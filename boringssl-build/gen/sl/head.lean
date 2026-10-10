module

public import MLIR.Run.Tactic
public import Boringssl.Mlir.slide
import Firedancer.Common.Memory
import Firedancer.Common.Counter
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Boringssl

/-! ## Specification

`signed char r[256]` as a vector of bytes, `r[0]` first. The C's `int` arithmetic is 32-bit. -/

@[expose] public section

namespace slide

/-- `r[i] = 1 & (a[i >> 3] >> (i & 7))`: the bits of `a`. -/
def bits (a : BitVec 256) : Vector (BitVec 8) 256 :=
  Vector.ofFn fun i => 1#8 &&& a.extractLsb' (8 * (i.val / 8)) 8 >>> (i.val % 8)

/-- The carry loop from `k`: `r[k]` cleared while set, the first clear one set. -/
def carry (r : Vector (BitVec 8) 256) (k : Nat) : Vector (BitVec 8) 256 :=
  if h : k < 256 then
    if r[k] = 0#8 then r.setIfInBounds k 1#8 else carry (r.setIfInBounds k 0#8) (k + 1)
  else r
termination_by 256 - k

/-- The `b` loop at `i` from `b`: each set `r[i + b]` folded into `r[i]`, as `+` while
`r[i] + (r[i + b] << b) <= 15`, else as `-` with a carry while `r[i] - (r[i + b] << b) >= -15`,
else the loop ends. -/
def window (r : Vector (BitVec 8) 256) (i b : Nat) : Vector (BitVec 8) 256 :=
  if h : b ≤ 6 ∧ i + b < 256 then
    if r[i + b] = 0#8 then window r i (b + 1)
    else
      let ri := r[i].signExtend 32
      let rb := r[i + b].signExtend 32 <<< b
      if (ri + rb).sle 15#32 then window ((r.setIfInBounds i ((ri + rb).setWidth 8)).setIfInBounds (i + b) 0#8) i (b + 1)
      else if (-15#32).sle (ri - rb) then
        window (carry (r.setIfInBounds i ((ri - rb).setWidth 8)) (i + b)) i (b + 1)
      else r
  else r
termination_by 7 - b

/-- The `i` loop from `i`: each set `r[i]` given its window. -/
def loop (r : Vector (BitVec 8) 256) (i : Nat) : Vector (BitVec 8) 256 :=
  if h : i < 256 then loop (if r[i] ≠ 0#8 then window r i 1 else r) (i + 1) else r
termination_by 256 - i

end slide

/-- The 256 signed digits `slide` stores at `r` for the 32 bytes `a`. -/
def slide.spec (a : BitVec 256) : Vector (BitVec 8) 256 :=
  slide.loop (slide.bits a) 0

end


/-! ## Proof -/

section Proof

open slide MLIR.Firedancer

/-! ### `r` in memory -/

/-- A splice into a splice that covers it: one splice of the inner value. -/
theorem spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store inside a stored value: one store, the inner value spliced. -/
theorem storeAt_storeAt_add {m : MemoryState} {p : Pointer} {u : BitVec wu} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu) (y : BitVec wy) :
    (m.storeAt p u).storeAt (p.add off) y =
      m.storeAt p (Memory.spliceBits u (off.toNat * 8) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes wu) (off.toNat * 8) (BitVec.allOnes wy) =
      BitVec.allOnes wu := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  simp only [MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw, hones]

/-- Splicing byte `j` into 256 packed bytes sets it. -/
theorem spliceBits_packLanes {u : Vector (BitVec 8) 256} (hj : j < 256) (y : BitVec 8) :
    Memory.spliceBits (BitVec.packLanes u) (j * 8) y = BitVec.packLanes (u.setIfInBounds j y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  have hl :
    ∀ (v : Vector (BitVec 8) 256),
      (BitVec.packLanes v).getLsbD m = (v[m / 8]'(by omega)).getLsbD (m % 8) :=
    fun v => by
    have h := BitVec.extractLsb'_packLanes_of_lt v (s := m) (w := 1) (by omega) (by omega)
    simpa [BitVec.getLsbD_extractLsb'] using congrArg (·.getLsbD 0) h
  rw [Memory.getLsbD_spliceBits, hl, hl, Vector.getElem_setIfInBounds]
  by_cases h : m / 8 = j
  · subst h
    have hc : m / 8 * 8 ≤ m ∧ m < m / 8 * 8 + 8 ∧ m < 8 * 256 := by omega
    simp only [hc, and_self, ite_true]
    congr 1
    omega
  · have hc : ¬(j * 8 ≤ m ∧ m < j * 8 + 8 ∧ m < 8 * 256) := by omega
    simp only [hc, ite_false, Ne.symm h]

/-- `r[j]`'s offset `j`, which does not wrap. -/
theorem byte_offset {r : Pointer} (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) :
    (BitVec.ofNat 64 j).toNat = j ∧ ¬r.offset.uaddOverflow (BitVec.ofNat 64 j) := by
  have h : (BitVec.ofNat 64 j).toNat = j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  exact ⟨h, BitVec.not_uaddOverflow_of_le hov (by rw [h]; show j ≤ 256; omega)⟩

/-- `r[j]`, read from the stored digits. -/
theorem readAt_byte {m : MemoryState} {r : Pointer} {v : Vector (BitVec 8) 256}
    (hr : InBounds m r 2048) (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) :
    (m.storeAt r (BitVec.packLanes v)).readAt (r.add (BitVec.ofNat 64 j)) 8 = v[j] := by
  obtain ⟨h8, hov'⟩ := byte_offset hov hj
  rw [MemoryState.readAt_storeAt_add hr hov' (by omega), h8, BitVec.extractLsb'_packLanes v j hj]

/-- A store of `r[j]` into the stored digits: `r[j]` set. -/
theorem storeAt_byte {m : MemoryState} {r : Pointer} {v : Vector (BitVec 8) 256}
    (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) (y : BitVec 8) :
    (m.storeAt r (BitVec.packLanes v)).storeAt (r.add (BitVec.ofNat 64 j)) y =
      m.storeAt r (BitVec.packLanes (v.setIfInBounds j y)) := by
  obtain ⟨h8, hov'⟩ := byte_offset hov hj
  rw [storeAt_storeAt_add hov' (by rw [h8]; omega), h8, spliceBits_packLanes hj]

/-- The digits `v` stored at `r` over `S`. -/
abbrev st (S : GlobalState) (r : Pointer) (v : Vector (BitVec 8) 256) : GlobalState :=
  { S with mem := S.mem.storeAt r (BitVec.packLanes v) }

/-- The constants the `i` loop reads. -/
abbrev consts (E : ⟪slide.Γ⟫) : ⟪slide.Γ⟫ :=
  E[%207 := .value 3#64, %210 := .value 1#8, %211 := .value 1#64, %213 := .value 2#64,
    %214 := .value 256#64, %216 := .value 0#8, %217 := .value 255#64, %218 := .value 0#1,
    %219 := .value 5#32, %220 := .value 2#32, %221 := .value 1#32, %222 := .value 16#32,
    %223 := .value 4294967280#32, %224 := .value 0#32, %225 := .value 3#32, %226 := .value 4#32,
    %227 := .value 4#64, %228 := .value 5#64, %229 := .value 6#32, %230 := .value 4294967295#32]

/-- The `i` loop's registers at `i`: `%254` counts down from `254`. -/
abbrev hdrI (E : ⟪slide.Γ⟫) (i : Nat) : ⟪slide.Γ⟫ :=
  (consts E)[%253 := .value (BitVec.ofNat 64 i), %254 := .value (254#32 - BitVec.ofNat 32 i),
    %255 := .value (BitVec.ofNat 64 (i + 1))]

/-- The `b` loop's registers at `i`: `r + i`, and `%262 = min(254 - i, 5) + 2`. -/
abbrev hdrB (r : Pointer) (E : ⟪slide.Γ⟫) (i : Nat) : ⟪slide.Γ⟫ :=
  (hdrI E i)[%256 := .value (r.add (BitVec.ofNat 64 i)),
    %262 := .value (BitVec.ofNat 32 (min (254 - i) 5 + 2))]

/-- Distinct small counters differ as `long`s. -/
theorem ofNat64_ne {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) (h : a ≠ b) :
    BitVec.ofNat 64 a ≠ BitVec.ofNat 64 b := by
  intro e
  have := congrArg BitVec.toNat e
  simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb] at this
  exact h this

/-- The carry at a clear `r[k]`: set it. -/
theorem carry_set {v : Vector (BitVec 8) 256} (hk : k < 256) (h : v[k] = 0#8) :
    carry v k = v.setIfInBounds k 1#8 := by
  rw [carry]
  simp [hk, h]

/-- The carry at a set `r[k]`: clear it, carry on. -/
theorem carry_clear {v : Vector (BitVec 8) 256} (hk : k < 256) (h : ¬v[k] = 0#8) :
    carry v k = carry (v.setIfInBounds k 0#8) (k + 1) := by
  rw [carry]
  simp [hk, h]

/-- The carry past `r[255]`: nothing. -/
theorem carry_done {v : Vector (BitVec 8) 256} (hk : 256 ≤ k) : carry v k = v := by
  rw [carry]
  simp [show ¬k < 256 by omega]

