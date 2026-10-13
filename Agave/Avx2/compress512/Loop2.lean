module

public import Agave.Avx2.compress512.Basic

/-! The loops of `compress512`'s two-block path (`compress`'s loop over block pairs): the
schedule-and-rounds loop `^bb12` (with `^bb10`, `^bb11`), the first block's last rounds `^bb13`
and the second block's rounds `^bb15`. -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave

@[expose] public section

/-- `^bb8`'s pointers: pairs `1 … 7` of `ms2` and `t2`, words `1 … 7` of the state at `st`. -/
abbrev Ptr8 (st ms2 t2 : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%4127 := ms2.add 16#64, %4128 := t2.add 16#64, %4129 := ms2.add 32#64, %4130 := t2.add 32#64,
    %4131 := ms2.add 48#64, %4132 := t2.add 48#64, %4133 := ms2.add 64#64, %4134 := t2.add 64#64,
    %4135 := ms2.add 80#64, %4136 := t2.add 80#64, %4137 := ms2.add 96#64, %4138 := t2.add 96#64,
    %4139 := ms2.add 112#64, %4140 := t2.add 112#64, %4141 := st.add 8#64, %4142 := st.add 16#64,
    %4143 := st.add 24#64, %4144 := st.add 32#64, %4145 := st.add 40#64, %4146 := st.add 48#64,
    %4147 := st.add 56#64]

/-- `^bb9`'s state words `H`, block index `i` and pairs left `c`. -/
abbrev Old2 (H : Vector (BitVec 64) 8) (i c : Nat) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% compress512.hty 355 := H[7], rir_reg% compress512.hty 356 := H[6],
    rir_reg% compress512.hty 357 := H[5], rir_reg% compress512.hty 358 := H[4],
    rir_reg% compress512.hty 359 := H[3], rir_reg% compress512.hty 360 := H[2],
    rir_reg% compress512.hty 361 := H[1], rir_reg% compress512.hty 362 := H[0],
    rir_reg% compress512.hty 363 := BitVec.ofNat 64 i, rir_reg% compress512.hty 364 :=
    BitVec.ofNat 64 c]

/-- What the two-block path's blocks read from before them. -/
abbrev Live2 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (i c : Nat) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ Ptrs Kp ms t2 ms2 E ∧ Ptr8 st ms2 t2 E ∧ Old2 H i c E

/-- `^bb14`'s state words `H` after the first block, which `^bb16` adds to. -/
abbrev Acc (H : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [rir_reg% compress512.hty 640 := H[0], rir_reg% compress512.hty 641 := H[1],
    rir_reg% compress512.hty 642 := H[2], rir_reg% compress512.hty 643 := H[3],
    rir_reg% compress512.hty 644 := H[4], rir_reg% compress512.hty 645 := H[5],
    rir_reg% compress512.hty 646 := H[6], rir_reg% compress512.hty 647 := H[7]]

/-- `^bb12` at iteration `j` of round group `i` (`rounds_0_63_avx2`), `k` the index of the next
pair of `K`, the schedule words `x` and working variables `v`. -/
abbrev hdr12 (t2 : Pointer) (i j k : Nat) (x0 x1 x2 x3 x4 x5 x6 x7 : Vector (BitVec 64) 4)
    (v : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[rir_dst% compress512.hty 473 := BitVec.ofNat 64 i, rir_dst% compress512.hty 491 :=
    t2.add (BitVec.ofNat 64 (i * 128)), rir_dst% compress512.hty 492 := BitVec.ofNat 64 k,
    rir_dst% compress512.hty 493 := BitVec.ofNat 64 j, rir_dst% compress512.hty 494 := x1,
    rir_dst% compress512.hty 495 := x0, rir_dst% compress512.hty 496 := x5,
    rir_dst% compress512.hty 497 := x4, rir_dst% compress512.hty 498 := x7,
    rir_dst% compress512.hty 499 := x2, rir_dst% compress512.hty 500 := x3,
    rir_dst% compress512.hty 501 := x6, rir_dst% compress512.hty 502 := v[7],
    rir_dst% compress512.hty 503 := v[4], rir_dst% compress512.hty 504 := v[6],
    rir_dst% compress512.hty 505 := v[5], rir_dst% compress512.hty 506 := v[0],
    rir_dst% compress512.hty 507 := v[1], rir_dst% compress512.hty 508 := v[2],
    rir_dst% compress512.hty 509 := v[3]]

/-- `^bb13` at round `i` on the working variables `v`. -/
abbrev hdr13 (i : Nat) (v : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[rir_dst% compress512.hty 595 := BitVec.ofNat 64 i, rir_dst% compress512.hty 596 := v[7],
    rir_dst% compress512.hty 597 := v[4], rir_dst% compress512.hty 598 := v[6],
    rir_dst% compress512.hty 599 := v[5], rir_dst% compress512.hty 600 := v[0],
    rir_dst% compress512.hty 601 := v[1], rir_dst% compress512.hty 602 := v[2],
    rir_dst% compress512.hty 603 := v[3]]

/-- `^bb14` on the working variables `v` after the first block's last round. -/
abbrev exit14 (v : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[rir_dst% compress512.hty 632 := v[5], rir_dst% compress512.hty 633 := v[7],
    rir_dst% compress512.hty 634 := v[6], rir_dst% compress512.hty 635 := v[1],
    rir_dst% compress512.hty 636 := v[2], rir_dst% compress512.hty 637 := v[3],
    rir_dst% compress512.hty 638 := v[0], rir_dst% compress512.hty 639 := v[4]]

/-- `^bb15` at round `t` of the second block (`process_second_block`) on the working variables
`v`. -/
abbrev hdr15 (t : Nat) (v : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[rir_dst% compress512.hty 648 := BitVec.ofNat 64 (8 * t), rir_dst% compress512.hty 649 := v[7],
    rir_dst% compress512.hty 650 := v[4], rir_dst% compress512.hty 651 := v[6],
    rir_dst% compress512.hty 652 := v[5], rir_dst% compress512.hty 653 := v[0],
    rir_dst% compress512.hty 654 := v[1], rir_dst% compress512.hty 655 := v[2],
    rir_dst% compress512.hty 656 := v[3]]

/-- `^bb16` on the working variables `v` after the second block's last round. -/
abbrev exit16 (v : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[rir_dst% compress512.hty 684 := v[5], rir_dst% compress512.hty 685 := v[7],
    rir_dst% compress512.hty 686 := v[6], rir_dst% compress512.hty 687 := v[1],
    rir_dst% compress512.hty 688 := v[2], rir_dst% compress512.hty 689 := v[3],
    rir_dst% compress512.hty 690 := v[0], rir_dst% compress512.hty 691 := v[4]]

/-- The two stores of `^bb12`'s iteration on pair `p`: its first block's words into `ms2`'s slot
`p % 8`, its second block's into `t2` at byte `16 p`. -/
abbrev pairMem2 (ms2 t2 : Pointer) (W₀ W₁ : Nat → BitVec 64) (p n : Nat) (mem : MemoryState) :
    MemoryState :=
  tMem t2 W₁ p n (pairsMem ms2 W₀ p n mem)

end

section Proof

/-- A round from its word's load on, as `^bb6`'s (the first of two in `^bb5`) computes it: `t`
its `T1`, `a`, `e` the new working variables. -/
local macro "round1 " t:ident a:ident e:ident : tactic =>
  `(tactic|
    ( iterate 4 step_pure
      step_pure [sig1_code]
      step_pure
      step_pure
      step_pure [ch_code]
      step_pure
      step_pure
      step_pure with $t:ident
      iterate 4 step_pure
      step_pure [sig0_code]
      iterate 3 step_pure
      step_pure [maj_code1]
      step_pure
      step_pure with $a:ident
      step_pure with $e:ident))

/-- The second round of `^bb5`'s two, from its word's load on. -/
local macro "round2 " t:ident a:ident e:ident : tactic =>
  `(tactic|
    ( iterate 4 step_pure
      step_pure [sig1_code]
      step_pure
      step_pure
      step_pure [ch_code2]
      step_pure
      step_pure
      step_pure with $t:ident
      iterate 4 step_pure
      step_pure [sig0_code]
      iterate 3 step_pure
      step_pure [maj_code2]
      step_pure
      step_pure with $a:ident
      step_pure with $e:ident))

-- `^bb13`'s 36 steps
set_option maxHeartbeats 400000 in
/-- `^bb13`'s round `i` (`rounds_64_79` on `ms2`): to `^bb14` after round `79`, else round
`i + 1`. -/
theorem iter13 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (b c : Nat) (i : Nat)
    (hi : i < 80) (v : Vector (BitVec 64) 8) (w : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hL : Live2 st Kp ms t2 ms2 H b c E)
    (hmo : ms2.offset = 0) (hw : S.mem.readAt (ms2.add (BitVec.ofNat 64 (i % 16 * 8))) 64 = w)
    (hwf : Fits S.mem (ms2.add (BitVec.ofNat 64 (i % 16 * 8))) 64)
    (hexit :
      i + 1 = 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            (compress512.runFrom (exit14 (wround v w) E') 14 S >>= g) = K)
    (hback :
      i + 1 < 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            (compress512.runFrom (hdr13 (i + 1) (wround v w) E') 13 S >>= g) = K) :
    (compress512.runFrom (hdr13 i v E) 13 S >>= g) = K := by
  obtain ⟨hC, hP, hP8, hO⟩ := hL
  block_init
  step_pure [and_15]
  step_pure [saddOverflow_ofNat (i := i) (k := 1) (by omega),
    uaddOverflow_ofNat (i := i) (k := 1) (by omega), ← BitVec.ofNat_add]
  step_pure [gepDyn_slot hmo (show i % 16 * 8 < 2 ^ 63 by omega) (by omega)]
  step_load consuming hw
  round1 u1 a1 e1
  have ev : wround v w = #v[a1, v[0], v[1], v[2], e1, v[4], v[5], v[6]] := by
    rw [ha1, he1, hu1]; rfl
  rw [ev] at hexit hback
  step_pure
  finish_block
  · step_loop using hexit (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hback
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

/-- Rounds `i … 79` of the first block from `ms2`, which holds their words: to `^bb14` on the
working variables after round `79`. -/
public theorem loop13 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (b c : Nat)
    (W : Nat → BitVec 64) (H₀ : Vector (BitVec 64) 8) (S : GlobalState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hmo : ms2.offset = 0)
    (hf : Fits S.mem ms2 1024) (hR : HoldsR S.mem ms2 W 64 80) :
    ∀ n i (E : ⟪Γ⟫),
      i + n + 1 = 80 →
        64 ≤ i →
        Live2 st Kp ms t2 ms2 H b c E →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            (compress512.runFrom (exit14 (rounds W 80 H₀) E') 14 S >>= g) = K) →
        (compress512.runFrom (hdr13 i (rounds W i H₀) E) 13 S >>= g) = K := by
  have hfw (i : Nat) : Fits S.mem (ms2.add (BitVec.ofNat 64 (i % 16 * 8))) 64 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow, hmo]; omega)
      (by
        simp; omega)
      hf
  intro n
  induction n with
  | zero =>
    intro i E hi hi64 hL hK
    refine
      iter13 st Kp ms t2 ms2 H b c i (by omega) _ _ S E g K hL hmo (hR i hi64 (by omega)) (hfw i)
        (fun h E' hE' hL' => ?_) (fun h => absurd h (by omega))
    rw [← rounds_succ_wround, show i + 1 = 80 by omega]
    exact hK E' hE' hL'
  | succ n ih =>
    intro i E hi hi64 hL hK
    refine
      iter13 st Kp ms t2 ms2 H b c i (by omega) _ _ S E g K hL hmo (hR i hi64 (by omega)) (hfw i)
        (fun h => absurd h (by omega)) (fun h E' hE' hL' => ?_)
    rw [← rounds_succ_wround]
    exact ih (i + 1) E' (by omega) (by omega) hL' fun E'' hE'' hL'' => hK E'' (hE''.trans hE') hL''

-- `^bb15`'s 36 steps
set_option maxHeartbeats 400000 in
/-- `^bb15`'s round `t` (`process_second_block`'s `sha_round(s, t2[t])`): to `^bb16` after
round `79`, else round `t + 1`. -/
theorem iter15 (st Kp ms t2 ms2 : Pointer) (H H' : Vector (BitVec 64) 8) (b c : Nat) (t : Nat)
    (ht : t < 80) (v : Vector (BitVec 64) 8) (w : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hL : Live2 st Kp ms t2 ms2 H b c E)
    (hA : Acc H' E) (hto : t2.offset = 0)
    (hw : S.mem.readAt (t2.add (BitVec.ofNat 64 (8 * t))) 64 = w)
    (hwf : Fits S.mem (t2.add (BitVec.ofNat 64 (8 * t))) 64)
    (hexit :
      t + 1 = 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            Acc H' E' → (compress512.runFrom (exit16 (wround v w) E') 16 S >>= g) = K)
    (hback :
      t + 1 < 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            Acc H' E' → (compress512.runFrom (hdr15 (t + 1) (wround v w) E') 15 S >>= g) = K) :
    (compress512.runFrom (hdr15 t v E) 15 S >>= g) = K := by
  obtain ⟨hC, hP, hP8, hO⟩ := hL
  block_init
  step_pure [gepDyn_slot hto (show 8 * t * 1 < 2 ^ 63 by omega) (by omega)]
  step_pure [saddOverflow_ofNat (i := 8 * t) (k := 8) (by omega),
    uaddOverflow_ofNat (i := 8 * t) (k := 8) (by omega), ← BitVec.ofNat_add]
  step_load consuming hw
  round1 u1 a1 e1
  have ev : wround v w = #v[a1, v[0], v[1], v[2], e1, v[4], v[5], v[6]] := by
    rw [ha1, he1, hu1]; rfl
  dsimp only [hdr15] at hback
  rw [ev, show 8 * (t + 1) = 8 * t + 8 by omega] at hback
  rw [ev] at hexit
  step_pure
  finish_block
  · step_loop using
      hexit
        (by
          have := eq_of_ofNat_eq hbr (by omega) (by decide); omega)
  · step_loop using
      hback
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

/-- The second block's rounds `t … 79` from `t2`, which holds their words: to `^bb16` on the
working variables after round `79`. -/
public theorem loop15 (st Kp ms t2 ms2 : Pointer) (H H' : Vector (BitVec 64) 8) (b c : Nat)
    (W : Nat → BitVec 64) (H₀ : Vector (BitVec 64) 8) (S : GlobalState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hto : t2.offset = 0)
    (hf : Fits S.mem t2 5120) (hR : HoldsT S.mem t2 W 80) :
    ∀ n t (E : ⟪Γ⟫),
      t + n + 1 = 80 →
        Live2 st Kp ms t2 ms2 H b c E →
        Acc H' E →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            Acc H' E' → (compress512.runFrom (exit16 (rounds W 80 H₀) E') 16 S >>= g) = K) →
        (compress512.runFrom (hdr15 t (rounds W t H₀) E) 15 S >>= g) = K := by
  have hfw (t : Nat) (ht : t < 80) : Fits S.mem (t2.add (BitVec.ofNat 64 (8 * t))) 64 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow, hto]; omega)
      (by
        simp; omega)
      hf
  have hw (t : Nat) (ht : t < 80) :
    S.mem.readAt (t2.add (BitVec.ofNat 64 (8 * t))) 64 = wk W t := by
    rw [Nat.mul_comm]; exact hR t ht
  intro n
  induction n with
  | zero =>
    intro t E ht hL hA hK
    refine
      iter15 st Kp ms t2 ms2 H H' b c t (by omega) _ _ S E g K hL hA hto (hw t (by omega))
        (hfw t (by omega)) (fun h E' hE' hL' hA' => ?_) (fun h => absurd h (by omega))
    rw [← rounds_succ_wround, show t + 1 = 80 by omega]
    exact hK E' hE' hL' hA'
  | succ n ih =>
    intro t E ht hL hA hK
    refine
      iter15 st Kp ms t2 ms2 H H' b c t (by omega) _ _ S E g K hL hA hto (hw t (by omega))
        (hfw t (by omega)) (fun h => absurd h (by omega)) (fun h E' hE' hL' hA' => ?_)
    rw [← rounds_succ_wround]
    exact
      ih (t + 1) E' (by omega) hL' hA' fun E'' hE'' hL'' hA'' => hK E'' (hE''.trans hE') hL'' hA''

/-- `pairMem2` one pair on. -/
public theorem pairMem2_succ {ms2 t2 : Pointer} {W₀ W₁ : Nat → BitVec 64} {p n : Nat}
    {mem : MemoryState} (hne : t2.id ≠ ms2.id) :
    pairMem2 ms2 t2 W₀ W₁ p (n + 1) mem =
      pairMem2 ms2 t2 W₀ W₁ (p + 1) n
        ((mem.storeAt (ms2.add (BitVec.ofNat 64 (p % 8 * 16)))
              (BitVec.packLanes #v[wk W₀ (2 * p), wk W₀ (2 * p + 1)])).storeAt
          (t2.add (BitVec.ofNat 64 (p * 16)))
          (BitVec.packLanes #v[wk W₁ (2 * p), wk W₁ (2 * p + 1)])) := by
  rw [pairMem2, pairMem2, tMem_succ, pairsMem_succ,
    pairsMem_storeAt_comm (q := t2.add (BitVec.ofNat 64 (p * 16))) (by simpa using hne)]

public theorem pairMem2_add {ms2 t2 : Pointer} {W₀ W₁ : Nat → BitVec 64} {mem : MemoryState}
    (hne : t2.id ≠ ms2.id) :
    ∀ {p n n'},
      pairMem2 ms2 t2 W₀ W₁ (p + n) n' (pairMem2 ms2 t2 W₀ W₁ p n mem) =
        pairMem2 ms2 t2 W₀ W₁ p (n + n') mem := by
  intro p n n'
  induction n generalizing p mem with
  | zero =>
    rw [Nat.add_zero, Nat.zero_add]; rfl
  | succ n ih =>
    rw [pairMem2_succ hne, show p + (n + 1) = p + 1 + n by omega, ih,
      show n + 1 + n' = (n + n') + 1 by omega, pairMem2_succ hne]

/-- The ring buffer's words past the second block's stores. -/
public theorem HoldsR.tMem {mem : MemoryState} {X Y : Pointer} {W W' : Nat → BitVec 64}
    (h : HoldsR mem X W lo hi) (hne : Y.id ≠ X.id) :
    HoldsR (compress512.tMem Y W' p n mem) X W lo hi := fun t h1 h2 => by
  rw [readAt_tMem_of_id_ne (by simpa using hne)]
  exact h t h1 h2

-- `^bb12`'s 90 steps, twelve of them `fshl`s of half a second each
set_option maxHeartbeats 2000000 in
/-- `^bb12`'s iteration `j` of round group `i`: the schedule's next pairs `y` stored at `ms2[j]`
and `t2[8 i + j]`, two rounds on `ms2[2 j]`, `ms2[2 j + 1]`; then iteration `j + 1`, or through
`^bb10` the next group's first (`^bb11`) or, after the fourth group, `^bb13`. -/
theorem iter12 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (b c : Nat) (i j k : Nat)
    (hi : 1 ≤ i) (hi5 : i < 5) (hj : j < 8) (hk : k + 2 ≤ 80)
    (x0 x1 x2 x3 x4 x5 x6 x7 : Vector (BitVec 64) 4) (v : Vector (BitVec 64) 8)
    (k0 k1 w0 w1 : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hL : Live2 st Kp ms t2 ms2 H b c E) (hmo : ms2.offset = 0)
    (hto : t2.offset = 0) (hKo : Kp.offset = 0)
    (hkf : Fits S.mem (Kp.add (BitVec.ofNat 64 (k * 8))) 128)
    (hk2 : S.mem.readAt (Kp.add (BitVec.ofNat 64 (k * 8))) 128 = BitVec.packLanes #v[k0, k1])
    (hw0f : Fits S.mem (ms2.add (BitVec.ofNat 64 (j * 16))) 64)
    (hw0 : S.mem.readAt (ms2.add (BitVec.ofNat 64 (j * 16))) 64 = w0)
    (hw1f : Fits S.mem (ms2.add (BitVec.ofNat 64 (j * 16) + 8#64)) 64)
    (hw1 : S.mem.readAt (ms2.add (BitVec.ofNat 64 (j * 16) + 8#64)) 64 = w1)
    (hroom : Room S.mem (ms2.add (BitVec.ofNat 64 (j * 16))) 128)
    (hroomt : Room S.mem (t2.add (BitVec.ofNat 64 (i * 128 + j * 16))) 128)
    (hnext :
      j + 1 < 8 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            (compress512.runFrom
                  (hdr12 t2 i (j + 1) (k + 2) x1 x2 x3 x4 x5 x6 x7 (upd4 x0 x1 x4 x5 x7)
                    (wround (wround v w0) w1) E')
                  12
                  { S with
                    mem :=
                      (S.mem.storeAt (ms2.add (BitVec.ofNat 64 (j * 16)))
                            (BitVec.packLanes (ylo (upd4 x0 x1 x4 x5 x7) k0 k1))).storeAt
                        (t2.add (BitVec.ofNat 64 (i * 128 + j * 16)))
                        (BitVec.packLanes (yhi (upd4 x0 x1 x4 x5 x7) k0 k1)) } >>=
                g) =
              K)
    (hgroup :
      j + 1 = 8 →
        i + 1 < 5 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            (compress512.runFrom
                  (hdr12 t2 (i + 1) 0 (k + 2) x1 x2 x3 x4 x5 x6 x7 (upd4 x0 x1 x4 x5 x7)
                    (wround (wround v w0) w1) E')
                  12
                  { S with
                    mem :=
                      (S.mem.storeAt (ms2.add (BitVec.ofNat 64 (j * 16)))
                            (BitVec.packLanes (ylo (upd4 x0 x1 x4 x5 x7) k0 k1))).storeAt
                        (t2.add (BitVec.ofNat 64 (i * 128 + j * 16)))
                        (BitVec.packLanes (yhi (upd4 x0 x1 x4 x5 x7) k0 k1)) } >>=
                g) =
              K)
    (hdone :
      j + 1 = 8 →
        i + 1 = 5 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            (compress512.runFrom (hdr13 64 (wround (wround v w0) w1) E') 13
                  { S with
                    mem :=
                      (S.mem.storeAt (ms2.add (BitVec.ofNat 64 (j * 16)))
                            (BitVec.packLanes (ylo (upd4 x0 x1 x4 x5 x7) k0 k1))).storeAt
                        (t2.add (BitVec.ofNat 64 (i * 128 + j * 16)))
                        (BitVec.packLanes (yhi (upd4 x0 x1 x4 x5 x7) k0 k1)) } >>=
                g) =
              K) :
    (compress512.runFrom (hdr12 t2 i j k x0 x1 x2 x3 x4 x5 x6 x7 v E) 12 S >>= g) = K := by
  obtain ⟨hC, hP, hP8, hO⟩ := hL
  block_init
  step_pure [saddOverflow_ofNat (i := j) (k := 1) (by omega),
    uaddOverflow_ofNat (i := j) (k := 1) (by omega), ← BitVec.ofNat_add]
  -- let t = _mm_loadu_si128(K64.as_ptr().add(k64x4_idx).cast());
  step_pure [gepDyn_slot hKo (show k * 8 < 2 ^ 63 by omega) (by omega)]
  step_load with kv consuming hk2
  step_pure with kv4
  -- let y = sha512_update_x_avx2(x, _mm256_set_m128i(t, t));
  step_pure with t0
  step_pure with t3
  step_pure
  step_pure with x0t3
  iterate 7 step_pure
  step_pure with s0
  step_pure
  step_pure
  step_pure with x0t3s0
  iterate 6 step_pure
  step_pure with s1
  step_pure with xn
  step_pure with y
  have exn : xn = upd4 x0 x1 x4 x5 x7 := by
    rw [hxn, hx0t3s0, hs1, hx0t3, hs0, ht0, ht3]
    ext l hl
    rcases l with _ | _ | _ | _ | l
    · simp [upd4, ssig0_vcode, ssig1_vcode]
    · simp [upd4, ssig0_vcode, ssig1_vcode]
    · simp [upd4, ssig0_vcode, ssig1_vcode]
    · simp [upd4, ssig0_vcode, ssig1_vcode]
    · omega
  clear hxn hx0t3s0 hs1 hx0t3 hs0 ht0 ht3
  subst exn
  -- sha_round(current_state, ms[2 * j]); sha_round(current_state, ms[2 * j + 1]);
  step_pure [ofNat_shiftLeft, ofNat_mul_ushiftRight (show j * 2 ^ 4 < 2 ^ 64 by omega),
    ofNat_mul_sshiftRight (show j * 2 ^ 4 < 2 ^ 63 by omega)]
  step_pure [gepDyn_slot hmo (show j * 16 * 1 < 2 ^ 63 by omega) (by omega)]
  step_load consuming hw0
  round1 u1 a1 e1
  step_pure
  step_load consuming hw1
  round2 u2 a2 e2
  rw [two_rounds hu1 ha1 he1 hu2 ha2 he2] at hnext hgroup hdone
  -- ms[j] = _mm256_extracti128_si256(y, 0); t2[8 * i + j] = _mm256_extracti128_si256(y, 1);
  step_pure with lo
  have elo : lo = ylo (upd4 x0 x1 x4 x5 x7) k0 k1 := by
    rw [hlo, hy, hkv4, hkv]
    rfl
  clear hlo
  subst elo
  step_pure [gepDyn_slot hmo (show j * 16 < 2 ^ 63 by omega) (by omega)]
  step_store
  step_pure with hi'
  have ehi : hi' = yhi (upd4 x0 x1 x4 x5 x7) k0 k1 := by
    rw [hhi', hy, hkv4, hkv]
    rfl
  clear hhi' hy hkv4 hkv
  subst ehi
  step_pure [gepDyn_slot_add hto (show i * 128 + j * 16 < 2 ^ 63 by omega) (by omega)]
  step_store
  -- k64x4_idx += 2;
  step_pure [← BitVec.ofNat_add]
  step_pure
  finish_block
  · have hj7 : j = 7 := by
      have := eq_of_ofNat_eq hbr (by omega) (by decide); omega
    block_init
    step_pure [saddOverflow_ofNat (i := i) (k := 1) (by omega),
      uaddOverflow_ofNat (i := i) (k := 1) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · step_loop using hdone (by omega) (eq_of_ofNat_eq hbr (by omega) (by decide))
    · block_init
      step_pure [ofNat_shiftLeft, ofNat_mul_ushiftRight (show (i + 1) * 2 ^ 7 < 2 ^ 64 by omega),
        ofNat_mul_sshiftRight (show (i + 1) * 2 ^ 7 < 2 ^ 63 by omega)]
      step_pure [gepDyn_slot hto (show (i + 1) * 128 * 1 < 2 ^ 63 by omega) (by omega)]
      finish_block
      step_loop using
        hgroup (by omega)
          (by
            have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)
  · step_loop using
      hnext
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

-- one `iter12` per case, each elaborating its continuations
set_option maxHeartbeats 400000 in
/-- Iterations `m … 31` of `^bb12` (`rounds_0_63_avx2`), `ms2` holding the first block's schedule
window from pair `m`: the pairs `m + 8 …` of both blocks stored (`pairMem2`), the first block's
rounds `2 m … 63`, then `^bb13`. -/
public theorem loop12 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (b c : Nat)
    (W₀ W₁ : Nat → BitVec 64) (H₀ : Vector (BitVec 64) 8) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hmo : ms2.offset = 0) (hto : t2.offset = 0) (hKo : Kp.offset = 0)
    (hne : ms2.id ≠ Kp.id) (hne' : t2.id ≠ Kp.id) (hne'' : t2.id ≠ ms2.id) (hW₀ : Sched W₀)
    (hW₁ : Sched W₁) :
    ∀ n m (S : GlobalState) (E : ⟪Γ⟫),
      m + n + 1 = 32 →
        Live2 st Kp ms t2 ms2 H b c E →
        Fits S.mem ms2 1024 →
        Writable S.mem ms2 →
        Room S.mem t2 5120 →
        Fits S.mem Kp 5120 →
        KPairs S.mem Kp →
        HoldsR S.mem ms2 W₀ (2 * m) (2 * m + 16) →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live2 st Kp ms t2 ms2 H b c E' →
            (compress512.runFrom (hdr13 64 (rounds W₀ 64 H₀) E') 13
                  { S with mem := pairMem2 ms2 t2 W₀ W₁ (m + 8) (n + 1) S.mem } >>=
                g) =
              K) →
        (compress512.runFrom
              (hdr12 t2 (m / 8 + 1) (m % 8) (16 + 2 * m) (xq W₀ W₁ m) (xq W₀ W₁ (m + 1))
                (xq W₀ W₁ (m + 2)) (xq W₀ W₁ (m + 3)) (xq W₀ W₁ (m + 4)) (xq W₀ W₁ (m + 5))
                (xq W₀ W₁ (m + 6)) (xq W₀ W₁ (m + 7)) (rounds W₀ (2 * m) H₀) E)
              12 S >>=
            g) =
          K := by
  have hw (S : GlobalState) (m : Nat) (hf : Fits S.mem ms2 1024) (hfw : Writable S.mem ms2)
    (hR : HoldsR S.mem ms2 W₀ (2 * m) (2 * m + 16)) :
    (Fits S.mem (ms2.add (BitVec.ofNat 64 (m % 8 * 16))) 64 ∧
        S.mem.readAt (ms2.add (BitVec.ofNat 64 (m % 8 * 16))) 64 = wk W₀ (2 * m)) ∧
      (Fits S.mem (ms2.add (BitVec.ofNat 64 (m % 8 * 16) + 8#64)) 64 ∧
        S.mem.readAt (ms2.add (BitVec.ofNat 64 (m % 8 * 16) + 8#64)) 64 = wk W₀ (2 * m + 1)) ∧
      Room S.mem (ms2.add (BitVec.ofNat 64 (m % 8 * 16))) 128 := by
    have e0 := hR (2 * m) (by omega) (by omega)
    have e1 := hR (2 * m + 1) (by omega) (by omega)
    rw [show 2 * m % 16 * 8 = m % 8 * 16 by omega] at e0
    rw [show (2 * m + 1) % 16 * 8 = m % 8 * 16 + 8 by omega, BitVec.ofNat_add] at e1
    refine ⟨⟨Fits.add_of_le ?_ ?_ hf, e0⟩, ⟨?_, e1⟩, Room.add_of_le ?_ ?_ (hf.room hfw)⟩
    · simp [BitVec.uaddOverflow, hmo]; omega
    · simp; omega
    · rw [← BitVec.ofNat_add]
      exact
        Fits.add_of_le
          (by
            simp [BitVec.uaddOverflow, hmo]; omega)
          (by
            simp; omega)
          hf
    · simp [BitVec.uaddOverflow, hmo]; omega
    · simp; omega
  have hst (S : GlobalState) (m : Nat) (hm : m < 32) (hf : Fits S.mem ms2 1024)
    (hfw : Writable S.mem ms2) (ht : Room S.mem t2 5120) (hKf : Fits S.mem Kp 5120)
    (hK : KPairs S.mem Kp)
    (hR : HoldsR S.mem ms2 W₀ (2 * m) (2 * m + 16)) :
      let mem :=
      (S.mem.storeAt (ms2.add (BitVec.ofNat 64 (m % 8 * 16)))
            (BitVec.packLanes #v[wk W₀ (2 * m + 16), wk W₀ (2 * m + 17)])).storeAt
        (t2.add (BitVec.ofNat 64 ((m + 8) * 16)))
        (BitVec.packLanes #v[wk W₁ (2 * m + 16), wk W₁ (2 * m + 17)])
      Fits mem ms2 1024 ∧
      Writable mem ms2 ∧
      Room mem t2 5120 ∧
      Fits mem Kp 5120 ∧ KPairs mem Kp ∧ HoldsR mem ms2 W₀ (2 * (m + 1)) (2 * (m + 1) + 16) := by
    intro mem
    refine
      ⟨hf.storeAt.storeAt, hfw.storeAt.storeAt, ht.storeAt.storeAt, hKf.storeAt.storeAt,
        (hK.storeAt (by simpa using hne)).storeAt (by simpa using hne'), fun t h1 h2 => ?_⟩
    have :=
      HoldsR.pairsMem (p := m + 8) (n := 1) (lo := 2 * m) hmo (hf.room hfw) (by omega) (by omega)
        (fun t h1 h2 => hR t h1 (by omega))
    rw [show max (2 * m) (2 * (m + 8 + 1) - 16) = 2 * (m + 1) by omega,
      show 2 * (m + 8 + 1) = 2 * (m + 1) + 16 by omega] at this
    simp only [pairsMem, show (m + 8) % 8 = m % 8 by omega,
      show 2 * (m + 8) = 2 * m + 16 by omega] at this
    rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using hne''))]
    exact this t h1 h2
  intro n
  induction n with
  | zero =>
    intro m S E hm hL hf hfw ht hKf hK hR hcont
    obtain ⟨⟨hw0f, hw0⟩, ⟨hw1f, hw1⟩, hroom⟩ := hw S m hf hfw hR
    refine
      iter12 st Kp ms t2 ms2 H b c (m / 8 + 1) (m % 8) (16 + 2 * m) (by omega) (by omega) (by omega)
        (by omega) _ _ _ _ _ _ _ _ _ _ _ _ _ S E g K hL hmo hto hKo
        (Fits.add_of_le
          (by
            simp [BitVec.uaddOverflow, hKo]; omega)
          (by
            simp; omega)
          hKf)
        (hK _ (by omega)) hw0f hw0 hw1f hw1 hroom
        (Room.add_of_le
          (by
            simp [BitVec.uaddOverflow, hto]; omega)
          (by
            simp; omega)
          ht)
        (fun h => absurd h (by omega)) (fun _ h => absurd h (by omega)) (fun _ _ E' hE' hL' => ?_)
    rw [upd4_xq hW₀ hW₁ (by omega), show 16 + 2 * m = 2 * (m + 8) by omega, ylo_xq, yhi_xq,
      rounds_two, show 2 * m + 2 = 64 by omega,
      show (m / 8 + 1) * 128 + m % 8 * 16 = (m + 8) * 16 by omega]
    have := hcont E' hE' hL'
    rw [pairMem2_succ hne''] at this
    simpa [pairMem2, tMem, pairsMem, show (m + 8) % 8 = m % 8 by omega] using this
  | succ n ih =>
    intro m S E hm hL hf hfw ht hKf hK hR hcont
    obtain ⟨⟨hw0f, hw0⟩, ⟨hw1f, hw1⟩, hroom⟩ := hw S m hf hfw hR
    obtain ⟨hf', hfw', ht', hKf', hK', hR'⟩ := hst S m (by omega) hf hfw ht hKf hK hR
    refine
      iter12 st Kp ms t2 ms2 H b c (m / 8 + 1) (m % 8) (16 + 2 * m) (by omega) (by omega) (by omega)
        (by omega) _ _ _ _ _ _ _ _ _ _ _ _ _ S E g K hL hmo hto hKo
        (Fits.add_of_le
          (by
            simp [BitVec.uaddOverflow, hKo]; omega)
          (by
            simp; omega)
          hKf)
        (hK _ (by omega)) hw0f hw0 hw1f hw1 hroom
        (Room.add_of_le
          (by
            simp [BitVec.uaddOverflow, hto]; omega)
          (by
            simp; omega)
          ht)
        (fun h E' hE' hL' => ?_) (fun h _ E' hE' hL' => ?_) (fun h h' => absurd h' (by omega))
    all_goals
      rw [upd4_xq hW₀ hW₁ (by omega), show 16 + 2 * m = 2 * (m + 8) by omega, ylo_xq, yhi_xq,
        rounds_two, show (m / 8 + 1) * 128 + m % 8 * 16 = (m + 8) * 16 by omega,
        show 2 * (m + 8) = 2 * m + 16 by omega, show 2 * m + 16 + 1 = 2 * m + 17 by omega]
      have :=
        ih (m + 1)
          { S with
            mem :=
              (S.mem.storeAt (ms2.add (BitVec.ofNat 64 (m % 8 * 16)))
                    (BitVec.packLanes #v[wk W₀ (2 * m + 16), wk W₀ (2 * m + 17)])).storeAt
                (t2.add (BitVec.ofNat 64 ((m + 8) * 16)))
                (BitVec.packLanes #v[wk W₁ (2 * m + 16), wk W₁ (2 * m + 17)]) }
          E' (by omega) hL' hf' hfw' ht' hKf' hK' hR'
          (fun E'' hE'' hL'' => by
            have := hcont E'' (hE''.trans hE') hL''
            rw [pairMem2_succ hne'', show m + 8 + 1 = m + 1 + 8 by omega,
              show (m + 8) % 8 = m % 8 by omega, show 2 * (m + 8) = 2 * m + 16 by omega] at this
            exact this)
      rw [show 2 * (m + 1) = 2 * m + 2 by omega,
        show 16 + (2 * m + 2) = 2 * (m + 8) + 2 by omega] at this
      first
      | ( rw [show (m + 1) / 8 + 1 = m / 8 + 1 by omega,
            show (m + 1) % 8 = m % 8 + 1 by omega] at this
          exact this)
      | ( rw [show (m + 1) / 8 + 1 = m / 8 + 1 + 1 by omega, show (m + 1) % 8 = 0 by omega] at this
          exact this)

end Proof

end MLIR.Agave.Avx2.compress512
