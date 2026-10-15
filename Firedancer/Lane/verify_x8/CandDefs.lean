module

public import Firedancer.Lane.verify_x8.Defs
import Std.Tactic.BVDecide
import Mathlib.Tactic.IntervalCases

/-! `cand_run`'s pieces: the candidates' mask after `n` items, the state after `n` items, the
scalar check's three exits, and the registers at the loop's joins. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

@[expose] public section

namespace Call

variable (c : Call)

/-- `candidates` after the items `j < n`. -/
noncomputable def cm (n : Nat) : BitVec 32 :=
  maskOf fun j => decide (j.val < n) && c.X.cand j

/-- After `n ≤ cnt` items: `results[j] = FD_ED25519_ERR_SIG` for `j < n` outside the frame, `k` and
`s` zero, `results` apart from the two globals. -/
structure Inv (n : Nat) (S : GlobalState) : Prop where
  le : n ≤ c.cnt
  base : c.Base S (storeResults c.s.mem c.a.results (fun _ => errSig) n)
  ks : c.KS S 0 0
  tbl : c.a.results.id ≠ c.tbl.id
  idp : c.a.results.id ≠ c.idp.id

end Call

/-! ## The mask -/

/-- Bit `j` of `maskOf f`: `f j`. -/
theorem maskOf_bit (f : Fin 8 → Bool) (j : Fin 8) : (maskOf f).getLsbD j = f j := by
  have h := congrArg (·.getLsbD 0)
    (BitVec.extractLsb'_packLanes (Vector.ofFn fun j => BitVec.ofBool (f j)) j j.isLt)
  simp only [BitVec.getLsbD_extractLsb', Nat.mul_one, Nat.zero_lt_one, decide_true,
    Bool.true_and, Nat.add_zero, Vector.getElem_ofFn, BitVec.getLsbD_ofBool] at h
  simp only [maskOf, BitVec.getLsbD_setWidth, h, show (j : Nat) < 32 by omega, decide_true,
    Bool.true_and]

/-- `maskOf f` from its lanes. -/
theorem maskOf_eq (f : Fin 8 → Bool) :
    maskOf f =
      (BitVec.ofBool (f 7) ++ BitVec.ofBool (f 6) ++ BitVec.ofBool (f 5) ++ BitVec.ofBool (f 4) ++
          BitVec.ofBool (f 3) ++ BitVec.ofBool (f 2) ++ BitVec.ofBool (f 1) ++
          BitVec.ofBool (f 0)).setWidth 32 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  by_cases h8 : i < 8
  · have := maskOf_bit f ⟨i, h8⟩
    simp only at this
    rw [this]
    interval_cases i <;>
      simp only [BitVec.getLsbD_setWidth, BitVec.getLsbD_append, BitVec.getLsbD_ofBool] <;>
      simp
  · rw [maskOf, BitVec.getLsbD_setWidth, BitVec.getLsbD_setWidth,
      BitVec.getLsbD_of_ge _ i (by omega), BitVec.getLsbD_of_ge _ i (by omega)]

namespace Call

variable (c : Call)

/-- No item, no bit. -/
theorem cm_zero : c.cm 0 = 0 := by
  simp only [cm, maskOf_eq]
  simp

/-- Item `0` a candidate: `candidates = 1`. -/
theorem cm_one (h : c.X.cand 0 = true) : c.cm 1 = 1#32 := by
  simp only [cm, maskOf_eq]
  simp [h]

/-- A candidate's bit. -/
theorem cm_succ_of_cand {n : Nat} (hn : n < 8) (h : c.X.cand ⟨n, hn⟩ = true) :
    c.cm (n + 1) = c.cm n ||| BitVec.ofNat 32 (2 ^ n) := by
  simp only [cm, maskOf_eq]
  interval_cases n <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] at h <;> simp [h] <;>
    bv_decide

/-- A non-candidate leaves the mask. -/
theorem cm_succ_of_not {n : Nat} (hn : n < 8) (h : c.X.cand ⟨n, hn⟩ = false) :
    c.cm (n + 1) = c.cm n := by
  simp only [cm, maskOf_eq]
  interval_cases n <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] at h <;> simp [h]

/-- The bit of item `n` is not set yet. -/
theorem cm_and {n : Nat} (hn : n < 8) : c.cm n &&& BitVec.ofNat 32 (2 ^ n) = 0 := by
  simp only [cm, maskOf_eq]
  interval_cases n <;> simp <;> bv_decide

/-- Item `j < cnt` is a candidate when its `S`, the upper half of its signature, is canonical. -/
theorem cand_eq (hc : c.Ok) {j : Nat} (hj : j < c.cnt) (h8 : j < 8) :
    c.X.cand ⟨j, h8⟩ =
      fd_curve25519_scalar_validate.spec
        ((c.s.mem.readAt (c.it j).sig 512).extractLsb' 256 256) := by
  obtain ⟨_, _, _, hsf, hso, _⟩ := hc.batch.ok j hj
  show x8Cand c.cnt (fun j => if j.val < c.cnt then (c.it j).readS c.s.mem else 0) ⟨j, h8⟩ = _
  simp only [x8Cand, hj, decide_true, Bool.true_and, ite_true, Item.readS]
  rw [Ref.MemoryState.readAt_add_of_fits (v := 512) hsf hso (by decide) (by decide)]

/-- Items past `cnt` are no candidates. -/
theorem cand_ge {j : Nat} (hj : c.cnt ≤ j) (h8 : j < 8) : c.X.cand ⟨j, h8⟩ = false := by
  show x8Cand c.cnt (fun j => if j.val < c.cnt then (c.it j).readS c.s.mem else 0) ⟨j, h8⟩ = false
  simp [x8Cand, show ¬j < c.cnt by omega]

/-- `cand_ge` at a lane. -/
theorem cand_ge' {j : Fin 8} (hj : c.cnt ≤ j.val) : c.X.cand j = false :=
  c.cand_ge hj j.isLt

/-- Past the items the mask is `candidates`. -/
theorem cm_cnt : c.cm c.cnt = c.candMask := by
  unfold cm candMask
  congr 1
  funext j
  by_cases h : j.val < c.cnt
  · simp [h]
  · simp [h, c.cand_ge (j := j.val) (by omega) j.isLt]

/-- A candidate's `a_buf[j]`: its key. -/
theorem bufA_of_cand {j : Fin 8} (h : c.X.cand j = true) : c.bufA j = (c.it j).pk := by
  simp [bufA, h]

/-- A candidate's `r_buf[j]`: its signature. -/
theorem bufR_of_cand {j : Fin 8} (h : c.X.cand j = true) : c.bufR j = (c.it j).sig := by
  simp [bufR, h]

/-- No candidate: `a_buf[j] = identity`. -/
theorem bufA_of_not {j : Fin 8} (h : c.X.cand j = false) : c.bufA j = c.idp := by
  simp [bufA, h]

/-- No candidate: `r_buf[j] = identity`. -/
theorem bufR_of_not {j : Fin 8} (h : c.X.cand j = false) : c.bufR j = c.idp := by
  simp [bufR, h]

/-- A candidate makes the mask nonzero. -/
theorem candMask_ne {j : Fin 8} (h : c.X.cand j = true) : c.candMask ≠ 0 := by
  intro h0
  have := maskOf_bit c.X.cand j
  rw [← candMask, h0, h] at this
  simp at this

end Call

/-! ## The scalar check -/

/-- `fd_curve25519_scalar_validate`'s fast path: a top byte below `0x10`. -/
theorem validate_lo {v : BitVec 512} (h : (v.extractLsb' 504 8).ult 16#8 = true) :
    fd_curve25519_scalar_validate.spec (v.extractLsb' 256 256) = true := by
  simp only [fd_curve25519_scalar_validate.spec, scalarL]
  bv_decide

/-- A top byte from `0x20` on is no scalar. -/
theorem validate_hi {v : BitVec 512} (h : ¬(v.extractLsb' 504 8).ult 32#8 = true) :
    fd_curve25519_scalar_validate.spec (v.extractLsb' 256 256) = false := by
  simp only [fd_curve25519_scalar_validate.spec, scalarL]
  bv_decide

/-- The borrow out of the `subborrow.64` chain `s - ℓ` over the limbs `l0 … l3` of `s`, as the steps
leave it. -/
def sbb (l0 l1 l2 l3 : BitVec 64) : BitVec 8 :=
  if
      l3.toNat <
        1152921504606846976 +
          if
              (if (1503914060200516822 + if 6346243789798364141 ≤ l0.toNat then 0 else 1) ≤
                    l1.toNat then
                  0
                else 1) ≤
                l2.toNat then
            0
          else 1 then
    1#8
  else 0#8

/-! `subborrow`'s borrow out is `a.toNat < b.toNat + c'`; these turn the chain into compares
`bv_decide` reads. -/

private theorem lt_add_ite {a n : Nat} {c : Prop} [Decidable c] :
    (a < n + if c then 0 else 1) ↔ c ∧ a < n ∨ ¬c ∧ a < n + 1 := by split <;> simp [*]

private theorem add_ite_le {a n : Nat} {c : Prop} [Decidable c] :
    (n + (if c then 0 else 1) ≤ a) ↔ c ∧ n ≤ a ∨ ¬c ∧ n + 1 ≤ a := by split <;> simp [*]

private theorem ite_le {a : Nat} {c : Prop} [Decidable c] :
    ((if c then 0 else 1) ≤ a) ↔ c ∨ 1 ≤ a := by
  split <;> simp [*]

private theorem toNat_lt_iff {x : BitVec 64} {n : Nat} (h : n < 2 ^ 64) :
    x.toNat < n ↔ x < BitVec.ofNat 64 n := by
  simp only [BitVec.lt_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]

private theorem le_toNat_iff {x : BitVec 64} {n : Nat} (h : n < 2 ^ 64) :
    n ≤ x.toNat ↔ BitVec.ofNat 64 n ≤ x := by
  simp only [BitVec.le_def, BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]

/-- The chain borrows exactly when `s` is a canonical scalar. -/
theorem sbb_eq_zero (v : BitVec 512) :
    sbb (v.extractLsb' 256 64) (v.extractLsb' 320 64) (v.extractLsb' 384 64)
        (v.extractLsb' 448 64) = 0#8 ↔
      fd_curve25519_scalar_validate.spec (v.extractLsb' 256 256) = false := by
  simp only [sbb, fd_curve25519_scalar_validate.spec, decide_eq_false_iff_not]
  simp (disch := decide) only [lt_add_ite, add_ite_le, ite_le, toNat_lt_iff, le_toNat_iff,
    Nat.reduceAdd]
  simp only [ite_eq_right_iff, BitVec.reduceEq, imp_false]
  unfold scalarL
  bv_decide

/-- The chain does not borrow: no scalar. -/
theorem validate_sbb_zero {v : BitVec 512} {l0 l1 l2 l3 : BitVec 64}
    (h0 : l0 = v.extractLsb' 256 64) (h1 : l1 = v.extractLsb' 320 64)
    (h2 : l2 = v.extractLsb' 384 64) (h3 : l3 = v.extractLsb' 448 64) (h : sbb l0 l1 l2 l3 = 0#8) :
    fd_curve25519_scalar_validate.spec (v.extractLsb' 256 256) = false := by
  subst h0 h1 h2 h3
  exact (sbb_eq_zero v).mp h

/-- The chain borrows: a scalar. -/
theorem validate_sbb_ne {v : BitVec 512} {l0 l1 l2 l3 : BitVec 64}
    (h0 : l0 = v.extractLsb' 256 64) (h1 : l1 = v.extractLsb' 320 64)
    (h2 : l2 = v.extractLsb' 384 64) (h3 : l3 = v.extractLsb' 448 64)
    (h : ¬sbb l0 l1 l2 l3 = 0#8) :
    fd_curve25519_scalar_validate.spec (v.extractLsb' 256 256) = true := by
  subst h0 h1 h2 h3
  exact Bool.eq_true_of_not_eq_false fun h' => h ((sbb_eq_zero v).mpr h')

/-! ## The state after `n` items -/

/-- Item `j`'s inputs the first loop reads, at the entry state. -/
theorem Call.Ok.item {c : Call} (hc : c.Ok) {j : Nat} (hj : j < c.cnt) :
    Room c.s.mem (c.a.results.add (BitVec.ofNat 64 (j * 4))) 32 ∧
      ¬c.a.results.offset.uaddOverflow (BitVec.ofNat 64 (j * 4)) ∧
      InBounds c.s.mem (c.a.sigs.add (BitVec.ofNat 64 (j * 8))) 64 ∧
      c.s.mem.loadPtr (c.a.sigs.add (BitVec.ofNat 64 (j * 8))) = .value (c.it j).sig ∧
      ¬c.a.sigs.offset.uaddOverflow (BitVec.ofNat 64 (j * 8)) ∧
      InBounds c.s.mem (c.a.pks.add (BitVec.ofNat 64 (j * 8))) 64 ∧
      c.s.mem.loadPtr (c.a.pks.add (BitVec.ofNat 64 (j * 8))) = .value (c.it j).pk ∧
      ¬c.a.pks.offset.uaddOverflow (BitVec.ofNat 64 (j * 8)) ∧
      Fits c.s.mem (c.it j).sig 512 ∧ ¬(c.it j).sig.offset.uaddOverflow 64#64 ∧
      c.a.results.id ≠ c.a.sigs.id ∧ c.a.results.id ≠ c.a.pks.id ∧
      c.a.results.id ≠ (c.it j).sig.id := by
  have hB := hc.batch
  obtain ⟨_, _, _, _, hsb, hsl, hpb, hpl, _, _⟩ := hB.holds j hj
  obtain ⟨_, _, _, hsf, hso, _⟩ := hB.ok j hj
  obtain ⟨_, _, ho2, ho3, _, ho5⟩ := hB.off
  have hro := hB.sep.1
  simp only [Arrays.ReadOnly, not_or, not_exists, not_and] at hro
  have hlen := hB.len
  have ov (p : Pointer) (k : Nat) (h : p.offset.toNat + k < 2 ^ 64) :
      ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, ge_iff_le, decide_eq_true_eq, not_le]
    rw [Nat.mod_eq_of_lt (by omega)]; omega
  exact ⟨hB.room j hj, ov _ _ (by omega), hsb, hsl, ov _ _ (by omega), hpb, hpl, ov _ _ (by omega),
    hsf, hso, hro.2.2.1, hro.2.2.2.1, fun h => (hro.2.2.2.2.2 j hj).2.1 h⟩

/-- `results`' block is below the frame. -/
theorem Call.Ok.results_lt {c : Call} (hc : c.Ok) :
    c.a.results.id.id < c.s.alloc.nextFreeBlock := by
  have h := (hc.item (j := 0) (by have := hc.cnt3; omega)).1.inBounds
  simpa only [Pointer.add_id] using hc.wf.id_lt_of_inBounds h

/-- Item `n`'s inputs at the state after `n` items. -/
theorem Call.Inv.item {c : Call} (hc : c.Ok) {n : Nat} {S : GlobalState} (h : c.Inv n S)
    (hn : n < c.cnt) :
    Room S.mem (c.a.results.add (BitVec.ofNat 64 (n * 4))) 32 ∧
      ¬c.a.results.offset.uaddOverflow (BitVec.ofNat 64 (n * 4)) ∧
      InBounds S.mem (c.a.sigs.add (BitVec.ofNat 64 (n * 8))) 64 ∧
      S.mem.loadPtr (c.a.sigs.add (BitVec.ofNat 64 (n * 8))) = .value (c.it n).sig ∧
      ¬c.a.sigs.offset.uaddOverflow (BitVec.ofNat 64 (n * 8)) ∧
      InBounds S.mem (c.a.pks.add (BitVec.ofNat 64 (n * 8))) 64 ∧
      S.mem.loadPtr (c.a.pks.add (BitVec.ofNat 64 (n * 8))) = .value (c.it n).pk ∧
      ¬c.a.pks.offset.uaddOverflow (BitVec.ofNat 64 (n * 8)) ∧
      Fits S.mem (c.it n).sig 512 ∧
      S.mem.readAt (c.it n).sig 512 = c.s.mem.readAt (c.it n).sig 512 ∧
      ¬(c.it n).sig.offset.uaddOverflow 64#64 ∧
      c.a.results.id ≠ c.a.sigs.id ∧ c.a.results.id ≠ c.a.pks.id ∧
      c.a.results.id ≠ (c.it n).sig.id := by
  obtain ⟨hr, hro, hsb, hsl, hso, hpb, hpl, hpo, hsf, hsigo, hne0, hne1, hne2⟩ := hc.item hn
  have hSO :=
    (MemoryState.StoresOff.storeResults (K := fun b => b ≠ c.a.results.id) (m := c.s.mem)
      (fun h => h rfl) (fun _ => errSig) n)
  have hMS := h.base.sameOn
  have lt {q : Pointer} {w : Nat} (hq : InBounds c.s.mem q w) :
      q.id.id < c.s.alloc.nextFreeBlock :=
    hc.wf.id_lt_of_inBounds hq
  have ne {q : Pointer} (o : BitVec 64) (hq : c.a.results.id ≠ q.id) :
      (q.add o).id ≠ c.a.results.id := by
    rw [Pointer.add_id]; exact Ne.symm hq
  refine ⟨hMS.room (lt hr.inBounds) (hSO.room hr), hro, hMS.inBounds (lt hsb) (hSO.inBounds hsb),
    ?_, hso, hMS.inBounds (lt hpb) (hSO.inBounds hpb), ?_, hpo,
    hMS.fits (lt hsf.inBounds) (hSO.sameOn.fits (Ne.symm hne2) hsf), ?_, hsigo, hne0, hne1, hne2⟩
  · rw [hMS.loadPtr (lt hsb), hSO.sameOn.loadPtr (ne _ hne0), hsl]
  · rw [hMS.loadPtr (lt hpb), hSO.sameOn.loadPtr (ne _ hne1), hpl]
  · rw [hMS.readAt (lt hsf.inBounds), hSO.sameOn.readAt (Ne.symm hne2)]

/-- Item `n`'s `results[n] = FD_ED25519_ERR_SIG`. -/
theorem Call.Inv.step {c : Call} (hc : c.Ok) {n : Nat} {S : GlobalState} (h : c.Inv n S)
    (hn : n < c.cnt) :
    c.Inv (n + 1)
      { S with
        mem := S.mem.storeAt (c.a.results.add (BitVec.ofNat 64 (n * 4))) 4294967295#32 } := by
  have hso : S.mem.StoresOff (fun b => b ≠ c.a.results.id)
      (S.mem.storeAt (c.a.results.add (BitVec.ofNat 64 (n * 4))) 4294967295#32) :=
    .storeAt _ (.refl _) (by simp only [Pointer.add_id, ne_eq, not_true_eq_false,
      not_false_eq_true])
  have hlt := hc.results_lt
  have slot_ne (k : Nat) : (c.s.slot k).id ≠ c.a.results.id := by
    intro e
    have := congrArg BlockId.id e
    simp only [GlobalState.slot_id_id] at this
    omega
  have hb := h.base
  have hks := h.ks
  refine ⟨hn, ⟨hb.wf.storeAt, hso.globals hb.globals, hb.frame,
    fun k hk => hso.inBounds (hb.slots k hk), fun k hk => hso.writable (hb.writable k hk), ?_,
    hb.tbl_lt, hb.idp_lt, hso.sameOn.fits (Ne.symm h.tbl) hb.tbl_fits,
    (hso.sameOn.readAt (Ne.symm h.tbl)).trans hb.tbl_read,
    hso.sameOn.fits (Ne.symm h.idp) hb.idp_fits,
    (hso.sameOn.readAt (Ne.symm h.idp)).trans hb.idp_read⟩,
    ⟨hso.sameOn.fits (slot_ne 26) hks.k_fits, (hso.sameOn.readAt (slot_ne 26)).trans hks.k_read,
      hso.sameOn.fits (slot_ne 27) hks.s_fits, (hso.sameOn.readAt (slot_ne 27)).trans hks.s_read⟩,
    h.tbl, h.idp⟩
  show (S.mem.storeAt _ _).eraseFrom _ = _
  rw [MemoryState.eraseFrom_storeAt, hb.mem]
  rfl

/-- `m < cnt` from `clang`'s compare. -/
theorem Call.Ok.lt_of_ult {c : Call} (hc : c.Ok) {m : Nat} (hm : m < 2 ^ 64)
    (h : (BitVec.ofNat 64 m).ult (BitVec.ofNat 64 c.cnt) = true) : m < c.cnt := by
  have := hc.cnt8
  simp only [BitVec.ult, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hm,
    Nat.mod_eq_of_lt (show c.cnt < 2 ^ 64 by omega), decide_eq_true_eq] at h
  exact h

/-- `cnt ≤ m` from `clang`'s compare. -/
theorem Call.Ok.le_of_not_ult {c : Call} (hc : c.Ok) {m : Nat} (hm : m < 2 ^ 64)
    (h : ¬(BitVec.ofNat 64 m).ult (BitVec.ofNat 64 c.cnt) = true) : c.cnt ≤ m := by
  have := hc.cnt8
  simp only [BitVec.ult, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hm,
    Nat.mod_eq_of_lt (show c.cnt < 2 ^ 64 by omega), decide_eq_true_eq] at h
  omega

/-- `cnt = m` from `clang`'s compare. -/
theorem Call.Ok.eq_of_ofNat {c : Call} (hc : c.Ok) {m : Nat} (hm : m < 2 ^ 64)
    (h : BitVec.ofNat 64 c.cnt = BitVec.ofNat 64 m) : c.cnt = m := by
  have := hc.cnt8
  have h' := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt hm,
    Nat.mod_eq_of_lt (show c.cnt < 2 ^ 64 by omega)] at h'
  exact h'

/-- `cnt ≠ m` from `clang`'s compare. -/
theorem Call.Ok.ne_of_ofNat {c : Call} {m : Nat}
    (h : ¬BitVec.ofNat 64 c.cnt = BitVec.ofNat 64 m) : c.cnt ≠ m := fun e => h (e ▸ rfl)

/-- After the `cnt` items, `^bb38`'s memory. -/
theorem Call.Inv.at38 {c : Call} {S : GlobalState} (h : c.Inv c.cnt S) : c.At38 S :=
  ⟨h.base, h.ks⟩

/-! ## The continuations -/

/-- `^bb38` and on: `cand_run`'s continuation with candidates. -/
abbrev To38 (c : Call) {β : Type} (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Prop :=
  ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env38 c E' → c.At38 S' →
    c.candMask ≠ 0 → ((verify_x8 c.batch).runFrom E' 38 S' >>= g) = K

/-- The return at `^bb103`: `cand_run`'s continuation without candidates. -/
abbrev To103 (c : Call) {β : Type} (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    Prop :=
  ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env103 c E' → c.Base S' c.mem38 →
    c.candMask = 0 → ((verify_x8 c.batch).runFrom E' 103 S' >>= g) = K

/-- A fact about each of the 33 `alloca`s, one by one. -/
theorem forall_lt_33 {P : (j : Nat) → j < 33 → Prop} (h0 : P 0 (by decide)) (h1 : P 1 (by decide))
    (h2 : P 2 (by decide)) (h3 : P 3 (by decide)) (h4 : P 4 (by decide)) (h5 : P 5 (by decide))
    (h6 : P 6 (by decide)) (h7 : P 7 (by decide)) (h8 : P 8 (by decide)) (h9 : P 9 (by decide))
    (h10 : P 10 (by decide)) (h11 : P 11 (by decide)) (h12 : P 12 (by decide))
    (h13 : P 13 (by decide)) (h14 : P 14 (by decide)) (h15 : P 15 (by decide))
    (h16 : P 16 (by decide)) (h17 : P 17 (by decide)) (h18 : P 18 (by decide))
    (h19 : P 19 (by decide)) (h20 : P 20 (by decide)) (h21 : P 21 (by decide))
    (h22 : P 22 (by decide)) (h23 : P 23 (by decide)) (h24 : P 24 (by decide))
    (h25 : P 25 (by decide)) (h26 : P 26 (by decide)) (h27 : P 27 (by decide))
    (h28 : P 28 (by decide)) (h29 : P 29 (by decide)) (h30 : P 30 (by decide))
    (h31 : P 31 (by decide)) (h32 : P 32 (by decide))
    (j : Nat) (hj : j < 33) : P j hj := by
  interval_cases j
  exacts [h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14, h15, h16, h17, h18, h19,
    h20, h21, h22, h23, h24, h25, h26, h27, h28, h29, h30, h31, h32]

/-- `verify_x8`'s own globals. -/
noncomputable abbrev ownGlobals : List Global :=
  [⟨"fd_ed25519_lane_base_table", _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table⟩,
    ⟨"verify_x8.identity", _root_.Firedancer.Lane.Mlir.verify_x8_identity⟩]

/-- The call's globals hold `verify_x8`'s own. -/
theorem Call.globals_own (c : Call) (hc : c.Ok) : c.s.mem.Globals ownGlobals :=
  hc.globals.mono rfl fun g hg => by
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hg
    rcases hg with rfl | rfl <;> exact List.mem_append_left _ (by simp)

/-- `results` is writable, the globals' blocks read-only: apart. -/
theorem Call.Ok.results_ne_global {c : Call} (hc : c.Ok) {g : Global} (hg : g ∈ ownGlobals)
    (hcst : g.init.image.constant = true) :
    c.a.results.id ≠ c.s.mem.globalBlock g.sym := by
  have hW := (hc.item (j := 0) (by have := hc.cnt3; omega)).1.2
  simp only [Nat.zero_mul, Pointer.add_zero] at hW
  exact Writable.ne_of_readOnly hW (hc.wf.const_block ((c.globals_own hc).globals_eq hg) hcst)
    (MemoryState.imageBlock_writable hcst)

/-- `fd_ed25519_lane_base_table`'s value. -/
theorem tbl_value_eq (s : GlobalState) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table.value s =
      .value (Ty.wrap _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `identity`'s value. -/
theorem idp_value_eq (s : GlobalState) :
    _root_.Firedancer.Lane.Mlir.verify_x8_identity.value s =
      .value (Ty.wrap _root_.Firedancer.Lane.Mlir.verify_x8_identity.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- The table's block is below the frame. -/
theorem Call.Ok.tbl_lt {c : Call} (hc : c.Ok) : c.tbl.id.id < c.s.alloc.nextFreeBlock :=
  hc.wf.global_lt ((c.globals_own hc).globals_eq
    (g := ⟨"fd_ed25519_lane_base_table", _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table⟩)
    (by simp))

/-- `identity`'s block is below the frame. -/
theorem Call.Ok.idp_lt {c : Call} (hc : c.Ok) : c.idp.id.id < c.s.alloc.nextFreeBlock :=
  hc.wf.global_lt ((c.globals_own hc).globals_eq
    (g := ⟨"verify_x8.identity", _root_.Firedancer.Lane.Mlir.verify_x8_identity⟩) (by simp))

/-- A global's start, by its table entry. -/
theorem ptr_of_global {m : MemoryState} {sym : String} {p : Pointer} {img : GlobalImage}
    (h : m.globals sym = some (p.id, img)) (ho : p.offset = 0) :
    (⟨m.globalBlock sym, 0#64⟩ : Pointer) = p := by
  obtain ⟨id, off⟩ := p
  simp only at ho
  simp [MemoryState.globalBlock, h, ho]

/-! ## The registers at the joins -/

/-- `^bb1`'s registers: item `0`'s top byte from `0x10` on. -/
abbrev Env1 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %70 := PoisonOr.value 2#32,
    %71 := PoisonOr.value 4#32, %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64,
    %74 := PoisonOr.value 8#32, %75 := PoisonOr.value 16#32, %76 := PoisonOr.value 5#64,
    %77 := PoisonOr.value 32#32, %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32,
    %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 :=
    Ty.wrap #v[6365466163363#64, 253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64,
    704489577558#64, 0#64, 0#64], %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64,
    5210002954932#64, 329084955603#64, 4526638806224#64, 373767602335#64, 0#64, 0#64],
    %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %168 := PoisonOr.value (c.it 0).sig,
    %169 := PoisonOr.value ((c.it 0).sig.add 32#64),
    %171 := PoisonOr.value ((c.s.mem.readAt (c.it 0).sig 512).extractLsb' 504 8)]

/-- `^bb3`'s registers: item `0` a candidate. -/
abbrev Env3 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %70 := PoisonOr.value 2#32,
    %71 := PoisonOr.value 4#32, %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64,
    %74 := PoisonOr.value 8#32, %75 := PoisonOr.value 16#32, %76 := PoisonOr.value 5#64,
    %77 := PoisonOr.value 32#32, %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32,
    %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 :=
    Ty.wrap #v[6365466163363#64, 253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64,
    704489577558#64, 0#64, 0#64], %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64,
    5210002954932#64, 329084955603#64, 4526638806224#64, 373767602335#64, 0#64, 0#64],
    %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %168 := PoisonOr.value (c.it 0).sig]

/-- `^bb4`'s registers: item `0` done. -/
abbrev Env4 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %70 := PoisonOr.value 2#32,
    %71 := PoisonOr.value 4#32, %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64,
    %74 := PoisonOr.value 8#32, %75 := PoisonOr.value 16#32, %76 := PoisonOr.value 5#64,
    %77 := PoisonOr.value 32#32, %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32,
    %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 :=
    Ty.wrap #v[6365466163363#64, 253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64,
    704489577558#64, 0#64, 0#64], %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64,
    5210002954932#64, 329084955603#64, 4526638806224#64, 373767602335#64, 0#64, 0#64],
    %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %193 := PoisonOr.value (c.cm 1)]

/-- `^bb8`'s registers: items `0, 1` done. -/
abbrev Env8 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %75 := PoisonOr.value 16#32, %76 := PoisonOr.value 5#64, %77 := PoisonOr.value 32#32,
    %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32, %80 := PoisonOr.value 7#64,
    %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64,
    %86 := PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison,
    %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %223 := PoisonOr.value (c.cm 2)]

/-- `^bb12`'s registers: items `0 … 2` done. -/
abbrev Env12 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %75 := PoisonOr.value 16#32, %76 := PoisonOr.value 5#64, %77 := PoisonOr.value 32#32,
    %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32, %80 := PoisonOr.value 7#64,
    %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64,
    %86 := PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison,
    %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %253 := PoisonOr.value (c.cm 3)]

/-- `^bb13`'s registers: item `3`'s start. -/
abbrev Env13 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %75 := PoisonOr.value 16#32, %76 := PoisonOr.value 5#64, %77 := PoisonOr.value 32#32,
    %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32, %80 := PoisonOr.value 7#64,
    %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64,
    %86 := PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison,
    %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %253 := PoisonOr.value (c.cm 3)]

/-- `^bb17`'s registers: items `0 … 3` done. -/
abbrev Env17 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %75 := PoisonOr.value 16#32, %76 := PoisonOr.value 5#64, %77 := PoisonOr.value 32#32,
    %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32, %80 := PoisonOr.value 7#64,
    %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64,
    %86 := PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison,
    %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %284 := PoisonOr.value (c.cm 4)]

/-- `^bb18`'s registers: item `4`'s start. -/
abbrev Env18 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %75 := PoisonOr.value 16#32, %76 := PoisonOr.value 5#64, %77 := PoisonOr.value 32#32,
    %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32, %80 := PoisonOr.value 7#64,
    %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64,
    %86 := PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison,
    %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %284 := PoisonOr.value (c.cm 4)]

/-- `^bb22`'s registers: items `0 … 4` done. -/
abbrev Env22 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %76 := PoisonOr.value 5#64, %77 := PoisonOr.value 32#32, %78 := PoisonOr.value 6#64,
    %79 := PoisonOr.value 64#32, %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32,
    %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64, 253762649449#64,
    7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64], %84 := Ty.wrap
    #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64, 4526638806224#64,
    373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %313 := PoisonOr.value (c.bufR 4),
    %314 := PoisonOr.value (c.bufA 4), %315 := PoisonOr.value (c.cm 5)]

/-- `^bb23`'s registers: item `5`'s start. -/
abbrev Env23 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %76 := PoisonOr.value 5#64, %77 := PoisonOr.value 32#32, %78 := PoisonOr.value 6#64,
    %79 := PoisonOr.value 64#32, %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32,
    %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64, 253762649449#64,
    7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64], %84 := Ty.wrap
    #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64, 4526638806224#64,
    373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %313 := PoisonOr.value (c.bufR 4),
    %314 := PoisonOr.value (c.bufA 4), %315 := PoisonOr.value (c.cm 5)]

/-- `^bb27`'s registers: items `0 … 5` done. -/
abbrev Env27 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32,
    %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 :=
    Ty.wrap #v[6365466163363#64, 253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64,
    704489577558#64, 0#64, 0#64], %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64,
    5210002954932#64, 329084955603#64, 4526638806224#64, 373767602335#64, 0#64, 0#64],
    %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %313 := PoisonOr.value (c.bufR 4),
    %314 := PoisonOr.value (c.bufA 4), %344 := PoisonOr.value (c.bufR 5),
    %345 := PoisonOr.value (c.bufA 5), %346 := PoisonOr.value (c.cm 6)]

/-- `^bb28`'s registers: item `6`'s start. -/
abbrev Env28 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %79 := PoisonOr.value 64#32,
    %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 :=
    Ty.wrap #v[6365466163363#64, 253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64,
    704489577558#64, 0#64, 0#64], %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64,
    5210002954932#64, 329084955603#64, 4526638806224#64, 373767602335#64, 0#64, 0#64],
    %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %313 := PoisonOr.value (c.bufR 4),
    %314 := PoisonOr.value (c.bufA 4), %344 := PoisonOr.value (c.bufR 5),
    %345 := PoisonOr.value (c.bufA 5), %346 := PoisonOr.value (c.cm 6)]

/-- `^bb32`'s registers: items `0 … 6` done. -/
abbrev Env32 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64,
    %86 := PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison,
    %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %313 := PoisonOr.value (c.bufR 4),
    %314 := PoisonOr.value (c.bufA 4), %344 := PoisonOr.value (c.bufR 5),
    %345 := PoisonOr.value (c.bufA 5), %375 := PoisonOr.value (c.bufR 6),
    %376 := PoisonOr.value (c.bufA 6), %377 := PoisonOr.value (c.cm 7)]

/-- `^bb33`'s registers: item `7`'s start. -/
abbrev Env33 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %58 := PoisonOr.value 16#8,
    %59 := PoisonOr.value 32#8, %60 := PoisonOr.value c.idp, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %63 := PoisonOr.value 1#8,
    %64 := PoisonOr.value 6346243789798364140#64, %65 := PoisonOr.value 1503914060200516822#64,
    %66 := PoisonOr.value 0#64, %67 := PoisonOr.value 1152921504606846976#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64,
    %86 := PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison,
    %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %313 := PoisonOr.value (c.bufR 4),
    %314 := PoisonOr.value (c.bufA 4), %344 := PoisonOr.value (c.bufR 5),
    %345 := PoisonOr.value (c.bufA 5), %375 := PoisonOr.value (c.bufR 6),
    %376 := PoisonOr.value (c.bufA 6), %377 := PoisonOr.value (c.cm 7)]

/-- `^bb36`'s registers: item `7` a candidate. -/
abbrev Env36 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64,
    %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 := PoisonOr.value 3#64,
    %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32, %76 := PoisonOr.value 5#64,
    %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32,
    %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64, 253762649449#64,
    7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64], %84 := Ty.wrap
    #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64, 4526638806224#64,
    373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64, %86 := PoisonOr.value 1#1,
    %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %282 := PoisonOr.value (c.bufR 3),
    %283 := PoisonOr.value (c.bufA 3), %313 := PoisonOr.value (c.bufR 4),
    %314 := PoisonOr.value (c.bufA 4), %344 := PoisonOr.value (c.bufR 5),
    %345 := PoisonOr.value (c.bufA 5), %375 := PoisonOr.value (c.bufR 6),
    %376 := PoisonOr.value (c.bufA 6), %377 := PoisonOr.value (c.cm 7),
    %381 := PoisonOr.value (c.bufR 7)]

/-- `^bb37`'s registers: the loop left early: `cnt` items done. -/
abbrev Env37 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64, 507525298899#64,
    15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64, 0#64],
    %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value 768#32,
    %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %37 := PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32),
    %41 := Ty.wrap (Vector.replicate 8 4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1),
    %43 := Ty.wrap (Vector.replicate 8 1#1), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %55 := PoisonOr.value 4294967295#32,
    %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %60 := PoisonOr.value c.idp,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32,
    %72 := PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64,
    %86 := PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison,
    %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64,
    %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64, 63#64],
    %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64],
    %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate 8 6#64),
    %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64),
    %101 := Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64),
    %105 := Ty.wrap (Vector.replicate 8 9007199254740915#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %107 := PoisonOr.value 0#1,
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8,
    %112 := Ty.wrap (Vector.replicate 8 2251799813685228#64),
    %113 := PoisonOr.value 18446744073709551584#64, %114 := Vector.replicate 16 PoisonOr.poison,
    %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32,
    5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32],
    %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32),
    %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap (Vector.replicate 16 0#1),
    %121 := Ty.wrap (Vector.replicate 16 4294967294#32),
    %122 := Ty.wrap (Vector.replicate 16 4294967295#32),
    %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value 18446744073709551608#64,
    %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1 (PoisonOr.value 0#32) (by decide)).set
    2 (PoisonOr.value 0#32) (by decide)).set 3 (PoisonOr.value 0#32) (by decide)).set 4
    (PoisonOr.value 0#32) (by decide)).set 5 (PoisonOr.value 0#32) (by decide)).set 6
    (PoisonOr.value 0#32) (by decide)).set 7 (PoisonOr.value 0#32) (by decide),
    %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot 1),
    %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3),
    %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5),
    %141 := PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7),
    %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9),
    %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %151 := PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17),
    %153 := PoisonOr.value (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19),
    %155 := PoisonOr.value (c.s.slot 20), %156 := PoisonOr.value (c.s.slot 21),
    %157 := PoisonOr.value (c.s.slot 22), %158 := PoisonOr.value (c.s.slot 23),
    %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value (c.s.slot 25),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31),
    %167 := PoisonOr.value (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0),
    %192 := PoisonOr.value (c.bufR 0), %221 := PoisonOr.value (c.bufA 1),
    %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %410 := PoisonOr.value (c.bufA 6),
    %411 := PoisonOr.value (c.bufR 6), %412 := PoisonOr.value (c.bufA 4),
    %413 := PoisonOr.value (c.bufR 4), %414 := PoisonOr.value (c.bufR 3),
    %415 := PoisonOr.value (c.bufA 3), %416 := PoisonOr.value (c.bufR 5),
    %417 := PoisonOr.value (c.bufA 5), %418 := PoisonOr.value (c.candMask)]


end

end MLIR.Firedancer.Lane.VerifyX8
