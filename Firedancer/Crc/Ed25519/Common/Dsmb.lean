module

public import MLIR.Run.Tactic
public import Firedancer.Common.Memory
public import Firedancer.Common.Dsmb
import Std.Data.ExtHashMap.Lemmas

/-! # Helpers of the double-scalar-multiplication proofs

Backend-neutral facts the `double_scalar_mul_base` proofs share: the entry blocks' 32- and 64-bit
arithmetic, digit-array memsets, and memory below an erased frame. -/

namespace MLIR.Firedancer.Crc.Ed25519.Dsmb

@[expose] public section

/-! ### Arithmetic of the entry blocks -/

theorem smax32 {a b : Nat} (ha : a < 2 ^ 31) (hb : b < 2 ^ 31) :
    (if (BitVec.ofNat 32 b).slt (BitVec.ofNat 32 a) then BitVec.ofNat 32 a else BitVec.ofNat 32 b) =
      BitVec.ofNat 32 (max a b) := by
  have h1 : (BitVec.ofNat 32 a).toInt = a := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 32 b).toInt = b := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp only [BitVec.slt, h1, h2, decide_eq_true_eq]
  split <;> congr 1 <;> omega

theorem slt32 {a b : Nat} (ha : a < 2 ^ 31) (hb : b < 2 ^ 31) :
    (BitVec.ofNat 32 b).slt (BitVec.ofNat 32 a) = decide (b < a) := by
  have h1 : (BitVec.ofNat 32 a).toInt = a := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 32 b).toInt = b := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp only [BitVec.slt, h1, h2]
  simp

theorem signExtend_ofNat32 {a : Nat} (h : a < 2 ^ 31) :
    (BitVec.ofNat 32 a).signExtend 64 = BitVec.ofNat 64 a := by
  have hm : (BitVec.ofNat 32 a).msb = false := by
    rw [BitVec.msb_eq_decide, BitVec.toNat_ofNat]; simp; omega
  rw [BitVec.signExtend_eq_setWidth_of_msb_false hm]
  apply BitVec.eq_of_toNat_eq
  simp [Nat.mod_eq_of_lt (show a < 2 ^ 32 by omega)]

theorem shl1_64 {a : Nat} (h : a < 2 ^ 62) :
    (BitVec.ofNat 64 a <<< 1).sshiftRight 1 = BitVec.ofNat 64 a ∧
      BitVec.ofNat 64 a <<< 1 >>> 1 = BitVec.ofNat 64 a ∧
      BitVec.ofNat 64 a <<< 1 = BitVec.ofNat 64 (2 * a) := by
  have : BitVec.ofNat 64 a <<< 1 = BitVec.ofNat 64 (2 * a) := by
    apply BitVec.eq_of_toNat_eq
    simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (show 2 * a < 2 ^ 64 by omega)]
    omega
  refine ⟨?_, ?_, this⟩
  · rw [this, BitVec.sshiftRight_eq_of_msb_false]
    · apply BitVec.eq_of_toNat_eq
      simp [BitVec.toNat_ushiftRight, Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega),
        Nat.mod_eq_of_lt (show 2 * a < 2 ^ 64 by omega)]
      omega
    · rw [BitVec.msb_eq_decide, BitVec.toNat_ofNat]; simp; omega
  · rw [this]
    apply BitVec.eq_of_toNat_eq
    simp [BitVec.toNat_ushiftRight, Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (show 2 * a < 2 ^ 64 by omega)]
    omega

theorem shl_mul2 {a : Nat} (h : a < 2 ^ 62) : BitVec.ofNat 64 a <<< 1 = BitVec.ofNat 64 (2 * a) :=
  (shl1_64 h).2.2

theorem sshr_mul2 {a : Nat} (h : a < 2 ^ 62) :
    (BitVec.ofNat 64 (2 * a)).sshiftRight 1 = BitVec.ofNat 64 a := by
  rw [← shl_mul2 h]; exact (shl1_64 h).1

theorem ushr_mul2 {a : Nat} (h : a < 2 ^ 62) : BitVec.ofNat 64 (2 * a) >>> 1 = BitVec.ofNat 64 a := by
  rw [← shl_mul2 h]; exact (shl1_64 h).2.1

/-- `n + (k xor -1)`, zero-extended: `n - k - 1` (with `k < n`). -/
theorem memset_z {n k : Nat} (hn : n < 2 ^ 31) (hk : k < n) :
    (BitVec.ofNat 32 n + (BitVec.ofNat 32 k ^^^ 4294967295#32)).setWidth 64 =
      BitVec.ofNat 64 (n - k - 1) := by
  have hx : BitVec.ofNat 32 k ^^^ 4294967295#32 = ~~~ BitVec.ofNat 32 k := by
    rw [show (4294967295#32) = BitVec.allOnes 32 from rfl, BitVec.xor_allOnes]
  apply BitVec.eq_of_toNat_eq
  simp only [hx, BitVec.toNat_setWidth, BitVec.toNat_add, BitVec.toNat_not, BitVec.toNat_ofNat,
    Nat.reducePow]
  rw [Nat.mod_eq_of_lt (show n < 2 ^ 32 by omega), Nat.mod_eq_of_lt (show k < 2 ^ 32 by omega),
    show n + (2 ^ 32 - 1 - k) = (n - k - 1) + 2 ^ 32 by omega, Nat.add_mod_right,
    Nat.mod_eq_of_lt (show n - k - 1 < 2 ^ 32 by omega), Nat.mod_eq_of_lt (by omega)]

theorem add_two64 {a : Nat} (h : a + 2 < 2 ^ 63) :
    (BitVec.ofNat 64 a).uaddOverflow 2#64 = false ∧ (BitVec.ofNat 64 a).saddOverflow 2#64 = false ∧
      BitVec.ofNat 64 a + 2#64 = BitVec.ofNat 64 (a + 2) := by
  have h1 : (BitVec.ofNat 64 a).toInt = a := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 64 a).toNat = a := by simp; omega
  refine ⟨?_, ?_, ?_⟩
  · simp only [BitVec.uaddOverflow, h2]; simp; omega
  · simp only [BitVec.saddOverflow, h1]; simp; omega
  · apply BitVec.eq_of_toNat_eq
    simp [h2, Nat.mod_eq_of_lt (show a + 2 < 2 ^ 64 by omega)]

theorem sub32 {a b : Nat} (hb : b ≤ a) (ha : a < 2 ^ 32) :
    BitVec.ofNat 32 a - BitVec.ofNat 32 b = BitVec.ofNat 32 (a - b) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt (show b < 2 ^ 32 by omega),
    Nat.mod_eq_of_lt (show a - b < 2 ^ 32 by omega)]
  rw [show 2 ^ 32 - b + a = (a - b) + 2 ^ 32 by omega, Nat.add_mod_right]
  exact Nat.mod_eq_of_lt (by omega)

theorem setWidth64_ofNat32 {a : Nat} (h : a < 2 ^ 32) :
    (BitVec.ofNat 32 a).setWidth 64 = BitVec.ofNat 64 a := by
  apply BitVec.eq_of_toNat_eq
  simp [Nat.mod_eq_of_lt h, Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega)]

theorem msb32_false {a : Nat} (h : a < 2 ^ 31) : (BitVec.ofNat 32 a).msb = false := by
  rw [BitVec.msb_eq_decide, BitVec.toNat_ofNat]; simp; omega

/-! ### Memory below an erased frame -/

theorem eraseFrom_eraseFrom {m : MemoryState} (h : n ≤ n') :
    (m.eraseFrom n').eraseFrom n = m.eraseFrom n := by
  simp only [MemoryState.eraseFrom, MemoryState.mk.injEq, and_true]
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_filter']
  cases m.mem[k]? <;> simp only [Option.filter_none, Option.filter_some]
  by_cases hk : k.id < n
  · simp [hk, show k.id < n' by omega]
  · simp [hk]

theorem readAt_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n).readAt p w = m.readAt p w := by
  simp only [MemoryState.readAt, MemoryState.eraseFrom, MemoryState.getElem?_eq,
    Std.ExtHashMap.getElem?_filter', h, decide_true]
  cases m.mem[p.id]? <;> rfl

theorem getElem?_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n)[p.id]? = m[p.id]? := by
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter', h,
    decide_true]
  cases m.mem[p.id]? <;> rfl

theorem fits_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Fits (m.eraseFrom n) p w) :
    Fits m p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := h
  refine ⟨b, ?_, hl, hw, hd⟩
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

theorem room_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Room (m.eraseFrom n) p w) :
    Room m p w := by
  have hn : p.id.id < n := by
    obtain ⟨⟨b, hb, -, -⟩, -⟩ := h
    by_contra hc
    simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter',
      hc, decide_false] at hb
    cases m.mem[p.id]? <;> simp at hb
  obtain ⟨⟨b, hb, hl, hw⟩, ⟨b', hb', hw'⟩⟩ := h
  rw [getElem?_eraseFrom_of_lt hn] at hb hb'
  exact ⟨⟨b, hb, hl, hw⟩, ⟨b', hb', hw'⟩⟩

theorem Fits.eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n)
    (hf : Fits m p w) : Fits (m.eraseFrom n) p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := hf
  exact ⟨b, (getElem?_eraseFrom_of_lt h).trans hb, hl, hw, hd⟩

theorem Room.eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n)
    (hr : Room m p w) : Room (m.eraseFrom n) p w := by
  obtain ⟨⟨b, hb, hl, hw⟩, ⟨b', hb', hw'⟩⟩ := hr
  exact ⟨⟨b, (getElem?_eraseFrom_of_lt h).trans hb, hl, hw⟩,
    ⟨b', (getElem?_eraseFrom_of_lt h).trans hb', hw'⟩⟩

theorem id_lt_of_eraseFrom_fits {m : MemoryState} {p : Pointer} (h : Fits (m.eraseFrom n) p w) :
    p.id.id < n := by
  obtain ⟨b, hb, -, -, -⟩ := h
  by_contra hc
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter',
    hc, decide_false] at hb
  cases m.mem[p.id]? <;> simp at hb

theorem room_of_lifetimeStart_ne {m : MemoryState} (hne : p.id ≠ q.id)
    (h : Room (m.lifetimeStart q) p w) : Room m p w := by
  obtain ⟨⟨b, hb, hl, hw⟩, ⟨b', hb', hw'⟩⟩ := h
  rw [show (m.lifetimeStart q)[p.id]? = m[p.id]? from MemoryState.getElem?_setLifetime_ne hne]
    at hb hb'
  exact ⟨⟨b, hb, hl, hw⟩, ⟨b', hb', hw'⟩⟩

/-! ### Digit arrays: `short d[256]` -/

/-- `d[i]`'s `Room`, inside `d`'s 512 bytes. -/
theorem lane_room {m : MemoryState} {d : Pointer} (hd : Room m d (8 * 512))
    (hdo : ¬d.offset.uaddOverflow 512#64) (hi : i < 256) :
    Room m (d.add (BitVec.ofNat 64 (2 * i))) 16 := by
  have h := hdo
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.reducePow,
    Nat.reduceMod] at h
  refine Room.add_of_le ?_ ?_ hd
  · simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
  · simp only [BitVec.toNat_ofNat]; omega

theorem replicate_zero8 (n : Nat) : (0#8).replicate n = 0#(8 * n) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i
  simp [BitVec.getLsbD_replicate]

/-- A memset of `2 * c` zero bytes at `d[k]` zeroes `d[i]`, `k ≤ i < k + c`. -/
theorem memset_read_zero {m : MemoryState} {d : Pointer} (hd : Room m d (8 * 512))
    (hdo : ¬d.offset.uaddOverflow 512#64) (hk : k + c ≤ 256) (hi : k ≤ i ∧ i < k + c) :
    Fits (m.storeAt (d.add (BitVec.ofNat 64 (2 * k))) ((0#8).replicate (2 * c)))
        (d.add (BitVec.ofNat 64 (2 * i))) 16 ∧
      (m.storeAt (d.add (BitVec.ofNat 64 (2 * k))) ((0#8).replicate (2 * c))).readAt
        (d.add (BitVec.ofNat 64 (2 * i))) 16 = 0#16 := by
  have h := hdo
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.reducePow,
    Nat.reduceMod] at h
  have hR : Room m (d.add (BitVec.ofNat 64 (2 * k))) (8 * (2 * c)) := by
    refine Room.add_of_le ?_ ?_ hd
    · simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
    · simp only [BitVec.toNat_ofNat]; omega
  have hov : ¬(d.add (BitVec.ofNat 64 (2 * k))).offset.uaddOverflow (BitVec.ofNat 64 (2 * (i - k))) := by
    simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
      decide_eq_true_eq, Nat.reducePow]
    rw [Nat.mod_eq_of_lt (show 2 * k < 2 ^ 64 by omega), Nat.mod_eq_of_lt (show 2 * (i - k) < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (by omega)]
    omega
  have he : d.add (BitVec.ofNat 64 (2 * i)) =
      (d.add (BitVec.ofNat 64 (2 * k))).add (BitVec.ofNat 64 (2 * (i - k))) := by
    rw [Pointer.add_add, ← BitVec.ofNat_add]; congr 2; omega
  have hw : (BitVec.ofNat 64 (2 * (i - k))).toNat * 8 + 16 ≤ 8 * (2 * c) := by
    simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega
  rw [he]
  refine ⟨Fits.storeAt_add_self hR hov hw, ?_⟩
  rw [MemoryState.readAt_storeAt_add hR hov hw, replicate_zero8, BitVec.extractLsb'_zero]

/-- A memset at `d[k]` of `2 * c` bytes keeps `d[i]`, `i < k`. -/
theorem memset_read_keep {m : MemoryState} {d : Pointer} {x : BitVec (8 * (2 * c))}
    (hdo : ¬d.offset.uaddOverflow 512#64) (hk : k + c ≤ 256) (hi : i < k) :
    (m.storeAt (d.add (BitVec.ofNat 64 (2 * k))) x).readAt (d.add (BitVec.ofNat 64 (2 * i))) 16 =
      m.readAt (d.add (BitVec.ofNat 64 (2 * i))) 16 := by
  have h := hdo
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.reducePow,
    Nat.reduceMod] at h
  exact MemoryState.readAt_storeAt_disjoint (Range.disjoint_add (by omega) (by omega) (by omega)) _

end

end MLIR.Firedancer.Crc.Ed25519.Dsmb
