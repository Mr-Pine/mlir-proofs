module

public import Firedancer.Lane.Common.Jacobi
public import MLIR.Run.Tactic

/-! Five-limb arrays of `long` in memory, as `fd_f25519_update_fg_62_var` and
`fd_f25519_jacobi_var` hold `f` and `g`. -/

namespace MLIR.Firedancer.Lane.Jacobi

@[expose] public section

/-- The five limbs at `p`. -/
def limbsAt (m : MemoryState) (p : Pointer) : Vector (BitVec 64) 5 :=
  Vector.ofFn fun k : Fin 5 => m.readAt (p.add (BitVec.ofNat 64 (8 * k))) 64

/-- `f[k] = F[k]; g[k] = G[k]` for `k < len`, in turn. -/
def storeFG (m : MemoryState) (f g : Pointer) (F G : Vector (BitVec 64) 5) :
    Nat → MemoryState
  | 0 => m
  | n + 1 =>
    ((storeFG m f g F G n).storeAt (f.add (BitVec.ofNat 64 (8 * n))) F[n]!).storeAt
      (g.add (BitVec.ofNat 64 (8 * n))) G[n]!

/-- Five limbs as one 320-bit value, limb `0` lowest. -/
def packF (F : Vector (BitVec 64) 5) : BitVec 320 :=
  F[4] ++ F[3] ++ F[2] ++ F[1] ++ F[0]

end

/-- `+` left-commutes, for normalizing sums with `add_comm` and `add_assoc`. -/
public theorem add_left_comm {w : Nat} (a b c : BitVec w) : a + (b + c) = b + (a + c) := by
  rw [← BitVec.add_assoc, BitVec.add_comm a b, BitVec.add_assoc]

/-- A compiled carry step, `(f[i] u + c) + g[i] v`, as `updLoop`'s `c + (u f[i] + v g[i])`. -/
public theorem carry_step (c : BitVec 128) (u v a b : BitVec 64) :
    a.signExtend 128 * u.signExtend 128 + c + b.signExtend 128 * v.signExtend 128 =
      c + (ext u * ext a + ext v * ext b) := by
  simp only [ext, BitVec.mul_comm (u.signExtend 128), BitVec.mul_comm (v.signExtend 128)]
  rw [← BitVec.add_assoc, BitVec.add_comm c]

/-- The compiled first carry, `g[0] v + f[0] u`, as `updateFg`'s `u f[0] + v g[0]`. -/
public theorem carry_init (u v a b : BitVec 64) :
    b.signExtend 128 * v.signExtend 128 + a.signExtend 128 * u.signExtend 128 =
      ext u * ext a + ext v * ext b := by
  simp only [ext, BitVec.mul_comm (u.signExtend 128), BitVec.mul_comm (v.signExtend 128)]
  exact BitVec.add_comm _ _

/-- `p` zero bytes on. -/
@[simp] public theorem add_zero (p : Pointer) : p.add 0#64 = p := by
  simp [Pointer.add]

/-- `p.add` stays in `p`'s block. -/
@[simp] public theorem add_id (p : Pointer) (off : BitVec 64) : (p.add off).id = p.id := rfl

/-- Erasing a well-formed state's frame from its next free block leaves its memory. -/
public theorem mem_eraseFrom_self {s : GlobalState} (hs : s.WF) :
    s.mem.eraseFrom s.alloc.nextFreeBlock = s.mem :=
  congrArg GlobalState.mem (GlobalState.eraseFrom_self hs)

private theorem noov_of_le {p : Pointer} {off : BitVec 64} (ho : ¬p.offset.uaddOverflow 40#64)
    (h : off.toNat ≤ 40) : ¬p.offset.uaddOverflow off := by
  simp [BitVec.uaddOverflow] at *
  omega

/-- Room for the five limbs at `p`, one at a time. -/
public theorem room_limbs {m : MemoryState} {p : Pointer} (h : Room m p 320)
    (ho : ¬p.offset.uaddOverflow 40#64) :
    Room m p 64 ∧ Room m (p.add 8#64) 64 ∧ Room m (p.add 16#64) 64 ∧ Room m (p.add 24#64) 64 ∧
      Room m (p.add 32#64) 64 :=
  ⟨h.mono (by omega), Room.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Room.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Room.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Room.add_of_le (noov_of_le ho (by decide)) (by decide) h⟩

/-- The five limbs at `p` fit, one at a time. -/
public theorem fits_limbs {m : MemoryState} {p : Pointer} (h : Fits m p 320)
    (ho : ¬p.offset.uaddOverflow 40#64) :
    Fits m p 64 ∧ Fits m (p.add 8#64) 64 ∧ Fits m (p.add 16#64) 64 ∧ Fits m (p.add 24#64) 64 ∧
      Fits m (p.add 32#64) 64 :=
  ⟨h.mono (by omega), Fits.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Fits.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Fits.add_of_le (noov_of_le ho (by decide)) (by decide) h,
    Fits.add_of_le (noov_of_le ho (by decide)) (by decide) h⟩

/-- Limb `k`'s offset in bits, for `k ≤ 5`. -/
private theorem offsetInBits_limb {p : Pointer} (ho : ¬p.offset.uaddOverflow 40#64) {k : Nat}
    (hk : k ≤ 5) : (p.add (BitVec.ofNat 64 (8 * k))).offsetInBits = p.offsetInBits + 64 * k := by
  rw [Pointer.offsetInBits_add (noov_of_le ho (by simp; omega))]
  simp
  omega

/-- Two limbs of one array do not overlap. -/
private theorem limb_disjoint {p : Pointer} (ho : ¬p.offset.uaddOverflow 40#64) {a b : Nat}
    (ha : a < 5) (hb : b < 5) (hab : a ≠ b) :
    (Range.of (p.add (BitVec.ofNat 64 (8 * a))) 64).Disjoint
      (Range.of (p.add (BitVec.ofNat 64 (8 * b))) 64) := by
  simp only [Range.Disjoint, Range.of, offsetInBits_limb ho (Nat.le_of_lt ha),
    offsetInBits_limb ho (Nat.le_of_lt hb)]
  omega

/-- Room for limb `k < 5`. -/
private theorem room_limb {m : MemoryState} {p : Pointer} (h : Room m p 320)
    (ho : ¬p.offset.uaddOverflow 40#64) {k : Nat} (hk : k < 5) :
    Room m (p.add (BitVec.ofNat 64 (8 * k))) 64 :=
  Room.add_of_le (noov_of_le ho (by simp; omega)) (by simp; omega) h

/-- `storeFG` keeps room. -/
@[mlir_transport]
public theorem room_storeFG {m : MemoryState} {f g p : Pointer} {F G : Vector (BitVec 64) 5}
    {w : Nat} {n : Nat} (h : Room m p w) : Room (storeFG m f g F G n) p w := by
  induction n with
  | zero => exact h
  | succ n ih => exact Room.storeAt (Room.storeAt ih)

/-- `storeFG` keeps known bits known. -/
@[mlir_transport]
public theorem fits_storeFG {m : MemoryState} {f g p : Pointer} {F G : Vector (BitVec 64) 5}
    {w : Nat} {n : Nat} (h : Fits m p w) : Fits (storeFG m f g F G n) p w := by
  induction n with
  | zero => exact h
  | succ n ih => exact Fits.storeAt (Fits.storeAt ih)

/-- `storeFG` keeps bounds. -/
@[mlir_transport]
public theorem inBounds_storeFG {m : MemoryState} {f g p : Pointer} {F G : Vector (BitVec 64) 5}
    {w : Nat} {n : Nat} (h : InBounds m p w) : InBounds (storeFG m f g F G n) p w := by
  induction n with
  | zero => exact h
  | succ n ih => exact InBounds.storeAt (InBounds.storeAt ih)

/-- `storeFG` keeps writability. -/
@[mlir_transport]
public theorem writable_storeFG {m : MemoryState} {f g p : Pointer} {F G : Vector (BitVec 64) 5}
    {n : Nat} (h : Writable m p) : Writable (storeFG m f g F G n) p := by
  induction n with
  | zero => exact h
  | succ n ih => exact Writable.storeAt (Writable.storeAt ih)

/-- `storeFG` keeps a state well formed. -/
@[mlir_transport]
public theorem wf_storeFG_mk {a : AllocState} {m : MemoryState} {f g : Pointer}
    {F G : Vector (BitVec 64) 5} {n : Nat} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, storeFG m f g F G n⟩ : GlobalState).WF := by
  induction n with
  | zero => exact h
  | succ n ih => exact GlobalState.WF.storeAt_mk (GlobalState.WF.storeAt_mk ih)

/-- `storeFG` leaves other blocks' bits. -/
public theorem readAt_storeFG_of_ne {m : MemoryState} {f g p : Pointer}
    {F G : Vector (BitVec 64) 5} {w n : Nat} (hf : f.id ≠ p.id) (hg : g.id ≠ p.id) :
    (storeFG m f g F G n).readAt p w = m.readAt p w := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [storeFG]
    rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (p := g.add _) hg),
      MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (p := f.add _) hf), ih]

/-- `storeFG` into blocks at or above `b`, erased from `b`: nothing. -/
public theorem eraseFrom_storeFG {m : MemoryState} {f g : Pointer} {F G : Vector (BitVec 64) 5}
    {b n : Nat} (hf : b ≤ f.id.id) (hg : b ≤ g.id.id) :
    (storeFG m f g F G n).eraseFrom b = m.eraseFrom b := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [storeFG]
    rw [MemoryState.eraseFrom_storeAt_of_le (p := g.add _) hg,
      MemoryState.eraseFrom_storeAt_of_le (p := f.add _) hf, ih]

/-- Limb `k` of `f` after `storeFG`: stored if `k < n`, else as before. -/
public theorem readAt_storeFG_f {m : MemoryState} {f g : Pointer} {F G : Vector (BitVec 64) 5}
    (hfg : f.id ≠ g.id) (hf : Room m f 320) (ho : ¬f.offset.uaddOverflow 40#64) {k : Nat}
    (hk : k < 5) :
    ∀ n, n ≤ 5 → (storeFG m f g F G n).readAt (f.add (BitVec.ofNat 64 (8 * k))) 64 =
      if k < n then F[k]! else m.readAt (f.add (BitVec.ofNat 64 (8 * k))) 64
  | 0, _ => by simp [storeFG]
  | n + 1, hn => by
    simp only [storeFG]
    rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by exact hfg.symm))]
    by_cases h : k = n
    · subst h
      rw [MemoryState.readAt_storeAt_self (room_storeFG (room_limb hf ho hk))]
      simp
    · rw [MemoryState.readAt_storeAt_disjoint (limb_disjoint ho (by omega) hk (Ne.symm h)),
        readAt_storeFG_f hfg hf ho hk n (by omega)]
      by_cases h' : k < n
      · simp [h', show k < n + 1 by omega]
      · simp [h', show ¬k < n + 1 by omega]

/-- Limb `k` of `g` after `storeFG`: stored if `k < n`, else as before. -/
public theorem readAt_storeFG_g {m : MemoryState} {f g : Pointer} {F G : Vector (BitVec 64) 5}
    (hfg : f.id ≠ g.id) (hg : Room m g 320) (ho : ¬g.offset.uaddOverflow 40#64) {k : Nat}
    (hk : k < 5) :
    ∀ n, n ≤ 5 → (storeFG m f g F G n).readAt (g.add (BitVec.ofNat 64 (8 * k))) 64 =
      if k < n then G[k]! else m.readAt (g.add (BitVec.ofNat 64 (8 * k))) 64
  | 0, _ => by simp [storeFG]
  | n + 1, hn => by
    simp only [storeFG]
    by_cases h : k = n
    · subst h
      rw [MemoryState.readAt_storeAt_self (Room.storeAt (room_storeFG (room_limb hg ho hk)))]
      simp
    · rw [MemoryState.readAt_storeAt_disjoint (limb_disjoint ho (by omega) hk (Ne.symm h)),
        MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by exact hfg)),
        readAt_storeFG_g hfg hg ho hk n (by omega)]
      by_cases h' : k < n
      · simp [h', show k < n + 1 by omega]
      · simp [h', show ¬k < n + 1 by omega]

/-- `f`'s limbs after `storeFG` of `F` on the low `n`, `F` agreeing with them above. -/
public theorem limbsAt_storeFG_f {m : MemoryState} {f g : Pointer} {F G : Vector (BitVec 64) 5}
    (hfg : f.id ≠ g.id) (hf : Room m f 320) (ho : ¬f.offset.uaddOverflow 40#64) {n : Nat}
    (hn : n ≤ 5) (hF : ∀ k (hk : k < 5), n ≤ k → F[k] = (limbsAt m f)[k]) :
    limbsAt (storeFG m f g F G n) f = F := by
  apply Vector.ext
  intro k hk
  simp only [limbsAt, Vector.getElem_ofFn]
  rw [readAt_storeFG_f hfg hf ho hk n hn]
  split
  · simp [hk]
  · have := hF k hk (by omega)
    simp only [limbsAt, Vector.getElem_ofFn] at this
    exact this.symm

/-- `g`'s limbs after `storeFG` of `G` on the low `n`, `G` agreeing with them above. -/
public theorem limbsAt_storeFG_g {m : MemoryState} {f g : Pointer} {F G : Vector (BitVec 64) 5}
    (hfg : f.id ≠ g.id) (hg : Room m g 320) (ho : ¬g.offset.uaddOverflow 40#64) {n : Nat}
    (hn : n ≤ 5) (hG : ∀ k (hk : k < 5), n ≤ k → G[k] = (limbsAt m g)[k]) :
    limbsAt (storeFG m f g F G n) g = G := by
  apply Vector.ext
  intro k hk
  simp only [limbsAt, Vector.getElem_ofFn]
  rw [readAt_storeFG_g hfg hg ho hk n hn]
  split
  · simp [hk]
  · have := hG k hk (by omega)
    simp only [limbsAt, Vector.getElem_ofFn] at this
    exact this.symm

/-- Limb `k` as bits of the whole array. -/
public theorem extract_limb {m : MemoryState} {p : Pointer} (h : InBounds m p 320)
    (ho : ¬p.offset.uaddOverflow 40#64) {k : Nat} (hk : k < 5) :
    (m.readAt p 320).extractLsb' (64 * k) 64 = (limbsAt m p)[k] := by
  simp only [limbsAt, Vector.getElem_ofFn]
  rw [MemoryState.readAt_add_of_readAt h (noov_of_le ho (by simp; omega)) (by simp; omega) rfl]
  congr 1
  simp
  omega

/-- Four adjacent words that fit make 256 bits that fit. -/
public theorem fits_256 {m : MemoryState} {p : Pointer} (ho : p.offset = 0) (h0 : Fits m p 64)
    (h8 : Fits m (p.add 8#64) 64) (h16 : Fits m (p.add 16#64) 64)
    (h24 : Fits m (p.add 24#64) 64) : Fits m p 256 := by
  have hov : ∀ off : BitVec 64, ¬p.offset.uaddOverflow off := by
    intro off; simp [BitVec.uaddOverflow, ho, off.isLt]
  have a := Fits.append (hov 8#64) (by decide) rfl h0 h8
  have b := Fits.append (hov 16#64) (by decide) rfl a h16
  exact Fits.append (hov 24#64) (by decide) rfl b h24

/-- The limbs of `packF`. -/
public theorem packF_extract (F : Vector (BitVec 64) 5) :
    (packF F).extractLsb' 0 64 = F[0] ∧ (packF F).extractLsb' 64 64 = F[1] ∧
      (packF F).extractLsb' 128 64 = F[2] ∧ (packF F).extractLsb' 192 64 = F[3] ∧
        (packF F).extractLsb' 256 64 = F[4] := by
  simp only [packF]
  generalize F[0] = a, F[1] = b, F[2] = c, F[3] = d, F[4] = e
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

private theorem eq_packF (X : BitVec 320) :
    X = X.extractLsb' 256 64 ++ X.extractLsb' 192 64 ++ X.extractLsb' 128 64 ++
      X.extractLsb' 64 64 ++ X.extractLsb' 0 64 := by
  bv_decide

/-- The limbs at `p` of a known 320-bit value. -/
public theorem limbsAt_of_readAt {m : MemoryState} {p : Pointer} {F : Vector (BitVec 64) 5}
    (h : m.readAt p 320 = packF F) (hb : InBounds m p 320) (ho : ¬p.offset.uaddOverflow 40#64) :
    limbsAt m p = F := by
  have e := packF_extract F
  rw [← h] at e
  apply Vector.ext
  intro k hk
  rw [← extract_limb hb ho hk]
  obtain rfl | rfl | rfl | rfl | rfl : k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 := by omega
  · exact e.1
  · exact e.2.1
  · exact e.2.2.1
  · exact e.2.2.2.1
  · exact e.2.2.2.2

/-- The 320 bits at `p`, from its limbs. -/
public theorem readAt_of_limbsAt {m : MemoryState} {p : Pointer} {F : Vector (BitVec 64) 5}
    (h : limbsAt m p = F) (hb : InBounds m p 320) (ho : ¬p.offset.uaddOverflow 40#64) :
    m.readAt p 320 = packF F := by
  subst h
  have e0 := extract_limb hb ho (k := 0) (by omega)
  have e1 := extract_limb hb ho (k := 1) (by omega)
  have e2 := extract_limb hb ho (k := 2) (by omega)
  have e3 := extract_limb hb ho (k := 3) (by omega)
  have e4 := extract_limb hb ho (k := 4) (by omega)
  simp only [Nat.mul_zero, Nat.reduceMul] at e0 e1 e2 e3 e4
  rw [packF, ← e0, ← e1, ← e2, ← e3, ← e4]
  exact eq_packF _

/-- 320 bits at `p` from its low 256 and the 64 at `p + 32`. -/
public theorem readAt_320 {m : MemoryState} {p : Pointer} {A : BitVec 256} {B : BitVec 64}
    (hb : InBounds m p 320) (ho : ¬p.offset.uaddOverflow 40#64) (hA : m.readAt p 256 = A)
    (hB : m.readAt (p.add 32#64) 64 = B) : m.readAt p 320 = B ++ A := by
  have h1 := MemoryState.readAt_of_readAt_le (w := 256) (by omega) (rfl : m.readAt p 320 = _)
  have h2 := MemoryState.readAt_add_of_readAt hb (noov_of_le ho (by decide)) (by decide)
    (rfl : m.readAt p 320 = _) (off := 32#64) (w := 64)
  rw [hA] at h1
  rw [hB] at h2
  generalize m.readAt p 320 = X at h1 h2 ⊢
  simp only [BitVec.toNat_ofNat] at h2
  subst h1 h2
  bv_decide

/-- The limbs at `p` from its low 256 bits and the word at `p + 32`. -/
public theorem limbsAt_of_256 {m : MemoryState} {p : Pointer} (hb : InBounds m p 320)
    (ho : ¬p.offset.uaddOverflow 40#64) {X : BitVec 256} {e : BitVec 64}
    (hA : m.readAt p 256 = X) (hB : m.readAt (p.add 32#64) 64 = e) :
    limbsAt m p = #v[X.extractLsb' 0 64, X.extractLsb' 64 64, X.extractLsb' 128 64,
      X.extractLsb' 192 64, e] := by
  have hb' : InBounds m p 256 := hb.mono (by omega)
  apply Vector.ext
  intro k hk
  simp only [limbsAt, Vector.getElem_ofFn]
  obtain rfl | rfl | rfl | rfl | rfl : k = 0 ∨ k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 := by omega
  · simpa using MemoryState.readAt_add_of_readAt hb' (noov_of_le ho (by decide)) (by decide) hA
      (off := 0#64) (w := 64)
  · simpa using MemoryState.readAt_add_of_readAt hb' (noov_of_le ho (by decide)) (by decide) hA
      (off := 8#64) (w := 64)
  · simpa using MemoryState.readAt_add_of_readAt hb' (noov_of_le ho (by decide)) (by decide) hA
      (off := 16#64) (w := 64)
  · simpa using MemoryState.readAt_add_of_readAt hb' (noov_of_le ho (by decide)) (by decide) hA
      (off := 24#64) (w := 64)
  · simpa using hB

/-- The four 64-bit lanes of a packed 256-bit value. -/
public theorem extract_packLanes4 (v : Vector (BitVec 64) 4) :
    (BitVec.packLanes v).extractLsb' 0 64 = v[0] ∧ (BitVec.packLanes v).extractLsb' 64 64 = v[1] ∧
      (BitVec.packLanes v).extractLsb' 128 64 = v[2] ∧
        (BitVec.packLanes v).extractLsb' 192 64 = v[3] :=
  ⟨BitVec.extractLsb'_packLanes v 0 (by omega), BitVec.extractLsb'_packLanes v 1 (by omega),
    BitVec.extractLsb'_packLanes v 2 (by omega), BitVec.extractLsb'_packLanes v 3 (by omega)⟩

/-- A lifetime start leaves the limbs at `p`. -/
public theorem limbsAt_lifetimeStart {m : MemoryState} {p q : Pointer} :
    limbsAt (m.lifetimeStart q) p = limbsAt m p := by
  simp [limbsAt, MemoryState.readAt_lifetimeStart]

/-- A lifetime end leaves the limbs at `p`. -/
public theorem limbsAt_lifetimeEnd {m : MemoryState} {p q : Pointer} :
    limbsAt (m.lifetimeEnd q) p = limbsAt m p := by
  simp [limbsAt, MemoryState.readAt_lifetimeEnd]

/-- `storeFG` keeps room, both ways. -/
public theorem room_storeFG_iff {m : MemoryState} {f g p : Pointer} {F G : Vector (BitVec 64) 5}
    {w n : Nat} : Room (storeFG m f g F G n) p w ↔ Room m p w := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [storeFG, Room.storeAt_iff, ih]

/-- A store into another block leaves the limbs at `p`. -/
public theorem limbsAt_storeAt {m : MemoryState} {p q : Pointer} {w : Nat} {x : BitVec w}
    (h : q.id ≠ p.id) : limbsAt (m.storeAt q x) p = limbsAt m p := by
  apply Vector.ext
  intro k hk
  simp only [limbsAt, Vector.getElem_ofFn]
  exact MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (q := p.add _) h) x

/-- A store into another block, at an offset, leaves the limbs at `p`. -/
public theorem limbsAt_storeAt_add {m : MemoryState} {p q : Pointer} {off : BitVec 64} {w : Nat}
    {x : BitVec w} (h : q.id ≠ p.id) : limbsAt (m.storeAt (q.add off) x) p = limbsAt m p :=
  limbsAt_storeAt h

/-- A product of two `long`s, as `int128`s: within `±2^126`. -/
public theorem mul_toInt_bound (a b : BitVec 64) :
    -(2 ^ 126 : Int) ≤ a.toInt * b.toInt ∧ a.toInt * b.toInt ≤ 2 ^ 126 := by
  have ha := a.toInt_lt
  have ha' := a.le_toInt
  have hb := b.toInt_lt
  have hb' := b.le_toInt
  simp only [Nat.add_one_sub_one] at *
  have h1 : a.toInt.natAbs ≤ 2 ^ 63 := by omega
  have h2 : b.toInt.natAbs ≤ 2 ^ 63 := by omega
  have h3 : (a.toInt * b.toInt).natAbs ≤ 2 ^ 126 := by
    rw [Int.natAbs_mul]
    calc a.toInt.natAbs * b.toInt.natAbs ≤ 2 ^ 63 * 2 ^ 63 := Nat.mul_le_mul h1 h2
      _ = 2 ^ 126 := by rw [← Nat.pow_add]
  generalize a.toInt * b.toInt = P at *
  omega

/-- `(int128)a * (int128)b` does not overflow. -/
public theorem sext_mul_noov (a b : BitVec 64) :
    ¬(a.signExtend 128).smulOverflow (b.signExtend 128) = true := by
  have := mul_toInt_bound a b
  simp only [BitVec.smulOverflow, BitVec.toInt_signExtend_of_le (show 64 ≤ 128 by omega)]
  simp
  omega

/-- An `int128` shifted right by `62`: within `±2^65`. -/
public theorem shr62_bound (c : BitVec 128) :
    -(2 ^ 65 : Int) ≤ (c.sshiftRight 62).toInt ∧ (c.sshiftRight 62).toInt ≤ 2 ^ 65 := by
  rw [BitVec.toInt_sshiftRight, Int.shiftRight_eq_div_pow]
  have h1 := c.toInt_lt
  have h2 := c.le_toInt
  simp only [Nat.add_one_sub_one] at *
  constructor <;> omega

/-- A carry plus a product of two `long`s does not overflow an `int128`. -/
public theorem add_noov (a b : BitVec 64) (c : BitVec 128) :
    ¬(a.signExtend 128 * b.signExtend 128).saddOverflow (c.sshiftRight 62) = true := by
  have hm := mul_toInt_bound a b
  have hc := shr62_bound c
  have := BitVec.toInt_mul_of_not_smulOverflow (sext_mul_noov a b)
  simp only [BitVec.toInt_signExtend_of_le (show 64 ≤ 128 by omega)] at this
  rw [BitVec.toInt_sshiftRight] at hc
  simp only [BitVec.saddOverflow, this, BitVec.toInt_sshiftRight, Bool.or_eq_true,
    decide_eq_true_eq, not_or]
  omega

end MLIR.Firedancer.Lane.Jacobi
