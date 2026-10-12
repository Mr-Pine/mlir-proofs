module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Dsmb
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_curve25519_into_precomputed
public import Firedancer.Ref.fd_curve25519_scalar_wnaf
public import Firedancer.Ref.fd_ed25519_partial_dbl
public import Firedancer.Ref.fd_ed25519_point_add_final_mul
public import Firedancer.Ref.fd_ed25519_point_add_final_mul_projective
public import Firedancer.Ref.fd_ed25519_point_add_with_opts
public import Firedancer.Ref.fd_ed25519_point_dbln
public import Firedancer.Ref.fd_ed25519_point_set
public import Firedancer.Ref.fd_ed25519_point_set_zero
public import Firedancer.Ref.fd_ed25519_point_sub_with_opts
public import Firedancer.Ref.Mlir.fd_ed25519_double_scalar_mul_base
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.Ref

/-! ## Specification

The slides are `fd_curve25519_scalar_wnaf.wnaf`'s digits, as `Int`s. The base point's table is a
parameter `tbl`; the function reads `baseTbl`, the bits `addressof` gives
`fd_ed25519_base_point_wnaf_table`. -/

@[expose] public section

namespace fd_ed25519_double_scalar_mul_base

/-- `ai[i]` after the table loop `for( int i=1; i<WNAF_TBL_SZ; i++ )` from `ai[0]` and `a2`:
`t = a2 + ai[i-1]` (`Z = 1` for `i == 1`), then `ai[i]` its final multiplication, precomputed. -/
def aiTable (a2 ai0 : PointLimbs) : Nat → PointLimbs
  | 0 => ai0
  | i + 1 =>
    let t :=
      fd_ed25519_point_add_with_opts.spec a2 (aiTable a2 ai0 i) (if i + 1 = 1 then 1#32 else 0#32)
        1#32 1#32
    fd_curve25519_into_precomputed.spec (fd_ed25519_point_add_final_mul.spec t)

/-- `for( i=255; i>=0; i-- ) if( n1slide[i] || n2slide[i] ) break;` from `i` down: the `i` it
stops at, if any. -/
def start (w1 w2 : Vector Int 256) : (i : Nat) → i < 256 → Option (Fin 256)
  | 0, _ => if w1[0] = 0 ∧ w2[0] = 0 then none else some 0
  | i + 1, h => if w1[i + 1] = 0 ∧ w2[i + 1] = 0 then start w1 w2 i (by omega) else some ⟨i + 1, h⟩

/-- A digit's add, `if( d > 0 ) … else if( d < 0 ) …`: `r` the final multiplication of `t`, then
`t` as `r` plus or minus `tbl[|d| / 2]`, with the `Z = 1` flags `zp`, `zm`; nothing at `d = 0`. -/
def addDigit (tbl : Nat → PointLimbs) (d : Int) (zp zm : BitVec 32) (r t : PointLimbs) :
    PointLimbs × PointLimbs :=
  if 0 < d then
    let r := fd_ed25519_point_add_final_mul.spec t
    (r, fd_ed25519_point_add_with_opts.spec r (tbl (d / 2).toNat) zp 1#32 1#32)
  else
    if d < 0 then
      let r := fd_ed25519_point_add_final_mul.spec t
      (r, fd_ed25519_point_sub_with_opts.spec r (tbl (-d / 2).toNat) zm 1#32 1#32)
    else (r, t)

/-- `t = partial_dbl( r )`, then `n1slide[i]`'s add, `d`: `ai[0]`'s `Z` is one for `d = ±1`. -/
def add1 (ai : Nat → PointLimbs) (d : Int) (r : PointLimbs) : PointLimbs × PointLimbs :=
  addDigit ai d (if d = 1 then 1#32 else 0#32) (if d = -1 then 1#32 else 0#32) r
    (fd_ed25519_partial_dbl.spec r)

/-- An iteration's adds on `r`: `add1`, then `n2slide[i]`'s add from `tbl`, whose `Z` is one;
the new `r` and `t`. -/
def adds (ai tbl : Nat → PointLimbs) (d1 d2 : Int) (r : PointLimbs) : PointLimbs × PointLimbs :=
  let rt := add1 ai d1 r
  addDigit tbl d2 1#32 1#32 rt.1 rt.2

/-- The main loop from `i` down to `0` on `r`. Its last multiplication computes `r`'s `T` only at
`i == 0`. -/
def ladder (ai tbl : Nat → PointLimbs) (w1 w2 : Vector Int 256) :
    (i : Nat) → i < 256 → PointLimbs → PointLimbs
  | 0, _, r => fd_ed25519_point_add_final_mul.spec (adds ai tbl w1[0] w2[0] r).2
  | i + 1, h, r =>
    let rt := adds ai tbl w1[i + 1] w2[i + 1] r
    ladder ai tbl w1 w2 i (by omega) (fd_ed25519_point_add_final_mul_projective.spec rt.2 rt.1.T)

/-- `n1 A + n2 B` as the code computes it, `B`'s odd multiples precomputed in `tbl`: the slides,
the table `ai` of `A`'s, then the main loop from the first non-zero digit on the neutral point. -/
def spec (tbl : Nat → PointLimbs) (n1 : BitVec 256) (A : PointLimbs) (n2 : BitVec 256) :
    PointLimbs :=
  let n1slide := fd_curve25519_scalar_wnaf.wnaf n1 4
  let n2slide := fd_curve25519_scalar_wnaf.wnaf n2 8
  let ai := aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)
  match start n1slide n2slide 255 (by decide) with
  | some i => ladder ai tbl n1slide n2slide i i.isLt fd_ed25519_point_set_zero.spec
  | none => fd_ed25519_point_set_zero.spec

/-- Blocks a digit's add allocates: `add_with_opts`'s or `sub_with_opts`'s ten. -/
def digitBlocks (d : Int) : Nat :=
  if d = 0 then 0 else 10

/-- Blocks the main loop's callees allocate from `i` down: `partial_dbl`'s five per iteration,
and the adds'. -/
def ladderBlocks (w1 w2 : Vector Int 256) : (i : Nat) → i < 256 → Nat
  | 0, _ => 5 + digitBlocks w1[0] + digitBlocks w2[0]
  | i + 1, h => 5 + digitBlocks w1[i + 1] + digitBlocks w2[i + 1] + ladderBlocks w1 w2 i (by omega)

/-- The blocks the function allocates, its callees' included: 110 before the main loop. -/
def blocks (n1 n2 : BitVec 256) : Nat :=
  let n1slide := fd_curve25519_scalar_wnaf.wnaf n1 4
  let n2slide := fd_curve25519_scalar_wnaf.wnaf n2 8
  110 +
    match start n1slide n2slide 255 (by decide) with
    | some i => ladderBlocks n1slide n2slide i i.isLt
    | none => 0

/-- The point at bit `o` of `b`: `X, Y, T, Z` 320 bits apart. -/
def pointAt (b : BitVec n) (o : Nat) : PointLimbs :=
  ⟨fun i => b.extractLsb' (o + 64 * i.val) 64, fun i => b.extractLsb' (o + 320 + 64 * i.val) 64,
    fun i => b.extractLsb' (o + 640 + 64 * i.val) 64, fun i =>
    b.extractLsb' (o + 960 + 64 * i.val) 64⟩

/-- `fd_ed25519_base_point_wnaf_table[j]`: entry `j` of the bits `addressof` stores. -/
noncomputable def baseTbl (j : Nat) : PointLimbs :=
  pointAt (Ty.flatBits fd_ed25519_base_point_wnaf_table.lit (w := 163840) (hw := rfl)) (1280 * j)

end fd_ed25519_double_scalar_mul_base

end

public theorem fd_ed25519_base_point_wnaf_table.value_eq (s : GlobalState) :
    fd_ed25519_base_point_wnaf_table.value s =
      .value (Ty.wrap fd_ed25519_base_point_wnaf_table.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-! ## Staged for Common -/

section Staged

/-- Storing what a point holds changes nothing. -/
theorem MemoryState.storePoint_readPoint_self {m : MemoryState} (h : m.PointFit p) :
    m.storePoint p (m.readPoint p) = m := by
  simp only [MemoryState.storePoint, MemoryState.readPoint]
  rw [MemoryState.storeLimbs_readLimbs_self h.2.1, MemoryState.storeLimbs_readLimbs_self h.2.2.1,
    MemoryState.storeLimbs_readLimbs_self h.2.2.2.2,
    MemoryState.storeLimbs_readLimbs_self h.2.2.2.1]

/-- `storePoint_readPoint_self` with the point named. -/
theorem MemoryState.storePoint_readPoint_self' {m : MemoryState} (h : m.PointFit p)
    (hP : m.readPoint p = P) : m.storePoint p P = m := by rw [← hP, storePoint_readPoint_self h]

/-- A field element at byte `b` from `p`, past a point stored at byte `a`, apart from it. -/
theorem readLimbs_storePoint_apart {m : MemoryState} {p : Pointer} {a b : Nat}
    (hp : p.offset.toNat + a + 160 ≤ 2 ^ 64) (hb : p.offset.toNat + b + 40 ≤ 2 ^ 64)
    (hab : a + 160 ≤ b ∨ b + 40 ≤ a) :
    (m.storePoint (p.add (BitVec.ofNat 64 a)) P).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m.readLimbs (p.add (BitVec.ofNat 64 b)) := by
  have hoff (c : Nat) (hc : c ≤ 120) :
    (p.add (BitVec.ofNat 64 (a + c))).offset.toNat + 32 < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hboff : (p.add (BitVec.ofNat 64 b)).offset.toNat + 32 < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hd (m' : MemoryState) (l : Fin 5 → BitVec 64) (c : Nat) (hc : c ≤ 120) :
    (m'.storeLimbs (p.add (BitVec.ofNat 64 (a + c))) l).readLimbs (p.add (BitVec.ofNat 64 b)) =
      m'.readLimbs (p.add (BitVec.ofNat 64 b)) :=
    MemoryState.readLimbs_storeLimbs_of_disjoint
      (Range.disjoint_add (by omega) (by omega) (by omega)) (hoff c hc) hboff
  have h0 := hd (c := 0) (hc := by omega)
  simp only [Nat.add_zero] at h0
  simp only [MemoryState.storePoint, add_ofNat_add]
  rw [hd _ _ 80 (by omega), hd _ _ 120 (by omega), hd _ _ 40 (by omega), h0]

/-- The point at byte `b` from `p`, past a point stored at byte `a`, apart from it. -/
theorem readPoint_storePoint_apart {m : MemoryState} {p : Pointer} {a b : Nat}
    (hp : p.offset.toNat + a + 160 ≤ 2 ^ 64) (hb : p.offset.toNat + b + 160 ≤ 2 ^ 64)
    (hab : a + 160 ≤ b ∨ b + 160 ≤ a) :
    (m.storePoint (p.add (BitVec.ofNat 64 a)) P).readPoint (p.add (BitVec.ofNat 64 b)) =
      m.readPoint (p.add (BitVec.ofNat 64 b)) := by
  simp only [MemoryState.readPoint, add_ofNat_add]
  rw [readLimbs_storePoint_apart hp (by omega) (by omega),
    readLimbs_storePoint_apart hp (by omega) (by omega),
    readLimbs_storePoint_apart hp (by omega) (by omega),
    readLimbs_storePoint_apart hp (by omega) (by omega)]

/-- Entry `k` of a table of `n` points from `p` fits where the table does. -/
theorem PointFit.entry {m : MemoryState} {p : Pointer} (h : Fits m p (1280 * n))
    (hp : p.offset.toNat + 160 * n < 2 ^ 64) (hk : k < n) :
    m.PointFit (p.add (BitVec.ofNat 64 (160 * k))) := by
  have hf (o : Nat) (ho : o + 8 ≤ 160) : Fits m (p.add (BitVec.ofNat 64 (160 * k + o))) 64 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      h
  have hoff (o : Nat) (ho : o ≤ 160) :
    (p.add (BitVec.ofNat 64 (160 * k + o))).offset.toNat = p.offset.toNat + 160 * k + o := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have h0 := hoff 0 (by omega)
  have hf0 := hf 0 (by omega)
  simp only [Nat.add_zero] at h0 hf0
  simp only [MemoryState.PointFit, MemoryState.LimbsFit, add_ofNat_add, h0,
    hoff _ (by omega : 40 ≤ 160), hoff _ (by omega : 80 ≤ 160), hoff _ (by omega : 120 ≤ 160)]
  refine
      ⟨by omega,
        ⟨by omega, hf0, hf _ (by omega), hf _ (by omega), hf _ (by omega), hf _ (by omega)⟩,
        ⟨by omega, ?_⟩, ⟨by omega, ?_⟩, ⟨by omega, ?_⟩⟩ <;>
    simp only [Nat.add_assoc] <;>
    exact ⟨hf _ (by omega), hf _ (by omega), hf _ (by omega), hf _ (by omega), hf _ (by omega)⟩

/-- Room for entry `k` of a table of `n` points from `p` where there is room for the table. -/
theorem PointRoom.entry {m : MemoryState} {p : Pointer} (h : Room m p (1280 * n))
    (hp : p.offset.toNat + 160 * n < 2 ^ 64) (hk : k < n) :
    m.PointRoom (p.add (BitVec.ofNat 64 (160 * k))) := by
  have hf (o : Nat) (ho : o + 8 ≤ 160) : Room m (p.add (BitVec.ofNat 64 (160 * k + o))) 64 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      h
  have hoff (o : Nat) (ho : o ≤ 160) :
    (p.add (BitVec.ofNat 64 (160 * k + o))).offset.toNat = p.offset.toNat + 160 * k + o := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have h0 := hoff 0 (by omega)
  have hf0 := hf 0 (by omega)
  simp only [Nat.add_zero] at h0 hf0
  simp only [MemoryState.PointRoom, MemoryState.LimbsRoom, add_ofNat_add, h0,
    hoff _ (by omega : 40 ≤ 160), hoff _ (by omega : 80 ≤ 160), hoff _ (by omega : 120 ≤ 160)]
  refine
      ⟨by omega,
        ⟨by omega, hf0, hf _ (by omega), hf _ (by omega), hf _ (by omega), hf _ (by omega)⟩,
        ⟨by omega, ?_⟩, ⟨by omega, ?_⟩, ⟨by omega, ?_⟩⟩ <;>
    simp only [Nat.add_assoc] <;>
    exact ⟨hf _ (by omega), hf _ (by omega), hf _ (by omega), hf _ (by omega), hf _ (by omega)⟩

/-- The field element at byte `o` of a known read: its bits. -/
theorem readLimbs_add_of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v} (hf : Fits m p v)
    (h : m.readAt p v = x) (hp : p.offset.toNat + o + 40 ≤ 2 ^ 64) (hv : 8 * o + 320 ≤ v) :
    m.readLimbs (p.add (BitVec.ofNat 64 o)) = fun i => x.extractLsb' (8 * o + 64 * i.val) 64 := by
  have hr (c : Nat) (hc : c ≤ 32) :
    m.readAt (p.add (BitVec.ofNat 64 (o + c))) 64 = x.extractLsb' (8 * o + 8 * c) 64 := by
    rw [MemoryState.readAt_add_of_readAt hf.inBounds
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        h]
    congr 1
    simp
    omega
  have h0 := hr 0 (by omega)
  simp only [Nat.add_zero, Nat.mul_zero] at h0
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs, add_ofNat_add]
  · exact h0
  · exact hr 8 (by omega)
  · exact hr 16 (by omega)
  · exact hr 24 (by omega)
  · exact hr 32 (by omega)

/-- The point at byte `o` of a known read: its bits. -/
theorem readPoint_add_of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v} (hf : Fits m p v)
    (h : m.readAt p v = x) (hp : p.offset.toNat + o + 160 ≤ 2 ^ 64) (hv : 8 * o + 1280 ≤ v) :
    m.readPoint (p.add (BitVec.ofNat 64 o)) =
      fd_ed25519_double_scalar_mul_base.pointAt x (8 * o) := by
  simp only [MemoryState.readPoint, add_ofNat_add, fd_ed25519_double_scalar_mul_base.pointAt]
  rw [readLimbs_add_of_readAt hf h (by omega) (by omega),
    readLimbs_add_of_readAt (o := o + 40) hf h (by omega) (by omega),
    readLimbs_add_of_readAt (o := o + 80) hf h (by omega) (by omega),
    readLimbs_add_of_readAt (o := o + 120) hf h (by omega) (by omega)]
  congr 1

/-- The point with the given field elements. -/
theorem MemoryState.readPoint_of_limbs {m : MemoryState} {p : Pointer} {P : PointLimbs}
    (hX : m.readLimbs p = P.X) (hY : m.readLimbs (p.add 40#64) = P.Y)
    (hT : m.readLimbs (p.add 80#64) = P.T) (hZ : m.readLimbs (p.add 120#64) = P.Z) :
    m.readPoint p = P := by simp only [MemoryState.readPoint, hX, hY, hT, hZ]

end Staged

/-! ## Proof -/

section Proof

attribute [local mlir_transport] GlobalState.WF.add_blocks₂

namespace fd_ed25519_double_scalar_mul_base

/-! ### Slides and tables in memory -/

/-- `n` points `f 0, …, f (n - 1)` at `p`, 160 bytes apart. -/
def TableAt (m : MemoryState) (p : Pointer) (n : Nat) (f : Nat → PointLimbs) : Prop :=
  ∀ k < n,
    m.PointFit (p.add (BitVec.ofNat 64 (160 * k))) ∧
      m.readPoint (p.add (BitVec.ofNat 64 (160 * k))) = f k

/-- `TableAt` past a store into another block. -/
theorem TableAt.storePoint {m : MemoryState} (h : TableAt m q n f) (hne : p.id ≠ q.id) :
    TableAt (m.storePoint p P) q n f := fun k hk =>
  ⟨(h k hk).1.storePoint, by
    rw [MemoryState.readPoint_storePoint_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

/-- `SlidesAt` past a store into another block. -/
theorem _root_.MLIR.Firedancer.SlidesAt.storePoint {m : MemoryState} (h : SlidesAt m q w)
    (hne : p.id ≠ q.id) : SlidesAt (m.storePoint p P) q w := fun k hk =>
  ⟨Fits.storePoint (h k hk).1, by
    rw [MemoryState.readAt_storePoint_of_id_ne (by simpa [Pointer.add_id] using hne)]
    exact (h k hk).2⟩

/-- `TableAt.storePoint` for a store into another block at an offset. -/
theorem TableAt.storePoint_add {m : MemoryState} {p q : Pointer} (h : TableAt m q n f)
    (hne : p.id ≠ q.id) : TableAt (m.storePoint (p.add k) P) q n f :=
  h.storePoint (by simpa [Pointer.add_id] using hne)

/-- `SlidesAt.storePoint` for a store into another block at an offset. -/
theorem _root_.MLIR.Firedancer.SlidesAt.storePoint_add {m : MemoryState} {p q : Pointer}
    (h : SlidesAt m q w) (hne : p.id ≠ q.id) : SlidesAt (m.storePoint (p.add k) P) q w :=
  h.storePoint (by simpa [Pointer.add_id] using hne)

/-- `n` points of a known read from `p`, 160 bytes apart. -/
theorem TableAt.of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v} (hf : Fits m p v)
    (h : m.readAt p v = x) (hp : p.offset.toNat + 160 * n < 2 ^ 64) (hv : 1280 * n = v) :
    TableAt m p n fun k => pointAt x (1280 * k) := fun k hk =>
  ⟨PointFit.entry (hv ▸ hf) hp hk, by
    rw [readPoint_add_of_readAt hf h (by omega) (by omega), show 8 * (160 * k) = 1280 * k by omega]⟩

/-- The entry block's registers that later blocks read. -/
abbrev EntryRegs (tbl n1s n2s ai a2 tp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1589 := 1#32, %1592 := 1#64, %1593 := 8#64, %1594 := 255#32, %1595 := 0#16, %1596 :=
    4294967295#32, %1597 := 1#16, %1598 := 65535#16, %1599 := tbl, %1600 := 0#64, %1601 :=
    18446744073709551615#64, %1602 := 0#32, %1603 := n1s, %1604 := n2s, %1605 := ai, %1606 := a2,
    %1607 := tp]

/-- The registers the main loop reads, `i` aside. -/
abbrev LoopRegs (tbl n1s n2s ai a2 tp : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1589 := 1#32, %1595 := 0#16, %1597 := 1#16, %1598 := 65535#16, %1599 := tbl, %1600 := 0#64,
    %1601 := 18446744073709551615#64, %1603 := n1s, %1604 := n2s, %1605 := ai, %1606 := a2, %1607 :=
    tp]

attribute [local mlir_transport] TableAt.storePoint SlidesAt.storePoint

/-! ### The main loop -/

/-- A point store at `t` after stores at `t` and `r`: the stores at `t` merge. -/
theorem storePoint_swap {m : MemoryState} {t r : Pointer} (ht : t.offset.toNat + 160 ≤ 2 ^ 64)
    (htr : t.id ≠ r.id) :
    ((m.storePoint t X).storePoint r Y).storePoint t Z = (m.storePoint t Z).storePoint r Y := by
  rw [MemoryState.storePoint_comm htr.symm, MemoryState.storePoint_storePoint_self ht]

/-- One main-loop iteration's stores at `t` and `r`, merged: the last of each. -/
theorem storePoint_canon {m : MemoryState} {t r : Pointer} (ht : t.offset.toNat + 160 ≤ 2 ^ 64)
    (hr : r.offset.toNat + 160 ≤ 2 ^ 64) (htr : t.id ≠ r.id) :
    ((((m.storePoint t T₁).storePoint r R₁).storePoint t T₂).storePoint r R₂).storePoint r R₃ =
      (m.storePoint t T₂).storePoint r R₃ := by
  rw [MemoryState.storePoint_storePoint_self hr, storePoint_swap ht htr,
    MemoryState.storePoint_storePoint_self hr]

/-- The main loop's objects: blocks apart and offsets that do not wrap. -/
structure Layout (r tp n1s n2s ai tbl : Pointer) : Prop where
  rt : r.id ≠ tp.id
  r1 : r.id ≠ n1s.id
  r2 : r.id ≠ n2s.id
  ra : r.id ≠ ai.id
  rb : r.id ≠ tbl.id
  t1 : tp.id ≠ n1s.id
  t2 : tp.id ≠ n2s.id
  ta : tp.id ≠ ai.id
  tb : tp.id ≠ tbl.id
  n1o : n1s.offset.toNat + 512 < 2 ^ 64
  n2o : n2s.offset.toNat + 512 < 2 ^ 64
  aio : ai.offset.toNat + 160 * 8 < 2 ^ 64
  tbo : tbl.offset.toNat + 160 * 128 < 2 ^ 64

/-- What the main loop needs of a state: `r` and `t` fit, the slides and tables in place. -/
structure LoopFacts (S : GlobalState) (r tp n1s n2s ai tbl : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → PointLimbs) : Prop where
  wf : S.WF
  fitR : S.mem.PointFit r
  fitT : S.mem.PointFit tp
  slides1 : SlidesAt S.mem n1s w1
  slides2 : SlidesAt S.mem n2s w2
  tblA : TableAt S.mem ai 8 AI
  tblB : TableAt S.mem tbl 128 B

/-- `LoopFacts` before `r` is first stored: room for `r`. -/
structure EntryFacts (S : GlobalState) (r tp n1s n2s ai tbl : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → PointLimbs) : Prop where
  wf : S.WF
  roomR : S.mem.PointRoom r
  fitT : S.mem.PointFit tp
  slides1 : SlidesAt S.mem n1s w1
  slides2 : SlidesAt S.mem n2s w2
  tblA : TableAt S.mem ai 8 AI
  tblB : TableAt S.mem tbl 128 B

/-- `LoopFacts` after `t` and `r` are stored, the counter advanced. -/
theorem LoopFacts.store {S : GlobalState} (h : LoopFacts S r tp n1s n2s ai tbl w1 w2 AI B)
    (hL : Layout r tp n1s n2s ai tbl) (hn : S.alloc.nextFreeBlock ≤ n) :
    LoopFacts ⟨⟨n⟩, (S.mem.storePoint tp T).storePoint r R⟩ r tp n1s n2s ai tbl w1 w2 AI B
    where
  wf := (GlobalState.WF.bump h.wf hn).storePoint_mk.storePoint_mk
  fitR := h.fitR.storePoint.storePoint
  fitT := h.fitT.storePoint.storePoint
  slides1 := (h.slides1.storePoint hL.t1).storePoint hL.r1
  slides2 := (h.slides2.storePoint hL.t2).storePoint hL.r2
  tblA := (h.tblA.storePoint hL.ta).storePoint hL.ra
  tblB := (h.tblB.storePoint hL.tb).storePoint hL.rb

/-- `^bb8`, an iteration's start at `i`: `t = partial_dbl( r )`, then `n1slide[i]`'s add; on to
`^bb12`. -/
theorem head_block (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (w1 : Vector Int 256)
    (AI : Nat → PointLimbs) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat)
    (hi : i < 256) (hd : -15 ≤ w1[i] ∧ w1[i] ≤ 15) (R : PointLimbs) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai a2 tp E) (hRi : E ⊨ [%1632 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hr : S.mem.PointFit r) (htp : S.mem.PointFit tp) (hrt : r.id ≠ tp.id) (hra : r.id ≠ ai.id)
    (hta : tp.id ≠ ai.id) (htn : tp.id ≠ n1s.id) (hn1o : n1s.offset.toNat + 512 < 2 ^ 64)
    (haio : ai.offset.toNat + 160 * 8 < 2 ^ 64) (hrv : S.mem.readPoint r = R)
    (hn1s : SlidesAt S.mem n1s w1) (hai : TableAt S.mem ai 8 AI)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
          LoopRegs tbl n1s n2s ai a2 tp E' →
          (E' ⊨ [%1632 := BitVec.ofNat 64 i]) →
          S' =
            { alloc := ⟨S.alloc.nextFreeBlock + 5 + digitBlocks w1[i]⟩,
              mem := (S.mem.storePoint tp (add1 AI w1[i] R).2).storePoint r (add1 AI w1[i] R).1 } →
          (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb12 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb8 S >>= g) = K := by
  obtain ⟨hf1, hl1⟩ := hn1s i hi
  clear hn1s
  block_init
  step_call using fd_ed25519_partial_dbl.call_eq
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load with transparent d consuming hf1 hl1
  step_pure
  finish_block
  case
    isTrue =>
    have hpos : 0 < w1[i] := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    obtain ⟨k, hk⟩ : ∃ k, (w1[i] / 2).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 8 := by omega
    obtain ⟨hAf, hAr⟩ := hai k hk8
    clear hai
    block_init
    step_call using fd_ed25519_point_add_final_mul.call_eq
    step_pure
    step_pure with idx
    have hidx : idx.toNat = k := by rw [hidx, idx_pos (by omega), hk]
    step_pure [hidx, Nat.mul_comm k 160, show 160 * k < 2 ^ 64 by omega]
    step_pure
    step_pure [flag_one (d := w1[i]) (by omega)]
    step_call using fd_ed25519_point_add_with_opts.call_eq
    finish_block
    refine hK E S hArgs (by env_reads) (by env_reads) ?_
    rw [hS, storePoint_swap htp.1 hrt.symm]
    simp only [add1, addDigit, hpos, ite_true, hk, digitBlocks, show w1[i] ≠ 0 by omega, ite_false]
  case
    isFalse =>
    have hnpos : w1[i] ≤ 0 := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    block_init
    step_pure
    finish_block
    case
      isTrue =>
      have hneg : w1[i] < 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simpa using hbr
      obtain ⟨k, hk⟩ : ∃ k, (-w1[i] / 2).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 8 := by omega
      obtain ⟨hAf, hAr⟩ := hai k hk8
      clear hai
      block_init
      step_call using fd_ed25519_point_add_final_mul.call_eq
      step_pure
      step_pure
      step_pure with idx
      have hidx : idx.toNat = k := by rw [hidx, idx_neg (by omega), hk]
      step_pure [hidx, Nat.mul_comm k 160, show 160 * k < 2 ^ 64 by omega]
      step_pure
      step_pure [flag_neg_one (d := w1[i]) (by omega)]
      step_call using fd_ed25519_point_sub_with_opts.call_eq
      finish_block
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      rw [hS, storePoint_swap htp.1 hrt.symm]
      simp only [add1, addDigit, hneg, show ¬0 < w1[i] by omega, ite_true, ite_false, hk,
        digitBlocks, show w1[i] ≠ 0 by omega]
    case
      isFalse =>
      have h0 : w1[i] = 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simp at hbr
        omega
      clear hai
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      simp only [add1, addDigit, h0, lt_irrefl, ite_false, digitBlocks, ite_true, Nat.add_zero]
      subst hS
      exact congrArg _ (MemoryState.storePoint_readPoint_self' hr hrv).symm

/-- `^bb12`: `n2slide[i]`'s add; on to `^bb16`. -/
theorem digit2_block (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (w2 : Vector Int 256)
    (B : Nat → PointLimbs) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat)
    (hi : i < 256) (hd : -255 ≤ w2[i] ∧ w2[i] ≤ 255) (R T : PointLimbs) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai a2 tp E) (hRi : E ⊨ [%1632 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hr : S.mem.PointFit r) (htp : S.mem.PointFit tp) (hrt : r.id ≠ tp.id) (hrb : r.id ≠ tbl.id)
    (hn2o : n2s.offset.toNat + 512 < 2 ^ 64) (htbo : tbl.offset.toNat + 160 * 128 < 2 ^ 64)
    (hrv : S.mem.readPoint r = R) (htv : S.mem.readPoint tp = T) (hn2s : SlidesAt S.mem n2s w2)
    (htbl : TableAt S.mem tbl 128 B)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
          LoopRegs tbl n1s n2s ai a2 tp E' →
          (E' ⊨ [%1632 := BitVec.ofNat 64 i]) →
          S' =
            { alloc := ⟨S.alloc.nextFreeBlock + digitBlocks w2[i]⟩,
              mem :=
                (S.mem.storePoint tp (addDigit B w2[i] 1#32 1#32 R T).2).storePoint r
                  (addDigit B w2[i] 1#32 1#32 R T).1 } →
          (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb16 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb12 S >>= g) = K := by
  obtain ⟨hf2, hl2⟩ := hn2s i hi
  clear hn2s
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load with transparent d consuming hf2 hl2
  step_pure
  finish_block
  case
    isTrue =>
    have hpos : 0 < w2[i] := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    obtain ⟨k, hk⟩ : ∃ k, (w2[i] / 2).toNat = k := ⟨_, rfl⟩
    have hk8 : k < 128 := by omega
    obtain ⟨hBf, hBr⟩ := htbl k hk8
    clear htbl
    block_init
    step_call using fd_ed25519_point_add_final_mul.call_eq
    step_pure
    step_pure with idx
    have hidx : idx.toNat = k := by rw [hidx, idx_pos (by omega), hk]
    step_pure [hidx, Nat.mul_comm k 160, show 160 * k < 2 ^ 64 by omega]
    step_call using fd_ed25519_point_add_with_opts.call_eq
    finish_block
    refine hK E S hArgs (by env_reads) (by env_reads) ?_
    rw [hS, MemoryState.storePoint_comm hrt]
    simp only [addDigit, hpos, ite_true, hk, digitBlocks, show w2[i] ≠ 0 by omega, ite_false]
  case
    isFalse =>
    have hnpos : w2[i] ≤ 0 := by
      rw [slt_zero_ofInt16 (by omega)] at hbr
      simpa using hbr
    block_init
    step_pure
    finish_block
    case
      isTrue =>
      have hneg : w2[i] < 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simpa using hbr
      obtain ⟨k, hk⟩ : ∃ k, (-w2[i] / 2).toNat = k := ⟨_, rfl⟩
      have hk8 : k < 128 := by omega
      obtain ⟨hBf, hBr⟩ := htbl k hk8
      clear htbl
      block_init
      step_call using fd_ed25519_point_add_final_mul.call_eq
      step_pure
      step_pure
      step_pure with idx
      have hidx : idx.toNat = k := by rw [hidx, idx_neg (by omega), hk]
      step_pure [hidx, Nat.mul_comm k 160, show 160 * k < 2 ^ 64 by omega]
      step_call using fd_ed25519_point_sub_with_opts.call_eq
      finish_block
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      rw [hS, MemoryState.storePoint_comm hrt]
      simp only [addDigit, hneg, show ¬0 < w2[i] by omega, ite_true, ite_false, hk, digitBlocks,
        show w2[i] ≠ 0 by omega]
    case
      isFalse =>
      have h0 : w2[i] = 0 := by
        rw [ofInt16_slt_zero (by omega)] at hbr
        simp at hbr
        omega
      clear htbl
      refine hK E S hArgs (by env_reads) (by env_reads) ?_
      simp only [addDigit, h0, lt_irrefl, ite_false, digitBlocks, ite_true, Nat.add_zero]
      subst hS
      rw [MemoryState.storePoint_readPoint_self' htp htv,
        MemoryState.storePoint_readPoint_self' hr hrv]

/-- `^bb16`: `r`'s last multiplication, with `T` only at `i == 0`; then out, or around at
`i - 1`. -/
theorem tail_block (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (R T : PointLimbs) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai a2 tp E) (hRi : E ⊨ [%1632 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (hr : S.mem.PointFit r) (htp : S.mem.PointFit tp) (hrt : r.id ≠ tp.id)
    (hrv : S.mem.readPoint r = R) (htv : S.mem.readPoint tp = T)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            LoopRegs tbl n1s n2s ai a2 tp E' →
            S' = { S with mem := S.mem.storePoint r (fd_ed25519_point_add_final_mul.spec T) } →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb19 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              LoopRegs tbl n1s n2s ai a2 tp E' →
              (E' ⊨ [%1632 := BitVec.ofNat 64 j]) →
              S' =
                { S with
                  mem :=
                    S.mem.storePoint r (fd_ed25519_point_add_final_mul_projective.spec T R.T) } →
              (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb8 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb16 S >>= g) = K := by
  have hrT : S.mem.readLimbs (r.add 80#64) = R.T := by
    rw [← hrv]; rfl
  clear hrv
  block_init
  step_pure
  finish_block
  case isTrue =>
    have hi0 : i = 0 := eq_zero_of_ofNat64 (by omega) hbr
    block_init
    step_call using fd_ed25519_point_add_final_mul.call_eq
    finish_block
    exact hexit hi0 E S hArgs (by env_reads) (by rw [hS])
  case isFalse =>
    have hi0 : 1 ≤ i := Nat.one_le_iff_ne_zero.mpr fun h => hbr (by rw [h])
    block_init
    step_call using fd_ed25519_point_add_final_mul_projective.call_eq
    step_pure [saddOverflow_neg_one64 hi0 (by omega), add_neg_one64 hi0 (by omega)]
    step_pure [slt_ofNat64 hi0 (by omega)]
    finish_block
    refine hback (i - 1) (by omega) E S hArgs (by env_reads) (by env_reads) (by rw [hS])

/-- An iteration of the main loop at `i`: `r` and `t` stored by the adds, then `r` again. -/
theorem main_iter (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → PointLimbs) (hL : Layout r tp n1s n2s ai tbl)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (R : PointLimbs) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai a2 tp E) (hRi : E ⊨ [%1632 := BitVec.ofNat 64 i])
    (hF : LoopFacts S r tp n1s n2s ai tbl w1 w2 AI B) (hrv : S.mem.readPoint r = R)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            LoopRegs tbl n1s n2s ai a2 tp E' →
            S' =
              { alloc := ⟨S.alloc.nextFreeBlock + 5 + digitBlocks w1[i] + digitBlocks w2[i]⟩,
                mem :=
                  (S.mem.storePoint tp (adds AI B w1[i] w2[i] R).2).storePoint r
                    (fd_ed25519_point_add_final_mul.spec (adds AI B w1[i] w2[i] R).2) } →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb19 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              LoopRegs tbl n1s n2s ai a2 tp E' →
              (E' ⊨ [%1632 := BitVec.ofNat 64 j]) →
              S' =
                { alloc := ⟨S.alloc.nextFreeBlock + 5 + digitBlocks w1[i] + digitBlocks w2[i]⟩,
                  mem :=
                    (S.mem.storePoint tp (adds AI B w1[i] w2[i] R).2).storePoint r
                      (fd_ed25519_point_add_final_mul_projective.spec (adds AI B w1[i] w2[i] R).2
                        (adds AI B w1[i] w2[i] R).1.T) } →
              (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb8 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb8 S >>= g) = K := by
  refine
    head_block r n1 a n2 tbl n1s n2s ai a2 tp w1 AI g K i hi (hw1 i hi) R S E hArgs hR hRi hF.wf
      hF.fitR hF.fitT hL.rt hL.ra hL.ta hL.t1 hL.n1o hL.aio hrv hF.slides1 hF.tblA
      fun E₁ S₁ h₁ hR₁ hRi₁ hS₁ => ?_
  have hF₁ :=
    hS₁ ▸
      hF.store (T := (add1 AI w1[i] R).2) (R := (add1 AI w1[i] R).1) hL (n :=
        S.alloc.nextFreeBlock + 5 + digitBlocks w1[i]) (by omega)
  have hrv₁ : S₁.mem.readPoint r = (add1 AI w1[i] R).1 := by
    rw [hS₁]
    exact MemoryState.readPoint_storePoint_self hF.fitR.room.storePoint
  have htv₁ : S₁.mem.readPoint tp = (add1 AI w1[i] R).2 := by
    rw [hS₁]
    dsimp only
    rw [MemoryState.readPoint_storePoint_of_id_ne hL.rt]
    exact MemoryState.readPoint_storePoint_self hF.fitT.room
  refine
    digit2_block r n1 a n2 tbl n1s n2s ai a2 tp w2 B g K i hi (hw2 i hi) _ _ S₁ E₁ h₁ hR₁ hRi₁
      hF₁.wf hF₁.fitR hF₁.fitT hL.rt hL.rb hL.n2o hL.tbo hrv₁ htv₁ hF₁.slides2 hF₁.tblB
      fun E₂ S₂ h₂ hR₂ hRi₂ hS₂ => ?_
  have hF₂ :=
    hS₂ ▸
      hF₁.store (T := (adds AI B w1[i] w2[i] R).2) (R := (adds AI B w1[i] w2[i] R).1) hL (n :=
        S₁.alloc.nextFreeBlock + digitBlocks w2[i]) (by omega)
  have hrv₂ : S₂.mem.readPoint r = (adds AI B w1[i] w2[i] R).1 := by
    rw [hS₂]
    exact MemoryState.readPoint_storePoint_self hF₁.fitR.room.storePoint
  have htv₂ : S₂.mem.readPoint tp = (adds AI B w1[i] w2[i] R).2 := by
    rw [hS₂]
    dsimp only
    rw [MemoryState.readPoint_storePoint_of_id_ne hL.rt]
    exact MemoryState.readPoint_storePoint_self hF₁.fitT.room
  refine
      tail_block r n1 a n2 tbl n1s n2s ai a2 tp g K i hi _ _ S₂ E₂ h₂ hR₂ hRi₂ hF₂.wf hF₂.fitR
        hF₂.fitT hL.rt hrv₂ htv₂ (fun h0 E₃ S₃ h₃ hR₃ hS₃ => hexit h0 E₃ S₃ h₃ hR₃ (hS₃.trans ?_))
        (fun j hj E₃ S₃ h₃ hR₃ hRi₃ hS₃ => hback j hj E₃ S₃ h₃ hR₃ hRi₃ (hS₃.trans ?_)) <;>
    · subst hS₂ hS₁
      dsimp only
      rw [storePoint_canon hF.fitT.1 hF.fitR.1 hL.rt.symm]
      rfl

/-- The main loop from `^bb8` at `i`: `r` the ladder from `i` down, `t` some point. -/
theorem main_loop (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → PointLimbs) (hL : Layout r tp n1s n2s ai tbl)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (hi : i < 256) (R : PointLimbs) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
        LoopRegs tbl n1s n2s ai a2 tp E →
        (E ⊨ [%1632 := BitVec.ofNat 64 i]) →
        LoopFacts S r tp n1s n2s ai tbl w1 w2 AI B →
        S.mem.readPoint r = R →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState) (T' : PointLimbs),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            LoopRegs tbl n1s n2s ai a2 tp E' →
            S' =
              { alloc := ⟨S.alloc.nextFreeBlock + ladderBlocks w1 w2 i hi⟩,
                mem := (S.mem.storePoint tp T').storePoint r (ladder AI B w1 w2 i hi R) } →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb19 S' >>= g) = K) →
        (fd_ed25519_double_scalar_mul_base.runFrom E ^bb8 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi R S E hArgs hR hRi hF hrv hK
    exact
      main_iter r n1 a n2 tbl n1s n2s ai a2 tp w1 w2 AI B hL hw1 hw2 g K 0 hi R S E hArgs hR hRi hF
        hrv
        (fun _ E' S' h₁ hR' hS' =>
          hK E' S' (adds AI B w1[0] w2[0] R).2 h₁ hR'
            (hS'.trans (by simp only [ladderBlocks, ladder, Nat.add_assoc])))
        (fun j hj => absurd hj (by omega))
  | succ j ih =>
    intro hi R S E hArgs hR hRi hF hrv hK
    refine
      main_iter r n1 a n2 tbl n1s n2s ai a2 tp w1 w2 AI B hL hw1 hw2 g K (j + 1) hi R S E hArgs hR
        hRi hF hrv (fun h => absurd h (by omega)) fun j' hj E' S' h₁ hR' hRi' hS' => ?_
    obtain rfl : j = j' := by omega
    have hF' :=
      hS' ▸
        hF.store (T := (adds AI B w1[j + 1] w2[j + 1] R).2) hL (n :=
          S.alloc.nextFreeBlock + 5 + digitBlocks w1[j + 1] + digitBlocks w2[j + 1]) (by omega)
    refine
      ih (by omega)
        (fd_ed25519_point_add_final_mul_projective.spec (adds AI B w1[j + 1] w2[j + 1] R).2
          (adds AI B w1[j + 1] w2[j + 1] R).1.T)
        S' E' h₁ hR' hRi' hF' ?_ fun E'' S'' T'' h₂ hR'' hS'' =>
        hK E'' S'' T'' h₂ hR'' (hS''.trans ?_)
    · rw [hS']
      exact MemoryState.readPoint_storePoint_self hF.fitR.room.storePoint
    · subst hS'
      dsimp only
      rw [storePoint_swap hF.fitT.1 hL.rt.symm, MemoryState.storePoint_storePoint_self hF.fitR.1]
      simp only [ladderBlocks, ladder, Nat.add_assoc]

/-! ### The zero-digit search -/

/-- `^bb3`, the zero-digit search at `i`: on to the main loop at a non-zero digit, out after `0`,
else around. -/
theorem skip_iter (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (w1 w2 : Vector Int 256)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi : i < 256)
    (hd1 : (-15 : Int) ≤ w1[i] ∧ w1[i] ≤ 15) (hd2 : (-255 : Int) ≤ w2[i] ∧ w2[i] ≤ 255)
    (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : LoopRegs tbl n1s n2s ai a2 tp E)
    (hR' : E ⊨ [%1602 := 0#32, %1596 := 4294967295#32, %1620 := BitVec.ofNat 32 i])
    (hn1s : SlidesAt S.mem n1s w1) (hn2s : SlidesAt S.mem n2s w2)
    (hfound :
      ¬(w1[i] = 0 ∧ w2[i] = 0) →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            LoopRegs tbl n1s n2s ai a2 tp E' →
            (E' ⊨ [%1632 := BitVec.ofNat 64 i]) →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb8 S >>= g) = K)
    (hnone :
      w1[i] = 0 ∧ w2[i] = 0 →
        i = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            LoopRegs tbl n1s n2s ai a2 tp E' →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb19 S >>= g) = K)
    (hback :
      w1[i] = 0 ∧ w2[i] = 0 →
        ∀ j,
          i = j + 1 →
            ∀ E' : ⟪Γ⟫,
              E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
                LoopRegs tbl n1s n2s ai a2 tp E' →
                (E' ⊨ [%1602 := 0#32, %1596 := 4294967295#32, %1620 := BitVec.ofNat 32 j]) →
                (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb3 S >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb3 S >>= g) = K := by
  obtain ⟨hf1, hl1⟩ := hn1s i hi
  obtain ⟨hf2, hl2⟩ := hn2s i hi
  clear hn1s hn2s
  block_init
  step_pure [msb_ofNat32 (show i < 2 ^ 31 by omega), setWidth_ofNat32 (show i < 2 ^ 32 by omega)]
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load consuming hf1 hl1
  step_pure
  finish_block
  case isTrue =>
    have h1 : w1[i] = 0 := (ofInt16_eq_zero (by omega)).1 hbr
    block_init
    step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
      show i * 2 = 2 * i by omega]
    step_load consuming hf2 hl2
    step_pure
    finish_block
    case isTrue =>
      have h2 : w2[i] = 0 := (ofInt16_eq_zero (by omega)).1 hbr
      block_init
      step_pure [saddOverflow_neg_one32 (show i < 2 ^ 31 by omega)]
      step_pure
      finish_block
      case isTrue => step_loop using hnone ⟨h1, h2⟩ (eq_zero_of_ofNat32 (by omega) hbr)
      case isFalse =>
        have hi0 : 1 ≤ i := Nat.one_le_iff_ne_zero.mpr fun h => hbr (by rw [h])
        subst hS
        refine hback ⟨h1, h2⟩ (i - 1) (by omega) E hArgs (by env_reads) ?_
        rw [← add_neg_one32 hi0 (by omega)]
        env_reads
    case isFalse =>
      have h2 : ¬w2[i] = 0 := fun h => hbr ((ofInt16_eq_zero (by omega)).2 h)
      block_init
      step_pure [slt_neg_one32 (show i < 2 ^ 31 by omega)]
      finish_block
      block_init
      step_pure [msb_ofNat32 (show i < 2 ^ 31 by omega),
        setWidth_ofNat32 (show i < 2 ^ 32 by omega)]
      finish_block
      subst hS
      exact hfound (fun h => h2 h.2) E hArgs (by env_reads) (by env_reads)
  case isFalse =>
    have h1 : ¬w1[i] = 0 := fun h => hbr ((ofInt16_eq_zero (by omega)).2 h)
    block_init
    step_pure [slt_neg_one32 (show i < 2 ^ 31 by omega)]
    finish_block
    block_init
    step_pure [msb_ofNat32 (show i < 2 ^ 31 by omega), setWidth_ofNat32 (show i < 2 ^ 32 by omega)]
    finish_block
    subst hS
    exact hfound (fun h => h1 h.1) E hArgs (by env_reads) (by env_reads)

/-- The zero-digit search from `^bb3` at `i`: the main loop from `start`, or out without one. -/
theorem skip_loop (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (w1 w2 : Vector Int 256)
    (hw1 : ∀ k (hk : k < 256), (-15 : Int) ≤ w1[k] ∧ w1[k] ≤ 15)
    (hw2 : ∀ k (hk : k < 256), (-255 : Int) ≤ w2[k] ∧ w2[k] ≤ 255)
    (hn1o : n1s.offset.toNat + 512 < 2 ^ 64) (hn2o : n2s.offset.toNat + 512 < 2 ^ 64)
    (S : GlobalState) (hn1s : SlidesAt S.mem n1s w1) (hn2s : SlidesAt S.mem n2s w2)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ i (hi : i < 256) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
        LoopRegs tbl n1s n2s ai a2 tp E →
        (E ⊨ [%1602 := 0#32, %1596 := 4294967295#32, %1620 := BitVec.ofNat 32 i]) →
        (∀ j,
          start w1 w2 i hi = some j →
            ∀ E' : ⟪Γ⟫,
              E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
                LoopRegs tbl n1s n2s ai a2 tp E' →
                (E' ⊨ [%1632 := BitVec.ofNat 64 j.val]) →
                (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb8 S >>= g) = K) →
        (start w1 w2 i hi = none →
          ∀ E' : ⟪Γ⟫,
            E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
              LoopRegs tbl n1s n2s ai a2 tp E' →
              (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb19 S >>= g) = K) →
        (fd_ed25519_double_scalar_mul_base.runFrom E ^bb3 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi E hArgs hR hR' hfound hnone
    refine
      skip_iter r n1 a n2 tbl n1s n2s ai a2 tp w1 w2 hn1o hn2o g K 0 hi (hw1 0 hi) (hw2 0 hi) S E
        hArgs hR hR' hn1s hn2s (fun h => hfound 0 (by simp [start, h]))
        (fun h _ => hnone (by simp [start, h])) fun _ j hj => absurd hj (by omega)
  | succ j ih =>
    intro hi E hArgs hR hR' hfound hnone
    refine
      skip_iter r n1 a n2 tbl n1s n2s ai a2 tp w1 w2 hn1o hn2o g K (j + 1) hi (hw1 _ hi) (hw2 _ hi)
        S E hArgs hR hR' hn1s hn2s (fun h => hfound ⟨j + 1, hi⟩ (by simp [start, h]))
        (fun _ h => absurd h (by omega)) fun h j' hj E' h₁ h₂ h₃ => ?_
    obtain rfl : j = j' := by omega
    have hs : start w1 w2 (j + 1) hi = start w1 w2 j (by omega) := by simp [start, h]
    exact
      ih (by omega) E' h₁ h₂ h₃ (fun j'' h' => hfound j'' (hs.trans h')) fun h' =>
        hnone (hs.trans h')

/-! ### The table loop -/

/-- One table-loop iteration's effect at `i`: `t = a2 + ai[i-1]`, then `ai[i]` from it; thirteen
blocks. -/
abbrev tableStep (tp ai : Pointer) (A2 P : PointLimbs) (i : Nat) (S : GlobalState) : GlobalState :=
  let t := fd_ed25519_point_add_with_opts.spec A2 P (if i = 1 then 1#32 else 0#32) 1#32 1#32
  { alloc := ⟨S.alloc.nextFreeBlock + 13⟩,
    mem :=
      (S.mem.storePoint tp t).storePoint (ai.add (BitVec.ofNat 64 (160 * i)))
        (fd_curve25519_into_precomputed.spec (fd_ed25519_point_add_final_mul.spec t)) }

/-- `^bb2`, the table loop at `i`: `t = a2 + ai[i-1]`, `ai[i]` from it; then around or on to
`^bb1`. -/
theorem table_iter (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (A2 P : PointLimbs)
    (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β) (i : Nat) (hi1 : 1 ≤ i)
    (hi : i < 8) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get)
    (hR : EntryRegs tbl n1s n2s ai a2 tp E) (hRi : E ⊨ [%1611 := BitVec.ofNat 64 i]) (hwf : S.WF)
    (ha2 : S.mem.PointFit a2) (htp : S.mem.PointRoom tp)
    (hP : S.mem.PointFit (ai.add (BitVec.ofNat 64 (160 * (i - 1)))))
    (hQ : S.mem.PointRoom (ai.add (BitVec.ofNat 64 (160 * i)))) (htai : tp.id ≠ ai.id)
    (ha2v : S.mem.readPoint a2 = A2)
    (hPv : S.mem.readPoint (ai.add (BitVec.ofNat 64 (160 * (i - 1)))) = P)
    (hexit :
      i + 1 = 8 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            EntryRegs tbl n1s n2s ai a2 tp E' →
            S' = tableStep tp ai A2 P i S →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb1 S' >>= g) = K)
    (hback :
      i + 1 < 8 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            EntryRegs tbl n1s n2s ai a2 tp E' →
            (E' ⊨ [%1611 := BitVec.ofNat 64 (i + 1)]) →
            S' = tableStep tp ai A2 P i S →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb2 S' >>= g) = K) :
    (fd_ed25519_double_scalar_mul_base.runFrom E ^bb2 S >>= g) = K := by
  dsimp only [EntryRegs] at hR
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), Nat.mul_comm i 160,
    show 160 * i < 2 ^ 64 by omega]
  step_pure [off_prev (c := 18446744073709551456) rfl hi1 (show 160 * i < 2 ^ 64 by omega)]
  step_pure
  step_pure [flag64_one (show i < 2 ^ 64 by omega)]
  step_call using fd_ed25519_point_add_with_opts.call_eq
  step_call using fd_ed25519_point_add_final_mul.call_eq
  step_call using fd_curve25519_into_precomputed.call_eq
  step_pure [saddOverflow_one64 (show i + 1 < 2 ^ 63 by omega),
    uaddOverflow_one64 (show i + 1 < 2 ^ 64 by omega), ← BitVec.ofNat_add]
  step_pure
  finish_block
  case
    isTrue =>
    have h8 : i + 1 = 8 := by
      have := congrArg BitVec.toNat hbr
      simp only [BitVec.toNat_ofNat] at this
      omega
    refine hexit h8 E S hArgs (by env_reads) ?_
    subst hS
    rw [MemoryState.storePoint_storePoint_self hQ.1]
  case
    isFalse =>
    have h8 : i + 1 < 8 := by
      by_contra h
      exact hbr (by rw [show i + 1 = 8 by omega])
    refine hback h8 E S hArgs (by env_reads) (by env_reads) ?_
    subst hS
    rw [MemoryState.storePoint_storePoint_self hQ.1]

/-- The table loop's objects: `t` and `ai` apart from what they must not touch. -/
structure TableLayout (tp n1s n2s ai tbl a2 : Pointer) : Prop where
  ta : tp.id ≠ ai.id
  ta2 : tp.id ≠ a2.id
  aa2 : ai.id ≠ a2.id
  t1 : tp.id ≠ n1s.id
  a1 : ai.id ≠ n1s.id
  t2 : tp.id ≠ n2s.id
  a2' : ai.id ≠ n2s.id
  tb : tp.id ≠ tbl.id
  ab : ai.id ≠ tbl.id
  aio : ai.offset.toNat + 160 * 8 < 2 ^ 64

/-- What the table loop needs of a state at `i`: `ai[0 … i-1]` in place, `a2` holding `A2`, and the
main loop's other facts. -/
structure TableFacts (S : GlobalState) (r tp n1s n2s ai tbl a2 : Pointer) (w1 w2 : Vector Int 256)
    (AI B : Nat → PointLimbs) (A2 : PointLimbs) (i : Nat) : Prop where
  wf : S.WF
  roomR : S.mem.PointRoom r
  roomT : S.mem.PointRoom tp
  fitA2 : S.mem.PointFit a2
  roomAI : Room S.mem ai (1280 * 8)
  a2v : S.mem.readPoint a2 = A2
  slides1 : SlidesAt S.mem n1s w1
  slides2 : SlidesAt S.mem n2s w2
  tblA : TableAt S.mem ai i AI
  tblB : TableAt S.mem tbl 128 B

/-- `TableFacts` after an iteration: entry `i` stored. -/
theorem TableFacts.step {S : GlobalState}
    (h : TableFacts S r tp n1s n2s ai tbl a2 w1 w2 (aiTable A2 AI0) B A2 i)
    (hL : TableLayout tp n1s n2s ai tbl a2) (hi1 : 1 ≤ i) (hi : i < 8) :
    TableFacts (tableStep tp ai A2 (aiTable A2 AI0 (i - 1)) i S) r tp n1s n2s ai tbl a2 w1 w2
      (aiTable A2 AI0) B A2 (i + 1)
    where
  wf :=
    (GlobalState.WF.bump h.wf (n := S.alloc.nextFreeBlock + 13)
          (by omega)).storePoint_mk |>.storePoint_mk
  roomR := h.roomR.storePoint.storePoint
  roomT := h.roomT.storePoint.storePoint
  fitA2 := h.fitA2.storePoint.storePoint
  roomAI := Room.storePoint (Room.storePoint h.roomAI)
  a2v := by
    rw [MemoryState.readPoint_storePoint_of_id_ne (by simpa [Pointer.add_id] using hL.aa2),
      MemoryState.readPoint_storePoint_of_id_ne hL.ta2, h.a2v]
  slides1 := (h.slides1.storePoint hL.t1).storePoint_add hL.a1
  slides2 := (h.slides2.storePoint hL.t2).storePoint_add hL.a2'
  tblB := (h.tblB.storePoint hL.tb).storePoint_add hL.ab
  tblA := fun k hk => by
    have := hL.aio
    rcases Nat.lt_or_ge k i with hki | hki
    · refine ⟨(h.tblA k hki).1.storePoint.storePoint, ?_⟩
      rw [readPoint_storePoint_apart (by omega) (by omega) (by omega),
        MemoryState.readPoint_storePoint_of_id_ne (by simpa [Pointer.add_id] using hL.ta)]
      exact (h.tblA k hki).2
    · obtain rfl : k = i := by omega
      have hroom :=
        (PointRoom.entry h.roomAI hL.aio hi).storePoint (p := tp) (P :=
          fd_ed25519_point_add_with_opts.spec A2 (aiTable A2 AI0 (k - 1))
            (if k = 1 then 1#32 else 0#32) 1#32 1#32)
      refine ⟨MemoryState.PointFit.storePoint_self hroom, ?_⟩
      rw [MemoryState.readPoint_storePoint_self hroom]
      obtain ⟨j, rfl⟩ : ∃ j, k = j + 1 := ⟨k - 1, by omega⟩
      simp only [aiTable, Nat.add_sub_cancel, Nat.add_eq_right]

/-- The table loop's stores are in the frame. -/
theorem eraseFrom_tableStep (hNa : N ≤ ai.id.id) (hNt : N ≤ tp.id.id) :
    (tableStep tp ai A2 P i S).mem.eraseFrom N = S.mem.eraseFrom N := by
  dsimp only
  rw [MemoryState.eraseFrom_storePoint_of_le (by simpa [Pointer.add_id] using hNa),
    MemoryState.eraseFrom_storePoint_of_le hNt]

/-- The table loop from `^bb2` at `i`: `ai[i …]` stored; at `^bb1` the main loop's facts hold, and
only the frame changed. -/
theorem table_loop (r n1 a n2 tbl n1s n2s ai a2 tp : Pointer) (w1 w2 : Vector Int 256)
    (A2 AI0 : PointLimbs) (B : Nat → PointLimbs) (N : Nat) (hL : TableLayout tp n1s n2s ai tbl a2)
    (hNa : N ≤ ai.id.id) (hNt : N ≤ tp.id.id) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) :
    ∀ m i (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
        EntryRegs tbl n1s n2s ai a2 tp E →
        (E ⊨ [%1611 := BitVec.ofNat 64 i]) →
        1 ≤ i →
        i + m = 8 →
        i < 8 →
        TableFacts S r tp n1s n2s ai tbl a2 w1 w2 (aiTable A2 AI0) B A2 i →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value n1) (.value a) (.value n2)).get →
            EntryRegs tbl n1s n2s ai a2 tp E' →
            S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 13 * m →
            EntryFacts S' r tp n1s n2s ai tbl w1 w2 (aiTable A2 AI0) B →
            S'.mem.eraseFrom N = S.mem.eraseFrom N →
            (fd_ed25519_double_scalar_mul_base.runFrom E' ^bb1 S' >>= g) = K) →
        (fd_ed25519_double_scalar_mul_base.runFrom E ^bb2 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro i S E _ _ _ _ hm hi; omega
  | succ m ih =>
    intro i S E hArgs hR hRi hi1 hm hi hF hK
    have hstep := hF.step (AI0 := AI0) hL hi1 hi
    refine
      table_iter r n1 a n2 tbl n1s n2s ai a2 tp A2 (aiTable A2 AI0 (i - 1)) g K i hi1 hi S E hArgs
        hR hRi hF.wf hF.fitA2 hF.roomT (hF.tblA (i - 1) (by omega)).1
        (PointRoom.entry hF.roomAI hL.aio hi) hL.ta hF.a2v (hF.tblA (i - 1) (by omega)).2 ?_ ?_
    · intro h8 E' S' h₁ h₂ hS'
      subst hS'
      obtain rfl : m = 0 := by omega
      rw [show i + 1 = 8 from h8] at hstep
      exact
        hK E' _ h₁ h₂ rfl
          ⟨hstep.wf, hstep.roomR, (MemoryState.PointFit.storePoint_self hF.roomT).storePoint,
            hstep.slides1, hstep.slides2, hstep.tblA, hstep.tblB⟩
          (eraseFrom_tableStep hNa hNt)
    · intro h8 E' S' h₁ h₂ h₃ hS'
      subst hS'
      exact
        ih (i + 1) _ E' h₁ h₂ h₃ (by omega) (by omega) h8 hstep
          fun E'' S'' h₁' h₂' halloc hLF herase =>
          hK E'' S'' h₁' h₂'
            (by
              rw [halloc]; dsimp only; omega)
            hLF (herase.trans (eraseFrom_tableStep hNa hNt))

/-! ### The function -/

/-- `spec` without a non-zero digit: the neutral point. -/
theorem spec_of_none {x1 x2 : BitVec 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        none) :
    spec tbl x1 A x2 = fd_ed25519_point_set_zero.spec := by
  unfold spec
  dsimp only
  rw [h]

/-- `blocks` without a non-zero digit. -/
theorem blocks_of_none {x1 x2 : BitVec 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        none) :
    blocks x1 x2 = 110 := by
  unfold blocks
  dsimp only
  rw [h]
  rfl

/-- `spec` from the first non-zero digit `j`: the main loop from `j`. -/
theorem spec_of_some {x1 x2 : BitVec 256} {j : Fin 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        some j) :
    spec tbl x1 A x2 =
      ladder (aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)) tbl
        (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) j j.isLt
        fd_ed25519_point_set_zero.spec := by
  unfold spec
  dsimp only
  rw [h]

/-- `blocks` from the first non-zero digit `j`. -/
theorem blocks_of_some {x1 x2 : BitVec 256} {j : Fin 256}
    (h :
      start (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) 255
          (by decide) =
        some j) :
    blocks x1 x2 =
      110 +
        ladderBlocks (fd_curve25519_scalar_wnaf.wnaf x1 4) (fd_curve25519_scalar_wnaf.wnaf x2 8) j
          j.isLt := by
  unfold blocks
  dsimp only
  rw [h]

end fd_ed25519_double_scalar_mul_base

attribute [local mlir_transport] fd_ed25519_double_scalar_mul_base.TableAt.storePoint
  SlidesAt.storePoint

open fd_ed25519_double_scalar_mul_base in
/-- `fd_ed25519_double_scalar_mul_base` stores `spec` of the scalars at `n1`, `n2` and the point
at `a` at `r` and returns `r`; `r` may be any of the inputs: they are read before it is written.
The block counter advances by `blocks`. -/
public theorem fd_ed25519_double_scalar_mul_base.call_eq (r n1 a n2 : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.PointRoom r) (hn1 : Fits s.mem n1 (8 * 32))
    (hn1o : ¬n1.offset.uaddOverflow 32#64) (ha : s.mem.PointFit a) (hn2 : Fits s.mem n2 (8 * 32))
    (hn2o : ¬n2.offset.uaddOverflow 32#64) :
    fd_ed25519_double_scalar_mul_base.call
        (fd_ed25519_double_scalar_mul_base.args (.value r) (.value n1) (.value a) (.value n2)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + blocks (s.mem.readAt n1 256) (s.mem.readAt n2 256)⟩,
            mem :=
              s.mem.storePoint r
                (spec baseTbl (s.mem.readAt n1 256) (s.mem.readPoint a)
                  (s.mem.readAt n2 256)) }) := by
  -- folded for `func_init`, whose frame-free check would unfold `blocks`
  generalize hP : spec baseTbl (s.mem.readAt n1 256) (s.mem.readPoint a) (s.mem.readAt n2 256) = P
  generalize hk : blocks (s.mem.readAt n1 256) (s.mem.readAt n2 256) = k
  func_init
  -- the inputs, named before the frame grows
  obtain ⟨x1, hx1⟩ : ∃ x, S.mem.readAt n1 256 = x := ⟨_, rfl⟩
  obtain ⟨A, hA⟩ : ∃ A, S.mem.readPoint a = A := ⟨_, rfl⟩
  obtain ⟨x2, hx2⟩ : ∃ x, S.mem.readAt n2 256 = x := ⟨_, rfl⟩
  rw [hx1, hA, hx2] at hP
  rw [hx1, hx2] at hk
  have hr₀ : S₀.mem.PointRoom r := hS ▸ hr
  have hA₀ : S₀.mem.readPoint a = A := hS ▸ hA
  clear hA
  block_init
  iterate 10 step_pure
  step_addressof fd_ed25519_base_point_wnaf_table.value_eq with tbl
  iterate 3 step_pure
  -- `a` past the table's block
  have hA : S.mem.readPoint a = A := by
    rw [hS,
      MemoryState.readPoint_addBlock_of_id_ne
        (by
          rw [htbl] at ha_ne_tbl; exact ha_ne_tbl),
      hA₀]
  clear hA₀
  -- short n1slide[256]; short n2slide[256]; fd_ed25519_point_t ai[8], a2[1], t[1];
  step_alloca with n1s
  step_alloca with n2s
  step_alloca with ai
  step_alloca with a2
  step_alloca with tp
  -- fd_curve25519_scalar_wnaf( n1slide, n1, WNAF_BIT_SZ );
  -- fd_curve25519_scalar_wnaf( n2slide, n2, 8 );
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  step_pure
  step_call using fd_curve25519_scalar_wnaf.call_eq
  iterate 3 step_pure
  have hai_pt := MemoryState.PointRoom.of_room (hroom_ai.mono (by decide)) hai_off
  have ha2_pt := MemoryState.PointRoom.of_room hroom_a2 ha2_off
  have htp_pt := MemoryState.PointRoom.of_room hroom_tp htp_off
  clear hroom_a2 hroom_tp hai_bounds ha2_bounds htp_bounds
  -- fd_ed25519_point_set( &ai[0], a ); fd_ed25519_point_dbln( a2, a, 1 );
  -- fd_curve25519_into_precomputed( &ai[0] );
  step_call using fd_ed25519_point_set.call_eq
  clear hread_ai_readLimbs hread_ai_40 hread_ai_80 hread_ai_120
  step_call using fd_ed25519_point_dbln.call_eq_one consuming hA
  step_call using fd_curve25519_into_precomputed.call_eq consuming hread_ai
  have hsl1 : SlidesAt S.mem n1s (fd_curve25519_scalar_wnaf.wnaf x1 4) :=
    SlidesAt.of_readAt hfits_n1s
      (by
        rw [hn1s_off]; decide)
      hread_n1s
  have hsl2 : SlidesAt S.mem n2s (fd_curve25519_scalar_wnaf.wnaf x2 8) :=
    SlidesAt.of_readAt hfits_n2s
      (by
        rw [hn2s_off]; decide)
      hread_n2s
  have htblB : TableAt S.mem tbl 128 baseTbl :=
    TableAt.of_readAt htbl_fits hread_tbl
      (by
        rw [htbl_off]; decide)
      rfl
  clear_reads
  finish_block
  have hTL : TableLayout tp n1s n2s ai tbl a2 :=
    ⟨by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by mem_fact, by
      mem_fact, by mem_fact, by
      rw [hai_off]; decide⟩
  have hF :
    TableFacts S r tp n1s n2s ai tbl a2 (fd_curve25519_scalar_wnaf.wnaf x1 4)
      (fd_curve25519_scalar_wnaf.wnaf x2 8)
      (aiTable (fd_ed25519_point_dbln.spec A 1) (fd_curve25519_into_precomputed.spec A)) baseTbl
      (fd_ed25519_point_dbln.spec A 1) 1 :=
    ⟨hwf, hr, htp_pt, ha2_pt, hroom_ai, hread_a2, hsl1, hsl2, fun k hk => by
      obtain rfl : k = 0 := by omega
      simpa [Pointer.add_zero', aiTable] using And.intro hai_pt hread_ai, htblB⟩
  clear hread_a2 hread_ai hsl1 hsl2 htblB
  -- for( int i=1; i<WNAF_TBL_SZ; i++ ) { … }
  refine
    table_loop r n1 a n2 tbl n1s n2s ai a2 tp _ _ _ _ baseTbl S₀.alloc.nextFreeBlock hTL
      (by slot_bound) (by slot_bound) _ _ 7 1 S E hArgs (by env_reads) (by env_reads) (by decide)
      (by decide) (by decide) hF fun E' S' h₁ h₂ halloc hLF herase => ?_
  clear hF hwf hr htp_pt ha2_pt hai_pt hroom_ai hn1 hn2 ha htbl_fits
  obtain ⟨hwf, hr, htp_pt, hsl1, hsl2, htA, htB⟩ := hLF
  dsimp only [EntryRegs] at h₂
  -- fd_ed25519_point_set_zero( r );
  block_init
  step_call using fd_ed25519_point_set_zero.call_eq
  finish_block
  have hrz : S.mem.readPoint r = fd_ed25519_point_set_zero.spec := hread_r
  clear_reads
  have hL : Layout r tp n1s n2s ai tbl :=
    ⟨hr_ne_tp, hr_ne_n1s, hr_ne_n2s, hr_ne_ai, hr_ne_tbl, by mem_fact, by mem_fact, by mem_fact, by
      mem_fact, by
      rw [hn1s_off]; decide, by
      rw [hn2s_off]; decide, by
      rw [hai_off]; decide, by
      rw [htbl_off]; decide⟩
  have hw1 := fun k hk => (fd_curve25519_scalar_wnaf.wnaf4_digits x1 k hk).2
  have hw2 := fun k hk => (fd_curve25519_scalar_wnaf.wnaf8_digits x2 k hk).2
  -- for( i=255; i>=0; i-- ) { if( n1slide[i] || n2slide[i] ) break; }
  refine
    skip_loop r n1 a n2 tbl n1s n2s ai a2 tp _ _ hw1 hw2 hL.n1o hL.n2o S hsl1 hsl2 _ _ 255
      (by decide) E hArgs (by env_reads) (by env_reads) ?_ ?_
  · -- the main loop from the first non-zero digit
    intro j hj E₂ h₁ h₂ h₃
    refine
      main_loop r n1 a n2 tbl n1s n2s ai a2 tp _ _ _ _ hL hw1 hw2 _ _ j.val j.isLt _ S E₂ h₁ h₂ h₃
        ⟨hwf, hr, htp_pt, hsl1, hsl2, htA, htB⟩ hrz fun E₃ S₃ T' h₁' hR₃ hS₃ => ?_
    -- the lifetimes' ends: of the objects only `r` and the state's `WF` are left
    clear htp_pt hsl1 hsl2 htA htB hrz hTL hL
    block_init
    iterate 5 step_pure
    finish_block
    rw [← hk, ← hP, blocks_of_some hj, spec_of_some hj]
    clear hwf hr
    subst hS
    dsimp only
    rw [MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ n1s.id.id by slot_bound),
      MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ n2s.id.id by slot_bound),
      MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ ai.id.id by slot_bound),
      MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ a2.id.id by slot_bound),
      MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound),
      MemoryState.eraseFrom_storePoint,
      MemoryState.eraseFrom_storePoint_of_le (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound)]
    subst hS
    dsimp only
    rw [MemoryState.eraseFrom_storePoint, herase, halloc,
      MemoryState.storePoint_storePoint_self hr₀.1]
    clear herase halloc
    subst hS
    erase_frame
    simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd, Nat.reduceMul]
  · -- no non-zero digit: `r` is zero
    intro hj E₂ h₁ hR₂
    clear htp_pt hsl1 hsl2 htA htB hrz hTL hL
    block_init
    iterate 5 step_pure
    finish_block
    rw [← hk, ← hP, blocks_of_none hj, spec_of_none hj]
    subst hS
    dsimp only
    rw [MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ n1s.id.id by slot_bound),
      MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ n2s.id.id by slot_bound),
      MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ ai.id.id by slot_bound),
      MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ a2.id.id by slot_bound),
      MemoryState.eraseFrom_lifetimeEnd_of_le
        (show S₀.alloc.nextFreeBlock ≤ tp.id.id by slot_bound),
      MemoryState.eraseFrom_storePoint, herase, halloc]
    clear hwf hr herase halloc h₂ hArgs h₁
    subst hS
    erase_frame
    simp only [GlobalState.alloca]

end Proof

end MLIR.Firedancer.Ref
