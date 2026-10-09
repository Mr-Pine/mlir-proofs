module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import Firedancer.R52x5.fd_ulong_load_8
public import Firedancer.R52x5.Common.Limbs
public import Firedancer.R52x5.Mlir.fd_curve25519_scalar_reduce
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.R52x5

open Ref (Bnd nswAdd nswSub nswMul nuwAdd nuwMul lshrNonneg andMask)

/-! `fd_curve25519_scalar_reduce`'s compiled code computes the C's limbs in another order, the
unpacking and the packing partly in `<2 x i64>` and `<4 x i64>` lanes. Its runs `runK` step the
instructions from the `K`-th in continuation form: each value is named after the C variable it
equals (`tN` for `%N` otherwise), bounded (`Bnd`) to discharge its `nsw`/`nuw` flags, and stated
with the carries as `sshiftRight`s and the masked carries as `carry <<< 21`. Each `x_eq` restates a
C variable `x` over the earlier ones as the spec's lets expand, `pack_eq` the stored lanes as the
spec's `out3 ++ (out2 ++ (out1 ++ out0))`; substituted, the result is the spec by `rfl`. -/

section Proof

/-- The constants the scalar code reads. -/
abbrev fd_curve25519_scalar_reduce.Consts (E : ⟪fd_curve25519_scalar_reduce.Γ⟫) : Prop :=
  E ⊨ [%451 := 16#64, %452 := 40#64, %453 := 2097151#64, %454 := 21#64, %455 := 42#64, %456 :=
    20#64, %457 := 41#64, %458 := Vector.replicate 2 PoisonOr.poison, %459 := 0#64, %460 := 1#64,
    %461 := Ty.wrap #v[1#64, 2#64], %462 := 19#64, %463 := 18#64, %464 := 39#64, %465 :=
    Ty.wrap #v[3#64, 4#64], %466 := 17#64, %467 := 38#64, %468 := 37#64, %469 :=
    Ty.wrap #v[5#64, 6#64], %470 := 15#64, %471 := 36#64, %472 := 7#64, %473 := 14#64, %474 :=
    35#64, %475 := 666643#64, %476 := 470296#64, %477 := 654183#64, %478 := 18446744073708553811#64,
    %479 := 136657#64, %480 := 18446744073708867715#64, %481 := 1048576#64, %482 :=
    8796090925056#64, %483 := 9223372036852678656#64, %484 := 18446744073707454464#64]

/-- The constants the final packing reads. -/
abbrev fd_curve25519_scalar_reduce.VConsts (E : ⟪fd_curve25519_scalar_reduce.Γ⟫) : Prop :=
  E ⊨ [%438 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64], %439 :=
    Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64], %440 :=
    Ty.wrap #v[21#64, 20#64, 19#64, 18#64], %441 :=
    Ty.wrap #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64],
    %442 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64], %443 := 3#64, %444 :=
    Vector.replicate 4 PoisonOr.poison, %445 := Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64],
    %446 := Ty.wrap #v[0#64, 1#64, 2#64, 0#64], %447 := 2#64, %492 :=
    (Vector.replicate 4 PoisonOr.poison).set 3 (PoisonOr.value 18446744073709551615#64) (by decide)]

/-- The constants, `in0 … in7`. -/
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
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 55 := in0,
              rir_reg% fd_curve25519_scalar_reduce.hty 57 := in1,
              rir_reg% fd_curve25519_scalar_reduce.hty 59 := in2,
              rir_reg% fd_curve25519_scalar_reduce.hty 61 := in3,
              rir_reg% fd_curve25519_scalar_reduce.hty 63 := in4,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := in5,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := in6,
              rir_reg% fd_curve25519_scalar_reduce.hty 69 := in7]) →
          (hin0 : in0 = (S.mem.readAt inp 512).extractLsb' 0 64) →
          (hin1 : in1 = (S.mem.readAt inp 512).extractLsb' 64 64) →
          (hin2 : in2 = (S.mem.readAt inp 512).extractLsb' 128 64) →
          (hin3 : in3 = (S.mem.readAt inp 512).extractLsb' 192 64) →
          (hin4 : in4 = (S.mem.readAt inp 512).extractLsb' 256 64) →
          (hin5 : in5 = (S.mem.readAt inp 512).extractLsb' 320 64) →
          (hin6 : in6 = (S.mem.readAt inp 512).extractLsb' 384 64) →
          (hin7 : in7 = (S.mem.readAt inp 512).extractLsb' 448 64) →
          (blk.runBodyFrom E' 70 S >>= g) = K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  iterate 55 step_pure
  step_call using fd_ulong_load_8.call_eq with in0
  step_pure
  step_call using fd_ulong_load_8.call_eq with in1
  step_pure
  step_call using fd_ulong_load_8.call_eq with in2
  step_pure
  step_call using fd_ulong_load_8.call_eq with in3
  step_pure
  step_call using fd_ulong_load_8.call_eq with in4
  step_pure
  step_call using fd_ulong_load_8.call_eq with in5
  step_pure
  step_call using fd_ulong_load_8.call_eq with in6
  step_pure
  step_call using fd_ulong_load_8.call_eq with in7
  subst hS
  exact
    hK _ in0 in1 in2 in3 in4 in5 in6 in7 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) (hin0.trans (BitVec.setWidth_eq_extractLsb' (by decide))) hin1 hin2 hin3 hin4
      hin5 hin6 hin7

/-- Instructions `70` to `103`. -/
theorem fd_curve25519_scalar_reduce.run70 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 70 = fd_curve25519_scalar_reduce.entry.body.drop 70)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in0 in1 in2 in3 in4 in5 in6 in7 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 55 := in0,
        rir_reg% fd_curve25519_scalar_reduce.hty 57 := in1,
        rir_reg% fd_curve25519_scalar_reduce.hty 59 := in2,
        rir_reg% fd_curve25519_scalar_reduce.hty 61 := in3,
        rir_reg% fd_curve25519_scalar_reduce.hty 63 := in4,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := in5,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := in6,
        rir_reg% fd_curve25519_scalar_reduce.hty 69 := in7])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s0 s1 s2 s4 s5 s3 s6 s7 s8 s10 s11 s9 t541 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := in4,
              rir_reg% fd_curve25519_scalar_reduce.hty 65 := in5,
              rir_reg% fd_curve25519_scalar_reduce.hty 67 := in6,
              rir_reg% fd_curve25519_scalar_reduce.hty 69 := in7,
              rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 87 := s6,
              rir_reg% fd_curve25519_scalar_reduce.hty 89 := s7,
              rir_reg% fd_curve25519_scalar_reduce.hty 91 := s8,
              rir_reg% fd_curve25519_scalar_reduce.hty 93 := s10,
              rir_reg% fd_curve25519_scalar_reduce.hty 95 := s11,
              rir_reg% fd_curve25519_scalar_reduce.hty 102 := s9,
              rir_reg% fd_curve25519_scalar_reduce.hty 103 := t541]) →
          (hs0 : s0 = in0 &&& 2097151#64) →
          (hs1 : s1 = in0 >>> 21 &&& 2097151#64) →
          (hs2 : s2 = in0 >>> 42 &&& 2097151#64) →
          (hs4 : s4 = in1 >>> 20 &&& 2097151#64) →
          (hs5 : s5 = in1 >>> 41 &&& 2097151#64) →
          (hs3 : s3 = BitVec.extractLsb' 64 64 ((in1 ++ in0) <<< 1) &&& 2097151#64) →
          (hs6 : s6 = BitVec.extractLsb' 64 64 ((in2 ++ in1) <<< 2) &&& 2097151#64) →
          (hs7 : s7 = in2 >>> 19 &&& 2097151#64) →
          (hs8 : s8 = in2 >>> 40 &&& 2097151#64) →
          (hs10 : s10 = in3 >>> 18 &&& 2097151#64) →
          (hs11 : s11 = in3 >>> 39 &&& 2097151#64) →
          (hs9 : s9 = BitVec.extractLsb' 64 64 ((in3 ++ in2) <<< 3) &&& 2097151#64) →
          (ht541 : t541 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4)) →
          (hbs0 : Bnd s0 0 2097151) →
          (hbs1 : Bnd s1 0 2097151) →
          (hbs2 : Bnd s2 0 2097151) →
          (hbs4 : Bnd s4 0 2097151) →
          (hbs5 : Bnd s5 0 2097151) →
          (hbs3 : Bnd s3 0 2097151) →
          (hbs6 : Bnd s6 0 2097151) →
          (hbs7 : Bnd s7 0 2097151) →
          (hbs8 : Bnd s8 0 2097151) →
          (hbs10 : Bnd s10 0 2097151) →
          (hbs11 : Bnd s11 0 2097151) →
          (hbs9 : Bnd s9 0 2097151) →
          (hbt541 : Bnd t541 (-9223372036854775808) 9223372036854775807) →
          (blk.runBodyFrom E' 104 S >>= g) = K) :
    (blk.runBodyFrom E 70 S >>= g) = K := by
  step_pure with s0
  bnd s0
  step_pure
  step_pure with s1
  bnd s1
  step_pure
  step_pure with s2
  bnd s2
  step_pure
  step_pure with s4
  bnd s4
  step_pure
  step_pure with s5
  bnd s5
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with s3
  bnd s3
  step_pure
  step_pure with s6
  bnd s6
  step_pure
  step_pure with s7
  bnd s7
  step_pure
  step_pure with s8
  bnd s8
  step_pure
  step_pure with s10
  bnd s10
  step_pure
  step_pure with s11
  bnd s11
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with s9
  bnd s9
  step_pure with t541
  bnd t541
  exact
    hK _ s0 s1 s2 s4 s5 s3 s6 s7 s8 s10 s11 s9 t541 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) hs0 hs1 hs2 hs4 hs5 hs3 hs6 hs7 hs8 hs10 hs11 hs9 ht541 hbs0 hbs1 hbs2 hbs4
      hbs5 hbs3 hbs6 hbs7 hbs8 hbs10 hbs11 hbs9 hbt541

/-- Instructions `104` to `129`. -/
theorem fd_curve25519_scalar_reduce.run104 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 104 = fd_curve25519_scalar_reduce.entry.body.drop 104)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in4 in5 in6 in7 s0 s1 s2 s4 s5 s3 s6 s7 s8 s10 s11 s9 t541 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 63 := in4,
        rir_reg% fd_curve25519_scalar_reduce.hty 65 := in5,
        rir_reg% fd_curve25519_scalar_reduce.hty 67 := in6,
        rir_reg% fd_curve25519_scalar_reduce.hty 69 := in7,
        rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 87 := s6,
        rir_reg% fd_curve25519_scalar_reduce.hty 89 := s7,
        rir_reg% fd_curve25519_scalar_reduce.hty 91 := s8,
        rir_reg% fd_curve25519_scalar_reduce.hty 93 := s10,
        rir_reg% fd_curve25519_scalar_reduce.hty 95 := s11,
        rir_reg% fd_curve25519_scalar_reduce.hty 102 := s9,
        rir_reg% fd_curve25519_scalar_reduce.hty 103 := t541])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s12 s13 s14 s16 s17 s15 s18 s19 s20 s21 s22 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 69 := in7,
              rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 87 := s6,
              rir_reg% fd_curve25519_scalar_reduce.hty 89 := s7,
              rir_reg% fd_curve25519_scalar_reduce.hty 91 := s8,
              rir_reg% fd_curve25519_scalar_reduce.hty 93 := s10,
              rir_reg% fd_curve25519_scalar_reduce.hty 95 := s11,
              rir_reg% fd_curve25519_scalar_reduce.hty 102 := s9,
              rir_reg% fd_curve25519_scalar_reduce.hty 104 := s12,
              rir_reg% fd_curve25519_scalar_reduce.hty 106 := s13,
              rir_reg% fd_curve25519_scalar_reduce.hty 108 := s14,
              rir_reg% fd_curve25519_scalar_reduce.hty 110 := s16,
              rir_reg% fd_curve25519_scalar_reduce.hty 112 := s17,
              rir_reg% fd_curve25519_scalar_reduce.hty 119 := s15,
              rir_reg% fd_curve25519_scalar_reduce.hty 121 := s18,
              rir_reg% fd_curve25519_scalar_reduce.hty 123 := s19,
              rir_reg% fd_curve25519_scalar_reduce.hty 125 := s20,
              rir_reg% fd_curve25519_scalar_reduce.hty 127 := s21,
              rir_reg% fd_curve25519_scalar_reduce.hty 129 := s22]) →
          (hs12 : s12 = t541 &&& 2097151#64) →
          (hs13 : s13 = in4 >>> 17 &&& 2097151#64) →
          (hs14 : s14 = in4 >>> 38 &&& 2097151#64) →
          (hs16 : s16 = in5 >>> 16 &&& 2097151#64) →
          (hs17 : s17 = in5 >>> 37 &&& 2097151#64) →
          (hs15 : s15 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5) &&& 2097151#64) →
          (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64) →
          (hs19 : s19 = in6 >>> 15 &&& 2097151#64) →
          (hs20 : s20 = in6 >>> 36 &&& 2097151#64) →
          (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) →
          (hs22 : s22 = in7 >>> 14 &&& 2097151#64) →
          (hbs12 : Bnd s12 0 2097151) →
          (hbs13 : Bnd s13 0 2097151) →
          (hbs14 : Bnd s14 0 2097151) →
          (hbs16 : Bnd s16 0 2097151) →
          (hbs17 : Bnd s17 0 2097151) →
          (hbs15 : Bnd s15 0 2097151) →
          (hbs18 : Bnd s18 0 2097151) →
          (hbs19 : Bnd s19 0 2097151) →
          (hbs20 : Bnd s20 0 2097151) →
          (hbs21 : Bnd s21 0 2097151) →
          (hbs22 : Bnd s22 0 2097151) → (blk.runBodyFrom E' 130 S >>= g) = K) :
    (blk.runBodyFrom E 104 S >>= g) = K := by
  step_pure with s12
  bnd s12
  step_pure
  step_pure with s13
  bnd s13
  step_pure
  step_pure with s14
  bnd s14
  step_pure
  step_pure with s16
  bnd s16
  step_pure
  step_pure with s17
  bnd s17
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with s15
  bnd s15
  step_pure
  step_pure with s18
  bnd s18
  step_pure
  step_pure with s19
  bnd s19
  step_pure
  step_pure with s20
  bnd s20
  step_pure
  step_pure with s21
  bnd s21
  step_pure
  step_pure with s22
  bnd s22
  exact
    hK _ s12 s13 s14 s16 s17 s15 s18 s19 s20 s21 s22 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) hs12 hs13 hs14 hs16 hs17 hs15 hs18 hs19 hs20 hs21 hs22 hbs12 hbs13 hbs14 hbs16
      hbs17 hbs15 hbs18 hbs19 hbs20 hbs21 hbs22

/-- Instructions `130` to `159`. -/
theorem fd_curve25519_scalar_reduce.run130 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 130 = fd_curve25519_scalar_reduce.entry.body.drop 130)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {in7 s0 s1 s2 s4 s5 s3 s6 s7 s8 s10 s11 s9 s12 s13 s14 s16 s17 s15 s18 s19 s20 s21 s22 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 69 := in7,
        rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 87 := s6,
        rir_reg% fd_curve25519_scalar_reduce.hty 89 := s7,
        rir_reg% fd_curve25519_scalar_reduce.hty 91 := s8,
        rir_reg% fd_curve25519_scalar_reduce.hty 93 := s10,
        rir_reg% fd_curve25519_scalar_reduce.hty 95 := s11,
        rir_reg% fd_curve25519_scalar_reduce.hty 102 := s9,
        rir_reg% fd_curve25519_scalar_reduce.hty 104 := s12,
        rir_reg% fd_curve25519_scalar_reduce.hty 106 := s13,
        rir_reg% fd_curve25519_scalar_reduce.hty 108 := s14,
        rir_reg% fd_curve25519_scalar_reduce.hty 110 := s16,
        rir_reg% fd_curve25519_scalar_reduce.hty 112 := s17,
        rir_reg% fd_curve25519_scalar_reduce.hty 119 := s15,
        rir_reg% fd_curve25519_scalar_reduce.hty 121 := s18,
        rir_reg% fd_curve25519_scalar_reduce.hty 123 := s19,
        rir_reg% fd_curve25519_scalar_reduce.hty 125 := s20,
        rir_reg% fd_curve25519_scalar_reduce.hty 127 := s21,
        rir_reg% fd_curve25519_scalar_reduce.hty 129 := s22])
    (hbs8 : Bnd s8 0 2097151) (hbs11 : Bnd s11 0 2097151) (hbs12 : Bnd s12 0 2097151)
    (hbs13 : Bnd s13 0 2097151) (hbs14 : Bnd s14 0 2097151) (hbs16 : Bnd s16 0 2097151)
    (hbs15 : Bnd s15 0 2097151) (hbs20 : Bnd s20 0 2097151) (hbs21 : Bnd s21 0 2097151)
    (hbs22 : Bnd s22 0 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s23 t570 t572 t574 t580 t581 t582 t583 t584 t588 t589 t590 t591 t592 t593 t595 t597 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 87 := s6,
              rir_reg% fd_curve25519_scalar_reduce.hty 89 := s7,
              rir_reg% fd_curve25519_scalar_reduce.hty 93 := s10,
              rir_reg% fd_curve25519_scalar_reduce.hty 102 := s9,
              rir_reg% fd_curve25519_scalar_reduce.hty 112 := s17,
              rir_reg% fd_curve25519_scalar_reduce.hty 121 := s18,
              rir_reg% fd_curve25519_scalar_reduce.hty 123 := s19,
              rir_reg% fd_curve25519_scalar_reduce.hty 125 := s20,
              rir_reg% fd_curve25519_scalar_reduce.hty 132 := t570,
              rir_reg% fd_curve25519_scalar_reduce.hty 134 := t572,
              rir_reg% fd_curve25519_scalar_reduce.hty 136 := t574,
              rir_reg% fd_curve25519_scalar_reduce.hty 142 := t580,
              rir_reg% fd_curve25519_scalar_reduce.hty 143 := t581,
              rir_reg% fd_curve25519_scalar_reduce.hty 144 := t582,
              rir_reg% fd_curve25519_scalar_reduce.hty 145 := t583,
              rir_reg% fd_curve25519_scalar_reduce.hty 146 := t584,
              rir_reg% fd_curve25519_scalar_reduce.hty 150 := t588,
              rir_reg% fd_curve25519_scalar_reduce.hty 151 := t589,
              rir_reg% fd_curve25519_scalar_reduce.hty 152 := t590,
              rir_reg% fd_curve25519_scalar_reduce.hty 153 := t591,
              rir_reg% fd_curve25519_scalar_reduce.hty 154 := t592,
              rir_reg% fd_curve25519_scalar_reduce.hty 155 := t593,
              rir_reg% fd_curve25519_scalar_reduce.hty 157 := t595,
              rir_reg% fd_curve25519_scalar_reduce.hty 159 := t597]) →
          (hs23 : s23 = in7 >>> 35) →
          (ht570 : t570 = s23 * 666643#64 + s11) →
          (ht572 : t572 = s23 * 470296#64 + s12) →
          (ht574 : t574 = s23 * 654183#64 + s13) →
          (ht580 : t580 = s23 * 18446744073708867715#64 + s16) →
          (ht581 : t581 = s22 * 666643#64) →
          (ht582 : t582 = s22 * 470296#64) →
          (ht583 : t583 = s22 * 654183#64) →
          (ht584 : t584 = s22 * 18446744073708553811#64) →
          (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64) →
          (ht589 : t589 = s21 * 666643#64) →
          (ht590 : t590 = s21 * 470296#64) →
          (ht591 : t591 = s21 * 654183#64) →
          (ht592 : t592 = s21 * 18446744073708553811#64) →
          (ht593 : t593 = s21 * 136657#64) →
          (ht595 :
            t595 =
              s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 +
                s21 * 18446744073708867715#64) →
          (ht597 : t597 = s20 * 666643#64 + s8) →
          (hbs23 : Bnd s23 0 536870911) →
          (hbt570 : Bnd t570 0 357901236818924) →
          (hbt572 : Bnd t572 0 252488244056807) →
          (hbt574 : Bnd t574 0 351211825267864) →
          (hbt580 : Bnd t580 (-367166552903811) 2097151) →
          (hbt581 : Bnd t581 0 1398051034093) →
          (hbt582 : Bnd t582 0 986281726696) →
          (hbt583 : Bnd t583 0 1371920532633) →
          (hbt584 : Bnd t584 (-2092547753555) 0) →
          (hbt588 : Bnd t588 (-1434243666051) 73367170181678) →
          (hbt589 : Bnd t589 0 1398051034093) →
          (hbt590 : Bnd t590 0 986281726696) →
          (hbt591 : Bnd t591 0 1371920532633) →
          (hbt592 : Bnd t592 (-2092547753555) 0) →
          (hbt593 : Bnd t593 0 286590364207) →
          (hbt595 : Bnd t595 (-537126723016406) 286592461358) →
          (hbt597 : Bnd t597 0 1398053131244) → (blk.runBodyFrom E' 160 S >>= g) = K) :
    (blk.runBodyFrom E 130 S >>= g) = K := by
  step_pure with s23
  bnd s23
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd] with t570
  bnd t570
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd] with t572
  bnd t572
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd] with t574
  bnd t574
  step_pure [nswMul]
  step_pure [nswAdd]
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswMul]
  step_pure [nswAdd] with t580
  bnd t580
  step_pure [nswMul, nuwMul] with t581
  bnd t581
  step_pure [nswMul, nuwMul] with t582
  bnd t582
  step_pure [nswMul, nuwMul] with t583
  bnd t583
  step_pure [nswMul] with t584
  bnd t584
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd]
  step_pure [nswMul]
  step_pure [nswAdd] with t588
  bnd t588
  step_pure [nswMul, nuwMul] with t589
  bnd t589
  step_pure [nswMul, nuwMul] with t590
  bnd t590
  step_pure [nswMul, nuwMul] with t591
  bnd t591
  step_pure [nswMul] with t592
  bnd t592
  step_pure [nswMul, nuwMul] with t593
  bnd t593
  step_pure [nswMul]
  step_pure [nswAdd] with t595
  bnd t595
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd] with t597
  bnd t597
  exact
    hK _ s23 t570 t572 t574 t580 t581 t582 t583 t584 t588 t589 t590 t591 t592 t593 t595 t597 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) hs23 ht570 ht572 ht574 ht580 ht581 ht582 ht583 ht584 ht588 ht589 ht590 ht591
      ht592 ht593 ht595 ht597 hbs23 hbt570 hbt572 hbt574 hbt580 hbt581 hbt582 hbt583 hbt584 hbt588
      hbt589 hbt590 hbt591 hbt592 hbt593 hbt595 hbt597

/-- Instructions `160` to `189`. -/
theorem fd_curve25519_scalar_reduce.run160 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 160 = fd_curve25519_scalar_reduce.entry.body.drop 160)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s4 s5 s3 s6 s7 s10 s9 s17 s18 s19 s20 t570 t572 t574 t580 t581 t582 t583 t584 t588
      t589 t590 t591 t592 t593 t595 t597 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 87 := s6,
        rir_reg% fd_curve25519_scalar_reduce.hty 89 := s7,
        rir_reg% fd_curve25519_scalar_reduce.hty 93 := s10,
        rir_reg% fd_curve25519_scalar_reduce.hty 102 := s9,
        rir_reg% fd_curve25519_scalar_reduce.hty 112 := s17,
        rir_reg% fd_curve25519_scalar_reduce.hty 121 := s18,
        rir_reg% fd_curve25519_scalar_reduce.hty 123 := s19,
        rir_reg% fd_curve25519_scalar_reduce.hty 125 := s20,
        rir_reg% fd_curve25519_scalar_reduce.hty 132 := t570,
        rir_reg% fd_curve25519_scalar_reduce.hty 134 := t572,
        rir_reg% fd_curve25519_scalar_reduce.hty 136 := t574,
        rir_reg% fd_curve25519_scalar_reduce.hty 142 := t580,
        rir_reg% fd_curve25519_scalar_reduce.hty 143 := t581,
        rir_reg% fd_curve25519_scalar_reduce.hty 144 := t582,
        rir_reg% fd_curve25519_scalar_reduce.hty 145 := t583,
        rir_reg% fd_curve25519_scalar_reduce.hty 146 := t584,
        rir_reg% fd_curve25519_scalar_reduce.hty 150 := t588,
        rir_reg% fd_curve25519_scalar_reduce.hty 151 := t589,
        rir_reg% fd_curve25519_scalar_reduce.hty 152 := t590,
        rir_reg% fd_curve25519_scalar_reduce.hty 153 := t591,
        rir_reg% fd_curve25519_scalar_reduce.hty 154 := t592,
        rir_reg% fd_curve25519_scalar_reduce.hty 155 := t593,
        rir_reg% fd_curve25519_scalar_reduce.hty 157 := t595,
        rir_reg% fd_curve25519_scalar_reduce.hty 159 := t597])
    (hbs6 : Bnd s6 0 2097151) (hbs7 : Bnd s7 0 2097151) (hbs10 : Bnd s10 0 2097151)
    (hbs18 : Bnd s18 0 2097151) (hbs19 : Bnd s19 0 2097151) (hbs20 : Bnd s20 0 2097151)
    (hbt572 : Bnd t572 0 252488244056807) (hbt581 : Bnd t581 0 1398051034093)
    (hbt583 : Bnd t583 0 1371920532633) (hbt590 : Bnd t590 0 986281726696)
    (hbt592 : Bnd t592 (-2092547753555) 0) (hbt597 : Bnd t597 0 1398053131244)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t598 t600 t602 t607 t609 t614 t616 t618 t620 t621 t627 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 102 := s9,
              rir_reg% fd_curve25519_scalar_reduce.hty 112 := s17,
              rir_reg% fd_curve25519_scalar_reduce.hty 121 := s18,
              rir_reg% fd_curve25519_scalar_reduce.hty 132 := t570,
              rir_reg% fd_curve25519_scalar_reduce.hty 136 := t574,
              rir_reg% fd_curve25519_scalar_reduce.hty 142 := t580,
              rir_reg% fd_curve25519_scalar_reduce.hty 144 := t582,
              rir_reg% fd_curve25519_scalar_reduce.hty 146 := t584,
              rir_reg% fd_curve25519_scalar_reduce.hty 150 := t588,
              rir_reg% fd_curve25519_scalar_reduce.hty 151 := t589,
              rir_reg% fd_curve25519_scalar_reduce.hty 153 := t591,
              rir_reg% fd_curve25519_scalar_reduce.hty 155 := t593,
              rir_reg% fd_curve25519_scalar_reduce.hty 157 := t595,
              rir_reg% fd_curve25519_scalar_reduce.hty 160 := t598,
              rir_reg% fd_curve25519_scalar_reduce.hty 162 := t600,
              rir_reg% fd_curve25519_scalar_reduce.hty 164 := t602,
              rir_reg% fd_curve25519_scalar_reduce.hty 169 := t607,
              rir_reg% fd_curve25519_scalar_reduce.hty 171 := t609,
              rir_reg% fd_curve25519_scalar_reduce.hty 176 := t614,
              rir_reg% fd_curve25519_scalar_reduce.hty 178 := t616,
              rir_reg% fd_curve25519_scalar_reduce.hty 180 := t618,
              rir_reg% fd_curve25519_scalar_reduce.hty 182 := t620,
              rir_reg% fd_curve25519_scalar_reduce.hty 183 := t621,
              rir_reg% fd_curve25519_scalar_reduce.hty 189 := t627]) →
          (ht598 : t598 = s20 * 470296#64) →
          (ht600 : t600 = s20 * 18446744073708553811#64) →
          (ht602 : t602 = s20 * 18446744073708867715#64) →
          (ht607 : t607 = s19 * 654183#64) →
          (ht609 : t609 = s19 * 136657#64) →
          (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592) →
          (ht616 : t616 = s18 * 666643#64 + s6) →
          (ht618 : t618 = s19 * 666643#64 + s7 + s18 * 470296#64) →
          (ht620 : t620 = t597 + s19 * 470296#64 + s18 * 654183#64) →
          (ht621 : t621 = s18 * 18446744073708553811#64) →
          (ht627 :
            t627 =
              s20 * 654183#64 + s10 + s19 * 18446744073708553811#64 + s18 * 136657#64 + t581 +
                t590) →
          (hbt598 : Bnd t598 0 986281726696) →
          (hbt600 : Bnd t600 (-2092547753555) 0) →
          (hbt602 : Bnd t602 (-1434243666051) 0) →
          (hbt607 : Bnd t607 0 1371920532633) →
          (hbt609 : Bnd t609 0 286590364207) →
          (hbt614 : Bnd t614 (-3526791419606) 254146754953647) →
          (hbt616 : Bnd t616 0 1398053131244) →
          (hbt618 : Bnd t618 0 2384334857940) →
          (hbt620 : Bnd t620 0 3756255390573) →
          (hbt621 : Bnd t621 (-2092547753555) 0) →
          (hbt627 : Bnd t627 (-2092547753555) 4042845754780) →
          (blk.runBodyFrom E' 190 S >>= g) = K) :
    (blk.runBodyFrom E 160 S >>= g) = K := by
  step_pure [nswMul, nuwMul] with t598
  bnd t598
  step_pure [nswMul, nuwMul]
  step_pure [nswMul] with t600
  bnd t600
  step_pure [nswMul, nuwMul]
  step_pure [nswMul] with t602
  bnd t602
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswMul, nuwMul] with t607
  bnd t607
  step_pure [nswMul]
  step_pure [nswMul, nuwMul] with t609
  bnd t609
  step_pure [nswMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd] with t614
  bnd t614
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd] with t616
  bnd t616
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd] with t618
  bnd t618
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd] with t620
  bnd t620
  step_pure [nswMul] with t621
  bnd t621
  step_pure [nswMul, nuwMul]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd] with t627
  bnd t627
  exact
    hK _ t598 t600 t602 t607 t609 t614 t616 t618 t620 t621 t627 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) ht598 ht600 ht602 ht607 ht609 ht614 ht616 ht618 ht620 ht621 ht627 hbt598 hbt600
      hbt602 hbt607 hbt609 hbt614 hbt616 hbt618 hbt620 hbt621 hbt627

/-- Instructions `190` to `214`. -/
theorem fd_curve25519_scalar_reduce.run190 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 190 = fd_curve25519_scalar_reduce.entry.body.drop 190)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s4 s5 s3 s9 s17 s18 t570 t574 t580 t582 t584 t588 t589 t591 t593 t595 t598 t600 t602
      t607 t609 t614 t616 t618 t620 t621 t627 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 102 := s9,
        rir_reg% fd_curve25519_scalar_reduce.hty 112 := s17,
        rir_reg% fd_curve25519_scalar_reduce.hty 121 := s18,
        rir_reg% fd_curve25519_scalar_reduce.hty 132 := t570,
        rir_reg% fd_curve25519_scalar_reduce.hty 136 := t574,
        rir_reg% fd_curve25519_scalar_reduce.hty 142 := t580,
        rir_reg% fd_curve25519_scalar_reduce.hty 144 := t582,
        rir_reg% fd_curve25519_scalar_reduce.hty 146 := t584,
        rir_reg% fd_curve25519_scalar_reduce.hty 150 := t588,
        rir_reg% fd_curve25519_scalar_reduce.hty 151 := t589,
        rir_reg% fd_curve25519_scalar_reduce.hty 153 := t591,
        rir_reg% fd_curve25519_scalar_reduce.hty 155 := t593,
        rir_reg% fd_curve25519_scalar_reduce.hty 157 := t595,
        rir_reg% fd_curve25519_scalar_reduce.hty 160 := t598,
        rir_reg% fd_curve25519_scalar_reduce.hty 162 := t600,
        rir_reg% fd_curve25519_scalar_reduce.hty 164 := t602,
        rir_reg% fd_curve25519_scalar_reduce.hty 169 := t607,
        rir_reg% fd_curve25519_scalar_reduce.hty 171 := t609,
        rir_reg% fd_curve25519_scalar_reduce.hty 176 := t614,
        rir_reg% fd_curve25519_scalar_reduce.hty 178 := t616,
        rir_reg% fd_curve25519_scalar_reduce.hty 180 := t618,
        rir_reg% fd_curve25519_scalar_reduce.hty 182 := t620,
        rir_reg% fd_curve25519_scalar_reduce.hty 183 := t621,
        rir_reg% fd_curve25519_scalar_reduce.hty 189 := t627])
    (hbs9 : Bnd s9 0 2097151) (hbs18 : Bnd s18 0 2097151) (hbt570 : Bnd t570 0 357901236818924)
    (hbt582 : Bnd t582 0 986281726696) (hbt589 : Bnd t589 0 1398051034093)
    (hbt591 : Bnd t591 0 1371920532633) (hbt598 : Bnd t598 0 986281726696)
    (hbt600 : Bnd t600 (-2092547753555) 0) (hbt607 : Bnd t607 0 1371920532633)
    (hbt609 : Bnd t609 0 286590364207) (hbt614 : Bnd t614 (-3526791419606) 254146754953647)
    (hbt616 : Bnd t616 0 1398053131244) (hbt618 : Bnd t618 0 2384334857940)
    (hbt620 : Bnd t620 0 3756255390573) (hbt621 : Bnd t621 (-2092547753555) 0)
    (hbt627 : Bnd t627 (-2092547753555) 4042845754780)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry6 t631 t633 carry8 t640 t642 carry10 t650 t651 t652 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 112 := s17,
              rir_reg% fd_curve25519_scalar_reduce.hty 136 := t574,
              rir_reg% fd_curve25519_scalar_reduce.hty 142 := t580,
              rir_reg% fd_curve25519_scalar_reduce.hty 146 := t584,
              rir_reg% fd_curve25519_scalar_reduce.hty 150 := t588,
              rir_reg% fd_curve25519_scalar_reduce.hty 155 := t593,
              rir_reg% fd_curve25519_scalar_reduce.hty 157 := t595,
              rir_reg% fd_curve25519_scalar_reduce.hty 164 := t602,
              rir_reg% fd_curve25519_scalar_reduce.hty 176 := t614,
              rir_reg% fd_curve25519_scalar_reduce.hty 189 := t627,
              rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
              rir_reg% fd_curve25519_scalar_reduce.hty 195 := t633,
              rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
              rir_reg% fd_curve25519_scalar_reduce.hty 204 := t642,
              rir_reg% fd_curve25519_scalar_reduce.hty 212 := t650,
              rir_reg% fd_curve25519_scalar_reduce.hty 213 := t651,
              rir_reg% fd_curve25519_scalar_reduce.hty 214 := t652]) →
          (hcarry6 : carry6 = (t616 + 1048576#64).sshiftRight 21) →
          (ht631 : t631 = t618 + carry6) →
          (ht633 : t633 = t616 - carry6 <<< 21) →
          (hcarry8 : carry8 = (t620 + 1048576#64).sshiftRight 21) →
          (ht640 : t640 = t598 + s9 + t607 + t621 + t589 + carry8) →
          (ht642 : t642 = t620 - carry8 <<< 21) →
          (hcarry10 : carry10 = (t627 + 1048576#64).sshiftRight 21) →
          (ht650 :
            t650 = t570 + t600 + t609 + s18 * 18446744073708867715#64 + t582 + t591 + carry10) →
          (ht651 : t651 = t627 + 1048576#64 &&& 18446744073707454464#64) →
          (ht652 : t652 = t614 + 1048576#64) →
          (hbcarry6 : Bnd carry6 0 666644) →
          (hbt631 : Bnd t631 0 2384335524584) →
          (hbt633 : Bnd t633 (-1048576) 1048575) →
          (hbcarry8 : Bnd carry8 0 1791122) →
          (hbt640 : Bnd t640 (-2092547753555) 3756257181695) →
          (hbt642 : Bnd t642 (-1048576) 1048575) →
          (hbcarry10 : Bnd carry10 (-997805) 1927779) →
          (hbt650 : Bnd t650 (-3526792417411) 360546031370239) →
          (hbt651 : Bnd t651 (-2092548751360) 4042845585408) →
          (hbt652 : Bnd t652 (-3526790371030) 254146756002223) →
          (blk.runBodyFrom E' 215 S >>= g) = K) :
    (blk.runBodyFrom E 190 S >>= g) = K := by
  step_pure [nswMul]
  step_pure [nswAdd, nuwAdd]
  -- carry6 = (s6 + (1L << 20)) >> 21;
  step_pure with carry6
  bnd carry6
  step_pure [nswAdd, nuwAdd] with t631
  bnd t631
  step_pure
  step_pure [nswSub] with t633
  bnd t633
  step_pure [nswAdd, nuwAdd]
  -- carry8 = (s8 + (1L << 20)) >> 21;
  step_pure with carry8
  bnd carry8
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd, nuwAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd] with t640
  bnd t640
  step_pure
  step_pure [nswSub] with t642
  bnd t642
  step_pure [nswAdd]
  -- carry10 = (s10 + (1L << 20)) >> 21;
  step_pure with carry10
  bnd carry10
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd] with t650
  bnd t650
  step_pure with t651
  bnd t651
  step_pure [nswAdd] with t652
  bnd t652
  simp only [lshrNonneg] at hcarry6
  simp only [lshrNonneg] at hcarry8
  simp only [andMask] at ht633
  rw [← hcarry6] at ht633
  simp only [andMask] at ht642
  rw [← hcarry8] at ht642
  exact
    hK _ carry6 t631 t633 carry8 t640 t642 carry10 t650 t651 t652 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) hcarry6 ht631 ht633 hcarry8 ht640 ht642 hcarry10 ht650 ht651 ht652 hbcarry6
      hbt631 hbt633 hbcarry8 hbt640 hbt642 hbcarry10 hbt650 hbt651 hbt652

/-- Instructions `215` to `244`. -/
theorem fd_curve25519_scalar_reduce.run215 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 215 = fd_curve25519_scalar_reduce.entry.body.drop 215)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s4 s5 s3 s17 t574 t580 t584 t588 t593 t595 t602 t614 t627 t631 t633 t640 t642 t650
      t651 t652 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 112 := s17,
        rir_reg% fd_curve25519_scalar_reduce.hty 136 := t574,
        rir_reg% fd_curve25519_scalar_reduce.hty 142 := t580,
        rir_reg% fd_curve25519_scalar_reduce.hty 146 := t584,
        rir_reg% fd_curve25519_scalar_reduce.hty 150 := t588,
        rir_reg% fd_curve25519_scalar_reduce.hty 155 := t593,
        rir_reg% fd_curve25519_scalar_reduce.hty 157 := t595,
        rir_reg% fd_curve25519_scalar_reduce.hty 164 := t602,
        rir_reg% fd_curve25519_scalar_reduce.hty 176 := t614,
        rir_reg% fd_curve25519_scalar_reduce.hty 189 := t627,
        rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
        rir_reg% fd_curve25519_scalar_reduce.hty 195 := t633,
        rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
        rir_reg% fd_curve25519_scalar_reduce.hty 204 := t642,
        rir_reg% fd_curve25519_scalar_reduce.hty 212 := t650,
        rir_reg% fd_curve25519_scalar_reduce.hty 213 := t651,
        rir_reg% fd_curve25519_scalar_reduce.hty 214 := t652])
    (hbs17 : Bnd s17 0 2097151) (hbt574 : Bnd t574 0 351211825267864)
    (hbt580 : Bnd t580 (-367166552903811) 2097151) (hbt584 : Bnd t584 (-2092547753555) 0)
    (hbt588 : Bnd t588 (-1434243666051) 73367170181678) (hbt593 : Bnd t593 0 286590364207)
    (hbt595 : Bnd t595 (-537126723016406) 286592461358) (hbt602 : Bnd t602 (-1434243666051) 0)
    (hbt614 : Bnd t614 (-3526791419606) 254146754953647) (hbt631 : Bnd t631 0 2384335524584)
    (hbt640 : Bnd t640 (-2092547753555) 3756257181695)
    (hbt650 : Bnd t650 (-3526792417411) 360546031370239)
    (hbt652 : Bnd t652 (-3526790371030) 254146756002223)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (carry12 t657 carry14 t662 t664 carry16 t667 t669 carry7 t672 carry9 t675 carry11 t678 t680
          t681 carry13 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
              rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
              rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
              rir_reg% fd_curve25519_scalar_reduce.hty 189 := t627,
              rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
              rir_reg% fd_curve25519_scalar_reduce.hty 195 := t633,
              rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
              rir_reg% fd_curve25519_scalar_reduce.hty 204 := t642,
              rir_reg% fd_curve25519_scalar_reduce.hty 213 := t651,
              rir_reg% fd_curve25519_scalar_reduce.hty 219 := t657,
              rir_reg% fd_curve25519_scalar_reduce.hty 224 := t662,
              rir_reg% fd_curve25519_scalar_reduce.hty 226 := t664,
              rir_reg% fd_curve25519_scalar_reduce.hty 229 := t667,
              rir_reg% fd_curve25519_scalar_reduce.hty 231 := t669,
              rir_reg% fd_curve25519_scalar_reduce.hty 233 := carry7,
              rir_reg% fd_curve25519_scalar_reduce.hty 234 := t672,
              rir_reg% fd_curve25519_scalar_reduce.hty 236 := carry9,
              rir_reg% fd_curve25519_scalar_reduce.hty 237 := t675,
              rir_reg% fd_curve25519_scalar_reduce.hty 240 := t678,
              rir_reg% fd_curve25519_scalar_reduce.hty 242 := t680,
              rir_reg% fd_curve25519_scalar_reduce.hty 243 := t681,
              rir_reg% fd_curve25519_scalar_reduce.hty 244 := carry13]) →
          (hcarry12 : carry12 = t652.sshiftRight 21) →
          (ht657 : t657 = t574 + t602 + t584 + t593 + carry12) →
          (hcarry14 : carry14 = (t595 + 1048576#64).sshiftRight 21) →
          (ht662 : t662 = t588 + carry14) →
          (ht664 : t664 = t595 - carry14 <<< 21) →
          (hcarry16 : carry16 = (t580 + 1048576#64).sshiftRight 21) →
          (ht667 : t667 = carry16 + s17) →
          (ht669 : t669 = t580 - carry16 <<< 21) →
          (hcarry7 : carry7 = (t631 + 1048576#64).sshiftRight 21) →
          (ht672 : t672 = t631 + 1048576#64 &&& 9223372036852678656#64) →
          (hcarry9 : carry9 = (t640 + 1048576#64).sshiftRight 21) →
          (ht675 : t675 = t640 + 1048576#64 &&& 18446744073707454464#64) →
          (hcarry11 : carry11 = (t650 + 1048576#64).sshiftRight 21) →
          (ht678 : t678 = carry11 + (t614 - carry12 <<< 21)) →
          (ht680 : t680 = t650 - carry11 <<< 21) →
          (ht681 : t681 = t657 + 1048576#64) →
          (hcarry13 : carry13 = t681.sshiftRight 21) →
          (hbcarry12 : Bnd carry12 (-1681705) 121186616) →
          (hbt657 : Bnd t657 (-3526793101311) 351498536818687) →
          (hbcarry14 : Bnd carry14 (-256121980) 136658) →
          (hbt662 : Bnd t662 (-1434499788031) 73367170318336) →
          (hbt664 : Bnd t664 (-1048576) 1048575) →
          (hbcarry16 : Bnd carry16 (-175078656) 1) →
          (hbt667 : Bnd t667 (-175078656) 2097152) →
          (hbt669 : Bnd t669 (-1048576) 1048575) →
          (hbcarry7 : Bnd carry7 0 1136940) →
          (hbt672 : Bnd t672 0 2384335994880) →
          (hbcarry9 : Bnd carry9 (-997805) 1791123) →
          (hbt675 : Bnd t675 (-2092548751360) 3756257181696) →
          (hbcarry11 : Bnd carry11 (-1681706) 171921745) →
          (hbt678 : Bnd t678 (-257673547218944) 257673717879552) →
          (hbt680 : Bnd t680 (-1048576) 1048575) →
          (hbt681 : Bnd t681 (-3526792052735) 351498537867263) →
          (hbcarry13 : Bnd carry13 (-1681706) 167607563) → (blk.runBodyFrom E' 245 S >>= g) = K) :
    (blk.runBodyFrom E 215 S >>= g) = K := by
  -- carry12 = (s12 + (1L << 20)) >> 21;
  step_pure with carry12
  bnd carry12
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure [nswAdd] with t657
  bnd t657
  step_pure
  step_pure
  step_pure [nswAdd]
  -- carry14 = (s14 + (1L << 20)) >> 21;
  step_pure with carry14
  bnd carry14
  step_pure [nswAdd] with t662
  bnd t662
  step_pure
  step_pure with t664
  bnd t664
  step_pure [nswAdd]
  -- carry16 = (s16 + (1L << 20)) >> 21;
  step_pure with carry16
  bnd carry16
  step_pure [nswAdd] with t667
  bnd t667
  step_pure
  step_pure [nswSub] with t669
  bnd t669
  step_pure [nswAdd, nuwAdd]
  -- carry7 = (s7 + (1L << 20)) >> 21;
  step_pure with carry7
  bnd carry7
  step_pure with t672
  bnd t672
  step_pure [nswAdd]
  -- carry9 = (s9 + (1L << 20)) >> 21;
  step_pure with carry9
  bnd carry9
  step_pure with t675
  bnd t675
  step_pure [nswAdd]
  -- carry11 = (s11 + (1L << 20)) >> 21;
  step_pure with carry11
  bnd carry11
  step_pure with t678
  bnd t678
  step_pure
  step_pure with t680
  bnd t680
  step_pure [nswAdd] with t681
  bnd t681
  -- carry13 = (s13 + (1L << 20)) >> 21;
  step_pure with carry13
  bnd carry13
  simp only [lshrNonneg] at hcarry7
  simp only [Bnd.and_neg_shift] at ht664
  rw [← hcarry14] at ht664
  simp only [Bnd.and_neg_shift] at ht669
  rw [← hcarry16] at ht669
  simp only [Bnd.and_neg_shift] at ht678
  rw [← hcarry12] at ht678
  simp only [Bnd.and_neg_shift] at ht680
  rw [← hcarry11] at ht680
  exact
    hK _ carry12 t657 carry14 t662 t664 carry16 t667 t669 carry7 t672 carry9 t675 carry11 t678 t680
      t681 carry13 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) hcarry12 ht657 hcarry14 ht662 ht664 hcarry16 ht667 ht669 hcarry7 ht672 hcarry9
      ht675 hcarry11 ht678 ht680 ht681 hcarry13 hbcarry12 hbt657 hbcarry14 hbt662 hbt664 hbcarry16
      hbt667 hbt669 hbcarry7 hbt672 hbcarry9 hbt675 hbcarry11 hbt678 hbt680 hbt681 hbcarry13

/-- Instructions `245` to `274`. -/
theorem fd_curve25519_scalar_reduce.run245 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 245 = fd_curve25519_scalar_reduce.entry.body.drop 245)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 s4 s5 s3 t627 t631 t633 t640 t642 carry10 t651 t657 t662 t664 t667 t669 carry7 t672
      carry9 t675 t678 t680 t681 carry13 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 76 := s4,
        rir_reg% fd_curve25519_scalar_reduce.hty 78 := s5,
        rir_reg% fd_curve25519_scalar_reduce.hty 85 := s3,
        rir_reg% fd_curve25519_scalar_reduce.hty 189 := t627,
        rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
        rir_reg% fd_curve25519_scalar_reduce.hty 195 := t633,
        rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
        rir_reg% fd_curve25519_scalar_reduce.hty 204 := t642,
        rir_reg% fd_curve25519_scalar_reduce.hty 213 := t651,
        rir_reg% fd_curve25519_scalar_reduce.hty 219 := t657,
        rir_reg% fd_curve25519_scalar_reduce.hty 224 := t662,
        rir_reg% fd_curve25519_scalar_reduce.hty 226 := t664,
        rir_reg% fd_curve25519_scalar_reduce.hty 229 := t667,
        rir_reg% fd_curve25519_scalar_reduce.hty 231 := t669,
        rir_reg% fd_curve25519_scalar_reduce.hty 233 := carry7,
        rir_reg% fd_curve25519_scalar_reduce.hty 234 := t672,
        rir_reg% fd_curve25519_scalar_reduce.hty 236 := carry9,
        rir_reg% fd_curve25519_scalar_reduce.hty 237 := t675,
        rir_reg% fd_curve25519_scalar_reduce.hty 240 := t678,
        rir_reg% fd_curve25519_scalar_reduce.hty 242 := t680,
        rir_reg% fd_curve25519_scalar_reduce.hty 243 := t681,
        rir_reg% fd_curve25519_scalar_reduce.hty 244 := carry13])
    (ht681 : t657 + 1048576#64 = t681)
    (ht651 : t627 + 1048576#64 &&& 18446744073707454464#64 = t651)
    (hcarry13 : t681.sshiftRight 21 = carry13)
    (hcarry10 : (t627 + 1048576#64).sshiftRight 21 = carry10) (hbs4 : Bnd s4 0 2097151)
    (hbs5 : Bnd s5 0 2097151) (hbs3 : Bnd s3 0 2097151)
    (hbt627 : Bnd t627 (-2092547753555) 4042845754780) (hbt633 : Bnd t633 (-1048576) 1048575)
    (hbt662 : Bnd t662 (-1434499788031) 73367170318336) (hbt664 : Bnd t664 (-1048576) 1048575)
    (hbt667 : Bnd t667 (-175078656) 2097152) (hbt669 : Bnd t669 (-1048576) 1048575)
    (hbcarry9 : Bnd carry9 (-997805) 1791123) (hbcarry13 : Bnd carry13 (-1681706) 167607563)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t683 t685 carry15 t688 t690 t695 t696 t697 t701 t703 t705 t707 t708 t709 t710 t712 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
              rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
              rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
              rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
              rir_reg% fd_curve25519_scalar_reduce.hty 204 := t642,
              rir_reg% fd_curve25519_scalar_reduce.hty 233 := carry7,
              rir_reg% fd_curve25519_scalar_reduce.hty 234 := t672,
              rir_reg% fd_curve25519_scalar_reduce.hty 237 := t675,
              rir_reg% fd_curve25519_scalar_reduce.hty 240 := t678,
              rir_reg% fd_curve25519_scalar_reduce.hty 242 := t680,
              rir_reg% fd_curve25519_scalar_reduce.hty 245 := t683,
              rir_reg% fd_curve25519_scalar_reduce.hty 247 := t685,
              rir_reg% fd_curve25519_scalar_reduce.hty 252 := t690,
              rir_reg% fd_curve25519_scalar_reduce.hty 257 := t695,
              rir_reg% fd_curve25519_scalar_reduce.hty 258 := t696,
              rir_reg% fd_curve25519_scalar_reduce.hty 259 := t697,
              rir_reg% fd_curve25519_scalar_reduce.hty 263 := t701,
              rir_reg% fd_curve25519_scalar_reduce.hty 265 := t703,
              rir_reg% fd_curve25519_scalar_reduce.hty 267 := t705,
              rir_reg% fd_curve25519_scalar_reduce.hty 269 := t707,
              rir_reg% fd_curve25519_scalar_reduce.hty 270 := t708,
              rir_reg% fd_curve25519_scalar_reduce.hty 271 := t709,
              rir_reg% fd_curve25519_scalar_reduce.hty 272 := t710,
              rir_reg% fd_curve25519_scalar_reduce.hty 274 := t712]) →
          (ht683 : t683 = carry13 + t664) →
          (ht685 : t685 = t657 - carry13 <<< 21) →
          (hcarry15 : carry15 = (t662 + 1048576#64).sshiftRight 21) →
          (ht688 : t688 = carry15 + t669) →
          (ht690 : t690 = t662 - carry15 <<< 21) →
          (ht695 : t695 = t667 * 654183#64) →
          (ht696 : t696 = t667 * 18446744073708553811#64) →
          (ht697 : t697 = t667 * 136657#64) →
          (ht701 : t701 = t627 + t667 * 18446744073708867715#64 - carry10 <<< 21 + carry9) →
          (ht703 : t703 = t688 * 666643#64 + s4) →
          (ht705 : t705 = t667 * 666643#64 + s5 + t688 * 470296#64) →
          (ht707 : t707 = t633 + t667 * 470296#64 + t688 * 654183#64) →
          (ht708 : t708 = t688 * 18446744073708553811#64) →
          (ht709 : t709 = t688 * 136657#64) →
          (ht710 : t710 = t688 * 18446744073708867715#64) →
          (ht712 : t712 = t690 * 666643#64 + s3) →
          (hbt683 : Bnd t683 (-2730282) 168656138) →
          (hbt685 : Bnd t685 (-1048576) 1048575) →
          (hbcarry15 : Bnd carry15 (-684023) 34984193) →
          (hbt688 : Bnd t688 (-1732599) 36032768) →
          (hbt690 : Bnd t690 (-1048576) 1048575) →
          (hbt695 : Bnd t695 (-114533480418048) 1371921186816) →
          (hbt696 : Bnd t696 (-2092548751360) 174694358350080) →
          (hbt697 : Bnd t697 (-23925723892992) 286590500864) →
          (hbt701 : Bnd t701 (-1434246396333) 119736470756754) →
          (hbt703 : Bnd t703 (-1155024995157) 24020994654975) →
          (hbt705 : Bnd t705 (-117529794851112) 18344120457215) →
          (hbt707 : Bnd t707 (-83472229462369) 24558307514111) →
          (hbt708 : Bnd t708 (-35953676074240) 1728795945195) →
          (hbt709 : Bnd t709 (-236771781543) 4924129976576) →
          (hbt710 : Bnd t710 (-24642846067968) 1184926188699) →
          (hbt712 : Bnd t712 (-699025850368) 699027280876) → (blk.runBodyFrom E' 275 S >>= g) = K) :
    (blk.runBodyFrom E 245 S >>= g) = K := by
  step_pure with t683
  bnd t683
  step_pure
  step_pure with t685
  have ht685u := ht685
  rw [← ht681] at ht685u
  bnd t685
  clear ht685u
  step_pure [nswAdd]
  -- carry15 = (s15 + (1L << 20)) >> 21;
  step_pure with carry15
  bnd carry15
  step_pure [nswAdd] with t688
  bnd t688
  step_pure
  step_pure with t690
  bnd t690
  step_pure [nswMul]
  step_pure [nswAdd]
  step_pure [nswMul]
  step_pure [nswAdd]
  step_pure [nswMul] with t695
  bnd t695
  step_pure [nswMul] with t696
  bnd t696
  step_pure [nswMul] with t697
  bnd t697
  step_pure [nswMul]
  step_pure [nswAdd]
  step_pure
  step_pure with t701
  have ht701u := ht701
  rw [← ht651] at ht701u
  bnd t701
  clear ht701u
  step_pure
  step_pure with t703
  bnd t703
  step_pure
  step_pure with t705
  bnd t705
  step_pure
  step_pure with t707
  bnd t707
  step_pure with t708
  bnd t708
  step_pure with t709
  bnd t709
  step_pure with t710
  bnd t710
  step_pure
  step_pure with t712
  bnd t712
  simp only [Bnd.and_neg_shift] at ht685
  rw [hcarry13] at ht685
  simp only [Bnd.and_neg_shift] at ht690
  rw [← hcarry15] at ht690
  rw [← ht651] at ht701
  simp only [Bnd.and_neg_shift] at ht701
  rw [hcarry10] at ht701
  exact
    hK _ t683 t685 carry15 t688 t690 t695 t696 t697 t701 t703 t705 t707 t708 t709 t710 t712 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) ht683 ht685 hcarry15 ht688 ht690 ht695 ht696 ht697 ht701 ht703 ht705 ht707
      ht708 ht709 ht710 ht712 hbt683 hbt685 hbcarry15 hbt688 hbt690 hbt695 hbt696 hbt697 hbt701
      hbt703 hbt705 hbt707 hbt708 hbt709 hbt710 hbt712

/-- Instructions `275` to `304`. -/
theorem fd_curve25519_scalar_reduce.run275 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 275 = fd_curve25519_scalar_reduce.entry.body.drop 275)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 s1 s2 t631 t640 t642 carry7 t672 t675 t678 t680 t683 t685 t690 t695 t696 t697 t701 t703 t705
      t707 t708 t709 t710 t712 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 72 := s1,
        rir_reg% fd_curve25519_scalar_reduce.hty 74 := s2,
        rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
        rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
        rir_reg% fd_curve25519_scalar_reduce.hty 204 := t642,
        rir_reg% fd_curve25519_scalar_reduce.hty 233 := carry7,
        rir_reg% fd_curve25519_scalar_reduce.hty 234 := t672,
        rir_reg% fd_curve25519_scalar_reduce.hty 237 := t675,
        rir_reg% fd_curve25519_scalar_reduce.hty 240 := t678,
        rir_reg% fd_curve25519_scalar_reduce.hty 242 := t680,
        rir_reg% fd_curve25519_scalar_reduce.hty 245 := t683,
        rir_reg% fd_curve25519_scalar_reduce.hty 247 := t685,
        rir_reg% fd_curve25519_scalar_reduce.hty 252 := t690,
        rir_reg% fd_curve25519_scalar_reduce.hty 257 := t695,
        rir_reg% fd_curve25519_scalar_reduce.hty 258 := t696,
        rir_reg% fd_curve25519_scalar_reduce.hty 259 := t697,
        rir_reg% fd_curve25519_scalar_reduce.hty 263 := t701,
        rir_reg% fd_curve25519_scalar_reduce.hty 265 := t703,
        rir_reg% fd_curve25519_scalar_reduce.hty 267 := t705,
        rir_reg% fd_curve25519_scalar_reduce.hty 269 := t707,
        rir_reg% fd_curve25519_scalar_reduce.hty 270 := t708,
        rir_reg% fd_curve25519_scalar_reduce.hty 271 := t709,
        rir_reg% fd_curve25519_scalar_reduce.hty 272 := t710,
        rir_reg% fd_curve25519_scalar_reduce.hty 274 := t712])
    (hbs1 : Bnd s1 0 2097151) (hbs2 : Bnd s2 0 2097151) (hbt642 : Bnd t642 (-1048576) 1048575)
    (hbcarry7 : Bnd carry7 0 1136940) (hbt683 : Bnd t683 (-2730282) 168656138)
    (hbt685 : Bnd t685 (-1048576) 1048575) (hbt690 : Bnd t690 (-1048576) 1048575)
    (hbt696 : Bnd t696 (-2092548751360) 174694358350080)
    (hbt703 : Bnd t703 (-1155024995157) 24020994654975)
    (hbt705 : Bnd t705 (-117529794851112) 18344120457215)
    (hbt707 : Bnd t707 (-83472229462369) 24558307514111)
    (hbt709 : Bnd t709 (-236771781543) 4924129976576)
    (hbt712 : Bnd t712 (-699025850368) 699027280876)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t719 t724 t730 t732 t734 t735 t737 t739 t741 t742 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
              rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
              rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
              rir_reg% fd_curve25519_scalar_reduce.hty 234 := t672,
              rir_reg% fd_curve25519_scalar_reduce.hty 237 := t675,
              rir_reg% fd_curve25519_scalar_reduce.hty 240 := t678,
              rir_reg% fd_curve25519_scalar_reduce.hty 242 := t680,
              rir_reg% fd_curve25519_scalar_reduce.hty 247 := t685,
              rir_reg% fd_curve25519_scalar_reduce.hty 257 := t695,
              rir_reg% fd_curve25519_scalar_reduce.hty 259 := t697,
              rir_reg% fd_curve25519_scalar_reduce.hty 263 := t701,
              rir_reg% fd_curve25519_scalar_reduce.hty 270 := t708,
              rir_reg% fd_curve25519_scalar_reduce.hty 272 := t710,
              rir_reg% fd_curve25519_scalar_reduce.hty 281 := t719,
              rir_reg% fd_curve25519_scalar_reduce.hty 286 := t724,
              rir_reg% fd_curve25519_scalar_reduce.hty 292 := t730,
              rir_reg% fd_curve25519_scalar_reduce.hty 294 := t732,
              rir_reg% fd_curve25519_scalar_reduce.hty 296 := t734,
              rir_reg% fd_curve25519_scalar_reduce.hty 297 := t735,
              rir_reg% fd_curve25519_scalar_reduce.hty 299 := t737,
              rir_reg% fd_curve25519_scalar_reduce.hty 301 := t739,
              rir_reg% fd_curve25519_scalar_reduce.hty 303 := t741,
              rir_reg% fd_curve25519_scalar_reduce.hty 304 := t742]) →
          (ht719 : t719 = t690 * 136657#64) →
          (ht724 : t724 = t642 + t696 + carry7 + t709 + t690 * 18446744073708867715#64) →
          (ht730 : t730 = t703 + t690 * 470296#64 + t683 * 654183#64) →
          (ht732 : t732 = t705 + t690 * 654183#64 + t683 * 18446744073708553811#64) →
          (ht734 : t734 = t707 + t690 * 18446744073708553811#64 + t683 * 136657#64) →
          (ht735 : t735 = t683 * 18446744073708867715#64) →
          (ht737 : t737 = t685 * 666643#64 + s1) →
          (ht739 : t739 = t683 * 666643#64 + s2 + t685 * 470296#64) →
          (ht741 : t741 = t712 + t683 * 470296#64 + t685 * 654183#64) →
          (ht742 : t742 = t685 * 18446744073708553811#64) →
          (hbt719 : Bnd t719 (-143295250432) 143295113775) →
          (hbt724 : Bnd t724 (-3046443072554) 180335612687147) →
          (hbt730 : Bnd t730 (-3434270163259) 134846113608429) →
          (hbt732 : Bnd t732 (-286501693221610) 21754369427450) →
          (hbt734 : Bnd t734 (-84891614987518) 48652623740457) →
          (hbt735 : Bnd t735 (-115344101434338) 1867242590082) →
          (hbt737 : Bnd t737 (-699025850368) 699027280876) →
          (hbt739 : Bnd t739 (-2313264481822) 112926576530085) →
          (hbt741 : Bnd t741 (-2669027147248) 80703294296949) →
          (hbt742 : Bnd t742 (-1046273377875) 1046274375680) →
          (blk.runBodyFrom E' 305 S >>= g) = K) :
    (blk.runBodyFrom E 275 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t719
  bnd t719
  step_pure
  step_pure [nswAdd]
  step_pure [nswAdd]
  step_pure
  step_pure with t724
  bnd t724
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t730
  bnd t730
  step_pure
  step_pure with t732
  bnd t732
  step_pure
  step_pure with t734
  bnd t734
  step_pure with t735
  bnd t735
  step_pure
  step_pure with t737
  bnd t737
  step_pure
  step_pure with t739
  bnd t739
  step_pure
  step_pure with t741
  bnd t741
  step_pure with t742
  bnd t742
  exact
    hK _ t719 t724 t730 t732 t734 t735 t737 t739 t741 t742 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) ht719 ht724 ht730 ht732 ht734 ht735 ht737 ht739 ht741 ht742 hbt719 hbt724
      hbt730 hbt732 hbt734 hbt735 hbt737 hbt739 hbt741 hbt742

/-- Instructions `305` to `334`. -/
theorem fd_curve25519_scalar_reduce.run305 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 305 = fd_curve25519_scalar_reduce.entry.body.drop 305)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0 t631 t640 t672 t675 t678 t680 t685 t695 t697 t701 t708 t710 t719 t724 t730 t732 t734 t735
      t737 t739 t741 t742 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 70 := s0,
        rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
        rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
        rir_reg% fd_curve25519_scalar_reduce.hty 234 := t672,
        rir_reg% fd_curve25519_scalar_reduce.hty 237 := t675,
        rir_reg% fd_curve25519_scalar_reduce.hty 240 := t678,
        rir_reg% fd_curve25519_scalar_reduce.hty 242 := t680,
        rir_reg% fd_curve25519_scalar_reduce.hty 247 := t685,
        rir_reg% fd_curve25519_scalar_reduce.hty 257 := t695,
        rir_reg% fd_curve25519_scalar_reduce.hty 259 := t697,
        rir_reg% fd_curve25519_scalar_reduce.hty 263 := t701,
        rir_reg% fd_curve25519_scalar_reduce.hty 270 := t708,
        rir_reg% fd_curve25519_scalar_reduce.hty 272 := t710,
        rir_reg% fd_curve25519_scalar_reduce.hty 281 := t719,
        rir_reg% fd_curve25519_scalar_reduce.hty 286 := t724,
        rir_reg% fd_curve25519_scalar_reduce.hty 292 := t730,
        rir_reg% fd_curve25519_scalar_reduce.hty 294 := t732,
        rir_reg% fd_curve25519_scalar_reduce.hty 296 := t734,
        rir_reg% fd_curve25519_scalar_reduce.hty 297 := t735,
        rir_reg% fd_curve25519_scalar_reduce.hty 299 := t737,
        rir_reg% fd_curve25519_scalar_reduce.hty 301 := t739,
        rir_reg% fd_curve25519_scalar_reduce.hty 303 := t741,
        rir_reg% fd_curve25519_scalar_reduce.hty 304 := t742])
    (hbt685 : Bnd t685 (-1048576) 1048575) (hbt734 : Bnd t734 (-84891614987518) 48652623740457)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t747 t749 t753 t757 carry0 t762 t764 carry2 t767 t769 t770 carry4 t772 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
              rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
              rir_reg% fd_curve25519_scalar_reduce.hty 234 := t672,
              rir_reg% fd_curve25519_scalar_reduce.hty 237 := t675,
              rir_reg% fd_curve25519_scalar_reduce.hty 242 := t680,
              rir_reg% fd_curve25519_scalar_reduce.hty 257 := t695,
              rir_reg% fd_curve25519_scalar_reduce.hty 259 := t697,
              rir_reg% fd_curve25519_scalar_reduce.hty 263 := t701,
              rir_reg% fd_curve25519_scalar_reduce.hty 270 := t708,
              rir_reg% fd_curve25519_scalar_reduce.hty 272 := t710,
              rir_reg% fd_curve25519_scalar_reduce.hty 281 := t719,
              rir_reg% fd_curve25519_scalar_reduce.hty 286 := t724,
              rir_reg% fd_curve25519_scalar_reduce.hty 297 := t735,
              rir_reg% fd_curve25519_scalar_reduce.hty 309 := t747,
              rir_reg% fd_curve25519_scalar_reduce.hty 319 := t757,
              rir_reg% fd_curve25519_scalar_reduce.hty 324 := t762,
              rir_reg% fd_curve25519_scalar_reduce.hty 326 := t764,
              rir_reg% fd_curve25519_scalar_reduce.hty 329 := t767,
              rir_reg% fd_curve25519_scalar_reduce.hty 331 := t769,
              rir_reg% fd_curve25519_scalar_reduce.hty 332 := t770,
              rir_reg% fd_curve25519_scalar_reduce.hty 334 := t772]) →
          (ht747 : t747 = t734 + t685 * 18446744073708867715#64) →
          (ht749 : t749 = t678 * 666643#64 + s0) →
          (ht753 : t753 = t739 + t678 * 654183#64) →
          (ht757 : t757 = t730 + t742 + t678 * 136657#64) →
          (hcarry0 : carry0 = (t749 + 1048576#64).sshiftRight 21) →
          (ht762 : t762 = t737 + t678 * 470296#64 + carry0) →
          (ht764 : t764 = t749 - carry0 <<< 21) →
          (hcarry2 : carry2 = (t753 + 1048576#64).sshiftRight 21) →
          (ht767 : t767 = t741 + t678 * 18446744073708553811#64 + carry2) →
          (ht769 : t769 = t753 - carry2 <<< 21) →
          (ht770 : t770 = t757 + 1048576#64) →
          (hcarry4 : carry4 = t770.sshiftRight 21) →
          (ht772 : t772 = t732 + t685 * 136657#64 + t678 * 18446744073708867715#64 + carry4) →
          (hbt747 : Bnd t747 (-85608736478593) 49369745915433) →
          (hbt749 : Bnd t749 (-9223372036854775808) 9223372036854775807) →
          (hbt753 : Bnd t753 (-9223372036854775808) 9223372036854775807) →
          (hbt757 : Bnd t757 (-9223372036854775808) 9223372036854775807) →
          (hbcarry0 : Bnd carry0 (-4398046511104) 4398046511103) →
          (hbt762 : Bnd t762 (-9223372036854775808) 9223372036854775807) →
          (hbt764 : Bnd t764 (-1048576) 1048575) →
          (hbcarry2 : Bnd carry2 (-4398046511104) 4398046511103) →
          (hbt767 : Bnd t767 (-9223372036854775808) 9223372036854775807) →
          (hbt769 : Bnd t769 (-1048576) 1048575) →
          (hbt770 : Bnd t770 (-9223372036854775808) 9223372036854775807) →
          (hbcarry4 : Bnd carry4 (-4398046511104) 4398046511103) →
          (hbt772 : Bnd t772 (-9223372036854775808) 9223372036854775807) →
          (blk.runBodyFrom E' 335 S >>= g) = K) :
    (blk.runBodyFrom E 305 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t747
  bnd t747
  step_pure
  step_pure with t749
  bnd t749
  step_pure
  step_pure
  step_pure
  step_pure with t753
  bnd t753
  step_pure
  step_pure
  step_pure
  step_pure with t757
  bnd t757
  step_pure
  step_pure
  step_pure
  -- carry0 = (s0 + (1L << 20)) >> 21;
  step_pure with carry0
  bnd carry0
  step_pure with t762
  bnd t762
  step_pure
  step_pure with t764
  bnd t764
  step_pure
  -- carry2 = (s2 + (1L << 20)) >> 21;
  step_pure with carry2
  bnd carry2
  step_pure with t767
  bnd t767
  step_pure
  step_pure with t769
  bnd t769
  step_pure with t770
  bnd t770
  -- carry4 = (s4 + (1L << 20)) >> 21;
  step_pure with carry4
  bnd carry4
  step_pure with t772
  bnd t772
  simp only [Bnd.and_neg_shift] at ht764
  rw [← hcarry0] at ht764
  simp only [Bnd.and_neg_shift] at ht769
  rw [← hcarry2] at ht769
  exact
    hK _ t747 t749 t753 t757 carry0 t762 t764 carry2 t767 t769 t770 carry4 t772 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) ht747 ht749 ht753 ht757 hcarry0 ht762 ht764 hcarry2 ht767 ht769 ht770 hcarry4
      ht772 hbt747 hbt749 hbt753 hbt757 hbcarry0 hbt762 hbt764 hbcarry2 hbt767 hbt769 hbt770
      hbcarry4 hbt772

/-- Instructions `335` to `364`. -/
theorem fd_curve25519_scalar_reduce.run335 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 335 = fd_curve25519_scalar_reduce.entry.body.drop 335)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {t631 t640 carry7 t672 carry9 t675 t680 t695 t697 t701 t708 t710 t719 t724 t735 t747 t757 t762
      t764 t767 t769 t770 carry4 t772 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 193 := t631,
        rir_reg% fd_curve25519_scalar_reduce.hty 202 := t640,
        rir_reg% fd_curve25519_scalar_reduce.hty 234 := t672,
        rir_reg% fd_curve25519_scalar_reduce.hty 237 := t675,
        rir_reg% fd_curve25519_scalar_reduce.hty 242 := t680,
        rir_reg% fd_curve25519_scalar_reduce.hty 257 := t695,
        rir_reg% fd_curve25519_scalar_reduce.hty 259 := t697,
        rir_reg% fd_curve25519_scalar_reduce.hty 263 := t701,
        rir_reg% fd_curve25519_scalar_reduce.hty 270 := t708,
        rir_reg% fd_curve25519_scalar_reduce.hty 272 := t710,
        rir_reg% fd_curve25519_scalar_reduce.hty 281 := t719,
        rir_reg% fd_curve25519_scalar_reduce.hty 286 := t724,
        rir_reg% fd_curve25519_scalar_reduce.hty 297 := t735,
        rir_reg% fd_curve25519_scalar_reduce.hty 309 := t747,
        rir_reg% fd_curve25519_scalar_reduce.hty 319 := t757,
        rir_reg% fd_curve25519_scalar_reduce.hty 324 := t762,
        rir_reg% fd_curve25519_scalar_reduce.hty 326 := t764,
        rir_reg% fd_curve25519_scalar_reduce.hty 329 := t767,
        rir_reg% fd_curve25519_scalar_reduce.hty 331 := t769,
        rir_reg% fd_curve25519_scalar_reduce.hty 332 := t770,
        rir_reg% fd_curve25519_scalar_reduce.hty 334 := t772])
    (ht770 : t757 + 1048576#64 = t770) (ht672 : t631 + 1048576#64 &&& 9223372036852678656#64 = t672)
    (ht675 : t640 + 1048576#64 &&& 18446744073707454464#64 = t675)
    (hcarry4 : t770.sshiftRight 21 = carry4) (hcarry7 : (t631 + 1048576#64).sshiftRight 21 = carry7)
    (hcarry9 : (t640 + 1048576#64).sshiftRight 21 = carry9) (hbt631 : Bnd t631 0 2384335524584)
    (hbt640 : Bnd t640 (-2092547753555) 3756257181695) (hbt672 : Bnd t672 0 2384335994880)
    (hbt680 : Bnd t680 (-1048576) 1048575) (hbt695 : Bnd t695 (-114533480418048) 1371921186816)
    (hbt697 : Bnd t697 (-23925723892992) 286590500864)
    (hbt701 : Bnd t701 (-1434246396333) 119736470756754)
    (hbt708 : Bnd t708 (-35953676074240) 1728795945195)
    (hbt710 : Bnd t710 (-24642846067968) 1184926188699)
    (hbt719 : Bnd t719 (-143295250432) 143295113775)
    (hbt724 : Bnd t724 (-3046443072554) 180335612687147)
    (hbt735 : Bnd t735 (-115344101434338) 1867242590082)
    (hbt747 : Bnd t747 (-85608736478593) 49369745915433)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t774 carry6_1 t782 t784 carry8_1 t790 t792 carry10_1 t795 t797 carry1 t800 t801 carry3 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 324 := t762,
              rir_reg% fd_curve25519_scalar_reduce.hty 326 := t764,
              rir_reg% fd_curve25519_scalar_reduce.hty 329 := t767,
              rir_reg% fd_curve25519_scalar_reduce.hty 331 := t769,
              rir_reg% fd_curve25519_scalar_reduce.hty 334 := t772,
              rir_reg% fd_curve25519_scalar_reduce.hty 336 := t774,
              rir_reg% fd_curve25519_scalar_reduce.hty 344 := t782,
              rir_reg% fd_curve25519_scalar_reduce.hty 346 := t784,
              rir_reg% fd_curve25519_scalar_reduce.hty 352 := t790,
              rir_reg% fd_curve25519_scalar_reduce.hty 354 := t792,
              rir_reg% fd_curve25519_scalar_reduce.hty 357 := t795,
              rir_reg% fd_curve25519_scalar_reduce.hty 359 := t797,
              rir_reg% fd_curve25519_scalar_reduce.hty 361 := carry1,
              rir_reg% fd_curve25519_scalar_reduce.hty 362 := t800,
              rir_reg% fd_curve25519_scalar_reduce.hty 363 := t801,
              rir_reg% fd_curve25519_scalar_reduce.hty 364 := carry3]) →
          (ht774 : t774 = t757 - carry4 <<< 21) →
          (hcarry6_1 : carry6_1 = (t747 + 1048576#64).sshiftRight 21) →
          (ht782 : t782 = t695 + t631 - carry7 <<< 21 + t708 + t719 + t735 + carry6_1) →
          (ht784 : t784 = t747 - carry6_1 <<< 21) →
          (hcarry8_1 : carry8_1 = (t724 + 1048576#64).sshiftRight 21) →
          (ht790 : t790 = t640 + t697 - carry9 <<< 21 + t710 + carry8_1) →
          (ht792 : t792 = t724 - carry8_1 <<< 21) →
          (hcarry10_1 : carry10_1 = (t701 + 1048576#64).sshiftRight 21) →
          (ht795 : t795 = carry10_1 + t680) →
          (ht797 : t797 = t701 - carry10_1 <<< 21) →
          (hcarry1 : carry1 = (t762 + 1048576#64).sshiftRight 21) →
          (ht800 : t800 = t762 + 1048576#64 &&& 18446744073707454464#64) →
          (ht801 : t801 = t767 + 1048576#64) →
          (hcarry3 : carry3 = t801.sshiftRight 21) →
          (hbt774 : Bnd t774 (-1048576) 1048575) →
          (hbcarry6_1 : Bnd carry6_1 (-40821427) 23541329) →
          (hbt782 : Bnd t782 (-265974595047061) 5111279425772) →
          (hbt784 : Bnd t784 (-1048576) 1048575) →
          (hbcarry8_1 : Bnd carry8_1 (-1452657) 85990721) →
          (hbt790 : Bnd t790 (-48568572462193) 1471603728859) →
          (hbt792 : Bnd t792 (-1048576) 1048575) →
          (hbcarry10_1 : Bnd carry10_1 (-683902) 57094798) →
          (hbt795 : Bnd t795 (-1732478) 58143373) →
          (hbt797 : Bnd t797 (-1048576) 1048575) →
          (hbcarry1 : Bnd carry1 (-4398046511104) 4398046511103) →
          (hbt800 : Bnd t800 (-9223372036854775808) 9223372036852678656) →
          (hbt801 : Bnd t801 (-9223372036854775808) 9223372036854775807) →
          (hbcarry3 : Bnd carry3 (-4398046511104) 4398046511103) →
          (blk.runBodyFrom E' 365 S >>= g) = K) :
    (blk.runBodyFrom E 335 S >>= g) = K := by
  step_pure
  step_pure with t774
  have ht774u := ht774
  rw [← ht770] at ht774u
  bnd t774
  clear ht774u
  step_pure
  -- carry6 = (s6 + (1L << 20)) >> 21;
  step_pure with carry6_1
  bnd carry6_1
  step_pure [nswAdd]
  step_pure [nswSub]
  step_pure
  step_pure
  step_pure
  step_pure with t782
  have ht782u := ht782
  rw [← ht672] at ht782u
  bnd t782
  clear ht782u
  step_pure
  step_pure with t784
  bnd t784
  step_pure
  -- carry8 = (s8 + (1L << 20)) >> 21;
  step_pure with carry8_1
  bnd carry8_1
  step_pure [nswAdd]
  step_pure
  step_pure
  step_pure with t790
  have ht790u := ht790
  rw [← ht675] at ht790u
  bnd t790
  clear ht790u
  step_pure
  step_pure with t792
  bnd t792
  step_pure
  -- carry10 = (s10 + (1L << 20)) >> 21;
  step_pure with carry10_1
  bnd carry10_1
  step_pure with t795
  bnd t795
  step_pure
  step_pure with t797
  bnd t797
  step_pure
  -- carry1 = (s1 + (1L << 20)) >> 21;
  step_pure with carry1
  bnd carry1
  step_pure with t800
  bnd t800
  step_pure with t801
  bnd t801
  -- carry3 = (s3 + (1L << 20)) >> 21;
  step_pure with carry3
  bnd carry3
  simp only [Bnd.and_neg_shift] at ht774
  rw [hcarry4] at ht774
  rw [← ht672] at ht782
  simp only [andMask] at ht782
  rw [hcarry7] at ht782
  simp only [Bnd.and_neg_shift] at ht784
  rw [← hcarry6_1] at ht784
  rw [← ht675] at ht790
  simp only [Bnd.and_neg_shift] at ht790
  rw [hcarry9] at ht790
  simp only [Bnd.and_neg_shift] at ht792
  rw [← hcarry8_1] at ht792
  simp only [Bnd.and_neg_shift] at ht797
  rw [← hcarry10_1] at ht797
  exact
    hK _ t774 carry6_1 t782 t784 carry8_1 t790 t792 carry10_1 t795 t797 carry1 t800 t801 carry3
      hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) ht774 hcarry6_1 ht782 ht784 hcarry8_1 ht790 ht792 hcarry10_1 ht795 ht797
      hcarry1 ht800 ht801 hcarry3 hbt774 hbcarry6_1 hbt782 hbt784 hbcarry8_1 hbt790 hbt792
      hbcarry10_1 hbt795 hbt797 hbcarry1 hbt800 hbt801 hbcarry3

/-- Instructions `365` to `394`. -/
theorem fd_curve25519_scalar_reduce.run365 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 365 = fd_curve25519_scalar_reduce.entry.body.drop 365)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {t762 t764 t767 t769 t772 t774 t782 t784 t790 t792 t795 t797 carry1 t800 t801 carry3 :
      BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 324 := t762,
        rir_reg% fd_curve25519_scalar_reduce.hty 326 := t764,
        rir_reg% fd_curve25519_scalar_reduce.hty 329 := t767,
        rir_reg% fd_curve25519_scalar_reduce.hty 331 := t769,
        rir_reg% fd_curve25519_scalar_reduce.hty 334 := t772,
        rir_reg% fd_curve25519_scalar_reduce.hty 336 := t774,
        rir_reg% fd_curve25519_scalar_reduce.hty 344 := t782,
        rir_reg% fd_curve25519_scalar_reduce.hty 346 := t784,
        rir_reg% fd_curve25519_scalar_reduce.hty 352 := t790,
        rir_reg% fd_curve25519_scalar_reduce.hty 354 := t792,
        rir_reg% fd_curve25519_scalar_reduce.hty 357 := t795,
        rir_reg% fd_curve25519_scalar_reduce.hty 359 := t797,
        rir_reg% fd_curve25519_scalar_reduce.hty 361 := carry1,
        rir_reg% fd_curve25519_scalar_reduce.hty 362 := t800,
        rir_reg% fd_curve25519_scalar_reduce.hty 363 := t801,
        rir_reg% fd_curve25519_scalar_reduce.hty 364 := carry3])
    (ht800 : t762 + 1048576#64 &&& 18446744073707454464#64 = t800)
    (hcarry1 : (t762 + 1048576#64).sshiftRight 21 = carry1) (hbt764 : Bnd t764 (-1048576) 1048575)
    (hbt782 : Bnd t782 (-265974595047061) 5111279425772) (hbt784 : Bnd t784 (-1048576) 1048575)
    (hbt790 : Bnd t790 (-48568572462193) 1471603728859) (hbt792 : Bnd t792 (-1048576) 1048575)
    (hbt795 : Bnd t795 (-1732478) 58143373) (hbt797 : Bnd t797 (-1048576) 1048575)
    (hbt801 : Bnd t801 (-9223372036854775808) 9223372036854775807)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t803 carry5 t806 t807 carry7_1 t810 t812 carry9_1 t815 t817 carry11_1 t821 t823 t825 t826
          t827 t828 carry0_1 t832 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 329 := t767,
              rir_reg% fd_curve25519_scalar_reduce.hty 331 := t769,
              rir_reg% fd_curve25519_scalar_reduce.hty 334 := t772,
              rir_reg% fd_curve25519_scalar_reduce.hty 336 := t774,
              rir_reg% fd_curve25519_scalar_reduce.hty 361 := carry1,
              rir_reg% fd_curve25519_scalar_reduce.hty 364 := carry3,
              rir_reg% fd_curve25519_scalar_reduce.hty 365 := t803,
              rir_reg% fd_curve25519_scalar_reduce.hty 368 := t806,
              rir_reg% fd_curve25519_scalar_reduce.hty 369 := t807,
              rir_reg% fd_curve25519_scalar_reduce.hty 372 := t810,
              rir_reg% fd_curve25519_scalar_reduce.hty 374 := t812,
              rir_reg% fd_curve25519_scalar_reduce.hty 377 := t815,
              rir_reg% fd_curve25519_scalar_reduce.hty 379 := t817,
              rir_reg% fd_curve25519_scalar_reduce.hty 383 := t821,
              rir_reg% fd_curve25519_scalar_reduce.hty 385 := t823,
              rir_reg% fd_curve25519_scalar_reduce.hty 387 := t825,
              rir_reg% fd_curve25519_scalar_reduce.hty 388 := t826,
              rir_reg% fd_curve25519_scalar_reduce.hty 389 := t827,
              rir_reg% fd_curve25519_scalar_reduce.hty 390 := t828,
              rir_reg% fd_curve25519_scalar_reduce.hty 394 := t832]) →
          (ht803 : t803 = t801 &&& 18446744073707454464#64) →
          (hcarry5 : carry5 = (t772 + 1048576#64).sshiftRight 21) →
          (ht806 : t806 = t784 + carry5) →
          (ht807 : t807 = t772 + 1048576#64 &&& 18446744073707454464#64) →
          (hcarry7_1 : carry7_1 = (t782 + 1048576#64).sshiftRight 21) →
          (ht810 : t810 = t792 + carry7_1) →
          (ht812 : t812 = t782 - carry7_1 <<< 21) →
          (hcarry9_1 : carry9_1 = (t790 + 1048576#64).sshiftRight 21) →
          (ht815 : t815 = t797 + carry9_1) →
          (ht817 : t817 = t790 - carry9_1 <<< 21) →
          (hcarry11_1 : carry11_1 = (t795 + 1048576#64).sshiftRight 21) →
          (ht821 : t821 = t795 - carry11_1 <<< 21) →
          (ht823 : t823 = t764 + carry11_1 * 666643#64) →
          (ht825 : t825 = carry11_1 * 654183#64) →
          (ht826 : t826 = carry11_1 * 18446744073708553811#64) →
          (ht827 : t827 = carry11_1 * 136657#64) →
          (ht828 : t828 = carry11_1 * 18446744073708867715#64) →
          (hcarry0_1 : carry0_1 = t823.sshiftRight 21) →
          (ht832 : t832 = carry11_1 * 470296#64 + t762 - carry1 <<< 21 + carry0_1) →
          (hbt803 : Bnd t803 (-9223372036854775808) 9223372036852678656) →
          (hbcarry5 : Bnd carry5 (-4398046511104) 4398046511103) →
          (hbt806 : Bnd t806 (-4398047559680) 4398047559678) →
          (hbt807 : Bnd t807 (-9223372036854775808) 9223372036852678656) →
          (hbcarry7_1 : Bnd carry7_1 (-126826570) 2437248) →
          (hbt810 : Bnd t810 (-127875146) 3485823) →
          (hbt812 : Bnd t812 (-1048576) 1048575) →
          (hbcarry9_1 : Bnd carry9_1 (-23159300) 701715) →
          (hbt815 : Bnd t815 (-24207876) 1750290) →
          (hbt817 : Bnd t817 (-1048576) 1048575) →
          (hbcarry11_1 : Bnd carry11_1 (-1) 28) →
          (hbt821 : Bnd t821 (-1048576) 1048575) →
          (hbt823 : Bnd t823 (-1715219) 19714579) →
          (hbt825 : Bnd t825 (-654183) 18317124) →
          (hbt826 : Bnd t826 (-27938540) 997805) →
          (hbt827 : Bnd t827 (-136657) 3826396) →
          (hbt828 : Bnd t828 (-19149228) 683901) →
          (hbcarry0_1 : Bnd carry0_1 (-1) 9) →
          (hbt832 : Bnd t832 (-1518873) 14216872) → (blk.runBodyFrom E' 395 S >>= g) = K) :
    (blk.runBodyFrom E 365 S >>= g) = K := by
  step_pure with t803
  bnd t803
  step_pure
  -- carry5 = (s5 + (1L << 20)) >> 21;
  step_pure with carry5
  bnd carry5
  step_pure with t806
  bnd t806
  step_pure with t807
  bnd t807
  step_pure
  -- carry7 = (s7 + (1L << 20)) >> 21;
  step_pure with carry7_1
  bnd carry7_1
  step_pure with t810
  bnd t810
  step_pure
  step_pure with t812
  bnd t812
  step_pure
  -- carry9 = (s9 + (1L << 20)) >> 21;
  step_pure with carry9_1
  bnd carry9_1
  step_pure with t815
  bnd t815
  step_pure
  step_pure with t817
  bnd t817
  step_pure
  -- carry11 = (s11 + (1L << 20)) >> 21;
  step_pure with carry11_1
  bnd carry11_1
  step_pure
  step_pure with t821
  bnd t821
  step_pure [nswMul]
  step_pure with t823
  bnd t823
  step_pure [nswMul]
  step_pure [nswMul] with t825
  bnd t825
  step_pure [nswMul] with t826
  bnd t826
  step_pure [nswMul] with t827
  bnd t827
  step_pure [nswMul] with t828
  bnd t828
  -- carry0 = s0 >> 21;
  step_pure with carry0_1
  bnd carry0_1
  step_pure
  step_pure
  step_pure with t832
  have ht832u := ht832
  rw [← ht800] at ht832u
  bnd t832
  clear ht832u
  simp only [Bnd.and_neg_shift] at ht812
  rw [← hcarry7_1] at ht812
  simp only [Bnd.and_neg_shift] at ht817
  rw [← hcarry9_1] at ht817
  simp only [Bnd.and_neg_shift] at ht821
  rw [← hcarry11_1] at ht821
  rw [← ht800] at ht832
  simp only [Bnd.and_neg_shift] at ht832
  rw [hcarry1] at ht832
  exact
    hK _ t803 carry5 t806 t807 carry7_1 t810 t812 carry9_1 t815 t817 carry11_1 t821 t823 t825 t826
      t827 t828 carry0_1 t832 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) ht803 hcarry5 ht806 ht807 hcarry7_1 ht810 ht812 hcarry9_1 ht815 ht817
      hcarry11_1 ht821 ht823 ht825 ht826 ht827 ht828 hcarry0_1 ht832 hbt803 hbcarry5 hbt806 hbt807
      hbcarry7_1 hbt810 hbt812 hbcarry9_1 hbt815 hbt817 hbcarry11_1 hbt821 hbt823 hbt825 hbt826
      hbt827 hbt828 hbcarry0_1 hbt832

/-- Instructions `395` to `419`. -/
theorem fd_curve25519_scalar_reduce.run395 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 395 = fd_curve25519_scalar_reduce.entry.body.drop 395)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {t767 t769 t772 t774 carry1 t801 carry3 t803 carry5 t806 t807 t810 t812 t815 t817 t821 t823 t825
      t826 t827 t828 carry0_1 t832 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 329 := t767,
        rir_reg% fd_curve25519_scalar_reduce.hty 331 := t769,
        rir_reg% fd_curve25519_scalar_reduce.hty 334 := t772,
        rir_reg% fd_curve25519_scalar_reduce.hty 336 := t774,
        rir_reg% fd_curve25519_scalar_reduce.hty 361 := carry1,
        rir_reg% fd_curve25519_scalar_reduce.hty 364 := carry3,
        rir_reg% fd_curve25519_scalar_reduce.hty 365 := t803,
        rir_reg% fd_curve25519_scalar_reduce.hty 368 := t806,
        rir_reg% fd_curve25519_scalar_reduce.hty 369 := t807,
        rir_reg% fd_curve25519_scalar_reduce.hty 372 := t810,
        rir_reg% fd_curve25519_scalar_reduce.hty 374 := t812,
        rir_reg% fd_curve25519_scalar_reduce.hty 377 := t815,
        rir_reg% fd_curve25519_scalar_reduce.hty 379 := t817,
        rir_reg% fd_curve25519_scalar_reduce.hty 383 := t821,
        rir_reg% fd_curve25519_scalar_reduce.hty 385 := t823,
        rir_reg% fd_curve25519_scalar_reduce.hty 387 := t825,
        rir_reg% fd_curve25519_scalar_reduce.hty 388 := t826,
        rir_reg% fd_curve25519_scalar_reduce.hty 389 := t827,
        rir_reg% fd_curve25519_scalar_reduce.hty 390 := t828,
        rir_reg% fd_curve25519_scalar_reduce.hty 394 := t832])
    (ht803 : t801 &&& 18446744073707454464#64 = t803) (ht801 : t767 + 1048576#64 = t801)
    (ht807 : t772 + 1048576#64 &&& 18446744073707454464#64 = t807)
    (hcarry0_1 : t823.sshiftRight 21 = carry0_1) (hcarry3 : t801.sshiftRight 21 = carry3)
    (hcarry5 : (t772 + 1048576#64).sshiftRight 21 = carry5) (hbt769 : Bnd t769 (-1048576) 1048575)
    (hbt774 : Bnd t774 (-1048576) 1048575) (hbcarry1 : Bnd carry1 (-4398046511104) 4398046511103)
    (hbcarry3 : Bnd carry3 (-4398046511104) 4398046511103)
    (hbt806 : Bnd t806 (-4398047559680) 4398047559678) (hbt825 : Bnd t825 (-654183) 18317124)
    (hbt826 : Bnd t826 (-27938540) 997805) (hbt827 : Bnd t827 (-136657) 3826396)
    (hbt828 : Bnd t828 (-19149228) 683901) (hbt832 : Bnd t832 (-1518873) 14216872)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t833 carry1_1 t837 t838 carry2_1 t842 t843 carry3_1 t847 t848 carry4_1 t852 t853 carry5_1
          t855 t856 carry6_2 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 372 := t810,
              rir_reg% fd_curve25519_scalar_reduce.hty 374 := t812,
              rir_reg% fd_curve25519_scalar_reduce.hty 377 := t815,
              rir_reg% fd_curve25519_scalar_reduce.hty 379 := t817,
              rir_reg% fd_curve25519_scalar_reduce.hty 383 := t821,
              rir_reg% fd_curve25519_scalar_reduce.hty 395 := t833,
              rir_reg% fd_curve25519_scalar_reduce.hty 400 := t838,
              rir_reg% fd_curve25519_scalar_reduce.hty 405 := t843,
              rir_reg% fd_curve25519_scalar_reduce.hty 410 := t848,
              rir_reg% fd_curve25519_scalar_reduce.hty 415 := t853,
              rir_reg% fd_curve25519_scalar_reduce.hty 417 := t855,
              rir_reg% fd_curve25519_scalar_reduce.hty 418 := t856,
              rir_reg% fd_curve25519_scalar_reduce.hty 419 := carry6_2]) →
          (ht833 : t833 = t823 - carry0_1 <<< 21) →
          (hcarry1_1 : carry1_1 = t832.sshiftRight 21) →
          (ht837 : t837 = t769 + t825 + carry1 + carry1_1) →
          (ht838 : t838 = t832 - carry1_1 <<< 21) →
          (hcarry2_1 : carry2_1 = t837.sshiftRight 21) →
          (ht842 : t842 = t767 + t826 - carry3 <<< 21 + carry2_1) →
          (ht843 : t843 = t837 - carry2_1 <<< 21) →
          (hcarry3_1 : carry3_1 = t842.sshiftRight 21) →
          (ht847 : t847 = t774 + t827 + carry3 + carry3_1) →
          (ht848 : t848 = t842 - carry3_1 <<< 21) →
          (hcarry4_1 : carry4_1 = t847.sshiftRight 21) →
          (ht852 : t852 = t772 + t828 - carry5 <<< 21 + carry4_1) →
          (ht853 : t853 = t847 - carry4_1 <<< 21) →
          (hcarry5_1 : carry5_1 = t852.sshiftRight 21) →
          (ht855 : t855 = t806 + carry5_1) →
          (ht856 : t856 = t852 - carry5_1 <<< 21) →
          (hcarry6_2 : carry6_2 = t855.sshiftRight 21) →
          (hbt833 : Bnd t833 0 2097151) →
          (hbcarry1_1 : Bnd carry1_1 (-1) 6) →
          (hbt837 : Bnd t837 (-4398048213864) 4398065876808) →
          (hbt838 : Bnd t838 0 2097151) →
          (hbcarry2_1 : Bnd carry2_1 (-2097153) 2097161) →
          (hbt842 : Bnd t842 (-31084269) 4143541) →
          (hbt843 : Bnd t843 0 2097151) →
          (hbcarry3_1 : Bnd carry3_1 (-15) 1) →
          (hbt847 : Bnd t847 (-4398047696352) 4398051386075) →
          (hbt848 : Bnd t848 0 2097151) →
          (hbcarry4_1 : Bnd carry4_1 (-2097153) 2097154) →
          (hbt852 : Bnd t852 (-22294957) 3829630) →
          (hbt853 : Bnd t853 0 2097151) →
          (hbcarry5_1 : Bnd carry5_1 (-11) 1) →
          (hbt855 : Bnd t855 (-4398047559691) 4398047559679) →
          (hbt856 : Bnd t856 0 2097151) →
          (hbcarry6_2 : Bnd carry6_2 (-2097153) 2097152) → (blk.runBodyFrom E' 420 S >>= g) = K) :
    (blk.runBodyFrom E 395 S >>= g) = K := by
  step_pure with t833
  bnd t833
  -- carry1 = s1 >> 21;
  step_pure with carry1_1
  bnd carry1_1
  step_pure
  step_pure
  step_pure with t837
  bnd t837
  step_pure with t838
  bnd t838
  -- carry2 = s2 >> 21;
  step_pure with carry2_1
  bnd carry2_1
  step_pure
  step_pure
  step_pure with t842
  have ht842u := ht842
  rw [← ht803, ← ht801] at ht842u
  bnd t842
  clear ht842u
  step_pure with t843
  bnd t843
  -- carry3 = s3 >> 21;
  step_pure with carry3_1
  bnd carry3_1
  step_pure
  step_pure
  step_pure with t847
  bnd t847
  step_pure with t848
  bnd t848
  -- carry4 = s4 >> 21;
  step_pure with carry4_1
  bnd carry4_1
  step_pure
  step_pure
  step_pure with t852
  have ht852u := ht852
  rw [← ht807] at ht852u
  bnd t852
  clear ht852u
  step_pure with t853
  bnd t853
  -- carry5 = s5 >> 21;
  step_pure with carry5_1
  bnd carry5_1
  step_pure with t855
  bnd t855
  step_pure with t856
  bnd t856
  -- carry6 = s6 >> 21;
  step_pure with carry6_2
  bnd carry6_2
  simp only [Bnd.and_mask_sub] at ht833
  rw [hcarry0_1] at ht833
  simp only [Bnd.and_mask_sub] at ht838
  rw [← hcarry1_1] at ht838
  rw [← ht803] at ht842
  simp only [Bnd.and_neg_shift] at ht842
  rw [hcarry3] at ht842
  simp only [Bnd.and_mask_sub] at ht843
  rw [← hcarry2_1] at ht843
  simp only [Bnd.and_mask_sub] at ht848
  rw [← hcarry3_1] at ht848
  rw [← ht807] at ht852
  simp only [Bnd.and_neg_shift] at ht852
  rw [hcarry5] at ht852
  simp only [Bnd.and_mask_sub] at ht853
  rw [← hcarry4_1] at ht853
  simp only [Bnd.and_mask_sub] at ht856
  rw [← hcarry5_1] at ht856
  exact
    hK _ t833 carry1_1 t837 t838 carry2_1 t842 t843 carry3_1 t847 t848 carry4_1 t852 t853 carry5_1
      t855 t856 carry6_2 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) ht833 hcarry1_1 ht837 ht838 hcarry2_1 ht842 ht843 hcarry3_1 ht847 ht848
      hcarry4_1 ht852 ht853 hcarry5_1 ht855 ht856 hcarry6_2 hbt833 hbcarry1_1 hbt837 hbt838
      hbcarry2_1 hbt842 hbt843 hbcarry3_1 hbt847 hbt848 hbcarry4_1 hbt852 hbt853 hbcarry5_1 hbt855
      hbt856 hbcarry6_2

/-- Instructions `420` to `444`. -/
theorem fd_curve25519_scalar_reduce.run420 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 420 = fd_curve25519_scalar_reduce.entry.body.drop 420)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {t810 t812 t815 t817 t821 t833 t838 t843 t848 t853 t855 t856 carry6_2 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 372 := t810,
        rir_reg% fd_curve25519_scalar_reduce.hty 374 := t812,
        rir_reg% fd_curve25519_scalar_reduce.hty 377 := t815,
        rir_reg% fd_curve25519_scalar_reduce.hty 379 := t817,
        rir_reg% fd_curve25519_scalar_reduce.hty 383 := t821,
        rir_reg% fd_curve25519_scalar_reduce.hty 395 := t833,
        rir_reg% fd_curve25519_scalar_reduce.hty 400 := t838,
        rir_reg% fd_curve25519_scalar_reduce.hty 405 := t843,
        rir_reg% fd_curve25519_scalar_reduce.hty 410 := t848,
        rir_reg% fd_curve25519_scalar_reduce.hty 415 := t853,
        rir_reg% fd_curve25519_scalar_reduce.hty 417 := t855,
        rir_reg% fd_curve25519_scalar_reduce.hty 418 := t856,
        rir_reg% fd_curve25519_scalar_reduce.hty 419 := carry6_2])
    (hcarry6_2 : t855.sshiftRight 21 = carry6_2) (hbt810 : Bnd t810 (-127875146) 3485823)
    (hbt812 : Bnd t812 (-1048576) 1048575) (hbt815 : Bnd t815 (-24207876) 1750290)
    (hbt817 : Bnd t817 (-1048576) 1048575) (hbt821 : Bnd t821 (-1048576) 1048575)
    (hbt838 : Bnd t838 0 2097151) (hbt843 : Bnd t843 0 2097151) (hbt848 : Bnd t848 0 2097151)
    (hbt853 : Bnd t853 0 2097151) (hbcarry6_2 : Bnd carry6_2 (-2097153) 2097152)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (t858 t859 carry7_2 t861 t862 carry8_2 t864 t865 carry9_2 t867 t868 carry10_2 t870 t871
          carry11_2 s11_12 t874 t876 t878 t880 t882 : BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 395 := t833,
              rir_reg% fd_curve25519_scalar_reduce.hty 418 := t856,
              rir_reg% fd_curve25519_scalar_reduce.hty 421 := t859,
              rir_reg% fd_curve25519_scalar_reduce.hty 424 := t862,
              rir_reg% fd_curve25519_scalar_reduce.hty 427 := t865,
              rir_reg% fd_curve25519_scalar_reduce.hty 430 := t868,
              rir_reg% fd_curve25519_scalar_reduce.hty 433 := t871,
              rir_reg% fd_curve25519_scalar_reduce.hty 434 := carry11_2,
              rir_reg% fd_curve25519_scalar_reduce.hty 435 := s11_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 436 := t874,
              rir_reg% fd_curve25519_scalar_reduce.hty 438 := t876,
              rir_reg% fd_curve25519_scalar_reduce.hty 440 := t878,
              rir_reg% fd_curve25519_scalar_reduce.hty 442 := t880,
              rir_reg% fd_curve25519_scalar_reduce.hty 444 := t882]) →
          (ht858 : t858 = carry6_2 + t812) →
          (ht859 : t859 = t855 - carry6_2 <<< 21) →
          (hcarry7_2 : carry7_2 = t858.sshiftRight 21) →
          (ht861 : t861 = t810 + carry7_2) →
          (ht862 : t862 = t858 - carry7_2 <<< 21) →
          (hcarry8_2 : carry8_2 = t861.sshiftRight 21) →
          (ht864 : t864 = carry8_2 + t817) →
          (ht865 : t865 = t861 - carry8_2 <<< 21) →
          (hcarry9_2 : carry9_2 = t864.sshiftRight 21) →
          (ht867 : t867 = t815 + carry9_2) →
          (ht868 : t868 = t864 - carry9_2 <<< 21) →
          (hcarry10_2 : carry10_2 = t867.sshiftRight 21) →
          (ht870 : t870 = carry10_2 + t821) →
          (ht871 : t871 = t867 - carry10_2 <<< 21) →
          (hcarry11_2 : carry11_2 = t870.sshiftRight 21) →
          (hs11_12 : s11_12 = t870 - carry11_2 <<< 21) →
          (ht874 : t874 = carry11_2 * 666643#64) →
          (ht876 : t876 = carry11_2 * 470296#64 + t838) →
          (ht878 : t878 = carry11_2 * 654183#64 + t843) →
          (ht880 : t880 = carry11_2 * 18446744073708553811#64 + t848) →
          (ht882 : t882 = carry11_2 * 136657#64 + t853) →
          (hbt858 : Bnd t858 (-3145729) 3145727) →
          (hbt859 : Bnd t859 0 2097151) →
          (hbcarry7_2 : Bnd carry7_2 (-2) 1) →
          (hbt861 : Bnd t861 (-127875148) 3485824) →
          (hbt862 : Bnd t862 0 2097151) →
          (hbcarry8_2 : Bnd carry8_2 (-61) 1) →
          (hbt864 : Bnd t864 (-1048637) 1048576) →
          (hbt865 : Bnd t865 0 2097151) →
          (hbcarry9_2 : Bnd carry9_2 (-1) 0) →
          (hbt867 : Bnd t867 (-24207877) 1750290) →
          (hbt868 : Bnd t868 0 2097151) →
          (hbcarry10_2 : Bnd carry10_2 (-12) 0) →
          (hbt870 : Bnd t870 (-1048588) 1048575) →
          (hbt871 : Bnd t871 0 2097151) →
          (hbcarry11_2 : Bnd carry11_2 (-1) 0) →
          (hbs11_12 : Bnd s11_12 0 2097151) →
          (hbt874 : Bnd t874 (-666643) 0) →
          (hbt876 : Bnd t876 (-470296) 2097151) →
          (hbt878 : Bnd t878 (-654183) 2097151) →
          (hbt880 : Bnd t880 0 3094956) →
          (hbt882 : Bnd t882 (-136657) 2097151) → (blk.runBodyFrom E' 445 S >>= g) = K) :
    (blk.runBodyFrom E 420 S >>= g) = K := by
  step_pure with t858
  bnd t858
  step_pure with t859
  bnd t859
  -- carry7 = s7 >> 21;
  step_pure with carry7_2
  bnd carry7_2
  step_pure with t861
  bnd t861
  step_pure with t862
  bnd t862
  -- carry8 = s8 >> 21;
  step_pure with carry8_2
  bnd carry8_2
  step_pure with t864
  bnd t864
  step_pure with t865
  bnd t865
  -- carry9 = s9 >> 21;
  step_pure with carry9_2
  bnd carry9_2
  step_pure with t867
  bnd t867
  step_pure with t868
  bnd t868
  -- carry10 = s10 >> 21;
  step_pure with carry10_2
  bnd carry10_2
  step_pure with t870
  bnd t870
  step_pure with t871
  bnd t871
  -- carry11 = s11 >> 21;
  step_pure with carry11_2
  bnd carry11_2
  step_pure with s11_12
  bnd s11_12
  step_pure [nswMul] with t874
  bnd t874
  step_pure [nswMul]
  step_pure [nswAdd] with t876
  bnd t876
  step_pure [nswMul]
  step_pure [nswAdd] with t878
  bnd t878
  step_pure [nswMul]
  step_pure [nswAdd] with t880
  bnd t880
  step_pure [nswMul]
  step_pure [nswAdd] with t882
  bnd t882
  simp only [Bnd.and_mask_sub] at ht859
  rw [hcarry6_2] at ht859
  simp only [Bnd.and_mask_sub] at ht862
  rw [← hcarry7_2] at ht862
  simp only [Bnd.and_mask_sub] at ht865
  rw [← hcarry8_2] at ht865
  simp only [Bnd.and_mask_sub] at ht868
  rw [← hcarry9_2] at ht868
  simp only [Bnd.and_mask_sub] at ht871
  rw [← hcarry10_2] at ht871
  simp only [Bnd.and_mask_sub] at hs11_12
  rw [← hcarry11_2] at hs11_12
  exact
    hK _ t858 t859 carry7_2 t861 t862 carry8_2 t864 t865 carry9_2 t867 t868 carry10_2 t870 t871
      carry11_2 s11_12 t874 t876 t878 t880 t882 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) ht858 ht859 hcarry7_2 ht861 ht862 hcarry8_2 ht864 ht865 hcarry9_2 ht867 ht868
      hcarry10_2 ht870 ht871 hcarry11_2 hs11_12 ht874 ht876 ht878 ht880 ht882 hbt858 hbt859
      hbcarry7_2 hbt861 hbt862 hbcarry8_2 hbt864 hbt865 hbcarry9_2 hbt867 hbt868 hbcarry10_2 hbt870
      hbt871 hbcarry11_2 hbs11_12 hbt874 hbt876 hbt878 hbt880 hbt882

/-- Instructions `445` to `469`. -/
theorem fd_curve25519_scalar_reduce.run445 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 445 = fd_curve25519_scalar_reduce.entry.body.drop 445)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {t833 t856 t859 t862 t865 t868 t871 carry11_2 s11_12 t874 t876 t878 t880 t882 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hc : fd_curve25519_scalar_reduce.Consts E) (hv : fd_curve25519_scalar_reduce.VConsts E)
    (hR :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 395 := t833,
        rir_reg% fd_curve25519_scalar_reduce.hty 418 := t856,
        rir_reg% fd_curve25519_scalar_reduce.hty 421 := t859,
        rir_reg% fd_curve25519_scalar_reduce.hty 424 := t862,
        rir_reg% fd_curve25519_scalar_reduce.hty 427 := t865,
        rir_reg% fd_curve25519_scalar_reduce.hty 430 := t868,
        rir_reg% fd_curve25519_scalar_reduce.hty 433 := t871,
        rir_reg% fd_curve25519_scalar_reduce.hty 434 := carry11_2,
        rir_reg% fd_curve25519_scalar_reduce.hty 435 := s11_12,
        rir_reg% fd_curve25519_scalar_reduce.hty 436 := t874,
        rir_reg% fd_curve25519_scalar_reduce.hty 438 := t876,
        rir_reg% fd_curve25519_scalar_reduce.hty 440 := t878,
        rir_reg% fd_curve25519_scalar_reduce.hty 442 := t880,
        rir_reg% fd_curve25519_scalar_reduce.hty 444 := t882])
    (hbt833 : Bnd t833 0 2097151) (hbt856 : Bnd t856 0 2097151) (hbt859 : Bnd t859 0 2097151)
    (hbt862 : Bnd t862 0 2097151) (hbt865 : Bnd t865 0 2097151) (hbt868 : Bnd t868 0 2097151)
    (hbt871 : Bnd t871 0 2097151) (hbcarry11_2 : Bnd carry11_2 (-1) 0)
    (hbs11_12 : Bnd s11_12 0 2097151) (hbt874 : Bnd t874 (-666643) 0)
    (hbt876 : Bnd t876 (-470296) 2097151) (hbt878 : Bnd t878 (-654183) 2097151)
    (hbt880 : Bnd t880 0 3094956) (hbt882 : Bnd t882 (-136657) 2097151)
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫)
        (s0_5 carry0_2 s1_9 carry1_2 s2_10 carry2_2 s3_11 carry3_2 s4_12 carry4_2 s5_13 carry5_2
          s6_12 carry6_3 s7_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 carry10_3 t907 :
          BitVec 64),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (hc : fd_curve25519_scalar_reduce.Consts E') →
          (hv : fd_curve25519_scalar_reduce.VConsts E') →
          (hR :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 447 := s0_5,
              rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9,
              rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10,
              rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11,
              rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12,
              rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13,
              rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (hs0_5 : s0_5 = t874 + t833) →
          (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) →
          (hs1_9 : s1_9 = t876 + carry0_2) →
          (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21) →
          (hs2_10 : s2_10 = t878 + carry1_2) →
          (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) →
          (hs3_11 : s3_11 = t880 + carry2_2) →
          (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21) →
          (hs4_12 : s4_12 = t882 + carry3_2) →
          (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) →
          (hs5_13 : s5_13 = carry11_2 * 18446744073708867715#64 + t856 + carry4_2) →
          (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21) →
          (hs6_12 : s6_12 = carry5_2 + t859) →
          (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) →
          (hs7_13 : s7_13 = carry6_3 + t862) →
          (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21) →
          (hs8_13 : s8_13 = carry7_3 + t865) →
          (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) →
          (hs9_13 : s9_13 = carry8_3 + t868) →
          (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21) →
          (hs10_13 : s10_13 = carry9_3 + t871) →
          (hcarry10_3 : carry10_3 = s10_13 >>> 21) →
          (ht907 : t907 = carry10_3 + s11_12) →
          (hbs0_5 : Bnd s0_5 (-666643) 2097151) →
          (hbcarry0_2 : Bnd carry0_2 (-1) 0) →
          (hbs1_9 : Bnd s1_9 (-470297) 2097151) →
          (hbcarry1_2 : Bnd carry1_2 (-1) 0) →
          (hbs2_10 : Bnd s2_10 (-654184) 2097151) →
          (hbcarry2_2 : Bnd carry2_2 (-1) 0) →
          (hbs3_11 : Bnd s3_11 (-1) 3094956) →
          (hbcarry3_2 : Bnd carry3_2 (-1) 1) →
          (hbs4_12 : Bnd s4_12 (-136658) 2097152) →
          (hbcarry4_2 : Bnd carry4_2 (-1) 1) →
          (hbs5_13 : Bnd s5_13 (-1) 2781053) →
          (hbcarry5_2 : Bnd carry5_2 (-1) 1) →
          (hbs6_12 : Bnd s6_12 (-1) 2097152) →
          (hbcarry6_3 : Bnd carry6_3 (-1) 1) →
          (hbs7_13 : Bnd s7_13 (-1) 2097152) →
          (hbcarry7_3 : Bnd carry7_3 (-1) 1) →
          (hbs8_13 : Bnd s8_13 (-1) 2097152) →
          (hbcarry8_3 : Bnd carry8_3 (-1) 1) →
          (hbs9_13 : Bnd s9_13 (-1) 2097152) →
          (hbcarry9_3 : Bnd carry9_3 (-1) 1) →
          (hbs10_13 : Bnd s10_13 (-1) 2097152) →
          (hbcarry10_3 : Bnd carry10_3 0 8796093022207) →
          (hbt907 : Bnd t907 0 8796095119358) → (blk.runBodyFrom E' 470 S >>= g) = K) :
    (blk.runBodyFrom E 445 S >>= g) = K := by
  step_pure [nswMul]
  step_pure [nswAdd]
  step_pure [nswAdd] with s0_5
  bnd s0_5
  -- carry0 = s0 >> 21;
  step_pure with carry0_2
  bnd carry0_2
  step_pure [nswAdd] with s1_9
  bnd s1_9
  -- carry1 = s1 >> 21;
  step_pure with carry1_2
  bnd carry1_2
  step_pure [nswAdd] with s2_10
  bnd s2_10
  -- carry2 = s2 >> 21;
  step_pure with carry2_2
  bnd carry2_2
  step_pure [nswAdd] with s3_11
  bnd s3_11
  -- carry3 = s3 >> 21;
  step_pure with carry3_2
  bnd carry3_2
  step_pure [nswAdd] with s4_12
  bnd s4_12
  -- carry4 = s4 >> 21;
  step_pure with carry4_2
  bnd carry4_2
  step_pure [nswAdd] with s5_13
  bnd s5_13
  -- carry5 = s5 >> 21;
  step_pure with carry5_2
  bnd carry5_2
  step_pure [nswAdd] with s6_12
  bnd s6_12
  -- carry6 = s6 >> 21;
  step_pure with carry6_3
  bnd carry6_3
  step_pure [nswAdd] with s7_13
  bnd s7_13
  -- carry7 = s7 >> 21;
  step_pure with carry7_3
  bnd carry7_3
  step_pure [nswAdd] with s8_13
  bnd s8_13
  -- carry8 = s8 >> 21;
  step_pure with carry8_3
  bnd carry8_3
  step_pure [nswAdd] with s9_13
  bnd s9_13
  -- carry9 = s9 >> 21;
  step_pure with carry9_3
  bnd carry9_3
  step_pure [nswAdd] with s10_13
  bnd s10_13
  -- carry10 = s10 >> 21;
  step_pure with carry10_3
  bnd carry10_3
  step_pure [nswAdd, nuwAdd] with t907
  bnd t907
  exact
    hK _ s0_5 carry0_2 s1_9 carry1_2 s2_10 carry2_2 s3_11 carry3_2 s4_12 carry4_2 s5_13 carry5_2
      s6_12 carry6_3 s7_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 carry10_3 t907 hArgs
      (by
        unfold fd_curve25519_scalar_reduce.Consts; env_reads)
      (by
        unfold fd_curve25519_scalar_reduce.VConsts; env_reads)
      (by env_reads) hs0_5 hcarry0_2 hs1_9 hcarry1_2 hs2_10 hcarry2_2 hs3_11 hcarry3_2 hs4_12
      hcarry4_2 hs5_13 hcarry5_2 hs6_12 hcarry6_3 hs7_13 hcarry7_3 hs8_13 hcarry8_3 hs9_13 hcarry9_3
      hs10_13 hcarry10_3 ht907 hbs0_5 hbcarry0_2 hbs1_9 hbcarry1_2 hbs2_10 hbcarry2_2 hbs3_11
      hbcarry3_2 hbs4_12 hbcarry4_2 hbs5_13 hbcarry5_2 hbs6_12 hbcarry6_3 hbs7_13 hbcarry7_3 hbs8_13
      hbcarry8_3 hbs9_13 hbcarry9_3 hbs10_13 hbcarry10_3 hbt907

attribute [-mlir_operation] zipWith_eq_ofFn

/-! The lanes `or disjoint` joins share no bit. -/

theorem fd_curve25519_scalar_reduce.disj927_0 (s0_5 s1_9 : BitVec 64) :
    (s1_9 <<< 21 &&& 4398044413952#64) &&& (s0_5 &&& 2097151#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj927_1 (s3_11 s4_12 : BitVec 64) :
    (s4_12 <<< 20 &&& 2199022206976#64) &&& (s3_11 >>> 1 &&& 1048575#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj927_2 (s6_12 s7_13 : BitVec 64) :
    (s7_13 <<< 19 &&& 1099511103488#64) &&& (s6_12 >>> 2 &&& 524287#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj927_3 (s10_13 : BitVec 64) :
    (s10_13 <<< 18 &&& 549755551744#64) &&& (0#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj928_0 (s0_5 s1_9 s2_10 : BitVec 64) :
    (s2_10 <<< 42 &&& 9223367638808264704#64) &&&
        (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj928_1 (s3_11 s4_12 s5_13 : BitVec 64) :
    (s5_13 <<< 41 &&& 4611683819404132352#64) &&&
        (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj928_2 (s6_12 s7_13 s8_13 : BitVec 64) :
    (s8_13 <<< 40 &&& 2305841909702066176#64) &&&
        (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj928_3 (s9_13 s10_13 : BitVec 64) :
    (s9_13 >>> 3 &&& 262143#64) &&& (s10_13 <<< 18 &&& 549755551744#64) = 0#64 := by bv_decide

theorem fd_curve25519_scalar_reduce.disj934_0 (s0_5 s1_9 s2_10 s3_11 : BitVec 64) :
    (s2_10 <<< 42 &&& 9223367638808264704#64 |||
          (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64)) &&&
        (s3_11 <<< 63) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj934_1 (s3_11 s4_12 s5_13 s6_12 : BitVec 64) :
    (s5_13 <<< 41 &&& 4611683819404132352#64 |||
          (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64)) &&&
        (s6_12 <<< 62) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj934_2 (s6_12 s7_13 s8_13 s9_13 : BitVec 64) :
    (s8_13 <<< 40 &&& 2305841909702066176#64 |||
          (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64)) &&&
        (s9_13 <<< 61) =
      0#64 := by
  bv_decide

theorem fd_curve25519_scalar_reduce.disj934_3 (s9_13 s10_13 t907 : BitVec 64) :
    (s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64) &&& (t907 <<< 39) = 0#64 := by
  bv_decide

/-! The packing, one instruction a run: past a write, a step this deep in the context
(index ~490 of `Γ.vals`) exceeds the default `maxRecDepth`. -/

theorem fd_curve25519_scalar_reduce.run470 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 470 = fd_curve25519_scalar_reduce.entry.body.drop 470)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (hv : fd_curve25519_scalar_reduce.VConsts E)
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h885 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 447 := s0_5])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h889 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h895 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h901 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h445 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 7 :=
              Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64]]) →
          (h446 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 8 :=
              Ty.wrap #v[0#64, 1#64, 2#64, 0#64]]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h889 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h895 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h901 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h908 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 470 :=
              #v[PoisonOr.value s0_5, PoisonOr.poison, PoisonOr.poison,
                PoisonOr.value 18446744073709551615#64]]) →
          (blk.runBodyFrom E' 471 S >>= g) = K) :
    (blk.runBodyFrom E 470 S >>= g) = K := by
  obtain ⟨h438, h439, h440, h441, h442, h443, h444, h445, h446, h447, h492⟩ := hv
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads)

theorem fd_curve25519_scalar_reduce.run471 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 471 = fd_curve25519_scalar_reduce.entry.body.drop 471)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h445 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 7 :=
        Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64]])
    (h446 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 8 := Ty.wrap #v[0#64, 1#64, 2#64, 0#64]])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h889 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h895 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h901 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h908 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 470 :=
        #v[PoisonOr.value s0_5, PoisonOr.poison, PoisonOr.poison,
          PoisonOr.value 18446744073709551615#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h445 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 7 :=
              Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64]]) →
          (h446 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 8 :=
              Ty.wrap #v[0#64, 1#64, 2#64, 0#64]]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h889 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h895 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h901 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h909 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 471 :=
              #v[PoisonOr.value s0_5, PoisonOr.value s3_11, PoisonOr.poison,
                PoisonOr.value 18446744073709551615#64]]) →
          (blk.runBodyFrom E' 472 S >>= g) = K) :
    (blk.runBodyFrom E 471 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads)

theorem fd_curve25519_scalar_reduce.run472 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 472 = fd_curve25519_scalar_reduce.entry.body.drop 472)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h445 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 7 :=
        Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64]])
    (h446 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 8 := Ty.wrap #v[0#64, 1#64, 2#64, 0#64]])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h889 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h895 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h901 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h909 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 471 :=
        #v[PoisonOr.value s0_5, PoisonOr.value s3_11, PoisonOr.poison,
          PoisonOr.value 18446744073709551615#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h445 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 7 :=
              Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64]]) →
          (h446 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 8 :=
              Ty.wrap #v[0#64, 1#64, 2#64, 0#64]]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h889 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h895 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h901 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h910 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 472 :=
              Ty.wrap #v[s0_5, s3_11, s6_12, 18446744073709551615#64]]) →
          (blk.runBodyFrom E' 473 S >>= g) = K) :
    (blk.runBodyFrom E 472 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads)

theorem fd_curve25519_scalar_reduce.run473 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 473 = fd_curve25519_scalar_reduce.entry.body.drop 473)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h445 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 7 :=
        Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64]])
    (h446 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 8 := Ty.wrap #v[0#64, 1#64, 2#64, 0#64]])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h889 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h895 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h901 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h910 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 472 :=
        Ty.wrap #v[s0_5, s3_11, s6_12, 18446744073709551615#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h445 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 7 :=
              Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64]]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h889 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h895 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h901 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h911 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 473 :=
              Ty.wrap #v[s0_5, s3_11 >>> 1, s6_12 >>> 2, 18446744073709551615#64]]) →
          (blk.runBodyFrom E' 474 S >>= g) = K) :
    (blk.runBodyFrom E 473 S >>= g) = K := by
  step_pure [expandZipWith]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run474 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 474 = fd_curve25519_scalar_reduce.entry.body.drop 474)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h445 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 7 :=
        Ty.wrap #v[2097151#64, 1048575#64, 524287#64, 0#64]])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h889 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h895 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h901 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h911 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 473 :=
        Ty.wrap #v[s0_5, s3_11 >>> 1, s6_12 >>> 2, 18446744073709551615#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h889 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h895 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h901 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (blk.runBodyFrom E' 475 S >>= g) = K) :
    (blk.runBodyFrom E 474 S >>= g) = K := by
  step_pure [expandZipWith]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run475 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 475 = fd_curve25519_scalar_reduce.entry.body.drop 475)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h889 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 451 := s2_10])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h895 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h901 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h895 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h901 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h913 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 475 :=
              #v[PoisonOr.value s2_10, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]]) →
          (blk.runBodyFrom E' 476 S >>= g) = K) :
    (blk.runBodyFrom E 475 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run476 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 476 = fd_curve25519_scalar_reduce.entry.body.drop 476)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h895 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 457 := s5_13])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h901 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h913 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 475 :=
        #v[PoisonOr.value s2_10, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h901 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h914 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 476 :=
              #v[PoisonOr.value s2_10, PoisonOr.value s5_13, PoisonOr.poison, PoisonOr.poison]]) →
          (blk.runBodyFrom E' 477 S >>= g) = K) :
    (blk.runBodyFrom E 476 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run477 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 477 = fd_curve25519_scalar_reduce.entry.body.drop 477)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h901 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 463 := s8_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h914 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 476 :=
        #v[PoisonOr.value s2_10, PoisonOr.value s5_13, PoisonOr.poison, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h915 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 477 :=
              #v[PoisonOr.value s2_10, PoisonOr.value s5_13, PoisonOr.value s8_13,
                PoisonOr.poison]]) →
          (blk.runBodyFrom E' 478 S >>= g) = K) :
    (blk.runBodyFrom E 477 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run478 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 478 = fd_curve25519_scalar_reduce.entry.body.drop 478)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h915 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 477 :=
        #v[PoisonOr.value s2_10, PoisonOr.value s5_13, PoisonOr.value s8_13, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h916 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 478 :=
              Ty.wrap #v[s2_10, s5_13, s8_13, s9_13]]) →
          (blk.runBodyFrom E' 479 S >>= g) = K) :
    (blk.runBodyFrom E 478 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run479 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 479 = fd_curve25519_scalar_reduce.entry.body.drop 479)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h916 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 478 := Ty.wrap #v[s2_10, s5_13, s8_13, s9_13]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h442 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 :=
              Ty.wrap #v[42#64, 41#64, 40#64, 3#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h916 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 478 :=
              Ty.wrap #v[s2_10, s5_13, s8_13, s9_13]]) →
          (h917 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 479 :=
              Ty.wrap #v[s2_10 <<< 42, s5_13 <<< 41, s8_13 <<< 40, s9_13 <<< 3]]) →
          (blk.runBodyFrom E' 480 S >>= g) = K) :
    (blk.runBodyFrom E 479 S >>= g) = K := by
  step_pure [expandZipWith]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run480 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 480 = fd_curve25519_scalar_reduce.entry.body.drop 480)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h442 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 4 := Ty.wrap #v[42#64, 41#64, 40#64, 3#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h916 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 478 := Ty.wrap #v[s2_10, s5_13, s8_13, s9_13]])
    (h917 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 479 :=
        Ty.wrap #v[s2_10 <<< 42, s5_13 <<< 41, s8_13 <<< 40, s9_13 <<< 3]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h917 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 479 :=
              Ty.wrap #v[s2_10 <<< 42, s5_13 <<< 41, s8_13 <<< 40, s9_13 <<< 3]]) →
          (h918 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 480 :=
              Ty.wrap #v[s2_10 >>> 42, s5_13 >>> 41, s8_13 >>> 40, s9_13 >>> 3]]) →
          (blk.runBodyFrom E' 481 S >>= g) = K) :
    (blk.runBodyFrom E 480 S >>= g) = K := by
  step_pure [expandZipWith]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run481 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 481 = fd_curve25519_scalar_reduce.entry.body.drop 481)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h917 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 479 :=
        Ty.wrap #v[s2_10 <<< 42, s5_13 <<< 41, s8_13 <<< 40, s9_13 <<< 3]])
    (h918 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 480 :=
        Ty.wrap #v[s2_10 >>> 42, s5_13 >>> 41, s8_13 >>> 40, s9_13 >>> 3]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h441 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
              Ty.wrap
                #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64,
                  262143#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h919 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 481 :=
              Ty.wrap #v[s2_10 <<< 42, s5_13 <<< 41, s8_13 <<< 40, s9_13 >>> 3]]) →
          (blk.runBodyFrom E' 482 S >>= g) = K) :
    (blk.runBodyFrom E 481 S >>= g) = K := by
  step_pure
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run482 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 482 = fd_curve25519_scalar_reduce.entry.body.drop 482)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h441 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 3 :=
        Ty.wrap
          #v[9223367638808264704#64, 4611683819404132352#64, 2305841909702066176#64, 262143#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h919 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 481 :=
        Ty.wrap #v[s2_10 <<< 42, s5_13 <<< 41, s8_13 <<< 40, s9_13 >>> 3]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h887 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h920 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
                  s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]]) →
          (blk.runBodyFrom E' 483 S >>= g) = K) :
    (blk.runBodyFrom E 482 S >>= g) = K := by
  step_pure [expandZipWith]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads)

theorem fd_curve25519_scalar_reduce.run483 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 483 = fd_curve25519_scalar_reduce.entry.body.drop 483)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h887 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 449 := s1_9])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h920 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
            s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h893 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h920 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
                  s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]]) →
          (h921 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 483 :=
              #v[PoisonOr.value s1_9, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]]) →
          (blk.runBodyFrom E' 484 S >>= g) = K) :
    (blk.runBodyFrom E 483 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads)

theorem fd_curve25519_scalar_reduce.run484 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 484 = fd_curve25519_scalar_reduce.entry.body.drop 484)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h893 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 455 := s4_12])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h920 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
            s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]])
    (h921 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 483 :=
        #v[PoisonOr.value s1_9, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h899 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h920 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
                  s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]]) →
          (h922 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 484 :=
              #v[PoisonOr.value s1_9, PoisonOr.value s4_12, PoisonOr.poison, PoisonOr.poison]]) →
          (blk.runBodyFrom E' 485 S >>= g) = K) :
    (blk.runBodyFrom E 484 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run485 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 485 = fd_curve25519_scalar_reduce.entry.body.drop 485)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h899 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 461 := s7_13])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h920 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
            s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]])
    (h922 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 484 :=
        #v[PoisonOr.value s1_9, PoisonOr.value s4_12, PoisonOr.poison, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h905 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h920 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
                  s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]]) →
          (h923 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 485 :=
              #v[PoisonOr.value s1_9, PoisonOr.value s4_12, PoisonOr.value s7_13,
                PoisonOr.poison]]) →
          (blk.runBodyFrom E' 486 S >>= g) = K) :
    (blk.runBodyFrom E 485 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run486 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 486 = fd_curve25519_scalar_reduce.entry.body.drop 486)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h905 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 467 := s10_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h920 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
            s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]])
    (h923 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 485 :=
        #v[PoisonOr.value s1_9, PoisonOr.value s4_12, PoisonOr.value s7_13, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h440 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 :=
              Ty.wrap #v[21#64, 20#64, 19#64, 18#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h920 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
                  s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]]) →
          (h924 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 486 :=
              Ty.wrap #v[s1_9, s4_12, s7_13, s10_13]]) →
          (blk.runBodyFrom E' 487 S >>= g) = K) :
    (blk.runBodyFrom E 486 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run487 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 487 = fd_curve25519_scalar_reduce.entry.body.drop 487)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h440 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 2 := Ty.wrap #v[21#64, 20#64, 19#64, 18#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h920 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
            s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]])
    (h924 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 486 := Ty.wrap #v[s1_9, s4_12, s7_13, s10_13]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h439 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
              Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h920 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
                  s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]]) →
          (h925 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 487 :=
              Ty.wrap #v[s1_9 <<< 21, s4_12 <<< 20, s7_13 <<< 19, s10_13 <<< 18]]) →
          (blk.runBodyFrom E' 488 S >>= g) = K) :
    (blk.runBodyFrom E 487 S >>= g) = K := by
  step_pure [expandZipWith]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run488 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 488 = fd_curve25519_scalar_reduce.entry.body.drop 488)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h439 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 1 :=
        Ty.wrap #v[4398044413952#64, 2199022206976#64, 1099511103488#64, 549755551744#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h920 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
            s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]])
    (h925 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 487 :=
        Ty.wrap #v[s1_9 <<< 21, s4_12 <<< 20, s7_13 <<< 19, s10_13 <<< 18]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h912 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
              Ty.wrap
                #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64,
                  0#64]]) →
          (h920 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
                  s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]]) →
          (h926 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 488 :=
              Ty.wrap
                #v[s1_9 <<< 21 &&& 4398044413952#64, s4_12 <<< 20 &&& 2199022206976#64,
                  s7_13 <<< 19 &&& 1099511103488#64, s10_13 <<< 18 &&& 549755551744#64]]) →
          (blk.runBodyFrom E' 489 S >>= g) = K) :
    (blk.runBodyFrom E 488 S >>= g) = K := by
  step_pure [expandZipWith]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run489 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 489 = fd_curve25519_scalar_reduce.entry.body.drop 489)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h912 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 474 :=
        Ty.wrap
          #v[s0_5 &&& 2097151#64, s3_11 >>> 1 &&& 1048575#64, s6_12 >>> 2 &&& 524287#64, 0#64]])
    (h920 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
            s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]])
    (h926 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 488 :=
        Ty.wrap
          #v[s1_9 <<< 21 &&& 4398044413952#64, s4_12 <<< 20 &&& 2199022206976#64,
            s7_13 <<< 19 &&& 1099511103488#64, s10_13 <<< 18 &&& 549755551744#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h920 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
                  s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]]) →
          (h927 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 489 :=
              Ty.wrap
                #v[s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64,
                  s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64,
                  s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64,
                  s10_13 <<< 18 &&& 549755551744#64]]) →
          (blk.runBodyFrom E' 490 S >>= g) = K) :
    (blk.runBodyFrom E 489 S >>= g) = K := by
  step_pure [expandZipWith, fd_curve25519_scalar_reduce.disj927_0,
    fd_curve25519_scalar_reduce.disj927_1, fd_curve25519_scalar_reduce.disj927_2,
    fd_curve25519_scalar_reduce.disj927_3]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads)

theorem fd_curve25519_scalar_reduce.run490 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 490 = fd_curve25519_scalar_reduce.entry.body.drop 490)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h920 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 482 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64, s5_13 <<< 41 &&& 4611683819404132352#64,
            s8_13 <<< 40 &&& 2305841909702066176#64, s9_13 >>> 3 &&& 262143#64]])
    (h927 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 489 :=
        Ty.wrap
          #v[s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64,
            s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64,
            s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64,
            s10_13 <<< 18 &&& 549755551744#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h444 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 :=
              Vector.replicate 4 PoisonOr.poison]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h459 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h891 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h928 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                    (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
                  s5_13 <<< 41 &&& 4611683819404132352#64 |||
                    (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
                  s8_13 <<< 40 &&& 2305841909702066176#64 |||
                    (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
                  s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]]) →
          (blk.runBodyFrom E' 491 S >>= g) = K) :
    (blk.runBodyFrom E 490 S >>= g) = K := by
  step_pure [expandZipWith, fd_curve25519_scalar_reduce.disj928_0,
    fd_curve25519_scalar_reduce.disj928_1, fd_curve25519_scalar_reduce.disj928_2,
    fd_curve25519_scalar_reduce.disj928_3]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run491 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 491 = fd_curve25519_scalar_reduce.entry.body.drop 491)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h444 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 6 := Vector.replicate 4 PoisonOr.poison])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h459 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 21 := 0#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h891 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 453 := s3_11])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h928 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
              (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
            s5_13 <<< 41 &&& 4611683819404132352#64 |||
              (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
            s8_13 <<< 40 &&& 2305841909702066176#64 |||
              (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
            s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h460 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64]) →
          (h897 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h928 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                    (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
                  s5_13 <<< 41 &&& 4611683819404132352#64 |||
                    (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
                  s8_13 <<< 40 &&& 2305841909702066176#64 |||
                    (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
                  s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]]) →
          (h929 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 491 :=
              #v[PoisonOr.value s3_11, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]]) →
          (blk.runBodyFrom E' 492 S >>= g) = K) :
    (blk.runBodyFrom E 491 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run492 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 492 = fd_curve25519_scalar_reduce.entry.body.drop 492)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h460 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 22 := 1#64])
    (h897 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 459 := s6_12])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h928 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
              (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
            s5_13 <<< 41 &&& 4611683819404132352#64 |||
              (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
            s8_13 <<< 40 &&& 2305841909702066176#64 |||
              (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
            s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]])
    (h929 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 491 :=
        #v[PoisonOr.value s3_11, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h447 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64]) →
          (h903 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h928 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                    (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
                  s5_13 <<< 41 &&& 4611683819404132352#64 |||
                    (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
                  s8_13 <<< 40 &&& 2305841909702066176#64 |||
                    (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
                  s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]]) →
          (h930 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 492 :=
              #v[PoisonOr.value s3_11, PoisonOr.value s6_12, PoisonOr.poison, PoisonOr.poison]]) →
          (blk.runBodyFrom E' 493 S >>= g) = K) :
    (blk.runBodyFrom E 492 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact
    hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)
      (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run493 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 493 = fd_curve25519_scalar_reduce.entry.body.drop 493)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h447 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 9 := 2#64])
    (h903 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 465 := s9_13])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h928 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
              (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
            s5_13 <<< 41 &&& 4611683819404132352#64 |||
              (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
            s8_13 <<< 40 &&& 2305841909702066176#64 |||
              (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
            s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]])
    (h930 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 492 :=
        #v[PoisonOr.value s3_11, PoisonOr.value s6_12, PoisonOr.poison, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h443 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64]) →
          (h907 : E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907]) →
          (h928 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                    (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
                  s5_13 <<< 41 &&& 4611683819404132352#64 |||
                    (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
                  s8_13 <<< 40 &&& 2305841909702066176#64 |||
                    (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
                  s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]]) →
          (h931 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 493 :=
              #v[PoisonOr.value s3_11, PoisonOr.value s6_12, PoisonOr.value s9_13,
                PoisonOr.poison]]) →
          (blk.runBodyFrom E' 494 S >>= g) = K) :
    (blk.runBodyFrom E 493 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact hK _ hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run494 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 494 = fd_curve25519_scalar_reduce.entry.body.drop 494)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h443 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 5 := 3#64])
    (h907 : E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 469 := t907])
    (h928 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
              (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
            s5_13 <<< 41 &&& 4611683819404132352#64 |||
              (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
            s8_13 <<< 40 &&& 2305841909702066176#64 |||
              (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
            s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]])
    (h931 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 493 :=
        #v[PoisonOr.value s3_11, PoisonOr.value s6_12, PoisonOr.value s9_13, PoisonOr.poison]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h438 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 :=
              Ty.wrap #v[63#64, 62#64, 61#64, 39#64]]) →
          (h928 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                    (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
                  s5_13 <<< 41 &&& 4611683819404132352#64 |||
                    (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
                  s8_13 <<< 40 &&& 2305841909702066176#64 |||
                    (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
                  s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]]) →
          (h932 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 494 :=
              Ty.wrap #v[s3_11, s6_12, s9_13, t907]]) →
          (blk.runBodyFrom E' 495 S >>= g) = K) :
    (blk.runBodyFrom E 494 S >>= g) = K := by
  step_pure [reduceVectorSet]
  exact hK _ hArgs (by env_reads) (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run495 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 495 = fd_curve25519_scalar_reduce.entry.body.drop 495)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h438 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 0 := Ty.wrap #v[63#64, 62#64, 61#64, 39#64]])
    (h928 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
              (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
            s5_13 <<< 41 &&& 4611683819404132352#64 |||
              (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
            s8_13 <<< 40 &&& 2305841909702066176#64 |||
              (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
            s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]])
    (h932 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 494 := Ty.wrap #v[s3_11, s6_12, s9_13, t907]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h928 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                    (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
                  s5_13 <<< 41 &&& 4611683819404132352#64 |||
                    (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
                  s8_13 <<< 40 &&& 2305841909702066176#64 |||
                    (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
                  s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]]) →
          (h933 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 495 :=
              Ty.wrap #v[s3_11 <<< 63, s6_12 <<< 62, s9_13 <<< 61, t907 <<< 39]]) →
          (blk.runBodyFrom E' 496 S >>= g) = K) :
    (blk.runBodyFrom E 495 S >>= g) = K := by
  step_pure [expandZipWith]
  exact hK _ hArgs (by env_reads) (by env_reads)

theorem fd_curve25519_scalar_reduce.run496 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 496 = fd_curve25519_scalar_reduce.entry.body.drop 496)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get)
    (h928 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 490 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
              (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64),
            s5_13 <<< 41 &&& 4611683819404132352#64 |||
              (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64),
            s8_13 <<< 40 &&& 2305841909702066176#64 |||
              (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64),
            s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64]])
    (h933 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 495 :=
        Ty.wrap #v[s3_11 <<< 63, s6_12 <<< 62, s9_13 <<< 61, t907 <<< 39]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (h934 :
            E' ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 496 :=
              Ty.wrap
                #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                    (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64) |||
                    s3_11 <<< 63,
                  s5_13 <<< 41 &&& 4611683819404132352#64 |||
                    (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64) |||
                    s6_12 <<< 62,
                  s8_13 <<< 40 &&& 2305841909702066176#64 |||
                    (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64) |||
                    s9_13 <<< 61,
                  s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64 |||
                    t907 <<< 39]]) →
          (blk.runBodyFrom E' 497 S >>= g) = K) :
    (blk.runBodyFrom E 496 S >>= g) = K := by
  step_pure [expandZipWith, fd_curve25519_scalar_reduce.disj934_0,
    fd_curve25519_scalar_reduce.disj934_1, fd_curve25519_scalar_reduce.disj934_2,
    fd_curve25519_scalar_reduce.disj934_3]
  exact hK _ hArgs (by env_reads)

/-- The store of the packed limbs. -/
theorem fd_curve25519_scalar_reduce.run497 {β : Type} {out inp : Pointer}
    {blk : BasicBlock fd_curve25519_scalar_reduce.Γ [Ty.ptr] fd_curve25519_scalar_reduce.blockTys}
    (hbody : blk.body.drop 497 = fd_curve25519_scalar_reduce.entry.body.drop 497)
    {E : ⟪fd_curve25519_scalar_reduce.Γ⟫} {S : GlobalState}
    {g : ⟪fd_curve25519_scalar_reduce.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {s0_5 s1_9 s2_10 s3_11 s4_12 s5_13 s6_12 s7_13 s8_13 s9_13 s10_13 t907 : BitVec 64}
    (hArgs : E.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) (hwf : S.WF)
    (hout : Fits S.mem out (8 * 32))
    (h934 :
      E ⊨ [rir_reg% fd_curve25519_scalar_reduce.hty 496 :=
        Ty.wrap
          #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
              (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64) |||
              s3_11 <<< 63,
            s5_13 <<< 41 &&& 4611683819404132352#64 |||
              (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64) |||
              s6_12 <<< 62,
            s8_13 <<< 40 &&& 2305841909702066176#64 |||
              (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64) |||
              s9_13 <<< 61,
            s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64 ||| t907 <<< 39]])
    (hK :
      ∀ (E' : ⟪fd_curve25519_scalar_reduce.Γ⟫),
        (hArgs : E'.args = (fd_curve25519_scalar_reduce.args (.value out) (.value inp)).get) →
          (blk.runBodyFrom E' 498
                { S with
                  mem :=
                    S.mem.storeAt out
                      (BitVec.packLanes
                        #v[s2_10 <<< 42 &&& 9223367638808264704#64 |||
                            (s1_9 <<< 21 &&& 4398044413952#64 ||| s0_5 &&& 2097151#64) |||
                            s3_11 <<< 63,
                          s5_13 <<< 41 &&& 4611683819404132352#64 |||
                            (s4_12 <<< 20 &&& 2199022206976#64 ||| s3_11 >>> 1 &&& 1048575#64) |||
                            s6_12 <<< 62,
                          s8_13 <<< 40 &&& 2305841909702066176#64 |||
                            (s7_13 <<< 19 &&& 1099511103488#64 ||| s6_12 >>> 2 &&& 524287#64) |||
                            s9_13 <<< 61,
                          s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64 |||
                            t907 <<< 39]) } >>=
              g) =
            K) :
    (blk.runBodyFrom E 497 S >>= g) = K := by
  step_store
  subst hS
  exact hK _ hArgs

/-! The C variables, over the earlier ones, as the spec's lets expand. -/

theorem fd_curve25519_scalar_reduce.s0_eq {in0 s0 : BitVec 64} (hs0 : s0 = in0 &&& 2097151#64) :
    s0 = in0 &&& 2097151#64 := by exact hs0

theorem fd_curve25519_scalar_reduce.s1_eq {in0 s1 : BitVec 64}
    (hs1 : s1 = in0 >>> 21 &&& 2097151#64) : s1 = (in0 >>> 21) &&& 2097151#64 := by exact hs1

theorem fd_curve25519_scalar_reduce.s2_eq {in0 s2 : BitVec 64}
    (hs2 : s2 = in0 >>> 42 &&& 2097151#64) : s2 = (in0 >>> 42) &&& 2097151#64 := by exact hs2

theorem fd_curve25519_scalar_reduce.s3_eq {in0 in1 s3 : BitVec 64}
    (hs3 : s3 = BitVec.extractLsb' 64 64 ((in1 ++ in0) <<< 1) &&& 2097151#64) :
    s3 = ((in0 >>> 63) ||| (in1 <<< 1)) &&& 2097151#64 := by
  simp only [hs3, Bnd.fshl_eq _ _ 1 (by decide), Nat.reduceSub]

theorem fd_curve25519_scalar_reduce.s4_eq {in1 s4 : BitVec 64}
    (hs4 : s4 = in1 >>> 20 &&& 2097151#64) : s4 = (in1 >>> 20) &&& 2097151#64 := by exact hs4

theorem fd_curve25519_scalar_reduce.s5_eq {in1 s5 : BitVec 64}
    (hs5 : s5 = in1 >>> 41 &&& 2097151#64) : s5 = (in1 >>> 41) &&& 2097151#64 := by exact hs5

theorem fd_curve25519_scalar_reduce.s6_eq {in1 in2 s6 : BitVec 64}
    (hs6 : s6 = BitVec.extractLsb' 64 64 ((in2 ++ in1) <<< 2) &&& 2097151#64) :
    s6 = ((in1 >>> 62) ||| (in2 <<< 2)) &&& 2097151#64 := by
  simp only [hs6, Bnd.fshl_eq _ _ 2 (by decide), Nat.reduceSub]

theorem fd_curve25519_scalar_reduce.s7_eq {in2 s7 : BitVec 64}
    (hs7 : s7 = in2 >>> 19 &&& 2097151#64) : s7 = (in2 >>> 19) &&& 2097151#64 := by exact hs7

theorem fd_curve25519_scalar_reduce.s8_eq {in2 s8 : BitVec 64}
    (hs8 : s8 = in2 >>> 40 &&& 2097151#64) : s8 = (in2 >>> 40) &&& 2097151#64 := by exact hs8

theorem fd_curve25519_scalar_reduce.s9_eq {in2 in3 s9 : BitVec 64}
    (hs9 : s9 = BitVec.extractLsb' 64 64 ((in3 ++ in2) <<< 3) &&& 2097151#64) :
    s9 = ((in2 >>> 61) ||| (in3 <<< 3)) &&& 2097151#64 := by
  simp only [hs9, Bnd.fshl_eq _ _ 3 (by decide), Nat.reduceSub]

theorem fd_curve25519_scalar_reduce.s10_eq {in3 s10 : BitVec 64}
    (hs10 : s10 = in3 >>> 18 &&& 2097151#64) : s10 = (in3 >>> 18) &&& 2097151#64 := by exact hs10

theorem fd_curve25519_scalar_reduce.s11_eq {in3 s11 : BitVec 64}
    (hs11 : s11 = in3 >>> 39 &&& 2097151#64) : s11 = (in3 >>> 39) &&& 2097151#64 := by exact hs11

theorem fd_curve25519_scalar_reduce.s12_eq {in3 in4 t541 s12 : BitVec 64}
    (hs12 : s12 = t541 &&& 2097151#64)
    (ht541 : t541 = BitVec.extractLsb' 64 64 ((in4 ++ in3) <<< 4)) :
    s12 = ((in3 >>> 60) ||| (in4 <<< 4)) &&& 2097151#64 := by
  simp only [hs12, ht541, Bnd.fshl_eq _ _ 4 (by decide), Nat.reduceSub]

theorem fd_curve25519_scalar_reduce.s13_eq {in4 s13 : BitVec 64}
    (hs13 : s13 = in4 >>> 17 &&& 2097151#64) : s13 = (in4 >>> 17) &&& 2097151#64 := by exact hs13

theorem fd_curve25519_scalar_reduce.s14_eq {in4 s14 : BitVec 64}
    (hs14 : s14 = in4 >>> 38 &&& 2097151#64) : s14 = (in4 >>> 38) &&& 2097151#64 := by exact hs14

theorem fd_curve25519_scalar_reduce.s15_eq {in4 in5 s15 : BitVec 64}
    (hs15 : s15 = BitVec.extractLsb' 64 64 ((in5 ++ in4) <<< 5) &&& 2097151#64) :
    s15 = ((in4 >>> 59) ||| (in5 <<< 5)) &&& 2097151#64 := by
  simp only [hs15, Bnd.fshl_eq _ _ 5 (by decide), Nat.reduceSub]

theorem fd_curve25519_scalar_reduce.s16_eq {in5 s16 : BitVec 64}
    (hs16 : s16 = in5 >>> 16 &&& 2097151#64) : s16 = (in5 >>> 16) &&& 2097151#64 := by exact hs16

theorem fd_curve25519_scalar_reduce.s17_eq {in5 s17 : BitVec 64}
    (hs17 : s17 = in5 >>> 37 &&& 2097151#64) : s17 = (in5 >>> 37) &&& 2097151#64 := by exact hs17

theorem fd_curve25519_scalar_reduce.s18_eq {in5 in6 s18 : BitVec 64}
    (hs18 : s18 = BitVec.extractLsb' 64 64 ((in6 ++ in5) <<< 6) &&& 2097151#64) :
    s18 = ((in5 >>> 58) ||| (in6 <<< 6)) &&& 2097151#64 := by
  simp only [hs18, Bnd.fshl_eq _ _ 6 (by decide), Nat.reduceSub]

theorem fd_curve25519_scalar_reduce.s19_eq {in6 s19 : BitVec 64}
    (hs19 : s19 = in6 >>> 15 &&& 2097151#64) : s19 = (in6 >>> 15) &&& 2097151#64 := by exact hs19

theorem fd_curve25519_scalar_reduce.s20_eq {in6 s20 : BitVec 64}
    (hs20 : s20 = in6 >>> 36 &&& 2097151#64) : s20 = (in6 >>> 36) &&& 2097151#64 := by exact hs20

theorem fd_curve25519_scalar_reduce.s21_eq {in6 in7 s21 : BitVec 64}
    (hs21 : s21 = BitVec.extractLsb' 64 64 ((in7 ++ in6) <<< 7) &&& 2097151#64) :
    s21 = ((in6 >>> 57) ||| (in7 <<< 7)) &&& 2097151#64 := by
  simp only [hs21, Bnd.fshl_eq _ _ 7 (by decide), Nat.reduceSub]

theorem fd_curve25519_scalar_reduce.s22_eq {in7 s22 : BitVec 64}
    (hs22 : s22 = in7 >>> 14 &&& 2097151#64) : s22 = (in7 >>> 14) &&& 2097151#64 := by exact hs22

theorem fd_curve25519_scalar_reduce.s23_eq {in7 s23 : BitVec 64} (hs23 : s23 = in7 >>> 35) :
    s23 = in7 >>> 35 := by exact hs23

theorem fd_curve25519_scalar_reduce.carry6_eq {s6 s18 t616 carry6 : BitVec 64}
    (hcarry6 : carry6 = (t616 + 1048576#64).sshiftRight 21) (ht616 : t616 = s18 * 666643#64 + s6) :
    carry6 = ((s6 + (s18 * 666643#64)) + 1048576#64).sshiftRight 21 := by
  simp only [hcarry6, ht616]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry8_eq {s8 s18 s19 s20 t597 t620 carry8 : BitVec 64}
    (hcarry8 : carry8 = (t620 + 1048576#64).sshiftRight 21)
    (ht620 : t620 = t597 + s19 * 470296#64 + s18 * 654183#64)
    (ht597 : t597 = s20 * 666643#64 + s8) :
    carry8 =
      ((((s8 + (s20 * 666643#64)) + (s19 * 470296#64)) + (s18 * 654183#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry8, ht620, ht597]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry10_eq
    {s10 s18 s19 s20 s21 s22 t581 t590 t627 carry10 : BitVec 64}
    (hcarry10 : carry10 = (t627 + 1048576#64).sshiftRight 21)
    (ht627 :
      t627 = s20 * 654183#64 + s10 + s19 * 18446744073708553811#64 + s18 * 136657#64 + t581 + t590)
    (ht590 : t590 = s21 * 470296#64) (ht581 : t581 = s22 * 666643#64) :
    carry10 =
      ((((((s10 + (s22 * 666643#64)) + (s21 * 470296#64)) + (s20 * 654183#64)) -
                (s19 * 997805#64)) +
              (s18 * 136657#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry10, ht627, ht590, ht581]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry12_eq
    {s12 s19 s20 s21 s22 s23 t572 t583 t592 t614 t652 carry12 : BitVec 64}
    (hcarry12 : carry12 = t652.sshiftRight 21) (ht652 : t652 = t614 + 1048576#64)
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) :
    carry12 =
      ((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                (s20 * 136657#64)) -
              (s19 * 683901#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry12, ht652, ht614, ht592, ht583, ht572]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry14_eq {s14 s21 s22 s23 t595 carry14 : BitVec 64}
    (hcarry14 : carry14 = (t595 + 1048576#64).sshiftRight 21)
    (ht595 :
      t595 =
        s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64) :
    carry14 =
      ((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry14, ht595]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry16_eq {s16 s23 t580 carry16 : BitVec 64}
    (hcarry16 : carry16 = (t580 + 1048576#64).sshiftRight 21)
    (ht580 : t580 = s23 * 18446744073708867715#64 + s16) :
    carry16 = ((s16 - (s23 * 683901#64)) + 1048576#64).sshiftRight 21 := by
  simp only [hcarry16, ht580]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry7_eq {s7 s18 s19 t618 carry6 t631 carry7 : BitVec 64}
    (hcarry7 : carry7 = (t631 + 1048576#64).sshiftRight 21) (ht631 : t631 = t618 + carry6)
    (ht618 : t618 = s19 * 666643#64 + s7 + s18 * 470296#64) :
    carry7 =
      ((((s7 + (s19 * 666643#64)) + (s18 * 470296#64)) + carry6) + 1048576#64).sshiftRight 21 := by
  simp only [hcarry7, ht631, ht618]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry9_eq
    {s9 s18 s19 s20 s21 t589 t598 t607 t621 carry8 t640 carry9 : BitVec 64}
    (hcarry9 : carry9 = (t640 + 1048576#64).sshiftRight 21)
    (ht640 : t640 = t598 + s9 + t607 + t621 + t589 + carry8) (ht589 : t589 = s21 * 666643#64)
    (ht621 : t621 = s18 * 18446744073708553811#64) (ht607 : t607 = s19 * 654183#64)
    (ht598 : t598 = s20 * 470296#64) :
    carry9 =
      ((((((s9 + (s21 * 666643#64)) + (s20 * 470296#64)) + (s19 * 654183#64)) - (s18 * 997805#64)) +
              carry8) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry9, ht640, ht589, ht621, ht607, ht598]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry11_eq
    {s11 s18 s19 s20 s21 s22 s23 t570 t582 t591 t600 t609 carry10 t650 carry11 : BitVec 64}
    (hcarry11 : carry11 = (t650 + 1048576#64).sshiftRight 21)
    (ht650 : t650 = t570 + t600 + t609 + s18 * 18446744073708867715#64 + t582 + t591 + carry10)
    (ht591 : t591 = s21 * 654183#64) (ht582 : t582 = s22 * 470296#64)
    (ht609 : t609 = s19 * 136657#64) (ht600 : t600 = s20 * 18446744073708553811#64)
    (ht570 : t570 = s23 * 666643#64 + s11) :
    carry11 =
      ((((((((s11 + (s23 * 666643#64)) + (s22 * 470296#64)) + (s21 * 654183#64)) -
                    (s20 * 997805#64)) +
                  (s19 * 136657#64)) -
                (s18 * 683901#64)) +
              carry10) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry11, ht650, ht591, ht582, ht609, ht600, ht570]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry13_eq
    {s13 s20 s21 s22 s23 t574 t584 t593 t602 carry12 t657 t681 carry13 : BitVec 64}
    (hcarry13 : carry13 = t681.sshiftRight 21) (ht681 : t681 = t657 + 1048576#64)
    (ht657 : t657 = t574 + t602 + t584 + t593 + carry12) (ht593 : t593 = s21 * 136657#64)
    (ht584 : t584 = s22 * 18446744073708553811#64) (ht602 : t602 = s20 * 18446744073708867715#64)
    (ht574 : t574 = s23 * 654183#64 + s13) :
    carry13 =
      ((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                (s20 * 683901#64)) +
              carry12) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry13, ht681, ht657, ht593, ht584, ht602, ht574]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry15_eq {s15 s22 s23 t588 carry14 t662 carry15 : BitVec 64}
    (hcarry15 : carry15 = (t662 + 1048576#64).sshiftRight 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64) :
    carry15 =
      ((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) + 1048576#64).sshiftRight
        21 := by
  simp only [hcarry15, ht662, ht588]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry0_eq
    {s0 s12 s19 s20 s21 s22 s23 t572 t583 t592 t614 carry12 carry11 t678 t749 carry0 : BitVec 64}
    (hcarry0 : carry0 = (t749 + 1048576#64).sshiftRight 21) (ht749 : t749 = t678 * 666643#64 + s0)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) :
    carry0 =
      ((s0 +
              ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                        (s20 * 136657#64)) -
                      (s19 * 683901#64)) -
                    (carry12 <<< 21)) +
                  carry11) *
                666643#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry0, ht749, ht678, ht614, ht592, ht583, ht572]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry2_eq
    {s2 s12 s13 s14 s19 s20 s21 s22 s23 t572 t574 t583 t584 t592 t593 t595 t602 t614 carry12 t657
      carry14 t664 carry11 t678 carry13 t683 t685 t739 t753 carry2 : BitVec 64}
    (hcarry2 : carry2 = (t753 + 1048576#64).sshiftRight 21) (ht753 : t753 = t739 + t678 * 654183#64)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht739 : t739 = t683 * 666643#64 + s2 + t685 * 470296#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 =
        s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64) :
    carry2 =
      ((((s2 +
                  ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                        (carry14 <<< 21)) +
                      carry13) *
                    666643#64)) +
                (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                        (s20 * 683901#64)) +
                      carry12) -
                    (carry13 <<< 21)) *
                  470296#64)) +
              ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                        (s20 * 136657#64)) -
                      (s19 * 683901#64)) -
                    (carry12 <<< 21)) +
                  carry11) *
                654183#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry2, ht753, ht678, ht614, ht592, ht583, ht572, ht739, ht685, ht657, ht593, ht584,
    ht602, ht574, ht683, ht664, ht595]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry4_eq
    {s4 s12 s13 s14 s16 s15 s19 s20 s21 s22 s23 t572 t574 t580 t583 t584 t588 t592 t593 t595 t602
      t614 carry12 t657 carry14 t662 t664 carry16 t669 carry11 t678 carry13 t683 t685 carry15 t688
      t690 t703 t730 t742 t757 t770 carry4 : BitVec 64}
    (hcarry4 : carry4 = t770.sshiftRight 21) (ht770 : t770 = t757 + 1048576#64)
    (ht757 : t757 = t730 + t742 + t678 * 136657#64)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht742 : t742 = t685 * 18446744073708553811#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht730 : t730 = t703 + t690 * 470296#64 + t683 * 654183#64) (ht683 : t683 = carry13 + t664)
    (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht703 : t703 = t688 * 666643#64 + s4) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16) :
    carry4 =
      ((((((s4 + ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 666643#64)) +
                    (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                        (carry15 <<< 21)) *
                      470296#64)) +
                  ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                        (carry14 <<< 21)) +
                      carry13) *
                    654183#64)) -
                (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                        (s20 * 683901#64)) +
                      carry12) -
                    (carry13 <<< 21)) *
                  997805#64)) +
              ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                        (s20 * 136657#64)) -
                      (s19 * 683901#64)) -
                    (carry12 <<< 21)) +
                  carry11) *
                136657#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry4, ht770, ht757, ht678, ht614, ht592, ht583, ht572, ht742, ht685, ht657, ht593,
    ht584, ht602, ht574, ht730, ht683, ht664, ht595, ht690, ht662, ht588, ht703, ht688, ht669,
    ht580]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry6_1_eq
    {s6 s13 s14 s16 s17 s15 s18 s20 s21 s22 s23 t574 t580 t584 t588 t593 t595 t602 t616 carry6 t633
      carry12 t657 carry14 t662 t664 carry16 t667 t669 carry13 t683 t685 carry15 t688 t690 t707 t734
      t747 carry6_1 : BitVec 64}
    (hcarry6_1 : carry6_1 = (t747 + 1048576#64).sshiftRight 21)
    (ht747 : t747 = t734 + t685 * 18446744073708867715#64) (ht685 : t685 = t657 - carry13 <<< 21)
    (ht657 : t657 = t574 + t602 + t584 + t593 + carry12) (ht593 : t593 = s21 * 136657#64)
    (ht584 : t584 = s22 * 18446744073708553811#64) (ht602 : t602 = s20 * 18446744073708867715#64)
    (ht574 : t574 = s23 * 654183#64 + s13)
    (ht734 : t734 = t707 + t690 * 18446744073708553811#64 + t683 * 136657#64)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht707 : t707 = t633 + t667 * 470296#64 + t688 * 654183#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht667 : t667 = carry16 + s17) (ht633 : t633 = t616 - carry6 <<< 21)
    (ht616 : t616 = s18 * 666643#64 + s6) :
    carry6_1 =
      ((((((((s6 + (s18 * 666643#64)) - (carry6 <<< 21)) + ((s17 + carry16) * 470296#64)) +
                    ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 654183#64)) -
                  (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                      (carry15 <<< 21)) *
                    997805#64)) +
                ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                      (carry14 <<< 21)) +
                    carry13) *
                  136657#64)) -
              (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                      (s20 * 683901#64)) +
                    carry12) -
                  (carry13 <<< 21)) *
                683901#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry6_1, ht747, ht685, ht657, ht593, ht584, ht602, ht574, ht734, ht683, ht664, ht595,
    ht690, ht662, ht588, ht707, ht688, ht669, ht580, ht667, ht633, ht616]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry8_1_eq
    {s8 s16 s17 s15 s18 s19 s20 s22 s23 t580 t588 t597 t620 carry8 t642 carry14 t662 carry16 t667
      t669 carry7 carry15 t688 t690 t696 t709 t724 carry8_1 : BitVec 64}
    (hcarry8_1 : carry8_1 = (t724 + 1048576#64).sshiftRight 21)
    (ht724 : t724 = t642 + t696 + carry7 + t709 + t690 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht709 : t709 = t688 * 136657#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht696 : t696 = t667 * 18446744073708553811#64) (ht667 : t667 = carry16 + s17)
    (ht642 : t642 = t620 - carry8 <<< 21) (ht620 : t620 = t597 + s19 * 470296#64 + s18 * 654183#64)
    (ht597 : t597 = s20 * 666643#64 + s8) :
    carry8_1 =
      (((((((((s8 + (s20 * 666643#64)) + (s19 * 470296#64)) + (s18 * 654183#64)) -
                      (carry8 <<< 21)) +
                    carry7) -
                  ((s17 + carry16) * 997805#64)) +
                ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 136657#64)) -
              (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) - (carry15 <<< 21)) *
                683901#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry8_1, ht724, ht690, ht662, ht588, ht709, ht688, ht669, ht580, ht696, ht667, ht642,
    ht620, ht597]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry10_1_eq
    {s10 s17 s18 s19 s20 s21 s22 t581 t590 t627 carry10 carry16 t667 carry9 t701 carry10_1 :
      BitVec 64}
    (hcarry10_1 : carry10_1 = (t701 + 1048576#64).sshiftRight 21)
    (ht701 : t701 = t627 + t667 * 18446744073708867715#64 - carry10 <<< 21 + carry9)
    (ht667 : t667 = carry16 + s17)
    (ht627 :
      t627 = s20 * 654183#64 + s10 + s19 * 18446744073708553811#64 + s18 * 136657#64 + t581 + t590)
    (ht590 : t590 = s21 * 470296#64) (ht581 : t581 = s22 * 666643#64) :
    carry10_1 =
      (((((((((s10 + (s22 * 666643#64)) + (s21 * 470296#64)) + (s20 * 654183#64)) -
                      (s19 * 997805#64)) +
                    (s18 * 136657#64)) -
                  (carry10 <<< 21)) +
                carry9) -
              ((s17 + carry16) * 683901#64)) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry10_1, ht701, ht667, ht627, ht590, ht581]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry1_eq
    {s1 s12 s13 s19 s20 s21 s22 s23 t572 t574 t583 t584 t592 t593 t602 t614 carry12 t657 carry11
      t678 carry13 t685 t737 carry0 t762 carry1 : BitVec 64}
    (hcarry1 : carry1 = (t762 + 1048576#64).sshiftRight 21)
    (ht762 : t762 = t737 + t678 * 470296#64 + carry0)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht737 : t737 = t685 * 666643#64 + s1)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13) :
    carry1 =
      ((((s1 +
                  (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                          (s20 * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    666643#64)) +
                ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                          (s20 * 136657#64)) -
                        (s19 * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  470296#64)) +
              carry0) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry1, ht762, ht678, ht614, ht592, ht583, ht572, ht737, ht685, ht657, ht593, ht584,
    ht602, ht574]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry3_eq
    {s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 t572 t574 t583 t584 t588 t592 t593 t595 t602 t614
      carry12 t657 carry14 t662 t664 carry11 t678 carry13 t683 t685 carry15 t690 t712 t741 carry2
      t767 t801 carry3 : BitVec 64}
    (hcarry3 : carry3 = t801.sshiftRight 21) (ht801 : t801 = t767 + 1048576#64)
    (ht767 : t767 = t741 + t678 * 18446744073708553811#64 + carry2)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12)
    (ht741 : t741 = t712 + t683 * 470296#64 + t685 * 654183#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht712 : t712 = t690 * 666643#64 + s3) (ht690 : t690 = t662 - carry15 <<< 21)
    (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64) :
    carry3 =
      ((((((s3 +
                      (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                          (carry15 <<< 21)) *
                        666643#64)) +
                    ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                          (carry14 <<< 21)) +
                        carry13) *
                      470296#64)) +
                  (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                          (s20 * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    654183#64)) -
                ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                          (s20 * 136657#64)) -
                        (s19 * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  997805#64)) +
              carry2) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry3, ht801, ht767, ht678, ht614, ht592, ht583, ht572, ht741, ht685, ht657, ht593,
    ht584, ht602, ht574, ht683, ht664, ht595, ht712, ht690, ht662, ht588]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry5_eq
    {s5 s12 s13 s14 s16 s17 s15 s19 s20 s21 s22 s23 t572 t574 t580 t583 t584 t588 t592 t593 t595
      t602 t614 carry12 t657 carry14 t662 t664 carry16 t667 t669 carry11 t678 carry13 t683 t685
      carry15 t688 t690 t705 t732 carry4 t772 carry5 : BitVec 64}
    (hcarry5 : carry5 = (t772 + 1048576#64).sshiftRight 21)
    (ht772 : t772 = t732 + t685 * 136657#64 + t678 * 18446744073708867715#64 + carry4)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht685 : t685 = t657 - carry13 <<< 21)
    (ht657 : t657 = t574 + t602 + t584 + t593 + carry12) (ht593 : t593 = s21 * 136657#64)
    (ht584 : t584 = s22 * 18446744073708553811#64) (ht602 : t602 = s20 * 18446744073708867715#64)
    (ht574 : t574 = s23 * 654183#64 + s13)
    (ht732 : t732 = t705 + t690 * 654183#64 + t683 * 18446744073708553811#64)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht705 : t705 = t667 * 666643#64 + s5 + t688 * 470296#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht667 : t667 = carry16 + s17) :
    carry5 =
      ((((((((s5 + ((s17 + carry16) * 666643#64)) +
                        ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 470296#64)) +
                      (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                          (carry15 <<< 21)) *
                        654183#64)) -
                    ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                          (carry14 <<< 21)) +
                        carry13) *
                      997805#64)) +
                  (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                          (s20 * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    136657#64)) -
                ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                          (s20 * 136657#64)) -
                        (s19 * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  683901#64)) +
              carry4) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry5, ht772, ht678, ht614, ht592, ht583, ht572, ht685, ht657, ht593, ht584, ht602,
    ht574, ht732, ht683, ht664, ht595, ht690, ht662, ht588, ht705, ht688, ht669, ht580, ht667]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry7_1_eq
    {s7 s14 s16 s17 s15 s18 s19 s21 s22 s23 t580 t588 t595 t618 carry6 t631 carry14 t662 t664
      carry16 t667 t669 carry7 carry13 t683 carry15 t688 t690 t695 t708 t719 t735 carry6_1 t782
      carry7_1 : BitVec 64}
    (hcarry7_1 : carry7_1 = (t782 + 1048576#64).sshiftRight 21)
    (ht782 : t782 = t695 + t631 - carry7 <<< 21 + t708 + t719 + t735 + carry6_1)
    (ht735 : t735 = t683 * 18446744073708867715#64) (ht683 : t683 = carry13 + t664)
    (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht719 : t719 = t690 * 136657#64) (ht690 : t690 = t662 - carry15 <<< 21)
    (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht708 : t708 = t688 * 18446744073708553811#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht631 : t631 = t618 + carry6) (ht618 : t618 = s19 * 666643#64 + s7 + s18 * 470296#64)
    (ht695 : t695 = t667 * 654183#64) (ht667 : t667 = carry16 + s17) :
    carry7_1 =
      ((((((((((s7 + (s19 * 666643#64)) + (s18 * 470296#64)) + carry6) - (carry7 <<< 21)) +
                      ((s17 + carry16) * 654183#64)) -
                    ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 997805#64)) +
                  (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                      (carry15 <<< 21)) *
                    136657#64)) -
                ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                      (carry14 <<< 21)) +
                    carry13) *
                  683901#64)) +
              carry6_1) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry7_1, ht782, ht735, ht683, ht664, ht595, ht719, ht690, ht662, ht588, ht708, ht688,
    ht669, ht580, ht631, ht618, ht695, ht667]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry9_1_eq
    {s9 s16 s17 s18 s19 s20 s21 s23 t580 t589 t598 t607 t621 carry8 t640 carry16 t667 t669 carry9
      carry15 t688 t697 t710 carry8_1 t790 carry9_1 : BitVec 64}
    (hcarry9_1 : carry9_1 = (t790 + 1048576#64).sshiftRight 21)
    (ht790 : t790 = t640 + t697 - carry9 <<< 21 + t710 + carry8_1)
    (ht710 : t710 = t688 * 18446744073708867715#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht697 : t697 = t667 * 136657#64) (ht667 : t667 = carry16 + s17)
    (ht640 : t640 = t598 + s9 + t607 + t621 + t589 + carry8) (ht589 : t589 = s21 * 666643#64)
    (ht621 : t621 = s18 * 18446744073708553811#64) (ht607 : t607 = s19 * 654183#64)
    (ht598 : t598 = s20 * 470296#64) :
    carry9_1 =
      ((((((((((s9 + (s21 * 666643#64)) + (s20 * 470296#64)) + (s19 * 654183#64)) -
                        (s18 * 997805#64)) +
                      carry8) -
                    (carry9 <<< 21)) +
                  ((s17 + carry16) * 136657#64)) -
                ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 683901#64)) +
              carry8_1) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry9_1, ht790, ht710, ht688, ht669, ht580, ht697, ht667, ht640, ht589, ht621, ht607,
    ht598]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry11_1_eq
    {s11 s18 s19 s20 s21 s22 s23 t570 t582 t591 t600 t609 carry10 t650 carry11 t680 carry10_1 t795
      carry11_1 : BitVec 64}
    (hcarry11_1 : carry11_1 = (t795 + 1048576#64).sshiftRight 21) (ht795 : t795 = carry10_1 + t680)
    (ht680 : t680 = t650 - carry11 <<< 21)
    (ht650 : t650 = t570 + t600 + t609 + s18 * 18446744073708867715#64 + t582 + t591 + carry10)
    (ht591 : t591 = s21 * 654183#64) (ht582 : t582 = s22 * 470296#64)
    (ht609 : t609 = s19 * 136657#64) (ht600 : t600 = s20 * 18446744073708553811#64)
    (ht570 : t570 = s23 * 666643#64 + s11) :
    carry11_1 =
      ((((((((((s11 + (s23 * 666643#64)) + (s22 * 470296#64)) + (s21 * 654183#64)) -
                        (s20 * 997805#64)) +
                      (s19 * 136657#64)) -
                    (s18 * 683901#64)) +
                  carry10) -
                (carry11 <<< 21)) +
              carry10_1) +
            1048576#64).sshiftRight
        21 := by
  simp only [hcarry11_1, ht795, ht680, ht650, ht591, ht582, ht609, ht600, ht570]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry0_1_eq
    {s0 s12 s19 s20 s21 s22 s23 t572 t583 t592 t614 carry12 carry11 t678 t749 carry0 t764 carry11_1
      t823 carry0_1 : BitVec 64}
    (hcarry0_1 : carry0_1 = t823.sshiftRight 21) (ht823 : t823 = t764 + carry11_1 * 666643#64)
    (ht764 : t764 = t749 - carry0 <<< 21) (ht749 : t749 = t678 * 666643#64 + s0)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) :
    carry0_1 =
      (((s0 +
                ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                          (s20 * 136657#64)) -
                        (s19 * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  666643#64)) -
              (carry0 <<< 21)) +
            ((0#64 + carry11_1) * 666643#64)).sshiftRight
        21 := by
  simp only [hcarry0_1, ht823, ht764, ht749, ht678, ht614, ht592, ht583, ht572]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry1_1_eq
    {s1 s12 s13 s19 s20 s21 s22 s23 t572 t574 t583 t584 t592 t593 t602 t614 carry12 t657 carry11
      t678 carry13 t685 t737 carry0 t762 carry1 carry11_1 carry0_1 t832 carry1_1 : BitVec 64}
    (hcarry1_1 : carry1_1 = t832.sshiftRight 21)
    (ht832 : t832 = carry11_1 * 470296#64 + t762 - carry1 <<< 21 + carry0_1)
    (ht762 : t762 = t737 + t678 * 470296#64 + carry0)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht737 : t737 = t685 * 666643#64 + s1)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13) :
    carry1_1 =
      ((((((s1 +
                      (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                              (s20 * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        666643#64)) +
                    ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                              (s20 * 136657#64)) -
                            (s19 * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      470296#64)) +
                  carry0) -
                (carry1 <<< 21)) +
              ((0#64 + carry11_1) * 470296#64)) +
            carry0_1).sshiftRight
        21 := by
  simp only [hcarry1_1, ht832, ht762, ht678, ht614, ht592, ht583, ht572, ht737, ht685, ht657, ht593,
    ht584, ht602, ht574]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry2_1_eq
    {s2 s12 s13 s14 s19 s20 s21 s22 s23 t572 t574 t583 t584 t592 t593 t595 t602 t614 carry12 t657
      carry14 t664 carry11 t678 carry13 t683 t685 t739 t753 carry2 t769 carry1 carry11_1 t825
      carry1_1 t837 carry2_1 : BitVec 64}
    (hcarry2_1 : carry2_1 = t837.sshiftRight 21) (ht837 : t837 = t769 + t825 + carry1 + carry1_1)
    (ht825 : t825 = carry11_1 * 654183#64) (ht769 : t769 = t753 - carry2 <<< 21)
    (ht753 : t753 = t739 + t678 * 654183#64) (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht739 : t739 = t683 * 666643#64 + s2 + t685 * 470296#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 =
        s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64) :
    carry2_1 =
      (((((((s2 +
                        ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                              (carry14 <<< 21)) +
                            carry13) *
                          666643#64)) +
                      (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                              (s20 * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        470296#64)) +
                    ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                              (s20 * 136657#64)) -
                            (s19 * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      654183#64)) -
                  (carry2 <<< 21)) +
                carry1) +
              ((0#64 + carry11_1) * 654183#64)) +
            carry1_1).sshiftRight
        21 := by
  simp only [hcarry2_1, ht837, ht825, ht769, ht753, ht678, ht614, ht592, ht583, ht572, ht739, ht685,
    ht657, ht593, ht584, ht602, ht574, ht683, ht664, ht595]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry3_1_eq
    {s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 t572 t574 t583 t584 t588 t592 t593 t595 t602 t614
      carry12 t657 carry14 t662 t664 carry11 t678 carry13 t683 t685 carry15 t690 t712 t741 carry2
      t767 carry3 carry11_1 t826 carry2_1 t842 carry3_1 : BitVec 64}
    (hcarry3_1 : carry3_1 = t842.sshiftRight 21)
    (ht842 : t842 = t767 + t826 - carry3 <<< 21 + carry2_1)
    (ht826 : t826 = carry11_1 * 18446744073708553811#64)
    (ht767 : t767 = t741 + t678 * 18446744073708553811#64 + carry2)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12)
    (ht741 : t741 = t712 + t683 * 470296#64 + t685 * 654183#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht712 : t712 = t690 * 666643#64 + s3) (ht690 : t690 = t662 - carry15 <<< 21)
    (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64) :
    carry3_1 =
      ((((((((s3 +
                          (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                              (carry15 <<< 21)) *
                            666643#64)) +
                        ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                              (carry14 <<< 21)) +
                            carry13) *
                          470296#64)) +
                      (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                              (s20 * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        654183#64)) -
                    ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                              (s20 * 136657#64)) -
                            (s19 * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      997805#64)) +
                  carry2) -
                (carry3 <<< 21)) -
              ((0#64 + carry11_1) * 997805#64)) +
            carry2_1).sshiftRight
        21 := by
  simp only [hcarry3_1, ht842, ht826, ht767, ht678, ht614, ht592, ht583, ht572, ht741, ht685, ht657,
    ht593, ht584, ht602, ht574, ht683, ht664, ht595, ht712, ht690, ht662, ht588]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry4_1_eq
    {s4 s12 s13 s14 s16 s15 s19 s20 s21 s22 s23 t572 t574 t580 t583 t584 t588 t592 t593 t595 t602
      t614 carry12 t657 carry14 t662 t664 carry16 t669 carry11 t678 carry13 t683 t685 carry15 t688
      t690 t703 t730 t742 t757 carry4 t774 carry3 carry11_1 t827 carry3_1 t847 carry4_1 : BitVec 64}
    (hcarry4_1 : carry4_1 = t847.sshiftRight 21) (ht847 : t847 = t774 + t827 + carry3 + carry3_1)
    (ht827 : t827 = carry11_1 * 136657#64) (ht774 : t774 = t757 - carry4 <<< 21)
    (ht757 : t757 = t730 + t742 + t678 * 136657#64)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht742 : t742 = t685 * 18446744073708553811#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht730 : t730 = t703 + t690 * 470296#64 + t683 * 654183#64) (ht683 : t683 = carry13 + t664)
    (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht703 : t703 = t688 * 666643#64 + s4) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16) :
    carry4_1 =
      (((((((((s4 + ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 666643#64)) +
                          (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                              (carry15 <<< 21)) *
                            470296#64)) +
                        ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                              (carry14 <<< 21)) +
                            carry13) *
                          654183#64)) -
                      (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                              (s20 * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        997805#64)) +
                    ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                              (s20 * 136657#64)) -
                            (s19 * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      136657#64)) -
                  (carry4 <<< 21)) +
                carry3) +
              ((0#64 + carry11_1) * 136657#64)) +
            carry3_1).sshiftRight
        21 := by
  simp only [hcarry4_1, ht847, ht827, ht774, ht757, ht678, ht614, ht592, ht583, ht572, ht742, ht685,
    ht657, ht593, ht584, ht602, ht574, ht730, ht683, ht664, ht595, ht690, ht662, ht588, ht703,
    ht688, ht669, ht580]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry5_1_eq
    {s5 s12 s13 s14 s16 s17 s15 s19 s20 s21 s22 s23 t572 t574 t580 t583 t584 t588 t592 t593 t595
      t602 t614 carry12 t657 carry14 t662 t664 carry16 t667 t669 carry11 t678 carry13 t683 t685
      carry15 t688 t690 t705 t732 carry4 t772 carry5 carry11_1 t828 carry4_1 t852 carry5_1 :
      BitVec 64}
    (hcarry5_1 : carry5_1 = t852.sshiftRight 21)
    (ht852 : t852 = t772 + t828 - carry5 <<< 21 + carry4_1)
    (ht828 : t828 = carry11_1 * 18446744073708867715#64)
    (ht772 : t772 = t732 + t685 * 136657#64 + t678 * 18446744073708867715#64 + carry4)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht685 : t685 = t657 - carry13 <<< 21)
    (ht657 : t657 = t574 + t602 + t584 + t593 + carry12) (ht593 : t593 = s21 * 136657#64)
    (ht584 : t584 = s22 * 18446744073708553811#64) (ht602 : t602 = s20 * 18446744073708867715#64)
    (ht574 : t574 = s23 * 654183#64 + s13)
    (ht732 : t732 = t705 + t690 * 654183#64 + t683 * 18446744073708553811#64)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht705 : t705 = t667 * 666643#64 + s5 + t688 * 470296#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht667 : t667 = carry16 + s17) :
    carry5_1 =
      ((((((((((s5 + ((s17 + carry16) * 666643#64)) +
                            ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) *
                              470296#64)) +
                          (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                              (carry15 <<< 21)) *
                            654183#64)) -
                        ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                              (carry14 <<< 21)) +
                            carry13) *
                          997805#64)) +
                      (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                              (s20 * 683901#64)) +
                            carry12) -
                          (carry13 <<< 21)) *
                        136657#64)) -
                    ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                              (s20 * 136657#64)) -
                            (s19 * 683901#64)) -
                          (carry12 <<< 21)) +
                        carry11) *
                      683901#64)) +
                  carry4) -
                (carry5 <<< 21)) -
              ((0#64 + carry11_1) * 683901#64)) +
            carry4_1).sshiftRight
        21 := by
  simp only [hcarry5_1, ht852, ht828, ht772, ht678, ht614, ht592, ht583, ht572, ht685, ht657, ht593,
    ht584, ht602, ht574, ht732, ht683, ht664, ht595, ht690, ht662, ht588, ht705, ht688, ht669,
    ht580, ht667]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry6_2_eq
    {s6 s13 s14 s16 s17 s15 s18 s20 s21 s22 s23 t574 t580 t584 t588 t593 t595 t602 t616 carry6 t633
      carry12 t657 carry14 t662 t664 carry16 t667 t669 carry13 t683 t685 carry15 t688 t690 t707 t734
      t747 carry6_1 t784 carry5 t806 carry5_1 t855 carry6_2 : BitVec 64}
    (hcarry6_2 : carry6_2 = t855.sshiftRight 21) (ht855 : t855 = t806 + carry5_1)
    (ht806 : t806 = t784 + carry5) (ht784 : t784 = t747 - carry6_1 <<< 21)
    (ht747 : t747 = t734 + t685 * 18446744073708867715#64) (ht685 : t685 = t657 - carry13 <<< 21)
    (ht657 : t657 = t574 + t602 + t584 + t593 + carry12) (ht593 : t593 = s21 * 136657#64)
    (ht584 : t584 = s22 * 18446744073708553811#64) (ht602 : t602 = s20 * 18446744073708867715#64)
    (ht574 : t574 = s23 * 654183#64 + s13)
    (ht734 : t734 = t707 + t690 * 18446744073708553811#64 + t683 * 136657#64)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht707 : t707 = t633 + t667 * 470296#64 + t688 * 654183#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht667 : t667 = carry16 + s17) (ht633 : t633 = t616 - carry6 <<< 21)
    (ht616 : t616 = s18 * 666643#64 + s6) :
    carry6_2 =
      ((((((((((s6 + (s18 * 666643#64)) - (carry6 <<< 21)) + ((s17 + carry16) * 470296#64)) +
                        ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 654183#64)) -
                      (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                          (carry15 <<< 21)) *
                        997805#64)) +
                    ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                          (carry14 <<< 21)) +
                        carry13) *
                      136657#64)) -
                  (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                          (s20 * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    683901#64)) -
                (carry6_1 <<< 21)) +
              carry5) +
            carry5_1).sshiftRight
        21 := by
  simp only [hcarry6_2, ht855, ht806, ht784, ht747, ht685, ht657, ht593, ht584, ht602, ht574, ht734,
    ht683, ht664, ht595, ht690, ht662, ht588, ht707, ht688, ht669, ht580, ht667, ht633, ht616]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry7_2_eq
    {s7 s14 s16 s17 s15 s18 s19 s21 s22 s23 t580 t588 t595 t618 carry6 t631 carry14 t662 t664
      carry16 t667 t669 carry7 carry13 t683 carry15 t688 t690 t695 t708 t719 t735 carry6_1 t782
      carry7_1 t812 carry6_2 t858 carry7_2 : BitVec 64}
    (hcarry7_2 : carry7_2 = t858.sshiftRight 21) (ht858 : t858 = carry6_2 + t812)
    (ht812 : t812 = t782 - carry7_1 <<< 21)
    (ht782 : t782 = t695 + t631 - carry7 <<< 21 + t708 + t719 + t735 + carry6_1)
    (ht735 : t735 = t683 * 18446744073708867715#64) (ht683 : t683 = carry13 + t664)
    (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht719 : t719 = t690 * 136657#64) (ht690 : t690 = t662 - carry15 <<< 21)
    (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht708 : t708 = t688 * 18446744073708553811#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht631 : t631 = t618 + carry6) (ht618 : t618 = s19 * 666643#64 + s7 + s18 * 470296#64)
    (ht695 : t695 = t667 * 654183#64) (ht667 : t667 = carry16 + s17) :
    carry7_2 =
      (((((((((((s7 + (s19 * 666643#64)) + (s18 * 470296#64)) + carry6) - (carry7 <<< 21)) +
                        ((s17 + carry16) * 654183#64)) -
                      ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 997805#64)) +
                    (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                        (carry15 <<< 21)) *
                      136657#64)) -
                  ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                        (carry14 <<< 21)) +
                      carry13) *
                    683901#64)) +
                carry6_1) -
              (carry7_1 <<< 21)) +
            carry6_2).sshiftRight
        21 := by
  simp only [hcarry7_2, ht858, ht812, ht782, ht735, ht683, ht664, ht595, ht719, ht690, ht662, ht588,
    ht708, ht688, ht669, ht580, ht631, ht618, ht695, ht667]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry8_2_eq
    {s8 s16 s17 s15 s18 s19 s20 s22 s23 t580 t588 t597 t620 carry8 t642 carry14 t662 carry16 t667
      t669 carry7 carry15 t688 t690 t696 t709 t724 carry8_1 t792 carry7_1 t810 carry7_2 t861
      carry8_2 : BitVec 64}
    (hcarry8_2 : carry8_2 = t861.sshiftRight 21) (ht861 : t861 = t810 + carry7_2)
    (ht810 : t810 = t792 + carry7_1) (ht792 : t792 = t724 - carry8_1 <<< 21)
    (ht724 : t724 = t642 + t696 + carry7 + t709 + t690 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht709 : t709 = t688 * 136657#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht696 : t696 = t667 * 18446744073708553811#64) (ht667 : t667 = carry16 + s17)
    (ht642 : t642 = t620 - carry8 <<< 21) (ht620 : t620 = t597 + s19 * 470296#64 + s18 * 654183#64)
    (ht597 : t597 = s20 * 666643#64 + s8) :
    carry8_2 =
      (((((((((((s8 + (s20 * 666643#64)) + (s19 * 470296#64)) + (s18 * 654183#64)) -
                          (carry8 <<< 21)) +
                        carry7) -
                      ((s17 + carry16) * 997805#64)) +
                    ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 136657#64)) -
                  (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                      (carry15 <<< 21)) *
                    683901#64)) -
                (carry8_1 <<< 21)) +
              carry7_1) +
            carry7_2).sshiftRight
        21 := by
  simp only [hcarry8_2, ht861, ht810, ht792, ht724, ht690, ht662, ht588, ht709, ht688, ht669, ht580,
    ht696, ht667, ht642, ht620, ht597]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry9_2_eq
    {s9 s16 s17 s18 s19 s20 s21 s23 t580 t589 t598 t607 t621 carry8 t640 carry16 t667 t669 carry9
      carry15 t688 t697 t710 carry8_1 t790 carry9_1 t817 carry8_2 t864 carry9_2 : BitVec 64}
    (hcarry9_2 : carry9_2 = t864.sshiftRight 21) (ht864 : t864 = carry8_2 + t817)
    (ht817 : t817 = t790 - carry9_1 <<< 21)
    (ht790 : t790 = t640 + t697 - carry9 <<< 21 + t710 + carry8_1)
    (ht710 : t710 = t688 * 18446744073708867715#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht697 : t697 = t667 * 136657#64) (ht667 : t667 = carry16 + s17)
    (ht640 : t640 = t598 + s9 + t607 + t621 + t589 + carry8) (ht589 : t589 = s21 * 666643#64)
    (ht621 : t621 = s18 * 18446744073708553811#64) (ht607 : t607 = s19 * 654183#64)
    (ht598 : t598 = s20 * 470296#64) :
    carry9_2 =
      (((((((((((s9 + (s21 * 666643#64)) + (s20 * 470296#64)) + (s19 * 654183#64)) -
                          (s18 * 997805#64)) +
                        carry8) -
                      (carry9 <<< 21)) +
                    ((s17 + carry16) * 136657#64)) -
                  ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 683901#64)) +
                carry8_1) -
              (carry9_1 <<< 21)) +
            carry8_2).sshiftRight
        21 := by
  simp only [hcarry9_2, ht864, ht817, ht790, ht710, ht688, ht669, ht580, ht697, ht667, ht640, ht589,
    ht621, ht607, ht598]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry10_2_eq
    {s10 s17 s18 s19 s20 s21 s22 t581 t590 t627 carry10 carry16 t667 carry9 t701 carry10_1 t797
      carry9_1 t815 carry9_2 t867 carry10_2 : BitVec 64}
    (hcarry10_2 : carry10_2 = t867.sshiftRight 21) (ht867 : t867 = t815 + carry9_2)
    (ht815 : t815 = t797 + carry9_1) (ht797 : t797 = t701 - carry10_1 <<< 21)
    (ht701 : t701 = t627 + t667 * 18446744073708867715#64 - carry10 <<< 21 + carry9)
    (ht667 : t667 = carry16 + s17)
    (ht627 :
      t627 = s20 * 654183#64 + s10 + s19 * 18446744073708553811#64 + s18 * 136657#64 + t581 + t590)
    (ht590 : t590 = s21 * 470296#64) (ht581 : t581 = s22 * 666643#64) :
    carry10_2 =
      (((((((((((s10 + (s22 * 666643#64)) + (s21 * 470296#64)) + (s20 * 654183#64)) -
                          (s19 * 997805#64)) +
                        (s18 * 136657#64)) -
                      (carry10 <<< 21)) +
                    carry9) -
                  ((s17 + carry16) * 683901#64)) -
                (carry10_1 <<< 21)) +
              carry9_1) +
            carry9_2).sshiftRight
        21 := by
  simp only [hcarry10_2, ht867, ht815, ht797, ht701, ht667, ht627, ht590, ht581]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.carry11_2_eq
    {s11 s18 s19 s20 s21 s22 s23 t570 t582 t591 t600 t609 carry10 t650 carry11 t680 carry10_1 t795
      carry11_1 t821 carry10_2 t870 carry11_2 : BitVec 64}
    (hcarry11_2 : carry11_2 = t870.sshiftRight 21) (ht870 : t870 = carry10_2 + t821)
    (ht821 : t821 = t795 - carry11_1 <<< 21) (ht795 : t795 = carry10_1 + t680)
    (ht680 : t680 = t650 - carry11 <<< 21)
    (ht650 : t650 = t570 + t600 + t609 + s18 * 18446744073708867715#64 + t582 + t591 + carry10)
    (ht591 : t591 = s21 * 654183#64) (ht582 : t582 = s22 * 470296#64)
    (ht609 : t609 = s19 * 136657#64) (ht600 : t600 = s20 * 18446744073708553811#64)
    (ht570 : t570 = s23 * 666643#64 + s11) :
    carry11_2 =
      (((((((((((s11 + (s23 * 666643#64)) + (s22 * 470296#64)) + (s21 * 654183#64)) -
                          (s20 * 997805#64)) +
                        (s19 * 136657#64)) -
                      (s18 * 683901#64)) +
                    carry10) -
                  (carry11 <<< 21)) +
                carry10_1) -
              (carry11_1 <<< 21)) +
            carry10_2).sshiftRight
        21 := by
  simp only [hcarry11_2, ht870, ht821, ht795, ht680, ht650, ht591, ht582, ht609, ht600, ht570]
  exact congrArg (BitVec.sshiftRight · 21) (by grind)

theorem fd_curve25519_scalar_reduce.s11_12_eq
    {s11 s18 s19 s20 s21 s22 s23 t570 t582 t591 t600 t609 carry10 t650 carry11 t680 carry10_1 t795
      carry11_1 t821 carry10_2 t870 carry11_2 s11_12 : BitVec 64}
    (hs11_12 : s11_12 = t870 - carry11_2 <<< 21) (ht870 : t870 = carry10_2 + t821)
    (ht821 : t821 = t795 - carry11_1 <<< 21) (ht795 : t795 = carry10_1 + t680)
    (ht680 : t680 = t650 - carry11 <<< 21)
    (ht650 : t650 = t570 + t600 + t609 + s18 * 18446744073708867715#64 + t582 + t591 + carry10)
    (ht591 : t591 = s21 * 654183#64) (ht582 : t582 = s22 * 470296#64)
    (ht609 : t609 = s19 * 136657#64) (ht600 : t600 = s20 * 18446744073708553811#64)
    (ht570 : t570 = s23 * 666643#64 + s11) :
    s11_12 =
      (((((((((((s11 + (s23 * 666643#64)) + (s22 * 470296#64)) + (s21 * 654183#64)) -
                        (s20 * 997805#64)) +
                      (s19 * 136657#64)) -
                    (s18 * 683901#64)) +
                  carry10) -
                (carry11 <<< 21)) +
              carry10_1) -
            (carry11_1 <<< 21)) +
          carry10_2) -
        (carry11_2 <<< 21) := by
  simp only [hs11_12, ht870, ht821, ht795, ht680, ht650, ht591, ht582, ht609, ht600, ht570]
  grind

theorem fd_curve25519_scalar_reduce.s0_5_eq
    {s0 s12 s19 s20 s21 s22 s23 t572 t583 t592 t614 carry12 carry11 t678 t749 carry0 t764 carry11_1
      t823 carry0_1 t833 carry11_2 t874 s0_5 : BitVec 64}
    (hs0_5 : s0_5 = t874 + t833) (ht833 : t833 = t823 - carry0_1 <<< 21)
    (ht823 : t823 = t764 + carry11_1 * 666643#64) (ht764 : t764 = t749 - carry0 <<< 21)
    (ht749 : t749 = t678 * 666643#64 + s0) (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht874 : t874 = carry11_2 * 666643#64) :
    s0_5 =
      ((((s0 +
                ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                          (s20 * 136657#64)) -
                        (s19 * 683901#64)) -
                      (carry12 <<< 21)) +
                    carry11) *
                  666643#64)) -
              (carry0 <<< 21)) +
            ((0#64 + carry11_1) * 666643#64)) -
          (carry0_1 <<< 21)) +
        ((0#64 + carry11_2) * 666643#64) := by
  simp only [hs0_5, ht833, ht823, ht764, ht749, ht678, ht614, ht592, ht583, ht572, ht874]
  grind

theorem fd_curve25519_scalar_reduce.carry0_2_eq {s0_5 carry0_2 : BitVec 64}
    (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) : carry0_2 = s0_5.sshiftRight 21 := by
  exact hcarry0_2

theorem fd_curve25519_scalar_reduce.s1_9_eq
    {s1 s12 s13 s19 s20 s21 s22 s23 t572 t574 t583 t584 t592 t593 t602 t614 carry12 t657 carry11
      t678 carry13 t685 t737 carry0 t762 carry1 carry11_1 carry0_1 t832 carry1_1 t838 carry11_2 t876
      carry0_2 s1_9 : BitVec 64}
    (hs1_9 : s1_9 = t876 + carry0_2) (ht876 : t876 = carry11_2 * 470296#64 + t838)
    (ht838 : t838 = t832 - carry1_1 <<< 21)
    (ht832 : t832 = carry11_1 * 470296#64 + t762 - carry1 <<< 21 + carry0_1)
    (ht762 : t762 = t737 + t678 * 470296#64 + carry0)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht737 : t737 = t685 * 666643#64 + s1)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13) :
    s1_9 =
      ((((((((s1 +
                        (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                                (s20 * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          666643#64)) +
                      ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                                (s20 * 136657#64)) -
                              (s19 * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        470296#64)) +
                    carry0) -
                  (carry1 <<< 21)) +
                ((0#64 + carry11_1) * 470296#64)) +
              carry0_1) -
            (carry1_1 <<< 21)) +
          ((0#64 + carry11_2) * 470296#64)) +
        carry0_2 := by
  simp only [hs1_9, ht876, ht838, ht832, ht762, ht678, ht614, ht592, ht583, ht572, ht737, ht685,
    ht657, ht593, ht584, ht602, ht574]
  grind

theorem fd_curve25519_scalar_reduce.carry1_2_eq {s1_9 carry1_2 : BitVec 64}
    (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21) : carry1_2 = s1_9.sshiftRight 21 := by
  exact hcarry1_2

theorem fd_curve25519_scalar_reduce.s2_10_eq
    {s2 s12 s13 s14 s19 s20 s21 s22 s23 t572 t574 t583 t584 t592 t593 t595 t602 t614 carry12 t657
      carry14 t664 carry11 t678 carry13 t683 t685 t739 t753 carry2 t769 carry1 carry11_1 t825
      carry1_1 t837 carry2_1 t843 carry11_2 t878 carry1_2 s2_10 : BitVec 64}
    (hs2_10 : s2_10 = t878 + carry1_2) (ht878 : t878 = carry11_2 * 654183#64 + t843)
    (ht843 : t843 = t837 - carry2_1 <<< 21) (ht837 : t837 = t769 + t825 + carry1 + carry1_1)
    (ht825 : t825 = carry11_1 * 654183#64) (ht769 : t769 = t753 - carry2 <<< 21)
    (ht753 : t753 = t739 + t678 * 654183#64) (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht739 : t739 = t683 * 666643#64 + s2 + t685 * 470296#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 =
        s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64) :
    s2_10 =
      (((((((((s2 +
                          ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                                (carry14 <<< 21)) +
                              carry13) *
                            666643#64)) +
                        (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                                (s20 * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          470296#64)) +
                      ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                                (s20 * 136657#64)) -
                              (s19 * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        654183#64)) -
                    (carry2 <<< 21)) +
                  carry1) +
                ((0#64 + carry11_1) * 654183#64)) +
              carry1_1) -
            (carry2_1 <<< 21)) +
          ((0#64 + carry11_2) * 654183#64)) +
        carry1_2 := by
  simp only [hs2_10, ht878, ht843, ht837, ht825, ht769, ht753, ht678, ht614, ht592, ht583, ht572,
    ht739, ht685, ht657, ht593, ht584, ht602, ht574, ht683, ht664, ht595]
  grind

theorem fd_curve25519_scalar_reduce.carry2_2_eq {s2_10 carry2_2 : BitVec 64}
    (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) : carry2_2 = s2_10.sshiftRight 21 := by
  exact hcarry2_2

theorem fd_curve25519_scalar_reduce.s3_11_eq
    {s3 s12 s13 s14 s15 s19 s20 s21 s22 s23 t572 t574 t583 t584 t588 t592 t593 t595 t602 t614
      carry12 t657 carry14 t662 t664 carry11 t678 carry13 t683 t685 carry15 t690 t712 t741 carry2
      t767 carry3 carry11_1 t826 carry2_1 t842 carry3_1 t848 carry11_2 t880 carry2_2 s3_11 :
      BitVec 64}
    (hs3_11 : s3_11 = t880 + carry2_2) (ht880 : t880 = carry11_2 * 18446744073708553811#64 + t848)
    (ht848 : t848 = t842 - carry3_1 <<< 21) (ht842 : t842 = t767 + t826 - carry3 <<< 21 + carry2_1)
    (ht826 : t826 = carry11_1 * 18446744073708553811#64)
    (ht767 : t767 = t741 + t678 * 18446744073708553811#64 + carry2)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12)
    (ht741 : t741 = t712 + t683 * 470296#64 + t685 * 654183#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht712 : t712 = t690 * 666643#64 + s3) (ht690 : t690 = t662 - carry15 <<< 21)
    (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64) :
    s3_11 =
      ((((((((((s3 +
                            (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                                (carry15 <<< 21)) *
                              666643#64)) +
                          ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                                (carry14 <<< 21)) +
                              carry13) *
                            470296#64)) +
                        (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                                (s20 * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          654183#64)) -
                      ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                                (s20 * 136657#64)) -
                              (s19 * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        997805#64)) +
                    carry2) -
                  (carry3 <<< 21)) -
                ((0#64 + carry11_1) * 997805#64)) +
              carry2_1) -
            (carry3_1 <<< 21)) -
          ((0#64 + carry11_2) * 997805#64)) +
        carry2_2 := by
  simp only [hs3_11, ht880, ht848, ht842, ht826, ht767, ht678, ht614, ht592, ht583, ht572, ht741,
    ht685, ht657, ht593, ht584, ht602, ht574, ht683, ht664, ht595, ht712, ht690, ht662, ht588]
  grind

theorem fd_curve25519_scalar_reduce.carry3_2_eq {s3_11 carry3_2 : BitVec 64}
    (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21) : carry3_2 = s3_11.sshiftRight 21 := by
  exact hcarry3_2

theorem fd_curve25519_scalar_reduce.s4_12_eq
    {s4 s12 s13 s14 s16 s15 s19 s20 s21 s22 s23 t572 t574 t580 t583 t584 t588 t592 t593 t595 t602
      t614 carry12 t657 carry14 t662 t664 carry16 t669 carry11 t678 carry13 t683 t685 carry15 t688
      t690 t703 t730 t742 t757 carry4 t774 carry3 carry11_1 t827 carry3_1 t847 carry4_1 t853
      carry11_2 t882 carry3_2 s4_12 : BitVec 64}
    (hs4_12 : s4_12 = t882 + carry3_2) (ht882 : t882 = carry11_2 * 136657#64 + t853)
    (ht853 : t853 = t847 - carry4_1 <<< 21) (ht847 : t847 = t774 + t827 + carry3 + carry3_1)
    (ht827 : t827 = carry11_1 * 136657#64) (ht774 : t774 = t757 - carry4 <<< 21)
    (ht757 : t757 = t730 + t742 + t678 * 136657#64)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht742 : t742 = t685 * 18446744073708553811#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht730 : t730 = t703 + t690 * 470296#64 + t683 * 654183#64) (ht683 : t683 = carry13 + t664)
    (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht703 : t703 = t688 * 666643#64 + s4) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16) :
    s4_12 =
      (((((((((((s4 + ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 666643#64)) +
                            (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                                (carry15 <<< 21)) *
                              470296#64)) +
                          ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                                (carry14 <<< 21)) +
                              carry13) *
                            654183#64)) -
                        (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                                (s20 * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          997805#64)) +
                      ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                                (s20 * 136657#64)) -
                              (s19 * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        136657#64)) -
                    (carry4 <<< 21)) +
                  carry3) +
                ((0#64 + carry11_1) * 136657#64)) +
              carry3_1) -
            (carry4_1 <<< 21)) +
          ((0#64 + carry11_2) * 136657#64)) +
        carry3_2 := by
  simp only [hs4_12, ht882, ht853, ht847, ht827, ht774, ht757, ht678, ht614, ht592, ht583, ht572,
    ht742, ht685, ht657, ht593, ht584, ht602, ht574, ht730, ht683, ht664, ht595, ht690, ht662,
    ht588, ht703, ht688, ht669, ht580]
  grind

theorem fd_curve25519_scalar_reduce.carry4_2_eq {s4_12 carry4_2 : BitVec 64}
    (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) : carry4_2 = s4_12.sshiftRight 21 := by
  exact hcarry4_2

theorem fd_curve25519_scalar_reduce.s5_13_eq
    {s5 s12 s13 s14 s16 s17 s15 s19 s20 s21 s22 s23 t572 t574 t580 t583 t584 t588 t592 t593 t595
      t602 t614 carry12 t657 carry14 t662 t664 carry16 t667 t669 carry11 t678 carry13 t683 t685
      carry15 t688 t690 t705 t732 carry4 t772 carry5 carry11_1 t828 carry4_1 t852 carry5_1 t856
      carry11_2 carry4_2 s5_13 : BitVec 64}
    (hs5_13 : s5_13 = carry11_2 * 18446744073708867715#64 + t856 + carry4_2)
    (ht856 : t856 = t852 - carry5_1 <<< 21) (ht852 : t852 = t772 + t828 - carry5 <<< 21 + carry4_1)
    (ht828 : t828 = carry11_1 * 18446744073708867715#64)
    (ht772 : t772 = t732 + t685 * 136657#64 + t678 * 18446744073708867715#64 + carry4)
    (ht678 : t678 = carry11 + (t614 - carry12 <<< 21))
    (ht614 : t614 = t572 + s20 * 136657#64 + s19 * 18446744073708867715#64 + t583 + t592)
    (ht592 : t592 = s21 * 18446744073708553811#64) (ht583 : t583 = s22 * 654183#64)
    (ht572 : t572 = s23 * 470296#64 + s12) (ht685 : t685 = t657 - carry13 <<< 21)
    (ht657 : t657 = t574 + t602 + t584 + t593 + carry12) (ht593 : t593 = s21 * 136657#64)
    (ht584 : t584 = s22 * 18446744073708553811#64) (ht602 : t602 = s20 * 18446744073708867715#64)
    (ht574 : t574 = s23 * 654183#64 + s13)
    (ht732 : t732 = t705 + t690 * 654183#64 + t683 * 18446744073708553811#64)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht705 : t705 = t667 * 666643#64 + s5 + t688 * 470296#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht667 : t667 = carry16 + s17) :
    s5_13 =
      ((((((((((((s5 + ((s17 + carry16) * 666643#64)) +
                              ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) *
                                470296#64)) +
                            (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                                (carry15 <<< 21)) *
                              654183#64)) -
                          ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                                (carry14 <<< 21)) +
                              carry13) *
                            997805#64)) +
                        (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                                (s20 * 683901#64)) +
                              carry12) -
                            (carry13 <<< 21)) *
                          136657#64)) -
                      ((((((((s12 + (s23 * 470296#64)) + (s22 * 654183#64)) - (s21 * 997805#64)) +
                                (s20 * 136657#64)) -
                              (s19 * 683901#64)) -
                            (carry12 <<< 21)) +
                          carry11) *
                        683901#64)) +
                    carry4) -
                  (carry5 <<< 21)) -
                ((0#64 + carry11_1) * 683901#64)) +
              carry4_1) -
            (carry5_1 <<< 21)) -
          ((0#64 + carry11_2) * 683901#64)) +
        carry4_2 := by
  simp only [hs5_13, ht856, ht852, ht828, ht772, ht678, ht614, ht592, ht583, ht572, ht685, ht657,
    ht593, ht584, ht602, ht574, ht732, ht683, ht664, ht595, ht690, ht662, ht588, ht705, ht688,
    ht669, ht580, ht667]
  grind

theorem fd_curve25519_scalar_reduce.carry5_2_eq {s5_13 carry5_2 : BitVec 64}
    (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21) : carry5_2 = s5_13.sshiftRight 21 := by
  exact hcarry5_2

theorem fd_curve25519_scalar_reduce.s6_12_eq
    {s6 s13 s14 s16 s17 s15 s18 s20 s21 s22 s23 t574 t580 t584 t588 t593 t595 t602 t616 carry6 t633
      carry12 t657 carry14 t662 t664 carry16 t667 t669 carry13 t683 t685 carry15 t688 t690 t707 t734
      t747 carry6_1 t784 carry5 t806 carry5_1 t855 carry6_2 t859 carry5_2 s6_12 : BitVec 64}
    (hs6_12 : s6_12 = carry5_2 + t859) (ht859 : t859 = t855 - carry6_2 <<< 21)
    (ht855 : t855 = t806 + carry5_1) (ht806 : t806 = t784 + carry5)
    (ht784 : t784 = t747 - carry6_1 <<< 21) (ht747 : t747 = t734 + t685 * 18446744073708867715#64)
    (ht685 : t685 = t657 - carry13 <<< 21) (ht657 : t657 = t574 + t602 + t584 + t593 + carry12)
    (ht593 : t593 = s21 * 136657#64) (ht584 : t584 = s22 * 18446744073708553811#64)
    (ht602 : t602 = s20 * 18446744073708867715#64) (ht574 : t574 = s23 * 654183#64 + s13)
    (ht734 : t734 = t707 + t690 * 18446744073708553811#64 + t683 * 136657#64)
    (ht683 : t683 = carry13 + t664) (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht707 : t707 = t633 + t667 * 470296#64 + t688 * 654183#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht667 : t667 = carry16 + s17) (ht633 : t633 = t616 - carry6 <<< 21)
    (ht616 : t616 = s18 * 666643#64 + s6) :
    s6_12 =
      (((((((((((s6 + (s18 * 666643#64)) - (carry6 <<< 21)) + ((s17 + carry16) * 470296#64)) +
                        ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 654183#64)) -
                      (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                          (carry15 <<< 21)) *
                        997805#64)) +
                    ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                          (carry14 <<< 21)) +
                        carry13) *
                      136657#64)) -
                  (((((((s13 + (s23 * 654183#64)) - (s22 * 997805#64)) + (s21 * 136657#64)) -
                          (s20 * 683901#64)) +
                        carry12) -
                      (carry13 <<< 21)) *
                    683901#64)) -
                (carry6_1 <<< 21)) +
              carry5) +
            carry5_1) -
          (carry6_2 <<< 21)) +
        carry5_2 := by
  simp only [hs6_12, ht859, ht855, ht806, ht784, ht747, ht685, ht657, ht593, ht584, ht602, ht574,
    ht734, ht683, ht664, ht595, ht690, ht662, ht588, ht707, ht688, ht669, ht580, ht667, ht633,
    ht616]
  grind

theorem fd_curve25519_scalar_reduce.carry6_3_eq {s6_12 carry6_3 : BitVec 64}
    (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) : carry6_3 = s6_12.sshiftRight 21 := by
  exact hcarry6_3

theorem fd_curve25519_scalar_reduce.s7_13_eq
    {s7 s14 s16 s17 s15 s18 s19 s21 s22 s23 t580 t588 t595 t618 carry6 t631 carry14 t662 t664
      carry16 t667 t669 carry7 carry13 t683 carry15 t688 t690 t695 t708 t719 t735 carry6_1 t782
      carry7_1 t812 carry6_2 t858 carry7_2 t862 carry6_3 s7_13 : BitVec 64}
    (hs7_13 : s7_13 = carry6_3 + t862) (ht862 : t862 = t858 - carry7_2 <<< 21)
    (ht858 : t858 = carry6_2 + t812) (ht812 : t812 = t782 - carry7_1 <<< 21)
    (ht782 : t782 = t695 + t631 - carry7 <<< 21 + t708 + t719 + t735 + carry6_1)
    (ht735 : t735 = t683 * 18446744073708867715#64) (ht683 : t683 = carry13 + t664)
    (ht664 : t664 = t595 - carry14 <<< 21)
    (ht595 :
      t595 = s23 * 18446744073708553811#64 + s14 + s22 * 136657#64 + s21 * 18446744073708867715#64)
    (ht719 : t719 = t690 * 136657#64) (ht690 : t690 = t662 - carry15 <<< 21)
    (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht708 : t708 = t688 * 18446744073708553811#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht631 : t631 = t618 + carry6) (ht618 : t618 = s19 * 666643#64 + s7 + s18 * 470296#64)
    (ht695 : t695 = t667 * 654183#64) (ht667 : t667 = carry16 + s17) :
    s7_13 =
      ((((((((((((s7 + (s19 * 666643#64)) + (s18 * 470296#64)) + carry6) - (carry7 <<< 21)) +
                        ((s17 + carry16) * 654183#64)) -
                      ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 997805#64)) +
                    (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                        (carry15 <<< 21)) *
                      136657#64)) -
                  ((((((s14 - (s23 * 997805#64)) + (s22 * 136657#64)) - (s21 * 683901#64)) -
                        (carry14 <<< 21)) +
                      carry13) *
                    683901#64)) +
                carry6_1) -
              (carry7_1 <<< 21)) +
            carry6_2) -
          (carry7_2 <<< 21)) +
        carry6_3 := by
  simp only [hs7_13, ht862, ht858, ht812, ht782, ht735, ht683, ht664, ht595, ht719, ht690, ht662,
    ht588, ht708, ht688, ht669, ht580, ht631, ht618, ht695, ht667]
  grind

theorem fd_curve25519_scalar_reduce.carry7_3_eq {s7_13 carry7_3 : BitVec 64}
    (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21) : carry7_3 = s7_13.sshiftRight 21 := by
  exact hcarry7_3

theorem fd_curve25519_scalar_reduce.s8_13_eq
    {s8 s16 s17 s15 s18 s19 s20 s22 s23 t580 t588 t597 t620 carry8 t642 carry14 t662 carry16 t667
      t669 carry7 carry15 t688 t690 t696 t709 t724 carry8_1 t792 carry7_1 t810 carry7_2 t861
      carry8_2 t865 carry7_3 s8_13 : BitVec 64}
    (hs8_13 : s8_13 = carry7_3 + t865) (ht865 : t865 = t861 - carry8_2 <<< 21)
    (ht861 : t861 = t810 + carry7_2) (ht810 : t810 = t792 + carry7_1)
    (ht792 : t792 = t724 - carry8_1 <<< 21)
    (ht724 : t724 = t642 + t696 + carry7 + t709 + t690 * 18446744073708867715#64)
    (ht690 : t690 = t662 - carry15 <<< 21) (ht662 : t662 = t588 + carry14)
    (ht588 : t588 = s23 * 136657#64 + s15 + s22 * 18446744073708867715#64)
    (ht709 : t709 = t688 * 136657#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht696 : t696 = t667 * 18446744073708553811#64) (ht667 : t667 = carry16 + s17)
    (ht642 : t642 = t620 - carry8 <<< 21) (ht620 : t620 = t597 + s19 * 470296#64 + s18 * 654183#64)
    (ht597 : t597 = s20 * 666643#64 + s8) :
    s8_13 =
      ((((((((((((s8 + (s20 * 666643#64)) + (s19 * 470296#64)) + (s18 * 654183#64)) -
                          (carry8 <<< 21)) +
                        carry7) -
                      ((s17 + carry16) * 997805#64)) +
                    ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 136657#64)) -
                  (((((s15 + (s23 * 136657#64)) - (s22 * 683901#64)) + carry14) -
                      (carry15 <<< 21)) *
                    683901#64)) -
                (carry8_1 <<< 21)) +
              carry7_1) +
            carry7_2) -
          (carry8_2 <<< 21)) +
        carry7_3 := by
  simp only [hs8_13, ht865, ht861, ht810, ht792, ht724, ht690, ht662, ht588, ht709, ht688, ht669,
    ht580, ht696, ht667, ht642, ht620, ht597]
  grind

theorem fd_curve25519_scalar_reduce.carry8_3_eq {s8_13 carry8_3 : BitVec 64}
    (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) : carry8_3 = s8_13.sshiftRight 21 := by
  exact hcarry8_3

theorem fd_curve25519_scalar_reduce.s9_13_eq
    {s9 s16 s17 s18 s19 s20 s21 s23 t580 t589 t598 t607 t621 carry8 t640 carry16 t667 t669 carry9
      carry15 t688 t697 t710 carry8_1 t790 carry9_1 t817 carry8_2 t864 carry9_2 t868 carry8_3
      s9_13 : BitVec 64}
    (hs9_13 : s9_13 = carry8_3 + t868) (ht868 : t868 = t864 - carry9_2 <<< 21)
    (ht864 : t864 = carry8_2 + t817) (ht817 : t817 = t790 - carry9_1 <<< 21)
    (ht790 : t790 = t640 + t697 - carry9 <<< 21 + t710 + carry8_1)
    (ht710 : t710 = t688 * 18446744073708867715#64) (ht688 : t688 = carry15 + t669)
    (ht669 : t669 = t580 - carry16 <<< 21) (ht580 : t580 = s23 * 18446744073708867715#64 + s16)
    (ht697 : t697 = t667 * 136657#64) (ht667 : t667 = carry16 + s17)
    (ht640 : t640 = t598 + s9 + t607 + t621 + t589 + carry8) (ht589 : t589 = s21 * 666643#64)
    (ht621 : t621 = s18 * 18446744073708553811#64) (ht607 : t607 = s19 * 654183#64)
    (ht598 : t598 = s20 * 470296#64) :
    s9_13 =
      ((((((((((((s9 + (s21 * 666643#64)) + (s20 * 470296#64)) + (s19 * 654183#64)) -
                          (s18 * 997805#64)) +
                        carry8) -
                      (carry9 <<< 21)) +
                    ((s17 + carry16) * 136657#64)) -
                  ((((s16 - (s23 * 683901#64)) - (carry16 <<< 21)) + carry15) * 683901#64)) +
                carry8_1) -
              (carry9_1 <<< 21)) +
            carry8_2) -
          (carry9_2 <<< 21)) +
        carry8_3 := by
  simp only [hs9_13, ht868, ht864, ht817, ht790, ht710, ht688, ht669, ht580, ht697, ht667, ht640,
    ht589, ht621, ht607, ht598]
  grind

theorem fd_curve25519_scalar_reduce.carry9_3_eq {s9_13 carry9_3 : BitVec 64}
    (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21) : carry9_3 = s9_13.sshiftRight 21 := by
  exact hcarry9_3

theorem fd_curve25519_scalar_reduce.s10_13_eq
    {s10 s17 s18 s19 s20 s21 s22 t581 t590 t627 carry10 carry16 t667 carry9 t701 carry10_1 t797
      carry9_1 t815 carry9_2 t867 carry10_2 t871 carry9_3 s10_13 : BitVec 64}
    (hs10_13 : s10_13 = carry9_3 + t871) (ht871 : t871 = t867 - carry10_2 <<< 21)
    (ht867 : t867 = t815 + carry9_2) (ht815 : t815 = t797 + carry9_1)
    (ht797 : t797 = t701 - carry10_1 <<< 21)
    (ht701 : t701 = t627 + t667 * 18446744073708867715#64 - carry10 <<< 21 + carry9)
    (ht667 : t667 = carry16 + s17)
    (ht627 :
      t627 = s20 * 654183#64 + s10 + s19 * 18446744073708553811#64 + s18 * 136657#64 + t581 + t590)
    (ht590 : t590 = s21 * 470296#64) (ht581 : t581 = s22 * 666643#64) :
    s10_13 =
      ((((((((((((s10 + (s22 * 666643#64)) + (s21 * 470296#64)) + (s20 * 654183#64)) -
                          (s19 * 997805#64)) +
                        (s18 * 136657#64)) -
                      (carry10 <<< 21)) +
                    carry9) -
                  ((s17 + carry16) * 683901#64)) -
                (carry10_1 <<< 21)) +
              carry9_1) +
            carry9_2) -
          (carry10_2 <<< 21)) +
        carry9_3 := by
  simp only [hs10_13, ht871, ht867, ht815, ht797, ht701, ht667, ht627, ht590, ht581]
  grind

/-- The stored lanes are the spec's `out3 ++ (out2 ++ (out1 ++ out0))`. -/
theorem fd_curve25519_scalar_reduce.pack_eq
    {s11_12 s0_5 carry0_2 s1_9 carry1_2 s2_10 carry2_2 s3_11 carry3_2 s4_12 carry4_2 s5_13 carry5_2
      s6_12 carry6_3 s7_13 carry7_3 s8_13 carry8_3 s9_13 carry9_3 s10_13 carry10_3 t907 : BitVec 64}
    (hcarry0_2 : carry0_2 = s0_5.sshiftRight 21) (hcarry1_2 : carry1_2 = s1_9.sshiftRight 21)
    (hcarry2_2 : carry2_2 = s2_10.sshiftRight 21) (hcarry3_2 : carry3_2 = s3_11.sshiftRight 21)
    (hcarry4_2 : carry4_2 = s4_12.sshiftRight 21) (hcarry5_2 : carry5_2 = s5_13.sshiftRight 21)
    (hcarry6_3 : carry6_3 = s6_12.sshiftRight 21) (hcarry7_3 : carry7_3 = s7_13.sshiftRight 21)
    (hcarry8_3 : carry8_3 = s8_13.sshiftRight 21) (hcarry9_3 : carry9_3 = s9_13.sshiftRight 21)
    (hcarry10_3 : carry10_3 = s10_13 >>> 21) (ht907 : t907 = carry10_3 + s11_12) :
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
          s9_13 >>> 3 &&& 262143#64 ||| s10_13 <<< 18 &&& 549755551744#64 ||| t907 <<< 39] =
      ((((s9_13 - (carry9_3 <<< 21)) >>> 3) |||
            ((s10_13 - ((s10_13.sshiftRight 21) <<< 21)) <<< 18)) |||
          ((s11_12 + (s10_13.sshiftRight 21)) <<< 39)) ++
        ((((((s6_12 - (carry6_3 <<< 21)) >>> 2) ||| ((s7_13 - (carry7_3 <<< 21)) <<< 19)) |||
              ((s8_13 - (carry8_3 <<< 21)) <<< 40)) |||
            ((s9_13 - (carry9_3 <<< 21)) <<< 61)) ++
          ((((((s3_11 - (carry3_2 <<< 21)) >>> 1) ||| ((s4_12 - (carry4_2 <<< 21)) <<< 20)) |||
                ((s5_13 - (carry5_2 <<< 21)) <<< 41)) |||
              ((s6_12 - (carry6_3 <<< 21)) <<< 62)) ++
            ((((s0_5 - (carry0_2 <<< 21)) ||| ((s1_9 - (carry1_2 <<< 21)) <<< 21)) |||
                ((s2_10 - (carry2_2 <<< 21)) <<< 42)) |||
              ((s3_11 - (carry3_2 <<< 21)) <<< 63)))) := by
  rw [BitVec.packLanes_four]
  subst ht907 hcarry10_3 hcarry9_3 hcarry8_3 hcarry7_3 hcarry6_3 hcarry5_2 hcarry4_2 hcarry3_2
    hcarry2_2 hcarry1_2 hcarry0_2
  bv_decide

/-- `reduce` stores `spec` of the 64 bytes at `inp` as the 32 bytes at `out`, and returns `out`. The
loads all come before the store, so `out` may alias `inp`. -/
public theorem fd_curve25519_scalar_reduce.call_eq (out inp : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : Fits s.mem out (8 * 32)) (hin : Fits s.mem inp (8 * 64))
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
  step_pattern using fd_curve25519_scalar_reduce.run70
  step_pattern using fd_curve25519_scalar_reduce.run104
  step_pattern using fd_curve25519_scalar_reduce.run130
  step_pattern using fd_curve25519_scalar_reduce.run160
  step_pattern using fd_curve25519_scalar_reduce.run190
  step_pattern using fd_curve25519_scalar_reduce.run215
  step_pattern using fd_curve25519_scalar_reduce.run245 (ht681 := ht681.symm) (ht651 := ht651.symm)
    (hcarry13 := hcarry13.symm) (hcarry10 := hcarry10.symm)
  step_pattern using fd_curve25519_scalar_reduce.run275
  step_pattern using fd_curve25519_scalar_reduce.run305
  step_pattern using fd_curve25519_scalar_reduce.run335 (ht770 := ht770.symm) (ht672 := ht672.symm)
    (ht675 := ht675.symm) (hcarry4 := hcarry4.symm) (hcarry7 := hcarry7.symm) (hcarry9 :=
    hcarry9.symm)
  step_pattern using fd_curve25519_scalar_reduce.run365 (ht800 := ht800.symm) (hcarry1 :=
    hcarry1.symm)
  step_pattern using fd_curve25519_scalar_reduce.run395 (ht803 := ht803.symm) (ht801 := ht801.symm)
    (ht807 := ht807.symm) (hcarry0_1 := hcarry0_1.symm) (hcarry3 := hcarry3.symm) (hcarry5 :=
    hcarry5.symm)
  step_pattern using fd_curve25519_scalar_reduce.run420 (hcarry6_2 := hcarry6_2.symm)
  step_pattern using fd_curve25519_scalar_reduce.run445
  step_pattern using fd_curve25519_scalar_reduce.run470
  step_pattern using fd_curve25519_scalar_reduce.run471
  step_pattern using fd_curve25519_scalar_reduce.run472
  step_pattern using fd_curve25519_scalar_reduce.run473
  step_pattern using fd_curve25519_scalar_reduce.run474
  step_pattern using fd_curve25519_scalar_reduce.run475
  step_pattern using fd_curve25519_scalar_reduce.run476
  step_pattern using fd_curve25519_scalar_reduce.run477
  step_pattern using fd_curve25519_scalar_reduce.run478
  step_pattern using fd_curve25519_scalar_reduce.run479
  step_pattern using fd_curve25519_scalar_reduce.run480
  step_pattern using fd_curve25519_scalar_reduce.run481
  step_pattern using fd_curve25519_scalar_reduce.run482
  step_pattern using fd_curve25519_scalar_reduce.run483
  step_pattern using fd_curve25519_scalar_reduce.run484
  step_pattern using fd_curve25519_scalar_reduce.run485
  step_pattern using fd_curve25519_scalar_reduce.run486
  step_pattern using fd_curve25519_scalar_reduce.run487
  step_pattern using fd_curve25519_scalar_reduce.run488
  step_pattern using fd_curve25519_scalar_reduce.run489
  step_pattern using fd_curve25519_scalar_reduce.run490
  step_pattern using fd_curve25519_scalar_reduce.run491
  step_pattern using fd_curve25519_scalar_reduce.run492
  step_pattern using fd_curve25519_scalar_reduce.run493
  step_pattern using fd_curve25519_scalar_reduce.run494
  step_pattern using fd_curve25519_scalar_reduce.run495
  step_pattern using fd_curve25519_scalar_reduce.run496
  step_pattern using fd_curve25519_scalar_reduce.run497
  finish_block
  subst hS
  rw [fd_curve25519_scalar_reduce.pack_eq hcarry0_2 hcarry1_2 hcarry2_2 hcarry3_2 hcarry4_2
      hcarry5_2 hcarry6_3 hcarry7_3 hcarry8_3 hcarry9_3 hcarry10_3 ht907]
  have hcs0 := fd_curve25519_scalar_reduce.s0_eq hs0
  have hcs1 := fd_curve25519_scalar_reduce.s1_eq hs1
  have hcs2 := fd_curve25519_scalar_reduce.s2_eq hs2
  have hcs3 := fd_curve25519_scalar_reduce.s3_eq hs3
  have hcs4 := fd_curve25519_scalar_reduce.s4_eq hs4
  have hcs5 := fd_curve25519_scalar_reduce.s5_eq hs5
  have hcs6 := fd_curve25519_scalar_reduce.s6_eq hs6
  have hcs7 := fd_curve25519_scalar_reduce.s7_eq hs7
  have hcs8 := fd_curve25519_scalar_reduce.s8_eq hs8
  have hcs9 := fd_curve25519_scalar_reduce.s9_eq hs9
  have hcs10 := fd_curve25519_scalar_reduce.s10_eq hs10
  have hcs11 := fd_curve25519_scalar_reduce.s11_eq hs11
  have hcs12 := fd_curve25519_scalar_reduce.s12_eq hs12 ht541
  have hcs13 := fd_curve25519_scalar_reduce.s13_eq hs13
  have hcs14 := fd_curve25519_scalar_reduce.s14_eq hs14
  have hcs15 := fd_curve25519_scalar_reduce.s15_eq hs15
  have hcs16 := fd_curve25519_scalar_reduce.s16_eq hs16
  have hcs17 := fd_curve25519_scalar_reduce.s17_eq hs17
  have hcs18 := fd_curve25519_scalar_reduce.s18_eq hs18
  have hcs19 := fd_curve25519_scalar_reduce.s19_eq hs19
  have hcs20 := fd_curve25519_scalar_reduce.s20_eq hs20
  have hcs21 := fd_curve25519_scalar_reduce.s21_eq hs21
  have hcs22 := fd_curve25519_scalar_reduce.s22_eq hs22
  have hcs23 := fd_curve25519_scalar_reduce.s23_eq hs23
  have hccarry6 := fd_curve25519_scalar_reduce.carry6_eq hcarry6 ht616
  have hccarry8 := fd_curve25519_scalar_reduce.carry8_eq hcarry8 ht620 ht597
  have hccarry10 := fd_curve25519_scalar_reduce.carry10_eq hcarry10 ht627 ht590 ht581
  have hccarry12 := fd_curve25519_scalar_reduce.carry12_eq hcarry12 ht652 ht614 ht592 ht583 ht572
  have hccarry14 := fd_curve25519_scalar_reduce.carry14_eq hcarry14 ht595
  have hccarry16 := fd_curve25519_scalar_reduce.carry16_eq hcarry16 ht580
  have hccarry7 := fd_curve25519_scalar_reduce.carry7_eq hcarry7 ht631 ht618
  have hccarry9 := fd_curve25519_scalar_reduce.carry9_eq hcarry9 ht640 ht589 ht621 ht607 ht598
  have hccarry11 :=
    fd_curve25519_scalar_reduce.carry11_eq hcarry11 ht650 ht591 ht582 ht609 ht600 ht570
  have hccarry13 :=
    fd_curve25519_scalar_reduce.carry13_eq hcarry13 ht681 ht657 ht593 ht584 ht602 ht574
  have hccarry15 := fd_curve25519_scalar_reduce.carry15_eq hcarry15 ht662 ht588
  have hccarry0 := fd_curve25519_scalar_reduce.carry0_eq hcarry0 ht749 ht678 ht614 ht592 ht583 ht572
  have hccarry2 :=
    fd_curve25519_scalar_reduce.carry2_eq hcarry2 ht753 ht678 ht614 ht592 ht583 ht572 ht739 ht685
      ht657 ht593 ht584 ht602 ht574 ht683 ht664 ht595
  have hccarry4 :=
    fd_curve25519_scalar_reduce.carry4_eq hcarry4 ht770 ht757 ht678 ht614 ht592 ht583 ht572 ht742
      ht685 ht657 ht593 ht584 ht602 ht574 ht730 ht683 ht664 ht595 ht690 ht662 ht588 ht703 ht688
      ht669 ht580
  have hccarry6_1 :=
    fd_curve25519_scalar_reduce.carry6_1_eq hcarry6_1 ht747 ht685 ht657 ht593 ht584 ht602 ht574
      ht734 ht683 ht664 ht595 ht690 ht662 ht588 ht707 ht688 ht669 ht580 ht667 ht633 ht616
  have hccarry8_1 :=
    fd_curve25519_scalar_reduce.carry8_1_eq hcarry8_1 ht724 ht690 ht662 ht588 ht709 ht688 ht669
      ht580 ht696 ht667 ht642 ht620 ht597
  have hccarry10_1 :=
    fd_curve25519_scalar_reduce.carry10_1_eq hcarry10_1 ht701 ht667 ht627 ht590 ht581
  have hccarry1 :=
    fd_curve25519_scalar_reduce.carry1_eq hcarry1 ht762 ht678 ht614 ht592 ht583 ht572 ht737 ht685
      ht657 ht593 ht584 ht602 ht574
  have hccarry3 :=
    fd_curve25519_scalar_reduce.carry3_eq hcarry3 ht801 ht767 ht678 ht614 ht592 ht583 ht572 ht741
      ht685 ht657 ht593 ht584 ht602 ht574 ht683 ht664 ht595 ht712 ht690 ht662 ht588
  have hccarry5 :=
    fd_curve25519_scalar_reduce.carry5_eq hcarry5 ht772 ht678 ht614 ht592 ht583 ht572 ht685 ht657
      ht593 ht584 ht602 ht574 ht732 ht683 ht664 ht595 ht690 ht662 ht588 ht705 ht688 ht669 ht580
      ht667
  have hccarry7_1 :=
    fd_curve25519_scalar_reduce.carry7_1_eq hcarry7_1 ht782 ht735 ht683 ht664 ht595 ht719 ht690
      ht662 ht588 ht708 ht688 ht669 ht580 ht631 ht618 ht695 ht667
  have hccarry9_1 :=
    fd_curve25519_scalar_reduce.carry9_1_eq hcarry9_1 ht790 ht710 ht688 ht669 ht580 ht697 ht667
      ht640 ht589 ht621 ht607 ht598
  have hccarry11_1 :=
    fd_curve25519_scalar_reduce.carry11_1_eq hcarry11_1 ht795 ht680 ht650 ht591 ht582 ht609 ht600
      ht570
  have hccarry0_1 :=
    fd_curve25519_scalar_reduce.carry0_1_eq hcarry0_1 ht823 ht764 ht749 ht678 ht614 ht592 ht583
      ht572
  have hccarry1_1 :=
    fd_curve25519_scalar_reduce.carry1_1_eq hcarry1_1 ht832 ht762 ht678 ht614 ht592 ht583 ht572
      ht737 ht685 ht657 ht593 ht584 ht602 ht574
  have hccarry2_1 :=
    fd_curve25519_scalar_reduce.carry2_1_eq hcarry2_1 ht837 ht825 ht769 ht753 ht678 ht614 ht592
      ht583 ht572 ht739 ht685 ht657 ht593 ht584 ht602 ht574 ht683 ht664 ht595
  have hccarry3_1 :=
    fd_curve25519_scalar_reduce.carry3_1_eq hcarry3_1 ht842 ht826 ht767 ht678 ht614 ht592 ht583
      ht572 ht741 ht685 ht657 ht593 ht584 ht602 ht574 ht683 ht664 ht595 ht712 ht690 ht662 ht588
  have hccarry4_1 :=
    fd_curve25519_scalar_reduce.carry4_1_eq hcarry4_1 ht847 ht827 ht774 ht757 ht678 ht614 ht592
      ht583 ht572 ht742 ht685 ht657 ht593 ht584 ht602 ht574 ht730 ht683 ht664 ht595 ht690 ht662
      ht588 ht703 ht688 ht669 ht580
  have hccarry5_1 :=
    fd_curve25519_scalar_reduce.carry5_1_eq hcarry5_1 ht852 ht828 ht772 ht678 ht614 ht592 ht583
      ht572 ht685 ht657 ht593 ht584 ht602 ht574 ht732 ht683 ht664 ht595 ht690 ht662 ht588 ht705
      ht688 ht669 ht580 ht667
  have hccarry6_2 :=
    fd_curve25519_scalar_reduce.carry6_2_eq hcarry6_2 ht855 ht806 ht784 ht747 ht685 ht657 ht593
      ht584 ht602 ht574 ht734 ht683 ht664 ht595 ht690 ht662 ht588 ht707 ht688 ht669 ht580 ht667
      ht633 ht616
  have hccarry7_2 :=
    fd_curve25519_scalar_reduce.carry7_2_eq hcarry7_2 ht858 ht812 ht782 ht735 ht683 ht664 ht595
      ht719 ht690 ht662 ht588 ht708 ht688 ht669 ht580 ht631 ht618 ht695 ht667
  have hccarry8_2 :=
    fd_curve25519_scalar_reduce.carry8_2_eq hcarry8_2 ht861 ht810 ht792 ht724 ht690 ht662 ht588
      ht709 ht688 ht669 ht580 ht696 ht667 ht642 ht620 ht597
  have hccarry9_2 :=
    fd_curve25519_scalar_reduce.carry9_2_eq hcarry9_2 ht864 ht817 ht790 ht710 ht688 ht669 ht580
      ht697 ht667 ht640 ht589 ht621 ht607 ht598
  have hccarry10_2 :=
    fd_curve25519_scalar_reduce.carry10_2_eq hcarry10_2 ht867 ht815 ht797 ht701 ht667 ht627 ht590
      ht581
  have hccarry11_2 :=
    fd_curve25519_scalar_reduce.carry11_2_eq hcarry11_2 ht870 ht821 ht795 ht680 ht650 ht591 ht582
      ht609 ht600 ht570
  have hcs11_12 :=
    fd_curve25519_scalar_reduce.s11_12_eq hs11_12 ht870 ht821 ht795 ht680 ht650 ht591 ht582 ht609
      ht600 ht570
  have hcs0_5 :=
    fd_curve25519_scalar_reduce.s0_5_eq hs0_5 ht833 ht823 ht764 ht749 ht678 ht614 ht592 ht583 ht572
      ht874
  have hccarry0_2 := fd_curve25519_scalar_reduce.carry0_2_eq hcarry0_2
  have hcs1_9 :=
    fd_curve25519_scalar_reduce.s1_9_eq hs1_9 ht876 ht838 ht832 ht762 ht678 ht614 ht592 ht583 ht572
      ht737 ht685 ht657 ht593 ht584 ht602 ht574
  have hccarry1_2 := fd_curve25519_scalar_reduce.carry1_2_eq hcarry1_2
  have hcs2_10 :=
    fd_curve25519_scalar_reduce.s2_10_eq hs2_10 ht878 ht843 ht837 ht825 ht769 ht753 ht678 ht614
      ht592 ht583 ht572 ht739 ht685 ht657 ht593 ht584 ht602 ht574 ht683 ht664 ht595
  have hccarry2_2 := fd_curve25519_scalar_reduce.carry2_2_eq hcarry2_2
  have hcs3_11 :=
    fd_curve25519_scalar_reduce.s3_11_eq hs3_11 ht880 ht848 ht842 ht826 ht767 ht678 ht614 ht592
      ht583 ht572 ht741 ht685 ht657 ht593 ht584 ht602 ht574 ht683 ht664 ht595 ht712 ht690 ht662
      ht588
  have hccarry3_2 := fd_curve25519_scalar_reduce.carry3_2_eq hcarry3_2
  have hcs4_12 :=
    fd_curve25519_scalar_reduce.s4_12_eq hs4_12 ht882 ht853 ht847 ht827 ht774 ht757 ht678 ht614
      ht592 ht583 ht572 ht742 ht685 ht657 ht593 ht584 ht602 ht574 ht730 ht683 ht664 ht595 ht690
      ht662 ht588 ht703 ht688 ht669 ht580
  have hccarry4_2 := fd_curve25519_scalar_reduce.carry4_2_eq hcarry4_2
  have hcs5_13 :=
    fd_curve25519_scalar_reduce.s5_13_eq hs5_13 ht856 ht852 ht828 ht772 ht678 ht614 ht592 ht583
      ht572 ht685 ht657 ht593 ht584 ht602 ht574 ht732 ht683 ht664 ht595 ht690 ht662 ht588 ht705
      ht688 ht669 ht580 ht667
  have hccarry5_2 := fd_curve25519_scalar_reduce.carry5_2_eq hcarry5_2
  have hcs6_12 :=
    fd_curve25519_scalar_reduce.s6_12_eq hs6_12 ht859 ht855 ht806 ht784 ht747 ht685 ht657 ht593
      ht584 ht602 ht574 ht734 ht683 ht664 ht595 ht690 ht662 ht588 ht707 ht688 ht669 ht580 ht667
      ht633 ht616
  have hccarry6_3 := fd_curve25519_scalar_reduce.carry6_3_eq hcarry6_3
  have hcs7_13 :=
    fd_curve25519_scalar_reduce.s7_13_eq hs7_13 ht862 ht858 ht812 ht782 ht735 ht683 ht664 ht595
      ht719 ht690 ht662 ht588 ht708 ht688 ht669 ht580 ht631 ht618 ht695 ht667
  have hccarry7_3 := fd_curve25519_scalar_reduce.carry7_3_eq hcarry7_3
  have hcs8_13 :=
    fd_curve25519_scalar_reduce.s8_13_eq hs8_13 ht865 ht861 ht810 ht792 ht724 ht690 ht662 ht588
      ht709 ht688 ht669 ht580 ht696 ht667 ht642 ht620 ht597
  have hccarry8_3 := fd_curve25519_scalar_reduce.carry8_3_eq hcarry8_3
  have hcs9_13 :=
    fd_curve25519_scalar_reduce.s9_13_eq hs9_13 ht868 ht864 ht817 ht790 ht710 ht688 ht669 ht580
      ht697 ht667 ht640 ht589 ht621 ht607 ht598
  have hccarry9_3 := fd_curve25519_scalar_reduce.carry9_3_eq hcarry9_3
  have hcs10_13 :=
    fd_curve25519_scalar_reduce.s10_13_eq hs10_13 ht871 ht867 ht815 ht797 ht701 ht667 ht627 ht590
      ht581
  clear hs0 hs1 hs2 hs4 hs5 hs3 hs6 hs7 hs8 hs10 hs11 hs9 ht541 hs12 hs13 hs14 hs16 hs17 hs15 hs18
    hs19 hs20 hs21 hs22 hs23 ht570 ht572 ht574 ht580 ht581 ht582 ht583 ht584 ht588 ht589 ht590 ht591
    ht592 ht593 ht595 ht597 ht598 ht600 ht602 ht607 ht609 ht614 ht616 ht618 ht620 ht621 ht627
    hcarry6 ht631 ht633 hcarry8 ht640 ht642 hcarry10 ht650 ht651 ht652 hcarry12 ht657 hcarry14 ht662
    ht664 hcarry16 ht667 ht669 hcarry7 ht672 hcarry9 ht675 hcarry11 ht678 ht680 ht681 hcarry13 ht683
    ht685 hcarry15 ht688 ht690 ht695 ht696 ht697 ht701 ht703 ht705 ht707 ht708 ht709 ht710 ht712
    ht719 ht724 ht730 ht732 ht734 ht735 ht737 ht739 ht741 ht742 ht747 ht749 ht753 ht757 hcarry0
    ht762 ht764 hcarry2 ht767 ht769 ht770 hcarry4 ht772 ht774 hcarry6_1 ht782 ht784 hcarry8_1 ht790
    ht792 hcarry10_1 ht795 ht797 hcarry1 ht800 ht801 hcarry3 ht803 hcarry5 ht806 ht807 hcarry7_1
    ht810 ht812 hcarry9_1 ht815 ht817 hcarry11_1 ht821 ht823 ht825 ht826 ht827 ht828 hcarry0_1 ht832
    ht833 hcarry1_1 ht837 ht838 hcarry2_1 ht842 ht843 hcarry3_1 ht847 ht848 hcarry4_1 ht852 ht853
    hcarry5_1 ht855 ht856 hcarry6_2 ht858 ht859 hcarry7_2 ht861 ht862 hcarry8_2 ht864 ht865
    hcarry9_2 ht867 ht868 hcarry10_2 ht870 ht871 hcarry11_2 hs11_12 ht874 ht876 ht878 ht880 ht882
    hs0_5 hcarry0_2 hs1_9 hcarry1_2 hs2_10 hcarry2_2 hs3_11 hcarry3_2 hs4_12 hcarry4_2 hs5_13
    hcarry5_2 hs6_12 hcarry6_3 hs7_13 hcarry7_3 hs8_13 hcarry8_3 hs9_13 hcarry9_3 hs10_13 hcarry10_3
    ht907
  keep_eqs
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.R52x5
