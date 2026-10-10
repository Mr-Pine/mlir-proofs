#!/bin/bash
# usage: imv.sh <marker-substring> : cut ScratchW3 at marker (sorry everything after, close all goals) and report
cd ~/mlir-proofs
python3 - "$1" <<'PY'
import sys
s=open('/home/david.intern/mlir-proofs/Boringssl/ScratchW3.lean').read()
i=s.index(sys.argv[1])
j=s.index("end Proof")
s=s[:i]+"  all_goals sorry\n\n"+s[j:]
open('/home/david.intern/mlir-proofs/Boringssl/ScratchW6.lean','w').write(s)
PY
timeout 290 lake env lean Boringssl/ScratchW6.lean > /tmp/prof6.txt 2>&1
grep -E "error" /tmp/prof6.txt | head -3
grep -E "elaborating proof|instantiateMVars" /tmp/prof6.txt | cut -c1-90
