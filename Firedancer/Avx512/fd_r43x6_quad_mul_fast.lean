module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_mul_fast
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Avx512

attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_quad_mul_fast(_z03, _z14, _z25, x03, x14, x25, y03, y14, y25)`: the four products of
the QUAD `x` and `y`, limbs `i` and `i + 3` of all four in one vector. The partials `pij` are summed
by columns `p0_q3 … p8_qb`, the high halves repacked into `za` and `zb`, then `za + 152 zb`. -/
def fd_r43x6_quad_mul_fast.spec (x03 x14 x25 y03 y14 y25 : Wwl) : Wwl × Wwl × Wwl :=
  let _zz := wwl_zero
  let x00 := wwl_pack_halves x03 0 x03 0
  let x11 := wwl_pack_halves x14 0 x14 0
  let x22 := wwl_pack_halves x25 0 x25 0
  let x33 := wwl_pack_halves x03 1 x03 1
  let x44 := wwl_pack_halves x14 1 x14 1
  let x55 := wwl_pack_halves x25 1 x25 1
  let p0_q3 := wwl_madd52lo _zz x00 y03
  let p1_q4 := wwl_madd52lo (wwl_madd52lo _zz x11 y03) x00 y14
  let p2_q5 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x22 y03) x11 y14) x00 y25
  let p3_q6 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x33 y03) x22 y14) x11 y25
  let p4_q7 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x44 y03) x33 y14) x22 y25
  let p5_q8 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x55 y03) x44 y14) x33 y25
  let p6_q9 := wwl_madd52lo (wwl_madd52lo _zz x55 y14) x44 y25
  let p7_qa := wwl_madd52lo _zz x55 y25
  let p1_q4 := wwl_add p1_q4 (wwl_shl (wwl_madd52hi _zz x00 y03) 9)
  let p2_q5 := wwl_add p2_q5 (wwl_shl (wwl_madd52hi (wwl_madd52hi _zz x11 y03) x00 y14) 9)
  let p3_q6 :=
    wwl_add p3_q6
      (wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x22 y03) x11 y14) x00 y25) 9)
  let p4_q7 :=
    wwl_add p4_q7
      (wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x33 y03) x22 y14) x11 y25) 9)
  let p5_q8 :=
    wwl_add p5_q8
      (wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x44 y03) x33 y14) x22 y25) 9)
  let p6_q9 :=
    wwl_add p6_q9
      (wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x55 y03) x44 y14) x33 y25) 9)
  let p7_qa := wwl_add p7_qa (wwl_shl (wwl_madd52hi (wwl_madd52hi _zz x55 y14) x44 y25) 9)
  let p8_qb := wwl_shl (wwl_madd52hi _zz x55 y25) 9
  let q6_p3 := wwl_pack_halves p3_q6 1 p3_q6 0
  let q7_p4 := wwl_pack_halves p4_q7 1 p4_q7 0
  let q8_p5 := wwl_pack_halves p5_q8 1 p5_q8 0
  let za03 := wwv_add_if 0xF0 p0_q3 q6_p3 p0_q3
  let za14 := wwv_add_if 0xF0 p1_q4 q7_p4 p1_q4
  let za25 := wwv_add_if 0xF0 p2_q5 q8_p5 p2_q5
  let zb03 := wwv_add_if 0x0F p6_q9 q6_p3 p6_q9
  let zb14 := wwv_add_if 0x0F p7_qa q7_p4 p7_qa
  let zb25 := wwv_add_if 0x0F p8_qb q8_p5 p8_qb
  let z03 := wwl_add (wwl_add za03 (wwl_shl zb03 7)) (wwl_add (wwl_shl zb03 4) (wwl_shl zb03 3))
  let z14 := wwl_add (wwl_add za14 (wwl_shl zb14 7)) (wwl_add (wwl_shl zb14 4) (wwl_shl zb14 3))
  let z25 := wwl_add (wwl_add za25 (wwl_shl zb25 7)) (wwl_add (wwl_shl zb25 4) (wwl_shl zb25 3))
  (z03, z14, z25)

end

/-! ## Proof -/

section Proof

/-- A step's lanes, as the `Wwl` operation they are. -/
local macro "lanes " h:ident : tactic =>
  `(tactic|
    (rw [$h:ident]; ext i hi : 1;
      rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
        simp [wwl_pack_halves, wwl_madd52lo, wwl_madd52hi, madd52lo, madd52hi, wwl_add, wwl_shl,
          wwv_add_if, add_mul152] <;>
        first
        | omega
        | ac_rfl))

-- the 60 steps' lane identities (`lanes`) all run inside this one declaration
set_option maxHeartbeats 1000000 in
/-- `fd_r43x6_quad_mul_fast` stores `spec`'s vectors at `_z03`, `_z14`, `_z25`, in that order. -/
public theorem fd_r43x6_quad_mul_fast.call_eq (_z03 _z14 _z25 : Pointer)
    (x03 x14 x25 y03 y14 y25 : Wwl) (s : GlobalState) (hwf : s.WF) (h03 : Room s.mem _z03 512)
    (h14 : Room s.mem _z14 512) (h25 : Room s.mem _z25 512) :
    fd_r43x6_quad_mul_fast.call
        (fd_r43x6_quad_mul_fast.args (.value _z03) (.value _z14) (.value _z25) (Ty.wrap x03)
          (Ty.wrap x14) (Ty.wrap x25) (Ty.wrap y03) (Ty.wrap y14) (Ty.wrap y25))
        s =
      .value
        (.nil,
          { s with
            mem :=
              ((s.mem.storeVec _z03
                        (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).1).storeVec
                    _z14 (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.1).storeVec
                _z25 (fd_r43x6_quad_mul_fast.spec x03 x14 x25 y03 y14 y25).2.2 }) := by
  func_init
  block_init
  iterate 5 step_pure
  step_pure with x00
  step_pure with x11
  step_pure with x22
  step_pure with x33
  step_pure with x44
  step_pure with x55
  step_pure with p0_q3
  step_pure with a12
  step_pure with p1_q4
  step_pure with a14
  step_pure with a15
  step_pure with p2_q5
  step_pure with a17
  step_pure with a18
  step_pure with p3_q6
  step_pure with a20
  step_pure with a21
  step_pure with p4_q7
  step_pure with a23
  step_pure with a24
  step_pure with p5_q8
  step_pure with a26
  step_pure with p6_q9
  step_pure with h29
  step_pure with s30
  step_pure with p1_q4'
  step_pure with h32
  step_pure with h33
  step_pure with s34
  step_pure with p2_q5'
  step_pure with h36
  step_pure with h37
  step_pure with h38
  step_pure with s39
  step_pure with p3_q6'
  step_pure with h41
  step_pure with h42
  step_pure with h43
  step_pure with s44
  step_pure with p4_q7'
  step_pure with h46
  step_pure with h47
  step_pure with h48
  step_pure with s49
  step_pure with p5_q8'
  step_pure with h51
  step_pure with h52
  step_pure with h53
  step_pure with s54
  step_pure with p6_q9'
  step_pure with h56
  step_pure with h57
  step_pure with s58
  step_pure with p7_qa'
  step_pure with h60
  step_pure with p8_qb
  step_pure with q6_p3
  step_pure with q7_p4
  step_pure with q8_p5
  step_pure
  step_pure with za03
  step_pure
  step_pure with za14
  step_pure
  step_pure with za25
  step_pure
  step_pure with zb03
  step_pure
  step_pure with zb14
  step_pure
  step_pure with zb25
  step_pure
  step_pure
  step_pure
  step_pure with z03
  step_pure
  step_pure
  step_pure
  step_pure with z14
  step_pure
  step_pure
  step_pure
  step_pure with z25
  iterate 3 step_store
  finish_block
  have e_x00 : x00 = wwl_pack_halves x03 0 x03 0 := by lanes hx00
  have e_x11 : x11 = wwl_pack_halves x14 0 x14 0 := by lanes hx11
  have e_x22 : x22 = wwl_pack_halves x25 0 x25 0 := by lanes hx22
  have e_x33 : x33 = wwl_pack_halves x03 1 x03 1 := by lanes hx33
  have e_x44 : x44 = wwl_pack_halves x14 1 x14 1 := by lanes hx44
  have e_x55 : x55 = wwl_pack_halves x25 1 x25 1 := by lanes hx55
  have e_p0_q3 : p0_q3 = wwl_madd52lo wwl_zero x00 y03 := by lanes hp0_q3
  have e_a12 : a12 = wwl_madd52lo wwl_zero x11 y03 := by lanes ha12
  have e_p1_q4 : p1_q4 = wwl_madd52lo a12 x00 y14 := by lanes hp1_q4
  have e_a14 : a14 = wwl_madd52lo wwl_zero x22 y03 := by lanes ha14
  have e_a15 : a15 = wwl_madd52lo a14 x11 y14 := by lanes ha15
  have e_p2_q5 : p2_q5 = wwl_madd52lo a15 x00 y25 := by lanes hp2_q5
  have e_a17 : a17 = wwl_madd52lo wwl_zero x33 y03 := by lanes ha17
  have e_a18 : a18 = wwl_madd52lo a17 x22 y14 := by lanes ha18
  have e_p3_q6 : p3_q6 = wwl_madd52lo a18 x11 y25 := by lanes hp3_q6
  have e_a20 : a20 = wwl_madd52lo wwl_zero x44 y03 := by lanes ha20
  have e_a21 : a21 = wwl_madd52lo a20 x33 y14 := by lanes ha21
  have e_p4_q7 : p4_q7 = wwl_madd52lo a21 x22 y25 := by lanes hp4_q7
  have e_a23 : a23 = wwl_madd52lo wwl_zero x55 y03 := by lanes ha23
  have e_a24 : a24 = wwl_madd52lo a23 x44 y14 := by lanes ha24
  have e_p5_q8 : p5_q8 = wwl_madd52lo a24 x33 y25 := by lanes hp5_q8
  have e_a26 : a26 = wwl_madd52lo wwl_zero x55 y14 := by lanes ha26
  have e_p6_q9 : p6_q9 = wwl_madd52lo a26 x44 y25 := by lanes hp6_q9
  have e_h29 : h29 = wwl_madd52hi wwl_zero x00 y03 := by lanes hh29
  have e_s30 : s30 = wwl_shl h29 9 := hs30
  have e_p1_q4' : p1_q4' = wwl_add p1_q4 s30 := by lanes hp1_q4'
  have e_h32 : h32 = wwl_madd52hi wwl_zero x11 y03 := by lanes hh32
  have e_h33 : h33 = wwl_madd52hi h32 x00 y14 := by lanes hh33
  have e_s34 : s34 = wwl_shl h33 9 := hs34
  have e_p2_q5' : p2_q5' = wwl_add p2_q5 s34 := by lanes hp2_q5'
  have e_h36 : h36 = wwl_madd52hi wwl_zero x22 y03 := by lanes hh36
  have e_h37 : h37 = wwl_madd52hi h36 x11 y14 := by lanes hh37
  have e_h38 : h38 = wwl_madd52hi h37 x00 y25 := by lanes hh38
  have e_s39 : s39 = wwl_shl h38 9 := hs39
  have e_p3_q6' : p3_q6' = wwl_add p3_q6 s39 := by lanes hp3_q6'
  have e_h41 : h41 = wwl_madd52hi wwl_zero x33 y03 := by lanes hh41
  have e_h42 : h42 = wwl_madd52hi h41 x22 y14 := by lanes hh42
  have e_h43 : h43 = wwl_madd52hi h42 x11 y25 := by lanes hh43
  have e_s44 : s44 = wwl_shl h43 9 := hs44
  have e_p4_q7' : p4_q7' = wwl_add p4_q7 s44 := by lanes hp4_q7'
  have e_h46 : h46 = wwl_madd52hi wwl_zero x44 y03 := by lanes hh46
  have e_h47 : h47 = wwl_madd52hi h46 x33 y14 := by lanes hh47
  have e_h48 : h48 = wwl_madd52hi h47 x22 y25 := by lanes hh48
  have e_s49 : s49 = wwl_shl h48 9 := hs49
  have e_p5_q8' : p5_q8' = wwl_add p5_q8 s49 := by lanes hp5_q8'
  have e_h51 : h51 = wwl_madd52hi wwl_zero x55 y03 := by lanes hh51
  have e_h52 : h52 = wwl_madd52hi h51 x44 y14 := by lanes hh52
  have e_h53 : h53 = wwl_madd52hi h52 x33 y25 := by lanes hh53
  have e_s54 : s54 = wwl_shl h53 9 := hs54
  have e_p6_q9' : p6_q9' = wwl_add p6_q9 s54 := by lanes hp6_q9'
  have e_h56 : h56 = wwl_madd52hi wwl_zero x55 y14 := by lanes hh56
  have e_h57 : h57 = wwl_madd52hi h56 x44 y25 := by lanes hh57
  have e_s58 : s58 = wwl_shl h57 9 := hs58
  have e_p7_qa' : p7_qa' = wwl_add (wwl_madd52lo wwl_zero x55 y25) s58 := by lanes hp7_qa'
  have e_h60 : h60 = wwl_madd52hi wwl_zero x55 y25 := by lanes hh60
  have e_p8_qb : p8_qb = wwl_shl h60 9 := hp8_qb
  have e_q6_p3 : q6_p3 = wwl_pack_halves p3_q6' 1 p3_q6' 0 := by lanes hq6_p3
  have e_q7_p4 : q7_p4 = wwl_pack_halves p4_q7' 1 p4_q7' 0 := by lanes hq7_p4
  have e_q8_p5 : q8_p5 = wwl_pack_halves p5_q8' 1 p5_q8' 0 := by lanes hq8_p5
  have e_za03 : za03 = wwv_add_if 0xF0 p0_q3 q6_p3 p0_q3 := by lanes hza03
  have e_za14 : za14 = wwv_add_if 0xF0 p1_q4' q7_p4 p1_q4' := by lanes hza14
  have e_za25 : za25 = wwv_add_if 0xF0 p2_q5' q8_p5 p2_q5' := by lanes hza25
  have e_zb03 : zb03 = wwv_add_if 0x0F p6_q9' q6_p3 p6_q9' := by lanes hzb03
  have e_zb14 : zb14 = wwv_add_if 0x0F p7_qa' q7_p4 p7_qa' := by lanes hzb14
  have e_zb25 : zb25 = wwv_add_if 0x0F p8_qb q8_p5 p8_qb := by lanes hzb25
  have e_z03 :
    z03 = wwl_add (wwl_add za03 (wwl_shl zb03 7)) (wwl_add (wwl_shl zb03 4) (wwl_shl zb03 3)) := by
    lanes hz03
  have e_z14 :
    z14 = wwl_add (wwl_add za14 (wwl_shl zb14 7)) (wwl_add (wwl_shl zb14 4) (wwl_shl zb14 3)) := by
    lanes hz14
  have e_z25 :
    z25 = wwl_add (wwl_add za25 (wwl_shl zb25 7)) (wwl_add (wwl_shl zb25 4) (wwl_shl zb25 3)) := by
    lanes hz25
  clear hArgs hE hx00 hx11 hx22 hx33 hx44 hx55 hp0_q3 ha12 hp1_q4 ha14 ha15 hp2_q5 ha17 ha18 hp3_q6
    ha20 ha21 hp4_q7 ha23 ha24 hp5_q8 ha26 hp6_q9 hh29 hs30 hp1_q4' hh32 hh33 hs34 hp2_q5' hh36 hh37
    hh38 hs39 hp3_q6' hh41 hh42 hh43 hs44 hp4_q7' hh46 hh47 hh48 hs49 hp5_q8' hh51 hh52 hh53 hs54
    hp6_q9' hh56 hh57 hs58 hp7_qa' hh60 hp8_qb hq6_p3 hq7_p4 hq8_p5 hza03 hza14 hza25 hzb03 hzb14
    hzb25 hz03 hz14 hz25
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Avx512
