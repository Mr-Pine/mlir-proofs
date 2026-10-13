module

public import MLIR.Run.Tactic
public import Agave.Common.ExtendedPoint
public import Agave.Common.Point
public import Agave.Avx2.ExtendedPoint_double_impl_double
public import Agave.Avx2.ExtendedPoint_Add_CachedPoint_add_impl_add
public import Agave.Avx2.CachedPoint_From_ExtendedPoint_from_impl_from
public import Agave.Avx2.Mlir.NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from
import Agave.Serial.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

open Fe2625x4
open Serial.NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from (entry_off entry_noOverflow
  fits_table)

/-! ## Specification -/

@[expose] public section

/-- `FieldElement2625x4::new(x₀, x₁, x₂, x₃)`: the limbs packed, then reduced. -/
def _root_.MLIR.Agave.Fe2625x4.new (x₀ x₁ x₂ x₃ : Fin 5 → BitVec 64) : Fe2625x4 :=
  reduce (pack x₀ x₁ x₂ x₃)

namespace NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from

/-- `Ai[i]`: `Ai[0] = CachedPoint::from(A)`, `Ai[i + 1] = (&A2 + &Ai[i]).into()`. -/
def Ai (A A2 : Fe2625x4) : Nat → Fe2625x4
  | 0 => CachedPoint_From_ExtendedPoint_from_impl_from.spec A
  | i + 1 =>
    CachedPoint_From_ExtendedPoint_from_impl_from.spec
      (ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2 (Ai A A2 i))

/-- `NafLookupTable5::<CachedPoint>::from(&P)`: `A, 3A, …, 15A` as `CachedPoint`s, for
`A = ExtendedPoint::from(P)`, `A2 = A.double()`. -/
def spec (P : EdwardsPoint) : Fin 8 → Fe2625x4 :=
  let A := Fe2625x4.new P.X P.Y P.Z P.T
  let A2 := ExtendedPoint_double_impl_double.spec A
  fun i => Ai A A2 i

end NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `Ai[i + 1] = (&A2 + &Ai[i]).into();`: `Ai[i]` at entry `e` (offset bound `ho`) with read fact
`hr` and fit `hf`, the sum named `x`, its cached form `c`. -/
local macro "naf_iter " e:term:max ho:term:max ho':term:max hr:ident hf:ident x:ident c:ident :
    tactic =>
  `(tactic|
    ( step_pure
      step_pure
      have hv16_fe4 := MemoryState.Fe4xRoom.of_room hroom_v16 (by simp [hv16_off])
      have hq := MemoryState.Fe4xFit.of_fits $hf $ho
      have hqr := MemoryState.readFe4x_of_readAt (q := $e) ($hf).inBounds $ho' $hr
      step_call using
        (add_call_of_read (hout := hv16_fe4)
          (hp := ⟨by rw [hv18_off]; decide, hA2f0, hA2f1, hA2f2, hA2f3, hA2f4⟩) (hq := hq)
          (hr := hqr))
        consuming hq hqr
      name_fe4 $x
      have hv17_fe4 := MemoryState.Fe4xRoom.of_room hroom_v17 (by simp [hv17_off])
      step_call using
        (CachedPoint_From_ExtendedPoint_from_impl_from.call_eq (hout := hv17_fe4)
          (hx := hv16_fe4))
        consuming hv16_fe4
      name_fe4 $c
      have hb := (MemoryState.readAt_fe4xBits hv17_fe4).trans (congrArg fe4xBits hread_v17_readFe4x)
      have hf17 := hv17_fe4.fits
      clear hv17_fe4
      step_pure
      step_memcpy consuming hb hf17
      step_pure))

/-- An odd limb's low bits plus the high half of `c9 · 19`, zero: no overflow. -/
theorem c9_hi_add_ok' (x y : BitVec 32) :
    (y &&& 33554431#32).saddOverflow
          (BitVec.extractLsb' 32 32 ((0#32 ++ (x >>> 25 &&& 127#32)) * 19#64)) =
        false ∧
      (y &&& 33554431#32).uaddOverflow
          (BitVec.extractLsb' 32 32 ((0#32 ++ (x >>> 25 &&& 127#32)) * 19#64)) =
        false := by
  constructor <;> bv_decide

attribute [local simp] carry25_add_ok carry26_add_ok zero_add_ok c9_mul_ok c9_add_ok c9_hi_add_ok
  c9_hi_add_ok'

/-- `self + other` with `other`'s registers given by a read fact. -/
theorem add_call_of_read (out p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.Fe4xRoom out) (hp : s.mem.Fe4xFit p) (hq : s.mem.Fe4xFit q) {c : Fe2625x4}
    (hr : s.mem.readFe4x q = c) :
    ExtendedPoint_Add_CachedPoint_add_impl_add.call
        (ExtendedPoint_Add_CachedPoint_add_impl_add.args (.value out) (.value p) (.value q)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem :=
              s.mem.storeFe4x out
                (ExtendedPoint_Add_CachedPoint_add_impl_add.spec (s.mem.readFe4x p) c) }) := by
  rw [← hr]
  exact ExtendedPoint_Add_CachedPoint_add_impl_add.call_eq out p q s hwf hout hp hq

/-- A table entry's offset bound, as `readFe4x_of_readAt` takes it. -/
theorem entry_off' {t : Pointer} (ho : t.offset = 0) {k : BitVec 64} (hk : k.toNat ≤ 1120) :
    (t.add k).offset.toNat + 128 < 2 ^ 64 := by
  simp [Pointer.add, ho]; omega

/-- `new`'s packed register of limbs `x, y, z, t` as the lifted code computes it. -/
def packReg (x y z t : BitVec 64) : Vector (BitVec 32) 8 :=
  #v[x.setWidth 32 &&& 67108863#32, y.setWidth 32 &&& 67108863#32, (x >>> 26).setWidth 32,
    (y >>> 26).setWidth 32, z.setWidth 32 &&& 67108863#32, t.setWidth 32 &&& 67108863#32,
    (z >>> 26).setWidth 32, (t >>> 26).setWidth 32]

/-- `reduce`'s register `i > 0` as the lifted code computes it, `u` register `i - 1`. -/
def redReg (v u : Vector (BitVec 32) 8) : Vector (BitVec 32) 8 :=
  #v[u[2] >>> 25 + (v[0] &&& 67108863#32), u[3] >>> 25 + (v[1] &&& 67108863#32),
    v[0] >>> 26 + (v[2] &&& 33554431#32), v[1] >>> 26 + (v[3] &&& 33554431#32),
    u[6] >>> 25 + (v[4] &&& 67108863#32), u[7] >>> 25 + (v[5] &&& 67108863#32),
    v[4] >>> 26 + (v[6] &&& 33554431#32), v[5] >>> 26 + (v[7] &&& 33554431#32)]

/-- `c9 · 19`'s half `k` for carry `c`, as the code computes it in 64 bits. -/
def c19 (k : Nat) (c : BitVec 32) : BitVec 32 :=
  BitVec.extractLsb' k 32 ((0#32 ++ (c >>> 25 &&& 127#32)) * 19#64)

/-- `reduce`'s register 0 of a packed element as the lifted code computes it, `u` register 4: the
even limbs' carries are zero. -/
def red0Reg (v u : Vector (BitVec 32) 8) : Vector (BitVec 32) 8 :=
  #v[(v[0] &&& 67108863#32) + c19 0 u[2], (v[1] &&& 67108863#32) + c19 0 u[3],
    (v[2] &&& 33554431#32) + c19 32 u[2], (v[3] &&& 33554431#32) + c19 32 u[3],
    (v[4] &&& 67108863#32) + c19 0 u[6], (v[5] &&& 67108863#32) + c19 0 u[7],
    (v[6] &&& 33554431#32) + c19 32 u[6], (v[7] &&& 33554431#32) + c19 32 u[7]]

theorem pack_reg (X Y Z T : Fin 5 → BitVec 64) (i : Fin 5) :
    pack X Y Z T i = packReg (X i) (Y i) (Z i) (T i) := by
  have hlo (x : BitVec 64) : (x &&& 67108863#64).setWidth 32 = x.setWidth 32 &&& 67108863#32 := by
    bv_decide
  simp only [pack, packReg, hlo]
  apply Vector.ext; intro j hj
  simp only [Vector.getElem_ofFn]
  obtain rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl :
    j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 ∨ j = 4 ∨ j = 5 ∨ j = 6 ∨ j = 7 := by omega
  all_goals rfl

theorem red_reg (v u : Vector (BitVec 32) 8) : reduceReg v (carries u) = redReg v u := by
  apply Vector.ext; intro j hj
  obtain rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl :
    j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 ∨ j = 4 ∨ j = 5 ∨ j = 6 ∨ j = 7 := by omega
  all_goals exact BitVec.add_comm _ _

theorem red0_reg (x y z t : BitVec 64) (u : Vector (BitVec 32) 8) :
    reduceReg (packReg x y z t) (fun e => carries u e * 19) = red0Reg (packReg x y z t) u := by
  apply Vector.ext; intro j hj
  obtain rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl :
    j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 ∨ j = 4 ∨ j = 5 ∨ j = 6 ∨ j = 7 := by omega
  all_goals
    simp only [reduceReg, red0Reg, carries, packReg, c19, Matrix.cons_val, reduceGetElemLit]
    bv_decide

theorem new_eq (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 z0 z1 z2 z3 z4 t0 t1 t2 t3 t4 : BitVec 64) :
    Fe2625x4.new ![x0, x1, x2, x3, x4] ![y0, y1, y2, y3, y4] ![z0, z1, z2, z3, z4]
        ![t0, t1, t2, t3, t4] =
      ![red0Reg (packReg x0 y0 z0 t0) (packReg x4 y4 z4 t4),
        redReg (packReg x1 y1 z1 t1) (packReg x0 y0 z0 t0),
        redReg (packReg x2 y2 z2 t2) (packReg x1 y1 z1 t1),
        redReg (packReg x3 y3 z3 t3) (packReg x2 y2 z2 t2),
        redReg (packReg x4 y4 z4 t4) (packReg x3 y3 z3 t3)] := by
  simp only [Fe2625x4.new, reduce, pack_reg, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val, red0_reg, red_reg]

/-- A table's 10240 bits, read entry by entry. -/
theorem readAt_table {m : MemoryState} {t : Pointer} {c0 c1 c2 c3 c4 c5 c6 c7 : Fe2625x4}
    (ho : t.offset = 0) (hb : InBounds m t 10240) (h0 : m.readAt t 1280 = fe4xBits c0)
    (h1 : m.readAt (t.add 160#64) 1280 = fe4xBits c1)
    (h2 : m.readAt (t.add 320#64) 1280 = fe4xBits c2)
    (h3 : m.readAt (t.add 480#64) 1280 = fe4xBits c3)
    (h4 : m.readAt (t.add 640#64) 1280 = fe4xBits c4)
    (h5 : m.readAt (t.add 800#64) 1280 = fe4xBits c5)
    (h6 : m.readAt (t.add 960#64) 1280 = fe4xBits c6)
    (h7 : m.readAt (t.add 1120#64) 1280 = fe4xBits c7) :
    m.readAt t 10240 = naf5Bits ![c0, c1, c2, c3, c4, c5, c6, c7] := by
  have a1 :=
    readAt_append (v := 1280) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) h0 h1
  have a2 :=
    readAt_append (v := 2560) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a1 h2
  have a3 :=
    readAt_append (v := 3840) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a2 h3
  have a4 :=
    readAt_append (v := 5120) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a3 h4
  have a5 :=
    readAt_append (v := 6400) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a4 h5
  have a6 :=
    readAt_append (v := 7680) (w := 1280) (hb.mono (by decide)) (entry_noOverflow ho (by decide))
      (by decide) a5 h6
  exact readAt_append (v := 8960) (w := 1280) hb (entry_noOverflow ho (by decide)) (by decide) a6 h7

/-- A field element's limbs at byte `k` of a point, as the code loads them. -/
theorem readLimbs_add {m : MemoryState} {p : Pointer} (k : Nat) :
    m.readLimbs (p.add (BitVec.ofNat 64 k)) =
      ![m.readAt (p.add (BitVec.ofNat 64 k)) 64, m.readAt (p.add (BitVec.ofNat 64 (k + 8))) 64,
        m.readAt (p.add (BitVec.ofNat 64 (k + 16))) 64,
        m.readAt (p.add (BitVec.ofNat 64 (k + 24))) 64,
        m.readAt (p.add (BitVec.ofNat 64 (k + 32))) 64] := by
  funext i
  fin_cases i <;> simp [MemoryState.readLimbs, Pointer.add_add, BitVec.ofNat_add]

/-- A field element's limbs at byte 0 of a point, as the code loads them. -/
theorem readLimbs_zero {m : MemoryState} {p : Pointer} :
    m.readLimbs p =
      ![m.readAt p 64, m.readAt (p.add 8#64) 64, m.readAt (p.add 16#64) 64,
        m.readAt (p.add 24#64) 64, m.readAt (p.add 32#64) 64] := by
  funext i
  fin_cases i <;> rfl

/-- The `EdwardsPoint` at `p` as its loads. -/
theorem readEdwards_eq {m : MemoryState} {p : Pointer} :
    m.readEdwards p =
      ⟨![m.readAt p 64, m.readAt (p.add 8#64) 64, m.readAt (p.add 16#64) 64,
          m.readAt (p.add 24#64) 64, m.readAt (p.add 32#64) 64],
        ![m.readAt (p.add 40#64) 64, m.readAt (p.add 48#64) 64, m.readAt (p.add 56#64) 64,
          m.readAt (p.add 64#64) 64, m.readAt (p.add 72#64) 64],
        ![m.readAt (p.add 80#64) 64, m.readAt (p.add 88#64) 64, m.readAt (p.add 96#64) 64,
          m.readAt (p.add 104#64) 64, m.readAt (p.add 112#64) 64],
        ![m.readAt (p.add 120#64) 64, m.readAt (p.add 128#64) 64, m.readAt (p.add 136#64) 64,
          m.readAt (p.add 144#64) 64, m.readAt (p.add 152#64) 64]⟩ := by
  rw [MemoryState.readEdwards, readLimbs_zero, readLimbs_add 40, readLimbs_add 80,
    readLimbs_add 120]

/-- A limb of a point's 1280 bits that fit. -/
theorem fits_limb {m : MemoryState} {p : Pointer} (h : Fits m p 1280)
    (ho : p.offset.toNat + 160 ≤ 2 ^ 64) (k : Nat) (hk : k ≤ 152) :
    Fits m (p.add (BitVec.ofNat 64 k)) 64 :=
  Fits.add_of_le
    (Pointer.not_uaddOverflow_of_point ho
      (by
        simp; omega))
    (by
      simp; omega)
    h

namespace NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from

theorem spec_eq (P : EdwardsPoint) :
    spec P = fun i : Fin 8 =>
      Ai (Fe2625x4.new P.X P.Y P.Z P.T)
        (ExtendedPoint_double_impl_double.spec (Fe2625x4.new P.X P.Y P.Z P.T)) i :=
  rfl

/-- The entries the steps name, as `Ai`. -/
theorem table_eq {A A2 c0 c1 c2 c3 c4 c5 c6 c7 s1 s2 s3 s4 s5 s6 s7 : Fe2625x4}
    (h0 : c0 = CachedPoint_From_ExtendedPoint_from_impl_from.spec A)
    (g1 : s1 = ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2 c0)
    (h1 : c1 = CachedPoint_From_ExtendedPoint_from_impl_from.spec s1)
    (g2 : s2 = ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2 c1)
    (h2 : c2 = CachedPoint_From_ExtendedPoint_from_impl_from.spec s2)
    (g3 : s3 = ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2 c2)
    (h3 : c3 = CachedPoint_From_ExtendedPoint_from_impl_from.spec s3)
    (g4 : s4 = ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2 c3)
    (h4 : c4 = CachedPoint_From_ExtendedPoint_from_impl_from.spec s4)
    (g5 : s5 = ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2 c4)
    (h5 : c5 = CachedPoint_From_ExtendedPoint_from_impl_from.spec s5)
    (g6 : s6 = ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2 c5)
    (h6 : c6 = CachedPoint_From_ExtendedPoint_from_impl_from.spec s6)
    (g7 : s7 = ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2 c6)
    (h7 : c7 = CachedPoint_From_ExtendedPoint_from_impl_from.spec s7) :
    ![c0, c1, c2, c3, c4, c5, c6, c7] = fun i : Fin 8 => Ai A A2 i := by
  subst h0 g1 h1 g2 h2 g3 h3 g4 h4 g5 h5 g6 h6 g7 h7
  funext i
  fin_cases i <;> rfl

-- about 250 steps over 6 slots and 16 calls: past the default heartbeats
set_option maxHeartbeats 4000000 in
attribute [-mlir_operation] zipWith_eq_ofFn in
/-- `NafLookupTable5::<CachedPoint>::from(&point)` stores `spec point` at `out`, the `sret` slot;
`point` is read before `out` is written. Its six slots and its callees' frames are freed again:
the counter moves on by 68 blocks. -/
public theorem call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : Room s.mem out 10240) (ha : s.mem.PointFit a) :
    NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from.call
        (args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 68⟩,
            mem := s.mem.storeNaf5 out (spec (s.mem.readEdwards a)) }) := by
  have hao := ha.1
  have hfa := MemoryState.PointFit.fits ha
  have hf0 := hfa.mono (by decide : 64 ≤ 1280)
  have hf40 := fits_limb hfa hao 40 (by decide)
  have hf80 := fits_limb hfa hao 80 (by decide)
  have hf120 := fits_limb hfa hao 120 (by decide)
  have hf8 := fits_limb hfa hao 8 (by decide)
  have hf48 := fits_limb hfa hao 48 (by decide)
  have hf88 := fits_limb hfa hao 88 (by decide)
  have hf128 := fits_limb hfa hao 128 (by decide)
  have hf16 := fits_limb hfa hao 16 (by decide)
  have hf56 := fits_limb hfa hao 56 (by decide)
  have hf96 := fits_limb hfa hao 96 (by decide)
  have hf136 := fits_limb hfa hao 136 (by decide)
  have hf24 := fits_limb hfa hao 24 (by decide)
  have hf64 := fits_limb hfa hao 64 (by decide)
  have hf104 := fits_limb hfa hao 104 (by decide)
  have hf144 := fits_limb hfa hao 144 (by decide)
  have hf32 := fits_limb hfa hao 32 (by decide)
  have hf72 := fits_limb hfa hao 72 (by decide)
  have hf112 := fits_limb hfa hao 112 (by decide)
  have hf152 := fits_limb hfa hao 152 (by decide)
  clear ha
  func_init
  block_init
  iterate 16 step_pure [expandZipWith]
  iterate 6 step_alloca
  iterate 3 step_pure [expandZipWith]
  step_load with x0 consuming hf0
  step_load with y0 consuming hf40
  step_load with z0 consuming hf80
  step_load with t0 consuming hf120
  iterate 4 step_pure [expandZipWith]
  iterate 4 step_pure [expandZipWith]
  step_pure [expandZipWith]
  iterate 4 step_pure [expandZipWith]
  step_pure [expandZipWith]
  step_pure [expandZipWith]
  step_pure [expandZipWith] with v0
  step_pure [expandZipWith]
  step_load with x1 consuming hf8
  step_pure [expandZipWith]
  step_load with y1 consuming hf48
  step_pure [expandZipWith]
  step_load with z1 consuming hf88
  step_pure [expandZipWith]
  step_load with t1 consuming hf128
  iterate 15 step_pure [expandZipWith]
  step_pure [expandZipWith] with v1
  step_pure [expandZipWith]
  step_load with x2 consuming hf16
  step_pure [expandZipWith]
  step_load with y2 consuming hf56
  step_pure [expandZipWith]
  step_load with z2 consuming hf96
  step_pure [expandZipWith]
  step_load with t2 consuming hf136
  iterate 15 step_pure [expandZipWith]
  step_pure [expandZipWith] with v2
  step_pure [expandZipWith]
  step_load with x3 consuming hf24
  step_pure [expandZipWith]
  step_load with y3 consuming hf64
  step_pure [expandZipWith]
  step_load with z3 consuming hf104
  step_pure [expandZipWith]
  step_load with t3 consuming hf144
  iterate 15 step_pure [expandZipWith]
  step_pure [expandZipWith] with v3
  step_pure [expandZipWith]
  step_load with x4 consuming hf32
  step_pure [expandZipWith]
  step_load with y4 consuming hf72
  step_pure [expandZipWith]
  step_load with z4 consuming hf112
  step_pure [expandZipWith]
  step_load with t4 consuming hf152
  iterate 15 step_pure [expandZipWith]
  step_pure [expandZipWith] with v4
  -- FieldElement2625x4(buf).reduce()
  iterate 5 step_pure [expandZipWith]
  step_pure [expandZipWith] with w1
  iterate 3 step_pure [expandZipWith]
  step_pure [expandZipWith] with w2
  iterate 3 step_pure [expandZipWith]
  step_pure [expandZipWith] with w3
  iterate 3 step_pure [expandZipWith]
  step_pure [expandZipWith] with w4
  iterate 6 step_pure [expandZipWith]
  step_pure [expandZipWith] with w0
  step_store
  iterate 4
    step_pure [expandZipWith]
    step_store
  rw [MemoryState.storeFe4x_eq] at hS
  -- let A = ExtendedPoint::from(*point);
  change v0 = packReg x0 y0 z0 t0 at hv0
  change v1 = packReg x1 y1 z1 t1 at hv1
  change v2 = packReg x2 y2 z2 t2 at hv2
  change v3 = packReg x3 y3 z3 t3 at hv3
  change v4 = packReg x4 y4 z4 t4 at hv4
  change w0 = red0Reg v0 v4 at hw0
  change w1 = redReg v1 v0 at hw1
  change w2 = redReg v2 v1 at hw2
  change w3 = redReg v3 v2 at hw3
  change w4 = redReg v4 v3 at hw4
  subst hw0 hw1 hw2 hw3 hw4 hv0 hv1 hv2 hv3 hv4
  rw [← new_eq] at hS
  name_fe4 A
  -- let mut Ai = [CachedPoint::from(A); 8];
  step_pure
  have hv19_fe4 := MemoryState.Fe4xRoom.of_room hroom_v19 (by simp [hv19_off])
  step_call using
    (CachedPoint_From_ExtendedPoint_from_impl_from.call_eq (hout := hv19_fe4) (hx :=
      ⟨by
        rw [hv21_off]; decide, hfits_v21, hfits_v21_32, hfits_v21_64, hfits_v21_96, hfits_v21_128⟩))
  name_fe4 c0
  clear hread_v21 hread_v21_32 hread_v21_64 hread_v21_96 hread_v21_128
  have hb := (MemoryState.readAt_fe4xBits hv19_fe4).trans (congrArg fe4xBits hread_v19_readFe4x)
  have hf := hv19_fe4.fits
  step_memcpy consuming hv19_fe4
  iterate 6
    step_pure
    step_memcpy
  step_pure
  step_memcpy consuming hb hf
  step_pure
  -- let A2 = A.double();
  step_pure
  have hv18_fe4 := MemoryState.Fe4xRoom.of_room hroom_v18 (by simp [hv18_off])
  step_call using
    (ExtendedPoint_double_impl_double.call_eq (hout := hv18_fe4) (hx :=
      ⟨by
        rw [hv21_off]; decide, hfits_v21, hfits_v21_32, hfits_v21_64, hfits_v21_96, hfits_v21_128⟩))
  name_fe4 A2
  obtain ⟨-, hA2f0, hA2f1, hA2f2, hA2f3, hA2f4⟩ := hv18_fe4
  clear hread_v19_readFe4x hread_v19_readAt hread_v19_32 hread_v19_64 hread_v19_96 hread_v19_128
    hread_v19
  -- for i in 0..7 { Ai[i + 1] = (&A2 + &Ai[i]).into(); }
  naf_iter v20 (by simp [hv20_off]) (by simp [hv20_off]) hread_v20 hfits_v20 s1 c1
  naf_iter (v20.add 160#64) (entry_off hv20_off (by decide)) (entry_off' hv20_off (by decide))
    hread_v20_160 hfits_v20_160 s2 c2
  naf_iter (v20.add 320#64) (entry_off hv20_off (by decide)) (entry_off' hv20_off (by decide))
    hread_v20_320 hfits_v20_320 s3 c3
  naf_iter (v20.add 480#64) (entry_off hv20_off (by decide)) (entry_off' hv20_off (by decide))
    hread_v20_480 hfits_v20_480 s4 c4
  naf_iter (v20.add 640#64) (entry_off hv20_off (by decide)) (entry_off' hv20_off (by decide))
    hread_v20_640 hfits_v20_640 s5 c5
  naf_iter (v20.add 800#64) (entry_off hv20_off (by decide)) (entry_off' hv20_off (by decide))
    hread_v20_800 hfits_v20_800 s6 c6
  naf_iter (v20.add 960#64) (entry_off hv20_off (by decide)) (entry_off' hv20_off (by decide))
    hread_v20_960 hfits_v20_960 s7 c7
  -- NafLookupTable5(Ai)
  have hfits_tbl :=
    fits_table hv20_off hfits_v20 hfits_v20_160 hfits_v20_320 hfits_v20_480 hfits_v20_640
      hfits_v20_800 hfits_v20_960 hfits_v20_1120
  have hread_tbl :=
    readAt_table hv20_off hfits_tbl.inBounds hread_v20 hread_v20_160 hread_v20_320 hread_v20_480
      hread_v20_640 hread_v20_800 hread_v20_960 hread_v20_1120
  clear hread_v20 hread_v20_160 hread_v20_320 hread_v20_480 hread_v20_640 hread_v20_800
    hread_v20_960 hread_v20_1120 hfits_v20 hfits_v20_160 hfits_v20_320 hfits_v20_480 hfits_v20_640
    hfits_v20_800 hfits_v20_960 hfits_v20_1120
  step_memcpy consuming hread_tbl hfits_tbl
  step_pure
  finish_block
  subst hS
  erase_frame
  rw [MemoryState.storeNaf5, readEdwards_eq, spec_eq,
    table_eq hc0 hs1 hc1 hs2 hc2 hs3 hc3 hs4 hc4 hs5 hc5 hs6 hc6 hs7 hc7]
  subst hx0 hy0 hz0 ht0 hx1 hy1 hz1 ht1 hx2 hy2 hz2 ht2 hx3 hy3 hz3 ht3 hx4 hy4 hz4 ht4 hA hA2
  rfl

end NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from

end Proof

end MLIR.Agave.Avx2
