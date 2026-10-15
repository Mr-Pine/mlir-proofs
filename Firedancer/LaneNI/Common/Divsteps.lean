module

public import Firedancer.Lane.Common.Jacobi
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The facts of `fd_f25519_posdivsteps_62_var`'s loop: from an odd `f` it keeps `f` and `g` odd and
`i` in `[1, 62]` while it runs, `|eta| + i` bounded, and every pass lowers `i`. -/

namespace MLIR.Firedancer.Lane.Jacobi

@[expose] public section

/-- The loop's invariant at its head: `f` and `g` odd, `i` in `[1, 62]`, `|eta| + i ≤ C`. -/
def Good (C : BitVec 64) (s : PD) : Prop :=
  s.f &&& 1 = 1 ∧ s.g &&& 1 = 1 ∧ 1#32 ≤ s.i ∧ s.i ≤ 62#32 ∧
    (s.eta + s.i.setWidth 64).sle C ∧ (-s.eta + s.i.setWidth 64).sle C ∧ s.eta.sle C ∧
      (-C).sle s.eta

end

/-- A pass, cancel then divide, lowers `i` and keeps the invariant while `i` stays nonzero. -/
public theorem good_step {C : BitVec 64} (hC : C.sle 1073741886#64) (hC0 : (0#64).sle C) {s : PD}
    (h : Good C s) :
    (s.cancel.divide).i < s.i ∧ ((s.cancel.divide).i ≠ 0 → Good C s.cancel.divide) := by
  obtain ⟨eta, f, g, u, v, q, r, i, j⟩ := s
  simp only [Good] at h ⊢
  unfold PD.cancel
  split
  all_goals
    simp only [PD.divide, intMin] at *
    bv_decide

/-- A shift amount below `64`: no poison. -/
public theorem not_le_toNat_of_lt64 {x : BitVec 64} (h : x < 64#64) : ¬64 ≤ x.toNat := by
  rw [BitVec.lt_def] at h
  simp only [BitVec.toNat_ofNat] at h
  omega

/-- `i` as the loop's shift amount: nonnegative, below `64`, `-1 << i` without signed overflow. -/
public theorem i_facts {C : BitVec 64} {s : PD} (h : Good C s) :
    s.i.toNat % 18446744073709551616 = s.i.toNat ∧ s.i.msb = false ∧ ¬64 ≤ s.i.toNat ∧
      (18446744073709551615#64 <<< s.i.toNat).sshiftRight s.i.toNat = 18446744073709551615#64 := by
  simp only [Good] at h
  have h1 : s.i.toNat ≤ 62 := by
    have := h.2.2.2.1
    rw [BitVec.le_def] at this
    simpa using this
  refine ⟨Nat.mod_eq_of_lt (by omega), ?_, by omega, ?_⟩ <;> bv_decide

/-- `-1 << i` keeps the loop's `find_lsb` argument nonzero. -/
public theorem shl_or_ne_zero {C : BitVec 64} {s : PD} (h : Good C s) (y : BitVec 64) :
    18446744073709551615#64 <<< s.i.toNat ||| y ≠ 0#64 := by
  simp only [Good] at h
  bv_decide

/-- `find_lsb`'s result of a nonzero word as a shift amount: nonnegative, below `64`. -/
public theorem z_facts {x : BitVec 64} (hx : x ≠ 0#64) :
    (x.ctz.setWidth 32).msb = false ∧ (x.ctz.setWidth 32).toNat % 18446744073709551616 =
      (x.ctz.setWidth 32).toNat ∧ ¬64 ≤ (x.ctz.setWidth 32).toNat := by
  have h : x.ctz.setWidth 32 < 64#32 := by bv_decide
  rw [BitVec.lt_def] at h
  simp only [BitVec.toNat_ofNat] at h
  refine ⟨by bv_decide, Nat.mod_eq_of_lt (by omega), by omega⟩

/-- The cancel's shift `64 - limit` for `eta < 0`: in `[2, 63]`. -/
public theorem lim_neg {C : BitVec 64} (hC : C.sle 1073741886#64) (hC0 : (0#64).sle C) {s : PD}
    (h : Good C s) (hn : s.eta.slt 0#64 = true) :
    (64#32 - (if (-s.eta.setWidth 32 + 1#32).slt s.i = true then -s.eta.setWidth 32 + 1#32
        else s.i)).msb = false ∧
      (64#32 - (if (-s.eta.setWidth 32 + 1#32).slt s.i = true then -s.eta.setWidth 32 + 1#32
        else s.i)).setWidth 64 < 64#64 := by
  simp only [Good] at h
  bv_decide

/-- The cancel's shift `64 - limit` for `eta ≥ 0`: in `[2, 63]`. -/
public theorem lim_nonneg {C : BitVec 64} (hC : C.sle 1073741886#64) (hC0 : (0#64).sle C) {s : PD}
    (h : Good C s) (hn : ¬s.eta.slt 0#64 = true) :
    (64#32 - (if (s.eta.setWidth 32 + 1#32).slt s.i = true then s.eta.setWidth 32 + 1#32
        else s.i)).msb = false ∧
      (64#32 - (if (s.eta.setWidth 32 + 1#32).slt s.i = true then s.eta.setWidth 32 + 1#32
        else s.i)).setWidth 64 < 64#64 := by
  simp only [Good] at h
  bv_decide

/-- A pass with `eta < 0` as compiled: swap, cancel, divide. -/
public theorem cancel_divide_neg (s : PD) (hn : s.eta.slt 0#64 = true) :
    s.cancel.divide =
      let lim :=
        if (-s.eta.setWidth 32 + 1#32).slt s.i = true then -s.eta.setWidth 32 + 1#32 else s.i
      let m := 18446744073709551615#64 >>> (BitVec.setWidth 64 (64#32 - lim)).toNat
      let w := s.g * s.f * (s.g * s.g + 62#64) &&& 63#64 &&& m
      let z := (18446744073709551615#64 <<< s.i.toNat ||| w * s.g + s.f).ctz.setWidth 32
      ⟨-s.eta - z.setWidth 64, s.g, (w * s.g + s.f) >>> z.toNat, s.q <<< z.toNat,
        s.r <<< z.toNat, w * s.q + s.u, w * s.r + s.v, s.i - z,
        z &&& (BitVec.setWidth 32 (s.g >>> 1) ^^^ BitVec.setWidth 32 (s.g >>> 2)) ^^^
          (s.j ^^^ BitVec.setWidth 32 ((s.g &&& s.f) >>> 1))⟩ := by
  obtain ⟨eta, f, g, u, v, q, r, i, j⟩ := s
  have hn' : eta.slt 0 = true := hn
  simp only [PD.cancel, hn', ite_true, PD.divide, intMin, PD.mk.injEq]
  and_intros <;> first | exact True.intro | bv_decide

/-- A pass with `eta ≥ 0` as compiled: cancel, divide. -/
public theorem cancel_divide_nonneg (s : PD) (hn : ¬s.eta.slt 0#64 = true) :
    s.cancel.divide =
      let lim := if (s.eta.setWidth 32 + 1#32).slt s.i = true then s.eta.setWidth 32 + 1#32 else s.i
      let m := 18446744073709551615#64 >>> (BitVec.setWidth 64 (64#32 - lim)).toNat
      let w := -(((s.f <<< 1 + 2#64 &&& 8#64) + s.f) * s.g) &&& 15#64 &&& m
      let z := (18446744073709551615#64 <<< s.i.toNat ||| w * s.f + s.g).ctz.setWidth 32
      ⟨s.eta - z.setWidth 64, s.f, (w * s.f + s.g) >>> z.toNat, s.u <<< z.toNat,
        s.v <<< z.toNat, w * s.u + s.q, w * s.v + s.r, s.i - z,
        z &&& (BitVec.setWidth 32 (s.f >>> 1) ^^^ BitVec.setWidth 32 (s.f >>> 2)) ^^^ s.j⟩ := by
  obtain ⟨eta, f, g, u, v, q, r, i, j⟩ := s
  have hn' : ¬eta.slt 0 = true := hn
  simp only [PD.cancel, hn', ite_false, PD.divide, intMin, PD.mk.injEq, Bool.false_eq_true]
  and_intros <;> first | exact True.intro | bv_decide

/-- The first divide's `zeros`, of `g` or-ed with the top two bits: at most `62`. -/
public theorem init_z (g : BitVec 64) :
    let x := g ||| 13835058055282163712#64
    let z := x.ctz.setWidth 32
    x ≠ 0#64 ∧ z.toNat ≤ 62 ∧ ¬(62#32).ssubOverflow z = true ∧ ¬64 ≤ (z.setWidth 64).toNat ∧
      1#64 <<< (z.setWidth 64).toNat >>> (z.setWidth 64).toNat = 1#64 := by
  intro x z
  have h : z ≤ 62#32 := by bv_decide
  rw [BitVec.le_def] at h
  simp only [BitVec.toNat_ofNat] at h
  have h' : (z.setWidth 64).toNat = z.toNat := by simp; omega
  refine ⟨by bv_decide, by omega, by bv_decide, by omega, ?_⟩
  bv_decide

/-- The first divide as compiled, `zeros` that of `g` or-ed with the top two bits. -/
public theorem init_divide (eta f g : BitVec 64) (j : BitVec 32) :
    (⟨eta, f, g, 1, 0, 0, 1, 62, j⟩ : PD).divide =
      let z := (g ||| 13835058055282163712#64).ctz.setWidth 32
      ⟨eta - z.setWidth 64, f, g >>> (z.setWidth 64).toNat, 1#64 <<< (z.setWidth 64).toNat, 0, 0,
        1, 62#32 - z,
        z &&& (BitVec.setWidth 32 (f >>> 1) ^^^ BitVec.setWidth 32 (f >>> 2)) ^^^ j⟩ := by
  simp only [PD.divide, PD.mk.injEq]
  and_intros <;> first | exact True.intro | bv_decide

/-- The first divide, from `i = 62` and an odd `f`, leaves the invariant if `i` stays nonzero,
for `|eta| ≤ B` and `C = B + 62`. -/
public theorem good_init {B eta f g u v q r : BitVec 64} {j : BitVec 32} (hB : B.sle 1073741824#64)
    (hB0 : (0#64).sle B) (hf : f &&& 1 = 1) (he : eta.sle B) (he' : (-B).sle eta) :
    let s : PD := ⟨eta, f, g, u, v, q, r, 62, j⟩
    s.divide.i ≠ 0 → Good (B + 62) s.divide := by
  simp only [Good, PD.divide]
  bv_decide

end MLIR.Firedancer.Lane.Jacobi
