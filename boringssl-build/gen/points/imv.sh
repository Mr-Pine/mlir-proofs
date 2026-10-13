#!/bin/bash
# usage: imv.sh <marker-substring> [scratch.lean] : cut the scratch file (default Boringssl/ScratchW3.lean)
# at marker (sorry everything after, close all goals), elaborate the cut in a temp dir and report
cd "$(dirname "$0")/../../.." || exit 1
tmp=$(mktemp -d) || exit 1
trap 'rm -rf "$tmp"' EXIT
python3 - "$1" "${2:-Boringssl/ScratchW3.lean}" "$tmp/ScratchW6.lean" <<'PY'
import sys
s=open(sys.argv[2]).read()
i=s.index(sys.argv[1])
j=s.index("end Proof")
s=s[:i]+"  all_goals sorry\n\n"+s[j:]
open(sys.argv[3],'w').write(s)
PY
timeout 290 lake env lean "$tmp/ScratchW6.lean" > "$tmp/prof6.txt" 2>&1
grep -E "error" "$tmp/prof6.txt" | head -3
grep -E "elaborating proof|instantiateMVars" "$tmp/prof6.txt" | cut -c1-90
