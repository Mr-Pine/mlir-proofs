module

public import Firedancer.Lane.verify_x8.Defs
public import Firedancer.Lane.verify_x8.Lanes
public import Firedancer.Lane.verify_x8.Tactics
public import Firedancer.Lane.verify_x8.ChecksBits
public import Firedancer.Lane.verify_x8.TableMem

/-! `scalars_run`'s pieces: the registers and the state of the loop at `^bb76`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

@[expose] public section

/-- `^bb76`'s registers at item `j`. -/
abbrev EnvS (c : Call) (E : ⟪Γ⟫) (j : Nat) : Prop :=
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
    0#8, %54 := PoisonOr.value 256#64, %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 :=
    PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 :=
    PoisonOr.value 3#64, %74 := PoisonOr.value 8#32, %76 := PoisonOr.value 5#64, %78 :=
    PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 :=
    PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64, %89 :=
    PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64, %94 := Ty.wrap
    (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64), %96 := Ty.wrap
    (Vector.replicate 8 2251799813685247#64), %99 := PoisonOr.value 576#64, %102 := Ty.wrap
    (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap
    (Vector.replicate 8 51#64), %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %108 :=
    Ty.wrap (Vector.replicate 8 4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8
    4503599627370494#64), %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %114 :=
    Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap
    #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32,
    14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16
    1#32), %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value
    18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot
    1), %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3), %139 :=
    PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5), %141 := PoisonOr.value
    (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7), %143 := PoisonOr.value (c.s.slot 8), %144 :=
    PoisonOr.value (c.s.slot 9), %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value
    (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15), %161 :=
    PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value
    (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32), rir_reg% hty 2040 :=
    PoisonOr.value (c.liveMask), rir_reg% hty 2176 :=
    PoisonOr.value (BitVec.ofNat 64 j)]

/-- `^bb75`'s registers past `a.x`'s stores: `^bb80`'s but `a.t`'s pointers. -/
abbrev EnvN (c : Call) (E : ⟪Γ⟫) : Prop :=
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
    PoisonOr.value ((c.s.slot 28).add 256#64)]

/-- What follows `^bb75`'s body. -/
noncomputable abbrev G75 {β : Type} (c : Call) (g : Vals [] × GlobalState → PoisonOr β) :
    ⟪Γ⟫ × GlobalState → PoisonOr β :=
  fun x =>
    Exit.run _root_.Firedancer.Lane.Mlir.verify_x8.blockParams x.1
        _root_.Firedancer.Lane.Mlir.verify_x8.bb75.exit x.2 >>= fun x =>
      Func.continue (func := verify_x8 c.batch) x.1.1 x.1.2 x.2 >>= g

namespace Call

variable (c : Call)

/-- `k[i]` for the items `i < j`, `0` past them. -/
noncomputable def kUpTo (j : Nat) (i : Fin 8) : BitVec 256 :=
  if i.val < j then c.kS i else 0

/-- `s[i]` for the items `i < j`, `0` past them. -/
noncomputable def sUpTo (j : Nat) (i : Fin 8) : BitVec 256 :=
  if i.val < j then c.sS i else 0

/-- `^bb76` at item `j`: `k` and `s` filled below `j`, the rest as at `^bb76`. -/
structure InvS (j : Nat) (S : GlobalState) : Prop where
  base : c.Base S c.mem76
  ks : c.KS S (rows32 (c.kUpTo j)) (rows32 (c.sUpTo j))
  a : c.PointAt S 28 c.decA.1
  r : c.PointAt S 29 c.decR.1
  hashes : ∀ j < c.cnt, c.X.liveAt j = true →
    Fits S.mem ((c.s.slot 31).add (BitVec.ofNat 64 (64 * j))) 512 ∧
      S.mem.readAt ((c.s.slot 31).add (BitVec.ofNat 64 (64 * j))) 512 = (c.it j).digest c.s.mem

end Call

/-! ### Facts the loop's items read -/

/-- Item `j`'s signature at a state over `mem76`: its pointer at `sigs[j]`, and its `S`. -/
theorem Call.Base.sig76 {c : Call} (hc : c.Ok) {S : GlobalState} (h : c.Base S c.mem76) {j : Nat}
    (hj : j < c.cnt) :
    InBounds S.mem (c.a.sigs.add (BitVec.ofNat 64 (j * 8))) 64 ∧
      S.mem.loadPtr (c.a.sigs.add (BitVec.ofNat 64 (j * 8))) = .value (c.it j).sig ∧
      ¬c.a.sigs.offset.uaddOverflow (BitVec.ofNat 64 (j * 8)) ∧
      Fits S.mem ((c.it j).sig.add 32#64) 256 ∧
      S.mem.readAt ((c.it j).sig.add 32#64) 256 = (c.it j).readS c.s.mem ∧
      ¬(c.it j).sig.offset.uaddOverflow 32#64 ∧
      (c.it j).sig.id.id < c.s.alloc.nextFreeBlock ∧ c.a.sigs.id.id < c.s.alloc.nextFreeBlock := by
  obtain ⟨_, _, _, _, hsb, hsl, _, _, _, _⟩ := hc.batch.holds j hj
  obtain ⟨_, _, _, hsf, hso, _⟩ := hc.batch.ok j hj
  have ho2 := hc.batch.off.2.2.1
  have hlen := hc.batch.len
  have hsep := hc.batch.sep
  have hrs : c.a.results.id ≠ c.a.sigs.id := fun e => hsep.1 (Or.inr (Or.inr (Or.inl e)))
  have hrg : c.a.results.id ≠ (c.it j).sig.id := fun e =>
    hsep.1 (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨j, hj, Or.inr (Or.inl e)⟩)))))
  have hhs (i : Nat) (hi : i < c.cnt) : (c.it i).sha.id ≠ c.a.sigs.id := fun e =>
    (hsep.2.1 i hi).1 (Or.inr (Or.inr (Or.inl e)))
  have hhg (i : Nat) (hi : i < c.cnt) : (c.it i).sha.id ≠ (c.it j).sig.id := fun e =>
    (hsep.2.1 i hi).1 (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨j, hj, Or.inr (Or.inl e)⟩)))))
  let Kp : BlockId → Prop := fun b => b ≠ c.a.results.id ∧ ∀ i < c.cnt, b ≠ (c.it i).sha.id
  have hSO : c.s.mem.StoresOff Kp c.mem76 :=
    (MemoryState.StoresOff.streamMem c.cnt fun i hi _ hk => hk.2 i hi rfl).trans
      (MemoryState.StoresOff.storeResults (fun hk => hk.1 rfl) _ _)
  have hKs : Kp c.a.sigs.id := ⟨Ne.symm hrs, fun i hi => Ne.symm (hhs i hi)⟩
  have hKg : Kp (c.it j).sig.id := ⟨Ne.symm hrg, fun i hi => Ne.symm (hhg i hi)⟩
  have hMS := h.sameOn
  have hsglt : c.a.sigs.id.id < c.s.alloc.nextFreeBlock := by
    simpa only [Pointer.add_id] using hc.wf.id_lt_of_inBounds hsb
  have hglt : (c.it j).sig.id.id < c.s.alloc.nextFreeBlock := hc.wf.id_lt_of_inBounds hsf.inBounds
  have hso32 : ¬(c.it j).sig.offset.uaddOverflow 32#64 :=
    BitVec.not_uaddOverflow_of_le hso (by decide)
  refine ⟨hMS.inBounds hsglt (hSO.inBounds hsb), ?_, ?_, ?_, ?_, hso32, hglt, hsglt⟩
  · rw [hMS.loadPtr (q := c.a.sigs.add _) hsglt, hSO.sameOn.loadPtr (q := c.a.sigs.add _) hKs, hsl]
  · simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, ge_iff_le, decide_eq_true_eq, not_le]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  · exact (hMS.fits hglt (hSO.sameOn.fits hKg hsf)).add_of_le hso32 (by decide)
  · rw [hMS.readAt (q := (c.it j).sig.add _) hglt, hSO.sameOn.readAt (q := (c.it j).sig.add _) hKg]
    rfl

/-- `live`'s bit `j` tested as `1 << j & live`: item `j` live. -/
theorem Call.liveAt_of_bit (c : Call) {j : Nat} (hj : j < 8) :
    (1#32 <<< j &&& c.liveMask = 0#32) ↔ c.X.liveAt j = false := by
  rw [and_bit_iff _ (by omega), Call.liveMask, getLsbD_maskOf, X8.liveAt]

/-- A live item is an item. -/
theorem Call.lt_of_liveAt {c : Call} {j : Nat} (h : c.X.liveAt j = true) : j < c.cnt := by
  unfold X8.liveAt at h
  split at h
  · rw [Call.live_eq] at h
    simp only [Bool.and_eq_true] at h
    exact Call.lt_of_cand h.1.1.1.1
  · exact absurd h (by simp)

/-- `j++` does not wrap. -/
theorem scal_inc {j : Nat} (hj : j < 8) :
    (BitVec.ofNat 64 j).uaddOverflow 1#64 = false ∧
      BitVec.ofNat 64 j + 1#64 = BitVec.ofNat 64 (j + 1) := by
  revert j; decide

/-- The loop's exit test. -/
theorem scal_exit {j n : Nat} (hj : j < 8) (hn : n ≤ 8) :
    (BitVec.ofNat 64 (j + 1) = BitVec.ofNat 64 n) ↔ j + 1 = n := by
  constructor
  · intro h
    have := congrArg BitVec.toNat h
    simp only [BitVec.toNat_ofNat] at this
    rwa [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)] at this
  · rintro rfl; rfl

/-! ### Rows of `k` and `s` -/

/-- A slot's row `j < 8` of `n ≤ 64` bytes starts without wrapping. -/
theorem slot_row_ov0 (s : GlobalState) (k : Nat) {j n : Nat} (hj : j < 8) (hn : n ≤ 64) :
    ¬(s.slot k).offset.uaddOverflow (BitVec.ofNat 64 (j * n)) := by
  have : j * n ≤ 7 * 64 := Nat.mul_le_mul (by omega) hn
  simp [BitVec.uaddOverflow, Nat.mod_eq_of_lt (show j * n < 2 ^ 64 by omega)]
  omega

/-- A slot's row `j < 8` of `n ≤ 64` bytes does not wrap. -/
theorem slot_row_ov (s : GlobalState) (k : Nat) {j n : Nat} (hj : j < 8) (hn : n ≤ 64) :
    ((s.slot k).add (BitVec.ofNat 64 (j * n))).offset.uaddOverflow (BitVec.ofNat 64 n) = false := by
  have : j * n ≤ 7 * 64 := Nat.mul_le_mul (by omega) hn
  simp [Pointer.add, BitVec.uaddOverflow, Nat.mod_eq_of_lt (show j * n < 2 ^ 64 by omega),
    Nat.mod_eq_of_lt (show n < 2 ^ 64 by omega)]
  omega

/-- A block below the frame is no slot's. -/
theorem slot_id_ne {c : Call} {p : Pointer} (hp : p.id.id < c.s.alloc.nextFreeBlock) (k : Nat)
    (a b : BitVec 64) : ((c.s.slot k).add a).id ≠ (p.add b).id := by
  intro h
  have := congrArg BlockId.id h
  simp only [Pointer.add_id, GlobalState.slot_id_id] at this
  omega

/-- Two slots' blocks differ. -/
theorem slot_ne_slot (s : GlobalState) {k l : Nat} (h : k ≠ l) (a : BitVec 64) :
    ((s.slot k).add a).id ≠ (s.slot l).id := by
  intro e
  have := congrArg BlockId.id e
  simp only [Pointer.add_id, GlobalState.slot_id_id] at this
  omega

/-- Row `j` of an `[8][32]` array replaced. -/
theorem rows32_splice (f : Fin 8 → BitVec 256) {j : Nat} (hj : j < 8) (x : BitVec 256) :
    Memory.spliceBits (rows32 f) ((BitVec.ofNat 64 (j * 32)).toNat * 8) x =
      rows32 fun i => if i.val = j then x else f i := by
  rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [Memory.getLsbD_spliceBits]
  simp only [rows32]
  rw [BitVec.getLsbD_packLanes_lane _ hi, BitVec.getLsbD_packLanes_lane _ hi]
  simp only [Vector.getElem_ofFn]
  by_cases h : i / 256 = j
  · have h' : j * 32 * 8 ≤ i ∧ i < j * 32 * 8 + 256 ∧ i < 2048 := by omega
    simp only [h', h, and_self, ↓reduceIte, show i - j * 32 * 8 = i % 256 by omega]
  · have h' : ¬(j * 32 * 8 ≤ i ∧ i < j * 32 * 8 + 256 ∧ i < 2048) := by omega
    simp only [h', h, ↓reduceIte]

/-- Room for row `j` of `k`. -/
theorem Call.KS.room_k {c : Call} {S : GlobalState} {K Sv : BitVec 2048} (h : c.KS S K Sv)
    (hw : Writable S.mem (c.s.slot 26)) {j : Nat} (hj : j < 8) :
    Room S.mem ((c.s.slot 26).add (BitVec.ofNat 64 (j * 32))) (8 * 32) :=
  (h.k_fits.room hw).add_of_le (slot_row_ov0 _ _ hj (by decide))
    (by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)

/-- Room for row `j` of `s`. -/
theorem Call.KS.room_s {c : Call} {S : GlobalState} {K Sv : BitVec 2048} (h : c.KS S K Sv)
    (hw : Writable S.mem (c.s.slot 27)) {j : Nat} (hj : j < 8) :
    Room S.mem ((c.s.slot 27).add (BitVec.ofNat 64 (j * 32))) (8 * 32) :=
  (h.s_fits.room hw).add_of_le (slot_row_ov0 _ _ hj (by decide))
    (by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega)

/-- `m'` is `m` after a store into the frame. -/
theorem FrameOps.storeAt {n : Nat} {m m' : MemoryState} {p : Pointer} {x : BitVec w}
    (h : FrameOps n m m') (hp : n ≤ p.id.id) : FrameOps n m (m'.storeAt p x) :=
  ⟨fun _ _ hq => (h.1 _ _ hq).storeAt, fun _ hq => (h.2.1 _ hq).storeAt,
    (MemoryState.eraseFrom_storeAt_of_le hp).trans h.2.2⟩

/-! ### The loop's steps -/

/-- No row of `k` yet. -/
theorem Call.kUpTo_zero (c : Call) : rows32 (c.kUpTo 0) = 0 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [rows32, BitVec.getLsbD_packLanes_lane _ hi]
  simp [Call.kUpTo]

/-- No row of `s` yet. -/
theorem Call.sUpTo_zero (c : Call) : rows32 (c.sUpTo 0) = 0 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [rows32, BitVec.getLsbD_packLanes_lane _ hi]
  simp [Call.sUpTo]

/-- A live item is a lane. -/
theorem lt8_of_liveAt {X : X8} {j : Nat} (h : X.liveAt j = true) : j < 8 := by
  unfold X8.liveAt at h
  split at h
  · assumption
  · exact absurd h (by simp)

/-- A dead lane's `k[j]` and `s[j]` are `0`. -/
theorem Call.kS_sS_of_dead {c : Call} {i : Fin 8} (h : c.X.liveAt i = false) :
    c.kS i = 0 ∧ c.sS i = 0 := by
  have : c.X.live i = false := by simpa [X8.liveAt, i.isLt] using h
  simp [Call.kS, Call.sS, this]

/-- A dead item: `k[j]`, `s[j]` stay `0`. -/
theorem Call.InvS.dead {c : Call} {j : Nat} {S : GlobalState} (h : c.InvS j S) (hj : j < 8)
    (hl : c.X.liveAt j = false) : c.InvS (j + 1) S := by
  obtain ⟨hk, hs⟩ := c.kS_sS_of_dead (i := ⟨j, hj⟩) hl
  have ek : c.kUpTo (j + 1) = c.kUpTo j := by
    funext i
    simp only [Call.kUpTo]
    by_cases hi : i.val = j
    · have : i = ⟨j, hj⟩ := Fin.ext hi
      subst this
      simp [hk]
    · simp only [show (i.val < j + 1) = (i.val < j) from propext (by omega)]
  have es : c.sUpTo (j + 1) = c.sUpTo j := by
    funext i
    simp only [Call.sUpTo]
    by_cases hi : i.val = j
    · have : i = ⟨j, hj⟩ := Fin.ext hi
      subst this
      simp [hs]
    · simp only [show (i.val < j + 1) = (i.val < j) from propext (by omega)]
  exact ⟨h.base, by rw [ek, es]; exact h.ks, h.a, h.r, h.hashes⟩

/-- A live item: `k[j]` its reduced digest, `s[j]` its `S`. -/
theorem Call.InvS.live {c : Call} {j : Nat} {S : GlobalState} (h : c.InvS j S)
    (hl : c.X.liveAt j = true) :
    c.InvS (j + 1)
      { alloc := S.alloc,
        mem :=
          (S.mem.storeAt ((c.s.slot 26).add (BitVec.ofNat 64 (j * 32)))
                (fd_curve25519_scalar_reduce.spec ((c.it j).digest c.s.mem))).storeAt
            ((c.s.slot 27).add (BitVec.ofNat 64 (j * 32))) ((c.it j).readS c.s.mem) } := by
  have hj := Call.lt_of_liveAt hl
  have hj8 := lt8_of_liveAt hl
  have hlive : c.X.live ⟨j, hj8⟩ = true := by simpa [X8.liveAt, hj8] using hl
  have hk : c.kS ⟨j, hj8⟩ = fd_curve25519_scalar_reduce.spec ((c.it j).digest c.s.mem) := by
    simp [Call.kS, hlive, Call.H, hj]
  have hs : c.sS ⟨j, hj8⟩ = (c.it j).readS c.s.mem := by simp [Call.sS, hlive, Call.S, hj]
  have ek : c.kUpTo (j + 1) =
      fun i => if i.val = j then fd_curve25519_scalar_reduce.spec ((c.it j).digest c.s.mem)
        else c.kUpTo j i := by
    funext i
    simp only [Call.kUpTo]
    by_cases hi : i.val = j
    · have : i = ⟨j, hj8⟩ := Fin.ext hi
      subst this
      simp [hk]
    · simp only [hi, ↓reduceIte, show (i.val < j + 1) = (i.val < j) from propext (by omega)]
  have es : c.sUpTo (j + 1) =
      fun i => if i.val = j then (c.it j).readS c.s.mem else c.sUpTo j i := by
    funext i
    simp only [Call.sUpTo]
    by_cases hi : i.val = j
    · have : i = ⟨j, hj8⟩ := Fin.ext hi
      subst this
      simp [hs]
    · simp only [hi, ↓reduceIte, show (i.val < j + 1) = (i.val < j) from propext (by omega)]
  have hb := h.base
  have hr26 : Room S.mem (c.s.slot 26) 2048 := h.ks.k_fits.room (hb.writable 26 (by decide))
  have hr27 : Room S.mem (c.s.slot 27) 2048 := h.ks.s_fits.room (hb.writable 27 (by decide))
  have hov (k : Nat) := slot_row_ov0 c.s k (j := j) (n := 32) hj8 (by decide)
  have hw : (BitVec.ofNat 64 (j * 32)).toNat * 8 + 256 ≤ 2048 := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega
  refine ⟨?_, ⟨h.ks.k_fits.storeAt.storeAt, ?_, h.ks.s_fits.storeAt.storeAt, ?_⟩,
    ⟨⟨h.a.fit.1, h.a.fit.2.storeAt.storeAt⟩, ?_⟩, ⟨⟨h.r.fit.1, h.r.fit.2.storeAt.storeAt⟩, ?_⟩,
    fun i hi hli => ⟨(h.hashes i hi hli).1.storeAt.storeAt, ?_⟩⟩
  · exact hb.frameOps (((FrameOps.refl _ _).storeAt (by simp)).storeAt (by simp))
      hb.wf.storeAt.storeAt rfl
  · dsimp only
    rw [MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_of_id_ne (slot_ne_slot c.s (by decide : 27 ≠ 26) _)),
      MemoryState.readAt_add_storeAt hr26 (hov 26) hw, h.ks.k_read, rows32_splice _ hj8, ek]
  · dsimp only
    rw [MemoryState.readAt_add_storeAt hr27.storeAt (hov 27) hw,
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_of_id_ne (slot_ne_slot c.s (by decide : 26 ≠ 27) _)),
      h.ks.s_read, rows32_splice _ hj8, es]
  · dsimp only
    rw [readLanePoint_storeAt_of_id_ne (slot_ne_slot c.s (by decide : 27 ≠ 28) _),
      readLanePoint_storeAt_of_id_ne (slot_ne_slot c.s (by decide : 26 ≠ 28) _), h.a.read]
  · dsimp only
    rw [readLanePoint_storeAt_of_id_ne (slot_ne_slot c.s (by decide : 27 ≠ 29) _),
      readLanePoint_storeAt_of_id_ne (slot_ne_slot c.s (by decide : 26 ≠ 29) _), h.r.read]
  · dsimp only
    rw [MemoryState.readAt_storeAt_disjoint (q := (c.s.slot 31).add _)
        (Range.disjoint_of_id_ne (slot_ne_slot c.s (by decide : 27 ≠ 31) _)),
      MemoryState.readAt_storeAt_disjoint (q := (c.s.slot 31).add _)
        (Range.disjoint_of_id_ne (slot_ne_slot c.s (by decide : 26 ≠ 31) _)),
      (h.hashes i hi hli).2]

/-- All of `k` after the items. -/
theorem Call.kUpTo_cnt (c : Call) : c.kUpTo c.cnt = c.kS := by
  funext i
  simp only [Call.kUpTo]
  split
  · rfl
  · rename_i h
    have hl : c.X.liveAt i = false := by
      cases e : c.X.liveAt i
      · rfl
      · exact absurd (Call.lt_of_liveAt e) h
    exact (c.kS_sS_of_dead hl).1.symm

/-- All of `s` after the items. -/
theorem Call.sUpTo_cnt (c : Call) : c.sUpTo c.cnt = c.sS := by
  funext i
  simp only [Call.sUpTo]
  split
  · rfl
  · rename_i h
    have hl : c.X.liveAt i = false := by
      cases e : c.X.liveAt i
      · rfl
      · exact absurd (Call.lt_of_liveAt e) h
    exact (c.kS_sS_of_dead hl).2.symm

/-! ### `a.x`, `a.t` negated -/

/-- `fd_ed25519_lane_sub( zero, a )` as compiled: `4p - a` limbwise, carried. -/
theorem sub_zero_eq (a0 a1 a2 a3 a4 : Wwl) :
    sub Fe.zero ⟨a0, a1, a2, a3, a4⟩ =
      ⟨wwl_madd52lo
          (wwl_and (wwl_sub (Vector.replicate 8 9007199254740916#64) a0)
            (Vector.replicate 8 2251799813685247#64))
          (wwl_shru (wwl_sub (Vector.replicate 8 9007199254740988#64) a4) 51)
          (Vector.replicate 8 19#64),
        wwl_add
          (wwl_and (wwl_sub (Vector.replicate 8 9007199254740988#64) a1)
            (Vector.replicate 8 2251799813685247#64))
          (wwl_shru (wwl_sub (Vector.replicate 8 9007199254740916#64) a0) 51),
        wwl_add
          (wwl_and (wwl_sub (Vector.replicate 8 9007199254740988#64) a2)
            (Vector.replicate 8 2251799813685247#64))
          (wwl_shru (wwl_sub (Vector.replicate 8 9007199254740988#64) a1) 51),
        wwl_add
          (wwl_and (wwl_sub (Vector.replicate 8 9007199254740988#64) a3)
            (Vector.replicate 8 2251799813685247#64))
          (wwl_shru (wwl_sub (Vector.replicate 8 9007199254740988#64) a2) 51),
        wwl_add
          (wwl_and (wwl_sub (Vector.replicate 8 9007199254740988#64) a4)
            (Vector.replicate 8 2251799813685247#64))
          (wwl_shru (wwl_sub (Vector.replicate 8 9007199254740988#64) a3) 51)⟩ := by
  have h (c : BitVec 64) :
      wwl_add (Vector.replicate 8 0#64) (Vector.replicate 8 c) = Vector.replicate 8 c := by
    ext i hi; simp [wwl_add]
  have c1 : (2#64 * (2#64 ^ 52 - 38#64)) = 9007199254740916#64 := by decide
  have c2 : (2#64 * (2#64 ^ 52 - 2#64)) = 9007199254740988#64 := by decide
  simp [sub, subOff, carry, Fe.zipWith, Fe.bcast2, Fe.zero, Fe.small, wwl_bcast, wwl_zero, h, c1,
    c2]

/-- The point after `x` and `t` are stored. -/
theorem readLanePoint_storeFe_xt {m : MemoryState} {p : Pointer} {X T : Fe}
    (h : m.LanePointRoom p) :
    ((m.storeFe p X).storeFe (p.add 960#64) T).readLanePoint p =
      ⟨X, m.readFe (p.add 320#64), m.readFe (p.add 640#64), T⟩ := by
  have hov := h.1
  have hfe : m.FeRoom p :=
    ⟨BitVec.not_uaddOverflow_of_le hov (by decide), h.2.mono (by decide)⟩
  have hfe' : (m.storeFe p X).FeRoom (p.add 960#64) := by
    refine ⟨?_, (h.2.add_of_le (BitVec.not_uaddOverflow_of_le hov (by decide)) (by decide)).storeFe⟩
    have := hov
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, not_le,
      BitVec.toNat_ofNat] at this ⊢
    rw [BitVec.toNat_add_of_not_uaddOverflow (BitVec.not_uaddOverflow_of_le hov (by decide))]
    simp only [BitVec.toNat_ofNat]
    omega
  simp only [MemoryState.readLanePoint]
  rw [MemoryState.readFe_storeFe_apart_base hov (by decide) (by decide),
    MemoryState.readFe_storeFe_self hfe,
    MemoryState.readFe_storeFe_apart (a := 960#64) (b := 320#64) hov (by decide) (by decide)
      (by decide),
    MemoryState.readFe_storeFe_base_apart hov (by decide) (by decide),
    MemoryState.readFe_storeFe_apart (a := 960#64) (b := 640#64) hov (by decide) (by decide)
      (by decide),
    MemoryState.readFe_storeFe_base_apart hov (by decide) (by decide),
    MemoryState.readFe_storeFe_self hfe']

/-- `m'` is `m` after a field element's stores into the frame. -/
theorem FrameOps.storeFe {n : Nat} {m m' : MemoryState} {p : Pointer} {a : Fe}
    (h : FrameOps n m m') (hp : n ≤ p.id.id) : FrameOps n m (m'.storeFe p a) := by
  have hp' (o : BitVec 64) : n ≤ (p.add o).id.id := by rw [Pointer.add_id]; exact hp
  simp only [MemoryState.storeFe, MemoryState.storeVec]
  exact ((((h.storeAt hp).storeAt (hp' _)).storeAt (hp' _)).storeAt (hp' _)).storeAt (hp' _)

/-- `^bb80`'s state from `^bb76`'s after the items: `a.x`, `a.t` negated, `kd` and `sd` started. -/
theorem Call.InvS.at80 {c : Call} {S₀ S : GlobalState} (h : c.InvS c.cnt S₀) {X T : Fe}
    (hX : X = sub Fe.zero c.decA.1.x) (hT : T = sub Fe.zero c.decA.1.t)
    (hm :
      S.mem =
        (((S₀.mem.storeFe (c.s.slot 28) X).storeFe ((c.s.slot 28).add 960#64) T).lifetimeStart
            (c.s.slot 0)).lifetimeStart (c.s.slot 1))
    (hwf : S.WF) (ha : S.alloc = S₀.alloc) : c.At80 S := by
  have hb := h.base
  have ne (k l : Nat) (hkl : k ≠ l) : (c.s.slot k).id ≠ (c.s.slot l).id := by
    simpa [Pointer.add] using slot_ne_slot c.s hkl 0#64
  have ne' (k : Nat) (hk : k ≠ 28) (b : BitVec 64) : ((c.s.slot 28).add b).id ≠ (c.s.slot k).id :=
    slot_ne_slot c.s (Ne.symm hk) b
  have fits {k : Nat} {w : Nat} (hk : k ≠ 0 ∧ k ≠ 1) (hf : Fits S₀.mem (c.s.slot k) w) :
      Fits S.mem (c.s.slot k) w := by
    rw [hm]
    exact (hf.storeFe.storeFe.lifetimeStart (ne _ _ hk.1)).lifetimeStart (ne _ _ hk.2)
  have read {k : Nat} {w : Nat} (hk : k ≠ 28) :
      S.mem.readAt (c.s.slot k) w = S₀.mem.readAt (c.s.slot k) w := by
    rw [hm, MemoryState.readAt_lifetimeStart, MemoryState.readAt_lifetimeStart,
      MemoryState.readAt_storeFe_of_id_ne (ne' k hk _),
      MemoryState.readAt_storeFe_of_id_ne (by simpa [Pointer.add] using ne' k hk 0#64)]
  have hroom : S₀.mem.LanePointRoom (c.s.slot 28) :=
    h.a.fit.room (hb.writable 28 (by decide))
  have hP := h.a.read
  have hb0 := hb.slots 0 (by decide)
  have hb1 := hb.slots 1 (by decide)
  simp only [slotBytes, List.getElem_cons_zero, List.getElem_cons_succ] at hb0 hb1
  refine ⟨hb.frameOps ?_ hwf ha, ⟨fits (by decide) h.ks.k_fits, ?_, fits (by decide) h.ks.s_fits,
    ?_⟩, ⟨⟨h.a.fit.1, ?_⟩, ?_⟩, ⟨⟨h.r.fit.1, fits (by decide) h.r.fit.2⟩, ?_⟩, ?_, ?_⟩
  · rw [hm]
    exact (((FrameOps.refl _ _).storeFe (by simp)).storeFe (by simp)).lifetimeStart (by simp)
      |>.lifetimeStart (by simp)
  · rw [read (by decide), h.ks.k_read, Call.kUpTo_cnt]
  · rw [read (by decide), h.ks.s_read, Call.sUpTo_cnt]
  · rw [hm]
    exact (h.a.fit.2.storeFe.storeFe.lifetimeStart (ne _ _ (by decide))).lifetimeStart
      (ne _ _ (by decide))
  · rw [hm, MemoryState.readLanePoint_lifetimeStart, MemoryState.readLanePoint_lifetimeStart,
      readLanePoint_storeFe_xt hroom, hX, hT, Call.aNeg]
    rw [← hP]
    rfl
  · rw [hm, MemoryState.readLanePoint_lifetimeStart, MemoryState.readLanePoint_lifetimeStart,
      MemoryState.readLanePoint_storeFe_of_id_ne (ne' 29 (by decide) _),
      MemoryState.readLanePoint_storeFe_of_id_ne (ne 28 29 (by decide)), h.r.read]
  · rw [hm]
    exact (Room.lifetimeStart_self hb0.storeFe.storeFe
      (hb.writable 0 (by decide)).storeFe.storeFe).lifetimeStart (ne _ _ (by decide))
  · rw [hm]
    exact Room.lifetimeStart_self (hb1.storeFe.storeFe.lifetimeStart)
      (hb.writable 1 (by decide)).storeFe.storeFe.lifetimeStart

end

end MLIR.Firedancer.Lane.VerifyX8
