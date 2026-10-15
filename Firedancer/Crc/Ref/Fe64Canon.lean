module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Fe64
public import Firedancer.Common.Memory
public import Firedancer.Crc.Ref.Mlir.crc_fe64_canon
public import Firedancer.Crc.Ref.Mlir.crc_fe64_canon_4
public import Firedancer.Crc.Ref.Mlir.crc_fe64_canon_45
public import Firedancer.Crc.Ref.Mlir.crc_fe64_canon_P_5
public import Firedancer.Crc.Ref.Mlir.crc_fe64_canon_P_46
import Std.Tactic.BVDecide

/-!
# `crc_fe64_canon` refinement (MLIR lift ↔ spec)

Each copy of `crc_fe64_canon( c, a )` stores `Fe64.canon` of the 256-bit value at `a` at `c`
(`X mod p` for every `X`: `Fe64.canon_toNat`). The loop is the C's: two passes, each a four-limb
`u128` borrow chain into `t[4]`, then `x = t` when it does not borrow (a branch and a `memcpy` in
the lift). `freeze` is the identity.
-/

namespace MLIR.Firedancer.Crc.Ref

namespace Fe64

@[expose] public section

/-- `crc_fe64_canon`'s `P`: `p = 2^255 - 19` as 256 bits. -/
abbrev pBits : BitVec 256 :=
  57896044618658097711785492504343953926634992332820282019728792003956564819949#256

/-- `(u128)x - P - borrow`, as the loop body computes it. -/
abbrev limbSub (x p b : BitVec 64) : BitVec 128 :=
  x.setWidth 128 - (b.setWidth 128 + p.setWidth 128)

/-- The borrow out of `limbSub`: `(d >> 64) & 1`. -/
abbrev borrowOut (d : BitVec 128) : BitVec 64 :=
  (d >>> 64).setWidth 64 &&& 1#64

/-- One pass of `crc_fe64_canon`'s loop: `x - P` by the `u128` borrow chain, kept when it does not
borrow (`keep` in C picks `x` exactly when it does). -/
def canonPass (X : BitVec 256) : BitVec 256 :=
  let d0 := limbSub (X.extractLsb' 0 64) (pBits.extractLsb' 0 64) 0#64
  let d1 := limbSub (X.extractLsb' 64 64) (pBits.extractLsb' 64 64) (borrowOut d0)
  let d2 := limbSub (X.extractLsb' 128 64) (pBits.extractLsb' 128 64) (borrowOut d1)
  let d3 := limbSub (X.extractLsb' 192 64) (pBits.extractLsb' 192 64) (borrowOut d2)
  if borrowOut d3 = 0#64 then
    d3.setWidth 64 ++ (d2.setWidth 64 ++ (d1.setWidth 64 ++ d0.setWidth 64))
  else X

/-- `crc_fe64_canon( c, a )`'s `c`: two passes. -/
def canon (X : BitVec 256) : BitVec 256 :=
  canonPass (canonPass X)

end

end Fe64

open Fe64

/-- What the canon loop needs of the memory below `xs`'s store, and keeps: room for `c` and `xs`,
`ts` free for a pass, `P`'s block, and the memory outside the frame from `n` unchanged. -/
abbrev CanonFrame (n : Nat) (M₀ : MemoryState) (c xs ts Pp : Pointer) (A : AllocState)
    (M : MemoryState) : Prop :=
  ({ alloc := A, mem := M } : GlobalState).WF ∧
    Room M c 256 ∧
    Room M xs 256 ∧
    InBounds M ts 256 ∧
    Writable M ts ∧ Fits M Pp 256 ∧ M.readAt Pp 256 = pBits ∧ M.eraseFrom n = M₀.eraseFrom n

section Proof

set_option hygiene false in
/-- An iteration `i ≥ 1` of the pass's limb loop: `d = (u128)x[i] - P[i] - borrow`, `t[i] = d`,
`borrow = (d >> 64) & 1`. -/
local macro "canon_iter " hp:ident x:ident p:ident d:ident t:ident b:ident : tactic =>
  `(tactic|
    ( block_init
      step_pure
      step_load with $x:ident
      step_pure
      step_pure
      step_load [$hp:ident] with $p:ident
      iterate 4 step_pure
      step_pure with $d:ident
      step_pure with $t:ident
      step_pure
      step_store
      step_pure
      step_pure [trunc_hi]
      step_pure with transparent $b:ident
      step_pure
      step_pure
      finish_block))

set_option hygiene false in
/-- `crc_fe64_canon.pass`'s proof, any copy. -/
local macro "canon_pass_proof" : tactic =>
  `(tactic|
    ( have hM' := hM.pass hct hxt hpt hnt
      obtain ⟨hwf, -, hxr, htb, htw, hPf, hPr, hMe⟩ := hM
      have hxf : Fits (M.storeAt xs X) xs 256 := Fits.storeAt_self hxr
      obtain ⟨hP0, hP1, hP2, hP3⟩ := readAt_pBits hPf hPo hPr
      block_init
      seal_env
      step_pure
      finish_block
      block_init
      step_pure
      step_load with x0
      step_pure
      step_pure
      step_load [hP0] with p0
      iterate 4 step_pure
      step_pure with d0
      step_pure with t0
      step_pure
      step_store
      step_pure
      step_pure [trunc_hi]
      step_pure with transparent b0
      step_pure
      step_pure
      finish_block
      canon_iter hP1 x1 p1 d1 t1 b1
      canon_iter hP2 x2 p2 d2 t2 b2
      canon_iter hP3 x3 p3 d3 t3 b3
      rw [storeAt_limbs (by simp [hts, BitVec.uaddOverflow])] at hS
      rw [MemoryState.readAt_of_readAt_le (v := 256) (by decide)
          (MemoryState.readAt_storeAt_self hxr X)] at hx0
      -- `keep = 0 - borrow`: `x = t` when `x ≥ P`
      block_init
      step_pure
      finish_block
      · have hb := hbr
        have hT : t3 ++ (t2 ++ (t1 ++ t0)) = canonPass X := by
          clear hK1 hK6
          subst_vars
          simp only [canonPass]
          bv_decide
        block_init
        step_memcpy
        finish_block
        block_init
        step_pure
        finish_block
        · rw [hS, pass_mem_copy hxt, hT]
          exact hK1 hbr E _ hArgs (by env_reads) (hM' _)
        · rw [hS, pass_mem_copy hxt, hT]
          exact hK6 (bv1_eq_zero hbr) E _ hArgs (by env_reads) (hM' _)
      · have hb := hbr
        have hT : canonPass X = X := by
          clear hK1 hK6
          subst_vars
          simp only [canonPass]
          bv_decide
        block_init
        step_pure
        finish_block
        · rw [hS, pass_mem_keep hxt]
          have h := hK1 hbr E _ hArgs (by env_reads) (hM' (t3 ++ (t2 ++ (t1 ++ t0))))
          rwa [hT] at h
        · rw [hS, pass_mem_keep hxt]
          have h := hK6 (bv1_eq_zero hbr) E _ hArgs (by env_reads) (hM' (t3 ++ (t2 ++ (t1 ++ t0))))
          rwa [hT] at h))

set_option hygiene false in
/-- `crc_fe64_canon.call_eq`'s proof, any copy: `pass` its pass lemma, `lit` its `P`'s bits. -/
local macro "canon_proof " pass:ident lit:ident : tactic =>
  `(tactic|
    ( func_init
      block_init
      iterate 3 step_pure
      step_addressof with Pp
      iterate 5 step_pure
      step_alloca with xs
      step_alloca with ts
      step_pure
      have hM₀ : CanonFrame S₀.alloc.nextFreeBlock S.mem c xs ts Pp S.alloc S.mem :=
        ⟨hwf, hc, hroom_xs, hts_bounds, hwritable_ts, hPp_fits, hread_Pp.trans $lit, rfl⟩
      rw [hS] at hM₀
      dsimp only at hM₀
      -- `x[i] = a[i]`
      step_load with a0
      step_store
      step_pure
      step_pure
      step_load with a1
      step_store
      step_pure
      step_pure
      step_load with a2
      step_store
      step_pure
      step_pure
      step_load with a3
      step_store
      finish_block
      rw [storeAt_limbs (by simp [hxs_off, BitVec.uaddOverflow])] at hS
      have hid (i j : Nat) (p q : Pointer) (hp : p = S₀.slot i) (hq : q = S₀.slot j) (h : i ≠ j) :
        p.id ≠ q.id := fun e =>
        h
          (by
            have := congrArg BlockId.id e
            simp only [hp, hq, GlobalState.slot_id_id] at this
            omega)
      have hxt := hid 0 1 xs ts hxs hts (by decide)
      have hnx : S₀.alloc.nextFreeBlock ≤ xs.id.id := by
        simp only [hxs, GlobalState.slot_id_id]; omega
      have hnt : S₀.alloc.nextFreeBlock ≤ ts.id.id := by
        simp only [hts, GlobalState.slot_id_id]; omega
      rw [hS]
      -- pass 1, then pass 2
      refine
        $pass _ _ c a Pp xs ts hxs_off hts_off hxt hPp_ne_xs hPp_ne_ts hc_ne_ts hPp_off hnt _ _ 1#1
          _ _ hM₀ _ E hArgs (by env_reads) ?_ (fun h => absurd h (by decide))
      intro _ E₁ M₁ hArgs₁ hE₁ hM₁
      refine
        $pass _ _ c a Pp xs ts hxs_off hts_off hxt hPp_ne_xs hPp_ne_ts hc_ne_ts hPp_off hnt _ _ 0#1
          _ _ hM₁ _ E₁ hArgs₁ hE₁ (fun h => absurd h (by decide)) ?_
      intro _ E₂ M₂ hArgs₂ hE₂ hM₂
      clear hfits_xs_24 hread_xs_24 hread_xs_16 hread_xs_8 hread_xs hread_Pp hfits_xs_16 hfits_xs_8
        hfits_xs hroom_xs hwf hg hc ha hglobal_Pp hPp_live hPp_fits hwritable_xs hxs_bounds
        hwritable_ts hts_bounds hS hM₀ hM₁ hE hArgs hE₁ hArgs₁
      obtain ⟨hwf₂, hcr₂, hxr₂, -, -, -, -, hMe₂⟩ := hM₂
      -- `memcpy( c, x, 32 )`
      have hwf₂' :=
        GlobalState.WF.storeAt (s := ⟨_, M₂⟩) (p := xs) (x :=
          canonPass (canonPass (a3 ++ (a2 ++ (a1 ++ a0))))) hwf₂
      have hc₂ :=
        Room.storeAt (p := c) (q := xs) (x := canonPass (canonPass (a3 ++ (a2 ++ (a1 ++ a0))))) hcr₂
      have hx₂ := Fits.storeAt_self (x := canonPass (canonPass (a3 ++ (a2 ++ (a1 ++ a0))))) hxr₂
      clear hwf₂ hcr₂
      block_init
      step_memcpy
      step_pure
      finish_block
      rw [hS]
      simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hnx, MemoryState.eraseFrom_storeAt,
        MemoryState.storeAt_eraseFrom_of_le hnx, hMe₂, GlobalState.alloca_alloc]
      erase_frame
      rw [readAt_limb0] at ha0
      rw [readAt_limb (off := 8#64) ha₀ hao (by decide)] at ha1
      rw [readAt_limb (off := 16#64) ha₀ hao (by decide)] at ha2
      rw [readAt_limb (off := 24#64) ha₀ hao (by decide)] at ha3
      subst ha0 ha1 ha2 ha3
      rw [limbs_append']
      rfl))

@[local simp]
theorem setWidth128_ssubOverflow (x y : BitVec 64) :
    (x.setWidth 128).ssubOverflow (y.setWidth 128) = false := by bv_decide

@[local simp]
theorem setWidth128_ssubOverflow_add (x y z : BitVec 64) :
    (x.setWidth 128).ssubOverflow (y.setWidth 128 + z.setWidth 128) = false := by bv_decide

@[local simp]
theorem setWidth128_saddOverflow (x y : BitVec 64) :
    (x.setWidth 128).saddOverflow (y.setWidth 128) = false := by bv_decide

@[local simp]
theorem setWidth128_uaddOverflow (x y : BitVec 64) :
    (x.setWidth 128).uaddOverflow (y.setWidth 128) = false := by bv_decide

@[local simp]
theorem zero_saddOverflow_setWidth128 (y : BitVec 64) :
    (0#128).saddOverflow (y.setWidth 128) = false := by bv_decide

@[local simp]
theorem zero_uaddOverflow_setWidth128 (y : BitVec 64) :
    (0#128).uaddOverflow (y.setWidth 128) = false := by bv_decide

@[local simp]
theorem and_one_saddOverflow_setWidth128 (u y : BitVec 64) :
    (u.setWidth 128 &&& 1#128).saddOverflow (y.setWidth 128) = false := by bv_decide

@[local simp]
theorem and_one_uaddOverflow_setWidth128 (u y : BitVec 64) :
    (u.setWidth 128 &&& 1#128).uaddOverflow (y.setWidth 128) = false := by bv_decide

@[local simp]
theorem setWidth128_ssubOverflow_and_one (x u y : BitVec 64) :
    (x.setWidth 128).ssubOverflow ((u.setWidth 128 &&& 1#128) + y.setWidth 128) = false := by
  bv_decide

/-- `P`'s limbs at its block. -/
theorem readAt_pBits {m : MemoryState} {Pp : Pointer} (hf : Fits m Pp 256) (ho : Pp.offset = 0)
    (h : m.readAt Pp 256 = pBits) :
    m.readAt Pp 64 = 18446744073709551597#64 ∧
      m.readAt (Pp.add 8#64) 64 = 18446744073709551615#64 ∧
      m.readAt (Pp.add 16#64) 64 = 18446744073709551615#64 ∧
      m.readAt (Pp.add 24#64) 64 = 9223372036854775807#64 := by
  have ho' : ¬Pp.offset.uaddOverflow 32#64 := by simp [ho, BitVec.uaddOverflow]
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [readAt_limb0, h]; decide
  · rw [readAt_limb hf ho' (by decide), h]; decide
  · rw [readAt_limb hf ho' (by decide), h]; decide
  · rw [readAt_limb hf ho' (by decide), h]; decide

@[local simp]
theorem and_one_msb (x : BitVec 64) : (x &&& 1#64).msb = false := by bv_decide

/-! ### A pass's memory -/

theorem lifetime_storeAt_comm {m : MemoryState} {p q : Pointer} {x : BitVec w} {l : Bool}
    (h : p.id ≠ q.id) : (m.storeAt p x).setLifetime q l = (m.setLifetime q l).storeAt p x :=
  MemoryState.modifyBlock_comm h

theorem storeAt_storeAt_comm {m : MemoryState} {p q : Pointer} {x : BitVec v} {y : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).storeAt q y = (m.storeAt q y).storeAt p x :=
  MemoryState.modifyBlock_comm h

/-- A pass that keeps `x`: its `t` stores move below `x`'s. -/
theorem pass_mem_keep {M : MemoryState} {xs ts : Pointer} (hxt : xs.id ≠ ts.id) (X T : BitVec 256) :
    (((M.storeAt xs X).lifetimeStart ts).storeAt ts T).lifetimeEnd ts =
      (((M.lifetimeStart ts).storeAt ts T).lifetimeEnd ts).storeAt xs X := by
  simp only [MemoryState.lifetimeStart, MemoryState.lifetimeEnd]
  rw [lifetime_storeAt_comm hxt, storeAt_storeAt_comm hxt, lifetime_storeAt_comm hxt]

/-- A pass that copies `t` to `x`: `x`'s first store is overwritten. -/
theorem pass_mem_copy {M : MemoryState} {xs ts : Pointer} (hxt : xs.id ≠ ts.id)
    (X T Y : BitVec 256) :
    ((((M.storeAt xs X).lifetimeStart ts).storeAt ts T).storeAt xs Y).lifetimeEnd ts =
      (((M.lifetimeStart ts).storeAt ts T).lifetimeEnd ts).storeAt xs Y := by
  simp only [MemoryState.lifetimeStart, MemoryState.lifetimeEnd]
  simp only [lifetime_storeAt_comm hxt, storeAt_storeAt_comm hxt, MemoryState.storeAt_storeAt_self]

theorem bv1_eq_zero {f : BitVec 1} (h : ¬f = 1#1) : f = 0#1 := by bv_decide

/-- A pass keeps the loop's frame facts. -/
theorem CanonFrame.pass {n : Nat} {M₀ M : MemoryState} {c xs ts Pp : Pointer} {A : AllocState}
    (hM : CanonFrame n M₀ c xs ts Pp A M) (hct : c.id ≠ ts.id) (hxt : xs.id ≠ ts.id)
    (hpt : Pp.id ≠ ts.id) (hnt : n ≤ ts.id.id) (T : BitVec 256) :
    CanonFrame n M₀ c xs ts Pp A (((M.lifetimeStart ts).storeAt ts T).lifetimeEnd ts) := by
  obtain ⟨hwf, hcr, hxr, htb, htw, hPf, hPr, hMe⟩ := hM
  refine
    ⟨?_, (Room.lifetimeStart hcr hct).storeAt.lifetimeEnd hct,
      (Room.lifetimeStart hxr hxt).storeAt.lifetimeEnd hxt, htb.lifetimeStart.storeAt.lifetimeEnd,
      htw.lifetimeStart.storeAt.lifetimeEnd, ((hPf.lifetimeStart hpt).storeAt).lifetimeEnd hpt, ?_,
      ?_⟩
  · exact
      GlobalState.WF.lifetimeEnd_mk
        (GlobalState.WF.storeAt (s := ⟨A, _⟩) (GlobalState.WF.lifetimeStart_mk hwf))
  · rw [MemoryState.readAt_lifetimeEnd,
      MemoryState.readAt_storeAt_disjoint (.inl (by simpa [Range.of] using hpt.symm)),
      MemoryState.readAt_lifetimeStart, hPr]
  · rw [MemoryState.eraseFrom_lifetimeEnd_of_le hnt, MemoryState.eraseFrom_storeAt_of_le hnt,
      MemoryState.eraseFrom_lifetimeStart_of_le hnt, hMe]

/-- `^bb1` through `^bb5`: one pass over the value `X` at `xs`, then `^bb1` again (`f = 1`) or
`^bb6`. -/
theorem crc_fe64_canon.pass (n : Nat) (M₀ : MemoryState) (c a Pp xs ts : Pointer)
    (hxs : xs.offset = 0) (hts : ts.offset = 0) (hxt : xs.id ≠ ts.id) (hpx : Pp.id ≠ xs.id)
    (hpt : Pp.id ≠ ts.id) (hct : c.id ≠ ts.id) (hPo : Pp.offset = 0) (hnt : n ≤ ts.id.id) {β : Type}
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (f : BitVec 1) (A : AllocState)
    (M : MemoryState) (hM : CanonFrame n M₀ c xs ts Pp A M) (X : BitVec 256)
    (E : ⟪crc_fe64_canon.Γ⟫) (hArgs : E.args = (crc_fe64_canon.args (.value c) (.value a)).get)
    (hE :
      E ⊨ [%2 := 0#64, %3 := Pp, %4 := 64#128, %5 := 1#64, %6 := 4#64, %7 := 32#64, %8 := 0#1, %9 :=
        xs, %10 := ts, %21 := f])
    (hK1 :
      f = 1#1 →
        ∀ (E' : ⟪crc_fe64_canon.Γ⟫) (M' : MemoryState),
          E'.args = (crc_fe64_canon.args (.value c) (.value a)).get →
            (E' ⊨ [%2 := 0#64, %3 := Pp, %4 := 64#128, %5 := 1#64, %6 := 4#64, %7 := 32#64, %8 :=
              0#1, %9 := xs, %10 := ts, %21 := 0#1]) →
            CanonFrame n M₀ c xs ts Pp A M' →
            (crc_fe64_canon.runFrom E' ^bb1 { alloc := A, mem := M'.storeAt xs (canonPass X) } >>=
                g) =
              K)
    (hK6 :
      f = 0#1 →
        ∀ (E' : ⟪crc_fe64_canon.Γ⟫) (M' : MemoryState),
          E'.args = (crc_fe64_canon.args (.value c) (.value a)).get →
            (E' ⊨ [%7 := 32#64, %9 := xs]) →
            CanonFrame n M₀ c xs ts Pp A M' →
            (crc_fe64_canon.runFrom E' ^bb6 { alloc := A, mem := M'.storeAt xs (canonPass X) } >>=
                g) =
              K) :
    (crc_fe64_canon.runFrom E ^bb1 { alloc := A, mem := M.storeAt xs X } >>= g) = K := by
  canon_pass_proof

theorem pBits_lit {hw : (Ty.array 4 (.bv 64)).width = 256} :
    Ty.flatBits (hw := hw) crc_fe64_canon_P.lit = pBits := by
  apply BitVec.eq_of_toNat_eq
  rw [Ty.flatBits_eq, BitVec.toNat_cast, Ty.toNat_flattenRaw]
  rfl

/-- The four limbs of `X`, reassembled. -/
theorem limbs_append (X : BitVec 256) :
    X.extractLsb' 192 64 ++ (X.extractLsb' 128 64 ++ (X.extractLsb' 64 64 ++ X.extractLsb' 0 64)) =
      X := by
  bv_decide

/-- `limbs_append` at the offsets `readAt_limb` gives. -/
theorem limbs_append' (X : BitVec 256) :
    X.extractLsb' ((24#64).toNat * 8) 64 ++
        (X.extractLsb' ((16#64).toNat * 8) 64 ++
          (X.extractLsb' ((8#64).toNat * 8) 64 ++ X.extractLsb' 0 64)) =
      X :=
  limbs_append X

/-- `crc_fe64_canon( c, a )` stores `canon` of the value at `a` at `c`; its `x[4]` and `t[4]` are
frame slots. `c` may alias `a`. -/
public theorem crc_fe64_canon.call_eq (c a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_canon.globals) (hc : Room s.mem c 256) (ha : Fits s.mem a 256)
    (hao : ¬a.offset.uaddOverflow 32#64) :
    crc_fe64_canon.call (crc_fe64_canon.args (.value c) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩
            mem := s.mem.storeAt c (canon (s.mem.readAt a 256)) }) := by
  canon_proof crc_fe64_canon.pass pBits_lit

@[inherit_doc crc_fe64_canon.pass]
theorem crc_fe64_canon_4.pass (n : Nat) (M₀ : MemoryState) (c a Pp xs ts : Pointer)
    (hxs : xs.offset = 0) (hts : ts.offset = 0) (hxt : xs.id ≠ ts.id) (hpx : Pp.id ≠ xs.id)
    (hpt : Pp.id ≠ ts.id) (hct : c.id ≠ ts.id) (hPo : Pp.offset = 0) (hnt : n ≤ ts.id.id) {β : Type}
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (f : BitVec 1) (A : AllocState)
    (M : MemoryState) (hM : CanonFrame n M₀ c xs ts Pp A M) (X : BitVec 256)
    (E : ⟪crc_fe64_canon_4.Γ⟫) (hArgs : E.args = (crc_fe64_canon_4.args (.value c) (.value a)).get)
    (hE :
      E ⊨ [%2 := 0#64, %3 := Pp, %4 := 64#128, %5 := 1#64, %6 := 4#64, %7 := 32#64, %8 := 0#1, %9 :=
        xs, %10 := ts, %21 := f])
    (hK1 :
      f = 1#1 →
        ∀ (E' : ⟪crc_fe64_canon_4.Γ⟫) (M' : MemoryState),
          E'.args = (crc_fe64_canon_4.args (.value c) (.value a)).get →
            (E' ⊨ [%2 := 0#64, %3 := Pp, %4 := 64#128, %5 := 1#64, %6 := 4#64, %7 := 32#64, %8 :=
              0#1, %9 := xs, %10 := ts, %21 := 0#1]) →
            CanonFrame n M₀ c xs ts Pp A M' →
            (crc_fe64_canon_4.runFrom E' ^bb1 { alloc := A, mem := M'.storeAt xs (canonPass X) } >>=
                g) =
              K)
    (hK6 :
      f = 0#1 →
        ∀ (E' : ⟪crc_fe64_canon_4.Γ⟫) (M' : MemoryState),
          E'.args = (crc_fe64_canon_4.args (.value c) (.value a)).get →
            (E' ⊨ [%7 := 32#64, %9 := xs]) →
            CanonFrame n M₀ c xs ts Pp A M' →
            (crc_fe64_canon_4.runFrom E' ^bb6 { alloc := A, mem := M'.storeAt xs (canonPass X) } >>=
                g) =
              K) :
    (crc_fe64_canon_4.runFrom E ^bb1 { alloc := A, mem := M.storeAt xs X } >>= g) = K := by
  canon_pass_proof

theorem pBits_lit_46 {hw : (Ty.array 4 (.bv 64)).width = 256} :
    Ty.flatBits (hw := hw) crc_fe64_canon_P_46.lit = pBits := by
  apply BitVec.eq_of_toNat_eq
  rw [Ty.flatBits_eq, BitVec.toNat_cast, Ty.toNat_flattenRaw]
  rfl

@[inherit_doc crc_fe64_canon.call_eq]
public theorem crc_fe64_canon_4.call_eq (c a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_canon_4.globals) (hc : Room s.mem c 256) (ha : Fits s.mem a 256)
    (hao : ¬a.offset.uaddOverflow 32#64) :
    crc_fe64_canon_4.call (crc_fe64_canon_4.args (.value c) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩
            mem := s.mem.storeAt c (canon (s.mem.readAt a 256)) }) := by
  canon_proof crc_fe64_canon_4.pass pBits_lit_46

@[inherit_doc crc_fe64_canon.pass]
theorem crc_fe64_canon_45.pass (n : Nat) (M₀ : MemoryState) (c a Pp xs ts : Pointer)
    (hxs : xs.offset = 0) (hts : ts.offset = 0) (hxt : xs.id ≠ ts.id) (hpx : Pp.id ≠ xs.id)
    (hpt : Pp.id ≠ ts.id) (hct : c.id ≠ ts.id) (hPo : Pp.offset = 0) (hnt : n ≤ ts.id.id) {β : Type}
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (f : BitVec 1) (A : AllocState)
    (M : MemoryState) (hM : CanonFrame n M₀ c xs ts Pp A M) (X : BitVec 256)
    (E : ⟪crc_fe64_canon_45.Γ⟫)
    (hArgs : E.args = (crc_fe64_canon_45.args (.value c) (.value a)).get)
    (hE :
      E ⊨ [%2 := 0#64, %3 := Pp, %4 := 64#128, %5 := 1#64, %6 := 4#64, %7 := 32#64, %8 := 0#1, %9 :=
        xs, %10 := ts, %21 := f])
    (hK1 :
      f = 1#1 →
        ∀ (E' : ⟪crc_fe64_canon_45.Γ⟫) (M' : MemoryState),
          E'.args = (crc_fe64_canon_45.args (.value c) (.value a)).get →
            (E' ⊨ [%2 := 0#64, %3 := Pp, %4 := 64#128, %5 := 1#64, %6 := 4#64, %7 := 32#64, %8 :=
              0#1, %9 := xs, %10 := ts, %21 := 0#1]) →
            CanonFrame n M₀ c xs ts Pp A M' →
            (crc_fe64_canon_45.runFrom E' ^bb1
                  { alloc := A, mem := M'.storeAt xs (canonPass X) } >>=
                g) =
              K)
    (hK6 :
      f = 0#1 →
        ∀ (E' : ⟪crc_fe64_canon_45.Γ⟫) (M' : MemoryState),
          E'.args = (crc_fe64_canon_45.args (.value c) (.value a)).get →
            (E' ⊨ [%7 := 32#64, %9 := xs]) →
            CanonFrame n M₀ c xs ts Pp A M' →
            (crc_fe64_canon_45.runFrom E' ^bb6
                  { alloc := A, mem := M'.storeAt xs (canonPass X) } >>=
                g) =
              K) :
    (crc_fe64_canon_45.runFrom E ^bb1 { alloc := A, mem := M.storeAt xs X } >>= g) = K := by
  canon_pass_proof

theorem pBits_lit_5 {hw : (Ty.array 4 (.bv 64)).width = 256} :
    Ty.flatBits (hw := hw) crc_fe64_canon_P_5.lit = pBits := by
  apply BitVec.eq_of_toNat_eq
  rw [Ty.flatBits_eq, BitVec.toNat_cast, Ty.toNat_flattenRaw]
  rfl

@[inherit_doc crc_fe64_canon.call_eq]
public theorem crc_fe64_canon_45.call_eq (c a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals crc_fe64_canon_45.globals) (hc : Room s.mem c 256) (ha : Fits s.mem a 256)
    (hao : ¬a.offset.uaddOverflow 32#64) :
    crc_fe64_canon_45.call (crc_fe64_canon_45.args (.value c) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩
            mem := s.mem.storeAt c (canon (s.mem.readAt a 256)) }) := by
  canon_proof crc_fe64_canon_45.pass pBits_lit_5

end Proof

end MLIR.Firedancer.Crc.Ref
