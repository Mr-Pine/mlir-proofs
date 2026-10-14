module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_double_scalar_mul_base
public import Firedancer.Lane.fd_ed25519_partial_dbl
public import Firedancer.Lane.fd_ed25519_point_dbln
public import Firedancer.Lane.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.fd_curve25519_scalar_wnaf
public import Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

namespace fd_ed25519_double_scalar_mul_base

open _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base
open Avx512.fd_ed25519_double_scalar_mul_base (start aiTable addDigit add1 adds ladder)
open Firedancer.Ref

/-- The lift's runs from a block. -/
local notation "runD" => _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base.runFrom

set_option hygiene false in
/-- An erased frame's equation, by the `mlir_erase` lemmas, the bounds from the context. -/
local macro "erase_eq" : tactic =>
  `(tactic| simp (disch := assumption) only [mlir_erase])

/-- Register `k` of the lift. -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base.hty $k)

/-! ### Counters -/

/-- `i - d` on a small `int` counter, `c` being `-d`, does not overflow. -/
theorem saddOverflow_sub32 {i c d : Nat} (hc : c + d = 2 ^ 32) (hd : d ≤ 8) (h : i < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow (BitVec.ofNat 32 c) = false := by
  have hn : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (BitVec.ofNat 32 c).toInt = -(d : Int) := by
    simp only [BitVec.toInt, BitVec.toNat_ofNat]
    split <;> omega
  simp [BitVec.saddOverflow, hn, hm]
  omega

/-- `i - d` on an `int` counter at least `d`, `c` being `-d`. -/
theorem add_sub32 {i c d : Nat} (hc : c + d = 2 ^ 32) (h1 : d ≤ i) (h : i < 2 ^ 32) :
    BitVec.ofNat 32 i + BitVec.ofNat 32 c = BitVec.ofNat 32 (i - d) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-! ### The zero-digit search -/

/-- `start` from `i` as from `j = i - 1`, past a zero digit pair. -/
theorem start_pred {w1 w2 : Vector Int 256} {i j : Nat} (hi : i < 256) (hj : j + 1 = i)
    (h : w1[i] = 0 ∧ w2[i] = 0) : start w1 w2 i hi = start w1 w2 j (by omega) := by
  subst hj
  simp [start, h]

/-- `start` at a non-zero digit pair. -/
theorem start_self {w1 w2 : Vector Int 256} {i : Nat} (hi : i < 256)
    (h : ¬(w1[i] = 0 ∧ w2[i] = 0)) : start w1 w2 i hi = some ⟨i, hi⟩ := by
  cases i with
  | zero => simp [start, h]
  | succ j => simp [start, h]

/-- `start` at digit `0` of a zero pair: none. -/
theorem start_zero {w1 w2 : Vector Int 256} {j : Nat} (hj : j < 256) (h0 : j = 0)
    (h : w1[j] = 0 ∧ w2[j] = 0) : start w1 w2 j hj = none := by
  subst h0
  simp [start, h]

/-- `p`'s limbs 3 and 7, the rest poison: `FD_R43X6_QUAD_LANE_SUB_FAST( …, 0,0,0,1, _p, … )`'s. -/
abbrev negK03 : ⟦.vec 8 64⟧ :=
  #v[.poison, .poison, .poison, .value 17592186044378#64, .poison, .poison, .poison,
    .value 17592186044414#64]

/-- `negK03` for the second vector. -/
abbrev negK14 : ⟦.vec 8 64⟧ :=
  #v[.poison, .poison, .poison, .value 17592186044414#64, .poison, .poison, .poison,
    .value 17592186044414#64]

/-- `negK03` for the third vector. -/
abbrev negK25 : ⟦.vec 8 64⟧ :=
  #v[.poison, .poison, .poison, .value 17592186044414#64, .poison, .poison, .poison,
    .value 2199023255550#64]

/-- The registers the main loop and the lifetimes' ends read, `i` aside: constants, the base
point's table, the negations' `p` limbs, the slots and the points' second and third vectors. -/
abbrev PreRegs (r tbl n1s n2s ai a2 tp tA tB : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1 := 18446744073709551615#64, %2 := tbl, %6 := 1#16, %13 := 4294967295#32, %14 := 0#16,
    %27 := 0#64, %43 := 1#32, %92 := negK03, %100 := negK14, %108 := negK25, %109 := tB,
    %110 := tA, %111 := n1s, %112 := n2s, %113 := ai, %114 := a2, %115 := tp,
    %%253 := tp.add 64#64, %%254 := tp.add 128#64, %%255 := r.add 64#64]

/-- `PreRegs` but `r`'s second vector: the registers the entry block leaves. -/
abbrev CommonRegs (tbl n1s n2s ai a2 tp tA tB : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1 := 18446744073709551615#64, %2 := tbl, %6 := 1#16, %13 := 4294967295#32, %14 := 0#16,
    %27 := 0#64, %43 := 1#32, %92 := negK03, %100 := negK14, %108 := negK25, %109 := tB,
    %110 := tA, %111 := n1s, %112 := n2s, %113 := ai, %114 := a2, %115 := tp,
    %%253 := tp.add 64#64, %%254 := tp.add 128#64]

/-- The search's constants. -/
abbrev SkipConsts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := 4294967288#32, %7 := 4294967289#32, %8 := 4294967290#32, %9 := 4294967291#32,
    %10 := 4294967292#32, %11 := 4294967293#32, %12 := 4294967294#32, %52 := 0#32]

/-- `PreRegs` and the search's constants. -/
abbrev SkipRegs (r tbl n1s n2s ai a2 tp tA tB : Pointer) (E : ⟪Γ⟫) : Prop :=
  PreRegs r tbl n1s n2s ai a2 tp tA tB E ∧ SkipConsts E

/-- `^bb3` to `^bb19`, the zero-digit search unrolled eight times, at `i`: on to `^bb20` at the
first non-zero digit pair down to `i - 7`, else around at `i - 8`, or out after digit `0`. -/
theorem skip_group (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (w1 w2 : Vector Int 256)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (hi7 : 7 ≤ i) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : SkipRegs r tbl n1s n2s ai a2 tp tA tB E) (hRi : E ⊨ [%%396 := BitVec.ofNat 32 i])
    (hn1s : SlidesAt S.mem n1s w1) (hn2s : SlidesAt S.mem n2s w2)
    (hfound :
      ∀ j (hj : j < 256),
        start w1 w2 i hi = some ⟨j, hj⟩ →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              PreRegs r tbl n1s n2s ai a2 tp tA tB E' →
              (E' ⊨ [%%462 := BitVec.ofNat 32 j]) → (runD E' ^bb20 S >>= g) = K)
    (hnone :
      start w1 w2 i hi = none →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            PreRegs r tbl n1s n2s ai a2 tp tA tB E' → (runD E' ^bb33 S >>= g) = K)
    (hback :
      ∀ (hi8 : 8 ≤ i), start w1 w2 i hi = start w1 w2 (i - 8) (by omega) →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            SkipRegs r tbl n1s n2s ai a2 tp tA tB E' →
            (E' ⊨ [%%396 := BitVec.ofNat 32 (i - 8)]) → (runD E' ^bb3 S >>= g) = K) :
    (runD E ^bb3 S >>= g) = K := by
  obtain ⟨hP, hC⟩ := hR
  dsimp only [PreRegs] at hP
  have hb1 : ∀ k (hk : k < 256), (-2 ^ 15 : Int) ≤ w1[k] ∧ w1[k] < 2 ^ 15 := fun k hk => by
    have := hw1 k hk
    omega
  have hb2 : ∀ k (hk : k < 256), (-2 ^ 15 : Int) ≤ w2[k] ∧ w2[k] < 2 ^ 15 := fun k hk => by
    have := hw2 k hk
    omega
  clear hw1 hw2
  -- `n1slide[i]`
  block_init
  step_pure [msb_ofNat32 (show i < 2 ^ 31 by omega),
    setWidth_ofNat32 (show i < 2 ^ 32 by omega)]
  have hf := (hn1s i hi).1
  have hl := (hn1s i hi).2
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i] = 0 ∧ w2[i] = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb1 _ hi)).2 h.1)
    subst hS
    exact hfound _ _ (start_self _ hnz) E hArgs (by env_reads) (by env_reads)
  have h1 : w1[i] = 0 := (ofInt16_eq_zero (hb1 _ hi)).1 hbr
  -- `n2slide[i]`
  block_init
  have hf := (hn2s i hi).1
  have hl := (hn2s i hi).2
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i] = 0 ∧ w2[i] = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb2 _ hi)).2 h.2)
    subst hS
    exact hfound _ _ (start_self _ hnz) E hArgs (by env_reads) (by env_reads)
  have h2 : w2[i] = 0 := (ofInt16_eq_zero (hb2 _ hi)).1 hbr
  have hs := start_pred (w1 := w1) (w2 := w2) hi (show i - 1 + 1 = i by omega) ⟨h1, h2⟩
  clear h1 h2
  -- `n1slide[i - 1]`
  have hk1 : i - 1 < 256 := by omega
  block_init
  step_pure [saddOverflow_sub32 (c := 4294967295) (d := 1) rfl (by decide)
      (show i < 2 ^ 31 by omega),
    add_sub32 (c := 4294967295) (d := 1) rfl (show 1 ≤ i by omega) (show i < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show i - 1 < 2 ^ 31 by omega),
    setWidth_ofNat32 (show i - 1 < 2 ^ 32 by omega)]
  have hf := (hn1s (i - 1) hk1).1
  have hl := (hn1s (i - 1) hk1).2
  step_pure [Nat.mod_eq_of_lt (show i - 1 < 2 ^ 64 by omega), show 2 * (i - 1) < 2 ^ 64 by omega,
    show (i - 1) * 2 = 2 * (i - 1) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 1]'hk1 = 0 ∧ w2[i - 1]'hk1 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb1 _ hk1)).2 h.1)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h1 : w1[i - 1]'hk1 = 0 := (ofInt16_eq_zero (hb1 _ hk1)).1 hbr
  -- `n2slide[i - 1]`
  block_init
  have hf := (hn2s (i - 1) hk1).1
  have hl := (hn2s (i - 1) hk1).2
  step_pure [Nat.mod_eq_of_lt (show i - 1 < 2 ^ 64 by omega), show 2 * (i - 1) < 2 ^ 64 by omega,
    show (i - 1) * 2 = 2 * (i - 1) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 1]'hk1 = 0 ∧ w2[i - 1]'hk1 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb2 _ hk1)).2 h.2)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h2 : w2[i - 1]'hk1 = 0 := (ofInt16_eq_zero (hb2 _ hk1)).1 hbr
  have hs := hs.trans (start_pred hk1 (show i - 2 + 1 = i - 1 by omega) ⟨h1, h2⟩)
  clear h1 h2
  -- `n1slide[i - 2]`
  have hk2 : i - 2 < 256 := by omega
  block_init
  step_pure [saddOverflow_sub32 (c := 4294967294) (d := 2) rfl (by decide)
      (show i < 2 ^ 31 by omega),
    add_sub32 (c := 4294967294) (d := 2) rfl (show 2 ≤ i by omega) (show i < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show i - 2 < 2 ^ 31 by omega),
    setWidth_ofNat32 (show i - 2 < 2 ^ 32 by omega)]
  have hf := (hn1s (i - 2) hk2).1
  have hl := (hn1s (i - 2) hk2).2
  step_pure [Nat.mod_eq_of_lt (show i - 2 < 2 ^ 64 by omega), show 2 * (i - 2) < 2 ^ 64 by omega,
    show (i - 2) * 2 = 2 * (i - 2) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 2]'hk2 = 0 ∧ w2[i - 2]'hk2 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb1 _ hk2)).2 h.1)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h1 : w1[i - 2]'hk2 = 0 := (ofInt16_eq_zero (hb1 _ hk2)).1 hbr
  -- `n2slide[i - 2]`
  block_init
  have hf := (hn2s (i - 2) hk2).1
  have hl := (hn2s (i - 2) hk2).2
  step_pure [Nat.mod_eq_of_lt (show i - 2 < 2 ^ 64 by omega), show 2 * (i - 2) < 2 ^ 64 by omega,
    show (i - 2) * 2 = 2 * (i - 2) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 2]'hk2 = 0 ∧ w2[i - 2]'hk2 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb2 _ hk2)).2 h.2)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h2 : w2[i - 2]'hk2 = 0 := (ofInt16_eq_zero (hb2 _ hk2)).1 hbr
  have hs := hs.trans (start_pred hk2 (show i - 3 + 1 = i - 2 by omega) ⟨h1, h2⟩)
  clear h1 h2
  -- `n1slide[i - 3]`
  have hk3 : i - 3 < 256 := by omega
  block_init
  step_pure [saddOverflow_sub32 (c := 4294967293) (d := 3) rfl (by decide)
      (show i < 2 ^ 31 by omega),
    add_sub32 (c := 4294967293) (d := 3) rfl (show 3 ≤ i by omega) (show i < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show i - 3 < 2 ^ 31 by omega),
    setWidth_ofNat32 (show i - 3 < 2 ^ 32 by omega)]
  have hf := (hn1s (i - 3) hk3).1
  have hl := (hn1s (i - 3) hk3).2
  step_pure [Nat.mod_eq_of_lt (show i - 3 < 2 ^ 64 by omega), show 2 * (i - 3) < 2 ^ 64 by omega,
    show (i - 3) * 2 = 2 * (i - 3) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 3]'hk3 = 0 ∧ w2[i - 3]'hk3 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb1 _ hk3)).2 h.1)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h1 : w1[i - 3]'hk3 = 0 := (ofInt16_eq_zero (hb1 _ hk3)).1 hbr
  -- `n2slide[i - 3]`
  block_init
  have hf := (hn2s (i - 3) hk3).1
  have hl := (hn2s (i - 3) hk3).2
  step_pure [Nat.mod_eq_of_lt (show i - 3 < 2 ^ 64 by omega), show 2 * (i - 3) < 2 ^ 64 by omega,
    show (i - 3) * 2 = 2 * (i - 3) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 3]'hk3 = 0 ∧ w2[i - 3]'hk3 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb2 _ hk3)).2 h.2)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h2 : w2[i - 3]'hk3 = 0 := (ofInt16_eq_zero (hb2 _ hk3)).1 hbr
  have hs := hs.trans (start_pred hk3 (show i - 4 + 1 = i - 3 by omega) ⟨h1, h2⟩)
  clear h1 h2
  -- `n1slide[i - 4]`
  have hk4 : i - 4 < 256 := by omega
  block_init
  step_pure [saddOverflow_sub32 (c := 4294967292) (d := 4) rfl (by decide)
      (show i < 2 ^ 31 by omega),
    add_sub32 (c := 4294967292) (d := 4) rfl (show 4 ≤ i by omega) (show i < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show i - 4 < 2 ^ 31 by omega),
    setWidth_ofNat32 (show i - 4 < 2 ^ 32 by omega)]
  have hf := (hn1s (i - 4) hk4).1
  have hl := (hn1s (i - 4) hk4).2
  step_pure [Nat.mod_eq_of_lt (show i - 4 < 2 ^ 64 by omega), show 2 * (i - 4) < 2 ^ 64 by omega,
    show (i - 4) * 2 = 2 * (i - 4) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 4]'hk4 = 0 ∧ w2[i - 4]'hk4 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb1 _ hk4)).2 h.1)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h1 : w1[i - 4]'hk4 = 0 := (ofInt16_eq_zero (hb1 _ hk4)).1 hbr
  -- `n2slide[i - 4]`
  block_init
  have hf := (hn2s (i - 4) hk4).1
  have hl := (hn2s (i - 4) hk4).2
  step_pure [Nat.mod_eq_of_lt (show i - 4 < 2 ^ 64 by omega), show 2 * (i - 4) < 2 ^ 64 by omega,
    show (i - 4) * 2 = 2 * (i - 4) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 4]'hk4 = 0 ∧ w2[i - 4]'hk4 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb2 _ hk4)).2 h.2)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h2 : w2[i - 4]'hk4 = 0 := (ofInt16_eq_zero (hb2 _ hk4)).1 hbr
  have hs := hs.trans (start_pred hk4 (show i - 5 + 1 = i - 4 by omega) ⟨h1, h2⟩)
  clear h1 h2
  -- `n1slide[i - 5]`
  have hk5 : i - 5 < 256 := by omega
  block_init
  step_pure [saddOverflow_sub32 (c := 4294967291) (d := 5) rfl (by decide)
      (show i < 2 ^ 31 by omega),
    add_sub32 (c := 4294967291) (d := 5) rfl (show 5 ≤ i by omega) (show i < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show i - 5 < 2 ^ 31 by omega),
    setWidth_ofNat32 (show i - 5 < 2 ^ 32 by omega)]
  have hf := (hn1s (i - 5) hk5).1
  have hl := (hn1s (i - 5) hk5).2
  step_pure [Nat.mod_eq_of_lt (show i - 5 < 2 ^ 64 by omega), show 2 * (i - 5) < 2 ^ 64 by omega,
    show (i - 5) * 2 = 2 * (i - 5) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 5]'hk5 = 0 ∧ w2[i - 5]'hk5 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb1 _ hk5)).2 h.1)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h1 : w1[i - 5]'hk5 = 0 := (ofInt16_eq_zero (hb1 _ hk5)).1 hbr
  -- `n2slide[i - 5]`
  block_init
  have hf := (hn2s (i - 5) hk5).1
  have hl := (hn2s (i - 5) hk5).2
  step_pure [Nat.mod_eq_of_lt (show i - 5 < 2 ^ 64 by omega), show 2 * (i - 5) < 2 ^ 64 by omega,
    show (i - 5) * 2 = 2 * (i - 5) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 5]'hk5 = 0 ∧ w2[i - 5]'hk5 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb2 _ hk5)).2 h.2)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h2 : w2[i - 5]'hk5 = 0 := (ofInt16_eq_zero (hb2 _ hk5)).1 hbr
  have hs := hs.trans (start_pred hk5 (show i - 6 + 1 = i - 5 by omega) ⟨h1, h2⟩)
  clear h1 h2
  -- `n1slide[i - 6]`
  have hk6 : i - 6 < 256 := by omega
  block_init
  step_pure [saddOverflow_sub32 (c := 4294967290) (d := 6) rfl (by decide)
      (show i < 2 ^ 31 by omega),
    add_sub32 (c := 4294967290) (d := 6) rfl (show 6 ≤ i by omega) (show i < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show i - 6 < 2 ^ 31 by omega),
    setWidth_ofNat32 (show i - 6 < 2 ^ 32 by omega)]
  have hf := (hn1s (i - 6) hk6).1
  have hl := (hn1s (i - 6) hk6).2
  step_pure [Nat.mod_eq_of_lt (show i - 6 < 2 ^ 64 by omega), show 2 * (i - 6) < 2 ^ 64 by omega,
    show (i - 6) * 2 = 2 * (i - 6) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 6]'hk6 = 0 ∧ w2[i - 6]'hk6 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb1 _ hk6)).2 h.1)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h1 : w1[i - 6]'hk6 = 0 := (ofInt16_eq_zero (hb1 _ hk6)).1 hbr
  -- `n2slide[i - 6]`
  block_init
  have hf := (hn2s (i - 6) hk6).1
  have hl := (hn2s (i - 6) hk6).2
  step_pure [Nat.mod_eq_of_lt (show i - 6 < 2 ^ 64 by omega), show 2 * (i - 6) < 2 ^ 64 by omega,
    show (i - 6) * 2 = 2 * (i - 6) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 6]'hk6 = 0 ∧ w2[i - 6]'hk6 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb2 _ hk6)).2 h.2)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h2 : w2[i - 6]'hk6 = 0 := (ofInt16_eq_zero (hb2 _ hk6)).1 hbr
  have hs := hs.trans (start_pred hk6 (show i - 7 + 1 = i - 6 by omega) ⟨h1, h2⟩)
  clear h1 h2
  -- `n1slide[i - 7]`
  have hk7 : i - 7 < 256 := by omega
  block_init
  step_pure [saddOverflow_sub32 (c := 4294967289) (d := 7) rfl (by decide)
      (show i < 2 ^ 31 by omega),
    add_sub32 (c := 4294967289) (d := 7) rfl (show 7 ≤ i by omega) (show i < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show i - 7 < 2 ^ 31 by omega),
    setWidth_ofNat32 (show i - 7 < 2 ^ 32 by omega)]
  have hf := (hn1s (i - 7) hk7).1
  have hl := (hn1s (i - 7) hk7).2
  step_pure [Nat.mod_eq_of_lt (show i - 7 < 2 ^ 64 by omega), show 2 * (i - 7) < 2 ^ 64 by omega,
    show (i - 7) * 2 = 2 * (i - 7) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 7]'hk7 = 0 ∧ w2[i - 7]'hk7 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb1 _ hk7)).2 h.1)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h1 : w1[i - 7]'hk7 = 0 := (ofInt16_eq_zero (hb1 _ hk7)).1 hbr
  -- `n2slide[i - 7]`
  block_init
  have hf := (hn2s (i - 7) hk7).1
  have hl := (hn2s (i - 7) hk7).2
  step_pure [Nat.mod_eq_of_lt (show i - 7 < 2 ^ 64 by omega), show 2 * (i - 7) < 2 ^ 64 by omega,
    show (i - 7) * 2 = 2 * (i - 7) by omega]
  step_load consuming hf hl
  step_pure
  finish_block
  case isFalse =>
    have hnz : ¬(w1[i - 7]'hk7 = 0 ∧ w2[i - 7]'hk7 = 0) := fun h =>
      hbr ((ofInt16_eq_zero (hb2 _ hk7)).2 h.2)
    subst hS
    exact hfound _ _ (hs.trans (start_self _ hnz)) E hArgs (by env_reads) (by env_reads)
  have h2 : w2[i - 7]'hk7 = 0 := (ofInt16_eq_zero (hb2 _ hk7)).1 hbr
  -- `i == 7`: out, else around at `i - 8`
  block_init
  step_pure [saddOverflow_sub32 (c := 4294967288) (d := 8) rfl (by decide)
    (show i < 2 ^ 31 by omega)]
  step_pure
  finish_block
  case isTrue =>
    have h7 : i - 7 = 0 := eq_zero_of_ofNat32 (by omega) hbr
    have hz := hs.trans (start_zero hk7 h7 ⟨h1, h2⟩)
    subst hS
    exact hnone hz E hArgs (by env_reads)
  have hi8 : 8 ≤ i := by
    by_contra h
    exact hbr (by rw [show i - 7 = 0 by omega])
  subst hS
  refine hback hi8 (hs.trans (start_pred (by omega) (show i - 8 + 1 = i - 7 by omega) ⟨h1, h2⟩))
    E hArgs ⟨by env_reads, by env_reads⟩ ?_
  rw [← add_sub32 (c := 4294967288) (d := 8) rfl hi8 (by omega)]
  env_reads

/-- The zero-digit search from `^bb3` at `8 m + 7`: on to `^bb20` at `start`'s digit, or out
without one. -/
theorem skip_loop (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (w1 w2 : Vector Int 256)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (S : GlobalState) (hn1s : SlidesAt S.mem n1s w1) (hn2s : SlidesAt S.mem n2s w2)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m (hm : 8 * m + 7 < 256) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
        SkipRegs r tbl n1s n2s ai a2 tp tA tB E →
        (E ⊨ [%%396 := BitVec.ofNat 32 (8 * m + 7)]) →
        (∀ j (hj : j < 256),
          start w1 w2 (8 * m + 7) hm = some ⟨j, hj⟩ →
            ∀ E' : ⟪Γ⟫,
              E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
                PreRegs r tbl n1s n2s ai a2 tp tA tB E' →
                (E' ⊨ [%%462 := BitVec.ofNat 32 j]) → (runD E' ^bb20 S >>= g) = K) →
        (start w1 w2 (8 * m + 7) hm = none →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              PreRegs r tbl n1s n2s ai a2 tp tA tB E' → (runD E' ^bb33 S >>= g) = K) →
        (runD E ^bb3 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro hm E hArgs hR hRi hfound hnone
    exact
      skip_group r n1 a n2 tbl n1s n2s ai a2 tp tA tB w1 w2 hw1 hw2 hn1o hn2o g K 7 hm (by omega)
        S E hArgs hR hRi hn1s hn2s hfound hnone fun h8 => absurd h8 (by omega)
  | succ m ih =>
    intro hm E hArgs hR hRi hfound hnone
    refine
      skip_group r n1 a n2 tbl n1s n2s ai a2 tp tA tB w1 w2 hw1 hw2 hn1o hn2o g K _ hm (by omega)
        S E hArgs hR hRi hn1s hn2s hfound hnone fun _ hs E' h₁ h₂ h₃ => ?_
    have e : 8 * (m + 1) + 7 - 8 = 8 * m + 7 := by omega
    rw [e] at h₃
    have hs' : start w1 w2 (8 * (m + 1) + 7) hm = start w1 w2 (8 * m + 7) (by omega) := by
      rw [hs]
      congr 1
    exact
      ih (by omega) E' h₁ h₂ h₃ (fun j hj h => hfound j hj (hs'.trans h)) fun h =>
        hnone (hs'.trans h)

/-! ### Point copies -/

/-- `fd_ed25519_point_add_final_mul( q, t )` inlined: `t`'s three vectors (`t1`, `t2` its second
and third) loaded and stored at `q` (`q1`, `q2`). -/
def copyRun (t t1 t2 q q1 q2 : Reg Γ .ptr) (x03 x14 x25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.load x03 t, .store q (.val x03.i x03.h), .load x14 t1, .store q1 (.val x14.i x14.h),
    .load x25 t2, .store q2 (.val x25.i x25.h)]

/-- Where the body at `pos` is `copyRun` and `t`, `q` hold points in other blocks: running on from
`pos` then `g` gives `K` if it does from `pos + 6` with the point at `T` copied to `Q`. -/
theorem runBodyFrom_copyRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {t t1 t2 q q1 q2 : Reg Γ .ptr} {x03 x14 x25 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {T Q : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = copyRun t t1 t2 q q1 q2 x03 x14 x25 ++ rest)
    (ht : E.read t = .value T) (ht1 : E.read t1 = .value (T.add 64#64))
    (ht2 : E.read t2 = .value (T.add 128#64)) (hq : E.read q = .value Q)
    (hq1 : E.read q1 = .value (Q.add 64#64)) (hq2 : E.read q2 = .value (Q.add 128#64))
    (hwf : S.WF) (hT : S.mem.QuadFit T) (hQ : S.mem.QuadRoom Q) (hsep : Q.id ≠ T.id)
    (hK :
      ∀ v03 v14 v25 : ⟦.vec 8 64⟧,
        (blk.runBodyFrom E[x03 := v03, x14 := v14, x25 := v25] (pos + 6)
              { S with mem := S.mem.storeQuad Q (S.mem.readQuad T) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_load
  step_store
  step_load
  step_store
  step_load
  step_store
  rw [hE, hS]
  exact hK _ _ _

/-- `runBodyFrom_permuteRun` by `permPoisonMask imm s`: the lanes of `X.permute imm` where
`sj ≠ 0`, poison elsewhere. -/
theorem runBodyFrom_permuteRun_poison (i0 i1 i2 i3 s0 s1 s2 s3 : Nat) {blk : BasicBlock Γ tRets bp}
    {E : ⟪Γ⟫} {pos : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    {x03 x14 x25 pz r03 r14 r25 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)} {X03 X14 X25 : Wwl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = permuteRun m x03 x14 x25 pz r03 r14 r25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hm : m = permPoisonMask i0 i1 i2 i3 s0 s1 s2 s3)
    (hi : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4) (hd : [x03.i, x14.i, x25.i, r03.i, r14.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[r03 := selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X03),
              r14 := selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X14),
              r25 := selPoison s0 s1 s2 s3 (wwl_perm4 i0 i1 i2 i3 X25)] (pos + 3) S >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [shufflevector_permPoisonMask hm hi]
  step_pure [shufflevector_permPoisonMask hm hi]
  step_pure [shufflevector_permPoisonMask hm hi]
  rw [hE]
  exact hK

/-- `FD_R43X6_QUAD_PERMUTE( 0,1,2,3 )` is the identity. -/
theorem Quad.permute_0123 (X : Quad) : X.permute 0 1 2 3 = X := by
  rw [Quad.permute_eq_perm4 (by decide)]
  rcases X with ⟨a, b, c⟩
  simp only [Quad.perm4, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext k hk : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  all_goals
    first
    | omega
    | simp [wwl_perm4]

/-- `FD_R43X6_QUAD_MUL_FAST( _, X, Y )` from `quadMulCore` on `X`'s halves. -/
theorem quadMul_of_core' {X Y M : Quad}
    (h :
      quadMulCore (wwl_pack_halves (X.permute 0 1 2 3).P03 0 (X.permute 0 1 2 3).P03 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P14 0 (X.permute 0 1 2 3).P14 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P25 0 (X.permute 0 1 2 3).P25 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P03 1 (X.permute 0 1 2 3).P03 1)
          (wwl_pack_halves (X.permute 0 1 2 3).P14 1 (X.permute 0 1 2 3).P14 1)
          (wwl_pack_halves (X.permute 0 1 2 3).P25 1 (X.permute 0 1 2 3).P25 1) Y.P03 Y.P14 Y.P25 =
        M) :
    quadMul X Y = M := by
  rw [Quad.permute_0123] at h
  rw [quadMul_eq_core]
  exact h

/-- `fd_curve25519_into_precomputed` from its steps' equations. -/
theorem intoPre_of {X T2 T3 F M : Quad}
    (h2 : (X.permute 1 0 2 3).laneSubFast 1 0 0 0 (X.permute 1 0 2 3) X = T2)
    (h3 : T2.laneAddFast 0 1 0 0 T2 X = T3) (hF : T3.foldSigned = F)
    (hM : quadMul F quad1112d = M) :
    fd_curve25519_into_precomputed.spec X = M.foldUnsigned := by
  subst_vars
  rfl

/-! ### Negated table entries -/

/-- `PERMUTE( r, 1,0,2,3, r )` on one vector: lanes `0, 1` and `4, 5` swapped. -/
def swapXY (n : Wwl) : Wwl :=
  #v[n[1], n[0], n[2], n[3], n[5], n[4], n[6], n[7]]

/-- `fd_ed25519_point_neg_precomputed` as compiled: `T` replaced by `2p - T`, `X`, `Y` swapped. -/
def negPrecomputedC (A : Quad) : Quad :=
  ⟨swapXY
      #v[A.P03[0], A.P03[1], A.P03[2], 17592186044378#64 - A.P03[3], A.P03[4], A.P03[5], A.P03[6],
        17592186044414#64 - A.P03[7]],
    swapXY
      #v[A.P14[0], A.P14[1], A.P14[2], 17592186044414#64 - A.P14[3], A.P14[4], A.P14[5], A.P14[6],
        17592186044414#64 - A.P14[7]],
    swapXY
      #v[A.P25[0], A.P25[1], A.P25[2], 17592186044414#64 - A.P25[3], A.P25[4], A.P25[5], A.P25[6],
        2199023255550#64 - A.P25[7]]⟩

theorem p_add_p_sub (c x : BitVec 64) : c + (c - x) = (c + c) - x := by bv_decide

theorem neg_precomputed_spec_eq (A : Quad) :
    fd_ed25519_point_neg_precomputed.spec A = negPrecomputedC A := by
  rcases A with ⟨a, b, c⟩
  simp only [fd_ed25519_point_neg_precomputed.spec, Quad.permute, Quad.laneSubFast,
    Quad.laneAddFast, negPrecomputedC, swapXY, quadP, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext i hi : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      first
      | done
      | simp only [p_add_p_sub, BitVec.reduceAdd]

/-- `fd_ed25519_point_neg_precomputed( q, p )` inlined: `p`'s vectors loaded (`g1`, `g2` its
second and third), `p`'s limbs in `k03 k14 k25` less them, the lanes selected and stored at `q`
(`q1`, `q2`). -/
def negPreRun (p : Reg Γ .ptr) (x03 x14 x25 k03 k14 k25 d03 d14 d25 s03 s14 s25 : Dst Γ (.vec 8 64))
    (g1 g2 : Dst Γ .ptr) (q q1 q2 : Reg Γ .ptr) : List (Instr Γ) :=
  [.load x03 p, .unop (.gepConst { nusw := true, nuw := true } 64) g1 p,
    .load x14 (.val g1.i g1.h), .unop (.gepConst { nusw := true, nuw := true } 128) g2 p,
    .load x25 (.val g2.i g2.h),
    .binop (.vector (.sub {})) d03 (.val k03.i k03.h) (.val x03.i x03.h),
    .binop (.vector (.sub {})) d14 (.val k14.i k14.h) (.val x14.i x14.h),
    .binop (.vector (.sub {})) d25 (.val k25.i k25.h) (.val x25.i x25.h),
    .binop (.shufflevector #v[some 1, some 0, some 2, some 11, some 5, some 4, some 6, some 15]) s03
      (.val x03.i x03.h) (.val d03.i d03.h),
    .store q (.val s03.i s03.h),
    .binop (.shufflevector #v[some 1, some 0, some 2, some 11, some 5, some 4, some 6, some 15]) s14
      (.val x14.i x14.h) (.val d14.i d14.h),
    .store q1 (.val s14.i s14.h),
    .binop (.shufflevector #v[some 1, some 0, some 2, some 11, some 5, some 4, some 6, some 15]) s25
      (.val x25.i x25.h) (.val d25.i d25.h),
    .store q2 (.val s25.i s25.h)]

/-- Where the body at `pos` is `negPreRun`, `p` holds a point `P` and `q` room for one in another
block: running on from `pos` then `g` gives `K` if it does from `pos + 14` with `P` negated as a
precomputed point at `Q`. -/
theorem runBodyFrom_negPreRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p : Reg Γ .ptr} {x03 x14 x25 k03 k14 k25 d03 d14 d25 s03 s14 s25 : Dst Γ (.vec 8 64)}
    {g1 g2 : Dst Γ .ptr} {q q1 q2 : Reg Γ .ptr} {rest : List (Instr Γ)} {P Q : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        negPreRun p x03 x14 x25 k03 k14 k25 d03 d14 d25 s03 s14 s25 g1 g2 q q1 q2 ++ rest)
    (hk : E ⊨ [k03 := negK03, k14 := negK14, k25 := negK25]) (hp : E.read p = .value P)
    (hq : E.read q = .value Q) (hq1 : E.read q1 = .value (Q.add 64#64))
    (hq2 : E.read q2 = .value (Q.add 128#64)) (hpg : p ≠ .val g1.i g1.h)
    (hqg1 : q ≠ .val g1.i g1.h) (hqg2 : q ≠ .val g2.i g2.h) (hq1g1 : q1 ≠ .val g1.i g1.h)
    (hq1g2 : q1 ≠ .val g2.i g2.h) (hq2g1 : q2 ≠ .val g1.i g1.h) (hq2g2 : q2 ≠ .val g2.i g2.h)
    (hd :
      [x03.i, x14.i, x25.i, k03.i, k14.i, k25.i, d03.i, d14.i, d25.i, s03.i, s14.i, s25.i].Nodup)
    (hwf : S.WF) (hP : S.mem.QuadFit P) (hQ : S.mem.QuadRoom Q)
    (hK :
      ∀ (v03 v14 v25 vd03 vd14 vd25 vs03 vs14 vs25 : ⟦.vec 8 64⟧) (vg1 vg2 : ⟦.ptr⟧),
        (blk.runBodyFrom
              E[x03 := v03, g1 := vg1, x14 := v14, g2 := vg2, x25 := v25, d03 := vd03,
                d14 := vd14, d25 := vd25, s03 := vs03, s14 := vs14, s25 := vs25]
              (pos + 14)
              { S with
                mem :=
                  S.mem.storeQuad Q (fd_ed25519_point_neg_precomputed.spec (S.mem.readQuad P)) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  rw [neg_precomputed_spec_eq] at hK
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _

/-! ### Tables in memory -/

/-- `n` points `f 0, …, f (n - 1)` at `p`, 192 bytes apart. -/
def TableAt (m : MemoryState) (p : Pointer) (n : Nat) (f : Nat → Quad) : Prop :=
  ∀ k < n,
    m.QuadFit (p.add (BitVec.ofNat 64 (192 * k))) ∧
      m.readQuad (p.add (BitVec.ofNat 64 (192 * k))) = f k

/-- `n` points of a known read from `p`, 192 bytes apart. -/
theorem TableAt.of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v} (hf : Fits m p v)
    (h : m.readAt p v = x) (hp : p.offset.toNat + 192 * n < 2 ^ 64) (hv : 1536 * n = v) :
    TableAt m p n fun k => quadAt x (1536 * k) := fun k hk =>
  ⟨MemoryState.QuadFit.entry (hv ▸ hf) hp hk, by
    rw [MemoryState.readQuad_add_of_readAt hf h (by omega) (by omega),
      show 8 * (192 * k) = 1536 * k by omega]⟩

theorem TableAt.storeQuad {m : MemoryState} (h : TableAt m q n f) (hne : p.id ≠ q.id) :
    TableAt (m.storeQuad p P) q n f := fun k hk =>
  ⟨(h k hk).1.storeQuad, by
    rw [MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

theorem TableAt.storeAt {m : MemoryState} {x : BitVec w} (h : TableAt m q n f)
    (hne : p.id ≠ q.id) : TableAt (m.storeAt p x) q n f := fun k hk =>
  ⟨(h k hk).1.storeAt, by
    rw [MemoryState.readQuad_storeAt_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

theorem TableAt.lifetimeStart {m : MemoryState} (h : TableAt m q n f) (hne : q.id ≠ p.id) :
    TableAt (m.lifetimeStart p) q n f := fun k hk =>
  ⟨(h k hk).1.lifetimeStart (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readQuad_lifetimeStart]
    exact (h k hk).2⟩

theorem TableAt.lifetimeEnd {m : MemoryState} (h : TableAt m q n f) (hne : q.id ≠ p.id) :
    TableAt (m.lifetimeEnd p) q n f := fun k hk =>
  ⟨(h k hk).1.lifetimeEnd (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readQuad_lifetimeEnd]
    exact (h k hk).2⟩

theorem slidesAt_storeQuad {m : MemoryState} (h : SlidesAt m q w) (hne : p.id ≠ q.id) :
    SlidesAt (m.storeQuad p P) q w := fun k hk =>
  ⟨Fits.storeQuad (h k hk).1, by
    rw [MemoryState.readAt_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

theorem slidesAt_storeAt {m : MemoryState} {x : BitVec v} (h : SlidesAt m q w)
    (hne : p.id ≠ q.id) : SlidesAt (m.storeAt p x) q w := fun k hk =>
  ⟨(h k hk).1.storeAt, by
    rw [MemoryState.readAt_storeAt_disjoint (Or.inl (by simpa [Range.of, Pointer.add] using hne))]
    exact (h k hk).2⟩

theorem slidesAt_lifetimeStart {m : MemoryState} (h : SlidesAt m q w) (hne : q.id ≠ p.id) :
    SlidesAt (m.lifetimeStart p) q w := fun k hk =>
  ⟨(h k hk).1.lifetimeStart (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readAt_lifetimeStart]
    exact (h k hk).2⟩

theorem slidesAt_lifetimeEnd {m : MemoryState} (h : SlidesAt m q w) (hne : q.id ≠ p.id) :
    SlidesAt (m.lifetimeEnd p) q w := fun k hk =>
  ⟨(h k hk).1.lifetimeEnd (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readAt_lifetimeEnd]
    exact (h k hk).2⟩

attribute [local mlir_transport] TableAt.storeQuad TableAt.storeAt TableAt.lifetimeStart
  TableAt.lifetimeEnd slidesAt_storeQuad slidesAt_storeAt slidesAt_lifetimeStart
  slidesAt_lifetimeEnd

/-! ### The main loop -/

/-- The main loop's objects: blocks apart, offsets that do not wrap, the frame's slots from
`N` on. -/
structure Layout (N : Nat) (r tp n1s n2s ai tbl tA tB : Pointer) : Prop where
  rt : r.id ≠ tp.id
  r1 : r.id ≠ n1s.id
  r2 : r.id ≠ n2s.id
  ra : r.id ≠ ai.id
  rb : r.id ≠ tbl.id
  rA : r.id ≠ tA.id
  rB : r.id ≠ tB.id
  t1 : tp.id ≠ n1s.id
  t2 : tp.id ≠ n2s.id
  ta : tp.id ≠ ai.id
  tb : tp.id ≠ tbl.id
  tpA : tp.id ≠ tA.id
  tpB : tp.id ≠ tB.id
  A1 : tA.id ≠ n1s.id
  A2 : tA.id ≠ n2s.id
  Aa : tA.id ≠ ai.id
  Ab : tA.id ≠ tbl.id
  B1 : tB.id ≠ n1s.id
  B2 : tB.id ≠ n2s.id
  Ba : tB.id ≠ ai.id
  Bb : tB.id ≠ tbl.id
  n1o : n1s.offset.toNat + 512 < 2 ^ 64
  n2o : n2s.offset.toNat + 512 < 2 ^ 64
  aio : ai.offset.toNat + 192 * 8 < 2 ^ 64
  tbo : tbl.offset.toNat + 192 * 128 < 2 ^ 64
  Ao : tA.offset = 0
  Bo : tB.offset = 0
  Nt : N ≤ tp.id.id
  NA : N ≤ tA.id.id
  NB : N ≤ tB.id.id

/-- What the main loop needs of a state: `r` and `t` known and writable, the negations' slots in
bounds and writable, the slides and tables in place. -/
structure LoopFacts (S : GlobalState) (r tp n1s n2s ai tbl tA tB : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → Quad) : Prop where
  wf : S.WF
  fitR : S.mem.QuadFit r
  wrR : Writable S.mem r
  fitT : S.mem.QuadFit tp
  wrT : Writable S.mem tp
  bA : InBounds S.mem tA 1536
  wA : Writable S.mem tA
  bB : InBounds S.mem tB 1536
  wB : Writable S.mem tB
  slides1 : SlidesAt S.mem n1s w1
  slides2 : SlidesAt S.mem n2s w2
  tblA : TableAt S.mem ai 8 AI
  tblB : TableAt S.mem tbl 128 B

/-- The registers the main loop reads, `i` aside. -/
abbrev MainRegs (r tbl n1s n2s ai a2 tp tA tB : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1 := 18446744073709551615#64, %2 := tbl, %6 := 1#16, %14 := 0#16, %27 := 0#64,
    %43 := 1#32, %92 := negK03, %100 := negK14, %108 := negK25, %109 := tB, %110 := tA,
    %111 := n1s, %112 := n2s, %113 := ai, %114 := a2, %115 := tp, %%253 := tp.add 64#64,
    %%254 := tp.add 128#64, %%255 := r.add 64#64, %%464 := r.add 128#64,
    %%465 := tA.add 64#64, %%466 := tA.add 128#64, %%467 := tB.add 64#64,
    %%468 := tB.add 128#64]

/-- `^bb22`, an iteration's start at `i`: `t = partial_dbl( r )`, then `n1slide[i]`'s add; on to
`^bb26`. -/
theorem head_block (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (N : Nat)
    (w1 w2 : Vector Int 256) (AI B : Nat → Quad) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (hw : -15 ≤ w1[i] ∧ w1[i] ≤ 15) (R : Quad)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : MainRegs r tbl n1s n2s ai a2 tp tA tB E) (hRi : E ⊨ [%%470 := BitVec.ofNat 64 i])
    (hL : Layout N r tp n1s n2s ai tbl tA tB)
    (hF : LoopFacts S r tp n1s n2s ai tbl tA tB w1 w2 AI B)
    (hrv : S.mem.readQuad r = R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
          MainRegs r tbl n1s n2s ai a2 tp tA tB E' →
          (E' ⊨ [%%470 := BitVec.ofNat 64 i]) →
          LoopFacts S' r tp n1s n2s ai tbl tA tB w1 w2 AI B →
          S'.alloc = S.alloc →
          S'.mem.readQuad r = (add1 AI w1[i] R).1 →
          S'.mem.readQuad tp = (add1 AI w1[i] R).2 →
          S'.mem.eraseFrom N = (S.mem.storeQuad r (add1 AI w1[i] R).1).eraseFrom N →
          (runD E' ^bb26 S' >>= g) = K) :
    (runD E ^bb22 S >>= g) = K := by
  obtain ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ := hF
  obtain ⟨hrt, hr1, hr2, hra, hrb, hrA, hrB, ht1, ht2, hta, htb, htA, htB, hA1, hA2, hAa, hAb', hB1,
    hB2, hBa, hBb', hn1o, hn2o, haio, htbo, hAo, hBo, hNt, hNA, hNB⟩ := hL
  have hf1 := (hn1s i hi).1
  have hl1 := (hn1s i hi).2
  have htR := ht.room htw
  have e0 : S.mem.storeQuad r R = S.mem := MemoryState.storeQuad_readQuad_self' hr hrv
  block_init
  -- t = fd_ed25519_partial_dbl( r )
  step_call using fd_ed25519_partial_dbl.call_eq
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load with transparent d consuming hf1 hl1
  step_pure
  finish_block
  case isTrue =>
    have hpos : 0 < w1[i] := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    obtain ⟨k, hk⟩ : ∃ k, (w1[i] / 2).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 8 := by omega
    have hAf := (hai k hk8).1
    have hAr := (hai k hk8).2
    block_init
    -- fd_ed25519_point_add_final_mul( r, t )
    step_pattern using runBodyFrom_copyRun
    -- fd_ed25519_point_add_with_opts( t, r, &ai[ n1slide[i] / 2 ], 1 )
    step_pure
    step_pure with idx
    have hidx : idx.toNat = k := by rw [hidx, idx_pos (by omega), hk]
    step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega]
    step_call using fd_ed25519_point_add_with_opts.call_eq
    finish_block
    refine hK E S hArgs (by env_reads) (by env_reads)
      ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ (by rw [hS]) ?_ ?_ ?_
    · simpa [add1, addDigit, hpos] using hread_r
    · simpa [add1, addDigit, hpos, hk] using hread_tp
    · rw [hS]
      simp only [add1, addDigit, hpos, ite_true]
      erase_eq
  case isFalse =>
    have hnpos : w1[i] ≤ 0 := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      have hneg : w1[i] < 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simpa using hbr
      obtain ⟨k, hk⟩ : ∃ k, (-w1[i] / 2).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 8 := by omega
      have hAf := (hai k hk8).1
      have hAr := (hai k hk8).2
      block_init
      -- fd_ed25519_point_add_final_mul( r, t )
      step_pattern using runBodyFrom_copyRun
      -- fd_ed25519_point_sub_with_opts( t, r, &ai[ (-n1slide[i]) / 2 ], 1 ): the entry negated
      -- into a temporary, then added
      step_pure
      step_pure
      step_pure with idx
      have hidx : idx.toNat = k := by rw [hidx, idx_neg (by omega), hk]
      step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega]
      step_pure
      have hAq := MemoryState.QuadRoom.of_room hroom_tA hAo
      step_pattern using runBodyFrom_negPreRun
      step_call using fd_ed25519_point_add_with_opts.call_eq
      step_pure
      finish_block
      refine hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ (by rw [hS]) ?_ ?_ ?_
      · simpa [add1, addDigit, show ¬0 < w1[i] by omega, hneg] using hread_r
      · simpa [add1, addDigit, show ¬0 < w1[i] by omega, hneg, hk,
          fd_ed25519_point_sub_with_opts.spec] using hread_tp
      · rw [hS]
        simp only [add1, addDigit, show ¬0 < w1[i] by omega, hneg, ite_true, ite_false]
        erase_eq
    case isFalse =>
      have h0 : w1[i] = 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simp at hbr
        omega
      refine hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ (by rw [hS]) ?_ ?_ ?_
      · simpa [add1, addDigit, h0] using hrv
      · simpa [add1, addDigit, h0] using hread_tp
      · rw [hS]
        simp only [add1, addDigit, h0, lt_irrefl, ite_false]
        rw [e0]
        erase_eq

/-- `^bb26`: `n2slide[i]`'s add; on to `^bb30`. -/
theorem digit2_block (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (N : Nat)
    (w1 w2 : Vector Int 256) (AI B : Nat → Quad) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (hw : -255 ≤ w2[i] ∧ w2[i] ≤ 255) (R T : Quad)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : MainRegs r tbl n1s n2s ai a2 tp tA tB E) (hRi : E ⊨ [%%470 := BitVec.ofNat 64 i])
    (hL : Layout N r tp n1s n2s ai tbl tA tB)
    (hF : LoopFacts S r tp n1s n2s ai tbl tA tB w1 w2 AI B)
    (hrv : S.mem.readQuad r = R) (htv : S.mem.readQuad tp = T)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
          MainRegs r tbl n1s n2s ai a2 tp tA tB E' →
          (E' ⊨ [%%470 := BitVec.ofNat 64 i]) →
          LoopFacts S' r tp n1s n2s ai tbl tA tB w1 w2 AI B →
          S'.alloc = S.alloc →
          S'.mem.readQuad r = (addDigit B w2[i] R T).1 →
          S'.mem.readQuad tp = (addDigit B w2[i] R T).2 →
          S'.mem.eraseFrom N = (S.mem.storeQuad r (addDigit B w2[i] R T).1).eraseFrom N →
          (runD E' ^bb30 S' >>= g) = K) :
    (runD E ^bb26 S >>= g) = K := by
  obtain ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ := hF
  obtain ⟨hrt, hr1, hr2, hra, hrb, hrA, hrB, ht1, ht2, hta, htb, htA, htB, hA1, hA2, hAa, hAb', hB1,
    hB2, hBa, hBb', hn1o, hn2o, haio, htbo, hAo, hBo, hNt, hNA, hNB⟩ := hL
  have hf2 := (hn2s i hi).1
  have hl2 := (hn2s i hi).2
  have e0 : S.mem.storeQuad r R = S.mem := MemoryState.storeQuad_readQuad_self' hr hrv
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load with transparent d consuming hf2 hl2
  step_pure
  finish_block
  case isTrue =>
    have hpos : 0 < w2[i] := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    obtain ⟨k, hk⟩ : ∃ k, (w2[i] / 2).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 128 := by omega
    have hBf := (htbl k hk8).1
    have hBr := (htbl k hk8).2
    block_init
    -- fd_ed25519_point_add_final_mul( r, t )
    step_pattern using runBodyFrom_copyRun
    -- fd_ed25519_point_add_with_opts( t, r, &fd_ed25519_base_point_wnaf_table[ n2slide[i] / 2 ],
    -- 1 )
    step_pure
    step_pure with idx
    have hidx : idx.toNat = k := by rw [hidx, idx_pos (by omega), hk]
    step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega]
    step_call using fd_ed25519_point_add_with_opts.call_eq
    finish_block
    refine hK E S hArgs (by env_reads) (by env_reads)
      ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ (by rw [hS]) ?_ ?_ ?_
    · simpa [addDigit, hpos] using hread_r
    · simpa [addDigit, hpos, hk] using hread_tp
    · rw [hS]
      simp only [addDigit, hpos, ite_true]
      erase_eq
  case isFalse =>
    have hnpos : ¬0 < w2[i] := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      have hneg : w2[i] < 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simpa using hbr
      obtain ⟨k, hk⟩ : ∃ k, (-w2[i] / 2).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 128 := by omega
      have hBf := (htbl k hk8).1
      have hBr := (htbl k hk8).2
      block_init
      -- fd_ed25519_point_add_final_mul( r, t )
      step_pattern using runBodyFrom_copyRun
      -- fd_ed25519_point_sub_with_opts( t, r,
      -- &fd_ed25519_base_point_wnaf_table[ (-n2slide[i]) / 2 ], 1 ): the entry negated into a
      -- temporary, then added
      step_pure
      step_pure
      step_pure with idx
      have hidx : idx.toNat = k := by rw [hidx, idx_neg (by omega), hk]
      step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega]
      step_pure
      have hBq := MemoryState.QuadRoom.of_room hroom_tB hBo
      step_pattern using runBodyFrom_negPreRun
      step_call using fd_ed25519_point_add_with_opts.call_eq
      step_pure
      finish_block
      refine hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ (by rw [hS]) ?_ ?_ ?_
      · simpa [addDigit, hnpos, hneg] using hread_r
      · simpa [addDigit, hnpos, hneg, hk, fd_ed25519_point_sub_with_opts.spec] using hread_tp
      · rw [hS]
        simp only [addDigit, hnpos, hneg, ite_true, ite_false]
        erase_eq
    case isFalse =>
      have h0 : w2[i] = 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simp at hbr
        omega
      refine hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ (by rw [hS]) ?_ ?_ ?_
      · simpa [addDigit, h0] using hrv
      · simpa [addDigit, h0] using htv
      · rw [hS]
        simp only [addDigit, h0, lt_irrefl, ite_false]
        rw [e0]

/-- `^bb30`: `r` a copy of `t`; then out at `i == 0`, else around at `i - 1`. -/
theorem tail_block (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (N : Nat)
    (w1 w2 : Vector Int 256) (AI B : Nat → Quad) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (T : Quad) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : MainRegs r tbl n1s n2s ai a2 tp tA tB E) (hRi : E ⊨ [%%470 := BitVec.ofNat 64 i])
    (hL : Layout N r tp n1s n2s ai tbl tA tB)
    (hF : LoopFacts S r tp n1s n2s ai tbl tA tB w1 w2 AI B)
    (htv : S.mem.readQuad tp = T)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            MainRegs r tbl n1s n2s ai a2 tp tA tB E' →
            LoopFacts S' r tp n1s n2s ai tbl tA tB w1 w2 AI B →
            S'.alloc = S.alloc →
            S'.mem.readQuad r = T →
            S'.mem.eraseFrom N = (S.mem.storeQuad r T).eraseFrom N →
            (runD E' ^bb33 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              MainRegs r tbl n1s n2s ai a2 tp tA tB E' →
              (E' ⊨ [%%470 := BitVec.ofNat 64 j]) →
              LoopFacts S' r tp n1s n2s ai tbl tA tB w1 w2 AI B →
              S'.alloc = S.alloc →
              S'.mem.readQuad r = T →
              S'.mem.eraseFrom N = (S.mem.storeQuad r T).eraseFrom N →
              (runD E' ^bb22 S' >>= g) = K) :
    (runD E ^bb30 S >>= g) = K := by
  obtain ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ := hF
  obtain ⟨hrt, hr1, hr2, hra, hrb, hrA, hrB, ht1, ht2, hta, htb, htA, htB, hA1, hA2, hAa, hAb', hB1,
    hB2, hBa, hBb', hn1o, hn2o, haio, htbo, hAo, hBo, hNt, hNA, hNB⟩ := hL
  block_init
  step_pure
  finish_block
  case isTrue =>
    have hi0 : i = 0 := eq_zero_of_ofNat64 (by omega) hbr
    block_init
    -- fd_ed25519_point_add_final_mul( r, t )
    step_pattern using runBodyFrom_copyRun
    finish_block
    refine hexit hi0 E S hArgs (by env_reads)
      ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ (by rw [hS]) hread_r ?_
    rw [hS]
  case isFalse =>
    have hi0 : 1 ≤ i := Nat.one_le_iff_ne_zero.mpr fun h => hbr (by rw [h])
    block_init
    -- fd_ed25519_point_add_final_mul_projective( r, t )
    step_pattern using runBodyFrom_copyRun
    step_pure [saddOverflow_neg_one64 hi0 (by omega), add_neg_one64 hi0 (by omega)]
    step_pure [slt_ofNat64 hi0 (by omega)]
    finish_block
    refine hback (i - 1) (by omega) E S hArgs (by env_reads) (by env_reads)
      ⟨hwf, hr, hrw, ht, htw, hAb, hAw, hBb, hBw, hn1s, hn2s, hai, htbl⟩ (by rw [hS]) hread_r ?_
    rw [hS]

/-- Two erased frames' equations, the second over the first's state: `r`'s last store. -/
theorem erase_trans {m m₁ m₂ : MemoryState} {r : Pointer} {N : Nat}
    (h₁ : m₁.eraseFrom N = (m.storeQuad r X).eraseFrom N)
    (h₂ : m₂.eraseFrom N = (m₁.storeQuad r Y).eraseFrom N) (hr : r.offset.toNat + 192 ≤ 2 ^ 64) :
    m₂.eraseFrom N = (m.storeQuad r Y).eraseFrom N := by
  rw [h₂, MemoryState.eraseFrom_storeQuad, h₁, ← MemoryState.eraseFrom_storeQuad,
    MemoryState.storeQuad_storeQuad_self hr]

/-- An iteration of the main loop at `i`: `t` and `r` by the adds, then `r` a copy of `t`. -/
theorem main_iter (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (N : Nat)
    (w1 w2 : Vector Int 256) (AI B : Nat → Quad) (hL : Layout N r tp n1s n2s ai tbl tA tB)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (R : Quad) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : MainRegs r tbl n1s n2s ai a2 tp tA tB E) (hRi : E ⊨ [%%470 := BitVec.ofNat 64 i])
    (hF : LoopFacts S r tp n1s n2s ai tbl tA tB w1 w2 AI B) (hrv : S.mem.readQuad r = R)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            MainRegs r tbl n1s n2s ai a2 tp tA tB E' →
            LoopFacts S' r tp n1s n2s ai tbl tA tB w1 w2 AI B →
            S'.alloc = S.alloc →
            S'.mem.readQuad r = (adds AI B w1[i] w2[i] R).2 →
            S'.mem.eraseFrom N = (S.mem.storeQuad r (adds AI B w1[i] w2[i] R).2).eraseFrom N →
            (runD E' ^bb33 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              MainRegs r tbl n1s n2s ai a2 tp tA tB E' →
              (E' ⊨ [%%470 := BitVec.ofNat 64 j]) →
              LoopFacts S' r tp n1s n2s ai tbl tA tB w1 w2 AI B →
              S'.alloc = S.alloc →
              S'.mem.readQuad r = (adds AI B w1[i] w2[i] R).2 →
              S'.mem.eraseFrom N = (S.mem.storeQuad r (adds AI B w1[i] w2[i] R).2).eraseFrom N →
              (runD E' ^bb22 S' >>= g) = K) :
    (runD E ^bb22 S >>= g) = K := by
  have hro := hF.fitR.1
  refine
    head_block r n1 a n2 tbl n1s n2s ai a2 tp tA tB N w1 w2 AI B g K i hi (hw1 i hi) R S E hArgs hR
      hRi hL hF hrv fun E₁ S₁ h₁ hR₁ hRi₁ hF₁ ha₁ hr₁ ht₁ he₁ => ?_
  refine
    digit2_block r n1 a n2 tbl n1s n2s ai a2 tp tA tB N w1 w2 AI B g K i hi (hw2 i hi) _ _ S₁ E₁
      h₁ hR₁ hRi₁ hL hF₁ hr₁ ht₁ fun E₂ S₂ h₂ hR₂ hRi₂ hF₂ ha₂ hr₂ ht₂ he₂ => ?_
  refine
    tail_block r n1 a n2 tbl n1s n2s ai a2 tp tA tB N w1 w2 AI B g K i hi _ S₂ E₂ h₂ hR₂ hRi₂ hL
      hF₂ ht₂ (fun h0 E₃ S₃ h₃ hR₃ hF₃ ha₃ hr₃ he₃ => ?_)
      fun j hj E₃ S₃ h₃ hR₃ hRi₃ hF₃ ha₃ hr₃ he₃ => ?_
  · exact
      hexit h0 E₃ S₃ h₃ hR₃ hF₃ (ha₃.trans (ha₂.trans ha₁)) hr₃
        (erase_trans (erase_trans he₁ he₂ hro) he₃ hro)
  · exact
      hback j hj E₃ S₃ h₃ hR₃ hRi₃ hF₃ (ha₃.trans (ha₂.trans ha₁)) hr₃
        (erase_trans (erase_trans he₁ he₂ hro) he₃ hro)

/-- The main loop from `^bb22` at `i`: `r` the ladder from `i` down. -/
theorem main_loop (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (N : Nat)
    (w1 w2 : Vector Int 256) (AI B : Nat → Quad) (hL : Layout N r tp n1s n2s ai tbl tA tB)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (hi : i < 256) (R : Quad) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
        MainRegs r tbl n1s n2s ai a2 tp tA tB E →
        (E ⊨ [%%470 := BitVec.ofNat 64 i]) →
        LoopFacts S r tp n1s n2s ai tbl tA tB w1 w2 AI B →
        S.mem.readQuad r = R →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            MainRegs r tbl n1s n2s ai a2 tp tA tB E' →
            LoopFacts S' r tp n1s n2s ai tbl tA tB w1 w2 AI B →
            S'.alloc = S.alloc →
            S'.mem.readQuad r = ladder AI B w1 w2 i hi R →
            S'.mem.eraseFrom N = (S.mem.storeQuad r (ladder AI B w1 w2 i hi R)).eraseFrom N →
            (runD E' ^bb33 S' >>= g) = K) →
        (runD E ^bb22 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi R S E hArgs hR hRi hF hrv hK
    exact
      main_iter r n1 a n2 tbl n1s n2s ai a2 tp tA tB N w1 w2 AI B hL hw1 hw2 g K 0 hi R S E hArgs
        hR hRi hF hrv (fun _ => hK) fun j hj => absurd hj (by omega)
  | succ j ih =>
    intro hi R S E hArgs hR hRi hF hrv hK
    refine
      main_iter r n1 a n2 tbl n1s n2s ai a2 tp tA tB N w1 w2 AI B hL hw1 hw2 g K (j + 1) hi R S E
        hArgs hR hRi hF hrv (fun h => absurd h (by omega))
        fun j' hj E' S' h₁ hR' hRi' hF' ha' hr' he' => ?_
    obtain rfl : j = j' := by omega
    exact
      ih (by omega) _ S' E' h₁ hR' hRi' hF' hr' fun E'' S'' h₂ hR'' hF'' ha'' hr'' he'' =>
        hK E'' S'' h₂ hR'' hF'' (ha''.trans ha') hr'' (erase_trans he' he'' hF.fitR.1)

/-! ### The table loop -/

/-- `CommonRegs`, `SkipConsts` and the constants of the table loop and of
`fd_ed25519_point_set_zero`: the folds', products' and lane operations'
(`fd_curve25519_into_precomputed` inlined), the counter's. -/
abbrev TableRegs (tbl n1s n2s ai a2 tp tA tB : Pointer) (E : ⟪Γ⟫) : Prop :=
  (CommonRegs tbl n1s n2s ai a2 tp tA tB E ∧ SkipConsts E) ∧
    E ⊨ [%15 := 255#32, %16 := 0#8, %17 := #v[0#64, 1#64, 1#64, 0#64, 0#64, 0#64, 0#64, 0#64],
      %18 := 8#64, %19 := 1#64, %20 := Vector.replicate 8 24#64, %21 := Vector.replicate 8 7#64,
      %22 := Vector.replicate 8 9#64,
      %23 := #v[0#64, 0#64, 0#64, 15037786634#64, 0#64, 0#64, 0#64, 309467527341#64],
      %24 := #v[0#64, 0#64, 0#64, 507525298899#64, 0#64, 0#64, 0#64, 6596238350568#64],
      %25 := #v[1#64, 1#64, 1#64, 3934839304537#64, 0#64, 0#64, 0#64, 521695520920#64],
      %26 := Vector.replicate 8 0#64, %28 := m4340, %29 := Vector.replicate 8 1048576#64,
      %30 := bias03, %31 := Vector.replicate 8 8796093022207#64, %33 := s4340,
      %34 := Vector.replicate 8 43#64, %35 := Vector.replicate 8 18446744073708503040#64,
      %36 := negBias03, %46 := 128#64, %47 := (Vector.replicate 8 .poison : ⟦.vec 8 64⟧),
      %60 :=
      (#v[.value 8796093022189#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
        .poison, .poison] : ⟦.vec 8 64⟧),
      %68 :=
      (#v[.value 8796093022207#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
        .poison, .poison] : ⟦.vec 8 64⟧),
      %76 :=
      (#v[.value 8796093022207#64, .poison, .poison, .poison, .value 1099511627775#64, .poison,
        .poison, .poison] : ⟦.vec 8 64⟧),
      %84 := k19Lanes]

/-- One table-loop iteration's effect at `i`: `t = a2 + ai[i-1]`, then `ai[i]` from it. -/
abbrev tableStep (tp ai : Pointer) (A2 P : Quad) (i : Nat) (S : GlobalState) : GlobalState :=
  let t := fd_ed25519_point_add_with_opts.spec A2 P 1#32
  { S with
    mem :=
      (S.mem.storeQuad tp t).storeQuad (ai.add (BitVec.ofNat 64 (192 * i)))
        (fd_curve25519_into_precomputed.spec t) }

set_option maxHeartbeats 1000000 in
-- one walk through `fd_ed25519_point_add_with_opts` and the inlined
-- `fd_curve25519_into_precomputed`, 140 instructions
/-- `^bb2`, the table loop at `i`: `t = a2 + ai[i-1]`, `ai[i]` from it; then around or on to
`^bb1`. -/
theorem table_iter (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (A2 P : Quad)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi1 : 1 ≤ i)
    (hi : i < 8) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : TableRegs tbl n1s n2s ai a2 tp tA tB E) (hRi : E ⊨ [%%256 := BitVec.ofNat 64 i])
    (hwf : S.WF) (ha2 : S.mem.QuadFit a2) (htp : S.mem.QuadRoom tp)
    (hP : S.mem.QuadFit (ai.add (BitVec.ofNat 64 (192 * (i - 1)))))
    (hQ : S.mem.QuadRoom (ai.add (BitVec.ofNat 64 (192 * i)))) (hao : ai.offset = 0)
    (ha2v : S.mem.readQuad a2 = A2)
    (hPv : S.mem.readQuad (ai.add (BitVec.ofNat 64 (192 * (i - 1)))) = P)
    (hexit :
      i + 1 = 8 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            TableRegs tbl n1s n2s ai a2 tp tA tB E' →
            S' = tableStep tp ai A2 P i S →
            (runD E' ^bb1 S' >>= g) = K)
    (hback :
      i + 1 < 8 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            TableRegs tbl n1s n2s ai a2 tp tA tB E' →
            (E' ⊨ [%%256 := BitVec.ofNat 64 (i + 1)]) →
            S' = tableStep tp ai A2 P i S →
            (runD E' ^bb2 S' >>= g) = K) :
    (runD E ^bb2 S >>= g) = K := by
  obtain ⟨⟨hP1, hC1⟩, hC2⟩ := hR
  dsimp only [CommonRegs] at hP1
  have hQo : ¬(ai.add (BitVec.ofNat 64 (192 * i))).offset.uaddOverflow 128#64 := by
    have h192 : (BitVec.ofNat 64 (192 * i)).toNat = 192 * i := by
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    have ho : (ai.add (BitVec.ofNat 64 (192 * i))).offset.toNat = 192 * i := by
      simp [Pointer.add, hao, h192]
    simp only [BitVec.uaddOverflow, ho]
    simp
    omega
  -- `ai[i]`, kept apart from its vectors' offsets
  obtain ⟨Q, hQe⟩ : ∃ Q, ai.add (BitVec.ofNat 64 (192 * i)) = Q := ⟨_, rfl⟩
  rw [hQe] at hQ hQo
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), Nat.mul_comm i 192,
    show 192 * i < 2 ^ 64 by omega, hQe]
  step_pure [← hQe, off_prev (c := 18446744073709551424) rfl hi1 (show 192 * i < 2 ^ 64 by omega)]
  -- fd_ed25519_point_add_with_opts( t, a2, &ai[i-1], 1 )
  step_call using fd_ed25519_point_add_with_opts.call_eq
  -- fd_ed25519_point_add_final_mul( &ai[i], t ); fd_curve25519_into_precomputed( &ai[i] ): `t`
  -- loaded, the copy fused away
  step_load with t03
  step_load with t14
  step_pure
  step_load with t25
  step_pure
  have et : (⟨t03, t14, t25⟩ : Quad) = fd_ed25519_point_add_with_opts.spec A2 P 1#32 := by
    rw [← hread_tp, hS, ht03, ht14, ht25]
    rfl
  step_pattern using runBodyFrom_permuteRun_poison 1 0 2 3 1 0 0 0
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
  have e2 := _hl
  step_pattern using runBodyFrom_laneAddRun 0 1 0 0
  have e3 := _hl
  step_pattern using runBodyFrom_foldSignedRun
  have eF := (Quad.foldSigned_eq _).trans _hs
  step_pattern using runBodyFrom_halvesRun 0 1 2 3 inline
  step_pattern using runBodyFrom_quadMulCoreRun
  have e4 := quadMul_of_core' (Y := quad1112d) _hm
  step_pattern using runBodyFrom_foldUnsignedStoreRun'
  have eU := (Quad.foldUnsigned_eq _).trans _hu
  step_pure [saddOverflow_one64 (show i + 1 < 2 ^ 63 by omega),
    uaddOverflow_one64 (show i + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure
  finish_block
  all_goals
    have eT : fd_curve25519_into_precomputed.spec (fd_ed25519_point_add_with_opts.spec A2 P 1#32) =
        ⟨u03, u14, u25⟩ := by
      rw [← et]
      exact (intoPre_of e2 e3 eF e4).trans eU
  case isTrue =>
    have h8 : i + 1 = 8 := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    refine hexit h8 E S hArgs ⟨⟨by env_reads, by env_reads⟩, by env_reads⟩ ?_
    rw [hS, tableStep, eT, hQe]
    rfl
  case isFalse =>
    have h8 : i + 1 < 8 := by
      by_contra h
      exact hbr (by rw [show i + 1 = 8 by omega])
    refine hback h8 E S hArgs ⟨⟨by env_reads, by env_reads⟩, by env_reads⟩ (by env_reads) ?_
    rw [hS, tableStep, eT, hQe]
    rfl

/-- The table loop's objects: `t` and `ai` apart from what they must not touch. -/
structure TableLayout (tp n1s n2s ai tbl a2 : Pointer) : Prop where
  ta : tp.id ≠ ai.id
  ta2 : tp.id ≠ a2.id
  aa2 : ai.id ≠ a2.id
  t1 : tp.id ≠ n1s.id
  a1 : ai.id ≠ n1s.id
  t2 : tp.id ≠ n2s.id
  a2' : ai.id ≠ n2s.id
  tb : tp.id ≠ tbl.id
  ab : ai.id ≠ tbl.id
  aio : ai.offset = 0

/-- What the table loop needs of a state at `i`: `ai[0 … i-1]` in place, `a2` holding `A2`, and the
main loop's other facts. -/
structure TableFacts (S : GlobalState) (r tp n1s n2s ai tbl a2 tA tB : Pointer)
    (w1 w2 : Vector Int 256) (AI B : Nat → Quad) (A2 : Quad) (i : Nat) : Prop where
  wf : S.WF
  roomR : S.mem.QuadRoom r
  roomT : S.mem.QuadRoom tp
  fitA2 : S.mem.QuadFit a2
  roomAI : Room S.mem ai (1536 * 8)
  bA : InBounds S.mem tA 1536
  wA : Writable S.mem tA
  bB : InBounds S.mem tB 1536
  wB : Writable S.mem tB
  a2v : S.mem.readQuad a2 = A2
  slides1 : SlidesAt S.mem n1s w1
  slides2 : SlidesAt S.mem n2s w2
  tblA : TableAt S.mem ai i AI
  tblB : TableAt S.mem tbl 128 B

/-- `TableFacts` after an iteration: entry `i` stored. -/
theorem TableFacts.step {S : GlobalState}
    (h : TableFacts S r tp n1s n2s ai tbl a2 tA tB w1 w2 (aiTable A2 AI0) B A2 i)
    (hL : TableLayout tp n1s n2s ai tbl a2) (hi1 : 1 ≤ i) (hi : i < 8) :
    TableFacts (tableStep tp ai A2 (aiTable A2 AI0 (i - 1)) i S) r tp n1s n2s ai tbl a2 tA tB w1 w2
      (aiTable A2 AI0) B A2 (i + 1)
    where
  wf := h.wf.storeQuad.storeQuad
  roomR := h.roomR.storeQuad.storeQuad
  roomT := h.roomT.storeQuad.storeQuad
  fitA2 := h.fitA2.storeQuad.storeQuad
  roomAI := Room.storeQuad (Room.storeQuad h.roomAI)
  bA := h.bA.storeQuad.storeQuad
  wA := h.wA.storeQuad.storeQuad
  bB := h.bB.storeQuad.storeQuad
  wB := h.wB.storeQuad.storeQuad
  a2v := by
    rw [MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hL.aa2),
      MemoryState.readQuad_storeQuad_of_id_ne hL.ta2, h.a2v]
  slides1 := slidesAt_storeQuad (slidesAt_storeQuad h.slides1 hL.t1)
    (by simpa [Pointer.add_id] using hL.a1)
  slides2 := slidesAt_storeQuad (slidesAt_storeQuad h.slides2 hL.t2)
    (by simpa [Pointer.add_id] using hL.a2')
  tblB := (h.tblB.storeQuad hL.tb).storeQuad (by simpa [Pointer.add_id] using hL.ab)
  tblA := fun k hk => by
    have hao : ai.offset.toNat + 192 * 8 < 2 ^ 64 := by rw [hL.aio]; decide
    rcases Nat.lt_or_ge k i with hki | hki
    · refine ⟨(h.tblA k hki).1.storeQuad.storeQuad, ?_⟩
      rw [MemoryState.readQuad_storeQuad_apart (by omega) (by omega) (by omega),
        MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hL.ta)]
      exact (h.tblA k hki).2
    · obtain rfl : k = i := by omega
      have hroom :=
        (MemoryState.QuadRoom.entry h.roomAI hao hi).storeQuad (p := tp) (P :=
          fd_ed25519_point_add_with_opts.spec A2 (aiTable A2 AI0 (k - 1)) 1#32)
      refine ⟨MemoryState.QuadFit.storeQuad_self hroom, ?_⟩
      rw [MemoryState.readQuad_storeQuad_self hroom]
      obtain ⟨j, rfl⟩ : ∃ j, k = j + 1 := ⟨k - 1, by omega⟩
      simp only [aiTable, Nat.add_sub_cancel]

/-- The table loop's stores are in the frame. -/
theorem eraseFrom_tableStep (hNa : N ≤ ai.id.id) (hNt : N ≤ tp.id.id) :
    (tableStep tp ai A2 P i S).mem.eraseFrom N = S.mem.eraseFrom N := by
  dsimp only
  rw [MemoryState.eraseFrom_storeQuad_of_le (by simpa [Pointer.add_id] using hNa),
    MemoryState.eraseFrom_storeQuad_of_le hNt]

/-- The table loop from `^bb2` at `i`: `ai[i …]` stored; at `^bb1` the table complete, `t` known,
and only the frame changed. -/
theorem table_loop (r n1 a n2 tbl n1s n2s ai a2 tp tA tB : Pointer) (w1 w2 : Vector Int 256)
    (A2 AI0 : Quad) (B : Nat → Quad) (N : Nat) (hL : TableLayout tp n1s n2s ai tbl a2)
    (hNa : N ≤ ai.id.id) (hNt : N ≤ tp.id.id) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
        TableRegs tbl n1s n2s ai a2 tp tA tB E →
        (E ⊨ [%%256 := BitVec.ofNat 64 i]) →
        1 ≤ i →
        i + m = 8 →
        i < 8 →
        TableFacts S r tp n1s n2s ai tbl a2 tA tB w1 w2 (aiTable A2 AI0) B A2 i →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            TableRegs tbl n1s n2s ai a2 tp tA tB E' →
            S'.alloc = S.alloc →
            TableFacts S' r tp n1s n2s ai tbl a2 tA tB w1 w2 (aiTable A2 AI0) B A2 8 →
            S'.mem.QuadFit tp →
            S'.mem.eraseFrom N = S.mem.eraseFrom N →
            (runD E' ^bb1 S' >>= g) = K) →
        (runD E ^bb2 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro i S E _ _ _ _ hm hi; omega
  | succ m ih =>
    intro i S E hArgs hR hRi hi1 hm hi hF hK
    have hstep := hF.step (AI0 := AI0) hL hi1 hi
    have hao : ai.offset.toNat + 192 * 8 < 2 ^ 64 := by rw [hL.aio]; decide
    refine
      table_iter r n1 a n2 tbl n1s n2s ai a2 tp tA tB A2 (aiTable A2 AI0 (i - 1)) g K i hi1 hi S E
        hArgs hR hRi hF.wf hF.fitA2 hF.roomT (hF.tblA (i - 1) (by omega)).1
        (MemoryState.QuadRoom.entry hF.roomAI hao hi) hL.aio hF.a2v
        (hF.tblA (i - 1) (by omega)).2 ?_ ?_
    · intro h8 E' S' h₁ h₂ hS'
      subst hS'
      obtain rfl : m = 0 := by omega
      rw [show i + 1 = 8 from h8] at hstep
      exact
        hK E' _ h₁ h₂ rfl hstep (MemoryState.QuadFit.storeQuad_self hF.roomT).storeQuad
          (eraseFrom_tableStep hNa hNt)
    · intro h8 E' S' h₁ h₂ h₃ hS'
      subst hS'
      exact
        ih (i + 1) _ E' h₁ h₂ h₃ (by omega) (by omega) h8 hstep
          fun E'' S'' h₁' h₂' halloc hLF hT herase =>
          hK E'' S'' h₁' h₂' halloc hLF hT (herase.trans (eraseFrom_tableStep hNa hNt))

/-! ### The specification's cases -/

/-- `spec` without a non-zero digit: the neutral point. -/
theorem spec_of_none {x1 x2 : BitVec 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        none) :
    Avx512.fd_ed25519_double_scalar_mul_base.spec tbl x1 A x2 = fd_ed25519_point_set_zero.spec := by
  unfold Avx512.fd_ed25519_double_scalar_mul_base.spec
  dsimp only
  rw [h]

/-- `spec` from the first non-zero digit `j`: the main loop from `j`. -/
theorem spec_of_some {x1 x2 : BitVec 256} {j : Fin 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        some j) :
    Avx512.fd_ed25519_double_scalar_mul_base.spec tbl x1 A x2 =
      ladder (aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)) tbl
        (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) j j.isLt
        fd_ed25519_point_set_zero.spec := by
  unfold Avx512.fd_ed25519_double_scalar_mul_base.spec
  dsimp only
  rw [h]

end fd_ed25519_double_scalar_mul_base

attribute [local mlir_transport] fd_ed25519_double_scalar_mul_base.TableAt.storeQuad
  fd_ed25519_double_scalar_mul_base.TableAt.storeAt
  fd_ed25519_double_scalar_mul_base.TableAt.lifetimeStart
  fd_ed25519_double_scalar_mul_base.TableAt.lifetimeEnd
  fd_ed25519_double_scalar_mul_base.slidesAt_storeQuad
  fd_ed25519_double_scalar_mul_base.slidesAt_storeAt
  fd_ed25519_double_scalar_mul_base.slidesAt_lifetimeStart
  fd_ed25519_double_scalar_mul_base.slidesAt_lifetimeEnd

/-- The table's value, its folded constant. -/
public theorem fd_ed25519_base_point_wnaf_table.value_eq (s : GlobalState) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_base_point_wnaf_table.value s =
      .value (Ty.wrap _root_.Firedancer.Lane.Mlir.fd_ed25519_base_point_wnaf_table.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

set_option maxHeartbeats 2000000 in
-- the entry block in one walk: 265 instructions, the inlined `fd_curve25519_into_precomputed`
open fd_ed25519_double_scalar_mul_base Firedancer.Ref in
/-- `fd_ed25519_double_scalar_mul_base` stores `spec` of the scalars at `n1`, `n2` and the point at
`a` at `r` and returns `r`; `r` may be any of the inputs: they are read before it is written. Its
frame is nine blocks: seven locals and `fd_curve25519_scalar_wnaf`'s two. -/
public theorem fd_ed25519_double_scalar_mul_base.call_eq (r n1 a n2 : Pointer) (s : GlobalState)
    (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base.globals)
    (hr : s.mem.QuadRoom r) (hn1 : Fits s.mem n1 (8 * 32)) (ha : s.mem.QuadFit a)
    (hn2 : Fits s.mem n2 (8 * 32)) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_double_scalar_mul_base.args (.value r) (.value n1)
          (.value a) (.value n2)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 9⟩,
            mem :=
              s.mem.storeQuad r
                (Avx512.fd_ed25519_double_scalar_mul_base.spec
                  Avx512.fd_ed25519_base_point_wnaf_table.point (s.mem.readAt n1 256)
                  (s.mem.readQuad a) (s.mem.readAt n2 256)) }) := by
  -- folded for `func_init`, whose frame-free check would unfold it
  generalize hP :
    Avx512.fd_ed25519_double_scalar_mul_base.spec Avx512.fd_ed25519_base_point_wnaf_table.point
      (s.mem.readAt n1 256) (s.mem.readQuad a) (s.mem.readAt n2 256) = P
  func_init
  obtain ⟨x1, hx1⟩ : ∃ x, S.mem.readAt n1 256 = x := ⟨_, rfl⟩
  obtain ⟨A, hA⟩ : ∃ A, S.mem.readQuad a = A := ⟨_, rfl⟩
  obtain ⟨x2, hx2⟩ : ∃ x, S.mem.readAt n2 256 = x := ⟨_, rfl⟩
  rw [hx1, hA, hx2] at hP
  have hr₀ : S₀.mem.QuadRoom r := hS ▸ hr
  have hA₀ : S₀.mem.readQuad a = A := hS ▸ hA
  clear hA
  block_init
  iterate 2 step_pure
  step_addressof fd_ed25519_base_point_wnaf_table.value_eq with tbl
  iterate 50 step_pure
  iterate 7 step_pattern using runBodyFrom_insertRun inline
  -- the temporaries, short n1slide[256], n2slide[256], fd_ed25519_point_t ai[8], a2[1], t[1]
  step_alloca with tB
  step_alloca with tA
  step_alloca with n1s
  step_alloca with n2s
  step_alloca with ai
  step_alloca with a2
  step_alloca with tp
  -- fd_curve25519_scalar_wnaf( n1slide, n1, 4 ); fd_curve25519_scalar_wnaf( n2slide, n2, 8 );
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  iterate 3 step_pure
  -- fd_ed25519_point_set( &ai[0], a ); fd_ed25519_point_dbln( a2, a, 1 );
  -- fd_curve25519_into_precomputed( &ai[0] ): `a` loaded, the copy fused away
  step_load with a03
  step_pure
  step_load with a14
  step_pure
  step_pure
  step_load with a25
  step_pure
  have ha2q := MemoryState.QuadRoom.of_room hroom_a2 ha2_off
  step_call using fd_ed25519_point_dbln.call_eq
  step_pattern using runBodyFrom_permuteRun_poison 1 0 2 3 1 0 0 0
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
  have e2 := _hl
  step_pattern using runBodyFrom_laneAddRun 0 1 0 0
  have e3 := _hl
  step_pattern using runBodyFrom_foldSignedRun
  have eF := (Quad.foldSigned_eq _).trans _hs
  step_pattern using runBodyFrom_halvesRun 0 1 2 3 inline
  step_pattern using runBodyFrom_quadMulCoreRun
  have e4 := quadMul_of_core' (Y := quad1112d) _hm
  have haiq := MemoryState.QuadRoom.of_room (hroom_ai.mono (by decide)) hai_off
  step_pattern using runBodyFrom_foldUnsignedStoreRun'
  have eU := (Quad.foldUnsigned_eq _).trans _hu
  iterate 2 step_pure
  finish_block
  have eA : (⟨a03, a14, a25⟩ : Quad) = A := by
    rw [← hA₀, ha03, ha14, ha25]
    rfl
  have hsl1 : SlidesAt S.mem n1s (fd_curve25519_scalar_wnaf.wnaf x1 4) :=
    SlidesAt.of_readAt hfits_n1s (by rw [hn1s_off]; decide) hread_n1s
  have hsl2 : SlidesAt S.mem n2s (fd_curve25519_scalar_wnaf.wnaf x2 8) :=
    SlidesAt.of_readAt hfits_n2s (by rw [hn2s_off]; decide) hread_n2s
  have hlit :
      _root_.Firedancer.Lane.Mlir.fd_ed25519_base_point_wnaf_table.lit =
        Avx512.fd_ed25519_base_point_wnaf_table.lit := rfl
  have htblB : TableAt S.mem tbl 128 Avx512.fd_ed25519_base_point_wnaf_table.point :=
    TableAt.of_readAt htbl_fits (hread_tbl.trans (by rw [hlit])) (by rw [htbl_off]; decide) rfl
  have hai0 : TableAt S.mem ai 1
      (aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)) :=
    fun k hk => by
      obtain rfl : k = 0 := by omega
      simp only [Nat.mul_zero, Pointer.add_zero_quad, aiTable]
      refine ⟨haiq, ?_⟩
      rw [← eA, intoPre_of e2 e3 eF e4, eU, MemoryState.readQuad,
        MemoryState.readVec_packLanes hread_ai, MemoryState.readVec_packLanes hread_ai_64,
        MemoryState.readVec_packLanes hread_ai_128]
  have hTL : TableLayout tp n1s n2s ai tbl a2 :=
    ⟨by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact,
      by mem_fact, by mem_fact, hai_off⟩
  have hF : TableFacts S r tp n1s n2s ai tbl a2 tA tB (fd_curve25519_scalar_wnaf.wnaf x1 4)
      (fd_curve25519_scalar_wnaf.wnaf x2 8)
      (aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A))
      Avx512.fd_ed25519_base_point_wnaf_table.point (fd_ed25519_point_dbln.spec A 1) 1 :=
    ⟨hwf, hr, MemoryState.QuadRoom.of_room hroom_tp htp_off, ha2q, hroom_ai, htA_bounds,
      hwritable_tA, htB_bounds, hwritable_tB, hread_a2, hsl1, hsl2, hai0, htblB⟩
  clear hsl1 hsl2 htblB hai0
  -- for( int i=1; i<WNAF_TBL_SZ; i++ ) { … }
  refine
    table_loop r n1 a n2 tbl n1s n2s ai a2 tp tA tB _ _ _ _ _ S₀.alloc.nextFreeBlock hTL
      (by slot_bound) (by slot_bound) _ _ 7 1 S E hArgs ⟨⟨by env_reads, by env_reads⟩, by env_reads⟩
      (by env_reads) (by decide) (by decide) (by decide) hF
      fun E' S' h₁ h₂ halloc hLF hT herase => ?_
  clear hfits_ai_128 haiq hfits_ai_64 hfits_ai hread_ai_128 hread_ai_64 hread_ai hread_a2 hread_n2s
    hread_n1s hx1 hx2 hread_tbl ha2q hroom_tp hroom_a2 hroom_ai hfits_n2s hroom_n2s hfits_n1s
    hroom_n1s hwf hr hn1 ha hn2 htbl_live htbl_fits hwritable_tB htB_bounds hwritable_tA htA_bounds
    hwritable_n1s hn1s_bounds hwritable_n2s hn2s_bounds hwritable_ai hai_bounds hwritable_a2
    ha2_bounds hwritable_tp htp_bounds hF hE hArgs eA eU e4 eF ha03 ha14 ha25 hg hglobal_tbl
  obtain ⟨hwf, hr, hrT, -, -, hAb, hAw, hBb, hBw, -, hsl1, hsl2, htA, htB⟩ := hLF
  obtain ⟨⟨hC, hSk⟩, hT2⟩ := h₂
  have hS0 := hS
  have hro := hr.1
  -- fd_ed25519_point_set_zero( r ), inlined
  block_init
  step_store
  step_pure
  have hr_1024 := hr.room_14_25
  step_memset consuming hr_1024
  finish_block
  have hS1 := hS
  have hz : S.mem = S'.mem.storeQuad r fd_ed25519_point_set_zero.spec := by
    rw [hS]
    dsimp only
    rw [MemoryState.storeAt_zero_14_25 hro]
    rfl
  have hrS' : S'.mem.QuadRoom r := MemoryState.QuadRoom.of_storeQuad (hz ▸ hr)
  have hfitR : S.mem.QuadFit r := hz ▸ MemoryState.QuadFit.storeQuad_self hrS'
  have hrz : S.mem.readQuad r = fd_ed25519_point_set_zero.spec :=
    hz ▸ MemoryState.readQuad_storeQuad_self hrS'
  have hrw : Writable S.mem r := hr.2.1.2
  clear hread_r hread_r_64 hfits_r hfits_r_64 hread_tp
  have hN1 : S₀.alloc.nextFreeBlock ≤ n1s.id.id := by slot_bound
  have hN2 : S₀.alloc.nextFreeBlock ≤ n2s.id.id := by slot_bound
  have hNa : S₀.alloc.nextFreeBlock ≤ ai.id.id := by slot_bound
  have hNa2 : S₀.alloc.nextFreeBlock ≤ a2.id.id := by slot_bound
  have hNt : S₀.alloc.nextFreeBlock ≤ tp.id.id := by slot_bound
  have hw1 := fun k hk => (fd_curve25519_scalar_wnaf.wnaf4_digits x1 k hk).2
  have hw2 := fun k hk => (fd_curve25519_scalar_wnaf.wnaf8_digits x2 k hk).2
  -- for( i=255; i>=0; i-- ) { if( n1slide[i] || n2slide[i] ) break; }
  refine
    skip_loop r n1 a n2 tbl n1s n2s ai a2 tp tA tB _ _ hw1 hw2 (by rw [hn1s_off]; decide)
      (by rw [hn2s_off]; decide) S hsl1 hsl2 _ _ 31 (by decide) E hArgs
      ⟨by env_reads, by env_reads⟩ (by env_reads) ?_ ?_
  · -- the main loop from the first non-zero digit
    intro j hj hj' E₂ h₁ h₂ h₃
    block_init
    step_pure [slt_neg_one32 (show j < 2 ^ 31 by omega)]
    finish_block
    block_init
    iterate 5 step_pure
    step_pure [msb_ofNat32 (show j < 2 ^ 31 by omega), setWidth_ofNat32 (show j < 2 ^ 32 by omega)]
    finish_block
    have hL : Layout S₀.alloc.nextFreeBlock r tp n1s n2s ai tbl tA tB :=
      ⟨by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact,
        by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact,
        by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact,
        by rw [hn1s_off]; decide, by rw [hn2s_off]; decide, by rw [hai_off]; decide,
        by rw [htbl_off]; decide, htA_off, htB_off, by slot_bound, by slot_bound, by slot_bound⟩
    refine
      main_loop r n1 a n2 tbl n1s n2s ai a2 tp tA tB _ _ _ _ _ hL hw1 hw2 _ _ j hj _ S E hArgs
        (by env_reads) (by env_reads)
        ⟨hwf, hfitR, hrw, hT, hrT.2.1.2, hAb, hAw, hBb, hBw, hsl1, hsl2, htA, htB⟩ hrz
        fun E₃ S₃ h₁' hR₃ hF₃ ha₃ hr₃ he₃ => ?_
    -- the lifetimes' ends
    block_init
    iterate 5 step_pure
    finish_block
    rw [← hP, spec_of_some hj']
    subst hS
    simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hN1,
      MemoryState.eraseFrom_lifetimeEnd_of_le hN2, MemoryState.eraseFrom_lifetimeEnd_of_le hNa,
      MemoryState.eraseFrom_lifetimeEnd_of_le hNa2, MemoryState.eraseFrom_lifetimeEnd_of_le hNt]
    rw [he₃, hz, MemoryState.storeQuad_storeQuad_self hro, MemoryState.eraseFrom_storeQuad, herase,
      ha₃, hS1]
    dsimp only
    rw [halloc, hS0]
    dsimp only
    erase_frame
    simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
  · -- no non-zero digit: `r` is zero
    intro hj E₂ h₁ h₂
    block_init
    iterate 5 step_pure
    finish_block
    rw [← hP, spec_of_none hj]
    subst hS
    simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hN1,
      MemoryState.eraseFrom_lifetimeEnd_of_le hN2, MemoryState.eraseFrom_lifetimeEnd_of_le hNa,
      MemoryState.eraseFrom_lifetimeEnd_of_le hNa2, MemoryState.eraseFrom_lifetimeEnd_of_le hNt]
    have hz' :
        (S'.mem.storeAt r
              (BitVec.packLanes #v[0#64, 1#64, 1#64, 0#64, 0#64, 0#64, 0#64, 0#64])).storeAt
            (r.add 64#64) 0#1024 =
          S'.mem.storeQuad r fd_ed25519_point_set_zero.spec := by
      rw [MemoryState.storeAt_zero_14_25 hro]
      rfl
    rw [hz', MemoryState.eraseFrom_storeQuad, herase, halloc, hS0]
    dsimp only
    erase_frame
    simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]

end Proof

end MLIR.Firedancer.Lane
