module

public import Ed25519.Encode
public import Firedancer.Math.Curve
import all Firedancer.Math.Curve
public import Firedancer.Math.Encode
public import Firedancer.Ref.fd_ed25519_point_add
public import Firedancer.Ref.fd_ed25519_point_sub
import Mathlib.Tactic.LinearCombination

/-! Points as the curve syscalls hold them, `Rep A P`, and `fd_ed25519_point_add`/`_sub`/`_frombytes`/
`_tobytes` on them: `P + Q`, `P - Q`, RFC 8032 decoding and encoding. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519

/-! ## Representatives -/

@[expose] public section

/-- `A` represents `P` in extended coordinates, `X` within `2p`'s limbs and `Y`, `T`, `Z` tight:
what `frombytes` and the point operations produce. -/
def _root_.MLIR.PointLimbs.Rep (A : PointLimbs) (P : Ed25519.Point) : Prop :=
  A.Ext P.x P.y ∧ Limbs.Under2p A.X ∧ Limbs.Tight A.Y ∧ Limbs.Tight A.T ∧ Limbs.Tight A.Z

end

/-- Tight extended coordinates represent. -/
public theorem _root_.MLIR.PointLimbs.Rep.of_tight {A : PointLimbs} {P : Ed25519.Point}
    (h : A.Ext P.x P.y) (t : A.Tight) : A.Rep P :=
  ⟨h, t.1.under2p, t.2.1, t.2.2.1, t.2.2.2⟩

/-- `set_zero` represents `0`. -/
public theorem fd_ed25519_point_set_zero.spec_rep : fd_ed25519_point_set_zero.spec.Rep 0 :=
  .of_tight fd_ed25519_point_set_zero.spec_ext.1 fd_ed25519_point_set_zero.spec_ext.2

/-! ## Addition and subtraction -/

/-- `add_with_opts` without options or its last multiplications, on representatives:
`P + Q` completed, loose. -/
theorem fd_ed25519_point_add_with_opts.compl_rep {A B : PointLimbs} {P Q : Ed25519.Point}
    (hA : A.Rep P) (hB : B.Rep Q) :
    let R := fd_ed25519_point_add_with_opts.spec A B 0#32 0#32 1#32
    R.Compl (P + Q).x (P + Q).y ∧ R.Loose := by
  obtain ⟨eA, hAX, hAY, hAT, hAZ⟩ := hA
  obtain ⟨eB, hBX, hBY, hBT, hBZ⟩ := hB
  obtain ⟨d₁, d₂, eX, eT⟩ := Ed25519.add_compl eA eB P.on Q.on
  obtain ⟨⟨v7, b7⟩, ⟨v8, b8⟩⟩ :=
    fd_ed25519_point_add_with_opts.r78 (A := A) (B := B) (zOne := 0#32) (pre := 0#32) (X :=
      Limbs.val B.X) (Y := Limbs.val B.Y) (T := Limbs.val B.T) (Z := Limbs.val B.Z) (by simp)
      (by simp) hAT.loose hAZ hBT.loose hBZ.loose
  simp only [ite_true] at v7 b7 v8 b8
  obtain ⟨v1, b1⟩ := fd_f25519_sub_nr.spec_wide hAY hAX
  obtain ⟨v3, b3⟩ := fd_f25519_add_nr.spec_wide hAY hAX
  obtain ⟨v2, b2⟩ := fd_f25519_sub_nr.spec_wide hBY hBX
  obtain ⟨v4, b4⟩ := fd_f25519_add_nr.spec_wide hBY hBX
  obtain ⟨v5, b5⟩ := fd_f25519_mul.spec_val b1 b2
  obtain ⟨v6, b6⟩ := fd_f25519_mul.spec_val b3 b4
  rw [v1, v2] at v5
  rw [v3, v4] at v6
  simp only [fd_ed25519_point_add_with_opts.spec, fd_ed25519_point_add_with_opts.last, ite_true,
    show (1#32 = 0#32) = False by decide, ite_false]
  obtain ⟨vX, bX⟩ := fd_f25519_sub_nr.spec_val b6 b5
  obtain ⟨vY, bY⟩ := fd_f25519_sub_nr.spec_val b8 b7
  obtain ⟨vZ, bZ⟩ := fd_f25519_add_nr.spec_val b8 b7
  obtain ⟨vT, bT⟩ := fd_f25519_add_nr.spec_val b6 b5
  refine ⟨⟨?_, ?_, ?_, ?_⟩, bX, bY, bT, bZ⟩ <;> simp only [vX, vY, vZ, vT, v5, v6, v7, v8]
  · exact d₁
  · exact d₂
  · exact eX
  · exact eT

/-- `sub_with_opts` without options or its last multiplications, on representatives:
`P - Q` completed, loose. -/
theorem fd_ed25519_point_sub_with_opts.compl_rep {A B : PointLimbs} {P Q : Ed25519.Point}
    (hA : A.Rep P) (hB : B.Rep Q) :
    let R := fd_ed25519_point_sub_with_opts.spec A B 0#32 0#32 1#32
    R.Compl (P - Q).x (P - Q).y ∧ R.Loose := by
  obtain ⟨eA, hAX, hAY, hAT, hAZ⟩ := hA
  obtain ⟨eB, hBX, hBY, hBT, hBZ⟩ := hB
  obtain ⟨d₁, d₂, eX, eT⟩ := Ed25519.add_compl eA eB.neg P.on Q.on.neg
  obtain ⟨⟨v7, b7⟩, ⟨v8, b8⟩⟩ :=
    fd_ed25519_point_add_with_opts.r78 (A := A) (B := B) (zOne := 0#32) (pre := 0#32) (X :=
      Limbs.val B.X) (Y := Limbs.val B.Y) (T := Limbs.val B.T) (Z := Limbs.val B.Z) (by simp)
      (by simp) hAT.loose hAZ hBT.loose hBZ.loose
  simp only [ite_true] at v7 b7 v8 b8
  obtain ⟨v1, b1⟩ := fd_f25519_sub_nr.spec_wide hAY hAX
  obtain ⟨v3, b3⟩ := fd_f25519_add_nr.spec_wide hAY hAX
  obtain ⟨v2, b2⟩ := fd_f25519_add_nr.spec_wide hBY hBX
  obtain ⟨v4, b4⟩ := fd_f25519_sub_nr.spec_wide hBY hBX
  obtain ⟨v5, b5⟩ := fd_f25519_mul.spec_val b1 b2
  obtain ⟨v6, b6⟩ := fd_f25519_mul.spec_val b3 b4
  rw [v1, v2] at v5
  rw [v3, v4] at v6
  simp only [fd_ed25519_point_sub_with_opts.spec, fd_ed25519_point_sub_with_opts.last, ite_true,
    show (1#32 = 0#32) = False by decide, ite_false]
  obtain ⟨vX, bX⟩ := fd_f25519_sub_nr.spec_val b6 b5
  obtain ⟨vY, bY⟩ := fd_f25519_add_nr.spec_val b8 b7
  obtain ⟨vZ, bZ⟩ := fd_f25519_sub_nr.spec_val b8 b7
  obtain ⟨vT, bT⟩ := fd_f25519_add_nr.spec_val b6 b5
  refine ⟨⟨?_, ?_, ?_, ?_⟩, bX, bY, bT, bZ⟩ <;>
    simp only [vX, vY, vZ, vT, v5, v6, v7, v8, Point.sub_x, Point.sub_y]
  · exact fun h => d₁ (by linear_combination h)
  · exact fun h => d₂ (by linear_combination h)
  · linear_combination eX
  · linear_combination eT

/-- `fd_ed25519_point_add` on representatives of `P` and `Q`: `P + Q`, tight. -/
public theorem fd_ed25519_point_add.spec_rep {A B : PointLimbs} {P Q : Ed25519.Point} (hA : A.Rep P)
    (hB : B.Rep Q) :
    (fd_ed25519_point_add.spec A B).Ext (P + Q).x (P + Q).y ∧
      (fd_ed25519_point_add.spec A B).Tight := by
  obtain ⟨hc, bX, bY, bT, bZ⟩ := fd_ed25519_point_add_with_opts.compl_rep hA hB
  have := fd_ed25519_point_add_final_mul.spec_ext hc bX bY bT bZ
  simpa [fd_ed25519_point_add.spec, fd_ed25519_point_add_with_opts.spec,
    fd_ed25519_point_add_with_opts.last] using this

/-- `fd_ed25519_point_sub` on representatives of `P` and `Q`: `P - Q`, tight. -/
public theorem fd_ed25519_point_sub.spec_rep {A B : PointLimbs} {P Q : Ed25519.Point} (hA : A.Rep P)
    (hB : B.Rep Q) :
    (fd_ed25519_point_sub.spec A B).Ext (P - Q).x (P - Q).y ∧
      (fd_ed25519_point_sub.spec A B).Tight := by
  obtain ⟨hc, bX, bY, bT, bZ⟩ := fd_ed25519_point_sub_with_opts.compl_rep hA hB
  have := fd_ed25519_point_add_final_mul.spec_ext hc bX bY bT bZ
  simpa [fd_ed25519_point_sub.spec, fd_ed25519_point_sub_with_opts.spec,
    fd_ed25519_point_sub_with_opts.last] using this

/-- `fd_ed25519_point_add` represents `P + Q`. -/
public theorem fd_ed25519_point_add.rep {A B : PointLimbs} {P Q : Ed25519.Point} (hA : A.Rep P)
    (hB : B.Rep Q) : (fd_ed25519_point_add.spec A B).Rep (P + Q) :=
  .of_tight (fd_ed25519_point_add.spec_rep hA hB).1 (fd_ed25519_point_add.spec_rep hA hB).2

/-- `fd_ed25519_point_sub` represents `P - Q`. -/
public theorem fd_ed25519_point_sub.rep {A B : PointLimbs} {P Q : Ed25519.Point} (hA : A.Rep P)
    (hB : B.Rep Q) : (fd_ed25519_point_sub.spec A B).Rep (P - Q) :=
  .of_tight (fd_ed25519_point_sub.spec_rep hA hB).1 (fd_ed25519_point_sub.spec_rep hA hB).2

/-! ## Decoding and encoding -/

/-- `frombytes` fails exactly when `buf` decodes to no point. -/
public theorem fd_ed25519_point_frombytes.spec_eq_none_iff_decode (buf : BitVec 256) :
    fd_ed25519_point_frombytes.spec buf = none ↔ Ed25519.decode buf = none := by
  rw [fd_ed25519_point_frombytes.spec_eq_none_iff, Ed25519.decode_eq_none]
  have := Ed25519.exists_decodes_iff buf
  constructor
  · exact fun h P hP => this.1 ⟨P, hP⟩ |>.elim fun x hx => h x hx
  · exact fun h x hx => (this.2 ⟨x, hx⟩).elim fun P hP => h P hP

/-- A point `frombytes` decodes represents `decode buf`, with `Z = 1`. -/
public theorem fd_ed25519_point_frombytes.spec_rep {buf : BitVec 256} {A : PointLimbs}
    (h : fd_ed25519_point_frombytes.spec buf = some A) :
    ∃ P, Ed25519.decode buf = some P ∧ A.Rep P ∧ Limbs.val A.Z = 1 := by
  obtain ⟨x, hE, hc, hs, hZ, hX, -, hY, hT, hZt⟩ := fd_ed25519_point_frombytes.spec_some h
  exact ⟨⟨x, _, hc⟩, Ed25519.decode_eq_some ⟨rfl, hs⟩, ⟨hE, hX, hY, hT, hZt⟩, hZ⟩

/-- The ref `tobytes` on a representative of `P`: `P`'s encoding. -/
public theorem fd_ed25519_point_tobytes.spec_rep {A : PointLimbs} {P : Ed25519.Point}
    (hA : A.Rep P) : fd_ed25519_point_tobytes.spec A = Ed25519.encode P :=
  fd_ed25519_point_tobytes.spec_eq hA.1 hA.2.1.loose hA.2.2.1.loose hA.2.2.2.2.loose

/-- The s2n `tobytes` on a representative of `P`: `P`'s encoding. -/
public theorem fd_ed25519_point_tobytes.s2n_rep {A : PointLimbs} {P : Ed25519.Point}
    (hA : A.Rep P) : fd_ed25519_point_tobytes.s2n A = Ed25519.encode P :=
  fd_ed25519_point_tobytes.s2n_eq hA.1 hA.2.1.loose hA.2.2.1.loose hA.2.2.2.2

end MLIR.Firedancer.Ref
