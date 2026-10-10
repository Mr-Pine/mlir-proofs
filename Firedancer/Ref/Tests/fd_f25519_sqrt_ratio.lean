module

public import Firedancer.Ref.fd_f25519_sqrt_ratio

meta import Firedancer.Ref.fd_f25519_sqrt_ratio

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def u : Pointer :=
  ⟨⟨1⟩, 0⟩

private def v : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three 40-byte blocks: `r` zeroed, `u` and `v` holding the limbs `ub` and `vb`. -/
private def state (ub vb : BitVec 320) : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 40 0), (⟨1⟩, .ofBytes 40 ub), (⟨2⟩, .ofBytes 40 vb)]⟩⟩

/-- The returned flag and `r`'s canonical encoding after `sqrt_ratio r u q`, if the inputs are
unchanged and the counter moved on by 50 blocks; else `none`. `spec` itself is not evaluated: its
`pow22523` chain re-evaluates its closures exponentially often. -/
private def out (ub vb : BitVec 320) (q : Pointer := v) : Option (BitVec 32 × BitVec 256) :=
  let s := state ub vb
  match
    fd_f25519_sqrt_ratio.call (fd_f25519_sqrt_ratio.args (.value r) (.value u) (.value q)) s with
  | .value (.cons (.value ret) .nil, s') =>
    if
        s'.mem.readAt u 320 == ub && s'.mem.readAt v 320 == vb && s'.alloc.nextFreeBlock == 53 &&
          s'.mem.mem.size == 3 then
      some (ret, fd_f25519_tobytes.spec (s'.mem.readLimbs r))
    else none
  | _ => none

/-- The limbs of `p - 1 = -1`. -/
private def mOneBytes : BitVec 320 :=
  0x0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffec#320

/-- `p - 1`, `(p - 1) / 2 = -1/2` and `√-1`, encoded. -/
private def pm1 : BitVec 256 :=
  0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec#256

private def half : BitVec 256 :=
  0x3ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff6#256

private def sqrtm1 : BitVec 256 :=
  0x2b8324804fc1df0b2b4d00993dfbd7a72f431806ad2fe478c4ee1b274a0ea0b0#256

-- `√(1/1) = ±1`: the even one is `p - 1`
#guard out 1#320 1#320 == some (1#32, pm1)

-- `√(4/1) = ±2`
#guard out 4#320 1#320 == some (1#32, 2#256)

-- `√(1/4) = ±1/2`: the even one is `-1/2`
#guard out 1#320 4#320 == some (1#32, half)

-- `√(-1/1) = ±√-1`, `√-1` the even one
#guard out mOneBytes 1#320 == some (1#32, sqrtm1)

-- `√0 = 0`
#guard out 0#320 1#320 == some (1#32, 0#256)

-- `2` is not a square: flag `0`, and `r` is still even
#guard
  match out 2#320 1#320 with
  | some (ret, x) => ret == 0#32 && x.getLsbD 0 == false
  | none => false

-- `v` may be `u`: `√(4/4) = ±1`
#guard out 4#320 0#320 (q := u) == some (1#32, pm1)

end MLIR.Firedancer.Ref
