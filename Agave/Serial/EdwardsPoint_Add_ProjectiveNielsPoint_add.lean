module

public import MLIR.Run.Tactic
public import Agave.Common.Point
public import Firedancer.Common.Tactics
public import Agave.Serial.FieldElement51_Add_add
public import Agave.Serial.FieldElement51_Sub_sub
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.Mlir.EdwardsPoint_Add_ProjectiveNielsPoint_add

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `&P + &Q` for a `ProjectiveNielsPoint` `Q`, named as in the Rust: `PP = (Y + X) Q.Y_plus_X`,
`MM = (Y - X) Q.Y_minus_X`, `TT2d = T Q.T2d`, `ZZ2 = 2 Z Q.Z`; the sum is
`(PP - MM, PP + MM, ZZ2 + TT2d, ZZ2 - TT2d)`. -/
def EdwardsPoint_Add_ProjectiveNielsPoint_add.spec (P : EdwardsPoint) (Q : ProjectiveNielsPoint) :
    CompletedPoint :=
  let Y_plus_X := FieldElement51_Add_add.spec P.Y P.X
  let Y_minus_X := FieldElement51_Sub_sub.spec P.Y P.X
  let PP := FieldElement51_Mul_mul.spec Y_plus_X Q.Y_plus_X
  let MM := FieldElement51_Mul_mul.spec Y_minus_X Q.Y_minus_X
  let TT2d := FieldElement51_Mul_mul.spec P.T Q.T2d
  let ZZ := FieldElement51_Mul_mul.spec P.Z Q.Z
  let ZZ2 := FieldElement51_Add_add.spec ZZ ZZ
  ⟨FieldElement51_Sub_sub.spec PP MM, FieldElement51_Add_add.spec PP MM,
    FieldElement51_Add_add.spec ZZ2 TT2d, FieldElement51_Sub_sub.spec ZZ2 TT2d⟩

end

/-! ## Proof -/

section Proof

-- about 60 steps over a frame of 7 slots and 13 calls: past the default heartbeats
set_option maxHeartbeats 400000 in
/-- `&P + &Q` stores `spec P Q` at `out`. Every read of `P` and `Q` comes before the first store to
`out`, so `out` may alias them. Its seven temporaries count seven blocks. -/
public theorem EdwardsPoint_Add_ProjectiveNielsPoint_add.call_eq (out p q : Pointer)
    (s : GlobalState) (hwf : s.WF) (hout : s.mem.PointRoom out) (hp : s.mem.PointFit p)
    (hq : s.mem.PointFit q) :
    EdwardsPoint_Add_ProjectiveNielsPoint_add.call
        (EdwardsPoint_Add_ProjectiveNielsPoint_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem :=
              s.mem.storeCompleted out
                (EdwardsPoint_Add_ProjectiveNielsPoint_add.spec (s.mem.readEdwards p)
                  (s.mem.readNiels q)) }) := by
  func_init
  block_init
  step_pure
  step_alloca with zz2
  step_alloca with zz
  step_alloca with tt2d
  step_alloca with mm
  step_alloca with pp
  step_alloca with ymx
  step_alloca with ypx
  -- let Y_plus_X = &self.Y + &self.X;
  step_pure
  limbs_room ypx
  step_pure
  step_call using FieldElement51_Add_add.call_eq
  name_limbs Y_plus_X
  -- let Y_minus_X = &self.Y - &self.X;
  step_pure
  limbs_room ymx
  step_call using FieldElement51_Sub_sub.call_eq
  name_limbs Y_minus_X
  -- let PP = &Y_plus_X * &other.Y_plus_X;
  step_pure
  limbs_room pp
  step_call using FieldElement51_Mul_mul.call_eq consuming hread_ypx hread_ypx_readLimbs hypx_limbs
  name_limbs PP
  -- let MM = &Y_minus_X * &other.Y_minus_X;
  step_pure
  limbs_room mm
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq consuming hread_ymx hread_ymx_readLimbs hymx_limbs
  name_limbs MM
  -- let TT2d = &self.T * &other.T2d;
  step_pure
  limbs_room tt2d
  step_pure
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs TT2d
  -- let ZZ = &self.Z * &other.Z;
  step_pure
  limbs_room zz
  step_pure
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs ZZ
  -- let ZZ2 = &ZZ + &ZZ;
  step_pure
  limbs_room zz2
  step_call using FieldElement51_Add_add.call_eq consuming hread_zz hread_zz_readLimbs hzz_limbs
  name_limbs ZZ2
  -- CompletedPoint { X: &PP - &MM, Y: &PP + &MM, Z: &ZZ2 + &TT2d, T: &ZZ2 - &TT2d }
  step_call using FieldElement51_Sub_sub.call_eq
  step_pure
  step_call using FieldElement51_Add_add.call_eq consuming hread_pp hread_pp_readLimbs hpp_limbs
    hread_mm hread_mm_readLimbs hmm_limbs
  step_pure
  step_call using FieldElement51_Add_add.call_eq
  step_pure
  step_call using FieldElement51_Sub_sub.call_eq consuming hread_zz2 hread_zz2_readLimbs hzz2_limbs
    hread_tt2d hread_tt2d_readLimbs htt2d_limbs
  iterate 7 step_pure
  finish_block
  clear_reads
  subst hS
  erase_frame
  subst_vars
  rfl

end Proof

end MLIR.Agave.Serial
