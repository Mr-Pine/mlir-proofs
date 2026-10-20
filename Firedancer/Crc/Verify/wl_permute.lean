module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.R52x5.Common.Wl
public import Firedancer.Crc.Verify.Mlir.wl_permute

/-! crc's `wl_permute` is Firedancer's (`fd_avx_wl.h`); its region differs from mlir-proofs' only in
the `getelementptr` element type (`i64` for `!llvm.array<8 x i8>`), so the proof is the steps of their
`MLIR.Firedancer.R52x5.wl_permute.call_eq`. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5 (Wl wlPermute)

/-! ## Proof -/

section Proof

/-- An index below 4: `zext nneg` and the `getelementptr` by it neither poison nor wrap. -/
private theorem idx_facts {i : BitVec 32} (h : i.toNat < 4) :
    i.msb = false ∧ i.toNat % 18446744073709551616 = i.toNat ∧ i.toNat * 8 < 18446744073709551616 :=
  ⟨by
    rw [BitVec.msb_eq_false_iff_two_mul_lt]; omega, Nat.mod_eq_of_lt (by omega), by omega⟩

/-- Lane `k` of the slot `t`: in its `Fits`. -/
private theorem lane_fits {m : MemoryState} {t : Pointer} (h : Fits m t 256) (ho : t.offset = 0)
    (hk : k < 4) : Fits m (t.add (BitVec.ofNat 64 (k * 8))) 64 :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow, ho]; omega)
    (by
      simp; omega)
    h

/-- Lane `k` of the slot `t` holding `x`: `x[k]`. -/
private theorem lane_read {m : MemoryState} {t : Pointer} {x : Wl} (h : Fits m t 256)
    (ho : t.offset = 0) (hr : m.readAt t 256 = BitVec.packLanes x) (hk : k < 4) :
    m.readAt (t.add (BitVec.ofNat 64 (k * 8))) 64 = x[k] := by
  rw [MemoryState.readAt_add_of_readAt h.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      hr]
  have e : (BitVec.ofNat 64 (k * 8)).toNat * 8 = k * 64 := by
    simp; omega
  rw [e, BitVec.extractLsb'_packLanes x k hk]

set_option hygiene false in
/-- `u.l[k] = t.l[ imm_ik ]`'s `zext`, `getelementptr` and `load`, the lane named `v`. -/
local macro "lane " hk:ident v:ident : tactic =>
  `(tactic|
    ( have hf := lane_fits hfits_t ht_off $hk
      have hr := lane_read hfits_t ht_off hread_t $hk
      obtain ⟨hm, hmod, hmul⟩ := idx_facts $hk
      step_pure
      step_pure [hm, hmod, hmul]
      step_load with $v:ident
      clear hf hr hm hmod hmul))

/-- `wl_permute( x, imm_i0, imm_i1, imm_i2, imm_i3 )` returns lanes `imm_ik` of `x`, each below 4;
its union `t` is freed, the counter moves on by one block. -/
public theorem wl_permute.call_eq (x : Wl) (i0 i1 i2 i3 : BitVec 32) (s : GlobalState) (hwf : s.WF)
    (hi : i0.toNat < 4 ∧ i1.toNat < 4 ∧ i2.toNat < 4 ∧ i3.toNat < 4) :
    wl_permute.call (wl_permute.args (Ty.wrap x) (.value i0) (.value i1) (.value i2) (.value i3))
        s =
      .value
        (.cons (Ty.wrap (wlPermute x i0.toNat i1.toNat i2.toNat i3.toNat)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  func_init
  block_init
  iterate 6 step_pure
  -- _mm256_store_si256( t.v, x );
  step_alloca with t
  step_pure
  step_store
  -- u.l[k] = t.l[ imm_ik ];
  lane h0 l0
  step_pure
  lane h1 l1
  step_pure
  lane h2 l2
  step_pure
  lane h3 l3
  step_pure
  step_pure
  finish_block
  subst hS
  erase_frame
  subst_vars
  congr 3
  ext k hk
  simp only [Ty.wrap_vec, wlPermute, Nat.mod_eq_of_lt h0, Nat.mod_eq_of_lt h1, Nat.mod_eq_of_lt h2,
    Nat.mod_eq_of_lt h3]
  obtain rfl | rfl | rfl | rfl : k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 := by omega
  all_goals simp

end Proof

end MLIR.Firedancer.Crc.Verify
