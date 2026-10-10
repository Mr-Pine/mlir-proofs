/-! ### The bit loop -/

/-- The low `8 j` bits of the 256 bytes. -/
abbrev lowMask (j : Nat) : BitVec 2048 :=
  BitVec.allOnes 2048 >>> (2048 - 8 * j)

/-- `r` after the bit loop's first `j` stores over `Sb`: the bytes of `B` below `j`, `Sb`'s above,
defined as stored. -/
abbrev fill (Sb : GlobalState) (r : Pointer) (B : BitVec 2048) (j : Nat) : MemoryState :=
  Sb.mem.storeDef r (B &&& lowMask j ||| Sb.mem.readAt r 2048 &&& ~~~lowMask j)
    (lowMask j ||| Sb.mem.definedAt r 2048 &&& ~~~lowMask j)

/-- A store inside a range stored with definedness: one such store, both spliced. -/
theorem storeDef_storeAt_add {m : MemoryState} {p : Pointer} {u d : BitVec wu} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu) (y : BitVec wy) :
    (m.storeDef p u d).storeAt (p.add off) y =
      m.storeDef p (Memory.spliceBits u (off.toNat * 8) y)
        (Memory.spliceBits d (off.toNat * 8) (BitVec.allOnes wy)) := by
  simp only [MemoryState.storeAt, MemoryState.storeDef, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw]

/-- Before the loop: `Sb`'s memory. -/
theorem fill_zero {Sb : GlobalState} {r : Pointer} (hr : InBounds Sb.mem r 2048) (B : BitVec 2048) :
    fill Sb r B 0 = Sb.mem := by
  have h0 : lowMask 0 = 0#2048 := by
    apply BitVec.eq_of_getLsbD_eq
    intro k hk
    simp [BitVec.getLsbD_ushiftRight]
  simp only [fill, h0, BitVec.and_zero, BitVec.zero_or, BitVec.not_zero, BitVec.and_allOnes]
  exact MemoryState.storeDef_readAt_definedAt hr

/-- After it: `B` stored. -/
theorem fill_full {Sb : GlobalState} {r : Pointer} (B : BitVec 2048) :
    fill Sb r B 256 = Sb.mem.storeAt r B := by
  have h1 : lowMask 256 = BitVec.allOnes 2048 := by
    simp [lowMask]
  simp only [fill, h1, BitVec.and_allOnes, BitVec.not_allOnes, BitVec.and_zero, BitVec.or_zero]
  rfl

/-- The store of byte `j` of `B`: one byte more. -/
theorem fill_step {Sb : GlobalState} {r : Pointer} {B : BitVec 2048}
    (hov : ¬r.offset.uaddOverflow 256#64) (hj : j < 256) :
    (fill Sb r B j).storeAt (r.add (BitVec.ofNat 64 j)) (B.extractLsb' (j * 8) 8) =
      fill Sb r B (j + 1) := by
  obtain ⟨h8, hov'⟩ := byte_offset hov hj
  rw [storeDef_storeAt_add hov' (by rw [h8]; omega), h8]
  congr 1
  · apply BitVec.eq_of_getLsbD_eq
    intro k hk
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and,
      BitVec.getLsbD_not, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_allOnes,
      BitVec.getLsbD_extractLsb']
    by_cases h : j * 8 ≤ k ∧ k < j * 8 + 8 ∧ k < 2048
    · simp only [h, and_self, ite_true]
      simp [show k - j * 8 < 8 by omega, show j * 8 + (k - j * 8) = k by omega, hk,
        show 2048 - 8 * (j + 1) + k < 2048 by omega]
    · simp only [h, ite_false]
      simp [hk]
      grind
  · apply BitVec.eq_of_getLsbD_eq
    intro k hk
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and,
      BitVec.getLsbD_not, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_allOnes]
    by_cases h : j * 8 ≤ k ∧ k < j * 8 + 8 ∧ k < 2048
    · simp only [h, and_self, ite_true]
      simp [show k - j * 8 < 8 by omega, hk, show 2048 - 8 * (j + 1) + k < 2048 by omega]
    · simp only [h, ite_false]
      simp [hk]
      grind

/-- `a[i >> 3]`'s index. -/
theorem idx_eq (hj : j < 256) : BitVec.ofNat 64 j >>> 3 &&& 536870911#64 = BitVec.ofNat 64 (j / 8) := by
  have : ∀ j < 256, BitVec.ofNat 64 j >>> 3 &&& 536870911#64 = BitVec.ofNat 64 (j / 8) := by
    decide +kernel
  exact this j hj

/-- `a[k]`, read from the 32 bytes at `a`. -/
theorem readAt_a {m : MemoryState} {a : Pointer} (ha : InBounds m a 256)
    (hov : ¬a.offset.uaddOverflow 32#64) (hk : k < 32) :
    m.readAt (a.add (BitVec.ofNat 64 k)) 8 = (m.readAt a 256).extractLsb' (k * 8) 8 := by
  have h8 : (BitVec.ofNat 64 k).toNat = k := by
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]
  rw [MemoryState.readAt_add_of_readAt ha
      (BitVec.not_uaddOverflow_of_le hov (by rw [h8]; show k ≤ 32; omega)) (by rw [h8]; omega) rfl,
    h8]

/-- `i & 6` and `(i | 1) & 7` on an even `i`: `i % 8` and `(i + 1) % 8`. -/
theorem sh_eq : ∀ j < 256, j % 2 = 0 →
    BitVec.ofNat 8 j &&& 6#8 = BitVec.ofNat 8 (j % 8) ∧
      BitVec.ofNat 8 (j + 1) &&& 7#8 = BitVec.ofNat 8 ((j + 1) % 8) := by
  decide +kernel

/-- `i | 1` on an even `i`: `i + 1`. -/
theorem or_one (hj : j < 256) (he : j % 2 = 0) :
    BitVec.ofNat 64 j &&& 1#64 = 0#64 ∧ BitVec.ofNat 64 j ||| 1#64 = BitVec.ofNat 64 (j + 1) := by
  have : ∀ j < 256, j % 2 = 0 →
      BitVec.ofNat 64 j &&& 1#64 = 0#64 ∧ BitVec.ofNat 64 j ||| 1#64 = BitVec.ofNat 64 (j + 1) := by
    decide +kernel
  exact this j hj he

/-- `(a[i >> 3] >> (i & 7)) & 1` as the code computes it: byte `i` of the bits. -/
theorem bit_byte (A : BitVec 256) (hj : j < 256) (k : Nat) (hk : k = j / 8) :
    A.extractLsb' (k * 8) 8 >>> (j % 8) &&& 1#8 = (BitVec.packLanes (bits A)).extractLsb' (j * 8) 8 := by
  rw [BitVec.extractLsb'_packLanes (bits A) j hj]
  simp only [bits, Vector.getElem_ofFn, hk, Nat.mul_comm (j / 8), BitVec.and_comm]

/-- The shift amount `i % 8 < 8`. -/
theorem toNat_mod8 : (BitVec.ofNat 8 (j % 8)).toNat = j % 8 := by
  simp only [BitVec.toNat_ofNat]
  omega

/-- The constants the bit loop reads. -/
abbrev consts1 (E : ⟪slide.Γ⟫) : ⟪slide.Γ⟫ :=
  E[%206 := .value 0#64, %207 := .value 3#64, %208 := .value 536870911#64, %209 := .value 6#8,
    %210 := .value 1#8, %211 := .value 1#64, %212 := .value 7#8, %213 := .value 2#64,
    %214 := .value 256#64, %215 := .value 254#32, %216 := .value 0#8, %217 := .value 255#64,
    %218 := .value 0#1, %219 := .value 5#32, %220 := .value 2#32, %221 := .value 1#32,
    %222 := .value 16#32, %223 := .value 4294967280#32, %224 := .value 0#32, %225 := .value 3#32,
    %226 := .value 4#32, %227 := .value 4#64, %228 := .value 5#64, %229 := .value 6#32,
    %230 := .value 4294967295#32]

/-- `^bb1`, the bit loop from `j`, two bits a round: on to `^bb2` at `i = 0` with `bits A`. -/
theorem bits_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (ha : Fits Sb.mem a 256)
    (ha_off : ¬a.offset.uaddOverflow 32#64) (hsep : r.id ≠ a.id)
    (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n j (E : ⟪slide.Γ⟫),
      E.args = (slide.args (.value r) (.value a)).get → j + 2 * n = 254 → j % 2 = 0 →
        (∀ E' : ⟪slide.Γ⟫, E'.args = E.args →
          slide.runFrom (hdrI E' 0) ^bb2 (st Sb r (bits (Sb.mem.readAt a 256))) = K) →
        slide.runFrom ((consts1 E)[%231 := .value (BitVec.ofNat 64 j)]) ^bb1
          { Sb with mem := fill Sb r (BitVec.packLanes (bits (Sb.mem.readAt a 256))) j } = K := by
  intro n
  induction n with
  | zero =>
    intro j E hArgs hj he hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hj0 : j < 256 := by omega
    block_init
    step_pure
    step_pure
    step_pure [idx_eq hj0]
    have hk : j / 8 < 32 := by omega
    have hsh := sh_eq j hj0 he
    have hm : ¬8 ≤ j % 8 := by omega
    have hm' : ¬8 ≤ (j + 1) % 8 := by omega
    step_pure [Nat.mod_lt]
    step_load [readAt_a ha.inBounds ha_off hk]
    step_pure [hsh.1]
    step_pure [toNat_mod8, hm]
    step_pure
    step_pure [Nat.mod_lt]
    step_store
    rw [bit_byte _ hj0 _ rfl, fill_step hr_off hj0] at hS
    step_pure [(or_one hj0 he).1, (or_one hj0 he).2]
    step_pure
    step_pure
    step_pure [idx_eq hj0]
    step_pure [Nat.mod_lt]
    step_load [readAt_a ha.inBounds ha_off hk]
    step_pure [hsh.2]
    step_pure [toNat_mod8, hm']
    step_pure
    step_pure [Nat.mod_lt]
    step_store
    rw [bit_byte _ (show j + 1 < 256 by omega) (j / 8) (by omega),
      fill_step hr_off (show j + 1 < 256 by omega)] at hS
    step_pure [sadd64 (x := j) (c := 2) (by omega), uadd64 (x := j) (c := 2) (by omega),
      ← BitVec.ofNat_add]
    step_pure
    finish_block
    · rw [show j + 1 + 1 = 256 by omega, fill_full] at hS
      step_loop using hK
    · exact absurd (by rw [show j + 2 = 256 by omega]) hbr
  | succ n ih =>
    intro j E hArgs hj he hK
    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hj0 : j < 256 := by omega
    block_init
    step_pure
    step_pure
    step_pure [idx_eq hj0]
    have hk : j / 8 < 32 := by omega
    have hsh := sh_eq j hj0 he
    have hm : ¬8 ≤ j % 8 := by omega
    have hm' : ¬8 ≤ (j + 1) % 8 := by omega
    step_pure [Nat.mod_lt]
    step_load [readAt_a ha.inBounds ha_off hk]
    step_pure [hsh.1]
    step_pure [toNat_mod8, hm]
    step_pure
    step_pure [Nat.mod_lt]
    step_store
    rw [bit_byte _ hj0 _ rfl, fill_step hr_off hj0] at hS
    step_pure [(or_one hj0 he).1, (or_one hj0 he).2]
    step_pure
    step_pure
    step_pure [idx_eq hj0]
    step_pure [Nat.mod_lt]
    step_load [readAt_a ha.inBounds ha_off hk]
    step_pure [hsh.2]
    step_pure [toNat_mod8, hm']
    step_pure
    step_pure [Nat.mod_lt]
    step_store
    rw [bit_byte _ (show j + 1 < 256 by omega) (j / 8) (by omega),
      fill_step hr_off (show j + 1 < 256 by omega)] at hS
    step_pure [sadd64 (x := j) (c := 2) (by omega), uadd64 (x := j) (c := 2) (by omega),
      ← BitVec.ofNat_add]
    step_pure
    finish_block
    · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
    · step_loop using ih (j + 2) _ _ (by omega) (by omega)
      step_loop using hK

