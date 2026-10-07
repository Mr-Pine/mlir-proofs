module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_ed25519_partial_dbl
public import Firedancer.Ref.fd_ed25519_point_add_final_mul
public import Firedancer.Ref.fd_ed25519_point_add_final_mul_projective
public import Firedancer.Ref.Mlir.fd_ed25519_point_dbln

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- One iteration on `t`: `r` gets `t`'s projective final multiplication, then `t` its partial
doubling. `partial_dbl` reads no `T`, so `r`'s old `T` (here `0`) does not matter. -/
def fd_ed25519_point_dbln.step (t : PointLimbs) : PointLimbs :=
  fd_ed25519_partial_dbl.spec (fd_ed25519_point_add_final_mul_projective.spec t 0)

/-- `t` after `j` more steps. -/
def fd_ed25519_point_dbln.iter : Nat → PointLimbs → PointLimbs
  | 0, t => t
  | j + 1, t => fd_ed25519_point_dbln.iter j (fd_ed25519_point_dbln.step t)

/-- `2ⁿ P`: `n - 1` loop steps after the first partial doubling, then the last multiplication. -/
def fd_ed25519_point_dbln.spec (P : PointLimbs) (n : Nat) : PointLimbs :=
  fd_ed25519_point_add_final_mul.spec
    (fd_ed25519_point_dbln.iter (n - 1) (fd_ed25519_partial_dbl.spec P))

end

/-! ## Proof -/

section Proof

namespace fd_ed25519_point_dbln

/-- The loop from `^bb2` at counter `k`, with `t` at `tp` and `m + 1` iterations left: at the exit
`r` holds the last iteration's projective multiplication and `tp` holds `iter (m + 1) t`. -/
theorem loop (r a tp : Pointer) (n : BitVec 32) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    ∀ m k (t : PointLimbs) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value a) (.value n)).get →
        (E ⊨ [%1 := 1#8, %2 := tp, %6 := BitVec.ofNat 8 k]) →
        k + m + 1 = n.toNat →
        1 ≤ k →
        n.toNat ≤ 255 →
        S.WF →
        S.mem.PointFit r →
        S.mem.PointFit tp →
        r.id ≠ tp.id →
        S.mem.readPoint tp = t →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value a) (.value n)).get →
            (E' ⊨ [%2 := tp]) →
            S' =
              { alloc := ⟨S.alloc.nextFreeBlock + 5 * (m + 1)⟩,
                mem :=
                  (S.mem.storePoint r
                        (fd_ed25519_point_add_final_mul_projective.spec (iter m t)
                          (S.mem.readLimbs (r.add 80#64)))).storePoint
                    tp (iter (m + 1) t) } →
            (fd_ed25519_point_dbln.runFrom E' ^bb1 S' >>= g) = K) →
        (fd_ed25519_point_dbln.runFrom E ^bb2 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro k t S E hArgs hR hk hk1 hn hwf hr htp hsep ht hK
    block_init
    step_call using fd_ed25519_point_add_final_mul_projective.call_eq
    step_call using fd_ed25519_partial_dbl.call_eq
    step_pure
    step_pure
    step_pure
    finish_block
    · -- back to the header: impossible, the counter has reached `n`
      exfalso
      have : (BitVec.ofNat 8 k + 1#8).setWidth 32 = n := by
        apply BitVec.eq_of_toNat_eq
        simp [BitVec.toNat_setWidth]
        omega
      simp [this, BitVec.ult] at hbr
    · step_loop using hK
      rfl
  | succ m ih =>
    intro k t S E hArgs hR hk hk1 hn hwf hr htp hsep ht hK
    have htpo := htp.1
    block_init
    step_call using fd_ed25519_point_add_final_mul_projective.call_eq
    step_call using fd_ed25519_partial_dbl.call_eq
    step_pure
    step_pure
    step_pure
    finish_block
    · -- around again, one iteration fewer
      refine
        ih (k + 1) (step t) S E hArgs ?_ (by omega) (by omega) hn hwf hr htp hsep ?_
          (fun E' S' h1 h2 h3 => hK E' S' h1 h2 (h3.trans ?_))
      · refine ⟨?_, ?_, ?_⟩ <;> env_reads
        rw [BitVec.ofNat_add]
      · rw [hread_tp]
        rfl
      · have hr₀ := hr
        rw [hS] at hr₀
        replace hr₀ := hr₀.of_storePoint.of_storePoint
        rw [hS]
        simp only [GlobalState.mk.injEq, AllocState.mk.injEq]
        refine ⟨by omega, ?_⟩
        have htr : tp.id ≠ r.id := Ne.symm hsep
        rw [MemoryState.readLimbs_storePoint_of_id_ne (by simpa [Pointer.add_id] using htr),
          MemoryState.readLimbs_storePoint_T hr₀, MemoryState.storePoint_comm htr,
          MemoryState.storePoint_storePoint_self hr₀.1, MemoryState.storePoint_storePoint_self htpo]
        rfl
    · -- leaving: impossible, the counter is below `n`
      have : ((BitVec.ofNat 8 k + 1#8).setWidth 32).toNat = k + 1 := by
        simp [BitVec.toNat_setWidth]
        omega
      simp [BitVec.ult, this] at hbr
      omega

end fd_ed25519_point_dbln

/-- `fd_ed25519_point_dbln` stores `spec` of the point at `a` (its `2ⁿ` multiple) at `r` and returns
`r`, for `1 ≤ n ≤ 255`; `r` may be `a`. The block counter advances by `1 + 5 n`. -/
public theorem fd_ed25519_point_dbln.call_eq (r a : Pointer) (n : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.PointFit r) (ha : s.mem.PointFit a) (hn1 : 1 ≤ n.toNat)
    (hn : n.toNat ≤ 255) :
    fd_ed25519_point_dbln.call (fd_ed25519_point_dbln.args (.value r) (.value a) (.value n)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1 + 5 * n.toNat⟩,
            mem :=
              s.mem.storePoint r (fd_ed25519_point_dbln.spec (s.mem.readPoint a) n.toNat) }) := by
  func_init
  block_init
  iterate 2 step_pure
  step_alloca with tp
  have htp := MemoryState.PointFit.of_fits htp_fits htp_off
  clear htp_fits
  step_pure
  step_call using fd_ed25519_partial_dbl.call_eq
  step_pure
  finish_block
  · -- `n > 1`: the loop, `n - 1` iterations
    have hn2 : 2 ≤ n.toNat := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    refine
      fd_ed25519_point_dbln.loop r a tp n _ _ (n.toNat - 2) 1 _ S E hArgs ?_ (by omega) le_rfl hn
        hwf hr htp hr_ne_tp hread_tp ?_
    · env_reads
    · intro E' S' h1 h2 h3
      block_init
      step_call using fd_ed25519_point_add_final_mul.call_eq
      step_pure
      finish_block
      have hro := hr.1
      have hm : n.toNat - 2 + 1 = n.toNat - 1 := by omega
      subst_vars
      erase_frame
      rw [MemoryState.storePoint_storePoint_self hro]
      simp only [GlobalState.alloca, fd_ed25519_point_dbln.spec, hm]
      rw [show
          S₀.alloc.nextFreeBlock + 1 + 5 + 5 * (n.toNat - 1) =
            S₀.alloc.nextFreeBlock + 1 + 5 * n.toNat
          by omega]
  · -- `n = 1`: no iteration
    have hn1' : n.toNat = 1 := by
      simp [BitVec.slt, BitVec.toInt_eq_toNat_of_lt (show 2 * n.toNat < 2 ^ 32 by omega)] at hbr
      omega
    block_init
    step_call using fd_ed25519_point_add_final_mul.call_eq
    step_pure
    finish_block
    subst_vars
    erase_frame
    simp only [GlobalState.alloca, fd_ed25519_point_dbln.spec, hn1']
    rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref
