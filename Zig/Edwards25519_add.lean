module

public import SSA.Projects.RIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
public import Zig.Point
public import Zig.Fe_add
public import Zig.Fe_sub
public import Zig.Fe_mul
public import Zig.Globals
public import Zig.Steps
public import Zig.Mlir.Edwards25519_add

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `2d`'s limbs. -/
def Fe.d2 : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 1859910466990425
  | ⟨1, _⟩ => 932731440258426
  | ⟨2, _⟩ => 1072319116312658
  | ⟨3, _⟩ => 1815898335770999
  | ⟨4, _⟩ => 633789495995903

/-- `P + Q`, extended coordinates; in the program's operand order. -/
def Edwards25519.add.spec (P Q : ZPt) : ZPt :=
  let a := Fe.mul.spec (Fe.sub.spec P.y P.x) (Fe.sub.spec Q.y Q.x)
  let b := Fe.mul.spec (Fe.add.spec P.x P.y) (Fe.add.spec Q.x Q.y)
  let c := Fe.mul.spec (Fe.mul.spec P.t Q.t) Fe.d2
  let d : Fin 5 → BitVec 64 := fun i => Fe.mul.spec P.z Q.z i <<< 1
  let x := Fe.sub.spec b a
  let y := Fe.add.spec b a
  let z := Fe.add.spec d c
  let t := Fe.sub.spec d c
  ⟨Fe.mul.spec x t, Fe.mul.spec y z, Fe.mul.spec z t, Fe.mul.spec x y⟩

end

/-! ## Proof -/

section Proof

set_option maxHeartbeats 2000000 in
/-- `Edwards25519.add` stores `spec P Q` at `out`, `is_base` false, for limbs below `2^53`. -/
public theorem Edwards25519_add.call_eq (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hq : s.mem.PtFit q)
    (hP : (s.mem.readPt p).Lt (2 ^ 53)) (hQ : (s.mem.readPt q).Lt (2 ^ 53)) :
    Edwards25519_add.call (Edwards25519_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 38⟩,
            mem :=
              s.mem.storePt out (Edwards25519.add.spec (s.mem.readPt p) (s.mem.readPt q))
                (ZPt.flag (s.mem.readRest out) 0#1) }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hP
  generalize hQd : S.mem.readPt q = Q at hQ
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  have hQ₀ : S₀.mem.readPt q = Q := hS ▸ hQd
  have hp₀ : S₀.mem.PtFit p := hS ▸ hp
  have hq₀ : S₀.mem.PtFit q := hS ▸ hq
  have hout₀ : S₀.mem.PtFit out := hS ▸ hout
  obtain ⟨hpx, hpy, hpz, hpt⟩ := hP
  obtain ⟨hqx, hqy, hqz, hqt⟩ := hQ
  have hrp :
    S.mem.readLimbs p = P.x ∧
      S.mem.readLimbs (p.add 40#64) = P.y ∧
      S.mem.readLimbs (p.add 80#64) = P.z ∧ S.mem.readLimbs (p.add 120#64) = P.t := by
    subst hPd; exact ⟨rfl, rfl, rfl, rfl⟩
  have hrq :
    S.mem.readLimbs q = Q.x ∧
      S.mem.readLimbs (q.add 40#64) = Q.y ∧
      S.mem.readLimbs (q.add 80#64) = Q.z ∧ S.mem.readLimbs (q.add 120#64) = Q.t := by
    subst hQd; exact ⟨rfl, rfl, rfl, rfl⟩
  obtain ⟨hread_px, hread_py, hread_pz, hread_pt⟩ := hrp
  obtain ⟨hread_qx, hread_qy, hread_qz, hread_qt⟩ := hrq
  clear hPd hQd
  block_init
  iterate 3 step_pure
  step_addressof Fe_edwards25519d2.value_eq with g
  have hgl : S.mem.readLimbs g = Fe.d2 := by
    rw [MemoryState.readLimbs_of_readAt_fe hg_fits hg_off hread_g]
    funext i; fin_cases i <;> rfl
  have hg' : Fe.Lt (S.mem.readLimbs g) (2 ^ 54) := by
    rw [hgl]; intro i; fin_cases i <;> simp [Fe.d2]
  limbs_fit g
  clear hread_g hg'
  have hread_gd := hgl
  clear hgl
  iterate 2 step_pure
  step_alloca with ot
  limbs_fit ot
  step_alloca with oz
  limbs_fit oz
  step_alloca with oy
  limbs_fit oy
  step_alloca with ox
  limbs_fit ox
  step_alloca with t
  limbs_fit t
  step_alloca with z
  limbs_fit z
  step_alloca with y
  limbs_fit y
  step_alloca with x
  limbs_fit x
  step_alloca with d
  limbs_fit d
  step_alloca with c
  limbs_fit c
  step_alloca with tt
  limbs_fit tt
  step_alloca with b
  limbs_fit b
  step_alloca with qs
  limbs_fit qs
  step_alloca with ps
  limbs_fit ps
  step_alloca with a
  limbs_fit a
  step_alloca with qd
  limbs_fit qd
  step_alloca with pd
  limbs_fit pd
  step_alloca with qc
  have hqcP := MemoryState.PtFit.of_fits hqc_fits hqc_off
  step_alloca with pc
  have hpcP := MemoryState.PtFit.of_fits hpc_fits hpc_off
  clear hqc_fits hpc_fits
  have hf := hp.2
  step_memcpy consuming hf
  -- the copies' fields are `p`'s and `q`'s
  have hpc_eq : S.mem.readPt pc = S.mem.readPt p := by
    have h1 := hp
    have h2 := hpcP
    rw [hS] at h1 h2 ⊢
    exact MemoryState.readPt_copy h1 h2 hp_ne_pc.symm rfl
  have hread_pcy : S.mem.readLimbs (pc.add 40#64) = P.y := by
    rw [← hread_py]; exact congrArg ZPt.y hpc_eq
  have hread_pcz : S.mem.readLimbs (pc.add 80#64) = P.z := by
    rw [← hread_pz]; exact congrArg ZPt.z hpc_eq
  have hread_pct : S.mem.readLimbs (pc.add 120#64) = P.t := by
    rw [← hread_pt]; exact congrArg ZPt.t hpc_eq
  clear hpc_eq hread_pc
  have hf := hq.2
  step_memcpy consuming hf
  have hqc_eq : S.mem.readPt qc = S.mem.readPt q := by
    have h1 := hq
    have h2 := hqcP
    rw [hS] at h1 h2 ⊢
    refine MemoryState.readPt_copy h1 h2 hq_ne_qc.symm (MemoryState.readAt_storeAt_disjoint ?_ _)
    simp only [Range.Disjoint, Range.of]
    exact .inl hq_ne_pc.symm
  have hread_qcy : S.mem.readLimbs (qc.add 40#64) = Q.y := by
    rw [← hread_qy]; exact congrArg ZPt.y hqc_eq
  clear hqc_eq hread_qc
  -- a = (p.y - p.x) * (q.y - q.x)
  step_pure
  have h1 := hpy.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hpx.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  step_pure
  have h1 := hqy.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hqx.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  have h1 :=
    (Fe.sub.spec_lt (b := P.x) hpy (by decide)).mono (show 2 ^ 53 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 :=
    (Fe.sub.spec_lt (b := Q.x) hqy (by decide)).mono (show 2 ^ 53 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  -- b = (p.x + p.y) * (q.x + q.y)
  step_pure
  have h1 := hpx.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hpy.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  step_call using Fe_add.call_eq_of consuming h1 h2
  step_pure
  have h1 := hqx.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hqy.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  step_call using Fe_add.call_eq_of consuming h1 h2
  have h1 := (Fe.add.spec_lt hpx hpy (by decide)).mono (show 2 ^ 53 + 2 ^ 53 ≤ 2 ^ 54 by decide)
  have h2 := (Fe.add.spec_lt hqx hqy (by decide)).mono (show 2 ^ 53 + 2 ^ 53 ≤ 2 ^ 54 by decide)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  -- c = p.t * q.t * 2d
  step_pure
  step_pure
  have h1 := hpt.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  have h2 := hqt.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have h1 := (Fe.mul.spec_lt P.t Q.t).mono (show 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 : Fe.Lt Fe.d2 (2 ^ 54) := by
    intro i; fin_cases i <;> decide
  generalize hD₀ : Fe.d2 = D at h2 hread_gd
  step_call using Fe_mul.call_eq_of consuming h1 h2
  -- d = p.z * q.z
  step_pure
  step_pure
  have h1 := hpz.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  have h2 := hqz.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  -- d + d, as `shl nuw` by one, back into `d`
  have hD := Fe.mul.spec_lt P.z Q.z
  have hsh (i : Fin 5) := shl1_shr1 (Nat.lt_trans (hD i) (show 2 ^ 52 < 2 ^ 63 by decide))
  step_load
  step_pure [hsh 0]
  step_pure
  step_load with l1
  fix_load l1 hl1 hread_d_8
  step_pure [hsh 1]
  step_pure
  step_load with l2
  fix_load l2 hl2 hread_d_16
  step_pure [hsh 2]
  step_pure
  step_load with l3
  fix_load l3 hl3 hread_d_24
  step_pure [hsh 3]
  step_pure
  step_load with l4
  fix_load l4 hl4 hread_d_32
  step_pure [hsh 4]
  iterate 5 step_store
  read_stores d, (fun i => Fe.mul.spec P.z Q.z i <<< 1) with hread_dd
  have hDD : Fe.Lt (fun i => Fe.mul.spec P.z Q.z i <<< 1) (2 ^ 53) := fun i => by
    show (Fe.mul.spec P.z Q.z i <<< 1).toNat < _
    rw [shl1_toNat (Nat.lt_trans (hD i) (by decide))]; have := hD i; omega
  have hA := Fe.mul.spec_lt (Fe.sub.spec P.y P.x) (Fe.sub.spec Q.y Q.x)
  have hB := Fe.mul.spec_lt (Fe.add.spec P.x P.y) (Fe.add.spec Q.x Q.y)
  have hC := Fe.mul.spec_lt (Fe.mul.spec P.t Q.t) D
  -- x = b - a
  have h1 := hB.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have h2 := hA.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  -- y = b + a, inline
  have hyo (i : Fin 5) :
    (Fe.mul.spec (Fe.sub.spec P.y P.x) (Fe.sub.spec Q.y Q.x) i).uaddOverflow
        (Fe.mul.spec (Fe.add.spec P.x P.y) (Fe.add.spec Q.x Q.y) i) =
      false :=
    uaddOverflow_eq_false
      (by
        have := hA i; have := hB i; omega)
  have hzo (i : Fin 5) :
    (Fe.mul.spec (Fe.mul.spec P.t Q.t) D i).uaddOverflow (Fe.mul.spec P.z Q.z i <<< 1) = false :=
    uaddOverflow_eq_false
      (by
        have := hC i; have : (Fe.mul.spec P.z Q.z i <<< 1).toNat < 2 ^ 53 := hDD i; omega)
  step_load with ub0
  fix_load ub0 hub0(congrFun hread_b 0 : S.mem.readAt b 64 = _)
  step_load with ua0
  fix_load ua0 hua0(congrFun hread_a 0 : S.mem.readAt a 64 = _)
  step_pure [hyo 0]
  step_pure
  step_load with ub1
  fix_load ub1 hub1(congrFun hread_b 1 : S.mem.readAt (b.add 8#64) 64 = _)
  step_pure
  step_load with ua1
  fix_load ua1 hua1(congrFun hread_a 1 : S.mem.readAt (a.add 8#64) 64 = _)
  step_pure [hyo 1]
  step_pure
  step_load with ub2
  fix_load ub2 hub2(congrFun hread_b 2 : S.mem.readAt (b.add 16#64) 64 = _)
  step_pure
  step_load with ua2
  fix_load ua2 hua2(congrFun hread_a 2 : S.mem.readAt (a.add 16#64) 64 = _)
  step_pure [hyo 2]
  step_pure
  step_load with ub3
  fix_load ub3 hub3(congrFun hread_b 3 : S.mem.readAt (b.add 24#64) 64 = _)
  step_pure
  step_load with ua3
  fix_load ua3 hua3(congrFun hread_a 3 : S.mem.readAt (a.add 24#64) 64 = _)
  step_pure [hyo 3]
  step_pure
  step_load with ub4
  fix_load ub4 hub4(congrFun hread_b 4 : S.mem.readAt (b.add 32#64) 64 = _)
  step_pure
  step_load with ua4
  fix_load ua4 hua4(congrFun hread_a 4 : S.mem.readAt (a.add 32#64) 64 = _)
  step_pure [hyo 4]
  step_store
  iterate 4 
    step_pure
    step_store
  read_stores y,
    Fe.add.spec (Fe.mul.spec (Fe.add.spec P.x P.y) (Fe.add.spec Q.x Q.y))
      (Fe.mul.spec (Fe.sub.spec P.y P.x) (Fe.sub.spec Q.y Q.x)) with
    hread_yv
  -- z = 2d + c, inline
  checkpoint hck1
  have hrc0 : S.mem.readAt c 64 = _ := congrFun hread_c 0
  step_load
  step_pure [hzo 0]
  step_pure
  step_load with uc1
  fix_load uc1 huc1(congrFun hread_c 1 : S.mem.readAt (c.add 8#64) 64 = _)
  step_pure [hzo 1]
  step_pure
  step_load with uc2
  fix_load uc2 huc2(congrFun hread_c 2 : S.mem.readAt (c.add 16#64) 64 = _)
  step_pure [hzo 2]
  step_pure
  step_load with uc3
  fix_load uc3 huc3(congrFun hread_c 3 : S.mem.readAt (c.add 24#64) 64 = _)
  step_pure [hzo 3]
  step_pure
  step_load with uc4
  fix_load uc4 huc4(congrFun hread_c 4 : S.mem.readAt (c.add 32#64) 64 = _)
  step_pure [hzo 4]
  step_store
  iterate 4 
    step_pure
    step_store
  read_stores z,
    Fe.add.spec (fun i => Fe.mul.spec P.z Q.z i <<< 1) (Fe.mul.spec (Fe.mul.spec P.t Q.t) D) with
    hread_zv
  -- t = 2d - c
  have h1 := hDD.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hC.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  -- the outputs
  have hX54 :=
    (Fe.sub.spec_lt (b := (Fe.mul.spec (Fe.sub.spec P.y P.x) (Fe.sub.spec Q.y Q.x))) hB
          (by decide)).mono
      (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have hT54 :=
    (Fe.sub.spec_lt (b := Fe.mul.spec (Fe.mul.spec P.t Q.t) D) hDD (by decide)).mono
      (show 2 ^ 53 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have hY54 := (Fe.add.spec_lt hB hA (by decide)).mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have hZ54 := (Fe.add.spec_lt hDD hC (by decide)).mono (show 2 ^ 53 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h1 := hX54
  have h2 := hT54
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have f1 := hout.limbsFit_x.fits
  have f2 := hox_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits hox_limbs.fits hox_limbs.1
  step_memcpy consuming f1 f2 hv
  step_pure
  have h1 := hY54
  have h2 := hZ54
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have f1 := hout.limbsFit_y.fits
  have f2 := hoy_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits hoy_limbs.fits hoy_limbs.1
  step_memcpy consuming f1 f2 hv
  step_pure
  have h1 := hZ54
  have h2 := hT54
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have f1 := hout.limbsFit_z.fits
  have f2 := hoz_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits hoz_limbs.fits hoz_limbs.1
  step_memcpy consuming f1 f2 hv
  step_pure
  have h1 := hX54
  have h2 := hY54
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have f1 := hout.limbsFit_t.fits
  have f2 := hot_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits hot_limbs.fits hot_limbs.1
  step_memcpy consuming f1 f2 hv
  step_pure
  have f1 := hout.fits_rest.mono (show 1 ≤ 64 by omega)
  step_store consuming f1
  finish_block
  subst hck1
  rw [hS]
  erase_frame
  rw [MemoryState.storeAt_fields_eq hout₀, hP₀, hQ₀, ← hD₀]
  simp [GlobalState.alloca, Edwards25519.add.spec]

end Proof

end LeanMLIR.RIR.Zig
