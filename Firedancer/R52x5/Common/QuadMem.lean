module

public import Firedancer.R52x5.Common.Limbs
public import Firedancer.R52x5.Common.Quad
import Std.Data.ExtHashMap.Lemmas

/-! A `wl_t` (32 bytes) and an `FD_R52X5_QUAD` point in memory: five `wl_t`s at byte offsets 0, 32,
64, 96, 128 (192-byte `fd_ed25519_point_t`, the last 32 bytes padding), or at five callee
out-pointers. -/

namespace MLIR

@[expose] public section

open Firedancer.R52x5

/-- Store `Q0 … Q4` at `t0 … t4`, `Q0` first: a callee's five out-pointers. -/
def MemoryState.storeTmp5 (m : MemoryState) (t0 t1 t2 t3 t4 : Pointer) (Q : Quad5) : MemoryState :=
  ((((m.storeWv t0 Q.P0).storeWv t1 Q.P1).storeWv t2 Q.P2).storeWv t3 Q.P3).storeWv t4 Q.P4

/-- Store a point at `p`, `Q0` first, as the code does. -/
def MemoryState.storeQuad5 (m : MemoryState) (p : Pointer) (Q : Quad5) : MemoryState :=
  m.storeTmp5 p (p.add 32#64) (p.add 64#64) (p.add 96#64) (p.add 128#64) Q

/-- The point at `p`. -/
def MemoryState.readQuad5 (m : MemoryState) (p : Pointer) : Quad5 :=
  ⟨m.readWv p, m.readWv (p.add 32#64), m.readWv (p.add 64#64), m.readWv (p.add 96#64),
    m.readWv (p.add 128#64)⟩

/-- The point at `p` fits: its offsets do not wrap, and each `wl_t` fits. Spelled out at the
offsets `getelementptr` produces, so the steps find each conjunct. -/
abbrev MemoryState.Quad5Fit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 160 ≤ 2 ^ 64 ∧
    Fits m p 256 ∧
    Fits m (p.add 32#64) 256 ∧
    Fits m (p.add 64#64) 256 ∧ Fits m (p.add 96#64) 256 ∧ Fits m (p.add 128#64) 256

/-- Room for the point at `p` (an output), and its offsets do not wrap. -/
abbrev MemoryState.Quad5Room (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 160 ≤ 2 ^ 64 ∧
    Room m p 256 ∧
    Room m (p.add 32#64) 256 ∧
    Room m (p.add 64#64) 256 ∧ Room m (p.add 96#64) 256 ∧ Room m (p.add 128#64) 256

attribute [mlir_mem] MemoryState.Quad5Fit MemoryState.Quad5Room

theorem MemoryState.Quad5Fit.room {m : MemoryState} (h : m.Quad5Fit p) : m.Quad5Room p :=
  ⟨h.1, h.2.1.room, h.2.2.1.room, h.2.2.2.1.room, h.2.2.2.2.1.room, h.2.2.2.2.2.room⟩

/-! ### Fit -/

@[mlir_transport]
theorem MemoryState.Quad5Fit.fits_0 {m : MemoryState} (h : m.Quad5Fit p) : Fits m p 256 :=
  h.2.1

@[mlir_transport]
theorem MemoryState.Quad5Fit.fits_1 {m : MemoryState} (h : m.Quad5Fit p) :
    Fits m (p.add 32#64) 256 :=
  h.2.2.1

@[mlir_transport]
theorem MemoryState.Quad5Fit.fits_2 {m : MemoryState} (h : m.Quad5Fit p) :
    Fits m (p.add 64#64) 256 :=
  h.2.2.2.1

@[mlir_transport]
theorem MemoryState.Quad5Fit.fits_3 {m : MemoryState} (h : m.Quad5Fit p) :
    Fits m (p.add 96#64) 256 :=
  h.2.2.2.2.1

@[mlir_transport]
theorem MemoryState.Quad5Fit.fits_4 {m : MemoryState} (h : m.Quad5Fit p) :
    Fits m (p.add 128#64) 256 :=
  h.2.2.2.2.2

@[mlir_transport]
theorem MemoryState.Quad5Room.room_0 {m : MemoryState} (h : m.Quad5Room p) : Room m p 256 :=
  h.2.1

@[mlir_transport]
theorem MemoryState.Quad5Room.room_1 {m : MemoryState} (h : m.Quad5Room p) :
    Room m (p.add 32#64) 256 :=
  h.2.2.1

@[mlir_transport]
theorem MemoryState.Quad5Room.room_2 {m : MemoryState} (h : m.Quad5Room p) :
    Room m (p.add 64#64) 256 :=
  h.2.2.2.1

@[mlir_transport]
theorem MemoryState.Quad5Room.room_3 {m : MemoryState} (h : m.Quad5Room p) :
    Room m (p.add 96#64) 256 :=
  h.2.2.2.2.1

@[mlir_transport]
theorem MemoryState.Quad5Room.room_4 {m : MemoryState} (h : m.Quad5Room p) :
    Room m (p.add 128#64) 256 :=
  h.2.2.2.2.2

theorem MemoryState.Quad5Room.no_wrap {m : MemoryState} (h : m.Quad5Room p) {off : BitVec 64}
    (hoff : off.toNat ≤ 128) : ¬p.offset.uaddOverflow off := by
  have := h.1
  simp only [BitVec.uaddOverflow, decide_eq_true_eq]
  omega

theorem MemoryState.Quad5Fit.no_wrap {m : MemoryState} (h : m.Quad5Fit p) {off : BitVec 64}
    (hoff : off.toNat ≤ 128) : ¬p.offset.uaddOverflow off := by
  have := h.1
  simp only [BitVec.uaddOverflow, decide_eq_true_eq]
  omega

/-- Room for `Q1 … Q4` together, as `memset` writes them. -/
theorem MemoryState.Quad5Room.room_1_4 {m : MemoryState} (h : m.Quad5Room p) :
    Room m (p.add 32#64) 1024 := by
  obtain ⟨blk, hblk, hl, hsz⟩ := h.room_4
  refine ⟨blk, hblk, hl, ?_⟩
  have h1 := Pointer.offsetInBits_add (p := p) (h.no_wrap (off := 32#64) (by decide))
  have h2 := Pointer.offsetInBits_add (p := p) (h.no_wrap (off := 128#64) (by decide))
  simp only [BitVec.toNat_ofNat] at h1 h2
  omega

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.storeAt {m : MemoryState} {x : BitVec w} (h : m.Quad5Fit q) :
    (m.storeAt p x).Quad5Fit q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.1.storeAt, h.2.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.storeWv {m : MemoryState} (h : m.Quad5Fit q) :
    (m.storeWv p v).Quad5Fit q :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.storeVec {m : MemoryState} (h : m.Quad5Fit q) :
    (m.storeVec p v).Quad5Fit q :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.storeLimbs {m : MemoryState} (h : m.Quad5Fit q) :
    (m.storeLimbs p l).Quad5Fit q :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.storeLimbsV {m : MemoryState} (h : m.Quad5Fit q) :
    (m.storeLimbsV p l).Quad5Fit q :=
  h.storeAt.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.storeTmp5 {m : MemoryState} (h : m.Quad5Fit q) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).Quad5Fit q :=
  h.storeWv.storeWv.storeWv.storeWv.storeWv

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.storeQuad5 {m : MemoryState} (h : m.Quad5Fit q) :
    (m.storeQuad5 p Q).Quad5Fit q :=
  h.storeTmp5

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.Quad5Fit q) :
    (s.alloca n d).mem.Quad5Fit q :=
  ⟨h.1, h.2.1.alloca hwf, h.2.2.1.alloca hwf, h.2.2.2.1.alloca hwf, h.2.2.2.2.1.alloca hwf,
    h.2.2.2.2.2.alloca hwf⟩

@[mlir_transport]
theorem MemoryState.Quad5Fit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.Quad5Fit q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).Quad5Fit q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.1.addBlock hwf, h.2.2.2.2.1.addBlock hwf,
    h.2.2.2.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.storeAt {m : MemoryState} {x : BitVec w} (h : m.Quad5Room q) :
    (m.storeAt p x).Quad5Room q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.1.storeAt, h.2.2.2.2.1.storeAt, h.2.2.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.storeWv {m : MemoryState} (h : m.Quad5Room q) :
    (m.storeWv p v).Quad5Room q :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.storeVec {m : MemoryState} (h : m.Quad5Room q) :
    (m.storeVec p v).Quad5Room q :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.storeLimbs {m : MemoryState} (h : m.Quad5Room q) :
    (m.storeLimbs p l).Quad5Room q :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.storeLimbsV {m : MemoryState} (h : m.Quad5Room q) :
    (m.storeLimbsV p l).Quad5Room q :=
  h.storeAt.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.storeTmp5 {m : MemoryState} (h : m.Quad5Room q) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).Quad5Room q :=
  h.storeWv.storeWv.storeWv.storeWv.storeWv

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.storeQuad5 {m : MemoryState} (h : m.Quad5Room q) :
    (m.storeQuad5 p Q).Quad5Room q :=
  h.storeTmp5

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.Quad5Room q) :
    (s.alloca n d).mem.Quad5Room q :=
  ⟨h.1, h.2.1.alloca hwf, h.2.2.1.alloca hwf, h.2.2.2.1.alloca hwf, h.2.2.2.2.1.alloca hwf,
    h.2.2.2.2.2.alloca hwf⟩

@[mlir_transport]
theorem MemoryState.Quad5Room.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.Quad5Room q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).Quad5Room q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.1.addBlock hwf, h.2.2.2.2.1.addBlock hwf,
    h.2.2.2.2.2.addBlock hwf⟩

/-- Room for a point before a store if there is room after it. -/
theorem MemoryState.Quad5Room.of_storeQuad5 {m : MemoryState} (h : (m.storeQuad5 p P).Quad5Room q) :
    m.Quad5Room q := by
  simpa only [MemoryState.Quad5Room, MemoryState.storeQuad5, MemoryState.storeTmp5,
    MemoryState.storeWv, Room.storeAt_iff] using h

/-- A point stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.Quad5Fit.storeQuad5_self {m : MemoryState} {p : Pointer} (h : m.Quad5Room p) :
    (m.storeQuad5 p Q).Quad5Fit p := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  exact
    ⟨ho, (Fits.storeAt_self h0).storeAt.storeAt.storeAt.storeAt,
      (Fits.storeAt_self h1.storeAt).storeAt.storeAt.storeAt,
      (Fits.storeAt_self h2.storeAt.storeAt).storeAt.storeAt,
      (Fits.storeAt_self h3.storeAt.storeAt.storeAt).storeAt,
      Fits.storeAt_self h4.storeAt.storeAt.storeAt.storeAt⟩

/-! A callee's five out-pointers, each stored where there is room: known. -/

@[mlir_fresh]
theorem Fits.storeTmp5_0 {m : MemoryState} (h : Room m t0 256) :
    Fits (m.storeTmp5 t0 t1 t2 t3 t4 Q) t0 256 :=
  (Fits.storeAt_self h).storeAt.storeAt.storeAt.storeAt

@[mlir_fresh]
theorem Fits.storeTmp5_1 {m : MemoryState} (h : Room m t1 256) :
    Fits (m.storeTmp5 t0 t1 t2 t3 t4 Q) t1 256 :=
  (Fits.storeAt_self h.storeAt).storeAt.storeAt.storeAt

@[mlir_fresh]
theorem Fits.storeTmp5_2 {m : MemoryState} (h : Room m t2 256) :
    Fits (m.storeTmp5 t0 t1 t2 t3 t4 Q) t2 256 :=
  (Fits.storeAt_self h.storeAt.storeAt).storeAt.storeAt

@[mlir_fresh]
theorem Fits.storeTmp5_3 {m : MemoryState} (h : Room m t3 256) :
    Fits (m.storeTmp5 t0 t1 t2 t3 t4 Q) t3 256 :=
  (Fits.storeAt_self h.storeAt.storeAt.storeAt).storeAt

@[mlir_fresh]
theorem Fits.storeTmp5_4 {m : MemoryState} (h : Room m t4 256) :
    Fits (m.storeTmp5 t0 t1 t2 t3 t4 Q) t4 256 :=
  Fits.storeAt_self h.storeAt.storeAt.storeAt.storeAt

/-- A 1280-bit block from its start holds one point. -/
theorem MemoryState.Quad5Fit.of_fits {m : MemoryState} (h : Fits m p 1280) (ho : p.offset = 0) :
    m.Quad5Fit p := by
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 128) : ¬p.offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, ho, decide_eq_true_eq]
    simp
    omega
  exact
    ⟨by simp [ho], h.mono (by omega), Fits.add_of_le (hov _ (by decide)) (by decide) h,
      Fits.add_of_le (hov _ (by decide)) (by decide) h,
      Fits.add_of_le (hov _ (by decide)) (by decide) h,
      Fits.add_of_le (hov _ (by decide)) (by decide) h⟩

/-- A 1280-bit live block from its start has room for one point. -/
theorem MemoryState.Quad5Room.of_room {m : MemoryState} (h : Room m p 1280) (ho : p.offset = 0) :
    m.Quad5Room p := by
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 128) : ¬p.offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, ho, decide_eq_true_eq]
    simp
    omega
  exact
    ⟨by simp [ho], h.mono (by omega), Room.add_of_le (hov _ (by decide)) (by decide) h,
      Room.add_of_le (hov _ (by decide)) (by decide) h,
      Room.add_of_le (hov _ (by decide)) (by decide) h,
      Room.add_of_le (hov _ (by decide)) (by decide) h⟩

/-- Entry `k` of a table of `n` points from `p`, 192 bytes apart, fits where the table does. -/
theorem MemoryState.Quad5Fit.entry {m : MemoryState} {p : Pointer} (h : Fits m p (1536 * n))
    (hp : p.offset.toNat + 192 * n < 2 ^ 64) (hk : k < n) :
    m.Quad5Fit (p.add (BitVec.ofNat 64 (192 * k))) := by
  have hf (o : Nat) (ho : o + 32 ≤ 192) : Fits m (p.add (BitVec.ofNat 64 (192 * k + o))) 256 :=
    Fits.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      h
  have hoff : (p.add (BitVec.ofNat 64 (192 * k))).offset.toNat = p.offset.toNat + 192 * k := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hadd (o : Nat) :
    (p.add (BitVec.ofNat 64 (192 * k))).add (BitVec.ofNat 64 o) =
      p.add (BitVec.ofNat 64 (192 * k + o)) := by
    rw [Pointer.add_add, BitVec.ofNat_add]
  have hf0 := hf 0 (by omega)
  simp only [Nat.add_zero] at hf0
  refine ⟨by omega, hf0, ?_, ?_, ?_, ?_⟩
  · rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl, hadd]
    exact hf 32 (by omega)
  · rw [show (64#64 : BitVec 64) = BitVec.ofNat 64 64 from rfl, hadd]
    exact hf 64 (by omega)
  · rw [show (96#64 : BitVec 64) = BitVec.ofNat 64 96 from rfl, hadd]
    exact hf 96 (by omega)
  · rw [show (128#64 : BitVec 64) = BitVec.ofNat 64 128 from rfl, hadd]
    exact hf 128 (by omega)

/-- Room for entry `k` of a table of `n` points from `p`, 192 bytes apart, where there is room for
the table. -/
theorem MemoryState.Quad5Room.entry {m : MemoryState} {p : Pointer} (h : Room m p (1536 * n))
    (hp : p.offset.toNat + 192 * n < 2 ^ 64) (hk : k < n) :
    m.Quad5Room (p.add (BitVec.ofNat 64 (192 * k))) := by
  have hf (o : Nat) (ho : o + 32 ≤ 192) : Room m (p.add (BitVec.ofNat 64 (192 * k + o))) 256 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      h
  have hoff : (p.add (BitVec.ofNat 64 (192 * k))).offset.toNat = p.offset.toNat + 192 * k := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hadd (o : Nat) :
    (p.add (BitVec.ofNat 64 (192 * k))).add (BitVec.ofNat 64 o) =
      p.add (BitVec.ofNat 64 (192 * k + o)) := by
    rw [Pointer.add_add, BitVec.ofNat_add]
  have hf0 := hf 0 (by omega)
  simp only [Nat.add_zero] at hf0
  refine ⟨by omega, hf0, ?_, ?_, ?_, ?_⟩
  · rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl, hadd]
    exact hf 32 (by omega)
  · rw [show (64#64 : BitVec 64) = BitVec.ofNat 64 64 from rfl, hadd]
    exact hf 64 (by omega)
  · rw [show (96#64 : BitVec 64) = BitVec.ofNat 64 96 from rfl, hadd]
    exact hf 96 (by omega)
  · rw [show (128#64 : BitVec 64) = BitVec.ofNat 64 128 from rfl, hadd]
    exact hf 128 (by omega)

/-! ### State -/

@[simp, mlir_state]
theorem Room.storeTmp5_iff {m : MemoryState} :
    Room (m.storeTmp5 t0 t1 t2 t3 t4 Q) p w ↔ Room m p w := by simp [MemoryState.storeTmp5]

@[mlir_mem, mlir_transport]
theorem Fits.storeTmp5 {m : MemoryState} (h : Fits m p w) :
    Fits (m.storeTmp5 t0 t1 t2 t3 t4 Q) p w :=
  h.storeWv.storeWv.storeWv.storeWv.storeWv

@[mlir_mem, mlir_transport]
theorem Room.storeTmp5 {m : MemoryState} (h : Room m p w) :
    Room (m.storeTmp5 t0 t1 t2 t3 t4 Q) p w :=
  Room.storeTmp5_iff.mpr h

@[mlir_mem, mlir_transport]
theorem InBounds.storeTmp5 {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.storeTmp5 t0 t1 t2 t3 t4 Q) p w :=
  h.storeWv.storeWv.storeWv.storeWv.storeWv

@[simp, mlir_state]
theorem Room.storeQuad5_iff {m : MemoryState} : Room (m.storeQuad5 q Q) p w ↔ Room m p w :=
  Room.storeTmp5_iff

@[mlir_mem, mlir_transport]
theorem Fits.storeQuad5 {m : MemoryState} (h : Fits m p w) : Fits (m.storeQuad5 q Q) p w :=
  Fits.storeTmp5 h

@[mlir_mem, mlir_transport]
theorem Room.storeQuad5 {m : MemoryState} (h : Room m p w) : Room (m.storeQuad5 q Q) p w :=
  Room.storeTmp5 h

@[mlir_mem, mlir_transport]
theorem InBounds.storeQuad5 {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.storeQuad5 q Q) p w :=
  InBounds.storeTmp5 h

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeTmp5 (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeTmp5 t0 t1 t2 t3 t4 Q) p :=
  h.storeWv.storeWv.storeWv.storeWv.storeWv

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeQuad5 (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeQuad5 q Q) p :=
  h.storeTmp5

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeTmp5 (h : MemoryState.LimbsRoom m p) :
    MemoryState.LimbsRoom (m.storeTmp5 t0 t1 t2 t3 t4 Q) p :=
  h.storeWv.storeWv.storeWv.storeWv.storeWv

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeQuad5 (h : MemoryState.LimbsRoom m p) :
    MemoryState.LimbsRoom (m.storeQuad5 q Q) p :=
  h.storeTmp5

@[simp, mlir_mem]
theorem GlobalState.WF_storeTmp5 {s : GlobalState} :
    ({ s with mem := m.storeTmp5 t0 t1 t2 t3 t4 Q } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeTmp5, MemoryState.storeWv]

@[mlir_transport]
theorem GlobalState.WF.storeTmp5 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeTmp5 t0 t1 t2 t3 t4 Q } : GlobalState).WF :=
  GlobalState.WF_storeTmp5.mpr h

@[mlir_transport]
theorem GlobalState.WF.storeTmp5_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeTmp5 t0 t1 t2 t3 t4 Q⟩ : GlobalState).WF :=
  GlobalState.WF.storeTmp5 (s := ⟨a, m⟩) h

@[simp, mlir_mem]
theorem GlobalState.WF_storeQuad5 {s : GlobalState} :
    ({ s with mem := m.storeQuad5 p Q } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF :=
  GlobalState.WF_storeTmp5

@[mlir_transport]
theorem GlobalState.WF.storeQuad5 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeQuad5 p Q } : GlobalState).WF :=
  GlobalState.WF_storeQuad5.mpr h

@[mlir_transport]
theorem GlobalState.WF.storeQuad5_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeQuad5 p Q⟩ : GlobalState).WF :=
  GlobalState.WF.storeQuad5 (s := ⟨a, m⟩) h

/-! ### Ranges of one point -/

/-- Two `wl_t`s of one point, at byte offsets `a` and `b` 32 apart, do not overlap. -/
theorem Range.disjoint_wl {p : Pointer} {a b : Nat} (hp : p.offset.toNat + 160 ≤ 2 ^ 64)
    (ha : a ≤ 128) (hb : b ≤ 128) (hab : a + 32 ≤ b ∨ b + 32 ≤ a) (hv : v ≤ 256) (hw : w ≤ 256) :
    (Range.of (p.add (BitVec.ofNat 64 a)) v).Disjoint (Range.of (p.add (BitVec.ofNat 64 b)) w) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega : b < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

theorem Pointer.add_ofNat_zero (p : Pointer) : p.add (BitVec.ofNat 64 0) = p := by
  simp [Pointer.add]

/-- `Range.disjoint_wl` for the `wl_t` at offset 0, spelled `p`. -/
theorem Range.disjoint_wl_base {p : Pointer} {b : BitVec 64} (hp : p.offset.toNat + 160 ≤ 2 ^ 64)
    (hb : b.toNat ≤ 128) (h32 : 32 ≤ b.toNat) (hv : v ≤ 256) (hw : w ≤ 256) :
    (Range.of p v).Disjoint (Range.of (p.add b) w) := by
  have := Range.disjoint_wl (a := 0) (b := b.toNat) hp (by omega) hb (by omega) hv hw
  simpa [Pointer.add_ofNat_zero] using this

/-! ### Reads -/

/-- A read at one `wl_t` of a point, past a store to another. -/
@[mlir_read]
theorem MemoryState.readAt_storeAt_wl {m : MemoryState} {p : Pointer} {a b : BitVec 64}
    {x : BitVec v} (h : m.Quad5Room p) (ha : a.toNat ≤ 128) (hb : b.toNat ≤ 128)
    (hab : a.toNat + 32 ≤ b.toNat ∨ b.toNat + 32 ≤ a.toNat) (hv : v ≤ 256) (hw : w ≤ 256) :
    (m.storeAt (p.add a) x).readAt (p.add b) w = m.readAt (p.add b) w := by
  have := Range.disjoint_wl (a := a.toNat) (b := b.toNat) h.1 ha hb hab hv hw
  simp only [BitVec.ofNat_toNat, BitVec.setWidth_eq] at this
  exact readAt_storeAt_disjoint this _

/-- `readAt_storeAt_wl` for a store to `Q0`. -/
@[mlir_read]
theorem MemoryState.readAt_storeAt_wl_base {m : MemoryState} {p : Pointer} {b : BitVec 64}
    {x : BitVec v} (h : m.Quad5Room p) (hb : b.toNat ≤ 128) (h32 : 32 ≤ b.toNat) (hv : v ≤ 256)
    (hw : w ≤ 256) : (m.storeAt p x).readAt (p.add b) w = m.readAt (p.add b) w :=
  readAt_storeAt_disjoint (Range.disjoint_wl_base h.1 hb h32 hv hw) _

/-- `readAt_storeAt_wl` for a read of `Q0`. -/
@[mlir_read]
theorem MemoryState.readAt_storeAt_wl_of_base {m : MemoryState} {p : Pointer} {a : BitVec 64}
    {x : BitVec v} (h : m.Quad5Room p) (ha : a.toNat ≤ 128) (h32 : 32 ≤ a.toNat) (hv : v ≤ 256)
    (hw : w ≤ 256) : (m.storeAt (p.add a) x).readAt p w = m.readAt p w :=
  readAt_storeAt_disjoint (Range.disjoint_wl_base h.1 ha h32 hw hv).symm _

/-- A read past a callee's five stores, elsewhere. -/
@[mlir_read]
theorem MemoryState.readAt_storeTmp5_of_disjoint {m : MemoryState} {q : Pointer}
    (h0 : (Range.of t0 256).Disjoint (Range.of q w))
    (h1 : (Range.of t1 256).Disjoint (Range.of q w))
    (h2 : (Range.of t2 256).Disjoint (Range.of q w))
    (h3 : (Range.of t3 256).Disjoint (Range.of q w))
    (h4 : (Range.of t4 256).Disjoint (Range.of q w)) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readAt q w = m.readAt q w := by
  simp only [storeTmp5, readAt_storeWv_disjoint h0, readAt_storeWv_disjoint h1,
    readAt_storeWv_disjoint h2, readAt_storeWv_disjoint h3, readAt_storeWv_disjoint h4]

/-- A read past a callee's five stores, in another block. -/
@[mlir_read]
theorem MemoryState.readAt_storeTmp5_of_id_ne {m : MemoryState} {q : Pointer} (h0 : t0.id ≠ q.id)
    (h1 : t1.id ≠ q.id) (h2 : t2.id ≠ q.id) (h3 : t3.id ≠ q.id) (h4 : t4.id ≠ q.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readAt q w = m.readAt q w :=
  readAt_storeTmp5_of_disjoint (Or.inl (by simpa [Range.of] using h0))
    (Or.inl (by simpa [Range.of] using h1)) (Or.inl (by simpa [Range.of] using h2))
    (Or.inl (by simpa [Range.of] using h3)) (Or.inl (by simpa [Range.of] using h4))

/-! The callee's out-pointers in five blocks, each read back. -/

@[mlir_read]
theorem MemoryState.readAt_storeTmp5_0 {m : MemoryState} (h : InBounds m t0 256)
    (h1 : t1.id ≠ t0.id) (h2 : t2.id ≠ t0.id) (h3 : t3.id ≠ t0.id) (h4 : t4.id ≠ t0.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readAt t0 256 = BitVec.packLanes Q.P0 := by
  simp only [storeTmp5, storeWv,
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h1) : (Range.of t1 256).Disjoint _),
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h2) : (Range.of t2 256).Disjoint _),
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h3) : (Range.of t3 256).Disjoint _),
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h4) : (Range.of t4 256).Disjoint _),
    readAt_storeAt_self h]

@[mlir_read]
theorem MemoryState.readAt_storeTmp5_1 {m : MemoryState} (h : InBounds m t1 256)
    (h2 : t2.id ≠ t1.id) (h3 : t3.id ≠ t1.id) (h4 : t4.id ≠ t1.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readAt t1 256 = BitVec.packLanes Q.P1 := by
  simp only [storeTmp5, storeWv,
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h2) : (Range.of t2 256).Disjoint _),
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h3) : (Range.of t3 256).Disjoint _),
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h4) : (Range.of t4 256).Disjoint _),
    readAt_storeAt_self h.storeAt]

@[mlir_read]
theorem MemoryState.readAt_storeTmp5_2 {m : MemoryState} (h : InBounds m t2 256)
    (h3 : t3.id ≠ t2.id) (h4 : t4.id ≠ t2.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readAt t2 256 = BitVec.packLanes Q.P2 := by
  simp only [storeTmp5, storeWv,
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h3) : (Range.of t3 256).Disjoint _),
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h4) : (Range.of t4 256).Disjoint _),
    readAt_storeAt_self h.storeAt.storeAt]

@[mlir_read]
theorem MemoryState.readAt_storeTmp5_3 {m : MemoryState} (h : InBounds m t3 256)
    (h4 : t4.id ≠ t3.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readAt t3 256 = BitVec.packLanes Q.P3 := by
  simp only [storeTmp5, storeWv,
    readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h4) : (Range.of t4 256).Disjoint _),
    readAt_storeAt_self h.storeAt.storeAt.storeAt]

@[mlir_read]
theorem MemoryState.readAt_storeTmp5_4 {m : MemoryState} (h : InBounds m t4 256) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readAt t4 256 = BitVec.packLanes Q.P4 := by
  simp only [storeTmp5, storeWv, readAt_storeAt_self h.storeAt.storeAt.storeAt.storeAt]

/-- The point at `q`, past a store in another block. -/
@[mlir_read]
theorem MemoryState.readQuad5_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readQuad5 q = m.readQuad5 q := by
  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa using h
  simp only [readQuad5, readWv_storeAt_of_id_ne h, readWv_storeAt_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readQuad5_storeWv_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeWv p v).readQuad5 q = m.readQuad5 q :=
  readQuad5_storeAt_of_id_ne h

@[mlir_read]
theorem MemoryState.readQuad5_storeTmp5_of_id_ne {m : MemoryState} {q : Pointer} (h0 : t0.id ≠ q.id)
    (h1 : t1.id ≠ q.id) (h2 : t2.id ≠ q.id) (h3 : t3.id ≠ q.id) (h4 : t4.id ≠ q.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).readQuad5 q = m.readQuad5 q := by
  simp only [storeTmp5, readQuad5_storeWv_of_id_ne h0, readQuad5_storeWv_of_id_ne h1,
    readQuad5_storeWv_of_id_ne h2, readQuad5_storeWv_of_id_ne h3, readQuad5_storeWv_of_id_ne h4]

@[mlir_read]
theorem MemoryState.readQuad5_storeQuad5_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeQuad5 p P).readQuad5 q = m.readQuad5 q :=
  readQuad5_storeTmp5_of_id_ne h h h h h

/-- A point stored where there is room reads back. -/
@[mlir_read]
theorem MemoryState.readQuad5_storeQuad5_self {m : MemoryState} {p : Pointer} (h : m.Quad5Room p) :
    (m.storeQuad5 p P).readQuad5 p = P := by
  have hd (a b : BitVec 64) (ha : a.toNat ≤ 128) (hb : b.toNat ≤ 128)
    (hab : a.toNat + 32 ≤ b.toNat ∨ b.toNat + 32 ≤ a.toNat) :
    (Range.of (p.add a) 256).Disjoint (Range.of (p.add b) 256) := by
    simpa using Range.disjoint_wl (a := a.toNat) (b := b.toNat) h.1 ha hb hab le_rfl le_rfl
  have hd0 (b : BitVec 64) (hb : b.toNat ≤ 128) (h32 : 32 ≤ b.toNat) :=
    Range.disjoint_wl_base (v := 256) (w := 256) h.1 hb h32 le_rfl le_rfl
  rcases P with ⟨a, b, c, d, e⟩
  simp only [readQuad5, storeQuad5, storeTmp5, Quad5.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [readWv_storeWv_disjoint (hd0 _ (by decide) (by decide)).symm,
      readWv_storeWv_disjoint (hd0 _ (by decide) (by decide)).symm,
      readWv_storeWv_disjoint (hd0 _ (by decide) (by decide)).symm,
      readWv_storeWv_disjoint (hd0 _ (by decide) (by decide)).symm,
      readWv_storeWv_self h.2.1.inBounds]
  · rw [readWv_storeWv_disjoint (hd _ _ (by decide) (by decide) (by decide)),
      readWv_storeWv_disjoint (hd _ _ (by decide) (by decide) (by decide)),
      readWv_storeWv_disjoint (hd _ _ (by decide) (by decide) (by decide)),
      readWv_storeWv_self h.2.2.1.storeWv.inBounds]
  · rw [readWv_storeWv_disjoint (hd _ _ (by decide) (by decide) (by decide)),
      readWv_storeWv_disjoint (hd _ _ (by decide) (by decide) (by decide)),
      readWv_storeWv_self h.2.2.2.1.storeWv.storeWv.inBounds]
  · rw [readWv_storeWv_disjoint (hd _ _ (by decide) (by decide) (by decide)),
      readWv_storeWv_self h.2.2.2.2.1.storeWv.storeWv.storeWv.inBounds]
  · rw [readWv_storeWv_self h.2.2.2.2.2.storeWv.storeWv.storeWv.storeWv.inBounds]

/-- A point elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readQuad5_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readQuad5 p = s.mem.readQuad5 p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa using hne
  simp only [readQuad5, readWv_alloca hne, readWv_alloca (hne' _)]

@[mlir_read]
theorem MemoryState.readQuad5_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readQuad5 p = m.readQuad5 p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa using h
  simp only [readQuad5, readWv_addBlock_of_id_ne h, readWv_addBlock_of_id_ne (h' _)]

@[mlir_read]
theorem MemoryState.readQuad5_addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.Quad5Room p) :
    (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).readQuad5 p = s.mem.readQuad5 p := by
  simp only [readQuad5, readWv_addBlock hwf h.2.1.inBounds, readWv_addBlock hwf h.2.2.1.inBounds,
    readWv_addBlock hwf h.2.2.2.1.inBounds, readWv_addBlock hwf h.2.2.2.2.1.inBounds,
    readWv_addBlock hwf h.2.2.2.2.2.inBounds]

/-- The point at byte `o` of a known read: its bits. -/
theorem MemoryState.readQuad5_add_of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v}
    (hf : InBounds m p v) (h : m.readAt p v = x) (hp : p.offset.toNat + o + 160 ≤ 2 ^ 64)
    (hv : 8 * o + 1280 ≤ v) : m.readQuad5 (p.add (BitVec.ofNat 64 o)) = quad5At x (8 * o) := by
  have hadd (c : Nat) :
    (p.add (BitVec.ofNat 64 o)).add (BitVec.ofNat 64 c) = p.add (BitVec.ofNat 64 (o + c)) := by
    rw [Pointer.add_add, BitVec.ofNat_add]
  simp only [readQuad5, quad5At]
  rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl,
    show (64#64 : BitVec 64) = BitVec.ofNat 64 64 from rfl,
    show (96#64 : BitVec 64) = BitVec.ofNat 64 96 from rfl,
    show (128#64 : BitVec 64) = BitVec.ofNat 64 128 from rfl, hadd, hadd, hadd, hadd,
    readWv_add_of_readAt hf h (by omega) (by omega),
    readWv_add_of_readAt (o := o + 32) hf h (by omega) (by omega),
    readWv_add_of_readAt (o := o + 64) hf h (by omega) (by omega),
    readWv_add_of_readAt (o := o + 96) hf h (by omega) (by omega),
    readWv_add_of_readAt (o := o + 128) hf h (by omega) (by omega)]
  congr 1

/-! ### Stores -/

/-- Lanes stored twice at the same place: the second. -/
theorem MemoryState.storeWv_storeWv_self {m : MemoryState} :
    (m.storeWv p v).storeWv p v' = m.storeWv p v' :=
  storeAt_storeAt_self

/-- Four lanes read, packed: the bits read. -/
theorem MemoryState.packLanes_readWv {m : MemoryState} :
    BitVec.packLanes (m.readWv p) = m.readAt p 256 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := BitVec.extractLsb'_packLanes (m.readWv p) (i / 64) (by omega)
  have hb := congrArg (fun y => y.getLsbD (i % 64)) hk
  simp only [BitVec.getLsbD_extractLsb', show i % 64 < 64 by omega, decide_true, Bool.true_and,
    show i / 64 * 64 + i % 64 = i by omega] at hb
  rw [hb]
  simp only [readWv, Vector.getElem_ofFn, Ty.extractVecElem_eq, BitVec.getLsbD_extractLsb',
    show i % 64 < 64 by omega, decide_true, Bool.true_and, show i / 64 * 64 + i % 64 = i by omega]

/-- Storing the lanes a `wl_t` holds changes nothing. -/
theorem MemoryState.storeWv_readWv_self {m : MemoryState} (h : Fits m p 256) :
    m.storeWv p (m.readWv p) = m := by rw [storeWv, packLanes_readWv, storeAt_readAt_self h]

/-- Storing what a point holds changes nothing. -/
theorem MemoryState.storeQuad5_readQuad5_self {m : MemoryState} (h : m.Quad5Fit p) :
    m.storeQuad5 p (m.readQuad5 p) = m := by
  simp only [storeQuad5, storeTmp5, readQuad5]
  rw [storeWv_readWv_self h.2.1, storeWv_readWv_self h.2.2.1, storeWv_readWv_self h.2.2.2.1,
    storeWv_readWv_self h.2.2.2.2.1, storeWv_readWv_self h.2.2.2.2.2]

/-- `storeQuad5_readQuad5_self` with the point named. -/
theorem MemoryState.storeQuad5_readQuad5_self' {m : MemoryState} (h : m.Quad5Fit p)
    (hP : m.readQuad5 p = P) : m.storeQuad5 p P = m := by rw [← hP, storeQuad5_readQuad5_self h]

/-- A callee's five stores twice, out-pointers in five blocks: the second. -/
theorem MemoryState.storeTmp5_storeTmp5_self {m : MemoryState} (h01 : t0.id ≠ t1.id)
    (h02 : t0.id ≠ t2.id) (h03 : t0.id ≠ t3.id) (h04 : t0.id ≠ t4.id) (h12 : t1.id ≠ t2.id)
    (h13 : t1.id ≠ t3.id) (h14 : t1.id ≠ t4.id) (h23 : t2.id ≠ t3.id) (h24 : t2.id ≠ t4.id)
    (h34 : t3.id ≠ t4.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 P).storeTmp5 t0 t1 t2 t3 t4 Q = m.storeTmp5 t0 t1 t2 t3 t4 Q := by
  have d {a b : Pointer} (h : a.id ≠ b.id) : (Range.of a 256).Disjoint (Range.of b 256) :=
    Or.inl (by simpa [Range.of] using h)
  simp only [storeTmp5, storeWv]
  -- each second store moved down to the first, which it replaces
  rw [storeAt_comm (d h04.symm), storeAt_comm (d h03.symm), storeAt_comm (d h02.symm),
    storeAt_comm (d h01.symm), storeAt_storeAt_self, storeAt_comm (d h14.symm),
    storeAt_comm (d h13.symm), storeAt_comm (d h12.symm), storeAt_storeAt_self,
    storeAt_comm (d h24.symm), storeAt_comm (d h23.symm), storeAt_storeAt_self,
    storeAt_comm (d h34.symm), storeAt_storeAt_self, storeAt_storeAt_self]

/-- A point stored twice at the same place: the second. -/
theorem MemoryState.storeQuad5_storeQuad5_self {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeQuad5 p P).storeQuad5 p Q = m.storeQuad5 p Q := by
  have d (a b : BitVec 64) (ha : a.toNat ≤ 128) (hb : b.toNat ≤ 128)
    (hab : a.toNat + 32 ≤ b.toNat ∨ b.toNat + 32 ≤ a.toNat) :
    (Range.of (p.add a) 256).Disjoint (Range.of (p.add b) 256) := by
    simpa using Range.disjoint_wl (a := a.toNat) (b := b.toNat) hp ha hb hab le_rfl le_rfl
  have d0 (b : BitVec 64) (hb : b.toNat ≤ 128) (h32 : 32 ≤ b.toNat) :=
    Range.disjoint_wl_base (v := 256) (w := 256) hp hb h32 le_rfl le_rfl
  simp only [storeQuad5, storeTmp5, storeWv]
  rw [storeAt_comm ((d0 128#64 (by decide) (by decide)).symm),
    storeAt_comm ((d0 96#64 (by decide) (by decide)).symm),
    storeAt_comm ((d0 64#64 (by decide) (by decide)).symm),
    storeAt_comm ((d0 32#64 (by decide) (by decide)).symm), storeAt_storeAt_self,
    storeAt_comm (d 128#64 32#64 (by decide) (by decide) (by decide)),
    storeAt_comm (d 96#64 32#64 (by decide) (by decide) (by decide)),
    storeAt_comm (d 64#64 32#64 (by decide) (by decide) (by decide)), storeAt_storeAt_self,
    storeAt_comm (d 128#64 64#64 (by decide) (by decide) (by decide)),
    storeAt_comm (d 96#64 64#64 (by decide) (by decide) (by decide)), storeAt_storeAt_self,
    storeAt_comm (d 128#64 96#64 (by decide) (by decide) (by decide)), storeAt_storeAt_self,
    storeAt_storeAt_self]

/-- Points in different blocks: their stores commute. -/
theorem MemoryState.storeQuad5_comm {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeQuad5 p P).storeQuad5 q Q = (m.storeQuad5 q Q).storeQuad5 p P := by
  have dd {a b : Pointer} (ha : a.id = p.id) (hb : b.id = q.id) :
    (Range.of a 256).Disjoint (Range.of b 256) := Or.inl (by simpa [Range.of, ha, hb] using h)
  simp only [storeQuad5, storeTmp5, storeWv]
  rw [storeAt_comm (dd (a := (p.add 128#64)) (b := q) rfl rfl),
    storeAt_comm (dd (a := (p.add 96#64)) (b := q) rfl rfl),
    storeAt_comm (dd (a := (p.add 64#64)) (b := q) rfl rfl),
    storeAt_comm (dd (a := (p.add 32#64)) (b := q) rfl rfl),
    storeAt_comm (dd (a := p) (b := q) rfl rfl),
    storeAt_comm (dd (a := (p.add 128#64)) (b := (q.add 32#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 96#64)) (b := (q.add 32#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 64#64)) (b := (q.add 32#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 32#64)) (b := (q.add 32#64)) rfl rfl),
    storeAt_comm (dd (a := p) (b := (q.add 32#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 128#64)) (b := (q.add 64#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 96#64)) (b := (q.add 64#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 64#64)) (b := (q.add 64#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 32#64)) (b := (q.add 64#64)) rfl rfl),
    storeAt_comm (dd (a := p) (b := (q.add 64#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 128#64)) (b := (q.add 96#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 96#64)) (b := (q.add 96#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 64#64)) (b := (q.add 96#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 32#64)) (b := (q.add 96#64)) rfl rfl),
    storeAt_comm (dd (a := p) (b := (q.add 96#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 128#64)) (b := (q.add 128#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 96#64)) (b := (q.add 128#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 64#64)) (b := (q.add 128#64)) rfl rfl),
    storeAt_comm (dd (a := (p.add 32#64)) (b := (q.add 128#64)) rfl rfl),
    storeAt_comm (dd (a := p) (b := (q.add 128#64)) rfl rfl)]

/-- The point at byte `b` from `p`, past a point stored at byte `a`, apart from it. -/
theorem MemoryState.readQuad5_storeQuad5_apart {m : MemoryState} {p : Pointer} {a b : Nat}
    (hp : p.offset.toNat + a + 160 ≤ 2 ^ 64) (hb : p.offset.toNat + b + 160 ≤ 2 ^ 64)
    (hab : a + 160 ≤ b ∨ b + 160 ≤ a) :
    (m.storeQuad5 (p.add (BitVec.ofNat 64 a)) P).readQuad5 (p.add (BitVec.ofNat 64 b)) =
      m.readQuad5 (p.add (BitVec.ofNat 64 b)) := by
  have hadd (o c : Nat) :
    (p.add (BitVec.ofNat 64 o)).add (BitVec.ofNat 64 c) = p.add (BitVec.ofNat 64 (o + c)) := by
    rw [Pointer.add_add, BitVec.ofNat_add]
  have h0 (x y : Nat) (hx : a ≤ x ∧ x ≤ a + 128) (hy : b ≤ y ∧ y ≤ b + 128) (z : BitVec 256)
    (m' : MemoryState) :
    (m'.storeAt (p.add (BitVec.ofNat 64 x)) z).readWv (p.add (BitVec.ofNat 64 y)) =
      m'.readWv (p.add (BitVec.ofNat 64 y)) := by
    apply readWv_storeAt_disjoint
    simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
      BitVec.toNat_ofNat]
    right
    rw [Nat.mod_eq_of_lt (by omega : x < 2 ^ 64), Nat.mod_eq_of_lt (by omega : y < 2 ^ 64),
      Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
    omega
  simp only [readQuad5, storeQuad5, storeTmp5, storeWv]
  rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl,
    show (64#64 : BitVec 64) = BitVec.ofNat 64 64 from rfl,
    show (96#64 : BitVec 64) = BitVec.ofNat 64 96 from rfl,
    show (128#64 : BitVec 64) = BitVec.ofNat 64 128 from rfl]
  simp only [hadd]
  simp (disch := omega) only [h0]

/-! ### `memset` and frames -/

/-- Bit `i` of four packed lanes: bit `i % 64` of lane `i / 64`. -/
theorem BitVec.getLsbD_packLanes_wl (v : Vector (BitVec 64) 4) (hi : i < 256) :
    (BitVec.packLanes v).getLsbD i = (v[i / 64]'(by omega)).getLsbD (i % 64) := by
  have h := BitVec.extractLsb'_packLanes v (i / 64) (by omega)
  have hb := congrArg (fun y => y.getLsbD (i % 64)) h
  simp only [BitVec.getLsbD_extractLsb', show i % 64 < 64 by omega, decide_true, Bool.true_and,
    show i / 64 * 64 + i % 64 = i by omega] at hb
  exact hb

/-- `FD_R52X5_GE_ZERO` stored as compiled: `Q0`, then `memset` of 128 zero bytes. -/
theorem MemoryState.storeQuad5_quadZero {m : MemoryState} {p : Pointer}
    (hp : p.offset.toNat + 160 ≤ 2 ^ 64) :
    (m.storeWv p (wl 0 1 1 0)).storeAt (p.add 32#64) ((0#8).replicate 128) =
      m.storeQuad5 p quadZero := by
  have hz : BitVec.packLanes (wl_zero : Wl) = 0#256 := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp [BitVec.getLsbD_packLanes_wl _ hi]
  have hov (a : Nat) (ha : a ≤ 96) : ¬(p.add 32#64).offset.uaddOverflow (BitVec.ofNat 64 a) := by
    simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat]
    simp
    omega
  have e (b : Nat) (c : BitVec 64) (hc : c = BitVec.ofNat 64 (32 + b)) :
    p.add c = (p.add 32#64).add (BitVec.ofNat 64 b) := by rw [Pointer.add_add, hc, BitVec.ofNat_add]
  have hr : (0#8).replicate 128 = (0#256 ++ (0#256 ++ (0#256 ++ 0#256))).cast (by decide) := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [BitVec.getLsbD_cast, BitVec.getLsbD_replicate, BitVec.getLsbD_zero, Bool.and_false,
      BitVec.getLsbD_append, ite_self]
  simp only [storeQuad5, storeTmp5, storeWv, quadZero, hz]
  rw [e 32 64#64 rfl]
  rw [storeAt_storeAt_append (hov 32 (by omega)) rfl (by omega)]
  rw [e 64 96#64 rfl]
  rw [storeAt_storeAt_append (hov 64 (by omega)) rfl (by omega)]
  rw [e 96 128#64 rfl]
  rw [storeAt_storeAt_append (hov 96 (by omega)) rfl (by omega)]
  rw [hr, storeAt_cast]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeTmp5 {m : MemoryState} :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).eraseFrom n = (m.eraseFrom n).storeTmp5 t0 t1 t2 t3 t4 Q := by
  simp only [storeTmp5, eraseFrom_storeWv]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeQuad5 {m : MemoryState} :
    (m.storeQuad5 p Q).eraseFrom n = (m.eraseFrom n).storeQuad5 p Q :=
  eraseFrom_storeTmp5

/-- A callee's five stores into the frame, dropped before the erase moves past them. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeTmp5_of_le {m : MemoryState} (h0 : n ≤ t0.id.id)
    (h1 : n ≤ t1.id.id) (h2 : n ≤ t2.id.id) (h3 : n ≤ t3.id.id) (h4 : n ≤ t4.id.id) :
    (m.storeTmp5 t0 t1 t2 t3 t4 Q).eraseFrom n = m.eraseFrom n := by
  simp only [storeTmp5, eraseFrom_storeWv_of_le h0, eraseFrom_storeWv_of_le h1,
    eraseFrom_storeWv_of_le h2, eraseFrom_storeWv_of_le h3, eraseFrom_storeWv_of_le h4]

@[mlir_frame, mlir_erase]
theorem MemoryState.storeQuad5_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeQuad5 p Q = m.eraseFrom n := by
  have h' (k : BitVec 64) : n ≤ (p.add k).id.id := by simpa using h
  simp only [storeQuad5, storeTmp5, storeWv_eraseFrom_of_le h, storeWv_eraseFrom_of_le (h' _)]

/-- A point stored into the frame, dropped before the erase moves past it. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeQuad5_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeQuad5 p Q).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeQuad5, storeQuad5_eraseFrom_of_le h]

/-! ### Reads of a stored point, as the loads see them -/

@[mlir_read]
theorem MemoryState.readAt_storeQuad5_of_id_ne {m : MemoryState} {p q : Pointer} (h : p.id ≠ q.id) :
    (m.storeQuad5 p Q).readAt q w = m.readAt q w :=
  readAt_storeTmp5_of_id_ne h h h h h

/-! The `wl_t`s of a stored point, as loads read them. -/

@[mlir_read]
theorem MemoryState.readAt_storeQuad5_0 {m : MemoryState} (h : m.Quad5Room p) :
    (m.storeQuad5 p Q).readAt p 256 = BitVec.packLanes Q.P0 := by
  rw [← packLanes_readWv, ← congrArg Quad5.P0 (readQuad5_storeQuad5_self (P := Q) h)]; rfl

@[mlir_read]
theorem MemoryState.readAt_storeQuad5_1 {m : MemoryState} (h : m.Quad5Room p) :
    (m.storeQuad5 p Q).readAt (p.add 32#64) 256 = BitVec.packLanes Q.P1 := by
  rw [← packLanes_readWv, ← congrArg Quad5.P1 (readQuad5_storeQuad5_self (P := Q) h)]; rfl

@[mlir_read]
theorem MemoryState.readAt_storeQuad5_2 {m : MemoryState} (h : m.Quad5Room p) :
    (m.storeQuad5 p Q).readAt (p.add 64#64) 256 = BitVec.packLanes Q.P2 := by
  rw [← packLanes_readWv, ← congrArg Quad5.P2 (readQuad5_storeQuad5_self (P := Q) h)]; rfl

@[mlir_read]
theorem MemoryState.readAt_storeQuad5_3 {m : MemoryState} (h : m.Quad5Room p) :
    (m.storeQuad5 p Q).readAt (p.add 96#64) 256 = BitVec.packLanes Q.P3 := by
  rw [← packLanes_readWv, ← congrArg Quad5.P3 (readQuad5_storeQuad5_self (P := Q) h)]; rfl

@[mlir_read]
theorem MemoryState.readAt_storeQuad5_4 {m : MemoryState} (h : m.Quad5Room p) :
    (m.storeQuad5 p Q).readAt (p.add 128#64) 256 = BitVec.packLanes Q.P4 := by
  rw [← packLanes_readWv, ← congrArg Quad5.P4 (readQuad5_storeQuad5_self (P := Q) h)]; rfl

/-! ### Lifetime markers -/

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readQuad5_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readQuad5 p = m.readQuad5 p := by
  simp only [readQuad5, readWv_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readQuad5_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readQuad5 p = m.readQuad5 p := by simp only [readQuad5, readWv_lifetimeEnd]

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.Quad5Fit p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).Quad5Fit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.1.lifetimeStart (hne' _),
      h.2.2.2.2.1.lifetimeStart (hne' _), h.2.2.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.Quad5Fit p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).Quad5Fit p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.1.lifetimeEnd (hne' _),
      h.2.2.2.2.1.lifetimeEnd (hne' _), h.2.2.2.2.2.lifetimeEnd (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.Quad5Room p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).Quad5Room p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart (hne' _), h.2.2.2.1.lifetimeStart (hne' _),
      h.2.2.2.2.1.lifetimeStart (hne' _), h.2.2.2.2.2.lifetimeStart (hne' _)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.Quad5Room p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).Quad5Room p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ q.id := by simpa [Pointer.add_id] using hne
  exact
    ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd (hne' _), h.2.2.2.1.lifetimeEnd (hne' _),
      h.2.2.2.2.1.lifetimeEnd (hne' _), h.2.2.2.2.2.lifetimeEnd (hne' _)⟩

/-! ### A callee's five temporaries, live for its call -/

/-- `t0 … t4` started, `Q` stored there by a callee, then ended: an `FD_R52X5_QUAD_MUL_FAST`'s or
`SQR_FAST`'s temporaries. -/
def MemoryState.callTmp5 (m : MemoryState) (t0 t1 t2 t3 t4 : Pointer) (Q : Quad5) : MemoryState :=
  ((((((((((m.lifetimeStart t0).lifetimeStart t1).lifetimeStart t2).lifetimeStart t3).lifetimeStart
                            t4).storeTmp5
                        t0 t1 t2 t3 t4 Q).lifetimeEnd
                    t4).lifetimeEnd
                t3).lifetimeEnd
            t2).lifetimeEnd
        t1).lifetimeEnd
    t0

@[simp, mlir_mem]
theorem GlobalState.WF_callTmp5 {s : GlobalState} :
    ({ s with mem := m.callTmp5 t0 t1 t2 t3 t4 Q } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.callTmp5, MemoryState.storeTmp5, MemoryState.storeWv]

@[mlir_transport]
theorem GlobalState.WF.callTmp5 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.callTmp5 t0 t1 t2 t3 t4 Q } : GlobalState).WF :=
  GlobalState.WF_callTmp5.mpr h

@[mlir_transport]
theorem GlobalState.WF.callTmp5_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.callTmp5 t0 t1 t2 t3 t4 Q⟩ : GlobalState).WF :=
  GlobalState.WF.callTmp5 (s := ⟨a, m⟩) h

@[mlir_mem, mlir_transport]
theorem InBounds.callTmp5 {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.callTmp5 t0 t1 t2 t3 t4 Q) p w := by
  unfold MemoryState.callTmp5
  repeat
    first
    | exact h
    | apply InBounds.lifetimeEnd
    | apply InBounds.storeTmp5
    | apply InBounds.lifetimeStart

@[mlir_mem, mlir_transport]
theorem Room.callTmp5 {m : MemoryState} (h : Room m p w) (h0 : p.id ≠ t0.id) (h1 : p.id ≠ t1.id)
    (h2 : p.id ≠ t2.id) (h3 : p.id ≠ t3.id) (h4 : p.id ≠ t4.id) :
    Room (m.callTmp5 t0 t1 t2 t3 t4 Q) p w :=
  have h' :=
    ((((h.lifetimeStart h0).lifetimeStart h1).lifetimeStart h2).lifetimeStart h3).lifetimeStart h4
  ((((h'.storeTmp5.lifetimeEnd h4).lifetimeEnd h3).lifetimeEnd h2).lifetimeEnd h1).lifetimeEnd h0

@[mlir_mem, mlir_transport]
theorem Fits.callTmp5 {m : MemoryState} (h : Fits m p w) (h0 : p.id ≠ t0.id) (h1 : p.id ≠ t1.id)
    (h2 : p.id ≠ t2.id) (h3 : p.id ≠ t3.id) (h4 : p.id ≠ t4.id) :
    Fits (m.callTmp5 t0 t1 t2 t3 t4 Q) p w :=
  have h' :=
    ((((h.lifetimeStart h0).lifetimeStart h1).lifetimeStart h2).lifetimeStart h3).lifetimeStart h4
  ((((h'.storeTmp5.lifetimeEnd h4).lifetimeEnd h3).lifetimeEnd h2).lifetimeEnd h1).lifetimeEnd h0

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Fit.callTmp5 {m : MemoryState} (h : m.Quad5Fit p) (h0 : p.id ≠ t0.id)
    (h1 : p.id ≠ t1.id) (h2 : p.id ≠ t2.id) (h3 : p.id ≠ t3.id) (h4 : p.id ≠ t4.id) :
    (m.callTmp5 t0 t1 t2 t3 t4 Q).Quad5Fit p :=
  have h' :=
    ((((h.lifetimeStart h0).lifetimeStart h1).lifetimeStart h2).lifetimeStart h3).lifetimeStart h4
  ((((h'.storeTmp5.lifetimeEnd h4).lifetimeEnd h3).lifetimeEnd h2).lifetimeEnd h1).lifetimeEnd h0

@[mlir_mem, mlir_transport]
theorem MemoryState.Quad5Room.callTmp5 {m : MemoryState} (h : m.Quad5Room p) (h0 : p.id ≠ t0.id)
    (h1 : p.id ≠ t1.id) (h2 : p.id ≠ t2.id) (h3 : p.id ≠ t3.id) (h4 : p.id ≠ t4.id) :
    (m.callTmp5 t0 t1 t2 t3 t4 Q).Quad5Room p :=
  have h' :=
    ((((h.lifetimeStart h0).lifetimeStart h1).lifetimeStart h2).lifetimeStart h3).lifetimeStart h4
  ((((h'.storeTmp5.lifetimeEnd h4).lifetimeEnd h3).lifetimeEnd h2).lifetimeEnd h1).lifetimeEnd h0

/-- A read past a call's temporaries, in another block. -/
@[mlir_read]
theorem MemoryState.readAt_callTmp5_of_id_ne {m : MemoryState} {q : Pointer} (h0 : t0.id ≠ q.id)
    (h1 : t1.id ≠ q.id) (h2 : t2.id ≠ q.id) (h3 : t3.id ≠ q.id) (h4 : t4.id ≠ q.id) :
    (m.callTmp5 t0 t1 t2 t3 t4 Q).readAt q w = m.readAt q w := by
  simp only [callTmp5, readAt_lifetimeEnd, readAt_storeTmp5_of_id_ne h0 h1 h2 h3 h4,
    readAt_lifetimeStart]

/-- A point past a call's temporaries, in other blocks. -/
@[mlir_read]
theorem MemoryState.readQuad5_callTmp5_of_id_ne {m : MemoryState} {q : Pointer} (h0 : t0.id ≠ q.id)
    (h1 : t1.id ≠ q.id) (h2 : t2.id ≠ q.id) (h3 : t3.id ≠ q.id) (h4 : t4.id ≠ q.id) :
    (m.callTmp5 t0 t1 t2 t3 t4 Q).readQuad5 q = m.readQuad5 q := by
  simp only [callTmp5, readQuad5_lifetimeEnd, readQuad5_storeTmp5_of_id_ne h0 h1 h2 h3 h4,
    readQuad5_lifetimeStart]

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_callTmp5 {m : MemoryState} :
    (m.callTmp5 t0 t1 t2 t3 t4 Q).eraseFrom n = (m.eraseFrom n).callTmp5 t0 t1 t2 t3 t4 Q := by
  simp only [callTmp5, eraseFrom_lifetimeEnd, eraseFrom_storeTmp5, eraseFrom_lifetimeStart]

@[mlir_frame, mlir_erase]
theorem MemoryState.callTmp5_eraseFrom_of_le {m : MemoryState} (h0 : n ≤ t0.id.id)
    (h1 : n ≤ t1.id.id) (h2 : n ≤ t2.id.id) (h3 : n ≤ t3.id.id) (h4 : n ≤ t4.id.id) :
    (m.eraseFrom n).callTmp5 t0 t1 t2 t3 t4 Q = m.eraseFrom n := by
  simp only [callTmp5, lifetimeStart_eraseFrom_of_le, storeTmp5, storeWv, storeAt_eraseFrom_of_le,
    lifetimeEnd_eraseFrom_of_le, h0, h1, h2, h3, h4]

/-- A call's temporaries in the frame, dropped before the erase moves past them. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_callTmp5_of_le {m : MemoryState} (h0 : n ≤ t0.id.id)
    (h1 : n ≤ t1.id.id) (h2 : n ≤ t2.id.id) (h3 : n ≤ t3.id.id) (h4 : n ≤ t4.id.id) :
    (m.callTmp5 t0 t1 t2 t3 t4 Q).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_callTmp5, callTmp5_eraseFrom_of_le h0 h1 h2 h3 h4]

-- the Fit-to-Room projections last among the transports (see `Firedancer.Common.Point`)
attribute [-mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room

attribute [mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room
  MemoryState.Quad5Fit.room

end

end MLIR
