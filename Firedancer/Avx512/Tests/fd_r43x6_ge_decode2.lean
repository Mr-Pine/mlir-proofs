module

public import Firedancer.Avx512.fd_r43x6_ge_decode2

meta import SSA.Projects.RIR.Semantics.Func
meta import Firedancer.Avx512.fd_r43x6_ge_decode2

/-! `fd_r43x6_ge_decode2` run, with the lifted callees, on encodings that decode and that do not. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

section Tests

private def p : Nat :=
  2 ^ 255 - 19

/-- Block `k`, at offset 0. -/
private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- Six zeroed 64-byte out-vectors, blocks `0 1 2` and `4 5 6`, and the two 32-byte encodings
`ea`, `eb` in blocks `3` and `7`. -/
private def state (ea eb : Nat) : GlobalState :=
  ⟨⟨8⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨0⟩, ⟨64, 0⟩), (⟨1⟩, ⟨64, 0⟩), (⟨2⟩, ⟨64, 0⟩), (⟨3⟩, ⟨32, BitVec.ofNat 256 ea⟩),
          (⟨4⟩, ⟨64, 0⟩), (⟨5⟩, ⟨64, 0⟩), (⟨6⟩, ⟨64, 0⟩), (⟨7⟩, ⟨32, BitVec.ofNat 256 eb⟩)]⟩⟩

/-- The return value and the six out-vectors' lanes, or `none` for UB / out of fuel. -/
private def run (ea eb : Nat) : Option (BitVec 32 × List (List Nat)) :=
  match
    fd_r43x6_ge_decode2.eval 10
      (fd_r43x6_ge_decode2.args (.value (ptr 0)) (.value (ptr 1)) (.value (ptr 2)) (.value (ptr 3))
        (.value (ptr 4)) (.value (ptr 5)) (.value (ptr 6)) (.value (ptr 7)))
      (state ea eb) with
  | .value (some (.cons (.value r) .nil), s) =>
    some
      (r,
        [0, 1, 2, 4, 5, 6].map fun k =>
          (List.range 8).map fun i => (s.mem.readAt (ptr k) 512).toNat / 2 ^ (64 * i) % 2 ^ 64)
  | _ => none

/-- Coordinate `j` (`X Y Z T`) of the QUAD in out-vectors `v03 v14 v25`, mod `p`: limb `k` is in
lane `j` (`k < 3`) or `j + 4` of vector `k mod 3`. -/
private def coord (vs : List (List Nat)) (j : Nat) : Nat :=
  (List.range 6).foldl (fun acc k => acc + vs[k % 3]![j + if k < 3 then 0 else 4]! * 2 ^ (43 * k))
      0 %
    p

/-- The encodings of the base point (`y = 4/5`, `x` even) and the identity, and a `y` naming no
point. -/
private def enc_B : Nat :=
  0x6666666666666666666666666666666666666666666666666666666666666658

private def enc_O : Nat :=
  1

private def enc_bad : Nat :=
  2

private def B_x : Nat :=
  15112221349535400772501151409588531511454012693041857206046113283949847762202

private def B_y : Nat :=
  0x6666666666666666666666666666666666666666666666666666666666666658

/-- Both points decode: `0`, and the QUADs hold `(x, y, 1, x y)`. -/
private def decodes (ea eb x₁ y₁ x₂ y₂ : Nat) : Bool :=
  match run ea eb with
  | some (r, vs) =>
    r == 0 && [coord vs 0, coord vs 1, coord vs 2, coord vs 3] == [x₁, y₁, 1, x₁ * y₁ % p] &&
      [coord (vs.drop 3) 0, coord (vs.drop 3) 1, coord (vs.drop 3) 2, coord (vs.drop 3) 3] ==
        [x₂, y₂, 1, x₂ * y₂ % p]
  | none => false

/-- A failure: `r`, and all six out-vectors zero. -/
private def fails (ea eb : Nat) (r : BitVec 32) : Bool :=
  match run ea eb with
  | some (r', vs) => r' == r && vs.all (·.all (· == 0))
  | none => false

#guard decodes enc_B enc_O B_x B_y 0 1

#guard decodes enc_O enc_B 0 1 B_x B_y

#guard fails enc_bad enc_B (-1)

#guard fails enc_B enc_bad (-2)

#guard fails enc_bad enc_bad (-1)

end Tests

end LeanMLIR.RIR.Firedancer.Avx512
