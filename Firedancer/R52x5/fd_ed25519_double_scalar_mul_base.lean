module

public import MLIR.Run.Tactic
public import Firedancer.Common.Dsmb
public import Firedancer.Common.Tactics
public import Firedancer.R52x5.Globals
public import Firedancer.R52x5.fd_curve25519_scalar_wnaf
public import Firedancer.R52x5.fd_ed25519_point_set_zero
public import Firedancer.R52x5.fd_ed25519_partial_dbl
public import Firedancer.R52x5.fd_ed25519_point_dbln
public import Firedancer.R52x5.fd_ed25519_point_add_with_opts
public import Firedancer.R52x5.fd_ed25519_point_sub_with_opts
public import Firedancer.R52x5.fd_curve25519_into_precomputed
public import Firedancer.R52x5.fd_ed25519_point_add_final_mul
public import Firedancer.R52x5.fd_ed25519_point_add_final_mul_projective
public import Firedancer.R52x5.fd_ed25519_point_set
public import Firedancer.R52x5.Mlir.fd_ed25519_double_scalar_mul_base
import Firedancer.R52x5.Dsmb.Tactics

namespace MLIR.Firedancer.R52x5

/-! ## Specification

The slides are `fd_curve25519_scalar_wnaf.wnaf`'s digits, as `Int`s. The base point's table is a
parameter `tbl`; the function reads `fd_ed25519_base_point_wnaf_table.point`.
`fd_ed25519_point_add_final_mul` and its projective form copy their point. -/

@[expose] public section

namespace fd_ed25519_double_scalar_mul_base

/-- `ai[i]` after the table loop `for( int i=1; i<WNAF_TBL_SZ; i++ )` from `ai[0]` and `a2`:
`t = a2 + ai[i-1]`, then `ai[i]` a copy of `t`, precomputed. -/
def aiTable (a2 ai0 : Quad5) : Nat → Quad5
  | 0 => ai0
  | i + 1 =>
    let t := fd_ed25519_point_add_with_opts.spec a2 (aiTable a2 ai0 i) 1#32
    fd_curve25519_into_precomputed.spec t

/-- `for( i=255; i>=0; i-- ) if( n1slide[i] || n2slide[i] ) break;` from `i` down: the `i` it
stops at, if any. -/
def start (w1 w2 : Vector Int 256) : (i : Nat) → i < 256 → Option (Fin 256)
  | 0, _ => if w1[0] = 0 ∧ w2[0] = 0 then none else some 0
  | i + 1, h => if w1[i + 1] = 0 ∧ w2[i + 1] = 0 then start w1 w2 i (by omega) else some ⟨i + 1, h⟩

/-- A digit's add, `if( d > 0 ) … else if( d < 0 ) …`: `r` a copy of `t`, then `t` as `r` plus or
minus `tbl[|d| / 2]`; nothing at `d = 0`. -/
def addDigit (tbl : Nat → Quad5) (d : Int) (r t : Quad5) : Quad5 × Quad5 :=
  if 0 < d then (t, fd_ed25519_point_add_with_opts.spec t (tbl (d / 2).toNat) 1#32)
  else
    if d < 0 then (t, fd_ed25519_point_sub_with_opts.spec t (tbl (-d / 2).toNat) 1#32) else (r, t)

/-- `t = partial_dbl( r )`, then `n1slide[i]`'s add, `d`, from `ai`. -/
def add1 (ai : Nat → Quad5) (d : Int) (r : Quad5) : Quad5 × Quad5 :=
  addDigit ai d r (fd_ed25519_partial_dbl.spec r)

/-- An iteration's adds on `r`: `add1`, then `n2slide[i]`'s add from `tbl`; the new `r` and `t`. -/
def adds (ai tbl : Nat → Quad5) (d1 d2 : Int) (r : Quad5) : Quad5 × Quad5 :=
  let rt := add1 ai d1 r
  addDigit tbl d2 rt.1 rt.2

/-- The main loop from `i` down to `0` on `r`; each iteration ends with `r` a copy of `t`. -/
def ladder (ai tbl : Nat → Quad5) (w1 w2 : Vector Int 256) : (i : Nat) → i < 256 → Quad5 → Quad5
  | 0, _, r => (adds ai tbl w1[0] w2[0] r).2
  | i + 1, h, r => ladder ai tbl w1 w2 i (by omega) (adds ai tbl w1[i + 1] w2[i + 1] r).2

/-- `n1 A + n2 B` as the code computes it, `B`'s odd multiples precomputed in `tbl`: the slides,
the table `ai` of `A`'s, then the main loop from the first non-zero digit on the neutral point. -/
def spec (tbl : Nat → Quad5) (n1 : BitVec 256) (A : Quad5) (n2 : BitVec 256) : Quad5 :=
  let n1slide := fd_curve25519_scalar_wnaf.wnaf n1 4
  let n2slide := fd_curve25519_scalar_wnaf.wnaf n2 8
  let ai := aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)
  match start n1slide n2slide 255 (by decide) with
  | some i => ladder ai tbl n1slide n2slide i i.isLt quadZero
  | none => quadZero

/-- Blocks a digit's add allocates: `add_with_opts`'s forty-five, `sub_with_opts`'s fifty-one. -/
def digitBlocks (d : Int) : Nat :=
  if 0 < d then 45 else if d < 0 then 51 else 0

/-- Blocks the main loop's callees allocate from `i` down: `partial_dbl`'s forty per iteration,
and the adds'. -/
def ladderBlocks (w1 w2 : Vector Int 256) : (i : Nat) → i < 256 → Nat
  | 0, _ => 40 + digitBlocks w1[0] + digitBlocks w2[0]
  | i + 1, h => 40 + digitBlocks w1[i + 1] + digitBlocks w2[i + 1] + ladderBlocks w1 w2 i (by omega)

/-- The blocks the function allocates, its callees' included: 411 before the main loop (the
table's, five `alloca`s, `dbln`'s fifty, `into_precomputed`'s five, fifty per table entry). -/
def blocks (n1 n2 : BitVec 256) : Nat :=
  let n1slide := fd_curve25519_scalar_wnaf.wnaf n1 4
  let n2slide := fd_curve25519_scalar_wnaf.wnaf n2 8
  411 +
    match start n1slide n2slide 255 (by decide) with
    | some i => ladderBlocks n1slide n2slide i i.isLt
    | none => 0

end fd_ed25519_double_scalar_mul_base

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- The `n1slide[l]` probe of the zero-digit search: `l` zero-extended, the digit loaded and
tested. -/
local macro "probe1 " l:term : tactic =>
  `(tactic|
    ( obtain ⟨hf, hld⟩ := hn1s ($l) (by omega)
      step_pure [msb_ofNat32 (show $l < 2 ^ 31 by omega),
        setWidth_ofNat32 (show $l < 2 ^ 32 by omega)]
      step_pure [Nat.mod_eq_of_lt (show $l < 2 ^ 64 by omega), show 2 * ($l) < 2 ^ 64 by omega,
        show ($l) * 2 = 2 * ($l) by omega]
      step_load inline consuming hf hld
      step_pure
      finish_block))

set_option hygiene false in
/-- The `n2slide[l]` probe. -/
local macro "probe2 " l:term : tactic =>
  `(tactic|
    ( obtain ⟨hf, hld⟩ := hn2s ($l) (by omega)
      block_init
      step_pure [Nat.mod_eq_of_lt (show $l < 2 ^ 64 by omega), show 2 * ($l) < 2 ^ 64 by omega,
        show ($l) * 2 = 2 * ($l) by omega]
      step_load inline consuming hf hld
      step_pure
      finish_block))

set_option hygiene false in
/-- After a probe of `n1slide[l]`: at a non-zero, on to the main loop; at a zero, `h1`. -/
local macro "found_or_zero1 " l:term : tactic =>
  `(tactic|
    ( pick_goal 2
      · have h : w1[$l] ≠ 0 := fun h0 => hbr ((ofInt16_eq_zero (hb1 ($l) (by omega))).2 h0)
        subst hS
        exact
          found_block r n1 a n2 tbl n1s n2s ai tp g K ($l) (by omega) _ _ hArgs (by env_reads)
            (by env_reads) (hfound ⟨$l, by omega⟩ (hst.trans (start_of_ne _ fun h' => h h'.1)))
      have h1 : w1[$l] = 0 := (ofInt16_eq_zero (hb1 ($l) (by omega))).1 hbr
      clear hbr))

set_option hygiene false in
/-- After a probe of `n2slide[l]`: at a non-zero, on to the main loop; at a zero, `h2`. -/
local macro "found_or_zero2 " l:term : tactic =>
  `(tactic|
    ( pick_goal 2
      · have h : w2[$l] ≠ 0 := fun h0 => hbr ((ofInt16_eq_zero (hb2 ($l) (by omega))).2 h0)
        subst hS
        exact
          found_block r n1 a n2 tbl n1s n2s ai tp g K ($l) (by omega) _ _ hArgs (by env_reads)
            (by env_reads) (hfound ⟨$l, by omega⟩ (hst.trans (start_of_ne _ fun h' => h h'.2)))
      have h2 : w2[$l] = 0 := (ofInt16_eq_zero (hb2 ($l) (by omega))).1 hbr
      clear hbr))

set_option hygiene false in
/-- A table-loop iteration, unrolled: `t = a2 + ai[i-1]`, then `ai[i]` a copy of `t`,
precomputed. -/
local macro "table_entry " t:ident ai:ident : tactic =>
  `(tactic|
    ( iterate 2 step_pure
      step_call using fd_ed25519_point_add_with_opts.call_eq
      name_quad $t
      step_call using (fd_ed25519_point_add_final_mul.call_eq (hsep := .inr ?_))
      step_call using fd_curve25519_into_precomputed.call_eq
      name_quad $ai
      clear_reads))

set_option hygiene false in
/-- `n1slide[l] == 0 && n2slide[l] == 0`: on to `l' = l - 1`, computed as `i - k`, `c` being
`-k`. -/
local macro "next_index " l:term ", " l':term ", " k:num ", " c:num : tactic =>
  `(tactic|
    ( replace hst := hst.trans (start_of_zero (l := $l) (l' := $l') (by omega) (by omega) ⟨h1, h2⟩)
      clear h1 h2
      block_init
      step_pure [saddOverflow_neg32 (i := i) (c := $c) (k := $k) (by decide) (by decide) (by omega)
            (by omega),
        add_neg32 (i := i) (k := $k) (c := $c) (by decide) (by omega) (by omega)]))

attribute [local mlir_transport] GlobalState.WF.add_blocks₂

/-- Entry `b` of a table at `p`, past a store to entry `a`. -/
theorem readQuad5_storeQuad5_entry {m : MemoryState} {p : Pointer} {a b : Nat} (hp : p.offset = 0)
    (hab : a + 160 ≤ b ∨ b + 160 ≤ a) (ha : a + 160 ≤ 2 ^ 64) (hb : b + 160 ≤ 2 ^ 64) :
    (m.storeQuad5 (p.add (BitVec.ofNat 64 a)) P).readQuad5 (p.add (BitVec.ofNat 64 b)) =
      m.readQuad5 (p.add (BitVec.ofNat 64 b)) :=
  MemoryState.readQuad5_storeQuad5_apart
    (by
      rw [hp]; simpa using ha)
    (by
      rw [hp]; simpa using hb)
    hab

/-- Entry `0` of a table at `p`, past a store to entry `a`. -/
theorem readQuad5_storeQuad5_base_entry {m : MemoryState} {p : Pointer} {a : Nat}
    (hp : p.offset = 0) (ha : 160 ≤ a) (ha' : a + 160 ≤ 2 ^ 64) :
    (m.storeQuad5 (p.add (BitVec.ofNat 64 a)) P).readQuad5 p = m.readQuad5 p := by
  simpa [Pointer.add_ofNat_zero] using
    readQuad5_storeQuad5_entry (m := m) (P := P) (b := 0) hp (.inr (by omega)) ha' (by omega)

/-- `SlidesAt` past a point store into another block. -/
theorem _root_.MLIR.Firedancer.SlidesAt.storeQuad5 {m : MemoryState} (h : SlidesAt m q w)
    (hne : p.id ≠ q.id) : SlidesAt (m.storeQuad5 p P) q w := fun k hk => by
  have h' (c : BitVec 64) : (p.add c).id ≠ (q.add (BitVec.ofNat 64 (2 * k))).id := by
    simpa [Pointer.add_id] using hne
  refine ⟨Fits.storeQuad5 (h k hk).1, ?_⟩
  rw [MemoryState.storeQuad5,
    MemoryState.readAt_storeTmp5_of_id_ne (by simpa using h' 0#64) (h' _) (h' _) (h' _) (h' _)]
  exact (h k hk).2

attribute [local mlir_transport] SlidesAt.storeQuad5

attribute [local mlir_read] readQuad5_storeQuad5_entry readQuad5_storeQuad5_base_entry

namespace fd_ed25519_double_scalar_mul_base

/-! ### Tables in memory -/

/-- `n` points `f 0, …, f (n - 1)` at `p`, 192 bytes apart. -/
def TableAt (m : MemoryState) (p : Pointer) (n : Nat) (f : Nat → Quad5) : Prop :=
  ∀ k < n,
    m.Quad5Fit (p.add (BitVec.ofNat 64 (192 * k))) ∧
      m.readQuad5 (p.add (BitVec.ofNat 64 (192 * k))) = f k

/-- `TableAt` past a store into another block. -/
theorem TableAt.storeQuad5 {m : MemoryState} (h : TableAt m q n f) (hne : p.id ≠ q.id) :
    TableAt (m.storeQuad5 p P) q n f := fun k hk =>
  ⟨(h k hk).1.storeQuad5, by
    rw [MemoryState.readQuad5_storeQuad5_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

/-- The registers the main loop reads, `i` aside. -/
abbrev LoopRegs (tbl n1s n2s ai tp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%935 := 1#32, %939 := 0#16, %943 := 1#16, %944 := tbl, %945 := 0#64, %946 :=
    18446744073709551615#64, %949 := n1s, %950 := n2s, %951 := ai, %953 := tp]

/-- The registers the zero-digit search reads, `i` aside. -/
abbrev SkipRegs (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%940 := 4294967295#32, %941 := 4294967294#32, %942 := 4294967293#32, %947 := 4294967292#32,
    %948 := 0#32]

/-- The entry block's registers that later blocks read. -/
abbrev EntryRegs (tbl n1s n2s ai a2 tp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%935 := 1#32, %938 := 255#32, %939 := 0#16, %940 := 4294967295#32, %941 := 4294967294#32,
    %942 := 4294967293#32, %943 := 1#16, %944 := tbl, %945 := 0#64, %946 := 18446744073709551615#64,
    %947 := 4294967292#32, %948 := 0#32, %949 := n1s, %950 := n2s, %951 := ai, %952 := a2, %953 :=
    tp]

attribute [local mlir_transport] TableAt.storeQuad5

/-! ### The main loop -/

/-- A point store at `t` after stores at `t` and `r`: the stores at `t` merge. -/
theorem storeQuad5_swap {m : MemoryState} {t r : Pointer} (ht : t.offset.toNat + 160 ≤ 2 ^ 64)
    (htr : t.id ≠ r.id) :
    ((m.storeQuad5 t X).storeQuad5 r Y).storeQuad5 t Z = (m.storeQuad5 t Z).storeQuad5 r Y := by
  rw [MemoryState.storeQuad5_comm htr.symm, MemoryState.storeQuad5_storeQuad5_self ht]

/-- One main-loop iteration's stores at `t` and `r`, merged: the last of each. -/
theorem storeQuad5_canon {m : MemoryState} {t r : Pointer} (ht : t.offset.toNat + 160 ≤ 2 ^ 64)
    (hr : r.offset.toNat + 160 ≤ 2 ^ 64) (htr : t.id ≠ r.id) :
    ((((m.storeQuad5 t T₁).storeQuad5 r R₁).storeQuad5 t T₂).storeQuad5 r R₂).storeQuad5 r R₃ =
      (m.storeQuad5 t T₂).storeQuad5 r R₃ := by
  rw [MemoryState.storeQuad5_storeQuad5_self hr, storeQuad5_swap ht htr,
    MemoryState.storeQuad5_storeQuad5_self hr]

/-- The main loop's objects: blocks apart and offsets that do not wrap. -/
structure Layout (r tp n1s n2s ai tbl : Pointer) : Prop where
  rt : r.id ≠ tp.id
  r1 : r.id ≠ n1s.id
  r2 : r.id ≠ n2s.id
  ra : r.id ≠ ai.id
  rb : r.id ≠ tbl.id
  t1 : tp.id ≠ n1s.id
  t2 : tp.id ≠ n2s.id
  ta : tp.id ≠ ai.id
  tb : tp.id ≠ tbl.id
  n1o : n1s.offset.toNat + 512 < 2 ^ 64
  n2o : n2s.offset.toNat + 512 < 2 ^ 64
  aio : ai.offset.toNat + 192 * 8 < 2 ^ 64
  tbo : tbl.offset.toNat + 192 * 128 < 2 ^ 64

/-- What the main loop needs of a state: `r` and `t` fit, the slides and tables in place. -/
structure LoopFacts (S : GlobalState) (r tp n1s n2s ai tbl : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → Quad5) : Prop where
  wf : S.WF
  fitR : S.mem.Quad5Fit r
  fitT : S.mem.Quad5Fit tp
  slides1 : SlidesAt S.mem n1s w1
  slides2 : SlidesAt S.mem n2s w2
  tblA : TableAt S.mem ai 8 AI
  tblB : TableAt S.mem tbl 128 B

/-- `LoopFacts` after `t` and `r` are stored, the counter advanced. -/
theorem LoopFacts.store {S : GlobalState} (h : LoopFacts S r tp n1s n2s ai tbl w1 w2 AI B)
    (hL : Layout r tp n1s n2s ai tbl) (hn : S.alloc.nextFreeBlock ≤ n) :
    LoopFacts ⟨⟨n⟩, (S.mem.storeQuad5 tp T).storeQuad5 r R⟩ r tp n1s n2s ai tbl w1 w2 AI B
    where
  wf := (GlobalState.WF.bump h.wf hn).storeQuad5_mk.storeQuad5_mk
  fitR := h.fitR.storeQuad5.storeQuad5
  fitT := h.fitT.storeQuad5.storeQuad5
  slides1 := (h.slides1.storeQuad5 hL.t1).storeQuad5 hL.r1
  slides2 := (h.slides2.storeQuad5 hL.t2).storeQuad5 hL.r2
  tblA := (h.tblA.storeQuad5 hL.ta).storeQuad5 hL.ra
  tblB := (h.tblB.storeQuad5 hL.tb).storeQuad5 hL.rb

/-- `^bb12`, an iteration's start at `i`: `t = partial_dbl( r )`, then `n1slide[i]`'s add; on to
`^bb16`. -/
theorem head_block (r n1 a n2 tbl n1s n2s ai tp : Pointer) (w1 : Vector Int 256) (AI : Nat → Quad5)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (hw : -15 ≤ w1[i] ∧ w1[i] ≤ 15) (R : Quad5) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai tp E) (hRi : E ⊨ [%1021 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hr : S.mem.Quad5Fit r) (htp : S.mem.Quad5Fit tp) (hrt : r.id ≠ tp.id) (hra : r.id ≠ ai.id)
    (hta : tp.id ≠ ai.id) (htn : tp.id ≠ n1s.id) (hn1o : n1s.offset.toNat + 512 < 2 ^ 64)
    (haio : ai.offset.toNat + 192 * 8 < 2 ^ 64) (hrv : S.mem.readQuad5 r = R)
    (hn1s : SlidesAt S.mem n1s w1) (hai : TableAt S.mem ai 8 AI)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
          LoopRegs tbl n1s n2s ai tp E' →
          (E' ⊨ [%1021 := BitVec.ofNat 64 i]) →
          S' =
            { alloc := ⟨S.alloc.nextFreeBlock + 40 + digitBlocks w1[i]⟩,
              mem := (S.mem.storeQuad5 tp (add1 AI w1[i] R).2).storeQuad5 r (add1 AI w1[i] R).1 } →
          (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb16 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb12 S >>= g) = K := by
  obtain ⟨hf1, hl1⟩ := hn1s i hi
  clear hn1s
  dsimp only [LoopRegs] at hR
  block_init
  step_call using fd_ed25519_partial_dbl.call_eq
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load consuming hf1 hl1
  step_pure
  finish_block
  case
    isTrue =>
    have hpos : 0 < w1[i] := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    obtain ⟨k, hk⟩ : ∃ k, (w1[i] / 2).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 8 := by omega
    obtain ⟨hAf, hAr⟩ := hai k hk8
    clear hai
    block_init
    step_call using (fd_ed25519_point_add_final_mul.call_eq (hsep := .inr ?_))
    step_pure
    step_pure with idx
    have hidx : idx.toNat = k := by rw [hidx, idx_pos (by omega), hk]
    step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega]
    step_call using fd_ed25519_point_add_with_opts.call_eq
    finish_block
    refine hK E S hArgs (by env_reads) (by env_reads) ?_
    rw [hS, storeQuad5_swap htp.1 hrt.symm]
    simp only [add1, addDigit, hpos, ite_true, hk, digitBlocks]
  case
    isFalse =>
    have hnpos : w1[i] ≤ 0 := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    block_init
    step_pure
    finish_block
    case
      isTrue =>
      have hneg : w1[i] < 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simpa using hbr
      obtain ⟨k, hk⟩ : ∃ k, (-w1[i] / 2).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 8 := by omega
      obtain ⟨hAf, hAr⟩ := hai k hk8
      clear hai
      block_init
      step_call using (fd_ed25519_point_add_final_mul.call_eq (hsep := .inr ?_))
      step_pure
      step_pure
      step_pure with idx
      have hidx : idx.toNat = k := by rw [hidx, idx_neg (by omega), hk]
      step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega]
      step_call using fd_ed25519_point_sub_with_opts.call_eq
      finish_block
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      rw [hS, storeQuad5_swap htp.1 hrt.symm]
      simp only [add1, addDigit, hneg, show ¬0 < w1[i] by omega, ite_true, ite_false, hk,
        digitBlocks]
    case
      isFalse =>
      have h0 : w1[i] = 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simp at hbr
        omega
      clear hai
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      simp only [add1, addDigit, h0, lt_irrefl, ite_false, digitBlocks, Nat.add_zero]
      subst hS
      exact congrArg _ (MemoryState.storeQuad5_readQuad5_self' hr hrv).symm

/-- `^bb16`: `n2slide[i]`'s add; on to `^bb20`. -/
theorem digit2_block (r n1 a n2 tbl n1s n2s ai tp : Pointer) (w2 : Vector Int 256) (B : Nat → Quad5)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (hw : -255 ≤ w2[i] ∧ w2[i] ≤ 255) (R T : Quad5) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai tp E) (hRi : E ⊨ [%1021 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hr : S.mem.Quad5Fit r) (htp : S.mem.Quad5Fit tp) (hrt : r.id ≠ tp.id) (hrb : r.id ≠ tbl.id)
    (hn2o : n2s.offset.toNat + 512 < 2 ^ 64) (htbo : tbl.offset.toNat + 192 * 128 < 2 ^ 64)
    (hrv : S.mem.readQuad5 r = R) (htv : S.mem.readQuad5 tp = T) (hn2s : SlidesAt S.mem n2s w2)
    (htbl : TableAt S.mem tbl 128 B)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
          LoopRegs tbl n1s n2s ai tp E' →
          (E' ⊨ [%1021 := BitVec.ofNat 64 i]) →
          S' =
            { alloc := ⟨S.alloc.nextFreeBlock + digitBlocks w2[i]⟩,
              mem :=
                (S.mem.storeQuad5 tp (addDigit B w2[i] R T).2).storeQuad5 r
                  (addDigit B w2[i] R T).1 } →
          (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb20 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb16 S >>= g) = K := by
  obtain ⟨hf2, hl2⟩ := hn2s i hi
  clear hn2s
  dsimp only [LoopRegs] at hR
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load consuming hf2 hl2
  step_pure
  finish_block
  case
    isTrue =>
    have hpos : 0 < w2[i] := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    obtain ⟨k, hk⟩ : ∃ k, (w2[i] / 2).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 128 := by omega
    obtain ⟨hBf, hBr⟩ := htbl k hk8
    clear htbl
    block_init
    step_call using (fd_ed25519_point_add_final_mul.call_eq (hsep := .inr ?_))
    step_pure
    step_pure with idx
    have hidx : idx.toNat = k := by rw [hidx, idx_pos (by omega), hk]
    step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega]
    step_call using fd_ed25519_point_add_with_opts.call_eq
    finish_block
    refine hK E S hArgs (by env_reads) (by env_reads) ?_
    rw [hS, MemoryState.storeQuad5_comm hrt]
    simp only [addDigit, hpos, ite_true, hk, digitBlocks]
  case
    isFalse =>
    have hnpos : w2[i] ≤ 0 := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    block_init
    step_pure
    finish_block
    case
      isTrue =>
      have hneg : w2[i] < 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simpa using hbr
      obtain ⟨k, hk⟩ : ∃ k, (-w2[i] / 2).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 128 := by omega
      obtain ⟨hBf, hBr⟩ := htbl k hk8
      clear htbl
      block_init
      step_call using (fd_ed25519_point_add_final_mul.call_eq (hsep := .inr ?_))
      step_pure
      step_pure
      step_pure with idx
      have hidx : idx.toNat = k := by rw [hidx, idx_neg (by omega), hk]
      step_pure [hidx, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega]
      step_call using fd_ed25519_point_sub_with_opts.call_eq
      finish_block
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      rw [hS, MemoryState.storeQuad5_comm hrt]
      simp only [addDigit, hneg, show ¬0 < w2[i] by omega, ite_true, ite_false, hk, digitBlocks]
    case
      isFalse =>
      have h0 : w2[i] = 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simp at hbr
        omega
      clear htbl
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      simp only [addDigit, h0, lt_irrefl, ite_false, digitBlocks, Nat.add_zero]
      subst hS
      rw [MemoryState.storeQuad5_readQuad5_self' htp htv,
        MemoryState.storeQuad5_readQuad5_self' hr hrv]

/-- `^bb20`: `r` a copy of `t`; then out at `i == 0`, else around at `i - 1`. -/
theorem tail_block (r n1 a n2 tbl n1s n2s ai tp : Pointer)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (T : Quad5) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai tp E) (hRi : E ⊨ [%1021 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hr : S.mem.Quad5Fit r) (htp : S.mem.Quad5Fit tp) (hrt : r.id ≠ tp.id)
    (htv : S.mem.readQuad5 tp = T)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            S' = { S with mem := S.mem.storeQuad5 r T } →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb23 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              LoopRegs tbl n1s n2s ai tp E' →
              (E' ⊨ [%1021 := BitVec.ofNat 64 j]) →
              S' = { S with mem := S.mem.storeQuad5 r T } →
              (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb12 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb20 S >>= g) = K := by
  dsimp only [LoopRegs] at hR
  block_init
  step_pure
  finish_block
  case isTrue =>
    have hi0 : i = 0 := eq_zero_of_ofNat64 (by omega) hbr
    block_init
    step_call using (fd_ed25519_point_add_final_mul.call_eq (hsep := .inr ?_))
    finish_block
    exact hexit hi0 E S hArgs (by rw [hS])
  case isFalse =>
    have hi0 : 1 ≤ i := Nat.one_le_iff_ne_zero.mpr fun h => hbr (by rw [h])
    block_init
    step_call using (fd_ed25519_point_add_final_mul_projective.call_eq (hsep := .inr ?_))
    step_pure [saddOverflow_neg_one64 hi0 (by omega), add_neg_one64 hi0 (by omega)]
    step_pure [slt_ofNat64 hi0 (by omega)]
    finish_block
    refine hback (i - 1) (by omega) E S hArgs (by env_reads) (by env_reads) (by rw [hS])

/-- An iteration of the main loop at `i`: `r` and `t` stored by the adds, then `r` a copy of `t`. -/
theorem main_iter (r n1 a n2 tbl n1s n2s ai tp : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → Quad5) (hL : Layout r tp n1s n2s ai tbl)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (R : Quad5) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai tp E) (hRi : E ⊨ [%1021 := BitVec.ofNat 64 i])
    (hF : LoopFacts S r tp n1s n2s ai tbl w1 w2 AI B) (hrv : S.mem.readQuad5 r = R)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            S' =
              { alloc := ⟨S.alloc.nextFreeBlock + 40 + digitBlocks w1[i] + digitBlocks w2[i]⟩,
                mem :=
                  (S.mem.storeQuad5 tp (adds AI B w1[i] w2[i] R).2).storeQuad5 r
                    (adds AI B w1[i] w2[i] R).2 } →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb23 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              LoopRegs tbl n1s n2s ai tp E' →
              (E' ⊨ [%1021 := BitVec.ofNat 64 j]) →
              S' =
                { alloc := ⟨S.alloc.nextFreeBlock + 40 + digitBlocks w1[i] + digitBlocks w2[i]⟩,
                  mem :=
                    (S.mem.storeQuad5 tp (adds AI B w1[i] w2[i] R).2).storeQuad5 r
                      (adds AI B w1[i] w2[i] R).2 } →
              (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb12 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb12 S >>= g) = K := by
  refine
    head_block r n1 a n2 tbl n1s n2s ai tp w1 AI g K i hi (hw1 i hi) R S E hArgs hR hRi hF.wf
      hF.fitR hF.fitT hL.rt hL.ra hL.ta hL.t1 hL.n1o hL.aio hrv hF.slides1 hF.tblA
      fun E₁ S₁ h₁ hR₁ hRi₁ hS₁ => ?_
  have hF₁ :=
    hS₁ ▸
      hF.store (T := (add1 AI w1[i] R).2) (R := (add1 AI w1[i] R).1) hL (n :=
        S.alloc.nextFreeBlock + 40 + digitBlocks w1[i]) (by omega)
  have hrv₁ : S₁.mem.readQuad5 r = (add1 AI w1[i] R).1 := by
    rw [hS₁]
    exact MemoryState.readQuad5_storeQuad5_self hF.fitR.storeQuad5
  have htv₁ : S₁.mem.readQuad5 tp = (add1 AI w1[i] R).2 := by
    rw [hS₁]
    dsimp only
    rw [MemoryState.readQuad5_storeQuad5_of_id_ne hL.rt]
    exact MemoryState.readQuad5_storeQuad5_self hF.fitT
  refine
    digit2_block r n1 a n2 tbl n1s n2s ai tp w2 B g K i hi (hw2 i hi) _ _ S₁ E₁ h₁ hR₁ hRi₁ hF₁.wf
      hF₁.fitR hF₁.fitT hL.rt hL.rb hL.n2o hL.tbo hrv₁ htv₁ hF₁.slides2 hF₁.tblB
      fun E₂ S₂ h₂ hR₂ hRi₂ hS₂ => ?_
  have hF₂ :=
    hS₂ ▸
      hF₁.store (T := (adds AI B w1[i] w2[i] R).2) (R := (adds AI B w1[i] w2[i] R).1) hL (n :=
        S₁.alloc.nextFreeBlock + digitBlocks w2[i]) (by omega)
  have htv₂ : S₂.mem.readQuad5 tp = (adds AI B w1[i] w2[i] R).2 := by
    rw [hS₂]
    dsimp only
    rw [MemoryState.readQuad5_storeQuad5_of_id_ne hL.rt]
    exact MemoryState.readQuad5_storeQuad5_self hF₁.fitT
  refine
      tail_block r n1 a n2 tbl n1s n2s ai tp g K i hi _ S₂ E₂ h₂ hR₂ hRi₂ hF₂.wf hF₂.fitR hF₂.fitT
        hL.rt htv₂ (fun h0 E₃ S₃ h₃ hS₃ => hexit h0 E₃ S₃ h₃ (hS₃.trans ?_))
        (fun j hj E₃ S₃ h₃ hR₃ hRi₃ hS₃ => hback j hj E₃ S₃ h₃ hR₃ hRi₃ (hS₃.trans ?_)) <;>
    · subst hS₂ hS₁
      dsimp only
      rw [storeQuad5_canon hF.fitT.1 hF.fitR.1 hL.rt.symm]
      rfl

/-- The main loop from `^bb12` at `i`: `r` the ladder from `i` down, `t` some point. -/
theorem main_loop (r n1 a n2 tbl n1s n2s ai tp : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → Quad5) (hL : Layout r tp n1s n2s ai tbl)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (hi : i < 256) (R : Quad5) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
        LoopRegs tbl n1s n2s ai tp E →
        (E ⊨ [%1021 := BitVec.ofNat 64 i]) →
        LoopFacts S r tp n1s n2s ai tbl w1 w2 AI B →
        S.mem.readQuad5 r = R →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState) (T' : Quad5),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            S' =
              { alloc := ⟨S.alloc.nextFreeBlock + ladderBlocks w1 w2 i hi⟩,
                mem := (S.mem.storeQuad5 tp T').storeQuad5 r (ladder AI B w1 w2 i hi R) } →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb23 S' >>= g) = K) →
        (fd_ed25519_double_scalar_mul_base.runFrom E ^bb12 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi R S E hArgs hR hRi hF hrv hK
    exact
      main_iter r n1 a n2 tbl n1s n2s ai tp w1 w2 AI B hL hw1 hw2 g K 0 hi R S E hArgs hR hRi hF hrv
        (fun _ E' S' h₁ hS' =>
          hK E' S' (adds AI B w1[0] w2[0] R).2 h₁
            (hS'.trans (by simp only [ladderBlocks, ladder, Nat.add_assoc])))
        (fun j hj => absurd hj (by omega))
  | succ j ih =>
    intro hi R S E hArgs hR hRi hF hrv hK
    refine
      main_iter r n1 a n2 tbl n1s n2s ai tp w1 w2 AI B hL hw1 hw2 g K (j + 1) hi R S E hArgs hR hRi
        hF hrv (fun h => absurd h (by omega)) fun j' hj E' S' h₁ hR' hRi' hS' => ?_
    obtain rfl : j = j' := by omega
    have hF' :=
      hS' ▸
        hF.store (T := (adds AI B w1[j + 1] w2[j + 1] R).2) hL (n :=
          S.alloc.nextFreeBlock + 40 + digitBlocks w1[j + 1] + digitBlocks w2[j + 1]) (by omega)
    refine
      ih (by omega) (adds AI B w1[j + 1] w2[j + 1] R).2 S' E' h₁ hR' hRi' hF' ?_
        fun E'' S'' T'' h₂ hS'' => hK E'' S'' T'' h₂ (hS''.trans ?_)
    · rw [hS']
      exact MemoryState.readQuad5_storeQuad5_self hF.fitR.storeQuad5
    · subst hS'
      dsimp only
      rw [storeQuad5_swap hF.fitT.1 hL.rt.symm, MemoryState.storeQuad5_storeQuad5_self hF.fitR.1]
      simp only [ladderBlocks, ladder, Nat.add_assoc]

/-! ### The zero-digit search -/

/-- `i - k` on a small `int` counter does not overflow: `c` is `-k`. -/
theorem saddOverflow_neg32 {i c : Nat} {k : Int} (hm : (BitVec.ofNat 32 c).toInt = -k) (hk : 0 ≤ k)
    (hki : k ≤ i + 2 ^ 31) (h : i < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow (BitVec.ofNat 32 c) = false := by
  have hn : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hn, hm]
  omega

/-- `i - k` on an `int` counter at least `k`: `c` is `-k`. -/
theorem add_neg32 {i k c : Nat} (hc : k + c = 2 ^ 32) (hki : k ≤ i) (h : i < 2 ^ 32) :
    BitVec.ofNat 32 i + BitVec.ofNat 32 c = BitVec.ofNat 32 (i - k) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  omega

/-- `start` past a zero digit pair at `l + 1`. -/
theorem start_of_zero {w1 w2 : Vector Int 256} {l l' : Nat} (hl : l < 256) (hl' : l' + 1 = l)
    (hz : w1[l] = 0 ∧ w2[l] = 0) : start w1 w2 l hl = start w1 w2 l' (by omega) := by
  subst hl'
  simp only [start, hz, and_self, ite_true]

/-- `start` at a non-zero digit pair. -/
theorem start_of_ne {w1 w2 : Vector Int 256} {l : Nat} (hl : l < 256)
    (hz : ¬(w1[l] = 0 ∧ w2[l] = 0)) : start w1 w2 l hl = some ⟨l, hl⟩ := by
  cases l with
  | zero =>
    simp only [start, hz, ite_false]
    rfl
  | succ l => simp only [start, hz, ite_false]

/-- `^bb10`, a non-zero digit pair found at `j`: on to the main loop at `j`. -/
theorem found_block (r n1 a n2 tbl n1s n2s ai tp : Pointer)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (j : Nat) (hj : j < 256)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai tp E)
    (hRj : E ⊨ [%940 := 4294967295#32, %1018 := BitVec.ofNat 32 j])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
          LoopRegs tbl n1s n2s ai tp E' →
          (E' ⊨ [%1021 := BitVec.ofNat 64 j]) →
          (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb12 S >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb10 S >>= g) = K := by
  dsimp only [LoopRegs] at hR
  block_init
  step_pure [slt_neg_one32 (show j < 2 ^ 31 by omega)]
  finish_block
  block_init
  step_pure [msb_ofNat32 (show j < 2 ^ 31 by omega), setWidth_ofNat32 (show j < 2 ^ 32 by omega)]
  finish_block
  exact hK E hArgs (by env_reads) (by env_reads)

/-- `start` at a zero digit pair at `0`. -/
theorem start_none {w1 w2 : Vector Int 256} {l : Nat} (hl : l < 256) (h0 : l = 0)
    (hz : w1[l] = 0 ∧ w2[l] = 0) : start w1 w2 l hl = none := by
  subst h0
  simp only [start, hz, and_self, ite_true]

/-- `^bb1` … `^bb9`, the zero-digit search at `i`, unrolled by four: on to the main loop at the
first non-zero digit pair in `i, …, i - 3`, else out after `0` or around at `i - 4`. -/
theorem skip_iter (r n1 a n2 tbl n1s n2s ai tp : Pointer) (w1 w2 : Vector Int 256)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (hi3 : 3 ≤ i) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai tp E) (hRs : SkipRegs E) (hRi : E ⊨ [%984 := BitVec.ofNat 32 i])
    (hn1s : SlidesAt S.mem n1s w1) (hn2s : SlidesAt S.mem n2s w2)
    (hfound :
      ∀ j,
        start w1 w2 i hi = some j →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              LoopRegs tbl n1s n2s ai tp E' →
              (E' ⊨ [%1021 := BitVec.ofNat 64 j.val]) →
              (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb12 S >>= g) = K)
    (hnone :
      i = 3 →
        start w1 w2 i hi = none →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb23 S >>= g) = K)
    (hback :
      ∀ j (hj : i = j + 4),
        start w1 w2 i hi = start w1 w2 j (by omega) →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              LoopRegs tbl n1s n2s ai tp E' →
              SkipRegs E' →
              (E' ⊨ [%984 := BitVec.ofNat 32 j]) →
              (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb1 S >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb1 S >>= g) = K := by
  have hb1 (k : Nat) (hk : k < 256) : -2 ^ 15 ≤ w1[k] ∧ w1[k] < 2 ^ 15 := by
    have := hw1 k hk
    omega
  have hb2 (k : Nat) (hk : k < 256) : -2 ^ 15 ≤ w2[k] ∧ w2[k] < 2 ^ 15 := by
    have := hw2 k hk
    omega
  clear hw1 hw2
  have hst : start w1 w2 i hi = start w1 w2 i hi := rfl
  dsimp only [LoopRegs, SkipRegs] at hR hRs
  block_init
  probe1 i
  found_or_zero1 i
  probe2 i
  found_or_zero2 i
  next_index i, i - 1, 1, 4294967295
  probe1 i - 1
  found_or_zero1 i - 1
  probe2 i - 1
  found_or_zero2 i - 1
  next_index i - 1, i - 2, 2, 4294967294
  probe1 i - 2
  found_or_zero1 i - 2
  probe2 i - 2
  found_or_zero2 i - 2
  next_index i - 2, i - 3, 3, 4294967293
  probe1 i - 3
  found_or_zero1 i - 3
  probe2 i - 3
  found_or_zero2 i - 3
  -- `i -= 4`, out after `0`
  block_init
  rcases Nat.lt_or_ge i 4 with h4 | h4
  · step_pure [saddOverflow_neg32 (i := i) (c := 4294967292) (k := 4) (by decide) (by decide)
          (by omega) (by omega)]
    step_pure
    finish_block
    · subst hS
      exact hnone (by omega) (hst.trans (start_none _ (by omega) ⟨h1, h2⟩)) _ hArgs
    · exact absurd (by rw [show i - 3 = 0 by omega]) hbr
  · step_pure [saddOverflow_neg32 (i := i) (c := 4294967292) (k := 4) (by decide) (by decide)
          (by omega) (by omega),
      add_neg32 (i := i) (k := 4) (c := 4294967292) (by decide) h4 (by omega)]
    step_pure
    finish_block
    · exact absurd (eq_zero_of_ofNat32 (by omega) hbr) (by omega)
    · subst hS
      exact
        hback (i - 4) (by omega)
          (hst.trans (start_of_zero (l := i - 3) (l' := i - 4) _ (by omega) ⟨h1, h2⟩)) _ hArgs
          (by env_reads) (by env_reads) (by env_reads)

/-- The zero-digit search from `^bb1` at `4 m + 3`: the main loop from `start`, or out without
one. -/
theorem skip_loop (r n1 a n2 tbl n1s n2s ai tp : Pointer) (w1 w2 : Vector Int 256)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (S : GlobalState) (hn1s : SlidesAt S.mem n1s w1) (hn2s : SlidesAt S.mem n2s w2)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m (hi : 4 * m + 3 < 256) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
        LoopRegs tbl n1s n2s ai tp E →
        SkipRegs E →
        (E ⊨ [%984 := BitVec.ofNat 32 (4 * m + 3)]) →
        (∀ j,
          start w1 w2 (4 * m + 3) hi = some j →
            ∀ E' : ⟪Γ⟫,
              E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
                LoopRegs tbl n1s n2s ai tp E' →
                (E' ⊨ [%1021 := BitVec.ofNat 64 j.val]) →
                (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb12 S >>= g) = K) →
        (start w1 w2 (4 * m + 3) hi = none →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb23 S >>= g) = K) →
        (fd_ed25519_double_scalar_mul_base.runFrom E ^bb1 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro hi E hArgs hR hRs hRi hfound hnone
    exact
      skip_iter r n1 a n2 tbl n1s n2s ai tp w1 w2 hw1 hw2 hn1o hn2o g K _ hi (by omega) S E hArgs hR
        hRs hRi hn1s hn2s hfound (fun _ h => hnone h) fun j hj => absurd hj (by omega)
  | succ m ih =>
    intro hi E hArgs hR hRs hRi hfound hnone
    refine
      skip_iter r n1 a n2 tbl n1s n2s ai tp w1 w2 hw1 hw2 hn1o hn2o g K _ hi (by omega) S E hArgs hR
        hRs hRi hn1s hn2s hfound (fun h => absurd h (by omega)) fun j hj hs E' h₁ h₂ h₃ h₄ => ?_
    obtain rfl : j = 4 * m + 3 := by omega
    exact
      ih (by omega) E' h₁ h₂ h₃ h₄ (fun j' h' => hfound j' (hs.trans h')) fun h' =>
        hnone (hs.trans h')

/-! ### The table loop, unrolled -/

/-- The table loop's objects: `t` and `ai` apart from what they must not touch. -/
structure TableLayout (tp n1s n2s ai tbl a2 : Pointer) : Prop where
  ta : tp.id ≠ ai.id
  ta2 : tp.id ≠ a2.id
  aa2 : ai.id ≠ a2.id
  t1 : tp.id ≠ n1s.id
  a1 : ai.id ≠ n1s.id
  t2 : tp.id ≠ n2s.id
  a2' : ai.id ≠ n2s.id
  tb : tp.id ≠ tbl.id
  ab : ai.id ≠ tbl.id

/-- `^bb0`'s sites `29` to `63`, the table loop `for( int i=1; i<WNAF_TBL_SZ; i++ )` unrolled:
`ai[1 … 7]` stored; the main loop's facts carried, and only the frame changed. -/
theorem table_run (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (w1 w2 : Vector Int 256)
    (B : Nat → Quad5) (A2 AI0 : Quad5) (N : Nat) (g : ⟪Γ⟫ × GlobalState → PoisonOr β)
    (K : PoisonOr β) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : EntryRegs tbl n1s n2s ai a2 tp E) (hwf : S.WF) (hr : S.mem.Quad5Fit r)
    (ha2 : S.mem.Quad5Fit a2) (htp : S.mem.Quad5Fit tp) (hai : Fits S.mem ai (1536 * 8))
    (hai_off : ai.offset = 0) (hL : TableLayout tp n1s n2s ai tbl a2) (hNa : N ≤ ai.id.id)
    (hNt : N ≤ tp.id.id) (hsl1 : SlidesAt S.mem n1s w1) (hsl2 : SlidesAt S.mem n2s w2)
    (htblB : TableAt S.mem tbl 128 B) (hread_a2 : S.mem.readQuad5 a2 = A2)
    (hread_ai : S.mem.readQuad5 ai = AI0)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
          EntryRegs tbl n1s n2s ai a2 tp E' →
          S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 350 →
          S'.WF →
          S'.mem.Quad5Fit r →
          S'.mem.Quad5Fit tp →
          SlidesAt S'.mem n1s w1 →
          SlidesAt S'.mem n2s w2 →
          TableAt S'.mem tbl 128 B →
          TableAt S'.mem ai 8 (aiTable A2 AI0) →
          S'.mem.eraseFrom N = S.mem.eraseFrom N → (bb0.runBodyFrom E' 63 S' >>= g) = K) :
    (bb0.runBodyFrom E 29 S >>= g) = K := by
  obtain ⟨hta, hta2, haa2, ht1, ha1, ht2, ha2', htb, hab⟩ := hL
  have hq (j : Nat) (hj : j < 8) : S.mem.Quad5Fit (ai.add (BitVec.ofNat 64 (192 * j))) :=
    MemoryState.Quad5Fit.entry (n := 8) hai
      (by
        rw [hai_off]; decide)
      hj
  have hai_pt : S.mem.Quad5Fit ai := by simpa [Pointer.add_ofNat_zero] using hq 0 (by decide)
  have hq1 := hq 1 (by decide)
  have hq2 := hq 2 (by decide)
  have hq3 := hq 3 (by decide)
  have hq4 := hq 4 (by decide)
  have hq5 := hq 5 (by decide)
  have hq6 := hq 6 (by decide)
  have hq7 := hq 7 (by decide)
  simp only [Nat.reduceMul] at hq1 hq2 hq3 hq4 hq5 hq6 hq7
  clear hq
  dsimp only [EntryRegs] at hR
  step_pure
  step_call using fd_ed25519_point_add_with_opts.call_eq
  name_quad t1
  step_call using (fd_ed25519_point_add_final_mul.call_eq (hsep := .inr ?_))
  step_call using fd_curve25519_into_precomputed.call_eq
  name_quad ai1
  clear_reads
  table_entry t2 ai2
  table_entry t3 ai3
  table_entry t4 ai4
  table_entry t5 ai5
  table_entry t6 ai6
  table_entry t7 ai7
  have e1 : ai1 = aiTable A2 AI0 1 := by
    rw [hai1, ht1]; rfl
  have e2 : ai2 = aiTable A2 AI0 2 := by
    rw [hai2, ht2, e1]; rfl
  have e3 : ai3 = aiTable A2 AI0 3 := by
    rw [hai3, ht3, e2]; rfl
  have e4 : ai4 = aiTable A2 AI0 4 := by
    rw [hai4, ht4, e3]; rfl
  have e5 : ai5 = aiTable A2 AI0 5 := by
    rw [hai5, ht5, e4]; rfl
  have e6 : ai6 = aiTable A2 AI0 6 := by
    rw [hai6, ht6, e5]; rfl
  have e7 : ai7 = aiTable A2 AI0 7 := by
    rw [hai7, ht7, e6]; rfl
  have htA : TableAt S.mem ai 8 (aiTable A2 AI0) := fun k hk => by
    match k, hk with
    | 0, _ =>
      exact
        ⟨by simpa [Pointer.add_ofNat_zero] using hai_pt, by
          simpa [Pointer.add_ofNat_zero, aiTable] using hread_ai⟩
    | 1, _ => exact ⟨hq1, hread_ai_192_readQuad5.trans e1⟩
    | 2, _ => exact ⟨hq2, hread_ai_384_readQuad5.trans e2⟩
    | 3, _ => exact ⟨hq3, hread_ai_576_readQuad5.trans e3⟩
    | 4, _ => exact ⟨hq4, hread_ai_768_readQuad5.trans e4⟩
    | 5, _ => exact ⟨hq5, hread_ai_960_readQuad5.trans e5⟩
    | 6, _ => exact ⟨hq6, hread_ai_1152_readQuad5.trans e6⟩
    | 7, _ => exact ⟨hq7, hread_ai_1344_readQuad5.trans e7⟩
  have hNa' (c : BitVec 64) : N ≤ (ai.add c).id.id := by simpa [Pointer.add_id] using hNa
  refine hK E S hArgs (by env_reads) (by rw [hS]) hwf hr htp hsl1 hsl2 htblB htA ?_
  rw [hS]
  simp only [MemoryState.eraseFrom_storeQuad5_of_le hNt,
    MemoryState.eraseFrom_storeQuad5_of_le (hNa' _)]

/-! ### The function -/

/-- `spec` without a non-zero digit: the neutral point. -/
theorem spec_of_none {x1 x2 : BitVec 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        none) :
    spec tbl x1 A x2 = quadZero := by
  unfold spec
  dsimp only
  rw [h]

/-- `blocks` without a non-zero digit. -/
theorem blocks_of_none {x1 x2 : BitVec 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        none) :
    blocks x1 x2 = 411 := by
  unfold blocks
  dsimp only
  rw [h]
  rfl

/-- `spec` from the first non-zero digit `j`: the main loop from `j`. -/
theorem spec_of_some {x1 x2 : BitVec 256} {j : Fin 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        some j) :
    spec tbl x1 A x2 =
      ladder (aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)) tbl
        (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) j j.isLt
        quadZero := by
  unfold spec
  dsimp only
  rw [h]

/-- `blocks` from the first non-zero digit `j`. -/
theorem blocks_of_some {x1 x2 : BitVec 256} {j : Fin 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        some j) :
    blocks x1 x2 =
      411 +
        ladderBlocks (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) j
          j.isLt := by
  unfold blocks
  dsimp only
  rw [h]

end fd_ed25519_double_scalar_mul_base

attribute [local mlir_transport] fd_ed25519_double_scalar_mul_base.TableAt.storeQuad5

open fd_ed25519_double_scalar_mul_base in
/-- `fd_ed25519_double_scalar_mul_base` stores `spec` of the scalars at `n1`, `n2` and the point
at `a` at `r` and returns `r`; `r` may be any of the inputs: they are read before it is written.
The block counter advances by `blocks`. -/
public theorem fd_ed25519_double_scalar_mul_base.call_eq (r n1 a n2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.Quad5Fit r) (hn1 : Fits s.mem n1 (8 * 32))
    (hn1o : ¬n1.offset.uaddOverflow 32#64) (ha : s.mem.Quad5Fit a) (hn2 : Fits s.mem n2 (8 * 32))
    (hn2o : ¬n2.offset.uaddOverflow 32#64) :
    fd_ed25519_double_scalar_mul_base.call
        (fd_ed25519_double_scalar_mul_base.args (.value r) (.value n1) (.value a) (.value n2)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + blocks (s.mem.readAt n1 256) (s.mem.readAt n2 256)⟩,
            mem :=
              s.mem.storeQuad5 r
                (spec fd_ed25519_base_point_wnaf_table.point (s.mem.readAt n1 256)
                  (s.mem.readQuad5 a) (s.mem.readAt n2 256)) }) := by
  -- folded for `func_init`, whose frame-free check would unfold `blocks`
  generalize hP :
    spec fd_ed25519_base_point_wnaf_table.point (s.mem.readAt n1 256) (s.mem.readQuad5 a)
      (s.mem.readAt n2 256) =
    P
  generalize hk : blocks (s.mem.readAt n1 256) (s.mem.readAt n2 256) = k
  func_init
  -- the inputs, named before the frame grows
  obtain ⟨x1, hx1⟩ : ∃ x, S.mem.readAt n1 256 = x := ⟨_, rfl⟩
  obtain ⟨A, hA⟩ : ∃ A, S.mem.readQuad5 a = A := ⟨_, rfl⟩
  obtain ⟨x2, hx2⟩ : ∃ x, S.mem.readAt n2 256 = x := ⟨_, rfl⟩
  rw [hx1, hA, hx2] at hP
  rw [hx1, hx2] at hk
  have hr₀ : S₀.mem.Quad5Fit r := hS ▸ hr
  have hA₀ : S₀.mem.readQuad5 a = A := hS ▸ hA
  clear hA
  block_init
  iterate 9 step_pure
  step_addressof fd_ed25519_base_point_wnaf_table.value_eq with tbl
  iterate 4 step_pure
  -- `a` past the table's block
  have hA : S.mem.readQuad5 a = A := by
    rw [hS,
      MemoryState.readQuad5_addBlock_of_id_ne
        (by
          rw [htbl] at ha_ne_tbl; exact ha_ne_tbl),
      hA₀]
  clear hA₀
  -- short n1slide[256]; short n2slide[256]; fd_ed25519_point_t ai[8], a2[1], t[1];
  step_alloca with n1s
  step_alloca with n2s
  step_alloca with ai
  step_alloca with a2
  step_alloca with tp
  -- fd_curve25519_scalar_wnaf( n1slide, n1, WNAF_BIT_SZ );
  -- fd_curve25519_scalar_wnaf( n2slide, n2, 8 );
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  iterate 3 step_pure
  have hsl1 : SlidesAt S.mem n1s (fd_curve25519_scalar_wnaf.wnaf x1 4) :=
    SlidesAt.of_readAt hn1s_fits
      (by
        rw [hn1s_off]; decide)
      hread_n1s
  have hsl2 : SlidesAt S.mem n2s (fd_curve25519_scalar_wnaf.wnaf x2 8) :=
    SlidesAt.of_readAt hn2s_fits
      (by
        rw [hn2s_off]; decide)
      hread_n2s
  have htblB : TableAt S.mem tbl 128 fd_ed25519_base_point_wnaf_table.point := fun j hj =>
    ⟨MemoryState.Quad5Fit.entry (n := 128) htbl_fits
        (by
          rw [htbl_off]; decide)
        hj,
      fd_ed25519_base_point_wnaf_table.readQuad5 htbl_fits htbl_off hread_tbl hj⟩
  -- `ai[0]`, `a2`, `t`
  have hai_pt := MemoryState.Quad5Fit.of_fits (hai_fits.mono (by decide)) hai_off
  have ha2_pt := MemoryState.Quad5Fit.of_fits (ha2_fits.mono (by decide)) ha2_off
  have htp_pt := MemoryState.Quad5Fit.of_fits (htp_fits.mono (by decide)) htp_off
  clear ha2_fits htp_fits htbl_fits hn1s_fits hn2s_fits hn1 hn2
  clear_reads
  -- fd_ed25519_point_set( &ai[0], a ); fd_ed25519_point_dbln( a2, a, 1 );
  -- fd_curve25519_into_precomputed( &ai[0] );
  step_call using (fd_ed25519_point_set.call_eq (hsep := .inr ?_))
  step_call using fd_ed25519_point_dbln.call_eq consuming hA
  step_call using fd_curve25519_into_precomputed.call_eq
  -- for( int i=1; i<WNAF_TBL_SZ; i++ ) { … }, unrolled
  refine
    table_run r n1 a n2 tbl n1s n2s ai a2 tp _ _ _ _ _ S₀.alloc.nextFreeBlock _ _ S E hArgs
      (by env_reads) hwf hr ha2_pt htp_pt hai_fits hai_off
      ⟨by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by
        mem_fact, by mem_fact⟩
      (by slot_bound) (by slot_bound) hsl1 hsl2 htblB hread_a2_readQuad5 hread_ai_readQuad5
      fun E' S' hArgs' hR' halloc hwf' hr' htp' hsl1' hsl2' htblB' htA herase => ?_
  have hS₁ := hS
  clear_reads
  clear hS hArgs hread_ai_readQuad5 hread_a2_readQuad5 hwf hr ha hai_fits hsl1 hsl2 htblB hai_pt
    ha2_pt htp_pt
  dsimp only [EntryRegs] at hR'
  -- fd_ed25519_point_set_zero( r );
  step_call using fd_ed25519_point_set_zero.call_eq
  have hrz : S.mem.readQuad5 r = quadZero := hread_r_readQuad5
  clear_reads
  finish_block
  have hL : Layout r tp n1s n2s ai tbl :=
    ⟨hr_ne_tp, hr_ne_n1s, hr_ne_n2s, hr_ne_ai, hr_ne_tbl, by mem_fact, by mem_fact, by mem_fact, by
      mem_fact, by
      rw [hn1s_off]; decide, by
      rw [hn2s_off]; decide, by
      rw [hai_off]; decide, by
      rw [htbl_off]; decide⟩
  have hw1 := fun k hk => (fd_curve25519_scalar_wnaf.wnaf4_digits x1 k hk).2
  have hw2 := fun k hk => (fd_curve25519_scalar_wnaf.wnaf8_digits x2 k hk).2
  -- for( i=255; i>=0; i-- ) { if( n1slide[i] || n2slide[i] ) break; }
  refine
    skip_loop r n1 a n2 tbl n1s n2s ai tp _ _ hw1 hw2 hL.n1o hL.n2o S hsl1' hsl2' _ _ 63 (by decide)
      E hArgs (by env_reads) (by env_reads) (by env_reads) ?_ ?_
  · -- the main loop from the first non-zero digit
    intro j hj E₂ h₁ h₂ h₃
    refine
      main_loop r n1 a n2 tbl n1s n2s ai tp _ _ _ _ hL hw1 hw2 _ _ j.val j.isLt _ S E₂ h₁ h₂ h₃
        ⟨hwf', hr', htp', hsl1', hsl2', htA, htblB'⟩ hrz fun E₃ S₃ T' h₁' hS₃ => ?_
    block_init
    iterate 5 step_pure
    finish_block
    rw [← hk, ← hP, blocks_of_some hj, spec_of_some hj]
    clear hwf' hr' htp' hsl1' hsl2' htA htblB' hrz hL
    subst hS₃
    dsimp only
    rw [MemoryState.eraseFrom_storeQuad5,
      MemoryState.eraseFrom_storeQuad5_of_le (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound)]
    subst hS
    dsimp only
    rw [MemoryState.eraseFrom_storeQuad5, herase, show S'.alloc = ⟨S'.alloc.nextFreeBlock⟩ from rfl,
      halloc, MemoryState.storeQuad5_storeQuad5_self hr₀.1]
    clear herase halloc
    subst hS₁
    erase_frame
    simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
  · -- no non-zero digit: `r` is zero
    intro hj E₂ h₁
    block_init
    iterate 5 step_pure
    finish_block
    rw [← hk, ← hP, blocks_of_none hj, spec_of_none hj]
    clear hwf' hr' htp' hsl1' hsl2' htA htblB' hrz hL
    subst hS
    dsimp only
    rw [MemoryState.eraseFrom_storeQuad5, herase, show S'.alloc = ⟨S'.alloc.nextFreeBlock⟩ from rfl,
      halloc]
    clear herase halloc
    subst hS₁
    erase_frame
    simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]

end Proof

end MLIR.Firedancer.R52x5
