module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_limbs_is_zero
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_limbs_eq
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y0
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_order8_y1
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_affine_is_small_order

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

/-! ## Specification -/

@[expose] public section

/-- The limbs of `fd_r52x5_order8_y0`, the y-coordinate of an order-8 point. -/
def fd_r52x5_order8_y0.limbs : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 2166873539340326
  | ⟨1, _⟩ => 1778179147085316
  | ⟨2, _⟩ => 1886209374839743
  | ⟨3, _⟩ => 1223329526802818
  | ⟨4, _⟩ => 105300633354275

/-- The limbs of `fd_r52x5_order8_y1`, the y-coordinate of the other order-8 points. -/
def fd_r52x5_order8_y1.limbs : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 84926274344903
  | ⟨1, _⟩ => 473620666599931
  | ⟨2, _⟩ => 365590438845504
  | ⟨3, _⟩ => 1028470286882429
  | ⟨4, _⟩ => 2146499180330972

/-- `fd_r52x5_affine_is_small_order( cx, cy )`: `1` when `x = 0`, `y = 0`, or `y` is one of the
order-8 points' `y`, tested in that order, else `0`. -/
def fd_r52x5_affine_is_small_order.spec (x y : Fin 5 → BitVec 64) : BitVec 32 :=
  if fd_r52x5_limbs_is_zero.spec x ≠ 0 then 1
  else if fd_r52x5_limbs_is_zero.spec y ≠ 0 then 1
  else if fd_r52x5_limbs_eq.spec y fd_r52x5_order8_y0.limbs ≠ 0 then 1
  else fd_r52x5_limbs_eq.spec y fd_r52x5_order8_y1.limbs

end

/-! ## Proof -/

section Proof

public theorem fd_r52x5_order8_y0.value_eq (s : GlobalState) :
    fd_r52x5_order8_y0.value s = .value (Ty.wrap fd_r52x5_order8_y0.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

public theorem fd_r52x5_order8_y1.value_eq (s : GlobalState) :
    fd_r52x5_order8_y1.value s = .value (Ty.wrap fd_r52x5_order8_y1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- A global of five limbs at offset 0: its limbs fit. -/
public theorem limbsFit_of_fits320 {m : MemoryState} {p : Pointer} (h : Fits m p 320) (ho : p.offset = 0#64) :
    m.LimbsFit p :=
  MemoryState.LimbsFit.of_fits h (by simpa using ho)

public theorem fd_r52x5_order8_y0_readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 5 (.bv 64)).width = 320} (hf : Fits m p 320) (ho : p.offset = 0#64)
    (h : m.readAt p 320 = Ty.flatBits fd_r52x5_order8_y0.lit (hw := hw)) :
    m.readLimbs p = fd_r52x5_order8_y0.limbs := by
  rw [Ty.flatBits_eq] at h
  rw [MemoryState.readLimbs_of_readAt hf (by simpa using ho) h]
  funext i
  fin_cases i <;>
    simp (disch := decide) only [BitVec.extractLsb'_cast, Ty.extractLsb'_flattenRaw_array,
      Ty.extractLsb'_flattenRaw_bv] <;>
    simp [Ty.stride, Ty.width, Ty.padding, Ty.align, fd_r52x5_order8_y0.limbs] <;> rfl

public theorem fd_r52x5_order8_y1_readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 5 (.bv 64)).width = 320} (hf : Fits m p 320) (ho : p.offset = 0#64)
    (h : m.readAt p 320 = Ty.flatBits fd_r52x5_order8_y1.lit (hw := hw)) :
    m.readLimbs p = fd_r52x5_order8_y1.limbs := by
  rw [Ty.flatBits_eq] at h
  rw [MemoryState.readLimbs_of_readAt hf (by simpa using ho) h]
  funext i
  fin_cases i <;>
    simp (disch := decide) only [BitVec.extractLsb'_cast, Ty.extractLsb'_flattenRaw_array,
      Ty.extractLsb'_flattenRaw_bv] <;>
    simp [Ty.stride, Ty.width, Ty.padding, Ty.align, fd_r52x5_order8_y1.limbs] <;> rfl

/-- `fd_r52x5_affine_is_small_order( cx, cy )` returns `spec` of the limbs at `cx` and `cy`. -/
public theorem fd_r52x5_affine_is_small_order.call_eq (cx cy : Pointer) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals fd_r52x5_affine_is_small_order.globals)
    (hx : s.mem.LimbsFit cx) (hy : s.mem.LimbsFit cy) :
    fd_r52x5_affine_is_small_order.call
        (fd_r52x5_affine_is_small_order.args (.value cx) (.value cy)) s =
      .value
        (.cons (.value (fd_r52x5_affine_is_small_order.spec (s.mem.readLimbs cx)
            (s.mem.readLimbs cy))) .nil, s) := by
  func_init
  block_init
  iterate 2 step_pure
  step_addressof fd_r52x5_order8_y0.value_eq with y0
  step_addressof fd_r52x5_order8_y1.value_eq with y1
  have hl0 := fd_r52x5_order8_y0_readLimbs hy0_fits hy0_off hread_y0
  have hl1 := fd_r52x5_order8_y1_readLimbs hy1_fits hy1_off hread_y1
  have hf0 := limbsFit_of_fits320 hy0_fits hy0_off
  have hf1 := limbsFit_of_fits320 hy1_fits hy1_off
  step_call using fd_r52x5_limbs_is_zero.call_eq
  step_pure
  finish_block
  · block_init
    step_call using fd_r52x5_limbs_is_zero.call_eq
    step_pure
    finish_block
    · block_init
      step_call using fd_r52x5_limbs_eq.call_eq
      step_pure
      finish_block
      · block_init
        step_call using fd_r52x5_limbs_eq.call_eq
        finish_block
        block_init
        finish_block
        subst_vars
        simp [fd_r52x5_affine_is_small_order.spec, *]
      · block_init
        finish_block
        subst_vars
        simp [fd_r52x5_affine_is_small_order.spec, *]
    · block_init
      finish_block
      subst_vars
      simp [fd_r52x5_affine_is_small_order.spec, *]
  · block_init
    finish_block
    subst_vars
    simp [fd_r52x5_affine_is_small_order.spec, *]

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
