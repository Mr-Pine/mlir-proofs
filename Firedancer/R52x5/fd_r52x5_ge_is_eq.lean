module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Runs
public import Firedancer.R52x5.fd_r52x5_reduce
public import Firedancer.R52x5.Mlir.fd_r52x5_ge_is_eq
import Firedancer.Common.Tactics
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `1` when the limbs `l` reduce to zero, else `0`. -/
def fd_r52x5_ge_is_eq.isZero (l : Fin 5 → BitVec 64) : BitVec 32 :=
  if (l 0 ||| l 1 ||| l 2 ||| l 3 ||| l 4) = 0 then 1 else 0

/-- `FD_R52X5_GE_IS_EQ( A, B )`: the cross products `X_A Z_B - Z_A X_B` (`dx`) and
`Y_A Z_B - Z_A Y_B` (`dy`) reduced to canonical limbs, `1` when both are zero. -/
def fd_r52x5_ge_is_eq.spec (A B : Quad5) : BitVec 32 :=
  let A := A.permute 2 0 2 1
  let B := B.permute 0 2 1 2
  let A := (fd_r52x5_quad_mul_fast.spec A B).reduce
  let D := A.permute 1 0 3 2
  let A := A.negateLazy
  let D := (D.addFast A).reduce
  let dx := fd_r52x5_reduce.spec (D.elem 0)
  let dy := fd_r52x5_reduce.spec (D.elem 2)
  isZero dx &&& isZero dy

end

/-! ## Proof -/

section Proof

/-- The `ulong` mask in lanes 0 and 2, poison in 1 and 3: `FD_R52X5_QUAD_REDUCE`'s mask where only
lanes 0 and 2 are used. -/
abbrev mask02 : ⟦Ty4x64⟧ :=
  ((((Vector.replicate 4 (PoisonOr.poison : PoisonOr (BitVec 64))).set 0
                (.value 2251799813685247#64)).set
            1 .poison).set
        2 (.value 2251799813685247#64)).set
    3 .poison

/-- Lanes 0 and 2 of `v`, poison in 1 and 3. -/
def wlHalf (v : Wl) : Vector (PoisonOr (BitVec 64)) 4 :=
  #v[.value v[0], .poison, .value v[2], .poison]

theorem wlHalf_getElem_0 (v : Wl) : (wlHalf v)[0] = .value v[0] :=
  rfl

theorem wlHalf_getElem_2 (v : Wl) : (wlHalf v)[2] = .value v[2] :=
  rfl

/-- The `and` with `mask02`: masked lanes 0 and 2. -/
theorem zipWith_and_mask02 (x : Wl) :
    Vector.zipWith (Operation.and (w := 64)) (Ty.wrap (t := .vec 4 64) x) mask02 =
      wlHalf (wl_and x (Vector.replicate 4 2251799813685247#64)) := by
  ext i hi
  match i, hi with
  | 0, _ | 1, _ | 2, _ | 3, _ => simp [Ty.wrap_vec, wl_and, wlHalf, Operation.and]

/-- `FD_R52X5_QUAD_REDUCE`'s flagged add on lanes 0 and 2. -/
theorem zipWith_add_nsw_nuw_half (x y : Wl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (wlHalf (wl_and x (Vector.replicate 4 2251799813685247#64)))
        (Ty.wrap (t := .vec 4 64) (wl_shru y 51)) =
      wlHalf (wl_add (wl_and x (Vector.replicate 4 2251799813685247#64)) (wl_shru y 51)) := by
  ext i hi
  match i, hi with
  | 0, _ | 1, _ | 2, _ | 3, _ =>
    simp [Ty.wrap_vec, wl_and, wl_add, wl_shru, wlHalf, Operation.add, mask51_add_shr51]

/-- Two lanes' bits, lane 0 lowest. -/
theorem BitVec.packLanes_two (a b : BitVec 64) :
    BitVec.packLanes #v[a, b] = (b ++ a).cast (by decide) := by
  have key (k : Nat) (hk : k < 2) (j : Nat) (hj : j < 64) :
    (BitVec.packLanes #v[a, b]).getLsbD (k * 64 + j) = #v[a, b][k].getLsbD j := by
    rw [← BitVec.extractLsb'_packLanes #v[a, b] k hk, BitVec.getLsbD_extractLsb']
    simp [hj]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := key (i / 64) (by omega) (i % 64) (by omega)
  rw [show i / 64 * 64 + i % 64 = i by omega] at hk
  rw [hk, BitVec.getLsbD_cast]
  obtain h | h : i / 64 = 0 ∨ i / 64 = 1 := by omega
  all_goals
    simp only [h, BitVec.getLsbD_append, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ]
    grind

/-- The limbs `#v[a0, …, a4]` as `Fin 5 → BitVec 64`. -/
abbrev limbsOf (a0 a1 a2 a3 a4 : BitVec 64) : Fin 5 → BitVec 64 := fun i =>
  #v[a0, a1, a2, a3, a4][i]

/-- Limbs stored in pairs (`dx[0..1]`, `dx[2..3]`, then `dx[4]`): the five limb stores. -/
theorem MemoryState.storeAt_limbPairs {m : MemoryState} (h : m.LimbsFit p) :
    ((m.storeAt p (BitVec.packLanes #v[a0, a1])).storeAt (p.add 16#64)
            (BitVec.packLanes #v[a2, a3])).storeAt
        (p.add 32#64) a4 =
      m.storeLimbs p (limbsOf a0 a1 a2 a3 a4) := by
  have hp := h.1
  have hov (q : Pointer) (k : Nat) (hq : q.offset.toNat + k < 2 ^ 64) :
    ¬q.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
    omega
  have h16 : (p.add 16#64).offset.toNat = p.offset.toNat + 16 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hov0 := hov p 8 (by omega)
  have hov16 := hov (p.add 16#64) 8 (by omega)
  rw [BitVec.packLanes_two, BitVec.packLanes_two, MemoryState.storeAt_cast,
    MemoryState.storeAt_cast, ← MemoryState.storeAt_storeAt_append hov0 rfl (by omega), ←
    MemoryState.storeAt_storeAt_append hov16 rfl (by omega), Pointer.add_add]
  rfl

/-- `storeAt_limbPairs` for `dx` and `dy` stored alternately. -/
theorem MemoryState.storeAt_limbPairs₂ {m : MemoryState} (hp : m.LimbsFit p) (hq : m.LimbsFit q)
    (hne : q.id ≠ p.id) :
    (((((m.storeAt p (BitVec.packLanes #v[a0, a1])).storeAt q (BitVec.packLanes #v[b0, b1])).storeAt
                    (p.add 16#64) (BitVec.packLanes #v[a2, a3])).storeAt
                (q.add 16#64) (BitVec.packLanes #v[b2, b3])).storeAt
            (p.add 32#64) a4).storeAt
        (q.add 32#64) b4 =
      (m.storeLimbs p (limbsOf a0 a1 a2 a3 a4)).storeLimbs q (limbsOf b0 b1 b2 b3 b4) := by
  have hd (x y : Pointer) (hx : x.id = q.id) (hy : y.id = p.id) (v w : Nat) :
    (Range.of x v).Disjoint (Range.of y w) := Or.inl (by simpa [Range.of, hx, hy] using hne)
  rw [MemoryState.storeAt_comm (hd q (p.add 16#64) rfl rfl _ _),
    MemoryState.storeAt_comm (hd (q.add 16#64) (p.add 32#64) rfl rfl _ _),
    MemoryState.storeAt_comm (hd q (p.add 32#64) rfl rfl _ _), MemoryState.storeAt_limbPairs hp,
    MemoryState.storeAt_limbPairs hq.storeLimbs]

/-- Limb `0` of known limbs. -/
theorem MemoryState.readAt_limb0 {m : MemoryState} (h : m.readLimbs p = l) :
    m.readAt p 64 = l 0 := by
  rw [← h]; rfl

/-- Limb `3` of known limbs. -/
theorem MemoryState.readAt_limb3 {m : MemoryState} (h : m.readLimbs p = l) :
    m.readAt (p.add 24#64) 64 = l 3 := by
  rw [← h]; rfl

/-- Limb `4` of known limbs. -/
theorem MemoryState.readAt_limb4 {m : MemoryState} (h : m.readLimbs p = l) :
    m.readAt (p.add 32#64) 64 = l 4 := by
  rw [← h]; rfl

/-- Limbs `1, 2` read as 128 bits. -/
theorem MemoryState.readAt_limbs12 {m : MemoryState} (hf : m.LimbsFit p) (h : m.readLimbs p = l) :
    m.readAt (p.add 8#64) 128 = BitVec.packLanes #v[l 1, l 2] := by
  have hov : ¬(p.add 8#64).offset.uaddOverflow 8#64 := by
    have := hf.1
    simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
      decide_eq_true_eq]
    omega
  have hf8 : Fits m (p.add 8#64) 128 :=
    Fits.add_of_le
      (by
        have := hf.1
        simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
        omega)
      (by decide) (MemoryState.LimbsFit.fits hf)
  have e0 :=
    MemoryState.readAt_of_readAt_le (m := m) (p := p.add 8#64) (v := 128) (w := 64) (by decide) rfl
  have e1 := MemoryState.readAt_add_of_readAt hf8 hov (w := 64) (by decide) rfl
  rw [Pointer.add_add] at e1
  simp only [BitVec.reduceAdd, BitVec.reduceToNat, Nat.reduceMul] at e1
  rw [← h, BitVec.packLanes_two]
  change _ = (m.readAt (p.add 16#64) 64 ++ m.readAt (p.add 8#64) 64).cast _
  rw [e0, e1]
  generalize m.readAt (p.add 8#64) 128 = x
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_cast, BitVec.getLsbD_append, BitVec.getLsbD_extractLsb',
    BitVec.getLsbD_setWidth]
  grind

/-- Limbs `0 … 3` read as 256 bits. -/
theorem MemoryState.readAt_limbs0123 {m : MemoryState} (hf : m.LimbsFit p) (h : m.readLimbs p = l) :
    m.readAt p 256 = BitVec.packLanes #v[l 0, l 1, l 2, l 3] := by
  have hov (k : Nat) (hk : k ≤ 32) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    have := hf.1
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
    omega
  have hf256 : Fits m p 256 := (MemoryState.LimbsFit.fits hf).mono (by omega)
  have e0 := MemoryState.readAt_of_readAt_le (m := m) (p := p) (v := 256) (w := 64) (by decide) rfl
  have e1 := MemoryState.readAt_add_of_readAt hf256 (hov 8 (by omega)) (w := 64) (by decide) rfl
  have e2 := MemoryState.readAt_add_of_readAt hf256 (hov 16 (by omega)) (w := 64) (by decide) rfl
  have e3 := MemoryState.readAt_add_of_readAt hf256 (hov 24 (by omega)) (w := 64) (by decide) rfl
  simp only [BitVec.reduceToNat, Nat.reduceMul] at e1 e2 e3
  rw [← h, BitVec.packLanes_four]
  change
    _ =
      (m.readAt (p.add 24#64) 64 ++
            (m.readAt (p.add 16#64) 64 ++ (m.readAt (p.add 8#64) 64 ++ m.readAt p 64))).cast
        _
  rw [e0, e1, e2, e3]
  generalize m.readAt p 256 = x
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_cast, BitVec.getLsbD_append, BitVec.getLsbD_extractLsb',
    BitVec.getLsbD_setWidth]
  grind

/-- `D - A + 32p` as compiled is `D + (32p - A)` (`NEGATE_LAZY` then `ADD_FAST`). -/
theorem wl_add_wl_sub (x y c : Wl) : wl_add (wl_sub x y) c = wl_add x (wl_sub c y) := by
  apply Vector.ext
  intro i hi
  simp only [wl_add, wl_sub, Vector.getElem_ofFn, Fin.getElem_fin]
  rw [BitVec.sub_eq_add_neg, BitVec.sub_eq_add_neg]
  ac_rfl

/-- Coordinate `j`'s limbs: lane `j` of each `wl_t`. -/
theorem Quad5.elem_eq (Q : Quad5) (j : Fin 4) :
    Q.elem j = limbsOf Q.P0[j] Q.P1[j] Q.P2[j] Q.P3[j] Q.P4[j] := by
  funext i
  fin_cases i <;> rfl

/-- The compiled return: one OR of `dy`'s and `dx`'s limbs against zero. -/
theorem fd_r52x5_ge_is_eq.isZero_and (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : BitVec 64) :
    ((if (x0 ||| x1 ||| x2 ||| x3 ||| x4) = 0 then 1 else 0) &&&
          if (y0 ||| y1 ||| y2 ||| y3 ||| y4) = 0 then 1 else 0 :
        BitVec 32) =
      (BitVec.ofBool
            (y0 ||| y1 ||| y2 ||| y3 ||| y4 ||| x0 ||| x1 ||| x2 ||| x3 ||| x4 == 0#64)).setWidth
        32 := by
  split <;> split <;> bv_decide

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l

attribute [local mlir_operation] vpmadd52l_wl zipWith_add_wl zipWith_sub_wl zipWith_and_wl
  zipWith_lshr_wl zipWith_and_mask02 zipWith_add_nsw_nuw_half wlHalf_getElem_0 wlHalf_getElem_2

/-- `fd_r52x5_ge_is_eq` returns `spec` of the QUADs `A` and `B`; its 15 `wl_permute` calls'
unions and seven temporaries move the counter on by 22 blocks. -/
public theorem fd_r52x5_ge_is_eq.call_eq (A B : Quad5) (s : GlobalState) (hwf : s.WF) :
    fd_r52x5_ge_is_eq.call
        (fd_r52x5_ge_is_eq.args (Ty.wrap A.P0) (Ty.wrap A.P1) (Ty.wrap A.P2) (Ty.wrap A.P3)
          (Ty.wrap A.P4) (Ty.wrap B.P0) (Ty.wrap B.P1) (Ty.wrap B.P2) (Ty.wrap B.P3) (Ty.wrap B.P4))
        s =
      .value
        (.cons (.value (fd_r52x5_ge_is_eq.spec A B)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 22⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 23 step_pure
  step_alloca with z0
  step_alloca with z1
  step_alloca with z2
  step_alloca with z3
  step_alloca with z4
  step_alloca with dx
  step_alloca with dy
  -- FD_R52X5_QUAD_PERMUTE( A, 2,0,2,1, A ); FD_R52X5_QUAD_PERMUTE( B, 0,2,1,2, B );
  iterate 10 step_call using wl_permute.call_eq [BitVec.toNat_ofNat]
  -- FD_R52X5_QUAD_MUL_FAST( A, A, B ); FD_R52X5_QUAD_REDUCE( A, A );
  step_pattern using runBodyFrom_qpMulRun (X := A.permute 2 0 2 1) (Y := B.permute 0 2 1 2) inline
  step_pattern using runBodyFrom_reduceRun inline
  clear hread_z0 hread_z1 hread_z2 hread_z3 hread_z4 hz0_fits hz1_fits hz2_fits hz3_fits hz4_fits
  -- FD_R52X5_QUAD_PERMUTE( D, 1,0,3,2, A );
  step_pattern using runBodyFrom_permuteRun 1 0 3 2 inline
  -- FD_R52X5_QUAD_NEGATE_LAZY( A, A ); FD_R52X5_QUAD_ADD_FAST( D, D, A ); as D - A + 32p
  step_pure
  step_pure with D0
  step_pure
  step_pure with D1
  step_pure
  step_pure with D2
  step_pure
  step_pure with D3
  step_pure
  step_pure with D4
  -- FD_R52X5_QUAD_REDUCE( D, D ), lanes 0 and 2
  iterate 15 step_pure
  -- dx[i] = wl_extract( Di, 0 ); dy[i] = wl_extract( Di, 2 );
  iterate 4 step_pure
  step_store
  step_pure
  step_store
  iterate 4 step_pure
  step_store
  step_pure
  step_store
  iterate 2 step_pure
  step_store
  iterate 2 step_pure
  step_store
  -- the six stores are `dx`'s and `dy`'s limbs
  have hdx₀ : S.mem.LimbsFit dx := .of_fits hdx_fits hdx_off
  have hdy₀ : S.mem.LimbsFit dy := .of_fits hdy_fits hdy_off
  rw [hS] at hdx₀ hdy₀
  simp only [MemoryState.LimbsFit, Fits.storeAt_iff] at hdx₀ hdy₀
  have hyx : dy.id ≠ dx.id := by
    rw [hdx, hdy]; exact GlobalState.slot_id_ne (by decide)
  rw [MemoryState.storeAt_limbPairs₂ hdx₀ hdy₀ hyx] at hS
  -- fd_r52x5_reduce( dx ); fd_r52x5_reduce( dy );
  have hdx_lf : S.mem.LimbsFit dx := .of_fits hdx_fits hdx_off
  have hdy_lf : S.mem.LimbsFit dy := .of_fits hdy_fits hdy_off
  step_call using fd_r52x5_reduce.call_eq
  step_call using fd_r52x5_reduce.call_eq
  clear hdx₀ hdy₀
  -- return ((dx[0]|dx[1]|dx[2]|dx[3]|dx[4]) == 0) & ((dy[0]|dy[1]|dy[2]|dy[3]|dy[4]) == 0);
  -- with the reduced limbs opaque as `X`, `Y`
  obtain ⟨X, hX⟩ : ∃ X, S.mem.readLimbs dx = X := ⟨_, rfl⟩
  obtain ⟨Y, hY⟩ : ∃ Y, S.mem.readLimbs dy = Y := ⟨_, rfl⟩
  rw [hX, eq_comm] at hread_dx
  rw [hY, eq_comm] at hread_dy
  have hread_dx8 := MemoryState.readAt_limbs12 hdx_lf hX
  have hread_dy0 := MemoryState.readAt_limbs0123 hdy_lf hY
  step_load [MemoryState.readAt_limb0 hX]
  step_load [MemoryState.readAt_limb3 hX]
  step_load [MemoryState.readAt_limb4 hX]
  step_load
  step_load
  step_load [MemoryState.readAt_limb4 hY]
  iterate 13 step_pure
  finish_block
  clear_reads
  subst hS
  erase_frame
  have hspec :
    fd_r52x5_ge_is_eq.spec A B = fd_r52x5_ge_is_eq.isZero X &&& fd_r52x5_ge_is_eq.isZero Y := by
    rw [← hread_dx, ← hread_dy]
    subst hD0 hD1 hD2 hD3 hD4
    simp only [fd_r52x5_ge_is_eq.spec]
    obtain ⟨R, hR⟩ :
      ∃ R, (fd_r52x5_quad_mul_fast.spec (A.permute 2 0 2 1) (B.permute 0 2 1 2)).reduce = R :=
      ⟨_, rfl⟩
    rw [hR]
    simp only [wl_add_wl_sub]
    simp only [Quad5.elem_eq, Quad5.reduce, Quad5.addFast, Quad5.negateLazy, wl_bcast]
    rfl
  rw [hspec]
  unfold fd_r52x5_ge_is_eq.isZero
  rw [fd_r52x5_ge_is_eq.isZero_and]
  rfl

end Proof

end MLIR.Firedancer.R52x5
