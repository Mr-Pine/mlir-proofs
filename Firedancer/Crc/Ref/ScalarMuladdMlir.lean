module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.ScalarMuladd
public import Firedancer.Crc.Ref.ScalarBnd
public import Firedancer.Crc.Ref.Mlir.fd_curve25519_scalar_muladd
import Std.Tactic.BVDecide

/-!
# `fd_curve25519_scalar_muladd` (MLIR lift ↔ spec)

The compiled code is the C's limb arithmetic reassociated. The runs `runK` step from the `K`-th
instruction in continuation form: each value is named after the spec's let it equals (`tN` for `%N`
otherwise) and bounded (`Bnd`) to discharge its `nsw`/`nuw` flags. Each `x_eq` restates a value in
the spec's terms; `spec_eq` substitutes them into the stored words, which are then `spec` by `rfl`,
and `fd_curve25519_scalar_muladd.spec_val` is `(a b + c) mod ℓ`.
-/

namespace MLIR.Firedancer.Crc.Ref

open Firedancer.Ref (Bnd nswAdd nswSub nswMul nswShl nuwAdd nuwMul lshrNonneg andMask)

/-! ## Proof -/

section Proof

/-- The constants the code reads. -/
abbrev fd_curve25519_scalar_muladd.Consts (E : ⟪fd_curve25519_scalar_muladd.Γ⟫) : Prop :=
  E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 0 := 2097151#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 1 := 21#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 2 := 42#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 3 := 1#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 4 := 20#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 5 := 41#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 6 := 2#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 7 := 19#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 8 := 40#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 9 := 3#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 10 := 18#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 11 := 39#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 12 := 1048576#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 13 := 17592183947264#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 14 := 18446744073707454464#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 15 := 562949951324160#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 16 := 2251799811588096#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 17 := 666643#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 18 := 470296#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 19 := 654183#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 20 := 18446744073708553811#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 21 := 136657#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 22 := 18446744073708867715#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 23 := 4398044413952#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 24 := 9223367638808264704#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 25 := 63#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 26 := 1048575#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 27 := 2199022206976#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 28 := 4611683819404132352#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 29 := 62#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 30 := 524287#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 31 := 1099511103488#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 32 := 2305841909702066176#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 33 := 61#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 34 := 262143#64,
    rir_reg% fd_curve25519_scalar_muladd.hty 35 := 549755551744#64]

/-- From `%0`: the constants, and the words `ia0 … ic3` of `a`, `b`, `c`. -/
theorem fd_curve25519_scalar_muladd.run0 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hwf : S.WF) (ha : Fits S.mem a (8 * 32)) (ha_off : ¬a.offset.uaddOverflow 32#64)
    (hb : Fits S.mem b (8 * 32)) (hb_off : ¬b.offset.uaddOverflow 32#64)
    (hc : Fits S.mem c (8 * 32)) (hc_off : ¬c.offset.uaddOverflow 32#64)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 36 := ia0,
              rir_reg% fd_curve25519_scalar_muladd.hty 37 := ib0,
              rir_reg% fd_curve25519_scalar_muladd.hty 38 := ic0,
              rir_reg% fd_curve25519_scalar_muladd.hty 40 := ia1,
              rir_reg% fd_curve25519_scalar_muladd.hty 42 := ib1,
              rir_reg% fd_curve25519_scalar_muladd.hty 44 := ic1,
              rir_reg% fd_curve25519_scalar_muladd.hty 46 := ia2,
              rir_reg% fd_curve25519_scalar_muladd.hty 48 := ib2,
              rir_reg% fd_curve25519_scalar_muladd.hty 50 := ic2,
              rir_reg% fd_curve25519_scalar_muladd.hty 52 := ia3,
              rir_reg% fd_curve25519_scalar_muladd.hty 54 := ib3,
              rir_reg% fd_curve25519_scalar_muladd.hty 56 := ic3]) →
          (hia0 : ia0 = BitVec.setWidth 64 (S.mem.readAt a 256)) →
          (hib0 : ib0 = BitVec.setWidth 64 (S.mem.readAt b 256)) →
          (hic0 : ic0 = BitVec.setWidth 64 (S.mem.readAt c 256)) →
          (hia1 : ia1 = BitVec.extractLsb' 64 64 (S.mem.readAt a 256)) →
          (hib1 : ib1 = BitVec.extractLsb' 64 64 (S.mem.readAt b 256)) →
          (hic1 : ic1 = BitVec.extractLsb' 64 64 (S.mem.readAt c 256)) →
          (hia2 : ia2 = BitVec.extractLsb' 128 64 (S.mem.readAt a 256)) →
          (hib2 : ib2 = BitVec.extractLsb' 128 64 (S.mem.readAt b 256)) →
          (hic2 : ic2 = BitVec.extractLsb' 128 64 (S.mem.readAt c 256)) →
          (hia3 : ia3 = BitVec.extractLsb' 192 64 (S.mem.readAt a 256)) →
          (hib3 : ib3 = BitVec.extractLsb' 192 64 (S.mem.readAt b 256)) →
          (hic3 : ic3 = BitVec.extractLsb' 192 64 (S.mem.readAt c 256)) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 57 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 0 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_load with ia0
  step_load with ib0
  step_load with ic0
  step_pure
  step_load with ia1
  step_pure
  step_load with ib1
  step_pure
  step_load with ic1
  step_pure
  step_load with ia2
  step_pure
  step_load with ib2
  step_pure
  step_load with ic2
  step_pure
  step_load with ia3
  step_pure
  step_load with ib3
  step_pure
  step_load with ic3
  subst hS
  exact
    hK _ ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) hia0 hib0 hic0 hia1 hib1 hic1 hia2 hib2 hic2 hia3 hib3 hic3

/-- From `%57`: `a0` … `c0`. -/
theorem fd_curve25519_scalar_muladd.run57 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 36 := ia0,
        rir_reg% fd_curve25519_scalar_muladd.hty 37 := ib0,
        rir_reg% fd_curve25519_scalar_muladd.hty 38 := ic0,
        rir_reg% fd_curve25519_scalar_muladd.hty 40 := ia1,
        rir_reg% fd_curve25519_scalar_muladd.hty 42 := ib1,
        rir_reg% fd_curve25519_scalar_muladd.hty 44 := ic1,
        rir_reg% fd_curve25519_scalar_muladd.hty 46 := ia2,
        rir_reg% fd_curve25519_scalar_muladd.hty 48 := ib2,
        rir_reg% fd_curve25519_scalar_muladd.hty 50 := ic2,
        rir_reg% fd_curve25519_scalar_muladd.hty 52 := ia3,
        rir_reg% fd_curve25519_scalar_muladd.hty 54 := ib3,
        rir_reg% fd_curve25519_scalar_muladd.hty 56 := ic3])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (a0 t58 a1 t60 a2 t62 a3 t64 a4 t66 a5 t68 a6 t70 a7 t72 a8 t74 a9 t76 a10 a11 b0 t80 b1 t82
          b2 t84 b3 t86 b4 t88 b5 t90 b6 t92 b7 t94 b8 t96 b9 t98 b10 b11 c0 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 38 := ic0,
              rir_reg% fd_curve25519_scalar_muladd.hty 44 := ic1,
              rir_reg% fd_curve25519_scalar_muladd.hty 50 := ic2,
              rir_reg% fd_curve25519_scalar_muladd.hty 56 := ic3,
              rir_reg% fd_curve25519_scalar_muladd.hty 57 := a0,
              rir_reg% fd_curve25519_scalar_muladd.hty 59 := a1,
              rir_reg% fd_curve25519_scalar_muladd.hty 61 := a2,
              rir_reg% fd_curve25519_scalar_muladd.hty 63 := a3,
              rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
              rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
              rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
              rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
              rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
              rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
              rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
              rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
              rir_reg% fd_curve25519_scalar_muladd.hty 79 := b0,
              rir_reg% fd_curve25519_scalar_muladd.hty 81 := b1,
              rir_reg% fd_curve25519_scalar_muladd.hty 83 := b2,
              rir_reg% fd_curve25519_scalar_muladd.hty 85 := b3,
              rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
              rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
              rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
              rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
              rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
              rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
              rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
              rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
              rir_reg% fd_curve25519_scalar_muladd.hty 101 := c0]) →
          (ha0 : a0 = ia0 &&& 2097151#64) →
          (ht58 : t58 = ia0 >>> 21) →
          (ha1 : a1 = t58 &&& 2097151#64) →
          (ht60 : t60 = ia0 >>> 42) →
          (ha2 : a2 = t60 &&& 2097151#64) →
          (ht62 : t62 = BitVec.extractLsb' 64 64 ((ia1 ++ ia0) <<< 1)) →
          (ha3 : a3 = t62 &&& 2097151#64) →
          (ht64 : t64 = ia1 >>> 20) →
          (ha4 : a4 = t64 &&& 2097151#64) →
          (ht66 : t66 = ia1 >>> 41) →
          (ha5 : a5 = t66 &&& 2097151#64) →
          (ht68 : t68 = BitVec.extractLsb' 64 64 ((ia2 ++ ia1) <<< 2)) →
          (ha6 : a6 = t68 &&& 2097151#64) →
          (ht70 : t70 = ia2 >>> 19) →
          (ha7 : a7 = t70 &&& 2097151#64) →
          (ht72 : t72 = ia2 >>> 40) →
          (ha8 : a8 = t72 &&& 2097151#64) →
          (ht74 : t74 = BitVec.extractLsb' 64 64 ((ia3 ++ ia2) <<< 3)) →
          (ha9 : a9 = t74 &&& 2097151#64) →
          (ht76 : t76 = ia3 >>> 18) →
          (ha10 : a10 = t76 &&& 2097151#64) →
          (ha11 : a11 = ia3 >>> 39) →
          (hb0 : b0 = ib0 &&& 2097151#64) →
          (ht80 : t80 = ib0 >>> 21) →
          (hb1 : b1 = t80 &&& 2097151#64) →
          (ht82 : t82 = ib0 >>> 42) →
          (hb2 : b2 = t82 &&& 2097151#64) →
          (ht84 : t84 = BitVec.extractLsb' 64 64 ((ib1 ++ ib0) <<< 1)) →
          (hb3 : b3 = t84 &&& 2097151#64) →
          (ht86 : t86 = ib1 >>> 20) →
          (hb4 : b4 = t86 &&& 2097151#64) →
          (ht88 : t88 = ib1 >>> 41) →
          (hb5 : b5 = t88 &&& 2097151#64) →
          (ht90 : t90 = BitVec.extractLsb' 64 64 ((ib2 ++ ib1) <<< 2)) →
          (hb6 : b6 = t90 &&& 2097151#64) →
          (ht92 : t92 = ib2 >>> 19) →
          (hb7 : b7 = t92 &&& 2097151#64) →
          (ht94 : t94 = ib2 >>> 40) →
          (hb8 : b8 = t94 &&& 2097151#64) →
          (ht96 : t96 = BitVec.extractLsb' 64 64 ((ib3 ++ ib2) <<< 3)) →
          (hb9 : b9 = t96 &&& 2097151#64) →
          (ht98 : t98 = ib3 >>> 18) →
          (hb10 : b10 = t98 &&& 2097151#64) →
          (hb11 : b11 = ib3 >>> 39) →
          (hc0 : c0 = ic0 &&& 2097151#64) →
          (hba0 : Bnd a0 0 2097151) →
          (hbt58 : Bnd t58 0 8796093022207) →
          (hba1 : Bnd a1 0 2097151) →
          (hbt60 : Bnd t60 0 4194303) →
          (hba2 : Bnd a2 0 2097151) →
          (hbt62 : Bnd t62 (-9223372036854775808) 9223372036854775807) →
          (hba3 : Bnd a3 0 2097151) →
          (hbt64 : Bnd t64 0 17592186044415) →
          (hba4 : Bnd a4 0 2097151) →
          (hbt66 : Bnd t66 0 8388607) →
          (hba5 : Bnd a5 0 2097151) →
          (hbt68 : Bnd t68 (-9223372036854775808) 9223372036854775807) →
          (hba6 : Bnd a6 0 2097151) →
          (hbt70 : Bnd t70 0 35184372088831) →
          (hba7 : Bnd a7 0 2097151) →
          (hbt72 : Bnd t72 0 16777215) →
          (hba8 : Bnd a8 0 2097151) →
          (hbt74 : Bnd t74 (-9223372036854775808) 9223372036854775807) →
          (hba9 : Bnd a9 0 2097151) →
          (hbt76 : Bnd t76 0 70368744177663) →
          (hba10 : Bnd a10 0 2097151) →
          (hba11 : Bnd a11 0 33554431) →
          (hbb0 : Bnd b0 0 2097151) →
          (hbt80 : Bnd t80 0 8796093022207) →
          (hbb1 : Bnd b1 0 2097151) →
          (hbt82 : Bnd t82 0 4194303) →
          (hbb2 : Bnd b2 0 2097151) →
          (hbt84 : Bnd t84 (-9223372036854775808) 9223372036854775807) →
          (hbb3 : Bnd b3 0 2097151) →
          (hbt86 : Bnd t86 0 17592186044415) →
          (hbb4 : Bnd b4 0 2097151) →
          (hbt88 : Bnd t88 0 8388607) →
          (hbb5 : Bnd b5 0 2097151) →
          (hbt90 : Bnd t90 (-9223372036854775808) 9223372036854775807) →
          (hbb6 : Bnd b6 0 2097151) →
          (hbt92 : Bnd t92 0 35184372088831) →
          (hbb7 : Bnd b7 0 2097151) →
          (hbt94 : Bnd t94 0 16777215) →
          (hbb8 : Bnd b8 0 2097151) →
          (hbt96 : Bnd t96 (-9223372036854775808) 9223372036854775807) →
          (hbb9 : Bnd b9 0 2097151) →
          (hbt98 : Bnd t98 0 70368744177663) →
          (hbb10 : Bnd b10 0 2097151) →
          (hbb11 : Bnd b11 0 33554431) →
          (hbc0 : Bnd c0 0 2097151) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 102 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 57 S >>= g) = K := by
  step_pure with a0
  sbnd a0
  step_pure with t58
  sbnd t58
  step_pure with a1
  sbnd a1
  step_pure with t60
  sbnd t60
  step_pure with a2
  sbnd a2
  step_pure with t62
  sbnd t62
  step_pure with a3
  sbnd a3
  step_pure with t64
  sbnd t64
  step_pure with a4
  sbnd a4
  step_pure with t66
  sbnd t66
  step_pure with a5
  sbnd a5
  step_pure with t68
  sbnd t68
  step_pure with a6
  sbnd a6
  step_pure with t70
  sbnd t70
  step_pure with a7
  sbnd a7
  step_pure with t72
  sbnd t72
  step_pure with a8
  sbnd a8
  step_pure with t74
  sbnd t74
  step_pure with a9
  sbnd a9
  step_pure with t76
  sbnd t76
  step_pure with a10
  sbnd a10
  step_pure with a11
  sbnd a11
  step_pure with b0
  sbnd b0
  step_pure with t80
  sbnd t80
  step_pure with b1
  sbnd b1
  step_pure with t82
  sbnd t82
  step_pure with b2
  sbnd b2
  step_pure with t84
  sbnd t84
  step_pure with b3
  sbnd b3
  step_pure with t86
  sbnd t86
  step_pure with b4
  sbnd b4
  step_pure with t88
  sbnd t88
  step_pure with b5
  sbnd b5
  step_pure with t90
  sbnd t90
  step_pure with b6
  sbnd b6
  step_pure with t92
  sbnd t92
  step_pure with b7
  sbnd b7
  step_pure with t94
  sbnd t94
  step_pure with b8
  sbnd b8
  step_pure with t96
  sbnd t96
  step_pure with b9
  sbnd b9
  step_pure with t98
  sbnd t98
  step_pure with b10
  sbnd b10
  step_pure with b11
  sbnd b11
  step_pure with c0
  sbnd c0
  exact
    hK _ a0 t58 a1 t60 a2 t62 a3 t64 a4 t66 a5 t68 a6 t70 a7 t72 a8 t74 a9 t76 a10 a11 b0 t80 b1 t82
      b2 t84 b3 t86 b4 t88 b5 t90 b6 t92 b7 t94 b8 t96 b9 t98 b10 b11 c0 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ha0 ht58 ha1 ht60 ha2 ht62 ha3 ht64 ha4 ht66 ha5 ht68 ha6 ht70 ha7 ht72 ha8
      ht74 ha9 ht76 ha10 ha11 hb0 ht80 hb1 ht82 hb2 ht84 hb3 ht86 hb4 ht88 hb5 ht90 hb6 ht92 hb7
      ht94 hb8 ht96 hb9 ht98 hb10 hb11 hc0 hba0 hbt58 hba1 hbt60 hba2 hbt62 hba3 hbt64 hba4 hbt66
      hba5 hbt68 hba6 hbt70 hba7 hbt72 hba8 hbt74 hba9 hbt76 hba10 hba11 hbb0 hbt80 hbb1 hbt82 hbb2
      hbt84 hbb3 hbt86 hbb4 hbt88 hbb5 hbt90 hbb6 hbt92 hbb7 hbt94 hbb8 hbt96 hbb9 hbt98 hbb10 hbb11
      hbc0

/-- From `%102`: `c1` … `s4`. -/
theorem fd_curve25519_scalar_muladd.run102 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {ic0 ic1 ic2 ic3 a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11
      c0 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 38 := ic0,
        rir_reg% fd_curve25519_scalar_muladd.hty 44 := ic1,
        rir_reg% fd_curve25519_scalar_muladd.hty 50 := ic2,
        rir_reg% fd_curve25519_scalar_muladd.hty 56 := ic3,
        rir_reg% fd_curve25519_scalar_muladd.hty 57 := a0,
        rir_reg% fd_curve25519_scalar_muladd.hty 59 := a1,
        rir_reg% fd_curve25519_scalar_muladd.hty 61 := a2,
        rir_reg% fd_curve25519_scalar_muladd.hty 63 := a3,
        rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
        rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
        rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
        rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
        rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
        rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
        rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
        rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
        rir_reg% fd_curve25519_scalar_muladd.hty 79 := b0,
        rir_reg% fd_curve25519_scalar_muladd.hty 81 := b1,
        rir_reg% fd_curve25519_scalar_muladd.hty 83 := b2,
        rir_reg% fd_curve25519_scalar_muladd.hty 85 := b3,
        rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
        rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
        rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
        rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
        rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
        rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
        rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
        rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
        rir_reg% fd_curve25519_scalar_muladd.hty 101 := c0])
    (hba0 : Bnd a0 0 2097151) (hba1 : Bnd a1 0 2097151) (hba2 : Bnd a2 0 2097151)
    (hba3 : Bnd a3 0 2097151) (hba4 : Bnd a4 0 2097151) (hbb0 : Bnd b0 0 2097151)
    (hbb1 : Bnd b1 0 2097151) (hbb2 : Bnd b2 0 2097151) (hbb3 : Bnd b3 0 2097151)
    (hbb4 : Bnd b4 0 2097151) (hbc0 : Bnd c0 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t102 c1 t104 c2 t106 c3 t108 c4 t110 c5 t112 c6 t114 c7 t116 c8 t118 c9 t120 c10 c11 t123
          s0 t125 t126 t127 t128 t129 t130 t131 s2 t133 t134 t135 t136 t137 t138 t139 t140 t141 t142
          t143 t144 t145 s4 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 57 := a0,
              rir_reg% fd_curve25519_scalar_muladd.hty 59 := a1,
              rir_reg% fd_curve25519_scalar_muladd.hty 61 := a2,
              rir_reg% fd_curve25519_scalar_muladd.hty 63 := a3,
              rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
              rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
              rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
              rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
              rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
              rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
              rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
              rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
              rir_reg% fd_curve25519_scalar_muladd.hty 79 := b0,
              rir_reg% fd_curve25519_scalar_muladd.hty 81 := b1,
              rir_reg% fd_curve25519_scalar_muladd.hty 83 := b2,
              rir_reg% fd_curve25519_scalar_muladd.hty 85 := b3,
              rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
              rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
              rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
              rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
              rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
              rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
              rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
              rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
              rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
              rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
              rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
              rir_reg% fd_curve25519_scalar_muladd.hty 113 := c6,
              rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
              rir_reg% fd_curve25519_scalar_muladd.hty 117 := c8,
              rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
              rir_reg% fd_curve25519_scalar_muladd.hty 121 := c10,
              rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
              rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
              rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
              rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
              rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
              rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
              rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
              rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
              rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
              rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4]) →
          (ht102 : t102 = ic0 >>> 21) →
          (hc1 : c1 = t102 &&& 2097151#64) →
          (ht104 : t104 = ic0 >>> 42) →
          (hc2 : c2 = t104 &&& 2097151#64) →
          (ht106 : t106 = BitVec.extractLsb' 64 64 ((ic1 ++ ic0) <<< 1)) →
          (hc3 : c3 = t106 &&& 2097151#64) →
          (ht108 : t108 = ic1 >>> 20) →
          (hc4 : c4 = t108 &&& 2097151#64) →
          (ht110 : t110 = ic1 >>> 41) →
          (hc5 : c5 = t110 &&& 2097151#64) →
          (ht112 : t112 = BitVec.extractLsb' 64 64 ((ic2 ++ ic1) <<< 2)) →
          (hc6 : c6 = t112 &&& 2097151#64) →
          (ht114 : t114 = ic2 >>> 19) →
          (hc7 : c7 = t114 &&& 2097151#64) →
          (ht116 : t116 = ic2 >>> 40) →
          (hc8 : c8 = t116 &&& 2097151#64) →
          (ht118 : t118 = BitVec.extractLsb' 64 64 ((ic3 ++ ic2) <<< 3)) →
          (hc9 : c9 = t118 &&& 2097151#64) →
          (ht120 : t120 = ic3 >>> 18) →
          (hc10 : c10 = t120 &&& 2097151#64) →
          (hc11 : c11 = ic3 >>> 39) →
          (ht123 : t123 = b0 * a0) →
          (hs0 : s0 = c0 + t123) →
          (ht125 : t125 = b1 * a0) →
          (ht126 : t126 = a1 * b0) →
          (ht127 : t127 = b2 * a0) →
          (ht128 : t128 = b1 * a1) →
          (ht129 : t129 = a2 * b0) →
          (ht130 : t130 = t127 + t129) →
          (ht131 : t131 = t130 + c2) →
          (hs2 : s2 = t131 + t128) →
          (ht133 : t133 = b3 * a0) →
          (ht134 : t134 = b2 * a1) →
          (ht135 : t135 = b1 * a2) →
          (ht136 : t136 = a3 * b0) →
          (ht137 : t137 = b4 * a0) →
          (ht138 : t138 = b3 * a1) →
          (ht139 : t139 = b2 * a2) →
          (ht140 : t140 = a3 * b1) →
          (ht141 : t141 = a4 * b0) →
          (ht142 : t142 = t140 + t139) →
          (ht143 : t143 = t142 + t141) →
          (ht144 : t144 = t143 + t137) →
          (ht145 : t145 = t144 + c4) →
          (hs4 : s4 = t145 + t138) →
          (hbt102 : Bnd t102 0 8796093022207) →
          (hbc1 : Bnd c1 0 2097151) →
          (hbt104 : Bnd t104 0 4194303) →
          (hbc2 : Bnd c2 0 2097151) →
          (hbt106 : Bnd t106 (-9223372036854775808) 9223372036854775807) →
          (hbc3 : Bnd c3 0 2097151) →
          (hbt108 : Bnd t108 0 17592186044415) →
          (hbc4 : Bnd c4 0 2097151) →
          (hbt110 : Bnd t110 0 8388607) →
          (hbc5 : Bnd c5 0 2097151) →
          (hbt112 : Bnd t112 (-9223372036854775808) 9223372036854775807) →
          (hbc6 : Bnd c6 0 2097151) →
          (hbt114 : Bnd t114 0 35184372088831) →
          (hbc7 : Bnd c7 0 2097151) →
          (hbt116 : Bnd t116 0 16777215) →
          (hbc8 : Bnd c8 0 2097151) →
          (hbt118 : Bnd t118 (-9223372036854775808) 9223372036854775807) →
          (hbc9 : Bnd c9 0 2097151) →
          (hbt120 : Bnd t120 0 70368744177663) →
          (hbc10 : Bnd c10 0 2097151) →
          (hbc11 : Bnd c11 0 33554431) →
          (hbt123 : Bnd t123 0 4398042316801) →
          (hbs0 : Bnd s0 0 4398044413952) →
          (hbt125 : Bnd t125 0 4398042316801) →
          (hbt126 : Bnd t126 0 4398042316801) →
          (hbt127 : Bnd t127 0 4398042316801) →
          (hbt128 : Bnd t128 0 4398042316801) →
          (hbt129 : Bnd t129 0 4398042316801) →
          (hbt130 : Bnd t130 0 8796084633602) →
          (hbt131 : Bnd t131 0 8796086730753) →
          (hbs2 : Bnd s2 0 13194129047554) →
          (hbt133 : Bnd t133 0 4398042316801) →
          (hbt134 : Bnd t134 0 4398042316801) →
          (hbt135 : Bnd t135 0 4398042316801) →
          (hbt136 : Bnd t136 0 4398042316801) →
          (hbt137 : Bnd t137 0 4398042316801) →
          (hbt138 : Bnd t138 0 4398042316801) →
          (hbt139 : Bnd t139 0 4398042316801) →
          (hbt140 : Bnd t140 0 4398042316801) →
          (hbt141 : Bnd t141 0 4398042316801) →
          (hbt142 : Bnd t142 0 8796084633602) →
          (hbt143 : Bnd t143 0 13194126950403) →
          (hbt144 : Bnd t144 0 17592169267204) →
          (hbt145 : Bnd t145 0 17592171364355) →
          (hbs4 : Bnd s4 0 21990213681156) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 147 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 102 S >>= g) = K := by
  step_pure with t102
  sbnd t102
  step_pure with c1
  sbnd c1
  step_pure with t104
  sbnd t104
  step_pure with c2
  sbnd c2
  step_pure with t106
  sbnd t106
  step_pure with c3
  sbnd c3
  step_pure with t108
  sbnd t108
  step_pure with c4
  sbnd c4
  step_pure with t110
  sbnd t110
  step_pure with c5
  sbnd c5
  step_pure with t112
  sbnd t112
  step_pure with c6
  sbnd c6
  step_pure with t114
  sbnd t114
  step_pure with c7
  sbnd c7
  step_pure with t116
  sbnd t116
  step_pure with c8
  sbnd c8
  step_pure with t118
  sbnd t118
  step_pure with c9
  sbnd c9
  step_pure with t120
  sbnd t120
  step_pure with c10
  sbnd c10
  step_pure with c11
  sbnd c11
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t123
  sbnd t123
  step_pure [nswAdd, nuwAdd] with s0
  sbnd s0
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t125
  sbnd t125
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t126
  sbnd t126
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t127
  sbnd t127
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t128
  sbnd t128
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t129
  sbnd t129
  step_pure [nswAdd, nuwAdd] with t130
  sbnd t130
  step_pure [nswAdd, nuwAdd] with t131
  sbnd t131
  step_pure [nswAdd, nuwAdd] with s2
  sbnd s2
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t133
  sbnd t133
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t134
  sbnd t134
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t135
  sbnd t135
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t136
  sbnd t136
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t137
  sbnd t137
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t138
  sbnd t138
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t139
  sbnd t139
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t140
  sbnd t140
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t141
  sbnd t141
  step_pure [nswAdd, nuwAdd] with t142
  sbnd t142
  step_pure [nswAdd, nuwAdd] with t143
  sbnd t143
  step_pure [nswAdd, nuwAdd] with t144
  sbnd t144
  step_pure [nswAdd, nuwAdd] with t145
  sbnd t145
  step_pure [nswAdd, nuwAdd] with s4
  sbnd s4
  exact
    hK _ t102 c1 t104 c2 t106 c3 t108 c4 t110 c5 t112 c6 t114 c7 t116 c8 t118 c9 t120 c10 c11 t123
      s0 t125 t126 t127 t128 t129 t130 t131 s2 t133 t134 t135 t136 t137 t138 t139 t140 t141 t142
      t143 t144 t145 s4 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht102 hc1 ht104 hc2 ht106 hc3 ht108 hc4 ht110 hc5 ht112 hc6 ht114 hc7 ht116 hc8
      ht118 hc9 ht120 hc10 hc11 ht123 hs0 ht125 ht126 ht127 ht128 ht129 ht130 ht131 hs2 ht133 ht134
      ht135 ht136 ht137 ht138 ht139 ht140 ht141 ht142 ht143 ht144 ht145 hs4 hbt102 hbc1 hbt104 hbc2
      hbt106 hbc3 hbt108 hbc4 hbt110 hbc5 hbt112 hbc6 hbt114 hbc7 hbt116 hbc8 hbt118 hbc9 hbt120
      hbc10 hbc11 hbt123 hbs0 hbt125 hbt126 hbt127 hbt128 hbt129 hbt130 hbt131 hbs2 hbt133 hbt134
      hbt135 hbt136 hbt137 hbt138 hbt139 hbt140 hbt141 hbt142 hbt143 hbt144 hbt145 hbs4

/-- From `%147`: `s6`. -/
theorem fd_curve25519_scalar_muladd.run147 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c1 c3 c5 c6 c7 c8
      c9 c10 c11 s0 t125 t126 s2 t133 t134 t135 t136 s4 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 57 := a0,
        rir_reg% fd_curve25519_scalar_muladd.hty 59 := a1,
        rir_reg% fd_curve25519_scalar_muladd.hty 61 := a2,
        rir_reg% fd_curve25519_scalar_muladd.hty 63 := a3,
        rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
        rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
        rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
        rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
        rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
        rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
        rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
        rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
        rir_reg% fd_curve25519_scalar_muladd.hty 79 := b0,
        rir_reg% fd_curve25519_scalar_muladd.hty 81 := b1,
        rir_reg% fd_curve25519_scalar_muladd.hty 83 := b2,
        rir_reg% fd_curve25519_scalar_muladd.hty 85 := b3,
        rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
        rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
        rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
        rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
        rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
        rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
        rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
        rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
        rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
        rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
        rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
        rir_reg% fd_curve25519_scalar_muladd.hty 113 := c6,
        rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
        rir_reg% fd_curve25519_scalar_muladd.hty 117 := c8,
        rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
        rir_reg% fd_curve25519_scalar_muladd.hty 121 := c10,
        rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
        rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
        rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
        rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
        rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
        rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
        rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
        rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
        rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
        rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4])
    (hba0 : Bnd a0 0 2097151) (hba1 : Bnd a1 0 2097151) (hba2 : Bnd a2 0 2097151)
    (hba3 : Bnd a3 0 2097151) (hba4 : Bnd a4 0 2097151) (hba5 : Bnd a5 0 2097151)
    (hba6 : Bnd a6 0 2097151) (hba7 : Bnd a7 0 2097151) (hba8 : Bnd a8 0 2097151)
    (hbb0 : Bnd b0 0 2097151) (hbb1 : Bnd b1 0 2097151) (hbb2 : Bnd b2 0 2097151)
    (hbb3 : Bnd b3 0 2097151) (hbb4 : Bnd b4 0 2097151) (hbb5 : Bnd b5 0 2097151)
    (hbb6 : Bnd b6 0 2097151) (hbb7 : Bnd b7 0 2097151) (hbb8 : Bnd b8 0 2097151)
    (hbc6 : Bnd c6 0 2097151) (hbc8 : Bnd c8 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t147 t148 t149 t150 t151 t152 t153 t154 t155 t156 t157 t158 t159 t160 t161 t162 t163 t164
          t165 s6 t167 t168 t169 t170 t171 t172 t173 t174 t175 t176 t177 t178 t179 t180 t181 t182
          t183 t184 t185 t186 t187 t188 t189 t190 t191 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 57 := a0,
              rir_reg% fd_curve25519_scalar_muladd.hty 59 := a1,
              rir_reg% fd_curve25519_scalar_muladd.hty 61 := a2,
              rir_reg% fd_curve25519_scalar_muladd.hty 63 := a3,
              rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
              rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
              rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
              rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
              rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
              rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
              rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
              rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
              rir_reg% fd_curve25519_scalar_muladd.hty 79 := b0,
              rir_reg% fd_curve25519_scalar_muladd.hty 81 := b1,
              rir_reg% fd_curve25519_scalar_muladd.hty 83 := b2,
              rir_reg% fd_curve25519_scalar_muladd.hty 85 := b3,
              rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
              rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
              rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
              rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
              rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
              rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
              rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
              rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
              rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
              rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
              rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
              rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
              rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
              rir_reg% fd_curve25519_scalar_muladd.hty 121 := c10,
              rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
              rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
              rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
              rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
              rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
              rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
              rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
              rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
              rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
              rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4,
              rir_reg% fd_curve25519_scalar_muladd.hty 147 := t147,
              rir_reg% fd_curve25519_scalar_muladd.hty 148 := t148,
              rir_reg% fd_curve25519_scalar_muladd.hty 149 := t149,
              rir_reg% fd_curve25519_scalar_muladd.hty 150 := t150,
              rir_reg% fd_curve25519_scalar_muladd.hty 151 := t151,
              rir_reg% fd_curve25519_scalar_muladd.hty 152 := t152,
              rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
              rir_reg% fd_curve25519_scalar_muladd.hty 167 := t167,
              rir_reg% fd_curve25519_scalar_muladd.hty 168 := t168,
              rir_reg% fd_curve25519_scalar_muladd.hty 169 := t169,
              rir_reg% fd_curve25519_scalar_muladd.hty 170 := t170,
              rir_reg% fd_curve25519_scalar_muladd.hty 171 := t171,
              rir_reg% fd_curve25519_scalar_muladd.hty 172 := t172,
              rir_reg% fd_curve25519_scalar_muladd.hty 173 := t173,
              rir_reg% fd_curve25519_scalar_muladd.hty 174 := t174,
              rir_reg% fd_curve25519_scalar_muladd.hty 177 := t177,
              rir_reg% fd_curve25519_scalar_muladd.hty 191 := t191]) →
          (ht147 : t147 = b5 * a0) →
          (ht148 : t148 = b4 * a1) →
          (ht149 : t149 = b3 * a2) →
          (ht150 : t150 = a3 * b2) →
          (ht151 : t151 = a4 * b1) →
          (ht152 : t152 = a5 * b0) →
          (ht153 : t153 = b6 * a0) →
          (ht154 : t154 = b5 * a1) →
          (ht155 : t155 = b4 * a2) →
          (ht156 : t156 = b3 * a3) →
          (ht157 : t157 = a4 * b2) →
          (ht158 : t158 = a5 * b1) →
          (ht159 : t159 = a6 * b0) →
          (ht160 : t160 = t158 + t157) →
          (ht161 : t161 = t160 + t154) →
          (ht162 : t162 = t161 + t155) →
          (ht163 : t163 = t162 + t156) →
          (ht164 : t164 = t163 + t159) →
          (ht165 : t165 = t164 + t153) →
          (hs6 : s6 = t165 + c6) →
          (ht167 : t167 = b7 * a0) →
          (ht168 : t168 = b6 * a1) →
          (ht169 : t169 = b5 * a2) →
          (ht170 : t170 = b4 * a3) →
          (ht171 : t171 = b3 * a4) →
          (ht172 : t172 = a5 * b2) →
          (ht173 : t173 = a6 * b1) →
          (ht174 : t174 = a7 * b0) →
          (ht175 : t175 = b8 * a0) →
          (ht176 : t176 = b7 * a1) →
          (ht177 : t177 = b6 * a2) →
          (ht178 : t178 = b5 * a3) →
          (ht179 : t179 = b4 * a4) →
          (ht180 : t180 = b3 * a5) →
          (ht181 : t181 = a6 * b2) →
          (ht182 : t182 = a7 * b1) →
          (ht183 : t183 = a8 * b0) →
          (ht184 : t184 = t179 + t178) →
          (ht185 : t185 = t184 + t180) →
          (ht186 : t186 = t185 + t181) →
          (ht187 : t187 = t186 + t182) →
          (ht188 : t188 = t187 + t183) →
          (ht189 : t189 = t188 + t175) →
          (ht190 : t190 = t189 + c8) →
          (ht191 : t191 = t190 + t176) →
          (hbt147 : Bnd t147 0 4398042316801) →
          (hbt148 : Bnd t148 0 4398042316801) →
          (hbt149 : Bnd t149 0 4398042316801) →
          (hbt150 : Bnd t150 0 4398042316801) →
          (hbt151 : Bnd t151 0 4398042316801) →
          (hbt152 : Bnd t152 0 4398042316801) →
          (hbt153 : Bnd t153 0 4398042316801) →
          (hbt154 : Bnd t154 0 4398042316801) →
          (hbt155 : Bnd t155 0 4398042316801) →
          (hbt156 : Bnd t156 0 4398042316801) →
          (hbt157 : Bnd t157 0 4398042316801) →
          (hbt158 : Bnd t158 0 4398042316801) →
          (hbt159 : Bnd t159 0 4398042316801) →
          (hbt160 : Bnd t160 0 8796084633602) →
          (hbt161 : Bnd t161 0 13194126950403) →
          (hbt162 : Bnd t162 0 17592169267204) →
          (hbt163 : Bnd t163 0 21990211584005) →
          (hbt164 : Bnd t164 0 26388253900806) →
          (hbt165 : Bnd t165 0 30786296217607) →
          (hbs6 : Bnd s6 0 30786298314758) →
          (hbt167 : Bnd t167 0 4398042316801) →
          (hbt168 : Bnd t168 0 4398042316801) →
          (hbt169 : Bnd t169 0 4398042316801) →
          (hbt170 : Bnd t170 0 4398042316801) →
          (hbt171 : Bnd t171 0 4398042316801) →
          (hbt172 : Bnd t172 0 4398042316801) →
          (hbt173 : Bnd t173 0 4398042316801) →
          (hbt174 : Bnd t174 0 4398042316801) →
          (hbt175 : Bnd t175 0 4398042316801) →
          (hbt176 : Bnd t176 0 4398042316801) →
          (hbt177 : Bnd t177 0 4398042316801) →
          (hbt178 : Bnd t178 0 4398042316801) →
          (hbt179 : Bnd t179 0 4398042316801) →
          (hbt180 : Bnd t180 0 4398042316801) →
          (hbt181 : Bnd t181 0 4398042316801) →
          (hbt182 : Bnd t182 0 4398042316801) →
          (hbt183 : Bnd t183 0 4398042316801) →
          (hbt184 : Bnd t184 0 8796084633602) →
          (hbt185 : Bnd t185 0 13194126950403) →
          (hbt186 : Bnd t186 0 17592169267204) →
          (hbt187 : Bnd t187 0 21990211584005) →
          (hbt188 : Bnd t188 0 26388253900806) →
          (hbt189 : Bnd t189 0 30786296217607) →
          (hbt190 : Bnd t190 0 30786298314758) →
          (hbt191 : Bnd t191 0 35184340631559) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 192 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 147 S >>= g) = K := by
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t147
  sbnd t147
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t148
  sbnd t148
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t149
  sbnd t149
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t150
  sbnd t150
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t151
  sbnd t151
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t152
  sbnd t152
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t153
  sbnd t153
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t154
  sbnd t154
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t155
  sbnd t155
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t156
  sbnd t156
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t157
  sbnd t157
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t158
  sbnd t158
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t159
  sbnd t159
  step_pure [nswAdd, nuwAdd] with t160
  sbnd t160
  step_pure [nswAdd, nuwAdd] with t161
  sbnd t161
  step_pure [nswAdd, nuwAdd] with t162
  sbnd t162
  step_pure [nswAdd, nuwAdd] with t163
  sbnd t163
  step_pure [nswAdd, nuwAdd] with t164
  sbnd t164
  step_pure [nswAdd, nuwAdd] with t165
  sbnd t165
  step_pure [nswAdd, nuwAdd] with s6
  sbnd s6
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t167
  sbnd t167
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t168
  sbnd t168
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t169
  sbnd t169
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t170
  sbnd t170
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t171
  sbnd t171
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t172
  sbnd t172
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t173
  sbnd t173
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t174
  sbnd t174
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t175
  sbnd t175
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t176
  sbnd t176
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t177
  sbnd t177
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t178
  sbnd t178
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t179
  sbnd t179
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t180
  sbnd t180
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t181
  sbnd t181
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t182
  sbnd t182
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t183
  sbnd t183
  step_pure [nswAdd, nuwAdd] with t184
  sbnd t184
  step_pure [nswAdd, nuwAdd] with t185
  sbnd t185
  step_pure [nswAdd, nuwAdd] with t186
  sbnd t186
  step_pure [nswAdd, nuwAdd] with t187
  sbnd t187
  step_pure [nswAdd, nuwAdd] with t188
  sbnd t188
  step_pure [nswAdd, nuwAdd] with t189
  sbnd t189
  step_pure [nswAdd, nuwAdd] with t190
  sbnd t190
  step_pure [nswAdd, nuwAdd] with t191
  sbnd t191
  exact
    hK _ t147 t148 t149 t150 t151 t152 t153 t154 t155 t156 t157 t158 t159 t160 t161 t162 t163 t164
      t165 s6 t167 t168 t169 t170 t171 t172 t173 t174 t175 t176 t177 t178 t179 t180 t181 t182 t183
      t184 t185 t186 t187 t188 t189 t190 t191 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht147 ht148 ht149 ht150 ht151 ht152 ht153 ht154 ht155 ht156 ht157 ht158 ht159
      ht160 ht161 ht162 ht163 ht164 ht165 hs6 ht167 ht168 ht169 ht170 ht171 ht172 ht173 ht174 ht175
      ht176 ht177 ht178 ht179 ht180 ht181 ht182 ht183 ht184 ht185 ht186 ht187 ht188 ht189 ht190
      ht191 hbt147 hbt148 hbt149 hbt150 hbt151 hbt152 hbt153 hbt154 hbt155 hbt156 hbt157 hbt158
      hbt159 hbt160 hbt161 hbt162 hbt163 hbt164 hbt165 hbs6 hbt167 hbt168 hbt169 hbt170 hbt171
      hbt172 hbt173 hbt174 hbt175 hbt176 hbt177 hbt178 hbt179 hbt180 hbt181 hbt182 hbt183 hbt184
      hbt185 hbt186 hbt187 hbt188 hbt189 hbt190 hbt191

/-- From `%192`: `s8` … `s10`. -/
theorem fd_curve25519_scalar_muladd.run192 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c1 c3 c5 c7 c9 c10
      c11 s0 t125 t126 s2 t133 t134 t135 t136 s4 t147 t148 t149 t150 t151 t152 s6 t167 t168 t169
      t170 t171 t172 t173 t174 t177 t191 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 57 := a0,
        rir_reg% fd_curve25519_scalar_muladd.hty 59 := a1,
        rir_reg% fd_curve25519_scalar_muladd.hty 61 := a2,
        rir_reg% fd_curve25519_scalar_muladd.hty 63 := a3,
        rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
        rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
        rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
        rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
        rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
        rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
        rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
        rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
        rir_reg% fd_curve25519_scalar_muladd.hty 79 := b0,
        rir_reg% fd_curve25519_scalar_muladd.hty 81 := b1,
        rir_reg% fd_curve25519_scalar_muladd.hty 83 := b2,
        rir_reg% fd_curve25519_scalar_muladd.hty 85 := b3,
        rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
        rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
        rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
        rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
        rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
        rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
        rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
        rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
        rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
        rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
        rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
        rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
        rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
        rir_reg% fd_curve25519_scalar_muladd.hty 121 := c10,
        rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
        rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
        rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
        rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
        rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
        rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
        rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
        rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
        rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
        rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4,
        rir_reg% fd_curve25519_scalar_muladd.hty 147 := t147,
        rir_reg% fd_curve25519_scalar_muladd.hty 148 := t148,
        rir_reg% fd_curve25519_scalar_muladd.hty 149 := t149,
        rir_reg% fd_curve25519_scalar_muladd.hty 150 := t150,
        rir_reg% fd_curve25519_scalar_muladd.hty 151 := t151,
        rir_reg% fd_curve25519_scalar_muladd.hty 152 := t152,
        rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
        rir_reg% fd_curve25519_scalar_muladd.hty 167 := t167,
        rir_reg% fd_curve25519_scalar_muladd.hty 168 := t168,
        rir_reg% fd_curve25519_scalar_muladd.hty 169 := t169,
        rir_reg% fd_curve25519_scalar_muladd.hty 170 := t170,
        rir_reg% fd_curve25519_scalar_muladd.hty 171 := t171,
        rir_reg% fd_curve25519_scalar_muladd.hty 172 := t172,
        rir_reg% fd_curve25519_scalar_muladd.hty 173 := t173,
        rir_reg% fd_curve25519_scalar_muladd.hty 174 := t174,
        rir_reg% fd_curve25519_scalar_muladd.hty 177 := t177,
        rir_reg% fd_curve25519_scalar_muladd.hty 191 := t191])
    (hba0 : Bnd a0 0 2097151) (hba1 : Bnd a1 0 2097151) (hba2 : Bnd a2 0 2097151)
    (hba3 : Bnd a3 0 2097151) (hba4 : Bnd a4 0 2097151) (hba5 : Bnd a5 0 2097151)
    (hba6 : Bnd a6 0 2097151) (hba7 : Bnd a7 0 2097151) (hba8 : Bnd a8 0 2097151)
    (hba9 : Bnd a9 0 2097151) (hba10 : Bnd a10 0 2097151) (hba11 : Bnd a11 0 33554431)
    (hbb0 : Bnd b0 0 2097151) (hbb1 : Bnd b1 0 2097151) (hbb2 : Bnd b2 0 2097151)
    (hbb3 : Bnd b3 0 2097151) (hbb4 : Bnd b4 0 2097151) (hbb5 : Bnd b5 0 2097151)
    (hbb6 : Bnd b6 0 2097151) (hbb7 : Bnd b7 0 2097151) (hbb8 : Bnd b8 0 2097151)
    (hbb9 : Bnd b9 0 2097151) (hbb10 : Bnd b10 0 2097151) (hbb11 : Bnd b11 0 33554431)
    (hbc10 : Bnd c10 0 2097151) (hbt177 : Bnd t177 0 4398042316801)
    (hbt191 : Bnd t191 0 35184340631559)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (s8 t193 t194 t195 t196 t197 t198 t199 t200 t201 t202 t203 t204 t205 t206 t207 t208 t209
          t210 t211 t212 t213 t214 t215 t216 t217 t218 t219 t220 t221 t222 t223 s10 t225 t226 t227
          t228 t229 t230 t231 t232 t233 t234 t235 t236 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 59 := a1,
              rir_reg% fd_curve25519_scalar_muladd.hty 61 := a2,
              rir_reg% fd_curve25519_scalar_muladd.hty 63 := a3,
              rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
              rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
              rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
              rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
              rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
              rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
              rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
              rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
              rir_reg% fd_curve25519_scalar_muladd.hty 81 := b1,
              rir_reg% fd_curve25519_scalar_muladd.hty 83 := b2,
              rir_reg% fd_curve25519_scalar_muladd.hty 85 := b3,
              rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
              rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
              rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
              rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
              rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
              rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
              rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
              rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
              rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
              rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
              rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
              rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
              rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
              rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
              rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
              rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
              rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
              rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
              rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
              rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
              rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
              rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
              rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4,
              rir_reg% fd_curve25519_scalar_muladd.hty 147 := t147,
              rir_reg% fd_curve25519_scalar_muladd.hty 148 := t148,
              rir_reg% fd_curve25519_scalar_muladd.hty 149 := t149,
              rir_reg% fd_curve25519_scalar_muladd.hty 150 := t150,
              rir_reg% fd_curve25519_scalar_muladd.hty 151 := t151,
              rir_reg% fd_curve25519_scalar_muladd.hty 152 := t152,
              rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
              rir_reg% fd_curve25519_scalar_muladd.hty 167 := t167,
              rir_reg% fd_curve25519_scalar_muladd.hty 168 := t168,
              rir_reg% fd_curve25519_scalar_muladd.hty 169 := t169,
              rir_reg% fd_curve25519_scalar_muladd.hty 170 := t170,
              rir_reg% fd_curve25519_scalar_muladd.hty 171 := t171,
              rir_reg% fd_curve25519_scalar_muladd.hty 172 := t172,
              rir_reg% fd_curve25519_scalar_muladd.hty 173 := t173,
              rir_reg% fd_curve25519_scalar_muladd.hty 174 := t174,
              rir_reg% fd_curve25519_scalar_muladd.hty 192 := s8,
              rir_reg% fd_curve25519_scalar_muladd.hty 193 := t193,
              rir_reg% fd_curve25519_scalar_muladd.hty 194 := t194,
              rir_reg% fd_curve25519_scalar_muladd.hty 195 := t195,
              rir_reg% fd_curve25519_scalar_muladd.hty 196 := t196,
              rir_reg% fd_curve25519_scalar_muladd.hty 197 := t197,
              rir_reg% fd_curve25519_scalar_muladd.hty 198 := t198,
              rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199,
              rir_reg% fd_curve25519_scalar_muladd.hty 200 := t200,
              rir_reg% fd_curve25519_scalar_muladd.hty 201 := t201,
              rir_reg% fd_curve25519_scalar_muladd.hty 202 := t202,
              rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
              rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225,
              rir_reg% fd_curve25519_scalar_muladd.hty 226 := t226,
              rir_reg% fd_curve25519_scalar_muladd.hty 227 := t227,
              rir_reg% fd_curve25519_scalar_muladd.hty 228 := t228,
              rir_reg% fd_curve25519_scalar_muladd.hty 229 := t229,
              rir_reg% fd_curve25519_scalar_muladd.hty 230 := t230,
              rir_reg% fd_curve25519_scalar_muladd.hty 231 := t231,
              rir_reg% fd_curve25519_scalar_muladd.hty 232 := t232,
              rir_reg% fd_curve25519_scalar_muladd.hty 233 := t233,
              rir_reg% fd_curve25519_scalar_muladd.hty 234 := t234,
              rir_reg% fd_curve25519_scalar_muladd.hty 235 := t235,
              rir_reg% fd_curve25519_scalar_muladd.hty 236 := t236]) →
          (hs8 : s8 = t191 + t177) →
          (ht193 : t193 = b9 * a0) →
          (ht194 : t194 = b8 * a1) →
          (ht195 : t195 = b7 * a2) →
          (ht196 : t196 = b6 * a3) →
          (ht197 : t197 = b5 * a4) →
          (ht198 : t198 = b4 * a5) →
          (ht199 : t199 = a6 * b3) →
          (ht200 : t200 = a7 * b2) →
          (ht201 : t201 = a8 * b1) →
          (ht202 : t202 = a9 * b0) →
          (ht203 : t203 = b10 * a0) →
          (ht204 : t204 = b9 * a1) →
          (ht205 : t205 = b8 * a2) →
          (ht206 : t206 = b7 * a3) →
          (ht207 : t207 = b6 * a4) →
          (ht208 : t208 = b5 * a5) →
          (ht209 : t209 = a6 * b4) →
          (ht210 : t210 = a7 * b3) →
          (ht211 : t211 = a8 * b2) →
          (ht212 : t212 = a9 * b1) →
          (ht213 : t213 = a10 * b0) →
          (ht214 : t214 = t209 + t208) →
          (ht215 : t215 = t214 + t210) →
          (ht216 : t216 = t215 + t211) →
          (ht217 : t217 = t216 + t205) →
          (ht218 : t218 = t217 + t206) →
          (ht219 : t219 = t218 + t207) →
          (ht220 : t220 = t219 + t212) →
          (ht221 : t221 = t220 + t213) →
          (ht222 : t222 = t221 + t203) →
          (ht223 : t223 = t222 + c10) →
          (hs10 : s10 = t223 + t204) →
          (ht225 : t225 = b11 * a0) →
          (ht226 : t226 = b10 * a1) →
          (ht227 : t227 = b9 * a2) →
          (ht228 : t228 = b8 * a3) →
          (ht229 : t229 = b7 * a4) →
          (ht230 : t230 = b6 * a5) →
          (ht231 : t231 = a6 * b5) →
          (ht232 : t232 = a7 * b4) →
          (ht233 : t233 = a8 * b3) →
          (ht234 : t234 = a9 * b2) →
          (ht235 : t235 = a10 * b1) →
          (ht236 : t236 = a11 * b0) →
          (hbs8 : Bnd s8 0 39582382948360) →
          (hbt193 : Bnd t193 0 4398042316801) →
          (hbt194 : Bnd t194 0 4398042316801) →
          (hbt195 : Bnd t195 0 4398042316801) →
          (hbt196 : Bnd t196 0 4398042316801) →
          (hbt197 : Bnd t197 0 4398042316801) →
          (hbt198 : Bnd t198 0 4398042316801) →
          (hbt199 : Bnd t199 0 4398042316801) →
          (hbt200 : Bnd t200 0 4398042316801) →
          (hbt201 : Bnd t201 0 4398042316801) →
          (hbt202 : Bnd t202 0 4398042316801) →
          (hbt203 : Bnd t203 0 4398042316801) →
          (hbt204 : Bnd t204 0 4398042316801) →
          (hbt205 : Bnd t205 0 4398042316801) →
          (hbt206 : Bnd t206 0 4398042316801) →
          (hbt207 : Bnd t207 0 4398042316801) →
          (hbt208 : Bnd t208 0 4398042316801) →
          (hbt209 : Bnd t209 0 4398042316801) →
          (hbt210 : Bnd t210 0 4398042316801) →
          (hbt211 : Bnd t211 0 4398042316801) →
          (hbt212 : Bnd t212 0 4398042316801) →
          (hbt213 : Bnd t213 0 4398042316801) →
          (hbt214 : Bnd t214 0 8796084633602) →
          (hbt215 : Bnd t215 0 13194126950403) →
          (hbt216 : Bnd t216 0 17592169267204) →
          (hbt217 : Bnd t217 0 21990211584005) →
          (hbt218 : Bnd t218 0 26388253900806) →
          (hbt219 : Bnd t219 0 30786296217607) →
          (hbt220 : Bnd t220 0 35184338534408) →
          (hbt221 : Bnd t221 0 39582380851209) →
          (hbt222 : Bnd t222 0 43980423168010) →
          (hbt223 : Bnd t223 0 43980425265161) →
          (hbs10 : Bnd s10 0 48378467581962) →
          (hbt225 : Bnd t225 0 70368708526081) →
          (hbt226 : Bnd t226 0 4398042316801) →
          (hbt227 : Bnd t227 0 4398042316801) →
          (hbt228 : Bnd t228 0 4398042316801) →
          (hbt229 : Bnd t229 0 4398042316801) →
          (hbt230 : Bnd t230 0 4398042316801) →
          (hbt231 : Bnd t231 0 4398042316801) →
          (hbt232 : Bnd t232 0 4398042316801) →
          (hbt233 : Bnd t233 0 4398042316801) →
          (hbt234 : Bnd t234 0 4398042316801) →
          (hbt235 : Bnd t235 0 4398042316801) →
          (hbt236 : Bnd t236 0 70368708526081) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 237 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 192 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd] with s8
  sbnd s8
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t193
  sbnd t193
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t194
  sbnd t194
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t195
  sbnd t195
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t196
  sbnd t196
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t197
  sbnd t197
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t198
  sbnd t198
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t199
  sbnd t199
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t200
  sbnd t200
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t201
  sbnd t201
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t202
  sbnd t202
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t203
  sbnd t203
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t204
  sbnd t204
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t205
  sbnd t205
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t206
  sbnd t206
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t207
  sbnd t207
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t208
  sbnd t208
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t209
  sbnd t209
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t210
  sbnd t210
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t211
  sbnd t211
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t212
  sbnd t212
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t213
  sbnd t213
  step_pure [nswAdd, nuwAdd] with t214
  sbnd t214
  step_pure [nswAdd, nuwAdd] with t215
  sbnd t215
  step_pure [nswAdd, nuwAdd] with t216
  sbnd t216
  step_pure [nswAdd, nuwAdd] with t217
  sbnd t217
  step_pure [nswAdd, nuwAdd] with t218
  sbnd t218
  step_pure [nswAdd, nuwAdd] with t219
  sbnd t219
  step_pure [nswAdd, nuwAdd] with t220
  sbnd t220
  step_pure [nswAdd, nuwAdd] with t221
  sbnd t221
  step_pure [nswAdd, nuwAdd] with t222
  sbnd t222
  step_pure [nswAdd, nuwAdd] with t223
  sbnd t223
  step_pure [nswAdd, nuwAdd] with s10
  sbnd s10
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t225
  sbnd t225
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t226
  sbnd t226
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t227
  sbnd t227
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t228
  sbnd t228
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t229
  sbnd t229
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t230
  sbnd t230
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t231
  sbnd t231
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t232
  sbnd t232
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t233
  sbnd t233
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t234
  sbnd t234
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t235
  sbnd t235
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t236
  sbnd t236
  exact
    hK _ s8 t193 t194 t195 t196 t197 t198 t199 t200 t201 t202 t203 t204 t205 t206 t207 t208 t209
      t210 t211 t212 t213 t214 t215 t216 t217 t218 t219 t220 t221 t222 t223 s10 t225 t226 t227 t228
      t229 t230 t231 t232 t233 t234 t235 t236 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) hs8 ht193 ht194 ht195 ht196 ht197 ht198 ht199 ht200 ht201 ht202 ht203 ht204
      ht205 ht206 ht207 ht208 ht209 ht210 ht211 ht212 ht213 ht214 ht215 ht216 ht217 ht218 ht219
      ht220 ht221 ht222 ht223 hs10 ht225 ht226 ht227 ht228 ht229 ht230 ht231 ht232 ht233 ht234 ht235
      ht236 hbs8 hbt193 hbt194 hbt195 hbt196 hbt197 hbt198 hbt199 hbt200 hbt201 hbt202 hbt203 hbt204
      hbt205 hbt206 hbt207 hbt208 hbt209 hbt210 hbt211 hbt212 hbt213 hbt214 hbt215 hbt216 hbt217
      hbt218 hbt219 hbt220 hbt221 hbt222 hbt223 hbs10 hbt225 hbt226 hbt227 hbt228 hbt229 hbt230
      hbt231 hbt232 hbt233 hbt234 hbt235 hbt236

/-- From `%237`: `s12`. -/
theorem fd_curve25519_scalar_muladd.run237 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c1 c3 c5 c7 c9 c11 s0
      t125 t126 s2 t133 t134 t135 t136 s4 t147 t148 t149 t150 t151 t152 s6 t167 t168 t169 t170 t171
      t172 t173 t174 s8 t193 t194 t195 t196 t197 t198 t199 t200 t201 t202 s10 t225 t226 t227 t228
      t229 t230 t231 t232 t233 t234 t235 t236 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 59 := a1,
        rir_reg% fd_curve25519_scalar_muladd.hty 61 := a2,
        rir_reg% fd_curve25519_scalar_muladd.hty 63 := a3,
        rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
        rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
        rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
        rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
        rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
        rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
        rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
        rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
        rir_reg% fd_curve25519_scalar_muladd.hty 81 := b1,
        rir_reg% fd_curve25519_scalar_muladd.hty 83 := b2,
        rir_reg% fd_curve25519_scalar_muladd.hty 85 := b3,
        rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
        rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
        rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
        rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
        rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
        rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
        rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
        rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
        rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
        rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
        rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
        rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
        rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
        rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
        rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
        rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
        rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
        rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
        rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
        rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
        rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
        rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
        rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4,
        rir_reg% fd_curve25519_scalar_muladd.hty 147 := t147,
        rir_reg% fd_curve25519_scalar_muladd.hty 148 := t148,
        rir_reg% fd_curve25519_scalar_muladd.hty 149 := t149,
        rir_reg% fd_curve25519_scalar_muladd.hty 150 := t150,
        rir_reg% fd_curve25519_scalar_muladd.hty 151 := t151,
        rir_reg% fd_curve25519_scalar_muladd.hty 152 := t152,
        rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
        rir_reg% fd_curve25519_scalar_muladd.hty 167 := t167,
        rir_reg% fd_curve25519_scalar_muladd.hty 168 := t168,
        rir_reg% fd_curve25519_scalar_muladd.hty 169 := t169,
        rir_reg% fd_curve25519_scalar_muladd.hty 170 := t170,
        rir_reg% fd_curve25519_scalar_muladd.hty 171 := t171,
        rir_reg% fd_curve25519_scalar_muladd.hty 172 := t172,
        rir_reg% fd_curve25519_scalar_muladd.hty 173 := t173,
        rir_reg% fd_curve25519_scalar_muladd.hty 174 := t174,
        rir_reg% fd_curve25519_scalar_muladd.hty 192 := s8,
        rir_reg% fd_curve25519_scalar_muladd.hty 193 := t193,
        rir_reg% fd_curve25519_scalar_muladd.hty 194 := t194,
        rir_reg% fd_curve25519_scalar_muladd.hty 195 := t195,
        rir_reg% fd_curve25519_scalar_muladd.hty 196 := t196,
        rir_reg% fd_curve25519_scalar_muladd.hty 197 := t197,
        rir_reg% fd_curve25519_scalar_muladd.hty 198 := t198,
        rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199,
        rir_reg% fd_curve25519_scalar_muladd.hty 200 := t200,
        rir_reg% fd_curve25519_scalar_muladd.hty 201 := t201,
        rir_reg% fd_curve25519_scalar_muladd.hty 202 := t202,
        rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
        rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225,
        rir_reg% fd_curve25519_scalar_muladd.hty 226 := t226,
        rir_reg% fd_curve25519_scalar_muladd.hty 227 := t227,
        rir_reg% fd_curve25519_scalar_muladd.hty 228 := t228,
        rir_reg% fd_curve25519_scalar_muladd.hty 229 := t229,
        rir_reg% fd_curve25519_scalar_muladd.hty 230 := t230,
        rir_reg% fd_curve25519_scalar_muladd.hty 231 := t231,
        rir_reg% fd_curve25519_scalar_muladd.hty 232 := t232,
        rir_reg% fd_curve25519_scalar_muladd.hty 233 := t233,
        rir_reg% fd_curve25519_scalar_muladd.hty 234 := t234,
        rir_reg% fd_curve25519_scalar_muladd.hty 235 := t235,
        rir_reg% fd_curve25519_scalar_muladd.hty 236 := t236])
    (hba1 : Bnd a1 0 2097151) (hba2 : Bnd a2 0 2097151) (hba3 : Bnd a3 0 2097151)
    (hba4 : Bnd a4 0 2097151) (hba5 : Bnd a5 0 2097151) (hba6 : Bnd a6 0 2097151)
    (hba7 : Bnd a7 0 2097151) (hba8 : Bnd a8 0 2097151) (hba9 : Bnd a9 0 2097151)
    (hba10 : Bnd a10 0 2097151) (hba11 : Bnd a11 0 33554431) (hbb1 : Bnd b1 0 2097151)
    (hbb2 : Bnd b2 0 2097151) (hbb3 : Bnd b3 0 2097151) (hbb4 : Bnd b4 0 2097151)
    (hbb5 : Bnd b5 0 2097151) (hbb6 : Bnd b6 0 2097151) (hbb7 : Bnd b7 0 2097151)
    (hbb8 : Bnd b8 0 2097151) (hbb9 : Bnd b9 0 2097151) (hbb10 : Bnd b10 0 2097151)
    (hbb11 : Bnd b11 0 33554431)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t237 t238 t239 t240 t241 t242 t243 t244 t245 t246 t247 t248 t249 t250 t251 t252 t253 t254
          t255 t256 s12 t258 t259 t260 t261 t262 t263 t264 t265 t266 t267 t268 t269 t270 t271 t272
          t273 t274 t275 t276 t277 t278 t279 t280 t281 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
              rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
              rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
              rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
              rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
              rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
              rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
              rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
              rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
              rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
              rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
              rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
              rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
              rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
              rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
              rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
              rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
              rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
              rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
              rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
              rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
              rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
              rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
              rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
              rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
              rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
              rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
              rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
              rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
              rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
              rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4,
              rir_reg% fd_curve25519_scalar_muladd.hty 147 := t147,
              rir_reg% fd_curve25519_scalar_muladd.hty 148 := t148,
              rir_reg% fd_curve25519_scalar_muladd.hty 149 := t149,
              rir_reg% fd_curve25519_scalar_muladd.hty 150 := t150,
              rir_reg% fd_curve25519_scalar_muladd.hty 151 := t151,
              rir_reg% fd_curve25519_scalar_muladd.hty 152 := t152,
              rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
              rir_reg% fd_curve25519_scalar_muladd.hty 167 := t167,
              rir_reg% fd_curve25519_scalar_muladd.hty 168 := t168,
              rir_reg% fd_curve25519_scalar_muladd.hty 169 := t169,
              rir_reg% fd_curve25519_scalar_muladd.hty 170 := t170,
              rir_reg% fd_curve25519_scalar_muladd.hty 171 := t171,
              rir_reg% fd_curve25519_scalar_muladd.hty 172 := t172,
              rir_reg% fd_curve25519_scalar_muladd.hty 173 := t173,
              rir_reg% fd_curve25519_scalar_muladd.hty 174 := t174,
              rir_reg% fd_curve25519_scalar_muladd.hty 192 := s8,
              rir_reg% fd_curve25519_scalar_muladd.hty 193 := t193,
              rir_reg% fd_curve25519_scalar_muladd.hty 194 := t194,
              rir_reg% fd_curve25519_scalar_muladd.hty 195 := t195,
              rir_reg% fd_curve25519_scalar_muladd.hty 196 := t196,
              rir_reg% fd_curve25519_scalar_muladd.hty 197 := t197,
              rir_reg% fd_curve25519_scalar_muladd.hty 198 := t198,
              rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199,
              rir_reg% fd_curve25519_scalar_muladd.hty 200 := t200,
              rir_reg% fd_curve25519_scalar_muladd.hty 201 := t201,
              rir_reg% fd_curve25519_scalar_muladd.hty 202 := t202,
              rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
              rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225,
              rir_reg% fd_curve25519_scalar_muladd.hty 226 := t226,
              rir_reg% fd_curve25519_scalar_muladd.hty 227 := t227,
              rir_reg% fd_curve25519_scalar_muladd.hty 228 := t228,
              rir_reg% fd_curve25519_scalar_muladd.hty 229 := t229,
              rir_reg% fd_curve25519_scalar_muladd.hty 230 := t230,
              rir_reg% fd_curve25519_scalar_muladd.hty 231 := t231,
              rir_reg% fd_curve25519_scalar_muladd.hty 232 := t232,
              rir_reg% fd_curve25519_scalar_muladd.hty 233 := t233,
              rir_reg% fd_curve25519_scalar_muladd.hty 234 := t234,
              rir_reg% fd_curve25519_scalar_muladd.hty 235 := t235,
              rir_reg% fd_curve25519_scalar_muladd.hty 236 := t236,
              rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
              rir_reg% fd_curve25519_scalar_muladd.hty 258 := t258,
              rir_reg% fd_curve25519_scalar_muladd.hty 259 := t259,
              rir_reg% fd_curve25519_scalar_muladd.hty 260 := t260,
              rir_reg% fd_curve25519_scalar_muladd.hty 261 := t261,
              rir_reg% fd_curve25519_scalar_muladd.hty 262 := t262,
              rir_reg% fd_curve25519_scalar_muladd.hty 263 := t263,
              rir_reg% fd_curve25519_scalar_muladd.hty 264 := t264,
              rir_reg% fd_curve25519_scalar_muladd.hty 265 := t265,
              rir_reg% fd_curve25519_scalar_muladd.hty 266 := t266,
              rir_reg% fd_curve25519_scalar_muladd.hty 267 := t267,
              rir_reg% fd_curve25519_scalar_muladd.hty 269 := t269,
              rir_reg% fd_curve25519_scalar_muladd.hty 270 := t270,
              rir_reg% fd_curve25519_scalar_muladd.hty 275 := t275,
              rir_reg% fd_curve25519_scalar_muladd.hty 281 := t281]) →
          (ht237 : t237 = b11 * a1) →
          (ht238 : t238 = b10 * a2) →
          (ht239 : t239 = b9 * a3) →
          (ht240 : t240 = b8 * a4) →
          (ht241 : t241 = b7 * a5) →
          (ht242 : t242 = b6 * a6) →
          (ht243 : t243 = a7 * b5) →
          (ht244 : t244 = a8 * b4) →
          (ht245 : t245 = a9 * b3) →
          (ht246 : t246 = a10 * b2) →
          (ht247 : t247 = a11 * b1) →
          (ht248 : t248 = t244 + t243) →
          (ht249 : t249 = t248 + t240) →
          (ht250 : t250 = t249 + t241) →
          (ht251 : t251 = t250 + t242) →
          (ht252 : t252 = t251 + t247) →
          (ht253 : t253 = t252 + t237) →
          (ht254 : t254 = t253 + t245) →
          (ht255 : t255 = t254 + t246) →
          (ht256 : t256 = t255 + t238) →
          (hs12 : s12 = t256 + t239) →
          (ht258 : t258 = b11 * a2) →
          (ht259 : t259 = b10 * a3) →
          (ht260 : t260 = b9 * a4) →
          (ht261 : t261 = b8 * a5) →
          (ht262 : t262 = b7 * a6) →
          (ht263 : t263 = b6 * a7) →
          (ht264 : t264 = a8 * b5) →
          (ht265 : t265 = a9 * b4) →
          (ht266 : t266 = a10 * b3) →
          (ht267 : t267 = a11 * b2) →
          (ht268 : t268 = b11 * a3) →
          (ht269 : t269 = b10 * a4) →
          (ht270 : t270 = b9 * a5) →
          (ht271 : t271 = b8 * a6) →
          (ht272 : t272 = b7 * a7) →
          (ht273 : t273 = b6 * a8) →
          (ht274 : t274 = a9 * b5) →
          (ht275 : t275 = a10 * b4) →
          (ht276 : t276 = a11 * b3) →
          (ht277 : t277 = t272 + t271) →
          (ht278 : t278 = t277 + t273) →
          (ht279 : t279 = t278 + t276) →
          (ht280 : t280 = t279 + t268) →
          (ht281 : t281 = t280 + t274) →
          (hbt237 : Bnd t237 0 70368708526081) →
          (hbt238 : Bnd t238 0 4398042316801) →
          (hbt239 : Bnd t239 0 4398042316801) →
          (hbt240 : Bnd t240 0 4398042316801) →
          (hbt241 : Bnd t241 0 4398042316801) →
          (hbt242 : Bnd t242 0 4398042316801) →
          (hbt243 : Bnd t243 0 4398042316801) →
          (hbt244 : Bnd t244 0 4398042316801) →
          (hbt245 : Bnd t245 0 4398042316801) →
          (hbt246 : Bnd t246 0 4398042316801) →
          (hbt247 : Bnd t247 0 70368708526081) →
          (hbt248 : Bnd t248 0 8796084633602) →
          (hbt249 : Bnd t249 0 13194126950403) →
          (hbt250 : Bnd t250 0 17592169267204) →
          (hbt251 : Bnd t251 0 21990211584005) →
          (hbt252 : Bnd t252 0 92358920110086) →
          (hbt253 : Bnd t253 0 162727628636167) →
          (hbt254 : Bnd t254 0 167125670952968) →
          (hbt255 : Bnd t255 0 171523713269769) →
          (hbt256 : Bnd t256 0 175921755586570) →
          (hbs12 : Bnd s12 0 180319797903371) →
          (hbt258 : Bnd t258 0 70368708526081) →
          (hbt259 : Bnd t259 0 4398042316801) →
          (hbt260 : Bnd t260 0 4398042316801) →
          (hbt261 : Bnd t261 0 4398042316801) →
          (hbt262 : Bnd t262 0 4398042316801) →
          (hbt263 : Bnd t263 0 4398042316801) →
          (hbt264 : Bnd t264 0 4398042316801) →
          (hbt265 : Bnd t265 0 4398042316801) →
          (hbt266 : Bnd t266 0 4398042316801) →
          (hbt267 : Bnd t267 0 70368708526081) →
          (hbt268 : Bnd t268 0 70368708526081) →
          (hbt269 : Bnd t269 0 4398042316801) →
          (hbt270 : Bnd t270 0 4398042316801) →
          (hbt271 : Bnd t271 0 4398042316801) →
          (hbt272 : Bnd t272 0 4398042316801) →
          (hbt273 : Bnd t273 0 4398042316801) →
          (hbt274 : Bnd t274 0 4398042316801) →
          (hbt275 : Bnd t275 0 4398042316801) →
          (hbt276 : Bnd t276 0 70368708526081) →
          (hbt277 : Bnd t277 0 8796084633602) →
          (hbt278 : Bnd t278 0 13194126950403) →
          (hbt279 : Bnd t279 0 83562835476484) →
          (hbt280 : Bnd t280 0 153931544002565) →
          (hbt281 : Bnd t281 0 158329586319366) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 282 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 237 S >>= g) = K := by
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t237
  sbnd t237
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t238
  sbnd t238
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t239
  sbnd t239
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t240
  sbnd t240
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t241
  sbnd t241
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t242
  sbnd t242
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t243
  sbnd t243
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t244
  sbnd t244
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t245
  sbnd t245
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t246
  sbnd t246
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t247
  sbnd t247
  step_pure [nswAdd, nuwAdd] with t248
  sbnd t248
  step_pure [nswAdd, nuwAdd] with t249
  sbnd t249
  step_pure [nswAdd, nuwAdd] with t250
  sbnd t250
  step_pure [nswAdd, nuwAdd] with t251
  sbnd t251
  step_pure [nswAdd, nuwAdd] with t252
  sbnd t252
  step_pure [nswAdd, nuwAdd] with t253
  sbnd t253
  step_pure [nswAdd, nuwAdd] with t254
  sbnd t254
  step_pure [nswAdd, nuwAdd] with t255
  sbnd t255
  step_pure [nswAdd, nuwAdd] with t256
  sbnd t256
  step_pure [nswAdd, nuwAdd] with s12
  sbnd s12
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t258
  sbnd t258
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t259
  sbnd t259
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t260
  sbnd t260
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t261
  sbnd t261
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t262
  sbnd t262
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t263
  sbnd t263
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t264
  sbnd t264
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t265
  sbnd t265
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t266
  sbnd t266
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t267
  sbnd t267
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t268
  sbnd t268
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t269
  sbnd t269
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t270
  sbnd t270
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t271
  sbnd t271
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t272
  sbnd t272
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t273
  sbnd t273
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t274
  sbnd t274
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t275
  sbnd t275
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t276
  sbnd t276
  step_pure [nswAdd, nuwAdd] with t277
  sbnd t277
  step_pure [nswAdd, nuwAdd] with t278
  sbnd t278
  step_pure [nswAdd, nuwAdd] with t279
  sbnd t279
  step_pure [nswAdd, nuwAdd] with t280
  sbnd t280
  step_pure [nswAdd, nuwAdd] with t281
  sbnd t281
  exact
    hK _ t237 t238 t239 t240 t241 t242 t243 t244 t245 t246 t247 t248 t249 t250 t251 t252 t253 t254
      t255 t256 s12 t258 t259 t260 t261 t262 t263 t264 t265 t266 t267 t268 t269 t270 t271 t272 t273
      t274 t275 t276 t277 t278 t279 t280 t281 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht237 ht238 ht239 ht240 ht241 ht242 ht243 ht244 ht245 ht246 ht247 ht248 ht249
      ht250 ht251 ht252 ht253 ht254 ht255 ht256 hs12 ht258 ht259 ht260 ht261 ht262 ht263 ht264 ht265
      ht266 ht267 ht268 ht269 ht270 ht271 ht272 ht273 ht274 ht275 ht276 ht277 ht278 ht279 ht280
      ht281 hbt237 hbt238 hbt239 hbt240 hbt241 hbt242 hbt243 hbt244 hbt245 hbt246 hbt247 hbt248
      hbt249 hbt250 hbt251 hbt252 hbt253 hbt254 hbt255 hbt256 hbs12 hbt258 hbt259 hbt260 hbt261
      hbt262 hbt263 hbt264 hbt265 hbt266 hbt267 hbt268 hbt269 hbt270 hbt271 hbt272 hbt273 hbt274
      hbt275 hbt276 hbt277 hbt278 hbt279 hbt280 hbt281

/-- From `%282`: `s14` … `s18`. -/
theorem fd_curve25519_scalar_muladd.run282 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a4 a5 a6 a7 a8 a9 a10 a11 b4 b5 b6 b7 b8 b9 b10 b11 c1 c3 c5 c7 c9 c11 s0 t125 t126 s2 t133
      t134 t135 t136 s4 t147 t148 t149 t150 t151 t152 s6 t167 t168 t169 t170 t171 t172 t173 t174 s8
      t193 t194 t195 t196 t197 t198 t199 t200 t201 t202 s10 t225 t226 t227 t228 t229 t230 t231 t232
      t233 t234 t235 t236 s12 t258 t259 t260 t261 t262 t263 t264 t265 t266 t267 t269 t270 t275
      t281 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 65 := a4,
        rir_reg% fd_curve25519_scalar_muladd.hty 67 := a5,
        rir_reg% fd_curve25519_scalar_muladd.hty 69 := a6,
        rir_reg% fd_curve25519_scalar_muladd.hty 71 := a7,
        rir_reg% fd_curve25519_scalar_muladd.hty 73 := a8,
        rir_reg% fd_curve25519_scalar_muladd.hty 75 := a9,
        rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
        rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
        rir_reg% fd_curve25519_scalar_muladd.hty 87 := b4,
        rir_reg% fd_curve25519_scalar_muladd.hty 89 := b5,
        rir_reg% fd_curve25519_scalar_muladd.hty 91 := b6,
        rir_reg% fd_curve25519_scalar_muladd.hty 93 := b7,
        rir_reg% fd_curve25519_scalar_muladd.hty 95 := b8,
        rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
        rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
        rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
        rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
        rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
        rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
        rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
        rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
        rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
        rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
        rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
        rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
        rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
        rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
        rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
        rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
        rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
        rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4,
        rir_reg% fd_curve25519_scalar_muladd.hty 147 := t147,
        rir_reg% fd_curve25519_scalar_muladd.hty 148 := t148,
        rir_reg% fd_curve25519_scalar_muladd.hty 149 := t149,
        rir_reg% fd_curve25519_scalar_muladd.hty 150 := t150,
        rir_reg% fd_curve25519_scalar_muladd.hty 151 := t151,
        rir_reg% fd_curve25519_scalar_muladd.hty 152 := t152,
        rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
        rir_reg% fd_curve25519_scalar_muladd.hty 167 := t167,
        rir_reg% fd_curve25519_scalar_muladd.hty 168 := t168,
        rir_reg% fd_curve25519_scalar_muladd.hty 169 := t169,
        rir_reg% fd_curve25519_scalar_muladd.hty 170 := t170,
        rir_reg% fd_curve25519_scalar_muladd.hty 171 := t171,
        rir_reg% fd_curve25519_scalar_muladd.hty 172 := t172,
        rir_reg% fd_curve25519_scalar_muladd.hty 173 := t173,
        rir_reg% fd_curve25519_scalar_muladd.hty 174 := t174,
        rir_reg% fd_curve25519_scalar_muladd.hty 192 := s8,
        rir_reg% fd_curve25519_scalar_muladd.hty 193 := t193,
        rir_reg% fd_curve25519_scalar_muladd.hty 194 := t194,
        rir_reg% fd_curve25519_scalar_muladd.hty 195 := t195,
        rir_reg% fd_curve25519_scalar_muladd.hty 196 := t196,
        rir_reg% fd_curve25519_scalar_muladd.hty 197 := t197,
        rir_reg% fd_curve25519_scalar_muladd.hty 198 := t198,
        rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199,
        rir_reg% fd_curve25519_scalar_muladd.hty 200 := t200,
        rir_reg% fd_curve25519_scalar_muladd.hty 201 := t201,
        rir_reg% fd_curve25519_scalar_muladd.hty 202 := t202,
        rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
        rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225,
        rir_reg% fd_curve25519_scalar_muladd.hty 226 := t226,
        rir_reg% fd_curve25519_scalar_muladd.hty 227 := t227,
        rir_reg% fd_curve25519_scalar_muladd.hty 228 := t228,
        rir_reg% fd_curve25519_scalar_muladd.hty 229 := t229,
        rir_reg% fd_curve25519_scalar_muladd.hty 230 := t230,
        rir_reg% fd_curve25519_scalar_muladd.hty 231 := t231,
        rir_reg% fd_curve25519_scalar_muladd.hty 232 := t232,
        rir_reg% fd_curve25519_scalar_muladd.hty 233 := t233,
        rir_reg% fd_curve25519_scalar_muladd.hty 234 := t234,
        rir_reg% fd_curve25519_scalar_muladd.hty 235 := t235,
        rir_reg% fd_curve25519_scalar_muladd.hty 236 := t236,
        rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
        rir_reg% fd_curve25519_scalar_muladd.hty 258 := t258,
        rir_reg% fd_curve25519_scalar_muladd.hty 259 := t259,
        rir_reg% fd_curve25519_scalar_muladd.hty 260 := t260,
        rir_reg% fd_curve25519_scalar_muladd.hty 261 := t261,
        rir_reg% fd_curve25519_scalar_muladd.hty 262 := t262,
        rir_reg% fd_curve25519_scalar_muladd.hty 263 := t263,
        rir_reg% fd_curve25519_scalar_muladd.hty 264 := t264,
        rir_reg% fd_curve25519_scalar_muladd.hty 265 := t265,
        rir_reg% fd_curve25519_scalar_muladd.hty 266 := t266,
        rir_reg% fd_curve25519_scalar_muladd.hty 267 := t267,
        rir_reg% fd_curve25519_scalar_muladd.hty 269 := t269,
        rir_reg% fd_curve25519_scalar_muladd.hty 270 := t270,
        rir_reg% fd_curve25519_scalar_muladd.hty 275 := t275,
        rir_reg% fd_curve25519_scalar_muladd.hty 281 := t281])
    (hba4 : Bnd a4 0 2097151) (hba5 : Bnd a5 0 2097151) (hba6 : Bnd a6 0 2097151)
    (hba7 : Bnd a7 0 2097151) (hba8 : Bnd a8 0 2097151) (hba9 : Bnd a9 0 2097151)
    (hba10 : Bnd a10 0 2097151) (hba11 : Bnd a11 0 33554431) (hbb4 : Bnd b4 0 2097151)
    (hbb5 : Bnd b5 0 2097151) (hbb6 : Bnd b6 0 2097151) (hbb7 : Bnd b7 0 2097151)
    (hbb8 : Bnd b8 0 2097151) (hbb9 : Bnd b9 0 2097151) (hbb10 : Bnd b10 0 2097151)
    (hbb11 : Bnd b11 0 33554431) (hbt269 : Bnd t269 0 4398042316801)
    (hbt270 : Bnd t270 0 4398042316801) (hbt275 : Bnd t275 0 4398042316801)
    (hbt281 : Bnd t281 0 158329586319366)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t282 t283 s14 t285 t286 t287 t288 t289 t290 t291 t292 t293 t294 t295 t296 t297 t298 t299
          t300 t301 t302 t303 t304 s16 t306 t307 t308 t309 t310 t311 t312 t313 t314 t315 t316 t317
          t318 t319 s18 t321 t322 t323 t324 t325 t326 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
              rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
              rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
              rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
              rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
              rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
              rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
              rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
              rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
              rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
              rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
              rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
              rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
              rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
              rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
              rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
              rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
              rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
              rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
              rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4,
              rir_reg% fd_curve25519_scalar_muladd.hty 147 := t147,
              rir_reg% fd_curve25519_scalar_muladd.hty 148 := t148,
              rir_reg% fd_curve25519_scalar_muladd.hty 149 := t149,
              rir_reg% fd_curve25519_scalar_muladd.hty 150 := t150,
              rir_reg% fd_curve25519_scalar_muladd.hty 151 := t151,
              rir_reg% fd_curve25519_scalar_muladd.hty 152 := t152,
              rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
              rir_reg% fd_curve25519_scalar_muladd.hty 167 := t167,
              rir_reg% fd_curve25519_scalar_muladd.hty 168 := t168,
              rir_reg% fd_curve25519_scalar_muladd.hty 169 := t169,
              rir_reg% fd_curve25519_scalar_muladd.hty 170 := t170,
              rir_reg% fd_curve25519_scalar_muladd.hty 171 := t171,
              rir_reg% fd_curve25519_scalar_muladd.hty 172 := t172,
              rir_reg% fd_curve25519_scalar_muladd.hty 173 := t173,
              rir_reg% fd_curve25519_scalar_muladd.hty 174 := t174,
              rir_reg% fd_curve25519_scalar_muladd.hty 192 := s8,
              rir_reg% fd_curve25519_scalar_muladd.hty 193 := t193,
              rir_reg% fd_curve25519_scalar_muladd.hty 194 := t194,
              rir_reg% fd_curve25519_scalar_muladd.hty 195 := t195,
              rir_reg% fd_curve25519_scalar_muladd.hty 196 := t196,
              rir_reg% fd_curve25519_scalar_muladd.hty 197 := t197,
              rir_reg% fd_curve25519_scalar_muladd.hty 198 := t198,
              rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199,
              rir_reg% fd_curve25519_scalar_muladd.hty 200 := t200,
              rir_reg% fd_curve25519_scalar_muladd.hty 201 := t201,
              rir_reg% fd_curve25519_scalar_muladd.hty 202 := t202,
              rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
              rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225,
              rir_reg% fd_curve25519_scalar_muladd.hty 226 := t226,
              rir_reg% fd_curve25519_scalar_muladd.hty 227 := t227,
              rir_reg% fd_curve25519_scalar_muladd.hty 228 := t228,
              rir_reg% fd_curve25519_scalar_muladd.hty 229 := t229,
              rir_reg% fd_curve25519_scalar_muladd.hty 230 := t230,
              rir_reg% fd_curve25519_scalar_muladd.hty 231 := t231,
              rir_reg% fd_curve25519_scalar_muladd.hty 232 := t232,
              rir_reg% fd_curve25519_scalar_muladd.hty 233 := t233,
              rir_reg% fd_curve25519_scalar_muladd.hty 234 := t234,
              rir_reg% fd_curve25519_scalar_muladd.hty 235 := t235,
              rir_reg% fd_curve25519_scalar_muladd.hty 236 := t236,
              rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
              rir_reg% fd_curve25519_scalar_muladd.hty 258 := t258,
              rir_reg% fd_curve25519_scalar_muladd.hty 259 := t259,
              rir_reg% fd_curve25519_scalar_muladd.hty 260 := t260,
              rir_reg% fd_curve25519_scalar_muladd.hty 261 := t261,
              rir_reg% fd_curve25519_scalar_muladd.hty 262 := t262,
              rir_reg% fd_curve25519_scalar_muladd.hty 263 := t263,
              rir_reg% fd_curve25519_scalar_muladd.hty 264 := t264,
              rir_reg% fd_curve25519_scalar_muladd.hty 265 := t265,
              rir_reg% fd_curve25519_scalar_muladd.hty 266 := t266,
              rir_reg% fd_curve25519_scalar_muladd.hty 267 := t267,
              rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
              rir_reg% fd_curve25519_scalar_muladd.hty 285 := t285,
              rir_reg% fd_curve25519_scalar_muladd.hty 286 := t286,
              rir_reg% fd_curve25519_scalar_muladd.hty 287 := t287,
              rir_reg% fd_curve25519_scalar_muladd.hty 288 := t288,
              rir_reg% fd_curve25519_scalar_muladd.hty 289 := t289,
              rir_reg% fd_curve25519_scalar_muladd.hty 290 := t290,
              rir_reg% fd_curve25519_scalar_muladd.hty 291 := t291,
              rir_reg% fd_curve25519_scalar_muladd.hty 292 := t292,
              rir_reg% fd_curve25519_scalar_muladd.hty 305 := s16,
              rir_reg% fd_curve25519_scalar_muladd.hty 306 := t306,
              rir_reg% fd_curve25519_scalar_muladd.hty 307 := t307,
              rir_reg% fd_curve25519_scalar_muladd.hty 308 := t308,
              rir_reg% fd_curve25519_scalar_muladd.hty 309 := t309,
              rir_reg% fd_curve25519_scalar_muladd.hty 310 := t310,
              rir_reg% fd_curve25519_scalar_muladd.hty 311 := t311,
              rir_reg% fd_curve25519_scalar_muladd.hty 320 := s18,
              rir_reg% fd_curve25519_scalar_muladd.hty 321 := t321,
              rir_reg% fd_curve25519_scalar_muladd.hty 322 := t322,
              rir_reg% fd_curve25519_scalar_muladd.hty 323 := t323,
              rir_reg% fd_curve25519_scalar_muladd.hty 324 := t324,
              rir_reg% fd_curve25519_scalar_muladd.hty 325 := t325,
              rir_reg% fd_curve25519_scalar_muladd.hty 326 := t326]) →
          (ht282 : t282 = t281 + t275) →
          (ht283 : t283 = t282 + t269) →
          (hs14 : s14 = t283 + t270) →
          (ht285 : t285 = b11 * a4) →
          (ht286 : t286 = b10 * a5) →
          (ht287 : t287 = b9 * a6) →
          (ht288 : t288 = b8 * a7) →
          (ht289 : t289 = b7 * a8) →
          (ht290 : t290 = a9 * b6) →
          (ht291 : t291 = a10 * b5) →
          (ht292 : t292 = a11 * b4) →
          (ht293 : t293 = b11 * a5) →
          (ht294 : t294 = b10 * a6) →
          (ht295 : t295 = b9 * a7) →
          (ht296 : t296 = b8 * a8) →
          (ht297 : t297 = a9 * b7) →
          (ht298 : t298 = a10 * b6) →
          (ht299 : t299 = a11 * b5) →
          (ht300 : t300 = t299 + t296) →
          (ht301 : t301 = t300 + t293) →
          (ht302 : t302 = t301 + t297) →
          (ht303 : t303 = t302 + t298) →
          (ht304 : t304 = t303 + t294) →
          (hs16 : s16 = t304 + t295) →
          (ht306 : t306 = b11 * a6) →
          (ht307 : t307 = b10 * a7) →
          (ht308 : t308 = b9 * a8) →
          (ht309 : t309 = a9 * b8) →
          (ht310 : t310 = a10 * b7) →
          (ht311 : t311 = a11 * b6) →
          (ht312 : t312 = b11 * a7) →
          (ht313 : t313 = b10 * a8) →
          (ht314 : t314 = b9 * a9) →
          (ht315 : t315 = a10 * b8) →
          (ht316 : t316 = a11 * b7) →
          (ht317 : t317 = t312 + t316) →
          (ht318 : t318 = t317 + t315) →
          (ht319 : t319 = t318 + t313) →
          (hs18 : s18 = t319 + t314) →
          (ht321 : t321 = b11 * a8) →
          (ht322 : t322 = b10 * a9) →
          (ht323 : t323 = b9 * a10) →
          (ht324 : t324 = a11 * b8) →
          (ht325 : t325 = a9 * b11) →
          (ht326 : t326 = b10 * a10) →
          (hbt282 : Bnd t282 0 162727628636167) →
          (hbt283 : Bnd t283 0 167125670952968) →
          (hbs14 : Bnd s14 0 171523713269769) →
          (hbt285 : Bnd t285 0 70368708526081) →
          (hbt286 : Bnd t286 0 4398042316801) →
          (hbt287 : Bnd t287 0 4398042316801) →
          (hbt288 : Bnd t288 0 4398042316801) →
          (hbt289 : Bnd t289 0 4398042316801) →
          (hbt290 : Bnd t290 0 4398042316801) →
          (hbt291 : Bnd t291 0 4398042316801) →
          (hbt292 : Bnd t292 0 70368708526081) →
          (hbt293 : Bnd t293 0 70368708526081) →
          (hbt294 : Bnd t294 0 4398042316801) →
          (hbt295 : Bnd t295 0 4398042316801) →
          (hbt296 : Bnd t296 0 4398042316801) →
          (hbt297 : Bnd t297 0 4398042316801) →
          (hbt298 : Bnd t298 0 4398042316801) →
          (hbt299 : Bnd t299 0 70368708526081) →
          (hbt300 : Bnd t300 0 74766750842882) →
          (hbt301 : Bnd t301 0 145135459368963) →
          (hbt302 : Bnd t302 0 149533501685764) →
          (hbt303 : Bnd t303 0 153931544002565) →
          (hbt304 : Bnd t304 0 158329586319366) →
          (hbs16 : Bnd s16 0 162727628636167) →
          (hbt306 : Bnd t306 0 70368708526081) →
          (hbt307 : Bnd t307 0 4398042316801) →
          (hbt308 : Bnd t308 0 4398042316801) →
          (hbt309 : Bnd t309 0 4398042316801) →
          (hbt310 : Bnd t310 0 4398042316801) →
          (hbt311 : Bnd t311 0 70368708526081) →
          (hbt312 : Bnd t312 0 70368708526081) →
          (hbt313 : Bnd t313 0 4398042316801) →
          (hbt314 : Bnd t314 0 4398042316801) →
          (hbt315 : Bnd t315 0 4398042316801) →
          (hbt316 : Bnd t316 0 70368708526081) →
          (hbt317 : Bnd t317 0 140737417052162) →
          (hbt318 : Bnd t318 0 145135459368963) →
          (hbt319 : Bnd t319 0 149533501685764) →
          (hbs18 : Bnd s18 0 153931544002565) →
          (hbt321 : Bnd t321 0 70368708526081) →
          (hbt322 : Bnd t322 0 4398042316801) →
          (hbt323 : Bnd t323 0 4398042316801) →
          (hbt324 : Bnd t324 0 70368708526081) →
          (hbt325 : Bnd t325 0 70368708526081) →
          (hbt326 : Bnd t326 0 4398042316801) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 327 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 282 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd] with t282
  sbnd t282
  step_pure [nswAdd, nuwAdd] with t283
  sbnd t283
  step_pure [nswAdd, nuwAdd] with s14
  sbnd s14
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t285
  sbnd t285
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t286
  sbnd t286
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t287
  sbnd t287
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t288
  sbnd t288
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t289
  sbnd t289
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t290
  sbnd t290
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t291
  sbnd t291
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t292
  sbnd t292
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t293
  sbnd t293
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t294
  sbnd t294
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t295
  sbnd t295
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t296
  sbnd t296
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t297
  sbnd t297
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t298
  sbnd t298
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t299
  sbnd t299
  step_pure [nswAdd, nuwAdd] with t300
  sbnd t300
  step_pure [nswAdd, nuwAdd] with t301
  sbnd t301
  step_pure [nswAdd, nuwAdd] with t302
  sbnd t302
  step_pure [nswAdd, nuwAdd] with t303
  sbnd t303
  step_pure [nswAdd, nuwAdd] with t304
  sbnd t304
  step_pure [nswAdd, nuwAdd] with s16
  sbnd s16
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t306
  sbnd t306
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t307
  sbnd t307
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t308
  sbnd t308
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t309
  sbnd t309
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t310
  sbnd t310
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t311
  sbnd t311
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t312
  sbnd t312
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t313
  sbnd t313
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t314
  sbnd t314
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t315
  sbnd t315
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t316
  sbnd t316
  step_pure [nswAdd, nuwAdd] with t317
  sbnd t317
  step_pure [nswAdd, nuwAdd] with t318
  sbnd t318
  step_pure [nswAdd, nuwAdd] with t319
  sbnd t319
  step_pure [nswAdd, nuwAdd] with s18
  sbnd s18
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t321
  sbnd t321
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t322
  sbnd t322
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t323
  sbnd t323
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t324
  sbnd t324
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t325
  sbnd t325
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t326
  sbnd t326
  exact
    hK _ t282 t283 s14 t285 t286 t287 t288 t289 t290 t291 t292 t293 t294 t295 t296 t297 t298 t299
      t300 t301 t302 t303 t304 s16 t306 t307 t308 t309 t310 t311 t312 t313 t314 t315 t316 t317 t318
      t319 s18 t321 t322 t323 t324 t325 t326 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht282 ht283 hs14 ht285 ht286 ht287 ht288 ht289 ht290 ht291 ht292 ht293 ht294
      ht295 ht296 ht297 ht298 ht299 ht300 ht301 ht302 ht303 ht304 hs16 ht306 ht307 ht308 ht309 ht310
      ht311 ht312 ht313 ht314 ht315 ht316 ht317 ht318 ht319 hs18 ht321 ht322 ht323 ht324 ht325 ht326
      hbt282 hbt283 hbs14 hbt285 hbt286 hbt287 hbt288 hbt289 hbt290 hbt291 hbt292 hbt293 hbt294
      hbt295 hbt296 hbt297 hbt298 hbt299 hbt300 hbt301 hbt302 hbt303 hbt304 hbs16 hbt306 hbt307
      hbt308 hbt309 hbt310 hbt311 hbt312 hbt313 hbt314 hbt315 hbt316 hbt317 hbt318 hbt319 hbs18
      hbt321 hbt322 hbt323 hbt324 hbt325 hbt326

/-- From `%327`: `s20` … `s7_1`. -/
theorem fd_curve25519_scalar_muladd.run327 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {a10 a11 b9 b10 b11 c1 c3 c5 c7 c9 c11 s0 t125 t126 s2 t133 t134 t135 t136 s4 t147 t148 t149
      t150 t151 t152 s6 t167 t168 t169 t170 t171 t172 t173 t174 s8 t193 t194 t195 t196 t197 t198
      t199 t200 t201 t202 s10 t225 t226 t227 t228 t229 t230 t231 t232 t233 t234 t235 t236 s12 t258
      t259 t260 t261 t262 t263 t264 t265 t266 t267 s14 t285 t286 t287 t288 t289 t290 t291 t292 s16
      t306 t307 t308 t309 t310 t311 s18 t321 t322 t323 t324 t325 t326 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 77 := a10,
        rir_reg% fd_curve25519_scalar_muladd.hty 78 := a11,
        rir_reg% fd_curve25519_scalar_muladd.hty 97 := b9,
        rir_reg% fd_curve25519_scalar_muladd.hty 99 := b10,
        rir_reg% fd_curve25519_scalar_muladd.hty 100 := b11,
        rir_reg% fd_curve25519_scalar_muladd.hty 103 := c1,
        rir_reg% fd_curve25519_scalar_muladd.hty 107 := c3,
        rir_reg% fd_curve25519_scalar_muladd.hty 111 := c5,
        rir_reg% fd_curve25519_scalar_muladd.hty 115 := c7,
        rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
        rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
        rir_reg% fd_curve25519_scalar_muladd.hty 124 := s0,
        rir_reg% fd_curve25519_scalar_muladd.hty 125 := t125,
        rir_reg% fd_curve25519_scalar_muladd.hty 126 := t126,
        rir_reg% fd_curve25519_scalar_muladd.hty 132 := s2,
        rir_reg% fd_curve25519_scalar_muladd.hty 133 := t133,
        rir_reg% fd_curve25519_scalar_muladd.hty 134 := t134,
        rir_reg% fd_curve25519_scalar_muladd.hty 135 := t135,
        rir_reg% fd_curve25519_scalar_muladd.hty 136 := t136,
        rir_reg% fd_curve25519_scalar_muladd.hty 146 := s4,
        rir_reg% fd_curve25519_scalar_muladd.hty 147 := t147,
        rir_reg% fd_curve25519_scalar_muladd.hty 148 := t148,
        rir_reg% fd_curve25519_scalar_muladd.hty 149 := t149,
        rir_reg% fd_curve25519_scalar_muladd.hty 150 := t150,
        rir_reg% fd_curve25519_scalar_muladd.hty 151 := t151,
        rir_reg% fd_curve25519_scalar_muladd.hty 152 := t152,
        rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
        rir_reg% fd_curve25519_scalar_muladd.hty 167 := t167,
        rir_reg% fd_curve25519_scalar_muladd.hty 168 := t168,
        rir_reg% fd_curve25519_scalar_muladd.hty 169 := t169,
        rir_reg% fd_curve25519_scalar_muladd.hty 170 := t170,
        rir_reg% fd_curve25519_scalar_muladd.hty 171 := t171,
        rir_reg% fd_curve25519_scalar_muladd.hty 172 := t172,
        rir_reg% fd_curve25519_scalar_muladd.hty 173 := t173,
        rir_reg% fd_curve25519_scalar_muladd.hty 174 := t174,
        rir_reg% fd_curve25519_scalar_muladd.hty 192 := s8,
        rir_reg% fd_curve25519_scalar_muladd.hty 193 := t193,
        rir_reg% fd_curve25519_scalar_muladd.hty 194 := t194,
        rir_reg% fd_curve25519_scalar_muladd.hty 195 := t195,
        rir_reg% fd_curve25519_scalar_muladd.hty 196 := t196,
        rir_reg% fd_curve25519_scalar_muladd.hty 197 := t197,
        rir_reg% fd_curve25519_scalar_muladd.hty 198 := t198,
        rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199,
        rir_reg% fd_curve25519_scalar_muladd.hty 200 := t200,
        rir_reg% fd_curve25519_scalar_muladd.hty 201 := t201,
        rir_reg% fd_curve25519_scalar_muladd.hty 202 := t202,
        rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
        rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225,
        rir_reg% fd_curve25519_scalar_muladd.hty 226 := t226,
        rir_reg% fd_curve25519_scalar_muladd.hty 227 := t227,
        rir_reg% fd_curve25519_scalar_muladd.hty 228 := t228,
        rir_reg% fd_curve25519_scalar_muladd.hty 229 := t229,
        rir_reg% fd_curve25519_scalar_muladd.hty 230 := t230,
        rir_reg% fd_curve25519_scalar_muladd.hty 231 := t231,
        rir_reg% fd_curve25519_scalar_muladd.hty 232 := t232,
        rir_reg% fd_curve25519_scalar_muladd.hty 233 := t233,
        rir_reg% fd_curve25519_scalar_muladd.hty 234 := t234,
        rir_reg% fd_curve25519_scalar_muladd.hty 235 := t235,
        rir_reg% fd_curve25519_scalar_muladd.hty 236 := t236,
        rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
        rir_reg% fd_curve25519_scalar_muladd.hty 258 := t258,
        rir_reg% fd_curve25519_scalar_muladd.hty 259 := t259,
        rir_reg% fd_curve25519_scalar_muladd.hty 260 := t260,
        rir_reg% fd_curve25519_scalar_muladd.hty 261 := t261,
        rir_reg% fd_curve25519_scalar_muladd.hty 262 := t262,
        rir_reg% fd_curve25519_scalar_muladd.hty 263 := t263,
        rir_reg% fd_curve25519_scalar_muladd.hty 264 := t264,
        rir_reg% fd_curve25519_scalar_muladd.hty 265 := t265,
        rir_reg% fd_curve25519_scalar_muladd.hty 266 := t266,
        rir_reg% fd_curve25519_scalar_muladd.hty 267 := t267,
        rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
        rir_reg% fd_curve25519_scalar_muladd.hty 285 := t285,
        rir_reg% fd_curve25519_scalar_muladd.hty 286 := t286,
        rir_reg% fd_curve25519_scalar_muladd.hty 287 := t287,
        rir_reg% fd_curve25519_scalar_muladd.hty 288 := t288,
        rir_reg% fd_curve25519_scalar_muladd.hty 289 := t289,
        rir_reg% fd_curve25519_scalar_muladd.hty 290 := t290,
        rir_reg% fd_curve25519_scalar_muladd.hty 291 := t291,
        rir_reg% fd_curve25519_scalar_muladd.hty 292 := t292,
        rir_reg% fd_curve25519_scalar_muladd.hty 305 := s16,
        rir_reg% fd_curve25519_scalar_muladd.hty 306 := t306,
        rir_reg% fd_curve25519_scalar_muladd.hty 307 := t307,
        rir_reg% fd_curve25519_scalar_muladd.hty 308 := t308,
        rir_reg% fd_curve25519_scalar_muladd.hty 309 := t309,
        rir_reg% fd_curve25519_scalar_muladd.hty 310 := t310,
        rir_reg% fd_curve25519_scalar_muladd.hty 311 := t311,
        rir_reg% fd_curve25519_scalar_muladd.hty 320 := s18,
        rir_reg% fd_curve25519_scalar_muladd.hty 321 := t321,
        rir_reg% fd_curve25519_scalar_muladd.hty 322 := t322,
        rir_reg% fd_curve25519_scalar_muladd.hty 323 := t323,
        rir_reg% fd_curve25519_scalar_muladd.hty 324 := t324,
        rir_reg% fd_curve25519_scalar_muladd.hty 325 := t325,
        rir_reg% fd_curve25519_scalar_muladd.hty 326 := t326])
    (hba10 : Bnd a10 0 2097151) (hba11 : Bnd a11 0 33554431) (hbb9 : Bnd b9 0 2097151)
    (hbb10 : Bnd b10 0 2097151) (hbb11 : Bnd b11 0 33554431) (hbc1 : Bnd c1 0 2097151)
    (hbc3 : Bnd c3 0 2097151) (hbc5 : Bnd c5 0 2097151) (hbc7 : Bnd c7 0 2097151)
    (hbs0 : Bnd s0 0 4398044413952) (hbt125 : Bnd t125 0 4398042316801)
    (hbt126 : Bnd t126 0 4398042316801) (hbs2 : Bnd s2 0 13194129047554)
    (hbt133 : Bnd t133 0 4398042316801) (hbt134 : Bnd t134 0 4398042316801)
    (hbt135 : Bnd t135 0 4398042316801) (hbt136 : Bnd t136 0 4398042316801)
    (hbs4 : Bnd s4 0 21990213681156) (hbt147 : Bnd t147 0 4398042316801)
    (hbt148 : Bnd t148 0 4398042316801) (hbt149 : Bnd t149 0 4398042316801)
    (hbt150 : Bnd t150 0 4398042316801) (hbt151 : Bnd t151 0 4398042316801)
    (hbt152 : Bnd t152 0 4398042316801) (hbs6 : Bnd s6 0 30786298314758)
    (hbt167 : Bnd t167 0 4398042316801) (hbt168 : Bnd t168 0 4398042316801)
    (hbt169 : Bnd t169 0 4398042316801) (hbt170 : Bnd t170 0 4398042316801)
    (hbt171 : Bnd t171 0 4398042316801) (hbt172 : Bnd t172 0 4398042316801)
    (hbt173 : Bnd t173 0 4398042316801) (hbt174 : Bnd t174 0 4398042316801)
    (hbt325 : Bnd t325 0 70368708526081) (hbt326 : Bnd t326 0 4398042316801)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t327 t328 s20 t330 t331 s21 s22 carry0 t336 s1 s1_1 s0_1 carry2 t343 t344 t345 s3 s3_1 s2_1
          carry4 t352 t353 t354 t355 t356 s5 s5_1 s4_1 carry6 t363 t364 t365 t366 t367 t368 t369 s7
          s7_1 t361 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
              rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
              rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
              rir_reg% fd_curve25519_scalar_muladd.hty 192 := s8,
              rir_reg% fd_curve25519_scalar_muladd.hty 193 := t193,
              rir_reg% fd_curve25519_scalar_muladd.hty 194 := t194,
              rir_reg% fd_curve25519_scalar_muladd.hty 195 := t195,
              rir_reg% fd_curve25519_scalar_muladd.hty 196 := t196,
              rir_reg% fd_curve25519_scalar_muladd.hty 197 := t197,
              rir_reg% fd_curve25519_scalar_muladd.hty 198 := t198,
              rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199,
              rir_reg% fd_curve25519_scalar_muladd.hty 200 := t200,
              rir_reg% fd_curve25519_scalar_muladd.hty 201 := t201,
              rir_reg% fd_curve25519_scalar_muladd.hty 202 := t202,
              rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
              rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225,
              rir_reg% fd_curve25519_scalar_muladd.hty 226 := t226,
              rir_reg% fd_curve25519_scalar_muladd.hty 227 := t227,
              rir_reg% fd_curve25519_scalar_muladd.hty 228 := t228,
              rir_reg% fd_curve25519_scalar_muladd.hty 229 := t229,
              rir_reg% fd_curve25519_scalar_muladd.hty 230 := t230,
              rir_reg% fd_curve25519_scalar_muladd.hty 231 := t231,
              rir_reg% fd_curve25519_scalar_muladd.hty 232 := t232,
              rir_reg% fd_curve25519_scalar_muladd.hty 233 := t233,
              rir_reg% fd_curve25519_scalar_muladd.hty 234 := t234,
              rir_reg% fd_curve25519_scalar_muladd.hty 235 := t235,
              rir_reg% fd_curve25519_scalar_muladd.hty 236 := t236,
              rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
              rir_reg% fd_curve25519_scalar_muladd.hty 258 := t258,
              rir_reg% fd_curve25519_scalar_muladd.hty 259 := t259,
              rir_reg% fd_curve25519_scalar_muladd.hty 260 := t260,
              rir_reg% fd_curve25519_scalar_muladd.hty 261 := t261,
              rir_reg% fd_curve25519_scalar_muladd.hty 262 := t262,
              rir_reg% fd_curve25519_scalar_muladd.hty 263 := t263,
              rir_reg% fd_curve25519_scalar_muladd.hty 264 := t264,
              rir_reg% fd_curve25519_scalar_muladd.hty 265 := t265,
              rir_reg% fd_curve25519_scalar_muladd.hty 266 := t266,
              rir_reg% fd_curve25519_scalar_muladd.hty 267 := t267,
              rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
              rir_reg% fd_curve25519_scalar_muladd.hty 285 := t285,
              rir_reg% fd_curve25519_scalar_muladd.hty 286 := t286,
              rir_reg% fd_curve25519_scalar_muladd.hty 287 := t287,
              rir_reg% fd_curve25519_scalar_muladd.hty 288 := t288,
              rir_reg% fd_curve25519_scalar_muladd.hty 289 := t289,
              rir_reg% fd_curve25519_scalar_muladd.hty 290 := t290,
              rir_reg% fd_curve25519_scalar_muladd.hty 291 := t291,
              rir_reg% fd_curve25519_scalar_muladd.hty 292 := t292,
              rir_reg% fd_curve25519_scalar_muladd.hty 305 := s16,
              rir_reg% fd_curve25519_scalar_muladd.hty 306 := t306,
              rir_reg% fd_curve25519_scalar_muladd.hty 307 := t307,
              rir_reg% fd_curve25519_scalar_muladd.hty 308 := t308,
              rir_reg% fd_curve25519_scalar_muladd.hty 309 := t309,
              rir_reg% fd_curve25519_scalar_muladd.hty 310 := t310,
              rir_reg% fd_curve25519_scalar_muladd.hty 311 := t311,
              rir_reg% fd_curve25519_scalar_muladd.hty 320 := s18,
              rir_reg% fd_curve25519_scalar_muladd.hty 321 := t321,
              rir_reg% fd_curve25519_scalar_muladd.hty 322 := t322,
              rir_reg% fd_curve25519_scalar_muladd.hty 323 := t323,
              rir_reg% fd_curve25519_scalar_muladd.hty 324 := t324,
              rir_reg% fd_curve25519_scalar_muladd.hty 329 := s20,
              rir_reg% fd_curve25519_scalar_muladd.hty 332 := s21,
              rir_reg% fd_curve25519_scalar_muladd.hty 333 := s22,
              rir_reg% fd_curve25519_scalar_muladd.hty 338 := s1_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 347 := s3_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 349 := s2_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 358 := s5_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 360 := s4_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 371 := s7_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 361 := t361]) →
          (ht327 : t327 = t326 + t325) →
          (ht328 : t328 = b9 * a11) →
          (hs20 : s20 = t327 + t328) →
          (ht330 : t330 = a10 * b11) →
          (ht331 : t331 = b10 * a11) →
          (hs21 : s21 = t331 + t330) →
          (hs22 : s22 = b11 * a11) →
          (hcarry0 : carry0 = BitVec.sshiftRight (s0 + 1048576#64) 21) →
          (ht336 : t336 = t125 + t126) →
          (hs1 : s1 = t336 + c1) →
          (hs1_1 : s1_1 = s1 + carry0) →
          (hs0_1 : s0_1 = s0 - ((BitVec.sshiftRight (s0 + 1048576#64) 21) <<< 21)) →
          (hcarry2 : carry2 = BitVec.sshiftRight (s2 + 1048576#64) 21) →
          (ht343 : t343 = t135 + t134) →
          (ht344 : t344 = t343 + t136) →
          (ht345 : t345 = t344 + t133) →
          (hs3 : s3 = t345 + c3) →
          (hs3_1 : s3_1 = s3 + carry2) →
          (hs2_1 : s2_1 = s2 - ((BitVec.sshiftRight (s2 + 1048576#64) 21) <<< 21)) →
          (hcarry4 : carry4 = BitVec.sshiftRight (s4 + 1048576#64) 21) →
          (ht352 : t352 = t151 + t150) →
          (ht353 : t353 = t352 + t152) →
          (ht354 : t354 = t353 + t147) →
          (ht355 : t355 = t354 + c5) →
          (ht356 : t356 = t355 + t148) →
          (hs5 : s5 = t356 + t149) →
          (hs5_1 : s5_1 = s5 + carry4) →
          (hs4_1 : s4_1 = s4 - ((BitVec.sshiftRight (s4 + 1048576#64) 21) <<< 21)) →
          (hcarry6 : carry6 = BitVec.sshiftRight t361 21) →
          (ht363 : t363 = t169 + t172) →
          (ht364 : t364 = t363 + t170) →
          (ht365 : t365 = t364 + t171) →
          (ht366 : t366 = t365 + t173) →
          (ht367 : t367 = t366 + t174) →
          (ht368 : t368 = t367 + t167) →
          (ht369 : t369 = t368 + c7) →
          (hs7 : s7 = t369 + t168) →
          (hs7_1 : s7_1 = s7 + carry6) →
          (ht361 : t361 = s6 + 1048576#64) →
          (hbt327 : Bnd t327 0 74766750842882) →
          (hbt328 : Bnd t328 0 70368708526081) →
          (hbs20 : Bnd s20 0 145135459368963) →
          (hbt330 : Bnd t330 0 70368708526081) →
          (hbt331 : Bnd t331 0 70368708526081) →
          (hbs21 : Bnd s21 0 140737417052162) →
          (hbs22 : Bnd s22 0 1125899839733761) →
          (hbcarry0 : Bnd carry0 0 2097151) →
          (hbt336 : Bnd t336 0 8796084633602) →
          (hbs1 : Bnd s1 0 8796086730753) →
          (hbs1_1 : Bnd s1_1 0 8796088827904) →
          (hbs0_1 : Bnd s0_1 (-1048576) 1048575) →
          (hbcarry2 : Bnd carry2 0 6291451) →
          (hbt343 : Bnd t343 0 8796084633602) →
          (hbt344 : Bnd t344 0 13194126950403) →
          (hbt345 : Bnd t345 0 17592169267204) →
          (hbs3 : Bnd s3 0 17592171364355) →
          (hbs3_1 : Bnd s3_1 0 17592177655806) →
          (hbs2_1 : Bnd s2_1 (-1048576) 1048575) →
          (hbcarry4 : Bnd carry4 0 10485751) →
          (hbt352 : Bnd t352 0 8796084633602) →
          (hbt353 : Bnd t353 0 13194126950403) →
          (hbt354 : Bnd t354 0 17592169267204) →
          (hbt355 : Bnd t355 0 17592171364355) →
          (hbt356 : Bnd t356 0 21990213681156) →
          (hbs5 : Bnd s5 0 26388255997957) →
          (hbs5_1 : Bnd s5_1 0 26388266483708) →
          (hbs4_1 : Bnd s4_1 (-1048576) 1048575) →
          (hbcarry6 : Bnd carry6 0 14680051) →
          (hbt363 : Bnd t363 0 8796084633602) →
          (hbt364 : Bnd t364 0 13194126950403) →
          (hbt365 : Bnd t365 0 17592169267204) →
          (hbt366 : Bnd t366 0 21990211584005) →
          (hbt367 : Bnd t367 0 26388253900806) →
          (hbt368 : Bnd t368 0 30786296217607) →
          (hbt369 : Bnd t369 0 30786298314758) →
          (hbs7 : Bnd s7 0 35184340631559) →
          (hbs7_1 : Bnd s7_1 0 35184355311610) →
          (hbt361 : Bnd t361 1048576 30786299363334) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 372 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 327 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd] with t327
  sbnd t327
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t328
  sbnd t328
  step_pure [nswAdd, nuwAdd] with s20
  sbnd s20
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t330
  sbnd t330
  step_pure [Sc.nswMulV, Sc.nuwMulV] with t331
  sbnd t331
  step_pure [nswAdd, nuwAdd] with s21
  sbnd s21
  step_pure [Sc.nswMulV, Sc.nuwMulV] with s22
  sbnd s22
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry0
  sbnd carry0
  step_pure [nswAdd, nuwAdd] with t336
  sbnd t336
  step_pure [nswAdd, nuwAdd] with s1
  sbnd s1
  step_pure [nswAdd, nuwAdd] with s1_1
  sbnd s1_1
  step_pure [Sc.andMaskN]
  step_pure [Sc.nswSubS] with s0_1
  sbnd s0_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry2
  sbnd carry2
  step_pure [nswAdd, nuwAdd] with t343
  sbnd t343
  step_pure [nswAdd, nuwAdd] with t344
  sbnd t344
  step_pure [nswAdd, nuwAdd] with t345
  sbnd t345
  step_pure [nswAdd, nuwAdd] with s3
  sbnd s3
  step_pure [nswAdd, nuwAdd] with s3_1
  sbnd s3_1
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s2_1
  sbnd s2_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry4
  sbnd carry4
  step_pure [nswAdd, nuwAdd] with t352
  sbnd t352
  step_pure [nswAdd, nuwAdd] with t353
  sbnd t353
  step_pure [nswAdd, nuwAdd] with t354
  sbnd t354
  step_pure [nswAdd, nuwAdd] with t355
  sbnd t355
  step_pure [nswAdd, nuwAdd] with t356
  sbnd t356
  step_pure [nswAdd, nuwAdd] with s5
  sbnd s5
  step_pure [nswAdd, nuwAdd] with s5_1
  sbnd s5_1
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s4_1
  sbnd s4_1
  step_pure [nswAdd, nuwAdd] with t361
  sbnd t361
  step_pure [lshrNonneg] with carry6
  sbnd carry6
  step_pure [nswAdd, nuwAdd] with t363
  sbnd t363
  step_pure [nswAdd, nuwAdd] with t364
  sbnd t364
  step_pure [nswAdd, nuwAdd] with t365
  sbnd t365
  step_pure [nswAdd, nuwAdd] with t366
  sbnd t366
  step_pure [nswAdd, nuwAdd] with t367
  sbnd t367
  step_pure [nswAdd, nuwAdd] with t368
  sbnd t368
  step_pure [nswAdd, nuwAdd] with t369
  sbnd t369
  step_pure [nswAdd, nuwAdd] with s7
  sbnd s7
  step_pure [nswAdd, nuwAdd] with s7_1
  sbnd s7_1
  exact
    hK _ t327 t328 s20 t330 t331 s21 s22 carry0 t336 s1 s1_1 s0_1 carry2 t343 t344 t345 s3 s3_1 s2_1
      carry4 t352 t353 t354 t355 t356 s5 s5_1 s4_1 carry6 t363 t364 t365 t366 t367 t368 t369 s7 s7_1
      t361 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht327 ht328 hs20 ht330 ht331 hs21 hs22 hcarry0 ht336 hs1 hs1_1 hs0_1 hcarry2
      ht343 ht344 ht345 hs3 hs3_1 hs2_1 hcarry4 ht352 ht353 ht354 ht355 ht356 hs5 hs5_1 hs4_1
      hcarry6 ht363 ht364 ht365 ht366 ht367 ht368 ht369 hs7 hs7_1 ht361 hbt327 hbt328 hbs20 hbt330
      hbt331 hbs21 hbs22 hbcarry0 hbt336 hbs1 hbs1_1 hbs0_1 hbcarry2 hbt343 hbt344 hbt345 hbs3
      hbs3_1 hbs2_1 hbcarry4 hbt352 hbt353 hbt354 hbt355 hbt356 hbs5 hbs5_1 hbs4_1 hbcarry6 hbt363
      hbt364 hbt365 hbt366 hbt367 hbt368 hbt369 hbs7 hbs7_1 hbt361

/-- From `%372`: `carry8` … `s13_1`. -/
theorem fd_curve25519_scalar_muladd.run372 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {c9 c11 s6 s8 t193 t194 t195 t196 t197 t198 t199 t200 t201 t202 s10 t225 t226 t227 t228 t229
      t230 t231 t232 t233 t234 t235 t236 s12 t258 t259 t260 t261 t262 t263 t264 t265 t266 t267 s14
      t285 t286 t287 t288 t289 t290 t291 t292 s16 t306 t307 t308 t309 t310 t311 s18 t321 t322 t323
      t324 s20 s21 s22 s1_1 s0_1 s3_1 s2_1 s5_1 s4_1 t361 s7_1 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 119 := c9,
        rir_reg% fd_curve25519_scalar_muladd.hty 122 := c11,
        rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
        rir_reg% fd_curve25519_scalar_muladd.hty 192 := s8,
        rir_reg% fd_curve25519_scalar_muladd.hty 193 := t193,
        rir_reg% fd_curve25519_scalar_muladd.hty 194 := t194,
        rir_reg% fd_curve25519_scalar_muladd.hty 195 := t195,
        rir_reg% fd_curve25519_scalar_muladd.hty 196 := t196,
        rir_reg% fd_curve25519_scalar_muladd.hty 197 := t197,
        rir_reg% fd_curve25519_scalar_muladd.hty 198 := t198,
        rir_reg% fd_curve25519_scalar_muladd.hty 199 := t199,
        rir_reg% fd_curve25519_scalar_muladd.hty 200 := t200,
        rir_reg% fd_curve25519_scalar_muladd.hty 201 := t201,
        rir_reg% fd_curve25519_scalar_muladd.hty 202 := t202,
        rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
        rir_reg% fd_curve25519_scalar_muladd.hty 225 := t225,
        rir_reg% fd_curve25519_scalar_muladd.hty 226 := t226,
        rir_reg% fd_curve25519_scalar_muladd.hty 227 := t227,
        rir_reg% fd_curve25519_scalar_muladd.hty 228 := t228,
        rir_reg% fd_curve25519_scalar_muladd.hty 229 := t229,
        rir_reg% fd_curve25519_scalar_muladd.hty 230 := t230,
        rir_reg% fd_curve25519_scalar_muladd.hty 231 := t231,
        rir_reg% fd_curve25519_scalar_muladd.hty 232 := t232,
        rir_reg% fd_curve25519_scalar_muladd.hty 233 := t233,
        rir_reg% fd_curve25519_scalar_muladd.hty 234 := t234,
        rir_reg% fd_curve25519_scalar_muladd.hty 235 := t235,
        rir_reg% fd_curve25519_scalar_muladd.hty 236 := t236,
        rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
        rir_reg% fd_curve25519_scalar_muladd.hty 258 := t258,
        rir_reg% fd_curve25519_scalar_muladd.hty 259 := t259,
        rir_reg% fd_curve25519_scalar_muladd.hty 260 := t260,
        rir_reg% fd_curve25519_scalar_muladd.hty 261 := t261,
        rir_reg% fd_curve25519_scalar_muladd.hty 262 := t262,
        rir_reg% fd_curve25519_scalar_muladd.hty 263 := t263,
        rir_reg% fd_curve25519_scalar_muladd.hty 264 := t264,
        rir_reg% fd_curve25519_scalar_muladd.hty 265 := t265,
        rir_reg% fd_curve25519_scalar_muladd.hty 266 := t266,
        rir_reg% fd_curve25519_scalar_muladd.hty 267 := t267,
        rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
        rir_reg% fd_curve25519_scalar_muladd.hty 285 := t285,
        rir_reg% fd_curve25519_scalar_muladd.hty 286 := t286,
        rir_reg% fd_curve25519_scalar_muladd.hty 287 := t287,
        rir_reg% fd_curve25519_scalar_muladd.hty 288 := t288,
        rir_reg% fd_curve25519_scalar_muladd.hty 289 := t289,
        rir_reg% fd_curve25519_scalar_muladd.hty 290 := t290,
        rir_reg% fd_curve25519_scalar_muladd.hty 291 := t291,
        rir_reg% fd_curve25519_scalar_muladd.hty 292 := t292,
        rir_reg% fd_curve25519_scalar_muladd.hty 305 := s16,
        rir_reg% fd_curve25519_scalar_muladd.hty 306 := t306,
        rir_reg% fd_curve25519_scalar_muladd.hty 307 := t307,
        rir_reg% fd_curve25519_scalar_muladd.hty 308 := t308,
        rir_reg% fd_curve25519_scalar_muladd.hty 309 := t309,
        rir_reg% fd_curve25519_scalar_muladd.hty 310 := t310,
        rir_reg% fd_curve25519_scalar_muladd.hty 311 := t311,
        rir_reg% fd_curve25519_scalar_muladd.hty 320 := s18,
        rir_reg% fd_curve25519_scalar_muladd.hty 321 := t321,
        rir_reg% fd_curve25519_scalar_muladd.hty 322 := t322,
        rir_reg% fd_curve25519_scalar_muladd.hty 323 := t323,
        rir_reg% fd_curve25519_scalar_muladd.hty 324 := t324,
        rir_reg% fd_curve25519_scalar_muladd.hty 329 := s20,
        rir_reg% fd_curve25519_scalar_muladd.hty 332 := s21,
        rir_reg% fd_curve25519_scalar_muladd.hty 333 := s22,
        rir_reg% fd_curve25519_scalar_muladd.hty 338 := s1_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 347 := s3_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 349 := s2_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 358 := s5_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 360 := s4_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 371 := s7_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 361 := t361])
    (hbc9 : Bnd c9 0 2097151) (hbc11 : Bnd c11 0 33554431) (hbs8 : Bnd s8 0 39582382948360)
    (hbt193 : Bnd t193 0 4398042316801) (hbt194 : Bnd t194 0 4398042316801)
    (hbt195 : Bnd t195 0 4398042316801) (hbt196 : Bnd t196 0 4398042316801)
    (hbt197 : Bnd t197 0 4398042316801) (hbt198 : Bnd t198 0 4398042316801)
    (hbt199 : Bnd t199 0 4398042316801) (hbt200 : Bnd t200 0 4398042316801)
    (hbt201 : Bnd t201 0 4398042316801) (hbt202 : Bnd t202 0 4398042316801)
    (hbs10 : Bnd s10 0 48378467581962) (hbt225 : Bnd t225 0 70368708526081)
    (hbt226 : Bnd t226 0 4398042316801) (hbt227 : Bnd t227 0 4398042316801)
    (hbt228 : Bnd t228 0 4398042316801) (hbt229 : Bnd t229 0 4398042316801)
    (hbt230 : Bnd t230 0 4398042316801) (hbt231 : Bnd t231 0 4398042316801)
    (hbt232 : Bnd t232 0 4398042316801) (hbt233 : Bnd t233 0 4398042316801)
    (hbt234 : Bnd t234 0 4398042316801) (hbt235 : Bnd t235 0 4398042316801)
    (hbt236 : Bnd t236 0 70368708526081) (hbs12 : Bnd s12 0 180319797903371)
    (hbt258 : Bnd t258 0 70368708526081) (hbt259 : Bnd t259 0 4398042316801)
    (hbt260 : Bnd t260 0 4398042316801) (hbt261 : Bnd t261 0 4398042316801)
    (hbt262 : Bnd t262 0 4398042316801) (hbt263 : Bnd t263 0 4398042316801)
    (hbt264 : Bnd t264 0 4398042316801) (hbt265 : Bnd t265 0 4398042316801)
    (hbt266 : Bnd t266 0 4398042316801) (hbt267 : Bnd t267 0 70368708526081)
    (hbt361 : Bnd t361 1048576 30786299363334)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (carry8 t375 t376 t377 t378 t379 t380 t381 t382 t383 s9 s9_1 s8_1 carry10 t390 t391 t392
          t393 t394 t395 t396 t397 t398 t399 t400 s11 s11_1 carry12 t406 t407 t408 t409 t410 t411
          t412 t413 s13 s13_1 t372 t403 t416 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
              rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
              rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
              rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
              rir_reg% fd_curve25519_scalar_muladd.hty 285 := t285,
              rir_reg% fd_curve25519_scalar_muladd.hty 286 := t286,
              rir_reg% fd_curve25519_scalar_muladd.hty 287 := t287,
              rir_reg% fd_curve25519_scalar_muladd.hty 288 := t288,
              rir_reg% fd_curve25519_scalar_muladd.hty 289 := t289,
              rir_reg% fd_curve25519_scalar_muladd.hty 290 := t290,
              rir_reg% fd_curve25519_scalar_muladd.hty 291 := t291,
              rir_reg% fd_curve25519_scalar_muladd.hty 292 := t292,
              rir_reg% fd_curve25519_scalar_muladd.hty 305 := s16,
              rir_reg% fd_curve25519_scalar_muladd.hty 306 := t306,
              rir_reg% fd_curve25519_scalar_muladd.hty 307 := t307,
              rir_reg% fd_curve25519_scalar_muladd.hty 308 := t308,
              rir_reg% fd_curve25519_scalar_muladd.hty 309 := t309,
              rir_reg% fd_curve25519_scalar_muladd.hty 310 := t310,
              rir_reg% fd_curve25519_scalar_muladd.hty 311 := t311,
              rir_reg% fd_curve25519_scalar_muladd.hty 320 := s18,
              rir_reg% fd_curve25519_scalar_muladd.hty 321 := t321,
              rir_reg% fd_curve25519_scalar_muladd.hty 322 := t322,
              rir_reg% fd_curve25519_scalar_muladd.hty 323 := t323,
              rir_reg% fd_curve25519_scalar_muladd.hty 324 := t324,
              rir_reg% fd_curve25519_scalar_muladd.hty 329 := s20,
              rir_reg% fd_curve25519_scalar_muladd.hty 332 := s21,
              rir_reg% fd_curve25519_scalar_muladd.hty 333 := s22,
              rir_reg% fd_curve25519_scalar_muladd.hty 338 := s1_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 347 := s3_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 349 := s2_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 358 := s5_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 360 := s4_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 371 := s7_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 385 := s9_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 387 := s8_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 402 := s11_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 372 := t372,
              rir_reg% fd_curve25519_scalar_muladd.hty 403 := t403,
              rir_reg% fd_curve25519_scalar_muladd.hty 416 := t416]) →
          (hcarry8 : carry8 = BitVec.sshiftRight (s8 + 1048576#64) 21) →
          (ht375 : t375 = t198 + t197) →
          (ht376 : t376 = t375 + t199) →
          (ht377 : t377 = t376 + t200) →
          (ht378 : t378 = t377 + t201) →
          (ht379 : t379 = t378 + t194) →
          (ht380 : t380 = t379 + t195) →
          (ht381 : t381 = t380 + t196) →
          (ht382 : t382 = t381 + t202) →
          (ht383 : t383 = t382 + t193) →
          (hs9 : s9 = t383 + c9) →
          (hs9_1 : s9_1 = s9 + carry8) →
          (hs8_1 : s8_1 = s8 - ((BitVec.sshiftRight (s8 + 1048576#64) 21) <<< 21)) →
          (hcarry10 : carry10 = BitVec.sshiftRight (s10 + 1048576#64) 21) →
          (ht390 : t390 = t232 + t231) →
          (ht391 : t391 = t390 + t233) →
          (ht392 : t392 = t391 + t228) →
          (ht393 : t393 = t392 + t229) →
          (ht394 : t394 = t393 + t230) →
          (ht395 : t395 = t394 + t236) →
          (ht396 : t396 = t395 + t225) →
          (ht397 : t397 = t396 + c11) →
          (ht398 : t398 = t397 + t234) →
          (ht399 : t399 = t398 + t235) →
          (ht400 : t400 = t399 + t226) →
          (hs11 : s11 = t400 + t227) →
          (hs11_1 : s11_1 = s11 + carry10) →
          (hcarry12 : carry12 = BitVec.sshiftRight (s12 + 1048576#64) 21) →
          (ht406 : t406 = t261 + t264) →
          (ht407 : t407 = t406 + t262) →
          (ht408 : t408 = t407 + t263) →
          (ht409 : t409 = t408 + t267) →
          (ht410 : t410 = t409 + t258) →
          (ht411 : t411 = t410 + t265) →
          (ht412 : t412 = t411 + t266) →
          (ht413 : t413 = t412 + t259) →
          (hs13 : s13 = t413 + t260) →
          (hs13_1 : s13_1 = s13 + carry12) →
          (ht372 : t372 = t361 &&& 18446744073707454464#64) →
          (ht403 : t403 = (s10 + 1048576#64) &&& 18446744073707454464#64) →
          (ht416 : t416 = (s12 + 1048576#64) &&& 18446744073707454464#64) →
          (hbcarry8 : Bnd carry8 0 18874351) →
          (hbt375 : Bnd t375 0 8796084633602) →
          (hbt376 : Bnd t376 0 13194126950403) →
          (hbt377 : Bnd t377 0 17592169267204) →
          (hbt378 : Bnd t378 0 21990211584005) →
          (hbt379 : Bnd t379 0 26388253900806) →
          (hbt380 : Bnd t380 0 30786296217607) →
          (hbt381 : Bnd t381 0 35184338534408) →
          (hbt382 : Bnd t382 0 39582380851209) →
          (hbt383 : Bnd t383 0 43980423168010) →
          (hbs9 : Bnd s9 0 43980425265161) →
          (hbs9_1 : Bnd s9_1 0 43980444139512) →
          (hbs8_1 : Bnd s8_1 (-1048576) 1048575) →
          (hbcarry10 : Bnd carry10 0 23068651) →
          (hbt390 : Bnd t390 0 8796084633602) →
          (hbt391 : Bnd t391 0 13194126950403) →
          (hbt392 : Bnd t392 0 17592169267204) →
          (hbt393 : Bnd t393 0 21990211584005) →
          (hbt394 : Bnd t394 0 26388253900806) →
          (hbt395 : Bnd t395 0 96756962426887) →
          (hbt396 : Bnd t396 0 167125670952968) →
          (hbt397 : Bnd t397 0 167125704507399) →
          (hbt398 : Bnd t398 0 171523746824200) →
          (hbt399 : Bnd t399 0 175921789141001) →
          (hbt400 : Bnd t400 0 180319831457802) →
          (hbs11 : Bnd s11 0 184717873774603) →
          (hbs11_1 : Bnd s11_1 0 184717896843254) →
          (hbcarry12 : Bnd carry12 0 85983180) →
          (hbt406 : Bnd t406 0 8796084633602) →
          (hbt407 : Bnd t407 0 13194126950403) →
          (hbt408 : Bnd t408 0 17592169267204) →
          (hbt409 : Bnd t409 0 87960877793285) →
          (hbt410 : Bnd t410 0 158329586319366) →
          (hbt411 : Bnd t411 0 162727628636167) →
          (hbt412 : Bnd t412 0 167125670952968) →
          (hbt413 : Bnd t413 0 171523713269769) →
          (hbs13 : Bnd s13 0 175921755586570) →
          (hbs13_1 : Bnd s13_1 0 175921841569750) →
          (hbt372 : Bnd t372 0 30786298314752) →
          (hbt403 : Bnd t403 0 48378467581952) →
          (hbt416 : Bnd t416 0 180319797903360) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 417 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 372 S >>= g) = K := by
  step_pure with t372
  sbnd t372
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry8
  sbnd carry8
  step_pure [nswAdd, nuwAdd] with t375
  sbnd t375
  step_pure [nswAdd, nuwAdd] with t376
  sbnd t376
  step_pure [nswAdd, nuwAdd] with t377
  sbnd t377
  step_pure [nswAdd, nuwAdd] with t378
  sbnd t378
  step_pure [nswAdd, nuwAdd] with t379
  sbnd t379
  step_pure [nswAdd, nuwAdd] with t380
  sbnd t380
  step_pure [nswAdd, nuwAdd] with t381
  sbnd t381
  step_pure [nswAdd, nuwAdd] with t382
  sbnd t382
  step_pure [nswAdd, nuwAdd] with t383
  sbnd t383
  step_pure [nswAdd, nuwAdd] with s9
  sbnd s9
  step_pure [nswAdd, nuwAdd] with s9_1
  sbnd s9_1
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s8_1
  sbnd s8_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry10
  sbnd carry10
  step_pure [nswAdd, nuwAdd] with t390
  sbnd t390
  step_pure [nswAdd, nuwAdd] with t391
  sbnd t391
  step_pure [nswAdd, nuwAdd] with t392
  sbnd t392
  step_pure [nswAdd, nuwAdd] with t393
  sbnd t393
  step_pure [nswAdd, nuwAdd] with t394
  sbnd t394
  step_pure [nswAdd, nuwAdd] with t395
  sbnd t395
  step_pure [nswAdd, nuwAdd] with t396
  sbnd t396
  step_pure [nswAdd, nuwAdd] with t397
  sbnd t397
  step_pure [nswAdd, nuwAdd] with t398
  sbnd t398
  step_pure [nswAdd, nuwAdd] with t399
  sbnd t399
  step_pure [nswAdd, nuwAdd] with t400
  sbnd t400
  step_pure [nswAdd, nuwAdd] with s11
  sbnd s11
  step_pure [nswAdd, nuwAdd] with s11_1
  sbnd s11_1
  step_pure with t403
  sbnd t403
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry12
  sbnd carry12
  step_pure [nswAdd, nuwAdd] with t406
  sbnd t406
  step_pure [nswAdd, nuwAdd] with t407
  sbnd t407
  step_pure [nswAdd, nuwAdd] with t408
  sbnd t408
  step_pure [nswAdd, nuwAdd] with t409
  sbnd t409
  step_pure [nswAdd, nuwAdd] with t410
  sbnd t410
  step_pure [nswAdd, nuwAdd] with t411
  sbnd t411
  step_pure [nswAdd, nuwAdd] with t412
  sbnd t412
  step_pure [nswAdd, nuwAdd] with t413
  sbnd t413
  step_pure [nswAdd, nuwAdd] with s13
  sbnd s13
  step_pure [nswAdd, nuwAdd] with s13_1
  sbnd s13_1
  step_pure with t416
  sbnd t416
  exact
    hK _ carry8 t375 t376 t377 t378 t379 t380 t381 t382 t383 s9 s9_1 s8_1 carry10 t390 t391 t392
      t393 t394 t395 t396 t397 t398 t399 t400 s11 s11_1 carry12 t406 t407 t408 t409 t410 t411 t412
      t413 s13 s13_1 t372 t403 t416 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) hcarry8 ht375 ht376 ht377 ht378 ht379 ht380 ht381 ht382 ht383 hs9 hs9_1 hs8_1
      hcarry10 ht390 ht391 ht392 ht393 ht394 ht395 ht396 ht397 ht398 ht399 ht400 hs11 hs11_1
      hcarry12 ht406 ht407 ht408 ht409 ht410 ht411 ht412 ht413 hs13 hs13_1 ht372 ht403 ht416
      hbcarry8 hbt375 hbt376 hbt377 hbt378 hbt379 hbt380 hbt381 hbt382 hbt383 hbs9 hbs9_1 hbs8_1
      hbcarry10 hbt390 hbt391 hbt392 hbt393 hbt394 hbt395 hbt396 hbt397 hbt398 hbt399 hbt400 hbs11
      hbs11_1 hbcarry12 hbt406 hbt407 hbt408 hbt409 hbt410 hbt411 hbt412 hbt413 hbs13 hbs13_1 hbt372
      hbt403 hbt416

/-- From `%417`: `carry14` … `s4_2`. -/
theorem fd_curve25519_scalar_muladd.run417 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s6 s10 s12 s14 t285 t286 t287 t288 t289 t290 t291 t292 s16 t306 t307 t308 t309 t310 t311 s18
      t321 t322 t323 t324 s20 s21 s22 s1_1 s0_1 s3_1 s2_1 s5_1 s4_1 s7_1 t372 s9_1 s8_1 s11_1 t403
      s13_1 t416 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
        rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
        rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
        rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
        rir_reg% fd_curve25519_scalar_muladd.hty 285 := t285,
        rir_reg% fd_curve25519_scalar_muladd.hty 286 := t286,
        rir_reg% fd_curve25519_scalar_muladd.hty 287 := t287,
        rir_reg% fd_curve25519_scalar_muladd.hty 288 := t288,
        rir_reg% fd_curve25519_scalar_muladd.hty 289 := t289,
        rir_reg% fd_curve25519_scalar_muladd.hty 290 := t290,
        rir_reg% fd_curve25519_scalar_muladd.hty 291 := t291,
        rir_reg% fd_curve25519_scalar_muladd.hty 292 := t292,
        rir_reg% fd_curve25519_scalar_muladd.hty 305 := s16,
        rir_reg% fd_curve25519_scalar_muladd.hty 306 := t306,
        rir_reg% fd_curve25519_scalar_muladd.hty 307 := t307,
        rir_reg% fd_curve25519_scalar_muladd.hty 308 := t308,
        rir_reg% fd_curve25519_scalar_muladd.hty 309 := t309,
        rir_reg% fd_curve25519_scalar_muladd.hty 310 := t310,
        rir_reg% fd_curve25519_scalar_muladd.hty 311 := t311,
        rir_reg% fd_curve25519_scalar_muladd.hty 320 := s18,
        rir_reg% fd_curve25519_scalar_muladd.hty 321 := t321,
        rir_reg% fd_curve25519_scalar_muladd.hty 322 := t322,
        rir_reg% fd_curve25519_scalar_muladd.hty 323 := t323,
        rir_reg% fd_curve25519_scalar_muladd.hty 324 := t324,
        rir_reg% fd_curve25519_scalar_muladd.hty 329 := s20,
        rir_reg% fd_curve25519_scalar_muladd.hty 332 := s21,
        rir_reg% fd_curve25519_scalar_muladd.hty 333 := s22,
        rir_reg% fd_curve25519_scalar_muladd.hty 338 := s1_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 347 := s3_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 349 := s2_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 358 := s5_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 360 := s4_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 371 := s7_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 385 := s9_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 387 := s8_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 402 := s11_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 372 := t372,
        rir_reg% fd_curve25519_scalar_muladd.hty 403 := t403,
        rir_reg% fd_curve25519_scalar_muladd.hty 416 := t416])
    (hbs14 : Bnd s14 0 171523713269769) (hbt285 : Bnd t285 0 70368708526081)
    (hbt286 : Bnd t286 0 4398042316801) (hbt287 : Bnd t287 0 4398042316801)
    (hbt288 : Bnd t288 0 4398042316801) (hbt289 : Bnd t289 0 4398042316801)
    (hbt290 : Bnd t290 0 4398042316801) (hbt291 : Bnd t291 0 4398042316801)
    (hbt292 : Bnd t292 0 70368708526081) (hbs16 : Bnd s16 0 162727628636167)
    (hbt306 : Bnd t306 0 70368708526081) (hbt307 : Bnd t307 0 4398042316801)
    (hbt308 : Bnd t308 0 4398042316801) (hbt309 : Bnd t309 0 4398042316801)
    (hbt310 : Bnd t310 0 4398042316801) (hbt311 : Bnd t311 0 70368708526081)
    (hbs18 : Bnd s18 0 153931544002565) (hbt321 : Bnd t321 0 70368708526081)
    (hbt322 : Bnd t322 0 4398042316801) (hbt323 : Bnd t323 0 4398042316801)
    (hbt324 : Bnd t324 0 70368708526081) (hbs20 : Bnd s20 0 145135459368963)
    (hbs21 : Bnd s21 0 140737417052162) (hbs22 : Bnd s22 0 1125899839733761)
    (hbs1_1 : Bnd s1_1 0 8796088827904) (hbs3_1 : Bnd s3_1 0 17592177655806)
    (hbs2_1 : Bnd s2_1 (-1048576) 1048575) (hbs4_1 : Bnd s4_1 (-1048576) 1048575)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (carry14 t419 t420 t421 t422 t423 t424 s15 s15_1 carry16 t430 t431 t432 t433 s17 s17_1
          carry18 t439 t440 s19 s19_1 s18_1 carry20 s21_1 s20_1 carry22 s22_1 carry1 s2_2 s1_2
          carry3 s4_2 t427 t436 t459 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
              rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
              rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
              rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
              rir_reg% fd_curve25519_scalar_muladd.hty 305 := s16,
              rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 347 := s3_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 358 := s5_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 371 := s7_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 385 := s9_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 387 := s8_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 402 := s11_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 426 := s15_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 435 := s17_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 442 := s19_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 444 := s18_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 447 := s21_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 449 := s20_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 451 := carry22,
              rir_reg% fd_curve25519_scalar_muladd.hty 453 := s22_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 372 := t372,
              rir_reg% fd_curve25519_scalar_muladd.hty 403 := t403,
              rir_reg% fd_curve25519_scalar_muladd.hty 416 := t416,
              rir_reg% fd_curve25519_scalar_muladd.hty 427 := t427,
              rir_reg% fd_curve25519_scalar_muladd.hty 436 := t436,
              rir_reg% fd_curve25519_scalar_muladd.hty 459 := t459]) →
          (hcarry14 : carry14 = BitVec.sshiftRight (s14 + 1048576#64) 21) →
          (ht419 : t419 = t289 + t288) →
          (ht420 : t420 = t419 + t292) →
          (ht421 : t421 = t420 + t285) →
          (ht422 : t422 = t421 + t290) →
          (ht423 : t423 = t422 + t291) →
          (ht424 : t424 = t423 + t286) →
          (hs15 : s15 = t424 + t287) →
          (hs15_1 : s15_1 = s15 + carry14) →
          (hcarry16 : carry16 = BitVec.sshiftRight (s16 + 1048576#64) 21) →
          (ht430 : t430 = t306 + t311) →
          (ht431 : t431 = t430 + t309) →
          (ht432 : t432 = t431 + t310) →
          (ht433 : t433 = t432 + t307) →
          (hs17 : s17 = t433 + t308) →
          (hs17_1 : s17_1 = s17 + carry16) →
          (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21) →
          (ht439 : t439 = t321 + t324) →
          (ht440 : t440 = t439 + t322) →
          (hs19 : s19 = t440 + t323) →
          (hs19_1 : s19_1 = s19 + carry18) →
          (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21)) →
          (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21) →
          (hs21_1 : s21_1 = s21 + carry20) →
          (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21)) →
          (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21) →
          (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21)) →
          (hcarry1 : carry1 = BitVec.sshiftRight (s1_1 + 1048576#64) 21) →
          (hs2_2 : s2_2 = s2_1 + carry1) →
          (hs1_2 : s1_2 = s1_1 - ((BitVec.sshiftRight (s1_1 + 1048576#64) 21) <<< 21)) →
          (hcarry3 : carry3 = BitVec.sshiftRight t459 21) →
          (hs4_2 : s4_2 = s4_1 + carry3) →
          (ht427 : t427 = (s14 + 1048576#64) &&& 18446744073707454464#64) →
          (ht436 : t436 = (s16 + 1048576#64) &&& 18446744073707454464#64) →
          (ht459 : t459 = s3_1 + 1048576#64) →
          (hbcarry14 : Bnd carry14 0 81788880) →
          (hbt419 : Bnd t419 0 8796084633602) →
          (hbt420 : Bnd t420 0 79164793159683) →
          (hbt421 : Bnd t421 0 149533501685764) →
          (hbt422 : Bnd t422 0 153931544002565) →
          (hbt423 : Bnd t423 0 158329586319366) →
          (hbt424 : Bnd t424 0 162727628636167) →
          (hbs15 : Bnd s15 0 167125670952968) →
          (hbs15_1 : Bnd s15_1 0 167125752741848) →
          (hbcarry16 : Bnd carry16 0 77594580) →
          (hbt430 : Bnd t430 0 140737417052162) →
          (hbt431 : Bnd t431 0 145135459368963) →
          (hbt432 : Bnd t432 0 149533501685764) →
          (hbt433 : Bnd t433 0 153931544002565) →
          (hbs17 : Bnd s17 0 158329586319366) →
          (hbs17_1 : Bnd s17_1 0 158329663913946) →
          (hbcarry18 : Bnd carry18 0 73400280) →
          (hbt439 : Bnd t439 0 140737417052162) →
          (hbt440 : Bnd t440 0 145135459368963) →
          (hbs19 : Bnd s19 0 149533501685764) →
          (hbs19_1 : Bnd s19_1 0 149533575086044) →
          (hbs18_1 : Bnd s18_1 (-1048576) 1048575) →
          (hbcarry20 : Bnd carry20 0 69205980) →
          (hbs21_1 : Bnd s21_1 0 140737486258142) →
          (hbs20_1 : Bnd s20_1 (-1048576) 1048575) →
          (hbcarry22 : Bnd carry22 0 536870880) →
          (hbs22_1 : Bnd s22_1 (-1048576) 1048575) →
          (hbcarry1 : Bnd carry1 0 4194302) →
          (hbs2_2 : Bnd s2_2 (-1048576) 5242877) →
          (hbs1_2 : Bnd s1_2 (-1048576) 1048575) →
          (hbcarry3 : Bnd carry3 0 8388604) →
          (hbs4_2 : Bnd s4_2 (-1048576) 9437179) →
          (hbt427 : Bnd t427 0 171523713269760) →
          (hbt436 : Bnd t436 0 162727628636160) →
          (hbt459 : Bnd t459 1048576 17592178704382) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 462 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 417 S >>= g) = K := by
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry14
  sbnd carry14
  step_pure [nswAdd, nuwAdd] with t419
  sbnd t419
  step_pure [nswAdd, nuwAdd] with t420
  sbnd t420
  step_pure [nswAdd, nuwAdd] with t421
  sbnd t421
  step_pure [nswAdd, nuwAdd] with t422
  sbnd t422
  step_pure [nswAdd, nuwAdd] with t423
  sbnd t423
  step_pure [nswAdd, nuwAdd] with t424
  sbnd t424
  step_pure [nswAdd, nuwAdd] with s15
  sbnd s15
  step_pure [nswAdd, nuwAdd] with s15_1
  sbnd s15_1
  step_pure with t427
  sbnd t427
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry16
  sbnd carry16
  step_pure [nswAdd, nuwAdd] with t430
  sbnd t430
  step_pure [nswAdd, nuwAdd] with t431
  sbnd t431
  step_pure [nswAdd, nuwAdd] with t432
  sbnd t432
  step_pure [nswAdd, nuwAdd] with t433
  sbnd t433
  step_pure [nswAdd, nuwAdd] with s17
  sbnd s17
  step_pure [nswAdd, nuwAdd] with s17_1
  sbnd s17_1
  step_pure with t436
  sbnd t436
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry18
  sbnd carry18
  step_pure [nswAdd, nuwAdd] with t439
  sbnd t439
  step_pure [nswAdd, nuwAdd] with t440
  sbnd t440
  step_pure [nswAdd, nuwAdd] with s19
  sbnd s19
  step_pure [nswAdd, nuwAdd] with s19_1
  sbnd s19_1
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s18_1
  sbnd s18_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry20
  sbnd carry20
  step_pure [nswAdd, nuwAdd] with s21_1
  sbnd s21_1
  step_pure [Sc.andMaskN]
  step_pure [Sc.nswSubS] with s20_1
  sbnd s20_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry22
  sbnd carry22
  step_pure [Sc.andMaskN]
  step_pure [Sc.nswSubS] with s22_1
  sbnd s22_1
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry1
  sbnd carry1
  step_pure [nswAdd] with s2_2
  sbnd s2_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s1_2
  sbnd s1_2
  step_pure [nswAdd, nuwAdd] with t459
  sbnd t459
  step_pure [lshrNonneg] with carry3
  sbnd carry3
  step_pure [nswAdd] with s4_2
  sbnd s4_2
  exact
    hK _ carry14 t419 t420 t421 t422 t423 t424 s15 s15_1 carry16 t430 t431 t432 t433 s17 s17_1
      carry18 t439 t440 s19 s19_1 s18_1 carry20 s21_1 s20_1 carry22 s22_1 carry1 s2_2 s1_2 carry3
      s4_2 t427 t436 t459 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) hcarry14 ht419 ht420 ht421 ht422 ht423 ht424 hs15 hs15_1 hcarry16 ht430 ht431
      ht432 ht433 hs17 hs17_1 hcarry18 ht439 ht440 hs19 hs19_1 hs18_1 hcarry20 hs21_1 hs20_1
      hcarry22 hs22_1 hcarry1 hs2_2 hs1_2 hcarry3 hs4_2 ht427 ht436 ht459 hbcarry14 hbt419 hbt420
      hbt421 hbt422 hbt423 hbt424 hbs15 hbs15_1 hbcarry16 hbt430 hbt431 hbt432 hbt433 hbs17 hbs17_1
      hbcarry18 hbt439 hbt440 hbs19 hbs19_1 hbs18_1 hbcarry20 hbs21_1 hbs20_1 hbcarry22 hbs22_1
      hbcarry1 hbs2_2 hbs1_2 hbcarry3 hbs4_2 hbt427 hbt436 hbt459

/-- From `%462`: `s3_2` … `s21_2`. -/
theorem fd_curve25519_scalar_muladd.run462 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s6 s10 s12 s14 s16 s0_1 s3_1 s5_1 s7_1 t372 s9_1 s8_1 s11_1 t403 s13_1 t416 s15_1 t427 s17_1
      t436 s19_1 s18_1 s21_1 s20_1 carry22 s22_1 s2_2 s1_2 t459 s4_2 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
        rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
        rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
        rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
        rir_reg% fd_curve25519_scalar_muladd.hty 305 := s16,
        rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 347 := s3_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 358 := s5_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 371 := s7_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 385 := s9_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 387 := s8_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 402 := s11_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 426 := s15_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 435 := s17_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 442 := s19_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 444 := s18_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 447 := s21_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 449 := s20_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 451 := carry22,
        rir_reg% fd_curve25519_scalar_muladd.hty 453 := s22_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 372 := t372,
        rir_reg% fd_curve25519_scalar_muladd.hty 403 := t403,
        rir_reg% fd_curve25519_scalar_muladd.hty 416 := t416,
        rir_reg% fd_curve25519_scalar_muladd.hty 427 := t427,
        rir_reg% fd_curve25519_scalar_muladd.hty 436 := t436,
        rir_reg% fd_curve25519_scalar_muladd.hty 459 := t459])
    (hbs16 : Bnd s16 0 162727628636167) (hbs3_1 : Bnd s3_1 0 17592177655806)
    (hbs5_1 : Bnd s5_1 0 26388266483708) (hbs7_1 : Bnd s7_1 0 35184355311610)
    (hbs9_1 : Bnd s9_1 0 43980444139512) (hbs8_1 : Bnd s8_1 (-1048576) 1048575)
    (hbs11_1 : Bnd s11_1 0 184717896843254) (hbs13_1 : Bnd s13_1 0 175921841569750)
    (hbs15_1 : Bnd s15_1 0 167125752741848) (hbs17_1 : Bnd s17_1 0 158329663913946)
    (hbs19_1 : Bnd s19_1 0 149533575086044) (hbs18_1 : Bnd s18_1 (-1048576) 1048575)
    (hbs21_1 : Bnd s21_1 0 140737486258142) (hbs20_1 : Bnd s20_1 (-1048576) 1048575)
    (hbcarry22 : Bnd carry22 0 536870880) (hbs22_1 : Bnd s22_1 (-1048576) 1048575)
    (hbt459 : Bnd t459 1048576 17592178704382)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (s3_2 carry5 s5_2 carry7 s8_2 s7_2 carry9 carry11 carry13 carry15 carry17 s18_2 s17_2
          carry19 s20_2 s19_2 carry21 s22_2 s21_2 t500 t501 t502 t503 t504 t505 t506 t475 t478 t481
          t484 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
              rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
              rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
              rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
              rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 385 := s9_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 402 := s11_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 426 := s15_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 463 := s3_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 465 := carry5,
              rir_reg% fd_curve25519_scalar_muladd.hty 467 := s5_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 470 := s8_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 472 := s7_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 474 := carry9,
              rir_reg% fd_curve25519_scalar_muladd.hty 477 := carry11,
              rir_reg% fd_curve25519_scalar_muladd.hty 480 := carry13,
              rir_reg% fd_curve25519_scalar_muladd.hty 483 := carry15,
              rir_reg% fd_curve25519_scalar_muladd.hty 487 := s18_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 489 := s17_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 492 := s20_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 494 := s19_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 497 := s22_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 499 := s21_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 500 := t500,
              rir_reg% fd_curve25519_scalar_muladd.hty 501 := t501,
              rir_reg% fd_curve25519_scalar_muladd.hty 502 := t502,
              rir_reg% fd_curve25519_scalar_muladd.hty 503 := t503,
              rir_reg% fd_curve25519_scalar_muladd.hty 504 := t504,
              rir_reg% fd_curve25519_scalar_muladd.hty 506 := t506,
              rir_reg% fd_curve25519_scalar_muladd.hty 372 := t372,
              rir_reg% fd_curve25519_scalar_muladd.hty 403 := t403,
              rir_reg% fd_curve25519_scalar_muladd.hty 416 := t416,
              rir_reg% fd_curve25519_scalar_muladd.hty 427 := t427,
              rir_reg% fd_curve25519_scalar_muladd.hty 436 := t436,
              rir_reg% fd_curve25519_scalar_muladd.hty 475 := t475,
              rir_reg% fd_curve25519_scalar_muladd.hty 478 := t478,
              rir_reg% fd_curve25519_scalar_muladd.hty 481 := t481,
              rir_reg% fd_curve25519_scalar_muladd.hty 484 := t484]) →
          (hs3_2 : s3_2 = s3_1 - ((BitVec.sshiftRight t459 21) <<< 21)) →
          (hcarry5 : carry5 = BitVec.sshiftRight (s5_1 + 1048576#64) 21) →
          (hs5_2 : s5_2 = s5_1 - ((BitVec.sshiftRight (s5_1 + 1048576#64) 21) <<< 21)) →
          (hcarry7 : carry7 = BitVec.sshiftRight (s7_1 + 1048576#64) 21) →
          (hs8_2 : s8_2 = s8_1 + carry7) →
          (hs7_2 : s7_2 = s7_1 - ((BitVec.sshiftRight (s7_1 + 1048576#64) 21) <<< 21)) →
          (hcarry9 : carry9 = BitVec.sshiftRight (s9_1 + 1048576#64) 21) →
          (hcarry11 : carry11 = BitVec.sshiftRight (s11_1 + 1048576#64) 21) →
          (hcarry13 : carry13 = BitVec.sshiftRight (s13_1 + 1048576#64) 21) →
          (hcarry15 : carry15 = BitVec.sshiftRight (s15_1 + 1048576#64) 21) →
          (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21) →
          (hs18_2 : s18_2 = carry17 + s18_1) →
          (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21)) →
          (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21) →
          (hs20_2 : s20_2 = carry19 + s20_1) →
          (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21)) →
          (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21) →
          (hs22_2 : s22_2 = carry21 + s22_1) →
          (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21)) →
          (ht500 : t500 = carry22 * 666643#64) →
          (ht501 : t501 = carry22 * 470296#64) →
          (ht502 : t502 = carry22 * 654183#64) →
          (ht503 : t503 = carry22 * 18446744073708553811#64) →
          (ht504 : t504 = carry22 * 136657#64) →
          (ht505 : t505 = carry22 * 18446744073708867715#64) →
          (ht506 : t506 = s16 + t505) →
          (ht475 : t475 = (s9_1 + 1048576#64) &&& 18446744073707454464#64) →
          (ht478 : t478 = (s11_1 + 1048576#64) &&& 18446744073707454464#64) →
          (ht481 : t481 = (s13_1 + 1048576#64) &&& 18446744073707454464#64) →
          (ht484 : t484 = (s15_1 + 1048576#64) &&& 18446744073707454464#64) →
          (hbs3_2 : Bnd s3_2 (-9223372036854775808) 9223372036854775807) →
          (hbcarry5 : Bnd carry5 0 12582906) →
          (hbs5_2 : Bnd s5_2 (-1048576) 1048575) →
          (hbcarry7 : Bnd carry7 0 16777208) →
          (hbs8_2 : Bnd s8_2 (-1048576) 17825783) →
          (hbs7_2 : Bnd s7_2 (-1048576) 1048575) →
          (hbcarry9 : Bnd carry9 0 20971510) →
          (hbcarry11 : Bnd carry11 0 88080357) →
          (hbcarry13 : Bnd carry13 0 83886071) →
          (hbcarry15 : Bnd carry15 0 79691769) →
          (hbcarry17 : Bnd carry17 0 75497467) →
          (hbs18_2 : Bnd s18_2 (-1048576) 76546042) →
          (hbs17_2 : Bnd s17_2 (-1048576) 1048575) →
          (hbcarry19 : Bnd carry19 0 71303165) →
          (hbs20_2 : Bnd s20_2 (-1048576) 72351740) →
          (hbs19_2 : Bnd s19_2 (-1048576) 1048575) →
          (hbcarry21 : Bnd carry21 0 67108863) →
          (hbs22_2 : Bnd s22_2 (-1048576) 68157438) →
          (hbs21_2 : Bnd s21_2 (-1048576) 1048575) →
          (hbt500 : Bnd t500 0 357901214055840) →
          (hbt501 : Bnd t501 0 252488227380480) →
          (hbt502 : Bnd t502 0 351211802891040) →
          (hbt503 : Bnd t503 (-535692448418400) 0) →
          (hbt504 : Bnd t504 0 73367163848160) →
          (hbt505 : Bnd t505 (-367166531702880) 0) →
          (hbt506 : Bnd t506 (-367166531702880) 162727628636167) →
          (hbt475 : Bnd t475 0 43980444139520) →
          (hbt478 : Bnd t478 0 184717896843264) →
          (hbt481 : Bnd t481 0 175921841569792) →
          (hbt484 : Bnd t484 0 167125752741888) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 507 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 462 S >>= g) = K := by
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s3_2
  sbnd s3_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry5
  sbnd carry5
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s5_2
  sbnd s5_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry7
  sbnd carry7
  step_pure [nswAdd] with s8_2
  sbnd s8_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s7_2
  sbnd s7_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry9
  sbnd carry9
  step_pure with t475
  sbnd t475
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry11
  sbnd carry11
  step_pure with t478
  sbnd t478
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry13
  sbnd carry13
  step_pure with t481
  sbnd t481
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry15
  sbnd carry15
  step_pure with t484
  sbnd t484
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry17
  sbnd carry17
  step_pure [nswAdd] with s18_2
  sbnd s18_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s17_2
  sbnd s17_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry19
  sbnd carry19
  step_pure [nswAdd] with s20_2
  sbnd s20_2
  step_pure [Bnd.and_neg_shift]
  step_pure [Sc.nswSubS] with s19_2
  sbnd s19_2
  step_pure [nswAdd, nuwAdd]
  step_pure [lshrNonneg] with carry21
  sbnd carry21
  step_pure [nswAdd] with s22_2
  sbnd s22_2
  step_pure [Sc.andMaskN]
  step_pure [Sc.nswSubS] with s21_2
  sbnd s21_2
  step_pure [nswMul, nuwMul] with t500
  sbnd t500
  step_pure [nswMul, nuwMul] with t501
  sbnd t501
  step_pure [nswMul, nuwMul] with t502
  sbnd t502
  step_pure [nswMul] with t503
  sbnd t503
  step_pure [nswMul, nuwMul] with t504
  sbnd t504
  step_pure [nswMul] with t505
  sbnd t505
  step_pure [nswAdd] with t506
  sbnd t506
  exact
    hK _ s3_2 carry5 s5_2 carry7 s8_2 s7_2 carry9 carry11 carry13 carry15 carry17 s18_2 s17_2
      carry19 s20_2 s19_2 carry21 s22_2 s21_2 t500 t501 t502 t503 t504 t505 t506 t475 t478 t481 t484
      hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) hs3_2 hcarry5 hs5_2 hcarry7 hs8_2 hs7_2 hcarry9 hcarry11 hcarry13 hcarry15
      hcarry17 hs18_2 hs17_2 hcarry19 hs20_2 hs19_2 hcarry21 hs22_2 hs21_2 ht500 ht501 ht502 ht503
      ht504 ht505 ht506 ht475 ht478 ht481 ht484 hbs3_2 hbcarry5 hbs5_2 hbcarry7 hbs8_2 hbs7_2
      hbcarry9 hbcarry11 hbcarry13 hbcarry15 hbcarry17 hbs18_2 hbs17_2 hbcarry19 hbs20_2 hbs19_2
      hbcarry21 hbs22_2 hbs21_2 hbt500 hbt501 hbt502 hbt503 hbt504 hbt505 hbt506 hbt475 hbt478
      hbt481 hbt484

/-- From `%507`: `s16_3` … `s6_3`. -/
theorem fd_curve25519_scalar_muladd.run507 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s6 s10 s12 s14 s0_1 t372 s9_1 s11_1 t403 s13_1 t416 s15_1 t427 t436 s2_2 s1_2 s4_2 s3_2 carry5
      s5_2 s8_2 s7_2 carry9 t475 carry11 t478 carry13 t481 carry15 t484 s18_2 s17_2 s20_2 s19_2
      s22_2 s21_2 t500 t501 t502 t503 t504 t506 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 166 := s6,
        rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
        rir_reg% fd_curve25519_scalar_muladd.hty 257 := s12,
        rir_reg% fd_curve25519_scalar_muladd.hty 284 := s14,
        rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 385 := s9_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 402 := s11_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 426 := s15_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 463 := s3_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 465 := carry5,
        rir_reg% fd_curve25519_scalar_muladd.hty 467 := s5_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 470 := s8_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 472 := s7_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 474 := carry9,
        rir_reg% fd_curve25519_scalar_muladd.hty 477 := carry11,
        rir_reg% fd_curve25519_scalar_muladd.hty 480 := carry13,
        rir_reg% fd_curve25519_scalar_muladd.hty 483 := carry15,
        rir_reg% fd_curve25519_scalar_muladd.hty 487 := s18_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 489 := s17_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 492 := s20_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 494 := s19_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 497 := s22_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 499 := s21_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 500 := t500,
        rir_reg% fd_curve25519_scalar_muladd.hty 501 := t501,
        rir_reg% fd_curve25519_scalar_muladd.hty 502 := t502,
        rir_reg% fd_curve25519_scalar_muladd.hty 503 := t503,
        rir_reg% fd_curve25519_scalar_muladd.hty 504 := t504,
        rir_reg% fd_curve25519_scalar_muladd.hty 506 := t506,
        rir_reg% fd_curve25519_scalar_muladd.hty 372 := t372,
        rir_reg% fd_curve25519_scalar_muladd.hty 403 := t403,
        rir_reg% fd_curve25519_scalar_muladd.hty 416 := t416,
        rir_reg% fd_curve25519_scalar_muladd.hty 427 := t427,
        rir_reg% fd_curve25519_scalar_muladd.hty 436 := t436,
        rir_reg% fd_curve25519_scalar_muladd.hty 475 := t475,
        rir_reg% fd_curve25519_scalar_muladd.hty 478 := t478,
        rir_reg% fd_curve25519_scalar_muladd.hty 481 := t481,
        rir_reg% fd_curve25519_scalar_muladd.hty 484 := t484])
    (hbs6 : Bnd s6 0 30786298314758) (hbs12 : Bnd s12 0 180319797903371)
    (hbs14 : Bnd s14 0 171523713269769) (hbt372 : Bnd t372 0 30786298314752)
    (hbt416 : Bnd t416 0 180319797903360) (hbt427 : Bnd t427 0 171523713269760)
    (hbt436 : Bnd t436 0 162727628636160) (hbcarry5 : Bnd carry5 0 12582906)
    (hbs8_2 : Bnd s8_2 (-1048576) 17825783) (hbs7_2 : Bnd s7_2 (-1048576) 1048575)
    (hbcarry11 : Bnd carry11 0 88080357) (hbcarry13 : Bnd carry13 0 83886071)
    (hbcarry15 : Bnd carry15 0 79691769) (hbs18_2 : Bnd s18_2 (-1048576) 76546042)
    (hbs20_2 : Bnd s20_2 (-1048576) 72351740) (hbs19_2 : Bnd s19_2 (-1048576) 1048575)
    (hbs22_2 : Bnd s22_2 (-1048576) 68157438) (hbs21_2 : Bnd s21_2 (-1048576) 1048575)
    (hbt501 : Bnd t501 0 252488227380480) (hbt503 : Bnd t503 (-535692448418400) 0)
    (hbt506 : Bnd t506 (-367166531702880) 162727628636167)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t507 s16_3 t509 t510 t511 t512 t513 t514 t515 t516 t517 t518 t519 t520 t521 t522 t523 t524
          s14_5 t526 s8_3 t528 t529 t530 t531 t532 t533 s7_3 t535 s8_4 t537 t538 t539 t540 t541 t542
          t543 t544 t545 t546 s12_7 t548 t549 s6_2 s6_3 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
              rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 385 := s9_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 402 := s11_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 426 := s15_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 463 := s3_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 467 := s5_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 474 := carry9,
              rir_reg% fd_curve25519_scalar_muladd.hty 487 := s18_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 489 := s17_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 500 := t500,
              rir_reg% fd_curve25519_scalar_muladd.hty 502 := t502,
              rir_reg% fd_curve25519_scalar_muladd.hty 504 := t504,
              rir_reg% fd_curve25519_scalar_muladd.hty 508 := s16_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 509 := t509,
              rir_reg% fd_curve25519_scalar_muladd.hty 510 := t510,
              rir_reg% fd_curve25519_scalar_muladd.hty 512 := t512,
              rir_reg% fd_curve25519_scalar_muladd.hty 514 := t514,
              rir_reg% fd_curve25519_scalar_muladd.hty 515 := t515,
              rir_reg% fd_curve25519_scalar_muladd.hty 516 := t516,
              rir_reg% fd_curve25519_scalar_muladd.hty 517 := t517,
              rir_reg% fd_curve25519_scalar_muladd.hty 519 := t519,
              rir_reg% fd_curve25519_scalar_muladd.hty 525 := s14_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 528 := t528,
              rir_reg% fd_curve25519_scalar_muladd.hty 529 := t529,
              rir_reg% fd_curve25519_scalar_muladd.hty 530 := t530,
              rir_reg% fd_curve25519_scalar_muladd.hty 532 := t532,
              rir_reg% fd_curve25519_scalar_muladd.hty 534 := s7_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 536 := s8_4,
              rir_reg% fd_curve25519_scalar_muladd.hty 537 := t537,
              rir_reg% fd_curve25519_scalar_muladd.hty 538 := t538,
              rir_reg% fd_curve25519_scalar_muladd.hty 539 := t539,
              rir_reg% fd_curve25519_scalar_muladd.hty 547 := s12_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 551 := s6_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 403 := t403,
              rir_reg% fd_curve25519_scalar_muladd.hty 475 := t475,
              rir_reg% fd_curve25519_scalar_muladd.hty 478 := t478,
              rir_reg% fd_curve25519_scalar_muladd.hty 481 := t481,
              rir_reg% fd_curve25519_scalar_muladd.hty 484 := t484]) →
          (ht507 : t507 = t506 - t436) →
          (hs16_3 : s16_3 = t507 + carry15) →
          (ht509 : t509 = s22_2 * 666643#64) →
          (ht510 : t510 = s22_2 * 470296#64) →
          (ht511 : t511 = s22_2 * 654183#64) →
          (ht512 : t512 = s22_2 * 18446744073708553811#64) →
          (ht513 : t513 = s22_2 * 136657#64) →
          (ht514 : t514 = s22_2 * 18446744073708867715#64) →
          (ht515 : t515 = s21_2 * 666643#64) →
          (ht516 : t516 = s21_2 * 470296#64) →
          (ht517 : t517 = s21_2 * 654183#64) →
          (ht518 : t518 = s21_2 * 18446744073708553811#64) →
          (ht519 : t519 = s21_2 * 136657#64) →
          (ht520 : t520 = s21_2 * 18446744073708867715#64) →
          (ht521 : t521 = s14 + t503) →
          (ht522 : t522 = t521 + t513) →
          (ht523 : t523 = t522 + t520) →
          (ht524 : t524 = t523 - t427) →
          (hs14_5 : s14_5 = t524 + carry13) →
          (ht526 : t526 = s20_2 * 666643#64) →
          (hs8_3 : s8_3 = s8_2 + t526) →
          (ht528 : t528 = s20_2 * 470296#64) →
          (ht529 : t529 = s20_2 * 654183#64) →
          (ht530 : t530 = s20_2 * 18446744073708553811#64) →
          (ht531 : t531 = s20_2 * 136657#64) →
          (ht532 : t532 = s20_2 * 18446744073708867715#64) →
          (ht533 : t533 = s19_2 * 666643#64) →
          (hs7_3 : s7_3 = s7_2 + t533) →
          (ht535 : t535 = s19_2 * 470296#64) →
          (hs8_4 : s8_4 = s8_3 + t535) →
          (ht537 : t537 = s19_2 * 654183#64) →
          (ht538 : t538 = s19_2 * 18446744073708553811#64) →
          (ht539 : t539 = s19_2 * 136657#64) →
          (ht540 : t540 = s19_2 * 18446744073708867715#64) →
          (ht541 : t541 = t511 + t501) →
          (ht542 : t542 = t541 + t518) →
          (ht543 : t543 = t542 + s12) →
          (ht544 : t544 = t543 + t531) →
          (ht545 : t545 = t544 + t540) →
          (ht546 : t546 = t545 - t416) →
          (hs12_7 : s12_7 = t546 + carry11) →
          (ht548 : t548 = s18_2 * 666643#64) →
          (ht549 : t549 = carry5 + s6) →
          (hs6_2 : s6_2 = t549 - t372) →
          (hs6_3 : s6_3 = s6_2 + t548) →
          (hbt507 : Bnd t507 (-529894160339040) 162727628636167) →
          (hbs16_3 : Bnd s16_3 (-529894160339040) 162727708327936) →
          (hbt509 : Bnd t509 (-699025850368) 45436678940634) →
          (hbt510 : Bnd t510 (-493141098496) 32054170461648) →
          (hbt511 : Bnd t511 (-685960593408) 44587437263154) →
          (hbt512 : Bnd t512 (-68007832423590) 1046274375680) →
          (hbt513 : Bnd t513 (-143295250432) 9314191004766) →
          (hbt514 : Bnd t514 (-46612940005638) 717122174976) →
          (hbt515 : Bnd t515 (-699025850368) 699025183725) →
          (hbt516 : Bnd t516 (-493141098496) 493140628200) →
          (hbt517 : Bnd t517 (-685960593408) 685959939225) →
          (hbt518 : Bnd t518 (-1046273377875) 1046274375680) →
          (hbt519 : Bnd t519 (-143295250432) 143295113775) →
          (hbt520 : Bnd t520 (-717121491075) 717122174976) →
          (hbt521 : Bnd t521 (-535692448418400) 171523713269769) →
          (hbt522 : Bnd t522 (-535835743668832) 180837904274535) →
          (hbt523 : Bnd t523 (-536552865159907) 181555026449511) →
          (hbt524 : Bnd t524 (-708076578429667) 181555026449511) →
          (hbs14_5 : Bnd s14_5 (-708076578429667) 181555110335582) →
          (hbt526 : Bnd t526 (-699025850368) 48232781008820) →
          (hbs8_3 : Bnd s8_3 (-699026898944) 48232798834603) →
          (hbt528 : Bnd t528 (-493141098496) 34026733915040) →
          (hbt529 : Bnd t529 (-685960593408) 47331278328420) →
          (hbt530 : Bnd t530 (-72192927930700) 1046274375680) →
          (hbt531 : Bnd t531 (-143295250432) 9887371733180) →
          (hbt532 : Bnd t532 (-49481427337740) 717122174976) →
          (hbt533 : Bnd t533 (-699025850368) 699025183725) →
          (hbs7_3 : Bnd s7_3 (-699026898944) 699026232300) →
          (hbt535 : Bnd t535 (-493141098496) 493140628200) →
          (hbs8_4 : Bnd s8_4 (-1192167997440) 48725939462803) →
          (hbt537 : Bnd t537 (-685960593408) 685959939225) →
          (hbt538 : Bnd t538 (-1046273377875) 1046274375680) →
          (hbt539 : Bnd t539 (-143295250432) 143295113775) →
          (hbt540 : Bnd t540 (-717121491075) 717122174976) →
          (hbt541 : Bnd t541 (-685960593408) 297075664643634) →
          (hbt542 : Bnd t542 (-1732233971283) 298121939019314) →
          (hbt543 : Bnd t543 (-1732233971283) 478441736922685) →
          (hbt544 : Bnd t544 (-1875529221715) 488329108655865) →
          (hbt545 : Bnd t545 (-2592650712790) 489046230830841) →
          (hbt546 : Bnd t546 (-182912448616150) 489046230830841) →
          (hbs12_7 : Bnd s12_7 (-182912448616150) 489046318911198) →
          (hbt548 : Bnd t548 (-699025850368) 51028883077006) →
          (hbt549 : Bnd t549 0 30786310897664) →
          (hbs6_2 : Bnd s6_2 (-30786298314752) 30786310897664) →
          (hbs6_3 : Bnd s6_3 (-31485324165120) 81815193974670) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 552 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 507 S >>= g) = K := by
  step_pure [Sc.nswSubS] with t507
  sbnd t507
  step_pure [nswAdd] with s16_3
  sbnd s16_3
  step_pure with t509
  sbnd t509
  step_pure with t510
  sbnd t510
  step_pure with t511
  sbnd t511
  step_pure with t512
  sbnd t512
  step_pure with t513
  sbnd t513
  step_pure with t514
  sbnd t514
  step_pure with t515
  sbnd t515
  step_pure with t516
  sbnd t516
  step_pure with t517
  sbnd t517
  step_pure with t518
  sbnd t518
  step_pure with t519
  sbnd t519
  step_pure with t520
  sbnd t520
  step_pure [nswAdd] with t521
  sbnd t521
  step_pure with t522
  sbnd t522
  step_pure with t523
  sbnd t523
  step_pure with t524
  sbnd t524
  step_pure with s14_5
  sbnd s14_5
  step_pure with t526
  sbnd t526
  step_pure with s8_3
  sbnd s8_3
  step_pure with t528
  sbnd t528
  step_pure with t529
  sbnd t529
  step_pure with t530
  sbnd t530
  step_pure with t531
  sbnd t531
  step_pure with t532
  sbnd t532
  step_pure with t533
  sbnd t533
  step_pure with s7_3
  sbnd s7_3
  step_pure with t535
  sbnd t535
  step_pure with s8_4
  sbnd s8_4
  step_pure with t537
  sbnd t537
  step_pure with t538
  sbnd t538
  step_pure with t539
  sbnd t539
  step_pure with t540
  sbnd t540
  step_pure with t541
  sbnd t541
  step_pure with t542
  sbnd t542
  step_pure with t543
  sbnd t543
  step_pure with t544
  sbnd t544
  step_pure with t545
  sbnd t545
  step_pure with t546
  sbnd t546
  step_pure with s12_7
  sbnd s12_7
  step_pure with t548
  sbnd t548
  step_pure [nswAdd, nuwAdd] with t549
  sbnd t549
  step_pure [Sc.nswSubS] with s6_2
  sbnd s6_2
  step_pure with s6_3
  sbnd s6_3
  exact
    hK _ t507 s16_3 t509 t510 t511 t512 t513 t514 t515 t516 t517 t518 t519 t520 t521 t522 t523 t524
      s14_5 t526 s8_3 t528 t529 t530 t531 t532 t533 s7_3 t535 s8_4 t537 t538 t539 t540 t541 t542
      t543 t544 t545 t546 s12_7 t548 t549 s6_2 s6_3 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht507 hs16_3 ht509 ht510 ht511 ht512 ht513 ht514 ht515 ht516 ht517 ht518 ht519
      ht520 ht521 ht522 ht523 ht524 hs14_5 ht526 hs8_3 ht528 ht529 ht530 ht531 ht532 ht533 hs7_3
      ht535 hs8_4 ht537 ht538 ht539 ht540 ht541 ht542 ht543 ht544 ht545 ht546 hs12_7 ht548 ht549
      hs6_2 hs6_3 hbt507 hbs16_3 hbt509 hbt510 hbt511 hbt512 hbt513 hbt514 hbt515 hbt516 hbt517
      hbt518 hbt519 hbt520 hbt521 hbt522 hbt523 hbt524 hbs14_5 hbt526 hbs8_3 hbt528 hbt529 hbt530
      hbt531 hbt532 hbt533 hbs7_3 hbt535 hbs8_4 hbt537 hbt538 hbt539 hbt540 hbt541 hbt542 hbt543
      hbt544 hbt545 hbt546 hbs12_7 hbt548 hbt549 hbs6_2 hbs6_3

/-- From `%552`: `s7_4` … `carry12_1`. -/
theorem fd_curve25519_scalar_muladd.run552 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s10 s0_1 s9_1 s11_1 t403 s13_1 s15_1 s2_2 s1_2 s4_2 s3_2 s5_2 carry9 t475 t478 t481 t484 s18_2
      s17_2 t500 t502 t504 s16_3 t509 t510 t512 t514 t515 t516 t517 t519 s14_5 t528 t529 t530 t532
      s7_3 s8_4 t537 t538 t539 s12_7 s6_3 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 224 := s10,
        rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 385 := s9_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 402 := s11_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 426 := s15_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 463 := s3_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 467 := s5_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 474 := carry9,
        rir_reg% fd_curve25519_scalar_muladd.hty 487 := s18_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 489 := s17_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 500 := t500,
        rir_reg% fd_curve25519_scalar_muladd.hty 502 := t502,
        rir_reg% fd_curve25519_scalar_muladd.hty 504 := t504,
        rir_reg% fd_curve25519_scalar_muladd.hty 508 := s16_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 509 := t509,
        rir_reg% fd_curve25519_scalar_muladd.hty 510 := t510,
        rir_reg% fd_curve25519_scalar_muladd.hty 512 := t512,
        rir_reg% fd_curve25519_scalar_muladd.hty 514 := t514,
        rir_reg% fd_curve25519_scalar_muladd.hty 515 := t515,
        rir_reg% fd_curve25519_scalar_muladd.hty 516 := t516,
        rir_reg% fd_curve25519_scalar_muladd.hty 517 := t517,
        rir_reg% fd_curve25519_scalar_muladd.hty 519 := t519,
        rir_reg% fd_curve25519_scalar_muladd.hty 525 := s14_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 528 := t528,
        rir_reg% fd_curve25519_scalar_muladd.hty 529 := t529,
        rir_reg% fd_curve25519_scalar_muladd.hty 530 := t530,
        rir_reg% fd_curve25519_scalar_muladd.hty 532 := t532,
        rir_reg% fd_curve25519_scalar_muladd.hty 534 := s7_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 536 := s8_4,
        rir_reg% fd_curve25519_scalar_muladd.hty 537 := t537,
        rir_reg% fd_curve25519_scalar_muladd.hty 538 := t538,
        rir_reg% fd_curve25519_scalar_muladd.hty 539 := t539,
        rir_reg% fd_curve25519_scalar_muladd.hty 547 := s12_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 551 := s6_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 403 := t403,
        rir_reg% fd_curve25519_scalar_muladd.hty 475 := t475,
        rir_reg% fd_curve25519_scalar_muladd.hty 478 := t478,
        rir_reg% fd_curve25519_scalar_muladd.hty 481 := t481,
        rir_reg% fd_curve25519_scalar_muladd.hty 484 := t484])
    (hbs10 : Bnd s10 0 48378467581962) (hbs9_1 : Bnd s9_1 0 43980444139512)
    (hbs11_1 : Bnd s11_1 0 184717896843254) (hbt403 : Bnd t403 0 48378467581952)
    (hbcarry9 : Bnd carry9 0 20971510) (hbt475 : Bnd t475 0 43980444139520)
    (hbt478 : Bnd t478 0 184717896843264) (hbs18_2 : Bnd s18_2 (-1048576) 76546042)
    (hbt500 : Bnd t500 0 357901214055840) (hbt502 : Bnd t502 0 351211802891040)
    (hbt509 : Bnd t509 (-699025850368) 45436678940634)
    (hbt510 : Bnd t510 (-493141098496) 32054170461648)
    (hbt512 : Bnd t512 (-68007832423590) 1046274375680)
    (hbt515 : Bnd t515 (-699025850368) 699025183725)
    (hbt516 : Bnd t516 (-493141098496) 493140628200)
    (hbt517 : Bnd t517 (-685960593408) 685959939225)
    (hbt519 : Bnd t519 (-143295250432) 143295113775)
    (hbt528 : Bnd t528 (-493141098496) 34026733915040)
    (hbt529 : Bnd t529 (-685960593408) 47331278328420)
    (hbt530 : Bnd t530 (-72192927930700) 1046274375680)
    (hbt532 : Bnd t532 (-49481427337740) 717122174976)
    (hbs7_3 : Bnd s7_3 (-699026898944) 699026232300)
    (hbs8_4 : Bnd s8_4 (-1192167997440) 48725939462803)
    (hbt537 : Bnd t537 (-685960593408) 685959939225)
    (hbt538 : Bnd t538 (-1046273377875) 1046274375680)
    (hbt539 : Bnd t539 (-143295250432) 143295113775)
    (hbs12_7 : Bnd s12_7 (-182912448616150) 489046318911198)
    (hbs6_3 : Bnd s6_3 (-31485324165120) 81815193974670)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t552 s7_4 t554 s8_5 t556 t557 t558 t559 t560 t561 t562 s10_6 s10_7 t565 carry6_1 s7_5 s6_4
          carry8_1 t573 t574 t575 s9_5 s9_6 s9_7 s8_6 carry10_1 t583 t584 t585 t586 t587 t588 s11_8
          s11_9 carry12_1 t594 t595 t596 t591 t592 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 426 := s15_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 463 := s3_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 467 := s5_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 489 := s17_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 504 := t504,
              rir_reg% fd_curve25519_scalar_muladd.hty 508 := s16_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 514 := t514,
              rir_reg% fd_curve25519_scalar_muladd.hty 525 := s14_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 547 := s12_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 564 := s10_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 568 := s7_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 570 := s6_4,
              rir_reg% fd_curve25519_scalar_muladd.hty 578 := s9_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 580 := s8_6,
              rir_reg% fd_curve25519_scalar_muladd.hty 590 := s11_9,
              rir_reg% fd_curve25519_scalar_muladd.hty 593 := carry12_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 596 := t596,
              rir_reg% fd_curve25519_scalar_muladd.hty 481 := t481,
              rir_reg% fd_curve25519_scalar_muladd.hty 484 := t484,
              rir_reg% fd_curve25519_scalar_muladd.hty 591 := t591,
              rir_reg% fd_curve25519_scalar_muladd.hty 592 := t592]) →
          (ht552 : t552 = s18_2 * 470296#64) →
          (hs7_4 : s7_4 = s7_3 + t552) →
          (ht554 : t554 = s18_2 * 654183#64) →
          (hs8_5 : s8_5 = s8_4 + t554) →
          (ht556 : t556 = s18_2 * 18446744073708553811#64) →
          (ht557 : t557 = s18_2 * 136657#64) →
          (ht558 : t558 = t516 + t509) →
          (ht559 : t559 = t558 + s10) →
          (ht560 : t560 = t559 + t529) →
          (ht561 : t561 = t560 + t538) →
          (ht562 : t562 = t561 - t403) →
          (hs10_6 : s10_6 = t562 + carry9) →
          (hs10_7 : s10_7 = s10_6 + t557) →
          (ht565 : t565 = s18_2 * 18446744073708867715#64) →
          (hcarry6_1 : carry6_1 = BitVec.sshiftRight (s6_3 + 1048576#64) 21) →
          (hs7_5 : s7_5 = s7_4 + carry6_1) →
          (hs6_4 : s6_4 = s6_3 - ((BitVec.sshiftRight (s6_3 + 1048576#64) 21) <<< 21)) →
          (hcarry8_1 : carry8_1 = BitVec.sshiftRight (s8_5 + 1048576#64) 21) →
          (ht573 : t573 = s9_1 + t515) →
          (ht574 : t574 = t573 + t528) →
          (ht575 : t575 = t574 + t537) →
          (hs9_5 : s9_5 = t575 - t475) →
          (hs9_6 : s9_6 = s9_5 + t556) →
          (hs9_7 : s9_7 = s9_6 + carry8_1) →
          (hs8_6 : s8_6 = s8_5 - ((BitVec.sshiftRight (s8_5 + 1048576#64) 21) <<< 21)) →
          (hcarry10_1 : carry10_1 = BitVec.sshiftRight (s10_7 + 1048576#64) 21) →
          (ht583 : t583 = t510 + t500) →
          (ht584 : t584 = t583 + t517) →
          (ht585 : t585 = t584 + t530) →
          (ht586 : t586 = t585 + t539) →
          (ht587 : t587 = t586 + t565) →
          (ht588 : t588 = t587 + s11_1) →
          (hs11_8 : s11_8 = t588 - t478) →
          (hs11_9 : s11_9 = s11_8 + carry10_1) →
          (hcarry12_1 : carry12_1 = BitVec.sshiftRight t592 21) →
          (ht594 : t594 = t512 + t502) →
          (ht595 : t595 = t594 + t519) →
          (ht596 : t596 = t595 + t532) →
          (ht591 : t591 = (s10_7 + 1048576#64) &&& 18446744073707454464#64) →
          (ht592 : t592 = s12_7 + 1048576#64) →
          (hbt552 : Bnd t552 (-493141098496) 35999297368432) →
          (hbs7_4 : Bnd s7_4 (-1192167997440) 36698323600732) →
          (hbt554 : Bnd t554 (-685960593408) 50075119393686) →
          (hbs8_5 : Bnd s8_5 (-1878128590848) 98801058856489) →
          (hbt556 : Bnd t556 (-76378023437810) 1046274375680) →
          (hbt557 : Bnd t557 (-143295250432) 10460552461594) →
          (hbt558 : Bnd t558 (-1192166948864) 45929819568834) →
          (hbt559 : Bnd t559 (-1192166948864) 94308287150796) →
          (hbt560 : Bnd t560 (-1878127542272) 141639565479216) →
          (hbt561 : Bnd t561 (-2924400920147) 142685839854896) →
          (hbt562 : Bnd t562 (-51302868502099) 142685839854896) →
          (hbs10_6 : Bnd s10_6 (-51302868502099) 142685860826406) →
          (hbs10_7 : Bnd s10_7 (-51446163752531) 153146413288000) →
          (hbt565 : Bnd t565 (-52349914669842) 717122174976) →
          (hbcarry6_1 : Bnd carry6_1 (-15013372) 39012525) →
          (hbs7_5 : Bnd s7_5 (-1192183010812) 36698362613257) →
          (hbs6_4 : Bnd s6_4 (-1048576) 1048575) →
          (hbcarry8_1 : Bnd carry8_1 (-895561) 47112016) →
          (hbt573 : Bnd t573 (-699025850368) 44679469323237) →
          (hbt574 : Bnd t574 (-1192166948864) 78706203238277) →
          (hbt575 : Bnd t575 (-1878127542272) 79392163177502) →
          (hbs9_5 : Bnd s9_5 (-45858571681792) 79392163177502) →
          (hbs9_6 : Bnd s9_6 (-122236595119602) 80438437553182) →
          (hbs9_7 : Bnd s9_7 (-122236596015163) 80438484665198) →
          (hbs8_6 : Bnd s8_6 (-1048576) 1048575) →
          (hbcarry10_1 : Bnd carry10_1 (-24531443) 73025901) →
          (hbt583 : Bnd t583 (-493141098496) 389955384517488) →
          (hbt584 : Bnd t584 (-1179101691904) 390641344456713) →
          (hbt585 : Bnd t585 (-73372029622604) 391687618832393) →
          (hbt586 : Bnd t586 (-73515324873036) 391830913946168) →
          (hbt587 : Bnd t587 (-125865239542878) 392548036121144) →
          (hbt588 : Bnd t588 (-125865239542878) 577265932964398) →
          (hbs11_8 : Bnd s11_8 (-310583136386142) 577265932964398) →
          (hbs11_9 : Bnd s11_9 (-310583160917585) 577266005990299) →
          (hbcarry12_1 : Bnd carry12_1 (-87219452) 233195457) →
          (hbt594 : Bnd t594 (-68007832423590) 352258077266720) →
          (hbt595 : Bnd t595 (-68151127674022) 352401372380495) →
          (hbt596 : Bnd t596 (-117632555011762) 353118494555471) →
          (hbt591 : Bnd t591 (-51446164750336) 153146414333952) →
          (hbt592 : Bnd t592 (-182912447567574) 489046319959774) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 597 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 552 S >>= g) = K := by
  step_pure with t552
  sbnd t552
  step_pure with s7_4
  sbnd s7_4
  step_pure with t554
  sbnd t554
  step_pure with s8_5
  sbnd s8_5
  step_pure with t556
  sbnd t556
  step_pure with t557
  sbnd t557
  step_pure with t558
  sbnd t558
  step_pure with t559
  sbnd t559
  step_pure with t560
  sbnd t560
  step_pure with t561
  sbnd t561
  step_pure with t562
  sbnd t562
  step_pure with s10_6
  sbnd s10_6
  step_pure with s10_7
  sbnd s10_7
  step_pure with t565
  sbnd t565
  step_pure
  step_pure with carry6_1
  sbnd carry6_1
  step_pure with s7_5
  sbnd s7_5
  step_pure [Bnd.and_neg_shift]
  step_pure with s6_4
  sbnd s6_4
  step_pure
  step_pure with carry8_1
  sbnd carry8_1
  step_pure with t573
  sbnd t573
  step_pure with t574
  sbnd t574
  step_pure with t575
  sbnd t575
  step_pure with s9_5
  sbnd s9_5
  step_pure with s9_6
  sbnd s9_6
  step_pure with s9_7
  sbnd s9_7
  step_pure [Bnd.and_neg_shift]
  step_pure with s8_6
  sbnd s8_6
  step_pure
  step_pure with carry10_1
  sbnd carry10_1
  step_pure with t583
  sbnd t583
  step_pure with t584
  sbnd t584
  step_pure with t585
  sbnd t585
  step_pure with t586
  sbnd t586
  step_pure with t587
  sbnd t587
  step_pure with t588
  sbnd t588
  step_pure with s11_8
  sbnd s11_8
  step_pure with s11_9
  sbnd s11_9
  step_pure with t591
  sbnd t591
  step_pure with t592
  sbnd t592
  step_pure with carry12_1
  sbnd carry12_1
  step_pure with t594
  sbnd t594
  step_pure with t595
  sbnd t595
  step_pure with t596
  sbnd t596
  exact
    hK _ t552 s7_4 t554 s8_5 t556 t557 t558 t559 t560 t561 t562 s10_6 s10_7 t565 carry6_1 s7_5 s6_4
      carry8_1 t573 t574 t575 s9_5 s9_6 s9_7 s8_6 carry10_1 t583 t584 t585 t586 t587 t588 s11_8
      s11_9 carry12_1 t594 t595 t596 t591 t592 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht552 hs7_4 ht554 hs8_5 ht556 ht557 ht558 ht559 ht560 ht561 ht562 hs10_6 hs10_7
      ht565 hcarry6_1 hs7_5 hs6_4 hcarry8_1 ht573 ht574 ht575 hs9_5 hs9_6 hs9_7 hs8_6 hcarry10_1
      ht583 ht584 ht585 ht586 ht587 ht588 hs11_8 hs11_9 hcarry12_1 ht594 ht595 ht596 ht591 ht592
      hbt552 hbs7_4 hbt554 hbs8_5 hbt556 hbt557 hbt558 hbt559 hbt560 hbt561 hbt562 hbs10_6 hbs10_7
      hbt565 hbcarry6_1 hbs7_5 hbs6_4 hbcarry8_1 hbt573 hbt574 hbt575 hbs9_5 hbs9_6 hbs9_7 hbs8_6
      hbcarry10_1 hbt583 hbt584 hbt585 hbt586 hbt587 hbt588 hbs11_8 hbs11_9 hbcarry12_1 hbt594
      hbt595 hbt596 hbt591 hbt592

/-- From `%597`: `s13_6` … `s6_5`. -/
theorem fd_curve25519_scalar_muladd.run597 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_1 s13_1 s15_1 s2_2 s1_2 s4_2 s3_2 s5_2 t481 t484 s17_2 t504 s16_3 t514 s14_5 s12_7 s10_7
      s7_5 s6_4 s9_7 s8_6 s11_9 t591 t592 carry12_1 t596 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 415 := s13_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 426 := s15_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 463 := s3_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 467 := s5_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 489 := s17_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 504 := t504,
        rir_reg% fd_curve25519_scalar_muladd.hty 508 := s16_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 514 := t514,
        rir_reg% fd_curve25519_scalar_muladd.hty 525 := s14_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 547 := s12_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 564 := s10_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 568 := s7_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 570 := s6_4,
        rir_reg% fd_curve25519_scalar_muladd.hty 578 := s9_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 580 := s8_6,
        rir_reg% fd_curve25519_scalar_muladd.hty 590 := s11_9,
        rir_reg% fd_curve25519_scalar_muladd.hty 593 := carry12_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 596 := t596,
        rir_reg% fd_curve25519_scalar_muladd.hty 481 := t481,
        rir_reg% fd_curve25519_scalar_muladd.hty 484 := t484,
        rir_reg% fd_curve25519_scalar_muladd.hty 591 := t591,
        rir_reg% fd_curve25519_scalar_muladd.hty 592 := t592])
    (hbs13_1 : Bnd s13_1 0 175921841569750) (hbs15_1 : Bnd s15_1 0 167125752741848)
    (hbs5_2 : Bnd s5_2 (-1048576) 1048575) (hbt481 : Bnd t481 0 175921841569792)
    (hbt484 : Bnd t484 0 167125752741888) (hbs17_2 : Bnd s17_2 (-1048576) 1048575)
    (hbt504 : Bnd t504 0 73367163848160) (hbs16_3 : Bnd s16_3 (-529894160339040) 162727708327936)
    (hbt514 : Bnd t514 (-46612940005638) 717122174976)
    (hbs14_5 : Bnd s14_5 (-708076578429667) 181555110335582)
    (hbs7_5 : Bnd s7_5 (-1192183010812) 36698362613257) (hbs6_4 : Bnd s6_4 (-1048576) 1048575)
    (hbs9_7 : Bnd s9_7 (-122236596015163) 80438484665198) (hbs8_6 : Bnd s8_6 (-1048576) 1048575)
    (hbs11_9 : Bnd s11_9 (-310583160917585) 577266005990299)
    (hbcarry12_1 : Bnd carry12_1 (-87219452) 233195457)
    (hbt596 : Bnd t596 (-117632555011762) 353118494555471)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t597 s13_6 s13_7 s12_8 carry14_1 t604 t605 s15_4 s15_5 s14_6 carry16_1 s17_3 s16_4 carry7_1
          s8_7 s7_6 carry9_1 carry11_1 s12_9 s11_10 carry13_1 s14_7 s13_8 carry15_1 s16_5 s15_6 t638
          s5_3 t640 s6_5 t622 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 463 := s3_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 564 := s10_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 578 := s9_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 612 := s17_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 617 := s8_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 619 := s7_6,
              rir_reg% fd_curve25519_scalar_muladd.hty 621 := carry9_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 625 := s12_9,
              rir_reg% fd_curve25519_scalar_muladd.hty 627 := s11_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 630 := s14_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 632 := s13_8,
              rir_reg% fd_curve25519_scalar_muladd.hty 635 := s16_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 637 := s15_6,
              rir_reg% fd_curve25519_scalar_muladd.hty 639 := s5_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 641 := s6_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 591 := t591,
              rir_reg% fd_curve25519_scalar_muladd.hty 622 := t622]) →
          (ht597 : t597 = t596 + s13_1) →
          (hs13_6 : s13_6 = t597 - t481) →
          (hs13_7 : s13_7 = s13_6 + carry12_1) →
          (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight t592 21) <<< 21)) →
          (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21) →
          (ht604 : t604 = t514 + t504) →
          (ht605 : t605 = t604 + s15_1) →
          (hs15_4 : s15_4 = t605 - t484) →
          (hs15_5 : s15_5 = s15_4 + carry14_1) →
          (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21)) →
          (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21) →
          (hs17_3 : s17_3 = carry16_1 + s17_2) →
          (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21)) →
          (hcarry7_1 : carry7_1 = BitVec.sshiftRight (s7_5 + 1048576#64) 21) →
          (hs8_7 : s8_7 = s8_6 + carry7_1) →
          (hs7_6 : s7_6 = s7_5 - ((BitVec.sshiftRight (s7_5 + 1048576#64) 21) <<< 21)) →
          (hcarry9_1 : carry9_1 = BitVec.sshiftRight (s9_7 + 1048576#64) 21) →
          (hcarry11_1 : carry11_1 = BitVec.sshiftRight (s11_9 + 1048576#64) 21) →
          (hs12_9 : s12_9 = carry11_1 + s12_8) →
          (hs11_10 : s11_10 = s11_9 - ((BitVec.sshiftRight (s11_9 + 1048576#64) 21) <<< 21)) →
          (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21) →
          (hs14_7 : s14_7 = carry13_1 + s14_6) →
          (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21)) →
          (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21) →
          (hs16_5 : s16_5 = carry15_1 + s16_4) →
          (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21)) →
          (ht638 : t638 = s17_3 * 666643#64) →
          (hs5_3 : s5_3 = s5_2 + t638) →
          (ht640 : t640 = s17_3 * 470296#64) →
          (hs6_5 : s6_5 = s6_4 + t640) →
          (ht622 : t622 = (s9_7 + 1048576#64) &&& 18446744073707454464#64) →
          (hbt597 : Bnd t597 (-117632555011762) 529040336125221) →
          (hbs13_6 : Bnd s13_6 (-293554396581554) 529040336125221) →
          (hbs13_7 : Bnd s13_7 (-293554483801006) 529040569320678) →
          (hbs12_8 : Bnd s12_8 (-9223372036854775808) 9223372036854775807) →
          (hbcarry14_1 : Bnd carry14_1 (-337637223) 86572223) →
          (hbt604 : Bnd t604 (-46612940005638) 74084286023136) →
          (hbt605 : Bnd t605 (-46612940005638) 241210038764984) →
          (hbs15_4 : Bnd s15_4 (-213738692747526) 241210038764984) →
          (hbs15_5 : Bnd s15_5 (-213739030384749) 241210125337207) →
          (hbs14_6 : Bnd s14_6 (-1048576) 1048575) →
          (hbcarry16_1 : Bnd carry16_1 (-252673226) 77594618) →
          (hbs17_3 : Bnd s17_3 (-253721802) 78643193) →
          (hbs16_4 : Bnd s16_4 (-1048576) 1048575) →
          (hbcarry7_1 : Bnd carry7_1 (-568477) 17499143) →
          (hbs8_7 : Bnd s8_7 (-1617053) 18547718) →
          (hbs7_6 : Bnd s7_6 (-1048576) 1048575) →
          (hbcarry9_1 : Bnd carry9_1 (-58286951) 38356058) →
          (hbcarry11_1 : Bnd carry11_1 (-148097592) 275261882) →
          (hbs12_9 : Bnd s12_9 (-9223372036854775808) 9223372036854775807) →
          (hbs11_10 : Bnd s11_10 (-1048576) 1048575) →
          (hbcarry13_1 : Bnd carry13_1 (-139977686) 252266202) →
          (hbs14_7 : Bnd s14_7 (-141026262) 253314777) →
          (hbs13_8 : Bnd s13_8 (-1048576) 1048575) →
          (hbcarry15_1 : Bnd carry15_1 (-101918712) 115017951) →
          (hbs16_5 : Bnd s16_5 (-102967288) 116066526) →
          (hbs15_6 : Bnd s15_6 (-1048576) 1048575) →
          (hbt638 : Bnd t638 (-169141863250686) 52426934111099) →
          (hbs5_3 : Bnd s5_3 (-169141864299262) 52426935159674) →
          (hbt640 : Bnd t640 (-119324348593392) 36985579095128) →
          (hbs6_5 : Bnd s6_5 (-119324349641968) 36985580143703) →
          (hbt622 : Bnd t622 (-122236595863552) 80438483746816) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 642 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 597 S >>= g) = K := by
  step_pure with t597
  sbnd t597
  step_pure with s13_6
  sbnd s13_6
  step_pure with s13_7
  sbnd s13_7
  step_pure [Bnd.and_neg_shift]
  step_pure with s12_8
  sbnd s12_8
  step_pure
  step_pure with carry14_1
  sbnd carry14_1
  step_pure with t604
  sbnd t604
  step_pure with t605
  sbnd t605
  step_pure with s15_4
  sbnd s15_4
  step_pure with s15_5
  sbnd s15_5
  step_pure [Bnd.and_neg_shift]
  step_pure with s14_6
  sbnd s14_6
  step_pure [nswAdd]
  step_pure with carry16_1
  sbnd carry16_1
  step_pure [nswAdd] with s17_3
  sbnd s17_3
  step_pure [Bnd.and_neg_shift]
  step_pure with s16_4
  sbnd s16_4
  step_pure
  step_pure with carry7_1
  sbnd carry7_1
  step_pure with s8_7
  sbnd s8_7
  step_pure [Bnd.and_neg_shift]
  step_pure with s7_6
  sbnd s7_6
  step_pure
  step_pure with carry9_1
  sbnd carry9_1
  step_pure with t622
  sbnd t622
  step_pure
  step_pure with carry11_1
  sbnd carry11_1
  step_pure with s12_9
  sbnd s12_9
  step_pure [Bnd.and_neg_shift]
  step_pure with s11_10
  sbnd s11_10
  step_pure
  step_pure with carry13_1
  sbnd carry13_1
  step_pure with s14_7
  sbnd s14_7
  step_pure [Bnd.and_neg_shift]
  step_pure with s13_8
  sbnd s13_8
  step_pure
  step_pure with carry15_1
  sbnd carry15_1
  step_pure with s16_5
  sbnd s16_5
  step_pure [Bnd.and_neg_shift]
  step_pure with s15_6
  sbnd s15_6
  step_pure with t638
  sbnd t638
  step_pure with s5_3
  sbnd s5_3
  step_pure with t640
  sbnd t640
  step_pure with s6_5
  sbnd s6_5
  exact
    hK _ t597 s13_6 s13_7 s12_8 carry14_1 t604 t605 s15_4 s15_5 s14_6 carry16_1 s17_3 s16_4 carry7_1
      s8_7 s7_6 carry9_1 carry11_1 s12_9 s11_10 carry13_1 s14_7 s13_8 carry15_1 s16_5 s15_6 t638
      s5_3 t640 s6_5 t622 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht597 hs13_6 hs13_7 hs12_8 hcarry14_1 ht604 ht605 hs15_4 hs15_5 hs14_6
      hcarry16_1 hs17_3 hs16_4 hcarry7_1 hs8_7 hs7_6 hcarry9_1 hcarry11_1 hs12_9 hs11_10 hcarry13_1
      hs14_7 hs13_8 hcarry15_1 hs16_5 hs15_6 ht638 hs5_3 ht640 hs6_5 ht622 hbt597 hbs13_6 hbs13_7
      hbs12_8 hbcarry14_1 hbt604 hbt605 hbs15_4 hbs15_5 hbs14_6 hbcarry16_1 hbs17_3 hbs16_4
      hbcarry7_1 hbs8_7 hbs7_6 hbcarry9_1 hbcarry11_1 hbs12_9 hbs11_10 hbcarry13_1 hbs14_7 hbs13_8
      hbcarry15_1 hbs16_5 hbs15_6 hbt638 hbs5_3 hbt640 hbs6_5 hbt622

/-- From `%642`: `s7_7` … `s7_10`. -/
theorem fd_curve25519_scalar_muladd.run642 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_1 s2_2 s1_2 s4_2 s3_2 s10_7 s9_7 t591 s17_3 s8_7 s7_6 carry9_1 t622 s12_9 s11_10 s14_7 s13_8
      s16_5 s15_6 s5_3 s6_5 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 461 := s4_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 463 := s3_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 564 := s10_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 578 := s9_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 612 := s17_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 617 := s8_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 619 := s7_6,
        rir_reg% fd_curve25519_scalar_muladd.hty 621 := carry9_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 625 := s12_9,
        rir_reg% fd_curve25519_scalar_muladd.hty 627 := s11_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 630 := s14_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 632 := s13_8,
        rir_reg% fd_curve25519_scalar_muladd.hty 635 := s16_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 637 := s15_6,
        rir_reg% fd_curve25519_scalar_muladd.hty 639 := s5_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 641 := s6_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 591 := t591,
        rir_reg% fd_curve25519_scalar_muladd.hty 622 := t622])
    (hbs4_2 : Bnd s4_2 (-1048576) 9437179) (hbs10_7 : Bnd s10_7 (-51446163752531) 153146413288000)
    (hbt591 : Bnd t591 (-51446164750336) 153146414333952)
    (hbs17_3 : Bnd s17_3 (-253721802) 78643193) (hbs8_7 : Bnd s8_7 (-1617053) 18547718)
    (hbs7_6 : Bnd s7_6 (-1048576) 1048575) (hbcarry9_1 : Bnd carry9_1 (-58286951) 38356058)
    (hbs14_7 : Bnd s14_7 (-141026262) 253314777) (hbs13_8 : Bnd s13_8 (-1048576) 1048575)
    (hbs16_5 : Bnd s16_5 (-102967288) 116066526) (hbs15_6 : Bnd s15_6 (-1048576) 1048575)
    (hbs5_3 : Bnd s5_3 (-169141864299262) 52426935159674)
    (hbs6_5 : Bnd s6_5 (-119324349641968) 36985580143703)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t642 s7_7 t644 s8_8 t646 t647 t648 t649 s10_10 t651 s4_3 t653 s5_4 t655 s6_6 t657 s7_8 t659
          s8_9 t661 t662 s3_3 t664 s4_4 t666 s5_5 t668 s6_7 t670 s7_9 t672 s8_10 t674 t675 t676 t677
          t678 s6_8 t680 s7_10 t682 t683 t684 t685 t686 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 578 := s9_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 625 := s12_9,
              rir_reg% fd_curve25519_scalar_muladd.hty 627 := s11_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 632 := s13_8,
              rir_reg% fd_curve25519_scalar_muladd.hty 646 := t646,
              rir_reg% fd_curve25519_scalar_muladd.hty 650 := s10_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 661 := t661,
              rir_reg% fd_curve25519_scalar_muladd.hty 663 := s3_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 665 := s4_4,
              rir_reg% fd_curve25519_scalar_muladd.hty 667 := s5_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 673 := s8_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 674 := t674,
              rir_reg% fd_curve25519_scalar_muladd.hty 675 := t675,
              rir_reg% fd_curve25519_scalar_muladd.hty 676 := t676,
              rir_reg% fd_curve25519_scalar_muladd.hty 677 := t677,
              rir_reg% fd_curve25519_scalar_muladd.hty 679 := s6_8,
              rir_reg% fd_curve25519_scalar_muladd.hty 681 := s7_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 682 := t682,
              rir_reg% fd_curve25519_scalar_muladd.hty 683 := t683,
              rir_reg% fd_curve25519_scalar_muladd.hty 684 := t684,
              rir_reg% fd_curve25519_scalar_muladd.hty 685 := t685,
              rir_reg% fd_curve25519_scalar_muladd.hty 686 := t686,
              rir_reg% fd_curve25519_scalar_muladd.hty 622 := t622]) →
          (ht642 : t642 = s17_3 * 654183#64) →
          (hs7_7 : s7_7 = s7_6 + t642) →
          (ht644 : t644 = s17_3 * 18446744073708553811#64) →
          (hs8_8 : s8_8 = s8_7 + t644) →
          (ht646 : t646 = s17_3 * 136657#64) →
          (ht647 : t647 = s17_3 * 18446744073708867715#64) →
          (ht648 : t648 = s10_7 + t647) →
          (ht649 : t649 = t648 + carry9_1) →
          (hs10_10 : s10_10 = t649 - t591) →
          (ht651 : t651 = s16_5 * 666643#64) →
          (hs4_3 : s4_3 = s4_2 + t651) →
          (ht653 : t653 = s16_5 * 470296#64) →
          (hs5_4 : s5_4 = s5_3 + t653) →
          (ht655 : t655 = s16_5 * 654183#64) →
          (hs6_6 : s6_6 = s6_5 + t655) →
          (ht657 : t657 = s16_5 * 18446744073708553811#64) →
          (hs7_8 : s7_8 = s7_7 + t657) →
          (ht659 : t659 = s16_5 * 136657#64) →
          (hs8_9 : s8_9 = s8_8 + t659) →
          (ht661 : t661 = s16_5 * 18446744073708867715#64) →
          (ht662 : t662 = s15_6 * 666643#64) →
          (hs3_3 : s3_3 = s3_2 + t662) →
          (ht664 : t664 = s15_6 * 470296#64) →
          (hs4_4 : s4_4 = s4_3 + t664) →
          (ht666 : t666 = s15_6 * 654183#64) →
          (hs5_5 : s5_5 = s5_4 + t666) →
          (ht668 : t668 = s15_6 * 18446744073708553811#64) →
          (hs6_7 : s6_7 = s6_6 + t668) →
          (ht670 : t670 = s15_6 * 136657#64) →
          (hs7_9 : s7_9 = s7_8 + t670) →
          (ht672 : t672 = s15_6 * 18446744073708867715#64) →
          (hs8_10 : s8_10 = s8_9 + t672) →
          (ht674 : t674 = s14_7 * 666643#64) →
          (ht675 : t675 = s14_7 * 470296#64) →
          (ht676 : t676 = s14_7 * 654183#64) →
          (ht677 : t677 = s14_7 * 18446744073708553811#64) →
          (ht678 : t678 = s14_7 * 136657#64) →
          (hs6_8 : s6_8 = s6_7 + t678) →
          (ht680 : t680 = s14_7 * 18446744073708867715#64) →
          (hs7_10 : s7_10 = s7_9 + t680) →
          (ht682 : t682 = s13_8 * 666643#64) →
          (ht683 : t683 = s13_8 * 470296#64) →
          (ht684 : t684 = s13_8 * 654183#64) →
          (ht685 : t685 = s13_8 * 18446744073708553811#64) →
          (ht686 : t686 = s13_8 * 136657#64) →
          (hbt642 : Bnd t642 (-165980489597766) 51447039926319) →
          (hbs7_7 : Bnd s7_7 (-165980490646342) 51447040974894) →
          (hbt644 : Bnd t644 (-78470571191365) 253164882644610) →
          (hbs8_8 : Bnd s8_8 (-78470572808418) 253164901192328) →
          (hbt646 : Bnd t646 (-34672860295914) 10747142825801) →
          (hbt647 : Bnd t647 (-53784158335893) 173520594109602) →
          (hbt648 : Bnd t648 (-105230322088424) 326667007397602) →
          (hbt649 : Bnd t649 (-105230380375375) 326667045753660) →
          (hbs10_10 : Bnd s10_10 (-258376794709327) 378113210503996) →
          (hbt651 : Bnd t651 (-68642421774184) 77374937092218) →
          (hbs4_3 : Bnd s4_3 (-68642422822760) 77374946529397) →
          (hbt653 : Bnd t653 (-48425103677248) 54585622911696) →
          (hbs5_4 : Bnd s5_4 (-217566967976510) 107012558071370) →
          (hbt655 : Bnd t655 (-67359449365704) 75928748178258) →
          (hbs6_6 : Bnd s6_6 (-186683799007672) 112914328321961) →
          (hbt657 : Bnd t657 (-115811759975430) 102741274802840) →
          (hbs7_8 : Bnd s7_8 (-281792250621772) 154188315777734) →
          (hbt659 : Bnd t659 (-14071200676216) 15861303243582) →
          (hbs8_9 : Bnd s8_9 (-92541773484634) 269026204435910) →
          (hbt661 : Bnd t661 (-79378013197926) 70419431230488) →
          (hbt662 : Bnd t662 (-699025850368) 699025183725) →
          (hbs3_3 : Bnd s3_3 (-9223372036854775808) 9223372036854775807) →
          (hbt664 : Bnd t664 (-493141098496) 493140628200) →
          (hbs4_4 : Bnd s4_4 (-69135563921256) 77868087157597) →
          (hbt666 : Bnd t666 (-685960593408) 685959939225) →
          (hbs5_5 : Bnd s5_5 (-218252928569918) 107698518010595) →
          (hbt668 : Bnd t668 (-1046273377875) 1046274375680) →
          (hbs6_7 : Bnd s6_7 (-187730072385547) 113960602697641) →
          (hbt670 : Bnd t670 (-143295250432) 143295113775) →
          (hbs7_9 : Bnd s7_9 (-281935545872204) 154331610891509) →
          (hbt672 : Bnd t672 (-717121491075) 717122174976) →
          (hbs8_10 : Bnd s8_10 (-93258894975709) 269743326610886) →
          (hbt674 : Bnd t674 (-94014170378466) 168870522883611) →
          (hbt675 : Bnd t675 (-66324086913552) 119132926363992) →
          (hbt676 : Bnd t676 (-92256983153946) 165714220762191) →
          (hbt677 : Bnd t677 (-252758751064485) 140716709354910) →
          (hbt678 : Bnd t678 (-19272225886134) 34617237480489) →
          (hbs6_8 : Bnd s6_8 (-207002298271681) 148577840178130) →
          (hbt680 : Bnd t680 (-173242229305077) 96448001608062) →
          (hbs7_10 : Bnd s7_10 (-455177775177281) 250779612499571) →
          (hbt682 : Bnd t682 (-699025850368) 699025183725) →
          (hbt683 : Bnd t683 (-493141098496) 493140628200) →
          (hbt684 : Bnd t684 (-685960593408) 685959939225) →
          (hbt685 : Bnd t685 (-1046273377875) 1046274375680) →
          (hbt686 : Bnd t686 (-143295250432) 143295113775) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 687 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 642 S >>= g) = K := by
  step_pure with t642
  sbnd t642
  step_pure with s7_7
  sbnd s7_7
  step_pure with t644
  sbnd t644
  step_pure with s8_8
  sbnd s8_8
  step_pure with t646
  sbnd t646
  step_pure with t647
  sbnd t647
  step_pure with t648
  sbnd t648
  step_pure with t649
  sbnd t649
  step_pure with s10_10
  sbnd s10_10
  step_pure with t651
  sbnd t651
  step_pure with s4_3
  sbnd s4_3
  step_pure with t653
  sbnd t653
  step_pure with s5_4
  sbnd s5_4
  step_pure with t655
  sbnd t655
  step_pure with s6_6
  sbnd s6_6
  step_pure with t657
  sbnd t657
  step_pure with s7_8
  sbnd s7_8
  step_pure with t659
  sbnd t659
  step_pure with s8_9
  sbnd s8_9
  step_pure with t661
  sbnd t661
  step_pure with t662
  sbnd t662
  step_pure with s3_3
  sbnd s3_3
  step_pure with t664
  sbnd t664
  step_pure with s4_4
  sbnd s4_4
  step_pure with t666
  sbnd t666
  step_pure with s5_5
  sbnd s5_5
  step_pure with t668
  sbnd t668
  step_pure with s6_7
  sbnd s6_7
  step_pure with t670
  sbnd t670
  step_pure with s7_9
  sbnd s7_9
  step_pure with t672
  sbnd t672
  step_pure with s8_10
  sbnd s8_10
  step_pure with t674
  sbnd t674
  step_pure with t675
  sbnd t675
  step_pure with t676
  sbnd t676
  step_pure with t677
  sbnd t677
  step_pure with t678
  sbnd t678
  step_pure with s6_8
  sbnd s6_8
  step_pure with t680
  sbnd t680
  step_pure with s7_10
  sbnd s7_10
  step_pure with t682
  sbnd t682
  step_pure with t683
  sbnd t683
  step_pure with t684
  sbnd t684
  step_pure with t685
  sbnd t685
  step_pure with t686
  sbnd t686
  exact
    hK _ t642 s7_7 t644 s8_8 t646 t647 t648 t649 s10_10 t651 s4_3 t653 s5_4 t655 s6_6 t657 s7_8 t659
      s8_9 t661 t662 s3_3 t664 s4_4 t666 s5_5 t668 s6_7 t670 s7_9 t672 s8_10 t674 t675 t676 t677
      t678 s6_8 t680 s7_10 t682 t683 t684 t685 t686 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht642 hs7_7 ht644 hs8_8 ht646 ht647 ht648 ht649 hs10_10 ht651 hs4_3 ht653 hs5_4
      ht655 hs6_6 ht657 hs7_8 ht659 hs8_9 ht661 ht662 hs3_3 ht664 hs4_4 ht666 hs5_5 ht668 hs6_7
      ht670 hs7_9 ht672 hs8_10 ht674 ht675 ht676 ht677 ht678 hs6_8 ht680 hs7_10 ht682 ht683 ht684
      ht685 ht686 hbt642 hbs7_7 hbt644 hbs8_8 hbt646 hbt647 hbt648 hbt649 hbs10_10 hbt651 hbs4_3
      hbt653 hbs5_4 hbt655 hbs6_6 hbt657 hbs7_8 hbt659 hbs8_9 hbt661 hbt662 hbs3_3 hbt664 hbs4_4
      hbt666 hbs5_5 hbt668 hbs6_7 hbt670 hbs7_9 hbt672 hbs8_10 hbt674 hbt675 hbt676 hbt677 hbt678
      hbs6_8 hbt680 hbs7_10 hbt682 hbt683 hbt684 hbt685 hbt686

/-- From `%687`: `s6_9` … `s9_9`. -/
theorem fd_curve25519_scalar_muladd.run687 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_1 s2_2 s1_2 s9_7 t622 s12_9 s11_10 s13_8 t646 s10_10 t661 s3_3 s4_4 s5_5 s8_10 t674 t675
      t676 t677 s6_8 s7_10 t682 t683 t684 t685 t686 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 340 := s0_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 456 := s2_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 458 := s1_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 578 := s9_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 625 := s12_9,
        rir_reg% fd_curve25519_scalar_muladd.hty 627 := s11_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 632 := s13_8,
        rir_reg% fd_curve25519_scalar_muladd.hty 646 := t646,
        rir_reg% fd_curve25519_scalar_muladd.hty 650 := s10_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 661 := t661,
        rir_reg% fd_curve25519_scalar_muladd.hty 663 := s3_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 665 := s4_4,
        rir_reg% fd_curve25519_scalar_muladd.hty 667 := s5_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 673 := s8_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 674 := t674,
        rir_reg% fd_curve25519_scalar_muladd.hty 675 := t675,
        rir_reg% fd_curve25519_scalar_muladd.hty 676 := t676,
        rir_reg% fd_curve25519_scalar_muladd.hty 677 := t677,
        rir_reg% fd_curve25519_scalar_muladd.hty 679 := s6_8,
        rir_reg% fd_curve25519_scalar_muladd.hty 681 := s7_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 682 := t682,
        rir_reg% fd_curve25519_scalar_muladd.hty 683 := t683,
        rir_reg% fd_curve25519_scalar_muladd.hty 684 := t684,
        rir_reg% fd_curve25519_scalar_muladd.hty 685 := t685,
        rir_reg% fd_curve25519_scalar_muladd.hty 686 := t686,
        rir_reg% fd_curve25519_scalar_muladd.hty 622 := t622])
    (hbs9_7 : Bnd s9_7 (-122236596015163) 80438484665198)
    (hbt622 : Bnd t622 (-122236595863552) 80438483746816) (hbs13_8 : Bnd s13_8 (-1048576) 1048575)
    (hbt646 : Bnd t646 (-34672860295914) 10747142825801)
    (hbs8_10 : Bnd s8_10 (-93258894975709) 269743326610886)
    (hbs6_8 : Bnd s6_8 (-207002298271681) 148577840178130)
    (hbs7_10 : Bnd s7_10 (-455177775177281) 250779612499571)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (t687 s6_9 t689 s0_2 t691 t692 t693 t694 s2_5 t696 t697 t698 t699 s4_7 t701 carry0_1 t704
          s1_4 s1_5 s0_3 carry2_1 t711 t712 s3_6 s3_7 carry4_1 t718 t719 s5_8 s5_9 carry6_2 s7_11
          s6_10 carry8_2 t730 s9_9 t715 t722 t728 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 627 := s11_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 650 := s10_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 661 := t661,
              rir_reg% fd_curve25519_scalar_muladd.hty 673 := s8_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 695 := s2_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 700 := s4_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 706 := s1_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 708 := s0_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 714 := s3_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 721 := s5_9,
              rir_reg% fd_curve25519_scalar_muladd.hty 725 := s7_11,
              rir_reg% fd_curve25519_scalar_muladd.hty 727 := s6_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 729 := carry8_2,
              rir_reg% fd_curve25519_scalar_muladd.hty 731 := s9_9,
              rir_reg% fd_curve25519_scalar_muladd.hty 715 := t715,
              rir_reg% fd_curve25519_scalar_muladd.hty 722 := t722,
              rir_reg% fd_curve25519_scalar_muladd.hty 728 := t728]) →
          (ht687 : t687 = s13_8 * 18446744073708867715#64) →
          (hs6_9 : s6_9 = s6_8 + t687) →
          (ht689 : t689 = s12_9 * 666643#64) →
          (hs0_2 : s0_2 = t689 + s0_1) →
          (ht691 : t691 = s12_9 * 470296#64) →
          (ht692 : t692 = s12_9 * 654183#64) →
          (ht693 : t693 = s2_2 + t692) →
          (ht694 : t694 = t693 + t674) →
          (hs2_5 : s2_5 = t694 + t683) →
          (ht696 : t696 = s12_9 * 18446744073708553811#64) →
          (ht697 : t697 = s12_9 * 136657#64) →
          (ht698 : t698 = s4_4 + t697) →
          (ht699 : t699 = t698 + t676) →
          (hs4_7 : s4_7 = t699 + t685) →
          (ht701 : t701 = s12_9 * 18446744073708867715#64) →
          (hcarry0_1 : carry0_1 = BitVec.sshiftRight (s0_2 + 1048576#64) 21) →
          (ht704 : t704 = s1_2 + t691) →
          (hs1_4 : s1_4 = t704 + t682) →
          (hs1_5 : s1_5 = s1_4 + carry0_1) →
          (hs0_3 : s0_3 = s0_2 - ((BitVec.sshiftRight (s0_2 + 1048576#64) 21) <<< 21)) →
          (hcarry2_1 : carry2_1 = BitVec.sshiftRight (s2_5 + 1048576#64) 21) →
          (ht711 : t711 = s3_3 + t696) →
          (ht712 : t712 = t711 + t675) →
          (hs3_6 : s3_6 = t712 + t684) →
          (hs3_7 : s3_7 = s3_6 + carry2_1) →
          (hcarry4_1 : carry4_1 = BitVec.sshiftRight (s4_7 + 1048576#64) 21) →
          (ht718 : t718 = s5_5 + t701) →
          (ht719 : t719 = t718 + t677) →
          (hs5_8 : s5_8 = t719 + t686) →
          (hs5_9 : s5_9 = s5_8 + carry4_1) →
          (hcarry6_2 : carry6_2 = BitVec.sshiftRight (s6_9 + 1048576#64) 21) →
          (hs7_11 : s7_11 = s7_10 + carry6_2) →
          (hs6_10 : s6_10 = s6_9 - ((BitVec.sshiftRight (s6_9 + 1048576#64) 21) <<< 21)) →
          (hcarry8_2 : carry8_2 = BitVec.sshiftRight t728 21) →
          (ht730 : t730 = t646 + s9_7) →
          (hs9_9 : s9_9 = t730 - t622) →
          (ht715 : t715 = (s2_5 + 1048576#64) &&& 18446744073707454464#64) →
          (ht722 : t722 = (s4_7 + 1048576#64) &&& 18446744073707454464#64) →
          (ht728 : t728 = s8_10 + 1048576#64) →
          (hbt687 : Bnd t687 (-717121491075) 717122174976) →
          (hbs6_9 : Bnd s6_9 (-207719419762756) 149294962353106) →
          (hbt689 : Bnd t689 (-9223372036854775808) 9223372036854775807) →
          (hbs0_2 : Bnd s0_2 (-9223372036854775808) 9223372036854775807) →
          (hbt691 : Bnd t691 (-9223372036854775808) 9223372036854775807) →
          (hbt692 : Bnd t692 (-9223372036854775808) 9223372036854775807) →
          (hbt693 : Bnd t693 (-9223372036854775808) 9223372036854775807) →
          (hbt694 : Bnd t694 (-9223372036854775808) 9223372036854775807) →
          (hbs2_5 : Bnd s2_5 (-9223372036854775808) 9223372036854775807) →
          (hbt696 : Bnd t696 (-9223372036854775808) 9223372036854775807) →
          (hbt697 : Bnd t697 (-9223372036854775808) 9223372036854775807) →
          (hbt698 : Bnd t698 (-9223372036854775808) 9223372036854775807) →
          (hbt699 : Bnd t699 (-9223372036854775808) 9223372036854775807) →
          (hbs4_7 : Bnd s4_7 (-9223372036854775808) 9223372036854775807) →
          (hbt701 : Bnd t701 (-9223372036854775808) 9223372036854775807) →
          (hbcarry0_1 : Bnd carry0_1 (-4398046511104) 4398046511103) →
          (hbt704 : Bnd t704 (-9223372036854775808) 9223372036854775807) →
          (hbs1_4 : Bnd s1_4 (-9223372036854775808) 9223372036854775807) →
          (hbs1_5 : Bnd s1_5 (-9223372036854775808) 9223372036854775807) →
          (hbs0_3 : Bnd s0_3 (-1048576) 1048575) →
          (hbcarry2_1 : Bnd carry2_1 (-4398046511104) 4398046511103) →
          (hbt711 : Bnd t711 (-9223372036854775808) 9223372036854775807) →
          (hbt712 : Bnd t712 (-9223372036854775808) 9223372036854775807) →
          (hbs3_6 : Bnd s3_6 (-9223372036854775808) 9223372036854775807) →
          (hbs3_7 : Bnd s3_7 (-9223372036854775808) 9223372036854775807) →
          (hbcarry4_1 : Bnd carry4_1 (-4398046511104) 4398046511103) →
          (hbt718 : Bnd t718 (-9223372036854775808) 9223372036854775807) →
          (hbt719 : Bnd t719 (-9223372036854775808) 9223372036854775807) →
          (hbs5_8 : Bnd s5_8 (-9223372036854775808) 9223372036854775807) →
          (hbs5_9 : Bnd s5_9 (-9223372036854775808) 9223372036854775807) →
          (hbcarry6_2 : Bnd carry6_2 (-99048338) 71189386) →
          (hbs7_11 : Bnd s7_11 (-455177874225619) 250779683688957) →
          (hbs6_10 : Bnd s6_10 (-1048576) 1048575) →
          (hbcarry8_2 : Bnd carry8_2 (-44469306) 128623641) →
          (hbt730 : Bnd t730 (-156909456311077) 91185627490999) →
          (hbs9_9 : Bnd s9_9 (-237347940057893) 213422223354551) →
          (hbt715 : Bnd t715 (-9223372036854775808) 9223372036852678656) →
          (hbt722 : Bnd t722 (-9223372036854775808) 9223372036852678656) →
          (hbt728 : Bnd t728 (-93258893927133) 269743327659462) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 732 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 687 S >>= g) = K := by
  step_pure with t687
  sbnd t687
  step_pure with s6_9
  sbnd s6_9
  step_pure with t689
  sbnd t689
  step_pure with s0_2
  sbnd s0_2
  step_pure with t691
  sbnd t691
  step_pure with t692
  sbnd t692
  step_pure with t693
  sbnd t693
  step_pure with t694
  sbnd t694
  step_pure with s2_5
  sbnd s2_5
  step_pure with t696
  sbnd t696
  step_pure with t697
  sbnd t697
  step_pure with t698
  sbnd t698
  step_pure with t699
  sbnd t699
  step_pure with s4_7
  sbnd s4_7
  step_pure with t701
  sbnd t701
  step_pure
  step_pure with carry0_1
  sbnd carry0_1
  step_pure with t704
  sbnd t704
  step_pure with s1_4
  sbnd s1_4
  step_pure with s1_5
  sbnd s1_5
  step_pure [Bnd.and_neg_shift]
  step_pure with s0_3
  sbnd s0_3
  step_pure
  step_pure with carry2_1
  sbnd carry2_1
  step_pure with t711
  sbnd t711
  step_pure with t712
  sbnd t712
  step_pure with s3_6
  sbnd s3_6
  step_pure with s3_7
  sbnd s3_7
  step_pure with t715
  sbnd t715
  step_pure
  step_pure with carry4_1
  sbnd carry4_1
  step_pure with t718
  sbnd t718
  step_pure with t719
  sbnd t719
  step_pure with s5_8
  sbnd s5_8
  step_pure with s5_9
  sbnd s5_9
  step_pure with t722
  sbnd t722
  step_pure
  step_pure with carry6_2
  sbnd carry6_2
  step_pure with s7_11
  sbnd s7_11
  step_pure [Bnd.and_neg_shift]
  step_pure with s6_10
  sbnd s6_10
  step_pure with t728
  sbnd t728
  step_pure with carry8_2
  sbnd carry8_2
  step_pure with t730
  sbnd t730
  step_pure with s9_9
  sbnd s9_9
  exact
    hK _ t687 s6_9 t689 s0_2 t691 t692 t693 t694 s2_5 t696 t697 t698 t699 s4_7 t701 carry0_1 t704
      s1_4 s1_5 s0_3 carry2_1 t711 t712 s3_6 s3_7 carry4_1 t718 t719 s5_8 s5_9 carry6_2 s7_11 s6_10
      carry8_2 t730 s9_9 t715 t722 t728 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) ht687 hs6_9 ht689 hs0_2 ht691 ht692 ht693 ht694 hs2_5 ht696 ht697 ht698 ht699
      hs4_7 ht701 hcarry0_1 ht704 hs1_4 hs1_5 hs0_3 hcarry2_1 ht711 ht712 hs3_6 hs3_7 hcarry4_1
      ht718 ht719 hs5_8 hs5_9 hcarry6_2 hs7_11 hs6_10 hcarry8_2 ht730 hs9_9 ht715 ht722 ht728 hbt687
      hbs6_9 hbt689 hbs0_2 hbt691 hbt692 hbt693 hbt694 hbs2_5 hbt696 hbt697 hbt698 hbt699 hbs4_7
      hbt701 hbcarry0_1 hbt704 hbs1_4 hbs1_5 hbs0_3 hbcarry2_1 hbt711 hbt712 hbs3_6 hbs3_7
      hbcarry4_1 hbt718 hbt719 hbs5_8 hbs5_9 hbcarry6_2 hbs7_11 hbs6_10 hbcarry8_2 hbt730 hbs9_9
      hbt715 hbt722 hbt728

/-- From `%732`: `s9_10` … `s0_5`. -/
theorem fd_curve25519_scalar_muladd.run732 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s11_10 s10_10 t661 s8_10 s2_5 s4_7 s1_5 s0_3 s3_7 t715 s5_9 t722 s7_11 s6_10 t728 carry8_2
      s9_9 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 627 := s11_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 650 := s10_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 661 := t661,
        rir_reg% fd_curve25519_scalar_muladd.hty 673 := s8_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 695 := s2_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 700 := s4_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 706 := s1_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 708 := s0_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 714 := s3_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 721 := s5_9,
        rir_reg% fd_curve25519_scalar_muladd.hty 725 := s7_11,
        rir_reg% fd_curve25519_scalar_muladd.hty 727 := s6_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 729 := carry8_2,
        rir_reg% fd_curve25519_scalar_muladd.hty 731 := s9_9,
        rir_reg% fd_curve25519_scalar_muladd.hty 715 := t715,
        rir_reg% fd_curve25519_scalar_muladd.hty 722 := t722,
        rir_reg% fd_curve25519_scalar_muladd.hty 728 := t728])
    (hbs11_10 : Bnd s11_10 (-1048576) 1048575)
    (hbs10_10 : Bnd s10_10 (-258376794709327) 378113210503996)
    (hbt661 : Bnd t661 (-79378013197926) 70419431230488) (hbs0_3 : Bnd s0_3 (-1048576) 1048575)
    (hbs7_11 : Bnd s7_11 (-455177874225619) 250779683688957)
    (hbs6_10 : Bnd s6_10 (-1048576) 1048575) (hbcarry8_2 : Bnd carry8_2 (-44469306) 128623641)
    (hbs9_9 : Bnd s9_9 (-237347940057893) 213422223354551)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (s9_10 s9_11 s8_11 carry10_2 s11_11 s10_11 carry1_1 carry3_1 carry5_1 s6_11 carry7_2 s8_12
          s7_12 carry9_2 s10_12 s9_12 carry11_2 s11_12 t765 s0_4 t767 t768 t769 t770 t771 carry0_2
          t773 s1_7 s1_8 s0_5 t746 t750 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 695 := s2_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 700 := s4_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 714 := s3_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 721 := s5_9,
              rir_reg% fd_curve25519_scalar_muladd.hty 742 := carry1_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 745 := carry3_1,
              rir_reg% fd_curve25519_scalar_muladd.hty 749 := s6_11,
              rir_reg% fd_curve25519_scalar_muladd.hty 753 := s8_12,
              rir_reg% fd_curve25519_scalar_muladd.hty 755 := s7_12,
              rir_reg% fd_curve25519_scalar_muladd.hty 758 := s10_12,
              rir_reg% fd_curve25519_scalar_muladd.hty 760 := s9_12,
              rir_reg% fd_curve25519_scalar_muladd.hty 764 := s11_12,
              rir_reg% fd_curve25519_scalar_muladd.hty 768 := t768,
              rir_reg% fd_curve25519_scalar_muladd.hty 769 := t769,
              rir_reg% fd_curve25519_scalar_muladd.hty 770 := t770,
              rir_reg% fd_curve25519_scalar_muladd.hty 771 := t771,
              rir_reg% fd_curve25519_scalar_muladd.hty 775 := s1_8,
              rir_reg% fd_curve25519_scalar_muladd.hty 776 := s0_5,
              rir_reg% fd_curve25519_scalar_muladd.hty 715 := t715,
              rir_reg% fd_curve25519_scalar_muladd.hty 722 := t722,
              rir_reg% fd_curve25519_scalar_muladd.hty 746 := t746,
              rir_reg% fd_curve25519_scalar_muladd.hty 750 := t750]) →
          (hs9_10 : s9_10 = s9_9 + t661) →
          (hs9_11 : s9_11 = s9_10 + carry8_2) →
          (hs8_11 : s8_11 = s8_10 - ((BitVec.sshiftRight t728 21) <<< 21)) →
          (hcarry10_2 : carry10_2 = BitVec.sshiftRight (s10_10 + 1048576#64) 21) →
          (hs11_11 : s11_11 = s11_10 + carry10_2) →
          (hs10_11 : s10_11 = s10_10 - ((BitVec.sshiftRight (s10_10 + 1048576#64) 21) <<< 21)) →
          (hcarry1_1 : carry1_1 = BitVec.sshiftRight (s1_5 + 1048576#64) 21) →
          (hcarry3_1 : carry3_1 = BitVec.sshiftRight (s3_7 + 1048576#64) 21) →
          (hcarry5_1 : carry5_1 = BitVec.sshiftRight (s5_9 + 1048576#64) 21) →
          (hs6_11 : s6_11 = s6_10 + carry5_1) →
          (hcarry7_2 : carry7_2 = BitVec.sshiftRight (s7_11 + 1048576#64) 21) →
          (hs8_12 : s8_12 = s8_11 + carry7_2) →
          (hs7_12 : s7_12 = s7_11 - ((BitVec.sshiftRight (s7_11 + 1048576#64) 21) <<< 21)) →
          (hcarry9_2 : carry9_2 = BitVec.sshiftRight (s9_11 + 1048576#64) 21) →
          (hs10_12 : s10_12 = s10_11 + carry9_2) →
          (hs9_12 : s9_12 = s9_11 - ((BitVec.sshiftRight (s9_11 + 1048576#64) 21) <<< 21)) →
          (hcarry11_2 : carry11_2 = BitVec.sshiftRight (s11_11 + 1048576#64) 21) →
          (hs11_12 : s11_12 = s11_11 - ((BitVec.sshiftRight (s11_11 + 1048576#64) 21) <<< 21)) →
          (ht765 : t765 = carry11_2 * 666643#64) →
          (hs0_4 : s0_4 = s0_3 + t765) →
          (ht767 : t767 = carry11_2 * 470296#64) →
          (ht768 : t768 = carry11_2 * 654183#64) →
          (ht769 : t769 = carry11_2 * 18446744073708553811#64) →
          (ht770 : t770 = carry11_2 * 136657#64) →
          (ht771 : t771 = carry11_2 * 18446744073708867715#64) →
          (hcarry0_2 : carry0_2 = BitVec.sshiftRight s0_4 21) →
          (ht773 : t773 = s1_5 + t767) →
          (hs1_7 : s1_7 = t773 - ((BitVec.sshiftRight (s1_5 + 1048576#64) 21) <<< 21)) →
          (hs1_8 : s1_8 = s1_7 + carry0_2) →
          (hs0_5 : s0_5 = s0_4 &&& 2097151#64) →
          (ht746 : t746 = (s3_7 + 1048576#64) &&& 18446744073707454464#64) →
          (ht750 : t750 = (s5_9 + 1048576#64) &&& 18446744073707454464#64) →
          (hbs9_10 : Bnd s9_10 (-316725953255819) 283841654585039) →
          (hbs9_11 : Bnd s9_11 (-316725997725125) 283841783208680) →
          (hbs8_11 : Bnd s8_11 (-9223372036854775808) 9223372036854775807) →
          (hbcarry10_2 : Bnd carry10_2 (-123203657) 180298429) →
          (hbs11_11 : Bnd s11_11 (-124252233) 181347004) →
          (hbs10_11 : Bnd s10_11 (-1048576) 1048575) →
          (hbcarry1_1 : Bnd carry1_1 (-4398046511104) 4398046511103) →
          (hbcarry3_1 : Bnd carry3_1 (-4398046511104) 4398046511103) →
          (hbcarry5_1 : Bnd carry5_1 (-4398046511104) 4398046511103) →
          (hbs6_11 : Bnd s6_11 (-4398047559680) 4398047559678) →
          (hbcarry7_2 : Bnd carry7_2 (-217045724) 119581072) →
          (hbs8_12 : Bnd s8_12 (-9223372036854775808) 9223372036854775807) →
          (hbs7_12 : Bnd s7_12 (-1048576) 1048575) →
          (hbcarry9_2 : Bnd carry9_2 (-151026725) 135346309) →
          (hbs10_12 : Bnd s10_12 (-152075301) 136394884) →
          (hbs9_12 : Bnd s9_12 (-1048576) 1048575) →
          (hbcarry11_2 : Bnd carry11_2 (-59) 86) →
          (hbs11_12 : Bnd s11_12 (-1048576) 1048575) →
          (hbt765 : Bnd t765 (-39331937) 57331298) →
          (hbs0_4 : Bnd s0_4 (-40380513) 58379873) →
          (hbt767 : Bnd t767 (-27747464) 40445456) →
          (hbt768 : Bnd t768 (-38596797) 56259738) →
          (hbt769 : Bnd t769 (-85811230) 58870495) →
          (hbt770 : Bnd t770 (-8062763) 11752502) →
          (hbt771 : Bnd t771 (-58815486) 40350159) →
          (hbcarry0_2 : Bnd carry0_2 (-20) 27) →
          (hbt773 : Bnd t773 (-9223372036854775808) 9223372036854775807) →
          (hbs1_7 : Bnd s1_7 (-28796040) 41494031) →
          (hbs1_8 : Bnd s1_8 (-28796060) 41494058) →
          (hbs0_5 : Bnd s0_5 0 2097151) →
          (hbt746 : Bnd t746 (-9223372036854775808) 9223372036852678656) →
          (hbt750 : Bnd t750 (-9223372036854775808) 9223372036852678656) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 777 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 732 S >>= g) = K := by
  step_pure with s9_10
  sbnd s9_10
  step_pure with s9_11
  sbnd s9_11
  step_pure [Bnd.and_neg_shift]
  step_pure with s8_11
  sbnd s8_11
  step_pure
  step_pure with carry10_2
  sbnd carry10_2
  step_pure with s11_11
  sbnd s11_11
  step_pure [Bnd.and_neg_shift]
  step_pure with s10_11
  sbnd s10_11
  step_pure
  step_pure with carry1_1
  sbnd carry1_1
  step_pure [Bnd.and_neg_shift]
  step_pure
  step_pure with carry3_1
  sbnd carry3_1
  step_pure with t746
  sbnd t746
  step_pure
  step_pure with carry5_1
  sbnd carry5_1
  step_pure with s6_11
  sbnd s6_11
  step_pure with t750
  sbnd t750
  step_pure
  step_pure with carry7_2
  sbnd carry7_2
  step_pure with s8_12
  sbnd s8_12
  step_pure [Bnd.and_neg_shift]
  step_pure with s7_12
  sbnd s7_12
  step_pure
  step_pure with carry9_2
  sbnd carry9_2
  step_pure with s10_12
  sbnd s10_12
  step_pure [Bnd.and_neg_shift]
  step_pure with s9_12
  sbnd s9_12
  step_pure
  step_pure with carry11_2
  sbnd carry11_2
  step_pure [Bnd.and_neg_shift]
  step_pure with s11_12
  sbnd s11_12
  step_pure [nswMul] with t765
  sbnd t765
  step_pure with s0_4
  sbnd s0_4
  step_pure [nswMul] with t767
  sbnd t767
  step_pure [nswMul] with t768
  sbnd t768
  step_pure [nswMul] with t769
  sbnd t769
  step_pure [nswMul] with t770
  sbnd t770
  step_pure [nswMul] with t771
  sbnd t771
  step_pure with carry0_2
  sbnd carry0_2
  step_pure with t773
  sbnd t773
  step_pure with s1_7
  sbnd s1_7
  step_pure with s1_8
  sbnd s1_8
  step_pure with s0_5
  sbnd s0_5
  exact
    hK _ s9_10 s9_11 s8_11 carry10_2 s11_11 s10_11 carry1_1 carry3_1 carry5_1 s6_11 carry7_2 s8_12
      s7_12 carry9_2 s10_12 s9_12 carry11_2 s11_12 t765 s0_4 t767 t768 t769 t770 t771 carry0_2 t773
      s1_7 s1_8 s0_5 t746 t750 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) hs9_10 hs9_11 hs8_11 hcarry10_2 hs11_11 hs10_11 hcarry1_1 hcarry3_1 hcarry5_1
      hs6_11 hcarry7_2 hs8_12 hs7_12 hcarry9_2 hs10_12 hs9_12 hcarry11_2 hs11_12 ht765 hs0_4 ht767
      ht768 ht769 ht770 ht771 hcarry0_2 ht773 hs1_7 hs1_8 hs0_5 ht746 ht750 hbs9_10 hbs9_11 hbs8_11
      hbcarry10_2 hbs11_11 hbs10_11 hbcarry1_1 hbcarry3_1 hbcarry5_1 hbs6_11 hbcarry7_2 hbs8_12
      hbs7_12 hbcarry9_2 hbs10_12 hbs9_12 hbcarry11_2 hbs11_12 hbt765 hbs0_4 hbt767 hbt768 hbt769
      hbt770 hbt771 hbcarry0_2 hbt773 hbs1_7 hbs1_8 hbs0_5 hbt746 hbt750

/-- From `%777`: `carry1_2` … `s0_6`. -/
theorem fd_curve25519_scalar_muladd.run777 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s2_5 s4_7 s3_7 t715 s5_9 t722 carry1_1 carry3_1 t746 s6_11 t750 s8_12 s7_12 s10_12 s9_12 s11_12
      t768 t769 t770 t771 s1_8 s0_5 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 695 := s2_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 700 := s4_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 714 := s3_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 721 := s5_9,
        rir_reg% fd_curve25519_scalar_muladd.hty 742 := carry1_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 745 := carry3_1,
        rir_reg% fd_curve25519_scalar_muladd.hty 749 := s6_11,
        rir_reg% fd_curve25519_scalar_muladd.hty 753 := s8_12,
        rir_reg% fd_curve25519_scalar_muladd.hty 755 := s7_12,
        rir_reg% fd_curve25519_scalar_muladd.hty 758 := s10_12,
        rir_reg% fd_curve25519_scalar_muladd.hty 760 := s9_12,
        rir_reg% fd_curve25519_scalar_muladd.hty 764 := s11_12,
        rir_reg% fd_curve25519_scalar_muladd.hty 768 := t768,
        rir_reg% fd_curve25519_scalar_muladd.hty 769 := t769,
        rir_reg% fd_curve25519_scalar_muladd.hty 770 := t770,
        rir_reg% fd_curve25519_scalar_muladd.hty 771 := t771,
        rir_reg% fd_curve25519_scalar_muladd.hty 775 := s1_8,
        rir_reg% fd_curve25519_scalar_muladd.hty 776 := s0_5,
        rir_reg% fd_curve25519_scalar_muladd.hty 715 := t715,
        rir_reg% fd_curve25519_scalar_muladd.hty 722 := t722,
        rir_reg% fd_curve25519_scalar_muladd.hty 746 := t746,
        rir_reg% fd_curve25519_scalar_muladd.hty 750 := t750])
    (hbs6_11 : Bnd s6_11 (-4398047559680) 4398047559678) (hbs7_12 : Bnd s7_12 (-1048576) 1048575)
    (hbs10_12 : Bnd s10_12 (-152075301) 136394884) (hbs9_12 : Bnd s9_12 (-1048576) 1048575)
    (hbs11_12 : Bnd s11_12 (-1048576) 1048575) (hbs1_8 : Bnd s1_8 (-28796060) 41494058)
    (hbs0_5 : Bnd s0_5 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (carry1_2 t778 t779 s2_8 s2_9 s1_9 carry2_2 t784 s3_9 s3_10 s2_10 carry3_2 t789 t790 s4_10
          s4_11 s3_11 carry4_2 t795 s5_11 s5_12 s4_12 carry5_2 s6_12 s5_13 carry6_3 s7_13 s6_13
          carry7_3 s8_13 s7_14 carry8_3 s9_13 s8_14 carry9_3 s10_13 s9_14 carry10_3 s11_13 s10_14
          carry11_3 s11_14 t819 s0_6 t821 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 782 := s1_9,
              rir_reg% fd_curve25519_scalar_muladd.hty 787 := s2_10,
              rir_reg% fd_curve25519_scalar_muladd.hty 793 := s3_11,
              rir_reg% fd_curve25519_scalar_muladd.hty 798 := s4_12,
              rir_reg% fd_curve25519_scalar_muladd.hty 801 := s5_13,
              rir_reg% fd_curve25519_scalar_muladd.hty 804 := s6_13,
              rir_reg% fd_curve25519_scalar_muladd.hty 807 := s7_14,
              rir_reg% fd_curve25519_scalar_muladd.hty 810 := s8_14,
              rir_reg% fd_curve25519_scalar_muladd.hty 813 := s9_14,
              rir_reg% fd_curve25519_scalar_muladd.hty 816 := s10_14,
              rir_reg% fd_curve25519_scalar_muladd.hty 817 := carry11_3,
              rir_reg% fd_curve25519_scalar_muladd.hty 818 := s11_14,
              rir_reg% fd_curve25519_scalar_muladd.hty 820 := s0_6,
              rir_reg% fd_curve25519_scalar_muladd.hty 821 := t821]) →
          (hcarry1_2 : carry1_2 = BitVec.sshiftRight s1_8 21) →
          (ht778 : t778 = s2_5 + t768) →
          (ht779 : t779 = t778 - t715) →
          (hs2_8 : s2_8 = t779 + carry1_1) →
          (hs2_9 : s2_9 = s2_8 + carry1_2) →
          (hs1_9 : s1_9 = s1_8 &&& 2097151#64) →
          (hcarry2_2 : carry2_2 = BitVec.sshiftRight s2_9 21) →
          (ht784 : t784 = s3_7 + t769) →
          (hs3_9 : s3_9 = t784 - t746) →
          (hs3_10 : s3_10 = s3_9 + carry2_2) →
          (hs2_10 : s2_10 = s2_9 &&& 2097151#64) →
          (hcarry3_2 : carry3_2 = BitVec.sshiftRight s3_10 21) →
          (ht789 : t789 = s4_7 + t770) →
          (ht790 : t790 = t789 - t722) →
          (hs4_10 : s4_10 = t790 + carry3_1) →
          (hs4_11 : s4_11 = s4_10 + carry3_2) →
          (hs3_11 : s3_11 = s3_10 &&& 2097151#64) →
          (hcarry4_2 : carry4_2 = BitVec.sshiftRight s4_11 21) →
          (ht795 : t795 = s5_9 + t771) →
          (hs5_11 : s5_11 = t795 - t750) →
          (hs5_12 : s5_12 = s5_11 + carry4_2) →
          (hs4_12 : s4_12 = s4_11 &&& 2097151#64) →
          (hcarry5_2 : carry5_2 = BitVec.sshiftRight s5_12 21) →
          (hs6_12 : s6_12 = s6_11 + carry5_2) →
          (hs5_13 : s5_13 = s5_12 &&& 2097151#64) →
          (hcarry6_3 : carry6_3 = BitVec.sshiftRight s6_12 21) →
          (hs7_13 : s7_13 = carry6_3 + s7_12) →
          (hs6_13 : s6_13 = s6_12 &&& 2097151#64) →
          (hcarry7_3 : carry7_3 = BitVec.sshiftRight s7_13 21) →
          (hs8_13 : s8_13 = s8_12 + carry7_3) →
          (hs7_14 : s7_14 = s7_13 &&& 2097151#64) →
          (hcarry8_3 : carry8_3 = BitVec.sshiftRight s8_13 21) →
          (hs9_13 : s9_13 = carry8_3 + s9_12) →
          (hs8_14 : s8_14 = s8_13 &&& 2097151#64) →
          (hcarry9_3 : carry9_3 = BitVec.sshiftRight s9_13 21) →
          (hs10_13 : s10_13 = s10_12 + carry9_3) →
          (hs9_14 : s9_14 = s9_13 &&& 2097151#64) →
          (hcarry10_3 : carry10_3 = BitVec.sshiftRight s10_13 21) →
          (hs11_13 : s11_13 = carry10_3 + s11_12) →
          (hs10_14 : s10_14 = s10_13 &&& 2097151#64) →
          (hcarry11_3 : carry11_3 = BitVec.sshiftRight s11_13 21) →
          (hs11_14 : s11_14 = s11_13 &&& 2097151#64) →
          (ht819 : t819 = carry11_3 * 666643#64) →
          (hs0_6 : s0_6 = t819 + s0_5) →
          (ht821 : t821 = carry11_3 * 470296#64) →
          (hbcarry1_2 : Bnd carry1_2 (-14) 19) →
          (hbt778 : Bnd t778 (-9223372036854775808) 9223372036854775807) →
          (hbt779 : Bnd t779 (-9223372036854775808) 9223372036854775807) →
          (hbs2_8 : Bnd s2_8 (-9223372036854775808) 9223372036854775807) →
          (hbs2_9 : Bnd s2_9 (-9223372036854775808) 9223372036854775807) →
          (hbs1_9 : Bnd s1_9 0 2097151) →
          (hbcarry2_2 : Bnd carry2_2 (-4398046511104) 4398046511103) →
          (hbt784 : Bnd t784 (-9223372036854775808) 9223372036854775807) →
          (hbs3_9 : Bnd s3_9 (-9223372036854775808) 9223372036854775807) →
          (hbs3_10 : Bnd s3_10 (-9223372036854775808) 9223372036854775807) →
          (hbs2_10 : Bnd s2_10 0 2097151) →
          (hbcarry3_2 : Bnd carry3_2 (-4398046511104) 4398046511103) →
          (hbt789 : Bnd t789 (-9223372036854775808) 9223372036854775807) →
          (hbt790 : Bnd t790 (-9223372036854775808) 9223372036854775807) →
          (hbs4_10 : Bnd s4_10 (-9223372036854775808) 9223372036854775807) →
          (hbs4_11 : Bnd s4_11 (-9223372036854775808) 9223372036854775807) →
          (hbs3_11 : Bnd s3_11 0 2097151) →
          (hbcarry4_2 : Bnd carry4_2 (-4398046511104) 4398046511103) →
          (hbt795 : Bnd t795 (-9223372036854775808) 9223372036854775807) →
          (hbs5_11 : Bnd s5_11 (-9223372036854775808) 9223372036854775807) →
          (hbs5_12 : Bnd s5_12 (-9223372036854775808) 9223372036854775807) →
          (hbs4_12 : Bnd s4_12 0 2097151) →
          (hbcarry5_2 : Bnd carry5_2 (-4398046511104) 4398046511103) →
          (hbs6_12 : Bnd s6_12 (-8796094070784) 8796094070781) →
          (hbs5_13 : Bnd s5_13 0 2097151) →
          (hbcarry6_3 : Bnd carry6_3 (-4194305) 4194304) →
          (hbs7_13 : Bnd s7_13 (-5242881) 5242879) →
          (hbs6_13 : Bnd s6_13 0 2097151) →
          (hbcarry7_3 : Bnd carry7_3 (-3) 2) →
          (hbs8_13 : Bnd s8_13 (-9223372036854775808) 9223372036854775807) →
          (hbs7_14 : Bnd s7_14 0 2097151) →
          (hbcarry8_3 : Bnd carry8_3 (-4398046511104) 4398046511103) →
          (hbs9_13 : Bnd s9_13 (-4398047559680) 4398047559678) →
          (hbs8_14 : Bnd s8_14 0 2097151) →
          (hbcarry9_3 : Bnd carry9_3 (-2097153) 2097152) →
          (hbs10_13 : Bnd s10_13 (-154172454) 138492036) →
          (hbs9_14 : Bnd s9_14 0 2097151) →
          (hbcarry10_3 : Bnd carry10_3 (-74) 66) →
          (hbs11_13 : Bnd s11_13 (-1048650) 1048641) →
          (hbs10_14 : Bnd s10_14 0 2097151) →
          (hbcarry11_3 : Bnd carry11_3 (-1) 0) →
          (hbs11_14 : Bnd s11_14 0 2097151) →
          (hbt819 : Bnd t819 (-666643) 0) →
          (hbs0_6 : Bnd s0_6 (-666643) 2097151) →
          (hbt821 : Bnd t821 (-470296) 0) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 822 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 777 S >>= g) = K := by
  step_pure with carry1_2
  sbnd carry1_2
  step_pure with t778
  sbnd t778
  step_pure with t779
  sbnd t779
  step_pure with s2_8
  sbnd s2_8
  step_pure with s2_9
  sbnd s2_9
  step_pure with s1_9
  sbnd s1_9
  step_pure with carry2_2
  sbnd carry2_2
  step_pure with t784
  sbnd t784
  step_pure with s3_9
  sbnd s3_9
  step_pure with s3_10
  sbnd s3_10
  step_pure with s2_10
  sbnd s2_10
  step_pure with carry3_2
  sbnd carry3_2
  step_pure with t789
  sbnd t789
  step_pure with t790
  sbnd t790
  step_pure with s4_10
  sbnd s4_10
  step_pure with s4_11
  sbnd s4_11
  step_pure with s3_11
  sbnd s3_11
  step_pure with carry4_2
  sbnd carry4_2
  step_pure with t795
  sbnd t795
  step_pure with s5_11
  sbnd s5_11
  step_pure with s5_12
  sbnd s5_12
  step_pure with s4_12
  sbnd s4_12
  step_pure with carry5_2
  sbnd carry5_2
  step_pure with s6_12
  sbnd s6_12
  step_pure with s5_13
  sbnd s5_13
  step_pure with carry6_3
  sbnd carry6_3
  step_pure with s7_13
  sbnd s7_13
  step_pure with s6_13
  sbnd s6_13
  step_pure with carry7_3
  sbnd carry7_3
  step_pure with s8_13
  sbnd s8_13
  step_pure with s7_14
  sbnd s7_14
  step_pure with carry8_3
  sbnd carry8_3
  step_pure with s9_13
  sbnd s9_13
  step_pure with s8_14
  sbnd s8_14
  step_pure with carry9_3
  sbnd carry9_3
  step_pure with s10_13
  sbnd s10_13
  step_pure with s9_14
  sbnd s9_14
  step_pure with carry10_3
  sbnd carry10_3
  step_pure with s11_13
  sbnd s11_13
  step_pure with s10_14
  sbnd s10_14
  step_pure with carry11_3
  sbnd carry11_3
  step_pure with s11_14
  sbnd s11_14
  step_pure [nswMul] with t819
  sbnd t819
  step_pure [nswAdd] with s0_6
  sbnd s0_6
  step_pure [nswMul] with t821
  sbnd t821
  exact
    hK _ carry1_2 t778 t779 s2_8 s2_9 s1_9 carry2_2 t784 s3_9 s3_10 s2_10 carry3_2 t789 t790 s4_10
      s4_11 s3_11 carry4_2 t795 s5_11 s5_12 s4_12 carry5_2 s6_12 s5_13 carry6_3 s7_13 s6_13 carry7_3
      s8_13 s7_14 carry8_3 s9_13 s8_14 carry9_3 s10_13 s9_14 carry10_3 s11_13 s10_14 carry11_3
      s11_14 t819 s0_6 t821 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) hcarry1_2 ht778 ht779 hs2_8 hs2_9 hs1_9 hcarry2_2 ht784 hs3_9 hs3_10 hs2_10
      hcarry3_2 ht789 ht790 hs4_10 hs4_11 hs3_11 hcarry4_2 ht795 hs5_11 hs5_12 hs4_12 hcarry5_2
      hs6_12 hs5_13 hcarry6_3 hs7_13 hs6_13 hcarry7_3 hs8_13 hs7_14 hcarry8_3 hs9_13 hs8_14
      hcarry9_3 hs10_13 hs9_14 hcarry10_3 hs11_13 hs10_14 hcarry11_3 hs11_14 ht819 hs0_6 ht821
      hbcarry1_2 hbt778 hbt779 hbs2_8 hbs2_9 hbs1_9 hbcarry2_2 hbt784 hbs3_9 hbs3_10 hbs2_10
      hbcarry3_2 hbt789 hbt790 hbs4_10 hbs4_11 hbs3_11 hbcarry4_2 hbt795 hbs5_11 hbs5_12 hbs4_12
      hbcarry5_2 hbs6_12 hbs5_13 hbcarry6_3 hbs7_13 hbs6_13 hbcarry7_3 hbs8_13 hbs7_14 hbcarry8_3
      hbs9_13 hbs8_14 hbcarry9_3 hbs10_13 hbs9_14 hbcarry10_3 hbs11_13 hbs10_14 hbcarry11_3 hbs11_14
      hbt819 hbs0_6 hbt821

/-- From `%822`: `s1_10` … `s10_15`. -/
theorem fd_curve25519_scalar_muladd.run822 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s1_9 s2_10 s3_11 s4_12 s5_13 s6_13 s7_14 s8_14 s9_14 s10_14 carry11_3 s11_14 s0_6 t821 :
      BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 782 := s1_9,
        rir_reg% fd_curve25519_scalar_muladd.hty 787 := s2_10,
        rir_reg% fd_curve25519_scalar_muladd.hty 793 := s3_11,
        rir_reg% fd_curve25519_scalar_muladd.hty 798 := s4_12,
        rir_reg% fd_curve25519_scalar_muladd.hty 801 := s5_13,
        rir_reg% fd_curve25519_scalar_muladd.hty 804 := s6_13,
        rir_reg% fd_curve25519_scalar_muladd.hty 807 := s7_14,
        rir_reg% fd_curve25519_scalar_muladd.hty 810 := s8_14,
        rir_reg% fd_curve25519_scalar_muladd.hty 813 := s9_14,
        rir_reg% fd_curve25519_scalar_muladd.hty 816 := s10_14,
        rir_reg% fd_curve25519_scalar_muladd.hty 817 := carry11_3,
        rir_reg% fd_curve25519_scalar_muladd.hty 818 := s11_14,
        rir_reg% fd_curve25519_scalar_muladd.hty 820 := s0_6,
        rir_reg% fd_curve25519_scalar_muladd.hty 821 := t821])
    (hbs1_9 : Bnd s1_9 0 2097151) (hbs2_10 : Bnd s2_10 0 2097151) (hbs3_11 : Bnd s3_11 0 2097151)
    (hbs4_12 : Bnd s4_12 0 2097151) (hbs5_13 : Bnd s5_13 0 2097151) (hbs6_13 : Bnd s6_13 0 2097151)
    (hbs7_14 : Bnd s7_14 0 2097151) (hbs8_14 : Bnd s8_14 0 2097151) (hbs9_14 : Bnd s9_14 0 2097151)
    (hbs10_14 : Bnd s10_14 0 2097151) (hbcarry11_3 : Bnd carry11_3 (-1) 0)
    (hbs11_14 : Bnd s11_14 0 2097151) (hbs0_6 : Bnd s0_6 (-666643) 2097151)
    (hbt821 : Bnd t821 (-470296) 0)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫)
        (s1_10 t823 s2_11 t825 s3_12 t827 s4_13 t829 s5_14 carry0_3 s1_11 s0_7 carry1_3 s2_12
          carry2_3 s3_13 carry3_3 s4_14 carry4_3 s5_15 carry5_3 s6_14 carry6_4 s7_15 carry7_4 s8_15
          carry8_4 s9_15 carry9_4 s10_15 t852 t853 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hk : fd_curve25519_scalar_muladd.Consts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 832 := s1_11,
              rir_reg% fd_curve25519_scalar_muladd.hty 833 := s0_7,
              rir_reg% fd_curve25519_scalar_muladd.hty 835 := s2_12,
              rir_reg% fd_curve25519_scalar_muladd.hty 837 := s3_13,
              rir_reg% fd_curve25519_scalar_muladd.hty 839 := s4_14,
              rir_reg% fd_curve25519_scalar_muladd.hty 841 := s5_15,
              rir_reg% fd_curve25519_scalar_muladd.hty 843 := s6_14,
              rir_reg% fd_curve25519_scalar_muladd.hty 845 := s7_15,
              rir_reg% fd_curve25519_scalar_muladd.hty 847 := s8_15,
              rir_reg% fd_curve25519_scalar_muladd.hty 849 := s9_15,
              rir_reg% fd_curve25519_scalar_muladd.hty 851 := s10_15,
              rir_reg% fd_curve25519_scalar_muladd.hty 853 := t853]) →
          (hs1_10 : s1_10 = t821 + s1_9) →
          (ht823 : t823 = carry11_3 * 654183#64) →
          (hs2_11 : s2_11 = t823 + s2_10) →
          (ht825 : t825 = carry11_3 * 18446744073708553811#64) →
          (hs3_12 : s3_12 = t825 + s3_11) →
          (ht827 : t827 = carry11_3 * 136657#64) →
          (hs4_13 : s4_13 = t827 + s4_12) →
          (ht829 : t829 = carry11_3 * 18446744073708867715#64) →
          (hs5_14 : s5_14 = t829 + s5_13) →
          (hcarry0_3 : carry0_3 = BitVec.sshiftRight s0_6 21) →
          (hs1_11 : s1_11 = s1_10 + carry0_3) →
          (hs0_7 : s0_7 = s0_6 &&& 2097151#64) →
          (hcarry1_3 : carry1_3 = BitVec.sshiftRight s1_11 21) →
          (hs2_12 : s2_12 = s2_11 + carry1_3) →
          (hcarry2_3 : carry2_3 = BitVec.sshiftRight s2_12 21) →
          (hs3_13 : s3_13 = s3_12 + carry2_3) →
          (hcarry3_3 : carry3_3 = BitVec.sshiftRight s3_13 21) →
          (hs4_14 : s4_14 = s4_13 + carry3_3) →
          (hcarry4_3 : carry4_3 = BitVec.sshiftRight s4_14 21) →
          (hs5_15 : s5_15 = s5_14 + carry4_3) →
          (hcarry5_3 : carry5_3 = BitVec.sshiftRight s5_15 21) →
          (hs6_14 : s6_14 = carry5_3 + s6_13) →
          (hcarry6_4 : carry6_4 = BitVec.sshiftRight s6_14 21) →
          (hs7_15 : s7_15 = carry6_4 + s7_14) →
          (hcarry7_4 : carry7_4 = BitVec.sshiftRight s7_15 21) →
          (hs8_15 : s8_15 = carry7_4 + s8_14) →
          (hcarry8_4 : carry8_4 = BitVec.sshiftRight s8_15 21) →
          (hs9_15 : s9_15 = carry8_4 + s9_14) →
          (hcarry9_4 : carry9_4 = BitVec.sshiftRight s9_15 21) →
          (hs10_15 : s10_15 = carry9_4 + s10_14) →
          (ht852 : t852 = s10_15 >>> 21) →
          (ht853 : t853 = t852 + s11_14) →
          (hbs1_10 : Bnd s1_10 (-470296) 2097151) →
          (hbt823 : Bnd t823 (-654183) 0) →
          (hbs2_11 : Bnd s2_11 (-654183) 2097151) →
          (hbt825 : Bnd t825 0 997805) →
          (hbs3_12 : Bnd s3_12 0 3094956) →
          (hbt827 : Bnd t827 (-136657) 0) →
          (hbs4_13 : Bnd s4_13 (-136657) 2097151) →
          (hbt829 : Bnd t829 0 683901) →
          (hbs5_14 : Bnd s5_14 0 2781052) →
          (hbcarry0_3 : Bnd carry0_3 (-1) 0) →
          (hbs1_11 : Bnd s1_11 (-470297) 2097151) →
          (hbs0_7 : Bnd s0_7 0 2097151) →
          (hbcarry1_3 : Bnd carry1_3 (-1) 0) →
          (hbs2_12 : Bnd s2_12 (-654184) 2097151) →
          (hbcarry2_3 : Bnd carry2_3 (-1) 0) →
          (hbs3_13 : Bnd s3_13 (-1) 3094956) →
          (hbcarry3_3 : Bnd carry3_3 (-1) 1) →
          (hbs4_14 : Bnd s4_14 (-136658) 2097152) →
          (hbcarry4_3 : Bnd carry4_3 (-1) 1) →
          (hbs5_15 : Bnd s5_15 (-1) 2781053) →
          (hbcarry5_3 : Bnd carry5_3 (-1) 1) →
          (hbs6_14 : Bnd s6_14 (-1) 2097152) →
          (hbcarry6_4 : Bnd carry6_4 (-1) 1) →
          (hbs7_15 : Bnd s7_15 (-1) 2097152) →
          (hbcarry7_4 : Bnd carry7_4 (-1) 1) →
          (hbs8_15 : Bnd s8_15 (-1) 2097152) →
          (hbcarry8_4 : Bnd carry8_4 (-1) 1) →
          (hbs9_15 : Bnd s9_15 (-1) 2097152) →
          (hbcarry9_4 : Bnd carry9_4 (-1) 1) →
          (hbs10_15 : Bnd s10_15 (-1) 2097152) →
          (hbt852 : Bnd t852 0 8796093022207) →
          (hbt853 : Bnd t853 0 8796095119358) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 854 S >>= g) = K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 822 S >>= g) = K := by
  step_pure [nswAdd] with s1_10
  sbnd s1_10
  step_pure [nswMul] with t823
  sbnd t823
  step_pure [nswAdd] with s2_11
  sbnd s2_11
  step_pure [nswMul] with t825
  sbnd t825
  step_pure [nswAdd] with s3_12
  sbnd s3_12
  step_pure [nswMul] with t827
  sbnd t827
  step_pure [nswAdd] with s4_13
  sbnd s4_13
  step_pure [nswMul] with t829
  sbnd t829
  step_pure [nswAdd] with s5_14
  sbnd s5_14
  step_pure with carry0_3
  sbnd carry0_3
  step_pure [nswAdd] with s1_11
  sbnd s1_11
  step_pure with s0_7
  sbnd s0_7
  step_pure with carry1_3
  sbnd carry1_3
  step_pure [nswAdd] with s2_12
  sbnd s2_12
  step_pure with carry2_3
  sbnd carry2_3
  step_pure [nswAdd] with s3_13
  sbnd s3_13
  step_pure with carry3_3
  sbnd carry3_3
  step_pure [nswAdd] with s4_14
  sbnd s4_14
  step_pure with carry4_3
  sbnd carry4_3
  step_pure [nswAdd] with s5_15
  sbnd s5_15
  step_pure with carry5_3
  sbnd carry5_3
  step_pure [nswAdd] with s6_14
  sbnd s6_14
  step_pure with carry6_4
  sbnd carry6_4
  step_pure [nswAdd] with s7_15
  sbnd s7_15
  step_pure with carry7_4
  sbnd carry7_4
  step_pure [nswAdd] with s8_15
  sbnd s8_15
  step_pure with carry8_4
  sbnd carry8_4
  step_pure [nswAdd] with s9_15
  sbnd s9_15
  step_pure with carry9_4
  sbnd carry9_4
  step_pure [nswAdd] with s10_15
  sbnd s10_15
  step_pure with t852
  sbnd t852
  step_pure [nswAdd, nuwAdd] with t853
  sbnd t853
  exact
    hK _ s1_10 t823 s2_11 t825 s3_12 t827 s4_13 t829 s5_14 carry0_3 s1_11 s0_7 carry1_3 s2_12
      carry2_3 s3_13 carry3_3 s4_14 carry4_3 s5_15 carry5_3 s6_14 carry6_4 s7_15 carry7_4 s8_15
      carry8_4 s9_15 carry9_4 s10_15 t852 t853 hArgs
      (by
        unfold fd_curve25519_scalar_muladd.Consts; env_reads)
      (by env_reads) hs1_10 ht823 hs2_11 ht825 hs3_12 ht827 hs4_13 ht829 hs5_14 hcarry0_3 hs1_11
      hs0_7 hcarry1_3 hs2_12 hcarry2_3 hs3_13 hcarry3_3 hs4_14 hcarry4_3 hs5_15 hcarry5_3 hs6_14
      hcarry6_4 hs7_15 hcarry7_4 hs8_15 hcarry8_4 hs9_15 hcarry9_4 hs10_15 ht852 ht853 hbs1_10
      hbt823 hbs2_11 hbt825 hbs3_12 hbt827 hbs4_13 hbt829 hbs5_14 hbcarry0_3 hbs1_11 hbs0_7
      hbcarry1_3 hbs2_12 hbcarry2_3 hbs3_13 hbcarry3_3 hbs4_14 hbcarry4_3 hbs5_15 hbcarry5_3 hbs6_14
      hbcarry6_4 hbs7_15 hbcarry7_4 hbs8_15 hbcarry8_4 hbs9_15 hbcarry9_4 hbs10_15 hbt852 hbt853

/-- Word 0's `or disjoint`s hold: the limbs' bits are masked or shifted apart. -/
theorem fd_curve25519_scalar_muladd.out0_disjoint (s0_6 s1_11 s0_7 s2_12 s3_13 : BitVec 64)
    (hs0_7 : s0_7 = s0_6 &&& 2097151#64) :
    ((s1_11 <<< 21) &&& 4398044413952#64) &&& s0_7 = 0#64 ∧
      (((s1_11 <<< 21) &&& 4398044413952#64) ||| s0_7) &&&
          ((s2_12 <<< 42) &&& 9223367638808264704#64) =
        0#64 ∧
      ((((s1_11 <<< 21) &&& 4398044413952#64) ||| s0_7) |||
            ((s2_12 <<< 42) &&& 9223367638808264704#64)) &&&
          (s3_13 <<< 63) =
        0#64 := by
  subst hs0_7
  bv_decide

/-- Word 1's `or disjoint`s hold: the limbs' bits are masked or shifted apart. -/
theorem fd_curve25519_scalar_muladd.out1_disjoint (s3_13 s4_14 s5_15 s6_14 : BitVec 64) :
    ((s4_14 <<< 20) &&& 2199022206976#64) &&& ((s3_13 >>> 1) &&& 1048575#64) = 0#64 ∧
      (((s4_14 <<< 20) &&& 2199022206976#64) ||| ((s3_13 >>> 1) &&& 1048575#64)) &&&
          ((s5_15 <<< 41) &&& 4611683819404132352#64) =
        0#64 ∧
      ((((s4_14 <<< 20) &&& 2199022206976#64) ||| ((s3_13 >>> 1) &&& 1048575#64)) |||
            ((s5_15 <<< 41) &&& 4611683819404132352#64)) &&&
          (s6_14 <<< 62) =
        0#64 := by
  bv_decide

/-- Word 2's `or disjoint`s hold: the limbs' bits are masked or shifted apart. -/
theorem fd_curve25519_scalar_muladd.out2_disjoint (s6_14 s7_15 s8_15 s9_15 : BitVec 64) :
    ((s7_15 <<< 19) &&& 1099511103488#64) &&& ((s6_14 >>> 2) &&& 524287#64) = 0#64 ∧
      (((s7_15 <<< 19) &&& 1099511103488#64) ||| ((s6_14 >>> 2) &&& 524287#64)) &&&
          ((s8_15 <<< 40) &&& 2305841909702066176#64) =
        0#64 ∧
      ((((s7_15 <<< 19) &&& 1099511103488#64) ||| ((s6_14 >>> 2) &&& 524287#64)) |||
            ((s8_15 <<< 40) &&& 2305841909702066176#64)) &&&
          (s9_15 <<< 61) =
        0#64 := by
  bv_decide

/-- Word 3's `or disjoint`s hold: the limbs' bits are masked or shifted apart. -/
theorem fd_curve25519_scalar_muladd.out3_disjoint (s9_15 s10_15 t853 : BitVec 64) :
    ((s9_15 >>> 3) &&& 262143#64) &&& ((s10_15 <<< 18) &&& 549755551744#64) = 0#64 ∧
      (((s9_15 >>> 3) &&& 262143#64) ||| ((s10_15 <<< 18) &&& 549755551744#64)) &&& (t853 <<< 39) =
        0#64 := by
  bv_decide

/-- From `%854`: the limbs packed into four words, stored at `s`. -/
theorem fd_curve25519_scalar_muladd.run854 {β : Type} {s a b c : Pointer}
    {E : ⟪fd_curve25519_scalar_muladd.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_muladd.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_6 s1_11 s0_7 s2_12 s3_13 s4_14 s5_15 s6_14 s7_15 s8_15 s9_15 s10_15 t853 : BitVec 64}
    (hArgs :
      E.args = (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get)
    (hs : Room S.mem s (8 * 32)) (hs_off : ¬s.offset.uaddOverflow 32#64)
    (hk : fd_curve25519_scalar_muladd.Consts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_muladd.hty 832 := s1_11,
        rir_reg% fd_curve25519_scalar_muladd.hty 833 := s0_7,
        rir_reg% fd_curve25519_scalar_muladd.hty 835 := s2_12,
        rir_reg% fd_curve25519_scalar_muladd.hty 837 := s3_13,
        rir_reg% fd_curve25519_scalar_muladd.hty 839 := s4_14,
        rir_reg% fd_curve25519_scalar_muladd.hty 841 := s5_15,
        rir_reg% fd_curve25519_scalar_muladd.hty 843 := s6_14,
        rir_reg% fd_curve25519_scalar_muladd.hty 845 := s7_15,
        rir_reg% fd_curve25519_scalar_muladd.hty 847 := s8_15,
        rir_reg% fd_curve25519_scalar_muladd.hty 849 := s9_15,
        rir_reg% fd_curve25519_scalar_muladd.hty 851 := s10_15,
        rir_reg% fd_curve25519_scalar_muladd.hty 853 := t853])
    (hs0_7 : s0_7 = s0_6 &&& 2097151#64) (hbs7_15 : Bnd s7_15 (-1) 2097152)
    (hbs8_15 : Bnd s8_15 (-1) 2097152) (hbs10_15 : Bnd s10_15 (-1) 2097152)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_muladd.Γ⟫) (out0 out1 out2 out3 : BitVec 64),
        (hArgs :
            E'.args =
              (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)).get) →
          (hout0 :
            out0 =
              ((((s1_11 <<< 21) &&& 4398044413952#64) ||| s0_7) |||
                  ((s2_12 <<< 42) &&& 9223367638808264704#64)) |||
                (s3_13 <<< 63)) →
          (hout1 :
            out1 =
              ((((s4_14 <<< 20) &&& 2199022206976#64) ||| ((s3_13 >>> 1) &&& 1048575#64)) |||
                  ((s5_15 <<< 41) &&& 4611683819404132352#64)) |||
                (s6_14 <<< 62)) →
          (hout2 :
            out2 =
              ((((s7_15 <<< 19) &&& 1099511103488#64) ||| ((s6_14 >>> 2) &&& 524287#64)) |||
                  ((s8_15 <<< 40) &&& 2305841909702066176#64)) |||
                (s9_15 <<< 61)) →
          (hout3 :
            out3 =
              (((s9_15 >>> 3) &&& 262143#64) ||| ((s10_15 <<< 18) &&& 549755551744#64)) |||
                (t853 <<< 39)) →
          (fd_curve25519_scalar_muladd.entry.runBodyFrom E' 896
                { S with
                  mem :=
                    (((S.mem.storeAt s out0).storeAt (s.add 8#64) out1).storeAt (s.add 16#64)
                          out2).storeAt
                      (s.add 24#64) out3 } >>=
              g) =
            K) :
    (fd_curve25519_scalar_muladd.entry.runBodyFrom E 854 S >>= g) = K := by
  fold_eqs
  have hd0 := fd_curve25519_scalar_muladd.out0_disjoint s0_6 s1_11 s0_7 s2_12 s3_13 hs0_7
  have hd1 := fd_curve25519_scalar_muladd.out1_disjoint s3_13 s4_14 s5_15 s6_14
  have hd2 := fd_curve25519_scalar_muladd.out2_disjoint s6_14 s7_15 s8_15 s9_15
  have hd3 := fd_curve25519_scalar_muladd.out3_disjoint s9_15 s10_15 t853
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
  exact hK _ out0 out1 out2 out3 hArgs hout0 hout1 hout2 hout3

/-! ### The C values -/

theorem fd_curve25519_scalar_muladd.a1_eq {ia0 t58 a1 : BitVec 64} (ha1 : a1 = t58 &&& 2097151#64)
    (ht58 : t58 = ia0 >>> 21) : a1 = ((ia0 >>> 21) &&& 2097151#64) := by
  subst ha1 ht58
  bv_decide

theorem fd_curve25519_scalar_muladd.a2_eq {ia0 t60 a2 : BitVec 64} (ha2 : a2 = t60 &&& 2097151#64)
    (ht60 : t60 = ia0 >>> 42) : a2 = ((ia0 >>> 42) &&& 2097151#64) := by
  subst ha2 ht60
  bv_decide

theorem fd_curve25519_scalar_muladd.a3_eq {ia0 ia1 t62 a3 : BitVec 64}
    (ha3 : a3 = t62 &&& 2097151#64) (ht62 : t62 = BitVec.extractLsb' 64 64 ((ia1 ++ ia0) <<< 1)) :
    a3 = (((ia0 >>> 63) ||| (ia1 <<< 1)) &&& 2097151#64) := by
  subst ha3 ht62
  bv_decide

theorem fd_curve25519_scalar_muladd.a4_eq {ia1 t64 a4 : BitVec 64} (ha4 : a4 = t64 &&& 2097151#64)
    (ht64 : t64 = ia1 >>> 20) : a4 = ((ia1 >>> 20) &&& 2097151#64) := by
  subst ha4 ht64
  bv_decide

theorem fd_curve25519_scalar_muladd.a5_eq {ia1 t66 a5 : BitVec 64} (ha5 : a5 = t66 &&& 2097151#64)
    (ht66 : t66 = ia1 >>> 41) : a5 = ((ia1 >>> 41) &&& 2097151#64) := by
  subst ha5 ht66
  bv_decide

theorem fd_curve25519_scalar_muladd.a6_eq {ia1 ia2 t68 a6 : BitVec 64}
    (ha6 : a6 = t68 &&& 2097151#64) (ht68 : t68 = BitVec.extractLsb' 64 64 ((ia2 ++ ia1) <<< 2)) :
    a6 = (((ia1 >>> 62) ||| (ia2 <<< 2)) &&& 2097151#64) := by
  subst ha6 ht68
  bv_decide

theorem fd_curve25519_scalar_muladd.a7_eq {ia2 t70 a7 : BitVec 64} (ha7 : a7 = t70 &&& 2097151#64)
    (ht70 : t70 = ia2 >>> 19) : a7 = ((ia2 >>> 19) &&& 2097151#64) := by
  subst ha7 ht70
  bv_decide

theorem fd_curve25519_scalar_muladd.a8_eq {ia2 t72 a8 : BitVec 64} (ha8 : a8 = t72 &&& 2097151#64)
    (ht72 : t72 = ia2 >>> 40) : a8 = ((ia2 >>> 40) &&& 2097151#64) := by
  subst ha8 ht72
  bv_decide

theorem fd_curve25519_scalar_muladd.a9_eq {ia2 ia3 t74 a9 : BitVec 64}
    (ha9 : a9 = t74 &&& 2097151#64) (ht74 : t74 = BitVec.extractLsb' 64 64 ((ia3 ++ ia2) <<< 3)) :
    a9 = (((ia2 >>> 61) ||| (ia3 <<< 3)) &&& 2097151#64) := by
  subst ha9 ht74
  bv_decide

theorem fd_curve25519_scalar_muladd.a10_eq {ia3 t76 a10 : BitVec 64}
    (ha10 : a10 = t76 &&& 2097151#64) (ht76 : t76 = ia3 >>> 18) :
    a10 = ((ia3 >>> 18) &&& 2097151#64) := by
  subst ha10 ht76
  bv_decide

theorem fd_curve25519_scalar_muladd.b1_eq {ib0 t80 b1 : BitVec 64} (hb1 : b1 = t80 &&& 2097151#64)
    (ht80 : t80 = ib0 >>> 21) : b1 = ((ib0 >>> 21) &&& 2097151#64) := by
  subst hb1 ht80
  bv_decide

theorem fd_curve25519_scalar_muladd.b2_eq {ib0 t82 b2 : BitVec 64} (hb2 : b2 = t82 &&& 2097151#64)
    (ht82 : t82 = ib0 >>> 42) : b2 = ((ib0 >>> 42) &&& 2097151#64) := by
  subst hb2 ht82
  bv_decide

theorem fd_curve25519_scalar_muladd.b3_eq {ib0 ib1 t84 b3 : BitVec 64}
    (hb3 : b3 = t84 &&& 2097151#64) (ht84 : t84 = BitVec.extractLsb' 64 64 ((ib1 ++ ib0) <<< 1)) :
    b3 = (((ib0 >>> 63) ||| (ib1 <<< 1)) &&& 2097151#64) := by
  subst hb3 ht84
  bv_decide

theorem fd_curve25519_scalar_muladd.b4_eq {ib1 t86 b4 : BitVec 64} (hb4 : b4 = t86 &&& 2097151#64)
    (ht86 : t86 = ib1 >>> 20) : b4 = ((ib1 >>> 20) &&& 2097151#64) := by
  subst hb4 ht86
  bv_decide

theorem fd_curve25519_scalar_muladd.b5_eq {ib1 t88 b5 : BitVec 64} (hb5 : b5 = t88 &&& 2097151#64)
    (ht88 : t88 = ib1 >>> 41) : b5 = ((ib1 >>> 41) &&& 2097151#64) := by
  subst hb5 ht88
  bv_decide

theorem fd_curve25519_scalar_muladd.b6_eq {ib1 ib2 t90 b6 : BitVec 64}
    (hb6 : b6 = t90 &&& 2097151#64) (ht90 : t90 = BitVec.extractLsb' 64 64 ((ib2 ++ ib1) <<< 2)) :
    b6 = (((ib1 >>> 62) ||| (ib2 <<< 2)) &&& 2097151#64) := by
  subst hb6 ht90
  bv_decide

theorem fd_curve25519_scalar_muladd.b7_eq {ib2 t92 b7 : BitVec 64} (hb7 : b7 = t92 &&& 2097151#64)
    (ht92 : t92 = ib2 >>> 19) : b7 = ((ib2 >>> 19) &&& 2097151#64) := by
  subst hb7 ht92
  bv_decide

theorem fd_curve25519_scalar_muladd.b8_eq {ib2 t94 b8 : BitVec 64} (hb8 : b8 = t94 &&& 2097151#64)
    (ht94 : t94 = ib2 >>> 40) : b8 = ((ib2 >>> 40) &&& 2097151#64) := by
  subst hb8 ht94
  bv_decide

theorem fd_curve25519_scalar_muladd.b9_eq {ib2 ib3 t96 b9 : BitVec 64}
    (hb9 : b9 = t96 &&& 2097151#64) (ht96 : t96 = BitVec.extractLsb' 64 64 ((ib3 ++ ib2) <<< 3)) :
    b9 = (((ib2 >>> 61) ||| (ib3 <<< 3)) &&& 2097151#64) := by
  subst hb9 ht96
  bv_decide

theorem fd_curve25519_scalar_muladd.b10_eq {ib3 t98 b10 : BitVec 64}
    (hb10 : b10 = t98 &&& 2097151#64) (ht98 : t98 = ib3 >>> 18) :
    b10 = ((ib3 >>> 18) &&& 2097151#64) := by
  subst hb10 ht98
  bv_decide

theorem fd_curve25519_scalar_muladd.c1_eq {ic0 t102 c1 : BitVec 64} (hc1 : c1 = t102 &&& 2097151#64)
    (ht102 : t102 = ic0 >>> 21) : c1 = ((ic0 >>> 21) &&& 2097151#64) := by
  subst hc1 ht102
  bv_decide

theorem fd_curve25519_scalar_muladd.c2_eq {ic0 t104 c2 : BitVec 64} (hc2 : c2 = t104 &&& 2097151#64)
    (ht104 : t104 = ic0 >>> 42) : c2 = ((ic0 >>> 42) &&& 2097151#64) := by
  subst hc2 ht104
  bv_decide

theorem fd_curve25519_scalar_muladd.c3_eq {ic0 ic1 t106 c3 : BitVec 64}
    (hc3 : c3 = t106 &&& 2097151#64)
    (ht106 : t106 = BitVec.extractLsb' 64 64 ((ic1 ++ ic0) <<< 1)) :
    c3 = (((ic0 >>> 63) ||| (ic1 <<< 1)) &&& 2097151#64) := by
  subst hc3 ht106
  bv_decide

theorem fd_curve25519_scalar_muladd.c4_eq {ic1 t108 c4 : BitVec 64} (hc4 : c4 = t108 &&& 2097151#64)
    (ht108 : t108 = ic1 >>> 20) : c4 = ((ic1 >>> 20) &&& 2097151#64) := by
  subst hc4 ht108
  bv_decide

theorem fd_curve25519_scalar_muladd.c5_eq {ic1 t110 c5 : BitVec 64} (hc5 : c5 = t110 &&& 2097151#64)
    (ht110 : t110 = ic1 >>> 41) : c5 = ((ic1 >>> 41) &&& 2097151#64) := by
  subst hc5 ht110
  bv_decide

theorem fd_curve25519_scalar_muladd.c6_eq {ic1 ic2 t112 c6 : BitVec 64}
    (hc6 : c6 = t112 &&& 2097151#64)
    (ht112 : t112 = BitVec.extractLsb' 64 64 ((ic2 ++ ic1) <<< 2)) :
    c6 = (((ic1 >>> 62) ||| (ic2 <<< 2)) &&& 2097151#64) := by
  subst hc6 ht112
  bv_decide

theorem fd_curve25519_scalar_muladd.c7_eq {ic2 t114 c7 : BitVec 64} (hc7 : c7 = t114 &&& 2097151#64)
    (ht114 : t114 = ic2 >>> 19) : c7 = ((ic2 >>> 19) &&& 2097151#64) := by
  subst hc7 ht114
  bv_decide

theorem fd_curve25519_scalar_muladd.c8_eq {ic2 t116 c8 : BitVec 64} (hc8 : c8 = t116 &&& 2097151#64)
    (ht116 : t116 = ic2 >>> 40) : c8 = ((ic2 >>> 40) &&& 2097151#64) := by
  subst hc8 ht116
  bv_decide

theorem fd_curve25519_scalar_muladd.c9_eq {ic2 ic3 t118 c9 : BitVec 64}
    (hc9 : c9 = t118 &&& 2097151#64)
    (ht118 : t118 = BitVec.extractLsb' 64 64 ((ic3 ++ ic2) <<< 3)) :
    c9 = (((ic2 >>> 61) ||| (ic3 <<< 3)) &&& 2097151#64) := by
  subst hc9 ht118
  bv_decide

theorem fd_curve25519_scalar_muladd.c10_eq {ic3 t120 c10 : BitVec 64}
    (hc10 : c10 = t120 &&& 2097151#64) (ht120 : t120 = ic3 >>> 18) :
    c10 = ((ic3 >>> 18) &&& 2097151#64) := by
  subst hc10 ht120
  bv_decide

theorem fd_curve25519_scalar_muladd.s0_eq {a0 b0 c0 t123 s0 : BitVec 64} (hs0 : s0 = c0 + t123)
    (ht123 : t123 = b0 * a0) : s0 = (c0 + (a0 * b0)) := by
  subst hs0 ht123
  grind

theorem fd_curve25519_scalar_muladd.s2_eq
    {a0 a1 a2 b0 b1 b2 c2 t127 t128 t129 t130 t131 s2 : BitVec 64} (hs2 : s2 = t131 + t128)
    (ht131 : t131 = t130 + c2) (ht130 : t130 = t127 + t129) (ht129 : t129 = a2 * b0)
    (ht127 : t127 = b2 * a0) (ht128 : t128 = b1 * a1) :
    s2 = (((c2 + (a0 * b2)) + (a1 * b1)) + (a2 * b0)) := by
  subst hs2 ht131 ht130 ht129 ht127 ht128
  grind

theorem fd_curve25519_scalar_muladd.s4_eq
    {a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 c4 t137 t138 t139 t140 t141 t142 t143 t144 t145 s4 : BitVec 64}
    (hs4 : s4 = t145 + t138) (ht145 : t145 = t144 + c4) (ht144 : t144 = t143 + t137)
    (ht137 : t137 = b4 * a0) (ht143 : t143 = t142 + t141) (ht141 : t141 = a4 * b0)
    (ht142 : t142 = t140 + t139) (ht140 : t140 = a3 * b1) (ht139 : t139 = b2 * a2)
    (ht138 : t138 = b3 * a1) :
    s4 = (((((c4 + (a0 * b4)) + (a1 * b3)) + (a2 * b2)) + (a3 * b1)) + (a4 * b0)) := by
  subst hs4 ht145 ht144 ht137 ht143 ht141 ht142 ht140 ht139 ht138
  grind

theorem fd_curve25519_scalar_muladd.s6_eq
    {a0 a1 a2 a3 a4 a5 a6 b0 b1 b2 b3 b4 b5 b6 c6 t153 t154 t155 t156 t157 t158 t159 t160 t161 t162
      t163 t164 t165 s6 : BitVec 64}
    (hs6 : s6 = t165 + c6) (ht165 : t165 = t164 + t153) (ht164 : t164 = t163 + t159)
    (ht163 : t163 = t162 + t156) (ht156 : t156 = b3 * a3) (ht162 : t162 = t161 + t155)
    (ht155 : t155 = b4 * a2) (ht161 : t161 = t160 + t154) (ht160 : t160 = t158 + t157)
    (ht158 : t158 = a5 * b1) (ht157 : t157 = a4 * b2) (ht154 : t154 = b5 * a1)
    (ht159 : t159 = a6 * b0) (ht153 : t153 = b6 * a0) :
    s6 =
      (((((((c6 + (a0 * b6)) + (a1 * b5)) + (a2 * b4)) + (a3 * b3)) + (a4 * b2)) + (a5 * b1)) +
        (a6 * b0)) := by
  subst hs6 ht165 ht164 ht163 ht156 ht162 ht155 ht161 ht160 ht158 ht157 ht154 ht159 ht153
  grind

theorem fd_curve25519_scalar_muladd.s8_eq
    {a0 a1 a2 a3 a4 a5 a6 a7 a8 b0 b1 b2 b3 b4 b5 b6 b7 b8 c8 t175 t176 t177 t178 t179 t180 t181
      t182 t183 t184 t185 t186 t187 t188 t189 t190 t191 s8 : BitVec 64}
    (hs8 : s8 = t191 + t177) (ht177 : t177 = b6 * a2) (ht191 : t191 = t190 + t176)
    (ht190 : t190 = t189 + c8) (ht189 : t189 = t188 + t175) (ht188 : t188 = t187 + t183)
    (ht187 : t187 = t186 + t182) (ht182 : t182 = a7 * b1) (ht186 : t186 = t185 + t181)
    (ht185 : t185 = t184 + t180) (ht184 : t184 = t179 + t178) (ht179 : t179 = b4 * a4)
    (ht178 : t178 = b5 * a3) (ht180 : t180 = b3 * a5) (ht181 : t181 = a6 * b2)
    (ht183 : t183 = a8 * b0) (ht175 : t175 = b8 * a0) (ht176 : t176 = b7 * a1) :
    s8 =
      (((((((((c8 + (a0 * b8)) + (a1 * b7)) + (a2 * b6)) + (a3 * b5)) + (a4 * b4)) + (a5 * b3)) +
            (a6 * b2)) +
          (a7 * b1)) +
        (a8 * b0)) := by
  subst hs8 ht177 ht191 ht190 ht189 ht188 ht187 ht182 ht186 ht185 ht184 ht179 ht178 ht180 ht181
    ht183 ht175 ht176
  grind

theorem fd_curve25519_scalar_muladd.s10_eq
    {a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 c10 t203 t204 t205 t206
      t207 t208 t209 t210 t211 t212 t213 t214 t215 t216 t217 t218 t219 t220 t221 t222 t223 s10 :
      BitVec 64}
    (hs10 : s10 = t223 + t204) (ht204 : t204 = b9 * a1) (ht223 : t223 = t222 + c10)
    (ht222 : t222 = t221 + t203) (ht203 : t203 = b10 * a0) (ht221 : t221 = t220 + t213)
    (ht213 : t213 = a10 * b0) (ht220 : t220 = t219 + t212) (ht212 : t212 = a9 * b1)
    (ht219 : t219 = t218 + t207) (ht218 : t218 = t217 + t206) (ht206 : t206 = b7 * a3)
    (ht217 : t217 = t216 + t205) (ht216 : t216 = t215 + t211) (ht215 : t215 = t214 + t210)
    (ht210 : t210 = a7 * b3) (ht214 : t214 = t209 + t208) (ht209 : t209 = a6 * b4)
    (ht208 : t208 = b5 * a5) (ht211 : t211 = a8 * b2) (ht205 : t205 = b8 * a2)
    (ht207 : t207 = b6 * a4) :
    s10 =
      (((((((((((c10 + (a0 * b10)) + (a1 * b9)) + (a2 * b8)) + (a3 * b7)) + (a4 * b6)) +
                  (a5 * b5)) +
                (a6 * b4)) +
              (a7 * b3)) +
            (a8 * b2)) +
          (a9 * b1)) +
        (a10 * b0)) := by
  subst hs10 ht204 ht223 ht222 ht203 ht221 ht213 ht220 ht212 ht219 ht218 ht206 ht217 ht216 ht215
    ht210 ht214 ht209 ht208 ht211 ht205 ht207
  grind

theorem fd_curve25519_scalar_muladd.s12_eq
    {a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 t237 t238 t239 t240 t241
      t242 t243 t244 t245 t246 t247 t248 t249 t250 t251 t252 t253 t254 t255 t256 s12 : BitVec 64}
    (hs12 : s12 = t256 + t239) (ht256 : t256 = t255 + t238) (ht255 : t255 = t254 + t246)
    (ht254 : t254 = t253 + t245) (ht253 : t253 = t252 + t237) (ht237 : t237 = b11 * a1)
    (ht252 : t252 = t251 + t247) (ht247 : t247 = a11 * b1) (ht251 : t251 = t250 + t242)
    (ht242 : t242 = b6 * a6) (ht250 : t250 = t249 + t241) (ht249 : t249 = t248 + t240)
    (ht240 : t240 = b8 * a4) (ht248 : t248 = t244 + t243) (ht243 : t243 = a7 * b5)
    (ht244 : t244 = a8 * b4) (ht241 : t241 = b7 * a5) (ht245 : t245 = a9 * b3)
    (ht246 : t246 = a10 * b2) (ht238 : t238 = b10 * a2) (ht239 : t239 = b9 * a3) :
    s12 =
      (((((((((((a1 * b11) + (a2 * b10)) + (a3 * b9)) + (a4 * b8)) + (a5 * b7)) + (a6 * b6)) +
                (a7 * b5)) +
              (a8 * b4)) +
            (a9 * b3)) +
          (a10 * b2)) +
        (a11 * b1)) := by
  subst hs12 ht256 ht255 ht254 ht253 ht237 ht252 ht247 ht251 ht242 ht250 ht249 ht240 ht248 ht243
    ht244 ht241 ht245 ht246 ht238 ht239
  grind

theorem fd_curve25519_scalar_muladd.s14_eq
    {a3 a4 a5 a6 a7 a8 a9 a10 a11 b3 b4 b5 b6 b7 b8 b9 b10 b11 t268 t269 t270 t271 t272 t273 t274
      t275 t276 t277 t278 t279 t280 t281 t282 t283 s14 : BitVec 64}
    (hs14 : s14 = t283 + t270) (ht283 : t283 = t282 + t269) (ht282 : t282 = t281 + t275)
    (ht281 : t281 = t280 + t274) (ht280 : t280 = t279 + t268) (ht279 : t279 = t278 + t276)
    (ht276 : t276 = a11 * b3) (ht278 : t278 = t277 + t273) (ht277 : t277 = t272 + t271)
    (ht271 : t271 = b8 * a6) (ht272 : t272 = b7 * a7) (ht273 : t273 = b6 * a8)
    (ht268 : t268 = b11 * a3) (ht274 : t274 = a9 * b5) (ht275 : t275 = a10 * b4)
    (ht269 : t269 = b10 * a4) (ht270 : t270 = b9 * a5) :
    s14 =
      (((((((((a3 * b11) + (a4 * b10)) + (a5 * b9)) + (a6 * b8)) + (a7 * b7)) + (a8 * b6)) +
            (a9 * b5)) +
          (a10 * b4)) +
        (a11 * b3)) := by
  subst hs14 ht283 ht282 ht281 ht280 ht279 ht276 ht278 ht277 ht271 ht272 ht273 ht268 ht274 ht275
    ht269 ht270
  grind

theorem fd_curve25519_scalar_muladd.s16_eq
    {a5 a6 a7 a8 a9 a10 a11 b5 b6 b7 b8 b9 b10 b11 t293 t294 t295 t296 t297 t298 t299 t300 t301 t302
      t303 t304 s16 : BitVec 64}
    (hs16 : s16 = t304 + t295) (ht295 : t295 = b9 * a7) (ht304 : t304 = t303 + t294)
    (ht294 : t294 = b10 * a6) (ht303 : t303 = t302 + t298) (ht302 : t302 = t301 + t297)
    (ht301 : t301 = t300 + t293) (ht300 : t300 = t299 + t296) (ht299 : t299 = a11 * b5)
    (ht296 : t296 = b8 * a8) (ht293 : t293 = b11 * a5) (ht297 : t297 = a9 * b7)
    (ht298 : t298 = a10 * b6) :
    s16 =
      (((((((a5 * b11) + (a6 * b10)) + (a7 * b9)) + (a8 * b8)) + (a9 * b7)) + (a10 * b6)) +
        (a11 * b5)) := by
  subst hs16 ht295 ht304 ht294 ht303 ht302 ht301 ht300 ht299 ht296 ht293 ht297 ht298
  grind

theorem fd_curve25519_scalar_muladd.s18_eq
    {a7 a8 a9 a10 a11 b7 b8 b9 b10 b11 t312 t313 t314 t315 t316 t317 t318 t319 s18 : BitVec 64}
    (hs18 : s18 = t319 + t314) (ht319 : t319 = t318 + t313) (ht318 : t318 = t317 + t315)
    (ht315 : t315 = a10 * b8) (ht317 : t317 = t312 + t316) (ht312 : t312 = b11 * a7)
    (ht316 : t316 = a11 * b7) (ht313 : t313 = b10 * a8) (ht314 : t314 = b9 * a9) :
    s18 = (((((a7 * b11) + (a8 * b10)) + (a9 * b9)) + (a10 * b8)) + (a11 * b7)) := by
  subst hs18 ht319 ht318 ht315 ht317 ht312 ht316 ht313 ht314
  grind

theorem fd_curve25519_scalar_muladd.s20_eq
    {a9 a10 a11 b9 b10 b11 t325 t326 t327 t328 s20 : BitVec 64} (hs20 : s20 = t327 + t328)
    (ht328 : t328 = b9 * a11) (ht327 : t327 = t326 + t325) (ht325 : t325 = a9 * b11)
    (ht326 : t326 = b10 * a10) : s20 = (((a9 * b11) + (a10 * b10)) + (a11 * b9)) := by
  subst hs20 ht328 ht327 ht325 ht326
  grind

theorem fd_curve25519_scalar_muladd.s21_eq {a10 a11 b10 b11 t330 t331 s21 : BitVec 64}
    (hs21 : s21 = t331 + t330) (ht331 : t331 = b10 * a11) (ht330 : t330 = a10 * b11) :
    s21 = ((a10 * b11) + (a11 * b10)) := by
  subst hs21 ht331 ht330
  grind

theorem fd_curve25519_scalar_muladd.s22_eq {a11 b11 s22 : BitVec 64} (hs22 : s22 = b11 * a11) :
    s22 = (a11 * b11) := by
  subst hs22
  grind

theorem fd_curve25519_scalar_muladd.s1_eq {a0 a1 b0 b1 c1 t125 t126 t336 s1 : BitVec 64}
    (hs1 : s1 = t336 + c1) (ht336 : t336 = t125 + t126) (ht125 : t125 = b1 * a0)
    (ht126 : t126 = a1 * b0) : s1 = ((c1 + (a0 * b1)) + (a1 * b0)) := by
  subst hs1 ht336 ht125 ht126
  grind

theorem fd_curve25519_scalar_muladd.s0_1_eq {s0 carry0 s0_1 : BitVec 64}
    (hs0_1 : s0_1 = s0 - ((BitVec.sshiftRight (s0 + 1048576#64) 21) <<< 21))
    (hcarry0 : carry0 = BitVec.sshiftRight (s0 + 1048576#64) 21) :
    s0_1 = (s0 - (carry0 <<< 21)) := by
  rw [← hcarry0] at hs0_1
  clear hcarry0
  subst hs0_1
  grind

theorem fd_curve25519_scalar_muladd.s3_eq
    {a0 a1 a2 a3 b0 b1 b2 b3 c3 t133 t134 t135 t136 t343 t344 t345 s3 : BitVec 64}
    (hs3 : s3 = t345 + c3) (ht345 : t345 = t344 + t133) (ht133 : t133 = b3 * a0)
    (ht344 : t344 = t343 + t136) (ht136 : t136 = a3 * b0) (ht343 : t343 = t135 + t134)
    (ht135 : t135 = b1 * a2) (ht134 : t134 = b2 * a1) :
    s3 = ((((c3 + (a0 * b3)) + (a1 * b2)) + (a2 * b1)) + (a3 * b0)) := by
  subst hs3 ht345 ht133 ht344 ht136 ht343 ht135 ht134
  grind

theorem fd_curve25519_scalar_muladd.s2_1_eq {s2 carry2 s2_1 : BitVec 64}
    (hs2_1 : s2_1 = s2 - ((BitVec.sshiftRight (s2 + 1048576#64) 21) <<< 21))
    (hcarry2 : carry2 = BitVec.sshiftRight (s2 + 1048576#64) 21) :
    s2_1 = (s2 - (carry2 <<< 21)) := by
  rw [← hcarry2] at hs2_1
  clear hcarry2
  subst hs2_1
  grind

theorem fd_curve25519_scalar_muladd.s5_eq
    {a0 a1 a2 a3 a4 a5 b0 b1 b2 b3 b4 b5 c5 t147 t148 t149 t150 t151 t152 t352 t353 t354 t355 t356
      s5 : BitVec 64}
    (hs5 : s5 = t356 + t149) (ht149 : t149 = b3 * a2) (ht356 : t356 = t355 + t148)
    (ht355 : t355 = t354 + c5) (ht354 : t354 = t353 + t147) (ht353 : t353 = t352 + t152)
    (ht352 : t352 = t151 + t150) (ht150 : t150 = a3 * b2) (ht151 : t151 = a4 * b1)
    (ht152 : t152 = a5 * b0) (ht147 : t147 = b5 * a0) (ht148 : t148 = b4 * a1) :
    s5 =
      ((((((c5 + (a0 * b5)) + (a1 * b4)) + (a2 * b3)) + (a3 * b2)) + (a4 * b1)) + (a5 * b0)) := by
  subst hs5 ht149 ht356 ht355 ht354 ht353 ht352 ht150 ht151 ht152 ht147 ht148
  grind

theorem fd_curve25519_scalar_muladd.s4_1_eq {s4 carry4 s4_1 : BitVec 64}
    (hs4_1 : s4_1 = s4 - ((BitVec.sshiftRight (s4 + 1048576#64) 21) <<< 21))
    (hcarry4 : carry4 = BitVec.sshiftRight (s4 + 1048576#64) 21) :
    s4_1 = (s4 - (carry4 <<< 21)) := by
  rw [← hcarry4] at hs4_1
  clear hcarry4
  subst hs4_1
  grind

theorem fd_curve25519_scalar_muladd.carry6_eq {s6 t361 carry6 : BitVec 64}
    (hcarry6 : carry6 = BitVec.sshiftRight t361 21) (ht361 : t361 = s6 + 1048576#64) :
    carry6 = (BitVec.sshiftRight (s6 + 1048576#64) 21) := by
  subst hcarry6 ht361
  rfl

theorem fd_curve25519_scalar_muladd.s7_eq
    {a0 a1 a2 a3 a4 a5 a6 a7 b0 b1 b2 b3 b4 b5 b6 b7 c7 t167 t168 t169 t170 t171 t172 t173 t174 t363
      t364 t365 t366 t367 t368 t369 s7 : BitVec 64}
    (hs7 : s7 = t369 + t168) (ht168 : t168 = b6 * a1) (ht369 : t369 = t368 + c7)
    (ht368 : t368 = t367 + t167) (ht167 : t167 = b7 * a0) (ht367 : t367 = t366 + t174)
    (ht174 : t174 = a7 * b0) (ht366 : t366 = t365 + t173) (ht365 : t365 = t364 + t171)
    (ht171 : t171 = b3 * a4) (ht364 : t364 = t363 + t170) (ht170 : t170 = b4 * a3)
    (ht363 : t363 = t169 + t172) (ht169 : t169 = b5 * a2) (ht172 : t172 = a5 * b2)
    (ht173 : t173 = a6 * b1) :
    s7 =
      ((((((((c7 + (a0 * b7)) + (a1 * b6)) + (a2 * b5)) + (a3 * b4)) + (a4 * b3)) + (a5 * b2)) +
          (a6 * b1)) +
        (a7 * b0)) := by
  subst hs7 ht168 ht369 ht368 ht167 ht367 ht174 ht366 ht365 ht171 ht364 ht170 ht363 ht169 ht172
    ht173
  grind

theorem fd_curve25519_scalar_muladd.s9_eq
    {a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 c9 t193 t194 t195 t196 t197 t198
      t199 t200 t201 t202 t375 t376 t377 t378 t379 t380 t381 t382 t383 s9 : BitVec 64}
    (hs9 : s9 = t383 + c9) (ht383 : t383 = t382 + t193) (ht193 : t193 = b9 * a0)
    (ht382 : t382 = t381 + t202) (ht381 : t381 = t380 + t196) (ht380 : t380 = t379 + t195)
    (ht195 : t195 = b7 * a2) (ht379 : t379 = t378 + t194) (ht194 : t194 = b8 * a1)
    (ht378 : t378 = t377 + t201) (ht201 : t201 = a8 * b1) (ht377 : t377 = t376 + t200)
    (ht376 : t376 = t375 + t199) (ht375 : t375 = t198 + t197) (ht198 : t198 = b4 * a5)
    (ht197 : t197 = b5 * a4) (ht199 : t199 = a6 * b3) (ht200 : t200 = a7 * b2)
    (ht196 : t196 = b6 * a3) (ht202 : t202 = a9 * b0) :
    s9 =
      ((((((((((c9 + (a0 * b9)) + (a1 * b8)) + (a2 * b7)) + (a3 * b6)) + (a4 * b5)) + (a5 * b4)) +
              (a6 * b3)) +
            (a7 * b2)) +
          (a8 * b1)) +
        (a9 * b0)) := by
  subst hs9 ht383 ht193 ht382 ht381 ht380 ht195 ht379 ht194 ht378 ht201 ht377 ht376 ht375 ht198
    ht197 ht199 ht200 ht196 ht202
  grind

theorem fd_curve25519_scalar_muladd.s8_1_eq {s8 carry8 s8_1 : BitVec 64}
    (hs8_1 : s8_1 = s8 - ((BitVec.sshiftRight (s8 + 1048576#64) 21) <<< 21))
    (hcarry8 : carry8 = BitVec.sshiftRight (s8 + 1048576#64) 21) :
    s8_1 = (s8 - (carry8 <<< 21)) := by
  rw [← hcarry8] at hs8_1
  clear hcarry8
  subst hs8_1
  grind

theorem fd_curve25519_scalar_muladd.s11_eq
    {a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 c11 t225 t226 t227
      t228 t229 t230 t231 t232 t233 t234 t235 t236 t390 t391 t392 t393 t394 t395 t396 t397 t398 t399
      t400 s11 : BitVec 64}
    (hs11 : s11 = t400 + t227) (ht227 : t227 = b9 * a2) (ht400 : t400 = t399 + t226)
    (ht226 : t226 = b10 * a1) (ht399 : t399 = t398 + t235) (ht235 : t235 = a10 * b1)
    (ht398 : t398 = t397 + t234) (ht397 : t397 = t396 + c11) (ht396 : t396 = t395 + t225)
    (ht395 : t395 = t394 + t236) (ht236 : t236 = a11 * b0) (ht394 : t394 = t393 + t230)
    (ht393 : t393 = t392 + t229) (ht229 : t229 = b7 * a4) (ht392 : t392 = t391 + t228)
    (ht391 : t391 = t390 + t233) (ht233 : t233 = a8 * b3) (ht390 : t390 = t232 + t231)
    (ht231 : t231 = a6 * b5) (ht232 : t232 = a7 * b4) (ht228 : t228 = b8 * a3)
    (ht230 : t230 = b6 * a5) (ht225 : t225 = b11 * a0) (ht234 : t234 = a9 * b2) :
    s11 =
      ((((((((((((c11 + (a0 * b11)) + (a1 * b10)) + (a2 * b9)) + (a3 * b8)) + (a4 * b7)) +
                    (a5 * b6)) +
                  (a6 * b5)) +
                (a7 * b4)) +
              (a8 * b3)) +
            (a9 * b2)) +
          (a10 * b1)) +
        (a11 * b0)) := by
  subst hs11 ht227 ht400 ht226 ht399 ht235 ht398 ht397 ht396 ht395 ht236 ht394 ht393 ht229 ht392
    ht391 ht233 ht390 ht231 ht232 ht228 ht230 ht225 ht234
  grind

theorem fd_curve25519_scalar_muladd.s13_eq
    {a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 t258 t259 t260 t261 t262 t263
      t264 t265 t266 t267 t406 t407 t408 t409 t410 t411 t412 t413 s13 : BitVec 64}
    (hs13 : s13 = t413 + t260) (ht413 : t413 = t412 + t259) (ht259 : t259 = b10 * a3)
    (ht412 : t412 = t411 + t266) (ht266 : t266 = a10 * b3) (ht411 : t411 = t410 + t265)
    (ht265 : t265 = a9 * b4) (ht410 : t410 = t409 + t258) (ht409 : t409 = t408 + t267)
    (ht267 : t267 = a11 * b2) (ht408 : t408 = t407 + t263) (ht407 : t407 = t406 + t262)
    (ht262 : t262 = b7 * a6) (ht406 : t406 = t261 + t264) (ht261 : t261 = b8 * a5)
    (ht264 : t264 = a8 * b5) (ht263 : t263 = b6 * a7) (ht258 : t258 = b11 * a2)
    (ht260 : t260 = b9 * a4) :
    s13 =
      ((((((((((a2 * b11) + (a3 * b10)) + (a4 * b9)) + (a5 * b8)) + (a6 * b7)) + (a7 * b6)) +
              (a8 * b5)) +
            (a9 * b4)) +
          (a10 * b3)) +
        (a11 * b2)) := by
  subst hs13 ht413 ht259 ht412 ht266 ht411 ht265 ht410 ht409 ht267 ht408 ht407 ht262 ht406 ht261
    ht264 ht263 ht258 ht260
  grind

theorem fd_curve25519_scalar_muladd.s15_eq
    {a4 a5 a6 a7 a8 a9 a10 a11 b4 b5 b6 b7 b8 b9 b10 b11 t285 t286 t287 t288 t289 t290 t291 t292
      t419 t420 t421 t422 t423 t424 s15 : BitVec 64}
    (hs15 : s15 = t424 + t287) (ht424 : t424 = t423 + t286) (ht423 : t423 = t422 + t291)
    (ht422 : t422 = t421 + t290) (ht290 : t290 = a9 * b6) (ht421 : t421 = t420 + t285)
    (ht285 : t285 = b11 * a4) (ht420 : t420 = t419 + t292) (ht292 : t292 = a11 * b4)
    (ht419 : t419 = t289 + t288) (ht288 : t288 = b8 * a7) (ht289 : t289 = b7 * a8)
    (ht291 : t291 = a10 * b5) (ht286 : t286 = b10 * a5) (ht287 : t287 = b9 * a6) :
    s15 =
      ((((((((a4 * b11) + (a5 * b10)) + (a6 * b9)) + (a7 * b8)) + (a8 * b7)) + (a9 * b6)) +
          (a10 * b5)) +
        (a11 * b4)) := by
  subst hs15 ht424 ht423 ht422 ht290 ht421 ht285 ht420 ht292 ht419 ht288 ht289 ht291 ht286 ht287
  grind

theorem fd_curve25519_scalar_muladd.s17_eq
    {a6 a7 a8 a9 a10 a11 b6 b7 b8 b9 b10 b11 t306 t307 t308 t309 t310 t311 t430 t431 t432 t433 s17 :
      BitVec 64}
    (hs17 : s17 = t433 + t308) (ht433 : t433 = t432 + t307) (ht432 : t432 = t431 + t310)
    (ht310 : t310 = a10 * b7) (ht431 : t431 = t430 + t309) (ht309 : t309 = a9 * b8)
    (ht430 : t430 = t306 + t311) (ht306 : t306 = b11 * a6) (ht311 : t311 = a11 * b6)
    (ht307 : t307 = b10 * a7) (ht308 : t308 = b9 * a8) :
    s17 = ((((((a6 * b11) + (a7 * b10)) + (a8 * b9)) + (a9 * b8)) + (a10 * b7)) + (a11 * b6)) := by
  subst hs17 ht433 ht432 ht310 ht431 ht309 ht430 ht306 ht311 ht307 ht308
  grind

theorem fd_curve25519_scalar_muladd.s19_eq
    {a8 a9 a10 a11 b8 b9 b10 b11 t321 t322 t323 t324 t439 t440 s19 : BitVec 64}
    (hs19 : s19 = t440 + t323) (ht323 : t323 = b9 * a10) (ht440 : t440 = t439 + t322)
    (ht322 : t322 = b10 * a9) (ht439 : t439 = t321 + t324) (ht321 : t321 = b11 * a8)
    (ht324 : t324 = a11 * b8) : s19 = ((((a8 * b11) + (a9 * b10)) + (a10 * b9)) + (a11 * b8)) := by
  subst hs19 ht323 ht440 ht322 ht439 ht321 ht324
  grind

theorem fd_curve25519_scalar_muladd.s18_1_eq {s18 carry18 s18_1 : BitVec 64}
    (hs18_1 : s18_1 = s18 - ((BitVec.sshiftRight (s18 + 1048576#64) 21) <<< 21))
    (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21) :
    s18_1 = (s18 - (carry18 <<< 21)) := by
  rw [← hcarry18] at hs18_1
  clear hcarry18
  subst hs18_1
  grind

theorem fd_curve25519_scalar_muladd.s20_1_eq {s20 carry20 s20_1 : BitVec 64}
    (hs20_1 : s20_1 = s20 - ((BitVec.sshiftRight (s20 + 1048576#64) 21) <<< 21))
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21) :
    s20_1 = (s20 - (carry20 <<< 21)) := by
  rw [← hcarry20] at hs20_1
  clear hcarry20
  subst hs20_1
  grind

theorem fd_curve25519_scalar_muladd.s22_1_eq {s22 carry22 s22_1 : BitVec 64}
    (hs22_1 : s22_1 = s22 - ((BitVec.sshiftRight (s22 + 1048576#64) 21) <<< 21))
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21) :
    s22_1 = (s22 - (carry22 <<< 21)) := by
  rw [← hcarry22] at hs22_1
  clear hcarry22
  subst hs22_1
  grind

theorem fd_curve25519_scalar_muladd.s1_2_eq {s1_1 carry1 s1_2 : BitVec 64}
    (hs1_2 : s1_2 = s1_1 - ((BitVec.sshiftRight (s1_1 + 1048576#64) 21) <<< 21))
    (hcarry1 : carry1 = BitVec.sshiftRight (s1_1 + 1048576#64) 21) :
    s1_2 = (s1_1 - (carry1 <<< 21)) := by
  rw [← hcarry1] at hs1_2
  clear hcarry1
  subst hs1_2
  grind

theorem fd_curve25519_scalar_muladd.carry3_eq {s3_1 t459 carry3 : BitVec 64}
    (hcarry3 : carry3 = BitVec.sshiftRight t459 21) (ht459 : t459 = s3_1 + 1048576#64) :
    carry3 = (BitVec.sshiftRight (s3_1 + 1048576#64) 21) := by
  subst hcarry3 ht459
  rfl

theorem fd_curve25519_scalar_muladd.s3_2_eq {s3_1 t459 carry3 s3_2 : BitVec 64}
    (hs3_2 : s3_2 = s3_1 - ((BitVec.sshiftRight t459 21) <<< 21))
    (hcarry3 : carry3 = BitVec.sshiftRight t459 21) : s3_2 = (s3_1 - (carry3 <<< 21)) := by
  rw [← hcarry3] at hs3_2
  clear hcarry3
  subst hs3_2
  grind

theorem fd_curve25519_scalar_muladd.s5_2_eq {s5_1 carry5 s5_2 : BitVec 64}
    (hs5_2 : s5_2 = s5_1 - ((BitVec.sshiftRight (s5_1 + 1048576#64) 21) <<< 21))
    (hcarry5 : carry5 = BitVec.sshiftRight (s5_1 + 1048576#64) 21) :
    s5_2 = (s5_1 - (carry5 <<< 21)) := by
  rw [← hcarry5] at hs5_2
  clear hcarry5
  subst hs5_2
  grind

theorem fd_curve25519_scalar_muladd.s7_2_eq {s7_1 carry7 s7_2 : BitVec 64}
    (hs7_2 : s7_2 = s7_1 - ((BitVec.sshiftRight (s7_1 + 1048576#64) 21) <<< 21))
    (hcarry7 : carry7 = BitVec.sshiftRight (s7_1 + 1048576#64) 21) :
    s7_2 = (s7_1 - (carry7 <<< 21)) := by
  rw [← hcarry7] at hs7_2
  clear hcarry7
  subst hs7_2
  grind

theorem fd_curve25519_scalar_muladd.s18_2_eq {s18_1 carry17 s18_2 : BitVec 64}
    (hs18_2 : s18_2 = carry17 + s18_1) : s18_2 = (s18_1 + carry17) := by
  subst hs18_2
  grind

theorem fd_curve25519_scalar_muladd.s17_2_eq {s17_1 carry17 s17_2 : BitVec 64}
    (hs17_2 : s17_2 = s17_1 - ((BitVec.sshiftRight (s17_1 + 1048576#64) 21) <<< 21))
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21) :
    s17_2 = (s17_1 - (carry17 <<< 21)) := by
  rw [← hcarry17] at hs17_2
  clear hcarry17
  subst hs17_2
  grind

theorem fd_curve25519_scalar_muladd.s20_2_eq {s20_1 carry19 s20_2 : BitVec 64}
    (hs20_2 : s20_2 = carry19 + s20_1) : s20_2 = (s20_1 + carry19) := by
  subst hs20_2
  grind

theorem fd_curve25519_scalar_muladd.s19_2_eq {s19_1 carry19 s19_2 : BitVec 64}
    (hs19_2 : s19_2 = s19_1 - ((BitVec.sshiftRight (s19_1 + 1048576#64) 21) <<< 21))
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21) :
    s19_2 = (s19_1 - (carry19 <<< 21)) := by
  rw [← hcarry19] at hs19_2
  clear hcarry19
  subst hs19_2
  grind

theorem fd_curve25519_scalar_muladd.s22_2_eq {s22_1 carry21 s22_2 : BitVec 64}
    (hs22_2 : s22_2 = carry21 + s22_1) : s22_2 = (s22_1 + carry21) := by
  subst hs22_2
  grind

theorem fd_curve25519_scalar_muladd.s21_2_eq {s21_1 carry21 s21_2 : BitVec 64}
    (hs21_2 : s21_2 = s21_1 - ((BitVec.sshiftRight (s21_1 + 1048576#64) 21) <<< 21))
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21) :
    s21_2 = (s21_1 - (carry21 <<< 21)) := by
  rw [← hcarry21] at hs21_2
  clear hcarry21
  subst hs21_2
  grind

theorem fd_curve25519_scalar_muladd.s16_3_eq
    {s16 carry16 t436 carry22 carry15 t505 t506 t507 s16_3 : BitVec 64}
    (hs16_3 : s16_3 = t507 + carry15) (ht507 : t507 = t506 - t436) (ht506 : t506 = s16 + t505)
    (ht505 : t505 = carry22 * 18446744073708867715#64)
    (ht436 : t436 = (s16 + 1048576#64) &&& 18446744073707454464#64)
    (hcarry16 : carry16 = BitVec.sshiftRight (s16 + 1048576#64) 21) :
    s16_3 = (((s16 - (carry16 <<< 21)) + carry15) - ((0#64 + carry22) * 683901#64)) := by
  rw [Bnd.and_neg_shift] at ht436
  rw [← hcarry16] at ht436
  clear hcarry16
  subst hs16_3 ht507 ht506 ht505 ht436
  grind

theorem fd_curve25519_scalar_muladd.s14_5_eq
    {s14 carry14 t427 carry22 carry13 s22_2 s21_2 t503 t513 t520 t521 t522 t523 t524 s14_5 :
      BitVec 64}
    (hs14_5 : s14_5 = t524 + carry13) (ht524 : t524 = t523 - t427) (ht523 : t523 = t522 + t520)
    (ht520 : t520 = s21_2 * 18446744073708867715#64) (ht522 : t522 = t521 + t513)
    (ht521 : t521 = s14 + t503) (ht503 : t503 = carry22 * 18446744073708553811#64)
    (ht513 : t513 = s22_2 * 136657#64)
    (ht427 : t427 = (s14 + 1048576#64) &&& 18446744073707454464#64)
    (hcarry14 : carry14 = BitVec.sshiftRight (s14 + 1048576#64) 21) :
    s14_5 =
      (((((s14 - (carry14 <<< 21)) + carry13) - ((0#64 + carry22) * 997805#64)) +
          (s22_2 * 136657#64)) -
        (s21_2 * 683901#64)) := by
  rw [Bnd.and_neg_shift] at ht427
  rw [← hcarry14] at ht427
  clear hcarry14
  subst hs14_5 ht524 ht523 ht520 ht522 ht521 ht503 ht513 ht427
  grind

theorem fd_curve25519_scalar_muladd.s8_3_eq {s8_2 s20_2 t526 s8_3 : BitVec 64}
    (hs8_3 : s8_3 = s8_2 + t526) (ht526 : t526 = s20_2 * 666643#64) :
    s8_3 = (s8_2 + (s20_2 * 666643#64)) := by
  subst hs8_3 ht526
  rfl

theorem fd_curve25519_scalar_muladd.s7_3_eq {s7_2 s19_2 t533 s7_3 : BitVec 64}
    (hs7_3 : s7_3 = s7_2 + t533) (ht533 : t533 = s19_2 * 666643#64) :
    s7_3 = (s7_2 + (s19_2 * 666643#64)) := by
  subst hs7_3 ht533
  rfl

theorem fd_curve25519_scalar_muladd.s8_4_eq {s19_2 s8_3 t535 s8_4 : BitVec 64}
    (hs8_4 : s8_4 = s8_3 + t535) (ht535 : t535 = s19_2 * 470296#64) :
    s8_4 = (s8_3 + (s19_2 * 470296#64)) := by
  subst hs8_4 ht535
  rfl

theorem fd_curve25519_scalar_muladd.s12_7_eq
    {s12 carry12 t416 carry22 carry11 s20_2 s19_2 s22_2 s21_2 t501 t511 t518 t531 t540 t541 t542
      t543 t544 t545 t546 s12_7 : BitVec 64}
    (hs12_7 : s12_7 = t546 + carry11) (ht546 : t546 = t545 - t416) (ht545 : t545 = t544 + t540)
    (ht544 : t544 = t543 + t531) (ht531 : t531 = s20_2 * 136657#64) (ht543 : t543 = t542 + s12)
    (ht542 : t542 = t541 + t518) (ht518 : t518 = s21_2 * 18446744073708553811#64)
    (ht541 : t541 = t511 + t501) (ht511 : t511 = s22_2 * 654183#64)
    (ht501 : t501 = carry22 * 470296#64) (ht540 : t540 = s19_2 * 18446744073708867715#64)
    (ht416 : t416 = (s12 + 1048576#64) &&& 18446744073707454464#64)
    (hcarry12 : carry12 = BitVec.sshiftRight (s12 + 1048576#64) 21) :
    s12_7 =
      (((((((s12 - (carry12 <<< 21)) + carry11) + ((0#64 + carry22) * 470296#64)) +
              (s22_2 * 654183#64)) -
            (s21_2 * 997805#64)) +
          (s20_2 * 136657#64)) -
        (s19_2 * 683901#64)) := by
  rw [Bnd.and_neg_shift] at ht416
  rw [← hcarry12] at ht416
  clear hcarry12
  subst hs12_7 ht546 ht545 ht544 ht531 ht543 ht542 ht518 ht541 ht511 ht501 ht540 ht416
  grind

theorem fd_curve25519_scalar_muladd.s6_2_eq {s6 t361 carry6 t372 carry5 t549 s6_2 : BitVec 64}
    (hs6_2 : s6_2 = t549 - t372) (ht372 : t372 = t361 &&& 18446744073707454464#64)
    (ht549 : t549 = carry5 + s6) (hcarry6 : carry6 = BitVec.sshiftRight t361 21) :
    s6_2 = ((s6 - (carry6 <<< 21)) + carry5) := by
  rw [Bnd.and_neg_shift] at ht372
  rw [← hcarry6] at ht372
  clear hcarry6
  subst hs6_2 ht372 ht549
  grind

theorem fd_curve25519_scalar_muladd.s6_3_eq {s18_2 t548 s6_2 s6_3 : BitVec 64}
    (hs6_3 : s6_3 = s6_2 + t548) (ht548 : t548 = s18_2 * 666643#64) :
    s6_3 = (s6_2 + (s18_2 * 666643#64)) := by
  subst hs6_3 ht548
  rfl

theorem fd_curve25519_scalar_muladd.s7_4_eq {s18_2 s7_3 t552 s7_4 : BitVec 64}
    (hs7_4 : s7_4 = s7_3 + t552) (ht552 : t552 = s18_2 * 470296#64) :
    s7_4 = (s7_3 + (s18_2 * 470296#64)) := by
  subst hs7_4 ht552
  rfl

theorem fd_curve25519_scalar_muladd.s8_5_eq {s18_2 s8_4 t554 s8_5 : BitVec 64}
    (hs8_5 : s8_5 = s8_4 + t554) (ht554 : t554 = s18_2 * 654183#64) :
    s8_5 = (s8_4 + (s18_2 * 654183#64)) := by
  subst hs8_5 ht554
  rfl

theorem fd_curve25519_scalar_muladd.s10_6_eq
    {s10 carry10 t403 carry9 s20_2 s19_2 s22_2 s21_2 t509 t516 t529 t538 t558 t559 t560 t561 t562
      s10_6 : BitVec 64}
    (hs10_6 : s10_6 = t562 + carry9) (ht562 : t562 = t561 - t403) (ht561 : t561 = t560 + t538)
    (ht560 : t560 = t559 + t529) (ht529 : t529 = s20_2 * 654183#64) (ht559 : t559 = t558 + s10)
    (ht558 : t558 = t516 + t509) (ht516 : t516 = s21_2 * 470296#64)
    (ht509 : t509 = s22_2 * 666643#64) (ht538 : t538 = s19_2 * 18446744073708553811#64)
    (ht403 : t403 = (s10 + 1048576#64) &&& 18446744073707454464#64)
    (hcarry10 : carry10 = BitVec.sshiftRight (s10 + 1048576#64) 21) :
    s10_6 =
      ((((((s10 - (carry10 <<< 21)) + carry9) + (s22_2 * 666643#64)) + (s21_2 * 470296#64)) +
          (s20_2 * 654183#64)) -
        (s19_2 * 997805#64)) := by
  rw [Bnd.and_neg_shift] at ht403
  rw [← hcarry10] at ht403
  clear hcarry10
  subst hs10_6 ht562 ht561 ht560 ht529 ht559 ht558 ht516 ht509 ht538 ht403
  grind

theorem fd_curve25519_scalar_muladd.s10_7_eq {s18_2 t557 s10_6 s10_7 : BitVec 64}
    (hs10_7 : s10_7 = s10_6 + t557) (ht557 : t557 = s18_2 * 136657#64) :
    s10_7 = (s10_6 + (s18_2 * 136657#64)) := by
  subst hs10_7 ht557
  rfl

theorem fd_curve25519_scalar_muladd.s6_4_eq {s6_3 carry6_1 s6_4 : BitVec 64}
    (hs6_4 : s6_4 = s6_3 - ((BitVec.sshiftRight (s6_3 + 1048576#64) 21) <<< 21))
    (hcarry6_1 : carry6_1 = BitVec.sshiftRight (s6_3 + 1048576#64) 21) :
    s6_4 = (s6_3 - (carry6_1 <<< 21)) := by
  rw [← hcarry6_1] at hs6_4
  clear hcarry6_1
  subst hs6_4
  grind

theorem fd_curve25519_scalar_muladd.s9_5_eq
    {s9_1 carry9 t475 s20_2 s19_2 s21_2 t515 t528 t537 t573 t574 t575 s9_5 : BitVec 64}
    (hs9_5 : s9_5 = t575 - t475) (ht475 : t475 = (s9_1 + 1048576#64) &&& 18446744073707454464#64)
    (ht575 : t575 = t574 + t537) (ht537 : t537 = s19_2 * 654183#64) (ht574 : t574 = t573 + t528)
    (ht528 : t528 = s20_2 * 470296#64) (ht573 : t573 = s9_1 + t515)
    (ht515 : t515 = s21_2 * 666643#64)
    (hcarry9 : carry9 = BitVec.sshiftRight (s9_1 + 1048576#64) 21) :
    s9_5 =
      ((((s9_1 - (carry9 <<< 21)) + (s21_2 * 666643#64)) + (s20_2 * 470296#64)) +
        (s19_2 * 654183#64)) := by
  rw [Bnd.and_neg_shift] at ht475
  rw [← hcarry9] at ht475
  clear hcarry9
  subst hs9_5 ht475 ht575 ht537 ht574 ht528 ht573 ht515
  grind

theorem fd_curve25519_scalar_muladd.s9_6_eq {s18_2 t556 s9_5 s9_6 : BitVec 64}
    (hs9_6 : s9_6 = s9_5 + t556) (ht556 : t556 = s18_2 * 18446744073708553811#64) :
    s9_6 = (s9_5 - (s18_2 * 997805#64)) := by
  subst hs9_6 ht556
  grind

theorem fd_curve25519_scalar_muladd.s8_6_eq {s8_5 carry8_1 s8_6 : BitVec 64}
    (hs8_6 : s8_6 = s8_5 - ((BitVec.sshiftRight (s8_5 + 1048576#64) 21) <<< 21))
    (hcarry8_1 : carry8_1 = BitVec.sshiftRight (s8_5 + 1048576#64) 21) :
    s8_6 = (s8_5 - (carry8_1 <<< 21)) := by
  rw [← hcarry8_1] at hs8_6
  clear hcarry8_1
  subst hs8_6
  grind

theorem fd_curve25519_scalar_muladd.s11_8_eq
    {s11_1 carry22 carry11 t478 s18_2 s20_2 s19_2 s22_2 s21_2 t500 t510 t517 t530 t539 t565 t583
      t584 t585 t586 t587 t588 s11_8 : BitVec 64}
    (hs11_8 : s11_8 = t588 - t478) (ht588 : t588 = t587 + s11_1) (ht587 : t587 = t586 + t565)
    (ht586 : t586 = t585 + t539) (ht539 : t539 = s19_2 * 136657#64) (ht585 : t585 = t584 + t530)
    (ht584 : t584 = t583 + t517) (ht517 : t517 = s21_2 * 654183#64) (ht583 : t583 = t510 + t500)
    (ht500 : t500 = carry22 * 666643#64) (ht510 : t510 = s22_2 * 470296#64)
    (ht530 : t530 = s20_2 * 18446744073708553811#64)
    (ht565 : t565 = s18_2 * 18446744073708867715#64)
    (ht478 : t478 = (s11_1 + 1048576#64) &&& 18446744073707454464#64)
    (hcarry11 : carry11 = BitVec.sshiftRight (s11_1 + 1048576#64) 21) :
    s11_8 =
      (((((((s11_1 - (carry11 <<< 21)) + ((0#64 + carry22) * 666643#64)) + (s22_2 * 470296#64)) +
              (s21_2 * 654183#64)) -
            (s20_2 * 997805#64)) +
          (s19_2 * 136657#64)) -
        (s18_2 * 683901#64)) := by
  rw [Bnd.and_neg_shift] at ht478
  rw [← hcarry11] at ht478
  clear hcarry11
  subst hs11_8 ht588 ht587 ht586 ht539 ht585 ht584 ht517 ht583 ht500 ht510 ht530 ht565 ht478
  grind

theorem fd_curve25519_scalar_muladd.carry12_1_eq {s12_7 t592 carry12_1 : BitVec 64}
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight t592 21) (ht592 : t592 = s12_7 + 1048576#64) :
    carry12_1 = (BitVec.sshiftRight (s12_7 + 1048576#64) 21) := by
  subst hcarry12_1 ht592
  rfl

theorem fd_curve25519_scalar_muladd.s13_6_eq
    {s13_1 carry22 carry13 t481 s20_2 s22_2 s21_2 t502 t512 t519 t532 t594 t595 t596 t597 s13_6 :
      BitVec 64}
    (hs13_6 : s13_6 = t597 - t481) (ht481 : t481 = (s13_1 + 1048576#64) &&& 18446744073707454464#64)
    (ht597 : t597 = t596 + s13_1) (ht596 : t596 = t595 + t532)
    (ht532 : t532 = s20_2 * 18446744073708867715#64) (ht595 : t595 = t594 + t519)
    (ht519 : t519 = s21_2 * 136657#64) (ht594 : t594 = t512 + t502)
    (ht502 : t502 = carry22 * 654183#64) (ht512 : t512 = s22_2 * 18446744073708553811#64)
    (hcarry13 : carry13 = BitVec.sshiftRight (s13_1 + 1048576#64) 21) :
    s13_6 =
      (((((s13_1 - (carry13 <<< 21)) + ((0#64 + carry22) * 654183#64)) - (s22_2 * 997805#64)) +
          (s21_2 * 136657#64)) -
        (s20_2 * 683901#64)) := by
  rw [Bnd.and_neg_shift] at ht481
  rw [← hcarry13] at ht481
  clear hcarry13
  subst hs13_6 ht481 ht597 ht596 ht532 ht595 ht519 ht594 ht502 ht512
  grind

theorem fd_curve25519_scalar_muladd.s12_8_eq {s12_7 t592 carry12_1 s12_8 : BitVec 64}
    (hs12_8 : s12_8 = s12_7 - ((BitVec.sshiftRight t592 21) <<< 21))
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight t592 21) :
    s12_8 = (s12_7 - (carry12_1 <<< 21)) := by
  rw [← hcarry12_1] at hs12_8
  clear hcarry12_1
  subst hs12_8
  grind

theorem fd_curve25519_scalar_muladd.s15_4_eq
    {s15_1 carry22 carry15 t484 s22_2 t504 t514 t604 t605 s15_4 : BitVec 64}
    (hs15_4 : s15_4 = t605 - t484) (ht484 : t484 = (s15_1 + 1048576#64) &&& 18446744073707454464#64)
    (ht605 : t605 = t604 + s15_1) (ht604 : t604 = t514 + t504)
    (ht514 : t514 = s22_2 * 18446744073708867715#64) (ht504 : t504 = carry22 * 136657#64)
    (hcarry15 : carry15 = BitVec.sshiftRight (s15_1 + 1048576#64) 21) :
    s15_4 =
      (((s15_1 - (carry15 <<< 21)) + ((0#64 + carry22) * 136657#64)) - (s22_2 * 683901#64)) := by
  rw [Bnd.and_neg_shift] at ht484
  rw [← hcarry15] at ht484
  clear hcarry15
  subst hs15_4 ht484 ht605 ht604 ht514 ht504
  grind

theorem fd_curve25519_scalar_muladd.s14_6_eq {s14_5 carry14_1 s14_6 : BitVec 64}
    (hs14_6 : s14_6 = s14_5 - ((BitVec.sshiftRight (s14_5 + 1048576#64) 21) <<< 21))
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21) :
    s14_6 = (s14_5 - (carry14_1 <<< 21)) := by
  rw [← hcarry14_1] at hs14_6
  clear hcarry14_1
  subst hs14_6
  grind

theorem fd_curve25519_scalar_muladd.s17_3_eq {s17_2 carry16_1 s17_3 : BitVec 64}
    (hs17_3 : s17_3 = carry16_1 + s17_2) : s17_3 = (s17_2 + carry16_1) := by
  subst hs17_3
  grind

theorem fd_curve25519_scalar_muladd.s16_4_eq {s16_3 carry16_1 s16_4 : BitVec 64}
    (hs16_4 : s16_4 = s16_3 - ((BitVec.sshiftRight (s16_3 + 1048576#64) 21) <<< 21))
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21) :
    s16_4 = (s16_3 - (carry16_1 <<< 21)) := by
  rw [← hcarry16_1] at hs16_4
  clear hcarry16_1
  subst hs16_4
  grind

theorem fd_curve25519_scalar_muladd.s7_6_eq {s7_5 carry7_1 s7_6 : BitVec 64}
    (hs7_6 : s7_6 = s7_5 - ((BitVec.sshiftRight (s7_5 + 1048576#64) 21) <<< 21))
    (hcarry7_1 : carry7_1 = BitVec.sshiftRight (s7_5 + 1048576#64) 21) :
    s7_6 = (s7_5 - (carry7_1 <<< 21)) := by
  rw [← hcarry7_1] at hs7_6
  clear hcarry7_1
  subst hs7_6
  grind

theorem fd_curve25519_scalar_muladd.s12_9_eq {s12_8 carry11_1 s12_9 : BitVec 64}
    (hs12_9 : s12_9 = carry11_1 + s12_8) : s12_9 = (s12_8 + carry11_1) := by
  subst hs12_9
  grind

theorem fd_curve25519_scalar_muladd.s11_10_eq {s11_9 carry11_1 s11_10 : BitVec 64}
    (hs11_10 : s11_10 = s11_9 - ((BitVec.sshiftRight (s11_9 + 1048576#64) 21) <<< 21))
    (hcarry11_1 : carry11_1 = BitVec.sshiftRight (s11_9 + 1048576#64) 21) :
    s11_10 = (s11_9 - (carry11_1 <<< 21)) := by
  rw [← hcarry11_1] at hs11_10
  clear hcarry11_1
  subst hs11_10
  grind

theorem fd_curve25519_scalar_muladd.s14_7_eq {s14_6 carry13_1 s14_7 : BitVec 64}
    (hs14_7 : s14_7 = carry13_1 + s14_6) : s14_7 = (s14_6 + carry13_1) := by
  subst hs14_7
  grind

theorem fd_curve25519_scalar_muladd.s13_8_eq {s13_7 carry13_1 s13_8 : BitVec 64}
    (hs13_8 : s13_8 = s13_7 - ((BitVec.sshiftRight (s13_7 + 1048576#64) 21) <<< 21))
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21) :
    s13_8 = (s13_7 - (carry13_1 <<< 21)) := by
  rw [← hcarry13_1] at hs13_8
  clear hcarry13_1
  subst hs13_8
  grind

theorem fd_curve25519_scalar_muladd.s16_5_eq {s16_4 carry15_1 s16_5 : BitVec 64}
    (hs16_5 : s16_5 = carry15_1 + s16_4) : s16_5 = (s16_4 + carry15_1) := by
  subst hs16_5
  grind

theorem fd_curve25519_scalar_muladd.s15_6_eq {s15_5 carry15_1 s15_6 : BitVec 64}
    (hs15_6 : s15_6 = s15_5 - ((BitVec.sshiftRight (s15_5 + 1048576#64) 21) <<< 21))
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21) :
    s15_6 = (s15_5 - (carry15_1 <<< 21)) := by
  rw [← hcarry15_1] at hs15_6
  clear hcarry15_1
  subst hs15_6
  grind

theorem fd_curve25519_scalar_muladd.s5_3_eq {s5_2 s17_3 t638 s5_3 : BitVec 64}
    (hs5_3 : s5_3 = s5_2 + t638) (ht638 : t638 = s17_3 * 666643#64) :
    s5_3 = (s5_2 + (s17_3 * 666643#64)) := by
  subst hs5_3 ht638
  rfl

theorem fd_curve25519_scalar_muladd.s6_5_eq {s6_4 s17_3 t640 s6_5 : BitVec 64}
    (hs6_5 : s6_5 = s6_4 + t640) (ht640 : t640 = s17_3 * 470296#64) :
    s6_5 = (s6_4 + (s17_3 * 470296#64)) := by
  subst hs6_5 ht640
  rfl

theorem fd_curve25519_scalar_muladd.s7_7_eq {s17_3 s7_6 t642 s7_7 : BitVec 64}
    (hs7_7 : s7_7 = s7_6 + t642) (ht642 : t642 = s17_3 * 654183#64) :
    s7_7 = (s7_6 + (s17_3 * 654183#64)) := by
  subst hs7_7 ht642
  rfl

theorem fd_curve25519_scalar_muladd.s8_8_eq {s17_3 s8_7 t644 s8_8 : BitVec 64}
    (hs8_8 : s8_8 = s8_7 + t644) (ht644 : t644 = s17_3 * 18446744073708553811#64) :
    s8_8 = (s8_7 - (s17_3 * 997805#64)) := by
  subst hs8_8 ht644
  grind

theorem fd_curve25519_scalar_muladd.s10_10_eq
    {s10_7 carry10_1 t591 s17_3 carry9_1 t647 t648 t649 s10_10 : BitVec 64}
    (hs10_10 : s10_10 = t649 - t591)
    (ht591 : t591 = (s10_7 + 1048576#64) &&& 18446744073707454464#64)
    (ht649 : t649 = t648 + carry9_1) (ht648 : t648 = s10_7 + t647)
    (ht647 : t647 = s17_3 * 18446744073708867715#64)
    (hcarry10_1 : carry10_1 = BitVec.sshiftRight (s10_7 + 1048576#64) 21) :
    s10_10 = (((s10_7 - (carry10_1 <<< 21)) + carry9_1) - (s17_3 * 683901#64)) := by
  rw [Bnd.and_neg_shift] at ht591
  rw [← hcarry10_1] at ht591
  clear hcarry10_1
  subst hs10_10 ht591 ht649 ht648 ht647
  grind

theorem fd_curve25519_scalar_muladd.s4_3_eq {s4_2 s16_5 t651 s4_3 : BitVec 64}
    (hs4_3 : s4_3 = s4_2 + t651) (ht651 : t651 = s16_5 * 666643#64) :
    s4_3 = (s4_2 + (s16_5 * 666643#64)) := by
  subst hs4_3 ht651
  rfl

theorem fd_curve25519_scalar_muladd.s5_4_eq {s16_5 s5_3 t653 s5_4 : BitVec 64}
    (hs5_4 : s5_4 = s5_3 + t653) (ht653 : t653 = s16_5 * 470296#64) :
    s5_4 = (s5_3 + (s16_5 * 470296#64)) := by
  subst hs5_4 ht653
  rfl

theorem fd_curve25519_scalar_muladd.s6_6_eq {s16_5 s6_5 t655 s6_6 : BitVec 64}
    (hs6_6 : s6_6 = s6_5 + t655) (ht655 : t655 = s16_5 * 654183#64) :
    s6_6 = (s6_5 + (s16_5 * 654183#64)) := by
  subst hs6_6 ht655
  rfl

theorem fd_curve25519_scalar_muladd.s7_8_eq {s16_5 s7_7 t657 s7_8 : BitVec 64}
    (hs7_8 : s7_8 = s7_7 + t657) (ht657 : t657 = s16_5 * 18446744073708553811#64) :
    s7_8 = (s7_7 - (s16_5 * 997805#64)) := by
  subst hs7_8 ht657
  grind

theorem fd_curve25519_scalar_muladd.s8_9_eq {s16_5 s8_8 t659 s8_9 : BitVec 64}
    (hs8_9 : s8_9 = s8_8 + t659) (ht659 : t659 = s16_5 * 136657#64) :
    s8_9 = (s8_8 + (s16_5 * 136657#64)) := by
  subst hs8_9 ht659
  rfl

theorem fd_curve25519_scalar_muladd.s3_3_eq {s3_2 s15_6 t662 s3_3 : BitVec 64}
    (hs3_3 : s3_3 = s3_2 + t662) (ht662 : t662 = s15_6 * 666643#64) :
    s3_3 = (s3_2 + (s15_6 * 666643#64)) := by
  subst hs3_3 ht662
  rfl

theorem fd_curve25519_scalar_muladd.s4_4_eq {s15_6 s4_3 t664 s4_4 : BitVec 64}
    (hs4_4 : s4_4 = s4_3 + t664) (ht664 : t664 = s15_6 * 470296#64) :
    s4_4 = (s4_3 + (s15_6 * 470296#64)) := by
  subst hs4_4 ht664
  rfl

theorem fd_curve25519_scalar_muladd.s5_5_eq {s15_6 s5_4 t666 s5_5 : BitVec 64}
    (hs5_5 : s5_5 = s5_4 + t666) (ht666 : t666 = s15_6 * 654183#64) :
    s5_5 = (s5_4 + (s15_6 * 654183#64)) := by
  subst hs5_5 ht666
  rfl

theorem fd_curve25519_scalar_muladd.s6_7_eq {s15_6 s6_6 t668 s6_7 : BitVec 64}
    (hs6_7 : s6_7 = s6_6 + t668) (ht668 : t668 = s15_6 * 18446744073708553811#64) :
    s6_7 = (s6_6 - (s15_6 * 997805#64)) := by
  subst hs6_7 ht668
  grind

theorem fd_curve25519_scalar_muladd.s7_9_eq {s15_6 s7_8 t670 s7_9 : BitVec 64}
    (hs7_9 : s7_9 = s7_8 + t670) (ht670 : t670 = s15_6 * 136657#64) :
    s7_9 = (s7_8 + (s15_6 * 136657#64)) := by
  subst hs7_9 ht670
  rfl

theorem fd_curve25519_scalar_muladd.s8_10_eq {s15_6 s8_9 t672 s8_10 : BitVec 64}
    (hs8_10 : s8_10 = s8_9 + t672) (ht672 : t672 = s15_6 * 18446744073708867715#64) :
    s8_10 = (s8_9 - (s15_6 * 683901#64)) := by
  subst hs8_10 ht672
  grind

theorem fd_curve25519_scalar_muladd.s6_8_eq {s14_7 s6_7 t678 s6_8 : BitVec 64}
    (hs6_8 : s6_8 = s6_7 + t678) (ht678 : t678 = s14_7 * 136657#64) :
    s6_8 = (s6_7 + (s14_7 * 136657#64)) := by
  subst hs6_8 ht678
  rfl

theorem fd_curve25519_scalar_muladd.s7_10_eq {s14_7 s7_9 t680 s7_10 : BitVec 64}
    (hs7_10 : s7_10 = s7_9 + t680) (ht680 : t680 = s14_7 * 18446744073708867715#64) :
    s7_10 = (s7_9 - (s14_7 * 683901#64)) := by
  subst hs7_10 ht680
  grind

theorem fd_curve25519_scalar_muladd.s6_9_eq {s13_8 s6_8 t687 s6_9 : BitVec 64}
    (hs6_9 : s6_9 = s6_8 + t687) (ht687 : t687 = s13_8 * 18446744073708867715#64) :
    s6_9 = (s6_8 - (s13_8 * 683901#64)) := by
  subst hs6_9 ht687
  grind

theorem fd_curve25519_scalar_muladd.s0_2_eq {s0_1 s12_9 t689 s0_2 : BitVec 64}
    (hs0_2 : s0_2 = t689 + s0_1) (ht689 : t689 = s12_9 * 666643#64) :
    s0_2 = (s0_1 + (s12_9 * 666643#64)) := by
  subst hs0_2 ht689
  grind

theorem fd_curve25519_scalar_muladd.s2_5_eq
    {s2_2 s12_9 s14_7 s13_8 t674 t683 t692 t693 t694 s2_5 : BitVec 64} (hs2_5 : s2_5 = t694 + t683)
    (ht694 : t694 = t693 + t674) (ht693 : t693 = s2_2 + t692) (ht692 : t692 = s12_9 * 654183#64)
    (ht674 : t674 = s14_7 * 666643#64) (ht683 : t683 = s13_8 * 470296#64) :
    s2_5 = (((s2_2 + (s14_7 * 666643#64)) + (s13_8 * 470296#64)) + (s12_9 * 654183#64)) := by
  subst hs2_5 ht694 ht693 ht692 ht674 ht683
  grind

theorem fd_curve25519_scalar_muladd.s4_7_eq
    {s12_9 s14_7 s13_8 s4_4 t676 t685 t697 t698 t699 s4_7 : BitVec 64} (hs4_7 : s4_7 = t699 + t685)
    (ht699 : t699 = t698 + t676) (ht698 : t698 = s4_4 + t697) (ht697 : t697 = s12_9 * 136657#64)
    (ht676 : t676 = s14_7 * 654183#64) (ht685 : t685 = s13_8 * 18446744073708553811#64) :
    s4_7 = (((s4_4 + (s14_7 * 654183#64)) - (s13_8 * 997805#64)) + (s12_9 * 136657#64)) := by
  subst hs4_7 ht699 ht698 ht697 ht676 ht685
  grind

theorem fd_curve25519_scalar_muladd.s1_4_eq {s1_2 s12_9 s13_8 t682 t691 t704 s1_4 : BitVec 64}
    (hs1_4 : s1_4 = t704 + t682) (ht682 : t682 = s13_8 * 666643#64) (ht704 : t704 = s1_2 + t691)
    (ht691 : t691 = s12_9 * 470296#64) :
    s1_4 = ((s1_2 + (s13_8 * 666643#64)) + (s12_9 * 470296#64)) := by
  subst hs1_4 ht682 ht704 ht691
  grind

theorem fd_curve25519_scalar_muladd.s0_3_eq {s0_2 carry0_1 s0_3 : BitVec 64}
    (hs0_3 : s0_3 = s0_2 - ((BitVec.sshiftRight (s0_2 + 1048576#64) 21) <<< 21))
    (hcarry0_1 : carry0_1 = BitVec.sshiftRight (s0_2 + 1048576#64) 21) :
    s0_3 = (s0_2 - (carry0_1 <<< 21)) := by
  rw [← hcarry0_1] at hs0_3
  clear hcarry0_1
  subst hs0_3
  grind

theorem fd_curve25519_scalar_muladd.s3_6_eq
    {s12_9 s14_7 s13_8 s3_3 t675 t684 t696 t711 t712 s3_6 : BitVec 64} (hs3_6 : s3_6 = t712 + t684)
    (ht712 : t712 = t711 + t675) (ht675 : t675 = s14_7 * 470296#64) (ht711 : t711 = s3_3 + t696)
    (ht696 : t696 = s12_9 * 18446744073708553811#64) (ht684 : t684 = s13_8 * 654183#64) :
    s3_6 = (((s3_3 + (s14_7 * 470296#64)) + (s13_8 * 654183#64)) - (s12_9 * 997805#64)) := by
  subst hs3_6 ht712 ht675 ht711 ht696 ht684
  grind

theorem fd_curve25519_scalar_muladd.s5_8_eq
    {s12_9 s14_7 s13_8 s5_5 t677 t686 t701 t718 t719 s5_8 : BitVec 64} (hs5_8 : s5_8 = t719 + t686)
    (ht686 : t686 = s13_8 * 136657#64) (ht719 : t719 = t718 + t677) (ht718 : t718 = s5_5 + t701)
    (ht701 : t701 = s12_9 * 18446744073708867715#64)
    (ht677 : t677 = s14_7 * 18446744073708553811#64) :
    s5_8 = (((s5_5 - (s14_7 * 997805#64)) + (s13_8 * 136657#64)) - (s12_9 * 683901#64)) := by
  subst hs5_8 ht686 ht719 ht718 ht701 ht677
  grind

theorem fd_curve25519_scalar_muladd.s6_10_eq {s6_9 carry6_2 s6_10 : BitVec 64}
    (hs6_10 : s6_10 = s6_9 - ((BitVec.sshiftRight (s6_9 + 1048576#64) 21) <<< 21))
    (hcarry6_2 : carry6_2 = BitVec.sshiftRight (s6_9 + 1048576#64) 21) :
    s6_10 = (s6_9 - (carry6_2 <<< 21)) := by
  rw [← hcarry6_2] at hs6_10
  clear hcarry6_2
  subst hs6_10
  grind

theorem fd_curve25519_scalar_muladd.carry8_2_eq {s8_10 t728 carry8_2 : BitVec 64}
    (hcarry8_2 : carry8_2 = BitVec.sshiftRight t728 21) (ht728 : t728 = s8_10 + 1048576#64) :
    carry8_2 = (BitVec.sshiftRight (s8_10 + 1048576#64) 21) := by
  subst hcarry8_2 ht728
  rfl

theorem fd_curve25519_scalar_muladd.s9_9_eq {s9_7 s17_3 carry9_1 t622 t646 t730 s9_9 : BitVec 64}
    (hs9_9 : s9_9 = t730 - t622) (ht622 : t622 = (s9_7 + 1048576#64) &&& 18446744073707454464#64)
    (ht730 : t730 = t646 + s9_7) (ht646 : t646 = s17_3 * 136657#64)
    (hcarry9_1 : carry9_1 = BitVec.sshiftRight (s9_7 + 1048576#64) 21) :
    s9_9 = ((s9_7 - (carry9_1 <<< 21)) + (s17_3 * 136657#64)) := by
  rw [Bnd.and_neg_shift] at ht622
  rw [← hcarry9_1] at ht622
  clear hcarry9_1
  subst hs9_9 ht622 ht730 ht646
  grind

theorem fd_curve25519_scalar_muladd.s9_10_eq {s16_5 t661 s9_9 s9_10 : BitVec 64}
    (hs9_10 : s9_10 = s9_9 + t661) (ht661 : t661 = s16_5 * 18446744073708867715#64) :
    s9_10 = (s9_9 - (s16_5 * 683901#64)) := by
  subst hs9_10 ht661
  grind

theorem fd_curve25519_scalar_muladd.s8_11_eq {s8_10 t728 carry8_2 s8_11 : BitVec 64}
    (hs8_11 : s8_11 = s8_10 - ((BitVec.sshiftRight t728 21) <<< 21))
    (hcarry8_2 : carry8_2 = BitVec.sshiftRight t728 21) : s8_11 = (s8_10 - (carry8_2 <<< 21)) := by
  rw [← hcarry8_2] at hs8_11
  clear hcarry8_2
  subst hs8_11
  grind

theorem fd_curve25519_scalar_muladd.s10_11_eq {s10_10 carry10_2 s10_11 : BitVec 64}
    (hs10_11 : s10_11 = s10_10 - ((BitVec.sshiftRight (s10_10 + 1048576#64) 21) <<< 21))
    (hcarry10_2 : carry10_2 = BitVec.sshiftRight (s10_10 + 1048576#64) 21) :
    s10_11 = (s10_10 - (carry10_2 <<< 21)) := by
  rw [← hcarry10_2] at hs10_11
  clear hcarry10_2
  subst hs10_11
  grind

theorem fd_curve25519_scalar_muladd.s7_12_eq {s7_11 carry7_2 s7_12 : BitVec 64}
    (hs7_12 : s7_12 = s7_11 - ((BitVec.sshiftRight (s7_11 + 1048576#64) 21) <<< 21))
    (hcarry7_2 : carry7_2 = BitVec.sshiftRight (s7_11 + 1048576#64) 21) :
    s7_12 = (s7_11 - (carry7_2 <<< 21)) := by
  rw [← hcarry7_2] at hs7_12
  clear hcarry7_2
  subst hs7_12
  grind

theorem fd_curve25519_scalar_muladd.s9_12_eq {s9_11 carry9_2 s9_12 : BitVec 64}
    (hs9_12 : s9_12 = s9_11 - ((BitVec.sshiftRight (s9_11 + 1048576#64) 21) <<< 21))
    (hcarry9_2 : carry9_2 = BitVec.sshiftRight (s9_11 + 1048576#64) 21) :
    s9_12 = (s9_11 - (carry9_2 <<< 21)) := by
  rw [← hcarry9_2] at hs9_12
  clear hcarry9_2
  subst hs9_12
  grind

theorem fd_curve25519_scalar_muladd.s11_12_eq {s11_11 carry11_2 s11_12 : BitVec 64}
    (hs11_12 : s11_12 = s11_11 - ((BitVec.sshiftRight (s11_11 + 1048576#64) 21) <<< 21))
    (hcarry11_2 : carry11_2 = BitVec.sshiftRight (s11_11 + 1048576#64) 21) :
    s11_12 = (s11_11 - (carry11_2 <<< 21)) := by
  rw [← hcarry11_2] at hs11_12
  clear hcarry11_2
  subst hs11_12
  grind

theorem fd_curve25519_scalar_muladd.s0_4_eq {s0_3 carry11_2 t765 s0_4 : BitVec 64}
    (hs0_4 : s0_4 = s0_3 + t765) (ht765 : t765 = carry11_2 * 666643#64) :
    s0_4 = (s0_3 + ((0#64 + carry11_2) * 666643#64)) := by
  subst hs0_4 ht765
  grind

theorem fd_curve25519_scalar_muladd.s1_7_eq {s1_5 carry1_1 carry11_2 t767 t773 s1_7 : BitVec 64}
    (hs1_7 : s1_7 = t773 - ((BitVec.sshiftRight (s1_5 + 1048576#64) 21) <<< 21))
    (ht773 : t773 = s1_5 + t767) (ht767 : t767 = carry11_2 * 470296#64)
    (hcarry1_1 : carry1_1 = BitVec.sshiftRight (s1_5 + 1048576#64) 21) :
    s1_7 = ((s1_5 - (carry1_1 <<< 21)) + ((0#64 + carry11_2) * 470296#64)) := by
  rw [← hcarry1_1] at hs1_7
  clear hcarry1_1
  subst hs1_7 ht773 ht767
  grind

theorem fd_curve25519_scalar_muladd.s0_5_eq {s0_4 carry0_2 s0_5 : BitVec 64}
    (hs0_5 : s0_5 = s0_4 &&& 2097151#64) (hcarry0_2 : carry0_2 = BitVec.sshiftRight s0_4 21) :
    s0_5 = (s0_4 - (carry0_2 <<< 21)) := by
  subst hs0_5 hcarry0_2
  bv_decide

theorem fd_curve25519_scalar_muladd.s2_8_eq
    {s2_5 carry2_1 t715 carry1_1 carry11_2 t768 t778 t779 s2_8 : BitVec 64}
    (hs2_8 : s2_8 = t779 + carry1_1) (ht779 : t779 = t778 - t715) (ht778 : t778 = s2_5 + t768)
    (ht768 : t768 = carry11_2 * 654183#64)
    (ht715 : t715 = (s2_5 + 1048576#64) &&& 18446744073707454464#64)
    (hcarry2_1 : carry2_1 = BitVec.sshiftRight (s2_5 + 1048576#64) 21) :
    s2_8 = (((s2_5 - (carry2_1 <<< 21)) + carry1_1) + ((0#64 + carry11_2) * 654183#64)) := by
  rw [Bnd.and_neg_shift] at ht715
  rw [← hcarry2_1] at ht715
  clear hcarry2_1
  subst hs2_8 ht779 ht778 ht768 ht715
  grind

theorem fd_curve25519_scalar_muladd.s1_9_eq {s1_8 carry1_2 s1_9 : BitVec 64}
    (hs1_9 : s1_9 = s1_8 &&& 2097151#64) (hcarry1_2 : carry1_2 = BitVec.sshiftRight s1_8 21) :
    s1_9 = (s1_8 - (carry1_2 <<< 21)) := by
  subst hs1_9 hcarry1_2
  bv_decide

theorem fd_curve25519_scalar_muladd.s3_9_eq
    {s3_7 carry3_1 t746 carry11_2 t769 t784 s3_9 : BitVec 64} (hs3_9 : s3_9 = t784 - t746)
    (ht784 : t784 = s3_7 + t769) (ht769 : t769 = carry11_2 * 18446744073708553811#64)
    (ht746 : t746 = (s3_7 + 1048576#64) &&& 18446744073707454464#64)
    (hcarry3_1 : carry3_1 = BitVec.sshiftRight (s3_7 + 1048576#64) 21) :
    s3_9 = ((s3_7 - (carry3_1 <<< 21)) - ((0#64 + carry11_2) * 997805#64)) := by
  rw [Bnd.and_neg_shift] at ht746
  rw [← hcarry3_1] at ht746
  clear hcarry3_1
  subst hs3_9 ht784 ht769 ht746
  grind

theorem fd_curve25519_scalar_muladd.s2_10_eq {s2_9 carry2_2 s2_10 : BitVec 64}
    (hs2_10 : s2_10 = s2_9 &&& 2097151#64) (hcarry2_2 : carry2_2 = BitVec.sshiftRight s2_9 21) :
    s2_10 = (s2_9 - (carry2_2 <<< 21)) := by
  subst hs2_10 hcarry2_2
  bv_decide

theorem fd_curve25519_scalar_muladd.s4_10_eq
    {s4_7 carry4_1 t722 carry3_1 carry11_2 t770 t789 t790 s4_10 : BitVec 64}
    (hs4_10 : s4_10 = t790 + carry3_1) (ht790 : t790 = t789 - t722) (ht789 : t789 = s4_7 + t770)
    (ht770 : t770 = carry11_2 * 136657#64)
    (ht722 : t722 = (s4_7 + 1048576#64) &&& 18446744073707454464#64)
    (hcarry4_1 : carry4_1 = BitVec.sshiftRight (s4_7 + 1048576#64) 21) :
    s4_10 = (((s4_7 - (carry4_1 <<< 21)) + carry3_1) + ((0#64 + carry11_2) * 136657#64)) := by
  rw [Bnd.and_neg_shift] at ht722
  rw [← hcarry4_1] at ht722
  clear hcarry4_1
  subst hs4_10 ht790 ht789 ht770 ht722
  grind

theorem fd_curve25519_scalar_muladd.s3_11_eq {s3_10 carry3_2 s3_11 : BitVec 64}
    (hs3_11 : s3_11 = s3_10 &&& 2097151#64) (hcarry3_2 : carry3_2 = BitVec.sshiftRight s3_10 21) :
    s3_11 = (s3_10 - (carry3_2 <<< 21)) := by
  subst hs3_11 hcarry3_2
  bv_decide

theorem fd_curve25519_scalar_muladd.s5_11_eq
    {s5_9 carry5_1 t750 carry11_2 t771 t795 s5_11 : BitVec 64} (hs5_11 : s5_11 = t795 - t750)
    (ht750 : t750 = (s5_9 + 1048576#64) &&& 18446744073707454464#64) (ht795 : t795 = s5_9 + t771)
    (ht771 : t771 = carry11_2 * 18446744073708867715#64)
    (hcarry5_1 : carry5_1 = BitVec.sshiftRight (s5_9 + 1048576#64) 21) :
    s5_11 = ((s5_9 - (carry5_1 <<< 21)) - ((0#64 + carry11_2) * 683901#64)) := by
  rw [Bnd.and_neg_shift] at ht750
  rw [← hcarry5_1] at ht750
  clear hcarry5_1
  subst hs5_11 ht750 ht795 ht771
  grind

theorem fd_curve25519_scalar_muladd.s4_12_eq {s4_11 carry4_2 s4_12 : BitVec 64}
    (hs4_12 : s4_12 = s4_11 &&& 2097151#64) (hcarry4_2 : carry4_2 = BitVec.sshiftRight s4_11 21) :
    s4_12 = (s4_11 - (carry4_2 <<< 21)) := by
  subst hs4_12 hcarry4_2
  bv_decide

theorem fd_curve25519_scalar_muladd.s5_13_eq {s5_12 carry5_2 s5_13 : BitVec 64}
    (hs5_13 : s5_13 = s5_12 &&& 2097151#64) (hcarry5_2 : carry5_2 = BitVec.sshiftRight s5_12 21) :
    s5_13 = (s5_12 - (carry5_2 <<< 21)) := by
  subst hs5_13 hcarry5_2
  bv_decide

theorem fd_curve25519_scalar_muladd.s7_13_eq {s7_12 carry6_3 s7_13 : BitVec 64}
    (hs7_13 : s7_13 = carry6_3 + s7_12) : s7_13 = (s7_12 + carry6_3) := by
  subst hs7_13
  grind

theorem fd_curve25519_scalar_muladd.s6_13_eq {s6_12 carry6_3 s6_13 : BitVec 64}
    (hs6_13 : s6_13 = s6_12 &&& 2097151#64) (hcarry6_3 : carry6_3 = BitVec.sshiftRight s6_12 21) :
    s6_13 = (s6_12 - (carry6_3 <<< 21)) := by
  subst hs6_13 hcarry6_3
  bv_decide

theorem fd_curve25519_scalar_muladd.s7_14_eq {s7_13 carry7_3 s7_14 : BitVec 64}
    (hs7_14 : s7_14 = s7_13 &&& 2097151#64) (hcarry7_3 : carry7_3 = BitVec.sshiftRight s7_13 21) :
    s7_14 = (s7_13 - (carry7_3 <<< 21)) := by
  subst hs7_14 hcarry7_3
  bv_decide

theorem fd_curve25519_scalar_muladd.s9_13_eq {s9_12 carry8_3 s9_13 : BitVec 64}
    (hs9_13 : s9_13 = carry8_3 + s9_12) : s9_13 = (s9_12 + carry8_3) := by
  subst hs9_13
  grind

theorem fd_curve25519_scalar_muladd.s8_14_eq {s8_13 carry8_3 s8_14 : BitVec 64}
    (hs8_14 : s8_14 = s8_13 &&& 2097151#64) (hcarry8_3 : carry8_3 = BitVec.sshiftRight s8_13 21) :
    s8_14 = (s8_13 - (carry8_3 <<< 21)) := by
  subst hs8_14 hcarry8_3
  bv_decide

theorem fd_curve25519_scalar_muladd.s9_14_eq {s9_13 carry9_3 s9_14 : BitVec 64}
    (hs9_14 : s9_14 = s9_13 &&& 2097151#64) (hcarry9_3 : carry9_3 = BitVec.sshiftRight s9_13 21) :
    s9_14 = (s9_13 - (carry9_3 <<< 21)) := by
  subst hs9_14 hcarry9_3
  bv_decide

theorem fd_curve25519_scalar_muladd.s11_13_eq {s11_12 carry10_3 s11_13 : BitVec 64}
    (hs11_13 : s11_13 = carry10_3 + s11_12) : s11_13 = (s11_12 + carry10_3) := by
  subst hs11_13
  grind

theorem fd_curve25519_scalar_muladd.s10_14_eq {s10_13 carry10_3 s10_14 : BitVec 64}
    (hs10_14 : s10_14 = s10_13 &&& 2097151#64)
    (hcarry10_3 : carry10_3 = BitVec.sshiftRight s10_13 21) :
    s10_14 = (s10_13 - (carry10_3 <<< 21)) := by
  subst hs10_14 hcarry10_3
  bv_decide

theorem fd_curve25519_scalar_muladd.s11_14_eq {s11_13 carry11_3 s11_14 : BitVec 64}
    (hs11_14 : s11_14 = s11_13 &&& 2097151#64)
    (hcarry11_3 : carry11_3 = BitVec.sshiftRight s11_13 21) :
    s11_14 = (s11_13 - (carry11_3 <<< 21)) := by
  subst hs11_14 hcarry11_3
  bv_decide

theorem fd_curve25519_scalar_muladd.s0_6_eq {s0_5 carry11_3 t819 s0_6 : BitVec 64}
    (hs0_6 : s0_6 = t819 + s0_5) (ht819 : t819 = carry11_3 * 666643#64) :
    s0_6 = (s0_5 + ((0#64 + carry11_3) * 666643#64)) := by
  subst hs0_6 ht819
  grind

theorem fd_curve25519_scalar_muladd.s1_10_eq {s1_9 carry11_3 t821 s1_10 : BitVec 64}
    (hs1_10 : s1_10 = t821 + s1_9) (ht821 : t821 = carry11_3 * 470296#64) :
    s1_10 = (s1_9 + ((0#64 + carry11_3) * 470296#64)) := by
  subst hs1_10 ht821
  grind

theorem fd_curve25519_scalar_muladd.s2_11_eq {s2_10 carry11_3 t823 s2_11 : BitVec 64}
    (hs2_11 : s2_11 = t823 + s2_10) (ht823 : t823 = carry11_3 * 654183#64) :
    s2_11 = (s2_10 + ((0#64 + carry11_3) * 654183#64)) := by
  subst hs2_11 ht823
  grind

theorem fd_curve25519_scalar_muladd.s3_12_eq {s3_11 carry11_3 t825 s3_12 : BitVec 64}
    (hs3_12 : s3_12 = t825 + s3_11) (ht825 : t825 = carry11_3 * 18446744073708553811#64) :
    s3_12 = (s3_11 - ((0#64 + carry11_3) * 997805#64)) := by
  subst hs3_12 ht825
  grind

theorem fd_curve25519_scalar_muladd.s4_13_eq {s4_12 carry11_3 t827 s4_13 : BitVec 64}
    (hs4_13 : s4_13 = t827 + s4_12) (ht827 : t827 = carry11_3 * 136657#64) :
    s4_13 = (s4_12 + ((0#64 + carry11_3) * 136657#64)) := by
  subst hs4_13 ht827
  grind

theorem fd_curve25519_scalar_muladd.s5_14_eq {s5_13 carry11_3 t829 s5_14 : BitVec 64}
    (hs5_14 : s5_14 = t829 + s5_13) (ht829 : t829 = carry11_3 * 18446744073708867715#64) :
    s5_14 = (s5_13 - ((0#64 + carry11_3) * 683901#64)) := by
  subst hs5_14 ht829
  grind

theorem fd_curve25519_scalar_muladd.s0_7_eq {s0_6 carry0_3 s0_7 : BitVec 64}
    (hs0_7 : s0_7 = s0_6 &&& 2097151#64) (hcarry0_3 : carry0_3 = BitVec.sshiftRight s0_6 21) :
    s0_7 = (s0_6 - (carry0_3 <<< 21)) := by
  subst hs0_7 hcarry0_3
  bv_decide

theorem fd_curve25519_scalar_muladd.s6_14_eq {s6_13 carry5_3 s6_14 : BitVec 64}
    (hs6_14 : s6_14 = carry5_3 + s6_13) : s6_14 = (s6_13 + carry5_3) := by
  subst hs6_14
  grind

theorem fd_curve25519_scalar_muladd.s7_15_eq {s7_14 carry6_4 s7_15 : BitVec 64}
    (hs7_15 : s7_15 = carry6_4 + s7_14) : s7_15 = (s7_14 + carry6_4) := by
  subst hs7_15
  grind

theorem fd_curve25519_scalar_muladd.s8_15_eq {s8_14 carry7_4 s8_15 : BitVec 64}
    (hs8_15 : s8_15 = carry7_4 + s8_14) : s8_15 = (s8_14 + carry7_4) := by
  subst hs8_15
  grind

theorem fd_curve25519_scalar_muladd.s9_15_eq {s9_14 carry8_4 s9_15 : BitVec 64}
    (hs9_15 : s9_15 = carry8_4 + s9_14) : s9_15 = (s9_14 + carry8_4) := by
  subst hs9_15
  grind

theorem fd_curve25519_scalar_muladd.s10_15_eq {s10_14 carry9_4 s10_15 : BitVec 64}
    (hs10_15 : s10_15 = carry9_4 + s10_14) : s10_15 = (s10_14 + carry9_4) := by
  subst hs10_15
  grind

theorem fd_curve25519_scalar_muladd.out0_eq
    {s1_11 s0_7 carry1_3 s2_12 carry2_3 s3_13 carry3_3 out0 : BitVec 64}
    (hout0 :
      out0 =
        ((((s1_11 <<< 21) &&& 4398044413952#64) ||| s0_7) |||
            ((s2_12 <<< 42) &&& 9223367638808264704#64)) |||
          (s3_13 <<< 63))
    (hcarry1_3 : carry1_3 = BitVec.sshiftRight s1_11 21)
    (hcarry2_3 : carry2_3 = BitVec.sshiftRight s2_12 21)
    (hcarry3_3 : carry3_3 = BitVec.sshiftRight s3_13 21) :
    out0 =
      (((s0_7 ||| ((s1_11 - (carry1_3 <<< 21)) <<< 21)) |||
          ((s2_12 - (carry2_3 <<< 21)) <<< 42)) |||
        ((s3_13 - (carry3_3 <<< 21)) <<< 63)) := by
  subst hout0 hcarry1_3 hcarry2_3 hcarry3_3
  bv_decide

theorem fd_curve25519_scalar_muladd.out1_eq
    {s3_13 carry3_3 s4_14 carry4_3 s5_15 carry5_3 s6_14 carry6_4 out1 : BitVec 64}
    (hout1 :
      out1 =
        ((((s4_14 <<< 20) &&& 2199022206976#64) ||| ((s3_13 >>> 1) &&& 1048575#64)) |||
            ((s5_15 <<< 41) &&& 4611683819404132352#64)) |||
          (s6_14 <<< 62))
    (hcarry3_3 : carry3_3 = BitVec.sshiftRight s3_13 21)
    (hcarry4_3 : carry4_3 = BitVec.sshiftRight s4_14 21)
    (hcarry5_3 : carry5_3 = BitVec.sshiftRight s5_15 21)
    (hcarry6_4 : carry6_4 = BitVec.sshiftRight s6_14 21) :
    out1 =
      (((((s3_13 - (carry3_3 <<< 21)) >>> 1) ||| ((s4_14 - (carry4_3 <<< 21)) <<< 20)) |||
          ((s5_15 - (carry5_3 <<< 21)) <<< 41)) |||
        ((s6_14 - (carry6_4 <<< 21)) <<< 62)) := by
  subst hout1 hcarry3_3 hcarry4_3 hcarry5_3 hcarry6_4
  bv_decide

theorem fd_curve25519_scalar_muladd.out2_eq
    {s6_14 carry6_4 s7_15 carry7_4 s8_15 carry8_4 s9_15 carry9_4 out2 : BitVec 64}
    (hout2 :
      out2 =
        ((((s7_15 <<< 19) &&& 1099511103488#64) ||| ((s6_14 >>> 2) &&& 524287#64)) |||
            ((s8_15 <<< 40) &&& 2305841909702066176#64)) |||
          (s9_15 <<< 61))
    (hcarry6_4 : carry6_4 = BitVec.sshiftRight s6_14 21)
    (hcarry7_4 : carry7_4 = BitVec.sshiftRight s7_15 21)
    (hcarry8_4 : carry8_4 = BitVec.sshiftRight s8_15 21)
    (hcarry9_4 : carry9_4 = BitVec.sshiftRight s9_15 21) :
    out2 =
      (((((s6_14 - (carry6_4 <<< 21)) >>> 2) ||| ((s7_15 - (carry7_4 <<< 21)) <<< 19)) |||
          ((s8_15 - (carry8_4 <<< 21)) <<< 40)) |||
        ((s9_15 - (carry9_4 <<< 21)) <<< 61)) := by
  subst hout2 hcarry6_4 hcarry7_4 hcarry8_4 hcarry9_4
  bv_decide

theorem fd_curve25519_scalar_muladd.out3_eq
    {s11_14 s9_15 carry9_4 s10_15 t852 t853 out3 : BitVec 64}
    (hout3 :
      out3 =
        (((s9_15 >>> 3) &&& 262143#64) ||| ((s10_15 <<< 18) &&& 549755551744#64)) ||| (t853 <<< 39))
    (ht853 : t853 = t852 + s11_14) (ht852 : t852 = s10_15 >>> 21)
    (hcarry9_4 : carry9_4 = BitVec.sshiftRight s9_15 21) :
    out3 =
      ((((s9_15 - (carry9_4 <<< 21)) >>> 3) |||
          ((s10_15 - ((BitVec.sshiftRight s10_15 21) <<< 21)) <<< 18)) |||
        ((s11_14 + (BitVec.sshiftRight s10_15 21)) <<< 39)) := by
  subst hout3 ht853 ht852 hcarry9_4
  bv_decide

/-- The stored words are `spec`, the C's lets expanded over the compiled values. -/
theorem fd_curve25519_scalar_muladd.spec_eq {A B C : BitVec 256}
    {ia0 ib0 ic0 ia1 ib1 ic1 ia2 ib2 ic2 ia3 ib3 ic3 a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 b0 b1 b2
      b3 b4 b5 b6 b7 b8 b9 b10 b11 c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 s0 s2 s4 s6 s8 s10 s12 s14
      s16 s18 s20 s21 s22 carry0 s1 s1_1 s0_1 carry2 s3 s3_1 s2_1 carry4 s5 s5_1 s4_1 carry6 s7 s7_1
      carry8 s9 s9_1 s8_1 carry10 s11 s11_1 carry12 s13 s13_1 carry14 s15 s15_1 carry16 s17 s17_1
      carry18 s19 s19_1 s18_1 carry20 s21_1 s20_1 carry22 s22_1 carry1 s2_2 s1_2 carry3 s4_2 s3_2
      carry5 s5_2 carry7 s8_2 s7_2 carry9 carry11 carry13 carry15 carry17 s18_2 s17_2 carry19 s20_2
      s19_2 carry21 s22_2 s21_2 s16_3 s14_5 s8_3 s7_3 s8_4 s12_7 s6_2 s6_3 s7_4 s8_5 s10_6 s10_7
      carry6_1 s7_5 s6_4 carry8_1 s9_5 s9_6 s9_7 s8_6 carry10_1 s11_8 s11_9 carry12_1 s13_6 s13_7
      s12_8 carry14_1 s15_4 s15_5 s14_6 carry16_1 s17_3 s16_4 carry7_1 s8_7 s7_6 carry9_1 carry11_1
      s12_9 s11_10 carry13_1 s14_7 s13_8 carry15_1 s16_5 s15_6 s5_3 s6_5 s7_7 s8_8 s10_10 s4_3 s5_4
      s6_6 s7_8 s8_9 s3_3 s4_4 s5_5 s6_7 s7_9 s8_10 s6_8 s7_10 s6_9 s0_2 s2_5 s4_7 carry0_1 s1_4
      s1_5 s0_3 carry2_1 s3_6 s3_7 carry4_1 s5_8 s5_9 carry6_2 s7_11 s6_10 carry8_2 s9_9 s9_10 s9_11
      s8_11 carry10_2 s11_11 s10_11 carry1_1 carry3_1 carry5_1 s6_11 carry7_2 s8_12 s7_12 carry9_2
      s10_12 s9_12 carry11_2 s11_12 s0_4 carry0_2 s1_7 s1_8 s0_5 carry1_2 s2_8 s2_9 s1_9 carry2_2
      s3_9 s3_10 s2_10 carry3_2 s4_10 s4_11 s3_11 carry4_2 s5_11 s5_12 s4_12 carry5_2 s6_12 s5_13
      carry6_3 s7_13 s6_13 carry7_3 s8_13 s7_14 carry8_3 s9_13 s8_14 carry9_3 s10_13 s9_14 carry10_3
      s11_13 s10_14 carry11_3 s11_14 s0_6 s1_10 s2_11 s3_12 s4_13 s5_14 carry0_3 s1_11 s0_7 carry1_3
      s2_12 carry2_3 s3_13 carry3_3 s4_14 carry4_3 s5_15 carry5_3 s6_14 carry6_4 s7_15 carry7_4
      s8_15 carry8_4 s9_15 carry9_4 s10_15 out0 out1 out2 out3 : BitVec 64}
    (hia0 : ia0 = A.extractLsb' 0 64) (hib0 : ib0 = B.extractLsb' 0 64)
    (hic0 : ic0 = C.extractLsb' 0 64) (hia1 : ia1 = A.extractLsb' 64 64)
    (hib1 : ib1 = B.extractLsb' 64 64) (hic1 : ic1 = C.extractLsb' 64 64)
    (hia2 : ia2 = A.extractLsb' 128 64) (hib2 : ib2 = B.extractLsb' 128 64)
    (hic2 : ic2 = C.extractLsb' 128 64) (hia3 : ia3 = A.extractLsb' 192 64)
    (hib3 : ib3 = B.extractLsb' 192 64) (hic3 : ic3 = C.extractLsb' 192 64)
    (ha0 : a0 = ia0 &&& 2097151#64) (ha1 : a1 = (ia0 >>> 21) &&& 2097151#64)
    (ha2 : a2 = (ia0 >>> 42) &&& 2097151#64)
    (ha3 : a3 = ((ia0 >>> 63) ||| (ia1 <<< 1)) &&& 2097151#64)
    (ha4 : a4 = (ia1 >>> 20) &&& 2097151#64) (ha5 : a5 = (ia1 >>> 41) &&& 2097151#64)
    (ha6 : a6 = ((ia1 >>> 62) ||| (ia2 <<< 2)) &&& 2097151#64)
    (ha7 : a7 = (ia2 >>> 19) &&& 2097151#64) (ha8 : a8 = (ia2 >>> 40) &&& 2097151#64)
    (ha9 : a9 = ((ia2 >>> 61) ||| (ia3 <<< 3)) &&& 2097151#64)
    (ha10 : a10 = (ia3 >>> 18) &&& 2097151#64) (ha11 : a11 = ia3 >>> 39)
    (hb0 : b0 = ib0 &&& 2097151#64) (hb1 : b1 = (ib0 >>> 21) &&& 2097151#64)
    (hb2 : b2 = (ib0 >>> 42) &&& 2097151#64)
    (hb3 : b3 = ((ib0 >>> 63) ||| (ib1 <<< 1)) &&& 2097151#64)
    (hb4 : b4 = (ib1 >>> 20) &&& 2097151#64) (hb5 : b5 = (ib1 >>> 41) &&& 2097151#64)
    (hb6 : b6 = ((ib1 >>> 62) ||| (ib2 <<< 2)) &&& 2097151#64)
    (hb7 : b7 = (ib2 >>> 19) &&& 2097151#64) (hb8 : b8 = (ib2 >>> 40) &&& 2097151#64)
    (hb9 : b9 = ((ib2 >>> 61) ||| (ib3 <<< 3)) &&& 2097151#64)
    (hb10 : b10 = (ib3 >>> 18) &&& 2097151#64) (hb11 : b11 = ib3 >>> 39)
    (hc0 : c0 = ic0 &&& 2097151#64) (hc1 : c1 = (ic0 >>> 21) &&& 2097151#64)
    (hc2 : c2 = (ic0 >>> 42) &&& 2097151#64)
    (hc3 : c3 = ((ic0 >>> 63) ||| (ic1 <<< 1)) &&& 2097151#64)
    (hc4 : c4 = (ic1 >>> 20) &&& 2097151#64) (hc5 : c5 = (ic1 >>> 41) &&& 2097151#64)
    (hc6 : c6 = ((ic1 >>> 62) ||| (ic2 <<< 2)) &&& 2097151#64)
    (hc7 : c7 = (ic2 >>> 19) &&& 2097151#64) (hc8 : c8 = (ic2 >>> 40) &&& 2097151#64)
    (hc9 : c9 = ((ic2 >>> 61) ||| (ic3 <<< 3)) &&& 2097151#64)
    (hc10 : c10 = (ic3 >>> 18) &&& 2097151#64) (hc11 : c11 = ic3 >>> 39) (hs0 : s0 = c0 + (a0 * b0))
    (hs2 : s2 = ((c2 + (a0 * b2)) + (a1 * b1)) + (a2 * b0))
    (hs4 : s4 = ((((c4 + (a0 * b4)) + (a1 * b3)) + (a2 * b2)) + (a3 * b1)) + (a4 * b0))
    (hs6 :
      s6 =
        ((((((c6 + (a0 * b6)) + (a1 * b5)) + (a2 * b4)) + (a3 * b3)) + (a4 * b2)) + (a5 * b1)) +
          (a6 * b0))
    (hs8 :
      s8 =
        ((((((((c8 + (a0 * b8)) + (a1 * b7)) + (a2 * b6)) + (a3 * b5)) + (a4 * b4)) + (a5 * b3)) +
              (a6 * b2)) +
            (a7 * b1)) +
          (a8 * b0))
    (hs10 :
      s10 =
        ((((((((((c10 + (a0 * b10)) + (a1 * b9)) + (a2 * b8)) + (a3 * b7)) + (a4 * b6)) +
                    (a5 * b5)) +
                  (a6 * b4)) +
                (a7 * b3)) +
              (a8 * b2)) +
            (a9 * b1)) +
          (a10 * b0))
    (hs12 :
      s12 =
        ((((((((((a1 * b11) + (a2 * b10)) + (a3 * b9)) + (a4 * b8)) + (a5 * b7)) + (a6 * b6)) +
                  (a7 * b5)) +
                (a8 * b4)) +
              (a9 * b3)) +
            (a10 * b2)) +
          (a11 * b1))
    (hs14 :
      s14 =
        ((((((((a3 * b11) + (a4 * b10)) + (a5 * b9)) + (a6 * b8)) + (a7 * b7)) + (a8 * b6)) +
              (a9 * b5)) +
            (a10 * b4)) +
          (a11 * b3))
    (hs16 :
      s16 =
        ((((((a5 * b11) + (a6 * b10)) + (a7 * b9)) + (a8 * b8)) + (a9 * b7)) + (a10 * b6)) +
          (a11 * b5))
    (hs18 : s18 = ((((a7 * b11) + (a8 * b10)) + (a9 * b9)) + (a10 * b8)) + (a11 * b7))
    (hs20 : s20 = ((a9 * b11) + (a10 * b10)) + (a11 * b9)) (hs21 : s21 = (a10 * b11) + (a11 * b10))
    (hs22 : s22 = a11 * b11) (hcarry0 : carry0 = BitVec.sshiftRight (s0 + 1048576#64) 21)
    (hs1 : s1 = (c1 + (a0 * b1)) + (a1 * b0)) (hs1_1 : s1_1 = s1 + carry0)
    (hs0_1 : s0_1 = s0 - (carry0 <<< 21))
    (hcarry2 : carry2 = BitVec.sshiftRight (s2 + 1048576#64) 21)
    (hs3 : s3 = (((c3 + (a0 * b3)) + (a1 * b2)) + (a2 * b1)) + (a3 * b0))
    (hs3_1 : s3_1 = s3 + carry2) (hs2_1 : s2_1 = s2 - (carry2 <<< 21))
    (hcarry4 : carry4 = BitVec.sshiftRight (s4 + 1048576#64) 21)
    (hs5 :
      s5 = (((((c5 + (a0 * b5)) + (a1 * b4)) + (a2 * b3)) + (a3 * b2)) + (a4 * b1)) + (a5 * b0))
    (hs5_1 : s5_1 = s5 + carry4) (hs4_1 : s4_1 = s4 - (carry4 <<< 21))
    (hcarry6 : carry6 = BitVec.sshiftRight (s6 + 1048576#64) 21)
    (hs7 :
      s7 =
        (((((((c7 + (a0 * b7)) + (a1 * b6)) + (a2 * b5)) + (a3 * b4)) + (a4 * b3)) + (a5 * b2)) +
            (a6 * b1)) +
          (a7 * b0))
    (hs7_1 : s7_1 = s7 + carry6) (hcarry8 : carry8 = BitVec.sshiftRight (s8 + 1048576#64) 21)
    (hs9 :
      s9 =
        (((((((((c9 + (a0 * b9)) + (a1 * b8)) + (a2 * b7)) + (a3 * b6)) + (a4 * b5)) + (a5 * b4)) +
                (a6 * b3)) +
              (a7 * b2)) +
            (a8 * b1)) +
          (a9 * b0))
    (hs9_1 : s9_1 = s9 + carry8) (hs8_1 : s8_1 = s8 - (carry8 <<< 21))
    (hcarry10 : carry10 = BitVec.sshiftRight (s10 + 1048576#64) 21)
    (hs11 :
      s11 =
        (((((((((((c11 + (a0 * b11)) + (a1 * b10)) + (a2 * b9)) + (a3 * b8)) + (a4 * b7)) +
                      (a5 * b6)) +
                    (a6 * b5)) +
                  (a7 * b4)) +
                (a8 * b3)) +
              (a9 * b2)) +
            (a10 * b1)) +
          (a11 * b0))
    (hs11_1 : s11_1 = s11 + carry10) (hcarry12 : carry12 = BitVec.sshiftRight (s12 + 1048576#64) 21)
    (hs13 :
      s13 =
        (((((((((a2 * b11) + (a3 * b10)) + (a4 * b9)) + (a5 * b8)) + (a6 * b7)) + (a7 * b6)) +
                (a8 * b5)) +
              (a9 * b4)) +
            (a10 * b3)) +
          (a11 * b2))
    (hs13_1 : s13_1 = s13 + carry12) (hcarry14 : carry14 = BitVec.sshiftRight (s14 + 1048576#64) 21)
    (hs15 :
      s15 =
        (((((((a4 * b11) + (a5 * b10)) + (a6 * b9)) + (a7 * b8)) + (a8 * b7)) + (a9 * b6)) +
            (a10 * b5)) +
          (a11 * b4))
    (hs15_1 : s15_1 = s15 + carry14) (hcarry16 : carry16 = BitVec.sshiftRight (s16 + 1048576#64) 21)
    (hs17 : s17 = (((((a6 * b11) + (a7 * b10)) + (a8 * b9)) + (a9 * b8)) + (a10 * b7)) + (a11 * b6))
    (hs17_1 : s17_1 = s17 + carry16) (hcarry18 : carry18 = BitVec.sshiftRight (s18 + 1048576#64) 21)
    (hs19 : s19 = (((a8 * b11) + (a9 * b10)) + (a10 * b9)) + (a11 * b8))
    (hs19_1 : s19_1 = s19 + carry18) (hs18_1 : s18_1 = s18 - (carry18 <<< 21))
    (hcarry20 : carry20 = BitVec.sshiftRight (s20 + 1048576#64) 21) (hs21_1 : s21_1 = s21 + carry20)
    (hs20_1 : s20_1 = s20 - (carry20 <<< 21))
    (hcarry22 : carry22 = BitVec.sshiftRight (s22 + 1048576#64) 21)
    (hs22_1 : s22_1 = s22 - (carry22 <<< 21))
    (hcarry1 : carry1 = BitVec.sshiftRight (s1_1 + 1048576#64) 21) (hs2_2 : s2_2 = s2_1 + carry1)
    (hs1_2 : s1_2 = s1_1 - (carry1 <<< 21))
    (hcarry3 : carry3 = BitVec.sshiftRight (s3_1 + 1048576#64) 21) (hs4_2 : s4_2 = s4_1 + carry3)
    (hs3_2 : s3_2 = s3_1 - (carry3 <<< 21))
    (hcarry5 : carry5 = BitVec.sshiftRight (s5_1 + 1048576#64) 21)
    (hs5_2 : s5_2 = s5_1 - (carry5 <<< 21))
    (hcarry7 : carry7 = BitVec.sshiftRight (s7_1 + 1048576#64) 21) (hs8_2 : s8_2 = s8_1 + carry7)
    (hs7_2 : s7_2 = s7_1 - (carry7 <<< 21))
    (hcarry9 : carry9 = BitVec.sshiftRight (s9_1 + 1048576#64) 21)
    (hcarry11 : carry11 = BitVec.sshiftRight (s11_1 + 1048576#64) 21)
    (hcarry13 : carry13 = BitVec.sshiftRight (s13_1 + 1048576#64) 21)
    (hcarry15 : carry15 = BitVec.sshiftRight (s15_1 + 1048576#64) 21)
    (hcarry17 : carry17 = BitVec.sshiftRight (s17_1 + 1048576#64) 21)
    (hs18_2 : s18_2 = s18_1 + carry17) (hs17_2 : s17_2 = s17_1 - (carry17 <<< 21))
    (hcarry19 : carry19 = BitVec.sshiftRight (s19_1 + 1048576#64) 21)
    (hs20_2 : s20_2 = s20_1 + carry19) (hs19_2 : s19_2 = s19_1 - (carry19 <<< 21))
    (hcarry21 : carry21 = BitVec.sshiftRight (s21_1 + 1048576#64) 21)
    (hs22_2 : s22_2 = s22_1 + carry21) (hs21_2 : s21_2 = s21_1 - (carry21 <<< 21))
    (hs16_3 : s16_3 = ((s16 - (carry16 <<< 21)) + carry15) - ((0#64 + carry22) * 683901#64))
    (hs14_5 :
      s14_5 =
        ((((s14 - (carry14 <<< 21)) + carry13) - ((0#64 + carry22) * 997805#64)) +
            (s22_2 * 136657#64)) -
          (s21_2 * 683901#64))
    (hs8_3 : s8_3 = s8_2 + (s20_2 * 666643#64)) (hs7_3 : s7_3 = s7_2 + (s19_2 * 666643#64))
    (hs8_4 : s8_4 = s8_3 + (s19_2 * 470296#64))
    (hs12_7 :
      s12_7 =
        ((((((s12 - (carry12 <<< 21)) + carry11) + ((0#64 + carry22) * 470296#64)) +
                (s22_2 * 654183#64)) -
              (s21_2 * 997805#64)) +
            (s20_2 * 136657#64)) -
          (s19_2 * 683901#64))
    (hs6_2 : s6_2 = (s6 - (carry6 <<< 21)) + carry5) (hs6_3 : s6_3 = s6_2 + (s18_2 * 666643#64))
    (hs7_4 : s7_4 = s7_3 + (s18_2 * 470296#64)) (hs8_5 : s8_5 = s8_4 + (s18_2 * 654183#64))
    (hs10_6 :
      s10_6 =
        (((((s10 - (carry10 <<< 21)) + carry9) + (s22_2 * 666643#64)) + (s21_2 * 470296#64)) +
            (s20_2 * 654183#64)) -
          (s19_2 * 997805#64))
    (hs10_7 : s10_7 = s10_6 + (s18_2 * 136657#64))
    (hcarry6_1 : carry6_1 = BitVec.sshiftRight (s6_3 + 1048576#64) 21)
    (hs7_5 : s7_5 = s7_4 + carry6_1) (hs6_4 : s6_4 = s6_3 - (carry6_1 <<< 21))
    (hcarry8_1 : carry8_1 = BitVec.sshiftRight (s8_5 + 1048576#64) 21)
    (hs9_5 :
      s9_5 =
        (((s9_1 - (carry9 <<< 21)) + (s21_2 * 666643#64)) + (s20_2 * 470296#64)) +
          (s19_2 * 654183#64))
    (hs9_6 : s9_6 = s9_5 - (s18_2 * 997805#64)) (hs9_7 : s9_7 = s9_6 + carry8_1)
    (hs8_6 : s8_6 = s8_5 - (carry8_1 <<< 21))
    (hcarry10_1 : carry10_1 = BitVec.sshiftRight (s10_7 + 1048576#64) 21)
    (hs11_8 :
      s11_8 =
        ((((((s11_1 - (carry11 <<< 21)) + ((0#64 + carry22) * 666643#64)) + (s22_2 * 470296#64)) +
                (s21_2 * 654183#64)) -
              (s20_2 * 997805#64)) +
            (s19_2 * 136657#64)) -
          (s18_2 * 683901#64))
    (hs11_9 : s11_9 = s11_8 + carry10_1)
    (hcarry12_1 : carry12_1 = BitVec.sshiftRight (s12_7 + 1048576#64) 21)
    (hs13_6 :
      s13_6 =
        ((((s13_1 - (carry13 <<< 21)) + ((0#64 + carry22) * 654183#64)) - (s22_2 * 997805#64)) +
            (s21_2 * 136657#64)) -
          (s20_2 * 683901#64))
    (hs13_7 : s13_7 = s13_6 + carry12_1) (hs12_8 : s12_8 = s12_7 - (carry12_1 <<< 21))
    (hcarry14_1 : carry14_1 = BitVec.sshiftRight (s14_5 + 1048576#64) 21)
    (hs15_4 :
      s15_4 = ((s15_1 - (carry15 <<< 21)) + ((0#64 + carry22) * 136657#64)) - (s22_2 * 683901#64))
    (hs15_5 : s15_5 = s15_4 + carry14_1) (hs14_6 : s14_6 = s14_5 - (carry14_1 <<< 21))
    (hcarry16_1 : carry16_1 = BitVec.sshiftRight (s16_3 + 1048576#64) 21)
    (hs17_3 : s17_3 = s17_2 + carry16_1) (hs16_4 : s16_4 = s16_3 - (carry16_1 <<< 21))
    (hcarry7_1 : carry7_1 = BitVec.sshiftRight (s7_5 + 1048576#64) 21)
    (hs8_7 : s8_7 = s8_6 + carry7_1) (hs7_6 : s7_6 = s7_5 - (carry7_1 <<< 21))
    (hcarry9_1 : carry9_1 = BitVec.sshiftRight (s9_7 + 1048576#64) 21)
    (hcarry11_1 : carry11_1 = BitVec.sshiftRight (s11_9 + 1048576#64) 21)
    (hs12_9 : s12_9 = s12_8 + carry11_1) (hs11_10 : s11_10 = s11_9 - (carry11_1 <<< 21))
    (hcarry13_1 : carry13_1 = BitVec.sshiftRight (s13_7 + 1048576#64) 21)
    (hs14_7 : s14_7 = s14_6 + carry13_1) (hs13_8 : s13_8 = s13_7 - (carry13_1 <<< 21))
    (hcarry15_1 : carry15_1 = BitVec.sshiftRight (s15_5 + 1048576#64) 21)
    (hs16_5 : s16_5 = s16_4 + carry15_1) (hs15_6 : s15_6 = s15_5 - (carry15_1 <<< 21))
    (hs5_3 : s5_3 = s5_2 + (s17_3 * 666643#64)) (hs6_5 : s6_5 = s6_4 + (s17_3 * 470296#64))
    (hs7_7 : s7_7 = s7_6 + (s17_3 * 654183#64)) (hs8_8 : s8_8 = s8_7 - (s17_3 * 997805#64))
    (hs10_10 : s10_10 = ((s10_7 - (carry10_1 <<< 21)) + carry9_1) - (s17_3 * 683901#64))
    (hs4_3 : s4_3 = s4_2 + (s16_5 * 666643#64)) (hs5_4 : s5_4 = s5_3 + (s16_5 * 470296#64))
    (hs6_6 : s6_6 = s6_5 + (s16_5 * 654183#64)) (hs7_8 : s7_8 = s7_7 - (s16_5 * 997805#64))
    (hs8_9 : s8_9 = s8_8 + (s16_5 * 136657#64)) (hs3_3 : s3_3 = s3_2 + (s15_6 * 666643#64))
    (hs4_4 : s4_4 = s4_3 + (s15_6 * 470296#64)) (hs5_5 : s5_5 = s5_4 + (s15_6 * 654183#64))
    (hs6_7 : s6_7 = s6_6 - (s15_6 * 997805#64)) (hs7_9 : s7_9 = s7_8 + (s15_6 * 136657#64))
    (hs8_10 : s8_10 = s8_9 - (s15_6 * 683901#64)) (hs6_8 : s6_8 = s6_7 + (s14_7 * 136657#64))
    (hs7_10 : s7_10 = s7_9 - (s14_7 * 683901#64)) (hs6_9 : s6_9 = s6_8 - (s13_8 * 683901#64))
    (hs0_2 : s0_2 = s0_1 + (s12_9 * 666643#64))
    (hs2_5 : s2_5 = ((s2_2 + (s14_7 * 666643#64)) + (s13_8 * 470296#64)) + (s12_9 * 654183#64))
    (hs4_7 : s4_7 = ((s4_4 + (s14_7 * 654183#64)) - (s13_8 * 997805#64)) + (s12_9 * 136657#64))
    (hcarry0_1 : carry0_1 = BitVec.sshiftRight (s0_2 + 1048576#64) 21)
    (hs1_4 : s1_4 = (s1_2 + (s13_8 * 666643#64)) + (s12_9 * 470296#64))
    (hs1_5 : s1_5 = s1_4 + carry0_1) (hs0_3 : s0_3 = s0_2 - (carry0_1 <<< 21))
    (hcarry2_1 : carry2_1 = BitVec.sshiftRight (s2_5 + 1048576#64) 21)
    (hs3_6 : s3_6 = ((s3_3 + (s14_7 * 470296#64)) + (s13_8 * 654183#64)) - (s12_9 * 997805#64))
    (hs3_7 : s3_7 = s3_6 + carry2_1)
    (hcarry4_1 : carry4_1 = BitVec.sshiftRight (s4_7 + 1048576#64) 21)
    (hs5_8 : s5_8 = ((s5_5 - (s14_7 * 997805#64)) + (s13_8 * 136657#64)) - (s12_9 * 683901#64))
    (hs5_9 : s5_9 = s5_8 + carry4_1)
    (hcarry6_2 : carry6_2 = BitVec.sshiftRight (s6_9 + 1048576#64) 21)
    (hs7_11 : s7_11 = s7_10 + carry6_2) (hs6_10 : s6_10 = s6_9 - (carry6_2 <<< 21))
    (hcarry8_2 : carry8_2 = BitVec.sshiftRight (s8_10 + 1048576#64) 21)
    (hs9_9 : s9_9 = (s9_7 - (carry9_1 <<< 21)) + (s17_3 * 136657#64))
    (hs9_10 : s9_10 = s9_9 - (s16_5 * 683901#64)) (hs9_11 : s9_11 = s9_10 + carry8_2)
    (hs8_11 : s8_11 = s8_10 - (carry8_2 <<< 21))
    (hcarry10_2 : carry10_2 = BitVec.sshiftRight (s10_10 + 1048576#64) 21)
    (hs11_11 : s11_11 = s11_10 + carry10_2) (hs10_11 : s10_11 = s10_10 - (carry10_2 <<< 21))
    (hcarry1_1 : carry1_1 = BitVec.sshiftRight (s1_5 + 1048576#64) 21)
    (hcarry3_1 : carry3_1 = BitVec.sshiftRight (s3_7 + 1048576#64) 21)
    (hcarry5_1 : carry5_1 = BitVec.sshiftRight (s5_9 + 1048576#64) 21)
    (hs6_11 : s6_11 = s6_10 + carry5_1)
    (hcarry7_2 : carry7_2 = BitVec.sshiftRight (s7_11 + 1048576#64) 21)
    (hs8_12 : s8_12 = s8_11 + carry7_2) (hs7_12 : s7_12 = s7_11 - (carry7_2 <<< 21))
    (hcarry9_2 : carry9_2 = BitVec.sshiftRight (s9_11 + 1048576#64) 21)
    (hs10_12 : s10_12 = s10_11 + carry9_2) (hs9_12 : s9_12 = s9_11 - (carry9_2 <<< 21))
    (hcarry11_2 : carry11_2 = BitVec.sshiftRight (s11_11 + 1048576#64) 21)
    (hs11_12 : s11_12 = s11_11 - (carry11_2 <<< 21))
    (hs0_4 : s0_4 = s0_3 + ((0#64 + carry11_2) * 666643#64))
    (hcarry0_2 : carry0_2 = BitVec.sshiftRight s0_4 21)
    (hs1_7 : s1_7 = (s1_5 - (carry1_1 <<< 21)) + ((0#64 + carry11_2) * 470296#64))
    (hs1_8 : s1_8 = s1_7 + carry0_2) (hs0_5 : s0_5 = s0_4 - (carry0_2 <<< 21))
    (hcarry1_2 : carry1_2 = BitVec.sshiftRight s1_8 21)
    (hs2_8 : s2_8 = ((s2_5 - (carry2_1 <<< 21)) + carry1_1) + ((0#64 + carry11_2) * 654183#64))
    (hs2_9 : s2_9 = s2_8 + carry1_2) (hs1_9 : s1_9 = s1_8 - (carry1_2 <<< 21))
    (hcarry2_2 : carry2_2 = BitVec.sshiftRight s2_9 21)
    (hs3_9 : s3_9 = (s3_7 - (carry3_1 <<< 21)) - ((0#64 + carry11_2) * 997805#64))
    (hs3_10 : s3_10 = s3_9 + carry2_2) (hs2_10 : s2_10 = s2_9 - (carry2_2 <<< 21))
    (hcarry3_2 : carry3_2 = BitVec.sshiftRight s3_10 21)
    (hs4_10 : s4_10 = ((s4_7 - (carry4_1 <<< 21)) + carry3_1) + ((0#64 + carry11_2) * 136657#64))
    (hs4_11 : s4_11 = s4_10 + carry3_2) (hs3_11 : s3_11 = s3_10 - (carry3_2 <<< 21))
    (hcarry4_2 : carry4_2 = BitVec.sshiftRight s4_11 21)
    (hs5_11 : s5_11 = (s5_9 - (carry5_1 <<< 21)) - ((0#64 + carry11_2) * 683901#64))
    (hs5_12 : s5_12 = s5_11 + carry4_2) (hs4_12 : s4_12 = s4_11 - (carry4_2 <<< 21))
    (hcarry5_2 : carry5_2 = BitVec.sshiftRight s5_12 21) (hs6_12 : s6_12 = s6_11 + carry5_2)
    (hs5_13 : s5_13 = s5_12 - (carry5_2 <<< 21))
    (hcarry6_3 : carry6_3 = BitVec.sshiftRight s6_12 21) (hs7_13 : s7_13 = s7_12 + carry6_3)
    (hs6_13 : s6_13 = s6_12 - (carry6_3 <<< 21))
    (hcarry7_3 : carry7_3 = BitVec.sshiftRight s7_13 21) (hs8_13 : s8_13 = s8_12 + carry7_3)
    (hs7_14 : s7_14 = s7_13 - (carry7_3 <<< 21))
    (hcarry8_3 : carry8_3 = BitVec.sshiftRight s8_13 21) (hs9_13 : s9_13 = s9_12 + carry8_3)
    (hs8_14 : s8_14 = s8_13 - (carry8_3 <<< 21))
    (hcarry9_3 : carry9_3 = BitVec.sshiftRight s9_13 21) (hs10_13 : s10_13 = s10_12 + carry9_3)
    (hs9_14 : s9_14 = s9_13 - (carry9_3 <<< 21))
    (hcarry10_3 : carry10_3 = BitVec.sshiftRight s10_13 21) (hs11_13 : s11_13 = s11_12 + carry10_3)
    (hs10_14 : s10_14 = s10_13 - (carry10_3 <<< 21))
    (hcarry11_3 : carry11_3 = BitVec.sshiftRight s11_13 21)
    (hs11_14 : s11_14 = s11_13 - (carry11_3 <<< 21))
    (hs0_6 : s0_6 = s0_5 + ((0#64 + carry11_3) * 666643#64))
    (hs1_10 : s1_10 = s1_9 + ((0#64 + carry11_3) * 470296#64))
    (hs2_11 : s2_11 = s2_10 + ((0#64 + carry11_3) * 654183#64))
    (hs3_12 : s3_12 = s3_11 - ((0#64 + carry11_3) * 997805#64))
    (hs4_13 : s4_13 = s4_12 + ((0#64 + carry11_3) * 136657#64))
    (hs5_14 : s5_14 = s5_13 - ((0#64 + carry11_3) * 683901#64))
    (hcarry0_3 : carry0_3 = BitVec.sshiftRight s0_6 21) (hs1_11 : s1_11 = s1_10 + carry0_3)
    (hs0_7 : s0_7 = s0_6 - (carry0_3 <<< 21)) (hcarry1_3 : carry1_3 = BitVec.sshiftRight s1_11 21)
    (hs2_12 : s2_12 = s2_11 + carry1_3) (hcarry2_3 : carry2_3 = BitVec.sshiftRight s2_12 21)
    (hs3_13 : s3_13 = s3_12 + carry2_3) (hcarry3_3 : carry3_3 = BitVec.sshiftRight s3_13 21)
    (hs4_14 : s4_14 = s4_13 + carry3_3) (hcarry4_3 : carry4_3 = BitVec.sshiftRight s4_14 21)
    (hs5_15 : s5_15 = s5_14 + carry4_3) (hcarry5_3 : carry5_3 = BitVec.sshiftRight s5_15 21)
    (hs6_14 : s6_14 = s6_13 + carry5_3) (hcarry6_4 : carry6_4 = BitVec.sshiftRight s6_14 21)
    (hs7_15 : s7_15 = s7_14 + carry6_4) (hcarry7_4 : carry7_4 = BitVec.sshiftRight s7_15 21)
    (hs8_15 : s8_15 = s8_14 + carry7_4) (hcarry8_4 : carry8_4 = BitVec.sshiftRight s8_15 21)
    (hs9_15 : s9_15 = s9_14 + carry8_4) (hcarry9_4 : carry9_4 = BitVec.sshiftRight s9_15 21)
    (hs10_15 : s10_15 = s10_14 + carry9_4)
    (hout0 :
      out0 =
        ((s0_7 ||| ((s1_11 - (carry1_3 <<< 21)) <<< 21)) |||
            ((s2_12 - (carry2_3 <<< 21)) <<< 42)) |||
          ((s3_13 - (carry3_3 <<< 21)) <<< 63))
    (hout1 :
      out1 =
        ((((s3_13 - (carry3_3 <<< 21)) >>> 1) ||| ((s4_14 - (carry4_3 <<< 21)) <<< 20)) |||
            ((s5_15 - (carry5_3 <<< 21)) <<< 41)) |||
          ((s6_14 - (carry6_4 <<< 21)) <<< 62))
    (hout2 :
      out2 =
        ((((s6_14 - (carry6_4 <<< 21)) >>> 2) ||| ((s7_15 - (carry7_4 <<< 21)) <<< 19)) |||
            ((s8_15 - (carry8_4 <<< 21)) <<< 40)) |||
          ((s9_15 - (carry9_4 <<< 21)) <<< 61))
    (hout3 :
      out3 =
        (((s9_15 - (carry9_4 <<< 21)) >>> 3) |||
            ((s10_15 - ((BitVec.sshiftRight s10_15 21) <<< 21)) <<< 18)) |||
          ((s11_14 + (BitVec.sshiftRight s10_15 21)) <<< 39)) :
    out3 ++ (out2 ++ (out1 ++ out0)) = fd_curve25519_scalar_muladd.spec A B C := by
  subst_vars
  rfl

-- 20 runs and the C values in one declaration, over a context of ~2000 facts.
set_option maxHeartbeats 400000 in
/-- `muladd` stores `spec` of the 32 bytes at `a`, `b` and `c` as the 32 bytes at `s`, and returns
`s`. The loads all come before the stores, so `s` may alias the inputs. -/
public theorem fd_curve25519_scalar_muladd.call_eq (s a b c : Pointer) (st : GlobalState)
    (hwf : st.WF) (hs : Room st.mem s (8 * 32)) (hs_off : ¬s.offset.uaddOverflow 32#64)
    (ha : Fits st.mem a (8 * 32)) (ha_off : ¬a.offset.uaddOverflow 32#64)
    (hb : Fits st.mem b (8 * 32)) (hb_off : ¬b.offset.uaddOverflow 32#64)
    (hc : Fits st.mem c (8 * 32)) (hc_off : ¬c.offset.uaddOverflow 32#64) :
    fd_curve25519_scalar_muladd.call
        (fd_curve25519_scalar_muladd.args (.value s) (.value a) (.value b) (.value c)) st =
      .value
        (.cons (.value s) .nil,
          { st with
            mem :=
              st.mem.storeAt s
                (fd_curve25519_scalar_muladd.spec (st.mem.readAt a 256) (st.mem.readAt b 256)
                  (st.mem.readAt c 256)) }) := by
  func_init
  block_init
  step_pattern using fd_curve25519_scalar_muladd.run0
  step_pattern using fd_curve25519_scalar_muladd.run57
  step_pattern using fd_curve25519_scalar_muladd.run102
  step_pattern using fd_curve25519_scalar_muladd.run147
  step_pattern using fd_curve25519_scalar_muladd.run192
  step_pattern using fd_curve25519_scalar_muladd.run237
  step_pattern using fd_curve25519_scalar_muladd.run282
  step_pattern using fd_curve25519_scalar_muladd.run327
  step_pattern using fd_curve25519_scalar_muladd.run372
  step_pattern using fd_curve25519_scalar_muladd.run417
  step_pattern using fd_curve25519_scalar_muladd.run462
  step_pattern using fd_curve25519_scalar_muladd.run507
  step_pattern using fd_curve25519_scalar_muladd.run552
  step_pattern using fd_curve25519_scalar_muladd.run597
  step_pattern using fd_curve25519_scalar_muladd.run642
  step_pattern using fd_curve25519_scalar_muladd.run687
  step_pattern using fd_curve25519_scalar_muladd.run732
  step_pattern using fd_curve25519_scalar_muladd.run777
  step_pattern using fd_curve25519_scalar_muladd.run822
  step_pattern using fd_curve25519_scalar_muladd.run854
  finish_block
  have hov (k : Nat) (hk : k ≤ 32) : ¬s.offset.uaddOverflow (BitVec.ofNat 64 k) :=
    BitVec.not_uaddOverflow_of_le hs_off
      (by
        simp; omega)
  rw [hS, MemoryState.storeAt_storeAt_append (hov 8 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 16 (by decide)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 24 (by decide)) rfl (by decide)]
  -- the compiled values in the C's terms
  have es_a1 := fd_curve25519_scalar_muladd.a1_eq ha1 ht58
  have es_a2 := fd_curve25519_scalar_muladd.a2_eq ha2 ht60
  have es_a3 := fd_curve25519_scalar_muladd.a3_eq ha3 ht62
  have es_a4 := fd_curve25519_scalar_muladd.a4_eq ha4 ht64
  have es_a5 := fd_curve25519_scalar_muladd.a5_eq ha5 ht66
  have es_a6 := fd_curve25519_scalar_muladd.a6_eq ha6 ht68
  have es_a7 := fd_curve25519_scalar_muladd.a7_eq ha7 ht70
  have es_a8 := fd_curve25519_scalar_muladd.a8_eq ha8 ht72
  have es_a9 := fd_curve25519_scalar_muladd.a9_eq ha9 ht74
  have es_a10 := fd_curve25519_scalar_muladd.a10_eq ha10 ht76
  have es_b1 := fd_curve25519_scalar_muladd.b1_eq hb1 ht80
  have es_b2 := fd_curve25519_scalar_muladd.b2_eq hb2 ht82
  have es_b3 := fd_curve25519_scalar_muladd.b3_eq hb3 ht84
  have es_b4 := fd_curve25519_scalar_muladd.b4_eq hb4 ht86
  have es_b5 := fd_curve25519_scalar_muladd.b5_eq hb5 ht88
  have es_b6 := fd_curve25519_scalar_muladd.b6_eq hb6 ht90
  have es_b7 := fd_curve25519_scalar_muladd.b7_eq hb7 ht92
  have es_b8 := fd_curve25519_scalar_muladd.b8_eq hb8 ht94
  have es_b9 := fd_curve25519_scalar_muladd.b9_eq hb9 ht96
  have es_b10 := fd_curve25519_scalar_muladd.b10_eq hb10 ht98
  have es_c1 := fd_curve25519_scalar_muladd.c1_eq hc1 ht102
  have es_c2 := fd_curve25519_scalar_muladd.c2_eq hc2 ht104
  have es_c3 := fd_curve25519_scalar_muladd.c3_eq hc3 ht106
  have es_c4 := fd_curve25519_scalar_muladd.c4_eq hc4 ht108
  have es_c5 := fd_curve25519_scalar_muladd.c5_eq hc5 ht110
  have es_c6 := fd_curve25519_scalar_muladd.c6_eq hc6 ht112
  have es_c7 := fd_curve25519_scalar_muladd.c7_eq hc7 ht114
  have es_c8 := fd_curve25519_scalar_muladd.c8_eq hc8 ht116
  have es_c9 := fd_curve25519_scalar_muladd.c9_eq hc9 ht118
  have es_c10 := fd_curve25519_scalar_muladd.c10_eq hc10 ht120
  have es_s0 := fd_curve25519_scalar_muladd.s0_eq hs0 ht123
  have es_s2 := fd_curve25519_scalar_muladd.s2_eq hs2 ht131 ht130 ht129 ht127 ht128
  have es_s4 :=
    fd_curve25519_scalar_muladd.s4_eq hs4 ht145 ht144 ht137 ht143 ht141 ht142 ht140 ht139 ht138
  have es_s6 :=
    fd_curve25519_scalar_muladd.s6_eq hs6 ht165 ht164 ht163 ht156 ht162 ht155 ht161 ht160 ht158
      ht157 ht154 ht159 ht153
  have es_s8 :=
    fd_curve25519_scalar_muladd.s8_eq hs8 ht177 ht191 ht190 ht189 ht188 ht187 ht182 ht186 ht185
      ht184 ht179 ht178 ht180 ht181 ht183 ht175 ht176
  have es_s10 :=
    fd_curve25519_scalar_muladd.s10_eq hs10 ht204 ht223 ht222 ht203 ht221 ht213 ht220 ht212 ht219
      ht218 ht206 ht217 ht216 ht215 ht210 ht214 ht209 ht208 ht211 ht205 ht207
  have es_s12 :=
    fd_curve25519_scalar_muladd.s12_eq hs12 ht256 ht255 ht254 ht253 ht237 ht252 ht247 ht251 ht242
      ht250 ht249 ht240 ht248 ht243 ht244 ht241 ht245 ht246 ht238 ht239
  have es_s14 :=
    fd_curve25519_scalar_muladd.s14_eq hs14 ht283 ht282 ht281 ht280 ht279 ht276 ht278 ht277 ht271
      ht272 ht273 ht268 ht274 ht275 ht269 ht270
  have es_s16 :=
    fd_curve25519_scalar_muladd.s16_eq hs16 ht295 ht304 ht294 ht303 ht302 ht301 ht300 ht299 ht296
      ht293 ht297 ht298
  have es_s18 :=
    fd_curve25519_scalar_muladd.s18_eq hs18 ht319 ht318 ht315 ht317 ht312 ht316 ht313 ht314
  have es_s20 := fd_curve25519_scalar_muladd.s20_eq hs20 ht328 ht327 ht325 ht326
  have es_s21 := fd_curve25519_scalar_muladd.s21_eq hs21 ht331 ht330
  have es_s22 := fd_curve25519_scalar_muladd.s22_eq hs22
  have es_s1 := fd_curve25519_scalar_muladd.s1_eq hs1 ht336 ht125 ht126
  have es_s0_1 := fd_curve25519_scalar_muladd.s0_1_eq hs0_1 hcarry0
  have es_s3 := fd_curve25519_scalar_muladd.s3_eq hs3 ht345 ht133 ht344 ht136 ht343 ht135 ht134
  have es_s2_1 := fd_curve25519_scalar_muladd.s2_1_eq hs2_1 hcarry2
  have es_s5 :=
    fd_curve25519_scalar_muladd.s5_eq hs5 ht149 ht356 ht355 ht354 ht353 ht352 ht150 ht151 ht152
      ht147 ht148
  have es_s4_1 := fd_curve25519_scalar_muladd.s4_1_eq hs4_1 hcarry4
  have es_carry6 := fd_curve25519_scalar_muladd.carry6_eq hcarry6 ht361
  have es_s7 :=
    fd_curve25519_scalar_muladd.s7_eq hs7 ht168 ht369 ht368 ht167 ht367 ht174 ht366 ht365 ht171
      ht364 ht170 ht363 ht169 ht172 ht173
  have es_s9 :=
    fd_curve25519_scalar_muladd.s9_eq hs9 ht383 ht193 ht382 ht381 ht380 ht195 ht379 ht194 ht378
      ht201 ht377 ht376 ht375 ht198 ht197 ht199 ht200 ht196 ht202
  have es_s8_1 := fd_curve25519_scalar_muladd.s8_1_eq hs8_1 hcarry8
  have es_s11 :=
    fd_curve25519_scalar_muladd.s11_eq hs11 ht227 ht400 ht226 ht399 ht235 ht398 ht397 ht396 ht395
      ht236 ht394 ht393 ht229 ht392 ht391 ht233 ht390 ht231 ht232 ht228 ht230 ht225 ht234
  have es_s13 :=
    fd_curve25519_scalar_muladd.s13_eq hs13 ht413 ht259 ht412 ht266 ht411 ht265 ht410 ht409 ht267
      ht408 ht407 ht262 ht406 ht261 ht264 ht263 ht258 ht260
  have es_s15 :=
    fd_curve25519_scalar_muladd.s15_eq hs15 ht424 ht423 ht422 ht290 ht421 ht285 ht420 ht292 ht419
      ht288 ht289 ht291 ht286 ht287
  have es_s17 :=
    fd_curve25519_scalar_muladd.s17_eq hs17 ht433 ht432 ht310 ht431 ht309 ht430 ht306 ht311 ht307
      ht308
  have es_s19 := fd_curve25519_scalar_muladd.s19_eq hs19 ht323 ht440 ht322 ht439 ht321 ht324
  have es_s18_1 := fd_curve25519_scalar_muladd.s18_1_eq hs18_1 hcarry18
  have es_s20_1 := fd_curve25519_scalar_muladd.s20_1_eq hs20_1 hcarry20
  have es_s22_1 := fd_curve25519_scalar_muladd.s22_1_eq hs22_1 hcarry22
  have es_s1_2 := fd_curve25519_scalar_muladd.s1_2_eq hs1_2 hcarry1
  have es_carry3 := fd_curve25519_scalar_muladd.carry3_eq hcarry3 ht459
  have es_s3_2 := fd_curve25519_scalar_muladd.s3_2_eq hs3_2 hcarry3
  have es_s5_2 := fd_curve25519_scalar_muladd.s5_2_eq hs5_2 hcarry5
  have es_s7_2 := fd_curve25519_scalar_muladd.s7_2_eq hs7_2 hcarry7
  have es_s18_2 := fd_curve25519_scalar_muladd.s18_2_eq hs18_2
  have es_s17_2 := fd_curve25519_scalar_muladd.s17_2_eq hs17_2 hcarry17
  have es_s20_2 := fd_curve25519_scalar_muladd.s20_2_eq hs20_2
  have es_s19_2 := fd_curve25519_scalar_muladd.s19_2_eq hs19_2 hcarry19
  have es_s22_2 := fd_curve25519_scalar_muladd.s22_2_eq hs22_2
  have es_s21_2 := fd_curve25519_scalar_muladd.s21_2_eq hs21_2 hcarry21
  have es_s16_3 := fd_curve25519_scalar_muladd.s16_3_eq hs16_3 ht507 ht506 ht505 ht436 hcarry16
  have es_s14_5 :=
    fd_curve25519_scalar_muladd.s14_5_eq hs14_5 ht524 ht523 ht520 ht522 ht521 ht503 ht513 ht427
      hcarry14
  have es_s8_3 := fd_curve25519_scalar_muladd.s8_3_eq hs8_3 ht526
  have es_s7_3 := fd_curve25519_scalar_muladd.s7_3_eq hs7_3 ht533
  have es_s8_4 := fd_curve25519_scalar_muladd.s8_4_eq hs8_4 ht535
  have es_s12_7 :=
    fd_curve25519_scalar_muladd.s12_7_eq hs12_7 ht546 ht545 ht544 ht531 ht543 ht542 ht518 ht541
      ht511 ht501 ht540 ht416 hcarry12
  have es_s6_2 := fd_curve25519_scalar_muladd.s6_2_eq hs6_2 ht372 ht549 hcarry6
  have es_s6_3 := fd_curve25519_scalar_muladd.s6_3_eq hs6_3 ht548
  have es_s7_4 := fd_curve25519_scalar_muladd.s7_4_eq hs7_4 ht552
  have es_s8_5 := fd_curve25519_scalar_muladd.s8_5_eq hs8_5 ht554
  have es_s10_6 :=
    fd_curve25519_scalar_muladd.s10_6_eq hs10_6 ht562 ht561 ht560 ht529 ht559 ht558 ht516 ht509
      ht538 ht403 hcarry10
  have es_s10_7 := fd_curve25519_scalar_muladd.s10_7_eq hs10_7 ht557
  have es_s6_4 := fd_curve25519_scalar_muladd.s6_4_eq hs6_4 hcarry6_1
  have es_s9_5 :=
    fd_curve25519_scalar_muladd.s9_5_eq hs9_5 ht475 ht575 ht537 ht574 ht528 ht573 ht515 hcarry9
  have es_s9_6 := fd_curve25519_scalar_muladd.s9_6_eq hs9_6 ht556
  have es_s8_6 := fd_curve25519_scalar_muladd.s8_6_eq hs8_6 hcarry8_1
  have es_s11_8 :=
    fd_curve25519_scalar_muladd.s11_8_eq hs11_8 ht588 ht587 ht586 ht539 ht585 ht584 ht517 ht583
      ht500 ht510 ht530 ht565 ht478 hcarry11
  have es_carry12_1 := fd_curve25519_scalar_muladd.carry12_1_eq hcarry12_1 ht592
  have es_s13_6 :=
    fd_curve25519_scalar_muladd.s13_6_eq hs13_6 ht481 ht597 ht596 ht532 ht595 ht519 ht594 ht502
      ht512 hcarry13
  have es_s12_8 := fd_curve25519_scalar_muladd.s12_8_eq hs12_8 hcarry12_1
  have es_s15_4 :=
    fd_curve25519_scalar_muladd.s15_4_eq hs15_4 ht484 ht605 ht604 ht514 ht504 hcarry15
  have es_s14_6 := fd_curve25519_scalar_muladd.s14_6_eq hs14_6 hcarry14_1
  have es_s17_3 := fd_curve25519_scalar_muladd.s17_3_eq hs17_3
  have es_s16_4 := fd_curve25519_scalar_muladd.s16_4_eq hs16_4 hcarry16_1
  have es_s7_6 := fd_curve25519_scalar_muladd.s7_6_eq hs7_6 hcarry7_1
  have es_s12_9 := fd_curve25519_scalar_muladd.s12_9_eq hs12_9
  have es_s11_10 := fd_curve25519_scalar_muladd.s11_10_eq hs11_10 hcarry11_1
  have es_s14_7 := fd_curve25519_scalar_muladd.s14_7_eq hs14_7
  have es_s13_8 := fd_curve25519_scalar_muladd.s13_8_eq hs13_8 hcarry13_1
  have es_s16_5 := fd_curve25519_scalar_muladd.s16_5_eq hs16_5
  have es_s15_6 := fd_curve25519_scalar_muladd.s15_6_eq hs15_6 hcarry15_1
  have es_s5_3 := fd_curve25519_scalar_muladd.s5_3_eq hs5_3 ht638
  have es_s6_5 := fd_curve25519_scalar_muladd.s6_5_eq hs6_5 ht640
  have es_s7_7 := fd_curve25519_scalar_muladd.s7_7_eq hs7_7 ht642
  have es_s8_8 := fd_curve25519_scalar_muladd.s8_8_eq hs8_8 ht644
  have es_s10_10 := fd_curve25519_scalar_muladd.s10_10_eq hs10_10 ht591 ht649 ht648 ht647 hcarry10_1
  have es_s4_3 := fd_curve25519_scalar_muladd.s4_3_eq hs4_3 ht651
  have es_s5_4 := fd_curve25519_scalar_muladd.s5_4_eq hs5_4 ht653
  have es_s6_6 := fd_curve25519_scalar_muladd.s6_6_eq hs6_6 ht655
  have es_s7_8 := fd_curve25519_scalar_muladd.s7_8_eq hs7_8 ht657
  have es_s8_9 := fd_curve25519_scalar_muladd.s8_9_eq hs8_9 ht659
  have es_s3_3 := fd_curve25519_scalar_muladd.s3_3_eq hs3_3 ht662
  have es_s4_4 := fd_curve25519_scalar_muladd.s4_4_eq hs4_4 ht664
  have es_s5_5 := fd_curve25519_scalar_muladd.s5_5_eq hs5_5 ht666
  have es_s6_7 := fd_curve25519_scalar_muladd.s6_7_eq hs6_7 ht668
  have es_s7_9 := fd_curve25519_scalar_muladd.s7_9_eq hs7_9 ht670
  have es_s8_10 := fd_curve25519_scalar_muladd.s8_10_eq hs8_10 ht672
  have es_s6_8 := fd_curve25519_scalar_muladd.s6_8_eq hs6_8 ht678
  have es_s7_10 := fd_curve25519_scalar_muladd.s7_10_eq hs7_10 ht680
  have es_s6_9 := fd_curve25519_scalar_muladd.s6_9_eq hs6_9 ht687
  have es_s0_2 := fd_curve25519_scalar_muladd.s0_2_eq hs0_2 ht689
  have es_s2_5 := fd_curve25519_scalar_muladd.s2_5_eq hs2_5 ht694 ht693 ht692 ht674 ht683
  have es_s4_7 := fd_curve25519_scalar_muladd.s4_7_eq hs4_7 ht699 ht698 ht697 ht676 ht685
  have es_s1_4 := fd_curve25519_scalar_muladd.s1_4_eq hs1_4 ht682 ht704 ht691
  have es_s0_3 := fd_curve25519_scalar_muladd.s0_3_eq hs0_3 hcarry0_1
  have es_s3_6 := fd_curve25519_scalar_muladd.s3_6_eq hs3_6 ht712 ht675 ht711 ht696 ht684
  have es_s5_8 := fd_curve25519_scalar_muladd.s5_8_eq hs5_8 ht686 ht719 ht718 ht701 ht677
  have es_s6_10 := fd_curve25519_scalar_muladd.s6_10_eq hs6_10 hcarry6_2
  have es_carry8_2 := fd_curve25519_scalar_muladd.carry8_2_eq hcarry8_2 ht728
  have es_s9_9 := fd_curve25519_scalar_muladd.s9_9_eq hs9_9 ht622 ht730 ht646 hcarry9_1
  have es_s9_10 := fd_curve25519_scalar_muladd.s9_10_eq hs9_10 ht661
  have es_s8_11 := fd_curve25519_scalar_muladd.s8_11_eq hs8_11 hcarry8_2
  have es_s10_11 := fd_curve25519_scalar_muladd.s10_11_eq hs10_11 hcarry10_2
  have es_s7_12 := fd_curve25519_scalar_muladd.s7_12_eq hs7_12 hcarry7_2
  have es_s9_12 := fd_curve25519_scalar_muladd.s9_12_eq hs9_12 hcarry9_2
  have es_s11_12 := fd_curve25519_scalar_muladd.s11_12_eq hs11_12 hcarry11_2
  have es_s0_4 := fd_curve25519_scalar_muladd.s0_4_eq hs0_4 ht765
  have es_s1_7 := fd_curve25519_scalar_muladd.s1_7_eq hs1_7 ht773 ht767 hcarry1_1
  have es_s0_5 := fd_curve25519_scalar_muladd.s0_5_eq hs0_5 hcarry0_2
  have es_s2_8 := fd_curve25519_scalar_muladd.s2_8_eq hs2_8 ht779 ht778 ht768 ht715 hcarry2_1
  have es_s1_9 := fd_curve25519_scalar_muladd.s1_9_eq hs1_9 hcarry1_2
  have es_s3_9 := fd_curve25519_scalar_muladd.s3_9_eq hs3_9 ht784 ht769 ht746 hcarry3_1
  have es_s2_10 := fd_curve25519_scalar_muladd.s2_10_eq hs2_10 hcarry2_2
  have es_s4_10 := fd_curve25519_scalar_muladd.s4_10_eq hs4_10 ht790 ht789 ht770 ht722 hcarry4_1
  have es_s3_11 := fd_curve25519_scalar_muladd.s3_11_eq hs3_11 hcarry3_2
  have es_s5_11 := fd_curve25519_scalar_muladd.s5_11_eq hs5_11 ht750 ht795 ht771 hcarry5_1
  have es_s4_12 := fd_curve25519_scalar_muladd.s4_12_eq hs4_12 hcarry4_2
  have es_s5_13 := fd_curve25519_scalar_muladd.s5_13_eq hs5_13 hcarry5_2
  have es_s7_13 := fd_curve25519_scalar_muladd.s7_13_eq hs7_13
  have es_s6_13 := fd_curve25519_scalar_muladd.s6_13_eq hs6_13 hcarry6_3
  have es_s7_14 := fd_curve25519_scalar_muladd.s7_14_eq hs7_14 hcarry7_3
  have es_s9_13 := fd_curve25519_scalar_muladd.s9_13_eq hs9_13
  have es_s8_14 := fd_curve25519_scalar_muladd.s8_14_eq hs8_14 hcarry8_3
  have es_s9_14 := fd_curve25519_scalar_muladd.s9_14_eq hs9_14 hcarry9_3
  have es_s11_13 := fd_curve25519_scalar_muladd.s11_13_eq hs11_13
  have es_s10_14 := fd_curve25519_scalar_muladd.s10_14_eq hs10_14 hcarry10_3
  have es_s11_14 := fd_curve25519_scalar_muladd.s11_14_eq hs11_14 hcarry11_3
  have es_s0_6 := fd_curve25519_scalar_muladd.s0_6_eq hs0_6 ht819
  have es_s1_10 := fd_curve25519_scalar_muladd.s1_10_eq hs1_10 ht821
  have es_s2_11 := fd_curve25519_scalar_muladd.s2_11_eq hs2_11 ht823
  have es_s3_12 := fd_curve25519_scalar_muladd.s3_12_eq hs3_12 ht825
  have es_s4_13 := fd_curve25519_scalar_muladd.s4_13_eq hs4_13 ht827
  have es_s5_14 := fd_curve25519_scalar_muladd.s5_14_eq hs5_14 ht829
  have es_s0_7 := fd_curve25519_scalar_muladd.s0_7_eq hs0_7 hcarry0_3
  have es_s6_14 := fd_curve25519_scalar_muladd.s6_14_eq hs6_14
  have es_s7_15 := fd_curve25519_scalar_muladd.s7_15_eq hs7_15
  have es_s8_15 := fd_curve25519_scalar_muladd.s8_15_eq hs8_15
  have es_s9_15 := fd_curve25519_scalar_muladd.s9_15_eq hs9_15
  have es_s10_15 := fd_curve25519_scalar_muladd.s10_15_eq hs10_15
  have es_out0 := fd_curve25519_scalar_muladd.out0_eq hout0 hcarry1_3 hcarry2_3 hcarry3_3
  have es_out1 := fd_curve25519_scalar_muladd.out1_eq hout1 hcarry3_3 hcarry4_3 hcarry5_3 hcarry6_4
  have es_out2 := fd_curve25519_scalar_muladd.out2_eq hout2 hcarry6_4 hcarry7_4 hcarry8_4 hcarry9_4
  have es_out3 := fd_curve25519_scalar_muladd.out3_eq hout3 ht853 ht852 hcarry9_4
  rw [fd_curve25519_scalar_muladd.spec_eq (hia0.trans (BitVec.setWidth_eq_extractLsb' (by decide)))
      (hib0.trans (BitVec.setWidth_eq_extractLsb' (by decide)))
      (hic0.trans (BitVec.setWidth_eq_extractLsb' (by decide))) hia1 hib1 hic1 hia2 hib2 hic2 hia3
      hib3 hic3 ha0 es_a1 es_a2 es_a3 es_a4 es_a5 es_a6 es_a7 es_a8 es_a9 es_a10 ha11 hb0 es_b1
      es_b2 es_b3 es_b4 es_b5 es_b6 es_b7 es_b8 es_b9 es_b10 hb11 hc0 es_c1 es_c2 es_c3 es_c4 es_c5
      es_c6 es_c7 es_c8 es_c9 es_c10 hc11 es_s0 es_s2 es_s4 es_s6 es_s8 es_s10 es_s12 es_s14 es_s16
      es_s18 es_s20 es_s21 es_s22 hcarry0 es_s1 hs1_1 es_s0_1 hcarry2 es_s3 hs3_1 es_s2_1 hcarry4
      es_s5 hs5_1 es_s4_1 es_carry6 es_s7 hs7_1 hcarry8 es_s9 hs9_1 es_s8_1 hcarry10 es_s11 hs11_1
      hcarry12 es_s13 hs13_1 hcarry14 es_s15 hs15_1 hcarry16 es_s17 hs17_1 hcarry18 es_s19 hs19_1
      es_s18_1 hcarry20 hs21_1 es_s20_1 hcarry22 es_s22_1 hcarry1 hs2_2 es_s1_2 es_carry3 hs4_2
      es_s3_2 hcarry5 es_s5_2 hcarry7 hs8_2 es_s7_2 hcarry9 hcarry11 hcarry13 hcarry15 hcarry17
      es_s18_2 es_s17_2 hcarry19 es_s20_2 es_s19_2 hcarry21 es_s22_2 es_s21_2 es_s16_3 es_s14_5
      es_s8_3 es_s7_3 es_s8_4 es_s12_7 es_s6_2 es_s6_3 es_s7_4 es_s8_5 es_s10_6 es_s10_7 hcarry6_1
      hs7_5 es_s6_4 hcarry8_1 es_s9_5 es_s9_6 hs9_7 es_s8_6 hcarry10_1 es_s11_8 hs11_9 es_carry12_1
      es_s13_6 hs13_7 es_s12_8 hcarry14_1 es_s15_4 hs15_5 es_s14_6 hcarry16_1 es_s17_3 es_s16_4
      hcarry7_1 hs8_7 es_s7_6 hcarry9_1 hcarry11_1 es_s12_9 es_s11_10 hcarry13_1 es_s14_7 es_s13_8
      hcarry15_1 es_s16_5 es_s15_6 es_s5_3 es_s6_5 es_s7_7 es_s8_8 es_s10_10 es_s4_3 es_s5_4 es_s6_6
      es_s7_8 es_s8_9 es_s3_3 es_s4_4 es_s5_5 es_s6_7 es_s7_9 es_s8_10 es_s6_8 es_s7_10 es_s6_9
      es_s0_2 es_s2_5 es_s4_7 hcarry0_1 es_s1_4 hs1_5 es_s0_3 hcarry2_1 es_s3_6 hs3_7 hcarry4_1
      es_s5_8 hs5_9 hcarry6_2 hs7_11 es_s6_10 es_carry8_2 es_s9_9 es_s9_10 hs9_11 es_s8_11
      hcarry10_2 hs11_11 es_s10_11 hcarry1_1 hcarry3_1 hcarry5_1 hs6_11 hcarry7_2 hs8_12 es_s7_12
      hcarry9_2 hs10_12 es_s9_12 hcarry11_2 es_s11_12 es_s0_4 hcarry0_2 es_s1_7 hs1_8 es_s0_5
      hcarry1_2 es_s2_8 hs2_9 es_s1_9 hcarry2_2 es_s3_9 hs3_10 es_s2_10 hcarry3_2 es_s4_10 hs4_11
      es_s3_11 hcarry4_2 es_s5_11 hs5_12 es_s4_12 hcarry5_2 hs6_12 es_s5_13 hcarry6_3 es_s7_13
      es_s6_13 hcarry7_3 hs8_13 es_s7_14 hcarry8_3 es_s9_13 es_s8_14 hcarry9_3 hs10_13 es_s9_14
      hcarry10_3 es_s11_13 es_s10_14 hcarry11_3 es_s11_14 es_s0_6 es_s1_10 es_s2_11 es_s3_12
      es_s4_13 es_s5_14 hcarry0_3 hs1_11 es_s0_7 hcarry1_3 hs2_12 hcarry2_3 hs3_13 hcarry3_3 hs4_14
      hcarry4_3 hs5_15 hcarry5_3 es_s6_14 hcarry6_4 es_s7_15 hcarry7_4 es_s8_15 hcarry8_4 es_s9_15
      hcarry9_4 es_s10_15 es_out0 es_out1 es_out2 es_out3]

end Proof

end MLIR.Firedancer.Crc.Ref
