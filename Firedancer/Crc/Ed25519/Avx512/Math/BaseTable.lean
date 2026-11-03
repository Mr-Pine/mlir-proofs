module

public import Firedancer.Crc.Ed25519.Avx512.Math.Ladder
import Firedancer.Math.BaseTable
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! crc's base table `fd_ed25519_r52x5_base_table`: entry `k` of segment `0` is `(2 k + 1) B`,
precomputed as `(Y - X, Y + X, 2d T)` with `Z = 1`, three words per limb (the kernel reconstitutes
`2 Z`), every limb below `2^52`. The words are read off the global's bits; the points are checked by
the kernel, mod `p`, against the curve formulas. -/

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5
open _root_.Ed25519 (p natCast_eq)
open MLIR.Firedancer.Ref (dN x2N y2N curveOk addOk dblOk dN_eq add_of_ok dbl_of_ok)

namespace BaseTable

/-! ## Reading the table -/

/-- An entry's type: words `3 i`, `3 i + 1`, `3 i + 2` are limb `i` of `Y - X`, `Y + X`, `2d T`;
word `15` is padding. -/
abbrev tE : Ty :=
  .struct [.array 16 (.bv 64)]

/-- An entry's QUAD as the kernel loads it: the three words of each limb in lanes `0`, `1`, `3`,
lane `2` the `Z = 1` limbs `2, 0, 0, 0, 0`. -/
noncomputable def entry (e : ⟦tE⟧ᵣ) : Quad5 :=
  ⟨#v[e[0], e[1], 2#64, e[2]], #v[e[3], e[4], 0#64, e[5]], #v[e[6], e[7], 0#64, e[8]],
    #v[e[9], e[10], 0#64, e[11]], #v[e[12], e[13], 0#64, e[14]]⟩

/-- Word `w` of entry `k` of segment `0`, off the table's bits. -/
theorem word_eq {k w : ℕ} (hk : k < 128) (hw : w < 16) :
    (Ty.flatBits fd_ed25519_r52x5_base_table.lit (w := 1048576) (hw := rfl)).extractLsb'
        (1024 * k + 64 * w) 64 =
      fd_ed25519_r52x5_base_table.lit[0][k][w] := by
  have hs1 : (Ty.array 128 tE).stride = 131072 := rfl
  have hs2 : tE.stride = 1024 := rfl
  have hs3 : (Ty.bv 64).stride = 64 := rfl
  have h1 := Ty.extractLsb'_flattenRaw_array fd_ed25519_r52x5_base_table.lit
    (s := 1024 * k + 64 * w) (w := 64) (by rw [hs1]; omega)
    (by rw [hs1, show (Ty.array 128 tE).width = 131072 from rfl]; omega)
  have e1 : (1024 * k + 64 * w) / (Ty.array 128 tE).stride = 0 := by rw [hs1]; omega
  have e2 : (1024 * k + 64 * w) % (Ty.array 128 tE).stride = 1024 * k + 64 * w := by
    rw [hs1]; omega
  simp only [e1, e2] at h1
  have h2 := Ty.extractLsb'_flattenRaw_array fd_ed25519_r52x5_base_table.lit[0]
    (s := 1024 * k + 64 * w) (w := 64) (by rw [hs2]; omega)
    (by rw [hs2, show tE.width = 1024 from rfl]; omega)
  have e3 : (1024 * k + 64 * w) / tE.stride = k := by rw [hs2]; omega
  have e4 : (1024 * k + 64 * w) % tE.stride = 64 * w := by rw [hs2]; omega
  simp only [e3, e4] at h2
  have h3 := Ty.extractLsb'_flattenRaw_struct_singleton fd_ed25519_r52x5_base_table.lit[0][k]
    (s := 64 * w) (w := 64) (by show 64 * w + 64 ≤ 1024; omega)
  have h4 := Ty.extractLsb'_flattenRaw_array
    (fd_ed25519_r52x5_base_table.lit[0][k] : ⟦Ty.array 16 (Ty.bv 64)⟧ᵣ)
    (s := 64 * w) (w := 64) (by rw [hs3]; omega) (by rw [hs3, show (Ty.bv 64).width = 64 from rfl]; omega)
  have e5 : (64 * w) / (Ty.bv 64).stride = w := by rw [hs3]; omega
  have e6 : (64 * w) % (Ty.bv 64).stride = 0 := by rw [hs3]; omega
  simp only [e5, e6] at h4
  exact (congrArg (BitVec.extractLsb' _ 64) Ty.flatBits_eq).trans <|
    BitVec.extractLsb'_cast.trans <| h1.trans <| h2.trans <| h3.trans <| h4.trans <|
    (Ty.extractLsb'_flattenRaw_bv _).trans BitVec.extractLsb'_eq_self

/-- Limb `i` of entry `k` as the kernel fixes it: its three words, `z` in lane `2`. -/
theorem fixAt_eq {k i : ℕ} (hk : k < 128) (hi : i < 5) (z : BitVec 64) :
    fixAt (Ty.flatBits fd_ed25519_r52x5_base_table.lit (w := 1048576) (hw := rfl))
        (128 * k + 24 * i) z =
      #v[fd_ed25519_r52x5_base_table.lit[0][k][3 * i], fd_ed25519_r52x5_base_table.lit[0][k][3 * i + 1],
        z, fd_ed25519_r52x5_base_table.lit[0][k][3 * i + 2]] := by
  have e1 : 8 * (128 * k + 24 * i) = 1024 * k + 64 * (3 * i) := by ring
  have e2 : 1024 * k + 64 * (3 * i) + 64 = 1024 * k + 64 * (3 * i + 1) := by ring
  have e3 : 1024 * k + 64 * (3 * i) + 128 = 1024 * k + 64 * (3 * i + 2) := by ring
  have w0 := word_eq hk (w := 3 * i) (by omega)
  have w1 := word_eq hk (w := 3 * i + 1) (by omega)
  have w2 := word_eq hk (w := 3 * i + 2) (by omega)
  simp only [fixAt, e1, e2, e3, w0, w1, w2]

/-- Entry `k` is the literal's. -/
theorem point_eq {k : ℕ} (hk : k < 128) :
    fd_ed25519_r52x5_base_table.point k = entry fd_ed25519_r52x5_base_table.lit[0][k] := by
  have e0 := fixAt_eq hk (i := 0) (by omega) 2#64
  have e1 := fixAt_eq hk (i := 1) (by omega) 0#64
  have e2 := fixAt_eq hk (i := 2) (by omega) 0#64
  have e3 := fixAt_eq hk (i := 3) (by omega) 0#64
  have e4 := fixAt_eq hk (i := 4) (by omega) 0#64
  simp only [Nat.reduceMul, Nat.reduceAdd, Nat.mul_zero, Nat.add_zero, Nat.zero_add] at e0 e1 e2 e3 e4
  unfold fd_ed25519_r52x5_base_table.point tbPoint entry
  rw [e0, e1, e2, e3, e4]

/-! ## Checks

Natural number checks, mod `p`, that the kernel decides. -/

/-- Coordinate `c`'s integer. -/
abbrev coord (T : Quad5) (c : Fin 4) : ℕ :=
  Ed25519.Limbs.nat (T.elem c)

/-- The affine point an entry stores, `((Y + X) - (Y - X), (Y + X) + (Y - X)) / 2`: the witness
the checks test. -/
def affine (T : Quad5) : ℕ × ℕ :=
  ((coord T 1 + p - coord T 0 % p) * ((p + 1) / 2) % p, (coord T 0 + coord T 1) * ((p + 1) / 2) % p)

/-- `T` is the curve point `(x, y)` as `(Y - X, Y + X, 2 Z, 2d T)` with `Z = 1`, limbs below
`2^52`. -/
abbrev EntryOk (T : Quad5) (x y : ℕ) : Prop :=
  (coord T 0 + x) % p = y % p ∧ coord T 1 % p = (y + x) % p ∧ coord T 2 % p = 2 ∧
    coord T 3 % p = 2 * dN * (x * y) % p ∧ T.Below 52 ∧ curveOk x y = true

/-- Entry `0` stores `B`, and `2 B` is `(x2N, y2N)`. -/
theorem base_ok :
    affine (entry fd_ed25519_r52x5_base_table.lit[0][0]) = (Ed25519.Bx.val, Ed25519.By.val) ∧
      dblOk Ed25519.Bx.val Ed25519.By.val x2N y2N = true := by
  decide +kernel

/-- Every entry stores its point, on the curve. -/
theorem entries_ok :
    ∀ k (h : k < 128),
      EntryOk (entry fd_ed25519_r52x5_base_table.lit[0][k])
        (affine (entry fd_ed25519_r52x5_base_table.lit[0][k])).1
        (affine (entry fd_ed25519_r52x5_base_table.lit[0][k])).2 := by
  decide +kernel

/-- Each entry's point plus `2 B` is the next's. -/
theorem adds_ok :
    ∀ k (h : k < 127),
      addOk (affine (entry fd_ed25519_r52x5_base_table.lit[0][k])).1
          (affine (entry fd_ed25519_r52x5_base_table.lit[0][k])).2 x2N y2N
          (affine (entry fd_ed25519_r52x5_base_table.lit[0][k + 1])).1
          (affine (entry fd_ed25519_r52x5_base_table.lit[0][k + 1])).2 =
        true := by
  decide +kernel

/-! ## Soundness -/

/-- `EntryOk` gives the precomputed point and the limb bound. -/
theorem entry_of_ok {T : Quad5} {x y : ℕ} (h : EntryOk T x y) : T.Pre x y ∧ T.Below 52 := by
  obtain ⟨h0, h1, h2, h3, hb, -⟩ := h
  have e0 := natCast_eq h0
  have e1 := natCast_eq h1
  have e2 := natCast_eq (b := 2) h2
  have e3 := natCast_eq h3
  push_cast [dN_eq] at e0 e1 e2 e3
  refine ⟨⟨x, y, x * y, 1, ⟨one_ne_zero, by ring, by ring, by ring⟩, ?_, ?_, ?_, ?_⟩, hb⟩ <;>
    rw [Quad5.val, Ed25519.Limbs.val_nat]
  · linear_combination e0
  · linear_combination e1
  · linear_combination e2
  · linear_combination e3

/-- `(2 k + 1) B` is the point entry `k` stores. -/
theorem oddMul_eq {k : ℕ} (hk : k < 128) :
    Ref.Ed25519.oddMul k =
      (((affine (fd_ed25519_r52x5_base_table.point k)).1 : ZMod p),
        ((affine (fd_ed25519_r52x5_base_table.point k)).2 : ZMod p)) := by
  induction k with
  | zero =>
    rw [point_eq hk, base_ok.1, ZMod.natCast_zmod_val, ZMod.natCast_zmod_val]
    rfl
  | succ j ih =>
    have h2 := dbl_of_ok base_ok.2
    rw [ZMod.natCast_zmod_val, ZMod.natCast_zmod_val] at h2
    rw [Ref.Ed25519.oddMul, ih (by omega), h2, point_eq hk, point_eq (by omega)]
    exact add_of_ok (adds_ok j (by omega))

end BaseTable

/-! ## The table -/

/-- The base table is a table of the odd multiples of the base point: entry `k` is `(2 k + 1) B`
precomputed, limbs below `2^52`. -/
public theorem fd_ed25519_r52x5_base_table.oddTab :
    OddTab fd_ed25519_r52x5_base_table.point 128 Ed25519.basePoint := by
  intro k hk
  have h := BaseTable.entries_ok k hk
  rw [← BaseTable.point_eq hk] at h
  have e := BaseTable.oddMul_eq hk
  rw [Ref.Ed25519.oddMul_eq_nsmul] at e
  refine ⟨?_, (BaseTable.entry_of_ok h).2⟩
  rw [(Prod.mk.inj e).1, (Prod.mk.inj e).2]
  exact (BaseTable.entry_of_ok h).1

end MLIR.Firedancer.Crc.Ed25519.Avx512
