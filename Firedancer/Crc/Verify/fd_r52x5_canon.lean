module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_canon
public import Firedancer.Crc.Verify.Reads
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5 (shr51_mul19 mask51_add_shr51)

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_canon( r, a )`: one carry pass over `a`, then `q`, the carry of `+ 19` out of bit
255, added back as `19 q` with a second carry pass, each limb masked to 51 bits. Operands in the
compiled order. -/
def fd_r52x5_canon.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let mask := 2251799813685247#64
  let t4 := (a 4 >>> 51) * 19#64 + (a 0 &&& mask)
  let t7 := (a 3 >>> 51) + (a 4 &&& mask)
  let t10 := (a 2 >>> 51) + (a 3 &&& mask)
  let t13 := (a 1 >>> 51) + (a 2 &&& mask)
  let t16 := (a 1 &&& mask) + (a 0 >>> 51)
  let u0 := t4 + 19#64
  let u1 := t16 + (u0 >>> 51)
  let u2 := (u1 >>> 51) + t13
  let u3 := (u2 >>> 51) + t10
  let u4 := (u3 >>> 51) + t7
  let t29 := (u4 >>> 51) * 19#64 + t4
  let t32 := (t29 >>> 51) + t16
  let t35 := (t32 >>> 51) + t13
  let t38 := (t35 >>> 51) + t10
  let t41 := (t38 >>> 51) + t7
  fun
  | ⟨0, _⟩ => t29 &&& mask
  | ⟨1, _⟩ => t32 &&& mask
  | ⟨2, _⟩ => t35 &&& mask
  | ⟨3, _⟩ => t38 &&& mask
  | ⟨4, _⟩ => t41 &&& mask

end

/-! ## Proof -/

section Proof

/-! The flagged adds' no-overflow facts, by the shape of their operands. -/

theorem canon_ok_a (x y : BitVec 64) :
    ((x >>> 51) * 19#64).saddOverflow (y &&& 2251799813685247#64) = false ∧
      ((x >>> 51) * 19#64).uaddOverflow (y &&& 2251799813685247#64) = false := by bv_decide

theorem canon_ok_b (x y : BitVec 64) :
    (x >>> 51).saddOverflow (y &&& 2251799813685247#64) = false ∧
      (x >>> 51).uaddOverflow (y &&& 2251799813685247#64) = false := by bv_decide

theorem canon_ok_d (x y : BitVec 64) :
    ((x >>> 51) * 19#64 + (y &&& 2251799813685247#64)).saddOverflow 19#64 = false ∧
      ((x >>> 51) * 19#64 + (y &&& 2251799813685247#64)).uaddOverflow 19#64 = false := by
  bv_decide

theorem canon_ok_e (x y z : BitVec 64) :
    ((y &&& 2251799813685247#64) + (x >>> 51)).saddOverflow (z >>> 51) = false ∧
      ((y &&& 2251799813685247#64) + (x >>> 51)).uaddOverflow (z >>> 51) = false := by bv_decide

theorem canon_ok_f (x y z : BitVec 64) :
    (z >>> 51).saddOverflow ((x >>> 51) + (y &&& 2251799813685247#64)) = false ∧
      (z >>> 51).uaddOverflow ((x >>> 51) + (y &&& 2251799813685247#64)) = false := by bv_decide

theorem canon_ok_g (x y z : BitVec 64) :
    ((z >>> 51) * 19#64).saddOverflow ((x >>> 51) * 19#64 + (y &&& 2251799813685247#64)) = false ∧
      ((z >>> 51) * 19#64).uaddOverflow ((x >>> 51) * 19#64 + (y &&& 2251799813685247#64)) =
        false := by bv_decide

theorem canon_ok_h (x y z : BitVec 64) :
    (z >>> 51).saddOverflow ((y &&& 2251799813685247#64) + (x >>> 51)) = false ∧
      (z >>> 51).uaddOverflow ((y &&& 2251799813685247#64) + (x >>> 51)) = false := by bv_decide

namespace fd_r52x5_canon

/-- The first carry pass (positions 9 to 34): the limbs at `a` loaded, `t4 … t16` into
`%177 %182 %187 %192 %195`. -/
theorem pass1 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 9 = entry.body.drop 9) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {r a : Pointer}
    (hArgs : E.args = (args (.value r) (.value a)).get)
    (hR : E ⊨ [%162 := 2251799813685247#64, %163 := 51#64, %164 := 19#64,
      %165 := Vector.replicate 4 PoisonOr.poison, %166 := 0#64, %167 := 1#64, %168 := 2#64,
      %169 := 3#64, %170 := Ty.wrap (Vector.replicate 4 2251799813685247#64)])
    (ha : S.mem.LimbsFit a)
    (hK : ∀ (E' : ⟪Γ⟫) (a0 a1 a2 a3 a4 : BitVec 64),
      a0 = S.mem.readAt a 64 → a1 = S.mem.readAt (a.add 8#64) 64 →
      a2 = S.mem.readAt (a.add 16#64) 64 → a3 = S.mem.readAt (a.add 24#64) 64 →
      a4 = S.mem.readAt (a.add 32#64) 64 →
      E' ⊨ [%162 := 2251799813685247#64, %163 := 51#64, %164 := 19#64,
        %165 := Vector.replicate 4 PoisonOr.poison, %166 := 0#64, %167 := 1#64, %168 := 2#64,
        %169 := 3#64, %170 := Ty.wrap (Vector.replicate 4 2251799813685247#64),
        %177 := (a4 >>> 51) * 19#64 + (a0 &&& 2251799813685247#64),
        %182 := (a3 >>> 51) + (a4 &&& 2251799813685247#64),
        %187 := (a2 >>> 51) + (a3 &&& 2251799813685247#64),
        %192 := (a1 >>> 51) + (a2 &&& 2251799813685247#64),
        %195 := (a1 &&& 2251799813685247#64) + (a0 >>> 51)] →
      E'.args = (args (.value r) (.value a)).get →
      (blk.runBodyFrom E' 34 S >>= g) = K) :
    (blk.runBodyFrom E 9 S >>= g) = K := by
  obtain ⟨_, hf0, hf1, hf2, hf3, hf4⟩ := ha
  step_load inline
  step_pure
  step_pure
  step_load inline
  step_pure
  step_pure [shr51_mul19]
  step_pure [canon_ok_a]
  step_pure
  step_load inline
  step_pure
  step_pure
  step_pure [canon_ok_b]
  step_pure
  step_load inline
  step_pure
  step_pure
  step_pure [canon_ok_b]
  step_pure
  step_load inline
  step_pure
  step_pure
  step_pure [canon_ok_b]
  step_pure
  step_pure
  step_pure [mask51_add_shr51]
  subst hS
  refine hK E _ _ _ _ _ rfl rfl rfl rfl rfl ?_ hArgs
  rw [hE]
  subst_vars
  lemma_reads


/-- The carry of `+ 19` through `t4 … t16` (positions 34 to 44): its sums named `u0 … u4`. -/
theorem carry19 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 34 = entry.body.drop 34) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (a0 a1 a2 a3 a4 : BitVec 64)
    (hR : E ⊨ [%163 := 51#64, %164 := 19#64,
      %177 := (a4 >>> 51) * 19#64 + (a0 &&& 2251799813685247#64),
      %182 := (a3 >>> 51) + (a4 &&& 2251799813685247#64),
      %187 := (a2 >>> 51) + (a3 &&& 2251799813685247#64),
      %192 := (a1 >>> 51) + (a2 &&& 2251799813685247#64),
      %195 := (a1 &&& 2251799813685247#64) + (a0 >>> 51)])
    (hK : ∀ u0 u1 u2 u3 u4 : BitVec 64,
      u0 = (a4 >>> 51) * 19#64 + (a0 &&& 2251799813685247#64) + 19#64 →
      u1 = (a1 &&& 2251799813685247#64) + (a0 >>> 51) + (u0 >>> 51) →
      u2 = (u1 >>> 51) + ((a1 >>> 51) + (a2 &&& 2251799813685247#64)) →
      u3 = (u2 >>> 51) + ((a2 >>> 51) + (a3 &&& 2251799813685247#64)) →
      u4 = (u3 >>> 51) + ((a3 >>> 51) + (a4 &&& 2251799813685247#64)) →
      (blk.runBodyFrom
          E[%196 := .value u0, %197 := .value (u0 >>> 51), %198 := .value u1,
            %199 := .value (u1 >>> 51), %200 := .value u2, %201 := .value (u2 >>> 51),
            %202 := .value u3, %203 := .value (u3 >>> 51), %204 := .value u4,
            %205 := .value (u4 >>> 51)] 44 S >>= g) = K) :
    (blk.runBodyFrom E 34 S >>= g) = K := by
  step_pure [canon_ok_d] with u0
  step_pure
  step_pure [canon_ok_e] with u1
  step_pure
  step_pure [canon_ok_f] with u2
  step_pure
  step_pure [canon_ok_f] with u3
  step_pure
  step_pure [canon_ok_f] with u4
  step_pure
  rw [hE]
  exact hK u0 u1 u2 u3 u4 hu0 hu1 hu2 hu3 hu4


/-- `19 q` added back and the second carry pass (positions 44 to 52), named `t29 … t38`. -/
theorem pass2 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 44 = entry.body.drop 44) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (a0 a1 a2 a3 a4 u4 : BitVec 64)
    (hR : E ⊨ [%163 := 51#64, %164 := 19#64,
      %177 := (a4 >>> 51) * 19#64 + (a0 &&& 2251799813685247#64),
      %187 := (a2 >>> 51) + (a3 &&& 2251799813685247#64),
      %192 := (a1 >>> 51) + (a2 &&& 2251799813685247#64),
      %195 := (a1 &&& 2251799813685247#64) + (a0 >>> 51), %205 := u4 >>> 51])
    (hK : ∀ t29 t32 t35 t38 : BitVec 64,
      t29 = (u4 >>> 51) * 19#64 + ((a4 >>> 51) * 19#64 + (a0 &&& 2251799813685247#64)) →
      t32 = (t29 >>> 51) + ((a1 &&& 2251799813685247#64) + (a0 >>> 51)) →
      t35 = (t32 >>> 51) + ((a1 >>> 51) + (a2 &&& 2251799813685247#64)) →
      t38 = (t35 >>> 51) + ((a2 >>> 51) + (a3 &&& 2251799813685247#64)) →
      (blk.runBodyFrom
          E[%206 := .value ((u4 >>> 51) * 19#64), %207 := .value t29, %208 := .value (t29 >>> 51),
            %209 := .value t32, %210 := .value (t32 >>> 51), %211 := .value t35,
            %212 := .value (t35 >>> 51), %213 := .value t38] 52 S >>= g) = K) :
    (blk.runBodyFrom E 44 S >>= g) = K := by
  step_pure [shr51_mul19]
  step_pure [canon_ok_g] with t29
  step_pure
  step_pure [canon_ok_h] with t32
  step_pure
  step_pure [canon_ok_f] with t35
  step_pure
  step_pure [canon_ok_f] with t38
  rw [hE]
  exact hK t29 t32 t35 t38 ht29 ht32 ht35 ht38

/-- The last limb, the mask and the two stores (position 52 to the block's end): the five
masked limbs at `r` as `storeLimbsV`. -/
theorem pass3 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 52 = entry.body.drop 52) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {r a : Pointer}
    (hArgs : E.args = (args (.value r) (.value a)).get) (hr : S.mem.LimbsRoom r)
    (hr256 : Room S.mem r 256) (a3 a4 t29 t32 t35 t38 : BitVec 64)
    (hR : E ⊨ [%162 := 2251799813685247#64, %163 := 51#64,
      %165 := Vector.replicate 4 PoisonOr.poison, %166 := 0#64, %167 := 1#64, %168 := 2#64,
      %169 := 3#64, %170 := Ty.wrap (Vector.replicate 4 2251799813685247#64),
      %182 := (a3 >>> 51) + (a4 &&& 2251799813685247#64), %207 := t29, %209 := t32, %211 := t35,
      %213 := t38])
    (hK : ∀ E' : ⟪Γ⟫, (blk.runBodyFrom E' 63
      { alloc := S.alloc,
        mem := (S.mem.storeWv r #v[t29 &&& 2251799813685247#64, t32 &&& 2251799813685247#64,
            t35 &&& 2251799813685247#64, t38 &&& 2251799813685247#64]).storeAt (r.add 32#64)
          (((t38 >>> 51) + ((a3 >>> 51) + (a4 &&& 2251799813685247#64))) &&&
            2251799813685247#64) } >>= g) = K) :
    (blk.runBodyFrom E 52 S >>= g) = K := by
  iterate 4 step_pure
  step_pure [expandOfFn]
  step_pure
  step_pure [canon_ok_f] with t41
  step_pure
  step_store
  step_pure
  step_store
  subst hS ht41
  exact hK E

end fd_r52x5_canon

/-- `fd_r52x5_canon( r, a )` stores `spec` of the limbs at `a` as limbs at `r`. -/
public theorem fd_r52x5_canon.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsRoom r) (ha : s.mem.LimbsFit a) :
    fd_r52x5_canon.call (fd_r52x5_canon.args (.value r) (.value a)) s =
      .value
        (.nil, { s with mem := s.mem.storeLimbs r (fd_r52x5_canon.spec (s.mem.readLimbs a)) }) := by
  have hr256 : Room s.mem r 256 := hr.room320.mono (by omega)
  have hf0 := ha.2.1
  have hf1 := ha.2.2.1
  have hf2 := ha.2.2.2.1
  have hf3 := ha.2.2.2.2.1
  have hf4 := ha.2.2.2.2.2
  rw [MemoryState.storeLimbsV_eq hr]
  func_init
  block_init
  iterate 9 step_pure
  refine fd_r52x5_canon.pass1 (blk := entry) rfl hArgs (by rw [hE]; lemma_reads) ha ?_
  intro E' a0 a1 a2 a3 a4 ha0 ha1 ha2 ha3 ha4 hR hArgs'
  have hl : S₀.mem.readLimbs a = fun
      | ⟨0, _⟩ => a0 | ⟨1, _⟩ => a1 | ⟨2, _⟩ => a2 | ⟨3, _⟩ => a3 | ⟨4, _⟩ => a4 := by
    subst hS; funext i; fin_cases i <;> simp [MemoryState.readLimbs, *]
  clear ha0 ha1 ha2 ha3 ha4
  obtain ⟨h162, h163, h164, h165, h166, h167, h168, h169, h170, h177, h182, h187, h192, h195⟩ :=
    hR
  refine fd_r52x5_canon.carry19 (blk := entry) rfl a0 a1 a2 a3 a4
    ⟨h163, h164, h177, h182, h187, h192, h195⟩ ?_
  intro u0 u1 u2 u3 u4 hu0 hu1 hu2 hu3 hu4
  refine fd_r52x5_canon.pass2 (blk := entry) rfl a0 a1 a2 a3 a4 u4 (by lemma_reads) ?_
  intro t29 t32 t35 t38 ht29 ht32 ht35 ht38
  clear h164 h177 h187 h192 h195
  refine fd_r52x5_canon.pass3 (blk := entry) (S := S) (a := a) rfl ?hA3 hr hr256 a3 a4 t29 t32
    t35 t38 ?hR3 fun E => ?_
  case hA3 => simp only [Env.write_args]; exact hArgs'
  case hR3 => lemma_reads
  finish_block
  rw [hS]
  clear hS hE hArgs hArgs'
  rw [hl]
  subst ht38 ht35 ht32 ht29 hu4 hu3 hu2 hu1 hu0
  simp only [MemoryState.storeLimbsV, MemoryState.storeWv, fd_r52x5_canon.spec]

end Proof

end MLIR.Firedancer.Crc.Verify
