module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_f25519_pow22523
public import Firedancer.Common.Writable
public import Firedancer.Common.Counter
public import Boringssl.fe_sq_tt

namespace MLIR.Boringssl

/-! What `fe_pow22523` and `fe_loose_invert` share: their unrolled squaring loops (runs of
`fe_sq_tt(t, t)`) and their loop counters. -/

open Firedancer.Ref

@[expose] public section

/-- `n` in-place squarings, `fe_sq_tt(t, t)`. -/
def sqRun (t : Dst Γ .ptr) : Nat → List (Instr Γ)
  | 0 => []
  | n + 1 =>
    .call fe_sq_tt.call (.cons (.val t.i t.h) (.cons (.val t.i t.h) .nil)) .nil :: sqRun t n

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
              { S with
                mem :=
                  S.mem.storeLimbs T (fd_f25519_pow22523.sqrN (n + 1) (S.mem.readLimbs T)) } >>=
            g) =
          K →
        (blk.runBodyFrom E pos S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro E pos S hbody hR hwf hT hTw hK
    simp only [sqRun, List.cons_append, List.nil_append] at hbody
    step_call using fe_sq_tt.call_eq
    rw [hS]
    exact hK
  | succ n ih =>
    intro E pos S hbody hR hwf hT hTw hK
    simp only [sqRun, List.cons_append] at hbody
    step_call using fe_sq_tt.call_eq
    refine ih hbody hR hwf hT hTw ?_
    subst hS
    dsimp only
    rw [MemoryState.readLimbs_storeLimbs_self
        (MemoryState.limbsRoom_storeLimbs_iff.mp (hT.room hTw)),
      MemoryState.storeLimbs_storeLimbs_self, Nat.add_right_comm pos 1 (n + 1)]
    exact hK

end MLIR.Boringssl
