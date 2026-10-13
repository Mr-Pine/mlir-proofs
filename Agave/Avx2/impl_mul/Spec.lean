module

public import Agave.Avx2.EXTENDEDPOINT_IDENTITY
public import Agave.Avx2.ExtendedPoint_Sub_CachedPoint_sub_impl_sub
public import Agave.Avx2.ExtendedPoint_double_impl_double
public import Agave.Avx2.NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from
public import Agave.Avx2.NafLookupTable8_CachedPoint_select
public import Agave.Serial.mul.Spec

namespace MLIR.Agave.Avx2

/-! ## Specification

The digits are `Scalar_non_adjacent_form.spec`'s bytes, read as in the serial tree
(`Serial.mul.digit`, `Serial.mul.start`). -/

@[expose] public section

namespace impl_mul

open Serial.mul (digit start)

/-- A digit's add on `Q`, `T` the table's entries: `&Q + &table.select(d)`,
`&Q - &table.select(-d)`, `select(x)` being entry `x / 2`; none at `d = 0`. -/
def addDigit (T : Nat → Fe2625x4) (d : BitVec 8) (Q : Fe2625x4) : Fe2625x4 :=
  if (0#8).slt d then ExtendedPoint_Add_CachedPoint_add_impl_add.spec Q (T (d >>> 1).toNat)
  else
    if d.slt 0#8 then ExtendedPoint_Sub_CachedPoint_sub_impl_sub.spec Q (T ((-d) >>> 1).toNat)
    else Q

/-- An iteration on `Q`: `Q = Q.double()`, then the two digits' adds. -/
def step (tA tB : Nat → Fe2625x4) (da db : BitVec 8) (Q : Fe2625x4) : Fe2625x4 :=
  addDigit tB db (addDigit tA da (ExtendedPoint_double_impl_double.spec Q))

/-- The loop from `i` down to `0` on `Q`. -/
def ladder (tA tB : Nat → Fe2625x4) (a_naf b_naf : BitVec (8 * 256)) : Nat → Fe2625x4 → Fe2625x4
  | 0, Q => step tA tB (digit a_naf 0) (digit b_naf 0) Q
  | i + 1, Q =>
    ladder tA tB a_naf b_naf i (step tA tB (digit a_naf (i + 1)) (digit b_naf (i + 1)) Q)

open NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from in
/-- `table_A`'s entries, `NafLookupTable5::<CachedPoint>::from(A)`'s `Ai`. -/
def tableA (P : EdwardsPoint) : Nat → Fe2625x4 :=
  let A := Fe2625x4.new P.X P.Y P.Z P.T
  Ai A (ExtendedPoint_double_impl_double.spec A)

/-- `EdwardsPoint::from(Q)`: the four field elements of `Q.0.split()`. -/
def toEdwards (v : Fe2625x4) : EdwardsPoint :=
  ⟨Fe2625x4.split v 0, Fe2625x4.split v 1, Fe2625x4.split v 2, Fe2625x4.split v 3⟩

/-- Blocks a digit's add allocates, `sel` its `select`'s: `add`'s 6, `sub`'s 7; none at `0`. -/
def digitBlocks (sel : Nat) (d : BitVec 8) : Nat :=
  if (0#8).slt d then sel + 6 else if d.slt 0#8 then sel + 7 else 0

/-- Blocks the loop's callees allocate from `i` down: `double`'s 4 per iteration and the digits'
adds, `table_A.select`'s 1, `table_B.select`'s 2. -/
def ladderBlocks (a_naf b_naf : BitVec (8 * 256)) : Nat → Nat
  | 0 => 4 + digitBlocks 1 (digit a_naf 0) + digitBlocks 2 (digit b_naf 0)
  | i + 1 =>
    4 + digitBlocks 1 (digit a_naf (i + 1)) + digitBlocks 2 (digit b_naf (i + 1)) +
      ladderBlocks a_naf b_naf i

end impl_mul

open impl_mul Serial.mul in
/-- `vartime_double_base::spec_avx2::mul(a, A, b)`, `a A + b B`, as the code computes it: the
width-5 and width-8 NAFs, `table_A = NafLookupTable5::<CachedPoint>::from(A)`,
`BASEPOINT_ODD_LOOKUP_TABLE`, the loop on the identity from the start index, then `Q.into()`. -/
noncomputable def impl_mul.spec (a : BitVec 256) (A : EdwardsPoint) (b : BitVec 256) :
    EdwardsPoint :=
  let a_naf := Scalar_non_adjacent_form.spec a 5
  let b_naf := Scalar_non_adjacent_form.spec b 8
  toEdwards
    (ladder (tableA A) BASEPOINT_ODD_LOOKUP_TABLE.point a_naf b_naf (start a_naf b_naf 255)
      EXTENDEDPOINT_IDENTITY.point)

open impl_mul Serial.mul in
/-- The blocks the function allocates, its callees' included: 84 before the loop (the identity's
global, 13 slots, the NAFs' one each, `table_A`'s 68). -/
def impl_mul.blocks (a b : BitVec 256) : Nat :=
  let a_naf := Scalar_non_adjacent_form.spec a 5
  let b_naf := Scalar_non_adjacent_form.spec b 8
  84 + ladderBlocks a_naf b_naf (start a_naf b_naf 255)

end

end MLIR.Agave.Avx2
