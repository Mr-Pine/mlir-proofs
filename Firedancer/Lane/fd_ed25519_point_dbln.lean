module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_point_dbln
public import Firedancer.Lane.Common.R43x6Point
public import Firedancer.Lane.Mlir.fd_ed25519_point_dbln

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_shl_wrap

namespace fd_ed25519_point_dbln

open _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln

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

/-- The registers of the entry block that the loop and its exit read: the constants and the
pointers to `r`'s second and third vectors. -/
abbrev LoopEnv (E : ⟪Γ⟫) (r : Pointer) : Prop :=
  E ⊨ [%0 := .value 1#8, %1 :=
    Ty.wrap
      #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64, 1099511627775#64,
        1099511627775#64, 1099511627775#64, 1099511627775#64],
    %2 := Ty.wrap (Vector.replicate 8 1048576#64), %3 :=
    Ty.wrap
      #v[159383552#64, 159383552#64, 159383552#64, 159383552#64, 1048576#64, 1048576#64, 1048576#64,
        1048576#64],
    %4 := Ty.wrap (Vector.replicate 8 8796093022207#64), %6 :=
    Ty.wrap #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64], %7 :=
    Ty.wrap (Vector.replicate 8 43#64), %8 := Ty.wrap (Vector.replicate 8 18446744073708503040#64),
    %9 :=
    Ty.wrap
      #v[18446744073550168064#64, 18446744073550168064#64, 18446744073550168064#64,
        18446744073550168064#64, 18446744073708503040#64, 18446744073708503040#64,
        18446744073708503040#64, 18446744073708503040#64],
    %13 := Ty.wrap #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64], %14 :=
    Ty.wrap (Vector.replicate 8 24#64), %15 := Ty.wrap (Vector.replicate 8 7#64), %16 :=
    Ty.wrap (Vector.replicate 8 9#64), %17 := Ty.wrap (Vector.replicate 8 0#64), %18 :=
    Ty.wrap (Vector.replicate 8 1#64), %26 := Vector.replicate 8 PoisonOr.poison, %38 := zeroLo,
    %46 := zeroHi, %54 :=
    #v[.poison, .value 8796093022189#64, .value 8796093022189#64, .poison, .poison,
      .value 8796093022207#64, .value 8796093022207#64, .poison],
    %62 :=
    #v[.poison, .value 8796093022207#64, .value 8796093022207#64, .poison, .poison,
      .value 8796093022207#64, .value 8796093022207#64, .poison],
    %70 :=
    #v[.poison, .value 8796093022207#64, .value 8796093022207#64, .poison, .poison,
      .value 1099511627775#64, .value 1099511627775#64, .poison],
    %78 :=
    #v[.value 8796093022189#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison],
    %86 :=
    #v[.value 8796093022207#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison],
    %94 :=
    #v[.value 8796093022207#64, .poison, .poison, .poison, .value 1099511627775#64, .poison,
      .poison, .poison],
    %102 :=
    #v[.poison, .poison, .poison, .poison, .value 19#64, .value 19#64, .value 19#64, .value 19#64],
    rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 338 := r.add 64#64,
    rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 341 := r.add 128#64]

/-- The lanes of a folded point are below `2^44`. -/
abbrev Folded (P : Quad) : Prop :=
  (∀ i : Fin 8, P.P03[i] < 17592186044416#64) ∧
    (∀ i : Fin 8, P.P14[i] < 17592186044416#64) ∧ ∀ i : Fin 8, P.P25[i] < 17592186044416#64

theorem add_lt_ok {x y : Wwl} (hx : ∀ i : Fin 8, x[i] < 17592186044416#64)
    (hy : ∀ i : Fin 8, y[i] < 17592186044416#64) : ∀ i : Fin 8, x[i].saddOverflow y[i] = false :=
  fun i => add_lane_ok (hx i) (hy i)

/-- The loop's header `^bb3` holding `P` and the counter `k`. -/
abbrev hdr (E : ⟪Γ⟫) (P : Quad) (k : Nat) : ⟪Γ⟫ :=
  E[rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 343 := Ty.wrap P.P25,
    rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 344 := Ty.wrap P.P14,
    rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 345 := Ty.wrap P.P03,
    rir_dst% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 346 := .value (BitVec.ofNat 8 k)]

/-- One trip through `^bb3` on `P` at counter `k`: `geDbl P` into the registers; then back to the
header if `k + 1 < n`, else to the exit. -/
theorem trip (r a : Pointer) (n : BitVec 32) (k : Nat) (P : Quad) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value a) (.value n)).get) (hR : LoopEnv E r)
    (hP : Folded P)
    (hback :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a) (.value n)).get →
          LoopEnv E' r →
          Folded (geDbl quadMul quadSqr P) →
          ((BitVec.ofNat 8 k + 1#8).setWidth 32).ult n = true →
          (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.runFrom
                (hdr E' (geDbl quadMul quadSqr P) (k + 1)) 3 S >>=
              g) =
            K)
    (hexit :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a) (.value n)).get →
          (E' ⊨ [rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 338 := r.add 64#64,
            rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 341 := r.add 128#64,
            rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 574 :=
            Ty.wrap (geDbl quadMul quadSqr P).P03,
            rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 576 :=
            Ty.wrap (geDbl quadMul quadSqr P).P14,
            rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 578 :=
            Ty.wrap (geDbl quadMul quadSqr P).P25]) →
          ¬((BitVec.ofNat 8 k + 1#8).setWidth 32).ult n = true →
          (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.runFrom E' 1 S >>= g) = K) :
    (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.runFrom (hdr E P k) 3 S >>= g) = K := by
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
  -- its limbs 1 and 4 below `2^45`: the squaring's `nsw` doubling holds
  have hs14 : ∀ k : Fin 8, (s14[k] <<< 1).sshiftRight 1 = s14[k] := by
    have h :=
      laneAddFast_1000_shl1 (T := ⟨p03, p14, p25⟩) (X := ⟨P.P03, P.P14, P.P25⟩)
        (wwl_perm4_lt_of_eq hP14 (congrArg Quad.P14 d1')) hP14
    rw [d2] at h
    exact h
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  quad_dbl_mid using hs14
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta ), kept in registers
  step_pattern using runBodyFrom_foldUnsignedRun
  have d3 := _hu
  -- `i++`, `i<n`
  step_pure
  step_pure
  step_pure
  have hQ : geDbl quadMul quadSqr P = ⟨u03, u14, u25⟩ := by
    rw [geDbl_eq_mid, show P = ⟨P.P03, P.P14, P.P25⟩ from rfl, d1, d2, hD, Quad.foldUnsigned_eq, d3]
  finish_block
  · rw [hQ] at hback
    step_loop using hback
    · exact (BitVec.ofNat_add _ _).symm
    · exact Quad.foldUnsignedC_lt d3
  · rw [hQ] at hexit
    step_loop using hexit

/-- The loop from `^bb3` at counter `k` with `P` in the registers and `m + 1` trips left: at the
exit the registers hold `iter (m + 1) P`. -/
theorem loop (r a : Pointer) (n : BitVec 32) (S : GlobalState)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ m k (P : Quad) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value a) (.value n)).get →
        LoopEnv E r →
        k + m + 1 = n.toNat →
        n.toNat ≤ 255 →
        Folded P →
        (∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a) (.value n)).get →
            (E' ⊨ [rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 338 :=
              r.add 64#64, rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 341 :=
              r.add 128#64, rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 574 :=
              Ty.wrap (iter (m + 1) P).P03,
              rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 576 :=
              Ty.wrap (iter (m + 1) P).P14,
              rir_reg% _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.hty 578 :=
              Ty.wrap (iter (m + 1) P).P25]) →
            (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.runFrom E' 1 S >>= g) = K) →
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.runFrom (hdr E P k) 3 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro k P E hArgs hR hk hn hP hK
    refine trip r a n k P S E g K hArgs hR hP ?_ ?_
    · -- around again: impossible, the counter has reached `n`
      intro _ _ _ _ hbr
      have : (BitVec.setWidth 32 (BitVec.ofNat 8 k + 1#8)).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth, BitVec.toNat_add]
        omega
      simp [BitVec.ult, this] at hbr
      omega
    · intro E' h1 h2 _
      exact hK E' h1 h2
  | succ m ih =>
    intro k P E hArgs hR hk hn hP hK
    refine trip r a n k P S E g K hArgs hR hP ?_ ?_
    · -- around again, one trip fewer
      intro E' g1 g2 hF _
      exact ih (k + 1) _ E' g1 g2 (by omega) hn hF hK
    · -- leaving: impossible, the counter is below `n`
      intro _ _ _ hbr
      have : (BitVec.setWidth 32 (BitVec.ofNat 8 k + 1#8)).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth, BitVec.toNat_add]
        omega
      simp [BitVec.ult, this] at hbr
      omega

end fd_ed25519_point_dbln

/-- `fd_ed25519_point_dbln` stores `spec` of the point at `a` (its `2ⁿ` multiple) at `r` and returns
`r`, for `n ≤ 255`; `r` may be `a`. -/
public theorem fd_ed25519_point_dbln.call_eq (r a : Pointer) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) (hn : n.toNat ≤ 255) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.args (.value r) (.value a) (.value n))
        s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeQuad r (fd_ed25519_point_dbln.spec (s.mem.readQuad a) n.toNat) }) := by
  func_init
  have hra : S.mem.readQuad a = S₀.mem.readQuad a := by rw [hS]
  block_init
  iterate 31 step_pure
  iterate 9 step_pattern using runBodyFrom_insertRun
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,1,2,0, a->P )
  step_pattern using runBodyFrom_permuteLoadRun 1 1 2 0
  have d0 := hra ▸ _hx
  have d1 := _hp
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 1,0,0,0, _ta, a->P )
  step_pattern using runBodyFrom_laneAddRun' 1 0 0 0
  have d2 := _hl
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  quad_dbl_mid
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have d3 := _hu
  step_pure
  have hA : geDbl quadMul quadSqr (S₀.mem.readQuad a) = ⟨u03, u14, u25⟩ := by
    rw [geDbl_eq_mid, d0, d1, d2, hD, Quad.foldUnsigned_eq, d3]
  finish_block
  · -- `n > 1`: the loop, `n - 1` trips
    have hn2 : 2 ≤ n.toNat := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    step_loop using fd_ed25519_point_dbln.loop r a n S _ _ (n.toNat - 2) 1 ⟨u03, u14, u25⟩
    · exact Quad.foldUnsignedC_lt d3
    · intro hR'
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
      have hro := hr.1
      subst hS hv341
      rw [← hiter, MemoryState.storeAt_quad_twice hro]
      rfl
  · -- `n ≤ 1`: no trip
    have hn1 : n.toNat - 1 = 0 := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    block_init
    finish_block
    subst hS
    rw [fd_ed25519_point_dbln.spec, hn1, Nat.repeat, hA]
    subst_vars
    rfl

end Proof

end MLIR.Firedancer.Lane
