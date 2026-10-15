module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import Firedancer.Crc.Ref.Mlir.fd_curve25519_scalar_reduce
import Std.Tactic.BVDecide

/-!
# `fd_curve25519_scalar_reduce` (MLIR lift ↔ spec)

Stated with the tree's `Firedancer.Ref.fd_curve25519_scalar_reduce.spec`. The lift loads the input
words inline (`fd_ulong_load_8_fast`).
-/

namespace MLIR.Firedancer.Crc.Ref

open Firedancer.Ref (Bnd nswAdd nswSub nswMul nswShl nuwAdd nuwMul lshrNonneg andMask)

/-! ## Proof -/

section Proof

/-- The constants the code reads after loading the input. -/
abbrev fd_curve25519_scalar_reduce.Consts (E : ⟪fd_curve25519_scalar_reduce.Γ⟫) : Prop :=
  E ⊨ [%0 := 16#64, %1 := 40#64, %2 := 2097151#64, %3 := 21#64, %4 := 42#64, %5 := 1#64, %6 :=
    20#64, %7 := 41#64, %8 := 2#64, %9 := 19#64, %10 := 3#64, %11 := 18#64, %12 := 39#64, %13 :=
    4#64, %14 := 17#64, %15 := 38#64, %16 := 5#64, %17 := 37#64, %18 := 6#64, %19 := 15#64, %20 :=
    36#64, %21 := 7#64, %22 := 14#64, %23 := 35#64, %24 := 666643#64, %25 := 470296#64, %26 :=
    654183#64, %27 := 18446744073708553811#64, %28 := 136657#64, %29 := 18446744073708867715#64,
    %30 := 1048576#64, %31 := 8796090925056#64, %32 := 9223372036852678656#64, %33 :=
    18446744073707454464#64, %34 := 4398044413952#64, %35 := 9223367638808264704#64, %36 := 63#64,
    %37 := 1048575#64, %38 := 2199022206976#64, %39 := 4611683819404132352#64, %40 := 62#64, %41 :=
    524287#64, %42 := 1099511103488#64, %43 := 2305841909702066176#64, %44 := 61#64, %45 :=
    262143#64, %46 := 549755551744#64]

/-! `^bb0` in thirteen runs. Each `runK` steps the instructions from the `K`-th of any block whose
body from there on is `^bb0`'s (`hbody`), in continuation form: `hK` takes the env with the run's
values named (`sK_n` is C's `sK` after its `n`-th assignment, `tN` the compiled code's `%N`), their
C forms and their bounds. The input values' bounds (`hb…`) let the `nsw`/`nuw` flags be discharged.
-/

/-- From `%0`: the constants, and the input words `in0 … in7`. -/
theorem fd_curve25519_scalar_reduce.run0 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 0 = fd_curve25519_scalar_reduce.entry.body.drop 0)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) (hwf : S.WF)
    (hin : Fits S.mem inp (8 * 64)) (hin_off : ¬inp.offset.uaddOverflow 64#64)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (in0 in1 in2 in3 in4 in5 in6 in7 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%47 := in0, %49 := in1, %51 := in2, %53 := in3, %55 := in4, %57 := in5, %59 :=
              in6, %61 := in7]) →
          (hin0 : in0 = (S.mem.readAt inp 512).extractLsb' 0 64) →
          (hin1 : in1 = (S.mem.readAt inp 512).extractLsb' 64 64) →
          (hin2 : in2 = (S.mem.readAt inp 512).extractLsb' 128 64) →
          (hin3 : in3 = (S.mem.readAt inp 512).extractLsb' 192 64) →
          (hin4 : in4 = (S.mem.readAt inp 512).extractLsb' 256 64) →
          (hin5 : in5 = (S.mem.readAt inp 512).extractLsb' 320 64) →
          (hin6 : in6 = (S.mem.readAt inp 512).extractLsb' 384 64) →
          (hin7 : in7 = (S.mem.readAt inp 512).extractLsb' 448 64) →
          (blk.runBodyFrom E' 62 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  iterate 47 step_pure
  step_load with in0
  step_pure
  step_load with in1
  step_pure
  step_load with in2
  step_pure
  step_load with in3
  step_pure
  step_load with in4
  step_pure
  step_load with in5
  step_pure
  step_load with in6
  step_pure
  step_load with in7
  subst hS
  exact
    hK _ in0 in1 in2 in3 in4 in5 in6 in7 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (hin0.trans (BitVec.setWidth_eq_extractLsb' (by decide))) hin1 hin2 hin3 hin4
      hin5 hin6 hin7

/-- From `%62`: `in0 … in7` unpacked into the limbs `s0 … s23`. -/
theorem fd_curve25519_scalar_reduce.run62 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 62 = fd_curve25519_scalar_reduce.entry.body.drop 62)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in0 in1 in2 in3 in4 in5 in6 in7 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%47 := in0, %49 := in1, %51 := in2, %53 := in3, %55 := in4, %57 := in5, %59 := in6,
        %61 := in7])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %72 := s5, %74 := s6,
              %76 := s7, %78 := s8, %80 := s9, %82 := s10, %84 := s11, %86 := s12, %88 := s13,
              %90 := s14, %92 := s15, %94 := s16, %96 := s17, %98 := s18, %100 := s19, %102 := s20,
              %104 := s21, %106 := s22, %107 := s23]) →
          (hs0 : s0 = in0 &&& 2097151#64) →
          (hs1 : s1 = in0 >>> 21 &&& 2097151#64) →
          (hs2 : s2 = in0 >>> 42 &&& 2097151#64) →
          (hs3 : s3 = (in0 >>> 63 ||| in1 <<< 1) &&& 2097151#64) →
          (hs4 : s4 = in1 >>> 20 &&& 2097151#64) →
          (hs5 : s5 = in1 >>> 41 &&& 2097151#64) →
          (hs6 : s6 = (in1 >>> 62 ||| in2 <<< 2) &&& 2097151#64) →
          (hs7 : s7 = in2 >>> 19 &&& 2097151#64) →
          (hs8 : s8 = in2 >>> 40 &&& 2097151#64) →
          (hs9 : s9 = (in2 >>> 61 ||| in3 <<< 3) &&& 2097151#64) →
          (hs10 : s10 = in3 >>> 18 &&& 2097151#64) →
          (hs11 : s11 = in3 >>> 39 &&& 2097151#64) →
          (hs12 : s12 = (in3 >>> 60 ||| in4 <<< 4) &&& 2097151#64) →
          (hs13 : s13 = in4 >>> 17 &&& 2097151#64) →
          (hs14 : s14 = in4 >>> 38 &&& 2097151#64) →
          (hs15 : s15 = (in4 >>> 59 ||| in5 <<< 5) &&& 2097151#64) →
          (hs16 : s16 = in5 >>> 16 &&& 2097151#64) →
          (hs17 : s17 = in5 >>> 37 &&& 2097151#64) →
          (hs18 : s18 = (in5 >>> 58 ||| in6 <<< 6) &&& 2097151#64) →
          (hs19 : s19 = in6 >>> 15 &&& 2097151#64) →
          (hs20 : s20 = in6 >>> 36 &&& 2097151#64) →
          (hs21 : s21 = (in6 >>> 57 ||| in7 <<< 7) &&& 2097151#64) →
          (hs22 : s22 = in7 >>> 14 &&& 2097151#64) →
          (hs23 : s23 = in7 >>> 35) →
          (hbs0 : Bnd s0 0 2097151) →
          (hbs1 : Bnd s1 0 2097151) →
          (hbs2 : Bnd s2 0 2097151) →
          (hbs3 : Bnd s3 0 2097151) →
          (hbs4 : Bnd s4 0 2097151) →
          (hbs5 : Bnd s5 0 2097151) →
          (hbs6 : Bnd s6 0 2097151) →
          (hbs7 : Bnd s7 0 2097151) →
          (hbs8 : Bnd s8 0 2097151) →
          (hbs9 : Bnd s9 0 2097151) →
          (hbs10 : Bnd s10 0 2097151) →
          (hbs11 : Bnd s11 0 2097151) →
          (hbs12 : Bnd s12 0 2097151) →
          (hbs13 : Bnd s13 0 2097151) →
          (hbs14 : Bnd s14 0 2097151) →
          (hbs15 : Bnd s15 0 2097151) →
          (hbs16 : Bnd s16 0 2097151) →
          (hbs17 : Bnd s17 0 2097151) →
          (hbs18 : Bnd s18 0 2097151) →
          (hbs19 : Bnd s19 0 2097151) →
          (hbs20 : Bnd s20 0 2097151) →
          (hbs21 : Bnd s21 0 2097151) →
          (hbs22 : Bnd s22 0 2097151) →
          (hbs23 : Bnd s23 0 536870911) → (blk.runBodyFrom E' 108 S >>= g) = K) :
    (blk.runBodyFrom E 62 S >>= g) = K := by
  -- long s0 = …
  step_pure with s0
  bnd s0
  step_pure
  -- long s1 = …
  step_pure with s1
  bnd s1
  step_pure
  -- long s2 = …
  step_pure with s2
  bnd s2
  step_pure
  -- long s3 = …
  step_pure with s3
  bnd s3
  step_pure
  -- long s4 = …
  step_pure with s4
  bnd s4
  step_pure
  -- long s5 = …
  step_pure with s5
  bnd s5
  step_pure
  -- long s6 = …
  step_pure with s6
  bnd s6
  step_pure
  -- long s7 = …
  step_pure with s7
  bnd s7
  step_pure
  -- long s8 = …
  step_pure with s8
  bnd s8
  step_pure
  -- long s9 = …
  step_pure with s9
  bnd s9
  step_pure
  -- long s10 = …
  step_pure with s10
  bnd s10
  step_pure
  -- long s11 = …
  step_pure with s11
  bnd s11
  step_pure
  -- long s12 = …
  step_pure with s12
  bnd s12
  step_pure
  -- long s13 = …
  step_pure with s13
  bnd s13
  step_pure
  -- long s14 = …
  step_pure with s14
  bnd s14
  step_pure
  -- long s15 = …
  step_pure with s15
  bnd s15
  step_pure
  -- long s16 = …
  step_pure with s16
  bnd s16
  step_pure
  -- long s17 = …
  step_pure with s17
  bnd s17
  step_pure
  -- long s18 = …
  step_pure with s18
  bnd s18
  step_pure
  -- long s19 = …
  step_pure with s19
  bnd s19
  step_pure
  -- long s20 = …
  step_pure with s20
  bnd s20
  step_pure
  -- long s21 = …
  step_pure with s21
  bnd s21
  step_pure
  -- long s22 = …
  step_pure with s22
  bnd s22
  -- long s23 = …
  step_pure with s23
  bnd s23
  exact
    hK _ s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) hs0 hs1 hs2 (by simp only [hs3, Bnd.fshl_eq _ _ 1 (by decide), Nat.reduceSub])
      hs4 hs5 (by simp only [hs6, Bnd.fshl_eq _ _ 2 (by decide), Nat.reduceSub]) hs7 hs8
      (by simp only [hs9, Bnd.fshl_eq _ _ 3 (by decide), Nat.reduceSub]) hs10 hs11
      (by simp only [hs12, Bnd.fshl_eq _ _ 4 (by decide), Nat.reduceSub]) hs13 hs14
      (by simp only [hs15, Bnd.fshl_eq _ _ 5 (by decide), Nat.reduceSub]) hs16 hs17
      (by simp only [hs18, Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]) hs19 hs20
      (by simp only [hs21, Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]) hs22 hs23 hbs0 hbs1 hbs2
      hbs3 hbs4 hbs5 hbs6 hbs7 hbs8 hbs9 hbs10 hbs11 hbs12 hbs13 hbs14 hbs15 hbs16 hbs17 hbs18 hbs19
      hbs20 hbs21 hbs22 hbs23

/-- From `%108`: the rows of `s23 … s18` into `s6 … s16`, begun. -/
theorem fd_curve25519_scalar_reduce.run108 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 108 = fd_curve25519_scalar_reduce.entry.body.drop 108)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %72 := s5, %74 := s6, %76 := s7,
        %78 := s8, %80 := s9, %82 := s10, %84 := s11, %86 := s12, %88 := s13, %90 := s14, %92 :=
        s15, %94 := s16, %96 := s17, %98 := s18, %100 := s19, %102 := s20, %104 := s21, %106 := s22,
        %107 := s23])
    (hbs8 : Bnd s8 0 2097151) (hbs11 : Bnd s11 0 2097151) (hbs12 : Bnd s12 0 2097151)
    (hbs13 : Bnd s13 0 2097151) (hbs14 : Bnd s14 0 2097151) (hbs15 : Bnd s15 0 2097151)
    (hbs16 : Bnd s16 0 2097151) (hbs20 : Bnd s20 0 2097151) (hbs21 : Bnd s21 0 2097151)
    (hbs22 : Bnd s22 0 2097151) (hbs23 : Bnd s23 0 536870911)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s11_1 s12_1 s13_1 s14_1 s15_1 s16_1 t120 t121 t122 t123 s14_2 s15_2 t128 t129 t130 t131
          t132 s14_3 s8_1 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %72 := s5, %74 := s6,
              %76 := s7, %80 := s9, %82 := s10, %96 := s17, %98 := s18, %100 := s19, %102 := s20,
              %109 := s11_1, %111 := s12_1, %113 := s13_1, %119 := s16_1, %120 := t120, %121 :=
              t121, %122 := t122, %123 := t123, %127 := s15_2, %128 := t128, %129 := t129, %130 :=
              t130, %131 := t131, %132 := t132, %134 := s14_3, %136 := s8_1]) →
          (hs11_1 : s11_1 = s11 + s23 * 666643#64) →
          (hs12_1 : s12_1 = s12 + s23 * 470296#64) →
          (hs13_1 : s13_1 = s13 + s23 * 654183#64) →
          (hs14_1 : s14_1 = s14 - s23 * 997805#64) →
          (hs15_1 : s15_1 = s15 + s23 * 136657#64) →
          (hs16_1 : s16_1 = s16 - s23 * 683901#64) →
          (ht120 : t120 = (s22 * 666643#64)) →
          (ht121 : t121 = (s22 * 470296#64)) →
          (ht122 : t122 = (s22 * 654183#64)) →
          (ht123 : t123 = (s22 * 18446744073708553811#64)) →
          (hs14_2 : s14_2 = s14_1 + s22 * 136657#64) →
          (hs15_2 : s15_2 = s15_1 - s22 * 683901#64) →
          (ht128 : t128 = (s21 * 666643#64)) →
          (ht129 : t129 = (s21 * 470296#64)) →
          (ht130 : t130 = (s21 * 654183#64)) →
          (ht131 : t131 = (s21 * 18446744073708553811#64)) →
          (ht132 : t132 = (s21 * 136657#64)) →
          (hs14_3 : s14_3 = s14_2 - s21 * 683901#64) →
          (hs8_1 : s8_1 = s8 + s20 * 666643#64) →
          (hbs11_1 : Bnd s11_1 0 357901236818924) →
          (hbs12_1 : Bnd s12_1 0 252488244056807) →
          (hbs13_1 : Bnd s13_1 0 351211825267864) →
          (hbs14_1 : Bnd s14_1 (-535692479350355) 2097151) →
          (hbs15_1 : Bnd s15_1 0 73367170181678) →
          (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151) →
          (hbt120 : Bnd t120 0 1398051034093) →
          (hbt121 : Bnd t121 0 986281726696) →
          (hbt122 : Bnd t122 0 1371920532633) →
          (hbt123 : Bnd t123 (-2092547753555) 0) →
          (hbs14_2 : Bnd s14_2 (-535692479350355) 286592461358) →
          (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678) →
          (hbt128 : Bnd t128 0 1398051034093) →
          (hbt129 : Bnd t129 0 986281726696) →
          (hbt130 : Bnd t130 0 1371920532633) →
          (hbt131 : Bnd t131 (-2092547753555) 0) →
          (hbt132 : Bnd t132 0 286590364207) →
          (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358) →
          (hbs8_1 : Bnd s8_1 0 1398053131244) → (blk.runBodyFrom E' 137 S >>= g) = K) :
    (blk.runBodyFrom E 108 S >>= g) = K := by
  step_pure [nswMul, nuwMul]
  -- s11 += s23*666643L
  step_pure [nswAdd, nuwAdd] with s11_1
  bnd s11_1
  step_pure [nswMul, nuwMul]
  -- s12 += s23*470296L
  step_pure [nswAdd, nuwAdd] with s12_1
  bnd s12_1
  step_pure [nswMul, nuwMul]
  -- s13 += s23*654183L
  step_pure [nswAdd, nuwAdd] with s13_1
  bnd s13_1
  step_pure [nswMul]
  -- s14 -= s23*997805L
  step_pure [nswAdd] with s14_1
  bnd s14_1
  step_pure [nswMul, nuwMul]
  -- s15 += s23*136657L
  step_pure [nswAdd, nuwAdd] with s15_1
  bnd s15_1
  step_pure [nswMul]
  -- s16 -= s23*683901L
  step_pure [nswAdd] with s16_1
  bnd s16_1
  step_pure [nswMul, nuwMul] with t120
  bnd t120
  step_pure [nswMul, nuwMul] with t121
  bnd t121
  step_pure [nswMul, nuwMul] with t122
  bnd t122
  step_pure [nswMul] with t123
  bnd t123
  step_pure [nswMul, nuwMul]
  -- s14 += s22*136657L
  step_pure [nswAdd] with s14_2
  bnd s14_2
  step_pure [nswMul]
  -- s15 -= s22*683901L
  step_pure [nswAdd] with s15_2
  bnd s15_2
  step_pure [nswMul, nuwMul] with t128
  bnd t128
  step_pure [nswMul, nuwMul] with t129
  bnd t129
  step_pure [nswMul, nuwMul] with t130
  bnd t130
  step_pure [nswMul] with t131
  bnd t131
  step_pure [nswMul, nuwMul] with t132
  bnd t132
  step_pure [nswMul]
  -- s14 -= s21*683901L
  step_pure [nswAdd] with s14_3
  bnd s14_3
  step_pure [nswMul, nuwMul]
  -- s8 += s20*666643L
  step_pure [nswAdd, nuwAdd] with s8_1
  bnd s8_1
  exact
    hK _ s11_1 s12_1 s13_1 s14_1 s15_1 s16_1 t120 t121 t122 t123 s14_2 s15_2 t128 t129 t130 t131
      t132 s14_3 s8_1 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hs11_1) (by bridge hs12_1) (by bridge hs13_1) (by bridge hs14_1)
      (by bridge hs15_1) (by bridge hs16_1) ht120 ht121 ht122 ht123 (by bridge hs14_2)
      (by bridge hs15_2) ht128 ht129 ht130 ht131 ht132 (by bridge hs14_3) (by bridge hs8_1) hbs11_1
      hbs12_1 hbs13_1 hbs14_1 hbs15_1 hbs16_1 hbt120 hbt121 hbt122 hbt123 hbs14_2 hbs15_2 hbt128
      hbt129 hbt130 hbt131 hbt132 hbs14_3 hbs8_1

/-- From `%137`: those rows finished, then `carry6` and `carry8`. -/
theorem fd_curve25519_scalar_reduce.run137 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 137 = fd_curve25519_scalar_reduce.entry.body.drop 137)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s6 s7 s9 s10 s17 s18 s19 s20 s11_1 s12_1 s13_1 s16_1 t120 t121 t122 t123
      s15_2 t128 t129 t130 t131 t132 s14_3 s8_1 s21 s22 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %72 := s5, %74 := s6, %76 := s7,
        %80 := s9, %82 := s10, %96 := s17, %98 := s18, %100 := s19, %102 := s20, %109 := s11_1,
        %111 := s12_1, %113 := s13_1, %119 := s16_1, %120 := t120, %121 := t121, %122 := t122,
        %123 := t123, %127 := s15_2, %128 := t128, %129 := t129, %130 := t130, %131 := t131, %132 :=
        t132, %134 := s14_3, %136 := s8_1])
    (ht120 : t120 = (s22 * 666643#64)) (ht122 : t122 = (s22 * 654183#64))
    (ht128 : t128 = (s21 * 666643#64)) (ht129 : t129 = (s21 * 470296#64))
    (ht131 : t131 = (s21 * 18446744073708553811#64)) (hbs6 : Bnd s6 0 2097151)
    (hbs7 : Bnd s7 0 2097151) (hbs9 : Bnd s9 0 2097151) (hbs10 : Bnd s10 0 2097151)
    (hbs18 : Bnd s18 0 2097151) (hbs19 : Bnd s19 0 2097151) (hbs20 : Bnd s20 0 2097151)
    (hbs21 : Bnd s21 0 2097151) (hbs22 : Bnd s22 0 2097151) (hbs12_1 : Bnd s12_1 0 252488244056807)
    (hbs8_1 : Bnd s8_1 0 1398053131244)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t139 t141 s7_1 s8_2 t148 s12_5 s6_1 s7_2 s8_3 s10_5 t167 carry6_1 s7_3 s6_2 carry8_1 s9_4
          s9_5 s8_4 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %72 := s5, %96 := s17,
              %109 := s11_1, %113 := s13_1, %119 := s16_1, %121 := t121, %123 := t123, %127 :=
              s15_2, %130 := t130, %132 := t132, %134 := s14_3, %139 := t139, %141 := t141, %148 :=
              t148, %153 := s12_5, %166 := s10_5, %167 := t167, %170 := s7_3, %172 := s6_2, %179 :=
              s9_5, %181 := s8_4]) →
          (ht139 : t139 = (s20 * 18446744073708553811#64)) →
          (ht141 : t141 = (s20 * 18446744073708867715#64)) →
          (hs7_1 : s7_1 = s7 + s19 * 666643#64) →
          (hs8_2 : s8_2 = s8_1 + s19 * 470296#64) →
          (ht148 : t148 = (s19 * 136657#64)) →
          (hs12_5 :
            s12_5 =
              (((s12_1 + s22 * 654183#64) - s21 * 997805#64) + s20 * 136657#64) - s19 * 683901#64) →
          (hs6_1 : s6_1 = s6 + s18 * 666643#64) →
          (hs7_2 : s7_2 = s7_1 + s18 * 470296#64) →
          (hs8_3 : s8_3 = s8_2 + s18 * 654183#64) →
          (hs10_5 :
            s10_5 =
              ((((s10 + s22 * 666643#64) + s21 * 470296#64) + s20 * 654183#64) - s19 * 997805#64) +
                s18 * 136657#64) →
          (ht167 : t167 = (s18 * 18446744073708867715#64)) →
          (hcarry6_1 : carry6_1 = (s6_1 + 1048576#64).sshiftRight 21) →
          (hs7_3 : s7_3 = s7_2 + ((s6_1 + 1048576#64).sshiftRight 21)) →
          (hs6_2 : s6_2 = s6_1 - ((s6_1 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry8_1 : carry8_1 = (s8_3 + 1048576#64).sshiftRight 21) →
          (hs9_4 :
            s9_4 =
              (((s9 + s21 * 666643#64) + s20 * 470296#64) + s19 * 654183#64) - s18 * 997805#64) →
          (hs9_5 : s9_5 = s9_4 + ((s8_3 + 1048576#64).sshiftRight 21)) →
          (hs8_4 : s8_4 = s8_3 - ((s8_3 + 1048576#64).sshiftRight 21) <<< 21) →
          (hbt139 : Bnd t139 (-2092547753555) 0) →
          (hbt141 : Bnd t141 (-1434243666051) 0) →
          (hbs7_1 : Bnd s7_1 0 1398053131244) →
          (hbs8_2 : Bnd s8_2 0 2384334857940) →
          (hbt148 : Bnd t148 0 286590364207) →
          (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647) →
          (hbs6_1 : Bnd s6_1 0 1398053131244) →
          (hbs7_2 : Bnd s7_2 0 2384334857940) →
          (hbs8_3 : Bnd s8_3 0 3756255390573) →
          (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) →
          (hbt167 : Bnd t167 (-1434243666051) 0) →
          (hbcarry6_1 : Bnd carry6_1 0 666644) →
          (hbs7_3 : Bnd s7_3 0 2384335524584) →
          (hbs6_2 : Bnd s6_2 (-1048576) 1048575) →
          (hbcarry8_1 : Bnd carry8_1 0 1791122) →
          (hbs9_4 : Bnd s9_4 (-2092547753555) 3756255390573) →
          (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) →
          (hbs8_4 : Bnd s8_4 (-1048576) 1048575) → (blk.runBodyFrom E' 182 S >>= g) = K) :
    (blk.runBodyFrom E 137 S >>= g) = K := by
  step_pure [nswMul, nuwMul]
  step_pure [nswMul, nuwMul]
  step_pure [nswMul] with t139
  bnd t139
  step_pure [nswMul, nuwMul]
  step_pure [nswMul] with t141
  bnd t141
  step_pure [nswMul, nuwMul]
  -- s7 += s19*666643L
  step_pure [nswAdd, nuwAdd] with s7_1
  bnd s7_1
  step_pure [nswMul, nuwMul]
  -- s8 += s19*470296L
  step_pure [nswAdd, nuwAdd] with s8_2
  bnd s8_2
  step_pure [nswMul, nuwMul]
  step_pure [nswMul]
  step_pure [nswMul, nuwMul] with t148
  bnd t148
  step_pure [nswMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  -- s12 -= s19*683901L
  step_pure [nswAdd] with s12_5
  bnd s12_5
  step_pure [nswMul, nuwMul]
  -- s6 += s18*666643L
  step_pure [nswAdd, nuwAdd] with s6_1
  bnd s6_1
  step_pure [nswMul, nuwMul]
  -- s7 += s18*470296L
  step_pure [nswAdd, nuwAdd] with s7_2
  bnd s7_2
  step_pure [nswMul, nuwMul]
  -- s8 += s18*654183L
  step_pure [nswAdd, nuwAdd] with s8_3
  bnd s8_3
  step_pure [nswMul]
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  -- s10 += s18*136657L
  step_pure [nswAdd] with s10_5
  bnd s10_5
  step_pure [nswMul] with t167
  bnd t167
  step_pure [nswAdd, nuwAdd]
  -- long carry6 = (s6 + (1L << 20)) >> 21
  step_pure with carry6_1
  bnd carry6_1
  -- s7 += carry6
  step_pure [nswAdd, nuwAdd] with s7_3
  bnd s7_3
  step_pure
  -- s6 -= (long)((ulong)carry6 << 21)
  step_pure [nswSub] with s6_2
  bnd s6_2
  step_pure [nswAdd, nuwAdd]
  -- long carry8 = (s8 + (1L << 20)) >> 21
  step_pure with carry8_1
  bnd carry8_1
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  -- s9 -= s18*997805L
  step_pure [nswAdd] with s9_4
  bnd s9_4
  -- s9 += carry8
  step_pure [nswAdd] with s9_5
  bnd s9_5
  step_pure
  -- s8 -= (long)((ulong)carry8 << 21)
  step_pure [nswSub] with s8_4
  bnd s8_4
  exact
    hK _ t139 t141 s7_1 s8_2 t148 s12_5 s6_1 s7_2 s8_3 s10_5 t167 carry6_1 s7_3 s6_2 carry8_1 s9_4
      s9_5 s8_4 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht139 ht141 (by bridge hs7_1) (by bridge hs8_2) ht148 (by bridge hs12_5)
      (by bridge hs6_1) (by bridge hs7_2) (by bridge hs8_3) (by bridge hs10_5) ht167
      (by bridge hcarry6_1) (by bridge hs7_3 hcarry6_1) (by bridge hs6_2) (by bridge hcarry8_1)
      (by bridge hs9_4) (by bridge hs9_5 hcarry8_1) (by bridge hs8_4) hbt139 hbt141 hbs7_1 hbs8_2
      hbt148 hbs12_5 hbs6_1 hbs7_2 hbs8_3 hbs10_5 hbt167 hbcarry6_1 hbs7_3 hbs6_2 hbcarry8_1 hbs9_4
      hbs9_5 hbs8_4

/-- From `%182`: `carry10 … carry16`. -/
theorem fd_curve25519_scalar_reduce.run182 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 182 = fd_curve25519_scalar_reduce.entry.body.drop 182)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s17 s11_1 s13_1 s16_1 t121 t123 s15_2 t130 t132 s14_3 t139 t141 t148 s12_5
      s10_5 t167 s7_3 s6_2 s9_5 s8_4 s18 s19 s20 s21 s22 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %72 := s5, %96 := s17, %109 :=
        s11_1, %113 := s13_1, %119 := s16_1, %121 := t121, %123 := t123, %127 := s15_2, %130 :=
        t130, %132 := t132, %134 := s14_3, %139 := t139, %141 := t141, %148 := t148, %153 := s12_5,
        %166 := s10_5, %167 := t167, %170 := s7_3, %172 := s6_2, %179 := s9_5, %181 := s8_4])
    (ht121 : t121 = (s22 * 470296#64)) (ht123 : t123 = (s22 * 18446744073708553811#64))
    (ht130 : t130 = (s21 * 654183#64)) (ht132 : t132 = (s21 * 136657#64))
    (ht139 : t139 = (s20 * 18446744073708553811#64))
    (ht141 : t141 = (s20 * 18446744073708867715#64)) (ht148 : t148 = (s19 * 136657#64))
    (ht167 : t167 = (s18 * 18446744073708867715#64)) (hbs17 : Bnd s17 0 2097151)
    (hbs18 : Bnd s18 0 2097151) (hbs19 : Bnd s19 0 2097151) (hbs20 : Bnd s20 0 2097151)
    (hbs21 : Bnd s21 0 2097151) (hbs22 : Bnd s22 0 2097151) (hbs11_1 : Bnd s11_1 0 357901236818924)
    (hbs13_1 : Bnd s13_1 0 351211825267864) (hbs16_1 : Bnd s16_1 (-367166552903811) 2097151)
    (hbs15_2 : Bnd s15_2 (-1434243666051) 73367170181678)
    (hbs14_3 : Bnd s14_3 (-537126723016406) 286592461358)
    (hbs12_5 : Bnd s12_5 (-3526791419606) 254146754953647)
    (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry10_1 s11_6 s11_7 t190 carry12_1 s13_4 s13_5 s12_6 carry14_1 s15_3 s14_4 carry16_1
          s17_1 s16_2 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %72 := s5, %166 := s10_5,
              %170 := s7_3, %172 := s6_2, %179 := s9_5, %181 := s8_4, %189 := s11_7, %190 := t190,
              %196 := s13_5, %198 := s12_6, %201 := s15_3, %203 := s14_4, %206 := s17_1, %208 :=
              s16_2]) →
          (hcarry10_1 : carry10_1 = (s10_5 + 1048576#64).sshiftRight 21) →
          (hs11_6 :
            s11_6 =
              ((((s11_1 + s22 * 470296#64) + s21 * 654183#64) - s20 * 997805#64) +
                  s19 * 136657#64) -
                s18 * 683901#64) →
          (hs11_7 : s11_7 = s11_6 + ((s10_5 + 1048576#64).sshiftRight 21)) →
          (ht190 : t190 = ((s10_5 + 1048576#64) &&& 18446744073707454464#64)) →
          (hcarry12_1 : carry12_1 = (s12_5 + 1048576#64).sshiftRight 21) →
          (hs13_4 : s13_4 = ((s13_1 - s22 * 997805#64) + s21 * 136657#64) - s20 * 683901#64) →
          (hs13_5 : s13_5 = s13_4 + ((s12_5 + 1048576#64).sshiftRight 21)) →
          (hs12_6 : s12_6 = s12_5 - ((s12_5 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry14_1 : carry14_1 = (s14_3 + 1048576#64).sshiftRight 21) →
          (hs15_3 : s15_3 = s15_2 + ((s14_3 + 1048576#64).sshiftRight 21)) →
          (hs14_4 : s14_4 = s14_3 - ((s14_3 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry16_1 : carry16_1 = (s16_1 + 1048576#64).sshiftRight 21) →
          (hs17_1 : s17_1 = s17 + ((s16_1 + 1048576#64).sshiftRight 21)) →
          (hs16_2 : s16_2 = s16_1 - ((s16_1 + 1048576#64).sshiftRight 21) <<< 21) →
          (hbcarry10_1 : Bnd carry10_1 (-997805) 1927779) →
          (hbs11_6 : Bnd s11_6 (-3526791419606) 360546029442460) →
          (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239) →
          (hbt190 : Bnd t190 (-2092548751360) 4042845585408) →
          (hbcarry12_1 : Bnd carry12_1 (-1681705) 121186616) →
          (hbs13_4 : Bnd s13_4 (-3526791419606) 351498415632071) →
          (hbs13_5 : Bnd s13_5 (-3526793101311) 351498536818687) →
          (hbs12_6 : Bnd s12_6 (-1048576) 1048575) →
          (hbcarry14_1 : Bnd carry14_1 (-256121980) 136658) →
          (hbs15_3 : Bnd s15_3 (-1434499788031) 73367170318336) →
          (hbs14_4 : Bnd s14_4 (-1048576) 1048575) →
          (hbcarry16_1 : Bnd carry16_1 (-175078656) 1) →
          (hbs17_1 : Bnd s17_1 (-175078656) 2097152) →
          (hbs16_2 : Bnd s16_2 (-1048576) 1048575) → (blk.runBodyFrom E' 209 S >>= g) = K) :
    (blk.runBodyFrom E 182 S >>= g) = K := by
  step_pure [nswAdd]
  -- long carry10 = (s10 + (1L << 20)) >> 21
  step_pure with carry10_1
  bnd carry10_1
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  -- s11 -= s18*683901L
  step_pure [nswAdd] with s11_6
  bnd s11_6
  -- s11 += carry10
  step_pure [nswAdd] with s11_7
  bnd s11_7
  step_pure with t190
  bnd t190
  step_pure [nswAdd]
  -- long carry12 = (s12 + (1L << 20)) >> 21
  step_pure with carry12_1
  bnd carry12_1
  step_pure [nswAdd]
  step_pure [nswAdd]
  -- s13 -= s20*683901L
  step_pure [nswAdd] with s13_4
  bnd s13_4
  -- s13 += carry12
  step_pure [nswAdd] with s13_5
  bnd s13_5
  step_pure
  -- s12 -= (long)((ulong)carry12 << 21)
  step_pure with s12_6
  bnd s12_6
  step_pure [nswAdd]
  -- long carry14 = (s14 + (1L << 20)) >> 21
  step_pure with carry14_1
  bnd carry14_1
  -- s15 += carry14
  step_pure [nswAdd] with s15_3
  bnd s15_3
  step_pure
  -- s14 -= (long)((ulong)carry14 << 21)
  step_pure with s14_4
  bnd s14_4
  step_pure [nswAdd]
  -- long carry16 = (s16 + (1L << 20)) >> 21
  step_pure with carry16_1
  bnd carry16_1
  -- s17 += carry16
  step_pure [nswAdd] with s17_1
  bnd s17_1
  step_pure
  -- s16 -= (long)((ulong)carry16 << 21)
  step_pure [nswSub] with s16_2
  bnd s16_2
  exact
    hK _ carry10_1 s11_6 s11_7 t190 carry12_1 s13_4 s13_5 s12_6 carry14_1 s15_3 s14_4 carry16_1
      s17_1 s16_2 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hcarry10_1) (by bridge hs11_6) (by bridge hs11_7 hcarry10_1) ht190
      (by bridge hcarry12_1) (by bridge hs13_4) (by bridge hs13_5 hcarry12_1) (by bridge hs12_6)
      (by bridge hcarry14_1) (by bridge hs15_3 hcarry14_1) (by bridge hs14_4) (by bridge hcarry16_1)
      (by bridge hs17_1 hcarry16_1) (by bridge hs16_2) hbcarry10_1 hbs11_6 hbs11_7 hbt190
      hbcarry12_1 hbs13_4 hbs13_5 hbs12_6 hbcarry14_1 hbs15_3 hbs14_4 hbcarry16_1 hbs17_1 hbs16_2

/-- From `%209`: `carry7 … carry15`, and the `s17` row begun. -/
theorem fd_curve25519_scalar_reduce.run209 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 209 = fd_curve25519_scalar_reduce.entry.body.drop 209)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s5 s10_5 s7_3 s6_2 s9_5 s8_4 s11_7 t190 s13_5 s12_6 s15_3 s14_4 s17_1 s16_2 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %72 := s5, %166 := s10_5, %170 :=
        s7_3, %172 := s6_2, %179 := s9_5, %181 := s8_4, %189 := s11_7, %190 := t190, %196 := s13_5,
        %198 := s12_6, %201 := s15_3, %203 := s14_4, %206 := s17_1, %208 := s16_2])
    (hbs5 : Bnd s5 0 2097151) (hbs7_3 : Bnd s7_3 0 2384335524584)
    (hbs6_2 : Bnd s6_2 (-1048576) 1048575) (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695)
    (hbs11_7 : Bnd s11_7 (-3526792417411) 360546031370239)
    (hbs13_5 : Bnd s13_5 (-3526793101311) 351498536818687) (hbs12_6 : Bnd s12_6 (-1048576) 1048575)
    (hbs15_3 : Bnd s15_3 (-1434499788031) 73367170318336) (hbs14_4 : Bnd s14_4 (-1048576) 1048575)
    (hbs17_1 : Bnd s17_1 (-175078656) 2097152) (hbs16_2 : Bnd s16_2 (-1048576) 1048575)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry7_1 t211 carry9_1 t214 carry11_1 s12_7 s11_8 carry13_1 s14_5 s13_6 carry15_1 s16_3
          s15_4 s5_1 s6_3 t234 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %166 := s10_5, %170 :=
              s7_3, %179 := s9_5, %181 := s8_4, %190 := t190, %206 := s17_1, %210 := carry7_1,
              %211 := t211, %213 := carry9_1, %214 := t214, %217 := s12_7, %219 := s11_8, %222 :=
              s14_5, %224 := s13_6, %227 := s16_3, %229 := s15_4, %231 := s5_1, %233 := s6_3,
              %234 := t234]) →
          (hcarry7_1 : carry7_1 = (s7_3 + 1048576#64).sshiftRight 21) →
          (ht211 : t211 = ((s7_3 + 1048576#64) &&& 9223372036852678656#64)) →
          (hcarry9_1 : carry9_1 = (s9_5 + 1048576#64).sshiftRight 21) →
          (ht214 : t214 = ((s9_5 + 1048576#64) &&& 18446744073707454464#64)) →
          (hcarry11_1 : carry11_1 = (s11_7 + 1048576#64).sshiftRight 21) →
          (hs12_7 : s12_7 = s12_6 + ((s11_7 + 1048576#64).sshiftRight 21)) →
          (hs11_8 : s11_8 = s11_7 - ((s11_7 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry13_1 : carry13_1 = (s13_5 + 1048576#64).sshiftRight 21) →
          (hs14_5 : s14_5 = s14_4 + ((s13_5 + 1048576#64).sshiftRight 21)) →
          (hs13_6 : s13_6 = s13_5 - ((s13_5 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry15_1 : carry15_1 = (s15_3 + 1048576#64).sshiftRight 21) →
          (hs16_3 : s16_3 = s16_2 + ((s15_3 + 1048576#64).sshiftRight 21)) →
          (hs15_4 : s15_4 = s15_3 - ((s15_3 + 1048576#64).sshiftRight 21) <<< 21) →
          (hs5_1 : s5_1 = s5 + s17_1 * 666643#64) →
          (hs6_3 : s6_3 = s6_2 + s17_1 * 470296#64) →
          (ht234 : t234 = (s17_1 * 654183#64)) →
          (hbcarry7_1 : Bnd carry7_1 0 1136940) →
          (hbt211 : Bnd t211 0 2384335994880) →
          (hbcarry9_1 : Bnd carry9_1 (-997805) 1791123) →
          (hbt214 : Bnd t214 (-2092548751360) 3756257181696) →
          (hbcarry11_1 : Bnd carry11_1 (-1681706) 171921745) →
          (hbs12_7 : Bnd s12_7 (-2730282) 172970320) →
          (hbs11_8 : Bnd s11_8 (-1048576) 1048575) →
          (hbcarry13_1 : Bnd carry13_1 (-1681706) 167607563) →
          (hbs14_5 : Bnd s14_5 (-2730282) 168656138) →
          (hbs13_6 : Bnd s13_6 (-1048576) 1048575) →
          (hbcarry15_1 : Bnd carry15_1 (-684023) 34984193) →
          (hbs16_3 : Bnd s16_3 (-1732599) 36032768) →
          (hbs15_4 : Bnd s15_4 (-1048576) 1048575) →
          (hbs5_1 : Bnd s5_1 (-116714960471808) 1398053797887) →
          (hbs6_3 : Bnd s6_3 (-82338792650752) 986283245567) →
          (hbt234 : Bnd t234 (-114533480418048) 1371921186816) →
          (blk.runBodyFrom E' 235 S >>= g) = K) :
    (blk.runBodyFrom E 209 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd]
  -- long carry7 = (s7 + (1L << 20)) >> 21
  step_pure with carry7_1
  bnd carry7_1
  step_pure with t211
  bnd t211
  step_pure [nswAdd]
  -- long carry9 = (s9 + (1L << 20)) >> 21
  step_pure with carry9_1
  bnd carry9_1
  step_pure with t214
  bnd t214
  step_pure [nswAdd]
  -- long carry11 = (s11 + (1L << 20)) >> 21
  step_pure with carry11_1
  bnd carry11_1
  -- s12 += carry11
  step_pure with s12_7
  bnd s12_7
  step_pure
  -- s11 -= (long)((ulong)carry11 << 21)
  step_pure with s11_8
  bnd s11_8
  step_pure [nswAdd]
  -- long carry13 = (s13 + (1L << 20)) >> 21
  step_pure with carry13_1
  bnd carry13_1
  -- s14 += carry13
  step_pure with s14_5
  bnd s14_5
  step_pure
  -- s13 -= (long)((ulong)carry13 << 21)
  step_pure with s13_6
  bnd s13_6
  step_pure [nswAdd]
  -- long carry15 = (s15 + (1L << 20)) >> 21
  step_pure with carry15_1
  bnd carry15_1
  -- s16 += carry15
  step_pure [nswAdd] with s16_3
  bnd s16_3
  step_pure
  -- s15 -= (long)((ulong)carry15 << 21)
  step_pure with s15_4
  bnd s15_4
  step_pure [nswMul]
  -- s5 += s17*666643L
  step_pure [nswAdd] with s5_1
  bnd s5_1
  step_pure [nswMul]
  -- s6 += s17*470296L
  step_pure [nswAdd] with s6_3
  bnd s6_3
  step_pure [nswMul] with t234
  bnd t234
  exact
    hK _ carry7_1 t211 carry9_1 t214 carry11_1 s12_7 s11_8 carry13_1 s14_5 s13_6 carry15_1 s16_3
      s15_4 s5_1 s6_3 t234 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hcarry7_1) ht211 (by bridge hcarry9_1) ht214 (by bridge hcarry11_1)
      (by bridge hs12_7 hcarry11_1) (by bridge hs11_8) (by bridge hcarry13_1)
      (by bridge hs14_5 hcarry13_1) (by bridge hs13_6) (by bridge hcarry15_1)
      (by bridge hs16_3 hcarry15_1) (by bridge hs15_4) (by bridge hs5_1) (by bridge hs6_3) ht234
      hbcarry7_1 hbt211 hbcarry9_1 hbt214 hbcarry11_1 hbs12_7 hbs11_8 hbcarry13_1 hbs14_5 hbs13_6
      hbcarry15_1 hbs16_3 hbs15_4 hbs5_1 hbs6_3 hbt234

/-- From `%235`: the rows of `s17 … s14` into `s2 … s10`. -/
theorem fd_curve25519_scalar_reduce.run235 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 235 = fd_curve25519_scalar_reduce.entry.body.drop 235)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s3 s4 s10_5 s7_3 s9_5 s8_4 t190 s17_1 carry7_1 t211 carry9_1 t214 s12_7 s11_8 s14_5
      s13_6 s16_3 s15_4 s5_1 s6_3 t234 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%62 := s0, %64 := s1, %66 := s2, %68 := s3, %70 := s4, %166 := s10_5, %170 := s7_3,
        %179 := s9_5, %181 := s8_4, %190 := t190, %206 := s17_1, %210 := carry7_1, %211 := t211,
        %213 := carry9_1, %214 := t214, %217 := s12_7, %219 := s11_8, %222 := s14_5, %224 := s13_6,
        %227 := s16_3, %229 := s15_4, %231 := s5_1, %233 := s6_3, %234 := t234])
    (ht190 : t190 = ((s10_5 + 1048576#64) &&& 18446744073707454464#64))
    (hcarry7_1 : carry7_1 = (s7_3 + 1048576#64).sshiftRight 21)
    (hcarry9_1 : carry9_1 = (s9_5 + 1048576#64).sshiftRight 21) (hbs2 : Bnd s2 0 2097151)
    (hbs3 : Bnd s3 0 2097151) (hbs4 : Bnd s4 0 2097151)
    (hbs10_5 : Bnd s10_5 (-2092547753555) 4042845754780) (hbs7_3 : Bnd s7_3 0 2384335524584)
    (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) (hbs8_4 : Bnd s8_4 (-1048576) 1048575)
    (hbs17_1 : Bnd s17_1 (-175078656) 2097152) (hbs14_5 : Bnd s14_5 (-2730282) 168656138)
    (hbs16_3 : Bnd s16_3 (-1732599) 36032768) (hbs15_4 : Bnd s15_4 (-1048576) 1048575)
    (hbs5_1 : Bnd s5_1 (-116714960471808) 1398053797887)
    (hbs6_3 : Bnd s6_3 (-82338792650752) 986283245567)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t236 s10_8 s4_1 s5_2 s6_4 t247 t249 s3_1 s4_2 s5_3 s6_5 t258 s8_6 s8_7 s8_8 s2_1 s3_2
          s4_3 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%62 := s0, %64 := s1, %170 := s7_3, %179 := s9_5, %211 := t211, %214 := t214,
              %217 := s12_7, %219 := s11_8, %222 := s14_5, %224 := s13_6, %234 := t234, %236 :=
              t236, %240 := s10_8, %247 := t247, %249 := t249, %255 := s5_3, %257 := s6_5, %258 :=
              t258, %263 := s8_8, %265 := s2_1, %267 := s3_2, %269 := s4_3]) →
          (ht236 : t236 = (s17_1 * 136657#64)) →
          (hs10_8 :
            s10_8 =
              ((s10_5 - ((s10_5 + 1048576#64).sshiftRight 21) <<< 21) +
                  ((s9_5 + 1048576#64).sshiftRight 21)) -
                s17_1 * 683901#64) →
          (hs4_1 : s4_1 = s4 + s16_3 * 666643#64) →
          (hs5_2 : s5_2 = s5_1 + s16_3 * 470296#64) →
          (hs6_4 : s6_4 = s6_3 + s16_3 * 654183#64) →
          (ht247 : t247 = (s16_3 * 18446744073708553811#64)) →
          (ht249 : t249 = (s16_3 * 18446744073708867715#64)) →
          (hs3_1 : s3_1 = s3 + s15_4 * 666643#64) →
          (hs4_2 : s4_2 = s4_1 + s15_4 * 470296#64) →
          (hs5_3 : s5_3 = s5_2 + s15_4 * 654183#64) →
          (hs6_5 : s6_5 = s6_4 - s15_4 * 997805#64) →
          (ht258 : t258 = (s15_4 * 136657#64)) →
          (hs8_6 : s8_6 = (s8_4 + ((s7_3 + 1048576#64).sshiftRight 21)) - s17_1 * 997805#64) →
          (hs8_7 : s8_7 = s8_6 + s16_3 * 136657#64) →
          (hs8_8 : s8_8 = s8_7 - s15_4 * 683901#64) →
          (hs2_1 : s2_1 = s2 + s14_5 * 666643#64) →
          (hs3_2 : s3_2 = s3_1 + s14_5 * 470296#64) →
          (hs4_3 : s4_3 = s4_2 + s14_5 * 654183#64) →
          (hbt236 : Bnd t236 (-23925723892992) 286590500864) →
          (hbs10_8 : Bnd s10_8 (-1434246396333) 119736470756754) →
          (hbs4_1 : Bnd s4_1 (-1155024995157) 24020994654975) →
          (hbs5_2 : Bnd s5_2 (-117529794851112) 18344120457215) →
          (hbs6_4 : Bnd s6_4 (-83472229462369) 24558307514111) →
          (hbt247 : Bnd t247 (-35953676074240) 1728795945195) →
          (hbt249 : Bnd t249 (-24642846067968) 1184926188699) →
          (hbs3_1 : Bnd s3_1 (-699025850368) 699027280876) →
          (hbs4_2 : Bnd s4_2 (-1648166093653) 24514135283175) →
          (hbs5_3 : Bnd s5_3 (-118215755444520) 19030080396440) →
          (hbs6_5 : Bnd s6_5 (-84518502840244) 25604581889791) →
          (hbt258 : Bnd t258 (-143295250432) 143295113775) →
          (hbs8_6 : Bnd s8_6 (-2092549799936) 174694360535595) →
          (hbs8_7 : Bnd s8_7 (-2329321581479) 179618490512171) →
          (hbs8_8 : Bnd s8_8 (-3046443072554) 180335612687147) →
          (hbs2_1 : Bnd s2_1 (-1820123383326) 112433435901885) →
          (hbs3_2 : Bnd s3_2 (-1983066553840) 80017334357724) →
          (hbs4_3 : Bnd s4_3 (-3434270163259) 134846113608429) →
          (blk.runBodyFrom E' 270 S >>= g) = K) :
    (blk.runBodyFrom E 235 S >>= g) = K := by
  step_pure [nswMul]
  step_pure [nswMul] with t236
  bnd t236
  step_pure [nswMul]
  step_pure [nswAdd]
  step_pure
  -- s10 -= s17*683901L
  step_pure with s10_8
  bnd s10_8
  step_pure
  -- s4 += s16*666643L
  step_pure with s4_1
  bnd s4_1
  step_pure
  -- s5 += s16*470296L
  step_pure with s5_2
  bnd s5_2
  step_pure
  -- s6 += s16*654183L
  step_pure with s6_4
  bnd s6_4
  step_pure with t247
  bnd t247
  step_pure
  step_pure with t249
  bnd t249
  step_pure
  -- s3 += s15*666643L
  step_pure with s3_1
  bnd s3_1
  step_pure
  -- s4 += s15*470296L
  step_pure with s4_2
  bnd s4_2
  step_pure
  -- s5 += s15*654183L
  step_pure with s5_3
  bnd s5_3
  step_pure
  -- s6 -= s15*997805L
  step_pure with s6_5
  bnd s6_5
  step_pure with t258
  bnd t258
  step_pure
  step_pure [nswAdd]
  -- s8 -= s17*997805L
  step_pure [nswAdd] with s8_6
  bnd s8_6
  -- s8 += s16*136657L
  step_pure with s8_7
  bnd s8_7
  -- s8 -= s15*683901L
  step_pure with s8_8
  bnd s8_8
  step_pure
  -- s2 += s14*666643L
  step_pure with s2_1
  bnd s2_1
  step_pure
  -- s3 += s14*470296L
  step_pure with s3_2
  bnd s3_2
  step_pure
  -- s4 += s14*654183L
  step_pure with s4_3
  bnd s4_3
  exact
    hK _ t236 s10_8 s4_1 s5_2 s6_4 t247 t249 s3_1 s4_2 s5_3 s6_5 t258 s8_6 s8_7 s8_8 s2_1 s3_2 s4_3
      hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) ht236 (by bridge hs10_8) (by bridge hs4_1) (by bridge hs5_2) (by bridge hs6_4)
      ht247 ht249 (by bridge hs3_1) (by bridge hs4_2) (by bridge hs5_3) (by bridge hs6_5) ht258
      (by bridge hs8_6) (by bridge hs8_7) (by bridge hs8_8) (by bridge hs2_1) (by bridge hs3_2)
      (by bridge hs4_3) hbt236 hbs10_8 hbs4_1 hbs5_2 hbs6_4 hbt247 hbt249 hbs3_1 hbs4_2 hbs5_3
      hbs6_5 hbt258 hbs8_6 hbs8_7 hbs8_8 hbs2_1 hbs3_2 hbs4_3

/-- From `%270`: the rows of `s13` and `s12`, and `carry0`. -/
theorem fd_curve25519_scalar_reduce.run270 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 270 = fd_curve25519_scalar_reduce.entry.body.drop 270)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s7_3 s9_5 t211 t214 s12_7 s11_8 s14_5 s13_6 t234 t236 s10_8 t247 t249 s5_3 s6_5 t258 s8_8
      s2_1 s3_2 s4_3 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%62 := s0, %64 := s1, %170 := s7_3, %179 := s9_5, %211 := t211, %214 := t214, %217 :=
        s12_7, %219 := s11_8, %222 := s14_5, %224 := s13_6, %234 := t234, %236 := t236, %240 :=
        s10_8, %247 := t247, %249 := t249, %255 := s5_3, %257 := s6_5, %258 := t258, %263 := s8_8,
        %265 := s2_1, %267 := s3_2, %269 := s4_3])
    (hbs0 : Bnd s0 0 2097151) (hbs1 : Bnd s1 0 2097151) (hbs12_7 : Bnd s12_7 (-2730282) 172970320)
    (hbs14_5 : Bnd s14_5 (-2730282) 168656138) (hbs13_6 : Bnd s13_6 (-1048576) 1048575)
    (hbs5_3 : Bnd s5_3 (-118215755444520) 19030080396440)
    (hbs6_5 : Bnd s6_5 (-84518502840244) 25604581889791)
    (hbs2_1 : Bnd s2_1 (-1820123383326) 112433435901885)
    (hbs3_2 : Bnd s3_2 (-1983066553840) 80017334357724)
    (hbs4_3 : Bnd s4_3 (-3434270163259) 134846113608429)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s5_4 s6_6 t274 s1_1 s2_2 s3_3 s4_4 s5_5 s6_7 s0_1 s1_2 s2_3 s3_4 s4_5 s5_6 carry0_1 s1_3
          s0_2 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%170 := s7_3, %179 := s9_5, %211 := t211, %214 := t214, %219 := s11_8, %234 :=
              t234, %236 := t236, %240 := s10_8, %247 := t247, %249 := t249, %258 := t258, %263 :=
              s8_8, %274 := t274, %286 := s6_7, %292 := s2_3, %294 := s3_4, %296 := s4_5, %298 :=
              s5_6, %301 := s1_3, %303 := s0_2]) →
          (hs5_4 : s5_4 = s5_3 - s14_5 * 997805#64) →
          (hs6_6 : s6_6 = s6_5 + s14_5 * 136657#64) →
          (ht274 : t274 = (s14_5 * 18446744073708867715#64)) →
          (hs1_1 : s1_1 = s1 + s13_6 * 666643#64) →
          (hs2_2 : s2_2 = s2_1 + s13_6 * 470296#64) →
          (hs3_3 : s3_3 = s3_2 + s13_6 * 654183#64) →
          (hs4_4 : s4_4 = s4_3 - s13_6 * 997805#64) →
          (hs5_5 : s5_5 = s5_4 + s13_6 * 136657#64) →
          (hs6_7 : s6_7 = s6_6 - s13_6 * 683901#64) →
          (hs0_1 : s0_1 = s0 + s12_7 * 666643#64) →
          (hs1_2 : s1_2 = s1_1 + s12_7 * 470296#64) →
          (hs2_3 : s2_3 = s2_2 + s12_7 * 654183#64) →
          (hs3_4 : s3_4 = s3_3 - s12_7 * 997805#64) →
          (hs4_5 : s4_5 = s4_4 + s12_7 * 136657#64) →
          (hs5_6 : s5_6 = s5_5 - s12_7 * 683901#64) →
          (hcarry0_1 : carry0_1 = (s0_1 + 1048576#64).sshiftRight 21) →
          (hs1_3 : s1_3 = s1_2 + ((s0_1 + 1048576#64).sshiftRight 21)) →
          (hs0_2 : s0_2 = s0_1 - ((s0_1 + 1048576#64).sshiftRight 21) <<< 21) →
          (hbs5_4 : Bnd s5_4 (-286501693221610) 21754369427450) →
          (hbs6_6 : Bnd s6_6 (-84891614987518) 48652623740457) →
          (hbt274 : Bnd t274 (-115344101434338) 1867242590082) →
          (hbs1_1 : Bnd s1_1 (-699025850368) 699027280876) →
          (hbs2_2 : Bnd s2_2 (-2313264481822) 112926576530085) →
          (hbs3_3 : Bnd s3_3 (-2669027147248) 80703294296949) →
          (hbs4_4 : Bnd s4_4 (-4480543541134) 135892387984109) →
          (hbs5_5 : Bnd s5_5 (-286644988472042) 21897664541225) →
          (hbs6_7 : Bnd s6_7 (-85608736478593) 49369745915433) →
          (hbs0_1 : Bnd s0_1 (-1820123383326) 115309455132911) →
          (hbs1_2 : Bnd s1_2 (-1983066553840) 82046276895596) →
          (hbs2_3 : Bnd s2_3 (-4099368551428) 226080819378645) →
          (hbs3_4 : Bnd s3_4 (-175259677294848) 83427583327959) →
          (hbs4_5 : Bnd s4_5 (-4853655688408) 159529993004349) →
          (hbs5_6 : Bnd s5_6 (-404939563290362) 23764907131307) →
          (hbcarry0_1 : Bnd carry0_1 (-867902) 54983833) →
          (hbs1_3 : Bnd s1_3 (-1983067421742) 82046331879429) →
          (hbs0_2 : Bnd s0_2 (-1048576) 1048575) → (blk.runBodyFrom E' 304 S >>= g) = K) :
    (blk.runBodyFrom E 270 S >>= g) = K := by
  step_pure
  -- s5 -= s14*997805L
  step_pure with s5_4
  bnd s5_4
  step_pure
  -- s6 += s14*136657L
  step_pure with s6_6
  bnd s6_6
  step_pure with t274
  bnd t274
  step_pure
  -- s1 += s13*666643L
  step_pure with s1_1
  bnd s1_1
  step_pure
  -- s2 += s13*470296L
  step_pure with s2_2
  bnd s2_2
  step_pure
  -- s3 += s13*654183L
  step_pure with s3_3
  bnd s3_3
  step_pure
  -- s4 -= s13*997805L
  step_pure with s4_4
  bnd s4_4
  step_pure
  -- s5 += s13*136657L
  step_pure with s5_5
  bnd s5_5
  step_pure
  -- s6 -= s13*683901L
  step_pure with s6_7
  bnd s6_7
  step_pure
  -- s0 += s12*666643L
  step_pure with s0_1
  bnd s0_1
  step_pure
  -- s1 += s12*470296L
  step_pure with s1_2
  bnd s1_2
  step_pure
  -- s2 += s12*654183L
  step_pure with s2_3
  bnd s2_3
  step_pure
  -- s3 -= s12*997805L
  step_pure with s3_4
  bnd s3_4
  step_pure
  -- s4 += s12*136657L
  step_pure with s4_5
  bnd s4_5
  step_pure
  -- s5 -= s12*683901L
  step_pure with s5_6
  bnd s5_6
  step_pure
  -- long carry0 = (s0 + (1L << 20)) >> 21
  step_pure with carry0_1
  bnd carry0_1
  -- s1 += carry0
  step_pure with s1_3
  bnd s1_3
  step_pure
  -- s0 -= (long)((ulong)carry0 << 21)
  step_pure with s0_2
  bnd s0_2
  exact
    hK _ s5_4 s6_6 t274 s1_1 s2_2 s3_3 s4_4 s5_5 s6_7 s0_1 s1_2 s2_3 s3_4 s4_5 s5_6 carry0_1 s1_3
      s0_2 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hs5_4) (by bridge hs6_6) ht274 (by bridge hs1_1) (by bridge hs2_2)
      (by bridge hs3_3) (by bridge hs4_4) (by bridge hs5_5) (by bridge hs6_7) (by bridge hs0_1)
      (by bridge hs1_2) (by bridge hs2_3) (by bridge hs3_4) (by bridge hs4_5) (by bridge hs5_6)
      (by bridge hcarry0_1) (by bridge hs1_3 hcarry0_1) (by bridge hs0_2) hbs5_4 hbs6_6 hbt274
      hbs1_1 hbs2_2 hbs3_3 hbs4_4 hbs5_5 hbs6_7 hbs0_1 hbs1_2 hbs2_3 hbs3_4 hbs4_5 hbs5_6 hbcarry0_1
      hbs1_3 hbs0_2

/-- From `%304`: `carry2 … carry10`. -/
theorem fd_curve25519_scalar_reduce.run304 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 304 = fd_curve25519_scalar_reduce.entry.body.drop 304)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s7_3 s9_5 t211 t214 s11_8 t234 t236 s10_8 t247 t249 t258 s8_8 t274 s6_7 s2_3 s3_4 s4_5 s5_6
      s1_3 s0_2 s17_1 s14_5 s16_3 s15_4 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%170 := s7_3, %179 := s9_5, %211 := t211, %214 := t214, %219 := s11_8, %234 := t234,
        %236 := t236, %240 := s10_8, %247 := t247, %249 := t249, %258 := t258, %263 := s8_8, %274 :=
        t274, %286 := s6_7, %292 := s2_3, %294 := s3_4, %296 := s4_5, %298 := s5_6, %301 := s1_3,
        %303 := s0_2])
    (ht211 : t211 = ((s7_3 + 1048576#64) &&& 9223372036852678656#64))
    (ht214 : t214 = ((s9_5 + 1048576#64) &&& 18446744073707454464#64))
    (ht234 : t234 = (s17_1 * 654183#64)) (ht236 : t236 = (s17_1 * 136657#64))
    (ht247 : t247 = (s16_3 * 18446744073708553811#64))
    (ht249 : t249 = (s16_3 * 18446744073708867715#64)) (ht258 : t258 = (s15_4 * 136657#64))
    (ht274 : t274 = (s14_5 * 18446744073708867715#64)) (hbs7_3 : Bnd s7_3 0 2384335524584)
    (hbs9_5 : Bnd s9_5 (-2092547753555) 3756257181695) (hbs17_1 : Bnd s17_1 (-175078656) 2097152)
    (hbs11_8 : Bnd s11_8 (-1048576) 1048575) (hbs14_5 : Bnd s14_5 (-2730282) 168656138)
    (hbs16_3 : Bnd s16_3 (-1732599) 36032768) (hbs15_4 : Bnd s15_4 (-1048576) 1048575)
    (hbs10_8 : Bnd s10_8 (-1434246396333) 119736470756754)
    (hbs8_8 : Bnd s8_8 (-3046443072554) 180335612687147)
    (hbs6_7 : Bnd s6_7 (-85608736478593) 49369745915433)
    (hbs2_3 : Bnd s2_3 (-4099368551428) 226080819378645)
    (hbs3_4 : Bnd s3_4 (-175259677294848) 83427583327959)
    (hbs4_5 : Bnd s4_5 (-4853655688408) 159529993004349)
    (hbs5_6 : Bnd s5_6 (-404939563290362) 23764907131307)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry2_1 s3_5 s2_4 carry4_1 s5_7 s4_6 carry6_2 s7_5 s7_6 s7_7 s7_8 s7_9 s6_8 carry8_2 s9_7
          s9_8 s9_9 s8_9 carry10_2 s11_9 s10_9 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%301 := s1_3, %303 := s0_2, %306 := s3_5, %308 := s2_4, %311 := s5_7, %313 :=
              s4_6, %321 := s7_9, %323 := s6_8, %329 := s9_9, %331 := s8_9, %334 := s11_9, %336 :=
              s10_9]) →
          (hcarry2_1 : carry2_1 = (s2_3 + 1048576#64).sshiftRight 21) →
          (hs3_5 : s3_5 = s3_4 + ((s2_3 + 1048576#64).sshiftRight 21)) →
          (hs2_4 : s2_4 = s2_3 - ((s2_3 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry4_1 : carry4_1 = (s4_5 + 1048576#64).sshiftRight 21) →
          (hs5_7 : s5_7 = s5_6 + ((s4_5 + 1048576#64).sshiftRight 21)) →
          (hs4_6 : s4_6 = s4_5 - ((s4_5 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry6_2 : carry6_2 = (s6_7 + 1048576#64).sshiftRight 21) →
          (hs7_5 :
            s7_5 = (s7_3 - ((s7_3 + 1048576#64).sshiftRight 21) <<< 21) + s17_1 * 654183#64) →
          (hs7_6 : s7_6 = s7_5 - s16_3 * 997805#64) →
          (hs7_7 : s7_7 = s7_6 + s15_4 * 136657#64) →
          (hs7_8 : s7_8 = s7_7 - s14_5 * 683901#64) →
          (hs7_9 : s7_9 = s7_8 + ((s6_7 + 1048576#64).sshiftRight 21)) →
          (hs6_8 : s6_8 = s6_7 - ((s6_7 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry8_2 : carry8_2 = (s8_8 + 1048576#64).sshiftRight 21) →
          (hs9_7 :
            s9_7 = (s9_5 - ((s9_5 + 1048576#64).sshiftRight 21) <<< 21) + s17_1 * 136657#64) →
          (hs9_8 : s9_8 = s9_7 - s16_3 * 683901#64) →
          (hs9_9 : s9_9 = s9_8 + ((s8_8 + 1048576#64).sshiftRight 21)) →
          (hs8_9 : s8_9 = s8_8 - ((s8_8 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry10_2 : carry10_2 = (s10_8 + 1048576#64).sshiftRight 21) →
          (hs11_9 : s11_9 = s11_8 + ((s10_8 + 1048576#64).sshiftRight 21)) →
          (hs10_9 : s10_9 = s10_8 - ((s10_8 + 1048576#64).sshiftRight 21) <<< 21) →
          (hbcarry2_1 : Bnd carry2_1 (-1954731) 107803735) →
          (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694) →
          (hbs2_4 : Bnd s2_4 (-1048576) 1048575) →
          (hbcarry4_1 : Bnd carry4_1 (-2314403) 76069829) →
          (hbs5_7 : Bnd s5_7 (-404939565604765) 23764983201136) →
          (hbs4_6 : Bnd s4_6 (-1048576) 1048575) →
          (hbcarry6_2 : Bnd carry6_2 (-40821427) 23541329) →
          (hbs7_5 : Bnd s7_5 (-114533481466624) 1371922235391) →
          (hbs7_6 : Bnd s7_6 (-150487157540864) 3100718180586) →
          (hbs7_7 : Bnd s7_7 (-150630452791296) 3244013294361) →
          (hbs7_8 : Bnd s7_8 (-265974554225634) 5111255884443) →
          (hbs7_9 : Bnd s7_9 (-265974595047061) 5111279425772) →
          (hbs6_8 : Bnd s6_8 (-1048576) 1048575) →
          (hbcarry8_2 : Bnd carry8_2 (-1452657) 85990721) →
          (hbs9_7 : Bnd s9_7 (-23925724941568) 286591549439) →
          (hbs9_8 : Bnd s9_8 (-48568571009536) 1471517738138) →
          (hbs9_9 : Bnd s9_9 (-48568572462193) 1471603728859) →
          (hbs8_9 : Bnd s8_9 (-1048576) 1048575) →
          (hbcarry10_2 : Bnd carry10_2 (-683902) 57094798) →
          (hbs11_9 : Bnd s11_9 (-1732478) 58143373) →
          (hbs10_9 : Bnd s10_9 (-1048576) 1048575) → (blk.runBodyFrom E' 337 S >>= g) = K) :
    (blk.runBodyFrom E 304 S >>= g) = K := by
  step_pure
  -- long carry2 = (s2 + (1L << 20)) >> 21
  step_pure with carry2_1
  bnd carry2_1
  -- s3 += carry2
  step_pure with s3_5
  bnd s3_5
  step_pure
  -- s2 -= (long)((ulong)carry2 << 21)
  step_pure with s2_4
  bnd s2_4
  step_pure
  -- long carry4 = (s4 + (1L << 20)) >> 21
  step_pure with carry4_1
  bnd carry4_1
  -- s5 += carry4
  step_pure with s5_7
  bnd s5_7
  step_pure
  -- s4 -= (long)((ulong)carry4 << 21)
  step_pure with s4_6
  bnd s4_6
  step_pure
  -- carry6 = (s6 + (1L << 20)) >> 21
  step_pure with carry6_2
  bnd carry6_2
  step_pure [nswAdd]
  -- s7 += s17*654183L
  step_pure [nswSub] with s7_5
  bnd s7_5
  -- s7 -= s16*997805L
  step_pure with s7_6
  bnd s7_6
  -- s7 += s15*136657L
  step_pure with s7_7
  bnd s7_7
  -- s7 -= s14*683901L
  step_pure with s7_8
  bnd s7_8
  -- s7 += carry6
  step_pure with s7_9
  bnd s7_9
  step_pure
  -- s6 -= (long)((ulong)carry6 << 21)
  step_pure with s6_8
  bnd s6_8
  step_pure
  -- carry8 = (s8 + (1L << 20)) >> 21
  step_pure with carry8_2
  bnd carry8_2
  step_pure [nswAdd]
  -- s9 += s17*136657L
  step_pure with s9_7
  bnd s9_7
  -- s9 -= s16*683901L
  step_pure with s9_8
  bnd s9_8
  -- s9 += carry8
  step_pure with s9_9
  bnd s9_9
  step_pure
  -- s8 -= (long)((ulong)carry8 << 21)
  step_pure with s8_9
  bnd s8_9
  step_pure
  -- carry10 = (s10 + (1L << 20)) >> 21
  step_pure with carry10_2
  bnd carry10_2
  -- s11 += carry10
  step_pure with s11_9
  bnd s11_9
  step_pure
  -- s10 -= (long)((ulong)carry10 << 21)
  step_pure with s10_9
  bnd s10_9
  exact
    hK _ carry2_1 s3_5 s2_4 carry4_1 s5_7 s4_6 carry6_2 s7_5 s7_6 s7_7 s7_8 s7_9 s6_8 carry8_2 s9_7
      s9_8 s9_9 s8_9 carry10_2 s11_9 s10_9 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hcarry2_1) (by bridge hs3_5 hcarry2_1) (by bridge hs2_4)
      (by bridge hcarry4_1) (by bridge hs5_7 hcarry4_1) (by bridge hs4_6) (by bridge hcarry6_2)
      (by bridge hs7_5) (by bridge hs7_6) (by bridge hs7_7) (by bridge hs7_8)
      (by bridge hs7_9 hcarry6_2) (by bridge hs6_8) (by bridge hcarry8_2) (by bridge hs9_7)
      (by bridge hs9_8) (by bridge hs9_9 hcarry8_2) (by bridge hs8_9) (by bridge hcarry10_2)
      (by bridge hs11_9 hcarry10_2) (by bridge hs10_9) hbcarry2_1 hbs3_5 hbs2_4 hbcarry4_1 hbs5_7
      hbs4_6 hbcarry6_2 hbs7_5 hbs7_6 hbs7_7 hbs7_8 hbs7_9 hbs6_8 hbcarry8_2 hbs9_7 hbs9_8 hbs9_9
      hbs8_9 hbcarry10_2 hbs11_9 hbs10_9

/-- From `%337`: `carry1 … carry11`, the `s12` row, and the unrounded carries begun. -/
theorem fd_curve25519_scalar_reduce.run337 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 337 = fd_curve25519_scalar_reduce.entry.body.drop 337)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s1_3 s0_2 s3_5 s2_4 s5_7 s4_6 s7_9 s6_8 s9_9 s8_9 s11_9 s10_9 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%301 := s1_3, %303 := s0_2, %306 := s3_5, %308 := s2_4, %311 := s5_7, %313 := s4_6,
        %321 := s7_9, %323 := s6_8, %329 := s9_9, %331 := s8_9, %334 := s11_9, %336 := s10_9])
    (hbs1_3 : Bnd s1_3 (-1983067421742) 82046331879429) (hbs0_2 : Bnd s0_2 (-1048576) 1048575)
    (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694) (hbs2_4 : Bnd s2_4 (-1048576) 1048575)
    (hbs5_7 : Bnd s5_7 (-404939565604765) 23764983201136)
    (hbs7_9 : Bnd s7_9 (-265974595047061) 5111279425772) (hbs6_8 : Bnd s6_8 (-1048576) 1048575)
    (hbs9_9 : Bnd s9_9 (-48568572462193) 1471603728859) (hbs8_9 : Bnd s8_9 (-1048576) 1048575)
    (hbs11_9 : Bnd s11_9 (-1732478) 58143373) (hbs10_9 : Bnd s10_9 (-1048576) 1048575)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry1_1 carry3_1 carry5_1 s6_9 t346 carry7_2 s8_10 s7_10 carry9_2 s10_10 s9_10 carry11_2
          s11_10 s0_3 t366 t367 carry0_2 s1_5 s1_6 s0_4 carry1_2 s2_6 s2_7 s1_7 carry2_2 s3_7 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%311 := s5_7, %313 := s4_6, %341 := carry3_1, %345 := s6_9, %346 := t346, %349 :=
              s8_10, %351 := s7_10, %354 := s10_10, %356 := s9_10, %360 := s11_10, %366 := t366,
              %367 := t367, %372 := s0_4, %376 := s2_7, %377 := s1_7, %378 := carry2_2, %380 :=
              s3_7]) →
          (hcarry1_1 : carry1_1 = (s1_3 + 1048576#64).sshiftRight 21) →
          (hcarry3_1 : carry3_1 = (s3_5 + 1048576#64).sshiftRight 21) →
          (hcarry5_1 : carry5_1 = (s5_7 + 1048576#64).sshiftRight 21) →
          (hs6_9 : s6_9 = s6_8 + ((s5_7 + 1048576#64).sshiftRight 21)) →
          (ht346 : t346 = ((s5_7 + 1048576#64) &&& 18446744073707454464#64)) →
          (hcarry7_2 : carry7_2 = (s7_9 + 1048576#64).sshiftRight 21) →
          (hs8_10 : s8_10 = s8_9 + ((s7_9 + 1048576#64).sshiftRight 21)) →
          (hs7_10 : s7_10 = s7_9 - ((s7_9 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry9_2 : carry9_2 = (s9_9 + 1048576#64).sshiftRight 21) →
          (hs10_10 : s10_10 = s10_9 + ((s9_9 + 1048576#64).sshiftRight 21)) →
          (hs9_10 : s9_10 = s9_9 - ((s9_9 + 1048576#64).sshiftRight 21) <<< 21) →
          (hcarry11_2 : carry11_2 = (s11_9 + 1048576#64).sshiftRight 21) →
          (hs11_10 : s11_10 = s11_9 - ((s11_9 + 1048576#64).sshiftRight 21) <<< 21) →
          (hs0_3 : s0_3 = s0_2 + ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 666643#64) →
          (ht366 : t366 = (carry11_2 * 136657#64)) →
          (ht367 : t367 = (carry11_2 * 18446744073708867715#64)) →
          (hcarry0_2 : carry0_2 = s0_3.sshiftRight 21) →
          (hs1_5 :
            s1_5 =
              (s1_3 - ((s1_3 + 1048576#64).sshiftRight 21) <<< 21) +
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 470296#64) →
          (hs1_6 : s1_6 = s1_5 + (s0_3.sshiftRight 21)) →
          (hs0_4 : s0_4 = s0_3 - (s0_3.sshiftRight 21) <<< 21) →
          (hcarry1_2 : carry1_2 = s1_6.sshiftRight 21) →
          (hs2_6 :
            s2_6 =
              (s2_4 + ((s1_3 + 1048576#64).sshiftRight 21)) +
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 654183#64) →
          (hs2_7 : s2_7 = s2_6 + (s1_6.sshiftRight 21)) →
          (hs1_7 : s1_7 = s1_6 - (s1_6.sshiftRight 21) <<< 21) →
          (hcarry2_2 : carry2_2 = s2_7.sshiftRight 21) →
          (hs3_7 :
            s3_7 =
              (s3_5 - ((s3_5 + 1048576#64).sshiftRight 21) <<< 21) -
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 997805#64) →
          (hbcarry1_1 : Bnd carry1_1 (-945600) 39122740) →
          (hbcarry3_1 : Bnd carry3_1 (-83570327) 39781423) →
          (hbcarry5_1 : Bnd carry5_1 (-193090232) 11332027) →
          (hbs6_9 : Bnd s6_9 (-194138808) 12380602) →
          (hbt346 : Bnd t346 (-404939566219264) 23764983087104) →
          (hbcarry7_2 : Bnd carry7_2 (-126826570) 2437248) →
          (hbs8_10 : Bnd s8_10 (-127875146) 3485823) →
          (hbs7_10 : Bnd s7_10 (-1048576) 1048575) →
          (hbcarry9_2 : Bnd carry9_2 (-23159300) 701715) →
          (hbs10_10 : Bnd s10_10 (-24207876) 1750290) →
          (hbs9_10 : Bnd s9_10 (-1048576) 1048575) →
          (hbcarry11_2 : Bnd carry11_2 (-1) 28) →
          (hbs11_10 : Bnd s11_10 (-1048576) 1048575) →
          (hbs0_3 : Bnd s0_3 (-1715219) 19714579) →
          (hbt366 : Bnd t366 (-136657) 3826396) →
          (hbt367 : Bnd t367 (-19149228) 683901) →
          (hbcarry0_2 : Bnd carry0_2 (-1) 9) →
          (hbs1_5 : Bnd s1_5 (-1518872) 14216863) →
          (hbs1_6 : Bnd s1_6 (-1518873) 14216872) →
          (hbs0_4 : Bnd s0_4 0 2097151) →
          (hbcarry1_2 : Bnd carry1_2 (-1) 6) →
          (hbs2_6 : Bnd s2_6 (-2648359) 58488439) →
          (hbs2_7 : Bnd s2_7 (-2648360) 58488445) →
          (hbs1_7 : Bnd s1_7 0 2097151) →
          (hbcarry2_2 : Bnd carry2_2 (-2) 27) →
          (hbs3_7 : Bnd s3_7 (-28987116) 2046380) → (blk.runBodyFrom E' 381 S >>= g) = K) :
    (blk.runBodyFrom E 337 S >>= g) = K := by
  step_pure
  -- long carry1 = (s1 + (1L << 20)) >> 21
  step_pure with carry1_1
  bnd carry1_1
  step_pure
  step_pure
  -- long carry3 = (s3 + (1L << 20)) >> 21
  step_pure with carry3_1
  bnd carry3_1
  step_pure
  step_pure
  -- long carry5 = (s5 + (1L << 20)) >> 21
  step_pure with carry5_1
  bnd carry5_1
  -- s6 += carry5
  step_pure with s6_9
  bnd s6_9
  step_pure with t346
  bnd t346
  step_pure
  -- carry7 = (s7 + (1L << 20)) >> 21
  step_pure with carry7_2
  bnd carry7_2
  -- s8 += carry7
  step_pure with s8_10
  bnd s8_10
  step_pure
  -- s7 -= (long)((ulong)carry7 << 21)
  step_pure with s7_10
  bnd s7_10
  step_pure
  -- carry9 = (s9 + (1L << 20)) >> 21
  step_pure with carry9_2
  bnd carry9_2
  -- s10 += carry9
  step_pure with s10_10
  bnd s10_10
  step_pure
  -- s9 -= (long)((ulong)carry9 << 21)
  step_pure with s9_10
  bnd s9_10
  step_pure
  -- carry11 = (s11 + (1L << 20)) >> 21
  step_pure with carry11_2
  bnd carry11_2
  step_pure
  -- s11 -= (long)((ulong)carry11 << 21)
  step_pure with s11_10
  bnd s11_10
  step_pure [nswMul]
  -- s0 += s12*666643L
  step_pure with s0_3
  bnd s0_3
  step_pure [nswMul]
  step_pure [nswMul]
  step_pure [nswMul]
  step_pure [nswMul] with t366
  bnd t366
  step_pure [nswMul] with t367
  bnd t367
  -- carry0 = s0 >> 21
  step_pure with carry0_2
  bnd carry0_2
  step_pure
  -- s1 += s12*470296L
  step_pure with s1_5
  bnd s1_5
  -- s1 += carry0
  step_pure with s1_6
  bnd s1_6
  -- s0 -= (long)((ulong)carry0 << 21)
  step_pure with s0_4
  bnd s0_4
  -- carry1 = s1 >> 21
  step_pure with carry1_2
  bnd carry1_2
  step_pure
  -- s2 += s12*654183L
  step_pure with s2_6
  bnd s2_6
  -- s2 += carry1
  step_pure with s2_7
  bnd s2_7
  -- s1 -= (long)((ulong)carry1 << 21)
  step_pure with s1_7
  bnd s1_7
  -- carry2 = s2 >> 21
  step_pure with carry2_2
  bnd carry2_2
  step_pure
  -- s3 -= s12*997805L
  step_pure with s3_7
  bnd s3_7
  exact
    hK _ carry1_1 carry3_1 carry5_1 s6_9 t346 carry7_2 s8_10 s7_10 carry9_2 s10_10 s9_10 carry11_2
      s11_10 s0_3 t366 t367 carry0_2 s1_5 s1_6 s0_4 carry1_2 s2_6 s2_7 s1_7 carry2_2 s3_7 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hcarry1_1) (by bridge hcarry3_1) (by bridge hcarry5_1)
      (by bridge hs6_9 hcarry5_1) ht346 (by bridge hcarry7_2) (by bridge hs8_10 hcarry7_2)
      (by bridge hs7_10) (by bridge hcarry9_2) (by bridge hs10_10 hcarry9_2) (by bridge hs9_10)
      (by bridge hcarry11_2) (by bridge hs11_10) (by bridge hs0_3 hcarry11_2) ht366 ht367
      (by bridge hcarry0_2) (by bridge hs1_5 hcarry11_2) (by bridge hs1_6 hcarry0_2)
      (by bridge hs0_4) (by bridge hcarry1_2) (by bridge hs2_6 hcarry11_2 hcarry1_1)
      (by bridge hs2_7 hcarry1_2) (by bridge hs1_7) (by bridge hcarry2_2)
      (by bridge hs3_7 hcarry11_2) hbcarry1_1 hbcarry3_1 hbcarry5_1 hbs6_9 hbt346 hbcarry7_2 hbs8_10
      hbs7_10 hbcarry9_2 hbs10_10 hbs9_10 hbcarry11_2 hbs11_10 hbs0_3 hbt366 hbt367 hbcarry0_2
      hbs1_5 hbs1_6 hbs0_4 hbcarry1_2 hbs2_6 hbs2_7 hbs1_7 hbcarry2_2 hbs3_7

/-- From `%381`: the unrounded carries up to `carry11`. -/
theorem fd_curve25519_scalar_reduce.run381 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 381 = fd_curve25519_scalar_reduce.entry.body.drop 381)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s5_7 s4_6 carry3_1 s6_9 t346 s8_10 s7_10 s10_10 s9_10 s11_10 t366 t367 s0_4 s2_7 s1_7 carry2_2
      s3_7 s3_5 s11_9 carry11_2 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%311 := s5_7, %313 := s4_6, %341 := carry3_1, %345 := s6_9, %346 := t346, %349 := s8_10,
        %351 := s7_10, %354 := s10_10, %356 := s9_10, %360 := s11_10, %366 := t366, %367 := t367,
        %372 := s0_4, %376 := s2_7, %377 := s1_7, %378 := carry2_2, %380 := s3_7])
    (hcarry3_1 : carry3_1 = (s3_5 + 1048576#64).sshiftRight 21)
    (ht346 : t346 = ((s5_7 + 1048576#64) &&& 18446744073707454464#64))
    (hcarry11_2 : carry11_2 = (s11_9 + 1048576#64).sshiftRight 21)
    (ht366 : t366 = (carry11_2 * 136657#64)) (ht367 : t367 = (carry11_2 * 18446744073708867715#64))
    (hcarry2_2 : carry2_2 = s2_7.sshiftRight 21)
    (hbs3_5 : Bnd s3_5 (-175259679249579) 83427691131694) (hbs4_6 : Bnd s4_6 (-1048576) 1048575)
    (hbs11_9 : Bnd s11_9 (-1732478) 58143373) (hbs6_9 : Bnd s6_9 (-194138808) 12380602)
    (hbs8_10 : Bnd s8_10 (-127875146) 3485823) (hbs7_10 : Bnd s7_10 (-1048576) 1048575)
    (hbs10_10 : Bnd s10_10 (-24207876) 1750290) (hbs9_10 : Bnd s9_10 (-1048576) 1048575)
    (hbs11_10 : Bnd s11_10 (-1048576) 1048575) (hbs0_4 : Bnd s0_4 0 2097151)
    (hbs2_7 : Bnd s2_7 (-2648360) 58488445) (hbs1_7 : Bnd s1_7 0 2097151)
    (hbs3_7 : Bnd s3_7 (-28987116) 2046380)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s3_8 s2_8 carry3_2 s4_8 s4_9 s3_9 carry4_2 s5_9 s5_10 s4_10 carry5_2 s6_10 s5_11 carry6_3
          s7_11 s6_11 carry7_3 s8_11 s7_12 carry8_3 s9_11 s8_12 carry9_3 s10_11 s9_12 carry10_3
          s11_11 s10_12 carry11_3 s11_12 s0_5 s1_8 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%382 := s2_8, %387 := s3_9, %392 := s4_10, %395 := s5_11, %398 := s6_11, %401 :=
              s7_12, %404 := s8_12, %407 := s9_12, %410 := s10_12, %411 := carry11_3, %412 :=
              s11_12, %414 := s0_5, %416 := s1_8]) →
          (hs3_8 : s3_8 = s3_7 + (s2_7.sshiftRight 21)) →
          (hs2_8 : s2_8 = s2_7 - (s2_7.sshiftRight 21) <<< 21) →
          (hcarry3_2 : carry3_2 = s3_8.sshiftRight 21) →
          (hs4_8 :
            s4_8 =
              (s4_6 + ((s3_5 + 1048576#64).sshiftRight 21)) +
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 136657#64) →
          (hs4_9 : s4_9 = s4_8 + (s3_8.sshiftRight 21)) →
          (hs3_9 : s3_9 = s3_8 - (s3_8.sshiftRight 21) <<< 21) →
          (hcarry4_2 : carry4_2 = s4_9.sshiftRight 21) →
          (hs5_9 :
            s5_9 =
              (s5_7 - ((s5_7 + 1048576#64).sshiftRight 21) <<< 21) -
                ((0#64) + ((s11_9 + 1048576#64).sshiftRight 21)) * 683901#64) →
          (hs5_10 : s5_10 = s5_9 + (s4_9.sshiftRight 21)) →
          (hs4_10 : s4_10 = s4_9 - (s4_9.sshiftRight 21) <<< 21) →
          (hcarry5_2 : carry5_2 = s5_10.sshiftRight 21) →
          (hs6_10 : s6_10 = s6_9 + (s5_10.sshiftRight 21)) →
          (hs5_11 : s5_11 = s5_10 - (s5_10.sshiftRight 21) <<< 21) →
          (hcarry6_3 : carry6_3 = s6_10.sshiftRight 21) →
          (hs7_11 : s7_11 = s7_10 + (s6_10.sshiftRight 21)) →
          (hs6_11 : s6_11 = s6_10 - (s6_10.sshiftRight 21) <<< 21) →
          (hcarry7_3 : carry7_3 = s7_11.sshiftRight 21) →
          (hs8_11 : s8_11 = s8_10 + (s7_11.sshiftRight 21)) →
          (hs7_12 : s7_12 = s7_11 - (s7_11.sshiftRight 21) <<< 21) →
          (hcarry8_3 : carry8_3 = s8_11.sshiftRight 21) →
          (hs9_11 : s9_11 = s9_10 + (s8_11.sshiftRight 21)) →
          (hs8_12 : s8_12 = s8_11 - (s8_11.sshiftRight 21) <<< 21) →
          (hcarry9_3 : carry9_3 = s9_11.sshiftRight 21) →
          (hs10_11 : s10_11 = s10_10 + (s9_11.sshiftRight 21)) →
          (hs9_12 : s9_12 = s9_11 - (s9_11.sshiftRight 21) <<< 21) →
          (hcarry10_3 : carry10_3 = s10_11.sshiftRight 21) →
          (hs11_11 : s11_11 = s11_10 + (s10_11.sshiftRight 21)) →
          (hs10_12 : s10_12 = s10_11 - (s10_11.sshiftRight 21) <<< 21) →
          (hcarry11_3 : carry11_3 = s11_11.sshiftRight 21) →
          (hs11_12 : s11_12 = s11_11 - (s11_11.sshiftRight 21) <<< 21) →
          (hs0_5 : s0_5 = s0_4 + ((0#64) + (s11_11.sshiftRight 21)) * 666643#64) →
          (hs1_8 : s1_8 = s1_7 + ((0#64) + (s11_11.sshiftRight 21)) * 470296#64) →
          (hbs3_8 : Bnd s3_8 (-28987118) 2046407) →
          (hbs2_8 : Bnd s2_8 0 2097151) →
          (hbcarry3_2 : Bnd carry3_2 (-14) 0) →
          (hbs4_8 : Bnd s4_8 (-84755560) 44656394) →
          (hbs4_9 : Bnd s4_9 (-84755574) 44656394) →
          (hbs3_9 : Bnd s3_9 0 2097151) →
          (hbcarry4_2 : Bnd carry4_2 (-41) 21) →
          (hbs5_9 : Bnd s5_9 (-20197804) 1732476) →
          (hbs5_10 : Bnd s5_10 (-20197845) 1732497) →
          (hbs4_10 : Bnd s4_10 0 2097151) →
          (hbcarry5_2 : Bnd carry5_2 (-10) 0) →
          (hbs6_10 : Bnd s6_10 (-194138818) 12380602) →
          (hbs5_11 : Bnd s5_11 0 2097151) →
          (hbcarry6_3 : Bnd carry6_3 (-93) 5) →
          (hbs7_11 : Bnd s7_11 (-1048669) 1048580) →
          (hbs6_11 : Bnd s6_11 0 2097151) →
          (hbcarry7_3 : Bnd carry7_3 (-1) 0) →
          (hbs8_11 : Bnd s8_11 (-127875147) 3485823) →
          (hbs7_12 : Bnd s7_12 0 2097151) →
          (hbcarry8_3 : Bnd carry8_3 (-61) 1) →
          (hbs9_11 : Bnd s9_11 (-1048637) 1048576) →
          (hbs8_12 : Bnd s8_12 0 2097151) →
          (hbcarry9_3 : Bnd carry9_3 (-1) 0) →
          (hbs10_11 : Bnd s10_11 (-24207877) 1750290) →
          (hbs9_12 : Bnd s9_12 0 2097151) →
          (hbcarry10_3 : Bnd carry10_3 (-12) 0) →
          (hbs11_11 : Bnd s11_11 (-1048588) 1048575) →
          (hbs10_12 : Bnd s10_12 0 2097151) →
          (hbcarry11_3 : Bnd carry11_3 (-1) 0) →
          (hbs11_12 : Bnd s11_12 0 2097151) →
          (hbs0_5 : Bnd s0_5 (-666643) 2097151) →
          (hbs1_8 : Bnd s1_8 (-470296) 2097151) → (blk.runBodyFrom E' 417 S >>= g) = K) :
    (blk.runBodyFrom E 381 S >>= g) = K := by
  -- s3 += carry2
  step_pure with s3_8
  bnd s3_8
  -- s2 -= (long)((ulong)carry2 << 21)
  step_pure with s2_8
  bnd s2_8
  -- carry3 = s3 >> 21
  step_pure with carry3_2
  bnd carry3_2
  step_pure
  -- s4 += s12*136657L
  step_pure with s4_8
  bnd s4_8
  -- s4 += carry3
  step_pure with s4_9
  bnd s4_9
  -- s3 -= (long)((ulong)carry3 << 21)
  step_pure with s3_9
  bnd s3_9
  -- carry4 = s4 >> 21
  step_pure with carry4_2
  bnd carry4_2
  step_pure
  -- s5 -= s12*683901L
  step_pure with s5_9
  bnd s5_9
  -- s5 += carry4
  step_pure with s5_10
  bnd s5_10
  -- s4 -= (long)((ulong)carry4 << 21)
  step_pure with s4_10
  bnd s4_10
  -- carry5 = s5 >> 21
  step_pure with carry5_2
  bnd carry5_2
  -- s6 += carry5
  step_pure with s6_10
  bnd s6_10
  -- s5 -= (long)((ulong)carry5 << 21)
  step_pure with s5_11
  bnd s5_11
  -- carry6 = s6 >> 21
  step_pure with carry6_3
  bnd carry6_3
  -- s7 += carry6
  step_pure with s7_11
  bnd s7_11
  -- s6 -= (long)((ulong)carry6 << 21)
  step_pure with s6_11
  bnd s6_11
  -- carry7 = s7 >> 21
  step_pure with carry7_3
  bnd carry7_3
  -- s8 += carry7
  step_pure with s8_11
  bnd s8_11
  -- s7 -= (long)((ulong)carry7 << 21)
  step_pure with s7_12
  bnd s7_12
  -- carry8 = s8 >> 21
  step_pure with carry8_3
  bnd carry8_3
  -- s9 += carry8
  step_pure with s9_11
  bnd s9_11
  -- s8 -= (long)((ulong)carry8 << 21)
  step_pure with s8_12
  bnd s8_12
  -- carry9 = s9 >> 21
  step_pure with carry9_3
  bnd carry9_3
  -- s10 += carry9
  step_pure with s10_11
  bnd s10_11
  -- s9 -= (long)((ulong)carry9 << 21)
  step_pure with s9_12
  bnd s9_12
  -- carry10 = s10 >> 21
  step_pure with carry10_3
  bnd carry10_3
  -- s11 += carry10
  step_pure with s11_11
  bnd s11_11
  -- s10 -= (long)((ulong)carry10 << 21)
  step_pure with s10_12
  bnd s10_12
  -- carry11 = s11 >> 21
  step_pure with carry11_3
  bnd carry11_3
  -- s11 -= (long)((ulong)carry11 << 21)
  step_pure with s11_12
  bnd s11_12
  step_pure [nswMul]
  -- s0 += s12*666643L
  step_pure [nswAdd] with s0_5
  bnd s0_5
  step_pure [nswMul]
  -- s1 += s12*470296L
  step_pure [nswAdd] with s1_8
  bnd s1_8
  exact
    hK _ s3_8 s2_8 carry3_2 s4_8 s4_9 s3_9 carry4_2 s5_9 s5_10 s4_10 carry5_2 s6_10 s5_11 carry6_3
      s7_11 s6_11 carry7_3 s8_11 s7_12 carry8_3 s9_11 s8_12 carry9_3 s10_11 s9_12 carry10_3 s11_11
      s10_12 carry11_3 s11_12 s0_5 s1_8 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hs3_8) (by bridge hs2_8) (by bridge hcarry3_2) (by bridge hs4_8)
      (by bridge hs4_9 hcarry3_2) (by bridge hs3_9) (by bridge hcarry4_2) (by bridge hs5_9)
      (by bridge hs5_10 hcarry4_2) (by bridge hs4_10) (by bridge hcarry5_2)
      (by bridge hs6_10 hcarry5_2) (by bridge hs5_11) (by bridge hcarry6_3)
      (by bridge hs7_11 hcarry6_3) (by bridge hs6_11) (by bridge hcarry7_3)
      (by bridge hs8_11 hcarry7_3) (by bridge hs7_12) (by bridge hcarry8_3)
      (by bridge hs9_11 hcarry8_3) (by bridge hs8_12) (by bridge hcarry9_3)
      (by bridge hs10_11 hcarry9_3) (by bridge hs9_12) (by bridge hcarry10_3)
      (by bridge hs11_11 hcarry10_3) (by bridge hs10_12) (by bridge hcarry11_3) (by bridge hs11_12)
      (by bridge hs0_5 hcarry11_3) (by bridge hs1_8 hcarry11_3) hbs3_8 hbs2_8 hbcarry3_2 hbs4_8
      hbs4_9 hbs3_9 hbcarry4_2 hbs5_9 hbs5_10 hbs4_10 hbcarry5_2 hbs6_10 hbs5_11 hbcarry6_3 hbs7_11
      hbs6_11 hbcarry7_3 hbs8_11 hbs7_12 hbcarry8_3 hbs9_11 hbs8_12 hbcarry9_3 hbs10_11 hbs9_12
      hbcarry10_3 hbs11_11 hbs10_12 hbcarry11_3 hbs11_12 hbs0_5 hbs1_8

/-- From `%417`: the second `s12` row and the last carries. -/
theorem fd_curve25519_scalar_reduce.run417 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 417 = fd_curve25519_scalar_reduce.entry.body.drop 417)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s2_8 s3_9 s4_10 s5_11 s6_11 s7_12 s8_12 s9_12 s10_12 carry11_3 s11_12 s0_5 s1_8 s11_11 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%382 := s2_8, %387 := s3_9, %392 := s4_10, %395 := s5_11, %398 := s6_11, %401 := s7_12,
        %404 := s8_12, %407 := s9_12, %410 := s10_12, %411 := carry11_3, %412 := s11_12, %414 :=
        s0_5, %416 := s1_8])
    (hcarry11_3 : carry11_3 = s11_11.sshiftRight 21) (hbs2_8 : Bnd s2_8 0 2097151)
    (hbs3_9 : Bnd s3_9 0 2097151) (hbs4_10 : Bnd s4_10 0 2097151) (hbs5_11 : Bnd s5_11 0 2097151)
    (hbs6_11 : Bnd s6_11 0 2097151) (hbs7_12 : Bnd s7_12 0 2097151) (hbs8_12 : Bnd s8_12 0 2097151)
    (hbs9_12 : Bnd s9_12 0 2097151) (hbs11_11 : Bnd s11_11 (-1048588) 1048575)
    (hbs10_12 : Bnd s10_12 0 2097151) (hbs11_12 : Bnd s11_12 0 2097151)
    (hbs0_5 : Bnd s0_5 (-666643) 2097151) (hbs1_8 : Bnd s1_8 (-470296) 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s2_9 s3_10 s4_11 s5_12 carry0_3 s1_9 s0_6 carry1_3 s2_10 carry2_3 s3_11 carry3_3 s4_12
          carry4_3 s5_13 carry5_3 s6_12 carry6_4 s7_13 carry7_4 s8_13 carry8_4 s9_13 carry9_4 s10_13
          s11_13 t447 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hR :
            E' ⊨ [%426 := s1_9, %427 := s0_6, %429 := s2_10, %431 := s3_11, %433 := s4_12, %435 :=
              s5_13, %437 := s6_12, %439 := s7_13, %441 := s8_13, %443 := s9_13, %445 := s10_13,
              %447 := t447]) →
          (hs2_9 : s2_9 = s2_8 + ((0#64) + (s11_11.sshiftRight 21)) * 654183#64) →
          (hs3_10 : s3_10 = s3_9 - ((0#64) + (s11_11.sshiftRight 21)) * 997805#64) →
          (hs4_11 : s4_11 = s4_10 + ((0#64) + (s11_11.sshiftRight 21)) * 136657#64) →
          (hs5_12 : s5_12 = s5_11 - ((0#64) + (s11_11.sshiftRight 21)) * 683901#64) →
          (hcarry0_3 : carry0_3 = s0_5.sshiftRight 21) →
          (hs1_9 : s1_9 = s1_8 + (s0_5.sshiftRight 21)) →
          (hs0_6 : s0_6 = s0_5 - (s0_5.sshiftRight 21) <<< 21) →
          (hcarry1_3 : carry1_3 = s1_9.sshiftRight 21) →
          (hs2_10 : s2_10 = s2_9 + (s1_9.sshiftRight 21)) →
          (hcarry2_3 : carry2_3 = s2_10.sshiftRight 21) →
          (hs3_11 : s3_11 = s3_10 + (s2_10.sshiftRight 21)) →
          (hcarry3_3 : carry3_3 = s3_11.sshiftRight 21) →
          (hs4_12 : s4_12 = s4_11 + (s3_11.sshiftRight 21)) →
          (hcarry4_3 : carry4_3 = s4_12.sshiftRight 21) →
          (hs5_13 : s5_13 = s5_12 + (s4_12.sshiftRight 21)) →
          (hcarry5_3 : carry5_3 = s5_13.sshiftRight 21) →
          (hs6_12 : s6_12 = s6_11 + (s5_13.sshiftRight 21)) →
          (hcarry6_4 : carry6_4 = s6_12.sshiftRight 21) →
          (hs7_13 : s7_13 = s7_12 + (s6_12.sshiftRight 21)) →
          (hcarry7_4 : carry7_4 = s7_13.sshiftRight 21) →
          (hs8_13 : s8_13 = s8_12 + (s7_13.sshiftRight 21)) →
          (hcarry8_4 : carry8_4 = s8_13.sshiftRight 21) →
          (hs9_13 : s9_13 = s9_12 + (s8_13.sshiftRight 21)) →
          (hcarry9_4 : carry9_4 = s9_13.sshiftRight 21) →
          (hs10_13 : s10_13 = s10_12 + (s9_13.sshiftRight 21)) →
          (hs11_13 : s11_13 = s11_12 + (s10_13.sshiftRight 21)) →
          (ht447 : t447 <<< 39 = s11_13 <<< 39) →
          (hbs2_9 : Bnd s2_9 (-654183) 2097151) →
          (hbs3_10 : Bnd s3_10 0 3094956) →
          (hbs4_11 : Bnd s4_11 (-136657) 2097151) →
          (hbs5_12 : Bnd s5_12 0 2781052) →
          (hbcarry0_3 : Bnd carry0_3 (-1) 0) →
          (hbs1_9 : Bnd s1_9 (-470297) 2097151) →
          (hbs0_6 : Bnd s0_6 0 2097151) →
          (hbcarry1_3 : Bnd carry1_3 (-1) 0) →
          (hbs2_10 : Bnd s2_10 (-654184) 2097151) →
          (hbcarry2_3 : Bnd carry2_3 (-1) 0) →
          (hbs3_11 : Bnd s3_11 (-1) 3094956) →
          (hbcarry3_3 : Bnd carry3_3 (-1) 1) →
          (hbs4_12 : Bnd s4_12 (-136658) 2097152) →
          (hbcarry4_3 : Bnd carry4_3 (-1) 1) →
          (hbs5_13 : Bnd s5_13 (-1) 2781053) →
          (hbcarry5_3 : Bnd carry5_3 (-1) 1) →
          (hbs6_12 : Bnd s6_12 (-1) 2097152) →
          (hbcarry6_4 : Bnd carry6_4 (-1) 1) →
          (hbs7_13 : Bnd s7_13 (-1) 2097152) →
          (hbcarry7_4 : Bnd carry7_4 (-1) 1) →
          (hbs8_13 : Bnd s8_13 (-1) 2097152) →
          (hbcarry8_4 : Bnd carry8_4 (-1) 1) →
          (hbs9_13 : Bnd s9_13 (-1) 2097152) →
          (hbcarry9_4 : Bnd carry9_4 (-1) 1) →
          (hbs10_13 : Bnd s10_13 (-1) 2097152) → (blk.runBodyFrom E' 448 S >>= g) = K) :
    (blk.runBodyFrom E 417 S >>= g) = K := by
  step_pure [nswMul]
  -- s2 += s12*654183L
  step_pure [nswAdd] with s2_9
  bnd s2_9
  step_pure [nswMul]
  -- s3 -= s12*997805L
  step_pure [nswAdd] with s3_10
  bnd s3_10
  step_pure [nswMul]
  -- s4 += s12*136657L
  step_pure [nswAdd] with s4_11
  bnd s4_11
  step_pure [nswMul]
  -- s5 -= s12*683901L
  step_pure [nswAdd] with s5_12
  bnd s5_12
  -- carry0 = s0 >> 21
  step_pure with carry0_3
  bnd carry0_3
  -- s1 += carry0
  step_pure [nswAdd] with s1_9
  bnd s1_9
  -- s0 -= (long)((ulong)carry0 << 21)
  step_pure with s0_6
  bnd s0_6
  -- carry1 = s1 >> 21
  step_pure with carry1_3
  bnd carry1_3
  -- s2 += carry1
  step_pure [nswAdd] with s2_10
  bnd s2_10
  -- carry2 = s2 >> 21
  step_pure with carry2_3
  bnd carry2_3
  -- s3 += carry2
  step_pure [nswAdd] with s3_11
  bnd s3_11
  -- carry3 = s3 >> 21
  step_pure with carry3_3
  bnd carry3_3
  -- s4 += carry3
  step_pure [nswAdd] with s4_12
  bnd s4_12
  -- carry4 = s4 >> 21
  step_pure with carry4_3
  bnd carry4_3
  -- s5 += carry4
  step_pure [nswAdd] with s5_13
  bnd s5_13
  -- carry5 = s5 >> 21
  step_pure with carry5_3
  bnd carry5_3
  -- s6 += carry5
  step_pure [nswAdd] with s6_12
  bnd s6_12
  -- carry6 = s6 >> 21
  step_pure with carry6_4
  bnd carry6_4
  -- s7 += carry6
  step_pure [nswAdd] with s7_13
  bnd s7_13
  -- carry7 = s7 >> 21
  step_pure with carry7_4
  bnd carry7_4
  -- s8 += carry7
  step_pure [nswAdd] with s8_13
  bnd s8_13
  -- carry8 = s8 >> 21
  step_pure with carry8_4
  bnd carry8_4
  -- s9 += carry8
  step_pure [nswAdd] with s9_13
  bnd s9_13
  -- carry9 = s9 >> 21
  step_pure with carry9_4
  bnd carry9_4
  -- s10 += carry9
  step_pure [nswAdd] with s10_13
  bnd s10_13
  -- carry10 = s10 >> 21, shifted logically: `s11 << 39` drops the bits where the shifts differ
  step_pure
  -- s11 += carry10
  step_pure [nswAdd, nuwAdd] with t447
  exact
    hK _ s2_9 s3_10 s4_11 s5_12 carry0_3 s1_9 s0_6 carry1_3 s2_10 carry2_3 s3_11 carry3_3 s4_12
      carry4_3 s5_13 carry5_3 s6_12 carry6_4 s7_13 carry7_4 s8_13 carry8_4 s9_13 carry9_4 s10_13
      (s11_12 + s10_13.sshiftRight 21) t447 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by env_reads) (by bridge hs2_9) (by bridge hs3_10) (by bridge hs4_11) (by bridge hs5_12)
      (by bridge hcarry0_3) (by bridge hs1_9 hcarry0_3) (by bridge hs0_6) (by bridge hcarry1_3)
      (by bridge hs2_10 hcarry1_3) (by bridge hcarry2_3) (by bridge hs3_11 hcarry2_3)
      (by bridge hcarry3_3) (by bridge hs4_12 hcarry3_3) (by bridge hcarry4_3)
      (by bridge hs5_13 hcarry4_3) (by bridge hcarry5_3) (by bridge hs6_12 hcarry5_3)
      (by bridge hcarry6_4) (by bridge hs7_13 hcarry6_4) (by bridge hcarry7_4)
      (by bridge hs8_13 hcarry7_4) (by bridge hcarry8_4) (by bridge hs9_13 hcarry8_4)
      (by bridge hcarry9_4) (by bridge hs10_13 hcarry9_4) rfl
      (by rw [ht447, Bnd.ushiftRight_add_shl39]) hbs2_9 hbs3_10 hbs4_11 hbs5_12 hbcarry0_3 hbs1_9
      hbs0_6 hbcarry1_3 hbs2_10 hbcarry2_3 hbs3_11 hbcarry3_3 hbs4_12 hbcarry4_3 hbs5_13 hbcarry5_3
      hbs6_12 hbcarry6_4 hbs7_13 hbcarry7_4 hbs8_13 hbcarry8_4 hbs9_13 hbcarry9_4 hbs10_13

/-- `out0`'s `or disjoint`s hold: `s0` below `2^21`, the other limbs masked or shifted above it. -/
theorem fd_curve25519_scalar_reduce.out0_disjoint (a b c d : BitVec 64) (hd : Bnd d 0 2097151) :
    a <<< 21 &&& 4398044413952#64 &&& d = 0#64 ∧
      (a <<< 21 &&& 4398044413952#64 ||| d) &&& (b <<< 42 &&& 9223367638808264704#64) = 0#64 ∧
      (a <<< 21 &&& 4398044413952#64 ||| d ||| b <<< 42 &&& 9223367638808264704#64) &&& c <<< 63 =
        0#64 := by
  have := Bnd.toInt_eq_toNat hd (by decide)
  have := hd.2
  have hd' : d.ult 2097152#64 := by
    simp [BitVec.ult]; omega
  bv_decide

/-- `out1`'s `or disjoint`s hold: the limbs' bits are masked or shifted apart. -/
theorem fd_curve25519_scalar_reduce.out1_disjoint (a b c d : BitVec 64) :
    b <<< 20 &&& 2199022206976#64 &&& (a >>> 1 &&& 1048575#64) = 0#64 ∧
      (b <<< 20 &&& 2199022206976#64 ||| a >>> 1 &&& 1048575#64) &&&
          (c <<< 41 &&& 4611683819404132352#64) =
        0#64 ∧
      (b <<< 20 &&& 2199022206976#64 ||| a >>> 1 &&& 1048575#64 |||
            c <<< 41 &&& 4611683819404132352#64) &&&
          d <<< 62 =
        0#64 := by
  bv_decide

/-- `out2`'s `or disjoint`s hold: the limbs' bits are masked or shifted apart. -/
theorem fd_curve25519_scalar_reduce.out2_disjoint (a b c d : BitVec 64) :
    b <<< 19 &&& 1099511103488#64 &&& (a >>> 2 &&& 524287#64) = 0#64 ∧
      (b <<< 19 &&& 1099511103488#64 ||| a >>> 2 &&& 524287#64) &&&
          (c <<< 40 &&& 2305841909702066176#64) =
        0#64 ∧
      (b <<< 19 &&& 1099511103488#64 ||| a >>> 2 &&& 524287#64 |||
            c <<< 40 &&& 2305841909702066176#64) &&&
          d <<< 61 =
        0#64 := by
  bv_decide

/-- `out3`'s `or disjoint`s hold: the limbs' bits are masked or shifted apart. -/
theorem fd_curve25519_scalar_reduce.out3_disjoint (a b c : BitVec 64) :
    a >>> 3 &&& 262143#64 &&& (b <<< 18 &&& 549755551744#64) = 0#64 ∧
      (a >>> 3 &&& 262143#64 ||| b <<< 18 &&& 549755551744#64) &&& c <<< 39 = 0#64 := by
  bv_decide

/-- From `%448`: the limbs packed into four words, stored at `out`. -/
theorem fd_curve25519_scalar_reduce.run448 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 448 = fd_curve25519_scalar_reduce.entry.body.drop 448)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s1_9 s0_6 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 s11_13 t447 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hout : Room S.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hc : fd_curve25519_scalar_reduce.Consts E)
    (hR :
      E ⊨ [%426 := s1_9, %427 := s0_6, %429 := s2_10, %431 := s3_11, %433 := s4_12, %435 := s5_13,
        %437 := s6_12, %439 := s7_13, %441 := s8_13, %443 := s9_13, %445 := s10_13, %447 := t447])
    (ht447 : t447 <<< 39 = s11_13 <<< 39) (hbs0_6 : Bnd s0_6 0 2097151)
    (hbs7_13 : Bnd s7_13 (-1) 2097152) (hbs8_13 : Bnd s8_13 (-1) 2097152)
    (hbs10_13 : Bnd s10_13 (-1) 2097152)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫) (out0 out1 out2 out3 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hout0 :
            out0 =
              s0_6 ||| (s1_9 - (s1_9.sshiftRight 21) <<< 21) <<< 21 |||
                (s2_10 - (s2_10.sshiftRight 21) <<< 21) <<< 42 |||
                (s3_11 - (s3_11.sshiftRight 21) <<< 21) <<< 63) →
          (hout1 :
            out1 =
              (s3_11 - (s3_11.sshiftRight 21) <<< 21) >>> 1 |||
                (s4_12 - (s4_12.sshiftRight 21) <<< 21) <<< 20 |||
                (s5_13 - (s5_13.sshiftRight 21) <<< 21) <<< 41 |||
                (s6_12 - (s6_12.sshiftRight 21) <<< 21) <<< 62) →
          (hout2 :
            out2 =
              (s6_12 - (s6_12.sshiftRight 21) <<< 21) >>> 2 |||
                (s7_13 - (s7_13.sshiftRight 21) <<< 21) <<< 19 |||
                (s8_13 - (s8_13.sshiftRight 21) <<< 21) <<< 40 |||
                (s9_13 - (s9_13.sshiftRight 21) <<< 21) <<< 61) →
          (hout3 :
            out3 =
              (s9_13 - (s9_13.sshiftRight 21) <<< 21) >>> 3 |||
                (s10_13 - (s10_13.sshiftRight 21) <<< 21) <<< 18 |||
                s11_13 <<< 39) →
          (blk.runBodyFrom E' 490
                { S with
                  mem :=
                    (((S.mem.storeAt out out0).storeAt (out.add 8#64) out1).storeAt (out.add 16#64)
                          out2).storeAt
                      (out.add 24#64) out3 } >>=
              g) =
            K) :
    (blk.runBodyFrom E 448 S >>= g) = K := by
  have hd0 := fd_curve25519_scalar_reduce.out0_disjoint s1_9 s2_10 s3_11 s0_6 hbs0_6
  have hd1 := fd_curve25519_scalar_reduce.out1_disjoint s3_11 s4_12 s5_13 s6_12
  have hd2 := fd_curve25519_scalar_reduce.out2_disjoint s6_12 s7_13 s8_13 s9_13
  have hd3 := fd_curve25519_scalar_reduce.out3_disjoint s9_13 s10_13 t447
  step_pure
  step_pure
  step_pure [hd0]
  step_pure
  step_pure
  step_pure [hd0]
  step_pure
  step_pure [hd0] with out0
  step_store
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [hd1]
  step_pure
  step_pure
  step_pure [hd1]
  step_pure
  step_pure [hd1] with out1
  step_pure
  step_store
  step_pure
  step_pure
  step_pure [nswShl]
  step_pure
  step_pure [hd2]
  step_pure [nswShl]
  step_pure
  step_pure [hd2]
  step_pure
  step_pure [hd2] with out2
  step_pure
  step_store
  step_pure
  step_pure
  step_pure [nswShl]
  step_pure
  step_pure [hd3]
  step_pure
  step_pure [hd3] with out3
  step_pure
  step_store
  subst hS
  exact
    hK _ out0 out1 out2 out3 hArgs (by bridge_bv hout0) (by bridge_bv hout1) (by bridge_bv hout2)
      (by bridge_bv hout3 ht447)

/-- `reduce` stores `spec` of the 64 bytes at `inp` as the 32 bytes at `out`, and returns `out`. The
loads all come before the stores, so `out` may alias `inp`. -/
public theorem fd_curve25519_scalar_reduce.call_eq (out inp : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hin : Fits s.mem inp (8 * 64)) (hin_off : ¬inp.offset.uaddOverflow 64#64) :
    fd_curve25519_scalar_reduce.call (fd_curve25519_scalar_reduce.args (.value out) (.value inp))
        s =
      .value
        (.cons (.value out) .nil,
          { s with
            mem :=
              s.mem.storeAt out
                (Firedancer.Ref.fd_curve25519_scalar_reduce.spec (s.mem.readAt inp 512)) }) := by
  func_init
  block_init
  step_pattern using fd_curve25519_scalar_reduce.run0
  -- the loads' facts, about the entry state rather than the current one
  rw [hS] at hin0 hin1 hin2 hin3 hin4 hin5 hin6 hin7
  step_pattern using fd_curve25519_scalar_reduce.run62
  step_pattern using fd_curve25519_scalar_reduce.run108
  step_pattern using fd_curve25519_scalar_reduce.run137
  step_pattern using fd_curve25519_scalar_reduce.run182
  step_pattern using fd_curve25519_scalar_reduce.run209
  step_pattern using fd_curve25519_scalar_reduce.run235
  step_pattern using fd_curve25519_scalar_reduce.run270
  step_pattern using fd_curve25519_scalar_reduce.run304
  step_pattern using fd_curve25519_scalar_reduce.run337
  step_pattern using fd_curve25519_scalar_reduce.run381
  step_pattern using fd_curve25519_scalar_reduce.run417
  step_pattern using fd_curve25519_scalar_reduce.run448
  finish_block
  -- the four 8-byte stores as one 32-byte store
  have hov (k : Nat) (hk : k ≤ 32) : ¬out.offset.uaddOverflow (BitVec.ofNat 64 k) :=
    BitVec.not_uaddOverflow_of_le hout_off
      (by
        simp; omega)
  rw [hS, MemoryState.storeAt_storeAt_append (hov 8 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 16 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 24 (by decide)) rfl (by decide)]
  -- the named values' C forms, substituted, are the spec's lets
  keep_eqs
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Ref
