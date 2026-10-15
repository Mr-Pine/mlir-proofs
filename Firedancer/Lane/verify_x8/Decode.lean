module

public import Firedancer.Lane.verify_x8.DecodeLoop1
public import Firedancer.Lane.verify_x8.DecodeLoop2
public import Firedancer.Lane.verify_x8.DecodeMem
public import Firedancer.Lane.verify_x8.Tactics
public import Firedancer.Lane.fd_ed25519_lane_bcast_fe
public import Firedancer.Lane.fd_ed25519_lane_pow22523_2

/-! `fd_ed25519_lane_decode2` inlined into `verify_x8` (`^bb38 … ^bb41`): `d` and `sqrtm1`
broadcast, the first loop (`^bb40`, `n = 0, 1`), `fd_ed25519_lane_pow22523_2` (`^bb39`), the
second loop (`^bb41`, `n = 0, 1`). -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

attribute [local mlir_transport] MemoryState.FrameOn.storeAt MemoryState.FrameOn.storeAt_add
  MemoryState.FrameOn.storeVec MemoryState.FrameOn.storeVec_add MemoryState.FrameOn.lifetimeStart
  MemoryState.FrameOn.lifetimeEnd MemoryState.FrameOn.storeFe MemoryState.FrameOn.storeFe_add
  MemoryState.FrameOn.storeLanePoint Decode.frameOn_storePtr

namespace Decode

public section

/-- The first loop's values for `a`'s encodings. -/
abbrev preA (c : Call) : DecPre :=
  decPre (bcastBytes dBytes) (x8Buf c.cnt c.S c.A)

/-- The first loop's values for `r`'s encodings. -/
abbrev preR (c : Call) : DecPre :=
  decPre (bcastBytes dBytes) (x8Buf c.cnt c.S c.R)

/-- The second loop's point and mask for `a`: `c.decA`. -/
abbrev finA (c : Call) : Point × BitVec 32 :=
  decFin (bcastBytes sqrtm1Bytes) (signs (x8Buf c.cnt c.S c.A)) (preA c) (pow22523 (preA c).uv7)

/-- The second loop's point and mask for `r`: `c.decR`. -/
abbrev finR (c : Call) : Point × BitVec 32 :=
  decFin (bcastBytes sqrtm1Bytes) (signs (x8Buf c.cnt c.S c.R)) (preR c) (pow22523 (preR c).uv7)

/-- `fd_f25519_d`'s bytes. -/
theorem tobytes_d : tobytes fd_r43x6_ge_decode2.d = dBytes := by
  decide

/-- `fd_f25519_sqrtm1`'s bytes. -/
theorem tobytes_sqrtM1 : tobytes fd_r43x6_ge_decode2.sqrtM1 = sqrtm1Bytes := by
  decide

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

/-- `^bb39` up to its jump: `fd_ed25519_lane_pow22523_2( &r0->x, &uv7[0], &r1->x, &uv7[1] )`,
then `sqrtm1`'s limbs loaded. -/
theorem bb39_run (c : Call) (E : ⟪Γ⟫) (S : GlobalState) (Q : Fe)
    {G : ⟪Γ⟫ × GlobalState → PoisonOr β}
    (hA : E.args = c.args) (hD : EnvD c E) (hwf : S.WF) (ha0 : S.mem.FeFit (c.s.slot 21))
    (ha1 : S.mem.FeFit ((c.s.slot 21).add 320#64)) (hr0 : S.mem.FeRoom (c.s.slot 28))
    (hr1 : S.mem.FeRoom (c.s.slot 29)) (hq : S.mem.readFe (c.s.slot 23) = Q)
    (hq' : S.mem.FeFit (c.s.slot 23))
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = c.args → EnvD c E' →
        (E' ⊨ [rir_reg% hty 448 := Ty.wrap Q.l0, rir_reg% hty 450 := Ty.wrap Q.l1,
          rir_reg% hty 452 := Ty.wrap Q.l2, rir_reg% hty 454 := Ty.wrap Q.l3,
          rir_reg% hty 456 := Ty.wrap Q.l4]) →
        (verify_x8.bb39.runBodyFrom E' 10
            { S with
              mem := (S.mem.storeFe (c.s.slot 28) (pow22523 (S.mem.readFe (c.s.slot 21)))).storeFe
                (c.s.slot 29) (pow22523 (S.mem.readFe ((c.s.slot 21).add 320#64))) } >>= G) = K) :
    (verify_x8.bb39.runBodyFrom E 0 S >>= G) = K := by
  obtain ⟨S', hS'⟩ : ∃ s, s = S := ⟨_, rfl⟩
  have hqf : S'.mem.readFe (c.s.slot 23) = Q := hS' ▸ hq
  split_reads hD
  step_call using Firedancer.Lane.Mlir.fd_ed25519_lane_pow22523_2.call_eq
  step_load [vec_readFe_l0] inline
  iterate 4 (step_pure; step_load inline)
  subst hS
  refine hK _ hArgs (by env_reads) ?_
  env_reads
  · exact congrArg Ty.wrap (congrArg Fe.l0 (hS' ▸ hqf))
  · exact congrArg Ty.wrap (congrArg Fe.l1 (hS' ▸ hqf))
  · exact congrArg Ty.wrap (congrArg Fe.l2 (hS' ▸ hqf))
  · exact congrArg Ty.wrap (congrArg Fe.l3 (hS' ▸ hqf))
  · exact congrArg Ty.wrap (congrArg Fe.l4 (hS' ▸ hqf))

end

end Decode

open Decode

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

-- four loop iterations, two calls and their memory facts in one declaration
set_option maxHeartbeats 2000000 in
/-- `fd_ed25519_lane_decode2( &a, a_buf, &a_valid, &r, r_buf, &r_valid )`: the decodings at `a`
and `r`, the masks in registers. -/
public theorem decode_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : Env38 c E) (hS : c.At38 S)
    (h42 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env42 c E' → c.At42 S' →
        ((verify_x8 c.batch).runFrom E' 42 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 38 S >>= g) = K := by
  obtain ⟨hb, hks⟩ := hS
  have hbA := buf_facts c hc hb Item.pk c.A c.bufA (fun _ => rfl)
    (fun j hj => by simp [Call.A, hj, Item.readA])
    (fun j hj => by
      obtain ⟨-, -, -, -, -, hf, ho, -⟩ := hc.batch.ok j hj
      exact ⟨hf, ho, fun h => hc.batch.sep.1 (h ▸ Or.inr (Or.inr (Or.inr (Or.inr (Or.inr
        ⟨j, hj, Or.inr (Or.inr rfl)⟩)))))⟩)
  have hbR := buf_facts c hc hb Item.sig c.R c.bufR (fun _ => rfl)
    (fun j hj => by simp [Call.R, hj, Item.readR])
    (fun j hj => by
      obtain ⟨-, -, -, hf, ho, -⟩ := hc.batch.ok j hj
      exact ⟨hf.mono (by decide), BitVec.not_uaddOverflow_of_le ho (by decide),
        fun h => hc.batch.sep.1 (h ▸ Or.inr (Or.inr (Or.inr (Or.inr (Or.inr
          ⟨j, hj, Or.inr (Or.inl rfl)⟩)))))⟩)
  have hwf := hb.wf
  have h16 : InBounds S.mem (c.s.slot 16) 64 := hb.slots 16 (by decide)
  have h17 : InBounds S.mem (c.s.slot 17) 64 := hb.slots 17 (by decide)
  have h18 : InBounds S.mem (c.s.slot 18) 5120 := hb.slots 18 (by decide)
  have h19 : InBounds S.mem (c.s.slot 19) 5120 := hb.slots 19 (by decide)
  have h20 : InBounds S.mem (c.s.slot 20) 5120 := hb.slots 20 (by decide)
  have h21 : InBounds S.mem (c.s.slot 21) 5120 := hb.slots 21 (by decide)
  have h22 : InBounds S.mem (c.s.slot 22) 2560 := hb.slots 22 (by decide)
  have h23 : InBounds S.mem (c.s.slot 23) 2560 := hb.slots 23 (by decide)
  have h24 : InBounds S.mem (c.s.slot 24) 32 := hb.slots 24 (by decide)
  have h25 : InBounds S.mem (c.s.slot 25) 32 := hb.slots 25 (by decide)
  have h28 : InBounds S.mem (c.s.slot 28) 10240 := hb.slots 28 (by decide)
  have h29 : InBounds S.mem (c.s.slot 29) 10240 := hb.slots 29 (by decide)
  have w16 := hb.writable 16 (by decide)
  have w17 := hb.writable 17 (by decide)
  have w18 := hb.writable 18 (by decide)
  have w19 := hb.writable 19 (by decide)
  have w20 := hb.writable 20 (by decide)
  have w21 := hb.writable 21 (by decide)
  have w22 := hb.writable 22 (by decide)
  have w23 := hb.writable 23 (by decide)
  have w24 := hb.writable 24 (by decide)
  have w25 := hb.writable 25 (by decide)
  have w28 := hb.writable 28 (by decide)
  have w29 := hb.writable 29 (by decide)
  obtain ⟨S0, hS0⟩ : ∃ S', S' = S := ⟨_, rfl⟩
  have hfo0 : S0.mem.FrameOn S.mem (DKeep0 c) := hS0 ▸ MemoryState.FrameOn.refl _
  rw [← hS0] at hbA hbR hb hks
  have hk16 := not_dkeep0 c (k := 16) (by decide) (by decide) (by decide)
  have hk17 := not_dkeep0 c (k := 17) (by decide) (by decide) (by decide)
  have hk18 := not_dkeep0 c (k := 18) (by decide) (by decide) (by decide)
  have hk19 := not_dkeep0 c (k := 19) (by decide) (by decide) (by decide)
  have hk20 := not_dkeep0 c (k := 20) (by decide) (by decide) (by decide)
  have hk21 := not_dkeep0 c (k := 21) (by decide) (by decide) (by decide)
  have hk22 := not_dkeep0 c (k := 22) (by decide) (by decide) (by decide)
  have hk23 := not_dkeep0 c (k := 23) (by decide) (by decide) (by decide)
  have hk24 := not_dkeep0 c (k := 24) (by decide) (by decide) (by decide)
  have hk25 := not_dkeep0 c (k := 25) (by decide) (by decide) (by decide)
  have hk28 := not_dkeep0 c (k := 28) (by decide) (by decide) (by decide)
  have hk29 := not_dkeep0 c (k := 29) (by decide) (by decide) (by decide)
  -- `^bb38`: the slots' lifetimes, `r[]`, the signs, `d` and `sqrtm1` broadcast, `d` loaded
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨38, (by decide : 38 < 104)⟩ S >>= g) = K
  block_init
  iterate 4 step_pure
  step_store
  step_store
  iterate 8 step_pure
  step_store
  step_store
  have hfe22 : S.mem.FeRoom (c.s.slot 22) := ⟨by simp [BitVec.uaddOverflow], by mem_fact⟩
  step_call using Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.call_eq
  have hfe23 : S.mem.FeRoom (c.s.slot 23) := ⟨by simp [BitVec.uaddOverflow], by mem_fact⟩
  step_call using Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.call_eq
  iterate 4 step_pure
  iterate 5 step_load
  rw [tobytes_d] at hv443 hv444 hv445 hv446 hv447
  have hlp16 : S.mem.loadPtr (c.s.slot 16) = .value (c.s.slot 28) := by
    rw [hS]
    dsimp only
    rw [← hS0]
    simp (disch := (refine GlobalState.slot_id_ne ?_; omega)) only [lp_storeAt, lp_storePtr,
      lp_lifetimeStart, lp_storeFe]
    exact MemoryState.loadPtr_storePtr_self
      ((Room.lifetimeStart_self ((hb.slots 16 (by decide)).lifetimeStart.lifetimeStart)
        ((hb.writable 16 (by decide)).lifetimeStart.lifetimeStart)).lifetimeStart
        (GlobalState.slot_id_ne (i := 16) (j := 17) (by decide)))
  have hlp17 : S.mem.loadPtr (c.s.slot 17) = .value (c.s.slot 29) := by
    rw [hS]
    dsimp only
    rw [← hS0]
    simp (disch := (refine GlobalState.slot_id_ne ?_; omega)) only [lp_storeAt, lp_lifetimeStart,
      lp_storeFe]
    have h4 : Room ((((S0.mem.lifetimeStart (c.s.slot 28)).lifetimeStart
        (c.s.slot 29)).lifetimeStart (c.s.slot 16)).lifetimeStart (c.s.slot 17)) (c.s.slot 17) 64 :=
      Room.lifetimeStart_self ((hb.slots 17 (by decide)).lifetimeStart.lifetimeStart.lifetimeStart)
        ((hb.writable 17 (by decide)).lifetimeStart.lifetimeStart.lifetimeStart)
    exact MemoryState.loadPtr_storePtr_self h4.storePtr
  grab hq23 : S.mem.readFe (c.s.slot 23) = _
  rw [tobytes_sqrtM1] at hq23
  grab hf23 : S.mem.FeFit (c.s.slot 23)
  obtain ⟨S1, hS1⟩ : ∃ S', S' = S := ⟨_, rfl⟩
  have hfo1 : S1.mem.FrameOn S.mem (DKeep1 c) := hS1 ▸ MemoryState.FrameOn.refl _
  rw [← hS1] at hlp16 hlp17 hq23 hf23
  have hj18 := not_dkeep1 c (k := 18) (by decide) (by decide) (by decide)
  have hj19 := not_dkeep1 c (k := 19) (by decide) (by decide) (by decide)
  have hj20 := not_dkeep1 c (k := 20) (by decide) (by decide) (by decide)
  have hj21 := not_dkeep1 c (k := 21) (by decide) (by decide) (by decide)
  have hj22 := not_dkeep1 c (k := 22) (by decide) (by decide) (by decide)
  have hj24 := not_dkeep1 c (k := 24) (by decide) (by decide) (by decide)
  have hj25 := not_dkeep1 c (k := 25) (by decide) (by decide) (by decide)
  have hj28 := not_dkeep1 c (k := 28) (by decide) (by decide) (by decide)
  have hj29 := not_dkeep1 c (k := 29) (by decide) (by decide) (by decide)
  finish_block
  block_init
  subst hv443 hv444 hv445 hv446 hv447
  grab hs24 : S.mem.readAt (c.s.slot 24) 32 = _
  -- `^bb40`, `n = 0`: `a`'s encodings
  refine bb40_run c 1#1 (c.s.slot 24) (c.s.slot 16) (c.s.slot 28) (c.s.slot 18)
    (c.s.slot 19) (c.s.slot 20) (c.s.slot 21) c.bufA (x8Buf c.cnt c.S c.A) (bcastBytes dBytes)
    S E (g := g) rfl hArgs (by env_reads) (by env_reads)
    (fun j => ⟨hfo0.sameOn.fits (Or.inl (hbA j).2.2.2) (hbA j).1,
      (hfo0.sameOn.readAt (Or.inl (hbA j).2.2.2)).trans (hbA j).2.1, (hbA j).2.2.1⟩)
    (by mem_fact) hs24 (by mem_fact) (by mem_fact)
    ((hfo1.sameOn.loadPtr (Or.inl rfl)).trans hlp16) (by mem_fact) (by simp) (by mem_fact)
    (by simp [BitVec.uaddOverflow]) (by mem_fact) (by simp [BitVec.uaddOverflow]) (by mem_fact)
    (by simp [BitVec.uaddOverflow]) (by mem_fact) (by simp [BitVec.uaddOverflow])
    (by simp [GlobalState.slot]) ?_
  -- what it stored, read back
  intro E' hA' hD' hR'
  clear hE_0 hE_1 hE_2 hE_3 hE_4 hE_5 hE_6 hE_7 hE_8 hE_9 hE_10 hE_11 hE_12 hE_13 hE_14 hE_15 hE_16
    hE_17 hE_18 hE_19 hE_20 hE_21 hE_22 hE_23 hE_24 hE_25 hE_26 hE_27 hE_28 hE_29 hE_30 hE_31 hE_32
    hE_33 hE_34 hE_35 hE_36 hE_37 hE_38 hE_39 hE_40 hE_41 hE_42 hE_43 hE_44 hE_45 hE_46 hE_47 hE_48
    hE_49 hE_50 hE_51 hE_52 hE_53 hE_54 hE_55 hE_56 hE_57 hE_58 hE_59 hE_60 hE_61 hE_62 hE_63 hE_64
    hE_65 hE_66 hE_67 hE_68 hE_69 hE_70 hE_71 hE_72 hE_73 hE_74 hE_75 hE_76 hE_77 hE_78 hE_79 hE_80
    hE_81 hE_82 hE_83 hE_84 hE_85 hE_86 hE_87 hE_88 hE_89 hE_90 hE_91 hE_92 hE_93 hE_94 hE_95 hE_96
    hE_97 hE_98 hE_99 hE_100 hE_101 hE_102 hE_103 hE_104 hE_105 hE_106 hE_107 hE_108 hE_109 hE_110
    hE_111 hE_112 hE_113 hE_114 hE_115 hE_116 hE_117 hE_118 hE_119 hE_120 hE_121 hE_122 hE_123
    hE_124 hE_125 hE_126 hE_127 hE_128 hE_129 hE_130 hE_131 hE_132 hE_133 hE_134 hE_135 hE_136
    hE_137 hE_138 hE_139 hE_140 hE_141 hE_142 hE_143 hE_144 hE_145 hE_146 hE_147 hE_148 hE_149
    hE_150 hE_151 hE_152 hE_153 hE_154 hE_155 hE_156 hE_157 hE_158 hE_159 hE_160 hE_161 hE_162
    hE_163 hE_164 hE hArgs
  have hArgs := hA'
  clear hA'
  split_reads hD' hR'
  generalize hS2 : ({ S with mem := _ } : GlobalState) = S2
  replace hS2 := hS2.symm
  have hM2 := congrArg GlobalState.mem hS2
  dsimp only at hM2
  simp only [pointMem] at hS2
  have t0 : S0.mem.FrameOn S2.mem (DKeep0 c) := by rw [hS2]; frame_on
  have r28 : Room S2.mem (c.s.slot 28) 10240 := by mem_fact
  have r29 : Room S2.mem (c.s.slot 29) 10240 := by mem_fact
  have i16 : InBounds S2.mem (c.s.slot 16) 64 := by mem_fact
  have i17 : InBounds S2.mem (c.s.slot 17) 64 := by mem_fact
  have a0_18 : S2.mem.readFe (c.s.slot 18) = (preA c).u := by
    rw [hM2]
    rd
    exact MemoryState.readFe_storeFe_self ⟨by simp [BitVec.uaddOverflow], by rd_room⟩
  have f0_18 : Fits S2.mem (c.s.slot 18) 2560 := by
    rw [hM2]
    iterate 3 apply Fits.storeFe
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [BitVec.uaddOverflow], by rd_room⟩).2
  have a0_19 : S2.mem.readFe (c.s.slot 19) = (preA c).v := by
    rw [hM2]
    rd
    exact MemoryState.readFe_storeFe_self ⟨by simp [BitVec.uaddOverflow], by rd_room⟩
  have f0_19 : Fits S2.mem (c.s.slot 19) 2560 := by
    rw [hM2]
    iterate 2 apply Fits.storeFe
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [BitVec.uaddOverflow], by rd_room⟩).2
  have a0_20 : S2.mem.readFe (c.s.slot 20) = (preA c).uv3 := by
    rw [hM2]
    rd
    exact MemoryState.readFe_storeFe_self ⟨by simp [BitVec.uaddOverflow], by rd_room⟩
  have f0_20 : Fits S2.mem (c.s.slot 20) 2560 := by
    rw [hM2]
    iterate 1 apply Fits.storeFe
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [BitVec.uaddOverflow], by rd_room⟩).2
  have a0_21 : S2.mem.readFe (c.s.slot 21) = (preA c).uv7 := by
    rw [hM2]
    exact MemoryState.readFe_storeFe_self ⟨by simp [BitVec.uaddOverflow], by rd_room⟩
  have f0_21 : Fits S2.mem (c.s.slot 21) 2560 := by
    rw [hM2]
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [BitVec.uaddOverflow], by rd_room⟩).2
  have a0_y : S2.mem.readFe ((c.s.slot 28).add 320#64) = (preA c).y := by
    rw [hM2]
    rd
    exact pointMem_readFe_y (by simp) (by rd_room) _
  have f0_y : Fits S2.mem ((c.s.slot 28).add 320#64) 2560 := by
    rw [hM2]
    iterate 4 apply Fits.storeFe
    exact pointMem_fits_y (by simp) (by rd_room) _
  have a0_z : S2.mem.readFe ((c.s.slot 28).add 640#64) = Fe.one := by
    rw [hM2]
    rd
    exact pointMem_readFe_z (by simp) (by rd_room) _
  have f0_z : Fits S2.mem ((c.s.slot 28).add 640#64) 2560 := by
    rw [hM2]
    iterate 4 apply Fits.storeFe
    exact pointMem_fits_z1 (by simp) (by rd_room) _
  have a0_s : S2.mem.readAt (c.s.slot 24) 32 = signs (x8Buf c.cnt c.S c.A) := by
    rw [hM2]
    rd
    exact MemoryState.readAt_storeAt_self (by rd_room) _
  have f0_s : Fits S2.mem (c.s.slot 24) 32 := by
    rw [hM2]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt_self (by rd_room))
  have t0' : S1.mem.FrameOn S2.mem (DKeep1 c) := by rw [hS2]; frame_on
  grab hs25 : S.mem.readAt (c.s.slot 25) 32 = _
  have t2 : S2.mem.readAt (c.s.slot 25) 32 = 0#32 := by
    rw [hS2]
    dsimp only
    simp (disch := slot_ne) only [MemoryState.storeFe, MemoryState.storeVec, ra_storeAt]
    exact hs25
  clear hs25
  finish_block
  block_init
  -- `^bb40`, `n = 1`: `r`'s encodings
  refine bb40_run c 0#1 (c.s.slot 25) (c.s.slot 17) (c.s.slot 29) ((c.s.slot 18).add 320#64)
    ((c.s.slot 19).add 320#64) ((c.s.slot 20).add 320#64) ((c.s.slot 21).add 320#64) c.bufR
    (x8Buf c.cnt c.S c.R) (bcastBytes dBytes) S2 E (g := g) rfl hArgs (by env_reads) (by env_reads)
    (fun j => ⟨t0.sameOn.fits (Or.inl (hbR j).2.2.2) (hbR j).1,
      (t0.sameOn.readAt (Or.inl (hbR j).2.2.2)).trans (hbR j).2.1, (hbR j).2.2.1⟩)
    (by mem_fact) t2 (by mem_fact) (by mem_fact)
    ((t0'.sameOn.loadPtr (Or.inr (Or.inl rfl))).trans hlp17) (by mem_fact) (by simp) (by mem_fact)
    (by simp [Pointer.add, BitVec.uaddOverflow]) (by mem_fact)
    (by simp [Pointer.add, BitVec.uaddOverflow]) (by mem_fact)
    (by simp [Pointer.add, BitVec.uaddOverflow]) (by mem_fact)
    (by simp [Pointer.add, BitVec.uaddOverflow]) (by simp [GlobalState.slot, Pointer.add]) ?_
  -- what it stored, read back; the first iteration's through it
  intro E3 hA3 hD3 hR3
  clear hD'_0 hD'_1 hD'_2 hD'_3 hD'_4 hD'_5 hD'_6 hD'_7 hD'_8 hD'_9 hD'_10 hD'_11 hD'_12 hD'_13
    hD'_14 hD'_15 hD'_16 hD'_17 hD'_18 hD'_19 hD'_20 hD'_21 hD'_22 hD'_23 hD'_24 hD'_25 hD'_26
    hD'_27 hD'_28 hD'_29 hD'_30 hD'_31 hD'_32 hD'_33 hD'_34 hD'_35 hD'_36 hD'_37 hD'_38 hD'_39
    hD'_40 hD'_41 hD'_42 hD'_43 hD'_44 hD'_45 hD'_46 hD'_47 hD'_48 hD'_49 hD'_50 hD'_51 hD'_52
    hD'_53 hD'_54 hD'_55 hD'_56 hD'_57 hD'_58 hD'_59 hD'_60 hD'_61 hD'_62 hD'_63 hD'_64 hD'_65
    hD'_66 hD'_67 hD'_68 hD'_69 hD'_70 hD'_71 hD'_72 hD'_73 hD'_74 hD'_75 hD'_76 hD'_77 hD'_78
    hD'_79 hD'_80 hD'_81 hD'_82 hD'_83 hD'_84 hD'_85 hD'_86 hD'_87 hD'_88 hD'_89 hD'_90 hD'_91
    hD'_92 hD'_93 hD'_94 hD'_95 hD'_96 hD'_97 hD'_98 hD'_99 hD'_100 hD'_101 hD'_102 hD'_103 hD'_104
    hD'_105 hD'_106 hD'_107 hD'_108 hD'_109 hD'_110 hD'_111 hD'_112 hD'_113 hD'_114 hD'_115 hD'_116
    hD'_117 hD'_118 hD'_119 hD'_120 hD'_121 hD'_122 hD'_123 hD'_124 hD'_125 hD'_126 hD'_127 hD'_128
    hD'_129 hD'_130 hD'_131 hD'_132 hD'_133 hD'_134 hD'_135 hD'_136 hD'_137 hD'_138 hD'_139 hD'_140
    hD'_141 hD'_142 hD'_143 hD'_144 hD'_145 hD'_146 hD'_147 hD'_148 hD'_149 hD'_150 hD'_151 hD'_152
    hD'_153 hD'_154 hR'_0 hR'_1 hR'_2 hR'_3 hR'_4 hR'_5 hE hArgs
  have hArgs := hA3
  clear hA3
  split_reads hD3 hR3
  generalize hS3 : ({ S2 with mem := _ } : GlobalState) = S3
  replace hS3 := hS3.symm
  have hM3 := congrArg GlobalState.mem hS3
  dsimp only at hM3
  simp only [pointMem] at hS3
  have a1_18 : S3.mem.readFe ((c.s.slot 18).add 320#64) = (preR c).u := by
    rw [hM3]
    rd
    exact MemoryState.readFe_storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow], by rd_room⟩
  have f1_18 : Fits S3.mem ((c.s.slot 18).add 320#64) 2560 := by
    rw [hM3]
    iterate 3 apply Fits.storeFe
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow],
      by rd_room⟩).2
  have a1_19 : S3.mem.readFe ((c.s.slot 19).add 320#64) = (preR c).v := by
    rw [hM3]
    rd
    exact MemoryState.readFe_storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow], by rd_room⟩
  have f1_19 : Fits S3.mem ((c.s.slot 19).add 320#64) 2560 := by
    rw [hM3]
    iterate 2 apply Fits.storeFe
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow],
      by rd_room⟩).2
  have a1_20 : S3.mem.readFe ((c.s.slot 20).add 320#64) = (preR c).uv3 := by
    rw [hM3]
    rd
    exact MemoryState.readFe_storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow], by rd_room⟩
  have f1_20 : Fits S3.mem ((c.s.slot 20).add 320#64) 2560 := by
    rw [hM3]
    iterate 1 apply Fits.storeFe
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow],
      by rd_room⟩).2
  have a1_21 : S3.mem.readFe ((c.s.slot 21).add 320#64) = (preR c).uv7 := by
    rw [hM3]
    exact MemoryState.readFe_storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow], by rd_room⟩
  have f1_21 : Fits S3.mem ((c.s.slot 21).add 320#64) 2560 := by
    rw [hM3]
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow],
      by rd_room⟩).2
  have a1_y : S3.mem.readFe ((c.s.slot 29).add 320#64) = (preR c).y := by
    rw [hM3]
    rd
    exact pointMem_readFe_y (by simp) (by rd_room) _
  have f1_y : Fits S3.mem ((c.s.slot 29).add 320#64) 2560 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact pointMem_fits_y (by simp) (by rd_room) _
  have a1_z : S3.mem.readFe ((c.s.slot 29).add 640#64) = Fe.one := by
    rw [hM3]
    rd
    exact pointMem_readFe_z (by simp) (by rd_room) _
  have f1_z : Fits S3.mem ((c.s.slot 29).add 640#64) 2560 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact pointMem_fits_z1 (by simp) (by rd_room) _
  have a1_s : S3.mem.readAt (c.s.slot 25) 32 = signs (x8Buf c.cnt c.S c.R) := by
    rw [hM3]
    rd
    exact MemoryState.readAt_storeAt_self (by rd_room) _
  have f1_s : Fits S3.mem (c.s.slot 25) 32 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt_self (by rd_room))
  replace a0_18 : S3.mem.readFe (c.s.slot 18) = (preA c).u := by
    rw [hM3]
    rd
    exact a0_18
  replace f0_18 : Fits S3.mem (c.s.slot 18) 2560 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt f0_18)
  replace a0_19 : S3.mem.readFe (c.s.slot 19) = (preA c).v := by
    rw [hM3]
    rd
    exact a0_19
  replace f0_19 : Fits S3.mem (c.s.slot 19) 2560 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt f0_19)
  replace a0_20 : S3.mem.readFe (c.s.slot 20) = (preA c).uv3 := by
    rw [hM3]
    rd
    exact a0_20
  replace f0_20 : Fits S3.mem (c.s.slot 20) 2560 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt f0_20)
  replace a0_21 : S3.mem.readFe (c.s.slot 21) = (preA c).uv7 := by
    rw [hM3]
    rd
    exact a0_21
  replace f0_21 : Fits S3.mem (c.s.slot 21) 2560 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt f0_21)
  replace a0_y : S3.mem.readFe ((c.s.slot 28).add 320#64) = (preA c).y := by
    rw [hM3]
    rd
    exact a0_y
  replace f0_y : Fits S3.mem ((c.s.slot 28).add 320#64) 2560 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt f0_y)
  replace a0_z : S3.mem.readFe ((c.s.slot 28).add 640#64) = Fe.one := by
    rw [hM3]
    rd
    exact a0_z
  replace f0_z : Fits S3.mem ((c.s.slot 28).add 640#64) 2560 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt f0_z)
  replace a0_s : S3.mem.readAt (c.s.slot 24) 32 = signs (x8Buf c.cnt c.S c.A) := by
    rw [hM3]
    rd
    exact a0_s
  replace f0_s : Fits S3.mem (c.s.slot 24) 32 := by
    rw [hM3]
    iterate 4 apply Fits.storeFe
    exact Fits.pointMem (Fits.storeAt f0_s)
  have hwf3 : S3.WF := by mem_fact
  replace r28 : Room S3.mem (c.s.slot 28) 10240 := by mem_fact
  replace r29 : Room S3.mem (c.s.slot 29) 10240 := by mem_fact
  replace i16 : InBounds S3.mem (c.s.slot 16) 64 := by mem_fact
  replace i17 : InBounds S3.mem (c.s.slot 17) 64 := by mem_fact
  have t0s3 : S0.mem.FrameOn S3.mem (DKeep0 c) := by rw [hS3]; frame_on
  have t1 : S1.mem.FrameOn S3.mem (DKeep1 c) := by rw [hS3]; frame_on
  have hq23' : S3.mem.readFe (c.s.slot 23) = bcastBytes sqrtm1Bytes :=
    (t1.sameOn.readFe (Or.inr (Or.inr rfl))).trans hq23
  have hf23' : Fits S3.mem (c.s.slot 23) 2560 := t1.sameOn.fits (Or.inr (Or.inr rfl)) hf23.2
  finish_block
  block_init
  have hfa0 : S3.mem.FeFit (c.s.slot 21) := ⟨by simp, f0_21⟩
  have hfa1 : S3.mem.FeFit ((c.s.slot 21).add 320#64) :=
    ⟨by simp [Pointer.add, BitVec.uaddOverflow], f1_21⟩
  have hfr0 : S3.mem.FeRoom (c.s.slot 28) := ⟨by simp, by mem_fact⟩
  have hfr1 : S3.mem.FeRoom (c.s.slot 29) := ⟨by simp, by mem_fact⟩
  -- `^bb39`: the exponentiation, `sqrtm1` loaded
  refine bb39_run c E3 S3 (bcastBytes sqrtm1Bytes) hArgs (by env_reads) hwf3 hfa0 hfa1 hfr0 hfr1
    hq23' ⟨by simp, hf23'⟩ ?_
  -- the exponentiation's results; the first loop's through them
  intro E4 hA4 hD4 hR4
  clear hD3_0 hD3_1 hD3_2 hD3_3 hD3_4 hD3_5 hD3_6 hD3_7 hD3_8 hD3_9 hD3_10 hD3_11 hD3_12 hD3_13
    hD3_14 hD3_15 hD3_16 hD3_17 hD3_18 hD3_19 hD3_20 hD3_21 hD3_22 hD3_23 hD3_24 hD3_25 hD3_26
    hD3_27 hD3_28 hD3_29 hD3_30 hD3_31 hD3_32 hD3_33 hD3_34 hD3_35 hD3_36 hD3_37 hD3_38 hD3_39
    hD3_40 hD3_41 hD3_42 hD3_43 hD3_44 hD3_45 hD3_46 hD3_47 hD3_48 hD3_49 hD3_50 hD3_51 hD3_52
    hD3_53 hD3_54 hD3_55 hD3_56 hD3_57 hD3_58 hD3_59 hD3_60 hD3_61 hD3_62 hD3_63 hD3_64 hD3_65
    hD3_66 hD3_67 hD3_68 hD3_69 hD3_70 hD3_71 hD3_72 hD3_73 hD3_74 hD3_75 hD3_76 hD3_77 hD3_78
    hD3_79 hD3_80 hD3_81 hD3_82 hD3_83 hD3_84 hD3_85 hD3_86 hD3_87 hD3_88 hD3_89 hD3_90 hD3_91
    hD3_92 hD3_93 hD3_94 hD3_95 hD3_96 hD3_97 hD3_98 hD3_99 hD3_100 hD3_101 hD3_102 hD3_103 hD3_104
    hD3_105 hD3_106 hD3_107 hD3_108 hD3_109 hD3_110 hD3_111 hD3_112 hD3_113 hD3_114 hD3_115 hD3_116
    hD3_117 hD3_118 hD3_119 hD3_120 hD3_121 hD3_122 hD3_123 hD3_124 hD3_125 hD3_126 hD3_127 hD3_128
    hD3_129 hD3_130 hD3_131 hD3_132 hD3_133 hD3_134 hD3_135 hD3_136 hD3_137 hD3_138 hD3_139 hD3_140
    hD3_141 hD3_142 hD3_143 hD3_144 hD3_145 hD3_146 hD3_147 hD3_148 hD3_149 hD3_150 hD3_151 hD3_152
    hD3_153 hD3_154 hR3_0 hR3_1 hR3_2 hR3_3 hR3_4 hR3_5 hArgs
  have hArgs := hA4
  clear hA4
  split_reads hD4 hR4
  generalize hS4 : ({ S3 with mem := _ } : GlobalState) = S4
  replace hS4 := hS4.symm
  have hM4 := congrArg GlobalState.mem hS4
  dsimp only at hM4
  have hwf4 : S4.WF := by mem_fact
  have hx0 : S4.mem.readFe (c.s.slot 28) = pow22523 (preA c).uv7 := by
    rw [hM4]
    rd
    rw [MemoryState.readFe_storeFe_self ⟨by simp, by rd_room⟩, a0_21]
  have hx1 : S4.mem.readFe (c.s.slot 29) = pow22523 (preR c).uv7 := by
    rw [hM4, MemoryState.readFe_storeFe_self ⟨by simp, by rd_room⟩, a1_21]
  have fx0 : Fits S4.mem (c.s.slot 28) 2560 := by
    rw [hM4]
    exact Fits.storeFe (MemoryState.FeFit.storeFe_self ⟨by simp, by rd_room⟩).2
  have fx1 : Fits S4.mem (c.s.slot 29) 2560 := by
    rw [hM4]
    exact (MemoryState.FeFit.storeFe_self ⟨by simp, by rd_room⟩).2
  replace a0_18 : S4.mem.readFe (c.s.slot 18) = (preA c).u := by
    rw [hM4]
    rd
    exact a0_18
  replace f0_18 : Fits S4.mem (c.s.slot 18) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f0_18
  replace a0_19 : S4.mem.readFe (c.s.slot 19) = (preA c).v := by
    rw [hM4]
    rd
    exact a0_19
  replace f0_19 : Fits S4.mem (c.s.slot 19) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f0_19
  replace a0_20 : S4.mem.readFe (c.s.slot 20) = (preA c).uv3 := by
    rw [hM4]
    rd
    exact a0_20
  replace f0_20 : Fits S4.mem (c.s.slot 20) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f0_20
  replace a0_21 : S4.mem.readFe (c.s.slot 21) = (preA c).uv7 := by
    rw [hM4]
    rd
    exact a0_21
  replace f0_21 : Fits S4.mem (c.s.slot 21) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f0_21
  replace a0_y : S4.mem.readFe ((c.s.slot 28).add 320#64) = (preA c).y := by
    rw [hM4]
    rd
    exact a0_y
  replace f0_y : Fits S4.mem ((c.s.slot 28).add 320#64) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f0_y
  replace a0_z : S4.mem.readFe ((c.s.slot 28).add 640#64) = Fe.one := by
    rw [hM4]
    rd
    exact a0_z
  replace f0_z : Fits S4.mem ((c.s.slot 28).add 640#64) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f0_z
  replace a0_s : S4.mem.readAt (c.s.slot 24) 32 = signs (x8Buf c.cnt c.S c.A) := by
    rw [hM4]
    rd
    exact a0_s
  replace f0_s : Fits S4.mem (c.s.slot 24) 32 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f0_s
  replace a1_18 : S4.mem.readFe ((c.s.slot 18).add 320#64) = (preR c).u := by
    rw [hM4]
    rd
    exact a1_18
  replace f1_18 : Fits S4.mem ((c.s.slot 18).add 320#64) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f1_18
  replace a1_19 : S4.mem.readFe ((c.s.slot 19).add 320#64) = (preR c).v := by
    rw [hM4]
    rd
    exact a1_19
  replace f1_19 : Fits S4.mem ((c.s.slot 19).add 320#64) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f1_19
  replace a1_20 : S4.mem.readFe ((c.s.slot 20).add 320#64) = (preR c).uv3 := by
    rw [hM4]
    rd
    exact a1_20
  replace f1_20 : Fits S4.mem ((c.s.slot 20).add 320#64) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f1_20
  replace a1_21 : S4.mem.readFe ((c.s.slot 21).add 320#64) = (preR c).uv7 := by
    rw [hM4]
    rd
    exact a1_21
  replace f1_21 : Fits S4.mem ((c.s.slot 21).add 320#64) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f1_21
  replace a1_y : S4.mem.readFe ((c.s.slot 29).add 320#64) = (preR c).y := by
    rw [hM4]
    rd
    exact a1_y
  replace f1_y : Fits S4.mem ((c.s.slot 29).add 320#64) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f1_y
  replace a1_z : S4.mem.readFe ((c.s.slot 29).add 640#64) = Fe.one := by
    rw [hM4]
    rd
    exact a1_z
  replace f1_z : Fits S4.mem ((c.s.slot 29).add 640#64) 2560 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f1_z
  replace a1_s : S4.mem.readAt (c.s.slot 25) 32 = signs (x8Buf c.cnt c.S c.R) := by
    rw [hM4]
    rd
    exact a1_s
  replace f1_s : Fits S4.mem (c.s.slot 25) 32 := by
    rw [hM4]
    repeat (first | apply Fits.storeFe | apply Fits.xyMem)
    exact f1_s
  replace r28 : Room S4.mem (c.s.slot 28) 10240 := by mem_fact
  replace r29 : Room S4.mem (c.s.slot 29) 10240 := by mem_fact
  replace i16 : InBounds S4.mem (c.s.slot 16) 64 := by mem_fact
  replace i17 : InBounds S4.mem (c.s.slot 17) 64 := by mem_fact
  have t0s4 : S0.mem.FrameOn S4.mem (DKeep0 c) := by rw [hS4]; frame_on
  have t1s4 : S1.mem.FrameOn S4.mem (DKeep1 c) := by rw [hS4]; frame_on
  finish_block
  block_init
  -- `^bb41`, `n = 0`: `a`
  refine bb41_run c 1#1 0#32 (signs (x8Buf c.cnt c.S c.A)) (c.s.slot 24) (c.s.slot 16)
    (c.s.slot 28) (c.s.slot 18) (c.s.slot 19) (c.s.slot 20) (pow22523 (preA c).uv7)
    (bcastBytes sqrtm1Bytes) (preA c) S4 E (g := g) ?qG hArgs (by env_reads) (by env_reads) i16
    ((t1s4.sameOn.loadPtr (Or.inl rfl)).trans hlp16) r28 (by simp) fx0 hx0 f0_y a0_y f0_18 a0_18
    (by simp) f0_19 a0_19 (by simp) f0_20 a0_20 (by simp) f0_s a0_s (by simp [GlobalState.slot]) ?_
  case qG =>
    funext x
    simp only
  -- `a` read back; `r`'s inputs through its stores
  intro E5 hA5 hD5 hR5
  clear hD4_0 hD4_1 hD4_2 hD4_3 hD4_4 hD4_5 hD4_6 hD4_7 hD4_8 hD4_9 hD4_10 hD4_11 hD4_12 hD4_13
    hD4_14 hD4_15 hD4_16 hD4_17 hD4_18 hD4_19 hD4_20 hD4_21 hD4_22 hD4_23 hD4_24 hD4_25 hD4_26
    hD4_27 hD4_28 hD4_29 hD4_30 hD4_31 hD4_32 hD4_33 hD4_34 hD4_35 hD4_36 hD4_37 hD4_38 hD4_39
    hD4_40 hD4_41 hD4_42 hD4_43 hD4_44 hD4_45 hD4_46 hD4_47 hD4_48 hD4_49 hD4_50 hD4_51 hD4_52
    hD4_53 hD4_54 hD4_55 hD4_56 hD4_57 hD4_58 hD4_59 hD4_60 hD4_61 hD4_62 hD4_63 hD4_64 hD4_65
    hD4_66 hD4_67 hD4_68 hD4_69 hD4_70 hD4_71 hD4_72 hD4_73 hD4_74 hD4_75 hD4_76 hD4_77 hD4_78
    hD4_79 hD4_80 hD4_81 hD4_82 hD4_83 hD4_84 hD4_85 hD4_86 hD4_87 hD4_88 hD4_89 hD4_90 hD4_91
    hD4_92 hD4_93 hD4_94 hD4_95 hD4_96 hD4_97 hD4_98 hD4_99 hD4_100 hD4_101 hD4_102 hD4_103 hD4_104
    hD4_105 hD4_106 hD4_107 hD4_108 hD4_109 hD4_110 hD4_111 hD4_112 hD4_113 hD4_114 hD4_115 hD4_116
    hD4_117 hD4_118 hD4_119 hD4_120 hD4_121 hD4_122 hD4_123 hD4_124 hD4_125 hD4_126 hD4_127 hD4_128
    hD4_129 hD4_130 hD4_131 hD4_132 hD4_133 hD4_134 hD4_135 hD4_136 hD4_137 hD4_138 hD4_139 hD4_140
    hD4_141 hD4_142 hD4_143 hD4_144 hD4_145 hD4_146 hD4_147 hD4_148 hD4_149 hD4_150 hD4_151 hD4_152
    hD4_153 hD4_154 hR4_0 hR4_1 hR4_2 hR4_3 hR4_4 hArgs
  have hArgs := hA5
  clear hA5
  split_reads hD5 hR5
  generalize hS5 : ({ S4 with mem := _ } : GlobalState) = S5
  replace hS5 := hS5.symm
  have hM5 := congrArg GlobalState.mem hS5
  dsimp only at hM5
  simp only [xyMem] at hS5
  have hwf5 : S5.WF := by mem_fact
  have px0 : S5.mem.readFe (c.s.slot 28) = (finA c).1.x := by
    rw [hM5, rf_apart_base (by simp) (by simp), xyMem_readFe_x (by simp) (by rd_room)]
  have py0 : S5.mem.readFe ((c.s.slot 28).add 320#64) = (finA c).1.y := by
    rw [hM5, rf_apart (by simp) (by simp) (by simp), xyMem_readFe_y (by simp) (by rd_room)]
  have pz0 : S5.mem.readFe ((c.s.slot 28).add 640#64) = Fe.one := by
    rw [hM5, rf_apart (by simp) (by simp) (by simp), xyMem_readFe_z (by simp),
      rf_base_apart (by simp) (by simp)]
    exact a0_z
  have pt0 : S5.mem.readFe ((c.s.slot 28).add 960#64) = (finA c).1.t := by
    rw [hM5, MemoryState.readFe_storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow],
      by rd_room⟩]
  have qx0 : Fits S5.mem (c.s.slot 28) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (MemoryState.FeFit.storeFe_self ⟨by simp, by rd_room⟩).2)
  have qy0 : Fits S5.mem ((c.s.slot 28).add 320#64) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f0_y))
  have qz0 : Fits S5.mem ((c.s.slot 28).add 640#64) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f0_z))
  have qt0 : Fits S5.mem ((c.s.slot 28).add 960#64) 2560 := by
    rw [hM5]
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow],
      by rd_room⟩).2
  replace a1_18 : S5.mem.readFe ((c.s.slot 18).add 320#64) = (preR c).u := by
    rw [hM5]
    rd
    exact a1_18
  replace f1_18 : Fits S5.mem ((c.s.slot 18).add 320#64) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_18))
  replace a1_19 : S5.mem.readFe ((c.s.slot 19).add 320#64) = (preR c).v := by
    rw [hM5]
    rd
    exact a1_19
  replace f1_19 : Fits S5.mem ((c.s.slot 19).add 320#64) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_19))
  replace a1_20 : S5.mem.readFe ((c.s.slot 20).add 320#64) = (preR c).uv3 := by
    rw [hM5]
    rd
    exact a1_20
  replace f1_20 : Fits S5.mem ((c.s.slot 20).add 320#64) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_20))
  replace a1_21 : S5.mem.readFe ((c.s.slot 21).add 320#64) = (preR c).uv7 := by
    rw [hM5]
    rd
    exact a1_21
  replace f1_21 : Fits S5.mem ((c.s.slot 21).add 320#64) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_21))
  replace a1_y : S5.mem.readFe ((c.s.slot 29).add 320#64) = (preR c).y := by
    rw [hM5]
    rd
    exact a1_y
  replace f1_y : Fits S5.mem ((c.s.slot 29).add 320#64) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_y))
  replace a1_z : S5.mem.readFe ((c.s.slot 29).add 640#64) = Fe.one := by
    rw [hM5]
    rd
    exact a1_z
  replace f1_z : Fits S5.mem ((c.s.slot 29).add 640#64) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_z))
  replace a1_s : S5.mem.readAt (c.s.slot 25) 32 = signs (x8Buf c.cnt c.S c.R) := by
    rw [hM5]
    rd
    exact a1_s
  replace f1_s : Fits S5.mem (c.s.slot 25) 32 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_s))
  replace hx1 : S5.mem.readFe (c.s.slot 29) = pow22523 (preR c).uv7 := by
    rw [hM5]
    rd
    exact hx1
  replace fx1 : Fits S5.mem (c.s.slot 29) 2560 := by
    rw [hM5]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe fx1))
  replace r29 : Room S5.mem (c.s.slot 29) 10240 := by mem_fact
  replace i17 : InBounds S5.mem (c.s.slot 17) 64 := by mem_fact
  have t0s5 : S0.mem.FrameOn S5.mem (DKeep0 c) := by rw [hS5]; frame_on
  have t1s5 : S1.mem.FrameOn S5.mem (DKeep1 c) := by rw [hS5]; frame_on
  finish_block
  block_init
  -- `^bb41`, `n = 1`: `r`
  refine bb41_run c 0#1 (finA c).2
    (signs (x8Buf c.cnt c.S c.R)) (c.s.slot 25) (c.s.slot 17) (c.s.slot 29)
    ((c.s.slot 18).add 320#64) ((c.s.slot 19).add 320#64) ((c.s.slot 20).add 320#64)
    (pow22523 (preR c).uv7) (bcastBytes sqrtm1Bytes) (preR c) S5 E (g := g) ?qG hArgs (by env_reads)
    (by env_reads) i17 ((t1s5.sameOn.loadPtr (Or.inr (Or.inl rfl))).trans hlp17) r29 (by simp) fx1
    hx1 f1_y a1_y f1_18 a1_18 (by simp [Pointer.add, BitVec.uaddOverflow]) f1_19 a1_19
    (by simp [Pointer.add, BitVec.uaddOverflow]) f1_20 a1_20
    (by simp [Pointer.add, BitVec.uaddOverflow]) f1_s a1_s (by simp [GlobalState.slot, Pointer.add])
    ?_
  case qG =>
    funext x
    simp only
  -- `r` read back; `a` through its stores; on to `^bb42`
  intro E6 hA6 hD6 hR6
  clear hD5_0 hD5_1 hD5_2 hD5_3 hD5_4 hD5_5 hD5_6 hD5_7 hD5_8 hD5_9 hD5_10 hD5_11 hD5_12 hD5_13
    hD5_14 hD5_15 hD5_16 hD5_17 hD5_18 hD5_19 hD5_20 hD5_21 hD5_22 hD5_23 hD5_24 hD5_25 hD5_26
    hD5_27 hD5_28 hD5_29 hD5_30 hD5_31 hD5_32 hD5_33 hD5_34 hD5_35 hD5_36 hD5_37 hD5_38 hD5_39
    hD5_40 hD5_41 hD5_42 hD5_43 hD5_44 hD5_45 hD5_46 hD5_47 hD5_48 hD5_49 hD5_50 hD5_51 hD5_52
    hD5_53 hD5_54 hD5_55 hD5_56 hD5_57 hD5_58 hD5_59 hD5_60 hD5_61 hD5_62 hD5_63 hD5_64 hD5_65
    hD5_66 hD5_67 hD5_68 hD5_69 hD5_70 hD5_71 hD5_72 hD5_73 hD5_74 hD5_75 hD5_76 hD5_77 hD5_78
    hD5_79 hD5_80 hD5_81 hD5_82 hD5_83 hD5_84 hD5_85 hD5_86 hD5_87 hD5_88 hD5_89 hD5_90 hD5_91
    hD5_92 hD5_93 hD5_94 hD5_95 hD5_96 hD5_97 hD5_98 hD5_99 hD5_100 hD5_101 hD5_102 hD5_103 hD5_104
    hD5_105 hD5_106 hD5_107 hD5_108 hD5_109 hD5_110 hD5_111 hD5_112 hD5_113 hD5_114 hD5_115 hD5_116
    hD5_117 hD5_118 hD5_119 hD5_120 hD5_121 hD5_122 hD5_123 hD5_124 hD5_125 hD5_126 hD5_127 hD5_128
    hD5_129 hD5_130 hD5_131 hD5_132 hD5_133 hD5_134 hD5_135 hD5_136 hD5_137 hD5_138 hD5_139 hD5_140
    hD5_141 hD5_142 hD5_143 hD5_144 hD5_145 hD5_146 hD5_147 hD5_148 hD5_149 hD5_150 hD5_151 hD5_152
    hD5_153 hD5_154 hR5_0 hR5_1 hR5_2 hR5_3 hR5_4 hR5_5 hR5_6 hR5_7 hArgs
  have hArgs := hA6
  clear hA6
  split_reads hD6 hR6
  generalize hS6 : ({ S5 with mem := _ } : GlobalState) = S6
  replace hS6 := hS6.symm
  have hM6 := congrArg GlobalState.mem hS6
  dsimp only at hM6
  simp only [xyMem] at hS6
  have hwf6 : S6.WF := by mem_fact
  have px1 : S6.mem.readFe (c.s.slot 29) = (finR c).1.x := by
    rw [hM6, rf_apart_base (by simp) (by simp), xyMem_readFe_x (by simp) (by rd_room)]
  have py1 : S6.mem.readFe ((c.s.slot 29).add 320#64) = (finR c).1.y := by
    rw [hM6, rf_apart (by simp) (by simp) (by simp), xyMem_readFe_y (by simp) (by rd_room)]
  have pz1 : S6.mem.readFe ((c.s.slot 29).add 640#64) = Fe.one := by
    rw [hM6, rf_apart (by simp) (by simp) (by simp), xyMem_readFe_z (by simp),
      rf_base_apart (by simp) (by simp)]
    exact a1_z
  have pt1 : S6.mem.readFe ((c.s.slot 29).add 960#64) = (finR c).1.t := by
    rw [hM6, MemoryState.readFe_storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow],
      by rd_room⟩]
  have qx1 : Fits S6.mem (c.s.slot 29) 2560 := by
    rw [hM6]
    exact Fits.storeFe (Fits.xyMem (MemoryState.FeFit.storeFe_self ⟨by simp, by rd_room⟩).2)
  have qy1 : Fits S6.mem ((c.s.slot 29).add 320#64) 2560 := by
    rw [hM6]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_y))
  have qz1 : Fits S6.mem ((c.s.slot 29).add 640#64) 2560 := by
    rw [hM6]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe f1_z))
  have qt1 : Fits S6.mem ((c.s.slot 29).add 960#64) 2560 := by
    rw [hM6]
    exact (MemoryState.FeFit.storeFe_self ⟨by simp [Pointer.add, BitVec.uaddOverflow],
      by rd_room⟩).2
  replace px0 : S6.mem.readFe (c.s.slot 28) = (finA c).1.x := by
    rw [hM6]
    rd
    exact px0
  replace qx0 : Fits S6.mem (c.s.slot 28) 2560 := by
    rw [hM6]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe qx0))
  replace py0 : S6.mem.readFe ((c.s.slot 28).add 320#64) = (finA c).1.y := by
    rw [hM6]
    rd
    exact py0
  replace qy0 : Fits S6.mem ((c.s.slot 28).add 320#64) 2560 := by
    rw [hM6]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe qy0))
  replace pz0 : S6.mem.readFe ((c.s.slot 28).add 640#64) = Fe.one := by
    rw [hM6]
    rd
    exact pz0
  replace qz0 : Fits S6.mem ((c.s.slot 28).add 640#64) 2560 := by
    rw [hM6]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe qz0))
  replace pt0 : S6.mem.readFe ((c.s.slot 28).add 960#64) = (finA c).1.t := by
    rw [hM6]
    rd
    exact pt0
  replace qt0 : Fits S6.mem ((c.s.slot 28).add 960#64) 2560 := by
    rw [hM6]
    exact Fits.storeFe (Fits.xyMem (Fits.storeFe qt0))
  have t0s6 : S0.mem.FrameOn S6.mem (DKeep0 c) := by rw [hS6]; frame_on
  finish_block
  refine h42 _ S6 hArgs ?_ ⟨Call.Base.of_frameOn_d hb t0s6 hwf6, Call.KS.of_frameOn_d hks t0s6,
    ⟨⟨by simp, fits_point_of_fe (by simp) qx0 qy0 qz0 qt0⟩, ?_⟩,
    ⟨⟨by simp, fits_point_of_fe (by simp) qx1 qy1 qz1 qt1⟩, ?_⟩⟩
  · env_reads
  · simp only [MemoryState.readLanePoint, px0, py0, pz0, pt0]
    rfl
  · simp only [MemoryState.readLanePoint, px1, py1, pz1, pt1]
    rfl

end MLIR.Firedancer.Lane.VerifyX8
