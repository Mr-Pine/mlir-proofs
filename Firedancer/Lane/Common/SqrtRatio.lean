module

public import Firedancer.Avx512.fd_f25519_eq
public import Firedancer.Lane.Common.Decode
public import Firedancer.Lane.fd_ed25519_lane_bcast_fe
public import Firedancer.Math.Avx512.F25519
public import MLIR.Run.Tactic
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide

/-! `fd_f25519_sqrt_ratio`'s field helpers (`neg`, `if`, `sgn`, `abs`), and the runs the other
patterns do not cover: `fd_f25519_eq` inlined, the 6-lane loads of operands only `fd_r43x6_mul`
broadcasts, the selects of `if` and `abs`, and `sgn`'s reduction. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

namespace SqrtRatio

/-- `fd_f25519_eq( a, b )` as seventeen instructions: `a - b + negP` in `d`, the signed fold through
`lo hi c t u s1 s2` into `n` (`fd_f25519_sub`), then `n`'s lane tests against `0` (`zero`) and `p`
(`pr`), each packed to a byte (`m0 mp`) and tested `== 0` (`zb`), or-ed by a select (`tru`). -/
def eqRun (a b p d0 d mask shifts bias z o m18 lo hi c t u s1 s2 n zero pr : Dst Γ V)
    (e0 ep : Dst Γ (.vec 8 1)) (m0 mp zb : Dst Γ (.bv 8)) (z0 zp tru r : Dst Γ (.bv 1)) :
    List (Instr Γ) :=
  [.binop (.vector (.sub {})) d0 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector (.add {})) d (.val d0.i d0.h) (.val p.i p.h),
    .binop (.vector .and) lo (.val d.i d.h) (.val mask.i mask.h),
    .binop (.vector (.ashr false)) hi (.val d.i d.h) (.val shifts.i shifts.h),
    .binop (.shufflevector negRotMask) c (.val hi.i hi.h) (.val z.i z.h),
    .binop (.vector (.mul {})) t (.val c.i c.h) (.val o.i o.h),
    .binop (.vector .and) u (.val t.i t.h) (.val m18.i m18.h),
    .binop (.vector (.add { nsw := true, nuw := true })) s1 (.val lo.i lo.h) (.val bias.i bias.h),
    .binop (.vector (.add {})) s2 (.val s1.i s1.h) (.val c.i c.h),
    .binop (.vector (.add {})) n (.val s2.i s2.h) (.val u.i u.h),
    .binop (.vector (.icmp .ne)) e0 (.val n.i n.h) (.val zero.i zero.h),
    .unop (.bitcast (t := .vec 8 1) (t' := .bv 8) rfl) m0 (.val e0.i e0.h),
    .binop (.icmp .eq) z0 (.val m0.i m0.h) (.val zb.i zb.h),
    .binop (.vector (.icmp .ne)) ep (.val n.i n.h) (.val pr.i pr.h),
    .unop (.bitcast (t := .vec 8 1) (t' := .bv 8) rfl) mp (.val ep.i ep.h),
    .binop (.icmp .eq) zp (.val mp.i mp.h) (.val zb.i zb.h),
    .ternop (.select (τ := .bv 1)) r (.val z0.i z0.h) (.val tru.i tru.h) (.val zp.i zp.h)]


end SqrtRatio

namespace fd_f25519_sqrt_ratio

/-- `fd_f25519_sqrtm1`, `√-1`'s limbs. -/
def sqrtm1 : Wwl :=
  #v[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]

/-- `fd_f25519_neg( r, a )`: `fd_r43x6_fold_signed( fd_r43x6_neg_fast( a ) )`. -/
def neg (a : Wwl) : Wwl :=
  fd_r43x6_fold_signed (fd_r43x6_neg_fast a)

/-- `fd_f25519_if( r, cond, a0, a1 )`: `cond ? a0 : a1`. -/
def ifc (cond : BitVec 32) (a0 a1 : Wwl) : Wwl :=
  if cond = 0 then a1 else a0

/-- `fd_f25519_sgn( a )`: `buf[0] & 1` of `fd_f25519_tobytes( buf, a )`. -/
def sgn (a : Wwl) : BitVec 32 :=
  ((tobytes a).setWidth 8 &&& 1).setWidth 32

/-- `fd_f25519_abs( r, a )`: `fd_f25519_if( r, fd_f25519_sgn( a ), -a, a )`. -/
def abs (a : Wwl) : Wwl :=
  ifc (sgn a) (neg a) a

end fd_f25519_sqrt_ratio

namespace SqrtRatio

/-- `negFold`, `fd_r43x6_neg` as compiled, is `neg`. -/
theorem negFold_eq_neg (x : Wwl) : negFold x = fd_f25519_sqrt_ratio.neg x := by
  unfold negFold fd_f25519_sqrt_ratio.neg fd_r43x6_fold_signed fd_r43x6_approx_carry_propagate
    fd_r43x6_neg_fast fd_r43x6_p
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i
  all_goals try (exfalso; omega)
  all_goals
    simp only [R43x6.wwl_add_get, R43x6.wwl_sub_get, R43x6.wwl_and_get, R43x6.wwl_shl_get,
      R43x6.wwl_shr_vector_get, R43x6.wwl_select_get, wwl, Vector.getElem_ofFn,
      Vector.getElem_zipWith, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ, negP, foldMask, foldShifts, negBias, R43x6.wwl_zero_get,
      R43x6.getD_get, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT, Nat.reduceSub,
      Nat.reduceAdd, ite_true, ite_false, Nat.reduceEqDiff, Fin.getElem_fin, m43, m40]
    generalize x[0] = a0, x[1] = a1, x[2] = a2, x[3] = a3, x[4] = a4, x[5] = a5, x[6] = a6,
      x[7] = a7
    bv_decide

/-- A 6-lane load as an `fd_r43x6_t`, lanes 6 and 7 zero. -/
abbrev lanes6 (x : Vector (BitVec 64) 6) : Wwl :=
  #v[x[0], x[1], x[2], x[3], x[4], x[5], 0, 0]

/-- `fd_r43x6_mul` broadcasts only lanes `0 … 5` of its first operand. -/
theorem fd_r43x6_mul_congr_left {x x' : Wwl} (y : Wwl) (h : ∀ k (hk : k < 6), x[k] = x'[k]) :
    fd_r43x6_mul x y = fd_r43x6_mul x' y := by
  unfold fd_r43x6_mul fd_r43x6_mul_fast.spec
  rw [h 0 (by decide), h 1 (by decide), h 2 (by decide), h 3 (by decide), h 4 (by decide),
    h 5 (by decide)]

/-- A 6-lane load's lanes are the 8-lane load's. -/
theorem lanes6_readAt (m : MemoryState) (p : Pointer) (k : Nat) (hk : k < 6) :
    (lanes6 (Vector.ofFn fun i => Ty.extractVecElem 6 64 i (m.readAt p 384)))[k] =
      (m.readVec p)[k] := by
  rw [MemoryState.readAt_of_readAt_le (show 384 ≤ 512 by decide) rfl]
  simp only [MemoryState.readVec, Vector.getElem_ofFn, Ty.extractVecElem_eq]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rcases k with _ | _ | _ | _ | _ | _ | k
  all_goals first | omega | simp [hi]
  all_goals omega

/-- A 6-lane load of a stored vector: its lanes. -/
theorem lanes6_packLanes (w : Wwl) (k : Nat) (hk : k < 6) :
    (lanes6 (Vector.ofFn fun i => Ty.extractVecElem 6 64 i
      (BitVec.setWidth 384 (BitVec.packLanes w))))[k] = w[k] := by
  have e := Ty.extractVecElem_packLanes (xs := w) (i := ⟨k, by omega⟩)
  simp only [Ty.extractVecElem_eq] at e ⊢
  rw [show w[k] = w[(⟨k, by omega⟩ : Fin 8)] from rfl, ← e]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rcases k with _ | _ | _ | _ | _ | _ | k
  all_goals first | omega | simp [hi]
  all_goals omega

/-- `fd_f25519_if`'s select as compiled: the flags' bits, or-ed, inverted and spread to a lane
mask, pick `x` where clear. -/
theorem ifc_compiled (h : 8 = 1 * 8) {ca cb : BitVec 32} (ha : ca = 0 ∨ ca = 1)
    (hb : cb = 0 ∨ cb = 1) (x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        if
            Ty.extractVecElem 8 1 i
                (BitVec.cast h
                  ((BitVec.signExtend 8 (ca.setWidth 1) ||| BitVec.signExtend 8 (cb.setWidth 1)) ^^^
                    255#8)) =
              1#1 then
          x[(i : Nat)]
        else y[(i : Nat)]) =
      fd_f25519_sqrt_ratio.ifc (ca ||| cb) y x := by
  rcases ha with rfl | rfl <;> rcases hb with rfl | rfl <;> ext i hi : 1 <;>
    rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
    first | omega | simp [fd_f25519_sqrt_ratio.ifc, Ty.extractVecElem_eq]

/-- `fd_f25519_abs`'s select as compiled: `(b & 1) - 1` spread to a lane mask picks `x` where
set. -/
theorem abs_compiled (h : 8 = 1 * 8) (b : BitVec 8) (x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        if (Vector.ofFn fun j : Fin 8 =>
              Ty.extractVecElem 8 1 j (BitVec.cast h ((b &&& 1#8) + 255#8)))[(i : Nat)] = 1#1 then
          x[(i : Nat)]
        else y[(i : Nat)]) =
      fd_f25519_sqrt_ratio.ifc ((b &&& 1#8).setWidth 32) y x := by
  have hb : b &&& 1#8 = 0#8 ∨ b &&& 1#8 = 1#8 := by bv_decide
  rcases hb with e | e <;> rw [e] <;> ext i hi : 1 <;>
    rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
    first | omega | simp [fd_f25519_sqrt_ratio.ifc, Ty.extractVecElem_eq]

/-- The return `correct | flipped`, as compiled from the flags' bits. -/
theorem or_compiled {ca cb : BitVec 32} (ha : ca = 0 ∨ ca = 1) (hb : cb = 0 ∨ cb = 1) :
    BitVec.setWidth 32 (ca.setWidth 1 ||| cb.setWidth 1) = ca ||| cb := by
  rcases ha with rfl | rfl <;> rcases hb with rfl | rfl <;> decide

/-- `fd_f25519_eq.spec` is `0` or `1`. -/
theorem eq_spec_01 (a b : Wwl) : fd_f25519_eq.spec a b = 0 ∨ fd_f25519_eq.spec a b = 1 := by
  simp only [fd_f25519_eq.spec, fd_f25519_is_zero.spec]
  split
  · exact .inr rfl
  · exact .inl rfl

/-- `fd_f25519_sgn`'s byte as compiled: limb 0 of `fd_r43x6_mod`, limb 1 shifted above it. -/
theorem sgn_compiled {a : Wwl} {r0 r1 : BitVec 64}
    (hm : (r43x6Mod (extractLimbs a)).y0 = r0 &&& m43) :
    (BitVec.extractLsb' 0 8 ((r1 &&& m43) <<< 43 ||| r0 &&& m43 ||| (r1 &&& m43) <<< 43) &&& 1#8) =
      (tobytes a).setWidth 8 &&& 1 := by
  unfold tobytes r43x6Pack
  rw [hm]
  generalize (r43x6Mod (extractLimbs a)).y1 = b1, (r43x6Mod (extractLimbs a)).y2 = b2,
    (r43x6Mod (extractLimbs a)).y3 = b3, (r43x6Mod (extractLimbs a)).y4 = b4,
    (r43x6Mod (extractLimbs a)).y5 = b5
  simp only [m43]
  bv_decide

/-- `fd_r43x6_mod`'s limb 0 as compiled, from the extracted limbs `y0 … y5`. -/
theorem mod_y0_compiled
    {y0 y1 y2 y3 y4 y5 t5 u0 u1 u2 u3 v0 v1 v2 v3 v4 w5 r0 : BitVec 64}
    (ht5 : t5 = y4.sshiftRight 43 + 18446744073709551615#64 + (y5 &&& 1099511627775#64))
    (hu0 : u0 = (t5.sshiftRight 40 + y5.sshiftRight 40) * 19#64 + (y0 &&& 8796093022207#64))
    (hu1 : u1 = (y1 &&& 8796093022207#64) + y0.sshiftRight 43 + u0.sshiftRight 43)
    (hu2 : u2 = (y2 &&& 8796093022207#64) + y1.sshiftRight 43 + u1.sshiftRight 43)
    (hu3 : u3 = (y3 &&& 8796093022207#64) + y2.sshiftRight 43 + u2.sshiftRight 43)
    (hv0 : v0 = (u0 &&& 8796093022207#64) + 19#64)
    (hv1 : v1 = (u1 &&& 8796093022207#64) + v0 >>> 43)
    (hv2 : v2 = (u2 &&& 8796093022207#64) + v1 >>> 43)
    (hv3 : v3 = (u3 &&& 8796093022207#64) + v2 >>> 43)
    (hv4 :
      v4 =
        ((y4 &&& 8796093022207#64) + y3.sshiftRight 43 + u3.sshiftRight 43 &&& 8796093022207#64) +
          v3 >>> 43)
    (hw5 :
      w5 =
        (t5 &&& 1099511627775#64) + 1#64 +
          ((y4 &&& 8796093022207#64) + y3.sshiftRight 43 + u3.sshiftRight 43).sshiftRight 43 +
          v4 >>> 43)
    (hr0 :
      r0 =
        (if BitVec.ofBool (w5.ult 1099511627776#64) = 1#1 then 18446744073709551597#64 else 0#64) +
          (v0 &&& 8796093022207#64)) :
    (r43x6Mod ⟨y0, y1, y2, y3, y4, y5⟩).y0 = r0 &&& 8796093022207#64 := by
  subst_vars
  simp only [r43x6Mod, modNearlyReducedLimbs, biasedCarryPropagateLimbs, approxCarryPropagateLimbs,
    carryLimbs, carrySums, m43, m40]
  bv_decide

/-- Bit `i` of eight packed one-bit lanes: lane `i`. -/
theorem getLsbD_packLanes_bv1' (v : Vector (BitVec 1) 8) (i : Nat) (hi : i < 8) :
    (BitVec.packLanes v).getLsbD i = v[i].getLsbD 0 := by
  have h := congrArg (·.getLsbD 0) (BitVec.extractLsb'_packLanes v i (by omega))
  simpa using h

/-- Eight packed lane tests are all clear exactly when no lane fails. -/
theorem packLanes_ofFn_eq_zero' (f : Fin 8 → Bool) :
    BitVec.packLanes (Vector.ofFn fun i => BitVec.ofBool (f i)) = 0#8 ↔ ∀ i, f i = false := by
  constructor
  · intro h i
    have := getLsbD_packLanes_bv1' (Vector.ofFn fun i => BitVec.ofBool (f i)) i.1 i.2
    rw [h] at this
    simp only [BitVec.getLsbD_zero, Fin.eta, Vector.getElem_ofFn, BitVec.getLsbD_ofBool] at this
    simpa using this.symm
  · intro h
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    rw [getLsbD_packLanes_bv1' _ i hi]
    simp [h ⟨i, hi⟩]

/-- `fd_f25519_eq`'s compiled lane tests: the packed lanes `x ≠ f` are `0` exactly when every
lane agrees. -/
theorem packLanes_ne_eq_zero (x : Wwl) (f : Fin 8 → BitVec 64) (h : 1 * 8 = 8) :
    (BitVec.cast h
          (BitVec.packLanes (we := 1) (n := 8)
            (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (x[(i : Nat)] != f i))) ==
        0#8) =
      decide (∀ i : Fin 8, x[(i : Nat)] = f i) := by
  have := packLanes_ofFn_eq_zero' fun i : Fin 8 => x[(i : Nat)] != f i
  simp only [bne_eq_false_iff_eq] at this
  rw [Bool.eq_iff_iff, beq_iff_eq, decide_eq_true_iff, ← this]
  exact ⟨fun e => by simpa using congrArg (BitVec.cast h.symm) e, fun e => by rw [e]; rfl⟩

/-- `fd_f25519_sub` as `eqRun` compiles it: `d = a - b + negP`, its low bits plus the bias, the
carries rotated up a lane, and lane 0's `18 ×` lane 5's. -/
def subFold (a b : Wwl) : Wwl :=
  Vector.ofFn fun i =>
    (a[(i : Nat)] - b[(i : Nat)] + negP[(i : Nat)] &&& foldMask[(i : Nat)]) + negBias[(i : Nat)] +
        [(a[5] - b[5] + negP[5]).sshiftRight foldShifts[5].toNat,
          (a[0] - b[0] + negP[0]).sshiftRight foldShifts[0].toNat,
          (a[1] - b[1] + negP[1]).sshiftRight foldShifts[1].toNat,
          (a[2] - b[2] + negP[2]).sshiftRight foldShifts[2].toNat,
          (a[3] - b[3] + negP[3]).sshiftRight foldShifts[3].toNat,
          (a[4] - b[4] + negP[4]).sshiftRight foldShifts[4].toNat, 0#64, 0#64][(i : Nat)] +
      ([(a[5] - b[5] + negP[5]).sshiftRight foldShifts[5].toNat,
          (a[0] - b[0] + negP[0]).sshiftRight foldShifts[0].toNat,
          (a[1] - b[1] + negP[1]).sshiftRight foldShifts[1].toNat,
          (a[2] - b[2] + negP[2]).sshiftRight foldShifts[2].toNat,
          (a[3] - b[3] + negP[3]).sshiftRight foldShifts[3].toNat,
          (a[4] - b[4] + negP[4]).sshiftRight foldShifts[4].toNat, 0#64, 0#64][(i : Nat)] *
          neg18[(i : Nat)] &&&
        negSel[(i : Nat)])

/-- `subFold` is `fd_f25519_sub.spec`. -/
theorem subFold_eq (a b : Wwl) : subFold a b = fd_f25519_sub.spec a b := by
  unfold subFold fd_f25519_sub.spec
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i
  all_goals try (exfalso; omega)
  all_goals
    simp only [Vector.getElem_ofFn, Vector.getElem_zipWith, Vector.getElem_mk,
      List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ, negP, foldMask,
      foldShifts, negBias, neg18, negSel, Vector.getElem_replicate]
    generalize a[0] = a0, a[1] = a1, a[2] = a2, a[3] = a3, a[4] = a4, a[5] = a5, a[6] = a6,
      a[7] = a7, b[0] = b0, b[1] = b1, b[2] = b2, b[3] = b3, b[4] = b4, b[5] = b5, b[6] = b6,
      b[7] = b7
    bv_decide

/-- `eqRun`'s tests of `x` against `0` and `p`, or-ed: `fd_f25519_is_zero`'s bit. -/
theorem eqBits (x : Wwl) (h h' : 1 * 8 = 8) :
    (if
          BitVec.ofBool
              (BitVec.cast h
                  (BitVec.packLanes (we := 1) (n := 8)
                    (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (x[(i : Nat)] != 0#64))) ==
                0#8) =
            1#1 then
        1#1
      else
        BitVec.ofBool
          (BitVec.cast h'
              (BitVec.packLanes (we := 1) (n := 8)
                (Vector.ofFn fun i : Fin 8 =>
                  BitVec.ofBool (x[(i : Nat)] != fd_r43x6_p[(i : Nat)]))) ==
            0#8)) =
      (if x = wwl_zero ∨ x = fd_r43x6_p then (1 : BitVec 32) else 0).setWidth 1 := by
  rw [packLanes_ne_eq_zero x (fun _ => 0#64), packLanes_ne_eq_zero x fun i => fd_r43x6_p[(i : Nat)]]
  have h0 : (∀ i : Fin 8, x[(i : Nat)] = 0#64) ↔ x = wwl_zero :=
    ⟨fun h => vec_ext_fin fun i => by simpa using h i, fun h i => by simp [h]⟩
  have hp : (∀ i : Fin 8, x[(i : Nat)] = fd_r43x6_p[(i : Nat)]) ↔ x = fd_r43x6_p :=
    ⟨fun h => vec_ext_fin h, fun h i => by rw [h]⟩
  by_cases h0' : x = wwl_zero <;> by_cases hp' : x = fd_r43x6_p <;> simp [h0, hp, h0', hp']

/-- `fd_f25519_eq.spec` as the tests against `0` and `p`. -/
theorem fd_f25519_eq.spec_eq_ite (a b : Wwl) :
    fd_f25519_eq.spec a b =
      if fd_f25519_sub.spec a b = wwl_zero ∨ fd_f25519_sub.spec a b = fd_r43x6_p then 1 else 0 := by
  simp only [fd_f25519_eq.spec, fd_f25519_is_zero.spec, R43x6.wwl_eq_mask_iff, fd_r43x6_zero]

/-- `negBias_no_overflow` at a `Fin 8` lane. -/
theorem negBias_no_overflow' (a : BitVec 64) (i : Fin 8) :
    (a &&& foldMask[(i : Nat)]).saddOverflow negBias[(i : Nat)] = false ∧
      (a &&& foldMask[(i : Nat)]).uaddOverflow negBias[(i : Nat)] = false :=
  negBias_no_overflow a i i.2

/-- Where the body at `pos` is `eqRun`, `a b` hold `A B` and the others the constants: running on
from `pos` then `g` gives `K` if it does from `pos + 17` with `fd_f25519_eq.spec A B`'s bit in `r`,
whatever the intermediates hold. -/
theorem runBodyFrom_eqRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {a b p d0 d mask shifts bias z o m18 lo hi c t u s1 s2 n zero pr : Dst Γ V}
    {e0 ep : Dst Γ (.vec 8 1)} {m0 mp zb : Dst Γ (.bv 8)} {z0 zp tru r : Dst Γ (.bv 1)}
    {rest : List (Instr Γ)} {A B : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        eqRun a b p d0 d mask shifts bias z o m18 lo hi c t u s1 s2 n zero pr e0 ep m0 mp zb z0 zp
            tru r ++
          rest)
    (hR :
      E ⊨ [a := A, b := B, p := negP, mask := foldMask, shifts := foldShifts, bias := negBias, z :=
        zeroLo, o := neg18, m18 := negSel, zero := Vector.replicate 8 0#64, pr := fd_r43x6_p, zb :=
        0#8, tru := 1#1])
    (hd :
      [a.i, b.i, p.i, d0.i, d.i, mask.i, shifts.i, bias.i, z.i, o.i, m18.i, lo.i, hi.i, c.i, t.i,
          u.i, s1.i, s2.i, n.i, zero.i, pr.i].Nodup)
    (hd' : [m0.i, mp.i, zb.i].Nodup) (hd'' : [z0.i, zp.i, tru.i].Nodup)
    (hK :
      ∀ (vd0 vd vlo vhi vc vt vu vs1 vs2 vn : ⟦V⟧) (ve0 vep : ⟦.vec 8 1⟧) (vm0 vmp : ⟦.bv 8⟧)
        (vz0 vzp : ⟦.bv 1⟧),
        (blk.runBodyFrom
              E[d0 := vd0, d := vd, lo := vlo, hi := vhi, c := vc, t := vt, u := vu, s1 := vs1,
                s2 := vs2, n := vn, e0 := ve0, m0 := vm0, z0 := vz0, ep := vep, mp := vmp, zp :=
                vzp, r := .value ((fd_f25519_eq.spec A B).setWidth 1)]
              (pos + 17) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [eqRun] at hbody
  step_pure with transparent vd0
  step_pure with transparent vd
  step_pure with transparent vlo
  step_pure [foldShifts_lt] with transparent vhi
  step_pure with transparent vc
  step_pure with transparent vt
  step_pure with transparent vu
  step_pure [negBias_no_overflow'] with transparent vs1
  step_pure with transparent vs2
  step_pure with vn
  step_pure with ve0
  step_pure with vm0
  step_pure with vz0
  step_pure with vep
  step_pure with vmp
  step_pure with vzp
  step_pure with vr
  have en : vn = fd_f25519_sub.spec A B := by
    rw [hvn]
    exact subFold_eq A B
  have e : vr = (fd_f25519_eq.spec A B).setWidth 1 := by
    rw [hvr, hvz0, hvzp, hvm0, hvmp, hve0, hvep, fd_f25519_eq.spec_eq_ite, ← en]
    exact eqBits vn _ _
  rw [hE, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

end SqrtRatio

end

end MLIR.Firedancer.Lane
