module

public import Agave.Common.Naf
public import Agave.Common.Point
public import Agave.Serial.CompletedPoint_as_extended
public import Agave.Serial.CompletedPoint_as_projective
public import Agave.Serial.EdwardsPoint_Add_ProjectiveNielsPoint_add
public import Agave.Serial.EdwardsPoint_is_small_order
public import Agave.Serial.FieldElement51_Add_add
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.FieldElement51_Sub_sub
public import Agave.Serial.FieldElement51_square
public import Agave.Serial.Mlir.anon_042b818bc72209407b52bd0e4d6c8368_73
public import Agave.Serial.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from
public import Agave.Serial.ProjectivePoint_double

namespace MLIR.Agave.Serial

/-! ## Specification

The digits are `Scalar_non_adjacent_form.spec`'s bytes; `table_B`'s entries are read from its
global's bits. -/

@[expose] public section

/-- `AffineNielsPoint`: `(y + x, y - x, 2d x y)` of an affine point. -/
structure _root_.MLIR.Agave.AffineNielsPoint where
  y_plus_x : Fin 5 → BitVec 64
  y_minus_x : Fin 5 → BitVec 64
  xy2d : Fin 5 → BitVec 64

/-- `ProjectivePoint::identity()`: `(0, 1, 1)`. -/
def ProjectivePoint_identity.spec : ProjectivePoint :=
  ⟨FieldElement51.ZERO, FieldElement51.ONE, FieldElement51.ONE⟩

/-- `ProjectivePoint::as_extended`: `(X Z, Y Z, Z², X Y)`. -/
def ProjectivePoint_as_extended.spec (P : ProjectivePoint) : EdwardsPoint :=
  ⟨FieldElement51_Mul_mul.spec P.X P.Z, FieldElement51_Mul_mul.spec P.Y P.Z,
    FieldElement51_square.spec P.Z, FieldElement51_Mul_mul.spec P.X P.Y⟩

/-- `&P - &Q` for a `ProjectiveNielsPoint` `Q`, named as in the Rust: `PM = (Y + X) Q.Y_minus_X`,
`MP = (Y - X) Q.Y_plus_X`, `TT2d = T Q.T2d`, `ZZ2 = 2 Z Q.Z`; the difference is
`(PM - MP, PM + MP, ZZ2 - TT2d, ZZ2 + TT2d)`. -/
def EdwardsPoint_Sub_ProjectiveNielsPoint_sub.spec (P : EdwardsPoint) (Q : ProjectiveNielsPoint) :
    CompletedPoint :=
  let Y_plus_X := FieldElement51_Add_add.spec P.Y P.X
  let Y_minus_X := FieldElement51_Sub_sub.spec P.Y P.X
  let PM := FieldElement51_Mul_mul.spec Y_plus_X Q.Y_minus_X
  let MP := FieldElement51_Mul_mul.spec Y_minus_X Q.Y_plus_X
  let TT2d := FieldElement51_Mul_mul.spec P.T Q.T2d
  let ZZ := FieldElement51_Mul_mul.spec P.Z Q.Z
  let ZZ2 := FieldElement51_Add_add.spec ZZ ZZ
  ⟨FieldElement51_Sub_sub.spec PM MP, FieldElement51_Add_add.spec PM MP,
    FieldElement51_Sub_sub.spec ZZ2 TT2d, FieldElement51_Add_add.spec ZZ2 TT2d⟩

/-- `&P + &Q` for an `AffineNielsPoint` `Q`, named as in the Rust: `PP = (Y + X) Q.y_plus_x`,
`MM = (Y - X) Q.y_minus_x`, `Txy2d = T Q.xy2d`, `Z2 = Z + Z`; the sum is
`(PP - MM, PP + MM, Z2 + Txy2d, Z2 - Txy2d)`. -/
def EdwardsPoint_Add_AffineNielsPoint_add.spec (P : EdwardsPoint) (Q : AffineNielsPoint) :
    CompletedPoint :=
  let Y_plus_X := FieldElement51_Add_add.spec P.Y P.X
  let Y_minus_X := FieldElement51_Sub_sub.spec P.Y P.X
  let PP := FieldElement51_Mul_mul.spec Y_plus_X Q.y_plus_x
  let MM := FieldElement51_Mul_mul.spec Y_minus_X Q.y_minus_x
  let Txy2d := FieldElement51_Mul_mul.spec P.T Q.xy2d
  let Z2 := FieldElement51_Add_add.spec P.Z P.Z
  ⟨FieldElement51_Sub_sub.spec PP MM, FieldElement51_Add_add.spec PP MM,
    FieldElement51_Add_add.spec Z2 Txy2d, FieldElement51_Sub_sub.spec Z2 Txy2d⟩

/-- `&P - &Q` for an `AffineNielsPoint` `Q`, named as in the Rust: `PM = (Y + X) Q.y_minus_x`,
`MP = (Y - X) Q.y_plus_x`, `Txy2d = T Q.xy2d`, `Z2 = Z + Z`; the difference is
`(PM - MP, PM + MP, Z2 - Txy2d, Z2 + Txy2d)`. -/
def EdwardsPoint_Sub_AffineNielsPoint_sub.spec (P : EdwardsPoint) (Q : AffineNielsPoint) :
    CompletedPoint :=
  let Y_plus_X := FieldElement51_Add_add.spec P.Y P.X
  let Y_minus_X := FieldElement51_Sub_sub.spec P.Y P.X
  let PM := FieldElement51_Mul_mul.spec Y_plus_X Q.y_minus_x
  let MP := FieldElement51_Mul_mul.spec Y_minus_X Q.y_plus_x
  let Txy2d := FieldElement51_Mul_mul.spec P.T Q.xy2d
  let Z2 := FieldElement51_Add_add.spec P.Z P.Z
  ⟨FieldElement51_Sub_sub.spec PM MP, FieldElement51_Add_add.spec PM MP,
    FieldElement51_Sub_sub.spec Z2 Txy2d, FieldElement51_Add_add.spec Z2 Txy2d⟩

namespace mul

/-- Digit `i` of a NAF's bytes. -/
abbrev digit (naf : BitVec (8 * 256)) (i : Nat) : BitVec 8 :=
  naf.extractLsb' (i * 8) 8

/-- The `AffineNielsPoint` at bit `o` of `t`: `y_plus_x, y_minus_x, xy2d` 320 bits apart. -/
def affineAt (t : BitVec n) (o : Nat) : AffineNielsPoint :=
  ⟨fun k => t.extractLsb' (o + 64 * k.val) 64, fun k => t.extractLsb' (o + 320 + 64 * k.val) 64,
    fun k => t.extractLsb' (o + 640 + 64 * k.val) 64⟩

/-- `table_B[j]`: entry `j` of the bits `addressof` stores, 120 bytes each. -/
def tableB (j : Nat) : AffineNielsPoint :=
  affineAt (Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_73.lit (w := 61440) (hw := rfl))
    (960 * j)

/-- `a_naf[i]`'s add on `t`: `t = &t.as_extended() ± &table_A.select(|d|)`, `select(x)` being
entry `x / 2`; none at `d = 0`. -/
def addA (tA : Nat → ProjectiveNielsPoint) (d : BitVec 8) (t : CompletedPoint) : CompletedPoint :=
  if (0#8).slt d then
    EdwardsPoint_Add_ProjectiveNielsPoint_add.spec (CompletedPoint_as_extended.spec t)
      (tA (d >>> 1).toNat)
  else
    if d.slt 0#8 then
      EdwardsPoint_Sub_ProjectiveNielsPoint_sub.spec (CompletedPoint_as_extended.spec t)
        (tA ((-d) >>> 1).toNat)
    else t

/-- `b_naf[i]`'s add on `t`, from `table_B`. -/
def addB (tB : Nat → AffineNielsPoint) (d : BitVec 8) (t : CompletedPoint) : CompletedPoint :=
  if (0#8).slt d then
    EdwardsPoint_Add_AffineNielsPoint_add.spec (CompletedPoint_as_extended.spec t)
      (tB (d >>> 1).toNat)
  else
    if d.slt 0#8 then
      EdwardsPoint_Sub_AffineNielsPoint_sub.spec (CompletedPoint_as_extended.spec t)
        (tB ((-d) >>> 1).toNat)
    else t

/-- An iteration on `r`: `t = r.double()`, the two digits' adds, `r = t.as_projective()`. -/
def step (tA : Nat → ProjectiveNielsPoint) (tB : Nat → AffineNielsPoint) (da db : BitVec 8)
    (r : ProjectivePoint) : ProjectivePoint :=
  CompletedPoint_as_projective.spec (addB tB db (addA tA da (ProjectivePoint_double.spec r)))

/-- The main loop from `i` down to `0` on `r`. -/
def ladder (tA : Nat → ProjectiveNielsPoint) (tB : Nat → AffineNielsPoint)
    (a_naf b_naf : BitVec (8 * 256)) : Nat → ProjectivePoint → ProjectivePoint
  | 0, r => step tA tB (digit a_naf 0) (digit b_naf 0) r
  | i + 1, r =>
    ladder tA tB a_naf b_naf i (step tA tB (digit a_naf (i + 1)) (digit b_naf (i + 1)) r)

/-- `for j in (0..256).rev() { i = j; if a_naf[i] != 0 || b_naf[i] != 0 { break; } }` from `j`
down: the `i` it stops at, `0` if no digit is non-zero. -/
def start (a_naf b_naf : BitVec (8 * 256)) : Nat → Nat
  | 0 => 0
  | j + 1 =>
    if digit a_naf (j + 1) = 0#8 ∧ digit b_naf (j + 1) = 0#8 then start a_naf b_naf j else j + 1

/-- Blocks a digit's add on `table_A` allocates: seven for a positive one (the call to
`EdwardsPoint_Add_ProjectiveNielsPoint_add`), none for the inlined subtraction. -/
def digitBlocks (d : BitVec 8) : Nat :=
  if (0#8).slt d then 7 else 0

/-- Blocks the main loop's callees allocate from `i` down: `ProjectivePoint_double`'s seven per
iteration and the positive `a_naf` digits' adds. -/
def ladderBlocks (a_naf : BitVec (8 * 256)) : Nat → Nat
  | 0 => 7 + digitBlocks (digit a_naf 0)
  | i + 1 => 7 + digitBlocks (digit a_naf (i + 1)) + ladderBlocks a_naf i

end mul

open mul in
/-- `vartime_double_base::mul(a, A, b)`, `a A + b B`, as the code computes it: the width-5 and
width-8 NAFs, `table_A = NafLookupTable5::from(A)`, the main loop on the identity from the start
index, then `as_extended`. -/
def mul.spec (a : BitVec 256) (A : EdwardsPoint) (b : BitVec 256) : EdwardsPoint :=
  let a_naf := Scalar_non_adjacent_form.spec a 5
  let b_naf := Scalar_non_adjacent_form.spec b 8
  ProjectivePoint_as_extended.spec
    (ladder (NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.Ai A) tableB a_naf b_naf
      (start a_naf b_naf 255) ProjectivePoint_identity.spec)

open mul in
/-- The blocks the function allocates, its callees' included: 106 before the main loop (28 slots,
4 globals, the NAFs' one each, `table_A`'s 72). -/
def mul.blocks (a b : BitVec 256) : Nat :=
  let a_naf := Scalar_non_adjacent_form.spec a 5
  let b_naf := Scalar_non_adjacent_form.spec b 8
  106 + ladderBlocks a_naf (start a_naf b_naf 255)

end

end MLIR.Agave.Serial
