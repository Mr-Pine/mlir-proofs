module

public import Ed25519.Group
public import Zig.Math.Point
public import Zig.Math.PointDbl
public import Zig.Math.Identity
public import Zig.Edwards25519_precompute
import Mathlib.Tactic.Abel

/-! `precompute(P, 8)`'s table: entry `i` represents `i • A`, for `P` representing `A`. -/

namespace MLIR.Zig

open _root_.Ed25519

/-- Entry `i` of `precompute(P, 8)` represents `i • A`, its limbs below `2^53`. -/
public theorem Edwards25519.precompute.spec_point {P : ZPt} {A : Point} (hP : P.Ext A.x A.y)
    (hPb : P.Lt (2 ^ 53)) (i : Fin 9) :
    ((Edwards25519.precompute.spec P)[i]).Ext (i.val • A).x (i.val • A).y ∧
      ((Edwards25519.precompute.spec P)[i]).Lt (2 ^ 53) := by
  have l53 {Q : ZPt} (h : Q.Lt (2 ^ 52)) : Q.Lt (2 ^ 53) := ZPt.Lt.mono53 h
  have dbl {Q : ZPt} {B : Point} (h : Q.Ext B.x B.y) (hb : Q.Lt (2 ^ 53)) :=
    Edwards25519.dbl.spec_point h hb.1 hb.2.1 hb.2.2.1
  have add {Q : ZPt} {B : Point} (h : Q.Ext B.x B.y) (hb : Q.Lt (2 ^ 53)) :=
    Edwards25519.add.spec_point h hP hb hPb
  obtain ⟨e2, b2⟩ := dbl hP hPb
  obtain ⟨e3, b3⟩ := add e2 (l53 b2)
  obtain ⟨e4, b4⟩ := dbl e2 (l53 b2)
  obtain ⟨e5, b5⟩ := add e4 (l53 b4)
  obtain ⟨e6, b6⟩ := dbl e3 (l53 b3)
  obtain ⟨e7, b7⟩ := add e6 (l53 b6)
  obtain ⟨e8, b8⟩ := dbl e4 (l53 b4)
  have h0 : Edwards25519.identity.Lt (2 ^ 53) := by
    refine ⟨?_, ?_, ?_, ?_⟩ <;> intro j <;> fin_cases j <;> decide
  have s (n : ℕ) (B : Point) (h : n • A = B) : (n • A).x = B.x ∧ (n • A).y = B.y := by
    subst h; exact ⟨rfl, rfl⟩
  fin_cases i <;> simp only [Edwards25519.precompute.spec, Fin.reduceFinMk, Fin.isValue]
  · rw [(s 0 0 (zero_smul _ _)).1, (s 0 0 (zero_smul _ _)).2]
    exact ⟨Edwards25519.identity_ext, h0⟩
  · rw [(s 1 A (one_smul _ _)).1, (s 1 A (one_smul _ _)).2]; exact ⟨hP, hPb⟩
  · rw [(s 2 (A + A) (by abel)).1, (s 2 (A + A) (by abel)).2]; exact ⟨e2, l53 b2⟩
  · rw [(s 3 (A + A + A) (by abel)).1, (s 3 (A + A + A) (by abel)).2]; exact ⟨e3, l53 b3⟩
  · rw [(s 4 (A + A + (A + A)) (by abel)).1, (s 4 (A + A + (A + A)) (by abel)).2]
    exact ⟨e4, l53 b4⟩
  · rw [(s 5 (A + A + (A + A) + A) (by abel)).1, (s 5 (A + A + (A + A) + A) (by abel)).2]
    exact ⟨e5, l53 b5⟩
  · rw [(s 6 (A + A + A + (A + A + A)) (by abel)).1, (s 6 (A + A + A + (A + A + A)) (by abel)).2]
    exact ⟨e6, l53 b6⟩
  · rw [(s 7 (A + A + A + (A + A + A) + A) (by abel)).1,
      (s 7 (A + A + A + (A + A + A) + A) (by abel)).2]
    exact ⟨e7, l53 b7⟩
  · rw [(s 8 (A + A + (A + A) + (A + A + (A + A))) (by abel)).1,
      (s 8 (A + A + (A + A) + (A + A + (A + A))) (by abel)).2]
    exact ⟨e8, l53 b8⟩

end MLIR.Zig
