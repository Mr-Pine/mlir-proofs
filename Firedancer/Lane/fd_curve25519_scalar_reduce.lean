module

public import Firedancer.Lane.Mlir.fd_curve25519_scalar_reduce
public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import MLIR.Run.Tactic
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.Lane

open Firedancer.Lane.Mlir
open Ref (Bnd nswAdd nswSub nswMul nuwAdd nuwMul lshrNonneg)

/-! `fd_curve25519_scalar_reduce`'s compiled code loads the 64 input bytes as overlapping
`<4 x i64>` and `<2 x i64>`, unpacks the limbs and folds the high ones down partly in lanes
(`vector.reduce.add` of lane products), with the C's sums reassociated, and stores the four packed
words as one `<4 x i64>`. Its runs `runK` step the instructions from the `K`-th in continuation
form: each value is named after the C variable it equals (`tN` for `%N` otherwise) and bounded
(`Bnd`) to discharge its `nsw`/`nuw` flags. Each `x_eq` restates a carry or a packed limb `x` over
the earlier carries and the input words as the spec's lets expand, the masked carries as
`carry <<< 21`; `pack_eq` restates the stored lanes as the spec's
`out3 ++ (out2 ++ (out1 ++ out0))`. Substituted, the result is the spec by `rfl`. -/

/-! ## Staged for Common -/

/-- An `and` with all ones, as the compiled code masks a lane it keeps. -/
theorem and_ones (x : BitVec 64) : x &&& 18446744073709551615#64 = x := by bv_decide

/-- A loaded `<4 x i64>` lane: 64 bits of the input. -/
theorem extractVecElem_four (x : BitVec 512) (o : Nat) (i : Fin 4) :
    Ty.extractVecElem 4 64 i (x.extractLsb' o 256) = x.extractLsb' (o + i.val * 64) 64 := by
  rw [Ty.extractVecElem_eq]
  ext k hk
  simp only [BitVec.getElem_extractLsb']
  grind

/-- A loaded `<4 x i64>` lane at the input's start. -/
theorem extractVecElem_four_setWidth (x : BitVec 512) (i : Fin 4) :
    Ty.extractVecElem 4 64 i (x.setWidth 256) = x.extractLsb' (i.val * 64) 64 := by
  rw [Ty.extractVecElem_eq]
  ext k hk
  simp only [BitVec.getElem_extractLsb']
  grind

/-- A loaded `<2 x i64>` lane: 64 bits of the input. -/
theorem extractVecElem_two (x : BitVec 512) (o : Nat) (i : Fin 2) :
    Ty.extractVecElem 2 64 i (x.extractLsb' o 128) = x.extractLsb' (o + i.val * 64) 64 := by
  rw [Ty.extractVecElem_eq]
  ext k hk
  simp only [BitVec.getElem_extractLsb']
  grind

/-- Four lanes' bits, lane 0 lowest. -/
theorem packLanes_four (a b c d : BitVec 64) :
    BitVec.packLanes #v[a, b, c, d] = (d ++ (c ++ (b ++ a))).cast (by decide) := by
  have key (k : Nat) (hk : k < 4) (j : Nat) (hj : j < 64) :
    (BitVec.packLanes #v[a, b, c, d]).getLsbD (k * 64 + j) = #v[a, b, c, d][k].getLsbD j := by
    rw [← BitVec.extractLsb'_packLanes #v[a, b, c, d] k hk, BitVec.getLsbD_extractLsb']
    simp [hj]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := key (i / 64) (by omega) (i % 64) (by omega)
  rw [show i / 64 * 64 + i % 64 = i by omega] at hk
  rw [hk, BitVec.getLsbD_cast]
  obtain h | h | h | h : i / 64 = 0 ∨ i / 64 = 1 ∨ i / 64 = 2 ∨ i / 64 = 3 := by omega
  all_goals
    simp only [h, BitVec.getLsbD_append, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ]
    grind

/-! ## Proof -/

section Proof

/-! ### The lanes `or disjoint` joins share no bit -/

theorem fd_curve25519_scalar_reduce.disj0 (s0_5 s1_9 : BitVec 64) :
    s1_9 <<< 21 &&& 4398044413952#64 &&& (s0_5 &&& 2097151#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj1 (s3_11 s4_12 : BitVec 64) :
    s4_12 <<< 20 &&& 2199022206976#64 &&& (s3_11 >>> 1 &&& 1048575#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj2 (s6_12 s7_13 : BitVec 64) :
    s7_13 <<< 19 &&& 1099511103488#64 &&& (s6_12 >>> 2 &&& 524287#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj3 (s0_5 s1_9 s2_10 : BitVec 64) :
    s2_10 <<< 42 &&& 9223367638808264704#64 &&&
        (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj4 (s3_11 s4_12 s5_13 : BitVec 64) :
    s5_13 <<< 41 &&& 4611683819404132352#64 &&&
        (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj5 (s6_12 s7_13 s8_13 : BitVec 64) :
    s8_13 <<< 40 &&& 2305841909702066176#64 &&&
        (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj6 (s9_13 s10_13 : BitVec 64) :
    s9_13 >>> 3 &&& 262143#64 &&& (s10_13 <<< 18 &&& 549755551744#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj7 (s0_5 s1_9 s2_10 s3_11 : BitVec 64) :
    (s2_10 <<< 42 &&& 9223367638808264704#64 |||
          (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64)) &&&
        s3_11 <<< 63 =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj8 (s3_11 s4_12 s5_13 s6_12 : BitVec 64) :
    (s5_13 <<< 41 &&& 4611683819404132352#64 |||
          (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64)) &&&
        s6_12 <<< 62 =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj9 (s6_12 s7_13 s8_13 s9_13 : BitVec 64) :
    (s8_13 <<< 40 &&& 2305841909702066176#64 |||
          (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64)) &&&
        s9_13 <<< 61 =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj10 (s9_13 s10_13 t444 : BitVec 64) :
    (s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64) &&& t444 <<< 39 = 0#64 := by
  bv_decide

/-- The constants the code reads after loading the input. -/
abbrev fd_curve25519_scalar_reduce.Consts (E : ⟪fd_curve25519_scalar_reduce.Γ⟫) : Prop :=
  E ⊨ [%0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64], %1 :=
    Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64], %2 :=
    Ty.wrap #v[21#64, 20#64, 19#64, 18#64], %3 :=
    Ty.wrap #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64],
    %4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64], %5 := Vector.replicate 4 PoisonOr.poison, %6 :=
    Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64], %7 := Ty.wrap #v[0#64, 1#64, 2#64, 0#64],
    %11 := 40#64, %12 := 0#64, %13 := 2097151#64, %14 := 21#64, %15 := 42#64, %16 :=
    Ty.wrap #v[1#64, 2#64, 3#64, 4#64], %17 := 20#64, %18 := 41#64, %19 := 1#64, %20 := 19#64,
    %21 := 2#64, %22 := 18#64, %23 := 39#64, %24 := 3#64, %25 := 17#64, %26 := 38#64, %27 := 5#64,
    %28 := 16#64, %29 := 37#64, %30 := Ty.wrap #v[6#64, 7#64], %31 := Ty.wrap #v[15#64, 14#64],
    %32 := Ty.wrap (Vector.replicate 4 2097151#64), %33 := Vector.replicate 2 PoisonOr.poison,
    %34 := Ty.wrap #v[35#64, 36#64, 0#64, 0#64], %35 :=
    Ty.wrap
      #v[18446744073709551615#64, 2097151#64, 18446744073709551615#64, 18446744073709551615#64],
    %36 := 666643#64, %37 := 470296#64, %38 :=
    Ty.wrap #v[654183#64, 18446744073708867715#64, 18446744073708553811#64, 136657#64], %39 :=
    18446744073708553811#64, %40 := 136657#64, %41 := 18446744073708867715#64, %42 := 654183#64,
    %43 := Ty.wrap #v[136657#64, 18446744073708867715#64, 654183#64, 18446744073708553811#64],
    %44 := Ty.wrap #v[136657#64, 18446744073708867715#64, 470296#64, 654183#64], %45 := 1048576#64,
    %46 := 8796090925056#64, %47 := 9223372036852678656#64, %48 := 18446744073707454464#64, %56 :=
    (Vector.replicate 4 PoisonOr.poison).set 3 (PoisonOr.value 18446744073709551615#64) (by decide)]

/-! ### The walk -/

/-- From `%0`: the constants, and the input's first five words `in0 … in4`, loaded as two
overlapping `<4 x i64>`. -/
theorem fd_curve25519_scalar_reduce.run0 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 0 = fd_curve25519_scalar_reduce.entry.body.drop 0)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) (hwf : S.WF)
    (hin : Fits S.mem inp (8 * 64)) (hin_off : ¬inp.offset.uaddOverflow 64#64)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (in0 in1 in2 in3 in4 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 58 := inp.add 40#64,
              rir_reg% fd_curve25519_scalar_reduce.hty 59 := inp.add 48#64,
              rir_reg% fd_curve25519_scalar_reduce.hty 60 := Ty.wrap #v[in0, in1, in2, in3],
              rir_reg% fd_curve25519_scalar_reduce.hty 61 := Ty.wrap #v[in1, in2, in3, in4]]) →
          (hin0 : in0 = (S.mem.readAt inp 512).extractLsb' 0 64) →
          (hin1 : in1 = (S.mem.readAt inp 512).extractLsb' 64 64) →
          (hin2 : in2 = (S.mem.readAt inp 512).extractLsb' 128 64) →
          (hin3 : in3 = (S.mem.readAt inp 512).extractLsb' 192 64) →
          (hin4 : in4 = (S.mem.readAt inp 512).extractLsb' 256 64) →
          (blk.runBodyFrom E' 62 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  iterate 60 step_pure
  step_load [expandOfFn, extractVecElem_four, extractVecElem_four_setWidth] with t60
  step_load [expandOfFn, extractVecElem_four] with t61
  subst hS
  exact
    hK _ ((S.mem.readAt inp 512).extractLsb' 0 64) ((S.mem.readAt inp 512).extractLsb' 64 64)
      ((S.mem.readAt inp 512).extractLsb' 128 64) ((S.mem.readAt inp 512).extractLsb' 192 64)
      ((S.mem.readAt inp 512).extractLsb' 256 64) hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        rw [← ht60, ← ht61]; env_reads)
      rfl rfl rfl rfl rfl

/-- From `%62`: `in0 … in4` unpacked into the limbs `s0 … s14`. -/
theorem fd_curve25519_scalar_reduce.run62 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 62 = fd_curve25519_scalar_reduce.entry.body.drop 62)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in0 in1 in2 in3 in4 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 58 := inp.add 40#64,
        rir_reg% fd_curve25519_scalar_reduce.hty 59 := inp.add 48#64,
        rir_reg% fd_curve25519_scalar_reduce.hty 60 := Ty.wrap #v[in0, in1, in2, in3],
        rir_reg% fd_curve25519_scalar_reduce.hty 61 := Ty.wrap #v[in1, in2, in3, in4]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s0 t64 s1 t66 s2 t69 s3 t72 s4 t74 s5 t76 s6 t79 s7 t81 s8 t83 s9 t86 s10 t88 s11 t90 s12
          t93 s13 t95 s14 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 58 := inp.add 40#64,
              rir_reg% fd_curve25519_scalar_reduce.hty 59 := inp.add 48#64,
              rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 77 := s6,
              rir_reg% fd_curve25519_scalar_reduce.hty 80 := s7,
              rir_reg% fd_curve25519_scalar_reduce.hty 82 := s8,
              rir_reg% fd_curve25519_scalar_reduce.hty 84 := s9,
              rir_reg% fd_curve25519_scalar_reduce.hty 87 := s10,
              rir_reg% fd_curve25519_scalar_reduce.hty 89 := s11,
              rir_reg% fd_curve25519_scalar_reduce.hty 91 := s12,
              rir_reg% fd_curve25519_scalar_reduce.hty 92 := in4,
              rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
              rir_reg% fd_curve25519_scalar_reduce.hty 96 := s14]) →
          (hs0 : s0 = in0 &&& 2097151#64) →
          (ht64 : t64 = in0 >>> 21) →
          (hs1 : s1 = t64 &&& 2097151#64) →
          (ht66 : t66 = in0 >>> 42) →
          (hs2 : s2 = t66 &&& 2097151#64) →
          (ht69 : t69 = BitVec.extractLsb' 64 64 ((in1 ++ in0) <<< 1)) →
          (hs3 : s3 = t69 &&& 2097151#64) →
          (ht72 : t72 = in1 >>> 20) →
          (hs4 : s4 = t72 &&& 2097151#64) →
          (ht74 : t74 = in1 >>> 41) →
          (hs5 : s5 = t74 &&& 2097151#64) →
          (ht76 : t76 = BitVec.extractLsb' 64 64 ((in2 ++ in1) <<< 2)) →
          (hs6 : s6 = t76 &&& 2097151#64) →
          (ht79 : t79 = in2 >>> 19) →
          (hs7 : s7 = t79 &&& 2097151#64) →
          (ht81 : t81 = in2 >>> 40) →
          (hs8 : s8 = t81 &&& 2097151#64) →
          (ht83 : t83 = BitVec.extractLsb' 64 64 ((in3 ++ in2) <<< 3)) →
          (hs9 : s9 = t83 &&& 2097151#64) →
          (ht86 : t86 = in3 >>> 18) →
          (hs10 : s10 = t86 &&& 2097151#64) →
          (ht88 : t88 = in3 >>> 39) →
          (hs11 : s11 = t88 &&& 2097151#64) →
          (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4)) →
          (hs12 : s12 = t90 &&& 2097151#64) →
          (ht93 : t93 = in4 >>> 17) →
          (hs13 : s13 = t93 &&& 2097151#64) →
          (ht95 : t95 = in4 >>> 38) →
          (hs14 : s14 = t95 &&& 2097151#64) →
          (hbs5 : Bnd s5 0 2097151) →
          (hbs6 : Bnd s6 0 2097151) →
          (hbs7 : Bnd s7 0 2097151) →
          (hbs8 : Bnd s8 0 2097151) →
          (hbs9 : Bnd s9 0 2097151) →
          (hbs10 : Bnd s10 0 2097151) →
          (hbs11 : Bnd s11 0 2097151) →
          (hbs12 : Bnd s12 0 2097151) →
          (hbs13 : Bnd s13 0 2097151) →
          (hbs14 : Bnd s14 0 2097151) → (blk.runBodyFrom E' 97 S >>= g) = K) :
    (blk.runBodyFrom E 62 S >>= g) = K := by
  step_pure
  step_pure with s0
  bnd s0
  step_pure with t64
  bnd t64
  step_pure with s1
  bnd s1
  step_pure with t66
  bnd t66
  step_pure with s2
  bnd s2
  step_pure [expandOfFn] with t68
  step_pure [ht68] with t69
  bnd t69
  step_pure with s3
  bnd s3
  step_pure
  step_pure with t72
  bnd t72
  step_pure with s4
  bnd s4
  step_pure with t74
  bnd t74
  step_pure with s5
  bnd s5
  step_pure [ht68] with t76
  bnd t76
  step_pure with s6
  bnd s6
  step_pure
  step_pure with t79
  bnd t79
  step_pure with s7
  bnd s7
  step_pure with t81
  bnd t81
  step_pure with s8
  bnd s8
  step_pure [ht68] with t83
  bnd t83
  step_pure with s9
  bnd s9
  step_pure
  step_pure with t86
  bnd t86
  step_pure with s10
  bnd s10
  step_pure with t88
  bnd t88
  step_pure with s11
  bnd s11
  step_pure [ht68] with t90
  bnd t90
  step_pure with s12
  bnd s12
  step_pure
  step_pure with t93
  bnd t93
  step_pure with s13
  bnd s13
  step_pure with t95
  bnd t95
  step_pure with s14
  bnd s14
  exact
    hK _ s0 t64 s1 t66 s2 t69 s3 t72 s4 t74 s5 t76 s6 t79 s7 t81 s8 t83 s9 t86 s10 t88 s11 t90 s12
      t93 s13 t95 s14 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hs0 ht64 hs1 ht66 hs2 ht69 hs3 ht72 hs4 ht74 hs5 ht76 hs6 ht79 hs7 ht81 hs8
      ht83 hs9 ht86 hs10 ht88 hs11 ht90 hs12 ht93 hs13 ht95 hs14 hbs5 hbs6 hbs7 hbs8 hbs9 hbs10
      hbs11 hbs12 hbs13 hbs14

/-- From `%97`: `in5 … in7`, loaded as two overlapping `<2 x i64>`. -/
theorem fd_curve25519_scalar_reduce.run97 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 97 = fd_curve25519_scalar_reduce.entry.body.drop 97)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in4 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) (hwf : S.WF)
    (hin : Fits S.mem inp (8 * 64)) (hin_off : ¬inp.offset.uaddOverflow 64#64)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 58 := inp.add 40#64,
        rir_reg% fd_curve25519_scalar_reduce.hty 59 := inp.add 48#64,
        rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 77 := s6,
        rir_reg% fd_curve25519_scalar_reduce.hty 80 := s7,
        rir_reg% fd_curve25519_scalar_reduce.hty 82 := s8,
        rir_reg% fd_curve25519_scalar_reduce.hty 84 := s9,
        rir_reg% fd_curve25519_scalar_reduce.hty 87 := s10,
        rir_reg% fd_curve25519_scalar_reduce.hty 89 := s11,
        rir_reg% fd_curve25519_scalar_reduce.hty 91 := s12,
        rir_reg% fd_curve25519_scalar_reduce.hty 92 := in4,
        rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
        rir_reg% fd_curve25519_scalar_reduce.hty 96 := s14])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (in5 in6 in7 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 77 := s6,
              rir_reg% fd_curve25519_scalar_reduce.hty 80 := s7,
              rir_reg% fd_curve25519_scalar_reduce.hty 82 := s8,
              rir_reg% fd_curve25519_scalar_reduce.hty 84 := s9,
              rir_reg% fd_curve25519_scalar_reduce.hty 87 := s10,
              rir_reg% fd_curve25519_scalar_reduce.hty 89 := s11,
              rir_reg% fd_curve25519_scalar_reduce.hty 91 := s12,
              rir_reg% fd_curve25519_scalar_reduce.hty 92 := in4,
              rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
              rir_reg% fd_curve25519_scalar_reduce.hty 96 := s14,
              rir_reg% fd_curve25519_scalar_reduce.hty 97 := Ty.wrap #v[in5, in6],
              rir_reg% fd_curve25519_scalar_reduce.hty 98 := Ty.wrap #v[in6, in7]]) →
          (hin5 : in5 = (S.mem.readAt inp 512).extractLsb' 320 64) →
          (hin6 : in6 = (S.mem.readAt inp 512).extractLsb' 384 64) →
          (hin7 : in7 = (S.mem.readAt inp 512).extractLsb' 448 64) →
          (blk.runBodyFrom E' 99 S >>= g) = K) :
    (blk.runBodyFrom E 97 S >>= g) = K := by
  step_load [expandOfFn, extractVecElem_two] with t97
  step_load [expandOfFn, extractVecElem_two] with t98
  subst hS
  exact
    hK _ ((S.mem.readAt inp 512).extractLsb' 320 64) ((S.mem.readAt inp 512).extractLsb' 384 64)
      ((S.mem.readAt inp 512).extractLsb' 448 64) hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        rw [← ht97, ← ht98]; env_reads)
      rfl rfl rfl

/-- From `%99`: `in5 … in7` unpacked into `s15 … s23`, partly in lanes, and the folding of
`s18 … s23` begun. -/
theorem fd_curve25519_scalar_reduce.run99 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 99 = fd_curve25519_scalar_reduce.entry.body.drop 99)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in4 in5 in6 in7 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 77 := s6,
        rir_reg% fd_curve25519_scalar_reduce.hty 80 := s7,
        rir_reg% fd_curve25519_scalar_reduce.hty 82 := s8,
        rir_reg% fd_curve25519_scalar_reduce.hty 84 := s9,
        rir_reg% fd_curve25519_scalar_reduce.hty 87 := s10,
        rir_reg% fd_curve25519_scalar_reduce.hty 89 := s11,
        rir_reg% fd_curve25519_scalar_reduce.hty 91 := s12,
        rir_reg% fd_curve25519_scalar_reduce.hty 92 := in4,
        rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
        rir_reg% fd_curve25519_scalar_reduce.hty 96 := s14,
        rir_reg% fd_curve25519_scalar_reduce.hty 97 := Ty.wrap #v[in5, in6],
        rir_reg% fd_curve25519_scalar_reduce.hty 98 := Ty.wrap #v[in6, in7]])
    (hbs14 : Bnd s14 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (t100 s15 t102 s16 t104 s17 : BitVec 64)
        (t109 : Vector (BitVec 64) 4) (s22 s21 : BitVec 64) (t115 : Vector (BitVec 64) 4)
        (s23 t117 t118 : BitVec 64) (t119 : Vector (BitVec 64) 4)
        (t120 s14_1 t122 s15_1 t124 s16_1 t126 t127 s14_2 t129 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 77 := s6,
              rir_reg% fd_curve25519_scalar_reduce.hty 80 := s7,
              rir_reg% fd_curve25519_scalar_reduce.hty 82 := s8,
              rir_reg% fd_curve25519_scalar_reduce.hty 84 := s9,
              rir_reg% fd_curve25519_scalar_reduce.hty 87 := s10,
              rir_reg% fd_curve25519_scalar_reduce.hty 89 := s11,
              rir_reg% fd_curve25519_scalar_reduce.hty 91 := s12,
              rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
              rir_reg% fd_curve25519_scalar_reduce.hty 105 := s17,
              rir_reg% fd_curve25519_scalar_reduce.hty 109 := Ty.wrap t109,
              rir_reg% fd_curve25519_scalar_reduce.hty 111 := s21,
              rir_reg% fd_curve25519_scalar_reduce.hty 115 := Ty.wrap t115,
              rir_reg% fd_curve25519_scalar_reduce.hty 117 := t117,
              rir_reg% fd_curve25519_scalar_reduce.hty 118 := t118,
              rir_reg% fd_curve25519_scalar_reduce.hty 119 := Ty.wrap t119,
              rir_reg% fd_curve25519_scalar_reduce.hty 123 := s15_1,
              rir_reg% fd_curve25519_scalar_reduce.hty 125 := s16_1,
              rir_reg% fd_curve25519_scalar_reduce.hty 126 := t126,
              rir_reg% fd_curve25519_scalar_reduce.hty 128 := s14_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 129 := t129]) →
          (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) →
          (hs15 : s15 = t100 &&& 2097151#64) →
          (ht102 : t102 = in5 >>> 16) →
          (hs16 : s16 = t102 &&& 2097151#64) →
          (ht104 : t104 = in5 >>> 37) →
          (hs17 : s17 = t104 &&& 2097151#64) →
          (ht109 :
            t109 =
              #v[in6 >>> 15 &&& 2097151#64,
                BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64,
                in7 >>> 14 &&& 2097151#64,
                BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64]) →
          (hs22 : s22 = in7 >>> 14 &&& 2097151#64) →
          (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) →
          (ht115 :
            t115 =
              #v[in7 >>> 35, in6 >>> 36 &&& 2097151#64, in7 >>> 14 &&& 2097151#64,
                BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64]) →
          (hs23 : s23 = in7 >>> 35) →
          (ht117 : t117 = s23 * 666643#64) →
          (ht118 : t118 = s23 * 470296#64) →
          (ht119 :
            t119 =
              #v[in7 >>> 35 * 654183#64, (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64,
                (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64,
                (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64]) →
          (ht120 : t120 = s23 * 18446744073708553811#64) →
          (hs14_1 : s14_1 = t120 + s14) →
          (ht122 : t122 = s23 * 136657#64) →
          (hs15_1 : s15_1 = t122 + s15) →
          (ht124 : t124 = s23 * 18446744073708867715#64) →
          (hs16_1 : s16_1 = t124 + s16) →
          (ht126 : t126 = s22 * 666643#64) →
          (ht127 : t127 = s22 * 136657#64) →
          (hs14_2 : s14_2 = s14_1 + t127) →
          (ht129 : t129 = s22 * 18446744073708867715#64) →
          (hbs17 : Bnd s17 0 2097151) →
          (hbs21 : Bnd s21 0 2097151) →
          (hbt117 : Bnd t117 0 357901234721773) →
          (hbt118 : Bnd t118 0 252488241959656) →
          (hbs15_1 : Bnd s15_1 0 73367170181678) →
          (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151) →
          (hbt126 : Bnd t126 0 1398051034093) →
          (hbs14_2 : Bnd s14_2 (-535692479350355) 286592461358) →
          (hbt129 : Bnd t129 (-1434243666051) 0) → (blk.runBodyFrom E' 130 S >>= g) = K) :
    (blk.runBodyFrom E 99 S >>= g) = K := by
  step_pure
  step_pure with t100
  bnd t100
  step_pure with s15
  bnd s15
  step_pure with t102
  bnd t102
  step_pure with s16
  bnd s16
  step_pure with t104
  bnd t104
  step_pure with s17
  bnd s17
  step_pure [expandOfFn] with t106
  step_pure [expandOfFn] with t107
  step_pure [expandOfFn, ht107, ht106] with t108
  step_pure [expandOfFn, ht108] with t109
  step_pure [ht109] with s22
  bnd s22
  step_pure [ht109] with s21
  bnd s21
  step_pure [expandOfFn] with t112
  step_pure [expandOfFn, ht112, ht109] with t113
  step_pure [expandOfFn, ht113] with t114
  step_pure [expandOfFn, and_ones, ht114] with t115
  step_pure [ht114] with s23
  bnd s23
  step_pure [nswMul, nuwMul] with t117
  bnd t117
  step_pure [nswMul, nuwMul] with t118
  bnd t118
  step_pure [expandOfFn, nswMul, nuwMul, ht115] with t119
  step_pure [nswMul, nuwMul] with t120
  bnd t120
  step_pure [nswAdd, nuwAdd] with s14_1
  bnd s14_1
  step_pure [nswMul, nuwMul] with t122
  bnd t122
  step_pure [nswAdd, nuwAdd] with s15_1
  bnd s15_1
  step_pure [nswMul, nuwMul] with t124
  bnd t124
  step_pure [nswAdd, nuwAdd] with s16_1
  bnd s16_1
  step_pure [nswMul, nuwMul] with t126
  bnd t126
  step_pure [nswMul, nuwMul] with t127
  bnd t127
  step_pure [nswAdd, nuwAdd] with s14_2
  bnd s14_2
  step_pure [nswMul, nuwMul] with t129
  bnd t129
  exact
    hK _ t100 s15 t102 s16 t104 s17 t109 s22 s21 t115 s23 t117 t118 t119 t120 s14_1 t122 s15_1 t124
      s16_1 t126 t127 s14_2 t129 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht100 hs15 ht102 hs16 ht104 hs17 ht109 hs22 hs21 ht115 hs23 ht117 ht118 ht119
      ht120 hs14_1 ht122 hs15_1 ht124 hs16_1 ht126 ht127 hs14_2 ht129 hbs17 hbs21 hbt117 hbt118
      hbs15_1 hbs16_1 hbt126 hbs14_2 hbt129

/-- From `%130`: the folding of `s18 … s23` into `s6 … s15`, partly as `vector.reduce.add` of lane
products. -/
theorem fd_curve25519_scalar_reduce.run130 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 130 = fd_curve25519_scalar_reduce.entry.body.drop 130)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in5 in6 in7 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s17 : BitVec 64}
    {t109 : Vector (BitVec 64) 4} {s21 : BitVec 64} {t115 : Vector (BitVec 64) 4}
    {t117 t118 : BitVec 64} {t119 : Vector (BitVec 64) 4} {s15_1 s16_1 t126 s14_2 t129 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 77 := s6,
        rir_reg% fd_curve25519_scalar_reduce.hty 80 := s7,
        rir_reg% fd_curve25519_scalar_reduce.hty 82 := s8,
        rir_reg% fd_curve25519_scalar_reduce.hty 84 := s9,
        rir_reg% fd_curve25519_scalar_reduce.hty 87 := s10,
        rir_reg% fd_curve25519_scalar_reduce.hty 89 := s11,
        rir_reg% fd_curve25519_scalar_reduce.hty 91 := s12,
        rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
        rir_reg% fd_curve25519_scalar_reduce.hty 105 := s17,
        rir_reg% fd_curve25519_scalar_reduce.hty 109 := Ty.wrap t109,
        rir_reg% fd_curve25519_scalar_reduce.hty 111 := s21,
        rir_reg% fd_curve25519_scalar_reduce.hty 115 := Ty.wrap t115,
        rir_reg% fd_curve25519_scalar_reduce.hty 117 := t117,
        rir_reg% fd_curve25519_scalar_reduce.hty 118 := t118,
        rir_reg% fd_curve25519_scalar_reduce.hty 119 := Ty.wrap t119,
        rir_reg% fd_curve25519_scalar_reduce.hty 123 := s15_1,
        rir_reg% fd_curve25519_scalar_reduce.hty 125 := s16_1,
        rir_reg% fd_curve25519_scalar_reduce.hty 126 := t126,
        rir_reg% fd_curve25519_scalar_reduce.hty 128 := s14_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 129 := t129])
    (ht109 :
      t109 =
        #v[in6 >>> 15 &&& 2097151#64, BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64,
          in7 >>> 14 &&& 2097151#64, BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64])
    (ht115 :
      t115 =
        #v[in7 >>> 35, in6 >>> 36 &&& 2097151#64, in7 >>> 14 &&& 2097151#64,
          BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64])
    (hbs6 : Bnd s6 0 2097151) (hbs7 : Bnd s7 0 2097151) (hbs8 : Bnd s8 0 2097151)
    (hbs12 : Bnd s12 0 2097151) (hbs21 : Bnd s21 0 2097151) (hbt118 : Bnd t118 0 252488241959656)
    (hbs15_1 : Bnd s15_1 0 73367170181678) (hbs14_2 : Bnd s14_2 (-535692479350355) 286592461358)
    (hbt129 : Bnd t129 (-1434243666051) 0)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s15_2 t131 t132 t133 s14_3 s20 t136 s8_1 t138 t139 t140 s19 t142 s7_1 t144 s8_2 t146 t147
          t150 t151 s12_5 s18 t154 s6_1 t156 s7_2 t158 s8_3 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 84 := s9,
              rir_reg% fd_curve25519_scalar_reduce.hty 87 := s10,
              rir_reg% fd_curve25519_scalar_reduce.hty 89 := s11,
              rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
              rir_reg% fd_curve25519_scalar_reduce.hty 105 := s17,
              rir_reg% fd_curve25519_scalar_reduce.hty 109 := Ty.wrap t109,
              rir_reg% fd_curve25519_scalar_reduce.hty 117 := t117,
              rir_reg% fd_curve25519_scalar_reduce.hty 119 := Ty.wrap t119,
              rir_reg% fd_curve25519_scalar_reduce.hty 125 := s16_1,
              rir_reg% fd_curve25519_scalar_reduce.hty 126 := t126,
              rir_reg% fd_curve25519_scalar_reduce.hty 130 := s15_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 131 := t131,
              rir_reg% fd_curve25519_scalar_reduce.hty 132 := t132,
              rir_reg% fd_curve25519_scalar_reduce.hty 134 := s14_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 138 := t138,
              rir_reg% fd_curve25519_scalar_reduce.hty 139 := t139,
              rir_reg% fd_curve25519_scalar_reduce.hty 140 := t140,
              rir_reg% fd_curve25519_scalar_reduce.hty 146 := t146,
              rir_reg% fd_curve25519_scalar_reduce.hty 147 := t147,
              rir_reg% fd_curve25519_scalar_reduce.hty 152 := s12_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 153 := s18,
              rir_reg% fd_curve25519_scalar_reduce.hty 155 := s6_1,
              rir_reg% fd_curve25519_scalar_reduce.hty 157 := s7_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 159 := s8_3]) →
          (hs15_2 : s15_2 = s15_1 + t129) →
          (ht131 : t131 = s21 * 666643#64) →
          (ht132 : t132 = s21 * 470296#64) →
          (ht133 : t133 = s21 * 18446744073708867715#64) →
          (hs14_3 : s14_3 = s14_2 + t133) →
          (hs20 : s20 = in6 >>> 36 &&& 2097151#64) →
          (ht136 : t136 = s20 * 666643#64) →
          (hs8_1 : s8_1 = t136 + s8) →
          (ht138 : t138 = s20 * 470296#64) →
          (ht139 : t139 = s20 * 654183#64) →
          (ht140 : t140 = s20 * 18446744073708553811#64) →
          (hs19 : s19 = in6 >>> 15 &&& 2097151#64) →
          (ht142 : t142 = s19 * 666643#64) →
          (hs7_1 : s7_1 = t142 + s7) →
          (ht144 : t144 = s19 * 470296#64) →
          (hs8_2 : s8_2 = s8_1 + t144) →
          (ht146 : t146 = s19 * 654183#64) →
          (ht147 : t147 = s19 * 18446744073708553811#64) →
          (ht150 :
            t150 =
              (in6 >>> 36 &&& 2097151#64) * 136657#64 +
                (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
                (in7 >>> 14 &&& 2097151#64) * 654183#64 +
                (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) *
                  18446744073708553811#64) →
          (ht151 : t151 = t150 + t118) →
          (hs12_5 : s12_5 = t151 + s12) →
          (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64) →
          (ht154 : t154 = s18 * 666643#64) →
          (hs6_1 : s6_1 = t154 + s6) →
          (ht156 : t156 = s18 * 470296#64) →
          (hs7_2 : s7_2 = s7_1 + t156) →
          (ht158 : t158 = s18 * 654183#64) →
          (hs8_3 : s8_3 = s8_2 + t158) →
          (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678) →
          (hbt131 : Bnd t131 0 1398051034093) →
          (hbt132 : Bnd t132 0 986281726696) →
          (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358) →
          (hbt138 : Bnd t138 0 986281726696) →
          (hbt139 : Bnd t139 0 1371920532633) →
          (hbt140 : Bnd t140 (-2092547753555) 0) →
          (hbt146 : Bnd t146 0 1371920532633) →
          (hbt147 : Bnd t147 (-2092547753555) 0) →
          (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647) →
          (hbs18 : Bnd s18 0 2097151) →
          (hbs6_1 : Bnd s6_1 0 1398053131244) →
          (hbs7_2 : Bnd s7_2 0 2384334857940) →
          (hbs8_3 : Bnd s8_3 0 3756255390573) → (blk.runBodyFrom E' 160 S >>= g) = K) :
    (blk.runBodyFrom E 130 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd] with s15_2
  bnd s15_2
  step_pure [nswMul, nuwMul] with t131
  bnd t131
  step_pure [nswMul, nuwMul] with t132
  bnd t132
  step_pure [nswMul, nuwMul] with t133
  bnd t133
  step_pure [nswAdd, nuwAdd] with s14_3
  bnd s14_3
  step_pure [ht115] with s20
  bnd s20
  step_pure [nswMul, nuwMul] with t136
  bnd t136
  step_pure [nswAdd, nuwAdd] with s8_1
  bnd s8_1
  step_pure [nswMul, nuwMul] with t138
  bnd t138
  step_pure [nswMul, nuwMul] with t139
  bnd t139
  step_pure [nswMul, nuwMul] with t140
  bnd t140
  step_pure [ht109] with s19
  bnd s19
  step_pure [nswMul, nuwMul] with t142
  bnd t142
  step_pure [nswAdd, nuwAdd] with s7_1
  bnd s7_1
  step_pure [nswMul, nuwMul] with t144
  bnd t144
  step_pure [nswAdd, nuwAdd] with s8_2
  bnd s8_2
  step_pure [nswMul, nuwMul] with t146
  bnd t146
  step_pure [nswMul, nuwMul] with t147
  bnd t147
  step_pure [expandOfFn, ht115, ht109] with t148
  step_pure [expandOfFn, nswMul, nuwMul, ht148] with t149
  step_pure [ht149] with t150
  bnd t150
  step_pure with t151
  bnd t151
  step_pure with s12_5
  bnd s12_5
  step_pure [ht109] with s18
  bnd s18
  step_pure [nswMul, nuwMul] with t154
  bnd t154
  step_pure [nswAdd, nuwAdd] with s6_1
  bnd s6_1
  step_pure [nswMul, nuwMul] with t156
  bnd t156
  step_pure [nswAdd, nuwAdd] with s7_2
  bnd s7_2
  step_pure [nswMul, nuwMul] with t158
  bnd t158
  step_pure [nswAdd, nuwAdd] with s8_3
  bnd s8_3
  exact
    hK _ s15_2 t131 t132 t133 s14_3 s20 t136 s8_1 t138 t139 t140 s19 t142 s7_1 t144 s8_2 t146 t147
      t150 t151 s12_5 s18 t154 s6_1 t156 s7_2 t158 s8_3 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hs15_2 ht131 ht132 ht133 hs14_3 hs20 ht136 hs8_1 ht138 ht139 ht140 hs19 ht142
      hs7_1 ht144 hs8_2 ht146 ht147 ht150 ht151 hs12_5 hs18 ht154 hs6_1 ht156 hs7_2 ht158 hs8_3
      hbs15_2 hbt131 hbt132 hbs14_3 hbt138 hbt139 hbt140 hbt146 hbt147 hbs12_5 hbs18 hbs6_1 hbs7_2
      hbs8_3

/-- From `%160`: the folding's end, and `carry6`, `carry8`, `carry10` of the first carry pass. -/
theorem fd_curve25519_scalar_reduce.run160 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 160 = fd_curve25519_scalar_reduce.entry.body.drop 160)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in5 in6 in7 s0 s1 s2 s3 s4 s5 s9 s10 s11 s13 s17 : BitVec 64} {t109 : Vector (BitVec 64) 4}
    {t117 : BitVec 64} {t119 : Vector (BitVec 64) 4}
    {s16_1 t126 s15_2 t131 t132 s14_3 t138 t139 t140 t146 t147 s12_5 s18 s6_1 s7_2 s8_3 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 84 := s9,
        rir_reg% fd_curve25519_scalar_reduce.hty 87 := s10,
        rir_reg% fd_curve25519_scalar_reduce.hty 89 := s11,
        rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
        rir_reg% fd_curve25519_scalar_reduce.hty 105 := s17,
        rir_reg% fd_curve25519_scalar_reduce.hty 109 := Ty.wrap t109,
        rir_reg% fd_curve25519_scalar_reduce.hty 117 := t117,
        rir_reg% fd_curve25519_scalar_reduce.hty 119 := Ty.wrap t119,
        rir_reg% fd_curve25519_scalar_reduce.hty 125 := s16_1,
        rir_reg% fd_curve25519_scalar_reduce.hty 126 := t126,
        rir_reg% fd_curve25519_scalar_reduce.hty 130 := s15_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 131 := t131,
        rir_reg% fd_curve25519_scalar_reduce.hty 132 := t132,
        rir_reg% fd_curve25519_scalar_reduce.hty 134 := s14_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 138 := t138,
        rir_reg% fd_curve25519_scalar_reduce.hty 139 := t139,
        rir_reg% fd_curve25519_scalar_reduce.hty 140 := t140,
        rir_reg% fd_curve25519_scalar_reduce.hty 146 := t146,
        rir_reg% fd_curve25519_scalar_reduce.hty 147 := t147,
        rir_reg% fd_curve25519_scalar_reduce.hty 152 := s12_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 153 := s18,
        rir_reg% fd_curve25519_scalar_reduce.hty 155 := s6_1,
        rir_reg% fd_curve25519_scalar_reduce.hty 157 := s7_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 159 := s8_3])
    (ht109 :
      t109 =
        #v[in6 >>> 15 &&& 2097151#64, BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64,
          in7 >>> 14 &&& 2097151#64, BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64])
    (hbs9 : Bnd s9 0 2097151) (hbs10 : Bnd s10 0 2097151) (hbs11 : Bnd s11 0 2097151)
    (hbt117 : Bnd t117 0 357901234721773) (hbt126 : Bnd t126 0 1398051034093)
    (hbt131 : Bnd t131 0 1398051034093) (hbt132 : Bnd t132 0 986281726696)
    (hbt138 : Bnd t138 0 986281726696) (hbt139 : Bnd t139 0 1371920532633)
    (hbt140 : Bnd t140 (-2092547753555) 0) (hbt146 : Bnd t146 0 1371920532633)
    (hbt147 : Bnd t147 (-2092547753555) 0) (hbs18 : Bnd s18 0 2097151)
    (hbs6_1 : Bnd s6_1 0 1398053131244) (hbs7_2 : Bnd s7_2 0 2384334857940)
    (hbs8_3 : Bnd s8_3 0 3756255390573)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t160 t161 t162 t163 t164 t165 s10_5 t168 carry6 s7_3 t171 s6_2 t173 carry8 t175 t176 t177
          s9_4 s9_5 t180 s8_4 t182 carry10 t184 t185 t186 t187 s11_7 t189 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
              rir_reg% fd_curve25519_scalar_reduce.hty 105 := s17,
              rir_reg% fd_curve25519_scalar_reduce.hty 119 := Ty.wrap t119,
              rir_reg% fd_curve25519_scalar_reduce.hty 125 := s16_1,
              rir_reg% fd_curve25519_scalar_reduce.hty 130 := s15_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 134 := s14_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 152 := s12_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 166 := s10_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 172 := s6_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 181 := s8_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 188 := s11_7,
              rir_reg% fd_curve25519_scalar_reduce.hty 189 := t189]) →
          (ht160 : t160 = s18 * 18446744073708553811#64) →
          (ht161 : t161 = s18 * 136657#64) →
          (ht162 : t162 = t139 + s10) →
          (ht163 : t163 = t162 + t147) →
          (ht164 : t164 = t163 + t161) →
          (ht165 : t165 = t164 + t126) →
          (hs10_5 : s10_5 = t165 + t132) →
          (ht168 : t168 = s6_1 + 1048576#64) →
          (hcarry6 : carry6 = t168.sshiftRight 21) →
          (hs7_3 : s7_3 = s7_2 + carry6) →
          (ht171 : t171 = t168 &&& 8796090925056#64) →
          (hs6_2 : s6_2 = s6_1 - t171) →
          (ht173 : t173 = s8_3 + 1048576#64) →
          (hcarry8 : carry8 = t173.sshiftRight 21) →
          (ht175 : t175 = t138 + s9) →
          (ht176 : t176 = t175 + t146) →
          (ht177 : t177 = t176 + t160) →
          (hs9_4 : s9_4 = t177 + t131) →
          (hs9_5 : s9_5 = s9_4 + carry8) →
          (ht180 : t180 = t173 &&& 9223372036852678656#64) →
          (hs8_4 : s8_4 = s8_3 - t180) →
          (ht182 : t182 = s10_5 + 1048576#64) →
          (hcarry10 : carry10 = t182.sshiftRight 21) →
          (ht184 :
            t184 =
              (in6 >>> 15 &&& 2097151#64) * 136657#64 +
                (BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64) *
                  18446744073708867715#64 +
                (in7 >>> 14 &&& 2097151#64) * 470296#64 +
                (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 654183#64) →
          (ht185 : t185 = t184 + t117) →
          (ht186 : t186 = t140 + carry10) →
          (ht187 : t187 = t185 + t186) →
          (hs11_7 : s11_7 = t187 + s11) →
          (ht189 : t189 = t182 &&& 18446744073707454464#64) →
          (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) →
          (hbt168 : Bnd t168 1048576 1398054179820) →
          (hbs7_3 : Bnd s7_3 0 2384335524584) →
          (hbs6_2 : Bnd s6_2 (-8796090925056) 1398053131244) →
          (hbt173 : Bnd t173 1048576 3756256439149) →
          (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) →
          (hbs8_4 : Bnd s8_4 (-3756255084544) 3756255390573) →
          (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239) →
          (hbt189 : Bnd t189 (-2092548751360) 4042845585408) →
          (blk.runBodyFrom E' 190 S >>= g) = K) :
    (blk.runBodyFrom E 160 S >>= g) = K := by
  step_pure [nswMul, nuwMul] with t160
  bnd t160
  step_pure [nswMul, nuwMul] with t161
  bnd t161
  step_pure [nswAdd, nuwAdd] with t162
  bnd t162
  step_pure [nswAdd, nuwAdd] with t163
  bnd t163
  step_pure [nswAdd, nuwAdd] with t164
  bnd t164
  step_pure [nswAdd, nuwAdd] with t165
  bnd t165
  step_pure [nswAdd, nuwAdd] with s10_5
  bnd s10_5
  step_pure [expandOfFn, nswMul, nuwMul, ht109] with t167
  step_pure [nswAdd, nuwAdd] with t168
  bnd t168
  step_pure [lshrNonneg] with carry6
  bnd carry6
  step_pure [nswAdd, nuwAdd] with s7_3
  bnd s7_3
  step_pure with t171
  bnd t171
  step_pure [nswSub] with s6_2
  bnd s6_2
  step_pure [nswAdd, nuwAdd] with t173
  bnd t173
  step_pure [lshrNonneg] with carry8
  bnd carry8
  step_pure [nswAdd, nuwAdd] with t175
  bnd t175
  step_pure [nswAdd, nuwAdd] with t176
  bnd t176
  step_pure [nswAdd, nuwAdd] with t177
  bnd t177
  step_pure [nswAdd, nuwAdd] with s9_4
  bnd s9_4
  step_pure [nswAdd, nuwAdd] with s9_5
  bnd s9_5
  step_pure with t180
  bnd t180
  step_pure [nswSub] with s8_4
  bnd s8_4
  step_pure [nswAdd, nuwAdd] with t182
  bnd t182
  step_pure with carry10
  bnd carry10
  step_pure [ht167] with t184
  bnd t184
  step_pure with t185
  bnd t185
  step_pure with t186
  bnd t186
  step_pure with t187
  bnd t187
  step_pure with s11_7
  bnd s11_7
  step_pure with t189
  bnd t189
  exact
    hK _ t160 t161 t162 t163 t164 t165 s10_5 t168 carry6 s7_3 t171 s6_2 t173 carry8 t175 t176 t177
      s9_4 s9_5 t180 s8_4 t182 carry10 t184 t185 t186 t187 s11_7 t189 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht160 ht161 ht162 ht163 ht164 ht165 hs10_5 ht168 hcarry6 hs7_3 ht171 hs6_2
      ht173 hcarry8 ht175 ht176 ht177 hs9_4 hs9_5 ht180 hs8_4 ht182 hcarry10 ht184 ht185 ht186 ht187
      hs11_7 ht189 hbs10_5 hbt168 hbs7_3 hbs6_2 hbt173 hbs9_5 hbs8_4 hbs11_7 hbt189

/-- From `%190`: the first pass's `carry12`, `carry14`, `carry16` and `carry7 … carry13`. -/
theorem fd_curve25519_scalar_reduce.run190 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 190 = fd_curve25519_scalar_reduce.entry.body.drop 190)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in6 in7 s0 s1 s2 s3 s4 s5 s13 s17 : BitVec 64} {t119 : Vector (BitVec 64) 4}
    {s16_1 s15_2 s14_3 s12_5 s10_5 s7_3 s6_2 s9_5 s8_4 s11_7 t189 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 94 := s13,
        rir_reg% fd_curve25519_scalar_reduce.hty 105 := s17,
        rir_reg% fd_curve25519_scalar_reduce.hty 119 := Ty.wrap t119,
        rir_reg% fd_curve25519_scalar_reduce.hty 125 := s16_1,
        rir_reg% fd_curve25519_scalar_reduce.hty 130 := s15_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 134 := s14_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 152 := s12_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 166 := s10_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 172 := s6_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 181 := s8_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 188 := s11_7,
        rir_reg% fd_curve25519_scalar_reduce.hty 189 := t189])
    (ht119 :
      t119 =
        #v[in7 >>> 35 * 654183#64, (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64,
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64,
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64])
    (hbs13 : Bnd s13 0 2097151) (hbs17 : Bnd s17 0 2097151)
    (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151)
    (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678)
    (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358)
    (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647) (hbs7_3 : Bnd s7_3 0 2384335524584)
    (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695)
    (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (t190 carry12 t192 t193 : BitVec 64)
        (s13_5 : BitVec 64) (t195 s12_6 t197 carry14 : BitVec 64) (s15_3 : BitVec 64)
        (t200 : BitVec 64) (s14_4 : BitVec 64) (t202 carry16 : BitVec 64) (s17_1 : BitVec 64)
        (t205 : BitVec 64) (s16_2 : BitVec 64) (t207 : BitVec 64) (carry7 t209 : BitVec 64)
        (t210 : BitVec 64) (carry9 t212 : BitVec 64) (t213 carry11 : BitVec 64) (s12_7 : BitVec 64)
        (t216 : BitVec 64) (s11_8 t218 carry13 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 166 := s10_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 172 := s6_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 181 := s8_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 189 := t189,
              rir_reg% fd_curve25519_scalar_reduce.hty 194 := s13_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 199 := s15_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 201 := s14_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 204 := s17_1,
              rir_reg% fd_curve25519_scalar_reduce.hty 206 := s16_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 208 := carry7,
              rir_reg% fd_curve25519_scalar_reduce.hty 209 := t209,
              rir_reg% fd_curve25519_scalar_reduce.hty 211 := carry9,
              rir_reg% fd_curve25519_scalar_reduce.hty 212 := t212,
              rir_reg% fd_curve25519_scalar_reduce.hty 215 := s12_7,
              rir_reg% fd_curve25519_scalar_reduce.hty 217 := s11_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 218 := t218,
              rir_reg% fd_curve25519_scalar_reduce.hty 219 := carry13]) →
          (ht190 : t190 = s12_5 + 1048576#64) →
          (hcarry12 : carry12 = t190.sshiftRight 21) →
          (ht192 :
            t192 =
              in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
                (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
                (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64) →
          (ht193 : t193 = t192 + carry12) →
          (hs13_5 : s13_5 = t193 + s13) →
          (ht195 : t195 = t190 &&& 18446744073707454464#64) →
          (hs12_6 : s12_6 = s12_5 - t195) →
          (ht197 : t197 = s14_3 + 1048576#64) →
          (hcarry14 : carry14 = t197.sshiftRight 21) →
          (hs15_3 : s15_3 = s15_2 + carry14) →
          (ht200 : t200 = t197 &&& 18446744073707454464#64) →
          (hs14_4 : s14_4 = s14_3 - t200) →
          (ht202 : t202 = s16_1 + 1048576#64) →
          (hcarry16 : carry16 = t202.sshiftRight 21) →
          (hs17_1 : s17_1 = carry16 + s17) →
          (ht205 : t205 = t202 &&& 18446744073707454464#64) →
          (hs16_2 : s16_2 = s16_1 - t205) →
          (ht207 : t207 = s7_3 + 1048576#64) →
          (hcarry7 : carry7 = t207.sshiftRight 21) →
          (ht209 : t209 = t207 &&& 9223372036852678656#64) →
          (ht210 : t210 = s9_5 + 1048576#64) →
          (hcarry9 : carry9 = t210.sshiftRight 21) →
          (ht212 : t212 = t210 &&& 18446744073707454464#64) →
          (ht213 : t213 = s11_7 + 1048576#64) →
          (hcarry11 : carry11 = t213.sshiftRight 21) →
          (hs12_7 : s12_7 = carry11 + s12_6) →
          (ht216 : t216 = t213 &&& 18446744073707454464#64) →
          (hs11_8 : s11_8 = s11_7 - t216) →
          (ht218 : t218 = s13_5 + 1048576#64) →
          (hcarry13 : carry13 = t218.sshiftRight 21) →
          (hbs15_3 : Bnd s15_3 (-1434499788031) 73367170318336) →
          (hbs17_1 : Bnd s17_1 (-175078656) 2097152) →
          (hbs16_2 : Bnd s16_2 (-367166555000963) 367166555684863) →
          (hbt207 : Bnd t207 1048576 2384336573160) →
          (hbcarry7 : Bnd carry7 0 1136940) →
          (hbt209 : Bnd t209 0 2384335994880) →
          (hbcarry9 : Bnd carry9 (-997805) 1791123) →
          (hbs11_8 : Bnd s11_8 (-364072823787651) 364072824471551) →
          (blk.runBodyFrom E' 220 S >>= g) = K) :
    (blk.runBodyFrom E 190 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd] with t190
  bnd t190
  step_pure with carry12
  bnd carry12
  step_pure [ht119] with t192
  bnd t192
  step_pure with t193
  bnd t193
  step_pure with s13_5
  bnd s13_5
  step_pure with t195
  bnd t195
  step_pure with s12_6
  bnd s12_6
  step_pure [nswAdd, nuwAdd] with t197
  bnd t197
  step_pure with carry14
  bnd carry14
  step_pure [nswAdd, nuwAdd] with s15_3
  bnd s15_3
  step_pure with t200
  bnd t200
  step_pure with s14_4
  bnd s14_4
  step_pure [nswAdd, nuwAdd] with t202
  bnd t202
  step_pure with carry16
  bnd carry16
  step_pure [nswAdd, nuwAdd] with s17_1
  bnd s17_1
  step_pure with t205
  bnd t205
  step_pure [nswSub] with s16_2
  bnd s16_2
  step_pure [nswAdd, nuwAdd] with t207
  bnd t207
  step_pure [lshrNonneg] with carry7
  bnd carry7
  step_pure with t209
  bnd t209
  step_pure [nswAdd, nuwAdd] with t210
  bnd t210
  step_pure with carry9
  bnd carry9
  step_pure with t212
  bnd t212
  step_pure [nswAdd, nuwAdd] with t213
  bnd t213
  step_pure with carry11
  bnd carry11
  step_pure with s12_7
  bnd s12_7
  step_pure with t216
  bnd t216
  step_pure with s11_8
  bnd s11_8
  step_pure [nswAdd, nuwAdd] with t218
  bnd t218
  step_pure with carry13
  bnd carry13
  exact
    hK _ t190 carry12 t192 t193 s13_5 t195 s12_6 t197 carry14 s15_3 t200 s14_4 t202 carry16 s17_1
      t205 s16_2 t207 carry7 t209 t210 carry9 t212 t213 carry11 s12_7 t216 s11_8 t218 carry13 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht190 hcarry12 ht192 ht193 hs13_5 ht195 hs12_6 ht197 hcarry14 hs15_3 ht200
      hs14_4 ht202 hcarry16 hs17_1 ht205 hs16_2 ht207 hcarry7 ht209 ht210 hcarry9 ht212 ht213
      hcarry11 hs12_7 ht216 hs11_8 ht218 hcarry13 hbs15_3 hbs17_1 hbs16_2 hbt207 hbcarry7 hbt209
      hbcarry9 hbs11_8

/-- From `%220`: the first pass's `carry15`, and the folding of `s12 … s17` into `s0 … s10`
begun. -/
theorem fd_curve25519_scalar_reduce.run220 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 220 = fd_curve25519_scalar_reduce.entry.body.drop 220)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s10_5 s7_3 s6_2 s9_5 s8_4 t189 : BitVec 64}
    {s13_5 s15_3 s14_4 s17_1 s16_2 carry7 t209 carry9 t212 s12_7 s11_8 t218 carry13 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 70 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 73 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 75 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 166 := s10_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 172 := s6_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 181 := s8_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 189 := t189,
        rir_reg% fd_curve25519_scalar_reduce.hty 194 := s13_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 199 := s15_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 201 := s14_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 204 := s17_1,
        rir_reg% fd_curve25519_scalar_reduce.hty 206 := s16_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 208 := carry7,
        rir_reg% fd_curve25519_scalar_reduce.hty 209 := t209,
        rir_reg% fd_curve25519_scalar_reduce.hty 211 := carry9,
        rir_reg% fd_curve25519_scalar_reduce.hty 212 := t212,
        rir_reg% fd_curve25519_scalar_reduce.hty 215 := s12_7,
        rir_reg% fd_curve25519_scalar_reduce.hty 217 := s11_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 218 := t218,
        rir_reg% fd_curve25519_scalar_reduce.hty 219 := carry13])
    (hbs5 : Bnd s5 0 2097151) (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780)
    (hbs6_2 : Bnd s6_2 (-8796090925056) 1398053131244)
    (hbt189 : Bnd t189 (-2092548751360) 4042845585408)
    (hbs15_3 : Bnd s15_3 (-1434499788031) 73367170318336) (hbs17_1 : Bnd s17_1 (-175078656) 2097152)
    (hbs16_2 : Bnd s16_2 (-367166555000963) 367166555684863)
    (hbcarry9 : Bnd carry9 (-997805) 1791123)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s14_5 t221 s13_6 t223 carry15 s16_3 t226 s15_4 t228 s5_1 t230 s6_3 t232 t233 t234 t235 t236
          t237 s10_8 t239 s4_1 t241 s5_2 t243 s6_4 t245 t246 t247 t248 s3_1 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 181 := s8_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 208 := carry7,
              rir_reg% fd_curve25519_scalar_reduce.hty 209 := t209,
              rir_reg% fd_curve25519_scalar_reduce.hty 212 := t212,
              rir_reg% fd_curve25519_scalar_reduce.hty 215 := s12_7,
              rir_reg% fd_curve25519_scalar_reduce.hty 217 := s11_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 220 := s14_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 222 := s13_6,
              rir_reg% fd_curve25519_scalar_reduce.hty 227 := s15_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 232 := t232,
              rir_reg% fd_curve25519_scalar_reduce.hty 233 := t233,
              rir_reg% fd_curve25519_scalar_reduce.hty 234 := t234,
              rir_reg% fd_curve25519_scalar_reduce.hty 238 := s10_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 240 := s4_1,
              rir_reg% fd_curve25519_scalar_reduce.hty 242 := s5_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 244 := s6_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 245 := t245,
              rir_reg% fd_curve25519_scalar_reduce.hty 246 := t246,
              rir_reg% fd_curve25519_scalar_reduce.hty 247 := t247,
              rir_reg% fd_curve25519_scalar_reduce.hty 249 := s3_1]) →
          (hs14_5 : s14_5 = carry13 + s14_4) →
          (ht221 : t221 = t218 &&& 18446744073707454464#64) →
          (hs13_6 : s13_6 = s13_5 - t221) →
          (ht223 : t223 = s15_3 + 1048576#64) →
          (hcarry15 : carry15 = t223.sshiftRight 21) →
          (hs16_3 : s16_3 = carry15 + s16_2) →
          (ht226 : t226 = t223 &&& 18446744073707454464#64) →
          (hs15_4 : s15_4 = s15_3 - t226) →
          (ht228 : t228 = s17_1 * 666643#64) →
          (hs5_1 : s5_1 = t228 + s5) →
          (ht230 : t230 = s17_1 * 470296#64) →
          (hs6_3 : s6_3 = s6_2 + t230) →
          (ht232 : t232 = s17_1 * 654183#64) →
          (ht233 : t233 = s17_1 * 18446744073708553811#64) →
          (ht234 : t234 = s17_1 * 136657#64) →
          (ht235 : t235 = s17_1 * 18446744073708867715#64) →
          (ht236 : t236 = s10_5 + t235) →
          (ht237 : t237 = t236 - t189) →
          (hs10_8 : s10_8 = t237 + carry9) →
          (ht239 : t239 = s16_3 * 666643#64) →
          (hs4_1 : s4_1 = t239 + s4) →
          (ht241 : t241 = s16_3 * 470296#64) →
          (hs5_2 : s5_2 = s5_1 + t241) →
          (ht243 : t243 = s16_3 * 654183#64) →
          (hs6_4 : s6_4 = s6_3 + t243) →
          (ht245 : t245 = s16_3 * 18446744073708553811#64) →
          (ht246 : t246 = s16_3 * 136657#64) →
          (ht247 : t247 = s16_3 * 18446744073708867715#64) →
          (ht248 : t248 = s15_4 * 666643#64) →
          (hs3_1 : s3_1 = t248 + s3) →
          (hbt232 : Bnd t232 (-114533480418048) 1371921186816) →
          (hbt233 : Bnd t233 (-2092548751360) 174694358350080) →
          (hbt234 : Bnd t234 (-23925723892992) 286590500864) →
          (hbs10_8 : Bnd s10_8 (-7569638686720) 125871864214319) →
          (blk.runBodyFrom E' 250 S >>= g) = K) :
    (blk.runBodyFrom E 220 S >>= g) = K := by
  step_pure with s14_5
  bnd s14_5
  step_pure with t221
  bnd t221
  step_pure with s13_6
  bnd s13_6
  step_pure [nswAdd, nuwAdd] with t223
  bnd t223
  step_pure with carry15
  bnd carry15
  step_pure [nswAdd, nuwAdd] with s16_3
  bnd s16_3
  step_pure with t226
  bnd t226
  step_pure with s15_4
  bnd s15_4
  step_pure [nswMul, nuwMul] with t228
  bnd t228
  step_pure [nswAdd, nuwAdd] with s5_1
  bnd s5_1
  step_pure [nswMul, nuwMul] with t230
  bnd t230
  step_pure [nswAdd, nuwAdd] with s6_3
  bnd s6_3
  step_pure [nswMul, nuwMul] with t232
  bnd t232
  step_pure [nswMul, nuwMul] with t233
  bnd t233
  step_pure [nswMul, nuwMul] with t234
  bnd t234
  step_pure [nswMul, nuwMul] with t235
  bnd t235
  step_pure [nswAdd, nuwAdd] with t236
  bnd t236
  step_pure with t237
  bnd t237
  step_pure with s10_8
  bnd s10_8
  step_pure with t239
  bnd t239
  step_pure with s4_1
  bnd s4_1
  step_pure with t241
  bnd t241
  step_pure with s5_2
  bnd s5_2
  step_pure with t243
  bnd t243
  step_pure with s6_4
  bnd s6_4
  step_pure with t245
  bnd t245
  step_pure with t246
  bnd t246
  step_pure with t247
  bnd t247
  step_pure with t248
  bnd t248
  step_pure with s3_1
  bnd s3_1
  exact
    hK _ s14_5 t221 s13_6 t223 carry15 s16_3 t226 s15_4 t228 s5_1 t230 s6_3 t232 t233 t234 t235 t236
      t237 s10_8 t239 s4_1 t241 s5_2 t243 s6_4 t245 t246 t247 t248 s3_1 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hs14_5 ht221 hs13_6 ht223 hcarry15 hs16_3 ht226 hs15_4 ht228 hs5_1 ht230 hs6_3
      ht232 ht233 ht234 ht235 ht236 ht237 hs10_8 ht239 hs4_1 ht241 hs5_2 ht243 hs6_4 ht245 ht246
      ht247 ht248 hs3_1 hbt232 hbt233 hbt234 hbs10_8

/-- From `%250`: the folding of `s12 … s17`, continued. -/
theorem fd_curve25519_scalar_reduce.run250 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 250 = fd_curve25519_scalar_reduce.entry.body.drop 250)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s7_3 s9_5 s8_4 : BitVec 64} {carry7 t209 t212 s12_7 s11_8 : BitVec 64}
    {s14_5 s13_6 s15_4 t232 t233 t234 s10_8 s4_1 s5_2 s6_4 t245 t246 t247 s3_1 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 181 := s8_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 208 := carry7,
        rir_reg% fd_curve25519_scalar_reduce.hty 209 := t209,
        rir_reg% fd_curve25519_scalar_reduce.hty 212 := t212,
        rir_reg% fd_curve25519_scalar_reduce.hty 215 := s12_7,
        rir_reg% fd_curve25519_scalar_reduce.hty 217 := s11_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 220 := s14_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 222 := s13_6,
        rir_reg% fd_curve25519_scalar_reduce.hty 227 := s15_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 232 := t232,
        rir_reg% fd_curve25519_scalar_reduce.hty 233 := t233,
        rir_reg% fd_curve25519_scalar_reduce.hty 234 := t234,
        rir_reg% fd_curve25519_scalar_reduce.hty 238 := s10_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 240 := s4_1,
        rir_reg% fd_curve25519_scalar_reduce.hty 242 := s5_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 244 := s6_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 245 := t245,
        rir_reg% fd_curve25519_scalar_reduce.hty 246 := t246,
        rir_reg% fd_curve25519_scalar_reduce.hty 247 := t247,
        rir_reg% fd_curve25519_scalar_reduce.hty 249 := s3_1])
    (hbs8_4 : Bnd s8_4 (-3756255084544) 3756255390573) (hbcarry7 : Bnd carry7 0 1136940)
    (hbt233 : Bnd t233 (-2092548751360) 174694358350080)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t250 s4_2 t252 s5_3 t254 s6_5 t256 t257 t258 s8_6 s8_7 s8_8 t262 s2_1 t264 s3_2 t266 s4_3
          t268 s5_4 t270 s6_6 t272 t273 s1_1 t275 s2_2 t277 s3_3 t279 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 209 := t209,
              rir_reg% fd_curve25519_scalar_reduce.hty 212 := t212,
              rir_reg% fd_curve25519_scalar_reduce.hty 215 := s12_7,
              rir_reg% fd_curve25519_scalar_reduce.hty 217 := s11_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 222 := s13_6,
              rir_reg% fd_curve25519_scalar_reduce.hty 232 := t232,
              rir_reg% fd_curve25519_scalar_reduce.hty 234 := t234,
              rir_reg% fd_curve25519_scalar_reduce.hty 238 := s10_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 245 := t245,
              rir_reg% fd_curve25519_scalar_reduce.hty 247 := t247,
              rir_reg% fd_curve25519_scalar_reduce.hty 256 := t256,
              rir_reg% fd_curve25519_scalar_reduce.hty 261 := s8_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 267 := s4_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 269 := s5_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 271 := s6_6,
              rir_reg% fd_curve25519_scalar_reduce.hty 272 := t272,
              rir_reg% fd_curve25519_scalar_reduce.hty 274 := s1_1,
              rir_reg% fd_curve25519_scalar_reduce.hty 276 := s2_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 278 := s3_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 279 := t279]) →
          (ht250 : t250 = s15_4 * 470296#64) →
          (hs4_2 : s4_2 = s4_1 + t250) →
          (ht252 : t252 = s15_4 * 654183#64) →
          (hs5_3 : s5_3 = s5_2 + t252) →
          (ht254 : t254 = s15_4 * 18446744073708553811#64) →
          (hs6_5 : s6_5 = s6_4 + t254) →
          (ht256 : t256 = s15_4 * 136657#64) →
          (ht257 : t257 = s15_4 * 18446744073708867715#64) →
          (ht258 : t258 = s8_4 + t233) →
          (hs8_6 : s8_6 = t258 + carry7) →
          (hs8_7 : s8_7 = s8_6 + t246) →
          (hs8_8 : s8_8 = s8_7 + t257) →
          (ht262 : t262 = s14_5 * 666643#64) →
          (hs2_1 : s2_1 = t262 + s2) →
          (ht264 : t264 = s14_5 * 470296#64) →
          (hs3_2 : s3_2 = s3_1 + t264) →
          (ht266 : t266 = s14_5 * 654183#64) →
          (hs4_3 : s4_3 = s4_2 + t266) →
          (ht268 : t268 = s14_5 * 18446744073708553811#64) →
          (hs5_4 : s5_4 = s5_3 + t268) →
          (ht270 : t270 = s14_5 * 136657#64) →
          (hs6_6 : s6_6 = s6_5 + t270) →
          (ht272 : t272 = s14_5 * 18446744073708867715#64) →
          (ht273 : t273 = s13_6 * 666643#64) →
          (hs1_1 : s1_1 = t273 + s1) →
          (ht275 : t275 = s13_6 * 470296#64) →
          (hs2_2 : s2_2 = s2_1 + t275) →
          (ht277 : t277 = s13_6 * 654183#64) →
          (hs3_3 : s3_3 = s3_2 + t277) →
          (ht279 : t279 = s13_6 * 18446744073708553811#64) → (blk.runBodyFrom E' 280 S >>= g) = K) :
    (blk.runBodyFrom E 250 S >>= g) = K := by
  step_pure with t250
  bnd t250
  step_pure with s4_2
  bnd s4_2
  step_pure with t252
  bnd t252
  step_pure with s5_3
  bnd s5_3
  step_pure with t254
  bnd t254
  step_pure with s6_5
  bnd s6_5
  step_pure with t256
  bnd t256
  step_pure with t257
  bnd t257
  step_pure [nswAdd, nuwAdd] with t258
  bnd t258
  step_pure [nswAdd, nuwAdd] with s8_6
  bnd s8_6
  step_pure with s8_7
  bnd s8_7
  step_pure with s8_8
  bnd s8_8
  step_pure with t262
  bnd t262
  step_pure with s2_1
  bnd s2_1
  step_pure with t264
  bnd t264
  step_pure with s3_2
  bnd s3_2
  step_pure with t266
  bnd t266
  step_pure with s4_3
  bnd s4_3
  step_pure with t268
  bnd t268
  step_pure with s5_4
  bnd s5_4
  step_pure with t270
  bnd t270
  step_pure with s6_6
  bnd s6_6
  step_pure with t272
  bnd t272
  step_pure with t273
  bnd t273
  step_pure with s1_1
  bnd s1_1
  step_pure with t275
  bnd t275
  step_pure with s2_2
  bnd s2_2
  step_pure with t277
  bnd t277
  step_pure with s3_3
  bnd s3_3
  step_pure with t279
  bnd t279
  exact
    hK _ t250 s4_2 t252 s5_3 t254 s6_5 t256 t257 t258 s8_6 s8_7 s8_8 t262 s2_1 t264 s3_2 t266 s4_3
      t268 s5_4 t270 s6_6 t272 t273 s1_1 t275 s2_2 t277 s3_3 t279 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht250 hs4_2 ht252 hs5_3 ht254 hs6_5 ht256 ht257 ht258 hs8_6 hs8_7 hs8_8 ht262
      hs2_1 ht264 hs3_2 ht266 hs4_3 ht268 hs5_4 ht270 hs6_6 ht272 ht273 hs1_1 ht275 hs2_2 ht277
      hs3_3 ht279

/-- From `%280`: the folding's end, and `carry0`, `carry2`, `carry4` of the second carry pass. -/
theorem fd_curve25519_scalar_reduce.run280 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 280 = fd_curve25519_scalar_reduce.entry.body.drop 280)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s7_3 s9_5 : BitVec 64} {t209 t212 s12_7 s11_8 : BitVec 64}
    {s13_6 t232 t234 s10_8 t245 t247 t256 s8_8 s4_3 s5_4 s6_6 t272 s1_1 s2_2 s3_3 t279 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 209 := t209,
        rir_reg% fd_curve25519_scalar_reduce.hty 212 := t212,
        rir_reg% fd_curve25519_scalar_reduce.hty 215 := s12_7,
        rir_reg% fd_curve25519_scalar_reduce.hty 217 := s11_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 222 := s13_6,
        rir_reg% fd_curve25519_scalar_reduce.hty 232 := t232,
        rir_reg% fd_curve25519_scalar_reduce.hty 234 := t234,
        rir_reg% fd_curve25519_scalar_reduce.hty 238 := s10_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 245 := t245,
        rir_reg% fd_curve25519_scalar_reduce.hty 247 := t247,
        rir_reg% fd_curve25519_scalar_reduce.hty 256 := t256,
        rir_reg% fd_curve25519_scalar_reduce.hty 261 := s8_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 267 := s4_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 269 := s5_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 271 := s6_6,
        rir_reg% fd_curve25519_scalar_reduce.hty 272 := t272,
        rir_reg% fd_curve25519_scalar_reduce.hty 274 := s1_1,
        rir_reg% fd_curve25519_scalar_reduce.hty 276 := s2_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 278 := s3_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 279 := t279])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s4_4 t281 s5_5 t283 s6_7 t285 s0_1 t287 s1_2 t289 s2_3 t291 s3_4 t293 s4_5 t295 s5_6 t297
          carry0 s1_3 t300 s0_2 t302 carry2 s3_5 t305 s2_4 t307 carry4 s5_7 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 209 := t209,
              rir_reg% fd_curve25519_scalar_reduce.hty 212 := t212,
              rir_reg% fd_curve25519_scalar_reduce.hty 217 := s11_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 232 := t232,
              rir_reg% fd_curve25519_scalar_reduce.hty 234 := t234,
              rir_reg% fd_curve25519_scalar_reduce.hty 238 := s10_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 245 := t245,
              rir_reg% fd_curve25519_scalar_reduce.hty 247 := t247,
              rir_reg% fd_curve25519_scalar_reduce.hty 256 := t256,
              rir_reg% fd_curve25519_scalar_reduce.hty 261 := s8_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 272 := t272,
              rir_reg% fd_curve25519_scalar_reduce.hty 284 := s6_7,
              rir_reg% fd_curve25519_scalar_reduce.hty 294 := s4_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 299 := s1_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 301 := s0_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 304 := s3_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 306 := s2_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 307 := t307,
              rir_reg% fd_curve25519_scalar_reduce.hty 309 := s5_7]) →
          (hs4_4 : s4_4 = s4_3 + t279) →
          (ht281 : t281 = s13_6 * 136657#64) →
          (hs5_5 : s5_5 = s5_4 + t281) →
          (ht283 : t283 = s13_6 * 18446744073708867715#64) →
          (hs6_7 : s6_7 = s6_6 + t283) →
          (ht285 : t285 = s12_7 * 666643#64) →
          (hs0_1 : s0_1 = t285 + s0) →
          (ht287 : t287 = s12_7 * 470296#64) →
          (hs1_2 : s1_2 = s1_1 + t287) →
          (ht289 : t289 = s12_7 * 654183#64) →
          (hs2_3 : s2_3 = s2_2 + t289) →
          (ht291 : t291 = s12_7 * 18446744073708553811#64) →
          (hs3_4 : s3_4 = s3_3 + t291) →
          (ht293 : t293 = s12_7 * 136657#64) →
          (hs4_5 : s4_5 = s4_4 + t293) →
          (ht295 : t295 = s12_7 * 18446744073708867715#64) →
          (hs5_6 : s5_6 = s5_5 + t295) →
          (ht297 : t297 = s0_1 + 1048576#64) →
          (hcarry0 : carry0 = t297.sshiftRight 21) →
          (hs1_3 : s1_3 = s1_2 + carry0) →
          (ht300 : t300 = t297 &&& 18446744073707454464#64) →
          (hs0_2 : s0_2 = s0_1 - t300) →
          (ht302 : t302 = s2_3 + 1048576#64) →
          (hcarry2 : carry2 = t302.sshiftRight 21) →
          (hs3_5 : s3_5 = s3_4 + carry2) →
          (ht305 : t305 = t302 &&& 18446744073707454464#64) →
          (hs2_4 : s2_4 = s2_3 - t305) →
          (ht307 : t307 = s4_5 + 1048576#64) →
          (hcarry4 : carry4 = t307.sshiftRight 21) →
          (hs5_7 : s5_7 = s5_6 + carry4) → (blk.runBodyFrom E' 310 S >>= g) = K) :
    (blk.runBodyFrom E 280 S >>= g) = K := by
  step_pure with s4_4
  bnd s4_4
  step_pure with t281
  bnd t281
  step_pure with s5_5
  bnd s5_5
  step_pure with t283
  bnd t283
  step_pure with s6_7
  bnd s6_7
  step_pure with t285
  bnd t285
  step_pure with s0_1
  bnd s0_1
  step_pure with t287
  bnd t287
  step_pure with s1_2
  bnd s1_2
  step_pure with t289
  bnd t289
  step_pure with s2_3
  bnd s2_3
  step_pure with t291
  bnd t291
  step_pure with s3_4
  bnd s3_4
  step_pure with t293
  bnd t293
  step_pure with s4_5
  bnd s4_5
  step_pure with t295
  bnd t295
  step_pure with s5_6
  bnd s5_6
  step_pure with t297
  bnd t297
  step_pure with carry0
  bnd carry0
  step_pure with s1_3
  bnd s1_3
  step_pure with t300
  bnd t300
  step_pure with s0_2
  bnd s0_2
  step_pure with t302
  bnd t302
  step_pure with carry2
  bnd carry2
  step_pure with s3_5
  bnd s3_5
  step_pure with t305
  bnd t305
  step_pure with s2_4
  bnd s2_4
  step_pure with t307
  bnd t307
  step_pure with carry4
  bnd carry4
  step_pure with s5_7
  bnd s5_7
  exact
    hK _ s4_4 t281 s5_5 t283 s6_7 t285 s0_1 t287 s1_2 t289 s2_3 t291 s3_4 t293 s4_5 t295 s5_6 t297
      carry0 s1_3 t300 s0_2 t302 carry2 s3_5 t305 s2_4 t307 carry4 s5_7 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hs4_4 ht281 hs5_5 ht283 hs6_7 ht285 hs0_1 ht287 hs1_2 ht289 hs2_3 ht291 hs3_4
      ht293 hs4_5 ht295 hs5_6 ht297 hcarry0 hs1_3 ht300 hs0_2 ht302 hcarry2 hs3_5 ht305 hs2_4 ht307
      hcarry4 hs5_7

/-- From `%310`: the second pass's `carry6`, `carry8`, `carry10`, `carry1`, `carry3`. -/
theorem fd_curve25519_scalar_reduce.run310 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 310 = fd_curve25519_scalar_reduce.entry.body.drop 310)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s7_3 s9_5 : BitVec 64} {t209 t212 s11_8 : BitVec 64}
    {t232 t234 s10_8 t245 t247 t256 s8_8 t272 s6_7 s4_5 s1_3 s0_2 s3_5 s2_4 t307 s5_7 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 170 := s7_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 179 := s9_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 209 := t209,
        rir_reg% fd_curve25519_scalar_reduce.hty 212 := t212,
        rir_reg% fd_curve25519_scalar_reduce.hty 217 := s11_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 232 := t232,
        rir_reg% fd_curve25519_scalar_reduce.hty 234 := t234,
        rir_reg% fd_curve25519_scalar_reduce.hty 238 := s10_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 245 := t245,
        rir_reg% fd_curve25519_scalar_reduce.hty 247 := t247,
        rir_reg% fd_curve25519_scalar_reduce.hty 256 := t256,
        rir_reg% fd_curve25519_scalar_reduce.hty 261 := s8_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 272 := t272,
        rir_reg% fd_curve25519_scalar_reduce.hty 284 := s6_7,
        rir_reg% fd_curve25519_scalar_reduce.hty 294 := s4_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 299 := s1_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 301 := s0_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 304 := s3_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 306 := s2_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 307 := t307,
        rir_reg% fd_curve25519_scalar_reduce.hty 309 := s5_7])
    (hbs7_3 : Bnd s7_3 0 2384335524584) (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695)
    (hbt209 : Bnd t209 0 2384335994880) (hbs11_8 : Bnd s11_8 (-364072823787651) 364072824471551)
    (hbt232 : Bnd t232 (-114533480418048) 1371921186816)
    (hbt234 : Bnd t234 (-23925723892992) 286590500864)
    (hbs10_8 : Bnd s10_8 (-7569638686720) 125871864214319)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t310 s4_6 t312 carry6_1 t314 s7_5 s7_6 s7_7 s7_8 s7_9 t320 s6_8 t322 carry8_1 t324 s9_7
          s9_8 s9_9 t328 s8_9 t330 carry10_1 s11_9 t333 s10_9 t335 carry1 t337 t338 carry3 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 299 := s1_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 301 := s0_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 304 := s3_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 306 := s2_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 309 := s5_7,
              rir_reg% fd_curve25519_scalar_reduce.hty 311 := s4_6,
              rir_reg% fd_curve25519_scalar_reduce.hty 319 := s7_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 321 := s6_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 327 := s9_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 329 := s8_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 332 := s11_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 334 := s10_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 336 := carry1,
              rir_reg% fd_curve25519_scalar_reduce.hty 337 := t337,
              rir_reg% fd_curve25519_scalar_reduce.hty 338 := t338,
              rir_reg% fd_curve25519_scalar_reduce.hty 339 := carry3]) →
          (ht310 : t310 = t307 &&& 18446744073707454464#64) →
          (hs4_6 : s4_6 = s4_5 - t310) →
          (ht312 : t312 = s6_7 + 1048576#64) →
          (hcarry6_1 : carry6_1 = t312.sshiftRight 21) →
          (ht314 : t314 = t232 + s7_3) →
          (hs7_5 : s7_5 = t314 - t209) →
          (hs7_6 : s7_6 = s7_5 + t245) →
          (hs7_7 : s7_7 = s7_6 + t256) →
          (hs7_8 : s7_8 = s7_7 + t272) →
          (hs7_9 : s7_9 = s7_8 + carry6_1) →
          (ht320 : t320 = t312 &&& 18446744073707454464#64) →
          (hs6_8 : s6_8 = s6_7 - t320) →
          (ht322 : t322 = s8_8 + 1048576#64) →
          (hcarry8_1 : carry8_1 = t322.sshiftRight 21) →
          (ht324 : t324 = s9_5 + t234) →
          (hs9_7 : s9_7 = t324 - t212) →
          (hs9_8 : s9_8 = s9_7 + t247) →
          (hs9_9 : s9_9 = s9_8 + carry8_1) →
          (ht328 : t328 = t322 &&& 18446744073707454464#64) →
          (hs8_9 : s8_9 = s8_8 - t328) →
          (ht330 : t330 = s10_8 + 1048576#64) →
          (hcarry10_1 : carry10_1 = t330.sshiftRight 21) →
          (hs11_9 : s11_9 = carry10_1 + s11_8) →
          (ht333 : t333 = t330 &&& 18446744073707454464#64) →
          (hs10_9 : s10_9 = s10_8 - t333) →
          (ht335 : t335 = s1_3 + 1048576#64) →
          (hcarry1 : carry1 = t335.sshiftRight 21) →
          (ht337 : t337 = t335 &&& 18446744073707454464#64) →
          (ht338 : t338 = s3_5 + 1048576#64) →
          (hcarry3 : carry3 = t338.sshiftRight 21) →
          (hbs11_9 : Bnd s11_9 (-364072827397136) 364072884491933) →
          (hbs10_9 : Bnd s10_9 (-133441502838784) 133441502901039) →
          (blk.runBodyFrom E' 340 S >>= g) = K) :
    (blk.runBodyFrom E 310 S >>= g) = K := by
  step_pure with t310
  bnd t310
  step_pure with s4_6
  bnd s4_6
  step_pure with t312
  bnd t312
  step_pure with carry6_1
  bnd carry6_1
  step_pure [nswAdd, nuwAdd] with t314
  bnd t314
  step_pure [nswSub] with s7_5
  bnd s7_5
  step_pure with s7_6
  bnd s7_6
  step_pure with s7_7
  bnd s7_7
  step_pure with s7_8
  bnd s7_8
  step_pure with s7_9
  bnd s7_9
  step_pure with t320
  bnd t320
  step_pure with s6_8
  bnd s6_8
  step_pure with t322
  bnd t322
  step_pure with carry8_1
  bnd carry8_1
  step_pure [nswAdd, nuwAdd] with t324
  bnd t324
  step_pure with s9_7
  bnd s9_7
  step_pure with s9_8
  bnd s9_8
  step_pure with s9_9
  bnd s9_9
  step_pure with t328
  bnd t328
  step_pure with s8_9
  bnd s8_9
  step_pure with t330
  bnd t330
  step_pure with carry10_1
  bnd carry10_1
  step_pure with s11_9
  bnd s11_9
  step_pure with t333
  bnd t333
  step_pure with s10_9
  bnd s10_9
  step_pure with t335
  bnd t335
  step_pure with carry1
  bnd carry1
  step_pure with t337
  bnd t337
  step_pure with t338
  bnd t338
  step_pure with carry3
  bnd carry3
  exact
    hK _ t310 s4_6 t312 carry6_1 t314 s7_5 s7_6 s7_7 s7_8 s7_9 t320 s6_8 t322 carry8_1 t324 s9_7
      s9_8 s9_9 t328 s8_9 t330 carry10_1 s11_9 t333 s10_9 t335 carry1 t337 t338 carry3 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht310 hs4_6 ht312 hcarry6_1 ht314 hs7_5 hs7_6 hs7_7 hs7_8 hs7_9 ht320 hs6_8
      ht322 hcarry8_1 ht324 hs9_7 hs9_8 hs9_9 ht328 hs8_9 ht330 hcarry10_1 hs11_9 ht333 hs10_9 ht335
      hcarry1 ht337 ht338 hcarry3 hbs11_9 hbs10_9

/-- From `%340`: the second pass's `carry5 … carry11`, `s12` folded into `s0`, and the third pass's
`carry0`. -/
theorem fd_curve25519_scalar_reduce.run340 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 340 = fd_curve25519_scalar_reduce.entry.body.drop 340)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s1_3 s0_2 s3_5 s2_4 s5_7 s4_6 s7_9 s6_8 s9_9 s8_9 s11_9 s10_9 carry1 t337 t338 carry3 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 299 := s1_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 301 := s0_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 304 := s3_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 306 := s2_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 309 := s5_7,
        rir_reg% fd_curve25519_scalar_reduce.hty 311 := s4_6,
        rir_reg% fd_curve25519_scalar_reduce.hty 319 := s7_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 321 := s6_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 327 := s9_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 329 := s8_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 332 := s11_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 334 := s10_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 336 := carry1,
        rir_reg% fd_curve25519_scalar_reduce.hty 337 := t337,
        rir_reg% fd_curve25519_scalar_reduce.hty 338 := t338,
        rir_reg% fd_curve25519_scalar_reduce.hty 339 := carry3])
    (hbs11_9 : Bnd s11_9 (-364072827397136) 364072884491933)
    (hbs10_9 : Bnd s10_9 (-133441502838784) 133441502901039)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t340 t341 carry5 s6_9 t344 t345 carry7_1 s8_10 t348 s7_10 t350 carry9_1 s10_10 t353 s9_10
          t355 carry11_1 t357 s11_10 t359 s0_3 t361 t362 t363 t364 t365 carry0_1 t367 s1_5 s1_6 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 304 := s3_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 306 := s2_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 309 := s5_7,
              rir_reg% fd_curve25519_scalar_reduce.hty 311 := s4_6,
              rir_reg% fd_curve25519_scalar_reduce.hty 336 := carry1,
              rir_reg% fd_curve25519_scalar_reduce.hty 339 := carry3,
              rir_reg% fd_curve25519_scalar_reduce.hty 340 := t340,
              rir_reg% fd_curve25519_scalar_reduce.hty 343 := s6_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 344 := t344,
              rir_reg% fd_curve25519_scalar_reduce.hty 347 := s8_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 349 := s7_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 352 := s10_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 354 := s9_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 358 := s11_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 360 := s0_3,
              rir_reg% fd_curve25519_scalar_reduce.hty 362 := t362,
              rir_reg% fd_curve25519_scalar_reduce.hty 363 := t363,
              rir_reg% fd_curve25519_scalar_reduce.hty 364 := t364,
              rir_reg% fd_curve25519_scalar_reduce.hty 365 := t365,
              rir_reg% fd_curve25519_scalar_reduce.hty 369 := s1_6]) →
          (ht340 : t340 = t338 &&& 18446744073707454464#64) →
          (ht341 : t341 = s5_7 + 1048576#64) →
          (hcarry5 : carry5 = t341.sshiftRight 21) →
          (hs6_9 : s6_9 = s6_8 + carry5) →
          (ht344 : t344 = t341 &&& 18446744073707454464#64) →
          (ht345 : t345 = s7_9 + 1048576#64) →
          (hcarry7_1 : carry7_1 = t345.sshiftRight 21) →
          (hs8_10 : s8_10 = s8_9 + carry7_1) →
          (ht348 : t348 = t345 &&& 18446744073707454464#64) →
          (hs7_10 : s7_10 = s7_9 - t348) →
          (ht350 : t350 = s9_9 + 1048576#64) →
          (hcarry9_1 : carry9_1 = t350.sshiftRight 21) →
          (hs10_10 : s10_10 = s10_9 + carry9_1) →
          (ht353 : t353 = t350 &&& 18446744073707454464#64) →
          (hs9_10 : s9_10 = s9_9 - t353) →
          (ht355 : t355 = s11_9 + 1048576#64) →
          (hcarry11_1 : carry11_1 = t355.sshiftRight 21) →
          (ht357 : t357 = t355 &&& 18446744073707454464#64) →
          (hs11_10 : s11_10 = s11_9 - t357) →
          (ht359 : t359 = carry11_1 * 666643#64) →
          (hs0_3 : s0_3 = s0_2 + t359) →
          (ht361 : t361 = carry11_1 * 470296#64) →
          (ht362 : t362 = carry11_1 * 654183#64) →
          (ht363 : t363 = carry11_1 * 18446744073708553811#64) →
          (ht364 : t364 = carry11_1 * 136657#64) →
          (ht365 : t365 = carry11_1 * 18446744073708867715#64) →
          (hcarry0_1 : carry0_1 = s0_3.sshiftRight 21) →
          (ht367 : t367 = t361 + s1_3) →
          (hs1_5 : s1_5 = t367 - t337) →
          (hs1_6 : s1_6 = s1_5 + carry0_1) →
          (hbs10_10 : Bnd s10_10 (-137839549349888) 137839549412142) →
          (hbs11_10 : Bnd s11_10 (-728145712686096) 728145711060637) →
          (blk.runBodyFrom E' 370 S >>= g) = K) :
    (blk.runBodyFrom E 340 S >>= g) = K := by
  step_pure with t340
  bnd t340
  step_pure with t341
  bnd t341
  step_pure with carry5
  bnd carry5
  step_pure with s6_9
  bnd s6_9
  step_pure with t344
  bnd t344
  step_pure with t345
  bnd t345
  step_pure with carry7_1
  bnd carry7_1
  step_pure with s8_10
  bnd s8_10
  step_pure with t348
  bnd t348
  step_pure with s7_10
  bnd s7_10
  step_pure with t350
  bnd t350
  step_pure with carry9_1
  bnd carry9_1
  step_pure with s10_10
  bnd s10_10
  step_pure with t353
  bnd t353
  step_pure with s9_10
  bnd s9_10
  step_pure with t355
  bnd t355
  step_pure with carry11_1
  bnd carry11_1
  step_pure with t357
  bnd t357
  step_pure with s11_10
  bnd s11_10
  step_pure [nswMul, nuwMul] with t359
  bnd t359
  step_pure with s0_3
  bnd s0_3
  step_pure [nswMul, nuwMul] with t361
  bnd t361
  step_pure [nswMul, nuwMul] with t362
  bnd t362
  step_pure [nswMul, nuwMul] with t363
  bnd t363
  step_pure [nswMul, nuwMul] with t364
  bnd t364
  step_pure [nswMul, nuwMul] with t365
  bnd t365
  step_pure with carry0_1
  bnd carry0_1
  step_pure with t367
  bnd t367
  step_pure with s1_5
  bnd s1_5
  step_pure with s1_6
  bnd s1_6
  exact
    hK _ t340 t341 carry5 s6_9 t344 t345 carry7_1 s8_10 t348 s7_10 t350 carry9_1 s10_10 t353 s9_10
      t355 carry11_1 t357 s11_10 t359 s0_3 t361 t362 t363 t364 t365 carry0_1 t367 s1_5 s1_6 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht340 ht341 hcarry5 hs6_9 ht344 ht345 hcarry7_1 hs8_10 ht348 hs7_10 ht350
      hcarry9_1 hs10_10 ht353 hs9_10 ht355 hcarry11_1 ht357 hs11_10 ht359 hs0_3 ht361 ht362 ht363
      ht364 ht365 hcarry0_1 ht367 hs1_5 hs1_6 hbs10_10 hbs11_10

/-- From `%370`: the third pass's `carry1 … carry7`. -/
theorem fd_curve25519_scalar_reduce.run370 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 370 = fd_curve25519_scalar_reduce.entry.body.drop 370)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s3_5 s2_4 s5_7 s4_6 carry1 carry3 t340 s6_9 t344 s8_10 s7_10 s10_10 s9_10 s11_10 s0_3 t362 t363
      t364 t365 s1_6 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 304 := s3_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 306 := s2_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 309 := s5_7,
        rir_reg% fd_curve25519_scalar_reduce.hty 311 := s4_6,
        rir_reg% fd_curve25519_scalar_reduce.hty 336 := carry1,
        rir_reg% fd_curve25519_scalar_reduce.hty 339 := carry3,
        rir_reg% fd_curve25519_scalar_reduce.hty 340 := t340,
        rir_reg% fd_curve25519_scalar_reduce.hty 343 := s6_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 344 := t344,
        rir_reg% fd_curve25519_scalar_reduce.hty 347 := s8_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 349 := s7_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 352 := s10_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 354 := s9_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 358 := s11_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 360 := s0_3,
        rir_reg% fd_curve25519_scalar_reduce.hty 362 := t362,
        rir_reg% fd_curve25519_scalar_reduce.hty 363 := t363,
        rir_reg% fd_curve25519_scalar_reduce.hty 364 := t364,
        rir_reg% fd_curve25519_scalar_reduce.hty 365 := t365,
        rir_reg% fd_curve25519_scalar_reduce.hty 369 := s1_6])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s0_4 carry1_1 t372 s2_6 s2_7 s1_7 carry2_1 t377 s3_7 s3_8 s2_8 carry3_1 t382 s4_8 s4_9 s3_9
          carry4_1 t387 s5_9 s5_10 s4_10 carry5_1 s6_10 s5_11 carry6_2 s7_11 s6_11 carry7_2 s8_11
          s7_12 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 352 := s10_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 354 := s9_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 358 := s11_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 370 := s0_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 375 := s1_7,
              rir_reg% fd_curve25519_scalar_reduce.hty 380 := s2_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 385 := s3_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 390 := s4_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 393 := s5_11,
              rir_reg% fd_curve25519_scalar_reduce.hty 396 := s6_11,
              rir_reg% fd_curve25519_scalar_reduce.hty 398 := s8_11,
              rir_reg% fd_curve25519_scalar_reduce.hty 399 := s7_12]) →
          (hs0_4 : s0_4 = s0_3 &&& 2097151#64) →
          (hcarry1_1 : carry1_1 = s1_6.sshiftRight 21) →
          (ht372 : t372 = s2_4 + t362) →
          (hs2_6 : s2_6 = t372 + carry1) →
          (hs2_7 : s2_7 = s2_6 + carry1_1) →
          (hs1_7 : s1_7 = s1_6 &&& 2097151#64) →
          (hcarry2_1 : carry2_1 = s2_7.sshiftRight 21) →
          (ht377 : t377 = s3_5 + t363) →
          (hs3_7 : s3_7 = t377 - t340) →
          (hs3_8 : s3_8 = s3_7 + carry2_1) →
          (hs2_8 : s2_8 = s2_7 &&& 2097151#64) →
          (hcarry3_1 : carry3_1 = s3_8.sshiftRight 21) →
          (ht382 : t382 = s4_6 + t364) →
          (hs4_8 : s4_8 = t382 + carry3) →
          (hs4_9 : s4_9 = s4_8 + carry3_1) →
          (hs3_9 : s3_9 = s3_8 &&& 2097151#64) →
          (hcarry4_1 : carry4_1 = s4_9.sshiftRight 21) →
          (ht387 : t387 = s5_7 + t365) →
          (hs5_9 : s5_9 = t387 - t344) →
          (hs5_10 : s5_10 = s5_9 + carry4_1) →
          (hs4_10 : s4_10 = s4_9 &&& 2097151#64) →
          (hcarry5_1 : carry5_1 = s5_10.sshiftRight 21) →
          (hs6_10 : s6_10 = s6_9 + carry5_1) →
          (hs5_11 : s5_11 = s5_10 &&& 2097151#64) →
          (hcarry6_2 : carry6_2 = s6_10.sshiftRight 21) →
          (hs7_11 : s7_11 = carry6_2 + s7_10) →
          (hs6_11 : s6_11 = s6_10 &&& 2097151#64) →
          (hcarry7_2 : carry7_2 = s7_11.sshiftRight 21) →
          (hs8_11 : s8_11 = s8_10 + carry7_2) →
          (hs7_12 : s7_12 = s7_11 &&& 2097151#64) →
          (hbs0_4 : Bnd s0_4 0 2097151) →
          (hbs1_7 : Bnd s1_7 0 2097151) →
          (hbs2_8 : Bnd s2_8 0 2097151) →
          (hbs3_9 : Bnd s3_9 0 2097151) →
          (hbs4_10 : Bnd s4_10 0 2097151) →
          (hbs5_11 : Bnd s5_11 0 2097151) →
          (hbs6_11 : Bnd s6_11 0 2097151) →
          (hbs7_12 : Bnd s7_12 0 2097151) → (blk.runBodyFrom E' 400 S >>= g) = K) :
    (blk.runBodyFrom E 370 S >>= g) = K := by
  step_pure with s0_4
  bnd s0_4
  step_pure with carry1_1
  bnd carry1_1
  step_pure with t372
  bnd t372
  step_pure with s2_6
  bnd s2_6
  step_pure with s2_7
  bnd s2_7
  step_pure with s1_7
  bnd s1_7
  step_pure with carry2_1
  bnd carry2_1
  step_pure with t377
  bnd t377
  step_pure with s3_7
  bnd s3_7
  step_pure with s3_8
  bnd s3_8
  step_pure with s2_8
  bnd s2_8
  step_pure with carry3_1
  bnd carry3_1
  step_pure with t382
  bnd t382
  step_pure with s4_8
  bnd s4_8
  step_pure with s4_9
  bnd s4_9
  step_pure with s3_9
  bnd s3_9
  step_pure with carry4_1
  bnd carry4_1
  step_pure with t387
  bnd t387
  step_pure with s5_9
  bnd s5_9
  step_pure with s5_10
  bnd s5_10
  step_pure with s4_10
  bnd s4_10
  step_pure with carry5_1
  bnd carry5_1
  step_pure with s6_10
  bnd s6_10
  step_pure with s5_11
  bnd s5_11
  step_pure with carry6_2
  bnd carry6_2
  step_pure with s7_11
  bnd s7_11
  step_pure with s6_11
  bnd s6_11
  step_pure with carry7_2
  bnd carry7_2
  step_pure with s8_11
  bnd s8_11
  step_pure with s7_12
  bnd s7_12
  exact
    hK _ s0_4 carry1_1 t372 s2_6 s2_7 s1_7 carry2_1 t377 s3_7 s3_8 s2_8 carry3_1 t382 s4_8 s4_9 s3_9
      carry4_1 t387 s5_9 s5_10 s4_10 carry5_1 s6_10 s5_11 carry6_2 s7_11 s6_11 carry7_2 s8_11 s7_12
      hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hs0_4 hcarry1_1 ht372 hs2_6 hs2_7 hs1_7 hcarry2_1 ht377 hs3_7 hs3_8 hs2_8
      hcarry3_1 ht382 hs4_8 hs4_9 hs3_9 hcarry4_1 ht387 hs5_9 hs5_10 hs4_10 hcarry5_1 hs6_10 hs5_11
      hcarry6_2 hs7_11 hs6_11 hcarry7_2 hs8_11 hs7_12 hbs0_4 hbs1_7 hbs2_8 hbs3_9 hbs4_10 hbs5_11
      hbs6_11 hbs7_12

/-- From `%400`: the third pass's `carry8 … carry11`, and `s12` folded into `s1 … s5`. -/
theorem fd_curve25519_scalar_reduce.run400 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 400 = fd_curve25519_scalar_reduce.entry.body.drop 400)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s10_10 s9_10 s11_10 s0_4 s1_7 s2_8 s3_9 s4_10 s5_11 s6_11 s8_11 s7_12 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 352 := s10_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 354 := s9_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 358 := s11_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 370 := s0_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 375 := s1_7,
        rir_reg% fd_curve25519_scalar_reduce.hty 380 := s2_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 385 := s3_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 390 := s4_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 393 := s5_11,
        rir_reg% fd_curve25519_scalar_reduce.hty 396 := s6_11,
        rir_reg% fd_curve25519_scalar_reduce.hty 398 := s8_11,
        rir_reg% fd_curve25519_scalar_reduce.hty 399 := s7_12])
    (hbs10_10 : Bnd s10_10 (-137839549349888) 137839549412142)
    (hbs11_10 : Bnd s11_10 (-728145712686096) 728145711060637) (hbs1_7 : Bnd s1_7 0 2097151)
    (hbs2_8 : Bnd s2_8 0 2097151) (hbs3_9 : Bnd s3_9 0 2097151) (hbs4_10 : Bnd s4_10 0 2097151)
    (hbs5_11 : Bnd s5_11 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry8_2 s9_11 s8_12 carry9_2 s10_11 s9_12 carry10_2 s11_11 s10_12 carry11_2 s11_12 t411
          t412 s1_8 t414 s2_9 t416 s3_10 t418 s4_11 t420 s5_12 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 370 := s0_4,
              rir_reg% fd_curve25519_scalar_reduce.hty 396 := s6_11,
              rir_reg% fd_curve25519_scalar_reduce.hty 399 := s7_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 402 := s8_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 405 := s9_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 408 := s10_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 410 := s11_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 411 := t411,
              rir_reg% fd_curve25519_scalar_reduce.hty 413 := s1_8,
              rir_reg% fd_curve25519_scalar_reduce.hty 415 := s2_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 417 := s3_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 419 := s4_11,
              rir_reg% fd_curve25519_scalar_reduce.hty 421 := s5_12]) →
          (hcarry8_2 : carry8_2 = s8_11.sshiftRight 21) →
          (hs9_11 : s9_11 = carry8_2 + s9_10) →
          (hs8_12 : s8_12 = s8_11 &&& 2097151#64) →
          (hcarry9_2 : carry9_2 = s9_11.sshiftRight 21) →
          (hs10_11 : s10_11 = s10_10 + carry9_2) →
          (hs9_12 : s9_12 = s9_11 &&& 2097151#64) →
          (hcarry10_2 : carry10_2 = s10_11.sshiftRight 21) →
          (hs11_11 : s11_11 = carry10_2 + s11_10) →
          (hs10_12 : s10_12 = s10_11 &&& 2097151#64) →
          (hcarry11_2 : carry11_2 = s11_11.sshiftRight 21) →
          (hs11_12 : s11_12 = s11_11 &&& 2097151#64) →
          (ht411 : t411 = carry11_2 * 666643#64) →
          (ht412 : t412 = carry11_2 * 470296#64) →
          (hs1_8 : s1_8 = t412 + s1_7) →
          (ht414 : t414 = carry11_2 * 654183#64) →
          (hs2_9 : s2_9 = t414 + s2_8) →
          (ht416 : t416 = carry11_2 * 18446744073708553811#64) →
          (hs3_10 : s3_10 = t416 + s3_9) →
          (ht418 : t418 = carry11_2 * 136657#64) →
          (hs4_11 : s4_11 = t418 + s4_10) →
          (ht420 : t420 = carry11_2 * 18446744073708867715#64) →
          (hs5_12 : s5_12 = t420 + s5_11) →
          (hbs8_12 : Bnd s8_12 0 2097151) →
          (hbs9_12 : Bnd s9_12 0 2097151) →
          (hbs10_12 : Bnd s10_12 0 2097151) →
          (hbs11_12 : Bnd s11_12 0 2097151) →
          (hbt411 : Bnd t411 (-231463092768495) 231463091435209) →
          (hbs1_8 : Bnd s1_8 (-163290046811640) 163290047968199) →
          (hbs2_9 : Bnd s2_9 (-227136893984595) 227136894773380) →
          (hbs3_10 : Bnd s3_10 (-346444843716215) 346444847808976) →
          (hbs4_11 : Bnd s4_11 (-47448262216005) 47448264039842) →
          (hbs5_12 : Bnd s5_12 (-237455189202663) 237455192667616) →
          (blk.runBodyFrom E' 422 S >>= g) = K) :
    (blk.runBodyFrom E 400 S >>= g) = K := by
  step_pure with carry8_2
  bnd carry8_2
  step_pure with s9_11
  bnd s9_11
  step_pure with s8_12
  bnd s8_12
  step_pure with carry9_2
  bnd carry9_2
  step_pure with s10_11
  bnd s10_11
  step_pure with s9_12
  bnd s9_12
  step_pure with carry10_2
  bnd carry10_2
  step_pure with s11_11
  bnd s11_11
  step_pure with s10_12
  bnd s10_12
  step_pure with carry11_2
  bnd carry11_2
  step_pure with s11_12
  bnd s11_12
  step_pure [nswMul, nuwMul] with t411
  bnd t411
  step_pure [nswMul, nuwMul] with t412
  bnd t412
  step_pure [nswAdd, nuwAdd] with s1_8
  bnd s1_8
  step_pure [nswMul, nuwMul] with t414
  bnd t414
  step_pure [nswAdd, nuwAdd] with s2_9
  bnd s2_9
  step_pure [nswMul, nuwMul] with t416
  bnd t416
  step_pure [nswAdd, nuwAdd] with s3_10
  bnd s3_10
  step_pure [nswMul, nuwMul] with t418
  bnd t418
  step_pure [nswAdd, nuwAdd] with s4_11
  bnd s4_11
  step_pure [nswMul, nuwMul] with t420
  bnd t420
  step_pure [nswAdd, nuwAdd] with s5_12
  bnd s5_12
  exact
    hK _ carry8_2 s9_11 s8_12 carry9_2 s10_11 s9_12 carry10_2 s11_11 s10_12 carry11_2 s11_12 t411
      t412 s1_8 t414 s2_9 t416 s3_10 t418 s4_11 t420 s5_12 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hcarry8_2 hs9_11 hs8_12 hcarry9_2 hs10_11 hs9_12 hcarry10_2 hs11_11 hs10_12
      hcarry11_2 hs11_12 ht411 ht412 hs1_8 ht414 hs2_9 ht416 hs3_10 ht418 hs4_11 ht420 hs5_12
      hbs8_12 hbs9_12 hbs10_12 hbs11_12 hbt411 hbs1_8 hbs2_9 hbs3_10 hbs4_11 hbs5_12

/-- From `%422`: `s12` folded into `s0`, and the last pass's `carry0 … carry10`. -/
theorem fd_curve25519_scalar_reduce.run422 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 422 = fd_curve25519_scalar_reduce.entry.body.drop 422)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_4 s6_11 s7_12 s8_12 s9_12 s10_12 s11_12 t411 s1_8 s2_9 s3_10 s4_11 s5_12 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 370 := s0_4,
        rir_reg% fd_curve25519_scalar_reduce.hty 396 := s6_11,
        rir_reg% fd_curve25519_scalar_reduce.hty 399 := s7_12,
        rir_reg% fd_curve25519_scalar_reduce.hty 402 := s8_12,
        rir_reg% fd_curve25519_scalar_reduce.hty 405 := s9_12,
        rir_reg% fd_curve25519_scalar_reduce.hty 408 := s10_12,
        rir_reg% fd_curve25519_scalar_reduce.hty 410 := s11_12,
        rir_reg% fd_curve25519_scalar_reduce.hty 411 := t411,
        rir_reg% fd_curve25519_scalar_reduce.hty 413 := s1_8,
        rir_reg% fd_curve25519_scalar_reduce.hty 415 := s2_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 417 := s3_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 419 := s4_11,
        rir_reg% fd_curve25519_scalar_reduce.hty 421 := s5_12])
    (hbs0_4 : Bnd s0_4 0 2097151) (hbs6_11 : Bnd s6_11 0 2097151) (hbs7_12 : Bnd s7_12 0 2097151)
    (hbs8_12 : Bnd s8_12 0 2097151) (hbs9_12 : Bnd s9_12 0 2097151)
    (hbs10_12 : Bnd s10_12 0 2097151) (hbs11_12 : Bnd s11_12 0 2097151)
    (hbt411 : Bnd t411 (-231463092768495) 231463091435209)
    (hbs1_8 : Bnd s1_8 (-163290046811640) 163290047968199)
    (hbs2_9 : Bnd s2_9 (-227136893984595) 227136894773380)
    (hbs3_10 : Bnd s3_10 (-346444843716215) 346444847808976)
    (hbs4_11 : Bnd s4_11 (-47448262216005) 47448264039842)
    (hbs5_12 : Bnd s5_12 (-237455189202663) 237455192667616)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s0_5 carry0_2 s1_9 carry1_2 s2_10 carry2_2 s3_11 carry3_2 s4_12 carry4_2 s5_13 carry5_2
          s6_12 carry6_3 s7_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 t443 t444 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 422 := s0_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 424 := s1_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 426 := s2_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 428 := s3_11,
              rir_reg% fd_curve25519_scalar_reduce.hty 430 := s4_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 432 := s5_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 434 := s6_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 436 := s7_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 438 := s8_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 440 := s9_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 442 := s10_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 444 := t444]) →
          (hs0_5 : s0_5 = t411 + s0_4) →
          (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) →
          (hs1_9 : s1_9 = s1_8 + carry0_2) →
          (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21) →
          (hs2_10 : s2_10 = s2_9 + carry1_2) →
          (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) →
          (hs3_11 : s3_11 = s3_10 + carry2_2) →
          (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21) →
          (hs4_12 : s4_12 = s4_11 + carry3_2) →
          (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) →
          (hs5_13 : s5_13 = s5_12 + carry4_2) →
          (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21) →
          (hs6_12 : s6_12 = carry5_2 + s6_11) →
          (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) →
          (hs7_13 : s7_13 = carry6_3 + s7_12) →
          (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21) →
          (hs8_13 : s8_13 = carry7_3 + s8_12) →
          (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) →
          (hs9_13 : s9_13 = carry8_3 + s9_12) →
          (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21) →
          (hs10_13 : s10_13 = carry9_3 + s10_12) →
          (ht443 : t443 = s10_13 >>> 21) →
          (ht444 : t444 = t443 + s11_12) → (blk.runBodyFrom E' 445 S >>= g) = K) :
    (blk.runBodyFrom E 422 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd] with s0_5
  bnd s0_5
  step_pure with carry0_2
  bnd carry0_2
  step_pure [nswAdd, nuwAdd] with s1_9
  bnd s1_9
  step_pure with carry1_2
  bnd carry1_2
  step_pure [nswAdd, nuwAdd] with s2_10
  bnd s2_10
  step_pure with carry2_2
  bnd carry2_2
  step_pure [nswAdd, nuwAdd] with s3_11
  bnd s3_11
  step_pure with carry3_2
  bnd carry3_2
  step_pure [nswAdd, nuwAdd] with s4_12
  bnd s4_12
  step_pure with carry4_2
  bnd carry4_2
  step_pure [nswAdd, nuwAdd] with s5_13
  bnd s5_13
  step_pure with carry5_2
  bnd carry5_2
  step_pure [nswAdd, nuwAdd] with s6_12
  bnd s6_12
  step_pure with carry6_3
  bnd carry6_3
  step_pure [nswAdd, nuwAdd] with s7_13
  bnd s7_13
  step_pure with carry7_3
  bnd carry7_3
  step_pure [nswAdd, nuwAdd] with s8_13
  bnd s8_13
  step_pure with carry8_3
  bnd carry8_3
  step_pure [nswAdd, nuwAdd] with s9_13
  bnd s9_13
  step_pure with carry9_3
  bnd carry9_3
  step_pure [nswAdd, nuwAdd] with s10_13
  bnd s10_13
  step_pure with t443
  bnd t443
  step_pure [nswAdd, nuwAdd] with t444
  bnd t444
  exact
    hK _ s0_5 carry0_2 s1_9 carry1_2 s2_10 carry2_2 s3_11 carry3_2 s4_12 carry4_2 s5_13 carry5_2
      s6_12 carry6_3 s7_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 t443 t444 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hs0_5 hcarry0_2 hs1_9 hcarry1_2 hs2_10 hcarry2_2 hs3_11 hcarry3_2 hs4_12
      hcarry4_2 hs5_13 hcarry5_2 hs6_12 hcarry6_3 hs7_13 hcarry7_3 hs8_13 hcarry8_3 hs9_13 hcarry9_3
      hs10_13 ht443 ht444

/-- From `%445`: the limbs packed into four words, stored at `out`. -/
theorem fd_curve25519_scalar_reduce.run445 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 445 = fd_curve25519_scalar_reduce.entry.body.drop 445)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t444 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) (hwf : S.WF)
    (hout : Room S.mem out (8 * 32)) (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 422 := s0_5,
        rir_reg% fd_curve25519_scalar_reduce.hty 424 := s1_9,
        rir_reg% fd_curve25519_scalar_reduce.hty 426 := s2_10,
        rir_reg% fd_curve25519_scalar_reduce.hty 428 := s3_11,
        rir_reg% fd_curve25519_scalar_reduce.hty 430 := s4_12,
        rir_reg% fd_curve25519_scalar_reduce.hty 432 := s5_13,
        rir_reg% fd_curve25519_scalar_reduce.hty 434 := s6_12,
        rir_reg% fd_curve25519_scalar_reduce.hty 436 := s7_13,
        rir_reg% fd_curve25519_scalar_reduce.hty 438 := s8_13,
        rir_reg% fd_curve25519_scalar_reduce.hty 440 := s9_13,
        rir_reg% fd_curve25519_scalar_reduce.hty 442 := s10_13,
        rir_reg% fd_curve25519_scalar_reduce.hty 444 := t444])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (t471 : Vector (BitVec 64) 4),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (ht471 :
            t471 =
              #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                  (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64) |||
                  s3_11 <<< 63,
                s5_13 <<< 41 &&& 4611683819404132352#64 |||
                  (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64) |||
                  s6_12 <<< 62,
                s8_13 <<< 40 &&& 2305841909702066176#64 |||
                  (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64) |||
                  s9_13 <<< 61,
                s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64 ||| t444 <<< 39]) →
          (blk.runBodyFrom E' 473 { S with mem := S.mem.storeAt out (BitVec.packLanes t471) } >>=
              g) =
            K) :
    (blk.runBodyFrom E 445 S >>= g) = K := by
  step_pure [expandOfFn] with t445
  step_pure [expandOfFn, ht445] with t446
  step_pure [expandOfFn, ht446] with t447
  step_pure [expandOfFn, ht447] with t448
  step_pure [expandOfFn, ht448] with t449
  step_pure [expandOfFn] with t450
  step_pure [expandOfFn, ht450] with t451
  step_pure [expandOfFn, ht451] with t452
  step_pure [expandOfFn, ht452] with t453
  step_pure [expandOfFn, ht453] with t454
  step_pure [expandOfFn, ht453] with t455
  step_pure [expandOfFn, ht454, ht455] with t456
  step_pure [expandOfFn, ht456] with t457
  step_pure [expandOfFn] with t458
  step_pure [expandOfFn, ht458] with t459
  step_pure [expandOfFn, ht459] with t460
  step_pure [expandOfFn, ht460] with t461
  step_pure [expandOfFn, ht461] with t462
  step_pure [expandOfFn, ht462] with t463
  step_pure [expandOfFn, ht463, ht449, fd_curve25519_scalar_reduce.disj0,
    fd_curve25519_scalar_reduce.disj1, fd_curve25519_scalar_reduce.disj2] with t464
  step_pure [expandOfFn, ht457, ht464, fd_curve25519_scalar_reduce.disj0,
    fd_curve25519_scalar_reduce.disj1, fd_curve25519_scalar_reduce.disj2,
    fd_curve25519_scalar_reduce.disj3, fd_curve25519_scalar_reduce.disj4,
    fd_curve25519_scalar_reduce.disj5, fd_curve25519_scalar_reduce.disj6] with t465
  step_pure [expandOfFn] with t466
  step_pure [expandOfFn, ht466] with t467
  step_pure [expandOfFn, ht467] with t468
  step_pure [expandOfFn, ht468] with t469
  step_pure [expandOfFn, ht469] with t470
  step_pure [expandOfFn, ht465, ht470, fd_curve25519_scalar_reduce.disj0,
    fd_curve25519_scalar_reduce.disj1, fd_curve25519_scalar_reduce.disj2,
    fd_curve25519_scalar_reduce.disj3, fd_curve25519_scalar_reduce.disj4,
    fd_curve25519_scalar_reduce.disj5, fd_curve25519_scalar_reduce.disj6,
    fd_curve25519_scalar_reduce.disj7, fd_curve25519_scalar_reduce.disj8,
    fd_curve25519_scalar_reduce.disj9, fd_curve25519_scalar_reduce.disj10] with t471
  step_store
  subst hS
  exact hK _ t471 hArgs ht471

/-! ### The C values

Each carry over the earlier ones and `in0 … in7`, and each packed limb before its last
carry, as the spec's lets expand. -/

theorem fd_curve25519_scalar_reduce.carry6_eq
    {in1 in2 in5 in6 t76 s6 s18 t154 s6_1 t168 carry6 : BitVec 64}
    (hcarry6 : carry6 = t168.sshiftRight 21) (ht168 : t168 = s6_1 + 1048576#64)
    (hs6_1 : s6_1 = t154 + s6) (ht154 : t154 = s18 * 666643#64) (hs6 : s6 = t76 &&& 2097151#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht76 : t76 = BitVec.extractLsb' 64 64 ((in2 ++ in1) <<< 2)) :
    carry6 =
      ((((((in1 >>> 62) ||| (in2 <<< 2)) &&& 2097151#64) +
              ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 666643#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry6]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht168 hs6_1 ht154 hs6 hs18 ht76
  simp only [Bnd.fshl_eq _ _ 2 (by decide), Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry8_eq
    {in2 in5 in6 t81 s8 s20 t136 s8_1 s19 t144 s8_2 s18 t158 s8_3 t173 carry8 : BitVec 64}
    (hcarry8 : carry8 = t173.sshiftRight 21) (ht173 : t173 = s8_3 + 1048576#64)
    (hs8_3 : s8_3 = s8_2 + t158) (hs8_2 : s8_2 = s8_1 + t144) (ht158 : t158 = s18 * 654183#64)
    (hs8_1 : s8_1 = t136 + s8) (ht144 : t144 = s19 * 470296#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht136 : t136 = s20 * 666643#64) (hs8 : s8 = t81 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht81 : t81 = in2 >>> 40) :
    carry8 =
      (((((((in2 >>> 40) &&& 2097151#64) + (((in6 >>> 36) &&& 2097151#64) * 666643#64)) +
                (((in6 >>> 15) &&& 2097151#64) * 470296#64)) +
              ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 654183#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry8]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht173 hs8_3 hs8_2 ht158 hs8_1 ht144 hs18 ht136 hs8 hs19 hs20 ht81
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry10_eq
    {in3 in5 in6 in7 t86 s10 s22 s21 t126 t132 s20 t139 s19 t147 s18 t161 t162 t163 t164 t165 s10_5
      t182 carry10 : BitVec 64}
    (hcarry10 : carry10 = t182.sshiftRight 21) (ht182 : t182 = s10_5 + 1048576#64)
    (hs10_5 : s10_5 = t165 + t132) (ht165 : t165 = t164 + t126) (ht132 : t132 = s21 * 470296#64)
    (ht164 : t164 = t163 + t161) (ht126 : t126 = s22 * 666643#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht163 : t163 = t162 + t147) (ht161 : t161 = s18 * 136657#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht162 : t162 = t139 + s10)
    (ht147 : t147 = s19 * 18446744073708553811#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht139 : t139 = s20 * 654183#64) (hs10 : s10 = t86 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht86 : t86 = in3 >>> 18) :
    carry10 =
      (((((((((in3 >>> 18) &&& 2097151#64) + (((in7 >>> 14) &&& 2097151#64) * 666643#64)) +
                    ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 470296#64)) +
                  (((in6 >>> 36) &&& 2097151#64) * 654183#64)) -
                (((in6 >>> 15) &&& 2097151#64) * 997805#64)) +
              ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 136657#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry10]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht182 hs10_5 ht165 ht132 ht164 ht126 hs21 ht163 ht161 hs22 ht162 ht147 hs18 ht139 hs10 hs19
    hs20 ht86
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry12_eq
    {in3 in4 in6 in7 t90 s12 s23 t118 t150 t151 s12_5 t190 carry12 : BitVec 64}
    (hcarry12 : carry12 = t190.sshiftRight 21) (ht190 : t190 = s12_5 + 1048576#64)
    (hs12_5 : s12_5 = t151 + s12) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs23 : s23 = in7 >>> 35) :
    carry12 =
      ((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) + ((in7 >>> 35) * 470296#64)) +
                    (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
              (((in6 >>> 15) &&& 2097151#64) * 683901#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry12]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht190 hs12_5 ht151 hs12 ht150 ht118 ht90 hs23
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry14_eq
    {in4 in6 in7 t95 s14 s22 s21 s23 t120 s14_1 t127 s14_2 t133 s14_3 t197 carry14 : BitVec 64}
    (hcarry14 : carry14 = t197.sshiftRight 21) (ht197 : t197 = s14_3 + 1048576#64)
    (hs14_3 : s14_3 = s14_2 + t133) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs14_1 : s14_1 = t120 + s14)
    (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht120 : t120 = s23 * 18446744073708553811#64) (hs14 : s14 = t95 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (hs23 : s23 = in7 >>> 35) (ht95 : t95 = in4 >>> 38) :
    carry14 =
      (((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
              ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry14]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht197 hs14_3 hs14_2 ht133 hs14_1 ht127 hs21 ht120 hs14 hs22 hs23 ht95
  simp only [Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry16_eq
    {in5 in7 t102 s16 s23 t124 s16_1 t202 carry16 : BitVec 64}
    (hcarry16 : carry16 = t202.sshiftRight 21) (ht202 : t202 = s16_1 + 1048576#64)
    (hs16_1 : s16_1 = t124 + s16) (ht124 : t124 = s23 * 18446744073708867715#64)
    (hs16 : s16 = t102 &&& 2097151#64) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16) :
    carry16 =
      (((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) + 1048576#64)).sshiftRight
        21 := by
  rw [hcarry16]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht202 hs16_1 ht124 hs16 hs23 ht102
  grind

theorem fd_curve25519_scalar_reduce.carry7_eq
    {in2 in5 in6 t79 s7 s19 t142 s7_1 s18 t156 s7_2 carry6 s7_3 t207 carry7 : BitVec 64}
    (hcarry7 : carry7 = t207.sshiftRight 21) (ht207 : t207 = s7_3 + 1048576#64)
    (hs7_3 : s7_3 = s7_2 + carry6) (hs7_2 : s7_2 = s7_1 + t156) (hs7_1 : s7_1 = t142 + s7)
    (ht156 : t156 = s18 * 470296#64) (ht142 : t142 = s19 * 666643#64)
    (hs7 : s7 = t79 &&& 2097151#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (ht79 : t79 = in2 >>> 19) :
    carry7 =
      (((((((in2 >>> 19) &&& 2097151#64) + (((in6 >>> 15) &&& 2097151#64) * 666643#64)) +
                ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 470296#64)) +
              carry6) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry7]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht207 hs7_3 hs7_2 hs7_1 ht156 ht142 hs7 hs18 hs19 ht79
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry9_eq
    {in2 in3 in5 in6 in7 t83 s9 s21 t131 s20 t138 s19 t146 s18 t160 carry8 t175 t176 t177 s9_4 s9_5
      t210 carry9 : BitVec 64}
    (hcarry9 : carry9 = t210.sshiftRight 21) (ht210 : t210 = s9_5 + 1048576#64)
    (hs9_5 : s9_5 = s9_4 + carry8) (hs9_4 : s9_4 = t177 + t131) (ht177 : t177 = t176 + t160)
    (ht131 : t131 = s21 * 666643#64) (ht176 : t176 = t175 + t146)
    (ht160 : t160 = s18 * 18446744073708553811#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht175 : t175 = t138 + s9) (ht146 : t146 = s19 * 654183#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht138 : t138 = s20 * 470296#64) (hs9 : s9 = t83 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht83 : t83 = BitVec.extractLsb' 64 64 ((in3 ++ in2) <<< 3)) :
    carry9 =
      ((((((((((in2 >>> 61) ||| (in3 <<< 3)) &&& 2097151#64) +
                      ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 666643#64)) +
                    (((in6 >>> 36) &&& 2097151#64) * 470296#64)) +
                  (((in6 >>> 15) &&& 2097151#64) * 654183#64)) -
                ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 997805#64)) +
              carry8) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry9]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht210 hs9_5 hs9_4 ht177 ht131 ht176 ht160 hs21 ht175 ht146 hs18 ht138 hs9 hs19 hs20 ht83
  simp only [Bnd.fshl_eq _ _ 3 (by decide), Bnd.fshl_eq _ _ 6 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry11_eq
    {in3 in5 in6 in7 t88 s11 s23 t117 s20 t140 carry10 t184 t185 t186 t187 s11_7 t213 carry11 :
      BitVec 64}
    (hcarry11 : carry11 = t213.sshiftRight 21) (ht213 : t213 = s11_7 + 1048576#64)
    (hs11_7 : s11_7 = t187 + s11) (ht187 : t187 = t185 + t186) (hs11 : s11 = t88 &&& 2097151#64)
    (ht185 : t185 = t184 + t117) (ht186 : t186 = t140 + carry10) (ht88 : t88 = in3 >>> 39)
    (ht184 :
      t184 =
        (in6 >>> 15 &&& 2097151#64) * 136657#64 +
          (BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 470296#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 654183#64)
    (ht117 : t117 = s23 * 666643#64) (ht140 : t140 = s20 * 18446744073708553811#64)
    (hs23 : s23 = in7 >>> 35) (hs20 : s20 = in6 >>> 36 &&& 2097151#64) :
    carry11 =
      (((((((((((in3 >>> 39) &&& 2097151#64) + ((in7 >>> 35) * 666643#64)) +
                        (((in7 >>> 14) &&& 2097151#64) * 470296#64)) +
                      ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 654183#64)) -
                    (((in6 >>> 36) &&& 2097151#64) * 997805#64)) +
                  (((in6 >>> 15) &&& 2097151#64) * 136657#64)) -
                ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 683901#64)) +
              carry10) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry11]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht213 hs11_7 ht187 hs11 ht185 ht186 ht88 ht184 ht117 ht140 hs23 hs20
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry13_eq
    {in4 in6 in7 t93 s13 carry12 t192 t193 s13_5 t218 carry13 : BitVec 64}
    (hcarry13 : carry13 = t218.sshiftRight 21) (ht218 : t218 = s13_5 + 1048576#64)
    (hs13_5 : s13_5 = t193 + s13) (ht193 : t193 = t192 + carry12) (hs13 : s13 = t93 &&& 2097151#64)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17) :
    carry13 =
      (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                    (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
              carry12) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry13]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht218 hs13_5 ht193 hs13 ht192 ht93
  simp only [Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry15_eq
    {in4 in5 in7 t100 s15 s22 s23 t122 s15_1 t129 s15_2 carry14 s15_3 t223 carry15 : BitVec 64}
    (hcarry15 : carry15 = t223.sshiftRight 21) (ht223 : t223 = s15_3 + 1048576#64)
    (hs15_3 : s15_3 = s15_2 + carry14) (hs15_2 : s15_2 = s15_1 + t129) (hs15_1 : s15_1 = t122 + s15)
    (ht129 : t129 = s22 * 18446744073708867715#64) (ht122 : t122 = s23 * 136657#64)
    (hs15 : s15 = t100 &&& 2097151#64) (hs22 : s22 = in7 >>> 14 &&& 2097151#64)
    (hs23 : s23 = in7 >>> 35) (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) :
    carry15 =
      ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) + ((in7 >>> 35) * 136657#64)) -
                (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
              carry14) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry15]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht223 hs15_3 hs15_2 hs15_1 ht129 ht122 hs15 hs22 hs23 ht100
  simp only [Bnd.fshl_eq _ _ 5 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry0_eq
    {in0 in3 in4 in6 in7 s0 t90 s12 s23 t118 t150 t151 s12_5 carry12 t195 s12_6 carry11 s12_7 t285
      s0_1 t297 carry0 : BitVec 64}
    (hcarry0 : carry0 = t297.sshiftRight 21) (ht297 : t297 = s0_1 + 1048576#64)
    (hs0_1 : s0_1 = t285 + s0) (ht285 : t285 = s12_7 * 666643#64) (hs0 : s0 = in0 &&& 2097151#64)
    (hs12_7 : s12_7 = carry11 + s12_6) (hs12_6 : s12_6 = s12_5 - t195) (hs12_5 : s12_5 = t151 + s12)
    (ht195 : t195 = carry12 <<< 21) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs23 : s23 = in7 >>> 35) :
    carry0 =
      ((((in0 &&& 2097151#64) +
              (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                              ((in7 >>> 35) * 470296#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                        (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                      (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                    (carry12 <<< 21)) +
                  carry11) *
                666643#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry0]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht297 hs0_1 ht285 hs0 hs12_7 hs12_6 hs12_5 ht195 ht151 hs12 ht150 ht118 ht90 hs23
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry2_eq
    {in0 in3 in4 in6 in7 t66 s2 t90 s12 t93 s13 t95 s14 s22 s21 s23 t118 t120 s14_1 t127 s14_2 t133
      s14_3 t150 t151 s12_5 carry12 t192 t193 s13_5 t195 s12_6 carry14 t200 s14_4 carry11 s12_7
      carry13 s14_5 t221 s13_6 t262 s2_1 t275 s2_2 t289 s2_3 t302 carry2 : BitVec 64}
    (hcarry2 : carry2 = t302.sshiftRight 21) (ht302 : t302 = s2_3 + 1048576#64)
    (hs2_3 : s2_3 = s2_2 + t289) (hs2_2 : s2_2 = s2_1 + t275) (ht289 : t289 = s12_7 * 654183#64)
    (hs2_1 : s2_1 = t262 + s2) (ht275 : t275 = s13_6 * 470296#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (ht262 : t262 = s14_5 * 666643#64) (hs2 : s2 = t66 &&& 2097151#64)
    (hs13_6 : s13_6 = s13_5 - t221) (hs12_6 : s12_6 = s12_5 - t195)
    (hs14_5 : s14_5 = carry13 + s14_4) (ht66 : t66 = in0 >>> 42) (hs13_5 : s13_5 = t193 + s13)
    (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21)
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs14_2 : s14_2 = s14_1 + t127) (ht133 : t133 = s21 * 18446744073708867715#64)
    (hs23 : s23 = in7 >>> 35) (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht120 : t120 = s23 * 18446744073708553811#64) (hs14 : s14 = t95 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht95 : t95 = in4 >>> 38) :
    carry2 =
      (((((((in0 >>> 42) &&& 2097151#64) +
                  ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                        (carry14 <<< 21)) +
                      carry13) *
                    666643#64)) +
                (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                            (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                        (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                      carry12) -
                    (carry13 <<< 21)) *
                  470296#64)) +
              (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                              ((in7 >>> 35) * 470296#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                        (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                      (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                    (carry12 <<< 21)) +
                  carry11) *
                654183#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry2]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht302 hs2_3 hs2_2 ht289 hs2_1 ht275 hs12_7 ht262 hs2 hs13_6 hs12_6 hs14_5 ht66 hs13_5 ht221
    hs12_5 ht195 hs14_4 ht193 hs13 ht151 hs12 hs14_3 ht200 ht192 ht93 ht150 ht118 ht90 hs14_2 ht133
    hs23 hs14_1 ht127 hs21 ht120 hs14 hs22 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry4_eq
    {in1 in3 in4 in5 in6 in7 t72 s4 t90 s12 t93 s13 t95 s14 t100 s15 t102 s16 s22 s21 s23 t118 t120
      s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12 t192 t193
      s13_5 t195 s12_6 carry14 s15_3 t200 s14_4 carry16 t205 s16_2 carry11 s12_7 carry13 s14_5 t221
      s13_6 carry15 s16_3 t226 s15_4 t239 s4_1 t250 s4_2 t266 s4_3 t279 s4_4 t293 s4_5 t307 carry4 :
      BitVec 64}
    (hcarry4 : carry4 = t307.sshiftRight 21) (ht307 : t307 = s4_5 + 1048576#64)
    (hs4_5 : s4_5 = s4_4 + t293) (hs4_4 : s4_4 = s4_3 + t279) (ht293 : t293 = s12_7 * 136657#64)
    (hs4_3 : s4_3 = s4_2 + t266) (ht279 : t279 = s13_6 * 18446744073708553811#64)
    (hs12_7 : s12_7 = carry11 + s12_6) (hs4_2 : s4_2 = s4_1 + t250)
    (ht266 : t266 = s14_5 * 654183#64) (hs13_6 : s13_6 = s13_5 - t221)
    (hs12_6 : s12_6 = s12_5 - t195) (hs4_1 : s4_1 = t239 + s4) (ht250 : t250 = s15_4 * 470296#64)
    (hs14_5 : s14_5 = carry13 + s14_4) (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21)
    (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21) (ht239 : t239 = s16_3 * 666643#64)
    (hs4 : s4 = t72 &&& 2097151#64) (hs15_4 : s15_4 = s15_3 - t226) (hs14_4 : s14_4 = s14_3 - t200)
    (ht193 : t193 = t192 + carry12) (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118)
    (hs12 : s12 = t90 &&& 2097151#64) (hs16_3 : s16_3 = carry15 + s16_2) (ht72 : t72 = in1 >>> 20)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21) (hs15_1 : s15_1 = t122 + s15)
    (ht129 : t129 = s22 * 18446744073708867715#64) (hs14_1 : s14_1 = t120 + s14)
    (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38) :
    carry4 =
      (((((((((in1 >>> 20) &&& 2097151#64) +
                      ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                            (carry16 <<< 21)) +
                          carry15) *
                        666643#64)) +
                    ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                              ((in7 >>> 35) * 136657#64)) -
                            (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                          carry14) -
                        (carry15 <<< 21)) *
                      470296#64)) +
                  ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                        (carry14 <<< 21)) +
                      carry13) *
                    654183#64)) -
                (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                            (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                        (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                      carry12) -
                    (carry13 <<< 21)) *
                  997805#64)) +
              (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                              ((in7 >>> 35) * 470296#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                        (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                      (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                    (carry12 <<< 21)) +
                  carry11) *
                136657#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry4]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht307 hs4_5 hs4_4 ht293 hs4_3 ht279 hs12_7 hs4_2 ht266 hs13_6 hs12_6 hs4_1 ht250 hs14_5
    hs13_5 ht221 hs12_5 ht195 ht239 hs4 hs15_4 hs14_4 ht193 hs13 ht151 hs12 hs16_3 ht72 hs15_3 ht226
    hs14_3 ht200 ht192 ht93 ht150 ht118 ht90 hs16_2 hs15_2 hs14_2 ht133 hs23 hs16_1 ht205 hs15_1
    ht129 hs14_1 ht127 hs21 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht102 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry6_1_eq
    {in1 in2 in4 in5 in6 in7 t76 s6 t93 s13 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23 t120
      s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 s18 t154 s6_1 carry6 t171 s6_2
      carry12 t192 t193 s13_5 carry14 s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry13 s14_5 t221
      s13_6 carry15 s16_3 t226 s15_4 t230 s6_3 t243 s6_4 t254 s6_5 t270 s6_6 t283 s6_7 t312
      carry6_1 : BitVec 64}
    (hcarry6_1 : carry6_1 = t312.sshiftRight 21) (ht312 : t312 = s6_7 + 1048576#64)
    (hs6_7 : s6_7 = s6_6 + t283) (hs6_6 : s6_6 = s6_5 + t270)
    (ht283 : t283 = s13_6 * 18446744073708867715#64) (hs6_5 : s6_5 = s6_4 + t254)
    (ht270 : t270 = s14_5 * 136657#64) (hs13_6 : s13_6 = s13_5 - t221) (hs6_4 : s6_4 = s6_3 + t243)
    (ht254 : t254 = s15_4 * 18446744073708553811#64) (hs14_5 : s14_5 = carry13 + s14_4)
    (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21) (hs6_3 : s6_3 = s6_2 + t230)
    (ht243 : t243 = s16_3 * 654183#64) (hs15_4 : s15_4 = s15_3 - t226)
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (hs6_2 : s6_2 = s6_1 - t171)
    (ht230 : t230 = s17_1 * 470296#64) (hs16_3 : s16_3 = carry15 + s16_2)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17) (hs6_1 : s6_1 = t154 + s6) (ht171 : t171 = carry6 <<< 21)
    (hs17_1 : s17_1 = carry16 + s17) (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129)
    (hs14_2 : s14_2 = s14_1 + t127) (ht133 : t133 = s21 * 18446744073708867715#64)
    (ht154 : t154 = s18 * 666643#64) (hs6 : s6 = t76 &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht76 : t76 = BitVec.extractLsb' 64 64 ((in2 ++ in1) <<< 2)) (ht104 : t104 = in5 >>> 37)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38) :
    carry6_1 =
      ((((((((((((in1 >>> 62) ||| (in2 <<< 2)) &&& 2097151#64) +
                          ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 666643#64)) -
                        (carry6 <<< 21)) +
                      ((((in5 >>> 37) &&& 2097151#64) + carry16) * 470296#64)) +
                    ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                          (carry16 <<< 21)) +
                        carry15) *
                      654183#64)) -
                  ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                            ((in7 >>> 35) * 136657#64)) -
                          (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                        carry14) -
                      (carry15 <<< 21)) *
                    997805#64)) +
                ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                          (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                        ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                      (carry14 <<< 21)) +
                    carry13) *
                  136657#64)) -
              (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                          (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                        ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                      (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                    carry12) -
                  (carry13 <<< 21)) *
                683901#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry6_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht312 hs6_7 hs6_6 ht283 hs6_5 ht270 hs13_6 hs6_4 ht254 hs14_5 hs13_5 ht221 hs6_3 ht243
    hs15_4 hs14_4 ht193 hs13 hs6_2 ht230 hs16_3 hs15_3 ht226 hs14_3 ht200 ht192 ht93 hs6_1 ht171
    hs17_1 hs16_2 hs15_2 hs14_2 ht133 ht154 hs6 hs17 hs16_1 ht205 hs15_1 ht129 hs14_1 ht127 hs21
    hs18 ht76 ht104 ht124 hs16 ht122 hs15 hs22 ht120 hs14 hs23 ht102 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 2 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry8_1_eq
    {in2 in4 in5 in6 in7 t81 s8 t100 s15 t102 s16 t104 s17 s22 s23 t122 s15_1 t124 s16_1 t129 s15_2
      s20 t136 s8_1 s19 t144 s8_2 s18 t158 s8_3 carry8 t180 s8_4 carry14 s15_3 carry16 s17_1 t205
      s16_2 carry7 carry15 s16_3 t226 s15_4 t233 t246 t257 t258 s8_6 s8_7 s8_8 t322 carry8_1 :
      BitVec 64}
    (hcarry8_1 : carry8_1 = t322.sshiftRight 21) (ht322 : t322 = s8_8 + 1048576#64)
    (hs8_8 : s8_8 = s8_7 + t257) (hs8_7 : s8_7 = s8_6 + t246)
    (ht257 : t257 = s15_4 * 18446744073708867715#64) (hs8_6 : s8_6 = t258 + carry7)
    (ht246 : t246 = s16_3 * 136657#64) (hs15_4 : s15_4 = s15_3 - t226) (ht258 : t258 = s8_4 + t233)
    (hs16_3 : s16_3 = carry15 + s16_2) (hs15_3 : s15_3 = s15_2 + carry14)
    (ht226 : t226 = carry15 <<< 21) (hs8_4 : s8_4 = s8_3 - t180)
    (ht233 : t233 = s17_1 * 18446744073708553811#64) (hs16_2 : s16_2 = s16_1 - t205)
    (hs15_2 : s15_2 = s15_1 + t129) (hs8_3 : s8_3 = s8_2 + t158) (ht180 : t180 = carry8 <<< 21)
    (hs17_1 : s17_1 = carry16 + s17) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs8_2 : s8_2 = s8_1 + t144) (ht158 : t158 = s18 * 654183#64) (hs17 : s17 = t104 &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (hs8_1 : s8_1 = t136 + s8)
    (ht144 : t144 = s19 * 470296#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht136 : t136 = s20 * 666643#64)
    (hs8 : s8 = t81 &&& 2097151#64) (hs19 : s19 = in6 >>> 15 &&& 2097151#64)
    (hs20 : s20 = in6 >>> 36 &&& 2097151#64) (ht81 : t81 = in2 >>> 40) :
    carry8_1 =
      ((((((((((((in2 >>> 40) &&& 2097151#64) + (((in6 >>> 36) &&& 2097151#64) * 666643#64)) +
                          (((in6 >>> 15) &&& 2097151#64) * 470296#64)) +
                        ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 654183#64)) -
                      (carry8 <<< 21)) +
                    carry7) -
                  ((((in5 >>> 37) &&& 2097151#64) + carry16) * 997805#64)) +
                ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                      (carry16 <<< 21)) +
                    carry15) *
                  136657#64)) -
              ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) + ((in7 >>> 35) * 136657#64)) -
                      (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                    carry14) -
                  (carry15 <<< 21)) *
                683901#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry8_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht322 hs8_8 hs8_7 ht257 hs8_6 ht246 hs15_4 ht258 hs16_3 hs15_3 ht226 hs8_4 ht233 hs16_2
    hs15_2 hs8_3 ht180 hs17_1 hs16_1 ht205 hs15_1 ht129 hs8_2 ht158 hs17 ht124 hs16 ht122 hs15 hs22
    hs8_1 ht144 hs18 ht104 hs23 ht102 ht100 ht136 hs8 hs19 hs20 ht81
  simp only [Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry10_1_eq
    {in3 in5 in6 in7 t86 s10 t104 s17 s22 s21 t126 t132 s20 t139 s19 t147 s18 t161 t162 t163 t164
      t165 s10_5 carry10 t189 carry16 s17_1 carry9 t235 t236 t237 s10_8 t330 carry10_1 : BitVec 64}
    (hcarry10_1 : carry10_1 = t330.sshiftRight 21) (ht330 : t330 = s10_8 + 1048576#64)
    (hs10_8 : s10_8 = t237 + carry9) (ht237 : t237 = t236 - t189) (ht236 : t236 = s10_5 + t235)
    (ht189 : t189 = carry10 <<< 21) (hs10_5 : s10_5 = t165 + t132)
    (ht235 : t235 = s17_1 * 18446744073708867715#64) (ht165 : t165 = t164 + t126)
    (ht132 : t132 = s21 * 470296#64) (hs17_1 : s17_1 = carry16 + s17) (ht164 : t164 = t163 + t161)
    (ht126 : t126 = s22 * 666643#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (ht163 : t163 = t162 + t147) (ht161 : t161 = s18 * 136657#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht104 : t104 = in5 >>> 37) (ht162 : t162 = t139 + s10)
    (ht147 : t147 = s19 * 18446744073708553811#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht139 : t139 = s20 * 654183#64) (hs10 : s10 = t86 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht86 : t86 = in3 >>> 18) :
    carry10_1 =
      ((((((((((((in3 >>> 18) &&& 2097151#64) + (((in7 >>> 14) &&& 2097151#64) * 666643#64)) +
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 470296#64)) +
                        (((in6 >>> 36) &&& 2097151#64) * 654183#64)) -
                      (((in6 >>> 15) &&& 2097151#64) * 997805#64)) +
                    ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 136657#64)) -
                  (carry10 <<< 21)) +
                carry9) -
              ((((in5 >>> 37) &&& 2097151#64) + carry16) * 683901#64)) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry10_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht330 hs10_8 ht237 ht236 ht189 hs10_5 ht235 ht165 ht132 hs17_1 ht164 ht126 hs21 hs17 ht163
    ht161 hs22 ht104 ht162 ht147 hs18 ht139 hs10 hs19 hs20 ht86
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry1_eq
    {in0 in3 in4 in6 in7 t64 s1 t90 s12 t93 s13 s23 t118 t150 t151 s12_5 carry12 t192 t193 s13_5
      t195 s12_6 carry11 s12_7 carry13 t221 s13_6 t273 s1_1 t287 s1_2 carry0 s1_3 t335 carry1 :
      BitVec 64}
    (hcarry1 : carry1 = t335.sshiftRight 21) (ht335 : t335 = s1_3 + 1048576#64)
    (hs1_3 : s1_3 = s1_2 + carry0) (hs1_2 : s1_2 = s1_1 + t287) (hs1_1 : s1_1 = t273 + s1)
    (ht287 : t287 = s12_7 * 470296#64) (ht273 : t273 = s13_6 * 666643#64)
    (hs1 : s1 = t64 &&& 2097151#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (hs13_6 : s13_6 = s13_5 - t221) (ht64 : t64 = in0 >>> 21) (hs12_6 : s12_6 = s12_5 - t195)
    (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12)
    (ht195 : t195 = carry12 <<< 21) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs23 : s23 = in7 >>> 35) :
    carry1 =
      (((((((in0 >>> 21) &&& 2097151#64) +
                  (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                          (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    666643#64)) +
                (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                ((in7 >>> 35) * 470296#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                          (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                        (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  470296#64)) +
              carry0) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht335 hs1_3 hs1_2 hs1_1 ht287 ht273 hs1 hs12_7 hs13_6 ht64 hs12_6 hs13_5 ht221 hs12_5 ht195
    ht193 hs13 ht151 hs12 ht192 ht93 ht150 ht118 ht90 hs23
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry3_eq
    {in0 in1 in3 in4 in5 in6 in7 t69 s3 t90 s12 t93 s13 t95 s14 t100 s15 s22 s21 s23 t118 t120 s14_1
      t122 s15_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12 t192 t193 s13_5 t195 s12_6
      carry14 s15_3 t200 s14_4 carry11 s12_7 carry13 s14_5 t221 s13_6 carry15 t226 s15_4 t248 s3_1
      t264 s3_2 t277 s3_3 t291 s3_4 carry2 s3_5 t338 carry3 : BitVec 64}
    (hcarry3 : carry3 = t338.sshiftRight 21) (ht338 : t338 = s3_5 + 1048576#64)
    (hs3_5 : s3_5 = s3_4 + carry2) (hs3_4 : s3_4 = s3_3 + t291) (hs3_3 : s3_3 = s3_2 + t277)
    (ht291 : t291 = s12_7 * 18446744073708553811#64) (hs3_2 : s3_2 = s3_1 + t264)
    (ht277 : t277 = s13_6 * 654183#64) (hs12_7 : s12_7 = carry11 + s12_6) (hs3_1 : s3_1 = t248 + s3)
    (ht264 : t264 = s14_5 * 470296#64) (hs13_6 : s13_6 = s13_5 - t221)
    (hs12_6 : s12_6 = s12_5 - t195) (ht248 : t248 = s15_4 * 666643#64)
    (hs3 : s3 = t69 &&& 2097151#64) (hs14_5 : s14_5 = carry13 + s14_4) (hs13_5 : s13_5 = t193 + s13)
    (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21)
    (hs15_4 : s15_4 = s15_3 - t226) (ht69 : t69 = BitVec.extractLsb' 64 64 ((in1 ++ in0) <<< 1))
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5))
    (ht95 : t95 = in4 >>> 38) :
    carry3 =
      ((((((((((in0 >>> 63) ||| (in1 <<< 1)) &&& 2097151#64) +
                      ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                ((in7 >>> 35) * 136657#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                            carry14) -
                          (carry15 <<< 21)) *
                        666643#64)) +
                    ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                          (carry14 <<< 21)) +
                        carry13) *
                      470296#64)) +
                  (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                          (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    654183#64)) -
                (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                ((in7 >>> 35) * 470296#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                          (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                        (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  997805#64)) +
              carry2) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry3]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht338 hs3_5 hs3_4 hs3_3 ht291 hs3_2 ht277 hs12_7 hs3_1 ht264 hs13_6 hs12_6 ht248 hs3 hs14_5
    hs13_5 ht221 hs12_5 ht195 hs15_4 ht69 hs14_4 ht193 hs13 ht151 hs12 hs15_3 ht226 hs14_3 ht200
    ht192 ht93 ht150 ht118 ht90 hs15_2 hs14_2 ht133 hs23 hs15_1 ht129 hs14_1 ht127 hs21 ht122 hs15
    hs22 ht120 hs14 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 1 (by decide), Bnd.fshl_eq _ _ 4 (by decide),
    Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry5_eq
    {in1 in3 in4 in5 in6 in7 t74 s5 t90 s12 t93 s13 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23
      t118 t120 s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12
      t192 t193 s13_5 t195 s12_6 carry14 s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry11 s12_7
      carry13 s14_5 t221 s13_6 carry15 s16_3 t226 s15_4 t228 s5_1 t241 s5_2 t252 s5_3 t268 s5_4 t281
      s5_5 t295 s5_6 carry4 s5_7 t341 carry5 : BitVec 64}
    (hcarry5 : carry5 = t341.sshiftRight 21) (ht341 : t341 = s5_7 + 1048576#64)
    (hs5_7 : s5_7 = s5_6 + carry4) (hs5_6 : s5_6 = s5_5 + t295) (hs5_5 : s5_5 = s5_4 + t281)
    (ht295 : t295 = s12_7 * 18446744073708867715#64) (hs5_4 : s5_4 = s5_3 + t268)
    (ht281 : t281 = s13_6 * 136657#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (hs5_3 : s5_3 = s5_2 + t252) (ht268 : t268 = s14_5 * 18446744073708553811#64)
    (hs13_6 : s13_6 = s13_5 - t221) (hs12_6 : s12_6 = s12_5 - t195) (hs5_2 : s5_2 = s5_1 + t241)
    (ht252 : t252 = s15_4 * 654183#64) (hs14_5 : s14_5 = carry13 + s14_4)
    (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12)
    (ht195 : t195 = carry12 <<< 21) (hs5_1 : s5_1 = t228 + s5) (ht241 : t241 = s16_3 * 470296#64)
    (hs15_4 : s15_4 = s15_3 - t226) (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht228 : t228 = s17_1 * 666643#64) (hs5 : s5 = t74 &&& 2097151#64)
    (hs16_3 : s16_3 = carry15 + s16_2) (hs15_3 : s15_3 = s15_2 + carry14)
    (ht226 : t226 = carry15 <<< 21) (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs17_1 : s17_1 = carry16 + s17) (ht74 : t74 = in1 >>> 41) (hs16_2 : s16_2 = s16_1 - t205)
    (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs17 : s17 = t104 &&& 2097151#64) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (ht124 : t124 = s23 * 18446744073708867715#64)
    (hs16 : s16 = t102 &&& 2097151#64) (ht122 : t122 = s23 * 136657#64)
    (hs15 : s15 = t100 &&& 2097151#64) (hs22 : s22 = in7 >>> 14 &&& 2097151#64)
    (ht120 : t120 = s23 * 18446744073708553811#64) (hs14 : s14 = t95 &&& 2097151#64)
    (ht102 : t102 = in5 >>> 16) (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5))
    (ht95 : t95 = in4 >>> 38) :
    carry5 =
      (((((((((((in1 >>> 41) &&& 2097151#64) +
                          ((((in5 >>> 37) &&& 2097151#64) + carry16) * 666643#64)) +
                        ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                              (carry16 <<< 21)) +
                            carry15) *
                          470296#64)) +
                      ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                ((in7 >>> 35) * 136657#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                            carry14) -
                          (carry15 <<< 21)) *
                        654183#64)) -
                    ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                          (carry14 <<< 21)) +
                        carry13) *
                      997805#64)) +
                  (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                          (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    136657#64)) -
                (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                ((in7 >>> 35) * 470296#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                          (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                        (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  683901#64)) +
              carry4) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry5]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht341 hs5_7 hs5_6 hs5_5 ht295 hs5_4 ht281 hs12_7 hs5_3 ht268 hs13_6 hs12_6 hs5_2 ht252
    hs14_5 hs13_5 ht221 hs12_5 ht195 hs5_1 ht241 hs15_4 hs14_4 ht193 hs13 ht151 hs12 ht228 hs5
    hs16_3 hs15_3 ht226 hs14_3 ht200 ht192 ht93 ht150 ht118 ht90 hs17_1 ht74 hs16_2 hs15_2 hs14_2
    ht133 hs23 hs17 hs16_1 ht205 hs15_1 ht129 hs14_1 ht127 hs21 ht104 ht124 hs16 ht122 hs15 hs22
    ht120 hs14 ht102 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry7_1_eq
    {in2 in4 in5 in6 in7 t79 s7 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23 t120 s14_1 t122 s15_1
      t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 s19 t142 s7_1 s18 t156 s7_2 carry6 s7_3 carry14
      s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry7 t209 carry13 s14_5 carry15 s16_3 t226 s15_4
      t232 t245 t256 t272 carry6_1 t314 s7_5 s7_6 s7_7 s7_8 s7_9 t345 carry7_1 : BitVec 64}
    (hcarry7_1 : carry7_1 = t345.sshiftRight 21) (ht345 : t345 = s7_9 + 1048576#64)
    (hs7_9 : s7_9 = s7_8 + carry6_1) (hs7_8 : s7_8 = s7_7 + t272) (hs7_7 : s7_7 = s7_6 + t256)
    (ht272 : t272 = s14_5 * 18446744073708867715#64) (hs7_6 : s7_6 = s7_5 + t245)
    (ht256 : t256 = s15_4 * 136657#64) (hs14_5 : s14_5 = carry13 + s14_4)
    (hs7_5 : s7_5 = t314 - t209) (ht245 : t245 = s16_3 * 18446744073708553811#64)
    (hs15_4 : s15_4 = s15_3 - t226) (hs14_4 : s14_4 = s14_3 - t200) (ht314 : t314 = t232 + s7_3)
    (ht209 : t209 = carry7 <<< 21) (hs16_3 : s16_3 = carry15 + s16_2)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht232 : t232 = s17_1 * 654183#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs17_1 : s17_1 = carry16 + s17)
    (hs7_2 : s7_2 = s7_1 + t156) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (hs7_1 : s7_1 = t142 + s7) (ht156 : t156 = s18 * 470296#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht104 : t104 = in5 >>> 37) (ht142 : t142 = s19 * 666643#64)
    (hs7 : s7 = t79 &&& 2097151#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (ht79 : t79 = in2 >>> 19) :
    carry7_1 =
      (((((((((((((in2 >>> 19) &&& 2097151#64) + (((in6 >>> 15) &&& 2097151#64) * 666643#64)) +
                            ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 470296#64)) +
                          carry6) -
                        (carry7 <<< 21)) +
                      ((((in5 >>> 37) &&& 2097151#64) + carry16) * 654183#64)) -
                    ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                          (carry16 <<< 21)) +
                        carry15) *
                      997805#64)) +
                  ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                            ((in7 >>> 35) * 136657#64)) -
                          (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                        carry14) -
                      (carry15 <<< 21)) *
                    136657#64)) -
                ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                          (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                        ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                      (carry14 <<< 21)) +
                    carry13) *
                  683901#64)) +
              carry6_1) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry7_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht345 hs7_9 hs7_8 hs7_7 ht272 hs7_6 ht256 hs14_5 hs7_5 ht245 hs15_4 hs14_4 ht314 ht209
    hs16_3 hs15_3 ht226 hs14_3 ht200 ht232 hs7_3 hs16_2 hs15_2 hs14_2 ht133 hs17_1 hs7_2 hs16_1
    ht205 hs15_1 ht129 hs14_1 ht127 hs21 hs17 hs7_1 ht156 ht124 hs16 ht122 hs15 hs22 ht120 hs14
    ht104 ht142 hs7 hs18 hs23 ht102 ht100 ht95 hs19 ht79
  simp only [Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 6 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry9_1_eq
    {in2 in3 in5 in6 in7 t83 s9 t102 s16 t104 s17 s21 s23 t124 s16_1 t131 s20 t138 s19 t146 s18 t160
      carry8 t175 t176 t177 s9_4 s9_5 carry16 s17_1 t205 s16_2 carry9 t212 carry15 s16_3 t234 t247
      carry8_1 t324 s9_7 s9_8 s9_9 t350 carry9_1 : BitVec 64}
    (hcarry9_1 : carry9_1 = t350.sshiftRight 21) (ht350 : t350 = s9_9 + 1048576#64)
    (hs9_9 : s9_9 = s9_8 + carry8_1) (hs9_8 : s9_8 = s9_7 + t247) (hs9_7 : s9_7 = t324 - t212)
    (ht247 : t247 = s16_3 * 18446744073708867715#64) (ht324 : t324 = s9_5 + t234)
    (ht212 : t212 = carry9 <<< 21) (hs16_3 : s16_3 = carry15 + s16_2) (hs9_5 : s9_5 = s9_4 + carry8)
    (ht234 : t234 = s17_1 * 136657#64) (hs16_2 : s16_2 = s16_1 - t205) (hs9_4 : s9_4 = t177 + t131)
    (hs17_1 : s17_1 = carry16 + s17) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (ht177 : t177 = t176 + t160) (ht131 : t131 = s21 * 666643#64) (hs17 : s17 = t104 &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht176 : t176 = t175 + t146) (ht160 : t160 = s18 * 18446744073708553811#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht175 : t175 = t138 + s9) (ht146 : t146 = s19 * 654183#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht138 : t138 = s20 * 470296#64) (hs9 : s9 = t83 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht83 : t83 = BitVec.extractLsb' 64 64 ((in3 ++ in2) <<< 3)) :
    carry9_1 =
      ((((((((((((((in2 >>> 61) ||| (in3 <<< 3)) &&& 2097151#64) +
                              ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 666643#64)) +
                            (((in6 >>> 36) &&& 2097151#64) * 470296#64)) +
                          (((in6 >>> 15) &&& 2097151#64) * 654183#64)) -
                        ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 997805#64)) +
                      carry8) -
                    (carry9 <<< 21)) +
                  ((((in5 >>> 37) &&& 2097151#64) + carry16) * 136657#64)) -
                ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                      (carry16 <<< 21)) +
                    carry15) *
                  683901#64)) +
              carry8_1) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry9_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht350 hs9_9 hs9_8 hs9_7 ht247 ht324 ht212 hs16_3 hs9_5 ht234 hs16_2 hs9_4 hs17_1 hs16_1
    ht205 ht177 ht131 hs17 ht124 hs16 ht176 ht160 hs21 ht104 hs23 ht102 ht175 ht146 hs18 ht138 hs9
    hs19 hs20 ht83
  simp only [Bnd.fshl_eq _ _ 3 (by decide), Bnd.fshl_eq _ _ 6 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry11_1_eq
    {in3 in5 in6 in7 t88 s11 s23 t117 s20 t140 carry10 t184 t185 t186 t187 s11_7 carry11 t216 s11_8
      carry10_1 s11_9 t355 carry11_1 : BitVec 64}
    (hcarry11_1 : carry11_1 = t355.sshiftRight 21) (ht355 : t355 = s11_9 + 1048576#64)
    (hs11_9 : s11_9 = carry10_1 + s11_8) (hs11_8 : s11_8 = s11_7 - t216)
    (hs11_7 : s11_7 = t187 + s11) (ht216 : t216 = carry11 <<< 21) (ht187 : t187 = t185 + t186)
    (hs11 : s11 = t88 &&& 2097151#64) (ht185 : t185 = t184 + t117) (ht186 : t186 = t140 + carry10)
    (ht88 : t88 = in3 >>> 39)
    (ht184 :
      t184 =
        (in6 >>> 15 &&& 2097151#64) * 136657#64 +
          (BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 470296#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 654183#64)
    (ht117 : t117 = s23 * 666643#64) (ht140 : t140 = s20 * 18446744073708553811#64)
    (hs23 : s23 = in7 >>> 35) (hs20 : s20 = in6 >>> 36 &&& 2097151#64) :
    carry11_1 =
      (((((((((((((in3 >>> 39) &&& 2097151#64) + ((in7 >>> 35) * 666643#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 470296#64)) +
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 654183#64)) -
                        (((in6 >>> 36) &&& 2097151#64) * 997805#64)) +
                      (((in6 >>> 15) &&& 2097151#64) * 136657#64)) -
                    ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 683901#64)) +
                  carry10) -
                (carry11 <<< 21)) +
              carry10_1) +
            1048576#64)).sshiftRight
        21 := by
  rw [hcarry11_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst ht355 hs11_9 hs11_8 hs11_7 ht216 ht187 hs11 ht185 ht186 ht88 ht184 ht117 ht140 hs23 hs20
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry0_1_eq
    {in0 in3 in4 in6 in7 s0 t90 s12 s23 t118 t150 t151 s12_5 carry12 t195 s12_6 carry11 s12_7 t285
      s0_1 carry0 t300 s0_2 carry11_1 t359 s0_3 carry0_1 : BitVec 64}
    (hcarry0_1 : carry0_1 = s0_3.sshiftRight 21) (hs0_3 : s0_3 = s0_2 + t359)
    (hs0_2 : s0_2 = s0_1 - t300) (ht359 : t359 = carry11_1 * 666643#64) (hs0_1 : s0_1 = t285 + s0)
    (ht300 : t300 = carry0 <<< 21) (ht285 : t285 = s12_7 * 666643#64)
    (hs0 : s0 = in0 &&& 2097151#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (hs12_6 : s12_6 = s12_5 - t195) (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21)
    (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs23 : s23 = in7 >>> 35) :
    carry0_1 =
      (((((in0 &&& 2097151#64) +
                (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                ((in7 >>> 35) * 470296#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                          (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                        (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  666643#64)) -
              (carry0 <<< 21)) +
            ((0#64 + carry11_1) * 666643#64))).sshiftRight
        21 := by
  rw [hcarry0_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs0_3 hs0_2 ht359 hs0_1 ht300 ht285 hs0 hs12_7 hs12_6 hs12_5 ht195 ht151 hs12 ht150 ht118
    ht90 hs23
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry1_1_eq
    {in0 in3 in4 in6 in7 t64 s1 t90 s12 t93 s13 s23 t118 t150 t151 s12_5 carry12 t192 t193 s13_5
      t195 s12_6 carry11 s12_7 carry13 t221 s13_6 t273 s1_1 t287 s1_2 carry0 s1_3 carry1 t337
      carry11_1 t361 carry0_1 t367 s1_5 s1_6 carry1_1 : BitVec 64}
    (hcarry1_1 : carry1_1 = s1_6.sshiftRight 21) (hs1_6 : s1_6 = s1_5 + carry0_1)
    (hs1_5 : s1_5 = t367 - t337) (ht367 : t367 = t361 + s1_3) (ht337 : t337 = carry1 <<< 21)
    (ht361 : t361 = carry11_1 * 470296#64) (hs1_3 : s1_3 = s1_2 + carry0)
    (hs1_2 : s1_2 = s1_1 + t287) (hs1_1 : s1_1 = t273 + s1) (ht287 : t287 = s12_7 * 470296#64)
    (ht273 : t273 = s13_6 * 666643#64) (hs1 : s1 = t64 &&& 2097151#64)
    (hs12_7 : s12_7 = carry11 + s12_6) (hs13_6 : s13_6 = s13_5 - t221) (ht64 : t64 = in0 >>> 21)
    (hs12_6 : s12_6 = s12_5 - t195) (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21)
    (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs23 : s23 = in7 >>> 35) :
    carry1_1 =
      (((((((((in0 >>> 21) &&& 2097151#64) +
                      (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                  (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        666643#64)) +
                    (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                    ((in7 >>> 35) * 470296#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                              (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                            (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      470296#64)) +
                  carry0) -
                (carry1 <<< 21)) +
              ((0#64 + carry11_1) * 470296#64)) +
            carry0_1)).sshiftRight
        21 := by
  rw [hcarry1_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs1_6 hs1_5 ht367 ht337 ht361 hs1_3 hs1_2 hs1_1 ht287 ht273 hs1 hs12_7 hs13_6 ht64 hs12_6
    hs13_5 ht221 hs12_5 ht195 ht193 hs13 ht151 hs12 ht192 ht93 ht150 ht118 ht90 hs23
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry2_1_eq
    {in0 in3 in4 in6 in7 t66 s2 t90 s12 t93 s13 t95 s14 s22 s21 s23 t118 t120 s14_1 t127 s14_2 t133
      s14_3 t150 t151 s12_5 carry12 t192 t193 s13_5 t195 s12_6 carry14 t200 s14_4 carry11 s12_7
      carry13 s14_5 t221 s13_6 t262 s2_1 t275 s2_2 t289 s2_3 carry2 t305 s2_4 carry1 carry11_1 t362
      carry1_1 t372 s2_6 s2_7 carry2_1 : BitVec 64}
    (hcarry2_1 : carry2_1 = s2_7.sshiftRight 21) (hs2_7 : s2_7 = s2_6 + carry1_1)
    (hs2_6 : s2_6 = t372 + carry1) (ht372 : t372 = s2_4 + t362) (hs2_4 : s2_4 = s2_3 - t305)
    (ht362 : t362 = carry11_1 * 654183#64) (hs2_3 : s2_3 = s2_2 + t289)
    (ht305 : t305 = carry2 <<< 21) (hs2_2 : s2_2 = s2_1 + t275) (ht289 : t289 = s12_7 * 654183#64)
    (hs2_1 : s2_1 = t262 + s2) (ht275 : t275 = s13_6 * 470296#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (ht262 : t262 = s14_5 * 666643#64) (hs2 : s2 = t66 &&& 2097151#64)
    (hs13_6 : s13_6 = s13_5 - t221) (hs12_6 : s12_6 = s12_5 - t195)
    (hs14_5 : s14_5 = carry13 + s14_4) (ht66 : t66 = in0 >>> 42) (hs13_5 : s13_5 = t193 + s13)
    (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21)
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs14_2 : s14_2 = s14_1 + t127) (ht133 : t133 = s21 * 18446744073708867715#64)
    (hs23 : s23 = in7 >>> 35) (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht120 : t120 = s23 * 18446744073708553811#64) (hs14 : s14 = t95 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht95 : t95 = in4 >>> 38) :
    carry2_1 =
      ((((((((((in0 >>> 42) &&& 2097151#64) +
                        ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                              (carry14 <<< 21)) +
                            carry13) *
                          666643#64)) +
                      (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                  (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        470296#64)) +
                    (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                    ((in7 >>> 35) * 470296#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                              (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                            (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      654183#64)) -
                  (carry2 <<< 21)) +
                carry1) +
              ((0#64 + carry11_1) * 654183#64)) +
            carry1_1)).sshiftRight
        21 := by
  rw [hcarry2_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs2_7 hs2_6 ht372 hs2_4 ht362 hs2_3 ht305 hs2_2 ht289 hs2_1 ht275 hs12_7 ht262 hs2 hs13_6
    hs12_6 hs14_5 ht66 hs13_5 ht221 hs12_5 ht195 hs14_4 ht193 hs13 ht151 hs12 hs14_3 ht200 ht192
    ht93 ht150 ht118 ht90 hs14_2 ht133 hs23 hs14_1 ht127 hs21 ht120 hs14 hs22 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry3_1_eq
    {in0 in1 in3 in4 in5 in6 in7 t69 s3 t90 s12 t93 s13 t95 s14 t100 s15 s22 s21 s23 t118 t120 s14_1
      t122 s15_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12 t192 t193 s13_5 t195 s12_6
      carry14 s15_3 t200 s14_4 carry11 s12_7 carry13 s14_5 t221 s13_6 carry15 t226 s15_4 t248 s3_1
      t264 s3_2 t277 s3_3 t291 s3_4 carry2 s3_5 carry3 t340 carry11_1 t363 carry2_1 t377 s3_7 s3_8
      carry3_1 : BitVec 64}
    (hcarry3_1 : carry3_1 = s3_8.sshiftRight 21) (hs3_8 : s3_8 = s3_7 + carry2_1)
    (hs3_7 : s3_7 = t377 - t340) (ht377 : t377 = s3_5 + t363) (ht340 : t340 = carry3 <<< 21)
    (hs3_5 : s3_5 = s3_4 + carry2) (ht363 : t363 = carry11_1 * 18446744073708553811#64)
    (hs3_4 : s3_4 = s3_3 + t291) (hs3_3 : s3_3 = s3_2 + t277)
    (ht291 : t291 = s12_7 * 18446744073708553811#64) (hs3_2 : s3_2 = s3_1 + t264)
    (ht277 : t277 = s13_6 * 654183#64) (hs12_7 : s12_7 = carry11 + s12_6) (hs3_1 : s3_1 = t248 + s3)
    (ht264 : t264 = s14_5 * 470296#64) (hs13_6 : s13_6 = s13_5 - t221)
    (hs12_6 : s12_6 = s12_5 - t195) (ht248 : t248 = s15_4 * 666643#64)
    (hs3 : s3 = t69 &&& 2097151#64) (hs14_5 : s14_5 = carry13 + s14_4) (hs13_5 : s13_5 = t193 + s13)
    (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21)
    (hs15_4 : s15_4 = s15_3 - t226) (ht69 : t69 = BitVec.extractLsb' 64 64 ((in1 ++ in0) <<< 1))
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5))
    (ht95 : t95 = in4 >>> 38) :
    carry3_1 =
      ((((((((((((in0 >>> 63) ||| (in1 <<< 1)) &&& 2097151#64) +
                          ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                    ((in7 >>> 35) * 136657#64)) -
                                  (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                                carry14) -
                              (carry15 <<< 21)) *
                            666643#64)) +
                        ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                              (carry14 <<< 21)) +
                            carry13) *
                          470296#64)) +
                      (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                  (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        654183#64)) -
                    (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                    ((in7 >>> 35) * 470296#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                              (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                            (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      997805#64)) +
                  carry2) -
                (carry3 <<< 21)) -
              ((0#64 + carry11_1) * 997805#64)) +
            carry2_1)).sshiftRight
        21 := by
  rw [hcarry3_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs3_8 hs3_7 ht377 ht340 hs3_5 ht363 hs3_4 hs3_3 ht291 hs3_2 ht277 hs12_7 hs3_1 ht264 hs13_6
    hs12_6 ht248 hs3 hs14_5 hs13_5 ht221 hs12_5 ht195 hs15_4 ht69 hs14_4 ht193 hs13 ht151 hs12
    hs15_3 ht226 hs14_3 ht200 ht192 ht93 ht150 ht118 ht90 hs15_2 hs14_2 ht133 hs23 hs15_1 ht129
    hs14_1 ht127 hs21 ht122 hs15 hs22 ht120 hs14 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 1 (by decide), Bnd.fshl_eq _ _ 4 (by decide),
    Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry4_1_eq
    {in1 in3 in4 in5 in6 in7 t72 s4 t90 s12 t93 s13 t95 s14 t100 s15 t102 s16 s22 s21 s23 t118 t120
      s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12 t192 t193
      s13_5 t195 s12_6 carry14 s15_3 t200 s14_4 carry16 t205 s16_2 carry11 s12_7 carry13 s14_5 t221
      s13_6 carry15 s16_3 t226 s15_4 t239 s4_1 t250 s4_2 t266 s4_3 t279 s4_4 t293 s4_5 carry4 t310
      s4_6 carry3 carry11_1 t364 carry3_1 t382 s4_8 s4_9 carry4_1 : BitVec 64}
    (hcarry4_1 : carry4_1 = s4_9.sshiftRight 21) (hs4_9 : s4_9 = s4_8 + carry3_1)
    (hs4_8 : s4_8 = t382 + carry3) (ht382 : t382 = s4_6 + t364) (hs4_6 : s4_6 = s4_5 - t310)
    (ht364 : t364 = carry11_1 * 136657#64) (hs4_5 : s4_5 = s4_4 + t293)
    (ht310 : t310 = carry4 <<< 21) (hs4_4 : s4_4 = s4_3 + t279) (ht293 : t293 = s12_7 * 136657#64)
    (hs4_3 : s4_3 = s4_2 + t266) (ht279 : t279 = s13_6 * 18446744073708553811#64)
    (hs12_7 : s12_7 = carry11 + s12_6) (hs4_2 : s4_2 = s4_1 + t250)
    (ht266 : t266 = s14_5 * 654183#64) (hs13_6 : s13_6 = s13_5 - t221)
    (hs12_6 : s12_6 = s12_5 - t195) (hs4_1 : s4_1 = t239 + s4) (ht250 : t250 = s15_4 * 470296#64)
    (hs14_5 : s14_5 = carry13 + s14_4) (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21)
    (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21) (ht239 : t239 = s16_3 * 666643#64)
    (hs4 : s4 = t72 &&& 2097151#64) (hs15_4 : s15_4 = s15_3 - t226) (hs14_4 : s14_4 = s14_3 - t200)
    (ht193 : t193 = t192 + carry12) (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118)
    (hs12 : s12 = t90 &&& 2097151#64) (hs16_3 : s16_3 = carry15 + s16_2) (ht72 : t72 = in1 >>> 20)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21) (hs15_1 : s15_1 = t122 + s15)
    (ht129 : t129 = s22 * 18446744073708867715#64) (hs14_1 : s14_1 = t120 + s14)
    (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38) :
    carry4_1 =
      ((((((((((((in1 >>> 20) &&& 2097151#64) +
                            ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                                  (carry16 <<< 21)) +
                                carry15) *
                              666643#64)) +
                          ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                    ((in7 >>> 35) * 136657#64)) -
                                  (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                                carry14) -
                              (carry15 <<< 21)) *
                            470296#64)) +
                        ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                              (carry14 <<< 21)) +
                            carry13) *
                          654183#64)) -
                      (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                  (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        997805#64)) +
                    (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                    ((in7 >>> 35) * 470296#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                              (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                            (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      136657#64)) -
                  (carry4 <<< 21)) +
                carry3) +
              ((0#64 + carry11_1) * 136657#64)) +
            carry3_1)).sshiftRight
        21 := by
  rw [hcarry4_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs4_9 hs4_8 ht382 hs4_6 ht364 hs4_5 ht310 hs4_4 ht293 hs4_3 ht279 hs12_7 hs4_2 ht266 hs13_6
    hs12_6 hs4_1 ht250 hs14_5 hs13_5 ht221 hs12_5 ht195 ht239 hs4 hs15_4 hs14_4 ht193 hs13 ht151
    hs12 hs16_3 ht72 hs15_3 ht226 hs14_3 ht200 ht192 ht93 ht150 ht118 ht90 hs16_2 hs15_2 hs14_2
    ht133 hs23 hs16_1 ht205 hs15_1 ht129 hs14_1 ht127 hs21 ht124 hs16 ht122 hs15 hs22 ht120 hs14
    ht102 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry5_1_eq
    {in1 in3 in4 in5 in6 in7 t74 s5 t90 s12 t93 s13 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23
      t118 t120 s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12
      t192 t193 s13_5 t195 s12_6 carry14 s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry11 s12_7
      carry13 s14_5 t221 s13_6 carry15 s16_3 t226 s15_4 t228 s5_1 t241 s5_2 t252 s5_3 t268 s5_4 t281
      s5_5 t295 s5_6 carry4 s5_7 carry5 t344 carry11_1 t365 carry4_1 t387 s5_9 s5_10 carry5_1 :
      BitVec 64}
    (hcarry5_1 : carry5_1 = s5_10.sshiftRight 21) (hs5_10 : s5_10 = s5_9 + carry4_1)
    (hs5_9 : s5_9 = t387 - t344) (ht387 : t387 = s5_7 + t365) (ht344 : t344 = carry5 <<< 21)
    (hs5_7 : s5_7 = s5_6 + carry4) (ht365 : t365 = carry11_1 * 18446744073708867715#64)
    (hs5_6 : s5_6 = s5_5 + t295) (hs5_5 : s5_5 = s5_4 + t281)
    (ht295 : t295 = s12_7 * 18446744073708867715#64) (hs5_4 : s5_4 = s5_3 + t268)
    (ht281 : t281 = s13_6 * 136657#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (hs5_3 : s5_3 = s5_2 + t252) (ht268 : t268 = s14_5 * 18446744073708553811#64)
    (hs13_6 : s13_6 = s13_5 - t221) (hs12_6 : s12_6 = s12_5 - t195) (hs5_2 : s5_2 = s5_1 + t241)
    (ht252 : t252 = s15_4 * 654183#64) (hs14_5 : s14_5 = carry13 + s14_4)
    (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12)
    (ht195 : t195 = carry12 <<< 21) (hs5_1 : s5_1 = t228 + s5) (ht241 : t241 = s16_3 * 470296#64)
    (hs15_4 : s15_4 = s15_3 - t226) (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht228 : t228 = s17_1 * 666643#64) (hs5 : s5 = t74 &&& 2097151#64)
    (hs16_3 : s16_3 = carry15 + s16_2) (hs15_3 : s15_3 = s15_2 + carry14)
    (ht226 : t226 = carry15 <<< 21) (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs17_1 : s17_1 = carry16 + s17) (ht74 : t74 = in1 >>> 41) (hs16_2 : s16_2 = s16_1 - t205)
    (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs17 : s17 = t104 &&& 2097151#64) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (ht124 : t124 = s23 * 18446744073708867715#64)
    (hs16 : s16 = t102 &&& 2097151#64) (ht122 : t122 = s23 * 136657#64)
    (hs15 : s15 = t100 &&& 2097151#64) (hs22 : s22 = in7 >>> 14 &&& 2097151#64)
    (ht120 : t120 = s23 * 18446744073708553811#64) (hs14 : s14 = t95 &&& 2097151#64)
    (ht102 : t102 = in5 >>> 16) (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5))
    (ht95 : t95 = in4 >>> 38) :
    carry5_1 =
      (((((((((((((in1 >>> 41) &&& 2097151#64) +
                              ((((in5 >>> 37) &&& 2097151#64) + carry16) * 666643#64)) +
                            ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                                  (carry16 <<< 21)) +
                                carry15) *
                              470296#64)) +
                          ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                    ((in7 >>> 35) * 136657#64)) -
                                  (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                                carry14) -
                              (carry15 <<< 21)) *
                            654183#64)) -
                        ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                              (carry14 <<< 21)) +
                            carry13) *
                          997805#64)) +
                      (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                  (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        136657#64)) -
                    (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                    ((in7 >>> 35) * 470296#64)) +
                                  (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                              (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                            (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      683901#64)) +
                  carry4) -
                (carry5 <<< 21)) -
              ((0#64 + carry11_1) * 683901#64)) +
            carry4_1)).sshiftRight
        21 := by
  rw [hcarry5_1]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs5_10 hs5_9 ht387 ht344 hs5_7 ht365 hs5_6 hs5_5 ht295 hs5_4 ht281 hs12_7 hs5_3 ht268 hs13_6
    hs12_6 hs5_2 ht252 hs14_5 hs13_5 ht221 hs12_5 ht195 hs5_1 ht241 hs15_4 hs14_4 ht193 hs13 ht151
    hs12 ht228 hs5 hs16_3 hs15_3 ht226 hs14_3 ht200 ht192 ht93 ht150 ht118 ht90 hs17_1 ht74 hs16_2
    hs15_2 hs14_2 ht133 hs23 hs17 hs16_1 ht205 hs15_1 ht129 hs14_1 ht127 hs21 ht104 ht124 hs16 ht122
    hs15 hs22 ht120 hs14 ht102 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry6_2_eq
    {in1 in2 in4 in5 in6 in7 t76 s6 t93 s13 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23 t120
      s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 s18 t154 s6_1 carry6 t171 s6_2
      carry12 t192 t193 s13_5 carry14 s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry13 s14_5 t221
      s13_6 carry15 s16_3 t226 s15_4 t230 s6_3 t243 s6_4 t254 s6_5 t270 s6_6 t283 s6_7 carry6_1 t320
      s6_8 carry5 s6_9 carry5_1 s6_10 carry6_2 : BitVec 64}
    (hcarry6_2 : carry6_2 = s6_10.sshiftRight 21) (hs6_10 : s6_10 = s6_9 + carry5_1)
    (hs6_9 : s6_9 = s6_8 + carry5) (hs6_8 : s6_8 = s6_7 - t320) (hs6_7 : s6_7 = s6_6 + t283)
    (ht320 : t320 = carry6_1 <<< 21) (hs6_6 : s6_6 = s6_5 + t270)
    (ht283 : t283 = s13_6 * 18446744073708867715#64) (hs6_5 : s6_5 = s6_4 + t254)
    (ht270 : t270 = s14_5 * 136657#64) (hs13_6 : s13_6 = s13_5 - t221) (hs6_4 : s6_4 = s6_3 + t243)
    (ht254 : t254 = s15_4 * 18446744073708553811#64) (hs14_5 : s14_5 = carry13 + s14_4)
    (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21) (hs6_3 : s6_3 = s6_2 + t230)
    (ht243 : t243 = s16_3 * 654183#64) (hs15_4 : s15_4 = s15_3 - t226)
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (hs6_2 : s6_2 = s6_1 - t171)
    (ht230 : t230 = s17_1 * 470296#64) (hs16_3 : s16_3 = carry15 + s16_2)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17) (hs6_1 : s6_1 = t154 + s6) (ht171 : t171 = carry6 <<< 21)
    (hs17_1 : s17_1 = carry16 + s17) (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129)
    (hs14_2 : s14_2 = s14_1 + t127) (ht133 : t133 = s21 * 18446744073708867715#64)
    (ht154 : t154 = s18 * 666643#64) (hs6 : s6 = t76 &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht76 : t76 = BitVec.extractLsb' 64 64 ((in2 ++ in1) <<< 2)) (ht104 : t104 = in5 >>> 37)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38) :
    carry6_2 =
      ((((((((((((((in1 >>> 62) ||| (in2 <<< 2)) &&& 2097151#64) +
                              ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 666643#64)) -
                            (carry6 <<< 21)) +
                          ((((in5 >>> 37) &&& 2097151#64) + carry16) * 470296#64)) +
                        ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                              (carry16 <<< 21)) +
                            carry15) *
                          654183#64)) -
                      ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                ((in7 >>> 35) * 136657#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                            carry14) -
                          (carry15 <<< 21)) *
                        997805#64)) +
                    ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                          (carry14 <<< 21)) +
                        carry13) *
                      136657#64)) -
                  (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                          (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    683901#64)) -
                (carry6_1 <<< 21)) +
              carry5) +
            carry5_1)).sshiftRight
        21 := by
  rw [hcarry6_2]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs6_10 hs6_9 hs6_8 hs6_7 ht320 hs6_6 ht283 hs6_5 ht270 hs13_6 hs6_4 ht254 hs14_5 hs13_5
    ht221 hs6_3 ht243 hs15_4 hs14_4 ht193 hs13 hs6_2 ht230 hs16_3 hs15_3 ht226 hs14_3 ht200 ht192
    ht93 hs6_1 ht171 hs17_1 hs16_2 hs15_2 hs14_2 ht133 ht154 hs6 hs17 hs16_1 ht205 hs15_1 ht129
    hs14_1 ht127 hs21 hs18 ht76 ht104 ht124 hs16 ht122 hs15 hs22 ht120 hs14 hs23 ht102 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 2 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry7_2_eq
    {in2 in4 in5 in6 in7 t79 s7 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23 t120 s14_1 t122 s15_1
      t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 s19 t142 s7_1 s18 t156 s7_2 carry6 s7_3 carry14
      s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry7 t209 carry13 s14_5 carry15 s16_3 t226 s15_4
      t232 t245 t256 t272 carry6_1 t314 s7_5 s7_6 s7_7 s7_8 s7_9 carry7_1 t348 s7_10 carry6_2 s7_11
      carry7_2 : BitVec 64}
    (hcarry7_2 : carry7_2 = s7_11.sshiftRight 21) (hs7_11 : s7_11 = carry6_2 + s7_10)
    (hs7_10 : s7_10 = s7_9 - t348) (hs7_9 : s7_9 = s7_8 + carry6_1) (ht348 : t348 = carry7_1 <<< 21)
    (hs7_8 : s7_8 = s7_7 + t272) (hs7_7 : s7_7 = s7_6 + t256)
    (ht272 : t272 = s14_5 * 18446744073708867715#64) (hs7_6 : s7_6 = s7_5 + t245)
    (ht256 : t256 = s15_4 * 136657#64) (hs14_5 : s14_5 = carry13 + s14_4)
    (hs7_5 : s7_5 = t314 - t209) (ht245 : t245 = s16_3 * 18446744073708553811#64)
    (hs15_4 : s15_4 = s15_3 - t226) (hs14_4 : s14_4 = s14_3 - t200) (ht314 : t314 = t232 + s7_3)
    (ht209 : t209 = carry7 <<< 21) (hs16_3 : s16_3 = carry15 + s16_2)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht232 : t232 = s17_1 * 654183#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs17_1 : s17_1 = carry16 + s17)
    (hs7_2 : s7_2 = s7_1 + t156) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (hs7_1 : s7_1 = t142 + s7) (ht156 : t156 = s18 * 470296#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht104 : t104 = in5 >>> 37) (ht142 : t142 = s19 * 666643#64)
    (hs7 : s7 = t79 &&& 2097151#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (ht79 : t79 = in2 >>> 19) :
    carry7_2 =
      ((((((((((((((in2 >>> 19) &&& 2097151#64) + (((in6 >>> 15) &&& 2097151#64) * 666643#64)) +
                              ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 470296#64)) +
                            carry6) -
                          (carry7 <<< 21)) +
                        ((((in5 >>> 37) &&& 2097151#64) + carry16) * 654183#64)) -
                      ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                            (carry16 <<< 21)) +
                          carry15) *
                        997805#64)) +
                    ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                              ((in7 >>> 35) * 136657#64)) -
                            (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                          carry14) -
                        (carry15 <<< 21)) *
                      136657#64)) -
                  ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                        (carry14 <<< 21)) +
                      carry13) *
                    683901#64)) +
                carry6_1) -
              (carry7_1 <<< 21)) +
            carry6_2)).sshiftRight
        21 := by
  rw [hcarry7_2]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs7_11 hs7_10 hs7_9 ht348 hs7_8 hs7_7 ht272 hs7_6 ht256 hs14_5 hs7_5 ht245 hs15_4 hs14_4
    ht314 ht209 hs16_3 hs15_3 ht226 hs14_3 ht200 ht232 hs7_3 hs16_2 hs15_2 hs14_2 ht133 hs17_1 hs7_2
    hs16_1 ht205 hs15_1 ht129 hs14_1 ht127 hs21 hs17 hs7_1 ht156 ht124 hs16 ht122 hs15 hs22 ht120
    hs14 ht104 ht142 hs7 hs18 hs23 ht102 ht100 ht95 hs19 ht79
  simp only [Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 6 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry8_2_eq
    {in2 in4 in5 in6 in7 t81 s8 t100 s15 t102 s16 t104 s17 s22 s23 t122 s15_1 t124 s16_1 t129 s15_2
      s20 t136 s8_1 s19 t144 s8_2 s18 t158 s8_3 carry8 t180 s8_4 carry14 s15_3 carry16 s17_1 t205
      s16_2 carry7 carry15 s16_3 t226 s15_4 t233 t246 t257 t258 s8_6 s8_7 s8_8 carry8_1 t328 s8_9
      carry7_1 s8_10 carry7_2 s8_11 carry8_2 : BitVec 64}
    (hcarry8_2 : carry8_2 = s8_11.sshiftRight 21) (hs8_11 : s8_11 = s8_10 + carry7_2)
    (hs8_10 : s8_10 = s8_9 + carry7_1) (hs8_9 : s8_9 = s8_8 - t328) (hs8_8 : s8_8 = s8_7 + t257)
    (ht328 : t328 = carry8_1 <<< 21) (hs8_7 : s8_7 = s8_6 + t246)
    (ht257 : t257 = s15_4 * 18446744073708867715#64) (hs8_6 : s8_6 = t258 + carry7)
    (ht246 : t246 = s16_3 * 136657#64) (hs15_4 : s15_4 = s15_3 - t226) (ht258 : t258 = s8_4 + t233)
    (hs16_3 : s16_3 = carry15 + s16_2) (hs15_3 : s15_3 = s15_2 + carry14)
    (ht226 : t226 = carry15 <<< 21) (hs8_4 : s8_4 = s8_3 - t180)
    (ht233 : t233 = s17_1 * 18446744073708553811#64) (hs16_2 : s16_2 = s16_1 - t205)
    (hs15_2 : s15_2 = s15_1 + t129) (hs8_3 : s8_3 = s8_2 + t158) (ht180 : t180 = carry8 <<< 21)
    (hs17_1 : s17_1 = carry16 + s17) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs8_2 : s8_2 = s8_1 + t144) (ht158 : t158 = s18 * 654183#64) (hs17 : s17 = t104 &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (hs8_1 : s8_1 = t136 + s8)
    (ht144 : t144 = s19 * 470296#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht136 : t136 = s20 * 666643#64)
    (hs8 : s8 = t81 &&& 2097151#64) (hs19 : s19 = in6 >>> 15 &&& 2097151#64)
    (hs20 : s20 = in6 >>> 36 &&& 2097151#64) (ht81 : t81 = in2 >>> 40) :
    carry8_2 =
      ((((((((((((((in2 >>> 40) &&& 2097151#64) + (((in6 >>> 36) &&& 2097151#64) * 666643#64)) +
                              (((in6 >>> 15) &&& 2097151#64) * 470296#64)) +
                            ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 654183#64)) -
                          (carry8 <<< 21)) +
                        carry7) -
                      ((((in5 >>> 37) &&& 2097151#64) + carry16) * 997805#64)) +
                    ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                          (carry16 <<< 21)) +
                        carry15) *
                      136657#64)) -
                  ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                            ((in7 >>> 35) * 136657#64)) -
                          (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                        carry14) -
                      (carry15 <<< 21)) *
                    683901#64)) -
                (carry8_1 <<< 21)) +
              carry7_1) +
            carry7_2)).sshiftRight
        21 := by
  rw [hcarry8_2]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs8_11 hs8_10 hs8_9 hs8_8 ht328 hs8_7 ht257 hs8_6 ht246 hs15_4 ht258 hs16_3 hs15_3 ht226
    hs8_4 ht233 hs16_2 hs15_2 hs8_3 ht180 hs17_1 hs16_1 ht205 hs15_1 ht129 hs8_2 ht158 hs17 ht124
    hs16 ht122 hs15 hs22 hs8_1 ht144 hs18 ht104 hs23 ht102 ht100 ht136 hs8 hs19 hs20 ht81
  simp only [Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry9_2_eq
    {in2 in3 in5 in6 in7 t83 s9 t102 s16 t104 s17 s21 s23 t124 s16_1 t131 s20 t138 s19 t146 s18 t160
      carry8 t175 t176 t177 s9_4 s9_5 carry16 s17_1 t205 s16_2 carry9 t212 carry15 s16_3 t234 t247
      carry8_1 t324 s9_7 s9_8 s9_9 carry9_1 t353 s9_10 carry8_2 s9_11 carry9_2 : BitVec 64}
    (hcarry9_2 : carry9_2 = s9_11.sshiftRight 21) (hs9_11 : s9_11 = carry8_2 + s9_10)
    (hs9_10 : s9_10 = s9_9 - t353) (hs9_9 : s9_9 = s9_8 + carry8_1) (ht353 : t353 = carry9_1 <<< 21)
    (hs9_8 : s9_8 = s9_7 + t247) (hs9_7 : s9_7 = t324 - t212)
    (ht247 : t247 = s16_3 * 18446744073708867715#64) (ht324 : t324 = s9_5 + t234)
    (ht212 : t212 = carry9 <<< 21) (hs16_3 : s16_3 = carry15 + s16_2) (hs9_5 : s9_5 = s9_4 + carry8)
    (ht234 : t234 = s17_1 * 136657#64) (hs16_2 : s16_2 = s16_1 - t205) (hs9_4 : s9_4 = t177 + t131)
    (hs17_1 : s17_1 = carry16 + s17) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (ht177 : t177 = t176 + t160) (ht131 : t131 = s21 * 666643#64) (hs17 : s17 = t104 &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht176 : t176 = t175 + t146) (ht160 : t160 = s18 * 18446744073708553811#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht175 : t175 = t138 + s9) (ht146 : t146 = s19 * 654183#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht138 : t138 = s20 * 470296#64) (hs9 : s9 = t83 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht83 : t83 = BitVec.extractLsb' 64 64 ((in3 ++ in2) <<< 3)) :
    carry9_2 =
      (((((((((((((((in2 >>> 61) ||| (in3 <<< 3)) &&& 2097151#64) +
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 666643#64)) +
                              (((in6 >>> 36) &&& 2097151#64) * 470296#64)) +
                            (((in6 >>> 15) &&& 2097151#64) * 654183#64)) -
                          ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 997805#64)) +
                        carry8) -
                      (carry9 <<< 21)) +
                    ((((in5 >>> 37) &&& 2097151#64) + carry16) * 136657#64)) -
                  ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                        (carry16 <<< 21)) +
                      carry15) *
                    683901#64)) +
                carry8_1) -
              (carry9_1 <<< 21)) +
            carry8_2)).sshiftRight
        21 := by
  rw [hcarry9_2]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs9_11 hs9_10 hs9_9 ht353 hs9_8 hs9_7 ht247 ht324 ht212 hs16_3 hs9_5 ht234 hs16_2 hs9_4
    hs17_1 hs16_1 ht205 ht177 ht131 hs17 ht124 hs16 ht176 ht160 hs21 ht104 hs23 ht102 ht175 ht146
    hs18 ht138 hs9 hs19 hs20 ht83
  simp only [Bnd.fshl_eq _ _ 3 (by decide), Bnd.fshl_eq _ _ 6 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry10_2_eq
    {in3 in5 in6 in7 t86 s10 t104 s17 s22 s21 t126 t132 s20 t139 s19 t147 s18 t161 t162 t163 t164
      t165 s10_5 carry10 t189 carry16 s17_1 carry9 t235 t236 t237 s10_8 carry10_1 t333 s10_9
      carry9_1 s10_10 carry9_2 s10_11 carry10_2 : BitVec 64}
    (hcarry10_2 : carry10_2 = s10_11.sshiftRight 21) (hs10_11 : s10_11 = s10_10 + carry9_2)
    (hs10_10 : s10_10 = s10_9 + carry9_1) (hs10_9 : s10_9 = s10_8 - t333)
    (hs10_8 : s10_8 = t237 + carry9) (ht333 : t333 = carry10_1 <<< 21) (ht237 : t237 = t236 - t189)
    (ht236 : t236 = s10_5 + t235) (ht189 : t189 = carry10 <<< 21) (hs10_5 : s10_5 = t165 + t132)
    (ht235 : t235 = s17_1 * 18446744073708867715#64) (ht165 : t165 = t164 + t126)
    (ht132 : t132 = s21 * 470296#64) (hs17_1 : s17_1 = carry16 + s17) (ht164 : t164 = t163 + t161)
    (ht126 : t126 = s22 * 666643#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (ht163 : t163 = t162 + t147) (ht161 : t161 = s18 * 136657#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht104 : t104 = in5 >>> 37) (ht162 : t162 = t139 + s10)
    (ht147 : t147 = s19 * 18446744073708553811#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht139 : t139 = s20 * 654183#64) (hs10 : s10 = t86 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht86 : t86 = in3 >>> 18) :
    carry10_2 =
      ((((((((((((((in3 >>> 18) &&& 2097151#64) + (((in7 >>> 14) &&& 2097151#64) * 666643#64)) +
                              ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 470296#64)) +
                            (((in6 >>> 36) &&& 2097151#64) * 654183#64)) -
                          (((in6 >>> 15) &&& 2097151#64) * 997805#64)) +
                        ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 136657#64)) -
                      (carry10 <<< 21)) +
                    carry9) -
                  ((((in5 >>> 37) &&& 2097151#64) + carry16) * 683901#64)) -
                (carry10_1 <<< 21)) +
              carry9_1) +
            carry9_2)).sshiftRight
        21 := by
  rw [hcarry10_2]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs10_11 hs10_10 hs10_9 hs10_8 ht333 ht237 ht236 ht189 hs10_5 ht235 ht165 ht132 hs17_1 ht164
    ht126 hs21 hs17 ht163 ht161 hs22 ht104 ht162 ht147 hs18 ht139 hs10 hs19 hs20 ht86
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.carry11_2_eq
    {in3 in5 in6 in7 t88 s11 s23 t117 s20 t140 carry10 t184 t185 t186 t187 s11_7 carry11 t216 s11_8
      carry10_1 s11_9 carry11_1 t357 s11_10 carry10_2 s11_11 carry11_2 : BitVec 64}
    (hcarry11_2 : carry11_2 = s11_11.sshiftRight 21) (hs11_11 : s11_11 = carry10_2 + s11_10)
    (hs11_10 : s11_10 = s11_9 - t357) (hs11_9 : s11_9 = carry10_1 + s11_8)
    (ht357 : t357 = carry11_1 <<< 21) (hs11_8 : s11_8 = s11_7 - t216) (hs11_7 : s11_7 = t187 + s11)
    (ht216 : t216 = carry11 <<< 21) (ht187 : t187 = t185 + t186) (hs11 : s11 = t88 &&& 2097151#64)
    (ht185 : t185 = t184 + t117) (ht186 : t186 = t140 + carry10) (ht88 : t88 = in3 >>> 39)
    (ht184 :
      t184 =
        (in6 >>> 15 &&& 2097151#64) * 136657#64 +
          (BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 470296#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 654183#64)
    (ht117 : t117 = s23 * 666643#64) (ht140 : t140 = s20 * 18446744073708553811#64)
    (hs23 : s23 = in7 >>> 35) (hs20 : s20 = in6 >>> 36 &&& 2097151#64) :
    carry11_2 =
      ((((((((((((((in3 >>> 39) &&& 2097151#64) + ((in7 >>> 35) * 666643#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 470296#64)) +
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 654183#64)) -
                          (((in6 >>> 36) &&& 2097151#64) * 997805#64)) +
                        (((in6 >>> 15) &&& 2097151#64) * 136657#64)) -
                      ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 683901#64)) +
                    carry10) -
                  (carry11 <<< 21)) +
                carry10_1) -
              (carry11_1 <<< 21)) +
            carry10_2)).sshiftRight
        21 := by
  rw [hcarry11_2]
  refine congrArg (BitVec.sshiftRight · 21) ?_
  subst hs11_11 hs11_10 hs11_9 ht357 hs11_8 hs11_7 ht216 ht187 hs11 ht185 ht186 ht88 ht184 ht117
    ht140 hs23 hs20
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s11_12_eq
    {in3 in5 in6 in7 t88 s11 s23 t117 s20 t140 carry10 t184 t185 t186 t187 s11_7 carry11 t216 s11_8
      carry10_1 s11_9 carry11_1 t357 s11_10 carry10_2 s11_11 carry11_2 s11_12 : BitVec 64}
    (hs11_12 : s11_12 = s11_11 - carry11_2 <<< 21) (hs11_11 : s11_11 = carry10_2 + s11_10)
    (hs11_10 : s11_10 = s11_9 - t357) (hs11_9 : s11_9 = carry10_1 + s11_8)
    (ht357 : t357 = carry11_1 <<< 21) (hs11_8 : s11_8 = s11_7 - t216) (hs11_7 : s11_7 = t187 + s11)
    (ht216 : t216 = carry11 <<< 21) (ht187 : t187 = t185 + t186) (hs11 : s11 = t88 &&& 2097151#64)
    (ht185 : t185 = t184 + t117) (ht186 : t186 = t140 + carry10) (ht88 : t88 = in3 >>> 39)
    (ht184 :
      t184 =
        (in6 >>> 15 &&& 2097151#64) * 136657#64 +
          (BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 470296#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 654183#64)
    (ht117 : t117 = s23 * 666643#64) (ht140 : t140 = s20 * 18446744073708553811#64)
    (hs23 : s23 = in7 >>> 35) (hs20 : s20 = in6 >>> 36 &&& 2097151#64) :
    s11_12 =
      ((((((((((((((in3 >>> 39) &&& 2097151#64) + ((in7 >>> 35) * 666643#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 470296#64)) +
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 654183#64)) -
                        (((in6 >>> 36) &&& 2097151#64) * 997805#64)) +
                      (((in6 >>> 15) &&& 2097151#64) * 136657#64)) -
                    ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 683901#64)) +
                  carry10) -
                (carry11 <<< 21)) +
              carry10_1) -
            (carry11_1 <<< 21)) +
          carry10_2) -
        (carry11_2 <<< 21)) := by
  subst hs11_12 hs11_11 hs11_10 hs11_9 ht357 hs11_8 hs11_7 ht216 ht187 hs11 ht185 ht186 ht88 ht184
    ht117 ht140 hs23 hs20
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s0_5_eq
    {in0 in3 in4 in6 in7 s0 t90 s12 s23 t118 t150 t151 s12_5 carry12 t195 s12_6 carry11 s12_7 t285
      s0_1 carry0 t300 s0_2 carry11_1 t359 s0_3 carry0_1 s0_4 carry11_2 t411 s0_5 : BitVec 64}
    (hs0_5 : s0_5 = t411 + s0_4) (ht411 : t411 = carry11_2 * 666643#64)
    (hs0_4 : s0_4 = s0_3 - carry0_1 <<< 21) (hs0_3 : s0_3 = s0_2 + t359)
    (hs0_2 : s0_2 = s0_1 - t300) (ht359 : t359 = carry11_1 * 666643#64) (hs0_1 : s0_1 = t285 + s0)
    (ht300 : t300 = carry0 <<< 21) (ht285 : t285 = s12_7 * 666643#64)
    (hs0 : s0 = in0 &&& 2097151#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (hs12_6 : s12_6 = s12_5 - t195) (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21)
    (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs23 : s23 = in7 >>> 35) :
    s0_5 =
      ((((((in0 &&& 2097151#64) +
                (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                ((in7 >>> 35) * 470296#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                          (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                        (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  666643#64)) -
              (carry0 <<< 21)) +
            ((0#64 + carry11_1) * 666643#64)) -
          (carry0_1 <<< 21)) +
        ((0#64 + carry11_2) * 666643#64)) := by
  subst hs0_5 ht411 hs0_4 hs0_3 hs0_2 ht359 hs0_1 ht300 ht285 hs0 hs12_7 hs12_6 hs12_5 ht195 ht151
    hs12 ht150 ht118 ht90 hs23
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s1_9_eq
    {in0 in3 in4 in6 in7 t64 s1 t90 s12 t93 s13 s23 t118 t150 t151 s12_5 carry12 t192 t193 s13_5
      t195 s12_6 carry11 s12_7 carry13 t221 s13_6 t273 s1_1 t287 s1_2 carry0 s1_3 carry1 t337
      carry11_1 t361 carry0_1 t367 s1_5 s1_6 carry1_1 s1_7 carry11_2 t412 s1_8 carry0_2 s1_9 :
      BitVec 64}
    (hs1_9 : s1_9 = s1_8 + carry0_2) (hs1_8 : s1_8 = t412 + s1_7)
    (ht412 : t412 = carry11_2 * 470296#64) (hs1_7 : s1_7 = s1_6 - carry1_1 <<< 21)
    (hs1_6 : s1_6 = s1_5 + carry0_1) (hs1_5 : s1_5 = t367 - t337) (ht367 : t367 = t361 + s1_3)
    (ht337 : t337 = carry1 <<< 21) (ht361 : t361 = carry11_1 * 470296#64)
    (hs1_3 : s1_3 = s1_2 + carry0) (hs1_2 : s1_2 = s1_1 + t287) (hs1_1 : s1_1 = t273 + s1)
    (ht287 : t287 = s12_7 * 470296#64) (ht273 : t273 = s13_6 * 666643#64)
    (hs1 : s1 = t64 &&& 2097151#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (hs13_6 : s13_6 = s13_5 - t221) (ht64 : t64 = in0 >>> 21) (hs12_6 : s12_6 = s12_5 - t195)
    (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12)
    (ht195 : t195 = carry12 <<< 21) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs23 : s23 = in7 >>> 35) :
    s1_9 =
      (((((((((((in0 >>> 21) &&& 2097151#64) +
                        (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                    (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                                (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          666643#64)) +
                      (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                      ((in7 >>> 35) * 470296#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                                (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        470296#64)) +
                    carry0) -
                  (carry1 <<< 21)) +
                ((0#64 + carry11_1) * 470296#64)) +
              carry0_1) -
            (carry1_1 <<< 21)) +
          ((0#64 + carry11_2) * 470296#64)) +
        carry0_2) := by
  subst hs1_9 hs1_8 ht412 hs1_7 hs1_6 hs1_5 ht367 ht337 ht361 hs1_3 hs1_2 hs1_1 ht287 ht273 hs1
    hs12_7 hs13_6 ht64 hs12_6 hs13_5 ht221 hs12_5 ht195 ht193 hs13 ht151 hs12 ht192 ht93 ht150 ht118
    ht90 hs23
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s2_10_eq
    {in0 in3 in4 in6 in7 t66 s2 t90 s12 t93 s13 t95 s14 s22 s21 s23 t118 t120 s14_1 t127 s14_2 t133
      s14_3 t150 t151 s12_5 carry12 t192 t193 s13_5 t195 s12_6 carry14 t200 s14_4 carry11 s12_7
      carry13 s14_5 t221 s13_6 t262 s2_1 t275 s2_2 t289 s2_3 carry2 t305 s2_4 carry1 carry11_1 t362
      carry1_1 t372 s2_6 s2_7 carry2_1 s2_8 carry11_2 t414 s2_9 carry1_2 s2_10 : BitVec 64}
    (hs2_10 : s2_10 = s2_9 + carry1_2) (hs2_9 : s2_9 = t414 + s2_8)
    (ht414 : t414 = carry11_2 * 654183#64) (hs2_8 : s2_8 = s2_7 - carry2_1 <<< 21)
    (hs2_7 : s2_7 = s2_6 + carry1_1) (hs2_6 : s2_6 = t372 + carry1) (ht372 : t372 = s2_4 + t362)
    (hs2_4 : s2_4 = s2_3 - t305) (ht362 : t362 = carry11_1 * 654183#64) (hs2_3 : s2_3 = s2_2 + t289)
    (ht305 : t305 = carry2 <<< 21) (hs2_2 : s2_2 = s2_1 + t275) (ht289 : t289 = s12_7 * 654183#64)
    (hs2_1 : s2_1 = t262 + s2) (ht275 : t275 = s13_6 * 470296#64) (hs12_7 : s12_7 = carry11 + s12_6)
    (ht262 : t262 = s14_5 * 666643#64) (hs2 : s2 = t66 &&& 2097151#64)
    (hs13_6 : s13_6 = s13_5 - t221) (hs12_6 : s12_6 = s12_5 - t195)
    (hs14_5 : s14_5 = carry13 + s14_4) (ht66 : t66 = in0 >>> 42) (hs13_5 : s13_5 = t193 + s13)
    (ht221 : t221 = carry13 <<< 21) (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21)
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs14_2 : s14_2 = s14_1 + t127) (ht133 : t133 = s21 * 18446744073708867715#64)
    (hs23 : s23 = in7 >>> 35) (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht120 : t120 = s23 * 18446744073708553811#64) (hs14 : s14 = t95 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht95 : t95 = in4 >>> 38) :
    s2_10 =
      ((((((((((((in0 >>> 42) &&& 2097151#64) +
                          ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                                (carry14 <<< 21)) +
                              carry13) *
                            666643#64)) +
                        (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                    (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                                (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          470296#64)) +
                      (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                      ((in7 >>> 35) * 470296#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                                (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        654183#64)) -
                    (carry2 <<< 21)) +
                  carry1) +
                ((0#64 + carry11_1) * 654183#64)) +
              carry1_1) -
            (carry2_1 <<< 21)) +
          ((0#64 + carry11_2) * 654183#64)) +
        carry1_2) := by
  subst hs2_10 hs2_9 ht414 hs2_8 hs2_7 hs2_6 ht372 hs2_4 ht362 hs2_3 ht305 hs2_2 ht289 hs2_1 ht275
    hs12_7 ht262 hs2 hs13_6 hs12_6 hs14_5 ht66 hs13_5 ht221 hs12_5 ht195 hs14_4 ht193 hs13 ht151
    hs12 hs14_3 ht200 ht192 ht93 ht150 ht118 ht90 hs14_2 ht133 hs23 hs14_1 ht127 hs21 ht120 hs14
    hs22 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s3_11_eq
    {in0 in1 in3 in4 in5 in6 in7 t69 s3 t90 s12 t93 s13 t95 s14 t100 s15 s22 s21 s23 t118 t120 s14_1
      t122 s15_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12 t192 t193 s13_5 t195 s12_6
      carry14 s15_3 t200 s14_4 carry11 s12_7 carry13 s14_5 t221 s13_6 carry15 t226 s15_4 t248 s3_1
      t264 s3_2 t277 s3_3 t291 s3_4 carry2 s3_5 carry3 t340 carry11_1 t363 carry2_1 t377 s3_7 s3_8
      carry3_1 s3_9 carry11_2 t416 s3_10 carry2_2 s3_11 : BitVec 64}
    (hs3_11 : s3_11 = s3_10 + carry2_2) (hs3_10 : s3_10 = t416 + s3_9)
    (ht416 : t416 = carry11_2 * 18446744073708553811#64) (hs3_9 : s3_9 = s3_8 - carry3_1 <<< 21)
    (hs3_8 : s3_8 = s3_7 + carry2_1) (hs3_7 : s3_7 = t377 - t340) (ht377 : t377 = s3_5 + t363)
    (ht340 : t340 = carry3 <<< 21) (hs3_5 : s3_5 = s3_4 + carry2)
    (ht363 : t363 = carry11_1 * 18446744073708553811#64) (hs3_4 : s3_4 = s3_3 + t291)
    (hs3_3 : s3_3 = s3_2 + t277) (ht291 : t291 = s12_7 * 18446744073708553811#64)
    (hs3_2 : s3_2 = s3_1 + t264) (ht277 : t277 = s13_6 * 654183#64)
    (hs12_7 : s12_7 = carry11 + s12_6) (hs3_1 : s3_1 = t248 + s3) (ht264 : t264 = s14_5 * 470296#64)
    (hs13_6 : s13_6 = s13_5 - t221) (hs12_6 : s12_6 = s12_5 - t195)
    (ht248 : t248 = s15_4 * 666643#64) (hs3 : s3 = t69 &&& 2097151#64)
    (hs14_5 : s14_5 = carry13 + s14_4) (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21)
    (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21) (hs15_4 : s15_4 = s15_3 - t226)
    (ht69 : t69 = BitVec.extractLsb' 64 64 ((in1 ++ in0) <<< 1)) (hs14_4 : s14_4 = s14_3 - t200)
    (ht193 : t193 = t192 + carry12) (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118)
    (hs12 : s12 = t90 &&& 2097151#64) (hs15_3 : s15_3 = s15_2 + carry14)
    (ht226 : t226 = carry15 <<< 21) (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5))
    (ht95 : t95 = in4 >>> 38) :
    s3_11 =
      ((((((((((((((in0 >>> 63) ||| (in1 <<< 1)) &&& 2097151#64) +
                            ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                      ((in7 >>> 35) * 136657#64)) -
                                    (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                                  carry14) -
                                (carry15 <<< 21)) *
                              666643#64)) +
                          ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                                (carry14 <<< 21)) +
                              carry13) *
                            470296#64)) +
                        (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                    (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                                (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          654183#64)) -
                      (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                      ((in7 >>> 35) * 470296#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                                (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        997805#64)) +
                    carry2) -
                  (carry3 <<< 21)) -
                ((0#64 + carry11_1) * 997805#64)) +
              carry2_1) -
            (carry3_1 <<< 21)) -
          ((0#64 + carry11_2) * 997805#64)) +
        carry2_2) := by
  subst hs3_11 hs3_10 ht416 hs3_9 hs3_8 hs3_7 ht377 ht340 hs3_5 ht363 hs3_4 hs3_3 ht291 hs3_2 ht277
    hs12_7 hs3_1 ht264 hs13_6 hs12_6 ht248 hs3 hs14_5 hs13_5 ht221 hs12_5 ht195 hs15_4 ht69 hs14_4
    ht193 hs13 ht151 hs12 hs15_3 ht226 hs14_3 ht200 ht192 ht93 ht150 ht118 ht90 hs15_2 hs14_2 ht133
    hs23 hs15_1 ht129 hs14_1 ht127 hs21 ht122 hs15 hs22 ht120 hs14 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 1 (by decide), Bnd.fshl_eq _ _ 4 (by decide),
    Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s4_12_eq
    {in1 in3 in4 in5 in6 in7 t72 s4 t90 s12 t93 s13 t95 s14 t100 s15 t102 s16 s22 s21 s23 t118 t120
      s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12 t192 t193
      s13_5 t195 s12_6 carry14 s15_3 t200 s14_4 carry16 t205 s16_2 carry11 s12_7 carry13 s14_5 t221
      s13_6 carry15 s16_3 t226 s15_4 t239 s4_1 t250 s4_2 t266 s4_3 t279 s4_4 t293 s4_5 carry4 t310
      s4_6 carry3 carry11_1 t364 carry3_1 t382 s4_8 s4_9 carry4_1 s4_10 carry11_2 t418 s4_11
      carry3_2 s4_12 : BitVec 64}
    (hs4_12 : s4_12 = s4_11 + carry3_2) (hs4_11 : s4_11 = t418 + s4_10)
    (ht418 : t418 = carry11_2 * 136657#64) (hs4_10 : s4_10 = s4_9 - carry4_1 <<< 21)
    (hs4_9 : s4_9 = s4_8 + carry3_1) (hs4_8 : s4_8 = t382 + carry3) (ht382 : t382 = s4_6 + t364)
    (hs4_6 : s4_6 = s4_5 - t310) (ht364 : t364 = carry11_1 * 136657#64) (hs4_5 : s4_5 = s4_4 + t293)
    (ht310 : t310 = carry4 <<< 21) (hs4_4 : s4_4 = s4_3 + t279) (ht293 : t293 = s12_7 * 136657#64)
    (hs4_3 : s4_3 = s4_2 + t266) (ht279 : t279 = s13_6 * 18446744073708553811#64)
    (hs12_7 : s12_7 = carry11 + s12_6) (hs4_2 : s4_2 = s4_1 + t250)
    (ht266 : t266 = s14_5 * 654183#64) (hs13_6 : s13_6 = s13_5 - t221)
    (hs12_6 : s12_6 = s12_5 - t195) (hs4_1 : s4_1 = t239 + s4) (ht250 : t250 = s15_4 * 470296#64)
    (hs14_5 : s14_5 = carry13 + s14_4) (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21)
    (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21) (ht239 : t239 = s16_3 * 666643#64)
    (hs4 : s4 = t72 &&& 2097151#64) (hs15_4 : s15_4 = s15_3 - t226) (hs14_4 : s14_4 = s14_3 - t200)
    (ht193 : t193 = t192 + carry12) (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118)
    (hs12 : s12 = t90 &&& 2097151#64) (hs16_3 : s16_3 = carry15 + s16_2) (ht72 : t72 = in1 >>> 20)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21) (hs15_1 : s15_1 = t122 + s15)
    (ht129 : t129 = s22 * 18446744073708867715#64) (hs14_1 : s14_1 = t120 + s14)
    (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38) :
    s4_12 =
      ((((((((((((((in1 >>> 20) &&& 2097151#64) +
                              ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                                    (carry16 <<< 21)) +
                                  carry15) *
                                666643#64)) +
                            ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                      ((in7 >>> 35) * 136657#64)) -
                                    (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                                  carry14) -
                                (carry15 <<< 21)) *
                              470296#64)) +
                          ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                                (carry14 <<< 21)) +
                              carry13) *
                            654183#64)) -
                        (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                    (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                                (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          997805#64)) +
                      (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                      ((in7 >>> 35) * 470296#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                                (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        136657#64)) -
                    (carry4 <<< 21)) +
                  carry3) +
                ((0#64 + carry11_1) * 136657#64)) +
              carry3_1) -
            (carry4_1 <<< 21)) +
          ((0#64 + carry11_2) * 136657#64)) +
        carry3_2) := by
  subst hs4_12 hs4_11 ht418 hs4_10 hs4_9 hs4_8 ht382 hs4_6 ht364 hs4_5 ht310 hs4_4 ht293 hs4_3 ht279
    hs12_7 hs4_2 ht266 hs13_6 hs12_6 hs4_1 ht250 hs14_5 hs13_5 ht221 hs12_5 ht195 ht239 hs4 hs15_4
    hs14_4 ht193 hs13 ht151 hs12 hs16_3 ht72 hs15_3 ht226 hs14_3 ht200 ht192 ht93 ht150 ht118 ht90
    hs16_2 hs15_2 hs14_2 ht133 hs23 hs16_1 ht205 hs15_1 ht129 hs14_1 ht127 hs21 ht124 hs16 ht122
    hs15 hs22 ht120 hs14 ht102 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s5_13_eq
    {in1 in3 in4 in5 in6 in7 t74 s5 t90 s12 t93 s13 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23
      t118 t120 s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 t150 t151 s12_5 carry12
      t192 t193 s13_5 t195 s12_6 carry14 s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry11 s12_7
      carry13 s14_5 t221 s13_6 carry15 s16_3 t226 s15_4 t228 s5_1 t241 s5_2 t252 s5_3 t268 s5_4 t281
      s5_5 t295 s5_6 carry4 s5_7 carry5 t344 carry11_1 t365 carry4_1 t387 s5_9 s5_10 carry5_1 s5_11
      carry11_2 t420 s5_12 carry4_2 s5_13 : BitVec 64}
    (hs5_13 : s5_13 = s5_12 + carry4_2) (hs5_12 : s5_12 = t420 + s5_11)
    (ht420 : t420 = carry11_2 * 18446744073708867715#64) (hs5_11 : s5_11 = s5_10 - carry5_1 <<< 21)
    (hs5_10 : s5_10 = s5_9 + carry4_1) (hs5_9 : s5_9 = t387 - t344) (ht387 : t387 = s5_7 + t365)
    (ht344 : t344 = carry5 <<< 21) (hs5_7 : s5_7 = s5_6 + carry4)
    (ht365 : t365 = carry11_1 * 18446744073708867715#64) (hs5_6 : s5_6 = s5_5 + t295)
    (hs5_5 : s5_5 = s5_4 + t281) (ht295 : t295 = s12_7 * 18446744073708867715#64)
    (hs5_4 : s5_4 = s5_3 + t268) (ht281 : t281 = s13_6 * 136657#64)
    (hs12_7 : s12_7 = carry11 + s12_6) (hs5_3 : s5_3 = s5_2 + t252)
    (ht268 : t268 = s14_5 * 18446744073708553811#64) (hs13_6 : s13_6 = s13_5 - t221)
    (hs12_6 : s12_6 = s12_5 - t195) (hs5_2 : s5_2 = s5_1 + t241) (ht252 : t252 = s15_4 * 654183#64)
    (hs14_5 : s14_5 = carry13 + s14_4) (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21)
    (hs12_5 : s12_5 = t151 + s12) (ht195 : t195 = carry12 <<< 21) (hs5_1 : s5_1 = t228 + s5)
    (ht241 : t241 = s16_3 * 470296#64) (hs15_4 : s15_4 = s15_3 - t226)
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (ht151 : t151 = t150 + t118) (hs12 : s12 = t90 &&& 2097151#64)
    (ht228 : t228 = s17_1 * 666643#64) (hs5 : s5 = t74 &&& 2097151#64)
    (hs16_3 : s16_3 = carry15 + s16_2) (hs15_3 : s15_3 = s15_2 + carry14)
    (ht226 : t226 = carry15 <<< 21) (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17)
    (ht150 :
      t150 =
        (in6 >>> 36 &&& 2097151#64) * 136657#64 +
          (in6 >>> 15 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 654183#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 18446744073708553811#64)
    (ht118 : t118 = s23 * 470296#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4))
    (hs17_1 : s17_1 = carry16 + s17) (ht74 : t74 = in1 >>> 41) (hs16_2 : s16_2 = s16_1 - t205)
    (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs23 : s23 = in7 >>> 35)
    (hs17 : s17 = t104 &&& 2097151#64) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (ht124 : t124 = s23 * 18446744073708867715#64)
    (hs16 : s16 = t102 &&& 2097151#64) (ht122 : t122 = s23 * 136657#64)
    (hs15 : s15 = t100 &&& 2097151#64) (hs22 : s22 = in7 >>> 14 &&& 2097151#64)
    (ht120 : t120 = s23 * 18446744073708553811#64) (hs14 : s14 = t95 &&& 2097151#64)
    (ht102 : t102 = in5 >>> 16) (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5))
    (ht95 : t95 = in4 >>> 38) :
    s5_13 =
      (((((((((((((((in1 >>> 41) &&& 2097151#64) +
                                ((((in5 >>> 37) &&& 2097151#64) + carry16) * 666643#64)) +
                              ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                                    (carry16 <<< 21)) +
                                  carry15) *
                                470296#64)) +
                            ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                      ((in7 >>> 35) * 136657#64)) -
                                    (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                                  carry14) -
                                (carry15 <<< 21)) *
                              654183#64)) -
                          ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                                (carry14 <<< 21)) +
                              carry13) *
                            997805#64)) +
                        (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                                    (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                                (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          136657#64)) -
                      (((((((((((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64) +
                                      ((in7 >>> 35) * 470296#64)) +
                                    (((in7 >>> 14) &&& 2097151#64) * 654183#64)) -
                                  ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 997805#64)) +
                                (((in6 >>> 36) &&& 2097151#64) * 136657#64)) -
                              (((in6 >>> 15) &&& 2097151#64) * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        683901#64)) +
                    carry4) -
                  (carry5 <<< 21)) -
                ((0#64 + carry11_1) * 683901#64)) +
              carry4_1) -
            (carry5_1 <<< 21)) -
          ((0#64 + carry11_2) * 683901#64)) +
        carry4_2) := by
  subst hs5_13 hs5_12 ht420 hs5_11 hs5_10 hs5_9 ht387 ht344 hs5_7 ht365 hs5_6 hs5_5 ht295 hs5_4
    ht281 hs12_7 hs5_3 ht268 hs13_6 hs12_6 hs5_2 ht252 hs14_5 hs13_5 ht221 hs12_5 ht195 hs5_1 ht241
    hs15_4 hs14_4 ht193 hs13 ht151 hs12 ht228 hs5 hs16_3 hs15_3 ht226 hs14_3 ht200 ht192 ht93 ht150
    ht118 ht90 hs17_1 ht74 hs16_2 hs15_2 hs14_2 ht133 hs23 hs17 hs16_1 ht205 hs15_1 ht129 hs14_1
    ht127 hs21 ht104 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht102 ht100 ht95
  simp only [Bnd.fshl_eq _ _ 4 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s6_12_eq
    {in1 in2 in4 in5 in6 in7 t76 s6 t93 s13 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23 t120
      s14_1 t122 s15_1 t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 s18 t154 s6_1 carry6 t171 s6_2
      carry12 t192 t193 s13_5 carry14 s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry13 s14_5 t221
      s13_6 carry15 s16_3 t226 s15_4 t230 s6_3 t243 s6_4 t254 s6_5 t270 s6_6 t283 s6_7 carry6_1 t320
      s6_8 carry5 s6_9 carry5_1 s6_10 carry6_2 s6_11 carry5_2 s6_12 : BitVec 64}
    (hs6_12 : s6_12 = carry5_2 + s6_11) (hs6_11 : s6_11 = s6_10 - carry6_2 <<< 21)
    (hs6_10 : s6_10 = s6_9 + carry5_1) (hs6_9 : s6_9 = s6_8 + carry5) (hs6_8 : s6_8 = s6_7 - t320)
    (hs6_7 : s6_7 = s6_6 + t283) (ht320 : t320 = carry6_1 <<< 21) (hs6_6 : s6_6 = s6_5 + t270)
    (ht283 : t283 = s13_6 * 18446744073708867715#64) (hs6_5 : s6_5 = s6_4 + t254)
    (ht270 : t270 = s14_5 * 136657#64) (hs13_6 : s13_6 = s13_5 - t221) (hs6_4 : s6_4 = s6_3 + t243)
    (ht254 : t254 = s15_4 * 18446744073708553811#64) (hs14_5 : s14_5 = carry13 + s14_4)
    (hs13_5 : s13_5 = t193 + s13) (ht221 : t221 = carry13 <<< 21) (hs6_3 : s6_3 = s6_2 + t230)
    (ht243 : t243 = s16_3 * 654183#64) (hs15_4 : s15_4 = s15_3 - t226)
    (hs14_4 : s14_4 = s14_3 - t200) (ht193 : t193 = t192 + carry12)
    (hs13 : s13 = t93 &&& 2097151#64) (hs6_2 : s6_2 = s6_1 - t171)
    (ht230 : t230 = s17_1 * 470296#64) (hs16_3 : s16_3 = carry15 + s16_2)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21)
    (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht192 :
      t192 =
        in7 >>> 35 * 654183#64 + (in6 >>> 36 &&& 2097151#64) * 18446744073708867715#64 +
          (in7 >>> 14 &&& 2097151#64) * 18446744073708553811#64 +
          (BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) * 136657#64)
    (ht93 : t93 = in4 >>> 17) (hs6_1 : s6_1 = t154 + s6) (ht171 : t171 = carry6 <<< 21)
    (hs17_1 : s17_1 = carry16 + s17) (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129)
    (hs14_2 : s14_2 = s14_1 + t127) (ht133 : t133 = s21 * 18446744073708867715#64)
    (ht154 : t154 = s18 * 666643#64) (hs6 : s6 = t76 &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht76 : t76 = BitVec.extractLsb' 64 64 ((in2 ++ in1) <<< 2)) (ht104 : t104 = in5 >>> 37)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38) :
    s6_12 =
      (((((((((((((((in1 >>> 62) ||| (in2 <<< 2)) &&& 2097151#64) +
                              ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 666643#64)) -
                            (carry6 <<< 21)) +
                          ((((in5 >>> 37) &&& 2097151#64) + carry16) * 470296#64)) +
                        ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                              (carry16 <<< 21)) +
                            carry15) *
                          654183#64)) -
                      ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                                ((in7 >>> 35) * 136657#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                            carry14) -
                          (carry15 <<< 21)) *
                        997805#64)) +
                    ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                              (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                          (carry14 <<< 21)) +
                        carry13) *
                      136657#64)) -
                  (((((((((in4 >>> 17) &&& 2097151#64) + ((in7 >>> 35) * 654183#64)) -
                              (((in7 >>> 14) &&& 2097151#64) * 997805#64)) +
                            ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 136657#64)) -
                          (((in6 >>> 36) &&& 2097151#64) * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    683901#64)) -
                (carry6_1 <<< 21)) +
              carry5) +
            carry5_1) -
          (carry6_2 <<< 21)) +
        carry5_2) := by
  subst hs6_12 hs6_11 hs6_10 hs6_9 hs6_8 hs6_7 ht320 hs6_6 ht283 hs6_5 ht270 hs13_6 hs6_4 ht254
    hs14_5 hs13_5 ht221 hs6_3 ht243 hs15_4 hs14_4 ht193 hs13 hs6_2 ht230 hs16_3 hs15_3 ht226 hs14_3
    ht200 ht192 ht93 hs6_1 ht171 hs17_1 hs16_2 hs15_2 hs14_2 ht133 ht154 hs6 hs17 hs16_1 ht205
    hs15_1 ht129 hs14_1 ht127 hs21 hs18 ht76 ht104 ht124 hs16 ht122 hs15 hs22 ht120 hs14 hs23 ht102
    ht100 ht95
  simp only [Bnd.fshl_eq _ _ 2 (by decide), Bnd.fshl_eq _ _ 5 (by decide),
    Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s7_13_eq
    {in2 in4 in5 in6 in7 t79 s7 t95 s14 t100 s15 t102 s16 t104 s17 s22 s21 s23 t120 s14_1 t122 s15_1
      t124 s16_1 t127 s14_2 t129 s15_2 t133 s14_3 s19 t142 s7_1 s18 t156 s7_2 carry6 s7_3 carry14
      s15_3 t200 s14_4 carry16 s17_1 t205 s16_2 carry7 t209 carry13 s14_5 carry15 s16_3 t226 s15_4
      t232 t245 t256 t272 carry6_1 t314 s7_5 s7_6 s7_7 s7_8 s7_9 carry7_1 t348 s7_10 carry6_2 s7_11
      carry7_2 s7_12 carry6_3 s7_13 : BitVec 64}
    (hs7_13 : s7_13 = carry6_3 + s7_12) (hs7_12 : s7_12 = s7_11 - carry7_2 <<< 21)
    (hs7_11 : s7_11 = carry6_2 + s7_10) (hs7_10 : s7_10 = s7_9 - t348)
    (hs7_9 : s7_9 = s7_8 + carry6_1) (ht348 : t348 = carry7_1 <<< 21) (hs7_8 : s7_8 = s7_7 + t272)
    (hs7_7 : s7_7 = s7_6 + t256) (ht272 : t272 = s14_5 * 18446744073708867715#64)
    (hs7_6 : s7_6 = s7_5 + t245) (ht256 : t256 = s15_4 * 136657#64)
    (hs14_5 : s14_5 = carry13 + s14_4) (hs7_5 : s7_5 = t314 - t209)
    (ht245 : t245 = s16_3 * 18446744073708553811#64) (hs15_4 : s15_4 = s15_3 - t226)
    (hs14_4 : s14_4 = s14_3 - t200) (ht314 : t314 = t232 + s7_3) (ht209 : t209 = carry7 <<< 21)
    (hs16_3 : s16_3 = carry15 + s16_2) (hs15_3 : s15_3 = s15_2 + carry14)
    (ht226 : t226 = carry15 <<< 21) (hs14_3 : s14_3 = s14_2 + t133) (ht200 : t200 = carry14 <<< 21)
    (ht232 : t232 = s17_1 * 654183#64) (hs7_3 : s7_3 = s7_2 + carry6)
    (hs16_2 : s16_2 = s16_1 - t205) (hs15_2 : s15_2 = s15_1 + t129) (hs14_2 : s14_2 = s14_1 + t127)
    (ht133 : t133 = s21 * 18446744073708867715#64) (hs17_1 : s17_1 = carry16 + s17)
    (hs7_2 : s7_2 = s7_1 + t156) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs14_1 : s14_1 = t120 + s14) (ht127 : t127 = s22 * 136657#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (hs7_1 : s7_1 = t142 + s7) (ht156 : t156 = s18 * 470296#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht120 : t120 = s23 * 18446744073708553811#64)
    (hs14 : s14 = t95 &&& 2097151#64) (ht104 : t104 = in5 >>> 37) (ht142 : t142 = s19 * 666643#64)
    (hs7 : s7 = t79 &&& 2097151#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht95 : t95 = in4 >>> 38)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (ht79 : t79 = in2 >>> 19) :
    s7_13 =
      (((((((((((((((in2 >>> 19) &&& 2097151#64) + (((in6 >>> 15) &&& 2097151#64) * 666643#64)) +
                              ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 470296#64)) +
                            carry6) -
                          (carry7 <<< 21)) +
                        ((((in5 >>> 37) &&& 2097151#64) + carry16) * 654183#64)) -
                      ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                            (carry16 <<< 21)) +
                          carry15) *
                        997805#64)) +
                    ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                              ((in7 >>> 35) * 136657#64)) -
                            (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                          carry14) -
                        (carry15 <<< 21)) *
                      136657#64)) -
                  ((((((((in4 >>> 38) &&& 2097151#64) - ((in7 >>> 35) * 997805#64)) +
                            (((in7 >>> 14) &&& 2097151#64) * 136657#64)) -
                          ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 683901#64)) -
                        (carry14 <<< 21)) +
                      carry13) *
                    683901#64)) +
                carry6_1) -
              (carry7_1 <<< 21)) +
            carry6_2) -
          (carry7_2 <<< 21)) +
        carry6_3) := by
  subst hs7_13 hs7_12 hs7_11 hs7_10 hs7_9 ht348 hs7_8 hs7_7 ht272 hs7_6 ht256 hs14_5 hs7_5 ht245
    hs15_4 hs14_4 ht314 ht209 hs16_3 hs15_3 ht226 hs14_3 ht200 ht232 hs7_3 hs16_2 hs15_2 hs14_2
    ht133 hs17_1 hs7_2 hs16_1 ht205 hs15_1 ht129 hs14_1 ht127 hs21 hs17 hs7_1 ht156 ht124 hs16 ht122
    hs15 hs22 ht120 hs14 ht104 ht142 hs7 hs18 hs23 ht102 ht100 ht95 hs19 ht79
  simp only [Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 6 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s8_13_eq
    {in2 in4 in5 in6 in7 t81 s8 t100 s15 t102 s16 t104 s17 s22 s23 t122 s15_1 t124 s16_1 t129 s15_2
      s20 t136 s8_1 s19 t144 s8_2 s18 t158 s8_3 carry8 t180 s8_4 carry14 s15_3 carry16 s17_1 t205
      s16_2 carry7 carry15 s16_3 t226 s15_4 t233 t246 t257 t258 s8_6 s8_7 s8_8 carry8_1 t328 s8_9
      carry7_1 s8_10 carry7_2 s8_11 carry8_2 s8_12 carry7_3 s8_13 : BitVec 64}
    (hs8_13 : s8_13 = carry7_3 + s8_12) (hs8_12 : s8_12 = s8_11 - carry8_2 <<< 21)
    (hs8_11 : s8_11 = s8_10 + carry7_2) (hs8_10 : s8_10 = s8_9 + carry7_1)
    (hs8_9 : s8_9 = s8_8 - t328) (hs8_8 : s8_8 = s8_7 + t257) (ht328 : t328 = carry8_1 <<< 21)
    (hs8_7 : s8_7 = s8_6 + t246) (ht257 : t257 = s15_4 * 18446744073708867715#64)
    (hs8_6 : s8_6 = t258 + carry7) (ht246 : t246 = s16_3 * 136657#64)
    (hs15_4 : s15_4 = s15_3 - t226) (ht258 : t258 = s8_4 + t233) (hs16_3 : s16_3 = carry15 + s16_2)
    (hs15_3 : s15_3 = s15_2 + carry14) (ht226 : t226 = carry15 <<< 21) (hs8_4 : s8_4 = s8_3 - t180)
    (ht233 : t233 = s17_1 * 18446744073708553811#64) (hs16_2 : s16_2 = s16_1 - t205)
    (hs15_2 : s15_2 = s15_1 + t129) (hs8_3 : s8_3 = s8_2 + t158) (ht180 : t180 = carry8 <<< 21)
    (hs17_1 : s17_1 = carry16 + s17) (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21)
    (hs15_1 : s15_1 = t122 + s15) (ht129 : t129 = s22 * 18446744073708867715#64)
    (hs8_2 : s8_2 = s8_1 + t144) (ht158 : t158 = s18 * 654183#64) (hs17 : s17 = t104 &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht122 : t122 = s23 * 136657#64) (hs15 : s15 = t100 &&& 2097151#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (hs8_1 : s8_1 = t136 + s8)
    (ht144 : t144 = s19 * 470296#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht100 : t100 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5)) (ht136 : t136 = s20 * 666643#64)
    (hs8 : s8 = t81 &&& 2097151#64) (hs19 : s19 = in6 >>> 15 &&& 2097151#64)
    (hs20 : s20 = in6 >>> 36 &&& 2097151#64) (ht81 : t81 = in2 >>> 40) :
    s8_13 =
      (((((((((((((((in2 >>> 40) &&& 2097151#64) + (((in6 >>> 36) &&& 2097151#64) * 666643#64)) +
                              (((in6 >>> 15) &&& 2097151#64) * 470296#64)) +
                            ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 654183#64)) -
                          (carry8 <<< 21)) +
                        carry7) -
                      ((((in5 >>> 37) &&& 2097151#64) + carry16) * 997805#64)) +
                    ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                          (carry16 <<< 21)) +
                        carry15) *
                      136657#64)) -
                  ((((((((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64) +
                            ((in7 >>> 35) * 136657#64)) -
                          (((in7 >>> 14) &&& 2097151#64) * 683901#64)) +
                        carry14) -
                      (carry15 <<< 21)) *
                    683901#64)) -
                (carry8_1 <<< 21)) +
              carry7_1) +
            carry7_2) -
          (carry8_2 <<< 21)) +
        carry7_3) := by
  subst hs8_13 hs8_12 hs8_11 hs8_10 hs8_9 hs8_8 ht328 hs8_7 ht257 hs8_6 ht246 hs15_4 ht258 hs16_3
    hs15_3 ht226 hs8_4 ht233 hs16_2 hs15_2 hs8_3 ht180 hs17_1 hs16_1 ht205 hs15_1 ht129 hs8_2 ht158
    hs17 ht124 hs16 ht122 hs15 hs22 hs8_1 ht144 hs18 ht104 hs23 ht102 ht100 ht136 hs8 hs19 hs20 ht81
  simp only [Bnd.fshl_eq _ _ 5 (by decide), Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s9_13_eq
    {in2 in3 in5 in6 in7 t83 s9 t102 s16 t104 s17 s21 s23 t124 s16_1 t131 s20 t138 s19 t146 s18 t160
      carry8 t175 t176 t177 s9_4 s9_5 carry16 s17_1 t205 s16_2 carry9 t212 carry15 s16_3 t234 t247
      carry8_1 t324 s9_7 s9_8 s9_9 carry9_1 t353 s9_10 carry8_2 s9_11 carry9_2 s9_12 carry8_3
      s9_13 : BitVec 64}
    (hs9_13 : s9_13 = carry8_3 + s9_12) (hs9_12 : s9_12 = s9_11 - carry9_2 <<< 21)
    (hs9_11 : s9_11 = carry8_2 + s9_10) (hs9_10 : s9_10 = s9_9 - t353)
    (hs9_9 : s9_9 = s9_8 + carry8_1) (ht353 : t353 = carry9_1 <<< 21) (hs9_8 : s9_8 = s9_7 + t247)
    (hs9_7 : s9_7 = t324 - t212) (ht247 : t247 = s16_3 * 18446744073708867715#64)
    (ht324 : t324 = s9_5 + t234) (ht212 : t212 = carry9 <<< 21) (hs16_3 : s16_3 = carry15 + s16_2)
    (hs9_5 : s9_5 = s9_4 + carry8) (ht234 : t234 = s17_1 * 136657#64)
    (hs16_2 : s16_2 = s16_1 - t205) (hs9_4 : s9_4 = t177 + t131) (hs17_1 : s17_1 = carry16 + s17)
    (hs16_1 : s16_1 = t124 + s16) (ht205 : t205 = carry16 <<< 21) (ht177 : t177 = t176 + t160)
    (ht131 : t131 = s21 * 666643#64) (hs17 : s17 = t104 &&& 2097151#64)
    (ht124 : t124 = s23 * 18446744073708867715#64) (hs16 : s16 = t102 &&& 2097151#64)
    (ht176 : t176 = t175 + t146) (ht160 : t160 = s18 * 18446744073708553811#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (ht104 : t104 = in5 >>> 37) (hs23 : s23 = in7 >>> 35) (ht102 : t102 = in5 >>> 16)
    (ht175 : t175 = t138 + s9) (ht146 : t146 = s19 * 654183#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht138 : t138 = s20 * 470296#64) (hs9 : s9 = t83 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht83 : t83 = BitVec.extractLsb' 64 64 ((in3 ++ in2) <<< 3)) :
    s9_13 =
      ((((((((((((((((in2 >>> 61) ||| (in3 <<< 3)) &&& 2097151#64) +
                                ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 666643#64)) +
                              (((in6 >>> 36) &&& 2097151#64) * 470296#64)) +
                            (((in6 >>> 15) &&& 2097151#64) * 654183#64)) -
                          ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 997805#64)) +
                        carry8) -
                      (carry9 <<< 21)) +
                    ((((in5 >>> 37) &&& 2097151#64) + carry16) * 136657#64)) -
                  ((((((in5 >>> 16) &&& 2097151#64) - ((in7 >>> 35) * 683901#64)) -
                        (carry16 <<< 21)) +
                      carry15) *
                    683901#64)) +
                carry8_1) -
              (carry9_1 <<< 21)) +
            carry8_2) -
          (carry9_2 <<< 21)) +
        carry8_3) := by
  subst hs9_13 hs9_12 hs9_11 hs9_10 hs9_9 ht353 hs9_8 hs9_7 ht247 ht324 ht212 hs16_3 hs9_5 ht234
    hs16_2 hs9_4 hs17_1 hs16_1 ht205 ht177 ht131 hs17 ht124 hs16 ht176 ht160 hs21 ht104 hs23 ht102
    ht175 ht146 hs18 ht138 hs9 hs19 hs20 ht83
  simp only [Bnd.fshl_eq _ _ 3 (by decide), Bnd.fshl_eq _ _ 6 (by decide),
    Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

theorem fd_curve25519_scalar_reduce.s10_13_eq
    {in3 in5 in6 in7 t86 s10 t104 s17 s22 s21 t126 t132 s20 t139 s19 t147 s18 t161 t162 t163 t164
      t165 s10_5 carry10 t189 carry16 s17_1 carry9 t235 t236 t237 s10_8 carry10_1 t333 s10_9
      carry9_1 s10_10 carry9_2 s10_11 carry10_2 s10_12 carry9_3 s10_13 : BitVec 64}
    (hs10_13 : s10_13 = carry9_3 + s10_12) (hs10_12 : s10_12 = s10_11 - carry10_2 <<< 21)
    (hs10_11 : s10_11 = s10_10 + carry9_2) (hs10_10 : s10_10 = s10_9 + carry9_1)
    (hs10_9 : s10_9 = s10_8 - t333) (hs10_8 : s10_8 = t237 + carry9)
    (ht333 : t333 = carry10_1 <<< 21) (ht237 : t237 = t236 - t189) (ht236 : t236 = s10_5 + t235)
    (ht189 : t189 = carry10 <<< 21) (hs10_5 : s10_5 = t165 + t132)
    (ht235 : t235 = s17_1 * 18446744073708867715#64) (ht165 : t165 = t164 + t126)
    (ht132 : t132 = s21 * 470296#64) (hs17_1 : s17_1 = carry16 + s17) (ht164 : t164 = t163 + t161)
    (ht126 : t126 = s22 * 666643#64)
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64)
    (hs17 : s17 = t104 &&& 2097151#64) (ht163 : t163 = t162 + t147) (ht161 : t161 = s18 * 136657#64)
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) (ht104 : t104 = in5 >>> 37) (ht162 : t162 = t139 + s10)
    (ht147 : t147 = s19 * 18446744073708553811#64)
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64)
    (ht139 : t139 = s20 * 654183#64) (hs10 : s10 = t86 &&& 2097151#64)
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) (hs20 : s20 = in6 >>> 36 &&& 2097151#64)
    (ht86 : t86 = in3 >>> 18) :
    s10_13 =
      (((((((((((((((in3 >>> 18) &&& 2097151#64) + (((in7 >>> 14) &&& 2097151#64) * 666643#64)) +
                              ((((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64) * 470296#64)) +
                            (((in6 >>> 36) &&& 2097151#64) * 654183#64)) -
                          (((in6 >>> 15) &&& 2097151#64) * 997805#64)) +
                        ((((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64) * 136657#64)) -
                      (carry10 <<< 21)) +
                    carry9) -
                  ((((in5 >>> 37) &&& 2097151#64) + carry16) * 683901#64)) -
                (carry10_1 <<< 21)) +
              carry9_1) +
            carry9_2) -
          (carry10_2 <<< 21)) +
        carry9_3) := by
  subst hs10_13 hs10_12 hs10_11 hs10_10 hs10_9 hs10_8 ht333 ht237 ht236 ht189 hs10_5 ht235 ht165
    ht132 hs17_1 ht164 ht126 hs21 hs17 ht163 ht161 hs22 ht104 ht162 ht147 hs18 ht139 hs10 hs19 hs20
    ht86
  simp only [Bnd.fshl_eq _ _ 6 (by decide), Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]
  grind

/-- The stored lanes are the spec's `out3 ++ (out2 ++ (out1 ++ out0))`. -/
theorem fd_curve25519_scalar_reduce.pack_eq
    {s11_12 s0_5 carry0_2 s1_9 carry1_2 s2_10 carry2_2 s3_11 carry3_2 s4_12 carry4_2 s5_13 carry5_2
      s6_12 carry6_3 s7_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 t443 t444 : BitVec 64}
    (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21)
    (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21)
    (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21)
    (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21)
    (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21)
    (ht443 : t443 = s10_13 >>> 21) (ht444 : t444 = t443 + s11_12) :
    BitVec.packLanes
        #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
            (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64) |||
            s3_11 <<< 63,
          s5_13 <<< 41 &&& 4611683819404132352#64 |||
            (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64) |||
            s6_12 <<< 62,
          s8_13 <<< 40 &&& 2305841909702066176#64 |||
            (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64) |||
            s9_13 <<< 61,
          s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64 ||| t444 <<< 39] =
      (((((s9_13 - (carry9_3 <<< 21)) >>> 3) |||
            ((s10_13 - ((s10_13).sshiftRight 21 <<< 21)) <<< 18)) |||
          ((s11_12 + (s10_13).sshiftRight 21) <<< 39)) ++
        ((((((s6_12 - (carry6_3 <<< 21)) >>> 2) ||| ((s7_13 - (carry7_3 <<< 21)) <<< 19)) |||
              ((s8_13 - (carry8_3 <<< 21)) <<< 40)) |||
            ((s9_13 - (carry9_3 <<< 21)) <<< 61)) ++
          ((((((s3_11 - (carry3_2 <<< 21)) >>> 1) ||| ((s4_12 - (carry4_2 <<< 21)) <<< 20)) |||
                ((s5_13 - (carry5_2 <<< 21)) <<< 41)) |||
              ((s6_12 - (carry6_3 <<< 21)) <<< 62)) ++
            ((((s0_5 - (carry0_2 <<< 21)) ||| ((s1_9 - (carry1_2 <<< 21)) <<< 21)) |||
                ((s2_10 - (carry2_2 <<< 21)) <<< 42)) |||
              ((s3_11 - (carry3_2 <<< 21)) <<< 63))))) := by
  rw [packLanes_four]
  subst hcarry0_2 hcarry1_2 hcarry2_2 hcarry3_2 hcarry4_2 hcarry5_2 hcarry6_3 hcarry7_3 hcarry8_3
    hcarry9_3 ht443 ht444
  bv_decide

/-- `reduce` stores `spec` of the 64 bytes at `inp` as the 32 bytes at `out`, and returns `out`. The
loads all come before the store, so `out` may alias `inp`. -/
public theorem fd_curve25519_scalar_reduce.call_eq (out inp : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : Room s.mem out (8 * 32)) (hin : Fits s.mem inp (8 * 64))
    (hin_off : ¬inp.offset.uaddOverflow 64#64) :
    fd_curve25519_scalar_reduce.call (fd_curve25519_scalar_reduce.args (.value out) (.value inp))
        s =
      .value
        (.cons (.value out) .nil,
          { s with
            mem :=
              s.mem.storeAt out
                (Ref.fd_curve25519_scalar_reduce.spec (s.mem.readAt inp 512)) }) := by
  func_init
  block_init
  step_pattern using fd_curve25519_scalar_reduce.run0
  step_pattern using fd_curve25519_scalar_reduce.run62
  step_pattern using fd_curve25519_scalar_reduce.run97
  step_pattern using fd_curve25519_scalar_reduce.run99
  step_pattern using fd_curve25519_scalar_reduce.run130
  step_pattern using fd_curve25519_scalar_reduce.run160
  step_pattern using fd_curve25519_scalar_reduce.run190
  step_pattern using fd_curve25519_scalar_reduce.run220
  step_pattern using fd_curve25519_scalar_reduce.run250
  step_pattern using fd_curve25519_scalar_reduce.run280
  step_pattern using fd_curve25519_scalar_reduce.run310
  step_pattern using fd_curve25519_scalar_reduce.run340
  step_pattern using fd_curve25519_scalar_reduce.run370
  step_pattern using fd_curve25519_scalar_reduce.run400
  step_pattern using fd_curve25519_scalar_reduce.run422
  step_pattern using fd_curve25519_scalar_reduce.run445
  finish_block
  subst hS
  have ht171' : t171 = carry6 <<< 21 := by
    rw [ht171, Bnd.and_mask43 _ _ _ hbt168 (by decide), ← hcarry6]
  have ht180' : t180 = carry8 <<< 21 := by
    rw [ht180, Bnd.and_mask63 _ _ _ hbt173 (by decide), ← hcarry8]
  have ht189' : t189 = carry10 <<< 21 := by rw [ht189, Bnd.and_neg_shift, ← hcarry10]
  have ht195' : t195 = carry12 <<< 21 := by rw [ht195, Bnd.and_neg_shift, ← hcarry12]
  have ht200' : t200 = carry14 <<< 21 := by rw [ht200, Bnd.and_neg_shift, ← hcarry14]
  have ht205' : t205 = carry16 <<< 21 := by rw [ht205, Bnd.and_neg_shift, ← hcarry16]
  have ht209' : t209 = carry7 <<< 21 := by
    rw [ht209, Bnd.and_mask63 _ _ _ hbt207 (by decide), ← hcarry7]
  have ht212' : t212 = carry9 <<< 21 := by rw [ht212, Bnd.and_neg_shift, ← hcarry9]
  have ht216' : t216 = carry11 <<< 21 := by rw [ht216, Bnd.and_neg_shift, ← hcarry11]
  have ht221' : t221 = carry13 <<< 21 := by rw [ht221, Bnd.and_neg_shift, ← hcarry13]
  have ht226' : t226 = carry15 <<< 21 := by rw [ht226, Bnd.and_neg_shift, ← hcarry15]
  have ht300' : t300 = carry0 <<< 21 := by rw [ht300, Bnd.and_neg_shift, ← hcarry0]
  have ht305' : t305 = carry2 <<< 21 := by rw [ht305, Bnd.and_neg_shift, ← hcarry2]
  have ht310' : t310 = carry4 <<< 21 := by rw [ht310, Bnd.and_neg_shift, ← hcarry4]
  have ht320' : t320 = carry6_1 <<< 21 := by rw [ht320, Bnd.and_neg_shift, ← hcarry6_1]
  have ht328' : t328 = carry8_1 <<< 21 := by rw [ht328, Bnd.and_neg_shift, ← hcarry8_1]
  have ht333' : t333 = carry10_1 <<< 21 := by rw [ht333, Bnd.and_neg_shift, ← hcarry10_1]
  have ht337' : t337 = carry1 <<< 21 := by rw [ht337, Bnd.and_neg_shift, ← hcarry1]
  have ht340' : t340 = carry3 <<< 21 := by rw [ht340, Bnd.and_neg_shift, ← hcarry3]
  have ht344' : t344 = carry5 <<< 21 := by rw [ht344, Bnd.and_neg_shift, ← hcarry5]
  have ht348' : t348 = carry7_1 <<< 21 := by rw [ht348, Bnd.and_neg_shift, ← hcarry7_1]
  have ht353' : t353 = carry9_1 <<< 21 := by rw [ht353, Bnd.and_neg_shift, ← hcarry9_1]
  have ht357' : t357 = carry11_1 <<< 21 := by rw [ht357, Bnd.and_neg_shift, ← hcarry11_1]
  have hs0_4' : s0_4 = s0_3 - carry0_1 <<< 21 := by rw [hs0_4, Bnd.and_mask_sub, ← hcarry0_1]
  have hs1_7' : s1_7 = s1_6 - carry1_1 <<< 21 := by rw [hs1_7, Bnd.and_mask_sub, ← hcarry1_1]
  have hs2_8' : s2_8 = s2_7 - carry2_1 <<< 21 := by rw [hs2_8, Bnd.and_mask_sub, ← hcarry2_1]
  have hs3_9' : s3_9 = s3_8 - carry3_1 <<< 21 := by rw [hs3_9, Bnd.and_mask_sub, ← hcarry3_1]
  have hs4_10' : s4_10 = s4_9 - carry4_1 <<< 21 := by rw [hs4_10, Bnd.and_mask_sub, ← hcarry4_1]
  have hs5_11' : s5_11 = s5_10 - carry5_1 <<< 21 := by rw [hs5_11, Bnd.and_mask_sub, ← hcarry5_1]
  have hs6_11' : s6_11 = s6_10 - carry6_2 <<< 21 := by rw [hs6_11, Bnd.and_mask_sub, ← hcarry6_2]
  have hs7_12' : s7_12 = s7_11 - carry7_2 <<< 21 := by rw [hs7_12, Bnd.and_mask_sub, ← hcarry7_2]
  have hs8_12' : s8_12 = s8_11 - carry8_2 <<< 21 := by rw [hs8_12, Bnd.and_mask_sub, ← hcarry8_2]
  have hs9_12' : s9_12 = s9_11 - carry9_2 <<< 21 := by rw [hs9_12, Bnd.and_mask_sub, ← hcarry9_2]
  have hs10_12' : s10_12 = s10_11 - carry10_2 <<< 21 := by
    rw [hs10_12, Bnd.and_mask_sub, ← hcarry10_2]
  have hs11_12' : s11_12 = s11_11 - carry11_2 <<< 21 := by
    rw [hs11_12, Bnd.and_mask_sub, ← hcarry11_2]
  rw [ht471,
    fd_curve25519_scalar_reduce.pack_eq hcarry0_2 hcarry1_2 hcarry2_2 hcarry3_2 hcarry4_2 hcarry5_2
      hcarry6_3 hcarry7_3 hcarry8_3 hcarry9_3 ht443 ht444]
  have hccarry6 := fd_curve25519_scalar_reduce.carry6_eq hcarry6 ht168 hs6_1 ht154 hs6 hs18 ht76
  have hccarry8 :=
    fd_curve25519_scalar_reduce.carry8_eq hcarry8 ht173 hs8_3 hs8_2 ht158 hs8_1 ht144 hs18 ht136 hs8
      hs19 hs20 ht81
  have hccarry10 :=
    fd_curve25519_scalar_reduce.carry10_eq hcarry10 ht182 hs10_5 ht165 ht132 ht164 ht126 hs21 ht163
      ht161 hs22 ht162 ht147 hs18 ht139 hs10 hs19 hs20 ht86
  have hccarry12 :=
    fd_curve25519_scalar_reduce.carry12_eq hcarry12 ht190 hs12_5 ht151 hs12 ht150 ht118 ht90 hs23
  have hccarry14 :=
    fd_curve25519_scalar_reduce.carry14_eq hcarry14 ht197 hs14_3 hs14_2 ht133 hs14_1 ht127 hs21
      ht120 hs14 hs22 hs23 ht95
  have hccarry16 :=
    fd_curve25519_scalar_reduce.carry16_eq hcarry16 ht202 hs16_1 ht124 hs16 hs23 ht102
  have hccarry7 :=
    fd_curve25519_scalar_reduce.carry7_eq hcarry7 ht207 hs7_3 hs7_2 hs7_1 ht156 ht142 hs7 hs18 hs19
      ht79
  have hccarry9 :=
    fd_curve25519_scalar_reduce.carry9_eq hcarry9 ht210 hs9_5 hs9_4 ht177 ht131 ht176 ht160 hs21
      ht175 ht146 hs18 ht138 hs9 hs19 hs20 ht83
  have hccarry11 :=
    fd_curve25519_scalar_reduce.carry11_eq hcarry11 ht213 hs11_7 ht187 hs11 ht185 ht186 ht88 ht184
      ht117 ht140 hs23 hs20
  have hccarry13 :=
    fd_curve25519_scalar_reduce.carry13_eq hcarry13 ht218 hs13_5 ht193 hs13 ht192 ht93
  have hccarry15 :=
    fd_curve25519_scalar_reduce.carry15_eq hcarry15 ht223 hs15_3 hs15_2 hs15_1 ht129 ht122 hs15 hs22
      hs23 ht100
  have hccarry0 :=
    fd_curve25519_scalar_reduce.carry0_eq hcarry0 ht297 hs0_1 ht285 hs0 hs12_7 hs12_6 hs12_5 ht195'
      ht151 hs12 ht150 ht118 ht90 hs23
  have hccarry2 :=
    fd_curve25519_scalar_reduce.carry2_eq hcarry2 ht302 hs2_3 hs2_2 ht289 hs2_1 ht275 hs12_7 ht262
      hs2 hs13_6 hs12_6 hs14_5 ht66 hs13_5 ht221' hs12_5 ht195' hs14_4 ht193 hs13 ht151 hs12 hs14_3
      ht200' ht192 ht93 ht150 ht118 ht90 hs14_2 ht133 hs23 hs14_1 ht127 hs21 ht120 hs14 hs22 ht95
  have hccarry4 :=
    fd_curve25519_scalar_reduce.carry4_eq hcarry4 ht307 hs4_5 hs4_4 ht293 hs4_3 ht279 hs12_7 hs4_2
      ht266 hs13_6 hs12_6 hs4_1 ht250 hs14_5 hs13_5 ht221' hs12_5 ht195' ht239 hs4 hs15_4 hs14_4
      ht193 hs13 ht151 hs12 hs16_3 ht72 hs15_3 ht226' hs14_3 ht200' ht192 ht93 ht150 ht118 ht90
      hs16_2 hs15_2 hs14_2 ht133 hs23 hs16_1 ht205' hs15_1 ht129 hs14_1 ht127 hs21 ht124 hs16 ht122
      hs15 hs22 ht120 hs14 ht102 ht100 ht95
  have hccarry6_1 :=
    fd_curve25519_scalar_reduce.carry6_1_eq hcarry6_1 ht312 hs6_7 hs6_6 ht283 hs6_5 ht270 hs13_6
      hs6_4 ht254 hs14_5 hs13_5 ht221' hs6_3 ht243 hs15_4 hs14_4 ht193 hs13 hs6_2 ht230 hs16_3
      hs15_3 ht226' hs14_3 ht200' ht192 ht93 hs6_1 ht171' hs17_1 hs16_2 hs15_2 hs14_2 ht133 ht154
      hs6 hs17 hs16_1 ht205' hs15_1 ht129 hs14_1 ht127 hs21 hs18 ht76 ht104 ht124 hs16 ht122 hs15
      hs22 ht120 hs14 hs23 ht102 ht100 ht95
  have hccarry8_1 :=
    fd_curve25519_scalar_reduce.carry8_1_eq hcarry8_1 ht322 hs8_8 hs8_7 ht257 hs8_6 ht246 hs15_4
      ht258 hs16_3 hs15_3 ht226' hs8_4 ht233 hs16_2 hs15_2 hs8_3 ht180' hs17_1 hs16_1 ht205' hs15_1
      ht129 hs8_2 ht158 hs17 ht124 hs16 ht122 hs15 hs22 hs8_1 ht144 hs18 ht104 hs23 ht102 ht100
      ht136 hs8 hs19 hs20 ht81
  have hccarry10_1 :=
    fd_curve25519_scalar_reduce.carry10_1_eq hcarry10_1 ht330 hs10_8 ht237 ht236 ht189' hs10_5 ht235
      ht165 ht132 hs17_1 ht164 ht126 hs21 hs17 ht163 ht161 hs22 ht104 ht162 ht147 hs18 ht139 hs10
      hs19 hs20 ht86
  have hccarry1 :=
    fd_curve25519_scalar_reduce.carry1_eq hcarry1 ht335 hs1_3 hs1_2 hs1_1 ht287 ht273 hs1 hs12_7
      hs13_6 ht64 hs12_6 hs13_5 ht221' hs12_5 ht195' ht193 hs13 ht151 hs12 ht192 ht93 ht150 ht118
      ht90 hs23
  have hccarry3 :=
    fd_curve25519_scalar_reduce.carry3_eq hcarry3 ht338 hs3_5 hs3_4 hs3_3 ht291 hs3_2 ht277 hs12_7
      hs3_1 ht264 hs13_6 hs12_6 ht248 hs3 hs14_5 hs13_5 ht221' hs12_5 ht195' hs15_4 ht69 hs14_4
      ht193 hs13 ht151 hs12 hs15_3 ht226' hs14_3 ht200' ht192 ht93 ht150 ht118 ht90 hs15_2 hs14_2
      ht133 hs23 hs15_1 ht129 hs14_1 ht127 hs21 ht122 hs15 hs22 ht120 hs14 ht100 ht95
  have hccarry5 :=
    fd_curve25519_scalar_reduce.carry5_eq hcarry5 ht341 hs5_7 hs5_6 hs5_5 ht295 hs5_4 ht281 hs12_7
      hs5_3 ht268 hs13_6 hs12_6 hs5_2 ht252 hs14_5 hs13_5 ht221' hs12_5 ht195' hs5_1 ht241 hs15_4
      hs14_4 ht193 hs13 ht151 hs12 ht228 hs5 hs16_3 hs15_3 ht226' hs14_3 ht200' ht192 ht93 ht150
      ht118 ht90 hs17_1 ht74 hs16_2 hs15_2 hs14_2 ht133 hs23 hs17 hs16_1 ht205' hs15_1 ht129 hs14_1
      ht127 hs21 ht104 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht102 ht100 ht95
  have hccarry7_1 :=
    fd_curve25519_scalar_reduce.carry7_1_eq hcarry7_1 ht345 hs7_9 hs7_8 hs7_7 ht272 hs7_6 ht256
      hs14_5 hs7_5 ht245 hs15_4 hs14_4 ht314 ht209' hs16_3 hs15_3 ht226' hs14_3 ht200' ht232 hs7_3
      hs16_2 hs15_2 hs14_2 ht133 hs17_1 hs7_2 hs16_1 ht205' hs15_1 ht129 hs14_1 ht127 hs21 hs17
      hs7_1 ht156 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht104 ht142 hs7 hs18 hs23 ht102 ht100 ht95
      hs19 ht79
  have hccarry9_1 :=
    fd_curve25519_scalar_reduce.carry9_1_eq hcarry9_1 ht350 hs9_9 hs9_8 hs9_7 ht247 ht324 ht212'
      hs16_3 hs9_5 ht234 hs16_2 hs9_4 hs17_1 hs16_1 ht205' ht177 ht131 hs17 ht124 hs16 ht176 ht160
      hs21 ht104 hs23 ht102 ht175 ht146 hs18 ht138 hs9 hs19 hs20 ht83
  have hccarry11_1 :=
    fd_curve25519_scalar_reduce.carry11_1_eq hcarry11_1 ht355 hs11_9 hs11_8 hs11_7 ht216' ht187 hs11
      ht185 ht186 ht88 ht184 ht117 ht140 hs23 hs20
  have hccarry0_1 :=
    fd_curve25519_scalar_reduce.carry0_1_eq hcarry0_1 hs0_3 hs0_2 ht359 hs0_1 ht300' ht285 hs0
      hs12_7 hs12_6 hs12_5 ht195' ht151 hs12 ht150 ht118 ht90 hs23
  have hccarry1_1 :=
    fd_curve25519_scalar_reduce.carry1_1_eq hcarry1_1 hs1_6 hs1_5 ht367 ht337' ht361 hs1_3 hs1_2
      hs1_1 ht287 ht273 hs1 hs12_7 hs13_6 ht64 hs12_6 hs13_5 ht221' hs12_5 ht195' ht193 hs13 ht151
      hs12 ht192 ht93 ht150 ht118 ht90 hs23
  have hccarry2_1 :=
    fd_curve25519_scalar_reduce.carry2_1_eq hcarry2_1 hs2_7 hs2_6 ht372 hs2_4 ht362 hs2_3 ht305'
      hs2_2 ht289 hs2_1 ht275 hs12_7 ht262 hs2 hs13_6 hs12_6 hs14_5 ht66 hs13_5 ht221' hs12_5 ht195'
      hs14_4 ht193 hs13 ht151 hs12 hs14_3 ht200' ht192 ht93 ht150 ht118 ht90 hs14_2 ht133 hs23
      hs14_1 ht127 hs21 ht120 hs14 hs22 ht95
  have hccarry3_1 :=
    fd_curve25519_scalar_reduce.carry3_1_eq hcarry3_1 hs3_8 hs3_7 ht377 ht340' hs3_5 ht363 hs3_4
      hs3_3 ht291 hs3_2 ht277 hs12_7 hs3_1 ht264 hs13_6 hs12_6 ht248 hs3 hs14_5 hs13_5 ht221' hs12_5
      ht195' hs15_4 ht69 hs14_4 ht193 hs13 ht151 hs12 hs15_3 ht226' hs14_3 ht200' ht192 ht93 ht150
      ht118 ht90 hs15_2 hs14_2 ht133 hs23 hs15_1 ht129 hs14_1 ht127 hs21 ht122 hs15 hs22 ht120 hs14
      ht100 ht95
  have hccarry4_1 :=
    fd_curve25519_scalar_reduce.carry4_1_eq hcarry4_1 hs4_9 hs4_8 ht382 hs4_6 ht364 hs4_5 ht310'
      hs4_4 ht293 hs4_3 ht279 hs12_7 hs4_2 ht266 hs13_6 hs12_6 hs4_1 ht250 hs14_5 hs13_5 ht221'
      hs12_5 ht195' ht239 hs4 hs15_4 hs14_4 ht193 hs13 ht151 hs12 hs16_3 ht72 hs15_3 ht226' hs14_3
      ht200' ht192 ht93 ht150 ht118 ht90 hs16_2 hs15_2 hs14_2 ht133 hs23 hs16_1 ht205' hs15_1 ht129
      hs14_1 ht127 hs21 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht102 ht100 ht95
  have hccarry5_1 :=
    fd_curve25519_scalar_reduce.carry5_1_eq hcarry5_1 hs5_10 hs5_9 ht387 ht344' hs5_7 ht365 hs5_6
      hs5_5 ht295 hs5_4 ht281 hs12_7 hs5_3 ht268 hs13_6 hs12_6 hs5_2 ht252 hs14_5 hs13_5 ht221'
      hs12_5 ht195' hs5_1 ht241 hs15_4 hs14_4 ht193 hs13 ht151 hs12 ht228 hs5 hs16_3 hs15_3 ht226'
      hs14_3 ht200' ht192 ht93 ht150 ht118 ht90 hs17_1 ht74 hs16_2 hs15_2 hs14_2 ht133 hs23 hs17
      hs16_1 ht205' hs15_1 ht129 hs14_1 ht127 hs21 ht104 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht102
      ht100 ht95
  have hccarry6_2 :=
    fd_curve25519_scalar_reduce.carry6_2_eq hcarry6_2 hs6_10 hs6_9 hs6_8 hs6_7 ht320' hs6_6 ht283
      hs6_5 ht270 hs13_6 hs6_4 ht254 hs14_5 hs13_5 ht221' hs6_3 ht243 hs15_4 hs14_4 ht193 hs13 hs6_2
      ht230 hs16_3 hs15_3 ht226' hs14_3 ht200' ht192 ht93 hs6_1 ht171' hs17_1 hs16_2 hs15_2 hs14_2
      ht133 ht154 hs6 hs17 hs16_1 ht205' hs15_1 ht129 hs14_1 ht127 hs21 hs18 ht76 ht104 ht124 hs16
      ht122 hs15 hs22 ht120 hs14 hs23 ht102 ht100 ht95
  have hccarry7_2 :=
    fd_curve25519_scalar_reduce.carry7_2_eq hcarry7_2 hs7_11 hs7_10 hs7_9 ht348' hs7_8 hs7_7 ht272
      hs7_6 ht256 hs14_5 hs7_5 ht245 hs15_4 hs14_4 ht314 ht209' hs16_3 hs15_3 ht226' hs14_3 ht200'
      ht232 hs7_3 hs16_2 hs15_2 hs14_2 ht133 hs17_1 hs7_2 hs16_1 ht205' hs15_1 ht129 hs14_1 ht127
      hs21 hs17 hs7_1 ht156 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht104 ht142 hs7 hs18 hs23 ht102
      ht100 ht95 hs19 ht79
  have hccarry8_2 :=
    fd_curve25519_scalar_reduce.carry8_2_eq hcarry8_2 hs8_11 hs8_10 hs8_9 hs8_8 ht328' hs8_7 ht257
      hs8_6 ht246 hs15_4 ht258 hs16_3 hs15_3 ht226' hs8_4 ht233 hs16_2 hs15_2 hs8_3 ht180' hs17_1
      hs16_1 ht205' hs15_1 ht129 hs8_2 ht158 hs17 ht124 hs16 ht122 hs15 hs22 hs8_1 ht144 hs18 ht104
      hs23 ht102 ht100 ht136 hs8 hs19 hs20 ht81
  have hccarry9_2 :=
    fd_curve25519_scalar_reduce.carry9_2_eq hcarry9_2 hs9_11 hs9_10 hs9_9 ht353' hs9_8 hs9_7 ht247
      ht324 ht212' hs16_3 hs9_5 ht234 hs16_2 hs9_4 hs17_1 hs16_1 ht205' ht177 ht131 hs17 ht124 hs16
      ht176 ht160 hs21 ht104 hs23 ht102 ht175 ht146 hs18 ht138 hs9 hs19 hs20 ht83
  have hccarry10_2 :=
    fd_curve25519_scalar_reduce.carry10_2_eq hcarry10_2 hs10_11 hs10_10 hs10_9 hs10_8 ht333' ht237
      ht236 ht189' hs10_5 ht235 ht165 ht132 hs17_1 ht164 ht126 hs21 hs17 ht163 ht161 hs22 ht104
      ht162 ht147 hs18 ht139 hs10 hs19 hs20 ht86
  have hccarry11_2 :=
    fd_curve25519_scalar_reduce.carry11_2_eq hcarry11_2 hs11_11 hs11_10 hs11_9 ht357' hs11_8 hs11_7
      ht216' ht187 hs11 ht185 ht186 ht88 ht184 ht117 ht140 hs23 hs20
  have hcs11_12 :=
    fd_curve25519_scalar_reduce.s11_12_eq hs11_12' hs11_11 hs11_10 hs11_9 ht357' hs11_8 hs11_7
      ht216' ht187 hs11 ht185 ht186 ht88 ht184 ht117 ht140 hs23 hs20
  have hcs0_5 :=
    fd_curve25519_scalar_reduce.s0_5_eq hs0_5 ht411 hs0_4' hs0_3 hs0_2 ht359 hs0_1 ht300' ht285 hs0
      hs12_7 hs12_6 hs12_5 ht195' ht151 hs12 ht150 ht118 ht90 hs23
  have hcs1_9 :=
    fd_curve25519_scalar_reduce.s1_9_eq hs1_9 hs1_8 ht412 hs1_7' hs1_6 hs1_5 ht367 ht337' ht361
      hs1_3 hs1_2 hs1_1 ht287 ht273 hs1 hs12_7 hs13_6 ht64 hs12_6 hs13_5 ht221' hs12_5 ht195' ht193
      hs13 ht151 hs12 ht192 ht93 ht150 ht118 ht90 hs23
  have hcs2_10 :=
    fd_curve25519_scalar_reduce.s2_10_eq hs2_10 hs2_9 ht414 hs2_8' hs2_7 hs2_6 ht372 hs2_4 ht362
      hs2_3 ht305' hs2_2 ht289 hs2_1 ht275 hs12_7 ht262 hs2 hs13_6 hs12_6 hs14_5 ht66 hs13_5 ht221'
      hs12_5 ht195' hs14_4 ht193 hs13 ht151 hs12 hs14_3 ht200' ht192 ht93 ht150 ht118 ht90 hs14_2
      ht133 hs23 hs14_1 ht127 hs21 ht120 hs14 hs22 ht95
  have hcs3_11 :=
    fd_curve25519_scalar_reduce.s3_11_eq hs3_11 hs3_10 ht416 hs3_9' hs3_8 hs3_7 ht377 ht340' hs3_5
      ht363 hs3_4 hs3_3 ht291 hs3_2 ht277 hs12_7 hs3_1 ht264 hs13_6 hs12_6 ht248 hs3 hs14_5 hs13_5
      ht221' hs12_5 ht195' hs15_4 ht69 hs14_4 ht193 hs13 ht151 hs12 hs15_3 ht226' hs14_3 ht200'
      ht192 ht93 ht150 ht118 ht90 hs15_2 hs14_2 ht133 hs23 hs15_1 ht129 hs14_1 ht127 hs21 ht122 hs15
      hs22 ht120 hs14 ht100 ht95
  have hcs4_12 :=
    fd_curve25519_scalar_reduce.s4_12_eq hs4_12 hs4_11 ht418 hs4_10' hs4_9 hs4_8 ht382 hs4_6 ht364
      hs4_5 ht310' hs4_4 ht293 hs4_3 ht279 hs12_7 hs4_2 ht266 hs13_6 hs12_6 hs4_1 ht250 hs14_5
      hs13_5 ht221' hs12_5 ht195' ht239 hs4 hs15_4 hs14_4 ht193 hs13 ht151 hs12 hs16_3 ht72 hs15_3
      ht226' hs14_3 ht200' ht192 ht93 ht150 ht118 ht90 hs16_2 hs15_2 hs14_2 ht133 hs23 hs16_1 ht205'
      hs15_1 ht129 hs14_1 ht127 hs21 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht102 ht100 ht95
  have hcs5_13 :=
    fd_curve25519_scalar_reduce.s5_13_eq hs5_13 hs5_12 ht420 hs5_11' hs5_10 hs5_9 ht387 ht344' hs5_7
      ht365 hs5_6 hs5_5 ht295 hs5_4 ht281 hs12_7 hs5_3 ht268 hs13_6 hs12_6 hs5_2 ht252 hs14_5 hs13_5
      ht221' hs12_5 ht195' hs5_1 ht241 hs15_4 hs14_4 ht193 hs13 ht151 hs12 ht228 hs5 hs16_3 hs15_3
      ht226' hs14_3 ht200' ht192 ht93 ht150 ht118 ht90 hs17_1 ht74 hs16_2 hs15_2 hs14_2 ht133 hs23
      hs17 hs16_1 ht205' hs15_1 ht129 hs14_1 ht127 hs21 ht104 ht124 hs16 ht122 hs15 hs22 ht120 hs14
      ht102 ht100 ht95
  have hcs6_12 :=
    fd_curve25519_scalar_reduce.s6_12_eq hs6_12 hs6_11' hs6_10 hs6_9 hs6_8 hs6_7 ht320' hs6_6 ht283
      hs6_5 ht270 hs13_6 hs6_4 ht254 hs14_5 hs13_5 ht221' hs6_3 ht243 hs15_4 hs14_4 ht193 hs13 hs6_2
      ht230 hs16_3 hs15_3 ht226' hs14_3 ht200' ht192 ht93 hs6_1 ht171' hs17_1 hs16_2 hs15_2 hs14_2
      ht133 ht154 hs6 hs17 hs16_1 ht205' hs15_1 ht129 hs14_1 ht127 hs21 hs18 ht76 ht104 ht124 hs16
      ht122 hs15 hs22 ht120 hs14 hs23 ht102 ht100 ht95
  have hcs7_13 :=
    fd_curve25519_scalar_reduce.s7_13_eq hs7_13 hs7_12' hs7_11 hs7_10 hs7_9 ht348' hs7_8 hs7_7 ht272
      hs7_6 ht256 hs14_5 hs7_5 ht245 hs15_4 hs14_4 ht314 ht209' hs16_3 hs15_3 ht226' hs14_3 ht200'
      ht232 hs7_3 hs16_2 hs15_2 hs14_2 ht133 hs17_1 hs7_2 hs16_1 ht205' hs15_1 ht129 hs14_1 ht127
      hs21 hs17 hs7_1 ht156 ht124 hs16 ht122 hs15 hs22 ht120 hs14 ht104 ht142 hs7 hs18 hs23 ht102
      ht100 ht95 hs19 ht79
  have hcs8_13 :=
    fd_curve25519_scalar_reduce.s8_13_eq hs8_13 hs8_12' hs8_11 hs8_10 hs8_9 hs8_8 ht328' hs8_7 ht257
      hs8_6 ht246 hs15_4 ht258 hs16_3 hs15_3 ht226' hs8_4 ht233 hs16_2 hs15_2 hs8_3 ht180' hs17_1
      hs16_1 ht205' hs15_1 ht129 hs8_2 ht158 hs17 ht124 hs16 ht122 hs15 hs22 hs8_1 ht144 hs18 ht104
      hs23 ht102 ht100 ht136 hs8 hs19 hs20 ht81
  have hcs9_13 :=
    fd_curve25519_scalar_reduce.s9_13_eq hs9_13 hs9_12' hs9_11 hs9_10 hs9_9 ht353' hs9_8 hs9_7 ht247
      ht324 ht212' hs16_3 hs9_5 ht234 hs16_2 hs9_4 hs17_1 hs16_1 ht205' ht177 ht131 hs17 ht124 hs16
      ht176 ht160 hs21 ht104 hs23 ht102 ht175 ht146 hs18 ht138 hs9 hs19 hs20 ht83
  have hcs10_13 :=
    fd_curve25519_scalar_reduce.s10_13_eq hs10_13 hs10_12' hs10_11 hs10_10 hs10_9 hs10_8 ht333'
      ht237 ht236 ht189' hs10_5 ht235 ht165 ht132 hs17_1 ht164 ht126 hs21 hs17 ht163 ht161 hs22
      ht104 ht162 ht147 hs18 ht139 hs10 hs19 hs20 ht86
  clear hs0 ht64 hs1 ht66 hs2 ht69 hs3 ht72 hs4 ht74 hs5 ht76 hs6 ht79 hs7 ht81 hs8 ht83 hs9 ht86
    hs10 ht88 hs11 ht90 hs12 ht93 hs13 ht95 hs14 ht100 hs15 ht102 hs16 ht104 hs17 ht109 hs22 hs21
    ht115 hs23 ht117 ht118 ht119 ht120 hs14_1 ht122 hs15_1 ht124 hs16_1 ht126 ht127 hs14_2 ht129
    hs15_2 ht131 ht132 ht133 hs14_3 hs20 ht136 hs8_1 ht138 ht139 ht140 hs19 ht142 hs7_1 ht144 hs8_2
    ht146 ht147 ht150 ht151 hs12_5 hs18 ht154 hs6_1 ht156 hs7_2 ht158 hs8_3 ht160 ht161 ht162 ht163
    ht164 ht165 hs10_5 ht168 hcarry6 hs7_3 ht171 hs6_2 ht173 hcarry8 ht175 ht176 ht177 hs9_4 hs9_5
    ht180 hs8_4 ht182 hcarry10 ht184 ht185 ht186 ht187 hs11_7 ht189 ht190 hcarry12 ht192 ht193
    hs13_5 ht195 hs12_6 ht197 hcarry14 hs15_3 ht200 hs14_4 ht202 hcarry16 hs17_1 ht205 hs16_2 ht207
    hcarry7 ht209 ht210 hcarry9 ht212 ht213 hcarry11 hs12_7 ht216 hs11_8 ht218 hcarry13 hs14_5 ht221
    hs13_6 ht223 hcarry15 hs16_3 ht226 hs15_4 ht228 hs5_1 ht230 hs6_3 ht232 ht233 ht234 ht235 ht236
    ht237 hs10_8 ht239 hs4_1 ht241 hs5_2 ht243 hs6_4 ht245 ht246 ht247 ht248 hs3_1 ht250 hs4_2 ht252
    hs5_3 ht254 hs6_5 ht256 ht257 ht258 hs8_6 hs8_7 hs8_8 ht262 hs2_1 ht264 hs3_2 ht266 hs4_3 ht268
    hs5_4 ht270 hs6_6 ht272 ht273 hs1_1 ht275 hs2_2 ht277 hs3_3 ht279 hs4_4 ht281 hs5_5 ht283 hs6_7
    ht285 hs0_1 ht287 hs1_2 ht289 hs2_3 ht291 hs3_4 ht293 hs4_5 ht295 hs5_6 ht297 hcarry0 hs1_3
    ht300 hs0_2 ht302 hcarry2 hs3_5 ht305 hs2_4 ht307 hcarry4 hs5_7 ht310 hs4_6 ht312 hcarry6_1
    ht314 hs7_5 hs7_6 hs7_7 hs7_8 hs7_9 ht320 hs6_8 ht322 hcarry8_1 ht324 hs9_7 hs9_8 hs9_9 ht328
    hs8_9 ht330 hcarry10_1 hs11_9 ht333 hs10_9 ht335 hcarry1 ht337 ht338 hcarry3 ht340 ht341 hcarry5
    hs6_9 ht344 ht345 hcarry7_1 hs8_10 ht348 hs7_10 ht350 hcarry9_1 hs10_10 ht353 hs9_10 ht355
    hcarry11_1 ht357 hs11_10 ht359 hs0_3 ht361 ht362 ht363 ht364 ht365 hcarry0_1 ht367 hs1_5 hs1_6
    hs0_4 hcarry1_1 ht372 hs2_6 hs2_7 hs1_7 hcarry2_1 ht377 hs3_7 hs3_8 hs2_8 hcarry3_1 ht382 hs4_8
    hs4_9 hs3_9 hcarry4_1 ht387 hs5_9 hs5_10 hs4_10 hcarry5_1 hs6_10 hs5_11 hcarry6_2 hs7_11 hs6_11
    hcarry7_2 hs8_11 hs7_12 hcarry8_2 hs9_11 hs8_12 hcarry9_2 hs10_11 hs9_12 hcarry10_2 hs11_11
    hs10_12 hcarry11_2 hs11_12 ht411 ht412 hs1_8 ht414 hs2_9 ht416 hs3_10 ht418 hs4_11 ht420 hs5_12
    hs0_5 hs1_9 hs2_10 hs3_11 hs4_12 hs5_13 hs6_12 hs7_13 hs8_13 hs9_13 hs10_13 ht443 ht444 ht171'
    ht180' ht189' ht195' ht200' ht205' ht209' ht212' ht216' ht221' ht226' ht300' ht305' ht310'
    ht320' ht328' ht333' ht337' ht340' ht344' ht348' ht353' ht357' hs0_4' hs1_7' hs2_8' hs3_9'
    hs4_10' hs5_11' hs6_11' hs7_12' hs8_12' hs9_12' hs10_12' hs11_12'
  keep_eqs
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Lane
