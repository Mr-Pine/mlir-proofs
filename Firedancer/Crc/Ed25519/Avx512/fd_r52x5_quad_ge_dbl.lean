module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.Crc.Ed25519.Common.Wl
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_add_nc
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_mul
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_negate_lazy
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_reduce
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_sqr
public import Firedancer.Crc.Ed25519.Avx512.wl_permute
public import Firedancer.Crc.Ed25519.Avx512.QuadRuns
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_ge_dbl

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_ge_dbl( _z0 … _z4, x0 … x4 )`: the extended point `2 X`. The QUAD macros in the
compiled order. -/
def fd_r52x5_quad_ge_dbl.spec (X : Quad5) : Quad5 :=
  let t0 := Quad5.permute 1 0 3 2 X
  let t1 := fd_r52x5_quad_add_nc.spec t0 X
  let t2 := fd_r52x5_quad_reduce.spec t1
  let t3 := Quad5.permute 0 1 0 1 t2
  let t4 := Quad5.laneIf 1 1 1 0 X t3
  let t5 := fd_r52x5_quad_sqr.spec t4
  let t6 := Quad5.permute 0 0 0 0 t5
  let t7 := Quad5.permute 1 1 1 1 t5
  let t8 := Quad5.laneIf 1 1 1 0 t7 t5
  let t9 := fd_r52x5_quad_negate_lazy.spec t8
  let t10 := fd_r52x5_quad_add_nc.spec t5 t5
  let t11 := Quad5.laneIf 0 0 1 0 t10 quad5_zero
  let t12 := fd_r52x5_quad_add_nc.spec t6 t11
  let t13 := Quad5.laneIf 1 0 0 1 t7 quad5_zero
  let t14 := fd_r52x5_quad_add_nc.spec t12 t13
  let t15 := Quad5.laneIf 0 1 1 1 t9 quad5_zero
  let t16 := fd_r52x5_quad_add_nc.spec t14 t15
  let t17 := fd_r52x5_quad_reduce.spec t16
  let t18 := Quad5.permute 3 1 1 3 t17
  let t19 := Quad5.permute 2 0 2 0 t17
  let t20 := fd_r52x5_quad_mul.spec t18 t19
  t20

end

/-! ## Proof -/

section Proof

namespace fd_r52x5_quad_ge_dbl

-- the reads of the slots and QUADs the tail takes: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_ge_dbl` from position 266 to its stores, from the QUADs its tail reads in their
registers: their spec's tail stored at `_z0 … _z4`. -/
theorem run266 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 266 = entry.body.drop 266) {E : ⟪Γ⟫} {S B : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {Qt6 Qt7 Qt10 Qt9 : Quad5} {X : Quad5} {M : MemoryState} {n : Nat}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hidx : E ⊨ [rir_reg% hty 31 := (1#32 : BitVec 32), rir_reg% hty 32 := (0#32 : BitVec 32),
      rir_reg% hty 33 := (3#32 : BitVec 32), rir_reg% hty 34 := (2#32 : BitVec 32)])
    {C0 : ⟦.vec 32 8⟧} (hr0 : E.read (rir_reg% hty 69) = C0)
    (hc0 :
      C0[0] = .value 0#8 ∧
      C0[1] = .value 0#8 ∧
      C0[2] = .value 0#8 ∧
      C0[3] = .value 0#8 ∧
      C0[4] = .value 0#8 ∧
      C0[5] = .value 0#8 ∧
      C0[6] = .value 0#8 ∧
      C0[7] = .value 0#8 ∧
      C0[8] = .value 0#8 ∧
      C0[9] = .value 0#8 ∧
      C0[10] = .value 0#8 ∧
      C0[11] = .value 0#8 ∧
      C0[12] = .value 0#8 ∧
      C0[13] = .value 0#8 ∧
      C0[14] = .value 0#8 ∧
      C0[15] = .value 0#8 ∧
      C0[24] = .value 0#8 ∧
      C0[25] = .value 0#8 ∧
      C0[26] = .value 0#8 ∧
      C0[27] = .value 0#8 ∧
      C0[28] = .value 0#8 ∧
      C0[29] = .value 0#8 ∧
      C0[30] = .value 0#8 ∧
      C0[31] = .value 0#8)
    {C1 : ⟦.vec 4 64⟧} (hr1 : E.read (rir_reg% hty 73) = C1)
    (hc1 :
      C1[1] = .value 0#64 ∧
      C1[2] = .value 0#64)
    {C2 : ⟦.vec 32 8⟧} (hr2 : E.read (rir_reg% hty 105) = C2)
    (hc2 :
      C2[0] = .value 0#8 ∧
      C2[1] = .value 0#8 ∧
      C2[2] = .value 0#8 ∧
      C2[3] = .value 0#8 ∧
      C2[4] = .value 0#8 ∧
      C2[5] = .value 0#8 ∧
      C2[6] = .value 0#8 ∧
      C2[7] = .value 0#8)
    (hR : E ⊨ [
      rir_reg% hty 131 := B.slot 25,
      rir_reg% hty 132 := B.slot 26,
      rir_reg% hty 133 := B.slot 27,
      rir_reg% hty 134 := B.slot 28,
      rir_reg% hty 135 := B.slot 29,
      rir_reg% hty 136 := B.slot 30,
      rir_reg% hty 137 := B.slot 31,
      rir_reg% hty 138 := B.slot 32,
      rir_reg% hty 139 := B.slot 33,
      rir_reg% hty 140 := B.slot 34,
      rir_reg% hty 141 := B.slot 35,
      rir_reg% hty 142 := B.slot 36,
      rir_reg% hty 143 := B.slot 37,
      rir_reg% hty 144 := B.slot 38,
      rir_reg% hty 145 := B.slot 39,
      rir_reg% hty 146 := B.slot 40,
      rir_reg% hty 147 := B.slot 41,
      rir_reg% hty 148 := B.slot 42,
      rir_reg% hty 149 := B.slot 43,
      rir_reg% hty 150 := B.slot 44,
      rir_reg% hty 151 := B.slot 45,
      rir_reg% hty 152 := B.slot 46,
      rir_reg% hty 153 := B.slot 47,
      rir_reg% hty 154 := B.slot 48,
      rir_reg% hty 155 := B.slot 49,
      rir_reg% hty 186 := Qt6.P0,
      rir_reg% hty 187 := Qt6.P1,
      rir_reg% hty 188 := Qt6.P2,
      rir_reg% hty 189 := Qt6.P3,
      rir_reg% hty 190 := Qt6.P4,
      rir_reg% hty 191 := Qt7.P0,
      rir_reg% hty 192 := Qt7.P1,
      rir_reg% hty 193 := Qt7.P2,
      rir_reg% hty 194 := Qt7.P3,
      rir_reg% hty 195 := Qt7.P4,
      rir_reg% hty 206 := wlBytes Qt10.P0,
      rir_reg% hty 207 := wlBytes Qt10.P1,
      rir_reg% hty 208 := wlBytes Qt10.P2,
      rir_reg% hty 209 := wlBytes Qt10.P3,
      rir_reg% hty 210 := wlBytes Qt10.P4,
      rir_reg% hty 201 := wlBytes Qt9.P0,
      rir_reg% hty 202 := wlBytes Qt9.P1,
      rir_reg% hty 203 := wlBytes Qt9.P2,
      rir_reg% hty 204 := wlBytes Qt9.P3,
      rir_reg% hty 205 := wlBytes Qt9.P4])
    (hwf : S.WF) (hF : SlotFrame B 50 S.mem)
    (hSA : S.alloc = ⟨B.alloc.nextFreeBlock + n⟩) (hSE : S.mem.eraseFrom B.alloc.nextFreeBlock = M)
    (hZ : Room S.mem Z0 256 ∧ Room S.mem Z1 256 ∧ Room S.mem Z2 256 ∧ Room S.mem Z3 256 ∧
      Room S.mem Z4 256)
    (hZB : Z0.id.id < B.alloc.nextFreeBlock ∧ Z1.id.id < B.alloc.nextFreeBlock ∧
      Z2.id.id < B.alloc.nextFreeBlock ∧ Z3.id.id < B.alloc.nextFreeBlock ∧
      Z4.id.id < B.alloc.nextFreeBlock)
    (hK :
      ∀ S' : GlobalState, S'.WF → (hKA : S'.alloc = ⟨B.alloc.nextFreeBlock + n + 10⟩) →
        (hKE : S'.mem.eraseFrom B.alloc.nextFreeBlock =
          M.storeTmp5 Z0 Z1 Z2 Z3 Z4
            (let t11 := Quad5.laneIf 0 0 1 0 Qt10 quad5_zero
             let t12 := fd_r52x5_quad_add_nc.spec Qt6 t11
             let t13 := Quad5.laneIf 1 0 0 1 Qt7 quad5_zero
             let t14 := fd_r52x5_quad_add_nc.spec t12 t13
             let t15 := Quad5.laneIf 0 1 1 1 Qt9 quad5_zero
             let t16 := fd_r52x5_quad_add_nc.spec t14 t15
             let t17 := fd_r52x5_quad_reduce.spec t16
             let t18 := Quad5.permute 3 1 1 3 t17
             let t19 := Quad5.permute 2 0 2 0 t17
             let t20 := fd_r52x5_quad_mul.spec t18 t19
             t20)) →
        ∀ E' : ⟪Γ⟫, (blk.runBodyFrom E' 386 S' >>= g) = K) :
    (blk.runBodyFrom E 266 S >>= g) = K := by
  -- the outputs' room, about `S0`: out of the patterns' sight until the stores
  obtain ⟨S0, hS0⟩ : ∃ S0, S0 = S := ⟨_, rfl⟩
  rw [← hS0] at hZ
  step_pattern' using runBodyFrom_byteBlendQuadRun_0010 (hC := hc0) with t11
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t12
  step_pattern' using runBodyFrom_zeroBlendQuadRun_1001 (hC := hc1) with t13
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t14
  step_pattern' using runBodyFrom_byteBlendQuadRun_0111 (hC := hc2) with t15
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t16
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_reduce.call_eq) with t17
  step_pattern' using runBodyFrom_permuteRun 3 1 1 3 with t18
  step_pattern' using runBodyFrom_permuteRun 2 0 2 0 with t19
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq) with t20
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
  clear hF hidx hc0 hr0 hc1 hr1 hc2 hr2 hR
  iterate 5 step_store
  have hB : ∀ j, B.alloc.nextFreeBlock ≤ (B.slot j).id.id := fun j => by simp
  refine hK _ (by mem_fact) (by rw [hS]; simp only [hSA]) ?_ E
  rw [hS, ← hSE]
  subst_vars
  simp (disch := first | exact hB _ | omega) only [MemoryState.eraseFrom_storeAt,
    MemoryState.eraseFrom_callTmp5_of_le]
  rfl

end fd_r52x5_quad_ge_dbl

namespace fd_r52x5_quad_ge_dbl

-- the lead's constant vectors, read for each fact: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_ge_dbl`'s lead: its constants, and the facts the patterns read of them. -/
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
          E' ⊨ [rir_reg% hty 31 := (1#32 : BitVec 32), rir_reg% hty 32 := (0#32 : BitVec 32),
            rir_reg% hty 33 := (3#32 : BitVec 32), rir_reg% hty 34 := (2#32 : BitVec 32)]) →
        (hc0 :
          (E'.read (rir_reg% hty 69))[0] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[1] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[2] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[3] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[4] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[5] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[6] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[7] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[8] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[9] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[10] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[11] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[12] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[13] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[14] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[15] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[24] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[25] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[26] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[27] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[28] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[29] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[30] = .value 0#8 ∧
          (E'.read (rir_reg% hty 69))[31] = .value 0#8) →
        (hc1 :
          (E'.read (rir_reg% hty 73))[1] = .value 0#64 ∧
          (E'.read (rir_reg% hty 73))[2] = .value 0#64) →
        (hc2 :
          (E'.read (rir_reg% hty 105))[0] = .value 0#8 ∧
          (E'.read (rir_reg% hty 105))[1] = .value 0#8 ∧
          (E'.read (rir_reg% hty 105))[2] = .value 0#8 ∧
          (E'.read (rir_reg% hty 105))[3] = .value 0#8 ∧
          (E'.read (rir_reg% hty 105))[4] = .value 0#8 ∧
          (E'.read (rir_reg% hty 105))[5] = .value 0#8 ∧
          (E'.read (rir_reg% hty 105))[6] = .value 0#8 ∧
          (E'.read (rir_reg% hty 105))[7] = .value 0#8) →
        (blk.runBodyFrom E' 106 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  iterate 38 step_pure
  step_pattern' using runBodyFrom_insertRun_32_8 inline
  step_pattern' using runBodyFrom_insertRun_4_64 inline
  step_pattern' using runBodyFrom_insertRun_32_8 inline
  have hidx :
      E ⊨ [rir_reg% hty 31 := (1#32 : BitVec 32), rir_reg% hty 32 := (0#32 : BitVec 32),
        rir_reg% hty 33 := (3#32 : BitVec 32), rir_reg% hty 34 := (2#32 : BitVec 32)] := by
    rw [hE]; lemma_reads
  have hc0 :
      (E.read (rir_reg% hty 69))[0] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[1] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[2] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[3] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[4] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[5] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[6] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[7] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[8] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[9] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[10] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[11] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[12] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[13] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[14] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[15] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[24] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[25] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[26] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[27] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[28] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[29] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[30] = .value 0#8 ∧
      (E.read (rir_reg% hty 69))[31] = .value 0#8 := by
    rw [hE]
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_,
      ?_, ?_⟩ <;> lemma_reads
  have hc1 :
      (E.read (rir_reg% hty 73))[1] = .value 0#64 ∧
      (E.read (rir_reg% hty 73))[2] = .value 0#64 := by
    rw [hE]
    refine ⟨?_, ?_⟩ <;> lemma_reads
  have hc2 :
      (E.read (rir_reg% hty 105))[0] = .value 0#8 ∧
      (E.read (rir_reg% hty 105))[1] = .value 0#8 ∧
      (E.read (rir_reg% hty 105))[2] = .value 0#8 ∧
      (E.read (rir_reg% hty 105))[3] = .value 0#8 ∧
      (E.read (rir_reg% hty 105))[4] = .value 0#8 ∧
      (E.read (rir_reg% hty 105))[5] = .value 0#8 ∧
      (E.read (rir_reg% hty 105))[6] = .value 0#8 ∧
      (E.read (rir_reg% hty 105))[7] = .value 0#8 := by
    rw [hE]
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> lemma_reads
  rw [hS]
  exact hK E hArgs hidx hc0 hc1 hc2

end fd_r52x5_quad_ge_dbl

-- the lead's constant vectors, read at each pattern: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_quad_ge_dbl` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order; its `alloca` slots
and the permutes' are freed. -/
public theorem fd_r52x5_quad_ge_dbl.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_ge_dbl.call
        (fd_r52x5_quad_ge_dbl.args (.value _z0) (.value _z1) (.value _z2) (.value _z3) (.value _z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 80⟩,
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_ge_dbl.spec X) }) := by
  func_init
  block_init
  obtain ⟨M, hM⟩ : ∃ M, S.mem = M := ⟨_, rfl⟩
  refine fd_r52x5_quad_ge_dbl.lead (blk := entry) rfl hEargs fun E hArgs hidx hc0 hc1 hc2 => ?_
  clear hEargs
  refine runBodyFrom_allocas ([%925, %926, %927, %928, %929, %930, %931, %932, %933, %934, %935,
    %936, %937, %938, %939, %940, %941, %942, %943, %944, %945, %946, %947, %948, %949, %950, %951,
    %952, %953, %954, %955, %956, %957, %958, %959, %960, %961, %962, %963, %964, %965, %966, %967,
    %968, %969, %970, %971, %972, %973, %974] : List (Dst fd_r52x5_quad_ge_dbl.Γ .ptr))
    (rest := entry.body.drop 156) rfl hwf ?_
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
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_add_nc.call_eq) with t1
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_reduce.call_eq) with t2
  step_pattern' using runBodyFrom_permuteRun 0 1 0 1 with t3
  step_pattern' using runBodyFrom_blendRun 1 1 1 0 with t4
  step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_sqr.call_eq) with t5
  step_pattern' using runBodyFrom_permuteRun 0 0 0 0 with t6
  step_pattern' using runBodyFrom_permuteRun 1 1 1 1 with t7
  step_pattern' using runBodyFrom_blendRun 1 1 1 0 with t8
  step_pattern' using runBodyFrom_leafRun1B (hf := fd_r52x5_quad_negate_lazy.call_eq) with t9
  step_pattern' using runBodyFrom_leafRun2B (hf := fd_r52x5_quad_add_nc.call_eq) with t10
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
  step_pattern' using fd_r52x5_quad_ge_dbl.run266 (hc0 := hc0) (hc1 := hc1) (hc2 := hc2)
    (hZB := ⟨hz0, hz1, hz2, hz3, hz4⟩) (n := 70) (M := M)
    (hSA := by rw [hS]; simp only [hA]) (hSE := by rw [hS]; erase_frame; exact hErase)
  finish_block
  subst hS
  rw [hKA, hKE]
  clear hArgs
  subst_vars
  simp only [fd_r52x5_quad_ge_dbl.spec]

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
