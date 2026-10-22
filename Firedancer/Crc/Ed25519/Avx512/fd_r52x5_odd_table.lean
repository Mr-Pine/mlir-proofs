module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_ge_add
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_to_table
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_odd_table
import Std.Data.ExtHashMap.Lemmas

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- The odd multiples `(2 j + 1) A` as the loop adds them: `A`, then `+ 2 A` each step. -/
def fd_r52x5_odd_table.pt (A : Quad5) : Nat → Quad5
  | 0 => A
  | j + 1 => fd_r52x5_quad_ge_add.spec (pt A j) (fd_r52x5_quad_ge_dbl.spec A)

/-- Entry `j` of `fd_r52x5_odd_table( tab, a, cnt )`: the table form of `(2 j + 1) A`. -/
def fd_r52x5_odd_table.spec (A : Quad5) (j : Nat) : Quad5 :=
  fd_r52x5_quad_to_table.spec (pt A j)

/-- Entries `j … j + c - 1` of `fd_r52x5_odd_table.spec A` stored at `tab`, 160 bytes apart, in
that order. -/
def fd_r52x5_odd_table.storesFrom (m : MemoryState) (tab : Pointer) (A : Quad5) (j : Nat) :
    Nat → MemoryState
  | 0 => m
  | c + 1 => storesFrom (m.storeQuad5 (tab.add (BitVec.ofNat 64 (160 * j)))
      (fd_r52x5_odd_table.spec A j)) tab A (j + 1) c

/-- Room for a table of `n` points at `p`: a name that keeps `Room` from unfolding the size. -/
@[irreducible] def oddTabRoom (m : MemoryState) (p : Pointer) (n : Nat) : Prop :=
  Room m p (1280 * n)

end

/-! ## 160-byte tables -/

/-- Entry `k` of a table of `n` points from `p`, 160 bytes apart, fits where the table does. -/
public theorem Quad5Fit_entry160 {m : MemoryState} {p : Pointer} (h : Fits m p (1280 * n))
    (hp : p.offset.toNat + 160 * n < 2 ^ 64) (hk : k < n) :
    m.Quad5Fit (p.add (BitVec.ofNat 64 (160 * k))) := by
  have hf (o : Nat) (ho : o + 32 ≤ 160) : Fits m (p.add (BitVec.ofNat 64 (160 * k + o))) 256 :=
    Fits.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) h
  have hoff : (p.add (BitVec.ofNat 64 (160 * k))).offset.toNat = p.offset.toNat + 160 * k := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hadd (o : Nat) :
    (p.add (BitVec.ofNat 64 (160 * k))).add (BitVec.ofNat 64 o) =
      p.add (BitVec.ofNat 64 (160 * k + o)) := by
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

/-- Room for entry `k` of a table of `n` points from `p`, 160 bytes apart, where there is room
for the table. -/
public theorem Quad5Room_entry160 {m : MemoryState} {p : Pointer} (h : Room m p (1280 * n))
    (hp : p.offset.toNat + 160 * n < 2 ^ 64) (hk : k < n) :
    m.Quad5Room (p.add (BitVec.ofNat 64 (160 * k))) := by
  have hf (o : Nat) (ho : o + 32 ≤ 160) : Room m (p.add (BitVec.ofNat 64 (160 * k + o))) 256 :=
    Room.add_of_le (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) h
  have hoff : (p.add (BitVec.ofNat 64 (160 * k))).offset.toNat = p.offset.toNat + 160 * k := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  have hadd (o : Nat) :
    (p.add (BitVec.ofNat 64 (160 * k))).add (BitVec.ofNat 64 o) =
      p.add (BitVec.ofNat 64 (160 * k + o)) := by
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

/-! ## Proof -/

section Proof

/-! `oddTabRoom` through the steps, as `Room`. -/

@[local mlir_transport]
theorem oddTabRoom.alloca {s : GlobalState} (hwf : s.WF) (h : oddTabRoom s.mem q n) :
    oddTabRoom (s.alloca k d).mem q n := by
  unfold oddTabRoom at *; exact h.alloca hwf

@[local mlir_transport]
theorem oddTabRoom.lifetimeStart {m : MemoryState} (h : oddTabRoom m p n) (hne : p.id ≠ q.id) :
    oddTabRoom (m.lifetimeStart q) p n := by
  unfold oddTabRoom at *; exact h.lifetimeStart hne

@[local mlir_transport]
theorem oddTabRoom.lifetimeEnd {m : MemoryState} (h : oddTabRoom m p n) (hne : p.id ≠ q.id) :
    oddTabRoom (m.lifetimeEnd q) p n := by
  unfold oddTabRoom at *; exact h.lifetimeEnd hne

@[local mlir_transport]
theorem oddTabRoom.storeAt {m : MemoryState} {x : BitVec w} (h : oddTabRoom m p n) :
    oddTabRoom (m.storeAt q x) p n := by
  unfold oddTabRoom at *; exact h.storeAt

@[local mlir_transport]
theorem oddTabRoom.storeTmp5 {m : MemoryState} (h : oddTabRoom m p n) :
    oddTabRoom (m.storeTmp5 t0 t1 t2 t3 t4 Q) p n := by
  unfold oddTabRoom at *; exact h.storeTmp5

@[local mlir_transport]
theorem oddTabRoom.storeQuad5 {m : MemoryState} (h : oddTabRoom m p n) :
    oddTabRoom (m.storeQuad5 q Q) p n := by
  unfold oddTabRoom at *; exact h.storeQuad5

@[local mlir_transport]
theorem oddTabRoom.callTmp5 {m : MemoryState} (h : oddTabRoom m p n) (h0 : p.id ≠ t0.id)
    (h1 : p.id ≠ t1.id) (h2 : p.id ≠ t2.id) (h3 : p.id ≠ t3.id) (h4 : p.id ≠ t4.id) :
    oddTabRoom (m.callTmp5 t0 t1 t2 t3 t4 Q) p n := by
  unfold oddTabRoom at *; exact h.callTmp5 h0 h1 h2 h3 h4


/-! `storesFrom` through the steps: stores into the table only. -/

@[mlir_transport]
public theorem GlobalState.WF.storesFrom {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) :
    ∀ c j, (⟨a, fd_r52x5_odd_table.storesFrom m tab A j c⟩ : GlobalState).WF
  | 0, _ => h
  | c + 1, j => GlobalState.WF.storesFrom h.storeQuad5_mk c (j + 1)

@[mlir_mem, mlir_transport]
public theorem Fits.storesFrom {m : MemoryState} (h : Fits m p w) :
    ∀ c j, Fits (fd_r52x5_odd_table.storesFrom m tab A j c) p w
  | 0, _ => h
  | c + 1, j => Fits.storesFrom h.storeQuad5 c (j + 1)

@[mlir_mem, mlir_transport]
public theorem Room.storesFrom {m : MemoryState} (h : Room m p w) :
    ∀ c j, Room (fd_r52x5_odd_table.storesFrom m tab A j c) p w
  | 0, _ => h
  | c + 1, j => Room.storesFrom h.storeQuad5 c (j + 1)

@[mlir_mem, mlir_transport]
public theorem InBounds.storesFrom {m : MemoryState} (h : InBounds m p w) :
    ∀ c j, InBounds (fd_r52x5_odd_table.storesFrom m tab A j c) p w
  | 0, _ => h
  | c + 1, j => InBounds.storesFrom h.storeQuad5 c (j + 1)

@[mlir_mem, mlir_transport]
public theorem Writable.storesFrom' {m : MemoryState} (h : Writable m p) :
    ∀ c j, Writable (fd_r52x5_odd_table.storesFrom m tab A j c) p
  | 0, _ => h
  | c + 1, j => Writable.storesFrom' h.storeQuad5 c (j + 1)

@[mlir_mem, mlir_transport]
public theorem MemoryState.Quad5Fit.storesFrom {m : MemoryState} (h : m.Quad5Fit p) :
    ∀ c j, (fd_r52x5_odd_table.storesFrom m tab A j c).Quad5Fit p
  | 0, _ => h
  | c + 1, j => MemoryState.Quad5Fit.storesFrom h.storeQuad5 c (j + 1)

/-- The state `fd_r52x5_odd_table.call_eq` leaves: `WF`. -/
@[mlir_transport]
public theorem GlobalState.WF.storesFrom_add {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, fd_r52x5_odd_table.storesFrom s.mem tab A j c⟩ : GlobalState).WF :=
  GlobalState.WF.storesFrom h.add_blocks c j

@[mlir_mem, mlir_transport]
public theorem MemoryState.Quad5Room.storesFrom {m : MemoryState} (h : m.Quad5Room p) :
    ∀ c j, (fd_r52x5_odd_table.storesFrom m tab A j c).Quad5Room p
  | 0, _ => h
  | c + 1, j => MemoryState.Quad5Room.storesFrom h.storeQuad5 c (j + 1)

@[mlir_transport]
public theorem oddTabRoom.storesFrom {m : MemoryState} (h : oddTabRoom m p n) :
    ∀ c j, oddTabRoom (fd_r52x5_odd_table.storesFrom m tab A j c) p n
  | 0, _ => h
  | c + 1, j => oddTabRoom.storesFrom h.storeQuad5 c (j + 1)

@[mlir_read]
public theorem MemoryState.readQuad5_storesFrom_of_id_ne {m : MemoryState} (hne : tab.id ≠ q.id) :
    ∀ c j, (fd_r52x5_odd_table.storesFrom m tab A j c).readQuad5 q = m.readQuad5 q
  | 0, _ => rfl
  | c + 1, j => by
    rw [fd_r52x5_odd_table.storesFrom, MemoryState.readQuad5_storesFrom_of_id_ne hne c (j + 1),
      MemoryState.readQuad5_storeQuad5_of_id_ne (by simpa [Pointer.add_id] using hne)]

public theorem MemoryState.eraseFrom_storesFrom' {m : MemoryState} :
    ∀ c j, (fd_r52x5_odd_table.storesFrom m tab A j c).eraseFrom b =
      fd_r52x5_odd_table.storesFrom (m.eraseFrom b) tab A j c
  | 0, _ => rfl
  | c + 1, j => by
    rw [fd_r52x5_odd_table.storesFrom, fd_r52x5_odd_table.storesFrom,
      MemoryState.eraseFrom_storesFrom' c, MemoryState.eraseFrom_storeQuad5]

@[mlir_read]
public theorem MemoryState.readAt_storesFrom_of_id_ne {m : MemoryState} (hne : tab.id ≠ q.id) :
    ∀ c j, (fd_r52x5_odd_table.storesFrom m tab A j c).readAt q w = m.readAt q w
  | 0, _ => rfl
  | c + 1, j => by
    rw [fd_r52x5_odd_table.storesFrom, MemoryState.readAt_storesFrom_of_id_ne hne c (j + 1),
      MemoryState.readAt_storeQuad5_of_id_ne (by simpa [Pointer.add_id] using hne)]

namespace fd_r52x5_odd_table

/-! Reads and fits of blocks below `n` pass through `eraseFrom n`; a pointer below a frame's
`nextFreeBlock` is in none of its slots. -/

theorem readAt_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n).readAt p w = m.readAt p w := by
  simp only [MemoryState.readAt, MemoryState.eraseFrom, MemoryState.getElem?_eq,
    Std.ExtHashMap.getElem?_filter', h, decide_true]
  cases m.mem[p.id]? <;> rfl

theorem readQuad5_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n).readQuad5 p = m.readQuad5 p := by
  have h' : ∀ o : BitVec 64, (p.add o).id.id < n := fun o => by simpa using h
  simp only [MemoryState.readQuad5, MemoryState.readWv, readAt_eraseFrom_of_lt h,
    readAt_eraseFrom_of_lt (h' _)]

theorem fits_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Fits (m.eraseFrom n) p w) :
    Fits m p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := h
  refine ⟨b, ?_, hl, hw, hd⟩
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

theorem quad5Fit_of_eraseFrom {m : MemoryState} {p : Pointer} (h : (m.eraseFrom n).Quad5Fit p) :
    m.Quad5Fit p :=
  ⟨h.1, fits_of_eraseFrom h.2.1, fits_of_eraseFrom h.2.2.1, fits_of_eraseFrom h.2.2.2.1,
    fits_of_eraseFrom h.2.2.2.2.1, fits_of_eraseFrom h.2.2.2.2.2⟩

/-- A pointer below the frame is in no slot. -/
theorem ne_slot {B : GlobalState} {p : Pointer} (h : p.id.id < B.alloc.nextFreeBlock) :
    p.id ≠ (B.slot j).id := fun he => by
  have := congrArg BlockId.id he
  simp at this
  omega

theorem eraseFrom_callTmp5_slot {B : GlobalState} {m : MemoryState} {Q : Quad5} :
    (m.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q).eraseFrom
        B.alloc.nextFreeBlock =
      m.eraseFrom B.alloc.nextFreeBlock :=
  MemoryState.eraseFrom_callTmp5_of_le (by simp) (by simp) (by simp) (by simp) (by simp)

/-- Entries `0 … j - 1` of the table at `p` hold `spec A`, in fit; the rest of its room kept. -/
def Filled (m : MemoryState) (p : Pointer) (A : Quad5) (j n : Nat) : Prop :=
  oddTabRoom m p n ∧
    ∀ k < j,
      m.Quad5Fit (p.add (BitVec.ofNat 64 (160 * k))) ∧
        m.readQuad5 (p.add (BitVec.ofNat 64 (160 * k))) = fd_r52x5_odd_table.spec A k

/-- The registers the loop reads: the temporaries are slots `10 … 19` of the frame `B`. -/
abbrev LoopEnv (E : ⟪Γ⟫) (A : Quad5) (n : Nat) (B : GlobalState) : Prop :=
  E ⊨ [%1183 := 1#64, %1194 := B.slot 10, %1195 := B.slot 11, %1196 := B.slot 12,
    %1197 := B.slot 13, %1198 := B.slot 14, %1199 := B.slot 15, %1200 := B.slot 16,
    %1201 := B.slot 17, %1202 := B.slot 18, %1203 := B.slot 19,
    %1213 := (fd_r52x5_quad_ge_dbl.spec A).P0, %1214 := (fd_r52x5_quad_ge_dbl.spec A).P1,
    %1215 := (fd_r52x5_quad_ge_dbl.spec A).P2, %1216 := (fd_r52x5_quad_ge_dbl.spec A).P3,
    %1217 := (fd_r52x5_quad_ge_dbl.spec A).P4, %1227 := BitVec.ofNat 64 n]

/-- The header `^bb2` at counter `j` holding `P`. -/
abbrev hdr (E : ⟪Γ⟫) (P : Quad5) (j : Nat) : ⟪Γ⟫ :=
  E[%1228 := .value (BitVec.ofNat 64 j), %1229 := Ty.wrap P.P0, %1230 := Ty.wrap P.P1,
    %1231 := Ty.wrap P.P2, %1232 := Ty.wrap P.P3, %1233 := Ty.wrap P.P4]

/-- One trip through `^bb2` at counter `j`, `1 ≤ j < n`, with `pt A (j - 1)` in the registers:
entry `j` stored, `pt A j` into the registers, 115 blocks used; then back to the header if
`j + 1 < n`, else to the exit. -/
theorem trip (tab a : Pointer) (cnt : BitVec 32) (A : Quad5) (n : Nat) (B : GlobalState) (j : Nat)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value tab) (.value a) (.value cnt)).get)
    (hR : LoopEnv E A n B) (hwf : S.WF) (hT : SlotFrame B 20 S.mem) (hF : Filled S.mem tab A j n)
    (htb : tab.id.id < B.alloc.nextFreeBlock) (hto : tab.offset.toNat + 160 * 128 < 2 ^ 64)
    (m₀ : MemoryState) (hm₀ : S.mem = m₀) (hj : 1 ≤ j) (hjn : j < n) (hn : n ≤ 128)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value tab) (.value a) (.value cnt)).get →
          LoopEnv E' A n B → S'.WF → SlotFrame B 20 S'.mem → Filled S'.mem tab A (j + 1) n →
          S'.alloc = ⟨S.alloc.nextFreeBlock + 90 + 25⟩ →
          S'.mem.eraseFrom B.alloc.nextFreeBlock =
            (S.mem.storeQuad5 (tab.add (BitVec.ofNat 64 (160 * j)))
              (fd_r52x5_odd_table.spec A j)).eraseFrom B.alloc.nextFreeBlock →
          (if j + 1 = n then fd_r52x5_odd_table.runFrom E' 1 S' >>= g
           else fd_r52x5_odd_table.runFrom (hdr E' (fd_r52x5_odd_table.pt A j) (j + 1)) 2 S' >>= g) =
            K) :
    (fd_r52x5_odd_table.runFrom (hdr E (fd_r52x5_odd_table.pt A (j - 1)) j) 2 S >>= g) = K := by
  obtain ⟨ht, hfill⟩ := hF
  have hqj : S.mem.Quad5Room (tab.add (BitVec.ofNat 64 (160 * j))) :=
    Quad5Room_entry160 (n := n) (by unfold oddTabRoom at ht; exact ht)
      (by omega) hjn
  generalize hP : tab.add (BitVec.ofNat 64 (160 * j)) = P at hqj
  have hPid : P.id.id < B.alloc.nextFreeBlock := by rw [← hP]; exact htb
  have u0 : P.id ≠ (B.slot 10).id := ne_slot hPid
  have u1 : P.id ≠ (B.slot 11).id := ne_slot hPid
  have u2 : P.id ≠ (B.slot 12).id := ne_slot hPid
  have u3 : P.id ≠ (B.slot 13).id := ne_slot hPid
  have u4 : P.id ≠ (B.slot 14).id := ne_slot hPid
  have u5 : P.id ≠ (B.slot 15).id := ne_slot hPid
  have u6 : P.id ≠ (B.slot 16).id := ne_slot hPid
  have u7 : P.id ≠ (B.slot 17).id := ne_slot hPid
  have u8 : P.id ≠ (B.slot 18).id := ne_slot hPid
  have u9 : P.id ≠ (B.slot 19).id := ne_slot hPid
  have hroomP : ((m₀.callTmp5 (B.slot 10) (B.slot 11) (B.slot 12) (B.slot 13) (B.slot 14)
      (fd_r52x5_odd_table.pt A j)).callTmp5 (B.slot 15) (B.slot 16) (B.slot 17) (B.slot 18)
      (B.slot 19) (fd_r52x5_odd_table.spec A j)).Quad5Room P :=
    ((hm₀ ▸ hqj : m₀.Quad5Room P).callTmp5 u0 u1 u2 u3 u4).callTmp5 u5 u6 u7 u8 u9
  block_init
  step_pattern' using runBodyFrom_leafRun2A (hf := fd_r52x5_quad_ge_add.call_eq)
    (X := fd_r52x5_odd_table.pt A (j - 1)) (Y := fd_r52x5_quad_ge_dbl.spec A) (B := B)
    (k0 := 10) (k1 := 11) (k2 := 12) (k3 := 13) (k4 := 14) with t0
  step_pattern' using runBodyFrom_leafRun1A (hf := fd_r52x5_quad_to_table.call_eq) (B := B)
    (k0 := 15) (k1 := 16) (k2 := 17) (k3 := 18) (k4 := 19) with t1
  subst hv56 hv61
  step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega), Nat.mul_comm j 160,
    show 160 * j < 2 ^ 64 by omega]
  have hpt : fd_r52x5_odd_table.pt A j =
      fd_r52x5_quad_ge_add.spec (fd_r52x5_odd_table.pt A (j - 1)) (fd_r52x5_quad_ge_dbl.spec A) := by
    obtain ⟨i, rfl⟩ : ∃ i, j = i + 1 := ⟨j - 1, by omega⟩
    rfl
  rw [← hpt] at ht0
  rw [hP] at hE
  have hqS : S.mem.Quad5Room P := hqj
  step_pattern' using runBodyFrom_storeQuad5Run (Q := t1) (P := P)
  have hadd : (BitVec.ofNat 64 j).saddOverflow 1#64 = false ∧
      (BitVec.ofNat 64 j).uaddOverflow 1#64 = false := by
    simp only [BitVec.saddOverflow, BitVec.uaddOverflow, BitVec.toInt, BitVec.toNat_ofNat]
    constructor <;> simp <;> omega
  step_pure [hadd]
  step_pure
  have hj1 : (BitVec.ofNat 64 j + 1#64) = BitVec.ofNat 64 (j + 1) := (BitVec.ofNat_add _ _).symm
  subst ht1 ht0
  have hmem : S.mem = ((m₀.callTmp5 (B.slot 10) (B.slot 11) (B.slot 12) (B.slot 13) (B.slot 14)
      (fd_r52x5_odd_table.pt A j)).callTmp5 (B.slot 15) (B.slot 16) (B.slot 17) (B.slot 18)
      (B.slot 19) (fd_r52x5_odd_table.spec A j)).storeQuad5 P (fd_r52x5_odd_table.spec A j) := by
    rw [hS, ← hm₀]; rfl
  have hF' : Filled S.mem tab A (j + 1) n := by
    refine ⟨ht, fun k hk => ?_⟩
    rw [hmem]
    by_cases hkj : k = j
    · subst hkj
      rw [← hP]
      have hroom := hroomP
      rw [← hP] at hroom
      exact ⟨MemoryState.Quad5Fit.storeQuad5_self hroom, MemoryState.readQuad5_storeQuad5_self hroom⟩
    · obtain ⟨hf, hr⟩ := hfill k (by omega)
      rw [hm₀] at hf hr
      have hk' : k < j := by omega
      have hne' (i : Nat) : (B.slot i).id ≠ (tab.add (BitVec.ofNat 64 (160 * k))).id :=
        (ne_slot (B := B) (j := i) htb).symm
      refine ⟨((hf.callTmp5 (hne' _).symm (hne' _).symm (hne' _).symm (hne' _).symm
        (hne' _).symm).callTmp5 (hne' _).symm (hne' _).symm (hne' _).symm
        (hne' _).symm (hne' _).symm).storeQuad5, ?_⟩
      rw [← hP, MemoryState.readQuad5_storeQuad5_apart (by omega) (by omega) (by omega),
        MemoryState.readQuad5_callTmp5_of_id_ne (hne' _) (hne' _) (hne' _) (hne' _) (hne' _),
        MemoryState.readQuad5_callTmp5_of_id_ne (hne' _) (hne' _) (hne' _) (hne' _) (hne' _), hr]
  have her : S.mem.eraseFrom B.alloc.nextFreeBlock =
      (m₀.storeQuad5 P (fd_r52x5_odd_table.spec A j)).eraseFrom B.alloc.nextFreeBlock := by
    rw [hmem, MemoryState.eraseFrom_storeQuad5, MemoryState.eraseFrom_storeQuad5,
      eraseFrom_callTmp5_slot, eraseFrom_callTmp5_slot]
  rw [← hP, ← hm₀] at her
  have hal := congrArg GlobalState.alloc hS
  simp only at hal
  have hK' := fun E' h1 h2 => hK E' S h1 h2 hwf hT hF' hal her
  clear hK hfill hmem hroomP hqj
  finish_block
  · have hjn1 : j + 1 = n := by
      have := congrArg BitVec.toNat hbr; simp [BitVec.toNat_add] at this; omega
    simp only [hjn1, ite_true] at hK'
    run_from using hK'
  · have hjn1 : j + 1 ≠ n := by
      intro e; apply hbr; rw [hj1, e]
    simp only [hjn1, ite_false] at hK'
    run_from using hK'

public theorem eraseFrom_storesFrom {m : MemoryState} :
    ∀ (c j : Nat), (fd_r52x5_odd_table.storesFrom m tab A j c).eraseFrom b =
      fd_r52x5_odd_table.storesFrom (m.eraseFrom b) tab A j c
  | 0, _ => rfl
  | c + 1, j => by
    rw [fd_r52x5_odd_table.storesFrom, fd_r52x5_odd_table.storesFrom, eraseFrom_storesFrom c,
      MemoryState.eraseFrom_storeQuad5]

/-- The loop from `^bb2` at counter `j` with `pt A (j - 1)` in the registers and `m + 1` trips
left (`j + m + 1 = n`): at the exit the table is `Filled` to `n`, `115 (m + 1)` blocks used, the
frame below `B` holding the entries' stores. -/
theorem loop (tab a : Pointer) (cnt : BitVec 32) (A : Quad5) (n : Nat) (B : GlobalState)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (htb : tab.id.id < B.alloc.nextFreeBlock) (hto : tab.offset.toNat + 160 * 128 < 2 ^ 64)
    (hn : n ≤ 128) :
    ∀ m j (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value tab) (.value a) (.value cnt)).get →
        LoopEnv E A n B → 1 ≤ j → j + m + 1 = n →
        S.WF → SlotFrame B 20 S.mem → Filled S.mem tab A j n →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value tab) (.value a) (.value cnt)).get →
            S'.WF → Filled S'.mem tab A n n →
            S'.alloc = ⟨S.alloc.nextFreeBlock + 115 * (m + 1)⟩ →
            S'.mem.eraseFrom B.alloc.nextFreeBlock =
              (fd_r52x5_odd_table.storesFrom S.mem tab A j (m + 1)).eraseFrom
                B.alloc.nextFreeBlock →
            (fd_r52x5_odd_table.runFrom E' 1 S' >>= g) = K) →
        (fd_r52x5_odd_table.runFrom (hdr E (fd_r52x5_odd_table.pt A (j - 1)) j) 2 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro j S E hArgs hR hj hjm hwf hT hF hK
    refine trip tab a cnt A n B j S E g K hArgs hR hwf hT hF htb hto S.mem rfl hj (by omega) hn ?_
    intro E' S' h1 h2 h3 h4 h5 h6 h7
    rw [ite_eq_left (by omega)]
    exact hK E' S' h1 h3 (by simpa [show j + 1 = n by omega] using h5) (by rw [h6])
      (by rw [h7]; rfl)
  | succ m ih =>
    intro j S E hArgs hR hj hjm hwf hT hF hK
    refine trip tab a cnt A n B j S E g K hArgs hR hwf hT hF htb hto S.mem rfl hj (by omega) hn ?_
    intro E' S' h1 h2 h3 h4 h5 h6 h7
    rw [ite_eq_right (show ¬j + 1 = n by omega)]
    have := ih (j + 1) S' E' h1 h2 (by omega) (by omega) h3 h4 h5
      (fun E'' S'' f1 f2 f3 f4 f5 => hK E'' S'' f1 f2 f3 (by
        rw [f4, h6, AllocState.mk.injEq]; dsimp only; omega) (by
        rw [f5, eraseFrom_storesFrom, h7, ← eraseFrom_storesFrom]; rfl))
    simpa using this

end fd_r52x5_odd_table

public theorem fd_r52x5_odd_table.call_eq (tab a : Pointer) (cnt : BitVec 32) (s : GlobalState)
    (hwf : s.WF) (ha : s.mem.Quad5Fit a) (ht : oddTabRoom s.mem tab cnt.toNat)
    (hto : tab.offset.toNat + 160 * 128 < 2 ^ 64) (hn : 4 ≤ cnt.toNat ∧ cnt.toNat ≤ 128) :
    fd_r52x5_odd_table.call (fd_r52x5_odd_table.args (.value tab) (.value a) (.value cnt)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + (125 + 115 * (cnt.toNat - 1))⟩,
            mem := fd_r52x5_odd_table.storesFrom s.mem tab (s.mem.readQuad5 a) 0 cnt.toNat }) := by
  have hq0 : s.mem.Quad5Room tab := by
    have := Quad5Room_entry160 (n := cnt.toNat) (k := 0) (by unfold oddTabRoom at ht; exact ht)
      (by omega) (by omega)
    simpa [Pointer.add_ofNat_zero] using this
  obtain ⟨A, hA⟩ : ∃ A, s.mem.readQuad5 a = A := ⟨_, rfl⟩
  rw [hA]
  func_init
  block_init
  iterate 2 step_pure
  refine runBodyFrom_allocas ([%1184, %1185, %1186, %1187, %1188, %1189, %1190, %1191, %1192,
    %1193, %1194, %1195, %1196, %1197, %1198, %1199, %1200, %1201, %1202, %1203] :
    List (Dst fd_r52x5_odd_table.Γ .ptr)) (rest := bb0.body.drop 22) rfl hwf ?_
  intro S' hwf' hF hRoom hAl hErase
  subst hS
  simp only [writeSlots, List.length_cons, List.length_nil, Nat.reduceAdd] at hF hAl ⊢
  rename' S => S₀
  have hE0 : S'.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by rw [hErase, hwf₀.eraseFrom]
  have hrb : tab.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt hq0.2.1.mem
  have hab : a.id.id < S₀.alloc.nextFreeBlock := hwf₀.lt ha.2.1.inBounds.mem
  have hA' : S'.mem.readQuad5 a = A := by
    rw [← fd_r52x5_odd_table.readQuad5_eraseFrom_of_lt hab, hE0, hA]
  obtain ⟨hao, hf0, hf1, hf2, hf3, hf4⟩ : S'.mem.Quad5Fit a :=
    fd_r52x5_odd_table.quad5Fit_of_eraseFrom (by rw [hE0]; exact ha)
  have ht' : oddTabRoom S'.mem tab cnt.toNat := by
    unfold oddTabRoom at ht ⊢; exact hRoom _ _ ht
  have hq0' : S'.mem.Quad5Room tab :=
    ⟨hq0.1, hRoom _ _ hq0.2.1, hRoom _ _ hq0.2.2.1, hRoom _ _ hq0.2.2.2.1, hRoom _ _ hq0.2.2.2.2.1,
      hRoom _ _ hq0.2.2.2.2.2⟩
  obtain ⟨hto', hr0, hr1, hr2, hr3, hr4⟩ := hq0'
  have hP0 := congrArg Quad5.P0 hA'
  have hP1 := congrArg Quad5.P1 hA'
  have hP2 := congrArg Quad5.P2 hA'
  have hP3 := congrArg Quad5.P3 hA'
  have hP4 := congrArg Quad5.P4 hA'
  simp only [MemoryState.readQuad5] at hP0 hP1 hP2 hP3 hP4
  obtain ⟨M, hM⟩ : ∃ M, S'.mem = M := ⟨_, rfl⟩
  have hS : S' = { alloc := ⟨S₀.alloc.nextFreeBlock + 20⟩, mem := M } := by rw [← hM, ← hAl]
  rw [hM] at hE0
  clear hRoom hErase hAl hM ha ht hq0 hA hwf₀ ha₀ ha₀_1 ha₀_2 ha₀_3 ha₀_4 hq0₀ hq0₀_1 hq0₀_2 hq0₀_3
    hq0₀_4 hA'
  rename' S' => S, hwf' => hwf
  step_load [ofFn_extractVecElem_readAt, hP0] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt, hP1] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt, hP2] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt, hP3] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt, hP4] inline
  clear hP0 hP1 hP2 hP3 hP4 hf0 hf1 hf2 hf3 hf4 hao
  step_pattern' using runBodyFrom_leafRun1A (hf := fd_r52x5_quad_ge_dbl.call_eq) (X := A) (B := S₀)
    (k0 := 0) (k1 := 1) (k2 := 2) (k3 := 3) (k4 := 4) with D
  step_pattern' using runBodyFrom_leafRun1A (hf := fd_r52x5_quad_to_table.call_eq) (X := A)
    (B := S₀) (k0 := 5) (k1 := 6) (k2 := 7) (k3 := 8) (k4 := 9) with T
  have hqT : S.mem.Quad5Room tab := ⟨hto', hr0, hr1, hr2, hr3, hr4⟩
  step_pattern' using runBodyFrom_storeQuad5Run (Q := T) (P := tab)
  step_pure
  finish_block
  subst hv35 hD hT
  have hFl : fd_r52x5_odd_table.Filled S.mem tab A 1 cnt.toNat := by
    refine ⟨ht', fun k hk => ?_⟩
    obtain rfl : k = 0 := by omega
    simp only [Nat.mul_zero, Pointer.add_ofNat_zero]
    exact ⟨hqT, hread_tab_readQuad5⟩
  run_from using fd_r52x5_odd_table.loop tab a cnt A cnt.toNat S₀ _ _ hrb hto (by omega)
    (cnt.toNat - 2) 1
  · intro hmsb
    exfalso
    rw [BitVec.msb_eq_true_iff_two_mul_ge] at hmsb
    omega
  · intro _ hF' hal hm
    block_init
    finish_block
    subst_vars
    rw [hm, fd_r52x5_odd_table.eraseFrom_storesFrom, hal]
    rw [MemoryState.eraseFrom_storeQuad5,
      fd_r52x5_odd_table.eraseFrom_callTmp5_slot, fd_r52x5_odd_table.eraseFrom_callTmp5_slot, hE0]
    obtain ⟨c, hc⟩ : ∃ c, cnt.toNat = c + 2 := ⟨cnt.toNat - 2, by omega⟩
    rw [hc, show c + 2 - 2 + 1 = c + 1 by omega, show c + 2 = (c + 1) + 1 by omega,
      fd_r52x5_odd_table.storesFrom]
    have e0 : S₀.mem.storeQuad5 tab (fd_r52x5_quad_to_table.spec A) =
        S₀.mem.storeQuad5 (tab.add (BitVec.ofNat 64 (160 * 0))) (fd_r52x5_odd_table.spec A 0) := by
      rw [Nat.mul_zero, Pointer.add_ofNat_zero]; rfl
    rw [e0]
    congr 3
    simp only [AllocState.mk.injEq]
    omega

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
