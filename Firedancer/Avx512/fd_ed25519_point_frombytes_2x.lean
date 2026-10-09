module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.fd_r43x6_ge_decode2
public import Firedancer.Avx512.Mlir.fd_ed25519_point_frombytes_2x

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `FD_R43X6_GE_DECODE2` of the encodings `e1` and `e2`: the return value and both points. -/
noncomputable def fd_ed25519_point_frombytes_2x.spec (e1 e2 : BitVec 256) :
    BitVec 32 × Quad × Quad :=
  fd_r43x6_ge_decode2.spec (fd_r43x6_ge_decode2.dec e1) (fd_r43x6_ge_decode2.dec e2)

end

/-! ## Proof -/

section Proof

/-- Six 64-byte `alloca`s. -/
abbrev allocas6 (S : GlobalState) : GlobalState :=
  (((((S.alloca 64).alloca 64).alloca 64).alloca 64).alloca 64).alloca 64

/-- Slot `k` of the six fits its 64 bytes. -/
theorem fits_slot {S : GlobalState} (hwf : S.WF) (k : Nat) (hk : k < 6) :
    Fits (allocas6 S).mem (S.slot k) 512 := by
  have w1 := hwf.alloca (n := 64)
  have w2 := w1.alloca (n := 64)
  have w3 := w2.alloca (n := 64)
  have w4 := w3.alloca (n := 64)
  have w5 := w4.alloca (n := 64)
  have hn : ∀ (s : GlobalState), (s.alloca 64).alloc.nextFreeBlock = s.alloc.nextFreeBlock + 1 :=
    fun _ => rfl
  have hfresh : ∀ (s : GlobalState), Fits (s.alloca 64).mem (s.slot 0) 512 :=
    fun _ => Fits.allocaPtr (by omega)
  obtain _|_|_|_|_|_|k := k
  · exact ((((((hfresh S).alloca w1).alloca w2).alloca w3).alloca w4).alloca w5)
  · have h := hfresh (S.alloca 64)
    rw [GlobalState.alloca_slot] at h
    exact (((h.alloca w2).alloca w3).alloca w4).alloca w5
  · have h := hfresh ((S.alloca 64).alloca 64)
    rw [GlobalState.alloca_slot, GlobalState.alloca_slot] at h
    exact ((h.alloca w3).alloca w4).alloca w5
  · have h := hfresh (((S.alloca 64).alloca 64).alloca 64)
    rw [GlobalState.alloca_slot, GlobalState.alloca_slot, GlobalState.alloca_slot] at h
    exact (h.alloca w4).alloca w5
  · have h := hfresh ((((S.alloca 64).alloca 64).alloca 64).alloca 64)
    rw [GlobalState.alloca_slot, GlobalState.alloca_slot, GlobalState.alloca_slot,
      GlobalState.alloca_slot] at h
    exact h.alloca w5
  · have h := hfresh (((((S.alloca 64).alloca 64).alloca 64).alloca 64).alloca 64)
    rw [GlobalState.alloca_slot, GlobalState.alloca_slot, GlobalState.alloca_slot,
      GlobalState.alloca_slot, GlobalState.alloca_slot] at h
    exact h
  · omega

/-- `fd_ed25519_point_frombytes_2x` stores `spec`'s points of the encodings at `buf1` and `buf2` at
`r1`, then `r2`, and returns its value; six temporaries and the decoder's frames count `30`
blocks. -/
public theorem fd_ed25519_point_frombytes_2x.call_eq (r1 buf1 r2 buf2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr1 : s.mem.QuadFit r1) (hr2 : s.mem.QuadFit r2) (hb1 : Fits s.mem buf1 256)
    (hb2 : Fits s.mem buf2 256) :
    fd_ed25519_point_frombytes_2x.call
        (fd_ed25519_point_frombytes_2x.args (.value r1) (.value buf1) (.value r2) (.value buf2)) s =
      let R := fd_ed25519_point_frombytes_2x.spec (s.mem.readAt buf1 256) (s.mem.readAt buf2 256)
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 30⟩,
            mem := (s.mem.storeQuad r1 R.2.1).storeQuad r2 R.2.2 }) := by
  func_init
  block_init
  step_pure
  iterate 6 step_alloca
  iterate 6 step_pure
  have hids : [v1.id, v2.id, v3.id, v4.id, v5.id, v6.id].Nodup := by
    simp [hv1, hv2, hv3, hv4, hv5, hv6, GlobalState.slot]
  step_call using fd_r43x6_ge_decode2.call_eq consuming hids
  -- FD_R43X6_QUAD_MOV( r1->P, _Pa ); FD_R43X6_QUAD_MOV( r2->P, _Pb );
  iterate 2
    step_load
    step_store
    iterate 2
      step_load
      step_pure
      step_store
  iterate 6 step_pure
  finish_block
  subst hS
  erase_frame
  subst hv1 hv2 hv3 hv4 hv5 hv6
  have hids : [(S₀.slot 0).id, (S₀.slot 1).id, (S₀.slot 2).id, (S₀.slot 3).id, (S₀.slot 4).id,
      (S₀.slot 5).id].Nodup := by
    simp [GlobalState.slot]
  simp only [fd_r43x6_ge_decode2.readAt_storeOut_a03 hids (fits_slot hwf₀ 0 (by decide)),
    fd_r43x6_ge_decode2.readAt_storeOut_a14 hids (fits_slot hwf₀ 1 (by decide)),
    fd_r43x6_ge_decode2.readAt_storeOut_a25 hids (fits_slot hwf₀ 2 (by decide)),
    fd_r43x6_ge_decode2.readAt_storeOut_b03 hids (fits_slot hwf₀ 3 (by decide)),
    fd_r43x6_ge_decode2.readAt_storeOut_b14 hids (fits_slot hwf₀ 4 (by decide)),
    fd_r43x6_ge_decode2.readAt_storeOut_b25 (fits_slot hwf₀ 5 (by decide)),
    Ty.extractVecElem_packLanes, Fin.getElem_fin, Vector.ofFn_getElem]
  rfl

end Proof

end MLIR.Firedancer.Avx512
