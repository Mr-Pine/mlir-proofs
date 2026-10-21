module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.R52x5.Common.Frame
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Common.Dsmb
public import Firedancer.Crc.Verify.fd_r52x5_quad_ge_dbl
public import Firedancer.Crc.Verify.fd_r52x5_quad_ge_add_table
public import Firedancer.Crc.Verify.fd_r52x5_quad_neg
public import Firedancer.Crc.Verify.wl_permute
public import Firedancer.Crc.Verify.fd_r52x5_odd_table
public import Firedancer.Crc.Verify.fd_r52x5_wnaf
public import Firedancer.Crc.Verify.fd_r52x5_base_table_init
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_double_scalar_mul_base
import Std.Tactic.BVDecide
import Std.Data.ExtHashMap.Lemmas
import Firedancer.Crc.Verify.QuadRuns

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

namespace fd_r52x5_double_scalar_mul_base

/-! ### Frame: slots `3 … 37` (the loop's temporaries) in bounds and writable -/

def Frame (B : GlobalState) (m : MemoryState) : Prop :=
  ∀ j, 3 ≤ j → j < 38 → InBounds m (B.slot j) 256 ∧ Writable m (B.slot j)

theorem Frame.of {B : GlobalState} {m m' : MemoryState}
    (hb : ∀ p w, InBounds m p w → InBounds m' p w)
    (hw : ∀ p, Writable m p → Writable m' p) (h : Frame B m) : Frame B m' :=
  fun j h3 hj => ⟨hb _ _ (h j h3 hj).1, hw _ (h j h3 hj).2⟩

@[local mlir_transport]
theorem Frame.storeAt {B : GlobalState} {m : MemoryState} {x : BitVec w} (h : Frame B m) :
    Frame B (m.storeAt p x) :=
  h.of (fun _ _ => InBounds.storeAt) fun _ => Writable.storeAt

@[local mlir_transport]
theorem Frame.storeTmp5 {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.storeTmp5 t0 t1 t2 t3 t4 Q) :=
  h.of (fun _ _ => InBounds.storeTmp5) fun _ => Writable.storeTmp5

@[local mlir_transport]
theorem Frame.lifetimeStart {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.lifetimeStart p) :=
  h.of (fun _ _ => InBounds.lifetimeStart) fun _ => Writable.lifetimeStart

@[local mlir_transport]
theorem Frame.lifetimeEnd {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.lifetimeEnd p) :=
  h.of (fun _ _ => InBounds.lifetimeEnd) fun _ => Writable.lifetimeEnd

@[local mlir_transport]
theorem Frame.callTmp5 {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.callTmp5 t0 t1 t2 t3 t4 Q) :=
  h.of (fun _ _ => InBounds.callTmp5) fun _ => Writable.callTmp5

theorem readWv_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n).readWv p = m.readWv p := by
  simp only [MemoryState.readWv, readAt_eraseFrom_of_lt h]

/-- The state at each point of the loop: well-formed, the frame in bounds, below the frame
(`ta`, `dk`, `ds` and the globals) still `M`, and `c` blocks past the frame. -/
structure Inv (B : GlobalState) (M : MemoryState) (c : Nat) (S : GlobalState) : Prop where
  wf : S.WF
  frame : Frame B S.mem
  erase : S.mem.eraseFrom (B.alloc.nextFreeBlock + 3) = M
  alloc : S.alloc.nextFreeBlock = B.alloc.nextFreeBlock + 38 + c

theorem ne_slot {B : GlobalState} {p : Pointer} (h : p.id.id < B.alloc.nextFreeBlock + 3)
    (hj : 3 ≤ j := by decide) : p.id ≠ (B.slot j).id := fun he => by
  have := congrArg BlockId.id he
  simp at this
  omega

theorem Inv.readAt {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hp : p.id.id < B.alloc.nextFreeBlock + 3) : S.mem.readAt p w = M.readAt p w := by
  rw [← h.erase, readAt_eraseFrom_of_lt hp]

theorem Inv.readQuad5 {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hp : p.id.id < B.alloc.nextFreeBlock + 3) : S.mem.readQuad5 p = M.readQuad5 p := by
  rw [← h.erase, readQuad5_eraseFrom_of_lt hp]

theorem Inv.fits {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hf : Fits M p w) : Fits S.mem p w :=
  fits_of_eraseFrom (h.erase ▸ hf)

theorem Inv.quad5Fit {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hf : M.Quad5Fit p) : S.mem.Quad5Fit p :=
  quad5Fit_of_eraseFrom (h.erase ▸ hf)

theorem eraseFrom_storeAt_slot_add {B : GlobalState} {m : MemoryState} {x : BitVec w}
    {o : BitVec 64} (hj : 3 ≤ j) :
    (m.storeAt ((B.slot j).add o) x).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_storeAt_of_le (by simp [Pointer.add]; omega)

theorem eraseFrom_lifetimeStart_slot {B : GlobalState} {m : MemoryState} (hj : 3 ≤ j) :
    (m.lifetimeStart (B.slot j)).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_lifetimeStart_of_le (by simp; omega)

theorem eraseFrom_lifetimeEnd_slot {B : GlobalState} {m : MemoryState} (hj : 3 ≤ j) :
    (m.lifetimeEnd (B.slot j)).eraseFrom (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_lifetimeEnd_of_le (by simp; omega)

theorem eraseFrom_callTmp5_slot {B : GlobalState} {m : MemoryState} {Q : Quad5} (h0 : 3 ≤ j0)
    (h1 : 3 ≤ j1) (h2 : 3 ≤ j2) (h3 : 3 ≤ j3) (h4 : 3 ≤ j4) :
    (m.callTmp5 (B.slot j0) (B.slot j1) (B.slot j2) (B.slot j3) (B.slot j4) Q).eraseFrom
        (B.alloc.nextFreeBlock + 3) =
      m.eraseFrom (B.alloc.nextFreeBlock + 3) :=
  MemoryState.eraseFrom_callTmp5_of_le (by simp; omega) (by simp; omega) (by simp; omega)
    (by simp; omega) (by simp; omega)

/-! ### Specification of one iteration -/

/-- The table index `(d - 1) / 2` of a positive digit `d`, as the code computes it. -/
@[expose] public def idxP (y : BitVec 16) : Nat := ((y.signExtend 32 + 4294967295#32).setWidth 64 >>> 1).toNat

/-- The table index `(-d - 1) / 2` of a negative digit `d`, as the code computes it. -/
@[expose] public def idxN (y : BitVec 16) : Nat := (((y.signExtend 32).setWidth 64 ^^^ 4294967295#64) >>> 1).toNat

/-- A table entry negated as the code does: lanes `0 … 2` of `wl_permute( ., 1, 0, 2, 3 )`, lane
`3` from `fd_r52x5_quad_neg` of it. -/
@[expose] public def negEntry (T : Quad5) : Quad5 :=
  Quad5.laneIf 1 1 1 0 (Quad5.permute 1 0 2 3 T)
    (fd_r52x5_quad_neg.spec (Quad5.permute 1 0 2 3 T))

/-- `R + d · T` for the digit `d` over the table `T`. -/
@[expose] public def addDigit (T : Nat → Quad5) (y : BitVec 16) (R : Quad5) : Quad5 :=
  if (0#16).slt y then fd_r52x5_quad_ge_add_table.spec R (T (idxP y))
  else if y.slt 0#16 then fd_r52x5_quad_ge_add_table.spec R (negEntry (T (idxN y)))
  else R

/-- The blocks a digit's add uses. -/
@[expose] public def digitBlocks (y : BitVec 16) : Nat :=
  if (0#16).slt y then 65 else if y.slt 0#16 then 70 else 0

theorem idxP_lt8 {y : BitVec 16} (hyl : (65520#16).slt y = true) (hyh : y.slt 16#16 = true)
    (hp : (0#16).slt y = true) :
    (y.signExtend 32).saddOverflow 4294967295#32 = false ∧
      ((y.signExtend 32 + 4294967295#32) >>> 1).msb = false ∧ idxP y < 8 := by
  have h : (y.signExtend 32).saddOverflow 4294967295#32 = false ∧
      ((y.signExtend 32 + 4294967295#32) >>> 1).msb = false ∧
      ((y.signExtend 32 + 4294967295#32).setWidth 64 >>> 1).ult 8#64 = true := by bv_decide
  rw [BitVec.ult_eq_decide, decide_eq_true_eq] at h
  exact h

theorem idxN_lt8 {y : BitVec 16} (hyl : (65520#16).slt y = true) (hyh : y.slt 16#16 = true)
    (hn : y.slt 0#16 = true) :
    ((y.signExtend 32 ^^^ 4294967295#32) >>> 1).msb = false ∧ idxN y < 8 := by
  have h : ((y.signExtend 32 ^^^ 4294967295#32) >>> 1).msb = false ∧
      (((y.signExtend 32).setWidth 64 ^^^ 4294967295#64) >>> 1).ult 8#64 = true := by bv_decide
  rw [BitVec.ult_eq_decide, decide_eq_true_eq] at h
  exact h

theorem idxP_lt128 {y : BitVec 16} (hyl : (65280#16).slt y = true) (hyh : y.slt 256#16 = true)
    (hp : (0#16).slt y = true) :
    (y.signExtend 32).saddOverflow 4294967295#32 = false ∧
      ((y.signExtend 32 + 4294967295#32) >>> 1).msb = false ∧ idxP y < 128 := by
  have h : (y.signExtend 32).saddOverflow 4294967295#32 = false ∧
      ((y.signExtend 32 + 4294967295#32) >>> 1).msb = false ∧
      ((y.signExtend 32 + 4294967295#32).setWidth 64 >>> 1).ult 128#64 = true := by bv_decide
  rw [BitVec.ult_eq_decide, decide_eq_true_eq] at h
  exact h

theorem idxN_lt128 {y : BitVec 16} (hyl : (65280#16).slt y = true) (hyh : y.slt 256#16 = true)
    (hn : y.slt 0#16 = true) :
    ((y.signExtend 32 ^^^ 4294967295#32) >>> 1).msb = false ∧ idxN y < 128 := by
  have h : ((y.signExtend 32 ^^^ 4294967295#32) >>> 1).msb = false ∧
      (((y.signExtend 32).setWidth 64 ^^^ 4294967295#64) >>> 1).ult 128#64 = true := by bv_decide
  rw [BitVec.ult_eq_decide, decide_eq_true_eq] at h
  exact h

/-- The point `T k` of the table at `p`, `k < n`, in `M`. -/
@[expose] public def TableAt (M : MemoryState) (p : Pointer) (n : Nat) (T : Nat → Quad5) : Prop :=
  ∀ k < n, M.Quad5Fit (p.add (BitVec.ofNat 64 (192 * k))) ∧
    M.readQuad5 (p.add (BitVec.ofNat 64 (192 * k))) = T k

/-- The registers the loop reads: constants, the base table and the frame's slots. -/
abbrev LoopRegs (B : GlobalState) (tb : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%3227 := 1#32, %3231 := 4294967295#32, %3234 := 0#64, %3237 := 0#16, %3238 := 0#32,
    %3239 := 2#32, %3240 := 3#32, %3241 := tb, %3242 := 18446744073709551615#64, %3243 := B.slot 0, %3244 := B.slot 1, %3245 := B.slot 2, %3246 := B.slot 3, %3247 := B.slot 4, %3248 := B.slot 5, %3249 := B.slot 6, %3250 := B.slot 7, %3251 := B.slot 8, %3252 := B.slot 9, %3253 := B.slot 10, %3254 := B.slot 11, %3255 := B.slot 12, %3256 := B.slot 13, %3257 := B.slot 14, %3258 := B.slot 15, %3259 := B.slot 16, %3260 := B.slot 17, %3261 := B.slot 18, %3262 := B.slot 19, %3263 := B.slot 20, %3264 := B.slot 21, %3265 := B.slot 22, %3266 := B.slot 23, %3267 := B.slot 24, %3268 := B.slot 25, %3269 := B.slot 26, %3270 := B.slot 27, %3271 := B.slot 28, %3272 := B.slot 29, %3273 := B.slot 30, %3274 := B.slot 31, %3275 := B.slot 32, %3276 := B.slot 33, %3277 := B.slot 34, %3278 := B.slot 35, %3279 := B.slot 36, %3280 := B.slot 37]

abbrev hdr (E : ⟪Γ⟫) (i : Nat) (P : Quad5) : ⟪Γ⟫ :=
  E[%3315 := .value (BitVec.ofNat 64 i), %3316 := Ty.wrap P.P0, %3317 := Ty.wrap P.P1,
    %3318 := Ty.wrap P.P2, %3319 := Ty.wrap P.P3, %3320 := Ty.wrap P.P4]

theorem slot_lt {B : GlobalState} (hk : k < 3) (o : BitVec 64) :
    ((B.slot k).add o).id.id < B.alloc.nextFreeBlock + 3 := by
  simp; omega

/-- `B` three blocks on: its slot `j` is `B`'s slot `3 + j`, so the frame is its `SlotFrame`. -/
def shift (B : GlobalState) : GlobalState :=
  { alloc := ⟨B.alloc.nextFreeBlock + 3⟩, mem := B.mem }

theorem shift_slot {B : GlobalState} : (shift B).slot j = B.slot (3 + j) :=
  GlobalState.mk_slot

set_option maxHeartbeats 4000000 in
/-- `^bb8` at `i` with `P` in the registers: `dbl P`, then `dk[i]`'s add from the odd table in
slot `0`; on to `^bb12`. -/
theorem head_block (r kp a s tb : Pointer) (B : GlobalState) (M : MemoryState) (c i : Nat)
    (TA : Nat → Quad5) (y : BitVec 16) (P : Quad5) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value kp) (.value a) (.value s)).get)
    (hR : LoopRegs B tb E)
    (hRi : E ⊨ [%3315 := BitVec.ofNat 64 i, %3316 := P.P0, %3317 := P.P1, %3318 := P.P2,
      %3319 := P.P3, %3320 := P.P4]) (hI : Inv B M c S) (hi : i < 256)
    (hf : Fits M ((B.slot 1).add (BitVec.ofNat 64 (2 * i))) 16)
    (hy : M.readAt ((B.slot 1).add (BitVec.ofNat 64 (2 * i))) 16 = y)
    (hyl : (65520#16).slt y = true) (hyh : y.slt 16#16 = true)
    (hTA : TableAt M (B.slot 0) 8 TA)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value kp) (.value a) (.value s)).get →
          LoopRegs B tb E' →
          (E' ⊨ [%3315 := BitVec.ofNat 64 i,
            %3382 := (addDigit TA y (fd_r52x5_quad_ge_dbl.spec P)).P4,
            %3383 := (addDigit TA y (fd_r52x5_quad_ge_dbl.spec P)).P3,
            %3384 := (addDigit TA y (fd_r52x5_quad_ge_dbl.spec P)).P2,
            %3385 := (addDigit TA y (fd_r52x5_quad_ge_dbl.spec P)).P1,
            %3386 := (addDigit TA y (fd_r52x5_quad_ge_dbl.spec P)).P0]) →
          Inv B M (c + 80 + digitBlocks y) S' →
          (fd_r52x5_double_scalar_mul_base.runFrom E' 12 S' >>= g) = K) :
    (fd_r52x5_double_scalar_mul_base.runFrom E 8 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  have hSF : SlotFrame (shift B) 35 S.mem := fun j hj => by
    rw [shift_slot]; exact hF (3 + j) (by omega) (by omega)
  block_init
  step_pattern' using runBodyFrom_leafRun1A (hf := fd_r52x5_quad_ge_dbl.call_eq) (B := shift B)
    (k0 := 0) (k1 := 1) (k2 := 2) (k3 := 3) (k4 := 4) with D
  simp only [shift_slot] at hS
  have hI' : Inv B M (c + 80) S :=
    ⟨hwf, hF, by rw [hS]; simp (disch := decide) only [eraseFrom_callTmp5_slot]; exact herase,
      by rw [hS]; simp only [halloc]; omega⟩
  have hfS : Fits S.mem ((B.slot 1).add (BitVec.ofNat 64 (2 * i))) 16 := hI'.fits hf
  have hyS : S.mem.readAt ((B.slot 1).add (BitVec.ofNat 64 (2 * i))) 16 = y :=
    (hI'.readAt (slot_lt (by decide) _)).trans hy
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load
  step_pure
  step_pure
  finish_block
  case isTrue =>
    obtain ⟨hsadd, hmsb, hk⟩ := idxP_lt8 hyl hyh hbr
    obtain ⟨k, hk'⟩ : ∃ k, idxP y = k := ⟨_, rfl⟩
    rw [hk'] at hk
    obtain ⟨hAf, hAr⟩ := hTA k hk
    have hAfS := hI'.quad5Fit hAf
    have hP0 := congrArg Quad5.P0 hAr
    have hP1 := congrArg Quad5.P1 hAr
    have hP2 := congrArg Quad5.P2 hAr
    have hP3 := congrArg Quad5.P3 hAr
    have hP4 := congrArg Quad5.P4 hAr
    simp only [MemoryState.readQuad5, Pointer.add_add] at hP0 hP1 hP2 hP3 hP4
    obtain ⟨_, e0, e1, e2, e3, e4⟩ := hAfS
    simp only [Pointer.add_add] at e1 e2 e3 e4
    have hix0 : ((y.signExtend 32 + 4294967295#32).setWidth 64 >>> 1).toNat = k := hk'
    clear hI' hTA
    block_init
    step_pure [hsadd]
    step_pure
    step_pure [hmsb] with transparent ix
    rw [← hix] at hix0
    step_pure [hix0, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega,
      show ¬ 2 ^ 63 ≤ 192 * k by omega]
    step_load [ofFn_extractVecElem_readAt] with Y0
    step_pure
    step_load [ofFn_extractVecElem_readAt] with Y1
    step_pure
    step_load [ofFn_extractVecElem_readAt] with Y2
    step_pure
    step_load [ofFn_extractVecElem_readAt] with Y3
    step_pure
    step_load [ofFn_extractVecElem_readAt] with Y4
    have hY0' : Y0 = (TA k).P0 :=
      hY0.trans (by rw [← hP0, ← herase, readWv_eraseFrom_of_lt (by simp)])
    have hY1' : Y1 = (TA k).P1 :=
      hY1.trans (by rw [← hP1, ← herase, readWv_eraseFrom_of_lt (by simp)])
    have hY2' : Y2 = (TA k).P2 :=
      hY2.trans (by rw [← hP2, ← herase, readWv_eraseFrom_of_lt (by simp)])
    have hY3' : Y3 = (TA k).P3 :=
      hY3.trans (by rw [← hP3, ← herase, readWv_eraseFrom_of_lt (by simp)])
    have hY4' : Y4 = (TA k).P4 :=
      hY4.trans (by rw [← hP4, ← herase, readWv_eraseFrom_of_lt (by simp)])
    subst hY0' hY1' hY2' hY3' hY4'
    clear hP0 hP1 hP2 hP3 hP4 e0 e1 e2 e3 e4 hfS hyS
    step_pattern' using runBodyFrom_leafRun2A (hf := fd_r52x5_quad_ge_add_table.call_eq)
      (B := shift B) (k0 := 5) (k1 := 6) (k2 := 7) (k3 := 8) (k4 := 9) with A
    simp only [shift_slot] at hS
    finish_block
    subst hA hD
    refine hK E S hArgs (by lemma_reads) ?_ ⟨hwf, hF, ?_, ?_⟩
    · simp only [addDigit, hbr, ite_true, hk']
      lemma_reads
    · rw [hS]; simp (disch := decide) only [eraseFrom_callTmp5_slot]; exact herase
    · rw [hS]; simp only [halloc, digitBlocks, hbr, ite_true]; omega
  case isFalse =>
    block_init
    step_pure
    finish_block
    case isTrue =>
      obtain ⟨hmsb, hk⟩ := idxN_lt8 hyl hyh hbr
      obtain ⟨k, hk'⟩ : ∃ k, idxN y = k := ⟨_, rfl⟩
      rw [hk'] at hk
      obtain ⟨hAf, hAr⟩ := hTA k hk
      have hAfS := hI'.quad5Fit hAf
      have hP0 := congrArg Quad5.P0 hAr
      have hP1 := congrArg Quad5.P1 hAr
      have hP2 := congrArg Quad5.P2 hAr
      have hP3 := congrArg Quad5.P3 hAr
      have hP4 := congrArg Quad5.P4 hAr
      simp only [MemoryState.readQuad5, Pointer.add_add] at hP0 hP1 hP2 hP3 hP4
      obtain ⟨_, e0, e1, e2, e3, e4⟩ := hAfS
      simp only [Pointer.add_add] at e1 e2 e3 e4
      have hix0 : (((y.signExtend 32).setWidth 64 ^^^ 4294967295#64) >>> 1).toNat = k := hk'
      clear hI' hTA
      block_init
      step_pure
      step_pure
      step_pure [hmsb] with transparent ix
      rw [← hix] at hix0
      step_pure [hix0, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega,
        show ¬ 2 ^ 63 ≤ 192 * k by omega]
      step_load [ofFn_extractVecElem_readAt] with Y0
      step_pure
      step_load [ofFn_extractVecElem_readAt] with Y1
      step_pure
      step_load [ofFn_extractVecElem_readAt] with Y2
      step_pure
      step_load [ofFn_extractVecElem_readAt] with Y3
      step_pure
      step_load [ofFn_extractVecElem_readAt] with Y4
      have hY0' : Y0 = (TA k).P0 :=
        hY0.trans (by rw [← hP0, ← herase, readWv_eraseFrom_of_lt (by simp)])
      have hY1' : Y1 = (TA k).P1 :=
        hY1.trans (by rw [← hP1, ← herase, readWv_eraseFrom_of_lt (by simp)])
      have hY2' : Y2 = (TA k).P2 :=
        hY2.trans (by rw [← hP2, ← herase, readWv_eraseFrom_of_lt (by simp)])
      have hY3' : Y3 = (TA k).P3 :=
        hY3.trans (by rw [← hP3, ← herase, readWv_eraseFrom_of_lt (by simp)])
      have hY4' : Y4 = (TA k).P4 :=
        hY4.trans (by rw [← hP4, ← herase, readWv_eraseFrom_of_lt (by simp)])
      subst hY0' hY1' hY2' hY3' hY4'
      clear hP0 hP1 hP2 hP3 hP4 e0 e1 e2 e3 e4 hfS hyS
      step_pattern' using runBodyFrom_permuteRun 1 0 2 3 with T
      step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_neg.call_eq) (B := shift B)
        (k0 := 10) (k1 := 11) (k2 := 12) (k3 := 13) (k4 := 14) with N
      simp only [shift_slot] at hS
      step_pattern' using runBodyFrom_blendRun 1 1 1 0 with L
      step_pattern' using runBodyFrom_leafRun2A (hf := fd_r52x5_quad_ge_add_table.call_eq)
        (B := shift B) (k0 := 15) (k1 := 16) (k2 := 17) (k3 := 18) (k4 := 19) with A
      simp only [shift_slot] at hS
      finish_block
      subst hA hL hN hT hD
      have hnp : (0#16).slt y = false := by
        rw [BitVec.slt_eq_decide] at hbr ⊢; simp at hbr ⊢; omega
      refine hK E S hArgs (by lemma_reads) ?_ ⟨hwf, hF, ?_, ?_⟩
      · simp only [addDigit, negEntry, hbr, hnp, ite_true, ite_false, Bool.false_eq_true, hk']
        lemma_reads
      · rw [hS]; simp (disch := decide) only [eraseFrom_callTmp5_slot]; exact herase
      · rw [hS]; simp only [halloc, digitBlocks, hbr, hnp, ite_true, ite_false, Bool.false_eq_true]
        omega
    case isFalse =>
      rename_i hbr0
      have hnp : (0#16).slt y = false := Bool.eq_false_iff.mpr hbr0
      have hnn : y.slt 0#16 = false := Bool.eq_false_iff.mpr hbr
      subst hD
      refine hK E S hArgs (by lemma_reads) ?_ ?_
      · simp only [addDigit, hnp, hnn, Bool.false_eq_true, ite_false]
        lemma_reads
      · simpa only [digitBlocks, hnp, hnn, Bool.false_eq_true, ite_false, Nat.add_zero] using hI'

set_option maxHeartbeats 4000000 in
/-- `^bb12` at `i` with `R` in the registers (`P4 … P0` order): `ds[i]`'s add from the base
table `tb`; on to `^bb16`. -/
theorem digit2_block (r kp a s tb : Pointer) (B : GlobalState) (M : MemoryState) (c i : Nat)
    (TB : Nat → Quad5) (y : BitVec 16) (R : Quad5) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value kp) (.value a) (.value s)).get)
    (hR : LoopRegs B tb E)
    (hRi : E ⊨ [%3315 := BitVec.ofNat 64 i, %3382 := R.P4, %3383 := R.P3, %3384 := R.P2,
      %3385 := R.P1, %3386 := R.P0])
    (hI : Inv B M c S) (hi : i < 256) (htb : tb.id.id < B.alloc.nextFreeBlock + 3)
    (htbo : tb.offset = 0)
    (hf : Fits M ((B.slot 2).add (BitVec.ofNat 64 (2 * i))) 16)
    (hy : M.readAt ((B.slot 2).add (BitVec.ofNat 64 (2 * i))) 16 = y)
    (hyl : (65280#16).slt y = true) (hyh : y.slt 256#16 = true)
    (hTB : TableAt M tb 128 TB)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (args (.value r) (.value kp) (.value a) (.value s)).get →
          LoopRegs B tb E' →
          (E' ⊨ [%3315 := BitVec.ofNat 64 i,
            %3443 := (addDigit TB y R).P4, %3444 := (addDigit TB y R).P3,
            %3445 := (addDigit TB y R).P2, %3446 := (addDigit TB y R).P1,
            %3447 := (addDigit TB y R).P0]) →
          Inv B M (c + digitBlocks y) S' →
          (fd_r52x5_double_scalar_mul_base.runFrom E' 16 S' >>= g) = K) :
    (fd_r52x5_double_scalar_mul_base.runFrom E 12 S >>= g) = K := by
  have hfS : Fits S.mem ((B.slot 2).add (BitVec.ofNat 64 (2 * i))) 16 := hI.fits hf
  have hyS : S.mem.readAt ((B.slot 2).add (BitVec.ofNat 64 (2 * i))) 16 = y :=
    (hI.readAt (slot_lt (by decide) _)).trans hy
  have htb' : ∀ o : BitVec 64, (tb.add o).id.id < B.alloc.nextFreeBlock + 3 := fun o => by
    simpa using htb
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  have hSF : SlotFrame (shift B) 35 S.mem := fun j hj => by
    rw [shift_slot]; exact hF (3 + j) (by omega) (by omega)
  block_init
  step_pure [Nat.mod_eq_of_lt (show i < 2 ^ 64 by omega), show 2 * i < 2 ^ 64 by omega,
    show i * 2 = 2 * i by omega]
  step_load
  step_pure
  step_pure
  finish_block
  case isTrue =>
    subst hS
    obtain ⟨hsadd, hmsb, hk⟩ := idxP_lt128 hyl hyh hbr
    obtain ⟨k, hk'⟩ : ∃ k, idxP y = k := ⟨_, rfl⟩
    rw [hk'] at hk
    obtain ⟨hAf, hAr⟩ := hTB k hk
    have hAfS : S.mem.Quad5Fit (tb.add (BitVec.ofNat 64 (192 * k))) :=
      quad5Fit_of_eraseFrom (herase ▸ hAf)
    have hP0 := congrArg Quad5.P0 hAr
    have hP1 := congrArg Quad5.P1 hAr
    have hP2 := congrArg Quad5.P2 hAr
    have hP3 := congrArg Quad5.P3 hAr
    have hP4 := congrArg Quad5.P4 hAr
    simp only [MemoryState.readQuad5, Pointer.add_add] at hP0 hP1 hP2 hP3 hP4
    obtain ⟨_, e0, e1, e2, e3, e4⟩ := hAfS
    simp only [Pointer.add_add] at e1 e2 e3 e4
    have hix0 : ((y.signExtend 32 + 4294967295#32).setWidth 64 >>> 1).toNat = k := hk'
    clear hTB
    block_init
    step_pure [hsadd]
    step_pure
    step_pure [hmsb] with transparent ix
    rw [← hix] at hix0
    step_pure [hix0, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega,
      show ¬ 2 ^ 63 ≤ 192 * k by omega, htbo]
    step_load [ofFn_extractVecElem_readAt] with Y0
    step_pure
    step_load [ofFn_extractVecElem_readAt] with Y1
    step_pure
    step_load [ofFn_extractVecElem_readAt] with Y2
    step_pure
    step_load [ofFn_extractVecElem_readAt] with Y3
    step_pure
    step_load [ofFn_extractVecElem_readAt] with Y4
    have hY0' : Y0 = (TB k).P0 :=
      hY0.trans (by rw [← hP0, ← herase, readWv_eraseFrom_of_lt (htb' _)])
    have hY1' : Y1 = (TB k).P1 :=
      hY1.trans (by rw [← hP1, ← herase, readWv_eraseFrom_of_lt (htb' _)])
    have hY2' : Y2 = (TB k).P2 :=
      hY2.trans (by rw [← hP2, ← herase, readWv_eraseFrom_of_lt (htb' _)])
    have hY3' : Y3 = (TB k).P3 :=
      hY3.trans (by rw [← hP3, ← herase, readWv_eraseFrom_of_lt (htb' _)])
    have hY4' : Y4 = (TB k).P4 :=
      hY4.trans (by rw [← hP4, ← herase, readWv_eraseFrom_of_lt (htb' _)])
    subst hY0' hY1' hY2' hY3' hY4'
    clear hP0 hP1 hP2 hP3 hP4 e0 e1 e2 e3 e4 hfS hyS
    step_pattern' using runBodyFrom_leafRun2A (hf := fd_r52x5_quad_ge_add_table.call_eq)
      (B := shift B) (k0 := 20) (k1 := 21) (k2 := 22) (k3 := 23) (k4 := 24) with A
    simp only [shift_slot] at hS
    finish_block
    subst hA
    refine hK E S hArgs (by lemma_reads) ?_ ⟨hwf, hF, ?_, ?_⟩
    · simp only [addDigit, hbr, ite_true, hk']
      lemma_reads
    · rw [hS]; simp (disch := decide) only [eraseFrom_callTmp5_slot]; exact herase
    · rw [hS]; simp only [halloc, digitBlocks, hbr, ite_true]; omega
  case isFalse =>
    subst hS
    block_init
    step_pure
    finish_block
    case isTrue =>
      obtain ⟨hmsb, hk⟩ := idxN_lt128 hyl hyh hbr
      obtain ⟨k, hk'⟩ : ∃ k, idxN y = k := ⟨_, rfl⟩
      rw [hk'] at hk
      obtain ⟨hAf, hAr⟩ := hTB k hk
      have hAfS : S.mem.Quad5Fit (tb.add (BitVec.ofNat 64 (192 * k))) :=
        quad5Fit_of_eraseFrom (herase ▸ hAf)
      have hP0 := congrArg Quad5.P0 hAr
      have hP1 := congrArg Quad5.P1 hAr
      have hP2 := congrArg Quad5.P2 hAr
      have hP3 := congrArg Quad5.P3 hAr
      have hP4 := congrArg Quad5.P4 hAr
      simp only [MemoryState.readQuad5, Pointer.add_add] at hP0 hP1 hP2 hP3 hP4
      obtain ⟨_, e0, e1, e2, e3, e4⟩ := hAfS
      simp only [Pointer.add_add] at e1 e2 e3 e4
      have hix0 : (((y.signExtend 32).setWidth 64 ^^^ 4294967295#64) >>> 1).toNat = k := hk'
      clear hTB
      block_init
      step_pure
      step_pure
      step_pure [hmsb] with transparent ix
      rw [← hix] at hix0
      step_pure [hix0, Nat.mul_comm k 192, show 192 * k < 2 ^ 64 by omega,
        show ¬ 2 ^ 63 ≤ 192 * k by omega, htbo]
      step_load [ofFn_extractVecElem_readAt] with Y0
      step_pure
      step_load [ofFn_extractVecElem_readAt] with Y1
      step_pure
      step_load [ofFn_extractVecElem_readAt] with Y2
      step_pure
      step_load [ofFn_extractVecElem_readAt] with Y3
      step_pure
      step_load [ofFn_extractVecElem_readAt] with Y4
      have hY0' : Y0 = (TB k).P0 :=
        hY0.trans (by rw [← hP0, ← herase, readWv_eraseFrom_of_lt (htb' _)])
      have hY1' : Y1 = (TB k).P1 :=
        hY1.trans (by rw [← hP1, ← herase, readWv_eraseFrom_of_lt (htb' _)])
      have hY2' : Y2 = (TB k).P2 :=
        hY2.trans (by rw [← hP2, ← herase, readWv_eraseFrom_of_lt (htb' _)])
      have hY3' : Y3 = (TB k).P3 :=
        hY3.trans (by rw [← hP3, ← herase, readWv_eraseFrom_of_lt (htb' _)])
      have hY4' : Y4 = (TB k).P4 :=
        hY4.trans (by rw [← hP4, ← herase, readWv_eraseFrom_of_lt (htb' _)])
      subst hY0' hY1' hY2' hY3' hY4'
      clear hP0 hP1 hP2 hP3 hP4 e0 e1 e2 e3 e4 hfS hyS
      step_pattern' using runBodyFrom_permuteRun 1 0 2 3 with T
      step_pattern' using runBodyFrom_leafRun1 (hf := fd_r52x5_quad_neg.call_eq) (B := shift B)
        (k0 := 25) (k1 := 26) (k2 := 27) (k3 := 28) (k4 := 29) with N
      simp only [shift_slot] at hS
      step_pattern' using runBodyFrom_blendRun 1 1 1 0 with L
      step_pattern' using runBodyFrom_leafRun2A (hf := fd_r52x5_quad_ge_add_table.call_eq)
        (B := shift B) (k0 := 30) (k1 := 31) (k2 := 32) (k3 := 33) (k4 := 34) with A
      simp only [shift_slot] at hS
      finish_block
      subst hA hL hN hT
      have hnp : (0#16).slt y = false := by
        rw [BitVec.slt_eq_decide] at hbr ⊢; simp at hbr ⊢; omega
      refine hK E S hArgs (by lemma_reads) ?_ ⟨hwf, hF, ?_, ?_⟩
      · simp only [addDigit, negEntry, hbr, hnp, ite_true, ite_false, Bool.false_eq_true, hk']
        lemma_reads
      · rw [hS]; simp (disch := decide) only [eraseFrom_callTmp5_slot]; exact herase
      · rw [hS]; simp only [halloc, digitBlocks, hbr, hnp, ite_true, ite_false, Bool.false_eq_true]
        omega
    case isFalse =>
      rename_i hbr0
      have hnp : (0#16).slt y = false := Bool.eq_false_iff.mpr hbr0
      have hnn : y.slt 0#16 = false := Bool.eq_false_iff.mpr hbr
      refine hK E S hArgs (by lemma_reads) ?_ ?_
      · simp only [addDigit, hnp, hnn, Bool.false_eq_true, ite_false]
        lemma_reads
      · simpa only [digitBlocks, hnp, hnn, Bool.false_eq_true, ite_false, Nat.add_zero] using
          (⟨hwf, hF, herase, halloc⟩ : Inv B M c S)

/-- `^bb16` at `i` with `R` in the registers: exit to `^bb7` at `i = 0`, else back to `^bb8` at
`i - 1`. -/
theorem tail_block (r kp a s tb : Pointer) (B : GlobalState) (i : Nat) (hi : i < 256) (R : Quad5)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value kp) (.value a) (.value s)).get)
    (hR : LoopRegs B tb E)
    (hRi : E ⊨ [%3315 := BitVec.ofNat 64 i, %3443 := R.P4, %3444 := R.P3, %3445 := R.P2,
      %3446 := R.P1, %3447 := R.P0])
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫),
          E'.args = (args (.value r) (.value kp) (.value a) (.value s)).get →
            LoopRegs B tb E' →
            (E' ⊨ [%3306 := R.P4, %3307 := R.P3, %3308 := R.P2, %3309 := R.P1, %3310 := R.P0]) →
            (fd_r52x5_double_scalar_mul_base.runFrom E' 7 S >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫),
            E'.args = (args (.value r) (.value kp) (.value a) (.value s)).get →
              LoopRegs B tb E' →
              (E' ⊨ [%3315 := BitVec.ofNat 64 j, %3316 := R.P0, %3317 := R.P1, %3318 := R.P2,
                %3319 := R.P3, %3320 := R.P4]) →
              (fd_r52x5_double_scalar_mul_base.runFrom E' 8 S >>= g) = K) :
    (fd_r52x5_double_scalar_mul_base.runFrom E 16 S >>= g) = K := by
  rcases Nat.eq_zero_or_pos i with hi0 | hi0
  · subst hi0
    block_init
    step_pure
    step_pure
    finish_block
    · exact hexit rfl E hArgs (by lemma_reads) (by lemma_reads)
  · block_init
    step_pure [saddOverflow_neg_one64 hi0 (by omega), add_neg_one64 hi0 (by omega)]
    step_pure
    finish_block
    · exact hback (i - 1) (by omega) E hArgs (by lemma_reads) (by lemma_reads)
    · exact absurd (slt_ofNat64 hi0 (by omega)) hbr

/-- The digits of the two wNAF tables, as read from the frozen frame `M`: `dk` in slot 1 with
`|d| < 16`, `ds` in slot 2 with `|d| < 256`. -/
def Digits (B : GlobalState) (M : MemoryState) (n : Nat) (DK DS : Nat → BitVec 16) : Prop :=
  ∀ i < n,
    (Fits M ((B.slot 1).add (BitVec.ofNat 64 (2 * i))) 16 ∧
      M.readAt ((B.slot 1).add (BitVec.ofNat 64 (2 * i))) 16 = DK i ∧
      (65520#16).slt (DK i) = true ∧ (DK i).slt 16#16 = true) ∧
    (Fits M ((B.slot 2).add (BitVec.ofNat 64 (2 * i))) 16 ∧
      M.readAt ((B.slot 2).add (BitVec.ofNat 64 (2 * i))) 16 = DS i ∧
      (65280#16).slt (DS i) = true ∧ (DS i).slt 256#16 = true)

/-- One iteration at `i`: double, add `dk[i]` from `TA`, add `ds[i]` from `TB`. -/
@[expose] public def iter (TA TB : Nat → Quad5) (DK DS : Nat → BitVec 16) (i : Nat) (P : Quad5) : Quad5 :=
  addDigit TB (DS i) (addDigit TA (DK i) (fd_r52x5_quad_ge_dbl.spec P))

/-- The ladder from `i` down to `0`. -/
@[expose] public def ladder (TA TB : Nat → Quad5) (DK DS : Nat → BitVec 16) : Nat → Quad5 → Quad5
  | 0, P => iter TA TB DK DS 0 P
  | i + 1, P => ladder TA TB DK DS i (iter TA TB DK DS (i + 1) P)

/-- Blocks of one iteration at `i`. -/
@[expose] public def iterBlocks (DK DS : Nat → BitVec 16) (i : Nat) : Nat :=
  80 + digitBlocks (DK i) + digitBlocks (DS i)

/-- Blocks of the ladder from `i` down to `0`. -/
@[expose] public def ladderBlocks (DK DS : Nat → BitVec 16) : Nat → Nat
  | 0 => iterBlocks DK DS 0
  | i + 1 => iterBlocks DK DS (i + 1) + ladderBlocks DK DS i

/-- An iteration of the main loop from `^bb8` at `i`. -/
theorem main_iter (r kp a s tb : Pointer) (B : GlobalState) (M : MemoryState) (c i : Nat)
    (TA TB : Nat → Quad5) (DK DS : Nat → BitVec 16) (P : Quad5) (S : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value kp) (.value a) (.value s)).get)
    (hR : LoopRegs B tb E)
    (hRi : E ⊨ [%3315 := BitVec.ofNat 64 i, %3316 := P.P0, %3317 := P.P1, %3318 := P.P2,
      %3319 := P.P3, %3320 := P.P4])
    (hI : Inv B M c S) (n : Nat) (hn : n ≤ 256) (hi : i < n)
    (htb : tb.id.id < B.alloc.nextFreeBlock + 3)
    (htbo : tb.offset = 0) (hD : Digits B M n DK DS)
    (hTA : TableAt M (B.slot 0) 8 TA) (hTB : TableAt M tb 128 TB)
    (hexit :
      i = 0 →
        ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value kp) (.value a) (.value s)).get →
            LoopRegs B tb E' →
            (E' ⊨ [%3306 := (iter TA TB DK DS i P).P4, %3307 := (iter TA TB DK DS i P).P3,
              %3308 := (iter TA TB DK DS i P).P2, %3309 := (iter TA TB DK DS i P).P1,
              %3310 := (iter TA TB DK DS i P).P0]) →
            Inv B M (c + iterBlocks DK DS i) S' →
            (fd_r52x5_double_scalar_mul_base.runFrom E' 7 S' >>= g) = K)
    (hback :
      ∀ j,
        i = j + 1 →
          ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
            E'.args = (args (.value r) (.value kp) (.value a) (.value s)).get →
              LoopRegs B tb E' →
              (E' ⊨ [%3315 := BitVec.ofNat 64 j, %3316 := (iter TA TB DK DS i P).P0,
                %3317 := (iter TA TB DK DS i P).P1, %3318 := (iter TA TB DK DS i P).P2,
                %3319 := (iter TA TB DK DS i P).P3, %3320 := (iter TA TB DK DS i P).P4]) →
              Inv B M (c + iterBlocks DK DS i) S' →
              (fd_r52x5_double_scalar_mul_base.runFrom E' 8 S' >>= g) = K) :
    (fd_r52x5_double_scalar_mul_base.runFrom E 8 S >>= g) = K := by
  obtain ⟨⟨hf1, hy1, hl1, hh1⟩, ⟨hf2, hy2, hl2, hh2⟩⟩ := hD i hi
  have hi' : i < 256 := by omega
  refine
    head_block r kp a s tb B M c i TA (DK i) P S E g K hArgs hR hRi hI hi' hf1 hy1 hl1 hh1 hTA
      fun E₁ S₁ h₁ hR₁ hRi₁ hI₁ => ?_
  refine
    digit2_block r kp a s tb B M _ i TB (DS i) _ S₁ E₁ g K h₁ hR₁ hRi₁ hI₁ hi' htb htbo hf2 hy2 hl2
      hh2 hTB fun E₂ S₂ h₂ hR₂ hRi₂ hI₂ => ?_
  refine
    tail_block r kp a s tb B i hi' _ S₂ E₂ g K h₂ hR₂ hRi₂ (fun h0 E₃ h₃ hR₃ hRi₃ => ?_)
      (fun j hj E₃ h₃ hR₃ hRi₃ => ?_)
  · exact hexit h0 E₃ S₂ h₃ hR₃ hRi₃ (by simpa only [iterBlocks, Nat.add_assoc] using hI₂)
  · exact hback j hj E₃ S₂ h₃ hR₃ hRi₃ (by simpa only [iterBlocks, Nat.add_assoc] using hI₂)

/-- The main loop from `^bb8` at `i` with `P`: `^bb7` with the ladder. -/
theorem main_loop (r kp a s tb : Pointer) (B : GlobalState) (M : MemoryState)
    (TA TB : Nat → Quad5) (DK DS : Nat → BitVec 16)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (n : Nat) (hn : n ≤ 256)
    (htb : tb.id.id < B.alloc.nextFreeBlock + 3) (htbo : tb.offset = 0) (hD : Digits B M n DK DS)
    (hTA : TableAt M (B.slot 0) 8 TA) (hTB : TableAt M tb 128 TB) :
    ∀ i (_hi : i < n) (c : Nat) (P : Quad5) (S : GlobalState) (E : ⟪Γ⟫),
      E.args = (args (.value r) (.value kp) (.value a) (.value s)).get →
        LoopRegs B tb E →
        (E ⊨ [%3315 := BitVec.ofNat 64 i, %3316 := P.P0, %3317 := P.P1, %3318 := P.P2,
          %3319 := P.P3, %3320 := P.P4]) →
        Inv B M c S →
        (∀ (E' : ⟪Γ⟫) (S' : GlobalState),
          E'.args = (args (.value r) (.value kp) (.value a) (.value s)).get →
            LoopRegs B tb E' →
            (E' ⊨ [%3306 := (ladder TA TB DK DS i P).P4, %3307 := (ladder TA TB DK DS i P).P3,
              %3308 := (ladder TA TB DK DS i P).P2, %3309 := (ladder TA TB DK DS i P).P1,
              %3310 := (ladder TA TB DK DS i P).P0]) →
            Inv B M (c + ladderBlocks DK DS i) S' →
            (fd_r52x5_double_scalar_mul_base.runFrom E' 7 S' >>= g) = K) →
        (fd_r52x5_double_scalar_mul_base.runFrom E 8 S >>= g) = K := by
  intro i
  induction i with
  | zero =>
    intro hi c P S E hArgs hR hRi hI hK
    exact
      main_iter r kp a s tb B M c 0 TA TB DK DS P S E g K hArgs hR hRi hI n hn hi htb htbo hD hTA hTB
        (fun _ E' S' h₁ hR' hRi' hI' => hK E' S' h₁ hR' hRi' hI')
        (fun j hj => absurd hj (by omega))
  | succ j ih =>
    intro hi c P S E hArgs hR hRi hI hK
    refine
      main_iter r kp a s tb B M c (j + 1) TA TB DK DS P S E g K hArgs hR hRi hI n hn hi htb htbo hD hTA
        hTB (fun h => absurd h (by omega)) fun j' hj E' S' h₁ hR' hRi' hI' => ?_
    obtain rfl : j = j' := by omega
    refine ih (by omega) _ _ S' E' h₁ hR' hRi' hI' fun E'' S'' h₂ hR₂ hRi₂ hI₂ => ?_
    refine hK E'' S'' h₂ hR₂ hRi₂ ?_
    simpa only [ladderBlocks, Nat.add_assoc, Nat.add_comm (iterBlocks DK DS (j + 1))] using hI₂

/-! ### `fd_r52x5_wnaf.stores` through the memory predicates -/

theorem storesF_ind {P : MemoryState → Prop}
    (hs : ∀ (m : MemoryState) (q : Pointer) (x : BitVec 16), P m → P (m.storeAt q x)) :
    ∀ f (m : MemoryState) n (w : BitVec 256), P m → P (fd_r52x5_wnaf.storesF B d f m n w)
  | 0, _, _, _, h => h
  | f + 1, m, n, w, h => by
    simp only [fd_r52x5_wnaf.storesF]
    split
    · exact hs _ _ _ h
    · exact storesF_ind hs f _ _ _ (hs _ _ _ h)

theorem stores_ind {P : MemoryState → Prop}
    (hs : ∀ (m : MemoryState) (q : Pointer) (x : BitVec 16), P m → P (m.storeAt q x))
    (m : MemoryState) (x : BitVec 256) (h : P m) : P (fd_r52x5_wnaf.stores B d m x) := by
  unfold fd_r52x5_wnaf.stores
  split
  · exact h
  · exact storesF_ind hs 254 m 0 x h

@[local mlir_mem, local mlir_transport]
theorem Fits.stores {m : MemoryState} (h : Fits m p w) :
    Fits (fd_r52x5_wnaf.stores B d m x) p w :=
  stores_ind (P := fun m => Fits m p w) (fun _ _ _ h => h.storeAt) m x h

@[local mlir_mem, local mlir_transport]
theorem Room.stores {m : MemoryState} (h : Room m p w) :
    Room (fd_r52x5_wnaf.stores B d m x) p w :=
  stores_ind (P := fun m => Room m p w) (fun _ _ _ h => h.storeAt) m x h

@[local mlir_mem, local mlir_transport]
theorem InBounds.stores {m : MemoryState} (h : InBounds m p w) :
    InBounds (fd_r52x5_wnaf.stores B d m x) p w :=
  stores_ind (P := fun m => InBounds m p w) (fun _ _ _ h => h.storeAt) m x h

@[local mlir_mem, local mlir_transport]
theorem Writable.stores {m : MemoryState} (h : Writable m p) :
    Writable (fd_r52x5_wnaf.stores B d m x) p :=
  stores_ind (P := fun m => Writable m p) (fun _ _ _ h => h.storeAt) m x h

@[local mlir_transport]
theorem Frame.storesFrom {B' : GlobalState} {m : MemoryState} (h : Frame B' m) (c j : Nat) :
    Frame B' (fd_r52x5_odd_table.storesFrom m tab A j c) :=
  h.of (fun _ _ h => InBounds.storesFrom h c j) fun _ h => Writable.storesFrom' h c j

@[local mlir_mem, local mlir_transport]
theorem MemoryState.Quad5Fit.stores {m : MemoryState} (h : m.Quad5Fit p) :
    (fd_r52x5_wnaf.stores B d m x).Quad5Fit p :=
  stores_ind (P := fun m => m.Quad5Fit p) (fun _ _ _ h => h.storeAt) m x h

@[local mlir_mem, local mlir_transport]
theorem MemoryState.Quad5Room.stores {m : MemoryState} (h : m.Quad5Room p) :
    (fd_r52x5_wnaf.stores B d m x).Quad5Room p :=
  stores_ind (P := fun m => m.Quad5Room p) (fun _ _ _ h => h.storeAt) m x h

@[local mlir_transport]
theorem oddTabRoom.stores {m : MemoryState} (h : oddTabRoom m p n) :
    oddTabRoom (fd_r52x5_wnaf.stores B d m x) p n := by
  unfold oddTabRoom at *
  exact Room.stores h

@[local mlir_transport]
theorem Frame.stores {m : MemoryState} (h : Frame C m) :
    Frame C (fd_r52x5_wnaf.stores B d m x) :=
  stores_ind (P := fun m => Frame C m) (fun _ _ _ h => h.storeAt) m x h

@[local mlir_transport]
theorem GlobalState.WF.stores_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, fd_r52x5_wnaf.stores B d m x⟩ : GlobalState).WF :=
  stores_ind (P := fun m => (⟨a, m⟩ : GlobalState).WF) (fun _ _ _ h => h.storeAt_mk) m x h

/-- The state `fd_r52x5_wnaf.call_eq` leaves: `WF`. -/
@[local mlir_transport]
theorem GlobalState.WF.stores_add {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, fd_r52x5_wnaf.stores B d s.mem x⟩ : GlobalState).WF :=
  GlobalState.WF.stores_mk h.add_blocks

theorem storesF_ind' {P : MemoryState → Prop}
    (hs : ∀ (m : MemoryState) (o : BitVec 64) (x : BitVec 16), P m → P (m.storeAt (d.add o) x)) :
    ∀ f (m : MemoryState) n (w : BitVec 256), P m → P (fd_r52x5_wnaf.storesF B d f m n w)
  | 0, _, _, _, h => h
  | f + 1, m, n, w, h => by
    simp only [fd_r52x5_wnaf.storesF]
    split
    · exact hs _ _ _ h
    · exact storesF_ind' hs f _ _ _ (hs _ _ _ h)

theorem stores_ind' {P : MemoryState → Prop}
    (hs : ∀ (m : MemoryState) (o : BitVec 64) (x : BitVec 16), P m → P (m.storeAt (d.add o) x))
    (m : MemoryState) (x : BitVec 256) (h : P m) : P (fd_r52x5_wnaf.stores B d m x) := by
  unfold fd_r52x5_wnaf.stores
  split
  · exact h
  · exact storesF_ind' hs 254 m 0 x h

@[local mlir_read]
theorem MemoryState.readAt_stores_of_id_ne {m : MemoryState} (hne : d.id ≠ q.id) :
    (fd_r52x5_wnaf.stores B d m x).readAt q w = m.readAt q w := by
  refine stores_ind' (P := fun m' => m'.readAt q w = m.readAt q w) ?_ m x rfl
  intro m' o x' h
  rw [← h, MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using hne))]

@[local mlir_read]
theorem MemoryState.readQuad5_stores_of_id_ne {m : MemoryState} (hne : d.id ≠ q.id) :
    (fd_r52x5_wnaf.stores B d m x).readQuad5 q = m.readQuad5 q := by
  refine stores_ind' (P := fun m' => m'.readQuad5 q = m.readQuad5 q) ?_ m x rfl
  intro m' o x' h
  rw [← h, MemoryState.readQuad5_storeAt_of_id_ne (by simpa using hne)]

theorem eraseFrom_storesF :
    ∀ f (m : MemoryState) n (w : BitVec 256),
      (fd_r52x5_wnaf.storesF B d f m n w).eraseFrom k = fd_r52x5_wnaf.storesF B d f (m.eraseFrom k) n w
  | 0, _, _, _ => rfl
  | f + 1, m, n, w => by
    simp only [fd_r52x5_wnaf.storesF]
    split
    · exact MemoryState.eraseFrom_storeAt
    · rw [eraseFrom_storesF f _ _ _, MemoryState.eraseFrom_storeAt]

theorem MemoryState.eraseFrom_stores {m : MemoryState} :
    (fd_r52x5_wnaf.stores B d m x).eraseFrom k = fd_r52x5_wnaf.stores B d (m.eraseFrom k) x := by
  unfold fd_r52x5_wnaf.stores
  split
  · rfl
  · exact eraseFrom_storesF 254 m 0 x


/-! ### Arithmetic of the entry blocks -/

theorem digit4_bounds (w : BitVec 256) :
    (65520#16).slt ((fd_r52x5_wnaf.digit 4 w).setWidth 16) = true ∧
      ((fd_r52x5_wnaf.digit 4 w).setWidth 16).slt 16#16 = true := by
  simp only [fd_r52x5_wnaf.digit, fd_r52x5_wnaf.lo, fd_r52x5_wnaf.sel, Nat.reduceAdd]
  bv_decide

theorem digit8_bounds (w : BitVec 256) :
    (65280#16).slt ((fd_r52x5_wnaf.digit 8 w).setWidth 16) = true ∧
      ((fd_r52x5_wnaf.digit 8 w).setWidth 16).slt 256#16 = true := by
  simp only [fd_r52x5_wnaf.digit, fd_r52x5_wnaf.lo, fd_r52x5_wnaf.sel, Nat.reduceAdd]
  bv_decide

theorem smax32 {a b : Nat} (ha : a < 2 ^ 31) (hb : b < 2 ^ 31) :
    (if (BitVec.ofNat 32 b).slt (BitVec.ofNat 32 a) then BitVec.ofNat 32 a else BitVec.ofNat 32 b) =
      BitVec.ofNat 32 (max a b) := by
  have h1 : (BitVec.ofNat 32 a).toInt = a := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 32 b).toInt = b := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp only [BitVec.slt, h1, h2, decide_eq_true_eq]
  split <;> congr 1 <;> omega

theorem slt32 {a b : Nat} (ha : a < 2 ^ 31) (hb : b < 2 ^ 31) :
    (BitVec.ofNat 32 b).slt (BitVec.ofNat 32 a) = decide (b < a) := by
  have h1 : (BitVec.ofNat 32 a).toInt = a := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 32 b).toInt = b := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp only [BitVec.slt, h1, h2]
  simp

theorem shl1_64 {a : Nat} (h : a < 2 ^ 62) :
    (BitVec.ofNat 64 a <<< 1).sshiftRight 1 = BitVec.ofNat 64 a ∧
      BitVec.ofNat 64 a <<< 1 >>> 1 = BitVec.ofNat 64 a ∧
      BitVec.ofNat 64 a <<< 1 = BitVec.ofNat 64 (2 * a) := by
  have : BitVec.ofNat 64 a <<< 1 = BitVec.ofNat 64 (2 * a) := by
    apply BitVec.eq_of_toNat_eq
    simp [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (show 2 * a < 2 ^ 64 by omega)]
    omega
  refine ⟨?_, ?_, this⟩
  · rw [this, BitVec.sshiftRight_eq_of_msb_false]
    · apply BitVec.eq_of_toNat_eq
      simp [BitVec.toNat_ushiftRight, Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega),
        Nat.mod_eq_of_lt (show 2 * a < 2 ^ 64 by omega)]
      omega
    · rw [BitVec.msb_eq_decide, BitVec.toNat_ofNat]; simp; omega
  · rw [this]
    apply BitVec.eq_of_toNat_eq
    simp [BitVec.toNat_ushiftRight, Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (show 2 * a < 2 ^ 64 by omega)]
    omega

theorem shl_mul2 {a : Nat} (h : a < 2 ^ 62) : BitVec.ofNat 64 a <<< 1 = BitVec.ofNat 64 (2 * a) :=
  (shl1_64 h).2.2

theorem sshr_mul2 {a : Nat} (h : a < 2 ^ 62) :
    (BitVec.ofNat 64 (2 * a)).sshiftRight 1 = BitVec.ofNat 64 a := by
  rw [← shl_mul2 h]; exact (shl1_64 h).1

theorem ushr_mul2 {a : Nat} (h : a < 2 ^ 62) : BitVec.ofNat 64 (2 * a) >>> 1 = BitVec.ofNat 64 a := by
  rw [← shl_mul2 h]; exact (shl1_64 h).2.1

/-- `n + (k xor -1)`, zero-extended: `n - k - 1` (with `k < n`). -/
theorem memset_z {n k : Nat} (hn : n < 2 ^ 31) (hk : k < n) :
    (BitVec.ofNat 32 n + (BitVec.ofNat 32 k ^^^ 4294967295#32)).setWidth 64 =
      BitVec.ofNat 64 (n - k - 1) := by
  have hx : BitVec.ofNat 32 k ^^^ 4294967295#32 = ~~~ BitVec.ofNat 32 k := by
    rw [show (4294967295#32) = BitVec.allOnes 32 from rfl, BitVec.xor_allOnes]
  apply BitVec.eq_of_toNat_eq
  simp only [hx, BitVec.toNat_setWidth, BitVec.toNat_add, BitVec.toNat_not, BitVec.toNat_ofNat,
    Nat.reducePow]
  rw [Nat.mod_eq_of_lt (show n < 2 ^ 32 by omega), Nat.mod_eq_of_lt (show k < 2 ^ 32 by omega),
    show n + (2 ^ 32 - 1 - k) = (n - k - 1) + 2 ^ 32 by omega, Nat.add_mod_right,
    Nat.mod_eq_of_lt (show n - k - 1 < 2 ^ 32 by omega), Nat.mod_eq_of_lt (by omega)]

theorem add_two64 {a : Nat} (h : a + 2 < 2 ^ 63) :
    (BitVec.ofNat 64 a).uaddOverflow 2#64 = false ∧ (BitVec.ofNat 64 a).saddOverflow 2#64 = false ∧
      BitVec.ofNat 64 a + 2#64 = BitVec.ofNat 64 (a + 2) := by
  have h1 : (BitVec.ofNat 64 a).toInt = a := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 64 a).toNat = a := by simp; omega
  refine ⟨?_, ?_, ?_⟩
  · simp only [BitVec.uaddOverflow, h2]; simp; omega
  · simp only [BitVec.saddOverflow, h1]; simp; omega
  · apply BitVec.eq_of_toNat_eq
    simp [h2, Nat.mod_eq_of_lt (show a + 2 < 2 ^ 64 by omega)]

theorem sub32 {a b : Nat} (hb : b ≤ a) (ha : a < 2 ^ 32) :
    BitVec.ofNat 32 a - BitVec.ofNat 32 b = BitVec.ofNat 32 (a - b) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub, BitVec.toNat_ofNat, BitVec.toNat_ofNat, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt (show b < 2 ^ 32 by omega),
    Nat.mod_eq_of_lt (show a - b < 2 ^ 32 by omega)]
  rw [show 2 ^ 32 - b + a = (a - b) + 2 ^ 32 by omega, Nat.add_mod_right]
  exact Nat.mod_eq_of_lt (by omega)

theorem setWidth64_ofNat32 {a : Nat} (h : a < 2 ^ 32) :
    (BitVec.ofNat 32 a).setWidth 64 = BitVec.ofNat 64 a := by
  apply BitVec.eq_of_toNat_eq
  simp [Nat.mod_eq_of_lt h, Nat.mod_eq_of_lt (show a < 2 ^ 64 by omega)]

theorem msb32_false {a : Nat} (h : a < 2 ^ 31) : (BitVec.ofNat 32 a).msb = false := by
  rw [BitVec.msb_eq_decide, BitVec.toNat_ofNat]; simp; omega


/-! ### Memory helpers of the entry and exit blocks -/

/-- `d[i]`'s `Room`, inside `d`'s 512 bytes. -/
theorem lane_room {m : MemoryState} {d : Pointer} (hd : Room m d (8 * 512))
    (hdo : ¬d.offset.uaddOverflow 512#64) (hi : i < 256) :
    Room m (d.add (BitVec.ofNat 64 (2 * i))) 16 := by
  have h := hdo
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.reducePow,
    Nat.reduceMod] at h
  refine Room.add_of_le ?_ ?_ hd
  · simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
  · simp only [BitVec.toNat_ofNat]; omega

theorem replicate_zero8 (n : Nat) : (0#8).replicate n = 0#(8 * n) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i
  simp [BitVec.getLsbD_replicate]

/-- A memset of `2 * c` zero bytes at `d[k]` zeroes `d[i]`, `k ≤ i < k + c`. -/
theorem memset_read_zero {m : MemoryState} {d : Pointer} (hd : Room m d (8 * 512))
    (hdo : ¬d.offset.uaddOverflow 512#64) (hk : k + c ≤ 256) (hi : k ≤ i ∧ i < k + c) :
    Fits (m.storeAt (d.add (BitVec.ofNat 64 (2 * k))) ((0#8).replicate (2 * c)))
        (d.add (BitVec.ofNat 64 (2 * i))) 16 ∧
      (m.storeAt (d.add (BitVec.ofNat 64 (2 * k))) ((0#8).replicate (2 * c))).readAt
        (d.add (BitVec.ofNat 64 (2 * i))) 16 = 0#16 := by
  have h := hdo
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.reducePow,
    Nat.reduceMod] at h
  have hR : Room m (d.add (BitVec.ofNat 64 (2 * k))) (8 * (2 * c)) := by
    refine Room.add_of_le ?_ ?_ hd
    · simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
    · simp only [BitVec.toNat_ofNat]; omega
  have hov : ¬(d.add (BitVec.ofNat 64 (2 * k))).offset.uaddOverflow (BitVec.ofNat 64 (2 * (i - k))) := by
    simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat,
      decide_eq_true_eq, Nat.reducePow]
    rw [Nat.mod_eq_of_lt (show 2 * k < 2 ^ 64 by omega), Nat.mod_eq_of_lt (show 2 * (i - k) < 2 ^ 64 by omega),
      Nat.mod_eq_of_lt (by omega)]
    omega
  have he : d.add (BitVec.ofNat 64 (2 * i)) =
      (d.add (BitVec.ofNat 64 (2 * k))).add (BitVec.ofNat 64 (2 * (i - k))) := by
    rw [Pointer.add_add, ← BitVec.ofNat_add]; congr 2; omega
  have hw : (BitVec.ofNat 64 (2 * (i - k))).toNat * 8 + 16 ≤ 8 * (2 * c) := by
    simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega
  rw [he]
  refine ⟨Fits.storeAt_add_self hR hov hw, ?_⟩
  rw [MemoryState.readAt_storeAt_add hR hov hw, replicate_zero8, BitVec.extractLsb'_zero]

/-- A memset at `d[k]` of `2 * c` bytes keeps `d[i]`, `i < k`. -/
theorem memset_read_keep {m : MemoryState} {d : Pointer} {x : BitVec (8 * (2 * c))}
    (hdo : ¬d.offset.uaddOverflow 512#64) (hk : k + c ≤ 256) (hi : i < k) :
    (m.storeAt (d.add (BitVec.ofNat 64 (2 * k))) x).readAt (d.add (BitVec.ofNat 64 (2 * i))) 16 =
      m.readAt (d.add (BitVec.ofNat 64 (2 * i))) 16 := by
  have h := hdo
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.reducePow,
    Nat.reduceMod] at h
  exact MemoryState.readAt_storeAt_disjoint (Range.disjoint_add (by omega) (by omega) (by omega)) _

/-- Stores of entries `j …` keep entry `k < j`: its point and its fit. -/
theorem storesFrom_keep {m : MemoryState} {tab : Pointer} (hto : tab.offset = 0) :
    ∀ c j, j + c ≤ 128 → k < j →
      (fd_r52x5_odd_table.storesFrom m tab A j c).readQuad5 (tab.add (BitVec.ofNat 64 (192 * k))) =
          m.readQuad5 (tab.add (BitVec.ofNat 64 (192 * k))) ∧
        (m.Quad5Fit (tab.add (BitVec.ofNat 64 (192 * k))) →
          (fd_r52x5_odd_table.storesFrom m tab A j c).Quad5Fit (tab.add (BitVec.ofNat 64 (192 * k))))
  | 0, _, _, _ => ⟨rfl, id⟩
  | c + 1, j, hc, hk => by
    simp only [fd_r52x5_odd_table.storesFrom]
    obtain ⟨h1, h2⟩ := storesFrom_keep (k := k) (m := m.storeQuad5 (tab.add (BitVec.ofNat 64 (192 * j)))
      (fd_r52x5_odd_table.spec A j)) hto c (j + 1) (by omega) (by omega)
    refine ⟨h1.trans ?_, fun h => h2 h.storeQuad5⟩
    exact MemoryState.readQuad5_storeQuad5_apart (by rw [hto]; simp; omega) (by rw [hto]; simp; omega)
      (by omega)

/-- Entry `k` of the stored odd table: `spec A k`, in fit. -/
public theorem storesFrom_entry {m : MemoryState} {tab : Pointer} (hto : tab.offset = 0) :
    ∀ c j, Room m tab (1536 * (j + c)) → j + c ≤ 128 → j ≤ k → k < j + c →
      (fd_r52x5_odd_table.storesFrom m tab A j c).Quad5Fit (tab.add (BitVec.ofNat 64 (192 * k))) ∧
        (fd_r52x5_odd_table.storesFrom m tab A j c).readQuad5 (tab.add (BitVec.ofNat 64 (192 * k))) =
          fd_r52x5_odd_table.spec A k
  | 0, j, _, _, h1, h2 => by omega
  | c + 1, j, hR, hc, h1, h2 => by
    have hto' : tab.offset.toNat + 192 * (j + (c + 1)) < 2 ^ 64 := by rw [hto]; simp; omega
    have hQ : m.Quad5Room (tab.add (BitVec.ofNat 64 (192 * j))) :=
      MemoryState.Quad5Room.entry hR hto' (by omega)
    simp only [fd_r52x5_odd_table.storesFrom]
    rcases Nat.eq_or_lt_of_le h1 with he | hlt
    · subst he
      obtain ⟨h1, h2⟩ := storesFrom_keep (k := j) (m := m.storeQuad5 (tab.add (BitVec.ofNat 64 (192 * j)))
        (fd_r52x5_odd_table.spec A j)) hto c (j + 1) (by omega) (by omega)
      exact ⟨h2 (MemoryState.Quad5Fit.storeQuad5_self hQ),
        h1.trans (MemoryState.readQuad5_storeQuad5_self hQ)⟩
    · exact storesFrom_entry (k := k) hto c (j + 1) (by rw [show j + 1 + c = j + (c + 1) by omega]; exact hR.storeQuad5) (by omega)
        hlt (by omega)


/-! ### Specification -/

/-- Digit `i` of the `dk` table: the wNAF digit for `i < count`, else the memset's `0`. -/
@[expose] public def DK (x : BitVec 256) (i : Nat) : BitVec 16 :=
  if i < fd_r52x5_wnaf.count 4 x then (fd_r52x5_wnaf.digit 4 (fd_r52x5_wnaf.iter 4 i x)).setWidth 16
  else 0#16

/-- Digit `i` of the `ds` table. -/
@[expose] public def DS (x : BitVec 256) (i : Nat) : BitVec 16 :=
  if i < fd_r52x5_wnaf.count 8 x then (fd_r52x5_wnaf.digit 8 (fd_r52x5_wnaf.iter 8 i x)).setWidth 16
  else 0#16

/-- The digits' count of the ladder. -/
@[expose] public def steps (x1 x2 : BitVec 256) : Nat := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2)

/-- `fd_r52x5_double_scalar_mul_base( r, k, a, s )` with the base table `TB`: `k A + s B`. -/
@[expose] public def spec (TB : Nat → Quad5) (x1 : BitVec 256) (A : Quad5) (x2 : BitVec 256) : Quad5 :=
  if steps x1 x2 = 0 then quadZero
  else ladder (fd_r52x5_odd_table.spec A) TB (DK x1) (DS x2) (steps x1 x2 - 1) quadZero

/-- The blocks the call allocates. -/
@[expose] public def blocks (x1 x2 : BitVec 256) : Nat :=
  38 + (125 + 115 * 7) + 2 +
    (if steps x1 x2 = 0 then 0 else ladderBlocks (DK x1) (DS x2) (steps x1 x2 - 1))

theorem count_le (B : Nat) (x : BitVec 256) : fd_r52x5_wnaf.count B x ≤ 254 := by
  unfold fd_r52x5_wnaf.count
  split
  · omega
  · exact fd_r52x5_wnaf.countF_le B 254 0 x

/-! ### The call -/

/-! ### Transfer into the erased prefix -/

theorem getElem?_eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n) :
    (m.eraseFrom n)[p.id]? = m[p.id]? := by
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter', h,
    decide_true]
  cases m.mem[p.id]? <;> rfl

theorem Fits.eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n)
    (hf : Fits m p w) : Fits (m.eraseFrom n) p w := by
  obtain ⟨b, hb, hl, hw, hd⟩ := hf
  exact ⟨b, (getElem?_eraseFrom_of_lt h).trans hb, hl, hw, hd⟩

theorem Room.eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n)
    (hr : Room m p w) : Room (m.eraseFrom n) p w := by
  obtain ⟨⟨b, hb, hl, hw⟩, ⟨b', hb', hw'⟩⟩ := hr
  exact ⟨⟨b, (getElem?_eraseFrom_of_lt h).trans hb, hl, hw⟩,
    ⟨b', (getElem?_eraseFrom_of_lt h).trans hb', hw'⟩⟩

theorem id_lt_of_eraseFrom_fits {m : MemoryState} {p : Pointer} (h : Fits (m.eraseFrom n) p w) :
    p.id.id < n := by
  obtain ⟨b, hb, -, -, -⟩ := h
  by_contra hc
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter',
    hc, decide_false] at hb
  cases m.mem[p.id]? <;> simp at hb

theorem inBounds_of_eraseFrom {m : MemoryState} {p : Pointer} (h : InBounds (m.eraseFrom n) p w) :
    InBounds m p w := by
  obtain ⟨b, hb, hl⟩ := h
  refine ⟨b, ?_, hl⟩
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

theorem writable_of_eraseFrom {m : MemoryState} {p : Pointer} (h : Writable (m.eraseFrom n) p) :
    Writable m p := by
  obtain ⟨b, hb, hw⟩ := h
  refine ⟨b, ?_, hw⟩
  simp only [MemoryState.eraseFrom, MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_filter'] at hb
  rw [MemoryState.getElem?_eq]
  cases hm : m.mem[p.id]? <;> simp_all

theorem Quad5Fit.eraseFrom_of_lt {m : MemoryState} {p : Pointer} (h : p.id.id < n)
    (hf : m.Quad5Fit p) : (m.eraseFrom n).Quad5Fit p := by
  have h' : ∀ o : BitVec 64, (p.add o).id.id < n := fun o => by simpa using h
  exact ⟨hf.1, Fits.eraseFrom_of_lt h hf.2.1, Fits.eraseFrom_of_lt (h' _) hf.2.2.1,
    Fits.eraseFrom_of_lt (h' _) hf.2.2.2.1, Fits.eraseFrom_of_lt (h' _) hf.2.2.2.2.1,
    Fits.eraseFrom_of_lt (h' _) hf.2.2.2.2.2⟩

theorem Inv.room {B S : GlobalState} {M : MemoryState} (h : Inv B M c S) {p : Pointer}
    (hr : Room M p w) : Room S.mem p w :=
  room_of_eraseFrom (h.erase ▸ hr)

/-! ### The exit block: store the result, end the lifetimes, return -/

set_option maxHeartbeats 2000000 in
theorem exit_block (r kp a s tb : Pointer) (B : GlobalState) (M : MemoryState) (c : Nat)
    (Q : Quad5) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value r) (.value kp) (.value a) (.value s)).get)
    (hR : LoopRegs B tb E)
    (hV : E ⊨ [%3306 := Q.P4, %3307 := Q.P3, %3308 := Q.P2, %3309 := Q.P1, %3310 := Q.P0])
    (hI : Inv B M c S) (hr : M.Quad5Room r) :
    (fd_r52x5_double_scalar_mul_base.runFrom E 7 S >>= fun p =>
      PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom B.alloc.nextFreeBlock } : GlobalState))) =
      PoisonOr.value
        (Vals.nil,
          { alloc := ⟨B.alloc.nextFreeBlock + 38 + c⟩,
            mem := (M.eraseFrom B.alloc.nextFreeBlock).storeQuad5 r Q }) := by
  have hr' : S.mem.Quad5Room r := ⟨hr.1, hI.room hr.2.1, hI.room hr.2.2.1, hI.room hr.2.2.2.1,
    hI.room hr.2.2.2.2.1, hI.room hr.2.2.2.2.2⟩
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  block_init
  step_store
  iterate 4 (step_pure; step_store)
  iterate 3 step_pure
  finish_block
  subst hS
  dsimp only
  rw [MemoryState.eraseFrom_lifetimeEnd_of_le (by simp), MemoryState.eraseFrom_lifetimeEnd_of_le (by simp),
    MemoryState.eraseFrom_lifetimeEnd_of_le (by simp), MemoryState.storeQuad5_mk,
    MemoryState.eraseFrom_storeQuad5, ← eraseFrom_eraseFrom (show B.alloc.nextFreeBlock ≤ B.alloc.nextFreeBlock + 3 by omega),
    herase]
  congr 3
  exact (show S.alloc = ⟨S.alloc.nextFreeBlock⟩ from rfl).trans (congrArg _ halloc)

/-! ### The digits `fd_r52x5_wnaf.stores` leaves -/

/-- Digit `i < count` of the table `stores` writes. -/
theorem stores_digit {m : MemoryState} {d : Pointer} (hdo : ¬d.offset.uaddOverflow 512#64)
    (hd : Room m d (8 * 512)) (hi : i < fd_r52x5_wnaf.count B x) :
    Fits (fd_r52x5_wnaf.stores B d m x) (d.add (BitVec.ofNat 64 (2 * i))) 16 ∧
      (fd_r52x5_wnaf.stores B d m x).readAt (d.add (BitVec.ofNat 64 (2 * i))) 16 =
        (fd_r52x5_wnaf.digit B (fd_r52x5_wnaf.iter B i x)).setWidth 16 := by
  unfold fd_r52x5_wnaf.count at hi
  unfold fd_r52x5_wnaf.stores
  split
  · simp_all
  · rename_i hx
    rw [ite_eq_right hx] at hi
    simpa using fd_r52x5_wnaf.storesF_digit hdo 254 m 0 x i hd (by omega) (by omega) hi

/-- `DK x i` as the table `dk` holds it after `stores`, the `ds` stores, and the tail memset to
`n`. -/
theorem dk_digits {m : MemoryState} {dk ds : Pointer} (hne : ds.id ≠ dk.id)
    (hdo : ¬dk.offset.uaddOverflow 512#64)
    (hd : Room m dk (8 * 512)) (hn : n ≤ 256) (hcn : fd_r52x5_wnaf.count 4 x ≤ n) (hi : i < n) :
    let m' := (fd_r52x5_wnaf.stores 8 ds (fd_r52x5_wnaf.stores 4 dk m x) y).storeAt
      (dk.add (BitVec.ofNat 64 (2 * fd_r52x5_wnaf.count 4 x)))
      (BitVec.replicate (2 * (n - fd_r52x5_wnaf.count 4 x)) 0#8)
    Fits m' (dk.add (BitVec.ofNat 64 (2 * i))) 16 ∧
      m'.readAt (dk.add (BitVec.ofNat 64 (2 * i))) 16 = DK x i := by
  intro m'
  unfold DK
  split
  · rename_i hlt
    obtain ⟨h1, h2⟩ := stores_digit hdo hd hlt
    exact ⟨(Fits.stores h1).storeAt, (memset_read_keep hdo (by omega) hlt).trans
      ((MemoryState.readAt_stores_of_id_ne (q := dk.add (BitVec.ofNat 64 (2 * i)))
        (by simpa using hne)).trans h2)⟩
  · rename_i hge
    exact memset_read_zero (Room.stores (Room.stores hd)) hdo (by omega) (by omega)

/-- `DK x i`, `i < count`, as the table `dk` holds it after its `stores` and the `ds` stores. -/
theorem dk_digits_plain {m : MemoryState} {dk ds : Pointer} (hne : ds.id ≠ dk.id)
    (hdo : ¬dk.offset.uaddOverflow 512#64)
    (hd : Room m dk (8 * 512)) (hi : i < fd_r52x5_wnaf.count 4 x) :
    Fits (fd_r52x5_wnaf.stores 8 ds (fd_r52x5_wnaf.stores 4 dk m x) y) (dk.add (BitVec.ofNat 64 (2 * i))) 16 ∧
      (fd_r52x5_wnaf.stores 8 ds (fd_r52x5_wnaf.stores 4 dk m x) y).readAt
        (dk.add (BitVec.ofNat 64 (2 * i))) 16 = DK x i := by
  unfold DK
  rw [ite_eq_left hi]
  obtain ⟨h1, h2⟩ := stores_digit hdo hd hi
  exact ⟨Fits.stores h1, (MemoryState.readAt_stores_of_id_ne (q := dk.add (BitVec.ofNat 64 (2 * i)))
    (by simpa using hne)).trans h2⟩

/-- `DS x i` as the table `ds` holds it after `stores` and the tail memset to `n`. -/
theorem ds_digits_memset {m : MemoryState} {ds : Pointer} (hdo : ¬ds.offset.uaddOverflow 512#64)
    (hd : Room m ds (8 * 512)) (hn : n ≤ 256) (hcn : fd_r52x5_wnaf.count 8 x ≤ n) (hi : i < n) :
    let m' := (fd_r52x5_wnaf.stores 8 ds m x).storeAt
      (ds.add (BitVec.ofNat 64 (2 * fd_r52x5_wnaf.count 8 x)))
      (BitVec.replicate (2 * (n - fd_r52x5_wnaf.count 8 x)) 0#8)
    Fits m' (ds.add (BitVec.ofNat 64 (2 * i))) 16 ∧
      m'.readAt (ds.add (BitVec.ofNat 64 (2 * i))) 16 = DS x i := by
  intro m'
  unfold DS
  split
  · rename_i hlt
    obtain ⟨h1, h2⟩ := stores_digit hdo hd hlt
    exact ⟨h1.storeAt, (memset_read_keep hdo (by omega) hlt).trans h2⟩
  · rename_i hge
    exact memset_read_zero (Room.stores hd) hdo (by omega) (by omega)

/-- `DS x i`, `i < count`, as the table `ds` holds it after `stores`. -/
theorem ds_digits {m : MemoryState} {ds : Pointer} (hdo : ¬ds.offset.uaddOverflow 512#64)
    (hd : Room m ds (8 * 512)) (hi : i < fd_r52x5_wnaf.count 8 x) :
    Fits (fd_r52x5_wnaf.stores 8 ds m x) (ds.add (BitVec.ofNat 64 (2 * i))) 16 ∧
      (fd_r52x5_wnaf.stores 8 ds m x).readAt (ds.add (BitVec.ofNat 64 (2 * i))) 16 = DS x i := by
  unfold DS
  rw [ite_eq_left hi]
  exact stores_digit hdo hd hi

theorem DK_bounds (x : BitVec 256) (i : Nat) :
    (65520#16).slt (DK x i) = true ∧ (DK x i).slt 16#16 = true := by
  unfold DK; split
  · exact digit4_bounds _
  · decide

theorem DS_bounds (x : BitVec 256) (i : Nat) :
    (65280#16).slt (DS x i) = true ∧ (DS x i).slt 256#16 = true := by
  unfold DS; split
  · exact digit8_bounds _
  · decide

/-! ### From `^bb8` at `n - 1` with the identity to the return -/

theorem from_bb8 (r kp a s tb : Pointer) (B : GlobalState) (M : MemoryState)
    (TA TB : Nat → Quad5) (DK DS : Nat → BitVec 16) (n : Nat) (hn1 : 1 ≤ n) (hn : n ≤ 256)
    (htb : tb.id.id < B.alloc.nextFreeBlock + 3) (htbo : tb.offset = 0) (hD : Digits B M n DK DS)
    (hTA : TableAt M (B.slot 0) 8 TA) (hTB : TableAt M tb 128 TB) (c : Nat) (S : GlobalState)
    (E : ⟪Γ⟫) (hArgs : E.args = (args (.value r) (.value kp) (.value a) (.value s)).get)
    (hR : LoopRegs B tb E)
    (hV : E ⊨ [%3315 := BitVec.ofNat 64 (n - 1), %3316 := quadZero.P0, %3317 := quadZero.P1,
      %3318 := quadZero.P2, %3319 := quadZero.P3, %3320 := quadZero.P4])
    (hI : Inv B M c S) (hr : M.Quad5Room r) :
    (fd_r52x5_double_scalar_mul_base.runFrom E 8 S >>= fun p =>
      PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom B.alloc.nextFreeBlock } : GlobalState))) =
      PoisonOr.value
        (Vals.nil,
          { alloc := ⟨B.alloc.nextFreeBlock + 38 + (c + ladderBlocks DK DS (n - 1))⟩,
            mem := (M.eraseFrom B.alloc.nextFreeBlock).storeQuad5 r
              (ladder TA TB DK DS (n - 1) quadZero) }) := by
  refine main_loop r kp a s tb B M TA TB DK DS _ _ n hn htb htbo hD hTA hTB (n - 1) (by omega) c
    quadZero S E hArgs hR hV hI fun E' S' hA' hR' hV' hI' => ?_
  exact exit_block r kp a s tb B M _ _ S' E' hA' hR' hV' hI' hr

/-! ### Below the frame: the entry's stores and the erase -/

theorem stores_eraseFrom_of_le {m : MemoryState} (h : n ≤ d.id.id) :
    fd_r52x5_wnaf.stores B d (m.eraseFrom n) x = m.eraseFrom n :=
  stores_ind' (d := d) (P := fun m' => m' = m.eraseFrom n)
    (fun _ _ _ hm => by rw [hm, MemoryState.storeAt_eraseFrom_of_le (by simpa using h)]) _ x rfl

theorem storesFrom_eraseFrom_of_le {m : MemoryState} {tab : Pointer} (h : n ≤ tab.id.id) :
    ∀ c j, fd_r52x5_odd_table.storesFrom (m.eraseFrom n) tab A j c = m.eraseFrom n
  | 0, _ => rfl
  | c + 1, j => by
    simp only [fd_r52x5_odd_table.storesFrom]
    rw [MemoryState.storeQuad5_eraseFrom_of_le (by simpa using h)]
    exact storesFrom_eraseFrom_of_le h c (j + 1)

theorem room_of_stores {m : MemoryState} (h : Room (fd_r52x5_wnaf.stores B d m x) p w) :
    Room m p w :=
  stores_ind (P := fun m' => Room m' p w → Room m p w)
    (fun _ _ _ ih hr => ih (Room.storeAt_iff.1 hr)) m x id h

theorem room_of_lifetimeStart_ne {m : MemoryState} (hne : p.id ≠ q.id)
    (h : Room (m.lifetimeStart q) p w) : Room m p w := by
  obtain ⟨⟨b, hb, hl, hw⟩, ⟨b', hb', hw'⟩⟩ := h
  rw [show (m.lifetimeStart q)[p.id]? = m[p.id]? from MemoryState.getElem?_setLifetime_ne hne]
    at hb hb'
  exact ⟨⟨b, hb, hl, hw⟩, ⟨b', hb', hw'⟩⟩

theorem room_of_storesFrom {m : MemoryState} {tab : Pointer} :
    ∀ c j, Room (fd_r52x5_odd_table.storesFrom m tab A j c) p w → Room m p w
  | 0, _, h => h
  | c + 1, j, h => by
    simp only [fd_r52x5_odd_table.storesFrom] at h
    exact Room.storeQuad5_iff.1 (room_of_storesFrom c (j + 1) h)

/-- `^bb5` with `n - 1` in `%3303` (`n ≤ 256`): at `n = 0`, `^bb7` returns the identity; else
`^bb6` on to `^bb8` at `n - 1`. -/
theorem from_bb5 (r kp a s tb : Pointer) (B : GlobalState) (M : MemoryState)
    (TA TB : Nat → Quad5) (DK DS : Nat → BitVec 16) (n : Nat) (hn : n ≤ 256)
    (htb : tb.id.id < B.alloc.nextFreeBlock + 3) (htbo : tb.offset = 0) (hD : Digits B M n DK DS)
    (hTA : TableAt M (B.slot 0) 8 TA) (hTB : TableAt M tb 128 TB) (c : Nat) (S : GlobalState)
    (E : ⟪Γ⟫) (hArgs : E.args = (args (.value r) (.value kp) (.value a) (.value s)).get)
    (hR : LoopRegs B tb E)
    (hV : E ⊨ [%3235 := Ty.wrap (Vector.replicate 4 0#64), %3236 := Ty.wrap #v[0#64, 1#64, 1#64, 0#64],
      %3303 := BitVec.ofNat 32 n + 4294967295#32])
    (hI : Inv B M c S) (hr : M.Quad5Room r) :
    (fd_r52x5_double_scalar_mul_base.runFrom E 5 S >>= fun p =>
      PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom B.alloc.nextFreeBlock } : GlobalState))) =
      PoisonOr.value
        (Vals.nil,
          { alloc := ⟨B.alloc.nextFreeBlock + 38 + (c + if n = 0 then 0 else ladderBlocks DK DS (n - 1))⟩,
            mem := (M.eraseFrom B.alloc.nextFreeBlock).storeQuad5 r
              (if n = 0 then quadZero else ladder TA TB DK DS (n - 1) quadZero) }) := by
  rcases Nat.eq_zero_or_pos n with hz | hpos
  · subst hz
    simp only [ite_true, Nat.add_zero]
    block_init
    step_pure [show (BitVec.ofNat 32 0 + 4294967295#32).slt 4294967295#32 = false by decide]
    finish_block
    exact exit_block r kp a s tb B M c quadZero S E hArgs (by lemma_reads) (by lemma_reads) hI hr
  · rw [ite_eq_right (by omega), ite_eq_right (by omega)]
    block_init
    step_pure [add_neg_one32 (i := n) (by omega) (by omega), slt_neg_one32 (i := n - 1) (by omega)]
    finish_block
    block_init
    step_pure [add_neg_one32 (i := n) (by omega) (by omega), msb32_false (a := n - 1) (by omega),
      setWidth64_ofNat32 (a := n - 1) (by omega)]
    finish_block
    exact from_bb8 r kp a s tb B M TA TB DK DS n hpos hn htb htbo hD hTA hTB c S E hArgs
      (by lemma_reads) (by lemma_reads) hI hr

theorem blocks_arith (n L : Nat) : n + 38 + (932 + L) = n + (38 + (125 + 115 * 7) + 2 + L) := by
  omega

/-! ### The call -/

set_option maxHeartbeats 8000000 in
public theorem call_eq (r kp a s : Pointer) (TB : Nat → Quad5) (s₀ : GlobalState) (hwf : s₀.WF)
    (hg : s₀.mem.Globals fd_r52x5_double_scalar_mul_base.globals) (flB tbB : BlockId)
    (hgf : s₀.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : s₀.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hfl : Fits s₀.mem ⟨flB, 0⟩ 1) (hset : s₀.mem.readAt ⟨flB, 0⟩ 1 = 1)
    (hTB : TableAt s₀.mem ⟨tbB, 0⟩ 128 TB)
    (hr : s₀.mem.Quad5Room r) (ha : s₀.mem.Quad5Fit a)
    (hk : Fits s₀.mem kp 256) (hko : ¬kp.offset.uaddOverflow 32#64)
    (hklt : (s₀.mem.readAt kp 256).toNat < 2 ^ 253)
    (hs : Fits s₀.mem s 256) (hso : ¬s.offset.uaddOverflow 32#64)
    (hslt : (s₀.mem.readAt s 256).toNat < 2 ^ 253) :
    fd_r52x5_double_scalar_mul_base.call
        (fd_r52x5_double_scalar_mul_base.args (.value r) (.value kp) (.value a) (.value s)) s₀ =
      .value
        (.nil,
          { alloc := ⟨s₀.alloc.nextFreeBlock + blocks (s₀.mem.readAt kp 256) (s₀.mem.readAt s 256)⟩,
            mem := s₀.mem.storeQuad5 r
              (spec TB (s₀.mem.readAt kp 256) (s₀.mem.readQuad5 a) (s₀.mem.readAt s 256)) }) := by
  generalize hP : spec TB (s₀.mem.readAt kp 256) (s₀.mem.readQuad5 a) (s₀.mem.readAt s 256) = P
  generalize hkb : blocks (s₀.mem.readAt kp 256) (s₀.mem.readAt s 256) = kb
  func_init
  obtain ⟨x1, hx1⟩ : ∃ x, S.mem.readAt kp 256 = x := ⟨_, rfl⟩
  obtain ⟨A, hA⟩ : ∃ A, S.mem.readQuad5 a = A := ⟨_, rfl⟩
  obtain ⟨x2, hx2⟩ : ∃ x, S.mem.readAt s 256 = x := ⟨_, rfl⟩
  rw [hx1, hA, hx2] at hP
  rw [hx1, hx2] at hkb
  rw [hx1] at hklt
  rw [hx2] at hslt
  have hr₀ : S₀.mem.Quad5Room r := hS ▸ hr
  have hTB₀ : TableAt S₀.mem ⟨tbB, 0⟩ 128 TB := hS ▸ hTB
  have htbB : tbB.id < S₀.alloc.nextFreeBlock := hwf₀.global_lt (hS ▸ hgb)
  have hflB : flB.id < S₀.alloc.nextFreeBlock := hwf₀.global_lt (hS ▸ hgf)
  clear hTB hr
  block_init
  iterate 14 step_pure
  -- the table's block from `hgb`: its global facts are not needed here
  step_impure => (exact run_addressof hgb)
  step_pure
  step_alloca with ta
  step_alloca with dk
  step_alloca with ds
  refine runBodyFrom_allocas ([%3246, %3247, %3248, %3249, %3250, %3251, %3252, %3253, %3254, %3255,
    %3256, %3257, %3258, %3259, %3260, %3261, %3262, %3263, %3264, %3265, %3266, %3267, %3268,
    %3269, %3270, %3271, %3272, %3273, %3274, %3275, %3276, %3277, %3278, %3279,
    %3280] : List (Dst fd_r52x5_double_scalar_mul_base.Γ .ptr))
    (rest := bb0.body.drop 54) rfl hwf ?_
  intro S' hwf' hF hRoom hAl hErase
  simp only [writeSlots, List.length_cons, List.length_nil, Nat.reduceAdd] at hF hAl ⊢
  have hslot : ∀ k, S.slot k = S₀.slot (3 + k) := fun k => by
    rw [hS, GlobalState.alloca_slot, GlobalState.alloca_slot, GlobalState.alloca_slot]; congr 1; omega
  simp only [hslot, Nat.reduceAdd]
  have hn : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 3 := by rw [hS]; rfl
  -- the three big slots and below: `S.mem`, so `S'.mem` has its facts
  have hE0 : S'.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) = S.mem := by
    rw [← hn, hErase, hwf.eraseFrom]
  obtain ⟨M', hM'⟩ : ∃ M', S'.mem = M' := ⟨_, rfl⟩
  have hM'e : M'.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
    rw [← hM', ← eraseFrom_eraseFrom (n := S₀.alloc.nextFreeBlock) (n' := S₀.alloc.nextFreeBlock + 3)
      (by omega), hE0, hS, GlobalState.eraseFrom_alloca_of_le (by simp only [GlobalState.alloca_alloc]; omega),
      GlobalState.eraseFrom_alloca_of_le (by simp only [GlobalState.alloca_alloc]; omega),
      GlobalState.eraseFrom_alloca_of_le (by omega), hwf₀.eraseFrom]
  have hAl' : S'.alloc = ⟨S₀.alloc.nextFreeBlock + 38⟩ := by rw [hAl, hn]
  have hS' : S' = { alloc := ⟨S₀.alloc.nextFreeBlock + 38⟩, mem := M' } := by
    rw [← hM', ← hAl']
  -- the 35 loop slots' facts, as the frame every later block takes them from
  have hF0 : Frame S₀ S'.mem := fun j h3 hj => by
    have h := hF (j - 3) (by omega)
    rw [hS, GlobalState.alloca_slot, GlobalState.alloca_slot, GlobalState.alloca_slot,
      show 1 + (1 + (1 + (j - 3))) = j by omega] at h
    exact h
  have hset' : S'.mem.readAt ⟨flB, 0⟩ 1 = 1 := by
    rw [← readAt_eraseFrom_of_lt (show flB.id < S₀.alloc.nextFreeBlock + 3 by omega), hE0]; exact hset
  have hx1' : S'.mem.readAt kp 256 = x1 := by
    rw [← readAt_eraseFrom_of_lt (id_lt_of_eraseFrom_fits (by rw [hE0]; exact hk)), hE0, hx1]
  have hx2' : S'.mem.readAt s 256 = x2 := by
    rw [← readAt_eraseFrom_of_lt (id_lt_of_eraseFrom_fits (by rw [hE0]; exact hs)), hE0, hx2]
  have hA2 : S'.mem.readQuad5 a = A := by
    rwa [← readQuad5_eraseFrom_of_lt (id_lt_of_eraseFrom_fits (by rw [hE0]; exact ha.2.1)), hE0]
  have hg' : S'.mem.Globals fd_r52x5_double_scalar_mul_base.globals := by rw [← hE0] at hg; exact hg
  have hgf' : S'.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image) := by
    rw [← hE0] at hgf; exact hgf
  have hfl' : Fits S'.mem ⟨flB, 0⟩ 1 := fits_of_eraseFrom (by rw [hE0]; exact hfl)
  have ha' : S'.mem.Quad5Fit a := quad5Fit_of_eraseFrom (by rw [hE0]; exact ha)
  have hk' : Fits S'.mem kp 256 := fits_of_eraseFrom (by rw [hE0]; exact hk)
  have hs' : Fits S'.mem s 256 := fits_of_eraseFrom (by rw [hE0]; exact hs)
  have hwritable_ta' : Writable S'.mem ta := writable_of_eraseFrom (by rw [hE0]; exact hwritable_ta)
  have hta_bounds' : InBounds S'.mem ta 12288 := inBounds_of_eraseFrom (by rw [hE0]; exact hta_bounds)
  have hwritable_dk' : Writable S'.mem dk := writable_of_eraseFrom (by rw [hE0]; exact hwritable_dk)
  have hdk_bounds' : InBounds S'.mem dk 4096 := inBounds_of_eraseFrom (by rw [hE0]; exact hdk_bounds)
  have hwritable_ds' : Writable S'.mem ds := writable_of_eraseFrom (by rw [hE0]; exact hwritable_ds)
  have hds_bounds' : InBounds S'.mem ds 4096 := inBounds_of_eraseFrom (by rw [hE0]; exact hds_bounds)
  clear hset hx1 hx2 hA hg hgf hgb hfl ha hk hs hwritable_ta hta_bounds hwritable_dk hdk_bounds
    hwritable_ds hds_bounds hF hRoom hErase hAl hAl' hE0 hn hwf hM'
  subst hS
  rename' S' => S, hwf' => hwf, hS' => hS
  have hg'' : S.mem.Globals fd_r52x5_base_table_init.globals := by mem_fact
  step_call using (fd_r52x5_base_table_init.call_eq_done S hwf hg'' flB hgf' hfl' hset')
  clear hg' hg'' hgf' hfl' hset'
  step_pure
  step_call using (fd_r52x5_odd_table.call_eq ta a 8#32 S hwf (by assumption) (by unfold oddTabRoom; mem_fact)
    (by rw [hta_off]; decide) (by decide))
  all_goals try (subst hS'; exact Writable.storesFrom' (by assumption) _ _)
  step_pure
  step_pure
  step_call using (fd_r52x5_wnaf.call_eq dk kp 4#32 S hwf (by mem_fact) (by rw [hdk_off]; decide) (by assumption) hko
    (by decide) (by rw [hx1']; exact hklt))
  all_goals try (subst hS'; exact Writable.stores (by assumption))
  step_call using (fd_r52x5_wnaf.call_eq ds s 8#32 S hwf (by mem_fact) (by rw [hds_off]; decide) (by assumption) hso
    (by decide) (by rw [hx2']; exact hslt))
  all_goals try (subst hS'; exact Writable.stores (by assumption))
  have hc4 := count_le 4 x1
  have hc8 := count_le 8 x2
  step_pure [smax32 (a := fd_r52x5_wnaf.count 4 x1) (b := fd_r52x5_wnaf.count 8 x2) (by omega) (by omega)]
  step_pure [slt32 (a := fd_r52x5_wnaf.count 4 x1) (b := fd_r52x5_wnaf.count 8 x2) (by omega) (by omega)]
  finish_block
  case isTrue =>
    rw [slt32 (a := fd_r52x5_wnaf.count 8 x2) (b := fd_r52x5_wnaf.count 4 x1) (by omega) (by omega),
      decide_eq_true_eq] at hbr
    block_init
    step_pure [signExtend_ofNat32 (a := fd_r52x5_wnaf.count 4 x1) (by omega)]
    step_pure [shl_mul2 (a := fd_r52x5_wnaf.count 4 x1) (by omega),
      sshr_mul2 (a := fd_r52x5_wnaf.count 4 x1) (by omega)]
    step_pure
    step_pure
    step_pure
    step_pure
    step_pure [memset_z (n := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2))
      (k := fd_r52x5_wnaf.count 4 x1) (by omega) (by omega),
      shl_mul2 (a := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 4 x1 - 1) (by omega),
      sshr_mul2 (a := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 4 x1 - 1) (by omega),
      ushr_mul2 (a := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 4 x1 - 1) (by omega)]
    step_pure [add_two64 (a := 2 * (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 4 x1 - 1)) (by omega)]
    have hR : Room S.mem (dk.add (BitVec.ofNat 64 (2 * fd_r52x5_wnaf.count 4 x1)))
        (8 * (2 * (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 4 x1))) := by
      refine Room.add_of_le ?_ ?_ hroom_dk
      · rw [hdk_off]; simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; simp; omega
      · simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega
    have hlen : (BitVec.ofNat 64 (2 * (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 4 x1 - 1) + 2)).toNat
        = 2 * (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 4 x1) := by
      simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega
    step_impure => (exact run_memset hlen hR)
    finish_block
    block_init
    step_pure [slt32 (a := fd_r52x5_wnaf.count 4 x1) (b := fd_r52x5_wnaf.count 8 x2) (by omega) (by omega)]
    finish_block
    case isTrue => simp only [decide_eq_true_eq] at hbr; omega
    clear hbr
    block_init
    step_pure
    finish_block
    -- `^bb5` with `n - 1`, `n = max c4 c8`
    have hM : S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) = S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) := rfl
    generalize hMdef : S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) = M at hM
    clear hM
    have hInv : Inv S₀ M 932 S := by
      refine ⟨hwf, ?_, hMdef, ?_⟩
      · exact hF0
      · rw [hS]
    subst hta hdk hds
    -- below the frame the memory is `S₀.mem`
    have herase0 : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
      rw [hS]; dsimp only
      simp (disch := first
          | assumption
          | (simp only [GlobalState.alloca_alloc, GlobalState.slot_id_id, Pointer.add_id] <;> omega)
          | omega) only [mlir_erase, MemoryState.eraseFrom_stores, stores_eraseFrom_of_le,
        MemoryState.eraseFrom_storesFrom', storesFrom_eraseFrom_of_le]
      exact hM'e
    have hne : ∀ (i j : Nat) (o : BitVec 64), i ≠ j → ((S₀.slot i).add o).id ≠ (S₀.slot j).id :=
      fun i j o h => by rw [Pointer.add_id]; exact GlobalState.slot_id_ne h
    have hne2 : ∀ (i j : Nat) (o o' : BitVec 64), i ≠ j →
        ((S₀.slot i).add o).id ≠ ((S₀.slot j).add o').id :=
      fun i j o o' h => by rw [Pointer.add_id, Pointer.add_id]; exact GlobalState.slot_id_ne h
    have hroomS : ∀ {p : Pointer} {w}, Room S₀.mem p w → Room S.mem p w := fun h =>
      room_of_eraseFrom (n := S₀.alloc.nextFreeBlock) (by rw [herase0]; exact h)
    have hrM : M.Quad5Room r := by
      rw [← hMdef]
      have hlt : r.id.id < S₀.alloc.nextFreeBlock + 3 := by
        have := hwf₀.id_lt_of_inBounds hr₀.2.1.inBounds; omega
      exact ⟨hr₀.1, Room.eraseFrom_of_lt hlt (hroomS hr₀.2.1),
        Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.1),
        Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.1),
        Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.2.1),
        Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.2.2)⟩
    have hTB' : TableAt M ⟨tbB, 0⟩ 128 TB := by
      rw [← hMdef]
      intro k hk
      obtain ⟨h1, h2⟩ := hTB₀ k hk
      have hlt : ((⟨tbB, 0⟩ : Pointer).add (BitVec.ofNat 64 (192 * k))).id.id <
          S₀.alloc.nextFreeBlock + 3 := by simp; omega
      refine ⟨Quad5Fit.eraseFrom_of_lt hlt ?_, ?_⟩
      · exact quad5Fit_of_eraseFrom (n := S₀.alloc.nextFreeBlock) (by rw [herase0]; exact h1)
      · rw [readQuad5_eraseFrom_of_lt hlt, ← h2, ← herase0,
          readQuad5_eraseFrom_of_lt (by simp; omega)]
    have hTA : TableAt M (S₀.slot 0) 8 (fd_r52x5_odd_table.spec A) := by
      rw [← hMdef]
      intro k hk
      have hlt : ((S₀.slot 0).add (BitVec.ofNat 64 (192 * k))).id.id < S₀.alloc.nextFreeBlock + 3 := by
        simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
      have hR : Room S.mem (S₀.slot 0) 12288 := hroom_ta
      rw [hS] at hR; dsimp only at hR
      have hR := room_of_stores (room_of_stores (Room.storeAt_iff.1 hR))
      have hR := room_of_lifetimeStart_ne (GlobalState.slot_id_ne (i := 0) (j := 1) (by decide))
        (room_of_lifetimeStart_ne (GlobalState.slot_id_ne (i := 0) (j := 2) (by decide)) hR)
      have hR := room_of_storesFrom 8 0 hR
      obtain ⟨h1, h2⟩ := storesFrom_entry (k := k) (A := A) hta_off 8 0 hR (by omega) (by omega) hk
      refine ⟨Quad5Fit.eraseFrom_of_lt hlt ?_, ?_⟩
      · rw [hS]; dsimp only
        exact MemoryState.Quad5Fit.storeAt (MemoryState.Quad5Fit.stores (MemoryState.Quad5Fit.stores
          ((h1.lifetimeStart (hne 0 1 _ (by decide))).lifetimeStart (hne 0 2 _ (by decide)))))
      · rw [readQuad5_eraseFrom_of_lt hlt, hS]; dsimp only
        rw [MemoryState.readQuad5_storeAt_of_id_ne (hne2 1 0 _ _ (by decide)),
          MemoryState.readQuad5_stores_of_id_ne (hne 0 2 _ (by decide)).symm,
          MemoryState.readQuad5_stores_of_id_ne (hne 0 1 _ (by decide)).symm,
          MemoryState.readQuad5_lifetimeStart, MemoryState.readQuad5_lifetimeStart, h2]
    have hD : Digits S₀ M (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2)) (DK x1)
        (DS x2) := by
      rw [← hMdef]
      intro i hi
      have hdko : ¬(S₀.slot 1).offset.uaddOverflow 512#64 := by rw [hdk_off]; decide
      have hdso : ¬(S₀.slot 2).offset.uaddOverflow 512#64 := by rw [hds_off]; decide
      have hRk : Room S.mem (S₀.slot 1) 4096 := hroom_dk
      have hRs : Room S.mem (S₀.slot 2) 4096 := hroom_ds
      rw [hS] at hRk hRs; dsimp only at hRk hRs
      have hRk := room_of_stores (room_of_stores (Room.storeAt_iff.1 hRk))
      have hRs := room_of_stores (Room.storeAt_iff.1 hRs)
      obtain ⟨hk1, hk2⟩ := dk_digits (ds := S₀.slot 2) (dk := S₀.slot 1) (x := x1) (y := x2) (i := i)
        (GlobalState.slot_id_ne (by decide)) hdko hRk (by omega) (by omega) hi
      obtain ⟨hs1, hs2⟩ := ds_digits (ds := S₀.slot 2) (x := x2) (i := i) hdso hRs (by omega)
      have hltk : ((S₀.slot 1).add (BitVec.ofNat 64 (2 * i))).id.id < S₀.alloc.nextFreeBlock + 3 := by
        simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
      have hlts : ((S₀.slot 2).add (BitVec.ofNat 64 (2 * i))).id.id < S₀.alloc.nextFreeBlock + 3 := by
        simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
      refine ⟨⟨Fits.eraseFrom_of_lt hltk ?_, ?_, DK_bounds x1 i⟩,
        ⟨Fits.eraseFrom_of_lt hlts ?_, ?_, DS_bounds x2 i⟩⟩
      · rw [hS]; exact hk1
      · rw [readAt_eraseFrom_of_lt hltk, hS]; exact hk2
      · rw [hS]; exact hs1.storeAt
      · rw [readAt_eraseFrom_of_lt hlts, hS]; dsimp only
        rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (hne2 1 2 _ _ (by decide))),
          hs2]
    rw [← hkb, ← hP]
    unfold blocks spec steps
    refine (from_bb5 r kp a s ⟨tbB, 0⟩ S₀ M (fd_r52x5_odd_table.spec A) TB (DK x1) (DS x2)
      (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2)) (by omega) (by show tbB.id < _; omega) rfl hD hTA hTB'
      932 S E hArgs (by lemma_reads) (by lemma_reads) hInv hrM).trans ?_
    rw [← hMdef, eraseFrom_eraseFrom (by omega), herase0, blocks_arith]
  case isFalse =>
    rw [slt32 (a := fd_r52x5_wnaf.count 8 x2) (b := fd_r52x5_wnaf.count 4 x1) (by omega) (by omega),
      decide_eq_true_eq] at hbr
    block_init
    step_pure [slt32 (a := fd_r52x5_wnaf.count 4 x1) (b := fd_r52x5_wnaf.count 8 x2) (by omega) (by omega)]
    finish_block
    case isTrue =>
      simp only [decide_eq_true_eq] at hbr
      have hmax : max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) = fd_r52x5_wnaf.count 4 x1 := by
        omega
      block_init
      step_pure [signExtend_ofNat32 (a := fd_r52x5_wnaf.count 8 x2) (by omega)]
      step_pure [shl_mul2 (a := fd_r52x5_wnaf.count 8 x2) (by omega),
        sshr_mul2 (a := fd_r52x5_wnaf.count 8 x2) (by omega)]
      step_pure
      step_pure
      step_pure [add_neg_one32 (i := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2)) (by omega) (by omega),
        sub32 (a := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - 1) (b := fd_r52x5_wnaf.count 8 x2) (by omega) (by omega)]
      step_pure [setWidth64_ofNat32 (a := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - 1 - fd_r52x5_wnaf.count 8 x2) (by omega)]
      step_pure [shl_mul2 (a := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - 1 - fd_r52x5_wnaf.count 8 x2) (by omega),
        sshr_mul2 (a := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - 1 - fd_r52x5_wnaf.count 8 x2) (by omega),
        ushr_mul2 (a := max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - 1 - fd_r52x5_wnaf.count 8 x2) (by omega)]
      step_pure [add_two64 (a := 2 * (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - 1 - fd_r52x5_wnaf.count 8 x2)) (by omega)]
      have hR : Room S.mem (ds.add (BitVec.ofNat 64 (2 * fd_r52x5_wnaf.count 8 x2)))
          (8 * (2 * (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 8 x2))) := by
        refine Room.add_of_le ?_ ?_ hroom_ds
        · rw [hds_off]; simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; simp; omega
        · simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega
      have hlen : (BitVec.ofNat 64 (2 * (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - 1 - fd_r52x5_wnaf.count 8 x2) + 2)).toNat
          = 2 * (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2) - fd_r52x5_wnaf.count 8 x2) := by
        simp only [BitVec.toNat_ofNat]; rw [Nat.mod_eq_of_lt (by omega)]; omega
      step_impure => (exact run_memset hlen hR)
      finish_block
      -- `^bb5` with `n - 1`, `n = max c4 c8`
      have hM : S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) = S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) := rfl
      generalize hMdef : S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) = M at hM
      clear hM
      have hInv : Inv S₀ M 932 S := by
        refine ⟨hwf, ?_, hMdef, ?_⟩
        · exact hF0
        · rw [hS]
      subst hta hdk hds
      -- below the frame the memory is `S₀.mem`
      have herase0 : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
        rw [hS]; dsimp only
        simp (disch := first
            | assumption
            | (simp only [GlobalState.alloca_alloc, GlobalState.slot_id_id, Pointer.add_id] <;> omega)
            | omega) only [mlir_erase, MemoryState.eraseFrom_stores, stores_eraseFrom_of_le,
          MemoryState.eraseFrom_storesFrom', storesFrom_eraseFrom_of_le]
        exact hM'e
      have hne : ∀ (i j : Nat) (o : BitVec 64), i ≠ j → ((S₀.slot i).add o).id ≠ (S₀.slot j).id :=
        fun i j o h => by rw [Pointer.add_id]; exact GlobalState.slot_id_ne h
      have hne2 : ∀ (i j : Nat) (o o' : BitVec 64), i ≠ j →
          ((S₀.slot i).add o).id ≠ ((S₀.slot j).add o').id :=
        fun i j o o' h => by rw [Pointer.add_id, Pointer.add_id]; exact GlobalState.slot_id_ne h
      have hroomS : ∀ {p : Pointer} {w}, Room S₀.mem p w → Room S.mem p w := fun h =>
        room_of_eraseFrom (n := S₀.alloc.nextFreeBlock) (by rw [herase0]; exact h)
      have hrM : M.Quad5Room r := by
        rw [← hMdef]
        have hlt : r.id.id < S₀.alloc.nextFreeBlock + 3 := by
          have := hwf₀.id_lt_of_inBounds hr₀.2.1.inBounds; omega
        exact ⟨hr₀.1, Room.eraseFrom_of_lt hlt (hroomS hr₀.2.1),
          Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.1),
          Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.1),
          Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.2.1),
          Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.2.2)⟩
      have hTB' : TableAt M ⟨tbB, 0⟩ 128 TB := by
        rw [← hMdef]
        intro k hk
        obtain ⟨h1, h2⟩ := hTB₀ k hk
        have hlt : ((⟨tbB, 0⟩ : Pointer).add (BitVec.ofNat 64 (192 * k))).id.id <
            S₀.alloc.nextFreeBlock + 3 := by simp; omega
        refine ⟨Quad5Fit.eraseFrom_of_lt hlt ?_, ?_⟩
        · exact quad5Fit_of_eraseFrom (n := S₀.alloc.nextFreeBlock) (by rw [herase0]; exact h1)
        · rw [readQuad5_eraseFrom_of_lt hlt, ← h2, ← herase0,
            readQuad5_eraseFrom_of_lt (by simp; omega)]
      have hTA : TableAt M (S₀.slot 0) 8 (fd_r52x5_odd_table.spec A) := by
        rw [← hMdef]
        intro k hk
        have hlt : ((S₀.slot 0).add (BitVec.ofNat 64 (192 * k))).id.id < S₀.alloc.nextFreeBlock + 3 := by
          simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
        have hR : Room S.mem (S₀.slot 0) 12288 := hroom_ta
        rw [hS] at hR; dsimp only at hR
        have hR := room_of_stores (room_of_stores (Room.storeAt_iff.1 hR))
        have hR := room_of_lifetimeStart_ne (GlobalState.slot_id_ne (i := 0) (j := 1) (by decide))
          (room_of_lifetimeStart_ne (GlobalState.slot_id_ne (i := 0) (j := 2) (by decide)) hR)
        have hR := room_of_storesFrom 8 0 hR
        obtain ⟨h1, h2⟩ := storesFrom_entry (k := k) (A := A) hta_off 8 0 hR (by omega) (by omega) hk
        refine ⟨Quad5Fit.eraseFrom_of_lt hlt ?_, ?_⟩
        · rw [hS]; dsimp only
          exact MemoryState.Quad5Fit.storeAt (MemoryState.Quad5Fit.stores (MemoryState.Quad5Fit.stores
            ((h1.lifetimeStart (hne 0 1 _ (by decide))).lifetimeStart (hne 0 2 _ (by decide)))))
        · rw [readQuad5_eraseFrom_of_lt hlt, hS]; dsimp only
          rw [MemoryState.readQuad5_storeAt_of_id_ne (hne2 2 0 _ _ (by decide)),
            MemoryState.readQuad5_stores_of_id_ne (hne 0 2 _ (by decide)).symm,
            MemoryState.readQuad5_stores_of_id_ne (hne 0 1 _ (by decide)).symm,
            MemoryState.readQuad5_lifetimeStart, MemoryState.readQuad5_lifetimeStart, h2]
      have hD : Digits S₀ M (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2)) (DK x1)
          (DS x2) := by
        rw [← hMdef]
        intro i hi
        have hdko : ¬(S₀.slot 1).offset.uaddOverflow 512#64 := by rw [hdk_off]; decide
        have hdso : ¬(S₀.slot 2).offset.uaddOverflow 512#64 := by rw [hds_off]; decide
        have hRk : Room S.mem (S₀.slot 1) 4096 := hroom_dk
        have hRs : Room S.mem (S₀.slot 2) 4096 := hroom_ds
        rw [hS] at hRk hRs; dsimp only at hRk hRs
        have hRk := room_of_stores (room_of_stores (Room.storeAt_iff.1 hRk))
        have hRs := room_of_stores (Room.storeAt_iff.1 hRs)
        obtain ⟨hk1, hk2⟩ := dk_digits_plain (ds := S₀.slot 2) (dk := S₀.slot 1) (x := x1) (y := x2) (i := i)
          (GlobalState.slot_id_ne (by decide)) hdko hRk (by omega)
        obtain ⟨hs1, hs2⟩ := ds_digits_memset (ds := S₀.slot 2) (x := x2) (i := i) hdso hRs (by omega)
          (by omega) hi
        have hltk : ((S₀.slot 1).add (BitVec.ofNat 64 (2 * i))).id.id < S₀.alloc.nextFreeBlock + 3 := by
          simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
        have hlts : ((S₀.slot 2).add (BitVec.ofNat 64 (2 * i))).id.id < S₀.alloc.nextFreeBlock + 3 := by
          simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
        refine ⟨⟨Fits.eraseFrom_of_lt hltk ?_, ?_, DK_bounds x1 i⟩,
          ⟨Fits.eraseFrom_of_lt hlts ?_, ?_, DS_bounds x2 i⟩⟩
        · rw [hS]; exact hk1.storeAt
        · rw [readAt_eraseFrom_of_lt hltk, hS]; dsimp only
          rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (hne2 2 1 _ _ (by decide))),
            hk2]
        · rw [hS]; exact hs1
        · rw [readAt_eraseFrom_of_lt hlts, hS]; exact hs2
      rw [← hkb, ← hP]
      unfold blocks spec steps
      refine (from_bb5 r kp a s ⟨tbB, 0⟩ S₀ M (fd_r52x5_odd_table.spec A) TB (DK x1) (DS x2)
        (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2)) (by omega) (by show tbB.id < _; omega) rfl hD hTA hTB'
        932 S E hArgs (by lemma_reads) (by lemma_reads) hInv hrM).trans ?_
      rw [← hMdef, eraseFrom_eraseFrom (by omega), herase0, blocks_arith]
    case isFalse =>
      simp only [decide_eq_true_eq] at hbr
      block_init
      step_pure
      finish_block
      -- `^bb5` with `n - 1`, `n = max c4 c8`
      have hM : S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) = S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) := rfl
      generalize hMdef : S.mem.eraseFrom (S₀.alloc.nextFreeBlock + 3) = M at hM
      clear hM
      have hInv : Inv S₀ M 932 S := by
        refine ⟨hwf, ?_, hMdef, ?_⟩
        · exact hF0
        · rw [hS]
      subst hta hdk hds
      -- below the frame the memory is `S₀.mem`
      have herase0 : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
        rw [hS]; dsimp only
        simp (disch := first
            | assumption
            | (simp only [GlobalState.alloca_alloc, GlobalState.slot_id_id, Pointer.add_id] <;> omega)
            | omega) only [mlir_erase, MemoryState.eraseFrom_stores, stores_eraseFrom_of_le,
          MemoryState.eraseFrom_storesFrom', storesFrom_eraseFrom_of_le]
        exact hM'e
      have hne : ∀ (i j : Nat) (o : BitVec 64), i ≠ j → ((S₀.slot i).add o).id ≠ (S₀.slot j).id :=
        fun i j o h => by rw [Pointer.add_id]; exact GlobalState.slot_id_ne h
      have hne2 : ∀ (i j : Nat) (o o' : BitVec 64), i ≠ j →
          ((S₀.slot i).add o).id ≠ ((S₀.slot j).add o').id :=
        fun i j o o' h => by rw [Pointer.add_id, Pointer.add_id]; exact GlobalState.slot_id_ne h
      have hroomS : ∀ {p : Pointer} {w}, Room S₀.mem p w → Room S.mem p w := fun h =>
        room_of_eraseFrom (n := S₀.alloc.nextFreeBlock) (by rw [herase0]; exact h)
      have hrM : M.Quad5Room r := by
        rw [← hMdef]
        have hlt : r.id.id < S₀.alloc.nextFreeBlock + 3 := by
          have := hwf₀.id_lt_of_inBounds hr₀.2.1.inBounds; omega
        exact ⟨hr₀.1, Room.eraseFrom_of_lt hlt (hroomS hr₀.2.1),
          Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.1),
          Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.1),
          Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.2.1),
          Room.eraseFrom_of_lt (by simpa using hlt) (hroomS hr₀.2.2.2.2.2)⟩
      have hTB' : TableAt M ⟨tbB, 0⟩ 128 TB := by
        rw [← hMdef]
        intro k hk
        obtain ⟨h1, h2⟩ := hTB₀ k hk
        have hlt : ((⟨tbB, 0⟩ : Pointer).add (BitVec.ofNat 64 (192 * k))).id.id <
            S₀.alloc.nextFreeBlock + 3 := by simp; omega
        refine ⟨Quad5Fit.eraseFrom_of_lt hlt ?_, ?_⟩
        · exact quad5Fit_of_eraseFrom (n := S₀.alloc.nextFreeBlock) (by rw [herase0]; exact h1)
        · rw [readQuad5_eraseFrom_of_lt hlt, ← h2, ← herase0,
            readQuad5_eraseFrom_of_lt (by simp; omega)]
      have hTA : TableAt M (S₀.slot 0) 8 (fd_r52x5_odd_table.spec A) := by
        rw [← hMdef]
        intro k hk
        have hlt : ((S₀.slot 0).add (BitVec.ofNat 64 (192 * k))).id.id < S₀.alloc.nextFreeBlock + 3 := by
          simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
        have hR : Room S.mem (S₀.slot 0) 12288 := hroom_ta
        rw [hS] at hR; dsimp only at hR
        have hR := room_of_stores (room_of_stores hR)
        have hR := room_of_lifetimeStart_ne (GlobalState.slot_id_ne (i := 0) (j := 1) (by decide))
          (room_of_lifetimeStart_ne (GlobalState.slot_id_ne (i := 0) (j := 2) (by decide)) hR)
        have hR := room_of_storesFrom 8 0 hR
        obtain ⟨h1, h2⟩ := storesFrom_entry (k := k) (A := A) hta_off 8 0 hR (by omega) (by omega) hk
        refine ⟨Quad5Fit.eraseFrom_of_lt hlt ?_, ?_⟩
        · rw [hS]; dsimp only
          exact MemoryState.Quad5Fit.stores (MemoryState.Quad5Fit.stores
            ((h1.lifetimeStart (hne 0 1 _ (by decide))).lifetimeStart (hne 0 2 _ (by decide))))
        · rw [readQuad5_eraseFrom_of_lt hlt, hS]; dsimp only
          rw [MemoryState.readQuad5_stores_of_id_ne (hne 0 2 _ (by decide)).symm,
            MemoryState.readQuad5_stores_of_id_ne (hne 0 1 _ (by decide)).symm,
            MemoryState.readQuad5_lifetimeStart, MemoryState.readQuad5_lifetimeStart, h2]
      have hD : Digits S₀ M (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2)) (DK x1)
          (DS x2) := by
        rw [← hMdef]
        intro i hi
        have hdko : ¬(S₀.slot 1).offset.uaddOverflow 512#64 := by rw [hdk_off]; decide
        have hdso : ¬(S₀.slot 2).offset.uaddOverflow 512#64 := by rw [hds_off]; decide
        have hRk : Room S.mem (S₀.slot 1) 4096 := hroom_dk
        have hRs : Room S.mem (S₀.slot 2) 4096 := hroom_ds
        rw [hS] at hRk hRs; dsimp only at hRk hRs
        have hRk := room_of_stores (room_of_stores hRk)
        have hRs := room_of_stores hRs
        obtain ⟨hk1, hk2⟩ := dk_digits_plain (ds := S₀.slot 2) (dk := S₀.slot 1) (x := x1) (y := x2) (i := i)
          (GlobalState.slot_id_ne (by decide)) hdko hRk (by omega)
        obtain ⟨hs1, hs2⟩ := ds_digits (ds := S₀.slot 2) (x := x2) (i := i) hdso hRs (by omega)
        have hltk : ((S₀.slot 1).add (BitVec.ofNat 64 (2 * i))).id.id < S₀.alloc.nextFreeBlock + 3 := by
          simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
        have hlts : ((S₀.slot 2).add (BitVec.ofNat 64 (2 * i))).id.id < S₀.alloc.nextFreeBlock + 3 := by
          simp only [Pointer.add_id, GlobalState.slot_id_id]; omega
        refine ⟨⟨Fits.eraseFrom_of_lt hltk ?_, ?_, DK_bounds x1 i⟩,
          ⟨Fits.eraseFrom_of_lt hlts ?_, ?_, DS_bounds x2 i⟩⟩
        · rw [hS]; exact hk1
        · rw [readAt_eraseFrom_of_lt hltk, hS]; exact hk2
        · rw [hS]; exact hs1
        · rw [readAt_eraseFrom_of_lt hlts, hS]; exact hs2
      rw [← hkb, ← hP]
      unfold blocks spec steps
      refine (from_bb5 r kp a s ⟨tbB, 0⟩ S₀ M (fd_r52x5_odd_table.spec A) TB (DK x1) (DS x2)
        (max (fd_r52x5_wnaf.count 4 x1) (fd_r52x5_wnaf.count 8 x2)) (by omega) (by show tbB.id < _; omega) rfl hD hTA hTB'
        932 S E hArgs (by lemma_reads) (by lemma_reads) hInv hrM).trans ?_
      rw [← hMdef, eraseFrom_eraseFrom (by omega), herase0, blocks_arith]
