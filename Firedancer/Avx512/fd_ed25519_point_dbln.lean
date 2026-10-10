module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Mlir.fd_ed25519_point_dbln

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `2ⁿ A`: `FD_R43X6_GE_DBL` once, then `n - 1` more times. -/
def fd_ed25519_point_dbln.spec (A : Quad) (n : Nat) : Quad :=
  Nat.repeat (geDbl quadMul quadSqr) (n - 1) (geDbl quadMul quadSqr A)

end

/-! ## Proof -/

section Proof

namespace fd_ed25519_point_dbln

/-- `j` more doublings of `P`, the loop's order. -/
def iter : Nat → Quad → Quad
  | 0, P => P
  | j + 1, P => iter j (geDbl quadMul quadSqr P)

theorem repeat_eq_iter (j : Nat) (P : Quad) :
    Nat.repeat (geDbl quadMul quadSqr) j P = iter j P := by
  induction j generalizing P with
  | zero => rfl
  | succ j ih =>
    rw [iter, ← ih, Nat.repeat]
    clear ih
    induction j with
    | zero => rfl
    | succ j ih => rw [Nat.repeat, ih, Nat.repeat]

/-- The registers of the entry block that the loop and its exit read: the constants, the six
temporaries, and the pointers to `r`'s second and third vectors. -/
abbrev LoopEnv (E : ⟪Γ⟫) (r z0 z1 z2 z3 z4 z5 : Pointer) : Prop :=
  E ⊨ [%3051 := .value 1#8, %3052 :=
    Ty.wrap
      #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64, 1099511627775#64,
        1099511627775#64, 1099511627775#64, 1099511627775#64],
    %3053 := Ty.wrap (Vector.replicate 8 1048576#64), %3054 :=
    Ty.wrap
      #v[159383552#64, 159383552#64, 159383552#64, 159383552#64, 1048576#64, 1048576#64, 1048576#64,
        1048576#64],
    %3055 := Ty.wrap (Vector.replicate 8 8796093022207#64), %3057 :=
    Ty.wrap #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64], %3058 :=
    Ty.wrap (Vector.replicate 8 43#64), %3059 :=
    Ty.wrap (Vector.replicate 8 18446744073708503040#64), %3060 :=
    Ty.wrap
      #v[18446744073550168064#64, 18446744073550168064#64, 18446744073550168064#64,
        18446744073550168064#64, 18446744073708503040#64, 18446744073708503040#64,
        18446744073708503040#64, 18446744073708503040#64],
    %3069 := Vector.replicate 8 PoisonOr.poison, %3070 :=
    Ty.wrap #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64], %3083 :=
    #v[.poison, .value 8796093022189#64, .value 8796093022189#64, .poison, .poison,
      .value 8796093022207#64, .value 8796093022207#64, .poison],
    %3091 :=
    #v[.poison, .value 8796093022207#64, .value 8796093022207#64, .poison, .poison,
      .value 8796093022207#64, .value 8796093022207#64, .poison],
    %3099 :=
    #v[.poison, .value 8796093022207#64, .value 8796093022207#64, .poison, .poison,
      .value 1099511627775#64, .value 1099511627775#64, .poison],
    %3107 :=
    #v[.value 8796093022189#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison],
    %3115 :=
    #v[.value 8796093022207#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison],
    %3123 :=
    #v[.value 8796093022207#64, .poison, .poison, .poison, .value 1099511627775#64, .poison,
      .poison, .poison],
    %3131 :=
    #v[.poison, .poison, .poison, .poison, .value 19#64, .value 19#64, .value 19#64, .value 19#64],
    %3138 := z0, %3139 := z1, %3140 := z2, %3141 := z3, %3142 := z4, %3143 := z5, %3232 :=
    r.add 64#64, %3235 := r.add 128#64]

/-- The lanes of a folded point are below `2^44`. -/
abbrev Folded (P : Quad) : Prop :=
  (∀ i : Fin 8, P.P03[i] < 17592186044416#64) ∧
    (∀ i : Fin 8, P.P14[i] < 17592186044416#64) ∧ ∀ i : Fin 8, P.P25[i] < 17592186044416#64

theorem add_lt_ok {x y : Wwl} (hx : ∀ i : Fin 8, x[i] < 17592186044416#64)
    (hy : ∀ i : Fin 8, y[i] < 17592186044416#64) : ∀ i : Fin 8, x[i].saddOverflow y[i] = false :=
  fun i => add_lane_ok (hx i) (hy i)

theorem storeVec_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeVec p v = m.eraseFrom n :=
  MemoryState.storeAt_eraseFrom_of_le h

/-- The loop's header `^bb3` holding `P` and the counter `k`. -/
abbrev hdr (E : ⟪Γ⟫) (P : Quad) (k : Nat) : ⟪Γ⟫ :=
  E[%3237 := Ty.wrap P.P25, %3238 := Ty.wrap P.P14, %3239 := Ty.wrap P.P03, %3240 :=
    .value (BitVec.ofNat 8 k)]

/-- One trip through `^bb3` on `P` at counter `k`: `geDbl P` into the registers, the temporaries
written; then back to the header if `k + 1 < n`, else to the exit. -/
theorem trip (r a : Pointer) (n : BitVec 32) (z0 z1 z2 z3 z4 z5 : Pointer) (b k : Nat) (P : Quad)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value a) (.value n)).get)
    (hR : LoopEnv E r z0 z1 z2 z3 z4 z5) (hP : Folded P) (hwf : S.WF) (hr : S.mem.QuadRoom r)
    (h0 : InBounds S.mem z0 512) (h1 : InBounds S.mem z1 512) (h2 : InBounds S.mem z2 512)
    (h3 : InBounds S.mem z3 512) (h4 : InBounds S.mem z4 512) (h5 : InBounds S.mem z5 512)
    (hb0 : b ≤ z0.id.id) (hb1 : b ≤ z1.id.id) (hb2 : b ≤ z2.id.id) (hb3 : b ≤ z3.id.id)
    (hb4 : b ≤ z4.id.id) (hb5 : b ≤ z5.id.id) (h01 : z0.id ≠ z1.id) (h02 : z0.id ≠ z2.id)
    (h12 : z1.id ≠ z2.id) (h34 : z3.id ≠ z4.id) (h35 : z3.id ≠ z5.id) (h45 : z4.id ≠ z5.id)
    (hrb : r.id.id < b)
    (hback :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a) (.value n)).get →
          LoopEnv E' r z0 z1 z2 z3 z4 z5 →
          S'.WF →
          S'.mem.QuadRoom r →
          InBounds S'.mem z0 512 →
          InBounds S'.mem z1 512 →
          InBounds S'.mem z2 512 →
          InBounds S'.mem z3 512 →
          InBounds S'.mem z4 512 →
          InBounds S'.mem z5 512 →
          S'.alloc = S.alloc →
          S'.mem.eraseFrom b = S.mem.eraseFrom b →
          Folded (geDbl quadMul quadSqr P) →
          ((BitVec.ofNat 8 k + 1#8).setWidth 32).ult n = true →
          (fd_ed25519_point_dbln.runFrom (hdr E' (geDbl quadMul quadSqr P) (k + 1)) 3 S' >>= g) = K)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a) (.value n)).get →
          (E' ⊨ [%3232 := r.add 64#64, %3235 := r.add 128#64, %3321 :=
            Ty.wrap (geDbl quadMul quadSqr P).P03, %3323 := Ty.wrap (geDbl quadMul quadSqr P).P14,
            %3325 := Ty.wrap (geDbl quadMul quadSqr P).P25]) →
          S'.WF →
          S'.mem.QuadRoom r →
          S'.alloc = S.alloc →
          S'.mem.eraseFrom b = S.mem.eraseFrom b →
          ¬((BitVec.ofNat 8 k + 1#8).setWidth 32).ult n = true →
          (fd_ed25519_point_dbln.runFrom E' 1 S' >>= g) = K) :
    (fd_ed25519_point_dbln.runFrom (hdr E P k) 3 S >>= g) = K := by
  block_init
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,1,2,0, r->P ); its lanes stay below `2^44`
  step_pattern using runBodyFrom_permuteRun 1 1 2 0
  have d1 := _hp
  have d1' := (Quad.permute_1120 _).symm.trans d1
  obtain ⟨hP03, hP14, hP25⟩ := hP
  have hk03 := add_lt_ok (wwl_perm4_lt_of_eq hP03 (congrArg Quad.P03 d1')) hP03
  have hk14 := add_lt_ok (wwl_perm4_lt_of_eq hP14 (congrArg Quad.P14 d1')) hP14
  have hk25 := add_lt_ok (wwl_perm4_lt_of_eq hP25 (congrArg Quad.P25 d1')) hP25
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 1,0,0,0, _ta, r->P ): the code's `nsw` holds
  step_pattern using runBodyFrom_laneAddRun' 1 0 0 0 (ho03 := fun _ => hk03) (ho14 := fun _ => hk14)
    (ho25 := fun _ => hk25)
  have d2 := _hl
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_dblMidRun
  have d3 := _hdbl
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta ), kept in registers
  step_pattern using runBodyFrom_foldUnsignedRun
  have d15 := _hu
  -- `i++`, `i<n`
  step_pure
  step_pure
  step_pure
  have hQ : geDbl quadMul quadSqr P = ⟨u03, u14, u25⟩ := by
    rw [geDbl_eq_mid, show P = ⟨P.P03, P.P14, P.P25⟩ from rfl, d1, d2, d3, Quad.foldUnsigned_eq,
      d15]
  finish_block
  · rw [hQ] at hback
    step_loop using hback
    · exact (BitVec.ofNat_add _ _).symm
    · simp only [MemoryState.eraseFrom_storeVec, MemoryState.eraseFrom_lifetimeStart,
        MemoryState.eraseFrom_lifetimeEnd, MemoryState.lifetimeStart_eraseFrom_of_le hb0,
        MemoryState.lifetimeStart_eraseFrom_of_le hb1,
        MemoryState.lifetimeStart_eraseFrom_of_le hb2,
        MemoryState.lifetimeStart_eraseFrom_of_le hb3,
        MemoryState.lifetimeStart_eraseFrom_of_le hb4,
        MemoryState.lifetimeStart_eraseFrom_of_le hb5, MemoryState.lifetimeEnd_eraseFrom_of_le hb0,
        MemoryState.lifetimeEnd_eraseFrom_of_le hb1, MemoryState.lifetimeEnd_eraseFrom_of_le hb2,
        MemoryState.lifetimeEnd_eraseFrom_of_le hb3, MemoryState.lifetimeEnd_eraseFrom_of_le hb4,
        MemoryState.lifetimeEnd_eraseFrom_of_le hb5, storeVec_eraseFrom_of_le hb0,
        storeVec_eraseFrom_of_le hb1, storeVec_eraseFrom_of_le hb2, storeVec_eraseFrom_of_le hb3,
        storeVec_eraseFrom_of_le hb4, storeVec_eraseFrom_of_le hb5]
    · exact Quad.foldUnsignedC_lt _hu
  · rw [hQ] at hexit
    step_loop using hexit
    simp only [MemoryState.eraseFrom_storeVec, MemoryState.eraseFrom_lifetimeStart,
      MemoryState.eraseFrom_lifetimeEnd, MemoryState.lifetimeStart_eraseFrom_of_le hb0,
      MemoryState.lifetimeStart_eraseFrom_of_le hb1, MemoryState.lifetimeStart_eraseFrom_of_le hb2,
      MemoryState.lifetimeStart_eraseFrom_of_le hb3, MemoryState.lifetimeStart_eraseFrom_of_le hb4,
      MemoryState.lifetimeStart_eraseFrom_of_le hb5, MemoryState.lifetimeEnd_eraseFrom_of_le hb0,
      MemoryState.lifetimeEnd_eraseFrom_of_le hb1, MemoryState.lifetimeEnd_eraseFrom_of_le hb2,
      MemoryState.lifetimeEnd_eraseFrom_of_le hb3, MemoryState.lifetimeEnd_eraseFrom_of_le hb4,
      MemoryState.lifetimeEnd_eraseFrom_of_le hb5, storeVec_eraseFrom_of_le hb0,
      storeVec_eraseFrom_of_le hb1, storeVec_eraseFrom_of_le hb2, storeVec_eraseFrom_of_le hb3,
      storeVec_eraseFrom_of_le hb4, storeVec_eraseFrom_of_le hb5]

/-- The loop from `^bb3` at counter `k` with `P` in the registers and `m + 1` trips left: at the
exit the registers hold `iter (m + 1) P`; only the temporaries are written. -/
theorem loop (r a : Pointer) (n : BitVec 32) (z0 z1 z2 z3 z4 z5 : Pointer) (b : Nat)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m k (P : Quad) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value a) (.value n)).get →
        LoopEnv E r z0 z1 z2 z3 z4 z5 →
        k + m + 1 = n.toNat →
        n.toNat ≤ 255 →
        Folded P →
        S.WF →
        S.mem.QuadRoom r →
        InBounds S.mem z0 512 →
        InBounds S.mem z1 512 →
        InBounds S.mem z2 512 →
        InBounds S.mem z3 512 →
        InBounds S.mem z4 512 →
        InBounds S.mem z5 512 →
        b ≤ z0.id.id →
        b ≤ z1.id.id →
        b ≤ z2.id.id →
        b ≤ z3.id.id →
        b ≤ z4.id.id →
        b ≤ z5.id.id →
        z0.id ≠ z1.id →
        z0.id ≠ z2.id →
        z1.id ≠ z2.id →
        z3.id ≠ z4.id →
        z3.id ≠ z5.id →
        z4.id ≠ z5.id →
        r.id.id < b →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value a) (.value n)).get →
            (E' ⊨ [%3232 := r.add 64#64, %3235 := r.add 128#64, %3321 :=
              Ty.wrap (iter (m + 1) P).P03, %3323 := Ty.wrap (iter (m + 1) P).P14, %3325 :=
              Ty.wrap (iter (m + 1) P).P25]) →
            S'.WF →
            S'.mem.QuadRoom r →
            S'.alloc = S.alloc →
            S'.mem.eraseFrom b = S.mem.eraseFrom b →
            (fd_ed25519_point_dbln.runFrom E' 1 S' >>= g) = K) →
        (fd_ed25519_point_dbln.runFrom (hdr E P k) 3 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro k P S E hArgs hR hk hn hP hwf hr h0 h1 h2 h3 h4 h5 hb0 hb1 hb2 hb3 hb4 hb5 h01 h02 h12 h34
      h35 h45 hrb hK
    refine
      trip r a n z0 z1 z2 z3 z4 z5 b k P S E g K hArgs hR hP hwf hr h0 h1 h2 h3 h4 h5 hb0 hb1 hb2
        hb3 hb4 hb5 h01 h02 h12 h34 h35 h45 hrb ?_ ?_
    · -- around again: impossible, the counter has reached `n`
      intro _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ hbr
      have : (BitVec.setWidth 32 (BitVec.ofNat 8 k + 1#8)).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth, BitVec.toNat_add]
        omega
      simp [BitVec.ult, this] at hbr
      omega
    · intro E' S' h1 h2 h3 h4 h5 h6 _
      exact hK E' S' h1 h2 h3 h4 h5 h6
  | succ m
    ih =>
    intro k P S E hArgs hR hk hn hP hwf hr h0 h1 h2 h3 h4 h5 hb0 hb1 hb2 hb3 hb4 hb5 h01 h02 h12 h34
      h35 h45 hrb hK
    refine
      trip r a n z0 z1 z2 z3 z4 z5 b k P S E g K hArgs hR hP hwf hr h0 h1 h2 h3 h4 h5 hb0 hb1 hb2
        hb3 hb4 hb5 h01 h02 h12 h34 h35 h45 hrb ?_ ?_
    · -- around again, one trip fewer
      intro E' S' g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 ha hm hF _
      exact
        ih (k + 1) _ S' E' g1 g2 (by omega) hn hF g3 g4 g5 g6 g7 g8 g9 g10 hb0 hb1 hb2 hb3 hb4 hb5
          h01 h02 h12 h34 h35 h45 hrb
          (fun E'' S'' f1 f2 f3 f4 f5 f6 => hK E'' S'' f1 f2 f3 f4 (f5.trans ha) (f6.trans hm))
    · -- leaving: impossible, the counter is below `n`
      intro _ _ _ _ _ _ _ _ hbr
      have : (BitVec.setWidth 32 (BitVec.ofNat 8 k + 1#8)).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth, BitVec.toNat_add]
        omega
      simp [BitVec.ult, this] at hbr
      omega

end fd_ed25519_point_dbln

-- the first doubling inline: about 150 instructions
set_option maxHeartbeats 400000 in
/-- `fd_ed25519_point_dbln` stores `spec` of the point at `a` (its `2ⁿ` multiple) at `r` and returns
`r`, for `n ≤ 255`; `r` may be `a`. Its twelve temporaries use up twelve block ids. -/
public theorem fd_ed25519_point_dbln.call_eq (r a : Pointer) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) (hn : n.toNat ≤ 255) :
    fd_ed25519_point_dbln.call (fd_ed25519_point_dbln.args (.value r) (.value a) (.value n)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 12⟩,
            mem :=
              s.mem.storeQuad r (fd_ed25519_point_dbln.spec (s.mem.readQuad a) n.toNat) }) := by
  func_init
  have hra : S.mem.readQuad a = S₀.mem.readQuad a := by rw [hS]
  block_init
  iterate 25 step_pure
  iterate 7 step_pattern using runBodyFrom_insertRun
  iterate 12 step_alloca
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,1,2,0, a->P )
  step_pattern using runBodyFrom_permuteLoadRun 1 1 2 0
  have d0 := hra ▸ _hx
  have d1 := _hp
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 1,0,0,0, _ta, a->P )
  step_pattern using runBodyFrom_laneAddRun' 1 0 0 0
  have d2 := _hl
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_dblMidRun
  have d3 := _hdbl
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have d15 := _hu
  step_pure
  have hA : geDbl quadMul quadSqr (S₀.mem.readQuad a) = ⟨u03, u14, u25⟩ := by
    rw [geDbl_eq_mid, d0, d1, d2, d3, Quad.foldUnsigned_eq, d15]
  finish_block
  · -- `n > 1`: the loop, `n - 1` trips
    have hn2 : 2 ≤ n.toNat := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    step_loop using
      fd_ed25519_point_dbln.loop r a n v87 v88 v89 v90 v91 v92 S₀.alloc.nextFreeBlock _ _
        (n.toNat - 2) 1 ⟨u03, u14, u25⟩
    · exact Quad.foldUnsignedC_lt _hu
    · intro hR' hwf' hr' hal hm
      block_init
      step_store
      step_store
      step_store
      finish_block
      block_init
      finish_block
      have hiter :
        fd_ed25519_point_dbln.iter (n.toNat - 2 + 1) ⟨u03, u14, u25⟩ =
          fd_ed25519_point_dbln.spec (S₀.mem.readQuad a) n.toNat := by
        rw [fd_ed25519_point_dbln.spec, fd_ed25519_point_dbln.repeat_eq_iter, hA,
          show n.toNat - 1 = n.toNat - 2 + 1 by omega]
      have hro := hr'.1
      subst hS
      simp only [hiter, MemoryState.eraseFrom_storeAt]
      rw [hm, hal]
      subst_vars
      erase_frame
      rw [MemoryState.storeAt_quad_twice hro]
      rfl
  · -- `n ≤ 1`: no trip
    have hn1 : n.toNat - 1 = 0 := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    block_init
    finish_block
    subst hS
    erase_frame
    rw [fd_ed25519_point_dbln.spec, hn1, Nat.repeat, hA]
    subst_vars
    rfl

end Proof

end MLIR.Firedancer.Avx512
