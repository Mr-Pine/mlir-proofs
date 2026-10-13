module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.GeDbl
public import Firedancer.R52x5.Mlir.fd_ed25519_point_dbln
import Firedancer.Common.Tactics

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `2ⁿ A`: `FD_R52X5_GE_DBL` once, then `n - 1` more times. -/
def fd_ed25519_point_dbln.spec (A : Quad5) (n : Nat) : Quad5 :=
  Nat.repeat geDbl (n - 1) (geDbl A)

end

/-! ## Proof -/

section Proof

namespace fd_ed25519_point_dbln

/-- `j` more doublings of `P`, the loop's order. -/
def iter : Nat → Quad5 → Quad5
  | 0, P => P
  | j + 1, P => iter j (geDbl P)

theorem repeat_eq_iter (j : Nat) (P : Quad5) : Nat.repeat geDbl j P = iter j P := by
  induction j generalizing P with
  | zero => rfl
  | succ j ih =>
    rw [iter, ← ih, Nat.repeat]
    clear ih
    induction j with
    | zero => rfl
    | succ j ih => rw [Nat.repeat, ih, Nat.repeat]

/-- The entry block's registers the loop and its exit read: the constants, the loop's ten
temporaries, the four `LANE_IF` masks' bytes (hoisted out of the loop) and `r`'s limb pointers. -/
abbrev LoopEnv (E : ⟪Γ⟫) (r z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Pointer) : Prop :=
  E ⊨ [%4137 := 1#32, %4138 := 0#32, %4139 := 3#32, %4140 := 2#32, %4141 :=
    (Vector.replicate 4 51#64 : Wl), %4142 := (Vector.replicate 4 2251799813685247#64 : Wl),
    %4143 := (Vector.replicate 4 19#64 : Wl), %4144 :=
    (Vector.replicate 4 72057594037927328#64 : Wl), %4145 :=
    (Vector.replicate 4 72057594037927904#64 : Wl), %4146 := (Vector.replicate 4 1#64 : Wl),
    %4147 := (Vector.replicate 32 0#8 : Vector (BitVec 8) 32), %4148 := 1#8, %4159 := z0, %4160 :=
    z1, %4161 := z2, %4162 := z3, %4163 := z4, %4164 := z5, %4165 := z6, %4166 := z7, %4167 := z8,
    %4168 := z9, %4196 := wlBytes (laneMask 0 0 0 1), %4282 := wlBytes (laneMask 0 0 1 0), %4303 :=
    wlBytes (laneMask 1 0 0 1), %4321 := wlBytes (laneMask 0 1 1 1), %4368 := r.add 32#64, %4370 :=
    r.add 64#64, %4372 := r.add 96#64, %4374 := r.add 128#64]

/-- The loop's header `^bb3` holding `P` and the counter `k`. -/
abbrev hdr (E : ⟪Γ⟫) (P : Quad5) (k : Nat) : ⟪Γ⟫ :=
  E[%4391 := Ty.wrap P.P4, %4392 := Ty.wrap P.P3, %4393 := Ty.wrap P.P2, %4394 := Ty.wrap P.P1,
    %4395 := Ty.wrap P.P0, %4396 := .value (BitVec.ofNat 8 k)]

/-- The loop's facts about a state: well-formed, room for the point `r`, the ten temporaries in
bounds and writable (dead between their uses). -/
abbrev Inv (S : GlobalState) (r z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Pointer) : Prop :=
  S.WF ∧
    S.mem.Quad5Room r ∧
    InBounds S.mem z0 256 ∧
    InBounds S.mem z1 256 ∧
    InBounds S.mem z2 256 ∧
    InBounds S.mem z3 256 ∧
    InBounds S.mem z4 256 ∧
    InBounds S.mem z5 256 ∧
    InBounds S.mem z6 256 ∧
    InBounds S.mem z7 256 ∧
    InBounds S.mem z8 256 ∧
    InBounds S.mem z9 256 ∧
    Writable S.mem z0 ∧
    Writable S.mem z1 ∧
    Writable S.mem z2 ∧
    Writable S.mem z3 ∧
    Writable S.mem z4 ∧
    Writable S.mem z5 ∧
    Writable S.mem z6 ∧ Writable S.mem z7 ∧ Writable S.mem z8 ∧ Writable S.mem z9

/-- The temporaries: five distinct blocks each for the square and the product, all from block `b`
on. -/
abbrev Slots (b : Nat) (z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Pointer) : Prop :=
  (z1.id ≠ z0.id ∧
      z2.id ≠ z0.id ∧
      z3.id ≠ z0.id ∧
      z4.id ≠ z0.id ∧
      z2.id ≠ z1.id ∧
      z3.id ≠ z1.id ∧ z4.id ≠ z1.id ∧ z3.id ≠ z2.id ∧ z4.id ≠ z2.id ∧ z4.id ≠ z3.id) ∧
    (z6.id ≠ z5.id ∧
      z7.id ≠ z5.id ∧
      z8.id ≠ z5.id ∧
      z9.id ≠ z5.id ∧
      z7.id ≠ z6.id ∧
      z8.id ≠ z6.id ∧ z9.id ≠ z6.id ∧ z8.id ≠ z7.id ∧ z9.id ≠ z7.id ∧ z9.id ≠ z8.id) ∧
    b ≤ z0.id.id ∧
    b ≤ z1.id.id ∧
    b ≤ z2.id.id ∧
    b ≤ z3.id.id ∧
    b ≤ z4.id.id ∧ b ≤ z5.id.id ∧ b ≤ z6.id.id ∧ b ≤ z7.id.id ∧ b ≤ z8.id.id ∧ b ≤ z9.id.id

/-- One trip through `^bb3` on `P` at counter `k`: `geDbl P` into the registers, the temporaries
written, thirty blocks used; then back to the header if `k + 1 < n`, else to the exit. -/
theorem trip (r a : Pointer) (n : BitVec 32) (z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Pointer) (b k : Nat)
    (P : Quad5) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hArgs : E.args = (args (.value r) (.value a) (.value n)).get)
    (hR : LoopEnv E r z0 z1 z2 z3 z4 z5 z6 z7 z8 z9) (hI : Inv S r z0 z1 z2 z3 z4 z5 z6 z7 z8 z9)
    (hZ : Slots b z0 z1 z2 z3 z4 z5 z6 z7 z8 z9) (hrb : r.id.id < b)
    (hback :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a) (.value n)).get →
          LoopEnv E' r z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 →
          Inv S' r z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 →
          S'.alloc = ⟨S.alloc.nextFreeBlock + 30⟩ →
          S'.mem.eraseFrom b = S.mem.eraseFrom b →
          ((BitVec.ofNat 8 k + 1#8).setWidth 32).ult n = true →
          (fd_ed25519_point_dbln.runFrom (hdr E' (geDbl P) (k + 1)) 3 S' >>= g) = K)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a) (.value n)).get →
          (E' ⊨ [%4368 := r.add 32#64, %4370 := r.add 64#64, %4372 := r.add 96#64, %4374 :=
            r.add 128#64, %4588 := (geDbl P).P0, %4590 := (geDbl P).P1, %4592 := (geDbl P).P2,
            %4594 := (geDbl P).P3, %4596 := (geDbl P).P4]) →
          S'.WF →
          S'.mem.Quad5Room r →
          S'.alloc = ⟨S.alloc.nextFreeBlock + 30⟩ →
          S'.mem.eraseFrom b = S.mem.eraseFrom b →
          ¬((BitVec.ofNat 8 k + 1#8).setWidth 32).ult n = true →
          (fd_ed25519_point_dbln.runFrom E' 1 S' >>= g) = K) :
    (fd_ed25519_point_dbln.runFrom (hdr E P k) 3 S >>= g) = K := by
  obtain
    ⟨hwf, hr, h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9⟩ := hI
  obtain ⟨hne, hne', hb0, hb1, hb2, hb3, hb4, hb5, hb6, hb7, hb8, hb9⟩ := hZ
  block_init
  -- FD_R52X5_QUAD_PERMUTE( _ta, 1,0,3,2, P1 ), FD_R52X5_QUAD_ADD_FAST( _ta, _ta, P1 )
  step_pattern using runBodyFrom_permuteRun 1 0 3 2 inline
  step_pattern using runBodyFrom_addFastRun inline
  -- FD_R52X5_QUAD_PERMUTE( _ta, 0,1,0,1, _ta ), FD_R52X5_QUAD_LANE_IF( _ta, 0,0,0,1, _ta, P1 )
  step_pattern using runBodyFrom_permuteRun 0 1 0 1 inline
  step_pattern using runBodyFrom_laneIfMaskRun 0 0 0 1 inline
  -- FD_R52X5_QUAD_REDUCE( _ta, _ta ), FD_R52X5_QUAD_SQR_FAST( _ta, _ta )
  step_pattern using runBodyFrom_reduceCastRun inline
  step_pattern using runBodyFrom_qpSqrRun inline
  -- _1111, _2222, _2224
  step_pattern using runBodyFrom_permuteRun 0 0 0 0 inline
  step_pattern using runBodyFrom_permuteRun 1 1 1 1 inline
  step_pattern using runBodyFrom_laneIfMaskRun 0 0 0 1 inline
  step_pattern using runBodyFrom_negateLazyRun inline
  -- FD_R52X5_QUAD_ADD_FAST( _ta, _ta, _ta ) up to FD_R52X5_QUAD_REDUCE( _ta, _ta )
  step_pattern using runBodyFrom_addSelfRun inline
  step_pattern using runBodyFrom_laneIfZeroMaskRun 0 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_laneIfBytesMaskRun 1 0 0 1 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_laneIfZeroMaskRun 0 1 1 1 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_reduceRun inline
  -- _tb, _ta, FD_R52X5_QUAD_MUL_FAST( P2, _ta, _tb ), FD_R52X5_QUAD_REDUCE( P2, P2 )
  step_pattern using runBodyFrom_permuteRun 3 1 1 3 inline
  step_pattern using runBodyFrom_permuteRun 2 0 2 0 inline
  step_pattern using runBodyFrom_qpMulRun inline
  step_pattern using runBodyFrom_reduceRun_as inline
  have hD : geDbl P = D := by
    rw [← _hD]
    rfl
  clear _hD
  rw [hD] at hback hexit
  -- `i++`, `i<n`
  step_pure
  step_pure
  step_pure
  finish_block
  · step_loop using hback
    · exact (BitVec.ofNat_add _ _).symm
    · rw [← hS]
      exact
        ⟨hwf, hr, h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9⟩
    · rw [MemoryState.eraseFrom_callTmp5_of_le hb5 hb6 hb7 hb8 hb9,
        MemoryState.eraseFrom_callTmp5_of_le hb0 hb1 hb2 hb3 hb4]
  · step_loop using hexit
    rw [MemoryState.eraseFrom_callTmp5_of_le hb5 hb6 hb7 hb8 hb9,
      MemoryState.eraseFrom_callTmp5_of_le hb0 hb1 hb2 hb3 hb4]

/-- The loop from `^bb3` at counter `k` with `P` in the registers and `m + 1` trips left: at the
exit the registers hold `iter (m + 1) P`; `30 (m + 1)` blocks used, only the temporaries
written. -/
theorem loop (r a : Pointer) (n : BitVec 32) (z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Pointer) (b : Nat)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hZ : Slots b z0 z1 z2 z3 z4 z5 z6 z7 z8 z9) (hrb : r.id.id < b) :
    ∀ m k (P : Quad5) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value a) (.value n)).get →
        LoopEnv E r z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 →
        k + m + 1 = n.toNat →
        n.toNat < 256 →
        Inv S r z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value a) (.value n)).get →
            (E' ⊨ [%4368 := r.add 32#64, %4370 := r.add 64#64, %4372 := r.add 96#64, %4374 :=
              r.add 128#64, %4588 := (iter (m + 1) P).P0, %4590 := (iter (m + 1) P).P1, %4592 :=
              (iter (m + 1) P).P2, %4594 := (iter (m + 1) P).P3, %4596 := (iter (m + 1) P).P4]) →
            S'.WF →
            S'.mem.Quad5Room r →
            S'.alloc = ⟨S.alloc.nextFreeBlock + 30 * (m + 1)⟩ →
            S'.mem.eraseFrom b = S.mem.eraseFrom b →
            (fd_ed25519_point_dbln.runFrom E' 1 S' >>= g) = K) →
        (fd_ed25519_point_dbln.runFrom (hdr E P k) 3 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro k P S E hArgs hR hk hn hI hK
    refine trip r a n z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 b k P S E g K hArgs hR hI hZ hrb ?_ ?_
    · -- around again: impossible, the counter has reached `n`
      intro _ _ _ _ _ _ _ hbr
      have : (BitVec.setWidth 32 (BitVec.ofNat 8 k + 1#8)).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth, BitVec.toNat_add]
        omega
      simp [BitVec.ult, this] at hbr
      omega
    · intro E' S' h1 h2 h3 h4 h5 h6 _
      exact hK E' S' h1 h2 h3 h4 h5 h6
  | succ m ih =>
    intro k P S E hArgs hR hk hn hI hK
    refine trip r a n z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 b k P S E g K hArgs hR hI hZ hrb ?_ ?_
    · -- around again, one trip fewer
      intro E' S' g1 g2 g3 ha hm _
      refine ih (k + 1) _ S' E' g1 g2 (by omega) hn g3 fun E'' S'' f1 f2 f3 f4 f5 f6 => ?_
      refine hK E'' S'' f1 f2 f3 f4 ?_ (f6.trans hm)
      rw [f5, ha, AllocState.mk.injEq]
      dsimp only
      omega
    · -- leaving: impossible, the counter is below `n`
      intro _ _ _ _ _ _ _ _ hbr
      have : (BitVec.setWidth 32 (BitVec.ofNat 8 k + 1#8)).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth, BitVec.toNat_add]
        omega
      simp [BitVec.ult, this] at hbr
      omega

end fd_ed25519_point_dbln

-- the first doubling inline: about 230 instructions, 20 allocas
set_option maxHeartbeats 400000 in
/-- `fd_ed25519_point_dbln` stores `spec` of the point at `a` (its `2ⁿ` multiple) at `r` and returns
`r`, for `1 ≤ n < 256` (the C counter is a `uchar`); `r` may be `a`. Its twenty temporaries and
thirty `wl_permute` calls per doubling use up `20 + 30 n` block ids. -/
public theorem fd_ed25519_point_dbln.call_eq (r a : Pointer) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.Quad5Room r) (ha : s.mem.Quad5Fit a)
    (hn : 1 ≤ n.toNat ∧ n.toNat < 256) :
    fd_ed25519_point_dbln.call (fd_ed25519_point_dbln.args (.value r) (.value a) (.value n)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 20 + 30 * n.toNat⟩,
            mem :=
              s.mem.storeQuad5 r (fd_ed25519_point_dbln.spec (s.mem.readQuad5 a) n.toNat) }) := by
  obtain ⟨hn1, hn⟩ := hn
  generalize hres : fd_ed25519_point_dbln.spec (s.mem.readQuad5 a) n.toNat = res
  func_init
  have hra : S.mem.readQuad5 a = S₀.mem.readQuad5 a := by rw [hS]
  have hro := hr.1
  have hrb : r.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt (hS ▸ hr.2.1 : Room S₀.mem r 256).mem
  block_init
  iterate 12 step_pure
  iterate 20 step_alloca
  -- FD_R52X5_GE_DBL( r->P, a->P ), as `fd_ed25519_partial_dbl`
  step_pattern using runBodyFrom_permuteLoadRun 1 0 3 2 inline
  have hA := hra ▸ _hA
  clear _hA hra
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_permuteRun 0 1 0 1 inline
  step_pattern using runBodyFrom_laneIfRun 0 0 0 1 inline
  step_pattern using runBodyFrom_reduceCastRun inline
  step_pattern using runBodyFrom_qpSqrRun inline
  step_pattern using runBodyFrom_permuteRun 0 0 0 0 inline
  step_pattern using runBodyFrom_permuteRun 1 1 1 1 inline
  step_pattern using runBodyFrom_laneIfMaskRun 0 0 0 1 inline
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_addSelfRun inline
  step_pattern using runBodyFrom_laneIfZeroRun 0 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_laneIfBytesRun 1 0 0 1 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_laneIfZeroRun 0 1 1 1 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_reduceRun inline
  step_pattern using runBodyFrom_permuteRun 3 1 1 3 inline
  step_pattern using runBodyFrom_permuteRun 2 0 2 0 inline
  step_pattern using runBodyFrom_qpMulGepRun inline
  step_pattern using runBodyFrom_reduceStoreRun_as inline
  have hD : geDbl A = D := by
    rw [← _hD]
    rfl
  clear _hD
  clear_reads
  -- `1<n`
  step_pure
  finish_block
  · -- `n > 1`: the loop, `n - 1` trips
    have hn2 : 2 ≤ n.toNat := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    subst hv22 hv23 hv24 hv25 hv26 hv27 hv28 hv29 hv30 hv31
    have hZ :
      fd_ed25519_point_dbln.Slots S₀.alloc.nextFreeBlock (S₀.slot 10) (S₀.slot 11) (S₀.slot 12)
        (S₀.slot 13) (S₀.slot 14) (S₀.slot 15) (S₀.slot 16) (S₀.slot 17) (S₀.slot 18)
        (S₀.slot 19) := by
      refine
        ⟨⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩, ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩, ?_, ?_,
          ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
      all_goals
        first
        | mem_fact
        | slot_bound
    rw [hA, fd_ed25519_point_dbln.spec, fd_ed25519_point_dbln.repeat_eq_iter,
      show n.toNat - 1 = n.toNat - 2 + 1 by omega, hD] at hres
    have hI :
      fd_ed25519_point_dbln.Inv S r (S₀.slot 10) (S₀.slot 11) (S₀.slot 12) (S₀.slot 13) (S₀.slot 14)
        (S₀.slot 15) (S₀.slot 16) (S₀.slot 17) (S₀.slot 18) (S₀.slot 19) :=
      ⟨hwf, by mem_fact, hv22_bounds, hv23_bounds, hv24_bounds, hv25_bounds, hv26_bounds,
        hv27_bounds, hv28_bounds, hv29_bounds, hv30_bounds, hv31_bounds, by mem_fact, by mem_fact,
        by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact,
        by mem_fact⟩
    step_loop using
      fd_ed25519_point_dbln.loop r a n _ _ _ _ _ _ _ _ _ _ S₀.alloc.nextFreeBlock _ _ hZ hrb
        (n.toNat - 2) 1
    · -- `^bb1` stores the registers at `r`, `^bb2` returns
      intro _ _ _ hal hm
      block_init
      step_store
      step_store
      step_store
      step_store
      step_store
      finish_block
      block_init
      finish_block
      subst hS
      dsimp only at hal ⊢
      rw [← MemoryState.storeQuad5_mk, MemoryState.eraseFrom_storeQuad5, hm, hal]
      subst S
      erase_frame
      rw [MemoryState.storeQuad5_storeQuad5_self hro, ← hres]
      congr 3
      simp only [GlobalState.alloca, AllocState.mk.injEq]
      omega
  · -- `n ≤ 1`: no trip
    have hn1' : n.toNat = 1 := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    block_init
    finish_block
    subst hS
    erase_frame
    rw [← hres, hA, fd_ed25519_point_dbln.spec, hn1', Nat.sub_self, Nat.repeat, hD]
    rfl

end Proof

end MLIR.Firedancer.R52x5
