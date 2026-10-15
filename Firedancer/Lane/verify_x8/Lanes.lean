module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Mem
public import Firedancer.Lane.Common.Pick
public import Firedancer.Lane.verify_x8.Defs
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512

@[expose] public section

/-- `T + |d| * 1600 + o`: lane pointer `o` bytes into `ktab`'s entry `|d|`. -/
def kPtr (T : Pointer) (d : BitVec 8) (o : Nat) : Pointer :=
  T.add (BitVec.ofNat 64 (d.toInt.natAbs * 1600 + o))

variable {Γ : Ctx}

/-- Lane `j > 0`'s pointers of a `[k]` window, 16 instructions: from digit `d = dv[j]` and its
magnitude `av[j]`, `&ktab[|d|][j]`'s `y + x`, `y - x` (swapped for `d < 0`), `2dt` (`-2dt`) and `z`
stored at `sp`, `sm`, `sk`, `sz`; `pOff`, `mOff`, `zOff` are `8 j`, `320 + 8 j`, `1280 + 8 j`, and
`oN`, `oP` hold `960 + 8 j`, `640 + 8 j`. -/
def kLaneRun (pOff mOff zOff : Int) (dv av : Dst Γ (.vec 8 8)) (idx : Dst Γ (.bv 64))
    (z8 : Dst Γ (.bv 8)) (tab : Dst Γ .ptr) (oN oP : Dst Γ (.bv 64)) (sp sm sk sz : Dst Γ .ptr)
    (d : Dst Γ (.bv 8)) (n : Dst Γ (.bv 1)) (a : Dst Γ (.bv 8)) (z : Dst Γ (.bv 64))
    (e p m s1 s2 : Dst Γ .ptr) (o : Dst Γ (.bv 64)) (k zz : Dst Γ .ptr) : List (Instr Γ) :=
  [.binop .extractelement d (.val dv.i dv.h) (.val idx.i idx.h),
    .binop (.icmp .slt) n (.val d.i d.h) (.val z8.i z8.h),
    .binop .extractelement a (.val av.i av.h) (.val idx.i idx.h),
    .unop (.zext false) z (.val a.i a.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 1600) e (.val tab.i tab.h) (.val z.i z.h),
    .unop (.gepConst { nusw := true, nuw := true } pOff) p (.val e.i e.h),
    .unop (.gepConst { nusw := true, nuw := true } mOff) m (.val e.i e.h),
    .ternop .select s1 (.val n.i n.h) (.val m.i m.h) (.val p.i p.h),
    .store (.val sp.i sp.h) (.val s1.i s1.h),
    .ternop .select s2 (.val n.i n.h) (.val p.i p.h) (.val m.i m.h),
    .store (.val sm.i sm.h) (.val s2.i s2.h),
    .ternop .select o (.val n.i n.h) (.val oN.i oN.h) (.val oP.i oP.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 1) k (.val e.i e.h) (.val o.i o.h),
    .store (.val sk.i sk.h) (.val k.i k.h),
    .unop (.gepConst { nusw := true, nuw := true } zOff) zz (.val e.i e.h),
    .store (.val sz.i sz.h) (.val zz.i zz.h)]



/-- A digit's `abs`, zero-extended: its magnitude. -/
theorem abs_toNat {w : Nat} (d : BitVec w) (hw : 0 < w) (k : Nat) (hk : w ≤ k) :
    (BitVec.setWidth k (if d.msb = true then -d else d)).toNat = d.toInt.natAbs := by
  have hlt := d.isLt
  have hpow : 2 ^ w ≤ 2 ^ k := Nat.pow_le_pow_right (by omega) hk
  rw [BitVec.toNat_setWidth, apply_ite BitVec.toNat, BitVec.toNat_neg, BitVec.toInt_eq_toNat_cond,
    BitVec.msb_eq_decide]
  have h2 : 2 ^ w = 2 * 2 ^ (w - 1) := by rw [← Nat.pow_succ']; congr 1; omega
  have hH : 0 < 2 ^ (w - 1) := Nat.two_pow_pos _
  generalize 2 ^ w = N at *
  generalize 2 ^ (w - 1) = H at *
  generalize 2 ^ k = M at *
  generalize d.toNat = x at *
  by_cases hm : H ≤ x
  · simp only [hm, decide_true, ite_true]
    rw [Nat.mod_eq_of_lt (by omega : N - x < N), Nat.mod_eq_of_lt (by omega : N - x < M)]
    split <;> omega
  · simp only [hm, decide_false, Bool.false_eq_true, ite_false]
    rw [Nat.mod_eq_of_lt (by omega : x < M)]
    split <;> omega



/-- Lane `0`'s pointers of a `[k]` window, 16 instructions: `kLaneRun` with the magnitudes `av` of
all eight digits computed after the sign test, and no offset for `y + x`. -/
def kLane0Run (dv : Dst Γ (.vec 8 8)) (idx : Dst Γ (.bv 64)) (z8 : Dst Γ (.bv 8)) (tab : Dst Γ .ptr)
    (oN oP : Dst Γ (.bv 64)) (sp sm sk sz : Dst Γ .ptr) (d : Dst Γ (.bv 8)) (n : Dst Γ (.bv 1))
    (av : Dst Γ (.vec 8 8)) (a : Dst Γ (.bv 8)) (z : Dst Γ (.bv 64)) (e m s1 s2 : Dst Γ .ptr)
    (o : Dst Γ (.bv 64)) (k zz : Dst Γ .ptr) : List (Instr Γ) :=
  [.binop .extractelement d (.val dv.i dv.h) (.val idx.i idx.h),
    .binop (.icmp .slt) n (.val d.i d.h) (.val z8.i z8.h),
    .unop (.vector (.abs false)) av (.val dv.i dv.h),
    .binop .extractelement a (.val av.i av.h) (.val idx.i idx.h),
    .unop (.zext false) z (.val a.i a.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 1600) e (.val tab.i tab.h) (.val z.i z.h),
    .unop (.gepConst { nusw := true, nuw := true } 320) m (.val e.i e.h),
    .ternop .select s1 (.val n.i n.h) (.val m.i m.h) (.val e.i e.h),
    .store (.val sp.i sp.h) (.val s1.i s1.h),
    .ternop .select s2 (.val n.i n.h) (.val e.i e.h) (.val m.i m.h),
    .store (.val sm.i sm.h) (.val s2.i s2.h),
    .ternop .select o (.val n.i n.h) (.val oN.i oN.h) (.val oP.i oP.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 1) k (.val e.i e.h) (.val o.i o.h),
    .store (.val sk.i sk.h) (.val k.i k.h),
    .unop (.gepConst { nusw := true, nuw := true } 1280) zz (.val e.i e.h),
    .store (.val sz.i sz.h) (.val zz.i zz.h)]

/-! ### The `[k]` operands' pointer arrays -/

/-- Lane `j`'s `y + x` pointer for digits `D`: `y - x` for a negative digit. -/
def kP (T : Pointer) (D : Vector (BitVec 8) 8) (j : Fin 8) : Pointer :=
  kPtr T D[j.val] (if D[j.val].toInt < 0 then 320 + 8 * j else 8 * j)

/-- Lane `j`'s `y - x` pointer: `y + x` for a negative digit. -/
def kM (T : Pointer) (D : Vector (BitVec 8) 8) (j : Fin 8) : Pointer :=
  kPtr T D[j.val] (if D[j.val].toInt < 0 then 8 * j else 320 + 8 * j)

/-- Lane `j`'s `2dt` pointer: `-2dt` for a negative digit. -/
def kK (T : Pointer) (D : Vector (BitVec 8) 8) (j : Fin 8) : Pointer :=
  kPtr T D[j.val] (if D[j.val].toInt < 0 then 960 + 8 * j else 640 + 8 * j)

/-- Lane `j`'s `z` pointer. -/
def kZ (T : Pointer) (D : Vector (BitVec 8) 8) (j : Fin 8) : Pointer :=
  kPtr T D[j.val] (1280 + 8 * j)

/-- The `[k]` operands, with offsets `o j` into entries `|D[j]|`, are table rows. -/
theorem kPickFit {m : MemoryState} {T : Pointer} (hT : T.offset = 0#64)
    (hf : Fits m T (64 * 1800)) {D : Vector (BitVec 8) 8}
    (hD : ∀ j : Fin 8, D[j.val].toInt.natAbs ≤ 8)
    {o : Fin 8 → Nat} (ho : ∀ j : Fin 8, ∃ cm ≤ 4, o j = 320 * cm + 8 * j) :
    m.PickFit 1#32 (fun j => kPtr T D[j.val] (o j)) 8#64 := by
  choose cm hcm ho using ho
  simp only [MemoryState.PickFit, show (1#32 : BitVec 32) ≠ 0 by decide, ite_false]
  intro i hi
  have hs : (8#64 : BitVec 64).toNat = 8 := rfl
  rw [hs]
  have hb (j : Fin 8) := hD j
  have hc (j : Fin 8) := hcm j
  refine MemoryState.RowsAt.of_rows
    (row := fun j => T.add (BitVec.ofNat 64 (D[j.val].toInt.natAbs * 1600 + 320 * cm j)))
    (fun j => ?_) (by omega) (fun j => ?_) (fun j => ?_)
  · rw [kPtr, ho j, Pointer.add_add, ← BitVec.ofNat_add, Nat.add_assoc]
  · have := hb j; have := hc j
    simp only [Pointer.add, hT, BitVec.zero_add, BitVec.uaddOverflow, BitVec.toNat_ofNat,
      decide_eq_true_eq]
    rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
    omega
  · have := hb j; have := hc j
    rw [Pointer.add_add, ← BitVec.ofNat_add]
    refine hf.add_of_le ?_ ?_
    · simp only [hT, BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
      rw [Nat.mod_eq_of_lt (by omega)]
      omega
    · simp only [BitVec.toNat_ofNat]
      rw [Nat.mod_eq_of_lt (by omega)]
      omega

theorem kP_fit {m : MemoryState} {T : Pointer} (hT : T.offset = 0#64) (hf : Fits m T (64 * 1800))
    {D : Vector (BitVec 8) 8} (hD : ∀ j : Fin 8, D[j.val].toInt.natAbs ≤ 8) :
    m.PickFit 1#32 (kP T D) 8#64 :=
  kPickFit hT hf hD fun j => by
    by_cases h : D[j.val].toInt < 0
    · exact ⟨1, by omega, by simp [h]⟩
    · exact ⟨0, by omega, by simp [h]⟩

theorem kM_fit {m : MemoryState} {T : Pointer} (hT : T.offset = 0#64) (hf : Fits m T (64 * 1800))
    {D : Vector (BitVec 8) 8} (hD : ∀ j : Fin 8, D[j.val].toInt.natAbs ≤ 8) :
    m.PickFit 1#32 (kM T D) 8#64 :=
  kPickFit hT hf hD fun j => by
    by_cases h : D[j.val].toInt < 0
    · exact ⟨0, by omega, by simp [h]⟩
    · exact ⟨1, by omega, by simp [h]⟩

theorem kK_fit {m : MemoryState} {T : Pointer} (hT : T.offset = 0#64) (hf : Fits m T (64 * 1800))
    {D : Vector (BitVec 8) 8} (hD : ∀ j : Fin 8, D[j.val].toInt.natAbs ≤ 8) :
    m.PickFit 1#32 (kK T D) 8#64 :=
  kPickFit hT hf hD fun j => by
    by_cases h : D[j.val].toInt < 0
    · exact ⟨3, by omega, by simp [h]⟩
    · exact ⟨2, by omega, by simp [h]⟩

theorem kZ_fit {m : MemoryState} {T : Pointer} (hT : T.offset = 0#64) (hf : Fits m T (64 * 1800))
    {D : Vector (BitVec 8) 8} (hD : ∀ j : Fin 8, D[j.val].toInt.natAbs ≤ 8) :
    m.PickFit 1#32 (kZ T D) 8#64 :=
  kPickFit hT hf hD fun j => ⟨4, by omega, by simp⟩

/-- An array of eight pointers from its eight loads. -/
theorem ptrArray_of {m : MemoryState} {a : Pointer} {src : Fin 8 → Pointer} (ho : a.offset = 0#64)
    (hb : InBounds m a 512) (h0 : m.loadPtr a = .value (src 0))
    (h1 : m.loadPtr (a.add 8#64) = .value (src 1)) (h2 : m.loadPtr (a.add 16#64) = .value (src 2))
    (h3 : m.loadPtr (a.add 24#64) = .value (src 3)) (h4 : m.loadPtr (a.add 32#64) = .value (src 4))
    (h5 : m.loadPtr (a.add 40#64) = .value (src 5)) (h6 : m.loadPtr (a.add 48#64) = .value (src 6))
    (h7 : m.loadPtr (a.add 56#64) = .value (src 7)) : m.PtrArray a src := by
  refine ⟨by simp [ho, BitVec.uaddOverflow], hb, fun j => ?_⟩
  fin_cases j
  · simpa using h0
  · exact h1
  · exact h2
  · exact h3
  · exact h4
  · exact h5
  · exact h6
  · exact h7

/-- `Tb + |d| * 160 + 8 o`: limb `o`'s qword of the fixed-base table's entry `|d|`. -/
def bPtr (Tb : Pointer) (d : BitVec 16) (o : Nat) : Pointer :=
  Tb.add (BitVec.ofNat 64 (d.toInt.natAbs * 160 + 8 * o))

/-- Lane `j > 0`'s pointers of an `[S]` window, 14 instructions: from digit `d = sv[j]` and
`mv[j] = |d| * 160`, the base table's `y + x`, `y - x` (swapped for `d < 0`) and `2dt` (`-2dt`) of
entry `|d|` stored at `sp`, `sm`, `sk`; `c5`, `c0`, `c15`, `c10` hold `5, 0, 15, 10` (`c5` is lane
`5`'s index register too). -/
def bLaneRun (sv : Dst Γ (.vec 8 16)) (mv : Dst Γ (.vec 8 32)) (idx : Dst Γ (.bv 64))
    (z16 : Dst Γ (.bv 16)) (tb : Dst Γ .ptr) (c5 c0 c15 c10 : Dst Γ (.bv 64))
    (sp sm sk : Dst Γ .ptr)
    (d : Dst Γ (.bv 16)) (n : Dst Γ (.bv 1)) (mj : Dst Γ (.bv 32)) (z : Dst Γ (.bv 64))
    (e : Dst Γ .ptr) (o1 : Dst Γ (.bv 64)) (q1 : Dst Γ .ptr) (o2 : Dst Γ (.bv 64)) (q2 : Dst Γ .ptr)
    (o3 : Dst Γ (.bv 64)) (q3 : Dst Γ .ptr) : List (Instr Γ) :=
  [.binop .extractelement d (.val sv.i sv.h) (.val idx.i idx.h),
    .binop (.icmp .slt) n (.val d.i d.h) (.val z16.i z16.h),
    .binop .extractelement mj (.val mv.i mv.h) (.val idx.i idx.h),
    .unop (.zext true) z (.val mj.i mj.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 1) e (.val tb.i tb.h) (.val z.i z.h),
    .ternop .select o1 (.val n.i n.h) (.val c5.i c5.h) (.val c0.i c0.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) q1 (.val e.i e.h) (.val o1.i o1.h),
    .store (.val sp.i sp.h) (.val q1.i q1.h),
    .ternop .select o2 (.val n.i n.h) (.val c0.i c0.h) (.val c5.i c5.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) q2 (.val e.i e.h) (.val o2.i o2.h),
    .store (.val sm.i sm.h) (.val q2.i q2.h),
    .ternop .select o3 (.val n.i n.h) (.val c15.i c15.h) (.val c10.i c10.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) q3 (.val e.i e.h) (.val o3.i o3.h),
    .store (.val sk.i sk.h) (.val q3.i q3.h)]

/-- Lane `0`'s pointers of an `[S]` window, 17 instructions: `bLaneRun` with `mv = |sv| * 160`
computed (as `av`, `zv`) after the sign test; `k160` holds `160` in every lane, and the index `0`
is the select's `0` too. -/
def bLane0Run (sv : Dst Γ (.vec 8 16)) (idx : Dst Γ (.bv 64)) (z16 : Dst Γ (.bv 16))
    (k160 : Dst Γ (.vec 8 32)) (tb : Dst Γ .ptr) (c5 c15 c10 : Dst Γ (.bv 64))
    (sp sm sk : Dst Γ .ptr) (d : Dst Γ (.bv 16)) (n : Dst Γ (.bv 1)) (av : Dst Γ (.vec 8 16))
    (zv mv : Dst Γ (.vec 8 32)) (mj : Dst Γ (.bv 32)) (z : Dst Γ (.bv 64)) (e : Dst Γ .ptr)
    (o1 : Dst Γ (.bv 64)) (q1 : Dst Γ .ptr) (o2 : Dst Γ (.bv 64)) (q2 : Dst Γ .ptr)
    (o3 : Dst Γ (.bv 64)) (q3 : Dst Γ .ptr) : List (Instr Γ) :=
  [.binop .extractelement d (.val sv.i sv.h) (.val idx.i idx.h),
    .binop (.icmp .slt) n (.val d.i d.h) (.val z16.i z16.h),
    .unop (.vector (.abs false)) av (.val sv.i sv.h),
    .unop (.vector (.zext false)) zv (.val av.i av.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) mv (.val zv.i zv.h) (.val k160.i k160.h),
    .binop .extractelement mj (.val mv.i mv.h) (.val idx.i idx.h),
    .unop (.zext true) z (.val mj.i mj.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 1) e (.val tb.i tb.h) (.val z.i z.h),
    .ternop .select o1 (.val n.i n.h) (.val c5.i c5.h) (.val idx.i idx.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) q1 (.val e.i e.h) (.val o1.i o1.h),
    .store (.val sp.i sp.h) (.val q1.i q1.h),
    .ternop .select o2 (.val n.i n.h) (.val idx.i idx.h) (.val c5.i c5.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) q2 (.val e.i e.h) (.val o2.i o2.h),
    .store (.val sm.i sm.h) (.val q2.i q2.h),
    .ternop .select o3 (.val n.i n.h) (.val c15.i c15.h) (.val c10.i c10.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) q3 (.val e.i e.h) (.val o3.i o3.h),
    .store (.val sk.i sk.h) (.val q3.i q3.h)]

/-! ### Objects past pointer stores into other blocks -/

theorem _root_.MLIR.MemoryState.readVec_storePtr_of_id_ne {m : MemoryState} {p q x : Pointer}
    (h : q.id ≠ p.id) : (m.storePtr q x).readVec p = m.readVec p := by
  simp only [MemoryState.readVec,
    MemoryState.readAt_storePtr_disjoint (Range.disjoint_of_id_ne h)]

theorem _root_.MLIR.MemoryState.readFe_storePtr_of_id_ne {m : MemoryState} {p q x : Pointer}
    (h : q.id ≠ p.id) : (m.storePtr q x).readFe p = m.readFe p := by
  have h' (o : BitVec 64) : q.id ≠ (p.add o).id := by simpa using h
  simp only [MemoryState.readFe, MemoryState.readVec_storePtr_of_id_ne h,
    MemoryState.readVec_storePtr_of_id_ne (h' _)]

theorem _root_.MLIR.MemoryState.readLanePoint_storePtr_of_id_ne {m : MemoryState}
    {p q x : Pointer} (h : q.id ≠ p.id) :
    (m.storePtr q x).readLanePoint p = m.readLanePoint p := by
  have h' (o : BitVec 64) : q.id ≠ (p.add o).id := by simpa using h
  simp only [MemoryState.readLanePoint, MemoryState.readFe_storePtr_of_id_ne h,
    MemoryState.readFe_storePtr_of_id_ne (h' _)]

theorem _root_.MLIR.MemoryState.FeFit.storePtr_of_id_ne {m : MemoryState} {p q x : Pointer}
    (h : m.FeFit p) (hne : q.id ≠ p.id) : (m.storePtr q x).FeFit p :=
  ⟨h.1, h.2.storePtr_of_disjoint (Range.disjoint_of_id_ne hne)⟩

theorem _root_.MLIR.MemoryState.LanePointFit.storePtr_of_id_ne {m : MemoryState}
    {p q x : Pointer} (h : m.LanePointFit p) (hne : q.id ≠ p.id) :
    (m.storePtr q x).LanePointFit p :=
  ⟨h.1, h.2.storePtr_of_disjoint (Range.disjoint_of_id_ne hne)⟩

theorem _root_.MLIR.MemoryState.LanePointRoom.storePtr {m : MemoryState} {p q x : Pointer}
    (h : m.LanePointRoom p) : (m.storePtr q x).LanePointRoom p :=
  ⟨h.1, h.2.storePtr⟩

/-- A small counter truncated to 32 bits and widened back, either way. -/
theorem trunc_small {w : Nat} (hw : w < 2 ^ 31) :
    (BitVec.ofNat 32 w).setWidth 64 = BitVec.ofNat 64 w ∧
      (BitVec.ofNat 32 w).signExtend 64 = BitVec.ofNat 64 w := by
  have h1 : (BitVec.ofNat 32 w).setWidth 64 = BitVec.ofNat 64 w := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    omega
  refine ⟨h1, ?_⟩
  rw [BitVec.signExtend_eq_setWidth_of_msb_false, h1]
  rw [BitVec.msb_eq_decide]
  simp only [BitVec.toNat_ofNat, decide_eq_false_iff_not]
  omega

/-- Window `w`'s parity test. -/
theorem even_iff {w : Nat} (hw : w < 64) :
    BitVec.ofNat 32 w &&& 1#32 = 0#32 ↔ w % 2 = 0 := by
  revert w; decide

/-- An even window's low bit. -/
theorem lsb_zero {w : Nat} (hw : w < 64) (h : w % 2 = 0) :
    BitVec.extractLsb' 0 1 (BitVec.ofNat 64 w) = 0#1 := by
  revert w; decide

/-- `w >> 1`, masked to 31 bits. -/
theorem half_mask {w : Nat} (hw : w < 64) :
    BitVec.ofNat 64 w >>> 1 &&& 2147483647#64 = BitVec.ofNat 64 (w / 2) := by
  revert w; decide

/-- The `[k]` add's `with_t`: `!(w & 1)`. -/
theorem withT_eq {w : Nat} (hw : w < 64) :
    decide (BitVec.ofNat 32 w &&& 1#32 ^^^ 1#32 ≠ 0#32) = decide (w % 2 = 0) := by
  revert w; decide

/-- A `[S]` digit's magnitude times an entry's 160 bytes, in 32 bits: no signed overflow. -/
theorem bmul_smul (a : BitVec 16) :
    (BitVec.setWidth 32 (if a.msb = true then -a else a)).smulOverflow 160#32 = false := by
  bv_decide

/-- A `[S]` digit's magnitude times an entry's 160 bytes, in 32 bits: no unsigned overflow. -/
theorem bmul_umul (a : BitVec 16) :
    (BitVec.setWidth 32 (if a.msb = true then -a else a)).umulOverflow 160#32 = false := by
  bv_decide

/-- A 16-bit value's magnitude is at most `2 ^ 15`. -/
theorem abs_le16 (a : BitVec 16) : a.toInt.natAbs ≤ 2 ^ 15 := by
  have := BitVec.toInt_lt (x := a); have := BitVec.le_toInt (x := a)
  simp at *
  omega

/-- A digit's sign test. -/
theorem slt_zero_iff {w : Nat} (d : BitVec w) :
    (BitVec.ofBool (d.slt 0#w) = 1#1) ↔ d.toInt < 0 := by
  simp [BitVec.slt, BitVec.ofBool]

/-- A lane pointer as the steps compute it: entry `|d|` from its `abs`, then `o` bytes on. -/
theorem kPtr_eq {T : Pointer} {d : BitVec 8} {o : Nat} :
    (T.add
        (BitVec.ofNat 64 ((BitVec.setWidth 64 (if d.msb = true then -d else d)).toNat * 1600))).add
      (BitVec.ofNat 64 o) =
      kPtr T d o := by
  rw [Pointer.add_add, abs_toNat d (by decide) 64 (by decide), kPtr, BitVec.ofNat_add]

/-- An entry's start as the steps compute it. -/
theorem kPtr_eq0 {T : Pointer} {d : BitVec 8} :
    T.add (BitVec.ofNat 64 ((BitVec.setWidth 64 (if d.msb = true then -d else d)).toNat * 1600)) =
      kPtr T d 0 := by
  rw [abs_toNat d (by decide) 64 (by decide), kPtr, Nat.add_zero]

/-- A lane pointer moved on inside its entry. -/
theorem kPtr_add {T : Pointer} {d : BitVec 8} {a b : Nat} :
    (kPtr T d a).add (BitVec.ofNat 64 b) = kPtr T d (a + b) := by
  rw [kPtr, kPtr, Pointer.add_add, ← BitVec.ofNat_add, Nat.add_assoc]

/-- One of two lane pointers into one entry. -/
theorem ite_kPtr {c : Prop} [Decidable c] {T : Pointer} {d : BitVec 8} {a b : Nat} :
    (if c then kPtr T d a else kPtr T d b) = kPtr T d (if c then a else b) := by
  split <;> rfl

theorem zext_bound (a : BitVec 8) : (BitVec.setWidth 64 a).toNat * 1600 < 2 ^ 63 := by
  rw [BitVec.toNat_setWidth]; have := a.isLt; omega

theorem sel_bound {p : Prop} [Decidable p] {a b : BitVec 64} {n : Nat} (ha : a.toNat ≤ n)
    (hb : b.toNat ≤ n) : (if p then a else b).toNat ≤ n := by
  split <;> assumption

/-- Where the body at `pos` is `kLaneRun` for lane `j`: running on from `pos` gives `K` if it does
from `pos + 16` with lane `j`'s four `ktab` pointers stored, whatever the intermediates hold. -/
theorem runBodyFrom_kLaneRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {dv av : Dst Γ (.vec 8 8)} {idx : Dst Γ (.bv 64)} {z8 : Dst Γ (.bv 8)} {tab : Dst Γ .ptr}
    {oN oP : Dst Γ (.bv 64)} {sp sm sk sz : Dst Γ .ptr} {d : Dst Γ (.bv 8)} {n : Dst Γ (.bv 1)}
    {a : Dst Γ (.bv 8)} {z : Dst Γ (.bv 64)} {e p m s1 s2 : Dst Γ .ptr} {o : Dst Γ (.bv 64)}
    {k zz : Dst Γ .ptr} {rest : List (Instr Γ)} (j : Fin 8) (pOff mOff zOff : Int)
    {D : Vector (BitVec 8) 8} {T SP SM SK SZ : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        kLaneRun pOff mOff zOff dv av idx z8 tab oN oP sp sm sk sz d n a z e p m s1 s2 o k zz ++
          rest)
    (hR :
      E ⊨ [dv := D,
        av := Vector.ofFn fun i : Fin 8 => if D[i.val].msb = true then -D[i.val] else D[i.val],
        idx := BitVec.ofNat 64 j, z8 := 0#8, tab := T, oN := BitVec.ofNat 64 (960 + 8 * j),
        oP := BitVec.ofNat 64 (640 + 8 * j), sp := SP, sm := SM, sk := SK, sz := SZ])
    (hoff : pOff = 8 * (j : Nat) ∧ mOff = 320 + 8 * (j : Nat) ∧ zOff = 1280 + 8 * (j : Nat))
    (hd :
      [dv.i, av.i, idx.i, z8.i, tab.i, oN.i, oP.i, sp.i, sm.i, sk.i, sz.i, d.i, n.i, a.i, z.i, e.i,
        p.i, m.i, s1.i, s2.i, o.i, k.i, zz.i].Nodup)
    (hT : T.offset = 0#64)
    (hroom : Room S.mem SP 64 ∧ Room S.mem SM 64 ∧ Room S.mem SK 64 ∧ Room S.mem SZ 64)
    (hK :
      ∀ (vd : ⟦.bv 8⟧) (vn : ⟦.bv 1⟧) (va : ⟦.bv 8⟧) (vz : ⟦.bv 64⟧) (ve vp vm vs1 vs2 : ⟦.ptr⟧)
        (vo : ⟦.bv 64⟧) (vk vzz : ⟦.ptr⟧),
        (blk.runBodyFrom
              E[d := vd, n := vn, a := va, z := vz, e := ve, p := vp, m := vm, s1 := vs1,
                s2 := vs2, o := vo, k := vk, zz := vzz]
              (pos + 16)
              { S with
                mem :=
                  (((S.mem.storePtr SP
                            (kPtr T D[j] (if D[j].toInt < 0 then 320 + 8 * j else 8 * j))).storePtr
                        SM (kPtr T D[j] (if D[j].toInt < 0 then 8 * j else 320 + 8 * j))).storePtr
                    SK (kPtr T D[j] (if D[j].toInt < 0 then 960 + 8 * j else 640 + 8 * j))).storePtr
                    SZ (kPtr T D[j] (1280 + 8 * j)) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h1, h2, h3⟩ := hoff
  subst h1 h2 h3
  obtain ⟨r1, r2, r3, r4⟩ := hroom
  have hj : (j : Nat) % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  step_pure [hj]
  step_pure
  step_pure [hj]
  step_pure with z1 hz1
  have hzb : z1.toNat * 1600 < 2 ^ 63 := by rw [hz1]; exact zext_bound _
  step_pure [hzb] with e1 he1
  have heo : ¬e1.offset.uaddOverflow 1600#64 := by
    rw [he1]
    simp only [Pointer.add, hT, BitVec.zero_add, BitVec.uaddOverflow, BitVec.toNat_ofNat,
      decide_eq_true_eq, Nat.mod_eq_of_lt (show z1.toNat * 1600 < 2 ^ 64 by omega)]
    omega
  have hj8 := j.isLt
  step_pure [show (0 : Int) ≤ 8 * ((j : Nat) : Int) by omega,
    show (8 * ((j : Nat) : Int)).toNat = 8 * (j : Nat) by omega] with p1 hp1
  step_pure [show (0 : Int) ≤ 320 + 8 * ((j : Nat) : Int) by omega,
    show (320 + 8 * ((j : Nat) : Int)).toNat = 320 + 8 * (j : Nat) by omega] with m1 hm1
  step_pure
  step_store
  step_pure
  step_store
  step_pure with o1 ho1
  have hob : o1.toNat ≤ 1016 := by
    rw [ho1]
    exact sel_bound (by simp; omega) (by simp; omega)
  step_pure [hob]
  step_store
  step_pure [show (0 : Int) ≤ 1280 + 8 * ((j : Nat) : Int) by omega,
    show (1280 + 8 * ((j : Nat) : Int)).toNat = 1280 + 8 * (j : Nat) by omega]
  step_store
  subst hS hE
  rw [hp1, hm1, ho1, he1, hz1] at *
  simp only [slt_zero_iff, apply_ite (Pointer.add _), kPtr_eq, ite_kPtr] at *
  exact hK _ _ _ _ _ _ _ _ _ _ _ _

/-- Where the body at `pos` is `kLane0Run`: running on from `pos` gives `K` if it does from
`pos + 16` with the digits' magnitudes in `av` and lane `0`'s four `ktab` pointers stored. -/
theorem runBodyFrom_kLane0Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {dv : Dst Γ (.vec 8 8)} {idx : Dst Γ (.bv 64)} {z8 : Dst Γ (.bv 8)} {tab : Dst Γ .ptr}
    {oN oP : Dst Γ (.bv 64)} {sp sm sk sz : Dst Γ .ptr} {d : Dst Γ (.bv 8)} {n : Dst Γ (.bv 1)}
    {av : Dst Γ (.vec 8 8)} {a : Dst Γ (.bv 8)} {z : Dst Γ (.bv 64)} {e m s1 s2 : Dst Γ .ptr}
    {o : Dst Γ (.bv 64)} {k zz : Dst Γ .ptr} {rest : List (Instr Γ)} {D : Vector (BitVec 8) 8}
    {T SP SM SK SZ : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        kLane0Run dv idx z8 tab oN oP sp sm sk sz d n av a z e m s1 s2 o k zz ++ rest)
    (hR :
      E ⊨ [dv := D, idx := 0#64, z8 := 0#8, tab := T, oN := 960#64, oP := 640#64, sp := SP,
        sm := SM, sk := SK, sz := SZ])
    (hd :
      [dv.i, idx.i, z8.i, tab.i, oN.i, oP.i, sp.i, sm.i, sk.i, sz.i, d.i, n.i, av.i, a.i, z.i, e.i,
        m.i, s1.i, s2.i, o.i, k.i, zz.i].Nodup)
    (hT : T.offset = 0#64)
    (hroom : Room S.mem SP 64 ∧ Room S.mem SM 64 ∧ Room S.mem SK 64 ∧ Room S.mem SZ 64)
    (hK :
      ∀ (vd : ⟦.bv 8⟧) (vn : ⟦.bv 1⟧) (va : ⟦.bv 8⟧) (vz : ⟦.bv 64⟧) (ve vm vs1 vs2 : ⟦.ptr⟧)
        (vo : ⟦.bv 64⟧) (vk vzz : ⟦.ptr⟧),
        (blk.runBodyFrom
              E[d := vd, n := vn,
                av := Ty.wrap (Vector.ofFn fun i : Fin 8 =>
                  if D[i.val].msb = true then -D[i.val] else D[i.val]),
                a := va, z := vz, e := ve, m := vm, s1 := vs1, s2 := vs2, o := vo, k := vk,
                zz := vzz]
              (pos + 16)
              { S with
                mem :=
                  (((S.mem.storePtr SP (kPtr T D[0] (if D[0].toInt < 0 then 320 else 0))).storePtr
                        SM (kPtr T D[0] (if D[0].toInt < 0 then 0 else 320))).storePtr
                    SK (kPtr T D[0] (if D[0].toInt < 0 then 960 else 640))).storePtr
                    SZ (kPtr T D[0] 1280) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨r1, r2, r3, r4⟩ := hroom
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with z1 hz1
  have hzb : z1.toNat * 1600 < 2 ^ 63 := by rw [hz1]; exact zext_bound _
  step_pure [hzb] with e1 he1
  have heo : ¬e1.offset.uaddOverflow 1600#64 := by
    rw [he1]
    simp only [Pointer.add, hT, BitVec.zero_add, BitVec.uaddOverflow, BitVec.toNat_ofNat,
      decide_eq_true_eq, Nat.mod_eq_of_lt (show z1.toNat * 1600 < 2 ^ 64 by omega)]
    omega
  step_pure with m1 hm1
  step_pure
  step_store
  step_pure
  step_store
  step_pure with o1 ho1
  have hob : o1.toNat ≤ 960 := by
    rw [ho1]
    exact sel_bound (by decide) (by decide)
  step_pure [hob]
  step_store
  step_pure
  step_store
  subst hS hE
  rw [hm1, ho1, he1, hz1] at *
  simp only [slt_zero_iff, apply_ite (Pointer.add _), kPtr_eq0, kPtr_add, Nat.zero_add,
    ite_kPtr] at *
  exact hK _ _ _ _ _ _ _ _ _ _ _

/-- A `[S]` digit's magnitude times 160 is nonnegative in 32 bits. -/
theorem bmul_msb (a : BitVec 16) :
    (BitVec.setWidth 32 (if a.msb = true then -a else a) * 160#32).msb = false := by
  bv_decide

/-- A `[S]` digit's magnitude times 160, zero-extended: `|a| * 160`, below `2 ^ 23`. -/
theorem bmul_toNat (a : BitVec 16) :
    (BitVec.setWidth 64 (BitVec.setWidth 32 (if a.msb = true then -a else a) * 160#32)).toNat =
      a.toInt.natAbs * 160 := by
  have h := abs_toNat a (by decide) 32 (by decide)
  have hb := abs_le16 a
  rw [BitVec.toNat_setWidth, BitVec.toNat_mul, h]
  simp only [BitVec.toNat_ofNat, Nat.reducePow, Nat.reduceMod]
  generalize a.toInt.natAbs = x at *
  rw [Nat.mod_eq_of_lt (by omega : x * 160 < 4294967296), Nat.mod_eq_of_lt (by omega)]

/-- An `[S]` lane pointer as the steps compute it. -/
theorem bPtr_eq {Tb : Pointer} {a : BitVec 16} {c : Prop} [Decidable c] {k l : Nat}
    (hk : k < 16) (hl : l < 16) :
    (Tb.add (BitVec.setWidth 64 (BitVec.setWidth 32 (if a.msb = true then -a else a) * 160#32))).add
        (BitVec.ofNat 64 ((if c then BitVec.ofNat 64 k else BitVec.ofNat 64 l).toNat * 8)) =
      bPtr Tb a (if c then k else l) := by
  have hz : BitVec.setWidth 64 (BitVec.setWidth 32 (if a.msb = true then -a else a) * 160#32) =
      BitVec.ofNat 64 (a.toInt.natAbs * 160) := by
    apply BitVec.eq_of_toNat_eq
    rw [bmul_toNat, BitVec.toNat_ofNat, Nat.mod_eq_of_lt]
    have := abs_le16 a; omega
  rw [hz, Pointer.add_add, ← BitVec.ofNat_add, bPtr]
  split <;> simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega),
    Nat.mod_eq_of_lt (show l < 2 ^ 64 by omega), Nat.mul_comm 8]

theorem runBodyFrom_bLaneRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {sv : Dst Γ (.vec 8 16)} {mv : Dst Γ (.vec 8 32)} {idx : Dst Γ (.bv 64)} {z16 : Dst Γ (.bv 16)}
    {tb : Dst Γ .ptr} {c5 c0 c15 c10 : Dst Γ (.bv 64)} {sp sm sk : Dst Γ .ptr}
    {d : Dst Γ (.bv 16)} {n : Dst Γ (.bv 1)} {mj : Dst Γ (.bv 32)} {z : Dst Γ (.bv 64)}
    {e : Dst Γ .ptr} {o1 : Dst Γ (.bv 64)} {q1 : Dst Γ .ptr} {o2 : Dst Γ (.bv 64)} {q2 : Dst Γ .ptr}
    {o3 : Dst Γ (.bv 64)} {q3 : Dst Γ .ptr} {rest : List (Instr Γ)} (j : Fin 8)
    {V : Vector (BitVec 16) 8} {Tb SP SM SK : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        bLaneRun sv mv idx z16 tb c5 c0 c15 c10 sp sm sk d n mj z e o1 q1 o2 q2 o3 q3 ++ rest)
    (hR :
      E ⊨ [sv := V, mv := Vector.ofFn fun i : Fin 8 =>
          BitVec.setWidth 32 (if V[i.val].msb = true then -V[i.val] else V[i.val]) * 160#32,
        idx := BitVec.ofNat 64 j, z16 := 0#16, tb := Tb, c5 := 5#64, c0 := 0#64, c15 := 15#64,
        c10 := 10#64, sp := SP, sm := SM, sk := SK])
    (hd :
      [sv.i, mv.i, idx.i, z16.i, tb.i, c0.i, c15.i, c10.i, sp.i, sm.i, sk.i, d.i, n.i, mj.i, z.i,
        e.i, o1.i, q1.i, o2.i, q2.i, o3.i, q3.i].Nodup)
    (hd5 : [c5.i, d.i, n.i, mj.i, z.i, e.i, o1.i, q1.i, o2.i, q2.i, o3.i, q3.i].Nodup)
    (hTb : Tb.offset = 0#64)
    (hroom : Room S.mem SP 64 ∧ Room S.mem SM 64 ∧ Room S.mem SK 64)
    (hK :
      ∀ (vd : ⟦.bv 16⟧) (vn : ⟦.bv 1⟧) (vm : ⟦.bv 32⟧) (vz : ⟦.bv 64⟧) (ve : ⟦.ptr⟧)
        (vo1 : ⟦.bv 64⟧) (vq1 : ⟦.ptr⟧) (vo2 : ⟦.bv 64⟧) (vq2 : ⟦.ptr⟧) (vo3 : ⟦.bv 64⟧)
        (vq3 : ⟦.ptr⟧),
        (blk.runBodyFrom
              E[d := vd, n := vn, mj := vm, z := vz, e := ve, o1 := vo1, q1 := vq1, o2 := vo2,
                q2 := vq2, o3 := vo3, q3 := vq3]
              (pos + 14)
              { S with
                mem :=
                  ((S.mem.storePtr SP (bPtr Tb V[j] (if V[j].toInt < 0 then 5 else 0))).storePtr
                        SM (bPtr Tb V[j] (if V[j].toInt < 0 then 0 else 5))).storePtr
                    SK (bPtr Tb V[j] (if V[j].toInt < 0 then 15 else 10)) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨r1, r2, r3⟩ := hroom
  have hj : (j : Nat) % 18446744073709551616 = j := Nat.mod_eq_of_lt (by omega)
  step_pure [hj]
  step_pure
  step_pure [hj]
  step_pure [bmul_msb] with z1 hz1
  have hzb : z1.toNat < 2 ^ 23 := by
    rw [hz1, bmul_toNat]; have := abs_le16 V[(j : Nat)]; omega
  step_pure [hzb] with e1 he1
  have heo : ¬e1.offset.uaddOverflow 128#64 := by
    rw [he1]
    simp only [Pointer.add, hTb, BitVec.zero_add, BitVec.uaddOverflow, decide_eq_true_eq]
    simp only [BitVec.toNat_ofNat]
    omega
  step_pure with o1v ho1v
  have ho1b : o1v.toNat ≤ 15 := by rw [ho1v]; exact sel_bound (by decide) (by decide)
  step_pure [ho1b]
  step_store
  step_pure with o2v ho2v
  have ho2b : o2v.toNat ≤ 15 := by rw [ho2v]; exact sel_bound (by decide) (by decide)
  step_pure [ho2b]
  step_store
  step_pure with o3v ho3v
  have ho3b : o3v.toNat ≤ 15 := by rw [ho3v]; exact sel_bound (by decide) (by decide)
  step_pure [ho3b]
  step_store
  subst hS hE
  rw [ho1v, ho2v, ho3v, he1, hz1] at *
  simp only [slt_zero_iff, bPtr_eq (k := 5) (l := 0) (by decide) (by decide),
    bPtr_eq (k := 0) (l := 5) (by decide) (by decide),
    bPtr_eq (k := 15) (l := 10) (by decide) (by decide)] at *
  exact hK _ _ _ _ _ _ _ _ _ _ _

theorem runBodyFrom_bLane0Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {sv : Dst Γ (.vec 8 16)} {idx : Dst Γ (.bv 64)} {z16 : Dst Γ (.bv 16)}
    {k160 : Dst Γ (.vec 8 32)}
    {tb : Dst Γ .ptr} {c5 c15 c10 : Dst Γ (.bv 64)} {sp sm sk : Dst Γ .ptr}
    {d : Dst Γ (.bv 16)} {n : Dst Γ (.bv 1)} {av : Dst Γ (.vec 8 16)} {zv mv : Dst Γ (.vec 8 32)}
    {mj : Dst Γ (.bv 32)} {z : Dst Γ (.bv 64)} {e : Dst Γ .ptr} {o1 : Dst Γ (.bv 64)}
    {q1 : Dst Γ .ptr} {o2 : Dst Γ (.bv 64)} {q2 : Dst Γ .ptr} {o3 : Dst Γ (.bv 64)}
    {q3 : Dst Γ .ptr} {rest : List (Instr Γ)} {V : Vector (BitVec 16) 8} {Tb SP SM SK : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        bLane0Run sv idx z16 k160 tb c5 c15 c10 sp sm sk d n av zv mv mj z e o1 q1 o2 q2 o3 q3 ++
          rest)
    (hR :
      E ⊨ [sv := V, idx := 0#64, z16 := 0#16, k160 := Vector.replicate 8 160#32, tb := Tb,
        c5 := 5#64, c15 := 15#64, c10 := 10#64, sp := SP, sm := SM, sk := SK])
    (hd :
      [sv.i, idx.i, z16.i, k160.i, tb.i, c5.i, c15.i, c10.i, sp.i, sm.i, sk.i, d.i, n.i, av.i,
        zv.i, mv.i, mj.i, z.i, e.i, o1.i, q1.i, o2.i, q2.i, o3.i, q3.i].Nodup)
    (hTb : Tb.offset = 0#64)
    (hroom : Room S.mem SP 64 ∧ Room S.mem SM 64 ∧ Room S.mem SK 64)
    (hK :
      ∀ (vd : ⟦.bv 16⟧) (vn : ⟦.bv 1⟧) (va : ⟦.vec 8 16⟧) (vzv : ⟦.vec 8 32⟧) (vm : ⟦.bv 32⟧)
        (vz : ⟦.bv 64⟧) (ve : ⟦.ptr⟧) (vo1 : ⟦.bv 64⟧) (vq1 : ⟦.ptr⟧) (vo2 : ⟦.bv 64⟧)
        (vq2 : ⟦.ptr⟧) (vo3 : ⟦.bv 64⟧) (vq3 : ⟦.ptr⟧),
        (blk.runBodyFrom
              E[d := vd, n := vn, av := va, zv := vzv,
                mv := Ty.wrap (Vector.ofFn fun i : Fin 8 =>
                  BitVec.setWidth 32 (if V[i.val].msb = true then -V[i.val] else V[i.val]) *
                    160#32),
                mj := vm, z := vz, e := ve, o1 := vo1, q1 := vq1, o2 := vo2, q2 := vq2, o3 := vo3,
                q3 := vq3]
              (pos + 17)
              { S with
                mem :=
                  ((S.mem.storePtr SP (bPtr Tb V[0] (if V[0].toInt < 0 then 5 else 0))).storePtr
                        SM (bPtr Tb V[0] (if V[0].toInt < 0 then 0 else 5))).storePtr
                    SK (bPtr Tb V[0] (if V[0].toInt < 0 then 15 else 10)) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨r1, r2, r3⟩ := hroom
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure [bmul_smul, bmul_umul]
  step_pure
  step_pure [bmul_msb] with z1 hz1
  have hzb : z1.toNat < 2 ^ 23 := by
    rw [hz1, bmul_toNat]; have := abs_le16 V[0]; omega
  step_pure [hzb] with e1 he1
  have heo : ¬e1.offset.uaddOverflow 128#64 := by
    rw [he1]
    simp only [Pointer.add, hTb, BitVec.zero_add, BitVec.uaddOverflow, decide_eq_true_eq]
    simp only [BitVec.toNat_ofNat]
    omega
  step_pure with o1v ho1v
  have ho1b : o1v.toNat ≤ 15 := by rw [ho1v]; exact sel_bound (by decide) (by decide)
  step_pure [ho1b]
  step_store
  step_pure with o2v ho2v
  have ho2b : o2v.toNat ≤ 15 := by rw [ho2v]; exact sel_bound (by decide) (by decide)
  step_pure [ho2b]
  step_store
  step_pure with o3v ho3v
  have ho3b : o3v.toNat ≤ 15 := by rw [ho3v]; exact sel_bound (by decide) (by decide)
  step_pure [ho3b]
  step_store
  subst hS hE
  rw [ho1v, ho2v, ho3v, he1, hz1] at *
  simp only [slt_zero_iff, bPtr_eq (k := 5) (l := 0) (by decide) (by decide),
    bPtr_eq (k := 0) (l := 5) (by decide) (by decide),
    bPtr_eq (k := 15) (l := 10) (by decide) (by decide)] at *
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _

/-! ### Writes into the frame -/

/-- `m'` is `m` after writes into the frame from `n` on: the same blocks' bounds and writability,
and below the frame the same memory. -/
def FrameOps (n : Nat) (m m' : MemoryState) : Prop :=
  (∀ p w, InBounds m p w → InBounds m' p w) ∧ (∀ p, Writable m p → Writable m' p) ∧
    m'.eraseFrom n = m.eraseFrom n

theorem FrameOps.refl (n : Nat) (m : MemoryState) : FrameOps n m m :=
  ⟨fun _ _ h => h, fun _ h => h, rfl⟩

theorem FrameOps.storePtr {n : Nat} {m m' : MemoryState} {p x : Pointer} (h : FrameOps n m m')
    (hp : n ≤ p.id.id) : FrameOps n m (m'.storePtr p x) :=
  ⟨fun _ _ hq => (h.1 _ _ hq).storePtr, fun _ hq => (h.2.1 _ hq).storePtr,
    (MemoryState.eraseFrom_storePtr_of_le hp).trans h.2.2⟩

theorem FrameOps.storeLanePoint {n : Nat} {m m' : MemoryState} {p : Pointer} {P : Point}
    (h : FrameOps n m m') (hp : n ≤ p.id.id) : FrameOps n m (m'.storeLanePoint p P) :=
  ⟨fun _ _ hq => (h.1 _ _ hq).storeLanePoint, fun _ hq => (h.2.1 _ hq).storeLanePoint,
    (MemoryState.eraseFrom_storeLanePoint_of_le hp).trans h.2.2⟩

theorem FrameOps.lifetimeStart {n : Nat} {m m' : MemoryState} {p : Pointer} (h : FrameOps n m m')
    (hp : n ≤ p.id.id) : FrameOps n m (m'.lifetimeStart p) :=
  ⟨fun _ _ hq => (h.1 _ _ hq).lifetimeStart, fun _ hq => (h.2.1 _ hq).lifetimeStart,
    (MemoryState.eraseFrom_lifetimeStart_of_le hp).trans h.2.2⟩

theorem FrameOps.lifetimeEnd {n : Nat} {m m' : MemoryState} {p : Pointer} (h : FrameOps n m m')
    (hp : n ≤ p.id.id) : FrameOps n m (m'.lifetimeEnd p) :=
  ⟨fun _ _ hq => (h.1 _ _ hq).lifetimeEnd, fun _ hq => (h.2.1 _ hq).lifetimeEnd,
    (MemoryState.eraseFrom_lifetimeEnd_of_le hp).trans h.2.2⟩

/-- A hand-over's `Base` past writes into the frame, the state `WF` and its counter kept. -/
theorem Call.Base.frameOps {c : Call} {S S' : GlobalState} {M : MemoryState} (h : c.Base S M)
    (hf : FrameOps c.s.alloc.nextFreeBlock S.mem S'.mem) (hwf : S'.WF)
    (ha : S'.alloc = S.alloc) : c.Base S' M := by
  have hsame : S.mem.SameOn S'.mem fun b => b.id < c.s.alloc.nextFreeBlock := by
    have h1 := S.mem.sameOn_eraseFrom c.s.alloc.nextFreeBlock
    have h2 := (S'.mem.sameOn_eraseFrom c.s.alloc.nextFreeBlock).symm
    rw [hf.2.2] at h2
    exact h1.trans h2
  refine ⟨hwf, hsame.globals h.globals, ha ▸ h.frame, fun k hk => hf.1 _ _ (h.slots k hk),
    fun k hk => hf.2.1 _ (h.writable k hk), hf.2.2.trans h.mem, h.tbl_lt, h.idp_lt,
    hsame.fits h.tbl_lt h.tbl_fits, (hsame.readAt h.tbl_lt).trans h.tbl_read,
    hsame.fits h.idp_lt h.idp_fits, (hsame.readAt h.idp_lt).trans h.idp_read⟩

/-! ### Digit rows -/

/-- Bit `i` of packed lanes: bit `i % we` of lane `i / we`. -/
theorem _root_.BitVec.getLsbD_packLanes_lane {we n : Nat} (v : Vector (BitVec we) n) {i : Nat}
    (hi : i < we * n) :
    (BitVec.packLanes v).getLsbD i = (v[i / we]'(Nat.div_lt_of_lt_mul hi)).getLsbD (i % we) := by
  have hwe : 0 < we := Nat.pos_of_ne_zero fun h => by subst h; omega
  have h :=
    congrArg (·.getLsbD 0)
      (BitVec.extractLsb'_packLanes_of_lt v (s := i) (w := 1) (Nat.div_lt_of_lt_mul hi)
        (Nat.mod_lt _ hwe))
  simpa using h

/-- `kd[w]`: window `w`'s `[k]` digits. -/
noncomputable def Call.kdRow (c : Call) (w : Nat) : Vector (BitVec 8) 8 :=
  Vector.ofFn fun j => recode4 (c.kS j) w

/-- `sd[v]`: the `[S]` digits of window `2 v`. -/
noncomputable def Call.sdRow (c : Call) (v : Nat) : Vector (BitVec 16) 8 :=
  Vector.ofFn fun j => recode8 (c.sS j) v

theorem Call.kdBits_row (c : Call) {w : Nat} (hw : w < 64) :
    c.kdBits.extractLsb' (64 * w) 64 = BitVec.packLanes (c.kdRow w) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', hi, decide_true, Bool.true_and, Call.kdBits]
  rw [_root_.BitVec.getLsbD_packLanes_lane, _root_.BitVec.getLsbD_packLanes_lane]
  · simp only [Call.kdRow, Vector.getElem_ofFn, show (64 * w + i) / 8 % 8 = i / 8 by omega,
      show (64 * w + i) / 8 / 8 = w by omega, show (64 * w + i) % 8 = i % 8 by omega]
  all_goals omega

theorem Call.sdBits_row (c : Call) {v : Nat} (hv : v < 32) :
    c.sdBits.extractLsb' (128 * v) 128 = BitVec.packLanes (c.sdRow v) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [BitVec.getLsbD_extractLsb', hi, decide_true, Bool.true_and, Call.sdBits]
  rw [_root_.BitVec.getLsbD_packLanes_lane, _root_.BitVec.getLsbD_packLanes_lane]
  · simp only [Call.sdRow, Vector.getElem_ofFn, show (128 * v + i) / 16 % 8 = i / 16 by omega,
      show (128 * v + i) / 16 / 8 = v by omega, show (128 * v + i) % 16 = i % 16 by omega]
  all_goals omega

/-- A slice of a known read at a block's start: its bits there, known. -/
theorem slice_read {m : MemoryState} {p : Pointer} {N : Nat} {X : BitVec N} (hf : Fits m p N)
    (hr : m.readAt p N = X) (hoff : p.offset = 0) (hN : N < 2 ^ 64) {k w : Nat}
    (hk : 8 * k + w ≤ N) :
    Fits m (p.add (BitVec.ofNat 64 k)) w ∧
      m.readAt (p.add (BitVec.ofNat 64 k)) w = X.extractLsb' (8 * k) w := by
  have hk' : (BitVec.ofNat 64 k).toNat = k := by
    rw [BitVec.toNat_ofNat]; exact Nat.mod_eq_of_lt (by omega)
  have hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp [BitVec.uaddOverflow, hoff]; omega
  refine ⟨hf.add_of_le hov (by omega), ?_⟩
  rw [MemoryState.readAt_add_of_readAt hf.inBounds hov (by omega) hr, hk', Nat.mul_comm k 8]

/-- Window `w`'s `[k]` digits, at `kd[w]`. -/
theorem kd_row {c : Call} {m : MemoryState} (hf : Fits m (c.s.slot 0) 4096)
    (hr : m.readAt (c.s.slot 0) 4096 = c.kdBits) {w : Nat} (hw : w < 64) :
    Fits m ((c.s.slot 0).add (BitVec.ofNat 64 (w * 8))) 64 ∧
      m.readAt ((c.s.slot 0).add (BitVec.ofNat 64 (w * 8))) 64 = BitVec.packLanes (c.kdRow w) := by
  obtain ⟨h1, h2⟩ := slice_read hf hr rfl (by decide) (k := w * 8) (w := 64) (by omega)
  refine ⟨h1, h2.trans ?_⟩
  rw [show 8 * (w * 8) = 64 * w by omega]
  exact c.kdBits_row hw

/-- `t` of a point stored where there is room. -/
theorem _root_.MLIR.MemoryState.readFe_storeLanePoint_t {m : MemoryState} {p : Pointer}
    {P : Point} (h : m.LanePointRoom p) : (m.storeLanePoint p P).readFe (p.add 960#64) = P.t := by
  simp only [MemoryState.storeLanePoint]
  rw [MemoryState.readFe_storeFe_self h.room_t.storeFe.storeFe.storeFe]




/-- The `[S]` digits of window `2 v`, at `sd[v]`. -/
theorem sd_row {c : Call} {m : MemoryState} (hf : Fits m (c.s.slot 1) 4096)
    (hr : m.readAt (c.s.slot 1) 4096 = c.sdBits) {v : Nat} (hv : v < 32) :
    Fits m ((c.s.slot 1).add (BitVec.ofNat 64 (v * 16))) 128 ∧
      m.readAt ((c.s.slot 1).add (BitVec.ofNat 64 (v * 16))) 128 =
        BitVec.packLanes (c.sdRow v) := by
  obtain ⟨h1, h2⟩ := slice_read hf hr rfl (by decide) (k := v * 16) (w := 128) (by omega)
  refine ⟨h1, h2.trans ?_⟩
  rw [show 8 * (v * 16) = 128 * v by omega]
  exact c.sdBits_row hv


/-- Lane `j`'s `y + x` pointer into the base table for digits `V`: `y - x` for a negative digit. -/
def bP (Tb : Pointer) (V : Vector (BitVec 16) 8) (j : Fin 8) : Pointer :=
  bPtr Tb V[j.val] (if V[j.val].toInt < 0 then 5 else 0)

/-- Lane `j`'s `y - x` pointer: `y + x` for a negative digit. -/
def bM (Tb : Pointer) (V : Vector (BitVec 16) 8) (j : Fin 8) : Pointer :=
  bPtr Tb V[j.val] (if V[j.val].toInt < 0 then 0 else 5)

/-- Lane `j`'s `2dt` pointer: `-2dt` for a negative digit. -/
def bK (Tb : Pointer) (V : Vector (BitVec 16) 8) (j : Fin 8) : Pointer :=
  bPtr Tb V[j.val] (if V[j.val].toInt < 0 then 15 else 10)

/-- The `[S]` operands, offsets `o j` into entries `|V[j]|`, are the base table's qwords. -/
theorem bPickFit {m : MemoryState} {c : Call} (hf : Fits m c.tbl 165120)
    {V : Vector (BitVec 16) 8} (hV : ∀ j : Fin 8, V[j.val].toInt.natAbs ≤ 128) {o : Fin 8 → Nat}
    (ho : ∀ j : Fin 8, o j ≤ 15) :
    m.PickFit 0#32 (fun j => bPtr c.tbl V[j.val] (o j)) 1#64 := by
  simp only [MemoryState.PickFit]
  intro i hi
  have hs : (1#64 : BitVec 64).toNat = 1 := rfl
  rw [hs, Nat.mul_one]
  have hT : c.tbl.offset = 0#64 := rfl
  refine ⟨by omega, fun j => ?_⟩
  have := hV j; have := ho j
  dsimp only [bPtr]
  refine ⟨?_, ?_⟩
  · simp only [Pointer.add, hT, BitVec.zero_add, BitVec.uaddOverflow, BitVec.toNat_ofNat,
      decide_eq_true_eq]
    rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
    omega
  · rw [Pointer.add_add, ← BitVec.ofNat_add]
    refine hf.add_of_le ?_ ?_
    · simp only [hT, BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
      rw [Nat.mod_eq_of_lt (by omega)]
      omega
    · simp only [BitVec.toNat_ofNat]
      rw [Nat.mod_eq_of_lt (by omega)]
      omega

theorem bP_fit {m : MemoryState} {c : Call} (hf : Fits m c.tbl 165120)
    {V : Vector (BitVec 16) 8} (hV : ∀ j : Fin 8, V[j.val].toInt.natAbs ≤ 128) :
    m.PickFit 0#32 (bP c.tbl V) 1#64 :=
  bPickFit hf hV fun j => by split <;> omega

theorem bM_fit {m : MemoryState} {c : Call} (hf : Fits m c.tbl 165120)
    {V : Vector (BitVec 16) 8} (hV : ∀ j : Fin 8, V[j.val].toInt.natAbs ≤ 128) :
    m.PickFit 0#32 (bM c.tbl V) 1#64 :=
  bPickFit hf hV fun j => by split <;> omega

theorem bK_fit {m : MemoryState} {c : Call} (hf : Fits m c.tbl 165120)
    {V : Vector (BitVec 16) 8} (hV : ∀ j : Fin 8, V[j.val].toInt.natAbs ≤ 128) :
    m.PickFit 0#32 (bK c.tbl V) 1#64 :=
  bPickFit hf hV fun j => by split <;> omega

/-! ### The picked operands -/

/-- `ktab`'s qword `q`. -/
theorem Call.tab_qword (c : Call) {q : Nat} (hq : q < 1800) :
    c.tabBits.extractLsb' (64 * q) 64 = c.tabQword q := by
  have h := BitVec.extractLsb'_packLanes (Vector.ofFn fun q : Fin 1800 => c.tabQword q) q hq
  rw [Vector.getElem_ofFn, Nat.mul_comm q 64] at h
  exact h

/-- Lane `j`'s limb `i` of component `cm` (`y + x`, `y - x`, `2dt`, `-2dt`, `z`) of entry `|d|`,
read from `ktab`. -/
theorem kLimb {m : MemoryState} {c : Call} (hf : Fits m (c.s.slot 3) (64 * 1800))
    (hr : m.readAt (c.s.slot 3) (64 * 1800) = c.tabBits) {d : BitVec 8} (hd : d.toInt.natAbs ≤ 8)
    {cm o : Nat} (hcm : cm < 5) (j : Fin 8) (ho : o = 320 * cm + 8 * j) (i : Fin 5) :
    m.readAt ((kPtr (c.s.slot 3) d o).add (BitVec.ofNat 64 (8 * (8 * i)))) 64 =
      (#v[(c.tab d.toInt.natAbs).p, (c.tab d.toInt.natAbs).m, (c.tab d.toInt.natAbs).k,
        (c.tab d.toInt.natAbs).nk, (c.tab d.toInt.natAbs).z][cm]'hcm).lane j i := by
  obtain ⟨q, hq⟩ : ∃ q, q = 200 * d.toInt.natAbs + 40 * cm + 8 * i + j := ⟨_, rfl⟩
  have hq' : q < 1800 := by omega
  rw [kPtr, Pointer.add_add, ← BitVec.ofNat_add,
    show d.toInt.natAbs * 1600 + o + 8 * (8 * i) = 8 * q by omega]
  obtain ⟨_, h⟩ := slice_read hf hr rfl (by decide) (k := 8 * q) (w := 64) (by omega)
  rw [h, show 8 * (8 * q) = 64 * q by omega, c.tab_qword hq', Call.tabQword]
  have e1 : q / 200 = d.toInt.natAbs := by omega
  have e2 : q % 200 / 40 = cm := by omega
  have e3 : (⟨q % 8, by omega⟩ : Fin 8) = j := Fin.ext (by simp only; omega)
  have e4 : (⟨q % 40 / 8, by omega⟩ : Fin 5) = i := Fin.ext (by simp only; omega)
  simp only [e1, e2, e3, e4]

/-- A picked field element, limbs `8` qwords apart, from its lanes' limbs. -/
theorem pickFe_eight {m : MemoryState} {src : Fin 8 → Pointer} {F : Fin 8 → Fin 5 → BitVec 64}
    (h : ∀ (j : Fin 8) (i : Fin 5),
      m.readAt ((src j).add (BitVec.ofNat 64 (8 * (8 * i)))) 64 = F j i) :
    m.pickFe src 8#64 = Fe.ofLanes F := by
  simp only [MemoryState.pickFe, MemoryState.pickLimb, Fe.ofLanes]
  congr 1 <;> congr 1 <;> funext j
  · exact h j 0
  · exact h j 1
  · exact h j 2
  · exact h j 3
  · exact h j 4

/-- The `[k]` operands picked from `ktab` (`T`, holding `c.tabBits`): `selK`'s. -/
theorem kPick_eq {m : MemoryState} {c : Call} (hf : Fits m (c.s.slot 3) (64 * 1800))
    (hr : m.readAt (c.s.slot 3) (64 * 1800) = c.tabBits) {D : Vector (BitVec 8) 8}
    (hD : ∀ j : Fin 8, D[j.val].toInt.natAbs ≤ 8) :
    m.pickFe (kP (c.s.slot 3) D) 8#64 = (selK c.tab fun j => D[j.val]).1 ∧
      m.pickFe (kM (c.s.slot 3) D) 8#64 = (selK c.tab fun j => D[j.val]).2.1 ∧
      m.pickFe (kK (c.s.slot 3) D) 8#64 = (selK c.tab fun j => D[j.val]).2.2.1 ∧
      m.pickFe (kZ (c.s.slot 3) D) 8#64 = (selK c.tab fun j => D[j.val]).2.2.2 := by
  simp only [selK]
  refine ⟨pickFe_eight fun j i => ?_, pickFe_eight fun j i => ?_, pickFe_eight fun j i => ?_,
    pickFe_eight fun j i => ?_⟩
  · by_cases hn : D[j.val].toInt < 0
    · simp only [kP, hn, decide_true, ↓reduceIte]
      rw [kLimb hf hr (hD j) (o := 320 + 8 * j.val) (cm := 1) (by decide) j (by omega)]; rfl
    · simp only [kP, hn, decide_false, ↓reduceIte]
      rw [kLimb hf hr (hD j) (o := 8 * j.val) (cm := 0) (by decide) j (by omega)]; rfl
  · by_cases hn : D[j.val].toInt < 0
    · simp only [kM, hn, decide_true, ↓reduceIte]
      rw [kLimb hf hr (hD j) (o := 8 * j.val) (cm := 0) (by decide) j (by omega)]; rfl
    · simp only [kM, hn, decide_false, ↓reduceIte]
      rw [kLimb hf hr (hD j) (o := 320 + 8 * j.val) (cm := 1) (by decide) j (by omega)]; rfl
  · by_cases hn : D[j.val].toInt < 0
    · simp only [kK, hn, decide_true, ↓reduceIte]
      rw [kLimb hf hr (hD j) (o := 960 + 8 * j.val) (cm := 3) (by decide) j (by omega)]; rfl
    · simp only [kK, hn, decide_false, ↓reduceIte]
      rw [kLimb hf hr (hD j) (o := 640 + 8 * j.val) (cm := 2) (by decide) j (by omega)]; rfl
  · rw [kZ, kLimb hf hr (hD j) (o := 1280 + 8 * j.val) (cm := 4) (by decide) j (by omega)]; rfl

/-- A picked field element, limbs adjacent, from its lanes' limbs. -/
theorem pickFe_one {m : MemoryState} {src : Fin 8 → Pointer} {F : Fin 8 → Fin 5 → BitVec 64}
    (h : ∀ (j : Fin 8) (i : Fin 5), m.readAt ((src j).add (BitVec.ofNat 64 (8 * i))) 64 = F j i) :
    m.pickFe src 1#64 = Fe.ofLanes F := by
  simp only [MemoryState.pickFe, MemoryState.pickLimb, Fe.ofLanes]
  congr 1 <;> congr 1 <;> funext j
  · exact h j 0
  · exact h j 1
  · exact h j 2
  · exact h j 3
  · exact h j 4

/-- Lane `j`'s limb `i` at offset `o` of the fixed-base table's entry `|v|`. -/
theorem bLimb {m : MemoryState} {c : Call} (hf : Fits m c.tbl 165120)
    (hr :
      m.readAt c.tbl 165120 =
        Ty.flatBits _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table.lit (hw := rfl))
    {v : BitVec 16} (hv : v.toInt.natAbs ≤ 128) {o : Nat} (ho : o ≤ 15) (i : Fin 5) :
    m.readAt ((bPtr c.tbl v o).add (BitVec.ofNat 64 (8 * i))) 64 =
      baseLimbs lc.tbl v.toInt.natAbs o i := by
  obtain ⟨q, hq⟩ : ∃ q, q = 20 * v.toInt.natAbs + o + i := ⟨_, rfl⟩
  have hq' : q < 2580 := by omega
  have hs : (Ty.bv 64).stride = 64 := rfl
  have hw : (Ty.bv 64).width = 64 := rfl
  rw [bPtr, Pointer.add_add, ← BitVec.ofNat_add,
    show v.toInt.natAbs * 160 + 8 * o + 8 * i = 8 * q by omega]
  obtain ⟨_, h⟩ := slice_read hf hr rfl (by decide) (k := 8 * q) (w := 64) (by omega)
  rw [h, Ty.flatBits_eq]
  refine BitVec.extractLsb'_cast.trans ?_
  rw [Ty.extractLsb'_flattenRaw_array _ (by rw [hs]; omega) (by rw [hs, hw]; omega)]
  simp only [hs, show 8 * (8 * q) = 64 * q by omega, Nat.mul_mod_right,
    Nat.mul_div_cancel_left _ (by decide : 0 < 64), Ty.extractLsb'_flattenRaw_bv,
    BitVec.extractLsb'_eq_self, baseLimbs, laneConsts, x8Tbl, ← hq, hq', dite_true]

/-- The `[S]` operands picked from the base table: `selB`'s. -/
theorem bPick_eq {m : MemoryState} {c : Call} (hf : Fits m c.tbl 165120)
    (hr :
      m.readAt c.tbl 165120 =
        Ty.flatBits _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table.lit (hw := rfl))
    {V : Vector (BitVec 16) 8} (hV : ∀ j : Fin 8, V[j.val].toInt.natAbs ≤ 128) :
    m.pickFe (bP c.tbl V) 1#64 = (selB lc.tbl fun j => V[j.val]).1 ∧
      m.pickFe (bM c.tbl V) 1#64 = (selB lc.tbl fun j => V[j.val]).2.1 ∧
      m.pickFe (bK c.tbl V) 1#64 = (selB lc.tbl fun j => V[j.val]).2.2 := by
  simp only [selB]
  refine ⟨pickFe_one fun j i => ?_, pickFe_one fun j i => ?_, pickFe_one fun j i => ?_⟩
  · rw [bP, bLimb hf hr (hV j) (by split <;> omega)]
    by_cases hn : V[j.val].toInt < 0 <;> simp [hn]
  · rw [bM, bLimb hf hr (hV j) (by split <;> omega)]
    by_cases hn : V[j.val].toInt < 0 <;> simp [hn]
  · rw [bK, bLimb hf hr (hV j) (by split <;> omega)]
    by_cases hn : V[j.val].toInt < 0 <;> simp [hn]

/-- A nibble is at most 15. -/
theorem nib_le (s : BitVec 256) (w : Nat) : (nib s w).toNat ≤ 15 := by
  rw [nib, BitVec.toNat_and]
  exact Nat.and_le_right

/-- A byte is at most 255. -/
theorem byte_le (s : BitVec 256) (w : Nat) : (byte s w).toNat ≤ 255 := by
  rw [byte, BitVec.toNat_and]
  exact Nat.and_le_right

/-- `fd_ed25519_lane_recode4`'s carry is `0` or `1`. -/
theorem carry4_le (s : BitVec 256) : ∀ w, (carry4 s w).toNat ≤ 1
  | 0 => by simp [carry4]
  | w + 1 => by
    have h1 := nib_le s w
    have h2 := carry4_le s w
    rw [carry4]
    generalize nib s w = a at *
    generalize carry4 s w = b at *
    obtain ⟨k, hk, rfl⟩ : ∃ k, k ≤ 15 ∧ a = BitVec.ofNat 32 k := ⟨a.toNat, h1, by simp⟩
    obtain ⟨l, hl, rfl⟩ : ∃ l, l ≤ 1 ∧ b = BitVec.ofNat 32 l := ⟨b.toNat, h2, by simp⟩
    revert k l
    decide

/-- `fd_ed25519_lane_recode8`'s carry is `0` or `1`. -/
theorem carry8_le (s : BitVec 256) : ∀ w, (carry8 s w).toNat ≤ 1
  | 0 => by simp [carry8]
  | w + 1 => by
    have h1 := byte_le s w
    have h2 := carry8_le s w
    rw [carry8]
    generalize byte s w = a at *
    generalize carry8 s w = b at *
    obtain ⟨k, hk, rfl⟩ : ∃ k, k ≤ 255 ∧ a = BitVec.ofNat 32 k := ⟨a.toNat, h1, by simp⟩
    obtain ⟨l, hl, rfl⟩ : ∃ l, l ≤ 1 ∧ b = BitVec.ofNat 32 l := ⟨b.toNat, h2, by simp⟩
    revert k l
    decide +kernel

/-- A `[k]` digit is at most `8` in magnitude. -/
theorem recode4_le (s : BitVec 256) (w : Nat) : (recode4 s w).toInt.natAbs ≤ 8 := by
  have h1 := nib_le s w
  have h2 := carry4_le s w
  unfold recode4
  generalize nib s w = a at *
  generalize carry4 s w = b at *
  obtain ⟨k, hk, rfl⟩ : ∃ k, k ≤ 15 ∧ a = BitVec.ofNat 32 k := ⟨a.toNat, h1, by simp⟩
  obtain ⟨l, hl, rfl⟩ : ∃ l, l ≤ 1 ∧ b = BitVec.ofNat 32 l := ⟨b.toNat, h2, by simp⟩
  revert k l
  decide

/-- A `[S]` digit is at most `128` in magnitude. -/
theorem recode8_le (s : BitVec 256) (w : Nat) : (recode8 s w).toInt.natAbs ≤ 128 := by
  have h1 := byte_le s w
  have h2 := carry8_le s w
  unfold recode8
  generalize byte s w = a at *
  generalize carry8 s w = b at *
  obtain ⟨k, hk, rfl⟩ : ∃ k, k ≤ 255 ∧ a = BitVec.ofNat 32 k := ⟨a.toNat, h1, by simp⟩
  obtain ⟨l, hl, rfl⟩ : ∃ l, l ≤ 1 ∧ b = BitVec.ofNat 32 l := ⟨b.toNat, h2, by simp⟩
  revert k l
  decide +kernel

/-- Window `w`'s `[k]` digits are at most `8` in magnitude. -/
theorem kdRow_le (c : Call) (w : Nat) (j : Fin 8) : (c.kdRow w)[j.val].toInt.natAbs ≤ 8 := by
  simp only [Call.kdRow, Vector.getElem_ofFn]
  exact recode4_le _ _

/-- The `[S]` digits are at most `128` in magnitude. -/
theorem sdRow_le (c : Call) (v : Nat) (j : Fin 8) : (c.sdRow v)[j.val].toInt.natAbs ≤ 128 := by
  simp only [Call.sdRow, Vector.getElem_ofFn]
  exact recode8_le _ _

/-! ### A window's parts -/

/-- Four doublings, `t` only by the last. -/
def dbl4 (P : Point) : Point :=
  let P1 := P.dbl false P.t
  let P2 := P1.dbl false P1.t
  let P3 := P2.dbl false P2.t
  P3.dbl true P3.t

/-- Window `w`'s `[k]` add on `acc`. -/
noncomputable def Call.kadd (c : Call) (w : Nat) (P : Point) : Point :=
  let q := selK c.tab fun j => recode4 (c.kS j) w
  P.addQ q.1 q.2.1 q.2.2.1 q.2.2.2 false (w % 2 = 0) P.t

/-- Window `w`'s `[S]` add on `acc` (even `w`). -/
noncomputable def Call.sadd (c : Call) (w : Nat) (P : Point) : Point :=
  let b := selB lc.tbl fun j => recode8 (c.sS j) (w / 2)
  P.addQ b.1 b.2.1 b.2.2 Fe.one true false P.t

/-- Window `w` past its doublings: the `[k]` add, at even `w` the `[S]` add. -/
noncomputable def Call.wtail (c : Call) (w : Nat) (P : Point) : Point :=
  if w % 2 = 0 then c.sadd w (c.kadd w P) else c.kadd w P

/-- A window, as its doublings then `wtail`. -/
theorem window_eq (c : Call) (w : Nat) (P : Point) :
    window c.tab lc.tbl c.kS c.sS w P = c.wtail w (if w = 63 then P else dbl4 P) := by
  unfold window
  by_cases h : w = 63 <;> by_cases h2 : w % 2 = 0 <;>
    simp [h, h2, Call.wtail, Call.kadd, Call.sadd, dbl4]

end

end MLIR.Firedancer.Lane.VerifyX8
