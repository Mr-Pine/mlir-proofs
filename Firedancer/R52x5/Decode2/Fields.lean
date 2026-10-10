module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Decode2.Frame
public import Firedancer.R52x5.Decode2.Spec
public import Firedancer.R52x5.fd_memcpy
public import Firedancer.R52x5.fd_f25519_sqr2
public import Firedancer.R52x5.fd_f25519_mul2
public import Firedancer.R52x5.wwl_st
import Firedancer.R52x5.Decode2.Tactics

namespace MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

open Firedancer.Avx512 (Wwl wwl)

@[expose] public section

variable {Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb : Pointer}

-- the two copies, both encodings to `u v⁷` and `_Quv`: 73 instructions, each callee's facts carried
set_option maxHeartbeats 400000 in
/-- `^bb0` from the sign bytes to `_Quv`: both encodings at `sa sb` (`sA sB`) through `pre`, their
values the checks need stored, `_Quv = quv` in registers. -/
theorem fields_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} (sA sB : BitVec 256)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 46 := B.slot 3, rir_reg% hty 47 := B.slot 4, rir_reg% hty 48 := B.slot 5,
        rir_reg% hty 49 := B.slot 6, rir_reg% hty 50 := B.slot 7, rir_reg% hty 51 := B.slot 8,
        rir_reg% hty 52 := B.slot 9, rir_reg% hty 53 := B.slot 10, rir_reg% hty 54 := B.slot 11,
        rir_reg% hty 55 := B.slot 12, rir_reg% hty 56 := B.slot 13, rir_reg% hty 57 := B.slot 14,
        rir_reg% hty 58 := B.slot 15, rir_reg% hty 59 := B.slot 16, rir_reg% hty 60 := B.slot 17,
        rir_reg% hty 61 := B.slot 18, rir_reg% hty 62 := B.slot 19, rir_reg% hty 63 := B.slot 20,
        rir_reg% hty 80 := B.slot 37, rir_reg% hty 81 := B.slot 38, rir_reg% hty 82 := B.slot 39,
        rir_reg% hty 83 := B.slot 40, rir_reg% hty 16 := B.slot 1, rir_reg% hty 17 := B.slot 2,
        rir_reg% hty 14 := 32#64, rir_reg% hty 15 := 127#8, rir_reg% hty 18 :=
        (Vector.replicate 4 PoisonOr.poison : ⟦.vec 4 64⟧), rir_reg% hty 19 := 0#64,
        rir_reg% hty 20 := 1#64, rir_reg% hty 21 := 2#64, rir_reg% hty 22 := 3#64])
    (hI : Inv B M 0 S) (hG : Globals B M) (hsa : Fits S.mem sa 256) (hsb : Fits S.mem sb 256)
    (hsA : S.mem.readAt sa 256 = sA) (hsB : S.mem.readAt sb 256 = sB)
    (hsa_off : ¬sa.offset.uaddOverflow 32#64) (hsb_off : ¬sb.offset.uaddOverflow 32#64)
    (hsa_lt : sa.id.id < B.alloc.nextFreeBlock) (hsb_lt : sb.id.id < B.alloc.nextFreeBlock)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 247 303 →
          (E' ⊨ [rir_reg% hty 248 := sA.extractLsb' 248 8, rir_reg% hty 250 := sB.extractLsb' 248 8,
            rir_reg% hty 270 := (quv (pre sA) (pre sB)).P0, rir_reg% hty 278 :=
            (quv (pre sA) (pre sB)).P1, rir_reg% hty 286 := (quv (pre sA) (pre sB)).P2,
            rir_reg% hty 294 := (quv (pre sA) (pre sB)).P3, rir_reg% hty 302 :=
            (quv (pre sA) (pre sB)).P4]) →
          Inv B M 0 S' →
          (∀ j, 3 ≤ j → j < 21 → Fits S'.mem (B.slot j) 512) →
          S'.mem.readVec (B.slot 3) = (pre sA).y →
          S'.mem.readVec (B.slot 4) = (pre sA).u →
          S'.mem.readVec (B.slot 5) = (pre sA).v →
          S'.mem.readVec (B.slot 10) = (pre sA).uv3 →
          S'.mem.readVec (B.slot 12) = (pre sB).y →
          S'.mem.readVec (B.slot 13) = (pre sB).u →
          S'.mem.readVec (B.slot 14) = (pre sB).v →
          S'.mem.readVec (B.slot 19) = (pre sB).uv3 → (bb0.runBodyFrom E' 354 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 281 S >>= g) = K := by
  have hg1 := hI.fits hG.one_fits
  have hg2 := hI.fits hG.d_fits
  have hone := (hI.readVec (p := B.slot 1) (by simp [GlobalState.slot])).trans hG.one
  have hd := (hI.readVec (p := B.slot 2) (by simp [GlobalState.slot])).trans hG.d
  clear hG
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  have hsa_ne : sa.id ≠ (B.slot 37).id := fun h => by
    have := congrArg BlockId.id h; simp [GlobalState.slot] at this; omega
  have hsb_ne : sb.id ≠ (B.slot 38).id := fun h => by
    have := congrArg BlockId.id h; simp [GlobalState.slot] at this; omega
  have hsb_ne' : sb.id ≠ (B.slot 37).id := fun h => by
    have := congrArg BlockId.id h; simp [GlobalState.slot] at this; omega
  have hsa_ne' : sa.id ≠ (B.slot 38).id := fun h => by
    have := congrArg BlockId.id h; simp [GlobalState.slot] at this; omega
  have hb2a := hF.tmp 37
  have hb2b := hF.tmp 38
  have ho37 : (B.slot 37).offset = 0 := rfl
  have ho38 : (B.slot 38).offset = 0 := rfl
  step_pure
  step_load with sa31
  step_pure
  step_load with sb31
  step_pure
  -- `fd_memcpy( buf2a, bufa, 32UL ); buf2a[31] &= 0x7f;`
  step_call using fd_memcpy.call_eq
  step_pure
  step_load
  step_pure
  step_store
  step_pure
  step_call using fd_memcpy.call_eq
  step_pure
  step_load
  step_pure
  step_store
  clear hsa hsb
  have h3 := hF.vec 3
  have h4 := hF.vec 4
  have h5 := hF.vec 5
  have h6 := hF.vec 6
  have h7 := hF.vec 7
  have h8 := hF.vec 8
  have h9 := hF.vec 9
  have h10 := hF.vec 10
  have h11 := hF.vec 11
  have h12 := hF.vec 12
  have h13 := hF.vec 13
  have h14 := hF.vec 14
  have h15 := hF.vec 15
  have h16 := hF.vec 16
  have h17 := hF.vec 17
  have h18 := hF.vec 18
  have h19 := hF.vec 19
  have h20 := hF.vec 20
  -- `fd_f25519_frombytes( ya, buf2a )`, `yb`
  step_call using fd_f25519_frombytes.call_eq
  name_vec ya
  step_call using fd_f25519_frombytes.call_eq
  name_vec yb
  -- `fd_f25519_sqr2( ysqa, ya, ysqb, yb )`
  step_call using fd_f25519_sqr2.call_eq
  name_vec ysqb
  name_vec ysqa
  -- `ua = ysqa - one`, `ub`
  step_call using fd_f25519_sub.call_eq
  name_vec ua
  step_call using fd_f25519_sub.call_eq
  name_vec ub
  -- `fd_f25519_mul2( va, d, ysqa, vb, d, ysqb )`, `va += one`, `vb += one`
  step_call using fd_f25519_mul2.call_eq
  name_vec dysqb
  name_vec dysqa
  step_call using fd_f25519_add.call_eq
  name_vec va
  step_call using fd_f25519_add.call_eq
  name_vec vb
  -- `v2`, `v4`, `v3 = v v2`, `uv3 = u v3`, `uv7 = uv3 v4`
  step_call using fd_f25519_sqr2.call_eq
  name_vec v2b
  name_vec v2a
  step_call using fd_f25519_sqr2.call_eq
  name_vec v4b
  name_vec v4a
  step_call using fd_f25519_mul2.call_eq
  name_vec v3b
  name_vec v3a
  step_call using fd_f25519_mul2.call_eq
  name_vec uv3b
  name_vec uv3a
  step_call using fd_f25519_mul2.call_eq
  name_vec uv7b
  name_vec uv7a
  have h39 := hF.arr 39
  have h40 := hF.arr 40
  have ho39 : (B.slot 39).offset = 0 := rfl
  have ho40 : (B.slot 40).offset = 0 := rfl
  -- `wwl_st( ea, uv7a->el )`, `wwl_st( eb, uv7b->el )`
  step_pure
  step_load [ofFn_extractVecElem_readAt_512]
  step_call using wwl_st.call_eq
  step_pure
  step_load [ofFn_extractVecElem_readAt_512]
  step_call using wwl_st.call_eq
  -- `_Quv0 = wl( ea[0], eb[0], ea[0], eb[0] )`
  step_load [setWidth_packLanes]
  step_load [setWidth_packLanes]
  iterate 3 step_pure
  step_pure [insert4_eq]
  iterate 4 
    step_pure
    step_load
    step_pure
    step_load
    iterate 3 step_pure
    step_pure [insert4_eq]
  have hA : pre sA = ⟨(sA.extractLsb' 248 8 >>> 7).setWidth 32, ya, ua, va, uv3a, uv7a⟩ := by
    rw [huv7a, huv3a, hv4a, hv3a, hv2a, hva, hdysqa, hua, hysqa, hya]; rfl
  have hB : pre sB = ⟨(sB.extractLsb' 248 8 >>> 7).setWidth 32, yb, ub, vb, uv3b, uv7b⟩ := by
    rw [huv7b, huv3b, hv4b, hv3b, hv2b, hvb, hdysqb, hub, hysqb, hyb]; rfl
  have hBelow : Writes Ein E 247 303 := by
    rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  subst hsa31 hsb31
  refine
    hK E S hArgs hBelow ?_ ⟨hwf, hF, ?_, ?_⟩ ?_ (by rwa [hA]) (by rwa [hA]) (by rwa [hA])
      (by rwa [hA]) (by rwa [hB]) (by rwa [hB]) (by rwa [hB]) (by rwa [hB])
  · rw [hA, hB]
    env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeVec_slot, eraseFrom_storeAt_slot,
      eraseFrom_storeAt_slot_add, eraseFrom_lifetimeStart_slot]
    exact herase
  · rw [hS]
    exact halloc
  · -- the field elements stored, known
    intro j h3 hj
    obtain rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
      rfl | rfl | rfl :
      j = 3 ∨
        j = 4 ∨
        j = 5 ∨
        j = 6 ∨
        j = 7 ∨
        j = 8 ∨
        j = 9 ∨
        j = 10 ∨
        j = 11 ∨ j = 12 ∨ j = 13 ∨ j = 14 ∨ j = 15 ∨ j = 16 ∨ j = 17 ∨ j = 18 ∨ j = 19 ∨ j = 20 :=
      by omega
    all_goals mem_fact

end

end MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2
