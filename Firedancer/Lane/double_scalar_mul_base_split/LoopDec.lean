module

public import MLIR.Run.Tactic
public import Firedancer.Lane.double_scalar_mul_base_split.Dec

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

@[expose] public section

namespace double_scalar_mul_base_split

open _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split
open Split
open _root_.MLIR.Firedancer.Avx512.fd_ed25519_double_scalar_mul_base (addDigit)

/-- The lift's runs from a block. -/
local notation "runD" => _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.runFrom

/-- Register `k` of the lift. -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.hty $k)

/-- The lift's globals. -/
local notation "Gl" => _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.globals

/-- `^bb25` with `dec`: `n2slide[32j+i] = d2`'s add on `r` (`R` over the state `D` in memory) and
`t` (`T` in registers), then its decode step: on to `^bb37` with their `addDigit` and
`decAt d2 D`. -/
theorem half2D (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA : Nat → Quad) (TB : Nat → Nat → Quad) (M : MemoryState)
    (hM0 : Base M r n1s n2s bt ta btp w1 w2 TA TB) (hs : DecSep dec r n1s n2s bt ta tp btp)
    (hdr : M.DecRoom dec) (hgM : M.Globals Gl) (D : DecSt) (hOk : D.Ok)
    (i j : Nat) (hj : j < 8) (R T : Quad) (d2 : Int)
    (hd2 : Ref.fd_curve25519_scalar_wnaf.Digit 255 d2)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : LiveD r n1s n2s bt tp dec i E)
    (hR :
      E ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := BitVec.ofInt 16 d2, %%1343 := T.P25,
        %%1344 := T.P14, %%1345 := T.P03])
    (hwf : S.WF) (hM : S.mem = (M.storeDec dec D).storeQuad r R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          LiveD r n1s n2s bt tp dec i E' →
          (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%2192 := (addDigit (TB j) d2 R T).2.P25,
            %%2193 := (addDigit (TB j) d2 R T).2.P14,
            %%2194 := (addDigit (TB j) d2 R T).2.P03]) →
          S'.alloc = S.alloc → S'.WF →
          S'.mem = (M.storeDec dec (decAt d2 D)).storeQuad r (addDigit (TB j) d2 R T).1 →
          (runD E' 37 S' >>= g) = K) :
    (runD E 25 S >>= g) = K := by
  have hM1 := hM0.storeDec hs (D := D)
  obtain ⟨hz, hlo, hhi⟩ := hd2
  have hro := hM0.roomR.1
  have hr : S.mem.QuadRoom r := by rw [hM]; exact hM1.roomR.storeQuad
  have hbt := hM1.bt j hj
  have hbt1 : InBounds S.mem (bt.add (BitVec.ofNat 64 (8 * j))) 64 := by
    rw [hM]; exact InBounds.storeQuad hbt.1
  have hbt2 : S.mem.loadPtr (bt.add (BitVec.ofNat 64 (8 * j))) = .value (btp j) := by
    rw [hM, loadPtr_storeQuad_of_id_ne (by simpa [Nat.add_comm] using hM1.rbt)]; exact hbt.2
  have hMS := hM
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL hR
  block_init
  step_pure [signExtend_ofInt16 (show -2 ^ 15 ≤ d2 ∧ d2 < 2 ^ 15 by omega)]
  step_pure [slt_zero_ofInt16 (show -2 ^ 15 ≤ d2 ∧ d2 < 2 ^ 15 by omega)]
  finish_block
  case isTrue =>
    have hpos : 0 < d2 := by simpa [Nat.add_comm] using hbr
    obtain ⟨k, rfl⟩ : ∃ k : Nat, d2 = ((2 * k + 1 : Nat) : Int) :=
      ⟨(d2 / 2).toNat, by omega⟩
    have hk : k < 128 := by omega
    have he := hM1.btq j hj k hk
    refine add2_block r n1 ta n2 tb dec n1s n2s bt tp _ _ _ i j k hj hk T (TB j k) (btp j)
      S E g K hArgs ⟨by env_reads, by env_reads⟩
      (by rw [ofInt_pos_odd] at hE; env_reads) hM1.bto hbt1 hbt2 (by have := hM1.btpo j hj; omega)
      (hM1.rbp j hj) hM1.rbt hwf hr (by rw [hM]; exact he.1.storeQuad)
      (by
        rw [hM, MemoryState.readQuad_storeQuad_of_id_ne
          (by simpa [Nat.add_comm] using hM1.rbp j hj)]
        exact he.2) (fun h => absurd h (by decide)) (fun _ E' h1 h2 h3 => ?_)
    obtain ⟨fdr, fdh, fg⟩ := step_facts (T := T) hMS hs.r.symm hdr hgM
    refine add2_dec r n1 ta n2 tb dec n1s n2s bt tp i j _ D _ E' g K h1 h2 h3 hwf.storeQuad fg fdr
      fdh hOk fun E'' h1' h2' h3' => ?_
    rw [addDigit_pos] at hK
    refine hK E'' _ h1' h2' h3' rfl ?_ ?_
    · exact (GlobalState.WF.storeDec hwf.storeQuad)
    · dsimp only
      rw [step_mem hMS hs.r.symm hro hdr.1 (DecSt.mono_step D 3#64), decAt,
        ite_eq_right (by omega)]
  case isFalse =>
    have hnpos : ¬0 < d2 := by simpa [Nat.add_comm] using hbr
    block_init
    step_pure [ofInt16_slt_zero (show -2 ^ 15 ≤ d2 ∧ d2 < 2 ^ 15 by omega)]
    finish_block
    case isTrue =>
      have hneg : d2 < 0 := by simpa [Nat.add_comm] using hbr
      obtain ⟨k, rfl⟩ : ∃ k : Nat, d2 = -((2 * k + 1 : Nat) : Int) :=
        ⟨(-d2 / 2).toNat, by omega⟩
      have hk : k < 128 := by omega
      have he := hM1.btq j hj k hk
      refine sub2_block r n1 ta n2 tb dec n1s n2s bt tp _ _ _ i j k hj hk T (TB j k)
        (btp j) S E g K hArgs ⟨by env_reads, by env_reads⟩
        (by rw [ofInt_neg_odd] at hE; env_reads) hM1.bto hbt1 hbt2
        (by have := hM1.btpo j hj; omega) (hM1.rbp j hj) hM1.rbt hwf hr
        (by rw [hM]; exact he.1.storeQuad)
        (by
          rw [hM, MemoryState.readQuad_storeQuad_of_id_ne
            (by simpa [Nat.add_comm] using hM1.rbp j hj)]
          exact he.2) (fun h => absurd h (by decide)) (fun _ E' h1 h2 h3 => ?_)
      obtain ⟨fdr, fdh, fg⟩ := step_facts (T := T) hMS hs.r.symm hdr hgM
      refine sub2_dec r n1 ta n2 tb dec n1s n2s bt tp i j _ D _ E' g K h1 h2 h3 hwf.storeQuad fg
        fdr fdh hOk fun E'' h1' h2' h3' => ?_
      rw [addDigit_neg] at hK
      refine hK E'' _ h1' h2' h3' rfl ?_ ?_
      · exact (GlobalState.WF.storeDec hwf.storeQuad)
      · dsimp only
        rw [step_mem hMS hs.r.symm hro hdr.1 (DecSt.mono_step D 3#64), decAt,
          ite_eq_right (by omega)]
    case isFalse =>
      have h0 : d2 = 0 := by
        have : ¬d2 < 0 := by simpa [Nat.add_comm] using hbr
        omega
      subst h0
      rw [addDigit_zero, decAt, ite_eq_left rfl] at hK
      exact hK E S hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) rfl hwf hM

/-- `^bb13` with `dec`: segment `j` at bit `i` on `r` (`R` over the state `D` in memory) and `t`
(`T` in registers): `n1slide[32j+i] = d1`'s add from `a_tbl`'s segment `j`, then its decode step;
on to `^bb25` with their `addDigit` and `decAt d1 D`. -/
theorem half1D (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA : Nat → Quad) (TB : Nat → Nat → Quad) (M : MemoryState)
    (hM0 : Base M r n1s n2s bt ta btp w1 w2 TA TB) (hs : DecSep dec r n1s n2s bt ta tp btp)
    (hdr : M.DecRoom dec) (hgM : M.Globals Gl) (D : DecSt) (hOk : D.Ok)
    (i j : Nat) (hi : i < 32) (hj : j < 8) (R T : Quad)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : LiveD r n1s n2s bt tp dec i E)
    (hR : E ⊨ [%%485 := BitVec.ofNat 64 j, %%486 := T.P25, %%487 := T.P14, %%488 := T.P03])
    (hwf : S.WF) (hM : S.mem = (M.storeDec dec D).storeQuad r R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          LiveD r n1s n2s bt tp dec i E' →
          (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := BitVec.ofInt 16 (digit w2 (32 * j + i)),
            %%1343 := (addDigit (fun k => TA (4 * j + k)) (digit w1 (32 * j + i)) R T).2.P25,
            %%1344 := (addDigit (fun k => TA (4 * j + k)) (digit w1 (32 * j + i)) R T).2.P14,
            %%1345 := (addDigit (fun k => TA (4 * j + k)) (digit w1 (32 * j + i)) R T).2.P03]) →
          S'.alloc = S.alloc → S'.WF →
          S'.mem =
            (M.storeDec dec (decAt (digit w1 (32 * j + i)) D)).storeQuad r
              (addDigit (fun k => TA (4 * j + k)) (digit w1 (32 * j + i)) R T).1 →
          (runD E' 25 S' >>= g) = K) :
    (runD E 13 S >>= g) = K := by
  have hM1 := hM0.storeDec hs (D := D)
  have hro := hM0.roomR.1
  generalize hMd : M.storeDec dec D = M' at hM hM1
  have hold : Held (M.storeDec dec D = M' ∧ DecSep dec r n1s n2s bt ta tp btp ∧ M.DecRoom dec ∧
      M.Globals Gl ∧ D.Ok ∧ r.offset.toNat + 192 ≤ 2 ^ 64) := ⟨hMd, hs, hdr, hgM, hOk, hro⟩
  clear hMd hs hdr hgM hOk hro hM0
  have hx : 32 * j + i < 256 := by omega
  have hs1 := slidesAt_storeQuad hM1.s1 hM1.rn1 (P := R) (32 * j + i) hx
  have hs2 := slidesAt_storeQuad hM1.s2 hM1.rn2 (P := R) (32 * j + i) hx
  rw [← hM] at hs1 hs2
  obtain ⟨hf1, hl1⟩ := hs1
  obtain ⟨hf2, hl2⟩ := hs2
  have hd1 := hw1 (32 * j + i) hx
  have hd2 := hw2 (32 * j + i) hx
  rw [show w1[32 * j + i] = digit w1 (32 * j + i) by simp [digit, hx]] at hl1 hd1
  rw [show w2[32 * j + i] = digit w2 (32 * j + i) by simp [digit, hx]] at hl2 hd2
  generalize digit w1 (32 * j + i) = d1 at hl1 hd1 hK
  generalize digit w2 (32 * j + i) = d2 at hl2 hd2 hK
  obtain ⟨hz, hlo, hhi⟩ := hd1
  have hr : S.mem.QuadRoom r := by rw [hM]; exact hM1.roomR.storeQuad
  have hn1o := hM1.n1o
  have hn2o := hM1.n2o
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL hR
  block_init
  step_pure [shl5_ofNat j, ushr5_ofNat hj, sshr5_ofNat hj]
  step_pure [saddOverflow_ofNat64 (show 32 * j + i < 2 ^ 63 by omega),
    uaddOverflow_ofNat64 (show 32 * j + i < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure [Nat.mod_eq_of_lt (show 32 * j + i < 2 ^ 64 by omega),
    Nat.mod_eq_of_lt (show 32 * j + i < 18446744073709551616 by omega),
    Nat.mul_comm (32 * j + i) 2, show 2 * (32 * j + i) < 2 ^ 64 by omega]
  step_load consuming hf1 hl1
  step_pure [Nat.mod_eq_of_lt (show 32 * j + i < 2 ^ 64 by omega),
    Nat.mod_eq_of_lt (show 32 * j + i < 18446744073709551616 by omega),
    Nat.mul_comm (32 * j + i) 2, show 2 * (32 * j + i) < 2 ^ 64 by omega]
  step_load with dd2 consuming hf2 hl2
  subst hdd2
  step_pure [signExtend_ofInt16 (show -2 ^ 15 ≤ d1 ∧ d1 < 2 ^ 15 by omega)]
  step_pure [slt_zero_ofInt16 (show -2 ^ 15 ≤ d1 ∧ d1 < 2 ^ 15 by omega)]
  finish_block
  case isTrue =>
    have hpos : 0 < d1 := by simpa [Nat.add_comm] using hbr
    obtain ⟨k, rfl⟩ : ∃ k : Nat, d1 = ((2 * k + 1 : Nat) : Int) :=
      ⟨(d1 / 2).toNat, by omega⟩
    have hk : k < 4 := by omega
    have he := hM1.tap (4 * j + k) (by omega)
    have hSM : S.mem = M'.storeQuad r R := by rw [hS, hM]
    obtain ⟨hMd, hs, hdr, hgM, hOk, hro⟩ := hold
    refine add1_block r n1 ta n2 tb dec n1s n2s bt tp _ _ _ i j k hj hk T (TA (4 * j + k))
      (BitVec.ofInt 16 d2) S E g K hArgs ⟨by env_reads, by env_reads⟩
      (by rw [ofInt_pos_odd] at hE; env_reads) hM1.tao hM1.rta hwf hr
      (by rw [hSM]; exact he.1.storeQuad)
      (by
        rw [hSM, MemoryState.readQuad_storeQuad_of_id_ne
          (by simpa [Nat.add_comm] using hM1.rta)]
        exact he.2) (fun h => absurd h (by decide)) (fun _ E' h1 h2 h3 => ?_)
    obtain ⟨fdr, fdh, fg⟩ := step_facts (T := T) (hSM.trans (by rw [hMd])) hs.r.symm hdr hgM
    refine add1_dec r n1 ta n2 tb dec n1s n2s bt tp i j _ _ D _ E' g K h1 h2 h3 hwf.storeQuad fg
      fdr fdh hOk fun E'' h1' h2' h3' => ?_
    rw [addDigit_pos] at hK
    refine hK E'' _ h1' h2' h3' (by rw [hS]) ?_ ?_
    · exact (GlobalState.WF.storeDec hwf.storeQuad)
    · dsimp only
      rw [step_mem (hSM.trans (by rw [hMd])) hs.r.symm hro hdr.1 (DecSt.mono_step D 3#64), decAt,
        ite_eq_right (by omega)]
  case isFalse =>
    have hnpos : ¬0 < d1 := by simpa [Nat.add_comm] using hbr
    block_init
    step_pure [ofInt16_slt_zero (show -2 ^ 15 ≤ d1 ∧ d1 < 2 ^ 15 by omega)]
    finish_block
    case isTrue =>
      have hneg : d1 < 0 := by simpa [Nat.add_comm] using hbr
      obtain ⟨k, rfl⟩ : ∃ k : Nat, d1 = -((2 * k + 1 : Nat) : Int) :=
        ⟨(-d1 / 2).toNat, by omega⟩
      have hk : k < 4 := by omega
      have he := hM1.tap (4 * j + k) (by omega)
      have hSM : S.mem = M'.storeQuad r R := by rw [hS, hM]
      obtain ⟨hMd, hs, hdr, hgM, hOk, hro⟩ := hold
      refine sub1_block r n1 ta n2 tb dec n1s n2s bt tp _ _ _ i j k hj hk T
        (TA (4 * j + k)) (BitVec.ofInt 16 d2) S E g K hArgs ⟨by env_reads, by env_reads⟩
        (by rw [ofInt_neg_odd] at hE; env_reads) hM1.tao hM1.rta hwf hr
        (by rw [hSM]; exact he.1.storeQuad)
        (by
          rw [hSM, MemoryState.readQuad_storeQuad_of_id_ne
            (by simpa [Nat.add_comm] using hM1.rta)]
          exact he.2) (fun h => absurd h (by decide)) (fun _ E' h1 h2 h3 => ?_)
      obtain ⟨fdr, fdh, fg⟩ := step_facts (T := T) (hSM.trans (by rw [hMd])) hs.r.symm hdr hgM
      refine sub1_dec r n1 ta n2 tb dec n1s n2s bt tp i j _ _ D _ E' g K h1 h2 h3 hwf.storeQuad
        fg fdr fdh hOk fun E'' h1' h2' h3' => ?_
      rw [addDigit_neg] at hK
      refine hK E'' _ h1' h2' h3' (by rw [hS]) ?_ ?_
      · exact (GlobalState.WF.storeDec hwf.storeQuad)
      · dsimp only
        rw [step_mem (hSM.trans (by rw [hMd])) hs.r.symm hro hdr.1 (DecSt.mono_step D 3#64), decAt,
          ite_eq_right (by omega)]
    case isFalse =>
      have h0 : d1 = 0 := by
        have : ¬d1 < 0 := by simpa [Nat.add_comm] using hbr
        omega
      subst h0
      obtain ⟨hMd, -⟩ := hold
      rw [addDigit_zero, decAt, ite_eq_left rfl] at hK
      exact hK E S hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) (by rw [hS]) hwf
        (by rw [hS, hM, hMd])

/-- The segments' loop with `dec` from `^bb13` at `j`, `rt0`'s segments `0 … j-1` done and their
decode steps from `D0`: at `^bb12` all eight done. -/
theorem jloopD (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA TB : Nat → Quad) (M : MemoryState)
    (hM0 : Base M r n1s n2s bt ta btp w1 w2 TA (btab TB)) (hs : DecSep dec r n1s n2s bt ta tp btp)
    (hdr : M.DecRoom dec) (hgM : M.Globals Gl) (D0 : DecSt) (hOk : D0.Ok)
    (i : Nat) (hi : i < 32) (rt0 : Quad × Quad)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫), j + m = 8 → j < 8 →
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get →
        LiveD r n1s n2s bt tp dec i E →
        (E ⊨ [%%485 := BitVec.ofNat 64 j, %%486 := (segAdds TA TB w1 w2 i j rt0).2.P25,
          %%487 := (segAdds TA TB w1 w2 i j rt0).2.P14,
          %%488 := (segAdds TA TB w1 w2 i j rt0).2.P03]) →
        S.WF →
        S.mem =
          (M.storeDec dec (segDecs w1 w2 i j D0)).storeQuad r (segAdds TA TB w1 w2 i j rt0).1 →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            LiveD r n1s n2s bt tp dec i E' →
            (E' ⊨ [%%2192 := (segAdds TA TB w1 w2 i 8 rt0).2.P25,
              %%2193 := (segAdds TA TB w1 w2 i 8 rt0).2.P14,
              %%2194 := (segAdds TA TB w1 w2 i 8 rt0).2.P03]) →
            S'.alloc = S.alloc → S'.WF →
            S'.mem =
              (M.storeDec dec (segDecs w1 w2 i 8 D0)).storeQuad r
                (segAdds TA TB w1 w2 i 8 rt0).1 →
            (runD E' 12 S' >>= g) = K) →
        (runD E 13 S >>= g) = K := by
  intro m
  induction m with
  | zero => intro j S E hm hj; omega
  | succ m ih =>
    intro j S E hm hj hArgs hL hR hwf hM hK
    have hOkj := segDecs_of (P := DecSt.Ok) (fun D h => DecSt.Ok.step h 3#64) w1 w2 i j hOk
    refine half1D r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA (btab TB) M hM0 hs hdr hgM _ hOkj
      i j hi hj _ _ hw1 hw2 S E g K hArgs hL hR hwf hM
      fun E₁ S₁ h₁ hL₁ hR₁ ha₁ hwf₁ hM₁ => ?_
    have hd2 := hw2 (32 * j + i) (by omega)
    rw [show w2[32 * j + i] = digit w2 (32 * j + i) by simp [digit, show 32 * j + i < 256 by omega]]
      at hd2
    refine half2D r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA (btab TB) M hM0 hs hdr hgM _
      (decAt_of (P := DecSt.Ok) (fun D h => DecSt.Ok.step h 3#64) _ hOkj) i j hj _ _ _ hd2 S₁ E₁
      g K h₁ hL₁ (by env_reads) hwf₁ hM₁ fun E₂ S₂ h₂ hL₂ hR₂ ha₂ hwf₂ hM₂ => ?_
    obtain ⟨hC, hL⟩ := hL₂
    split_env hC hL hR₂
    block_init
    step_pure [saddOverflow_one64 (show j + 1 < 2 ^ 63 by omega),
      uaddOverflow_one64 (show j + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    case isTrue =>
      have h8 : j + 1 = 8 := by
        have := congrArg BitVec.toNat hbr
        simp only [BitVec.toNat_ofNat] at this
        omega
      obtain rfl : j = 7 := by omega
      exact hK E S₂ hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) (ha₂.trans ha₁) hwf₂ hM₂
    case isFalse =>
      have h8 : j + 1 < 8 := by
        by_contra h
        exact hbr (by rw [show j + 1 = 8 by omega])
      exact ih (j + 1) S₂ E (by omega) h8 hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) hwf₂ hM₂
        fun E' S' h1 h2 h3 h4 h5 h6 => hK E' S' h1 h2 h3 (h4.trans (ha₂.trans ha₁)) h5 h6

/-- The memory past `partial_dbl`'s store to `t` and its decode step. -/
theorem dbl_mem {Y : MemoryState} {r t dec : Pointer} {R P : Quad} {D D' : DecSt}
    (hrd : r.id ≠ dec.id) (htd : t.id ≠ dec.id) (hrt : r.id ≠ t.id)
    (hov : ¬dec.offset.uaddOverflow 724#64) (hm : D.Mono D') :
    (((Y.storeDec dec D).storeQuad r R).storeQuad t P).storeDec dec D' =
      ((Y.storeQuad t P).storeDec dec D').storeQuad r R := by
  rw [MemoryState.storeQuad_storeDec htd, MemoryState.storeQuad_storeDec hrd,
    MemoryState.storeDec_storeDec hov hm, MemoryState.storeQuad_comm hrt,
    MemoryState.storeQuad_storeDec htd]

/-- `^bb6` with `dec`, the main loop at bit `i` on `r` (`R` over the state `D` in memory):
`t = partial_dbl( r )` and its decode step, the eight segments' adds and theirs, `r` and `t` the
result; then around at `i - 1`, or out at `i = 0`. -/
theorem iterD_block (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA TB : Nat → Quad) (Y : MemoryState)
    (hY : Base Y r n1s n2s bt ta btp w1 w2 TA (btab TB)) (htY : Y.QuadRoom tp)
    (hs : DecSep dec r n1s n2s bt ta tp btp) (hdr : Y.DecRoom dec) (hgY : Y.Globals Gl)
    (D : DecSt) (hOk : D.Ok)
    (hrt : r.id ≠ tp.id) (htn1 : tp.id ≠ n1s.id) (htn2 : tp.id ≠ n2s.id) (htbt : tp.id ≠ bt.id)
    (htta : tp.id ≠ ta.id) (htbp : ∀ j < 8, tp.id ≠ (btp j).id) (i : Nat) (hi : i < 32) (R : Quad)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : LiveD r n1s n2s bt tp dec i E) (hwf : S.WF) (A : AllocState) (hA : S.alloc = A)
    (hM : S.mem = (Y.storeDec dec D).storeQuad r R)
    (hback :
      ∀ i', i = i' + 1 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            LiveD r n1s n2s bt tp dec i' E' → S'.alloc = A → S'.WF →
            S'.mem =
              ((Y.storeQuad tp (iter TA TB w1 w2 i R)).storeDec dec (iterDec w1 w2 i D)).storeQuad
                r (iter TA TB w1 w2 i R) →
            (runD E' 6 S' >>= g) = K)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            LiveD r n1s n2s bt tp dec i E' → S'.alloc = A → S'.WF →
            S'.mem =
              ((Y.storeQuad tp (iter TA TB w1 w2 i R)).storeDec dec (iterDec w1 w2 i D)).storeQuad
                r (iter TA TB w1 w2 i R) →
            (runD E' 38 S' >>= g) = K) :
    (runD E 6 S >>= g) = K := by
  have hro := hY.roomR.1
  have hY1 := hY.storeDec hs (D := D)
  have htY1 : (Y.storeDec dec D).QuadRoom tp := MemoryState.QuadRoom.storeDec htY
  generalize hYd : Y.storeDec dec D = Y' at hM hY1 htY1
  have hr : S.mem.QuadFit r := by rw [hM]; exact MemoryState.QuadFit.storeQuad_self hY1.roomR
  have ht : S.mem.QuadRoom tp := by rw [hM]; exact htY1.storeQuad
  have hrv : S.mem.readQuad r = R := by
    rw [hM]; exact MemoryState.readQuad_storeQuad_self hY1.roomR
  have hold : Held (Y.storeDec dec D = Y' ∧ DecSep dec r n1s n2s bt ta tp btp ∧ Y.DecRoom dec ∧
      Y.Globals Gl ∧ D.Ok ∧ r.offset.toNat + 192 ≤ 2 ^ 64) :=
    ⟨hYd, hs, hdr, hgY, hOk, hro⟩
  clear hYd hs hdr hgY hOk hro hY1 htY1
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL
  block_init
  -- t = fd_ed25519_partial_dbl( r )
  step_call using fd_ed25519_partial_dbl.call_eq
  finish_block
  -- fd_ed25519_point_decode_step( dec, 3 )
  obtain ⟨hYd, hs, hdr, hgY, hOk, hro⟩ := hold
  have hS1 : S.mem = (((Y.storeDec dec D).storeQuad r R).storeQuad tp
      (fd_ed25519_partial_dbl.spec R)) := by
    rw [hS]; dsimp only; rw [hM, hYd]
  have hTd := hs.tp
  have hDd : S.mem.DecHolds dec D := by
    rw [hS1]
    exact decHolds_storeQuad (decHolds_storeQuad (MemoryState.DecHolds.storeDec hdr) hs.r.symm)
      hs.tp.symm
  have hRd : S.mem.DecRoom dec := by
    rw [hS1]
    exact ⟨hdr.1, Room.storeQuad (Room.storeQuad (Room.storeDec hdr.2))⟩
  have hGd : S.mem.Globals Gl := by
    rw [hS1]
    exact (((MemoryState.Globals.storeDec hgY).mono globals_storeQuad fun _ h => h).mono
      globals_storeQuad fun _ h => h)
  refine dbl_dec r n1 ta n2 tb dec n1s n2s bt tp i D S E g K hArgs ⟨by env_reads, by env_reads⟩
    hwf hGd hRd hDd hOk fun E₁ h₁ hL₁ => ?_
  have hq : (S.mem.storeDec dec (D.step 3#64)).QuadFit tp := MemoryState.QuadFit.storeDec ht
  have hread : (S.mem.storeDec dec (D.step 3#64)).readQuad tp = fd_ed25519_partial_dbl.spec R := by
    rw [MemoryState.readQuad_storeDec_of_id_ne hTd]; exact hread_tp
  have hwf₁ : (({ S with mem := S.mem.storeDec dec (D.step 3#64) } : GlobalState)).WF :=
    GlobalState.WF.storeDec hwf
  have hA₁ : ({ S with mem := S.mem.storeDec dec (D.step 3#64) } : GlobalState).alloc = A := by
    rw [hS]; exact hA
  have hM₁ : ({ S with mem := S.mem.storeDec dec (D.step 3#64) } : GlobalState).mem =
      ((Y.storeQuad tp (fd_ed25519_partial_dbl.spec R)).storeDec dec (D.step 3#64)).storeQuad r
        R := by
    dsimp only
    rw [hS1, dbl_mem hs.r.symm hs.tp.symm hrt hdr.1 (DecSt.mono_step D 3#64)]
  obtain ⟨S₁, hS₁⟩ :
      ∃ S₁ : GlobalState, ({ S with mem := S.mem.storeDec dec (D.step 3#64) } : GlobalState) = S₁ :=
    ⟨_, rfl⟩
  rw [hS₁] at hwf₁ hA₁ hM₁
  have hq' : S₁.mem.QuadFit tp := hS₁ ▸ hq
  have hread' : S₁.mem.readQuad tp = fd_ed25519_partial_dbl.spec R := hS₁ ▸ hread
  rw [hS₁]
  clear hDd hRd hGd hq hread hS1 hS₁ hr ht hread_tp hrv hread_r hwf
  obtain ⟨hC, hL⟩ := hL₁
  split_env hC hL
  block_init
  step_load with x03
  step_load with x14
  step_load with x25
  finish_block
  have eD : (⟨x03, x14, x25⟩ : Quad) = fd_ed25519_partial_dbl.spec R := by
    rw [← hread', hS, hx03, hx14, hx25]
    rfl
  have hAj : S.alloc = A := by rw [hS]; exact hA₁
  have hYD := hY.storeQuad (P := ⟨x03, x14, x25⟩) htn1 htn2 htbt htta htbp
  -- for( int j=0; j<8; j++ ) { … }
  refine jloopD r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA TB _ hYD hs
    ⟨hdr.1, Room.storeQuad hdr.2⟩ (hgY.mono globals_storeQuad fun _ h => h) _
    (DecSt.Ok.step hOk 3#64) i hi (R, ⟨x03, x14, x25⟩) hw1 hw2 g K 8 0 S E (by omega) (by omega)
    hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) hwf₁
    (by rw [hS, hM₁, ← eD]; rfl)
    fun E' S' h₁ hL' hR' ha' hwf' hM' => ?_
  generalize hRt : segAdds TA TB w1 w2 i 8 (R, ⟨x03, x14, x25⟩) = rt at hR' hM'
  have hr' : S'.mem.QuadRoom r := by
    rw [hM']; exact (hYD.storeDec hs).roomR.storeQuad
  have ht' : S'.mem.QuadRoom tp := by
    rw [hM']; exact (MemoryState.QuadRoom.storeDec htY.storeQuad).storeQuad
  obtain ⟨hC, hL⟩ := hL'
  split_env hC hL hR'
  block_init
  iterate 6 step_store
  have hmem :
      S.mem = ((Y.storeQuad tp (iter TA TB w1 w2 i R)).storeDec dec (iterDec w1 w2 i D)).storeQuad r
        (iter TA TB w1 w2 i R) := by
    rw [hS]
    dsimp only
    rw [hM', MemoryState.storeQuad_storeDec hTd.symm (P := ⟨x03, x14, x25⟩), iter, iterDec, ← eD,
      hRt, bb12_mem (Ne.symm hrt) htY.1 hro, MemoryState.storeQuad_storeDec hTd.symm]
  rcases Nat.eq_zero_or_pos i with hi0 | hi0
  · subst hi0
    step_pure
    step_pure
    finish_block
    exact hexit rfl E S hArgs ⟨by env_reads, by env_reads⟩ (by rw [hS]; exact ha'.trans hAj) hwf'
      hmem
  · step_pure [saddOverflow_neg_one64 hi0 (by omega), add_neg_one64 hi0 (by omega)]
    step_pure [slt_ofNat64 hi0 (by omega)]
    finish_block
    exact hback (i - 1) (by omega) E S hArgs ⟨by env_reads, by env_reads⟩
      (by rw [hS]; exact ha'.trans hAj) hwf' hmem

/-- The main loop with `dec` from `^bb6` at bit `i` on `r` (`R` over the state `D` in memory, `Y`
beneath them): at `^bb38` `r` holds the ladder from `i`, `dec` the state after its steps, the
memory beneath them changed only in the frame. -/
theorem iloopD (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA TB : Nat → Quad) (N : Nat) (B : MemoryState)
    (hs : DecSep dec r n1s n2s bt ta tp btp)
    (hNt : N ≤ tp.id.id) (hrt : r.id ≠ tp.id) (htn1 : tp.id ≠ n1s.id) (htn2 : tp.id ≠ n2s.id)
    (htbt : tp.id ≠ bt.id) (htta : tp.id ≠ ta.id) (htbp : ∀ j < 8, tp.id ≠ (btp j).id)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2) (A : AllocState)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (R : Quad) (Y : MemoryState) (D : DecSt) (S : GlobalState) (E : ⟪Γ⟫), i < 32 →
      Base Y r n1s n2s bt ta btp w1 w2 TA (btab TB) → Y.QuadRoom tp → Y.eraseFrom N = B →
        Y.DecRoom dec → Y.Globals Gl → D.Ok →
        E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          LiveD r n1s n2s bt tp dec i E → S.WF → S.alloc = A →
          S.mem = (Y.storeDec dec D).storeQuad r R →
          (∀ (E' : ⟪Γ⟫) (S' : GlobalState) (Y' : MemoryState),
            E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
                (.value dec)).get →
              LiveD r n1s n2s bt tp dec 0 E' → S'.alloc = A → S'.WF →
              Y'.eraseFrom N = B →
              S'.mem =
                (Y'.storeDec dec (ladderDec w1 w2 i D)).storeQuad r (ladder TA TB w1 w2 i R) →
              (runD E' 38 S' >>= g) = K) →
          (runD E 6 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro R Y D S E hi hY htY hYB hdr hgY hOk hArgs hL hwf hA hM hK
    refine iterD_block r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA TB Y hY htY hs hdr hgY D hOk
      hrt htn1 htn2 htbt htta htbp 0 hi R hw1 hw2 S E g K hArgs hL hwf A hA hM
      (fun _ h => absurd h (by omega)) fun _ E' S' h₁ h₂ h₃ h₄ h₅ => ?_
    refine hK E' S' _ h₁ h₂ h₃ h₄ ?_ h₅
    rw [MemoryState.eraseFrom_storeQuad_of_le hNt, hYB]
  | succ i ih =>
    intro R Y D S E hi hY htY hYB hdr hgY hOk hArgs hL hwf hA hM hK
    refine iterD_block r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA TB Y hY htY hs hdr hgY D hOk
      hrt htn1 htn2 htbt htta htbp (i + 1) hi R hw1 hw2 S E g K hArgs hL hwf A hA hM
      (fun i' hi' E' S' h₁ h₂ h₃ h₄ h₅ => ?_) fun h => absurd h (by omega)
    obtain rfl : i = i' := by omega
    exact ih _ _ _ S' E' (by omega) (hY.storeQuad htn1 htn2 htbt htta htbp) htY.storeQuad
      (by rw [MemoryState.eraseFrom_storeQuad_of_le hNt, hYB]) ⟨hdr.1, Room.storeQuad hdr.2⟩
      (hgY.mono globals_storeQuad fun _ h => h)
      (segDecs_of (P := DecSt.Ok) (fun D h => DecSt.Ok.step h 3#64) w1 w2 (i + 1) 8
        (DecSt.Ok.step hOk 3#64)) h₁ h₂ h₄ h₃ h₅ hK

end double_scalar_mul_base_split

end

end MLIR.Firedancer.Lane
