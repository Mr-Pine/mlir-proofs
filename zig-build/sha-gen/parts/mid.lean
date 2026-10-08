/-! ## The rounds' block -/

/-- A register read right after its write, whatever the proofs of its type: no cast to reduce,
which for a late register would walk `Γ`'s types. -/
theorem read_write_same (E : ⟪Γ⟫) (i : Fin Γ.n) (h h' : Γ.ty i = t) (v : ⟦t⟧) :
    (E.write ⟨i, h⟩ v).read (.val i h') = v := by
  subst h
  exact Env.read_write_dst E ⟨i, rfl⟩ v

attribute [local mlir_env 1100] read_write_same

/-- `bb5`'s instructions all run by position `2110`; `decide` would walk the list. -/
theorem bb5_done : 2110 ≥ Sha512_round.bb5.body.length := by decide +kernel

/-- Rounds `t0 … t0 + n - 1` on the working variables `v`, `Wf t` the schedule's word `t`. -/
def rounds (Wf : Nat → BitVec 64) (t0 n : Nat) (v : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  (List.range' t0 n).foldl (fun v t => Sha512.round v Sha512.K[t]! (Wf t)) v

theorem rounds_zero (Wf : Nat → BitVec 64) (t : Nat) (v : Vector (BitVec 64) 8) :
    rounds Wf t 0 v = v := rfl

theorem rounds_succ (Wf : Nat → BitVec 64) (t n : Nat) (v : Vector (BitVec 64) 8) :
    rounds Wf t (n + 1) v = rounds Wf (t + 1) n (Sha512.round v Sha512.K[t]! (Wf t)) := by
  simp only [rounds, List.range'_succ, List.foldl_cons]

theorem rounds_add (Wf : Nat → BitVec 64) (t m n : Nat) (v : Vector (BitVec 64) 8) :
    rounds Wf t (m + n) v = rounds Wf (t + m) n (rounds Wf t m v) := by
  simp only [rounds, ← List.range'_append_1, List.foldl_append]

