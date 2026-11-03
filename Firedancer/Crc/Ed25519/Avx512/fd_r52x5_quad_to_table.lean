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
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_to_table

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_to_table( _z0 … _z4, x0 … x4 )`: the table entry `(Y - X, Y + X, 2 Z, 2 d T)` of
the point `X = (X, Y, Z, T)`. The QUAD macros in the compiled order. -/
def fd_r52x5_quad_to_table.spec (X : Quad5) : Quad5 :=
  let c0 : Quad5 := ⟨#v[1, 1, 2, 1859910466990425], #v[0, 0, 0, 932731440258426],
    #v[0, 0, 0, 1072319116312658], #v[0, 0, 0, 1815898335770999], #v[0, 0, 0, 633789495995903]⟩
  let t0 := Quad5.permute 1 0 3 2 X
  let t1 := fd_r52x5_quad_negate_lazy.spec X
  let t2 := Quad5.laneIf 1 0 1 0 t1 X
  let t3 := fd_r52x5_quad_add_nc.spec t0 t2
  let t4 := fd_r52x5_quad_reduce.spec t3
  let t5 := Quad5.laneIf 1 1 0 0 t4 X
  let t6 := fd_r52x5_quad_mul.spec t5 c0
  t6

end

/-! ## Proof -/

section Proof

namespace fd_r52x5_quad_to_table

-- the lead's constant vectors, read for each fact: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_to_table`'s lead: its constants, and the facts the patterns read of them. -/
theorem lead {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 0 = entry.body.drop 0) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer} {X : Quad5}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hK :
      ∀ E' : ⟪Γ⟫,
        (hArgs : E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get) →
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

end fd_r52x5_quad_to_table

-- the lead's constant vectors, read at each pattern: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_to_table` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order; its `alloca`
slots and the permutes' are freed. -/
public theorem fd_r52x5_quad_to_table.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_to_table.call
        (fd_r52x5_quad_to_table.args (.value _z0) (.value _z1) (.value _z2) (.value _z3)
          (.value _z4) (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 25⟩,
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_to_table.spec X) }) := by
  func_init
  block_init
  refine fd_r52x5_quad_to_table.lead (blk := entry) rfl hEargs fun E hArgs hidx hvec => ?_
  clear hEargs
  refine runBodyFrom_allocas ([%223, %224, %225, %226, %227, %228, %229, %230, %231, %232, %233,
    %234, %235, %236, %237, %238, %239, %240, %241,
    %242] : List (Dst fd_r52x5_quad_to_table.Γ .ptr))
    (rest := entry.body.drop 29) rfl hwf ?_
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
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq) (Y := ⟨#v[1, 1, 2,
    1859910466990425], #v[0, 0, 0, 932731440258426], #v[0, 0, 0, 1072319116312658], #v[0, 0, 0,
    1815898335770999], #v[0, 0, 0, 633789495995903]⟩) with t6
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
  clear hF hidx hvec
  iterate 5 step_store
  finish_block
  subst hS
  erase_frame
  rw [hErase, GlobalState.WF.eraseFrom hwf, hA]
  clear hArgs
  subst_vars
  simp only [fd_r52x5_quad_to_table.spec]
  rfl

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
