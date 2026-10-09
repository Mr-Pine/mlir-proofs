module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Avx512.Mlir.fd_r43x6_quad_sqr_fast
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Avx512

-- folded, so the steps' terms and the specs compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_quad_sqr_fast(_z03, _z14, _z25, x03, x14, x25)`: the four squares of the QUAD `x`,
limbs `i` and `i + 3` of all four in one vector. The partials are paired by `i <> j` symmetry into
`p0a … p55` (low) and `q1b … q66` (high, shifted up by `9`), repacked into `za` and `zb`, then
`za + 152 zb`. -/
def fd_r43x6_quad_sqr_fast.spec (x03 x14 x25 : Wwl) : Wwl × Wwl × Wwl :=
  let _zz := wwl_zero
  let x05 := wwl_pack_h0_h1 x03 x25
  let x12 := wwl_pack_halves x14 0 x25 0
  let x34 := wwl_pack_halves x03 1 x14 1
  let x41 := wwl_pack_halves x14 1 x14 0
  let x23 := wwl_pack_h0_h1 x25 x03
  let x52 := wwl_pack_halves x25 1 x25 0
  let x4z := wwl_pack_halves x14 1 _zz 0
  let two_x03 := wwl_shl x03 1
  let two_x14 := wwl_shl x14 1
  let two_x05 := wwl_shl x05 1
  let two_x12 := wwl_shl x12 1
  let p0a := wwl_madd52lo _zz x05 x05
  let p19 := wwl_madd52lo _zz two_x05 x14
  let p28 := wwl_madd52lo (wwl_madd52lo _zz x14 x14) two_x03 x25
  let p37 := wwl_madd52lo (wwl_madd52lo _zz two_x03 x34) two_x12 x25
  let p46 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x23 x23) two_x05 x41) two_x12 x34
  let p55 := wwl_madd52lo (wwl_madd52lo _zz two_x03 x52) two_x14 x4z
  let q1b := wwl_shl (wwl_madd52hi _zz x05 x05) 9
  let q2a := wwl_shl (wwl_madd52hi _zz two_x05 x14) 9
  let q39 := wwl_shl (wwl_madd52hi (wwl_madd52hi _zz x14 x14) two_x03 x25) 9
  let q48 := wwl_shl (wwl_madd52hi (wwl_madd52hi _zz two_x03 x34) two_x12 x25) 9
  let q57 :=
    wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x23 x23) two_x05 x41) two_x12 x34) 9
  let q66 := wwl_shl (wwl_madd52hi (wwl_madd52hi _zz two_x03 x52) two_x14 x4z) 9
  let za03 := wwl_add (wwl_pack_halves p0a 0 p37 0) (wwl_pack_halves _zz 0 q39 0)
  let za14 := wwl_add (wwl_pack_halves p19 0 p46 0) (wwl_pack_halves q1b 0 q48 0)
  let za25 := wwl_add (wwl_add (wwl_pack_halves p28 0 p55 0) (wwl_pack_halves q2a 0 q57 0))
    (wwl_pack_h0_h1 _zz p55)
  let zb03 := wwl_add (wwl_add (wwl_pack_halves p46 1 p19 1) (wwl_pack_halves q66 1 q39 1))
    (wwl_pack_h0_h1 q66 _zz)
  let zb14 := wwl_add (wwl_pack_halves p37 1 p0a 1) (wwl_pack_halves q57 1 q2a 1)
  let zb25 := wwl_add (wwl_pack_halves p28 1 _zz 1) (wwl_pack_halves q48 1 q1b 1)
  let z03 := wwl_add (wwl_add za03 (wwl_shl zb03 7)) (wwl_add (wwl_shl zb03 4) (wwl_shl zb03 3))
  let z14 := wwl_add (wwl_add za14 (wwl_shl zb14 7)) (wwl_add (wwl_shl zb14 4) (wwl_shl zb14 3))
  let z25 := wwl_add (wwl_add za25 (wwl_shl zb25 7)) (wwl_add (wwl_shl zb25 4) (wwl_shl zb25 3))
  (z03, z14, z25)

end

/-! ## Proof -/

section Proof

/-- A step's lanes, as the `Wwl` operation they are. -/
local macro "lanes " h:ident : tactic =>
  `(tactic| (rw [$h:ident]; ext i hi : 1; rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
    simp [wwl_pack_halves, wwl_pack_h0_h1, wwl_madd52lo, wwl_madd52hi, madd52lo, madd52hi,
      wwl_add, wwl_shl, mul24_eq_shl] <;> first | omega | ac_rfl))

-- the 60 steps' lane identities (`lanes`) all run inside this one declaration
set_option maxHeartbeats 1000000 in
/-- `fd_r43x6_quad_sqr_fast` stores `spec`'s vectors at `_z03`, `_z14`, `_z25`, in that order. -/
public theorem fd_r43x6_quad_sqr_fast.call_eq (_z03 _z14 _z25 : Pointer) (x03 x14 x25 : Wwl)
    (s : GlobalState) (hwf : s.WF) (h03 : Fits s.mem _z03 512) (h14 : Fits s.mem _z14 512)
    (h25 : Fits s.mem _z25 512) :
    fd_r43x6_quad_sqr_fast.call
        (fd_r43x6_quad_sqr_fast.args (.value _z03) (.value _z14) (.value _z25) (Ty.wrap x03)
          (Ty.wrap x14) (Ty.wrap x25)) s =
      .value
        (.nil,
          { s with
            mem :=
              ((s.mem.storeVec _z03 (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).1).storeVec _z14
                    (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.1).storeVec _z25
                (fd_r43x6_quad_sqr_fast.spec x03 x14 x25).2.2 }) := by
  func_init
  block_init
  iterate 34 step_pure
  step_pure with x05
  step_pure with x12
  step_pure with x34
  step_pure with x41
  step_pure with x23
  step_pure with x52
  step_pure with x4z
  step_pure with two_x03
  step_pure with two_x14
  step_pure with two_x05
  step_pure with two_x12
  step_pure with p0a
  step_pure with p19
  step_pure with a47
  step_pure with p28
  step_pure with a49
  step_pure with p37
  step_pure with a51
  step_pure with a52
  step_pure with p46
  step_pure with a54
  step_pure with p55
  step_pure with h56
  step_pure with q1b
  step_pure with h58
  step_pure with q2a
  step_pure with h60
  step_pure with h61
  step_pure with q39
  step_pure with h63
  step_pure with h64
  step_pure with q48
  step_pure with h66
  step_pure with h67
  step_pure with h68
  step_pure with q57
  step_pure with h70
  step_pure with h71
  step_pure with q66
  step_pure with l73
  step_pure with l74
  step_pure with za03
  step_pure with l76
  step_pure with l77
  step_pure with za14
  step_pure with l79
  step_pure with l80
  step_pure with l81
  step_pure with l82
  step_pure with l83
  step_pure with l84
  step_pure with l85
  step_pure with zb03
  step_pure with l87
  step_pure with l88
  step_pure with zb14
  step_pure with l90
  step_pure with l91
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
  step_pure
  step_pure
  step_pure with z25
  iterate 3 step_store
  finish_block
  have e_x05 : x05 = wwl_pack_h0_h1 x03 x25 := by lanes hx05
  have e_x12 : x12 = wwl_pack_halves x14 0 x25 0 := by lanes hx12
  have e_x34 : x34 = wwl_pack_halves x03 1 x14 1 := by lanes hx34
  have e_x41 : x41 = wwl_pack_halves x14 1 x14 0 := by lanes hx41
  have e_x23 : x23 = wwl_pack_h0_h1 x25 x03 := by lanes hx23
  have e_x52 : x52 = wwl_pack_halves x25 1 x25 0 := by lanes hx52
  have e_x4z : x4z = wwl_pack_halves x14 1 wwl_zero 0 := by lanes hx4z
  have e_two_x03 : two_x03 = wwl_shl x03 1 := by lanes htwo_x03
  have e_two_x14 : two_x14 = wwl_shl x14 1 := by lanes htwo_x14
  have e_two_x05 : two_x05 = wwl_shl x05 1 := by lanes htwo_x05
  have e_two_x12 : two_x12 = wwl_shl x12 1 := by lanes htwo_x12
  have e_p0a : p0a = wwl_madd52lo wwl_zero x05 x05 := by lanes hp0a
  have e_p19 : p19 = wwl_madd52lo wwl_zero two_x05 x14 := by lanes hp19
  have e_a47 : a47 = wwl_madd52lo wwl_zero x14 x14 := by lanes ha47
  have e_p28 : p28 = wwl_madd52lo a47 two_x03 x25 := by lanes hp28
  have e_a49 : a49 = wwl_madd52lo wwl_zero two_x03 x34 := by lanes ha49
  have e_p37 : p37 = wwl_madd52lo a49 two_x12 x25 := by lanes hp37
  have e_a51 : a51 = wwl_madd52lo wwl_zero x23 x23 := by lanes ha51
  have e_a52 : a52 = wwl_madd52lo a51 two_x05 x41 := by lanes ha52
  have e_p46 : p46 = wwl_madd52lo a52 two_x12 x34 := by lanes hp46
  have e_a54 : a54 = wwl_madd52lo wwl_zero two_x03 x52 := by lanes ha54
  have e_p55 : p55 = wwl_madd52lo a54 two_x14 x4z := by lanes hp55
  have e_h56 : h56 = wwl_madd52hi wwl_zero x05 x05 := by lanes hh56
  have e_q1b : q1b = wwl_shl h56 9 := by lanes hq1b
  have e_h58 : h58 = wwl_madd52hi wwl_zero two_x05 x14 := by lanes hh58
  have e_q2a : q2a = wwl_shl h58 9 := by lanes hq2a
  have e_h60 : h60 = wwl_madd52hi wwl_zero x14 x14 := by lanes hh60
  have e_h61 : h61 = wwl_madd52hi h60 two_x03 x25 := by lanes hh61
  have e_q39 : q39 = wwl_shl h61 9 := by lanes hq39
  have e_h63 : h63 = wwl_madd52hi wwl_zero two_x03 x34 := by lanes hh63
  have e_h64 : h64 = wwl_madd52hi h63 two_x12 x25 := by lanes hh64
  have e_q48 : q48 = wwl_shl h64 9 := by lanes hq48
  have e_h66 : h66 = wwl_madd52hi wwl_zero x23 x23 := by lanes hh66
  have e_h67 : h67 = wwl_madd52hi h66 two_x05 x41 := by lanes hh67
  have e_h68 : h68 = wwl_madd52hi h67 two_x12 x34 := by lanes hh68
  have e_q57 : q57 = wwl_shl h68 9 := by lanes hq57
  have e_h70 : h70 = wwl_madd52hi wwl_zero two_x03 x52 := by lanes hh70
  have e_h71 : h71 = wwl_madd52hi h70 two_x14 x4z := by lanes hh71
  have e_q66 : q66 = wwl_shl h71 9 := by lanes hq66
  have e_l73 : l73 = wwl_pack_halves p0a 0 p37 0 := by lanes hl73
  have e_l74 : l74 = wwl_pack_halves wwl_zero 0 q39 0 := by lanes hl74
  have e_za03 : za03 = wwl_add l73 l74 := by lanes hza03
  have e_l76 : l76 = wwl_pack_halves p19 0 p46 0 := by lanes hl76
  have e_l77 : l77 = wwl_pack_halves q1b 0 q48 0 := by lanes hl77
  have e_za14 : za14 = wwl_add l76 l77 := by lanes hza14
  have e_l79 : l79 = wwl_pack_halves p28 0 p55 0 := by lanes hl79
  have e_l80 : l80 = wwl_pack_halves q2a 0 q57 0 := by lanes hl80
  have e_l81 : l81 = wwl_pack_h0_h1 wwl_zero p55 := by lanes hl81
  have e_l82 : l82 = wwl_pack_halves p46 1 p19 1 := by lanes hl82
  have e_l83 : l83 = wwl_pack_halves q66 1 q39 1 := by lanes hl83
  have e_l84 : l84 = wwl_add l82 l83 := by lanes hl84
  have e_l85 : l85 = wwl_pack_h0_h1 q66 wwl_zero := by lanes hl85
  have e_zb03 : zb03 = wwl_add l84 l85 := by lanes hzb03
  have e_l87 : l87 = wwl_pack_halves p37 1 p0a 1 := by lanes hl87
  have e_l88 : l88 = wwl_pack_halves q57 1 q2a 1 := by lanes hl88
  have e_zb14 : zb14 = wwl_add l87 l88 := by lanes hzb14
  have e_l90 : l90 = wwl_pack_halves p28 1 wwl_zero 1 := by lanes hl90
  have e_l91 : l91 = wwl_pack_halves q48 1 q1b 1 := by lanes hl91
  have e_zb25 : zb25 = wwl_add l90 l91 := by lanes hzb25
  have e_z03 : z03 =
      wwl_add (wwl_add za03 (wwl_shl zb03 7)) (wwl_add (wwl_shl zb03 4) (wwl_shl zb03 3)) := by
    lanes hz03
  have e_z14 : z14 =
      wwl_add (wwl_add za14 (wwl_shl zb14 7)) (wwl_add (wwl_shl zb14 4) (wwl_shl zb14 3)) := by
    lanes hz14
  have e_z25 : z25 =
      wwl_add (wwl_add (wwl_add (wwl_add l81 l79) (wwl_shl zb25 7))
        (wwl_add (wwl_shl zb25 4) (wwl_shl zb25 3))) l80 := by
    lanes hz25
  replace e_z25 : z25 =
      wwl_add (wwl_add (wwl_add (wwl_add l79 l80) l81) (wwl_shl zb25 7))
        (wwl_add (wwl_shl zb25 4) (wwl_shl zb25 3)) := by
    rw [e_z25]; ac_rfl
  clear hArgs hE hx05 hx12 hx34 hx41 hx23 hx52 hx4z htwo_x03 htwo_x14 htwo_x05 htwo_x12 hp0a hp19
    ha47 hp28 ha49 hp37 ha51 ha52 hp46 ha54 hp55 hh56 hq1b hh58 hq2a hh60 hh61 hq39 hh63 hh64 hq48
    hh66 hh67 hh68 hq57 hh70 hh71 hq66 hl73 hl74 hza03 hl76 hl77 hza14 hl79 hl80 hl81 hl82 hl83 hl84
    hl85 hzb03 hl87 hl88 hzb14 hl90 hl91 hzb25 hz03 hz14 hz25
  subst_vars
  rfl


end Proof

end MLIR.Firedancer.Avx512
