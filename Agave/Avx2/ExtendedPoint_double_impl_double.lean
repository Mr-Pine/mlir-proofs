module

public import MLIR.Run.Tactic
public import Agave.Common.ExtendedPoint
public import Agave.Avx2.FieldElement2625x4_Mul_mul_impl_mul
public import Agave.Avx2.FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D
public import Agave.Avx2.Mlir.ExtendedPoint_double_impl_double

namespace MLIR.Agave.Avx2

open Fe2625x4

/-! ## Specification -/

@[expose] public section

/-- `self.double()`, named as in the Rust, sums in the code's operand order: `tmp0 = (X, Y, Z,
X + Y)`, squared with `D` negated, then `S_1 … S_2` combined into `(S₈, S₅, S₈, S₅)` and
`(S₉, S₆, S₉, S₆)` lanes, multiplied. -/
def ExtendedPoint_double_impl_double.spec (x : Fe2625x4) : Fe2625x4 :=
  let tmp0 := shuffle x Shuffle.ABAB
  let tmp1 := shuffle tmp0 Shuffle.BADC
  let tmp0 := blend x (add tmp1 tmp0) Lanes.D
  let tmp1 := FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec tmp0
  let S_1 := shuffle tmp1 Shuffle.AAAA
  let S_2 := shuffle tmp1 Shuffle.BBBB
  let tmp0 := blend (blend zero (dbl tmp1) Lanes.C) tmp1 Lanes.D
  let tmp0 := add tmp0 S_1
  let tmp0 := add tmp0 (blend zero S_2 Lanes.AD)
  let tmp0 := add tmp0 (blend zero (negateLazy S_2) Lanes.BC)
  let tmp1 := shuffle tmp0 Shuffle.DBBD
  let tmp0 := shuffle tmp0 Shuffle.CACA
  FieldElement2625x4_Mul_mul_impl_mul.spec tmp0 tmp1

end

/-! ## Proof -/

section Proof

/-- `tmp0.shuffle(CACA)` of register `b` as the code computes it, `P`, `Q` its `2p` limbs. -/
def cacaReg (b : Vector (BitVec 32) 8) (P Q : BitVec 32) : Vector (BitVec 32) 8 :=
  #v[b[4] <<< 1 + b[0] + (P - b[1]), b[0] + b[1], b[6] <<< 1 + b[2] + (Q - b[3]), b[2] + b[3],
    b[4] <<< 1 + b[0] + (P - b[1]), b[0] + b[1], b[6] <<< 1 + b[2] + (Q - b[3]), b[2] + b[3]]

/-- `tmp0.shuffle(DBBD)` of register `b` as the code computes it. -/
def dbbdReg (b : Vector (BitVec 32) 8) (P Q : BitVec 32) : Vector (BitVec 32) 8 :=
  #v[b[5] + b[0] + b[1], b[0] + (P - b[1]), b[7] + b[2] + b[3], b[2] + (Q - b[3]),
    b[0] + (P - b[1]), b[5] + b[0] + b[1], b[2] + (Q - b[3]), b[7] + b[2] + b[3]]

/-- The lanes combined after the square. -/
def post (tmp1 : Fe2625x4) : Fe2625x4 :=
  let S_1 := shuffle tmp1 Shuffle.AAAA
  let S_2 := shuffle tmp1 Shuffle.BBBB
  let tmp0 := blend (blend zero (dbl tmp1) Lanes.C) tmp1 Lanes.D
  let tmp0 := add tmp0 S_1
  let tmp0 := add tmp0 (blend zero S_2 Lanes.AD)
  add tmp0 (blend zero (negateLazy S_2) Lanes.BC)

/-- Register `b` of `post`, `P`, `Q` its `2p` limbs, zeros of `blend` kept. -/
def postReg (b : Vector (BitVec 32) 8) (P Q : BitVec 32) : Vector (BitVec 32) 8 :=
  #v[0 + b[0] + b[1] + 0, 0 + b[0] + 0 + (P - b[1]), 0 + b[2] + b[3] + 0, 0 + b[2] + 0 + (Q - b[3]),
    b[4] <<< 1 + b[0] + 0 + (P - b[1]), b[5] + b[0] + b[1] + 0, b[6] <<< 1 + b[2] + 0 + (Q - b[3]),
    b[7] + b[2] + b[3] + 0]

theorem post_eq (b : Fe2625x4) :
    post b =
      ![postReg (b 0) 134217690 67108862, postReg (b 1) 134217726 67108862,
        postReg (b 2) 134217726 67108862, postReg (b 3) 134217726 67108862,
        postReg (b 4) 134217726 67108862] := by
  funext i
  fin_cases i <;> rfl

theorem caca_reg (b : Vector (BitVec 32) 8) (P Q : BitVec 32) :
    permute (postReg b P Q) Shuffle.CACA = cacaReg b P Q := by
  simp [permute, postReg, cacaReg, Shuffle.CACA]

theorem dbbd_reg (b : Vector (BitVec 32) 8) (P Q : BitVec 32) :
    permute (postReg b P Q) Shuffle.DBBD = dbbdReg b P Q := by
  simp [permute, postReg, dbbdReg, Shuffle.DBBD]

theorem caca_eq (b : Fe2625x4) :
    shuffle (post b) Shuffle.CACA =
      ![cacaReg (b 0) 134217690 67108862, cacaReg (b 1) 134217726 67108862,
        cacaReg (b 2) 134217726 67108862, cacaReg (b 3) 134217726 67108862,
        cacaReg (b 4) 134217726 67108862] := by
  rw [post_eq]
  funext i
  fin_cases i <;> exact caca_reg _ _ _

theorem dbbd_eq (b : Fe2625x4) :
    shuffle (post b) Shuffle.DBBD =
      ![dbbdReg (b 0) 134217690 67108862, dbbdReg (b 1) 134217726 67108862,
        dbbdReg (b 2) 134217726 67108862, dbbdReg (b 3) 134217726 67108862,
        dbbdReg (b 4) 134217726 67108862] := by
  rw [post_eq]
  funext i
  fin_cases i <;> exact dbbd_reg _ _ _

/-- Register `a` of `self.0.blend(tmp0 + tmp1, Lanes::D)` as the code computes it. -/
def abReg (a : Vector (BitVec 32) 8) : Vector (BitVec 32) 8 :=
  #v[a[0], a[1], a[2], a[3], a[4], a[0] + a[1], a[6], a[2] + a[3]]

theorem tmp0_eq (X : Fe2625x4) :
    blend X (add (shuffle (shuffle X Shuffle.ABAB) Shuffle.BADC) (shuffle X Shuffle.ABAB)) Lanes.D =
      ![abReg (X 0), abReg (X 1), abReg (X 2), abReg (X 3), abReg (X 4)] := by
  funext i
  fin_cases i <;> rfl

set_option maxHeartbeats 4000000 in
/-- `self.double()` stores `spec x` at `out`; `x` is read first, so `out` may alias it. -/
public theorem ExtendedPoint_double_impl_double.call_eq (out x : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : s.mem.Fe4xRoom out) (hx : s.mem.Fe4xFit x) :
    ExtendedPoint_double_impl_double.call
        (ExtendedPoint_double_impl_double.args (.value out) (.value x)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem :=
              s.mem.storeFe4x out
                (ExtendedPoint_double_impl_double.spec (s.mem.readFe4x x)) }) := by
  func_init
  obtain ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩ := hout
  obtain ⟨hxoff, hxf0, hxf1, hxf2, hxf3, hxf4⟩ := hx
  block_init
  iterate 55 step_pure
  step_alloca
  step_alloca
  step_pure
  step_load with a0
  step_pure
  step_load with a1
  step_pure
  step_load with a2
  step_pure
  step_load with a3
  iterate 5 step_pure
  step_load with a4
  iterate 11 step_pure
  iterate 4 step_pure
  iterate 5 step_pure
  -- tmp0 = self.0.blend(tmp0 + tmp1, Lanes::D);
  step_pure with t0
  step_pure with t1
  step_pure with t2
  step_pure with t3
  step_pure with t4
  iterate 5 step_store
  rw [MemoryState.storeFe4x_eq] at hS
  -- tmp1 = tmp0.square_and_negate_D();
  have hv55_fe4 := MemoryState.Fe4xRoom.of_room hroom_v55 (by simp [hv55_off])
  step_call using
    (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.call_eq (hout := hv55_fe4)
      (hx :=
      ⟨by
        rw [hv56_off]; decide, hfits_v56, hfits_v56_32, hfits_v56_64, hfits_v56_96, hfits_v56_128⟩))
  name_fe4 sq
  step_load with b0
  step_load with b1
  step_load with b2
  step_load with b3
  iterate 4 step_pure
  step_load with b4
  clear hv55_fe4
  iterate 6 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  iterate 5 step_pure
  -- tmp1 = tmp0.shuffle(Shuffle::DBBD); tmp0 = tmp0.shuffle(Shuffle::CACA);
  step_pure with d0
  step_pure with d1
  step_pure with d2
  step_pure with d3
  step_pure with d4
  iterate 5 step_store
  rw [MemoryState.storeFe4x_eq] at hS
  step_pure with c0
  step_pure with c1
  step_pure with c2
  step_pure with c3
  step_pure with c4
  iterate 5 step_store
  rw [MemoryState.storeFe4x_eq] at hS
  -- ExtendedPoint(&tmp0 * &tmp1)
  step_call using
    (FieldElement2625x4_Mul_mul_impl_mul.call_eq (hout := ⟨hoff, ho0, ho1, ho2, ho3, ho4⟩) (hx :=
      ⟨by
        rw [hv56_off]; decide, hfits_v56, hfits_v56_32, hfits_v56_64, hfits_v56_96, hfits_v56_128⟩)
      (hy :=
      ⟨by
        rw [hv55_off]; decide, hfits_v55, hfits_v55_32, hfits_v55_64, hfits_v55_96, hfits_v55_128⟩))
  iterate 2 step_pure
  finish_block
  change a0 = S₀.mem.readFe4x x 0 at ha0
  change a1 = S₀.mem.readFe4x x 1 at ha1
  change a2 = S₀.mem.readFe4x x 2 at ha2
  change a3 = S₀.mem.readFe4x x 3 at ha3
  change a4 = S₀.mem.readFe4x x 4 at ha4
  change t0 = abReg a0 at ht0
  change t1 = abReg a1 at ht1
  change t2 = abReg a2 at ht2
  change t3 = abReg a3 at ht3
  change t4 = abReg a4 at ht4
  change c0 = cacaReg b0 134217690 67108862 at hc0
  change c1 = cacaReg b1 134217726 67108862 at hc1
  change c2 = cacaReg b2 134217726 67108862 at hc2
  change c3 = cacaReg b3 134217726 67108862 at hc3
  change c4 = cacaReg b4 134217726 67108862 at hc4
  change d0 = dbbdReg b0 134217690 67108862 at hd0
  change d1 = dbbdReg b1 134217726 67108862 at hd1
  change d2 = dbbdReg b2 134217726 67108862 at hd2
  change d3 = dbbdReg b3 134217726 67108862 at hd3
  change d4 = dbbdReg b4 134217726 67108862 at hd4
  subst hc0 hc1 hc2 hc3 hc4 hd0 hd1 hd2 hd3 hd4 hb0 hb1 hb2 hb3 hb4
  rw [← caca_eq, ← dbbd_eq] at hS
  subst hS
  erase_frame
  subst ht0 ht1 ht2 ht3 ht4 ha0 ha1 ha2 ha3 ha4
  rw [← tmp0_eq] at hsq
  subst hsq
  rfl
