module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_affine_is_small_order
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_lane_canon
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.Crc.Ed25519.Avx512.QuadRuns
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_ge_is_small_order_affine

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_ge_is_small_order_affine( a )`: `fd_r52x5_affine_is_small_order` of the canonical
lanes 0 and 1 (`x`, `y`) of the point `A`. -/
def fd_r52x5_ge_is_small_order_affine.spec (A : Quad5) : BitVec 32 :=
  fd_r52x5_affine_is_small_order.spec (fd_r52x5_quad_lane_canon.spec A 0)
    (fd_r52x5_quad_lane_canon.spec A 1)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_ge_is_small_order_affine( a )` returns `spec` of the point at `a`; its two limb
arrays and the lane extracts use up 14 block ids. -/
public theorem fd_r52x5_ge_is_small_order_affine.call_eq (a : Pointer) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals fd_r52x5_ge_is_small_order_affine.globals)
    (ha : s.mem.Quad5Fit a) :
    fd_r52x5_ge_is_small_order_affine.call (fd_r52x5_ge_is_small_order_affine.args (.value a)) s =
      .value
        (.cons (.value (fd_r52x5_ge_is_small_order_affine.spec (s.mem.readQuad5 a))) .nil,
          { s with alloc := ⟨s.alloc.nextFreeBlock + 14⟩ }) := by
  func_init
  block_init
  iterate 2 step_pure
  step_addressof fd_r52x5_order8_y0.value_eq with y0
  step_addressof fd_r52x5_order8_y1.value_eq with y1
  have hl0 := fd_r52x5_order8_y0_readLimbs hy0_fits hy0_off hread_y0
  have hl1 := fd_r52x5_order8_y1_readLimbs hy1_fits hy1_off hread_y1
  have hf0 := limbsFit_of_fits320 hy0_fits hy0_off
  have hf1 := limbsFit_of_fits320 hy1_fits hy1_off
  clear hread_y0 hread_y1 hg hglobal_y0 hglobal_y1 hy0_live hy1_live hy0_fits hy1_fits
  step_alloca with cx
  step_alloca with cy
  have hlta := hwf₀.lt ha₀.inBounds.mem
  step_pattern' using runBodyFrom_quad5LoadRun inline
  have eqa : Q = S₀.mem.readQuad5 a := by
    rw [hQ, hS]
    simp (disch := (try simp only [GlobalState.alloca_alloc]); omega) only
      [MemoryState.readQuad5_alloca_lt]
  subst eqa
  clear hlta hQ ha
  iterate 2 step_pure
  have hrx := MemoryState.LimbsRoom.of_room hroom_cx hcx_off
  have hry := MemoryState.LimbsRoom.of_room hroom_cy hcy_off
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := S₀.mem.readQuad5 a) (hl := by decide))
    consuming hrx
  have hry := hry.storeLimbs (q := cx) (l := fd_r52x5_quad_lane_canon.spec (S₀.mem.readQuad5 a) 0)
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := S₀.mem.readQuad5 a) (hl := by decide))
    consuming hry
  rename_i hfy hrx0 hry0
  clear hrx0 hry0 hry hwritable_cx hcx_bounds hwritable_cy hcy_bounds hroom_cx hroom_cy
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
        clear hfy hread_cy hread_cx hl0 hl1 hrx hwf hf0 hf1
        iterate 2 step_pure
        finish_block
        subst hS
        erase_frame
        simp only [GlobalState.alloca] at *
        simp_all [fd_r52x5_ge_is_small_order_affine.spec, fd_r52x5_affine_is_small_order.spec]
      · block_init
        clear hfy hread_cy hread_cx hl0 hl1 hrx hwf hf0 hf1
        iterate 2 step_pure
        finish_block
        subst hS
        erase_frame
        simp only [GlobalState.alloca] at *
        simp_all [fd_r52x5_ge_is_small_order_affine.spec, fd_r52x5_affine_is_small_order.spec]
    · block_init
      clear hfy hread_cy hread_cx hl0 hl1 hrx hwf hf0 hf1
      iterate 2 step_pure
      finish_block
      subst hS
      erase_frame
      simp only [GlobalState.alloca] at *
      simp_all [fd_r52x5_ge_is_small_order_affine.spec, fd_r52x5_affine_is_small_order.spec]
  · block_init
    clear hfy hread_cy hread_cx hl0 hl1 hrx hwf hf0 hf1
    iterate 2 step_pure
    finish_block
    subst hS
    erase_frame
    simp only [GlobalState.alloca] at *
    simp_all [fd_r52x5_ge_is_small_order_affine.spec, fd_r52x5_affine_is_small_order.spec]

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
