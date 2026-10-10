
/-! ## Proof -/

section Proof

open slide

/-! ### `r` in memory -/

/-- A splice into a splice that covers it: one splice of the inner value. -/
theorem spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store inside a stored value: one store, the inner value spliced. -/
theorem storeAt_storeAt_add {m : MemoryState} {p : Pointer} {u : BitVec wu} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu) (y : BitVec wy) :
    (m.storeAt p u).storeAt (p.add off) y =
      m.storeAt p (Memory.spliceBits u (off.toNat * 8) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes wu) (off.toNat * 8) (BitVec.allOnes wy) =
      BitVec.allOnes wu := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  simp only [MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw, hones]

/-- Splicing byte `j` into 256 packed bytes sets it. -/
theorem spliceBits_packLanes {u : Vector (BitVec 8) 256} (hj : j < 256) (y : BitVec 8) :
    Memory.spliceBits (BitVec.packLanes u) (8 * j) y = BitVec.packLanes (u.set j y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  have hl :
    ∀ (v : Vector (BitVec 8) 256),
      (BitVec.packLanes v).getLsbD m = (v[m / 8]'(by omega)).getLsbD (m % 8) :=
    fun v => by
    have h := BitVec.extractLsb'_packLanes_of_lt v (s := m) (w := 1) (by omega) (by omega)
    simpa [BitVec.getLsbD_extractLsb'] using congrArg (·.getLsbD 0) h
  rw [Memory.getLsbD_spliceBits, hl, hl, Vector.getElem_set]
  by_cases h : m / 8 = j
  · subst h
    have hc : 8 * (m / 8) ≤ m ∧ m < 8 * (m / 8) + 8 ∧ m < 8 * 256 := by omega
    simp only [hc, and_self, ite_true]
    congr 1
    omega
  · have hc : ¬(8 * j ≤ m ∧ m < 8 * j + 8 ∧ m < 8 * 256) := by omega
    simp only [hc, ite_false, Ne.symm h]

/-- `r[j]`'s offset `j`, which does not wrap. -/
theorem byte_offset {r : Pointer} (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) :
    (BitVec.ofNat 64 j).toNat = j ∧ ¬r.offset.uaddOverflow (BitVec.ofNat 64 j) := by
  have h : (BitVec.ofNat 64 j).toNat = j := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  exact ⟨h, BitVec.not_uaddOverflow_of_le hov (by rw [h]; show j ≤ 256; omega)⟩

/-- `r[j]`, read from the stored digits. -/
theorem readAt_byte {m : MemoryState} {r : Pointer} {v : Vector (BitVec 8) 256}
    (hr : InBounds m r 2048) (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) :
    (m.storeAt r (BitVec.packLanes v)).readAt (r.add (BitVec.ofNat 64 j)) 8 = v[j] := by
  obtain ⟨h8, hov'⟩ := byte_offset hov hj
  rw [MemoryState.readAt_storeAt_add hr hov' (by omega), h8, Nat.mul_comm,
    BitVec.extractLsb'_packLanes v j hj]

/-- A store of `r[j]` into the stored digits: `r[j]` set. -/
theorem storeAt_byte {m : MemoryState} {r : Pointer} {v : Vector (BitVec 8) 256}
    (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) (y : BitVec 8) :
    (m.storeAt r (BitVec.packLanes v)).storeAt (r.add (BitVec.ofNat 64 j)) y =
      m.storeAt r (BitVec.packLanes (v.set j y)) := by
  obtain ⟨h8, hov'⟩ := byte_offset hov hj
  rw [storeAt_storeAt_add hov' (by rw [h8]; omega), h8, Nat.mul_comm, spliceBits_packLanes hj]

/-- The digits `v` stored at `r` over `S`. -/
abbrev st (S : GlobalState) (r : Pointer) (v : Vector (BitVec 8) 256) : GlobalState :=
  { S with mem := S.mem.storeAt r (BitVec.packLanes v) }

/-- The constants the `i` loop reads. -/
abbrev consts (E : ⟪slide.Γ⟫) : ⟪slide.Γ⟫ :=
  E[%207 := .value 3#64, %210 := .value 1#8, %211 := .value 1#64, %213 := .value 2#64,
    %214 := .value 256#64, %216 := .value 0#8, %217 := .value 255#64, %218 := .value 1#1,
    %219 := .value 5#32, %220 := .value 2#32, %221 := .value 1#32, %222 := .value 16#32,
    %223 := .value 4294967280#32, %224 := .value 0#32, %225 := .value 3#32, %226 := .value 4#32,
    %227 := .value 4#64, %228 := .value 5#64, %229 := .value 6#32, %230 := .value 4294967295#32]

/-- The `i` loop's registers at `i`: `%254` counts down from `254`. -/
abbrev hdrI (E : ⟪slide.Γ⟫) (i : Nat) : ⟪slide.Γ⟫ :=
  (consts E)[%253 := .value (BitVec.ofNat 64 i), %254 := .value (254#32 - BitVec.ofNat 32 i),
    %255 := .value (BitVec.ofNat 64 (i + 1))]

/-- The `b` loop's registers at `i`: `r + i`, and `%262 = min(254 - i, 5) + 2`. -/
abbrev hdrB (r : Pointer) (E : ⟪slide.Γ⟫) (i : Nat) : ⟪slide.Γ⟫ :=
  (hdrI E i)[%256 := .value (r.add (BitVec.ofNat 64 i)),
    %262 := .value (BitVec.ofNat 32 (min (254 - i) 5 + 2))]

/-- `^bb8`, the carry loop of `b = 1` from `k`: on to `^bb11` with `carry v k`. -/
theorem carry1_loop (r a : Pointer) (S : GlobalState) (hr : Room S.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (v : Vector (BitVec 8) 256) (E : ⟪slide.Γ⟫),
      E.args = (slide.args (.value r) (.value a)).get → k + n = 255 →
        (∀ E' : ⟪slide.Γ⟫, E'.args = E.args →
          slide.runFrom (hdrB r E' i) ^bb11 (st S r (carry v k)) = K) →
        slide.runFrom ((hdrB r E i)[%276 := .value (BitVec.ofNat 64 k)]) ^bb8 (st S r v) = K := by
  intro n
  induction n with
  | zero =>
    intro k v E hArgs hk hK
    block_init
    step_pure
    step_load
    trace_state
    sorry
  | succ n ih => sorry

end Proof

end MLIR.Boringssl
