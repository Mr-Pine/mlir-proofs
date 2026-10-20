module

public import Firedancer.Crc.Verify.Decode2.Frame
import Firedancer.Crc.Verify.Decode2.Tactics
import Firedancer.Crc.Verify.QuadRuns

/-! `^bb0` of `fd_r52x5_ge_decode2`: `Y` from both encodings, then its quad call sites. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_r52x5_ge_decode2

attribute [local mlir_env 1100] read_write_same

private theorem Inv.slots {B : GlobalState} {M : MemoryState} {c : Nat} :
    ∀ s, Inv B M c s → s.WF ∧ SlotFrame B 246 s.mem := fun _ h =>
  ⟨h.wf, fun j hj => ⟨(h.frame j hj).1.mono (by unfold slotBytes; split_ifs <;> decide),
    (h.frame j hj).2⟩⟩

private theorem Inv.callTmp5_slots {B : GlobalState} {M : MemoryState} {c : Nat} :
    ∀ s j0 j1 j2 j3 j4 Q, Inv B M c s →
      Inv B M c
        ⟨s.alloc, s.mem.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q⟩ :=
  fun _ _ _ _ _ _ _ h =>
    ⟨h.wf.callTmp5, h.frame.callTmp5, eraseFrom_callTmp5_slot.trans h.erase, h.alloc⟩

/-- `^bb0`'s sites `393` to `399`: limb `1` of both encodings into lanes `0`, `1`. -/
private theorem ys_round1 {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {P0 P1 : Pointer} {x y : BitVec 64}
    (hR : E ⊨ [rir_reg% hty 139 := PoisonOr.value P0, rir_reg% hty 140 := PoisonOr.value P1,
      rir_reg% hty 59 := PoisonOr.value 0#64, rir_reg% hty 55 := PoisonOr.value 1#64,
      rir_reg% hty 66 := yUndef])
    (h0 : P0.offset.toNat + 32 < 2 ^ 64) (h1 : P1.offset.toNat + 32 < 2 ^ 64)
    (hf0 : Fits S.mem (P0.add 8#64) 64) (hf1 : Fits S.mem (P1.add 8#64) 64)
    (ha : S.mem.readAt (P0.add 8#64) 64 = x) (hb : S.mem.readAt (P1.add 8#64) 64 = y)
    (hK : ∀ E' : ⟪Γ⟫, Writes E E' 389 395 →
      E' ⊨ [rir_reg% hty 394 := Ty.wrap (wl x y 0#64 0#64)] →
      (bb0.runBodyFrom E' 399 S >>= g) = K) :
    (bb0.runBodyFrom E 393 S >>= g) = K := by
  step_pure
  step_load
  step_pure
  step_load
  step_pure [insert_y_eq]
  step_pure [insert_y_eq]
  subst hS
  exact hK E (by rw [hE]; writes_chain) (by lemma_reads)

/-- `^bb0`'s sites `399` to `405`: limb `2` of both encodings into lanes `0`, `1`. -/
private theorem ys_round2 {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {P0 P1 : Pointer} {x y : BitVec 64}
    (hR : E ⊨ [rir_reg% hty 139 := PoisonOr.value P0, rir_reg% hty 140 := PoisonOr.value P1,
      rir_reg% hty 59 := PoisonOr.value 0#64, rir_reg% hty 55 := PoisonOr.value 1#64,
      rir_reg% hty 66 := yUndef])
    (h0 : P0.offset.toNat + 32 < 2 ^ 64) (h1 : P1.offset.toNat + 32 < 2 ^ 64)
    (hf0 : Fits S.mem (P0.add 16#64) 64) (hf1 : Fits S.mem (P1.add 16#64) 64)
    (ha : S.mem.readAt (P0.add 16#64) 64 = x) (hb : S.mem.readAt (P1.add 16#64) 64 = y)
    (hK : ∀ E' : ⟪Γ⟫, Writes E E' 395 401 →
      E' ⊨ [rir_reg% hty 400 := Ty.wrap (wl x y 0#64 0#64)] →
      (bb0.runBodyFrom E' 405 S >>= g) = K) :
    (bb0.runBodyFrom E 399 S >>= g) = K := by
  step_pure
  step_load
  step_pure
  step_load
  step_pure [insert_y_eq]
  step_pure [insert_y_eq]
  subst hS
  exact hK E (by rw [hE]; writes_chain) (by lemma_reads)

/-- `^bb0`'s sites `405` to `411`: limb `3` of both encodings into lanes `0`, `1`. -/
private theorem ys_round3 {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {P0 P1 : Pointer} {x y : BitVec 64}
    (hR : E ⊨ [rir_reg% hty 139 := PoisonOr.value P0, rir_reg% hty 140 := PoisonOr.value P1,
      rir_reg% hty 59 := PoisonOr.value 0#64, rir_reg% hty 55 := PoisonOr.value 1#64,
      rir_reg% hty 66 := yUndef])
    (h0 : P0.offset.toNat + 32 < 2 ^ 64) (h1 : P1.offset.toNat + 32 < 2 ^ 64)
    (hf0 : Fits S.mem (P0.add 24#64) 64) (hf1 : Fits S.mem (P1.add 24#64) 64)
    (ha : S.mem.readAt (P0.add 24#64) 64 = x) (hb : S.mem.readAt (P1.add 24#64) 64 = y)
    (hK : ∀ E' : ⟪Γ⟫, Writes E E' 401 407 →
      E' ⊨ [rir_reg% hty 406 := Ty.wrap (wl x y 0#64 0#64)] →
      (bb0.runBodyFrom E' 411 S >>= g) = K) :
    (bb0.runBodyFrom E 405 S >>= g) = K := by
  step_pure
  step_load
  step_pure
  step_load
  step_pure [insert_y_eq]
  step_pure [insert_y_eq]
  subst hS
  exact hK E (by rw [hE]; writes_chain) (by lemma_reads)

/-- `^bb0`'s sites `411` to `417`: limb `4` of both encodings into lanes `0`, `1`. -/
private theorem ys_round4 {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {P0 P1 : Pointer} {x y : BitVec 64}
    (hR : E ⊨ [rir_reg% hty 139 := PoisonOr.value P0, rir_reg% hty 140 := PoisonOr.value P1,
      rir_reg% hty 59 := PoisonOr.value 0#64, rir_reg% hty 55 := PoisonOr.value 1#64,
      rir_reg% hty 66 := yUndef])
    (h0 : P0.offset.toNat + 32 < 2 ^ 64) (h1 : P1.offset.toNat + 32 < 2 ^ 64)
    (hf0 : Fits S.mem (P0.add 32#64) 64) (hf1 : Fits S.mem (P1.add 32#64) 64)
    (ha : S.mem.readAt (P0.add 32#64) 64 = x) (hb : S.mem.readAt (P1.add 32#64) 64 = y)
    (hK : ∀ E' : ⟪Γ⟫, Writes E E' 407 413 →
      E' ⊨ [rir_reg% hty 412 := Ty.wrap (wl x y 0#64 0#64)] →
      (bb0.runBodyFrom E' 417 S >>= g) = K) :
    (bb0.runBodyFrom E 411 S >>= g) = K := by
  step_pure
  step_load
  step_pure
  step_load
  step_pure [insert_y_eq]
  step_pure [insert_y_eq]
  subst hS
  exact hK E (by rw [hE]; writes_chain) (by lemma_reads)

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `385` to `417`: both encodings' limbs into `Y`. -/
theorem ys_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (sA sB : BitVec 256)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 139 := PoisonOr.value (B.slot 0), rir_reg% hty 140 := PoisonOr.value (B.slot 1), rir_reg% hty 59 := 0#64,
        rir_reg% hty 55 := 1#64, rir_reg% hty 66 := yUndef])
    (hI : Inv B M c S) (hsa : Fits S.mem ea 256) (hsb : Fits S.mem eb 256)
    (hsA : S.mem.readAt ea 256 = sA) (hsB : S.mem.readAt eb 256 = sB)
    (hsa_off : ea.offset.toNat + 32 < 2 ^ 64) (hsb_off : eb.offset.toNat + 32 < 2 ^ 64)
    (hsa_lt : ea.id.id < B.alloc.nextFreeBlock) (hsb_lt : eb.id.id < B.alloc.nextFreeBlock)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf a ea b eb).get →
          Writes Ein E' 385 413 →
          (E' ⊨ [rir_reg% hty 388 := Ty.wrap (yQ sA sB).P0, rir_reg% hty 394 := Ty.wrap (yQ sA sB).P1,
            rir_reg% hty 400 := Ty.wrap (yQ sA sB).P2, rir_reg% hty 406 := Ty.wrap (yQ sA sB).P3,
            rir_reg% hty 412 := Ty.wrap (yQ sA sB).P4]) →
          Inv B M c S' → (bb0.runBodyFrom E' 417 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 385 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  obtain ⟨i0, w0⟩ := hF.limbs 0
  obtain ⟨i1, w1⟩ := hF.limbs 1
  have hne0 := ne_slot (j := 0) hsa_lt
  have hne1 := ne_slot (j := 1) hsa_lt
  have hne0' := ne_slot (j := 0) hsb_lt
  have hne1' := ne_slot (j := 1) hsb_lt
  have h01 : (B.slot 0).id ≠ (B.slot 1).id := by simp [GlobalState.slot]
  step_pure
  step_pure
  have r0 := MemoryState.LimbsRoom.of_room hroom rfl
  have r1 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 1) 320› rfl
  step_call using fd_r52x5_limbs_frombytes.call_eq consuming r0
  step_call using fd_r52x5_limbs_frombytes.call_eq consuming r1
  have ⟨a0, a1, a2, a3, a4⟩ : S.mem.readAt (B.slot 0) 64 = fd_r52x5_limbs_frombytes.spec sA 0 ∧
      S.mem.readAt ((B.slot 0).add 8#64) 64 = fd_r52x5_limbs_frombytes.spec sA 1 ∧
      S.mem.readAt ((B.slot 0).add 16#64) 64 = fd_r52x5_limbs_frombytes.spec sA 2 ∧
      S.mem.readAt ((B.slot 0).add 24#64) 64 = fd_r52x5_limbs_frombytes.spec sA 3 ∧
      S.mem.readAt ((B.slot 0).add 32#64) 64 = fd_r52x5_limbs_frombytes.spec sA 4 := by
    rw [← ‹S.mem.readLimbs (B.slot 0) = fd_r52x5_limbs_frombytes.spec sA›]
    exact ⟨rfl, rfl, rfl, rfl, rfl⟩
  have ⟨b0, b1, b2, b3, b4⟩ : S.mem.readAt (B.slot 1) 64 = fd_r52x5_limbs_frombytes.spec sB 0 ∧
      S.mem.readAt ((B.slot 1).add 8#64) 64 = fd_r52x5_limbs_frombytes.spec sB 1 ∧
      S.mem.readAt ((B.slot 1).add 16#64) 64 = fd_r52x5_limbs_frombytes.spec sB 2 ∧
      S.mem.readAt ((B.slot 1).add 24#64) 64 = fd_r52x5_limbs_frombytes.spec sB 3 ∧
      S.mem.readAt ((B.slot 1).add 32#64) 64 = fd_r52x5_limbs_frombytes.spec sB 4 := by
    rw [← ‹S.mem.readLimbs (B.slot 1) = fd_r52x5_limbs_frombytes.spec sB›]
    exact ⟨rfl, rfl, rfl, rfl, rfl⟩
  step_load
  step_load
  step_pure [insert_y_eq]
  step_pure [insert_y_eq]
  have hR0 : E ⊨ [rir_reg% hty 139 := PoisonOr.value (B.slot 0),
      rir_reg% hty 140 := PoisonOr.value (B.slot 1), rir_reg% hty 59 := PoisonOr.value 0#64,
      rir_reg% hty 55 := PoisonOr.value 1#64, rir_reg% hty 66 := yUndef] := by
    rw [hE]; lemma_reads
  have hW0 : Writes Ein E 385 413 := by rw [hE]; writes_chain
  have hY0 : E ⊨ [rir_reg% hty 388 := Ty.wrap (yQ sA sB).P0] := by rw [hE]; lemma_reads
  obtain ⟨o0, f00, f01, f02, f03, f04⟩ := r0
  obtain ⟨o1, f10, f11, f12, f13, f14⟩ := r1
  clear hE
  refine ys_round1 hR0 o0 o1 f01 f11 a1 b1 fun E1 hW1 hY1 => ?_
  refine ys_round2 (by chain_reads) o0 o1 f02 f12 a2 b2 fun E2 hW2 hY2 => ?_
  refine ys_round3 (by chain_reads) o0 o1 f03 f13 a3 b3 fun E3 hW3 hY3 => ?_
  refine ys_round4 (by chain_reads) o0 o1 f04 f14 a4 b4 fun E4 hW4 hY4 => ?_
  have hW : Writes Ein E4 385 413 :=
    hW0.trans ((hW1.mono).trans ((hW2.mono).trans ((hW3.mono).trans hW4.mono)))
  refine hK E4 S (hW.1.trans (hW0.1.symm.trans hArgs)) hW ?_ ⟨hwf, hF, ?_, ?_⟩
  · chain_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_storeLimbs_slot, eraseFrom_lifetimeStart_slot]
    exact herase
  · rw [hS]
    exact halloc

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `417` to `481`. -/
theorem bb0g0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1091 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 388 := Ty.wrap Q1091.P0,
      rir_reg% hty 394 := Ty.wrap Q1091.P1,
      rir_reg% hty 400 := Ty.wrap Q1091.P2,
      rir_reg% hty 406 := Ty.wrap Q1091.P3,
      rir_reg% hty 412 := Ty.wrap Q1091.P4,
      rir_reg% hty 141 := PoisonOr.value (B.slot 2),
      rir_reg% hty 142 := PoisonOr.value (B.slot 3),
      rir_reg% hty 143 := PoisonOr.value (B.slot 4),
      rir_reg% hty 144 := PoisonOr.value (B.slot 5),
      rir_reg% hty 145 := PoisonOr.value (B.slot 6),
      rir_reg% hty 54 := Ty.wrap (Vector.replicate 4 1#64 : Wl),
      rir_reg% hty 53 := Ty.wrap (Vector.replicate 4 0#64 : Wl),
      rir_reg% hty 146 := PoisonOr.value (B.slot 7),
      rir_reg% hty 147 := PoisonOr.value (B.slot 8),
      rir_reg% hty 148 := PoisonOr.value (B.slot 9),
      rir_reg% hty 149 := PoisonOr.value (B.slot 10),
      rir_reg% hty 150 := PoisonOr.value (B.slot 11),
      rir_reg% hty 52 := Ty.wrap (Vector.replicate 4 929955233495203#64 : Wl),
      rir_reg% hty 51 := Ty.wrap (Vector.replicate 4 466365720129213#64 : Wl),
      rir_reg% hty 50 := Ty.wrap (Vector.replicate 4 1662059464998953#64 : Wl),
      rir_reg% hty 49 := Ty.wrap (Vector.replicate 4 2033849074728123#64 : Wl),
      rir_reg% hty 48 := Ty.wrap (Vector.replicate 4 1442794654840575#64 : Wl),
      rir_reg% hty 151 := PoisonOr.value (B.slot 12),
      rir_reg% hty 152 := PoisonOr.value (B.slot 13),
      rir_reg% hty 153 := PoisonOr.value (B.slot 14),
      rir_reg% hty 154 := PoisonOr.value (B.slot 15),
      rir_reg% hty 155 := PoisonOr.value (B.slot 16),
      rir_reg% hty 156 := PoisonOr.value (B.slot 17),
      rir_reg% hty 157 := PoisonOr.value (B.slot 18),
      rir_reg% hty 158 := PoisonOr.value (B.slot 19),
      rir_reg% hty 159 := PoisonOr.value (B.slot 20),
      rir_reg% hty 160 := PoisonOr.value (B.slot 21)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 413 433 →
      (E' ⊨ [rir_reg% hty 413 := Ty.wrap (sqrQ Q1091).P0,
        rir_reg% hty 414 := Ty.wrap (sqrQ Q1091).P1,
        rir_reg% hty 415 := Ty.wrap (sqrQ Q1091).P2,
        rir_reg% hty 416 := Ty.wrap (sqrQ Q1091).P3,
        rir_reg% hty 417 := Ty.wrap (sqrQ Q1091).P4,
        rir_reg% hty 418 := Ty.wrap (fd_r52x5_quad_sub.spec (sqrQ Q1091) oneQ).P0,
        rir_reg% hty 419 := Ty.wrap (fd_r52x5_quad_sub.spec (sqrQ Q1091) oneQ).P1,
        rir_reg% hty 420 := Ty.wrap (fd_r52x5_quad_sub.spec (sqrQ Q1091) oneQ).P2,
        rir_reg% hty 421 := Ty.wrap (fd_r52x5_quad_sub.spec (sqrQ Q1091) oneQ).P3,
        rir_reg% hty 422 := Ty.wrap (fd_r52x5_quad_sub.spec (sqrQ Q1091) oneQ).P4,
        rir_reg% hty 423 := Ty.wrap (mulQ (sqrQ Q1091) dQ).P0,
        rir_reg% hty 424 := Ty.wrap (mulQ (sqrQ Q1091) dQ).P1,
        rir_reg% hty 425 := Ty.wrap (mulQ (sqrQ Q1091) dQ).P2,
        rir_reg% hty 426 := Ty.wrap (mulQ (sqrQ Q1091) dQ).P3,
        rir_reg% hty 427 := Ty.wrap (mulQ (sqrQ Q1091) dQ).P4,
        rir_reg% hty 428 := Ty.wrap (fd_r52x5_quad_add.spec (mulQ (sqrQ Q1091) dQ) oneQ).P0,
        rir_reg% hty 429 := Ty.wrap (fd_r52x5_quad_add.spec (mulQ (sqrQ Q1091) dQ) oneQ).P1,
        rir_reg% hty 430 := Ty.wrap (fd_r52x5_quad_add.spec (mulQ (sqrQ Q1091) dQ) oneQ).P2,
        rir_reg% hty 431 := Ty.wrap (fd_r52x5_quad_add.spec (mulQ (sqrQ Q1091) dQ) oneQ).P3,
        rir_reg% hty 432 := Ty.wrap (fd_r52x5_quad_add.spec (mulQ (sqrQ Q1091) dQ) oneQ).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 481 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 417 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sub.call_eq) (Y := oneQ) with Q1
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) (Y := dQ) with Q2
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_add.call_eq) (Y := oneQ) with Q3
  subst hv417 hv422 hv427 hv432 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `481` to `545`. -/
theorem bb0g1_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1131 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 428 := Ty.wrap Q1131.P0,
      rir_reg% hty 429 := Ty.wrap Q1131.P1,
      rir_reg% hty 430 := Ty.wrap Q1131.P2,
      rir_reg% hty 431 := Ty.wrap Q1131.P3,
      rir_reg% hty 432 := Ty.wrap Q1131.P4,
      rir_reg% hty 161 := PoisonOr.value (B.slot 22),
      rir_reg% hty 162 := PoisonOr.value (B.slot 23),
      rir_reg% hty 163 := PoisonOr.value (B.slot 24),
      rir_reg% hty 164 := PoisonOr.value (B.slot 25),
      rir_reg% hty 165 := PoisonOr.value (B.slot 26),
      rir_reg% hty 166 := PoisonOr.value (B.slot 27),
      rir_reg% hty 167 := PoisonOr.value (B.slot 28),
      rir_reg% hty 168 := PoisonOr.value (B.slot 29),
      rir_reg% hty 169 := PoisonOr.value (B.slot 30),
      rir_reg% hty 170 := PoisonOr.value (B.slot 31),
      rir_reg% hty 171 := PoisonOr.value (B.slot 32),
      rir_reg% hty 172 := PoisonOr.value (B.slot 33),
      rir_reg% hty 173 := PoisonOr.value (B.slot 34),
      rir_reg% hty 174 := PoisonOr.value (B.slot 35),
      rir_reg% hty 175 := PoisonOr.value (B.slot 36),
      rir_reg% hty 176 := PoisonOr.value (B.slot 37),
      rir_reg% hty 177 := PoisonOr.value (B.slot 38),
      rir_reg% hty 178 := PoisonOr.value (B.slot 39),
      rir_reg% hty 179 := PoisonOr.value (B.slot 40),
      rir_reg% hty 180 := PoisonOr.value (B.slot 41)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 433 453 →
      (E' ⊨ [rir_reg% hty 433 := Ty.wrap (sqrQ Q1131).P0,
        rir_reg% hty 434 := Ty.wrap (sqrQ Q1131).P1,
        rir_reg% hty 435 := Ty.wrap (sqrQ Q1131).P2,
        rir_reg% hty 436 := Ty.wrap (sqrQ Q1131).P3,
        rir_reg% hty 437 := Ty.wrap (sqrQ Q1131).P4,
        rir_reg% hty 438 := Ty.wrap (mulQ (sqrQ Q1131) Q1131).P0,
        rir_reg% hty 439 := Ty.wrap (mulQ (sqrQ Q1131) Q1131).P1,
        rir_reg% hty 440 := Ty.wrap (mulQ (sqrQ Q1131) Q1131).P2,
        rir_reg% hty 441 := Ty.wrap (mulQ (sqrQ Q1131) Q1131).P3,
        rir_reg% hty 442 := Ty.wrap (mulQ (sqrQ Q1131) Q1131).P4,
        rir_reg% hty 443 := Ty.wrap (sqrQ (mulQ (sqrQ Q1131) Q1131)).P0,
        rir_reg% hty 444 := Ty.wrap (sqrQ (mulQ (sqrQ Q1131) Q1131)).P1,
        rir_reg% hty 445 := Ty.wrap (sqrQ (mulQ (sqrQ Q1131) Q1131)).P2,
        rir_reg% hty 446 := Ty.wrap (sqrQ (mulQ (sqrQ Q1131) Q1131)).P3,
        rir_reg% hty 447 := Ty.wrap (sqrQ (mulQ (sqrQ Q1131) Q1131)).P4,
        rir_reg% hty 448 := Ty.wrap (mulQ (sqrQ (mulQ (sqrQ Q1131) Q1131)) Q1131).P0,
        rir_reg% hty 449 := Ty.wrap (mulQ (sqrQ (mulQ (sqrQ Q1131) Q1131)) Q1131).P1,
        rir_reg% hty 450 := Ty.wrap (mulQ (sqrQ (mulQ (sqrQ Q1131) Q1131)) Q1131).P2,
        rir_reg% hty 451 := Ty.wrap (mulQ (sqrQ (mulQ (sqrQ Q1131) Q1131)) Q1131).P3,
        rir_reg% hty 452 := Ty.wrap (mulQ (sqrQ (mulQ (sqrQ Q1131) Q1131)) Q1131).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 545 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 481 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q3
  subst hv437 hv442 hv447 hv452 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `545` to `609`. -/
theorem bb0g2_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1121 Q1151 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 418 := Ty.wrap Q1121.P0,
      rir_reg% hty 419 := Ty.wrap Q1121.P1,
      rir_reg% hty 420 := Ty.wrap Q1121.P2,
      rir_reg% hty 421 := Ty.wrap Q1121.P3,
      rir_reg% hty 422 := Ty.wrap Q1121.P4,
      rir_reg% hty 448 := Ty.wrap Q1151.P0,
      rir_reg% hty 449 := Ty.wrap Q1151.P1,
      rir_reg% hty 450 := Ty.wrap Q1151.P2,
      rir_reg% hty 451 := Ty.wrap Q1151.P3,
      rir_reg% hty 452 := Ty.wrap Q1151.P4,
      rir_reg% hty 181 := PoisonOr.value (B.slot 42),
      rir_reg% hty 182 := PoisonOr.value (B.slot 43),
      rir_reg% hty 183 := PoisonOr.value (B.slot 44),
      rir_reg% hty 184 := PoisonOr.value (B.slot 45),
      rir_reg% hty 185 := PoisonOr.value (B.slot 46),
      rir_reg% hty 186 := PoisonOr.value (B.slot 47),
      rir_reg% hty 187 := PoisonOr.value (B.slot 48),
      rir_reg% hty 188 := PoisonOr.value (B.slot 49),
      rir_reg% hty 189 := PoisonOr.value (B.slot 50),
      rir_reg% hty 190 := PoisonOr.value (B.slot 51),
      rir_reg% hty 191 := PoisonOr.value (B.slot 52),
      rir_reg% hty 192 := PoisonOr.value (B.slot 53),
      rir_reg% hty 193 := PoisonOr.value (B.slot 54),
      rir_reg% hty 194 := PoisonOr.value (B.slot 55),
      rir_reg% hty 195 := PoisonOr.value (B.slot 56),
      rir_reg% hty 196 := PoisonOr.value (B.slot 57),
      rir_reg% hty 197 := PoisonOr.value (B.slot 58),
      rir_reg% hty 198 := PoisonOr.value (B.slot 59),
      rir_reg% hty 199 := PoisonOr.value (B.slot 60),
      rir_reg% hty 200 := PoisonOr.value (B.slot 61)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 453 473 →
      (E' ⊨ [rir_reg% hty 453 := Ty.wrap (mulQ Q1121 Q1151).P0,
        rir_reg% hty 454 := Ty.wrap (mulQ Q1121 Q1151).P1,
        rir_reg% hty 455 := Ty.wrap (mulQ Q1121 Q1151).P2,
        rir_reg% hty 456 := Ty.wrap (mulQ Q1121 Q1151).P3,
        rir_reg% hty 457 := Ty.wrap (mulQ Q1121 Q1151).P4,
        rir_reg% hty 458 := Ty.wrap (sqrQ (mulQ Q1121 Q1151)).P0,
        rir_reg% hty 459 := Ty.wrap (sqrQ (mulQ Q1121 Q1151)).P1,
        rir_reg% hty 460 := Ty.wrap (sqrQ (mulQ Q1121 Q1151)).P2,
        rir_reg% hty 461 := Ty.wrap (sqrQ (mulQ Q1121 Q1151)).P3,
        rir_reg% hty 462 := Ty.wrap (sqrQ (mulQ Q1121 Q1151)).P4,
        rir_reg% hty 463 := Ty.wrap (sqrQ (sqrQ (mulQ Q1121 Q1151))).P0,
        rir_reg% hty 464 := Ty.wrap (sqrQ (sqrQ (mulQ Q1121 Q1151))).P1,
        rir_reg% hty 465 := Ty.wrap (sqrQ (sqrQ (mulQ Q1121 Q1151))).P2,
        rir_reg% hty 466 := Ty.wrap (sqrQ (sqrQ (mulQ Q1121 Q1151))).P3,
        rir_reg% hty 467 := Ty.wrap (sqrQ (sqrQ (mulQ Q1121 Q1151))).P4,
        rir_reg% hty 468 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1121 Q1151)))).P0,
        rir_reg% hty 469 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1121 Q1151)))).P1,
        rir_reg% hty 470 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1121 Q1151)))).P2,
        rir_reg% hty 471 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1121 Q1151)))).P3,
        rir_reg% hty 472 := Ty.wrap (sqrQ (sqrQ (sqrQ (mulQ Q1121 Q1151)))).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 609 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 545 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q3
  subst hv457 hv462 hv467 hv472 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `609` to `673`. -/
theorem bb0g3_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1156 Q1171 Q1161 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 453 := Ty.wrap Q1156.P0,
      rir_reg% hty 454 := Ty.wrap Q1156.P1,
      rir_reg% hty 455 := Ty.wrap Q1156.P2,
      rir_reg% hty 456 := Ty.wrap Q1156.P3,
      rir_reg% hty 457 := Ty.wrap Q1156.P4,
      rir_reg% hty 468 := Ty.wrap Q1171.P0,
      rir_reg% hty 469 := Ty.wrap Q1171.P1,
      rir_reg% hty 470 := Ty.wrap Q1171.P2,
      rir_reg% hty 471 := Ty.wrap Q1171.P3,
      rir_reg% hty 472 := Ty.wrap Q1171.P4,
      rir_reg% hty 201 := PoisonOr.value (B.slot 62),
      rir_reg% hty 202 := PoisonOr.value (B.slot 63),
      rir_reg% hty 203 := PoisonOr.value (B.slot 64),
      rir_reg% hty 204 := PoisonOr.value (B.slot 65),
      rir_reg% hty 205 := PoisonOr.value (B.slot 66),
      rir_reg% hty 458 := Ty.wrap Q1161.P0,
      rir_reg% hty 459 := Ty.wrap Q1161.P1,
      rir_reg% hty 460 := Ty.wrap Q1161.P2,
      rir_reg% hty 461 := Ty.wrap Q1161.P3,
      rir_reg% hty 462 := Ty.wrap Q1161.P4,
      rir_reg% hty 206 := PoisonOr.value (B.slot 67),
      rir_reg% hty 207 := PoisonOr.value (B.slot 68),
      rir_reg% hty 208 := PoisonOr.value (B.slot 69),
      rir_reg% hty 209 := PoisonOr.value (B.slot 70),
      rir_reg% hty 210 := PoisonOr.value (B.slot 71),
      rir_reg% hty 211 := PoisonOr.value (B.slot 72),
      rir_reg% hty 212 := PoisonOr.value (B.slot 73),
      rir_reg% hty 213 := PoisonOr.value (B.slot 74),
      rir_reg% hty 214 := PoisonOr.value (B.slot 75),
      rir_reg% hty 215 := PoisonOr.value (B.slot 76),
      rir_reg% hty 216 := PoisonOr.value (B.slot 77),
      rir_reg% hty 217 := PoisonOr.value (B.slot 78),
      rir_reg% hty 218 := PoisonOr.value (B.slot 79),
      rir_reg% hty 219 := PoisonOr.value (B.slot 80),
      rir_reg% hty 220 := PoisonOr.value (B.slot 81)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 473 493 →
      (E' ⊨ [rir_reg% hty 473 := Ty.wrap (mulQ Q1156 Q1171).P0,
        rir_reg% hty 474 := Ty.wrap (mulQ Q1156 Q1171).P1,
        rir_reg% hty 475 := Ty.wrap (mulQ Q1156 Q1171).P2,
        rir_reg% hty 476 := Ty.wrap (mulQ Q1156 Q1171).P3,
        rir_reg% hty 477 := Ty.wrap (mulQ Q1156 Q1171).P4,
        rir_reg% hty 478 := Ty.wrap (mulQ Q1161 (mulQ Q1156 Q1171)).P0,
        rir_reg% hty 479 := Ty.wrap (mulQ Q1161 (mulQ Q1156 Q1171)).P1,
        rir_reg% hty 480 := Ty.wrap (mulQ Q1161 (mulQ Q1156 Q1171)).P2,
        rir_reg% hty 481 := Ty.wrap (mulQ Q1161 (mulQ Q1156 Q1171)).P3,
        rir_reg% hty 482 := Ty.wrap (mulQ Q1161 (mulQ Q1156 Q1171)).P4,
        rir_reg% hty 483 := Ty.wrap (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171))).P0,
        rir_reg% hty 484 := Ty.wrap (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171))).P1,
        rir_reg% hty 485 := Ty.wrap (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171))).P2,
        rir_reg% hty 486 := Ty.wrap (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171))).P3,
        rir_reg% hty 487 := Ty.wrap (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171))).P4,
        rir_reg% hty 488 := Ty.wrap (mulQ (mulQ Q1156 Q1171) (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171)))).P0,
        rir_reg% hty 489 := Ty.wrap (mulQ (mulQ Q1156 Q1171) (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171)))).P1,
        rir_reg% hty 490 := Ty.wrap (mulQ (mulQ Q1156 Q1171) (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171)))).P2,
        rir_reg% hty 491 := Ty.wrap (mulQ (mulQ Q1156 Q1171) (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171)))).P3,
        rir_reg% hty 492 := Ty.wrap (mulQ (mulQ Q1156 Q1171) (sqrQ (mulQ Q1161 (mulQ Q1156 Q1171)))).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 673 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 609 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q3
  subst hv477 hv482 hv487 hv492 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `673` to `737`. -/
theorem bb0g4_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1191 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 488 := Ty.wrap Q1191.P0,
      rir_reg% hty 489 := Ty.wrap Q1191.P1,
      rir_reg% hty 490 := Ty.wrap Q1191.P2,
      rir_reg% hty 491 := Ty.wrap Q1191.P3,
      rir_reg% hty 492 := Ty.wrap Q1191.P4,
      rir_reg% hty 221 := PoisonOr.value (B.slot 82),
      rir_reg% hty 222 := PoisonOr.value (B.slot 83),
      rir_reg% hty 223 := PoisonOr.value (B.slot 84),
      rir_reg% hty 224 := PoisonOr.value (B.slot 85),
      rir_reg% hty 225 := PoisonOr.value (B.slot 86),
      rir_reg% hty 226 := PoisonOr.value (B.slot 87),
      rir_reg% hty 227 := PoisonOr.value (B.slot 88),
      rir_reg% hty 228 := PoisonOr.value (B.slot 89),
      rir_reg% hty 229 := PoisonOr.value (B.slot 90),
      rir_reg% hty 230 := PoisonOr.value (B.slot 91)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 493 513 →
      (E' ⊨ [rir_reg% hty 493 := Ty.wrap (sqrQ Q1191).P0,
        rir_reg% hty 494 := Ty.wrap (sqrQ Q1191).P1,
        rir_reg% hty 495 := Ty.wrap (sqrQ Q1191).P2,
        rir_reg% hty 496 := Ty.wrap (sqrQ Q1191).P3,
        rir_reg% hty 497 := Ty.wrap (sqrQ Q1191).P4,
        rir_reg% hty 498 := Ty.wrap (sqrQ (sqrQ Q1191)).P0,
        rir_reg% hty 499 := Ty.wrap (sqrQ (sqrQ Q1191)).P1,
        rir_reg% hty 500 := Ty.wrap (sqrQ (sqrQ Q1191)).P2,
        rir_reg% hty 501 := Ty.wrap (sqrQ (sqrQ Q1191)).P3,
        rir_reg% hty 502 := Ty.wrap (sqrQ (sqrQ Q1191)).P4,
        rir_reg% hty 503 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1191))).P0,
        rir_reg% hty 504 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1191))).P1,
        rir_reg% hty 505 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1191))).P2,
        rir_reg% hty 506 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1191))).P3,
        rir_reg% hty 507 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1191))).P4,
        rir_reg% hty 508 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1191)))).P0,
        rir_reg% hty 509 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1191)))).P1,
        rir_reg% hty 510 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1191)))).P2,
        rir_reg% hty 511 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1191)))).P3,
        rir_reg% hty 512 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1191)))).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 737 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 673 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q3
  subst hv497 hv502 hv507 hv512 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `737` to `801`. -/
theorem bb0g5_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1211 Q1191 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 508 := Ty.wrap Q1211.P0,
      rir_reg% hty 509 := Ty.wrap Q1211.P1,
      rir_reg% hty 510 := Ty.wrap Q1211.P2,
      rir_reg% hty 511 := Ty.wrap Q1211.P3,
      rir_reg% hty 512 := Ty.wrap Q1211.P4,
      rir_reg% hty 226 := PoisonOr.value (B.slot 87),
      rir_reg% hty 227 := PoisonOr.value (B.slot 88),
      rir_reg% hty 228 := PoisonOr.value (B.slot 89),
      rir_reg% hty 229 := PoisonOr.value (B.slot 90),
      rir_reg% hty 230 := PoisonOr.value (B.slot 91),
      rir_reg% hty 488 := Ty.wrap Q1191.P0,
      rir_reg% hty 489 := Ty.wrap Q1191.P1,
      rir_reg% hty 490 := Ty.wrap Q1191.P2,
      rir_reg% hty 491 := Ty.wrap Q1191.P3,
      rir_reg% hty 492 := Ty.wrap Q1191.P4,
      rir_reg% hty 231 := PoisonOr.value (B.slot 92),
      rir_reg% hty 232 := PoisonOr.value (B.slot 93),
      rir_reg% hty 233 := PoisonOr.value (B.slot 94),
      rir_reg% hty 234 := PoisonOr.value (B.slot 95),
      rir_reg% hty 235 := PoisonOr.value (B.slot 96),
      rir_reg% hty 236 := PoisonOr.value (B.slot 97),
      rir_reg% hty 237 := PoisonOr.value (B.slot 98),
      rir_reg% hty 238 := PoisonOr.value (B.slot 99),
      rir_reg% hty 239 := PoisonOr.value (B.slot 100),
      rir_reg% hty 240 := PoisonOr.value (B.slot 101),
      rir_reg% hty 241 := PoisonOr.value (B.slot 102),
      rir_reg% hty 242 := PoisonOr.value (B.slot 103),
      rir_reg% hty 243 := PoisonOr.value (B.slot 104),
      rir_reg% hty 244 := PoisonOr.value (B.slot 105),
      rir_reg% hty 245 := PoisonOr.value (B.slot 106)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 513 533 →
      (E' ⊨ [rir_reg% hty 513 := Ty.wrap (sqrQ Q1211).P0,
        rir_reg% hty 514 := Ty.wrap (sqrQ Q1211).P1,
        rir_reg% hty 515 := Ty.wrap (sqrQ Q1211).P2,
        rir_reg% hty 516 := Ty.wrap (sqrQ Q1211).P3,
        rir_reg% hty 517 := Ty.wrap (sqrQ Q1211).P4,
        rir_reg% hty 518 := Ty.wrap (mulQ (sqrQ Q1211) Q1191).P0,
        rir_reg% hty 519 := Ty.wrap (mulQ (sqrQ Q1211) Q1191).P1,
        rir_reg% hty 520 := Ty.wrap (mulQ (sqrQ Q1211) Q1191).P2,
        rir_reg% hty 521 := Ty.wrap (mulQ (sqrQ Q1211) Q1191).P3,
        rir_reg% hty 522 := Ty.wrap (mulQ (sqrQ Q1211) Q1191).P4,
        rir_reg% hty 523 := Ty.wrap (sqrQ (mulQ (sqrQ Q1211) Q1191)).P0,
        rir_reg% hty 524 := Ty.wrap (sqrQ (mulQ (sqrQ Q1211) Q1191)).P1,
        rir_reg% hty 525 := Ty.wrap (sqrQ (mulQ (sqrQ Q1211) Q1191)).P2,
        rir_reg% hty 526 := Ty.wrap (sqrQ (mulQ (sqrQ Q1211) Q1191)).P3,
        rir_reg% hty 527 := Ty.wrap (sqrQ (mulQ (sqrQ Q1211) Q1191)).P4,
        rir_reg% hty 528 := Ty.wrap (sqrQ (sqrQ (mulQ (sqrQ Q1211) Q1191))).P0,
        rir_reg% hty 529 := Ty.wrap (sqrQ (sqrQ (mulQ (sqrQ Q1211) Q1191))).P1,
        rir_reg% hty 530 := Ty.wrap (sqrQ (sqrQ (mulQ (sqrQ Q1211) Q1191))).P2,
        rir_reg% hty 531 := Ty.wrap (sqrQ (sqrQ (mulQ (sqrQ Q1211) Q1191))).P3,
        rir_reg% hty 532 := Ty.wrap (sqrQ (sqrQ (mulQ (sqrQ Q1211) Q1191))).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 801 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 737 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q3
  subst hv517 hv522 hv527 hv532 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `801` to `865`. -/
theorem bb0g6_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1231 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 528 := Ty.wrap Q1231.P0,
      rir_reg% hty 529 := Ty.wrap Q1231.P1,
      rir_reg% hty 530 := Ty.wrap Q1231.P2,
      rir_reg% hty 531 := Ty.wrap Q1231.P3,
      rir_reg% hty 532 := Ty.wrap Q1231.P4,
      rir_reg% hty 241 := PoisonOr.value (B.slot 102),
      rir_reg% hty 242 := PoisonOr.value (B.slot 103),
      rir_reg% hty 243 := PoisonOr.value (B.slot 104),
      rir_reg% hty 244 := PoisonOr.value (B.slot 105),
      rir_reg% hty 245 := PoisonOr.value (B.slot 106)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 533 553 →
      (E' ⊨ [rir_reg% hty 533 := Ty.wrap (sqrQ Q1231).P0,
        rir_reg% hty 534 := Ty.wrap (sqrQ Q1231).P1,
        rir_reg% hty 535 := Ty.wrap (sqrQ Q1231).P2,
        rir_reg% hty 536 := Ty.wrap (sqrQ Q1231).P3,
        rir_reg% hty 537 := Ty.wrap (sqrQ Q1231).P4,
        rir_reg% hty 538 := Ty.wrap (sqrQ (sqrQ Q1231)).P0,
        rir_reg% hty 539 := Ty.wrap (sqrQ (sqrQ Q1231)).P1,
        rir_reg% hty 540 := Ty.wrap (sqrQ (sqrQ Q1231)).P2,
        rir_reg% hty 541 := Ty.wrap (sqrQ (sqrQ Q1231)).P3,
        rir_reg% hty 542 := Ty.wrap (sqrQ (sqrQ Q1231)).P4,
        rir_reg% hty 543 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1231))).P0,
        rir_reg% hty 544 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1231))).P1,
        rir_reg% hty 545 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1231))).P2,
        rir_reg% hty 546 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1231))).P3,
        rir_reg% hty 547 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1231))).P4,
        rir_reg% hty 548 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1231)))).P0,
        rir_reg% hty 549 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1231)))).P1,
        rir_reg% hty 550 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1231)))).P2,
        rir_reg% hty 551 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1231)))).P3,
        rir_reg% hty 552 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1231)))).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 865 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 801 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q3
  subst hv537 hv542 hv547 hv552 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `865` to `929`. -/
theorem bb0g7_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1251 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 548 := Ty.wrap Q1251.P0,
      rir_reg% hty 549 := Ty.wrap Q1251.P1,
      rir_reg% hty 550 := Ty.wrap Q1251.P2,
      rir_reg% hty 551 := Ty.wrap Q1251.P3,
      rir_reg% hty 552 := Ty.wrap Q1251.P4,
      rir_reg% hty 241 := PoisonOr.value (B.slot 102),
      rir_reg% hty 242 := PoisonOr.value (B.slot 103),
      rir_reg% hty 243 := PoisonOr.value (B.slot 104),
      rir_reg% hty 244 := PoisonOr.value (B.slot 105),
      rir_reg% hty 245 := PoisonOr.value (B.slot 106)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 553 573 →
      (E' ⊨ [rir_reg% hty 553 := Ty.wrap (sqrQ Q1251).P0,
        rir_reg% hty 554 := Ty.wrap (sqrQ Q1251).P1,
        rir_reg% hty 555 := Ty.wrap (sqrQ Q1251).P2,
        rir_reg% hty 556 := Ty.wrap (sqrQ Q1251).P3,
        rir_reg% hty 557 := Ty.wrap (sqrQ Q1251).P4,
        rir_reg% hty 558 := Ty.wrap (sqrQ (sqrQ Q1251)).P0,
        rir_reg% hty 559 := Ty.wrap (sqrQ (sqrQ Q1251)).P1,
        rir_reg% hty 560 := Ty.wrap (sqrQ (sqrQ Q1251)).P2,
        rir_reg% hty 561 := Ty.wrap (sqrQ (sqrQ Q1251)).P3,
        rir_reg% hty 562 := Ty.wrap (sqrQ (sqrQ Q1251)).P4,
        rir_reg% hty 563 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1251))).P0,
        rir_reg% hty 564 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1251))).P1,
        rir_reg% hty 565 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1251))).P2,
        rir_reg% hty 566 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1251))).P3,
        rir_reg% hty 567 := Ty.wrap (sqrQ (sqrQ (sqrQ Q1251))).P4,
        rir_reg% hty 568 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1251)))).P0,
        rir_reg% hty 569 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1251)))).P1,
        rir_reg% hty 570 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1251)))).P2,
        rir_reg% hty 571 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1251)))).P3,
        rir_reg% hty 572 := Ty.wrap (sqrQ (sqrQ (sqrQ (sqrQ Q1251)))).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 929 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 865 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q2
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q3
  subst hv557 hv562 hv567 hv572 hQ3 hQ2 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads

set_option maxHeartbeats 4000000 in
/-- `^bb0`'s sites `929` to `961`. -/
theorem bb0g8_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} {a ea b eb : Pointer}
    (Q1271 Q1221 : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 568 := Ty.wrap Q1271.P0,
      rir_reg% hty 569 := Ty.wrap Q1271.P1,
      rir_reg% hty 570 := Ty.wrap Q1271.P2,
      rir_reg% hty 571 := Ty.wrap Q1271.P3,
      rir_reg% hty 572 := Ty.wrap Q1271.P4,
      rir_reg% hty 518 := Ty.wrap Q1221.P0,
      rir_reg% hty 519 := Ty.wrap Q1221.P1,
      rir_reg% hty 520 := Ty.wrap Q1221.P2,
      rir_reg% hty 521 := Ty.wrap Q1221.P3,
      rir_reg% hty 522 := Ty.wrap Q1221.P4,
      rir_reg% hty 246 := PoisonOr.value (B.slot 107),
      rir_reg% hty 247 := PoisonOr.value (B.slot 108),
      rir_reg% hty 248 := PoisonOr.value (B.slot 109),
      rir_reg% hty 249 := PoisonOr.value (B.slot 110),
      rir_reg% hty 250 := PoisonOr.value (B.slot 111),
      rir_reg% hty 251 := PoisonOr.value (B.slot 112),
      rir_reg% hty 252 := PoisonOr.value (B.slot 113),
      rir_reg% hty 253 := PoisonOr.value (B.slot 114),
      rir_reg% hty 254 := PoisonOr.value (B.slot 115),
      rir_reg% hty 255 := PoisonOr.value (B.slot 116)])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 573 583 →
      (E' ⊨ [rir_reg% hty 573 := Ty.wrap (mulQ Q1271 Q1221).P0,
        rir_reg% hty 574 := Ty.wrap (mulQ Q1271 Q1221).P1,
        rir_reg% hty 575 := Ty.wrap (mulQ Q1271 Q1221).P2,
        rir_reg% hty 576 := Ty.wrap (mulQ Q1271 Q1221).P3,
        rir_reg% hty 577 := Ty.wrap (mulQ Q1271 Q1221).P4,
        rir_reg% hty 578 := Ty.wrap (sqrQ (mulQ Q1271 Q1221)).P0,
        rir_reg% hty 579 := Ty.wrap (sqrQ (mulQ Q1271 Q1221)).P1,
        rir_reg% hty 580 := Ty.wrap (sqrQ (mulQ Q1271 Q1221)).P2,
        rir_reg% hty 581 := Ty.wrap (sqrQ (mulQ Q1271 Q1221)).P3,
        rir_reg% hty 582 := Ty.wrap (sqrQ (mulQ Q1271 Q1221)).P4]) →
      Inv B M c S' → (bb0.runBodyFrom E' 961 S' >>= g) = K) :
    (bb0.runBodyFrom Ein 929 S >>= g) = K := by
  step_pattern' using runBodyFrom_leafRun2I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_mul.call_eq) with Q0
  step_pattern' using runBodyFrom_leafRun1I (hIw := Inv.slots) (hIc := Inv.callTmp5_slots) (hf := fd_r52x5_quad_sqr.call_eq) with Q1
  subst hv577 hv582 hQ1 hQ0
  refine hK E S hArgs ?_ ?_ ‹_›
  · rw [hE]
    writes_chain
  · lemma_reads


end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.Crc.Verify
