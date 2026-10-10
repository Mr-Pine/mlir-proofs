module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public meta import Lean.Elab.Tactic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! sha2's unrolled SHA-512 rounds (`sha512::soft::unroll::compress_block`) as instruction
templates, each with the lemma stepping it. -/

namespace MLIR.Agave

open _root_.Ed25519

@[expose] public section

/-- Rounds `0 … n - 1` from `H`, `Wf t` the schedule's word `t`. Irreducible: a failed match of
two counts must not unfold the rounds. -/
@[irreducible]
def rounds (Wf : Nat → BitVec 64) (n : Nat) (H : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  (List.range n).foldl (fun v t => Sha512.round v Sha512.K[t]! (Wf t)) H

theorem rounds_zero (Wf : Nat → BitVec 64) (H : Vector (BitVec 64) 8) : rounds Wf 0 H = H := by
  simp only [rounds, List.range_zero, List.foldl_nil]

theorem rounds_succ (Wf : Nat → BitVec 64) (n : Nat) (H : Vector (BitVec 64) 8) :
    rounds Wf (n + 1) H = Sha512.round (rounds Wf n H) Sha512.K[n]! (Wf n) := by
  simp only [rounds, List.range_succ, List.foldl_append, List.foldl_cons, List.foldl_nil]

/-! ## The code's forms of the round functions -/

/-- `Σ₀` as the code's `fshl`s compute it. -/
theorem sig0_code (x : BitVec 64) :
    BitVec.extractLsb' 64 64 ((x ++ x) <<< 36) ^^^ BitVec.extractLsb' 64 64 ((x ++ x) <<< 30) ^^^
        BitVec.extractLsb' 64 64 ((x ++ x) <<< 25) =
      Sha512.Sigma0 x := by
  simp only [Sha512.Sigma0]; bv_decide

/-- `Σ₁` as the code's `fshl`s compute it. -/
theorem sig1_code (x : BitVec 64) :
    BitVec.extractLsb' 64 64 ((x ++ x) <<< 50) ^^^ BitVec.extractLsb' 64 64 ((x ++ x) <<< 46) ^^^
        BitVec.extractLsb' 64 64 ((x ++ x) <<< 23) =
      Sha512.Sigma1 x := by
  simp only [Sha512.Sigma1]; bv_decide

/-- `Maj` as the code computes it. -/
theorem maj_code (a b c : BitVec 64) : a &&& (b ^^^ c) ^^^ b &&& c = Sha512.Maj a b c := by
  simp only [Sha512.Maj]; bv_decide

/-- `xor` with all ones. -/
theorem not_code (x : BitVec 64) : x ^^^ 18446744073709551615#64 = ~~~x := by bv_decide

/-- `Ch` from its two halves, disjoint, summed. -/
theorem ch_add (e f g : BitVec 64) : (g &&& ~~~e) + (e &&& f) = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide

/-- `σ₀` as the code computes it. -/
theorem ssig0_code (x : BitVec 64) :
    BitVec.extractLsb' 64 64 ((x ++ x) <<< 63) ^^^ BitVec.extractLsb' 64 64 ((x ++ x) <<< 56) ^^^
        x >>> 7 =
      Sha512.sigma0 x := by
  simp only [Sha512.sigma0]; bv_decide

/-- `σ₁` as the code computes it. -/
theorem ssig1_code (x : BitVec 64) :
    BitVec.extractLsb' 64 64 ((x ++ x) <<< 45) ^^^ BitVec.extractLsb' 64 64 ((x ++ x) <<< 3) ^^^
        x >>> 6 =
      Sha512.sigma1 x := by
  simp only [Sha512.sigma1]; bv_decide

/-- `Ch` from its two halves, disjoint, or-ed. -/
theorem ch_or (e f g : BitVec 64) : e &&& f ||| g &&& ~~~e = Sha512.Ch e f g := by
  simp only [Sha512.Ch]; bv_decide

/-- A round, `T1` and `T2 = Σ₀(a) + Maj(a, b, c)` summed as the code sums them. -/
theorem round_eq {a b c d e f g h k w T1 : BitVec 64}
    (hT : T1 = h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w) :
    Sha512.round #v[a, b, c, d, e, f, g, h] k w =
      #v[Sha512.Sigma0 a + Sha512.Maj a b c + T1, a, b, c, T1 + d, e, f, g] := by
  subst hT
  rw [show
      Sha512.Sigma0 a + Sha512.Maj a b c + (h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w) =
        h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w + (Sha512.Sigma0 a + Sha512.Maj a b c)
      by ac_rfl,
    show
      h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w + d =
        d + (h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w)
      by ac_rfl]
  rfl

/-- The last round added to the block's old state, summed as the code sums it. -/
theorem final_eq {a b c d e f g h k w T1 i0 i1 i2 i3 i4 i5 i6 i7 : BitVec 64}
    (hT : T1 = h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w) :
    #v[Sha512.Maj a b c + i0 + Sha512.Sigma0 a + T1, a + i1, b + i2, c + i3, d + i4 + T1, e + i5,
        f + i6, g + i7] =
      Vector.zipWith (· + ·) #v[i0, i1, i2, i3, i4, i5, i6, i7]
        (Sha512.round #v[a, b, c, d, e, f, g, h] k w) := by
  rw [round_eq hT]
  subst hT
  rw [show
      Sha512.Maj a b c + i0 + Sha512.Sigma0 a + (h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w) =
        i0 + (Sha512.Sigma0 a + Sha512.Maj a b c + (h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w))
      by ac_rfl,
    show
      d + i4 + (h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w) =
        i4 + ((h + Sha512.Sigma1 e + Sha512.Ch e f g + k + w) + d)
      by ac_rfl,
    BitVec.add_comm a, BitVec.add_comm b, BitVec.add_comm c, BitVec.add_comm e, BitVec.add_comm f,
    BitVec.add_comm g]
  simp only [Vector.mk_zipWith_mk, List.zipWith_toArray, List.zipWith_cons_cons,
    List.zipWith_nil_left]

/-! ## `T1`'s first sums, in the code's orders -/

/-- The order the code sums `w`, `h` and `K` in a round's `T1`: `whk` is `(w + h) + K`. -/
inductive Order
  | whk
  | hwk
  | kwh
  | wkh

/-- The first sum's operands and the second's other operand, in the order `o`. -/
def headRegs (o : Order) (w h kk : Dst Γ (.bv 64)) :
    Reg Γ (.bv 64) × Reg Γ (.bv 64) × Reg Γ (.bv 64) :=
  match o with
  | .whk => (.val w.i w.h, .val h.i h.h, .val kk.i kk.h)
  | .hwk => (.val h.i h.h, .val w.i w.h, .val kk.i kk.h)
  | .kwh => (.val kk.i kk.h, .val w.i w.h, .val h.i h.h)
  | .wkh => (.val w.i w.h, .val kk.i kk.h, .val h.i h.h)

/-- `T1`'s first two sums, in the order `o`, of `w`, `h` and the loaded `K` (`kk`). -/
def headRun (o : Order) (w h kk t0 t1 : Dst Γ (.bv 64)) : List (Instr Γ) :=
  [.binop (.add {}) t0 (headRegs o w h kk).1 (headRegs o w h kk).2.1,
    .binop (.add {}) t1 (.val t0.i t0.h) (headRegs o w h kk).2.2]

/-- `headRun o w h kk t0 t1`'s sum. -/
def headSum (o : Order) (w h k : BitVec 64) : BitVec 64 :=
  match o with
  | .whk => w + h + k
  | .hwk => h + w + k
  | .kwh => k + w + h
  | .wkh => w + k + h

theorem headSum_eq (o : Order) (w h k : BitVec 64) : headSum o w h k = w + h + k := by
  cases o <;> simp only [headSum] <;> ac_rfl

/-- Where the body at `pos` is `headRun o w h kk t0 t1`: `t1` gets `headSum o W Hh Kt`. -/
theorem runBodyFrom_headRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {o : Order}
    {w h kk t0 t1 : Dst Γ (.bv 64)} {rest : List (Instr Γ)} {W Hh Kt : BitVec 64} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = headRun o w h kk t0 t1 ++ rest)
    (hR : E ⊨ [w := W, h := Hh, kk := Kt]) (hkt : kk.i ≠ t0.i) (hht : h.i ≠ t0.i)
    (hK :
      ∀ v0 : ⟦.bv 64⟧,
        (blk.runBodyFrom E[t0 := v0, t1 := .value (headSum o W Hh Kt)] (pos + 2) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  revert hbody
  cases o <;> intro hbody <;> simp only [headRun, headRegs] at hbody
  all_goals
    step_pure
    step_pure
    rw [hE]
    exact hK _

/-! ## The rounds' templates -/

/-- Round 0, from the state: `Σ₁(e)` and the `Ch` halves, `T1 = ch₁ + h + ch₂ + Σ₁(e) + w + K`,
`T2 = Σ₀(a) + Maj(a, b, c)`, then round 1's `Σ₁(e')` and `Ch` halves. -/
def round0 (kp : Dst Γ .ptr) (w a b c d e f g h c36 c30 c25 c50 c46 c23 cm1 : Dst Γ (.bv 64))
    (q0 q1 x1 q2 s1 p1 n p2 kk t0 t1 t2 t3 t4 r0 r1 x0 r2 s0 ab y0 y1 bc mj u e' a' q0' q1' x1' q2'
      s1' p1' n' p2' : Dst Γ (.bv 64)) :
    List (Instr Γ) :=
  [.ternop .fshl q0 (.val e.i e.h) (.val e.i e.h) (.val c50.i c50.h),
    .ternop .fshl q1 (.val e.i e.h) (.val e.i e.h) (.val c46.i c46.h),
    .binop .xor x1 (.val q0.i q0.h) (.val q1.i q1.h),
    .ternop .fshl q2 (.val e.i e.h) (.val e.i e.h) (.val c23.i c23.h),
    .binop .xor s1 (.val x1.i x1.h) (.val q2.i q2.h), .binop .and p1 (.val e.i e.h) (.val f.i f.h),
    .binop .xor n (.val e.i e.h) (.val cm1.i cm1.h), .binop .and p2 (.val g.i g.h) (.val n.i n.h),
    .load kk (.val kp.i kp.h), .binop (.add {}) t0 (.val p1.i p1.h) (.val h.i h.h),
    .binop (.add {}) t1 (.val t0.i t0.h) (.val p2.i p2.h),
    .binop (.add {}) t2 (.val t1.i t1.h) (.val s1.i s1.h),
    .binop (.add {}) t3 (.val t2.i t2.h) (.val w.i w.h),
    .binop (.add {}) t4 (.val t3.i t3.h) (.val kk.i kk.h),
    .ternop .fshl r0 (.val a.i a.h) (.val a.i a.h) (.val c36.i c36.h),
    .ternop .fshl r1 (.val a.i a.h) (.val a.i a.h) (.val c30.i c30.h),
    .binop .xor x0 (.val r0.i r0.h) (.val r1.i r1.h),
    .ternop .fshl r2 (.val a.i a.h) (.val a.i a.h) (.val c25.i c25.h),
    .binop .xor s0 (.val x0.i x0.h) (.val r2.i r2.h), .binop .and ab (.val a.i a.h) (.val b.i b.h),
    .binop .xor y0 (.val b.i b.h) (.val c.i c.h), .binop .and y1 (.val a.i a.h) (.val y0.i y0.h),
    .binop .and bc (.val b.i b.h) (.val c.i c.h), .binop .xor mj (.val y1.i y1.h) (.val bc.i bc.h),
    .binop (.add {}) u (.val s0.i s0.h) (.val mj.i mj.h),
    .binop (.add {}) e' (.val t4.i t4.h) (.val d.i d.h),
    .binop (.add {}) a' (.val u.i u.h) (.val t4.i t4.h),
    .ternop .fshl q0' (.val e'.i e'.h) (.val e'.i e'.h) (.val c50.i c50.h),
    .ternop .fshl q1' (.val e'.i e'.h) (.val e'.i e'.h) (.val c46.i c46.h),
    .binop .xor x1' (.val q0'.i q0'.h) (.val q1'.i q1'.h),
    .ternop .fshl q2' (.val e'.i e'.h) (.val e'.i e'.h) (.val c23.i c23.h),
    .binop .xor s1' (.val x1'.i x1'.h) (.val q2'.i q2'.h),
    .binop .and p1' (.val e'.i e'.h) (.val e.i e.h),
    .binop .xor n' (.val e'.i e'.h) (.val cm1.i cm1.h),
    .binop .and p2' (.val f.i f.h) (.val n'.i n'.h)]

/-- Where the body at `pos` is `round0`: round `0` from the state `#v[A, …, Hh]`, then round 1's
`Σ₁(e')` and `Ch` halves. -/
theorem runBodyFrom_round0 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {kp : Dst Γ .ptr}
    {w a b c d e f g h c36 c30 c25 c50 c46 c23 cm1 : Dst Γ (.bv 64)}
    {q0 q1 x1 q2 s1 p1 n p2 kk t0 t1 t2 t3 t4 r0 r1 x0 r2 s0 ab y0 y1 bc mj u e' a' q0' q1' x1' q2'
      s1' p1' n' p2' : Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {KP : Pointer} {Wf : Nat → BitVec 64} {A B C D Ee F G Hh : BitVec 64}
    {S : GlobalState} {g' : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        round0 kp w a b c d e f g h c36 c30 c25 c50 c46 c23 cm1 q0 q1 x1 q2 s1 p1 n p2 kk t0 t1 t2
            t3 t4 r0 r1 x0 r2 s0 ab y0 y1 bc mj u e' a' q0' q1' x1' q2' s1' p1' n' p2' ++
          rest)
    (hR :
      E ⊨ [kp := KP, w := Wf 0, a := A, b := B, c := C, d := D, e := Ee, f := F, g := G, h := Hh,
        c36 := 36#64, c30 := 30#64, c25 := 25#64, c50 := 50#64, c46 := 46#64, c23 := 23#64, cm1 :=
        18446744073709551615#64])
    (hd :
      [w.i, a.i, b.i, c.i, d.i, e.i, f.i, g.i, h.i, c36.i, c30.i, c25.i, c50.i, c46.i, c23.i, cm1.i,
          q0.i, q1.i, x1.i, q2.i, s1.i, p1.i, n.i, p2.i, kk.i, t0.i, t1.i, t2.i, t3.i, t4.i, r0.i,
          r1.i, x0.i, r2.i, s0.i, ab.i, y0.i, y1.i, bc.i, mj.i, u.i, e'.i, a'.i, q0'.i, q1'.i,
          x1'.i, q2'.i, s1'.i, p1'.i, n'.i].Nodup)
    (hkf : Fits S.mem KP 64) (hk : S.mem.readAt KP 64 = Sha512.K[0]!)
    (hK :
      ∀ A' E' : BitVec 64,
        rounds Wf 1 #v[A, B, C, D, Ee, F, G, Hh] = #v[A', A, B, C, E', Ee, F, G] →
          ∀ vq0 vq1 vx1 vq2 vs1 vp1 vn vp2 vkk vt0 vt1 vt2 vt3 vt4 vr0 vr1 vx0 vr2 vs0 vy0 vy1 vbc
            vmj vu vq0' vq1' vx1' vq2' vn' : ⟦.bv 64⟧,
            (blk.runBodyFrom
                  E[q0 := vq0, q1 := vq1, x1 := vx1, q2 := vq2, s1 := vs1, p1 := vp1, n := vn, p2 :=
                    vp2, kk := vkk, t0 := vt0, t1 := vt1, t2 := vt2, t3 := vt3, t4 := vt4, r0 :=
                    vr0, r1 := vr1, x0 := vx0, r2 := vr2, s0 := vs0, ab := .value (A &&& B), y0 :=
                    vy0, y1 := vy1, bc := vbc, mj := vmj, u := vu, e' := .value E', a' := .value A',
                    q0' := vq0', q1' := vq1', x1' := vx1', q2' := vq2', s1' :=
                    .value (Sha512.Sigma1 E'), p1' := .value (E' &&& Ee), n' := vn', p2' :=
                    .value (F &&& ~~~E')]
                  (pos + 35) S >>=
                g') =
              K) :
    (blk.runBodyFrom E pos S >>= g') = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig1_code]
  step_pure
  step_pure [not_code]
  step_pure
  step_load
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig0_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [maj_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig1_code]
  step_pure
  step_pure [not_code]
  step_pure
  subst hS
  rw [hE]
  apply hK
  rw [rounds_succ, rounds_zero]
  exact
    round_eq
      (by
        rw [← ch_add]; ac_rfl)

/-- A round of rounds 1–14: `T1 = w + h + K + ch₂ + ch₁ + Σ₁(e)` (the first sums in the order
`o`), `T2 = Σ₀(a) + Maj(a, b, c)`, then the next round's `Σ₁(e')` and `Ch` halves. -/
def roundA (o : Order) (kp : Dst Γ .ptr)
    (w h p2 p1 s1 a b c bc d e f c36 c30 c25 c50 c46 c23 cm1 : Dst Γ (.bv 64))
    (kk t0 t1 t2 t3 t4 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' q0 q1 x1 q2 s1' p1' n' p2' :
      Dst Γ (.bv 64)) :
    List (Instr Γ) :=
  .load kk (.val kp.i kp.h) :: headRun o w h kk t0 t1 ++
    [.binop (.add {}) t2 (.val t1.i t1.h) (.val p2.i p2.h),
      .binop (.add {}) t3 (.val t2.i t2.h) (.val p1.i p1.h),
      .binop (.add {}) t4 (.val t3.i t3.h) (.val s1.i s1.h),
      .ternop .fshl r0 (.val a.i a.h) (.val a.i a.h) (.val c36.i c36.h),
      .ternop .fshl r1 (.val a.i a.h) (.val a.i a.h) (.val c30.i c30.h),
      .binop .xor x0 (.val r0.i r0.h) (.val r1.i r1.h),
      .ternop .fshl r2 (.val a.i a.h) (.val a.i a.h) (.val c25.i c25.h),
      .binop .xor s0 (.val x0.i x0.h) (.val r2.i r2.h),
      .binop .and ab (.val a.i a.h) (.val b.i b.h), .binop .xor y0 (.val b.i b.h) (.val c.i c.h),
      .binop .and y1 (.val a.i a.h) (.val y0.i y0.h),
      .binop .xor mj (.val y1.i y1.h) (.val bc.i bc.h),
      .binop (.add {}) u (.val s0.i s0.h) (.val mj.i mj.h),
      .binop (.add {}) e' (.val t4.i t4.h) (.val d.i d.h),
      .binop (.add {}) a' (.val u.i u.h) (.val t4.i t4.h),
      .ternop .fshl q0 (.val e'.i e'.h) (.val e'.i e'.h) (.val c50.i c50.h),
      .ternop .fshl q1 (.val e'.i e'.h) (.val e'.i e'.h) (.val c46.i c46.h),
      .binop .xor x1 (.val q0.i q0.h) (.val q1.i q1.h),
      .ternop .fshl q2 (.val e'.i e'.h) (.val e'.i e'.h) (.val c23.i c23.h),
      .binop .xor s1' (.val x1.i x1.h) (.val q2.i q2.h),
      .binop .and p1' (.val e'.i e'.h) (.val e.i e.h),
      .binop .xor n' (.val e'.i e'.h) (.val cm1.i cm1.h),
      .binop .and p2' (.val f.i f.h) (.val n'.i n'.h)]

/-- Where the body at `pos` is `roundA o`: round `t` from `rounds Wf t H`, then the next round's
`Σ₁(e')` and `Ch` halves. -/
theorem runBodyFrom_roundA {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {o : Order}
    {kp : Dst Γ .ptr} {w h p2 p1 s1 a b c bc d e f c36 c30 c25 c50 c46 c23 cm1 : Dst Γ (.bv 64)}
    {kk t0 t1 t2 t3 t4 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' q0 q1 x1 q2 s1' p1' n' p2' :
      Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {KP : Pointer} {Wf : Nat → BitVec 64} {t : Nat}
    {H : Vector (BitVec 64) 8} {A B C D Ee F G Hh : BitVec 64} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        roundA o kp w h p2 p1 s1 a b c bc d e f c36 c30 c25 c50 c46 c23 cm1 kk t0 t1 t2 t3 t4 r0 r1
            x0 r2 s0 ab y0 y1 mj u e' a' q0 q1 x1 q2 s1' p1' n' p2' ++
          rest)
    (hR :
      E ⊨ [kp := KP, w := Wf t, h := Hh, p2 := G &&& ~~~Ee, p1 := Ee &&& F, s1 := Sha512.Sigma1 Ee,
        a := A, b := B, c := C, bc := B &&& C, d := D, e := Ee, f := F, c36 := 36#64, c30 := 30#64,
        c25 := 25#64, c50 := 50#64, c46 := 46#64, c23 := 23#64, cm1 := 18446744073709551615#64])
    (hd :
      [w.i, h.i, p2.i, p1.i, s1.i, a.i, b.i, c.i, bc.i, d.i, e.i, f.i, c36.i, c30.i, c25.i, c50.i,
          c46.i, c23.i, cm1.i, kk.i, t0.i, t1.i, t2.i, t3.i, t4.i, r0.i, r1.i, x0.i, r2.i, s0.i,
          ab.i, y0.i, y1.i, mj.i, u.i, e'.i, a'.i, q0.i, q1.i, x1.i, q2.i, s1'.i, p1'.i,
          n'.i].Nodup)
    (hkf : Fits S.mem KP 64) (hk : S.mem.readAt KP 64 = Sha512.K[t]!)
    (hacc : rounds Wf t H = #v[A, B, C, D, Ee, F, G, Hh])
    (hK :
      ∀ A' E' : BitVec 64,
        rounds Wf (t + 1) H = #v[A', A, B, C, E', Ee, F, G] →
          ∀ vkk vt0 vt1 vt2 vt3 vt4 vr0 vr1 vx0 vr2 vs0 vy0 vy1 vmj vu vq0 vq1 vx1 vq2 vn' :
            ⟦.bv 64⟧,
            (blk.runBodyFrom
                  E[kk := vkk, t0 := vt0, t1 := vt1, t2 := vt2, t3 := vt3, t4 := vt4, r0 := vr0,
                    r1 := vr1, x0 := vx0, r2 := vr2, s0 := vs0, ab := .value (A &&& B), y0 := vy0,
                    y1 := vy1, mj := vmj, u := vu, e' := .value E', a' := .value A', q0 := vq0,
                    q1 := vq1, x1 := vx1, q2 := vq2, s1' := .value (Sha512.Sigma1 E'), p1' :=
                    .value (E' &&& Ee), n' := vn', p2' := .value (F &&& ~~~E')]
                  (pos + 26) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_load inline
  step_pattern using runBodyFrom_headRun
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig0_code]
  step_pure
  step_pure
  step_pure
  step_pure [maj_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig1_code]
  step_pure
  step_pure [not_code]
  step_pure
  subst hS
  rw [hE]
  apply hK
  rw [rounds_succ, hacc]
  exact
    round_eq
      (by
        rw [headSum_eq, ← ch_add]; ac_rfl)

/-- Round 15: as `roundA` (`kwh`), and `W₁₆ = σ₀(W₁) + W₀ + W₉ + σ₁(W₁₄)` in `wn`; round 16's
`Σ₁(e')` and `Ch(e', e, f)`. -/
def round15 (kp : Dst Γ .ptr)
    (w h p2 p1 s1 a b c bc d e f x15 x2 x16 x7 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1 :
      Dst Γ (.bv 64))
    (kk t0 t1 t2 t3 t4 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4 z1 o5 sg1 m0 m1 wn
      q0 q1 x1 q2 s1' p1' n' p2' ch' : Dst Γ (.bv 64)) :
    List (Instr Γ) :=
  [.load kk (.val kp.i kp.h), .binop (.add {}) t0 (.val kk.i kk.h) (.val w.i w.h),
    .binop (.add {}) t1 (.val t0.i t0.h) (.val h.i h.h),
    .binop (.add {}) t2 (.val t1.i t1.h) (.val p2.i p2.h),
    .binop (.add {}) t3 (.val t2.i t2.h) (.val p1.i p1.h),
    .binop (.add {}) t4 (.val t3.i t3.h) (.val s1.i s1.h),
    .ternop .fshl r0 (.val a.i a.h) (.val a.i a.h) (.val c36.i c36.h),
    .ternop .fshl r1 (.val a.i a.h) (.val a.i a.h) (.val c30.i c30.h),
    .binop .xor x0 (.val r0.i r0.h) (.val r1.i r1.h),
    .ternop .fshl r2 (.val a.i a.h) (.val a.i a.h) (.val c25.i c25.h),
    .binop .xor s0 (.val x0.i x0.h) (.val r2.i r2.h), .binop .and ab (.val a.i a.h) (.val b.i b.h),
    .binop .xor y0 (.val b.i b.h) (.val c.i c.h), .binop .and y1 (.val a.i a.h) (.val y0.i y0.h),
    .binop .xor mj (.val y1.i y1.h) (.val bc.i bc.h),
    .binop (.add {}) u (.val s0.i s0.h) (.val mj.i mj.h),
    .binop (.add {}) e' (.val t4.i t4.h) (.val d.i d.h),
    .binop (.add {}) a' (.val u.i u.h) (.val t4.i t4.h),
    .ternop .fshl o0 (.val x15.i x15.h) (.val x15.i x15.h) (.val c63.i c63.h),
    .ternop .fshl o1 (.val x15.i x15.h) (.val x15.i x15.h) (.val c56.i c56.h),
    .binop .xor z0 (.val o0.i o0.h) (.val o1.i o1.h),
    .binop (.lshr false) o2 (.val x15.i x15.h) (.val c7.i c7.h),
    .binop .xor sg0 (.val z0.i z0.h) (.val o2.i o2.h),
    .ternop .fshl o3 (.val x2.i x2.h) (.val x2.i x2.h) (.val c45.i c45.h),
    .ternop .fshl o4 (.val x2.i x2.h) (.val x2.i x2.h) (.val c3.i c3.h),
    .binop .xor z1 (.val o3.i o3.h) (.val o4.i o4.h),
    .binop (.lshr false) o5 (.val x2.i x2.h) (.val c6.i c6.h),
    .binop .xor sg1 (.val z1.i z1.h) (.val o5.i o5.h),
    .binop (.add {}) m0 (.val sg0.i sg0.h) (.val x16.i x16.h),
    .binop (.add {}) m1 (.val m0.i m0.h) (.val x7.i x7.h),
    .binop (.add {}) wn (.val m1.i m1.h) (.val sg1.i sg1.h),
    .ternop .fshl q0 (.val e'.i e'.h) (.val e'.i e'.h) (.val c50.i c50.h),
    .ternop .fshl q1 (.val e'.i e'.h) (.val e'.i e'.h) (.val c46.i c46.h),
    .binop .xor x1 (.val q0.i q0.h) (.val q1.i q1.h),
    .ternop .fshl q2 (.val e'.i e'.h) (.val e'.i e'.h) (.val c23.i c23.h),
    .binop .xor s1' (.val x1.i x1.h) (.val q2.i q2.h),
    .binop .and p1' (.val e'.i e'.h) (.val e.i e.h),
    .binop .xor n' (.val e'.i e'.h) (.val cm1.i cm1.h),
    .binop .and p2' (.val f.i f.h) (.val n'.i n'.h),
    .binop (.or false) ch' (.val p1'.i p1'.h) (.val p2'.i p2'.h)]

/-- Where the body at `pos` is `round15`: round `t` from `rounds Wf t H`, and `Wf tw` from the
schedule's four words. -/
theorem runBodyFrom_round15 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {kp : Dst Γ .ptr}
    {w h p2 p1 s1 a b c bc d e f x15 x2 x16 x7 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1 :
      Dst Γ (.bv 64)}
    {kk t0 t1 t2 t3 t4 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4 z1 o5 sg1 m0 m1 wn
      q0 q1 x1 q2 s1' p1' n' p2' ch' : Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {KP : Pointer} {Wf : Nat → BitVec 64} {t : Nat}
    {H : Vector (BitVec 64) 8} {A B C D Ee F G Hh : BitVec 64} {X15 X2 X16 X7 : BitVec 64}
    {tw : Nat} {S : GlobalState} {κ : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        round15 kp w h p2 p1 s1 a b c bc d e f x15 x2 x16 x7 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50
            c46 c23 cm1 kk t0 t1 t2 t3 t4 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4
            z1 o5 sg1 m0 m1 wn q0 q1 x1 q2 s1' p1' n' p2' ch' ++
          rest)
    (hR :
      E ⊨ [kp := KP, w := Wf t, h := Hh, p2 := G &&& ~~~Ee, p1 := Ee &&& F, s1 := Sha512.Sigma1 Ee,
        a := A, b := B, c := C, bc := B &&& C, d := D, e := Ee, f := F, x15 := X15, x2 := X2, x16 :=
        X16, x7 := X7, c36 := 36#64, c30 := 30#64, c25 := 25#64, c63 := 63#64, c56 := 56#64, c7 :=
        7#64, c45 := 45#64, c3 := 3#64, c6 := 6#64, c50 := 50#64, c46 := 46#64, c23 := 23#64, cm1 :=
        18446744073709551615#64])
    (hd :
      [w.i, h.i, p2.i, p1.i, s1.i, a.i, b.i, c.i, bc.i, d.i, e.i, f.i, x15.i, x2.i, x16.i, x7.i,
          c36.i, c30.i, c25.i, c63.i, c56.i, c7.i, c45.i, c3.i, c6.i, c50.i, c46.i, c23.i, cm1.i,
          kk.i, t0.i, t1.i, t2.i, t3.i, t4.i, r0.i, r1.i, x0.i, r2.i, s0.i, ab.i, y0.i, y1.i, mj.i,
          u.i, e'.i, a'.i, o0.i, o1.i, z0.i, o2.i, sg0.i, o3.i, o4.i, z1.i, o5.i, sg1.i, m0.i, m1.i,
          wn.i, q0.i, q1.i, x1.i, q2.i, s1'.i, p1'.i, n'.i, p2'.i].Nodup)
    (hkf : Fits S.mem KP 64) (hk : S.mem.readAt KP 64 = Sha512.K[t]!)
    (hacc : rounds Wf t H = #v[A, B, C, D, Ee, F, G, Hh])
    (hsch : Wf tw = Sha512.sigma1 X2 + X7 + Sha512.sigma0 X15 + X16)
    (hK :
      ∀ A' E' : BitVec 64,
        rounds Wf (t + 1) H = #v[A', A, B, C, E', Ee, F, G] →
          ∀ vkk vt0 vt1 vt2 vt3 vt4 vr0 vr1 vx0 vr2 vs0 vy0 vy1 vmj vu vo0 vo1 vz0 vo2 vsg0 vo3 vo4
            vz1 vo5 vsg1 vm0 vm1 vq0 vq1 vx1 vq2 vp1' vn' vp2' : ⟦.bv 64⟧,
            (blk.runBodyFrom
                  E[kk := vkk, t0 := vt0, t1 := vt1, t2 := vt2, t3 := vt3, t4 := vt4, r0 := vr0,
                    r1 := vr1, x0 := vx0, r2 := vr2, s0 := vs0, ab := .value (A &&& B), y0 := vy0,
                    y1 := vy1, mj := vmj, u := vu, e' := .value E', a' := .value A', o0 := vo0,
                    o1 := vo1, z0 := vz0, o2 := vo2, sg0 := vsg0, o3 := vo3, o4 := vo4, z1 := vz1,
                    o5 := vo5, sg1 := vsg1, m0 := vm0, m1 := vm1, wn := .value (Wf tw), q0 := vq0,
                    q1 := vq1, x1 := vx1, q2 := vq2, s1' := .value (Sha512.Sigma1 E'), p1' := vp1',
                    n' := vn', p2' := vp2', ch' := .value (Sha512.Ch E' Ee F)]
                  (pos + 40) S >>=
                κ) =
              K) :
    (blk.runBodyFrom E pos S >>= κ) = K := by
  have hw : Sha512.sigma0 X15 + X16 + X7 + Sha512.sigma1 X2 = Wf tw := by
    rw [hsch]; ac_rfl
  step_load
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig0_code]
  step_pure
  step_pure
  step_pure
  step_pure [maj_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [ssig0_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [ssig1_code]
  step_pure
  step_pure
  step_pure [hw]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig1_code]
  step_pure
  step_pure [not_code]
  step_pure
  step_pure [ch_or]
  subst hS
  rw [hE]
  apply hK
  rw [rounds_succ, hacc]
  exact
    round_eq
      (by
        rw [← ch_add]; ac_rfl)

/-- A round of rounds 16–76: `T1 = w + h + K + Ch(e, f, g) + Σ₁(e)` (the first sums in the order
`o`), `T2`, the schedule's next word in `wn`, then the next round's `Σ₁(e')` and `Ch(e', e, f)`. -/
def roundS (o : Order) (kp : Dst Γ .ptr)
    (w h ch s1 a b c bc d e f x15 x2 x16 x7 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1 :
      Dst Γ (.bv 64))
    (kk t0 t1 t2 t3 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4 z1 o5 sg1 m0 m1 wn q0
      q1 x1 q2 s1' p1' n' p2' ch' : Dst Γ (.bv 64)) :
    List (Instr Γ) :=
  .load kk (.val kp.i kp.h) :: headRun o w h kk t0 t1 ++
    [.binop (.add {}) t2 (.val t1.i t1.h) (.val ch.i ch.h),
      .binop (.add {}) t3 (.val t2.i t2.h) (.val s1.i s1.h),
      .ternop .fshl r0 (.val a.i a.h) (.val a.i a.h) (.val c36.i c36.h),
      .ternop .fshl r1 (.val a.i a.h) (.val a.i a.h) (.val c30.i c30.h),
      .binop .xor x0 (.val r0.i r0.h) (.val r1.i r1.h),
      .ternop .fshl r2 (.val a.i a.h) (.val a.i a.h) (.val c25.i c25.h),
      .binop .xor s0 (.val x0.i x0.h) (.val r2.i r2.h),
      .binop .and ab (.val a.i a.h) (.val b.i b.h), .binop .xor y0 (.val b.i b.h) (.val c.i c.h),
      .binop .and y1 (.val a.i a.h) (.val y0.i y0.h),
      .binop .xor mj (.val y1.i y1.h) (.val bc.i bc.h),
      .binop (.add {}) u (.val s0.i s0.h) (.val mj.i mj.h),
      .binop (.add {}) e' (.val t3.i t3.h) (.val d.i d.h),
      .binop (.add {}) a' (.val u.i u.h) (.val t3.i t3.h),
      .ternop .fshl o0 (.val x15.i x15.h) (.val x15.i x15.h) (.val c63.i c63.h),
      .ternop .fshl o1 (.val x15.i x15.h) (.val x15.i x15.h) (.val c56.i c56.h),
      .binop .xor z0 (.val o0.i o0.h) (.val o1.i o1.h),
      .binop (.lshr false) o2 (.val x15.i x15.h) (.val c7.i c7.h),
      .binop .xor sg0 (.val z0.i z0.h) (.val o2.i o2.h),
      .ternop .fshl o3 (.val x2.i x2.h) (.val x2.i x2.h) (.val c45.i c45.h),
      .ternop .fshl o4 (.val x2.i x2.h) (.val x2.i x2.h) (.val c3.i c3.h),
      .binop .xor z1 (.val o3.i o3.h) (.val o4.i o4.h),
      .binop (.lshr false) o5 (.val x2.i x2.h) (.val c6.i c6.h),
      .binop .xor sg1 (.val z1.i z1.h) (.val o5.i o5.h),
      .binop (.add {}) m0 (.val sg0.i sg0.h) (.val x16.i x16.h),
      .binop (.add {}) m1 (.val m0.i m0.h) (.val x7.i x7.h),
      .binop (.add {}) wn (.val m1.i m1.h) (.val sg1.i sg1.h),
      .ternop .fshl q0 (.val e'.i e'.h) (.val e'.i e'.h) (.val c50.i c50.h),
      .ternop .fshl q1 (.val e'.i e'.h) (.val e'.i e'.h) (.val c46.i c46.h),
      .binop .xor x1 (.val q0.i q0.h) (.val q1.i q1.h),
      .ternop .fshl q2 (.val e'.i e'.h) (.val e'.i e'.h) (.val c23.i c23.h),
      .binop .xor s1' (.val x1.i x1.h) (.val q2.i q2.h),
      .binop .and p1' (.val e'.i e'.h) (.val e.i e.h),
      .binop .xor n' (.val e'.i e'.h) (.val cm1.i cm1.h),
      .binop .and p2' (.val f.i f.h) (.val n'.i n'.h),
      .binop (.or false) ch' (.val p1'.i p1'.h) (.val p2'.i p2'.h)]

/-- Where the body at `pos` is `roundS o`: round `t` from `rounds Wf t H`, and `Wf tw` from the
schedule's four words. -/
theorem runBodyFrom_roundS {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {o : Order}
    {kp : Dst Γ .ptr}
    {w h ch s1 a b c bc d e f x15 x2 x16 x7 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1 :
      Dst Γ (.bv 64)}
    {kk t0 t1 t2 t3 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4 z1 o5 sg1 m0 m1 wn q0
      q1 x1 q2 s1' p1' n' p2' ch' : Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {KP : Pointer} {Wf : Nat → BitVec 64} {t : Nat}
    {H : Vector (BitVec 64) 8} {A B C D Ee F G Hh : BitVec 64} {X15 X2 X16 X7 : BitVec 64}
    {tw : Nat} {S : GlobalState} {κ : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        roundS o kp w h ch s1 a b c bc d e f x15 x2 x16 x7 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46
            c23 cm1 kk t0 t1 t2 t3 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4 z1 o5
            sg1 m0 m1 wn q0 q1 x1 q2 s1' p1' n' p2' ch' ++
          rest)
    (hR :
      E ⊨ [kp := KP, w := Wf t, h := Hh, ch := Sha512.Ch Ee F G, s1 := Sha512.Sigma1 Ee, a := A,
        b := B, c := C, bc := B &&& C, d := D, e := Ee, f := F, x15 := X15, x2 := X2, x16 := X16,
        x7 := X7, c36 := 36#64, c30 := 30#64, c25 := 25#64, c63 := 63#64, c56 := 56#64, c7 := 7#64,
        c45 := 45#64, c3 := 3#64, c6 := 6#64, c50 := 50#64, c46 := 46#64, c23 := 23#64, cm1 :=
        18446744073709551615#64])
    (hd :
      [w.i, h.i, ch.i, s1.i, a.i, b.i, c.i, bc.i, d.i, e.i, f.i, x15.i, x2.i, x16.i, x7.i, c36.i,
          c30.i, c25.i, c63.i, c56.i, c7.i, c45.i, c3.i, c6.i, c50.i, c46.i, c23.i, cm1.i, kk.i,
          t0.i, t1.i, t2.i, t3.i, r0.i, r1.i, x0.i, r2.i, s0.i, ab.i, y0.i, y1.i, mj.i, u.i, e'.i,
          a'.i, o0.i, o1.i, z0.i, o2.i, sg0.i, o3.i, o4.i, z1.i, o5.i, sg1.i, m0.i, m1.i, wn.i,
          q0.i, q1.i, x1.i, q2.i, s1'.i, p1'.i, n'.i, p2'.i].Nodup)
    (hkf : Fits S.mem KP 64) (hk : S.mem.readAt KP 64 = Sha512.K[t]!)
    (hacc : rounds Wf t H = #v[A, B, C, D, Ee, F, G, Hh])
    (hsch : Wf tw = Sha512.sigma1 X2 + X7 + Sha512.sigma0 X15 + X16)
    (hK :
      ∀ A' E' : BitVec 64,
        rounds Wf (t + 1) H = #v[A', A, B, C, E', Ee, F, G] →
          ∀ vkk vt0 vt1 vt2 vt3 vr0 vr1 vx0 vr2 vs0 vy0 vy1 vmj vu vo0 vo1 vz0 vo2 vsg0 vo3 vo4 vz1
            vo5 vsg1 vm0 vm1 vq0 vq1 vx1 vq2 vp1' vn' vp2' : ⟦.bv 64⟧,
            (blk.runBodyFrom
                  E[kk := vkk, t0 := vt0, t1 := vt1, t2 := vt2, t3 := vt3, r0 := vr0, r1 := vr1,
                    x0 := vx0, r2 := vr2, s0 := vs0, ab := .value (A &&& B), y0 := vy0, y1 := vy1,
                    mj := vmj, u := vu, e' := .value E', a' := .value A', o0 := vo0, o1 := vo1,
                    z0 := vz0, o2 := vo2, sg0 := vsg0, o3 := vo3, o4 := vo4, z1 := vz1, o5 := vo5,
                    sg1 := vsg1, m0 := vm0, m1 := vm1, wn := .value (Wf tw), q0 := vq0, q1 := vq1,
                    x1 := vx1, q2 := vq2, s1' := .value (Sha512.Sigma1 E'), p1' := vp1', n' := vn',
                    p2' := vp2', ch' := .value (Sha512.Ch E' Ee F)]
                  (pos + 39) S >>=
                κ) =
              K) :
    (blk.runBodyFrom E pos S >>= κ) = K := by
  have hw : Sha512.sigma0 X15 + X16 + X7 + Sha512.sigma1 X2 = Wf tw := by
    rw [hsch]; ac_rfl
  step_load inline
  step_pattern using runBodyFrom_headRun
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig0_code]
  step_pure
  step_pure
  step_pure
  step_pure [maj_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [ssig0_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [ssig1_code]
  step_pure
  step_pure
  step_pure [hw]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig1_code]
  step_pure
  step_pure [not_code]
  step_pure
  step_pure [ch_or]
  subst hS
  rw [hE]
  apply hK
  rw [rounds_succ, hacc]
  exact
    round_eq
      (by
        rw [headSum_eq]; ac_rfl)

/-- Round 77: as `roundS .wkh`, with `σ₀` and `σ₁` of round 78's word left unsummed. -/
def round77 (kp : Dst Γ .ptr)
    (w h ch s1 a b c bc d e f x15 x2 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1 :
      Dst Γ (.bv 64))
    (kk t0 t1 t2 t3 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4 z1 o5 sg1 q0 q1 x1 q2
      s1' p1' n' p2' ch' : Dst Γ (.bv 64)) :
    List (Instr Γ) :=
  [.load kk (.val kp.i kp.h), .binop (.add {}) t0 (.val w.i w.h) (.val kk.i kk.h),
    .binop (.add {}) t1 (.val t0.i t0.h) (.val h.i h.h),
    .binop (.add {}) t2 (.val t1.i t1.h) (.val ch.i ch.h),
    .binop (.add {}) t3 (.val t2.i t2.h) (.val s1.i s1.h),
    .ternop .fshl r0 (.val a.i a.h) (.val a.i a.h) (.val c36.i c36.h),
    .ternop .fshl r1 (.val a.i a.h) (.val a.i a.h) (.val c30.i c30.h),
    .binop .xor x0 (.val r0.i r0.h) (.val r1.i r1.h),
    .ternop .fshl r2 (.val a.i a.h) (.val a.i a.h) (.val c25.i c25.h),
    .binop .xor s0 (.val x0.i x0.h) (.val r2.i r2.h), .binop .and ab (.val a.i a.h) (.val b.i b.h),
    .binop .xor y0 (.val b.i b.h) (.val c.i c.h), .binop .and y1 (.val a.i a.h) (.val y0.i y0.h),
    .binop .xor mj (.val y1.i y1.h) (.val bc.i bc.h),
    .binop (.add {}) u (.val s0.i s0.h) (.val mj.i mj.h),
    .binop (.add {}) e' (.val t3.i t3.h) (.val d.i d.h),
    .binop (.add {}) a' (.val u.i u.h) (.val t3.i t3.h),
    .ternop .fshl o0 (.val x15.i x15.h) (.val x15.i x15.h) (.val c63.i c63.h),
    .ternop .fshl o1 (.val x15.i x15.h) (.val x15.i x15.h) (.val c56.i c56.h),
    .binop .xor z0 (.val o0.i o0.h) (.val o1.i o1.h),
    .binop (.lshr false) o2 (.val x15.i x15.h) (.val c7.i c7.h),
    .binop .xor sg0 (.val z0.i z0.h) (.val o2.i o2.h),
    .ternop .fshl o3 (.val x2.i x2.h) (.val x2.i x2.h) (.val c45.i c45.h),
    .ternop .fshl o4 (.val x2.i x2.h) (.val x2.i x2.h) (.val c3.i c3.h),
    .binop .xor z1 (.val o3.i o3.h) (.val o4.i o4.h),
    .binop (.lshr false) o5 (.val x2.i x2.h) (.val c6.i c6.h),
    .binop .xor sg1 (.val z1.i z1.h) (.val o5.i o5.h),
    .ternop .fshl q0 (.val e'.i e'.h) (.val e'.i e'.h) (.val c50.i c50.h),
    .ternop .fshl q1 (.val e'.i e'.h) (.val e'.i e'.h) (.val c46.i c46.h),
    .binop .xor x1 (.val q0.i q0.h) (.val q1.i q1.h),
    .ternop .fshl q2 (.val e'.i e'.h) (.val e'.i e'.h) (.val c23.i c23.h),
    .binop .xor s1' (.val x1.i x1.h) (.val q2.i q2.h),
    .binop .and p1' (.val e'.i e'.h) (.val e.i e.h),
    .binop .xor n' (.val e'.i e'.h) (.val cm1.i cm1.h),
    .binop .and p2' (.val f.i f.h) (.val n'.i n'.h),
    .binop (.or false) ch' (.val p1'.i p1'.h) (.val p2'.i p2'.h)]

/-- Where the body at `pos` is `round77`: round `t` from `rounds Wf t H`, `σ₀(X15)` and `σ₁(X2)` in
`sg0`, `sg1`. -/
theorem runBodyFrom_round77 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {kp : Dst Γ .ptr}
    {w h ch s1 a b c bc d e f x15 x2 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1 :
      Dst Γ (.bv 64)}
    {kk t0 t1 t2 t3 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4 z1 o5 sg1 q0 q1 x1 q2
      s1' p1' n' p2' ch' : Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {KP : Pointer} {Wf : Nat → BitVec 64} {t : Nat}
    {H : Vector (BitVec 64) 8} {A B C D Ee F G Hh : BitVec 64} {X15 X2 : BitVec 64}
    {S : GlobalState} {κ : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        round77 kp w h ch s1 a b c bc d e f x15 x2 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1
            kk t0 t1 t2 t3 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' o0 o1 z0 o2 sg0 o3 o4 z1 o5 sg1 q0 q1
            x1 q2 s1' p1' n' p2' ch' ++
          rest)
    (hR :
      E ⊨ [kp := KP, w := Wf t, h := Hh, ch := Sha512.Ch Ee F G, s1 := Sha512.Sigma1 Ee, a := A,
        b := B, c := C, bc := B &&& C, d := D, e := Ee, f := F, x15 := X15, x2 := X2, c36 := 36#64,
        c30 := 30#64, c25 := 25#64, c63 := 63#64, c56 := 56#64, c7 := 7#64, c45 := 45#64, c3 :=
        3#64, c6 := 6#64, c50 := 50#64, c46 := 46#64, c23 := 23#64, cm1 := 18446744073709551615#64])
    (hd :
      [w.i, h.i, ch.i, s1.i, a.i, b.i, c.i, bc.i, d.i, e.i, f.i, x15.i, x2.i, c36.i, c30.i, c25.i,
          c63.i, c56.i, c7.i, c45.i, c3.i, c6.i, c50.i, c46.i, c23.i, cm1.i, kk.i, t0.i, t1.i, t2.i,
          t3.i, r0.i, r1.i, x0.i, r2.i, s0.i, ab.i, y0.i, y1.i, mj.i, u.i, e'.i, a'.i, o0.i, o1.i,
          z0.i, o2.i, sg0.i, o3.i, o4.i, z1.i, o5.i, sg1.i, q0.i, q1.i, x1.i, q2.i, s1'.i, p1'.i,
          n'.i, p2'.i].Nodup)
    (hkf : Fits S.mem KP 64) (hk : S.mem.readAt KP 64 = Sha512.K[t]!)
    (hacc : rounds Wf t H = #v[A, B, C, D, Ee, F, G, Hh])
    (hK :
      ∀ A' E' : BitVec 64,
        rounds Wf (t + 1) H = #v[A', A, B, C, E', Ee, F, G] →
          ∀ vkk vt0 vt1 vt2 vt3 vr0 vr1 vx0 vr2 vs0 vy0 vy1 vmj vu vo0 vo1 vz0 vo2 vo3 vo4 vz1 vo5
            vq0 vq1 vx1 vq2 vp1' vn' vp2' : ⟦.bv 64⟧,
            (blk.runBodyFrom
                  E[kk := vkk, t0 := vt0, t1 := vt1, t2 := vt2, t3 := vt3, r0 := vr0, r1 := vr1,
                    x0 := vx0, r2 := vr2, s0 := vs0, ab := .value (A &&& B), y0 := vy0, y1 := vy1,
                    mj := vmj, u := vu, e' := .value E', a' := .value A', o0 := vo0, o1 := vo1,
                    z0 := vz0, o2 := vo2, sg0 := .value (Sha512.sigma0 X15), o3 := vo3, o4 := vo4,
                    z1 := vz1, o5 := vo5, sg1 := .value (Sha512.sigma1 X2), q0 := vq0, q1 := vq1,
                    x1 := vx1, q2 := vq2, s1' := .value (Sha512.Sigma1 E'), p1' := vp1', n' := vn',
                    p2' := vp2', ch' := .value (Sha512.Ch E' Ee F)]
                  (pos + 36) S >>=
                κ) =
              K) :
    (blk.runBodyFrom E pos S >>= κ) = K := by
  step_load
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig0_code]
  step_pure
  step_pure
  step_pure
  step_pure [maj_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [ssig0_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [ssig1_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig1_code]
  step_pure
  step_pure [not_code]
  step_pure
  step_pure [ch_or]
  subst hS
  rw [hE]
  apply hK
  rw [rounds_succ, hacc]
  exact round_eq (by ac_rfl)

/-- Round 78: `T1 = W₆₂ + K + σ₀(W₆₃) + W₇₁ + σ₁(W₇₆) + h + Ch(e, f, g) + Σ₁(e)`, its word summed in
place; `σ₀` and `σ₁` of round 79's word. -/
def round78 (kp : Dst Γ .ptr)
    (x16 sg0 x7 sg1 h ch s1 a b c bc d e f y15 y2 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1 :
      Dst Γ (.bv 64))
    (kk t0 t1 t2 t3 t4 t5 t6 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' no0 no1 nz0 no2 nsg0 no3 no4 nz1 no5
      nsg1 q0 q1 x1 q2 s1' p1' n' p2' ch' : Dst Γ (.bv 64)) :
    List (Instr Γ) :=
  [.load kk (.val kp.i kp.h), .binop (.add {}) t0 (.val x16.i x16.h) (.val kk.i kk.h),
    .binop (.add {}) t1 (.val t0.i t0.h) (.val sg0.i sg0.h),
    .binop (.add {}) t2 (.val t1.i t1.h) (.val x7.i x7.h),
    .binop (.add {}) t3 (.val t2.i t2.h) (.val sg1.i sg1.h),
    .binop (.add {}) t4 (.val t3.i t3.h) (.val h.i h.h),
    .binop (.add {}) t5 (.val t4.i t4.h) (.val ch.i ch.h),
    .binop (.add {}) t6 (.val t5.i t5.h) (.val s1.i s1.h),
    .ternop .fshl r0 (.val a.i a.h) (.val a.i a.h) (.val c36.i c36.h),
    .ternop .fshl r1 (.val a.i a.h) (.val a.i a.h) (.val c30.i c30.h),
    .binop .xor x0 (.val r0.i r0.h) (.val r1.i r1.h),
    .ternop .fshl r2 (.val a.i a.h) (.val a.i a.h) (.val c25.i c25.h),
    .binop .xor s0 (.val x0.i x0.h) (.val r2.i r2.h), .binop .and ab (.val a.i a.h) (.val b.i b.h),
    .binop .xor y0 (.val b.i b.h) (.val c.i c.h), .binop .and y1 (.val a.i a.h) (.val y0.i y0.h),
    .binop .xor mj (.val y1.i y1.h) (.val bc.i bc.h),
    .binop (.add {}) u (.val s0.i s0.h) (.val mj.i mj.h),
    .binop (.add {}) e' (.val t6.i t6.h) (.val d.i d.h),
    .binop (.add {}) a' (.val u.i u.h) (.val t6.i t6.h),
    .ternop .fshl no0 (.val y15.i y15.h) (.val y15.i y15.h) (.val c63.i c63.h),
    .ternop .fshl no1 (.val y15.i y15.h) (.val y15.i y15.h) (.val c56.i c56.h),
    .binop .xor nz0 (.val no0.i no0.h) (.val no1.i no1.h),
    .binop (.lshr false) no2 (.val y15.i y15.h) (.val c7.i c7.h),
    .binop .xor nsg0 (.val nz0.i nz0.h) (.val no2.i no2.h),
    .ternop .fshl no3 (.val y2.i y2.h) (.val y2.i y2.h) (.val c45.i c45.h),
    .ternop .fshl no4 (.val y2.i y2.h) (.val y2.i y2.h) (.val c3.i c3.h),
    .binop .xor nz1 (.val no3.i no3.h) (.val no4.i no4.h),
    .binop (.lshr false) no5 (.val y2.i y2.h) (.val c6.i c6.h),
    .binop .xor nsg1 (.val nz1.i nz1.h) (.val no5.i no5.h),
    .ternop .fshl q0 (.val e'.i e'.h) (.val e'.i e'.h) (.val c50.i c50.h),
    .ternop .fshl q1 (.val e'.i e'.h) (.val e'.i e'.h) (.val c46.i c46.h),
    .binop .xor x1 (.val q0.i q0.h) (.val q1.i q1.h),
    .ternop .fshl q2 (.val e'.i e'.h) (.val e'.i e'.h) (.val c23.i c23.h),
    .binop .xor s1' (.val x1.i x1.h) (.val q2.i q2.h),
    .binop .and p1' (.val e'.i e'.h) (.val e.i e.h),
    .binop .xor n' (.val e'.i e'.h) (.val cm1.i cm1.h),
    .binop .and p2' (.val f.i f.h) (.val n'.i n'.h),
    .binop (.or false) ch' (.val p1'.i p1'.h) (.val p2'.i p2'.h)]

/-- Where the body at `pos` is `round78`: round `t`, its word `Wf t` from the schedule's four, from
`rounds Wf t H`. -/
theorem runBodyFrom_round78 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {kp : Dst Γ .ptr}
    {x16 sg0 x7 sg1 h ch s1 a b c bc d e f y15 y2 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50 c46 c23 cm1 :
      Dst Γ (.bv 64)}
    {kk t0 t1 t2 t3 t4 t5 t6 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' no0 no1 nz0 no2 nsg0 no3 no4 nz1 no5
      nsg1 q0 q1 x1 q2 s1' p1' n' p2' ch' : Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {KP : Pointer} {Wf : Nat → BitVec 64} {t : Nat}
    {H : Vector (BitVec 64) 8} {A B C D Ee F G Hh : BitVec 64} {X15 X2 X16 X7 Y15 Y2 : BitVec 64}
    {S : GlobalState} {κ : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        round78 kp x16 sg0 x7 sg1 h ch s1 a b c bc d e f y15 y2 c36 c30 c25 c63 c56 c7 c45 c3 c6 c50
            c46 c23 cm1 kk t0 t1 t2 t3 t4 t5 t6 r0 r1 x0 r2 s0 ab y0 y1 mj u e' a' no0 no1 nz0 no2
            nsg0 no3 no4 nz1 no5 nsg1 q0 q1 x1 q2 s1' p1' n' p2' ch' ++
          rest)
    (hR :
      E ⊨ [kp := KP, x16 := X16, sg0 := Sha512.sigma0 X15, x7 := X7, sg1 := Sha512.sigma1 X2, h :=
        Hh, ch := Sha512.Ch Ee F G, s1 := Sha512.Sigma1 Ee, a := A, b := B, c := C, bc := B &&& C,
        d := D, e := Ee, f := F, y15 := Y15, y2 := Y2, c36 := 36#64, c30 := 30#64, c25 := 25#64,
        c63 := 63#64, c56 := 56#64, c7 := 7#64, c45 := 45#64, c3 := 3#64, c6 := 6#64, c50 := 50#64,
        c46 := 46#64, c23 := 23#64, cm1 := 18446744073709551615#64])
    (hd :
      [x16.i, sg0.i, x7.i, sg1.i, h.i, ch.i, s1.i, a.i, b.i, c.i, bc.i, d.i, e.i, f.i, y15.i, y2.i,
          c36.i, c30.i, c25.i, c63.i, c56.i, c7.i, c45.i, c3.i, c6.i, c50.i, c46.i, c23.i, cm1.i,
          kk.i, t0.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i, r0.i, r1.i, x0.i, r2.i, s0.i, ab.i, y0.i,
          y1.i, mj.i, u.i, e'.i, a'.i, no0.i, no1.i, nz0.i, no2.i, nsg0.i, no3.i, no4.i, nz1.i,
          no5.i, nsg1.i, q0.i, q1.i, x1.i, q2.i, s1'.i, p1'.i, n'.i, p2'.i].Nodup)
    (hkf : Fits S.mem KP 64) (hk : S.mem.readAt KP 64 = Sha512.K[t]!)
    (hacc : rounds Wf t H = #v[A, B, C, D, Ee, F, G, Hh])
    (hsch : Wf t = Sha512.sigma1 X2 + X7 + Sha512.sigma0 X15 + X16)
    (hK :
      ∀ A' E' : BitVec 64,
        rounds Wf (t + 1) H = #v[A', A, B, C, E', Ee, F, G] →
          ∀ vkk vt0 vt1 vt2 vt3 vt4 vt5 vt6 vr0 vr1 vx0 vr2 vs0 vy0 vy1 vmj vu vno0 vno1 vnz0 vno2
            vno3 vno4 vnz1 vno5 vq0 vq1 vx1 vq2 vp1' vn' vp2' : ⟦.bv 64⟧,
            (blk.runBodyFrom
                  E[kk := vkk, t0 := vt0, t1 := vt1, t2 := vt2, t3 := vt3, t4 := vt4, t5 := vt5,
                    t6 := vt6, r0 := vr0, r1 := vr1, x0 := vx0, r2 := vr2, s0 := vs0, ab :=
                    .value (A &&& B), y0 := vy0, y1 := vy1, mj := vmj, u := vu, e' := .value E',
                    a' := .value A', no0 := vno0, no1 := vno1, nz0 := vnz0, no2 := vno2, nsg0 :=
                    .value (Sha512.sigma0 Y15), no3 := vno3, no4 := vno4, nz1 := vnz1, no5 := vno5,
                    nsg1 := .value (Sha512.sigma1 Y2), q0 := vq0, q1 := vq1, x1 := vx1, q2 := vq2,
                    s1' := .value (Sha512.Sigma1 E'), p1' := vp1', n' := vn', p2' := vp2', ch' :=
                    .value (Sha512.Ch E' Ee F)]
                  (pos + 39) S >>=
                κ) =
              K) :
    (blk.runBodyFrom E pos S >>= κ) = K := by
  step_load
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
  step_pure [sig0_code]
  step_pure
  step_pure
  step_pure
  step_pure [maj_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [ssig0_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [ssig1_code]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [sig1_code]
  step_pure
  step_pure [not_code]
  step_pure
  step_pure [ch_or]
  subst hS
  rw [hE]
  apply hK
  rw [rounds_succ, hacc]
  exact
    round_eq
      (by
        rw [hsch]; ac_rfl)

/-- Round 79, then `state[i] += …`: the block's new state words in `n0 … n7`, from the old ones in
`i0 … i7`. -/
def round79 (kp : Dst Γ .ptr)
    (x16 sg0 x7 sg1 h ch s1 a b c bc d e f g i0 i1 i2 i3 i4 i5 i6 i7 c36 c30 c25 : Dst Γ (.bv 64))
    (kk t0 t1 t2 t3 t4 t5 t6 r0 r1 x0 r2 s0 y0 y1 mj f0 f1 n0 n1 n2 n3 z n4 n5 n6 n7 :
      Dst Γ (.bv 64)) :
    List (Instr Γ) :=
  [.load kk (.val kp.i kp.h), .binop (.add {}) t0 (.val x16.i x16.h) (.val kk.i kk.h),
    .binop (.add {}) t1 (.val t0.i t0.h) (.val sg0.i sg0.h),
    .binop (.add {}) t2 (.val t1.i t1.h) (.val x7.i x7.h),
    .binop (.add {}) t3 (.val t2.i t2.h) (.val sg1.i sg1.h),
    .binop (.add {}) t4 (.val t3.i t3.h) (.val h.i h.h),
    .binop (.add {}) t5 (.val t4.i t4.h) (.val ch.i ch.h),
    .binop (.add {}) t6 (.val t5.i t5.h) (.val s1.i s1.h),
    .ternop .fshl r0 (.val a.i a.h) (.val a.i a.h) (.val c36.i c36.h),
    .ternop .fshl r1 (.val a.i a.h) (.val a.i a.h) (.val c30.i c30.h),
    .binop .xor x0 (.val r0.i r0.h) (.val r1.i r1.h),
    .ternop .fshl r2 (.val a.i a.h) (.val a.i a.h) (.val c25.i c25.h),
    .binop .xor s0 (.val x0.i x0.h) (.val r2.i r2.h), .binop .xor y0 (.val b.i b.h) (.val c.i c.h),
    .binop .and y1 (.val a.i a.h) (.val y0.i y0.h),
    .binop .xor mj (.val y1.i y1.h) (.val bc.i bc.h),
    .binop (.add {}) f0 (.val mj.i mj.h) (.val i0.i i0.h),
    .binop (.add {}) f1 (.val f0.i f0.h) (.val s0.i s0.h),
    .binop (.add {}) n0 (.val f1.i f1.h) (.val t6.i t6.h),
    .binop (.add {}) n1 (.val a.i a.h) (.val i1.i i1.h),
    .binop (.add {}) n2 (.val b.i b.h) (.val i2.i i2.h),
    .binop (.add {}) n3 (.val c.i c.h) (.val i3.i i3.h),
    .binop (.add {}) z (.val d.i d.h) (.val i4.i i4.h),
    .binop (.add {}) n4 (.val z.i z.h) (.val t6.i t6.h),
    .binop (.add {}) n5 (.val e.i e.h) (.val i5.i i5.h),
    .binop (.add {}) n6 (.val f.i f.h) (.val i6.i i6.h),
    .binop (.add {}) n7 (.val g.i g.h) (.val i7.i i7.h)]

/-- Where the body at `pos` is `round79`: the last round from `rounds Wf t H`, added to `H`. -/
theorem runBodyFrom_round79 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {kp : Dst Γ .ptr}
    {x16 sg0 x7 sg1 h ch s1 a b c bc d e f g i0 i1 i2 i3 i4 i5 i6 i7 c36 c30 c25 : Dst Γ (.bv 64)}
    {kk t0 t1 t2 t3 t4 t5 t6 r0 r1 x0 r2 s0 y0 y1 mj f0 f1 n0 n1 n2 n3 z n4 n5 n6 n7 :
      Dst Γ (.bv 64)}
    {rest : List (Instr Γ)} {KP : Pointer} {Wf : Nat → BitVec 64} {t : Nat}
    {A B C D Ee F G Hh I0 I1 I2 I3 I4 I5 I6 I7 : BitVec 64} {X15 X2 X16 X7 : BitVec 64}
    {S : GlobalState} {κ : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        round79 kp x16 sg0 x7 sg1 h ch s1 a b c bc d e f g i0 i1 i2 i3 i4 i5 i6 i7 c36 c30 c25 kk t0
            t1 t2 t3 t4 t5 t6 r0 r1 x0 r2 s0 y0 y1 mj f0 f1 n0 n1 n2 n3 z n4 n5 n6 n7 ++
          rest)
    (hR :
      E ⊨ [kp := KP, x16 := X16, sg0 := Sha512.sigma0 X15, x7 := X7, sg1 := Sha512.sigma1 X2, h :=
        Hh, ch := Sha512.Ch Ee F G, s1 := Sha512.Sigma1 Ee, a := A, b := B, c := C, bc := B &&& C,
        d := D, e := Ee, f := F, g := G, i0 := I0, i1 := I1, i2 := I2, i3 := I3, i4 := I4, i5 := I5,
        i6 := I6, i7 := I7, c36 := 36#64, c30 := 30#64, c25 := 25#64])
    (hd :
      [x16.i, sg0.i, x7.i, sg1.i, h.i, ch.i, s1.i, a.i, b.i, c.i, bc.i, d.i, e.i, f.i, g.i, i0.i,
          i1.i, i2.i, i3.i, i4.i, i5.i, i6.i, i7.i, c36.i, c30.i, c25.i, kk.i, t0.i, t1.i, t2.i,
          t3.i, t4.i, t5.i, t6.i, r0.i, r1.i, x0.i, r2.i, s0.i, y0.i, y1.i, mj.i, f0.i, f1.i, n0.i,
          n1.i, n2.i, n3.i, z.i, n4.i, n5.i, n6.i].Nodup)
    (hkf : Fits S.mem KP 64) (hk : S.mem.readAt KP 64 = Sha512.K[t]!)
    (hacc : rounds Wf t #v[I0, I1, I2, I3, I4, I5, I6, I7] = #v[A, B, C, D, Ee, F, G, Hh])
    (hsch : Wf t = Sha512.sigma1 X2 + X7 + Sha512.sigma0 X15 + X16)
    (hK :
      ∀ N0 N1 N2 N3 N4 N5 N6 N7 : BitVec 64,
        #v[N0, N1, N2, N3, N4, N5, N6, N7] =
            Vector.zipWith (· + ·) #v[I0, I1, I2, I3, I4, I5, I6, I7]
              (rounds Wf (t + 1) #v[I0, I1, I2, I3, I4, I5, I6, I7]) →
          ∀ vkk vt0 vt1 vt2 vt3 vt4 vt5 vt6 vr0 vr1 vx0 vr2 vs0 vy0 vy1 vmj vf0 vf1 vz : ⟦.bv 64⟧,
            (blk.runBodyFrom
                  E[kk := vkk, t0 := vt0, t1 := vt1, t2 := vt2, t3 := vt3, t4 := vt4, t5 := vt5,
                    t6 := vt6, r0 := vr0, r1 := vr1, x0 := vx0, r2 := vr2, s0 := vs0, y0 := vy0,
                    y1 := vy1, mj := vmj, f0 := vf0, f1 := vf1, n0 := .value N0, n1 := .value N1,
                    n2 := .value N2, n3 := .value N3, z := vz, n4 := .value N4, n5 := .value N5,
                    n6 := .value N6, n7 := .value N7]
                  (pos + 27) S >>=
                κ) =
              K) :
    (blk.runBodyFrom E pos S >>= κ) = K := by
  step_load
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
  step_pure [sig0_code]
  step_pure
  step_pure
  step_pure [maj_code]
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
  subst hS
  rw [hE]
  apply hK
  rw [rounds_succ, hacc]
  exact
    final_eq
      (by
        rw [hsch]; ac_rfl)

end

public meta section

open Lean Elab Tactic Meta in
/-- `name_acc h`: the newest equation about `rounds` named `h`, the older ones cleared. A search by
type would unify against every read fact, whose deep registers' types unfold the context. -/
elab "name_acc " h:ident : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    let mut found := false
    for d in (← getLCtx).decls.toArray.reverse do
      let some d := d | continue
      if d.isImplementationDetail then
        continue
      let ty ← instantiateMVars d.type
      unless ty.isEq && (ty.find? (·.isConstOf ``rounds)).isSome do
        continue
      if found then
        g ← g.tryClear d.fvarId
      else
        g ← g.rename d.fvarId h.getId
        found := true
    unless found do
      throwError "name_acc: no `rounds` fact"
    replaceMainGoal [g]

end

end MLIR.Agave