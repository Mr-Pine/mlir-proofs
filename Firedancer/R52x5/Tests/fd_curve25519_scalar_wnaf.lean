module

public import Firedancer.R52x5.fd_curve25519_scalar_wnaf

meta import Firedancer.R52x5.fd_curve25519_scalar_wnaf

namespace MLIR.Firedancer.R52x5

private def slides : Pointer :=
  ⟨⟨1⟩, 0⟩

private def scalar : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- `_t` filled with ones (stale data the unpacking overwrites), the scalar `x` at `scalar`. -/
private def state (x : BitVec 256) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 512 (BitVec.allOnes _)), (⟨2⟩, .ofBytes 32 x)]⟩⟩

/-- `_t` after the call, or `none` for UB / out of fuel. -/
private def out (x : BitVec 256) (bits : BitVec 32) : Option (BitVec (16 * 256)) :=
  match
    fd_curve25519_scalar_wnaf.eval 10000
      (fd_curve25519_scalar_wnaf.args (.value slides) (.value scalar) (.value bits)) (state x) with
  | .value (some .nil, s') => some (s'.mem.readAt slides (16 * 256))
  | _ => none

/-- The call against the spec, at `bits`. -/
private def agrees (x : BitVec 256) (bits : Nat) : Bool :=
  out x (BitVec.ofNat 32 bits) == some (fd_curve25519_scalar_wnaf.spec x bits)

/-- `Σ wnaf[k] 2^k`, the value the digits stand for. -/
private def value (x : BitVec 256) (bits : Nat) : Int :=
  (List.range 256).foldr (fun k acc => acc + (fd_curve25519_scalar_wnaf.wnaf x bits)[k]! * 2 ^ k) 0

-- the group order `L`, minus one: a canonical scalar
private def lm1 : BitVec 256 :=
  0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec#256

private def mixed : BitVec 256 :=
  0x0a5c3f17e09d2b4486f0e1d2c3b4a5968778695a4b3c2d1e0f1e2d3c4b5a6978#256

-- zero, one, and all ones below bit 253 (carries run through the top)
#guard agrees 0 5

#guard agrees 1 1

#guard agrees (BitVec.allOnes 253 |>.setWidth 256) 4

#guard agrees (BitVec.allOnes 253 |>.setWidth 256) 12

-- all ones below bit 255: the carry ends at `_t[255]`, the outer loop's last digit
#guard agrees (BitVec.allOnes 255 |>.setWidth 256) 5

-- canonical scalars across the documented range of `bits`
#guard agrees lm1 1

#guard agrees lm1 5

#guard agrees lm1 8

#guard agrees mixed 2

#guard agrees mixed 7

#guard agrees mixed 12

-- the digits stand for the scalar
#guard value lm1 5 == lm1.toNat

#guard value mixed 12 == mixed.toNat

#guard value (BitVec.allOnes 253 |>.setWidth 256) 4 == 2 ^ 253 - 1

#guard value (BitVec.allOnes 255 |>.setWidth 256) 5 == 2 ^ 255 - 1

end MLIR.Firedancer.R52x5
