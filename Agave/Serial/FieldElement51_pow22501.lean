module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.FieldElement51_square
public import Agave.Serial.Mlir.FieldElement51_pow22501

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `self.pow22501()`: `(self^(2^250 - 1), self^11)`, by the Rust's chain `t0 … t19`. -/
def FieldElement51_pow22501.spec (z : Fin 5 → BitVec 64) :
    (Fin 5 → BitVec 64) × (Fin 5 → BitVec 64) :=
  let sq := FieldElement51_square.spec
  let mul := FieldElement51_Mul_mul.spec
  let pow2k := FieldElement51_pow2k.spec
  let t0 := sq z
  let t1 := sq (sq t0)
  let t2 := mul z t1
  let t3 := mul t0 t2
  let t4 := sq t3
  let t5 := mul t2 t4
  let t6 := pow2k t5 5
  let t7 := mul t6 t5
  let t8 := pow2k t7 10
  let t9 := mul t8 t7
  let t10 := pow2k t9 20
  let t11 := mul t10 t9
  let t12 := pow2k t11 10
  let t13 := mul t12 t7
  let t14 := pow2k t13 50
  let t15 := mul t14 t13
  let t16 := pow2k t15 100
  let t17 := mul t16 t15
  let t18 := pow2k t17 50
  let t19 := mul t18 t13
  (t19, t3)

end

/-! ## Proof -/

section Proof

/-- `start p`: the slot `p`'s lifetime starts, with room for its limbs. -/
local macro "start " p:ident : tactic => `(tactic| (step_pure; limbs_room $p))

/-- `drop p`: the slot `p` is read no more; its facts go. -/
local macro "drop " p:ident : tactic => do
  let n := p.getId.toString
  let r := Lean.mkIdent (.mkSimple s!"hread_{n}")
  let rl := Lean.mkIdent (.mkSimple s!"hread_{n}_readLimbs")
  `(tactic| (clear $r $rl; clear_facts $p))

-- about 110 steps over a frame of 20 slots: just over 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- `z.pow22501()` stores `spec z`'s two field elements at `out` and `out + 40` (the `sret`
pair). Its 20 temporaries are freed again: only the counter moves on, by 20 blocks. -/
public theorem FieldElement51_pow22501.call_eq (out z : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hout' : s.mem.LimbsRoom (out.add 40#64))
    (hoff : out.offset.toNat + 72 < 2 ^ 64) (hz : s.mem.LimbsFit z) :
    FieldElement51_pow22501.call (FieldElement51_pow22501.args (.value out) (.value z)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 20⟩,
            mem :=
              (s.mem.storeLimbs out (FieldElement51_pow22501.spec (s.mem.readLimbs z)).1).storeLimbs
                (out.add 40#64) (FieldElement51_pow22501.spec (s.mem.readLimbs z)).2 }) := by
  func_init
  have hz₀ : S₀.mem.LimbsFit z := hS ▸ hz
  have hout'_room := MemoryState.LimbsRoom.room320 hout'
  have hout40 : ¬out.offset.uaddOverflow 40#64 := by
    simp [BitVec.uaddOverflow]; omega
  block_init
  iterate 7 step_pure
  step_alloca with p18
  step_alloca with p17
  step_alloca with p16
  step_alloca with p15
  step_alloca with p14
  step_alloca with p13
  step_alloca with p12
  step_alloca with p11
  step_alloca with p10
  step_alloca with p9
  step_alloca with p8
  step_alloca with p7
  step_alloca with p6
  step_alloca with p5
  step_alloca with p4
  step_alloca with p3
  step_alloca with p2
  step_alloca with tmp
  step_alloca with p1
  step_alloca with p0
  -- let t0 = self.square();
  start p0
  step_call using FieldElement51_square.call_eq
  name_limbs t0
  -- let t1 = t0.square().square();
  start p1
  start tmp
  step_call using FieldElement51_square.call_eq
  name_limbs t0'
  step_call using FieldElement51_square.call_eq
  name_limbs t1
  step_pure
  drop tmp
  -- let t2 = self * &t1;
  start p2
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t2
  drop p1
  clear_facts z
  -- let t3 = &t0 * &t2;
  start p3
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t3
  drop p0
  -- let t4 = t3.square();
  start p4
  step_call using FieldElement51_square.call_eq
  name_limbs t4
  -- let t5 = &t2 * &t4;
  start p5
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t5
  drop p2
  drop p4
  -- let t6 = t5.pow2k(5);
  start p6
  step_call using FieldElement51_pow2k.call_eq
  name_limbs t6
  -- let t7 = &t6 * &t5;
  start p7
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t7
  drop p5
  drop p6
  -- let t8 = t7.pow2k(10);
  start p8
  step_call using FieldElement51_pow2k.call_eq
  name_limbs t8
  -- let t9 = &t8 * &t7;
  start p9
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t9
  drop p8
  -- let t10 = t9.pow2k(20);
  start p10
  step_call using FieldElement51_pow2k.call_eq
  name_limbs t10
  -- let t11 = &t10 * &t9;
  start p11
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t11
  drop p9
  drop p10
  -- let t12 = t11.pow2k(10);
  start p12
  step_call using FieldElement51_pow2k.call_eq
  name_limbs t12
  drop p11
  -- let t13 = &t12 * &t7;
  start p13
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t13
  drop p7
  drop p12
  -- let t14 = t13.pow2k(50);
  start p14
  step_call using FieldElement51_pow2k.call_eq
  name_limbs t14
  -- let t15 = &t14 * &t13;
  start p15
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t15
  drop p14
  -- let t16 = t15.pow2k(100);
  start p16
  step_call using FieldElement51_pow2k.call_eq
  name_limbs t16
  -- let t17 = &t16 * &t15;
  start p17
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t17
  drop p15
  drop p16
  -- let t18 = t17.pow2k(50);
  start p18
  step_call using FieldElement51_pow2k.call_eq
  name_limbs t18
  drop p17
  -- let t19 = &t18 * &t13;
  step_call using FieldElement51_Mul_mul.call_eq
  name_limbs t19
  drop p18
  drop p13
  -- (t19, t3)
  step_pure
  have hp3_fits := MemoryState.LimbsFit.fits hp3_limbs
  have hdisj : (Range.of (out.add 40#64) 320).Disjoint (Range.of p3 320) :=
    Or.inl (by simpa [Range.of] using hout_ne_p3)
  have hoff' := hout'.1
  step_memcpy consuming hdisj hp3_fits hout'_room
  -- the slots' lifetimes end
  clear_facts out p3
  iterate 19 step_pure
  finish_block
  clear_reads
  subst hS
  erase_frame
  rw [← MemoryState.storeLimbs_eq_storeAt hoff']
  subst_vars
  rfl

end Proof

end MLIR.Agave.Serial
