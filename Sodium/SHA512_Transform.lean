module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Sodium.Common.Memory
public import Sodium.rotr64
public import Sodium.be64dec_vect
public import Sodium.Common.Sha512Round
public import Sodium.Common.Counter
public import Firedancer.Ref.fd_sha512_append
public import Sodium.Mlir.SHA512_Transform
import Mathlib.Tactic.Rename
import Mathlib.Tactic.IntervalCases

namespace MLIR.Sodium

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

namespace SHA512_Transform

/-- `W[t]` for the block `block` (its bytes little-endian, as memory holds them): the message
schedule. -/
def W (block : BitVec 1024) (t : Nat) : BitVec 64 :=
  (Sha512.schedule (bytesLE block))[t]!

/-- The working variables `S` after rounds `0 … n - 1` from `state`. -/
def rounds (state : Vector (BitVec 64) 8) (block : BitVec 1024) (n : Nat) : Vector (BitVec 64) 8 :=
  (List.range n).foldl (fun v t => Sha512.round v Sha512.K[t]! (W block t)) state

/-- `tmp64` (`W[0 … 79]`, then `S[0 … 7]`) after a call: the schedule, the working variables after
the 80 rounds. -/
def tmp (state : Vector (BitVec 64) 8) (block : BitVec 1024) : BitVec 5632 :=
  wordsLE (fun i => (rounds state block 80)[i]!) 8 ++ wordsLE (W block) 80

end SHA512_Transform

/-- `state[i] += S[i]` after the 80 rounds: FIPS 180-4 compression of one block. -/
def SHA512_Transform.spec (state : Vector (BitVec 64) 8) (block : BitVec 1024) :
    Vector (BitVec 64) 8 :=
  Sha512.compress state (bytesLE block)

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- Round `t ≥ 1` of `^bb1` by `runBodyFrom_roundRun`, its new words named `a` and `e`, `S` kept
as the eight stored words. -/
local macro "round " t:num sw:term:max a:ident e:ident ld:ident lh:ident : tactic =>
  `(tactic|
    ( obtain ⟨hfw, hwt⟩ :=
        readW (t := 16 * j + $t) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
      obtain ⟨hfk, hkt⟩ :=
        readK (t := 16 * j + $t) (hw := hw) (congrArg GlobalState.mem hS) hKf hKo hKr ho hSpo htK
          hSK (by omega) (by omega)
      step_pattern using (runBodyFrom_roundRun (sw := $sw) (16 * j) $t)
      rename' A' => $a, E' => $e
      replace hv := rounds_step (n := 16 * j + $t) hv _hr
      rw [$ld:ident hSp56, $lh:ident hSp56] at hS
      clear _hr hfw hfk hkt))

namespace SHA512_Transform

/-- `Krnd[t]` read from the global's block. -/
theorem readAt_K {m : MemoryState} {Kp : Pointer} {hw : (Ty.array 80 (.bv 64)).width = 5120}
    (hf : Fits m Kp 5120) (ho : Kp.offset = 0)
    (h : m.readAt Kp 5120 = Ty.flatBits Krnd.lit (hw := hw)) {t : Nat} (ht : t < 80) :
    m.readAt (Kp.add (BitVec.ofNat 64 (8 * t))) 64 = Sha512.K[t]! := by
  have hs : (Ty.bv 64).stride = 64 := rfl
  have hK : Krnd.lit = Sha512.K := by decide
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      h,
    Ty.flatBits_eq, BitVec.extractLsb'_cast,
    show (BitVec.ofNat 64 (8 * t)).toNat * 8 = t * 64 by
      simp; omega,
    Ty.extractLsb'_flattenRaw_array _
      (by
        rw [hs]; omega)
      (by
        rw [hs, Nat.mul_mod_left]; decide)]
  simp only [hs, Nat.mul_mod_left, Nat.mul_div_cancel _ (by decide : 0 < 64),
    Ty.extractLsb'_flattenRaw_bv, hK, BitVec.extractLsb'_eq_self, getElem!_pos Sha512.K t ht]

/-- `W[t]` of an iteration's memory: the words at `tmp`, below the `S` slots. -/
theorem readW {m M0 : MemoryState} {tmp Sp : Pointer} {f : Nat → BitVec 64} {n t : Nat}
    {V : Vector (BitVec 64) 8} (hm : m = (M0.storeWords tmp f n).storeWords8 Sp V)
    (hR : Room M0 tmp 5120) (ho : tmp.offset.toNat + 640 < 2 ^ 64)
    (hSpo : Sp.offset.toNat + 64 < 2 ^ 64) (hWS : (Range.of tmp 5120).Disjoint (Range.of Sp 512))
    (hn : n ≤ 80) (ht : t < n) :
    Fits m (tmp.add (BitVec.ofNat 64 (8 * t))) 64 ∧
      m.readAt (tmp.add (BitVec.ofNat 64 (8 * t))) 64 = f t := by
  subst hm
  have hR' : Room M0 tmp (64 * n) := by
    obtain ⟨blk, hblk, hl, hsz⟩ := hR
    exact ⟨blk, hblk, hl, by omega⟩
  refine ⟨(Fits.storeWords_self hR' (by omega) ht).storeWords8, ?_⟩
  rw [MemoryState.readAt_storeWords8_of_disjoint (by omega),
    MemoryState.readAt_storeWords_self hR'.inBounds (by omega) ht]
  simp only [Range.Disjoint, Range.of, Pointer.add_id,
    Pointer.offsetInBits_word (n := 80) (by omega) (show t ≤ 80 by omega)] at hWS ⊢
  rcases hWS with h | h | h
  · exact .inl (Ne.symm h)
  · exact .inr (.inr (by omega))
  · exact .inr (.inl (by omega))

/-- `Krnd[t]` of an iteration's memory. -/
theorem readK {m M0 : MemoryState} {tmp Sp Kp : Pointer} {f : Nat → BitVec 64} {n t : Nat}
    {V : Vector (BitVec 64) 8} {hw : (Ty.array 80 (.bv 64)).width = 5120}
    (hm : m = (M0.storeWords tmp f n).storeWords8 Sp V) (hf : Fits M0 Kp 5120) (hKo : Kp.offset = 0)
    (hK : M0.readAt Kp 5120 = Ty.flatBits Krnd.lit (hw := hw))
    (ho : tmp.offset.toNat + 640 < 2 ^ 64) (hSpo : Sp.offset.toNat + 64 < 2 ^ 64)
    (htK : tmp.id ≠ Kp.id) (hSK : Sp.id ≠ Kp.id) (hn : n ≤ 80) (ht : t < 80) :
    Fits m (Kp.add (BitVec.ofNat 64 (8 * t))) 64 ∧
      m.readAt (Kp.add (BitVec.ofNat 64 (8 * t))) 64 = Sha512.K[t]! := by
  subst hm
  have hov : ¬Kp.offset.uaddOverflow (BitVec.ofNat 64 (8 * t)) := by
    simp [BitVec.uaddOverflow, hKo]; omega
  refine
    ⟨(Fits.add_of_le hov
          (by
            simp; omega)
          hf).storeWords.storeWords8,
      ?_⟩
  rw [MemoryState.readAt_storeWords8_of_disjoint (by omega)
      (Range.disjoint_of_id_ne
        (by
          rw [Pointer.add_id]; exact hSK)),
    MemoryState.readAt_storeWords_of_disjoint (by omega)
      (Range.disjoint_of_id_ne
        (by
          rw [Pointer.add_id]; exact htK)),
    readAt_K hf hKo hK ht]

theorem rounds_succ (H : Vector (BitVec 64) 8) (b : BitVec 1024) (n : Nat) :
    rounds H b (n + 1) = Sha512.round (rounds H b n) Sha512.K[n]! (W b n) := by
  simp only [rounds, List.range_succ, List.foldl_append, List.foldl_cons, List.foldl_nil]

/-- Round `n` after rounds `0 … n - 1`. -/
theorem rounds_step {H : Vector (BitVec 64) 8} {b : BitVec 1024} {n : Nat}
    {x y : Vector (BitVec 64) 8} (hv : rounds H b n = x)
    (hr : Sha512.round x Sha512.K[n]! (W b n) = y) : rounds H b (n + 1) = y := by
  rw [rounds_succ, hv, hr]

/-- The registers `^bb1` reads at `i = 16 j`: the constants, `Krnd`, the `S` slots, `i`. -/
abbrev Hdr1 (Sp Kp : Pointer) (i : Nat) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%408 := 64#64, %409 := 8#64, %410 := 16#64, %411 := 0#64, %412 := 14#32, %413 := 18#32,
    %414 := 41#32, %415 := Kp, %416 := 28#32, %417 := 34#32, %418 := 39#32, %419 := 1#64, %420 :=
    2#64, %421 := 3#64, %422 := 4#64, %423 := 5#64, %424 := 6#64, %425 := 7#64, %426 := 9#64,
    %427 := 10#64, %428 := 11#64, %429 := 12#64, %430 := 13#64, %431 := 14#64, %432 := 15#64,
    %433 := 19#32, %434 := 61#32, %435 := 1#32, %436 := 8#32, %437 := Sp.add 32#64, %438 :=
    Sp.add 40#64, %439 := Sp.add 48#64, %440 := Sp.add 56#64, %441 := Sp.add 24#64, %442 :=
    Sp.add 8#64, %443 := Sp.add 16#64, %444 := BitVec.ofNat 64 i]

/-- The registers `^bb3` reads: the `S` slots. -/
abbrev Hdr3 (Sp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%437 := Sp.add 32#64, %438 := Sp.add 40#64, %439 := Sp.add 48#64, %440 := Sp.add 56#64,
    %441 := Sp.add 24#64, %442 := Sp.add 8#64, %443 := Sp.add 16#64]

/-- The pointers `^bb2` reads: `W[i]`, `W[i + 1]`, `W[i + 9] … W[i + 15]`. -/
abbrev Ptr2 (tmp : Pointer) (i : Nat) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%456 := tmp.add (BitVec.ofNat 64 (8 * i)), %490 := tmp.add (BitVec.ofNat 64 (8 * (i + 1))),
    %722 := tmp.add (BitVec.ofNat 64 (8 * (i + 9))), %751 :=
    tmp.add (BitVec.ofNat 64 (8 * (i + 10))), %780 := tmp.add (BitVec.ofNat 64 (8 * (i + 11))),
    %809 := tmp.add (BitVec.ofNat 64 (8 * (i + 12))), %838 :=
    tmp.add (BitVec.ofNat 64 (8 * (i + 13))), %867 := tmp.add (BitVec.ofNat 64 (8 * (i + 14))),
    %896 := tmp.add (BitVec.ofNat 64 (8 * (i + 15)))]

/-- The memory of iteration `j`: `W[0 … 16 j + 15]` at `tmp`, rounds `0 … 16 j - 1` in `S`. -/
abbrev iterMem (M0 : MemoryState) (tmp Sp : Pointer) (H : Vector (BitVec 64) 8) (b : BitVec 1024)
    (n r : Nat) : MemoryState :=
  (M0.storeWords tmp (W b) n).storeWords8 Sp (rounds H b r)

-- one pass of the 500-instruction ^bb1: 16 rounds in one block exceed the default
set_option maxHeartbeats 2000000 in
theorem bb1_run (state blkp tmp Sp Kp : Pointer) (H : Vector (BitVec 64) 8) (b : BitVec 1024)
    (M0 : MemoryState) {hw : (Ty.array 80 (.bv 64)).width = 5120} (j : Nat) (hj : j < 5)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value state) (.value blkp) (.value tmp) (.value Sp)).get)
    (hE1 : Hdr1 Sp Kp (16 * j) E) (hwf : S.WF)
    (hM : S.mem = iterMem M0 tmp Sp H b (16 + 16 * j) (16 * j)) (hR : Room M0 tmp 5120)
    (hSR : Room M0 Sp 512) (hSpov : ¬Sp.offset.uaddOverflow 64#64) (hKf : Fits M0 Kp 5120)
    (hKo : Kp.offset = 0) (hKr : M0.readAt Kp 5120 = Ty.flatBits Krnd.lit (hw := hw))
    (ho : tmp.offset.toNat + 640 < 2 ^ 64) (hSpo : Sp.offset.toNat + 64 < 2 ^ 64)
    (hWS : (Range.of tmp 5120).Disjoint (Range.of Sp 512)) (htK : tmp.id ≠ Kp.id)
    (hSK : Sp.id ≠ Kp.id)
    (hexit :
      j = 4 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value state) (.value blkp) (.value tmp) (.value Sp)).get →
            Hdr3 Sp E' →
            (E' ⊨ [rir_reg% hty 507 := (rounds H b 80)[0]]) →
            S' = { alloc := S.alloc, mem := iterMem M0 tmp Sp H b 80 80 } →
            S'.WF → (SHA512_Transform.runFrom E' 3 S' >>= g) = K)
    (hnext :
      j < 4 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value state) (.value blkp) (.value tmp) (.value Sp)).get →
            Hdr1 Sp Kp (16 * j) E' →
            Ptr2 tmp (16 * j) E' →
            S' = { alloc := S.alloc, mem := iterMem M0 tmp Sp H b (16 + 16 * j) (16 * j + 16) } →
            S'.WF → (SHA512_Transform.runFrom E' 2 S' >>= g) = K) :
    (SHA512_Transform.runFrom E 1 S >>= g) = K := by
  have hR' : Room S.mem Sp 512 := by
    rw [hM]; exact hSR.storeWords.storeWords8
  have hV :
    ∀ k (hk : k < 8),
      S.mem.readAt (Sp.add (BitVec.ofNat 64 (8 * k))) 64 = (rounds H b (16 * j))[k] :=
    fun k hk => by
    rw [hM]; exact readAt_storeWords8_lane hSR.inBounds.storeWords (by omega) _ hk
  have hSF : S.mem.Words8Fit Sp := by
    rw [hM]
    have := hSR.storeWords (p := tmp) (f := W b) (n := 16 + 16 * j)
    refine MemoryState.Words8Fit.storeWords8_self ⟨by omega, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
      first
      | exact this.mono (by decide)
      | exact Room.add_of_le (BitVec.not_uaddOverflow_of_le hSpov (by decide)) (by decide) this
  have hv0 : S.mem.readAt Sp 64 = (rounds H b (16 * j))[0] := by simpa using hV 0 (by decide)
  have hv1 := hV 1 (by decide)
  have hv2 := hV 2 (by decide)
  have hv3 := hV 3 (by decide)
  have hv4 := hV 4 (by decide)
  have hv5 := hV 5 (by decide)
  have hv6 := hV 6 (by decide)
  have hv7 := hV 7 (by decide)
  have h16 : 16 * j < 18446744073709551616 := by omega
  obtain ⟨hfw, hw0⟩ := readW (t := 16 * j) hM hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hfk, hk0⟩ :=
    readK (t := 16 * j) (hw := hw) hM hKf hKo hKr ho hSpo htK hSK (by omega) (by omega)
  clear hV
  block_init
  -- h += S1(e) + Ch(e, f, g) + W[i] + Krnd[i]
  step_load with e0 consuming hv4
  iterate 2 step_call using rotr64.call_eq
  step_pure
  step_call using rotr64.call_eq
  step_pure
  step_load with f0 consuming hv5
  step_load with g0 consuming hv6
  iterate 3 step_pure
  step_pure [Nat.mod_eq_of_lt h16, Nat.mul_comm (16 * j) 8,
    show 8 * (16 * j) < 18446744073709551616 by omega]
  step_load consuming hfw hw0
  step_pure [Nat.mod_eq_of_lt h16, Nat.mul_comm (16 * j) 8,
    show 8 * (16 * j) < 18446744073709551616 by omega]
  step_load consuming hfk hk0
  step_load with h0 consuming hv7
  iterate 3 step_pure
  step_pure with transparent T1
  step_load with d0 consuming hv3
  step_pure with e1
  -- d += h;
  step_store
  -- h += S0(a) + Maj(a, b, c);
  step_load with a0 consuming hv0
  iterate 2 step_call using rotr64.call_eq
  step_pure
  step_call using rotr64.call_eq
  step_pure
  step_load with b0 consuming hv1
  step_load with c0 consuming hv2
  iterate 5 step_pure
  step_pure with a1
  step_store
  have hV0 : rounds H b (16 * j) = #v[a0, b0, c0, d0, e0, f0, g0, h0] := by
    rw [vec8_eta (rounds H b (16 * j)), ← ha0, ← hb0, ← hc0, ← hd0, ← he0, ← hf0, ← hg0, ← hh0]
  have hv : rounds H b (16 * j + 1) = #v[a1, a0, b0, c0, e1, e0, f0, g0] := by
    refine rounds_step hV0 ?_
    rw [ha1, he1, round_code0]
    simp only [sigma1_code, sigma0_code, ch_code0, maj_code0]
  have hSp56 : Sp.offset.toNat + 56 < 2 ^ 64 := by omega
  rw [hM, iterMem, hV0, storeWords8_storeAt_lane3 hSp56, storeWords8_storeAt_lane7 hSp56] at hS
  clear hV0 ha0 hb0 hc0 hd0 he0 hf0 hg0 hh0 ha1 he1 hT1 hM
  round 1true a2 e2 storeWords8_storeAt_lane2 storeWords8_storeAt_lane6
  round 2false a3 e3 storeWords8_storeAt_lane1 storeWords8_storeAt_lane5
  round 3false a4 e4 storeWords8_storeAt_lane0 storeWords8_storeAt_lane4
  -- the live registers only: the walk through the rounds' writes stays short
  have hE1' : Hdr1 Sp Kp (16 * j) E := by env_reads
  have hL :
    E ⊨ [%456 := tmp.add (BitVec.ofNat 64 (8 * (16 * j))), %466 := e1, %480 := a1, %490 :=
      tmp.add (BitVec.ofNat 64 (8 * (16 * j + 1))), %498 := e2, %509 := a2, %527 := e3, %538 := a3,
      %556 := e4, %567 := a4] := by
    env_reads
  clear hE hE1
  rename' hE1' => hE1, hL => hL'
  round 4false a5 e5 storeWords8_storeAt_lane7 storeWords8_storeAt_lane3
  round 5false a6 e6 storeWords8_storeAt_lane6 storeWords8_storeAt_lane2
  round 6false a7 e7 storeWords8_storeAt_lane5 storeWords8_storeAt_lane1
  round 7false a8 e8 storeWords8_storeAt_lane4 storeWords8_storeAt_lane0
  -- the live registers only: the walk through the rounds' writes stays short
  have hE1' : Hdr1 Sp Kp (16 * j) E := by env_reads
  have hL :
    E ⊨ [%456 := tmp.add (BitVec.ofNat 64 (8 * (16 * j))), %490 :=
      tmp.add (BitVec.ofNat 64 (8 * (16 * j + 1))), %585 := e5, %596 := a5, %614 := e6, %625 := a6,
      %643 := e7, %654 := a7, %672 := e8, %683 := a8] := by
    env_reads
  clear hE hE1 hL'
  rename' hE1' => hE1, hL => hL'
  round 8false a9 e9 storeWords8_storeAt_lane3 storeWords8_storeAt_lane7
  round 9false a10 e10 storeWords8_storeAt_lane2 storeWords8_storeAt_lane6
  round 10false a11 e11 storeWords8_storeAt_lane1 storeWords8_storeAt_lane5
  round 11false a12 e12 storeWords8_storeAt_lane0 storeWords8_storeAt_lane4
  -- the live registers only: the walk through the rounds' writes stays short
  have hE1' : Hdr1 Sp Kp (16 * j) E := by env_reads
  have hL :
    E ⊨ [%456 := tmp.add (BitVec.ofNat 64 (8 * (16 * j))), %490 :=
      tmp.add (BitVec.ofNat 64 (8 * (16 * j + 1))), %701 := e9, %712 := a9, %722 :=
      tmp.add (BitVec.ofNat 64 (8 * (16 * j + 9))), %730 := e10, %741 := a10, %751 :=
      tmp.add (BitVec.ofNat 64 (8 * (16 * j + 10))), %759 := e11, %770 := a11, %780 :=
      tmp.add (BitVec.ofNat 64 (8 * (16 * j + 11))), %788 := e12, %799 := a12] := by
    env_reads
  clear hE hE1 hL'
  rename' hE1' => hE1, hL => hL'
  round 12false a13 e13 storeWords8_storeAt_lane7 storeWords8_storeAt_lane3
  round 13false a14 e14 storeWords8_storeAt_lane6 storeWords8_storeAt_lane2
  round 14false a15 e15 storeWords8_storeAt_lane5 storeWords8_storeAt_lane1
  round 15false a16 e16 storeWords8_storeAt_lane4 storeWords8_storeAt_lane0
  rw [← hv] at hS
  -- if (i == 64) break;
  step_pure
  finish_block
  · have hj4 : j = 4 := by
      have := congrArg BitVec.toNat hbr
      simp at this
      omega
    subst hj4
    have ha16 : (rounds H b 80)[0] = a16 := by
      rw [show (80 : Nat) = 16 * 4 + 15 + 1 by rfl, hv]
      rfl
    refine hexit rfl E S hArgs (by env_reads) ?_ ?_ hwf
    · rw [ha16]
      env_reads
    · rw [hS]
  · have hj4 : j < 4 := by
      have : 16 * j ≠ 64 := fun h => hbr (by rw [h])
      omega
    refine hnext hj4 E S hArgs (by env_reads) (by env_reads) ?_ hwf
    rw [hS]

theorem rotr1 (x : BitVec 64) : rotr64.spec x 1#32 = x.rotateRight 1 :=
  rotr64_lit x 1 (by decide)

theorem rotr8 (x : BitVec 64) : rotr64.spec x 8#32 = x.rotateRight 8 :=
  rotr64_lit x 8 (by decide)

theorem rotr19 (x : BitVec 64) : rotr64.spec x 19#32 = x.rotateRight 19 :=
  rotr64_lit x 19 (by decide)

theorem rotr61 (x : BitVec 64) : rotr64.spec x 61#32 = x.rotateRight 61 :=
  rotr64_lit x 61 (by decide)

/-- The schedule's recurrence, for `16 ≤ n + 16 < 80`. -/
theorem W_rec (n : Nat) (h : n + 16 < 80) :
    W b (n + 16) =
      Sha512.sigma1 (W b (n + 14)) + W b (n + 9) + Sha512.sigma0 (W b (n + 1)) + W b n := by
  simp only [W]
  rw [Sha512.getElem!_schedule_ge _ (by omega) h]
  simp only [show n + 16 - 2 = n + 14 by omega, show n + 16 - 7 = n + 9 by omega,
    show n + 16 - 15 = n + 1 by omega, show n + 16 - 16 = n by omega]

/-- Room for word `t` of `W`. -/
theorem roomW {m : MemoryState} {tmp : Pointer} (h : Room m tmp 5120)
    (ho : tmp.offset.toNat + 640 < 2 ^ 64) {t : Nat} (ht : t < 80) :
    Room m (tmp.add (BitVec.ofNat 64 (8 * t))) 64 :=
  Room.add_of_le
    (by
      simp [BitVec.uaddOverflow]; omega)
    (by
      simp; omega)
    h

/-- An MSCH store of `W[n]` at `tmp + 8 n`, below the `S` slots. -/
theorem msch_store {M0 : MemoryState} {tmp Sp : Pointer} {f : Nat → BitVec 64} {n n' t : Nat}
    {V : Vector (BitVec 64) 8} {x : BitVec 64} (ho : tmp.offset.toNat + 640 < 2 ^ 64)
    (hSpo : Sp.offset.toNat + 64 < 2 ^ 64) (hWS : (Range.of tmp 5120).Disjoint (Range.of Sp 512))
    (hn : n < 80) (ht : t = n) (hn' : n' = n + 1) (hx : x = f n) :
    ((M0.storeWords tmp f n).storeWords8 Sp V).storeAt (tmp.add (BitVec.ofNat 64 (8 * t))) x =
      (M0.storeWords tmp f n').storeWords8 Sp V := by
  subst ht hn' hx
  rw [MemoryState.storeWords8_storeAt_comm (by omega)]
  · rfl
  · simp only [Range.Disjoint, Range.of, Pointer.add_id,
      Pointer.offsetInBits_word (n := 80) (by omega) (show t ≤ 80 by omega)] at hWS ⊢
    rcases hWS with h | h | h
    · exact .inl h
    · exact .inr (.inl (by omega))
    · exact .inr (.inr (by omega))

/-- The compression: the old words plus the working variables after the rounds. -/
theorem spec_eq_rounds (H : Vector (BitVec 64) 8) (b : BitVec 1024) :
    spec H b = Vector.zipWith (· + ·) H (rounds H b 80) :=
  rfl

/-- A word of the compression: the old word plus the working variable. -/
theorem spec_getElem (H : Vector (BitVec 64) 8) (b : BitVec 1024) (k : Nat) (hk : k < 8) :
    (spec H b)[k] = H[k] + (rounds H b 80)[k] := by rw [spec_eq_rounds, Vector.getElem_zipWith]

attribute [local irreducible] W in
-- the 280-instruction ^bb2: 16 schedule words in one block exceed the default
set_option maxHeartbeats 2000000 in
theorem bb2_run (state blkp tmp Sp Kp : Pointer) (H : Vector (BitVec 64) 8) (b : BitVec 1024)
    (M0 : MemoryState) (j : Nat) (hj : j < 4) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value state) (.value blkp) (.value tmp) (.value Sp)).get)
    (hE1 : Hdr1 Sp Kp (16 * j) E) (hP : Ptr2 tmp (16 * j) E) (hwf : S.WF)
    (hM : S.mem = iterMem M0 tmp Sp H b (16 + 16 * j) (16 * j + 16)) (hR : Room M0 tmp 5120)
    (ho : tmp.offset.toNat + 640 < 2 ^ 64) (hSpo : Sp.offset.toNat + 64 < 2 ^ 64)
    (hWS : (Range.of tmp 5120).Disjoint (Range.of Sp 512))
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value state) (.value blkp) (.value tmp) (.value Sp)).get →
          Hdr1 Sp Kp (16 * (j + 1)) E' →
          S' =
            { alloc := S.alloc, mem := iterMem M0 tmp Sp H b (16 + 16 * (j + 1)) (16 * (j + 1)) } →
          S'.WF → (SHA512_Transform.runFrom E' 1 S' >>= g) = K) :
    (SHA512_Transform.runFrom E 2 S >>= g) = K := by
  have hSp56 : Sp.offset.toNat + 56 < 2 ^ 64 := by omega
  have hRm : Room S.mem tmp 5120 := by
    rw [hM]; exact hR.storeWords.storeWords8
  block_init
  -- W[i + 16] = s1(W[i + 14]) + W[i + 9] + s0(W[i + 1]) + W[i + 0];
  obtain ⟨hf14, hl14⟩ := readW (t := 16 * j + 14) hM hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf9, hl9⟩ := readW (t := 16 * j + 9) hM hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf1, hl1⟩ := readW (t := 16 * j + 1) hM hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf0, hl0⟩ := readW (t := 16 * j + 0) hM hR ho hSpo hWS (by omega) (by omega)
  simp only [Nat.add_zero] at hf0 hl0
  step_load inline consuming hf14 hl14
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_load inline consuming hf9 hl9
  step_pure
  step_load inline consuming hf1 hl1
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_load inline consuming hf0 hl0
  step_pure
  step_pure with w16
  step_pure [saddOverflow_ofNat64 (i := 16 * j) (k := 16) (by omega),
    uaddOverflow_ofNat64 (i := 16 * j) (k := 16) (by omega), ← BitVec.ofNat_add]
  step_pure [Nat.mod_eq_of_lt (show 16 * j + 16 < 18446744073709551616 by omega),
    Nat.mul_comm (16 * j + 16) 8, show 8 * (16 * j + 16) < 18446744073709551616 by omega]
  have hrw := roomW hRm ho (t := 16 * j + 16) (by omega)
  step_store consuming hrw
  have hw16' : w16 = W b (16 * j + 16) := by
    rw [hw16, show 16 * j + 16 = 16 * j + 0 + 16 by omega, W_rec (16 * j + 0) (by omega)]
    simp only [Nat.add_zero, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0, Sha512.sigma1]
    ac_rfl
  rw [hM,
    msch_store (n' := 16 + 16 * j + 1) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw16'.trans (congrArg _ (by omega)))] at hS
  clear hw16
  rename' hw16' => hw16
  -- W[i + 17] = s1(W[i + 15]) + W[i + 10] + s0(W[i + 2]) + W[i + 1];
  obtain ⟨hf15, hl15⟩ :=
    readW (t := 16 * j + 15) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf10, hl10⟩ :=
    readW (t := 16 * j + 10) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf2, hl2⟩ :=
    readW (t := 16 * j + 2) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 120 = 8 * (16 * j + 15) by omega]
  step_load inline consuming hf15 hl15
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 80 = 8 * (16 * j + 10) by omega]
  step_load inline consuming hf10 hl10
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 16 = 8 * (16 * j + 2) by omega]
  step_load inline consuming hf2 hl2
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w17
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 136 = 8 * (16 * j + 17) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 17) (by omega)
  step_store consuming hrw
  have hw17' : w17 = W b (16 * j + 17) := by
    rw [hw17, show 16 * j + 17 = 16 * j + 1 + 16 by omega, W_rec (16 * j + 1) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 2) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw17'.trans (congrArg _ (by omega)))] at hS
  clear hw17
  rename' hw17' => hw17
  -- W[i + 18] = s1(W[i + 16]) + W[i + 11] + s0(W[i + 3]) + W[i + 2];
  obtain ⟨hf11, hl11⟩ :=
    readW (t := 16 * j + 11) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf3, hl3⟩ :=
    readW (t := 16 * j + 3) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 88 = 8 * (16 * j + 11) by omega]
  step_load inline consuming hf11 hl11
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 24 = 8 * (16 * j + 3) by omega]
  step_load inline consuming hf3 hl3
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w18
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 144 = 8 * (16 * j + 18) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 18) (by omega)
  step_store consuming hrw
  have hw18' : w18 = W b (16 * j + 18) := by
    rw [hw18, show 16 * j + 18 = 16 * j + 2 + 16 by omega, W_rec (16 * j + 2) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 3) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw18'.trans (congrArg _ (by omega)))] at hS
  clear hw18
  rename' hw18' => hw18
  -- W[i + 19] = s1(W[i + 17]) + W[i + 12] + s0(W[i + 4]) + W[i + 3];
  obtain ⟨hf12, hl12⟩ :=
    readW (t := 16 * j + 12) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf4, hl4⟩ :=
    readW (t := 16 * j + 4) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 96 = 8 * (16 * j + 12) by omega]
  step_load inline consuming hf12 hl12
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 32 = 8 * (16 * j + 4) by omega]
  step_load inline consuming hf4 hl4
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w19
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 152 = 8 * (16 * j + 19) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 19) (by omega)
  step_store consuming hrw
  have hw19' : w19 = W b (16 * j + 19) := by
    rw [hw19, show 16 * j + 19 = 16 * j + 3 + 16 by omega, W_rec (16 * j + 3) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 4) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw19'.trans (congrArg _ (by omega)))] at hS
  clear hw19
  rename' hw19' => hw19
  -- the live registers only
  have hE1' : Hdr1 Sp Kp (16 * j) E := by env_reads
  have hP' : Ptr2 tmp (16 * j) E := by env_reads
  have hL :
    E ⊨ [rir_reg% hty 509 := W b (16 * j + 14), rir_reg% hty 515 := W b (16 * j + 9),
      rir_reg% hty 525 := w16, rir_reg% hty 526 := BitVec.ofNat 64 (16 * j + 16),
      rir_reg% hty 529 := W b (16 * j + 15), rir_reg% hty 536 := W b (16 * j + 10),
      rir_reg% hty 546 := w17, rir_reg% hty 554 := W b (16 * j + 11), rir_reg% hty 564 := w18,
      rir_reg% hty 572 := W b (16 * j + 12), rir_reg% hty 575 := W b (16 * j + 4),
      rir_reg% hty 582 := w19] := by
    env_reads
  clear hE hE1 hP
  rename' hE1' => hE1, hP' => hP, hL => hL'
  -- W[i + 20] = s1(W[i + 18]) + W[i + 13] + s0(W[i + 5]) + W[i + 4];
  obtain ⟨hf13, hl13⟩ :=
    readW (t := 16 * j + 13) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf5, hl5⟩ :=
    readW (t := 16 * j + 5) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 104 = 8 * (16 * j + 13) by omega]
  step_load inline consuming hf13 hl13
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 40 = 8 * (16 * j + 5) by omega]
  step_load inline consuming hf5 hl5
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w20
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 160 = 8 * (16 * j + 20) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 20) (by omega)
  step_store consuming hrw
  have hw20' : w20 = W b (16 * j + 20) := by
    rw [hw20, show 16 * j + 20 = 16 * j + 4 + 16 by omega, W_rec (16 * j + 4) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 5) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw20'.trans (congrArg _ (by omega)))] at hS
  clear hw20
  rename' hw20' => hw20
  -- W[i + 21] = s1(W[i + 19]) + W[i + 14] + s0(W[i + 6]) + W[i + 5];
  obtain ⟨hf14, hl14⟩ :=
    readW (t := 16 * j + 14) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  obtain ⟨hf6, hl6⟩ :=
    readW (t := 16 * j + 6) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 112 = 8 * (16 * j + 14) by omega]
  step_load inline consuming hf14 hl14
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 48 = 8 * (16 * j + 6) by omega]
  step_load inline consuming hf6 hl6
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w21
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 168 = 8 * (16 * j + 21) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 21) (by omega)
  step_store consuming hrw
  have hw21' : w21 = W b (16 * j + 21) := by
    rw [hw21, show 16 * j + 21 = 16 * j + 5 + 16 by omega, W_rec (16 * j + 5) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 6) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw21'.trans (congrArg _ (by omega)))] at hS
  clear hw21
  rename' hw21' => hw21
  -- W[i + 22] = s1(W[i + 20]) + W[i + 15] + s0(W[i + 7]) + W[i + 6];
  obtain ⟨hf7, hl7⟩ :=
    readW (t := 16 * j + 7) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 56 = 8 * (16 * j + 7) by omega]
  step_load inline consuming hf7 hl7
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w22
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 176 = 8 * (16 * j + 22) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 22) (by omega)
  step_store consuming hrw
  have hw22' : w22 = W b (16 * j + 22) := by
    rw [hw22, show 16 * j + 22 = 16 * j + 6 + 16 by omega, W_rec (16 * j + 6) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 7) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw22'.trans (congrArg _ (by omega)))] at hS
  clear hw22
  rename' hw22' => hw22
  -- W[i + 23] = s1(W[i + 21]) + W[i + 16] + s0(W[i + 8]) + W[i + 7];
  obtain ⟨hf8, hl8⟩ :=
    readW (t := 16 * j + 8) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 64 = 8 * (16 * j + 8) by omega]
  step_load inline consuming hf8 hl8
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w23
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 184 = 8 * (16 * j + 23) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 23) (by omega)
  step_store consuming hrw
  have hw23' : w23 = W b (16 * j + 23) := by
    rw [hw23, show 16 * j + 23 = 16 * j + 7 + 16 by omega, W_rec (16 * j + 7) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 8) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw23'.trans (congrArg _ (by omega)))] at hS
  clear hw23
  rename' hw23' => hw23
  -- the live registers only
  have hE1' : Hdr1 Sp Kp (16 * j) E := by env_reads
  have hP' : Ptr2 tmp (16 * j) E := by env_reads
  have hL :
    E ⊨ [rir_reg% hty 509 := W b (16 * j + 14), rir_reg% hty 515 := W b (16 * j + 9),
      rir_reg% hty 525 := w16, rir_reg% hty 526 := BitVec.ofNat 64 (16 * j + 16),
      rir_reg% hty 529 := W b (16 * j + 15), rir_reg% hty 536 := W b (16 * j + 10),
      rir_reg% hty 546 := w17, rir_reg% hty 554 := W b (16 * j + 11), rir_reg% hty 564 := w18,
      rir_reg% hty 572 := W b (16 * j + 12), rir_reg% hty 582 := w19, rir_reg% hty 590 :=
      W b (16 * j + 13), rir_reg% hty 600 := w20, rir_reg% hty 608 := W b (16 * j + 14),
      rir_reg% hty 618 := w21, rir_reg% hty 634 := w22, rir_reg% hty 643 := W b (16 * j + 8),
      rir_reg% hty 650 := w23] := by
    env_reads
  clear hE hE1 hP hL'
  rename' hE1' => hE1, hP' => hP, hL => hL'
  -- W[i + 24] = s1(W[i + 22]) + W[i + 17] + s0(W[i + 9]) + W[i + 8];
  obtain ⟨hf9, hl9⟩ :=
    readW (t := 16 * j + 9) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 72 = 8 * (16 * j + 9) by omega]
  step_load inline consuming hf9 hl9
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w24
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 192 = 8 * (16 * j + 24) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 24) (by omega)
  step_store consuming hrw
  have hw24' : w24 = W b (16 * j + 24) := by
    rw [hw24, show 16 * j + 24 = 16 * j + 8 + 16 by omega, W_rec (16 * j + 8) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 9) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw24'.trans (congrArg _ (by omega)))] at hS
  clear hw24
  rename' hw24' => hw24
  -- W[i + 25] = s1(W[i + 23]) + W[i + 18] + s0(W[i + 10]) + W[i + 9];
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w25
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 200 = 8 * (16 * j + 25) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 25) (by omega)
  step_store consuming hrw
  have hw25' : w25 = W b (16 * j + 25) := by
    rw [hw25, show 16 * j + 25 = 16 * j + 9 + 16 by omega, W_rec (16 * j + 9) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 10) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw25'.trans (congrArg _ (by omega)))] at hS
  clear hw25
  rename' hw25' => hw25
  -- W[i + 26] = s1(W[i + 24]) + W[i + 19] + s0(W[i + 11]) + W[i + 10];
  obtain ⟨hf10, hl10⟩ :=
    readW (t := 16 * j + 10) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_load inline consuming hf10 hl10
  step_pure
  step_pure with w26
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 208 = 8 * (16 * j + 26) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 26) (by omega)
  step_store consuming hrw
  have hw26' : w26 = W b (16 * j + 26) := by
    rw [hw26, show 16 * j + 26 = 16 * j + 10 + 16 by omega, W_rec (16 * j + 10) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 11) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw26'.trans (congrArg _ (by omega)))] at hS
  clear hw26
  rename' hw26' => hw26
  -- W[i + 27] = s1(W[i + 25]) + W[i + 20] + s0(W[i + 12]) + W[i + 11];
  obtain ⟨hf11, hl11⟩ :=
    readW (t := 16 * j + 11) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_load inline consuming hf11 hl11
  step_pure
  step_pure with w27
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 216 = 8 * (16 * j + 27) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 27) (by omega)
  step_store consuming hrw
  have hw27' : w27 = W b (16 * j + 27) := by
    rw [hw27, show 16 * j + 27 = 16 * j + 11 + 16 by omega, W_rec (16 * j + 11) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 12) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw27'.trans (congrArg _ (by omega)))] at hS
  clear hw27
  rename' hw27' => hw27
  -- the live registers only
  have hE1' : Hdr1 Sp Kp (16 * j) E := by env_reads
  have hP' : Ptr2 tmp (16 * j) E := by env_reads
  have hL :
    E ⊨ [rir_reg% hty 509 := W b (16 * j + 14), rir_reg% hty 525 := w16, rir_reg% hty 526 :=
      BitVec.ofNat 64 (16 * j + 16), rir_reg% hty 529 := W b (16 * j + 15), rir_reg% hty 590 :=
      W b (16 * j + 13), rir_reg% hty 608 := W b (16 * j + 14), rir_reg% hty 618 := w21,
      rir_reg% hty 634 := w22, rir_reg% hty 650 := w23, rir_reg% hty 666 := w24, rir_reg% hty 695 :=
      w26, rir_reg% hty 710 := w27] := by
    env_reads
  clear hE hE1 hP hL'
  rename' hE1' => hE1, hP' => hP, hL => hL'
  -- W[i + 28] = s1(W[i + 26]) + W[i + 21] + s0(W[i + 13]) + W[i + 12];
  obtain ⟨hf12, hl12⟩ :=
    readW (t := 16 * j + 12) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_load inline consuming hf12 hl12
  step_pure
  step_pure with w28
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 224 = 8 * (16 * j + 28) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 28) (by omega)
  step_store consuming hrw
  have hw28' : w28 = W b (16 * j + 28) := by
    rw [hw28, show 16 * j + 28 = 16 * j + 12 + 16 by omega, W_rec (16 * j + 12) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 13) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw28'.trans (congrArg _ (by omega)))] at hS
  clear hw28
  rename' hw28' => hw28
  -- W[i + 29] = s1(W[i + 27]) + W[i + 22] + s0(W[i + 14]) + W[i + 13];
  obtain ⟨hf13, hl13⟩ :=
    readW (t := 16 * j + 13) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_load inline consuming hf13 hl13
  step_pure
  step_pure with w29
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 232 = 8 * (16 * j + 29) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 29) (by omega)
  step_store consuming hrw
  have hw29' : w29 = W b (16 * j + 29) := by
    rw [hw29, show 16 * j + 29 = 16 * j + 13 + 16 by omega, W_rec (16 * j + 13) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 14) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw29'.trans (congrArg _ (by omega)))] at hS
  clear hw29
  rename' hw29' => hw29
  -- W[i + 30] = s1(W[i + 28]) + W[i + 23] + s0(W[i + 15]) + W[i + 14];
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with w30
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 240 = 8 * (16 * j + 30) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 30) (by omega)
  step_store consuming hrw
  have hw30' : w30 = W b (16 * j + 30) := by
    rw [hw30, show 16 * j + 30 = 16 * j + 14 + 16 by omega, W_rec (16 * j + 14) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 15) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw30'.trans (congrArg _ (by omega)))] at hS
  clear hw30
  rename' hw30' => hw30
  -- W[i + 31] = s1(W[i + 29]) + W[i + 24] + s0(W[i + 16]) + W[i + 15];
  obtain ⟨hf15, hl15⟩ :=
    readW (t := 16 * j + 15) (congrArg GlobalState.mem hS) hR ho hSpo hWS (by omega) (by omega)
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_pure
  step_call using rotr64.call_eq
  step_call using rotr64.call_eq
  step_pure
  step_pure
  step_pure
  step_load inline consuming hf15 hl15
  step_pure
  step_pure with w31
  step_pure [← BitVec.ofNat_add, show 8 * (16 * j) + 248 = 8 * (16 * j + 31) by omega]
  have hrw := roomW hRm ho (t := 16 * j + 31) (by omega)
  step_store consuming hrw
  have hw31' : w31 = W b (16 * j + 31) := by
    rw [hw31, show 16 * j + 31 = 16 * j + 15 + 16 by omega, W_rec (16 * j + 15) (by omega)]
    simp only [Nat.add_assoc, Nat.reduceAdd, rotr1, rotr8, rotr19, rotr61, Sha512.sigma0,
      Sha512.sigma1]
    ac_rfl
  rw [msch_store (n' := 16 + 16 * j + 16) ho hSpo hWS (by omega) (by omega) (by omega)
      (hw31'.trans (congrArg _ (by omega)))] at hS
  clear hw31
  rename' hw31' => hw31
  finish_block
  refine hK E S hArgs (by env_reads) ?_ hwf
  rw [hS, show 16 + 16 * (j + 1) = 16 + 16 * j + 16 by omega,
    show 16 * (j + 1) = 16 * j + 16 by omega]

/-- `state[i] += S[i]`: `^bb3` stores the words plus the working variables at `state`. -/
theorem bb3_run (state blkp tmp Sp : Pointer) (H : Vector (BitVec 64) 8) (b : BitVec 1024)
    (M0 : MemoryState) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β)
    (hArgs : E.args = (args (.value state) (.value blkp) (.value tmp) (.value Sp)).get)
    (hE3 : Hdr3 Sp E) (h915 : E ⊨ [rir_reg% hty 507 := (rounds H b 80)[0]]) (hwf : S.WF)
    (hM : S.mem = iterMem M0 tmp Sp H b 80 80) (hSR : Room M0 Sp 512)
    (hSpov : ¬Sp.offset.uaddOverflow 64#64) (ho : tmp.offset.toNat + 640 < 2 ^ 64)
    (hSpo : Sp.offset.toNat + 64 < 2 ^ 64) (hst : M0.Words8Fit state) (hH : M0.readWords8 state = H)
    (hsep : tmp.id ≠ state.id) (hsepS : Sp.id ≠ state.id)
    (hsov : ¬state.offset.uaddOverflow 64#64) :
    (SHA512_Transform.runFrom E 3 S >>= g) =
      g (.nil, { alloc := S.alloc, mem := S.mem.storeWords8 state (spec H b) }) := by
  have hp (q : Pointer) (hq : q.id ≠ tmp.id) (hq' : q.id ≠ Sp.id) (w : Nat) :
    S.mem.readAt q w = M0.readAt q w := by
    rw [hM, iterMem,
      MemoryState.readAt_storeWords8_of_disjoint (by omega) (Range.disjoint_of_id_ne (Ne.symm hq')),
      MemoryState.readAt_storeWords_of_disjoint (by omega) (Range.disjoint_of_id_ne (Ne.symm hq))]
  have hHk (k : Nat) (hk : k < 8) := congrArg (·[k]'hk) hH
  simp only [MemoryState.readWords8] at hHk
  have hV (k : Nat) (hk : k < 8) :
    S.mem.readAt (Sp.add (BitVec.ofNat 64 (8 * k))) 64 = (rounds H b 80)[k] := by
    rw [hM]; exact readAt_storeWords8_lane hSR.inBounds.storeWords (by omega) _ hk
  have hSF : S.mem.Words8Fit Sp := by
    rw [hM]
    have := hSR.storeWords (p := tmp) (f := W b) (n := 80)
    refine MemoryState.Words8Fit.storeWords8_self ⟨by omega, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
      first
      | exact this.mono (by decide)
      | exact Room.add_of_le (BitVec.not_uaddOverflow_of_le hSpov (by decide)) (by decide) this
  have hstS : S.mem.Words8Fit state := by
    obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8⟩ := hst
    rw [hM]
    exact
      ⟨h0, h1.storeWords.storeWords8, h2.storeWords.storeWords8, h3.storeWords.storeWords8,
        h4.storeWords.storeWords8, h5.storeWords.storeWords8, h6.storeWords.storeWords8,
        h7.storeWords.storeWords8, h8.storeWords.storeWords8⟩
  have hs0 : S.mem.readAt state 64 = H[0] := by
    rw [hp state (Ne.symm hsep) (Ne.symm hsepS), ← hHk 0 (by decide)]; rfl
  have hs1 : S.mem.readAt (state.add 8#64) 64 = H[1] := by
    rw [hp (state.add 8#64)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsep)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsepS),
      ← hHk 1 (by decide)];
    rfl
  have hv1 : S.mem.readAt (Sp.add 8#64) 64 = (rounds H b 80)[1] := hV 1 (by decide)
  have hs2 : S.mem.readAt (state.add 16#64) 64 = H[2] := by
    rw [hp (state.add 16#64)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsep)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsepS),
      ← hHk 2 (by decide)];
    rfl
  have hv2 : S.mem.readAt (Sp.add 16#64) 64 = (rounds H b 80)[2] := hV 2 (by decide)
  have hs3 : S.mem.readAt (state.add 24#64) 64 = H[3] := by
    rw [hp (state.add 24#64)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsep)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsepS),
      ← hHk 3 (by decide)];
    rfl
  have hv3 : S.mem.readAt (Sp.add 24#64) 64 = (rounds H b 80)[3] := hV 3 (by decide)
  have hs4 : S.mem.readAt (state.add 32#64) 64 = H[4] := by
    rw [hp (state.add 32#64)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsep)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsepS),
      ← hHk 4 (by decide)];
    rfl
  have hv4 : S.mem.readAt (Sp.add 32#64) 64 = (rounds H b 80)[4] := hV 4 (by decide)
  have hs5 : S.mem.readAt (state.add 40#64) 64 = H[5] := by
    rw [hp (state.add 40#64)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsep)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsepS),
      ← hHk 5 (by decide)];
    rfl
  have hv5 : S.mem.readAt (Sp.add 40#64) 64 = (rounds H b 80)[5] := hV 5 (by decide)
  have hs6 : S.mem.readAt (state.add 48#64) 64 = H[6] := by
    rw [hp (state.add 48#64)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsep)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsepS),
      ← hHk 6 (by decide)];
    rfl
  have hv6 : S.mem.readAt (Sp.add 48#64) 64 = (rounds H b 80)[6] := hV 6 (by decide)
  have hs7 : S.mem.readAt (state.add 56#64) 64 = H[7] := by
    rw [hp (state.add 56#64)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsep)
        (by
          rw [Pointer.add_id]; exact Ne.symm hsepS),
      ← hHk 7 (by decide)];
    rfl
  have hv7 : S.mem.readAt (Sp.add 56#64) 64 = (rounds H b 80)[7] := hV 7 (by decide)
  obtain ⟨hso, hf0, hf1, hf2, hf3, hf4, hf5, hf6, hf7⟩ := hstS
  obtain ⟨-, -, hg1, hg2, hg3, hg4, hg5, hg6, hg7⟩ := hSF
  clear hV hp
  have hHk0 : M0.readAt state 64 = H[0] := hHk 0 (by decide)
  have hHk1 : M0.readAt (state.add 8#64) 64 = H[1] := hHk 1 (by decide)
  have hHk2 : M0.readAt (state.add 16#64) 64 = H[2] := hHk 2 (by decide)
  have hHk3 : M0.readAt (state.add 24#64) 64 = H[3] := hHk 3 (by decide)
  have hHk4 : M0.readAt (state.add 32#64) 64 = H[4] := hHk 4 (by decide)
  have hHk5 : M0.readAt (state.add 40#64) 64 = H[5] := hHk 5 (by decide)
  have hHk6 : M0.readAt (state.add 48#64) 64 = H[6] := hHk 6 (by decide)
  have hHk7 : M0.readAt (state.add 56#64) 64 = H[7] := hHk 7 (by decide)
  clear hHk hM
  block_init
  -- state[i] += S[i];
  step_load consuming hs0
  step_pure with u0
  step_store consuming hread_state
  step_load consuming hv1 hg1
  step_pure
  step_load [hs1] consuming hs1
  step_pure with u1
  have hr1 : Room S.mem (state.add 8#64) 64 := hf1.room
  step_store consuming hr1
  step_load consuming hv2 hg2
  step_pure
  step_load [hs2] consuming hs2
  step_pure with u2
  have hr2 : Room S.mem (state.add 16#64) 64 := hf2.room
  step_store consuming hr2
  step_load consuming hv3 hg3
  step_pure
  step_load [hs3] consuming hs3
  step_pure with u3
  have hr3 : Room S.mem (state.add 24#64) 64 := hf3.room
  step_store consuming hr3
  step_load consuming hv4 hg4
  step_pure
  step_load [hs4] consuming hs4
  step_pure with u4
  have hr4 : Room S.mem (state.add 32#64) 64 := hf4.room
  step_store consuming hr4
  step_load consuming hv5 hg5
  step_pure
  step_load [hs5] consuming hs5
  step_pure with u5
  have hr5 : Room S.mem (state.add 40#64) 64 := hf5.room
  step_store consuming hr5
  step_load consuming hv6 hg6
  step_pure
  step_load [hs6] consuming hs6
  step_pure with u6
  have hr6 : Room S.mem (state.add 48#64) 64 := hf6.room
  step_store consuming hr6
  step_load consuming hv7 hg7
  step_pure
  step_load [hs7] consuming hs7
  step_pure with u7
  have hr7 : Room S.mem (state.add 56#64) 64 := hf7.room
  step_store consuming hr7
  finish_block
  rw [hS]
  refine congrArg (fun m => g (.nil, ⟨_, m⟩)) ?_
  simp only [MemoryState.storeWords8, hu0, hu1, hu2, hu3, hu4, hu5, hu6, hu7,
    spec_getElem H b 0 (by decide), spec_getElem H b 1 (by decide), spec_getElem H b 2 (by decide),
    spec_getElem H b 3 (by decide), spec_getElem H b 4 (by decide), spec_getElem H b 5 (by decide),
    spec_getElem H b 6 (by decide), spec_getElem H b 7 (by decide)]

/-- The rounds' loop from iteration `j`, `m` more after it: `^bb1`, then `^bb2` back to `^bb1`
until `i == 64`. -/
theorem rounds_loop (state blkp tmp Sp Kp : Pointer) (H : Vector (BitVec 64) 8) (b : BitVec 1024)
    (M0 : MemoryState) {hw : (Ty.array 80 (.bv 64)).width = 5120} (a : AllocState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hR : Room M0 tmp 5120)
    (hSR : Room M0 Sp 512) (hSpov : ¬Sp.offset.uaddOverflow 64#64) (hKf : Fits M0 Kp 5120)
    (hKo : Kp.offset = 0) (hKr : M0.readAt Kp 5120 = Ty.flatBits Krnd.lit (hw := hw))
    (ho : tmp.offset.toNat + 640 < 2 ^ 64) (hSpo : Sp.offset.toNat + 64 < 2 ^ 64)
    (hWS : (Range.of tmp 5120).Disjoint (Range.of Sp 512)) (htK : tmp.id ≠ Kp.id)
    (hSK : Sp.id ≠ Kp.id)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value state) (.value blkp) (.value tmp) (.value Sp)).get →
          Hdr3 Sp E' →
          (E' ⊨ [rir_reg% hty 507 := (rounds H b 80)[0]]) →
          S' = { alloc := a, mem := iterMem M0 tmp Sp H b 80 80 } →
          S'.WF → (SHA512_Transform.runFrom E' 3 S' >>= g) = K) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫),
      j + m = 4 →
        E.args = (args (.value state) (.value blkp) (.value tmp) (.value Sp)).get →
        Hdr1 Sp Kp (16 * j) E →
        S.WF →
        S.alloc = a →
        S.mem = iterMem M0 tmp Sp H b (16 + 16 * j) (16 * j) →
        (SHA512_Transform.runFrom E 1 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro j S E hj hArgs hE1 hwf hA hM
    exact
      bb1_run state blkp tmp Sp Kp H b M0 (hw := hw) j (by omega) S E g K hArgs hE1 hwf hM hR hSR
        hSpov hKf hKo hKr ho hSpo hWS htK hSK
        (fun _ E' S' h1 h2 h3 h4 h5 => hK E' S' h1 h2 h3 (h4.trans (by rw [hA])) h5)
        (fun h => absurd h (by omega))
  | succ m ih =>
    intro j S E hj hArgs hE1 hwf hA hM
    refine
      bb1_run state blkp tmp Sp Kp H b M0 (hw := hw) j (by omega) S E g K hArgs hE1 hwf hM hR hSR
        hSpov hKf hKo hKr ho hSpo hWS htK hSK (fun h => absurd h (by omega))
        (fun hj4 E' S' h1 h2 h3 h4 h5 => ?_)
    subst h4
    exact
      bb2_run state blkp tmp Sp Kp H b M0 j hj4 _ E' g K h1 h2 h3 h5 rfl hR ho hSpo hWS
        (fun E'' S'' h6 h7 h8 h9 =>
          ih (j + 1) S'' E'' (by omega) h6 h7 h9 (by rw [h8, hA]) (by rw [h8]))

theorem getLsbD_wordsLE (f : Nat → BitVec 64) (n i : Nat) :
    (wordsLE f n).getLsbD i = (decide (i < 64 * n) && (f (i / 64)).getLsbD (i % 64)) := by
  induction n with
  | zero => simp [wordsLE]
  | succ n ih =>
    simp only [wordsLE, BitVec.getLsbD_cast, BitVec.getLsbD_append, ih]
    by_cases h : i < 64 * n
    · simp [h, show i < 64 * (n + 1) by omega]
    · have h1 : i / 64 = n ∨ 64 * (n + 1) ≤ i := by omega
      rcases h1 with h1 | h1
      · simp [h, show i < 64 * (n + 1) by omega, h1, show i - 64 * n = i % 64 by omega]
      · simp [h, show ¬i < 64 * (n + 1) by omega]
        exact BitVec.getLsbD_of_ge _ _ (by omega)

theorem wordsLE_extract {n : Nat} (x : BitVec (64 * n)) :
    wordsLE (fun i => x.extractLsb' (64 * i) 64) n = x := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [getLsbD_wordsLE]
  simp only [hi, decide_true, Bool.true_and, BitVec.getLsbD_extractLsb',
    Nat.mod_lt _ (by decide : 64 > 0)]
  congr 1
  omega

theorem storeWords8_eq_storeWords {m : MemoryState} {p : Pointer} (v : Vector (BitVec 64) 8) :
    m.storeWords8 p v = m.storeWords p (fun i => v[i]!) 8 := by
  simp only [MemoryState.storeWords8, MemoryState.storeWords, Nat.mul_zero, Pointer.add_zero]
  rfl

theorem be64dec_W (x : BitVec 1024) (t : Nat) (ht : t < 16) :
    be64dec_vect.spec x t = SHA512_Transform.W x t := by
  rw [SHA512_Transform.W, Sha512.getElem!_schedule_lt _ ht]
  simp only [Sha512.word, be64dec_vect.spec, load64_be.spec, Firedancer.Ref.fd_ulong_bswap.spec]
  rw [getElem!_bytesLE _ (by omega), getElem!_bytesLE _ (by omega), getElem!_bytesLE _ (by omega),
    getElem!_bytesLE _ (by omega), getElem!_bytesLE _ (by omega), getElem!_bytesLE _ (by omega),
    getElem!_bytesLE _ (by omega), getElem!_bytesLE _ (by omega)]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_append, BitVec.getLsbD_extractLsb']
  grind

theorem storeWords_congr {m : MemoryState} {p : Pointer} {f g : Nat → BitVec 64} :
    ∀ {n : Nat}, (∀ t < n, f t = g t) → m.storeWords p f n = m.storeWords p g n
  | 0, _ => rfl
  | n + 1, h => by
    rw [MemoryState.storeWords_succ, MemoryState.storeWords_succ, h n (by omega),
      storeWords_congr fun t ht => h t (by omega)]

/-- The words of a 512-bit read, as `readWords8` reads them. -/
theorem readWords8_getElem {m : MemoryState} {p : Pointer} (hm : InBounds m p 512)
    (hp : ¬p.offset.uaddOverflow 64#64) {i : Nat} (hi : i < 8) :
    (m.readWords8 p)[i]! = (m.readAt p 512).extractLsb' (64 * i) 64 := by
  have h (c : BitVec 64) (hc : c.toNat ≤ 56) :
    m.readAt (p.add c) 64 = (m.readAt p 512).extractLsb' (c.toNat * 8) 64 :=
    MemoryState.readAt_add_of_readAt hm
      (BitVec.not_uaddOverflow_of_le hp
        (by
          simp; omega))
      (by omega) rfl
  interval_cases i <;> simp only [MemoryState.readWords8] <;>
    first
    | (rw [MemoryState.readAt_of_readAt_le (v := 512) (by decide) rfl]; rfl)
    |
      (rw [getElem!_pos _ _ (by decide)];
       simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
         List.getElem_cons_zero];
       rw [h _ (by decide)]; rfl)

/-- `memcpy(S, state, 64)`: the eight words stored. -/
theorem storeAt_readAt_eq_storeWords8 {m m' : MemoryState} {p q : Pointer} (hm : InBounds m' q 512)
    (hq : ¬q.offset.uaddOverflow 64#64) (hp : p.offset.toNat + 64 < 2 ^ 64) :
    m.storeAt p (m'.readAt q 512) = m.storeWords8 p (m'.readWords8 q) := by
  rw [storeWords8_eq_storeWords, MemoryState.storeWords_eq_storeAt (by omega)]
  conv =>
    lhs; rw [← wordsLE_extract (n := 8) (m'.readAt q 512)]
  rw [wordsLE_congr fun i hi => (readWords8_getElem hm hq hi).symm]

/-- Eight words fit where 64 bytes do. -/
theorem words8Fit_of_fits {m : MemoryState} {p : Pointer} (h : Fits m p 512)
    (hp : ¬p.offset.uaddOverflow 64#64) : m.Words8Fit p := by
  have hp' : p.offset.toNat + 64 < 2 ^ 64 := by
    simp [BitVec.uaddOverflow] at hp; omega
  refine ⟨by omega, h.mono (by decide), ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (BitVec.not_uaddOverflow_of_le hp (by decide)) (by decide) h

end SHA512_Transform

/-- `Krnd`'s initializer gives its folded constant, leaving the state. -/
public theorem Krnd.value_eq (s : GlobalState) : Krnd.value s = .value (Ty.wrap Krnd.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

open SHA512_Transform in
/-- `SHA512_Transform(state, block, W, S)` with `W = tmp`, `S = tmp + 640` stores the block's
compression into the eight words at `state` and leaves `SHA512_Transform.tmp` at `tmp`. `state`
and `block` may share a block (they are read before anything is written); `tmp` may not. The
block counter advances by one (`Krnd`). -/
public theorem SHA512_Transform.call_eq (state block tmp : Pointer) (s : GlobalState) (hwf : s.WF)
    (hst : Fits s.mem state 512) (hsto : ¬state.offset.uaddOverflow 64#64)
    (hblk : Fits s.mem block 1024) (hblko : ¬block.offset.uaddOverflow 128#64)
    (htmp : Room s.mem tmp 5632) (htmpo : ¬tmp.offset.uaddOverflow 704#64)
    (hsep : tmp.id ≠ state.id) (hsep' : tmp.id ≠ block.id) :
    SHA512_Transform.call
        (SHA512_Transform.args (.value state) (.value block) (.value tmp) (.value (tmp.add 640#64)))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩
            mem :=
              (s.mem.storeAt tmp
                    (SHA512_Transform.tmp (s.mem.readWords8 state)
                      (s.mem.readAt block 1024))).storeWords8
                state
                (SHA512_Transform.spec (s.mem.readWords8 state) (s.mem.readAt block 1024)) }) := by
  have htmp1 : ¬tmp.offset.uaddOverflow 128#64 := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq] at htmpo ⊢; simp at htmpo ⊢; omega
  have h640 : ¬tmp.offset.uaddOverflow 640#64 := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq] at htmpo ⊢; simp at htmpo ⊢; omega
  have hSpR : Room s.mem (tmp.add 640#64) 512 := Room.add_of_le h640 (by simp) htmp
  have hSpo : (tmp.add 640#64).offset.toNat + 64 < 2 ^ 64 := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq] at htmpo
    simp [Pointer.add, BitVec.toNat_add] at htmpo ⊢; omega
  have hSpS : (Range.of (tmp.add 640#64) 512).Disjoint (Range.of state 512) :=
    Range.disjoint_of_id_ne
      (by
        rw [Pointer.add_id]; exact hsep)
  have hWS : (Range.of tmp 5120).Disjoint (Range.of (tmp.add 640#64) 512) := by
    simp only [Range.Disjoint, Range.of, Pointer.add_id, Pointer.offsetInBits_add h640]
    right; left; simp
  have hSpid : (tmp.add 640#64).id = tmp.id := Pointer.add_id _ _
  have hto : tmp.offset.toNat + 704 < 2 ^ 64 := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq] at htmpo; simp at htmpo; omega
  generalize hSp : tmp.add 640#64 = Sp at hSpR hSpo hSpS hWS hSpid
  func_init
  block_init
  iterate 7 step_pure
  step_addressof Krnd.value_eq with Kp
  have hKf0 := hKp_fits
  have hKr0 := hread_Kp
  have hR0 := htmp
  have hSR0 := hSpR
  have hst0 := words8Fit_of_fits hst hsto
  rw [hS] at hKf0 hKr0 hR0 hSR0 hst0
  dsimp only at hKf0 hKr0 hR0 hSR0 hst0
  iterate 21 step_pure
  step_call using be64dec_vect.call_eq
  step_memcpy
  iterate 7 step_pure
  finish_block
  have hM := congrArg GlobalState.mem hS
  dsimp only at hM
  rw [storeWords_congr (fun t ht => be64dec_W _ t ht),
    storeAt_readAt_eq_storeWords8 hst₀.inBounds hsto (by omega)] at hM
  refine
    SHA512_Transform.rounds_loop state block tmp Sp Kp (S₀.mem.readWords8 state)
      (S₀.mem.readAt block 1024) _ S.alloc _ _ (hR0.mono (by decide)) hSR0
      (by
        simp [BitVec.uaddOverflow]; omega)
      hKf0 hKp_off hKr0 (by omega) hSpo hWS htmp_ne_Kp hSp_ne_Kp (fun E' S' h1 h2 h3 h4 h5 => ?_) 4
      0 S E rfl hArgs (by env_reads) hwf rfl hM
  rw [SHA512_Transform.bb3_run state block tmp Sp _ _ _ S' E' _ h1 h2 h3 h5 (by rw [h4]) hSR0
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by omega) hSpo hst0 ?_ hsep
      (by
        rw [hSpid]; exact hsep)
      hsto]
  swap
  · obtain ⟨-, h0, h1, h2, h3, h4, h5, h6, h7⟩ := words8Fit_of_fits hst₀ hsto
    simp only [MemoryState.readWords8, MemoryState.readAt_addBlock hwf₀ h0.inBounds,
      MemoryState.readAt_addBlock hwf₀ h1.inBounds, MemoryState.readAt_addBlock hwf₀ h2.inBounds,
      MemoryState.readAt_addBlock hwf₀ h3.inBounds, MemoryState.readAt_addBlock hwf₀ h4.inBounds,
      MemoryState.readAt_addBlock hwf₀ h5.inBounds, MemoryState.readAt_addBlock hwf₀ h6.inBounds,
      MemoryState.readAt_addBlock hwf₀ h7.inBounds]
  subst h4
  rw [hS]
  dsimp only [iterMem]
  rw [MemoryState.eraseFrom_storeWords8, MemoryState.eraseFrom_storeWords8,
    MemoryState.eraseFrom_storeWords, MemoryState.eraseFrom_addBlock_of_le (Nat.le_refl _),
    hwf₀.eraseFrom, storeWords8_eq_storeWords (p := Sp),
    MemoryState.storeWords_eq_storeAt (p := Sp) (by omega),
    MemoryState.storeWords_eq_storeAt (p := tmp) (by omega), ← hSp,
    MemoryState.storeAt_storeAt_append (k := 640) h640 (by decide) (by decide)]
  rfl

end Proof

end MLIR.Sodium
