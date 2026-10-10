#!/usr/bin/env python3
"""Inventory of one variant's MLIR, as Markdown on stdout.

Usage: inventory.py <out/variant> <llvm-cxxfilt>

Reads <out/variant>/op/*.mlir (one function or global each) and
canonical.mlir (for declarations and module-level ops).  Lists the
functions by op count, the globals, every op name, every intrinsic,
the attributes seen on functions, calls and other ops, and every
inline asm, volatile, atomic and fence site.
"""
import collections
import os
import re
import subprocess
import sys

OP_RE = re.compile(r'^\s*(?:%[^=]+= )?"([a-z_]+\.[a-z_.0-9]+)"')
NAME_RE = re.compile(r'sym_name = "([^"]+)"')
CALLEE_RE = re.compile(r'callee = @([A-Za-z0-9_.$]+)')
INTRIN_RE = re.compile(r'intrin = "([^"]+)"')
# Attribute values not worth listing: they are per-site data.
SITE_KEYS = {'callee', 'value', 'sym_name', 'global_name', 'rawConstantIndices', 'mask',
             'case_values', 'case_operand_segments', 'operandSegmentSizes', 'elem_type',
             'alias_scopes', 'noalias_scopes', 'scope', 'tbaa', 'access_groups', 'position',
             'function_type', 'op_bundle_sizes', 'arg_attrs', 'res_attrs',
             'branch_weights', 'case_operands', 'loop_annotation', 'var_type', 'alignment'}


def braced(s, i, open_, close):
  """The text of s from the bracket at i to its match, inclusive."""
  depth, j, quote = 0, i, False
  while j < len(s):
    c = s[j]
    if c == '"' and s[j - 1] != '\\': quote = not quote
    elif not quote and c in open_: depth += 1
    elif not quote and c in close:
      depth -= 1
      if depth == 0: return s[i:j + 1]
    j += 1
  raise ValueError('unbalanced: ' + s[i:i + 80])


def split_top(s):
  """s split on commas outside brackets and strings."""
  out, depth, quote, cur = [], 0, False, ''
  for i, c in enumerate(s):
    if c == '"' and (i == 0 or s[i - 1] != '\\'): quote = not quote
    elif not quote and c in '<[{(': depth += 1
    elif not quote and c in '>]})': depth -= 1
    if c == ',' and depth == 0 and not quote:
      out.append(cur.strip()); cur = ''
    else: cur += c
  if cur.strip(): out.append(cur.strip())
  return out


def props(line):
  """The op's properties and discardable attributes as {key: value}."""
  out = {}
  # Properties <{...}>, then an optional attribute dict {...} before ':'.
  i = line.find('<{')
  rest = line
  if i >= 0:
    p = braced(line, i + 1, '{', '}')
    rest = line[i + 1 + len(p):]
    for kv in split_top(p[1:-1]):
      k, _, v = kv.partition(' = ')
      out[k.strip()] = v.strip() if v else 'unit'
  m = re.match(r'^\s*(\([^)]*\))?\s*\{', rest)
  if m and not rest.lstrip().startswith('({'):
    j = rest.find('{')
    p = braced(rest, j, '{', '}')
    for kv in split_top(p[1:-1]):
      k, _, v = kv.partition(' = ')
      out[k.strip()] = v.strip() if v else 'unit'
  return out


def sig(line):
  """The op's trailing type signature."""
  i = line.rfind(' : ')
  return line[i + 3:].strip() if i >= 0 else ''


def demangle(names, cxxfilt):
  if not names: return {}
  r = subprocess.run([cxxfilt], input='\n'.join(names), capture_output=True, text=True)
  return dict(zip(names, r.stdout.split('\n')))


def main(vdir, cxxfilt):
  funcs, globs = {}, {}
  for fn in sorted(os.listdir(os.path.join(vdir, 'op'))):
    lines = open(os.path.join(vdir, 'op', fn)).read().split('\n')
    lines = [l for l in lines if l.strip() and not l.startswith('#')]
    head = lines[0]
    name = NAME_RE.search(head).group(1)
    if head.startswith('"llvm.func"'): funcs[name] = lines
    else: globs[name] = lines
  module = open(os.path.join(vdir, 'canonical.mlir')).read().split('\n')
  decls = []
  for l, nxt in zip(module, module[1:]):
    if re.match(r'^\s*"llvm\.func"\(\)', l) and re.match(r'^\s*\}\) : \(\) -> \(\)', nxt):
      decls.append((NAME_RE.search(l).group(1), l.strip()))
  module_ops = collections.Counter()
  depth_ops = [l for l in module if re.match(r'^  "llvm\.', l) and not
               re.match(r'^  "llvm\.(func|mlir\.global)"', l)]
  for l in depth_ops: module_ops[l.strip()[:200]] += 1

  allnames = list(funcs) + list(globs) + [d for d, _ in decls]
  dm = demangle(allnames, cxxfilt)

  opnames = collections.Counter()
  op_attrs = collections.defaultdict(lambda: collections.defaultdict(collections.Counter))
  intr = collections.defaultdict(collections.Counter)
  calls = collections.Counter()
  callers = collections.defaultdict(collections.Counter)
  call_attrs = collections.defaultdict(collections.Counter)
  sites = collections.defaultdict(collections.Counter)
  func_attrs = collections.defaultdict(collections.Counter)
  rows, refs = [], collections.defaultdict(set)
  for name, lines in funcs.items():
    body = lines[1:-1]
    n = sum(1 for l in body if ' = "' in l or l.strip().startswith('"'))
    blocks = sum(1 for l in body if l.strip().startswith('^'))
    rows.append((n, blocks, name))
    for k, v in props(lines[0]).items():
      if k in ('sym_name', 'function_type'): continue
      if k in ('arg_attrs', 'res_attrs'):
        for a in re.findall(r'llvm\.[a-z_]+', v): func_attrs[k + ' ' + a][name] += 1
      elif k == 'passthrough':
        for a in split_top(v[1:-1]): func_attrs['passthrough ' + a][name] += 1
      else: func_attrs[k + ' = ' + v][name] += 1
    for l in body:
      m = OP_RE.match(l)
      if not m: continue
      op = m.group(1)
      opnames[op] += 1
      p = props(l)
      for g in re.findall(r'global_name = @([A-Za-z0-9_.$]+)', l): refs[g].add(name)
      if op == 'llvm.call':
        c = CALLEE_RE.search(l)
        calls[c.group(1) if c else '<indirect>'] += 1
        callers[c.group(1) if c else '<indirect>'][name] += 1
        for k, v in p.items():
          if k in ('callee', 'operandSegmentSizes', 'op_bundle_sizes'): continue
          if k in ('arg_attrs', 'res_attrs'):
            for a in sorted(set(re.findall(r'llvm\.[a-z_]+', v))): call_attrs[k + ' ' + a][name] += 1
          elif k in ('alias_scopes', 'noalias_scopes'): call_attrs[k][name] += 1
          else: call_attrs[k + ' = ' + v[:160]][name] += 1
      if op == 'llvm.call_intrinsic':
        intr[INTRIN_RE.search(l).group(1)][sig(l)] += 1
      if op.startswith('llvm.intr.'):
        intr[op][sig(l)] += 1
      for k, v in p.items():
        op_attrs[op][k][v if k not in SITE_KEYS else '…'] += 1
      if op == 'llvm.inline_asm': sites['inline_asm'][name] += 1
      if 'volatile_' in p: sites['volatile ' + op][name] += 1
      if p.get('isVolatile', 'false') != 'false': sites['volatile ' + op][name] += 1
      if p.get('ordering', '0 : i64') not in ('0 : i64',) and op != 'llvm.fence':
        sites['atomic ' + op + ' ordering ' + p['ordering']][name] += 1
      if op in ('llvm.atomicrmw', 'llvm.cmpxchg'): sites['atomic ' + op][name] += 1
      if op == 'llvm.fence':
        sites['fence ordering %s syncscope %s' % (p.get('ordering'), p.get('syncscope'))][name] += 1

  out = []
  w = out.append
  w('#### Functions (%d, %d ops in all)\n' % (len(rows), sum(r[0] for r in rows)))
  w('| ops | blocks | function | symbol |')
  w('|---:|---:|---|---|')
  for n, b, name in sorted(rows, reverse=True):
    w('| %d | %d | `%s` | `%s` |' % (n, b, dm.get(name, name).replace('|', '\\|'), name))
  w('\n#### External declarations\n')
  for d, l in decls:
    by = ', '.join('`%s` ×%d' % (dm.get(f, f), n) for f, n in callers[d].most_common())
    w('- `%s` (`%s`): %d calls%s' % (dm.get(d, d), d, calls.get(d, 0), ', from ' + by if by else ''))
  unwritten = [g for g in re.findall(r'^  "llvm\.mlir\.global"\(\) <\{[^\n]*?sym_name = "([^"]+)"',
                                     '\n'.join(module), re.M) if g not in globs]
  if unwritten:
    w('\nModule globals not in op/ (named only by another global\'s initializer): ' +
      ', '.join('`%s`' % g for g in unwritten))
  w('\n#### Globals (%d)\n' % len(globs))
  w('| global | type | attributes | read by |')
  w('|---|---|---|---|')
  for g, lines in globs.items():
    p = props(lines[0])
    ty = p.get('global_type', '?')
    attrs = ', '.join('%s = %s' % (k, v) if v != 'unit' else k for k, v in p.items()
                      if k not in ('global_type', 'sym_name', 'value'))
    users = ', '.join(sorted(dm.get(u, u).split('::')[-1] if u != 'agave_ed25519_verify' else u
                             for u in refs.get(g, ())))
    w('| `%s` | `%s` | %s | %s |' % (g, ty, attrs, users))
  w('\n#### Module-level ops\n')
  for l, n in module_ops.items(): w('- %d × `%s`' % (n, l))
  w('\n#### Op names (%d distinct)\n' % len(opnames))
  w(', '.join('`%s` %d' % (o, n) for o, n in opnames.most_common()))
  types = collections.Counter()
  for lines in funcs.values():
    for l in lines[1:-1]:
      if OP_RE.match(l):
        types.update(set(re.findall(r'vector<\d+xi\d+>|\bi\d+\b|!llvm\.ptr|!llvm\.struct<[^>]*>|!llvm\.array<[^>]*>', sig(l))))
  w('\n#### Types in op signatures (ops mentioning each)\n')
  w(', '.join('`%s` %d' % (t, n) for t, n in types.most_common()))
  w('\n#### Intrinsics (%d distinct)\n' % len(intr))
  for i in sorted(intr):
    w('- `%s`: %s' % (i, '; '.join('`%s` ×%d' % (s, n) for s, n in intr[i].most_common())))
  w('\n#### Function attributes (count of functions)\n')
  for k in sorted(func_attrs): w('- `%s`: %d' % (k, len(func_attrs[k])))
  w('\n#### Call attributes (call sites)\n')
  for k in sorted(call_attrs): w('- `%s`: %d' % (k, sum(call_attrs[k].values())))
  w('\n#### Op attributes (key: values ×count; … = per-site data)\n')
  for op in sorted(op_attrs):
    if op == 'llvm.call': continue
    parts = []
    for k in sorted(op_attrs[op]):
      vals = op_attrs[op][k]
      if len(vals) > 8: parts.append('`%s`: %d distinct' % (k, len(vals)))
      else: parts.append('`%s`: ' % k + ', '.join('`%s` ×%d' % (v[:80], n) for v, n in vals.most_common()))
    w('- `%s`: %s' % (op, '; '.join(parts) if parts else '(none)'))
  w('\n#### Inline asm, volatile, atomic, fence\n')
  if not sites: w('None.')
  for k in sorted(sites):
    w('- %s: %s' % (k, ', '.join('`%s` ×%d' % (dm.get(f, f), n) for f, n in sites[k].most_common())))
  print('\n'.join(out))


if __name__ == '__main__':
  main(*sys.argv[1:])
