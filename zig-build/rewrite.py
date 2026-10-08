#!/usr/bin/env python3
"""Rewrite a generic-form MLIR module (MLIR 20) into the form RIR's elaborator reads.

- `llvm.intr.assume(c)` is UB when `c` is false. It becomes a branch on
  `select c, true, poison`, which is UB exactly then, to a new block holding the rest of
  the block; a proof must show `c`.
- `llvm.intr.experimental.noalias.scope.decl` declares alias metadata and is dropped.
- `llvm.freeze(x)` becomes `x`: equal unless `x` is poison, which a proof then rules out.
- Call attributes MLIR 20 adds (tail call kind, memory effects, `no_unwind`,
  `will_return`) and alias scopes are dropped: hints, which RIR's parser does not read.
- Values are renumbered `%0, %1, …` and entry arguments `%arg0, %arg1, …` in each
  function; MLIR 20 numbers both across the module.

    python3 rewrite.py <in.mlir> <out.mlir>

With `--regions <dir>`, it instead turns each byte string constant in the extracted regions
into the `dense<[…]>` array RIR reads, and each `undef` byte array (a global's struct padding)
into zeros: a refinement, and the bytes the object file holds.
"""
import re, sys

ASSUME = re.compile(r'^(\s*)"llvm\.intr\.assume"\((%[\w.]+)\)')
FREEZE = re.compile(r'^\s*(%[\w.]+) = "llvm\.freeze"\((%[\w.]+)\)')
SCOPE = re.compile(r'^\s*"llvm\.intr\.experimental\.noalias\.scope\.decl"')
VALUE = re.compile(r'%[A-Za-z_0-9.]+')
HINTS = re.compile(r', (TailCallKind = #llvm\.tailcallkind<\w+>|memory_effects = #llvm\.memory_effects<[^>]*>'
                   r'|no_unwind|will_return|(noalias_scopes|alias_scopes) = \[[^]]*\])')

UNDEF_BYTES = re.compile(r'"llvm\.mlir\.undef"\(\) : \(\) -> !llvm\.array<(\d+) x i8>')
STRING = re.compile(r'value = "((?:[^"\\]|\\.)*)"(\}> : \(\) -> !llvm\.array<(\d+) x i8>)')

def dense(m):
    """`value = "…"` as `dense<[…]> : tensor<…>`, from MLIR's escapes (`\\XX`, `\\\\`)."""
    t, bs, i = m.group(1), [], 0
    while i < len(t):
        if t[i] == '\\' and t[i + 1] == '\\':
            bs.append(ord('\\')); i += 2
        elif t[i] == '\\':
            bs.append(int(t[i + 1:i + 3], 16)); i += 3
        else:
            bs.append(ord(t[i])); i += 1
    assert len(bs) == int(m.group(3))
    return f'value = dense<[{", ".join(map(str, bs))}]> : tensor<{len(bs)}xi8>' + m.group(2)

def rewrite(fn):
    """The intrinsics rewritten, in one function's lines."""
    out, subst, k = [], {}, 0
    for line in fn:
        line = VALUE.sub(lambda v: subst.get(v.group(0), v.group(0)), line)
        if SCOPE.match(line):
            continue
        line = HINTS.sub('', line).replace('<{TailCallKind = #llvm.tailcallkind<none>, ', '<{')
        m = FREEZE.match(line)
        if m:
            subst[m.group(1)] = m.group(2)
            continue
        m = ASSUME.match(line)
        if m:
            ind, c, n = m.group(1), m.group(2), f'assume{k}'
            k += 1
            out += [
                f'{ind}%{n}t = "llvm.mlir.constant"() <{{value = true}}> : () -> i1\n',
                f'{ind}%{n}p = "llvm.mlir.poison"() : () -> i1\n',
                f'{ind}%{n} = "llvm.select"({c}, %{n}t, %{n}p) '
                '<{fastmathFlags = #llvm.fastmath<none>}> : (i1, i1, i1) -> i1\n',
                f'{ind}"llvm.cond_br"(%{n})[^{n}, ^{n}] '
                '<{operandSegmentSizes = array<i32: 1, 0, 0>}> : (i1) -> ()\n',
                f'{ind[:-2]}^{n}:\n']
            continue
        out.append(line)
    return out

def renumber(fn):
    """Entry arguments and values numbered from 0, in order of definition."""
    names, args = {}, {}
    for line in fn:
        m = re.match(r'^\s*\^bb0\((.*)\):', line)
        if m and not args:
            for a in re.findall(r'%arg\d+', m.group(1)):
                args[a] = f'%arg{len(args)}'
            continue
        m = re.match(r'^\s*\^[\w.]+\((.*)\):', line)
        defs = re.findall(r'(%[\w.]+):', m.group(1)) if m else []
        m = re.match(r'^\s*((?:%[\w.]+(?:, )?)+) = ', line)
        if m:
            defs += VALUE.findall(m.group(1))
        for d in defs:
            names[d] = f'%{len(names)}'
    names.update(args)
    return [VALUE.sub(lambda v: names.get(v.group(0), v.group(0)), l) for l in fn]

if sys.argv[1] == '--regions':
    import glob
    for f in glob.glob(sys.argv[2] + '/*.mlir'):
        t = open(f).read()
        u = UNDEF_BYTES.sub(lambda m: f'"llvm.mlir.constant"() <{{value = dense<0> : tensor<{m.group(1)}xi8>}}> : () -> !llvm.array<{m.group(1)} x i8>', STRING.sub(dense, t))
        if u != t:
            open(f, 'w').write(u)
    sys.exit()

lines = open(sys.argv[1]).readlines()
out, fn = [], None
for line in lines:
    if '"llvm.func"' in line or '"llvm.mlir.global"' in line:
        if fn is not None:
            out += renumber(rewrite(fn))
        fn = []
    if fn is None:
        out.append(line)
    else:
        fn.append(line)
out += renumber(rewrite(fn))
open(sys.argv[2], 'w').writelines(out)
