module

public import Ed25519.Scalar
public import Firedancer.Math.Msm
public import Firedancer.Math.Scalar
public import Firedancer.Ref.multi_scalar_mul_edwards
import Mathlib.Algebra.BigOperators.Intervals

/-! The edwards25519 syscall helper `multi_scalar_mul_edwards`: `NULL` on an invalid scalar or an
undecodable point, else `Σ sⱼ decode(Pⱼ)`; and the add/sub/mul paths as the syscall composes them. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519

namespace multi_scalar_mul_edwards

/-- One more point to decode. -/
theorem decode_succ (points : ℕ → BitVec 256) (b : ℕ) :
    decode points (b + 1) =
      (decode points b).bind fun A =>
        (fd_ed25519_point_frombytes.spec (points b)).map fun P k => if k = b then P else A k := by
  simp only [decode, List.range_succ, List.foldlM_append, List.foldlM_cons, List.foldlM_nil,
    bind_pure]
  rfl

/-- `decode` fails exactly when one of the first `b` points does not decode. -/
theorem decode_eq_none_iff (points : ℕ → BitVec 256) (b : ℕ) :
    decode points b = none ↔ ∃ j < b, Ed25519.decode (points j) = none := by
  induction b with
  | zero =>
    simp only [Nat.not_lt_zero, false_and, exists_false, iff_false, decode, List.range_zero,
      List.foldlM_nil]
    exact Option.some_ne_none _
  | succ b ih =>
    rw [decode_succ]
    rcases h : decode points b with _ | A
    · simp only [Option.bind_none, true_iff]
      obtain ⟨j, hj, hn⟩ := ih.1 h
      exact ⟨j, by omega, hn⟩
    · rw [h] at ih
      simp only [reduceCtorEq, false_iff, not_exists, not_and] at ih
      rw [Option.bind_some, Option.map_eq_none_iff,
        fd_ed25519_point_frombytes.spec_eq_none_iff_decode]
      constructor
      · exact fun hn => ⟨b, by omega, hn⟩
      · rintro ⟨j, hj, hn⟩
        by_cases hjb : j = b
        · rw [← hjb]
          exact hn
        · exact absurd hn (ih j (by omega))

/-- A successful `decode`: entry `j < b` is what `frombytes` gives for point `j`. -/
theorem decode_eq_some (points : ℕ → BitVec 256) :
    ∀ b {A},
      decode points b = some A → ∀ j < b, fd_ed25519_point_frombytes.spec (points j) = some (A j)
  | 0, _, _, _, hj => absurd hj (by omega)
  | b + 1, A, h, j, hj => by
    rw [decode_succ] at h
    rcases h' : decode points b with _ | A'
    · rw [h', Option.bind_none] at h
      cases h
    · rw [h', Option.bind_some, Option.map_eq_some_iff] at h
      obtain ⟨P, hP, rfl⟩ := h
      by_cases hjb : j = b
      · subst hjb
        show _ = some (if j = j then P else A' j)
        rw [ite_eq_left_of_eq_true _ _ (eq_true rfl)]
        exact hP
      · show _ = some (if j = b then P else A' j)
        rw [ite_eq_right_of_eq_false _ _ (eq_false hjb)]
        exact decode_eq_some points b h' j (by omega)

/-- `(nⱼ mod 2^255)` for validated scalars is `nⱼ`. -/
theorem mod_of_valid {s : BitVec 256} (h : fd_curve25519_scalar_validate.spec s = true) :
    s.toNat % 2 ^ 255 = s.toNat :=
  Nat.mod_eq_of_lt
    (((fd_curve25519_scalar_validate.spec_iff s).1 h).trans (Ed25519.ell_lt.trans (by decide)))

/-- The batch loop from `i` (a multiple of 32) on a representative of `R`, points `j < j₀` decoding
to `D j` and point `j₀` failing unless `j₀ = cnt`: with `j₀ = cnt`, the full sum; else `NULL`,
`*r` the sum over the batches before `j₀`'s. -/
theorem loop_spec {cnt j₀ : ℕ} {S Pts : ℕ → BitVec 256} {D : ℕ → Ed25519.Point}
    (hcnt : cnt < 2 ^ 64) (hj₀ : j₀ ≤ cnt) (hD : ∀ j < j₀, Ed25519.decode (Pts j) = some (D j))
    (hfail : j₀ < cnt → Ed25519.decode (Pts j₀) = none) :
    ∀ k i (sc pt : ℕ → BitVec 256) {r : PointLimbs} {R : Ed25519.Point},
      cnt ≤ i + 32 * k →
        i % 32 = 0 →
        (i ≤ j₀ ∨ j₀ = cnt) →
        (i < cnt → sc = (fun j => S (i + j)) ∧ pt = fun j => Pts (i + j)) →
        r.Rep R →
        if j₀ = cnt then
          (loop cnt k i sc pt r).ret = some (loop cnt k i sc pt r).r ∧
            (loop cnt k i sc pt r).r.Rep (R + ∑ j ∈ Finset.Ico i cnt, ((S j).toNat % 2 ^ 255) • D j)
        else
          (loop cnt k i sc pt r).ret = none ∧
            (loop cnt k i sc pt r).r.Rep
              (R + ∑ j ∈ Finset.Ico i (32 * (j₀ / 32)), ((S j).toNat % 2 ^ 255) • D j)
  | k, i, sc, pt, r, R, hk, hi32, hij, hsp, hr => by
    by_cases hi : i < cnt
    · obtain ⟨rfl, rfl⟩ := hsp hi
      obtain ⟨k, rfl⟩ : ∃ k', k = k' + 1 :=
        ⟨k - 1, by
          rcases k with _ | k
          · omega
          · rfl⟩
      rw [loop, ite_eq_left_of_eq_true _ _ (eq_true hi)]
      dsimp only
      unfold fd_ed25519_multi_scalar_mul.BATCH_SZ
      by_cases hfb : j₀ < i + min (cnt - i) 32
      · -- `j₀`'s batch: `NULL`
        have hjc : j₀ ≠ cnt := by omega
        have hij' : i ≤ j₀ := hij.resolve_right hjc
        have hnone : decode (fun j => Pts (i + j)) (min (cnt - i) 32) = none :=
          (decode_eq_none_iff _ _).2
            ⟨j₀ - i, by omega, by
              rw [Nat.add_sub_cancel' hij']; exact hfail (by omega)⟩
        rw [hnone, ite_eq_right_of_eq_false _ _ (eq_false hjc)]
        refine ⟨rfl, ?_⟩
        rw [Finset.Ico_eq_empty_of_le (by omega), Finset.sum_empty, add_zero]
        exact hr
      · -- the whole batch decodes
        obtain ⟨A, hA⟩ : ∃ A, decode (fun j => Pts (i + j)) (min (cnt - i) 32) = some A := by
          rcases h : decode (fun j => Pts (i + j)) (min (cnt - i) 32) with _ | A
          · obtain ⟨j, hj, hn⟩ := (decode_eq_none_iff _ _).1 h
            rw [hD (i + j) (by omega)] at hn
            cases hn
          · exact ⟨A, rfl⟩
        have hb : (BitVec.ofNat 64 (min (cnt - i) 32)).toNat = min (cnt - i) 32 := by
          rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
        have hArep (j) (hj : j < (BitVec.ofNat 64 (min (cnt - i) 32)).toNat) :
          (A j).Rep (D (i + j)) ∧ Limbs.val (A j).Z = 1 := by
          rw [hb] at hj
          obtain ⟨P, hP, hR, hZ⟩ := fd_ed25519_point_frombytes.spec_rep (decode_eq_some _ _ hA j hj)
          rw [hD (i + j) (by omega), Option.some.injEq] at hP
          exact ⟨hP ▸ hR, hZ⟩
        rw [hA]
        dsimp only
        have hr' :=
          fd_ed25519_point_add.rep hr
            (fd_ed25519_multi_scalar_mul.spec_rep (fun j => S (i + j)) A _ hArep)
        have ih :=
          loop_spec hcnt hj₀ hD hfail k (i + 32) (fun j => S (i + (min (cnt - i) 32 + j)))
            (fun j => Pts (i + (min (cnt - i) 32 + j))) (by omega) (by omega) (by omega)
            (fun h =>
              ⟨funext fun j => by
                  congr 1; omega,
                funext fun j => by
                  congr 1; omega⟩)
            hr'
        have hs :=
          Finset.sum_Ico_eq_sum_range (fun j => ((S j).toNat % 2 ^ 255) • D j) i
            (i + min (cnt - i) 32)
        rw [Nat.add_sub_cancel_left] at hs
        rw [hb, add_assoc, ← hs] at ih
        by_cases hjc : j₀ = cnt
        · rw [ite_eq_left_of_eq_true _ _ (eq_true hjc)] at ih ⊢
          refine ⟨ih.1, (congrArg _ ?_).mp ih.2⟩
          by_cases hl : cnt ≤ i + 32
          · rw [show i + min (cnt - i) 32 = cnt by omega,
              Finset.Ico_eq_empty_of_le (show cnt ≤ i + 32 from hl), Finset.sum_empty, add_zero]
          · rw [show i + min (cnt - i) 32 = i + 32 by omega,
              Finset.sum_Ico_consecutive _ (by omega) (by omega)]
        · rw [ite_eq_right_of_eq_false _ _ (eq_false hjc)] at ih ⊢
          refine ⟨ih.1, (congrArg _ ?_).mp ih.2⟩
          have h32 : i + 32 ≤ 32 * (j₀ / 32) := by omega
          rw [show i + min (cnt - i) 32 = i + 32 by omega, add_assoc,
            Finset.sum_Ico_consecutive _ (show i ≤ i + 32 by omega) h32]
    · have hjc : j₀ = cnt := by omega
      have hl : (loop cnt k i sc pt r) = ⟨r, some r⟩ := by
        rcases k with _ | k
        · rfl
        · rw [loop, ite_eq_right_of_eq_false _ _ (eq_false hi)]
      rw [ite_eq_left_of_eq_true _ _ (eq_true hjc), hl]
      refine ⟨rfl, ?_⟩
      rw [Finset.Ico_eq_empty_of_le (by omega), Finset.sum_empty, add_zero]
      exact hr

end multi_scalar_mul_edwards

open multi_scalar_mul_edwards in
/-- An invalid scalar (`sⱼ ≥ ℓ`, `j < cnt`): `NULL`, `*r` untouched. -/
public theorem multi_scalar_mul_edwards.spec_invalid (r₀ : PointLimbs) (S Pts : ℕ → BitVec 256)
    (cnt : BitVec 64) (h : ∃ j < cnt.toNat, Ed25519.ell ≤ (S j).toNat) :
    multi_scalar_mul_edwards.spec r₀ S Pts cnt = ⟨r₀, none⟩ := by
  obtain ⟨j, hj, hs⟩ := h
  rw [multi_scalar_mul_edwards.spec, ite_eq_right_of_eq_false _ _ (eq_false ?_)]
  rw [Bool.not_eq_true, List.all_eq_false]
  refine ⟨j, List.mem_range.2 hj, ?_⟩
  rw [Bool.not_eq_true]
  cases hv : fd_curve25519_scalar_validate.spec (S j)
  · rfl
  · exact absurd ((fd_curve25519_scalar_validate.spec_iff _).1 hv) (by omega)

open multi_scalar_mul_edwards in
/-- Valid scalars, points `j < j₀` decoding to `D j`, point `j₀` failing unless `j₀ = cnt`: for
`j₀ = cnt` it returns `*r`, a representative of `Σ_{j<cnt} sⱼ D j`; else `NULL` with `*r` the
sum over the 32-point batches before `j₀`'s. -/
public theorem multi_scalar_mul_edwards.spec_valid (r₀ : PointLimbs) {S Pts : ℕ → BitVec 256}
    {cnt : BitVec 64} {j₀ : ℕ} {D : ℕ → Ed25519.Point}
    (hS : ∀ j < cnt.toNat, (S j).toNat < Ed25519.ell) (hj₀ : j₀ ≤ cnt.toNat)
    (hD : ∀ j < j₀, Ed25519.decode (Pts j) = some (D j))
    (hfail : j₀ < cnt.toNat → Ed25519.decode (Pts j₀) = none) :
    if j₀ = cnt.toNat then
      (multi_scalar_mul_edwards.spec r₀ S Pts cnt).ret =
          some (multi_scalar_mul_edwards.spec r₀ S Pts cnt).r ∧
        (multi_scalar_mul_edwards.spec r₀ S Pts cnt).r.Rep
          (∑ j ∈ Finset.range cnt.toNat, (S j).toNat • D j)
    else
      (multi_scalar_mul_edwards.spec r₀ S Pts cnt).ret = none ∧
        (multi_scalar_mul_edwards.spec r₀ S Pts cnt).r.Rep
          (∑ j ∈ Finset.range (32 * (j₀ / 32)), (S j).toNat • D j) := by
  have hv : ∀ j < cnt.toNat, fd_curve25519_scalar_validate.spec (S j) = true := fun j hj =>
    (fd_curve25519_scalar_validate.spec_iff _).2 (hS j hj)
  have hall :
    ((List.range cnt.toNat).all fun i => fd_curve25519_scalar_validate.spec (S i)) = true :=
    List.all_eq_true.2 fun j hj => hv j (List.mem_range.1 hj)
  rw [multi_scalar_mul_edwards.spec, ite_eq_left_of_eq_true _ _ (eq_true hall)]
  have h :=
    loop_spec (S := S) (Pts := Pts) cnt.isLt hj₀ hD hfail (cnt.toNat / 32 + 1) 0 S Pts (by omega)
      rfl (.inl (Nat.zero_le _)) (fun _ => ⟨by simp, by simp⟩) fd_ed25519_point_set_zero.spec_rep
  have hsum (m : ℕ) (hm : m ≤ cnt.toNat) :
    (0 : Ed25519.Point) + ∑ j ∈ Finset.Ico 0 m, ((S j).toNat % 2 ^ 255) • D j =
      ∑ j ∈ Finset.range m, (S j).toNat • D j := by
    rw [zero_add, ← Finset.range_eq_Ico]
    exact
      Finset.sum_congr rfl fun j hj => by
        rw [mod_of_valid
            (hv j
              (by
                have := Finset.mem_range.1 hj; omega))]
  by_cases hjc : j₀ = cnt.toNat
  · rw [ite_eq_left_of_eq_true _ _ (eq_true hjc)] at h ⊢
    rw [hsum _ le_rfl] at h
    exact h
  · rw [ite_eq_right_of_eq_false _ _ (eq_false hjc)] at h ⊢
    rw [hsum _ (by omega)] at h
    exact h

/-- `multi_scalar_mul_edwards` returns `NULL` exactly when a scalar is invalid (`≥ ℓ`) or a point
does not decode, among the first `cnt`. -/
public theorem multi_scalar_mul_edwards.spec_ret_eq_none_iff (r₀ : PointLimbs)
    (S Pts : ℕ → BitVec 256) (cnt : BitVec 64) :
    (multi_scalar_mul_edwards.spec r₀ S Pts cnt).ret = none ↔
      (∃ j < cnt.toNat, Ed25519.ell ≤ (S j).toNat) ∨
        ∃ j < cnt.toNat, Ed25519.decode (Pts j) = none := by
  classical
  by_cases hS : ∃ j < cnt.toNat, Ed25519.ell ≤ (S j).toNat
  · simp only [multi_scalar_mul_edwards.spec_invalid r₀ S Pts cnt hS, hS, true_or]
  · have hS' : ∀ j < cnt.toNat, (S j).toNat < Ed25519.ell := fun j hj =>
      Nat.lt_of_not_le fun h => hS ⟨j, hj, h⟩
    simp only [hS, false_or]
    let D : ℕ → Ed25519.Point := fun j => (Ed25519.decode (Pts j)).getD 0
    by_cases hP : ∃ j < cnt.toNat, Ed25519.decode (Pts j) = none
    · simp only [hP, iff_true]
      have hex : ∃ j, j < cnt.toNat ∧ Ed25519.decode (Pts j) = none := hP
      have hmin := Nat.find_spec hex
      have hD : ∀ j < Nat.find hex, Ed25519.decode (Pts j) = some (D j) := fun j hj => by
        have := Nat.find_min hex hj
        rcases h : Ed25519.decode (Pts j) with _ | Q
        · exact absurd ⟨by omega, h⟩ this
        · simp [D, h]
      have := multi_scalar_mul_edwards.spec_valid r₀ hS' hmin.1.le hD fun _ => hmin.2
      rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega))] at this
      exact this.1
    · simp only [hP, iff_false]
      have hD : ∀ j < cnt.toNat, Ed25519.decode (Pts j) = some (D j) := fun j hj => by
        rcases h : Ed25519.decode (Pts j) with _ | Q
        · exact absurd ⟨j, hj, h⟩ hP
        · simp [D, h]
      have := multi_scalar_mul_edwards.spec_valid r₀ hS' le_rfl hD fun h => absurd h (by omega)
      rw [ite_eq_left_of_eq_true _ _ (eq_true rfl)] at this
      rw [this.1]
      exact Option.some_ne_none _

/-- Valid scalars and points decoding to `Qⱼ`: the helper returns `*r`, whose s2n and ref encodings
are `encode (Σ_{j<cnt} sⱼ Qⱼ)`. -/
public theorem multi_scalar_mul_edwards.spec_encode (r₀ : PointLimbs) {S Pts : ℕ → BitVec 256}
    {cnt : BitVec 64} {Q : ℕ → Ed25519.Point} (hS : ∀ j < cnt.toNat, (S j).toNat < Ed25519.ell)
    (hQ : ∀ j < cnt.toNat, Ed25519.decode (Pts j) = some (Q j)) :
    ∃ R,
      (multi_scalar_mul_edwards.spec r₀ S Pts cnt).ret = some R ∧
        R.Rep (∑ j ∈ Finset.range cnt.toNat, (S j).toNat • Q j) ∧
        fd_ed25519_point_tobytes.s2n R =
          Ed25519.encode (∑ j ∈ Finset.range cnt.toNat, (S j).toNat • Q j) ∧
        fd_ed25519_point_tobytes.spec R =
          Ed25519.encode (∑ j ∈ Finset.range cnt.toNat, (S j).toNat • Q j) := by
  have := multi_scalar_mul_edwards.spec_valid r₀ hS le_rfl hQ fun h => absurd h (by omega)
  rw [ite_eq_left_of_eq_true _ _ (eq_true rfl)] at this
  exact
    ⟨_, this.1, this.2, fd_ed25519_point_tobytes.s2n_rep this.2,
      fd_ed25519_point_tobytes.spec_rep this.2⟩

/-! ## The add, sub and mul paths

The syscall decodes its operands with `frombytes` (and validates a `MUL` scalar first), then
encodes the result with `tobytes`. -/

/-- `ADD`: two decoded points' sum, encoded (s2n and ref `tobytes`). -/
public theorem curve_group_op_add {L R : BitVec 256} {A B : PointLimbs}
    (hA : fd_ed25519_point_frombytes.spec L = some A)
    (hB : fd_ed25519_point_frombytes.spec R = some B) :
    ∃ P Q,
      Ed25519.decode L = some P ∧
        Ed25519.decode R = some Q ∧
        fd_ed25519_point_tobytes.s2n (fd_ed25519_point_add.spec A B) = Ed25519.encode (P + Q) ∧
        fd_ed25519_point_tobytes.spec (fd_ed25519_point_add.spec A B) = Ed25519.encode (P + Q) := by
  obtain ⟨P, hP, rA, -⟩ := fd_ed25519_point_frombytes.spec_rep hA
  obtain ⟨Q, hQ, rB, -⟩ := fd_ed25519_point_frombytes.spec_rep hB
  exact
    ⟨P, Q, hP, hQ, fd_ed25519_point_tobytes.s2n_rep (fd_ed25519_point_add.rep rA rB),
      fd_ed25519_point_tobytes.spec_rep (fd_ed25519_point_add.rep rA rB)⟩

/-- `SUB`: two decoded points' difference, encoded (s2n and ref `tobytes`). -/
public theorem curve_group_op_sub {L R : BitVec 256} {A B : PointLimbs}
    (hA : fd_ed25519_point_frombytes.spec L = some A)
    (hB : fd_ed25519_point_frombytes.spec R = some B) :
    ∃ P Q,
      Ed25519.decode L = some P ∧
        Ed25519.decode R = some Q ∧
        fd_ed25519_point_tobytes.s2n (fd_ed25519_point_sub.spec A B) = Ed25519.encode (P - Q) ∧
        fd_ed25519_point_tobytes.spec (fd_ed25519_point_sub.spec A B) = Ed25519.encode (P - Q) := by
  obtain ⟨P, hP, rA, -⟩ := fd_ed25519_point_frombytes.spec_rep hA
  obtain ⟨Q, hQ, rB, -⟩ := fd_ed25519_point_frombytes.spec_rep hB
  exact
    ⟨P, Q, hP, hQ, fd_ed25519_point_tobytes.s2n_rep (fd_ed25519_point_sub.rep rA rB),
      fd_ed25519_point_tobytes.spec_rep (fd_ed25519_point_sub.rep rA rB)⟩

/-- `MUL`: a valid scalar (`s < ℓ`) times a decoded point, encoded (s2n and ref `tobytes`). -/
public theorem curve_group_op_mul {s R : BitVec 256} {B : PointLimbs}
    (hs : fd_curve25519_scalar_validate.spec s = true)
    (hB : fd_ed25519_point_frombytes.spec R = some B) :
    ∃ Q,
      Ed25519.decode R = some Q ∧
        fd_ed25519_point_tobytes.s2n (fd_ed25519_scalar_mul.spec s B) =
          Ed25519.encode (s.toNat • Q) ∧
        fd_ed25519_point_tobytes.spec (fd_ed25519_scalar_mul.spec s B) =
          Ed25519.encode (s.toNat • Q) := by
  obtain ⟨Q, hQ, rB, hZ⟩ := fd_ed25519_point_frombytes.spec_rep hB
  have hlt : s.toNat < 2 ^ 255 :=
    ((fd_curve25519_scalar_validate.spec_iff s).1 hs).trans (Ed25519.ell_lt.trans (by decide))
  have h := fd_ed25519_scalar_mul.rep_of_lt rB hZ hlt
  exact ⟨Q, hQ, fd_ed25519_point_tobytes.s2n_rep h, fd_ed25519_point_tobytes.spec_rep h⟩

end MLIR.Firedancer.Ref
