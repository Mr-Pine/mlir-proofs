#!/bin/bash
# Assembles Boringssl/x25519_sc_reduce.lean from parts/ and gen2.py at the splits in splits.txt.
cd "$(dirname "$0")" && SP=$(cat splits.txt); python3 assemble2.py "$SP" 12 '  rw [BasicBlock.runBodyFrom_done (block := x25519_sc_reduce.entry) (pos := 587) (by decide +kernel)]\n  simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, reduceFuncContinue, Exit.run]\n  rw [hS]\n  subst hres\n  rw [← x25519_sc_reduce.ir_eq_spec]\n  keep_eqs\n  subst_vars\n  rfl'
