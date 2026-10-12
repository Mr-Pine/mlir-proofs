module

public import MLIR.Run.Tactic
public import Sodium.Mlir.crypto_verify_n
import Std.Tactic.BVDecide
import Mathlib.Tactic.IntervalCases
import Mathlib.Data.Fin.Basic
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

namespace crypto_verify_n

/-- Sixteen packed one-bit lanes, lane `0` lowest. -/
theorem packLanes_ofFn16 (f : Fin 16 → Bool) (h : 16 = 16) :
    (BitVec.packLanes (Vector.ofFn fun i => BitVec.ofBool (f i))).cast h =
      BitVec.ofBool (f 15) ++ BitVec.ofBool (f 14) ++ BitVec.ofBool (f 13) ++
        BitVec.ofBool (f 12) ++
        BitVec.ofBool (f 11) ++
        BitVec.ofBool (f 10) ++
        BitVec.ofBool (f 9) ++
        BitVec.ofBool (f 8) ++
        BitVec.ofBool (f 7) ++
        BitVec.ofBool (f 6) ++
        BitVec.ofBool (f 5) ++
        BitVec.ofBool (f 4) ++
        BitVec.ofBool (f 3) ++
        BitVec.ofBool (f 2) ++
        BitVec.ofBool (f 1) ++
        BitVec.ofBool (f 0) := by
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  have e :=
    BitVec.extractLsb'_packLanes_of_lt (Vector.ofFn fun i => BitVec.ofBool (f i)) (s := j) (w := 1)
      (we := 1) (by omega) (by omega)
  have e' := congrArg (·.getLsbD 0) e
  simp only [BitVec.getLsbD_extractLsb', Nat.zero_lt_one, decide_true, Bool.true_and, Nat.div_one,
    Nat.mod_one, Nat.add_zero, Vector.getElem_ofFn] at e'
  rw [BitVec.getLsbD_cast, e']
  interval_cases j <;>
    simp only [BitVec.getLsbD_append, BitVec.getLsbD_ofBool, Nat.reduceLT, Nat.reduceSub,
      ↓reduceIte, decide_true, Bool.true_and, Nat.lt_irrefl] <;>
    rfl

/-- `_mm_movemask_epi8(_mm_cmpeq_epi32(z, 0))` on the lanes `a`, `b` of `z`, then
`((m + 1) >> 16) - 1`: `0` when `z = 0`, `-1` otherwise. -/
theorem ret_eq (a b : BitVec 64) (h : 16 = 16) :
    (BitVec.setWidth 32
              (BitVec.cast h
                (BitVec.packLanes
                  (Vector.ofFn fun i : Fin 16 =>
                    BitVec.ofBool
                      ([BitVec.extractLsb' 0 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 0 32 a == 0#32))),
                              BitVec.extractLsb' 8 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 0 32 a == 0#32))),
                              BitVec.extractLsb' 16 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 0 32 a == 0#32))),
                              BitVec.extractLsb' 24 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 0 32 a == 0#32))),
                              BitVec.extractLsb' 0 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 32 32 a == 0#32))),
                              BitVec.extractLsb' 8 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 32 32 a == 0#32))),
                              BitVec.extractLsb' 16 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 32 32 a == 0#32))),
                              BitVec.extractLsb' 24 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 32 32 a == 0#32))),
                              BitVec.extractLsb' 0 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 0 32 b == 0#32))),
                              BitVec.extractLsb' 8 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 0 32 b == 0#32))),
                              BitVec.extractLsb' 16 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 0 32 b == 0#32))),
                              BitVec.extractLsb' 24 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 0 32 b == 0#32))),
                              BitVec.extractLsb' 0 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 32 32 b == 0#32))),
                              BitVec.extractLsb' 8 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 32 32 b == 0#32))),
                              BitVec.extractLsb' 16 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool (BitVec.extractLsb' 32 32 b == 0#32))),
                              BitVec.extractLsb' 24 8
                                (BitVec.signExtend 32
                                  (BitVec.ofBool
                                    (BitVec.extractLsb' 32 32 b == 0#32)))][(i : ℕ)].slt
                        0#8)))) +
            1#32) >>>
          16 +
        4294967295#32 =
      if a = 0#64 ∧ b = 0#64 then 0#32 else -1#32 := by
  rw [packLanes_ofFn16 (fun i : Fin 16 => BitVec.slt _ 0#8) h]
  simp only [Fin.coe_ofNat_eq_mod, Nat.reduceMod, List.getElem_cons_zero, List.getElem_cons_succ]
  split <;> bv_decide

/-- `z`'s lanes, `(y[1] ^ x[1]) | (y[0] ^ x[0])`, are zero exactly when the 32 bytes `X` and `Y`
agree. -/
theorem lanes_eq_zero_iff (X Y : BitVec 256) {x0 y0 x1 y1 z1 : Vector (BitVec 64) 2}
    (hx0 : x0 = Vector.ofFn fun i => Ty.extractVecElem 2 64 i (X.setWidth 128))
    (hy0 : y0 = Vector.ofFn fun i => Ty.extractVecElem 2 64 i (Y.setWidth 128))
    (hx1 : x1 = Vector.ofFn fun i => Ty.extractVecElem 2 64 i (X.extractLsb' 128 128))
    (hy1 : y1 = Vector.ofFn fun i => Ty.extractVecElem 2 64 i (Y.extractLsb' 128 128))
    (hz1 : z1 = Vector.ofFn fun i => y1[↑i] ^^^ x1[↑i] ||| y0[↑i] ^^^ x0[↑i]) :
    (z1[0] = 0#64 ∧ z1[1] = 0#64) ↔ X = Y := by
  subst hz1 hx0 hy0 hx1 hy1
  simp only [Fin.getElem_fin, Vector.getElem_ofFn, Ty.extractVecElem_eq]
  bv_decide

/-- `((m + 1) >> 16) - 1` (`nsw`) does not wrap. -/
theorem shr16_sadd (a : BitVec 32) : (a >>> 16).saddOverflow 4294967295#32 = false := by bv_decide

end crypto_verify_n

/-- `crypto_verify_n(x_, y_, 32)`: `0` if the 32 bytes at `x_` and at `y_` agree, `-1` if not, the
loop run once; memory unchanged, the counter advanced by the six locals. -/
public theorem crypto_verify_n.call_eq (x_ y_ : Pointer) (s : GlobalState) (hwf : s.WF)
    (hx : Fits s.mem x_ 256) (hy : Fits s.mem y_ 256) (hxo : ¬x_.offset.uaddOverflow 32#64)
    (hyo : ¬y_.offset.uaddOverflow 32#64) :
    crypto_verify_n.call (crypto_verify_n.args (.value x_) (.value y_) (.value 32#32)) s =
      .value
        (.cons (.value (if s.mem.readAt x_ 256 = s.mem.readAt y_ 256 then 0#32 else -1#32)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩, mem := s.mem }) := by
  -- the bytes, and their two 16-byte halves
  obtain ⟨X, hX⟩ : ∃ X, s.mem.readAt x_ 256 = X := ⟨_, rfl⟩
  obtain ⟨Y, hY⟩ : ∃ Y, s.mem.readAt y_ 256 = Y := ⟨_, rfl⟩
  have hx_lo := MemoryState.readAt_of_readAt_le (w := 128) (by decide) hX
  have hy_lo := MemoryState.readAt_of_readAt_le (w := 128) (by decide) hY
  have hx_hi : s.mem.readAt (x_.add 16#64) 128 = X.extractLsb' 128 128 :=
    MemoryState.readAt_add_of_readAt hx.inBounds (BitVec.not_uaddOverflow_of_le hxo (by decide))
      (by decide) hX
  have hy_hi : s.mem.readAt (y_.add 16#64) 128 = Y.extractLsb' 128 128 :=
    MemoryState.readAt_add_of_readAt hy.inBounds (BitVec.not_uaddOverflow_of_le hyo (by decide))
      (by decide) hY
  rw [hX, hY]
  clear hX hY
  func_init
  replace hx_hi : S₀.mem.readAt (x_.add 16#64) 128 = X.extractLsb' 128 128 := hS ▸ hx_hi
  replace hy_hi : S₀.mem.readAt (y_.add 16#64) 128 = Y.extractLsb' 128 128 := hS ▸ hy_hi
  block_init
  iterate 10 step_pure
  -- volatile __m128i v1, v2, z; volatile int m; the volatile pointers x, y
  step_alloca with v1
  step_alloca with v2
  step_alloca with z
  step_alloca with m
  step_alloca with x
  step_alloca with y
  iterate 5 step_pure
  step_store
  step_pure
  step_store
  -- v1 = _mm_loadu_si128(&x[0]); v2 = _mm_loadu_si128(&y[0]); z = _mm_xor_si128(v1, v2);
  step_load
  step_load with x0
  step_store
  step_load
  step_load with y0
  step_store
  step_load
  step_load
  step_pure
  step_store
  -- 32 / 16 > 1
  step_pure
  finish_block
  -- i = 1: v1 = _mm_loadu_si128(&x[1]); v2 = _mm_loadu_si128(&y[1]);
  -- z = _mm_or_si128(z, _mm_xor_si128(v1, v2));
  block_init
  step_pure
  step_load
  step_pure
  step_load [hx_hi] with x1
  step_store
  step_load
  step_pure
  step_load [hy_hi] with y1
  step_store
  step_load
  step_load
  step_load
  step_pure
  step_pure with z1
  step_store
  -- i = 2 = 32 / 16
  step_pure
  finish_block
  -- m = _mm_movemask_epi8(_mm_cmpeq_epi32(z, zero)); v1 = zero; v2 = zero; z = zero;
  block_init
  step_load
  iterate 6 step_pure
  step_pure with mask
  step_store
  iterate 3 step_store
  -- return (int) (((uint32_t) m + 1U) >> 16) - 1;
  step_load
  iterate 2 step_pure
  step_pure [shr16_sadd]
  iterate 6 step_lifetime
  finish_block
  subst hS
  erase_frame
  have hret := ret_eq z1[0] z1[1] rfl
  rw [← hmask] at hret
  simp only [hret, lanes_eq_zero_iff X Y hx0 hy0 hx1 hy1 hz1]
  simp [GlobalState.alloca]

end Proof

end MLIR.Sodium
