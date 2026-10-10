#!/usr/bin/env python3
"""Print a byte-array global's initializer as Lean chunks for Agave/Math/BaseTable.lean.

    table_nat.py <op file> <name>

The global's bytes, as one little-endian number, in 352-bit chunks (lowest first), one per
line: `def <name> : ℕ := ofChunks [ … ]`.
"""
import re
import sys


def load(path):
  s = re.search(r'value = "((?:[^"\\]|\\.)*)"', open(path).read()).group(1)
  b, i = bytearray(), 0
  while i < len(s):
    if s[i] == '\\' and s[i + 1] == '\\':
      b.append(92); i += 2
    elif s[i] == '\\':
      b.append(int(s[i + 1:i + 3], 16)); i += 3
    else:
      b.append(ord(s[i])); i += 1
  return bytes(b)


def main(path, name):
  n = int.from_bytes(load(path), 'little')
  chunks = []
  while n:
    chunks.append(n % 2 ** 352)
    n >>= 352
  body = ',\n'.join(f'    0x{c:x}' for c in chunks)
  print(f'def {name} : ℕ :=\n  ofChunks [\n{body}]')


if __name__ == '__main__':
  main(*sys.argv[1:])
