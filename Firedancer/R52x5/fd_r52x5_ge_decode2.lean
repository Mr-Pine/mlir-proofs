module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Decode2.Spec
public import Firedancer.R52x5.Decode2.Frame
public import Firedancer.R52x5.Decode2.Fields
public import Firedancer.R52x5.Decode2.Head
public import Firedancer.R52x5.Decode2.Loop
public import Firedancer.R52x5.Decode2.Mid
public import Firedancer.R52x5.Decode2.Tail
public import Firedancer.R52x5.Decode2.Out
import Firedancer.R52x5.Decode2.Tactics

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl wwl)

/-! ## Specification -/

@[expose] public section

/-- The memory `fd_r52x5_ge_decode2` leaves: `Pa0 … Pa4` the first point, if any, then
`Pb0 … Pb4` the second (the neutral point on a failure). -/
def fd_r52x5_ge_decode2.storeOut (m : MemoryState)
    (Pa0 Pa1 Pa2 Pa3 Pa4 Pb0 Pb1 Pb2 Pb3 Pb4 : Pointer) (R : BitVec 32 × Option Quad5 × Quad5) :
    MemoryState :=
  let m :=
    match R.2.1 with
    | none => m
    | some P => m.storeTmp5 Pa0 Pa1 Pa2 Pa3 Pa4 P
  m.storeTmp5 Pb0 Pb1 Pb2 Pb3 Pb4 R.2.2

/-- The blocks `fd_r52x5_ge_decode2` allocates: its `201` slots, `fd_f25519_is_nonzero`'s and, on
success, `fd_f25519_sgn`'s. -/
def fd_r52x5_ge_decode2.blocks (r : BitVec 32) : Nat :=
  if r = 0 then 213 else 209

end

/-! ## Proof -/

section Proof

attribute [local mlir_env 1100] fd_r52x5_ge_decode2.read_write_same

open fd_r52x5_ge_decode2 in
-- the composition of the blocks' lemmas: each `chain_reads` searches the chain of envs back to
-- the entry
set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_ge_decode2` on the encodings at `sa` and `sb` returns `spec`'s value, stores its
points at `Pa0 … Pa4` (when both decode) and `Pb0 … Pb4`, and counts `blocks` frames. -/
public theorem fd_r52x5_ge_decode2.call_eq (Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb : Pointer)
    (s : GlobalState) (hwf : s.WF) (hg : s.mem.Globals fd_r52x5_ge_decode2.globals)
    (hO :
      Room s.mem Pa0 256 ∧
        Room s.mem Pa1 256 ∧
        Room s.mem Pa2 256 ∧
        Room s.mem Pa3 256 ∧
        Room s.mem Pa4 256 ∧
        Room s.mem Pb0 256 ∧
        Room s.mem Pb1 256 ∧ Room s.mem Pb2 256 ∧ Room s.mem Pb3 256 ∧ Room s.mem Pb4 256)
    (hsa : Fits s.mem sa 256) (hsb : Fits s.mem sb 256) (hsa_off : ¬sa.offset.uaddOverflow 32#64)
    (hsb_off : ¬sb.offset.uaddOverflow 32#64) :
    fd_r52x5_ge_decode2.call (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb) s =
      let R := fd_r52x5_ge_decode2.spec (s.mem.readAt sa 256) (s.mem.readAt sb 256)
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + blocks R.1⟩,
            mem := storeOut s.mem Pa0 Pa1 Pa2 Pa3 Pa4 Pb0 Pb1 Pb2 Pb3 Pb4 R }) := by
  generalize hR : fd_r52x5_ge_decode2.spec (s.mem.readAt sa 256) (s.mem.readAt sb 256) = R
  obtain ⟨ha0, ha1, ha2, ha3, ha4, hb0, hb1, hb2, hb3, hb4⟩ := hO
  func_init
  block_init
  step_pure
  step_addressof fd_f25519_sqrtm1.value_eq with gsq
  iterate 14 step_pure
  step_addressof fd_f25519_one.value_eq with gone
  step_addressof fd_f25519_d.value_eq with gd
  iterate 28 step_pure
  have hvsq := fd_f25519_sqrtm1.readVec hread_gsq
  have hvone := fd_f25519_one.readVec hread_gone
  have hvd := fd_f25519_d.readVec hread_gd
  -- the frame's slots `B.slot 3 …`: `B`'s counter three below the entry's, which the globals'
  -- three blocks, distinct and not null's, are below
  have hlt3 : 3 ≤ S₀.alloc.nextFreeBlock := by
    have hpt (p q : Pointer) (hp : p.offset = 0) (hq : q.offset = 0) (h : p.id = q.id) : p = q := by
      cases p; cases q; simp_all
    have h01 : gsq.id ≠ gone.id := fun h => by
      have := hvsq; rw [hpt _ _ hgsq_off hgone_off h, hvone] at this; exact absurd this (by decide)
    have h02 : gsq.id ≠ gd.id := fun h => by
      have := hvsq; rw [hpt _ _ hgsq_off hgd_off h, hvd] at this; exact absurd this (by decide)
    have h12 : gone.id ≠ gd.id := fun h => by
      have := hvone; rw [hpt _ _ hgone_off hgd_off h, hvd] at this; exact absurd this (by decide)
    have hb (x y : BlockId) (h : x ≠ y) : x.id ≠ y.id := fun e =>
      h
        (by
          cases x; cases y; simp_all)
    have n0 := hb _ _ (hwf.ne_null_of_inBounds hgsq_live.inBounds)
    have n1 := hb _ _ (hwf.ne_null_of_inBounds hgone_live.inBounds)
    have n2 := hb _ _ (hwf.ne_null_of_inBounds hgd_live.inBounds)
    have l0 := hwf.global_lt hglobal_gsq
    have l1 := hwf.global_lt hglobal_gone
    have l2 := hwf.global_lt hglobal_gd
    rw [hS] at l0 l1 l2
    have := hb _ _ h01
    have := hb _ _ h02
    have := hb _ _ h12
    simp only [Pointer.null] at n0 n1 n2
    omega
  obtain ⟨B, hB⟩ : ∃ B : GlobalState, B.alloc.nextFreeBlock + 3 = S₀.alloc.nextFreeBlock :=
    ⟨⟨⟨S₀.alloc.nextFreeBlock - 3⟩, S₀.mem⟩, by
      simp only; omega⟩
  have hS3 : S.alloc.nextFreeBlock = B.alloc.nextFreeBlock + 3 := by rw [hS, hB]
  have hsA : S.mem.readAt sa 256 = S₀.mem.readAt sa 256 := by rw [hS]
  have hsB : S.mem.readAt sb 256 = S₀.mem.readAt sb 256 := by rw [hS]
  rw [hsA, hsB] at hR
  have hM0 : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by rw [hS, hwf₀.eraseFrom]
  have hG : Globals B gsq gone gd S.mem :=
    ⟨hS3 ▸ hwf.global_lt hglobal_gsq, hS3 ▸ hwf.global_lt hglobal_gone,
      hS3 ▸ hwf.global_lt hglobal_gd, hgsq_fits, hgone_fits, hgd_fits, hvsq, hvone, hvd⟩
  have hI :
    Inv B S.mem 0 { allocas S slotSizes with mem := startFields (allocas S slotSizes).mem B } :=
    ⟨WF_startFields (WF_allocas _ _ hwf), frame_allocas hwf hS3, by
      rw [eraseFrom_startFields, eraseFrom_allocas _ _ (by omega), ← hS3, hwf.eraseFrom], by
      rw [alloc_allocas, hS3, show slotSizes.length = 201 by simp [slotSizes]]⟩
  rw [bb0_allocas hS3]
  obtain ⟨Eent, hEnt⟩ : ∃ X, X = writeSlots E B 3 slotDsts := ⟨_, rfl⟩
  rw [← hEnt]
  have hArgsE : Eent.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get := by
    rw [hEnt, writeSlots_args]
    exact hArgs
  replace hEnt : Eent = entryEnv E₀ B gsq gone gd :=
    hEnt.trans
      (by
        subst hE; exact rir_rfl%)
  have hsa_lt : sa.id.id < B.alloc.nextFreeBlock + 3 := hB ▸ hwf₀.lt hsa₀.mem
  have hsb_lt : sb.id.id < B.alloc.nextFreeBlock + 3 := hB ▸ hwf₀.lt hsb₀.mem
  -- the field elements' lifetimes start
  refine starts_run (B := B) (by chain_reads) ?_
  refine
    fields_run (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256) hArgsE (by chain_reads) hI hG
      (fits_startFields_of (fits_allocas_of slotSizes S hwf hsa) (by omega))
      (fits_startFields_of (fits_allocas_of slotSizes S hwf hsb) (by omega))
      ((hI.readAt (by omega)).trans hsA) ((hI.readAt (by omega)).trans hsB) hsa_off hsb_off hsa_lt
      hsb_lt fun E1 S1 hA1 hW1 hR1 hI1 hF1 hy hu hv huv3 hyb hub hvb huv3b => ?_
  -- `FD_R52X5_POW22523_QUAD( _Qx, _Quv )`: `^bb0`'s part, the loop of `20`
  refine head0_run _ hA1 (by chain_reads) hI1 fun Eh0 Sh0 hAh0 hWh0 hRh0 hIh0 hKh0 => ?_
  refine head1_run _ _ _ hAh0 (by chain_reads) hIh0 fun Eh1 Sh1 hAh1 hWh1 hRh1 hIh1 hKh1 => ?_
  refine head2_run _ _ hAh1 (by chain_reads) hIh1 fun Eh2 Sh2 hAh2 hWh2 hRh2 hIh2 hKh2 => ?_
  refine head3_run _ hAh2 (by chain_reads) hIh2 fun Eh3 Sh3 hAh3 hWh3 hRh3 hIh3 hKh3 => ?_
  refine head4_run _ _ hAh3 (by chain_reads) hIh3 fun Eh4 Sh4 hAh4 hWh4 hRh4 hIh4 hKh4 => ?_
  refine head5_run _ hAh4 (by chain_reads) hIh4 fun Eh5 Sh5 hAh5 hWh5 hRh5 hIh5 hKh5 => ?_
  refine head6_run _ hAh5 (by chain_reads) hIh5 fun Eh6 Sh6 hAh6 hWh6 hRh6 hIh6 hKh6 => ?_
  refine head7_run _ _ hAh6 (by chain_reads) hIh6 fun Eh7 Sh7 hAh7 hWh7 hRh7 hIh7 hKh7 => ?_
  refine head8_run _ hAh7 (by chain_reads) hIh7 fun Eh8 Sh8 hAh8 hWh8 hRh8 hIh8 hKh8 => ?_
  have h1560 : Eh8.read (rir_reg% hty 13) = .value 1#32 := by chain_reads
  -- `finish_block` by hand: `bb0.body.drop 1129` is too deep to reduce
  rw [BasicBlock.runBodyFrom_done (by decide +kernel)]
  simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, Exit.run]
  dsimp only [Jump.run, Fin.isValue, Regs.read_nil, EffectM.pure_eq, PoisonOr.value_bind,
    Regs.read_cons, reduceWriteManyDsts, Env.writeMany_nil, Env.writeMany_cons]
  rw [Func.continue_next]
  simp only [hRh8, h1560]
  refine
    loop2 B S.mem 0 _ _ 18 1 Sh8 Eh8 _ rfl hIh8
      (by
        unfold pre2; chain_reads)
      fun El2 Sl2 hWl2 hOl2 hIl2 hKl2 => ?_
  refine
    bb1_run _ _ _ (hWl2.1.trans hAh8) (by chain_reads) hIl2 fun Eb1 Sb1 hAb1 hWb1 hRb1 hIb1 hKb1 =>
      ?_
  refine
    loop4 B S.mem 0 _ _ 48 1 Sb1 Eb1 _ rfl hIb1
      (by
        unfold pre4; chain_reads)
      fun El4 Sl4 hWl4 hOl4 hIl4 hKl4 => ?_
  refine
    bb3_run _ _ (hWl4.1.trans hAb1) (by chain_reads) hIl4 fun Eb3 Sb3 hAb3 hWb3 hRb3 hIb3 hKb3 => ?_
  refine
    loop6 B S.mem 0 _ _ 98 1 Sb3 Eb3 _ rfl hIb3
      (by
        unfold pre6; chain_reads)
      fun El6 Sl6 hWl6 hOl6 hIl6 hKl6 => ?_
  refine bb5_run _ _ (hWl6.1.trans hAb3) (by chain_reads) hIl6 fun Eb5 Sb5 hAb5 hWb5 hIb5 hKb5 => ?_
  refine
    loop8 B S.mem 0 _ _ 48 1 Sb5 Eb5 _ rfl hIb5
      (by
        unfold pre8; chain_reads)
      fun El8 Sl8 hWl8 hOl8 hIl8 hKl8 => ?_
  -- the field elements `^bb0` stored, kept through the chain's temporaries
  have hk :=
    hKh0.trans hKh1 |>.trans hKh2 |>.trans hKh3 |>.trans hKh4 |>.trans hKh5 |>.trans hKh6 |>.trans
                      hKh7 |>.trans
                    hKh8 |>.trans
                  hKl2 |>.trans
                hKb1 |>.trans
              hKl4 |>.trans
            hKb3 |>.trans
          hKl6 |>.trans
        hKb5 |>.trans
      hKl8
  refine
    bb7_run _ _ _ (pre (S₀.mem.readAt sa 256)) (pre (S₀.mem.readAt sb 256)) _ _ (hWl8.1.trans hAb5)
      (by chain_reads) hIl8 ((hk 4 (by decide) (by decide)).1.trans hu)
      ((hk 5 (by decide) (by decide)).1.trans hv) ((hk 10 (by decide) (by decide)).1.trans huv3)
      ((hk 13 (by decide) (by decide)).1.trans hub) ((hk 14 (by decide) (by decide)).1.trans hvb)
      ((hk 19 (by decide) (by decide)).1.trans huv3b) ((hk 3 (by decide) (by decide)).1.trans hy)
      ((hk 12 (by decide) (by decide)).1.trans hyb)
      (fun j h3 hj => (hk j h3 (by omega)).2 (hF1 j h3 hj)) ?_ ?_
  · intro E10 S10 hA10 hW10 Qx DA DB hR10 hI10 hy10 hyb10 hx10 hxb10 hf3 hf12 hf21 hf29 hok
    refine bb10_run DB.t1nz DB.t2nz (by chain_reads) ?_ ?_
    · intro E12 hA12 hW12 hokb
      refine
        bb12_run DA DB (hA12.trans hA10) (by chain_reads) (is_nonzero_01 _) (is_nonzero_01 _) hI10
          hG ⟨ha0, ha1, ha2, ha3, ha4, hb0, hb1, hb2, hb3, hb4⟩ hy10 hyb10 hx10 hxb10 hf3 hf12 hf21
          hf29
          (by
            dsimp only [EndRegs]; chain_reads)
          ⟨by
            have := hwf₀.lt ha0₀.mem; omega, by
            have := hwf₀.lt ha1₀.mem; omega, by
            have := hwf₀.lt ha2₀.mem; omega, by
            have := hwf₀.lt ha3₀.mem; omega, by
            have := hwf₀.lt ha4₀.mem; omega, by
            have := hwf₀.lt hb0₀.mem; omega, by
            have := hwf₀.lt hb1₀.mem; omega, by
            have := hwf₀.lt hb2₀.mem; omega, by
            have := hwf₀.lt hb3₀.mem; omega, by
            have := hwf₀.lt hb4₀.mem; omega⟩
          fun S12 halloc herase => ?_
      have halloc10 := hI10.alloc
      have hokA :
        (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).1.t2nz &&&
            (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).1.t1nz =
          0 :=
        hok
      have hokB :
        (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).2.t2nz &&&
            (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).2.t1nz =
          0 :=
        hokb
      subst hR
      have hspec :
        fd_r52x5_ge_decode2.spec (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256) =
          (0, some (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).1.point,
            (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).2.point) := by
        simp only [fd_r52x5_ge_decode2.spec, Dec.err, hokA, hokB, bne_self_eq_false,
          Bool.false_eq_true, ↓reduceIte]
      rw [hspec]
      simp only [storeOut, blocks, ↓reduceIte]
      rw [← eraseFrom_eraseFrom (show S₀.alloc.nextFreeBlock ≤ B.alloc.nextFreeBlock + 3 by omega),
        herase, MemoryState.eraseFrom_storeTmp5, MemoryState.eraseFrom_storeTmp5, hM0]
      obtain ⟨⟨n⟩, m12⟩ := S12
      simp only at halloc ⊢
      rw [halloc, halloc10, ← hB]
      rfl
    · intro E11 hA11 hW11 hnb
      rw [bb11_run (B := B) (hA11.trans hA10) (by chain_reads) (hI10.room hb0) (hI10.room hb1)
          (hI10.room hb2) (hI10.room hb3) (hI10.room hb4)
          (by
            dsimp only [EndRegs]; chain_reads)]
      have halloc10 := hI10.alloc
      have herase := hI10.erase
      have hokA :
        (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).1.t2nz &&&
            (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).1.t1nz =
          0 :=
        hok
      have hnB :
        (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).2.t2nz &&&
            (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).2.t1nz ≠
          0 :=
        hnb
      subst hR
      have hspec :
        fd_r52x5_ge_decode2.spec (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256) =
          (-2, none, quadZero) := by
        simp only [fd_r52x5_ge_decode2.spec, Dec.err, hokA, hnB, bne_self_eq_false, bne_iff_ne,
          ne_eq, not_false_eq_true, Bool.false_eq_true, ↓reduceIte]
      rw [hspec]
      simp only [storeOut, blocks, show (-2 : BitVec 32) ≠ 0 by decide, ↓reduceIte]
      rw [← eraseFrom_eraseFrom (show S₀.alloc.nextFreeBlock ≤ B.alloc.nextFreeBlock + 3 by omega),
        eraseFrom_endFields, MemoryState.eraseFrom_storeTmp5, herase,
        MemoryState.eraseFrom_storeTmp5, hM0]
      obtain ⟨⟨n⟩, m10⟩ := S10
      simp only at halloc10 ⊢
      rw [halloc10, ← hB]
  · intro E9 S9 hA9 hW9 hI9 herr
    rw [bb9_run (B := B) hA9 (by chain_reads) (hI9.room (hS ▸ hb0)) (hI9.room (hS ▸ hb1))
        (hI9.room (hS ▸ hb2)) (hI9.room (hS ▸ hb3)) (hI9.room (hS ▸ hb4))
        (by
          dsimp only [EndRegs]; chain_reads)]
    have herr' :
      (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).1.t2nz &&&
          (decs (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)).1.t1nz ≠
        0 :=
      herr
    subst hR
    have hspec :
      fd_r52x5_ge_decode2.spec (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256) =
        (-1, none, quadZero) := by
      simp only [fd_r52x5_ge_decode2.spec, Dec.err, bne_iff_ne, ne_eq, herr', not_false_eq_true,
        ↓reduceIte]
    rw [hspec]
    have halloc := hI9.alloc
    have herase := hI9.erase
    simp only [storeOut, blocks, show (-1 : BitVec 32) ≠ 0 by decide, ↓reduceIte]
    rw [← eraseFrom_eraseFrom (show S₀.alloc.nextFreeBlock ≤ B.alloc.nextFreeBlock + 3 by omega),
      eraseFrom_endFields, MemoryState.eraseFrom_storeTmp5, herase, MemoryState.eraseFrom_storeTmp5,
      hM0]
    obtain ⟨⟨n⟩, m9⟩ := S9
    simp only at halloc ⊢
    rw [halloc, ← hB]

end Proof

end MLIR.Firedancer.R52x5
