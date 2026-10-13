module

public import Agave.Common.Fe2625x4
public import Agave.Common.Decompress
public import MLIR.Run.Tactic
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic
import MLIR.Run.Tactic.Memory
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
meta import Std.Tactic.BVDecide.Reflect

/-! The AVX2 `ExtendedPoint` and `CachedPoint`: a `FieldElement2625x4` of four field elements, in
memory five registers at bytes 0, 32, …, 128. Here: the lane operations of their formulas
(`shuffle`, `blend`, `+`, `negate_lazy`, `diff_sum`, `reduce`, `-`), each register spelled lane by
lane; the lifted code's registers for `diff_sum`; the overflow facts of `reduce`'s carries; the
160-byte objects' reads through `storeFe4x` and as 1280 bits (`fe4xBits`, for copies); the
`NafLookupTable5<CachedPoint>` object (`storeNaf5`, `readNaf5`); `name_fe4`. -/

namespace MLIR

open Agave

@[expose] public section

namespace Agave.Fe2625x4

/-! ### Registers -/

/-- `_mm256_permutevar8x32_epi32(x, c)`: lane `j` is lane `c j` of `x`. -/
def permute (x : Vector (BitVec 32) 8) (c : Fin 8 → Fin 8) : Vector (BitVec 32) 8 :=
  #v[x[c 0], x[c 1], x[c 2], x[c 3], x[c 4], x[c 5], x[c 6], x[c 7]]

/-- `_mm256_blend_epi32(x, y, m)`: lane `j` of `y` where `m j`, else of `x`. -/
def blendLanes (x y : Vector (BitVec 32) 8) (m : Fin 8 → Bool) : Vector (BitVec 32) 8 :=
  #v[if m 0 then y[0] else x[0], if m 1 then y[1] else x[1], if m 2 then y[2] else x[2],
    if m 3 then y[3] else x[3], if m 4 then y[4] else x[4], if m 5 then y[5] else x[5],
    if m 6 then y[6] else x[6], if m 7 then y[7] else x[7]]

/-- Lane-wise `x + y`. -/
def addLanes (x y : Vector (BitVec 32) 8) : Vector (BitVec 32) 8 :=
  #v[x[0] + y[0], x[1] + y[1], x[2] + y[2], x[3] + y[3], x[4] + y[4], x[5] + y[5], x[6] + y[6],
    x[7] + y[7]]

/-- Lane-wise `x - y`. -/
def subLanes (x y : Vector (BitVec 32) 8) : Vector (BitVec 32) 8 :=
  #v[x[0] - y[0], x[1] - y[1], x[2] - y[2], x[3] - y[3], x[4] - y[4], x[5] - y[5], x[6] - y[6],
    x[7] - y[7]]

/-- Lane-wise `x + x`, as the shift `x << 1` the code computes. -/
def dblLanes (x : Vector (BitVec 32) 8) : Vector (BitVec 32) 8 :=
  #v[x[0] <<< 1, x[1] <<< 1, x[2] <<< 1, x[3] <<< 1, x[4] <<< 1, x[5] <<< 1, x[6] <<< 1, x[7] <<< 1]

/-! ### Field elements -/

/-- The registers `f 0, …, f 4`. -/
def ofRegs (f : Fin 5 → Vector (BitVec 32) 8) : Fe2625x4 :=
  ![f 0, f 1, f 2, f 3, f 4]

/-- `ofRegs` as the compiled code's: each register computed only when read. A literal `![…]`
computes all five at each read (its value is a function: the compiler eta-expands it), so nested
lane operations cost five times their depth. -/
def ofRegsLazy (f : Fin 5 → Vector (BitVec 32) 8) : Fe2625x4 :=
  f

@[csimp]
theorem ofRegs_eq_lazy : @ofRegs = @ofRegsLazy := by
  funext f i
  fin_cases i <;> rfl

/-- Five registers from their 1280 bits, register 0 lowest. -/
def ofBits (c : BitVec 1280) : Fe2625x4 := fun i =>
  Vector.ofFn fun l : Fin 8 => c.extractLsb' (256 * i + 32 * l) 32

/-- `x.shuffle(c)`. -/
def shuffle (x : Fe2625x4) (c : Fin 8 → Fin 8) : Fe2625x4 :=
  ofRegs fun i => permute (x i) c

/-- `x.blend(y, m)`. -/
def blend (x y : Fe2625x4) (m : Fin 8 → Bool) : Fe2625x4 :=
  ofRegs fun i => blendLanes (x i) (y i) m

/-- `x + y`, without carries. -/
def add (x y : Fe2625x4) : Fe2625x4 :=
  ofRegs fun i => addLanes (x i) (y i)

/-- `x + x`, as shifts. -/
def dbl (x : Fe2625x4) : Fe2625x4 :=
  ofRegs fun i => dblLanes (x i)

/-- `FieldElement2625x4::ZERO`. -/
def zero : Fe2625x4 :=
  ofRegs fun _ => #v[0, 0, 0, 0, 0, 0, 0, 0]

/-- `x.negate_lazy()`: `2p - x`, without carries. -/
def negateLazy (x : Fe2625x4) : Fe2625x4 :=
  ![subLanes p2Lo (x 0), subLanes p2Hi (x 1), subLanes p2Hi (x 2), subLanes p2Hi (x 3),
    subLanes p2Hi (x 4)]

/-- `negateLazy` as the compiled code's, register by register (`ofRegsLazy`). -/
def negateLazyLazy (x : Fe2625x4) : Fe2625x4 := fun i =>
  subLanes (if i = 0 then p2Lo else p2Hi) (x i)

@[csimp]
theorem negateLazy_eq_lazy : @negateLazy = @negateLazyLazy := by
  funext x i
  fin_cases i <;> rfl

/-- The `Shuffle` controls: lane `j` of the result is lane `c j`. -/
def Shuffle.AAAA : Fin 8 → Fin 8 :=
  ![0, 0, 2, 2, 0, 0, 2, 2]

def Shuffle.BBBB : Fin 8 → Fin 8 :=
  ![1, 1, 3, 3, 1, 1, 3, 3]

def Shuffle.CACA : Fin 8 → Fin 8 :=
  ![4, 0, 6, 2, 4, 0, 6, 2]

def Shuffle.DBBD : Fin 8 → Fin 8 :=
  ![5, 1, 7, 3, 1, 5, 3, 7]

def Shuffle.ADDA : Fin 8 → Fin 8 :=
  ![0, 5, 2, 7, 5, 0, 7, 2]

def Shuffle.CBCB : Fin 8 → Fin 8 :=
  ![4, 1, 6, 3, 4, 1, 6, 3]

def Shuffle.ABAB : Fin 8 → Fin 8 :=
  ![0, 1, 2, 3, 0, 1, 2, 3]

def Shuffle.BADC : Fin 8 → Fin 8 :=
  ![1, 0, 3, 2, 5, 4, 7, 6]

def Shuffle.BACD : Fin 8 → Fin 8 :=
  ![1, 0, 3, 2, 4, 5, 6, 7]

def Shuffle.ABDC : Fin 8 → Fin 8 :=
  ![0, 1, 2, 3, 5, 4, 7, 6]

/-- The `Lanes` masks: element `A` in lanes 0, 2, `B` in 1, 3, `C` in 4, 6, `D` in 5, 7. -/
def Lanes.C : Fin 8 → Bool :=
  ![false, false, false, false, true, false, true, false]

def Lanes.D : Fin 8 → Bool :=
  ![false, false, false, false, false, true, false, true]

def Lanes.AB : Fin 8 → Bool :=
  ![true, true, true, true, false, false, false, false]

def Lanes.AD : Fin 8 → Bool :=
  ![true, false, true, false, false, true, false, true]

def Lanes.AC : Fin 8 → Bool :=
  ![true, false, true, false, true, false, true, false]

def Lanes.BC : Fin 8 → Bool :=
  ![false, true, false, true, true, false, true, false]

/-- `x.diff_sum()`: `(B - A, B + A, D - C, D + C)`, the differences through `negate_lazy`. -/
def diffSum (x : Fe2625x4) : Fe2625x4 :=
  add (shuffle x Shuffle.BADC) (blend x (negateLazy x) Lanes.AC)

/-- The carries out of `x`'s odd limbs, elements `A … D`: bits 25 up. -/
def carries (x : Vector (BitVec 32) 8) : Fin 4 → BitVec 32 :=
  ![x[2] >>> 25, x[3] >>> 25, x[6] >>> 25, x[7] >>> 25]

/-- A register's limbs reduced: even limbs keep 26 bits and take `c`, odd limbs keep 25 bits and
take the even limb's carry. -/
def reduceReg (x : Vector (BitVec 32) 8) (c : Fin 4 → BitVec 32) : Vector (BitVec 32) 8 :=
  #v[(x[0] &&& 67108863) + c 0, (x[1] &&& 67108863) + c 1, (x[2] &&& 33554431) + x[0] >>> 26,
    (x[3] &&& 33554431) + x[1] >>> 26, (x[4] &&& 67108863) + c 2, (x[5] &&& 67108863) + c 3,
    (x[6] &&& 33554431) + x[4] >>> 26, (x[7] &&& 33554431) + x[5] >>> 26]

/-- `x.reduce()`: each limb keeps its low 26 (even) or 25 (odd) bits and takes the carry of the limb
below; limb 0 takes 19 times limb 9's (`c9_19`, below `2^12`: its high half is zero). -/
def reduce (v : Fe2625x4) : Fe2625x4 :=
  ![reduceReg (v 0) fun e => carries (v 4) e * 19, reduceReg (v 1) (carries (v 0)),
    reduceReg (v 2) (carries (v 1)), reduceReg (v 3) (carries (v 2)),
    reduceReg (v 4) (carries (v 3))]

/-- `reduce` as the compiled code's, register by register (`ofRegsLazy`). -/
def reduceLazy (v : Fe2625x4) : Fe2625x4 := fun i =>
  if i = 0 then reduceReg (v 0) fun e => carries (v 4) e * 19
  else reduceReg (v i) (carries (v (i - 1)))

@[csimp]
theorem reduce_eq_lazy : @reduce = @reduceLazy := by
  funext v i
  fin_cases i <;> rfl

/-- `P_TIMES_16_LO`, register 0 of `(16p, 16p, 16p, 16p)`. -/
def p16Lo : Vector (BitVec 32) 8 :=
  #v[1073741520, 1073741520, 536870896, 536870896, 1073741520, 1073741520, 536870896, 536870896]

/-- `P_TIMES_16_HI`, registers 1 to 4 of `(16p, 16p, 16p, 16p)`. -/
def p16Hi : Vector (BitVec 32) 8 :=
  #v[1073741808, 1073741808, 536870896, 536870896, 1073741808, 1073741808, 536870896, 536870896]

/-- `-x`: `16p - x`, reduced. -/
def neg (x : Fe2625x4) : Fe2625x4 :=
  reduce
    ![subLanes p16Lo (x 0), subLanes p16Hi (x 1), subLanes p16Hi (x 2), subLanes p16Hi (x 3),
      subLanes p16Hi (x 4)]

/-- `neg` as the compiled code's, register by register (`ofRegsLazy`). -/
def negLazy (x : Fe2625x4) : Fe2625x4 :=
  reduceLazy fun i => subLanes (if i = 0 then p16Lo else p16Hi) (x i)

@[csimp]
theorem neg_eq_lazy : @neg = @negLazy := by
  funext x i
  fin_cases i <;> rfl

end Agave.Fe2625x4

/-! ### The lifted code's registers -/

namespace Agave

open Fe2625x4

/-- A field element as its registers. -/
theorem Fe2625x4.regs_eta (v : Fe2625x4) : ![v 0, v 1, v 2, v 3, v 4] = v := by
  funext i
  fin_cases i <;> rfl

/-- Register `i` of `x.blend(x.diff_sum(), Lanes::AB)` as the lifted code computes it, `p`, `q` its
`2p` limbs. -/
def Fe2625x4.dsReg (a : Vector (BitVec 32) 8) (p q : BitVec 32) : Vector (BitVec 32) 8 :=
  #v[p - a[0] + a[1], a[1] + a[0], q - a[2] + a[3], a[3] + a[2], a[4], a[5], a[6], a[7]]

theorem Fe2625x4.ds_reg (a : Vector (BitVec 32) 8) (p q : BitVec 32) :
    blendLanes a
        (addLanes (permute a Shuffle.BADC)
          (blendLanes a (subLanes #v[p, p, q, q, p, p, q, q] a) Lanes.AC))
        Lanes.AB =
      dsReg a p q := by
  simp [blendLanes, addLanes, permute, subLanes, dsReg, Shuffle.BADC, Lanes.AC, Lanes.AB]
  exact ⟨BitVec.add_comm _ _, BitVec.add_comm _ _, BitVec.add_comm _ _, BitVec.add_comm _ _⟩

theorem Fe2625x4.ds_eq (X : Fe2625x4) :
    blend X (diffSum X) Lanes.AB =
      ![dsReg (X 0) 134217690 67108862, dsReg (X 1) 134217726 67108862,
        dsReg (X 2) 134217726 67108862, dsReg (X 3) 134217726 67108862,
        dsReg (X 4) 134217726 67108862] := by
  funext i
  fin_cases i
  · exact Fe2625x4.ds_reg _ 134217690 67108862
  all_goals exact Fe2625x4.ds_reg _ 134217726 67108862

/-- Register `i` of `x.shuffle(Shuffle::ABDC).diff_sum()` as the lifted code computes it, `p`, `q`
its `2p` limbs. -/
def Fe2625x4.dsAbdcReg (c : Vector (BitVec 32) 8) (p q : BitVec 32) : Vector (BitVec 32) 8 :=
  #v[p - c[0] + c[1], c[1] + c[0], q - c[2] + c[3], c[3] + c[2], p - c[5] + c[4], c[4] + c[5],
    q - c[7] + c[6], c[6] + c[7]]

theorem Fe2625x4.dsAbdc_reg (c : Vector (BitVec 32) 8) (p q : BitVec 32) :
    addLanes (permute (permute c Shuffle.ABDC) Shuffle.BADC)
        (blendLanes (permute c Shuffle.ABDC)
          (subLanes #v[p, p, q, q, p, p, q, q] (permute c Shuffle.ABDC)) Lanes.AC) =
      dsAbdcReg c p q := by
  simp [blendLanes, addLanes, permute, subLanes, dsAbdcReg, Shuffle.BADC, Shuffle.ABDC, Lanes.AC]
  exact
    ⟨BitVec.add_comm _ _, BitVec.add_comm _ _, BitVec.add_comm _ _, BitVec.add_comm _ _,
      BitVec.add_comm _ _, BitVec.add_comm _ _, BitVec.add_comm _ _, BitVec.add_comm _ _⟩

theorem Fe2625x4.dsAbdc_eq (w : Fe2625x4) :
    diffSum (shuffle w Shuffle.ABDC) =
      ![dsAbdcReg (w 0) 134217690 67108862, dsAbdcReg (w 1) 134217726 67108862,
        dsAbdcReg (w 2) 134217726 67108862, dsAbdcReg (w 3) 134217726 67108862,
        dsAbdcReg (w 4) 134217726 67108862] := by
  funext i
  fin_cases i
  · exact Fe2625x4.dsAbdc_reg _ 134217690 67108862
  all_goals exact Fe2625x4.dsAbdc_reg _ 134217726 67108862

/-! ### `reduce`'s carries in the lifted code: no `nsw`/`nuw` overflow -/

/-- A carry out of an odd limb plus an even limb's low bits: no overflow. -/
theorem carry25_add_ok (x y : BitVec 32) :
    (x >>> 25).saddOverflow (y &&& 67108863#32) = false ∧
      (x >>> 25).uaddOverflow (y &&& 67108863#32) = false := by
  constructor <;> bv_decide

/-- A carry out of an even limb plus an odd limb's low bits: no overflow. -/
theorem carry26_add_ok (x y : BitVec 32) :
    (x >>> 26).saddOverflow (y &&& 33554431#32) = false ∧
      (x >>> 26).uaddOverflow (y &&& 33554431#32) = false := by
  constructor <;> bv_decide

/-- Zero plus an even limb's low bits: no overflow. -/
theorem zero_add_ok (y : BitVec 32) :
    (0#32).saddOverflow (y &&& 67108863#32) = false ∧
      (0#32).uaddOverflow (y &&& 67108863#32) = false := by
  constructor <;> bv_decide

/-- `c9 · 19`, `c9` a carry below `2 ^ 7`: no overflow. -/
theorem c9_mul_ok (x : BitVec 32) :
    (0#32 ++ (x >>> 25 &&& 127#32)).smulOverflow 19#64 = false ∧
      (0#32 ++ (x >>> 25 &&& 127#32)).umulOverflow 19#64 = false := by
  constructor <;> bv_decide

/-- An even limb's low bits plus `c9 · 19`: no overflow. -/
theorem c9_add_ok (x y : BitVec 32) :
    (y &&& 67108863#32).saddOverflow
          (BitVec.extractLsb' 0 32 ((0#32 ++ (x >>> 25 &&& 127#32)) * 19#64)) =
        false ∧
      (y &&& 67108863#32).uaddOverflow
          (BitVec.extractLsb' 0 32 ((0#32 ++ (x >>> 25 &&& 127#32)) * 19#64)) =
        false := by
  constructor <;> bv_decide

/-- An odd limb plus the high half of `c9 · 19`, zero: no overflow. -/
theorem c9_hi_add_ok (x y z : BitVec 32) :
    (y >>> 26 + (z &&& 33554431#32)).saddOverflow
          (BitVec.extractLsb' 32 32 ((0#32 ++ (x >>> 25 &&& 127#32)) * 19#64)) =
        false ∧
      (y >>> 26 + (z &&& 33554431#32)).uaddOverflow
          (BitVec.extractLsb' 32 32 ((0#32 ++ (x >>> 25 &&& 127#32)) * 19#64)) =
        false := by
  constructor <;> bv_decide

end Agave

/-! ### The 160-byte objects -/

/-- Five register stores, lowest first, as `storeFe4x`. -/
theorem MemoryState.storeFe4x_eq {m : MemoryState} {p : Pointer}
    {v0 v1 v2 v3 v4 : Vector (BitVec 32) 8} :
    ((((m.storeAt p (BitVec.packLanes v0)).storeAt (p.add 32#64) (BitVec.packLanes v1)).storeAt
                (p.add 64#64) (BitVec.packLanes v2)).storeAt
            (p.add 96#64) (BitVec.packLanes v3)).storeAt
        (p.add 128#64) (BitVec.packLanes v4) =
      m.storeFe4x p ![v0, v1, v2, v3, v4] :=
  rfl

/-- No wrap at a register's offset. -/
theorem Fe4x.noOverflow {p : Pointer} (ho : p.offset.toNat + 160 ≤ 2 ^ 64) {k : BitVec 64}
    (hk : k.toNat < 160) : ¬p.offset.uaddOverflow k := by
  simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega

/-- Room for registers from room for their 1280 bits. -/
theorem MemoryState.Fe4xRoom.of_room {m : MemoryState} {p : Pointer} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.Fe4xRoom p := by
  refine ⟨by omega, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (Fe4x.noOverflow ho (by decide)) (by decide) h

/-- Registers that fit from their 1280 bits that fit. -/
theorem MemoryState.Fe4xFit.of_fits {m : MemoryState} {p : Pointer} (h : Fits m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.Fe4xFit p := by
  refine ⟨by omega, h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (Fe4x.noOverflow ho (by decide)) (by decide) h

/-- The 1280 bits of registers that fit. -/
theorem MemoryState.Fe4xFit.fits {m : MemoryState} {p : Pointer} (h : m.Fe4xFit p) :
    Fits m p 1280 := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  have hov {k : BitVec 64} (hk : k.toNat ≤ 128) : ¬p.offset.uaddOverflow k := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega
  have a1 := Fits.append (hov (by decide)) (by decide) rfl h0 h1
  have a2 := Fits.append (hov (by decide)) (by decide) rfl a1 h2
  have a3 := Fits.append (hov (by decide)) (by decide) rfl a2 h3
  exact Fits.append (hov (by decide)) (by decide) rfl a3 h4

/-- Registers stored in a 160-byte object read back. -/
@[mlir_read]
theorem MemoryState.readFe4x_storeFe4x_room {m : MemoryState} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : (m.storeFe4x p v).readFe4x p = v :=
  MemoryState.readFe4x_storeFe4x_self (MemoryState.Fe4xRoom.of_room h ho)

/-- Register 0 stored in a 160-byte object reads back. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe4x_0 {m : MemoryState} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeFe4x p v).readAt p 256 = BitVec.packLanes (v 0) := by
  obtain ⟨-, h0, h1, h2, h3, h4⟩ := MemoryState.Fe4xRoom.of_room h ho
  simp only [MemoryState.storeFe4x, Tactic.readThroughStore]

/-- Register 1 stored in a 160-byte object reads back. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe4x_32 {m : MemoryState} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeFe4x p v).readAt (p.add 32#64) 256 = BitVec.packLanes (v 1) := by
  obtain ⟨-, h0, h1, h2, h3, h4⟩ := MemoryState.Fe4xRoom.of_room h ho
  simp only [MemoryState.storeFe4x, Tactic.readThroughStore]

/-- Register 2 stored in a 160-byte object reads back. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe4x_64 {m : MemoryState} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeFe4x p v).readAt (p.add 64#64) 256 = BitVec.packLanes (v 2) := by
  obtain ⟨-, h0, h1, h2, h3, h4⟩ := MemoryState.Fe4xRoom.of_room h ho
  simp only [MemoryState.storeFe4x, Tactic.readThroughStore]

/-- Register 3 stored in a 160-byte object reads back. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe4x_96 {m : MemoryState} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeFe4x p v).readAt (p.add 96#64) 256 = BitVec.packLanes (v 3) := by
  obtain ⟨-, h0, h1, h2, h3, h4⟩ := MemoryState.Fe4xRoom.of_room h ho
  simp only [MemoryState.storeFe4x, Tactic.readThroughStore]

/-- Register 4 stored in a 160-byte object reads back. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe4x_128 {m : MemoryState} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeFe4x p v).readAt (p.add 128#64) 256 = BitVec.packLanes (v 4) := by
  obtain ⟨-, h0, h1, h2, h3, h4⟩ := MemoryState.Fe4xRoom.of_room h ho
  simp only [MemoryState.storeFe4x, Tactic.readThroughStore]

/-- A read in another block passes `storeFe4x`. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe4x_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storeFe4x q v).readAt p w = m.readAt p w := by
  simp only [MemoryState.storeFe4x, Tactic.readThroughStore]

/-- `storeZ10` keeps every block, its length and lifetime. -/
@[simp, mlir_state]
theorem Room.storeZ10_iff {m : MemoryState} : Room (m.storeZ10 q v) p w ↔ Room m p w := by
  simp [MemoryState.storeZ10]

@[mlir_transport]
theorem Room.storeZ10 {m : MemoryState} (h : Room m p w) : Room (m.storeZ10 q v) p w :=
  Room.storeZ10_iff.mpr h

/-- `storeZ10` keeps known bits known. -/
@[mlir_transport]
theorem Fits.storeZ10 {m : MemoryState} (h : Fits m p w) : Fits (m.storeZ10 q v) p w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
theorem InBounds.storeZ10 {m : MemoryState} (h : InBounds m p w) : InBounds (m.storeZ10 q v) p w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt

/-- A read in another block passes `storeZ10`. -/
@[mlir_read]
theorem MemoryState.readAt_storeZ10_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storeZ10 q v).readAt p w = m.readAt p w := by
  simp only [MemoryState.storeZ10, Tactic.readThroughStore]

/-- Registers in another block are unaffected by a store. -/
@[mlir_read]
theorem MemoryState.readFe4x_storeAt_of_id_ne {m : MemoryState} {x : BitVec w} (h : q.id ≠ p.id) :
    (m.storeAt q x).readFe4x p = m.readFe4x p := by
  funext i
  fin_cases i <;> simp only [MemoryState.readFe4x, MemoryState.readU32x8, Tactic.readThroughStore]

/-- Registers in another block are unaffected by `storeZ10`. -/
@[mlir_read]
theorem MemoryState.readFe4x_storeZ10_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storeZ10 q v).readFe4x p = m.readFe4x p := by
  funext i
  fin_cases i <;>
    simp only [MemoryState.readFe4x, MemoryState.readU32x8, MemoryState.storeZ10,
      Tactic.readThroughStore]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readFe4x_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readFe4x p = m.readFe4x p := by
  funext i
  fin_cases i <;> simp only [MemoryState.readFe4x, MemoryState.readU32x8, readAt_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readFe4x_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readFe4x p = m.readFe4x p := by
  funext i
  fin_cases i <;> simp only [MemoryState.readFe4x, MemoryState.readU32x8, readAt_lifetimeEnd]

/-- Registers stored where there is room fit. -/
@[mlir_fresh]
theorem MemoryState.Fe4xFit.storeFe4x {m : MemoryState} (h : m.Fe4xRoom p) :
    (m.storeFe4x p v).Fe4xFit p := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  refine ⟨ho, ?_, ?_, ?_, ?_, ?_⟩ <;> simp only [MemoryState.storeFe4x] <;> mem_fact

/-- Five registers' 1280 bits, register 0 lowest. -/
def fe4xBits (v : Fe2625x4) : BitVec 1280 :=
  BitVec.packLanes (v 4) ++
    (BitVec.packLanes (v 3) ++
      (BitVec.packLanes (v 2) ++ (BitVec.packLanes (v 1) ++ BitVec.packLanes (v 0))))

/-- Registers stored in a 160-byte object: their 1280 bits. -/
@[mlir_read]
theorem MemoryState.readAt_storeFe4x_1280 {m : MemoryState} (h : Room m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : (m.storeFe4x p v).readAt p 1280 = fe4xBits v := by
  have hb : InBounds (m.storeFe4x p v) p 1280 := (Room.storeFe4x h).inBounds
  have a1 :=
    Agave.readAt_append (v := 256) (w := 256) (hb.mono (by decide))
      (Fe4x.noOverflow ho (k := 32#64) (by decide)) (by decide) (readAt_storeFe4x_0 h ho)
      (readAt_storeFe4x_32 h ho)
  have a2 :=
    Agave.readAt_append (v := 512) (w := 256) (hb.mono (by decide))
      (Fe4x.noOverflow ho (k := 64#64) (by decide)) (by decide) a1 (readAt_storeFe4x_64 h ho)
  have a3 :=
    Agave.readAt_append (v := 768) (w := 256) (hb.mono (by decide))
      (Fe4x.noOverflow ho (k := 96#64) (by decide)) (by decide) a2 (readAt_storeFe4x_96 h ho)
  exact
    Agave.readAt_append (v := 1024) (w := 256) hb (Fe4x.noOverflow ho (k := 128#64) (by decide))
      (by decide) a3 (readAt_storeFe4x_128 h ho)

theorem extract_append5_0 (a b c d e : BitVec 256) :
    (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 0 256 = a := by bv_decide

theorem extract_append5_256 (a b c d e : BitVec 256) :
    (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 256 256 = b := by bv_decide

theorem extract_append5_512 (a b c d e : BitVec 256) :
    (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 512 256 = c := by bv_decide

theorem extract_append5_768 (a b c d e : BitVec 256) :
    (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 768 256 = d := by bv_decide

theorem extract_append5_1024 (a b c d e : BitVec 256) :
    (e ++ (d ++ (c ++ (b ++ a)))).extractLsb' 1024 256 = e := by bv_decide

/-- A register's lanes packed back: its bits. -/
theorem MemoryState.packLanes_readU32x8 {m : MemoryState} {p : Pointer} :
    BitVec.packLanes (m.readU32x8 p) = m.readAt p 256 := by
  generalize hx : m.readAt p 256 = x
  simp only [MemoryState.readU32x8, hx, BitVec.packLanes, Ty.extractVecElem_eq,
    Vector.tail_eq_cast_extract, Vector.getElem_cast, Vector.getElem_extract, Vector.getElem_ofFn]
  simp
  bv_decide

/-- The 1280 bits of five registers that fit. -/
theorem MemoryState.readAt_fe4xBits {m : MemoryState} {p : Pointer} (h : m.Fe4xFit p) :
    m.readAt p 1280 = fe4xBits (m.readFe4x p) := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  have hb : InBounds m p 1280 := (MemoryState.Fe4xFit.fits ⟨ho, h0, h1, h2, h3, h4⟩).inBounds
  have hov {k : BitVec 64} (hk : k.toNat ≤ 128) : ¬p.offset.uaddOverflow k := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega
  have a1 :=
    Agave.readAt_append (v := 256) (w := 256) (hb.mono (by decide)) (hov (k := 32#64) (by decide))
      (by decide) packLanes_readU32x8.symm packLanes_readU32x8.symm
  have a2 :=
    Agave.readAt_append (v := 512) (w := 256) (hb.mono (by decide)) (hov (k := 64#64) (by decide))
      (by decide) a1 packLanes_readU32x8.symm
  have a3 :=
    Agave.readAt_append (v := 768) (w := 256) (hb.mono (by decide)) (hov (k := 96#64) (by decide))
      (by decide) a2 packLanes_readU32x8.symm
  exact
    Agave.readAt_append (v := 1024) (w := 256) hb (hov (k := 128#64) (by decide)) (by decide) a3
      packLanes_readU32x8.symm

/-- Storing five registers' bits is storing the registers. -/
theorem MemoryState.storeAt_fe4xBits {m : MemoryState} {p : Pointer} {v : Fe2625x4}
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) : m.storeAt p (fe4xBits v) = m.storeFe4x p v := by
  have hov (k : Nat) (hk : k ≤ 128) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  simp only [fe4xBits, MemoryState.storeFe4x]
  rw [MemoryState.storeAt_storeAt_append (k := 32) (hov 32 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (k := 64) (hov 64 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (k := 96) (hov 96 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (k := 128) (hov 128 (by omega)) rfl (by decide)]

/-- A copy of five registers that fit: their store. -/
theorem MemoryState.storeAt_readAt_fe4x {m m' : MemoryState} {p q : Pointer} (h : m'.Fe4xFit q)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) :
    m.storeAt p (m'.readAt q 1280) = m.storeFe4x p (m'.readFe4x q) := by
  rw [MemoryState.readAt_fe4xBits h, MemoryState.storeAt_fe4xBits ho]

/-- The registers' bits inside a known 1280-bit read (a copied object's loads). -/
theorem MemoryState.readAt_regs_of_1280 {m : MemoryState} {p : Pointer} (hb : InBounds m p 1280)
    (ho : p.offset.toNat + 128 < 2 ^ 64) :
    (m.readAt p 1280).setWidth 256 = m.readAt p 256 ∧
      (m.readAt p 1280).extractLsb' 256 256 = m.readAt (p.add 32#64) 256 ∧
      (m.readAt p 1280).extractLsb' 512 256 = m.readAt (p.add 64#64) 256 ∧
      (m.readAt p 1280).extractLsb' 768 256 = m.readAt (p.add 96#64) 256 ∧
      (m.readAt p 1280).extractLsb' 1024 256 = m.readAt (p.add 128#64) 256 := by
  have hov {k : BitVec 64} (hk : k.toNat ≤ 128) : ¬p.offset.uaddOverflow k := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]; omega
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [BitVec.setWidth_eq_extractLsb' (by decide)]
    simpa [Pointer.add_zero] using
      (MemoryState.readAt_add_of_readAt (off := 0#64) (w := 256) hb (hov (by decide)) (by decide)
          rfl).symm
  · exact
      (MemoryState.readAt_add_of_readAt (off := 32#64) hb (hov (by decide)) (by decide) rfl).symm
  · exact
      (MemoryState.readAt_add_of_readAt (off := 64#64) hb (hov (by decide)) (by decide) rfl).symm
  · exact
      (MemoryState.readAt_add_of_readAt (off := 96#64) hb (hov (by decide)) (by decide) rfl).symm
  · exact
      (MemoryState.readAt_add_of_readAt (off := 128#64) hb (hov (by decide)) (by decide) rfl).symm

theorem setWidth_append5 (a b c d e : BitVec 256) :
    (e ++ (d ++ (c ++ (b ++ a)))).setWidth 256 = a := by bv_decide

/-- Register 0 of five registers' bits, as a truncation. -/
@[simp]
theorem fe4xBits_setWidth (v : Fe2625x4) : (fe4xBits v).setWidth 256 = BitVec.packLanes (v 0) :=
  setWidth_append5 _ _ _ _ _

/-- Registers read off their bits, packed back. -/
theorem fe4xBits_ofBits (c : BitVec 1280) : fe4xBits (Fe2625x4.ofBits c) = c := by
  simp only [fe4xBits, Fe2625x4.ofBits, BitVec.packLanes, Vector.tail_eq_cast_extract,
    Vector.getElem_cast, Vector.getElem_extract, Vector.getElem_ofFn]
  simp
  bv_decide

/-- A read below two `alloca`s. -/
theorem MemoryState.readAt_alloca_alloca {s : GlobalState} (hwf : s.WF) (h : InBounds s.mem q w) :
    ((s.alloca n d).alloca n' d').mem.readAt q w = s.mem.readAt q w := by
  rw [MemoryState.readAt_alloca_of_fits hwf.alloca (h.alloca hwf),
    MemoryState.readAt_alloca_of_fits hwf h]

/-- Register `k` of five registers' bits. -/
@[simp]
theorem fe4xBits_extract_0 (v : Fe2625x4) :
    (fe4xBits v).extractLsb' 0 256 = BitVec.packLanes (v 0) := by exact extract_append5_0 _ _ _ _ _

@[simp]
theorem fe4xBits_extract_256 (v : Fe2625x4) :
    (fe4xBits v).extractLsb' 256 256 = BitVec.packLanes (v 1) := by
  exact extract_append5_256 _ _ _ _ _

@[simp]
theorem fe4xBits_extract_512 (v : Fe2625x4) :
    (fe4xBits v).extractLsb' 512 256 = BitVec.packLanes (v 2) := by
  exact extract_append5_512 _ _ _ _ _

@[simp]
theorem fe4xBits_extract_768 (v : Fe2625x4) :
    (fe4xBits v).extractLsb' 768 256 = BitVec.packLanes (v 3) := by
  exact extract_append5_768 _ _ _ _ _

@[simp]
theorem fe4xBits_extract_1024 (v : Fe2625x4) :
    (fe4xBits v).extractLsb' 1024 256 = BitVec.packLanes (v 4) := by
  exact extract_append5_1024 _ _ _ _ _

/-- Registers at `q` from the 1280 bits there. -/
theorem MemoryState.readFe4x_of_readAt {m : MemoryState} {q : Pointer} {v : Fe2625x4}
    (hb : InBounds m q 1280) (ho : q.offset.toNat + 128 < 2 ^ 64)
    (h : m.readAt q 1280 = fe4xBits v) : m.readFe4x q = v := by
  obtain ⟨r0, r1, r2, r3, r4⟩ := MemoryState.readAt_regs_of_1280 hb ho
  rw [h] at r0 r1 r2 r3 r4
  funext i
  fin_cases i
  · exact MemoryState.readU32x8_packLanes ((fe4xBits_setWidth v).symm.trans r0).symm
  · exact MemoryState.readU32x8_packLanes ((fe4xBits_extract_256 v).symm.trans r1).symm
  · exact MemoryState.readU32x8_packLanes ((fe4xBits_extract_512 v).symm.trans r2).symm
  · exact MemoryState.readU32x8_packLanes ((fe4xBits_extract_768 v).symm.trans r3).symm
  · exact MemoryState.readU32x8_packLanes ((fe4xBits_extract_1024 v).symm.trans r4).symm

/-! ### `NafLookupTable5<CachedPoint>` -/

/-- A `NafLookupTable5<CachedPoint>`'s 10240 bits, entry 0 lowest. -/
def naf5Bits (T : Fin 8 → Fe2625x4) : BitVec 10240 :=
  fe4xBits (T 7) ++
    (fe4xBits (T 6) ++
      (fe4xBits (T 5) ++
        (fe4xBits (T 4) ++
          (fe4xBits (T 3) ++ (fe4xBits (T 2) ++ (fe4xBits (T 1) ++ fe4xBits (T 0)))))))

/-- Store a `NafLookupTable5<CachedPoint>` at `p`, entry `j` at byte `160 j`. -/
def MemoryState.storeNaf5 (m : MemoryState) (p : Pointer) (T : Fin 8 → Fe2625x4) : MemoryState :=
  m.storeAt p (naf5Bits T)

/-- Entry `j` of the table at `p`. -/
def MemoryState.readNaf5 (m : MemoryState) (p : Pointer) (j : Fin 8) : Fe2625x4 :=
  m.readFe4x (p.add (BitVec.ofNat 64 (160 * j)))

/-- The table at `p` fits, and its offsets do not wrap. -/
abbrev MemoryState.Naf5Fit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 1280 ≤ 2 ^ 64 ∧ Fits m p 10240

theorem extract_append8 (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 1280) :
    (a7 ++ (a6 ++ (a5 ++ (a4 ++ (a3 ++ (a2 ++ (a1 ++ a0))))))).extractLsb' 0 1280 = a0 ∧
      (a7 ++ (a6 ++ (a5 ++ (a4 ++ (a3 ++ (a2 ++ (a1 ++ a0))))))).extractLsb' 1280 1280 = a1 ∧
      (a7 ++ (a6 ++ (a5 ++ (a4 ++ (a3 ++ (a2 ++ (a1 ++ a0))))))).extractLsb' 2560 1280 = a2 ∧
      (a7 ++ (a6 ++ (a5 ++ (a4 ++ (a3 ++ (a2 ++ (a1 ++ a0))))))).extractLsb' 3840 1280 = a3 ∧
      (a7 ++ (a6 ++ (a5 ++ (a4 ++ (a3 ++ (a2 ++ (a1 ++ a0))))))).extractLsb' 5120 1280 = a4 ∧
      (a7 ++ (a6 ++ (a5 ++ (a4 ++ (a3 ++ (a2 ++ (a1 ++ a0))))))).extractLsb' 6400 1280 = a5 ∧
      (a7 ++ (a6 ++ (a5 ++ (a4 ++ (a3 ++ (a2 ++ (a1 ++ a0))))))).extractLsb' 7680 1280 = a6 ∧
      (a7 ++ (a6 ++ (a5 ++ (a4 ++ (a3 ++ (a2 ++ (a1 ++ a0))))))).extractLsb' 8960 1280 = a7 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- An entry's offset. -/
theorem Naf5.entry_offset {p : Pointer} (ho : p.offset.toNat + 1280 ≤ 2 ^ 64) (j : Fin 8) :
    (p.add (BitVec.ofNat 64 (160 * j))).offset.toNat = p.offset.toNat + 160 * j := by
  have := j.isLt
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : 160 * (j : ℕ) < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]

/-- An entry of a table that fits: its 1280 bits. -/
theorem MemoryState.Naf5Fit.fits_entry {m : MemoryState} {p : Pointer} (h : m.Naf5Fit p)
    (j : Fin 8) : Fits m (p.add (BitVec.ofNat 64 (160 * j))) 1280 := by
  have := j.isLt
  refine Fits.add_of_le ?_ ?_ h.2
  · simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  · simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega

/-- An entry of a table that fits: its registers. -/
theorem MemoryState.Naf5Fit.entry {m : MemoryState} {p : Pointer} (h : m.Naf5Fit p) (j : Fin 8) :
    m.Fe4xFit (p.add (BitVec.ofNat 64 (160 * j))) := by
  have := j.isLt
  exact
    MemoryState.Fe4xFit.of_fits (h.fits_entry j)
      (by
        rw [Naf5.entry_offset h.1]; omega)

/-- A stored table read back. -/
theorem MemoryState.readNaf5_storeNaf5 {m : MemoryState} {p : Pointer} {T : Fin 8 → Fe2625x4}
    (h : Room m p 10240) (ho : p.offset.toNat + 1280 ≤ 2 ^ 64) :
    (m.storeNaf5 p T).readNaf5 p = T := by
  funext j
  have := j.isLt
  have hf : Fits (m.storeNaf5 p T) p 10240 := Fits.storeAt_self h
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 (160 * j)) := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  have hk : (BitVec.ofNat 64 (160 * j)).toNat = 160 * j := by
    simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]
  refine
    MemoryState.readFe4x_of_readAt (Fits.add_of_le hov (by omega) hf).inBounds
      (by
        rw [Naf5.entry_offset ho]; omega)
      ?_
  rw [MemoryState.readAt_add_of_readAt hf.inBounds hov (by omega)
      (MemoryState.readAt_storeAt_self h.inBounds _),
    hk]
  obtain ⟨e0, e1, e2, e3, e4, e5, e6, e7⟩ :=
    extract_append8 (fe4xBits (T 0)) (fe4xBits (T 1)) (fe4xBits (T 2)) (fe4xBits (T 3))
      (fe4xBits (T 4)) (fe4xBits (T 5)) (fe4xBits (T 6)) (fe4xBits (T 7))
  fin_cases j
  exacts [e0, e1, e2, e3, e4, e5, e6, e7]

end

/-! ### Naming a stored field element -/

public meta section

open Lean Elab Tactic Meta in
/-- `name_fe4 x`: the registers the latest `storeFe4x` of the current state writes become `x`, with
`hx : x = …`, in the state and the facts. -/
elab "name_fe4 " x:ident : tactic =>
  withMainContext do
    let (g, goal) ← Tactic.getGoalType
    let S ←
      try
        pure (← Tactic.getRunBodyFrom goal).state
      catch _ =>
        pure (← Tactic.getFuncRunFromGoal goal).state
    let hS? ←
      if S.isFVar then
        Tactic.findEqWithLhs? S m!"`{S} = _`"
      else
        pure none
    let rhs ←
      match hS? with
      | some hS =>
        do
          let some (_, _, rhs) := (← instantiateMVars (← hS.getType)).eq? | throwError "no equation"
          pure rhs
      | none =>
        pure S
    -- `find?` is pre-order: the outermost, i.e. latest, store
    let some st :=
      rhs.find? fun e => e.isAppOfArity ``MemoryState.storeFe4x 3 && !(e.getArg! 2).isFVar
      | throwError "`name_fe4`: no `storeFe4x` of an unnamed value in{indentExpr rhs}"
    let v := st.getArg! 2
    let (_, g) ←
      g.withContext do
          let hyps ←
            (← getLCtx).foldlM (init := #[]) fun hs d => do
                if d.isImplementationDetail then
                  return hs
                return if ((← instantiateMVars d.type).find? (· == v)).isSome then hs.push d.fvarId
                  else hs
          Tactic.generalizeOpaque g (hyps := hyps) v x.getId
              #[⟨x.getId.appendBefore "h", (mkEq · v), ← mkEqRefl v⟩]
    replaceMainGoal [g]

end

end MLIR
