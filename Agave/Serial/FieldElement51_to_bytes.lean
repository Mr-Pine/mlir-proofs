module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Limbs
public import Agave.Serial.FieldElement51
public import Agave.Serial.Mlir.FieldElement51_to_bytes
public meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `to_bytes`'s limbs: `reduce`, then `q = 1` iff the value is at least `p`, `19 q` added and
carried, each limb masked to 51 bits; named as in the Rust, sums in the code's operand order. -/
def FieldElement51_to_bytes.limbs (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let limbs := FieldElement51.reduce a
  let q := (limbs 0 + 19#64) >>> 51
  let q := (q + limbs 1) >>> 51
  let q := (q + limbs 2) >>> 51
  let q := (q + limbs 3) >>> 51
  let q := (q + limbs 4) >>> 51
  let l0 := q * 19#64 + limbs 0
  let l1 := l0 >>> 51 + limbs 1
  let l2 := l1 >>> 51 + limbs 2
  let l3 := l2 >>> 51 + limbs 3
  let l4 := l3 >>> 51 + limbs 4
  fun
  | 0 => l0 &&& mask51
  | 1 => l1 &&& mask51
  | 2 => l2 &&& mask51
  | 3 => l3 &&& mask51
  | 4 => l4 &&& mask51

/-- The bytes `s[0] … s[31]` of 51-bit limbs `l0 … l4`, `s[k]` at bits `8k …`, as the Rust cuts
them. -/
def FieldElement51_to_bytes.bytes (l0 l1 l2 l3 l4 : BitVec 64) : BitVec 256 :=
  let b (x : BitVec 64) : BitVec 8 := x.setWidth 8
  b (l4 >>> 44) ++
    (b (l4 >>> 36) ++
      (b (l4 >>> 28) ++
        (b (l4 >>> 20) ++
          (b (l4 >>> 12) ++
            (b (l4 >>> 4) ++
              (b (l3 >>> 47 ||| l4 <<< 4) ++
                (b (l3 >>> 39) ++
                  (b (l3 >>> 31) ++
                    (b (l3 >>> 23) ++
                      (b (l3 >>> 15) ++
                        (b (l3 >>> 7) ++
                          (b (l2 >>> 50 ||| l3 <<< 1) ++
                            (b (l2 >>> 42) ++
                              (b (l2 >>> 34) ++
                                (b (l2 >>> 26) ++
                                  (b (l2 >>> 18) ++
                                    (b (l2 >>> 10) ++
                                      (b (l2 >>> 2) ++
                                        (b (l1 >>> 45 ||| l2 <<< 6) ++
                                          (b (l1 >>> 37) ++
                                            (b (l1 >>> 29) ++
                                              (b (l1 >>> 21) ++
                                                (b (l1 >>> 13) ++
                                                  (b (l1 >>> 5) ++
                                                    (b (l0 >>> 48 ||| l1 <<< 3) ++
                                                      (b (l0 >>> 40) ++
                                                        (b (l0 >>> 32) ++
                                                          (b (l0 >>> 24) ++
                                                            (b (l0 >>> 16) ++
                                                              (b (l0 >>> 8) ++
                                                                b l0))))))))))))))))))))))))))))))

/-- `self.to_bytes()`: the bytes of `limbs self`, `s[k]` at bits `8k …`. -/
def FieldElement51_to_bytes.spec (a : Fin 5 → BitVec 64) : BitVec 256 :=
  let l := FieldElement51_to_bytes.limbs a
  FieldElement51_to_bytes.bytes (l 0) (l 1) (l 2) (l 3) (l 4)

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `s[k] = …` for `k > 0`: the address, the byte, its store, then the store merged into the bytes
before it, so the state keeps one store at `out`. -/
local macro "store_byte" : tactic =>
  `(tactic|
    ( step_pure
      step_pure
      step_store
      clear_reads
      rw [storeAt_storeAt_add (BitVec.not_uaddOverflow_of_le hout_off (by decide))
          (by decide)] at hS))

/-- `s[k] = (limbs[i] >> j) as u8`. -/
local macro "shift_byte" : tactic => `(tactic| (step_pure; store_byte))

@[simp]
theorem reduce0_add19_uaddOverflow (x y : BitVec 64) :
    ¬(x >>> 51 * 19#64 + (y &&& 2251799813685247#64)).uaddOverflow 19#64 := by bv_decide

@[simp]
theorem reduce0_add19_saddOverflow (x y : BitVec 64) :
    ¬(x >>> 51 * 19#64 + (y &&& 2251799813685247#64)).saddOverflow 19#64 := by bv_decide

@[simp]
theorem carry_reduce_uaddOverflow (x y z : BitVec 64) :
    ¬(x >>> 51).uaddOverflow ((y &&& 2251799813685247#64) + z >>> 51) := by bv_decide

@[simp]
theorem carry_reduce_saddOverflow (x y z : BitVec 64) :
    ¬(x >>> 51).saddOverflow ((y &&& 2251799813685247#64) + z >>> 51) := by bv_decide

@[simp]
theorem q19_reduce0_uaddOverflow (x y z : BitVec 64) :
    ¬(x >>> 51 * 19#64).uaddOverflow (y >>> 51 * 19#64 + (z &&& 2251799813685247#64)) := by
  bv_decide

@[simp]
theorem q19_reduce0_saddOverflow (x y z : BitVec 64) :
    ¬(x >>> 51 * 19#64).saddOverflow (y >>> 51 * 19#64 + (z &&& 2251799813685247#64)) := by
  bv_decide

@[simp]
theorem mask_shl1_ushiftRight (x : BitVec 64) :
    (x &&& 2251799813685247#64) <<< 1 >>> 1 = x &&& 2251799813685247#64 := by bv_decide

@[simp]
theorem mask_shl1_sshiftRight (x : BitVec 64) :
    ((x &&& 2251799813685247#64) <<< 1).sshiftRight 1 = x &&& 2251799813685247#64 := by bv_decide

@[simp]
theorem mask_shl3_ushiftRight (x : BitVec 64) :
    (x &&& 2251799813685247#64) <<< 3 >>> 3 = x &&& 2251799813685247#64 := by bv_decide

@[simp]
theorem mask_shl3_sshiftRight (x : BitVec 64) :
    ((x &&& 2251799813685247#64) <<< 3).sshiftRight 3 = x &&& 2251799813685247#64 := by bv_decide

@[simp]
theorem mask_shl4_ushiftRight (x : BitVec 64) :
    (x &&& 2251799813685247#64) <<< 4 >>> 4 = x &&& 2251799813685247#64 := by bv_decide

@[simp]
theorem mask_shl4_sshiftRight (x : BitVec 64) :
    ((x &&& 2251799813685247#64) <<< 4).sshiftRight 4 = x &&& 2251799813685247#64 := by bv_decide

@[simp]
theorem mask_shl6_ushiftRight (x : BitVec 64) :
    (x &&& 2251799813685247#64) <<< 6 >>> 6 = x &&& 2251799813685247#64 := by bv_decide

@[simp]
theorem mask_shl6_sshiftRight (x : BitVec 64) :
    ((x &&& 2251799813685247#64) <<< 6).sshiftRight 6 = x &&& 2251799813685247#64 := by bv_decide

@[simp]
theorem byte6_disjoint (x y : BitVec 64) :
    (x &&& 2251799813685247#64) <<< 3 &&& (y >>> 48 &&& 7#64) = 0#64 := by bv_decide

@[simp]
theorem byte12_disjoint (x y : BitVec 64) :
    (x &&& 2251799813685247#64) <<< 6 &&& (y &&& 2251799813685247#64) >>> 45 = 0#64 := by bv_decide

@[simp]
theorem byte19_disjoint (x y : BitVec 64) :
    (x &&& 2251799813685247#64) <<< 1 &&& (y &&& 2251799813685247#64) >>> 50 = 0#64 := by bv_decide

@[simp]
theorem byte25_disjoint (x y : BitVec 64) :
    (x &&& 2251799813685247#64) <<< 4 &&& (y &&& 2251799813685247#64) >>> 47 = 0#64 := by bv_decide

@[simp]
theorem byte31_setWidth (x : BitVec 64) :
    (((x &&& 2251799813685247#64) >>> 44).setWidth 8).setWidth 64 =
      (x &&& 2251799813685247#64) >>> 44 := by
  bv_decide

@[simp]
theorem byte31_signExtend (x : BitVec 64) :
    (((x &&& 2251799813685247#64) >>> 44).setWidth 8).signExtend 64 =
      (x &&& 2251799813685247#64) >>> 44 := by
  bv_decide

/-- The bytes as the code computes them, from the unmasked limbs: `bytes` of the masked ones. -/
theorem FieldElement51_to_bytes.bytes_eq (l0 l1 l2 l3 l4 : BitVec 64) :
    BitVec.setWidth 8 ((l4 &&& 2251799813685247#64) >>> 44) ++
        (BitVec.setWidth 8 (l4 >>> 36) ++
          (BitVec.setWidth 8 (l4 >>> 28) ++
            (BitVec.setWidth 8 (l4 >>> 20) ++
              (BitVec.setWidth 8 (l4 >>> 12) ++
                (BitVec.setWidth 8 (l4 >>> 4) ++
                  (((BitVec.setWidth 8 l4 &&& 255#8) <<< 4 |||
                      BitVec.setWidth 8 ((l3 &&& 2251799813685247#64) >>> 47)) ++
                    (BitVec.setWidth 8 (l3 >>> 39) ++
                      (BitVec.setWidth 8 (l3 >>> 31) ++
                        (BitVec.setWidth 8 (l3 >>> 23) ++
                          (BitVec.setWidth 8 (l3 >>> 15) ++
                            (BitVec.setWidth 8 (l3 >>> 7) ++
                              (((BitVec.setWidth 8 l3 &&& 255#8) <<< 1 |||
                                  BitVec.setWidth 8 ((l2 &&& 2251799813685247#64) >>> 50)) ++
                                (BitVec.setWidth 8 (l2 >>> 42) ++
                                  (BitVec.setWidth 8 (l2 >>> 34) ++
                                    (BitVec.setWidth 8 (l2 >>> 26) ++
                                      (BitVec.setWidth 8 (l2 >>> 18) ++
                                        (BitVec.setWidth 8 (l2 >>> 10) ++
                                          (BitVec.setWidth 8 (l2 >>> 2) ++
                                            (((BitVec.setWidth 8 l2 &&& 255#8) <<< 6 |||
                                                BitVec.setWidth 8
                                                  ((l1 &&& 2251799813685247#64) >>> 45)) ++
                                              (BitVec.setWidth 8 (l1 >>> 37) ++
                                                (BitVec.setWidth 8 (l1 >>> 29) ++
                                                  (BitVec.setWidth 8 (l1 >>> 21) ++
                                                    (BitVec.setWidth 8 (l1 >>> 13) ++
                                                      (BitVec.setWidth 8 (l1 >>> 5) ++
                                                        (((BitVec.setWidth 8 l1 &&& 255#8) <<< 3 |||
                                                            BitVec.setWidth 8 (l0 >>> 48) &&&
                                                              7#8) ++
                                                          (BitVec.setWidth 8 (l0 >>> 40) ++
                                                            (BitVec.setWidth 8 (l0 >>> 32) ++
                                                              (BitVec.setWidth 8 (l0 >>> 24) ++
                                                                (BitVec.setWidth 8 (l0 >>> 16) ++
                                                                  (BitVec.setWidth 8 (l0 >>> 8) ++
                                                                    BitVec.setWidth 8
                                                                      l0)))))))))))))))))))))))))))))) =
      FieldElement51_to_bytes.bytes (l0 &&& mask51) (l1 &&& mask51) (l2 &&& mask51) (l3 &&& mask51)
        (l4 &&& mask51) := by
  simp only [FieldElement51_to_bytes.bytes]
  bv_decide

-- 230 steps in one block (each step rescans the rest of it): over 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- `a.to_bytes()` stores `spec a` at `out` (32 bytes, one 256-bit value). The loads all come
before the stores, so `out` may alias `a`; the `nuw`/`nsw`/`disjoint` flags never fire. -/
public theorem FieldElement51_to_bytes.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (ha : s.mem.LimbsFit a) :
    FieldElement51_to_bytes.call (FieldElement51_to_bytes.args (.value out) (.value a)) s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeAt out (FieldElement51_to_bytes.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  iterate 37 step_pure
  step_load
  iterate 4 
    step_pure
    step_load
  -- let mut limbs = FieldElement51::reduce(self.0).0;
  iterate 16 step_pure
  -- q = (limbs[0] + 19) >> 51; … q = (limbs[4] + q) >> 51;
  iterate 10 step_pure
  -- limbs[0] += 19 * q; then the carries; `limbs[i] &= low_51_bit_mask` as the bytes need them
  step_pure
  step_pure with l0
  step_pure
  step_pure with l1
  step_pure
  step_pure with l2
  step_pure
  step_pure
  step_pure with l3
  step_pure
  step_pure
  step_pure with l4
  step_pure
  step_pure
  -- s[0] = limbs[0] as u8; … s[5] = (limbs[0] >> 40) as u8;
  step_pure
  step_store
  iterate 5 shift_byte
  -- s[6] = ((limbs[0] >> 48) | (limbs[1] << 3)) as u8;
  iterate 4 step_pure
  store_byte
  -- s[7] = (limbs[1] >> 5) as u8; … s[11] = (limbs[1] >> 37) as u8;
  iterate 5 shift_byte
  -- s[12] = ((limbs[1] >> 45) | (limbs[2] << 6)) as u8;
  iterate 3 step_pure
  store_byte
  -- s[13] = (limbs[2] >> 2) as u8; … s[18] = (limbs[2] >> 42) as u8;
  iterate 6 shift_byte
  -- s[19] = ((limbs[2] >> 50) | (limbs[3] << 1)) as u8;
  iterate 3 step_pure
  store_byte
  -- s[20] = (limbs[3] >> 7) as u8; … s[24] = (limbs[3] >> 39) as u8;
  iterate 5 shift_byte
  -- s[25] = ((limbs[3] >> 47) | (limbs[4] << 4)) as u8;
  iterate 3 step_pure
  store_byte
  -- s[26] = (limbs[4] >> 4) as u8; … s[31] = (limbs[4] >> 44) as u8;
  iterate 6 shift_byte
  finish_block
  rw [hS, FieldElement51_to_bytes.bytes_eq]
  subst_vars
  rfl

end Proof

end MLIR.Agave.Serial
