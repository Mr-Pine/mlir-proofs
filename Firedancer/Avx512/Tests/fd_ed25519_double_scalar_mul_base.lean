module

public import Firedancer.Avx512.fd_ed25519_double_scalar_mul_base

meta import Firedancer.Avx512.fd_ed25519_double_scalar_mul_base

/-! The lift reads `fd_ed25519_base_point_wnaf_table`, too long to compile, so it cannot be
evaluated. These test `spec`, with `ai`'s eight entries computed once, against `n1 A + n2 B` in
affine coordinates, with the table of `B`'s odd multiples computed here. -/

namespace MLIR.Firedancer.Avx512

open fd_ed25519_double_scalar_mul_base Firedancer.Ref

/-! ### `spec`, its table computed once -/

/-- `aiTable`, its first eight entries from `v`. -/
private def aiPick (a2 ai0 : Quad) (v : Vector Quad 8) (k : Nat) : Quad :=
  if h : k < 8 then v[k] else aiTable a2 ai0 k

/-- `aiTable`, its eight entries computed once. -/
private def aiM (a2 ai0 : Quad) : Nat → Quad :=
  aiPick a2 ai0 (Vector.ofFn fun j : Fin 8 => aiTable a2 ai0 j)

/-- `spec`, with `aiM`. -/
private def specM (tbl : Nat → Quad) (n1 : BitVec 256) (A : Quad) (n2 : BitVec 256) : Quad :=
  let n1slide := fd_curve25519_scalar_wnaf.wnaf n1 4
  let n2slide := fd_curve25519_scalar_wnaf.wnaf n2 8
  let ai := aiM (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)
  match start n1slide n2slide 255 (by decide) with
  | some i => ladder ai tbl n1slide n2slide i i.isLt fd_ed25519_point_set_zero.spec
  | none => fd_ed25519_point_set_zero.spec

private theorem aiM_eq : aiM a2 ai0 = aiTable a2 ai0 := by
  funext k
  simp only [aiM, aiPick]
  split <;> simp

private theorem specM_eq : specM tbl n1 A n2 = spec tbl n1 A n2 := by
  unfold specM spec
  dsimp only
  rw [aiM_eq]
  generalize start _ _ 255 _ = o
  cases o <;> rfl

/-! ### `n1 A + n2 B` in affine coordinates -/

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

/-- Coordinate `j` of a `Quad` (`X, Y, Z, T`), its limbs signed. -/
private def coord (Q : Quad) (j : Nat) : Nat :=
  let l (v : Wwl) (k : Nat) : Int := (v[k]?.getD 0).toInt
  ((l Q.P03 j + l Q.P14 j * 2 ^ 43 + l Q.P25 j * 2 ^ 86 + l Q.P03 (j + 4) * 2 ^ 129 +
        l Q.P14 (j + 4) * 2 ^ 172 +
        l Q.P25 (j + 4) * 2 ^ 215) %
      (p : Int)).toNat

/-- Whether `R` represents the affine `P`, `Z ≠ 0`. -/
private def represents (R : Quad) (P : Nat × Nat) : Bool :=
  let X := coord R 0
  let Y := coord R 1
  let Z := coord R 2
  let T := coord R 3
  Z != 0 && X == P.1 * Z % p && Y == P.2 * Z % p && T * Z % p == X * Y % p

/-- Whether `spec` computes `n1 A + n2 B`, for `A = 3B`; `n1`'s top bit is ignored. -/
private def check (n1 n2 : Nat) : Bool :=
  let A := mul 3 B
  represents
    (specM (fun j => tbl.getD j (toQuad (0, 1))) (BitVec.ofNat 256 n1) (toQuad A)
      (BitVec.ofNat 256 n2))
    (add (mul (n1 % 2 ^ 255) A) (mul n2 B))

-- no non-zero digit: the neutral point
#guard check 0 0

#guard check 1 0

#guard check 0 1

#guard check 5 7

#guard check (2 ^ 252 + 27742317777372353535851937790883648493 - 1) (2 ^ 200 + 98765)

#guard check (3 ^ 150 % 2 ^ 252) (7 ^ 85 % 2 ^ 252)

-- the top bit of `n1` is ignored
#guard check (2 ^ 255 + 12345) 0

end MLIR.Firedancer.Avx512
