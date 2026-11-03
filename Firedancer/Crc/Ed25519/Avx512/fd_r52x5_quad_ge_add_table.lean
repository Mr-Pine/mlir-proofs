module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.Crc.Ed25519.Common.Wl
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_add_nc
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_mul
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_negate_lazy
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_reduce
public import Firedancer.Crc.Ed25519.Avx512.wl_permute
public import Firedancer.Crc.Ed25519.Avx512.QuadRuns
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_add_table

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_ge_add_table( _z0 … _z4, x0 … x4, y0 … y4 )`: the extended point `X + Y`, `Y` a
table entry. The QUAD macros in the compiled order. -/
def fd_r52x5_quad_ge_add_table.spec (X Y : Quad5) : Quad5 :=
  let t0 := Quad5.permute 1 0 3 2 X
  let t1 := fd_r52x5_quad_negate_lazy.spec X
  let t2 := Quad5.laneIf 1 0 1 0 t1 X
  let t3 := fd_r52x5_quad_add_nc.spec t0 t2
  let t4 := fd_r52x5_quad_reduce.spec t3
  let t5 := Quad5.laneIf 1 1 0 0 t4 X
  let t6 := fd_r52x5_quad_mul.spec t5 Y
  let t7 := Quad5.permute 0 1 3 2 t6
  let t8 := Quad5.permute 1 0 3 2 t7
  let t9 := fd_r52x5_quad_negate_lazy.spec t7
  let t10 := Quad5.laneIf 1 0 1 0 t9 t7
  let t11 := fd_r52x5_quad_add_nc.spec t8 t10
  let t12 := fd_r52x5_quad_reduce.spec t11
  let t13 := Quad5.permute 0 3 3 0 t12
  let t14 := Quad5.permute 2 1 2 1 t12
  let t15 := fd_r52x5_quad_mul.spec t13 t14
  t15

end

/-! ## Proof -/

section Proof

namespace fd_r52x5_quad_ge_add_table

-- the lead's constant vectors, read for each fact: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_ge_add_table`'s lead: its constants, and the facts the patterns read of them. -/
theorem lead {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 0 = entry.body.drop 0) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer} {X Y : Quad5}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hK :
      ∀ E' : ⟪Γ⟫,
        (hArgs : E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
          (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get) →
        (hidx :
          E' ⊨ [rir_reg% hty 0 := (1#32 : BitVec 32), rir_reg% hty 1 := (0#32 : BitVec 32),
            rir_reg% hty 2 := (3#32 : BitVec 32), rir_reg% hty 3 := (2#32 : BitVec 32)]) →
        (blk.runBodyFrom E' 4 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  iterate 4 step_pure
  have hidx :
      E ⊨ [rir_reg% hty 0 := (1#32 : BitVec 32), rir_reg% hty 1 := (0#32 : BitVec 32),
        rir_reg% hty 2 := (3#32 : BitVec 32), rir_reg% hty 3 := (2#32 : BitVec 32)] := by
    rw [hE]; lemma_reads
  exact hK E hArgs hidx

end fd_r52x5_quad_ge_add_table

-- the lead's constant vectors, read at each pattern: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_ge_add_table` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order; its `alloca`
slots and the permutes' are freed. -/
public theorem fd_r52x5_quad_ge_add_table.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X Y : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_ge_add_table.call
        (fd_r52x5_quad_ge_add_table.args (.value _z0) (.value _z1) (.value _z2) (.value _z3)
          (.value _z4) (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)
          (Ty.wrap Y.P0) (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 65⟩,
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_ge_add_table.spec X Y) }) := by
  func_init
  block_init
  refine fd_r52x5_quad_ge_add_table.lead (blk := entry) rfl hEargs fun E hArgs hidx => ?_
  clear hEargs
  refine runBodyFrom_allocas ([%699, %700, %701, %702, %703, %704, %705, %706, %707, %708, %709,
    %710, %711, %712, %713, %714, %715, %716, %717, %718, %719, %720, %721, %722, %723, %724, %725,
    %726, %727, %728, %729, %730, %731, %732, %733, %734, %735, %736, %737,
    %738] : List (Dst fd_r52x5_quad_ge_add_table.Γ .ptr))
    (rest := entry.body.drop 44) rfl hwf ?_
  intro S' hwf' hF hRoom hA hErase
  subst hS
  simp only [writeSlots, List.length_cons, List.length_nil, Nat.reduceAdd] at hF hA ⊢
  have hz0 := hwf.lt h0.inBounds.mem
  have hz1 := hwf.lt h1.inBounds.mem
  have hz2 := hwf.lt h2.inBounds.mem
  have hz3 := hwf.lt h3.inBounds.mem
  have hz4 := hwf.lt h4.inBounds.mem
  have hZ : ∀ S0 : GlobalState, S0 = S' → Room S0.mem _z0 256 ∧ Room S0.mem _z1 256 ∧
      Room S0.mem _z2 256 ∧ Room S0.mem _z3 256 ∧ Room S0.mem _z4 256 := fun _ h =>
    h ▸ ⟨hRoom _ _ h0, hRoom _ _ h1, hRoom _ _ h2, hRoom _ _ h3, hRoom _ _ h4⟩
  clear hRoom h0 h1 h2 h3 h4 h0₀ h1₀ h2₀ h3₀ h4₀
  step_pattern' using runBodyFrom_permuteRun 1 0 3 2 with t0
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_negate_lazy.call_eq) with t1
  step_pattern' using runBodyFrom_blendRun 1 0 1 0 with t2
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t3
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_reduce.call_eq) with t4
  step_pattern' using runBodyFrom_blendRun 1 1 0 0 with t5
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq) with t6
  step_pattern' using runBodyFrom_permuteRun 0 1 3 2 with t7
  step_pattern' using runBodyFrom_permuteRun 1 0 3 2 with t8
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_negate_lazy.call_eq) with t9
  step_pattern' using runBodyFrom_blendRun 1 0 1 0 with t10
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t11
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_reduce.call_eq) with t12
  step_pattern' using runBodyFrom_permuteRun 0 3 3 0 with t13
  step_pattern' using runBodyFrom_permuteRun 2 1 2 1 with t14
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq) with t15
  obtain ⟨h0', h1', h2', h3', h4'⟩ := hZ _ rfl
  clear hZ
  replace h0' : Room S.mem _z0 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hz0)
    exact h0'
  replace h1' : Room S.mem _z1 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hz1)
    exact h1'
  replace h2' : Room S.mem _z2 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hz2)
    exact h2'
  replace h3' : Room S.mem _z3 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hz3)
    exact h3'
  replace h4' : Room S.mem _z4 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hz4)
    exact h4'
  clear hF hidx
  iterate 5 step_store
  finish_block
  subst hS
  erase_frame
  rw [hErase, GlobalState.WF.eraseFrom hwf, hA]
  clear hArgs
  subst_vars
  simp only [fd_r52x5_quad_ge_add_table.spec]
  rfl

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
