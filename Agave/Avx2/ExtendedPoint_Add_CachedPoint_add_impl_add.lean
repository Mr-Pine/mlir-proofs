module

public import MLIR.Run.Tactic
public import Agave.Common.ExtendedPoint
public import Agave.Avx2.FieldElement2625x4_Mul_mul_impl_mul
public import Agave.Avx2.Mlir.ExtendedPoint_Add_CachedPoint_add_impl_add

namespace MLIR.Agave.Avx2

open Fe2625x4

/-! ## Specification -/

@[expose] public section

/-- `self + other`, named as in the Rust: `(Y - X, Y + X, Z, T)` times the cached
`(Y - X, Y + X, 2 Z, 2d T)`, its `D` and `C` swapped and `diff_sum`'d, the `ADDA` and `CBCB`
shuffles multiplied. -/
def ExtendedPoint_Add_CachedPoint_add_impl_add.spec (P Q : Fe2625x4) : Fe2625x4 :=
  let tmp := blend P (diffSum P) Lanes.AB
  let tmp := FieldElement2625x4_Mul_mul_impl_mul.spec tmp Q
  let tmp := shuffle tmp Shuffle.ABDC
  let tmp := diffSum tmp
  let t0 := shuffle tmp Shuffle.ADDA
  let t1 := shuffle tmp Shuffle.CBCB
  FieldElement2625x4_Mul_mul_impl_mul.spec t0 t1

end

/-! ## Proof -/

section Proof

set_option maxHeartbeats 4000000 in
/-- `self + other` stores `spec self other` at `out`. Both inputs are read before `out` is written,
so it may alias either. -/
public theorem ExtendedPoint_Add_CachedPoint_add_impl_add.call_eq (out p q : Pointer)
    (s : GlobalState) (hwf : s.WF) (hout : s.mem.Fe4xRoom out) (hp : s.mem.Fe4xFit p)
    (hq : s.mem.Fe4xFit q) :
    ExtendedPoint_Add_CachedPoint_add_impl_add.call
        (ExtendedPoint_Add_CachedPoint_add_impl_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem :=
              s.mem.storeFe4x out
                (ExtendedPoint_Add_CachedPoint_add_impl_add.spec (s.mem.readFe4x p)
                  (s.mem.readFe4x q)) }) := by
  have hpf := hp.fits
  func_init
  obtain ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩ := hout
  obtain ⟨hpoff, hpf0, hpf1, hpf2, hpf3, hpf4⟩ := hp
  obtain ⟨hqoff, hqf0, hqf1, hqf2, hqf3, hqf4⟩ := hq
  block_init
  iterate 47 step_pure
  step_alloca
  step_alloca
  step_alloca
  step_alloca
  step_pure
  -- let mut tmp = self.0;
  step_memcpy
  step_load with a0
  step_pure
  step_load with a1
  step_pure
  step_load with a2
  step_pure
  step_load with a3
  iterate 4 step_pure
  step_pure
  step_load with a4
  iterate 6 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  -- tmp = tmp.blend(tmp.diff_sum(), Lanes::AB);
  step_pure with x0
  step_pure with x1
  step_pure with x2
  step_pure with x3
  step_pure with x4
  iterate 5 step_store
  rw [MemoryState.storeFe4x_eq] at hS
  step_pure
  -- tmp = &tmp * &other.0;
  have hv49_fe4 := MemoryState.Fe4xRoom.of_room hroom_v49 (by simp [hv49_off])
  step_call using
    (FieldElement2625x4_Mul_mul_impl_mul.call_eq (hout := hv49_fe4) (hx :=
      MemoryState.Fe4xFit.of_fits hfits_v50 (by simp [hv50_off])) (hy :=
      ⟨hqoff, hqf0, hqf1, hqf2, hqf3, hqf4⟩))
  name_fe4 w
  have hw_fits := hv49_fe4.fits
  step_memcpy consuming hv49_fe4
  step_pure
  step_load with c0
  step_load with c1
  step_load with c2
  step_load with c3
  iterate 4 step_pure
  step_load with c4
  iterate 6 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  -- tmp = tmp.shuffle(Shuffle::ABDC); tmp = tmp.diff_sum();
  iterate 5 step_pure
  step_pure
  -- let t0 = tmp.shuffle(Shuffle::ADDA);
  step_pure with e0
  step_pure with e1
  step_pure with e2
  step_pure with e3
  step_pure with e4
  step_store
  iterate 4 
    step_pure
    step_store
  rw [MemoryState.storeFe4x_eq] at hS
  step_pure
  -- let t1 = tmp.shuffle(Shuffle::CBCB);
  step_pure with f0
  step_pure with f1
  step_pure with f2
  step_pure with f3
  step_pure with f4
  step_store
  iterate 4 
    step_pure
    step_store
  rw [MemoryState.storeFe4x_eq] at hS
  -- ExtendedPoint(&t0 * &t1)
  step_call using
    (FieldElement2625x4_Mul_mul_impl_mul.call_eq (hout := ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩) (hx :=
      ⟨by
        rw [hv48_off]; decide, hfits_v48, hfits_v48_32, hfits_v48_64, hfits_v48_96, hfits_v48_128⟩)
      (hy :=
      ⟨by
        rw [hv47_off]; decide, hfits_v47, hfits_v47_32, hfits_v47_64, hfits_v47_96, hfits_v47_128⟩))
  iterate 3 step_pure
  finish_block
  obtain ⟨r0, r1, r2, r3, r4⟩ := MemoryState.readAt_regs_of_1280 hpf₀.inBounds hpoff
  rw [r0] at ha0
  rw [r1] at ha1
  rw [r2] at ha2
  rw [r3] at ha3
  rw [r4] at ha4
  change a0 = S₀.mem.readFe4x p 0 at ha0
  change a1 = S₀.mem.readFe4x p 1 at ha1
  change a2 = S₀.mem.readFe4x p 2 at ha2
  change a3 = S₀.mem.readFe4x p 3 at ha3
  change a4 = S₀.mem.readFe4x p 4 at ha4
  change x0 = dsReg a0 134217690 67108862 at hx0
  change x1 = dsReg a1 134217726 67108862 at hx1
  change x2 = dsReg a2 134217726 67108862 at hx2
  change x3 = dsReg a3 134217726 67108862 at hx3
  change x4 = dsReg a4 134217726 67108862 at hx4
  rw [← hw] at hc0 hc1 hc2 hc3 hc4
  change e0 = permute (dsAbdcReg c0 134217690 67108862) Shuffle.ADDA at he0
  change e1 = permute (dsAbdcReg c1 134217726 67108862) Shuffle.ADDA at he1
  change e2 = permute (dsAbdcReg c2 134217726 67108862) Shuffle.ADDA at he2
  change e3 = permute (dsAbdcReg c3 134217726 67108862) Shuffle.ADDA at he3
  change e4 = permute (dsAbdcReg c4 134217726 67108862) Shuffle.ADDA at he4
  change f0 = permute (dsAbdcReg c0 134217690 67108862) Shuffle.CBCB at hf0
  change f1 = permute (dsAbdcReg c1 134217726 67108862) Shuffle.CBCB at hf1
  change f2 = permute (dsAbdcReg c2 134217726 67108862) Shuffle.CBCB at hf2
  change f3 = permute (dsAbdcReg c3 134217726 67108862) Shuffle.CBCB at hf3
  change f4 = permute (dsAbdcReg c4 134217726 67108862) Shuffle.CBCB at hf4
  subst he0 he1 he2 he3 he4 hf0 hf1 hf2 hf3 hf4 hc0 hc1 hc2 hc3 hc4
  have ht := dsAbdc_eq w
  rw [show
      ![permute (dsAbdcReg (w 0) 134217690 67108862) Shuffle.ADDA,
          permute (dsAbdcReg (w 1) 134217726 67108862) Shuffle.ADDA,
          permute (dsAbdcReg (w 2) 134217726 67108862) Shuffle.ADDA,
          permute (dsAbdcReg (w 3) 134217726 67108862) Shuffle.ADDA,
          permute (dsAbdcReg (w 4) 134217726 67108862) Shuffle.ADDA] =
        shuffle (diffSum (shuffle w Shuffle.ABDC)) Shuffle.ADDA
      by
      rw [ht]; rfl,
    show
      ![permute (dsAbdcReg (w 0) 134217690 67108862) Shuffle.CBCB,
          permute (dsAbdcReg (w 1) 134217726 67108862) Shuffle.CBCB,
          permute (dsAbdcReg (w 2) 134217726 67108862) Shuffle.CBCB,
          permute (dsAbdcReg (w 3) 134217726 67108862) Shuffle.CBCB,
          permute (dsAbdcReg (w 4) 134217726 67108862) Shuffle.CBCB] =
        shuffle (diffSum (shuffle w Shuffle.ABDC)) Shuffle.CBCB
      by
      rw [ht]; rfl] at hS
  clear ht
  subst hS
  erase_frame
  have hX := ds_eq (S₀.mem.readFe4x p)
  subst hw hx0 hx1 hx2 hx3 hx4 ha0 ha1 ha2 ha3 ha4
  rw [ExtendedPoint_Add_CachedPoint_add_impl_add.spec, hX]
  rfl
