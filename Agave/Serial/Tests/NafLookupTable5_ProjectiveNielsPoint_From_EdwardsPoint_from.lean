module

public import Agave.Serial.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

meta import Agave.Serial.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

namespace MLIR.Agave.Serial

open NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a zeroed 1280-byte block, `a` holding `aBytes`; then
the globals'. -/
private def state (aBytes : BitVec 1280) : GlobalState :=
  GlobalState.withGlobals NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.globals
    ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 1280 0), (⟨2⟩, .ofBytes 160 aBytes)]⟩⟩

/-- A field element from its limbs, lowest first. -/
private def fe (l0 l1 l2 l3 l4 : Nat) : BitVec 320 :=
  limbsBits fun
    | 0 => BitVec.ofNat 64 l0
    | 1 => BitVec.ofNat 64 l1
    | 2 => BitVec.ofNat 64 l2
    | 3 => BitVec.ofNat 64 l3
    | 4 => BitVec.ofNat 64 l4

/-- `ED25519_BASEPOINT_POINT`'s `X, Y, Z, T`. -/
private def bX : BitVec 320 :=
  fe 1738742601995546 1146398526822698 2070867633025821 562264141797630 587772402128613

private def bY : BitVec 320 :=
  fe 1801439850948184 1351079888211148 450359962737049 900719925474099 1801439850948198

private def bZ : BitVec 320 :=
  fe 1 0 0 0 0

private def bT : BitVec 320 :=
  fe 1841354044333475 16398895984059 755974180946558 900171276175154 1821297809914039

/-- Limbs up to `2^52`. -/
private def mixed : BitVec 320 :=
  fe (2 ^ 52 - 1) 1 (2 ^ 51) 3 (2 ^ 50 + 7)

/-- A point's coordinates' limbs, each computed once. -/
private abbrev V4 :=
  Vector (BitVec 64) 5 × Vector (BitVec 64) 5 × Vector (BitVec 64) 5 × Vector (BitVec 64) 5

private def ofEdwards (P : EdwardsPoint) : V4 :=
  (Vector.ofFn P.X, Vector.ofFn P.Y, Vector.ofFn P.Z, Vector.ofFn P.T)

private def ofCompleted (P : CompletedPoint) : V4 :=
  (Vector.ofFn P.X, Vector.ofFn P.Y, Vector.ofFn P.Z, Vector.ofFn P.T)

private def ofNiels (P : ProjectiveNielsPoint) : V4 :=
  (Vector.ofFn P.Y_plus_X, Vector.ofFn P.Y_minus_X, Vector.ofFn P.Z, Vector.ofFn P.T2d)

/-- `Ai A 0 … Ai A n`, last first: `Ai`'s recursion, each point's limbs computed once (`spec`'s
limb functions are recomputed at every use). -/
private def table (A : EdwardsPoint) : Nat → List V4
  | 0 => [ofNiels (EdwardsPoint_as_projective_niels.spec A)]
  | n + 1 =>
    let t := table A n
    let (dx, dy, dz, dt) := ofEdwards (double A)
    let (p, m, z, t2d) := t.headD (ofNiels (EdwardsPoint_as_projective_niels.spec A))
    let (cx, cy, cz, ct) :=
      ofCompleted
        (EdwardsPoint_Add_ProjectiveNielsPoint_add.spec ⟨dx.get, dy.get, dz.get, dt.get⟩
          ⟨p.get, m.get, z.get, t2d.get⟩)
    let (ex, ey, ez, et) :=
      ofEdwards (CompletedPoint_as_extended.spec ⟨cx.get, cy.get, cz.get, ct.get⟩)
    ofNiels (EdwardsPoint_as_projective_niels.spec ⟨ex.get, ey.get, ez.get, et.get⟩) :: t

/-- The run stores `spec`'s points (`table`) at `out`, entry by entry, and counts 64 blocks. -/
private def agrees (s : GlobalState) : Bool :=
  match
    NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.eval 2
      (args (.value out) (.value a)) s with
  | .value (some .nil, s') =>
    let T := (table (s.mem.readEdwards a) 7).reverse
    s'.alloc.nextFreeBlock == s.alloc.nextFreeBlock + 64 &&
      (List.range 8).all fun i =>
        ofNiels (s'.mem.readNiels (out.add (BitVec.ofNat 64 (160 * i)))) == T[i]!
  | _ => false

#guard agrees (state (bT ++ bZ ++ bY ++ bX))

#guard agrees (state (mixed ++ bZ ++ mixed ++ mixed))

end MLIR.Agave.Serial
