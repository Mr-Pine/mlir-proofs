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
into the `dense<[…]>` array RIR reads. In a global's initializer, each `undef` that is more than
an `insertvalue` chain's base (struct padding, an error union's unused payload) becomes zeros: a
refinement, and the bytes the object file holds.
"""
import re, sys

ASSUME = re.compile(r'^(\s*)"llvm\.intr\.assume"\((%[\w.]+)\)')
FREEZE = re.compile(r'^\s*(%[\w.]+) = "llvm\.freeze"\((%[\w.]+)\)')
SCOPE = re.compile(r'^\s*"llvm\.intr\.experimental\.noalias\.scope\.decl"')
VALUE = re.compile(r'%[A-Za-z_0-9.]+')
HINTS = re.compile(r', (TailCallKind = #llvm\.tailcallkind<\w+>|memory_effects = #llvm\.memory_effects<[^>]*>'
                   r'|no_unwind|will_return|(noalias_scopes|alias_scopes) = \[[^]]*\])')

UNDEF = re.compile(r'^(\s*)(%[\w.]+) = "llvm\.mlir\.undef"\(\) : \(\) -> (.*)$')

def parse_ty(s, i=0):
    """An LLVM type at `s[i:]`, without `!llvm.`: `('int', w)`, `('array', n, t)` or
    `('struct', name, members)`."""
    s = s.replace('!llvm.', '')
    if s.startswith('i', i):
        m = re.match(r'i(\d+)', s[i:])
        return ('int', int(m.group(1))), i + m.end()
    if s.startswith('array<', i):
        m = re.match(r'array<(\d+) x ', s[i:])
        t, j = parse_ty(s, i + m.end())
        return ('array', int(m.group(1)), t), j + 1
    assert s.startswith('struct<', i), s[i:]
    i += len('struct<')
    name = None
    if s[i] == '"':
        j = s.index('"', i + 1)
        name, i = s[i:j + 1], j + 3
    assert s[i] == '('
    i, ms = i + 1, []
    while s[i] != ')':
        t, i = parse_ty(s, i)
        ms.append(t)
        if s.startswith(', ', i):
            i += 2
    return ('struct', name, ms), i + 2

def show_ty(t, top=True):
    pre = '!llvm.' if top else ''
    if t[0] == 'int':
        return f'i{t[1]}'
    if t[0] == 'array':
        return f'{pre}array<{t[1]} x {show_ty(t[2], False)}>'
    ms = ', '.join(show_ty(m, False) for m in t[2])
    return f'{pre}struct<{t[1] + ", " if t[1] else ""}({ms})>'

def zero_of(ind, dst, t):
    """Lines defining `dst` as `t`'s zero: `llvm.mlir.zero` at integers and integer arrays,
    `insertvalue`s of zeros elsewhere."""
    if t[0] == 'int' or t[0] == 'array' and t[2][0] == 'int':
        return [f'{ind}{dst} = "llvm.mlir.zero"() : () -> {show_ty(t)}\n']
    ms = [t[2]] * t[1] if t[0] == 'array' else t[2]
    out, cur = [f'{ind}{dst}.u = "llvm.mlir.undef"() : () -> {show_ty(t)}\n'], f'{dst}.u'
    for k, m in enumerate(ms):
        out += zero_of(ind, f'{dst}.m{k}', m)
        nxt = dst if k == len(ms) - 1 else f'{dst}.i{k}'
        out.append(f'{ind}{nxt} = "llvm.insertvalue"({cur}, {dst}.m{k}) <{{position = array<i64: {k}>}}> '
                   f': ({show_ty(t)}, {show_ty(m)}) -> {show_ty(t)}\n')
        cur = nxt
    return out

def zero_undefs(lines):
    """A global's initializer with its `undef`s other than `insertvalue` bases as zeros."""
    out = []
    for l in lines:
        m = UNDEF.match(l.rstrip('\n'))
        x = m and re.escape(m.group(2))
        if m and not all(re.search(r'"llvm\.insertvalue"\(' + x + ',', u) for u in lines
                         if u is not l and re.search(x + r'(?![\w.])', u)):
            out += zero_of(m.group(1), m.group(2), parse_ty(m.group(3))[0])
        else:
            out.append(l)
    return renumber(out)
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
        line = re.sub(r'<\{(noalias_scopes|alias_scopes) = \[[^]]*\], ', '<{', line)
        line = re.sub(r'<\{(noalias_scopes|alias_scopes) = \[[^]]*\], ', '<{', line)
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
        u = STRING.sub(dense, t)
        if '^bb0' not in u:
            u = ''.join(zero_undefs(u.splitlines(keepends=True)))
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
