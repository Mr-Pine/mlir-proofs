module

public import MLIR.Run.Tactic
public import Boringssl.Common.Pow
public import Sodium.fe25519_sq

namespace MLIR.Sodium

/-! What `fe25519_pow22523` and `fe25519_invert` share: their unrolled squaring loops (runs of
`fe25519_sq(t, t)`). -/

@[expose] public section

/-- `n` in-place squarings, as a loop does them. -/
def sqrN : Nat → (Fin 5 → BitVec 64) → Fin 5 → BitVec 64
  | 0, x => x
  | n + 1, x => sqrN n (fe25519_sq.spec x)

/-- `n` in-place squarings, `fe25519_sq(t, t)`. -/
def sqRun (t : Dst Γ .ptr) : Nat → List (Instr Γ)
  | 0 => []
  | n + 1 =>
    .call fe25519_sq.call (.cons (.val t.i t.h) (.cons (.val t.i t.h) .nil)) .nil :: sqRun t n

end

attribute [local mlir_state] MemoryState.readLimbs_storeLimbs_self MemoryState.LimbsFit.storeLimbs

/-- Where the body at `pos` is `n + 1` squarings of the limbs at `t`'s `T`: running on from `pos`
gives `K` if it does from `pos + n + 1` with `sqrN (n + 1)` of them stored at `T`. -/
public theorem runBodyFrom_sqRun {blk : BasicBlock Γ tRets bp} {t : Dst Γ .ptr}
    {rest : List (Instr Γ)} {T : Pointer} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} :
    ∀ (n : Nat) {E : ⟪Γ⟫} {pos : Nat} {S : GlobalState},
      blk.body.drop pos = sqRun t (n + 1) ++ rest →
        E ⊨ [t := T] →
        S.WF →
        S.mem.LimbsFit T →
        Writable S.mem T →
        (blk.runBodyFrom E (pos + (n + 1))
              { S with mem := S.mem.storeLimbs T (sqrN (n + 1) (S.mem.readLimbs T)) } >>=
            g) =
          K →
        (blk.runBodyFrom E pos S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro E pos S hbody hR hwf hT hTw hK
    simp only [sqRun, List.cons_append, List.nil_append] at hbody
    step_call using fe25519_sq.call_eq
    rw [hS]
    exact hK
  | succ n ih =>
    intro E pos S hbody hR hwf hT hTw hK
    simp only [sqRun, List.cons_append] at hbody
    step_call using fe25519_sq.call_eq
    refine ih hbody hR hwf hT hTw ?_
    subst hS
    dsimp only
    rw [MemoryState.readLimbs_storeLimbs_self
      (MemoryState.limbsRoom_storeLimbs_iff.mp (hT.room hTw)),
      MemoryState.storeLimbs_storeLimbs_self, Nat.add_right_comm pos 1 (n + 1)]
    exact hK

end MLIR.Sodium
