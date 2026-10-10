module

public import Firedancer.Math.BaseTable
public import Firedancer.Math.Avx512.QuadMul
public import Firedancer.Avx512.Globals
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The AVX-512 base point table `fd_ed25519_base_point_wnaf_table`: entry `j` is `(2 j + 1) B`,
affine (`Z = 1`) and precomputed (`fd_curve25519_into_precomputed`) as the QUAD
`(Y - X, Y + X, Z, 2d T)` that `FD_R43X6_GE_ADD_TABLE_ALT` takes, every element folded. The lanes
are read off the global's bits; the points are checked by the kernel, mod `p`, against the curve
formulas. -/

namespace MLIR.Firedancer.Avx512

open _root_.Ed25519 (p)
open MLIR.Firedancer.Ref (dN x2N y2N curveOk addOk dblOk natCast_eq natCast_ne dN_eq add_of_ok
  dbl_of_ok onCurve_of_ok)
open R43x6 (quadElem)

/-! ## Reading the table -/

/-- An entry's type: `P03, P14, P25`. -/
abbrev tE : Ty :=
  .struct [.vec 8 64, .vec 8 64, .vec 8 64]

/-- An entry's QUAD; noncomputable: the compiler cannot type a `⟦t⟧ᵣ` argument across modules. -/
noncomputable def entry (e : ⟦tE⟧ᵣ) : Quad :=
  ⟨e.1, e.2.1, e.2.2⟩

/-- Three 512-bit fields, packed as a struct: `a` lowest. -/
abbrev pack3 (a b c : BitVec 512) : BitVec 1536 :=
  ((0#0 ++ c) ++ (0#0 ++ b)) ++ (0#0 ++ a)

/-- Lane `i` of each field. -/
theorem pack3_extract (a b c : BitVec 512) {i : Nat} (hi : i < 8) :
    (pack3 a b c).extractLsb' (64 * i) 64 = a.extractLsb' (64 * i) 64 ∧
      (pack3 a b c).extractLsb' (512 + 64 * i) 64 = b.extractLsb' (64 * i) 64 ∧
      (pack3 a b c).extractLsb' (1024 + 64 * i) 64 = c.extractLsb' (64 * i) 64 := by
  simp (disch := omega) only [pack3, BitVec.extractLsb'_append_eq_of_add_le,
    BitVec.extractLsb'_append_eq_of_le, Nat.zero_add, Nat.add_sub_cancel_left, true_and]
  rw [show 1024 + 64 * i - 512 - 512 = 64 * i by omega]

/-- An entry's bits: its fields', packed. -/
theorem flattenRaw_tE (a b c : Wwl) :
    Ty.flattenRaw tE (a, b, c) =
      pack3 (Ty.flattenRaw (.vec 8 64) a) (Ty.flattenRaw (.vec 8 64) b)
        (Ty.flattenRaw (.vec 8 64) c) :=
  (Ty.flattenRaw_struct _).trans <|
    (Ty.flattenRawFields_cons _ _).trans <|
    congrArg (· ++ _) <|
    (Ty.flattenRawFields_cons _ _).trans <| congrArg (· ++ _) <| Ty.flattenRawFields_singleton _

/-- Lane `i` of a vector's bits. -/
theorem vec_lane (v : Wwl) {i : Nat} (hi : i < 8) :
    (Ty.flattenRaw (.vec 8 64) v).extractLsb' (64 * i) 64 = v[i] := by
  rw [Ty.flattenRaw_vec, Nat.mul_comm]
  exact BitVec.extractLsb'_packLanes v i hi

/-- Entry `j` is the literal's. -/
theorem point_eq {j : ℕ} (hj : j < 128) :
    fd_ed25519_base_point_wnaf_table.point j = entry fd_ed25519_base_point_wnaf_table.lit[j] := by
  set e := fd_ed25519_base_point_wnaf_table.lit[j]
  set F :=
    pack3 (Ty.flattenRaw (.vec 8 64) e.1) (Ty.flattenRaw (.vec 8 64) e.2.1)
      (Ty.flattenRaw (.vec 8 64) e.2.2)
  have hs : tE.stride = 1536 := rfl
  have key (o : ℕ) (ho : o + 64 ≤ 1536) :
      (Ty.flatBits fd_ed25519_base_point_wnaf_table.lit (w := 196608) (hw := rfl)).extractLsb'
          (1536 * j + o) 64 =
        F.extractLsb' o 64 := by
    have hi : (1536 * j + o) / tE.stride < 128 := by
      rw [hs]; omega
    have hw : (1536 * j + o) % tE.stride + 64 ≤ tE.width := by
      rw [hs, show tE.width = 1536 from rfl]; omega
    have h := Ty.extractLsb'_flattenRaw_array fd_ed25519_base_point_wnaf_table.lit hi hw
    have e1 : (1536 * j + o) / tE.stride = j := by
      rw [hs]; omega
    have e2 : (1536 * j + o) % tE.stride = o := by
      rw [hs]; omega
    simp only [e1, e2] at h
    exact
      (congrArg (BitVec.extractLsb' _ 64) Ty.flatBits_eq).trans <|
        BitVec.extractLsb'_cast.trans <|
        h.trans <| congrArg (BitVec.extractLsb' o 64) <| flattenRaw_tE e.1 e.2.1 e.2.2
  simp only [fd_ed25519_base_point_wnaf_table.point, quadAt, entry, Nat.add_assoc]
  congr 1 <;> ext i hi : 1 <;> rw [Vector.getElem_ofFn]
  · exact (key _ (by omega)).trans <| (pack3_extract _ _ _ hi).1.trans (vec_lane _ hi)
  · exact (key _ (by omega)).trans <| (pack3_extract _ _ _ hi).2.1.trans (vec_lane _ hi)
  · exact (key _ (by omega)).trans <| (pack3_extract _ _ _ hi).2.2.trans (vec_lane _ hi)

/-! ## Checks

Natural number checks, mod `p`, that the kernel decides. -/

/-- Element `k`'s integer. -/
abbrev coord (T : Quad) (k : ℕ) : ℕ :=
  R43x6.nat (quadElem T.P03 T.P14 T.P25 k)

/-- The affine point an entry stores, `((Y + X) - (Y - X), (Y + X) + (Y - X)) / 2`: the witness
the checks test. -/
def affine (T : Quad) : ℕ × ℕ :=
  ((coord T 1 + p - coord T 0 % p) * ((p + 1) / 2) % p, (coord T 0 + coord T 1) * ((p + 1) / 2) % p)

/-- `T` is the curve point `(x, y)` as `(Y - X, Y + X, Z, 2d T)` with `Z = 1`, folded. -/
abbrev EntryOk (T : Quad) (x y : ℕ) : Prop :=
  (coord T 0 + x) % p = y % p ∧ coord T 1 % p = (y + x) % p ∧ coord T 2 % p = 1 ∧
    coord T 3 % p = 2 * dN * x * y % p ∧
    R43x6.Folded (quadElem T.P03 T.P14 T.P25 0) ∧ R43x6.Folded (quadElem T.P03 T.P14 T.P25 1) ∧
    R43x6.Folded (quadElem T.P03 T.P14 T.P25 2) ∧ R43x6.Folded (quadElem T.P03 T.P14 T.P25 3) ∧
    curveOk x y = true

/-- Entry `0` stores `B`, and `2 B` is `(x2N, y2N)`. -/
theorem base_ok :
    affine (entry fd_ed25519_base_point_wnaf_table.lit[0]) = (Ed25519.Bx.val, Ed25519.By.val) ∧
      dblOk Ed25519.Bx.val Ed25519.By.val x2N y2N = true := by
  decide +kernel

/-- Every entry stores its point, on the curve. -/
theorem entries_ok :
    ∀ j (h : j < 128),
      EntryOk (entry fd_ed25519_base_point_wnaf_table.lit[j])
        (affine (entry fd_ed25519_base_point_wnaf_table.lit[j])).1
        (affine (entry fd_ed25519_base_point_wnaf_table.lit[j])).2 := by
  decide +kernel

/-- Each entry's point plus `2 B` is the next's. -/
theorem adds_ok :
    ∀ j (h : j < 127),
      addOk (affine (entry fd_ed25519_base_point_wnaf_table.lit[j])).1
          (affine (entry fd_ed25519_base_point_wnaf_table.lit[j])).2 x2N y2N
          (affine (entry fd_ed25519_base_point_wnaf_table.lit[j + 1])).1
          (affine (entry fd_ed25519_base_point_wnaf_table.lit[j + 1])).2 =
        true := by
  decide +kernel

/-! ## Soundness -/

/-- A folded element's value is its integer's. -/
theorem val_coord {T : Quad} {k : ℕ} (h : R43x6.Folded (quadElem T.P03 T.P14 T.P25 k)) :
    R43x6.val (quadElem T.P03 T.P14 T.P25 k) = (coord T k : ZMod p) :=
  R43x6.val_eq_nat (h.unsigned.mono (by omega))

/-- `EntryOk` gives the elements' values and ranges, and the point on the curve. -/
theorem entry_of_ok {T : Quad} {x y : ℕ} (h : EntryOk T x y) :
    R43x6.val (quadElem T.P03 T.P14 T.P25 0) = (y : ZMod p) - x ∧
      R43x6.val (quadElem T.P03 T.P14 T.P25 1) = (y : ZMod p) + x ∧
      R43x6.val (quadElem T.P03 T.P14 T.P25 2) = 1 ∧
      R43x6.val (quadElem T.P03 T.P14 T.P25 3) = 2 * Ed25519.d * ((x : ZMod p) * y) ∧
      (∀ k < 4, R43x6.Folded (quadElem T.P03 T.P14 T.P25 k)) ∧ Ed25519.OnCurve x y := by
  obtain ⟨h0, h1, h2, h3, f0, f1, f2, f3, hc⟩ := h
  have e0 := natCast_eq h0
  have e1 := natCast_eq h1
  have e2 := natCast_eq (b := 1) h2
  have e3 := natCast_eq h3
  push_cast [dN_eq] at e0 e1 e2 e3
  rw [val_coord f0, val_coord f1, val_coord f2, val_coord f3]
  refine ⟨by linear_combination e0, e1, e2,
    by linear_combination e3, fun k hk => ?_, onCurve_of_ok hc⟩
  match k, hk with
  | 0, _ => exact f0
  | 1, _ => exact f1
  | 2, _ => exact f2
  | 3, _ => exact f3

/-- `(2 j + 1) B` is the point entry `j` stores. -/
theorem oddMul_eq {j : ℕ} (hj : j < 128) :
    Ref.Ed25519.oddMul j =
      (((affine (fd_ed25519_base_point_wnaf_table.point j)).1 : ZMod p),
        ((affine (fd_ed25519_base_point_wnaf_table.point j)).2 : ZMod p)) := by
  induction j with
  | zero =>
    rw [point_eq hj, base_ok.1, ZMod.natCast_zmod_val, ZMod.natCast_zmod_val]
    rfl
  | succ j ih =>
    have h2 := dbl_of_ok base_ok.2
    rw [ZMod.natCast_zmod_val, ZMod.natCast_zmod_val] at h2
    rw [Ref.Ed25519.oddMul, ih (by omega), h2, point_eq hj, point_eq (by omega)]
    exact add_of_ok (adds_ok j (by omega))

/-! ## The table -/

/-- Entry `j` of the base point's table is `(2 j + 1) B = (x, y)` as `add_with_opts`'s
precomputed operand `(Y - X, Y + X, Z, 2d T)` with `Z = 1`: elements `y - x, y + x, 1, 2d x y`,
all folded, the point on the curve. -/
public theorem fd_ed25519_base_point_wnaf_table.point_operand {j : ℕ} (hj : j < 128) :
    let T := fd_ed25519_base_point_wnaf_table.point j
    let Q := Ref.Ed25519.oddMul j
    R43x6.val (quadElem T.P03 T.P14 T.P25 0) = Q.2 - Q.1 ∧
      R43x6.val (quadElem T.P03 T.P14 T.P25 1) = Q.2 + Q.1 ∧
      R43x6.val (quadElem T.P03 T.P14 T.P25 2) = 1 ∧
      R43x6.val (quadElem T.P03 T.P14 T.P25 3) = 2 * Ed25519.d * (Q.1 * Q.2) ∧
      (∀ k < 4, R43x6.Folded (quadElem T.P03 T.P14 T.P25 k)) ∧ Ed25519.OnCurve Q.1 Q.2 := by
  intro T Q
  have h := entries_ok j hj
  rw [← point_eq hj] at h
  rw [show Q = _ from oddMul_eq hj]
  exact entry_of_ok h

end MLIR.Firedancer.Avx512
