module

public import Agave.Avx2.compress512.Basic

/-! The loops of `compress512`'s single-block path (`sha512_compress_x86_64_avx`, an odd block
count's first block): the schedule-and-rounds loop `^bb5` (with `^bb3`, `^bb4`) and the last
rounds `^bb6`. -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave

@[expose] public section

/-- `^bb2`'s state words `H`, and the pointers to words `1 … 7` of the state at `st`. -/
abbrev Old1 (st : Pointer) (H : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%3877 := H[0], %3878 := st.add 8#64, %3879 := H[1], %3880 := st.add 16#64, %3881 := H[2],
    %3882 := st.add 24#64, %3883 := H[3], %3884 := st.add 32#64, %3885 := H[4], %3886 :=
    st.add 40#64, %3887 := H[5], %3888 := st.add 48#64, %3889 := H[6], %3890 := st.add 56#64,
    %3891 := H[7]]

/-- What the single-block path's blocks read from before them. -/
abbrev Live1 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ Ptrs Kp ms t2 ms2 E ∧ Old1 st H E

/-- `^bb6` at round `i` on the working variables `v`. -/
abbrev hdr6 (i : Nat) (v : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%4074 := BitVec.ofNat 64 i, %4075 := v[7], %4076 := v[4], %4077 := v[6], %4078 := v[5], %4079 :=
    v[0], %4080 := v[1], %4081 := v[2], %4082 := v[3]]

/-- `^bb7` on the working variables `v` after the last round. -/
abbrev exit7 (v : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%4111 := v[5], %4112 := v[7], %4113 := v[6], %4114 := v[1], %4115 := v[2], %4116 := v[3],
    %4117 := v[0], %4118 := v[4]]

/-- `^bb5` at iteration `j` of round group `i` (`rounds_0_63_avx`), `k` the index of the next
pair of `K`, the schedule words `x` and working variables `v`. -/
abbrev hdr5 (i j k : Nat) (x0 x1 x2 x3 x4 x5 x6 x7 : Vector (BitVec 64) 2)
    (v : Vector (BitVec 64) 8) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%3958 := BitVec.ofNat 32 i, %3975 := BitVec.ofNat 64 k, %3976 := BitVec.ofNat 64 j, %3977 := x1,
    %3978 := x0, %3979 := x5, %3980 := x4, %3981 := x7, %3982 := x2, %3983 := x3, %3984 := x6,
    %3985 := v[7], %3986 := v[4], %3987 := v[6], %3988 := v[5], %3989 := v[0], %3990 := v[1],
    %3991 := v[2], %3992 := v[3]]

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

-- `^bb6`'s 36 steps
set_option maxHeartbeats 400000 in
/-- `^bb6`'s round `i` (`sha_round(s, ms[i & 0xf])`): to `^bb7` after round `79`, else round
`i + 1`. -/
theorem iter6 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (i : Nat) (hi : i < 80)
    (v : Vector (BitVec 64) 8) (w : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hL : Live1 st Kp ms t2 ms2 H E)
    (hmo : ms.offset = 0) (hw : S.mem.readAt (ms.add (BitVec.ofNat 64 (i % 16 * 8))) 64 = w)
    (hwf : Fits S.mem (ms.add (BitVec.ofNat 64 (i % 16 * 8))) 64)
    (hexit :
      i + 1 = 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live1 st Kp ms t2 ms2 H E' →
            (compress512.runFrom (exit7 (wround v w) E') 7 S >>= g) = K)
    (hback :
      i + 1 < 80 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live1 st Kp ms t2 ms2 H E' →
            (compress512.runFrom (hdr6 (i + 1) (wround v w) E') 6 S >>= g) = K) :
    (compress512.runFrom (hdr6 i v E) 6 S >>= g) = K := by
  obtain ⟨hC, hP, hO⟩ := hL
  block_init
  -- sha_round(current_state, ms[i & 0xf]);
  step_pure [and_15]
  step_pure [saddOverflow_ofNat (i := i) (k := 1) (by omega),
    uaddOverflow_ofNat (i := i) (k := 1) (by omega), ← BitVec.ofNat_add]
  step_pure [gepDyn_slot hmo (show i % 16 * 8 < 2 ^ 63 by omega) (by omega)]
  step_load consuming hw
  round1 u1 a1 e1
  have ev : wround v w = #v[a1, v[0], v[1], v[2], e1, v[4], v[5], v[6]] := by
    rw [ha1, he1, hu1]; rfl
  rw [ev] at hexit hback
  -- for i in 64..80
  step_pure
  finish_block
  · step_loop using hexit (eq_of_ofNat_eq hbr (by omega) (by decide))
  · step_loop using
      hback
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

-- `^bb5`'s 80 steps, twelve of them `fshl`s of half a second each
set_option maxHeartbeats 2000000 in
/-- `^bb5`'s iteration `j` of round group `i`: the schedule's next pair `y` stored at `ms[j]`, two
rounds on `ms[2 j]`, `ms[2 j + 1]`; then iteration `j + 1`, or through `^bb3` the next group's
first (`^bb4`) or, after the fourth group, `^bb6`. -/
theorem iter5 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (i j k : Nat) (hi : i < 4)
    (hj : j < 8) (hk : k + 2 ≤ 80) (x0 x1 x2 x3 x4 x5 x6 x7 : Vector (BitVec 64) 2)
    (v : Vector (BitVec 64) 8) (k0 k1 w0 w1 : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (hL : Live1 st Kp ms t2 ms2 H E)
    (hmo : ms.offset = 0) (hKo : Kp.offset = 0)
    (hkf : Fits S.mem (Kp.add (BitVec.ofNat 64 (k * 8))) 128)
    (hk2 : S.mem.readAt (Kp.add (BitVec.ofNat 64 (k * 8))) 128 = BitVec.packLanes #v[k0, k1])
    (hw0f : Fits S.mem (ms.add (BitVec.ofNat 64 (j * 16))) 64)
    (hw0 : S.mem.readAt (ms.add (BitVec.ofNat 64 (j * 16))) 64 = w0)
    (hw1f : Fits S.mem (ms.add (BitVec.ofNat 64 (j * 16) + 8#64)) 64)
    (hw1 : S.mem.readAt (ms.add (BitVec.ofNat 64 (j * 16) + 8#64)) 64 = w1)
    (hroom : Room S.mem (ms.add (BitVec.ofNat 64 (j * 16))) 128)
    (hnext :
      j + 1 < 8 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live1 st Kp ms t2 ms2 H E' →
            (compress512.runFrom
                  (hdr5 i (j + 1) (k + 2) x1 x2 x3 x4 x5 x6 x7 (upd2 x0 x1 x4 x5 x7)
                    (wround (wround v w0) w1) E')
                  5
                  { S with
                    mem :=
                      S.mem.storeAt (ms.add (BitVec.ofNat 64 (j * 16)))
                        (BitVec.packLanes (ypair #v[k0, k1] (upd2 x0 x1 x4 x5 x7))) } >>=
                g) =
              K)
    (hgroup :
      j + 1 = 8 →
        i + 1 < 4 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live1 st Kp ms t2 ms2 H E' →
            (compress512.runFrom
                  (hdr5 (i + 1) 0 (k + 2) x1 x2 x3 x4 x5 x6 x7 (upd2 x0 x1 x4 x5 x7)
                    (wround (wround v w0) w1) E')
                  5
                  { S with
                    mem :=
                      S.mem.storeAt (ms.add (BitVec.ofNat 64 (j * 16)))
                        (BitVec.packLanes (ypair #v[k0, k1] (upd2 x0 x1 x4 x5 x7))) } >>=
                g) =
              K)
    (hdone :
      j + 1 = 8 →
        i + 1 = 4 →
        ∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live1 st Kp ms t2 ms2 H E' →
            (compress512.runFrom (hdr6 64 (wround (wround v w0) w1) E') 6
                  { S with
                    mem :=
                      S.mem.storeAt (ms.add (BitVec.ofNat 64 (j * 16)))
                        (BitVec.packLanes (ypair #v[k0, k1] (upd2 x0 x1 x4 x5 x7))) } >>=
                g) =
              K) :
    (compress512.runFrom (hdr5 i j k x0 x1 x2 x3 x4 x5 x6 x7 v E) 5 S >>= g) = K := by
  obtain ⟨hC, hP, hO⟩ := hL
  block_init
  step_pure [saddOverflow_ofNat (i := j) (k := 1) (by omega),
    uaddOverflow_ofNat (i := j) (k := 1) (by omega), ← BitVec.ofNat_add]
  -- let t = _mm_loadu_si128(K64.as_ptr().add(k64_idx).cast());
  step_pure [gepDyn_slot hKo (show k * 8 < 2 ^ 63 by omega) (by omega)]
  step_load with kv consuming hk2
  -- let y = sha512_update_x_avx(x, k64);
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
  have exn : xn = upd2 x0 x1 x4 x5 x7 := by
    rw [hxn, hx0t3s0, hs1, hx0t3, hs0, ht0, ht3]
    ext l hl
    rcases l with _ | _ | l
    · simp [upd2, ssig0_vcode, ssig1_vcode]
    · simp [upd2, ssig0_vcode, ssig1_vcode]
    · omega
  have ey : y = ypair #v[k0, k1] xn := by
    rw [hy, hkv]
    ext l hl
    rcases l with _ | _ | l
    · simp [ypair]
    · simp [ypair]
    · omega
  clear hxn hx0t3s0 hs1 hx0t3 hs0 ht0 ht3 hy hkv
  subst exn ey
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
  -- ms[j] = y;
  step_pure [gepDyn_slot hmo (show j * 16 < 2 ^ 63 by omega) (by omega)]
  step_store
  -- k64_idx += 2;
  step_pure [← BitVec.ofNat_add]
  step_pure
  finish_block
  · have hj7 : j = 7 := by
      have := eq_of_ofNat_eq hbr (by omega) (by decide); omega
    block_init
    step_pure [saddOverflow_ofNat32 (i := i) (k := 1) (by omega),
      uaddOverflow_ofNat32 (i := i) (k := 1) (by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    · step_loop using hdone (by omega) (eq_of_ofNat32_eq hbr (by omega) (by decide))
    · block_init
      finish_block
      step_loop using
        hgroup (by omega)
          (by
            have := mt (congrArg (BitVec.ofNat 32)) hbr; omega)
  · step_loop using
      hnext
        (by
          have := mt (congrArg (BitVec.ofNat 64)) hbr; omega)

-- one `iter5` per case, each elaborating its continuations
set_option maxHeartbeats 400000 in
/-- Iterations `m … 31` of `^bb5` (`rounds_0_63_avx`), `ms` holding the schedule's window from
pair `m`: the pairs `m + 8 …` stored, rounds `2 m … 63`, then `^bb6`. -/
public theorem loop5 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (W : Nat → BitVec 64)
    (H₀ : Vector (BitVec 64) 8) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hmo : ms.offset = 0) (hKo : Kp.offset = 0) (hne : ms.id ≠ Kp.id) (hW : Sched W) :
    ∀ n m (S : GlobalState) (E : ⟪Γ⟫),
      m + n + 1 = 32 →
        Live1 st Kp ms t2 ms2 H E →
        Fits S.mem ms 1024 →
        Fits S.mem Kp 5120 →
        KPairs S.mem Kp →
        HoldsR S.mem ms W (2 * m) (2 * m + 16) →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live1 st Kp ms t2 ms2 H E' →
            (compress512.runFrom (hdr6 64 (rounds W 64 H₀) E') 6
                  { S with mem := pairsMem ms W (m + 8) (n + 1) S.mem } >>=
                g) =
              K) →
        (compress512.runFrom
              (hdr5 (m / 8) (m % 8) (16 + 2 * m) (xp W m) (xp W (m + 1)) (xp W (m + 2))
                (xp W (m + 3)) (xp W (m + 4)) (xp W (m + 5)) (xp W (m + 6)) (xp W (m + 7))
                (rounds W (2 * m) H₀) E)
              5 S >>=
            g) =
          K := by
  have hw (S : GlobalState) (m : Nat) (hf : Fits S.mem ms 1024)
    (hR : HoldsR S.mem ms W (2 * m) (2 * m + 16)) :
    (Fits S.mem (ms.add (BitVec.ofNat 64 (m % 8 * 16))) 64 ∧
        S.mem.readAt (ms.add (BitVec.ofNat 64 (m % 8 * 16))) 64 = wk W (2 * m)) ∧
      (Fits S.mem (ms.add (BitVec.ofNat 64 (m % 8 * 16) + 8#64)) 64 ∧
        S.mem.readAt (ms.add (BitVec.ofNat 64 (m % 8 * 16) + 8#64)) 64 = wk W (2 * m + 1)) ∧
      Room S.mem (ms.add (BitVec.ofNat 64 (m % 8 * 16))) 128 := by
    have e0 := hR (2 * m) (by omega) (by omega)
    have e1 := hR (2 * m + 1) (by omega) (by omega)
    rw [show 2 * m % 16 * 8 = m % 8 * 16 by omega] at e0
    rw [show (2 * m + 1) % 16 * 8 = m % 8 * 16 + 8 by omega, BitVec.ofNat_add] at e1
    refine ⟨⟨Fits.add_of_le ?_ ?_ hf, e0⟩, ⟨?_, e1⟩, Room.add_of_le ?_ ?_ hf.room⟩
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
  have hst (S : GlobalState) (m : Nat) (hm : m < 32) (hf : Fits S.mem ms 1024)
    (hKf : Fits S.mem Kp 5120) (hK : KPairs S.mem Kp)
    (hR : HoldsR S.mem ms W (2 * m) (2 * m + 16)) :
    Fits
        (S.mem.storeAt (ms.add (BitVec.ofNat 64 (m % 8 * 16)))
          (BitVec.packLanes #v[wk W (2 * m + 16), wk W (2 * m + 17)]))
        ms 1024 ∧
      Fits
        (S.mem.storeAt (ms.add (BitVec.ofNat 64 (m % 8 * 16)))
          (BitVec.packLanes #v[wk W (2 * m + 16), wk W (2 * m + 17)]))
        Kp 5120 ∧
      KPairs
        (S.mem.storeAt (ms.add (BitVec.ofNat 64 (m % 8 * 16)))
          (BitVec.packLanes #v[wk W (2 * m + 16), wk W (2 * m + 17)]))
        Kp ∧
      HoldsR
        (S.mem.storeAt (ms.add (BitVec.ofNat 64 (m % 8 * 16)))
          (BitVec.packLanes #v[wk W (2 * m + 16), wk W (2 * m + 17)]))
        ms W (2 * (m + 1)) (2 * (m + 1) + 16) := by
    refine ⟨hf.storeAt, hKf.storeAt, fun k hk => ?_, ?_⟩
    · rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using hne))]
      exact hK k hk
    · have :=
        HoldsR.pairsMem (p := m + 8) (n := 1) (lo := 2 * m) hmo hf.inBounds (by omega) (by omega)
          (fun t h1 h2 => hR t h1 (by omega))
      rw [show max (2 * m) (2 * (m + 8 + 1) - 16) = 2 * (m + 1) by omega,
        show 2 * (m + 8 + 1) = 2 * (m + 1) + 16 by omega] at this
      simpa [pairsMem, show (m + 8) % 8 = m % 8 by omega,
        show 2 * (m + 8) = 2 * m + 16 by omega] using this
  intro n
  induction n with
  | zero =>
    intro m S E hm hL hf hKf hK hR hcont
    obtain ⟨⟨hw0f, hw0⟩, ⟨hw1f, hw1⟩, hroom⟩ := hw S m hf hR
    refine
      iter5 st Kp ms t2 ms2 H (m / 8) (m % 8) (16 + 2 * m) (by omega) (by omega) (by omega) _ _ _ _
        _ _ _ _ _ _ _ _ _ S E g K hL hmo hKo
        (Fits.add_of_le
          (by
            simp [BitVec.uaddOverflow, hKo]; omega)
          (by
            simp; omega)
          hKf)
        (hK _ (by omega)) hw0f hw0 hw1f hw1 hroom (fun h => absurd h (by omega))
        (fun _ h => absurd h (by omega)) (fun _ _ E' hE' hL' => ?_)
    rw [upd2_xp hW (by omega), ypair_xp W (p := m + 8) (by omega), rounds_two,
      show 2 * m + 2 = 64 by omega, show 2 * (m + 8) = 2 * m + 16 by omega,
      show 2 * m + 16 + 1 = 2 * m + 17 by omega]
    have := hcont E' hE' hL'
    simpa [pairsMem, show (m + 8) % 8 = m % 8 by omega,
      show 2 * (m + 8) = 2 * m + 16 by omega] using this
  | succ n ih =>
    intro m S E hm hL hf hKf hK hR hcont
    obtain ⟨⟨hw0f, hw0⟩, ⟨hw1f, hw1⟩, hroom⟩ := hw S m hf hR
    obtain ⟨hf', hKf', hK', hR'⟩ := hst S m (by omega) hf hKf hK hR
    refine
      iter5 st Kp ms t2 ms2 H (m / 8) (m % 8) (16 + 2 * m) (by omega) (by omega) (by omega) _ _ _ _
        _ _ _ _ _ _ _ _ _ S E g K hL hmo hKo
        (Fits.add_of_le
          (by
            simp [BitVec.uaddOverflow, hKo]; omega)
          (by
            simp; omega)
          hKf)
        (hK _ (by omega)) hw0f hw0 hw1f hw1 hroom (fun h E' hE' hL' => ?_)
        (fun h _ E' hE' hL' => ?_) (fun h h' => absurd h' (by omega))
    all_goals
      rw [upd2_xp hW (by omega), ypair_xp W (p := m + 8) (by omega), rounds_two,
        show 2 * (m + 8) = 2 * m + 16 by omega, show 2 * m + 16 + 1 = 2 * m + 17 by omega]
      have :=
        ih (m + 1)
          { S with
            mem :=
              S.mem.storeAt (ms.add (BitVec.ofNat 64 (m % 8 * 16)))
                (BitVec.packLanes #v[wk W (2 * m + 16), wk W (2 * m + 17)]) }
          E' (by omega) hL' hf' hKf' hK' hR'
          (fun E'' hE'' hL'' => by
            have := hcont E'' (hE''.trans hE') hL''
            rw [pairsMem_succ, show m + 8 + 1 = m + 1 + 8 by omega,
              show (m + 8) % 8 = m % 8 by omega, show 2 * (m + 8) = 2 * m + 16 by omega] at this
            exact this)
      rw [show 2 * (m + 1) = 2 * m + 2 by omega] at this
      first
      | ( rw [show (m + 1) / 8 = m / 8 by omega, show (m + 1) % 8 = m % 8 + 1 by omega,
            show 16 + (2 * m + 2) = 16 + 2 * m + 2 by omega] at this
          exact this)
      | ( rw [show (m + 1) / 8 = m / 8 + 1 by omega, show (m + 1) % 8 = 0 by omega,
            show 16 + (2 * m + 2) = 16 + 2 * m + 2 by omega] at this
          exact this)

/-- Rounds `i … 79` (`rounds_64_79`) from `ms`, which holds their words: to `^bb7` on the working
variables after round `79`. -/
public theorem loop6 (st Kp ms t2 ms2 : Pointer) (H : Vector (BitVec 64) 8) (W : Nat → BitVec 64)
    (H₀ : Vector (BitVec 64) 8) (S : GlobalState) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hmo : ms.offset = 0) (hf : Fits S.mem ms 1024)
    (hR : HoldsR S.mem ms W 64 80) :
    ∀ n i (E : ⟪Γ⟫),
      i + n + 1 = 80 →
        64 ≤ i →
        Live1 st Kp ms t2 ms2 H E →
        (∀ E' : ⟪Γ⟫,
          E'.args = E.args →
            Live1 st Kp ms t2 ms2 H E' →
            (compress512.runFrom (exit7 (rounds W 80 H₀) E') 7 S >>= g) = K) →
        (compress512.runFrom (hdr6 i (rounds W i H₀) E) 6 S >>= g) = K := by
  have hfw (i : Nat) : Fits S.mem (ms.add (BitVec.ofNat 64 (i % 16 * 8))) 64 :=
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
      iter6 st Kp ms t2 ms2 H i (by omega) _ _ S E g K hL hmo (hR i hi64 (by omega)) (hfw i)
        (fun h E' hE' hL' => ?_) (fun h => absurd h (by omega))
    rw [← rounds_succ_wround, show i + 1 = 80 by omega]
    exact hK E' hE' hL'
  | succ n ih =>
    intro i E hi hi64 hL hK
    refine
      iter6 st Kp ms t2 ms2 H i (by omega) _ _ S E g K hL hmo (hR i hi64 (by omega)) (hfw i)
        (fun h => absurd h (by omega)) (fun h E' hE' hL' => ?_)
    rw [← rounds_succ_wround]
    exact ih (i + 1) E' (by omega) (by omega) hL' fun E'' hE'' hL'' => hK E'' (hE''.trans hE') hL''

end Proof

end MLIR.Agave.Avx2.compress512
