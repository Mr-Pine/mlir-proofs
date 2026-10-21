module

public import MLIR.Run.Tactic
public import Boringssl.Mlir.CRYPTO_memcmp
import Std.Tactic.BVDecide
import Mathlib.Tactic.Ring

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- C's `x`: the bytes `a[i] ^ b[i]` (byte `i` at bits `8i …`) of the first `n` bytes, or-ed, as
an `int`. `0` exactly when the two ranges are equal. -/
def CRYPTO_memcmp.spec (a b : BitVec w) (n : Nat) : BitVec 32 :=
  ((List.range n).foldl (fun x i => x ||| (a.extractLsb' (8 * i) 8 ^^^ b.extractLsb' (8 * i) 8))
        0#8).setWidth
    32

end

/-- The or-ed xors vanish exactly when every byte agrees. -/
public theorem CRYPTO_memcmp.spec_eq_zero_iff (a b : BitVec w) (n : Nat) :
    CRYPTO_memcmp.spec a b n = 0#32 ↔
      ∀ i < n, a.extractLsb' (8 * i) 8 = b.extractLsb' (8 * i) 8 := by
  have hw (x : BitVec 8) : x.setWidth 32 = 0#32 ↔ x = 0#8 := by bv_decide
  rw [CRYPTO_memcmp.spec, hw]
  induction n with
  | zero => simp
  | succ n
    ih =>
    simp only [List.range_succ, List.foldl_append, List.foldl_cons, List.foldl_nil]
    generalize hx : List.foldl _ 0#8 (List.range n) = x at ih
    have hor (y z : BitVec 8) : y ||| z = 0#8 ↔ y = 0#8 ∧ z = 0#8 := by bv_decide
    have hxor (y z : BitVec 8) : y ^^^ z = 0#8 ↔ y = z := by bv_decide
    simp only [hor, ih, hxor]
    constructor
    · rintro ⟨h, h'⟩ i hi
      rcases Nat.lt_succ_iff_lt_or_eq.mp hi with hi | rfl
      · exact h i hi
      · exact h'
    · intro h
      exact ⟨fun i hi => h i (Nat.lt_succ_of_lt hi), h n (Nat.lt_succ_self n)⟩

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- A vector-loop iteration at byte `8k`: its facts, steps and branch. -/
local macro "vec_iter" : tactic =>
  `(tactic|
    ( have := len.isLt
      have hc4 := toNat_ofNat_add_four (i := 8 * k) (by omega)
      have ha4 := not_uaddOverflow_add (k := 8 * k) (c := 4) ha_off (by omega)
      have hb4 := not_uaddOverflow_add (k := 8 * k) (c := 4) hb_off (by omega)
      have ha' := fits_add ha ha_off (off := BitVec.ofNat 64 (8 * k) + 4#64) (by omega)
      have hb' := fits_add hb hb_off (off := BitVec.ofNat 64 (8 * k) + 4#64) (by omega)
      block_init
      -- x |= a[i] ^ b[i], eight bytes at a time
      step_pure [Nat.mod_lt]
      step_pure [ha4]
      step_load
      step_load
      step_pure [Nat.mod_lt]
      step_pure [hb4]
      step_load
      step_load
      iterate 6 step_pure
      -- i += 8
      step_pure [show ¬(BitVec.ofNat 64 (8 * k)).uaddOverflow 8#64 by
            simp [BitVec.uaddOverflow]; omega]
      step_pure
      finish_block))

set_option hygiene false in
/-- A tail-loop iteration at byte `i`: its facts, steps and branch. -/
local macro "tail_iter" : tactic =>
  `(tactic|
    ( have := len.isLt
      block_init
      -- x |= a[i] ^ b[i];
      step_pure [Nat.mod_lt]
      step_load
      step_pure [Nat.mod_lt]
      step_load
      iterate 3 step_pure
      -- i++
      step_pure [show ¬(BitVec.ofNat 64 i).uaddOverflow 1#64 by
            simp [BitVec.uaddOverflow]; omega]
      step_pure
      finish_block))

namespace CRYPTO_memcmp

/-- Byte `k`'s xor as the code widens it: `b[k]`, then `a[k]`. -/
abbrev xb (a b : BitVec w) (k : Nat) : BitVec 32 :=
  (b.extractLsb' (8 * k) 8).setWidth 32 ^^^ (a.extractLsb' (8 * k) 8).setWidth 32

/-- `xb` or-ed over the first `k` bytes. -/
def orTo (a b : BitVec w) (k : Nat) : BitVec 32 :=
  (List.range k).foldl (fun x t => x ||| xb a b t) 0

/-- A vector lane's accumulator after `k` iterations: `xb` or-ed over the bytes `8t + j`. -/
def orLane (a b : BitVec w) (j k : Nat) : BitVec 32 :=
  (List.range k).foldl (fun x t => x ||| xb a b (8 * t + j)) 0

/-- The accumulator of lanes `off … off + 3` after `k` iterations. -/
def lanes (a b : BitVec w) (off k : Nat) : Vector (BitVec 32) 4 :=
  Vector.ofFn fun j => orLane a b (j.val + off) k

theorem orTo_succ (a b : BitVec w) (k : Nat) : orTo a b (k + 1) = orTo a b k ||| xb a b k := by
  simp [orTo, List.range_succ]

theorem orLane_succ (a b : BitVec w) (j k : Nat) :
    orLane a b j (k + 1) = orLane a b j k ||| xb a b (8 * k + j) := by
  simp [orLane, List.range_succ]

/-- The OR of all eight lanes after `k` iterations: the first `8k` bytes'. -/
theorem orLanes_eq (a b : BitVec w) (k : Nat) :
    ((((lanes a b 4 k)[0] ||| (lanes a b 0 k)[0]) |||
            ((lanes a b 4 k)[1] ||| (lanes a b 0 k)[1])) |||
          ((lanes a b 4 k)[2] ||| (lanes a b 0 k)[2])) |||
        ((lanes a b 4 k)[3] ||| (lanes a b 0 k)[3]) =
      orTo a b (8 * k) := by
  induction k with
  | zero => simp [lanes, orLane, orTo]
  | succ k ih =>
    simp only [lanes, Vector.getElem_ofFn, orLane_succ] at ih ⊢
    rw [show 8 * (k + 1) = 8 * k + 7 + 1 by omega, orTo_succ, orTo_succ, orTo_succ, orTo_succ,
      orTo_succ, orTo_succ, orTo_succ, show 8 * k + 7 = 8 * k + 0 + 7 by omega, orTo_succ, ← ih]
    simp only [Nat.add_zero, Nat.zero_add]
    generalize xb a b (8 * k) = y0, xb a b (8 * k + 1) = y1, xb a b (8 * k + 2) = y2,
      xb a b (8 * k + 3) = y3, xb a b (8 * k + 4) = y4, xb a b (8 * k + 5) = y5,
      xb a b (8 * k + 6) = y6, xb a b (8 * k + 7) = y7
    generalize orLane a b 0 k = z0, orLane a b 1 k = z1, orLane a b 2 k = z2, orLane a b 3 k = z3,
      orLane a b 4 k = z4, orLane a b 5 k = z5, orLane a b 6 k = z6, orLane a b 7 k = z7
    bv_decide

/-- The bytes from `k` to `k + c` stay within `len` of `p`. -/
theorem not_uaddOverflow_add {p : Pointer} {len : BitVec 64} (h : ¬p.offset.uaddOverflow len)
    (hk : k + c ≤ len.toNat) :
    ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow (BitVec.ofNat 64 c) := by
  have := len.isLt
  simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le, Pointer.add,
    BitVec.toNat_add, BitVec.toNat_ofNat] at h ⊢
  rw [Nat.mod_eq_of_lt (a := k) (by omega), Nat.mod_eq_of_lt (a := c) (by omega),
    Nat.mod_eq_of_lt (by omega)]
  omega

/-- Four bytes from `off` within the `len` bytes at `p` fit. -/
theorem fits_add {m : MemoryState} {p : Pointer} {len : BitVec 64} (h : Fits m p (8 * len.toNat))
    (hov : ¬p.offset.uaddOverflow len) {off : BitVec 64} (hoff : off.toNat + 4 ≤ len.toNat) :
    Fits m (p.add off) 32 :=
  Fits.add_of_le (BitVec.not_uaddOverflow_of_le hov (by omega)) (by omega) h

/-- `i + 4` without wrap, for `i + 4 < 2^64`. -/
theorem toNat_ofNat_add_four (h : i + 4 < 2 ^ 64) : (BitVec.ofNat 64 i + 4#64).toNat = i + 4 := by
  simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
  omega

/-- An iteration's accumulator: lanes `off … off + 3` or-ed with the xors of the four bytes from
`c = 8k + off`. -/
theorem lanes_succ (A B : BitVec v) (hc : c = 8 * k + off) (hk : 8 * c + 32 ≤ v) :
    (Vector.ofFn fun i : Fin 4 =>
        (lanes A B off k)[i.val] |||
          (Ty.extractVecElem 4 8 i (B.extractLsb' (c * 8) 32)).setWidth 32 ^^^
            (Ty.extractVecElem 4 8 i (A.extractLsb' (c * 8) 32)).setWidth 32) =
      lanes A B off (k + 1) := by
  subst hc
  apply Vector.ext
  intro j hj
  simp only [lanes, Vector.getElem_ofFn, orLane_succ, xb, Ty.extractVecElem_eq,
    BitVec.extractLsb'_extractLsb'_add (show j * 8 + 8 ≤ 32 by omega)]
  rw [show (8 * k + off) * 8 + j * 8 = 8 * (8 * k + (j + off)) by ring]

/-- The vector loop's result: its eight lanes or-ed, the first `8k` bytes' xors. -/
theorem acc_or_eq {A B : BitVec v} {acc : Vector (BitVec 32) 4}
    (h : acc = Vector.ofFn fun i => (lanes A B 4 k)[i.val] ||| (lanes A B 0 k)[i.val]) :
    acc[0] ||| acc[1] ||| acc[2] ||| acc[3] = orTo A B (8 * k) := by
  subst h
  simp only [Vector.getElem_ofFn]
  exact orLanes_eq A B k

/-- `orTo` is the spec: or-ing the widened bytes widens their or. -/
theorem orTo_eq_spec (A B : BitVec v) (n : Nat) : orTo A B n = CRYPTO_memcmp.spec A B n := by
  induction n with
  | zero => simp [orTo, CRYPTO_memcmp.spec]
  | succ n ih =>
    rw [orTo_succ, ih]
    simp only [CRYPTO_memcmp.spec, List.range_succ, List.foldl_append, List.foldl_cons,
      List.foldl_nil, xb]
    generalize List.foldl _ 0#8 (List.range n) = x
    bv_decide

/-- `len & ~7`: `len` rounded down to a multiple of `8`. -/
theorem toNat_and_neg8 (len : BitVec 64) :
    (len &&& 18446744073709551608#64).toNat = 8 * (len.toNat / 8) := by
  have h : len &&& 18446744073709551608#64 = (len >>> 3) <<< 3 := by bv_decide
  rw [h, BitVec.toNat_shiftLeft, BitVec.toNat_ushiftRight, Nat.shiftLeft_eq,
    Nat.shiftRight_eq_div_pow]
  have := len.isLt
  omega

/-- The live registers at the vector loop's header `^bb3`: at byte `i`, its accumulators. -/
abbrev hdr3 (len : BitVec 64) (E : ⟪Γ⟫) (i : Nat) (acc0 acc1 : Vector (BitVec 32) 4) : ⟪Γ⟫ :=
  E[%0 := .value 0#64, %2 := .value 8#64, %4 := Ty.wrap (Vector.replicate 4 0#32), %5 :=
    .value 1#64, %8 := .value (len &&& 18446744073709551608#64), %9 := .value (BitVec.ofNat 64 i),
    %10 := Ty.wrap acc0, %11 := Ty.wrap acc1]

/-- The live registers at the vector loop's exit `^bb4`: the last iteration's accumulators. -/
abbrev exit3 (len : BitVec 64) (E : ⟪Γ⟫) (acc0 acc1 : Vector (BitVec 32) 4) : ⟪Γ⟫ :=
  E[%0 := .value 0#64, %2 := .value 8#64, %4 := Ty.wrap (Vector.replicate 4 0#32), %5 :=
    .value 1#64, %8 := .value (len &&& 18446744073709551608#64), %24 := Ty.wrap acc0, %25 :=
    Ty.wrap acc1]

/-- `^bb3` after `k` iterations, `n + 1` left: the accumulators then hold the first
`8 (k + n + 1)` bytes' xors, lane by lane, and the loop exits to `^bb4`. -/
theorem vec_loop (a b : Pointer) (len : BitVec 64) (S : GlobalState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (ha : Fits S.mem a (8 * len.toNat)) (hb : Fits S.mem b (8 * len.toNat))
    (ha_off : ¬a.offset.uaddOverflow len) (hb_off : ¬b.offset.uaddOverflow len)
    (hlen : len.toNat < 2 ^ 63) :
    ∀ n k,
      8 * (k + n + 1) ≤ len.toNat →
        8 * (k + n + 1) = (len &&& 18446744073709551608#64).toNat →
        ∀ E : ⟪Γ⟫,
          E.args = (CRYPTO_memcmp.args (.value a) (.value b) (.value len)).get →
            (∀ E' : ⟪Γ⟫,
              E'.args = E.args →
                (CRYPTO_memcmp.runFrom
                      (exit3 len E'
                        (lanes (S.mem.readAt a (8 * len.toNat)) (S.mem.readAt b (8 * len.toNat)) 0
                          (k + n + 1))
                        (lanes (S.mem.readAt a (8 * len.toNat)) (S.mem.readAt b (8 * len.toNat)) 4
                          (k + n + 1)))
                      4 S >>=
                    g) =
                  K) →
            (CRYPTO_memcmp.runFrom
                  (hdr3 len E (8 * k)
                    (lanes (S.mem.readAt a (8 * len.toNat)) (S.mem.readAt b (8 * len.toNat)) 0 k)
                    (lanes (S.mem.readAt a (8 * len.toNat)) (S.mem.readAt b (8 * len.toNat)) 4 k))
                  3 S >>=
                g) =
              K := by
  intro n
  induction n with
  | zero =>
    intro k hle hm E hArgs hK
    vec_iter
    · subst hS
      rw [lanes_succ _ _ (by omega) (by omega), lanes_succ _ _ (by omega) (by omega)] at hE
      run_from using hK
    · exfalso
      apply hbr
      apply BitVec.eq_of_toNat_eq
      rw [← hm]
      simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
      omega
  | succ n ih =>
    intro k hle hm E hArgs hK
    have hA := hArgs.symm
    vec_iter
    · exfalso
      have := congrArg BitVec.toNat hbr
      rw [← hm] at this
      simp only [BitVec.toNat_add, BitVec.toNat_ofNat] at this
      omega
    · subst hS
      rw [lanes_succ _ _ (by omega) (by omega), lanes_succ _ _ (by omega) (by omega),
        show BitVec.ofNat 64 (8 * k) + 8#64 = BitVec.ofNat 64 (8 * (k + 1)) by
          rw [Nat.mul_succ, BitVec.ofNat_add]] at hE
      run_from using ih (k + 1) (by omega) (by omega)
      subst hS
      rw [show k + 1 + n + 1 = k + (n + 1) + 1 by omega] at hE
      run_from using hK
      rw [hE] at hArgs
      simpa [← hA] using hArgs

/-- A tail iteration's accumulator: byte `c = i`'s xor or-ed in. -/
theorem orTo_step (A B : BitVec v) (hc : c = i) :
    orTo A B i ||| (B.extractLsb' (c * 8) 8).setWidth 32 ^^^ (A.extractLsb' (c * 8) 8).setWidth 32 =
      orTo A B (i + 1) := by
  subst hc
  rw [orTo_succ, xb, Nat.mul_comm]

/-- The live registers at the tail loop's header `^bb7`: at byte `i`, its accumulator. -/
abbrev hdr7 (E : ⟪Γ⟫) (i : Nat) (x : BitVec 32) : ⟪Γ⟫ :=
  E[%5 := .value 1#64, %34 := .value (BitVec.ofNat 64 i), %35 := .value x]

/-- The return block `^bb6`, its parameter `r`. -/
abbrev exit6 (E : ⟪Γ⟫) (r : BitVec 32) : ⟪Γ⟫ :=
  E[%33 := .value r]

/-- `^bb7` at byte `i`, `n + 1` bytes left: the accumulator then holds all `len` bytes' xors, and
the loop exits to `^bb6`. -/
theorem tail_loop (a b : Pointer) (len : BitVec 64) (S : GlobalState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (ha : Fits S.mem a (8 * len.toNat)) (hb : Fits S.mem b (8 * len.toNat))
    (ha_off : ¬a.offset.uaddOverflow len) (hb_off : ¬b.offset.uaddOverflow len)
    (hlen : len.toNat < 2 ^ 63) :
    ∀ n i,
      i + n + 1 = len.toNat →
        ∀ E : ⟪Γ⟫,
          E.args = (CRYPTO_memcmp.args (.value a) (.value b) (.value len)).get →
            (∀ E' : ⟪Γ⟫,
              E'.args = E.args →
                (CRYPTO_memcmp.runFrom
                      (exit6 E'
                        (orTo (S.mem.readAt a (8 * len.toNat)) (S.mem.readAt b (8 * len.toNat))
                          len.toNat))
                      6 S >>=
                    g) =
                  K) →
            (CRYPTO_memcmp.runFrom
                  (hdr7 E i
                    (orTo (S.mem.readAt a (8 * len.toNat)) (S.mem.readAt b (8 * len.toNat)) i))
                  7 S >>=
                g) =
              K := by
  intro n
  induction n with
  | zero =>
    intro i hi E hArgs hK
    tail_iter
    · subst hS
      rw [orTo_step _ _ (by omega), show i + 1 = len.toNat by omega] at hE
      run_from using hK
    · exfalso
      apply hbr
      apply BitVec.eq_of_toNat_eq
      simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
      omega
  | succ n ih =>
    intro i hi E hArgs hK
    have hA := hArgs.symm
    tail_iter
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_add, BitVec.toNat_ofNat] at this
      omega
    · subst hS
      rw [orTo_step _ _ (by omega),
        show BitVec.ofNat 64 i + 1#64 = BitVec.ofNat 64 (i + 1) by rw [BitVec.ofNat_add]] at hE
      run_from using ih (i + 1) (by omega)
      run_from using hK
      rw [hE] at hArgs
      simpa [← hA] using hArgs

end CRYPTO_memcmp

open CRYPTO_memcmp in
/-- `CRYPTO_memcmp` returns `spec` of the `len` bytes at `a` and at `b`; memory is unchanged. -/
public theorem CRYPTO_memcmp.call_eq (a b : Pointer) (len : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (ha : Fits s.mem a (8 * len.toNat)) (hb : Fits s.mem b (8 * len.toNat))
    (ha_off : ¬a.offset.uaddOverflow len) (hb_off : ¬b.offset.uaddOverflow len)
    (hlen : len.toNat < 2 ^ 63) :
    CRYPTO_memcmp.call (CRYPTO_memcmp.args (.value a) (.value b) (.value len)) s =
      .value
        (.cons
            (.value
              (CRYPTO_memcmp.spec (s.mem.readAt a (8 * len.toNat)) (s.mem.readAt b (8 * len.toNat))
                len.toNat))
            .nil,
          s) := by
  func_init
  block_init
  iterate 7 step_pure
  finish_block
  · -- len = 0: return 0
    block_init
    finish_block
    subst hS hbr
    simp [CRYPTO_memcmp.spec]
  · have hne : len.toNat ≠ 0 := fun h => hbr (BitVec.eq_of_toNat_eq h)
    block_init
    step_pure
    finish_block
    · -- len < 8: the tail loop alone
      block_init
      finish_block
      rw [← bind_pure (CRYPTO_memcmp.runFrom E 7 S)]
      run_from using tail_loop a b len _ _ _ ha hb ha_off hb_off hlen (len.toNat - 1) 0 (by omega)
      block_init
      finish_block
      subst hS
      simp [orTo_eq_spec]
    · block_init
      step_pure
      finish_block
      have hlt := len.isLt
      have h8 : 8 ≤ len.toNat := by
        simp [BitVec.ult] at hbr; omega
      have hm := toNat_and_neg8 len
      rw [← bind_pure (CRYPTO_memcmp.runFrom E 3 S)]
      run_from using
        vec_loop a b len _ _ _ ha hb ha_off hb_off hlen (len.toNat / 8 - 1) 0 (by omega) (by omega)
      -- `^bb4`: the lanes or-ed
      block_init
      step_pure with acc
      step_pure
      rw [acc_or_eq hacc, show 8 * (len.toNat / 8 - 1 + 1) = 8 * (len.toNat / 8) by omega] at hE
      clear hacc
      generalize hmd : len &&& 18446744073709551608#64 = m at hE hm
      step_pure
      finish_block
      · -- len == (len & ~7): return
        block_init
        finish_block
        subst hS hbr
        simp only [orTo_eq_spec, ← hm]
        rfl
      · -- the tail from byte `len & ~7`
        block_init
        finish_block
        have hne : m.toNat ≠ len.toNat := fun h => hbr (BitVec.eq_of_toNat_eq h).symm
        run_from using
          tail_loop a b len _ _ _ ha hb ha_off hb_off hlen (len.toNat - m.toNat - 1) m.toNat
            (by omega)
        · apply BitVec.eq_of_toNat_eq
          simp only [BitVec.toNat_ofNat]
          omega
        · block_init
          finish_block
          subst hS
          simp [orTo_eq_spec]

end Proof

end MLIR.Boringssl
