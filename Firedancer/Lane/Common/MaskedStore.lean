module

public import MLIR.Run.Tactic

/-! `llvm.masked.store` of known lanes under a known mask: one store per set lane, first to last
(`maskedStoreAt`), and the one-instruction pattern `step_pattern` steps it by. -/

namespace MLIR

@[expose] public section

/-- `V`'s lanes stored where `M` sets them, lane `i` at `lanePtr p w i`, first to last. -/
def MemoryState.maskedStoreAt (m : MemoryState) (p : Pointer) {l w : Nat} (V : Vector (BitVec w) l)
    (M : Vector (BitVec 1) l) : MemoryState :=
  (List.finRange l).foldl
    (fun m (i : Fin l) => if M[i] = 1#1 then m.storeAt (Operation.lanePtr p w i) V[i] else m) m

/-- `foldl` of conditional stores: `P` kept when each store keeps it. -/
theorem MemoryState.foldl_storeAt_induct {α : Type} (P : MemoryState → Prop) (L : List α)
    (c : α → Prop) [DecidablePred c] (q : α → Pointer) {w : Nat} (x : α → BitVec w)
    (m : MemoryState) (hm : P m) (hs : ∀ m a, P m → c a → P (m.storeAt (q a) (x a))) :
    P (L.foldl (fun m a => if c a then m.storeAt (q a) (x a) else m) m) := by
  induction L generalizing m with
  | nil => exact hm
  | cons a L ih =>
    refine ih _ ?_
    by_cases h : c a
    · simp only [h, ite_true]; exact hs m a hm h
    · simp only [h, ite_false]; exact hm

/-- A masked store keeps `WF`. -/
@[mlir_transport]
theorem GlobalState.WF.maskedStoreAt {s : GlobalState} {p : Pointer} {V : Vector (BitVec w) l}
    {M : Vector (BitVec 1) l} (h : s.WF) : { s with mem := s.mem.maskedStoreAt p V M }.WF := by
  unfold MemoryState.maskedStoreAt
  exact MemoryState.foldl_storeAt_induct (fun m => ({ s with mem := m } : GlobalState).WF) _
    (fun i : Fin l => M[i] = 1#1) (fun i => Operation.lanePtr p w i) (fun i => V[i]) s.mem h
    fun m _ hm _ => GlobalState.WF.storeAt (s := { s with mem := m }) hm

/-- A masked store keeps `Room`. -/
@[mlir_transport]
theorem Room.maskedStoreAt {m : MemoryState} {p : Pointer} {V : Vector (BitVec v) l}
    {M : Vector (BitVec 1) l} (h : Room m q w) : Room (m.maskedStoreAt p V M) q w :=
  MemoryState.foldl_storeAt_induct (Room · q w) _ (fun i : Fin l => M[i] = 1#1)
    (fun i => Operation.lanePtr p v i) (fun i => V[i]) m h fun _ _ hm _ => hm.storeAt

/-- A masked store keeps `Fits`. -/
@[mlir_transport]
theorem Fits.maskedStoreAt {m : MemoryState} {p : Pointer} {V : Vector (BitVec v) l}
    {M : Vector (BitVec 1) l} (h : Fits m q w) : Fits (m.maskedStoreAt p V M) q w :=
  MemoryState.foldl_storeAt_induct (Fits · q w) _ (fun i : Fin l => M[i] = 1#1)
    (fun i => Operation.lanePtr p v i) (fun i => V[i]) m h fun _ _ hm _ => hm.storeAt

/-- Erasing a frame commutes with a masked store. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_maskedStoreAt {m : MemoryState} {p : Pointer}
    {V : Vector (BitVec w) l} {M : Vector (BitVec 1) l} :
    (m.maskedStoreAt p V M).eraseFrom n = (m.eraseFrom n).maskedStoreAt p V M := by
  unfold MemoryState.maskedStoreAt
  generalize List.finRange l = L
  induction L generalizing m with
  | nil => rfl
  | cons i L ih =>
    simp only [List.foldl_cons]
    rw [ih]
    split <;> simp only [MemoryState.eraseFrom_storeAt]

/-- `masked.store` of `V` under the mask `M`, with room for each set lane whose offset does not
wrap: `V`'s set lanes stored, first to last. -/
theorem maskedStore_eq {Γ : Ctx} {env : ⟪Γ⟫} {s : GlobalState} {p : Pointer}
    {V : Vector (BitVec w) l} {M : Vector (BitVec 1) l}
    (hroom :
      ∀ i : Fin l, M[i] = 1#1 →
        p.offset.toNat + i * (w / 8) < 2 ^ 64 ∧ Room s.mem (Operation.lanePtr p w i) w) :
    Operation.maskedStore (Γ := Γ) (Ty.wrap V) (.value p) (Ty.wrap M) env s =
      .value (env, { s with mem := s.mem.maskedStoreAt p V M }) := by
  have hm : (Ty.wrap (t := .vec l 1) M).toList.any (·.isPoison) = false := by
    simp [Ty.wrap, Function.comp_def, PoisonOr.isPoison_value, Vector.any_eq_false]
  rw [run_maskedStore hm fun i hi => (hroom i (by simpa [Ty.wrap_vec] using hi)).1]
  unfold MemoryState.maskedStoreAt
  suffices h : ∀ (L : List (Fin l)) (s : GlobalState),
      (∀ i ∈ L, M[i] = 1#1 → Room s.mem (Operation.lanePtr p w i) w) →
      (L.foldlM (m := EffectM) (init := env) fun env (i : Fin l) =>
          if (Ty.wrap (t := .vec l 1) M)[i] = .value 1#1 then
            Operation.store (τ := .bv w) (.value (Operation.lanePtr p w i))
              (Ty.wrap (t := .vec l w) V)[i] env
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
      have hv : (Ty.wrap (t := .vec l 1) M)[i] = .value 1#1 := by simpa [Ty.wrap_vec] using hi
      have hx : (Ty.wrap (t := .vec l w) V)[i] = .value V[i] := by simp [Ty.wrap_vec]
      have hst :
          Operation.store (τ := .bv w) (.value (Operation.lanePtr p w i)) (.value V[i]) env s =
            .value (env, { s with mem := s.mem.storeAt (Operation.lanePtr p w i) V[i] }) :=
        run_store hr (Ty.flatten_bv _) rfl
      rw [ite_eq_left hv, ite_eq_left hi, EffectM.bind_eq, hx, hst]
      exact ih _ fun j hj hj' => (hL j (List.mem_cons_of_mem _ hj) hj').storeAt
    · have hv : ¬(Ty.wrap (t := .vec l 1) M)[i] = .value 1#1 := by simpa [Ty.wrap_vec] using hi
      rw [ite_eq_right hv, ite_eq_right hi, EffectM.bind_eq, EffectM.pure_eq]
      exact ih s fun j hj hj' => hL j (List.mem_cons_of_mem _ hj) hj'

/-- `masked.store` of `v` at `p` under the mask `m`. -/
def maskedStoreRun {Γ : Ctx} {l w : Nat} (v : Reg Γ (.vec l w)) (p : Reg Γ .ptr)
    (m : Reg Γ (.vec l 1)) : List (Instr Γ) :=
  [.maskedStore v p m]

/-- Where the body at `pos` is `maskedStoreRun`, `v` holds `V`, `p` `P` and `m` `M`, with room for
each set lane: running on gives `K` if it does from `pos + 1` with `V`'s set lanes stored. -/
theorem runBodyFrom_maskedStoreRun {Γ : Ctx} {tRets : List Ty} {n : Nat} {bp : Fin n → List Ty}
    {β : Type} {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {v : Reg Γ (.vec l w)}
    {p : Reg Γ .ptr} {m : Reg Γ (.vec l 1)} {rest : List (Instr Γ)} {P : Pointer}
    {V : Vector (BitVec w) l} {M : Vector (BitVec 1) l} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = maskedStoreRun v p m ++ rest) (hR : E ⊨ [v := V, p := P, m := M])
    (hroom :
      ∀ i : Fin l, M[i] = 1#1 →
        P.offset.toNat + i * (w / 8) < 2 ^ 64 ∧ Room S.mem (Operation.lanePtr P w i) w)
    (hK :
      ∀ S' : GlobalState, S' = { S with mem := S.mem.maskedStoreAt P V M } →
        (blk.runBodyFrom E (pos + 1) S' >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have h1 : (blk.body.drop pos)[0]? = some (.maskedStore v p m) := by rw [hbody]; rfl
  rw [List.getElem?_drop, Nat.add_zero] at h1
  obtain ⟨hpos, hi⟩ := List.getElem?_eq_some_iff.1 h1
  rw [BasicBlock.runBodyFrom_step_of_run hpos
    (by rw [hi, Instr.run, hR.1, hR.2.1, hR.2.2]; exact maskedStore_eq hroom)]
  exact hK _ rfl

end

end MLIR
