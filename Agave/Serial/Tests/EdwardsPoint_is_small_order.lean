module

public import Agave.Serial.EdwardsPoint_is_small_order

meta import Agave.Serial.EdwardsPoint_is_small_order

namespace MLIR.Agave.Serial

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Block 0 free (the null pointer's); `a` holding `aBytes`. -/
private def state (aBytes : BitVec 1280) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 160 aBytes)]⟩⟩

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

/-- The run returns `r`. `spec`'s nested limb functions are too slow to evaluate here; `call_eq`
equates it with the run. -/
private def returns (s : GlobalState) (r : BitVec 1) : Bool :=
  match EdwardsPoint_is_small_order.eval 1 (EdwardsPoint_is_small_order.args (.value a)) s with
  | .value (some (.cons v .nil), _) => v == .value r
  | _ => false

-- the identity: small order
#guard returns (state (fe 0 0 0 0 0 ++ bZ ++ bZ ++ fe 0 0 0 0 0)) 1

-- `(0, -1)`, of order 2
#guard
  returns
    (state
      (fe 0 0 0 0 0 ++ bZ ++ fe (2 ^ 51 - 20) (2 ^ 51 - 1) (2 ^ 51 - 1) (2 ^ 51 - 1) (2 ^ 51 - 1) ++
        fe 0 0 0 0 0))
    1

-- the basepoint: large order
#guard returns (state (bT ++ bZ ++ bY ++ bX)) 0

end MLIR.Agave.Serial
