module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_double_scalar_mul_base
public import Firedancer.LaneNI.fd_curve25519_scalar_wnaf
public import Firedancer.LaneNI.fd_ed25519_point_set
public import Firedancer.LaneNI.fd_ed25519_point_set_zero
public import Firedancer.LaneNI.fd_ed25519_partial_dbl
public import Firedancer.LaneNI.fd_ed25519_point_dbln
public import Firedancer.LaneNI.fd_curve25519_into_precomputed
public import Firedancer.LaneNI.fd_ed25519_point_add_final_mul
public import Firedancer.LaneNI.fd_ed25519_point_add_final_mul_projective
public import Firedancer.LaneNI.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.fd_ed25519_point_sub_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Specification

The batch's points `A 0 … A (sz - 1)`, their scalars `n 0 … n (sz - 1)`; each point's table and a
digit's add are `double_scalar_mul_base`'s. -/

@[expose] public section

namespace fd_ed25519_multi_scalar_mul_with_opts

open Avx512.fd_ed25519_double_scalar_mul_base (aiTable addDigit digitBlocks)
open Firedancer.Ref

/-- `ai[j]` for the point `A`: its odd multiples, precomputed. -/
abbrev table (A : Quad) : Nat → Quad :=
  aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)

/-- `for( ulong j=base_sz; j<sz; j++ )` at digit `i` on `(r, t)`, for points `0 … j - 1`: each
`nslide[j][i]`'s add from `ai[j]`. -/
def adds (ai : Nat → Nat → Quad) (w : Nat → Vector Int 256) (i : Nat) (hi : i < 256) :
    Nat → Quad × Quad → Quad × Quad
  | 0, rt => rt
  | j + 1, rt =>
    let rt := adds ai w i hi j rt
    addDigit (ai j) (w j)[i] rt.1 rt.2

/-- The blocks `adds` allocates. -/
def addsBlocks (w : Nat → Vector Int 256) (i : Nat) (hi : i < 256) : Nat → Nat
  | 0 => 0
  | j + 1 => addsBlocks w i hi j + digitBlocks (w j)[i]

/-- The main loop from `i` down to `0` on `r`: `t = partial_dbl( r )`, the `sz` points' adds, then
`r` a copy of `t`. -/
def ladder (ai : Nat → Nat → Quad) (w : Nat → Vector Int 256) (sz : Nat) :
    (i : Nat) → i < 256 → Quad → Quad
  | 0, h, r => (adds ai w 0 h sz (r, fd_ed25519_partial_dbl.spec r)).2
  | i + 1, h, r =>
    ladder ai w sz i (by omega) (adds ai w (i + 1) h sz (r, fd_ed25519_partial_dbl.spec r)).2

/-- The blocks `ladder` allocates: `partial_dbl`'s six per iteration, and the adds'. -/
def ladderBlocks (w : Nat → Vector Int 256) (sz : Nat) : (i : Nat) → i < 256 → Nat
  | 0, h => 6 + addsBlocks w 0 h sz
  | i + 1, h => 6 + addsBlocks w (i + 1) h sz + ladderBlocks w sz i (by omega)

/-- `Σ n[j] A[j]` as the code computes it with `base_sz = 0`: the slides and tables of the `sz`
points, then the main loop over all 256 digits on the neutral point. -/
def spec (n : Nat → BitVec 256) (A : Nat → Quad) (sz : Nat) : Quad :=
  ladder (fun j => table (A j)) (fun j => fd_curve25519_scalar_wnaf.wnaf (n j) 4) sz 255
    (by decide) fd_ed25519_point_set_zero.spec

/-- The blocks the function allocates, its callees' included: four locals, 142 per point for its
slides and table, and the main loop's. -/
def blocks (n : Nat → BitVec 256) (sz : Nat) : Nat :=
  4 + 142 * sz + ladderBlocks (fun j => fd_curve25519_scalar_wnaf.wnaf (n j) 4) sz 255 (by decide)

end fd_ed25519_multi_scalar_mul_with_opts

end

/-! ## Proof -/

section Proof

namespace fd_ed25519_multi_scalar_mul_with_opts

open _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts
open Avx512.fd_ed25519_double_scalar_mul_base (aiTable addDigit digitBlocks)
open Firedancer.Ref

/-- The lift's runs from a block. -/
local notation "runM" => _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.runFrom

/-- Register `k` of the lift. -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.hty $k)

/-! ### Tables and slides in memory -/

/-- `n` points `f 0, …, f (n - 1)` at `p`, 192 bytes apart. -/
def TableAt (m : MemoryState) (p : Pointer) (n : Nat) (f : Nat → Quad) : Prop :=
  ∀ k < n,
    m.QuadFit (p.add (BitVec.ofNat 64 (192 * k))) ∧
      m.readQuad (p.add (BitVec.ofNat 64 (192 * k))) = f k

/-- `n` points of a known read from `p`, 192 bytes apart. -/
theorem TableAt.of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v} (hf : Fits m p v)
    (h : m.readAt p v = x) (hp : p.offset.toNat + 192 * n < 2 ^ 64) (hv : 1536 * n = v) :
    TableAt m p n fun k => quadAt x (1536 * k) := fun k hk =>
  ⟨MemoryState.QuadFit.entry (hv ▸ hf) hp hk, by
    rw [MemoryState.readQuad_add_of_readAt hf h (by omega) (by omega),
      show 8 * (192 * k) = 1536 * k by omega]⟩

theorem TableAt.storeQuad {m : MemoryState} (h : TableAt m q n f) (hne : p.id ≠ q.id) :
    TableAt (m.storeQuad p P) q n f := fun k hk =>
  ⟨(h k hk).1.storeQuad, by
    rw [MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

theorem TableAt.storeAt {m : MemoryState} {x : BitVec w} (h : TableAt m q n f)
    (hne : p.id ≠ q.id) : TableAt (m.storeAt p x) q n f := fun k hk =>
  ⟨(h k hk).1.storeAt, by
    rw [MemoryState.readQuad_storeAt_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

theorem TableAt.lifetimeStart {m : MemoryState} (h : TableAt m q n f) (hne : q.id ≠ p.id) :
    TableAt (m.lifetimeStart p) q n f := fun k hk =>
  ⟨(h k hk).1.lifetimeStart (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readQuad_lifetimeStart]
    exact (h k hk).2⟩

theorem TableAt.lifetimeEnd {m : MemoryState} (h : TableAt m q n f) (hne : q.id ≠ p.id) :
    TableAt (m.lifetimeEnd p) q n f := fun k hk =>
  ⟨(h k hk).1.lifetimeEnd (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readQuad_lifetimeEnd]
    exact (h k hk).2⟩

theorem slidesAt_storeQuad {m : MemoryState} (h : SlidesAt m q w) (hne : p.id ≠ q.id) :
    SlidesAt (m.storeQuad p P) q w := fun k hk =>
  ⟨Fits.storeQuad (h k hk).1, by
    rw [MemoryState.readAt_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

theorem slidesAt_storeAt {m : MemoryState} {x : BitVec v} (h : SlidesAt m q w)
    (hne : p.id ≠ q.id) : SlidesAt (m.storeAt p x) q w := fun k hk =>
  ⟨(h k hk).1.storeAt, by
    rw [MemoryState.readAt_storeAt_disjoint (Or.inl (by simpa [Range.of, Pointer.add] using hne))]
    exact (h k hk).2⟩

theorem slidesAt_lifetimeStart {m : MemoryState} (h : SlidesAt m q w) (hne : q.id ≠ p.id) :
    SlidesAt (m.lifetimeStart p) q w := fun k hk =>
  ⟨(h k hk).1.lifetimeStart (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readAt_lifetimeStart]
    exact (h k hk).2⟩

theorem slidesAt_lifetimeEnd {m : MemoryState} (h : SlidesAt m q w) (hne : q.id ≠ p.id) :
    SlidesAt (m.lifetimeEnd p) q w := fun k hk =>
  ⟨(h k hk).1.lifetimeEnd (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readAt_lifetimeEnd]
    exact (h k hk).2⟩

attribute [local mlir_transport] TableAt.storeQuad TableAt.storeAt TableAt.lifetimeStart
  TableAt.lifetimeEnd slidesAt_storeQuad slidesAt_storeAt slidesAt_lifetimeStart
  slidesAt_lifetimeEnd

/-- A point store at `t` after stores at `t` and `r`: the stores at `t` merge. -/
theorem storeQuad_swap {m : MemoryState} {t r : Pointer} (ht : t.offset.toNat + 192 ≤ 2 ^ 64)
    (htr : t.id ≠ r.id) :
    ((m.storeQuad t X).storeQuad r Y).storeQuad t Z = (m.storeQuad t Z).storeQuad r Y := by
  rw [MemoryState.storeQuad_comm htr.symm, MemoryState.storeQuad_storeQuad_self ht]

/-- One main-loop iteration's stores at `t` and `r`, merged: the last of each. -/
theorem storeQuad_canon {m : MemoryState} {t r : Pointer} (ht : t.offset.toNat + 192 ≤ 2 ^ 64)
    (hr : r.offset.toNat + 192 ≤ 2 ^ 64) (htr : t.id ≠ r.id) :
    ((((m.storeQuad t T₁).storeQuad r R₁).storeQuad t T₂).storeQuad r R₂).storeQuad r R₃ =
      (m.storeQuad t T₂).storeQuad r R₃ := by
  rw [MemoryState.storeQuad_storeQuad_self hr, storeQuad_swap ht htr,
    MemoryState.storeQuad_storeQuad_self hr]

/-! ### Digits -/

/-- A digit's `short` widened to an `int`. -/
theorem signExtend_ofInt16 {d : Int} (h : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) :
    BitVec.signExtend 32 (BitVec.ofInt 16 d) = BitVec.ofInt 32 d := by
  apply BitVec.eq_of_toInt_eq
  rw [BitVec.toInt_signExtend_of_le (by decide), toInt_ofInt16 h,
    BitVec.toInt_ofInt_eq_self (by decide) (by omega) (by omega)]

/-- The table index `d / 2` of a positive digit, as an `int`. -/
theorem idx32_pos {d : Int} (h : 0 ≤ d ∧ d < 2 ^ 15) :
    (BitVec.setWidth 64 (BitVec.ofInt 32 d) >>> 1).toNat = (d / 2).toNat := by
  rw [BitVec.toNat_ushiftRight, BitVec.toNat_setWidth, BitVec.toNat_ofInt,
    Nat.shiftRight_eq_div_pow]
  omega

/-- `0 - d` on a digit as an `int` does not overflow. -/
theorem ssubOverflow_zero_ofInt32 {d : Int} (h : -2 ^ 15 ≤ d ∧ d < 2 ^ 15) :
    (0#32).ssubOverflow (BitVec.ofInt 32 d) = false := by
  have hd : (BitVec.ofInt 32 d).toInt = d :=
    BitVec.toInt_ofInt_eq_self (by decide) (by omega) (by omega)
  simp [BitVec.ssubOverflow, hd]
  omega

/-- The table index `-d / 2` of a negative digit, as an `int`. -/
theorem idx32_neg {d : Int} (h : -2 ^ 15 < d ∧ d ≤ 0) :
    (BitVec.setWidth 64 (-BitVec.ofInt 32 d) >>> 1).toNat = (-d / 2).toNat := by
  rw [BitVec.toNat_ushiftRight, BitVec.toNat_setWidth, ← BitVec.ofInt_neg, BitVec.toNat_ofInt,
    Nat.shiftRight_eq_div_pow]
  omega

/-! ### The main loop -/

/-- The registers the main loop reads, the counters aside. -/
abbrev MainRegs (ns ai a2 tp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := 1#32, %1 := 0#64, %4 := 1#64, %7 := 0#16, %8 := 0#32, %9 := 18446744073709551615#64,
    %12 := ns, %13 := ai, %14 := a2, %15 := tp]

theorem digit_block (r n a ns ai a2 tp : Pointer) (sz : Nat) (w : Vector Int 256)
    (AI : Nat → Quad) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (i : Nat) (hi : i < 256) (j : Nat) (hj : j < 32) (hw : -15 ≤ w[i] ∧ w[i] ≤ 15)
    (R T : Quad) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : MainRegs ns ai a2 tp E)
    (hRi : E ⊨ [%20 := BitVec.ofNat 64 i, %22 := ns.add (BitVec.ofNat 64 (2 * i)),
      %25 := BitVec.ofNat 64 j]) (hwf : S.WF)
    (hr : S.mem.QuadFit r) (hrw : Writable S.mem r) (htp : S.mem.QuadFit tp)
    (htw : Writable S.mem tp) (hrt : r.id ≠ tp.id) (hra : r.id ≠ ai.id) (hao : ai.offset = 0)
    (hrv : S.mem.readQuad r = R) (htv : S.mem.readQuad tp = T)
    (hsl : SlidesAt S.mem (ns.add (BitVec.ofNat 64 (512 * j))) w)
    (htbl : TableAt S.mem (ai.add (BitVec.ofNat 64 (1536 * j))) 8 AI)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
          MainRegs ns ai a2 tp E' →
          (E' ⊨ [%20 := BitVec.ofNat 64 i, %22 := ns.add (BitVec.ofNat 64 (2 * i)),
            %25 := BitVec.ofNat 64 j]) →
          S' =
            { alloc := ⟨S.alloc.nextFreeBlock + digitBlocks w[i]⟩,
              mem :=
                (S.mem.storeQuad tp (addDigit AI w[i] R T).2).storeQuad r
                  (addDigit AI w[i] R T).1 } →
          (runM E' ^bb9 S' >>= g) = K) :
    (runM E ^bb5 S >>= g) = K := by
  obtain ⟨hf, hl⟩ := hsl i hi
  clear hsl
  rw [add_ofNat_add] at hf hl
  block_init
  step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega), ← BitVec.ofNat_add,
    show 2 * i + j * 512 = 512 * j + 2 * i by omega]
  step_load with transparent d consuming hf hl
  step_pure
  step_pure
  finish_block
  case
    isTrue =>
    have hpos : 0 < w[i] := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    obtain ⟨k, hk⟩ : ∃ k, (w[i] / 2).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 8 := by omega
    obtain ⟨hAf, hAr⟩ := htbl k hk8
    clear htbl
    rw [Pointer.add_add] at hAf hAr
    block_init
    step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul.call_eq
    step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega)]
    step_pure [signExtend_ofInt16 (show -2 ^ 15 ≤ w[i] ∧ w[i] < 2 ^ 15 by omega)]
    step_pure with idx
    have hidx : idx.toNat = k := by rw [hidx, idx32_pos (by omega), hk]
    step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega, Nat.mul_comm j 1536]
    step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts.call_eq
    finish_block
    refine hK E S hArgs (by env_reads) (by env_reads) ?_
    rw [hS, MemoryState.storeQuad_comm hrt]
    simp only [addDigit, hpos, ite_true, hk, digitBlocks]
  case
    isFalse =>
    have hnpos : w[i] ≤ 0 := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    block_init
    step_pure
    finish_block
    case
      isTrue =>
      have hneg : w[i] < 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simpa using hbr
      obtain ⟨k, hk⟩ : ∃ k, (-w[i] / 2).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 8 := by omega
      obtain ⟨hAf, hAr⟩ := htbl k hk8
      clear htbl
      rw [Pointer.add_add] at hAf hAr
      block_init
      step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul.call_eq
      step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega)]
      step_pure [signExtend_ofInt16 (show -2 ^ 15 ≤ w[i] ∧ w[i] < 2 ^ 15 by omega)]
      step_pure [ssubOverflow_zero_ofInt32 (show -2 ^ 15 ≤ w[i] ∧ w[i] < 2 ^ 15 by omega)]
      step_pure with idx
      have hidx : idx.toNat = k := by rw [hidx, idx32_neg (by omega), hk]
      step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega, Nat.mul_comm j 1536]
      step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts.call_eq
      finish_block
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      rw [hS, MemoryState.storeQuad_comm hrt]
      simp only [addDigit, hneg, show ¬0 < w[i] by omega, ite_true, ite_false, hk, digitBlocks]
    case
      isFalse =>
      have h0 : w[i] = 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simp at hbr
        omega
      clear htbl
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      simp only [addDigit, h0, lt_irrefl, ite_false, digitBlocks, Nat.add_zero]
      subst hS
      rw [MemoryState.storeQuad_readQuad_self' htp htv, MemoryState.storeQuad_readQuad_self' hr hrv]

/-- `^bb9`: on to the next point, or out to `^bb10` after the last. -/
theorem next_block (r n a ns ai a2 tp : Pointer) (sz : Nat) (hsz : sz ≤ 32)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (j : Nat) (hj : j < sz)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : MainRegs ns ai a2 tp E)
    (hRi : E ⊨ [%20 := BitVec.ofNat 64 i, %22 := ns.add (BitVec.ofNat 64 (2 * i)),
      %25 := BitVec.ofNat 64 j])
    (hexit :
      j + 1 = sz →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            MainRegs ns ai a2 tp E' → (E' ⊨ [%20 := BitVec.ofNat 64 i]) →
            (runM E' ^bb10 S >>= g) = K)
    (hback :
      j + 1 < sz →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            MainRegs ns ai a2 tp E' →
            (E' ⊨ [%20 := BitVec.ofNat 64 i, %22 := ns.add (BitVec.ofNat 64 (2 * i)),
              %25 := BitVec.ofNat 64 (j + 1)]) →
            (runM E' ^bb5 S >>= g) = K) :
    (runM E ^bb9 S >>= g) = K := by
  block_init
  step_pure [uaddOverflow_one64 (show j + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure
  finish_block
  case isTrue =>
    have h : j + 1 = sz := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    exact hexit h E hArgs (by env_reads) (by env_reads)
  case isFalse =>
    have h : j + 1 < sz := by
      by_contra h'
      exact hbr (by rw [show j + 1 = sz by omega])
    exact hback h E hArgs (by env_reads) (by env_reads)

/-- What the main loop needs of a memory: `r` and `t` writable points, the slides and tables of
the `sz` points in place. -/
structure MemFacts (m : MemoryState) (r tp ns ai : Pointer) (sz : Nat) (w : Nat → Vector Int 256)
    (AI : Nat → Nat → Quad) : Prop where
  fitR : m.QuadFit r
  wrR : Writable m r
  roomT : m.QuadRoom tp
  slides : ∀ j < sz, SlidesAt m (ns.add (BitVec.ofNat 64 (512 * j))) (w j)
  tbls : ∀ j < sz, TableAt m (ai.add (BitVec.ofNat 64 (1536 * j))) 8 (AI j)

/-- The main loop's objects: blocks apart, `ai` from its block's start. -/
structure Layout (r tp ns ai : Pointer) : Prop where
  rt : r.id ≠ tp.id
  rn : r.id ≠ ns.id
  ra : r.id ≠ ai.id
  tn : tp.id ≠ ns.id
  ta : tp.id ≠ ai.id
  aio : ai.offset = 0

/-- `MemFacts` after stores at `t` and `r`. -/
theorem MemFacts.store {m : MemoryState} (h : MemFacts m r tp ns ai sz w AI)
    (hL : Layout r tp ns ai) :
    MemFacts ((m.storeQuad tp T).storeQuad r R) r tp ns ai sz w AI where
  fitR := h.fitR.storeQuad.storeQuad
  wrR := h.wrR.storeQuad.storeQuad
  roomT := h.roomT.storeQuad.storeQuad
  slides j hj :=
    slidesAt_storeQuad (slidesAt_storeQuad (h.slides j hj) (by simpa [Pointer.add_id] using hL.tn))
      (by simpa [Pointer.add_id] using hL.rn)
  tbls j hj :=
    ((h.tbls j hj).storeQuad (by simpa [Pointer.add_id] using hL.ta)).storeQuad
      (by simpa [Pointer.add_id] using hL.ra)

/-- `t` a point after stores at `t` and `r`. -/
theorem MemFacts.fitT_store {m : MemoryState} (h : MemFacts m r tp ns ai sz w AI) :
    ((m.storeQuad tp T).storeQuad r R).QuadFit tp :=
  (MemoryState.QuadFit.storeQuad_self h.roomT).storeQuad

/-- Stores at `t` and `r` after stores at both: the last of each. -/
theorem storeQuad_merge {m : MemoryState} {t r : Pointer} (ht : t.offset.toNat + 192 ≤ 2 ^ 64)
    (hr : r.offset.toNat + 192 ≤ 2 ^ 64) (htr : t.id ≠ r.id) :
    (((m.storeQuad t T₁).storeQuad r R₁).storeQuad t T₂).storeQuad r R₂ =
      (m.storeQuad t T₂).storeQuad r R₂ := by
  rw [storeQuad_swap ht htr, MemoryState.storeQuad_storeQuad_self hr]

/-- The adds loop from `^bb5` at point `j`: the adds of points `j …` at digit `i`, on to
`^bb10`. -/
theorem adds_loop (r n a ns ai a2 tp : Pointer) (sz : Nat) (hsz : sz ≤ 32)
    (w : Nat → Vector Int 256) (AI : Nat → Nat → Quad)
    (hw : ∀ j < sz, ∀ k (hk : k < 256), (-15 : Int) ≤ (w j)[k] ∧ (w j)[k] ≤ 15)
    (M : MemoryState) (hM : MemFacts M r tp ns ai sz w AI) (hL : Layout r tp ns ai) (B : Nat)
    (rt0 : Quad × Quad) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat)
    (hi : i < 256) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫),
      j + m = sz → j < sz →
        E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
          MainRegs ns ai a2 tp E →
          (E ⊨ [%20 := BitVec.ofNat 64 i, %22 := ns.add (BitVec.ofNat 64 (2 * i)),
            %25 := BitVec.ofNat 64 j]) →
          S.WF → S.alloc.nextFreeBlock = B + addsBlocks w i hi j →
          S.mem = (M.storeQuad tp (adds AI w i hi j rt0).2).storeQuad r (adds AI w i hi j rt0).1 →
          (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
              MainRegs ns ai a2 tp E' → (E' ⊨ [%20 := BitVec.ofNat 64 i]) → S'.WF →
              S'.alloc.nextFreeBlock = B + addsBlocks w i hi sz →
              S'.mem =
                (M.storeQuad tp (adds AI w i hi sz rt0).2).storeQuad r (adds AI w i hi sz rt0).1 →
              (runM E' ^bb10 S' >>= g) = K) →
          (runM E ^bb5 S >>= g) = K := by
  intro m
  induction m with
  | zero => intro j S E h hj; omega
  | succ m ih =>
    intro j S E hm hj hArgs hR hRi hwf hB hS hK
    have hF := hS ▸ hM.store (T := (adds AI w i hi j rt0).2) (R := (adds AI w i hi j rt0).1) hL
    refine
      digit_block r n a ns ai a2 tp sz (w j) (AI j) g K i hi j (by omega) (hw j hj i hi)
        (adds AI w i hi j rt0).1 (adds AI w i hi j rt0).2 S E
        hArgs hR hRi hwf hF.fitR hF.wrR (hS ▸ hM.fitT_store) hF.roomT.2.1.writable hL.rt hL.ra
        hL.aio ?_ ?_
        (hF.slides j hj) (hF.tbls j hj) fun E₁ S₁ h₁ hR₁ hRi₁ hS₁ => ?_
    · rw [hS]
      exact MemoryState.readQuad_storeQuad_self (hM.fitR.room hM.wrR).storeQuad
    · rw [hS, MemoryState.readQuad_storeQuad_of_id_ne hL.rt]
      exact MemoryState.readQuad_storeQuad_self hM.roomT
    have hwf₁ : S₁.WF := by
      rw [hS₁]
      exact (GlobalState.WF.bump hwf (by omega)).storeQuad_mk.storeQuad_mk
    have hB₁ : S₁.alloc.nextFreeBlock = B + addsBlocks w i hi (j + 1) := by
      rw [hS₁]
      simp only [addsBlocks, hB, Nat.add_assoc]
    have hS₁' :
        S₁.mem =
          (M.storeQuad tp (adds AI w i hi (j + 1) rt0).2).storeQuad r
            (adds AI w i hi (j + 1) rt0).1 := by
      rw [hS₁]
      dsimp only
      rw [hS, storeQuad_merge hM.roomT.1 hM.fitR.1 hL.rt.symm]
      rfl
    refine
      next_block r n a ns ai a2 tp sz hsz g K i j hj S₁ E₁ h₁ hR₁ hRi₁
        (fun h E' h' hR' hRi' => hK E' S₁ h' hR' hRi' hwf₁ (h ▸ hB₁) (h ▸ hS₁'))
        fun h E' h' hR' hRi' => ih (j + 1) S₁ E' (by omega) h h' hR' hRi' hwf₁ hB₁ hS₁' hK

/-- `^bb10`: out to `^bb14` at `i = 0`, else `r` a copy of `t` and around at `i - 1`. -/
theorem tail_block (r n a ns ai a2 tp : Pointer) (sz : Nat)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (T : Quad) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : MainRegs ns ai a2 tp E) (hRi : E ⊨ [%20 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hr : S.mem.QuadFit r) (hrw : Writable S.mem r) (htp : S.mem.QuadFit tp) (hrt : r.id ≠ tp.id)
    (htv : S.mem.readQuad tp = T)
    (hexit :
      i = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            MainRegs ns ai a2 tp E' → (runM E' ^bb14 S >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
              MainRegs ns ai a2 tp E' → (E' ⊨ [%20 := BitVec.ofNat 64 j]) →
              S' = { S with mem := S.mem.storeQuad r T } →
              (runM E' ^bb3 S' >>= g) = K) :
    (runM E ^bb10 S >>= g) = K := by
  block_init
  step_pure
  finish_block
  case isTrue =>
    exact hexit (eq_zero_of_ofNat64 (by omega) hbr) E hArgs (by env_reads)
  case isFalse =>
    have hi0 : 1 ≤ i := Nat.one_le_iff_ne_zero.mpr fun h => hbr (by rw [h])
    block_init
    step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective.call_eq
    step_pure [saddOverflow_neg_one64 hi0 (by omega), add_neg_one64 hi0 (by omega)]
    finish_block
    exact hback (i - 1) (by omega) E S hArgs (by env_reads) (by env_reads) (by rw [hS])

/-- `^bb3`, an iteration's start at `i`: `t = partial_dbl( r )`; on to the adds. -/
theorem head_block (r n a ns ai a2 tp : Pointer) (sz : Nat)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (R : Quad) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : MainRegs ns ai a2 tp E) (hRi : E ⊨ [%20 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hr : S.mem.QuadFit r) (htp : S.mem.QuadRoom tp)
    (hrv : S.mem.readQuad r = R)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
          MainRegs ns ai a2 tp E' →
          (E' ⊨ [%20 := BitVec.ofNat 64 i, %22 := ns.add (BitVec.ofNat 64 (2 * i)),
            %25 := BitVec.ofNat 64 0]) →
          S' =
            { alloc := ⟨S.alloc.nextFreeBlock + 6⟩,
              mem := S.mem.storeQuad tp (fd_ed25519_partial_dbl.spec R) } →
          (runM E' ^bb5 S' >>= g) = K) :
    (runM E ^bb3 S >>= g) = K := by
  block_init
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl.call_eq
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  finish_block
  exact hK E S hArgs (by env_reads) (by env_reads) (by rw [hS])

/-- An iteration of the main loop at `i`: `t = partial_dbl( r )`, the adds, then out or around
with `r` a copy of `t`. -/
theorem main_iter (r n a ns ai a2 tp : Pointer) (sz : Nat) (hsz : 1 ≤ sz ∧ sz ≤ 32)
    (w : Nat → Vector Int 256) (AI : Nat → Nat → Quad)
    (hw : ∀ j < sz, ∀ k (hk : k < 256), (-15 : Int) ≤ (w j)[k] ∧ (w j)[k] ≤ 15)
    (hL : Layout r tp ns ai) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (i : Nat) (hi : i < 256) (R : Quad) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : MainRegs ns ai a2 tp E) (hRi : E ⊨ [%20 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hF : MemFacts S.mem r tp ns ai sz w AI) (hrv : S.mem.readQuad r = R)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            MainRegs ns ai a2 tp E' → S'.WF →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 6 + addsBlocks w i hi sz →
            S'.mem =
              (S.mem.storeQuad tp
                    (adds AI w i hi sz (R, fd_ed25519_partial_dbl.spec R)).2).storeQuad
                r (adds AI w i hi sz (R, fd_ed25519_partial_dbl.spec R)).1 →
            (runM E' ^bb14 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
              MainRegs ns ai a2 tp E' → (E' ⊨ [%20 := BitVec.ofNat 64 j]) → S'.WF →
              S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 6 + addsBlocks w i hi sz →
              S'.mem =
                (S.mem.storeQuad tp
                      (adds AI w i hi sz (R, fd_ed25519_partial_dbl.spec R)).2).storeQuad
                  r (adds AI w i hi sz (R, fd_ed25519_partial_dbl.spec R)).2 →
              (runM E' ^bb3 S' >>= g) = K) :
    (runM E ^bb3 S >>= g) = K := by
  refine
    head_block r n a ns ai a2 tp sz g K i hi R S E hArgs hR hRi hwf hF.fitR hF.roomT hrv
      fun E₀ S₀ h₀ hR₀ hRi₀ hS => ?_
  refine
    adds_loop r n a ns ai a2 tp sz hsz.2 w AI hw S.mem hF hL (S.alloc.nextFreeBlock + 6)
      (R, fd_ed25519_partial_dbl.spec R) g K i hi sz 0 S₀ E₀ (by omega) (by omega) h₀ hR₀ hRi₀ ?_
      ?_ ?_ fun E₁ S₁ h₁ hR₁ hRi₁ hwf₁ hB₁ hS₁ => ?_
  · subst hS
    exact (GlobalState.WF.bump hwf (by omega)).storeQuad_mk
  · subst hS
    rfl
  · subst hS
    dsimp only [adds]
    rw [MemoryState.storeQuad_readQuad_self' (hF.fitR.storeQuad (p := tp))
        (by rw [MemoryState.readQuad_storeQuad_of_id_ne hL.rt.symm, hrv])]
  have hrt := hL.rt
  have hr₁ : S₁.mem.QuadFit r := hS₁ ▸ hF.fitR.storeQuad.storeQuad
  have hrw₁ : Writable S₁.mem r := hS₁ ▸ hF.wrR.storeQuad.storeQuad
  have ht₁ : S₁.mem.QuadFit tp := hS₁ ▸ hF.fitT_store
  have htv₁ : S₁.mem.readQuad tp = (adds AI w i hi sz (R, fd_ed25519_partial_dbl.spec R)).2 := by
    rw [hS₁, MemoryState.readQuad_storeQuad_of_id_ne hL.rt]
    exact MemoryState.readQuad_storeQuad_self hF.roomT
  refine
    tail_block r n a ns ai a2 tp sz g K i hi _ S₁ E₁ h₁ hR₁ hRi₁ hwf₁ hr₁ hrw₁ ht₁ hrt htv₁
      (fun h0 E' h' hR' => hexit h0 E' S₁ h' hR' hwf₁ (by omega) hS₁)
      fun j hj E' S' h' hR' hRi' hS' => hback j hj E' S' h' hR' hRi' ?_ ?_ ?_
  · rw [hS']
    exact hwf₁.storeQuad_mk
  · rw [hS']
    dsimp only
    omega
  · rw [hS']
    dsimp only
    rw [hS₁, MemoryState.storeQuad_storeQuad_self hF.fitR.1]

/-- The main loop from `^bb3` at `i`: `t` the ladder from `i` down, `r` some point, at
`^bb14`. -/
theorem main_loop (r n a ns ai a2 tp : Pointer) (sz : Nat) (hsz : 1 ≤ sz ∧ sz ≤ 32)
    (w : Nat → Vector Int 256) (AI : Nat → Nat → Quad)
    (hw : ∀ j < sz, ∀ k (hk : k < 256), (-15 : Int) ≤ (w j)[k] ∧ (w j)[k] ≤ 15)
    (hL : Layout r tp ns ai) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (hi : i < 256) (R : Quad) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
        MainRegs ns ai a2 tp E → (E ⊨ [%20 := BitVec.ofNat 64 i]) → S.WF →
        MemFacts S.mem r tp ns ai sz w AI → S.mem.readQuad r = R →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState) (R' : Quad),
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            MainRegs ns ai a2 tp E' → S'.WF →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + ladderBlocks w sz i hi →
            S'.mem = (S.mem.storeQuad tp (ladder AI w sz i hi R)).storeQuad r R' →
            (runM E' ^bb14 S' >>= g) = K) →
        (runM E ^bb3 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi R S E hArgs hR hRi hwf hF hrv hK
    exact
      main_iter r n a ns ai a2 tp sz hsz w AI hw hL g K 0 hi R S E hArgs hR hRi hwf hF hrv
        (fun _ E' S' h' hR' hwf' hB' hS' =>
          hK E' S' _ h' hR' hwf' (by rw [hB']; simp only [ladderBlocks, Nat.add_assoc]) hS')
        fun j hj => absurd hj (by omega)
  | succ j ih =>
    intro hi R S E hArgs hR hRi hwf hF hrv hK
    refine
      main_iter r n a ns ai a2 tp sz hsz w AI hw hL g K (j + 1) hi R S E hArgs hR hRi hwf hF hrv
        (fun h => absurd h (by omega)) fun j' hj E' S' h' hR' hRi' hwf' hB' hS' => ?_
    obtain rfl : j = j' := by omega
    have hF' := hS' ▸ hF.store hL
    refine
      ih (by omega) (adds AI w (j + 1) hi sz (R, fd_ed25519_partial_dbl.spec R)).2 S' E' h' hR'
        hRi' hwf' hF' ?_ fun E'' S'' R'' h'' hR'' hwf'' hB'' hS'' =>
        hK E'' S'' R'' h'' hR'' hwf'' ?_ ?_
    · rw [hS']
      exact MemoryState.readQuad_storeQuad_self (hF.fitR.room hF.wrR).storeQuad
    · rw [hB'', hB']
      simp only [ladderBlocks]
      omega
    · rw [hS'', hS', storeQuad_merge hF.roomT.1 hF.fitR.1 hL.rt.symm]
      rfl

/-! ### The setup loop -/

/-- The registers the setup loop reads, the counters aside. -/
abbrev SetupRegs (ns ai a2 tp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := 1#32, %1 := 0#64, %2 := 5#64, %3 := 4#32, %4 := 1#64, %5 := 8#64,
    %6 := 255#64, %7 := 0#16, %8 := 0#32, %9 := 18446744073709551615#64, %12 := ns, %13 := ai,
    %14 := a2, %15 := tp]

/-- `j << 5` on a small counter. -/
theorem shl5_ofNat64 {j : Nat} : BitVec.ofNat 64 j <<< 5 = BitVec.ofNat 64 (32 * j) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.shiftLeft_eq]
  omega

/-- `^bb11`, point `j`'s start: its slides, `ai[j][0]` and `a2` from it; on to its table. -/
theorem point_block (r n a ns ai a2 tp : Pointer) (sz : Nat) (hsz : sz ≤ 32)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (j : Nat) (hj : j < sz)
    (x : BitVec 256) (A : Quad) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : SetupRegs ns ai a2 tp E) (hRj : E ⊨ [%47 := BitVec.ofNat 64 j]) (hwf : S.WF)
    (hno : n.offset.toNat + 32 * sz < 2 ^ 64) (hao : a.offset.toNat + 192 * sz < 2 ^ 64)
    (hnso : ns.offset = 0) (haio : ai.offset = 0)
    (hnsr : Room S.mem (ns.add (BitVec.ofNat 64 (512 * j))) (8 * 512))
    (hn : Fits S.mem (n.add (BitVec.ofNat 64 (32 * j))) (8 * 32))
    (hx : S.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256 = x)
    (hair : S.mem.QuadRoom (ai.add (BitVec.ofNat 64 (1536 * j))))
    (ha : S.mem.QuadFit (a.add (BitVec.ofNat 64 (192 * j))))
    (hA : S.mem.readQuad (a.add (BitVec.ofNat 64 (192 * j))) = A) (ha2 : S.mem.QuadRoom a2)
    (hnsa : ns.id ≠ a.id) (haia : ai.id ≠ a.id) (haia2 : ai.id ≠ a2.id)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
          SetupRegs ns ai a2 tp E' →
          (E' ⊨ [%47 := BitVec.ofNat 64 j, %51 := ai.add (BitVec.ofNat 64 (1536 * j)),
            %57 := BitVec.ofNat 64 1]) →
          S' =
            { alloc := ⟨S.alloc.nextFreeBlock + 16⟩,
              mem :=
                ((S.mem.storeAt (ns.add (BitVec.ofNat 64 (512 * j)))
                        (Ref.fd_curve25519_scalar_wnaf.spec x 4)).storeQuad
                    (ai.add (BitVec.ofNat 64 (1536 * j)))
                    (fd_curve25519_into_precomputed.spec A)).storeQuad a2
                  (fd_ed25519_point_dbln.spec A 1) } →
          (runM E' ^bb13 S' >>= g) = K) :
    (runM E ^bb11 S >>= g) = K := by
  have hnov : ¬n.offset.uaddOverflow (BitVec.ofNat 64 (32 * j)) := by
    simp [BitVec.uaddOverflow]
    omega
  have haov : ¬a.offset.uaddOverflow (BitVec.ofNat 64 (192 * j)) := by
    simp [BitVec.uaddOverflow]
    omega
  have hso : (ns.add (BitVec.ofNat 64 (512 * j))).offset.uaddOverflow 512#64 = false := by
    simp [Pointer.add, hnso, BitVec.uaddOverflow]
    omega
  block_init
  step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega), Nat.mul_comm j 512]
  step_pure [shl5_ofNat64]
  step_pure [gep_value (f := { nuw := true }) hnov (Or.inl rfl)]
  step_call using Firedancer.LaneNI.Mlir.fd_curve25519_scalar_wnaf.call_eq
  step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega), Nat.mul_comm j 1536]
  step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega), Nat.mul_comm j 192,
    gep_value (f := { nuw := true }) haov (Or.inl rfl)]
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_set.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_dbln.call_eq consuming hA
  step_call using Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed.call_eq
  finish_block
  refine hK E S hArgs (by env_reads) (by env_reads) ?_
  rw [hS, storeQuad_swap hair.1 (by simpa [Pointer.add_id] using haia2)]

/-- One table-loop iteration's effect at `k`: `t = a2 + aj[k-1]`, then `aj[k]` from it; eighteen
blocks. -/
abbrev tableStep (tp aj : Pointer) (A2 P : Quad) (k : Nat) (S : GlobalState) : GlobalState :=
  let t := fd_ed25519_point_add_with_opts.spec A2 P 1#32
  { alloc := ⟨S.alloc.nextFreeBlock + 18⟩,
    mem :=
      (S.mem.storeQuad tp t).storeQuad (aj.add (BitVec.ofNat 64 (192 * k)))
        (fd_curve25519_into_precomputed.spec t) }

/-- `^bb13`, the table loop of `aj = ai[j]` at `k`: `t = a2 + aj[k-1]`, `aj[k]` from it; then
around or on to `^bb12`. -/
theorem table_iter (r n a ns ai a2 tp aj : Pointer) (sz : Nat) (A2 P : Quad)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (j k : Nat) (hk1 : 1 ≤ k)
    (hk : k < 8) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : SetupRegs ns ai a2 tp E)
    (hRk : E ⊨ [%47 := BitVec.ofNat 64 j, %51 := aj, %57 := BitVec.ofNat 64 k]) (hwf : S.WF)
    (ha2 : S.mem.QuadFit a2) (htp : S.mem.QuadRoom tp)
    (hP : S.mem.QuadFit (aj.add (BitVec.ofNat 64 (192 * (k - 1)))))
    (hQ : S.mem.QuadRoom (aj.add (BitVec.ofNat 64 (192 * k)))) (htaj : tp.id ≠ aj.id)
    (ha2v : S.mem.readQuad a2 = A2)
    (hPv : S.mem.readQuad (aj.add (BitVec.ofNat 64 (192 * (k - 1)))) = P)
    (hexit :
      k + 1 = 8 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            SetupRegs ns ai a2 tp E' → (E' ⊨ [%47 := BitVec.ofNat 64 j]) →
            S' = tableStep tp aj A2 P k S →
            (runM E' ^bb12 S' >>= g) = K)
    (hback :
      k + 1 < 8 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            SetupRegs ns ai a2 tp E' →
            (E' ⊨ [%47 := BitVec.ofNat 64 j, %51 := aj, %57 := BitVec.ofNat 64 (k + 1)]) →
            S' = tableStep tp aj A2 P k S →
            (runM E' ^bb13 S' >>= g) = K) :
    (runM E ^bb13 S >>= g) = K := by
  block_init
  step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mul_comm k 192,
    show 192 * k < 2 ^ 64 by omega]
  step_pure [off_prev (c := 18446744073709551424) rfl hk1 (show 192 * k < 2 ^ 64 by omega)]
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed.call_eq
  step_pure [saddOverflow_one64 (show k + 1 < 2 ^ 63 by omega),
    uaddOverflow_one64 (show k + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure
  finish_block
  case
    isTrue =>
    have h8 : k + 1 = 8 := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    refine hexit h8 E S hArgs (by env_reads) (by env_reads) ?_
    subst hS
    rw [MemoryState.storeQuad_storeQuad_self hQ.1]
  case
    isFalse =>
    have h8 : k + 1 < 8 := by
      by_contra h
      exact hbr (by rw [show k + 1 = 8 by omega])
    refine hback h8 E S hArgs (by env_reads) (by env_reads) ?_
    subst hS
    rw [MemoryState.storeQuad_storeQuad_self hQ.1]

/-- `^bb12`: on to the next point, or out to `^bb1` after the last. -/
theorem point_next (r n a ns ai a2 tp : Pointer) (sz : Nat) (hsz : sz ≤ 32)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (j : Nat) (hj : j < sz)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : SetupRegs ns ai a2 tp E) (hRj : E ⊨ [%47 := BitVec.ofNat 64 j])
    (hexit :
      j + 1 = sz →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            SetupRegs ns ai a2 tp E' → (runM E' ^bb1 S >>= g) = K)
    (hback :
      j + 1 < sz →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            SetupRegs ns ai a2 tp E' → (E' ⊨ [%47 := BitVec.ofNat 64 (j + 1)]) →
            (runM E' ^bb11 S >>= g) = K) :
    (runM E ^bb12 S >>= g) = K := by
  block_init
  step_pure [uaddOverflow_one64 (show j + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure
  finish_block
  case isTrue =>
    have h : j + 1 = sz := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    exact hexit h E hArgs (by env_reads)
  case isFalse =>
    have h : j + 1 < sz := by
      by_contra h'
      exact hbr (by rw [show j + 1 = sz by omega])
    exact hback h E hArgs (by env_reads) (by env_reads)

/-- The setup loop's objects: the locals apart from each other and from the inputs, from their
blocks' starts. -/
structure SetupLayout (n a ns ai a2 tp : Pointer) : Prop where
  nsn : ns.id ≠ n.id
  nsa : ns.id ≠ a.id
  ain : ai.id ≠ n.id
  aia : ai.id ≠ a.id
  a2n : a2.id ≠ n.id
  a2a : a2.id ≠ a.id
  tn : tp.id ≠ n.id
  ta : tp.id ≠ a.id
  nsai : ns.id ≠ ai.id
  nsa2 : ns.id ≠ a2.id
  nst : ns.id ≠ tp.id
  aia2 : ai.id ≠ a2.id
  ait : ai.id ≠ tp.id
  a2t : a2.id ≠ tp.id
  nso : ns.offset = 0
  aio : ai.offset = 0

/-- The `sz` scalars `x 0, …, x (sz - 1)` at `n`, 32 bytes apart. -/
def ScalarsAt (m : MemoryState) (n : Pointer) (sz : Nat) (x : Nat → BitVec 256) : Prop :=
  ∀ k < sz,
    Fits m (n.add (BitVec.ofNat 64 (32 * k))) (8 * 32) ∧
      m.readAt (n.add (BitVec.ofNat 64 (32 * k))) 256 = x k

theorem ScalarsAt.alloca {s : GlobalState} (hwf : s.WF) (h : ScalarsAt s.mem n sz x) :
    ScalarsAt (s.alloca k d).mem n sz x := fun j hj =>
  ⟨(h j hj).1.alloca hwf, by rw [MemoryState.readAt_alloca hwf (h j hj).1.inBounds, (h j hj).2]⟩

theorem ScalarsAt.lifetimeStart {m : MemoryState} (h : ScalarsAt m n sz x) (hne : n.id ≠ p.id) :
    ScalarsAt (m.lifetimeStart p) n sz x := fun j hj =>
  ⟨(h j hj).1.lifetimeStart (by simpa [Pointer.add_id] using hne), by
    rw [MemoryState.readAt_lifetimeStart, (h j hj).2]⟩

theorem TableAt.alloca {s : GlobalState} (hwf : s.WF) (h : TableAt s.mem q k f) :
    TableAt (s.alloca n d).mem q k f := fun j hj =>
  ⟨(h j hj).1.alloca hwf, by
    rw [MemoryState.readQuad_alloca (GlobalState.ne_allocaPtr_of_fits hwf (h j hj).1.2.1),
      (h j hj).2]⟩

attribute [local mlir_transport] ScalarsAt.alloca ScalarsAt.lifetimeStart TableAt.alloca

/-- What the setup loop needs of a memory: room for `r` and the locals, the inputs in place, and
the slides of points `0 … js - 1` and the tables of points `0 … jt - 1`. -/
structure MemSetup (m : MemoryState) (r n a ns ai a2 tp : Pointer) (sz : Nat)
    (x : Nat → BitVec 256) (A : Nat → Quad) (js jt : Nat) : Prop where
  roomR : m.QuadRoom r
  roomT : m.QuadRoom tp
  roomA2 : m.QuadRoom a2
  roomNS : Room m ns (8 * 512 * 32)
  roomAI : Room m ai (1536 * 256)
  scalars : ScalarsAt m n sz x
  points : TableAt m a sz A
  slides : ∀ k < js,
    SlidesAt m (ns.add (BitVec.ofNat 64 (512 * k))) (fd_curve25519_scalar_wnaf.wnaf (x k) 4)
  tbls : ∀ k < jt, TableAt m (ai.add (BitVec.ofNat 64 (1536 * k))) 8 (table (A k))

/-- `MemSetup` past a point stored in another block. -/
theorem MemSetup.storeQuad_of_ne {m : MemoryState} (h : MemSetup m r n a ns ai a2 tp sz x A js jt)
    (hn : p.id ≠ n.id) (ha : p.id ≠ a.id) (hns : p.id ≠ ns.id) (hai : p.id ≠ ai.id) :
    MemSetup (m.storeQuad p P) r n a ns ai a2 tp sz x A js jt where
  roomR := h.roomR.storeQuad
  roomT := h.roomT.storeQuad
  roomA2 := h.roomA2.storeQuad
  roomNS := h.roomNS.storeQuad
  roomAI := h.roomAI.storeQuad
  scalars k hk :=
    ⟨(h.scalars k hk).1.storeQuad, by
      rw [MemoryState.readAt_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hn)]
      exact (h.scalars k hk).2⟩
  points := h.points.storeQuad ha
  slides k hk := slidesAt_storeQuad (h.slides k hk) (by simpa [Pointer.add_id] using hns)
  tbls k hk := (h.tbls k hk).storeQuad (by simpa [Pointer.add_id] using hai)

/-- `MemSetup` past a point stored at byte `o` of `ai`, past the tables in place. -/
theorem MemSetup.storeQuad_ai {m : MemoryState} (h : MemSetup m r n a ns ai a2 tp sz x A js jt)
    (hL : SetupLayout n a ns ai a2 tp) (ho : 1536 * jt ≤ o) (ho' : o + 192 ≤ 1536 * 256) :
    MemSetup (m.storeQuad (ai.add (BitVec.ofNat 64 o)) P) r n a ns ai a2 tp sz x A js jt where
  roomR := h.roomR.storeQuad
  roomT := h.roomT.storeQuad
  roomA2 := h.roomA2.storeQuad
  roomNS := h.roomNS.storeQuad
  roomAI := h.roomAI.storeQuad
  scalars k hk :=
    ⟨(h.scalars k hk).1.storeQuad, by
      rw [MemoryState.readAt_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hL.ain)]
      exact (h.scalars k hk).2⟩
  points := h.points.storeQuad (by simpa [Pointer.add_id] using hL.aia)
  slides k hk := slidesAt_storeQuad (h.slides k hk) (by simpa [Pointer.add_id] using hL.nsai.symm)
  tbls k hk e he := by
    have hai : ai.offset.toNat = 0 := by rw [hL.aio]; rfl
    refine ⟨(h.tbls k hk e he).1.storeQuad, ?_⟩
    rw [add_ofNat_add, MemoryState.readQuad_storeQuad_apart (by omega) (by omega) (by omega),
      ← add_ofNat_add]
    exact (h.tbls k hk e he).2

/-- `MemSetup` past the slides of point `j` stored, past the slides in place. -/
theorem MemSetup.storeAt_ns {m : MemoryState} {y : BitVec v}
    (h : MemSetup m r n a ns ai a2 tp sz x A js jt) (hL : SetupLayout n a ns ai a2 tp)
    (hj : js ≤ j) (hj' : j < 32) :
    MemSetup (m.storeAt (ns.add (BitVec.ofNat 64 (512 * j))) y) r n a ns ai a2 tp sz x A js
      jt where
  roomR := h.roomR.storeAt
  roomT := h.roomT.storeAt
  roomA2 := h.roomA2.storeAt
  roomNS := h.roomNS.storeAt
  roomAI := h.roomAI.storeAt
  scalars k hk :=
    ⟨(h.scalars k hk).1.storeAt, by
      rw [MemoryState.readAt_storeAt_disjoint
          (Or.inl (by simpa [Range.of, Pointer.add] using hL.nsn))]
      exact (h.scalars k hk).2⟩
  points := h.points.storeAt (by simpa [Pointer.add_id] using hL.nsa)
  slides k hk e he := by
    have hns : ns.offset.toNat = 0 := by rw [hL.nso]; rfl
    refine ⟨(h.slides k hk e he).1.storeAt, ?_⟩
    rw [add_ofNat_add, MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_add (by omega) (by omega) (by omega)), ← add_ofNat_add]
    exact (h.slides k hk e he).2
  tbls k hk := (h.tbls k hk).storeAt (by simpa [Pointer.add_id] using hL.nsai)

/-- `MemSetup` with point `j`'s slides added. -/
theorem MemSetup.add_slide {m : MemoryState} (h : MemSetup m r n a ns ai a2 tp sz x A j jt)
    (hs :
      SlidesAt m (ns.add (BitVec.ofNat 64 (512 * j))) (fd_curve25519_scalar_wnaf.wnaf (x j) 4)) :
    MemSetup m r n a ns ai a2 tp sz x A (j + 1) jt :=
  { h with
    slides := fun k hk => by
      rcases Nat.lt_or_ge k j with hkj | hkj
      · exact h.slides k hkj
      · obtain rfl : k = j := by omega
        exact hs }

/-- `MemSetup` with point `j`'s table added. -/
theorem MemSetup.add_tbl {m : MemoryState} (h : MemSetup m r n a ns ai a2 tp sz x A js j)
    (ht : TableAt m (ai.add (BitVec.ofNat 64 (1536 * j))) 8 (table (A j))) :
    MemSetup m r n a ns ai a2 tp sz x A js (j + 1) :=
  { h with
    tbls := fun k hk => by
      rcases Nat.lt_or_ge k j with hkj | hkj
      · exact h.tbls k hkj
      · obtain rfl : k = j := by omega
        exact ht }

/-- Byte `o` of a block, from its start. -/
theorem offset_add_of_zero {p : Pointer} (h : p.offset = 0) (ho : o < 2 ^ 64) :
    (p.add (BitVec.ofNat 64 o)).offset.toNat = o := by
  simp [Pointer.add, h, Nat.mod_eq_of_lt ho]

/-- Room for point `j`'s slides. -/
theorem MemSetup.roomNS_j {m : MemoryState} (h : MemSetup m r n a ns ai a2 tp sz x A js jt)
    (hL : SetupLayout n a ns ai a2 tp) (hj : j < 32) :
    Room m (ns.add (BitVec.ofNat 64 (512 * j))) (8 * 512) :=
  Room.add_of_le (by simp [BitVec.uaddOverflow, hL.nso]; omega)
    (by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega) h.roomNS

/-- Room for point `j`'s table. -/
theorem MemSetup.roomAI_j {m : MemoryState} (h : MemSetup m r n a ns ai a2 tp sz x A js jt)
    (hL : SetupLayout n a ns ai a2 tp) (hj : j < 32) :
    Room m (ai.add (BitVec.ofNat 64 (1536 * j))) (1536 * 8) :=
  Room.add_of_le (by simp [BitVec.uaddOverflow, hL.aio]; omega)
    (by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega) h.roomAI

/-- What the table loop of point `j` needs of a memory at `k`: `MemSetup` with `j`'s slides, `a2`
holding `2 A[j]`, and `ai[j][0 … k-1]` in place. -/
structure TblFacts (m : MemoryState) (r n a ns ai a2 tp : Pointer) (sz : Nat)
    (x : Nat → BitVec 256) (A : Nat → Quad) (j k : Nat) : Prop where
  base : MemSetup m r n a ns ai a2 tp sz x A (j + 1) j
  fitA2 : m.QuadFit a2
  a2v : m.readQuad a2 = fd_ed25519_point_dbln.spec (A j) 1
  cur : TableAt m (ai.add (BitVec.ofNat 64 (1536 * j))) k (table (A j))

/-- `TblFacts` at `1` after `point_block`. -/
theorem TblFacts.start {m : MemoryState} (h : MemSetup m r n a ns ai a2 tp sz x A j j)
    (hL : SetupLayout n a ns ai a2 tp) (hj : j < 32) :
    TblFacts
      (((m.storeAt (ns.add (BitVec.ofNat 64 (512 * j)))
              (Ref.fd_curve25519_scalar_wnaf.spec (x j) 4)).storeQuad
          (ai.add (BitVec.ofNat 64 (1536 * j)))
          (fd_curve25519_into_precomputed.spec (A j))).storeQuad
        a2 (fd_ed25519_point_dbln.spec (A j) 1)) r n a ns ai a2 tp sz x A j 1 := by
  have h₁ := h.storeAt_ns (y := Ref.fd_curve25519_scalar_wnaf.spec (x j) 4) hL (le_refl j) hj
  have hroom := MemoryState.QuadRoom.entry (h₁.roomAI_j hL hj)
    (by rw [offset_add_of_zero hL.aio (by omega)]; omega) (k := 0)
    (by omega)
  rw [Pointer.add_zero_quad] at hroom
  have h₂ :=
    h₁.storeQuad_ai (P := fd_curve25519_into_precomputed.spec (A j)) hL (o := 1536 * j) (le_refl _)
      (by omega)
  have hfit₂ :=
    MemoryState.QuadFit.storeQuad_self hroom (P := fd_curve25519_into_precomputed.spec (A j))
  have hs : SlidesAt
      (m.storeAt (ns.add (BitVec.ofNat 64 (512 * j))) (Ref.fd_curve25519_scalar_wnaf.spec (x j) 4))
      (ns.add (BitVec.ofNat 64 (512 * j))) (fd_curve25519_scalar_wnaf.wnaf (x j) 4) :=
    SlidesAt.of_readAt (Fits.storeAt_self (h.roomNS_j hL hj))
      (by simp [Pointer.add, hL.nso]; omega) (MemoryState.readAt_storeAt_self (h.roomNS_j hL hj) _)
  refine ⟨(h₂.storeQuad_of_ne hL.a2n hL.a2a hL.nsa2.symm hL.aia2.symm).add_slide ?_,
    MemoryState.QuadFit.storeQuad_self h₂.roomA2, MemoryState.readQuad_storeQuad_self h₂.roomA2, ?_⟩
  · exact slidesAt_storeQuad (slidesAt_storeQuad hs (by simpa [Pointer.add_id] using hL.nsai.symm))
      (by simpa [Pointer.add_id] using hL.nsa2.symm)
  · intro k hk
    obtain rfl : k = 0 := by omega
    rw [Pointer.add_zero_quad]
    refine ⟨hfit₂.storeQuad, ?_⟩
    rw [MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hL.aia2.symm),
      MemoryState.readQuad_storeQuad_self hroom]
    rfl

/-- `TblFacts` after an iteration of point `j`'s table loop: entry `k` stored. -/
theorem TblFacts.step {S : GlobalState} (h : TblFacts S.mem r n a ns ai a2 tp sz x A j k)
    (hL : SetupLayout n a ns ai a2 tp) (hj : j < 32) (hk1 : 1 ≤ k) (hk : k < 8) :
    TblFacts
      (tableStep tp (ai.add (BitVec.ofNat 64 (1536 * j))) (fd_ed25519_point_dbln.spec (A j) 1)
          (table (A j) (k - 1)) k S).mem r n a ns ai a2 tp sz x A j (k + 1) := by
  have hroom :=
    MemoryState.QuadRoom.entry (h.base.roomAI_j hL hj)
      (by rw [offset_add_of_zero hL.aio (by omega)]; omega) hk
  have hai : ai.offset.toNat = 0 := by rw [hL.aio]; rfl
  refine ⟨?_, ?_, ?_, ?_⟩
  · dsimp only
    rw [add_ofNat_add]
    exact (h.base.storeQuad_of_ne hL.tn hL.ta hL.nst.symm hL.ait.symm).storeQuad_ai hL
      (by omega) (by omega)
  · exact h.fitA2.storeQuad.storeQuad
  · dsimp only
    rw [MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hL.aia2),
      MemoryState.readQuad_storeQuad_of_id_ne hL.a2t.symm, h.a2v]
  · intro e he
    rcases Nat.lt_or_ge e k with hek | hek
    · refine ⟨(h.cur e hek).1.storeQuad.storeQuad, ?_⟩
      dsimp only
      rw [add_ofNat_add, add_ofNat_add, MemoryState.readQuad_storeQuad_apart (by omega) (by omega)
          (by omega), ← add_ofNat_add,
        MemoryState.readQuad_storeQuad_of_id_ne (by simpa [Pointer.add_id] using hL.ait.symm)]
      exact (h.cur e hek).2
    · obtain rfl : e = k := by omega
      have hroom' := hroom.storeQuad (p := tp) (P :=
        fd_ed25519_point_add_with_opts.spec (fd_ed25519_point_dbln.spec (A j) 1)
          (table (A j) (e - 1)) 1#32)
      refine ⟨MemoryState.QuadFit.storeQuad_self hroom', ?_⟩
      dsimp only
      rw [MemoryState.readQuad_storeQuad_self hroom']
      obtain ⟨e, rfl⟩ : ∃ e', e = e' + 1 := ⟨e - 1, by omega⟩
      simp only [table, aiTable, Nat.add_sub_cancel]

/-- The table loop's stores are in the frame. -/
theorem eraseFrom_tableStep (hNa : N ≤ aj.id.id) (hNt : N ≤ tp.id.id) :
    (tableStep tp aj A2 P k S).mem.eraseFrom N = S.mem.eraseFrom N := by
  dsimp only
  rw [MemoryState.eraseFrom_storeQuad_of_le (by simpa [Pointer.add_id] using hNa),
    MemoryState.eraseFrom_storeQuad_of_le hNt]

/-- Point `j`'s table loop from `^bb13` at `k`: `ai[j][k …]` stored; at `^bb12` its table is in
place, and only the frame changed. -/
theorem table_loop (r n a ns ai a2 tp : Pointer) (sz : Nat) (x : Nat → BitVec 256) (A : Nat → Quad)
    (N : Nat) (hL : SetupLayout n a ns ai a2 tp) (hNa : N ≤ ai.id.id) (hNt : N ≤ tp.id.id)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (j : Nat) (hj : j < 32) :
    ∀ mm k (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
        SetupRegs ns ai a2 tp E →
        (E ⊨ [%47 := BitVec.ofNat 64 j, %51 := ai.add (BitVec.ofNat 64 (1536 * j)),
          %57 := BitVec.ofNat 64 k]) →
        1 ≤ k → k + mm = 8 → k < 8 → S.WF →
        TblFacts S.mem r n a ns ai a2 tp sz x A j k →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            SetupRegs ns ai a2 tp E' → (E' ⊨ [%47 := BitVec.ofNat 64 j]) → S'.WF →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 18 * mm →
            TblFacts S'.mem r n a ns ai a2 tp sz x A j 8 →
            S'.mem.eraseFrom N = S.mem.eraseFrom N →
            (runM E' ^bb12 S' >>= g) = K) →
        (runM E ^bb13 S >>= g) = K := by
  intro mm
  induction mm with
  | zero =>
    intro k S E _ _ _ _ hm hk; omega
  | succ mm ih =>
    intro k S E hArgs hR hRk hk1 hm hk hwf hF hK
    have hstep := hF.step hL hj hk1 hk
    have hroom :=
      MemoryState.QuadRoom.entry (hF.base.roomAI_j hL hj)
        (by rw [offset_add_of_zero hL.aio (by omega)]; omega) hk
    have hwf' : (tableStep tp (ai.add (BitVec.ofNat 64 (1536 * j)))
        (fd_ed25519_point_dbln.spec (A j) 1) (table (A j) (k - 1)) k S).WF :=
      (GlobalState.WF.bump hwf (by omega)).storeQuad_mk.storeQuad_mk
    have hNaj : N ≤ (ai.add (BitVec.ofNat 64 (1536 * j))).id.id := by
      simpa [Pointer.add_id] using hNa
    refine
      table_iter r n a ns ai a2 tp (ai.add (BitVec.ofNat 64 (1536 * j))) sz _ _ g K j k hk1 hk S E
        hArgs hR hRk hwf hF.fitA2 hF.base.roomT (hF.cur (k - 1) (by omega)).1 hroom
        (by simpa [Pointer.add_id] using hL.ait.symm) hF.a2v (hF.cur (k - 1) (by omega)).2 ?_ ?_
    · intro h8 E' S' h₁ h₂ h₃ hS'
      subst hS'
      obtain rfl : mm = 0 := by omega
      rw [show k + 1 = 8 from h8] at hstep
      exact hK E' _ h₁ h₂ h₃ hwf' rfl hstep (eraseFrom_tableStep hNaj hNt)
    · intro h8 E' S' h₁ h₂ h₃ hS'
      subst hS'
      exact
        ih (k + 1) _ E' h₁ h₂ h₃ (by omega) (by omega) h8 hwf' hstep
          fun E'' S'' h₁' h₂' h₃' hwf'' halloc hTF herase =>
          hK E'' S'' h₁' h₂' h₃' hwf''
            (by
              rw [halloc]; dsimp only; omega)
            hTF (herase.trans (eraseFrom_tableStep hNaj hNt))

/-- The setup loop from `^bb11` at point `j`: the slides and tables of points `j …` stored; at
`^bb1` all are in place, and only the frame changed. -/
theorem point_loop (r n a ns ai a2 tp : Pointer) (sz : Nat) (hsz : sz ≤ 32)
    (x : Nat → BitVec 256) (A : Nat → Quad) (N : Nat) (hL : SetupLayout n a ns ai a2 tp)
    (hno : n.offset.toNat + 32 * sz < 2 ^ 64) (hao : a.offset.toNat + 192 * sz < 2 ^ 64)
    (hNns : N ≤ ns.id.id) (hNa : N ≤ ai.id.id) (hNa2 : N ≤ a2.id.id) (hNt : N ≤ tp.id.id)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫),
      j + m = sz → j < sz →
        E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
        SetupRegs ns ai a2 tp E → (E ⊨ [%47 := BitVec.ofNat 64 j]) → S.WF →
        MemSetup S.mem r n a ns ai a2 tp sz x A j j →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
            SetupRegs ns ai a2 tp E' → S'.WF →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 142 * m →
            MemSetup S'.mem r n a ns ai a2 tp sz x A sz sz →
            S'.mem.eraseFrom N = S.mem.eraseFrom N →
            (runM E' ^bb1 S' >>= g) = K) →
        (runM E ^bb11 S >>= g) = K := by
  intro m
  induction m with
  | zero => intro j S E hm hj; omega
  | succ m ih =>
    intro j S E hm hj hArgs hR hRj hwf hM hK
    have hroom := MemoryState.QuadRoom.entry (hM.roomAI_j (j := j) hL (by omega))
      (by rw [offset_add_of_zero hL.aio (by omega)]; omega) (k := 0) (by omega)
    rw [Pointer.add_zero_quad] at hroom
    refine
      point_block r n a ns ai a2 tp sz hsz g K j hj (x j) (A j) S E hArgs hR hRj hwf hno hao hL.nso
        hL.aio (hM.roomNS_j hL (by omega)) (hM.scalars j hj).1 (hM.scalars j hj).2 hroom
        (hM.points j hj).1 (hM.points j hj).2 hM.roomA2 hL.nsa hL.aia hL.aia2
        fun E₁ S₁ h₁ hR₁ hRk₁ hS₁ => ?_
    have hF₁ : TblFacts S₁.mem r n a ns ai a2 tp sz x A j 1 := by
      rw [hS₁]
      exact TblFacts.start hM hL (by omega)
    have hwf₁ : S₁.WF := by
      rw [hS₁]
      exact (GlobalState.WF.bump hwf (by omega)).storeAt_mk.storeQuad_mk.storeQuad_mk
    have herase₁ : S₁.mem.eraseFrom N = S.mem.eraseFrom N := by
      rw [hS₁]
      dsimp only
      rw [MemoryState.eraseFrom_storeQuad_of_le hNa2,
        MemoryState.eraseFrom_storeQuad_of_le (by simpa [Pointer.add_id] using hNa),
        MemoryState.eraseFrom_storeAt_of_le (by simpa [Pointer.add_id] using hNns)]
    refine
      table_loop r n a ns ai a2 tp sz x A N hL hNa hNt g K j (by omega) 7 1 S₁ E₁ h₁ hR₁ hRk₁
        (le_refl 1) rfl (by omega) hwf₁ hF₁ fun E₂ S₂ h₂ hR₂ hRj₂ hwf₂ hB₂ hTF herase₂ => ?_
    have hM₂ := hTF.base.add_tbl hTF.cur
    have hB₂' : S₂.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 142 := by
      rw [hB₂, hS₁]
    refine
      point_next r n a ns ai a2 tp sz hsz g K j hj S₂ E₂ h₂ hR₂ hRj₂
        (fun h E' h' hR' => ?_) fun h E' h' hR' hRj' => ?_
    · obtain rfl : m = 0 := by omega
      exact hK E' S₂ h' hR' hwf₂ hB₂' (h ▸ hM₂) (herase₂.trans herase₁)
    · exact
        ih (j + 1) S₂ E' (by omega) h h' hR' hRj' hwf₂ hM₂
          fun E'' S'' h'' hR'' hwf'' hB'' hM'' herase'' =>
          hK E'' S'' h'' hR'' hwf'' (by rw [hB'', hB₂']; omega) hM''
            ((herase''.trans herase₂).trans herase₁)

/-! ### The function -/

/-- `^bb1`: `r` the neutral point; on to the main loop at `255`. -/
theorem start_block (r n a ns ai a2 tp : Pointer) (sz : Nat)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : SetupRegs ns ai a2 tp E) (hwf : S.WF) (hr : S.mem.QuadRoom r)
    (hK :
      ∀ (E' : ⟪Γ⟫),
        E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get →
          MainRegs ns ai a2 tp E' → (E' ⊨ [%20 := BitVec.ofNat 64 255]) →
          (runM E' ^bb3 { S with mem := S.mem.storeQuad r fd_ed25519_point_set_zero.spec } >>= g) =
            K) :
    (runM E ^bb1 S >>= g) = K := by
  block_init
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero.call_eq
  finish_block
  subst hS
  exact hK E hArgs (by env_reads) (by env_reads)

/-- `^bb14`: `r` a copy of `t`, the locals' lifetimes end; `r` returned. -/
theorem exit_block (r n a ns ai a2 tp : Pointer) (sz : Nat)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 sz))).get)
    (hR : MainRegs ns ai a2 tp E) (hwf : S.WF) (hr : S.mem.QuadRoom r) (htp : S.mem.QuadFit tp)
    (hrt : r.id ≠ tp.id) :
    (runM E ^bb14 S >>= g) =
      g (.cons (.value r) .nil,
        { S with
          mem :=
            ((((S.mem.storeQuad r (S.mem.readQuad tp)).lifetimeEnd tp).lifetimeEnd a2).lifetimeEnd
                ai).lifetimeEnd ns }) := by
  block_init
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul.call_eq
  iterate 4 step_pure
  finish_block
  subst hS
  rfl

/-- `MemFacts` for the main loop, from `MemSetup` after `r` is stored. -/
theorem MemSetup.memFacts {m : MemoryState} (h : MemSetup m r n a ns ai a2 tp sz x A sz sz)
    (hL : Layout r tp ns ai) :
    MemFacts (m.storeQuad r R) r tp ns ai sz (fun j => fd_curve25519_scalar_wnaf.wnaf (x j) 4)
      (fun j => table (A j)) where
  fitR := MemoryState.QuadFit.storeQuad_self h.roomR
  wrR := h.roomR.storeQuad.2.1.writable
  roomT := h.roomT.storeQuad
  slides j hj := slidesAt_storeQuad (h.slides j hj) (by simpa [Pointer.add_id] using hL.rn)
  tbls j hj := (h.tbls j hj).storeQuad (by simpa [Pointer.add_id] using hL.ra)

/-! ### No points -/

/-- `ladder` without points: `partial_dbl` `i + 1` times. -/
theorem ladder_nil (ai : Nat → Nat → Quad) (w : Nat → Vector Int 256) :
    ∀ i (hi : i < 256) R, ladder ai w 0 i hi R = fd_ed25519_partial_dbl.spec^[i + 1] R
  | 0, _, _ => rfl
  | i + 1, hi, R => by
    rw [ladder, ladder_nil ai w i]
    rfl

/-- `ladderBlocks` without points: `partial_dbl`'s six, `i + 1` times. -/
theorem ladderBlocks_nil (w : Nat → Vector Int 256) :
    ∀ i (hi : i < 256), ladderBlocks w 0 i hi = 6 * (i + 1)
  | 0, _ => rfl
  | i + 1, hi => by
    rw [ladderBlocks, ladderBlocks_nil w i]
    simp only [addsBlocks]
    omega

/-- The loop `^bb15` at `c` without points: `r` a copy of `t`, then `t = partial_dbl( r )`; out
to `^bb14` after `c` rounds. -/
theorem zero_loop (r n a ns ai a2 tp : Pointer) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hrt : r.id ≠ tp.id) :
    ∀ c, 1 ≤ c → c < 256 → ∀ (T : Quad) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 0))).get →
        MainRegs ns ai a2 tp E → (E ⊨ [%11 := 4294967295#32, %65 := BitVec.ofNat 32 c]) → S.WF →
        S.mem.QuadRoom r → S.mem.QuadFit tp → Writable S.mem tp → S.mem.readQuad tp = T →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState) (R' : Quad),
          E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 0))).get →
            MainRegs ns ai a2 tp E' → S'.WF →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 6 * c →
            S'.mem = (S.mem.storeQuad tp (fd_ed25519_partial_dbl.spec^[c] T)).storeQuad r R' →
            (runM E' ^bb14 S' >>= g) = K) →
        (runM E ^bb15 S >>= g) = K := by
  intro c
  induction c with
  | zero => intro h; omega
  | succ c ih =>
    intro _ hc T S E hArgs hR hRc hwf hr htp htw htv hK
    block_init
    step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_final_mul_projective.call_eq
    step_pure [saddOverflow_neg_one32 (show c + 1 < 2 ^ 31 by omega),
      add_neg_one32 (show 1 ≤ c + 1 by omega) (show c + 1 < 2 ^ 32 by omega), Nat.add_sub_cancel]
    step_call using Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl.call_eq
    step_pure
    finish_block
    case isTrue =>
      have hc0 : c = 0 := eq_zero_of_ofNat32 (by omega) hbr
      subst hc0
      refine hK E S T hArgs (by env_reads) hwf (by rw [hS]) ?_
      rw [hS]
      exact MemoryState.storeQuad_comm hrt
    case isFalse =>
      have hc1 : 1 ≤ c := Nat.one_le_iff_ne_zero.mpr fun h => hbr (by rw [h])
      refine
        ih hc1 (by omega) _ S E hArgs (by env_reads) (by env_reads) hwf ‹_› htp htw hread_tp
          fun E' S' R' h' hR' hwf' hB' hS' => hK E' S' R' h' hR' hwf' ?_ ?_
      · rw [hB', hS]
        dsimp only
        omega
      · rw [hS', hS]
        dsimp only
        rw [MemoryState.storeQuad_storeQuad_self htp.1, MemoryState.storeQuad_comm hrt,
          MemoryState.storeQuad_storeQuad_self hr.1]
        rfl

/-- `^bb2`, without points: `r` the neutral point, `t = partial_dbl( r )`; on to `^bb15` at
`255`. -/
theorem zero_block (r n a ns ai a2 tp : Pointer) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 0))).get)
    (hR : MainRegs ns ai a2 tp E) (hR' : E ⊨ [%10 := 255#32, %11 := 4294967295#32]) (hwf : S.WF)
    (hr : S.mem.QuadRoom r) (htp : S.mem.QuadRoom tp) (hrt : r.id ≠ tp.id)
    (hK :
      ∀ (E' : ⟪Γ⟫),
        E'.args = (args (.value r) (.value n) (.value a) (.value (BitVec.ofNat 64 0))).get →
          MainRegs ns ai a2 tp E' →
          (E' ⊨ [%11 := 4294967295#32, %65 := BitVec.ofNat 32 255]) →
          (runM E'
                ^bb15
                { alloc := ⟨S.alloc.nextFreeBlock + 6⟩,
                  mem :=
                    (S.mem.storeQuad r fd_ed25519_point_set_zero.spec).storeQuad tp
                      (fd_ed25519_partial_dbl.spec fd_ed25519_point_set_zero.spec) } >>= g) =
            K) :
    (runM E ^bb2 S >>= g) = K := by
  block_init
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl.call_eq
  finish_block
  subst hS
  exact hK E hArgs (by env_reads) (by env_reads)

end fd_ed25519_multi_scalar_mul_with_opts

attribute [local mlir_transport] fd_ed25519_multi_scalar_mul_with_opts.ScalarsAt.alloca
  fd_ed25519_multi_scalar_mul_with_opts.ScalarsAt.lifetimeStart
  fd_ed25519_multi_scalar_mul_with_opts.TableAt.alloca
  fd_ed25519_multi_scalar_mul_with_opts.TableAt.lifetimeStart

open fd_ed25519_multi_scalar_mul_with_opts in
/-- `call_eq` with points. -/
theorem fd_ed25519_multi_scalar_mul_with_opts.call_eq_pos
    (r n a : Pointer) (sz : Nat) (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadRoom r)
    (hsz0 : 0 < sz) (hsz : sz ≤ 32)
    (hn : ∀ j < sz, Fits s.mem (n.add (BitVec.ofNat 64 (32 * j))) (8 * 32))
    (hno : n.offset.toNat + 32 * sz < 2 ^ 64)
    (ha : ∀ j < sz, s.mem.QuadFit (a.add (BitVec.ofNat 64 (192 * j))))
    (hao : a.offset.toNat + 192 * sz < 2 ^ 64) :
    _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.call
        (_root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.args (.value r)
          (.value n) (.value a) (.value (BitVec.ofNat 64 sz))) s =
      .value
        (.cons (.value r) .nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256) sz⟩,
            mem :=
              s.mem.storeQuad r
                (spec (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256)
                  (fun j => s.mem.readQuad (a.add (BitVec.ofNat 64 (192 * j)))) sz) }) := by
  have hsc : ScalarsAt s.mem n sz fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256 :=
    fun j hj => ⟨hn j hj, rfl⟩
  have hpt : TableAt s.mem a sz fun j => s.mem.readQuad (a.add (BitVec.ofNat 64 (192 * j))) :=
    fun j hj => ⟨ha j hj, rfl⟩
  have hn0 := hn 0 hsz0
  have ha0 := ha 0 hsz0
  simp only [Nat.mul_zero, Pointer.add_zero_quad] at hn0 ha0
  clear hn ha
  generalize (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256) = x at hsc ⊢
  generalize (fun j => s.mem.readQuad (a.add (BitVec.ofNat 64 (192 * j)))) = A at hpt ⊢
  generalize hP : spec x A sz = P
  generalize hk : blocks x sz = k
  func_init
  block_init
  iterate 12 step_pure
  step_alloca with ns
  step_alloca with ai
  step_alloca with a2
  step_alloca with tp
  iterate 4 step_pure
  step_pure
  finish_block
  case isTrue =>
    exfalso
    have := congrArg BitVec.toNat hbr
    simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (show sz < 2 ^ 64 by omega)] at this
    omega
  case isFalse =>
  have hSL : SetupLayout n a ns ai a2 tp :=
    ⟨hn_ne_ns.symm, ha_ne_ns.symm, hn_ne_ai.symm, ha_ne_ai.symm, hn_ne_a2.symm, ha_ne_a2.symm,
      hn_ne_tp.symm, ha_ne_tp.symm, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact,
      by mem_fact, hns_off, hai_off⟩
  have hL : Layout r tp ns ai := ⟨hr_ne_tp, hr_ne_ns, hr_ne_ai, by mem_fact, by mem_fact, hai_off⟩
  have hM : MemSetup S.mem r n a ns ai a2 tp sz x A 0 0 :=
    ⟨hr, MemoryState.QuadRoom.of_room hroom_tp htp_off,
      MemoryState.QuadRoom.of_room hroom_a2 ha2_off, hroom_ns, hroom_ai, hsc, hpt,
      fun _ h => absurd h (by omega), fun _ h => absurd h (by omega)⟩
  clear hsc hpt hn0 ha0
  refine
    point_loop r n a ns ai a2 tp sz hsz x A S₀.alloc.nextFreeBlock hSL hno hao (by slot_bound)
      (by slot_bound) (by slot_bound) (by slot_bound) _ _ sz 0 S E (by omega) hsz0 hArgs
      (by env_reads) (by env_reads) hwf hM fun E₁ S₁ h₁ hR₁ hwf₁ hB₁ hM₁ herase₁ => ?_
  refine
    start_block r n a ns ai a2 tp sz _ _ S₁ E₁ h₁ hR₁ hwf₁ hM₁.roomR fun E₂ h₂ hR₂ hRi₂ => ?_
  refine
    main_loop r n a ns ai a2 tp sz ⟨hsz0, hsz⟩ _ _
      (fun j hj k hk => (Ref.fd_curve25519_scalar_wnaf.wnaf4_digits (x j) k hk).2) hL _ _ 255
      (by decide) _ _ E₂ h₂ hR₂ hRi₂ hwf₁.storeQuad_mk (hM₁.memFacts hL)
      (MemoryState.readQuad_storeQuad_self hM₁.roomR) fun E₃ S₃ R₃ h₃ hR₃ hwf₃ hB₃ hS₃ => ?_
  rw [exit_block r n a ns ai a2 tp sz _ S₃ E₃ h₃ hR₃ hwf₃
    (hS₃ ▸ hM₁.roomR.storeQuad.storeQuad.storeQuad)
    (hS₃ ▸ ((MemoryState.QuadFit.storeQuad_self hM₁.roomT.storeQuad).storeQuad)) hr_ne_tp]
  have htv : S₃.mem.readQuad tp = P := by
    rw [hS₃, MemoryState.readQuad_storeQuad_of_id_ne hr_ne_tp,
      MemoryState.readQuad_storeQuad_self hM₁.roomT.storeQuad, ← hP]
    rfl
  rw [htv, ← hk]
  dsimp only
  rw [MemoryState.eraseFrom_lifetimeEnd_of_le
      (show S₀.alloc.nextFreeBlock ≤ ns.id.id by slot_bound),
    MemoryState.eraseFrom_lifetimeEnd_of_le
      (show S₀.alloc.nextFreeBlock ≤ ai.id.id by slot_bound),
    MemoryState.eraseFrom_lifetimeEnd_of_le
      (show S₀.alloc.nextFreeBlock ≤ a2.id.id by slot_bound),
    MemoryState.eraseFrom_lifetimeEnd_of_le
      (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound),
    hS₃, MemoryState.storeQuad_storeQuad_self hM₁.roomR.1, MemoryState.eraseFrom_storeQuad,
    MemoryState.eraseFrom_storeQuad_of_le (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound)]
  dsimp only
  rw [MemoryState.eraseFrom_storeQuad, herase₁, MemoryState.storeQuad_storeQuad_self hM₁.roomR.1,
    show S₃.alloc = ⟨S₃.alloc.nextFreeBlock⟩ from rfl, hB₃]
  dsimp only
  rw [hB₁]
  clear herase₁ hB₁ hB₃ hS₃ htv
  subst hS
  erase_frame
  simp only [GlobalState.alloca, blocks]
  generalize ladderBlocks _ sz 255 _ = L
  rw [show S₀.alloc.nextFreeBlock + 1 + 1 + 1 + 1 + 142 * sz + L =
    S₀.alloc.nextFreeBlock + (4 + 142 * sz + L) by omega]

open fd_ed25519_multi_scalar_mul_with_opts in
/-- `call_eq` without points. -/
theorem fd_ed25519_multi_scalar_mul_with_opts.call_eq_zero (r n a : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadRoom r) (x : Nat → BitVec 256) (A : Nat → Quad) :
    _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.call
        (_root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.args (.value r)
          (.value n) (.value a) (.value (BitVec.ofNat 64 0))) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + blocks x 0⟩,
            mem := s.mem.storeQuad r (spec x A 0) }) := by
  rw [show blocks x 0 = 4 + 6 * 256 by simp only [blocks, ladderBlocks_nil]]
  generalize hP : spec x A 0 = P
  rw [show spec x A 0 = fd_ed25519_partial_dbl.spec^[256] fd_ed25519_point_set_zero.spec from
    ladder_nil _ _ 255 _ _] at hP
  func_init
  block_init
  iterate 12 step_pure
  step_alloca with ns
  step_alloca with ai
  step_alloca with a2
  step_alloca with tp
  iterate 4 step_pure
  step_pure
  finish_block
  have htp_pt := MemoryState.QuadRoom.of_room hroom_tp htp_off
  clear hroom_a2 hroom_ai hroom_ns
  refine
    zero_block r n a ns ai a2 tp _ _ S E hArgs (by env_reads) (by env_reads) hwf hr htp_pt hr_ne_tp
      fun E₂ h₂ hR₂ hRc₂ => ?_
  refine
    zero_loop r n a ns ai a2 tp _ _ hr_ne_tp 255 (by omega) (by omega) _ _ E₂ h₂ hR₂ hRc₂
      ((GlobalState.WF.bump hwf (by omega)).storeQuad_mk.storeQuad_mk) hr.storeQuad.storeQuad
      (MemoryState.QuadFit.storeQuad_self htp_pt.storeQuad) htp_pt.storeQuad.storeQuad.2.1.writable
      (MemoryState.readQuad_storeQuad_self htp_pt.storeQuad)
      fun E₃ S₃ R₃ h₃ hR₃ hwf₃ hB₃ hS₃ => ?_
  have hr₃ : S₃.mem.QuadRoom r := by
    rw [hS₃]
    exact hr.storeQuad.storeQuad.storeQuad.storeQuad
  have ht₃ : S₃.mem.QuadFit tp := by
    rw [hS₃]
    exact (MemoryState.QuadFit.storeQuad_self htp_pt.storeQuad.storeQuad).storeQuad
  rw [exit_block r n a ns ai a2 tp 0 _ S₃ E₃ h₃ hR₃ hwf₃ hr₃ ht₃ hr_ne_tp]
  have htv : S₃.mem.readQuad tp = P := by
    rw [hS₃, MemoryState.readQuad_storeQuad_of_id_ne hr_ne_tp,
      MemoryState.readQuad_storeQuad_self htp_pt.storeQuad.storeQuad, ← hP]
    exact (Function.iterate_succ_apply _ 255 _).symm
  rw [htv]
  dsimp only
  rw [MemoryState.eraseFrom_lifetimeEnd_of_le
      (show S₀.alloc.nextFreeBlock ≤ ns.id.id by slot_bound),
    MemoryState.eraseFrom_lifetimeEnd_of_le
      (show S₀.alloc.nextFreeBlock ≤ ai.id.id by slot_bound),
    MemoryState.eraseFrom_lifetimeEnd_of_le
      (show S₀.alloc.nextFreeBlock ≤ a2.id.id by slot_bound),
    MemoryState.eraseFrom_lifetimeEnd_of_le
      (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound),
    hS₃, MemoryState.storeQuad_storeQuad_self hr.1, MemoryState.eraseFrom_storeQuad,
    MemoryState.eraseFrom_storeQuad_of_le (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound)]
  dsimp only
  rw [MemoryState.eraseFrom_storeQuad_of_le (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound),
    MemoryState.eraseFrom_storeQuad, MemoryState.storeQuad_storeQuad_self hr.1,
    show S₃.alloc = ⟨S₃.alloc.nextFreeBlock⟩ from rfl, hB₃]
  clear hB₃ hS₃ htv
  subst hS
  erase_frame
  simp only [GlobalState.alloca]

open fd_ed25519_multi_scalar_mul_with_opts in
/-- `fd_ed25519_multi_scalar_mul_with_opts` (with `base_sz = 0`) stores `spec` of the `sz ≤ 32`
scalars at `n`, 32 bytes apart, and points at `a`, 192 bytes apart, at `r` and returns `r`; `r` may
be any of the inputs: they are read before it is written. The block counter advances by
`blocks`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.call_eq
    (r n a : Pointer) (sz : Nat) (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadRoom r)
    (hsz : sz ≤ 32) (hn : Fits s.mem n (8 * 32 * sz)) (hno : n.offset.toNat + 32 * sz < 2 ^ 64)
    (ha : Fits s.mem a (1536 * sz)) (hao : a.offset.toNat + 192 * sz < 2 ^ 64) :
    _root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.call
        (_root_.Firedancer.LaneNI.Mlir.fd_ed25519_multi_scalar_mul_with_opts.args (.value r)
          (.value n) (.value a) (.value (BitVec.ofNat 64 sz))) s =
      .value
        (.cons (.value r) .nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256) sz⟩,
            mem :=
              s.mem.storeQuad r
                (spec (fun j => s.mem.readAt (n.add (BitVec.ofNat 64 (32 * j))) 256)
                  (fun j => s.mem.readQuad (a.add (BitVec.ofNat 64 (192 * j)))) sz) }) := by
  rcases Nat.eq_zero_or_pos sz with rfl | hsz0
  · exact call_eq_zero r n a s hwf hr _ _
  · refine call_eq_pos r n a sz s hwf hr hsz0 hsz (fun j hj => ?_) hno
      (fun j hj => MemoryState.QuadFit.entry ha (by omega) hj) hao
    exact Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega)
      (by rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]; omega) hn

end Proof

end MLIR.Firedancer.LaneNI
