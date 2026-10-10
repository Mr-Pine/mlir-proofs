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

/-- Six 64-byte `alloca`s, dead until their lifetimes start. -/
abbrev allocas6 (S : GlobalState) : GlobalState :=
  (((((S.alloca 64 true).alloca 64 true).alloca 64 true).alloca 64 true).alloca 64 true).alloca 64
    true

/-- Slot `k` of the six is in bounds for its 64 bytes. -/
theorem inBounds_slot {S : GlobalState} (hwf : S.WF) (k : Nat) (hk : k < 6) :
    InBounds (allocas6 S).mem (S.slot k) 512 := by
  have w1 := hwf.alloca (n := 64) (d := true)
  have w2 := w1.alloca (n := 64) (d := true)
  have w3 := w2.alloca (n := 64) (d := true)
  have w4 := w3.alloca (n := 64) (d := true)
  have w5 := w4.alloca (n := 64) (d := true)
  have hfresh : ∀ (s : GlobalState), InBounds (s.alloca 64 true).mem (s.slot 0) 512 := fun _ =>
    InBounds.allocaPtr (by omega)
  obtain _ | _ | _ | _ | _ | _ | k := k
  · exact ((((((hfresh S).alloca w1).alloca w2).alloca w3).alloca w4).alloca w5)
  · have h := hfresh (S.alloca 64 true)
    rw [GlobalState.alloca_slot] at h
    exact (((h.alloca w2).alloca w3).alloca w4).alloca w5
  · have h := hfresh ((S.alloca 64 true).alloca 64 true)
    rw [GlobalState.alloca_slot, GlobalState.alloca_slot] at h
    exact ((h.alloca w3).alloca w4).alloca w5
  · have h := hfresh (((S.alloca 64 true).alloca 64 true).alloca 64 true)
    rw [GlobalState.alloca_slot, GlobalState.alloca_slot, GlobalState.alloca_slot] at h
    exact (h.alloca w4).alloca w5
  · have h := hfresh ((((S.alloca 64 true).alloca 64 true).alloca 64 true).alloca 64 true)
    rw [GlobalState.alloca_slot, GlobalState.alloca_slot, GlobalState.alloca_slot,
      GlobalState.alloca_slot] at h
    exact h.alloca w5
  · have h :=
      hfresh (((((S.alloca 64 true).alloca 64 true).alloca 64 true).alloca 64 true).alloca 64 true)
    rw [GlobalState.alloca_slot, GlobalState.alloca_slot, GlobalState.alloca_slot,
      GlobalState.alloca_slot, GlobalState.alloca_slot] at h
    exact h
  · omega

/-- The decoder's first two out-vectors are known, under its later stores: the steps only take
`storeVec_self` up to `₃`. -/
theorem fits_storeVec_self_storeVec₄ {m : MemoryState} (h : Room m p 512) :
    Fits (((((m.storeVec p v).storeVec q₁ v₁).storeVec q₂ v₂).storeVec q₃ v₃).storeVec q₄ v₄) p
      512 :=
  (Fits.storeVec_self h).storeVec.storeVec.storeVec.storeVec

@[inherit_doc fits_storeVec_self_storeVec₄]
theorem fits_storeVec_self_storeVec₅ {m : MemoryState} (h : Room m p 512) :
    Fits
      ((((((m.storeVec p v).storeVec q₁ v₁).storeVec q₂ v₂).storeVec q₃ v₃).storeVec q₄ v₄).storeVec
        q₅ v₅)
      p 512 :=
  (Fits.storeVec_self h).storeVec.storeVec.storeVec.storeVec.storeVec

/-- The decoder's last out-vector is known: the steps derive the room below five stores for
`storeVec_self` only four transports deep. -/
theorem fits_storeVec₅_storeVec_self {m : MemoryState} (h : Room m p 512) :
    Fits
      ((((((m.storeVec q₁ v₁).storeVec q₂ v₂).storeVec q₃ v₃).storeVec q₄ v₄).storeVec q₅
            v₅).storeVec
        p v)
      p 512 :=
  Fits.storeVec_self h.storeVec.storeVec.storeVec.storeVec.storeVec

attribute [local mlir_fresh] fits_storeVec_self_storeVec₄ fits_storeVec_self_storeVec₅
  fits_storeVec₅_storeVec_self

open fd_r43x6_ge_decode2 in
/-- `fd_r43x6_ge_decode2.call_eq` with `storeOut` spelled out: the steps record the stored
vectors' `Fits` only for a store chain written out. -/
theorem decode2_call_eq {a03 a14 a25 sa b03 b14 b25 sb : Pointer} (s : GlobalState) (hwf : s.WF)
    (hsa : Fits s.mem sa 256) (hsb : Fits s.mem sb 256) (ha03 : Room s.mem a03 512)
    (ha14 : Room s.mem a14 512) (ha25 : Room s.mem a25 512) (hb03 : Room s.mem b03 512)
    (hb14 : Room s.mem b14 512) (hb25 : Room s.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) :
    fd_r43x6_ge_decode2.call (argsOf a03 a14 a25 sa b03 b14 b25 sb) s =
      let R := spec (dec (s.mem.readAt sa 256)) (dec (s.mem.readAt sb 256))
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 24⟩,
            mem :=
              (((((s.mem.storeVec a03 R.2.1.P03).storeVec a14 R.2.1.P14).storeVec a25
                            R.2.1.P25).storeVec
                        b03 R.2.2.P03).storeVec
                    b14 R.2.2.P14).storeVec
                b25 R.2.2.P25 }) :=
  fd_r43x6_ge_decode2.call_eq s hwf hsa hsb ha03 ha14 ha25 hb03 hb14 hb25 hids

/-- `fd_ed25519_point_frombytes_2x` stores `spec`'s points of the encodings at `buf1` and `buf2` at
`r1`, then `r2`, and returns its value; six temporaries and the decoder's frames count `30`
blocks. -/
public theorem fd_ed25519_point_frombytes_2x.call_eq (r1 buf1 r2 buf2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr1 : s.mem.QuadRoom r1) (hr2 : s.mem.QuadRoom r2) (hb1 : Fits s.mem buf1 256)
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
  step_call using decode2_call_eq
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
  -- the last out-vector's read, which the steps leave unresolved
  have hin :
    InBounds
      (((((((allocas6 S₀).mem.lifetimeStart (S₀.slot 0)).lifetimeStart (S₀.slot 1)).lifetimeStart
                    (S₀.slot 2)).lifetimeStart
                (S₀.slot 3)).lifetimeStart
            (S₀.slot 4)).lifetimeStart
        (S₀.slot 5))
      (S₀.slot 5) 512 := by
    have h := inBounds_slot hwf₀ 5 (by decide)
    exact h.lifetimeStart.lifetimeStart.lifetimeStart.lifetimeStart.lifetimeStart.lifetimeStart
  simp only [fd_r43x6_ge_decode2.readAt_storeOut_b25 hin, Ty.extractVecElem_packLanes,
    Fin.getElem_fin, Vector.ofFn_getElem]
  rfl

end Proof

end MLIR.Firedancer.Avx512
