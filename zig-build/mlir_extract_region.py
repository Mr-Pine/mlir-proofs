#!/usr/bin/env python3

"""Split a generic-form MLIR module into one file per function and global.

Each "llvm.func" and "llvm.mlir.global" operation is written out
verbatim, attribute dictionary and region included, to
<outdir>/<sym_name>.mlir, preceded by the module's attribute alias
definitions (#tbaa_tag1 = ..., #loop_annotation = ...) it refers to,
directly or through another alias.  Nothing is dropped or rewritten: a
function's parameter, result and memory attributes, and the alignment
and constness of a global, are part of what the IR means, so they travel
with the operation for lean-mlir to model or reject.

A function that names a global through "llvm.mlir.addressof" reports it,
so that its lift can bind the global the way it binds its callees.
Every global some written function names is written out too.  Only
globals named directly are collected; a callee's travel in the callee's
own file.

Binding a global to its initializer is sound only for a constant one.  A
mutable global's initializer says what it holds until the first store,
not what a region reads from it, so the extractor refuses any global
that is not constant rather than emit one that would mislead.  It checks
every global in the module, not just those a function names: the
globaldce in make-mlir has already dropped the unreachable ones, and a
mutable global named only by another global's initializer is no safer.

Declarations -- functions without a body -- are not written.
"""

import os
import re
import sys

FUNC_RE   = re.compile(r'^\s*"llvm\.func"\(\)')
GLOBAL_RE = re.compile(r'^\s*"llvm\.mlir\.global"\(\)')
NAME_RE   = re.compile(r'sym_name = "([^"]+)"')
END_RE    = re.compile(r'^\s*\}\)\s*:\s*\(\)\s*->\s*\(\)\s*$')
ALIAS_RE  = re.compile(r'^(#[A-Za-z0-9_$.-]+) = ')
ALIASREF_RE = re.compile(r'#[A-Za-z0-9_$.-]+')
SYMREF_RE = re.compile(r'@([A-Za-z0-9_.$]+)')
CONST_RE  = re.compile(r'[{ ]constant[,}]')


def split_module(text):
  """The module's aliases by name, and its operations as (kind, name, lines)."""
  aliases, ops = {}, []
  kind, name, lines = None, None, None
  for line in text.split("\n"):
    if kind is None:
      alias = ALIAS_RE.match(line)
      if alias: aliases[alias.group(1)] = line; continue
      if   GLOBAL_RE.match(line): kind = "global"
      elif FUNC_RE.match(line):   kind = "func"
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
      name, lines = match.group(1), [line]
      continue
    lines.append(line)
    if END_RE.match(line):
      ops.append((kind, name, lines))
      kind, name, lines = None, None, None
  if kind is not None:
    raise ValueError("unterminated operation %s" % name)
  return aliases, ops


def aliases_named(lines, aliases):
  """The aliases lines refer to, transitively, in module order."""
  seen, todo = set(), [m for l in lines for m in ALIASREF_RE.findall(l)]
  while todo:
    a = todo.pop()
    if a in seen or a not in aliases: continue
    seen.add(a)
    todo += ALIASREF_RE.findall(aliases[a].split(" = ", 1)[1])
  return [a for a in aliases if a in seen]


def dedent(lines):
  """The operation's lines with its own indentation removed."""
  pad = len(lines[0]) - len(lines[0].lstrip())
  return [l[pad:] if l[:pad].strip()=="" else l for l in lines]


def main(argv):
  if len(argv)!=3:
    sys.stderr.write("usage: %s <generic.mlir> <outdir>\n" % argv[0])
    return 2

  src, outdir = argv[1], argv[2]
  with open(src) as f: text = f.read()

  os.makedirs(outdir, exist_ok=True)

  aliases, ops = split_module(text)
  globals_ = {name: lines for kind, name, lines in ops if kind=="global"}

  def emit(name, lines, note=""):
    path = os.path.join(outdir, name+".mlir")
    with open(path, "w") as f:
      f.write("\n".join([aliases[a] for a in aliases_named(lines, aliases)]
                        + dedent(lines))+"\n")
    count = sum(1 for l in lines[1:-1] if " = \"" in l or l.strip().startswith('"'))
    print("%s (%d ops%s)" % (path, count, note))

  count, wanted = 0, []
  for kind, name, lines in ops:
    if kind!="func" or len(lines)<3: continue
    named = [g for g in globals_ if g in {m.group(1) for l in lines[1:]
                                           for m in SYMREF_RE.finditer(l)}]
    wanted += [g for g in named if g not in wanted]
    emit(name, lines, ", globals: "+" ".join(named) if named else "")
    count += 1

  for name in wanted:
    emit(name, globals_[name], ", global")

  if not count:
    sys.stderr.write("%s: no function bodies found\n" % src)
    return 1
  return 0


if __name__=="__main__":
  sys.exit(main(sys.argv))
