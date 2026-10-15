module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadMem
public import Firedancer.Avx512.fd_ed25519_point_add_with_opts
public import Firedancer.Avx512.fd_ed25519_point_dbln
public import Firedancer.Avx512.fd_curve25519_into_precomputed
public import Firedancer.Lane.Common.R43x6Point
public import Firedancer.Common.Memory
public import Firedancer.Avx512.fd_ed25519_double_scalar_mul_base

/-! Tables of points in memory, as the split tables of `fd_ed25519_double_scalar_mul_base_split`
hold them: points stored 192 bytes apart, their reads, fits and frames; and the tables' specs. -/

namespace MLIR

open Firedancer Firedancer.Avx512

@[expose] public section

/-! ### Stores of a table -/

/-- `f 0, …, f (n - 1)` stored at `p`, 192 bytes apart, in that order. -/
def MemoryState.storeTable (m : MemoryState) (p : Pointer) : Nat → (Nat → Quad) → MemoryState
  | 0, _ => m
  | n + 1, f => (m.storeTable p n f).storeQuad (p.add (BitVec.ofNat 64 (192 * n))) (f n)

/-- Segments `0 … j-1` of `a` entries each stored from `p`, segment `i` holding `f i`. -/
def MemoryState.storeSegs (m : MemoryState) (p : Pointer) (a : Nat) (f : Nat → Nat → Quad) :
    Nat → MemoryState
  | 0 => m
  | j + 1 => (m.storeSegs p a f j).storeTable (p.add (BitVec.ofNat 64 (192 * (a * j)))) a (f j)

/-- Entry `k` of the table at `p`. -/
def MemoryState.readTable (m : MemoryState) (p : Pointer) (k : Nat) : Quad :=
  m.readQuad (p.add (BitVec.ofNat 64 (192 * k)))

/-- Each of the `n` entries of the table at `p` fits. -/
abbrev MemoryState.TableFit (m : MemoryState) (p : Pointer) (n : Nat) : Prop :=
  ∀ k < n, m.QuadFit (p.add (BitVec.ofNat 64 (192 * k)))

/-- Room for each of the `n` entries of a table at `p`. -/
abbrev MemoryState.TableRoom (m : MemoryState) (p : Pointer) (n : Nat) : Prop :=
  ∀ k < n, m.QuadRoom (p.add (BitVec.ofNat 64 (192 * k)))

namespace Firedancer.Lane.Split

theorem storeTable_succ {m : MemoryState} {p : Pointer} {n : Nat} {f : Nat → Quad} :
    m.storeTable p (n + 1) f =
      (m.storeTable p n f).storeQuad (p.add (BitVec.ofNat 64 (192 * n))) (f n) :=
  rfl

/-- Points at byte offsets `a`, `b` from `p`, apart: their stores commute. -/
theorem storeQuad_storeQuad_apart {m : MemoryState} {p : Pointer} {a b : Nat}
    (ha : p.offset.toNat + a + 192 ≤ 2 ^ 64) (hb : p.offset.toNat + b + 192 ≤ 2 ^ 64)
    (hab : a + 192 ≤ b ∨ b + 192 ≤ a) :
    (m.storeQuad (p.add (BitVec.ofNat 64 a)) P).storeQuad (p.add (BitVec.ofNat 64 b)) Q =
      (m.storeQuad (p.add (BitVec.ofNat 64 b)) Q).storeQuad (p.add (BitVec.ofNat 64 a)) P := by
  have hd (c d : Nat) (hc : c ≤ 128) (hd : d ≤ 128) :
      (Range.of (p.add (BitVec.ofNat 64 (a + c))) 512).Disjoint
        (Range.of (p.add (BitVec.ofNat 64 (b + d))) 512) :=
    Range.disjoint_add (by omega) (by omega) (by omega)
  have h00 := hd 0 0 (by omega) (by omega)
  have h01 := hd 0 64 (by omega) (by omega)
  have h02 := hd 0 128 (by omega) (by omega)
  have h10 := hd 64 0 (by omega) (by omega)
  have h20 := hd 128 0 (by omega) (by omega)
  simp only [Nat.add_zero] at h00 h01 h02 h10 h20
  simp only [MemoryState.storeQuad, MemoryState.storeVec, add_ofNat_add]
  rw [MemoryState.storeAt_swap h20, MemoryState.storeAt_swap (hd 128 64 (by omega) (by omega)),
    MemoryState.storeAt_swap (hd 128 128 (by omega) (by omega)), MemoryState.storeAt_swap h10,
    MemoryState.storeAt_swap (hd 64 64 (by omega) (by omega)),
    MemoryState.storeAt_swap (hd 64 128 (by omega) (by omega)), MemoryState.storeAt_swap h00,
    MemoryState.storeAt_swap h01, MemoryState.storeAt_swap h02]

/-- A table equal on its `n` entries: the same stores. -/
theorem storeTable_congr {m : MemoryState} {p : Pointer} {f g : Nat → Quad} :
    ∀ {n : Nat}, (∀ k < n, f k = g k) → m.storeTable p n f = m.storeTable p n g
  | 0, _ => rfl
  | n + 1, h => by
    rw [storeTable_succ, storeTable_succ, storeTable_congr fun k hk => h k (by omega),
      h n (by omega)]

/-- A byte offset that does not wrap. -/
theorem offset_add_ofNat {p : Pointer} {a : Nat} (h : p.offset.toNat + a < 2 ^ 64) :
    (p.add (BitVec.ofNat 64 a)).offset.toNat = p.offset.toNat + a := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt h]

/-- An entry stored over a table: the table with it replaced. -/
theorem storeTable_storeQuad {m : MemoryState} {p : Pointer} {f : Nat → Quad} {X : Quad} :
    ∀ {n k : Nat}, p.offset.toNat + 192 * n ≤ 2 ^ 64 → k < n →
      (m.storeTable p n f).storeQuad (p.add (BitVec.ofNat 64 (192 * k))) X =
        m.storeTable p n (Function.update f k X)
  | 0, _, _, hk => absurd hk (by omega)
  | n + 1, k, hp, hk => by
    rw [storeTable_succ, storeTable_succ]
    rcases Nat.lt_or_ge k n with hkn | hkn
    · rw [storeQuad_storeQuad_apart (by omega) (by omega) (by omega),
        storeTable_storeQuad (by omega) hkn, Function.update_of_ne (by omega)]
    · obtain rfl : k = n := by omega
      rw [MemoryState.storeQuad_storeQuad_self (by rw [offset_add_ofNat (by omega)]; omega),
        Function.update_self]
      congr 1
      exact storeTable_congr fun j hj => (Function.update_of_ne (by omega) _ _).symm

/-- A table after another, right behind it: one table. -/
theorem storeTable_append {m : MemoryState} {p : Pointer} {f g : Nat → Quad} {a : Nat} :
    ∀ {b : Nat},
      (m.storeTable p a f).storeTable (p.add (BitVec.ofNat 64 (192 * a))) b g =
        m.storeTable p (a + b) fun k => if k < a then f k else g (k - a)
  | 0 => (storeTable_congr (n := a) fun k hk => (ite_eq_left hk).symm :)
  | b + 1 => by
    rw [storeTable_succ, storeTable_append, ← Nat.add_assoc, storeTable_succ, add_ofNat_add,
      ← Nat.mul_add]
    simp only [show ¬a + b < a by omega, ite_false, Nat.add_sub_cancel_left]

/-- Segments of `a` entries: one table, entry `k` being `f (k / a) (k % a)`. -/
theorem storeSegs_eq {m : MemoryState} {p : Pointer} {a : Nat} {f : Nat → Nat → Quad}
    (ha : 0 < a) : ∀ j, m.storeSegs p a f j = m.storeTable p (a * j) fun k => f (k / a) (k % a)
  | 0 => rfl
  | j + 1 => by
    rw [MemoryState.storeSegs, storeSegs_eq ha j, storeTable_append, Nat.mul_succ]
    refine storeTable_congr fun k hk => ?_
    by_cases hkj : k < a * j
    · rw [ite_eq_left hkj]
    · rw [ite_eq_right hkj]
      obtain ⟨r, rfl, hr⟩ : ∃ r, k = a * j + r ∧ r < a := ⟨k - a * j, by omega, by omega⟩
      rw [Nat.mul_add_div ha, Nat.mul_add_mod, Nat.div_eq_of_lt hr, Nat.mod_eq_of_lt hr,
        Nat.add_zero, Nat.add_sub_cancel_left]

/-- `storeSegs_eq` for a table of `n = a j` entries. -/
theorem storeTable_eq_segs {m : MemoryState} {p : Pointer} {a n : Nat} {f : Nat → Nat → Quad}
    (ha : 0 < a) (j : Nat) (h : a * j = n) :
    m.storeTable p n (fun k => f (k / a) (k % a)) = m.storeSegs p a f j := by
  rw [storeSegs_eq ha j, h]

/-- Room for entries `k … k + c - 1` of a table where there is room for its `n`. -/
theorem room_seg {m : MemoryState} {p : Pointer} {n k c : Nat} (h : Room m p (1536 * n))
    (hp : p.offset.toNat + 192 * n < 2 ^ 64) (hk : k + c ≤ n) :
    Room m (p.add (BitVec.ofNat 64 (192 * k))) (1536 * c) :=
  Room.add_of_le
    (by
      simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le]
      rw [Nat.mod_eq_of_lt (by omega)]
      omega)
    (by
      rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
      omega)
    h

/-! ### Reads and fits -/

/-- A read outside the table's block: the read before it. -/
@[mlir_read]
theorem readAt_storeTable_of_id_ne {m : MemoryState} {p q : Pointer} {f : Nat → Quad}
    (h : p.id ≠ q.id) : ∀ {n : Nat}, (m.storeTable p n f).readAt q w = m.readAt q w
  | 0 => rfl
  | n + 1 => by
    rw [storeTable_succ, MemoryState.readAt_storeQuad_of_id_ne (by simpa using h),
      readAt_storeTable_of_id_ne h]

/-- A point read outside the table's block: the point before it. -/
@[mlir_read]
theorem readQuad_storeTable_of_id_ne {m : MemoryState} {p q : Pointer} {f : Nat → Quad}
    (h : p.id ≠ q.id) {n : Nat} : (m.storeTable p n f).readQuad q = m.readQuad q := by
  simp only [MemoryState.readQuad, MemoryState.readVec, readAt_storeTable_of_id_ne h,
    readAt_storeTable_of_id_ne (q := q.add _) (by simpa using h)]

@[mlir_mem, mlir_transport]
theorem _root_.MLIR.Fits.storeTable {m : MemoryState} {f : Nat → Quad} {n : Nat}
    (h : Fits m q w) : Fits (m.storeTable p n f) q w := by
  induction n with
  | zero => exact h
  | succ n ih => exact Fits.storeQuad ih

@[mlir_mem, mlir_transport]
theorem _root_.MLIR.Room.storeTable {m : MemoryState} {f : Nat → Quad} {n : Nat}
    (h : Room m q w) : Room (m.storeTable p n f) q w := by
  induction n with
  | zero => exact h
  | succ n ih => exact Room.storeQuad ih

@[mlir_mem, mlir_transport]
theorem _root_.MLIR.InBounds.storeTable {m : MemoryState} {f : Nat → Quad} {n : Nat}
    (h : InBounds m q w) : InBounds (m.storeTable p n f) q w := by
  induction n with
  | zero => exact h
  | succ n ih => exact InBounds.storeQuad ih

@[mlir_mem, mlir_transport]
theorem _root_.MLIR.Writable.storeTable {m : MemoryState} {f : Nat → Quad} {n : Nat}
    (h : Writable m q) : Writable (m.storeTable p n f) q := by
  induction n with
  | zero => exact h
  | succ n ih => exact Writable.storeQuad ih

@[mlir_mem, mlir_transport]
theorem _root_.MLIR.MemoryState.QuadFit.storeTable {m : MemoryState} {f : Nat → Quad}
    (h : m.QuadFit q) {n : Nat} :
    (m.storeTable p n f).QuadFit q :=
  ⟨h.1, Fits.storeTable h.2.1, Fits.storeTable h.2.2.1, Fits.storeTable h.2.2.2⟩

@[mlir_mem, mlir_transport]
theorem _root_.MLIR.MemoryState.QuadRoom.storeTable {m : MemoryState} {f : Nat → Quad}
    (h : m.QuadRoom q) {n : Nat} :
    (m.storeTable p n f).QuadRoom q :=
  ⟨h.1, Room.storeTable h.2.1, Room.storeTable h.2.2.1, Room.storeTable h.2.2.2⟩

@[simp, mlir_mem]
theorem WF_storeTable {s : GlobalState} {f : Nat → Quad} :
    ∀ {n : Nat},
      ({ s with mem := m.storeTable p n f } : GlobalState).WF ↔
        ({ s with mem := m } : GlobalState).WF
  | 0 => Iff.rfl
  | n + 1 => by
    rw [storeTable_succ, GlobalState.WF_storeQuad]
    exact WF_storeTable

@[mlir_transport]
theorem WF.storeTable {s : GlobalState} {f : Nat → Quad} (h : s.WF) {n : Nat} :
    ({ s with mem := s.mem.storeTable p n f } : GlobalState).WF :=
  WF_storeTable.mpr h

@[mlir_transport]
theorem WF.storeTable_mk {a : AllocState} {m : MemoryState} {f : Nat → Quad}
    (h : (⟨a, m⟩ : GlobalState).WF) {n : Nat} : (⟨a, m.storeTable p n f⟩ : GlobalState).WF :=
  WF.storeTable (s := ⟨a, m⟩) h

/-- Room for a table: room for its entries. -/
theorem tableRoom_of_room {m : MemoryState} {p : Pointer} {n : Nat} (h : Room m p (1536 * n))
    (hp : p.offset.toNat + 192 * n < 2 ^ 64) : m.TableRoom p n := fun _ hk =>
  MemoryState.QuadRoom.entry h hp hk

/-- Room for a table's entries past its stores. -/
theorem _root_.MLIR.MemoryState.TableRoom.storeTable {m : MemoryState} {f : Nat → Quad}
    (h : m.TableRoom q k) {n : Nat} :
    (m.storeTable p n f).TableRoom q k := fun j hj => MemoryState.QuadRoom.storeTable (h j hj)

/-- A table's entries, where there was room for them, are known after its stores. -/
theorem tableFit_storeTable {m : MemoryState} {p : Pointer} {f : Nat → Quad} :
    ∀ {n : Nat}, m.TableRoom p n → (m.storeTable p n f).TableFit p n
  | 0, _ => fun _ hk => absurd hk (by omega)
  | n + 1, h => fun k hk => by
    rw [storeTable_succ]
    rcases Nat.lt_or_ge k n with hkn | hkn
    · exact (tableFit_storeTable (fun j hj => h j (by omega)) k hkn).storeQuad
    · obtain rfl : k = n := by omega
      exact MemoryState.QuadFit.storeQuad_self (MemoryState.QuadRoom.storeTable (h k hk))

/-- A table's entries read back. -/
theorem readTable_storeTable {m : MemoryState} {p : Pointer} {f : Nat → Quad} :
    ∀ {n k : Nat}, m.TableRoom p n → p.offset.toNat + 192 * n ≤ 2 ^ 64 → k < n →
      (m.storeTable p n f).readTable p k = f k
  | 0, _, _, _, hk => absurd hk (by omega)
  | n + 1, k, h, hp, hk => by
    rw [MemoryState.readTable, storeTable_succ]
    rcases Nat.lt_or_ge k n with hkn | hkn
    · rw [MemoryState.readQuad_storeQuad_apart (by omega) (by omega) (by omega)]
      exact readTable_storeTable (fun j hj => h j (by omega)) (by omega) hkn
    · obtain rfl : k = n := by omega
      exact MemoryState.readQuad_storeQuad_self (MemoryState.QuadRoom.storeTable (h k hk))

/-! ### Products -/

/-- `FD_R43X6_QUAD_PERMUTE( 0,1,2,3 )` is the identity. -/
theorem permute_0123 (X : Quad) : X.permute 0 1 2 3 = X := by
  rw [Quad.permute_eq_perm4 (by decide)]
  rcases X with ⟨a, b, c⟩
  simp only [Quad.perm4, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext k hk : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  all_goals
    first
    | omega
    | simp [wwl_perm4]

/-- `FD_R43X6_QUAD_MUL_FAST( _, X, Y )` from `quadMulCore` on `X`'s halves. -/
theorem quadMul_of_core_id {X Y M : Quad}
    (h :
      quadMulCore (wwl_pack_halves (X.permute 0 1 2 3).P03 0 (X.permute 0 1 2 3).P03 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P14 0 (X.permute 0 1 2 3).P14 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P25 0 (X.permute 0 1 2 3).P25 0)
          (wwl_pack_halves (X.permute 0 1 2 3).P03 1 (X.permute 0 1 2 3).P03 1)
          (wwl_pack_halves (X.permute 0 1 2 3).P14 1 (X.permute 0 1 2 3).P14 1)
          (wwl_pack_halves (X.permute 0 1 2 3).P25 1 (X.permute 0 1 2 3).P25 1) Y.P03 Y.P14 Y.P25 =
        M) :
    quadMul X Y = M := by
  rw [permute_0123] at h
  rw [Firedancer.Lane.quadMul_eq_core]
  exact h

/-- `fd_curve25519_into_precomputed` from its steps' equations. -/
theorem intoPre_of {X T2 T3 F M : Quad}
    (h2 : (X.permute 1 0 2 3).laneSubFast 1 0 0 0 (X.permute 1 0 2 3) X = T2)
    (h3 : T2.laneAddFast 0 1 0 0 T2 X = T3) (hF : T3.foldSigned = F)
    (hM : quadMul F quad1112d = M) :
    fd_curve25519_into_precomputed.spec X = M.foldUnsigned := by
  subst_vars
  rfl

/-! ### Pointer arrays -/

/-- A store of four pointers, as `vector<4 x ptr>`: four pointer stores. -/
theorem storeDef_recordPtrs4 {m : MemoryState} {p a b c d : Pointer}
    (hp : p.offset.toNat + 32 ≤ 2 ^ 64) :
    (m.storeDef p ((Ty.array 4 .ptr).flattenDef #v[.value a, .value b, .value c, .value d]).1
          ((Ty.array 4 .ptr).flattenDef #v[.value a, .value b, .value c, .value d]).2).recordPtrs p
        ((Ty.array 4 .ptr).ptrLeaves 0 #v[.value a, .value b, .value c, .value d]) =
      (((m.storePtr p a).storePtr (p.add 8#64) b).storePtr (p.add 16#64) c).storePtr
        (p.add 24#64) d := by
  have h8 : (p.add 8#64).offsetInBits = p.offsetInBits + 64 := by
    simp [Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]; omega
  have h16 : (p.add 16#64).offsetInBits = p.offsetInBits + 128 := by
    simp [Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]; omega
  have h24 : (p.add 24#64).offsetInBits = p.offsetInBits + 192 := by
    simp [Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]; omega
  have hl : (Ty.array 4 .ptr).ptrLeaves 0 #v[.value a, .value b, .value c, .value d] =
      [(0, a), (64, b), (128, c), (192, d)] := rfl
  have hf2 : ((Ty.array 4 .ptr).flattenDef #v[.value a, .value b, .value c, .value d]).2 = 0 := by
    simp only [Ty.flattenDef, Ty.definedness, Ty.flattenRaw]
    apply BitVec.eq_of_toNat_eq
    simp [BitVec.toNat_packLanes, Ty.packNat, BitVec.toNat_ofNat]
    decide
  rw [hl, hf2]
  generalize ((Ty.array 4 .ptr).flattenDef #v[.value a, .value b, .value c, .value d]).1 = x
  simp only [MemoryState.recordPtrs, List.foldl, MemoryState.recordPtr, MemoryState.storeDef,
    MemoryState.storePtr, Pointer.add_id, h8, h16, h24, MemoryState.addr_modifyBlock]
  rw [MemoryState.modifyBlock_modifyBlock_self, MemoryState.modifyBlock_modifyBlock_self,
    MemoryState.modifyBlock_modifyBlock_self, MemoryState.modifyBlock_modifyBlock_self,
    MemoryState.modifyBlock_modifyBlock_self, MemoryState.modifyBlock_modifyBlock_self,
    MemoryState.modifyBlock_modifyBlock_self]
  rotate_left
  all_goals try (intro _; rfl)
  congr 1
  funext blk
  have hw : (Ty.array 4 Ty.ptr).width = 256 := by decide
  simp only [Function.comp_apply, MemoryBlock.mk.injEq, true_and]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_, ?_⟩
  · apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, hw]
    grind
  · apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, hw, BitVec.getLsbD_zero]
    grind
  · refine ⟨?_, trivial⟩
    funext o
    simp only [MemoryBlock.clearPtrs, show ¬(0 : BitVec (Ty.array 4 Ty.ptr).width) =
      BitVec.allOnes _ by decide, show ¬(0#64 = BitVec.allOnes 64) by decide, ite_false]
    grind

/-- `store` of four pointers, as `vector<4 x ptr>`, where there is room: four pointer stores. -/
theorem run_storePtrs4 {s : GlobalState} {env : ⟪Γ⟫} {ptr a b c d : Pointer}
    {v : ⟦.array 4 .ptr⟧} (hv : v = #v[.value a, .value b, .value c, .value d])
    (hroom : Room s.mem ptr 256) (hp : ptr.offset.toNat + 32 ≤ 2 ^ 64) :
    (Operation.store (τ := .array 4 .ptr) (.value ptr) v) env s =
      .value
        (env,
          { s with
            mem :=
              (((s.mem.storePtr ptr a).storePtr (ptr.add 8#64) b).storePtr (ptr.add 16#64)
                    c).storePtr
                (ptr.add 24#64) d }) := by
  subst hv
  rw [run_storeValue hroom, storeDef_recordPtrs4 hp]

/-- What four pointer stores 8 bytes apart load back. -/
theorem loadPtr_storePtrs4 {m : MemoryState} {p a b c d : Pointer} (h : Room m p 256)
    (hp : p.offset.toNat + 32 ≤ 2 ^ 64) :
    let m' := (((m.storePtr p a).storePtr (p.add 8#64) b).storePtr (p.add 16#64) c).storePtr
      (p.add 24#64) d
    m'.loadPtr p = .value a ∧ m'.loadPtr (p.add 8#64) = .value b ∧
      m'.loadPtr (p.add 16#64) = .value c ∧ m'.loadPtr (p.add 24#64) = .value d := by
  intro m'
  have ho (x : Nat) (hx : x ≤ 24) :
      (p.add (BitVec.ofNat 64 x)).offsetInBits = p.offsetInBits + 8 * x := by
    simp only [Pointer.offsetInBits, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hd (x y : Nat) (hx : x ≤ 24) (hy : y ≤ 24) (hxy : x + 8 ≤ y ∨ y + 8 ≤ x) :
      (Range.of (p.add (BitVec.ofNat 64 x)) 64).Disjoint
        (Range.of (p.add (BitVec.ofNat 64 y)) 64) := by
    simp only [Range.Disjoint, Range.of, ho x hx, ho y hy]
    omega
  have hd0 (x : Nat) (hx : x ≤ 24) (h8 : 8 ≤ x) :
      (Range.of (p.add (BitVec.ofNat 64 x)) 64).Disjoint (Range.of p 64) ∧
        (Range.of p 64).Disjoint (Range.of (p.add (BitVec.ofNat 64 x)) 64) := by
    simp only [Range.Disjoint, Range.of, ho x hx]
    omega
  have hr (x : Nat) (hx : x ≤ 24) {m₀ : MemoryState} (hm : Room m₀ p 256) :
      Room m₀ (p.add (BitVec.ofNat 64 x)) 64 :=
    Room.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) hm
  have hr0 : ∀ {m₀ : MemoryState}, Room m₀ p 256 → Room m₀ p 64 := fun hm => hm.mono (by omega)
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [MemoryState.loadPtr_storePtr_disjoint (hd0 24 (by omega) (by omega)).1,
      MemoryState.loadPtr_storePtr_disjoint (hd0 16 (by omega) (by omega)).1,
      MemoryState.loadPtr_storePtr_disjoint (hd0 8 (by omega) (by omega)).1,
      MemoryState.loadPtr_storePtr_self (hr0 h)]
  · rw [MemoryState.loadPtr_storePtr_disjoint (hd 24 8 (by omega) (by omega) (by omega)),
      MemoryState.loadPtr_storePtr_disjoint (hd 16 8 (by omega) (by omega) (by omega)),
      MemoryState.loadPtr_storePtr_self (hr 8 (by omega) (Room.storePtr h))]
  · rw [MemoryState.loadPtr_storePtr_disjoint (hd 24 16 (by omega) (by omega) (by omega)),
      MemoryState.loadPtr_storePtr_self (hr 16 (by omega) (Room.storePtr (Room.storePtr h)))]
  · rw [MemoryState.loadPtr_storePtr_self
      (hr 24 (by omega) (Room.storePtr (Room.storePtr (Room.storePtr h))))]

/-- A point's three vectors that fit: its 192 bytes fit. -/
theorem quadFit_fits {m : MemoryState} {p : Pointer} (h : m.QuadFit p) :
    Fits m p 1536 := by
  have h1 : Fits m p 1024 :=
    Fits.append (off := 64#64) (by simp [BitVec.uaddOverflow]; omega) (by simp) (by rfl) h.2.1
      h.2.2.1
  exact Fits.append (off := 128#64) (by simp [BitVec.uaddOverflow]; omega) (by simp) (by rfl) h1
    h.2.2.2

/-- A table's entries that fit: the whole table fits. -/
theorem fits_of_tableFit {m : MemoryState} {p : Pointer} :
    ∀ {n : Nat}, 0 < n → m.TableFit p n → p.offset.toNat + 192 * n ≤ 2 ^ 64 →
      Fits m p (1536 * n)
  | 0, h0, _, _ => absurd h0 (by omega)
  | 1, _, h, _ => by
    simpa [Pointer.add] using quadFit_fits (h 0 (by omega))
  | n + 2, _, h, hp => by
    have ih := fits_of_tableFit (n := n + 1) (by omega) (fun k hk => h k (by omega)) (by omega)
    exact Fits.append (off := BitVec.ofNat 64 (192 * (n + 1)))
      (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) (w := 1536) (by omega) ih
      (quadFit_fits (h (n + 1) (by omega)))

/-! ### Frames -/

@[mlir_frame, mlir_erase]
theorem eraseFrom_storeTable {m : MemoryState} {p : Pointer} {f : Nat → Quad} :
    ∀ {n : Nat}, (m.storeTable p n f).eraseFrom N = (m.eraseFrom N).storeTable p n f
  | 0 => rfl
  | n + 1 => by rw [storeTable_succ, MemoryState.eraseFrom_storeQuad, eraseFrom_storeTable]; rfl

end Firedancer.Lane.Split

/-! ### Specs -/

namespace Firedancer.Lane

/-- `tbl[i]` of `split_odd_table( tbl, p, n )` before `fd_curve25519_into_precomputed`: `p`, then
`fd_ed25519_point_add( &tbl[i], p2, &tbl[i-1] )`. -/
def split_odd_table.raw (P2 P : Quad) : Nat → Quad
  | 0 => P
  | i + 1 => fd_ed25519_point_add_with_opts.spec P2 (split_odd_table.raw P2 P i) 0#32

/-- `tbl[i]` of `split_odd_table( tbl, p, n )`: `(2i + 1) p` with `p2 = 2p`, precomputed. -/
def split_odd_table.spec (P : Quad) (i : Nat) : Quad :=
  fd_curve25519_into_precomputed.spec
    (split_odd_table.raw (fd_ed25519_point_dbln.spec P 1) P i)

/-- `p` of the split tables' segment `j`: `A` doubled `32 j` times. -/
def fd_ed25519_split_table_a.seg (A : Quad) : Nat → Quad
  | 0 => A
  | j + 1 => fd_ed25519_point_dbln.spec (fd_ed25519_split_table_a.seg A j) 32

/-- Entry `k` of `fd_ed25519_split_table_a( tbl, a )`: entry `k % 4` of `split_odd_table` on
segment `k / 4`'s point. -/
def fd_ed25519_split_table_a.spec (A : Quad) (k : Nat) : Quad :=
  split_odd_table.spec (fd_ed25519_split_table_a.seg A (k / 4)) (k % 4)

/-- The base point, as `fd_ed25519_split_table_b` sets it. -/
def fd_ed25519_split_table_b.base : Quad :=
  ⟨#v[5912276620570#64, 7036874417752#64, 1#64, 2970602692003#64, 1206867684910#64,
      3518437208883#64, 0#64, 8002368565694#64],
    #v[5175273663173#64, 5277655813324#64, 0#64, 2381000326097#64, 7581689711182#64,
      7036874417766#64, 0#64, 787695955620#64],
    #v[1806891319892#64, 1759218604441#64, 0#64, 4963950264797#64, 286998243226#64,
      879609302220#64, 0#64, 889305571247#64]⟩

/-- Entry `k` of `fd_ed25519_split_table_b( tbl )`: entry `k % 128` of `split_odd_table` on
segment `k / 128 + 1`'s point. -/
def fd_ed25519_split_table_b.spec (k : Nat) : Quad :=
  split_odd_table.spec (fd_ed25519_split_table_a.seg fd_ed25519_split_table_b.base (k / 128 + 1))
    (k % 128)


namespace double_scalar_mul_base_split

open _root_.MLIR.Firedancer.Avx512.fd_ed25519_double_scalar_mul_base (addDigit)

/-- Digit `k` of the slides `w`, `0` past them. -/
def digit (w : Vector Int 256) (k : Nat) : Int :=
  if h : k < 256 then w[k] else 0

/-- `bt[j][k]`: `fd_ed25519_base_point_wnaf_table`'s entry for segment `0`, `b_tbl`'s segment
`j - 1` for the others. -/
noncomputable def btab (tb : Nat → Quad) (j k : Nat) : Quad :=
  if j = 0 then fd_ed25519_base_point_wnaf_table.point k else tb (128 * (j - 1) + k)

/-- Segment `j`'s adds at bit `i` on `(r, t)`: `n1slide`'s digit from `a_tbl`'s segment `j`, then
`n2slide`'s from `bt[j]`. -/
noncomputable def segAdd (ta tb : Nat → Quad) (w1 w2 : Vector Int 256) (i j : Nat)
    (rt : Quad × Quad) : Quad × Quad :=
  let rt := addDigit (fun k => ta (4 * j + k)) (digit w1 (32 * j + i)) rt.1 rt.2
  addDigit (btab tb j) (digit w2 (32 * j + i)) rt.1 rt.2

/-- Segments `0 … j-1`'s adds at bit `i`. -/
noncomputable def segAdds (ta tb : Nat → Quad) (w1 w2 : Vector Int 256) (i : Nat) :
    Nat → Quad × Quad → Quad × Quad
  | 0, rt => rt
  | j + 1, rt => segAdd ta tb w1 w2 i j (segAdds ta tb w1 w2 i j rt)

/-- An iteration at bit `i` on `r`: `t = partial_dbl( r )`, the eight segments' adds, then `r` a
copy of `t`. -/
noncomputable def iter (ta tb : Nat → Quad) (w1 w2 : Vector Int 256) (i : Nat) (r : Quad) : Quad :=
  (segAdds ta tb w1 w2 i 8 (r, fd_ed25519_partial_dbl.spec r)).2

/-- The main loop from bit `i` down to `0` on `r`. -/
noncomputable def ladder (ta tb : Nat → Quad) (w1 w2 : Vector Int 256) : Nat → Quad → Quad
  | 0, r => iter ta tb w1 w2 0 r
  | i + 1, r => ladder ta tb w1 w2 i (iter ta tb w1 w2 (i + 1) r)

/-- No segment has a digit at bit `i`. -/
def zeroAt (w1 w2 : Vector Int 256) (i : Nat) : Prop :=
  ∀ j < 8, digit w1 (32 * j + i) = 0 ∧ digit w2 (32 * j + i) = 0

instance (w1 w2 : Vector Int 256) (i : Nat) : Decidable (zeroAt w1 w2 i) :=
  inferInstanceAs (Decidable (∀ j < 8, _))

/-- `for( i=31; i>=0; i-- ) { nz = …; if( nz ) break; }` from `i` down: the bit it stops at, if
any. -/
def start (w1 w2 : Vector Int 256) : Nat → Option Nat
  | 0 => if zeroAt w1 w2 0 then none else some 0
  | i + 1 => if zeroAt w1 w2 (i + 1) then start w1 w2 i else some (i + 1)

end double_scalar_mul_base_split

open double_scalar_mul_base_split in
/-- `n1 A + n2 B` as `double_scalar_mul_base_split` computes it from the split tables `ta` of `A`
and `tb` of `B`: the slides, then the main loop from the first bit with a digit, on the neutral
point. -/
noncomputable def double_scalar_mul_base_split.spec (ta tb : Nat → Quad) (n1 n2 : BitVec 256) :
    Quad :=
  let n1slide := Ref.fd_curve25519_scalar_wnaf.wnaf n1 3
  let n2slide := Ref.fd_curve25519_scalar_wnaf.wnaf n2 8
  match start n1slide n2slide 31 with
  | some i => ladder ta tb n1slide n2slide i fd_ed25519_point_set_zero.spec
  | none => fd_ed25519_point_set_zero.spec

end Firedancer.Lane

end

end MLIR
