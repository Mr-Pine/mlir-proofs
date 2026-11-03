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
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_add

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_ge_add( _z0 … _z4, x0 … x4, y0 … y4 )`: the extended point `X + Y`. The QUAD
macros in the compiled order. -/
def fd_r52x5_quad_ge_add.spec (X Y : Quad5) : Quad5 :=
  let c0 : Quad5 := ⟨#v[1, 1, 2, 1859910466990425], #v[0, 0, 0, 932731440258426],
    #v[0, 0, 0, 1072319116312658], #v[0, 0, 0, 1815898335770999], #v[0, 0, 0, 633789495995903]⟩
  let t0 := Quad5.permute 1 0 3 2 Y
  let t1 := fd_r52x5_quad_negate_lazy.spec Y
  let t2 := Quad5.laneIf 1 0 1 0 t1 Y
  let t3 := fd_r52x5_quad_add_nc.spec t0 t2
  let t4 := fd_r52x5_quad_reduce.spec t3
  let t5 := Quad5.laneIf 1 1 0 0 t4 Y
  let t6 := fd_r52x5_quad_mul.spec t5 c0
  let t7 := Quad5.permute 1 0 3 2 X
  let t8 := fd_r52x5_quad_negate_lazy.spec X
  let t9 := Quad5.laneIf 1 0 1 0 t8 X
  let t10 := fd_r52x5_quad_add_nc.spec t7 t9
  let t11 := fd_r52x5_quad_reduce.spec t10
  let t12 := Quad5.laneIf 1 1 0 0 t11 X
  let t13 := fd_r52x5_quad_mul.spec t12 t6
  let t14 := Quad5.permute 0 1 3 2 t13
  let t15 := Quad5.permute 1 0 3 2 t14
  let t16 := fd_r52x5_quad_negate_lazy.spec t14
  let t17 := Quad5.laneIf 1 0 1 0 t16 t14
  let t18 := fd_r52x5_quad_add_nc.spec t15 t17
  let t19 := fd_r52x5_quad_reduce.spec t18
  let t20 := Quad5.permute 0 3 3 0 t19
  let t21 := Quad5.permute 2 1 2 1 t19
  let t22 := fd_r52x5_quad_mul.spec t20 t21
  t22

end

/-! ## Proof -/

section Proof

namespace fd_r52x5_quad_ge_add

-- the reads of the slots and QUADs the tail takes: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_ge_add` from position 206 to its stores, from the QUADs its tail reads in their
registers: their spec's tail stored at `_z0 … _z4`. -/
theorem run206 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 206 = entry.body.drop 206) {E : ⟪Γ⟫} {S B : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {Qt11 Qt6 : Quad5} {X Y : Quad5} {M : MemoryState} {n : Nat}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hidx : E ⊨ [rir_reg% hty 0 := (1#32 : BitVec 32), rir_reg% hty 1 := (0#32 : BitVec 32),
      rir_reg% hty 2 := (3#32 : BitVec 32), rir_reg% hty 3 := (2#32 : BitVec 32)])
    (hR : E ⊨ [
      rir_reg% hty 44 := B.slot 35,
      rir_reg% hty 45 := B.slot 36,
      rir_reg% hty 46 := B.slot 37,
      rir_reg% hty 47 := B.slot 38,
      rir_reg% hty 48 := B.slot 39,
      rir_reg% hty 49 := B.slot 40,
      rir_reg% hty 50 := B.slot 41,
      rir_reg% hty 51 := B.slot 42,
      rir_reg% hty 52 := B.slot 43,
      rir_reg% hty 53 := B.slot 44,
      rir_reg% hty 54 := B.slot 45,
      rir_reg% hty 55 := B.slot 46,
      rir_reg% hty 56 := B.slot 47,
      rir_reg% hty 57 := B.slot 48,
      rir_reg% hty 58 := B.slot 49,
      rir_reg% hty 59 := B.slot 50,
      rir_reg% hty 60 := B.slot 51,
      rir_reg% hty 61 := B.slot 52,
      rir_reg% hty 62 := B.slot 53,
      rir_reg% hty 63 := B.slot 54,
      rir_reg% hty 64 := B.slot 55,
      rir_reg% hty 65 := B.slot 56,
      rir_reg% hty 66 := B.slot 57,
      rir_reg% hty 67 := B.slot 58,
      rir_reg% hty 68 := B.slot 59,
      rir_reg% hty 124 := Qt11.P0,
      rir_reg% hty 125 := Qt11.P1,
      rir_reg% hty 126 := Qt11.P2,
      rir_reg% hty 127 := Qt11.P3,
      rir_reg% hty 128 := Qt11.P4,
      rir_reg% hty 99 := Qt6.P0,
      rir_reg% hty 100 := Qt6.P1,
      rir_reg% hty 101 := Qt6.P2,
      rir_reg% hty 102 := Qt6.P3,
      rir_reg% hty 103 := Qt6.P4])
    (hwf : S.WF) (hF : SlotFrame B 60 S.mem)
    (hSA : S.alloc = ⟨B.alloc.nextFreeBlock + n⟩) (hSE : S.mem.eraseFrom B.alloc.nextFreeBlock = M)
    (hZ : Room S.mem Z0 256 ∧ Room S.mem Z1 256 ∧ Room S.mem Z2 256 ∧ Room S.mem Z3 256 ∧
      Room S.mem Z4 256)
    (hZB : Z0.id.id < B.alloc.nextFreeBlock ∧ Z1.id.id < B.alloc.nextFreeBlock ∧
      Z2.id.id < B.alloc.nextFreeBlock ∧ Z3.id.id < B.alloc.nextFreeBlock ∧
      Z4.id.id < B.alloc.nextFreeBlock)
    (hK :
      ∀ S' : GlobalState, S'.WF → (hKA : S'.alloc = ⟨B.alloc.nextFreeBlock + n + 20⟩) →
        (hKE : S'.mem.eraseFrom B.alloc.nextFreeBlock =
          M.storeTmp5 Z0 Z1 Z2 Z3 Z4
            (let t12 := Quad5.laneIf 1 1 0 0 Qt11 X
             let t13 := fd_r52x5_quad_mul.spec t12 Qt6
             let t14 := Quad5.permute 0 1 3 2 t13
             let t15 := Quad5.permute 1 0 3 2 t14
             let t16 := fd_r52x5_quad_negate_lazy.spec t14
             let t17 := Quad5.laneIf 1 0 1 0 t16 t14
             let t18 := fd_r52x5_quad_add_nc.spec t15 t17
             let t19 := fd_r52x5_quad_reduce.spec t18
             let t20 := Quad5.permute 0 3 3 0 t19
             let t21 := Quad5.permute 2 1 2 1 t19
             let t22 := fd_r52x5_quad_mul.spec t20 t21
             t22)) →
        ∀ E' : ⟪Γ⟫, (blk.runBodyFrom E' 321 S' >>= g) = K) :
    (blk.runBodyFrom E 206 S >>= g) = K := by
  -- the outputs' room, about `S0`: out of the patterns' sight until the stores
  obtain ⟨S0, hS0⟩ : ∃ S0, S0 = S := ⟨_, rfl⟩
  rw [← hS0] at hZ
  step_pattern' using runBodyFrom_blendRun 1 1 0 0 with t12
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq) with t13
  step_pattern' using runBodyFrom_permuteRun 0 1 3 2 with t14
  step_pattern' using runBodyFrom_permuteRun 1 0 3 2 with t15
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_negate_lazy.call_eq) with t16
  step_pattern' using runBodyFrom_blendRun 1 0 1 0 with t17
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t18
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_reduce.call_eq) with t19
  step_pattern' using runBodyFrom_permuteRun 0 3 3 0 with t20
  step_pattern' using runBodyFrom_permuteRun 2 1 2 1 with t21
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq) with t22
  subst hS0
  obtain ⟨hz0, hz1, hz2, hz3, hz4⟩ := hZ
  replace hz0 : Room S.mem Z0 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hZB.1)
    exact hz0
  replace hz1 : Room S.mem Z1 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hZB.2.1)
    exact hz1
  replace hz2 : Room S.mem Z2 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hZB.2.2.1)
    exact hz2
  replace hz3 : Room S.mem Z3 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hZB.2.2.2.1)
    exact hz3
  replace hz4 : Room S.mem Z4 256 := by
    rw [hS]; repeat (refine room_callTmp5_slots ?_ hZB.2.2.2.2)
    exact hz4
  clear hF hidx hR
  iterate 5 step_store
  have hB : ∀ j, B.alloc.nextFreeBlock ≤ (B.slot j).id.id := fun j => by simp
  refine hK _ (by mem_fact) (by rw [hS]; simp only [hSA]) ?_ E
  rw [hS, ← hSE]
  subst_vars
  simp (disch := first | exact hB _ | omega) only [MemoryState.eraseFrom_storeAt,
    MemoryState.eraseFrom_callTmp5_of_le]
  rfl

end fd_r52x5_quad_ge_add

namespace fd_r52x5_quad_ge_add

-- the lead's constant vectors, read for each fact: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_ge_add`'s lead: its constants, and the facts the patterns read of them. -/
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
        (hvec :
          E' ⊨ [rir_reg% hty 4 := (#v[1#64, 1#64, 2#64, 1859910466990425#64] : Wl),
            rir_reg% hty 5 := (#v[0#64, 0#64, 0#64, 932731440258426#64] : Wl),
            rir_reg% hty 6 := (#v[0#64, 0#64, 0#64, 1072319116312658#64] : Wl),
            rir_reg% hty 7 := (#v[0#64, 0#64, 0#64, 1815898335770999#64] : Wl),
            rir_reg% hty 8 := (#v[0#64, 0#64, 0#64, 633789495995903#64] : Wl)]) →
        (blk.runBodyFrom E' 9 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  iterate 9 step_pure
  have hidx :
      E ⊨ [rir_reg% hty 0 := (1#32 : BitVec 32), rir_reg% hty 1 := (0#32 : BitVec 32),
        rir_reg% hty 2 := (3#32 : BitVec 32), rir_reg% hty 3 := (2#32 : BitVec 32)] := by
    rw [hE]; lemma_reads
  have hvec :
      E ⊨ [rir_reg% hty 4 := (#v[1#64, 1#64, 2#64, 1859910466990425#64] : Wl),
        rir_reg% hty 5 := (#v[0#64, 0#64, 0#64, 932731440258426#64] : Wl),
        rir_reg% hty 6 := (#v[0#64, 0#64, 0#64, 1072319116312658#64] : Wl),
        rir_reg% hty 7 := (#v[0#64, 0#64, 0#64, 1815898335770999#64] : Wl),
        rir_reg% hty 8 := (#v[0#64, 0#64, 0#64, 633789495995903#64] : Wl)] := by
    rw [hE]; lemma_reads
  exact hK E hArgs hidx hvec

end fd_r52x5_quad_ge_add

-- the lead's constant vectors, read at each pattern: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_ge_add` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order; its `alloca` slots
and the permutes' are freed. -/
public theorem fd_r52x5_quad_ge_add.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X Y : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_ge_add.call
        (fd_r52x5_quad_ge_add.args (.value _z0) (.value _z1) (.value _z2) (.value _z3) (.value _z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
          (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 90⟩,
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_ge_add.spec X Y) }) := by
  func_init
  block_init
  obtain ⟨M, hM⟩ : ∃ M, S.mem = M := ⟨_, rfl⟩
  refine fd_r52x5_quad_ge_add.lead (blk := entry) rfl hEargs fun E hArgs hidx hvec => ?_
  clear hEargs
  refine runBodyFrom_allocas ([%39, %40, %41, %42, %43, %44, %45, %46, %47, %48, %49, %50, %51, %52,
    %53, %54, %55, %56, %57, %58, %59, %60, %61, %62, %63, %64, %65, %66, %67, %68, %69, %70, %71,
    %72, %73, %74, %75, %76, %77, %78, %79, %80, %81, %82, %83, %84, %85, %86, %87, %88, %89, %90,
    %91, %92, %93, %94, %95, %96, %97, %98] : List (Dst fd_r52x5_quad_ge_add.Γ .ptr))
    (rest := entry.body.drop 69) rfl hwf ?_
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
  rw [GlobalState.WF.eraseFrom hwf₀, hM] at hErase
  step_pattern' using runBodyFrom_permuteRun 1 0 3 2 with t0
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_negate_lazy.call_eq) with t1
  step_pattern' using runBodyFrom_blendRun 1 0 1 0 with t2
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t3
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_reduce.call_eq) with t4
  step_pattern' using runBodyFrom_blendRun 1 1 0 0 with t5
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq) (Y := ⟨#v[1, 1, 2,
    1859910466990425], #v[0, 0, 0, 932731440258426], #v[0, 0, 0, 1072319116312658], #v[0, 0, 0,
    1815898335770999], #v[0, 0, 0, 633789495995903]⟩) with t6
  step_pattern' using runBodyFrom_permuteRun 1 0 3 2 with t7
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_negate_lazy.call_eq) with t8
  step_pattern' using runBodyFrom_blendRun 1 0 1 0 with t9
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t10
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_reduce.call_eq) with t11
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
  step_pattern' using fd_r52x5_quad_ge_add.run206
    (hZB := ⟨hz0, hz1, hz2, hz3, hz4⟩) (n := 70) (M := M)
    (hSA := by rw [hS]; simp only [hA]) (hSE := by rw [hS]; erase_frame; exact hErase)
  finish_block
  subst hS
  rw [hKA, hKE]
  clear hArgs
  subst_vars
  simp only [fd_r52x5_quad_ge_add.spec]

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
