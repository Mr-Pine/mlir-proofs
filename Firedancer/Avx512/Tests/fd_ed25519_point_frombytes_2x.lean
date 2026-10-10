module

public import Firedancer.Avx512.fd_ed25519_point_frombytes_2x

meta import MLIR.Semantics.Func
meta import Firedancer.Avx512.fd_ed25519_point_frombytes_2x

/-! `fd_ed25519_point_frombytes_2x` run, with the lifted callees, on encodings that decode and
that do not. -/

namespace MLIR.Firedancer.Avx512

section Tests

private def p : Nat :=
  2 ^ 255 - 19

/-- Block `k`, at offset 0. -/
private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- The points `r1`, `r2` (192 bytes, zeroed, blocks `1` and `3`) and the encodings `e1`, `e2`
(32 bytes, blocks `2` and `4`). -/
private def state (e1 e2 : Nat) : GlobalState :=
  ⟨⟨5⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 192 0), (⟨2⟩, .ofBytes 32 (BitVec.ofNat 256 e1)), (⟨3⟩, .ofBytes 192 0),
          (⟨4⟩, .ofBytes 32 (BitVec.ofNat 256 e2))]⟩⟩

/-- The return value and the points' six vectors' lanes, or `none` for UB / out of fuel. -/
private def run (e1 e2 : Nat) : Option (BitVec 32 × List (List Nat)) :=
  match
    fd_ed25519_point_frombytes_2x.eval 10
      (fd_ed25519_point_frombytes_2x.args (.value (ptr 1)) (.value (ptr 2)) (.value (ptr 3))
        (.value (ptr 4)))
      (state e1 e2) with
  | .value (some (.cons (.value r) .nil), s) =>
    some
      (r,
        [(1, 0), (1, 64), (1, 128), (3, 0), (3, 64), (3, 128)].map fun (k, o) =>
          (List.range 8).map fun i =>
            (s.mem.readAt ((ptr k).add (BitVec.ofNat 64 o)) 512).toNat / 2 ^ (64 * i) % 2 ^ 64)
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

/-- Both points decode: `0`, and the points hold `(x, y, 1, x y)`. -/
private def decodes (ea eb x₁ y₁ x₂ y₂ : Nat) : Bool :=
  match run ea eb with
  | some (r, vs) =>
    r == 0 && [coord vs 0, coord vs 1, coord vs 2, coord vs 3] == [x₁, y₁, 1, x₁ * y₁ % p] &&
      [coord (vs.drop 3) 0, coord (vs.drop 3) 1, coord (vs.drop 3) 2, coord (vs.drop 3) 3] ==
        [x₂, y₂, 1, x₂ * y₂ % p]
  | none => false

/-- A failure: `r`, and both points zero. -/
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

end MLIR.Firedancer.Avx512
