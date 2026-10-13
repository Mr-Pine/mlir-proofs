module

public import Agave.Common.Tactics
public import Agave.Serial.Mlir.mul
public import Agave.Serial.mul.Objects
public import Firedancer.Common.Tactics
public meta import Lean.Elab.Tactic
public import MLIR.Run.Tactic
public meta import MLIR.Run.Tactic.Util
import Mathlib.Tactic.IntervalCases
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `vartime_double_base::mul`'s loops, block by block: the start index search, the main loop
`r = (2 r ± A_i ± B_j).as_projective()` from it down to `0`, and the final `r.as_extended()`. -/

namespace MLIR.Agave.Serial.mul

/-! ### Slots, registers and facts -/

/-- The function's pointers: `table_B`'s global, then its slots in `alloca` order: the inlined
adds' temporaries (affine add, affine sub, Niels sub), the four `t.as_extended()`, `t`, `r`,
`table_A` and the NAFs. -/
public structure Slots where
  table_B : Pointer
  aaZ2 : Pointer
  aaTxy2d : Pointer
  aaMM : Pointer
  aaPP : Pointer
  aaYmX : Pointer
  aaYpX : Pointer
  asZ2 : Pointer
  asTxy2d : Pointer
  asMP : Pointer
  asPM : Pointer
  asYmX : Pointer
  asYpX : Pointer
  nsZZ2 : Pointer
  nsZZ : Pointer
  nsTT2d : Pointer
  nsMP : Pointer
  nsPM : Pointer
  nsYmX : Pointer
  nsYpX : Pointer
  xBm : Pointer
  xBp : Pointer
  xAm : Pointer
  xAp : Pointer
  t : Pointer
  r : Pointer
  table_A : Pointer
  b_naf : Pointer
  a_naf : Pointer

/-- `σ`'s slots are `B`'s, from its counter on; `table_B`'s block is below it. -/
public structure Slots.At (σ : Slots) (B : GlobalState) : Prop where
  table_B : σ.table_B.offset = 0 ∧ σ.table_B.id.id < B.alloc.nextFreeBlock
  aaZ2 : σ.aaZ2 = B.slot 0
  aaTxy2d : σ.aaTxy2d = B.slot 1
  aaMM : σ.aaMM = B.slot 2
  aaPP : σ.aaPP = B.slot 3
  aaYmX : σ.aaYmX = B.slot 4
  aaYpX : σ.aaYpX = B.slot 5
  asZ2 : σ.asZ2 = B.slot 6
  asTxy2d : σ.asTxy2d = B.slot 7
  asMP : σ.asMP = B.slot 8
  asPM : σ.asPM = B.slot 9
  asYmX : σ.asYmX = B.slot 10
  asYpX : σ.asYpX = B.slot 11
  nsZZ2 : σ.nsZZ2 = B.slot 12
  nsZZ : σ.nsZZ = B.slot 13
  nsTT2d : σ.nsTT2d = B.slot 14
  nsMP : σ.nsMP = B.slot 15
  nsPM : σ.nsPM = B.slot 16
  nsYmX : σ.nsYmX = B.slot 17
  nsYpX : σ.nsYpX = B.slot 18
  xBm : σ.xBm = B.slot 19
  xBp : σ.xBp = B.slot 20
  xAm : σ.xAm = B.slot 21
  xAp : σ.xAp = B.slot 22
  t : σ.t = B.slot 23
  r : σ.r = B.slot 24
  table_A : σ.table_A = B.slot 25
  b_naf : σ.b_naf = B.slot 26
  a_naf : σ.a_naf = B.slot 27

/-- The registers the function's loops read: constants, the panics' locations and the slots. -/
public abbrev BaseRegs (σ : Slots) (locA locB : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%135 := 8#64, %137 := 18446744073709551615#64, %138 := 0#8, %139 := 0#64, %142 := 1#64,
    %143 := 16#8, %144 := locA, %145 := 255#8, %146 := 64#64, %147 := locB, %148 := σ.table_B,
    %149 := σ.aaZ2, %150 := σ.aaTxy2d, %151 := σ.aaMM, %152 := σ.aaPP, %153 := σ.aaYmX, %154 :=
    σ.aaYpX, %155 := σ.asZ2, %156 := σ.asTxy2d, %157 := σ.asMP, %158 := σ.asPM, %159 := σ.asYmX,
    %160 := σ.asYpX, %161 := σ.nsZZ2, %162 := σ.nsZZ, %163 := σ.nsTT2d, %164 := σ.nsMP, %165 :=
    σ.nsPM, %166 := σ.nsYmX, %167 := σ.nsYpX, %168 := σ.xBm, %169 := σ.xBp, %170 := σ.xAm, %171 :=
    σ.xAp, %172 := σ.t, %173 := σ.r, %174 := σ.table_A, %175 := σ.b_naf, %176 := σ.a_naf]

/-- The main loop's registers, its counter aside: `BaseRegs` and the coordinates' pointers. -/
public abbrev LoopRegs (σ : Slots) (locA locB : Pointer) (E : ⟪Γ⟫) : Prop :=
  BaseRegs σ locA locB E ∧
    (E ⊨ [%183 := σ.r.add 40#64, %184 := σ.r.add 80#64, %185 := σ.xAm.add 40#64, %186 :=
      σ.xAm.add 120#64, %187 := σ.xAm.add 80#64, %188 := σ.t.add 40#64, %189 := σ.t.add 80#64,
      %190 := σ.t.add 120#64, %191 := σ.xBp.add 40#64, %192 := σ.xBp.add 120#64, %193 :=
      σ.xBp.add 80#64, %194 := σ.xBm.add 40#64, %195 := σ.xBm.add 120#64, %196 := σ.xBm.add 80#64])

/-- The registers the start search reads: `BaseRegs`, and `^bb2`'s `ONE` global and its width. -/
public abbrev SearchRegs (σ : Slots) (locA locB one : Pointer) (E : ⟪Γ⟫) : Prop :=
  BaseRegs σ locA locB E ∧ (E ⊨ [%140 := 40#64, %141 := one])

/-- `a_naf`'s digits are width-5 digits: `|d| < 16`. -/
@[expose]
public def DigitsA (an : BitVec (8 * 256)) : Prop :=
  ∀ i, i < 256 → -16 < (digit an i).toInt ∧ (digit an i).toInt < 16

/-- `b_naf`'s digits are not `-128`. -/
@[expose]
public def DigitsB (bn : BitVec (8 * 256)) : Prop :=
  ∀ i, i < 256 → -128 < (digit bn i).toInt

/-- What the main loop needs of a state: room at `out`, `r` fits, the temporaries in bounds, the
NAFs' bytes and both tables in place. -/
public structure LoopFacts (S : GlobalState) (σ : Slots) (B : GlobalState) (out : Pointer)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) : Prop where
  wf : S.WF
  outRoom : S.mem.PointRoom out
  r : S.mem.ProjectiveFit σ.r
  slots : SlotsIn S.mem B
  aF : Fits S.mem σ.a_naf 2048
  aR : S.mem.readAt σ.a_naf 2048 = an
  bF : Fits S.mem σ.b_naf 2048
  bR : S.mem.readAt σ.b_naf 2048 = bn
  outLt : out.id.id < B.alloc.nextFreeBlock
  tAF : Fits S.mem σ.table_A 10240
  tAR :
    S.mem.readAt σ.table_A 10240 =
      nafBits (NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.spec P)
  tBF : Fits S.mem σ.table_B 61440
  tBR :
    S.mem.readAt σ.table_B 61440 =
      Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_73.lit (w := 61440) (hw := rfl)

open Lean Elab Tactic Meta in
/-- `tag_slots h₁ …`: the equations `x = B.slot k`, tagged as a step's named values, so the steps
keep the slots folded, as they keep an `alloca`'s. -/
local elab "tag_slots " hs:ident* : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for h in hs do
      let d ← getLocalDeclFromUserName h.getId
      g ← g.replaceLocalDeclDefEq d.fvarId (Tactic.tagNamed d.type)
    replaceMainGoal [g]

/-- `SlotsIn` from each temporary's bounds. -/
public theorem SlotsIn.of_bounds {m : MemoryState} {B : GlobalState}
    (h0 : InBounds m (B.slot 0) 320) (h1 : InBounds m (B.slot 1) 320)
    (h2 : InBounds m (B.slot 2) 320) (h3 : InBounds m (B.slot 3) 320)
    (h4 : InBounds m (B.slot 4) 320) (h5 : InBounds m (B.slot 5) 320)
    (h6 : InBounds m (B.slot 6) 320) (h7 : InBounds m (B.slot 7) 320)
    (h8 : InBounds m (B.slot 8) 320) (h9 : InBounds m (B.slot 9) 320)
    (h10 : InBounds m (B.slot 10) 320) (h11 : InBounds m (B.slot 11) 320)
    (h12 : InBounds m (B.slot 12) 320) (h13 : InBounds m (B.slot 13) 320)
    (h14 : InBounds m (B.slot 14) 320) (h15 : InBounds m (B.slot 15) 320)
    (h16 : InBounds m (B.slot 16) 320) (h17 : InBounds m (B.slot 17) 320)
    (h18 : InBounds m (B.slot 18) 320) (h19 : InBounds m (B.slot 19) 1280)
    (h20 : InBounds m (B.slot 20) 1280) (h21 : InBounds m (B.slot 21) 1280)
    (h22 : InBounds m (B.slot 22) 1280) (h23 : InBounds m (B.slot 23) 1280)
    (hw : ∀ k, k ≤ 24 → Writable m (B.slot k)) : SlotsIn m B := by
  refine ⟨fun k hk => ?_, hw⟩
  interval_cases k <;> simpa

/-- The slots `0 … 24` writable, from the named slots'. -/
public theorem Slots.At.writable {σ : Slots} {B : GlobalState} {m : MemoryState} (hσ : σ.At B)
    (h0 : Writable m σ.aaZ2) (h1 : Writable m σ.aaTxy2d) (h2 : Writable m σ.aaMM)
    (h3 : Writable m σ.aaPP) (h4 : Writable m σ.aaYmX) (h5 : Writable m σ.aaYpX)
    (h6 : Writable m σ.asZ2) (h7 : Writable m σ.asTxy2d) (h8 : Writable m σ.asMP)
    (h9 : Writable m σ.asPM) (h10 : Writable m σ.asYmX) (h11 : Writable m σ.asYpX)
    (h12 : Writable m σ.nsZZ2) (h13 : Writable m σ.nsZZ) (h14 : Writable m σ.nsTT2d)
    (h15 : Writable m σ.nsMP) (h16 : Writable m σ.nsPM) (h17 : Writable m σ.nsYmX)
    (h18 : Writable m σ.nsYpX) (h19 : Writable m σ.xBm) (h20 : Writable m σ.xBp)
    (h21 : Writable m σ.xAm) (h22 : Writable m σ.xAp) (h23 : Writable m σ.t)
    (h24 : Writable m σ.r) : ∀ k, k ≤ 24 → Writable m (B.slot k) := by
  intro k hk
  interval_cases k
  exacts [hσ.aaZ2 ▸ h0, hσ.aaTxy2d ▸ h1, hσ.aaMM ▸ h2, hσ.aaPP ▸ h3, hσ.aaYmX ▸ h4,
    hσ.aaYpX ▸ h5, hσ.asZ2 ▸ h6, hσ.asTxy2d ▸ h7, hσ.asMP ▸ h8, hσ.asPM ▸ h9, hσ.asYmX ▸ h10,
    hσ.asYpX ▸ h11, hσ.nsZZ2 ▸ h12, hσ.nsZZ ▸ h13, hσ.nsTT2d ▸ h14, hσ.nsMP ▸ h15,
    hσ.nsPM ▸ h16, hσ.nsYmX ▸ h17, hσ.nsYpX ▸ h18, hσ.xBm ▸ h19, hσ.xBp ▸ h20, hσ.xAm ▸ h21,
    hσ.xAp ▸ h22, hσ.t ▸ h23, hσ.r ▸ h24]

/-! ### Digits and indices -/

/-- A negative `table_A` digit above `-16` passes `select`'s bounds check. -/
theorem negA_ult {d : BitVec 8} (hneg : d.slt 0#8 = true) (hlo : (240#8).slt d = true) :
    (-d).ult 16#8 = true := by bv_decide

/-- A negative digit's index, `-d / 2`, as the code computes it. -/
theorem neg_idx {d : BitVec 8} (hneg : d.slt 0#8 = true) (hlo : (128#8).slt d = true) :
    BitVec.signExtend 64 (-d) >>> 1 = BitVec.ofNat 64 ((-d) >>> 1).toNat := by
  rw [BitVec.ofNat_toNat]
  bv_decide

/-- A negative `table_A` digit's index is below `8`. -/
theorem negA_idx_lt {d : BitVec 8} (hneg : d.slt 0#8 = true) (hlo : (240#8).slt d = true) :
    ((-d) >>> 1).toNat < 8 := by
  have : (-d) >>> 1 < 8#8 := by bv_decide
  exact this

/-- An `i8` is negative, zero or positive. -/
theorem sign_cases (d : BitVec 8) : d.slt 0#8 = true ∨ d = 0#8 ∨ (0#8).slt d = true := by bv_decide

/-- `-16 < d` for an `i8`. -/
theorem lo16 {d : BitVec 8} (h : -16 < d.toInt) : (240#8).slt d = true := by
  rw [BitVec.slt_iff_toInt_lt]
  have : (240#8).toInt = -16 := by decide
  omega

/-- `-128 < d` for an `i8`. -/
theorem lo128 {d : BitVec 8} (h : -128 < d.toInt) : (128#8).slt d = true := by
  rw [BitVec.slt_iff_toInt_lt]
  have : (128#8).toInt = -128 := by decide
  omega

/-- No wrap within a table entry `o` bytes into a block from its start. -/
theorem entry_noOverflow {q p : Pointer} {o : Nat} (hq : q = p.add (BitVec.ofNat 64 o))
    (hp : p.offset = 0) (ho : o + 120 < 2 ^ 64) : ¬q.offset.uaddOverflow 120#64 := by
  subst hq
  simp [BitVec.uaddOverflow, Pointer.add, hp,
    Nat.mod_eq_of_lt (show o < 18446744073709551616 by omega)]
  omega

/-- A negative `i8` is not positive. -/
theorem not_pos_of_neg {d : BitVec 8} (h : d.slt 0#8 = true) : (0#8).slt d = false := by bv_decide

/-- A `CompletedPoint` from its four field elements' reads. -/
theorem readCompleted_eq {m : MemoryState} {p : Pointer} {X Y Z T : Fin 5 → BitVec 64}
    (h0 : m.readLimbs p = X) (h1 : m.readLimbs (p.add 40#64) = Y)
    (h2 : m.readLimbs (p.add 80#64) = Z) (h3 : m.readLimbs (p.add 120#64) = T) :
    m.readCompleted p = ⟨X, Y, Z, T⟩ := by simp only [MemoryState.readCompleted, h0, h1, h2, h3]

/-- A positive `i8` is not negative. -/
theorem not_neg_of_pos {d : BitVec 8} (h : (0#8).slt d = true) : d.slt 0#8 = false := by bv_decide

/-- A positive `i8` is not zero. -/
theorem ne_zero_of_pos {d : BitVec 8} (h : (0#8).slt d = true) : (d = 0#8) = False := by
  simp only [eq_iff_iff, iff_false]
  rintro rfl
  exact absurd h (by decide)

/-- A positive `table_A` digit below `16` passes `select`'s bounds check. -/
theorem posA_ult {d : BitVec 8} (hpos : (0#8).slt d = true) (hhi : d.toInt < 16) :
    d.ult 16#8 = true := by
  have : d.slt 16#8 = true := by
    rw [BitVec.slt_iff_toInt_lt]
    exact hhi
  bv_decide

/-- A positive digit's index, `d / 2`, as the code computes it. -/
theorem pos_idx {d : BitVec 8} (hpos : (0#8).slt d = true) :
    BitVec.signExtend 64 d >>> 1 = BitVec.ofNat 64 (d >>> 1).toNat := by
  rw [BitVec.ofNat_toNat]
  bv_decide

/-- A positive `table_A` digit's index is below `8`. -/
theorem posA_idx_lt {d : BitVec 8} (hpos : (0#8).slt d = true) (hhi : d.toInt < 16) :
    (d >>> 1).toNat < 8 := by
  have : d.slt 16#8 = true := by
    rw [BitVec.slt_iff_toInt_lt]
    exact hhi
  have : d >>> 1 < 8#8 := by bv_decide
  exact this

/-- A negative `table_B` digit above `-128` passes the bounds check: `-d > -1`. -/
theorem negB_sgt {d : BitVec 8} (hneg : d.slt 0#8 = true) (hlo : (128#8).slt d = true) :
    (255#8).slt (-d) = true := by bv_decide

/-- A positive `table_B` digit passes the bounds check: `d > -1`. -/
theorem posB_sgt {d : BitVec 8} (hpos : (0#8).slt d = true) : (255#8).slt d = true := by bv_decide

/-- A negative `table_B` digit's index is below `64`. -/
theorem negB_idx_lt {d : BitVec 8} (hneg : d.slt 0#8 = true) (hlo : (128#8).slt d = true) :
    ((-d) >>> 1).toNat < 64 := by
  have : (-d) >>> 1 < 64#8 := by bv_decide
  exact this

/-- A positive `table_B` digit's index is below `64`. -/
theorem posB_idx_lt {d : BitVec 8} (hpos : (0#8).slt d = true) : (d >>> 1).toNat < 64 := by
  have : d >>> 1 < 64#8 := by bv_decide
  exact this

/-- A small counter is `0` as a `u64` exactly when it is. -/
theorem eq_zero_of_ofNat64 {i : Nat} (hi : i < 256) (h : BitVec.ofNat 64 i = 0#64) : i = 0 := by
  have := congrArg BitVec.toNat h
  simpa [Nat.mod_eq_of_lt (show i < 18446744073709551616 by omega)] using this

/-- `i - 1` on a small positive counter does not overflow. -/
theorem saddOverflow_neg_one64 {i : Nat} (h1 : 1 ≤ i) (h : i ≤ 256) :
    (BitVec.ofNat 64 i).saddOverflow 18446744073709551615#64 = false := by
  have hn : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (18446744073709551615#64).toInt = -1 := by decide
  simp [BitVec.saddOverflow, hn, hm]
  omega

/-- `i - 1` on a small positive counter. -/
theorem add_neg_one64 {i : Nat} (h1 : 1 ≤ i) (h : i ≤ 256) :
    BitVec.ofNat 64 i + 18446744073709551615#64 = BitVec.ofNat 64 (i - 1) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- A counter below `256`, mod `2^64`. -/
theorem mod64 {i : Nat} (h : i < 256) : i % 18446744073709551616 = i :=
  Nat.mod_eq_of_lt (by omega)

set_option hygiene false in
/-- Closes the targets of a `switch` on a known `scmp` that it does not take. -/
local macro "switch_drop" : tactic =>
  `(tactic|
    all_goals
      try
        first
        | exact absurd hbr (by decide)
        | exact absurd (by decide) hbr0
        | exact absurd (by decide) hbr1
        | exact absurd (by decide) hbr2)

set_option hygiene false in
/-- The slots' equations, tagged as `alloca`'s are. -/
local macro "open_slots " hσ:ident : tactic =>
  `(tactic|
    ( obtain
        ⟨⟨htable_B_off, htable_B_lt⟩, haaZ2, haaTxy2d, haaMM, haaPP, haaYmX, haaYpX, hasZ2,
          hasTxy2d, hasMP, hasPM, hasYmX, hasYpX, hnsZZ2, hnsZZ, hnsTT2d, hnsMP, hnsPM, hnsYmX,
          hnsYpX, hxBm, hxBp, hxAm, hxAp, ht, hr, htable_A, hb_naf, ha_naf⟩ :=
        $hσ
      dsimp only at *
      tag_slots haaZ2 haaTxy2d haaMM haaPP haaYmX haaYpX hasZ2 hasTxy2d hasMP hasPM hasYmX hasYpX
        hnsZZ2 hnsZZ hnsTT2d hnsMP hnsPM hnsYmX hnsYpX hxBm hxBp hxAm hxAp ht hr htable_A hb_naf
        ha_naf))

/-! ### The main loop's blocks -/

-- about 60 steps (the inlined Niels subtraction's 13 calls and 15 markers), each carrying the
-- loop's facts: past the default heartbeats
set_option maxHeartbeats 1000000 in
/-- `^bb4`, an iteration's start at `i`: `t = r.double()`, then `a_naf[i]`'s add; on to `^bb12`. -/
theorem headA_block (out a A b locA locB : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (hdA : -16 < (digit an i).toInt ∧ (digit an i).toInt < 16) (R : ProjectivePoint)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs σ locA locB E) (hRi : E ⊨ [%202 := BitVec.ofNat 64 i])
    (hF : LoopFacts S σ B out P an bn) (hrv : S.mem.readProjective σ.r = R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
          LoopRegs σ locA locB E' →
          (E' ⊨ [%202 := BitVec.ofNat 64 i]) →
          LoopFacts S' σ B out P an bn →
          S'.mem.PointFit σ.t →
          S'.mem.readCompleted σ.t =
            addA (NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.Ai P) (digit an i)
              (ProjectivePoint_double.spec R) →
          S'.mem.readProjective σ.r = R →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 7 + digitBlocks (digit an i) →
          S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
          (mul.runFrom E' ^bb12 S' >>= g) = K) :
    (mul.runFrom E ^bb4 S >>= g) = K := by
  rcases σ with
    ⟨table_B, aaZ2, aaTxy2d, aaMM, aaPP, aaYmX, aaYpX, asZ2, asTxy2d, asMP, asPM, asYmX, asYpX,
      nsZZ2, nsZZ, nsTT2d, nsMP, nsPM, nsYmX, nsYpX, xBm, xBp, xAm, xAp, t, r, table_A, b_naf,
      a_naf⟩
  obtain ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ := hF
  open_slots hσ
  have ht_b : InBounds S.mem t 1280 := ht ▸ hsl.pt 23
  have ht_w : Writable S.mem t := ht ▸ hsl.writable 23
  have ht_off : t.offset = 0 := by
    rw [ht]; rfl
  have ha_naf_off : a_naf.offset = 0 := by
    rw [ha_naf]; rfl
  -- let mut t = r.double();
  block_init
  step_pure
  have ht_pt := MemoryState.PointRoom.of_room hroom_t ht_off
  step_call using ProjectivePoint_double.call_eq
  name_point dbl
  -- match a_naf[i].cmp(&0)
  step_pure
  step_load [mod64 hi] with d
  have hdd : d = digit an i := hd
  rcases sign_cases (digit an i) with hneg | hz | hpos
  · -- Ordering::Less => t = &t.as_extended() - &table_A.select(-a_naf[i] as usize)
    have hlo := lo16 hdA.1
    have hlo' := lo128 (by omega : -128 < (digit an i).toInt)
    step_pure [hdd, hneg]
    finish_block
    switch_drop
    have hxAm_b : InBounds S.mem xAm 1280 := hxAm ▸ hsl.pt 21
    have hxAm_w : Writable S.mem xAm := hxAm ▸ hsl.writable 21
    have hxAm_off : xAm.offset = 0 := by
      rw [hxAm]; rfl
    block_init
    step_pure
    have hxAm_pt := MemoryState.PointRoom.of_room hroom_xAm hxAm_off
    step_call using CompletedPoint_as_extended.call_eq
    name_point ext
    step_pure with nd
    step_pure with snd
    step_pure with idx
    step_pure [hnd, negA_ult hneg hlo]
    finish_block
    block_init
    obtain ⟨k, hk⟩ : ∃ k, ((-digit an i) >>> 1).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 8 := hk ▸ negA_idx_lt hneg hlo
    have hidx' : idx = BitVec.ofNat 64 k := by rw [hidx, hsnd, hnd, neg_idx hneg hlo', hk]
    have htable_A_off : table_A.offset = 0 := by
      rw [htable_A]; rfl
    step_pure [hidx', Nat.mod_eq_of_lt (show k < 18446744073709551616 by omega),
      Nat.mul_comm k 160] with Q
    obtain ⟨Qv, hQv⟩ :
      ∃ v, NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.spec P ⟨k, hk8⟩ = v :=
      ⟨_, rfl⟩
    have hQno : ¬Q.offset.uaddOverflow 120#64 := entry_noOverflow hQ htable_A_off (by omega)
    -- let Y_plus_X = &self.Y + &self.X;
    have h167 : InBounds S.mem nsYpX 320 := hnsYpX ▸ hsl.fe 18
    have h167w : Writable S.mem nsYpX := hnsYpX ▸ hsl.writable 18
    step_pure
    have h167l :=
      MemoryState.LimbsRoom.of_room hroom_nsYpX
        (by
          rw [hnsYpX]; rfl)
    step_call using FieldElement51_Add_add.call_eq
    name_limbs Y_plus_X
    -- let Y_minus_X = &self.Y - &self.X;
    have h166 : InBounds S.mem nsYmX 320 := hnsYmX ▸ hsl.fe 17
    have h166w : Writable S.mem nsYmX := hnsYmX ▸ hsl.writable 17
    step_pure
    have h166l :=
      MemoryState.LimbsRoom.of_room hroom_nsYmX
        (by
          rw [hnsYmX]; rfl)
    step_call using FieldElement51_Sub_sub.call_eq
    name_limbs Y_minus_X
    -- let PM = &Y_plus_X * &other.Y_minus_X;
    have h165 : InBounds S.mem nsPM 320 := hnsPM ▸ hsl.fe 16
    have h165w : Writable S.mem nsPM := hnsPM ▸ hsl.writable 16
    step_pure
    have h165l :=
      MemoryState.LimbsRoom.of_room hroom_nsPM
        (by
          rw [hnsPM]; rfl)
    step_pure with Q40
    obtain ⟨-, -, hQ1f, hQ1, -⟩ := tableA_coords htAF htable_A_off htAR k hk8
    rw [hQv] at hQ1
    replace hQ1f : S.mem.LimbsFit Q40 := by
      rw [hQ40, hQ, Pointer.add_add]; exact hQ1f
    replace hQ1 : S.mem.readLimbs Q40 = Qv.Y_minus_X := by
      rw [hQ40, hQ, Pointer.add_add]; exact hQ1
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ1f hQ1
    name_limbs PM
    -- let MP = &Y_minus_X * &other.Y_plus_X;
    have h164 : InBounds S.mem nsMP 320 := hnsMP ▸ hsl.fe 15
    have h164w : Writable S.mem nsMP := hnsMP ▸ hsl.writable 15
    step_pure
    have h164l :=
      MemoryState.LimbsRoom.of_room hroom_nsMP
        (by
          rw [hnsMP]; rfl)
    obtain ⟨hQ0f, hQ0, -⟩ := tableA_coords htAF htable_A_off htAR k hk8
    rw [hQv, ← hQ] at hQ0
    rw [← hQ] at hQ0f
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ0f hQ0
    name_limbs MP
    -- let TT2d = &self.T * &other.T2d;
    have h163 : InBounds S.mem nsTT2d 320 := hnsTT2d ▸ hsl.fe 14
    have h163w : Writable S.mem nsTT2d := hnsTT2d ▸ hsl.writable 14
    step_pure
    have h163l :=
      MemoryState.LimbsRoom.of_room hroom_nsTT2d
        (by
          rw [hnsTT2d]; rfl)
    step_pure with Q120
    obtain ⟨-, -, -, -, -, -, hQ3f, hQ3⟩ := tableA_coords htAF htable_A_off htAR k hk8
    rw [hQv] at hQ3
    replace hQ3f : S.mem.LimbsFit Q120 := by
      rw [hQ120, hQ, Pointer.add_add]; exact hQ3f
    replace hQ3 : S.mem.readLimbs Q120 = Qv.T2d := by
      rw [hQ120, hQ, Pointer.add_add]; exact hQ3
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ3f hQ3
    name_limbs TT2d
    -- let ZZ = &self.Z * &other.Z;
    have h162 : InBounds S.mem nsZZ 320 := hnsZZ ▸ hsl.fe 13
    have h162w : Writable S.mem nsZZ := hnsZZ ▸ hsl.writable 13
    step_pure
    have h162l :=
      MemoryState.LimbsRoom.of_room hroom_nsZZ
        (by
          rw [hnsZZ]; rfl)
    step_pure with Q80
    obtain ⟨-, -, -, -, hQ2f, hQ2, -⟩ := tableA_coords htAF htable_A_off htAR k hk8
    rw [hQv] at hQ2
    replace hQ2f : S.mem.LimbsFit Q80 := by
      rw [hQ80, hQ, Pointer.add_add]; exact hQ2f
    replace hQ2 : S.mem.readLimbs Q80 = Qv.Z := by
      rw [hQ80, hQ, Pointer.add_add]; exact hQ2
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ2f hQ2
    name_limbs ZZ
    -- let ZZ2 = &ZZ + &ZZ;
    have h161 : InBounds S.mem nsZZ2 320 := hnsZZ2 ▸ hsl.fe 12
    have h161w : Writable S.mem nsZZ2 := hnsZZ2 ▸ hsl.writable 12
    step_pure
    have h161l :=
      MemoryState.LimbsRoom.of_room hroom_nsZZ2
        (by
          rw [hnsZZ2]; rfl)
    step_call using FieldElement51_Add_add.call_eq
    name_limbs ZZ2
    -- CompletedPoint { X: &PM - &MP, Y: &PM + &MP, Z: &ZZ2 - &TT2d, T: &ZZ2 + &TT2d }
    step_call using FieldElement51_Sub_sub.call_eq
    step_call using FieldElement51_Add_add.call_eq
    step_call using FieldElement51_Sub_sub.call_eq
    step_call using FieldElement51_Add_add.call_eq
    iterate 8 step_pure
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ ht_pt ?_ hrv ?_ ?_
    · rw [readCompleted_eq hread_t_readLimbs hread_t_40_readLimbs hread_t_80_readLimbs
          hread_t_120_readLimbs]
      simp only [addA, not_pos_of_neg hneg, hneg, Bool.false_eq_true, ↓reduceIte, hk]
      subst hPM hMP hTT2d hZZ hZZ2 hY_plus_X hY_minus_X hext hdbl hQv
      rfl
    · rw [hS]
      simp [digitBlocks, not_pos_of_neg hneg]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
        MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeLimbs_of_le,
        MemoryState.eraseFrom_storeCompleted_of_le, MemoryState.eraseFrom_storeEdwards_of_le]
  · -- Ordering::Equal => {}
    step_pure [hdd, hz]
    finish_block
    switch_drop
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ ht_pt ?_ hrv ?_ ?_
    · rw [hread_t, hdbl]
      simp only [addA, hz]
      rfl
    · rw [hS]
      simp [digitBlocks, hz]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeStart_of_le,
        MemoryState.eraseFrom_storeCompleted_of_le]
  · -- Ordering::Greater => t = &t.as_extended() + &table_A.select(a_naf[i] as usize)
    step_pure [hdd, hpos, ne_zero_of_pos hpos, not_neg_of_pos hpos]
    finish_block
    switch_drop
    have hxAp_b : InBounds S.mem xAp 1280 := hxAp ▸ hsl.pt 22
    have hxAp_w : Writable S.mem xAp := hxAp ▸ hsl.writable 22
    have hxAp_off : xAp.offset = 0 := by
      rw [hxAp]; rfl
    block_init
    step_pure
    have hxAp_pt := MemoryState.PointRoom.of_room hroom_xAp hxAp_off
    step_call using CompletedPoint_as_extended.call_eq
    name_point ext
    step_pure with sd
    step_pure with idx
    step_pure [posA_ult hpos hdA.2]
    finish_block
    block_init
    obtain ⟨k, hk⟩ : ∃ k, (digit an i >>> 1).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 8 := hk ▸ posA_idx_lt hpos hdA.2
    have hidx' : idx = BitVec.ofNat 64 k := by rw [hidx, hsd, pos_idx hpos, hk]
    have htable_A_off : table_A.offset = 0 := by
      rw [htable_A]; rfl
    step_pure [hidx', Nat.mod_eq_of_lt (show k < 18446744073709551616 by omega),
      Nat.mul_comm k 160] with Q
    obtain ⟨hQf, hQr⟩ := tableA_entry htAF htable_A_off htAR k hk8
    rw [← hQ] at hQf hQr
    step_call using EdwardsPoint_Add_ProjectiveNielsPoint_add.call_eq consuming hQf hQr
    step_pure
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ ht_pt ?_ hrv ?_ ?_
    · rw [hread_t]
      simp only [addA, hpos, ↓reduceIte, hk]
      subst hext hdbl
      rfl
    · rw [hS]
      simp [digitBlocks, hpos]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
        MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeCompleted_of_le,
        MemoryState.eraseFrom_storeEdwards_of_le]

-- about 100 steps (the two inlined affine adds), each carrying the loop's facts: past the
-- default heartbeats
set_option maxHeartbeats 1000000 in
/-- `^bb12`: `b_naf[i]`'s add on `t`; on to `^bb14`. -/
theorem headB_block (out a A b locA locB : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (hdB : -128 < (digit bn i).toInt)
    (R : ProjectivePoint) (T : CompletedPoint) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs σ locA locB E) (hRi : E ⊨ [%202 := BitVec.ofNat 64 i])
    (hF : LoopFacts S σ B out P an bn) (htf : S.mem.PointFit σ.t)
    (htv : S.mem.readCompleted σ.t = T) (hrv : S.mem.readProjective σ.r = R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
          LoopRegs σ locA locB E' →
          (E' ⊨ [%202 := BitVec.ofNat 64 i]) →
          LoopFacts S' σ B out P an bn →
          S'.mem.PointFit σ.t →
          S'.mem.readCompleted σ.t = addB tableB (digit bn i) T →
          S'.mem.readProjective σ.r = R →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock →
          S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
          (mul.runFrom E' ^bb14 S' >>= g) = K) :
    (mul.runFrom E ^bb12 S >>= g) = K := by
  rcases σ with
    ⟨table_B, aaZ2, aaTxy2d, aaMM, aaPP, aaYmX, aaYpX, asZ2, asTxy2d, asMP, asPM, asYmX, asYpX,
      nsZZ2, nsZZ, nsTT2d, nsMP, nsPM, nsYmX, nsYpX, xBm, xBp, xAm, xAp, t, r, table_A, b_naf,
      a_naf⟩
  obtain ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ := hF
  open_slots hσ
  have ht_w : Writable S.mem t := ht ▸ hsl.writable 23
  have hb_naf_off : b_naf.offset = 0 := by
    rw [hb_naf]; rfl
  -- match b_naf[i].cmp(&0)
  block_init
  step_pure
  step_load [mod64 hi] with d
  have hdd : d = digit bn i := hd
  have hlo := lo128 hdB
  rcases sign_cases (digit bn i) with hneg | hz | hpos
  · -- Ordering::Less => t = &t.as_extended() - &table_B.select(-b_naf[i] as usize)
    step_pure [hdd, hneg]
    finish_block
    switch_drop
    have hxBm_b : InBounds S.mem xBm 1280 := hxBm ▸ hsl.pt 19
    have hxBm_w : Writable S.mem xBm := hxBm ▸ hsl.writable 19
    have hxBm_off : xBm.offset = 0 := by
      rw [hxBm]; rfl
    block_init
    step_pure
    have hxBm_pt := MemoryState.PointRoom.of_room hroom_xBm hxBm_off
    step_call using CompletedPoint_as_extended.call_eq
    name_point ext
    step_pure with nd
    step_pure with snd
    step_pure with idx
    step_pure [hnd, negB_sgt hneg hlo]
    finish_block
    block_init
    obtain ⟨k, hk⟩ : ∃ k, ((-digit bn i) >>> 1).toNat = k := ⟨_, rfl⟩
    have hk64 : k < 64 := hk ▸ negB_idx_lt hneg hlo
    have hidx' : idx = BitVec.ofNat 64 k := by rw [hidx, hsnd, hnd, neg_idx hneg hlo, hk]
    step_pure [hidx', Nat.mod_eq_of_lt (show k < 18446744073709551616 by omega),
      Nat.mul_comm k 120] with Q
    have hQno : ¬Q.offset.uaddOverflow 120#64 := entry_noOverflow hQ htable_B_off (by omega)
    -- let Y_plus_X = &self.Y + &self.X;
    have h160 : InBounds S.mem asYpX 320 := hasYpX ▸ hsl.fe 11
    have h160w : Writable S.mem asYpX := hasYpX ▸ hsl.writable 11
    step_pure
    have h160l :=
      MemoryState.LimbsRoom.of_room hroom_asYpX
        (by
          rw [hasYpX]; rfl)
    step_call using FieldElement51_Add_add.call_eq
    name_limbs Y_plus_X
    -- let Y_minus_X = &self.Y - &self.X;
    have h159 : InBounds S.mem asYmX 320 := hasYmX ▸ hsl.fe 10
    have h159w : Writable S.mem asYmX := hasYmX ▸ hsl.writable 10
    step_pure
    have h159l :=
      MemoryState.LimbsRoom.of_room hroom_asYmX
        (by
          rw [hasYmX]; rfl)
    step_call using FieldElement51_Sub_sub.call_eq
    name_limbs Y_minus_X
    -- let PM = &Y_plus_X * &other.y_minus_x;
    have h158 : InBounds S.mem asPM 320 := hasPM ▸ hsl.fe 9
    have h158w : Writable S.mem asPM := hasPM ▸ hsl.writable 9
    step_pure
    have h158l :=
      MemoryState.LimbsRoom.of_room hroom_asPM
        (by
          rw [hasPM]; rfl)
    step_pure with Q40
    obtain ⟨-, -, hQ1f, hQ1, -⟩ := tableB_coords htBF htable_B_off htBR k hk64
    replace hQ1f : S.mem.LimbsFit Q40 := by
      rw [hQ40, hQ, Pointer.add_add]; exact hQ1f
    replace hQ1 : S.mem.readLimbs Q40 = (tableB k).y_minus_x := by
      rw [hQ40, hQ, Pointer.add_add]; exact hQ1
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ1f hQ1
    name_limbs PM
    -- let MP = &Y_minus_X * &other.y_plus_x;
    have h157 : InBounds S.mem asMP 320 := hasMP ▸ hsl.fe 8
    have h157w : Writable S.mem asMP := hasMP ▸ hsl.writable 8
    step_pure
    have h157l :=
      MemoryState.LimbsRoom.of_room hroom_asMP
        (by
          rw [hasMP]; rfl)
    obtain ⟨hQ0f, hQ0, -⟩ := tableB_coords htBF htable_B_off htBR k hk64
    replace hQ0f : S.mem.LimbsFit Q := by
      rw [hQ]; exact hQ0f
    replace hQ0 : S.mem.readLimbs Q = (tableB k).y_plus_x := by
      rw [hQ]; exact hQ0
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ0f hQ0
    name_limbs MP
    -- let Txy2d = &self.T * &other.xy2d;
    have h156 : InBounds S.mem asTxy2d 320 := hasTxy2d ▸ hsl.fe 7
    have h156w : Writable S.mem asTxy2d := hasTxy2d ▸ hsl.writable 7
    step_pure
    have h156l :=
      MemoryState.LimbsRoom.of_room hroom_asTxy2d
        (by
          rw [hasTxy2d]; rfl)
    step_pure with Q80
    obtain ⟨-, -, -, -, hQ2f, hQ2⟩ := tableB_coords htBF htable_B_off htBR k hk64
    replace hQ2f : S.mem.LimbsFit Q80 := by
      rw [hQ80, hQ, Pointer.add_add]; exact hQ2f
    replace hQ2 : S.mem.readLimbs Q80 = (tableB k).xy2d := by
      rw [hQ80, hQ, Pointer.add_add]; exact hQ2
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ2f hQ2
    name_limbs Txy2d
    -- let Z2 = &self.Z + &self.Z;
    have h155 : InBounds S.mem asZ2 320 := hasZ2 ▸ hsl.fe 6
    have h155w : Writable S.mem asZ2 := hasZ2 ▸ hsl.writable 6
    step_pure
    have h155l :=
      MemoryState.LimbsRoom.of_room hroom_asZ2
        (by
          rw [hasZ2]; rfl)
    step_call using FieldElement51_Add_add.call_eq
    name_limbs Z2
    -- CompletedPoint { X: &PM - &MP, Y: &PM + &MP, Z: &Z2 - &Txy2d, T: &Z2 + &Txy2d }
    step_call using FieldElement51_Sub_sub.call_eq
    step_call using FieldElement51_Add_add.call_eq
    step_call using FieldElement51_Sub_sub.call_eq
    step_call using FieldElement51_Add_add.call_eq
    iterate 7 step_pure
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ htf ?_ hrv ?_ ?_
    · rw [readCompleted_eq hread_t_readLimbs hread_t_40_readLimbs hread_t_80_readLimbs
          hread_t_120_readLimbs]
      simp only [addB, not_pos_of_neg hneg, hneg, Bool.false_eq_true, ↓reduceIte, hk]
      subst hPM hMP hTxy2d hZ2 hY_plus_X hY_minus_X hext
      rfl
    · rw [hS]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
        MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeLimbs_of_le,
        MemoryState.eraseFrom_storeEdwards_of_le]
  · -- Ordering::Equal => {}
    step_pure [hdd, hz]
    finish_block
    switch_drop
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ htf ?_ hrv
        (by rw [hS]) (by rw [hS])
    rw [htv]
    simp only [addB, hz]
    rfl
  · -- Ordering::Greater => t = &t.as_extended() + &table_B.select(b_naf[i] as usize)
    step_pure [hdd, hpos, ne_zero_of_pos hpos, not_neg_of_pos hpos]
    finish_block
    switch_drop
    have hxBp_b : InBounds S.mem xBp 1280 := hxBp ▸ hsl.pt 20
    have hxBp_w : Writable S.mem xBp := hxBp ▸ hsl.writable 20
    have hxBp_off : xBp.offset = 0 := by
      rw [hxBp]; rfl
    block_init
    step_pure
    have hxBp_pt := MemoryState.PointRoom.of_room hroom_xBp hxBp_off
    step_call using CompletedPoint_as_extended.call_eq
    name_point ext
    step_pure with sd
    step_pure with idx
    step_pure [posB_sgt hpos]
    finish_block
    block_init
    obtain ⟨k, hk⟩ : ∃ k, (digit bn i >>> 1).toNat = k := ⟨_, rfl⟩
    have hk64 : k < 64 := hk ▸ posB_idx_lt hpos
    have hidx' : idx = BitVec.ofNat 64 k := by rw [hidx, hsd, pos_idx hpos, hk]
    step_pure [hidx', Nat.mod_eq_of_lt (show k < 18446744073709551616 by omega),
      Nat.mul_comm k 120] with Q
    have hQno : ¬Q.offset.uaddOverflow 120#64 := entry_noOverflow hQ htable_B_off (by omega)
    -- let Y_plus_X = &self.Y + &self.X;
    have h154 : InBounds S.mem aaYpX 320 := haaYpX ▸ hsl.fe 5
    have h154w : Writable S.mem aaYpX := haaYpX ▸ hsl.writable 5
    step_pure
    have h154l :=
      MemoryState.LimbsRoom.of_room hroom_aaYpX
        (by
          rw [haaYpX]; rfl)
    step_call using FieldElement51_Add_add.call_eq
    name_limbs Y_plus_X
    -- let Y_minus_X = &self.Y - &self.X;
    have h153 : InBounds S.mem aaYmX 320 := haaYmX ▸ hsl.fe 4
    have h153w : Writable S.mem aaYmX := haaYmX ▸ hsl.writable 4
    step_pure
    have h153l :=
      MemoryState.LimbsRoom.of_room hroom_aaYmX
        (by
          rw [haaYmX]; rfl)
    step_call using FieldElement51_Sub_sub.call_eq
    name_limbs Y_minus_X
    -- let PP = &Y_plus_X * &other.y_plus_x;
    have h152 : InBounds S.mem aaPP 320 := haaPP ▸ hsl.fe 3
    have h152w : Writable S.mem aaPP := haaPP ▸ hsl.writable 3
    step_pure
    have h152l :=
      MemoryState.LimbsRoom.of_room hroom_aaPP
        (by
          rw [haaPP]; rfl)
    obtain ⟨hQ0f, hQ0, -⟩ := tableB_coords htBF htable_B_off htBR k hk64
    replace hQ0f : S.mem.LimbsFit Q := by
      rw [hQ]; exact hQ0f
    replace hQ0 : S.mem.readLimbs Q = (tableB k).y_plus_x := by
      rw [hQ]; exact hQ0
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ0f hQ0
    name_limbs PP
    -- let MM = &Y_minus_X * &other.y_minus_x;
    have h151 : InBounds S.mem aaMM 320 := haaMM ▸ hsl.fe 2
    have h151w : Writable S.mem aaMM := haaMM ▸ hsl.writable 2
    step_pure
    have h151l :=
      MemoryState.LimbsRoom.of_room hroom_aaMM
        (by
          rw [haaMM]; rfl)
    step_pure with Q40
    obtain ⟨-, -, hQ1f, hQ1, -⟩ := tableB_coords htBF htable_B_off htBR k hk64
    replace hQ1f : S.mem.LimbsFit Q40 := by
      rw [hQ40, hQ, Pointer.add_add]; exact hQ1f
    replace hQ1 : S.mem.readLimbs Q40 = (tableB k).y_minus_x := by
      rw [hQ40, hQ, Pointer.add_add]; exact hQ1
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ1f hQ1
    name_limbs MM
    -- let Txy2d = &self.T * &other.xy2d;
    have h150 : InBounds S.mem aaTxy2d 320 := haaTxy2d ▸ hsl.fe 1
    have h150w : Writable S.mem aaTxy2d := haaTxy2d ▸ hsl.writable 1
    step_pure
    have h150l :=
      MemoryState.LimbsRoom.of_room hroom_aaTxy2d
        (by
          rw [haaTxy2d]; rfl)
    step_pure with Q80
    obtain ⟨-, -, -, -, hQ2f, hQ2⟩ := tableB_coords htBF htable_B_off htBR k hk64
    replace hQ2f : S.mem.LimbsFit Q80 := by
      rw [hQ80, hQ, Pointer.add_add]; exact hQ2f
    replace hQ2 : S.mem.readLimbs Q80 = (tableB k).xy2d := by
      rw [hQ80, hQ, Pointer.add_add]; exact hQ2
    step_call using FieldElement51_Mul_mul.call_eq consuming hQ2f hQ2
    name_limbs Txy2d
    -- let Z2 = &self.Z + &self.Z;
    have h149 : InBounds S.mem aaZ2 320 := haaZ2 ▸ hsl.fe 0
    have h149w : Writable S.mem aaZ2 := haaZ2 ▸ hsl.writable 0
    step_pure
    have h149l :=
      MemoryState.LimbsRoom.of_room hroom_aaZ2
        (by
          rw [haaZ2]; rfl)
    step_call using FieldElement51_Add_add.call_eq
    name_limbs Z2
    -- CompletedPoint { X: &PP - &MM, Y: &PP + &MM, Z: &Z2 + &Txy2d, T: &Z2 - &Txy2d }
    step_call using FieldElement51_Sub_sub.call_eq
    step_call using FieldElement51_Add_add.call_eq
    step_call using FieldElement51_Add_add.call_eq
    step_call using FieldElement51_Sub_sub.call_eq
    iterate 7 step_pure
    finish_block
    refine
      hK E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ htf ?_ hrv ?_ ?_
    · rw [readCompleted_eq hread_t_readLimbs hread_t_40_readLimbs hread_t_80_readLimbs
          hread_t_120_readLimbs]
      simp only [addB, hpos, ↓reduceIte, hk]
      subst hPP hMM hTxy2d hZ2 hY_plus_X hY_minus_X hext
      rfl
    · rw [hS]
    · rw [hS]
      simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
        MemoryState.eraseFrom_lifetimeStart_of_le, MemoryState.eraseFrom_storeLimbs_of_le,
        MemoryState.eraseFrom_storeEdwards_of_le]

/-- `^bb14`: `r = t.as_projective()`; then out at `i = 0`, or around at `i - 1`. -/
theorem tail_block (out a A b locA locB : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (i : Nat) (hi : i < 256) (T : CompletedPoint) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs σ locA locB E) (hRi : E ⊨ [%202 := BitVec.ofNat 64 i])
    (hF : LoopFacts S σ B out P an bn) (htf : S.mem.PointFit σ.t)
    (htv : S.mem.readCompleted σ.t = T)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
            LoopRegs σ locA locB E' →
            LoopFacts S' σ B out P an bn →
            S'.mem.readProjective σ.r = CompletedPoint_as_projective.spec T →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock →
            S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
            (mul.runFrom E' ^bb20 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
              LoopRegs σ locA locB E' →
              (E' ⊨ [%202 := BitVec.ofNat 64 j]) →
              LoopFacts S' σ B out P an bn →
              S'.mem.readProjective σ.r = CompletedPoint_as_projective.spec T →
              S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock →
              S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
              (mul.runFrom E' ^bb4 S' >>= g) = K) :
    (mul.runFrom E ^bb14 S >>= g) = K := by
  rcases σ with
    ⟨table_B, aaZ2, aaTxy2d, aaMM, aaPP, aaYmX, aaYpX, asZ2, asTxy2d, asMP, asPM, asYmX, asYpX,
      nsZZ2, nsZZ, nsTT2d, nsMP, nsPM, nsYmX, nsYpX, xBm, xBp, xAm, xAp, t, r, table_A, b_naf,
      a_naf⟩
  obtain ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ := hF
  open_slots hσ
  have hr_w : Writable S.mem r := hr ▸ hsl.writable 24
  -- r = t.as_projective();
  block_init
  step_call using CompletedPoint_as_projective.call_eq consuming htv
  -- if i == 0 { break; }
  step_pure
  finish_block
  case isTrue =>
    have hi0 := eq_zero_of_ofNat64 hi hbr
    exact
      hexit hi0 E S hArgs (by env_reads)
        ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ hread_r
        (by rw [hS])
        (by
          rw [hS]
          simp (disch := slot_bound) only [MemoryState.eraseFrom_storeProjective_of_le])
  case
    isFalse =>
    have hi1 : 1 ≤ i := by
      rcases Nat.eq_zero_or_pos i with rfl | h
      · exact absurd rfl hbr
      · exact h
    block_init
    -- i -= 1;
    step_pure [saddOverflow_neg_one64 hi1 hi.le, add_neg_one64 hi1 hi.le]
    step_pure
    finish_block
    exact
      hback (i - 1) (by omega) E S hArgs (by env_reads) (by env_reads)
        ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ hread_r
        (by rw [hS])
        (by
          rw [hS]
          simp (disch := slot_bound) only [MemoryState.eraseFrom_storeProjective_of_le,
            MemoryState.eraseFrom_lifetimeEnd_of_le])

/-- An iteration of the main loop at `i`: `r` becomes `step` of it. -/
theorem main_iter (out a A b locA locB : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (hwA : DigitsA an) (hwB : DigitsB bn)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (R : ProjectivePoint) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs σ locA locB E) (hRi : E ⊨ [%202 := BitVec.ofNat 64 i])
    (hF : LoopFacts S σ B out P an bn) (hrv : S.mem.readProjective σ.r = R)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
            LoopRegs σ locA locB E' →
            LoopFacts S' σ B out P an bn →
            S'.mem.readProjective σ.r =
              step (NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.Ai P) tableB
                (digit an i) (digit bn i) R →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 7 + digitBlocks (digit an i) →
            S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
            (mul.runFrom E' ^bb20 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
              LoopRegs σ locA locB E' →
              (E' ⊨ [%202 := BitVec.ofNat 64 j]) →
              LoopFacts S' σ B out P an bn →
              S'.mem.readProjective σ.r =
                step (NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.Ai P) tableB
                  (digit an i) (digit bn i) R →
              S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 7 + digitBlocks (digit an i) →
              S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
              (mul.runFrom E' ^bb4 S' >>= g) = K) :
    (mul.runFrom E ^bb4 S >>= g) = K := by
  refine
    headA_block out a A b locA locB σ B hσ P an bn g K i hi (hwA i hi) R S E hArgs hR hRi hF hrv
      fun E₁ S₁ h₁ hR₁ hRi₁ hF₁ htf₁ htv₁ hrv₁ ha₁ he₁ => ?_
  refine
    headB_block out a A b locA locB σ B hσ P an bn g K i hi (hwB i hi) R _ S₁ E₁ h₁ hR₁ hRi₁ hF₁
      htf₁ htv₁ hrv₁ fun E₂ S₂ h₂ hR₂ hRi₂ hF₂ htf₂ htv₂ _ ha₂ he₂ => ?_
  refine
    tail_block out a A b locA locB σ B hσ P an bn g K i hi _ S₂ E₂ h₂ hR₂ hRi₂ hF₂ htf₂ htv₂
      (fun h0 E₃ S₃ h₃ hR₃ hF₃ hrv₃ ha₃ he₃ => ?_) fun j hj E₃ S₃ h₃ hR₃ hRi₃ hF₃ hrv₃ ha₃ he₃ => ?_
  · exact hexit h0 E₃ S₃ h₃ hR₃ hF₃ hrv₃ (by omega) (by rw [he₃, he₂, he₁])
  · exact hback j hj E₃ S₃ h₃ hR₃ hRi₃ hF₃ hrv₃ (by omega) (by rw [he₃, he₂, he₁])

/-- The main loop from `^bb4` at `i`: `r` the ladder from `i` down. -/
public theorem main_loop (out a A b locA locB : Pointer) (σ : Slots) (B : GlobalState) (hσ : σ.At B)
    (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (hwA : DigitsA an) (hwB : DigitsB bn)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (_ : i < 256) (R : ProjectivePoint) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value out) (.value a) (.value A) (.value b)).get →
        LoopRegs σ locA locB E →
        (E ⊨ [%202 := BitVec.ofNat 64 i]) →
        LoopFacts S σ B out P an bn →
        S.mem.readProjective σ.r = R →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
            LoopRegs σ locA locB E' →
            LoopFacts S' σ B out P an bn →
            S'.mem.readProjective σ.r =
              ladder (NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.Ai P) tableB an bn
                i R →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + ladderBlocks an i →
            S'.mem.eraseFrom B.alloc.nextFreeBlock = S.mem.eraseFrom B.alloc.nextFreeBlock →
            (mul.runFrom E' ^bb20 S' >>= g) = K) →
        (mul.runFrom E ^bb4 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi R S E hArgs hR hRi hF hrv hK
    exact
      main_iter out a A b locA locB σ B hσ P an bn hwA hwB g K 0 hi R S E hArgs hR hRi hF hrv
        (fun _ E' S' h₁ hR' hF' hrv' ha he =>
          hK E' S' h₁ hR' hF' hrv'
            (by
              rw [ha]; simp only [ladderBlocks]; omega)
            he)
        fun j hj => absurd hj (by omega)
  | succ j ih =>
    intro hi R S E hArgs hR hRi hF hrv hK
    refine
      main_iter out a A b locA locB σ B hσ P an bn hwA hwB g K (j + 1) hi R S E hArgs hR hRi hF hrv
        (fun h => absurd h (by omega)) fun j' hj E' S' h₁ hR' hRi' hF' hrv' ha he => ?_
    obtain rfl : j = j' := by omega
    refine ih (by omega) _ S' E' h₁ hR' hRi' hF' hrv' fun E'' S'' h₂ hR'' hF'' hrv'' ha' he' => ?_
    exact
      hK E'' S'' h₂ hR'' hF'' hrv''
        (by
          rw [ha', ha]; simp only [ladderBlocks]; omega)
        (by rw [he', he])

/-- `^bb20`: `r.as_extended()` stored at `out`, the slots' lifetimes ended; the frame from `N` on
erased. -/
public theorem exit_block (out a A b locA locB : Pointer) (σ : Slots) (B : GlobalState)
    (hσ : σ.At B) (P : EdwardsPoint) (an bn : BitVec (8 * 256)) (N : Nat)
    (hN : N ≤ B.alloc.nextFreeBlock) (R : ProjectivePoint) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value out) (.value a) (.value A) (.value b)).get)
    (hR : LoopRegs σ locA locB E) (hF : LoopFacts S σ B out P an bn)
    (hrv : S.mem.readProjective σ.r = R) :
    (mul.runFrom E ^bb20 S >>= fun p =>
        PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom N } : GlobalState))) =
      .value
        (.nil,
          ({ alloc := S.alloc,
             mem := (S.mem.eraseFrom N).storeEdwards out (ProjectivePoint_as_extended.spec R) } :
            GlobalState)) := by
  rcases σ with
    ⟨table_B, aaZ2, aaTxy2d, aaMM, aaPP, aaYmX, aaYpX, asZ2, asTxy2d, asMP, asPM, asYmX, asYpX,
      nsZZ2, nsZZ, nsTT2d, nsMP, nsPM, nsYmX, nsYpX, xBm, xBp, xAm, xAp, t, r, table_A, b_naf,
      a_naf⟩
  obtain ⟨hwf, hout, hr', hsl, haF, haR, hbF, hbR, houtLt, htAF, htAR, htBF, htBR⟩ := hF
  open_slots hσ
  have hX : S.mem.readLimbs r = R.X := congrArg ProjectivePoint.X hrv
  have hY : S.mem.readLimbs (r.add 40#64) = R.Y := congrArg ProjectivePoint.Y hrv
  have hZ : S.mem.readLimbs (r.add 80#64) = R.Z := congrArg ProjectivePoint.Z hrv
  have hout_no : ¬out.offset.uaddOverflow 120#64 := by
    have := hout.1
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]
    simp
    omega
  clear haF haR hbF hbR htAF htAR htBF htBR hsl hrv
  -- r.as_extended()
  block_init
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  step_pure
  step_call using FieldElement51_square.call_eq
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  iterate 4 step_pure
  finish_block
  rw [hS]
  dsimp only
  simp (disch := slot_bound) only [MemoryState.eraseFrom_lifetimeEnd_of_le,
    MemoryState.eraseFrom_storeLimbs]
  rfl

/-! ### The start search -/

theorem or_one (x : BitVec 1) : x ||| 1#1 = 1#1 := by bv_decide

/-- Digit `0` of a NAF's bytes, its low byte. -/
theorem digit_zero {an : BitVec (8 * 256)} : digit an 0 = an.setWidth 8 := by
  apply BitVec.eq_of_toNat_eq
  simp [digit]

theorem start_succ_zero {an bn : BitVec (8 * 256)} {j : Nat}
    (h : digit an (j + 1) = 0#8 ∧ digit bn (j + 1) = 0#8) :
    start an bn (j + 1) = start an bn j := by
  rw [start]
  simp only [h, and_self, ↓reduceIte]

theorem start_succ_ne {an bn : BitVec (8 * 256)} {j : Nat}
    (h : ¬(digit an (j + 1) = 0#8 ∧ digit bn (j + 1) = 0#8)) : start an bn (j + 1) = j + 1 := by
  rw [start]
  simp only [h, ↓reduceIte]

/-- `(i + 1) - 1` on a small counter. -/
theorem add_neg_one64_succ {i : Nat} (h : i + 1 ≤ 256) :
    BitVec.ofNat 64 (i + 1) + 18446744073709551615#64 = BitVec.ofNat 64 i := by
  simpa using add_neg_one64 (i := i + 1) (by omega) h

/-- `for j in (0..256).rev() { i = j; if a_naf[i] != 0 || b_naf[i] != 0 { break; } }` from `^bb1`
at `i + 1`: on to `^bb2` with `start` of it. -/
public theorem search_loop (out a A b locA locB one : Pointer) (σ : Slots)
    (an bn : BitVec (8 * 256)) (S : GlobalState) (haF : Fits S.mem σ.a_naf 2048)
    (haR : S.mem.readAt σ.a_naf 2048 = an) (hbF : Fits S.mem σ.b_naf 2048)
    (hbR : S.mem.readAt σ.b_naf 2048 = bn) (ha_off : σ.a_naf.offset = 0)
    (hb_off : σ.b_naf.offset = 0) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (_ : i < 256) (E : ⟪Γ⟫),
      E.args = (args (.value out) (.value a) (.value A) (.value b)).get →
        SearchRegs σ locA locB one E →
        (E ⊨ [%177 := BitVec.ofNat 64 (i + 1)]) →
        (∀ E' : ⟪Γ⟫,
          E'.args = (args (.value out) (.value a) (.value A) (.value b)).get →
            SearchRegs σ locA locB one E' →
            (E' ⊨ [%182 := BitVec.ofNat 64 (start an bn i)]) → (mul.runFrom E' ^bb2 S >>= g) = K) →
        (mul.runFrom E ^bb1 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi E hArgs hR hRi hK
    obtain ⟨hR, hR'⟩ := hR
    block_init
    step_pure [saddOverflow_neg_one64 (i := 1) (by omega) (by omega),
      add_neg_one64_succ (i := 0) (by omega)]
    step_pure
    step_load [← digit_zero] with da
    step_pure
    finish_block
    case isFalse =>
      subst hS
      exact hK E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)
    block_init
    step_pure
    step_load [← digit_zero] with db
    iterate 3 step_pure
    finish_block
    case isFalse => exact absurd (or_one _) hbr
    subst hS
    exact hK E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)
  | succ j ih =>
    intro hi E hArgs hR hRi hK
    obtain ⟨hR, hR'⟩ := hR
    block_init
    step_pure [saddOverflow_neg_one64 (i := j + 1 + 1) (by omega) (by omega),
      add_neg_one64_succ (i := j + 1) (by omega)]
    step_pure [mod64 hi]
    step_load [mod64 hi] with da
    step_pure
    finish_block
    case
      isFalse =>
      have hne : ¬(digit an (j + 1) = 0#8 ∧ digit bn (j + 1) = 0#8) := fun h =>
        hbr (by simp [hda, h.1])
      subst hS
      refine hK E hArgs ⟨by env_reads, by env_reads⟩ ?_
      rw [start_succ_ne hne]
      env_reads
    have ha0 : digit an (j + 1) = 0#8 := by simpa [hda] using hbr
    block_init
    step_pure [mod64 hi]
    step_load [mod64 hi] with db
    iterate 3 step_pure
    finish_block
    case
      isTrue =>
      have hne : ¬(digit an (j + 1) = 0#8 ∧ digit bn (j + 1) = 0#8) := fun h => by
        simp [hdb, h.2] at hbr
        exact absurd (eq_zero_of_ofNat64 hi hbr) (by omega)
      subst hS
      refine hK E hArgs ⟨by env_reads, by env_reads⟩ ?_
      rw [start_succ_ne hne]
      env_reads
    have hb0 : digit bn (j + 1) = 0#8 := by
      simp [hdb] at hbr
      exact hbr.1
    subst hS
    refine ih (by omega) E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads) fun E' h₁ h₂ h₃ => ?_
    refine hK E' h₁ h₂ ?_
    rw [start_succ_zero ⟨ha0, hb0⟩]
    exact h₃

end MLIR.Agave.Serial.mul
