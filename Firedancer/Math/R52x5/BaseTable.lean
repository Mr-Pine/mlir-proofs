module

public import Firedancer.Math.BaseTable
public import Firedancer.Math.R52x5.Point
public import Firedancer.R52x5.Globals
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The r52x5 base point table `fd_ed25519_base_point_wnaf_table`: entry `j` is `(2 j + 1) B`,
precomputed as `121666 (Y - X, Y + X, 2 Z, 2d T)` with `Z = 1`, every limb below `2^52`. The lanes
are read off the global's bits; the points are checked by the kernel, mod `p`, against the curve
formulas. -/

namespace MLIR.Firedancer.R52x5

open _root_.Ed25519 (p natCast_eq natCast_ne)
open MLIR.Firedancer.Ref (dN x2N y2N curveOk addOk dblOk dN_eq add_of_ok dbl_of_ok onCurve_of_ok)

namespace BaseTable

/-! ## Reading the table -/

/-- An entry's type: `Q0 … Q4` and 32 bytes of padding. -/
abbrev tE : Ty :=
  .struct [.vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .vec 4 64, .array 32 (.bv 8)]

/-- An entry's QUAD; noncomputable: the compiler cannot type a `⟦t⟧ᵣ` argument across modules. -/
noncomputable def entry (e : ⟦tE⟧ᵣ) : Quad5 :=
  ⟨e.1, e.2.1, e.2.2.1, e.2.2.2.1, e.2.2.2.2.1⟩

/-- Six 256-bit fields, packed as a struct: `a` lowest. -/
abbrev pack6 (a b c d e f : BitVec 256) : BitVec 1536 :=
  (((((0#0 ++ f) ++ (0#0 ++ e)) ++ (0#0 ++ d)) ++ (0#0 ++ c)) ++ (0#0 ++ b)) ++ (0#0 ++ a)

/-- Lane `i` of each of the first five fields. -/
theorem pack6_extract (a b c d e f : BitVec 256) {i : Nat} (hi : i < 4) :
    (pack6 a b c d e f).extractLsb' (64 * i) 64 = a.extractLsb' (64 * i) 64 ∧
      (pack6 a b c d e f).extractLsb' (256 + 64 * i) 64 = b.extractLsb' (64 * i) 64 ∧
      (pack6 a b c d e f).extractLsb' (512 + 64 * i) 64 = c.extractLsb' (64 * i) 64 ∧
      (pack6 a b c d e f).extractLsb' (768 + 64 * i) 64 = d.extractLsb' (64 * i) 64 ∧
      (pack6 a b c d e f).extractLsb' (1024 + 64 * i) 64 = e.extractLsb' (64 * i) 64 := by
  simp (disch := omega) only [pack6, BitVec.extractLsb'_append_eq_of_add_le,
    BitVec.extractLsb'_append_eq_of_le, Nat.zero_add, Nat.add_sub_cancel_left, true_and]
  rw [show 512 + 64 * i - 256 - 256 = 64 * i by omega,
    show 768 + 64 * i - 256 - 256 - 256 = 64 * i by omega,
    show 1024 + 64 * i - 256 - 256 - 256 - 256 = 64 * i by omega]
  exact ⟨rfl, rfl, rfl⟩

/-- An entry's bits: its fields', packed. -/
theorem flattenRaw_tE (a b c d e : Wl) (f : ⟦.array 32 (.bv 8)⟧ᵣ) :
    Ty.flattenRaw tE (a, b, c, d, e, f) =
      pack6 (Ty.flattenRaw (.vec 4 64) a) (Ty.flattenRaw (.vec 4 64) b)
        (Ty.flattenRaw (.vec 4 64) c) (Ty.flattenRaw (.vec 4 64) d) (Ty.flattenRaw (.vec 4 64) e)
        (Ty.flattenRaw (.array 32 (.bv 8)) f) :=
  (Ty.flattenRaw_struct _).trans <|
    (Ty.flattenRawFields_cons _ _).trans <|
    congrArg (· ++ _) <|
    (Ty.flattenRawFields_cons _ _).trans <|
    congrArg (· ++ _) <|
    (Ty.flattenRawFields_cons _ _).trans <|
    congrArg (· ++ _) <|
    (Ty.flattenRawFields_cons _ _).trans <|
    congrArg (· ++ _) <|
    (Ty.flattenRawFields_cons _ _).trans <| congrArg (· ++ _) <| Ty.flattenRawFields_singleton _

/-- Lane `i` of a vector's bits. -/
theorem vec_lane (v : Wl) {i : Nat} (hi : i < 4) :
    (Ty.flattenRaw (.vec 4 64) v).extractLsb' (64 * i) 64 = v[i] := by
  rw [Ty.flattenRaw_vec, Nat.mul_comm]
  exact BitVec.extractLsb'_packLanes v i hi

/-- Entry `j` is the literal's. -/
theorem point_eq {j : ℕ} (hj : j < 128) :
    fd_ed25519_base_point_wnaf_table.point j = entry fd_ed25519_base_point_wnaf_table.lit[j] := by
  set e := fd_ed25519_base_point_wnaf_table.lit[j]
  set F :=
    pack6 (Ty.flattenRaw (.vec 4 64) e.1) (Ty.flattenRaw (.vec 4 64) e.2.1)
      (Ty.flattenRaw (.vec 4 64) e.2.2.1) (Ty.flattenRaw (.vec 4 64) e.2.2.2.1)
      (Ty.flattenRaw (.vec 4 64) e.2.2.2.2.1) (Ty.flattenRaw (.array 32 (.bv 8)) e.2.2.2.2.2)
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
        h.trans <|
        congrArg (BitVec.extractLsb' o 64) <|
        flattenRaw_tE e.1 e.2.1 e.2.2.1 e.2.2.2.1 e.2.2.2.2.1 e.2.2.2.2.2
  simp only [fd_ed25519_base_point_wnaf_table.point, quad5At, entry, Nat.add_assoc]
  congr 1 <;> ext i hi : 1 <;> rw [Vector.getElem_ofFn]
  · exact (key _ (by omega)).trans <| (pack6_extract _ _ _ _ _ _ hi).1.trans (vec_lane _ hi)
  · exact (key _ (by omega)).trans <| (pack6_extract _ _ _ _ _ _ hi).2.1.trans (vec_lane _ hi)
  · exact (key _ (by omega)).trans <| (pack6_extract _ _ _ _ _ _ hi).2.2.1.trans (vec_lane _ hi)
  · exact (key _ (by omega)).trans <| (pack6_extract _ _ _ _ _ _ hi).2.2.2.1.trans (vec_lane _ hi)
  · exact (key _ (by omega)).trans <| (pack6_extract _ _ _ _ _ _ hi).2.2.2.2.trans (vec_lane _ hi)

/-! ## Checks

Natural number checks, mod `p`, that the kernel decides. -/

/-- Coordinate `k`'s integer. -/
abbrev coord (T : Quad5) (k : Fin 4) : ℕ :=
  Ed25519.Limbs.nat (T.elem k)

/-- `1 / 243332` mod `p`. -/
def inv243332 : ℕ :=
  18547852967334719671569041754377282594771056939921609508194392766542970141778

/-- The affine point an entry stores, `((Y + X) - (Y - X), (Y + X) + (Y - X)) / 243332`: the
witness the checks test. -/
def affine (T : Quad5) : ℕ × ℕ :=
  ((coord T 1 + p - coord T 0 % p) * inv243332 % p, (coord T 0 + coord T 1) * inv243332 % p)

/-- `T` is the curve point `(x, y)` as `121666 (Y - X, Y + X, 2 Z, 2d T)` with `Z = 1`, limbs below
`2^52`. -/
abbrev EntryOk (T : Quad5) (x y : ℕ) : Prop :=
  (coord T 0 + 121666 * x) % p = 121666 * y % p ∧
    coord T 1 % p = 121666 * (y + x) % p ∧
    coord T 2 % p = 243332 ∧
    coord T 3 % p = 2 * dN * (121666 * (x * y)) % p ∧ T.Below 52 ∧ curveOk x y = true

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

/-- `EntryOk` gives the precomputed point and the limb bound. -/
theorem entry_of_ok {T : Quad5} {x y : ℕ} (h : EntryOk T x y) : T.Pre x y ∧ T.Below 52 := by
  obtain ⟨h0, h1, h2, h3, hb, -⟩ := h
  have e0 := natCast_eq h0
  have e1 := natCast_eq h1
  have e2 := natCast_eq (b := 243332) h2
  have e3 := natCast_eq h3
  push_cast [dN_eq] at e0 e1 e2 e3
  refine
      ⟨⟨121666 * x, 121666 * y, 121666 * (x * y), 121666, ⟨by decide, by ring, by ring, by ring⟩,
          ?_, ?_, ?_, ?_⟩,
        hb⟩ <;>
    rw [Quad5.val, Ed25519.Limbs.val_nat]
  · linear_combination e0
  · linear_combination e1
  · linear_combination e2
  · linear_combination e3

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

end BaseTable

/-! ## The table -/

/-- Entry `j` of the base point's table is `(2 j + 1) B` precomputed, limbs below `2^52`. -/
public theorem fd_ed25519_base_point_wnaf_table.point_pre {j : ℕ} (hj : j < 128) :
    (fd_ed25519_base_point_wnaf_table.point j).Pre (Ref.Ed25519.oddMul j).1
        (Ref.Ed25519.oddMul j).2 ∧
      (fd_ed25519_base_point_wnaf_table.point j).Below 52 := by
  have h := BaseTable.entries_ok j hj
  rw [← BaseTable.point_eq hj] at h
  rw [BaseTable.oddMul_eq hj]
  exact BaseTable.entry_of_ok h

end MLIR.Firedancer.R52x5
