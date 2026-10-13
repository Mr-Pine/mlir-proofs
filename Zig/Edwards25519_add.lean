module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.PointCopy
public import Zig.Common.Globals
public import Zig.Fe_add
public import Zig.Fe_sub
public import Zig.Fe_mul
public import Zig.Mlir.Edwards25519_add

namespace MLIR.Zig

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

/-- `P + Q`'s limbs are below `2^52`. -/
public theorem Edwards25519.add.spec_lt (P Q : ZPt) : (Edwards25519.add.spec P Q).Lt (2 ^ 52) :=
  ⟨Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _⟩

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `hS` kept reversed as `hck`: later states build on an opaque `S`, not on its frame's layers. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

set_option hygiene false in
/-- `step_load` by the read fact `h`, with the load's `Fits` from `r` in the width the step states
(`mem_fact` misses it inside a limbs fact). -/
local macro "load_by " h:ident r:term:max : tactic =>
  `(tactic|
    ( have hl : Fits _ _ (Ty.bv 64).width := $r
      step_load [$h:ident] consuming $h:ident hl))

set_option hygiene false in
/-- Drop a dead temporary's facts: its limbs' reads and its fit. -/
local macro "drop " x:ident : tactic => do
  let n := x.getId.toString
  let h (s : String) := Lean.mkIdent (.mkSimple s!"hread_{n}{s}")
  `(tactic|
      ( clear $(h "_readLimbs") $(h "") $(h "_8") $(h "_16") $(h "_24") $(h "_32")
        clear_facts $x:ident))

-- one 160-instruction block: 19 slots, 15 calls and 25 loads, each step carrying the facts

-- one 160-instruction block: 19 slots, 15 calls and 25 loads, each step carrying the facts
set_option maxHeartbeats 3000000 in
/-- `Edwards25519.add` stores `spec P Q` at `out`, `is_base` false, for limbs below `2^53`. It
reads `p` and `q` before writing `out`, so `out` may alias them. -/
public theorem Edwards25519_add.call_eq (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Edwards25519_add.globals) (hout : s.mem.PtRoom out)
    (hp : s.mem.PtLimbsFit p) (hq : s.mem.PtLimbsFit q) (hP : (s.mem.readPt p).Lt (2 ^ 53))
    (hQ : (s.mem.readPt q).Lt (2 ^ 53)) :
    Edwards25519_add.call (Edwards25519_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 37⟩,
            mem :=
              s.mem.storePt out (Edwards25519.add.spec (s.mem.readPt p) (s.mem.readPt q))
                0#1 }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hP
  generalize hQd : S.mem.readPt q = Q at hQ
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  have hQ₀ : S₀.mem.readPt q = Q := hS ▸ hQd
  have hpL₀ : S₀.mem.PtLimbsFit p := hS ▸ hp
  have hqL₀ : S₀.mem.PtLimbsFit q := hS ▸ hq
  have ho := hout.1
  obtain ⟨hpx, hpy, hpz, hpt⟩ := hP
  obtain ⟨hqx, hqy, hqz, hqt⟩ := hQ
  block_init
  iterate 3 step_pure
  step_addressof Fe_edwards25519d2.value_eq with g
  have hread_gd : S.mem.readLimbs g = Fe.d2 := by
    rw [MemoryState.readLimbs_of_readAt_fe hg_fits hg_off hread_g]
    funext i; fin_cases i <;> rfl
  limbs_fit g
  clear hread_g
  iterate 2 step_pure
  step_alloca with ot
  step_alloca with oz
  step_alloca with oy
  step_alloca with ox
  step_alloca with t
  step_alloca with z
  step_alloca with y
  step_alloca with x
  step_alloca with d
  step_alloca with c
  step_alloca with tt
  step_alloca with b
  step_alloca with qs
  step_alloca with ps
  step_alloca with a
  step_alloca with qd
  step_alloca with pd
  step_alloca with qc
  step_alloca with pc
  checkpoint hck1
  have hpcR := MemoryState.PtRoom.of_room hpc_room hpc_off
  have hqcR := MemoryState.PtRoom.of_room hqc_room hqc_off
  step_memcpy
  have hread_pcy : S.mem.readLimbs (pc.add 40#64) = P.y := by
    rw [← hread_pc_readPt]; rfl
  have hread_pcz : S.mem.readLimbs (pc.add 80#64) = P.z := by
    rw [← hread_pc_readPt]; rfl
  have hread_pct : S.mem.readLimbs (pc.add 120#64) = P.t := by
    rw [← hread_pc_readPt]; rfl
  clear hfits_pc hread_pc_readAt hread_pc_readLimbs hread_pc_readPt hread_pc hpc_room
  have hread_px : S.mem.readLimbs p = P.x := by
    rw [← hPd]; rfl
  have hread_py : S.mem.readLimbs (p.add 40#64) = P.y := by
    rw [← hPd]; rfl
  clear hPd
  step_memcpy
  have hread_qcy : S.mem.readLimbs (qc.add 40#64) = Q.y := by
    rw [← hread_qc_readPt]; rfl
  clear hfits_qc hread_qc_readAt hread_qc_readLimbs hread_qc_readPt hread_qc hqc_room
  have hread_qx : S.mem.readLimbs q = Q.x := by
    rw [← hQd]; rfl
  have hread_qy : S.mem.readLimbs (q.add 40#64) = Q.y := by
    rw [← hQd]; rfl
  have hread_qz : S.mem.readLimbs (q.add 80#64) = Q.z := by
    rw [← hQd]; rfl
  have hread_qt : S.mem.readLimbs (q.add 120#64) = Q.t := by
    rw [← hQd]; rfl
  clear hQd
  -- a = (p.y - p.x) * (q.y - q.x)
  step_pure
  have h1 := hpy.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hpx.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  limbs_room pd
  step_call using Fe_sub.call_eq_of consuming h1 h2 hread_pcy
  step_pure
  have h1 := hqy.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hqx.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  limbs_room qd
  step_call using Fe_sub.call_eq_of consuming h1 h2 hread_qcy
  have h1 :=
    (Fe.sub.spec_lt (b := P.x) hpy (by decide)).mono (show 2 ^ 53 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 :=
    (Fe.sub.spec_lt (b := Q.x) hqy (by decide)).mono (show 2 ^ 53 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  limbs_room a
  step_call using Fe_mul.call_eq_of consuming h1 h2
  name_limbs A
  replace hA := hA.symm
  drop pd
  drop qd
  -- b = (p.x + p.y) * (q.x + q.y)
  step_pure
  have h1 := hpx.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hpy.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  limbs_room ps
  step_call using Fe_add.call_eq_of consuming h1 h2 hread_px hread_py
  step_pure
  have h1 := hqx.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hqy.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  limbs_room qs
  step_call using Fe_add.call_eq_of consuming h1 h2 hread_qx hread_qy
  have h1 := (Fe.add.spec_lt hpx hpy (by decide)).mono (show 2 ^ 53 + 2 ^ 53 ≤ 2 ^ 54 by decide)
  have h2 := (Fe.add.spec_lt hqx hqy (by decide)).mono (show 2 ^ 53 + 2 ^ 53 ≤ 2 ^ 54 by decide)
  limbs_room b
  step_call using Fe_mul.call_eq_of consuming h1 h2
  name_limbs B
  replace hB := hB.symm
  drop ps
  drop qs
  -- c = p.t * q.t * 2d
  step_pure
  step_pure
  have h1 := hpt.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  have h2 := hqt.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  limbs_room tt
  step_call using Fe_mul.call_eq_of consuming h1 h2 hread_pct hread_qt
  have h1 := (Fe.mul.spec_lt P.t Q.t).mono (show 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 : Fe.Lt Fe.d2 (2 ^ 54) := by
    intro i; fin_cases i <;> decide
  limbs_room c
  step_call using Fe_mul.call_eq_of consuming h1 h2 hread_gd
  name_limbs C
  replace hC := hC.symm
  drop tt
  clear_facts g
  -- d = p.z * q.z
  step_pure
  step_pure
  have h1 := hpz.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  have h2 := hqz.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  -- `d`'s room kept: its limbs are stored again in place
  have hd_limbs := MemoryState.LimbsRoom.of_room hd_room hd_off
  step_call using Fe_mul.call_eq_of consuming h1 h2 hread_pcz hread_qz
  name_limbs D
  replace hD := hD.symm
  clear_facts pc qc p q
  -- d + d, as `shl nuw` by one, back into `d`
  have hDl : Fe.Lt D (2 ^ 52) := hD ▸ Fe.mul.spec_lt P.z Q.z
  have hsh (i : Fin 5) := shl1_shr1 (Nat.lt_trans (hDl i) (show 2 ^ 52 < 2 ^ 63 by decide))
  clear hread_d_readLimbs
  load_by hread_d hd_limbs.2.1
  step_pure [hsh 0]
  step_pure
  load_by hread_d_8 hd_limbs.2.2.1
  step_pure [hsh 1]
  step_pure
  load_by hread_d_16 hd_limbs.2.2.2.1
  step_pure [hsh 2]
  step_pure
  load_by hread_d_24 hd_limbs.2.2.2.2.1
  step_pure [hsh 3]
  step_pure
  load_by hread_d_32 hd_limbs.2.2.2.2.2
  step_pure [hsh 4]
  clear hsh
  obtain ⟨hdo, r0, r8, r16, r24, r32⟩ := hd_limbs
  step_store [r0.room]
  step_store [r8.room]
  step_store [r16.room]
  step_store [r24.room]
  step_store [r32.room]
  have hread_d2 : S.mem.readLimbs d = fun i => D i <<< 1 :=
    MemoryState.readLimbs_of_reads hread_d hread_d_8 hread_d_16 hread_d_24 hread_d_32
  have hd_limbs : S.mem.LimbsFit d := ⟨hdo, r0, r8, r16, r24, r32⟩
  clear hread_d hread_d_8 hread_d_16 hread_d_24 hread_d_32 r0 r8 r16 r24 r32 hdo
  have hDD : Fe.Lt (fun i => D i <<< 1) (2 ^ 53) := fun i => by
    show (D i <<< 1).toNat < _
    rw [shl1_toNat (Nat.lt_trans (hDl i) (by decide))]; have := hDl i; omega
  have hAl : Fe.Lt A (2 ^ 52) := hA ▸ Fe.mul.spec_lt _ _
  have hBl : Fe.Lt B (2 ^ 52) := hB ▸ Fe.mul.spec_lt _ _
  have hCl : Fe.Lt C (2 ^ 52) := hC ▸ Fe.mul.spec_lt _ _
  -- x = b - a
  have h1 := hBl.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have h2 := hAl.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  limbs_room x
  step_call using Fe_sub.call_eq_of consuming h1 h2
  -- y = b + a, inline
  have hyo (i : Fin 5) : (A i).uaddOverflow (B i) = false :=
    uaddOverflow_eq_false
      (by
        have := hAl i; have := hBl i; omega)
  obtain ⟨hbo, fb0, fb8, fb16, fb24, fb32⟩ := hb_limbs
  obtain ⟨hao, fa0, fa8, fa16, fa24, fa32⟩ := ha_limbs
  load_by hread_b fb0
  load_by hread_a fa0
  step_pure [hyo 0]
  step_pure
  load_by hread_b_8 fb8
  step_pure
  load_by hread_a_8 fa8
  step_pure [hyo 1]
  step_pure
  load_by hread_b_16 fb16
  step_pure
  load_by hread_a_16 fa16
  step_pure [hyo 2]
  step_pure
  load_by hread_b_24 fb24
  step_pure
  load_by hread_a_24 fa24
  step_pure [hyo 3]
  step_pure
  load_by hread_b_32 fb32
  step_pure
  load_by hread_a_32 fa32
  step_pure [hyo 4]
  clear hyo
  obtain ⟨hyo, r0, r8, r16, r24, r32⟩ := MemoryState.LimbsRoom.of_room hy_room hy_off
  step_store consuming r0
  step_pure
  step_store consuming r8
  step_pure
  step_store consuming r16
  step_pure
  step_store consuming r24
  step_pure
  step_store consuming r32
  have hread_yv : S.mem.readLimbs y = Fe.add.spec B A :=
    MemoryState.readLimbs_of_reads hread_y hread_y_8 hread_y_16 hread_y_24 hread_y_32
  have hy_limbs : S.mem.LimbsFit y := ⟨hyo, hfits_y, hfits_y_8, hfits_y_16, hfits_y_24, hfits_y_32⟩
  clear hread_y hread_y_8 hread_y_16 hread_y_24 hread_y_32 hfits_y hfits_y_8 hfits_y_16 hfits_y_24
    hfits_y_32 hyo
  -- z = 2d + c, inline
  have hzo (i : Fin 5) : (C i).uaddOverflow (D i <<< 1) = false :=
    uaddOverflow_eq_false
      (by
        have := hCl i; have : (D i <<< 1).toNat < 2 ^ 53 := hDD i; omega)
  obtain ⟨hco, fc0, fc8, fc16, fc24, fc32⟩ := hc_limbs
  load_by hread_c fc0
  step_pure [hzo 0]
  step_pure
  load_by hread_c_8 fc8
  step_pure [hzo 1]
  step_pure
  load_by hread_c_16 fc16
  step_pure [hzo 2]
  step_pure
  load_by hread_c_24 fc24
  step_pure [hzo 3]
  step_pure
  load_by hread_c_32 fc32
  step_pure [hzo 4]
  clear hzo
  have hc_limbs : S.mem.LimbsFit c := ⟨hco, fc0, fc8, fc16, fc24, fc32⟩
  clear hco fc0 fc8 fc16 fc24 fc32
  obtain ⟨hzo', r0, r8, r16, r24, r32⟩ := MemoryState.LimbsRoom.of_room hz_room hz_off
  step_store consuming r0
  step_pure
  step_store consuming r8
  step_pure
  step_store consuming r16
  step_pure
  step_store consuming r24
  step_pure
  step_store consuming r32
  have hread_zv : S.mem.readLimbs z = Fe.add.spec (fun i => D i <<< 1) C :=
    MemoryState.readLimbs_of_reads hread_z hread_z_8 hread_z_16 hread_z_24 hread_z_32
  have hz_limbs : S.mem.LimbsFit z := ⟨hzo', hfits_z, hfits_z_8, hfits_z_16, hfits_z_24, hfits_z_32⟩
  clear hread_z hread_z_8 hread_z_16 hread_z_24 hread_z_32 hfits_z hfits_z_8 hfits_z_16 hfits_z_24
    hfits_z_32 hzo'
  -- t = 2d - c
  have h1 := hDD.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hCl.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  limbs_room t
  step_call using Fe_sub.call_eq_of consuming h1 h2 hread_d2 hread_c_readLimbs
  -- the outputs
  have hX54 :=
    (Fe.sub.spec_lt (b := A) hBl (by decide)).mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have hT54 :=
    (Fe.sub.spec_lt (b := C) hDD (by decide)).mono (show 2 ^ 53 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have hY54 := (Fe.add.spec_lt hBl hAl (by decide)).mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have hZ54 := (Fe.add.spec_lt hDD hCl (by decide)).mono (show 2 ^ 53 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h1 := hX54
  have h2 := hT54
  limbs_room ox
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have htm := hS ▸ hox_limbs
  have htr := hS ▸ hread_ox_readLimbs
  have f2 := hox_limbs.fits
  step_memcpy consuming f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (by omega), htr] at hS
  clear htm htr
  step_pure
  have h1 := hY54
  have h2 := hZ54
  limbs_room oy
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have htm := hS ▸ hoy_limbs
  have htr := hS ▸ hread_oy_readLimbs
  have f1 := hout.limbsRoom_y.room
  have f2 := hoy_limbs.fits
  step_memcpy consuming f1 f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (Pointer.field_offset ho (a := 40) (by omega)),
    htr] at hS
  clear htm htr
  step_pure
  have h1 := hZ54
  have h2 := hT54
  limbs_room oz
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have htm := hS ▸ hoz_limbs
  have htr := hS ▸ hread_oz_readLimbs
  have f1 := hout.limbsRoom_z.room
  have f2 := hoz_limbs.fits
  step_memcpy consuming f1 f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (Pointer.field_offset ho (a := 80) (by omega)),
    htr] at hS
  clear htm htr
  step_pure
  have h1 := hX54
  have h2 := hY54
  limbs_room ot
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have htm := hS ▸ hot_limbs
  have htr := hS ▸ hread_ot_readLimbs
  have f1 := hout.limbsRoom_t.room
  have f2 := hot_limbs.fits
  step_memcpy consuming f1 f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (Pointer.field_offset ho (a := 120) (by omega)),
    htr] at hS
  clear htm htr
  step_pure
  have f1 := hout.room_base
  step_store consuming f1
  finish_block
  subst_vars
  erase_frame
  rfl

/-- `call_eq` on the points `P`, `Q` read at `p`, `q`. -/
public theorem Edwards25519_add.call_eq_of (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Edwards25519_add.globals) (hout : s.mem.PtRoom out)
    (hp : s.mem.PtLimbsFit p) (hq : s.mem.PtLimbsFit q) (hPd : s.mem.readPt p = P)
    (hQd : s.mem.readPt q = Q) (hP : P.Lt (2 ^ 53)) (hQ : Q.Lt (2 ^ 53)) :
    Edwards25519_add.call (Edwards25519_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 37⟩,
            mem := s.mem.storePt out (Edwards25519.add.spec P Q) 0#1 }) := by
  subst hPd hQd
  exact Edwards25519_add.call_eq out p q s hwf hg hout hp hq hP hQ

end Proof

end MLIR.Zig
