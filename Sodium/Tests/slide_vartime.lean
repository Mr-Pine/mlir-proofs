module

public import Sodium.slide_vartime

meta import Sodium.slide_vartime

namespace MLIR.Sodium

open MLIR.Boringssl

private def rp : Pointer :=
  ⟨⟨1⟩, 0⟩

private def ap : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- `r` filled with ones (stale data the bit loop overwrites), the scalar `a` at `ap`. -/
private def state (a : BitVec 256) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 256 (BitVec.allOnes _)), (⟨2⟩, .ofBytes 32 a)]⟩⟩

/-- `r` after the call, or `none` for UB / out of fuel. -/
private def out (a : BitVec 256) : Option (BitVec 2048) :=
  match slide_vartime.eval 100000 (slide_vartime.args (.value rp) (.value ap)) (state a) with
  | .value (some .nil, s') => some (s'.mem.readAt rp 2048)
  | _ => none

/-- `Σ r[i] 2^i`, the value the digits stand for. -/
private def value (r : Vector (BitVec 8) 256) : Int :=
  (List.range 256).foldr (fun k acc => acc + r[k]!.toInt * 2 ^ k) 0

private def inputs : List (BitVec 256) :=
  [0, 1, 2, 0xff, 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec#256,
    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256,
    0x0123456789abcdeffedcba98765432100f1e2d3c4b5a69788796a5b4c3d2e1f0#256,
    0x5555555555555555555555555555555555555555555555555555555555555555#256,
    0x6db6db6db6db6db6db6db6db6db6db6db6db6db6db6db6db6db6db6db6db6db6#256, -1]

-- The call stores the spec's digits.
#guard inputs.all fun a => out a == some (BitVec.packLanes (slide.spec a))

-- Below `2^255` the digits stand for `a`.
#guard inputs.all fun a => a.toNat ≥ 2 ^ 255 || value (slide.spec a) == a.toNat

-- Each digit is `0` or odd in `[-15, 15]`.
#guard
  inputs.all fun a =>
    (slide.spec a).all fun d => d = 0 || (d.toInt % 2 = 1 && -15 ≤ d.toInt && d.toInt ≤ 15)

end MLIR.Sodium
