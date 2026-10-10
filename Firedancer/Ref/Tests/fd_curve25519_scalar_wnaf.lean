module

public import Firedancer.Ref.fd_curve25519_scalar_wnaf

meta import Firedancer.Ref.fd_curve25519_scalar_wnaf

namespace MLIR.Firedancer.Ref

private def slides : Pointer :=
  ⟨⟨1⟩, 0⟩

private def scalar : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- `_t` filled with ones (stale data the `memset` clears), the scalar `x` at `scalar`. -/
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

/-! The previous bit-at-a-time recoding (`ref_wnaf` in `test_ed25519.c`): the digits agree. -/

/-- `ref_wnaf`'s carry from `j`: ones become zeros, the first zero a one; its index. -/
private def refCarry : Nat → Vector Int 256 → Nat → Vector Int 256 × Nat
  | 0, t, j => (t, j)
  | f + 1, t, j =>
    if h : j + 1 < 256 then
      if t[j + 1] = 0 then (t.set (j + 1) 1, j + 1) else refCarry f (t.set (j + 1) 0) (j + 1)
    else (t, j + 1)

/-- `ref_wnaf`'s inner loop from `j`: absorb `_t[j …]` into `ti`. -/
private def refAbsorb (max : Int) (i : Nat) :
    Nat → Vector Int 256 → Int → Nat → Vector Int 256 × Int × Nat
  | 0, t, ti, j => (t, ti, j)
  | f + 1, t, ti, j =>
    if h : j < 256 then
      if t[j] = 0 then refAbsorb max i f t ti (j + 1)
      else
        let delta : Int := 2 ^ min (j - i) 14
        if 2 * max < delta then (t, ti, j)
        else
          if ti + delta ≤ max then refAbsorb max i f (t.set j 0) (ti + delta) (j + 1)
          else
            if -max ≤ ti - delta then
              let r := refCarry 256 (t.set j 0) j
              (r.1, ti - delta, r.2)
            else (t, ti, j)
    else (t, ti, j)

/-- `ref_wnaf`'s outer loop from `i`. -/
private def refOuter (max : Int) : Nat → Vector Int 256 → Nat → Vector Int 256
  | 0, t, _ => t
  | f + 1, t, i =>
    if h : i < 256 then
      let r := refAbsorb max i 256 t 1 (i + 1)
      refOuter max f (r.1.set i r.2.1 h) r.2.2
    else t

/-- `ref_wnaf( _t, s, bits )`. -/
private def refWnaf (x : BitVec 256) (bits : Nat) : Vector Int 256 :=
  let t : Vector Int 256 := Vector.ofFn fun i => if i.val < 255 ∧ x.getLsbD i.val then 1 else 0
  refOuter (2 ^ bits - 1) 257 t ((List.range 256).find? (fun k => t[k]! ≠ 0) |>.getD 256)

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

-- the same digits as the bit-at-a-time recoding
#guard
  [lm1, mixed, BitVec.allOnes 256, 0#256, 1#256, BitVec.allOnes 255 |>.setWidth 256].all fun x =>
    (List.range 12).all fun b => fd_curve25519_scalar_wnaf.wnaf x (b + 1) == refWnaf x (b + 1)

-- the digits stand for the scalar
#guard value lm1 5 == lm1.toNat

#guard value mixed 12 == mixed.toNat

#guard value (BitVec.allOnes 253 |>.setWidth 256) 4 == 2 ^ 253 - 1

#guard value (BitVec.allOnes 255 |>.setWidth 256) 5 == 2 ^ 255 - 1

end MLIR.Firedancer.Ref
