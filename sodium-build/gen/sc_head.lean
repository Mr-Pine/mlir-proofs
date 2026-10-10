module

public import Boringssl.Common.Bounds
public import Boringssl.x25519_sc_reduce
public import MLIR.Run.Tactic
public import Sodium.Mlir.sc25519_reduce
public import Sodium.load_3
public import Sodium.load_4
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! libsodium's `sc25519_reduce` is ref10's reduction, BoringSSL's `x25519_sc_reduce` with its
carries as `carry * (1 << 21)`: its spec is BoringSSL's, `s mod ℓ` by
`Boringssl.x25519_sc_reduce.spec_val`. The compiler folds those products into masks
(`(s + 2^20) & -2^21`), which `ir_eq_spec` turns back into shifted carries. -/

namespace MLIR.Sodium

open MLIR.Firedancer.Ref
open MLIR.Boringssl.x25519_sc_reduce (load3 load4)

/-! ## Bounds -/

/-- `load_3(s + k)`'s pointer does not wrap. -/
theorem sc25519_reduce.off3 {p : Pointer} (h : ¬p.offset.uaddOverflow 64#64) (k : Nat)
    (hk : k + 3 ≤ 64) : ¬(p.add (BitVec.ofNat 64 k)).offset.uaddOverflow 3#64 := by
  have e : (64#64).toNat = 64 := rfl
  simp only [BitVec.uaddOverflow, Pointer.add, e] at h ⊢
  simp at h ⊢
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- A 24-bit value shifted right by `3` fits the mask. -/
theorem sc25519_reduce.nomask3_3 (y : BitVec 24) :
    y.setWidth 64 >>> 3 = 2097151#64 &&& y.setWidth 64 >>> 3 := by
  bv_decide

/-- `shl nuw` by `k ≤ 7` of a value below `2^57` (`x * 2^7` does not wrap) loses no bits. -/
theorem sc25519_reduce.shl_nuw (x : BitVec 64) (k : Nat)
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7)
    (h : x.umulOverflow 128#64 = false) : x <<< k >>> k = x := by
  have hlt : x.ult 144115188075855872#64 := by
    simp only [BitVec.umulOverflow, BitVec.toNat_ofNat] at h
    simp only [BitVec.ult_iff_lt, BitVec.lt_def, BitVec.toNat_ofNat]
    simp at h
    omega
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `shl nsw` by `k ≤ 7` of a value in `[-2^56, 2^56)` (`x * 2^7` does not overflow) keeps its
sign bits. -/
theorem sc25519_reduce.shl_nsw (x : BitVec 64) (k : Nat)
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7)
    (h : x.smulOverflow 128#64 = false) : (x <<< k).sshiftRight k = x := by
  have e : (128#64).toInt = 128 := by decide
  simp only [BitVec.smulOverflow, e] at h
  simp at h
  have h0 : (-72057594037927936#64).sle x := by
    rw [BitVec.sle_iff_toInt_le]; simp; omega
  have h3 : x.slt 72057594037927936#64 := by
    rw [BitVec.slt_iff_toInt_lt]; simp; omega
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `or disjoint` of a limb shifted left by `k` and the next lower limb, below `2^21`, shifted right
by `21 - k`. -/
theorem sc25519_reduce.or_disj (x y : BitVec 64) (k : Nat)
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7)
    (h : y.umulOverflow 8796093022208#64 = false) : x <<< k &&& y >>> (21 - k) = 0#64 := by
  have hlt : y.ult 2097152#64 := by
    simp only [BitVec.umulOverflow, BitVec.toNat_ofNat] at h
    simp only [BitVec.ult_iff_lt, BitVec.lt_def, BitVec.toNat_ofNat]
    simp at h
    omega
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> bv_decide

/-- `or disjoint` of a limb shifted left by `5` and the next lower limb's bits `16 … 20`. -/
theorem sc25519_reduce.or_disj_mask (x y : BitVec 64) :
    x <<< 5 &&& (y >>> 16 &&& 31#64) = 0#64 := by
  bv_decide
