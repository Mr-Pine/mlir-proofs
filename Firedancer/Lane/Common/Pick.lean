module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Mem

/-! `fd_ed25519_lane_pick`: the per-lane operands it reads, by `rows` loads or broadcasts, and the
instruction runs `fd_ed25519_lane_point_add_sel` inlines it as, stepped by `step_pattern`. -/

namespace MLIR

@[expose] public section

open Firedancer.Avx512 Firedancer.Lane

/-- A picked limb: lane `j` the qword `k` qwords past `src j`. -/
def MemoryState.pickLimb (m : MemoryState) (src : Fin 8 → Pointer) (k : Nat) : Wwl :=
  Vector.ofFn fun j => m.readAt ((src j).add (BitVec.ofNat 64 (8 * k))) 64

/-- Lanes `0 … 3` of a picked limb. -/
def MemoryState.pickLo (m : MemoryState) (src : Fin 8 → Pointer) (k : Nat) : Vector (BitVec 64) 4 :=
  Vector.ofFn fun j : Fin 4 => m.readAt ((src (j.castAdd 4)).add (BitVec.ofNat 64 (8 * k))) 64

/-- Lanes `4 … 7` of a picked limb. -/
def MemoryState.pickHi (m : MemoryState) (src : Fin 8 → Pointer) (k : Nat) : Vector (BitVec 64) 4 :=
  Vector.ofFn fun j : Fin 4 => m.readAt ((src (j.natAdd 4)).add (BitVec.ofNat 64 (8 * k))) 64

/-- The field element `fd_ed25519_lane_point_add_sel` picks: limb `i` `i * stride` qwords on. -/
def MemoryState.pickFe (m : MemoryState) (src : Fin 8 → Pointer) (stride : BitVec 64) : Fe :=
  ⟨m.pickLimb src 0, m.pickLimb src stride.toNat, m.pickLimb src (2 * stride.toNat),
    m.pickLimb src (3 * stride.toNat), m.pickLimb src (4 * stride.toNat)⟩

/-- The array of eight pointers at `a` holds `src`. -/
def MemoryState.PtrArray (m : MemoryState) (a : Pointer) (src : Fin 8 → Pointer) : Prop :=
  ¬a.offset.uaddOverflow 64#64 ∧ InBounds m a 512 ∧
    ∀ j : Fin 8, m.loadPtr (a.add (BitVec.ofNat 64 (8 * j))) = .value (src j)

/-! ### Operands that fit -/

/-- What `fd_ed25519_lane_pick( src, k, 1 )` reads is known: lane `j`'s qword `k` qwords past
`src j`, and the 256 bits there for `j = 0, 4`; `src j` is `8 (j % 4)` bytes into its block, and
the offsets do not wrap. -/
def MemoryState.RowsAt (m : MemoryState) (src : Fin 8 → Pointer) (k : Nat) : Prop :=
  8 * k < 2 ^ 63 ∧
    (∀ j : Fin 8, ¬(src j).offset.uaddOverflow (BitVec.ofNat 64 (8 * k)) ∧
      8 * (j.val % 4) ≤ ((src j).add (BitVec.ofNat 64 (8 * k))).offset.toNat ∧
        Fits m ((src j).add (BitVec.ofNat 64 (8 * k))) 64) ∧
    Fits m ((src 0).add (BitVec.ofNat 64 (8 * k))) 256 ∧
      Fits m ((src 4).add (BitVec.ofNat 64 (8 * k))) 256

/-- What `fd_ed25519_lane_pick( src, k, 0 )` reads is known: lane `j`'s qword `k` qwords past
`src j`; the offsets do not wrap. -/
def MemoryState.BcastAt (m : MemoryState) (src : Fin 8 → Pointer) (k : Nat) : Prop :=
  8 * k < 2 ^ 63 ∧
    ∀ j : Fin 8, ¬(src j).offset.uaddOverflow (BitVec.ofNat 64 (8 * k)) ∧
      Fits m ((src j).add (BitVec.ofNat 64 (8 * k))) 64

/-- Limbs `0 … 4`, `stride` qwords apart, are `rows` operands. -/
def MemoryState.RowsFit (m : MemoryState) (src : Fin 8 → Pointer) (stride : BitVec 64) : Prop :=
  ∀ i < 5, m.RowsAt src (i * stride.toNat)

/-- Limbs `0 … 4`, `stride` qwords apart, are known, to broadcast. -/
def MemoryState.BcastFit (m : MemoryState) (src : Fin 8 → Pointer) (stride : BitVec 64) : Prop :=
  ∀ i < 5, m.BcastAt src (i * stride.toNat)

/-- The operands `src`, limbs `stride` qwords apart, as `fd_ed25519_lane_pick( src, off, rows )`
reads them. -/
def MemoryState.PickFit (m : MemoryState) (rows : BitVec 32) (src : Fin 8 → Pointer)
    (stride : BitVec 64) : Prop :=
  if rows = 0 then m.BcastFit src stride else m.RowsFit src stride

theorem MemoryState.PickFit.rows {m : MemoryState} {rows : BitVec 32} {src : Fin 8 → Pointer}
    {stride : BitVec 64} (h : m.PickFit rows src stride) (hr : rows ≠ 0) :
    m.RowsFit src stride := by
  simp only [PickFit, hr, ↓reduceIte] at h
  exact h

theorem MemoryState.PickFit.bcast {m : MemoryState} {rows : BitVec 32} {src : Fin 8 → Pointer}
    {stride : BitVec 64} (h : m.PickFit rows src stride) (hr : rows = 0) :
    m.BcastFit src stride := by
  subst hr
  simpa only [PickFit, ↓reduceIte] using h

/-- Limb `i`'s operands, `k = i * stride` qwords on. -/
theorem MemoryState.RowsFit.at {m : MemoryState} {src : Fin 8 → Pointer} {stride : BitVec 64}
    (h : m.RowsFit src stride) (i k : Nat) (hk : k = i * stride.toNat) (hi : i < 5 := by decide) :
    m.RowsAt src k :=
  hk ▸ h i hi

/-- Limb `i`'s operands, `k = i * stride` qwords on. -/
theorem MemoryState.BcastFit.at {m : MemoryState} {src : Fin 8 → Pointer} {stride : BitVec 64}
    (h : m.BcastFit src stride) (i k : Nat) (hk : k = i * stride.toNat) (hi : i < 5 := by decide) :
    m.BcastAt src k :=
  hk ▸ h i hi

/-- The stride of operands that fit is below `2 ^ 58`. -/
theorem MemoryState.PickFit.stride_lt {m : MemoryState} {rows : BitVec 32}
    {src : Fin 8 → Pointer} {stride : BitVec 64} (h : m.PickFit rows src stride) :
    stride.toNat < 2 ^ 58 := by
  by_cases hr : rows = 0
  · have := ((h.bcast hr) 4 (by decide)).1
    omega
  · have := ((h.rows hr) 4 (by decide)).1
    omega

/-- An offset plus `n`, below `2 ^ 64`. -/
theorem Pointer.offset_toNat_add_ofNat {P : Pointer} {n : Nat} (h : P.offset.toNat + n < 2 ^ 64) :
    (P.add (BitVec.ofNat 64 n)).offset.toNat = P.offset.toNat + n := by
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : n < 2 ^ 64), Nat.mod_eq_of_lt h]

/-- `rows` operands from `verify_x8`'s table layout: `src j` is qword `j` of a row of 8 qwords at
`row j`, known `k` qwords on. -/
theorem MemoryState.RowsAt.of_rows {m : MemoryState} {src row : Fin 8 → Pointer} {k : Nat}
    (hsrc : ∀ j, src j = (row j).add (BitVec.ofNat 64 (8 * j))) (hk : 8 * k < 2 ^ 63)
    (hov : ∀ j, ¬(row j).offset.uaddOverflow (BitVec.ofNat 64 (8 * k + 64)))
    (hf : ∀ j, Fits m ((row j).add (BitVec.ofNat 64 (8 * k))) 512) : m.RowsAt src k := by
  have hlt (j : Fin 8) : (row j).offset.toNat + (8 * k + 64) < 2 ^ 64 := by
    have := hov j
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq] at this
    omega
  -- `src j` `k` qwords on, as `row j` `k` qwords on then `j` qwords on
  have hpt (j : Fin 8) : (src j).add (BitVec.ofNat 64 (8 * k)) =
      ((row j).add (BitVec.ofNat 64 (8 * k))).add (BitVec.ofNat 64 (8 * j)) := by
    rw [hsrc, Pointer.add_add, Pointer.add_add, BitVec.add_comm]
  have hoff (j : Fin 8) (n : Nat) (hn : n ≤ 64) :
      ¬((row j).add (BitVec.ofNat 64 (8 * k))).offset.uaddOverflow (BitVec.ofNat 64 n) := by
    have := hlt j
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, BitVec.toNat_ofNat,
      Pointer.offset_toNat_add_ofNat (by omega : (row j).offset.toNat + 8 * k < 2 ^ 64)]
    omega
  refine ⟨hk, fun j => ⟨?_, ?_, ?_⟩, ?_, ?_⟩
  · have := hlt j
    rw [hsrc]
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, BitVec.toNat_ofNat,
      Pointer.offset_toNat_add_ofNat (by omega : (row j).offset.toNat + 8 * j < 2 ^ 64)]
    omega
  · have := hlt j
    rw [hpt,
      Pointer.offset_toNat_add_ofNat (by rw [Pointer.offset_toNat_add_ofNat (by omega)]; omega),
      Pointer.offset_toNat_add_ofNat (by omega)]
    omega
  · rw [hpt]
    exact (hf j).add_of_le (hoff j _ (by omega)) (by simp; omega)
  · rw [hpt]
    exact (hf 0).add_of_le (w := 256) (hoff 0 _ (by omega)) (by simp)
  · rw [hpt]
    exact (hf 4).add_of_le (w := 256) (hoff 4 _ (by omega)) (by simp)

/-! ### Lanes -/

/-- Lanes `1 … 3` set. -/
theorem _root_.Vector.set_set_set_eq {L : Vector α 4} {x1 x2 x3 : α} (h1 : 1 < 4) (h2 : 2 < 4)
    (h3 : 3 < 4) : ((L.set 1 x1 h1).set 2 x2 h2).set 3 x3 h3 = #v[L[0], x1, x2, x3] := by
  apply Vector.ext
  intro i hi
  rcases i with _ | _ | _ | _ | i
  all_goals simp
  omega

/-- Lanes `0 … 3` set. -/
theorem _root_.Vector.set_set_set_set_eq {z : Vector α 4} {x0 x1 x2 x3 : α} (h0 : 0 < 4)
    (h1 : 1 < 4) (h2 : 2 < 4) (h3 : 3 < 4) :
    (((z.set 0 x0 h0).set 1 x1 h1).set 2 x2 h2).set 3 x3 h3 = #v[x0, x1, x2, x3] := by
  apply Vector.ext
  intro i hi
  rcases i with _ | _ | _ | _ | i
  all_goals simp
  omega

theorem MemoryState.pickLo_eq {m : MemoryState} {src : Fin 8 → Pointer} {k : Nat} :
    m.pickLo src k =
      #v[m.readAt ((src 0).add (BitVec.ofNat 64 (8 * k))) 64,
        m.readAt ((src 1).add (BitVec.ofNat 64 (8 * k))) 64,
        m.readAt ((src 2).add (BitVec.ofNat 64 (8 * k))) 64,
        m.readAt ((src 3).add (BitVec.ofNat 64 (8 * k))) 64] := by
  apply Vector.ext
  intro i hi
  rcases i with _ | _ | _ | _ | i
  all_goals simp [pickLo]
  omega

theorem MemoryState.pickHi_eq {m : MemoryState} {src : Fin 8 → Pointer} {k : Nat} :
    m.pickHi src k =
      #v[m.readAt ((src 4).add (BitVec.ofNat 64 (8 * k))) 64,
        m.readAt ((src 5).add (BitVec.ofNat 64 (8 * k))) 64,
        m.readAt ((src 6).add (BitVec.ofNat 64 (8 * k))) 64,
        m.readAt ((src 7).add (BitVec.ofNat 64 (8 * k))) 64] := by
  apply Vector.ext
  intro i hi
  rcases i with _ | _ | _ | _ | i
  all_goals simp [pickHi]
  omega

/-- A picked limb's lanes, from its halves. -/
theorem MemoryState.pickLo_pickHi {m : MemoryState} {src : Fin 8 → Pointer} {k : Nat} :
    #v[(m.pickLo src k)[0], (m.pickLo src k)[1], (m.pickLo src k)[2], (m.pickLo src k)[3],
        (m.pickHi src k)[0], (m.pickHi src k)[1], (m.pickHi src k)[2], (m.pickHi src k)[3]] =
      m.pickLimb src k := by
  apply Vector.ext
  intro i hi
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i
  all_goals simp [pickLo, pickHi, pickLimb]
  all_goals first | rfl | omega

/-- Lane 0 of a 256-bit read: the qword there. -/
theorem MemoryState.extractVecElem_readAt_zero {m : MemoryState} {Q : Pointer} (h : 0 < 4) :
    Ty.extractVecElem 4 64 ⟨0, h⟩ (m.readAt Q 256) = m.readAt Q 64 := by
  rw [MemoryState.readAt_of_readAt_le (show 64 ≤ 256 by decide) rfl, Ty.extractVecElem_eq]
  simp [BitVec.setWidth_eq_extractLsb']

/-! ### Pointers -/

/-- A dynamic `gep` by `k` qwords that stays below `2 ^ 63` bytes and does not wrap. -/
theorem gepDyn_8 {P : Pointer} {o : BitVec 64} {k : Nat} (ho : o.toNat = k) (hk : 8 * k < 2 ^ 63)
    (hov : ¬P.offset.uaddOverflow (BitVec.ofNat 64 (8 * k))) :
    Operation.gepDyn { nusw := true, nuw := true } 0 8 (.value P) (.value o) =
      .value (P.add (BitVec.ofNat 64 (8 * k))) := by
  subst ho
  have h1 : ¬9223372036854775808 ≤ o.toNat * 8 := by omega
  have h2 : o.toNat * 8 < 18446744073709551616 := by omega
  have h4 : BitVec.ofNat 64 (o.toNat * 8) = BitVec.ofNat 64 (8 * o.toNat) := by
    rw [Nat.mul_comm]
  have h3 : (BitVec.ofNat 64 (8 * o.toNat)).msb = false := by
    rw [BitVec.msb_eq_decide]; simp; omega
  simp [Operation.gepDyn, Operation.gep, h1, h2, h4, h3, hov]

/-- `gep` back by `n` bytes, `nusw`, inside the block. -/
theorem gepBack_nusw {P : Pointer} {n : Nat} (h : n ≤ P.offset.toNat) :
    Operation.gepBack { nusw := true } n (.value P) = .value (P.add (-BitVec.ofNat 64 n)) := by
  simp [Operation.gepBack, Nat.not_lt.mpr h]

/-- `n` bytes back inside the block: the offset `n` less. -/
theorem Pointer.offset_toNat_back {Q : Pointer} {n : Nat} (h : n ≤ Q.offset.toNat) :
    (Q.add (-BitVec.ofNat 64 n)).offset.toNat = Q.offset.toNat - n := by
  have := Q.offset.isLt
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_neg, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : n < 2 ^ 64)]
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · simpa using this
  · rw [Nat.mod_eq_of_lt (by omega : 2 ^ 64 - n < 2 ^ 64)]
    omega

/-- `n` bytes back, then `n` on. -/
theorem Pointer.back_add (Q : Pointer) (n : Nat) :
    (Q.add (-BitVec.ofNat 64 n)).add (BitVec.ofNat 64 n) = Q := by
  rw [Pointer.add_add, BitVec.add_left_neg, Pointer.add_zero]

/-! ### Masked loads -/

/-- `masked.load` of lane `j` alone (`M` one-hot): `V` with lane `j` read. -/
theorem maskedLoad_lane {Γ : Ctx} {env : ⟪Γ⟫} {s : GlobalState} {dst : Dst Γ (.vec 4 64)}
    {P : Pointer} {M : Vector (BitVec 1) 4} {V : Vector (BitVec 64) 4} (j : Fin 4)
    (hm : ∀ i : Fin 4, M[i] = if i = j then 1#1 else 0#1) (hb : P.offset.toNat + j * 8 < 2 ^ 64)
    (hf : Fits s.mem (P.add (BitVec.ofNat 64 (j * 8))) 64) :
    Operation.maskedLoad dst (.value P) (Ty.wrap M) (Ty.wrap V) env s =
      .value (env.write dst (Ty.wrap (V.set j (s.mem.readAt (P.add (BitVec.ofNat 64 (j * 8))) 64))),
        s) := by
  have hm' : (Ty.wrap (t := .vec 4 1) M).toList.any (·.isPoison) = false := by
    simp [Ty.wrap, Function.comp_def, PoisonOr.isPoison_value, Vector.any_eq_false]
  rw [run_maskedLoad hm']
  · refine congrArg (fun v => PoisonOr.value (env.write dst v, s)) ?_
    apply Vector.ext
    intro i hi
    have hmi := hm ⟨i, hi⟩
    by_cases hij : i = j.val
    · subst hij
      simp only [Fin.eta, ↓reduceIte, Fin.getElem_fin] at hmi
      have hl : Operation.lanePtr P 64 j = P.add (BitVec.ofNat 64 (j * 8)) := rfl
      simp only [Ty.wrap, Vector.getElem_ofFn, Fin.getElem_fin, Vector.getElem_map, hmi, ↓reduceIte,
        hl, MemoryState.knownAt_of_fits hf, Vector.getElem_set_self]
      exact (Ty.unflattenDef_allOnes (t := .bv 64)).trans (Ty.unflatten_bv _)
    · have hne : (⟨i, hi⟩ : Fin 4) ≠ j := fun h => hij (by rw [← h])
      simp only [hne, ↓reduceIte, Fin.getElem_fin] at hmi
      simp [Ty.wrap, hmi, Vector.getElem_set_ne _ _ (Ne.symm hij)]
  · intro i hi
    have hmi := hm i
    by_cases hij : i = j
    · subst hij
      exact ⟨hb, by simpa [Operation.lanePtr] using hf.inBounds⟩
    · simp only [hij, ↓reduceIte, Fin.getElem_fin] at hmi
      simp [Ty.wrap, hmi] at hi

/-- `masked.load` of lane `j`'s qword at `a`, by the pointer `8 j` bytes back (`c = -8 j`). -/
def laneLoadRun (c : Int) (b : Dst Γ .ptr) (a : Reg Γ .ptr) (d : Dst Γ (.vec 4 64))
    (m : Reg Γ (.vec 4 1)) (pt : Reg Γ (.vec 4 64)) : List (Instr Γ) :=
  [.unop (.gepConst { nusw := true } c) b a, .maskedLoad d (.val b.i b.h) m pt]

/-- Where the body at `pos` is `laneLoadRun`, `a` holds `Q`, `m` the one-hot mask of lane `j` and
`pt` `V`: running on gives `K` if it does from `pos + 2` with `V`'s lane `j` the qword at `Q`. -/
theorem runBodyFrom_laneLoadRun (j : Fin 4) (c : Int) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {b : Dst Γ .ptr} {a : Reg Γ .ptr} {d : Dst Γ (.vec 4 64)} {m : Reg Γ (.vec 4 1)}
    {pt : Reg Γ (.vec 4 64)} {rest : List (Instr Γ)} {Q : Pointer} {M : Vector (BitVec 1) 4}
    {V : Vector (BitVec 64) 4} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (hbody : blk.body.drop pos = laneLoadRun c b a d m pt ++ rest)
    (hR : E ⊨ [a := Q, m := M, pt := V]) (hc : c = -(8 * (j : Nat) : Int) ∧ (j : Nat) ≠ 0)
    (hm : ∀ i : Fin 4, M[i] = if i = j then 1#1 else 0#1) (hoff : 8 * (j : Nat) ≤ Q.offset.toNat)
    (hf : Fits S.mem Q 64)
    (hK :
      ∀ vb : ⟦.ptr⟧,
        (blk.runBodyFrom E[b := vb, d := Ty.wrap (V.set j (S.mem.readAt Q 64))] (pos + 2) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hc, hj⟩ := hc
  subst hc
  have h1 : ¬8 * ((j : Nat) : Int) ≤ 0 := by omega
  have h2 : (8 * ((j : Nat) : Int)).natAbs = 8 * (j : Nat) := by omega
  step_pure [h1, h2, gepBack_nusw hoff]
  step_impure =>
    exact
      maskedLoad_lane j hm (by rw [Pointer.offset_toNat_back hoff]; omega)
        (by rw [Nat.mul_comm, Pointer.back_add]; exact hf)
  subst hS hE
  rw [Nat.mul_comm (j : Nat) 8, ← Pointer.add_add, Pointer.back_add]
  exact hK _

/-! ### Picks: `rows` loads -/

/-- `fd_ed25519_lane_pick( src, 0, 1 )`, 28 instructions: `a` holds `src`, `p0` `src[0]`, `g4`
`src + 4`, `m1 m2 m3` the one-hot masks of lanes 1 … 3; `src[1 … 7]` into `p1 … p7`, the limb into
`d`. -/
def rowsLimb0Run (a : Reg Γ .ptr) (m1 m2 m3 : Reg Γ (.vec 4 1)) (p0 g4 : Dst Γ .ptr)
    (l0 : Dst Γ (.vec 4 64)) (p4 : Dst Γ .ptr) (h0 : Dst Γ (.vec 4 64)) (c1 p1 b1 : Dst Γ .ptr)
    (l1 : Dst Γ (.vec 4 64)) (c5 p5 b5 : Dst Γ .ptr) (h1 : Dst Γ (.vec 4 64))
    (c2 p2 b2 : Dst Γ .ptr) (l2 : Dst Γ (.vec 4 64)) (c6 p6 b6 : Dst Γ .ptr)
    (h2 : Dst Γ (.vec 4 64)) (c3 p3 b3 : Dst Γ .ptr) (l3 : Dst Γ (.vec 4 64))
    (c7 p7 b7 : Dst Γ .ptr) (h3 : Dst Γ (.vec 4 64)) (d : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.load l0 (.val p0.i p0.h),
    .load p4 (.val g4.i g4.h),
    .load h0 (.val p4.i p4.h),
    .unop (.gepConst { nusw := true, nuw := true } 8) c1 a,
    .load p1 (.val c1.i c1.h),
    .unop (.gepConst { nusw := true } (-8)) b1 (.val p1.i p1.h),
    .maskedLoad l1 (.val b1.i b1.h) m1 (.val l0.i l0.h),
    .unop (.gepConst { nusw := true, nuw := true } 40) c5 a,
    .load p5 (.val c5.i c5.h),
    .unop (.gepConst { nusw := true } (-8)) b5 (.val p5.i p5.h),
    .maskedLoad h1 (.val b5.i b5.h) m1 (.val h0.i h0.h),
    .unop (.gepConst { nusw := true, nuw := true } 16) c2 a,
    .load p2 (.val c2.i c2.h),
    .unop (.gepConst { nusw := true } (-16)) b2 (.val p2.i p2.h),
    .maskedLoad l2 (.val b2.i b2.h) m2 (.val l1.i l1.h),
    .unop (.gepConst { nusw := true, nuw := true } 48) c6 a,
    .load p6 (.val c6.i c6.h),
    .unop (.gepConst { nusw := true } (-16)) b6 (.val p6.i p6.h),
    .maskedLoad h2 (.val b6.i b6.h) m2 (.val h1.i h1.h),
    .unop (.gepConst { nusw := true, nuw := true } 24) c3 a,
    .load p3 (.val c3.i c3.h),
    .unop (.gepConst { nusw := true } (-24)) b3 (.val p3.i p3.h),
    .maskedLoad l3 (.val b3.i b3.h) m3 (.val l2.i l2.h),
    .unop (.gepConst { nusw := true, nuw := true } 56) c7 a,
    .load p7 (.val c7.i c7.h),
    .unop (.gepConst { nusw := true } (-24)) b7 (.val p7.i p7.h),
    .maskedLoad h3 (.val b7.i b7.h) m3 (.val h2.i h2.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7]) d
      (.val l3.i l3.h) (.val h3.i h3.h)]

-- 28 steps in one declaration
set_option maxHeartbeats 400000 in
/-- Where the body at `pos` is `rowsLimb0Run`, `a` holds the array `A` of the operands `P`, `rows`
operands, `p0` `P 0` and `g4` `A + 32`: running on gives `K` if it does from `pos + 28` with
`P 1 … P 7` in `p1 … p7` and the limb in `d`. -/
theorem runBodyFrom_rowsLimb0Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {a : Reg Γ .ptr} {m1 m2 m3 : Reg Γ (.vec 4 1)} {A : Pointer}
    {p0 g4 p4 c1 p1 b1 c5 p5 b5 c2 p2 b2 c6 p6 b6 c3 p3 b3 c7 p7 b7 : Dst Γ .ptr}
    {l0 h0 l1 h1 l2 h2 l3 h3 : Dst Γ (.vec 4 64)} {d : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {P : Fin 8 → Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = rowsLimb0Run a m1 m2 m3 p0 g4 l0 p4 h0 c1 p1 b1 l1 c5 p5 b5 h1 c2
        p2 b2 l2 c6 p6 b6 h2 c3 p3 b3 l3 c7 p7 b7 h3 d ++ rest)
    (hR : E ⊨ [a := A, m1 := #v[0#1, 1#1, 0#1, 0#1], m2 := #v[0#1, 0#1, 1#1, 0#1],
        m3 := #v[0#1, 0#1, 0#1, 1#1], p0 := P 0, g4 := A.add 32#64])
    (hd : [p0.i, g4.i, l0.i, p4.i, h0.i, c1.i, p1.i, b1.i, l1.i, c5.i, p5.i, b5.i, h1.i, c2.i, p2.i,
        b2.i, l2.i, c6.i, p6.i, b6.i, h2.i, c3.i, p3.i, b3.i, l3.i, c7.i, p7.i, b7.i, h3.i,
        d.i].Nodup)
    (ha : a ≠ .val p4.i p4.h ∧ a ≠ .val c1.i c1.h ∧ a ≠ .val p1.i p1.h ∧ a ≠ .val b1.i b1.h ∧ a ≠
        .val c5.i c5.h ∧ a ≠ .val p5.i p5.h ∧ a ≠ .val b5.i b5.h ∧ a ≠ .val c2.i c2.h ∧ a ≠ .val
        p2.i p2.h ∧ a ≠ .val b2.i b2.h ∧ a ≠ .val c6.i c6.h ∧ a ≠ .val p6.i p6.h ∧ a ≠ .val b6.i
        b6.h ∧ a ≠ .val c3.i c3.h ∧ a ≠ .val p3.i p3.h ∧ a ≠ .val b3.i b3.h)
    (hA : S.mem.PtrArray A P) (hrow : S.mem.RowsAt P 0)
    (hK :
      ∀ (v_l0 : ⟦.vec 4 64⟧) (v_h0 : ⟦.vec 4 64⟧) (v_c1 : ⟦.ptr⟧) (v_b1 : ⟦.ptr⟧)
        (v_l1 : ⟦.vec 4 64⟧) (v_c5 : ⟦.ptr⟧) (v_b5 : ⟦.ptr⟧) (v_h1 : ⟦.vec 4 64⟧) (v_c2 : ⟦.ptr⟧)
        (v_b2 : ⟦.ptr⟧) (v_l2 : ⟦.vec 4 64⟧) (v_c6 : ⟦.ptr⟧) (v_b6 : ⟦.ptr⟧) (v_h2 : ⟦.vec 4 64⟧)
        (v_c3 : ⟦.ptr⟧) (v_b3 : ⟦.ptr⟧) (v_l3 : ⟦.vec 4 64⟧) (v_c7 : ⟦.ptr⟧) (v_b7 : ⟦.ptr⟧)
        (v_h3 : ⟦.vec 4 64⟧),
        (blk.runBodyFrom E[l0 := v_l0, p4 := .value (P 4), h0 := v_h0, c1 := v_c1,
          p1 := .value (P 1), b1 := v_b1, l1 := v_l1, c5 := v_c5, p5 := .value (P 5), b5 := v_b5,
          h1 := v_h1, c2 := v_c2, p2 := .value (P 2), b2 := v_b2, l2 := v_l2, c6 := v_c6,
          p6 := .value (P 6), b6 := v_b6, h2 := v_h2, c3 := v_c3, p3 := .value (P 3), b3 := v_b3,
          l3 := v_l3, c7 := v_c7, p7 := .value (P 7), b7 := v_b7, h3 := v_h3,
          d := Ty.wrap (S.mem.pickLimb P 0)] (pos + 28) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨ne0, ne1, ne2, ne3, ne4, ne5, ne6, ne7, ne8, ne9, ne10, ne11, ne12, ne13, ne14, ne15⟩ :=
    ha
  obtain ⟨hov, hb, hp⟩ := hA
  have q (j : Fin 8) (o : BitVec 64) (h : o = BitVec.ofNat 64 (8 * j) := by decide) :
      S.mem.loadPtr (A.add o) = .value (P j) := h ▸ hp j
  obtain ⟨-, hrow, f0, f4⟩ := hrow
  simp only [Nat.mul_zero, Pointer.add_zero] at hrow f0 f4
  have r (j : Fin 8) := hrow j
  obtain ⟨-, o1, f1⟩ := r 1
  obtain ⟨-, o5, f5⟩ := r 5
  obtain ⟨-, o2, f2⟩ := r 2
  obtain ⟨-, o6, f6⟩ := r 6
  obtain ⟨-, o3, f3⟩ := r 3
  obtain ⟨-, o7, f7⟩ := r 7
  clear r hrow
  step_load
  step_load [q 4 32#64] inline
  step_load
  step_pure
  step_load [q 1 8#64] inline
  step_pattern using runBodyFrom_laneLoadRun 1 (-8) (hoff := o1) (hf := f1)
  step_pure
  step_load [q 5 40#64] inline
  step_pattern using runBodyFrom_laneLoadRun 1 (-8) (hoff := o5) (hf := f5)
  step_pure
  step_load [q 2 16#64] inline
  step_pattern using runBodyFrom_laneLoadRun 2 (-16) (hoff := o2) (hf := f2)
  step_pure
  step_load [q 6 48#64] inline
  step_pattern using runBodyFrom_laneLoadRun 2 (-16) (hoff := o6) (hf := f6)
  step_pure
  step_load [q 3 24#64] inline
  step_pattern using runBodyFrom_laneLoadRun 3 (-24) (hoff := o3) (hf := f3) with lo
  step_pure
  step_load [q 7 56#64] inline
  step_pattern using runBodyFrom_laneLoadRun 3 (-24) (hoff := o7) (hf := f7) with hi
  step_pure
  subst hS
  have eLo : lo = S.mem.pickLo P 0 := by
    rw [hlo, Vector.set_set_set_eq, MemoryState.pickLo_eq, Vector.getElem_ofFn,
      MemoryState.extractVecElem_readAt_zero]
    simp only [Nat.mul_zero, Pointer.add_zero]
  have eHi : hi = S.mem.pickHi P 0 := by
    rw [hhi, Vector.set_set_set_eq, MemoryState.pickHi_eq, Vector.getElem_ofFn,
      MemoryState.extractVecElem_readAt_zero]
    simp only [Nat.mul_zero, Pointer.add_zero]
  rw [hE, eLo, eHi, MemoryState.pickLo_pickHi]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `fd_ed25519_lane_pick( src, off, 1 )` of a limb `off` qwords on but the halves' concatenation,
22 instructions: `o` holds `off`, `p0 … p7` the operands, `m1 m2 m3` the one-hot masks of lanes 1 …
3; the halves into `l3`, `h3`. -/
def rowsHalvesRun (o : Reg Γ (.bv 64)) (m1 m2 m3 : Reg Γ (.vec 4 1))
    (p0 p1 p2 p3 p4 p5 p6 p7 g0 : Dst Γ .ptr) (l0 : Dst Γ (.vec 4 64)) (g4 : Dst Γ .ptr)
    (h0 : Dst Γ (.vec 4 64)) (a1 b1 : Dst Γ .ptr) (l1 : Dst Γ (.vec 4 64)) (a5 b5 : Dst Γ .ptr)
    (h1 : Dst Γ (.vec 4 64)) (a2 b2 : Dst Γ .ptr) (l2 : Dst Γ (.vec 4 64)) (a6 b6 : Dst Γ .ptr)
    (h2 : Dst Γ (.vec 4 64)) (a3 b3 : Dst Γ .ptr) (l3 : Dst Γ (.vec 4 64)) (a7 b7 : Dst Γ .ptr)
    (h3 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  [.binop (.gepDyn { nusw := true, nuw := true } 0 8) g0 (.val p0.i p0.h) o,
    .load l0 (.val g0.i g0.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) g4 (.val p4.i p4.h) o,
    .load h0 (.val g4.i g4.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a1 (.val p1.i p1.h) o,
    .unop (.gepConst { nusw := true } (-8)) b1 (.val a1.i a1.h),
    .maskedLoad l1 (.val b1.i b1.h) m1 (.val l0.i l0.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a5 (.val p5.i p5.h) o,
    .unop (.gepConst { nusw := true } (-8)) b5 (.val a5.i a5.h),
    .maskedLoad h1 (.val b5.i b5.h) m1 (.val h0.i h0.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a2 (.val p2.i p2.h) o,
    .unop (.gepConst { nusw := true } (-16)) b2 (.val a2.i a2.h),
    .maskedLoad l2 (.val b2.i b2.h) m2 (.val l1.i l1.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a6 (.val p6.i p6.h) o,
    .unop (.gepConst { nusw := true } (-16)) b6 (.val a6.i a6.h),
    .maskedLoad h2 (.val b6.i b6.h) m2 (.val h1.i h1.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a3 (.val p3.i p3.h) o,
    .unop (.gepConst { nusw := true } (-24)) b3 (.val a3.i a3.h),
    .maskedLoad l3 (.val b3.i b3.h) m3 (.val l2.i l2.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a7 (.val p7.i p7.h) o,
    .unop (.gepConst { nusw := true } (-24)) b7 (.val a7.i a7.h),
    .maskedLoad h3 (.val b7.i b7.h) m3 (.val h2.i h2.h)]

-- 22 steps in one declaration
set_option maxHeartbeats 400000 in
/-- Where the body at `pos` is `rowsHalvesRun`, `o` holds `O` (`k` qwords) and `p0 … p7` the
operands `P`, `rows` operands there: running on gives `K` if it does from `pos + 22` with the limb's
halves in `l3`, `h3`. -/
theorem runBodyFrom_rowsHalvesRun (k : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {o : Reg Γ (.bv 64)} {m1 m2 m3 : Reg Γ (.vec 4 1)} {O : BitVec 64}
    {p0 p1 p2 p3 p4 p5 p6 p7 g0 g4 a1 b1 a5 b5 a2 b2 a6 b6 a3 b3 a7 b7 : Dst Γ .ptr}
    {l0 h0 l1 h1 l2 h2 l3 h3 : Dst Γ (.vec 4 64)} {rest : List (Instr Γ)} {P : Fin 8 → Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = rowsHalvesRun o m1 m2 m3 p0 p1 p2 p3 p4 p5 p6 p7 g0 l0 g4 h0 a1 b1
        l1 a5 b5 h1 a2 b2 l2 a6 b6 h2 a3 b3 l3 a7 b7 h3 ++ rest)
    (hR : E ⊨ [o := O, m1 := #v[0#1, 1#1, 0#1, 0#1], m2 := #v[0#1, 0#1, 1#1, 0#1],
        m3 := #v[0#1, 0#1, 0#1, 1#1], p0 := P 0, p1 := P 1, p2 := P 2, p3 := P 3, p4 := P 4,
        p5 := P 5, p6 := P 6, p7 := P 7])
    (hd : [p0.i, p1.i, p2.i, p3.i, p4.i, p5.i, p6.i, p7.i, g0.i, l0.i, g4.i, h0.i, a1.i, b1.i, l1.i,
        a5.i, b5.i, h1.i, a2.i, b2.i, l2.i, a6.i, b6.i, h2.i, a3.i, b3.i, l3.i, a7.i, b7.i,
        h3.i].Nodup)
    (ho : O.toNat = k) (hrow : S.mem.RowsAt P k)
    (hK :
      ∀ (v_g0 : ⟦.ptr⟧) (v_l0 : ⟦.vec 4 64⟧) (v_g4 : ⟦.ptr⟧) (v_h0 : ⟦.vec 4 64⟧) (v_a1 : ⟦.ptr⟧)
        (v_b1 : ⟦.ptr⟧) (v_l1 : ⟦.vec 4 64⟧) (v_a5 : ⟦.ptr⟧) (v_b5 : ⟦.ptr⟧) (v_h1 : ⟦.vec 4 64⟧)
        (v_a2 : ⟦.ptr⟧) (v_b2 : ⟦.ptr⟧) (v_l2 : ⟦.vec 4 64⟧) (v_a6 : ⟦.ptr⟧) (v_b6 : ⟦.ptr⟧)
        (v_h2 : ⟦.vec 4 64⟧) (v_a3 : ⟦.ptr⟧) (v_b3 : ⟦.ptr⟧) (v_a7 : ⟦.ptr⟧) (v_b7 : ⟦.ptr⟧),
        (blk.runBodyFrom E[g0 := v_g0, l0 := v_l0, g4 := v_g4, h0 := v_h0, a1 := v_a1, b1 := v_b1,
          l1 := v_l1, a5 := v_a5, b5 := v_b5, h1 := v_h1, a2 := v_a2, b2 := v_b2, l2 := v_l2,
          a6 := v_a6, b6 := v_b6, h2 := v_h2, a3 := v_a3, b3 := v_b3,
          l3 := Ty.wrap (S.mem.pickLo P k), a7 := v_a7, b7 := v_b7,
          h3 := Ty.wrap (S.mem.pickHi P k)] (pos + 22) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hk, hrow, f0, f4⟩ := hrow
  have r (j : Fin 8) := hrow j
  obtain ⟨ov0, -, -⟩ := r 0
  obtain ⟨ov4, -, -⟩ := r 4
  obtain ⟨ov1, o1, f1⟩ := r 1
  obtain ⟨ov5, o5, f5⟩ := r 5
  obtain ⟨ov2, o2, f2⟩ := r 2
  obtain ⟨ov6, o6, f6⟩ := r 6
  obtain ⟨ov3, o3, f3⟩ := r 3
  obtain ⟨ov7, o7, f7⟩ := r 7
  clear r hrow
  step_pure [gepDyn_8 ho hk ov0]
  step_load
  step_pure [gepDyn_8 ho hk ov4]
  step_load
  step_pure [gepDyn_8 ho hk ov1]
  step_pattern using runBodyFrom_laneLoadRun 1 (-8) (hoff := o1) (hf := f1)
  step_pure [gepDyn_8 ho hk ov5]
  step_pattern using runBodyFrom_laneLoadRun 1 (-8) (hoff := o5) (hf := f5)
  step_pure [gepDyn_8 ho hk ov2]
  step_pattern using runBodyFrom_laneLoadRun 2 (-16) (hoff := o2) (hf := f2)
  step_pure [gepDyn_8 ho hk ov6]
  step_pattern using runBodyFrom_laneLoadRun 2 (-16) (hoff := o6) (hf := f6)
  step_pure [gepDyn_8 ho hk ov3]
  step_pattern using runBodyFrom_laneLoadRun 3 (-24) (hoff := o3) (hf := f3)
  step_pure [gepDyn_8 ho hk ov7]
  step_pattern using runBodyFrom_laneLoadRun 3 (-24) (hoff := o7) (hf := f7)
  subst hS
  have eLo : vl3 = S.mem.pickLo P k := by
    rw [hvl3, Vector.set_set_set_eq, MemoryState.pickLo_eq, Vector.getElem_ofFn,
      MemoryState.extractVecElem_readAt_zero]
  have eHi : vh3 = S.mem.pickHi P k := by
    rw [hvh3, Vector.set_set_set_eq, MemoryState.pickHi_eq, Vector.getElem_ofFn,
      MemoryState.extractVecElem_readAt_zero]
  rw [hE, eLo, eHi]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-! ### Picks: broadcasts -/

/-- `fd_ed25519_lane_pick( src, 0, 0 )`, 30 instructions: `a` holds `src`, `p0` `src[0]`, `g4`
`src + 4`, `z` a poison vector, `i0 … i3` the lane indices; `src[1 … 7]` into `p1 … p7`, the limb
into `d`. -/
def bcastLimb0Run (a : Reg Γ .ptr) (z : Dst Γ (.vec 4 64)) (i0 i1 i2 i3 : Dst Γ (.bv 64))
    (p0 g4 : Dst Γ .ptr) (x0 : Dst Γ (.bv 64)) (l0 : Dst Γ (.vec 4 64)) (p4 : Dst Γ .ptr)
    (y0 : Dst Γ (.bv 64)) (h0 : Dst Γ (.vec 4 64)) (c1 p1 : Dst Γ .ptr) (x1 : Dst Γ (.bv 64))
    (l1 : Dst Γ (.vec 4 64)) (c5 p5 : Dst Γ .ptr) (y1 : Dst Γ (.bv 64)) (h1 : Dst Γ (.vec 4 64))
    (c2 p2 : Dst Γ .ptr) (x2 : Dst Γ (.bv 64)) (l2 : Dst Γ (.vec 4 64)) (c6 p6 : Dst Γ .ptr)
    (y2 : Dst Γ (.bv 64)) (h2 : Dst Γ (.vec 4 64)) (c3 p3 : Dst Γ .ptr) (x3 : Dst Γ (.bv 64))
    (l3 : Dst Γ (.vec 4 64)) (c7 p7 : Dst Γ .ptr) (y3 : Dst Γ (.bv 64)) (h3 : Dst Γ (.vec 4 64))
    (d : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.load x0 (.val p0.i p0.h),
    .ternop .insertelement l0 (.val z.i z.h) (.val x0.i x0.h) (.val i0.i i0.h),
    .load p4 (.val g4.i g4.h),
    .load y0 (.val p4.i p4.h),
    .ternop .insertelement h0 (.val z.i z.h) (.val y0.i y0.h) (.val i0.i i0.h),
    .unop (.gepConst { nusw := true, nuw := true } 8) c1 a,
    .load p1 (.val c1.i c1.h),
    .load x1 (.val p1.i p1.h),
    .ternop .insertelement l1 (.val l0.i l0.h) (.val x1.i x1.h) (.val i1.i i1.h),
    .unop (.gepConst { nusw := true, nuw := true } 40) c5 a,
    .load p5 (.val c5.i c5.h),
    .load y1 (.val p5.i p5.h),
    .ternop .insertelement h1 (.val h0.i h0.h) (.val y1.i y1.h) (.val i1.i i1.h),
    .unop (.gepConst { nusw := true, nuw := true } 16) c2 a,
    .load p2 (.val c2.i c2.h),
    .load x2 (.val p2.i p2.h),
    .ternop .insertelement l2 (.val l1.i l1.h) (.val x2.i x2.h) (.val i2.i i2.h),
    .unop (.gepConst { nusw := true, nuw := true } 48) c6 a,
    .load p6 (.val c6.i c6.h),
    .load y2 (.val p6.i p6.h),
    .ternop .insertelement h2 (.val h1.i h1.h) (.val y2.i y2.h) (.val i2.i i2.h),
    .unop (.gepConst { nusw := true, nuw := true } 24) c3 a,
    .load p3 (.val c3.i c3.h),
    .load x3 (.val p3.i p3.h),
    .ternop .insertelement l3 (.val l2.i l2.h) (.val x3.i x3.h) (.val i3.i i3.h),
    .unop (.gepConst { nusw := true, nuw := true } 56) c7 a,
    .load p7 (.val c7.i c7.h),
    .load y3 (.val p7.i p7.h),
    .ternop .insertelement h3 (.val h2.i h2.h) (.val y3.i y3.h) (.val i3.i i3.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7]) d
      (.val l3.i l3.h) (.val h3.i h3.h)]

-- 30 steps in one declaration
set_option maxHeartbeats 400000 in
/-- Where the body at `pos` is `bcastLimb0Run`, `a` holds the array `A` of the operands `P`, known,
`p0` `P 0` and `g4` `A + 32`: running on gives `K` if it does from `pos + 30` with `P 1 … P 7` in
`p1 … p7` and the limb in `d`. -/
theorem runBodyFrom_bcastLimb0Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {a : Reg Γ .ptr} {A : Pointer} {z l0 h0 l1 h1 l2 h2 l3 h3 : Dst Γ (.vec 4 64)}
    {i0 i1 i2 i3 x0 y0 x1 y1 x2 y2 x3 y3 : Dst Γ (.bv 64)}
    {p0 g4 p4 c1 p1 c5 p5 c2 p2 c6 p6 c3 p3 c7 p7 : Dst Γ .ptr} {d : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {P : Fin 8 → Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = bcastLimb0Run a z i0 i1 i2 i3 p0 g4 x0 l0 p4 y0 h0 c1 p1 x1 l1 c5
        p5 y1 h1 c2 p2 x2 l2 c6 p6 y2 h2 c3 p3 x3 l3 c7 p7 y3 h3 d ++ rest)
    (hR : E ⊨ [a := A, z := Vector.replicate 4 .poison, i0 := 0#64, i1 := 1#64, i2 := 2#64,
        i3 := 3#64, p0 := P 0, g4 := A.add 32#64])
    (hd : [z.i, i0.i, i1.i, i2.i, i3.i, p0.i, g4.i, x0.i, l0.i, p4.i, y0.i, h0.i, c1.i, p1.i, x1.i,
        l1.i, c5.i, p5.i, y1.i, h1.i, c2.i, p2.i, x2.i, l2.i, c6.i, p6.i, y2.i, h2.i, c3.i, p3.i,
        x3.i, l3.i, c7.i, p7.i, y3.i, h3.i, d.i].Nodup)
    (ha : a ≠ .val p4.i p4.h ∧ a ≠ .val c1.i c1.h ∧ a ≠ .val p1.i p1.h ∧ a ≠ .val c5.i c5.h ∧ a ≠
        .val p5.i p5.h ∧ a ≠ .val c2.i c2.h ∧ a ≠ .val p2.i p2.h ∧ a ≠ .val c6.i c6.h ∧ a ≠ .val
        p6.i p6.h ∧ a ≠ .val c3.i c3.h ∧ a ≠ .val p3.i p3.h)
    (hA : S.mem.PtrArray A P) (hbc : S.mem.BcastAt P 0)
    (hK :
      ∀ (v_x0 : ⟦.bv 64⟧) (v_l0 : ⟦.vec 4 64⟧) (v_y0 : ⟦.bv 64⟧) (v_h0 : ⟦.vec 4 64⟧)
        (v_c1 : ⟦.ptr⟧) (v_x1 : ⟦.bv 64⟧) (v_l1 : ⟦.vec 4 64⟧) (v_c5 : ⟦.ptr⟧) (v_y1 : ⟦.bv 64⟧)
        (v_h1 : ⟦.vec 4 64⟧) (v_c2 : ⟦.ptr⟧) (v_x2 : ⟦.bv 64⟧) (v_l2 : ⟦.vec 4 64⟧) (v_c6 : ⟦.ptr⟧)
        (v_y2 : ⟦.bv 64⟧) (v_h2 : ⟦.vec 4 64⟧) (v_c3 : ⟦.ptr⟧) (v_x3 : ⟦.bv 64⟧)
        (v_l3 : ⟦.vec 4 64⟧) (v_c7 : ⟦.ptr⟧) (v_y3 : ⟦.bv 64⟧) (v_h3 : ⟦.vec 4 64⟧),
        (blk.runBodyFrom E[x0 := v_x0, l0 := v_l0, p4 := .value (P 4), y0 := v_y0, h0 := v_h0,
          c1 := v_c1, p1 := .value (P 1), x1 := v_x1, l1 := v_l1, c5 := v_c5, p5 := .value (P 5),
          y1 := v_y1, h1 := v_h1, c2 := v_c2, p2 := .value (P 2), x2 := v_x2, l2 := v_l2,
          c6 := v_c6, p6 := .value (P 6), y2 := v_y2, h2 := v_h2, c3 := v_c3, p3 := .value (P 3),
          x3 := v_x3, l3 := v_l3, c7 := v_c7, p7 := .value (P 7), y3 := v_y3, h3 := v_h3,
          d := Ty.wrap (S.mem.pickLimb P 0)] (pos + 30) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨ne0, ne1, ne2, ne3, ne4, ne5, ne6, ne7, ne8, ne9, ne10⟩ := ha
  obtain ⟨hov, hb, hp⟩ := hA
  have q (j : Fin 8) (o : BitVec 64) (h : o = BitVec.ofNat 64 (8 * j) := by decide) :
      S.mem.loadPtr (A.add o) = .value (P j) := h ▸ hp j
  obtain ⟨-, hrow⟩ := hbc
  simp only [Nat.mul_zero, Pointer.add_zero] at hrow
  have r (j : Fin 8) := hrow j
  obtain ⟨-, f0⟩ := r 0
  obtain ⟨-, f1⟩ := r 1
  obtain ⟨-, f2⟩ := r 2
  obtain ⟨-, f3⟩ := r 3
  obtain ⟨-, f4⟩ := r 4
  obtain ⟨-, f5⟩ := r 5
  obtain ⟨-, f6⟩ := r 6
  obtain ⟨-, f7⟩ := r 7
  clear r hrow
  step_load
  step_pure
  step_load [q 4 32#64] inline
  step_load
  step_pure
  step_pure
  step_load [q 1 8#64] inline
  step_load
  step_pure
  step_pure
  step_load [q 5 40#64] inline
  step_load
  step_pure
  step_pure
  step_load [q 2 16#64] inline
  step_load
  step_pure
  step_pure
  step_load [q 6 48#64] inline
  step_load
  step_pure
  step_pure
  step_load [q 3 24#64] inline
  step_load
  step_pure [Vector.set_set_set_set_eq] with lo
  step_pure
  step_load [q 7 56#64] inline
  step_load
  step_pure [Vector.set_set_set_set_eq] with hi
  step_pure
  subst hS
  have eLo : lo = S.mem.pickLo P 0 := by
    rw [hlo, MemoryState.pickLo_eq]
    simp only [Nat.mul_zero, Pointer.add_zero]
  have eHi : hi = S.mem.pickHi P 0 := by
    rw [hhi, MemoryState.pickHi_eq]
    simp only [Nat.mul_zero, Pointer.add_zero]
  rw [hE, eLo, eHi, MemoryState.pickLo_pickHi]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `fd_ed25519_lane_pick( src, off, 0 )` of a limb `off` qwords on but the halves' concatenation,
24 instructions: `o` holds `off`, `p0 … p7` the operands, `z` a poison vector, `i0 … i3` the lane
indices; the halves into `l3`, `h3`. -/
def bcastHalvesRun (o : Reg Γ (.bv 64)) (z : Dst Γ (.vec 4 64)) (i0 i1 i2 i3 : Dst Γ (.bv 64))
    (p0 p1 p2 p3 p4 p5 p6 p7 g0 : Dst Γ .ptr) (x0 : Dst Γ (.bv 64)) (l0 : Dst Γ (.vec 4 64))
    (g4 : Dst Γ .ptr) (y0 : Dst Γ (.bv 64)) (h0 : Dst Γ (.vec 4 64)) (a1 : Dst Γ .ptr)
    (x1 : Dst Γ (.bv 64)) (l1 : Dst Γ (.vec 4 64)) (a5 : Dst Γ .ptr) (y1 : Dst Γ (.bv 64))
    (h1 : Dst Γ (.vec 4 64)) (a2 : Dst Γ .ptr) (x2 : Dst Γ (.bv 64)) (l2 : Dst Γ (.vec 4 64))
    (a6 : Dst Γ .ptr) (y2 : Dst Γ (.bv 64)) (h2 : Dst Γ (.vec 4 64)) (a3 : Dst Γ .ptr)
    (x3 : Dst Γ (.bv 64)) (l3 : Dst Γ (.vec 4 64)) (a7 : Dst Γ .ptr) (y3 : Dst Γ (.bv 64))
    (h3 : Dst Γ (.vec 4 64)) : List (Instr Γ) :=
  [.binop (.gepDyn { nusw := true, nuw := true } 0 8) g0 (.val p0.i p0.h) o,
    .load x0 (.val g0.i g0.h),
    .ternop .insertelement l0 (.val z.i z.h) (.val x0.i x0.h) (.val i0.i i0.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) g4 (.val p4.i p4.h) o,
    .load y0 (.val g4.i g4.h),
    .ternop .insertelement h0 (.val z.i z.h) (.val y0.i y0.h) (.val i0.i i0.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a1 (.val p1.i p1.h) o,
    .load x1 (.val a1.i a1.h),
    .ternop .insertelement l1 (.val l0.i l0.h) (.val x1.i x1.h) (.val i1.i i1.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a5 (.val p5.i p5.h) o,
    .load y1 (.val a5.i a5.h),
    .ternop .insertelement h1 (.val h0.i h0.h) (.val y1.i y1.h) (.val i1.i i1.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a2 (.val p2.i p2.h) o,
    .load x2 (.val a2.i a2.h),
    .ternop .insertelement l2 (.val l1.i l1.h) (.val x2.i x2.h) (.val i2.i i2.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a6 (.val p6.i p6.h) o,
    .load y2 (.val a6.i a6.h),
    .ternop .insertelement h2 (.val h1.i h1.h) (.val y2.i y2.h) (.val i2.i i2.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a3 (.val p3.i p3.h) o,
    .load x3 (.val a3.i a3.h),
    .ternop .insertelement l3 (.val l2.i l2.h) (.val x3.i x3.h) (.val i3.i i3.h),
    .binop (.gepDyn { nusw := true, nuw := true } 0 8) a7 (.val p7.i p7.h) o,
    .load y3 (.val a7.i a7.h),
    .ternop .insertelement h3 (.val h2.i h2.h) (.val y3.i y3.h) (.val i3.i i3.h)]

-- 24 steps in one declaration
set_option maxHeartbeats 400000 in
/-- Where the body at `pos` is `bcastHalvesRun`, `o` holds `O` (`k` qwords) and `p0 … p7` the
operands `P`, known there: running on gives `K` if it does from `pos + 24` with the limb's halves in
`l3`, `h3`. -/
theorem runBodyFrom_bcastHalvesRun (k : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {o : Reg Γ (.bv 64)} {O : BitVec 64} {z l0 h0 l1 h1 l2 h2 l3 h3 : Dst Γ (.vec 4 64)}
    {i0 i1 i2 i3 x0 y0 x1 y1 x2 y2 x3 y3 : Dst Γ (.bv 64)}
    {p0 p1 p2 p3 p4 p5 p6 p7 g0 g4 a1 a5 a2 a6 a3 a7 : Dst Γ .ptr} {rest : List (Instr Γ)}
    {P : Fin 8 → Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = bcastHalvesRun o z i0 i1 i2 i3 p0 p1 p2 p3 p4 p5 p6 p7 g0 x0 l0 g4
        y0 h0 a1 x1 l1 a5 y1 h1 a2 x2 l2 a6 y2 h2 a3 x3 l3 a7 y3 h3 ++ rest)
    (hR : E ⊨ [o := O, z := Vector.replicate 4 .poison, i0 := 0#64, i1 := 1#64, i2 := 2#64,
        i3 := 3#64, p0 := P 0, p1 := P 1, p2 := P 2, p3 := P 3, p4 := P 4, p5 := P 5, p6 := P 6,
        p7 := P 7])
    (hd : [z.i, i0.i, i1.i, i2.i, i3.i, p0.i, p1.i, p2.i, p3.i, p4.i, p5.i, p6.i, p7.i, g0.i, x0.i,
        l0.i, g4.i, y0.i, h0.i, a1.i, x1.i, l1.i, a5.i, y1.i, h1.i, a2.i, x2.i, l2.i, a6.i, y2.i,
        h2.i, a3.i, x3.i, l3.i, a7.i, y3.i, h3.i].Nodup)
    (hne : o ≠ .val x0.i x0.h ∧ o ≠ .val y0.i y0.h ∧ o ≠ .val x1.i x1.h ∧ o ≠ .val y1.i y1.h ∧ o ≠
        .val x2.i x2.h ∧ o ≠ .val y2.i y2.h ∧ o ≠ .val x3.i x3.h)
    (ho : O.toNat = k) (hb : S.mem.BcastAt P k)
    (hK :
      ∀ (v_g0 : ⟦.ptr⟧) (v_x0 : ⟦.bv 64⟧) (v_l0 : ⟦.vec 4 64⟧) (v_g4 : ⟦.ptr⟧) (v_y0 : ⟦.bv 64⟧)
        (v_h0 : ⟦.vec 4 64⟧) (v_a1 : ⟦.ptr⟧) (v_x1 : ⟦.bv 64⟧) (v_l1 : ⟦.vec 4 64⟧) (v_a5 : ⟦.ptr⟧)
        (v_y1 : ⟦.bv 64⟧) (v_h1 : ⟦.vec 4 64⟧) (v_a2 : ⟦.ptr⟧) (v_x2 : ⟦.bv 64⟧)
        (v_l2 : ⟦.vec 4 64⟧) (v_a6 : ⟦.ptr⟧) (v_y2 : ⟦.bv 64⟧) (v_h2 : ⟦.vec 4 64⟧) (v_a3 : ⟦.ptr⟧)
        (v_x3 : ⟦.bv 64⟧) (v_a7 : ⟦.ptr⟧) (v_y3 : ⟦.bv 64⟧),
        (blk.runBodyFrom E[g0 := v_g0, x0 := v_x0, l0 := v_l0, g4 := v_g4, y0 := v_y0, h0 := v_h0,
          a1 := v_a1, x1 := v_x1, l1 := v_l1, a5 := v_a5, y1 := v_y1, h1 := v_h1, a2 := v_a2,
          x2 := v_x2, l2 := v_l2, a6 := v_a6, y2 := v_y2, h2 := v_h2, a3 := v_a3, x3 := v_x3,
          l3 := Ty.wrap (S.mem.pickLo P k), a7 := v_a7, y3 := v_y3,
          h3 := Ty.wrap (S.mem.pickHi P k)] (pos + 24) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨ne0, ne1, ne2, ne3, ne4, ne5, ne6⟩ := hne
  obtain ⟨hk, hrow⟩ := hb
  have r (j : Fin 8) := hrow j
  obtain ⟨ov0, f0⟩ := r 0
  obtain ⟨ov1, f1⟩ := r 1
  obtain ⟨ov2, f2⟩ := r 2
  obtain ⟨ov3, f3⟩ := r 3
  obtain ⟨ov4, f4⟩ := r 4
  obtain ⟨ov5, f5⟩ := r 5
  obtain ⟨ov6, f6⟩ := r 6
  obtain ⟨ov7, f7⟩ := r 7
  clear r hrow
  step_pure [gepDyn_8 ho hk ov0]
  step_load
  step_pure
  step_pure [gepDyn_8 ho hk ov4]
  step_load
  step_pure
  step_pure [gepDyn_8 ho hk ov1]
  step_load
  step_pure
  step_pure [gepDyn_8 ho hk ov5]
  step_load
  step_pure
  step_pure [gepDyn_8 ho hk ov2]
  step_load
  step_pure
  step_pure [gepDyn_8 ho hk ov6]
  step_load
  step_pure
  step_pure [gepDyn_8 ho hk ov3]
  step_load
  step_pure [Vector.set_set_set_set_eq] with lo
  step_pure [gepDyn_8 ho hk ov7]
  step_load
  step_pure [Vector.set_set_set_set_eq] with hi
  subst hS
  rw [hE, hlo, hhi, ← MemoryState.pickLo_eq, ← MemoryState.pickHi_eq]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-! ### A limb from its halves -/

/-- The halves of a picked limb concatenated, one `shufflevector`. -/
def concatRun (lo hi : Reg Γ (.vec 4 64)) (d : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7]) d
      lo hi]

/-- Where the body at `pos` is `concatRun` and `lo`, `hi` hold a picked limb's halves (read in `m`
and `m' = m`): running on gives `K` if it does from `pos + 1` with the limb in `d`. -/
theorem runBodyFrom_concatRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {lo hi : Reg Γ (.vec 4 64)} {d : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {m m' : MemoryState} {P : Fin 8 → Pointer} {k : Nat} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = concatRun lo hi d ++ rest)
    (hR : E ⊨ [lo := m.pickLo P k, hi := m'.pickHi P k]) (hm : m = m')
    (hK : (blk.runBodyFrom E[d := Ty.wrap (m.pickLimb P k)] (pos + 1) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  subst hm
  step_pure
  rw [hE, MemoryState.pickLo_pickHi]
  exact hK

end

end MLIR
