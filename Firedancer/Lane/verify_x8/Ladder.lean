module

public import Firedancer.Lane.verify_x8.Defs
public import Firedancer.Lane.verify_x8.Lanes
public import Firedancer.Lane.verify_x8.Tactics
public import Firedancer.Lane.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.fd_ed25519_lane_point_add_sel

/-! `fd_ed25519_lane_verify`'s windows inlined into `verify_x8` (`^bb83 … ^bb87`): from `w = 63`
down, four doublings (none at the top), the `[k]` digit's entry picked from `ktab` by
`fd_ed25519_lane_point_add_sel`, and at even `w` the `[S]` digit's from the base table. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

@[expose] public section

/-- `^bb83`'s registers at window `w`. -/
abbrev EnvW (c : Call) (E : ⟪Γ⟫) (w : Nat) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 :=
    PoisonOr.value 10#64, %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate
    8 0#32), %45 := Ty.wrap (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32,
    4#32, 5#32, 6#32, 7#32], %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %57 := PoisonOr.value 63#64, %61 := PoisonOr.value 0#32, %62 :=
    PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64, %69 :=
    PoisonOr.value 8#64, %72 := PoisonOr.value 3#64, %76 := PoisonOr.value 5#64, %78 :=
    PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %85 := PoisonOr.value 64#64, %88 :=
    PoisonOr.value 1#64, %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 :=
    PoisonOr.value 640#64, %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap
    (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64), %102 :=
    Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap
    (Vector.replicate 8 51#64), %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64), %109 :=
    Ty.wrap (Vector.replicate 8 4503599627370494#64), %110 := Ty.wrap (Vector.replicate 8
    2251799813685229#64), %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap
    (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32,
    8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16
    16#32), %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0), %136 :=
    PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value (c.s.slot 3), %139 := PoisonOr.value
    (c.s.slot 4), %146 := PoisonOr.value (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14), %150 :=
    PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value
    (c.s.slot 27), %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 :=
    PoisonOr.value (c.s.slot 32), rir_reg% hty 2040 := PoisonOr.value (c.liveMask),
    rir_reg% hty 3727 := PoisonOr.value ((c.s.slot 11).add 640#64), rir_reg% hty 3728 :=
    PoisonOr.value ((c.s.slot 11).add 320#64), rir_reg% hty 3730 := PoisonOr.value ((c.s.slot
    11).add 704#64), rir_reg% hty 3731 := PoisonOr.value ((c.s.slot 11).add 384#64),
    rir_reg% hty 3732 := PoisonOr.value ((c.s.slot 12).add 8#64), rir_reg% hty 3733 :=
    PoisonOr.value ((c.s.slot 13).add 8#64), rir_reg% hty 3734 := PoisonOr.value ((c.s.slot 14).add
    8#64), rir_reg% hty 3735 := PoisonOr.value ((c.s.slot 15).add 8#64), rir_reg% hty 3736 :=
    PoisonOr.value ((c.s.slot 12).add 16#64), rir_reg% hty 3737 := PoisonOr.value ((c.s.slot 13).add
    16#64), rir_reg% hty 3738 := PoisonOr.value ((c.s.slot 14).add 16#64), rir_reg% hty 3739 :=
    PoisonOr.value ((c.s.slot 15).add 16#64), rir_reg% hty 3740 := PoisonOr.value ((c.s.slot 12).add
    24#64), rir_reg% hty 3741 := PoisonOr.value ((c.s.slot 13).add 24#64), rir_reg% hty 3742 :=
    PoisonOr.value ((c.s.slot 14).add 24#64), rir_reg% hty 3743 := PoisonOr.value ((c.s.slot 15).add
    24#64), rir_reg% hty 3744 := PoisonOr.value ((c.s.slot 12).add 32#64), rir_reg% hty 3745 :=
    PoisonOr.value ((c.s.slot 13).add 32#64), rir_reg% hty 3746 := PoisonOr.value ((c.s.slot 14).add
    32#64), rir_reg% hty 3747 := PoisonOr.value ((c.s.slot 15).add 32#64), rir_reg% hty 3748 :=
    PoisonOr.value ((c.s.slot 12).add 40#64), rir_reg% hty 3749 := PoisonOr.value ((c.s.slot 13).add
    40#64), rir_reg% hty 3750 := PoisonOr.value ((c.s.slot 14).add 40#64), rir_reg% hty 3751 :=
    PoisonOr.value ((c.s.slot 15).add 40#64), rir_reg% hty 3752 := PoisonOr.value ((c.s.slot 12).add
    48#64), rir_reg% hty 3753 := PoisonOr.value ((c.s.slot 13).add 48#64), rir_reg% hty 3754 :=
    PoisonOr.value ((c.s.slot 14).add 48#64), rir_reg% hty 3755 := PoisonOr.value ((c.s.slot 15).add
    48#64), rir_reg% hty 3756 := PoisonOr.value ((c.s.slot 12).add 56#64), rir_reg% hty 3757 :=
    PoisonOr.value ((c.s.slot 13).add 56#64), rir_reg% hty 3758 := PoisonOr.value ((c.s.slot 14).add
    56#64), rir_reg% hty 3759 := PoisonOr.value ((c.s.slot 15).add 56#64), rir_reg% hty 4134 :=
    PoisonOr.value (BitVec.ofNat 64 w)]

/-- The state at `^bb83` and `^bb85` with `acc = P`. -/
structure Call.AtW (c : Call) (S : GlobalState) (P : Point) : Prop where
  base : c.Base S c.mem76
  kd_fits : Fits S.mem (c.s.slot 0) 4096
  kd_read : S.mem.readAt (c.s.slot 0) 4096 = c.kdBits
  sd_fits : Fits S.mem (c.s.slot 1) 4096
  sd_read : S.mem.readAt (c.s.slot 1) 4096 = c.sdBits
  tab_fits : Fits S.mem (c.s.slot 3) (64 * 1800)
  tab_read : S.mem.readAt (c.s.slot 3) (64 * 1800) = c.tabBits
  acc : c.PointAt S 11 P
  r : c.PointAt S 29 c.decR.1

end

set_option hygiene false in
/-- `atw_facts`: the facts of `hW : c.AtW S P` the steps carry, then `hW` frozen at `S₀`. -/
macro "atw_facts" : tactic =>
  `(tactic|
    ( have hwf := hW.base.wf
      have hacc := hW.acc.fit
      have hacc_read := hW.acc.read
      have hacc_room : S.mem.LanePointRoom (c.s.slot 11) :=
        hW.acc.fit.room (hW.base.writable 11 (by decide))
      have hacc_t := hW.acc.fit.fit_t
      have hkdf := hW.kd_fits
      have hkdr := hW.kd_read
      have hsdf := hW.sd_fits
      have hsdr := hW.sd_read
      have htabf := hW.tab_fits
      have htabr := hW.tab_read
      have htbl_lt := hW.base.tbl_lt
      have hrf := hW.r.fit
      have hrr := hW.r.read
      obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
      rw [← hS₀] at hW))


/-- The `[k]` add as the call leaves it. -/
theorem kadd_eq (c : Call) {w : Nat} (hw : w < 64) (P : Point) :
    P.addQ (selK c.tab fun j => (c.kdRow w)[j.val]).1 (selK c.tab fun j => (c.kdRow w)[j.val]).2.1
        (selK c.tab fun j => (c.kdRow w)[j.val]).2.2.1
        (selK c.tab fun j => (c.kdRow w)[j.val]).2.2.2 (decide False)
        (decide (BitVec.ofNat 32 w &&& 1#32 ^^^ 1#32 ≠ 0#32)) P.t =
      c.kadd w P := by
  simp only [Call.kadd, Call.kdRow, Vector.getElem_ofFn, decide_false, withT_eq hw]

/-- The `[S]` add as the call leaves it. -/
theorem sadd_eq (c : Call) (w : Nat) (P : Point) (qz : Fe) :
    P.addQ (selB lc.tbl fun j => (c.sdRow (w / 2))[j.val]).1
        (selB lc.tbl fun j => (c.sdRow (w / 2))[j.val]).2.1
        (selB lc.tbl fun j => (c.sdRow (w / 2))[j.val]).2.2 qz (decide True) (decide False)
        P.t =
      c.sadd w P := by
  simp only [Call.sadd, Call.sdRow, Vector.getElem_ofFn, Point.addQ]
  simp

/-- The window counter's exit test. -/
theorem counter_zero {w : Nat} (hw : w < 64) (h : BitVec.ofNat 64 w = 0#64) : w = 0 := by
  revert w; decide

/-- The window counter's test failing: another window. -/
theorem counter_ne_zero {w : Nat} (h : ¬BitVec.ofNat 64 w = 0#64) : w ≠ 0 := by
  rintro rfl; exact h rfl

/-- `w--` does not overflow. -/
theorem counter_sadd {w : Nat} (hw : w < 64) :
    (BitVec.ofNat 64 w).saddOverflow 18446744073709551615#64 = false := by
  revert w; decide

/-- `w--`. -/
theorem counter_dec {w : Nat} (hw : w < 64) (h : w ≠ 0) :
    BitVec.ofNat 64 w + 18446744073709551615#64 = BitVec.ofNat 64 (w - 1) := by
  revert w; decide

attribute [local mlir_read] MemoryState.readFe_storeLanePoint_t MemoryState.readFe_storePtr_of_id_ne
  MemoryState.readLanePoint_storePtr_of_id_ne MemoryState.readVec_storePtr_of_id_ne

attribute [local mlir_transport] MemoryState.FeFit.storePtr_of_id_ne
  MemoryState.LanePointFit.storePtr_of_id_ne MemoryState.LanePointRoom.storePtr

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

-- 50 steps and three calls on a 5000-instruction function
set_option maxHeartbeats 0 in
/-- `^bb85` at window `w` with `acc = P`: the four arrays started, the `[k]` digits' pointers and
the `[k]` add; on to `^bb86` at even `w`, else `^bb87`. -/
theorem kpart (c : Call) (w : Nat) (hw : w < 64) (P : Point) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvW c E w) (hW : c.AtW S P)
    (hK86 :
      w % 2 = 0 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvW c E' w →
        c.AtW S' (c.kadd w P) → Room S'.mem (c.s.slot 12) 512 → Room S'.mem (c.s.slot 13) 512 →
        Room S'.mem (c.s.slot 14) 512 → ((verify_x8 c.batch).runFrom E' 86 S' >>= g) = K)
    (hK87 :
      w % 2 ≠ 0 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvW c E' w →
        c.AtW S' (c.kadd w P) → ((verify_x8 c.batch).runFrom E' 87 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 85 S >>= g) = K := by
  have hacc_tr : S.mem.readFe ((c.s.slot 11).add 960#64) = P.t := by
    rw [← hW.acc.read]; rfl
  have h12 := hW.base.slots 12 (by decide)
  have h13 := hW.base.slots 13 (by decide)
  have h14 := hW.base.slots 14 (by decide)
  have h15 := hW.base.slots 15 (by decide)
  have hw12 := hW.base.writable 12 (by decide)
  have hw13 := hW.base.writable 13 (by decide)
  have hw14 := hW.base.writable 14 (by decide)
  have hw15 := hW.base.writable 15 (by decide)
  simp only [slotBytes, List.getElem_cons_succ, List.getElem_cons_zero] at h12 h13 h14 h15
  obtain ⟨hrow_f, hrow⟩ := kd_row hW.kd_fits hW.kd_read hw
  atw_facts
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨85, (by decide : 85 < 104)⟩ S >>= g) = K
  block_init
  -- the four arrays' lifetimes; `kd[w]`
  step_pure
  clear h12 hw12
  step_pure
  clear h13 hw13
  step_pure
  clear h14 hw14
  step_pure
  clear h15 hw15
  step_pure [Nat.mod_eq_of_lt (show w < 2 ^ 64 by omega)]
  step_load with dv
  -- sp[j] … sz[j] = &ktab[|d|][j] + …
  step_pattern using runBodyFrom_kLane0Run
  step_pattern using runBodyFrom_kLaneRun 1 8 328 1288
  step_pattern using runBodyFrom_kLaneRun 2 16 336 1296
  step_pattern using runBodyFrom_kLaneRun 3 24 344 1304
  step_pattern using runBodyFrom_kLaneRun 4 32 352 1312
  step_pattern using runBodyFrom_kLaneRun 5 40 360 1320
  step_pattern using runBodyFrom_kLaneRun 6 48 368 1328
  step_pattern using runBodyFrom_kLaneRun 7 56 376 1336
  -- with_t = !(w & 1)
  step_pure [(trunc_small (show w < 2 ^ 31 by omega)).1, (trunc_small (show w < 2 ^ 31 by omega)).2]
  step_pure
  step_pure
  step_pure
  have hdD : ∀ j : Fin 8, dv[j.val].toInt.natAbs ≤ 8 := by rw [hdv]; exact kdRow_le c w
  grab hr12 : Room S.mem (c.s.slot 12) (8 * 64)
  grab_ptr hP0 : c.s.slot 12
  grab_ptr hP1 : (c.s.slot 12).add 8#64
  grab_ptr hP2 : (c.s.slot 12).add 16#64
  grab_ptr hP3 : (c.s.slot 12).add 24#64
  grab_ptr hP4 : (c.s.slot 12).add 32#64
  grab_ptr hP5 : (c.s.slot 12).add 40#64
  grab_ptr hP6 : (c.s.slot 12).add 48#64
  grab_ptr hP7 : (c.s.slot 12).add 56#64
  grab hr13 : Room S.mem (c.s.slot 13) (8 * 64)
  grab_ptr hM0 : c.s.slot 13
  grab_ptr hM1 : (c.s.slot 13).add 8#64
  grab_ptr hM2 : (c.s.slot 13).add 16#64
  grab_ptr hM3 : (c.s.slot 13).add 24#64
  grab_ptr hM4 : (c.s.slot 13).add 32#64
  grab_ptr hM5 : (c.s.slot 13).add 40#64
  grab_ptr hM6 : (c.s.slot 13).add 48#64
  grab_ptr hM7 : (c.s.slot 13).add 56#64
  grab hr14 : Room S.mem (c.s.slot 14) (8 * 64)
  grab_ptr hK0 : c.s.slot 14
  grab_ptr hK1 : (c.s.slot 14).add 8#64
  grab_ptr hK2 : (c.s.slot 14).add 16#64
  grab_ptr hK3 : (c.s.slot 14).add 24#64
  grab_ptr hK4 : (c.s.slot 14).add 32#64
  grab_ptr hK5 : (c.s.slot 14).add 40#64
  grab_ptr hK6 : (c.s.slot 14).add 48#64
  grab_ptr hK7 : (c.s.slot 14).add 56#64
  grab hr15 : Room S.mem (c.s.slot 15) (8 * 64)
  grab_ptr hZ0 : c.s.slot 15
  grab_ptr hZ1 : (c.s.slot 15).add 8#64
  grab_ptr hZ2 : (c.s.slot 15).add 16#64
  grab_ptr hZ3 : (c.s.slot 15).add 24#64
  grab_ptr hZ4 : (c.s.slot 15).add 32#64
  grab_ptr hZ5 : (c.s.slot 15).add 40#64
  grab_ptr hZ6 : (c.s.slot 15).add 48#64
  grab_ptr hZ7 : (c.s.slot 15).add 56#64
  have hsP : S.mem.PtrArray (c.s.slot 12) (kP (c.s.slot 3) dv) :=
    ptrArray_of rfl hr12.inBounds hP0 hP1 hP2 hP3 hP4 hP5 hP6 hP7
  have hsM : S.mem.PtrArray (c.s.slot 13) (kM (c.s.slot 3) dv) :=
    ptrArray_of rfl hr13.inBounds hM0 hM1 hM2 hM3 hM4 hM5 hM6 hM7
  have hsK : S.mem.PtrArray (c.s.slot 14) (kK (c.s.slot 3) dv) :=
    ptrArray_of rfl hr14.inBounds hK0 hK1 hK2 hK3 hK4 hK5 hK6 hK7
  have hsZ : S.mem.PtrArray (c.s.slot 15) (kZ (c.s.slot 3) dv) :=
    ptrArray_of rfl hr15.inBounds hZ0 hZ1 hZ2 hZ3 hZ4 hZ5 hZ6 hZ7
  clear hP0 hP1 hP2 hP3 hP4 hP5 hP6 hP7 hM0 hM1 hM2 hM3 hM4 hM5 hM6 hM7 hK0 hK1 hK2 hK3 hK4 hK5
    hK6 hK7 hZ0 hZ1 hZ2 hZ3 hZ4 hZ5 hZ6 hZ7
  obtain ⟨hpP, hpM, hpK, hpZ⟩ := kPick_eq htabf htabr hdD
  -- fd_ed25519_lane_point_add_sel( &acc, &acc, sp, sm, sk, sz, 8UL, 1, 0, !(w&1) )
  step_call using (_root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel.call_eq
    (P := kP (c.s.slot 3) dv) (M := kM (c.s.slot 3) dv) (K := kK (c.s.slot 3) dv)
    (Z := kZ (c.s.slot 3) dv) (hsp := hsP) (hsm := hsM) (hsk := hsK) (hsz := fun _ => hsZ)
    (hP := kP_fit rfl htabf hdD) (hM := kM_fit rfl htabf hdD) (hK := kK_fit rfl htabf hdD)
    (hZ := fun _ => kZ_fit rfl htabf hdD) (ht := fun _ => hacc_t)) consuming hsP hsM hsK hsZ
  grab hacc_r : S.mem.readLanePoint (c.s.slot 11) = _
  simp only at hpP hpM hpK hpZ hacc_r
  rw [hpP, hpM, hpK, hpZ, hdv, kadd_eq c hw P] at hacc_r
  have hAt : c.AtW S (c.kadd w P) := by
    subst hS₀
    exact ⟨hW.base.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS]), hkdf, hkdr,
      hsdf, hsdr, htabf, htabr, ⟨hacc, hacc_r⟩, ⟨hrf, hrr⟩⟩
  finish_block
  · exact hK86 ((even_iff (by omega)).1 hbr) E S hArgs (by dsimp only [EnvW]; env_reads) hAt
      hr12 hr13 hr14
  · exact hK87 (fun h => hbr ((even_iff (by omega)).2 h)) E S hArgs
      (by dsimp only [EnvW]; env_reads) hAt

-- 40 steps and a call on a 5000-instruction function
set_option maxHeartbeats 0 in
/-- `^bb86` at even window `w` with `acc = P`, the arrays started: the `[S]` digits' pointers into
the base table and the `[S]` add; on to `^bb87`. -/
theorem spart (c : Call) (w : Nat) (hw : w < 64) (hev : w % 2 = 0) (P : Point) (E : ⟪Γ⟫)
    (S : GlobalState) (hA : E.args = c.args) (hE : EnvW c E w) (hW : c.AtW S P)
    (h12 : Room S.mem (c.s.slot 12) 512) (h13 : Room S.mem (c.s.slot 13) 512)
    (h14 : Room S.mem (c.s.slot 14) 512)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvW c E' w →
        c.AtW S' (c.sadd w P) → ((verify_x8 c.batch).runFrom E' 87 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 86 S >>= g) = K := by
  obtain ⟨hsrow_f, hsrow⟩ := sd_row hW.sd_fits hW.sd_read (v := w / 2) (by omega)
  have hacc_tr : S.mem.readFe ((c.s.slot 11).add 960#64) = P.t := by
    rw [← hW.acc.read]; rfl
  atw_facts
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨86, (by decide : 86 < 104)⟩ S >>= g) = K
  block_init
  -- d = sd[w>>1][j]
  step_pure [lsb_zero (by omega) hev]
  step_pure [half_mask (by omega)]
  step_pure [Nat.mod_eq_of_lt (show w / 2 < 2 ^ 64 by omega)]
  step_load with sv
  -- sp[j] … sk[j] = fd_ed25519_lane_base_table + 20 |d| + …
  step_pattern using runBodyFrom_bLane0Run
  step_pattern using runBodyFrom_bLaneRun 1
  step_pattern using runBodyFrom_bLaneRun 2
  step_pattern using runBodyFrom_bLaneRun 3
  step_pattern using runBodyFrom_bLaneRun 4
  step_pattern using runBodyFrom_bLaneRun 5
  step_pattern using runBodyFrom_bLaneRun 6
  step_pattern using runBodyFrom_bLaneRun 7
  have hsD : ∀ j : Fin 8, sv[j.val].toInt.natAbs ≤ 128 := by rw [hsv]; exact sdRow_le c (w / 2)
  grab hr12 : Room S.mem (c.s.slot 12) (8 * 64)
  grab_ptr hP0 : c.s.slot 12
  grab_ptr hP1 : (c.s.slot 12).add 8#64
  grab_ptr hP2 : (c.s.slot 12).add 16#64
  grab_ptr hP3 : (c.s.slot 12).add 24#64
  grab_ptr hP4 : (c.s.slot 12).add 32#64
  grab_ptr hP5 : (c.s.slot 12).add 40#64
  grab_ptr hP6 : (c.s.slot 12).add 48#64
  grab_ptr hP7 : (c.s.slot 12).add 56#64
  grab hr13 : Room S.mem (c.s.slot 13) (8 * 64)
  grab_ptr hM0 : c.s.slot 13
  grab_ptr hM1 : (c.s.slot 13).add 8#64
  grab_ptr hM2 : (c.s.slot 13).add 16#64
  grab_ptr hM3 : (c.s.slot 13).add 24#64
  grab_ptr hM4 : (c.s.slot 13).add 32#64
  grab_ptr hM5 : (c.s.slot 13).add 40#64
  grab_ptr hM6 : (c.s.slot 13).add 48#64
  grab_ptr hM7 : (c.s.slot 13).add 56#64
  grab hr14 : Room S.mem (c.s.slot 14) (8 * 64)
  grab_ptr hK0 : c.s.slot 14
  grab_ptr hK1 : (c.s.slot 14).add 8#64
  grab_ptr hK2 : (c.s.slot 14).add 16#64
  grab_ptr hK3 : (c.s.slot 14).add 24#64
  grab_ptr hK4 : (c.s.slot 14).add 32#64
  grab_ptr hK5 : (c.s.slot 14).add 40#64
  grab_ptr hK6 : (c.s.slot 14).add 48#64
  grab_ptr hK7 : (c.s.slot 14).add 56#64
  have hsP : S.mem.PtrArray (c.s.slot 12) (bP c.tbl sv) :=
    ptrArray_of rfl hr12.inBounds hP0 hP1 hP2 hP3 hP4 hP5 hP6 hP7
  have hsM : S.mem.PtrArray (c.s.slot 13) (bM c.tbl sv) :=
    ptrArray_of rfl hr13.inBounds hM0 hM1 hM2 hM3 hM4 hM5 hM6 hM7
  have hsK : S.mem.PtrArray (c.s.slot 14) (bK c.tbl sv) :=
    ptrArray_of rfl hr14.inBounds hK0 hK1 hK2 hK3 hK4 hK5 hK6 hK7
  clear hP0 hP1 hP2 hP3 hP4 hP5 hP6 hP7 hM0 hM1 hM2 hM3 hM4 hM5 hM6 hM7 hK0 hK1 hK2 hK3 hK4 hK5
    hK6 hK7
  have hbase : c.Base S c.mem76 := by
    subst hS₀
    exact hW.base.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS])
  have htblf := hbase.tbl_fits
  have htblr := hbase.tbl_read
  clear hbase
  obtain ⟨hpP, hpM, hpK⟩ := bPick_eq htblf htblr hsD
  -- fd_ed25519_lane_point_add_sel( &acc, &acc, sp, sm, sk, sz, 1UL, 0, 1, 0 )
  step_call using (_root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add_sel.call_eq
    (P := bP c.tbl sv) (M := bM c.tbl sv) (K := bK c.tbl sv) (Z := fun _ => c.tbl)
    (hsp := hsP) (hsm := hsM) (hsk := hsK) (hsz := fun h => absurd h (by decide))
    (hP := bP_fit htblf hsD) (hM := bM_fit htblf hsD) (hK := bK_fit htblf hsD)
    (hZ := fun h => absurd h (by decide)) (ht := fun _ => hacc_t)) consuming hsP hsM hsK
  grab hacc_r : S.mem.readLanePoint (c.s.slot 11) = _
  simp only at hpP hpM hpK hacc_r
  rw [hpP, hpM, hpK, hsv, sadd_eq] at hacc_r
  have hAt : c.AtW S (c.sadd w P) := by
    subst hS₀
    exact ⟨hW.base.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS]), hkdf, hkdr,
      hsdf, hsdr, htabf, htabr, ⟨hacc, hacc_r⟩, ⟨hrf, hrr⟩⟩
  finish_block
  exact hK E S hArgs (by dsimp only [EnvW]; env_reads) hAt

-- four lifetime ends and the counter
set_option maxHeartbeats 0 in
/-- `^bb87` at window `w` with `acc = Q`: the arrays end, `w--`; on to the next window's header,
or after `w = 0` to `^bb88`. -/
theorem bb87_run (c : Call) (w : Nat) (hw : w < 64) (Q : Point) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvW c E w) (hW : c.AtW S Q)
    (hback :
      0 < w → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvW c E' (w - 1) →
        c.AtW S' Q → ((verify_x8 c.batch).runFrom E' 83 S' >>= g) = K)
    (hexit :
      w = 0 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env88 c E' →
        c.AtW S' Q → ((verify_x8 c.batch).runFrom E' 88 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 87 S >>= g) = K := by
  atw_facts
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨87, (by decide : 87 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [counter_sadd hw]
  step_pure
  grab hacc_r : S.mem.readLanePoint (c.s.slot 11) = _
  have hAt : c.AtW S Q := by
    subst hS₀
    exact ⟨hW.base.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS]), hkdf, hkdr,
      hsdf, hsdr, htabf, htabr, ⟨hacc, hacc_r⟩, ⟨hrf, hrr⟩⟩
  finish_block
  · exact hexit (counter_zero hw hbr) E S hArgs (by dsimp only [Env88]; env_reads) hAt
  · refine hback (by have := counter_ne_zero hbr; omega) E S hArgs ?_ hAt
    dsimp only [EnvW]
    rw [counter_dec hw (counter_ne_zero hbr)] at *
    env_reads

-- four calls, then the window's tail
set_option maxHeartbeats 0 in
/-- `^bb83` at window `w` with `acc = P`: `window w` (four doublings below the top), on to the next
window's header, or after `w = 0` to `^bb88`. -/
theorem window_trip (c : Call) (w : Nat) (hw : w < 64) (P : Point) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvW c E w) (hW : c.AtW S P)
    (hback :
      0 < w → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → EnvW c E' (w - 1) →
        c.AtW S' (window c.tab lc.tbl c.kS c.sS w P) →
        ((verify_x8 c.batch).runFrom E' 83 S' >>= g) = K)
    (hexit :
      w = 0 → ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env88 c E' →
        c.AtW S' (window c.tab lc.tbl c.kS c.sS w P) →
        ((verify_x8 c.batch).runFrom E' 88 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 83 S >>= g) = K := by
  -- the window's tail from `acc = P'`, `P'` after the doublings
  have tail (P' : Point) (hP' : P' = if w = 63 then P else dbl4 P) (E : ⟪Γ⟫) (S : GlobalState)
      (hA : E.args = c.args) (hE : EnvW c E w) (hW : c.AtW S P') :
      ((verify_x8 c.batch).runFrom E 85 S >>= g) = K := by
    have hwin : window c.tab lc.tbl c.kS c.sS w P = c.wtail w P' := by rw [window_eq, hP']
    refine kpart c w hw P' E S hA hE hW ?_ ?_
    · intro hev E S hA hE hW h12 h13 h14
      refine spart c w hw hev _ E S hA hE hW h12 h13 h14 fun E S hA hE hW => ?_
      have hQ : c.sadd w (c.kadd w P') = window c.tab lc.tbl c.kS c.sS w P := by
        rw [hwin, Call.wtail]; simp only [hev, ite_true]
      rw [hQ] at hW
      exact bb87_run c w hw _ E S hA hE hW hback hexit
    · intro hodd E S hA hE hW
      have hQ : c.kadd w P' = window c.tab lc.tbl c.kS c.sS w P := by
        rw [hwin, Call.wtail]; simp only [hodd, ite_false]
      rw [hQ] at hW
      exact bb87_run c w hw _ E S hA hE hW hback hexit
  have hacc_tr : S.mem.readFe ((c.s.slot 11).add 960#64) = P.t := by
    rw [← hW.acc.read]; rfl
  atw_facts
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨83, (by decide : 83 < 104)⟩ S >>= g) = K
  block_init
  -- if( w!=63 )
  step_pure
  finish_block
  · have h63 : w = 63 := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    exact tail P (by simp [h63]) E S hArgs (by dsimp only [EnvW]; env_reads) (hS₀ ▸ hW)
  · have h63 : w ≠ 63 := fun h => hbr (by rw [h])
    -- for( int i=0; i<3; i++ ) fd_ed25519_lane_point_dbl( &acc, &acc, 0 );
    -- fd_ed25519_lane_point_dbl( &acc, &acc, 1 );
    block_init
    step_call using (_root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq
      (ht := fun _ => hacc_t))
    name_point a1
    step_call using (_root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq
      (ht := fun _ => hacc_t))
    name_point a2
    step_call using (_root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq
      (ht := fun _ => hacc_t))
    name_point a3
    step_call using (_root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq
      (ht := fun h => absurd h (by decide)))
    name_point a4
    grab hacc_r : S.mem.readLanePoint (c.s.slot 11) = _
    have hQ : a4 = dbl4 P := by
      rw [ha4, ha3, ha2, ha1]
      simp only [decide_false, decide_true, dbl4]
    have hAt : c.AtW S (dbl4 P) := by
      subst hS₀
      exact ⟨hW.base.frameOps (by rw [hS]; dsimp only; frame_ops) hwf (by rw [hS]), hkdf, hkdr,
        hsdf, hsdr, htabf, htabr, ⟨hacc, hacc_r.trans hQ⟩, ⟨hrf, hrr⟩⟩
    finish_block
    exact tail _ (by simp [h63]) E S hArgs (by dsimp only [EnvW]; env_reads) hAt

/-- The windows from `w` down: `acc` after all 64. -/
theorem ladder_loop (c : Call) (E88 : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
      Env88 c E' → c.AtW S' (c.acc 64) → ((verify_x8 c.batch).runFrom E' 88 S' >>= g) = K) :
    ∀ (w : Nat), w < 64 → ∀ (E : ⟪Γ⟫) (S : GlobalState), E.args = c.args → EnvW c E w →
      c.AtW S (c.acc (63 - w)) → ((verify_x8 c.batch).runFrom E 83 S >>= g) = K := by
  intro w
  induction w with
  | zero =>
    intro hw E S hA hE hW
    refine window_trip c 0 hw _ E S hA hE hW (fun h => absurd h (by decide)) ?_
    intro _ E' S' hA' hE' hW'
    exact E88 E' S' hA' hE' hW'
  | succ w ih =>
    intro hw E S hA hE hW
    refine window_trip c (w + 1) hw _ E S hA hE hW ?_ (fun h => absurd h (by omega))
    intro _ E' S' hA' hE' hW'
    refine ih (by omega) E' S' hA' hE' ?_
    have h2 : c.acc (63 - w) = window c.tab lc.tbl c.kS c.sS (w + 1) (c.acc (63 - (w + 1))) := by
      rw [show 63 - w = (62 - w) + 1 by omega, show 63 - (w + 1) = 62 - w by omega]
      simp only [Call.acc, ladder]
      rw [show 63 - (62 - w) = w + 1 by omega]
    rw [h2]
    exact hW'

/-- The loop at `^bb83`: `acc` after the 64 windows. -/
public theorem ladder_run (c : Call) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : Env83 c E) (hS : c.At83 S)
    (h88 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env88 c E' → c.At88 S' →
        ((verify_x8 c.batch).runFrom E' 88 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 83 S >>= g) = K :=
  ladder_loop c (fun E' S' hA' hE' hW => h88 E' S' hA' hE' ⟨hW.base, hW.acc, hW.r⟩) 63
    (by decide) E S hA hE
    ⟨hS.base, hS.kd_fits, hS.kd_read, hS.sd_fits, hS.sd_read, hS.tab_fits, hS.tab_read, hS.acc,
      hS.r⟩

end MLIR.Firedancer.Lane.VerifyX8
