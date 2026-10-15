module

public import Firedancer.Lane.verify_x8.ChecksMem
public import Firedancer.Lane.verify_x8.ChecksBits
public import Firedancer.Lane.verify_x8.Tactics
import Firedancer.Common.Counter
import Mathlib.Tactic.IntervalCases
meta import Lean.Elab.Tactic

/-! `verify_x8`'s checks (`^bb42 … ^bb61`): `fd_ed25519_lane_small_order` of `a` and `r`, then the
loop storing the failed candidates' codes and collecting `live`, vectorized by `clang`: `cnt = 8`
runs the eight-lane body once (`^bb48 … ^bb50`, masked stores), `cnt < 8` the scalar loop
(`^bb53 … ^bb61`); the sixteen-lane one (`^bb44 … ^bb47`) needs `cnt ≥ 32`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_or_wrap zipWith_xor_wrap zipWith_add_wrap
  zipWith_icmp_eq_wrap zipWith_icmp_ne_wrap ofBool_eq_one ite_ofBool ite_ofBool_zero ite_one_ofBool
  ofBool_xor_one and_bit0 and_bit1 and_bit2 and_bit3 and_bit4 and_bit5 and_bit6 and_bit7

/-- The registers the checks carry to `^bb62`: `Env62`'s but `live`. -/
abbrev EnvC (c : Call) (E : ⟪Γ⟫) : Prop :=
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
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64), %37 :=
    PoisonOr.value 1233#64, %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap
    (Vector.replicate 8 0#32), %45 := Ty.wrap (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32,
    1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32], %47 := Vector.replicate 8 PoisonOr.poison, %52 :=
    PoisonOr.value 1#32, %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %56 :=
    PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %61 := PoisonOr.value 0#32, %62 :=
    PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64, %69 :=
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
    (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32)]

/-- The scalar loop's registers: `EnvC`'s, the codes, `candidates`, `a_valid`, `r_valid`, and the
small-order masks `as`, `rs`. -/
abbrev EnvL (c : Call) (as rs : BitVec 32) (E : ⟪Γ⟫) : Prop :=
  EnvC c E ∧
    E ⊨ [%38 := PoisonOr.value 4294967294#32, %55 := PoisonOr.value 4294967295#32, %428 :=
      PoisonOr.value c.candMask, rir_reg% hty 1278 := PoisonOr.value c.X.aValid,
      rir_reg% hty 1818 := PoisonOr.value c.X.rValid, rir_reg% hty 1906 := PoisonOr.value as,
      rir_reg% hty 1907 := PoisonOr.value rs]

/-- The eight-lane loop's registers: `EnvL`'s, its codes and `i1` lanes, `live`'s start. -/
abbrev EnvV (c : Call) (as rs : BitVec 32) (E : ⟪Γ⟫) : Prop :=
  EnvL c as rs E ∧
    E ⊨ [%40 := Ty.wrap (Vector.replicate 8 4294967295#32), %41 := Ty.wrap (Vector.replicate 8
      4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1), %43 := Ty.wrap (Vector.replicate 8
      1#1), %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32)
      (by decide)).set 2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32)
      (by decide)).set 4 (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32)
      (by decide)).set 6 (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32)
      (by decide)]

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

/-- `^bb52`: on to the hashes with an item live, else to the return. -/
theorem bb52_run (c : Call) (E : ⟪Γ⟫) (S : GlobalState) (hA : E.args = c.args) (hE : Env62 c E)
    (hS : c.At62 S)
    (h62 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env62 c E' → c.At62 S' →
        c.liveMask ≠ 0 → ((verify_x8 c.batch).runFrom E' 62 S' >>= g) = K)
    (h102 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env102 c E' → c.Base S' c.mem62 →
        c.liveMask = 0 → ((verify_x8 c.batch).runFrom E' 102 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 52 S >>= g) = K := by
  have hb := hS.base
  split_reads hE
  block_init
  step_pure
  finish_block
  · step_loop using h102
  · step_loop using h62

/-- `^bb61`: `i + 1`, then around with `acc` or, past the last item, to `^bb52` with `live`. -/
theorem bb61_run (c : Call) (hc : c.Ok) (as rs : BitVec 32) (i : Nat) (hi : i < c.cnt)
    (acc : BitVec 32) (hacc : i + 1 = c.cnt → acc = c.liveMask) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hL : EnvL c as rs E)
    (hI : E ⊨ [rir_reg% hty 2042 := PoisonOr.value (BitVec.ofNat 64 i),
      rir_reg% hty 2061 := PoisonOr.value acc])
    (hback :
      i + 1 < c.cnt → ∀ E' : ⟪Γ⟫, E'.args = c.args → EnvL c as rs E' →
        (E' ⊨ [rir_reg% hty 2042 := PoisonOr.value (BitVec.ofNat 64 (i + 1)),
          rir_reg% hty 2043 := PoisonOr.value acc]) →
        ((verify_x8 c.batch).runFrom E' 53 S >>= g) = K)
    (hexit :
      i + 1 = c.cnt → ∀ E' : ⟪Γ⟫, E'.args = c.args → Env62 c E' →
        ((verify_x8 c.batch).runFrom E' 52 S >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 61 S >>= g) = K := by
  have h8 := hc.cnt8
  split_reads hL hI
  block_init
  step_pure [uaddOverflow_one64 (i := i) (by omega)]
  step_pure
  finish_block
  · have hi1 : i + 1 = c.cnt := by
      have := congrArg BitVec.toNat hbr
      simp [BitVec.toNat_add] at this
      omega
    have := hacc hi1
    step_loop using hexit hi1
  · have hi1 : i + 1 < c.cnt := by
      have : i + 1 ≠ c.cnt := fun h => hbr (by rw [← h, BitVec.ofNat_add])
      omega
    step_loop using hback hi1
    exact (BitVec.ofNat_add i 1).symm

/-- One trip through the scalar loop (`^bb53 … ^bb60`) on item `i`: its code stored where it fails
a check, its `live` bit collected, on to `^bb61`. -/
theorem trip (c : Call) (hc : c.Ok) (as rs : BitVec 32) (has : as = c.X.aSmall)
    (hrs : rs = c.X.rSmall) (A : AllocState) (M : MemoryState)
    (hroom : ∀ j < c.cnt, Room M (c.a.result j) 32) (i : Nat) (hi : i < c.cnt) (E : ⟪Γ⟫)
    (S : GlobalState) (hSA : S = ⟨A, c.scalarMem M i⟩) (hA : E.args = c.args)
    (hL : EnvL c as rs E)
    (hI : E ⊨ [rir_reg% hty 2042 := PoisonOr.value (BitVec.ofNat 64 i),
      rir_reg% hty 2043 := PoisonOr.value (c.liveUpTo i)])
    (hback :
      i + 1 < c.cnt → ∀ E' : ⟪Γ⟫, E'.args = c.args → EnvL c as rs E' →
        (E' ⊨ [rir_reg% hty 2042 := PoisonOr.value (BitVec.ofNat 64 (i + 1)),
          rir_reg% hty 2043 := PoisonOr.value (c.liveUpTo (i + 1))]) →
        ((verify_x8 c.batch).runFrom E' 53 ⟨A, c.scalarMem M (i + 1)⟩ >>= g) = K)
    (hexit :
      i + 1 = c.cnt → ∀ E' : ⟪Γ⟫, E'.args = c.args → Env62 c E' →
        ((verify_x8 c.batch).runFrom E' 52 ⟨A, c.scalarMem M (i + 1)⟩ >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 53 S >>= g) = K := by
  have h8 := hc.cnt8
  have hi8 : i < 8 := by omega
  have hroomS : Room S.mem (c.a.result i) 32 := by
    rw [hSA]; exact (c.storesOff_scalarMem M i).room (hroom i hi)
  have hmod : i % 4294967296 = i := Nat.mod_eq_of_lt (by omega)
  have hmod64 : i % 18446744073709551616 = i := Nat.mod_eq_of_lt (by omega)
  have h32 : ¬32 ≤ i := by omega
  have hov : ¬c.a.results.offset.uaddOverflow (BitVec.ofNat 64 (i * 4)) := by
    have := hc.batch.off.2.2.2.2.2
    simp [BitVec.uaddOverflow]; omega
  have hacc (h : c.liveUpTo (i + 1) = c.liveUpTo i) : i + 1 = c.cnt → c.liveUpTo i = c.liveMask :=
    fun h' => by rw [← h, h']; exact c.liveUpTo_cnt hc
  have hdrop (hl : c.X.liveAt i = false) : c.liveUpTo (i + 1) = c.liveUpTo i := by
    simp [Call.liveUpTo, hl]
  have hcm := c.getLsbD_candMask hi8
  split_reads hL hI
  block_init
  step_pure
  step_pure [hmod, h32, one_shl_shr hi8]
  step_pure
  step_pure
  finish_block
  · -- not a candidate
    rw [and_bit_iff _ (by omega), hcm] at hbr
    have hst : c.stores i = false := by simp [Call.stores, hi8, hbr]
    have hl : c.X.liveAt i = false := by simp [X8.liveAt, hi8, Call.live_eq, hbr]
    rw [c.scalarMem_succ_keep hst, ← hSA] at hback hexit
    rw [hdrop hl] at hback
    step_loop using bb61_run c hc as rs i hi (c.liveUpTo i) (hacc (hdrop hl)) (hback := hback)
      (hexit := hexit)
  · have hb1 : c.X.cand ⟨i, hi8⟩ = true := by
      rw [and_bit_iff _ (by omega), hcm] at hbr; simpa using hbr
    block_init
    step_pure
    step_pure
    finish_block
    · -- a bad `A`
      rw [and_bit_iff _ (by omega)] at hbr
      have hst : c.stores i = true := by simp [Call.stores, hi8, hb1, hbr]
      have hcode : c.code1 i = 4294967294#32 := by simp [Call.code1, hi8, hb1, hbr]; rfl
      have hl : c.X.liveAt i = false := by simp [X8.liveAt, hi8, Call.live_eq, hbr]
      block_init
      step_pure [hmod64, gep_value (f := { nuw := true }) hov (Or.inl rfl)]
      step_store
      finish_block
      have hS2 : (⟨A, c.scalarMem M (i + 1)⟩ : GlobalState) = S := by
        rw [hS, c.scalarMem_succ_store hst, hcode]
      rw [hS2] at hback hexit
      rw [hdrop hl] at hback
      step_loop using bb61_run c hc as rs i hi (c.liveUpTo i) (hacc (hdrop hl)) (hback := hback)
        (hexit := hexit)
    · have hb2 : c.X.aValid.getLsbD i = true := by
        rw [and_bit_iff _ (by omega)] at hbr; simpa using hbr
      block_init
      step_pure
      step_pure
      finish_block
      · -- a bad `R`
        rw [and_bit_iff _ (by omega)] at hbr
        have hst : c.stores i = true := by simp [Call.stores, hi8, hb1, hbr]
        have hcode : c.code1 i = 4294967295#32 := by simp [Call.code1, hi8, hb1, hb2, hbr]; rfl
        have hl : c.X.liveAt i = false := by simp [X8.liveAt, hi8, Call.live_eq, hbr]
        block_init
        step_pure [hmod64, gep_value (f := { nuw := true }) hov (Or.inl rfl)]
        step_store
        finish_block
        have hS2 : (⟨A, c.scalarMem M (i + 1)⟩ : GlobalState) = S := by
          rw [hS, c.scalarMem_succ_store hst, hcode]
        rw [hS2] at hback hexit
        rw [hdrop hl] at hback
        step_loop using bb61_run c hc as rs i hi (c.liveUpTo i) (hacc (hdrop hl)) (hback := hback)
          (hexit := hexit)
      · have hb3 : c.X.rValid.getLsbD i = true := by
          rw [and_bit_iff _ (by omega)] at hbr; simpa using hbr
        block_init
        step_pure
        step_pure
        finish_block
        · -- valid: live unless `R` is of small order
          rw [and_bit_iff _ (by omega)] at hbr
          have hst : c.stores i = false := by simp [Call.stores, hi8, hb1, hb2, hb3, hbr]
          block_init
          step_pure
          step_pure
          step_pure
          step_pure
          finish_block
          have hlive :
              (if 1#32 <<< i &&& c.X.rSmall = 0#32 then 1#32 <<< i else 0#32) ||| c.liveUpTo i =
                c.liveUpTo (i + 1) := by
            simp only [Call.liveUpTo, and_bit_iff _ (show i < 32 by omega), X8.liveAt, hi8,
              dite_true, Call.live_eq, hb1, hb2, hb3, hbr]
            cases c.X.rSmall.getLsbD i <;> rfl
          rw [c.scalarMem_succ_keep hst, ← hSA] at hback hexit
          step_loop using bb61_run c hc as rs i hi (c.liveUpTo (i + 1))
            (fun h => h ▸ c.liveUpTo_cnt hc) (hback := hback) (hexit := hexit)
        · -- a small-order `A`
          have hb4 : c.X.aSmall.getLsbD i = true := by
            rw [and_bit_iff _ (by omega)] at hbr; simpa using hbr
          have hst : c.stores i = true := by simp [Call.stores, hi8, hb1, hb4]
          have hcode : c.code1 i = 4294967294#32 := by
            simp [Call.code1, hi8, hb1, hb2, hb3, hb4]; rfl
          have hl : c.X.liveAt i = false := by simp [X8.liveAt, hi8, Call.live_eq, hb4]
          block_init
          step_pure [hmod64, gep_value (f := { nuw := true }) hov (Or.inl rfl)]
          step_store
          finish_block
          have hS2 : (⟨A, c.scalarMem M (i + 1)⟩ : GlobalState) = S := by
            rw [hS, c.scalarMem_succ_store hst, hcode]
          rw [hS2] at hback hexit
          rw [hdrop hl] at hback
          step_loop using bb61_run c hc as rs i hi (c.liveUpTo i) (hacc (hdrop hl))
            (hback := hback) (hexit := hexit)

/-- The scalar loop from item `i`, `n + 1` items left: on to `^bb52` with every item's code stored
and `live`. -/
theorem scalar_loop (c : Call) (hc : c.Ok) (as rs : BitVec 32) (has : as = c.X.aSmall)
    (hrs : rs = c.X.rSmall) (A : AllocState) (M : MemoryState)
    (hroom : ∀ j < c.cnt, Room M (c.a.result j) 32) :
    ∀ n i (E : ⟪Γ⟫) (S : GlobalState), i + n + 1 = c.cnt → S = ⟨A, c.scalarMem M i⟩ →
      E.args = c.args → EnvL c as rs E →
      (E ⊨ [rir_reg% hty 2042 := PoisonOr.value (BitVec.ofNat 64 i),
        rir_reg% hty 2043 := PoisonOr.value (c.liveUpTo i)]) →
      (∀ E' : ⟪Γ⟫, E'.args = c.args → Env62 c E' →
        ((verify_x8 c.batch).runFrom E' 52 ⟨A, c.scalarMem M c.cnt⟩ >>= g) = K) →
      ((verify_x8 c.batch).runFrom E 53 S >>= g) = K := by
  intro n
  induction n with
  | zero =>
    intro i E S hn hS hA hL hI hK
    refine trip c hc as rs has hrs A M hroom i (by omega) E S hS hA hL hI
      (fun h => absurd h (by omega)) fun h E' h1 h2 => ?_
    rw [h]
    exact hK E' h1 h2
  | succ n ih =>
    intro i E S hn hS hA hL hI hK
    exact trip c hc as rs has hrs A M hroom i (by omega) E S hS hA hL hI
      (fun _ E' h1 h2 h3 => ih (i + 1) E' _ (by omega) rfl h1 h2 h3 hK)
      fun h => absurd h (by omega)

set_option maxHeartbeats 2000000 in
-- the lane-wise steps: each of the eight lanes' masks over the four checks
/-- `cnt = 8` (`^bb43 … ^bb50`): the eight-lane loop once, its three masked stores of the codes and
`live`, on to `^bb52`; the sixteen-lane loop needs `cnt ≥ 32`. -/
theorem vector_run (c : Call) (hc : c.Ok) (hcnt : c.cnt = 8) (S₀ : GlobalState)
    (hS42 : c.At42 S₀) (as rs : BitVec 32) (has : as = c.X.aSmall) (hrs : rs = c.X.rSmall)
    (E : ⟪Γ⟫) (S : GlobalState) (hSA : S = ⟨⟨S₀.alloc.nextFreeBlock + 6 + 6⟩, c.endMem S₀.mem⟩)
    (hA : E.args = c.args) (hE : EnvV c as rs E)
    (h62 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env62 c E' → c.At62 S' →
        c.liveMask ≠ 0 → ((verify_x8 c.batch).runFrom E' 62 S' >>= g) = K)
    (h102 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env102 c E' → c.Base S' c.mem62 →
        c.liveMask = 0 → ((verify_x8 c.batch).runFrom E' 102 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 43 S >>= g) = K := by
  have hroom : ∀ j < c.cnt, Room (c.endMem S₀.mem) (c.a.result j) 32 :=
    fun _ hj => c.room_result hc hS42 hj
  have h38 : (c.endMem S₀.mem).eraseFrom c.s.alloc.nextFreeBlock = c.mem38 := by
    rw [c.eraseFrom_endMem, hS42.base.mem]
  have h32 : (BitVec.ofNat 64 c.cnt).ult 32#64 = true := by rw [hcnt]; decide
  have hand : BitVec.ofNat 64 c.cnt &&& 18446744073709551608#64 = 8#64 := by rw [hcnt]; decide
  split_reads hE
  show ((verify_x8 c.batch).runFrom E ⟨43, (by decide : 43 < 104)⟩ S >>= g) = K
  block_init
  step_pure
  finish_block
  block_init
  iterate 16 step_pure [hand, or_lanes8, live0_lanes8]
  finish_block
  block_init
  iterate 14 step_pure [shl_lanes8, ite_value, expandOfFn]
  step_pure
  step_pattern using runBodyFrom_maskedStoreRun
    (hroom := c.room_lanes hc hcnt (fun j hj => by rw [hSA]; exact hroom j hj) _)
  iterate 3 step_pure [ite_value, expandOfFn]
  step_pattern using runBodyFrom_maskedStoreRun
    (hroom := c.room_lanes hc hcnt (fun j hj => by rw [hS]; exact (hroom j hj).maskedStoreAt) _)
  step_pure [ite_value, expandOfFn]
  step_pattern using runBodyFrom_maskedStoreRun
    (hroom := c.room_lanes hc hcnt
      (fun j hj => by rw [hS]; exact (hroom j hj).maskedStoreAt.maskedStoreAt) _)
  iterate 10 step_pure [ite_value, expandOfFn]
  finish_block
  block_init
  step_pure
  step_pure
  have h8eq : BitVec.ofNat 64 c.cnt = 8#64 := by rw [hcnt]
  finish_block
  have hne : ¬c.a.results.id ≠ c.a.results.id := fun h => h rfl
  step_loop using bb52_run c (h62 := h62) (h102 := h102)
  all_goals first
    | exact or_lanes_maskOf c.X.live (fun j => c.liveP j j.isLt) fun j => c.live_lane j j.isLt
    | refine c.at62_of hc hS42
        ((((MemoryState.StoresOff.refl (K := (· ≠ c.a.results.id)) _).maskedStoreAt hne _
          _).maskedStoreAt hne _ _).maskedStoreAt hne _ _)
        (c.eraseFrom_masked hc h38 hcnt fun j hj => ?_)
      interval_cases j <;> exact c.code1_lane _ (by decide)

/-- The checks: on to the hashes with `live`, or, with no live item, to the return. -/
public theorem checks_run (c : Call) (hc : c.Ok) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : Env42 c E) (hS : c.At42 S)
    (h62 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env62 c E' → c.At62 S' →
        c.liveMask ≠ 0 → ((verify_x8 c.batch).runFrom E' 62 S' >>= g) = K)
    (h102 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env102 c E' → c.Base S' c.mem62 →
        c.liveMask = 0 → ((verify_x8 c.batch).runFrom E' 102 S' >>= g) = K) :
    ((verify_x8 c.batch).runFrom E 42 S >>= g) = K := by
  have hwf := hS.base.wf
  have ha := hS.a.fit
  have hr := hS.r.fit
  have h3 := hc.cnt3
  have h8 := hc.cnt8
  obtain ⟨S₀, hS₀⟩ : ∃ S₀, S₀ = S := ⟨S, rfl⟩
  rw [← hS₀] at hS
  have hS42 := hS
  clear hS
  have hroom : ∀ j < c.cnt, Room (c.endMem S₀.mem) (c.a.result j) 32 :=
    fun _ hj => c.room_result hc hS42 hj
  have h38 : (c.endMem S₀.mem).eraseFrom c.s.alloc.nextFreeBlock = c.mem38 := by
    rw [c.eraseFrom_endMem, hS42.base.mem]
  have has0 : smallOrder order8Y0 order8Y1 (S₀.mem.readLanePoint (c.s.slot 28)) = c.X.aSmall := by
    rw [hS42.a.read]; rfl
  have hrs0 : smallOrder order8Y0 order8Y1 (S₀.mem.readLanePoint (c.s.slot 29)) = c.X.rSmall := by
    rw [hS42.r.read]; rfl
  split_reads hE
  block_init
  iterate 10 step_pure
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_small_order.call_eq with as
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_small_order.call_eq with rs
  have has' : as = c.X.aSmall := by rw [has, ← hS₀, has0]
  have hrs' : rs = c.X.rSmall := by rw [hrs, ← hS₀, hrs0]
  have hS1 :
      S = ⟨⟨S₀.alloc.nextFreeBlock + 6 + 6⟩, c.scalarMem (c.endMem S₀.mem) 0⟩ := by
    rw [hS, hS₀]; rfl
  clear hwf ha hr
  step_pure
  finish_block
  · -- `cnt < 8`: the scalar loop
    block_init
    finish_block
    step_loop using scalar_loop c hc as rs has' hrs' ⟨S₀.alloc.nextFreeBlock + 6 + 6⟩
      (c.endMem S₀.mem) hroom (c.cnt - 1) 0
    intro hE62
    refine bb52_run c E₀ S hArgs₀ hE62 ?_ h62 h102
    rw [hS]
    refine c.at62_of hc hS42 (c.storesOff_scalarMem _ _) ?_
    rw [c.eraseFrom_scalarMem hc h38 le_rfl, Call.mem62]
    exact storeResults_congr fun j hj => by simp [hj]
  · -- `cnt = 8`: the eight-lane loop, once; the sixteen-lane one needs `cnt ≥ 32`
    have hcnt : c.cnt = 8 := by
      simp only [BitVec.ult, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_lt] at hbr
      have : c.cnt % 2 ^ 64 = c.cnt := Nat.mod_eq_of_lt (by omega)
      omega
    have hS1' : S = ⟨⟨S₀.alloc.nextFreeBlock + 6 + 6⟩, c.endMem S₀.mem⟩ := hS1
    clear hS1
    step_loop using vector_run c hc hcnt S₀ hS42 as rs has' hrs' (h62 := h62) (h102 := h102)

end Proof

end MLIR.Firedancer.Lane.VerifyX8
