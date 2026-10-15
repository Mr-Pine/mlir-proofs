module

public import Firedancer.Lane.verify_x8.Defs
import Firedancer.Lane.verify_x8.HashMem
import Firedancer.Lane.verify_x8.Tactics
import Firedancer.Lane.fd_sha512_init
import Firedancer.Lane.fd_sha512_append
import Firedancer.Lane.fd_sha512_fini
import Firedancer.Common.Counter

/-! `verify_x8`'s hashes (`^bb62 … ^bb74`, `^bb63 … ^bb65`): per live item `R ‖ A ‖ msg` copied
into `hash_input[j]` and added to the batch (run at eight), or streamed through `shas[j]`; then
`fd_sha512_batch_fini`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

/-- The loop's registers at item `j`: `Env62`'s, `&batch->cnt`, `batch->sz`, `batch->hash`, `j`. -/
abbrev EnvH (c : Call) (E : ⟪Γ⟫) (j : Nat) : Prop :=
  Env62 c E ∧
    E ⊨ [rir_reg% hty 2064 := PoisonOr.value ((c.s.slot 32).add 192#64),
      rir_reg% hty 2065 := PoisonOr.value ((c.s.slot 32).add 64#64),
      rir_reg% hty 2066 := PoisonOr.value ((c.s.slot 32).add 128#64),
      rir_reg% hty 2069 := PoisonOr.value (BitVec.ofNat 64 j)]

/-- `sz + 64` does not wrap, signed. -/
theorem sadd64 {sz : BitVec 64} (h : sz.ult 1233#64 = true) : sz.saddOverflow 64#64 = false := by
  bv_decide

/-- `sz + 64` does not wrap. -/
theorem uadd64 {sz : BitVec 64} (h : sz.ult 1233#64 = true) : sz.uaddOverflow 64#64 = false := by
  bv_decide

attribute [local mlir_transport] storeDigests_fits storeDigests_room
  GlobalState.WF.storeDigests_mk InBounds.storeSha GlobalState.WF.add_blocks_storeSha
  GlobalState.WF.add_blocks_storeSha_storeWords8 MemoryState.Words8Room.storeSha

attribute [local mlir_read] MemoryState.readSha_storeSha_self MemoryState.readAt_storeWords8_self
  MemoryState.loadPtr_storeSha_of_id_ne MemoryState.loadPtr_storeWords8_of_id_ne

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

/-- `^bb70 … ^bb72`: item `j` queued at entry `q` (`fd_sha512_batch_add`), the batch run at eight;
on to `^bb74`. -/
theorem bb70_run (c : Call) (nb) (hb : BatchCallEq c.batch c.G nb) (j q : Nat)
    (sel : Nat → Nat) (hj : j < c.cnt) (h8 : c.cnt ≤ 8) (hs : c.short j = true) (E : ⟪Γ⟫)
    (S : GlobalState) (hA : E.args = c.args) (hE : EnvH c E j)
    (hE2 : E ⊨ [rir_reg% hty 2075 := PoisonOr.value (c.it j).msgSz,
      rir_reg% hty 2077 := PoisonOr.value (c.row j)])
    (hI : c.Inv j q sel S)
    (hrf : Fits S.mem (c.row j) (8 * ((c.it j).msgSz + 64#64).toNat))
    (hrh : sha512Bits ((c.it j).msgSz + 64#64)
        (S.mem.readAt (c.row j) (8 * ((c.it j).msgSz + 64#64).toNat)) = (c.it j).digest c.s.mem)
    (hK : ∀ (q' : Nat) (sel' : Nat → Nat) (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
      EnvH c E' j → c.Inv (j + 1) q' sel' S' → ((verify_x8 c.batch).runFrom E' 74 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 70 S >>= g) = K := by
  have hP := hI.toPend
  have hq := hP.q_le
  have hj8 : j < 8 := by omega
  have hmod64 : j % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  have hqmod : q % 18446744073709551616 = q := Nat.mod_eq_of_lt (by omega)
  have hult : (c.it j).msgSz.ult 1233#64 = true := by
    simpa [BitVec.ult] using Call.short_sz hs
  have hwf := hP.base.wf
  have hcntf := hI.cnt_fits
  have hcntr := hI.cnt_read
  have hr32 := hP.room32
  have hr64 := ent_room (a := 64) (k := q) (by omega) (by decide) hP.room32
  have hr128 := ent_room (a := 128) (k := q) (by omega) (by decide) hP.room32
  have e0 : (c.s.slot 32).add (BitVec.ofNat 64 (q * 8)) =
      (c.s.slot 32).add (BitVec.ofNat 64 0 + BitVec.ofNat 64 (q * 8)) := by simp
  have d10 : (Range.of ((c.s.slot 32).add (64#64 + BitVec.ofNat 64 (q * 8))) 64).Disjoint
      (Range.of ((c.s.slot 32).add (BitVec.ofNat 64 (q * 8))) 64) := by
    rw [e0]; exact ent_disjoint (by omega) (by omega) (by decide) (by decide) (by omega) rfl rfl
  have d20 : (Range.of ((c.s.slot 32).add (128#64 + BitVec.ofNat 64 (q * 8))) 64).Disjoint
      (Range.of ((c.s.slot 32).add (BitVec.ofNat 64 (q * 8))) 64) := by
    rw [e0]; exact ent_disjoint (by omega) (by omega) (by decide) (by decide) (by omega) rfl rfl
  have d21 : (Range.of ((c.s.slot 32).add (128#64 + BitVec.ofNat 64 (q * 8))) 64).Disjoint
      (Range.of ((c.s.slot 32).add (64#64 + BitVec.ofNat 64 (q * 8))) 64) :=
    ent_disjoint (by omega) (by omega) (by decide) (by decide) (by omega) rfl rfl
  clear e0
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hI hP hrf hrh
  split_reads hE hE2
  show ((verify_x8 c.batch).runFrom E ⟨70, (by decide : 70 < 104)⟩ S >>= g) = K
  block_init
  step_pure [sadd64 hult, uadd64 hult]
  step_pure [hmod64]
  step_load consuming hcntf hcntr
  step_pure [hqmod]
  step_store
  step_pure [hqmod]
  step_store
  step_pure [hqmod]
  step_store
  step_pure
  step_pure
  subst hS₀
  have hpush := hP.push hj8 hs hrf hrh
  finish_block
  · -- the eighth: `fd_sha512_private_batch_avx512( 8, … )`, `batch->cnt = 0`
    have hq1 : q + 1 = 8 := by
      have := congrArg BitVec.toNat hbr
      rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat] at this
      simp at this
      omega
    have hargs := hpush.batch_args (by omega)
    rw [hq1] at hargs
    obtain ⟨hargs1, hargs2⟩ := hargs
    have hSm := congrArg GlobalState.mem hS
    dsimp only at hSm hargs1
    simp only [Call.pushMem] at hargs1
    rw [← hSm] at hargs1
    have hgl : S.mem.Globals c.G := by rw [hS]; exact hpush.base.globalsG
    block_init
    step_call using (hb 8#64 (c.s.slot 32) ((c.s.slot 32).add 64#64) ((c.s.slot 32).add 128#64)
      (fun i => c.row (if i = q then j else sel i))
      (fun i => (c.it (if i = q then j else sel i)).msgSz + 64#64)
      (fun i => c.hashAt (if i = q then j else sel i)) S hwf hgl (by decide) (by decide) hargs1
      hargs2) consuming hargs1 hargs2 hgl
    finish_block
    block_init
    step_store
    finish_block
    have hInv := (hpush.batch (by omega)
      (nb 8#64 (c.s.slot 32) ((c.s.slot 32).add 64#64) ((c.s.slot 32).add 128#64)
        ⟨S₀.alloc, c.pushMem S₀.mem q j ((c.it j).msgSz + 64#64)⟩)).cnt (by omega) 0#64 rfl
    rw [hq1] at hInv
    refine hK 0 (fun k => if k = q then j else sel k) E S hArgs ⟨by env_reads, by env_reads⟩ ?_
    rw [hS]
    exact hInv
  · block_init
    step_store
    finish_block
    refine hK (q + 1) (fun k => if k = q then j else sel k) E S hArgs
      ⟨by env_reads, by env_reads⟩ ?_
    rw [hS]
    exact hpush.cnt (by omega) _ (BitVec.ofNat_add q 1).symm

/-- `^bb68`, `^bb69`: `R`, `A` and the message copied into `hash_input[j]`; on to `^bb70`. -/
theorem copy_run (c : Call) (hc : c.Ok) (nb) (hb : BatchCallEq c.batch c.G nb) (j q : Nat)
    (sel : Nat → Nat) (hj : j < c.cnt) (hs : c.short j = true) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvH c E j)
    (hE2 : E ⊨ [rir_reg% hty 2075 := PoisonOr.value (c.it j).msgSz])
    (hI : c.Inv j q sel S)
    (hK : ∀ (q' : Nat) (sel' : Nat → Nat) (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
      EnvH c E' j → c.Inv (j + 1) q' sel' S' → ((verify_x8 c.batch).runFrom E' 74 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 68 S >>= g) = K := by
  have h8 := hc.cnt8
  have hj8 : j < 8 := by omega
  have hmod64 : j % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  have hsz := Call.short_sz hs
  have hit := c.itemAt hc hj hI.base
  obtain ⟨-, hov2, hov3, hov4, -⟩ := c.arr_ov hc hj
  obtain ⟨h1, -, -, -, h5, -, h7, -, -, -⟩ := hc.batch.holds j hj
  obtain ⟨o1, -, -, o4, -, o6, -, -, -⟩ := hc.batch.ok j hj
  have hsig_lt := hc.wf.id_lt_of_inBounds o4.inBounds
  have hpk_lt := hc.wf.id_lt_of_inBounds o6.inBounds
  have hmsg_lt := hc.wf.id_lt_of_inBounds o1.inBounds
  have h3_lt : c.a.pks.id.id < c.s.alloc.nextFreeBlock := by
    have := hc.wf.id_lt_of_inBounds h7; exact this
  have h4_lt : c.a.msgs.id.id < c.s.alloc.nextFreeBlock := by
    have := hc.wf.id_lt_of_inBounds h1; exact this
  clear o1 o4 o6 h5 h7 h1
  have hs30 : c.s.alloc.nextFreeBlock + 30 ≤ (c.s.slot 30).id.id := by simp
  have hr30 := hI.room30
  have hrow32 := c.row_room (k := 32) (w := 8 * 32) hj8 hr30 (by decide) (by decide)
  have hrow64 := c.row_room (k := 64) (w := 8 * (c.it j).msgSz.toNat) hj8 hr30 (by decide)
    (by omega)
  have hsigb := hit.sigb
  have hsigr := hit.sigr
  have hpkb := hit.pkb
  have hpkr := hit.pkr
  have hmsgb := hit.msgb
  have hmsgr := hit.msgr
  have hsig := hit.sig
  have hpk := hit.pk
  have hmsg := hit.msg
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hI hit
  split_reads hE hE2
  show ((verify_x8 c.batch).runFrom E ⟨68, (by decide : 68 < 104)⟩ S >>= g) = K
  block_init
  step_pure [hmod64]
  step_pure [hmod64, gep_value (f := { nuw := true }) hov2 (Or.inl rfl)]
  step_load consuming hsigb hsigr
  step_memcpy consuming hsig
  step_pure
  step_pure [hmod64, gep_value (f := { nuw := true }) hov3 (Or.inl rfl)]
  step_load consuming hpkb hpkr
  step_memcpy consuming hpk
  step_pure
  subst hS₀
  finish_block
  · -- an empty message: no third `fd_memcpy`
    have hz : (c.it j).msgSz = 0#64 := hbr
    obtain ⟨hrf, hrh⟩ := c.rowMem0_hashed hj8 hI.room30 hz
    have hI1 := hI.row hj8 (c.rowMem0_mods _ _ ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem))
      (c.rowMem0_row _ hj8 _ _) (fun _ _ h => h.storeAt.storeAt)
    rw [← hit.sig_r, ← hit.pk_r] at hrf hrh hI1
    have hS' : S = ⟨S₀.alloc, c.rowMem0 S₀.mem j (S₀.mem.readAt (c.it j).sig 256)
        (S₀.mem.readAt (c.it j).pk 256)⟩ := hS
    have hSm : S.mem = c.rowMem0 S₀.mem j (S₀.mem.readAt (c.it j).sig 256)
        (S₀.mem.readAt (c.it j).pk 256) := by rw [hS']
    rw [← hSm] at hrf hrh
    rw [← hS'] at hI1
    exact bb70_run c nb hb j q sel hj h8 hs E S hArgs ⟨by env_reads, by env_reads⟩
      (by env_reads) hI1 hrf hrh hK
  · block_init
    step_pure
    step_pure [hmod64, gep_value (f := { nuw := true }) hov4 (Or.inl rfl)]
    step_load consuming hmsgb hmsgr
    step_memcpy consuming hmsg
    finish_block
    obtain ⟨hrf, hrh⟩ := c.rowMem_hashed hj8 hI.room30 hsz
    have hI1 := hI.row hj8 (c.rowMem_mods _ _ ((c.it j).readR c.s.mem) ((c.it j).readA c.s.mem)
        ((c.it j).readMsg c.s.mem)) (c.rowMem_row _ hj8 _ _ (by omega) _)
      (fun _ _ h => h.storeAt.storeAt.storeAt)
    rw [← hit.sig_r, ← hit.pk_r, ← hit.msg_r] at hrf hrh hI1
    have hS' : S = ⟨S₀.alloc, c.rowMem S₀.mem j (S₀.mem.readAt (c.it j).sig 256)
        (S₀.mem.readAt (c.it j).pk 256)
        (S₀.mem.readAt (c.it j).msg (8 * (c.it j).msgSz.toNat))⟩ := hS
    have hSm : S.mem = c.rowMem S₀.mem j (S₀.mem.readAt (c.it j).sig 256)
        (S₀.mem.readAt (c.it j).pk 256)
        (S₀.mem.readAt (c.it j).msg (8 * (c.it j).msgSz.toNat)) := by rw [hS']
    rw [← hSm] at hrf hrh
    rw [← hS'] at hI1
    exact bb70_run c nb hb j q sel hj h8 hs E S hArgs ⟨by env_reads, by env_reads⟩
      (by env_reads) hI1 hrf hrh hK

/-- `^bb73`: item `j` streamed through `shas[j]` (`fd_sha512_init`, three `append`s, `fini` into
`hashes[j]`); on to `^bb74`. -/
theorem stream_run (c : Call) (hc : c.Ok) (j q : Nat) (sel : Nat → Nat) (hj : j < c.cnt)
    (hl : c.long j = true) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args) (hE : EnvH c E j)
    (hE2 : E ⊨ [rir_reg% hty 2074 := PoisonOr.value (c.a.msgSzs.add (BitVec.ofNat 64 (j * 8)))])
    (hI : c.Inv j q sel S)
    (hK : ∀ (q' : Nat) (sel' : Nat → Nat) (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
      EnvH c E' j → c.Inv (j + 1) q' sel' S' → ((verify_x8 c.batch).runFrom E' 74 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 73 S >>= g) = K := by
  have h8 := hc.cnt8
  have hj8 : j < 8 := by omega
  have hmod64 : j % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  have hit := c.itemAt hc hj hI.base
  obtain ⟨-, hov2, hov3, hov4, hov5⟩ := c.arr_ov hc hj
  obtain ⟨h1, -, h3, -, h5, -, h7, -, h9, -⟩ := hc.batch.holds j hj
  obtain ⟨o1, hmsg_ov, hsz63, o4, hsig_ov, o6, hpk_ov, o8, o9⟩ := hc.batch.ok j hj
  have hsep := hc.batch.sep
  have hsig_lt := hc.wf.id_lt_of_inBounds o4.inBounds
  have hpk_lt := hc.wf.id_lt_of_inBounds o6.inBounds
  have hmsg_lt := hc.wf.id_lt_of_inBounds o1.inBounds
  have hsha_lt := hc.wf.id_lt_of_inBounds o8.1.inBounds
  have h1_lt : c.a.msgs.id.id < c.s.alloc.nextFreeBlock := by
    have := hc.wf.id_lt_of_inBounds h1; exact this
  have h3_lt : c.a.msgSzs.id.id < c.s.alloc.nextFreeBlock := by
    have := hc.wf.id_lt_of_inBounds h3.inBounds; exact this
  have h5_lt : c.a.sigs.id.id < c.s.alloc.nextFreeBlock := by
    have := hc.wf.id_lt_of_inBounds h5; exact this
  have h7_lt : c.a.pks.id.id < c.s.alloc.nextFreeBlock := by
    have := hc.wf.id_lt_of_inBounds h7; exact this
  have h9_lt : c.a.shas.id.id < c.s.alloc.nextFreeBlock := by
    have := hc.wf.id_lt_of_inBounds h9; exact this
  -- the hash object is no input's block
  have hro (b : BlockId) (hb : c.a.ReadOnly c.it c.cnt b) : b ≠ (c.it j).sha.id :=
    fun h => (hsep.2.1 j hj).1 (h ▸ hb)
  have hsig_sha := hro _ (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨j, hj, Or.inr (Or.inl rfl)⟩)))))
  have hpk_sha := hro _ (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨j, hj, Or.inr (Or.inr rfl)⟩)))))
  have hmsg_sha := hro _ (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨j, hj, Or.inl rfl⟩)))))
  have h1s := hro _ (Or.inl rfl)
  have h3s := hro _ (Or.inr (Or.inl rfl))
  have h5s := hro _ (Or.inr (Or.inr (Or.inl rfl)))
  have h7s := hro _ (Or.inr (Or.inr (Or.inr (Or.inl rfl))))
  have h9s := hro _ (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl)))))
  have hsig_ov32 : ¬(c.it j).sig.offset.uaddOverflow 32#64 :=
    BitVec.not_uaddOverflow_of_le hsig_ov (by decide)
  clear h1 h3 h5 h7 h9 o1 o4 o6 o8 o9 hro hsep hsig_ov
  have hs31 : c.s.alloc.nextFreeBlock + 31 ≤ (c.s.slot 31).id.id := by simp
  have hwf := hI.base.wf
  have hg := hI.base.globals
  have hk := c.hashAt_words8Room hj8 hI.room31
  have hszf := hit.szf
  have hszr := hit.szr
  have hsigb := hit.sigb
  have hsigr := hit.sigr
  have hpkb := hit.pkb
  have hpkr := hit.pkr
  have hmsgb := hit.msgb
  have hmsgr := hit.msgr
  have hshab := hit.shab
  have hshar := hit.shar
  have hsig := hit.sig
  have hpk := hit.pk
  have hmsg := hit.msg
  have hshaw := hit.shaw
  have hinit := fd_sha512_init.readSha hit.sha hit.shaw
  obtain ⟨hsha_fits, hsha_off⟩ := hit.sha
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hI hit
  split_reads hE hE2
  show ((verify_x8 c.batch).runFrom E ⟨73, (by decide : 73 < 104)⟩ S >>= g) = K
  block_init
  -- fd_sha512_init( shas[j] )
  step_pure [hmod64, gep_value (f := { nuw := true }) hov5 (Or.inl rfl)]
  step_load consuming hshab hshar
  step_call using _root_.Firedancer.Lane.Mlir.fd_sha512_init.call_eq
  subst hS₀
  have hsh0 : S.mem.readSha (c.it j).sha =
      ⟨S₀.mem.readAt (c.it j).sha 1024, sha512IV, 0#64, 0#64, 0#64⟩ := by
    rw [show BitVec.replicate 24 0#8 = 0#192 from by decide] at hinit
    rw [hS]
    exact hinit
  clear hinit
  have hsha : S.mem.ShaFit (c.it j).sha := ⟨hsha_fits, hsha_off⟩
  clear hsha_fits
  -- the appends of `R`, `A` and the message
  step_pure [hmod64, gep_value (f := { nuw := true }) hov2 (Or.inl rfl)]
  step_load consuming hsigb hsigr
  step_call using
    (_root_.Firedancer.Lane.Mlir.fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hsh0).mpr (by simp)))
  step_pure [hmod64, gep_value (f := { nuw := true }) hov3 (Or.inl rfl)]
  step_load consuming hpkb hpkr
  grab hread_sha : S.mem.readSha (c.it j).sha = _
  step_call using
    (_root_.Firedancer.Lane.Mlir.fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))
  step_pure [hmod64, gep_value (f := { nuw := true }) hov4 (Or.inl rfl)]
  step_load consuming hmsgb hmsgr
  step_load consuming hszf hszr
  grab hread_sha : S.mem.readSha (c.it j).sha = _
  step_call using
    (_root_.Firedancer.Lane.Mlir.fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (fd_sha512_append.spec_bufUsed_lt _ _ _
          (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp)))))
  -- fd_sha512_fini( sha, hashes[j] )
  step_pure [hmod64]
  grab hread_sha : S.mem.readSha (c.it j).sha = _
  step_call using
    (_root_.Firedancer.Lane.Mlir.fd_sha512_fini.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (fd_sha512_append.spec_bufUsed_lt _ _ _
          (fd_sha512_append.spec_bufUsed_lt _ _ _
            (fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))))
  finish_block
  refine hK q sel E S hArgs ⟨by env_reads, by env_reads⟩ ?_
  rw [hS, MemoryState.storeSha_storeSha_self hsha_off, MemoryState.storeSha_storeSha_self hsha_off,
    MemoryState.storeSha_storeSha_self hsha_off]
  simp only [Nat.add_assoc]
  exact hI.stream hc hj hl _

/-- `^bb74`: `j + 1`, then around to `^bb66` or, past the last item, to `^bb63`. -/
theorem bb74_run (c : Call) (hc : c.Ok) (j : Nat) (hj : j < c.cnt)
    (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args) (hE : EnvH c E j)
    (hback :
      j + 1 < c.cnt → ∀ E' : ⟪Γ⟫, E'.args = c.args → EnvH c E' (j + 1) →
        ((verify_x8 c.batch).runFrom E' 66 S >>= g) = K)
    (hexit :
      j + 1 = c.cnt → ∀ E' : ⟪Γ⟫, E'.args = c.args → EnvH c E' j →
        ((verify_x8 c.batch).runFrom E' 63 S >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 74 S >>= g) = K := by
  have h8 := hc.cnt8
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨74, (by decide : 74 < 104)⟩ S >>= g) = K
  block_init
  step_pure [uaddOverflow_one64 (i := j) (by omega)]
  step_pure
  finish_block
  · have hj1 : j + 1 = c.cnt := by
      have := congrArg BitVec.toNat hbr
      simp [BitVec.toNat_add] at this
      omega
    exact hexit hj1 E hArgs ⟨by env_reads, by env_reads⟩
  · have hj1 : j + 1 < c.cnt := by
      have : j + 1 ≠ c.cnt := fun h => hbr (by rw [← h, BitVec.ofNat_add])
      omega
    refine hback hj1 E hArgs ⟨by env_reads, ?_⟩
    simp only [BitVec.ofNat_add]
    env_reads

/-- One item (`^bb66`, `^bb67`): skipped if not live, else copied for the batch (at most
`LANE_HASH_COPY_MAX` bytes) or streamed; on to `^bb74`. -/
theorem trip (c : Call) (hc : c.Ok) (nb) (hb : BatchCallEq c.batch c.G nb) (j q : Nat)
    (sel : Nat → Nat) (hj : j < c.cnt) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hE : EnvH c E j) (hI : c.Inv j q sel S)
    (hK : ∀ (q' : Nat) (sel' : Nat → Nat) (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
      EnvH c E' j → c.Inv (j + 1) q' sel' S' → ((verify_x8 c.batch).runFrom E' 74 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 66 S >>= g) = K := by
  have h8 := hc.cnt8
  have hj8 : j < 8 := by omega
  have hmod : j % 4294967296 = j := Nat.mod_eq_of_lt (by omega)
  have h32 : ¬32 ≤ j := by omega
  have hmod64 : j % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  have hov1 := (c.arr_ov hc hj).1
  have hit := c.itemAt hc hj hI.base
  have hszf := hit.szf
  have hszr := hit.szr
  have hlm : c.liveMask.getLsbD j = c.X.liveAt j := by
    rw [Call.liveMask, getLsbD_maskOf]; rfl
  clear hit
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hI
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨66, (by decide : 66 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  step_pure [hmod, h32, one_shl_shr hj8]
  step_pure
  step_pure
  finish_block
  · -- not live: on to the next
    rw [and_bit_iff _ (by omega), hlm] at hbr
    subst hS₀
    exact hK q sel E S₀ hArgs ⟨by env_reads, by env_reads⟩ (hI.skip hbr)
  · have hl : c.X.liveAt j = true := by
      rw [and_bit_iff _ (by omega), hlm] at hbr; simpa using hbr
    block_init
    step_pure [hmod64, gep_value (f := { nuw := true }) hov1 (Or.inl rfl)]
    step_load consuming hszf hszr
    step_pure
    subst hS hS₀
    finish_block
    · -- at most `LANE_HASH_COPY_MAX` bytes: copied for the batch
      have hs : c.short j = true := by
        simp only [Call.short, hl, Bool.true_and, decide_eq_true_eq]
        simpa [BitVec.ult] using hbr
      exact copy_run c hc nb hb j q sel hj hs E S₀ hArgs ⟨by env_reads, by env_reads⟩
        (by rw [← hv2075]; env_reads) hI hK
    · have hlong : c.long j = true := by
        simp only [Call.long, hl, Bool.true_and, decide_eq_true_eq]
        simp [BitVec.ult] at hbr
        omega
      exact stream_run c hc j q sel hj hlong E S₀ hArgs ⟨by env_reads, by env_reads⟩
        (by env_reads) hI hK

/-- The loop from item `j`, `n + 1` items left: on to `^bb63` with every item handled. -/
theorem loop (c : Call) (hc : c.Ok) (nb) (hb : BatchCallEq c.batch c.G nb)
    (hfin : ∀ (q : Nat) (sel : Nat → Nat) (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
      EnvH c E' (c.cnt - 1) → c.Inv c.cnt q sel S' →
        ((verify_x8 c.batch).runFrom E' 63 S' >>= g) = K) :
    ∀ n j q (sel : Nat → Nat) (E : ⟪Γ⟫) (S : GlobalState), j + n + 1 = c.cnt →
      E.args = c.args → EnvH c E j → c.Inv j q sel S →
      ((verify_x8 c.batch).runFrom E 66 S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro j q sel E S hn hA hE hI
    refine trip c hc nb hb j q sel (by omega) E S hA hE hI fun q' sel' E' S' hA' hE' hI' => ?_
    refine bb74_run c hc j (by omega) E' S' hA' hE' (fun h => absurd h (by omega))
      fun h E'' h1 h2 => ?_
    rw [show j = c.cnt - 1 by omega] at h2
    rw [h] at hI'
    exact hfin q' sel' E'' S' h1 h2 hI'
  | succ n ih =>
    intro j q sel E S hn hA hE hI
    refine trip c hc nb hb j q sel (by omega) E S hA hE hI fun q' sel' E' S' hA' hE' hI' => ?_
    exact bb74_run c hc j (by omega) E' S' hA' hE'
      (fun _ E'' h1 h2 => ih (j + 1) q' sel' E'' S' (by omega) h1 h2 hI')
      fun h => absurd h (by omega)

/-- `^bb63 … ^bb65`: `fd_sha512_batch_fini`, the batch run on the queue's rest; on to `^bb76`. -/
theorem fin_run (c : Call) (hc : c.Ok) (nb) (hb : BatchCallEq c.batch c.G nb) (q : Nat)
    (sel : Nat → Nat) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args)
    (hE : EnvH c E (c.cnt - 1)) (hI : c.Inv c.cnt q sel S)
    (h76 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env76 c E' → c.At76 S' →
        ((verify_x8 c.batch).runFrom E' 76 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 63 S >>= g) = K := by
  have h8 := hc.cnt8
  have hP := hI.toPend
  have hq := hP.q_le
  have hcntf := hI.cnt_fits
  have hcntr := hI.cnt_read
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hI hP
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨63, (by decide : 63 < 104)⟩ S >>= g) = K
  block_init
  step_load consuming hcntf hcntr
  step_pure
  subst hS hS₀
  have hqt : (BitVec.ofNat 64 q).toNat = q := by rw [BitVec.toNat_ofNat]; omega
  finish_block
  · -- nothing queued
    have hq0 : q = 0 := by
      have := congrArg BitVec.toNat hbr
      simpa [hqt] using this
    subst hq0
    block_init
    finish_block
    exact h76 E S₀ hArgs (by env_reads) hP.at76
  · -- fd_sha512_private_batch_avx512( batch->cnt, … )
    have hq0 : 0 < q := by
      have : q ≠ 0 := fun h => hbr (by rw [h])
      omega
    obtain ⟨hargs1, hargs2⟩ := hP.batch_args h8
    rw [← hqt] at hargs1 hargs2
    have hgl := hP.base.globalsG
    have hwf := hP.base.wf
    obtain ⟨S₁, hS₁⟩ : ∃ S₁, S₁ = S₀ := ⟨S₀, rfl⟩
    rw [← hS₁] at hP hI
    block_init
    step_call using (hb (BitVec.ofNat 64 q) (c.s.slot 32) ((c.s.slot 32).add 64#64)
      ((c.s.slot 32).add 128#64) (fun i => c.row (sel i))
      (fun i => (c.it (sel i)).msgSz + 64#64) (fun i => c.hashAt (sel i)) S hwf hgl
      (by rw [hqt]; exact hq0) (by rw [hqt]; omega) (hS ▸ hargs1) hargs2)
      consuming hargs1 hargs2 hgl
    finish_block
    block_init
    finish_block
    refine h76 E S hArgs (by env_reads) ?_
    subst hS₁
    rw [hS, hqt]
    exact (hP.batch h8 _).at76

/-- The hashes: live item `j`'s digest at `hashes[j]`, the long messages' hash objects streamed. -/
public theorem hash_run (c : Call) (hc : c.Ok) (nb) (hb : BatchCallEq c.batch c.G nb) (E : ⟪Γ⟫)
    (S : GlobalState) (hA : E.args = c.args) (hE : Env62 c E) (hS : c.At62 S)
    (_hlive : c.liveMask ≠ 0)
    (h76 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env76 c E' → c.At76 S' →
        ((verify_x8 c.batch).runFrom E' 76 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 62 S >>= g) = K := by
  have h3 := hc.cnt3
  have hAt := hS
  clear hS
  have h30 := hAt.base.slots 30 (by decide)
  have h31 := hAt.base.slots 31 (by decide)
  have h32 := hAt.base.slots 32 (by decide)
  have hw30 := hAt.base.writable 30 (by decide)
  have hw31 := hAt.base.writable 31 (by decide)
  have hw32 := hAt.base.writable 32 (by decide)
  have hwf := hAt.base.wf
  simp only [slotBytes, List.getElem_cons_succ, List.getElem_cons_zero] at h30 h31 h32
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hAt
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨62, (by decide : 62 < 104)⟩ S >>= g) = K
  block_init
  -- fd_sha512_batch_init( batch ): the three objects started, `batch->cnt = 0`
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  finish_block
  subst hS₀
  grab r30 : Room S.mem (c.s.slot 30) (8 * 10368)
  grab r31 : Room S.mem (c.s.slot 31) (8 * 512)
  grab r32 : Room S.mem (c.s.slot 32) (8 * 256)
  grab hcf : Fits S.mem ((c.s.slot 32).add 192#64) 64
  grab hcr : S.mem.readAt ((c.s.slot 32).add 192#64) 64 = 0#64
  have hI := Call.inv0 hAt (fun _ => 0) hS hwf r30 r31 r32 hcf hcr
  exact loop c hc nb hb
    (fun q sel E' S' hA' hE' hI' => fin_run c hc nb hb q sel E' S' hA' hE' hI' h76)
    (c.cnt - 1) 0 0 (fun _ => 0) E S (by omega) hArgs ⟨by env_reads, by env_reads⟩ hI

end MLIR.Firedancer.Lane.VerifyX8
