#!/usr/bin/env python3
"""Summarize a generic-form LLVM-dialect MLIR module: functions by op
count, globals by size, op names, intrinsics, attributes, and anything a
lift must model or axiomatize (declarations, inline asm, volatile,
atomics).  Usage: analyze.py <module.mlir>"""

import re, sys
from collections import Counter, defaultdict

OP_RE = re.compile(r'^\s*(?:%[\w#:]+(?:, %[\w#:]+)* = )?"([\w.]+)"')

def props(line):
  """The top-level entries of an op's <{...}> property dict, as {key: value}."""
  i = line.find('<{')
  if i < 0: return {}
  depth, j, start, out = 0, i, i+2, []
  while j < len(line):
    c = line[j]
    if c in '<{[(': depth += 1
    elif c in '>}])':
      depth -= 1
      if depth == 0: out.append(line[start:j]); break
    elif c == ',' and depth == 2: out.append(line[start:j]); start = j+1
    elif c == '"':
      j += 1
      while line[j] != '"': j += 2 if line[j] == '\\' else 1
    j += 1
  d = {}
  for e in out:
    e = e.strip()
    if not e: continue
    if e.endswith('}') and e.count('{') < e.count('}'): e = e[:-1]
    k, _, v = e.partition(' = ')
    d[k] = v
  return d

def split_top(s):
  depth, start, out, j = 0, 0, [], 0
  while j < len(s):
    c = s[j]
    if c in '<{[(': depth += 1
    elif c in '>}])': depth -= 1
    elif c == ',' and depth == 0: out.append(s[start:j].strip()); start = j+1
    elif c == '"':
      j += 1
      while s[j] != '"': j += 1
    j += 1
  if s[start:].strip(): out.append(s[start:].strip())
  return out

def size_align(t, structs):
  t = t.strip()
  m = re.fullmatch(r'i(\d+)', t)
  if m:
    b = (int(m.group(1)) + 7) // 8
    a = 1 if b <= 1 else 2 if b <= 2 else 4 if b <= 4 else 8 if b <= 8 else 16
    return ((b + a - 1) // a * a, a)
  if t in ('f32',): return (4, 4)
  if t in ('f64',): return (8, 8)
  if t.startswith('!llvm.ptr'): return (8, 8)
  if t.startswith('array<') or t.startswith('struct<'): t = '!llvm.' + t
  m = re.fullmatch(r'!llvm\.array<(\d+) x (.*)>', t)
  if m:
    s, a = size_align(m.group(2), structs); return (int(m.group(1)) * s, a)
  m = re.fullmatch(r'vector<(\d+)x(.*)>', t)
  if m:
    s, _ = size_align(m.group(2), structs); n = int(m.group(1)) * s; return (n, n)
  m = re.fullmatch(r'!llvm\.struct<(packed )?(?:"[^"]*", )?(packed )?\((.*)\)>', t)
  if m:
    packed = bool(m.group(1) or m.group(2)); off, al = 0, 1
    for f in split_top(m.group(3)):
      s, a = size_align(f, structs)
      if packed: a = 1
      off = (off + a - 1) // a * a + s; al = max(al, a)
    return ((off + al - 1) // al * al, al)
  m = re.fullmatch(r'!llvm\.struct<"([^"]*)">', t)
  if m and m.group(1) in structs: return size_align(structs[m.group(1)], structs)
  raise ValueError("size of " + t)

def main(path):
  text = open(path).read().split('\n')
  funcs, globals_, cur = {}, {}, None
  structs = {}
  for l in text:
    for m in re.finditer(r'!llvm\.struct<"([^"]+)", (?:packed )?\(', l):
      pass
    if re.match(r'^  "llvm\.func"\(\)', l):
      p = props(l); name = p['sym_name'].strip('"')
      cur = funcs[name] = dict(props=p, ops=[], body=False)
      continue
    if re.match(r'^  "llvm\.mlir\.global"\(\)', l):
      p = props(l); name = p['sym_name'].strip('"')
      cur = globals_[name] = dict(props=p, ops=[], body=False)
      continue
    if re.match(r'^  \}\) : \(\) -> \(\)$', l): cur = None; continue
    if cur is None: continue
    m = OP_RE.match(l)
    if m:
      cur['body'] = True
      cur['ops'].append((m.group(1), props(l), l))

  defined = {n for n, f in funcs.items() if f['body']}
  decls = {n for n, f in funcs.items() if not f['body']}

  print("## Functions (%d defined, by op count)\n" % len(defined))
  rows = sorted(defined, key=lambda n: -len(funcs[n]['ops']))
  total = 0
  for n in rows:
    f = funcs[n]; total += len(f['ops'])
    nb = sum(1 for o in f['ops'] if o[0] in ('llvm.br', 'llvm.cond_br', 'llvm.switch', 'llvm.return', 'llvm.unreachable'))
    print("- `%s` %d ops (%d blocks), %s %s" % (n, len(f['ops']), nb,
          f['props'].get('linkage', '').replace('#llvm.linkage<', '').rstrip('>'),
          f['props'].get('CConv', '').replace('#llvm.cconv<', '').rstrip('>')))
  print("\nTotal: %d ops\n" % total)

  print("## Globals\n")
  for n, g in globals_.items():
    p = g['props']; t = p.get('global_type', '?').rsplit(' : ', 1)
    gt = p.get('global_type', '?')
    try: sz = "%d bytes" % size_align(gt, structs)[0]
    except Exception as e: sz = "size ?"
    print("- `%s` %s, %s, %s, align %s" % (n, gt, sz,
          'constant' if 'constant' in p else 'MUTABLE',
          p.get('alignment', '-').split(' :')[0]))
  print()

  print("## Declarations (external, no body) and their callers\n")
  callers = defaultdict(set)
  for n in defined:
    for op, p, l in funcs[n]['ops']:
      if op == 'llvm.call' and 'callee' in p:
        c = p['callee'].lstrip('@')
        if c in decls: callers[c].add(n)
  for d in sorted(decls):
    p = funcs[d]['props']
    ex = {k: v for k, v in p.items() if k in ('memory_effects', 'no_unwind', 'arg_attrs', 'res_attrs', 'will_return')}
    print("- `%s` %s; attrs %s; called from %s" % (d, p.get('function_type'), ex or '{}',
          ', '.join('`%s`' % c for c in sorted(callers[d])) or 'nowhere'))
  print()

  ops = Counter(); opattrs = defaultdict(Counter)
  for n in defined:
    for op, p, l in funcs[n]['ops']:
      ops[op] += 1
      for k, v in p.items():
        if k in ('callee', 'value', 'rawConstantIndices', 'elem_type', 'operandSegmentSizes',
                 'op_bundle_sizes', 'predicate', 'position', 'global_name', 'intrin', 'elem_type'):
          if k == 'predicate':
            opattrs[op]['predicate=' + ['eq','ne','slt','sle','sgt','sge','ult','ule','ugt','uge'][int(v.split(' :')[0])]] += 1
          continue
        if k == 'overflowFlags':
          opattrs[op]['overflow=' + ['none','nsw','nuw','nsw|nuw'][int(v.split(' :')[0])]] += 1
        elif k == 'noWrapFlags':
          f = int(v.split(' :')[0]); opattrs[op]['gep=' + ('|'.join(n for b, n in ((3, 'inbounds'), (2, 'nusw'), (4, 'nuw')) if f & b == b and not (b == 2 and f & 3 == 3)) or 'none')] += 1
        elif k == 'memory_effects':
          opattrs[op]['memory_effects=' + re.sub(r', (inaccessibleMem|errnoMem|targetMem0|targetMem1) = none', '', v)] += 1
        elif k == 'ordering' and v.split(' :')[0] == '0': continue
        elif k in ('overflowFlags', 'CConv', 'TailCallKind', 'fastmathFlags', 'ordering', 'alignment',
                 'isExact', 'nonNeg', 'isDisjoint', 'inbounds', 'noWrapFlags', 'isVolatile', 'volatile_'):
          opattrs[op]['%s=%s' % (k, v.split(' :')[0]) if v else k] += 1
        else:
          opattrs[op][k] += 1
  print("## Op names (in defined functions)\n")
  for op, c in ops.most_common():
    a = ', '.join('%s (%d)' % kv for kv in sorted(opattrs[op].items()))
    print("- `%s` x%d%s" % (op, c, ('; attrs: ' + a) if a else ''))
  print()

  print("## Value types (in defined functions)\n")
  ty = Counter()
  for n in defined:
    for op, p, l in funcs[n]['ops']:
      for t in set(re.findall(r'\bvector<[^>]*>|\bi\d+\b', l.rsplit(' : ', 1)[-1] if ' : (' in l else '')): ty[t] += 1
  print(', '.join('`%s` (%d ops)' % kv for kv in sorted(ty.items(), key=lambda kv: (kv[0].startswith('vector'), kv[0]))))
  print()

  print("## Intrinsics\n")
  intr = Counter()
  for n in defined:
    for op, p, l in funcs[n]['ops']:
      if op.startswith('llvm.intr.'): intr[op] += 1
      if op == 'llvm.call_intrinsic': intr['call_intrinsic ' + p.get('intrin', '?')] += 1
  for k, c in intr.most_common(): print("- `%s` x%d" % (k, c))
  print()

  print("## Function attributes (defined functions)\n")
  fattrs = Counter(); passthrough = Counter(); argattrs = Counter()
  for n in defined:
    p = funcs[n]['props']
    for k, v in p.items():
      if k in ('sym_name', 'function_type', 'passthrough', 'arg_attrs', 'res_attrs'): continue
      fattrs['%s = %s' % (k, v) if k in ('memory_effects', 'linkage', 'CConv', 'unnamed_addr',
             'visibility_', 'target_cpu', 'tune_cpu', 'target_features', 'uwtable_kind', 'frame_pointer') else k] += 1
    for e in split_top(p.get('passthrough', '[]')[1:-1]): passthrough[e] += 1
    for k in ('arg_attrs', 'res_attrs'):
      for a in re.findall(r'llvm\.[\w]+(?: = [^,}]+)?', p.get(k, '')):
        argattrs[k + ': ' + re.sub(r'#llvm.constant_range<.*', 'range', a)] += 1
  for k, c in sorted(fattrs.items()): print("- `%s` x%d" % (k, c))
  print("\npassthrough:\n")
  for k, c in sorted(passthrough.items()): print("- `%s` x%d" % (k, c))
  print("\nargument/result attributes:\n")
  for k, c in sorted(argattrs.items()): print("- `%s` x%d" % (k, c))
  print()

  print("## Hazards\n")
  hz = defaultdict(list)
  for n in defined:
    for op, p, l in funcs[n]['ops']:
      if op == 'llvm.inline_asm': hz['inline asm'].append(n)
      if 'volatile_' in p or 'isVolatile = true' in l: hz['volatile'].append(n)
      if op in ('llvm.atomicrmw', 'llvm.cmpxchg', 'llvm.fence') or p.get('ordering', '0 : i64').split(' :')[0] != '0':
        hz['atomic'].append(n)
      if op == 'llvm.call' and 'callee' not in p: hz['indirect call'].append(n)
  for k in ('inline asm', 'volatile', 'atomic', 'indirect call'):
    v = sorted(set(hz[k]))
    print("- %s: %s" % (k, ', '.join('`%s`' % x for x in v) if v else 'none'))

if __name__ == '__main__': main(sys.argv[1])
