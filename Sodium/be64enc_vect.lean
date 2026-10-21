module

public import MLIR.Run.Tactic
public import Sodium.Common.Memory
public import Sodium.Common.Counter
public import Sodium.store64_be
public import Sodium.Mlir.be64enc_vect
import Std.Tactic.BVDecide

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `STORE64_BE(dst + i * 8, src[i])`: word `i` of `m`'s words at `src`, its bytes big-endian. -/
def be64enc_vect.spec (m : MemoryState) (src : Pointer) (i : Nat) : BitVec 64 :=
  store64_be.spec (m.readAt (src.add (BitVec.ofNat 64 (8 * i))) 64)

end

/-! ## Proof -/

section Proof

namespace be64enc_vect

theorem shl3_toNat (i : Nat) (hi : 8 * i < 2 ^ 64) : (BitVec.ofNat 64 i <<< 3).toNat = 8 * i := by
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, Nat.shiftLeft_eq]
  omega

theorem shl3_eq (i : Nat) : BitVec.ofNat 64 i <<< 3 = BitVec.ofNat 64 (8 * i) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.shiftLeft_eq]
  omega

theorem shl3_ushr3 (i : Nat) (hi : i < 2 ^ 60) :
    BitVec.ofNat 64 i <<< 3 >>> 3 = BitVec.ofNat 64 i := by
  have : BitVec.ofNat 64 i < 1152921504606846976#64 := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat]; simp; omega
  bv_decide

theorem shl3_sshr3 (i : Nat) (hi : i < 2 ^ 60) :
    (BitVec.ofNat 64 i <<< 3).sshiftRight 3 = BitVec.ofNat 64 i := by
  have : BitVec.ofNat 64 i < 1152921504606846976#64 := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat]; simp; omega
  bv_decide

/-- Word `i` of `src`, past the words stored at `dst`. -/
theorem src_word {m₀ : MemoryState} {dst src : Pointer} {f : Nat → BitVec 64} {n i j : Nat}
    (hsrc : Fits m₀ src (64 * n)) (hsrco : src.offset.toNat + 8 * n < 2 ^ 64)
    (hdsto : dst.offset.toNat + 8 * n < 2 ^ 64)
    (hdisj : (Range.of dst (64 * n)).Disjoint (Range.of src (64 * n))) (hi : i < n) (hj : j ≤ n) :
    Fits (m₀.storeWords dst f j) (src.add (BitVec.ofNat 64 (8 * i))) 64 ∧
      (m₀.storeWords dst f j).readAt (src.add (BitVec.ofNat 64 (8 * i))) 64 =
        m₀.readAt (src.add (BitVec.ofNat 64 (8 * i))) 64 := by
  have hov : ¬src.offset.uaddOverflow (BitVec.ofNat 64 (8 * i)) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le, Nat.not_le]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  refine ⟨(Fits.add_of_le hov ?_ hsrc).storeWords, ?_⟩
  · rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    omega
  · refine MemoryState.readAt_storeWords_of_disjoint (by omega) ?_
    simp only [Range.Disjoint, Range.of, Pointer.add_id,
      Pointer.offsetInBits_word hsrco (Nat.le_of_lt hi)] at hdisj ⊢
    rcases hdisj with h | h | h
    · exact .inl h
    · exact .inr (.inl (by omega))
    · exact .inr (.inr (by omega))

/-- Room for word `i` at `dst`, which does not wrap. -/
theorem dst_word {m₀ : MemoryState} {dst : Pointer} {f : Nat → BitVec 64} {n i j : Nat}
    (hdst : Room m₀ dst (64 * n)) (hdsto : dst.offset.toNat + 8 * n < 2 ^ 64) (hi : i < n) :
    Room (m₀.storeWords dst f j) (dst.add (BitVec.ofNat 64 (8 * i))) 64 ∧
      ¬(dst.add (BitVec.ofNat 64 (8 * i))).offset.uaddOverflow 8#64 := by
  have hov : ¬dst.offset.uaddOverflow (BitVec.ofNat 64 (8 * i)) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, ge_iff_le, Nat.not_le]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  refine ⟨(Room.add_of_le hov ?_ hdst).storeWords, ?_⟩
  · rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    omega
  · simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
      decide_eq_true_eq, ge_iff_le, Nat.not_le]
    omega

/-- The loop from word `i`, `k + 1` words left. -/
theorem loop (dst src : Pointer) (len : BitVec 64) (m₀ : MemoryState) (a : AllocState) :
    ∀ k i (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value dst) (.value src) (.value len)).get →
        (E ⊨ [%262 := 3#64, %264 := 1#64, %265 := len >>> 3, %266 := BitVec.ofNat 64 i]) →
        i + k + 1 = (len >>> 3).toNat →
        (len >>> 3).toNat < 2 ^ 60 →
        S.WF →
        S.alloc = a →
        S.mem = m₀.storeWords dst (spec m₀ src) i →
        Room m₀ dst (64 * (len >>> 3).toNat) →
        dst.offset.toNat + 8 * (len >>> 3).toNat < 2 ^ 64 →
        Fits m₀ src (64 * (len >>> 3).toNat) →
        src.offset.toNat + 8 * (len >>> 3).toNat < 2 ^ 64 →
        (Range.of dst (64 * (len >>> 3).toNat)).Disjoint (Range.of src (64 * (len >>> 3).toNat)) →
        be64enc_vect.runFrom E 1 S =
          .value
            (.nil, { alloc := a, mem := m₀.storeWords dst (spec m₀ src) (len >>> 3).toNat }) := by
  intro k
  induction k with
  | zero =>
    intro i S E hArgs hR hk hn hwf hA hM hdst hdsto hsrc hsrco hdisj
    block_init
    step_pure [shl3_ushr3 i (by omega), shl3_sshr3 i (by omega)]
    have h8 : 8 * i < 18446744073709551616 := by omega
    have hi : i < 18446744073709551616 := by omega
    obtain ⟨hfs, hrs⟩ :=
      src_word (f := spec m₀ src) (j := i) hsrc hsrco hdsto hdisj
        (show i < (len >>> 3).toNat by omega) (by omega)
    obtain ⟨hrd, hdo⟩ :=
      dst_word (f := spec m₀ src) (j := i) hdst hdsto (show i < (len >>> 3).toNat by omega)
    rw [← hM] at hfs hrs hrd
    step_pure [shl3_eq, Nat.mod_eq_of_lt h8, h8]
    step_pure [Nat.mod_eq_of_lt hi, Nat.mul_comm i 8, h8]
    step_load consuming hfs hrs
    step_call using store64_be.call_eq
    step_pure [saddOverflow_ofNat64 (i := i) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 1) (by omega)]
    step_pure
    finish_block
    · block_init
      finish_block
      rw [hS, hM, hA, show (len >>> 3).toNat = i + 1 by omega]
      rfl
    · exact absurd ((ofNat64_add_one_eq_iff (by omega)).2 (by omega)) hbr
  | succ k ih =>
    intro i S E hArgs hR hk hn hwf hA hM hdst hdsto hsrc hsrco hdisj
    block_init
    have h8 : 8 * i < 18446744073709551616 := by omega
    have hi : i < 18446744073709551616 := by omega
    obtain ⟨hfs, hrs⟩ :=
      src_word (f := spec m₀ src) (j := i) hsrc hsrco hdsto hdisj
        (show i < (len >>> 3).toNat by omega) (by omega)
    obtain ⟨hrd, hdo⟩ :=
      dst_word (f := spec m₀ src) (j := i) hdst hdsto (show i < (len >>> 3).toNat by omega)
    rw [← hM] at hfs hrs hrd
    step_pure [shl3_ushr3 i (by omega), shl3_sshr3 i (by omega)]
    step_pure [shl3_eq, Nat.mod_eq_of_lt h8, h8]
    step_pure [Nat.mod_eq_of_lt hi, Nat.mul_comm i 8, h8]
    step_load consuming hfs hrs
    step_call using store64_be.call_eq
    step_pure [saddOverflow_ofNat64 (i := i) (k := 1) (by omega),
      uaddOverflow_ofNat64 (i := i) (k := 1) (by omega)]
    step_pure
    finish_block
    · have := (ofNat64_add_one_eq_iff (by omega)).1 hbr
      omega
    · run_from using ih (i + 1)
      all_goals
        first
        | rfl
        | exact (BitVec.ofNat_add i 1).symm

end be64enc_vect

/-- `be64enc_vect(dst, src, len)` stores the `len / 8 ≥ 1` words at `src` big-endian at `dst`, as
they were before: `dst`'s range must not overlap `src`'s. -/
public theorem be64enc_vect.call_eq (dst src : Pointer) (len : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hn1 : 1 ≤ (len >>> 3).toNat) (hn : (len >>> 3).toNat < 2 ^ 60)
    (hdst : Room s.mem dst (64 * (len >>> 3).toNat))
    (hdsto : dst.offset.toNat + 8 * (len >>> 3).toNat < 2 ^ 64)
    (hsrc : Fits s.mem src (64 * (len >>> 3).toNat))
    (hsrco : src.offset.toNat + 8 * (len >>> 3).toNat < 2 ^ 64)
    (hdisj :
      (Range.of dst (64 * (len >>> 3).toNat)).Disjoint (Range.of src (64 * (len >>> 3).toNat))) :
    be64enc_vect.call (be64enc_vect.args (.value dst) (.value src) (.value len)) s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeWords dst (be64enc_vect.spec s.mem src) (len >>> 3).toNat }) := by
  func_init
  have hdst₀ : Room S₀.mem dst (64 * (len >>> 3).toNat) := hS ▸ hdst
  have hsrc₀ : Fits S₀.mem src (64 * (len >>> 3).toNat) := hS ▸ hsrc
  block_init
  iterate 4 step_pure
  finish_block
  run_from using be64enc_vect.loop dst src len S₀.mem S₀.alloc ((len >>> 3).toNat - 1) 0
  all_goals rfl

end Proof

end MLIR.Sodium
