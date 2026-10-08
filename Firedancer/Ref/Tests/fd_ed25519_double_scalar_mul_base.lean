module

public import Firedancer.Ref.fd_ed25519_double_scalar_mul_base

meta import Firedancer.Ref.fd_ed25519_double_scalar_mul_base

/-! The lift reads `fd_ed25519_base_point_wnaf_table`, too long to compile, so it cannot be
evaluated. These test `spec`: a copy memoizing each callee's result, proved equal to it, against
`n1 A + n2 B` in affine coordinates, with the table of `B`'s odd multiples computed here. -/

namespace LeanMLIR.RIR.Firedancer.Ref

open fd_ed25519_double_scalar_mul_base

/-! ### `spec`, memoized -/

/-- `P` with its limbs computed once: the specs' limbs are functions, recomputed at each use. -/
private def memo (P : PointLimbs) : PointLimbs :=
  ⟨(Vector.ofFn P.X).get, (Vector.ofFn P.Y).get, (Vector.ofFn P.T).get, (Vector.ofFn P.Z).get⟩

private theorem memo_eq (P : PointLimbs) : memo P = P := by
  cases P
  simp only [memo, PointLimbs.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> funext i <;> simp [Vector.get] <;> rfl

/-- `addDigit`, memoized. -/
private def addDigitM (tbl : Nat → PointLimbs) (d : Int) (zp zm : BitVec 32) (r t : PointLimbs) :
    PointLimbs × PointLimbs :=
  if 0 < d then
    let r := memo (fd_ed25519_point_add_final_mul.spec t)
    (r, memo (fd_ed25519_point_add_with_opts.spec r (tbl (d / 2).toNat) zp 1#32 1#32))
  else if d < 0 then
    let r := memo (fd_ed25519_point_add_final_mul.spec t)
    (r, memo (fd_ed25519_point_sub_with_opts.spec r (tbl (-d / 2).toNat) zm 1#32 1#32))
  else (r, t)

/-- `adds`, memoized. -/
private def addsM (ai tbl : Nat → PointLimbs) (d1 d2 : Int) (r : PointLimbs) :
    PointLimbs × PointLimbs :=
  let rt :=
    addDigitM ai d1 (if d1 = 1 then 1#32 else 0#32) (if d1 = -1 then 1#32 else 0#32) r
      (memo (fd_ed25519_partial_dbl.spec r))
  addDigitM tbl d2 1#32 1#32 rt.1 rt.2

/-- `ladder`, memoized. -/
private def ladderM (ai tbl : Nat → PointLimbs) (w1 w2 : Vector Int 256) :
    (i : Nat) → i < 256 → PointLimbs → PointLimbs
  | 0, _, r => memo (fd_ed25519_point_add_final_mul.spec (addsM ai tbl w1[0] w2[0] r).2)
  | i + 1, h, r =>
    let rt := addsM ai tbl w1[i + 1] w2[i + 1] r
    ladderM ai tbl w1 w2 i (by omega)
      (memo (fd_ed25519_point_add_final_mul_projective.spec rt.2 rt.1.T))

/-- `aiTable`, memoized. -/
private def aiTableM (a2 ai0 : PointLimbs) : Nat → PointLimbs
  | 0 => ai0
  | i + 1 =>
    let t :=
      memo
        (fd_ed25519_point_add_with_opts.spec a2 (aiTableM a2 ai0 i)
          (if i + 1 = 1 then 1#32 else 0#32) 1#32 1#32)
    memo (fd_curve25519_into_precomputed.spec (memo (fd_ed25519_point_add_final_mul.spec t)))

/-- `aiTableM`, its first eight entries from `v`. -/
private def aiPick (a2 ai0 : PointLimbs) (v : Vector PointLimbs 8) (k : Nat) : PointLimbs :=
  if h : k < 8 then v[k] else aiTableM a2 ai0 k

/-- `aiTableM`, its eight entries computed once. -/
private def aiM (a2 ai0 : PointLimbs) : Nat → PointLimbs :=
  aiPick a2 ai0 (Vector.ofFn fun j : Fin 8 => aiTableM a2 ai0 j)

/-- `spec`, memoized. -/
private def specM (tbl : Nat → PointLimbs) (n1 : BitVec 256) (A : PointLimbs) (n2 : BitVec 256) :
    PointLimbs :=
  let n1slide := fd_curve25519_scalar_wnaf.wnaf n1 4
  let n2slide := fd_curve25519_scalar_wnaf.wnaf n2 8
  let ai :=
    aiM (memo (fd_ed25519_point_dbln.spec A 1)) (memo (fd_curve25519_into_precomputed.spec A))
  match start n1slide n2slide 255 (by decide) with
  | some i => ladderM ai tbl n1slide n2slide i i.isLt fd_ed25519_point_set_zero.spec
  | none => fd_ed25519_point_set_zero.spec

private theorem addsM_eq : addsM ai tbl d1 d2 r = adds ai tbl d1 d2 r := by
  simp only [addsM, adds, add1, addDigitM, addDigit, memo_eq]

private theorem ladderM_eq {h : i < 256} :
    ladderM ai tbl w1 w2 i h r = ladder ai tbl w1 w2 i h r := by
  induction i generalizing r with
  | zero => simp only [ladderM, ladder, addsM_eq, memo_eq]
  | succ i ih => simp only [ladderM, ladder, addsM_eq, memo_eq, ih]

private theorem aiTableM_eq : aiTableM a2 ai0 i = aiTable a2 ai0 i := by
  induction i with
  | zero => rfl
  | succ i ih => simp only [aiTableM, aiTable, memo_eq, ih]

private theorem aiM_eq : aiM a2 ai0 = aiTable a2 ai0 := by
  funext k
  simp only [aiM, aiPick]
  split <;> simp [aiTableM_eq]

private theorem specM_eq : specM tbl n1 A n2 = spec tbl n1 A n2 := by
  unfold specM spec
  dsimp only
  rw [memo_eq, memo_eq, aiM_eq]
  generalize start _ _ 255 _ = o
  cases o <;> simp only [ladderM_eq]

/-! ### `n1 A + n2 B` in affine coordinates -/

private def p : Nat := 2 ^ 255 - 19

/-- `b ^ e mod p` for `e < 2 ^ 256`, by squaring. -/
private def powMod (b e : Nat) : Nat :=
  (List.range 256).foldr
    (fun k acc => if e.testBit k then acc * acc % p * b % p else acc * acc % p) 1

private def inv (x : Nat) : Nat := powMod x (p - 2)

/-- `d = -121665/121666`. -/
private def d : Nat := (p - 121665) * inv 121666 % p

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

/-- An affine point's limbs, `Z = 1`. -/
private def toPoint (P : Nat × Nat) : PointLimbs :=
  let limbs (v : Nat) : Fin 5 → BitVec 64 := fun i => BitVec.ofNat 64 (v >>> (51 * i.val) % 2 ^ 51)
  ⟨limbs P.1, limbs P.2, limbs (P.1 * P.2 % p), limbs 1⟩

/-- `B, 3B, …, 255B`, precomputed as the table holds them. -/
private def tbl : Array PointLimbs :=
  let B2 := add B B
  ((List.range 128).foldl (fun (acc : Array (Nat × Nat) × (Nat × Nat)) _ =>
        (acc.1.push acc.2, add acc.2 B2)) (#[], B)).1.map
    fun P => memo (fd_curve25519_into_precomputed.spec (toPoint P))

/-- A field element's value. -/
private def val (l : Fin 5 → BitVec 64) : Nat :=
  (List.finRange 5).foldr (fun i acc => acc + (l i).toNat * 2 ^ (51 * i.val)) 0 % p

/-- Whether `R` represents the affine `P`. -/
private def represents (R : PointLimbs) (P : Nat × Nat) : Bool :=
  val R.X == P.1 * val R.Z % p && val R.Y == P.2 * val R.Z % p &&
    val R.T * val R.Z % p == val R.X * val R.Y % p

/-- Whether `spec` computes `n1 A + n2 B`, for `A = 3B`; `n1`'s top bit is ignored. -/
private def check (n1 n2 : Nat) : Bool :=
  let A := mul 3 B
  represents
    (specM (fun j => tbl.getD j (toPoint (0, 1))) (BitVec.ofNat 256 n1) (toPoint A)
      (BitVec.ofNat 256 n2))
    (add (mul (n1 % 2 ^ 255) A) (mul n2 B))

-- `B` is on the curve
#guard (B.2 * B.2 + p - B.1 * B.1) % p == (1 + d * (B.1 * B.1 % p) % p * (B.2 * B.2 % p)) % p

-- no non-zero digit: the neutral point
#guard check 0 0

#guard check 1 0

#guard check 0 1

#guard check 5 7

#guard check (2 ^ 252 + 27742317777372353535851937790883648493 - 1) (2 ^ 200 + 98765)

#guard check (3 ^ 150 % 2 ^ 252) (7 ^ 85 % 2 ^ 252)

-- the top bit of `n1` is ignored
#guard check (2 ^ 255 + 12345) 0

end LeanMLIR.RIR.Firedancer.Ref
