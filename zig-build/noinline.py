#!/usr/bin/env python3
"""Mark the functions `verify` is split into `noinline`, so LLVM keeps them as functions; Zig's
own code is unchanged.

    python3 noinline.py <in.ll> <out.ll>
"""
import re, sys

KEEP = re.compile(
    r'@"?(src\.ed25519\.Ed25519\.Verifier\.(init|verify|isIdentity)'
    r'|src\.edwards25519\.Edwards25519\.(mulDoubleBasePublic|precompute__anon_\d+)'
    r'|src\.sha2\.Sha2x64\([^"]*\)\.final'
    r'|src\.scalar\.(reduce64|mul8|rejectNonCanonical)'
    r'|src\.field\.Fe\.rejectNonCanonical__anon_\d+)"?\(')

out = []
for l in open(sys.argv[1]):
    if l.startswith('define') and KEEP.search(l):
        l = re.sub(r' (#\d+) \{$', r' noinline \1 {', l.rstrip('\n')) + '\n'
        assert 'noinline' in l, l[:120]
    out.append(l)
assert sum('noinline #' in l for l in out) == 10
open(sys.argv[2], 'w').writelines(out)
