module

public import Agave.Serial.mul

meta import Agave.Serial.mul

namespace MLIR.Agave.Serial

open mul NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

private def A : Pointer :=
  ⟨⟨3⟩, 0⟩

private def b : Pointer :=
  ⟨⟨4⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a zeroed 160-byte block, `a`, `A` and `b` holding
`aBytes`, `ABytes` and `bBytes`. -/
private def state (aBytes : BitVec 256) (ABytes : BitVec 1280) (bBytes : BitVec 256) :
    GlobalState :=
  ⟨⟨5⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 160 0), (⟨2⟩, .ofBytes 32 aBytes), (⟨3⟩, .ofBytes 160 ABytes),
          (⟨4⟩, .ofBytes 32 bBytes)]⟩⟩

/-- A field element from its limbs, lowest first. -/
private def fe (l0 l1 l2 l3 l4 : Nat) : BitVec 320 :=
  limbsBits fun
    | 0 => BitVec.ofNat 64 l0
    | 1 => BitVec.ofNat 64 l1
    | 2 => BitVec.ofNat 64 l2
    | 3 => BitVec.ofNat 64 l3
    | 4 => BitVec.ofNat 64 l4

/-- `ED25519_BASEPOINT_POINT`'s `X, Y, Z, T`, `X` lowest. -/
private def basepoint : BitVec 1280 :=
  fe 1841354044333475 16398895984059 755974180946558 900171276175154 1821297809914039 ++
    fe 1 0 0 0 0 ++
    fe 1801439850948184 1351079888211148 450359962737049 900719925474099 1801439850948198 ++
    fe 1738742601995546 1146398526822698 2070867633025821 562264141797630 587772402128613

/-! ### Memoized spec

Spec limbs are functions, recomputed at every use; each point below is stored as vectors once. -/

private abbrev Fe :=
  Vector (BitVec 64) 5

private def memoE (P : EdwardsPoint) : EdwardsPoint :=
  let (x, y, z, t) : Fe × Fe × Fe × Fe :=
    (Vector.ofFn P.X, Vector.ofFn P.Y, Vector.ofFn P.Z, Vector.ofFn P.T)
  ⟨x.get, y.get, z.get, t.get⟩

private def memoC (P : CompletedPoint) : CompletedPoint :=
  let (x, y, z, t) : Fe × Fe × Fe × Fe :=
    (Vector.ofFn P.X, Vector.ofFn P.Y, Vector.ofFn P.Z, Vector.ofFn P.T)
  ⟨x.get, y.get, z.get, t.get⟩

private def memoP (P : ProjectivePoint) : ProjectivePoint :=
  let (x, y, z) : Fe × Fe × Fe := (Vector.ofFn P.X, Vector.ofFn P.Y, Vector.ofFn P.Z)
  ⟨x.get, y.get, z.get⟩

private def memoN (P : ProjectiveNielsPoint) : ProjectiveNielsPoint :=
  let (p, m, z, t) : Fe × Fe × Fe × Fe :=
    (Vector.ofFn P.Y_plus_X, Vector.ofFn P.Y_minus_X, Vector.ofFn P.Z, Vector.ofFn P.T2d)
  ⟨p.get, m.get, z.get, t.get⟩

/-- `Ai A 0 … Ai A n`, last first. -/
private def tableA (A : EdwardsPoint) : Nat → List ProjectiveNielsPoint
  | 0 => [memoN (EdwardsPoint_as_projective_niels.spec A)]
  | n + 1 =>
    let t := tableA A n
    let D := memoE (double A)
    let C := memoC (EdwardsPoint_Add_ProjectiveNielsPoint_add.spec D (t.headD (memoN (Ai A 0))))
    memoN (EdwardsPoint_as_projective_niels.spec (memoE (CompletedPoint_as_extended.spec C))) :: t

/-- `addA`, memoized. -/
private def addA' (tA : Nat → ProjectiveNielsPoint) (d : BitVec 8) (t : CompletedPoint) :
    CompletedPoint :=
  if (0#8).slt d then
    memoC
      (EdwardsPoint_Add_ProjectiveNielsPoint_add.spec (memoE (CompletedPoint_as_extended.spec t))
        (tA (d >>> 1).toNat))
  else
    if d.slt 0#8 then
      memoC
        (EdwardsPoint_Sub_ProjectiveNielsPoint_sub.spec (memoE (CompletedPoint_as_extended.spec t))
          (tA ((-d) >>> 1).toNat))
    else t

/-- `addB`, memoized. -/
private def addB' (tB : Nat → AffineNielsPoint) (d : BitVec 8) (t : CompletedPoint) :
    CompletedPoint :=
  if (0#8).slt d then
    memoC
      (EdwardsPoint_Add_AffineNielsPoint_add.spec (memoE (CompletedPoint_as_extended.spec t))
        (tB (d >>> 1).toNat))
  else
    if d.slt 0#8 then
      memoC
        (EdwardsPoint_Sub_AffineNielsPoint_sub.spec (memoE (CompletedPoint_as_extended.spec t))
          (tB ((-d) >>> 1).toNat))
    else t

/-- `ladder`, memoized. -/
private def ladder' (tA : Nat → ProjectiveNielsPoint) (tB : Nat → AffineNielsPoint)
    (a_naf b_naf : BitVec (8 * 256)) (i : Nat) (r : ProjectivePoint) : ProjectivePoint :=
  let r :=
    memoP
      (CompletedPoint_as_projective.spec
        (addB' tB (digit b_naf i)
          (addA' tA (digit a_naf i) (memoC (ProjectivePoint_double.spec r)))))
  match i with
  | 0 => r
  | i + 1 => ladder' tA tB a_naf b_naf i r

/-- `mul.spec`, memoized. -/
private def spec' (a : BitVec 256) (A : EdwardsPoint) (b : BitVec 256) : EdwardsPoint :=
  let a_naf := Scalar_non_adjacent_form.spec a 5
  let b_naf := Scalar_non_adjacent_form.spec b 8
  let T := (tableA A 7).reverse
  let tB := (List.range 64).map fun j => tableB j
  memoE
    (ProjectivePoint_as_extended.spec
      (ladder' (fun i => T.getD i (Ai A 0)) (fun j => tB.getD j (tableB 0)) a_naf b_naf
        (start a_naf b_naf 255) ProjectivePoint_identity.spec))

private def eqE (P Q : EdwardsPoint) : Bool :=
  (List.finRange 5).all fun k =>
    P.X k == Q.X k && P.Y k == Q.Y k && P.Z k == Q.Z k && P.T k == Q.T k

/-! ### Tests -/

/-- The run on scalars `x`, `y` and the point bits `P` stores `E` at `out` and counts
`5 + blocks`. -/
private def agrees (x : Nat) (P : BitVec 1280) (y : Nat)
    (E : BitVec 256 → EdwardsPoint → BitVec 256 → EdwardsPoint) : Bool :=
  let s := state (BitVec.ofNat 256 x) P (BitVec.ofNat 256 y)
  match mul.eval 1000 (mul.args (.value out) (.value a) (.value A) (.value b)) s with
  | .value (some .nil, s') =>
    s'.alloc.nextFreeBlock == 5 + mul.blocks (BitVec.ofNat 256 x) (BitVec.ofNat 256 y) &&
      eqE (s'.mem.readEdwards out)
        (E (BitVec.ofNat 256 x) (s.mem.readEdwards A) (BitVec.ofNat 256 y))
  | _ => false

-- `mul.spec` itself, where nothing is added (`mul.spec` on a digit takes minutes)
#guard agrees 0 basepoint 0 mul.spec

private def eqC (P Q : CompletedPoint) : Bool :=
  (List.finRange 5).all fun k =>
    P.X k == Q.X k && P.Y k == Q.Y k && P.Z k == Q.Z k && P.T k == Q.T k

-- the memoized adds agree with `addA` and `addB` on `2 B`, for digits `0, 1, 3, 15, -1, -15` and
-- `0, 1, 127, -1, -127`
#guard
  let P := memoE ((state 0 basepoint 0).mem.readEdwards A)
  let t := memoC (ProjectivePoint_double.spec ⟨P.X, P.Y, P.Z⟩)
  let T := (tableA P 7).reverse
  let tA := fun i => T.getD i (Ai P 0)
  [0#8, 1#8, 3#8, 15#8, 0xff#8, 0xf1#8].all fun d => eqC (addA tA d t) (addA' tA d t)

#guard
  let P := memoE ((state 0 basepoint 0).mem.readEdwards A)
  let t := memoC (ProjectivePoint_double.spec ⟨P.X, P.Y, P.Z⟩)
  [0#8, 1#8, 127#8, 0xff#8, 0x81#8].all fun d => eqC (addB tableB d t) (addB' tableB d t)

-- the run against the memoized spec: positive and negative digits of both tables, their largest
-- entries, up to 11 iterations
#guard agrees 1 basepoint 1 spec'

#guard agrees 2 basepoint 3 spec'

#guard agrees 15 basepoint 127 spec'

#guard agrees 31 basepoint 255 spec'

#guard agrees 1000 basepoint 129 spec'

end MLIR.Agave.Serial
