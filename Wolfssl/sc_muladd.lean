module

public import MLIR.Run.Tactic
public import Wolfssl.Mlir.sc_muladd
public import Firedancer.Common.Memory

/-! `sc_muladd(s, a, b, c)` run on one input: `a = 4ℓ - 1`, `b = 4ℓ + 1`, `c = 0`. Every value the
steps compute is a literal, so the run needs no specification; `Wolfssl.Math.Scalar` shows the
result is not `a * b + c` modulo `ℓ`. -/

namespace MLIR.Wolfssl

open _root_.Wolfssl.Mlir

/-! ## Proof -/

section Proof

-- the `zext nneg` tests on literals
attribute [local simp] BitVec.msb_eq_decide

-- One block of 557 instructions on 128-bit literals, stepped in one declaration.
set_option maxHeartbeats 4000000 in
/-- On separate buffers holding `a = 4ℓ - 1` and `b = 4ℓ + 1` (`ℓ = 2^252 + …`) and `c = 0`,
`sc_muladd` returns, having stored 32 bytes of `0xff` at `s`. -/
public theorem sc_muladd.call_counterexample (s a b c : Pointer) (st : GlobalState) (hwf : st.WF)
    (hs : Room st.mem s 256) (hs_off : ¬s.offset.uaddOverflow 32#64)
    (ha : Fits st.mem a 256) (ha_off : ¬a.offset.uaddOverflow 32#64)
    (hb : Fits st.mem b 256) (hb_off : ¬b.offset.uaddOverflow 32#64)
    (hc : Fits st.mem c 256) (hc_off : ¬c.offset.uaddOverflow 32#64)
    (hsep : [s.id, a.id, b.id, c.id].Nodup)
    (hA :
      st.mem.readAt a 256 = 0x40000000000000000000000000000000537be77a8bde735960498c6973d74fb3#256)
    (hB :
      st.mem.readAt b 256 = 0x40000000000000000000000000000000537be77a8bde735960498c6973d74fb5#256)
    (hC : st.mem.readAt c 256 = 0#256) :
    sc_muladd.call (sc_muladd.args (.value s) (.value a) (.value b) (.value c)) st =
      .value (.nil, { st with mem := st.mem.storeAt s (BitVec.allOnes 256) }) := by
  func_init
  block_init
  -- the constants
  iterate 34 step_pure
  -- `a`, `b`, `c` loaded as 42-bit limbs
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 5 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 4 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 4 step_pure
  step_load
  -- the products, the reduction, and the first bytes of `s`
  iterate 202 step_pure
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  iterate 2 step_pure
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  -- the stores of `s[0] … s[31]`
  step_store
  iterate 3 step_pure
  step_store
  iterate 7 step_pure
  step_store
  iterate 3 step_pure
  step_store
  iterate 7 step_pure
  step_store
  iterate 3 step_pure
  step_store
  iterate 13 step_pure
  step_store
  iterate 2 step_pure
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_store
  iterate 3 step_pure
  step_store
  iterate 3 step_pure
  step_store
  iterate 7 step_pure
  step_store
  iterate 2 step_pure
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_store
  iterate 3 step_pure
  step_store
  finish_block
  subst hS
  rw [MemoryState.storeAt_storeAt_append (a := 32) (k := 4)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 40) (k := 5)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 48) (k := 6)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 80) (k := 10)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 88) (k := 11)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 120) (k := 15)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 128) (k := 16)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 192) (k := 24)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 200) (k := 25)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 208) (k := 26)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 216) (k := 27)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (a := 248) (k := 31)
      (BitVec.not_uaddOverflow_of_le hs_off (by decide)) rfl (by decide)]
  refine
    congrArg
      (fun v =>
        PoisonOr.value (Vals.nil, ({ alloc := S₀.alloc, mem := S₀.mem.storeAt s v } : GlobalState)))
      ?_
  decide +kernel

end Proof

end MLIR.Wolfssl
