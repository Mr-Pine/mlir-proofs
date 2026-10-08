
/-! ## Memory through the loops -/

theorem readAt_stores_ne {m : MemoryState} (h : q.id ≠ W.id) :
    ∀ n i, (stores W f i n m).readAt q w = m.readAt q w := by
  intro n
  induction n generalizing m with
  | zero => intro _; rfl
  | succ n ih =>
    intro i
    rw [stores, ih, MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using h.symm))]

theorem wf_stores {s : GlobalState} :
    ∀ n i (m : MemoryState), ({ s with mem := m } : GlobalState).WF →
      ({ s with mem := stores W f i n m } : GlobalState).WF := by
  intro n
  induction n with
  | zero => intro _ _ h; exact h
  | succ n ih => intro i m h; exact ih (i + 1) _ (GlobalState.WF_storeAt.2 h)

theorem eraseFrom_stores {m : MemoryState} (h : k ≤ W.id.id) :
    ∀ n i, (stores W f i n m).eraseFrom k = m.eraseFrom k := by
  intro n
  induction n generalizing m with
  | zero => intro _; rfl
  | succ n ih =>
    intro i
    rw [stores, ih, MemoryState.eraseFrom_storeAt_of_le (by simpa using h)]

theorem HoldsW.congr {m : MemoryState} {f g : Nat → BitVec 64} (h : HoldsW m W f n)
    (hfg : ∀ t, t < n → f t = g t) : HoldsW m W g n := fun t ht => (h t ht).trans (hfg t ht)

theorem holdsW_zero {m : MemoryState} : HoldsW m W f 0 := fun _ h => absurd h (by omega)

theorem storeWords8_eq (m : MemoryState) (V : Pointer) (v : Vector (BitVec 64) 8) :
    storeWords8 m V v = stores V (fun k => v[k]!) 0 8 m := by
  simp [storeWords8, stores]

/-! ## The spec's words -/

theorem bswapv_eq (x : BitVec 64) :
    bswapv x = x.extractLsb' 0 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 24 8 ++
      x.extractLsb' 32 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 56 8 := by
  simp only [bswapv, List.range, List.range.loop, List.foldl]
  bv_decide

/-- Block word `t`, big-endian: the code's byte swap of its little-endian load. -/
theorem word_eq (B : BitVec 1024) (ht : t < 16) :
    Sha512.word (bytesLE B) t = bswapv (B.extractLsb' (64 * t) 64) := by
  have e (b : Nat) (hb : b + 8 ≤ 64) :
      (B.extractLsb' (64 * t) 64).extractLsb' b 8 = B.extractLsb' (64 * t + b) 8 := by
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp [BitVec.getLsbD_extractLsb', show b + j < 64 by omega, Nat.add_assoc]
  simp (disch := omega) only [Sha512.word, getElem!_bytesLE, bswapv_eq, e]
  rw [show 8 * (8 * t) = 64 * t + 0 by omega, show 8 * (8 * t + 1) = 64 * t + 8 by omega,
    show 8 * (8 * t + 2) = 64 * t + 16 by omega, show 8 * (8 * t + 3) = 64 * t + 24 by omega,
    show 8 * (8 * t + 4) = 64 * t + 32 by omega, show 8 * (8 * t + 5) = 64 * t + 40 by omega,
    show 8 * (8 * t + 6) = 64 * t + 48 by omega, show 8 * (8 * t + 7) = 64 * t + 56 by omega]

/-- The compression's word `j`: the state word plus the rounds'. -/
theorem compress_getElem (H : Vector (BitVec 64) 8) (B : List (BitVec 8)) (hj : j < 8) :
    (Sha512.compress H B)[j] = H[j] + (rounds (fun t => (Sha512.schedule B)[t]!) 0 80 H)[j] := by
  simp only [Sha512.compress, rounds, Vector.getElem_zipWith, List.range_eq_range']

theorem eraseFrom_storeWords {m : MemoryState} :
    ∀ n i, (Sha512Obj.storeWords d f i n m).eraseFrom k = Sha512Obj.storeWords d f i n (m.eraseFrom k) := by
  intro n
  induction n generalizing m with
  | zero => intro _; rfl
  | succ n ih => intro i; rw [Sha512Obj.storeWords, ih, MemoryState.eraseFrom_storeAt]; rfl

theorem storeWords_congr {m : MemoryState} {f g : Nat → BitVec 64} :
    ∀ n i, (∀ j, i ≤ j → j < i + n → f j = g j) →
      Sha512Obj.storeWords d f i n m = Sha512Obj.storeWords d g i n m := by
  intro n
  induction n generalizing m with
  | zero => intro _ _; rfl
  | succ n ih =>
    intro i h
    simp only [Sha512Obj.storeWords]
    rw [h i (by omega) (by omega)]
    exact ih (i + 1) fun j h1 h2 => h j (by omega) (by omega)

theorem compress_getElem! (H : Vector (BitVec 64) 8) (B : List (BitVec 8)) (hj : j < 8) :
    (Sha512.compress H B)[j]! = H[j]! + (rounds (fun t => (Sha512.schedule B)[t]!) 0 80 H)[j]! := by
  rw [getElem!_pos (Sha512.compress H B) j hj, getElem!_pos H j hj,
    getElem!_pos (rounds _ 0 80 H) j hj]
  exact compress_getElem H B hj
