module

public import Firedancer.LaneNI.Common.Divsteps
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! What `posdivsteps` guarantees its caller: its matrix takes `[f0, g0]` to `2^62 [f, g]`
modulo `2^64`, `f` stays odd and `|eta|` grows by at most `62`. -/

namespace MLIR.Firedancer.Lane.Jacobi

@[expose] public section

/-- The transition matrix so far: `[u v; q r] [f0; g0] = 2^(62 - i) [f; g]` modulo `2^64`. -/
def Mat (f0 g0 : BitVec 64) (s : PD) : Prop :=
  s.u * f0 + s.v * g0 = s.f <<< (62 - s.i.toNat) ∧ s.q * f0 + s.r * g0 = s.g <<< (62 - s.i.toNat)

end

private theorem shl_mul (x y : BitVec 64) (k : Nat) : (x <<< k) * y = (x * y) <<< k := by
  simp only [BitVec.shiftLeft_eq_mul_twoPow]
  generalize BitVec.twoPow 64 k = T
  grind

/-- A divide keeps the matrix, for `i ≤ 62`. -/
public theorem mat_divide {f0 g0 : BitVec 64} {s : PD} (hi : s.i ≤ 62#32) (h : Mat f0 g0 s) :
    Mat f0 g0 s.divide := by
  obtain ⟨eta, f, g, u, v, q, r, i, j⟩ := s
  simp only [Mat, PD.divide] at h ⊢
  generalize hz : (g ||| BitVec.allOnes 64 <<< i.toNat).ctz = z
  have hzi : z.toNat ≤ i.toNat := by
    have : z ≤ i.setWidth 64 := by rw [← hz]; bv_decide
    rw [BitVec.le_def] at this
    have := i.isLt
    simp at *
    omega
  have hi' : i.toNat ≤ 62 := by
    rw [BitVec.le_def] at hi
    simpa using hi
  have hsub : (i - z.setWidth 32).toNat = i.toNat - z.toNat := by
    have : z.setWidth 32 ≤ i := by rw [← hz]; bv_decide
    rw [BitVec.toNat_sub_of_le this]
    have : z.toNat < 2 ^ 32 := by omega
    simp [Nat.mod_eq_of_lt this]
  have hg : (g >>> z.toNat) <<< z.toNat = g := by rw [← hz]; bv_decide
  rw [hsub, show 62 - (i.toNat - z.toNat) = (62 - i.toNat) + z.toNat by omega,
    BitVec.shiftLeft_add, BitVec.shiftLeft_add, ← h.1, shl_mul, shl_mul]
  refine ⟨?_, ?_⟩
  · simp only [BitVec.shiftLeft_eq_mul_twoPow]
    generalize BitVec.twoPow 64 z.toNat = T
    grind
  · rw [← BitVec.shiftLeft_add, Nat.add_comm, BitVec.shiftLeft_add, hg, h.2]

private theorem lin {u v q r f g f0 g0 T : BitVec 64} (h1 : u * f0 + v * g0 = f * T)
    (h2 : q * f0 + r * g0 = g * T) (w : BitVec 64) :
    (q + u * w) * f0 + (r + v * w) * g0 = (g + f * w) * T := by
  grind

/-- A cancel keeps the matrix. -/
public theorem mat_cancel {f0 g0 : BitVec 64} {s : PD} (h : Mat f0 g0 s) : Mat f0 g0 s.cancel := by
  obtain ⟨eta, f, g, u, v, q, r, i, j⟩ := s
  simp only [Mat] at h
  generalize hk : 62 - i.toNat = k at h
  obtain ⟨h1, h2⟩ := h
  simp only [BitVec.shiftLeft_eq_mul_twoPow] at h1 h2
  unfold PD.cancel
  split
  · simp only [Mat, hk, BitVec.shiftLeft_eq_mul_twoPow]
    exact ⟨h2, lin h2 h1 _⟩
  · simp only [Mat, hk, BitVec.shiftLeft_eq_mul_twoPow]
    exact ⟨h1, lin h1 h2 _⟩

/-- A pass that ends the loop leaves `f` odd and `|eta| ≤ C`. -/
public theorem exit_facts {C : BitVec 64} (hC : C.sle 1073741886#64) (hC0 : (0#64).sle C) {s : PD}
    (h : Good C s) (h0 : (s.cancel.divide).i = 0) :
    (s.cancel.divide).f &&& 1 = 1 ∧ (s.cancel.divide).eta.sle C ∧
      (-C).sle (s.cancel.divide).eta := by
  obtain ⟨eta, f, g, u, v, q, r, i, j⟩ := s
  simp only [Good] at h
  revert h0
  unfold PD.cancel
  split
  all_goals
    simp only [PD.divide, intMin] at *
    bv_decide

/-- A cancel keeps `i`. -/
public theorem cancel_i (s : PD) : s.cancel.i = s.i := by
  unfold PD.cancel
  split <;> rfl

/-- What the loop's exit satisfies: the matrix with `i = 0`, `f` odd, `|eta| ≤ C`. -/
public abbrev Exit (C f0 g0 : BitVec 64) (t : PD) : Prop :=
  Mat f0 g0 t ∧ t.i = 0 ∧ t.f &&& 1 = 1 ∧ t.eta.sle C ∧ (-C).sle t.eta

/-- The loop from a divided state `s` with `i ≤ n`: `pdLoop n s.cancel` exits as `Exit`. -/
public theorem pdLoop_exit {C f0 g0 : BitVec 64} (hC : C.sle 1073741886#64) (hC0 : (0#64).sle C) :
    ∀ n (s : PD), Good C s → s.i.toNat ≤ n → Mat f0 g0 s → Exit C f0 g0 (pdLoop n s.cancel) := by
  intro n
  induction n with
  | zero =>
    intro s hs hn
    have := hs.2.2.1
    rw [BitVec.le_def] at this
    simp at this
    omega
  | succ n ih =>
    intro s hs hn hm
    have hst := good_step hC hC0 hs
    have hm' : Mat f0 g0 s.cancel.divide := mat_divide (cancel_i s ▸ hs.2.2.2.1) (mat_cancel hm)
    rw [pdLoop.eq_2]
    by_cases h0 : (s.cancel.divide).i = 0
    · simp only [h0, ↓reduceIte]
      exact ⟨hm', h0, exit_facts hC hC0 hs h0⟩
    · simp only [h0, ↓reduceIte]
      refine ih _ (hst.2 h0) ?_ hm'
      have := hst.1
      rw [BitVec.lt_def] at this
      omega

/-- The first divide, from `|eta| ≤ B`, if it ends the loop: `f` odd, `|eta| ≤ B + 62`. -/
public theorem init_exit {B eta f g : BitVec 64} {j : BitVec 32} (hB : B.sle 1073741824#64)
    (hB0 : (0#64).sle B) (hf : f &&& 1 = 1) (he : eta.sle B) (he' : (-B).sle eta) :
    let s : PD := ⟨eta, f, g, 1, 0, 0, 1, 62, j⟩
    s.divide.i = 0 → s.divide.f &&& 1 = 1 ∧ s.divide.eta.sle (B + 62) ∧
      (-(B + 62)).sle s.divide.eta := by
  simp only [PD.divide]
  bv_decide

/-- `posdivsteps` from an odd `f0` and `|eta| ≤ B ≤ 2^30`: `[u v; q r] [f0; g0] = 2^62 [f; g]`
modulo `2^64`, `f` odd, `|eta| ≤ B + 62`. -/
public theorem posdivsteps_exit {B eta f0 g0 : BitVec 64} {j : BitVec 32}
    (hB : B.sle 1073741824#64) (hB0 : (0#64).sle B) (hf : f0 &&& 1 = 1) (he : eta.sle B)
    (he' : (-B).sle eta) : Exit (B + 62) f0 g0 (posdivsteps eta f0 g0 j) := by
  have hC : (B + 62).sle 1073741886#64 := by bv_decide
  have hC0 : (0#64).sle (B + 62) := by bv_decide
  have hm0 : Mat f0 g0 ⟨eta, f0, g0, 1, 0, 0, 1, 62, j⟩ := by
    simp [Mat]
  have hm := mat_divide (BitVec.le_refl _) hm0
  rw [posdivsteps, pdLoop.eq_2]
  by_cases h0 : (PD.divide ⟨eta, f0, g0, 1, 0, 0, 1, 62, j⟩).i = 0
  · simp only [h0, ↓reduceIte]
    exact ⟨hm, h0, init_exit hB hB0 hf he he' h0⟩
  · simp only [h0, ↓reduceIte]
    have hg := good_init hB hB0 hf he he' (g := g0) (u := 1) (v := 0) (q := 0) (r := 1) (j := j) h0
    refine pdLoop_exit hC hC0 62 _ hg ?_ hm
    have := hg.2.2.2.1
    rw [BitVec.le_def] at this
    simpa using this

private theorem sw_sext (a : BitVec 64) : (a.signExtend 128).setWidth 64 = a := by
  bv_decide

private theorem sw_mac (u v a b : BitVec 64) :
    (ext u * ext a + ext v * ext b).setWidth 64 = u * a + v * b := by
  rw [BitVec.setWidth_add _ _ (by omega), BitVec.setWidth_mul _ _ (by omega),
    BitVec.setWidth_mul _ _ (by omega)]
  simp only [ext, sw_sext]

private theorem bit_shr62 (X : BitVec 128) :
    (X.sshiftRight 62).setWidth 64 &&& 1#64 = X.setWidth 64 >>> 62 &&& 1#64 := by
  bv_decide

private theorem or_shl62 {a b : BitVec 64} (h : a < 4611686018427387904#64) :
    a ||| b <<< 62 = a + b <<< 62 := by
  bv_decide

private theorem split62 (u v a b c d : BitVec 64) :
    u * (a + b <<< 62) + v * (c + d <<< 62) = (u * a + v * c) + (u * b + v * d) <<< 62 := by
  simp only [BitVec.shiftLeft_eq_mul_twoPow]
  generalize BitVec.twoPow 64 62 = T
  grind

private theorem bits2 (P Q Y f : BitVec 64) (hm : P + Q <<< 62 = f <<< 62) (hf : f &&& 1 = 1)
    (hY : Y &&& 1#64 = P >>> 62 &&& 1#64) : ((Y + Q) &&& m62) &&& 1 = 1 := by
  bv_decide

private theorem bits1 (P Y f : BitVec 64) (hm : P = f <<< 62) (hf : f &&& 1 = 1)
    (hY : Y &&& 1#64 = P >>> 62 &&& 1#64) : Y &&& 1 = 1 := by
  bv_decide

/-- `update_fg`'s new `f[0]` is odd: the matrix takes the low words `[f0, g0]` to `2^62 [f, g]`
with `f` odd, and below `2^62` the bottom limbs make `f0`, `g0` without carries (`len ≥ 2`), or
the next limbs are zero (`len = 1`). -/
public theorem updateFg_f0_odd {len : Nat} (hl : 1 ≤ len ∧ len ≤ 5)
    {F G : Vector (BitVec 64) 5} {u v q r f : BitVec 64}
    (hm : u * (F[0] ||| F[1] <<< 62) + v * (G[0] ||| G[1] <<< 62) = f <<< 62)
    (hf : f &&& 1 = 1)
    (h2 : 2 ≤ len → F[0] < 4611686018427387904#64 ∧ G[0] < 4611686018427387904#64)
    (h1 : len = 1 → F[1] = 0#64 ∧ G[1] = 0#64) :
    (updateFg len F G u v q r).1[0] &&& 1 = 1 := by
  have hY := bit_shr62 (ext u * ext F[0] + ext v * ext G[0])
  rw [sw_mac] at hY
  have core1 : len = 1 →
      ((ext u * ext F[0] + ext v * ext G[0]).sshiftRight 62).setWidth 64 &&& 1 = 1 := by
    intro h
    obtain ⟨hF, hG⟩ := h1 h
    rw [hF, hG] at hm
    simp only [BitVec.zero_shiftLeft, BitVec.or_zero] at hm
    exact bits1 _ _ _ hm hf hY
  have core2 : 2 ≤ len →
      ((((ext u * ext F[0] + ext v * ext G[0]).sshiftRight 62).setWidth 64 +
        (u * F[1] + v * G[1])) &&& m62) &&& 1 = 1 := by
    intro h
    obtain ⟨hF, hG⟩ := h2 h
    rw [or_shl62 hF, or_shl62 hG, split62] at hm
    exact bits2 _ _ _ _ hm hf hY
  obtain rfl | rfl | rfl | rfl | rfl : len = 1 ∨ len = 2 ∨ len = 3 ∨ len = 4 ∨ len = 5 := by omega
  · have := core1 rfl
    simp [updateFg, updLoop]
    exact this
  all_goals
    have := core2 (by omega)
    simp [updateFg, updLoop]
    rw [BitVec.setWidth_add _ _ (by omega), sw_mac]
    exact this

/-- `update_fg`'s bottom limbs, for `len ≥ 2`, are masked to 62 bits. -/
public theorem updateFg_lo {len : Nat} (hl : 2 ≤ len ∧ len ≤ 5) (F G : Vector (BitVec 64) 5)
    (u v q r : BitVec 64) :
    (updateFg len F G u v q r).1[0] < 4611686018427387904#64 ∧
      (updateFg len F G u v q r).2[0] < 4611686018427387904#64 := by
  obtain rfl | rfl | rfl | rfl : len = 2 ∨ len = 3 ∨ len = 4 ∨ len = 5 := by omega
  all_goals
    constructor
    all_goals
      simp only [updateFg, updLoop, Vector.getElem_setIfInBounds]
      simp only [Nat.reduceAdd, Nat.reduceSub, Nat.reduceEqDiff, ↓reduceIte]
      bv_decide

/-- `update_fg` leaves the limbs from `len` on. -/
public theorem updateFg_above {len : Nat} (hl : 1 ≤ len ∧ len ≤ 5) (F G : Vector (BitVec 64) 5)
    (u v q r : BitVec 64) (k : Nat) (hk : len ≤ k) (hk5 : k < 5) :
    (updateFg len F G u v q r).1[k] = F[k] ∧ (updateFg len F G u v q r).2[k] = G[k] := by
  obtain rfl | rfl | rfl | rfl | rfl : len = 1 ∨ len = 2 ∨ len = 3 ∨ len = 4 ∨ len = 5 := by omega
  all_goals
    obtain rfl | rfl | rfl | rfl | rfl : k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 := by omega
    all_goals first | omega | simp [updateFg, updLoop]

/-- The bound on `|eta|` after `k` batches: `1 + 62 k`. -/
public abbrev bnd (k : Nat) : BitVec 64 :=
  BitVec.ofNat 64 (1 + 62 * k)

/-- Within 25 batches the bound stays below `2^30`. -/
public theorem bnd_le {k : Nat} (hk : k ≤ 25) :
    (bnd k).sle 1073741824#64 = true ∧ (0#64).sle (bnd k) = true := by
  simp only [bnd, BitVec.sle, decide_eq_true_eq, BitVec.toInt_eq_toNat_cond, BitVec.toNat_ofNat]
  have : (1 + 62 * k) % 2 ^ 64 = 1 + 62 * k := Nat.mod_eq_of_lt (by omega)
  simp only [this]
  constructor <;> split <;> split <;> omega

/-- A batch adds `62` to the bound. -/
public theorem bnd_succ (k : Nat) : bnd k + 62 = bnd (k + 1) := by
  apply BitVec.eq_of_toNat_eq
  simp
  omega

/-- `fd_f25519_jacobi_var`'s loop invariant after `k` batches: `len` in `[1, 5]`, `f[0]` odd, the
bottom limbs below `2^62` (`len ≥ 2`) or the next ones zero (`len = 1`), `|eta| ≤ 1 + 62 k`. -/
@[expose] public def JInv (k : Nat) (s : JS) : Prop :=
  1 ≤ s.len ∧ s.len ≤ 5 ∧ s.f[0] &&& 1 = 1 ∧
    (2 ≤ s.len → s.f[0] < 4611686018427387904#64 ∧ s.g[0] < 4611686018427387904#64) ∧
      (s.len = 1 → s.f[1] = 0#64 ∧ s.g[1] = 0#64) ∧ s.eta.sle (bnd k) ∧ (-bnd k).sle s.eta

/-- The low word `f[0] | f[1] << 62` of an invariant state is odd. -/
public theorem JInv.f0_odd {k : Nat} {s : JS} (h : JInv k s) :
    (s.f[0] ||| s.f[1] <<< 62) &&& 1 = 1 := by
  have := h.2.2.1
  generalize s.f[0] = a at this ⊢
  generalize s.f[1] = b
  bv_decide

private theorem or_eq_zero {a b : BitVec 64} (h : a ||| b = 0#64) : a = 0#64 ∧ b = 0#64 := by
  bv_decide

/-- A batch's `posdivsteps`, from the low words of `f` and `g`. -/
public abbrev JS.pd (s : JS) : PD :=
  posdivsteps s.eta (s.f[0] ||| s.f[1] <<< 62) (s.g[0] ||| s.g[1] <<< 62) s.jac

/-- A batch's `update_fg`. -/
public abbrev JS.FG (s : JS) : Vector (BitVec 64) 5 × Vector (BitVec 64) 5 :=
  updateFg s.len s.f s.g s.pd.u s.pd.v s.pd.q s.pd.r

/-- A batch ends the loop: `f == 1`. -/
public abbrev JS.done (s : JS) : Prop :=
  s.FG.1[0] = 1 ∧ hiOr s.FG.1 s.len = 0

/-- The state after a batch that does not end the loop. -/
public abbrev JS.next (s : JS) : JS :=
  ⟨s.FG.1, s.FG.2,
    if 1 < s.len ∧ (s.FG.1[s.len - 1]! ||| s.FG.2[s.len - 1]!) = 0 then s.len - 1 else s.len,
    s.pd.eta, s.pd.j⟩

/-- `jacLoop` by one batch. -/
public theorem jacLoop_succ (n : Nat) (s : JS) :
    jacLoop (n + 1) s = if s.done then 1 - 2 * (s.pd.j &&& 1) else jacLoop n s.next := by
  simp only [jacLoop]

/-- A batch keeps the invariant, the bound up by `62`. -/
public theorem JInv.step {k : Nat} (hk : k < 25) {s : JS} (h : JInv k s) :
    let pd := posdivsteps s.eta (s.f[0] ||| s.f[1] <<< 62) (s.g[0] ||| s.g[1] <<< 62) s.jac
    let FG := updateFg s.len s.f s.g pd.u pd.v pd.q pd.r
    let len := if 1 < s.len ∧ (FG.1[s.len - 1]! ||| FG.2[s.len - 1]!) = 0 then s.len - 1
      else s.len
    JInv (k + 1) ⟨FG.1, FG.2, len, pd.eta, pd.j⟩ := by
  intro pd FG len
  obtain ⟨hl1, hl5, hf, hlo, hone, he, he'⟩ := h
  have hb := bnd_le (Nat.le_of_lt hk)
  have hx := posdivsteps_exit (j := s.jac) (g0 := s.g[0] ||| s.g[1] <<< 62) hb.1 hb.2
    (JInv.f0_odd ⟨hl1, hl5, hf, hlo, hone, he, he'⟩) he he'
  obtain ⟨hm, hi0, hpf, hpe, hpe'⟩ := hx
  simp only [Mat, hi0] at hm
  rw [bnd_succ] at hpe hpe'
  have hodd := updateFg_f0_odd (q := pd.q) (r := pd.r) ⟨hl1, hl5⟩ hm.1 hpf hlo hone
  refine ⟨?_, ?_, hodd, ?_, ?_, hpe, hpe'⟩
  · simp only [len]; split <;> omega
  · simp only [len]; split <;> omega
  · intro h2
    have : 2 ≤ s.len := by simp only [len] at h2; split at h2 <;> omega
    exact updateFg_lo ⟨this, hl5⟩ _ _ _ _ _ _
  · intro h1
    simp only [len] at h1
    split at h1
    · rename_i hc
      obtain ⟨hc1, hc2⟩ := hc
      have h2 : s.len = 2 := by omega
      simp only [h2] at hc2 ⊢
      simp only [Nat.reduceSub] at hc2
      exact or_eq_zero (by simpa using hc2)
    · have ha := updateFg_above ⟨hl1, hl5⟩ s.f s.g pd.u pd.v pd.q pd.r 1 (by omega) (by omega)
      rw [ha.1, ha.2]
      exact hone h1

/-- `JInv`'s `len` in `[1, 5]`. -/
public theorem JInv.len {k : Nat} {s : JS} (h : JInv k s) : 1 ≤ s.len ∧ s.len ≤ 5 :=
  ⟨h.1, h.2.1⟩

/-- `JInv`'s `eta` within `posdivsteps`' bounds. -/
public theorem JInv.eta_le {k : Nat} (hk : k < 25) {s : JS} (h : JInv k s) :
    s.eta.sle 1073741824#64 = true ∧ (-1073741824#64).sle s.eta = true := by
  have hb := bnd_le (Nat.le_of_lt hk)
  have he := h.2.2.2.2.2.1
  have he' := h.2.2.2.2.2.2
  generalize bnd k = B at hb he he'
  obtain ⟨hb1, hb2⟩ := hb
  constructor <;> bv_decide

/-- `JInv.step` on `JS.next`. -/
public theorem JInv.next {k : Nat} (hk : k < 25) {s : JS} (h : JInv k s) : JInv (k + 1) s.next :=
  JInv.step hk h

/-- The batch count, below `25`, counted up. -/
public theorem cnt_succ {k : Nat} (hk : k < 25) :
    BitVec.ofNat 32 k + 1#32 = BitVec.ofNat 32 (k + 1) ∧
      (BitVec.ofNat 32 k).uaddOverflow 1#32 = false ∧
        (BitVec.ofNat 32 k).saddOverflow 1#32 = false ∧
      (BitVec.ofNat 32 (k + 1) = 25#32 ↔ k = 24) := by
  have hx : BitVec.ofNat 32 k < 25#32 := by
    rw [BitVec.lt_def]; simp; omega
  generalize hx' : BitVec.ofNat 32 k = x at hx
  refine ⟨?_, by bv_decide, by bv_decide, ?_⟩
  · rw [← hx']
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  · constructor
    · intro h
      have := congrArg BitVec.toNat h
      simp only [BitVec.toNat_ofNat] at this
      omega
    · rintro rfl
      rfl

/-- `hi` for `len = 2 … 5`, as the loop or-s it. -/
public theorem hiOr_eq (F : Vector (BitVec 64) 5) :
    hiOr F 2 = F[1] ∧ hiOr F 3 = F[2] ||| F[1] ∧ hiOr F 4 = F[3] ||| (F[2] ||| F[1]) ∧
      hiOr F 5 = F[4] ||| (F[3] ||| (F[2] ||| F[1])) := by
  simp only [hiOr]
  simp only [List.range_succ, List.range_zero]
  simp
  generalize F[1] = a, F[2] = b, F[3] = c, F[4] = d
  refine ⟨?_, ?_, ?_⟩ <;> bv_decide

/-- `^bb12`'s result from the symbol bit: `1 - 2 (jac & 1)`, without signed overflow. -/
public theorem res_eq (j : BitVec 32) :
    ¬(1#32).ssubOverflow (j <<< 1 &&& 2#32) = true ∧
      1#32 - (j <<< 1 &&& 2#32) = 1 - 2 * (j &&& 1) := by
  constructor <;> bv_decide

end MLIR.Firedancer.Lane.Jacobi
