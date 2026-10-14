module

public import Firedancer.Avx512.Common.Neg
public import Firedancer.Avx512.fd_r43x6_diagnose
public import Firedancer.Avx512.fd_r43x6_is_nonzero
public import Firedancer.Avx512.fd_r43x6_unpack
public import Firedancer.Lane.Common.R43x6
public import MLIR.Run.Tactic
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide

/-! The runs of `fd_r43x6_ge_decode2`'s lane build that the `Avx512` callee proofs do not cover:
`fd_r43x6_unpack` and `fd_r43x6_neg` inlined, and `fd_r43x6_is_nonzero` and `fd_r43x6_diagnose`
inlined and, where both points' runs line up, vectorized over two lanes. Each is stepped with
no-overflow facts that hold of any lane; the reduction's result is then `redLimbs` of the input's
limbs, against the old specs by `bv_decide`. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- `<2 x i64>`. -/
abbrev V2 : Ty :=
  .vec 2 64

/-- `<2 x i1>`. -/
abbrev B2 : Ty :=
  .vec 2 1

set_option hygiene false in
/-- A step of the reductions' runs, the lanes' no-overflow facts as simp arguments. -/
local macro "nz_step" : tactic =>
  `(tactic|
    step_pure [sshiftRight40_smulOverflow, and40_add_b20, and43_add_19, and43_add_lshr43,
      tail5_add_sshr43, tail5_add_lshr43, sshr43_add_and43, sshr43_add_and40, sel19_add_and43,
      lanesBelow_getElem])

set_option hygiene false in
/-- `nz_step`, its value named `x`. -/
local macro "nz_step_with " x:ident : tactic =>
  `(tactic|
    step_pure [sshiftRight40_smulOverflow, and40_add_b20, and43_add_19, and43_add_lshr43,
      tail5_add_sshr43, tail5_add_lshr43, sshr43_add_and43, sshr43_add_and40, sel19_add_and43,
      lanesBelow_getElem] with $x:ident)

/-! ## `fd_r43x6_unpack` -/

/-- `fd_r43x6_unpack(u)` as seven instructions: `u` widened (`p4` the shuffle's unused operand),
lane `7` zeroed (`z i7` hold `0 7`), its bytes shuffled (`p64` unused), the lanes shifted by `rs`
and masked by `m`, into `r`. -/
def unpackRun (u p4 : Dst Γ (.vec 4 64)) (z i7 : Dst Γ (.bv 64)) (p64 c e : Dst Γ (.vec 64 8))
    (rs m a b f h r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 1, some 2, some 3, none, none, none, none]) a
      (.val u.i u.h) (.val p4.i p4.h),
    .ternop .insertelement b (.val a.i a.h) (.val z.i z.h) (.val i7.i i7.h),
    .unop (.bitcast (by decide)) c (.val b.i b.h),
    .binop
      (.shufflevector
        #v[some 0, some 1, some 2, some 3, some 4, some 5, some 63, some 63, some 5, some 6, some 7,
          some 8, some 9, some 10, some 63, some 63, some 10, some 11, some 12, some 13, some 14,
          some 15, some 16, some 63, some 16, some 17, some 18, some 19, some 20, some 21, some 63,
          some 63, some 21, some 22, some 23, some 24, some 25, some 26, some 63, some 63, some 26,
          some 27, some 28, some 29, some 30, some 31, some 63, some 63, some 63, some 63, some 63,
          some 63, some 63, some 63, some 63, some 63, some 63, some 63, some 63, some 63, some 63,
          some 63, some 63, some 63])
      e (.val c.i c.h) (.val p64.i p64.h),
    .unop (.bitcast (by decide)) f (.val e.i e.h),
    .binop (.vector (.lshr false)) h (.val f.i f.h) (.val rs.i rs.h),
    .binop (.vector .and) r (.val h.i h.h) (.val m.i m.h)]

/-- `perm`'s byte indices, as the shuffle's mask. -/
theorem unpack_perm_idx :
    permutexvarIdx
        (wwl 0x3f3f050403020100 0x3f3f0a0908070605 0x3f100f0e0d0c0b0a 0x3f3f151413121110
          0x3f3f1a1918171615 0x3f3f1f1e1d1c1b1a 0x3f3f3f3f3f3f3f3f 0x3f3f3f3f3f3f3f3f) =
      #v[0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16,
        17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63,
        63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63] := by
  ext i hi : 1
  simp only [permutexvarIdx, wwl, Vector.getElem_ofFn]
  revert i; decide

/-- Where the body at `pos` is `unpackRun`, `u` holds `U` and the others the constants: running on
from `pos` then `g` gives `K` if it does from `pos + 7` with `fd_r43x6_unpack.spec U` in `r`,
whatever the intermediates hold. -/
theorem runBodyFrom_unpackRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u p4 : Dst Γ (.vec 4 64)} {z i7 : Dst Γ (.bv 64)} {p64 c e : Dst Γ (.vec 64 8)}
    {rs m a b f h r : Dst Γ V} {rest : List (Instr Γ)} {U : Wv} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = unpackRun u p4 z i7 p64 c e rs m a b f h r ++ rest)
    (hR :
      E ⊨ [u := U, z := 0#64, i7 := 7#64, rs :=
        #v[0#64, 3#64, 6#64, 1#64, 4#64, 7#64, 0#64, 0#64], m := Vector.replicate 8
            8796093022207#64])
    (hd : [u.i, p4.i, z.i, i7.i, p64.i, c.i, e.i, rs.i, m.i, a.i, b.i, f.i, h.i].Nodup)
    (hK :
      ∀ (va vb : ⟦V⟧) (vc ve : ⟦.vec 64 8⟧) (vf vh : ⟦V⟧),
        (blk.runBodyFrom
              E[a := va, b := vb, c := vc, e := ve, f := vf, h := vh, r :=
                Ty.wrap (fd_r43x6_unpack.spec U)]
              (pos + 7) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [unpackRun] at hbody
  step_pure with transparent va
  step_pure with transparent vb
  step_pure with transparent vc
  step_pure with transparent ve
  step_pure with vb'
  step_pure [expandOfFn] with transparent vh
  step_pure [expandOfFn] with vr
  have e :
      vb' = mm512_permutexvar_epi8
        (wwl 0x3f3f050403020100 0x3f3f0a0908070605 0x3f100f0e0d0c0b0a 0x3f3f151413121110
          0x3f3f1a1918171615 0x3f3f1f1e1d1c1b1a 0x3f3f3f3f3f3f3f3f 0x3f3f3f3f3f3f3f3f)
        (mm512_inserti64x4 wwl_zero U) := by
    rw [hvb', mm512_permutexvar_epi8, permutexvarBytes, unpack_perm_idx]
    simp [mlir_operation, mm512_inserti64x4]
  have e' : vr = fd_r43x6_unpack.spec U := by
    rw [hvr, fd_r43x6_unpack.spec, ← e]
    apply vec_ext_fin
    intro i
    fin_cases i <;> simp [wwl_and, wwl_shru_vector, wwl, wwl_bcast]
  rw [hE, e']
  exact hK _ _ _ _ _ _

/-- `fd_r43x6_unpack`'s limbs are below `2^43`. -/
theorem unpack_lt (U : Wv) (i : Nat) (h : i < 8) :
    (fd_r43x6_unpack.spec U)[i] < 0x80000000000#64 := by
  simp only [fd_r43x6_unpack.spec, wwl_and, wwl_bcast, Vector.getElem_ofFn, Fin.getElem_fin,
    Vector.getElem_replicate]
  bv_decide

/-! ## No-overflow facts, as the lanes spell them -/

/-- Limb 5's low bits plus `2^20`: no overflow. -/
theorem and40_add_b20 (a : BitVec 64) :
    (a &&& 1099511627775#64).saddOverflow 1048576#64 = false ∧
      (a &&& 1099511627775#64).uaddOverflow 1048576#64 = false := by
  constructor <;> bv_decide

/-- A lane masked by all ones, as the constant spells it. -/
theorem and_allOnes_lit (a : BitVec 64) : a &&& 18446744073709551615#64 = a := by bv_decide

/-- A limb's low bits plus `fd_r43x6_fold_signed`'s bias: no overflow. -/
theorem and43_add_bias (a : BitVec 64) :
    (a &&& 8796093022207#64).saddOverflow 1048576#64 = false ∧
      (a &&& 8796093022207#64).uaddOverflow 1048576#64 = false ∧
      (a &&& 8796093022207#64).saddOverflow 159383552#64 = false ∧
      (a &&& 8796093022207#64).uaddOverflow 159383552#64 = false := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- A limb's low bits plus `19`: no overflow. -/
theorem and43_add_19 (a : BitVec 64) :
    (a &&& 8796093022207#64).saddOverflow 19#64 = false ∧
      (a &&& 8796093022207#64).uaddOverflow 19#64 = false := by
  constructor <;> bv_decide

/-- A limb's low bits plus a carry `>>> 43`: no overflow. -/
theorem and43_add_lshr43 (a b : BitVec 64) :
    (a &&& 8796093022207#64).saddOverflow (b >>> 43) = false ∧
      (a &&& 8796093022207#64).uaddOverflow (b >>> 43) = false := by
  constructor <;> bv_decide

/-- Limb 5's low bits plus `2^20` plus a carry `>>s 43`: no overflow. -/
theorem tail5_add_sshr43 (a b : BitVec 64) :
    ((a &&& 1099511627775#64) + 1048576#64).saddOverflow (b.sshiftRight 43) = false := by bv_decide

/-- `tail5_add_sshr43`'s sum plus a carry `>>> 43`: no overflow. -/
theorem tail5_add_lshr43 (a b c : BitVec 64) :
    ((a &&& 1099511627775#64) + 1048576#64 + b.sshiftRight 43).saddOverflow (c >>> 43) = false ∧
      ((a &&& 1099511627775#64) + 1048576#64 + b.sshiftRight 43).uaddOverflow (c >>> 43) =
        false := by
  constructor <;> bv_decide

/-- A carry `>>s 43` plus a limb's low bits: no overflow. -/
theorem sshr43_add_and43 (a b : BitVec 64) :
    (b.sshiftRight 43).saddOverflow (a &&& 8796093022207#64) = false := by bv_decide

/-- A carry `>>s 43` plus limb 5's low bits: no overflow. -/
theorem sshr43_add_and40 (a b : BitVec 64) :
    (b.sshiftRight 43).saddOverflow (a &&& 1099511627775#64) = false := by bv_decide

/-- `-19` or `0` plus a limb's low bits: no overflow. -/
theorem sel19_add_and43 (p : Prop) [Decidable p] (a : BitVec 64) :
    (if p then 18446744073709551597#64 else 0#64).saddOverflow (a &&& 8796093022207#64) =
      false := by
  split <;> bv_decide

/-! ## `fd_r43x6_neg` -/

/-- `fd_r43x6_neg(x)` as nine instructions: `negIfRun`'s middle, without the select: `negFold x`
through `d lo hi c t u s1 s2` into `n`. -/
def negRun (p x mask shifts b z o m18 d lo hi c t u s1 s2 n : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector (.sub {})) d (.val p.i p.h) (.val x.i x.h),
    .binop (.vector .and) lo (.val d.i d.h) (.val mask.i mask.h),
    .binop (.vector (.ashr false)) hi (.val d.i d.h) (.val shifts.i shifts.h),
    .binop (.shufflevector negRotMask) c (.val hi.i hi.h) (.val z.i z.h),
    .binop (.vector (.mul {})) t (.val c.i c.h) (.val o.i o.h),
    .binop (.vector .and) u (.val t.i t.h) (.val m18.i m18.h),
    .binop (.vector (.add { nsw := true, nuw := true })) s1 (.val lo.i lo.h) (.val b.i b.h),
    .binop (.vector (.add {})) s2 (.val s1.i s1.h) (.val c.i c.h),
    .binop (.vector (.add {})) n (.val s2.i s2.h) (.val u.i u.h)]

/-- Where the body at `pos` is `negRun`, `x` holds `X` and the others the constants: running on from
`pos` then `g` gives `K` if it does from `pos + 9` with `negFold X` in `n`, whatever the
intermediates hold. -/
theorem runBodyFrom_negRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p x mask shifts b z o m18 d lo hi c t u s1 s2 n : Dst Γ V} {rest : List (Instr Γ)} {X : Wwl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = negRun p x mask shifts b z o m18 d lo hi c t u s1 s2 n ++ rest)
    (hR :
      E ⊨ [x := X, p := negP, mask := foldMask, shifts := foldShifts, b := negBias, z := zeroLo,
        o := neg18, m18 := negSel])
    (hd :
      [x.i, p.i, mask.i, shifts.i, b.i, z.i, o.i, m18.i, d.i, lo.i, hi.i, c.i, t.i, u.i, s1.i,
          s2.i].Nodup)
    (hK :
      ∀ vd vlo vhi vc vt vu vs1 vs2 : ⟦V⟧,
        (blk.runBodyFrom
              E[d := vd, lo := vlo, hi := vhi, c := vc, t := vt, u := vu, s1 := vs1, s2 := vs2, n :=
                Ty.wrap (negFold X)]
              (pos + 9) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [negRun] at hbody
  step_pure with transparent vd
  step_pure with transparent vlo
  step_pure [foldShifts_lt] with transparent vhi
  step_pure with transparent vc
  step_pure with transparent vt
  step_pure with transparent vu
  step_pure with transparent vs1
  step_pure with transparent vs2
  step_pure with vn
  rw [hE, ← hK]
  congr
  subst hvn
  apply vec_ext_fin
  intro i
  fin_cases i <;>
    simp [Ty.wrap_vec, and40_add_b20, and43_add_bias, and_allOnes_lit, negFold, negP, foldMask,
      foldShifts, negBias, neg18, negSel]

/-! ## `fd_r43x6_is_nonzero`, lane by lane -/

/-- `fd_r43x6_is_nonzero`'s and `fd_r43x6_diagnose`'s reduction of limbs `x0 … x5`, as the compiled
code computes it: the biased carries, `+ 19`'s carries, `19` taken back off unless bit 255 was set.
The reduced limb `0` unmasked, and the reduced limbs or-ed together. -/
def redLimbs (x0 x1 x2 x3 x4 x5 : BitVec 64) : BitVec 64 × BitVec 64 :=
  let t5 := x5 + 18446744073708503040#64
  let t0 := t5.sshiftRight 40 * 19#64 + x0
  let t1 := t0.sshiftRight 43 + x1
  let t2 := t1.sshiftRight 43 + x2
  let t3 := t2.sshiftRight 43 + x3
  let t4 := t3.sshiftRight 43 + x4
  let e0 := (t0 &&& 8796093022207#64) + 19#64
  let e1 := (t1 &&& 8796093022207#64) + e0 >>> 43
  let e2 := (t2 &&& 8796093022207#64) + e1 >>> 43
  let e3 := (t3 &&& 8796093022207#64) + e2 >>> 43
  let e4 := (t4 &&& 8796093022207#64) + e3 >>> 43
  let v5 := (t5 &&& 1099511627775#64) + 1048576#64 + t4.sshiftRight 43 + e4 >>> 43
  let r0 :=
    (if BitVec.ofBool (v5.ult 1099511627776#64) = 1#1 then 18446744073709551597#64 else 0#64) +
      (e0 &&& 8796093022207#64)
  let r1 := r0.sshiftRight 43 + (e1 &&& 8796093022207#64)
  let r2 := r1.sshiftRight 43 + (e2 &&& 8796093022207#64)
  let r3 := r2.sshiftRight 43 + (e3 &&& 8796093022207#64)
  let r4 := r3.sshiftRight 43 + (e4 &&& 8796093022207#64)
  let r5 := r4.sshiftRight 43 + (v5 &&& 1099511627775#64)
  (r0, (r1 ||| r0 ||| r2 ||| r3 ||| r4) &&& 8796093022207#64 ||| r5)

/-- Whether the reduced limbs are nonzero. -/
def nzLimbs (x0 x1 x2 x3 x4 x5 : BitVec 64) : BitVec 1 :=
  BitVec.ofBool ((redLimbs x0 x1 x2 x3 x4 x5).2 != 0#64)

/-- The reduced limb `0`'s low bit, as an `int`. -/
def parLimbs (x0 x1 x2 x3 x4 x5 : BitVec 64) : BitVec 32 :=
  (redLimbs x0 x1 x2 x3 x4 x5).1.setWidth 32 &&& 1#32

/-- Whether `fd_r43x6_is_nonzero(x)` is nonzero, as an `i1`. -/
abbrev nzBit (x : Wwl) : BitVec 1 :=
  BitVec.ofBool (fd_r43x6_is_nonzero.spec x != 0)

/-- The compiled lanes compute `fd_r43x6_is_nonzero`. -/
theorem nzLimbs_eq' (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    nzLimbs a0 a1 a2 a3 a4 a5 = nzBit #v[a0, a1, a2, a3, a4, a5, a6, a7] := by
  simp only [nzLimbs, redLimbs, nzBit, fd_r43x6_is_nonzero.spec, extractLimbs,
    biasedCarryPropagateLimbs, modNearlyReducedLimbs, carryLimbs, carrySums, m40, m43,
    BitVec.ofNat_eq_ofNat, show (1 <<< 20 : BitVec 64) = 1048576 from rfl, Vector.getElem_mk,
    List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
  bv_decide (config := { enums := false })

/-- A vector of eight lanes, as its literal. -/
theorem vec8_eta (x : Vector α 8) : x = #v[x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7]] := by
  apply vec_ext_fin
  intro i
  fin_cases i <;> rfl

/-- `nzLimbs_eq'` on `x`'s lanes. -/
theorem nzLimbs_eq (x : Wwl) : nzLimbs x[0] x[1] x[2] x[3] x[4] x[5] = nzBit x := by
  rw [nzLimbs_eq' _ _ _ _ _ _ x[6] x[7], ← vec8_eta]

/-- `fd_r43x6_diagnose` through the compiled lanes: `-1` if the reduction is zero, else
`parLimbs`. -/
theorem diagnose_eq' (a0 a1 a2 a3 a4 a5 a6 a7 : BitVec 64) :
    fd_r43x6_diagnose.spec #v[a0, a1, a2, a3, a4, a5, a6, a7] =
      if nzLimbs a0 a1 a2 a3 a4 a5 = 0#1 then -1 else parLimbs a0 a1 a2 a3 a4 a5 := by
  simp only [nzLimbs, parLimbs, redLimbs, fd_r43x6_diagnose.spec, extractLimbs,
    biasedCarryPropagateLimbs, modNearlyReducedLimbs, carryLimbs, carrySums, m40, m43,
    BitVec.ofNat_eq_ofNat, show (1 <<< 20 : BitVec 64) = 1048576 from rfl, Vector.getElem_mk,
    List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
  bv_decide (config := { enums := false })

/-- `diagnose_eq'` on `x`'s lanes. -/
theorem diagnose_eq (x : Wwl) :
    fd_r43x6_diagnose.spec x =
      if nzBit x = 0#1 then -1 else parLimbs x[0] x[1] x[2] x[3] x[4] x[5] := by
  have h := diagnose_eq' x[0] x[1] x[2] x[3] x[4] x[5] x[6] x[7]
  rw [← vec8_eta] at h
  rw [h, nzLimbs_eq]

/-- `fd_r43x6_is_nonzero` on `a` and `b` at once, as the SLP vectorizer compiled it: lane `0` of
each `<2 x i64>` is `a`'s limb, lane `1` `b`'s; `nz` holds whether each is nonzero. -/
def nz2Run (a b : Dst Γ V) (nb m40 s40 k19 b20 s43 m43 two40 m19 zero : Dst Γ V2)
    (x1 x2 x3 x4 x5 t5 y5 c5 d x0 t0 u5 c0 t1 c1 t2 c2 t3 c3 t4 y0 y1 y2 y3 c4 y4 : Dst Γ V2)
    (e0 f0 z0 e1 f1 z1 e2 f2 z2 e3 f3 z3 e4 f4 z4 w5 v5 g5 : Dst Γ V2) (q : Dst Γ B2)
    (f r0 h0 r1 h1 r2 h2 r3 h3 r4 h4 r5 o1 o2 o3 o4 o5 o6 : Dst Γ V2) (nz : Dst Γ B2) :
    List (Instr Γ) :=
  [.binop (.shufflevector #v[some 1, some 9]) x1 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 2, some 10]) x2 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 3, some 11]) x3 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 4, some 12]) x4 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 5, some 13]) x5 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector (.add {})) t5 (.val x5.i x5.h) (.val nb.i nb.h),
    .binop (.vector .and) y5 (.val t5.i t5.h) (.val m40.i m40.h),
    .binop (.vector (.ashr false)) c5 (.val t5.i t5.h) (.val s40.i s40.h),
    .binop (.vector (.mul { nsw := true })) d (.val c5.i c5.h) (.val k19.i k19.h),
    .binop (.shufflevector #v[some 0, some 8]) x0 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector (.add {})) t0 (.val d.i d.h) (.val x0.i x0.h),
    .binop (.vector (.add { nsw := true, nuw := true })) u5 (.val y5.i y5.h) (.val b20.i b20.h),
    .binop (.vector (.ashr false)) c0 (.val t0.i t0.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) t1 (.val c0.i c0.h) (.val x1.i x1.h),
    .binop (.vector (.ashr false)) c1 (.val t1.i t1.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) t2 (.val c1.i c1.h) (.val x2.i x2.h),
    .binop (.vector (.ashr false)) c2 (.val t2.i t2.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) t3 (.val c2.i c2.h) (.val x3.i x3.h),
    .binop (.vector (.ashr false)) c3 (.val t3.i t3.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) t4 (.val c3.i c3.h) (.val x4.i x4.h),
    .binop (.vector .and) y0 (.val t0.i t0.h) (.val m43.i m43.h),
    .binop (.vector .and) y1 (.val t1.i t1.h) (.val m43.i m43.h),
    .binop (.vector .and) y2 (.val t2.i t2.h) (.val m43.i m43.h),
    .binop (.vector .and) y3 (.val t3.i t3.h) (.val m43.i m43.h),
    .binop (.vector (.ashr false)) c4 (.val t4.i t4.h) (.val s43.i s43.h),
    .binop (.vector .and) y4 (.val t4.i t4.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e0 (.val y0.i y0.h) (.val k19.i k19.h),
    .binop (.vector (.lshr false)) f0 (.val e0.i e0.h) (.val s43.i s43.h),
    .binop (.vector .and) z0 (.val e0.i e0.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e1 (.val y1.i y1.h) (.val f0.i f0.h),
    .binop (.vector (.lshr false)) f1 (.val e1.i e1.h) (.val s43.i s43.h),
    .binop (.vector .and) z1 (.val e1.i e1.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e2 (.val y2.i y2.h) (.val f1.i f1.h),
    .binop (.vector (.lshr false)) f2 (.val e2.i e2.h) (.val s43.i s43.h),
    .binop (.vector .and) z2 (.val e2.i e2.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e3 (.val y3.i y3.h) (.val f2.i f2.h),
    .binop (.vector (.lshr false)) f3 (.val e3.i e3.h) (.val s43.i s43.h),
    .binop (.vector .and) z3 (.val e3.i e3.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e4 (.val y4.i y4.h) (.val f3.i f3.h),
    .binop (.vector (.lshr false)) f4 (.val e4.i e4.h) (.val s43.i s43.h),
    .binop (.vector .and) z4 (.val e4.i e4.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true })) w5 (.val u5.i u5.h) (.val c4.i c4.h),
    .binop (.vector (.add { nsw := true, nuw := true })) v5 (.val w5.i w5.h) (.val f4.i f4.h),
    .binop (.vector .and) g5 (.val v5.i v5.h) (.val m40.i m40.h),
    .binop (.vector (.icmp .ult)) q (.val v5.i v5.h) (.val two40.i two40.h),
    .ternop (.vector (.select (τ := .bv 64))) f (.val q.i q.h) (.val m19.i m19.h)
      (.val zero.i zero.h),
    .binop (.vector (.add { nsw := true })) r0 (.val f.i f.h) (.val z0.i z0.h),
    .binop (.vector (.ashr false)) h0 (.val r0.i r0.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r1 (.val h0.i h0.h) (.val z1.i z1.h),
    .binop (.vector (.ashr false)) h1 (.val r1.i r1.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r2 (.val h1.i h1.h) (.val z2.i z2.h),
    .binop (.vector (.ashr false)) h2 (.val r2.i r2.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r3 (.val h2.i h2.h) (.val z3.i z3.h),
    .binop (.vector (.ashr false)) h3 (.val r3.i r3.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r4 (.val h3.i h3.h) (.val z4.i z4.h),
    .binop (.vector (.ashr false)) h4 (.val r4.i r4.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r5 (.val h4.i h4.h) (.val g5.i g5.h),
    .binop (.vector (.or false)) o1 (.val r1.i r1.h) (.val r0.i r0.h),
    .binop (.vector (.or false)) o2 (.val o1.i o1.h) (.val r2.i r2.h),
    .binop (.vector (.or false)) o3 (.val o2.i o2.h) (.val r3.i r3.h),
    .binop (.vector (.or false)) o4 (.val o3.i o3.h) (.val r4.i r4.h),
    .binop (.vector .and) o5 (.val o4.i o4.h) (.val m43.i m43.h),
    .binop (.vector (.or false)) o6 (.val o5.i o5.h) (.val r5.i r5.h),
    .binop (.vector (.icmp .ne)) nz (.val o6.i o6.h) (.val zero.i zero.h)]

/-- `nz2Run`'s constants, splat over both lanes: `-2^20`, the masks, shifts and multipliers,
`2^40`, `-19` and `0`. -/
abbrev Nz2Consts (E : ⟪Γ⟫) (nb m40 s40 k19 b20 s43 m43 two40 m19 zero : Dst Γ V2) : Prop :=
  E ⊨ [nb := Vector.replicate 2 18446744073708503040#64, m40 := Vector.replicate 2 1099511627775#64,
    s40 := Vector.replicate 2 40#64, k19 := Vector.replicate 2 19#64, b20 :=
    Vector.replicate 2 1048576#64, s43 := Vector.replicate 2 43#64, m43 :=
    Vector.replicate 2 8796093022207#64, two40 := Vector.replicate 2 1099511627776#64, m19 :=
    Vector.replicate 2 18446744073709551597#64, zero := Vector.replicate 2 0#64]

-- 64 steps over two lanes, over 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- Where the body at `pos` is `nz2Run`, `a` holds `A`, `b` lanes `0 … 5` of `B` and the others the
constants: running on from `pos` then `g` gives `K` if it does from `pos + 64` with whether
`fd_r43x6_is_nonzero` of `A` and of `B` is nonzero in `nz`'s lanes, whatever the intermediates
hold. -/
theorem runBodyFrom_nz2Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {a b : Dst Γ V}
    {nb m40 s40 k19 b20 s43 m43 two40 m19 zero : Dst Γ V2}
    {x1 x2 x3 x4 x5 t5 y5 c5 d x0 t0 u5 c0 t1 c1 t2 c2 t3 c3 t4 y0 y1 y2 y3 c4 y4 : Dst Γ V2}
    {e0 f0 z0 e1 f1 z1 e2 f2 z2 e3 f3 z3 e4 f4 z4 w5 v5 g5 : Dst Γ V2} {q : Dst Γ B2}
    {f r0 h0 r1 h1 r2 h2 r3 h3 r4 h4 r5 o1 o2 o3 o4 o5 o6 : Dst Γ V2} {nz : Dst Γ B2}
    {rest : List (Instr Γ)}
    {A B : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = nz2Run a b nb m40 s40 k19 b20 s43 m43 two40 m19 zero x1 x2 x3 x4
        x5 t5 y5 c5 d x0 t0 u5 c0 t1 c1 t2 c2 t3 c3 t4 y0 y1 y2 y3 c4 y4 e0 f0 z0 e1 f1 z1 e2 f2 z2
        e3 f3 z3 e4 f4 z4 w5 v5 g5 q f r0 h0 r1 h1 r2 h2 r3 h3 r4 h4 r5 o1 o2 o3 o4 o5 o6 nz ++
        rest)
    (hR : E ⊨ [a := A, b := lanesBelow 6 B])
    (hC : Nz2Consts E nb m40 s40 k19 b20 s43 m43 two40 m19 zero)
    (hd : [a.i, b.i, nb.i, m40.i, s40.i, k19.i, b20.i, s43.i, m43.i, two40.i, m19.i, zero.i, x1.i,
        x2.i, x3.i, x4.i, x5.i, t5.i, y5.i, c5.i, d.i, x0.i, t0.i, u5.i, c0.i, t1.i, c1.i, t2.i,
        c2.i, t3.i, c3.i, t4.i, y0.i, y1.i, y2.i, y3.i, c4.i, y4.i, e0.i, f0.i, z0.i, e1.i, f1.i,
        z1.i, e2.i, f2.i, z2.i, e3.i, f3.i, z3.i, e4.i, f4.i, z4.i, w5.i, v5.i, g5.i, q.i, f.i,
        r0.i, h0.i, r1.i, h1.i, r2.i, h2.i, r3.i, h3.i, r4.i, h4.i, r5.i, o1.i, o2.i, o3.i, o4.i,
        o5.i, o6.i].Nodup)
    (hK :
      ∀ (vx1 vx2 vx3 vx4 vx5 vt5 vy5 vc5 vd vx0 vt0 vu5 vc0 vt1 vc1 vt2 vc2 vt3 vc3 vt4 vy0 vy1 vy2
          vy3 vc4 vy4 ve0 vf0 vz0 ve1 vf1 vz1 ve2 vf2 vz2 ve3 vf3 vz3 ve4 vf4 vz4 vw5 vv5 vg5 vf
          vr0 vh0 vr1 vh1 vr2 vh2 vr3 vh3 vr4 vh4 vr5 vo1 vo2 vo3 vo4 vo5 vo6 : ⟦V2⟧) (vq : ⟦B2⟧),
        (blk.runBodyFrom E[x1 := vx1, x2 := vx2, x3 := vx3, x4 := vx4, x5 := vx5, t5 := vt5, y5 :=
            vy5, c5 := vc5, d := vd, x0 := vx0, t0 := vt0, u5 := vu5, c0 := vc0, t1 := vt1, c1 :=
            vc1, t2 := vt2, c2 := vc2, t3 := vt3, c3 := vc3, t4 := vt4, y0 := vy0, y1 := vy1, y2 :=
            vy2, y3 := vy3, c4 := vc4, y4 := vy4, e0 := ve0, f0 := vf0, z0 := vz0, e1 := ve1, f1 :=
            vf1, z1 := vz1, e2 := ve2, f2 := vf2, z2 := vz2, e3 := ve3, f3 := vf3, z3 := vz3, e4 :=
            ve4, f4 := vf4, z4 := vz4, w5 := vw5, v5 := vv5, g5 := vg5, q := vq, f := vf, r0 :=
            vr0, h0 := vh0, r1 := vr1, h1 := vh1, r2 := vr2, h2 := vh2, r3 := vr3, h3 := vh3, r4 :=
            vr4, h4 := vh4, r5 := vr5, o1 := vo1, o2 := vo2, o3 := vo3, o4 := vo4, o5 := vo5, o6 :=
            vo6, nz := Ty.wrap #v[nzBit A, nzBit B]] (pos + 64) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [nz2Run] at hbody
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt5
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt0
  nz_step
  nz_step
  nz_step_with vt1
  nz_step
  nz_step_with vt2
  nz_step
  nz_step_with vt3
  nz_step
  nz_step_with vt4
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with ve0
  nz_step
  nz_step
  nz_step_with ve1
  nz_step
  nz_step
  nz_step_with ve2
  nz_step
  nz_step
  nz_step_with ve3
  nz_step
  nz_step
  nz_step_with ve4
  nz_step
  nz_step
  nz_step
  nz_step_with vv5
  nz_step
  nz_step
  nz_step
  nz_step_with vr0
  nz_step
  nz_step_with vr1
  nz_step
  nz_step_with vr2
  nz_step
  nz_step_with vr3
  nz_step
  nz_step_with vr4
  nz_step
  nz_step_with vr5
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with wnz
  have e : wnz = #v[nzBit A, nzBit B] := by
    rw [← nzLimbs_eq, ← nzLimbs_eq]
    subst_vars
    apply vec_ext_fin
    intro i
    fin_cases i <;> rfl
  rw [hE, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `fd_r43x6_is_nonzero`'s scalar constants: the lane indices `0 … 5`, `-2^20`, the masks, shifts
and multipliers, `2^20`, `2^40` and `-19`. -/
abbrev NzConsts (E : ⟪Γ⟫)
    (i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19 : Dst Γ (.bv 64)) : Prop :=
  E ⊨ [i0 := 0#64, i1 := 1#64, i2 := 2#64, i3 := 3#64, i4 := 4#64, i5 := 5#64, nb :=
    18446744073708503040#64, s40 := 40#64, m40 := 1099511627775#64, k19 := 19#64, s43 := 43#64,
    m43 := 8796093022207#64, b20 := 1048576#64, two40 := 1099511627776#64, m19 :=
    18446744073709551597#64]

/-- `fd_r43x6_is_nonzero(x)` as compiled in `^bb0`, on lanes `0 … 5` of `x`: whether it is nonzero
in `w63`, the intermediates in `w0 … w62`. -/
def nz1Run (x : Dst Γ V)
    (i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19 w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11
      w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32 w33 w34
      w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54 w55 w56 w57 w58
      w59 w60 w61 w62 : Dst Γ (.bv 64))
    (w44 w63 : Dst Γ (.bv 1)) : List (Instr Γ) :=
  [.binop .extractelement w0 (.val x.i x.h) (.val i0.i i0.h),
    .binop .extractelement w1 (.val x.i x.h) (.val i1.i i1.h),
    .binop .extractelement w2 (.val x.i x.h) (.val i2.i i2.h),
    .binop .extractelement w3 (.val x.i x.h) (.val i3.i i3.h),
    .binop .extractelement w4 (.val x.i x.h) (.val i4.i i4.h),
    .binop .extractelement w5 (.val x.i x.h) (.val i5.i i5.h),
    .binop (.add {}) w6 (.val w5.i w5.h) (.val nb.i nb.h),
    .binop (.ashr false) w7 (.val w6.i w6.h) (.val s40.i s40.h),
    .binop .and w8 (.val w6.i w6.h) (.val m40.i m40.h),
    .binop (.mul { nsw := true }) w9 (.val w7.i w7.h) (.val k19.i k19.h),
    .binop (.add {}) w10 (.val w9.i w9.h) (.val w0.i w0.h),
    .binop (.ashr false) w11 (.val w10.i w10.h) (.val s43.i s43.h),
    .binop .and w12 (.val w10.i w10.h) (.val m43.i m43.h),
    .binop (.add {}) w13 (.val w11.i w11.h) (.val w1.i w1.h),
    .binop (.ashr false) w14 (.val w13.i w13.h) (.val s43.i s43.h),
    .binop .and w15 (.val w13.i w13.h) (.val m43.i m43.h),
    .binop (.add {}) w16 (.val w14.i w14.h) (.val w2.i w2.h),
    .binop (.ashr false) w17 (.val w16.i w16.h) (.val s43.i s43.h),
    .binop .and w18 (.val w16.i w16.h) (.val m43.i m43.h),
    .binop (.add {}) w19 (.val w17.i w17.h) (.val w3.i w3.h),
    .binop (.ashr false) w20 (.val w19.i w19.h) (.val s43.i s43.h),
    .binop .and w21 (.val w19.i w19.h) (.val m43.i m43.h),
    .binop (.add {}) w22 (.val w20.i w20.h) (.val w4.i w4.h),
    .binop (.ashr false) w23 (.val w22.i w22.h) (.val s43.i s43.h),
    .binop .and w24 (.val w22.i w22.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w25 (.val w12.i w12.h) (.val k19.i k19.h),
    .binop (.lshr false) w26 (.val w25.i w25.h) (.val s43.i s43.h),
    .binop .and w27 (.val w25.i w25.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w28 (.val w15.i w15.h) (.val w26.i w26.h),
    .binop (.lshr false) w29 (.val w28.i w28.h) (.val s43.i s43.h),
    .binop .and w30 (.val w28.i w28.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w31 (.val w18.i w18.h) (.val w29.i w29.h),
    .binop (.lshr false) w32 (.val w31.i w31.h) (.val s43.i s43.h),
    .binop .and w33 (.val w31.i w31.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w34 (.val w21.i w21.h) (.val w32.i w32.h),
    .binop (.lshr false) w35 (.val w34.i w34.h) (.val s43.i s43.h),
    .binop .and w36 (.val w34.i w34.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w37 (.val w24.i w24.h) (.val w35.i w35.h),
    .binop (.lshr false) w38 (.val w37.i w37.h) (.val s43.i s43.h),
    .binop .and w39 (.val w37.i w37.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w40 (.val w8.i w8.h) (.val b20.i b20.h),
    .binop (.add { nsw := true }) w41 (.val w40.i w40.h) (.val w23.i w23.h),
    .binop (.add { nsw := true, nuw := true }) w42 (.val w41.i w41.h) (.val w38.i w38.h),
    .binop .and w43 (.val w42.i w42.h) (.val m40.i m40.h),
    .binop (.icmp .ult) w44 (.val w42.i w42.h) (.val two40.i two40.h),
    .ternop (.select (τ := (.bv 64))) w45 (.val w44.i w44.h) (.val m19.i m19.h) (.val i0.i i0.h),
    .binop (.add { nsw := true }) w46 (.val w45.i w45.h) (.val w27.i w27.h),
    .binop (.ashr false) w47 (.val w46.i w46.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w48 (.val w47.i w47.h) (.val w30.i w30.h),
    .binop (.ashr false) w49 (.val w48.i w48.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w50 (.val w49.i w49.h) (.val w33.i w33.h),
    .binop (.ashr false) w51 (.val w50.i w50.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w52 (.val w51.i w51.h) (.val w36.i w36.h),
    .binop (.ashr false) w53 (.val w52.i w52.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w54 (.val w53.i w53.h) (.val w39.i w39.h),
    .binop (.ashr false) w55 (.val w54.i w54.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w56 (.val w55.i w55.h) (.val w43.i w43.h),
    .binop (.or false) w57 (.val w48.i w48.h) (.val w46.i w46.h),
    .binop (.or false) w58 (.val w57.i w57.h) (.val w50.i w50.h),
    .binop (.or false) w59 (.val w58.i w58.h) (.val w52.i w52.h),
    .binop (.or false) w60 (.val w59.i w59.h) (.val w54.i w54.h),
    .binop .and w61 (.val w60.i w60.h) (.val m43.i m43.h),
    .binop (.or false) w62 (.val w61.i w61.h) (.val w56.i w56.h),
    .binop (.icmp .ne) w63 (.val w62.i w62.h) (.val i0.i i0.h)]

/-- Where the body at `pos` is `nz1Run`, `x` holds lanes `0 … 5` of `X` and the others the
constants: running on from `pos` then `g` gives `K` if it does from `pos + 64` with whether
`fd_r43x6_is_nonzero X` is nonzero in `w63`, whatever the intermediates hold. -/
theorem runBodyFrom_nz1Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x : Dst Γ V} {i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19 w0 w1 w2 w3 w4 w5 w6 w7
        w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30
        w31 w32 w33 w34 w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54
        w55 w56 w57 w58 w59 w60 w61 w62 : Dst Γ (.bv 64)} {w44 w63 : Dst Γ (.bv 1)}
    {rest : List (Instr Γ)} {X : Wwl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = nz1Run x i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19 w0
        w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25
        w26 w27 w28 w29 w30 w31 w32 w33 w34 w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48 w49
        w50 w51 w52 w53 w54 w55 w56 w57 w58 w59 w60 w61 w62 w44 w63 ++ rest)
    (hR : E ⊨ [x := lanesBelow 6 X])
    (hC : NzConsts E i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19)
    (hd : [x.i, i0.i, i1.i, i2.i, i3.i, i4.i, i5.i, nb.i, s40.i, m40.i, k19.i, s43.i, m43.i, b20.i,
        two40.i, m19.i, w0.i, w1.i, w2.i, w3.i, w4.i, w5.i, w6.i, w7.i, w8.i, w9.i, w10.i, w11.i,
        w12.i, w13.i, w14.i, w15.i, w16.i, w17.i, w18.i, w19.i, w20.i, w21.i, w22.i, w23.i, w24.i,
        w25.i, w26.i, w27.i, w28.i, w29.i, w30.i, w31.i, w32.i, w33.i, w34.i, w35.i, w36.i, w37.i,
        w38.i, w39.i, w40.i, w41.i, w42.i, w43.i, w44.i, w45.i, w46.i, w47.i, w48.i, w49.i, w50.i,
        w51.i, w52.i, w53.i, w54.i, w55.i, w56.i, w57.i, w58.i, w59.i, w60.i, w61.i, w62.i].Nodup)
    (hK :
      ∀ (vw0 vw1 vw2 vw3 vw4 vw5 vw6 vw7 vw8 vw9 vw10 vw11 vw12 vw13 vw14 vw15 vw16 vw17 vw18 vw19
          vw20 vw21 vw22 vw23 vw24 vw25 vw26 vw27 vw28 vw29 vw30 vw31 vw32 vw33 vw34 vw35 vw36 vw37
          vw38 vw39 vw40 vw41 vw42 vw43 : ⟦(.bv 64)⟧) (vw44 : ⟦(.bv 1)⟧) (vw45 vw46 vw47 vw48 vw49
          vw50 vw51 vw52 vw53 vw54 vw55 vw56 vw57 vw58 vw59 vw60 vw61 vw62 : ⟦(.bv 64)⟧),
        (blk.runBodyFrom E[w0 := vw0, w1 := vw1, w2 := vw2, w3 := vw3, w4 := vw4, w5 := vw5, w6 :=
            vw6, w7 := vw7, w8 := vw8, w9 := vw9, w10 := vw10, w11 := vw11, w12 := vw12, w13 :=
            vw13, w14 := vw14, w15 := vw15, w16 := vw16, w17 := vw17, w18 := vw18, w19 := vw19, w20
            := vw20, w21 := vw21, w22 := vw22, w23 := vw23, w24 := vw24, w25 := vw25, w26 := vw26,
            w27 := vw27, w28 := vw28, w29 := vw29, w30 := vw30, w31 := vw31, w32 := vw32, w33 :=
            vw33, w34 := vw34, w35 := vw35, w36 := vw36, w37 := vw37, w38 := vw38, w39 := vw39, w40
            := vw40, w41 := vw41, w42 := vw42, w43 := vw43, w44 := vw44, w45 := vw45, w46 := vw46,
            w47 := vw47, w48 := vw48, w49 := vw49, w50 := vw50, w51 := vw51, w52 := vw52, w53 :=
            vw53, w54 := vw54, w55 := vw55, w56 := vw56, w57 := vw57, w58 := vw58, w59 := vw59, w60
            := vw60, w61 := vw61, w62 := vw62, w63 := .value (nzBit X)] (pos + 64) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [nz1Run] at hbody
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt5
  nz_step
  nz_step
  nz_step
  nz_step_with vt0
  nz_step
  nz_step
  nz_step_with vt1
  nz_step
  nz_step
  nz_step_with vt2
  nz_step
  nz_step
  nz_step_with vt3
  nz_step
  nz_step
  nz_step_with vt4
  nz_step
  nz_step
  nz_step_with ve0
  nz_step
  nz_step
  nz_step_with ve1
  nz_step
  nz_step
  nz_step_with ve2
  nz_step
  nz_step
  nz_step_with ve3
  nz_step
  nz_step
  nz_step_with ve4
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vv5
  nz_step
  nz_step
  nz_step
  nz_step_with vr0
  nz_step
  nz_step_with vr1
  nz_step
  nz_step_with vr2
  nz_step
  nz_step_with vr3
  nz_step
  nz_step_with vr4
  nz_step
  nz_step_with vr5
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with wnz
  have e : wnz = nzBit X := by
    rw [← nzLimbs_eq]
    subst_vars
    rfl
  rw [hE, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `nz1Run` as compiled in `^bb1`, its carries and reductions interleaved, on `x`. -/
def nz1Run' (x : Dst Γ V)
    (i5 nb m40 b20 s40 k19 i0 s43 i1 i2 i3 i4 m43 two40 m19 w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11
      w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32 w33 w34
      w35 w36 w37 w39 w40 w41 w42 w43 w44 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54 w55 w56 w57 w58
      w59 w60 w61 w62 : Dst Γ (.bv 64))
    (w38 w63 : Dst Γ (.bv 1)) : List (Instr Γ) :=
  [.binop .extractelement w0 (.val x.i x.h) (.val i5.i i5.h),
    .binop (.add {}) w1 (.val w0.i w0.h) (.val nb.i nb.h),
    .binop .and w2 (.val w1.i w1.h) (.val m40.i m40.h),
    .binop (.add { nsw := true, nuw := true }) w3 (.val w2.i w2.h) (.val b20.i b20.h),
    .binop (.ashr false) w4 (.val w1.i w1.h) (.val s40.i s40.h),
    .binop (.mul { nsw := true }) w5 (.val w4.i w4.h) (.val k19.i k19.h),
    .binop .extractelement w6 (.val x.i x.h) (.val i0.i i0.h),
    .binop (.add {}) w7 (.val w5.i w5.h) (.val w6.i w6.h),
    .binop (.ashr false) w8 (.val w7.i w7.h) (.val s43.i s43.h),
    .binop .extractelement w9 (.val x.i x.h) (.val i1.i i1.h),
    .binop (.add {}) w10 (.val w8.i w8.h) (.val w9.i w9.h),
    .binop (.ashr false) w11 (.val w10.i w10.h) (.val s43.i s43.h),
    .binop .extractelement w12 (.val x.i x.h) (.val i2.i i2.h),
    .binop (.add {}) w13 (.val w11.i w11.h) (.val w12.i w12.h),
    .binop (.ashr false) w14 (.val w13.i w13.h) (.val s43.i s43.h),
    .binop .extractelement w15 (.val x.i x.h) (.val i3.i i3.h),
    .binop (.add {}) w16 (.val w14.i w14.h) (.val w15.i w15.h),
    .binop (.ashr false) w17 (.val w16.i w16.h) (.val s43.i s43.h),
    .binop .extractelement w18 (.val x.i x.h) (.val i4.i i4.h),
    .binop (.add {}) w19 (.val w17.i w17.h) (.val w18.i w18.h),
    .binop (.ashr false) w20 (.val w19.i w19.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w21 (.val w3.i w3.h) (.val w20.i w20.h),
    .binop .and w22 (.val w19.i w19.h) (.val m43.i m43.h),
    .binop .and w23 (.val w16.i w16.h) (.val m43.i m43.h),
    .binop .and w24 (.val w13.i w13.h) (.val m43.i m43.h),
    .binop .and w25 (.val w10.i w10.h) (.val m43.i m43.h),
    .binop .and w26 (.val w7.i w7.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w27 (.val w26.i w26.h) (.val k19.i k19.h),
    .binop (.lshr false) w28 (.val w27.i w27.h) (.val s43.i s43.h),
    .binop (.add { nsw := true, nuw := true }) w29 (.val w25.i w25.h) (.val w28.i w28.h),
    .binop (.lshr false) w30 (.val w29.i w29.h) (.val s43.i s43.h),
    .binop (.add { nsw := true, nuw := true }) w31 (.val w24.i w24.h) (.val w30.i w30.h),
    .binop (.lshr false) w32 (.val w31.i w31.h) (.val s43.i s43.h),
    .binop (.add { nsw := true, nuw := true }) w33 (.val w23.i w23.h) (.val w32.i w32.h),
    .binop (.lshr false) w34 (.val w33.i w33.h) (.val s43.i s43.h),
    .binop (.add { nsw := true, nuw := true }) w35 (.val w22.i w22.h) (.val w34.i w34.h),
    .binop (.lshr false) w36 (.val w35.i w35.h) (.val s43.i s43.h),
    .binop (.add { nsw := true, nuw := true }) w37 (.val w21.i w21.h) (.val w36.i w36.h),
    .binop (.icmp .ult) w38 (.val w37.i w37.h) (.val two40.i two40.h),
    .ternop (.select (τ := (.bv 64))) w39 (.val w38.i w38.h) (.val m19.i m19.h) (.val i0.i i0.h),
    .binop .and w40 (.val w27.i w27.h) (.val m43.i m43.h),
    .binop (.add { nsw := true }) w41 (.val w39.i w39.h) (.val w40.i w40.h),
    .binop (.ashr false) w42 (.val w41.i w41.h) (.val s43.i s43.h),
    .binop .and w43 (.val w29.i w29.h) (.val m43.i m43.h),
    .binop (.add { nsw := true }) w44 (.val w42.i w42.h) (.val w43.i w43.h),
    .binop (.or false) w45 (.val w44.i w44.h) (.val w41.i w41.h),
    .binop (.ashr false) w46 (.val w44.i w44.h) (.val s43.i s43.h),
    .binop .and w47 (.val w31.i w31.h) (.val m43.i m43.h),
    .binop (.add { nsw := true }) w48 (.val w46.i w46.h) (.val w47.i w47.h),
    .binop (.or false) w49 (.val w45.i w45.h) (.val w48.i w48.h),
    .binop (.ashr false) w50 (.val w48.i w48.h) (.val s43.i s43.h),
    .binop .and w51 (.val w33.i w33.h) (.val m43.i m43.h),
    .binop (.add { nsw := true }) w52 (.val w50.i w50.h) (.val w51.i w51.h),
    .binop (.or false) w53 (.val w49.i w49.h) (.val w52.i w52.h),
    .binop (.ashr false) w54 (.val w52.i w52.h) (.val s43.i s43.h),
    .binop .and w55 (.val w35.i w35.h) (.val m43.i m43.h),
    .binop (.add { nsw := true }) w56 (.val w54.i w54.h) (.val w55.i w55.h),
    .binop (.or false) w57 (.val w53.i w53.h) (.val w56.i w56.h),
    .binop .and w58 (.val w57.i w57.h) (.val m43.i m43.h),
    .binop (.ashr false) w59 (.val w56.i w56.h) (.val s43.i s43.h),
    .binop .and w60 (.val w37.i w37.h) (.val m40.i m40.h),
    .binop (.add { nsw := true }) w61 (.val w59.i w59.h) (.val w60.i w60.h),
    .binop (.or false) w62 (.val w58.i w58.h) (.val w61.i w61.h),
    .binop (.icmp .ne) w63 (.val w62.i w62.h) (.val i0.i i0.h)]

/-- `runBodyFrom_nz1Run` for `nz1Run'`, `x` holding `X`. -/
theorem runBodyFrom_nz1Run' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x : Dst Γ V} {i5 nb m40 b20 s40 k19 i0 s43 i1 i2 i3 i4 m43 two40 m19 w0 w1 w2 w3 w4 w5 w6 w7
        w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30
        w31 w32 w33 w34 w35 w36 w37 w39 w40 w41 w42 w43 w44 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54
        w55 w56 w57 w58 w59 w60 w61 w62 : Dst Γ (.bv 64)} {w38 w63 : Dst Γ (.bv 1)}
    {rest : List (Instr Γ)} {X : Wwl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = nz1Run' x i5 nb m40 b20 s40 k19 i0 s43 i1 i2 i3 i4 m43 two40 m19
        w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24
        w25 w26 w27 w28 w29 w30 w31 w32 w33 w34 w35 w36 w37 w39 w40 w41 w42 w43 w44 w45 w46 w47 w48
        w49 w50 w51 w52 w53 w54 w55 w56 w57 w58 w59 w60 w61 w62 w38 w63 ++ rest)
    (hR : E ⊨ [x := X])
    (hC : NzConsts E i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19)
    (hd : [x.i, i5.i, nb.i, m40.i, b20.i, s40.i, k19.i, i0.i, s43.i, i1.i, i2.i, i3.i, i4.i, m43.i,
        two40.i, m19.i, w0.i, w1.i, w2.i, w3.i, w4.i, w5.i, w6.i, w7.i, w8.i, w9.i, w10.i, w11.i,
        w12.i, w13.i, w14.i, w15.i, w16.i, w17.i, w18.i, w19.i, w20.i, w21.i, w22.i, w23.i, w24.i,
        w25.i, w26.i, w27.i, w28.i, w29.i, w30.i, w31.i, w32.i, w33.i, w34.i, w35.i, w36.i, w37.i,
        w38.i, w39.i, w40.i, w41.i, w42.i, w43.i, w44.i, w45.i, w46.i, w47.i, w48.i, w49.i, w50.i,
        w51.i, w52.i, w53.i, w54.i, w55.i, w56.i, w57.i, w58.i, w59.i, w60.i, w61.i, w62.i].Nodup)
    (hK :
      ∀ (vw0 vw1 vw2 vw3 vw4 vw5 vw6 vw7 vw8 vw9 vw10 vw11 vw12 vw13 vw14 vw15 vw16 vw17 vw18 vw19
          vw20 vw21 vw22 vw23 vw24 vw25 vw26 vw27 vw28 vw29 vw30 vw31 vw32 vw33 vw34 vw35 vw36 vw37
          : ⟦(.bv 64)⟧) (vw38 : ⟦(.bv 1)⟧) (vw39 vw40 vw41 vw42 vw43 vw44 vw45 vw46 vw47 vw48 vw49
          vw50 vw51 vw52 vw53 vw54 vw55 vw56 vw57 vw58 vw59 vw60 vw61 vw62 : ⟦(.bv 64)⟧),
        (blk.runBodyFrom E[w0 := vw0, w1 := vw1, w2 := vw2, w3 := vw3, w4 := vw4, w5 := vw5, w6 :=
            vw6, w7 := vw7, w8 := vw8, w9 := vw9, w10 := vw10, w11 := vw11, w12 := vw12, w13 :=
            vw13, w14 := vw14, w15 := vw15, w16 := vw16, w17 := vw17, w18 := vw18, w19 := vw19, w20
            := vw20, w21 := vw21, w22 := vw22, w23 := vw23, w24 := vw24, w25 := vw25, w26 := vw26,
            w27 := vw27, w28 := vw28, w29 := vw29, w30 := vw30, w31 := vw31, w32 := vw32, w33 :=
            vw33, w34 := vw34, w35 := vw35, w36 := vw36, w37 := vw37, w38 := vw38, w39 := vw39, w40
            := vw40, w41 := vw41, w42 := vw42, w43 := vw43, w44 := vw44, w45 := vw45, w46 := vw46,
            w47 := vw47, w48 := vw48, w49 := vw49, w50 := vw50, w51 := vw51, w52 := vw52, w53 :=
            vw53, w54 := vw54, w55 := vw55, w56 := vw56, w57 := vw57, w58 := vw58, w59 := vw59, w60
            := vw60, w61 := vw61, w62 := vw62, w63 := .value (nzBit X)] (pos + 64) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [nz1Run'] at hbody
  nz_step
  nz_step_with vt5
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt0
  nz_step
  nz_step
  nz_step_with vt1
  nz_step
  nz_step
  nz_step_with vt2
  nz_step
  nz_step
  nz_step_with vt3
  nz_step
  nz_step
  nz_step_with vt4
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with ve0
  nz_step
  nz_step_with ve1
  nz_step
  nz_step_with ve2
  nz_step
  nz_step_with ve3
  nz_step
  nz_step_with ve4
  nz_step
  nz_step_with vv5
  nz_step
  nz_step
  nz_step
  nz_step_with vr0
  nz_step
  nz_step
  nz_step_with vr1
  nz_step
  nz_step
  nz_step
  nz_step_with vr2
  nz_step
  nz_step
  nz_step
  nz_step_with vr3
  nz_step
  nz_step
  nz_step
  nz_step_with vr4
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vr5
  nz_step
  nz_step_with wnz
  have e : wnz = nzBit X := by
    rw [← nzLimbs_eq]
    subst_vars
    rfl
  rw [hE, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `fd_r43x6_diagnose` on `a` and `b` at once (lane `0` of each `<2 x i64>` is `a`'s limb, lane `1`
`b`'s), its result compared as `x_0 != x_mod_2` compiles: whether each reduction is nonzero in
`w63`, whether its low bit is `x0v`'s lane in `w66`. -/
def diag2Run (a b : Dst Γ V)
    (nb s40 k19 m43 m40 b20 s43 two40 m19 zero w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15
      w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32 w33 w34 w35 w36 w37 w38
      w40 w41 w42 w43 w44 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54 w55 w56 w57 w58 w59 w60 w61 w62 :
      Dst Γ V2)
    (one x0v w64 w65 : Dst Γ (.vec 2 32)) (w39 w63 w66 : Dst Γ B2) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 5, some 13]) w0 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector (.add {})) w1 (.val w0.i w0.h) (.val nb.i nb.h),
    .binop (.vector (.ashr false)) w2 (.val w1.i w1.h) (.val s40.i s40.h),
    .binop (.vector (.mul { nsw := true })) w3 (.val w2.i w2.h) (.val k19.i k19.h),
    .binop (.shufflevector #v[some 0, some 8]) w4 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector (.add {})) w5 (.val w3.i w3.h) (.val w4.i w4.h),
    .binop (.vector .and) w6 (.val w5.i w5.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) w7 (.val w6.i w6.h) (.val k19.i k19.h),
    .binop (.shufflevector #v[some 2, some 10]) w8 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 3, some 11]) w9 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 4, some 12]) w10 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector .and) w11 (.val w1.i w1.h) (.val m40.i m40.h),
    .binop (.vector (.add { nsw := true, nuw := true })) w12 (.val w11.i w11.h) (.val b20.i b20.h),
    .binop (.vector .and) w13 (.val w7.i w7.h) (.val m43.i m43.h),
    .binop (.vector (.ashr false)) w14 (.val w5.i w5.h) (.val s43.i s43.h),
    .binop (.shufflevector #v[some 1, some 9]) w15 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector (.add {})) w16 (.val w14.i w14.h) (.val w15.i w15.h),
    .binop (.vector .and) w17 (.val w16.i w16.h) (.val m43.i m43.h),
    .binop (.vector (.lshr false)) w18 (.val w7.i w7.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) w19 (.val w17.i w17.h) (.val w18.i w18.h),
    .binop (.vector (.ashr false)) w20 (.val w16.i w16.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) w21 (.val w20.i w20.h) (.val w8.i w8.h),
    .binop (.vector .and) w22 (.val w21.i w21.h) (.val m43.i m43.h),
    .binop (.vector (.lshr false)) w23 (.val w19.i w19.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) w24 (.val w22.i w22.h) (.val w23.i w23.h),
    .binop (.vector (.ashr false)) w25 (.val w21.i w21.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) w26 (.val w25.i w25.h) (.val w9.i w9.h),
    .binop (.vector .and) w27 (.val w26.i w26.h) (.val m43.i m43.h),
    .binop (.vector (.lshr false)) w28 (.val w24.i w24.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) w29 (.val w27.i w27.h) (.val w28.i w28.h),
    .binop (.vector (.ashr false)) w30 (.val w26.i w26.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) w31 (.val w30.i w30.h) (.val w10.i w10.h),
    .binop (.vector .and) w32 (.val w31.i w31.h) (.val m43.i m43.h),
    .binop (.vector (.lshr false)) w33 (.val w29.i w29.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) w34 (.val w32.i w32.h) (.val w33.i w33.h),
    .binop (.vector (.ashr false)) w35 (.val w31.i w31.h) (.val s43.i s43.h),
    .binop (.vector (.lshr false)) w36 (.val w34.i w34.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) w37 (.val w12.i w12.h) (.val w35.i w35.h),
    .binop (.vector (.add { nsw := true, nuw := true })) w38 (.val w37.i w37.h) (.val w36.i w36.h),
    .binop (.vector (.icmp .ult)) w39 (.val w38.i w38.h) (.val two40.i two40.h),
    .ternop (.vector (.select (τ := .bv 64))) w40 (.val w39.i w39.h) (.val m19.i m19.h)
      (.val zero.i zero.h),
    .binop (.vector (.add { nsw := true })) w41 (.val w40.i w40.h) (.val w13.i w13.h),
    .binop (.vector .and) w42 (.val w19.i w19.h) (.val m43.i m43.h),
    .binop (.vector .and) w43 (.val w24.i w24.h) (.val m43.i m43.h),
    .binop (.vector .and) w44 (.val w29.i w29.h) (.val m43.i m43.h),
    .binop (.vector .and) w45 (.val w34.i w34.h) (.val m43.i m43.h),
    .binop (.vector .and) w46 (.val w38.i w38.h) (.val m40.i m40.h),
    .binop (.vector (.ashr false)) w47 (.val w41.i w41.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) w48 (.val w47.i w47.h) (.val w42.i w42.h),
    .binop (.vector (.ashr false)) w49 (.val w48.i w48.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) w50 (.val w49.i w49.h) (.val w43.i w43.h),
    .binop (.vector (.ashr false)) w51 (.val w50.i w50.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) w52 (.val w51.i w51.h) (.val w44.i w44.h),
    .binop (.vector (.ashr false)) w53 (.val w52.i w52.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) w54 (.val w53.i w53.h) (.val w45.i w45.h),
    .binop (.vector (.ashr false)) w55 (.val w54.i w54.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) w56 (.val w55.i w55.h) (.val w46.i w46.h),
    .binop (.vector (.or false)) w57 (.val w48.i w48.h) (.val w41.i w41.h),
    .binop (.vector (.or false)) w58 (.val w57.i w57.h) (.val w50.i w50.h),
    .binop (.vector (.or false)) w59 (.val w58.i w58.h) (.val w52.i w52.h),
    .binop (.vector (.or false)) w60 (.val w59.i w59.h) (.val w54.i w54.h),
    .binop (.vector .and) w61 (.val w60.i w60.h) (.val m43.i m43.h),
    .binop (.vector (.or false)) w62 (.val w61.i w61.h) (.val w56.i w56.h),
    .binop (.vector (.icmp .ne)) w63 (.val w62.i w62.h) (.val zero.i zero.h),
    .unop (.vector (.trunc {})) w64 (.val w41.i w41.h),
    .binop (.vector .and) w65 (.val w64.i w64.h) (.val one.i one.h),
    .binop (.vector (.icmp .eq)) w66 (.val w65.i w65.h) (.val x0v.i x0v.h)]

-- 67 steps over two lanes, over 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- Where the body at `pos` is `diag2Run`, `a b` hold `A B`, `x0v` holds `X0` and the others the
constants: running on from `pos` then `g` gives `K` if it does from `pos + 67` with `nzBit` of `A`
and `B` in `w63`, and whether `parLimbs` of each is its `X0` lane in `w66`, whatever the
intermediates hold. -/
theorem runBodyFrom_diag2Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {a b : Dst Γ V} {nb s40 k19 m43 m40 b20 s43 two40 m19 zero w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10
        w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32 w33
        w34 w35 w36 w37 w38 w40 w41 w42 w43 w44 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54 w55 w56 w57
        w58 w59 w60 w61 w62 : Dst Γ V2} {one x0v w64 w65 : Dst Γ (.vec 2 32)} {w39 w63 w66 : Dst Γ
        B2} {rest : List (Instr Γ)} {A B : Wwl} {X0 : Vector (BitVec 32) 2}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = diag2Run a b nb s40 k19 m43 m40 b20 s43 two40 m19 zero w0 w1 w2 w3
        w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27
        w28 w29 w30 w31 w32 w33 w34 w35 w36 w37 w38 w40 w41 w42 w43 w44 w45 w46 w47 w48 w49 w50 w51
        w52 w53 w54 w55 w56 w57 w58 w59 w60 w61 w62 one x0v w64 w65 w39 w63 w66 ++ rest)
    (hR : E ⊨ [a := A, b := B, x0v := X0])
    (hC : Nz2Consts E nb m40 s40 k19 b20 s43 m43 two40 m19 zero) (hone : E ⊨ [one :=
        Vector.replicate 2 1#32])
    (hd : [a.i, b.i, nb.i, s40.i, k19.i, m43.i, m40.i, b20.i, s43.i, two40.i, m19.i, zero.i, one.i,
        x0v.i, w0.i, w1.i, w2.i, w3.i, w4.i, w5.i, w6.i, w7.i, w8.i, w9.i, w10.i, w11.i, w12.i,
        w13.i, w14.i, w15.i, w16.i, w17.i, w18.i, w19.i, w20.i, w21.i, w22.i, w23.i, w24.i, w25.i,
        w26.i, w27.i, w28.i, w29.i, w30.i, w31.i, w32.i, w33.i, w34.i, w35.i, w36.i, w37.i, w38.i,
        w39.i, w40.i, w41.i, w42.i, w43.i, w44.i, w45.i, w46.i, w47.i, w48.i, w49.i, w50.i, w51.i,
        w52.i, w53.i, w54.i, w55.i, w56.i, w57.i, w58.i, w59.i, w60.i, w61.i, w62.i, w63.i, w64.i,
        w65.i].Nodup)
    (hK :
      ∀ (vw0 vw1 vw2 vw3 vw4 vw5 vw6 vw7 vw8 vw9 vw10 vw11 vw12 vw13 vw14 vw15 vw16 vw17 vw18 vw19
          vw20 vw21 vw22 vw23 vw24 vw25 vw26 vw27 vw28 vw29 vw30 vw31 vw32 vw33 vw34 vw35 vw36 vw37
          vw38 : ⟦V2⟧) (vw39 : ⟦B2⟧) (vw40 vw41 vw42 vw43 vw44 vw45 vw46 vw47 vw48 vw49 vw50 vw51
          vw52 vw53 vw54 vw55 vw56 vw57 vw58 vw59 vw60 vw61 vw62 : ⟦V2⟧) (vw64 vw65 : ⟦(.vec 2
          32)⟧),
        (blk.runBodyFrom E[w0 := vw0, w1 := vw1, w2 := vw2, w3 := vw3, w4 := vw4, w5 := vw5, w6 :=
            vw6, w7 := vw7, w8 := vw8, w9 := vw9, w10 := vw10, w11 := vw11, w12 := vw12, w13 :=
            vw13, w14 := vw14, w15 := vw15, w16 := vw16, w17 := vw17, w18 := vw18, w19 := vw19, w20
            := vw20, w21 := vw21, w22 := vw22, w23 := vw23, w24 := vw24, w25 := vw25, w26 := vw26,
            w27 := vw27, w28 := vw28, w29 := vw29, w30 := vw30, w31 := vw31, w32 := vw32, w33 :=
            vw33, w34 := vw34, w35 := vw35, w36 := vw36, w37 := vw37, w38 := vw38, w39 := vw39, w40
            := vw40, w41 := vw41, w42 := vw42, w43 := vw43, w44 := vw44, w45 := vw45, w46 := vw46,
            w47 := vw47, w48 := vw48, w49 := vw49, w50 := vw50, w51 := vw51, w52 := vw52, w53 :=
            vw53, w54 := vw54, w55 := vw55, w56 := vw56, w57 := vw57, w58 := vw58, w59 := vw59, w60
            := vw60, w61 := vw61, w62 := vw62, w63 := Ty.wrap #v[nzBit A, nzBit B], w64 := vw64,
            w65 := vw65, w66 := Ty.wrap #v[BitVec.ofBool (parLimbs A[0] A[1] A[2] A[3] A[4] A[5] ==
            X0[0]),
                  BitVec.ofBool (parLimbs B[0] B[1] B[2] B[3] B[4] B[5] == X0[1])]] (pos + 67) S
                      >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [diag2Run] at hbody
  nz_step
  nz_step_with vt5
  nz_step
  nz_step
  nz_step
  nz_step_with vt0
  nz_step
  nz_step_with ve0
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt1
  nz_step
  nz_step
  nz_step_with ve1
  nz_step
  nz_step_with vt2
  nz_step
  nz_step
  nz_step_with ve2
  nz_step
  nz_step_with vt3
  nz_step
  nz_step
  nz_step_with ve3
  nz_step
  nz_step_with vt4
  nz_step
  nz_step
  nz_step_with ve4
  nz_step
  nz_step
  nz_step
  nz_step_with vv5
  nz_step
  nz_step
  nz_step_with vr0
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vr1
  nz_step
  nz_step_with vr2
  nz_step
  nz_step_with vr3
  nz_step
  nz_step_with vr4
  nz_step
  nz_step_with vr5
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with wnz
  nz_step
  nz_step
  nz_step_with weq
  have e : wnz = #v[nzBit A, nzBit B] := by
    rw [← nzLimbs_eq, ← nzLimbs_eq]
    subst_vars
    apply vec_ext_fin
    intro i
    fin_cases i <;> rfl
  have e' :
      weq =
        #v[BitVec.ofBool (parLimbs A[0] A[1] A[2] A[3] A[4] A[5] == X0[0]),
          BitVec.ofBool (parLimbs B[0] B[1] B[2] B[3] B[4] B[5] == X0[1])] := by
    subst_vars
    apply vec_ext_fin
    intro i
    fin_cases i <;> rfl
  rw [hE, e, e']
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

end

end MLIR.Firedancer.Lane
