#!/usr/bin/env python3
"""Check every registry package in a lock is pinned identically in Agave's lock."""
import re, sys
def pkgs(path):
    out = set()
    for p in open(path).read().split('[[package]]')[1:]:
        n = re.search(r'name = "([^"]+)"', p).group(1)
        v = re.search(r'version = "([^"]+)"', p).group(1)
        c = re.search(r'checksum = "([^"]+)"', p)
        if 'source = "registry' in p: out.add((n, v, c.group(1) if c else None))
    return out
ours, agave = pkgs(sys.argv[1]), pkgs(sys.argv[2])
bad = sorted(ours - agave)
for b in bad: print("not in Agave's lock:", *b[:2])
print("%d registry packages, %d mismatches" % (len(ours), len(bad)))
sys.exit(1 if bad else 0)
