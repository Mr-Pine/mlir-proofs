module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Tactics
public import Zig.Edwards25519_add
public import Zig.Edwards25519_sub
public import Zig.Edwards25519_dbl
public import Zig.Edwards25519_slide
public import Zig.Edwards25519_rejectIdentity
public import Zig.Edwards25519_basePointPc
public import Zig.Edwards25519_identityElement
public import Zig.Edwards25519_precompute
public import Zig.Steps
public import Zig.Mlir.Edwards25519_mulDoubleBasePublic
import all SSA.Projects.RIR.Ty
import Std.Tactic.BVDecide
import Std.Data.ExtHashMap.Lemmas

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

namespace Edwards25519.mulDoubleBasePublic

/-- The base point's table entry `k`; the identity past its 16. -/
def baseTbl (k : Nat) : ZPt :=
  if h : k < 16 then Edwards25519.basePointPc.pts[k] else Edwards25519.identity

/-- Digit `d` on `Q`: `Q + tbl[d]` for `d > 0`, `Q - tbl[-d]` for `d < 0`, else `Q`. -/
def digitStep (tbl : Nat → ZPt) (d : BitVec 8) (Q : ZPt) : ZPt :=
  if 0 < d.toInt then Edwards25519.add.spec Q (tbl d.toNat)
  else if d.toInt < 0 then Edwards25519.sub.spec Q (tbl (-d).toNat) else Q

/-- Position `i`: `x1`'s digit from the base point's table, then `x2`'s from `tbl`. -/
def posStep (tbl : Nat → ZPt) (x1 x2 : BitVec 256) (i : Nat) (Q : ZPt) : ZPt :=
  digitStep tbl (slide.digit x2 i) (digitStep baseTbl (slide.digit x1 i) Q)

/-- Four doublings. -/
def dbl4 (Q : ZPt) : ZPt :=
  dbl.spec (dbl.spec (dbl.spec (dbl.spec Q)))

/-- The loop from `pos = i` down to `0` on `Q`: each position's digits, then four doublings but
after `0`. -/
def ladder (tbl : Nat → ZPt) (x1 x2 : BitVec 256) : Nat → ZPt → ZPt
  | 0, Q => posStep tbl x1 x2 0 Q
  | i + 1, Q => ladder tbl x1 x2 i (dbl4 (posStep tbl x1 x2 (i + 1) Q))

/-- Blocks a digit's call allocates: `add`'s 38, `sub`'s 47. -/
def digitBlocks (d : BitVec 8) : Nat :=
  if 0 < d.toInt then 38 else if d.toInt < 0 then 47 else 0

/-- Blocks the loop allocates from `pos = i` down: the digits', and four `dbl`s' 28 but after
`0`. -/
def ladderBlocks (x1 x2 : BitVec 256) : Nat → Nat
  | 0 => digitBlocks (slide.digit x1 0) + digitBlocks (slide.digit x2 0)
  | i + 1 =>
    digitBlocks (slide.digit x1 (i + 1)) + digitBlocks (slide.digit x2 (i + 1)) + 112 +
      ladderBlocks x1 x2 i

/-- `error.WeakPublicKey`'s result: a zero point, error code `4`, zero padding. -/
def weakBits : BitVec 1408 :=
  0#48 ++ 4#16 ++ 0#1344

/-- `P2`'s table entry `k`, `precompute(P2, 8)`'s; the identity past its 9. -/
def pcTbl (P2 : ZPt) (k : Nat) : ZPt :=
  if h : k < 9 then (precompute.spec P2)[k] else identity

/-- `x1 B + x2 P2` as the program computes it: `none` (`error.WeakPublicKey`) if `rejectIdentity`
rejects entry `4` of `P2`'s table. With `is_base` (`b`) set, the base point's table is used
instead, unchecked. -/
def spec (x1 : BitVec 256) (b : BitVec 1) (P2 : ZPt) (x2 : BitVec 256) : Option ZPt :=
  if b = 1#1 then some (ladder baseTbl x1 x2 63 identity)
  else
    if rejectIdentity.spec (pcTbl P2 4) = 0#16 then some (ladder (pcTbl P2) x1 x2 63 identity)
    else none

/-- Blocks the function allocates, its callees' included. -/
def blocks (x1 : BitVec 256) (b : BitVec 1) (P2 : ZPt) (x2 : BitVec 256) : Nat :=
  if b = 1#1 then 20 + ladderBlocks x1 x2 63
  else if rejectIdentity.spec (pcTbl P2 4) = 0#16 then 251 + ladderBlocks x1 x2 63 else 245

/-- The result stored at `out`: `error.WeakPublicKey`'s, or `Q` with error code `0`. -/
def store (m : MemoryState) (out : Pointer) : Option ZPt → MemoryState
  | none => m.storeAt out weakBits
  | some Q => (m.storeAt (out.add 168#64) 0#16).storePt out Q 0#64

end Edwards25519.mulDoubleBasePublic

end

/-! ## Proof -/

section Proof

open Edwards25519.mulDoubleBasePublic

/-- The weak-key result's initializer: its literal. -/
public theorem Edwards25519_mulDoubleBasePublic_weak.value_eq (s : GlobalState) :
    Edwards25519_mulDoubleBasePublic_weak.value s =
      .value (Ty.wrap Edwards25519_mulDoubleBasePublic_weak.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- The weak-key literal's bits. -/
theorem weak_bits :
    Ty.flatBits Edwards25519_mulDoubleBasePublic_weak.lit (w := 1408) (hw := rfl) = weakBits := by
  decide +kernel

/-- `is_base`, the lowest bit of a point's last 8 bytes, loaded alone. -/
theorem _root_.LeanMLIR.RIR.MemoryState.PtFit.isBase {m : MemoryState} {p : Pointer}
    (h : m.PtFit p) :
    Fits m (p.add 160#64) 1 ∧ m.readAt (p.add 160#64) 1 = (m.readRest p).extractLsb' 0 1 := by
  have hf := h.fits_rest
  refine ⟨hf.mono (by omega), ?_⟩
  have :=
    MemoryState.readAt_add_of_readAt (off := 0#64) (w := 1) hf
      (by
        simp [BitVec.uaddOverflow]; exact BitVec.isLt _)
      (by simp) rfl
  rw [Pointer.add_zero] at this
  exact this

/-- A `WF` state stays so with its counter advanced. -/
theorem GlobalState.WF.bump' {s : GlobalState} (h : s.WF) (hn : s.alloc.nextFreeBlock ≤ n) :
    (⟨⟨n⟩, s.mem⟩ : GlobalState).WF :=
  ⟨fun k hk => Nat.lt_of_lt_of_le (h.bound k hk) hn, Nat.lt_of_lt_of_le h.pos hn, h.null⟩

/-- Clearing `is_base` of zero bytes. -/
theorem ZPt.flag_zero : ZPt.flag 0#64 0#1 = 0#64 := by decide

namespace Edwards25519_mulDoubleBasePublic

/-- The function's objects: temporaries `%11 … %17` and the accumulator `%18`, the digits of
`s2` (`%19`) and `s1` (`%20`), the base point's table (`%1`) and `p2`'s (`%24`). -/
structure Ptrs where
  t11 : Pointer
  t12 : Pointer
  t13 : Pointer
  t14 : Pointer
  t15 : Pointer
  t16 : Pointer
  t17 : Pointer
  acc : Pointer
  e2 : Pointer
  e1 : Pointer
  bp : Pointer
  tb : Pointer

/-- The points the loop writes. -/
def Ptrs.temps (P : Ptrs) : List Pointer :=
  [P.t11, P.t12, P.t13, P.t14, P.t15, P.t16, P.t17, P.acc]

/-- The registers the loop reads, `pos` aside. -/
abbrev Regs (P : Ptrs) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) : Prop :=
  E ⊨ [%1 := P.bp, %2 := 0#16, %6 := 168#64, %8 := 0#64, %9 := 0#8, %10 := 18446744073709551615#64,
    %11 := P.t11, %12 := P.t12, %13 := P.t13, %14 := P.t14, %15 := P.t15, %16 := P.t16, %17 :=
    P.t17, %18 := P.acc, %19 := P.e2, %20 := P.e1, %24 := P.tb]

/-- Entries `0 … 8` of a table of points at `p`. -/
def TableAt (m : MemoryState) (p : Pointer) (T : Nat → ZPt) : Prop :=
  ∀ k < 9,
    m.PtFit (p.add (BitVec.ofNat 64 (168 * k))) ∧ m.readPt (p.add (BitVec.ofNat 64 (168 * k))) = T k

/-- `slide`'s digits of `x` at `e`. -/
def DigitsAt (m : MemoryState) (e : Pointer) (x : BitVec 256) : Prop :=
  Fits m e 512 ∧ e.offset = 0 ∧ m.readAt e 512 = BitVec.packLanes (Edwards25519.slide.spec x)

/-- Points that fit, their last 8 bytes zero. -/
def TempsOK (m : MemoryState) (ts : List Pointer) : Prop :=
  ∀ u ∈ ts, m.PtFit u ∧ m.readRest u = 0#64

/-- The temporaries: at offset `0`, in the frame from `N`, apart from the digits and tables. -/
structure Layout (P : Ptrs) (N : Nat) : Prop where
  temp :
    ∀ u ∈ P.temps,
      u.offset = 0 ∧ N ≤ u.id.id ∧ u.id ≠ P.e1.id ∧ u.id ≠ P.e2.id ∧ u.id ≠ P.bp.id ∧ u.id ≠ P.tb.id
  acc : ∀ u ∈ [P.t11, P.t12, P.t13, P.t14, P.t15, P.t16, P.t17], u.id ≠ P.acc.id
  bpo : P.bp.offset.toNat + 1512 ≤ 2 ^ 64
  tbo : P.tb.offset.toNat + 1512 ≤ 2 ^ 64

/-- What the loop needs of a state. -/
structure Facts (P : Ptrs) (x1 x2 : BitVec 256) (T : Nat → ZPt) (S : GlobalState) : Prop where
  wf : S.WF
  temps : TempsOK S.mem P.temps
  d1 : DigitsAt S.mem P.e1 x1
  d2 : DigitsAt S.mem P.e2 x2
  t1 : TableAt S.mem P.bp baseTbl
  t2 : TableAt S.mem P.tb T

/-- `TableAt` past a store into another block. -/
theorem TableAt.storeAt {m : MemoryState} (h : TableAt m p T) (hne : q.id ≠ p.id) (x : BitVec w) :
    TableAt (m.storeAt q x) p T := fun k hk =>
  ⟨(h k hk).1.storeAt, by
    rw [MemoryState.readPt_storeAt_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

/-- `DigitsAt` past a store into another block. -/
theorem DigitsAt.storeAt {m : MemoryState} (h : DigitsAt m e x) (hne : q.id ≠ e.id) (y : BitVec w) :
    DigitsAt (m.storeAt q y) e x :=
  ⟨Fits.storeAt h.1, h.2.1, by
    rw [MemoryState.readAt_storeAt_disjoint (by simp [Range.Disjoint, Range.of, hne]), h.2.2]⟩

/-- Digit `j`, read alone. -/
theorem DigitsAt.lane {m : MemoryState} (h : DigitsAt m e x) (hj : j < 64) :
    Fits m (e.add (BitVec.ofNat 64 j)) 8 ∧
      m.readAt (e.add (BitVec.ofNat 64 j)) 8 = Edwards25519.slide.digit x j := by
  obtain ⟨hf, ho, hr⟩ := h
  have hj' : (BitVec.ofNat 64 j).toNat = j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  have hov : ¬e.offset.uaddOverflow (BitVec.ofNat 64 j) := by
    simp only [BitVec.uaddOverflow, ho, hj', decide_eq_true_eq,
      show (0 : BitVec 64).toNat = 0 from rfl]
    omega
  refine
    ⟨Fits.add_of_le hov
        (by
          rw [hj']; omega)
        hf,
      ?_⟩
  rw [MemoryState.readAt_add_of_readAt hf hov
      (by
        rw [hj']; omega)
      hr,
    hj', BitVec.extractLsb'_packLanes _ _ hj]
  simp [Edwards25519.slide.spec]

/-- `TempsOK` after one of them is stored, its last 8 bytes zero. -/
theorem TempsOK.storePt {m : MemoryState} (h : TempsOK m ts) (ho : ∀ u ∈ ts, u.offset = 0)
    (ht : t ∈ ts) (A : ZPt) : TempsOK (m.storePt t A 0#64) ts := by
  intro u hu
  refine ⟨(h u hu).1.storeAt, ?_⟩
  by_cases he : t.id = u.id
  · have : u = t := by
      have h1 := ho _ hu
      have h2 := ho _ ht
      cases u; cases t
      simp_all
    subst this
    exact (MemoryState.readPt_storePt_self (h u hu).1).2
  · rw [MemoryState.readRest_storeAt_of_id_ne he]
    exact (h u hu).2

/-- `TempsOK` past a store into another block. -/
theorem TempsOK.storeAt {m : MemoryState} (h : TempsOK m ts) (hne : ∀ u ∈ ts, u.id ≠ q.id)
    (x : BitVec w) : TempsOK (m.storeAt q x) ts := fun u hu =>
  ⟨(h u hu).1.storeAt, by
    rw [MemoryState.readRest_storeAt_of_id_ne (hne u hu).symm]; exact (h u hu).2⟩

/-- `Facts` after a temporary is stored, its last 8 bytes zero, the counter advanced. -/
theorem Facts.storePt (h : Facts P x1 x2 T S) (hL : Layout P N) (ht : t ∈ P.temps)
    (hn : S.alloc.nextFreeBlock ≤ n) (A : ZPt) : Facts P x1 x2 T ⟨⟨n⟩, S.mem.storePt t A 0#64⟩ := by
  obtain ⟨-, -, h1, h2, hb, htb⟩ := hL.temp t ht
  exact
    ⟨(GlobalState.WF_storeAt (s := ⟨⟨n⟩, S.mem⟩)).2 (GlobalState.WF.bump' h.wf hn),
      h.temps.storePt (fun u hu => (hL.temp u hu).1) ht A, h.d1.storeAt h1 _, h.d2.storeAt h2 _,
      h.t1.storeAt hb _, h.t2.storeAt htb _⟩

/-- `getelementptr` to entry `k ≤ 8` of a table of points. -/
theorem gep_entry {p : Pointer} (hp : p.offset.toNat + 1512 ≤ 2 ^ 64) (hk : k ≤ 8) :
    Operation.gep (.value (BitVec.ofNat 64 (k * 168))) (.value p) =
      .value (p.add (BitVec.ofNat 64 (168 * k))) := by
  rw [gep_value, Nat.mul_comm]
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, not_le]
  rw [Nat.mod_eq_of_lt (show k * 168 < 2 ^ 64 by omega)]
  omega

/-- `Facts` after a temporary is copied to the accumulator, which then reads the same point. -/
theorem Facts.copy (h : Facts P x1 x2 T S) (hL : Layout P N) (ht : t ∈ P.temps) :
    Facts P x1 x2 T ⟨S.alloc, S.mem.storeAt P.acc (S.mem.readAt t 1344)⟩ ∧
      (S.mem.storeAt P.acc (S.mem.readAt t 1344)).readPt P.acc = S.mem.readPt t ∧
      (S.mem.storeAt P.acc (S.mem.readAt t 1344)).eraseFrom N = S.mem.eraseFrom N := by
  have hacc : P.acc ∈ P.temps := by simp [Ptrs.temps]
  obtain ⟨hf, hr⟩ := h.temps t ht
  rw [MemoryState.storeAt_readAt_eq_storePt hf, hr]
  refine
    ⟨h.storePt hL hacc (Nat.le_refl _) _, (MemoryState.readPt_storePt_self (h.temps _ hacc).1).1,
      ?_⟩
  exact MemoryState.eraseFrom_storeAt_of_le (hL.temp _ hacc).2.1

/-- A point stored at a temporary, then copied to the accumulator: read there, in the frame. -/
theorem Facts.through (h : Facts P x1 x2 T S) (hL : Layout P N) (ht : t ∈ P.temps) (A : ZPt) :
    ((S.mem.storePt t A 0#64).storeAt P.acc ((S.mem.storePt t A 0#64).readAt t 1344)).readPt P.acc =
        A ∧
      ((S.mem.storePt t A 0#64).storeAt P.acc ((S.mem.storePt t A 0#64).readAt t 1344)).eraseFrom
          N =
        S.mem.eraseFrom N := by
  have h1 := h.storePt hL ht (Nat.le_refl _) A
  obtain ⟨-, hr, he⟩ := h1.copy hL ht
  refine ⟨hr.trans (MemoryState.readPt_storePt_self (h.temps t ht).1).1, he.trans ?_⟩
  exact MemoryState.eraseFrom_storeAt_of_le (hL.temp _ ht).2.1

/-- `Facts.storePt`'s store is in the frame. -/
theorem eraseFrom_storePt (hL : Layout P N) (ht : t ∈ P.temps) (m : MemoryState) (A : ZPt)
    (r : BitVec 64) : (m.storePt t A r).eraseFrom N = m.eraseFrom N :=
  MemoryState.eraseFrom_storeAt_of_le (hL.temp _ ht).2.1

/-- The accumulator apart from another temporary. -/
theorem Layout.disj (hL : Layout P N) (ht : t ∈ [P.t11, P.t12, P.t13, P.t14, P.t15, P.t16, P.t17]) :
    (Range.of P.acc 1344).Disjoint (Range.of t 1344) :=
  .inl (hL.acc t ht).symm

/-- A positive digit, `d ≤ 8`. -/
theorem digit_pos {d : BitVec 8} (h1 : (0#8).slt d = true) (h2 : d.toInt ≤ 8) :
    0 < d.toInt ∧ d.toNat ≤ 8 ∧ d.msb = false := by
  revert d; decide

/-- A negative digit, `-8 ≤ d`: `0 - d` does not overflow, and is `|d|`. -/
theorem digit_neg {d : BitVec 8} (h1 : d.slt 0#8 = true) (h2 : -8 ≤ d.toInt) :
    d.toInt < 0 ∧
      ¬0 < d.toInt ∧
      (0#8).ssubOverflow d = false ∧ 0#8 - d = -d ∧ (-d).toNat ≤ 8 ∧ (-d).msb = false := by
  revert d; decide

/-- A digit neither positive nor negative. -/
theorem digit_zero {d : BitVec 8} (h1 : ¬(0#8).slt d = true) (h2 : ¬d.slt 0#8 = true) :
    ¬0 < d.toInt ∧ ¬d.toInt < 0 := by
  revert d; decide

/-- The function's arguments. -/
abbrev Args (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (out s1 p2 s2 : Pointer) : Prop :=
  E.args =
    (Edwards25519_mulDoubleBasePublic.args (.value out) (.value s1) (.value p2) (.value s2)).get

/-- `^bb5`: `s1`'s digit at `pos = i` on the accumulator; on to `^bb7`. -/
theorem digit1_block (P : Ptrs) (N : Nat) (hL : Layout P N) (x1 x2 : BitVec 256) (T : Nat → ZPt)
    (hT : ∀ k < 9, (baseTbl k).Lt (2 ^ 53)) (out s1 p2 s2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 64)
    (hd : -8 ≤ (Edwards25519.slide.digit x1 i).toInt ∧ (Edwards25519.slide.digit x1 i).toInt ≤ 8)
    (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : Regs P E) (hRi : E ⊨ [%28 := BitVec.ofNat 64 i])
    (hF : Facts P x1 x2 T S) (hQd : S.mem.readPt P.acc = Q)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        Args E' out s1 p2 s2 →
          Regs P E' →
          (E' ⊨ [%28 := BitVec.ofNat 64 i]) →
          Facts P x1 x2 T S' →
          S'.mem.readPt P.acc = digitStep baseTbl (Edwards25519.slide.digit x1 i) Q →
          S'.alloc.nextFreeBlock =
            S.alloc.nextFreeBlock + digitBlocks (Edwards25519.slide.digit x1 i) →
          S'.mem.eraseFrom N = S.mem.eraseFrom N →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb7 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb5 S >>= g) = K := by
  obtain ⟨hf1, hl1⟩ := hF.d1.lane hi
  generalize Edwards25519.slide.digit x1 i = d at hd hl1 hK
  dsimp only [Regs] at hR
  have he1o := hF.d1.2.1
  have hwf := hF.wf
  block_init
  step_pure [Nat.mod_lt i (by decide : 0 < 18446744073709551616)]
  step_load consuming hf1 hl1
  step_pure
  finish_block
  case isTrue =>
    have hF₀ := hS ▸ hF
    obtain ⟨hpos, hk, hmsb⟩ := digit_pos hbr hd.2
    obtain ⟨hTf, hTr⟩ := hF.t1 d.toNat (by omega)
    have hTl := hT d.toNat (by omega)
    obtain ⟨h17, h17r⟩ := hF.temps P.t17 (by simp [Ptrs.temps])
    obtain ⟨hacc, haccr⟩ := hF.temps P.acc (by simp [Ptrs.temps])
    have hbpo := hL.bpo
    block_init
    step_pure [hmsb]
    step_pure [hmsb, Nat.mod_eq_of_lt (show d.toNat < 18446744073709551616 by omega),
      show d.toNat * 168 < 18446744073709551616 by omega, gep_entry hbpo hk]
    step_call using Edwards25519_add.call_eq_of
    case hF =>
      subst hS'; rw [ZPt.flag_zero]; exact hF.storePt hL (by simp [Ptrs.temps]) (by omega) _
    finish_block
    block_init
    have f1 := hacc.2
    have f2 := h17.2
    have hd := hL.disj (t := P.t17) (by simp)
    step_memcpy
    case hF =>
      subst hS'; exact (hF.copy hL (t := P.t17) (by simp [Ptrs.temps])).1
    finish_block
    rw [ZPt.flag_zero] at hS
    obtain ⟨hr, he⟩ :=
      hF₀.through hL (t := P.t17) (by simp [Ptrs.temps]) (Edwards25519.add.spec Q (baseTbl d.toNat))
    refine
        hK E S
          (by
            rw [hE]; exact hArgs)
          (by env_reads) (by env_reads) hF ?_ ?_ ?_ <;>
      rw [hS]
    · simp only [hr, digitStep, hpos, ite_true]
    · simp [digitBlocks, hpos]
    · exact he
  case isFalse =>
    have hF₀ := hS ▸ hF
    have hnp := hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      obtain ⟨hneg, hnpos, hov, hsub, hk, hmsb⟩ := digit_neg hbr hd.1
      obtain ⟨hTf, hTr⟩ := hF.t1 (-d).toNat (by omega)
      have hTl := hT (-d).toNat (by omega)
      obtain ⟨h16, h16r⟩ := hF.temps P.t16 (by simp [Ptrs.temps])
      obtain ⟨hacc, haccr⟩ := hF.temps P.acc (by simp [Ptrs.temps])
      have hbpo := hL.bpo
      block_init
      step_pure [hov, hsub] with m hm
      rw [← hm] at hTf hTr hTl hk hmsb
      step_pure [hmsb]
      step_pure [hmsb, Nat.mod_eq_of_lt (show m.toNat < 18446744073709551616 by omega),
        show m.toNat * 168 < 18446744073709551616 by omega, gep_entry hbpo hk]
      step_call using Edwards25519_sub.call_eq_of
      case hF =>
        subst hS'; exact hF.storePt hL (by simp [Ptrs.temps]) (by omega) _
      finish_block
      block_init
      have f1 := hacc.2
      have f2 := h16.2
      have hd := hL.disj (t := P.t16) (by simp)
      step_memcpy
      case hF =>
        subst hS'; exact (hF.copy hL (t := P.t16) (by simp [Ptrs.temps])).1
      finish_block
      obtain ⟨hr, he⟩ :=
        hF₀.through hL (t := P.t16) (by simp [Ptrs.temps])
          (Edwards25519.sub.spec Q (baseTbl m.toNat))
      refine
          hK E S
            (by
              rw [hE]; exact hArgs)
            (by env_reads) (by env_reads) hF ?_ ?_ ?_ <;>
        rw [hS]
      · simp only [digitStep, hnpos, hneg, ite_true, ite_false]
        rw [← hm]
        exact hr
      · simp [digitBlocks, hnpos, hneg]
      · exact he
    case isFalse =>
      obtain ⟨h1, h2⟩ := digit_zero hnp hbr
      refine
        hK E S
          (by
            rw [hE]; exact hArgs)
          (by env_reads) (by env_reads) hF ?_ ?_ ?_
      · simp only [hQd, digitStep, h1, h2, ite_false]
      · rw [hS]; simp [digitBlocks, h1, h2]
      · rw [hS]

/-- `^bb7`: `s2`'s digit at `pos = i` on the accumulator, from `p2`'s table; on to `^bb12`. -/
theorem digit2_block (P : Ptrs) (N : Nat) (hL : Layout P N) (x1 x2 : BitVec 256) (T : Nat → ZPt)
    (hT : ∀ k < 9, (T k).Lt (2 ^ 53)) (out s1 p2 s2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 64)
    (hd : -8 ≤ (Edwards25519.slide.digit x2 i).toInt ∧ (Edwards25519.slide.digit x2 i).toInt ≤ 8)
    (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : Regs P E) (hRi : E ⊨ [%28 := BitVec.ofNat 64 i])
    (hF : Facts P x1 x2 T S) (hQd : S.mem.readPt P.acc = Q)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        Args E' out s1 p2 s2 →
          Regs P E' →
          (E' ⊨ [%28 := BitVec.ofNat 64 i]) →
          Facts P x1 x2 T S' →
          S'.mem.readPt P.acc = digitStep T (Edwards25519.slide.digit x2 i) Q →
          S'.alloc.nextFreeBlock =
            S.alloc.nextFreeBlock + digitBlocks (Edwards25519.slide.digit x2 i) →
          S'.mem.eraseFrom N = S.mem.eraseFrom N →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb12 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb7 S >>= g) = K := by
  obtain ⟨hf1, hl1⟩ := hF.d2.lane hi
  generalize Edwards25519.slide.digit x2 i = d at hd hl1 hK
  dsimp only [Regs] at hR
  have he2o := hF.d2.2.1
  have hwf := hF.wf
  block_init
  step_pure [Nat.mod_lt i (by decide : 0 < 18446744073709551616)]
  step_load consuming hf1 hl1
  step_pure
  finish_block
  case isTrue =>
    have hF₀ := hS ▸ hF
    obtain ⟨hpos, hk, hmsb⟩ := digit_pos hbr hd.2
    obtain ⟨hTf, hTr⟩ := hF.t2 d.toNat (by omega)
    have hTl := hT d.toNat (by omega)
    obtain ⟨h15, h15r⟩ := hF.temps P.t15 (by simp [Ptrs.temps])
    obtain ⟨hacc, haccr⟩ := hF.temps P.acc (by simp [Ptrs.temps])
    have htbo := hL.tbo
    block_init
    step_pure [hmsb]
    step_pure [hmsb, Nat.mod_eq_of_lt (show d.toNat < 18446744073709551616 by omega),
      show d.toNat * 168 < 18446744073709551616 by omega, gep_entry htbo hk]
    step_call using Edwards25519_add.call_eq_of
    case hF =>
      subst hS'; rw [ZPt.flag_zero]; exact hF.storePt hL (by simp [Ptrs.temps]) (by omega) _
    finish_block
    block_init
    have f1 := hacc.2
    have f2 := h15.2
    have hd := hL.disj (t := P.t15) (by simp)
    step_memcpy
    case hF =>
      subst hS'; exact (hF.copy hL (t := P.t15) (by simp [Ptrs.temps])).1
    finish_block
    rw [ZPt.flag_zero] at hS
    obtain ⟨hr, he⟩ :=
      hF₀.through hL (t := P.t15) (by simp [Ptrs.temps]) (Edwards25519.add.spec Q (T d.toNat))
    refine
        hK E S
          (by
            rw [hE]; exact hArgs)
          (by env_reads) (by env_reads) hF ?_ ?_ ?_ <;>
      rw [hS]
    · simp only [hr, digitStep, hpos, ite_true]
    · simp [digitBlocks, hpos]
    · exact he
  case isFalse =>
    have hF₀ := hS ▸ hF
    have hnp := hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      obtain ⟨hneg, hnpos, hov, hsub, hk, hmsb⟩ := digit_neg hbr hd.1
      obtain ⟨hTf, hTr⟩ := hF.t2 (-d).toNat (by omega)
      have hTl := hT (-d).toNat (by omega)
      obtain ⟨h14, h14r⟩ := hF.temps P.t14 (by simp [Ptrs.temps])
      obtain ⟨hacc, haccr⟩ := hF.temps P.acc (by simp [Ptrs.temps])
      have htbo := hL.tbo
      block_init
      step_pure [hov, hsub] with m hm
      rw [← hm] at hTf hTr hTl hk hmsb
      step_pure [hmsb]
      step_pure [hmsb, Nat.mod_eq_of_lt (show m.toNat < 18446744073709551616 by omega),
        show m.toNat * 168 < 18446744073709551616 by omega, gep_entry htbo hk]
      step_call using Edwards25519_sub.call_eq_of
      case hF =>
        subst hS'; exact hF.storePt hL (by simp [Ptrs.temps]) (by omega) _
      finish_block
      block_init
      have f1 := hacc.2
      have f2 := h14.2
      have hd := hL.disj (t := P.t14) (by simp)
      step_memcpy
      case hF =>
        subst hS'; exact (hF.copy hL (t := P.t14) (by simp [Ptrs.temps])).1
      finish_block
      obtain ⟨hr, he⟩ :=
        hF₀.through hL (t := P.t14) (by simp [Ptrs.temps]) (Edwards25519.sub.spec Q (T m.toNat))
      refine
          hK E S
            (by
              rw [hE]; exact hArgs)
            (by env_reads) (by env_reads) hF ?_ ?_ ?_ <;>
        rw [hS]
      · simp only [digitStep, hnpos, hneg, ite_true, ite_false]
        rw [← hm]
        exact hr
      · simp [digitBlocks, hnpos, hneg]
      · exact he
    case isFalse =>
      obtain ⟨h1, h2⟩ := digit_zero hnp hbr
      refine
        hK E S
          (by
            rw [hE]; exact hArgs)
          (by env_reads) (by env_reads) hF ?_ ?_ ?_
      · simp only [hQd, digitStep, h1, h2, ite_false]
      · rw [hS]; simp [digitBlocks, h1, h2]
      · rw [hS]

/-- A point stored where it then fits reads back. -/
theorem readPt_storePt_of_fit {m : MemoryState} (h : (m.storePt p A r).PtFit p) :
    (m.storePt p A r).readPt p = A :=
  (MemoryState.readPt_storePt_self ⟨h.1, Fits.storeAt_iff.mp h.2⟩).1

/-- `2P`'s `x, y, z` are below `2^53`. -/
theorem dbl_lt53 (A : ZPt) :
    Fe.Lt (Edwards25519.dbl.spec A).x (2 ^ 53) ∧
      Fe.Lt (Edwards25519.dbl.spec A).y (2 ^ 53) ∧ Fe.Lt (Edwards25519.dbl.spec A).z (2 ^ 53) :=
  have h := Edwards25519.dbl.spec_lt A
  ⟨h.1.mono (by decide), h.2.1.mono (by decide), h.2.2.1.mono (by decide)⟩

/-- A small `pos` is `0` exactly when it is. -/
theorem eq_zero_of_ofNat64 {i : Nat} (hi : i < 2 ^ 64) (h : BitVec.ofNat 64 i = 0#64) : i = 0 := by
  have := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt hi] at this
  exact this

/-- `pos - 1`, as `pos + -1`, on a positive `pos`. -/
theorem add_neg_one64 {i : Nat} (h1 : 1 ≤ i) (h : i < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow 18446744073709551615#64 = false ∧
      BitVec.ofNat 64 i + 18446744073709551615#64 = BitVec.ofNat 64 (i - 1) := by
  have hn : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (18446744073709551615#64).toInt = -1 := by decide
  refine
    ⟨by
      simp [BitVec.saddOverflow, hn, hm]; omega, ?_⟩
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- `^bb12`: out at `pos = 0`, else four doublings and around at `pos - 1`. -/
theorem tail_block (P : Ptrs) (N : Nat) (hL : Layout P N) (x1 x2 : BitVec 256) (T : Nat → ZPt)
    (out s1 p2 s2 : Pointer) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat)
    (hi : i < 64) (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) (S : GlobalState)
    (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (hArgs : Args E out s1 p2 s2) (hR : Regs P E)
    (hRi : E ⊨ [%28 := BitVec.ofNat 64 i]) (hF : Facts P x1 x2 T S) (hQd : S.mem.readPt P.acc = Q)
    (hexit :
      i = 0 →
        ∀ E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫,
          Args E' out s1 p2 s2 →
            Regs P E' → (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb16 S >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
            Args E' out s1 p2 s2 →
              Regs P E' →
              (E' ⊨ [%28 := BitVec.ofNat 64 j]) →
              Facts P x1 x2 T S' →
              S'.mem.readPt P.acc = dbl4 Q →
              S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 112 →
              S'.mem.eraseFrom N = S.mem.eraseFrom N →
              (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb5 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb12 S >>= g) = K := by
  have hwf := hF.wf
  dsimp only [Regs] at hR
  block_init
  step_pure
  finish_block
  case isTrue =>
    exact
      hexit (eq_zero_of_ofNat64 (by omega) hbr) E
        (by
          rw [hE]; exact hArgs)
        (by env_reads)
  case isFalse =>
    have hi0 : 1 ≤ i := Nat.one_le_iff_ne_zero.mpr fun h => hbr (by rw [h])
    obtain ⟨S₁, hS₁⟩ : ∃ S₁, S₁ = S := ⟨S, rfl⟩
    have hF₀ : Facts P x1 x2 T S₁ := hS₁ ▸ hF
    obtain ⟨h11, -⟩ := hF.temps P.t11 (by simp [Ptrs.temps])
    obtain ⟨h12, -⟩ := hF.temps P.t12 (by simp [Ptrs.temps])
    obtain ⟨h13, -⟩ := hF.temps P.t13 (by simp [Ptrs.temps])
    obtain ⟨hacc, -⟩ := hF.temps P.acc (by simp [Ptrs.temps])
    obtain ⟨hX, hY, hZ⟩ : Fe.Lt Q.x (2 ^ 53) ∧ Fe.Lt Q.y (2 ^ 53) ∧ Fe.Lt Q.z (2 ^ 53) :=
      ⟨hQ.1, hQ.2.1, hQ.2.2.1⟩
    block_init
    step_call using Edwards25519_dbl.call_eq_of
    case hF =>
      subst hS'
      rw [(hF.temps P.t13 (by simp [Ptrs.temps])).2, ZPt.flag_zero]
      exact hF.storePt hL (by simp [Ptrs.temps]) (by omega) _
    subst hS₁
    rw [(hF₀.temps P.t13 (by simp [Ptrs.temps])).2, ZPt.flag_zero] at hS
    have hv : S.mem.readPt P.t13 = Edwards25519.dbl.spec Q := by
      rw [hS] at h13 ⊢; exact readPt_storePt_of_fit h13
    obtain ⟨hX, hY, hZ⟩ := dbl_lt53 Q
    have hr := (hF.temps P.t12 (by simp [Ptrs.temps])).2
    step_call using Edwards25519_dbl.call_eq_of
    case hF =>
      subst hS'; try simp only [ZPt.flag_zero]
      exact hF.storePt hL (by simp [Ptrs.temps]) (by omega) _
    try simp only [ZPt.flag_zero] at hS
    have hv : S.mem.readPt P.t12 = Edwards25519.dbl.spec (Edwards25519.dbl.spec Q) := by
      rw [hS] at h12 ⊢; exact readPt_storePt_of_fit h12
    obtain ⟨hX, hY, hZ⟩ := dbl_lt53 (Edwards25519.dbl.spec Q)
    have hr := (hF.temps P.t11 (by simp [Ptrs.temps])).2
    step_call using Edwards25519_dbl.call_eq_of
    case hF =>
      subst hS'; try simp only [ZPt.flag_zero]
      exact hF.storePt hL (by simp [Ptrs.temps]) (by omega) _
    try simp only [ZPt.flag_zero] at hS
    have hv :
      S.mem.readPt P.t11 =
        Edwards25519.dbl.spec (Edwards25519.dbl.spec (Edwards25519.dbl.spec Q)) := by
      rw [hS] at h11 ⊢; exact readPt_storePt_of_fit h11
    obtain ⟨hX, hY, hZ⟩ := dbl_lt53 (Edwards25519.dbl.spec (Edwards25519.dbl.spec Q))
    have hr := (hF.temps P.acc (by simp [Ptrs.temps])).2
    step_call using Edwards25519_dbl.call_eq_of
    case hF =>
      subst hS'; try simp only [ZPt.flag_zero]
      exact hF.storePt hL (by simp [Ptrs.temps]) (by omega) _
    try simp only [ZPt.flag_zero] at hS
    obtain ⟨ho, hn⟩ := add_neg_one64 hi0 (by omega)
    step_pure [ho, hn]
    finish_block
    refine
      hback (i - 1) (by omega) E S
        (by
          rw [hE]; exact hArgs)
        (by env_reads) (by env_reads) hF ?_ ?_ ?_
    · rw [hS] at hacc ⊢; exact readPt_storePt_of_fit hacc
    · rw [hS]
    · rw [hS]
      dsimp only
      rw [eraseFrom_storePt hL (t := P.acc) (by simp [Ptrs.temps]),
        eraseFrom_storePt hL (t := P.t11) (by simp [Ptrs.temps]),
        eraseFrom_storePt hL (t := P.t12) (by simp [Ptrs.temps]),
        eraseFrom_storePt hL (t := P.t13) (by simp [Ptrs.temps])]

/-- A digit's step keeps limbs below `2^53`. -/
theorem digitStep_lt (tbl : Nat → ZPt) (d : BitVec 8) {Q : ZPt} (hQ : Q.Lt (2 ^ 53)) :
    (digitStep tbl d Q).Lt (2 ^ 53) := by
  unfold digitStep
  split
  · exact ZPt.Lt.mono53 (Edwards25519.add.spec_lt _ _)
  · split
    · exact ZPt.Lt.mono53 (Edwards25519.sub.spec_lt _ _)
    · exact hQ

/-- One iteration at `pos = i`: both digits, then out at `0`, else four doublings and around. -/
theorem iter (P : Ptrs) (N : Nat) (hL : Layout P N) (x1 x2 : BitVec 256) (T : Nat → ZPt)
    (hT1 : ∀ k < 9, (baseTbl k).Lt (2 ^ 53)) (hT2 : ∀ k < 9, (T k).Lt (2 ^ 53))
    (hd1 :
      ∀ k < 64,
        -8 ≤ (Edwards25519.slide.digit x1 k).toInt ∧ (Edwards25519.slide.digit x1 k).toInt ≤ 8)
    (hd2 :
      ∀ k < 64,
        -8 ≤ (Edwards25519.slide.digit x2 k).toInt ∧ (Edwards25519.slide.digit x2 k).toInt ≤ 8)
    (out s1 p2 s2 : Pointer) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat)
    (hi : i < 64) (Q : ZPt) (hQ : Q.Lt (2 ^ 53)) (S : GlobalState)
    (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (hArgs : Args E out s1 p2 s2) (hR : Regs P E)
    (hRi : E ⊨ [%28 := BitVec.ofNat 64 i]) (hF : Facts P x1 x2 T S) (hQd : S.mem.readPt P.acc = Q)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
          Args E' out s1 p2 s2 →
            Regs P E' →
            Facts P x1 x2 T S' →
            S'.mem.readPt P.acc = posStep T x1 x2 i Q →
            S'.alloc.nextFreeBlock =
              S.alloc.nextFreeBlock + digitBlocks (Edwards25519.slide.digit x1 i) +
                digitBlocks (Edwards25519.slide.digit x2 i) →
            S'.mem.eraseFrom N = S.mem.eraseFrom N →
            (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb16 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
            Args E' out s1 p2 s2 →
              Regs P E' →
              (E' ⊨ [%28 := BitVec.ofNat 64 j]) →
              Facts P x1 x2 T S' →
              S'.mem.readPt P.acc = dbl4 (posStep T x1 x2 i Q) →
              S'.alloc.nextFreeBlock =
                S.alloc.nextFreeBlock + digitBlocks (Edwards25519.slide.digit x1 i) +
                  digitBlocks (Edwards25519.slide.digit x2 i) +
                  112 →
              S'.mem.eraseFrom N = S.mem.eraseFrom N →
              (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb5 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb5 S >>= g) = K := by
  refine
    digit1_block P N hL x1 x2 T hT1 out s1 p2 s2 g K i hi (hd1 i hi) Q hQ S E hArgs hR hRi hF hQd
      fun E₁ S₁ hA₁ hR₁ hRi₁ hF₁ hQ₁ hn₁ he₁ => ?_
  have hQb₁ := digitStep_lt baseTbl (Edwards25519.slide.digit x1 i) hQ
  refine
    digit2_block P N hL x1 x2 T hT2 out s1 p2 s2 g K i hi (hd2 i hi) _ hQb₁ S₁ E₁ hA₁ hR₁ hRi₁ hF₁
      hQ₁ fun E₂ S₂ hA₂ hR₂ hRi₂ hF₂ hQ₂ hn₂ he₂ => ?_
  have hQb₂ := digitStep_lt T (Edwards25519.slide.digit x2 i) hQb₁
  refine
    tail_block P N hL x1 x2 T out s1 p2 s2 g K i hi _ hQb₂ S₂ E₂ hA₂ hR₂ hRi₂ hF₂ hQ₂
      (fun h0 E₃ hA₃ hR₃ => hexit h0 E₃ S₂ hA₃ hR₃ hF₂ hQ₂ (by omega) (he₂.trans he₁))
      fun j hj E₃ S₃ hA₃ hR₃ hRi₃ hF₃ hQ₃ hn₃ he₃ =>
      hback j hj E₃ S₃ hA₃ hR₃ hRi₃ hF₃ hQ₃ (by omega) (he₃.trans (he₂.trans he₁))

/-- `dbl4`'s limbs are below `2^53`. -/
theorem dbl4_lt (A : ZPt) : (dbl4 A).Lt (2 ^ 53) :=
  ZPt.Lt.mono53 (Edwards25519.dbl.spec_lt _)

/-- The loop from `^bb5` at `pos = i`: the accumulator becomes `ladder … i Q`, then `^bb16`. -/
theorem loop (P : Ptrs) (N : Nat) (hL : Layout P N) (x1 x2 : BitVec 256) (T : Nat → ZPt)
    (hT1 : ∀ k < 9, (baseTbl k).Lt (2 ^ 53)) (hT2 : ∀ k < 9, (T k).Lt (2 ^ 53))
    (hd1 :
      ∀ k < 64,
        -8 ≤ (Edwards25519.slide.digit x1 k).toInt ∧ (Edwards25519.slide.digit x1 k).toInt ≤ 8)
    (hd2 :
      ∀ k < 64,
        -8 ≤ (Edwards25519.slide.digit x2 k).toInt ∧ (Edwards25519.slide.digit x2 k).toInt ≤ 8)
    (out s1 p2 s2 : Pointer) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i,
      i < 64 →
        ∀ (Q : ZPt) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫),
          Args E out s1 p2 s2 →
            Regs P E →
            (E ⊨ [%28 := BitVec.ofNat 64 i]) →
            Facts P x1 x2 T S →
            S.mem.readPt P.acc = Q →
            Q.Lt (2 ^ 53) →
            (∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
              Args E' out s1 p2 s2 →
                Regs P E' →
                Facts P x1 x2 T S' →
                S'.mem.readPt P.acc = ladder T x1 x2 i Q →
                S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + ladderBlocks x1 x2 i →
                S'.mem.eraseFrom N = S.mem.eraseFrom N →
                (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb16 S' >>= g) = K) →
            (Edwards25519_mulDoubleBasePublic.runFrom E ^bb5 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi Q S E hA hR hRi hF hQd hQ hK
    exact
      iter P N hL x1 x2 T hT1 hT2 hd1 hd2 out s1 p2 s2 g K 0 hi Q hQ S E hA hR hRi hF hQd
        (fun _ E' S' hA' hR' hF' hQ' hn he =>
          hK E' S' hA' hR' hF' hQ'
            (by
              rw [hn]; simp only [ladderBlocks]; omega)
            he)
        fun j hj => absurd hj (by omega)
  | succ j ih =>
    intro hi Q S E hA hR hRi hF hQd hQ hK
    refine
      iter P N hL x1 x2 T hT1 hT2 hd1 hd2 out s1 p2 s2 g K (j + 1) hi Q hQ S E hA hR hRi hF hQd
        (fun h => absurd h (by omega)) fun j' hj E' S' hA' hR' hRi' hF' hQ' hn he => ?_
    obtain rfl : j = j' := by omega
    exact
      ih (by omega) _ S' E' hA' hR' hRi' hF' hQ' (dbl4_lt _)
        fun E'' S'' hA'' hR'' hF'' hQ'' hn'' he'' =>
        hK E'' S'' hA'' hR'' hF'' hQ''
          (by
            rw [hn'', hn]; simp only [ladderBlocks]; omega)
          (he''.trans he)

/-- The top nibble of a scalar below `2^255` is below `8`. -/
theorem nib63_lt {x : BitVec 256} (h : x.msb = false) : x.extractLsb' 252 4 < 8#4 := by bv_decide

/-- The identity's limbs are below `2^53`. -/
theorem identity_lt : Edwards25519.identity.Lt (2 ^ 53) := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> intro i <;> fin_cases i <;> decide

/-- `slide`'s digits of a scalar below `2^255` are in `[-8, 8]`. -/
theorem digit_bound {x : BitVec 256} (h : x.msb = false) (k : Nat) (hk64 : k < 64) :
    -8 ≤ (Edwards25519.slide.digit x k).toInt ∧ (Edwards25519.slide.digit x k).toInt ≤ 8 := by
  have hc := Edwards25519_slide.carry_01 x k
  unfold Edwards25519.slide.digit Edwards25519.slide.nib
  by_cases hk : k < 63
  · simp only [hk, ite_true]
    generalize x.extractLsb' (4 * k) 4 = a
    generalize Edwards25519.slide.carry x k = c at hc
    rcases hc with rfl | rfl <;> revert a <;> decide
  · simp only [hk, ite_false]
    have h8 : x.extractLsb' (4 * k) 4 < 8#4 := by
      rw [show 4 * k = 252 by omega]; exact nib63_lt h
    generalize x.extractLsb' (4 * k) 4 = a at h8
    generalize Edwards25519.slide.carry x k = c at hc
    rcases hc with rfl | rfl <;> revert a <;> decide

/-- `^bb2`: both scalars' digits, the accumulator the identity, then the loop from `pos = 63`. -/
theorem from_bb2 (P : Ptrs) (N : Nat) (hL : Layout P N) (x1 x2 : BitVec 256) (T : Nat → ZPt)
    (hT1 : ∀ k < 9, (baseTbl k).Lt (2 ^ 53)) (hT2 : ∀ k < 9, (T k).Lt (2 ^ 53))
    (hm1 : x1.msb = false) (hm2 : x2.msb = false) (out s1 p2 s2 idp : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (S : GlobalState)
    (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (hArgs : Args E out s1 p2 s2) (hR : Regs P E)
    (hR' : E ⊨ [%5 := idp, %7 := 63#64]) (hwf : S.WF) (htemps : TempsOK S.mem P.temps)
    (he1 : Fits S.mem P.e1 512) (he1o : P.e1.offset = 0) (he2 : Fits S.mem P.e2 512)
    (he2o : P.e2.offset = 0) (hs1 : Fits S.mem s1 256) (hs1o : ¬s1.offset.uaddOverflow 32#64)
    (hx1 : S.mem.readAt s1 256 = x1) (hs2 : Fits S.mem s2 256)
    (hs2o : ¬s2.offset.uaddOverflow 32#64) (hx2 : S.mem.readAt s2 256 = x2)
    (ht1 : TableAt S.mem P.bp baseTbl) (ht2 : TableAt S.mem P.tb T) (hid : S.mem.PtFit idp)
    (hidv : S.mem.readAt idp 1344 = Edwards25519.identity.bits 0#64) (h12 : P.e1.id ≠ P.e2.id)
    (h1s : P.e1.id ≠ s2.id) (h1b : P.e1.id ≠ P.bp.id) (h1t : P.e1.id ≠ P.tb.id)
    (h1i : P.e1.id ≠ idp.id) (h2b : P.e2.id ≠ P.bp.id) (h2t : P.e2.id ≠ P.tb.id)
    (h2i : P.e2.id ≠ idp.id) (hai : P.acc.id ≠ idp.id) (hN1 : N ≤ P.e1.id.id) (hN2 : N ≤ P.e2.id.id)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        Args E' out s1 p2 s2 →
          Regs P E' →
          Facts P x1 x2 T S' →
          S'.mem.readPt P.acc = ladder T x1 x2 63 Edwards25519.identity →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 6 + ladderBlocks x1 x2 63 →
          S'.mem.eraseFrom N = S.mem.eraseFrom N →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb16 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb2 S >>= g) = K := by
  have hm1' : (S.mem.readAt s1 256).msb = false := hx1 ▸ hm1
  dsimp only [Regs] at hR
  unfold Args at hArgs
  block_init
  step_call using Edwards25519_slide.call_eq
  case htemps =>
    subst hS'; exact htemps.storeAt (fun u hu => (hL.temp u hu).2.2.1) _
  case ht1 =>
    subst hS'; exact ht1.storeAt h1b _
  case ht2 =>
    subst hS'; exact ht2.storeAt h1t _
  have hD1 : DigitsAt S.mem P.e1 x1 := ⟨he1, he1o, hread⟩
  clear hread
  have hm2' : (S.mem.readAt s2 256).msb = false := by
    rw [hx2]; exact hm2
  step_call using Edwards25519_slide.call_eq consuming hm2'
  case htemps =>
    subst hS'; exact htemps.storeAt (fun u hu => (hL.temp u hu).2.2.2.1) _
  case ht1 =>
    subst hS'; exact ht1.storeAt h2b _
  case ht2 =>
    subst hS'; exact ht2.storeAt h2t _
  case hD1 =>
    subst hS'; exact hD1.storeAt h12.symm _
  have hD2 : DigitsAt S.mem P.e2 x2 := ⟨he2, he2o, hread⟩
  clear hread
  have hacc : P.acc ∈ P.temps := by simp [Ptrs.temps]
  have f1 := (htemps P.acc hacc).1.2
  have f2 := hid.2
  have hd : (Range.of P.acc 1344).Disjoint (Range.of idp 1344) := .inl hai
  step_memcpy
  case htemps =>
    subst hS'; exact htemps.storePt (fun u hu => (hL.temp u hu).1) hacc Edwards25519.identity
  case ht1 =>
    subst hS'; exact ht1.storeAt (hL.temp _ hacc).2.2.2.2.1 _
  case ht2 =>
    subst hS'; exact ht2.storeAt (hL.temp _ hacc).2.2.2.2.2 _
  case hD1 =>
    subst hS'; exact hD1.storeAt (hL.temp _ hacc).2.2.1 _
  case hD2 =>
    subst hS'; exact hD2.storeAt (hL.temp _ hacc).2.2.2.1 _
  finish_block
  have hQ0 : S.mem.readPt P.acc = Edwards25519.identity := by
    have h := (htemps P.acc hacc).1
    rw [hS] at h ⊢; exact readPt_storePt_of_fit (r := 0#64) h
  refine
    loop P N hL x1 x2 T hT1 hT2 (digit_bound hm1) (digit_bound hm2) out s1 p2 s2 g K 63 (by omega) _
      S E hArgs (by env_reads) (by env_reads) ⟨hwf, htemps, hD1, hD2, ht1, ht2⟩ hQ0 identity_lt
      fun E' S' hA' hR' hF' hQ' hn' he' => hK E' S' hA' hR' hF' hQ' ?_ (he'.trans ?_)
  · rw [hn', hS]
  · rw [hS]
    dsimp only
    rw [MemoryState.eraseFrom_storeAt_of_le (hL.temp _ hacc).2.1,
      MemoryState.eraseFrom_storeAt_of_le hN2, MemoryState.eraseFrom_storeAt_of_le hN1]

/-- A zero point-sized block: a point that fits, its last 8 bytes zero. -/
theorem tempOK_of_zero {m : MemoryState} {t : Pointer} (hf : Fits m t 1344) (ho : t.offset = 0)
    (h : m.readAt t 1344 = 0) : m.PtFit t ∧ m.readRest t = 0#64 := by
  refine ⟨MemoryState.PtFit.of_fits hf ho, ?_⟩
  have :=
    MemoryState.readAt_add_of_readAt (off := 160#64) (w := 64) hf
      (by simp [BitVec.uaddOverflow, ho]) (by simp) h
  simpa [MemoryState.readRest] using this

/-- The base point's table, entries `0 … 8`, below `2^53`. -/
theorem baseTbl_lt : ∀ k < 9, (baseTbl k).Lt (2 ^ 53) := fun k hk => by
  simp only [baseTbl, show k < 16 by omega, dite_true]
  exact ZPt.Lt.mono53 (Edwards25519.basePointPc.pts_lt ⟨k, by omega⟩)

/-- `precompute`'s table, entries `0 … 8`, below `2^53`. -/
theorem pcTbl_lt {P : ZPt} (h : P.Lt (2 ^ 53)) : ∀ k < 9, (pcTbl P k).Lt (2 ^ 53) := by
  intro k hk
  have ha := fun A B => ZPt.Lt.mono53 (Edwards25519.add.spec_lt A B)
  have hd := fun A => ZPt.Lt.mono53 (Edwards25519.dbl.spec_lt A)
  rcases k with _ | _ | _ | _ | _ | _ | _ | _ | _ | k
  · exact identity_lt
  · exact h
  · exact hd _
  · exact ha _ _
  · exact hd _
  · exact ha _ _
  · exact hd _
  · exact ha _ _
  · exact hd _
  · omega

/-- The base point's table global's block (`step_addressof`'s facts): `TableAt`. -/
theorem tableAt_base {m : MemoryState} {p : Pointer} {hw : Edwards25519_basePointPc.t.width = 21504}
    (hf : Fits m p 21504) (ho : p.offset = 0)
    (hr : m.readAt p 21504 = Ty.flatBits Edwards25519_basePointPc.lit (hw := hw)) :
    TableAt m p baseTbl := fun k hk => by
  obtain ⟨h1, h2, -⟩ := MemoryState.readPt_basePointPc (i := ⟨k, by omega⟩) hf ho hr
  refine ⟨h1, h2.trans ?_⟩
  simp [baseTbl, show k < 16 by omega]

/-- `precompute`'s table at `c`: `TableAt`. -/
theorem tableAt_pc {m : MemoryState} {c : Pointer} (hf : Fits m c 12096)
    (ho : c.offset.toNat + 1512 ≤ 2 ^ 64) (P : ZPt) (r : BitVec 64) :
    TableAt (m.storeAt c (Edwards25519.precompute.bits P r)) c (pcTbl P) := fun k hk => by
  obtain ⟨h1, h2, -⟩ := MemoryState.readPt_precompute P r ⟨k, hk⟩ hf ho
  exact ⟨h1, h2.trans (by simp [pcTbl, hk])⟩

/-- `precompute`'s table read at `c`: `TableAt`. -/
theorem tableAt_pc' {m : MemoryState} {c : Pointer} (hf : Fits m c 12096)
    (ho : c.offset.toNat + 1512 ≤ 2 ^ 64)
    (hr : m.readAt c 12096 = Edwards25519.precompute.bits P r) : TableAt m c (pcTbl P) := by
  have h := tableAt_pc hf ho P r
  rwa [← hr, MemoryState.storeAt_readAt_self hf] at h

/-- A range below the frame fits alike in memories alike outside the frame. -/
theorem Fits.of_eraseFrom {m m' : MemoryState} {p : Pointer} (he : m'.eraseFrom N = m.eraseFrom N)
    (hp : p.id.id < N) (h : Fits m p w) : Fits m' p w := by
  obtain ⟨blk, hb, hs⟩ := h
  exact ⟨blk, (getElem?_of_eraseFrom he hp).trans hb, hs⟩

/-- `^bb16`: error code `0` at `out + 168`, the accumulator `Q` copied to `out`; on to `^bb1`. -/
theorem exit_block (P : Ptrs) (x1 x2 : BitVec 256) (T : Nat → ZPt) (out s1 p2 s2 : Pointer)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (Q : ZPt) (S : GlobalState)
    (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (hArgs : Args E out s1 p2 s2) (hR : Regs P E)
    (hF : Facts P x1 x2 T S) (hQ : S.mem.readPt P.acc = Q) (hFo : Fits S.mem out 1408)
    (hoo : out.offset.toNat + 176 ≤ 2 ^ 64) (hne : out.id ≠ P.acc.id)
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        S' = ⟨S.alloc, (S.mem.storeAt (out.add 168#64) 0#16).storeAt out (Q.bits 0#64)⟩ →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb1 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb16 S >>= g) = K := by
  have hFo168 : Fits S.mem (out.add 168#64) 16 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by decide) hFo
  have hFo1344 := hFo.mono (show 1344 ≤ 1408 by omega)
  have hFa := (hF.temps P.acc (by simp [Ptrs.temps])).1
  have hFa1344 := hFa.2
  have hbits : S.mem.readAt P.acc 1344 = Q.bits 0#64 := by
    rw [MemoryState.readAt_eq_ptBits hFa.2 hFa.1, hQ, (hF.temps P.acc (by simp [Ptrs.temps])).2]
  have hd : (Range.of out 1344).Disjoint (Range.of P.acc 1344) := .inl hne
  have hwf := hF.wf
  clear hF hQ
  dsimp only [Regs] at hR
  unfold Args at hArgs
  block_init
  step_pure
  step_store
  step_memcpy
  finish_block
  exact hK E S (by rw [hS])

/-- `^bb4`: `error.WeakPublicKey`'s result copied to `out`; on to `^bb1`. -/
theorem weak_block (out s1 p2 s2 wk : Pointer) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (S : GlobalState) (E : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫)
    (hArgs : Args E out s1 p2 s2) (hR : E ⊨ [%3 := wk, %4 := 176#64]) (hFo : Fits S.mem out 1408)
    (hFw : Fits S.mem wk 1408) (hne : out.id ≠ wk.id)
    (hw :
      S.mem.readAt wk 1408 =
        Ty.flatBits Edwards25519_mulDoubleBasePublic_weak.lit (w := 1408) (hw := rfl))
    (hK :
      ∀ (E' : ⟪Edwards25519_mulDoubleBasePublic.Γ⟫) (S' : GlobalState),
        S' = ⟨S.alloc, S.mem.storeAt out weakBits⟩ →
          (Edwards25519_mulDoubleBasePublic.runFrom E' ^bb1 S' >>= g) = K) :
    (Edwards25519_mulDoubleBasePublic.runFrom E ^bb4 S >>= g) = K := by
  rw [weak_bits] at hw
  have hd : (Range.of out 1408).Disjoint (Range.of wk 1408) := .inl hne
  unfold Args at hArgs
  block_init
  step_memcpy
  finish_block
  exact hK E S (by rw [hS])

end Edwards25519_mulDoubleBasePublic

open Edwards25519_mulDoubleBasePublic in
/-- `Edwards25519.mulDoubleBasePublic` stores at `out` `spec` of the scalars at `s1`, `s2` (below
`2^255`) and the point at `p2` (limbs below `2^53`, `is_base` the lowest bit of its last 8 bytes):
`s1 B + s2 P2` with error code `0`, or `error.WeakPublicKey`'s result. -/
public theorem Edwards25519_mulDoubleBasePublic.call_eq (out s1 p2 s2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : Fits s.mem out 1408) (hoo : out.offset.toNat + 176 ≤ 2 ^ 64)
    (hs1 : Fits s.mem s1 256) (hs1o : ¬s1.offset.uaddOverflow 32#64)
    (hm1 : (s.mem.readAt s1 256).msb = false) (hp2 : s.mem.PtFit p2)
    (hP2 : (s.mem.readPt p2).Lt (2 ^ 53)) (hs2 : Fits s.mem s2 256)
    (hs2o : ¬s2.offset.uaddOverflow 32#64) (hm2 : (s.mem.readAt s2 256).msb = false) :
    Edwards25519_mulDoubleBasePublic.call
        (Edwards25519_mulDoubleBasePublic.args (.value out) (.value s1) (.value p2) (.value s2)) s =
      .value
        (.nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (s.mem.readAt s1 256) ((s.mem.readRest p2).extractLsb' 0 1)
                    (s.mem.readPt p2) (s.mem.readAt s2 256)⟩,
            mem :=
              store s.mem out
                (spec (s.mem.readAt s1 256) ((s.mem.readRest p2).extractLsb' 0 1) (s.mem.readPt p2)
                  (s.mem.readAt s2 256)) }) := by
  generalize hRes :
    spec (s.mem.readAt s1 256) ((s.mem.readRest p2).extractLsb' 0 1) (s.mem.readPt p2)
      (s.mem.readAt s2 256) =
    Res
  generalize hk :
    blocks (s.mem.readAt s1 256) ((s.mem.readRest p2).extractLsb' 0 1) (s.mem.readPt p2)
      (s.mem.readAt s2 256) =
    k
  func_init
  obtain ⟨x1, hx1⟩ : ∃ x, S.mem.readAt s1 256 = x := ⟨_, rfl⟩
  obtain ⟨x2, hx2⟩ : ∃ x, S.mem.readAt s2 256 = x := ⟨_, rfl⟩
  obtain ⟨P2, hP2d⟩ : ∃ P, S.mem.readPt p2 = P := ⟨_, rfl⟩
  obtain ⟨r2, hr2⟩ : ∃ r, S.mem.readRest p2 = r := ⟨_, rfl⟩
  rw [hx1, hx2, hP2d, hr2] at hRes hk
  rw [hx1] at hm1
  rw [hx2] at hm2
  rw [hP2d] at hP2
  have hpx : S.mem.readLimbs p2 = P2.x := by
    rw [← hP2d]; rfl
  have hpy : S.mem.readLimbs (p2.add 40#64) = P2.y := by
    rw [← hP2d]; rfl
  have hpz : S.mem.readLimbs (p2.add 80#64) = P2.z := by
    rw [← hP2d]; rfl
  have hpt : S.mem.readLimbs (p2.add 120#64) = P2.t := by
    rw [← hP2d]; rfl
  have hpr : S.mem.readAt (p2.add 160#64) 64 = r2 := hr2
  have hb := hp2.isBase
  rw [hr2] at hb
  obtain ⟨hbf, hbr⟩ := hb
  have hout₀ : Fits S₀.mem out 1408 := hS ▸ hout
  clear hP2d hr2
  block_init
  step_pure
  step_addressof Edwards25519_basePointPc.value_eq with bp
  step_pure
  step_addressof Edwards25519_mulDoubleBasePublic_weak.value_eq with wk
  step_pure
  step_addressof Edwards25519_identityElement.value_eq with idp
  iterate 5 step_pure
  step_alloca with t11
  have hz11 : S.mem.readAt t11 1344 = 0 := by
    rw [hS, ht11]; exact readAt_alloca_allocaPtr
  step_alloca with t12
  have hz12 : S.mem.readAt t12 1344 = 0 := by
    rw [hS, ht12]; exact readAt_alloca_allocaPtr
  step_alloca with t13
  have hz13 : S.mem.readAt t13 1344 = 0 := by
    rw [hS, ht13]; exact readAt_alloca_allocaPtr
  step_alloca with t14
  have hz14 : S.mem.readAt t14 1344 = 0 := by
    rw [hS, ht14]; exact readAt_alloca_allocaPtr
  step_alloca with t15
  have hz15 : S.mem.readAt t15 1344 = 0 := by
    rw [hS, ht15]; exact readAt_alloca_allocaPtr
  step_alloca with t16
  have hz16 : S.mem.readAt t16 1344 = 0 := by
    rw [hS, ht16]; exact readAt_alloca_allocaPtr
  step_alloca with t17
  have hz17 : S.mem.readAt t17 1344 = 0 := by
    rw [hS, ht17]; exact readAt_alloca_allocaPtr
  step_alloca with acc
  have hzacc : S.mem.readAt acc 1344 = 0 := by
    rw [hS, hacc]; exact readAt_alloca_allocaPtr
  step_alloca with e2
  step_alloca with e1
  step_alloca with pc
  step_pure
  step_load with b hb23
  fix_load b hb23 hbr
  clear hbf
  finish_block
  case isTrue =>
    rw [hbr] at hRes hk
    simp only [spec, blocks, ite_true] at hRes hk
    have htb := tableAt_base hbp_fits hbp_off hread_bp
    obtain ⟨hidf, hidr, hidrr⟩ := MemoryState.readPt_identity hidp_fits hidp_off hread_idp
    have hidv : S.mem.readAt idp 1344 = Edwards25519.identity.bits 0#64 := by
      rw [MemoryState.readAt_eq_ptBits hidp_fits hidf.1, hidr, hidrr]
    have hL :
      Layout ⟨t11, t12, t13, t14, t15, t16, t17, acc, e2, e1, bp, bp⟩ S₀.alloc.nextFreeBlock := by
      subst ht11 ht12 ht13 ht14 ht15 ht16 ht17 hacc he2 he1 hbp
      refine ⟨?_, ?_, by simp, by simp⟩
      · intro u hu
        simp only [Ptrs.temps, List.mem_cons, List.not_mem_nil, or_false] at hu
        rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
          exact
            ⟨rfl, by simp [GlobalState.slot_id_id], GlobalState.slot_id_ne (by decide),
              GlobalState.slot_id_ne (by decide), GlobalState.slot_id_ne (by decide),
              GlobalState.slot_id_ne (by decide)⟩
      · intro u hu
        simp only [List.mem_cons, List.not_mem_nil, or_false] at hu
        rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
          exact GlobalState.slot_id_ne (by decide)
    have htemps :
      TempsOK S.mem (Ptrs.temps ⟨t11, t12, t13, t14, t15, t16, t17, acc, e2, e1, bp, bp⟩) := by
      intro u hu
      simp only [Ptrs.temps, List.mem_cons, List.not_mem_nil, or_false] at hu
      rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
      · exact tempOK_of_zero ht11_fits ht11_off hz11
      · exact tempOK_of_zero ht12_fits ht12_off hz12
      · exact tempOK_of_zero ht13_fits ht13_off hz13
      · exact tempOK_of_zero ht14_fits ht14_off hz14
      · exact tempOK_of_zero ht15_fits ht15_off hz15
      · exact tempOK_of_zero ht16_fits ht16_off hz16
      · exact tempOK_of_zero ht17_fits ht17_off hz17
      · exact tempOK_of_zero hacc_fits hacc_off hzacc
    have hEr : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
      rw [hS]; erase_frame
    have hAl : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 14 := by
      rw [hS]; simp [GlobalState.alloca]
    refine
      from_bb2 _ _ hL x1 x2 baseTbl baseTbl_lt baseTbl_lt hm1 hm2 out s1 p2 s2 idp _ _ S E hArgs
        (by env_reads) (by env_reads) hwf htemps he1_fits he1_off he2_fits he2_off hs1 hs1o hx1 hs2
        hs2o hx2 htb htb hidf hidv
        (by
          rw [he1, he2]; exact GlobalState.slot_id_ne (by decide))
        hs2_ne_e1.symm
        (by
          rw [he1, hbp]; exact GlobalState.slot_id_ne (by decide))
        (by
          rw [he1, hbp]; exact GlobalState.slot_id_ne (by decide))
        (by
          rw [he1, hidp]; exact GlobalState.slot_id_ne (by decide))
        (by
          rw [he2, hbp]; exact GlobalState.slot_id_ne (by decide))
        (by
          rw [he2, hbp]; exact GlobalState.slot_id_ne (by decide))
        (by
          rw [he2, hidp]; exact GlobalState.slot_id_ne (by decide))
        (by
          rw [hacc, hidp]; exact GlobalState.slot_id_ne (by decide))
        (by slot_bound) (by slot_bound) fun E' S' hA' hR' hF' hQ' hn' he' => ?_
    have hlt : out.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt (Fits.mem hout₀)
    refine
      exit_block _ x1 x2 _ out s1 p2 s2 _ _ _ S' E' hA' hR' hF' hQ' (Fits.of_eraseFrom he' hlt hout)
        hoo hout_ne_acc fun E'' S'' hS'' => ?_
    block_init
    finish_block
    rw [hS'', ← hRes, ← hk]
    dsimp only
    rw [MemoryState.eraseFrom_storeAt, MemoryState.eraseFrom_storeAt, he', hEr,
      show S'.alloc = ⟨S'.alloc.nextFreeBlock⟩ from rfl, hn', hAl]
    simp only [store, MemoryState.storePt]
    rw [show
        S₀.alloc.nextFreeBlock + 14 + 6 + ladderBlocks x1 x2 63 =
          S₀.alloc.nextFreeBlock + (20 + ladderBlocks x1 x2 63)
        by omega]
  case isFalse =>
    simp only [spec, blocks, hbr, ite_false] at hRes hk
    have hP2S : S.mem.readPt p2 = P2 := by simp only [MemoryState.readPt, hpx, hpy, hpz, hpt]
    have hr2S : S.mem.readRest p2 = r2 := hpr
    have hPf : (S.mem.readPt p2).Lt (2 ^ 53) := hP2S ▸ hP2
    block_init
    step_call using Edwards25519_precompute.call_eq consuming hPf hP2S hr2S
    have htb :=
      tableAt_pc' hpc_fits
        (by
          rw [hpc_off]; decide)
        hread_pc
    obtain ⟨h4f, h4r⟩ := htb 4 (by omega)
    have h4f' : S.mem.PtFit (pc.add 672#64) := h4f
    have h4r' : S.mem.readPt (pc.add 672#64) = pcTbl P2 4 := h4r
    have h4x : Fe.Lt (S.mem.readPt (pc.add 672#64)).x (2 ^ 63) := by
      rw [h4r']; exact (pcTbl_lt hP2 4 (by omega)).1.mono (by decide)
    clear h4f h4r
    step_pure
    step_call using Edwards25519_rejectIdentity.call_eq with rv hrv
    fix_load rv hrv h4r'
    step_pure
    finish_block
    case isTrue =>
      simp only [hbr, ite_true] at hRes hk
      have htb1 := tableAt_base hbp_fits hbp_off hread_bp
      have htb :=
        tableAt_pc' hpc_fits
          (by
            rw [hpc_off]; decide)
          hread_pc
      obtain ⟨hidf, hidr, hidrr⟩ := MemoryState.readPt_identity hidp_fits hidp_off hread_idp
      have hidv : S.mem.readAt idp 1344 = Edwards25519.identity.bits 0#64 := by
        rw [MemoryState.readAt_eq_ptBits hidp_fits hidf.1, hidr, hidrr]
      have hL :
        Layout ⟨t11, t12, t13, t14, t15, t16, t17, acc, e2, e1, bp, pc⟩ S₀.alloc.nextFreeBlock := by
        subst ht11 ht12 ht13 ht14 ht15 ht16 ht17 hacc he2 he1 hbp hpc
        refine ⟨?_, ?_, by simp, by simp⟩
        · intro u hu
          simp only [Ptrs.temps, List.mem_cons, List.not_mem_nil, or_false] at hu
          rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
            exact
              ⟨rfl, by simp [GlobalState.slot_id_id], GlobalState.slot_id_ne (by decide),
                GlobalState.slot_id_ne (by decide), GlobalState.slot_id_ne (by decide),
                GlobalState.slot_id_ne (by decide)⟩
        · intro u hu
          simp only [List.mem_cons, List.not_mem_nil, or_false] at hu
          rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
            exact GlobalState.slot_id_ne (by decide)
      have htemps :
        TempsOK S.mem (Ptrs.temps ⟨t11, t12, t13, t14, t15, t16, t17, acc, e2, e1, bp, pc⟩) := by
        intro u hu
        simp only [Ptrs.temps, List.mem_cons, List.not_mem_nil, or_false] at hu
        rcases hu with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
        · exact tempOK_of_zero ht11_fits ht11_off hz11
        · exact tempOK_of_zero ht12_fits ht12_off hz12
        · exact tempOK_of_zero ht13_fits ht13_off hz13
        · exact tempOK_of_zero ht14_fits ht14_off hz14
        · exact tempOK_of_zero ht15_fits ht15_off hz15
        · exact tempOK_of_zero ht16_fits ht16_off hz16
        · exact tempOK_of_zero ht17_fits ht17_off hz17
        · exact tempOK_of_zero hacc_fits hacc_off hzacc
      have hEr : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
        rw [hS]; erase_frame
      have hAl : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 245 := by
        rw [hS]; simp [GlobalState.alloca]
      refine
        from_bb2 _ _ hL x1 x2 (pcTbl P2) baseTbl_lt (pcTbl_lt hP2) hm1 hm2 out s1 p2 s2 idp _ _ S E
          hArgs (by env_reads) (by env_reads) hwf htemps he1_fits he1_off he2_fits he2_off hs1 hs1o
          hx1 hs2 hs2o hx2 htb1 htb hidf hidv
          (by
            rw [he1, he2]; exact GlobalState.slot_id_ne (by decide))
          hs2_ne_e1.symm
          (by
            rw [he1, hbp]; exact GlobalState.slot_id_ne (by decide))
          (by
            rw [he1, hpc]; exact GlobalState.slot_id_ne (by decide))
          (by
            rw [he1, hidp]; exact GlobalState.slot_id_ne (by decide))
          (by
            rw [he2, hbp]; exact GlobalState.slot_id_ne (by decide))
          (by
            rw [he2, hpc]; exact GlobalState.slot_id_ne (by decide))
          (by
            rw [he2, hidp]; exact GlobalState.slot_id_ne (by decide))
          (by
            rw [hacc, hidp]; exact GlobalState.slot_id_ne (by decide))
          (by slot_bound) (by slot_bound) fun E' S' hA' hR' hF' hQ' hn' he' => ?_
      have hlt : out.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt (Fits.mem hout₀)
      refine
        exit_block _ x1 x2 _ out s1 p2 s2 _ _ _ S' E' hA' hR' hF' hQ'
          (Fits.of_eraseFrom he' hlt hout) hoo hout_ne_acc fun E'' S'' hS'' => ?_
      block_init
      finish_block
      rw [hS'', ← hRes, ← hk]
      dsimp only
      rw [MemoryState.eraseFrom_storeAt, MemoryState.eraseFrom_storeAt, he', hEr,
        show S'.alloc = ⟨S'.alloc.nextFreeBlock⟩ from rfl, hn', hAl]
      simp only [store, MemoryState.storePt]
      rw [show
          S₀.alloc.nextFreeBlock + 245 + 6 + ladderBlocks x1 x2 63 =
            S₀.alloc.nextFreeBlock + (251 + ladderBlocks x1 x2 63)
          by omega]
    case isFalse =>
      simp only [hbr, ite_false] at hRes hk
      have hEr : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
        rw [hS]; erase_frame
      have hAl : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 245 := by
        rw [hS]; simp [GlobalState.alloca]
      refine
        weak_block out s1 p2 s2 wk _ _ S E hArgs (by env_reads) hout hwk_fits hout_ne_wk hread_wk
          fun E' S' hS' => ?_
      clear htb h4x h4f' h4r'
      block_init
      finish_block
      rw [hS', ← hRes, ← hk]
      dsimp only
      rw [MemoryState.eraseFrom_storeAt, hEr, show S.alloc = ⟨S.alloc.nextFreeBlock⟩ from rfl, hAl]
      rfl

end Proof

end LeanMLIR.RIR.Zig
