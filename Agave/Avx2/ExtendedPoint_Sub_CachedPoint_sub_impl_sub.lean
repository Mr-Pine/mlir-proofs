module

public import MLIR.Run.Tactic
public import Agave.Common.ExtendedPoint
public import Agave.Avx2.ExtendedPoint_Add_CachedPoint_add_impl_add
public import Agave.Avx2.Mlir.ExtendedPoint_Sub_CachedPoint_sub_impl_sub
import Mathlib.Tactic.FinCases

namespace MLIR.Agave.Avx2

open Fe2625x4

/-! ## Specification -/

@[expose] public section

/-- `-&other`: `A` and `B` swapped, `D` negated through `negate_lazy`. -/
def cachedNeg (x : Fe2625x4) : Fe2625x4 :=
  let swapped := shuffle x Shuffle.BACD
  blend swapped (negateLazy swapped) Lanes.D

/-- `self - other`: `self + &(-other)`. -/
def ExtendedPoint_Sub_CachedPoint_sub_impl_sub.spec (P Q : Fe2625x4) : Fe2625x4 :=
  ExtendedPoint_Add_CachedPoint_add_impl_add.spec P (cachedNeg Q)

end

/-! ## Proof -/

section Proof

/-- Register `i` of `-&other` as the lifted code computes it, `p`, `q` its `2p` limbs. -/
def negReg (b : Vector (BitVec 32) 8) (p q : BitVec 32) : Vector (BitVec 32) 8 :=
  #v[b[1], b[0], b[3], b[2], b[4], p - b[5], b[6], q - b[7]]

theorem cachedNeg_eq (X : Fe2625x4) :
    cachedNeg X =
      ![negReg (X 0) 134217690 67108862, negReg (X 1) 134217726 67108862,
        negReg (X 2) 134217726 67108862, negReg (X 3) 134217726 67108862,
        negReg (X 4) 134217726 67108862] := by
  funext i
  fin_cases i <;> rfl

set_option maxHeartbeats 1000000 in
/-- `self - other` stores `spec self other` at `out`; `-other` goes to a slot first, so `out` may
alias either input. -/
public theorem ExtendedPoint_Sub_CachedPoint_sub_impl_sub.call_eq (out p q : Pointer)
    (s : GlobalState) (hwf : s.WF) (hout : s.mem.Fe4xRoom out) (hp : s.mem.Fe4xFit p)
    (hq : s.mem.Fe4xFit q) :
    ExtendedPoint_Sub_CachedPoint_sub_impl_sub.call
        (ExtendedPoint_Sub_CachedPoint_sub_impl_sub.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 7⟩,
            mem :=
              s.mem.storeFe4x out
                (ExtendedPoint_Sub_CachedPoint_sub_impl_sub.spec (s.mem.readFe4x p)
                  (s.mem.readFe4x q)) }) := by
  func_init
  obtain ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩ := hout
  obtain ⟨hpoff, hpf0, hpf1, hpf2, hpf3, hpf4⟩ := hp
  obtain ⟨hqoff, hqf0, hqf1, hqf2, hqf3, hqf4⟩ := hq
  block_init
  iterate 30 step_pure
  step_alloca
  step_pure
  step_load with b0
  step_pure
  step_load with b1
  step_pure
  step_load with b2
  step_pure
  step_load with b3
  iterate 5 step_pure
  step_load with b4
  iterate 6 step_pure
  -- CachedPoint(swapped.blend(swapped.negate_lazy(), Lanes::D))
  step_pure with n0
  step_pure with n1
  step_pure with n2
  step_pure with n3
  step_pure with n4
  step_store
  iterate 4 
    step_pure
    step_store
  rw [MemoryState.storeFe4x_eq] at hS
  -- self + &(-other)
  step_call using
    (ExtendedPoint_Add_CachedPoint_add_impl_add.call_eq (hout := ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩)
      (hp := ⟨hpoff, hpf0, hpf1, hpf2, hpf3, hpf4⟩) (hq :=
      ⟨by
        rw [hv30_off]; decide, hfits_v30, hfits_v30_32, hfits_v30_64, hfits_v30_96, hfits_v30_128⟩))
  step_pure
  finish_block
  change b0 = S₀.mem.readFe4x q 0 at hb0
  change b1 = S₀.mem.readFe4x q 1 at hb1
  change b2 = S₀.mem.readFe4x q 2 at hb2
  change b3 = S₀.mem.readFe4x q 3 at hb3
  change b4 = S₀.mem.readFe4x q 4 at hb4
  change n0 = negReg b0 134217690 67108862 at hn0
  change n1 = negReg b1 134217726 67108862 at hn1
  change n2 = negReg b2 134217726 67108862 at hn2
  change n3 = negReg b3 134217726 67108862 at hn3
  change n4 = negReg b4 134217726 67108862 at hn4
  subst hn0 hn1 hn2 hn3 hn4 hb0 hb1 hb2 hb3 hb4
  rw [← cachedNeg_eq] at hS
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Agave.Avx2
