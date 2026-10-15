module

public import MLIR.Run.Tactic
public import Firedancer.Lane.double_scalar_mul_base_split.LoopDec
public import Firedancer.Lane.fd_curve25519_scalar_wnaf
public import Firedancer.Lane.fd_ed25519_double_scalar_mul_base

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

namespace double_scalar_mul_base_split

open _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split
open Split

/-- Room for a point past a pointer store. -/
theorem quadRoom_storePtr {m : MemoryState} {p q x : Pointer} (h : m.QuadRoom q) :
    (m.storePtr p x).QuadRoom q :=
  ⟨h.1, Room.storePtr h.2.1, Room.storePtr h.2.2.1, Room.storePtr h.2.2.2⟩

/-- `bt[j]`: `tbl` for segment `0`, `tb`'s segment `j - 1` for the others. -/
def btp (tbl tb : Pointer) (j : Nat) : Pointer :=
  if j = 0 then tbl else tb.add (BitVec.ofNat 64 (24576 * (j - 1)))

/-- The loop's memory facts from the entry's: the tables' reads, the slides and `bt`'s eight
pointers. -/
theorem base_init {M : MemoryState} {r n1s n2s bt ta tb tbl : Pointer} {w1 w2 : Vector Int 256}
    {TA TB : Nat → Quad} {xa : BitVec 49152} {xb : BitVec 1376256} (hr : M.QuadRoom r)
    (hs1 : SlidesAt M n1s w1) (hs2 : SlidesAt M n2s w2) (hn1o : n1s.offset = 0)
    (hn2o : n2s.offset = 0) (rn1 : r.id ≠ n1s.id) (rn2 : r.id ≠ n2s.id) (rbt : r.id ≠ bt.id)
    (rta : r.id ≠ ta.id) (rtb : r.id ≠ tb.id) (rtbl : r.id ≠ tbl.id)
    (htao : ta.offset.toNat + 192 * 32 < 2 ^ 64) (hfa : Fits M ta 49152)
    (hxa : M.readAt ta 49152 = xa) (hTA : ∀ k < 32, TA k = quadAt xa (1536 * k))
    (hbto : bt.offset = 0) (hbtb : InBounds M bt 512) (hl0 : M.loadPtr bt = .value tbl)
    (hl1 : M.loadPtr (bt.add 8#64) = .value tb)
    (hl2 : M.loadPtr (bt.add 16#64) = .value (tb.add 24576#64))
    (hl3 : M.loadPtr ((bt.add 16#64).add 8#64) = .value (tb.add 49152#64))
    (hl4 : M.loadPtr ((bt.add 16#64).add 16#64) = .value (tb.add 73728#64))
    (hl5 : M.loadPtr ((bt.add 16#64).add 24#64) = .value (tb.add 98304#64))
    (hl6 : M.loadPtr (bt.add 48#64) = .value (tb.add 122880#64))
    (hl7 : M.loadPtr (bt.add 56#64) = .value (tb.add 147456#64))
    (htblo : tbl.offset = 0) (htblf : Fits M tbl 196608)
    (htblr : M.readAt tbl 196608 =
      Ty.flatBits Firedancer.Lane.Mlir.fd_ed25519_base_point_wnaf_table.lit (hw := rfl))
    (htbo : tb.offset.toNat + 192 * 896 < 2 ^ 64) (hfb : Fits M tb 1376256)
    (hxb : M.readAt tb 1376256 = xb) (hTB : ∀ k < 896, TB k = quadAt xb (1536 * k)) :
    Base M r n1s n2s bt ta (btp tbl tb) w1 w2 TA (btab TB) where
  roomR := hr
  s1 := hs1
  s2 := hs2
  n1o := by rw [hn1o]; decide
  n2o := by rw [hn2o]; decide
  rn1 := rn1
  rn2 := rn2
  rbt := rbt
  rta := rta
  rbp j _ := by
    unfold btp
    split
    · exact rtbl
    · exact rtb
  tao := htao
  tap k hk := ⟨MemoryState.QuadFit.entry (n := 32) hfa (by omega) hk, by
    rw [MemoryState.readQuad_add_of_readAt hfa hxa (by omega) (by omega), hTA k hk]
    congr 1
    omega⟩
  bto := by rw [hbto]; decide
  bt j hj := by
    refine ⟨InBounds.add_of_le (by simp [BitVec.uaddOverflow, hbto]; omega)
      (by simp; omega) hbtb, ?_⟩
    obtain _ | _ | _ | _ | _ | _ | _ | _ | j := j
    · simpa [btp, Pointer.add] using hl0
    · simpa [btp] using hl1
    · simpa [btp] using hl2
    · simpa [btp, Pointer.add_add] using hl3
    · simpa [btp, Pointer.add_add] using hl4
    · simpa [btp, Pointer.add_add] using hl5
    · simpa [btp] using hl6
    · simpa [btp] using hl7
    · omega
  btpo j hj := by
    unfold btp
    split
    · rw [htblo]; decide
    · rw [offset_add_ofNat (by omega)]
      omega
  btq j hj k hk := by
    unfold btp btab
    split
    · refine ⟨MemoryState.QuadFit.entry (n := 128) htblf (by rw [htblo]; decide) hk, ?_⟩
      rw [MemoryState.readQuad_add_of_readAt htblf htblr (by rw [htblo]; simp; omega)
        (by omega)]
      unfold fd_ed25519_base_point_wnaf_table.point
      congr 1
      omega
    · rw [add_ofNat_add, show 24576 * (j - 1) + 192 * k = 192 * (128 * (j - 1) + k) by omega]
      refine ⟨MemoryState.QuadFit.entry (n := 896) hfb (by omega) (by omega), ?_⟩
      rw [MemoryState.readQuad_add_of_readAt hfb hxb (by omega) (by omega), hTB _ (by omega)]
      congr 1
      omega

/-- `i > -1` for `i` below `2 ^ 63`. -/
theorem slt_neg_one64 {i : Nat} (h : i < 2 ^ 63) :
    (18446744073709551615#64).slt (BitVec.ofNat 64 i) = true := by
  have hn : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hm : (18446744073709551615#64).toInt = -1 := by decide
  simp [BitVec.slt, hn, hm]
  omega

/-- `spec` without a bit with a digit: the neutral point. -/
theorem spec_of_none {TA TB : Nat → Quad} {x1 x2 : BitVec 256}
    (h :
      start (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3) (Ref.fd_curve25519_scalar_wnaf.wnaf x2 8) 31 =
        none) :
    double_scalar_mul_base_split.spec TA TB x1 x2 = fd_ed25519_point_set_zero.spec := by
  unfold double_scalar_mul_base_split.spec
  dsimp only
  rw [h]

/-- `spec` from the first bit `j` with a digit: the ladder from `j` on the neutral point. -/
theorem spec_of_some {TA TB : Nat → Quad} {x1 x2 : BitVec 256} {j : Nat}
    (h :
      start (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3) (Ref.fd_curve25519_scalar_wnaf.wnaf x2 8) 31 =
        some j) :
    double_scalar_mul_base_split.spec TA TB x1 x2 =
      ladder TA TB (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3)
        (Ref.fd_curve25519_scalar_wnaf.wnaf x2 8) j fd_ed25519_point_set_zero.spec := by
  unfold double_scalar_mul_base_split.spec
  dsimp only
  rw [h]

/-- `specDec` without a bit with a digit: no steps. -/
theorem specDec_of_none {x1 x2 : BitVec 256} {D : DecSt}
    (h :
      start (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3) (Ref.fd_curve25519_scalar_wnaf.wnaf x2 8) 31 =
        none) :
    double_scalar_mul_base_split.specDec x1 x2 D = D := by
  unfold double_scalar_mul_base_split.specDec
  dsimp only
  rw [h]

/-- `specDec` from the first bit `j` with a digit: the ladder's steps from `j`. -/
theorem specDec_of_some {x1 x2 : BitVec 256} {D : DecSt} {j : Nat}
    (h :
      start (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3) (Ref.fd_curve25519_scalar_wnaf.wnaf x2 8) 31 =
        some j) :
    double_scalar_mul_base_split.specDec x1 x2 D =
      ladderDec (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3)
        (Ref.fd_curve25519_scalar_wnaf.wnaf x2 8) j D := by
  unfold double_scalar_mul_base_split.specDec
  dsimp only
  rw [h]

end double_scalar_mul_base_split

attribute [local mlir_transport] double_scalar_mul_base_split.quadRoom_storePtr
  double_scalar_mul_base_split.decHolds_storeAt double_scalar_mul_base_split.decHolds_storePtr
  double_scalar_mul_base_split.decRoom_storeAt double_scalar_mul_base_split.decRoom_storePtr

-- the entry block in one walk (223 instructions, the inlined `fd_ed25519_point_set_zero`) and
-- the loops' lemma applications: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
open double_scalar_mul_base_split Split _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split in
/-- `double_scalar_mul_base_split` with `dec` `NULL` stores `spec` of the split tables at `ta`, `tb`
and the scalars at `n1`, `n2` at `r` and returns `r`. `r` is zeroed before the tables are read: it
lies outside them; the scalars may alias it. Its frame is six blocks: four locals and
`fd_curve25519_scalar_wnaf`'s two. -/
public theorem double_scalar_mul_base_split.call_eq (r n1 ta n2 tb : Pointer) (s : GlobalState)
    (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.globals)
    (hr : s.mem.QuadRoom r) (hn1 : Fits s.mem n1 (8 * 32)) (hn2 : Fits s.mem n2 (8 * 32))
    (hta : Fits s.mem ta (1536 * 32)) (htao : ta.offset.toNat + 192 * 32 < 2 ^ 64)
    (htb : Fits s.mem tb (1536 * 896)) (htbo : tb.offset.toNat + 192 * 896 < 2 ^ 64)
    (hrta : r.id ≠ ta.id) (hrtb : r.id ≠ tb.id) :
    _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.call
        (_root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.args (.value r) (.value n1)
          (.value ta) (.value n2) (.value tb) (.value Pointer.null)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem :=
              s.mem.storeQuad r
                (double_scalar_mul_base_split.spec (s.mem.readTable ta) (s.mem.readTable tb)
                  (s.mem.readAt n1 256) (s.mem.readAt n2 256)) }) := by
  have hfa : Fits s.mem ta 49152 := hta
  have hfb : Fits s.mem tb 1376256 := htb
  clear hta htb
  generalize hP :
    double_scalar_mul_base_split.spec (s.mem.readTable ta) (s.mem.readTable tb)
      (s.mem.readAt n1 256) (s.mem.readAt n2 256) = P
  func_init
  obtain ⟨xa, hxa⟩ : ∃ x, S.mem.readAt ta 49152 = x := ⟨_, rfl⟩
  obtain ⟨xb, hxb⟩ : ∃ x, S.mem.readAt tb 1376256 = x := ⟨_, rfl⟩
  obtain ⟨x1, hx1⟩ : ∃ x, S.mem.readAt n1 256 = x := ⟨_, rfl⟩
  obtain ⟨x2, hx2⟩ : ∃ x, S.mem.readAt n2 256 = x := ⟨_, rfl⟩
  have hTA : ∀ k < 32, S₀.mem.readTable ta k = quadAt xa (1536 * k) := fun k hk => by
    rw [MemoryState.readTable, MemoryState.readQuad_add_of_readAt (hS ▸ hfa) (hS ▸ hxa)
      (by omega) (by omega)]
    congr 1
    omega
  have hTB : ∀ k < 896, S₀.mem.readTable tb k = quadAt xb (1536 * k) := fun k hk => by
    rw [MemoryState.readTable, MemoryState.readQuad_add_of_readAt (hS ▸ hfb) (hS ▸ hxb)
      (by omega) (by omega)]
    congr 1
    omega
  rw [hx1, hx2] at hP
  block_init
  iterate 34 step_pure
  step_addressof fd_ed25519_base_point_wnaf_table.value_eq with tbl
  iterate 34 step_pure
  iterate 16 step_pattern using runBodyFrom_insertRun inline
  -- short n1slide[256], n2slide[256]; fd_ed25519_point_t const * bt[8]; fd_ed25519_point_t t[1]
  step_alloca with n1s
  step_alloca with n2s
  step_alloca with bt
  step_alloca with tp
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_pure
  step_impure =>
    exact run_storePtrs4 rfl (by mem_fact) (by simp [Pointer.add, hbt_off])
  have h4 : S.mem.loadPtr ((bt.add 16#64).add 8#64) = .value (tb.add 49152#64) ∧
      S.mem.loadPtr ((bt.add 16#64).add 16#64) = .value (tb.add 73728#64) ∧
      S.mem.loadPtr ((bt.add 16#64).add 24#64) = .value (tb.add 98304#64) := by
    rw [hS]
    have hp : (bt.add 16#64).offset.toNat + 32 ≤ 2 ^ 64 := by simp [Pointer.add, hbt_off]
    refine ⟨(loadPtr_storePtrs4 ?_ hp).2.1, (loadPtr_storePtrs4 ?_ hp).2.2.1,
      (loadPtr_storePtrs4 ?_ hp).2.2.2⟩ <;> mem_fact
  have hb24 := h4.1
  have hb32 := h4.2.1
  have hb40 := h4.2.2
  clear h4
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_store
  -- fd_ed25519_point_set_zero( r ), inlined
  step_pure
  step_store
  step_pure
  have hr_1024 := hr.room_14_25
  step_memset consuming hr_1024
  finish_block
  have hro := hr.1
  obtain ⟨Z, hZ, hZe⟩ :
      ∃ Z : MemoryState, S.mem = Z.storeQuad r fd_ed25519_point_set_zero.spec ∧
        Z.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem :=
    ⟨_, by rw [hS]; dsimp only; rw [MemoryState.storeAt_zero_14_25 hro]; rfl, by erase_frame⟩
  have hSa : S.alloc = ⟨S₀.alloc.nextFreeBlock + 6⟩ := by
    rw [hS]
    simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
  have hrS : Z.QuadRoom r := MemoryState.QuadRoom.of_storeQuad (hZ ▸ hr)
  have hfitR : S.mem.QuadFit r := hZ ▸ MemoryState.QuadFit.storeQuad_self hrS
  have hrz : S.mem.readQuad r = fd_ed25519_point_set_zero.spec :=
    hZ ▸ MemoryState.readQuad_storeQuad_self hrS
  have hYS : S.mem = S.mem.storeQuad r fd_ed25519_point_set_zero.spec :=
    (MemoryState.storeQuad_readQuad_self' hfitR hrz).symm
  have hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3) :=
    Ref.fd_curve25519_scalar_wnaf.wnaf_digits x1 (bits := 3) (by decide)
  have hw2 := Ref.fd_curve25519_scalar_wnaf.wnaf8_digits x2
  have hs1 : SlidesAt S.mem n1s (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3) :=
    SlidesAt.of_readAt hfits_n1s (by rw [hn1s_off]; decide) hread_n1s
  have hs2 : SlidesAt S.mem n2s (Ref.fd_curve25519_scalar_wnaf.wnaf x2 8) :=
    SlidesAt.of_readAt hfits_n2s (by rw [hn2s_off]; decide) hread_n2s
  have hB := base_init (TA := S₀.mem.readTable ta) (TB := S₀.mem.readTable tb) hr hs1 hs2
    hn1s_off hn2s_off hr_ne_n1s hr_ne_n2s hr_ne_bt hrta hrtb hr_ne_tbl htao hfa hxa hTA hbt_off
    hbt_bounds hread_bt hread_bt_8 hread_bt_16 hb24 hb32 hb40 hread_bt_48 hread_bt_56 htbl_off
    htbl_fits hread_tbl htbo hfb hxb hTB
  have hT : S.mem.QuadRoom tp := MemoryState.QuadRoom.of_room hroom_tp htp_off
  have hN1 : S₀.alloc.nextFreeBlock ≤ n1s.id.id := by slot_bound
  have hN2 : S₀.alloc.nextFreeBlock ≤ n2s.id.id := by slot_bound
  have hNb : S₀.alloc.nextFreeBlock ≤ bt.id.id := by slot_bound
  have hNt : S₀.alloc.nextFreeBlock ≤ tp.id.id := by slot_bound
  have htn1 : tp.id ≠ n1s.id := by mem_fact
  have htn2 : tp.id ≠ n2s.id := by mem_fact
  have htbt : tp.id ≠ bt.id := by mem_fact
  have htbp : ∀ j < 8, tp.id ≠ (btp tbl tb j).id := fun j _ => by
    unfold btp
    split
    · exact htbl_ne_tp.symm
    · exact htb_ne_tp.symm
  -- for( i=31; i>=0; i-- ) { … if( nz ) break; }
  refine
    search r n1 ta n2 tb Pointer.null n1s n2s bt tp _ _ hw1 hw2 S hs1 hs2
      (by rw [hn1s_off]; decide) (by rw [hn2s_off]; decide) _ _ ?_ ?_ 15 E (by decide) hArgs
      ⟨by env_reads, by env_reads, by env_reads⟩ (by env_reads) rfl
  · -- the main loop from the first bit with a digit
    intro j hj hj' E₂ h₁ h₂ h₃
    obtain ⟨hC, hC', hL'⟩ := h₂
    split_env hC hC' hL' h₃
    block_init
    step_pure [slt_neg_one64 (show j < 2 ^ 63 by omega)]
    finish_block
    block_init
    iterate 6 step_pure
    finish_block
    refine
      iloop r n1 ta n2 tb Pointer.null n1s n2s bt tp (btp tbl tb) _ _ (S₀.mem.readTable ta)
        (S₀.mem.readTable tb) S₀.alloc.nextFreeBlock (S.mem.eraseFrom S₀.alloc.nextFreeBlock) hNt
        hr_ne_tp htn1 htn2 htbt hta_ne_tp.symm htbp 1#1 rfl (.value (Pointer.null.add 712#64))
        (.value (Pointer.null.add 704#64)) hw1 hw2 S.alloc _ _ j fd_ed25519_point_set_zero.spec
        S.mem S E hj hB hT rfl hArgs ⟨by env_reads, by env_reads⟩ hwf rfl hYS
        fun E' S' Y' h₁ h₂ h₃ h₄ h₅ h₆ => ?_
    -- the lifetimes' ends
    obtain ⟨-, hL⟩ := h₂
    split_env hL
    block_init
    iterate 4 step_pure
    finish_block
    rw [← hP, spec_of_some hj']
    subst hS
    simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hN1,
      MemoryState.eraseFrom_lifetimeEnd_of_le hN2, MemoryState.eraseFrom_lifetimeEnd_of_le hNb,
      MemoryState.eraseFrom_lifetimeEnd_of_le hNt]
    rw [h₆, MemoryState.eraseFrom_storeQuad, h₅, hZ, MemoryState.eraseFrom_storeQuad, hZe,
      MemoryState.storeQuad_storeQuad_self hro, h₃, hSa]
  · -- no bit with a digit: `r` is zero
    intro hj E₂ h₁ h₂
    obtain ⟨-, -, hL⟩ := h₂
    split_env hL
    block_init
    iterate 4 step_pure
    finish_block
    rw [← hP, spec_of_none hj]
    subst hS
    simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hN1,
      MemoryState.eraseFrom_lifetimeEnd_of_le hN2, MemoryState.eraseFrom_lifetimeEnd_of_le hNb,
      MemoryState.eraseFrom_lifetimeEnd_of_le hNt]
    -- the entry's state was substituted back by the walk
    dsimp only at hZ hSa
    rw [hZ, MemoryState.eraseFrom_storeQuad, hZe, hSa]

-- the entry block in one walk (223 instructions, the inlined `fd_ed25519_point_set_zero`) and
-- the loops' lemma applications: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
open double_scalar_mul_base_split Split _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split in
/-- `double_scalar_mul_base_split` with a decode state `D` at `dec`: `call_eq`'s result, and at
`dec` the state after `specDec`'s steps, one `fd_ed25519_point_decode_step( dec, 3 )` per point
operation. `dec` lies outside `r` and the tables. -/
public theorem double_scalar_mul_base_split.call_eq_dec (r n1 ta n2 tb dec : Pointer) (D : DecSt)
    (s : GlobalState)
    (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.globals)
    (hr : s.mem.QuadRoom r) (hn1 : Fits s.mem n1 (8 * 32)) (hn2 : Fits s.mem n2 (8 * 32))
    (hta : Fits s.mem ta (1536 * 32)) (htao : ta.offset.toNat + 192 * 32 < 2 ^ 64)
    (htb : Fits s.mem tb (1536 * 896)) (htbo : tb.offset.toNat + 192 * 896 < 2 ^ 64)
    (hrta : r.id ≠ ta.id) (hrtb : r.id ≠ tb.id) (hdr : s.mem.DecRoom dec)
    (hD : s.mem.DecHolds dec D) (hOk : D.Ok) (hrd : r.id ≠ dec.id) (hdta : dec.id ≠ ta.id)
    (hdtb : dec.id ≠ tb.id) :
    _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.call
        (_root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.args (.value r) (.value n1)
          (.value ta) (.value n2) (.value tb) (.value dec)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem :=
              (s.mem.storeDec dec
                  (double_scalar_mul_base_split.specDec (s.mem.readAt n1 256) (s.mem.readAt n2 256)
                    D)).storeQuad r
                (double_scalar_mul_base_split.spec (s.mem.readTable ta) (s.mem.readTable tb)
                  (s.mem.readAt n1 256) (s.mem.readAt n2 256)) }) := by
  have hdn : dec ≠ Pointer.null := fun h => hwf.ne_null_of_inBounds hdr.2.inBounds (by rw [h])
  have hdroom : Room s.mem dec 5792 := hdr.2
  generalize hPD :
    double_scalar_mul_base_split.specDec (s.mem.readAt n1 256) (s.mem.readAt n2 256) D = PD
  have hfa : Fits s.mem ta 49152 := hta
  have hfb : Fits s.mem tb 1376256 := htb
  clear hta htb
  generalize hP :
    double_scalar_mul_base_split.spec (s.mem.readTable ta) (s.mem.readTable tb)
      (s.mem.readAt n1 256) (s.mem.readAt n2 256) = P
  func_init
  obtain ⟨xa, hxa⟩ : ∃ x, S.mem.readAt ta 49152 = x := ⟨_, rfl⟩
  obtain ⟨xb, hxb⟩ : ∃ x, S.mem.readAt tb 1376256 = x := ⟨_, rfl⟩
  obtain ⟨x1, hx1⟩ : ∃ x, S.mem.readAt n1 256 = x := ⟨_, rfl⟩
  obtain ⟨x2, hx2⟩ : ∃ x, S.mem.readAt n2 256 = x := ⟨_, rfl⟩
  have hTA : ∀ k < 32, S₀.mem.readTable ta k = quadAt xa (1536 * k) := fun k hk => by
    rw [MemoryState.readTable, MemoryState.readQuad_add_of_readAt (hS ▸ hfa) (hS ▸ hxa)
      (by omega) (by omega)]
    congr 1
    omega
  have hTB : ∀ k < 896, S₀.mem.readTable tb k = quadAt xb (1536 * k) := fun k hk => by
    rw [MemoryState.readTable, MemoryState.readQuad_add_of_readAt (hS ▸ hfb) (hS ▸ hxb)
      (by omega) (by omega)]
    congr 1
    omega
  rw [hx1, hx2] at hP hPD
  have hD₀ : S₀.mem.DecHolds dec D := hS ▸ hD
  block_init
  iterate 34 step_pure
  step_addressof fd_ed25519_base_point_wnaf_table.value_eq with tbl
  iterate 34 step_pure
  iterate 16 step_pattern using runBodyFrom_insertRun inline
  -- short n1slide[256], n2slide[256]; fd_ed25519_point_t const * bt[8]; fd_ed25519_point_t t[1]
  step_alloca with n1s
  step_alloca with n2s
  step_alloca with bt
  step_alloca with tp
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_pure
  step_impure =>
    exact run_storePtrs4 rfl (by mem_fact) (by simp [Pointer.add, hbt_off])
  have h4 : S.mem.loadPtr ((bt.add 16#64).add 8#64) = .value (tb.add 49152#64) ∧
      S.mem.loadPtr ((bt.add 16#64).add 16#64) = .value (tb.add 73728#64) ∧
      S.mem.loadPtr ((bt.add 16#64).add 24#64) = .value (tb.add 98304#64) := by
    rw [hS]
    have hp : (bt.add 16#64).offset.toNat + 32 ≤ 2 ^ 64 := by simp [Pointer.add, hbt_off]
    refine ⟨(loadPtr_storePtrs4 ?_ hp).2.1, (loadPtr_storePtrs4 ?_ hp).2.2.1,
      (loadPtr_storePtrs4 ?_ hp).2.2.2⟩ <;> mem_fact
  have hb24 := h4.1
  have hb32 := h4.2.1
  have hb40 := h4.2.2
  clear h4
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_store
  -- fd_ed25519_point_set_zero( r ), inlined
  step_pure
  step_store
  step_pure
  have hr_1024 := hr.room_14_25
  step_memset consuming hr_1024
  finish_block
  have hro := hr.1
  obtain ⟨Z, hZ, hZe⟩ :
      ∃ Z : MemoryState, S.mem = Z.storeQuad r fd_ed25519_point_set_zero.spec ∧
        Z.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem :=
    ⟨_, by rw [hS]; dsimp only; rw [MemoryState.storeAt_zero_14_25 hro]; rfl, by erase_frame⟩
  have hSa : S.alloc = ⟨S₀.alloc.nextFreeBlock + 6⟩ := by
    rw [hS]
    simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
  have hrS : Z.QuadRoom r := MemoryState.QuadRoom.of_storeQuad (hZ ▸ hr)
  have hfitR : S.mem.QuadFit r := hZ ▸ MemoryState.QuadFit.storeQuad_self hrS
  have hrz : S.mem.readQuad r = fd_ed25519_point_set_zero.spec :=
    hZ ▸ MemoryState.readQuad_storeQuad_self hrS
  have hYS : S.mem = (S.mem.storeDec dec D).storeQuad r fd_ed25519_point_set_zero.spec := by
    rw [MemoryState.storeDec_self hD]
    exact (MemoryState.storeQuad_readQuad_self' hfitR hrz).symm
  have hw1 : Ref.fd_curve25519_scalar_wnaf.Digits 7 (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3) :=
    Ref.fd_curve25519_scalar_wnaf.wnaf_digits x1 (bits := 3) (by decide)
  have hw2 := Ref.fd_curve25519_scalar_wnaf.wnaf8_digits x2
  have hs1 : SlidesAt S.mem n1s (Ref.fd_curve25519_scalar_wnaf.wnaf x1 3) :=
    SlidesAt.of_readAt hfits_n1s (by rw [hn1s_off]; decide) hread_n1s
  have hs2 : SlidesAt S.mem n2s (Ref.fd_curve25519_scalar_wnaf.wnaf x2 8) :=
    SlidesAt.of_readAt hfits_n2s (by rw [hn2s_off]; decide) hread_n2s
  have hB := base_init (TA := S₀.mem.readTable ta) (TB := S₀.mem.readTable tb) hr hs1 hs2
    hn1s_off hn2s_off hr_ne_n1s hr_ne_n2s hr_ne_bt hrta hrtb hr_ne_tbl htao hfa hxa hTA hbt_off
    hbt_bounds hread_bt hread_bt_8 hread_bt_16 hb24 hb32 hb40 hread_bt_48 hread_bt_56 htbl_off
    htbl_fits hread_tbl htbo hfb hxb hTB
  have hT : S.mem.QuadRoom tp := MemoryState.QuadRoom.of_room hroom_tp htp_off
  have hN1 : S₀.alloc.nextFreeBlock ≤ n1s.id.id := by slot_bound
  have hN2 : S₀.alloc.nextFreeBlock ≤ n2s.id.id := by slot_bound
  have hNb : S₀.alloc.nextFreeBlock ≤ bt.id.id := by slot_bound
  have hNt : S₀.alloc.nextFreeBlock ≤ tp.id.id := by slot_bound
  have htn1 : tp.id ≠ n1s.id := by mem_fact
  have htn2 : tp.id ≠ n2s.id := by mem_fact
  have htbt : tp.id ≠ bt.id := by mem_fact
  have htbp : ∀ j < 8, tp.id ≠ (btp tbl tb j).id := fun j _ => by
    unfold btp
    split
    · exact htbl_ne_tp.symm
    · exact htb_ne_tp.symm
  have hs : DecSep dec r n1s n2s bt ta tp (btp tbl tb) :=
    ⟨hrd.symm, hdec_ne_n1s, hdec_ne_n2s, hdec_ne_bt, hdta, hdec_ne_tp, fun j _ => by
      unfold btp
      split
      · exact hdec_ne_tbl
      · exact hdtb⟩
  -- for( i=31; i>=0; i-- ) { … if( nz ) break; }
  refine
    search r n1 ta n2 tb dec n1s n2s bt tp _ _ hw1 hw2 S hs1 hs2
      (by rw [hn1s_off]; decide) (by rw [hn2s_off]; decide) _ _ ?_ ?_ 15 E (by decide) hArgs
      ⟨by env_reads, by env_reads, by env_reads⟩ (by env_reads) rfl
  · -- the main loop from the first bit with a digit
    intro j hj hj' E₂ h₁ h₂ h₃
    obtain ⟨hC, hC', hL'⟩ := h₂
    split_env hC hC' hL' h₃
    block_init
    step_pure [slt_neg_one64 (show j < 2 ^ 63 by omega)]
    finish_block
    block_init
    iterate 6 step_pure [beq_eq_false_iff_ne.mpr hdn]
    finish_block
    refine
      iloopD r n1 ta n2 tb dec n1s n2s bt tp (btp tbl tb) _ _ (S₀.mem.readTable ta)
        (S₀.mem.readTable tb) S₀.alloc.nextFreeBlock (S.mem.eraseFrom S₀.alloc.nextFreeBlock) hs
        hNt hr_ne_tp htn1 htn2 htbt hta_ne_tp.symm htbp hw1 hw2 S.alloc _ _ j
        fd_ed25519_point_set_zero.spec S.mem D S E hj hB hT rfl hdr hg hOk hArgs
        ⟨by env_reads, by env_reads⟩ hwf rfl hYS
        fun E' S' Y' h₁ h₂ h₃ h₄ h₅ h₆ => ?_
    -- the lifetimes' ends
    obtain ⟨-, hL⟩ := h₂
    split_env hL
    block_init
    iterate 4 step_pure
    finish_block
    rw [← hP, spec_of_some hj', ← hPD, specDec_of_some hj']
    subst hS
    simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hN1,
      MemoryState.eraseFrom_lifetimeEnd_of_le hN2, MemoryState.eraseFrom_lifetimeEnd_of_le hNb,
      MemoryState.eraseFrom_lifetimeEnd_of_le hNt]
    rw [h₆, MemoryState.eraseFrom_storeQuad, MemoryState.eraseFrom_storeDec, h₅, hZ,
      MemoryState.eraseFrom_storeQuad, hZe, MemoryState.storeQuad_storeDec hrd,
      MemoryState.storeQuad_storeQuad_self hro, h₃, hSa]
  · -- no bit with a digit: `r` is zero
    intro hj E₂ h₁ h₂
    obtain ⟨-, -, hL⟩ := h₂
    split_env hL
    block_init
    iterate 4 step_pure
    finish_block
    rw [← hP, spec_of_none hj, ← hPD, specDec_of_none hj, MemoryState.storeDec_self hD₀]
    subst hS
    simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hN1,
      MemoryState.eraseFrom_lifetimeEnd_of_le hN2, MemoryState.eraseFrom_lifetimeEnd_of_le hNb,
      MemoryState.eraseFrom_lifetimeEnd_of_le hNt]
    -- the entry's state was substituted back by the walk
    dsimp only at hZ hSa
    rw [hZ, MemoryState.eraseFrom_storeQuad, hZe, hSa]

end Proof

end MLIR.Firedancer.Lane
