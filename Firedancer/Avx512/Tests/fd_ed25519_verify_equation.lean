module

public import Firedancer.Avx512.fd_ed25519_verify_equation

meta import Firedancer.Avx512.fd_ed25519_verify_equation

/-! The lift reads `fd_ed25519_base_point_wnaf_table` through `double_scalar_mul_base`, too long
to compile, so it cannot be evaluated. These test `spec` against `R + k A = S B` in affine
coordinates, with the table of `B`'s odd multiples computed here. -/

namespace MLIR.Firedancer.Avx512

/-! ### Affine arithmetic -/

private def p : Nat :=
  2 ^ 255 - 19

/-- `b ^ e mod p` for `e < 2 ^ 256`, by squaring. -/
private def powMod (b e : Nat) : Nat :=
  (List.range 256).foldr (fun k acc => if e.testBit k then acc * acc % p * b % p else acc * acc % p)
    1

private def inv (x : Nat) : Nat :=
  powMod x (p - 2)

/-- `d = -121665/121666`. -/
private def d : Nat :=
  (p - 121665) * inv 121666 % p

/-- Twisted Edwards addition, `a = -1`. -/
private def add (P Q : Nat × Nat) : Nat × Nat :=
  let t := d * P.1 % p * Q.1 % p * P.2 % p * Q.2 % p
  ((P.1 * Q.2 + P.2 * Q.1) % p * inv ((1 + t) % p) % p,
    (P.2 * Q.2 + P.1 * Q.1) % p * inv ((1 + p - t) % p) % p)

/-- `-P`. -/
private def neg (P : Nat × Nat) : Nat × Nat :=
  ((p - P.1) % p, P.2)

/-- `n P` for `n < 2 ^ 256`, by doubling. -/
private def mul (n : Nat) (P : Nat × Nat) : Nat × Nat :=
  (List.range 256).foldr (fun k acc => if n.testBit k then add (add acc acc) P else add acc acc)
    (0, 1)

/-- The base point `B`. -/
private def B : Nat × Nat :=
  (15112221349535400772501151409588531511454012693041857206046113283949847762202,
    46316835694926478169428394003475163141307993866256225615783033603165251855960)

/-- A field element's six 43-bit limbs, then two zero lanes. -/
private def limbs (v : Nat) : Wwl :=
  Vector.ofFn fun i => if i.val < 6 then BitVec.ofNat 64 (v >>> (43 * i.val) % 2 ^ 43) else 0

/-- An affine point as a `Quad`, `Z = 1`. -/
private def toQuad (P : Nat × Nat) : Quad :=
  Quad.pack (limbs P.1) (limbs P.2) (limbs 1) (limbs (P.1 * P.2 % p))

/-- `B, 3B, …, 255B`, precomputed as the table holds them. -/
private def tbl : Array Quad :=
  let B2 := add B B
  ((List.range 128).foldl
        (fun (acc : Array (Nat × Nat) × (Nat × Nat)) _ => (acc.1.push acc.2, add acc.2 B2))
        (#[], B)).1.map
    fun P => fd_curve25519_into_precomputed.spec (toQuad P)

/-- `spec` for `A = 3B`, `R = S B - k A + e B`: `1` iff the equation holds, `e = 0`. -/
private def check (k S e : Nat) : BitVec 32 :=
  let A := mul 3 B
  let R := add (add (mul S B) (neg (mul k A))) (mul e B)
  fd_ed25519_verify_equation.spec (fun j => tbl.getD j (toQuad (0, 1))) (BitVec.ofNat 256 k)
    (toQuad A) (BitVec.ofNat 256 S) (toQuad R)

-- `R` the neutral point
#guard check 0 0 0 == 1

#guard check 5 7 0 == 1

#guard check 5 7 1 == 0

#guard check (3 ^ 150 % 2 ^ 252) (7 ^ 85 % 2 ^ 252) 0 == 1

#guard check (3 ^ 150 % 2 ^ 252) (7 ^ 85 % 2 ^ 252) 2 == 0

end MLIR.Firedancer.Avx512
