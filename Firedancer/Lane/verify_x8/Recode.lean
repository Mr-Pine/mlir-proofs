module

public import Firedancer.Lane.verify_x8.RecodeRuns
public import Firedancer.Lane.verify_x8.RecodeMem

/-! `fd_ed25519_lane_recode4` and `fd_ed25519_lane_recode8` inlined into `verify_x8`
(`^bb80 … ^bb82`): per lane `j` the 64 digits of `k[j]` (the loop at `^bb81`, stored into `kd`'s
column by one masked store) and the 32 of `s[j]` (unrolled). -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

/-- `^bb81` at lane `j`, digits `4 t … 4 t + 3` of `k[j]` into `kj`; on to the next four, or
after the last to `^bb82`. -/
theorem rk_trip (c : Call) (j : Fin 8) (t : Nat) (ht : t < 16) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvB c E j) (hK : EnvK c E j t) (hR : c.Rec j S)
    (hk2 : c.K2 j (4 * t) S.mem) (hr2 : Room S.mem (c.s.slot 2) 512)
    (hback :
      t + 1 < 16 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvB c E' j →
        EnvK c E' j (t + 1) → c.Rec j S' → c.K2 j (4 * (t + 1)) S'.mem →
          Room S'.mem (c.s.slot 2) 512 → ((verify_x8 c.batch).runFrom E' 81 S' >>= g) = K)
    (hexit :
      t + 1 = 16 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvB c E' j →
        c.Rec j S' → c.K2 j 64 S'.mem → Room S'.mem (c.s.slot 2) 512 →
          ((verify_x8 c.batch).runFrom E' 82 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 81 S >>= g) = K := by
  have hwf := hR.base.wf
  obtain ⟨hf0, hr0⟩ := hR.ks.kbyte rfl j (m := 2 * t) (by omega)
  obtain ⟨hf1, hr1⟩ := hR.ks.kbyte rfl j (m := 2 * t + 1) (by omega)
  have hq0 := slot_room c.s 2 (b := 4 * t) (v := 8) hr2 (by omega) (by decide)
  have hq1 := slot_room c.s 2 (b := 4 * t + 1) (v := 8) hr2 (by omega) (by decide)
  have hq2 := slot_room c.s 2 (b := 4 * t + 2) (v := 8) hr2 (by omega) (by decide)
  have hq3 := slot_room c.s 2 (b := 4 * t + 3) (v := 8) hr2 (by omega) (by decide)
  rw [← add_ofNat_add_ofNat] at hq1 hq3
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hr0 hr1 hR hk2 hr2
  obtain ⟨P0, hP0⟩ : ∃ P0, (c.s.slot 26).add (BitVec.ofNat 64 (j.val * 32 + 2 * t)) = P0 :=
    ⟨_, rfl⟩
  obtain ⟨P1, hP1⟩ :
      ∃ P1, (c.s.slot 26).add (BitVec.ofNat 64 (j.val * 32 + (2 * t + 1))) = P1 := ⟨_, rfl⟩
  rw [hP0] at hf0 hr0
  rw [hP1] at hf1 hr1
  obtain ⟨Q0, hQ0⟩ : ∃ Q0, (c.s.slot 2).add (BitVec.ofNat 64 (4 * t)) = Q0 := ⟨_, rfl⟩
  obtain ⟨Q2, hQ2⟩ : ∃ Q2, (c.s.slot 2).add (BitVec.ofNat 64 (4 * t + 2)) = Q2 := ⟨_, rfl⟩
  have hqo (k : Nat) (hk : k ≤ 3) : ¬Q0.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    rw [← hQ0]
    simp [Pointer.add, BitVec.uaddOverflow, Nat.mod_eq_of_lt (show 4 * t < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega)]
    omega
  rw [hQ0] at hq0 hq1 hq3
  rw [hQ2] at hq2
  obtain ⟨E₁, hE₁⟩ : ∃ E₁, E₁ = E := ⟨E, rfl⟩
  have hrest : Hidden (EnvB c E₁ j) := ⟨hE₁ ▸ hE⟩
  clear hE
  split_reads hK
  obtain ⟨C, hCe⟩ : ∃ C, carry4 (c.kS j) (4 * t) = C := ⟨_, rfl⟩
  have hC : C ≤ 1#32 := by
    have := carry4_le (c.kS j) (4 * t)
    rw [hCe] at this
    exact BitVec.le_def.2 (by simpa using this)
  rw [hCe] at hK_12
  show ((verify_x8 c.batch).runFrom E ⟨81, (by decide : 81 < 104)⟩ S >>= g) = K
  block_init
  obtain ⟨hs1, hs2⟩ := rk_shr ht
  obtain ⟨hs3, hs4, hs5, hs6⟩ := rk_or ht
  step_pure [hs1, hs2]
  step_pure [← BitVec.ofNat_add, hP0]
  step_load with b0
  have d0 := dig4 C _ hC (lo_le b0)
  step_pure
  step_pure [msb_15]
  step_pure [d0]
  step_pure [d0]
  step_pure
  step_pure
  step_pure [d0]
  step_pure [d0]
  step_pure [hQ0]
  step_store
  have d1 := dig4 _ _ d0.2.2.2.2.2.2 (hi_le b0)
  iterate 2 step_pure
  step_pure [d1]
  step_pure [d1]
  step_pure
  step_pure
  step_pure [d1]
  step_pure [d1]
  step_pure [hQ0]
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hqo 1 (by omega)) (Or.inr (by decide))]
  step_store
  -- `s[w>>1]` for `w | 2`
  step_pure [hs3, hs4]
  step_pure [hs5, hs6]
  step_pure [← BitVec.ofNat_add, hP1]
  step_load with b1
  have d2 := dig4 _ _ d1.2.2.2.2.2.2 (lo_le b1)
  step_pure
  step_pure [msb_15]
  step_pure [d2]
  step_pure [d2]
  step_pure
  step_pure
  step_pure [d2]
  step_pure [d2]
  step_pure [hQ2]
  step_store
  have d3 := dig4 _ _ d2.2.2.2.2.2.2 (hi_le b1)
  iterate 2 step_pure
  step_pure [d3]
  step_pure [d3]
  step_pure
  step_pure
  step_pure [d3]
  step_pure [d3]
  step_pure [hQ0]
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hqo 3 (by omega)) (Or.inr (by decide))]
  step_store
  obtain ⟨hi1, hi2, hi3⟩ := rk_inc ht
  step_pure [hi1, hi2, hi3]
  step_pure
  subst hS₀
  -- the four digits and the carry out, as the spec's
  have hb1' : b1 = (c.kS j).extractLsb' (8 * (2 * t + 1)) 8 := by
    have hne : (c.s.slot 2).id ≠ P1.id := by
      rw [← hP1, Pointer.add_id]; exact slot_ne c.s (by decide)
    rw [hb1, ← hQ0,
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_of_id_ne (by simp only [Pointer.add_id]; exact hne)),
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_of_id_ne (by simp only [Pointer.add_id]; exact hne)), hr1]
  have hx0 : nib (c.kS j) (4 * t) = BitVec.setWidth 32 b0 &&& 15#32 := by
    rw [hb0, hr0, show 4 * t = 2 * (2 * t) by omega, nib_even]
  have hx1 : nib (c.kS j) (4 * t + 1) = BitVec.setWidth 32 b0 >>> 4 := by
    rw [hb0, hr0, show 4 * t + 1 = 2 * (2 * t) + 1 by omega, nib_odd]
  have hx2 : nib (c.kS j) (4 * t + 2) = BitVec.setWidth 32 b1 &&& 15#32 := by
    rw [hb1', show 4 * t + 2 = 2 * (2 * t + 1) by omega, nib_even]
  have hx3 : nib (c.kS j) (4 * t + 3) = BitVec.setWidth 32 b1 >>> 4 := by
    rw [hb1', show 4 * t + 3 = 2 * (2 * t + 1) + 1 by omega, nib_odd]
  have e0 := dig4_spec (c.kS j) (4 * t) hCe hx0
  have e1 := dig4_spec (c.kS j) (4 * t + 1) e0.1.symm hx1
  have e2 := dig4_spec (c.kS j) (4 * t + 2) e1.1.symm hx2
  have e3 := dig4_spec (c.kS j) (4 * t + 3) e2.1.symm hx3
  rw [e0.2, e1.2, e2.2, e3.2] at hS
  rw [e3.1, show 4 * t + 3 + 1 = 4 * (t + 1) by omega] at hE
  clear hb0 hb1 hb1' hx0 hx1 hx2 hx3 e0 e1 e2 e3 d0 d1 d2 d3
  subst hQ0 hQ2
  rw [add_ofNat_add_ofNat, add_ofNat_add_ofNat] at hS
  have hR' : c.Rec j S := by
    rw [hS]
    have a := Pointer.add_id (c.s.slot 2)
    exact (((hR.store2 (a _) _).store2 (a _) _).store2 (a _) _).store2 (a _) _
  have hk2' : c.K2 j (4 * (t + 1)) S.mem := by
    rw [hS]
    exact hk2.step hr2 ht
  have hr2' : Room S.mem (c.s.slot 2) 512 := by
    rw [hS]
    exact hr2.storeAt.storeAt.storeAt.storeAt
  clear hS hR hk2 hr2
  subst hE₁
  have hrest' := hrest.out
  clear hrest
  split_reads hrest'
  finish_block
  · rw [rk_exit ht] at hbr
    rw [show 4 * (t + 1) = 64 by omega] at hk2'
    exact hexit hbr E S hArgs (by dsimp only [EnvB]; env_reads) hR' hk2' hr2'
  · rw [rk_exit ht] at hbr
    exact hback (by omega) E S hArgs (by dsimp only [EnvB]; env_reads)
      (by dsimp only [EnvK]; env_reads) hR' hk2' hr2'

-- about 360 instructions and 30 digit patterns in one block
set_option maxHeartbeats 4000000 in
/-- `^bb82` at lane `j`: `fd_ed25519_lane_recode8( s[j] )`, `kd[w][j] = kj[w]` by one masked store,
`sd[w][j] = sj[w]`, `kj` ended; on to lane `j + 1`, or after the last to `^bb79`. -/
theorem rs_block (c : Call) (j : Fin 8) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvB c E j) (hR : c.Rec j S) (hk2 : c.K2 j 64 S.mem)
    (hr2 : Room S.mem (c.s.slot 2) 512)
    (hback :
      j.val + 1 < 8 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvB c E' (j.val + 1) → c.Rec (j.val + 1) S' →
          ((verify_x8 c.batch).runFrom E' 80 S' >>= g) = K)
    (hexit :
      j.val + 1 = 8 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env79 c E' →
        c.Rec 8 S' → ((verify_x8 c.batch).runFrom E' 79 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 82 S >>= g) = K := by
  have hN : Env82 c E j := by
    have h := hE
    split_reads h
    dsimp only [Env82]
    env_reads
  have hjm : j.val % 18446744073709551616 = j.val := Nat.mod_eq_of_lt (by omega)
  have hwf := hR.base.wf
  obtain ⟨hf2, hrd2⟩ := hk2.whole hr2
  have hkdr := c.kd_lane_room hR.kd j.isLt
  have hroomK : ∀ i : Fin 505, kdMask[i] = 1#1 →
      ((c.s.slot 0).add (BitVec.ofNat 64 j.val)).offset.toNat + i.val * (8 / 8) < 2 ^ 64 ∧
        Room S.mem (Operation.lanePtr ((c.s.slot 0).add (BitVec.ofNat 64 j.val)) 8 i) 8 :=
    fun i _ => hkdr i
  clear hkdr
  obtain ⟨P, hP⟩ : ∃ P, (c.s.slot 27).add (BitVec.ofNat 64 (j.val * 32)) = P := ⟨_, rfl⟩
  have hPo (w : Nat) (hw : w < 32) : ¬P.offset.uaddOverflow (BitVec.ofNat 64 w) := by
    rw [← hP]
    simp [Pointer.add, BitVec.uaddOverflow, Nat.mod_eq_of_lt (show j.val * 32 < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (show w < 2 ^ 64 by omega)]
    omega
  have hsb (w : Nat) (hw : w < 32) :
      Fits S.mem (P.add (BitVec.ofNat 64 w)) 8 ∧
        S.mem.readAt (P.add (BitVec.ofNat 64 w)) 8 = (c.sS j).extractLsb' (8 * w) 8 := by
    rw [← hP, add_ofNat_add_ofNat]
    exact hR.ks.sbyte rfl j hw
  obtain ⟨hfb00, hrb00⟩ := hsb 0 (by decide)
  have hP1 := hPo 1 (by decide)
  obtain ⟨hfb1, hrb1⟩ := hsb 1 (by decide)
  have hP2 := hPo 2 (by decide)
  obtain ⟨hfb2, hrb2⟩ := hsb 2 (by decide)
  have hP3 := hPo 3 (by decide)
  obtain ⟨hfb3, hrb3⟩ := hsb 3 (by decide)
  have hP4 := hPo 4 (by decide)
  obtain ⟨hfb4, hrb4⟩ := hsb 4 (by decide)
  have hP5 := hPo 5 (by decide)
  obtain ⟨hfb5, hrb5⟩ := hsb 5 (by decide)
  have hP6 := hPo 6 (by decide)
  obtain ⟨hfb6, hrb6⟩ := hsb 6 (by decide)
  have hP7 := hPo 7 (by decide)
  obtain ⟨hfb7, hrb7⟩ := hsb 7 (by decide)
  have hP8 := hPo 8 (by decide)
  obtain ⟨hfb8, hrb8⟩ := hsb 8 (by decide)
  have hP9 := hPo 9 (by decide)
  obtain ⟨hfb9, hrb9⟩ := hsb 9 (by decide)
  have hP10 := hPo 10 (by decide)
  obtain ⟨hfb10, hrb10⟩ := hsb 10 (by decide)
  have hP11 := hPo 11 (by decide)
  obtain ⟨hfb11, hrb11⟩ := hsb 11 (by decide)
  have hP12 := hPo 12 (by decide)
  obtain ⟨hfb12, hrb12⟩ := hsb 12 (by decide)
  have hP13 := hPo 13 (by decide)
  obtain ⟨hfb13, hrb13⟩ := hsb 13 (by decide)
  have hP14 := hPo 14 (by decide)
  obtain ⟨hfb14, hrb14⟩ := hsb 14 (by decide)
  have hP15 := hPo 15 (by decide)
  obtain ⟨hfb15, hrb15⟩ := hsb 15 (by decide)
  have hP16 := hPo 16 (by decide)
  obtain ⟨hfb16, hrb16⟩ := hsb 16 (by decide)
  have hP17 := hPo 17 (by decide)
  obtain ⟨hfb17, hrb17⟩ := hsb 17 (by decide)
  have hP18 := hPo 18 (by decide)
  obtain ⟨hfb18, hrb18⟩ := hsb 18 (by decide)
  have hP19 := hPo 19 (by decide)
  obtain ⟨hfb19, hrb19⟩ := hsb 19 (by decide)
  have hP20 := hPo 20 (by decide)
  obtain ⟨hfb20, hrb20⟩ := hsb 20 (by decide)
  have hP21 := hPo 21 (by decide)
  obtain ⟨hfb21, hrb21⟩ := hsb 21 (by decide)
  have hP22 := hPo 22 (by decide)
  obtain ⟨hfb22, hrb22⟩ := hsb 22 (by decide)
  have hP23 := hPo 23 (by decide)
  obtain ⟨hfb23, hrb23⟩ := hsb 23 (by decide)
  have hP24 := hPo 24 (by decide)
  obtain ⟨hfb24, hrb24⟩ := hsb 24 (by decide)
  have hP25 := hPo 25 (by decide)
  obtain ⟨hfb25, hrb25⟩ := hsb 25 (by decide)
  have hP26 := hPo 26 (by decide)
  obtain ⟨hfb26, hrb26⟩ := hsb 26 (by decide)
  have hP27 := hPo 27 (by decide)
  obtain ⟨hfb27, hrb27⟩ := hsb 27 (by decide)
  have hP28 := hPo 28 (by decide)
  obtain ⟨hfb28, hrb28⟩ := hsb 28 (by decide)
  have hP29 := hPo 29 (by decide)
  obtain ⟨hfb29, hrb29⟩ := hsb 29 (by decide)
  have hP30 := hPo 30 (by decide)
  obtain ⟨hfb30, hrb30⟩ := hsb 30 (by decide)
  have hP31 := hPo 31 (by decide)
  obtain ⟨hfb31, hrb31⟩ := hsb 31 (by decide)
  clear hsb hPo
  rw [add_ofNat_zero] at hfb00 hrb00
  obtain ⟨R, hRp⟩ : ∃ R, (c.s.slot 1).add (BitVec.ofNat 64 (j.val * 2)) = R := ⟨_, rfl⟩
  have hs0 : Room S.mem R 16 := by
    have := c.sd_room hR.sd j.isLt (w := 0) (by decide)
    rwa [add_ofNat_zero, hRp] at this
  have hs1 : Room S.mem (R.add 16#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 1) (by decide)
  have hs2 : Room S.mem (R.add 32#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 2) (by decide)
  have hs3 : Room S.mem (R.add 48#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 3) (by decide)
  have hs4 : Room S.mem (R.add 64#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 4) (by decide)
  have hs5 : Room S.mem (R.add 80#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 5) (by decide)
  have hs6 : Room S.mem (R.add 96#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 6) (by decide)
  have hs7 : Room S.mem (R.add 112#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 7) (by decide)
  have hs8 : Room S.mem (R.add 128#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 8) (by decide)
  have hs9 : Room S.mem (R.add 144#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 9) (by decide)
  have hs10 : Room S.mem (R.add 160#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 10) (by decide)
  have hs11 : Room S.mem (R.add 176#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 11) (by decide)
  have hs12 : Room S.mem (R.add 192#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 12) (by decide)
  have hs13 : Room S.mem (R.add 208#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 13) (by decide)
  have hs14 : Room S.mem (R.add 224#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 14) (by decide)
  have hs15 : Room S.mem (R.add 240#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 15) (by decide)
  have hs16 : Room S.mem (R.add 256#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 16) (by decide)
  have hs17 : Room S.mem (R.add 272#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 17) (by decide)
  have hs18 : Room S.mem (R.add 288#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 18) (by decide)
  have hs19 : Room S.mem (R.add 304#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 19) (by decide)
  have hs20 : Room S.mem (R.add 320#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 20) (by decide)
  have hs21 : Room S.mem (R.add 336#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 21) (by decide)
  have hs22 : Room S.mem (R.add 352#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 22) (by decide)
  have hs23 : Room S.mem (R.add 368#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 23) (by decide)
  have hs24 : Room S.mem (R.add 384#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 24) (by decide)
  have hs25 : Room S.mem (R.add 400#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 25) (by decide)
  have hs26 : Room S.mem (R.add 416#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 26) (by decide)
  have hs27 : Room S.mem (R.add 432#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 27) (by decide)
  have hs28 : Room S.mem (R.add 448#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 28) (by decide)
  have hs29 : Room S.mem (R.add 464#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 29) (by decide)
  have hs30 : Room S.mem (R.add 480#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 30) (by decide)
  have hs31 : Room S.mem (R.add 496#64) 16 := hRp ▸ c.sd_room hR.sd j.isLt (w := 31) (by decide)
  have hRo (k : Nat) (hk : k ≤ 496) : ¬R.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    rw [← hRp]
    simp [Pointer.add, BitVec.uaddOverflow, Nat.mod_eq_of_lt (show j.val * 2 < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega)]
    omega
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hR hk2 hr2
  obtain ⟨E₁, hE₁⟩ : ∃ E₁, E₁ = E := ⟨E, rfl⟩
  have hrest : Hidden (EnvB c E₁ j) := ⟨hE₁ ▸ hE⟩
  clear hE
  split_reads hN
  show ((verify_x8 c.batch).runFrom E ⟨82, (by decide : 82 < 104)⟩ S >>= g) = K
  block_init
  -- `s[j][0]`
  step_pure [hjm, hP]
  step_load with b0
  subst hS
  have z0 := dig8_zero (c.sS j) (x := BitVec.setWidth 32 b0) (by rw [byte_eq, hb0])
  obtain ⟨z1, z2, z3, z4, z5, z6⟩ := z0
  step_pure
  step_pure [z1, z2]
  step_pure
  step_pure
  step_pure [z3]
  step_pure [z4]
  rw [z5, z6] at hE
  clear z1 z2 z3 z4 z5 z6
  step_pattern using runBodyFrom_dig8Run (c.sS j) 1 1
  step_pattern using runBodyFrom_dig8Run (c.sS j) 2 2
  step_pattern using runBodyFrom_dig8Run (c.sS j) 3 3
  step_pattern using runBodyFrom_dig8Run (c.sS j) 4 4
  step_pattern using runBodyFrom_dig8Run (c.sS j) 5 5
  step_pattern using runBodyFrom_dig8Run (c.sS j) 6 6
  step_pattern using runBodyFrom_dig8Run (c.sS j) 7 7
  step_pattern using runBodyFrom_dig8Run (c.sS j) 8 8
  step_pattern using runBodyFrom_dig8Run (c.sS j) 9 9
  step_pattern using runBodyFrom_dig8Run (c.sS j) 10 10
  -- the env rooted afresh
  subst hE₁
  have hB1 : EnvB c E j := by
    have h := hrest.out
    split_reads h
    dsimp only [EnvB]
    env_reads
  have hD1 : E ⊨ [rir_reg% hty 3818 := PoisonOr.value (recode8 (c.sS j) 0),
      rir_reg% hty 3827 := PoisonOr.value v3827,
      rir_reg% hty 3836 := PoisonOr.value v3836,
      rir_reg% hty 3845 := PoisonOr.value v3845,
      rir_reg% hty 3854 := PoisonOr.value v3854,
      rir_reg% hty 3863 := PoisonOr.value v3863,
      rir_reg% hty 3872 := PoisonOr.value v3872,
      rir_reg% hty 3881 := PoisonOr.value v3881,
      rir_reg% hty 3890 := PoisonOr.value v3890,
      rir_reg% hty 3899 := PoisonOr.value v3899,
      rir_reg% hty 3908 := PoisonOr.value v3908,
      rir_reg% hty 3905 := PoisonOr.value (carry8 (c.sS j) (10 + 1)),
      rir_reg% hty 3811 := PoisonOr.value P] := by
    env_reads
  clear hE hrest hN_0 hN_1 hN_2 hN_3 hN_4 hN_5 hN_6 hN_7 hN_8 hN_9 hN_10 hN_11 hN_12 hN_13
  obtain ⟨E₁, hE₁⟩ : ∃ E₁, E₁ = E := ⟨E, rfl⟩
  have hrest : Hidden (EnvB c E₁ j) := ⟨hE₁ ▸ hB1⟩
  have hN : Env82 c E j := by
    have h := hB1
    split_reads h
    dsimp only [Env82]
    env_reads
  clear hB1
  split_reads hN
  split_reads hD1
  step_pattern using runBodyFrom_dig8Run (c.sS j) 11 11
  step_pattern using runBodyFrom_dig8Run (c.sS j) 12 12
  step_pattern using runBodyFrom_dig8Run (c.sS j) 13 13
  step_pattern using runBodyFrom_dig8Run (c.sS j) 14 14
  step_pattern using runBodyFrom_dig8Run (c.sS j) 15 15
  step_pattern using runBodyFrom_dig8Run (c.sS j) 16 16
  step_pattern using runBodyFrom_dig8Run (c.sS j) 17 17
  step_pattern using runBodyFrom_dig8Run (c.sS j) 18 18
  step_pattern using runBodyFrom_dig8Run (c.sS j) 19 19
  step_pattern using runBodyFrom_dig8Run (c.sS j) 20 20
  -- the env rooted afresh
  subst hE₁
  have hB2 : EnvB c E j := by
    have h := hrest.out
    split_reads h
    dsimp only [EnvB]
    env_reads
  have hD2 : E ⊨ [rir_reg% hty 3818 := PoisonOr.value (recode8 (c.sS j) 0),
      rir_reg% hty 3827 := PoisonOr.value v3827,
      rir_reg% hty 3836 := PoisonOr.value v3836,
      rir_reg% hty 3845 := PoisonOr.value v3845,
      rir_reg% hty 3854 := PoisonOr.value v3854,
      rir_reg% hty 3863 := PoisonOr.value v3863,
      rir_reg% hty 3872 := PoisonOr.value v3872,
      rir_reg% hty 3881 := PoisonOr.value v3881,
      rir_reg% hty 3890 := PoisonOr.value v3890,
      rir_reg% hty 3899 := PoisonOr.value v3899,
      rir_reg% hty 3908 := PoisonOr.value v3908,
      rir_reg% hty 3917 := PoisonOr.value v3917,
      rir_reg% hty 3926 := PoisonOr.value v3926,
      rir_reg% hty 3935 := PoisonOr.value v3935,
      rir_reg% hty 3944 := PoisonOr.value v3944,
      rir_reg% hty 3953 := PoisonOr.value v3953,
      rir_reg% hty 3962 := PoisonOr.value v3962,
      rir_reg% hty 3971 := PoisonOr.value v3971,
      rir_reg% hty 3980 := PoisonOr.value v3980,
      rir_reg% hty 3989 := PoisonOr.value v3989,
      rir_reg% hty 3998 := PoisonOr.value v3998,
      rir_reg% hty 3995 := PoisonOr.value (carry8 (c.sS j) (20 + 1)),
      rir_reg% hty 3811 := PoisonOr.value P] := by
    env_reads
  clear hE hrest hN_0 hN_1 hN_2 hN_3 hN_4 hN_5 hN_6 hN_7 hN_8 hN_9 hN_10 hN_11 hN_12 hN_13 hD1_0
    hD1_1 hD1_2 hD1_3 hD1_4 hD1_5 hD1_6 hD1_7 hD1_8 hD1_9 hD1_10 hD1_11 hD1_12
  obtain ⟨E₁, hE₁⟩ : ∃ E₁, E₁ = E := ⟨E, rfl⟩
  have hrest : Hidden (EnvB c E₁ j) := ⟨hE₁ ▸ hB2⟩
  have hN : Env82 c E j := by
    have h := hB2
    split_reads h
    dsimp only [Env82]
    env_reads
  clear hB2
  split_reads hN
  split_reads hD2
  step_pattern using runBodyFrom_dig8Run (c.sS j) 21 21
  step_pattern using runBodyFrom_dig8Run (c.sS j) 22 22
  step_pattern using runBodyFrom_dig8Run (c.sS j) 23 23
  step_pattern using runBodyFrom_dig8Run (c.sS j) 24 24
  step_pattern using runBodyFrom_dig8Run (c.sS j) 25 25
  step_pattern using runBodyFrom_dig8Run (c.sS j) 26 26
  step_pattern using runBodyFrom_dig8Run (c.sS j) 27 27
  step_pattern using runBodyFrom_dig8Run (c.sS j) 28 28
  step_pattern using runBodyFrom_dig8Run (c.sS j) 29 29
  step_pattern using runBodyFrom_dig8Run (c.sS j) 30 30
  -- the env rooted afresh
  subst hE₁
  have hB3 : EnvB c E j := by
    have h := hrest.out
    split_reads h
    dsimp only [EnvB]
    env_reads
  have hD3 : E ⊨ [rir_reg% hty 3818 := PoisonOr.value (recode8 (c.sS j) 0),
      rir_reg% hty 3827 := PoisonOr.value v3827,
      rir_reg% hty 3836 := PoisonOr.value v3836,
      rir_reg% hty 3845 := PoisonOr.value v3845,
      rir_reg% hty 3854 := PoisonOr.value v3854,
      rir_reg% hty 3863 := PoisonOr.value v3863,
      rir_reg% hty 3872 := PoisonOr.value v3872,
      rir_reg% hty 3881 := PoisonOr.value v3881,
      rir_reg% hty 3890 := PoisonOr.value v3890,
      rir_reg% hty 3899 := PoisonOr.value v3899,
      rir_reg% hty 3908 := PoisonOr.value v3908,
      rir_reg% hty 3917 := PoisonOr.value v3917,
      rir_reg% hty 3926 := PoisonOr.value v3926,
      rir_reg% hty 3935 := PoisonOr.value v3935,
      rir_reg% hty 3944 := PoisonOr.value v3944,
      rir_reg% hty 3953 := PoisonOr.value v3953,
      rir_reg% hty 3962 := PoisonOr.value v3962,
      rir_reg% hty 3971 := PoisonOr.value v3971,
      rir_reg% hty 3980 := PoisonOr.value v3980,
      rir_reg% hty 3989 := PoisonOr.value v3989,
      rir_reg% hty 3998 := PoisonOr.value v3998,
      rir_reg% hty 4007 := PoisonOr.value v4007,
      rir_reg% hty 4016 := PoisonOr.value v4016,
      rir_reg% hty 4025 := PoisonOr.value v4025,
      rir_reg% hty 4034 := PoisonOr.value v4034,
      rir_reg% hty 4043 := PoisonOr.value v4043,
      rir_reg% hty 4052 := PoisonOr.value v4052,
      rir_reg% hty 4061 := PoisonOr.value v4061,
      rir_reg% hty 4070 := PoisonOr.value v4070,
      rir_reg% hty 4079 := PoisonOr.value v4079,
      rir_reg% hty 4088 := PoisonOr.value v4088,
      rir_reg% hty 4085 := PoisonOr.value (carry8 (c.sS j) (30 + 1)),
      rir_reg% hty 3811 := PoisonOr.value P] := by
    env_reads
  clear hE hrest hN_0 hN_1 hN_2 hN_3 hN_4 hN_5 hN_6 hN_7 hN_8 hN_9 hN_10 hN_11 hN_12 hN_13 hD2_0
    hD2_1 hD2_2 hD2_3 hD2_4 hD2_5 hD2_6 hD2_7 hD2_8 hD2_9 hD2_10 hD2_11 hD2_12 hD2_13 hD2_14 hD2_15
    hD2_16 hD2_17 hD2_18 hD2_19 hD2_20 hD2_21 hD2_22
  obtain ⟨E₁, hE₁⟩ : ∃ E₁, E₁ = E := ⟨E, rfl⟩
  have hrest : Hidden (EnvB c E₁ j) := ⟨hE₁ ▸ hB3⟩
  have hN : Env82 c E j := by
    have h := hB3
    split_reads h
    dsimp only [Env82]
    env_reads
  clear hB3
  split_reads hN
  split_reads hD3
  -- `s[j][31]`
  step_pure [show (0 : Int) ≤ 31 by decide, show (31 : Int).toNat = 31 by rfl,
    gep_value (f := { nusw := true, nuw := true }) hP31 (Or.inr (by decide))]
  step_load with b31
  subst hS
  have hC31 : carry8 (c.sS j) 31 ≤ 1#32 :=
    BitVec.le_def.2 (by simpa using carry8_le (c.sS j) 31)
  have d31 := dig8 _ _ 65280#32 hC31 (zext_le b31) (by decide)
  step_pure
  step_pure [d31]
  step_pure [d31]
  step_pure
  step_pure [d31]
  step_pure [d31]
  rw [(dig8_spec (c.sS j) 31 rfl (x := BitVec.setWidth 32 b31) (by rw [byte_eq, hb31])
    (by decide)).2] at hE
  clear d31
  -- the env rooted afresh
  subst hE₁
  have hB4 : EnvB c E j := by
    have h := hrest.out
    split_reads h
    dsimp only [EnvB]
    env_reads
  have hD4 : E ⊨ [rir_reg% hty 3818 := PoisonOr.value (recode8 (c.sS j) 0),
      rir_reg% hty 3827 := PoisonOr.value v3827,
      rir_reg% hty 3836 := PoisonOr.value v3836,
      rir_reg% hty 3845 := PoisonOr.value v3845,
      rir_reg% hty 3854 := PoisonOr.value v3854,
      rir_reg% hty 3863 := PoisonOr.value v3863,
      rir_reg% hty 3872 := PoisonOr.value v3872,
      rir_reg% hty 3881 := PoisonOr.value v3881,
      rir_reg% hty 3890 := PoisonOr.value v3890,
      rir_reg% hty 3899 := PoisonOr.value v3899,
      rir_reg% hty 3908 := PoisonOr.value v3908,
      rir_reg% hty 3917 := PoisonOr.value v3917,
      rir_reg% hty 3926 := PoisonOr.value v3926,
      rir_reg% hty 3935 := PoisonOr.value v3935,
      rir_reg% hty 3944 := PoisonOr.value v3944,
      rir_reg% hty 3953 := PoisonOr.value v3953,
      rir_reg% hty 3962 := PoisonOr.value v3962,
      rir_reg% hty 3971 := PoisonOr.value v3971,
      rir_reg% hty 3980 := PoisonOr.value v3980,
      rir_reg% hty 3989 := PoisonOr.value v3989,
      rir_reg% hty 3998 := PoisonOr.value v3998,
      rir_reg% hty 4007 := PoisonOr.value v4007,
      rir_reg% hty 4016 := PoisonOr.value v4016,
      rir_reg% hty 4025 := PoisonOr.value v4025,
      rir_reg% hty 4034 := PoisonOr.value v4034,
      rir_reg% hty 4043 := PoisonOr.value v4043,
      rir_reg% hty 4052 := PoisonOr.value v4052,
      rir_reg% hty 4061 := PoisonOr.value v4061,
      rir_reg% hty 4070 := PoisonOr.value v4070,
      rir_reg% hty 4079 := PoisonOr.value v4079,
      rir_reg% hty 4088 := PoisonOr.value v4088,
      rir_reg% hty 4096 := PoisonOr.value (recode8 (c.sS j) 31),
      rir_reg% hty 3811 := PoisonOr.value P] := by
    env_reads
  clear hE hrest hN_0 hN_1 hN_2 hN_3 hN_4 hN_5 hN_6 hN_7 hN_8 hN_9 hN_10 hN_11 hN_12 hN_13 hD3_0
    hD3_1 hD3_2 hD3_3 hD3_4 hD3_5 hD3_6 hD3_7 hD3_8 hD3_9 hD3_10 hD3_11 hD3_12 hD3_13 hD3_14 hD3_15
    hD3_16 hD3_17 hD3_18 hD3_19 hD3_20 hD3_21 hD3_22 hD3_23 hD3_24 hD3_25 hD3_26 hD3_27 hD3_28
    hD3_29 hD3_30 hD3_31 hD3_32
  obtain ⟨E₁, hE₁⟩ : ∃ E₁, E₁ = E := ⟨E, rfl⟩
  have hrest : Hidden (EnvB c E₁ j) := ⟨hE₁ ▸ hB4⟩
  have hN : Env82 c E j := by
    have h := hB4
    split_reads h
    dsimp only [Env82]
    env_reads
  clear hB4
  split_reads hN
  split_reads hD4
  -- `kd[w][j] = kj[w]`
  step_pure [hjm, Nat.mul_one]
  kd_perm_fact hkp
  step_pattern using runBodyFrom_kdStoreRun (hperm := hkp.out)
  clear hkp
  clear hfb00 hf2 hroomK hfb1 hfb2 hfb3 hfb4 hfb5 hfb6 hfb7 hfb8 hfb9 hfb10 hfb11 hfb12 hfb13 hfb14
    hfb15 hfb16 hfb17 hfb18 hfb19 hfb20 hfb21 hfb22 hfb23 hfb24 hfb25 hfb26 hfb27 hfb28 hfb29 hfb30
    hfb31 hP1 hP2 hP3 hP4 hP5 hP6 hP7 hP8 hP9 hP10 hP11 hP12 hP13 hP14 hP15 hP16 hP17 hP18 hP19
    hP20 hP21 hP22 hP23 hP24 hP25 hP26 hP27 hP28 hP29 hP30 hP31
  -- `sd[w][j] = sj[w]`
  step_pure [hjm, hRp]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 16 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 32 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 48 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 64 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 80 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 96 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 112 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 128 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 144 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 160 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 176 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 192 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 208 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 224 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 240 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 256 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 272 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 288 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 304 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 320 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 336 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 352 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 368 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 384 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 400 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 416 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 432 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 448 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 464 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 480 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure [gep_value (f := { nusw := true, nuw := true }) (hRo 496 (by decide))
    (Or.inr (by decide))]
  step_store
  clear_stored
  step_pure
  obtain ⟨hi1, hi2, hi3⟩ := rj_inc j.isLt
  step_pure [hi1, hi2, hi3]
  step_pure
  -- the column's memory
  subst hS₀
  subst hRp
  have hm : S.mem = c.colMem j S₀.mem := by
    rw [hS]
    simp only [Call.colMem, sdStores, Nat.mul_zero, add_ofNat_zero, Nat.reduceMul]
    rfl
  have hR' := hR.col hm hwf (by rw [hS])
  clear hS hm hR
  subst hE₁
  have hrest' := hrest.out
  clear hrest
  split_reads hrest'
  finish_block
  · rw [rj_exit j.isLt] at hbr
    exact hexit hbr E S hArgs (by dsimp only [Env79]; env_reads) (hbr ▸ hR')
  · rw [rj_exit j.isLt] at hbr
    exact hback (by omega) E S hArgs (by dsimp only [EnvB]; env_reads) hR'

/-- `^bb80` at lane `j`: `kj` started, on to `^bb81` at digit `0`. -/
theorem rk_head (c : Call) (j : Fin 8) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hE : EnvB c E j) (hR : c.Rec j S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvB c E' j → EnvK c E' j 0 →
        c.Rec j S' → c.K2 j 0 S'.mem → Room S'.mem (c.s.slot 2) 512 →
          ((verify_x8 c.batch).runFrom E' 81 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 80 S >>= g) = K := by
  have hjm : j.val % 18446744073709551616 = j.val := Nat.mod_eq_of_lt (by omega)
  obtain ⟨hR', hr2⟩ := hR.start2
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hR' hr2 hR
  obtain ⟨E₁, hE₁⟩ : ∃ E₁, E₁ = E := ⟨E, rfl⟩
  have hrest : Hidden (EnvB c E₁ j) := ⟨hE₁ ▸ hE⟩
  have hN : E ⊨ [%61 := PoisonOr.value 0#32, %66 := PoisonOr.value 0#64,
      %137 := PoisonOr.value (c.s.slot 2), %161 := PoisonOr.value (c.s.slot 26),
      rir_reg% hty 3760 := PoisonOr.value (BitVec.ofNat 64 j.val)] := by
    have h := hE
    split_reads h
    env_reads
  clear hE
  split_reads hN
  show ((verify_x8 c.batch).runFrom E ⟨80, (by decide : 80 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  step_pure [hjm]
  subst hS₀
  subst hE₁
  have hrest' := hrest.out
  clear hrest
  split_reads hrest'
  finish_block
  subst hS
  exact hK E _ hArgs (by dsimp only [EnvB]; env_reads) (by dsimp only [EnvK]; env_reads) hR'
    (fun w hw => absurd hw (by omega)) hr2

/-- The digit loop at `^bb81` from digit `4 t`, `n + 1` rounds left: on to `^bb82` with `kj`. -/
theorem rk_loop (c : Call) (j : Fin 8)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvB c E' j → c.Rec j S' →
        c.K2 j 64 S'.mem → Room S'.mem (c.s.slot 2) 512 →
          ((verify_x8 c.batch).runFrom E' 82 S' >>= g) = K) :
    ∀ n t (E : ⟪Γ⟫) (S : GlobalState), t + n + 1 = 16 → E.args = c.args → EnvB c E j →
      EnvK c E j t → c.Rec j S → c.K2 j (4 * t) S.mem → Room S.mem (c.s.slot 2) 512 →
        ((verify_x8 c.batch).runFrom E 81 S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro t E S hn hA hE hK hR hk2 hr2
    exact rk_trip c j t (by omega) E S hA hE hK hR hk2 hr2 (fun h => absurd h (by omega))
      fun _ => hexit
  | succ n ih =>
    intro t E S hn hA hE hK hR hk2 hr2
    exact rk_trip c j t (by omega) E S hA hE hK hR hk2 hr2
      (fun _ E' S' h1 h2 h3 h4 h5 h6 => ih (t + 1) E' S' (by omega) h1 h2 h3 h4 h5 h6)
      fun h => absurd h (by omega)

/-- The lane loop at `^bb80` from lane `j`, `n + 1` lanes left: on to `^bb79` with `kd`, `sd`. -/
theorem rec_loop (c : Call)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env79 c E' → c.Rec 8 S' →
        ((verify_x8 c.batch).runFrom E' 79 S' >>= g) = K) :
    ∀ n (j : Fin 8) (E : ⟪Γ⟫) (S : GlobalState), j.val + n + 1 = 8 → E.args = c.args →
      EnvB c E j → c.Rec j S → ((verify_x8 c.batch).runFrom E 80 S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro j E S hn hA hE hR
    refine rk_head c j E S hA hE hR fun E S hA hE hK hR hk2 hr2 => ?_
    refine rk_loop c j (fun E S hA hE hR hk2 hr2 => ?_) 15 0 E S rfl hA hE hK hR hk2 hr2
    exact rs_block c j E S hA hE hR hk2 hr2 (fun h => absurd h (by omega))
      fun h => h ▸ hexit
  | succ n ih =>
    intro j E S hn hA hE hR
    refine rk_head c j E S hA hE hR fun E S hA hE hK hR hk2 hr2 => ?_
    refine rk_loop c j (fun E S hA hE hR hk2 hr2 => ?_) 15 0 E S rfl hA hE hK hR hk2 hr2
    exact rs_block c j E S hA hE hR hk2 hr2
      (fun _ E' S' h1 h2 h3 => ih ⟨j.val + 1, by omega⟩ E' S' (by simp; omega) h1 h2 h3)
      fun h => absurd h (by omega)

/-- The loop at `^bb80`: `kd` and `sd`. -/
public theorem recode_run (c : Call) (_hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : Env80 c E) (hS : c.At80 S)
    (h79 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env79 c E' → c.At79 S' →
        ((verify_x8 c.batch).runFrom E' 79 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 80 S >>= g) = K :=
  rec_loop c (fun E' S' hA' hE' hR => h79 E' S' hA' hE' hR.at79) 7 0 E S rfl hA hE
    ⟨hS.base, hS.ks, hS.a, hS.r, hS.kd, hS.sd, fun i hi => absurd hi (by omega),
      fun i hi => absurd hi (by omega)⟩

end MLIR.Firedancer.Lane.VerifyX8
