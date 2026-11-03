module

public import MLIR.Run.Tactic
public import Firedancer.Common.Verify
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Ed25519.Common.Wl
public import Firedancer.Ref.fd_curve25519_scalar_reduce
public import Firedancer.Math.Scalar
public import Firedancer.Crc.Ed25519.Avx512.fd_curve25519_scalar_validate
public import Firedancer.Crc.Ed25519.Avx512.Decode2.Main
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_ge_is_small_order_affine
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_ge_eq_z1
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_neg
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_double_scalar_mul_base
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_ed25519_crc_verify_core

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

@[expose] public section

/-- The byte `shufflevector` taking lanes 0 and 3 of `x` (stored, read back as bytes) and lanes 1
and 2 of `y` (`bitcast` to bytes). -/
theorem shuf_0330 (x y : Wl) (u : Vector (BitVec 8) 32) (hu : u = wlBytes y) :
    (#v[Ty.extractVecElem 32 8 0 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 1 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 2 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 3 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 4 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 5 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 6 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 7 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), u[8], u[9], u[10], u[11], u[12], u[13], u[14], u[15], u[16], u[17], u[18], u[19], u[20], u[21], u[22], u[23], Ty.extractVecElem 32 8 24 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 25 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 26 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 27 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 28 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 29 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 30 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)), Ty.extractVecElem 32 8 31 ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32))] : Vector (BitVec 8) 32) =
      wlBytes (wlBlend true false false true x y) := by
  subst hu
  have hx := fd_r52x5_ge_decode2.ofFn_extractVecElem_packLanes x
  have hx' (k : Fin 32) : Ty.extractVecElem 32 8 k
      ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)) = (wlBytes x)[k] := by
    rw [← hx]; simp
  simp only [show ∀ k : Nat, (hk : k < 32) → Ty.extractVecElem 32 8 (⟨k, hk⟩ : Fin 32)
      ((BitVec.packLanes (we := 64) (n := 4) x :) : BitVec (8 * 32)) = (wlBytes x)[k] from
    fun k hk => hx' ⟨k, hk⟩]
  ext k hk : 1
  obtain h | h | h | h : k / 8 = 0 ∨ k / 8 = 1 ∨ k / 8 = 2 ∨ k / 8 = 3 := by omega
  all_goals
    obtain hm | hm | hm | hm | hm | hm | hm | hm : k % 8 = 0 ∨ k % 8 = 1 ∨ k % 8 = 2 ∨ k % 8 = 3 ∨
      k % 8 = 4 ∨ k % 8 = 5 ∨ k % 8 = 6 ∨ k % 8 = 7 := by omega
  all_goals
    have hk' : k = 8 * (k / 8) + k % 8 := by omega
    rw [h, hm] at hk'
    subst hk'
    simp only [wlBytes, wlBlend, Vector.getElem_ofFn, Vector.getElem_mk, List.getElem_toArray]
    rfl

/-- Five `wl_t`s stored as bytes at a point's offsets, lane-blended `1 0 0 1` from `X` and `Y`. -/
theorem storeAt_laneIf_1001 {m : MemoryState} {p : Pointer} (X Y : Quad5) :
    (((((m.storeAt p (BitVec.packLanes (wlBytes (wlBlend true false false true X.P0 Y.P0)))).storeAt
      (p.add 32#64) (BitVec.packLanes (wlBytes (wlBlend true false false true X.P1 Y.P1)))).storeAt
      (p.add 64#64) (BitVec.packLanes (wlBytes (wlBlend true false false true X.P2 Y.P2)))).storeAt
      (p.add 96#64) (BitVec.packLanes (wlBytes (wlBlend true false false true X.P3 Y.P3)))).storeAt
      (p.add 128#64) (BitVec.packLanes (wlBytes (wlBlend true false false true X.P4 Y.P4)))) =
      m.storeQuad5 p (Quad5.laneIf 1 0 0 1 X Y) := by
  simp only [MemoryState.storeAt_packLanes_wlBytes]
  rfl

/-- `reduce`'s scalar is below `2^253`. -/
theorem reduce_lt (x : BitVec 512) : (Ref.fd_curve25519_scalar_reduce.spec x).toNat < 2 ^ 253 := by
  rw [Ref.fd_curve25519_scalar_reduce.spec_val]
  have := Nat.mod_lt x.toNat (show 0 < Ed25519.ell by unfold Ed25519.ell; decide)
  have := Ed25519.ell_lt
  omega

/-- A scalar `validate` accepts is below `2^253`. -/
theorem validate_lt {s : BitVec 256} (h : Ref.fd_curve25519_scalar_validate.spec s = true) :
    s.toNat < 2 ^ 253 := by
  have := (Ref.fd_curve25519_scalar_validate.spec_iff s).1 h
  have := Ed25519.ell_lt
  omega

theorem GlobalState.WF.add_blocks_storeQuad5 {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeQuad5 p Q⟩ : GlobalState).WF :=
  GlobalState.WF.storeQuad5_mk h.add_blocks

theorem GlobalState.WF.add_blocks3 {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + a + b + c⟩, s.mem⟩ : GlobalState).WF := by
  have := h.add_blocks (k := a + b + c)
  simpa only [Nat.add_assoc] using this

namespace fd_r52x5_ge_decode2

theorem storeOut_none {m : MemoryState} : storeOut m a b (r, none) = m := rfl

theorem storeOut_some {m : MemoryState} :
    storeOut m a b (r, some (PA, PB)) = (m.storeQuad5 a PA).storeQuad5 b PB := rfl

theorem Fits.storeOut {m : MemoryState} (h : Fits m p w) : Fits (storeOut m a b R) p w := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · exact h
  · exact h.storeQuad5.storeQuad5

theorem InBounds.storeOut {m : MemoryState} (h : InBounds m p w) :
    InBounds (storeOut m a b R) p w := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · exact h
  · exact h.storeQuad5.storeQuad5

theorem Room.storeOut {m : MemoryState} (h : Room m p w) : Room (storeOut m a b R) p w := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · exact h
  · exact h.storeQuad5.storeQuad5

theorem Writable.storeOut {m : MemoryState} (h : Writable m p) : Writable (storeOut m a b R) p := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · exact h
  · exact h.storeQuad5.storeQuad5

theorem Quad5Fit.storeOut {m : MemoryState} (h : m.Quad5Fit p) : (storeOut m a b R).Quad5Fit p := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · exact h
  · exact h.storeQuad5.storeQuad5

theorem Quad5Room.storeOut {m : MemoryState} (h : m.Quad5Room p) :
    (storeOut m a b R).Quad5Room p := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · exact h
  · exact h.storeQuad5.storeQuad5

theorem Words8Room.storeOut {m : MemoryState} (h : m.Words8Room p) :
    (storeOut m a b R).Words8Room p :=
  ⟨h.1, Room.storeOut h.2.1, Room.storeOut h.2.2.1, Room.storeOut h.2.2.2.1,
    Room.storeOut h.2.2.2.2.1, Room.storeOut h.2.2.2.2.2.1, Room.storeOut h.2.2.2.2.2.2.1,
    Room.storeOut h.2.2.2.2.2.2.2.1, Room.storeOut h.2.2.2.2.2.2.2.2⟩

theorem WF.storeOut_mk {al : AllocState} {m : MemoryState} (h : (⟨al, m⟩ : GlobalState).WF) :
    (⟨al, storeOut m a b R⟩ : GlobalState).WF := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · exact h
  · exact (GlobalState.WF.storeQuad5_mk h).storeQuad5_mk

theorem globals_storeOut {m : MemoryState} : (storeOut m a b R).globals = m.globals := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩ <;> rfl

theorem Globals.storeOut {m : MemoryState} (h : m.Globals G) : (storeOut m a b R).Globals G :=
  h.mono globals_storeOut fun _ h => h

theorem readAt_storeOut_of_id_ne {m : MemoryState} (ha : a.id ≠ q.id) (hb : b.id ≠ q.id) :
    (storeOut m a b R).readAt q w = m.readAt q w := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · rfl
  · exact (MemoryState.readAt_storeQuad5_of_id_ne hb).trans
      (MemoryState.readAt_storeQuad5_of_id_ne ha)

theorem readQuad5_storeOut_of_id_ne {m : MemoryState} (ha : a.id ≠ q.id) (hb : b.id ≠ q.id) :
    (storeOut m a b R).readQuad5 q = m.readQuad5 q := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · rfl
  · exact (MemoryState.readQuad5_storeQuad5_of_id_ne hb).trans
      (MemoryState.readQuad5_storeQuad5_of_id_ne ha)

theorem eraseFrom_storeOut_of_le {m : MemoryState} (ha : n ≤ a.id.id) (hb : n ≤ b.id.id) :
    (storeOut m a b R).eraseFrom n = m.eraseFrom n := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · rfl
  · rw [storeOut_some, MemoryState.eraseFrom_storeQuad5_of_le hb,
      MemoryState.eraseFrom_storeQuad5_of_le ha]

theorem tail_some {sa sb : BitVec 256} {x y vx2 u nu : Quad5} {r : BitVec 32} {P : Quad5 × Quad5}
    (h : tail sa sb x y vx2 u nu = (r, some P)) : r = 3 := by
  unfold tail at h
  dsimp only at h
  split at h
  · simp at h
  · split at h
    · simp at h
    · simp only [Prod.mk.injEq] at h
      exact h.1.symm

theorem tail_none {sa sb : BitVec 256} {x y vx2 u nu : Quad5} {r : BitVec 32}
    (h : tail sa sb x y vx2 u nu = (r, none)) : r &&& 1#32 = 0#32 ∨ r.ult 2#32 = true := by
  have h0 := (laneCheck_01 vx2 u nu 0).2
  unfold tail at h
  dsimp only at h
  split at h
  · simp only [Prod.mk.injEq, and_true] at h
    subst h
    rcases h0 with h0 | h0 <;> rw [h0] <;> decide
  · split at h
    · simp only [Prod.mk.injEq, and_true] at h
      subst h
      decide
    · simp at h

theorem spec_some {sa sb : BitVec 256} {r : BitVec 32} {P : Quad5 × Quad5}
    (h : spec sa sb = (r, some P)) : r = 3 :=
  tail_some h

theorem spec_none {sa sb : BitVec 256} {r : BitVec 32} (h : spec sa sb = (r, none)) :
    r &&& 1#32 = 0#32 ∨ r.ult 2#32 = true :=
  tail_none h

end fd_r52x5_ge_decode2

namespace fd_r52x5_double_scalar_mul_base

/-- `TableAt` only depends on the table's block. -/
public theorem TableAt.of_getElem?_eq {M M' : MemoryState} {p : Pointer} (he : M'[p.id]? = M[p.id]?)
    (h : TableAt M p n T) : TableAt M' p n T := by
  intro k hk
  obtain ⟨h1, h2⟩ := h k hk
  have he' (o : BitVec 64) : M'[(p.add o).id]? = M[(p.add o).id]? := he
  have hr (q : Pointer) (hq : q.id = p.id) (w : Nat) : M'.readAt q w = M.readAt q w := by
    unfold MemoryState.readAt
    rw [hq, he]
  refine ⟨⟨h1.1, h1.2.1.of_getElem?_eq (he' 0), h1.2.2.1.of_getElem?_eq (he' 0),
    h1.2.2.2.1.of_getElem?_eq (he' 0), h1.2.2.2.2.1.of_getElem?_eq (he' 0),
    h1.2.2.2.2.2.of_getElem?_eq (he' 0)⟩, ?_⟩
  rw [← h2]
  simp only [MemoryState.readQuad5, MemoryState.readWv]
  rw [hr (p.add _) rfl, hr ((p.add _).add _) rfl, hr ((p.add _).add 64#64) rfl,
    hr ((p.add _).add 96#64) rfl, hr ((p.add _).add 128#64) rfl]

theorem TableAt.inBounds {M : MemoryState} {p : Pointer} (h : TableAt M p 128 T) :
    InBounds M p 256 := by
  have := (h 0 (by decide)).1.2.1
  simpa using this.inBounds

public theorem TableAt.storeAt {M : MemoryState} {p q : Pointer} {x : BitVec w} (h : TableAt M p n T)
    (hne : p.id ≠ q.id) : TableAt (M.storeAt q x) p n T :=
  h.of_getElem?_eq (MemoryState.getElem?_storeAt_ne hne)

theorem TableAt.storeWv {M : MemoryState} {p q : Pointer} (h : TableAt M p n T)
    (hne : p.id ≠ q.id) : TableAt (M.storeWv q v) p n T :=
  h.storeAt hne

theorem TableAt.storeTmp5 {M : MemoryState} {p : Pointer} (h : TableAt M p n T)
    (h0 : p.id ≠ t0.id) (h1 : p.id ≠ t1.id) (h2 : p.id ≠ t2.id) (h3 : p.id ≠ t3.id)
    (h4 : p.id ≠ t4.id) : TableAt (M.storeTmp5 t0 t1 t2 t3 t4 Q) p n T :=
  ((((h.storeWv h0).storeWv h1).storeWv h2).storeWv h3).storeWv h4

theorem TableAt.storeQuad5 {M : MemoryState} {p q : Pointer} (h : TableAt M p n T)
    (hne : p.id ≠ q.id) : TableAt (M.storeQuad5 q Q) p n T :=
  h.storeTmp5 hne hne hne hne hne

theorem TableAt.storeOut {M : MemoryState} {p : Pointer} (h : TableAt M p n T)
    (ha : p.id ≠ a.id) (hb : p.id ≠ b.id) :
    TableAt (fd_r52x5_ge_decode2.storeOut M a b R) p n T := by
  rcases R with ⟨_, _ | ⟨_, _⟩⟩
  · exact h
  · exact (h.storeQuad5 ha).storeQuad5 hb

theorem TableAt.lifetimeStart {M : MemoryState} {p q : Pointer} (h : TableAt M p n T)
    (hne : p.id ≠ q.id) : TableAt (M.lifetimeStart q) p n T :=
  h.of_getElem?_eq (MemoryState.getElem?_setLifetime_ne hne)

theorem TableAt.lifetimeEnd {M : MemoryState} {p q : Pointer} (h : TableAt M p n T)
    (hne : p.id ≠ q.id) : TableAt (M.lifetimeEnd q) p n T :=
  h.of_getElem?_eq (MemoryState.getElem?_setLifetime_ne hne)

theorem TableAt.alloca {s : GlobalState} {p : Pointer} (hwf : s.WF) (h : TableAt s.mem p 128 T) :
    TableAt (s.alloca k d).mem p 128 T :=
  h.of_getElem?_eq (GlobalState.getElem?_alloca
    (GlobalState.ne_allocaPtr_of_inBounds hwf h.inBounds))

theorem TableAt.storeWords8 {M : MemoryState} {p q : Pointer} (h : TableAt M p n T)
    (hne : p.id ≠ q.id) : TableAt (M.storeWords8 q v) p n T := by
  have hne' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa [Pointer.add_id] using hne
  unfold MemoryState.storeWords8
  exact (((((((h.storeAt hne).storeAt (hne' _)).storeAt (hne' _)).storeAt (hne' _)).storeAt
    (hne' _)).storeAt (hne' _)).storeAt (hne' _)).storeAt (hne' _)

theorem TableAt.storeSha {M : MemoryState} {p q : Pointer} (h : TableAt M p n T)
    (hne : p.id ≠ q.id) : TableAt (M.storeSha q X) p n T := by
  have hne' (o : BitVec 64) : p.id ≠ (q.add o).id := by simpa [Pointer.add_id] using hne
  unfold MemoryState.storeSha
  exact ((((h.storeAt hne).storeAt (hne' _)).storeAt (hne' _)).storeAt (hne' _)).storeWords8
    (hne' _)

theorem TableAt.hashMem {M : MemoryState} {p : Pointer} (h : TableAt M p n T)
    (hsha : p.id ≠ sha.id) (hk : p.id ≠ k.id) :
    TableAt (fd_ed25519_verify.hashMem M sha k X v) p n T := by
  have hne' (o : BitVec 64) : p.id ≠ (sha.add o).id := by simpa [Pointer.add_id] using hsha
  unfold fd_ed25519_verify.hashMem fd_sha512_init.stores
  exact ((((((((((h.storeAt (hne' _)).storeAt (hne' _)).storeAt (hne' _)).storeAt
    (hne' _)).storeAt (hne' _)).storeAt (hne' _)).storeAt (hne' _)).storeAt (hne' _)).storeAt
    (hne' _)).storeSha hsha).storeWords8 hk

end fd_r52x5_double_scalar_mul_base

end

end MLIR.Firedancer.Crc.Ed25519.Avx512
