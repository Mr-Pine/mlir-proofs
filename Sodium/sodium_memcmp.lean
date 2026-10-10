module

public import MLIR.Run.Tactic
public import Sodium.Common.Counter
public import Sodium._sodium_dummy_symbol_to_prevent_memcmp_lto
public import Sodium.Mlir.sodium_memcmp
import Std.Tactic.BVDecide

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

namespace sodium_memcmp

/-- `b1[i] ^ b2[i]`, byte `i` of `x` and of `y`. -/
def xorByte (x y : BitVec w) (i : Nat) : BitVec 8 :=
  x.extractLsb' (8 * i) 8 ^^^ y.extractLsb' (8 * i) 8

/-- `d |= f i` for `i < k`, from `d = 0`. -/
def orRange (f : Nat → BitVec 8) : Nat → BitVec 8
  | 0 => 0#8
  | k + 1 => orRange f k ||| f k

end sodium_memcmp

/-- `(1 & ((e - 1) >> 8)) - 1` for `e = d`, the `OR` of the `len` bytes' differences: `0` if the
bytes `x` and `y` agree, `-1` if not. -/
def sodium_memcmp.spec (len : Nat) (x y : BitVec w) : BitVec 32 :=
  let d := sodium_memcmp.orRange (sodium_memcmp.xorByte x y) len
  (1#32 &&& ((d.setWidth 32 - 1#32) >>> 8)) - 1#32

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `^bb12`: `e = d`, its volatile store and loads (`asm` the identity), the return value
`(1 & ((e - 1) >> 8)) - 1`, the frame erased. -/
local macro "tail_proof" : tactic =>
  `(tactic|
    ( intro hR'
      block_init
      step_store
      step_load
      step_pure
      step_store
      step_load
      step_pure
      step_pure [add511_sadd, add511_uadd]
      step_pure
      step_pure
      step_pure [and1_sadd]
      step_lifetime
      finish_block
      subst hS
      erase_frame
      rw [ret_eq]
      rfl))

namespace sodium_memcmp

/-- A byte's difference `or`ed in, as the code orders it. -/
theorem orRange_succ_xor (x y : BitVec w) (i : Nat) :
    (y.extractLsb' (i * 8) 8 ^^^ x.extractLsb' (i * 8) 8) ||| orRange (xorByte x y) i =
      orRange (xorByte x y) (i + 1) := by
  rw [orRange, xorByte, Nat.mul_comm i 8, BitVec.or_comm, BitVec.xor_comm]

/-- `i + k` on a small counter equals `x` exactly when it does as a number. -/
theorem ofNat64_add_eq_iff {i k : Nat} {x : BitVec 64} (hi : i + k < 2 ^ 64) :
    BitVec.ofNat 64 i + BitVec.ofNat 64 k = x ↔ i + k = x.toNat := by
  constructor
  · rintro rfl
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  · intro h
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega

/-- The `OR` of `v`'s lanes. -/
def orAll (v : Vector (BitVec 8) n) : BitVec 8 :=
  orRange (fun j => if h : j < n then v[j] else 0#8) n

theorem orRange_congr {f g : Nat → BitVec 8} (h : ∀ j < n, f j = g j) :
    orRange f n = orRange g n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [orRange, orRange, ih (fun j hj => h j (by omega)), h n (by omega)]

theorem orRange_or (f g : Nat → BitVec 8) (n : Nat) :
    orRange (fun j => f j ||| g j) n = orRange f n ||| orRange g n := by
  induction n with
  | zero => simp [orRange]
  | succ n ih =>
    rw [orRange, orRange, orRange, ih]
    ac_rfl

theorem orRange_add (f : Nat → BitVec 8) (a b : Nat) :
    orRange f (a + b) = orRange f a ||| orRange (fun j => f (a + j)) b := by
  induction b with
  | zero => simp [orRange]
  | succ b ih =>
    rw [← Nat.add_assoc, orRange, ih, orRange]
    ac_rfl

/-- A vector loop's accumulator after a chunk of `n` bytes at `i`: the chunk's differences
`or`ed in. -/
theorem orAll_lanes (x y : BitVec w) (i n : Nat) (acc : Vector (BitVec 8) n) :
    orAll
        (Vector.ofFn fun j : Fin n =>
          Ty.extractVecElem n 8 j (y.extractLsb' (i * 8) (8 * n)) ^^^
              Ty.extractVecElem n 8 j (x.extractLsb' (i * 8) (8 * n)) |||
            acc[↑j]) =
      orRange (fun j => xorByte x y (i + j)) n ||| orAll acc := by
  unfold orAll
  rw [← orRange_or]
  apply orRange_congr
  intro j hj
  simp only [hj, ↓reduceDIte, Vector.getElem_ofFn, Ty.extractVecElem_eq,
    BitVec.extractLsb'_extractLsb'_add (show j * 8 + 8 ≤ 8 * n by omega), xorByte]
  rw [BitVec.xor_comm, show i * 8 + j * 8 = 8 * (i + j) by omega]
  rfl

/-- The invariant after a chunk of `n` bytes at `i`. -/
theorem orAll_step {x y : BitVec w} {i : Nat} {acc : Vector (BitVec 8) n}
    (h : orAll acc = orRange (xorByte x y) i) :
    orAll
        (Vector.ofFn fun j : Fin n =>
          Ty.extractVecElem n 8 j (y.extractLsb' (i * 8) (8 * n)) ^^^
              Ty.extractVecElem n 8 j (x.extractLsb' (i * 8) (8 * n)) |||
            acc[↑j]) =
      orRange (xorByte x y) (i + n) := by
  rw [orAll_lanes, h, orRange_add, BitVec.or_comm]

theorem orAll4_eq (v : Vector (BitVec 8) 4) : v[0] ||| v[1] ||| v[2] ||| v[3] = orAll v := by
  simp [orAll, orRange]

theorem add511_sadd (d : BitVec 8) : (d.setWidth 32).saddOverflow 511#32 = false := by bv_decide

theorem add511_uadd (d : BitVec 8) : (d.setWidth 32).uaddOverflow 511#32 = false := by bv_decide

theorem and1_sadd (z : BitVec 32) : (z &&& 1#32).saddOverflow 4294967295#32 = false := by bv_decide

/-- The return value as the steps leave it. -/
theorem ret_eq (d : BitVec 8) :
    ((d.setWidth 32 + 511#32) >>> 8 &&& 1#32) + 4294967295#32 =
      (1#32 &&& ((d.setWidth 32 - 1#32) >>> 8)) - 1#32 := by
  bv_decide

theorem toNat_and_neg4 (len : BitVec 64) :
    (len &&& 18446744073709551612#64).toNat = len.toNat / 4 * 4 := by
  have e : len &&& 18446744073709551612#64 = len - (len &&& 3#64) := by bv_decide
  have h3 : (len &&& 3#64).toNat = len.toNat % 4 := by
    rw [BitVec.toNat_and, show (3#64).toNat = 2 ^ 2 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  rw [e,
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, h3]; omega),
    h3]
  omega

theorem toNat_and_neg32 (len : BitVec 64) :
    (len &&& 18446744073709551584#64).toNat = len.toNat / 32 * 32 := by
  have e : len &&& 18446744073709551584#64 = len - (len &&& 31#64) := by bv_decide
  have h3 : (len &&& 31#64).toNat = len.toNat % 32 := by
    rw [BitVec.toNat_and, show (31#64).toNat = 2 ^ 5 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  rw [e,
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, h3]; omega),
    h3]
  omega

theorem toNat_and_28 (len : BitVec 64) :
    (len &&& 28#64).toNat = len.toNat % 32 - len.toNat % 4 := by
  have e : len &&& 28#64 = (len &&& 31#64) - (len &&& 3#64) := by bv_decide
  have hle : len &&& 3#64 ≤ len &&& 31#64 := by bv_decide
  have h3 : (len &&& 3#64).toNat = len.toNat % 4 := by
    rw [BitVec.toNat_and, show (3#64).toNat = 2 ^ 2 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  have h31 : (len &&& 31#64).toNat = len.toNat % 32 := by
    rw [BitVec.toNat_and, show (31#64).toNat = 2 ^ 5 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]
  rw [e, BitVec.toNat_sub_of_le hle, h3, h31]

/-- `^bb11`, the byte loop from `i`, `k + 1` bytes left. -/
theorem byte_loop (b1 b2 v : Pointer) (len : BitVec 64) (x y : BitVec (8 * len.toNat))
    (S : GlobalState) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hx : S.mem.readAt b1 (8 * len.toNat) = x) (hy : S.mem.readAt b2 (8 * len.toNat) = y)
    (hf1 : Fits S.mem b1 (8 * len.toNat)) (hf2 : Fits S.mem b2 (8 * len.toNat))
    (ho1 : ¬b1.offset.uaddOverflow len) (ho2 : ¬b2.offset.uaddOverflow len)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value b1) (.value b2) (.value len)).get →
          (E' ⊨ [%149 := orRange (xorByte x y) len.toNat, %94 := v, %72 := 4294967295#32, %73 :=
            8#32, %74 := 511#32, %78 := 1#32]) →
          (sodium_memcmp.runFrom E' 12 S >>= g) = K) :
    ∀ k i (E : ⟪Γ⟫),
      E.args = (args (.value b1) (.value b2) (.value len)).get →
        (E ⊨ [%139 := orRange (xorByte x y) i, %140 := BitVec.ofNat 64 i, %75 := 1#64, %94 := v,
          %72 := 4294967295#32, %73 := 8#32, %74 := 511#32, %78 := 1#32]) →
        i + k + 1 = len.toNat → (sodium_memcmp.runFrom E 11 S >>= g) = K := by
  intro k
  induction k with
  | zero =>
    intro i E hArgs hR hk
    have hi : i < 18446744073709551616 := by
      have := len.isLt; omega
    block_init
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load [Nat.mod_eq_of_lt hi]
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load [Nat.mod_eq_of_lt hi]
    step_pure
    step_pure [orRange_succ_xor]
    step_pure [uaddOverflow_ofNat64 (i := i) (k := 1) (by omega)]
    step_pure
    finish_block
    · step_loop using hK
    · exact absurd ((ofNat64_add_one_eq_iff (by omega)).2 (by omega)) hbr
  | succ k ih =>
    intro i E hArgs hR hk
    have hi : i < 18446744073709551616 := by
      have := len.isLt; omega
    block_init
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load [Nat.mod_eq_of_lt hi]
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load [Nat.mod_eq_of_lt hi]
    step_pure
    step_pure [orRange_succ_xor]
    step_pure [uaddOverflow_ofNat64 (i := i) (k := 1) (by omega)]
    step_pure
    finish_block
    · have := (ofNat64_add_one_eq_iff (by omega)).1 hbr
      omega
    · step_loop using ih (i + 1)
      all_goals
        first
        | omega
        | exact (BitVec.ofNat_add i 1).symm

/-- `^bb8`, the 4-byte loop from `i`, `k + 1` words left. -/
theorem word_loop (b1 b2 v : Pointer) (len : BitVec 64) (x y : BitVec (8 * len.toNat))
    (S : GlobalState) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hx : S.mem.readAt b1 (8 * len.toNat) = x) (hy : S.mem.readAt b2 (8 * len.toNat) = y)
    (hf1 : Fits S.mem b1 (8 * len.toNat)) (hf2 : Fits S.mem b2 (8 * len.toNat))
    (ho1 : ¬b1.offset.uaddOverflow len) (ho2 : ¬b2.offset.uaddOverflow len)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value b1) (.value b2) (.value len)).get →
          (E' ⊨ [%149 := orRange (xorByte x y) len.toNat, %94 := v, %72 := 4294967295#32, %73 :=
            8#32, %74 := 511#32, %78 := 1#32]) →
          (sodium_memcmp.runFrom E' 12 S >>= g) = K) :
    ∀ k i (acc : Vector (BitVec 8) 4) (E : ⟪Γ⟫),
      E.args = (args (.value b1) (.value b2) (.value len)).get →
        (E ⊨ [%125 := BitVec.ofNat 64 i, %126 := acc, %123 := len &&& 18446744073709551612#64,
          %81 := 4#64, %75 := 1#64, %94 := v, %72 := 4294967295#32, %73 := 8#32, %74 := 511#32,
          %78 := 1#32]) →
        orAll acc = orRange (xorByte x y) i →
        i + 4 * (k + 1) = (len &&& 18446744073709551612#64).toNat →
        (sodium_memcmp.runFrom E 8 S >>= g) = K := by
  intro k
  induction k with
  | zero =>
    intro i acc E hArgs hR hor hk
    rw [toNat_and_neg4] at hk
    have hle : i + 4 ≤ len.toNat := by omega
    have hi : i < 18446744073709551616 := by
      have := len.isLt; omega
    block_init
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load [Nat.mod_eq_of_lt hi]
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load [Nat.mod_eq_of_lt hi]
    step_pure
    step_pure with acc'
    have hor' : orAll acc' = orRange (xorByte x y) (i + 4) := by
      rw [hacc']; exact orAll_step hor
    step_pure [uaddOverflow_ofNat64 (i := i) (k := 4) (by omega)]
    step_pure
    finish_block
    · block_init
      step_pure [orAll4_eq, hor']
      step_pure
      finish_block
      · have e := congrArg BitVec.toNat hbr
        rw [toNat_and_neg4] at e
        rw [show i + 4 = len.toNat by omega] at hE
        step_loop using hK
      · block_init
        finish_block
        have e : len.toNat ≠ len.toNat / 4 * 4 := fun e =>
          hbr
            (BitVec.eq_of_toNat_eq
              (by
                rw [toNat_and_neg4]; exact e))
        subst hS
        step_loop using
          byte_loop b1 b2 v len x y _ g K hx hy hf1 hf2 ho1 ho2 hK (len.toNat - (i + 4) - 1) (i + 4)
        apply BitVec.eq_of_toNat_eq
        rw [toNat_and_neg4, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    · exact
        absurd
          ((ofNat64_add_eq_iff (k := 4) (by omega)).2
            (by
              rw [toNat_and_neg4]; omega))
          hbr
  | succ k ih =>
    intro i acc E hArgs hR hor hk
    rw [toNat_and_neg4] at hk
    have hle : i + 4 ≤ len.toNat := by omega
    have hi : i < 18446744073709551616 := by
      have := len.isLt; omega
    block_init
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load [Nat.mod_eq_of_lt hi]
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_load [Nat.mod_eq_of_lt hi]
    step_pure
    step_pure with acc'
    have hor' : orAll acc' = orRange (xorByte x y) (i + 4) := by
      rw [hacc']; exact orAll_step hor
    step_pure [uaddOverflow_ofNat64 (i := i) (k := 4) (by omega)]
    step_pure
    finish_block
    · have := (ofNat64_add_eq_iff (k := 4) (by omega)).1 hbr
      rw [toNat_and_neg4] at this
      omega
    · have h4 : len.toNat &&& 18446744073709551612 = len.toNat / 4 * 4 := by
        have := toNat_and_neg4 len
        rw [BitVec.toNat_and] at this
        exact this
      step_loop using ih (i + 4) acc'
      all_goals
        first
        | exact hor'
        | exact (BitVec.ofNat_add i 4).symm
        | omega

/-- `^bb7`, the 4-byte loop's entry at `i0`, a multiple of 4 below the last word, with
`d = orRange … i0`. -/
theorem word_entry (b1 b2 v : Pointer) (len : BitVec 64) (x y : BitVec (8 * len.toNat))
    (S : GlobalState) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hx : S.mem.readAt b1 (8 * len.toNat) = x) (hy : S.mem.readAt b2 (8 * len.toNat) = y)
    (hf1 : Fits S.mem b1 (8 * len.toNat)) (hf2 : Fits S.mem b2 (8 * len.toNat))
    (ho1 : ¬b1.offset.uaddOverflow len) (ho2 : ¬b2.offset.uaddOverflow len)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value b1) (.value b2) (.value len)).get →
          (E' ⊨ [%149 := orRange (xorByte x y) len.toNat, %94 := v, %72 := 4294967295#32, %73 :=
            8#32, %74 := 511#32, %78 := 1#32]) →
          (sodium_memcmp.runFrom E' 12 S >>= g) = K)
    (i0 : Nat) (E : ⟪Γ⟫) (hArgs : E.args = (args (.value b1) (.value b2) (.value len)).get)
    (hR :
      E ⊨ [%121 := BitVec.ofNat 64 i0, %122 := orRange (xorByte x y) i0, %79 := 0#64, %86 :=
        18446744073709551612#64, %81 := 4#64, %75 := 1#64, %94 := v, %72 := 4294967295#32, %73 :=
        8#32, %74 := 511#32, %78 := 1#32])
    (h93 :
      E.read (%93) =
        (#v[.poison, .value 0#8, .value 0#8, .value 0#8] : Vector (PoisonOr (BitVec 8)) 4))
    (hi0 : i0 % 4 = 0) (hlt : i0 + 4 ≤ len.toNat) : (sodium_memcmp.runFrom E 7 S >>= g) = K := by
  block_init
  step_pure
  step_pure
  finish_block
  have h4 : len.toNat &&& 18446744073709551612 = len.toNat / 4 * 4 := by
    have := toNat_and_neg4 len
    rw [BitVec.toNat_and] at this
    exact this
  step_loop using
    word_loop b1 b2 v len x y S g K hx hy hf1 hf2 ho1 ho2 hK ((len.toNat / 4 * 4 - i0) / 4 - 1) i0
      #v[orRange (xorByte x y) i0, 0#8, 0#8, 0#8]
  all_goals
    first
    | simp [orAll, orRange]
    | (rw [toNat_and_neg4]; omega)
    | omega

/-- `p + i` does not wrap by `c` when `i + c ≤ len` and `p` does not wrap by `len`. -/
theorem not_uaddOverflow_ofNat_add {p : Pointer} {len c : BitVec 64} {i : Nat}
    (h : ¬p.offset.uaddOverflow len) (hi : i + c.toNat ≤ len.toNat) :
    ¬(p.add (BitVec.ofNat 64 i)).offset.uaddOverflow c := by
  have := len.isLt
  simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
    decide_eq_true_eq, ge_iff_le, Nat.not_le] at h ⊢
  rw [Nat.mod_eq_of_lt (a := i) (by omega)]
  omega

theorem ofNat_add_toNat (i : Nat) (c : BitVec 64) :
    BitVec.ofNat 64 i + c = BitVec.ofNat 64 (i + c.toNat) := by
  rw [BitVec.ofNat_add, BitVec.ofNat_toNat, BitVec.setWidth_eq]

/-- The 16 bytes at `p + i + 16` inside the `len` known bytes `x` at `p`. -/
theorem chunk16 {m : MemoryState} {p : Pointer} {len : BitVec 64} {x : BitVec (8 * len.toNat)}
    (hx : m.readAt p (8 * len.toNat) = x) (hf : Fits m p (8 * len.toNat))
    (ho : ¬p.offset.uaddOverflow len) {i : Nat} (hi : i + 32 ≤ len.toNat) :
    Fits m (p.add (BitVec.ofNat 64 (i + 16))) 128 ∧
      m.readAt (p.add (BitVec.ofNat 64 (i + 16))) 128 = x.extractLsb' ((i + 16) * 8) 128 := by
  have := len.isLt
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (i + 16)) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le,
      Nat.not_le] at ho ⊢
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  have hw : (BitVec.ofNat 64 (i + 16)).toNat * 8 + 128 ≤ 8 * len.toNat := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    omega
  refine ⟨Fits.add_of_le hov hw hf, ?_⟩
  rw [MemoryState.readAt_add_of_readAt hf.inBounds hov hw hx, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt (by omega)]

/-- The 32-byte loop's invariant after a block at `i`. -/
theorem block_step {x y : BitVec w} {i : Nat} {acc1 acc2 : Vector (BitVec 8) 16}
    (h : orAll acc1 ||| orAll acc2 = orRange (xorByte x y) i) :
    orAll
          (Vector.ofFn fun j : Fin 16 =>
            Ty.extractVecElem 16 8 j (y.extractLsb' (i * 8) 128) ^^^
                Ty.extractVecElem 16 8 j (x.extractLsb' (i * 8) 128) |||
              acc1[↑j]) |||
        orAll
          (Vector.ofFn fun j : Fin 16 =>
            Ty.extractVecElem 16 8 j (y.extractLsb' ((i + 16) * 8) 128) ^^^
                Ty.extractVecElem 16 8 j (x.extractLsb' ((i + 16) * 8) 128) |||
              acc2[↑j]) =
      orRange (xorByte x y) (i + 32) := by
  rw [orAll_lanes x y i 16 acc1, orAll_lanes x y (i + 16) 16 acc2,
    show i + 32 = i + 16 + 16 by omega, orRange_add _ (i + 16), orRange_add _ i, ← h]
  have e : (fun j => xorByte x y (i + 16 + j)) = fun j => xorByte x y (i + 16 + j) := rfl
  simp only [Nat.add_assoc] at e ⊢
  ac_rfl

theorem orAll16_eq (v : Vector (BitVec 8) 16) :
    v[0] ||| v[1] ||| v[2] ||| v[3] ||| v[4] ||| v[5] ||| v[6] ||| v[7] ||| v[8] ||| v[9] |||
        v[10] |||
        v[11] |||
        v[12] |||
        v[13] |||
        v[14] |||
        v[15] =
      orAll v := by
  simp [orAll, orRange]

theorem orAll_or (a b : Vector (BitVec 8) n) :
    orAll (Vector.ofFn fun j : Fin n => a[(j : Nat)] ||| b[(j : Nat)]) = orAll a ||| orAll b := by
  unfold orAll
  rw [← orRange_or]
  apply orRange_congr
  intro j hj
  simp [hj]

/-- `^bb4`, the 32-byte loop from `i`, `k + 1` blocks left. -/
theorem block_loop (b1 b2 v : Pointer) (len : BitVec 64) (x y : BitVec (8 * len.toNat))
    (S : GlobalState) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hx : S.mem.readAt b1 (8 * len.toNat) = x) (hy : S.mem.readAt b2 (8 * len.toNat) = y)
    (hf1 : Fits S.mem b1 (8 * len.toNat)) (hf2 : Fits S.mem b2 (8 * len.toNat))
    (ho1 : ¬b1.offset.uaddOverflow len) (ho2 : ¬b2.offset.uaddOverflow len)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value b1) (.value b2) (.value len)).get →
          (E' ⊨ [%149 := orRange (xorByte x y) len.toNat, %94 := v, %72 := 4294967295#32, %73 :=
            8#32, %74 := 511#32, %78 := 1#32]) →
          (sodium_memcmp.runFrom E' 12 S >>= g) = K) :
    ∀ k i (acc1 acc2 : Vector (BitVec 8) 16) (E : ⟪Γ⟫),
      E.args = (args (.value b1) (.value b2) (.value len)).get →
        (E ⊨ [%100 := BitVec.ofNat 64 i, %101 := acc1, %102 := acc2, %99 :=
          len &&& 18446744073709551584#64, %98 := len &&& 28#64, %82 := 32#64, %79 := 0#64, %86 :=
          18446744073709551612#64, %81 := 4#64, %75 := 1#64, %94 := v, %72 := 4294967295#32, %73 :=
          8#32, %74 := 511#32, %78 := 1#32]) →
        E.read (%93) =
          (#v[.poison, .value 0#8, .value 0#8, .value 0#8] : Vector (PoisonOr (BitVec 8)) 4) →
        orAll acc1 ||| orAll acc2 = orRange (xorByte x y) i →
        i + 32 * (k + 1) = (len &&& 18446744073709551584#64).toNat →
        (sodium_memcmp.runFrom E 4 S >>= g) = K := by
  intro k
  induction k with
  | zero =>
    intro i acc1 acc2 E hArgs hR h93 hor hk
    rw [toNat_and_neg32] at hk
    have hle : i + 32 ≤ len.toNat := by omega
    have hi : i < 18446744073709551616 := by
      have := len.isLt; omega
    obtain ⟨hf16, hx16⟩ := chunk16 hx hf1 ho1 hle
    obtain ⟨hg16, hy16⟩ := chunk16 hy hf2 ho2 hle
    have hb1 :=
      not_uaddOverflow_ofNat_add (i := i) (c := BitVec.ofNat 64 16) ho1
        (by
          simp; omega)
    have hb2 :=
      not_uaddOverflow_ofNat_add (i := i) (c := BitVec.ofNat 64 16) ho2
        (by
          simp; omega)
    block_init
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_pure
    simp only [ofNat_add_toNat] at hE
    step_load [Nat.mod_eq_of_lt hi]
    step_load consuming hf16 hx16
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_pure
    simp only [ofNat_add_toNat] at hE
    step_load [Nat.mod_eq_of_lt hi]
    step_load consuming hg16 hy16
    step_pure
    step_pure
    step_pure with acc1'
    step_pure with acc2'
    have hor' : orAll acc1' ||| orAll acc2' = orRange (xorByte x y) (i + 32) := by
      rw [hacc1', hacc2']; exact block_step hor
    step_pure [uaddOverflow_ofNat64 (i := i) (k := 32) (by omega)]
    step_pure
    finish_block
    · block_init
      step_pure with acc
      have hacc : orAll acc = orRange (xorByte x y) (i + 32) := by
        rw [hacc, orAll_or, BitVec.or_comm, hor']
      step_pure [orAll16_eq, hacc]
      step_pure
      finish_block
      · have e := congrArg BitVec.toNat hbr
        rw [toNat_and_neg32] at e
        rw [show i + 32 = len.toNat by omega] at hE
        step_loop using hK
      · have hne : len.toNat ≠ len.toNat / 32 * 32 := fun e =>
          hbr
            (BitVec.eq_of_toNat_eq
              (by
                rw [toNat_and_neg32]; exact e))
        block_init
        step_pure
        finish_block
        · have e := congrArg BitVec.toNat hbr
          rw [toNat_and_28] at e
          block_init
          finish_block
          subst hS
          step_loop using
            byte_loop b1 b2 v len x y _ g K hx hy hf1 hf2 ho1 ho2 hK (len.toNat - (i + 32) - 1)
              (i + 32)
          apply BitVec.eq_of_toNat_eq
          rw [toNat_and_neg32, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
        · have e : len.toNat % 32 - len.toNat % 4 ≠ 0 := fun e =>
            hbr
              (BitVec.eq_of_toNat_eq
                (by
                  rw [toNat_and_28]; exact e))
          subst hS
          step_loop using word_entry b1 b2 v len x y _ g K hx hy hf1 hf2 ho1 ho2 hK (i + 32)
          apply BitVec.eq_of_toNat_eq
          rw [toNat_and_neg32, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    · exact
        absurd
          ((ofNat64_add_eq_iff (k := 32) (by omega)).2
            (by
              rw [toNat_and_neg32]; omega))
          hbr
  | succ k ih =>
    intro i acc1 acc2 E hArgs hR h93 hor hk
    rw [toNat_and_neg32] at hk
    have hle : i + 32 ≤ len.toNat := by omega
    have hi : i < 18446744073709551616 := by
      have := len.isLt; omega
    obtain ⟨hf16, hx16⟩ := chunk16 hx hf1 ho1 hle
    obtain ⟨hg16, hy16⟩ := chunk16 hy hf2 ho2 hle
    have hb1 :=
      not_uaddOverflow_ofNat_add (i := i) (c := BitVec.ofNat 64 16) ho1
        (by
          simp; omega)
    have hb2 :=
      not_uaddOverflow_ofNat_add (i := i) (c := BitVec.ofNat 64 16) ho2
        (by
          simp; omega)
    block_init
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_pure
    simp only [ofNat_add_toNat] at hE
    step_load [Nat.mod_eq_of_lt hi]
    step_load consuming hf16 hx16
    step_pure [Nat.mod_eq_of_lt hi, hi]
    step_pure
    simp only [ofNat_add_toNat] at hE
    step_load [Nat.mod_eq_of_lt hi]
    step_load consuming hg16 hy16
    step_pure
    step_pure
    step_pure with acc1'
    step_pure with acc2'
    have hor' : orAll acc1' ||| orAll acc2' = orRange (xorByte x y) (i + 32) := by
      rw [hacc1', hacc2']; exact block_step hor
    step_pure [uaddOverflow_ofNat64 (i := i) (k := 32) (by omega)]
    step_pure
    finish_block
    · have := (ofNat64_add_eq_iff (k := 32) (by omega)).1 hbr
      rw [toNat_and_neg32] at this
      omega
    · have h32 : len.toNat &&& 18446744073709551584 = len.toNat / 32 * 32 := by
        have := toNat_and_neg32 len
        rw [BitVec.toNat_and] at this
        exact this
      step_loop using ih (i + 32) acc1' acc2'
      all_goals
        first
        | exact hor'
        | exact (BitVec.ofNat_add i 32).symm
        | omega

end sodium_memcmp

open sodium_memcmp in
/-- `sodium_memcmp(b1, b2, len)` returns `spec` of the `len` bytes at `b1` and at `b2`: `0` if
they agree, `-1` if not. The two may alias. The block counter advances by one (`e`). -/
public theorem sodium_memcmp.call_eq (b1 b2 : Pointer) (len : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hf1 : Fits s.mem b1 (8 * len.toNat)) (hf2 : Fits s.mem b2 (8 * len.toNat))
    (ho1 : ¬b1.offset.uaddOverflow len) (ho2 : ¬b2.offset.uaddOverflow len) :
    sodium_memcmp.call (sodium_memcmp.args (.value b1) (.value b2) (.value len)) s =
      .value
        (.cons
            (.value
              (sodium_memcmp.spec len.toNat (s.mem.readAt b1 (8 * len.toNat))
                (s.mem.readAt b2 (8 * len.toNat))))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  generalize hx : s.mem.readAt b1 (8 * len.toNat) = x
  generalize hy : s.mem.readAt b2 (8 * len.toNat) = y
  func_init
  block_init
  iterate 22 step_pure
  step_alloca with e
  step_lifetime
  step_call using _sodium_dummy_symbol_to_prevent_memcmp_lto.call_eq
  step_pure
  finish_block
  · block_init
    step_store
    step_load
    step_pure
    step_store
    step_load
    step_pure
    step_pure [add511_sadd, add511_uadd]
    step_pure
    step_pure
    step_pure [and1_sadd]
    step_lifetime
    finish_block
    subst hS
    erase_frame
    subst hbr
    congr 3
    simp only [spec, BitVec.toNat_ofNat, Nat.zero_mod, orRange]
    decide
  · have hlen0 : len.toNat ≠ 0 := fun h => hbr (BitVec.eq_of_toNat_eq (by simpa using h))
    block_init
    step_pure
    finish_block
    · have hlt : len.toNat < 4 := by simpa [BitVec.ult] using hbr
      block_init
      finish_block
      step_loop using byte_loop b1 b2 e len x y _ _ _ hx hy hf1 hf2 ho1 ho2 ?_ (len.toNat - 1) 0
      tail_proof
    · have hge4 : 4 ≤ len.toNat := by simpa [BitVec.ult] using hbr
      block_init
      step_pure
      finish_block
      · step_loop using word_entry b1 b2 e len x y _ _ _ hx hy hf1 hf2 ho1 ho2 ?_ 0
        tail_proof
      · have hge32 : 32 ≤ len.toNat := by simpa [BitVec.ult] using hbr
        block_init
        step_pure
        step_pure
        finish_block
        step_loop using
          block_loop b1 b2 e len x y _ _ _ hx hy hf1 hf2 ho1 ho2 ?_ (len.toNat / 32 - 1) 0
            (Vector.replicate 16 0#8) (Vector.replicate 16 0#8)
        · simp [orAll, orRange]
        · have h32 : len.toNat &&& 18446744073709551584 = len.toNat / 32 * 32 := by
            have := toNat_and_neg32 len
            rw [BitVec.toNat_and] at this
            exact this
          omega
        · tail_proof

namespace sodium_memcmp

theorem ret_eq_zero_iff (d : BitVec 8) :
    (1#32 &&& ((d.setWidth 32 - 1#32) >>> 8)) - 1#32 = 0#32 ↔ d = 0#8 := by
  constructor <;> intro h <;> bv_decide

theorem orRange_eq_zero_iff (f : Nat → BitVec 8) (n : Nat) :
    orRange f n = 0#8 ↔ ∀ i < n, f i = 0#8 := by
  induction n with
  | zero => simp [orRange]
  | succ n ih =>
    rw [orRange, BitVec.or_eq_zero_iff, ih]
    constructor
    · rintro ⟨h1, h2⟩ i hi
      rcases Nat.lt_succ_iff_lt_or_eq.1 hi with hi | rfl
      · exact h1 i hi
      · exact h2
    · intro h
      exact ⟨fun i hi => h i (by omega), h n (by omega)⟩

end sodium_memcmp

open sodium_memcmp in
/-- `spec` is `0` exactly when the `n` bytes agree. -/
public theorem sodium_memcmp.spec_eq_zero_iff (n : Nat) (x y : BitVec (8 * n)) :
    sodium_memcmp.spec n x y = 0#32 ↔ x = y := by
  rw [spec, ret_eq_zero_iff, orRange_eq_zero_iff]
  simp only [xorByte, BitVec.xor_eq_zero_iff]
  constructor
  · intro h
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    have := congrArg (·.getLsbD (j % 8)) (h (j / 8) (by omega))
    simp only [BitVec.getLsbD_extractLsb', show j % 8 < 8 by omega, decide_true,
      Bool.true_and] at this
    rwa [show 8 * (j / 8) + j % 8 = j by omega] at this
  · rintro rfl i _
    rfl

end Proof

end MLIR.Sodium
