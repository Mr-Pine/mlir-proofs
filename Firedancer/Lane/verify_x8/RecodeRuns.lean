module

public import Firedancer.Lane.verify_x8.RecodeDefs
public import Firedancer.Lane.Common.MaskedStore
meta import MLIR.Run.Tactic.Util
meta import Lean.Elab.Tactic

/-! The runs `fd_ed25519_lane_recode8`'s digits compile to, as templates over registers, and the
lemmas stepping them. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512

@[expose] public section

variable {Γ : Ctx}

/-- Digit `w > 0` of `fd_ed25519_lane_recode8`, 9 instructions: byte `o = w` of `base` widened,
plus the carry `cin` and `128`; the next carry by `>> 8` (`k8`), the digit through the mask `kM`. -/
def dig8Run (o : Int) (base : Dst Γ .ptr) (cin k128 k8 kM : Dst Γ (.bv 32)) (gp : Dst Γ .ptr)
    (db : Dst Γ (.bv 8)) (dz da da2 dc dm dsub : Dst Γ (.bv 32)) (dd : Dst Γ (.bv 16)) :
    List (Instr Γ) :=
  [.unop (.gepConst { nusw := true, nuw := true } o) gp (.val base.i base.h),
    .load db (.val gp.i gp.h),
    .unop (.zext false) dz (.val db.i db.h),
    .binop (.add { nsw := true, nuw := true }) da (.val cin.i cin.h) (.val dz.i dz.h),
    .binop (.add { nsw := true, nuw := true }) da2 (.val da.i da.h) (.val k128.i k128.h),
    .binop (.lshr false) dc (.val da2.i da2.h) (.val k8.i k8.h),
    .binop .and dm (.val da2.i da2.h) (.val kM.i kM.h),
    .binop (.sub { nsw := true }) dsub (.val da.i da.h) (.val dm.i dm.h),
    .unop (.trunc { nsw := true }) dd (.val dsub.i dsub.h)]

/-- Where the body at `pos` is `dig8Run` for digit `w` of `s`, `cin` holding its carry: running on
gives `K` if it does from `pos + 9` with the next carry in `dc` and the digit in `dd`. -/
theorem runBodyFrom_dig8Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {base : Dst Γ .ptr} {cin k128 k8 kM : Dst Γ (.bv 32)} {gp : Dst Γ .ptr} {db : Dst Γ (.bv 8)}
    {dz da da2 dc dm dsub : Dst Γ (.bv 32)} {dd : Dst Γ (.bv 16)} {rest : List (Instr Γ)}
    (s : BitVec 256) (w : Nat) (o : Int) {P : Pointer} {M : BitVec 32} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = dig8Run o base cin k128 k8 kM gp db dz da da2 dc dm dsub dd ++ rest)
    (hR :
      E ⊨ [base := P, cin := carry8 s w, k128 := 128#32, k8 := 8#32, kM := M])
    (ho : o = w) (hw : w < 32) (hM : M = 256#32 ∨ M = 768#32 ∨ M = 65280#32)
    (hd : [base.i, cin.i, k128.i, k8.i, kM.i, gp.i, db.i, dz.i, da.i, da2.i, dc.i, dm.i, dsub.i,
      dd.i].Nodup)
    (hP : ¬P.offset.uaddOverflow (BitVec.ofNat 64 w))
    (hf : Fits S.mem (P.add (BitVec.ofNat 64 w)) 8)
    (hr : S.mem.readAt (P.add (BitVec.ofNat 64 w)) 8 = s.extractLsb' (8 * w) 8)
    (hK :
      ∀ (vgp : ⟦.ptr⟧) (vdb : ⟦.bv 8⟧) (vdz vda vda2 vdm vdsub : ⟦.bv 32⟧),
        (blk.runBodyFrom
              E[gp := vgp, db := vdb, dz := vdz, da := vda, da2 := vda2,
                dc := PoisonOr.value (carry8 s (w + 1)), dm := vdm, dsub := vdsub,
                dd := PoisonOr.value (recode8 s w)]
              (pos + 9) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  subst ho
  obtain ⟨C, hCe⟩ : ∃ C, carry8 s w = C := ⟨_, rfl⟩
  have hC : C ≤ 1#32 := by
    have := carry8_le s w
    rw [hCe] at this
    exact BitVec.le_def.2 (by simpa using this)
  rw [hCe] at hR
  step_pure [show (0 : Int) ≤ (w : Int) by omega, show ((w : Int)).toNat = w by omega,
    gep_value (f := { nusw := true, nuw := true }) hP (Or.inr (by simp; omega))]
  step_load with b
  have d := dig8 C _ M hC (zext_le b) hM
  step_pure
  step_pure [d]
  step_pure [d]
  step_pure
  step_pure
  step_pure [d]
  step_pure [d]
  have e := dig8_spec s w (x := BitVec.setWidth 32 b) hCe (by rw [byte_eq, hb]) hM
  rw [e.1, e.2] at hE
  subst hS hE
  exact hK _ _ _ _ _ _ _

/-- The spreading shuffle's indices: lane `8 k` from `kj[k]`, the others poison. -/
def kdPermList : List (Option (Fin (2 * 64))) :=
  (List.range 505).map fun i => if i % 8 = 0 then some (Fin.ofNat _ (i / 8)) else none

/-- `perm` is the spreading shuffle's. -/
def KdPerm (perm : Vector (Option (Fin (2 * 64))) 505) : Prop :=
  perm.toList = kdPermList

/-- `KdPerm` by evaluation. -/
instance (perm : Vector (Option (Fin (2 * 64))) 505) : Decidable (KdPerm perm) := by
  unfold KdPerm; infer_instance

/-- `maskedStore_eq` for lanes known where the mask is set (`V`'s there), poison elsewhere. -/
theorem maskedStore_eq' {env : ⟪Γ⟫} {s : GlobalState} {p : Pointer} {v : ⟦.vec l w⟧}
    {V : Vector (BitVec w) l} {M : Vector (BitVec 1) l}
    (hv : ∀ i : Fin l, M[i] = 1#1 → v[i] = .value V[i])
    (hroom :
      ∀ i : Fin l, M[i] = 1#1 →
        p.offset.toNat + i * (w / 8) < 2 ^ 64 ∧ Room s.mem (Operation.lanePtr p w i) w) :
    Operation.maskedStore (Γ := Γ) v (.value p) (Ty.wrap M) env s =
      .value (env, { s with mem := s.mem.maskedStoreAt p V M }) := by
  have hm : (Ty.wrap (t := .vec l 1) M).toList.any (·.isPoison) = false := by
    simp [Ty.wrap, Function.comp_def, PoisonOr.isPoison_value, Vector.any_eq_false]
  rw [run_maskedStore hm fun i hi => (hroom i (by simpa [Ty.wrap_vec] using hi)).1]
  unfold MemoryState.maskedStoreAt
  suffices h : ∀ (L : List (Fin l)) (s : GlobalState),
      (∀ i ∈ L, M[i] = 1#1 → Room s.mem (Operation.lanePtr p w i) w) →
      (L.foldlM (m := EffectM) (init := env) fun env (i : Fin l) =>
          if (Ty.wrap (t := .vec l 1) M)[i] = .value 1#1 then
            Operation.store (τ := .bv w) (.value (Operation.lanePtr p w i)) v[i] env
          else pure env) s =
        .value
          (env,
            { s with
              mem :=
                L.foldl
                  (fun m (i : Fin l) =>
                    if M[i] = 1#1 then m.storeAt (Operation.lanePtr p w i) V[i] else m)
                  s.mem }) from
    h _ s fun i _ hi => (hroom i hi).2
  intro L
  induction L with
  | nil => intro s _; rfl
  | cons i L ih =>
    intro s hL
    simp only [List.foldlM_cons, List.foldl_cons]
    by_cases hi : M[i] = 1#1
    · have hr := hL i List.mem_cons_self hi
      have hvi : (Ty.wrap (t := .vec l 1) M)[i] = .value 1#1 := by simpa [Ty.wrap_vec] using hi
      have hst :
          Operation.store (τ := .bv w) (.value (Operation.lanePtr p w i)) (.value V[i]) env s =
            .value (env, { s with mem := s.mem.storeAt (Operation.lanePtr p w i) V[i] }) :=
        run_store hr (Ty.flatten_bv _) rfl
      rw [ite_eq_left hvi, ite_eq_left hi, EffectM.bind_eq, hv i hi, hst]
      exact ih _ fun j hj hj' => (hL j (List.mem_cons_of_mem _ hj) hj').storeAt
    · have hvi : ¬(Ty.wrap (t := .vec l 1) M)[i] = .value 1#1 := by simpa [Ty.wrap_vec] using hi
      rw [ite_eq_right hvi, ite_eq_right hi, EffectM.bind_eq, EffectM.pure_eq]
      exact ih s fun j hj hj' => hL j (List.mem_cons_of_mem _ hj) hj'

/-- `kj` loaded as `<64 x i8>`, spread to every eighth lane of `<505 x i8>` by `perm`, and
stored into `kd`'s column under `mask`, 3 instructions. -/
def kdStoreRun (perm : Vector (Option (Fin (2 * 64))) 505) (p2 : Dst Γ .ptr)
    (pz : Dst Γ (.vec 64 8)) (kp : Dst Γ .ptr) (mask : Dst Γ (.vec 505 1)) (dv : Dst Γ (.vec 64 8))
    (ds : Dst Γ (.vec 505 8)) : List (Instr Γ) :=
  [.load dv (.val p2.i p2.h),
    .binop (.shufflevector perm) ds (.val dv.i dv.h) (.val pz.i pz.h),
    .maskedStore (.val ds.i ds.h) (.val kp.i kp.h) (.val mask.i mask.h)]

/-- Where the body at `pos` is `kdStoreRun`, `p2` holding `kj` (`D`) and `perm` spreading it:
running on gives `K` if it does from `pos + 3` with `kj` in `kd`'s column. -/
theorem runBodyFrom_kdStoreRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {perm : Vector (Option (Fin (2 * 64))) 505} {p2 : Dst Γ .ptr} {pz : Dst Γ (.vec 64 8)}
    {kp : Dst Γ .ptr} {mask : Dst Γ (.vec 505 1)} {dv : Dst Γ (.vec 64 8)}
    {ds : Dst Γ (.vec 505 8)} {rest : List (Instr Γ)} {Q KP : Pointer}
    {D : Vector (BitVec 8) 64} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = kdStoreRun perm p2 pz kp mask dv ds ++ rest)
    (hR : E ⊨ [p2 := Q, kp := KP, mask := kdMask])
    (hf : Fits S.mem Q 512) (hr : S.mem.readAt Q 512 = BitVec.packLanes D)
    (hperm : KdPerm perm)
    (hroom :
      ∀ i : Fin 505, kdMask[i] = 1#1 →
        KP.offset.toNat + i * (8 / 8) < 2 ^ 64 ∧ Room S.mem (Operation.lanePtr KP 8 i) 8)
    (hK :
      ∀ (vdv : ⟦.vec 64 8⟧) (vds : ⟦.vec 505 8⟧),
        (blk.runBodyFrom E[dv := vdv, ds := vds] (pos + 3)
              { S with
                mem := (S.mem.maskedStoreAt KP (Vector.ofFn fun i : Fin 505 => D[i.val / 8])
                  kdMask) } >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_load
  step_pure
  have hv (z : ⟦.vec 64 8⟧) : ∀ i : Fin 505, kdMask[i] = 1#1 →
      (Operation.shufflevector perm (Ty.wrap D) z)[i] =
        .value (Vector.ofFn fun i : Fin 505 => D[i.val / 8])[i] := by
    intro i hi
    have h8 : i.val % 8 = 0 := by
      by_contra h
      simp [kdMask, h] at hi
    have hp' : perm[i.val] = some ⟨i.val / 8, by omega⟩ := by
      have := congrArg (·[i.val]?) hperm
      simp only [Vector.getElem?_toList, kdPermList, List.getElem?_map, List.getElem?_range i.isLt,
        Option.map_some, h8, ↓reduceIte, Vector.getElem?_eq_getElem i.isLt] at this
      rw [Option.some_inj] at this
      rw [this, Option.some.injEq, Fin.ext_iff, Fin.val_ofNat]
      show i.val / 8 % (2 * 64) = i.val / 8
      omega
    simp only [Operation.shufflevector, Fin.getElem_fin, Vector.getElem_ofFn]
    split
    · rename_i idx h
      rw [hp'] at h
      cases h
      simp [Ty.wrap_vec, show i.val / 8 < 64 by omega]
    · rename_i h
      exact absurd hp' (h _)
  subst hS
  have h1 : (blk.body.drop (pos + 2))[0]? = some (.maskedStore (.val ds.i ds.h) (.val kp.i kp.h)
      (.val mask.i mask.h)) := by rw [hbody]; rfl
  rw [List.getElem?_drop, Nat.add_zero] at h1
  obtain ⟨hpos, hi⟩ := List.getElem?_eq_some_iff.1 h1
  rw [BasicBlock.runBodyFrom_step_of_run hpos
    (by
      rw [hi]
      simp (disch := decide) only [Instr.run, hE, Env.read_write_dst, Env.read_write_of_ty_ne,
        hR.2.1, hR.2.2]
      exact maskedStore_eq' (hv _) hroom)]
  subst hE
  exact hK _ _

end

meta section

open Lean Meta Elab Tactic in
/-- `kd_perm_fact h`: `h : Hidden (KdPerm perm)` for the shuffle of `verify_x8`'s `^bb82`, by the
kernel; `Hidden` keeps it from `simp`'s `decide`. -/
elab "kd_perm_fact " h:ident : tactic =>
  withMainContext do
    let some instrs ←
        MLIR.Tactic.blockInstrs? (mkConst ``_root_.Firedancer.Lane.Mlir.verify_x8.bb82)
      | throwError "`kd_perm_fact`: no `bb82` body"
    let some sh := instrs.findSome? fun x => x.find? fun e =>
        e.isAppOfArity ``BinOp.shufflevector 4 && (e.getArg! 1).nat? == some 505
      | throwError "`kd_perm_fact`: no shuffle"
    let p := mkApp (mkConst ``KdPerm) (sh.getArg! 3)
    let some pf ← MLIR.Tactic.kernelDecide? p | throwError "`kd_perm_fact`: false"
    let (_, g) ← (← getMainGoal).assertHypotheses
      #[{ userName := h.getId, type := mkApp (mkConst ``Hidden) p,
          value := mkApp2 (mkConst ``Hidden.mk) p pf }]
    replaceMainGoal [g]

end

end MLIR.Firedancer.Lane.VerifyX8
