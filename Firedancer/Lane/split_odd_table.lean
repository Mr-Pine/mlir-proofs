module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Split
public import Firedancer.Lane.fd_ed25519_point_dbln
public import Firedancer.Lane.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Mlir.split_odd_table

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

namespace split_odd_table

open _root_.Firedancer.Lane.Mlir.split_odd_table

/-- The lift's runs from a block. -/
local notation "runD" => _root_.Firedancer.Lane.Mlir.split_odd_table.runFrom

/-- A counter below `2^31` has no sign bit. -/
theorem msb_of_lt {n : BitVec 32} (h : n.toNat < 2 ^ 31) : n.msb = false := by
  simp only [BitVec.msb_eq_decide, decide_eq_false_iff_not]
  omega

/-- A counter zero-extends to the same `long`. -/
theorem setWidth_eq (n : BitVec 32) : BitVec.setWidth 64 n = BitVec.ofNat 64 n.toNat := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]

/-- A counter compared with `n` zero-extended. -/
theorem ofNat_eq_setWidth_iff {n : BitVec 32} {i : Nat} (h : i < 2 ^ 64) :
    BitVec.ofNat 64 i = BitVec.setWidth 64 n ↔ i = n.toNat := by
  rw [setWidth_eq]
  constructor
  · intro e
    have := congrArg BitVec.toNat e
    simp only [BitVec.toNat_ofNat] at this
    omega
  · intro e
    rw [e]

/-- `tbl[i] = p2 + tbl[i-1]` on the first `i` entries: the first `i + 1`. -/
theorem add_state {M : MemoryState} {tbl p2 : Pointer} {P2 P : Quad} {n i : Nat}
    (hP2 : M.readQuad p2 = P2) (hp2t : p2.id ≠ tbl.id) (ht : M.TableRoom tbl n)
    (hto : tbl.offset.toNat + 192 * n < 2 ^ 64) (hi1 : 1 ≤ i) (hi : i < n) :
    let T := M.storeTable tbl i (split_odd_table.raw P2 P)
    T.storeQuad (tbl.add (BitVec.ofNat 64 (192 * i)))
        (fd_ed25519_point_add_with_opts.spec (T.readQuad p2)
          (T.readQuad (tbl.add (BitVec.ofNat 64 (192 * (i - 1))))) 0#32) =
      M.storeTable tbl (i + 1) (split_odd_table.raw P2 P) := by
  intro T
  have e1 : T.readQuad p2 = P2 := by
    rw [Firedancer.Lane.Split.readQuad_storeTable_of_id_ne (Ne.symm hp2t), hP2]
  have e2 : T.readQuad (tbl.add (BitVec.ofNat 64 (192 * (i - 1)))) =
      split_odd_table.raw P2 P (i - 1) :=
    Firedancer.Lane.Split.readTable_storeTable (fun k hk => ht k (by omega)) (by omega) (by omega)
  rw [e1, e2, Firedancer.Lane.Split.storeTable_succ]
  obtain ⟨j, rfl⟩ : ∃ j, i = j + 1 := ⟨i - 1, by omega⟩
  rfl

/-- The registers the loops read: the precomputation's constants, `p2`, `n`. -/
abbrev Regs (p2 : Pointer) (n : BitVec 32) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := Vector.replicate 8 24#64, %1 := Vector.replicate 8 7#64,
    %2 := Vector.replicate 8 9#64,
    %3 := #v[0#64, 0#64, 0#64, 15037786634#64, 0#64, 0#64, 0#64, 309467527341#64],
    %4 := #v[0#64, 0#64, 0#64, 507525298899#64, 0#64, 0#64, 0#64, 6596238350568#64],
    %5 := #v[1#64, 1#64, 1#64, 3934839304537#64, 0#64, 0#64, 0#64, 521695520920#64],
    %6 := Vector.replicate 8 0#64, %7 := m4340, %8 := Vector.replicate 8 1048576#64, %9 := bias03,
    %10 := Vector.replicate 8 8796093022207#64, %12 := s4340, %13 := Vector.replicate 8 43#64,
    %14 := Vector.replicate 8 18446744073708503040#64, %15 := negBias03, %24 := 1#64, %25 := 0#32,
    %26 := 0#64, %27 := (Vector.replicate 8 .poison : ⟦.vec 8 64⟧),
    %39 :=
    (#v[.value 8796093022189#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison] : ⟦.vec 8 64⟧),
    %47 :=
    (#v[.value 8796093022207#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison] : ⟦.vec 8 64⟧),
    %55 :=
    (#v[.value 8796093022207#64, .poison, .poison, .poison, .value 1099511627775#64, .poison,
      .poison, .poison] : ⟦.vec 8 64⟧),
    %63 := k19Lanes, %64 := p2, %73 := BitVec.setWidth 64 n]


/-- `^bb1` at `i`: `tbl[i] = p2 + tbl[i-1]`; then around, or on to `^bb3` at `i + 1 = n`. -/
theorem add_iter (tbl p p2 : Pointer) (n : BitVec 32) (P2 P : Quad) (M : MemoryState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi1 : 1 ≤ i)
    (hi : i < n.toNat) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value tbl) (.value p) (.value n)).get)
    (hR : Regs p2 n E) (hRi : E ⊨ [%74 := BitVec.ofNat 64 i])
    (hto : tbl.offset.toNat + 192 * n.toNat < 2 ^ 64) (hwf : S.WF)
    (hM : S.mem = M.storeTable tbl i (split_odd_table.raw P2 P)) (hp2 : M.QuadFit p2)
    (hP2 : M.readQuad p2 = P2) (ht : M.TableRoom tbl n.toNat) (hp2t : p2.id ≠ tbl.id)
    (hexit :
      i + 1 = n.toNat →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value tbl) (.value p) (.value n)).get →
            Regs p2 n E' → (E' ⊨ [%80 := 0#64]) → S'.WF → S'.alloc = S.alloc →
            S'.mem = M.storeTable tbl (i + 1) (split_odd_table.raw P2 P) →
            (runD E' 3 S' >>= g) = K)
    (hback :
      i + 1 < n.toNat →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value tbl) (.value p) (.value n)).get →
            Regs p2 n E' → (E' ⊨ [%74 := BitVec.ofNat 64 (i + 1)]) → S'.WF → S'.alloc = S.alloc →
            S'.mem = M.storeTable tbl (i + 1) (split_odd_table.raw P2 P) →
            (runD E' 1 S' >>= g) = K) :
    (runD E 1 S >>= g) = K := by
  have hq : S.mem.QuadRoom (tbl.add (BitVec.ofNat 64 (192 * i))) := by
    rw [hM]; exact (ht i hi).storeTable
  have hp2' : S.mem.QuadFit p2 := by rw [hM]; exact hp2.storeTable
  have hprev : S.mem.QuadFit (tbl.add (BitVec.ofNat 64 (192 * (i - 1)))) := by
    rw [hM]
    exact Firedancer.Lane.Split.tableFit_storeTable (fun k hk => ht k (by omega)) (i - 1) (by omega)
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), Nat.mul_comm i 192]
  step_pure [off_prev (c := 18446744073709551424) rfl hi1 (show 192 * i < 2 ^ 64 by omega)]
  -- fd_ed25519_point_add( &tbl[i], p2, &tbl[i-1] )
  step_call using fd_ed25519_point_add_with_opts.call_eq
  step_pure [saddOverflow_one64 (show i + 1 < 2 ^ 63 by omega),
    uaddOverflow_one64 (show i + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure
  finish_block
  case isTrue =>
    have h1 := (ofNat_eq_setWidth_iff (by omega)).mp hbr
    refine hexit h1 E S hArgs (by env_reads) (by env_reads) hwf (by rw [hS]) ?_
    rw [hS, hM]
    exact add_state hP2 hp2t ht hto hi1 hi
  case isFalse =>
    have h1 : i + 1 < n.toNat :=
      Nat.lt_of_le_of_ne hi fun h => hbr ((ofNat_eq_setWidth_iff (by omega)).mpr h)
    refine hback h1 E S hArgs (by env_reads) (by env_reads) hwf (by rw [hS]) ?_
    rw [hS, hM]
    exact add_state hP2 hp2t ht hto hi1 hi

/-- `^bb1`'s loop from `i`: at `^bb3` the first `n` entries are `raw`. -/
theorem add_loop (tbl p p2 : Pointer) (n : BitVec 32) (P2 P : Quad) (M : MemoryState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hto : tbl.offset.toNat + 192 * n.toNat < 2 ^ 64) (hp2 : M.QuadFit p2)
    (hP2 : M.readQuad p2 = P2) (ht : M.TableRoom tbl n.toNat) (hp2t : p2.id ≠ tbl.id) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫), 1 ≤ i → i + m + 1 = n.toNat →
      E.args = (args (.value tbl) (.value p) (.value n)).get →
        Regs p2 n E → (E ⊨ [%74 := BitVec.ofNat 64 i]) → S.WF →
        S.mem = M.storeTable tbl i (split_odd_table.raw P2 P) →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value tbl) (.value p) (.value n)).get →
            Regs p2 n E' → (E' ⊨ [%80 := 0#64]) → S'.WF → S'.alloc = S.alloc →
            S'.mem = M.storeTable tbl n.toNat (split_odd_table.raw P2 P) →
            (runD E' 3 S' >>= g) = K) →
        (runD E 1 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro i S E hi1 hm hArgs hR hRi hwf hM hK
    refine add_iter tbl p p2 n P2 P M g K i hi1 (by omega) S E hArgs hR hRi hto hwf hM hp2 hP2 ht
      hp2t (fun h E' S' h1 h2 h3 h4 h5 h6 => hK E' S' h1 h2 h3 h4 h5 (h ▸ h6))
      fun h => absurd h (by omega)
  | succ m ih =>
    intro i S E hi1 hm hArgs hR hRi hwf hM hK
    refine add_iter tbl p p2 n P2 P M g K i hi1 (by omega) S E hArgs hR hRi hto hwf hM hp2 hP2 ht
      hp2t (fun h => absurd h (by omega)) fun _ E' S' h1 h2 h3 h4 h5 h6 =>
        ih (i + 1) S' E' (by omega) (by omega) h1 h2 h3 h4 h6 fun E'' S'' g1 g2 g3 g4 g5 g6 =>
          hK E'' S'' g1 g2 g3 g4 (g5.trans h5) g6

/-- The entries after the precomputation of the first `i`. -/
abbrev preTable (P2 P : Quad) (i : Nat) (k : Nat) : Quad :=
  if k < i then fd_curve25519_into_precomputed.spec (split_odd_table.raw P2 P k)
  else split_odd_table.raw P2 P k

/-- The entries after precomputing one more. -/
theorem preTable_succ {M : MemoryState} {tbl : Pointer} {P2 P : Quad} {n i : Nat}
    (hto : tbl.offset.toNat + 192 * n < 2 ^ 64) (hi : i < n) :
    (M.storeTable tbl n (preTable P2 P i)).storeQuad (tbl.add (BitVec.ofNat 64 (192 * i)))
        (fd_curve25519_into_precomputed.spec (split_odd_table.raw P2 P i)) =
      M.storeTable tbl n (preTable P2 P (i + 1)) := by
  rw [Firedancer.Lane.Split.storeTable_storeQuad (by omega) hi]
  congr 1
  funext k
  by_cases hk : k = i
  · subst hk
    simp [preTable]
  · rw [Function.update_of_ne hk]
    simp only [preTable]
    by_cases hki : k < i
    · simp [hki, show k < i + 1 by omega]
    · simp [hki, show ¬k < i + 1 by omega]

/-- `^bb3` at `i`: `tbl[i]` precomputed; then around, or on to `^bb2` at `i + 1 = n`. -/
theorem pre_iter (tbl p p2 : Pointer) (n : BitVec 32) (P2 P : Quad) (M : MemoryState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < n.toNat)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value tbl) (.value p) (.value n)).get)
    (hR : Regs p2 n E) (hRi : E ⊨ [%80 := BitVec.ofNat 64 i])
    (hto : tbl.offset.toNat + 192 * n.toNat < 2 ^ 64) (hwf : S.WF)
    (hM : S.mem = M.storeTable tbl n.toNat (preTable P2 P i)) (ht : M.TableRoom tbl n.toNat)
    (hexit :
      i + 1 = n.toNat →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value tbl) (.value p) (.value n)).get →
            Regs p2 n E' → S'.WF → S'.alloc = S.alloc →
            S'.mem = M.storeTable tbl n.toNat (preTable P2 P (i + 1)) →
            (runD E' 2 S' >>= g) = K)
    (hback :
      i + 1 < n.toNat →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value tbl) (.value p) (.value n)).get →
            Regs p2 n E' → (E' ⊨ [%80 := BitVec.ofNat 64 (i + 1)]) → S'.WF → S'.alloc = S.alloc →
            S'.mem = M.storeTable tbl n.toNat (preTable P2 P (i + 1)) →
            (runD E' 3 S' >>= g) = K) :
    (runD E 3 S >>= g) = K := by
  have hq : S.mem.QuadFit (tbl.add (BitVec.ofNat 64 (192 * i))) := by
    rw [hM]; exact Firedancer.Lane.Split.tableFit_storeTable ht i hi
  have hqr : S.mem.QuadRoom (tbl.add (BitVec.ofNat 64 (192 * i))) := by
    rw [hM]; exact (ht i hi).storeTable
  have hv : S.mem.readQuad (tbl.add (BitVec.ofNat 64 (192 * i))) = split_odd_table.raw P2 P i := by
    rw [hM]
    refine (Firedancer.Lane.Split.readTable_storeTable ht (by omega) hi).trans ?_
    simp [preTable]
  obtain ⟨Q, hQe⟩ : ∃ Q, tbl.add (BitVec.ofNat 64 (192 * i)) = Q := ⟨_, rfl⟩
  rw [hQe] at hq hqr hv
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), Nat.mul_comm i 192, hQe]
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, r->P ), only the lanes the subtraction reads
  step_pattern using runBodyFrom_permuteLoadRun_poison 1 0 2 3 1 0 0 0
  have eR : (⟨l03, l14, l25⟩ : Quad) = split_odd_table.raw P2 P i := _hx.symm.trans hv
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
  have e2 := _hl
  step_pattern using runBodyFrom_laneAddRun 0 1 0 0
  have e3 := _hl
  step_pattern using runBodyFrom_foldSignedRun
  have eF := (Quad.foldSigned_eq _).trans _hs
  step_pattern using runBodyFrom_halvesRun 0 1 2 3 inline
  step_pattern using runBodyFrom_quadMulCoreRun
  have e4 := Firedancer.Lane.Split.quadMul_of_core_id (Y := quad1112d) _hm
  step_pattern using runBodyFrom_foldUnsignedStoreRun'
  have eU := (Quad.foldUnsigned_eq _).trans _hu
  step_pure [saddOverflow_one64 (show i + 1 < 2 ^ 63 by omega),
    uaddOverflow_one64 (show i + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure
  finish_block
  all_goals
    have eT : fd_curve25519_into_precomputed.spec (split_odd_table.raw P2 P i) =
        ⟨u03, u14, u25⟩ := by
      rw [← eR]
      exact (Firedancer.Lane.Split.intoPre_of e2 e3 eF e4).trans eU
  case isTrue =>
    have h1 := (ofNat_eq_setWidth_iff (by omega)).mp hbr
    refine hexit h1 E S hArgs (by env_reads) hwf (by rw [hS]) ?_
    rw [hS, ← preTable_succ hto hi, ← hM, eT, hQe]
    rfl
  case isFalse =>
    have h1 : i + 1 < n.toNat :=
      Nat.lt_of_le_of_ne hi fun h => hbr ((ofNat_eq_setWidth_iff (by omega)).mpr h)
    refine hback h1 E S hArgs (by env_reads) (by env_reads) hwf (by rw [hS]) ?_
    rw [hS, ← preTable_succ hto hi, ← hM, eT, hQe]
    rfl

/-- `^bb3`'s loop from `i`: at `^bb2` every entry is precomputed. -/
theorem pre_loop (tbl p p2 : Pointer) (n : BitVec 32) (P2 P : Quad) (M : MemoryState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hto : tbl.offset.toNat + 192 * n.toNat < 2 ^ 64) (ht : M.TableRoom tbl n.toNat) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫), i + m + 1 = n.toNat →
      E.args = (args (.value tbl) (.value p) (.value n)).get →
        Regs p2 n E → (E ⊨ [%80 := BitVec.ofNat 64 i]) → S.WF →
        S.mem = M.storeTable tbl n.toNat (preTable P2 P i) →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value tbl) (.value p) (.value n)).get →
            Regs p2 n E' → S'.WF → S'.alloc = S.alloc →
            S'.mem = M.storeTable tbl n.toNat (preTable P2 P n.toNat) →
            (runD E' 2 S' >>= g) = K) →
        (runD E 3 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro i S E hm hArgs hR hRi hwf hM hK
    refine pre_iter tbl p p2 n P2 P M g K i (by omega) S E hArgs hR hRi hto hwf hM ht
      (fun h E' S' h1 h2 h3 h4 h5 => hK E' S' h1 h2 h3 h4 (h ▸ h5)) fun h => absurd h (by omega)
  | succ m ih =>
    intro i S E hm hArgs hR hRi hwf hM hK
    refine pre_iter tbl p p2 n P2 P M g K i (by omega) S E hArgs hR hRi hto hwf hM ht
      (fun h => absurd h (by omega)) fun _ E' S' h1 h2 h3 h4 h5 h6 =>
        ih (i + 1) S' E' (by omega) h1 h2 h3 h4 h6 fun E'' S'' g1 g2 g3 g4 g5 =>
          hK E'' S'' g1 g2 g3 (g4.trans h5) g5

end split_odd_table

/-- `split_odd_table` stores `spec` of the point at `p`, `n` entries, as a table at `tbl`. Its
frame is `p2`'s block. -/
public theorem split_odd_table.call_eq (tbl p : Pointer) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (ht : Room s.mem tbl (1536 * n.toNat))
    (hto : tbl.offset.toNat + 192 * n.toNat < 2 ^ 64) (hp : s.mem.QuadFit p) (hpt : p.id ≠ tbl.id)
    (hn : 2 ≤ n.toNat ∧ n.toNat < 2 ^ 31) :
    _root_.Firedancer.Lane.Mlir.split_odd_table.call
        (_root_.Firedancer.Lane.Mlir.split_odd_table.args (.value tbl) (.value p) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩
            mem := s.mem.storeTable tbl n.toNat (split_odd_table.spec (s.mem.readQuad p)) }) := by
  have ht0 := MemoryState.QuadRoom.entry ht hto (k := 0) (by omega)
  simp only [Nat.mul_zero, Pointer.add_zero_quad] at ht0
  func_init
  block_init
  iterate 32 step_pure
  iterate 4 step_pattern using runBodyFrom_insertRun inline
  -- fd_ed25519_point_t p2[1]
  step_alloca with p2
  step_pure
  have hp2q := MemoryState.QuadRoom.of_room hroom_p2 hp2_off
  have hL : ((S₀.alloca 192 true).mem.lifetimeStart p2).QuadRoom p2 := by
    rw [hS] at hp2q; exact hp2q
  have hLt : Room ((S₀.alloca 192 true).mem.lifetimeStart p2) tbl (1536 * n.toNat) := by
    rw [hS] at ht; exact ht
  -- fd_ed25519_point_set( &tbl[0], p )
  step_load with a03
  step_store
  step_pure
  step_load with a14
  step_pure
  step_store
  step_pure
  step_load with a25
  step_pure
  step_store
  -- fd_ed25519_point_dbln( p2, p, 1 )
  step_call using fd_ed25519_point_dbln.call_eq
  step_pure [split_odd_table.msb_of_lt hn.2]
  finish_block
  have eP : (⟨a03, a14, a25⟩ : Quad) = S₀.mem.readQuad p := by
    rw [ha03, ha14, ha25]
    rfl
  generalize hP : S₀.mem.readQuad p = P at eP hS
  generalize hP2 : fd_ed25519_point_dbln.spec P 1 = P2 at hS
  generalize hLe : (S₀.alloca 192 true).mem.lifetimeStart p2 = L at hL hLt hS
  have hMS : S.mem = (L.storeQuad p2 P2).storeTable tbl 1 (split_odd_table.raw P2 P) := by
    rw [hS, Firedancer.Lane.Split.storeTable_succ, Nat.mul_zero, Pointer.add_zero_quad]
    dsimp only
    rw [show (L.storeQuad p2 P2).storeTable tbl 0 (split_odd_table.raw P2 P) = L.storeQuad p2 P2
      from rfl, MemoryState.storeQuad_comm (Ne.symm htbl_ne_p2), ← eP]
    simp only [MemoryState.storeQuad, MemoryState.storeVec, split_odd_table.raw]
  have hM2 := MemoryState.QuadFit.storeQuad_self (P := P2) hL
  have hMv := MemoryState.readQuad_storeQuad_self (P := P2) hL
  have hMt := Firedancer.Lane.Split.tableRoom_of_room (Room.storeQuad (q := p2) (P := P2) hLt) hto
  have hA0 : S.alloc = (S₀.alloca 192 true).alloc := by rw [hS]
  have hN : S₀.alloc.nextFreeBlock ≤ p2.id.id := by slot_bound
  -- for( int i=1; i<n; i++ ) fd_ed25519_point_add( &tbl[i], p2, &tbl[i-1] )
  refine split_odd_table.add_loop tbl p p2 n P2 P _ _ _ hto hM2 hMv hMt (Ne.symm htbl_ne_p2)
    (n.toNat - 2) 1 S E le_rfl (by omega) hArgs (by env_reads) (by env_reads) hwf hMS
    fun E₁ S₁ h₁ h₂ h₃ h₄ ha₁ h₅ => ?_
  -- for( int i=0; i<n; i++ ) fd_curve25519_into_precomputed( &tbl[i] )
  refine split_odd_table.pre_loop tbl p p2 n P2 P _ _ _ hto hMt (n.toNat - 1) 0 S₁ E₁ (by omega)
    h₁ h₂ h₃ h₄ (h₅.trans (Firedancer.Lane.Split.storeTable_congr fun k hk => by
      simp [split_odd_table.preTable])) fun E₂ S₂ h₁' h₂' h₃' ha₂ h₄' => ?_
  -- the lifetime of `p2` ends
  block_init
  step_pure
  finish_block
  rw [hS]
  dsimp only
  rw [ha₂, ha₁, hA0, h₄', MemoryState.eraseFrom_lifetimeEnd_of_le hN,
    Firedancer.Lane.Split.eraseFrom_storeTable, MemoryState.eraseFrom_storeQuad_of_le hN, ← hLe,
    Firedancer.Lane.Split.storeTable_congr (g := split_odd_table.spec P) fun k hk => by
      simp [split_odd_table.preTable, hk, split_odd_table.spec, ← hP2]]
  erase_frame
  simp only [GlobalState.alloca]


end Proof

end MLIR.Firedancer.Lane
