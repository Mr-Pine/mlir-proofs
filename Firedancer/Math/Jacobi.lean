module

public import Ed25519.Field
public import Firedancer.Math.Posdivsteps
public import Firedancer.Math.UpdateFg
public import Firedancer.Ref.fd_f25519_jacobi_var
import Std.Tactic.BVDecide

/-! `fd_f25519_jacobi_var` returns the Jacobi symbol `J(x | p)` when it converges, `0` otherwise:
`J(G | F)` times the sign of `jac`'s bit 0 stays `J(x | p)` while `F` stays odd, and it stops at
`F = 1`. -/

namespace MLIR.Firedancer.Ref

open fd_f25519_update_fg_62_var

namespace fd_f25519_jacobi_var

/-- The loop invariant with `k` iterations left: `len` limbs below `2^62`, `F` odd, the signed
symbol `K`, `|eta| ≤ 1 + 62 (25 - k)`. -/
structure JInv (K : ℤ) (k : ℕ) (s : State) : Prop where
  len1 : 1 ≤ s.len.toNat
  len5 : s.len.toNat ≤ 5
  lf : Limbs62 s.f s.len.toNat
  lg : Limbs62 s.g s.len.toNat
  oF : val s.f % 2 = 1
  jac : jacobiSym (val s.g) (val s.f) * bitSign (s.jac.getLsbD 0) = K
  k25 : k ≤ 25
  eta : |s.eta.toInt| ≤ ((1 + 62 * (25 - k) : ℕ) : ℤ)

/-- `f[0] | (f[1] << 62)` is `F`'s low 64 bits. -/
theorem low64 (f : Vector (BitVec 64) 5) {L : ℕ} (h : Limbs62 f L) :
    (f[0] ||| (f[1] <<< 62)).toNat = val f % 2 ^ 64 := by
  have h0 : f[0].toNat < 2 ^ 62 := by simpa [limb] using h.1 0
  have e : f[0] ||| (f[1] <<< 62) = f[0] + (f[1] <<< 62) := by
    have : f[0] < BitVec.ofNat 64 (2 ^ 62) := by
      rw [BitVec.lt_def]; simpa using h0
    bv_decide
  rw [e, BitVec.toNat_add, BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
  unfold val
  simp only [Finset.sum_range_succ, Finset.range_zero, Finset.sum_empty, limb]
  simp only [Vector.getElem?_eq_getElem (by decide : 0 < 5),
    Vector.getElem?_eq_getElem (by decide : 1 < 5), Vector.getElem?_eq_getElem (by decide : 2 < 5),
    Vector.getElem?_eq_getElem (by decide : 3 < 5), Vector.getElem?_eq_getElem (by decide : 4 < 5),
    Option.getD_some]
  omega

/-- The `or` of limbs `1 .. m` is zero only if they all are. -/
theorem hi_fold_eq_zero (f : Vector (BitVec 64) 5) :
    ∀ m,
      (List.range' 1 m).foldl (fun hi j => hi ||| (f[j]?.getD 0)) 0#64 = 0#64 →
        ∀ j, 1 ≤ j → j < m + 1 → limb f j = 0
  | 0, _, j, h1, h2 => absurd h2 (by omega)
  | m + 1, h, j, h1, h2 => by
    rw [List.range'_concat, List.foldl_append, List.foldl_cons, List.foldl_nil,
      BitVec.or_eq_zero_iff] at h
    rcases Nat.lt_or_ge j (m + 1) with hj | hj
    · exact hi_fold_eq_zero f m h.1 j h1 hj
    · obtain rfl : j = 1 + 1 * m := by omega
      show (f[1 + 1 * m]?.getD 0).toNat = 0
      rw [h.2]; rfl

/-- `f[0] == 1` and `hi == 0`: `F = 1`. -/
theorem val_eq_one {f : Vector (BitVec 64) 5} {len : BitVec 32} (h1 : 1 ≤ len.toNat)
    (h5 : len.toNat ≤ 5) (hf : Limbs62 f len.toNat) (h0 : f[0] = 1#64) (hh : hi f len = 0#64) :
    val f = 1 := by
  have hlen : (len.toInt - 1).toNat = len.toNat - 1 := by
    rw [BitVec.toInt_eq_toNat_of_lt (by omega)]; omega
  unfold hi at hh
  rw [hlen] at hh
  have hz := hi_fold_eq_zero f _ hh
  rw [val_eq_sum (by omega) hf.2]
  obtain ⟨L, hL⟩ : ∃ L, len.toNat = L + 1 := ⟨len.toNat - 1, by omega⟩
  rw [hL, Finset.sum_range_succ']
  rw [Finset.sum_eq_zero fun k hk => by
      rw [hz (k + 1) (by omega)
          (by
            have := Finset.mem_range.1 hk; omega),
        zero_mul]]
  simp [limb, h0]

/-- The result `1 - 2 (jac & 1)`: `1` or `-1` by `jac`'s bit 0. -/
theorem result_eq (jac : BitVec 32) :
    1#32 - 2#32 * (jac &&& 1#32) = if jac.getLsbD 0 then -1#32 else 1#32 := by
  by_cases h : jac.getLsbD 0 = true
  · rw [ite_eq_left h]; bv_decide
  · rw [ite_eq_right h]; simp only [Bool.not_eq_true] at h; bv_decide

/-- The loop with `k` iterations left returns `0`, or `±1` equal to `K`. -/
theorem loop_spec {K : ℤ} :
    ∀ k (s : State),
      JInv K k s → loop k s = 0#32 ∨ (loop k s = 1#32 ∧ K = 1) ∨ (loop k s = -1#32 ∧ K = -1)
  | 0, s, _ => .inl rfl
  | k + 1, s, P => by
    have hE : 1 + 62 * (25 - (k + 1)) + 62 ≤ 2 ^ 30 := by omega
    obtain ⟨F₁, G₁, e1, e2, b1, b2, oF₁, jac₁, eta₁⟩ :=
      fd_f25519_posdivsteps_62_var.spec_val (E := 1 + 62 * (25 - (k + 1))) P.oF s.eta
        (s.f[0] ||| (s.f[1] <<< 62)) (s.g[0] ||| (s.g[1] <<< 62)) s.jac (low64 s.f P.lf)
        (low64 s.g P.lg) P.eta hE
    have hl5 := P.len5
    have hl1 := P.len1
    rw [loop]
    dsimp only
    generalize fd_f25519_posdivsteps_62_var.spec _ _ _ _ = res at e1 e2 b1 b2 jac₁ eta₁ ⊢
    have hF := val_lt P.len5 P.lf
    have hG := val_lt P.len5 P.lg
    have hbound (a b : BitVec 64) (X : ℕ) (hab : a.toNat + b.toNat ≤ 2 ^ 62)
      (he : a.toNat * val s.f + b.toNat * val s.g = 2 ^ 62 * X) : X < 2 ^ (62 * s.len.toNat) := by
      have h1 :
        a.toNat * val s.f + b.toNat * val s.g ≤
          (a.toNat + b.toNat) * (2 ^ (62 * s.len.toNat) - 1) := by
        rw [add_mul]
        exact Nat.add_le_add (Nat.mul_le_mul_left _ (by omega)) (Nat.mul_le_mul_left _ (by omega))
      have h2 := Nat.mul_le_mul_right (2 ^ (62 * s.len.toNat) - 1) hab
      have : 2 ^ 62 * X ≤ 2 ^ 62 * (2 ^ (62 * s.len.toNat) - 1) := by omega
      have := Nat.le_of_mul_le_mul_left this (by decide)
      have := Nat.one_le_two_pow (n := 62 * s.len.toNat)
      omega
    obtain ⟨⟨lf', vf'⟩, ⟨lg', vg'⟩⟩ :=
      fd_f25519_update_fg_62_var.spec_val rfl P.len1 P.len5 P.lf P.lg e1 e2 b1 b2
        (hbound _ _ _ b1 e1) (hbound _ _ _ b2 e2)
    generalize fd_f25519_update_fg_62_var.spec s.len s.f s.g res.t = fg at lf' vf' lg' vg' ⊢
    by_cases hd : fg.1[0] = 1#64 ∧ hi fg.1 s.len = 0#64
    · -- `f = 1`
      rw [ite_eq_left_of_eq_true _ _ (eq_true hd)]
      have h1 := val_eq_one P.len1 P.len5 lf' hd.1 hd.2
      rw [vf'] at h1
      subst h1
      rw [jacobiSym.one_right, one_mul, P.jac] at jac₁
      rw [result_eq]
      cases hb : res.jac.getLsbD 0
      · right; left;
        exact
          ⟨rfl, by
            rw [← jac₁, hb]; rfl⟩
      · right; right;
        exact
          ⟨rfl, by
            rw [← jac₁, hb]; rfl⟩
    · rw [ite_eq_right_of_eq_false _ _ (eq_false hd)]
      refine loop_spec k _ ?_
      have hjac : jacobiSym (val fg.2) (val fg.1) * bitSign (res.jac.getLsbD 0) = K := by
        rw [vf', vg', jac₁, P.jac]
      have heta : |res.eta.toInt| ≤ ((1 + 62 * (25 - k) : ℕ) : ℤ) := by
        have := P.k25
        refine eta₁.trans ?_
        push_cast [show 25 - (k + 1) + 1 = 25 - k by omega]
        omega
      split_ifs with hl
      · -- drop the top limb
        obtain ⟨hlt, hz⟩ := hl
        rw [BitVec.or_eq_zero_iff] at hz
        have hL2 : 2 ≤ s.len.toNat := by
          rw [BitVec.slt_iff_toInt_lt, BitVec.toInt_eq_toNat_of_lt (x := s.len) (by omega),
            show (1#32).toInt = 1 from rfl] at hlt
          omega
        have hlen : (s.len - 1#32).toNat = s.len.toNat - 1 := by
          rw [BitVec.toNat_sub, show (1#32).toNat = 1 from rfl]; omega
        have drop (v : Vector (BitVec 64) 5) (hv : Limbs62 v s.len.toNat)
          (h0 : v[(s.len - 1#32).toNat]?.getD 0 = 0#64) : Limbs62 v (s.len.toNat - 1) := by
          refine ⟨hv.1, fun j hj => ?_⟩
          rcases Nat.lt_or_ge j s.len.toNat with h | h
          · obtain rfl : j = (s.len - 1#32).toNat := by omega
            show (v[(s.len - 1#32).toNat]?.getD 0).toNat = 0
            rw [h0]; rfl
          · exact hv.2 j h
        have := P.k25
        exact
          ⟨by
            dsimp only; rw [hlen]; omega, by
            dsimp only; rw [hlen]; omega, by
            dsimp only; rw [hlen]; exact drop _ lf' hz.1, by
            dsimp only; rw [hlen]; exact drop _ lg' hz.2, by
            rw [vf']; exact oF₁, hjac, by omega, heta⟩
      · have := P.k25
        exact
          ⟨P.len1, P.len5, lf', lg', by
            rw [vf']; exact oF₁, hjac, by omega, heta⟩

/-- The modulus' limbs. -/
theorem p_limbs :
    let f : Vector (BitVec 64) 5 :=
      #v[(1#64 <<< 62) - 19#64, (1#64 <<< 62) - 1#64, (1#64 <<< 62) - 1#64, (1#64 <<< 62) - 1#64,
        127#64]
    Limbs62 f 5 ∧ val f = Ed25519.p := by
  intro f
  refine ⟨⟨fun k => ?_, fun k hk => limb_of_ge hk⟩, ?_⟩
  · rcases Nat.lt_or_ge k 5 with h | h
    · interval_cases k <;> decide
    · rw [limb_of_ge h]; exact Nat.two_pow_pos _
  · unfold val
    simp only [Finset.sum_range_succ, Finset.range_zero, Finset.sum_empty]
    decide

end fd_f25519_jacobi_var

open fd_f25519_jacobi_var in
/-- `jacobi_var` on 62-bit limbs (`x[4] < 2^62` too) of `X`: `0` (no convergence in 25 rounds), or
`±1`, the Jacobi symbol `J(X | p)`. -/
public theorem fd_f25519_jacobi_var.spec_val {x : Vector (BitVec 64) 5} (hx : Limbs62 x 5) :
    fd_f25519_jacobi_var.spec x = 0#32 ∨
      (fd_f25519_jacobi_var.spec x = 1#32 ∧ jacobiSym (val x) Ed25519.p = 1) ∨
      (fd_f25519_jacobi_var.spec x = -1#32 ∧ jacobiSym (val x) Ed25519.p = -1) := by
  obtain ⟨lp, vp⟩ := p_limbs
  have hg : (#v[x[0], x[1], x[2], x[3], x[4]] : Vector (BitVec 64) 5) = x := by
    ext i hi
    interval_cases i <;> rfl
  refine loop_spec 25 _ ⟨by simp, by simp, lp, ?_, ?_, ?_, le_rfl, ?_⟩
  · dsimp only; rw [hg]; exact hx
  · rw [vp]; decide
  · dsimp only
    rw [hg, vp]
    simp [bitSign]
  · show |(-1#64).toInt| ≤ _
    rw [show (-1#64).toInt = -1 from rfl]
    simp

end MLIR.Firedancer.Ref
