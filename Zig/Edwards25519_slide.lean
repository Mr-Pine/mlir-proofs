module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Firedancer.Common.Memory
public import Zig.Common.Memory
public import Zig.Common.PointCopy
import Std.Tactic.BVDecide
import Firedancer.Common.LimbBits
public import Zig.Mlir.Edwards25519_slide

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- Nibble `k` of `x`, as an `i8`. -/
def Edwards25519.slide.nib (x : BitVec 256) (k : Nat) : BitVec 8 :=
  (x.extractLsb' (4 * k) 4).setWidth 8

/-- The carry into digit `k`. -/
def Edwards25519.slide.carry (x : BitVec 256) : Nat → BitVec 8
  | 0 => 0#8
  | k + 1 =>
    let a := Edwards25519.slide.nib x k + Edwards25519.slide.carry x k
    (a + 8#8).sshiftRight 4

/-- Digit `k`: the nibble plus the carry in, less the carry out's `16`; the last keeps it. -/
def Edwards25519.slide.digit (x : BitVec 256) (k : Nat) : BitVec 8 :=
  let a := Edwards25519.slide.nib x k + Edwards25519.slide.carry x k
  if k < 63 then a - ((a + 8#8) &&& 240#8) else a

/-- The 64 signed radix-16 digits `slide` stores, lowest first. -/
def Edwards25519.slide.spec (x : BitVec 256) : Vector (BitVec 8) 64 :=
  Vector.ofFn fun k => Edwards25519.slide.digit x k

end

section Proof

/-! ### The digits in memory -/

/-- The digits `v` stored at `e` over `S`. -/
abbrev withE (e : Pointer) (v : Vector (BitVec 8) 64) (S : GlobalState) : GlobalState :=
  { S with mem := S.mem.storeAt e (BitVec.packLanes v) }

/-- The digits `v` stored at `e` over `S`, defined where `d` is set. -/
abbrev withED (e : Pointer) (v : Vector (BitVec 8) 64) (d : BitVec 512) (S : GlobalState) :
    GlobalState :=
  { S with mem := S.mem.overlay e (BitVec.packLanes v) d }

/-- The mask of lanes `0 … k - 1`. -/
def laneMask (k : Nat) : BitVec 512 :=
  BitVec.allOnes 512 >>> (512 - 8 * k)

/-- Lane `j`'s offset, which does not wrap from a block's start. -/
theorem lane_ov {p : Pointer} (ho : p.offset = 0) (hj : j < 64) :
    (BitVec.ofNat 64 j).toNat = j ∧ ¬p.offset.uaddOverflow (BitVec.ofNat 64 j) := by
  have hj' : (BitVec.ofNat 64 j).toNat = j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  refine ⟨hj', ?_⟩
  simp only [BitVec.uaddOverflow, ho, hj', decide_eq_true_eq,
    show (0 : BitVec 64).toNat = 0 from rfl]
  omega

/-- Room for lane `j` where there is for the digits. -/
theorem room_lane {m : MemoryState} {p : Pointer} (hf : Room m p 512) (ho : p.offset = 0)
    (hj : j < 64) : Room m (p.add (BitVec.ofNat 64 j)) 8 :=
  Room.add_of_le (lane_ov ho hj).2
    (by
      rw [(lane_ov ho hj).1]; omega)
    hf

/-- Lane `j` of stored digits is known. -/
theorem fits_lane {m : MemoryState} {p : Pointer} {v : Vector (BitVec 8) 64} (hf : Room m p 512)
    (ho : p.offset = 0) (hj : j < 64) :
    Fits (m.storeAt p (BitVec.packLanes v)) (p.add (BitVec.ofNat 64 j)) 8 :=
  Fits.storeAt_add_self hf (lane_ov ho hj).2
    (by
      rw [(lane_ov ho hj).1]; omega)

/-- Lane `j` of stored digits. -/
theorem readAt_lane {m : MemoryState} {p : Pointer} {v : Vector (BitVec 8) 64}
    (hf : Room m p 512) (ho : p.offset = 0) (hj : j < 64) :
    (m.storeAt p (BitVec.packLanes v)).readAt (p.add (BitVec.ofNat 64 j)) 8 = v[j] := by
  rw [MemoryState.readAt_storeAt_add hf (lane_ov ho hj).2
      (by
        rw [(lane_ov ho hj).1]; omega),
    (lane_ov ho hj).1, BitVec.extractLsb'_packLanes _ _ hj]

/-- Splicing lane `j` into packed lanes sets it. -/
theorem spliceBits_packLanes {u : Vector (BitVec 8) 64} (hj : j < 64) (y : BitVec 8) :
    Memory.spliceBits (BitVec.packLanes u) (j * 8) y = BitVec.packLanes (u.set j y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  rw [Memory.getLsbD_spliceBits, BitVec.getLsbD_packLanes _ hm, BitVec.getLsbD_packLanes _ hm,
    Vector.getElem_set]
  by_cases h : m / 8 = j
  · subst h
    have hc : m / 8 * 8 ≤ m ∧ m < m / 8 * 8 + 8 ∧ m < 8 * 64 := by omega
    simp only [hc, and_self, ite_true]
    congr 1
    omega
  · have hc : ¬(j * 8 ≤ m ∧ m < j * 8 + 8 ∧ m < 8 * 64) := by omega
    simp only [hc, ite_false, Ne.symm h]

/-- Lane `k`, defined: the mask of the lanes below `k + 1`. -/
theorem spliceBits_laneMask (hk : k < 64) :
    Memory.spliceBits (laneMask k) (k * 8) (BitVec.allOnes 8) = laneMask (k + 1) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  simp only [Memory.getLsbD_spliceBits, laneMask, BitVec.getLsbD_ushiftRight,
    BitVec.getLsbD_allOnes]
  by_cases h : k * 8 ≤ m ∧ m < k * 8 + 8 ∧ m < 512 <;> simp only [h, ite_false] <;> simp <;> omega

theorem laneMask_zero : laneMask 0 = 0#512 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [laneMask, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_allOnes, BitVec.getLsbD_zero]
  simp only [decide_eq_false_iff_not]; omega

theorem laneMask_64 : laneMask 64 = BitVec.allOnes 512 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [laneMask, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_allOnes]
  simp only [decide_eq_decide]; omega

/-- A splice inside a splice at a block's start: one splice of the spliced bits. -/
theorem spliceBits_spliceBits_inside {n : Nat} (bs : BitVec n) (x : BitVec 512) (y : BitVec 8)
    (o : Nat) (ho : o + 8 ≤ 512) :
    Memory.spliceBits (Memory.spliceBits bs 0 x) o y =
      Memory.spliceBits bs 0 (Memory.spliceBits x o y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store into lane `j` of digits stored with definedness `d`: lane `j` set and defined. -/
theorem overlay_lane {m : MemoryState} {p : Pointer} {v : Vector (BitVec 8) 64} {d : BitVec 512}
    (ho : p.offset = 0) (hj : j < 64) (y : BitVec 8) :
    (m.overlay p (BitVec.packLanes v) d).storeAt (p.add (BitVec.ofNat 64 j)) y =
      m.overlay p (BitVec.packLanes (v.set j y))
        (Memory.spliceBits d (j * 8) (BitVec.allOnes 8)) := by
  have h0 : p.offsetInBits = 0 := by simp [Pointer.offsetInBits, ho]
  have hj8 : (p.add (BitVec.ofNat 64 j)).offsetInBits = j * 8 := by
    rw [Pointer.offsetInBits_add (lane_ov ho hj).2, h0, (lane_ov ho hj).1]; omega
  simp only [MemoryState.storeAt, MemoryState.overlay, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self, implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, hj8, h0, ← spliceBits_packLanes hj,
    spliceBits_spliceBits_inside _ _ _ _ (show j * 8 + 8 ≤ 512 by omega)]

/-- A store into lane `j` of stored digits: lane `j` set. -/
theorem storeAt_lane {m : MemoryState} {p : Pointer} {v : Vector (BitVec 8) 64} (ho : p.offset = 0)
    (hj : j < 64) (y : BitVec 8) :
    (m.storeAt p (BitVec.packLanes v)).storeAt (p.add (BitVec.ofNat 64 j)) y =
      m.storeAt p (BitVec.packLanes (v.set j y)) := by
  have hm :
    Memory.spliceBits (BitVec.allOnes 512) (j * 8) (BitVec.allOnes 8) = BitVec.allOnes 512 := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    split
    · simp; omega
    · simp
  rw [show m.storeAt p (BitVec.packLanes v) = m.overlay p (BitVec.packLanes v) (BitVec.allOnes 512)
      from rfl,
    overlay_lane ho hj y, hm]
  rfl

/-- No digits packed: zero. -/
theorem packLanes_zero : BitVec.packLanes (Vector.replicate 64 (0#8)) = 0#512 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [BitVec.getLsbD_packLanes _ hi]
  simp

/-- A fresh slot `e`: no digits, none defined. -/
theorem withED_fresh {S : GlobalState} {e : Pointer} (h : InBounds S.mem e 512)
    (hz : S.mem.readAt e 512 = 0) (hzd : S.mem.definedAt e 512 = 0) :
    withED e (Vector.replicate 64 0#8) (laneMask 0) S = S := by
  have h1 : BitVec.packLanes (Vector.replicate 64 (0#8)) = S.mem.readAt e (8 * 64) :=
    packLanes_zero.trans hz.symm
  have h2 : laneMask 0 = S.mem.definedAt e (8 * 64) := laneMask_zero.trans hzd.symm
  simp only [withED, h1, h2, MemoryState.overlay_readAt_definedAt h]

/-- The top byte below `128` takes the unreduced branch. -/
theorem slt_top {x : BitVec 256} (h : x.msb = false) :
    (255#8).slt (x.extractLsb' 248 8) = true := by bv_decide

namespace Edwards25519_slide

/-- The unpack loop from `i`, `n` iterations: byte `i`'s nibbles into lanes `2i`, `2i + 1`. -/
def unpackFrom (x : BitVec 256) : Nat → Nat → Vector (BitVec 8) 64 → Vector (BitVec 8) 64
  | _, 0, v => v
  | i, n + 1, v =>
    unpackFrom x (i + 1) n
      (if h : 2 * i + 1 < 64 then
        (v.set (2 * i) (x.extractLsb' (i * 8) 8 &&& 15#8)).set (2 * i + 1)
          (x.extractLsb' (i * 8) 8 >>> 4) h
      else v)

/-- One unpack iteration. -/
theorem unpackFrom_succ {v : Vector (BitVec 8) 64} (hi : 2 * i + 1 < 64) :
    unpackFrom x i (n + 1) v =
      unpackFrom x (i + 1) n
        ((v.set (2 * i) (x.extractLsb' (i * 8) 8 &&& 15#8)).set (2 * i + 1)
          (x.extractLsb' (i * 8) 8 >>> 4) hi) := by
  simp [unpackFrom, hi]

/-- The registers at `^bb5`, the carry loop, at `k` with carry `c`. -/
abbrev Carry (E : ⟪Γ⟫) (e : Pointer) (k : Nat) (c : BitVec 8) : Prop :=
  E ⊨ [%624 := 1#64, %626 := 4#8, %627 := 63#64, %628 := 8#8, %629 := 240#8, %630 := 64#64, %632 :=
    e, %649 := BitVec.ofNat 64 k, %650 := c]

/-- The unpack loop's exit: `^bb5` from `v` unpacked. Not reducible: steps do not see into it. -/
def UnpackK (out sp e : Pointer) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (S : GlobalState) (v : Vector (BitVec 8) 64) : Prop :=
  ∀ E' : ⟪Γ⟫,
    E'.args = (args (.value out) (.value sp)).get →
      Carry E' e 0 0#8 → (Edwards25519_slide.runFrom E' ^bb5 (withE e v S) >>= g) = K

/-- The unpack loop's index arithmetic at `i`: `2i`, `2i + 1`, `i + 1`, none wrapping. -/
theorem idx_facts :
    ∀ i < 32,
      BitVec.ofNat 64 i <<< 1 = BitVec.ofNat 64 (2 * i) ∧
        BitVec.ofNat 64 (2 * i) >>> 1 = BitVec.ofNat 64 i ∧
        (BitVec.ofNat 64 (2 * i)).sshiftRight 1 = BitVec.ofNat 64 i ∧
        BitVec.ofNat 64 (2 * i) &&& 1#64 = 0#64 ∧
        BitVec.ofNat 64 (2 * i) ||| 1#64 = BitVec.ofNat 64 (2 * i + 1) ∧
        (BitVec.ofNat 64 i).uaddOverflow 1#64 = false ∧
        (BitVec.ofNat 64 i).saddOverflow 1#64 = false := by
  decide +kernel

/-- The loop's registers at `^bb3`, the unpack loop, at `i`. -/
abbrev Unpack (E : ⟪Γ⟫) (e sp : Pointer) (i : Nat) : Prop :=
  E ⊨ [%621 := 0#64, %622 := 32#64, %623 := 0#8, %624 := 1#64, %625 := 15#8, %626 := 4#8, %627 :=
    63#64, %628 := 8#8, %629 := 240#8, %630 := 64#64, %632 := e, %637 := sp, %638 :=
    BitVec.ofNat 64 i]

/-- `^bb3`, the unpack loop, at `i` with `n` iterations left: bytes `i …` unpacked, then
`^bb5`. -/
theorem unpack_loop (out sp e : Pointer) (x : BitVec 256) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (S : GlobalState) (hsp : Fits S.mem sp 256)
    (hso : ¬sp.offset.uaddOverflow 32#64) (hx : S.mem.readAt sp 256 = x) (hef : Room S.mem e 512)
    (he : e.offset = 0) (hsep : sp.id ≠ e.id) :
    ∀ n i (v : Vector (BitVec 8) 64) (E : ⟪Γ⟫),
      E.args = (args (.value out) (.value sp)).get →
        Unpack E e sp i →
        i + n = 32 →
        UnpackK out sp e g K S (unpackFrom x i n v) →
        (Edwards25519_slide.runFrom E ^bb3 (withED e v (laneMask (2 * i)) S) >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro i v E hArgs hR hn hK
    obtain rfl : i = 32 := by omega
    simp only [UnpackK, unpackFrom] at hK
    rw [show 2 * 32 = 64 from rfl, laneMask_64]
    block_init
    step_pure
    finish_block
    step_loop using hK
  | succ n ih =>
    intro i v E hArgs hR hn hK
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)] at this
      simp at this; omega
    · have hi : i < 32 := by omega
      have hin : (BitVec.ofNat 64 i).toNat = i := by
        rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
      have hov : ¬sp.offset.uaddOverflow (BitVec.ofNat 64 i) :=
        BitVec.not_uaddOverflow_of_le hso
          (by
            rw [hin]; show i ≤ 32; omega)
      have hw : (BitVec.ofNat 64 i).toNat * 8 + 8 ≤ 256 := by
        rw [hin]; omega
      have hfb := Fits.add_of_le hov hw hsp
      have hb := MemoryState.readAt_add_of_readAt hsp.inBounds hov hw hx
      rw [hin] at hb
      block_init
      step_pure [Nat.mod_lt i (by decide : 0 < 18446744073709551616)]
      obtain ⟨h1, h2, h3, h4, h5, h6, h7⟩ := idx_facts i hi
      step_load consuming hb
      step_pure [h1, h2, h3]
      step_pure [Nat.mod_lt (2 * i) (by decide : 0 < 18446744073709551616)]
      step_pure
      have hf0 :=
        (room_lane hef he (j := 2 * i) (by omega)).overlay (q := e) (x := BitVec.packLanes v) (d :=
          laneMask (2 * i))
      have hf1 :=
        (room_lane hef he (j := 2 * i + 1) (by omega)).overlay (q := e) (x := BitVec.packLanes v)
          (d := laneMask (2 * i))
      step_store consuming hf0
      rw [overlay_lane he (by omega), spliceBits_laneMask (by omega)] at hS
      step_pure [h5, h4]
      step_pure [Nat.mod_lt (2 * i + 1) (by decide : 0 < 18446744073709551616)]
      step_pure
      step_store consuming hf1
      rw [overlay_lane he (by omega), spliceBits_laneMask (by omega),
        show 2 * i + 1 + 1 = 2 * (i + 1) by omega] at hS
      step_pure [h6, h7, ← BitVec.ofNat_add]
      finish_block
      rw [unpackFrom_succ (by omega)] at hK
      step_loop using ih (i + 1)

/-! ### The carry loop -/

open Edwards25519.slide in
/-- Digits `0 … k - 1` final, the rest still nibbles. -/
def stage (x : BitVec 256) (k : Nat) : Vector (BitVec 8) 64 :=
  Vector.ofFn fun j => if j.val < k then digit x j else nib x j

/-- One carry step from a nibble and a `0`/`1` carry: no `nsw` overflows, a `0`/`1` carry out. -/
theorem carry_step (a : BitVec 4) (b : Bool) :
    let n := a.setWidth 8
    let c := if b then 1#8 else 0#8
    n.saddOverflow c = false ∧
      (n + c).saddOverflow 8#8 = false ∧
      (n + c).ssubOverflow ((n + c + 8#8) &&& 240#8) = false ∧
      ((n + c + 8#8).sshiftRight 4 = 0#8 ∨ (n + c + 8#8).sshiftRight 4 = 1#8) := by
  revert a b; decide

/-- Carries are `0` or `1`. -/
public theorem carry_01 (x : BitVec 256) :
    ∀ k, Edwards25519.slide.carry x k = 0#8 ∨ Edwards25519.slide.carry x k = 1#8
  | 0 => .inl rfl
  | k + 1 => by
    rcases carry_01 x k with h | h
    · have := (carry_step (x.extractLsb' (4 * k) 4) false).2.2.2
      simp only [Bool.false_eq_true, ite_false] at this
      simp only [Edwards25519.slide.carry, Edwards25519.slide.nib, h]; exact this
    · have := (carry_step (x.extractLsb' (4 * k) 4) true).2.2.2
      simp only [ite_true] at this
      simp only [Edwards25519.slide.carry, Edwards25519.slide.nib, h]; exact this

/-- The step at `k`: no `nsw` overflows. -/
theorem carry_ovf (x : BitVec 256) (k : Nat) :
    let n := Edwards25519.slide.nib x k
    let c := Edwards25519.slide.carry x k
    n.saddOverflow c = false ∧
      (n + c).saddOverflow 8#8 = false ∧
      (n + c).ssubOverflow ((n + c + 8#8) &&& 240#8) = false := by
  rcases carry_01 x k with h | h
  · have := carry_step (x.extractLsb' (4 * k) 4) false
    simp only [Bool.false_eq_true, ite_false] at this
    simp only [Edwards25519.slide.nib, h]; exact ⟨this.1, this.2.1, this.2.2.1⟩
  · have := carry_step (x.extractLsb' (4 * k) 4) true
    simp only [ite_true] at this
    simp only [Edwards25519.slide.nib, h]; exact ⟨this.1, this.2.1, this.2.2.1⟩

/-- Digit `k < 63` set: the next stage. -/
theorem stage_succ (hk : k < 63) :
    (stage x k).set k
        (Edwards25519.slide.nib x k + Edwards25519.slide.carry x k -
          (Edwards25519.slide.nib x k + Edwards25519.slide.carry x k + 8#8 &&& 240#8))
        (by omega) =
      stage x (k + 1) := by
  apply Vector.ext
  intro j hj
  rw [Vector.getElem_set]
  simp only [stage, Vector.getElem_ofFn]
  by_cases h : k = j
  · subst h; simp [Edwards25519.slide.digit, hk]
  · simp only [h, ite_false]
    by_cases h' : j < k
    · simp [h', show j < k + 1 by omega]
    · simp [h', show ¬j < k + 1 by omega]

/-- The last digit set: the spec. -/
theorem stage_last :
    (stage x 63).set 63 (Edwards25519.slide.nib x 63 + Edwards25519.slide.carry x 63) (by omega) =
      Edwards25519.slide.spec x := by
  apply Vector.ext
  intro j hj
  rw [Vector.getElem_set]
  simp only [stage, Edwards25519.slide.spec, Vector.getElem_ofFn]
  by_cases h : 63 = j
  · subst h; simp [Edwards25519.slide.digit]
  · simp [h, show j < 63 by omega]

/-- `stage`'s lane `k`, before its step: the nibble. -/
theorem stage_get (hk : k < 64) : (stage x k)[k] = Edwards25519.slide.nib x k := by simp [stage]

/-- The carry loop's exit: `^bb7` with digits `0 … 62` final. Not reducible. -/
def CarryK (out sp e : Pointer) (x : BitVec 256) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (S : GlobalState) : Prop :=
  ∀ E' : ⟪Γ⟫,
    E'.args = (args (.value out) (.value sp)).get →
      Carry E' e 63 (Edwards25519.slide.carry x 63) →
      (Edwards25519_slide.runFrom E' ^bb7 (withE e (stage x 63) S) >>= g) = K

/-- `^bb5`, the carry loop, at `k` with `n` iterations left: digits `k … 62` made final. -/
theorem carry_loop (out sp e : Pointer) (x : BitVec 256) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (S : GlobalState) (hef : Room S.mem e 512) (he : e.offset = 0) :
    ∀ n k (E : ⟪Γ⟫),
      E.args = (args (.value out) (.value sp)).get →
        Carry E e k (Edwards25519.slide.carry x k) →
        k + n = 63 →
        CarryK out sp e x g K S →
        (Edwards25519_slide.runFrom E ^bb5 (withE e (stage x k) S) >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro k E hArgs hR hn hK
    obtain rfl : k = 63 := by omega
    unfold CarryK at hK
    block_init
    step_pure
    finish_block
    step_loop using hK
  | succ n ih =>
    intro k E hArgs hR hn hK
    have hk : k < 63 := by omega
    have hkn : (BitVec.ofNat 64 k).toNat = k := by
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
    have hf := fits_lane (v := stage x k) hef he (j := k) (by omega)
    have hl := readAt_lane (v := stage x k) hef he (j := k) (by omega)
    rw [stage_get (by omega)] at hl
    obtain ⟨o1, o2, o3⟩ := carry_ovf x k
    block_init
    step_pure
    finish_block
    · exfalso
      have := congrArg BitVec.toNat hbr
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)] at this
      simp at this; omega
    · block_init
      step_pure [Nat.mod_lt k (by decide : 0 < 18446744073709551616)]
      step_load
      rw [hl] at hv34
      subst hv34
      step_pure [o1]
      step_pure [o2]
      step_pure
      step_pure
      step_pure [o3]
      step_store
      rw [storeAt_lane he (by omega), stage_succ hk] at hS
      step_pure [show (BitVec.ofNat 64 k).uaddOverflow 1#64 = false by
            simp [BitVec.uaddOverflow, hkn]; omega,
        show (BitVec.ofNat 64 k).saddOverflow 1#64 = false
            by
            have h : (BitVec.ofNat 64 k).toInt = k := by
              rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
            simp [BitVec.saddOverflow, h]; omega,
        ← BitVec.ofNat_add]
      finish_block
      step_loop using ih (k + 1)

/-! ### Unpacking: the nibbles -/

/-- The unpack loop's lanes, read back. -/
theorem unpackFrom_get {x : BitVec 256} {v : Vector (BitVec 8) 64} (h : i + n ≤ 32) (hk : k < 64) :
    (unpackFrom x i n v)[k] =
      if 2 * i ≤ k ∧ k < 2 * (i + n) then
        (if k % 2 = 0 then x.extractLsb' (k / 2 * 8) 8 &&& 15#8
        else x.extractLsb' (k / 2 * 8) 8 >>> 4)
      else v[k] := by
  induction n generalizing i v with
  | zero =>
    simp only [unpackFrom]
    split <;>
      first
      | rfl
      | omega
  | succ n
    ih =>
    rw [unpackFrom_succ (by omega), ih (by omega), Vector.getElem_set, Vector.getElem_set]
    by_cases h1 : 2 * (i + 1) ≤ k ∧ k < 2 * (i + 1 + n)
    · simp only [h1, and_self, ite_true, show 2 * i ≤ k ∧ k < 2 * (i + (n + 1)) by omega]
    · simp only [h1, ite_false]
      by_cases h2 : 2 * i + 1 = k
      · subst h2
        simp only [show 2 * i ≤ 2 * i + 1 ∧ 2 * i + 1 < 2 * (i + (n + 1)) by omega,
          show ¬(2 * i + 1) % 2 = 0 by omega, show (2 * i + 1) / 2 = i by omega, ite_true,
          ite_false, and_self]
      · by_cases h3 : 2 * i = k
        · subst h3
          simp only [show 2 * i ≤ 2 * i ∧ 2 * i < 2 * (i + (n + 1)) by omega,
            show 2 * i % 2 = 0 by omega, show 2 * i / 2 = i by omega, ite_true, ite_false,
            show ¬2 * i + 1 = 2 * i by omega, and_self]
        · simp only [h2, h3, ite_false, show ¬(2 * i ≤ k ∧ k < 2 * (i + (n + 1))) by omega]

/-- A byte's low nibble. -/
theorem lo_nib (x : BitVec 256) (j : Nat) :
    x.extractLsb' (j * 8) 8 &&& 15#8 = Edwards25519.slide.nib x (2 * j) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  simp only [Edwards25519.slide.nib, BitVec.getLsbD_and, BitVec.getLsbD_extractLsb',
    BitVec.getLsbD_setWidth]
  by_cases h : m < 4
  · have : (15#8).getLsbD m = true := by
      revert h; revert m; decide
    simp [this, h, hm, show j * 8 + m = 4 * (2 * j) + m by omega]
  · have : (15#8).getLsbD m = false := by
      revert h hm; revert m; decide
    simp [this, h]

/-- A byte's high nibble. -/
theorem hi_nib (x : BitVec 256) (j : Nat) :
    x.extractLsb' (j * 8) 8 >>> 4 = Edwards25519.slide.nib x (2 * j + 1) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  simp only [Edwards25519.slide.nib, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_extractLsb',
    BitVec.getLsbD_setWidth]
  by_cases h : m < 4
  · simp [h, hm, show 4 + m < 8 by omega, show j * 8 + (4 + m) = 4 * (2 * j + 1) + m by omega]
  · simp [h, show ¬4 + m < 8 by omega]

/-- Unpacking all 32 bytes: the nibbles, `stage x 0`. -/
theorem unpackFrom_all (x : BitVec 256) (v : Vector (BitVec 8) 64) :
    unpackFrom x 0 32 v = stage x 0 := by
  apply Vector.ext
  intro k hk
  rw [unpackFrom_get (by omega) hk, ite_eq_left_of_eq_true _ _ (eq_true (by omega))]
  simp only [stage, Vector.getElem_ofFn, Nat.not_lt_zero, ite_false]
  split
  · rw [lo_nib, show 2 * (k / 2) = k by omega]
  · rw [hi_nib, show 2 * (k / 2) + 1 = k by omega]

end Edwards25519_slide

/-- `Edwards25519.slide` stores `spec` of the 32 bytes at `sp` as the 64 bytes at `out`, for a
scalar below `2^255` (its top bit clear: no reduction). -/
public theorem Edwards25519_slide.call_eq (out sp : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 512) (hsp : Fits s.mem sp 256) (hso : ¬sp.offset.uaddOverflow 32#64)
    (hmsb : (s.mem.readAt sp 256).msb = false) :
    Edwards25519_slide.call (Edwards25519_slide.args (.value out) (.value sp)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem :=
              s.mem.storeAt out
                (BitVec.packLanes (Edwards25519.slide.spec (s.mem.readAt sp 256))) }) := by
  func_init
  generalize hxd : S.mem.readAt sp 256 = x at hmsb
  have hx₀ : S₀.mem.readAt sp 256 = x := hS ▸ hxd
  rw [hx₀]
  clear hxd
  block_init
  iterate 12 step_pure
  step_alloca with sc
  step_alloca with e
  step_alloca with red
  step_pure
  have hxS : S.mem.readAt sp 256 = x := by
    rw [hS]; simp (disch := mem_fact) only [MemoryState.readAt_alloca_of_fits]; exact hx₀
  -- `e` is fresh: its bits zero, none defined
  have hz : S.mem.readAt e 512 = 0 := by
    rw [hS, he,
      show S₀.slot 1 = (S₀.alloca 40 true).allocaPtr by
        rw [GlobalState.allocaPtr_eq_slot, GlobalState.alloca_slot],
      MemoryState.readAt_alloca_of_fits hwf₀.alloca.alloca (InBounds.allocaPtr (by omega)),
      MemoryState.readAt_alloca_allocaPtr]
  have hzd : S.mem.definedAt e 512 = 0 := by
    rw [hS, he,
      show S₀.slot 1 = (S₀.alloca 40 true).allocaPtr by
        rw [GlobalState.allocaPtr_eq_slot, GlobalState.alloca_slot],
      MemoryState.definedAt_alloca hwf₀.alloca.alloca (InBounds.allocaPtr (by omega)),
      MemoryState.definedAt_alloca_allocaPtr]
  have hov31 := BitVec.not_uaddOverflow_of_le hso (show (31#64).toNat ≤ (32#64).toNat by decide)
  have hf31 : Fits S.mem (sp.add 31#64) 8 := Fits.add_of_le hov31 (by decide) hsp
  have hb31 : S.mem.readAt (sp.add 31#64) 8 = x.extractLsb' 248 8 :=
    MemoryState.readAt_add_of_readAt hsp.inBounds hov31 (by decide) hxS
  step_load consuming hb31 hf31
  step_pure
  finish_block
  · block_init
    finish_block
    rw [← withED_fresh he_room.inBounds hz hzd]
    step_loop using
      Edwards25519_slide.unpack_loop out sp e x _ _ S hsp hso hxS he_room he_off hsp_ne_e 32 0
        (Vector.replicate 64 0#8)
    rw [← hS, ← he, Edwards25519_slide.unpackFrom_all]
    intro E₁ hA₁ hR₁
    have hSA := hS
    refine Edwards25519_slide.carry_loop out sp e x _ _ S he_room he_off 63 0 E₁ hA₁ hR₁ rfl ?_
    intro E₂ hA₂ hR₂
    have hf63 := fits_lane (v := Edwards25519_slide.stage x 63) he_room he_off (j := 63) (by omega)
    have o1 := (Edwards25519_slide.carry_ovf x 63).1
    block_init
    step_pure
    step_load
    rw [Edwards25519_slide.stage_get (by omega)] at hv42
    subst hv42
    step_pure [o1]
    step_store
    rw [storeAt_lane he_off (j := 63) (by omega), Edwards25519_slide.stage_last] at hS
    have hfe := Fits.storeAt_self (x := BitVec.packLanes (Edwards25519.slide.spec x)) he_room
    step_memcpy
    finish_block
    rw [hS, hSA, he]
    erase_frame
    simp [GlobalState.alloca]
  · exact absurd (slt_top hmsb) hbr

end Proof

end MLIR.Zig
