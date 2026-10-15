module

public import MLIR.Run.Tactic
public import Firedancer.Lane.double_scalar_mul_base_split.Add
public import Firedancer.Lane.fd_ed25519_partial_dbl

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

@[expose] public section

namespace double_scalar_mul_base_split

open _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split
open Split
open _root_.MLIR.Firedancer.Avx512.fd_ed25519_double_scalar_mul_base (addDigit)

/-- The lift's runs from a block. -/
local notation "runD" => _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.runFrom

/-- Register `k` of the lift. -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.hty $k)

set_option hygiene false in
/-- One segment's `short`s at `k + o` of the search: the index, both loads and the `or`s. -/
local macro "chk_seg " o:num : tactic =>
  `(tactic|
    (
      step_pure [saddOverflow_ofNat64 (show k + $o < 2 ^ 63 by omega),
        uaddOverflow_ofNat64 (show k + $o < 2 ^ 64 by omega), (BitVec.ofNat_add k $o).symm]
      step_pure [Nat.mod_eq_of_lt (show k + $o < 2 ^ 64 by omega), Nat.mul_comm (k + $o) 2,
        show 2 * (k + $o) < 2 ^ 64 by omega]
      step_load
      step_pure [Nat.mod_eq_of_lt (show k + $o < 2 ^ 64 by omega), Nat.mul_comm (k + $o) 2,
        show 2 * (k + $o) < 2 ^ 64 by omega]
      step_load
      step_pure
      step_pure))

set_option hygiene false in
/-- `chk_seg` from the counter `k + 1`, the offset `o - 1` as the code adds it. -/
local macro "chk_seg2 " c:num o:num : tactic =>
  `(tactic|
    (
      step_pure [saddOverflow_ofNat64 (show k + 1 + $c < 2 ^ 63 by omega),
        (BitVec.ofNat_add (k + 1) $c).symm, show k + 1 + $c = k + $o by omega]
      step_pure [Nat.mod_eq_of_lt (show k + $o < 2 ^ 64 by omega), Nat.mul_comm (k + $o) 2,
        show 2 * (k + $o) < 2 ^ 64 by omega]
      step_load
      step_pure [Nat.mod_eq_of_lt (show k + $o < 2 ^ 64 by omega), Nat.mul_comm (k + $o) 2,
        show 2 * (k + $o) < 2 ^ 64 by omega]
      step_load
      step_pure
      step_pure))

/-! ### Digits -/

/-- A digit's `int`, sign-extended from its `short`. -/
theorem signExtend_ofInt16 {d : Int} (h : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) :
    BitVec.signExtend 32 (BitVec.ofInt 16 d) = BitVec.ofInt 32 d := by
  apply BitVec.eq_of_toInt_eq
  rw [BitVec.toInt_signExtend_of_le (by decide), toInt_ofInt16 h, BitVec.toInt_ofInt]
  simp only [Int.bmod_def]
  omega

/-- A positive odd digit `2k + 1` as an `int`. -/
theorem ofInt_pos_odd {k : Nat} : BitVec.ofInt 32 ((2 * k + 1 : Nat) : Int) =
    BitVec.ofNat 32 (2 * k + 1) := BitVec.ofInt_natCast ..

/-- A negative odd digit `-(2k + 1)` as an `int`. -/
theorem ofInt_neg_odd {k : Nat} : BitVec.ofInt 32 (-((2 * k + 1 : Nat) : Int)) =
    -BitVec.ofNat 32 (2 * k + 1) := by
  rw [BitVec.ofInt_neg, BitVec.ofInt_natCast]

/-- `j << 5` for a segment `j`. -/
theorem shl5_ofNat (j : Nat) : BitVec.ofNat 64 j <<< 5 = BitVec.ofNat 64 (32 * j) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.shiftLeft_eq]
  omega

/-- Back, unsigned. -/
theorem ushr5_ofNat {j : Nat} (h : j < 8) : BitVec.ofNat 64 (32 * j) >>> 5 = BitVec.ofNat 64 j := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ushiftRight, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.shiftRight_eq_div_pow]
  omega

/-- Back, signed. -/
theorem sshr5_ofNat {j : Nat} (h : j < 8) :
    (BitVec.ofNat 64 (32 * j)).sshiftRight 5 = BitVec.ofNat 64 j := by
  have : (BitVec.ofNat 64 (32 * j)).msb = false := by
    simp only [BitVec.msb_eq_decide, BitVec.toNat_ofNat, decide_eq_false_iff_not]; omega
  rw [BitVec.sshiftRight_eq_of_msb_false this]
  exact ushr5_ofNat h

/-- `zeroAt` spelled out over the eight segments. -/
theorem zeroAt_iff {w1 w2 : Vector Int 256} {k : Nat} :
    zeroAt w1 w2 k ↔
      (digit w1 k = 0 ∧ digit w2 k = 0) ∧ (digit w1 (k + 32) = 0 ∧ digit w2 (k + 32) = 0) ∧
        (digit w1 (k + 64) = 0 ∧ digit w2 (k + 64) = 0) ∧
          (digit w1 (k + 96) = 0 ∧ digit w2 (k + 96) = 0) ∧
            (digit w1 (k + 128) = 0 ∧ digit w2 (k + 128) = 0) ∧
              (digit w1 (k + 160) = 0 ∧ digit w2 (k + 160) = 0) ∧
                (digit w1 (k + 192) = 0 ∧ digit w2 (k + 192) = 0) ∧
                  digit w1 (k + 224) = 0 ∧ digit w2 (k + 224) = 0 := by
  constructor
  · intro h
    exact ⟨by simpa [Nat.add_comm] using h 0 (by decide),
      by simpa [Nat.add_comm] using h 1 (by decide), by simpa [Nat.add_comm] using h 2 (by decide),
      by simpa [Nat.add_comm] using h 3 (by decide), by simpa [Nat.add_comm] using h 4 (by decide),
      by simpa [Nat.add_comm] using h 5 (by decide), by simpa [Nat.add_comm] using h 6 (by decide),
      by simpa [Nat.add_comm] using h 7 (by decide)⟩
  · rintro ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ j hj
    rcases j with _ | _ | _ | _ | _ | _ | _ | _ | j
    all_goals first | omega | simpa [Nat.add_comm] using ‹_›

/-- A digit's `short` is `0` exactly when the digit is. -/
theorem short_eq_zero {w : Vector Int 256} {m : Int} (hw : Ref.fd_curve25519_scalar_wnaf.Digits m w)
    (hm : m ≤ 255) (k : Nat) : BitVec.ofInt 16 (digit w k) = 0#16 ↔ digit w k = 0 := by
  apply ofInt16_eq_zero
  unfold digit
  split
  · have := hw k ‹_›
    obtain ⟨-, h1, h2⟩ := this
    omega
  · omega

/-- The search's `nz` at bit `k`: the `or` of the segments' `short`s, as the code folds it. -/
abbrev nzAt (w1 w2 : Vector Int 256) (k : Nat) : BitVec 16 :=
  let a (o : Nat) := BitVec.ofInt 16 (digit w1 (k + o))
  let b (o : Nat) := BitVec.ofInt 16 (digit w2 (k + o))
  (a 224 ||| ((a 192 ||| ((a 160 ||| ((a 128 ||| ((a 96 ||| ((a 64 ||| ((a 32 |||
    (BitVec.ofInt 16 (digit w1 k) ||| BitVec.ofInt 16 (digit w2 k))) ||| b 32)) ||| b 64)) |||
    b 96)) ||| b 128)) ||| b 160)) ||| b 192)) ||| b 224

/-- `nz` is `0` exactly at a bit without digits. -/
theorem nzAt_eq_zero {w1 w2 : Vector Int 256} (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2) (k : Nat) :
    nzAt w1 w2 k = 0#16 ↔ zeroAt w1 w2 k := by
  simp only [nzAt, BitVec.or_eq_zero_iff, short_eq_zero hw1 (by decide),
    short_eq_zero hw2 (by decide), zeroAt_iff]
  constructor
  · rintro
      ⟨⟨a7, ⟨⟨a6, ⟨⟨a5, ⟨⟨a4, ⟨⟨a3, ⟨⟨a2, ⟨⟨a1, a0, b0⟩, b1⟩⟩, b2⟩⟩, b3⟩⟩, b4⟩⟩, b5⟩⟩, b6⟩⟩, b7⟩
    exact ⟨⟨a0, b0⟩, ⟨a1, b1⟩, ⟨a2, b2⟩, ⟨a3, b3⟩, ⟨a4, b4⟩, ⟨a5, b5⟩, ⟨a6, b6⟩, a7, b7⟩
  · rintro ⟨⟨a0, b0⟩, ⟨a1, b1⟩, ⟨a2, b2⟩, ⟨a3, b3⟩, ⟨a4, b4⟩, ⟨a5, b5⟩, ⟨a6, b6⟩, a7, b7⟩
    exact ⟨⟨a7, ⟨⟨a6, ⟨⟨a5, ⟨⟨a4, ⟨⟨a3, ⟨⟨a2, ⟨⟨a1, a0, b0⟩, b1⟩⟩, b2⟩⟩, b3⟩⟩, b4⟩⟩, b5⟩⟩, b6⟩⟩, b7⟩

/-! ### The loop's memory -/

/-- The main loop's memory below `r`'s stores: room for `r`, the slides, `bt`'s pointers `btp`,
the tables `ta` (at `tap`) and `bt[j]`'s, and their offsets and blocks apart from `r`'s. -/
structure Base (M : MemoryState) (r n1s n2s bt tap : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (ta : Nat → Quad) (tb : Nat → Nat → Quad) : Prop where
  roomR : M.QuadRoom r
  s1 : SlidesAt M n1s w1
  s2 : SlidesAt M n2s w2
  n1o : n1s.offset.toNat + 512 < 2 ^ 64
  n2o : n2s.offset.toNat + 512 < 2 ^ 64
  rn1 : r.id ≠ n1s.id
  rn2 : r.id ≠ n2s.id
  rbt : r.id ≠ bt.id
  rta : r.id ≠ tap.id
  rbp : ∀ j < 8, r.id ≠ (btp j).id
  tao : tap.offset.toNat + 192 * 32 < 2 ^ 64
  tap : ∀ k < 32, M.QuadFit (tap.add (BitVec.ofNat 64 (192 * k))) ∧
    M.readQuad (tap.add (BitVec.ofNat 64 (192 * k))) = ta k
  bto : bt.offset.toNat + 64 ≤ 2 ^ 64
  bt : ∀ j < 8, InBounds M (bt.add (BitVec.ofNat 64 (8 * j))) 64 ∧
    M.loadPtr (bt.add (BitVec.ofNat 64 (8 * j))) = .value (btp j)
  btpo : ∀ j < 8, (btp j).offset.toNat + 192 * 128 < 2 ^ 64
  btq : ∀ j < 8, ∀ k < 128, M.QuadFit ((btp j).add (BitVec.ofNat 64 (192 * k))) ∧
    M.readQuad ((btp j).add (BitVec.ofNat 64 (192 * k))) = tb j k

/-- A pointer loaded outside a point store's block: the pointer before it. -/
theorem loadPtr_storeQuad_of_id_ne {m : MemoryState} {p q : Pointer} {P : Quad} (h : p.id ≠ q.id) :
    (m.storeQuad p P).loadPtr q = m.loadPtr q := by
  have hd (a : BitVec 64) : (Range.of (p.add a) 512).Disjoint (Range.of q 64) :=
    Or.inl (by simpa [Range.of, Pointer.add] using h)
  have h0 : (Range.of p 512).Disjoint (Range.of q 64) := Or.inl (by simpa [Range.of] using h)
  simp only [MemoryState.storeQuad, MemoryState.storeVec, MemoryState.loadPtr_storeAt_disjoint, hd,
    h0]

/-- The slides past a point store into another block. -/
theorem slidesAt_storeQuad {m : MemoryState} {p q : Pointer} {P : Quad} {w : Vector Int 256}
    (h : SlidesAt m q w) (hne : p.id ≠ q.id) : SlidesAt (m.storeQuad p P) q w := fun k hk =>
  ⟨Fits.storeQuad (h k hk).1, by
    rw [MemoryState.readAt_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

/-- A positive digit's add. -/
theorem addDigit_pos {tbl : Nat → Quad} {r t : Quad} (k : Nat) :
    addDigit tbl ((2 * k + 1 : Nat) : Int) r t =
      (t, fd_ed25519_point_add_with_opts.spec t (tbl k) 1#32) := by
  unfold addDigit
  rw [show (((2 * k + 1 : Nat) : Int) / 2).toNat = k by omega, ite_eq_left (by omega)]

/-- A negative digit's add. -/
theorem addDigit_neg {tbl : Nat → Quad} {r t : Quad} (k : Nat) :
    addDigit tbl (-((2 * k + 1 : Nat) : Int)) r t =
      (t, fd_ed25519_point_sub_with_opts.spec t (tbl k) 1#32) := by
  unfold addDigit
  rw [show (-(-((2 * k + 1 : Nat) : Int)) / 2).toNat = k by omega, ite_eq_right (by omega),
    ite_eq_left (by omega)]

/-- No add at a zero digit. -/
theorem addDigit_zero {tbl : Nat → Quad} {r t : Quad} : addDigit tbl 0 r t = (r, t) := by
  simp [addDigit]

/-- `Base` past a point store into a block it does not read. -/
theorem Base.storeQuad {M : MemoryState} {r n1s n2s bt ta p : Pointer} {btp : Nat → Pointer}
    {w1 w2 : Vector Int 256} {TA : Nat → Quad} {TB : Nat → Nat → Quad} {P : Quad}
    (h : Base M r n1s n2s bt ta btp w1 w2 TA TB) (hpn1 : p.id ≠ n1s.id) (hpn2 : p.id ≠ n2s.id)
    (hpbt : p.id ≠ bt.id) (hpta : p.id ≠ ta.id) (hpbp : ∀ j < 8, p.id ≠ (btp j).id) :
    Base (M.storeQuad p P) r n1s n2s bt ta btp w1 w2 TA TB where
  roomR := h.roomR.storeQuad
  s1 := slidesAt_storeQuad h.s1 hpn1
  s2 := slidesAt_storeQuad h.s2 hpn2
  n1o := h.n1o
  n2o := h.n2o
  rn1 := h.rn1
  rn2 := h.rn2
  rbt := h.rbt
  rta := h.rta
  rbp := h.rbp
  tao := h.tao
  tap k hk := ⟨(h.tap k hk).1.storeQuad, by
    rw [MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Nat.add_comm] using hpta)]
    exact (h.tap k hk).2⟩
  bto := h.bto
  bt j hj := ⟨InBounds.storeQuad (h.bt j hj).1, by
    rw [loadPtr_storeQuad_of_id_ne (by simpa [Nat.add_comm] using hpbt)]; exact (h.bt j hj).2⟩
  btpo := h.btpo
  btq j hj k hk := ⟨(h.btq j hj k hk).1.storeQuad, by
    rw [MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Nat.add_comm] using hpbp j hj)]
    exact (h.btq j hj k hk).2⟩

/-- A point stored vector by vector, `P14` and `P25` first, as `^bb12` stores `t`. -/
theorem storeAt_14_25_03 {m : MemoryState} {t : Pointer} (ht : t.offset.toNat + 192 ≤ 2 ^ 64)
    (x y z : Wwl) :
    ((m.storeAt (t.add 64#64) (BitVec.packLanes x)).storeAt (t.add 128#64)
          (BitVec.packLanes y)).storeAt t (BitVec.packLanes z) =
      m.storeQuad t ⟨z, x, y⟩ := by
  have d10 := Range.disjoint_quad ht (a := 64) (b := 0) (by omega) (by omega) (by omega)
  have d20 := Range.disjoint_quad ht (a := 128) (b := 0) (by omega) (by omega) (by omega)
  rw [Pointer.add_zero_quad] at d10 d20
  rw [MemoryState.storeAt_swap (p := t.add 128#64) (q := t) d20,
    MemoryState.storeAt_swap (p := t.add 64#64) (q := t) d10]
  rfl

/-- `^bb12`'s stores of the segments' `t` into `t` and `r`, over `r`'s and `t`'s earlier
stores. -/
theorem bb12_mem {Y : MemoryState} {t r : Pointer} {D R T : Quad} (htr : t.id ≠ r.id)
    (ht : t.offset.toNat + 192 ≤ 2 ^ 64) (hr : r.offset.toNat + 192 ≤ 2 ^ 64) :
    (((((((Y.storeQuad t D).storeQuad r R).storeAt (t.add 64#64) (BitVec.packLanes T.P14)).storeAt
                  (t.add 128#64) (BitVec.packLanes T.P25)).storeAt t
              (BitVec.packLanes T.P03)).storeAt r (BitVec.packLanes T.P03)).storeAt (r.add 64#64)
          (BitVec.packLanes T.P14)).storeAt (r.add 128#64) (BitVec.packLanes T.P25) =
      (Y.storeQuad t T).storeQuad r T := by
  rw [storeAt_14_25_03 ht]
  show (((Y.storeQuad t D).storeQuad r R).storeQuad t T).storeQuad r T = _
  rw [MemoryState.storeQuad_comm htr.symm, MemoryState.storeQuad_storeQuad_self ht,
    MemoryState.storeQuad_storeQuad_self hr]


/-- `^bb25`, `n2slide[32j+i] = d2`'s add on `r` (`R` in memory) and `t` (`T` in registers): on to
`^bb37` with their `addDigit`. -/
theorem half2 (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA : Nat → Quad) (TB : Nat → Nat → Quad) (M : MemoryState)
    (hM0 : Base M r n1s n2s bt ta btp w1 w2 TA TB) (fl : BitVec 1) (hfl : fl = 1#1)
    (v326 v327 : ⟦.ptr⟧) (i j : Nat) (hj : j < 8) (R T : Quad) (d2 : Int)
    (hd2 : Ref.fd_curve25519_scalar_wnaf.Digit 255 d2)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : Live r n1s n2s bt tp fl v326 v327 i E)
    (hR :
      E ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := BitVec.ofInt 16 d2, %%1343 := T.P25,
        %%1344 := T.P14, %%1345 := T.P03])
    (hwf : S.WF) (hM : S.mem = M.storeQuad r R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          Live r n1s n2s bt tp fl v326 v327 i E' →
          (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%2192 := (addDigit (TB j) d2 R T).2.P25,
            %%2193 := (addDigit (TB j) d2 R T).2.P14,
            %%2194 := (addDigit (TB j) d2 R T).2.P03]) →
          S'.alloc = S.alloc → S'.WF → S'.mem = M.storeQuad r (addDigit (TB j) d2 R T).1 →
          (runD E' 37 S' >>= g) = K) :
    (runD E 25 S >>= g) = K := by
  obtain ⟨hz, hlo, hhi⟩ := hd2
  have hr : S.mem.QuadRoom r := by rw [hM]; exact hM0.roomR.storeQuad
  have hbt := hM0.bt j hj
  have hbt1 : InBounds S.mem (bt.add (BitVec.ofNat 64 (8 * j))) 64 := by
    rw [hM]; exact InBounds.storeQuad hbt.1
  have hbt2 : S.mem.loadPtr (bt.add (BitVec.ofNat 64 (8 * j))) = .value (btp j) := by
    rw [hM, loadPtr_storeQuad_of_id_ne (by simpa [Nat.add_comm] using hM0.rbt)]; exact hbt.2
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL hR
  block_init
  step_pure [signExtend_ofInt16 (show -2 ^ 15 ≤ d2 ∧ d2 < 2 ^ 15 by omega)]
  step_pure [slt_zero_ofInt16 (show -2 ^ 15 ≤ d2 ∧ d2 < 2 ^ 15 by omega)]
  finish_block
  case isTrue =>
    have hpos : 0 < d2 := by simpa [Nat.add_comm] using hbr
    obtain ⟨k, rfl⟩ : ∃ k : Nat, d2 = ((2 * k + 1 : Nat) : Int) :=
      ⟨(d2 / 2).toNat, by omega⟩
    have hk : k < 128 := by omega
    have he := hM0.btq j hj k hk
    refine add2_block r n1 ta n2 tb dec n1s n2s bt tp fl v326 v327 i j k hj hk T (TB j k) (btp j)
      S E g K hArgs ⟨by env_reads, by env_reads⟩
      (by rw [ofInt_pos_odd] at hE; env_reads) hM0.bto hbt1 hbt2 (by have := hM0.btpo j hj; omega)
      (hM0.rbp j hj) hM0.rbt hwf hr (by rw [hM]; exact he.1.storeQuad)
      (by
        rw [hM, MemoryState.readQuad_storeQuad_of_id_ne
          (by simpa [Nat.add_comm] using hM0.rbp j hj)]
        exact he.2) (fun _ E' h1 h2 h3 => ?_) (fun h => absurd hfl h)
    rw [addDigit_pos] at hK
    exact hK E' _ h1 h2 h3 rfl hwf.storeQuad (by
      rw [hM, MemoryState.storeQuad_storeQuad_self (by have := hM0.roomR.1; omega)])
  case isFalse =>
    have hnpos : ¬0 < d2 := by simpa [Nat.add_comm] using hbr
    block_init
    step_pure [ofInt16_slt_zero (show -2 ^ 15 ≤ d2 ∧ d2 < 2 ^ 15 by omega)]
    finish_block
    case isTrue =>
      have hneg : d2 < 0 := by simpa [Nat.add_comm] using hbr
      obtain ⟨k, rfl⟩ : ∃ k : Nat, d2 = -((2 * k + 1 : Nat) : Int) :=
        ⟨(-d2 / 2).toNat, by omega⟩
      have hk : k < 128 := by omega
      have he := hM0.btq j hj k hk
      refine sub2_block r n1 ta n2 tb dec n1s n2s bt tp fl v326 v327 i j k hj hk T (TB j k)
        (btp j) S E g K hArgs ⟨by env_reads, by env_reads⟩
        (by rw [ofInt_neg_odd] at hE; env_reads) hM0.bto hbt1 hbt2
        (by have := hM0.btpo j hj; omega) (hM0.rbp j hj) hM0.rbt hwf hr
        (by rw [hM]; exact he.1.storeQuad)
        (by
          rw [hM, MemoryState.readQuad_storeQuad_of_id_ne
            (by simpa [Nat.add_comm] using hM0.rbp j hj)]
          exact he.2) (fun _ E' h1 h2 h3 => ?_) (fun h => absurd hfl h)
      rw [addDigit_neg] at hK
      exact hK E' _ h1 h2 h3 rfl hwf.storeQuad (by
        rw [hM, MemoryState.storeQuad_storeQuad_self (by have := hM0.roomR.1; omega)])
    case isFalse =>
      have h0 : d2 = 0 := by
        have : ¬d2 < 0 := by simpa [Nat.add_comm] using hbr
        omega
      subst h0
      rw [addDigit_zero] at hK
      exact hK E S hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) rfl hwf hM

/-- `^bb13`, segment `j` at bit `i` on `r` (`R` in memory) and `t` (`T` in registers):
`n1slide[32j+i] = d1`'s add from `a_tbl`'s segment `j`; on to `^bb25` with their `addDigit`. -/
theorem half1 (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA : Nat → Quad) (TB : Nat → Nat → Quad) (M : MemoryState)
    (hM0 : Base M r n1s n2s bt ta btp w1 w2 TA TB) (fl : BitVec 1) (hfl : fl = 1#1)
    (v326 v327 : ⟦.ptr⟧) (i j : Nat) (hi : i < 32) (hj : j < 8) (R T : Quad)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : Live r n1s n2s bt tp fl v326 v327 i E)
    (hR : E ⊨ [%%485 := BitVec.ofNat 64 j, %%486 := T.P25, %%487 := T.P14, %%488 := T.P03])
    (hwf : S.WF) (hM : S.mem = M.storeQuad r R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          Live r n1s n2s bt tp fl v326 v327 i E' →
          (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := BitVec.ofInt 16 (digit w2 (32 * j + i)),
            %%1343 := (addDigit (fun k => TA (4 * j + k)) (digit w1 (32 * j + i)) R T).2.P25,
            %%1344 := (addDigit (fun k => TA (4 * j + k)) (digit w1 (32 * j + i)) R T).2.P14,
            %%1345 := (addDigit (fun k => TA (4 * j + k)) (digit w1 (32 * j + i)) R T).2.P03]) →
          S'.alloc = S.alloc → S'.WF →
          S'.mem =
            M.storeQuad r (addDigit (fun k => TA (4 * j + k)) (digit w1 (32 * j + i)) R T).1 →
          (runD E' 25 S' >>= g) = K) :
    (runD E 13 S >>= g) = K := by
  have hx : 32 * j + i < 256 := by omega
  have hs1 := slidesAt_storeQuad hM0.s1 hM0.rn1 (P := R) (32 * j + i) hx
  have hs2 := slidesAt_storeQuad hM0.s2 hM0.rn2 (P := R) (32 * j + i) hx
  rw [← hM] at hs1 hs2
  obtain ⟨hf1, hl1⟩ := hs1
  obtain ⟨hf2, hl2⟩ := hs2
  have hd1 := hw1 (32 * j + i) hx
  have hd2 := hw2 (32 * j + i) hx
  rw [show w1[32 * j + i] = digit w1 (32 * j + i) by simp [digit, hx]] at hl1 hd1
  rw [show w2[32 * j + i] = digit w2 (32 * j + i) by simp [digit, hx]] at hl2 hd2
  generalize digit w1 (32 * j + i) = d1 at hl1 hd1 hK
  generalize digit w2 (32 * j + i) = d2 at hl2 hd2 hK
  obtain ⟨hz, hlo, hhi⟩ := hd1
  have hr : S.mem.QuadRoom r := by rw [hM]; exact hM0.roomR.storeQuad
  have hn1o := hM0.n1o
  have hn2o := hM0.n2o
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL hR
  block_init
  step_pure [shl5_ofNat j, ushr5_ofNat hj, sshr5_ofNat hj]
  step_pure [saddOverflow_ofNat64 (show 32 * j + i < 2 ^ 63 by omega),
    uaddOverflow_ofNat64 (show 32 * j + i < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure [Nat.mod_eq_of_lt (show 32 * j + i < 2 ^ 64 by omega), Nat.mul_comm (32 * j + i) 2,
    show 2 * (32 * j + i) < 2 ^ 64 by omega]
  step_load consuming hf1 hl1
  step_pure [Nat.mod_eq_of_lt (show 32 * j + i < 2 ^ 64 by omega), Nat.mul_comm (32 * j + i) 2,
    show 2 * (32 * j + i) < 2 ^ 64 by omega]
  step_load with dd2 consuming hf2 hl2
  subst hdd2
  step_pure [signExtend_ofInt16 (show -2 ^ 15 ≤ d1 ∧ d1 < 2 ^ 15 by omega)]
  step_pure [slt_zero_ofInt16 (show -2 ^ 15 ≤ d1 ∧ d1 < 2 ^ 15 by omega)]
  finish_block
  case isTrue =>
    have hpos : 0 < d1 := by simpa [Nat.add_comm] using hbr
    obtain ⟨k, rfl⟩ : ∃ k : Nat, d1 = ((2 * k + 1 : Nat) : Int) :=
      ⟨(d1 / 2).toNat, by omega⟩
    have hk : k < 4 := by omega
    have he := hM0.tap (4 * j + k) (by omega)
    refine add1_block r n1 ta n2 tb dec n1s n2s bt tp fl v326 v327 i j k hj hk T (TA (4 * j + k))
      (BitVec.ofInt 16 d2) S E g K hArgs ⟨by env_reads, by env_reads⟩
      (by rw [ofInt_pos_odd] at hE; env_reads) hM0.tao hM0.rta hwf hr
      (by rw [hS, hM]; exact he.1.storeQuad)
      (by
        rw [hS, hM, MemoryState.readQuad_storeQuad_of_id_ne
          (by simpa [Nat.add_comm] using hM0.rta)]
        exact he.2) (fun _ E' h1 h2 h3 => ?_) (fun h => absurd hfl h)
    rw [addDigit_pos] at hK
    exact hK E' _ h1 h2 h3 (by rw [hS]) hwf.storeQuad (by
      rw [hS]; dsimp only
      rw [hM, MemoryState.storeQuad_storeQuad_self (by have := hM0.roomR.1; omega)])
  case isFalse =>
    have hnpos : ¬0 < d1 := by simpa [Nat.add_comm] using hbr
    block_init
    step_pure [ofInt16_slt_zero (show -2 ^ 15 ≤ d1 ∧ d1 < 2 ^ 15 by omega)]
    finish_block
    case isTrue =>
      have hneg : d1 < 0 := by simpa [Nat.add_comm] using hbr
      obtain ⟨k, rfl⟩ : ∃ k : Nat, d1 = -((2 * k + 1 : Nat) : Int) :=
        ⟨(-d1 / 2).toNat, by omega⟩
      have hk : k < 4 := by omega
      have he := hM0.tap (4 * j + k) (by omega)
      refine sub1_block r n1 ta n2 tb dec n1s n2s bt tp fl v326 v327 i j k hj hk T
        (TA (4 * j + k)) (BitVec.ofInt 16 d2) S E g K hArgs ⟨by env_reads, by env_reads⟩
        (by rw [ofInt_neg_odd] at hE; env_reads) hM0.tao hM0.rta hwf hr
        (by rw [hS, hM]; exact he.1.storeQuad)
        (by
          rw [hS, hM, MemoryState.readQuad_storeQuad_of_id_ne
            (by simpa [Nat.add_comm] using hM0.rta)]
          exact he.2) (fun _ E' h1 h2 h3 => ?_) (fun h => absurd hfl h)
      rw [addDigit_neg] at hK
      exact hK E' _ h1 h2 h3 (by rw [hS]) hwf.storeQuad (by
        rw [hS]; dsimp only
        rw [hM, MemoryState.storeQuad_storeQuad_self (by have := hM0.roomR.1; omega)])
    case isFalse =>
      have h0 : d1 = 0 := by
        have : ¬d1 < 0 := by simpa [Nat.add_comm] using hbr
        omega
      subst h0
      rw [addDigit_zero] at hK
      exact hK E S hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) (by rw [hS]) hwf
        (by rw [hS, hM])

/-- The segments' loop `for( int j=0; j<8; j++ )` from `^bb13` at `j` on `rt0`'s segments
`0 … j-1` done: at `^bb12` all eight done. -/
theorem jloop (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA TB : Nat → Quad) (M : MemoryState)
    (hM0 : Base M r n1s n2s bt ta btp w1 w2 TA (btab TB)) (fl : BitVec 1) (hfl : fl = 1#1)
    (v326 v327 : ⟦.ptr⟧) (i : Nat) (hi : i < 32) (rt0 : Quad × Quad)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫), j + m = 8 → j < 8 →
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get →
        Live r n1s n2s bt tp fl v326 v327 i E →
        (E ⊨ [%%485 := BitVec.ofNat 64 j, %%486 := (segAdds TA TB w1 w2 i j rt0).2.P25,
          %%487 := (segAdds TA TB w1 w2 i j rt0).2.P14,
          %%488 := (segAdds TA TB w1 w2 i j rt0).2.P03]) →
        S.WF → S.mem = M.storeQuad r (segAdds TA TB w1 w2 i j rt0).1 →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%2192 := (segAdds TA TB w1 w2 i 8 rt0).2.P25,
              %%2193 := (segAdds TA TB w1 w2 i 8 rt0).2.P14,
              %%2194 := (segAdds TA TB w1 w2 i 8 rt0).2.P03]) →
            S'.alloc = S.alloc → S'.WF → S'.mem = M.storeQuad r (segAdds TA TB w1 w2 i 8 rt0).1 →
            (runD E' 12 S' >>= g) = K) →
        (runD E 13 S >>= g) = K := by
  intro m
  induction m with
  | zero => intro j S E hm hj; omega
  | succ m ih =>
    intro j S E hm hj hArgs hL hR hwf hM hK
    refine half1 r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA (btab TB) M hM0 fl hfl v326 v327 i
      j hi hj _ _ hw1 hw2 S E g K hArgs hL hR hwf hM fun E₁ S₁ h₁ hL₁ hR₁ ha₁ hwf₁ hM₁ => ?_
    have hd2 := hw2 (32 * j + i) (by omega)
    rw [show w2[32 * j + i] = digit w2 (32 * j + i) by simp [digit, show 32 * j + i < 256 by omega]]
      at hd2
    refine half2 r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA (btab TB) M hM0 fl hfl v326 v327 i
      j hj _ _ _ hd2 S₁ E₁ g K h₁ hL₁ (by env_reads) hwf₁ hM₁
      fun E₂ S₂ h₂ hL₂ hR₂ ha₂ hwf₂ hM₂ => ?_
    obtain ⟨hC, hL⟩ := hL₂
    split_env hC hL hR₂
    block_init
    step_pure [saddOverflow_one64 (show j + 1 < 2 ^ 63 by omega),
      uaddOverflow_one64 (show j + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
    step_pure
    finish_block
    case isTrue =>
      have h8 : j + 1 = 8 := by
        have := congrArg BitVec.toNat hbr
        simp only [BitVec.toNat_ofNat] at this
        omega
      obtain rfl : j = 7 := by omega
      exact hK E S₂ hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) (ha₂.trans ha₁) hwf₂ hM₂
    case isFalse =>
      have h8 : j + 1 < 8 := by
        by_contra h
        exact hbr (by rw [show j + 1 = 8 by omega])
      exact ih (j + 1) S₂ E (by omega) h8 hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) hwf₂ hM₂
        fun E' S' h1 h2 h3 h4 h5 h6 => hK E' S' h1 h2 h3 (h4.trans (ha₂.trans ha₁)) h5 h6

/-- `^bb6`, the main loop at bit `i` on `r` (`R` in memory): `t = partial_dbl( r )`, the eight
segments' adds, `r` and `t` the result; then around at `i - 1`, or out at `i = 0`. -/
theorem iter_block (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA TB : Nat → Quad) (Y : MemoryState)
    (hY : Base Y r n1s n2s bt ta btp w1 w2 TA (btab TB)) (htY : Y.QuadRoom tp)
    (hrt : r.id ≠ tp.id) (htn1 : tp.id ≠ n1s.id) (htn2 : tp.id ≠ n2s.id) (htbt : tp.id ≠ bt.id)
    (htta : tp.id ≠ ta.id) (htbp : ∀ j < 8, tp.id ≠ (btp j).id) (fl : BitVec 1) (hfl : fl = 1#1)
    (v326 v327 : ⟦.ptr⟧) (i : Nat) (hi : i < 32) (R : Quad)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : Live r n1s n2s bt tp fl v326 v327 i E) (hwf : S.WF) (A : AllocState) (hA : S.alloc = A)
    (hM : S.mem = Y.storeQuad r R)
    (hback :
      ∀ i', i = i' + 1 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i' E' → S'.alloc = A → S'.WF →
            S'.mem = (Y.storeQuad tp (iter TA TB w1 w2 i R)).storeQuad r (iter TA TB w1 w2 i R) →
            (runD E' 6 S' >>= g) = K)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' → S'.alloc = A → S'.WF →
            S'.mem = (Y.storeQuad tp (iter TA TB w1 w2 i R)).storeQuad r (iter TA TB w1 w2 i R) →
            (runD E' 38 S' >>= g) = K) :
    (runD E 6 S >>= g) = K := by
  subst hfl
  have hr : S.mem.QuadFit r := by rw [hM]; exact MemoryState.QuadFit.storeQuad_self hY.roomR
  have ht : S.mem.QuadRoom tp := by rw [hM]; exact htY.storeQuad
  have hrv : S.mem.readQuad r = R := by rw [hM]; exact MemoryState.readQuad_storeQuad_self hY.roomR
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL
  block_init
  -- t = fd_ed25519_partial_dbl( r )
  step_call using fd_ed25519_partial_dbl.call_eq
  finish_block
  block_init
  step_load with x03
  step_load with x14
  step_load with x25
  finish_block
  have eD : (⟨x03, x14, x25⟩ : Quad) = fd_ed25519_partial_dbl.spec R := by
    rw [← hread_tp, hS, hx03, hx14, hx25]
    rfl
  have hAj : S.alloc = A := by rw [hS]; exact hA
  have hYD := hY.storeQuad (P := ⟨x03, x14, x25⟩) htn1 htn2 htbt htta htbp
  -- for( int j=0; j<8; j++ ) { … }
  refine jloop r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA TB _ hYD 1#1 rfl v326 v327 i hi
    (R, ⟨x03, x14, x25⟩) hw1 hw2 g K 8 0 S E (by omega) (by omega) hArgs
    ⟨by env_reads, by env_reads⟩ (by env_reads) hwf
    (by rw [hS]; dsimp only; rw [hM, MemoryState.storeQuad_comm hrt, ← eD]; rfl)
    fun E' S' h₁ hL' hR' ha' hwf' hM' => ?_
  generalize hRt : segAdds TA TB w1 w2 i 8 (R, ⟨x03, x14, x25⟩) = rt at hR' hM'
  have hr' : S'.mem.QuadRoom r := by rw [hM']; exact hYD.roomR.storeQuad
  have ht' : S'.mem.QuadRoom tp := by rw [hM']; exact htY.storeQuad.storeQuad
  obtain ⟨hC, hL⟩ := hL'
  split_env hC hL hR'
  block_init
  iterate 6 step_store
  have hmem :
      S.mem = (Y.storeQuad tp (iter TA TB w1 w2 i R)).storeQuad r (iter TA TB w1 w2 i R) := by
    rw [hS]
    dsimp only
    rw [hM', iter, ← eD, hRt]
    exact bb12_mem (Ne.symm hrt) htY.1 hY.roomR.1
  rcases Nat.eq_zero_or_pos i with hi0 | hi0
  · subst hi0
    step_pure
    step_pure
    finish_block
    exact hexit rfl E S hArgs ⟨by env_reads, by env_reads⟩ (by rw [hS]; exact ha'.trans hAj) hwf'
      hmem
  · step_pure [saddOverflow_neg_one64 hi0 (by omega), add_neg_one64 hi0 (by omega)]
    step_pure [slt_ofNat64 hi0 (by omega)]
    finish_block
    exact hback (i - 1) (by omega) E S hArgs ⟨by env_reads, by env_reads⟩
      (by rw [hS]; exact ha'.trans hAj) hwf' hmem

/-- The main loop from `^bb6` at bit `i` on `r` (`R` in memory, `Y` beneath it): at `^bb38` `r`
holds the ladder from `i`, the memory beneath it changed only in the frame. -/
theorem iloop (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (btp : Nat → Pointer)
    (w1 w2 : Vector Int 256) (TA TB : Nat → Quad) (N : Nat) (B : MemoryState)
    (hNt : N ≤ tp.id.id) (hrt : r.id ≠ tp.id) (htn1 : tp.id ≠ n1s.id) (htn2 : tp.id ≠ n2s.id)
    (htbt : tp.id ≠ bt.id) (htta : tp.id ≠ ta.id) (htbp : ∀ j < 8, tp.id ≠ (btp j).id)
    (fl : BitVec 1) (hfl : fl = 1#1) (v326 v327 : ⟦.ptr⟧)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2) (A : AllocState)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (R : Quad) (Y : MemoryState) (S : GlobalState) (E : ⟪Γ⟫), i < 32 →
      Base Y r n1s n2s bt ta btp w1 w2 TA (btab TB) → Y.QuadRoom tp → Y.eraseFrom N = B →
        E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
            (.value dec)).get →
          Live r n1s n2s bt tp fl v326 v327 i E → S.WF → S.alloc = A →
          S.mem = Y.storeQuad r R →
          (∀ (E' : ⟪Γ⟫) (S' : GlobalState) (Y' : MemoryState),
            E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
                (.value dec)).get →
              Live r n1s n2s bt tp fl v326 v327 0 E' → S'.alloc = A → S'.WF →
              Y'.eraseFrom N = B → S'.mem = Y'.storeQuad r (ladder TA TB w1 w2 i R) →
              (runD E' 38 S' >>= g) = K) →
          (runD E 6 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro R Y S E hi hY htY hYB hArgs hL hwf hA hM hK
    refine iter_block r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA TB Y hY htY hrt htn1 htn2 htbt
      htta htbp fl hfl v326 v327 0 hi R hw1 hw2 S E g K hArgs hL hwf A hA hM
      (fun _ h => absurd h (by omega)) fun _ E' S' h₁ h₂ h₃ h₄ h₅ => ?_
    refine hK E' S' _ h₁ h₂ h₃ h₄ ?_ h₅
    rw [MemoryState.eraseFrom_storeQuad_of_le hNt, hYB]
  | succ i ih =>
    intro R Y S E hi hY htY hYB hArgs hL hwf hA hM hK
    refine iter_block r n1 ta n2 tb dec n1s n2s bt tp btp w1 w2 TA TB Y hY htY hrt htn1 htn2 htbt
      htta htbp fl hfl v326 v327 (i + 1) hi R hw1 hw2 S E g K hArgs hL hwf A hA hM
      (fun i' hi' E' S' h₁ h₂ h₃ h₄ h₅ => ?_) fun h => absurd h (by omega)
    obtain rfl : i = i' := by omega
    exact ih _ _ S' E' (by omega) (hY.storeQuad htn1 htn2 htbt htta htbp) htY.storeQuad
      (by rw [MemoryState.eraseFrom_storeQuad_of_le hNt, hYB]) h₁ h₂ h₄ h₃ h₅ hK

/-- The search's constants: the segments' offsets, the counters' and `NULL`. -/
abbrev SConsts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := 18446744073709551614#64, %38 := 64#64, %40 := 128#64, %41 := 31#64, %42 := 32#64,
    %43 := 96#64, %44 := 160#64, %45 := 192#64, %46 := 224#64, %47 := 0#16,
    %48 := 18446744073709551615#64, %49 := 63#64, %50 := 95#64, %51 := 127#64, %52 := 159#64,
    %53 := 191#64, %54 := 223#64, %55 := Pointer.null, %61 := 0#64]

/-- The `short`s at `n` of slides in memory. -/
theorem slide_fact {m : MemoryState} {p : Pointer} {w : Vector Int 256} (h : SlidesAt m p w)
    (n : Nat) (hn : n < 256) :
    Fits m (p.add (BitVec.ofNat 64 (2 * n))) 16 ∧
      m.readAt (p.add (BitVec.ofNat 64 (2 * n))) 16 = BitVec.ofInt 16 (digit w n) := by
  rw [show digit w n = w[n] by simp [digit, hn]]
  exact h n hn

/-- The registers the entry block leaves to the search and the main loop. -/
abbrev PreLive (r n1s n2s bt tp : Pointer) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ SConsts E ∧
    E ⊨ [%197 := n1s, %198 := n2s, %199 := bt, %200 := tp, %208 := r.add 64#64]

-- a bit's 16 loads and the constants carried past them: over 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- `^bb1`, the search at bit `k`: on to `^bb2` if no segment has a digit there, else to `^bb4`
at `k`. -/
theorem bb1_block (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (w1 w2 : Vector Int 256)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2) (k : Nat) (hk : k < 32) (S : GlobalState)
    (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : PreLive r n1s n2s bt tp E) (hR : E ⊨ [%209 := BitVec.ofNat 64 k])
    (hs1 : SlidesAt S.mem n1s w1) (hs2 : SlidesAt S.mem n2s w2)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (hzero :
      zeroAt w1 w2 k →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            PreLive r n1s n2s bt tp E' → (E' ⊨ [%209 := BitVec.ofNat 64 k]) →
            (runD E' 2 S >>= g) = K)
    (hnz :
      ¬zeroAt w1 w2 k →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            PreLive r n1s n2s bt tp E' → (E' ⊨ [%323 := BitVec.ofNat 64 k]) →
            (runD E' 4 S >>= g) = K) :
    (runD E 1 S >>= g) = K := by
  have ⟨f10, l10⟩ := slide_fact hs1 k (by omega)
  have ⟨f20, l20⟩ := slide_fact hs2 k (by omega)
  have ⟨f132, l132⟩ := slide_fact hs1 (k + 32) (by omega)
  have ⟨f232, l232⟩ := slide_fact hs2 (k + 32) (by omega)
  have ⟨f164, l164⟩ := slide_fact hs1 (k + 64) (by omega)
  have ⟨f264, l264⟩ := slide_fact hs2 (k + 64) (by omega)
  have ⟨f196, l196⟩ := slide_fact hs1 (k + 96) (by omega)
  have ⟨f296, l296⟩ := slide_fact hs2 (k + 96) (by omega)
  have ⟨f1128, l1128⟩ := slide_fact hs1 (k + 128) (by omega)
  have ⟨f2128, l2128⟩ := slide_fact hs2 (k + 128) (by omega)
  have ⟨f1160, l1160⟩ := slide_fact hs1 (k + 160) (by omega)
  have ⟨f2160, l2160⟩ := slide_fact hs2 (k + 160) (by omega)
  have ⟨f1192, l1192⟩ := slide_fact hs1 (k + 192) (by omega)
  have ⟨f2192, l2192⟩ := slide_fact hs2 (k + 192) (by omega)
  have ⟨f1224, l1224⟩ := slide_fact hs1 (k + 224) (by omega)
  have ⟨f2224, l2224⟩ := slide_fact hs2 (k + 224) (by omega)
  obtain ⟨hC, hC', hL⟩ := hL
  split_env hC hC' hL hR
  block_init
  step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mul_comm k 2,
    show 2 * k < 2 ^ 64 by omega]
  step_load
  step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mul_comm k 2,
    show 2 * k < 2 ^ 64 by omega]
  step_load
  step_pure
  chk_seg 32
  chk_seg 64
  chk_seg 96
  chk_seg 128
  chk_seg 160
  chk_seg 192
  chk_seg 224
  step_pure
  finish_block
  case isTrue =>
    rw [hS]
    exact hzero ((nzAt_eq_zero hw1 hw2 k).mp hbr) E hArgs ⟨by env_reads, by env_reads, by env_reads⟩
      (by env_reads)
  case isFalse =>
    rw [hS]
    exact hnz (fun h => hbr ((nzAt_eq_zero hw1 hw2 k).mpr h)) E hArgs
      ⟨by env_reads, by env_reads, by env_reads⟩ (by env_reads)

-- a bit's 16 loads and the constants carried past them: over 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- `^bb2`, the search at bit `k` from the counter `k + 1`: on to `^bb3` if no segment has a digit
there, else to `^bb4` at `k`. -/
theorem bb2_block (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (w1 w2 : Vector Int 256)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2) (k : Nat) (hk : k < 32) (S : GlobalState)
    (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : PreLive r n1s n2s bt tp E) (hR : E ⊨ [%209 := BitVec.ofNat 64 (k + 1)])
    (hs1 : SlidesAt S.mem n1s w1) (hs2 : SlidesAt S.mem n2s w2)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (hzero :
      zeroAt w1 w2 k →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            PreLive r n1s n2s bt tp E' →
              (E' ⊨ [%209 := BitVec.ofNat 64 (k + 1), %265 := BitVec.ofNat 64 k]) →
            (runD E' 3 S >>= g) = K)
    (hnz :
      ¬zeroAt w1 w2 k →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            PreLive r n1s n2s bt tp E' → (E' ⊨ [%323 := BitVec.ofNat 64 k]) →
            (runD E' 4 S >>= g) = K) :
    (runD E 2 S >>= g) = K := by
  have ⟨f10, l10⟩ := slide_fact hs1 k (by omega)
  have ⟨f20, l20⟩ := slide_fact hs2 k (by omega)
  have ⟨f132, l132⟩ := slide_fact hs1 (k + 32) (by omega)
  have ⟨f232, l232⟩ := slide_fact hs2 (k + 32) (by omega)
  have ⟨f164, l164⟩ := slide_fact hs1 (k + 64) (by omega)
  have ⟨f264, l264⟩ := slide_fact hs2 (k + 64) (by omega)
  have ⟨f196, l196⟩ := slide_fact hs1 (k + 96) (by omega)
  have ⟨f296, l296⟩ := slide_fact hs2 (k + 96) (by omega)
  have ⟨f1128, l1128⟩ := slide_fact hs1 (k + 128) (by omega)
  have ⟨f2128, l2128⟩ := slide_fact hs2 (k + 128) (by omega)
  have ⟨f1160, l1160⟩ := slide_fact hs1 (k + 160) (by omega)
  have ⟨f2160, l2160⟩ := slide_fact hs2 (k + 160) (by omega)
  have ⟨f1192, l1192⟩ := slide_fact hs1 (k + 192) (by omega)
  have ⟨f2192, l2192⟩ := slide_fact hs2 (k + 192) (by omega)
  have ⟨f1224, l1224⟩ := slide_fact hs1 (k + 224) (by omega)
  have ⟨f2224, l2224⟩ := slide_fact hs2 (k + 224) (by omega)
  obtain ⟨hC, hC', hL⟩ := hL
  split_env hC hC' hL hR
  block_init
  step_pure [saddOverflow_neg_one64 (show 1 ≤ k + 1 by omega) (by omega),
    add_neg_one64 (show 1 ≤ k + 1 by omega) (by omega), Nat.add_sub_cancel]
  step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mul_comm k 2,
    show 2 * k < 2 ^ 64 by omega]
  step_load
  step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mul_comm k 2,
    show 2 * k < 2 ^ 64 by omega]
  step_load
  step_pure
  chk_seg2 31 32
  chk_seg2 63 64
  chk_seg2 95 96
  chk_seg2 127 128
  chk_seg2 159 160
  chk_seg2 191 192
  chk_seg2 223 224
  step_pure
  finish_block
  case isTrue =>
    rw [hS]
    exact hzero ((nzAt_eq_zero hw1 hw2 k).mp hbr) E hArgs ⟨by env_reads, by env_reads, by env_reads⟩
      (by env_reads)
  case isFalse =>
    rw [hS]
    exact hnz (fun h => hbr ((nzAt_eq_zero hw1 hw2 k).mpr h)) E hArgs
      ⟨by env_reads, by env_reads, by env_reads⟩ (by env_reads)

/-- `start` past a bit without digits. -/
theorem start_of_zero {w1 w2 : Vector Int 256} {i : Nat} (h : zeroAt w1 w2 (i + 1)) :
    start w1 w2 (i + 1) = start w1 w2 i := by
  simp [start, h]

/-- `start` at a bit with a digit. -/
theorem start_of_nz {w1 w2 : Vector Int 256} {i : Nat} (h : ¬zeroAt w1 w2 i) :
    start w1 w2 i = some i := by
  cases i <;> simp [start, h]

/-- `start` past bit `0` without digits: none. -/
theorem start_of_zero0 {w1 w2 : Vector Int 256} (h : zeroAt w1 w2 0) : start w1 w2 0 = none := by
  simp [start, h]

/-- `i - 2` on a counter at least `2`. -/
theorem sub2_64 {i : Nat} (h1 : 2 ≤ i) (h : i < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow 18446744073709551614#64 = false ∧
      BitVec.ofNat 64 i + 18446744073709551614#64 = BitVec.ofNat 64 (i - 2) := by
  have hn : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (18446744073709551614#64).toInt = -2 := by decide
  refine ⟨by simp [BitVec.saddOverflow, hn, hm]; omega, ?_⟩
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- The search `for( i=31; i>=0; i-- ) { … if( nz ) break; }` from `^bb1` at the counter
`2m + 1`, the bits above it without digits: on to `^bb4` at the bit it stops at, or out to
`^bb38`. -/
theorem search (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (w1 w2 : Vector Int 256)
    (hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 w1)
    (hw2 : Ref.fd_curve25519_scalar_wnaf.Digits 255 w2) (S : GlobalState)
    (hs1 : SlidesAt S.mem n1s w1) (hs2 : SlidesAt S.mem n2s w2)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hfound :
      ∀ j, j < 32 → start w1 w2 31 = some j →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            PreLive r n1s n2s bt tp E' → (E' ⊨ [%323 := BitVec.ofNat 64 j]) →
            (runD E' 4 S >>= g) = K)
    (hnone :
      start w1 w2 31 = none →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            PreLive r n1s n2s bt tp E' → (runD E' 38 S >>= g) = K) :
    ∀ m (E : ⟪Γ⟫), 2 * m + 1 ≤ 31 →
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get →
        PreLive r n1s n2s bt tp E → (E ⊨ [%209 := BitVec.ofNat 64 (2 * m + 1)]) →
        start w1 w2 31 = start w1 w2 (2 * m + 1) →
        (runD E 1 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro E hm hArgs hL hR hst
    refine bb1_block r n1 ta n2 tb dec n1s n2s bt tp w1 w2 hw1 hw2 1 (by omega) S E g K hArgs hL hR
      hs1 hs2 hn1o hn2o (fun hz E' h₁ h₂ h₃ => ?_) fun hz E' h₁ h₂ h₃ =>
        hfound 1 (by omega) (hst.trans (start_of_nz hz)) E' h₁ h₂ h₃
    refine bb2_block r n1 ta n2 tb dec n1s n2s bt tp w1 w2 hw1 hw2 0 (by omega) S E' g K h₁ h₂ h₃
      hs1 hs2 hn1o hn2o (fun hz' E'' g₁ g₂ g₃ => ?_) fun hz' E'' g₁ g₂ g₃ =>
        hfound 0 (by omega) (hst.trans ((start_of_zero hz).trans (start_of_nz hz'))) E'' g₁ g₂ g₃
    obtain ⟨hC, hC', hL'⟩ := g₂
    split_env hC hC' hL' g₃
    block_init
    step_pure
    step_pure
    finish_block
    exact hnone (hst.trans ((start_of_zero hz).trans (start_of_zero0 hz'))) E hArgs
      ⟨by env_reads, by env_reads, by env_reads⟩
  | succ m ih =>
    intro E hm hArgs hL hR hst
    refine bb1_block r n1 ta n2 tb dec n1s n2s bt tp w1 w2 hw1 hw2 (2 * m + 3) (by omega) S E g K
      hArgs hL hR hs1 hs2 hn1o hn2o (fun hz E' h₁ h₂ h₃ => ?_) fun hz E' h₁ h₂ h₃ =>
        hfound _ (by omega) (hst.trans (start_of_nz hz)) E' h₁ h₂ h₃
    refine bb2_block r n1 ta n2 tb dec n1s n2s bt tp w1 w2 hw1 hw2 (2 * m + 2) (by omega) S E' g K
      h₁ h₂ h₃ hs1 hs2 hn1o hn2o (fun hz' E'' g₁ g₂ g₃ => ?_) fun hz' E'' g₁ g₂ g₃ =>
        hfound _ (by omega) (hst.trans ((start_of_zero hz).trans (start_of_nz hz'))) E'' g₁ g₂ g₃
    obtain ⟨hC, hC', hL'⟩ := g₂
    split_env hC hC' hL' g₃
    block_init
    step_pure [(sub2_64 (show 2 ≤ 2 * m + 2 + 1 by omega) (by omega)).1,
      (sub2_64 (show 2 ≤ 2 * m + 2 + 1 by omega) (by omega)).2]
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    · exact ih E (by omega) hArgs ⟨by env_reads, by env_reads, by env_reads⟩ (by env_reads)
        (hst.trans ((start_of_zero hz).trans (start_of_zero hz')))

end double_scalar_mul_base_split

end

end MLIR.Firedancer.Lane
