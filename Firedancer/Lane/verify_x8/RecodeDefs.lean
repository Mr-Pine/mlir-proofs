module

public import Firedancer.Lane.verify_x8.ScalarsDefs
import Std.Tactic.BVDecide

/-! `recode_run`'s pieces: the registers and the state of the loops at `^bb80` and `^bb81`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

@[expose] public section

/-- `^bb80`'s registers at lane `j`. -/
abbrev EnvB (c : Call) (E : ⟪Γ⟫) (j : Nat) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64,
    507525298899#64, 15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64,
    0#64], %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value
    15#64, %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value
    768#32, %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64), %39 :=
    Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32), %45 := Ty.wrap
    (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32, %53 := PoisonOr.value
    0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64, %69 :=
    PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 := PoisonOr.value 3#64, %74 :=
    PoisonOr.value 8#32, %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 :=
    PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %85 :=
    PoisonOr.value 64#64, %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64, %92 :=
    PoisonOr.value 960#64, %93 := PoisonOr.value 640#64, %94 := Ty.wrap (Vector.replicate 8 0#64),
    %95 := Ty.wrap (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8
    2251799813685247#64), %99 := PoisonOr.value 576#64, %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64), %106 :=
    Ty.wrap (Vector.replicate 8 9007199254740988#64), %108 := Ty.wrap (Vector.replicate 8
    4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64), %110 := Ty.wrap
    (Vector.replicate 8 2251799813685229#64), %114 := Vector.replicate 16 PoisonOr.poison, %115 :=
    Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32,
    7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate
    16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16
    32#32), %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value
    (c.s.slot 3), %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5), %141 :=
    PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7), %143 := PoisonOr.value
    (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9), %145 := PoisonOr.value (c.s.slot 10), %146 :=
    PoisonOr.value (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value
    (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 :=
    PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value
    (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask), rir_reg% hty 2115 := PoisonOr.value ((c.s.slot
    28).add 64#64), rir_reg% hty 2118 := PoisonOr.value ((c.s.slot 28).add 128#64),
    rir_reg% hty 2121 := PoisonOr.value ((c.s.slot 28).add 192#64), rir_reg% hty 2124 :=
    PoisonOr.value ((c.s.slot 28).add 256#64), rir_reg% hty 2142 := PoisonOr.value ((c.s.slot
    28).add 960#64), rir_reg% hty 2158 := PoisonOr.value ((c.s.slot 28).add 1024#64),
    rir_reg% hty 2160 := PoisonOr.value ((c.s.slot 28).add 1088#64), rir_reg% hty 2162 :=
    PoisonOr.value ((c.s.slot 28).add 1152#64), rir_reg% hty 2164 := PoisonOr.value ((c.s.slot
    28).add 1216#64), rir_reg% hty 3760 :=
    PoisonOr.value (BitVec.ofNat 64 j)]

/-- `^bb81`'s registers at lane `j`, digit `4 t`: the constants the loop reads, `k[j]`, `w` and
the carry. -/
abbrev EnvK (c : Call) (E : ⟪Γ⟫) (j : Fin 8) (t : Nat) : Prop :=
  E ⊨ [%33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32, %35 := PoisonOr.value 15#8,
    %68 := PoisonOr.value 4#64, %71 := PoisonOr.value 4#32, %74 := PoisonOr.value 8#32,
    %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %137 := PoisonOr.value (c.s.slot 2),
    rir_reg% hty 3761 := PoisonOr.value ((c.s.slot 26).add (BitVec.ofNat 64 (j.val * 32))),
    rir_reg% hty 3762 := PoisonOr.value (BitVec.ofNat 64 (4 * t)),
    rir_reg% hty 3763 := PoisonOr.value (carry4 (c.kS j) (4 * t))]

/-- The registers `^bb82` reads at lane `j`. -/
abbrev Env82 (c : Call) (E : ⟪Γ⟫) (j : Nat) : Prop :=
  E ⊨ [%26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison,
    %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32, %32 := PoisonOr.value 256#32,
    %69 := PoisonOr.value 8#64, %74 := PoisonOr.value 8#32, %81 := PoisonOr.value 128#32,
    %88 := PoisonOr.value 1#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %137 := PoisonOr.value (c.s.slot 2),
    %162 := PoisonOr.value (c.s.slot 27),
    rir_reg% hty 3760 := PoisonOr.value (BitVec.ofNat 64 j)]

/-- `p`, kept out of the steps' sight: the registers a block passes on untouched, about its entry
env. -/
structure Hidden (p : Prop) : Prop where
  out : p

/-- One digit of `fd_ed25519_lane_recode4` as compiled, carry `C ≤ 1`, nibble `x ≤ 15`: its flags
hold, and the next carry is at most `1`. -/
theorem dig4 (C x : BitVec 32) (hC : C ≤ 1#32) (hx : x ≤ 15#32) :
    C.saddOverflow x = false ∧ C.uaddOverflow x = false ∧
      (C + x).saddOverflow 8#32 = false ∧ (C + x).uaddOverflow 8#32 = false ∧
      (C + x).ssubOverflow ((C + x + 8#32) &&& 240#32) = false ∧
      ((C + x - ((C + x + 8#32) &&& 240#32)).setWidth 8).signExtend 32 =
        C + x - ((C + x + 8#32) &&& 240#32) ∧
      (C + x + 8#32) >>> 4 ≤ 1#32 := by
  bv_decide

/-- `15` is nonnegative as an `i8`. -/
theorem msb_15 : (15#8).msb = false := by decide

/-- A byte's low nibble. -/
theorem lo_le (b : BitVec 8) : BitVec.setWidth 32 b &&& 15#32 ≤ 15#32 := by bv_decide

/-- A byte's high nibble. -/
theorem hi_le (b : BitVec 8) : BitVec.setWidth 32 b >>> 4 ≤ 15#32 := by bv_decide

/-- `w >> 1` of the loop's `w = 4 t`: exact, `2 t`. -/
theorem rk_shr {t : Nat} (ht : t < 16) :
    (BitVec.ofNat 64 (4 * t)).extractLsb' 0 1 = 0#1 ∧
      BitVec.ofNat 64 (4 * t) >>> 1 = BitVec.ofNat 64 (2 * t) := by
  revert t; decide

/-- `w += 4` of the loop's `w = 4 t`, `t < 16`: no overflow. -/
theorem rk_inc {t : Nat} (ht : t < 16) :
    (BitVec.ofNat 64 (4 * t)).saddOverflow 4#64 = false ∧
      (BitVec.ofNat 64 (4 * t)).uaddOverflow 4#64 = false ∧
      BitVec.ofNat 64 (4 * t) + 4#64 = BitVec.ofNat 64 (4 * (t + 1)) := by
  revert t; decide

/-- `j++` of the lane loop, `j < 8`: no overflow. -/
theorem rj_inc {j : Nat} (hj : j < 8) :
    (BitVec.ofNat 64 j).saddOverflow 1#64 = false ∧ (BitVec.ofNat 64 j).uaddOverflow 1#64 = false ∧
      BitVec.ofNat 64 j + 1#64 = BitVec.ofNat 64 (j + 1) := by
  revert j; decide

/-- The lane loop's exit test. -/
theorem rj_exit {j : Nat} (hj : j < 8) : (BitVec.ofNat 64 (j + 1) = 8#64) ↔ j + 1 = 8 := by
  revert j; decide

/-- The loop's exit test. -/
theorem rk_exit {t : Nat} (ht : t < 16) :
    (BitVec.ofNat 64 (4 * (t + 1)) = 64#64) ↔ t + 1 = 16 := by
  revert t; decide

/-- `w | 2` of the loop's `w = 4 t`: disjoint, `4 t + 2`; then `>> 1`, exact, `2 t + 1`. -/
theorem rk_or {t : Nat} (ht : t < 16) :
    BitVec.ofNat 64 (4 * t) &&& 2#64 = 0#64 ∧
      BitVec.ofNat 64 (4 * t) ||| 2#64 = BitVec.ofNat 64 (4 * t + 2) ∧
      (BitVec.ofNat 64 (4 * t + 2)).extractLsb' 0 1 = 0#1 ∧
      BitVec.ofNat 64 (4 * t + 2) >>> 1 = BitVec.ofNat 64 (2 * t + 1) := by
  revert t; decide

/-! ### The digits -/

/-- Nibble `2 k` of `s`: byte `k`'s low half. -/
theorem nib_even (s : BitVec 256) (k : Nat) :
    nib s (2 * k) = BitVec.setWidth 32 (s.extractLsb' (8 * k) 8) &&& 15#32 := by
  rw [nib, ← BitVec.setWidth_ushiftRight_eq_extractLsb, show 4 * (2 * k) = 8 * k by omega]
  generalize s >>> (8 * k) = y
  bv_decide

/-- Nibble `2 k + 1` of `s`: byte `k`'s high half. -/
theorem nib_odd (s : BitVec 256) (k : Nat) :
    nib s (2 * k + 1) = BitVec.setWidth 32 (s.extractLsb' (8 * k) 8) >>> 4 := by
  rw [nib, ← BitVec.setWidth_ushiftRight_eq_extractLsb, show 4 * (2 * k + 1) = 8 * k + 4 by omega,
    BitVec.shiftRight_add]
  generalize s >>> (8 * k) = y
  bv_decide

/-- Digit `w` of `fd_ed25519_lane_recode4` as compiled, from its carry `C` and nibble `x`. -/
theorem dig4_spec (s : BitVec 256) (w : Nat) {C x : BitVec 32} (hC : carry4 s w = C)
    (hx : nib s w = x) :
    (C + x + 8#32) >>> 4 = carry4 s (w + 1) ∧
      BitVec.setWidth 8 (C + x - (C + x + 8#32 &&& 240#32)) = recode4 s w := by
  have h1 := carry4_le s w
  have h2 := nib_le s w
  rw [hC] at h1
  rw [hx] at h2
  have h1' : C ≤ 1#32 := BitVec.le_def.2 (by simpa using h1)
  have h2' : x ≤ 15#32 := BitVec.le_def.2 (by simpa using h2)
  simp only [carry4, recode4, hC, hx]
  constructor <;> bv_decide

/-- Byte `w` of `s`, as the code loads and widens it. -/
theorem byte_eq (s : BitVec 256) (w : Nat) :
    byte s w = BitVec.setWidth 32 (s.extractLsb' (8 * w) 8) := by
  rw [byte, ← BitVec.setWidth_ushiftRight_eq_extractLsb]
  generalize s >>> (8 * w) = y
  bv_decide

/-- One digit of `fd_ed25519_lane_recode8` as compiled, carry `C ≤ 1`, byte `x ≤ 255`, the
carry's mask `M` as `clang` narrows it: its flags hold, and the next carry is at most `1`. -/
theorem dig8 (C x M : BitVec 32) (hC : C ≤ 1#32) (hx : x ≤ 255#32)
    (hM : M = 256#32 ∨ M = 768#32 ∨ M = 65280#32) :
    C.saddOverflow x = false ∧ C.uaddOverflow x = false ∧
      (C + x).saddOverflow 128#32 = false ∧ (C + x).uaddOverflow 128#32 = false ∧
      (C + x).ssubOverflow ((C + x + 128#32) &&& M) = false ∧
      ((C + x - ((C + x + 128#32) &&& M)).setWidth 16).signExtend 32 =
        C + x - ((C + x + 128#32) &&& M) ∧
      (C + x + 128#32) >>> 8 ≤ 1#32 := by
  rcases hM with rfl | rfl | rfl <;> bv_decide

/-- A widened byte. -/
theorem zext_le (b : BitVec 8) : BitVec.setWidth 32 b ≤ 255#32 := by bv_decide

/-- Digit `w` of `fd_ed25519_lane_recode8` as compiled, from its carry `C` and byte `x`. -/
theorem dig8_spec (s : BitVec 256) (w : Nat) {C x M : BitVec 32} (hC : carry8 s w = C)
    (hx : byte s w = x) (hM : M = 256#32 ∨ M = 768#32 ∨ M = 65280#32) :
    (C + x + 128#32) >>> 8 = carry8 s (w + 1) ∧
      BitVec.setWidth 16 (C + x - (C + x + 128#32 &&& M)) = recode8 s w := by
  have h1 := carry8_le s w
  have h2 := byte_le s w
  rw [hC] at h1
  rw [hx] at h2
  have h1' : C ≤ 1#32 := BitVec.le_def.2 (by simpa using h1)
  have h2' : x ≤ 255#32 := BitVec.le_def.2 (by simpa using h2)
  simp only [carry8, recode8, hC, hx]
  rcases hM with rfl | rfl | rfl <;> constructor <;> bv_decide

/-- Digit `0` of `fd_ed25519_lane_recode8` as compiled, no carry in: its flags hold, and it is the
spec's. -/
theorem dig8_zero (s : BitVec 256) {x : BitVec 32} (hx : byte s 0 = x) :
    x.saddOverflow 128#32 = false ∧ x.uaddOverflow 128#32 = false ∧
      x.ssubOverflow ((x + 128#32) &&& 256#32) = false ∧
      ((x - ((x + 128#32) &&& 256#32)).setWidth 16).signExtend 32 = x - ((x + 128#32) &&& 256#32) ∧
      (x + 128#32) >>> 8 = carry8 s 1 ∧
      BitVec.setWidth 16 (x - (x + 128#32 &&& 256#32)) = recode8 s 0 := by
  have h2 := byte_le s 0
  rw [hx] at h2
  have h2' : x ≤ 255#32 := BitVec.le_def.2 (by simpa using h2)
  simp only [carry8, recode8, hx]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-! ### The state -/

/-- `kd[w][i]`. -/
def Call.kdPtr (c : Call) (i w : Nat) : Pointer :=
  (c.s.slot 0).add (BitVec.ofNat 64 (8 * w + i))

/-- `sd[w][i]`. -/
def Call.sdPtr (c : Call) (i w : Nat) : Pointer :=
  (c.s.slot 1).add (BitVec.ofNat 64 (2 * (8 * w + i)))

/-- `^bb80` at lane `j`: `At80`'s facts but `kd`'s and `sd`'s, which hold their columns `i < j`. -/
structure Call.Rec (c : Call) (j : Nat) (S : GlobalState) : Prop where
  base : c.Base S c.mem76
  ks : c.KS S (rows32 c.kS) (rows32 c.sS)
  a : c.PointAt S 28 c.aNeg
  r : c.PointAt S 29 c.decR.1
  kd : Room S.mem (c.s.slot 0) 4096
  sd : Room S.mem (c.s.slot 1) 4096
  kcol : ∀ i : Fin 8, i.val < j → ∀ w < 64,
    Fits S.mem (c.kdPtr i w) 8 ∧ S.mem.readAt (c.kdPtr i w) 8 = recode4 (c.kS i) w
  scol : ∀ i : Fin 8, i.val < j → ∀ w < 32,
    Fits S.mem (c.sdPtr i w) 16 ∧ S.mem.readAt (c.sdPtr i w) 16 = recode8 (c.sS i) w

/-- `kj[w]` for the digits `w < n` so far. -/
def Call.K2 (c : Call) (j : Fin 8) (n : Nat) (m : MemoryState) : Prop :=
  ∀ w < n, Fits m ((c.s.slot 2).add (BitVec.ofNat 64 w)) 8 ∧
    m.readAt ((c.s.slot 2).add (BitVec.ofNat 64 w)) 8 = recode4 (c.kS j) w

/-- A store into `kj` keeps `Rec`. -/
theorem Call.Rec.store2 {c : Call} {j : Nat} {S : GlobalState} (h : c.Rec j S) {q : Pointer}
    (hq : q.id = (c.s.slot 2).id) {w : Nat} (x : BitVec w) :
    c.Rec j { S with mem := S.mem.storeAt q x } := by
  have hb := h.base
  have ne (k : Nat) (hk : k ≠ 2) : q.id ≠ (c.s.slot k).id := by
    rw [hq]; simpa [Pointer.add] using slot_ne_slot c.s (Ne.symm hk) 0#64
  have ne' (k : Nat) (hk : k ≠ 2) (b : BitVec 64) : q.id ≠ ((c.s.slot k).add b).id := ne k hk
  have hle : c.s.alloc.nextFreeBlock ≤ q.id.id := by rw [hq]; simp
  refine ⟨hb.frameOps ((FrameOps.refl _ _).storeAt hle) hb.wf.storeAt rfl,
    ⟨h.ks.k_fits.storeAt, ?_, h.ks.s_fits.storeAt, ?_⟩, ⟨⟨h.a.fit.1, h.a.fit.2.storeAt⟩, ?_⟩,
    ⟨⟨h.r.fit.1, h.r.fit.2.storeAt⟩, ?_⟩, h.kd.storeAt, h.sd.storeAt, fun i hi w hw => ?_,
    fun i hi w hw => ?_⟩
  · rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (ne 26 (by decide))),
      h.ks.k_read]
  · rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (ne 27 (by decide))),
      h.ks.s_read]
  · dsimp only
    rw [readLanePoint_storeAt_of_id_ne (ne 28 (by decide)), h.a.read]
  · dsimp only
    rw [readLanePoint_storeAt_of_id_ne (ne 29 (by decide)), h.r.read]
  · obtain ⟨hf, hr⟩ := h.kcol i hi w hw
    exact ⟨hf.storeAt, by
      show (S.mem.storeAt q x).readAt (c.kdPtr i w) 8 = _
      rw [MemoryState.readAt_storeAt_disjoint (q := c.kdPtr i w)
        (Range.disjoint_of_id_ne (ne' 0 (by decide) _)), hr]⟩
  · obtain ⟨hf, hr⟩ := h.scol i hi w hw
    exact ⟨hf.storeAt, by
      show (S.mem.storeAt q x).readAt (c.sdPtr i w) 16 = _
      rw [MemoryState.readAt_storeAt_disjoint (q := c.sdPtr i w)
        (Range.disjoint_of_id_ne (ne' 1 (by decide) _)), hr]⟩

/-! ### Bytes of the slots -/

/-- Two slots' blocks differ. -/
theorem slot_ne (s : GlobalState) {k l : Nat} (h : k ≠ l) : (s.slot k).id ≠ (s.slot l).id := by
  simpa [Pointer.add] using slot_ne_slot s h 0#64

/-- Byte `m` of row `i` of an `[8][32]` array. -/
theorem rows32_byte (f : Fin 8 → BitVec 256) (i : Fin 8) {m : Nat} (hm : m < 32) :
    (rows32 f).extractLsb' (8 * (i.val * 32 + m)) 8 = (f i).extractLsb' (8 * m) 8 := by
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  simp only [BitVec.getLsbD_extractLsb', hk, decide_true, Bool.true_and, rows32]
  rw [BitVec.getLsbD_packLanes_lane _ (by omega)]
  simp only [Vector.getElem_ofFn, show (8 * (i.val * 32 + m) + k) / 256 = i.val by omega,
    show (8 * (i.val * 32 + m) + k) % 256 = 8 * m + k by omega]

/-- Byte `m` of `k[i]`. -/
theorem Call.KS.kbyte {c : Call} {S : GlobalState} {K Sv : BitVec 2048} (h : c.KS S K Sv)
    (hK : K = rows32 c.kS) (i : Fin 8) {m : Nat} (hm : m < 32) :
    Fits S.mem ((c.s.slot 26).add (BitVec.ofNat 64 (i.val * 32 + m))) 8 ∧
      S.mem.readAt ((c.s.slot 26).add (BitVec.ofNat 64 (i.val * 32 + m))) 8 =
        (c.kS i).extractLsb' (8 * m) 8 := by
  obtain ⟨hf, hr⟩ := slice_read h.k_fits h.k_read (by simp) (by decide) (k := i.val * 32 + m)
    (w := 8) (by omega)
  exact ⟨hf, hr.trans (by rw [hK, rows32_byte _ i hm])⟩

/-- Byte `m` of `s[i]`. -/
theorem Call.KS.sbyte {c : Call} {S : GlobalState} {K Sv : BitVec 2048} (h : c.KS S K Sv)
    (hS : Sv = rows32 c.sS) (i : Fin 8) {m : Nat} (hm : m < 32) :
    Fits S.mem ((c.s.slot 27).add (BitVec.ofNat 64 (i.val * 32 + m))) 8 ∧
      S.mem.readAt ((c.s.slot 27).add (BitVec.ofNat 64 (i.val * 32 + m))) 8 =
        (c.sS i).extractLsb' (8 * m) 8 := by
  obtain ⟨hf, hr⟩ := slice_read h.s_fits h.s_read (by simp) (by decide) (k := i.val * 32 + m)
    (w := 8) (by omega)
  exact ⟨hf, hr.trans (by rw [hS, rows32_byte _ i hm])⟩

/-- Two ranges of a slot, apart. -/
theorem recode_slot_disjoint (s : GlobalState) (k : Nat) {a b v w : Nat} (ha : a < 2 ^ 60)
    (hb : b < 2 ^ 60) (hab : 8 * a + v ≤ 8 * b ∨ 8 * b + w ≤ 8 * a) :
    (Range.of ((s.slot k).add (BitVec.ofNat 64 a)) v).Disjoint
      (Range.of ((s.slot k).add (BitVec.ofNat 64 b)) w) := by
  simp [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add,
    Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega), Nat.mod_eq_of_lt (show b < 2 ^ 64 by omega)]
  omega

/-- A store of `w` bits into a slot, read back `v` bits at `a`: the stored bits at its own
place, else the old ones. -/
theorem slot_store_read (s : GlobalState) (k : Nat) {m : MemoryState} {a b v : Nat} (x : BitVec v)
    (hr : Room m ((s.slot k).add (BitVec.ofNat 64 b)) v) (ha : a < 2 ^ 60) (hb : b < 2 ^ 60)
    (hab : a = b ∨ 8 * a + v ≤ 8 * b ∨ 8 * b + v ≤ 8 * a) :
    (m.storeAt ((s.slot k).add (BitVec.ofNat 64 b)) x).readAt ((s.slot k).add (BitVec.ofNat 64 a))
        v =
      if a = b then x else m.readAt ((s.slot k).add (BitVec.ofNat 64 a)) v := by
  split
  · subst_vars; exact MemoryState.readAt_storeAt_self hr x
  · exact MemoryState.readAt_storeAt_disjoint (recode_slot_disjoint s k hb ha (by omega)) x

/-- `slot_store_read`'s `Fits`. -/
theorem slot_store_fits (s : GlobalState) (k : Nat) {m : MemoryState} {a b v : Nat} (x : BitVec v)
    (hr : Room m ((s.slot k).add (BitVec.ofNat 64 b)) v)
    (h : a = b ∨ Fits m ((s.slot k).add (BitVec.ofNat 64 a)) v) :
    Fits (m.storeAt ((s.slot k).add (BitVec.ofNat 64 b)) x) ((s.slot k).add (BitVec.ofNat 64 a))
      v := by
  rcases h with rfl | h
  · exact Fits.storeAt_self hr
  · exact h.storeAt

/-- Room for `v` bits at byte `b` of a slot with room for `n`. -/
theorem slot_room {m : MemoryState} (s : GlobalState) (k : Nat) {n b v : Nat}
    (h : Room m (s.slot k) n) (hb : 8 * b + v ≤ n) (hn : n < 2 ^ 60) :
    Room m ((s.slot k).add (BitVec.ofNat 64 b)) v :=
  h.add_of_le (by simp [BitVec.uaddOverflow, Nat.mod_eq_of_lt (show b < 2 ^ 64 by omega)]; omega)
    (by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)

/-- Four digits more of `kj`. -/
theorem Call.K2.step {c : Call} {j : Fin 8} {t : Nat} {m : MemoryState} (h : c.K2 j (4 * t) m)
    (hr : Room m (c.s.slot 2) 512) (ht : t < 16) :
    c.K2 j (4 * (t + 1))
      ((((m.storeAt ((c.s.slot 2).add (BitVec.ofNat 64 (4 * t))) (recode4 (c.kS j) (4 * t))).storeAt
        ((c.s.slot 2).add (BitVec.ofNat 64 (4 * t + 1))) (recode4 (c.kS j) (4 * t + 1))).storeAt
        ((c.s.slot 2).add (BitVec.ofNat 64 (4 * t + 2))) (recode4 (c.kS j) (4 * t + 2))).storeAt
        ((c.s.slot 2).add (BitVec.ofNat 64 (4 * t + 3))) (recode4 (c.kS j) (4 * t + 3))) := by
  intro w hw
  have r (b : Nat) (hb : b < 64) {m' : MemoryState} (h' : Room m' (c.s.slot 2) 512) :=
    slot_room (m := m') c.s 2 (b := b) (v := 8) h' (by omega) (by decide)
  have r1 := hr.storeAt (q := (c.s.slot 2).add (BitVec.ofNat 64 (4 * t)))
    (x := recode4 (c.kS j) (4 * t))
  have r2 := r1.storeAt (q := (c.s.slot 2).add (BitVec.ofNat 64 (4 * t + 1)))
    (x := recode4 (c.kS j) (4 * t + 1))
  have r3 := r2.storeAt (q := (c.s.slot 2).add (BitVec.ofNat 64 (4 * t + 2)))
    (x := recode4 (c.kS j) (4 * t + 2))
  refine ⟨?_, ?_⟩
  · refine slot_store_fits c.s 2 _ (r _ (by omega) r3) ?_
    by_cases e3 : w = 4 * t + 3
    · exact .inl e3
    refine .inr (slot_store_fits c.s 2 _ (r _ (by omega) r2) ?_)
    by_cases e2 : w = 4 * t + 2
    · exact .inl e2
    refine .inr (slot_store_fits c.s 2 _ (r _ (by omega) r1) ?_)
    by_cases e1 : w = 4 * t + 1
    · exact .inl e1
    refine .inr (slot_store_fits c.s 2 _ (r _ (by omega) hr) ?_)
    by_cases e0 : w = 4 * t
    · exact .inl e0
    exact .inr (h w (by omega)).1
  · rw [slot_store_read c.s 2 _ (r _ (by omega) r3) (by omega) (by omega) (by omega),
      slot_store_read c.s 2 _ (r _ (by omega) r2) (by omega) (by omega) (by omega),
      slot_store_read c.s 2 _ (r _ (by omega) r1) (by omega) (by omega) (by omega),
      slot_store_read c.s 2 _ (r _ (by omega) hr) (by omega) (by omega) (by omega)]
    by_cases e3 : w = 4 * t + 3
    · simp [e3]
    by_cases e2 : w = 4 * t + 2
    · simp [e2]
    by_cases e1 : w = 4 * t + 1
    · simp [e1]
    by_cases e0 : w = 4 * t
    · simp [e0]
    simp only [e0, e1, e2, e3, ↓reduceIte]
    exact (h w (by omega)).2

/-! ### Arrays from their cells -/

/-- Two values of `8 n` bits with the same `8`-bit cells are equal. -/
theorem eq_of_cells8 {n : Nat} {x y : BitVec (8 * n)}
    (h : ∀ k < n, x.extractLsb' (8 * k) 8 = y.extractLsb' (8 * k) 8) : x = y := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := congrArg (·.getLsbD (i % 8)) (h (i / 8) (by omega))
  simp only [BitVec.getLsbD_extractLsb', show i % 8 < 8 by omega, decide_true, Bool.true_and,
    show 8 * (i / 8) + i % 8 = i by omega] at hk
  exact hk

/-- `n + 1` cells of 1 byte(s) that fit, at `q` plus `1 k`: their range fits. -/
theorem fits_cells8 {m : MemoryState} {q : Pointer} (hq : q.offset = 0) :
    ∀ (n : Nat), (∀ k < n + 1, Fits m (q.add (BitVec.ofNat 64 (1 * k))) 8) →
      1 * (n + 1) < 2 ^ 64 → Fits m q (8 * (n + 1))
  | 0, h, _ => by simpa [add_ofNat_zero] using h 0 (by omega)
  | n + 1, h, hlt => by
    have ih := fits_cells8 hq n (fun k hk => h k (by omega)) (by omega)
    have hl := h (n + 1) (by omega)
    exact Fits.append (off := BitVec.ofNat 64 (1 * (n + 1)))
      (by rw [hq]; simp [BitVec.uaddOverflow]; omega)
      (by simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega) (by omega) ih hl

/-- `n` cells of 1 byte(s) read at `q` plus `1 k`: their range's bits. -/
theorem readAt_cells8 {m : MemoryState} {q : Pointer} (hq : q.offset = 0) {n : Nat}
    {f : Fin n → BitVec 8} (hb : InBounds m q (8 * n)) (hlt : 1 * n < 2 ^ 64)
    (h : ∀ k : Fin n, m.readAt (q.add (BitVec.ofNat 64 (1 * k))) 8 = f k) :
    m.readAt q (8 * n) = BitVec.packLanes (Vector.ofFn f) := by
  apply eq_of_cells8
  intro k hk
  have := h ⟨k, hk⟩
  rw [MemoryState.readAt_add_of_readAt (off := BitVec.ofNat 64 (1 * k)) hb
      (by rw [hq]; simp [BitVec.uaddOverflow]; omega)
      (by simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega) rfl,
    BitVec.toNat_ofNat, Nat.mod_eq_of_lt (show 1 * k < 2 ^ 64 by omega),
    show 1 * k * 8 = 8 * k by omega] at this
  rw [this, show 8 * k = k * 8 by omega, BitVec.extractLsb'_packLanes _ k hk,
    Vector.getElem_ofFn]

/-- Two values of `16 n` bits with the same `16`-bit cells are equal. -/
theorem eq_of_cells16 {n : Nat} {x y : BitVec (16 * n)}
    (h : ∀ k < n, x.extractLsb' (16 * k) 16 = y.extractLsb' (16 * k) 16) : x = y := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := congrArg (·.getLsbD (i % 16)) (h (i / 16) (by omega))
  simp only [BitVec.getLsbD_extractLsb', show i % 16 < 16 by omega, decide_true, Bool.true_and,
    show 16 * (i / 16) + i % 16 = i by omega] at hk
  exact hk

/-- `n + 1` cells of 2 byte(s) that fit, at `q` plus `2 k`: their range fits. -/
theorem fits_cells16 {m : MemoryState} {q : Pointer} (hq : q.offset = 0) :
    ∀ (n : Nat), (∀ k < n + 1, Fits m (q.add (BitVec.ofNat 64 (2 * k))) 16) →
      2 * (n + 1) < 2 ^ 64 → Fits m q (16 * (n + 1))
  | 0, h, _ => by simpa [add_ofNat_zero] using h 0 (by omega)
  | n + 1, h, hlt => by
    have ih := fits_cells16 hq n (fun k hk => h k (by omega)) (by omega)
    have hl := h (n + 1) (by omega)
    exact Fits.append (off := BitVec.ofNat 64 (2 * (n + 1)))
      (by rw [hq]; simp [BitVec.uaddOverflow]; omega)
      (by simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega) (by omega) ih hl

/-- `n` cells of 2 byte(s) read at `q` plus `2 k`: their range's bits. -/
theorem readAt_cells16 {m : MemoryState} {q : Pointer} (hq : q.offset = 0) {n : Nat}
    {f : Fin n → BitVec 16} (hb : InBounds m q (16 * n)) (hlt : 2 * n < 2 ^ 64)
    (h : ∀ k : Fin n, m.readAt (q.add (BitVec.ofNat 64 (2 * k))) 16 = f k) :
    m.readAt q (16 * n) = BitVec.packLanes (Vector.ofFn f) := by
  apply eq_of_cells16
  intro k hk
  have := h ⟨k, hk⟩
  rw [MemoryState.readAt_add_of_readAt (off := BitVec.ofNat 64 (2 * k)) hb
      (by rw [hq]; simp [BitVec.uaddOverflow]; omega)
      (by simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega) rfl,
    BitVec.toNat_ofNat, Nat.mod_eq_of_lt (show 2 * k < 2 ^ 64 by omega),
    show 2 * k * 8 = 16 * k by omega] at this
  rw [this, show 16 * k = k * 16 by omega, BitVec.extractLsb'_packLanes _ k hk,
    Vector.getElem_ofFn]

/-- `kj` whole, after its 64 digits. -/
theorem Call.K2.whole {c : Call} {j : Fin 8} {m : MemoryState} (h : c.K2 j 64 m)
    (hr : Room m (c.s.slot 2) 512) :
    Fits m (c.s.slot 2) 512 ∧
      m.readAt (c.s.slot 2) 512 =
        BitVec.packLanes (Vector.ofFn fun w : Fin 64 => recode4 (c.kS j) w) :=
  ⟨fits_cells8 (by simp) 63 (fun k hk => by simpa using (h k hk).1) (by decide),
    readAt_cells8 (n := 64) (by simp) hr.inBounds (by decide) fun k => by
      simpa using (h k k.isLt).2⟩

/-- Room for lane `i` of the masked store into `kd`'s column `j`. -/
theorem Call.kd_lane_room {c : Call} {m : MemoryState} (h : Room m (c.s.slot 0) 4096) {j : Nat}
    (hj : j < 8) (i : Fin 505) :
    ((c.s.slot 0).add (BitVec.ofNat 64 j)).offset.toNat + i.val * (8 / 8) < 2 ^ 64 ∧
      Room m (Operation.lanePtr ((c.s.slot 0).add (BitVec.ofNat 64 j)) 8 i) 8 := by
  refine ⟨?_, ?_⟩
  · simp [Pointer.add, Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega)]; omega
  · rw [Operation.lanePtr, Nat.div_self (by decide), Nat.mul_one, add_ofNat_add_ofNat]
    exact slot_room c.s 0 h (by omega) (by decide)

/-- Room for `sd[w][j]`. -/
theorem Call.sd_room {c : Call} {m : MemoryState} (h : Room m (c.s.slot 1) 4096) {j w : Nat}
    (hj : j < 8) (hw : w < 32) :
    Room m (((c.s.slot 1).add (BitVec.ofNat 64 (j * 2))).add (BitVec.ofNat 64 (16 * w))) 16 := by
  rw [add_ofNat_add_ofNat]
  exact slot_room c.s 1 h (by omega) (by decide)

end

end MLIR.Firedancer.Lane.VerifyX8
