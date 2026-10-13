module

public import Agave.Serial.VerificationKey_verify_dalek_prehashed

meta import Agave.Serial.VerificationKey_verify_dalek_prehashed

namespace MLIR.Agave.Serial

private def self : Pointer :=
  ⟨⟨1⟩, 0⟩

private def sig : Pointer :=
  ⟨⟨2⟩, 0⟩

private def h : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- Block 0 free (the null pointer's); `self` holding `minus_A`'s bits above 32 zero bytes, `sig`
holding `r ‖ s`, `h` holding `hb`; then the globals'. -/
private def state (minus_A : BitVec 1280) (r s hb : BitVec 256) : GlobalState :=
  GlobalState.withGlobals VerificationKey_verify_dalek_prehashed.globals
    ⟨⟨4⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, .ofBytes 192 (minus_A ++ 0#256)), (⟨2⟩, .ofBytes 64 (s ++ r)),
            (⟨3⟩, .ofBytes 32 hb)]⟩⟩

/-- A field element from its limbs, lowest first. -/
private def fe (l0 l1 l2 l3 l4 : Nat) : BitVec 320 :=
  limbsBits fun
    | 0 => BitVec.ofNat 64 l0
    | 1 => BitVec.ofNat 64 l1
    | 2 => BitVec.ofNat 64 l2
    | 3 => BitVec.ofNat 64 l3
    | 4 => BitVec.ofNat 64 l4

/-- The identity's `X, Y, Z, T` bits. -/
private def identity : BitVec 1280 :=
  fe 0 0 0 0 0 ++ fe 1 0 0 0 0 ++ fe 1 0 0 0 0 ++ fe 0 0 0 0 0

/-- `ED25519_BASEPOINT_POINT`'s `X, Y, Z, T` bits. -/
private def basepoint : BitVec 1280 :=
  fe 1841354044333475 16398895984059 755974180946558 900171276175154 1821297809914039 ++
    fe 1 0 0 0 0 ++
    fe 1801439850948184 1351079888211148 450359962737049 900719925474099 1801439850948198 ++
    fe 1738742601995546 1146398526822698 2070867633025821 562264141797630 587772402128613

/-- The basepoint's encoding, `y = 4/5`. -/
private def B : BitVec 256 :=
  0x6666666666666666666666666666666666666666666666666666666666666658#256

/-- `ℓ`. -/
private def ell : BitVec 256 :=
  0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed#256

/-- The run returns `ret`, its counter moved on by `n` if given (`blocks` on the early exits). -/
private def returns (s : GlobalState) (ret : BitVec 8) (n : Option Nat := none) : Bool :=
  match
    VerificationKey_verify_dalek_prehashed.eval 1000
      (VerificationKey_verify_dalek_prehashed.args (.value self) (.value sig) (.value h)) s with
  | .value (some (.cons v .nil), s') =>
    v == .value ret && n.all (s'.alloc.nextFreeBlock == s.alloc.nextFreeBlock + ·)
  | _ => false

-- `minus_A` the identity: small order
#guard returns (state identity B 1 0) 2 (some 115)

-- `r` with `y = 2`: no point
#guard returns (state basepoint 2 1 0) 2 (some (115 + 158))

-- `r` the identity's encoding: small order
#guard returns (state basepoint 1 1 0) 2 (some (115 + 260))

-- `s` with bit 255 set
#guard returns (state basepoint B (1 <<< 255) 0) 2 (some (115 + 260 + 54))

-- `s = ℓ`: not reduced
#guard returns (state basepoint B ell 0) 2 (some (115 + 260 + 54))

-- `[0] minus_A + [1] B = B`: `r = B` accepted
#guard returns (state basepoint B 1 0) (-1) (some (115 + 260 + 54 + mul.blocks 0 1 + 22))

-- `[0] minus_A + [2] B ≠ B`: rejected
#guard returns (state basepoint B 2 0) 2

end MLIR.Agave.Serial
