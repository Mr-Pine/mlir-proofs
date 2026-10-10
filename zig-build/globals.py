#!/usr/bin/env python3
"""Name LLVM's anonymous globals (`@0`, `@1`, …) by their initializers.

    python3 globals.py <in.ll> <out.ll>
"""
import re, sys

NAMES = [
    (r'\[32 x i8\] c"\\ED\\D3\\F5', 'scalar.field_order_s'),
    (r'Fe \{ \[5 x i64\] \[i64 929955233495203,', 'Fe.edwards25519d'),
    (r'constant %src\.field\.Fe \{ \[5 x i64\] \[i64 1, i64 0,', 'Fe.one'),
    (r'Edwards25519 undef, i16 2,', 'Edwards25519.fromBytes.invalid'),
    (r'Edwards25519 undef, i16 4,', 'Edwards25519.mulDoubleBasePublic.weak'),
    (r'Fe \{ \[5 x i64\] \[i64 1718705420411056,', 'Fe.sqrtm1'),
    (r'constant %"src\.sha2\.Sha2x64', 'Sha512.iv'),
    (r'constant %src\.field\.Fe zeroinitializer', 'Fe.zero'),
    (r'constant %src\.edwards25519\.Edwards25519 \{ %src\.field\.Fe zeroinitializer, %src\.field\.Fe \{ \[5 x i64\] \[i64 1,',
     'Edwards25519.identityElement'),
    (r'Fe \{ \[5 x i64\] \[i64 1859910466990425,', 'Fe.edwards25519d2'),
]

t = open(sys.argv[1]).read()
names = {}
for m in re.finditer(r'^@(\d+) = (.*)$', t, re.M):
    hits = [n for p, n in NAMES if re.search(p, m.group(2))]
    assert len(hits) == 1, m.group(0)[:120]
    names[m.group(1)] = hits[0]
open(sys.argv[2], 'w').write(re.sub(r'@(\d+)\b', lambda m: '@' + names[m.group(1)], t))
