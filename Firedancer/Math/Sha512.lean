module

public import Ed25519.Sha512
public import Firedancer.Ref.fd_ed25519_verify
import Std.Tactic.BVDecide

/-! `fd_ed25519_verify.hash` computes SHA-512: its digest's bytes are SHA-512 of
`r ‖ publicKey ‖ msg`, whatever `buf0` holds. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519
open Memory

/-! ## Bytes -/

section Bytes

public theorem bytesLE_bswap (x : BitVec 64) :
    bytesLE (fd_ulong_bswap.spec x) = (bytesLE x).reverse := by
  simp only [bytesLE, fd_ulong_bswap.spec, List.ofFn_succ, List.ofFn_zero, List.reverse_cons,
    List.reverse_nil, List.nil_append, List.cons_append, List.cons.injEq, Fin.val_succ,
    Fin.val_zero, and_true]
  bv_decide

/-- `copy` right past a known prefix `P` of `buf`'s bytes extends it by `x`'s. -/
public theorem take_bytesLE_copy {buf : BitVec 1024} {P : List (BitVec 8)}
    (hP : (bytesLE buf).take P.length = P) {off : BitVec 64} (hoff : off.toNat = P.length)
    {n : Nat} (x : BitVec (8 * n)) (hle : P.length + n ≤ 128) :
    (bytesLE (fd_sha512_append.copy buf off x)).take (P.length + n) = P ++ bytesLE x := by
  apply List.ext_getElem
  · simp only [length_bytesLE, List.length_take, List.length_append]; omega
  · intro i h1 h2
    simp only [length_bytesLE, List.length_take, List.length_append] at h1 h2
    rw [List.getElem_take, getElem_bytesLE, List.getElem_append, fd_sha512_append.copy, hoff]
    split
    · rw [extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega)]
      rw [← List.getElem_of_eq hP (by simp; omega), List.getElem_take, getElem_bytesLE]
    · rw [extractLsb'_spliceBits_of_subrange _ _ _ _ (by omega) (by omega) (by omega),
        getElem_bytesLE]
      congr 1
      omega

end Bytes

/-! ## `fd_sha512_core_ref` -/

namespace fd_sha512_core_ref

open Sha512 (schedule)

private theorem Sigma0_ref (x : BitVec 64) : Sigma0 x = Sha512.Sigma0 x := by
  simp only [Sigma0, Sha512.Sigma0, ROTR, fd_ulong_rotate_right.spec]; bv_decide

private theorem Sigma1_ref (x : BitVec 64) : Sigma1 x = Sha512.Sigma1 x := by
  simp only [Sigma1, Sha512.Sigma1, ROTR, fd_ulong_rotate_right.spec]; bv_decide

private theorem sigma0_ref (x : BitVec 64) : sigma0 x = Sha512.sigma0 x := by
  simp only [sigma0, Sha512.sigma0, ROTR, fd_ulong_rotate_right.spec]; bv_decide

private theorem sigma1_ref (x : BitVec 64) : sigma1 x = Sha512.sigma1 x := by
  simp only [sigma1, Sha512.sigma1, ROTR, fd_ulong_rotate_right.spec]; bv_decide

private theorem round_ref (v : Vector (BitVec 64) 8) (x k : BitVec 64) :
    round v x k = Sha512.round v k x := by
  have e (a b c d : BitVec 64) : x + a + b + c + d = a + b + c + d + x := by ac_rfl
  simp only [round, Sha512.round, Sigma0_ref, Sigma1_ref, e]
  rfl

private theorem word_ref (block : BitVec 1024) (h : t < 16) :
    Sha512.word (bytesLE block) t = fd_ulong_bswap.spec (block.extractLsb' (64 * t) 64) := by
  have e (b : Nat) (hb : b + 8 ≤ 64) :
      (block.extractLsb' (64 * t) 64).extractLsb' b 8 = block.extractLsb' (64 * t + b) 8 := by
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp [BitVec.getLsbD_extractLsb', show b + j < 64 by omega, Nat.add_assoc]
  simp (disch := omega) only [Sha512.word, getElem!_bytesLE, fd_ulong_bswap.spec, e]
  rw [show 8 * (8 * t) = 64 * t + 0 by omega, show 8 * (8 * t + 1) = 64 * t + 8 by omega,
    show 8 * (8 * t + 2) = 64 * t + 16 by omega, show 8 * (8 * t + 3) = 64 * t + 24 by omega,
    show 8 * (8 * t + 4) = 64 * t + 32 by omega, show 8 * (8 * t + 5) = 64 * t + 40 by omega,
    show 8 * (8 * t + 6) = 64 * t + 48 by omega, show 8 * (8 * t + 7) = 64 * t + 56 by omega]

private theorem K_ref (h : i < 80) : K[i] = Sha512.K[i]! := by
  rw [getElem!_pos Sha512.K i h]
  rfl

private theorem loop1_ref (block : BitVec 1024) (i : Nat) (v : Vector (BitVec 64) 8)
    (hi : i ≤ 16) :
    loop1 block i v = (List.range' i (16 - i)).foldl
      (fun v t => Sha512.round v Sha512.K[t]! (schedule (bytesLE block))[t]!) v := by
  rw [loop1]
  split
  · rename_i h
    rw [loop1_ref block (i + 1) _ (by omega), show 16 - i = 16 - (i + 1) + 1 by omega,
      List.range'_succ, List.foldl_cons, round_ref, K_ref (by omega),
      Sha512.getElem!_schedule_lt _ h, word_ref block h]
  · rw [show 16 - i = 0 by omega]
    rfl
termination_by 16 - i

private theorem loop2_ref (block : BitVec 1024) (i : Nat) (v : Vector (BitVec 64) 8)
    (X : Vector (BitVec 64) 16) (hi : 16 ≤ i) (hi' : i ≤ 80)
    (hX : ∀ j < 16, X[(i + j) % 16] = (schedule (bytesLE block))[i - 16 + j]!) :
    loop2 i v X = (List.range' i (80 - i)).foldl
      (fun v t => Sha512.round v Sha512.K[t]! (schedule (bytesLE block))[t]!) v := by
  rw [loop2]
  split
  · rename_i h
    have hx : xNext X i = (schedule (bytesLE block))[i]! := by
      have h0 := hX 0 (by omega)
      simp only [Nat.add_zero] at h0
      rw [xNext, sigma0_ref, sigma1_ref, h0, hX 1 (by omega), hX 9 (by omega), hX 14 (by omega),
        Sha512.getElem!_schedule_ge _ (by omega) h, show i - 16 + 1 = i - 15 by omega,
        show i - 16 + 9 = i - 7 by omega, show i - 16 + 14 = i - 2 by omega]
      have e (a b c d : BitVec 64) : a + (b + c + d) = c + d + b + a := by ac_rfl
      exact e _ _ _ _
    rw [loop2_ref block (i + 1) _ _ (by omega) (by omega), show 80 - i = 80 - (i + 1) + 1 by omega,
      List.range'_succ, List.foldl_cons, hx, round_ref, K_ref h]
    intro j hj
    rw [Vector.getElem_set]
    split
    · obtain rfl : j = 15 := by omega
      rw [hx, show i + 1 - 16 + 15 = i by omega]
    · have := hX (j + 1) (by omega)
      simp only [show i + (j + 1) = i + 1 + j by omega,
        show i - 16 + (j + 1) = i + 1 - 16 + j by omega] at this
      exact this
  · rw [show 80 - i = 0 by omega]
    rfl
termination_by 80 - i

/-- One block, its bytes read little-endian: FIPS compression. -/
public theorem compress_eq (state : Vector (BitVec 64) 8) (block : BitVec 1024) :
    compress state block = Sha512.compress state (bytesLE block) := by
  have hX : ∀ j < 16, (X0 block)[(16 + j) % 16] = (schedule (bytesLE block))[16 - 16 + j]! := by
    intro j hj
    simp only [show (16 + j) % 16 = j by omega, Nat.sub_self, Nat.zero_add, X0,
      Vector.getElem_ofFn, ← word_ref block hj, Sha512.getElem!_schedule_lt _ hj]
  have hr : List.range 80 = List.range' 0 16 ++ List.range' 16 64 := by
    rw [List.range_eq_range', List.range'_append]
  rw [compress, Sha512.compress, loop1_ref _ _ _ (by omega), loop2_ref _ _ _ _ (by omega) (by omega)
    hX]
  simp only [hr, List.foldl_append]
  generalize List.foldl _ _ _ = v
  ext i hi
  simp only [addWords, Vector.getElem_zipWith]
  match i, hi with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ => rfl

private theorem compressFrom_eq (data : BitVec w) (hw : w % 8 = 0) :
    ∀ n j st, 1024 * (j + n) ≤ w →
      compressFrom data j n st =
        Sha512.compressBlocks st (((bytesLE data).drop (128 * j)).take (128 * n))
  | 0, j, st, _ => by
    rw [compressFrom, Nat.mul_zero, List.take_zero, Sha512.compressBlocks_of_lt (by simp)]
  | n + 1, j, st, h => by
    rw [compressFrom, compressFrom_eq data hw n (j + 1) _ (by omega), compress_eq,
      bytesLE_extractLsb' _ (by omega) (by omega) (by omega),
      Sha512.compressBlocks_of_le (l := List.take (128 * (n + 1)) _)
        (by simp only [List.length_take, List.length_drop, length_bytesLE]; omega),
      List.take_take, List.drop_take, List.drop_drop, show 1024 * j / 8 = 128 * j by omega,
      show min 128 (128 * (n + 1)) = 1024 / 8 by omega, show 128 * (n + 1) - 128 = 128 * n by omega,
      show 128 * j + 128 = 128 * (j + 1) by omega]

/-- The code's blocks, their bytes read little-endian: FIPS compression of each in turn. -/
public theorem spec_eq (state : Vector (BitVec 64) 8) {n : Nat} (data : BitVec (1024 * n)) :
    fd_sha512_core_ref.spec state data = Sha512.compressBlocks state (bytesLE data) := by
  rw [fd_sha512_core_ref.spec, compressFrom_eq data (by omega) n 0 state (by omega), Nat.mul_zero,
    List.drop_zero, List.take_of_length_le (by simp; omega)]

/-- `spec_eq` on one block. -/
public theorem spec_one (state : Vector (BitVec 64) 8) (block : BitVec 1024) :
    fd_sha512_core_ref.spec (n := 1) state block =
      Sha512.compressBlocks state (bytesLE block) :=
  spec_eq (n := 1) state block

end fd_sha512_core_ref

/-! ## The hash object -/

/-- `sha` has absorbed the bytes `m`: their whole blocks compressed from `IV`, the rest buffered,
their bit length counted mod `2^128`. -/
public structure _root_.MLIR.ShaState.Absorbed (sha : ShaState) (m : List (BitVec 8)) :
    Prop where
  state : sha.state = Sha512.compressBlocks Sha512.IV m
  bufUsed : sha.bufUsed.toNat = m.length % 128
  buf : (bytesLE sha.buf).take (m.length % 128) = m.drop (m.length / 128 * 128)
  bitCnt : sha.bitCntHi ++ sha.bitCntLo = BitVec.ofNat 128 (8 * m.length)

/-- `init`'s object has absorbed nothing. -/
public theorem _root_.MLIR.ShaState.absorbed_init (buf0 : BitVec 1024) :
    ShaState.Absorbed ⟨buf0, sha512IV, 0#64, 0#64, 0#64⟩ [] := by
  refine ⟨?_, rfl, rfl, ?_⟩
  · rw [Sha512.compressBlocks_of_lt (by simp)]
    rfl
  · show 0#64 ++ 0#64 = 0#128
    exact BitVec.eq_of_toNat_eq (by simp)

namespace fd_sha512_append

private theorem toNat_and_127 (n : BitVec 64) : (n &&& 127#64).toNat = n.toNat % 128 := by
  rw [BitVec.toNat_and, show (127#64).toNat = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

private theorem toNat_ushiftRight_7 (n : BitVec 64) : (n >>> 7).toNat = n.toNat / 128 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- `append`'s bit count: 128-bit addition of `8 sz`. -/
private theorem bitCnt_add (hi lo sz : BitVec 64) :
    (hi + (sz >>> 61) + (BitVec.ofBool ((lo + (sz <<< 3)).ult lo)).setWidth 64) ++
        (lo + (sz <<< 3)) = (hi ++ lo) + BitVec.ofNat 128 (8 * sz.toNat) := by
  have e : BitVec.ofNat 128 (8 * sz.toNat) = sz.setWidth 128 <<< 3 := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_ofNat, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth]
    have := sz.isLt
    rw [Nat.mod_eq_of_lt (by omega), Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega),
      Nat.mod_eq_of_lt (by omega)]
    omega
  rw [e]
  bv_decide

private theorem leftover_state (s : ShaState) (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) :
    (leftover s sz data).state = s.state ∧ (leftover s sz data).bitCntHi = s.bitCntHi ∧
      (leftover s sz data).bitCntLo = s.bitCntLo := by
  unfold leftover
  dsimp only
  split <;> exact ⟨rfl, rfl, rfl⟩

/-- `leftover` from an empty buffer buffers the bytes past the whole blocks. -/
private theorem leftover_buf (s : ShaState) (sz : BitVec 64) (data : BitVec (8 * sz.toNat))
    (hu : s.bufUsed = 0#64) :
    (leftover s sz data).bufUsed.toNat = sz.toNat % 128 ∧
      (bytesLE (leftover s sz data).buf).take (sz.toNat % 128) =
        (bytesLE data).drop (sz.toNat / 128 * 128) := by
  unfold leftover
  dsimp only
  split
  · rename_i h
    have h127 := toNat_and_127 sz
    refine ⟨h127, ?_⟩
    have := take_bytesLE_copy (buf := s.buf) (P := []) (by simp) (off := 0#64) rfl
      (data.extractLsb' (1024 * (sz >>> 7).toNat) (8 * (sz &&& 127#64).toNat))
      (by rw [h127]; simp only [List.length_nil]; omega)
    rw [List.length_nil, Nat.zero_add, List.nil_append] at this
    have hs := toNat_ushiftRight_7 sz
    rw [← h127]
    dsimp only
    rw [this, bytesLE_extractLsb' _ (by omega) (by omega) (by rw [hs, h127]; omega), hs, h127,
      List.take_of_length_le (by simp; omega)]
    congr 1
    omega
  · rename_i h
    have h0 : sz.toNat % 128 = 0 := by
      rw [← toNat_and_127, Decidable.not_not.mp h]
      rfl
    refine ⟨by rw [hu, h0]; rfl, ?_⟩
    rw [h0, List.take_zero, eq_comm, List.drop_eq_nil_iff, length_bytesLE]
    omega

/-- `bulk` from an empty buffer, after whole blocks `m`, with the counts already added. -/
private theorem bulk_absorbed {sha : ShaState} {m : List (BitVec 8)} (sz : BitVec 64)
    (data : BitVec (8 * sz.toNat)) (hm : m.length % 128 = 0)
    (hs : sha.state = Sha512.compressBlocks Sha512.IV m) (hu : sha.bufUsed = 0#64)
    (hc : sha.bitCntHi ++ sha.bitCntLo = BitVec.ofNat 128 (8 * (m.length + sz.toNat))) :
    (bulk sha sz data).Absorbed (m ++ bytesLE data) := by
  have hD : (bytesLE data).length = sz.toNat := by simp
  have hb := toNat_ushiftRight_7 sz
  obtain ⟨s, hbulk, hss, hsu, hsh, hsl⟩ : ∃ s : ShaState, bulk sha sz data = leftover s sz data ∧
      s.state = Sha512.compressBlocks Sha512.IV (m ++ bytesLE data) ∧ s.bufUsed = 0#64 ∧
      s.bitCntHi = sha.bitCntHi ∧ s.bitCntLo = sha.bitCntLo := by
    refine ⟨_, rfl, ?_, ?_, ?_, ?_⟩ <;> try dsimp only
    · rw [Sha512.compressBlocks_append _ hm, ← hs, Sha512.compressBlocks_take, hD]
      split
      · show fd_sha512_core_ref.spec _ _ = _
        rw [fd_sha512_core_ref.spec_eq, bytesLE_setWidth _ (by omega) (by rw [hb]; omega), hb]
        congr 2
        omega
      · rename_i h
        have h0 : sz.toNat / 128 = 0 := by
          rw [← hb, Decidable.not_not.mp h]
          rfl
        rw [h0, Nat.zero_mul, List.take_zero, Sha512.compressBlocks_of_lt (by simp)]
    all_goals split <;> first | rfl | exact hu
  obtain ⟨h1, h2, h3⟩ := leftover_state s sz data
  obtain ⟨h4, h5⟩ := leftover_buf s sz data hsu
  have e1 : (m ++ bytesLE data).length % 128 = sz.toNat % 128 := by simp; omega
  have e2 : (m ++ bytesLE data).length / 128 * 128 = m.length + sz.toNat / 128 * 128 := by
    simp; omega
  rw [hbulk]
  refine ⟨h1.trans hss, by rw [h4, e1], ?_, ?_⟩
  · rw [e1, h5, e2, List.drop_length_add_append]
  · rw [h2, h3, hsh, hsl, hc, List.length_append, hD]

end fd_sha512_append

open fd_sha512_append in
/-- `append` absorbs `data`'s bytes. -/
public theorem _root_.MLIR.ShaState.Absorbed.append {sha : ShaState}
    {m : List (BitVec 8)} (h : sha.Absorbed m) (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) :
    (fd_sha512_append.spec sha sz data).Absorbed (m ++ bytesLE data) := by
  have hD : (bytesLE data).length = sz.toNat := by simp
  have hc := bitCnt_add sha.bitCntHi sha.bitCntLo sz
  rw [h.bitCnt, ← BitVec.ofNat_add, ← Nat.mul_add] at hc
  have hu := h.bufUsed
  unfold fd_sha512_append.spec
  dsimp only
  split
  · rename_i h0
    have : bytesLE data = [] := List.eq_nil_of_length_eq_zero (by rw [hD, h0]; rfl)
    rw [this, List.append_nil]
    exact h
  split
  · rename_i hsz hbu
    have hrem : (128#64 - sha.bufUsed).toNat = 128 - m.length % 128 := by
      rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hu]; simp; omega), hu]
      rfl
    have hL : 0 < m.length % 128 := by
      rw [← hu]
      have := mt BitVec.toNat_eq.mpr hbu
      simp only [BitVec.toNat_ofNat] at this
      omega
    have hP := h.buf
    have hPl : (m.drop (m.length / 128 * 128)).length = m.length % 128 := by simp; omega
    rw [← hPl] at hP
    split
    · rename_i hlt
      simp only [BitVec.ult, decide_eq_true_eq, hrem] at hlt
      have hcopy := take_bytesLE_copy hP (off := sha.bufUsed) (by rw [hu, hPl]) data
        (by rw [hPl]; omega)
      refine ⟨?_, ?_, ?_, by rw [List.length_append, hD]; exact hc⟩
      · show sha.state = _
        rw [h.state, Sha512.compressBlocks_append_short (by rw [hD]; omega)]
      · show (sha.bufUsed + sz).toNat = _
        rw [BitVec.toNat_add, hu]
        simp only [List.length_append, hD]
        omega
      · show (bytesLE (copy sha.buf sha.bufUsed data)).take ((m ++ bytesLE data).length % 128) = _
        rw [show (m ++ bytesLE data).length % 128 = (m.drop (m.length / 128 * 128)).length +
            sz.toNat by simp; omega, hcopy,
          show (m ++ bytesLE data).length / 128 * 128 = m.length / 128 * 128 by simp; omega,
          List.drop_append_of_le_length (by omega)]
    · rename_i hge
      simp only [BitVec.ult, decide_eq_true_eq, hrem, Nat.not_lt] at hge
      generalize hR : 128#64 - sha.bufUsed = R at *
      have hsub : (sz - R).toNat = sz.toNat - (128 - m.length % 128) := by
        rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hrem]; omega), hrem]
      have hcopy := take_bytesLE_copy hP (off := sha.bufUsed) (by rw [hu, hPl])
        (data.setWidth (8 * R.toNat)) (by rw [hPl, hrem]; omega)
      have hx : bytesLE (data.setWidth (8 * R.toNat)) = (bytesLE data).take (128 - m.length % 128)
          := by
        rw [bytesLE_setWidth _ (by omega) (by omega), hrem]
        congr 1
        omega
      rw [hx, show (m.drop (m.length / 128 * 128)).length + R.toNat = 128 by rw [hPl, hrem]; omega,
        List.take_of_length_le (by simp)] at hcopy
      have hy : bytesLE (data.extractLsb' (8 * R.toNat) (8 * (sz - R).toNat)) =
          (bytesLE data).drop (128 - m.length % 128) := by
        rw [bytesLE_extractLsb' _ (by omega) (by omega) (by rw [hsub, hrem]; omega), hsub, hrem,
          List.take_of_length_le (by simp)]
        congr 1
        omega
      rw [show m ++ bytesLE data = m ++ (bytesLE data).take (128 - m.length % 128) ++
          bytesLE (data.extractLsb' (8 * R.toNat) (8 * (sz - R).toNat)) by
        rw [hy, List.append_assoc, List.take_append_drop]]
      refine bulk_absorbed _ _ (by simp only [List.length_append, List.length_take, hD]; omega)
        ?_ rfl ?_
      · show fd_sha512_core_ref.spec (n := 1) sha.state (copy sha.buf sha.bufUsed _) = _
        rw [fd_sha512_core_ref.spec_one, hcopy]
        rw [h.state, Sha512.compressBlocks_take m]
        rw [show m ++ (bytesLE data).take (128 - m.length % 128) = m.take (m.length / 128 * 128) ++
            (m.drop (m.length / 128 * 128) ++ (bytesLE data).take (128 - m.length % 128)) by
          rw [← List.append_assoc, List.take_append_drop],
          Sha512.compressBlocks_append (a := m.take _) _ (by simp; omega)]
      · rw [hc]
        congr 2
        simp only [List.length_append, List.length_take, hD, hsub]
        omega
  · rename_i hsz hbu
    exact bulk_absorbed sz data (by rw [← hu, Decidable.not_not.mp hbu]; rfl) h.state
      (Decidable.not_not.mp hbu) hc

namespace fd_sha512_fini

open fd_sha512_append (copy)

/-- `last` after a known prefix `Q` of the buffer, `b = |Q|`: the block `Q`, zeros to byte 112,
the counts big-endian. -/
private theorem last_state (s : ShaState) (b : BitVec 64) (Q : List (BitVec 8))
    (hQ : (bytesLE s.buf).take Q.length = Q) (hb : b.toNat = Q.length) (hl : Q.length ≤ 112) :
    (last s b).state = Sha512.compressBlocks s.state (Q ++ List.replicate (112 - Q.length) 0#8 ++
      bytesLE (fd_ulong_bswap.spec s.bitCntHi) ++ bytesLE (fd_ulong_bswap.spec s.bitCntLo)) := by
  have hn : (112#64 - b).toNat = 112 - Q.length := by
    rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hb]; simp; omega), hb]
    rfl
  unfold last
  dsimp only
  rw [hn, fd_sha512_core_ref.spec_one]
  have h1 := take_bytesLE_copy hQ hb ((0#8).replicate (112 - Q.length)) (by omega)
  rw [bytesLE_replicate_zero, show Q.length + (112 - Q.length) =
    (Q ++ List.replicate (112 - Q.length) 0#8).length by simp] at h1
  have h2 := take_bytesLE_copy h1 (off := 112#64) (by simp; omega) (n := 8)
    (fd_ulong_bswap.spec s.bitCntHi) (by simp; omega)
  rw [show (Q ++ List.replicate (112 - Q.length) 0#8).length + 8 =
    (Q ++ List.replicate (112 - Q.length) 0#8 ++ bytesLE (fd_ulong_bswap.spec s.bitCntHi)).length
    by simp; omega] at h2
  have h3 := take_bytesLE_copy h2 (off := 120#64) (by simp; omega) (n := 8)
    (fd_ulong_bswap.spec s.bitCntLo) (by simp; omega)
  rw [show (Q ++ List.replicate (112 - Q.length) 0#8 ++
      bytesLE (fd_ulong_bswap.spec s.bitCntHi)).length + 8 = 128 by simp; omega,
    List.take_of_length_le (by simp)] at h3
  rw [h3]

/-- The counts' words byte-swapped: the bit length big-endian. -/
private theorem bytesBE_append (hi lo : BitVec 64) :
    Sha512.bytesBE (hi ++ lo) =
      bytesLE (fd_ulong_bswap.spec hi) ++ bytesLE (fd_ulong_bswap.spec lo) := by
  rw [Sha512.bytesBE, bytesLE_append _ _ (by decide), List.reverse_append, bytesLE_bswap,
    bytesLE_bswap]

/-- The digest's bytes: the state's words big-endian. -/
private theorem bytesLE_bits_bswap (v : Vector (BitVec 64) 8) :
    bytesLE (Words8.bits (v.map fd_ulong_bswap.spec)) = v.toList.flatMap Sha512.bytesBE := by
  obtain ⟨⟨l⟩, hl⟩ := v
  match l, hl with
  | [a, b, c, d, e, f, g, h], _ =>
    simp only [Words8.bits, Vector.map_mk, Vector.getElem_mk, List.map_toArray, List.map_cons,
      List.map_nil, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
    rw [bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide)]
    simp [bytesLE_bswap, Sha512.bytesBE]

end fd_sha512_fini

open fd_sha512_fini in
/-- `fini` on an object that absorbed `m`: the digest's bytes are SHA-512 of `m`. -/
public theorem _root_.MLIR.ShaState.Absorbed.fini {sha : ShaState} {m : List (BitVec 8)}
    (h : sha.Absorbed m) : bytesLE (Words8.bits (fd_sha512_fini.spec sha).2) = Sha512.digest m := by
  rw [Sha512.digest]
  suffices hs :
      (fd_sha512_fini.spec sha).1.state = Sha512.compressBlocks Sha512.IV (Sha512.pad m) by
    rw [← hs, ← bytesLE_bits_bswap]
    rfl
  have hu := h.bufUsed
  have hP := h.buf
  have hPl : (m.drop (m.length / 128 * 128)).length = m.length % 128 := by simp; omega
  rw [← hPl] at hP
  have h80 := take_bytesLE_copy hP (off := sha.bufUsed) (by rw [hu, hPl]) (n := 1) 0x80#8
    (by rw [hPl]; omega)
  rw [show bytesLE 0x80#8 = [0x80#8] from rfl] at h80
  have hb1 : (sha.bufUsed + 1#64).toNat = m.length % 128 + 1 := by
    rw [BitVec.toNat_add, hu]; simp; omega
  have hst : sha.state = Sha512.compressBlocks Sha512.IV (m.take (m.length / 128 * 128)) := by
    rw [h.state, Sha512.compressBlocks_take]
  rw [Sha512.pad, ← h.bitCnt, bytesBE_append]
  generalize hk : (239 - m.length % 128) % 128 = k
  have e := List.take_append_drop (m.length / 128 * 128) m
  simp only [List.append_assoc]
  rw [show ∀ X : List (BitVec 8), m ++ X = m.take (m.length / 128 * 128) ++
      (m.drop (m.length / 128 * 128) ++ X) by intro X; rw [← List.append_assoc, e],
    Sha512.compressBlocks_append (a := m.take _) _ (by simp; omega), ← hst]
  generalize m.drop (m.length / 128 * 128) = P at *
  clear e hst
  have hr : m.length % 128 < 128 := Nat.mod_lt _ (by decide)
  generalize m.length % 128 = r at *
  have h80' : (bytesLE (fd_sha512_append.copy sha.buf sha.bufUsed 128#8)).take
      (P ++ [128#8]).length = P ++ [128#8] := by
    rw [List.length_append, List.length_singleton]
    exact h80
  have h112 : (112#64).toNat = 112 := rfl
  unfold fd_sha512_fini.spec
  dsimp only
  split
  · rename_i hlt
    simp only [BitVec.ult, decide_eq_true_eq, hb1, h112] at hlt
    have hn : (128#64 - (sha.bufUsed + 1#64)).toNat = 127 - r := by
      rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hb1]; simp; omega), hb1]
      simp
    rw [hn]
    have h2 := take_bytesLE_copy h80' (off := sha.bufUsed + 1#64) (by rw [hb1]; simp; omega)
      ((0#8).replicate (127 - r)) (by simp; omega)
    rw [bytesLE_replicate_zero, show (P ++ [128#8]).length + (127 - r) = 128 by simp; omega,
      List.take_of_length_le (by simp)] at h2
    rw [last_state _ _ [] (by simp) (by simp) (by simp)]
    dsimp only
    rw [fd_sha512_core_ref.spec_one, h2, ← Sha512.compressBlocks_append _ (by simp; omega),
      show k = 127 - r + 112 by omega, List.replicate_add]
    simp only [List.append_assoc, List.nil_append, List.length_nil, Nat.sub_zero,
      List.cons_append]
  · rename_i hge
    simp only [BitVec.ult, decide_eq_true_eq, hb1, h112, Nat.not_lt] at hge
    rw [last_state _ _ (P ++ [128#8]) h80' (by rw [hb1]; simp; omega) (by simp; omega)]
    dsimp only
    rw [show k = 112 - (P ++ [128#8]).length by simp; omega]
    simp only [List.append_assoc, List.cons_append]

/-! ## `fd_ed25519_verify`'s hash -/

/-- `fd_ed25519_verify`'s digest is SHA-512 of `r ‖ publicKey ‖ msg`, whatever `buf0` holds. -/
public theorem fd_ed25519_verify.hash_eq (buf0 : BitVec 1024) (r publicKey : BitVec 256)
    (msgSz : BitVec 64) (msg : BitVec (8 * msgSz.toNat)) :
    bytesLE (Words8.bits (fd_ed25519_verify.hash buf0 r publicKey msgSz msg).2) =
      Sha512.digest (bytesLE r ++ bytesLE publicKey ++ bytesLE msg) := by
  have h := (((ShaState.absorbed_init buf0).append 32#64 r).append 32#64 publicKey).append msgSz msg
  rw [List.nil_append] at h
  exact h.fini

end MLIR.Firedancer.Ref
