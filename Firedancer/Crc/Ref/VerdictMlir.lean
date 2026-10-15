module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Verdict
public import Firedancer.Crc.Ref.Mlir.crc_adx_verdict
public import Firedancer.Common.Counter

/-!
# `crc_adx_verdict` refinement (MLIR lift ↔ spec)

The lifted `crc_adx_verdict` loop computes `Verdict.verdict` of the `n` `int` codes at `p`, read
from memory, leaving the state unchanged.
-/

namespace MLIR.Firedancer.Crc.Ref

open MLIR.Firedancer.Crc.Ref.Verdict

@[expose] public section

/-- The `cnt` codes at `p` from index `k`, as a list (`int` loads at `p + 4·index`). -/
def memCodes (m : MemoryState) (p : Pointer) (k : Nat) : Nat → List (BitVec 32)
  | 0 => []
  | cnt + 1 => m.readAt (p.add (BitVec.ofNat 64 (4 * k))) 32 :: memCodes m p (k + 1) cnt

end

section Proof

namespace crc_adx_verdict

/-- The `k`-th code is the matching bits of the whole array read. -/
theorem readAt_code (m : MemoryState) (p : Pointer) (n k : Nat) (hf : Fits m p (32 * n))
    (hk : k < n) (hlt : 4 * n < 2 ^ 63) (hoff : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (4 * n))) :
    m.readAt (p.add (BitVec.ofNat 64 (4 * k))) 32 =
      (m.readAt p (32 * n)).extractLsb' (k * 4 % 2 ^ 64 * 8) 32 := by
  have h4 : (BitVec.ofNat 64 (4 * k)).toNat = 4 * k := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
    (BitVec.not_uaddOverflow_of_le hoff (by
      rw [h4, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)) (by rw [h4]; omega) rfl,
    h4, Nat.mod_eq_of_lt (by omega)]
  congr 2; omega

/-- The loop from `^bb1` at counter `k`, accumulator `ok`, with `m + 1` codes left, reduces to
`Verdict.runFrom` of the remaining codes. -/
theorem loop (p : Pointer) (n : BitVec 64) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (s : GlobalState) (hfits : Fits s.mem p (32 * n.toNat))
    (hspan : 4 * n.toNat < 2 ^ 63)
    (hoff : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (4 * n.toNat))) :
    ∀ m k (ok : Bool) (E : ⟪Γ⟫),
      E.args = (args (.value p) (.value n)).get →
      (E ⊨ [%1 := 0#32, %3 := 1#64, %4 := BitVec.ofInt 32 (-3), %6 := BitVec.ofNat 64 k, %7 := if ok then 1#32 else 0#32]) →
      k + m + 1 = n.toNat →
      (crc_adx_verdict.runFrom E ^bb1 s >>= g) =
        (g (.cons (.value (Verdict.runFrom ok (memCodes s.mem p k (m + 1)))) .nil, s)) := by
  have hn4 : (BitVec.ofNat 64 (4 * n.toNat)).toNat = 4 * n.toNat := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have hbvsucc : ∀ k : Nat, k + 1 ≤ n.toNat →
      (BitVec.ofNat 64 k + 1#64) = BitVec.ofNat 64 (k + 1) := by
    intro k hk
    rw [BitVec.toNat_eq, BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat,
      BitVec.toNat_ofNat]
    have := n.isLt; omega
  have hsucc : ∀ k : Nat, k + 1 ≤ n.toNat →
      ((BitVec.ofNat 64 k + 1#64 = n) ↔ k + 1 = n.toNat) := by
    intro k hk
    rw [hbvsucc k hk, BitVec.toNat_eq, BitVec.toNat_ofNat]
    have := n.isLt; omega
  intro m
  induction m with
  | zero =>
    intro k ok E hArgs hE hk
    have hnlt : n.toNat < 2 ^ 64 := n.isLt
    have hk4 : (BitVec.ofNat 64 (4 * k)).toNat = 4 * k := by
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    have hfk : Fits s.mem (p.add (BitVec.ofNat 64 (4 * k))) 32 :=
      Fits.add_of_le (BitVec.not_uaddOverflow_of_le hoff (by rw [hk4, hn4]; omega))
        (by rw [hk4]; omega) hfits
    block_init
    step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), show k * 4 = 4 * k by omega,
      show 4 * k < 2 ^ 63 by omega]
    step_load with code
    have hrd : S.mem.readAt (p.add (BitVec.ofNat 64 (4 * k))) 32 = code := by
      subst hS
      rw [hcode]
      exact readAt_code _ p n.toNat k hfits (by omega) hspan hoff
    finish_block
    · -- codes[k] = SUCCESS: `^bb3` with `ok`, then exit via `^bb4`, `^bb5`
      block_init
      step_pure [uaddOverflow_one64 (i := k) (by omega)]
      step_pure
      finish_block
      · block_init
        step_pure
        step_pure
        finish_block
        block_init
        finish_block
        subst hS
        simp only [memCodes, Verdict.runFrom, Verdict.SUCCESS, Verdict.ERR_MSG, hrd]
        cases ok <;> simp_all
      · exact absurd ((hsucc k (by omega)).mpr (by omega)) hbr
    · -- codes[k] = ERR_MSG: `^bb2` → `^bb3` with `ok := false`, then exit
      block_init
      finish_block
      block_init
      step_pure [uaddOverflow_one64 (i := k) (by omega)]
      step_pure
      finish_block
      · block_init
        step_pure
        step_pure
        finish_block
        block_init
        finish_block
        subst hS
        simp only [memCodes, Verdict.runFrom, Verdict.SUCCESS, Verdict.ERR_MSG]
        simp_all
      · exact absurd ((hsucc k (by omega)).mpr (by omega)) hbr
    · -- codes[k] other: `^bb5` returns the code
      block_init
      finish_block
      subst hS
      simp only [memCodes, Verdict.runFrom, Verdict.SUCCESS, Verdict.ERR_MSG, hrd]
      simp_all
  | succ m ih =>
    intro k ok E hArgs hE hk
    have hnlt : n.toNat < 2 ^ 64 := n.isLt
    have hk4 : (BitVec.ofNat 64 (4 * k)).toNat = 4 * k := by
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    have hfk : Fits s.mem (p.add (BitVec.ofNat 64 (4 * k))) 32 :=
      Fits.add_of_le (BitVec.not_uaddOverflow_of_le hoff (by rw [hk4, hn4]; omega))
        (by rw [hk4]; omega) hfits
    block_init
    step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), show k * 4 = 4 * k by omega,
      show 4 * k < 2 ^ 63 by omega]
    step_load with code
    have hrd : S.mem.readAt (p.add (BitVec.ofNat 64 (4 * k))) 32 = code := by
      subst hS
      rw [hcode]
      exact readAt_code _ p n.toNat k hfits (by omega) hspan hoff
    finish_block
    · -- codes[k] = SUCCESS: `^bb3` with `ok`, then back to `^bb1`
      block_init
      step_pure [uaddOverflow_one64 (i := k) (by omega)]
      step_pure
      finish_block
      · exfalso; have := (hsucc k (by omega)).mp hbr; omega
      · subst hS
        refine (ih (k + 1) ok E hArgs ?_ (by omega)).trans ?_
        · refine ⟨?_, ?_⟩ <;> env_reads
          rw [hbvsucc k (by omega)]
        · simp only [memCodes, Verdict.runFrom, Verdict.SUCCESS, Verdict.ERR_MSG, hrd]
          simp_all
    · -- codes[k] = ERR_MSG: `^bb2` → `^bb3` with `ok := false`, then back to `^bb1`
      block_init
      finish_block
      block_init
      step_pure [uaddOverflow_one64 (i := k) (by omega)]
      step_pure
      finish_block
      · exfalso; have := (hsucc k (by omega)).mp hbr; omega
      · subst hS
        refine (ih (k + 1) false E hArgs ?_ (by omega)).trans ?_
        · refine ⟨?_, ?_⟩ <;> env_reads
          rw [hbvsucc k (by omega)]
        · simp only [memCodes, Verdict.runFrom, Verdict.SUCCESS, Verdict.ERR_MSG, hrd]
          simp_all
    · -- codes[k] other: `^bb5` returns the code
      block_init
      finish_block
      subst hS
      simp only [memCodes, Verdict.runFrom, Verdict.SUCCESS, Verdict.ERR_MSG, hrd]
      simp_all

end crc_adx_verdict

/-- `crc_adx_verdict` returns `Verdict.verdict` of the `n` `int` codes at `p`, leaving the state
unchanged, when the code array fits without its offsets wrapping. -/
public theorem crc_adx_verdict.call_eq (p : Pointer) (n : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hfits : Fits s.mem p (32 * n.toNat)) (hspan : 4 * n.toNat < 2 ^ 63)
    (hoff : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (4 * n.toNat))) :
    crc_adx_verdict.call (crc_adx_verdict.args (.value p) (.value n)) s =
      .value (.cons (.value (Verdict.verdict (memCodes s.mem p 0 n.toNat))) .nil, s) := by
  func_init
  block_init
  iterate 6 step_pure
  finish_block
  · -- n = 0: `^bb5` returns SUCCESS
    block_init
    finish_block
    subst hS
    have h0 : n.toNat = 0 := by rw [BitVec.toNat_eq] at hbr; simpa using hbr
    rw [h0]
    simp only [memCodes, Verdict.verdict, Verdict.runFrom, Verdict.SUCCESS]
    rfl
  · -- n ≠ 0: run the loop from k = 0, ok = 1
    obtain ⟨m, hm⟩ : ∃ m, 0 + m + 1 = n.toNat := by
      refine ⟨n.toNat - 1, ?_⟩
      have : n.toNat ≠ 0 := by
        intro h; exact hbr (by rw [BitVec.toNat_eq]; simpa using h)
      omega
    subst hS
    have h := crc_adx_verdict.loop p n (g := fun r => .value r) (s := S) hfits hspan hoff m 0 true E
      hArgs (by refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> env_reads) hm
    rw [show n.toNat = m + 1 by omega]
    exact (bind_pure _).symm.trans h

end Proof

end MLIR.Firedancer.Crc.Ref
