module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.Crc.Verify.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Verify.QuadRuns
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_ge_dbln

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_ge_dbln( r, a )`: `2³³ A`, `fd_r52x5_quad_ge_dbl` 33 times. -/
def fd_r52x5_ge_dbln.spec (A : Quad5) : Quad5 :=
  Nat.repeat fd_r52x5_quad_ge_dbl.spec 33 A

end

/-! ## Proof -/

section Proof

namespace fd_r52x5_ge_dbln

/-- A point stored by its five `<4 x i64>` stores, as the steps leave them. -/
theorem storeQuad5_mk {m : MemoryState} {P : Pointer} {x0 x1 x2 x3 x4 : Wl} :
    ((((m.storeAt P (BitVec.packLanes x0)).storeAt (P.add 32#64) (BitVec.packLanes x1)).storeAt
              (P.add 64#64) (BitVec.packLanes x2)).storeAt
          (P.add 96#64) (BitVec.packLanes x3)).storeAt
        (P.add 128#64) (BitVec.packLanes x4) =
      m.storeQuad5 P ⟨x0, x1, x2, x3, x4⟩ :=
  rfl

/-- `j` more doublings of `P`, the loop's order. -/
def iter : Nat → Quad5 → Quad5
  | 0, P => P
  | j + 1, P => iter j (fd_r52x5_quad_ge_dbl.spec P)

theorem repeat_eq_iter (j : Nat) (P : Quad5) :
    Nat.repeat fd_r52x5_quad_ge_dbl.spec j P = iter j P := by
  induction j generalizing P with
  | zero => rfl
  | succ j ih =>
    rw [iter, ← ih, Nat.repeat]
    clear ih
    induction j with
    | zero => rfl
    | succ j ih => rw [Nat.repeat, ih, Nat.repeat]

/-- The entry block's registers the loop reads: the constants and the five temporaries. -/
abbrev LoopEnv (E : ⟪Γ⟫) (z0 z1 z2 z3 z4 : Pointer) : Prop :=
  E ⊨ [%3519 := 1#32, %3521 := 33#32, %3522 := z0, %3523 := z1, %3524 := z2, %3525 := z3,
    %3526 := z4]

/-- The loop's header `^bb2` holding `P` and the counter `k`. -/
abbrev hdr (E : ⟪Γ⟫) (P : Quad5) (k : Nat) : ⟪Γ⟫ :=
  E[%3540 := .value (BitVec.ofNat 32 k), %3541 := Ty.wrap P.P4, %3542 := Ty.wrap P.P3,
    %3543 := Ty.wrap P.P2, %3544 := Ty.wrap P.P1, %3545 := Ty.wrap P.P0]

/-- The loop's facts about a state: well-formed, room for the point `r`, the temporaries in
bounds and writable (dead between their uses). -/
abbrev Inv (S : GlobalState) (r z0 z1 z2 z3 z4 : Pointer) : Prop :=
  S.WF ∧ S.mem.Quad5Room r ∧ InBounds S.mem z0 256 ∧ InBounds S.mem z1 256 ∧
    InBounds S.mem z2 256 ∧ InBounds S.mem z3 256 ∧ InBounds S.mem z4 256 ∧ Writable S.mem z0 ∧
    Writable S.mem z1 ∧ Writable S.mem z2 ∧ Writable S.mem z3 ∧ Writable S.mem z4

/-- The temporaries: five distinct blocks from block `b` on, `r`'s below `b`. -/
abbrev Slots (b : Nat) (r z0 z1 z2 z3 z4 : Pointer) : Prop :=
  (z1.id ≠ z0.id ∧ z2.id ≠ z0.id ∧ z3.id ≠ z0.id ∧ z4.id ≠ z0.id ∧ z2.id ≠ z1.id ∧
      z3.id ≠ z1.id ∧ z4.id ≠ z1.id ∧ z3.id ≠ z2.id ∧ z4.id ≠ z2.id ∧ z4.id ≠ z3.id) ∧
    b ≤ z0.id.id ∧ b ≤ z1.id.id ∧ b ≤ z2.id.id ∧ b ≤ z3.id.id ∧ b ≤ z4.id.id ∧ r.id.id < b

/-- One trip through `^bb2` on `P` at counter `k`: `fd_r52x5_quad_ge_dbl P` into the registers,
the temporaries written, 80 blocks used; then back to the header if `k + 1 < 33`, else to the
exit. -/
theorem trip (r a : Pointer) (z0 z1 z2 z3 z4 : Pointer) (b k : Nat)
    (P : Quad5) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (B : GlobalState)
    (hz : z0 = B.slot 0 ∧ z1 = B.slot 1 ∧ z2 = B.slot 2 ∧ z3 = B.slot 3 ∧ z4 = B.slot 4)
    (hArgs : E.args = (args (.value r) (.value a)).get)
    (hR : LoopEnv E z0 z1 z2 z3 z4) (hI : Inv S r z0 z1 z2 z3 z4)
    (hZ : Slots b r z0 z1 z2 z3 z4) (hk : k < 33)
    (hback :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a)).get →
          LoopEnv E' z0 z1 z2 z3 z4 →
          Inv S' r z0 z1 z2 z3 z4 →
          S'.alloc = ⟨S.alloc.nextFreeBlock + 80⟩ →
          S'.mem.eraseFrom b = S.mem.eraseFrom b →
          k + 1 < 33 →
          (fd_r52x5_ge_dbln.runFrom (hdr E' (fd_r52x5_quad_ge_dbl.spec P) (k + 1)) 2 S' >>= g) = K)
    (hexit :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value a)).get →
          (E' ⊨ [%3546 := (fd_r52x5_quad_ge_dbl.spec P).P0, %3547 := (fd_r52x5_quad_ge_dbl.spec P).P1,
            %3548 := (fd_r52x5_quad_ge_dbl.spec P).P2, %3549 := (fd_r52x5_quad_ge_dbl.spec P).P3,
            %3550 := (fd_r52x5_quad_ge_dbl.spec P).P4]) →
          S'.WF →
          S'.mem.Quad5Room r →
          S'.alloc = ⟨S.alloc.nextFreeBlock + 80⟩ →
          S'.mem.eraseFrom b = S.mem.eraseFrom b →
          k + 1 = 33 →
          (fd_r52x5_ge_dbln.runFrom E' 1 S' >>= g) = K) :
    (fd_r52x5_ge_dbln.runFrom (hdr E P k) 2 S >>= g) = K := by
  obtain ⟨hwf, hr, h0, h1, h2, h3, h4, w0, w1, w2, w3, w4⟩ := hI
  obtain ⟨⟨n10, n20, n30, n40, n21, n31, n41, n32, n42, n43⟩, hb0, hb1, hb2, hb3, hb4, hrb⟩ := hZ
  have hr0 : r.id ≠ z0.id := fun e => by have := congrArg BlockId.id e; omega
  have hr1 : r.id ≠ z1.id := fun e => by have := congrArg BlockId.id e; omega
  have hr2 : r.id ≠ z2.id := fun e => by have := congrArg BlockId.id e; omega
  have hr3 : r.id ≠ z3.id := fun e => by have := congrArg BlockId.id e; omega
  have hr4 : r.id ≠ z4.id := fun e => by have := congrArg BlockId.id e; omega
  have hadd : (BitVec.ofNat 32 k).saddOverflow 1#32 = false ∧
      (BitVec.ofNat 32 k).uaddOverflow 1#32 = false := by
    simp only [BitVec.saddOverflow, BitVec.uaddOverflow, BitVec.toInt, BitVec.toNat_ofNat]
    constructor <;> simp <;> omega
  obtain ⟨rfl, rfl, rfl, rfl, rfl⟩ := hz
  have hF : SlotFrame B 5 S.mem := fun j hj =>
    match j, hj with
    | 0, _ => ⟨h0, w0⟩
    | 1, _ => ⟨h1, w1⟩
    | 2, _ => ⟨h2, w2⟩
    | 3, _ => ⟨h3, w3⟩
    | 4, _ => ⟨h4, w4⟩
  clear h0 h1 h2 h3 h4 w0 w1 w2 w3 w4
  block_init
  step_pattern' using runBodyFrom_leafRun1A (hf := fd_r52x5_quad_ge_dbl.call_eq) inline
  subst hQ
  have ⟨h0, w0⟩ := hF 0 (by decide)
  have ⟨h1, w1⟩ := hF 1 (by decide)
  have ⟨h2, w2⟩ := hF 2 (by decide)
  have ⟨h3, w3⟩ := hF 3 (by decide)
  have ⟨h4, w4⟩ := hF 4 (by decide)
  clear hF
  step_pure [hadd]
  step_pure
  finish_block
  · subst hS hE
    refine hexit _ _ hArgs (by lemma_reads) hwf hr rfl
      (MemoryState.eraseFrom_callTmp5_of_le hb0 hb1 hb2 hb3 hb4) ?_
    have := congrArg BitVec.toNat hbr
    simp [BitVec.toNat_add] at this
    omega
  · have : (BitVec.ofNat 32 k + 1#32).toNat = k + 1 := by simp [BitVec.toNat_add]; omega
    have h33 : k + 1 < 33 := by
      have h33 : k + 1 ≠ 33 := fun e => hbr (BitVec.eq_of_toNat_eq (by rw [this]; simpa using e))
      omega
    have hb' := fun E' hA hL => hback E' S hA hL ⟨hwf, hr, h0, h1, h2, h3, h4, w0, w1, w2, w3, w4⟩
      (by rw [hS]) (by rw [hS]; exact MemoryState.eraseFrom_callTmp5_of_le hb0 hb1 hb2 hb3 hb4) h33
    clear hback hwf hr h0 h1 h2 h3 h4 w0 w1 w2 w3 w4 this
    run_from using hb'
    exact (BitVec.ofNat_add _ _).symm

/-- The loop from `^bb2` at counter `k` with `P` in the registers and `m + 1` trips left: at the
exit the registers hold `iter (m + 1) P`; `80 (m + 1)` blocks used, only the temporaries
written. -/
theorem loop (r a : Pointer) (z0 z1 z2 z3 z4 : Pointer) (b : Nat)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β) (B : GlobalState)
    (hz : z0 = B.slot 0 ∧ z1 = B.slot 1 ∧ z2 = B.slot 2 ∧ z3 = B.slot 3 ∧ z4 = B.slot 4)
    (hZ : Slots b r z0 z1 z2 z3 z4) :
    ∀ m k (P : Quad5) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value a)).get →
        LoopEnv E z0 z1 z2 z3 z4 →
        k + m + 1 = 33 →
        Inv S r z0 z1 z2 z3 z4 →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value a)).get →
            (E' ⊨ [%3546 := (iter (m + 1) P).P0, %3547 := (iter (m + 1) P).P1,
              %3548 := (iter (m + 1) P).P2, %3549 := (iter (m + 1) P).P3,
              %3550 := (iter (m + 1) P).P4]) →
            S'.WF →
            S'.mem.Quad5Room r →
            S'.alloc = ⟨S.alloc.nextFreeBlock + 80 * (m + 1)⟩ →
            S'.mem.eraseFrom b = S.mem.eraseFrom b →
            (fd_r52x5_ge_dbln.runFrom E' 1 S' >>= g) = K) →
        (fd_r52x5_ge_dbln.runFrom (hdr E P k) 2 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro k P S E hArgs hR hk hI hK
    refine trip r a z0 z1 z2 z3 z4 b k P S E g K B hz hArgs hR hI hZ (by omega) ?_ ?_
    · intro _ _ _ _ _ _ _ hlt
      omega
    · intro E' S' h1 h2 h3 h4 h5 h6 _
      exact hK E' S' h1 h2 h3 h4 h5 h6
  | succ m ih =>
    intro k P S E hArgs hR hk hI hK
    refine trip r a z0 z1 z2 z3 z4 b k P S E g K B hz hArgs hR hI hZ (by omega) ?_ ?_
    · intro E' S' g1 g2 g3 ha hm _
      refine ih (k + 1) _ S' E' g1 g2 (by omega) g3 fun E'' S'' f1 f2 f3 f4 f5 f6 => ?_
      refine hK E'' S'' f1 f2 f3 f4 ?_ (f6.trans hm)
      rw [f5, ha, AllocState.mk.injEq]
      dsimp only
      omega
    · intro _ _ _ _ _ _ _ _ he
      omega

end fd_r52x5_ge_dbln

/-- `fd_r52x5_ge_dbln( r, a )` stores `spec` of the point at `a` at `r`; its five temporaries and
the doublings' use up `5 + 80 · 33` block ids. -/
public theorem fd_r52x5_ge_dbln.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Quad5Room r) (ha : s.mem.Quad5Fit a) :
    fd_r52x5_ge_dbln.call (fd_r52x5_ge_dbln.args (.value r) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + (5 + 80 * 33)⟩,
            mem := s.mem.storeQuad5 r (fd_r52x5_ge_dbln.spec (s.mem.readQuad5 a)) }) := by
  generalize hres : fd_r52x5_ge_dbln.spec (s.mem.readQuad5 a) = res
  func_init
  have hro := hr.1
  have hrb : r.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt (hS ▸ hr.2.1 : Room S₀.mem r 256).mem
  block_init
  iterate 3 step_pure
  iterate 5 step_alloca
  have hlta := hwf₀.lt ha₀.inBounds.mem
  step_pattern' using runBodyFrom_quad5LoadRun inline
  have eqa : Q = S₀.mem.readQuad5 a := by
    rw [hQ, hS]
    simp (disch := (try simp only [GlobalState.alloca_alloc]); omega) only
      [MemoryState.readQuad5_alloca_lt]
  subst eqa
  clear hlta hQ ha
  finish_block
  rw [fd_r52x5_ge_dbln.spec, fd_r52x5_ge_dbln.repeat_eq_iter] at hres
  subst hv3 hv4 hv5 hv6 hv7
  have hZ : fd_r52x5_ge_dbln.Slots S₀.alloc.nextFreeBlock r (S₀.slot 0) (S₀.slot 1) (S₀.slot 2)
      (S₀.slot 3) (S₀.slot 4) := by
    refine ⟨slot_ids_ne (by decide), ?_, ?_, ?_, ?_, ?_, hrb⟩ <;>
      simp only [GlobalState.slot_id_id] <;> omega
  have hI : fd_r52x5_ge_dbln.Inv S r (S₀.slot 0) (S₀.slot 1) (S₀.slot 2) (S₀.slot 3) (S₀.slot 4) :=
    ⟨hwf, hr, hv3_bounds, hv4_bounds, hv5_bounds, hv6_bounds, hv7_bounds, hwritable_v3,
      hwritable_v4, hwritable_v5, hwritable_v6, hwritable_v7⟩
  run_from using fd_r52x5_ge_dbln.loop r a _ _ _ _ _ S₀.alloc.nextFreeBlock _ _ S₀
    ⟨rfl, rfl, rfl, rfl, rfl⟩ hZ 32 0
    (S₀.mem.readQuad5 a)
  · intro _ _ _ hal hm
    block_init
    clear hI hwf hr hZ hwritable_v3 hwritable_v4 hwritable_v5 hwritable_v6 hwritable_v7 hv3_bounds
      hv4_bounds hv5_bounds hv6_bounds hv7_bounds hr₀ hr₀_1 hr₀_2 hr₀_3 hr₀_4 ha₀ ha₀_1 ha₀_2 ha₀_3
      ha₀_4
    step_store
    iterate 4 (step_pure; step_store)
    finish_block
    subst hS
    dsimp only at hal ⊢
    rw [fd_r52x5_ge_dbln.storeQuad5_mk, MemoryState.eraseFrom_storeQuad5, hm, hal]
    subst S
    erase_frame
    rw [← hres]
    congr 3

end Proof

end MLIR.Firedancer.Crc.Verify
