#!/usr/bin/env python3

"""Split a generic-form MLIR module into one bare region per function.

lean-mlir's Com.parseFromFile and its [llvm()| ... ] quotation both
expect a bare region -- an `{ ^bb0(...): ... }` block -- rather than a
module containing llvm.func operations.  mlir-opt --mlir-print-op-generic
emits the region we want, but wrapped in a "llvm.func"() <{...}> ({ ... })
: () -> () operation whose attribute dictionary carries target-cpu,
target-features and similar noise that lean-mlir has no use for.

This script pulls each function's region out of that wrapper and writes
it to <outdir>/<sym_name>.mlir.

A region that reads a global -- fd_f25519_sqrt_ratio takes the address of
fd_f25519_sqrtm1 to pass it to fd_f25519_mul -- names it with an
"llvm.mlir.addressof" whose global_name refers to an "llvm.mlir.global"
at module scope, which a bare region leaves behind.  Every global that
some emitted region names is therefore written out too, as
<outdir>/<sym_name>.mlir, and each region reports the globals it names so
that its lift can bind them the way it binds its callees.

Binding a global to its initializer is sound only for a constant one.  A
mutable global's initializer says what it holds until the first store,
not what a region reads from it, so the extractor refuses any global
that is not constant rather than emit a region that would mislead.  It
checks every global in the module, not just those a region names: the
globaldce in make-mlir has already dropped the unreachable ones, and a
mutable global named only by another global's initializer is no safer.

A global goes to its own file rather than into the regions that name it
because the "llvm.mlir.global" wrapper carries the initializer as a
nested region, and lean-mlir's [mlir_region| ... ] parses no operation
with a region in generic form (it spells a region argument `${...}`, and
on `({` reports `unexpected token '('; expected ':'`).  What it does
parse is a bare region -- which is exactly what the initializer is, once
unwrapped: a single entry block of constant/undef/insertvalue ending in
an "llvm.return" of the global's value.  Unwrapping also drops the
linkage and visibility attributes, which say how a linker should treat
the symbol and mean nothing to a proof.

An array of scalars -- fd_sha512_core_ref's K table of round constants --
takes the other of the two forms mlir-translate gives a global: instead
of an initializer region it carries the whole array in a "value"
attribute on the wrapper, leaving the region empty.  Unwrapping that one
would produce an empty region, so it is instead rebuilt into the region
the other form already has, a constant of the global's type followed by
an "llvm.return" of it, and the two forms reach lean-mlir alike.

Only globals named directly are collected.  A callee's globals travel in
the callee's own file, which is linked in at its call.
"""

import os
import re
import sys

FUNC_RE   = re.compile(r'"llvm\.func"\(\)')
GLOBAL_RE = re.compile(r'"llvm\.mlir\.global"\(\)')
NAME_RE   = re.compile(r'sym_name = "([^"]+)"')
END_RE    = re.compile(r'^\s*\}\)\s*:\s*\(\)\s*->\s*\(\)\s*$')
SYMREF_RE = re.compile(r'@([A-Za-z0-9_.$]+)')
CONST_RE  = re.compile(r'[{ ]constant[,}]')

# Target intrinsics reach us as calls to a dotted symbol, because no
# released MLIR imports them as operations (see make-mlir in
# config/everything.mk).  Fold the call back into an operation named for
# the intrinsic, dropping the calling convention and fastmath attributes
# that belong to the call rather than to the intrinsic.
INTR_RE = re.compile(
    r'"llvm\.call"\((?P<args>[^)]*)\)'
    r'\s*<\{[^}]*callee = @(?P<callee>x86vector\.[A-Za-z0-9_.]+)[^}]*\}>'
    r'\s*:\s*(?P<sig>.*)$')


def fold_intrinsic_calls(line):
  """Rewrite a call to an unmodelled target intrinsic into an operation."""
  match = INTR_RE.search(line)
  if match is None: return line
  op = '"%s"(%s) : %s' % (match.group("callee"), match.group("args"), match.group("sig"))
  return line[:match.start()]+op


OPEN, CLOSE = "<[({", ">])}"


def attr(line, key):
  """The value of attribute key in an operation's attribute dictionary.

  Read by scanning to the comma that closes it rather than by regex,
  since a value nests the same brackets that delimit it -- K's is a
  dense<[...]> : tensor<80xi64>, whose own > would end any lazy match."""
  start = line.find(key+" = ")
  if start<0: return None
  start += len(key)+3
  depth = 0
  for i in range(start, len(line)):
    c = line[i]
    if   c in OPEN:  depth += 1
    elif c in CLOSE:
      # The dictionary's own }> closes around us at depth 0.
      if depth==0: return line[start:i].rstrip()
      depth -= 1
    elif c=="," and depth==0: return line[start:i]
  return line[start:].rstrip()


def value_region(name, line):
  """Rebuild the initializer region of a global that has none.

  The result is the region the initializer-region form already emits for
  a constant array: the value, then an "llvm.return" of it."""
  value, type_ = attr(line, "value"), attr(line, "global_type")
  if value is None or type_ is None:
    raise ValueError("global %s has neither an initializer region nor a "
                     "value and global_type to rebuild one from" % name)
  return ['    %%0 = "llvm.mlir.constant"() <{value = %s}> : () -> %s' % (value, type_),
          '    "llvm.return"(%%0) : (%s) -> ()' % type_]


def split_module(text):
  """Return the module's globals by name, and its (name, region) functions.

  Either way it is the wrapper's region that is kept -- a function's body,
  a global's initializer -- since that is what gets written out; the
  wrapper itself holds only attributes a proof has no use for, save the
  value of a global whose initializer region is empty."""
  globals_, funcs = {}, []
  kind, name, head, body = None, None, None, None
  for line in text.split("\n"):
    if kind is None:
      if   GLOBAL_RE.search(line): kind = "global"
      elif FUNC_RE.search(line):   kind = "func"
      else: continue
      match = NAME_RE.search(line)
      if match is None:
        raise ValueError("llvm.%s without a sym_name attribute"
                         % ("mlir.global" if kind=="global" else "func"))
      # constant is a unit attribute: present or absent, never assigned.
      if kind=="global" and CONST_RE.search(line) is None:
        raise ValueError("global %s is not constant, so its initializer "
                         "need not be what a region reads from it"
                         % match.group(1))
      name, head, body = match.group(1), line, []
      continue
    if END_RE.match(line):
      # A global with no initializer region carries its value on the
      # wrapper instead, so the wrapper is kept to rebuild one from.
      if kind=="global":
        globals_[name] = body if any(l.strip() for l in body) \
                              else value_region(name, head)
      else: funcs.append((name, body))
      kind, name, head, body = None, None, None, None
      continue
    body.append(line if kind=="global" else fold_intrinsic_calls(line))
  if kind is not None:
    raise ValueError("unterminated region for %s" % name)
  return globals_, funcs


def globals_named(body, globals_):
  """The globals body refers to, in module order, so that what a region
  reports does not depend on the order its uses happen to appear in."""
  named = {m.group(1) for line in body for m in SYMREF_RE.finditer(line)}
  return [name for name in globals_ if name in named]


def main(argv):
  if len(argv)!=3:
    sys.stderr.write("usage: %s <generic.mlir> <outdir>\n" % argv[0])
    return 2

  src, outdir = argv[1], argv[2]
  with open(src) as f: text = f.read()

  os.makedirs(outdir, exist_ok=True)

  globals_, funcs = split_module(text)

  def emit(name, body, note=""):
    path = os.path.join(outdir, name+".mlir")
    with open(path, "w") as f:
      f.write("{\n"+"\n".join(body)+"\n}\n")
    ops = sum(1 for l in body if " = \"" in l or l.strip().startswith('"'))
    print("%s (%d ops%s)" % (path, ops, note))

  count, wanted = 0, []
  for name, body in funcs:
    # Declarations have an empty region; there is nothing to lift.
    if not any(line.strip() for line in body): continue
    named = globals_named(body, globals_)
    wanted += [g for g in named if g not in wanted]
    emit(name, body, ", globals: "+" ".join(named) if named else "")
    count += 1

  # A global's initializer, unwrapped, is already a bare region.
  for name in wanted:
    emit(name, globals_[name], ", global")

  if not count:
    sys.stderr.write("%s: no function regions found\n" % src)
    return 1
  return 0


if __name__=="__main__":
  sys.exit(main(sys.argv))
