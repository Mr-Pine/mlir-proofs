module

public import Ed25519.Sha512
public import Firedancer.Math.Sha512
public import Sodium.crypto_hash_sha512_init
public import Sodium.crypto_hash_sha512_update
public import Sodium.crypto_hash_sha512_final
import Std.Tactic.BVDecide

/-! The SHA-512 that `crypto_hash_sha512_init`, `crypto_hash_sha512_update` and
`crypto_hash_sha512_final` compute: after an init and updates, the final digest's bytes are SHA-512
of the bytes appended. -/


namespace MLIR.Sodium

open _root_.Ed25519
open Memory
open Firedancer.Ref (take_bytesLE_copy bytesLE_bswap)

/-! ## The hash object -/

/-- `v` has absorbed the bytes `m`: their whole blocks compressed from `IV`, the rest buffered and
known, their bit length counted mod `2 ^ 128`. -/
public structure HashState.Absorbed (v : HashState) (m : List (BitVec 8)) : Prop where
  state : v.state = Sha512.compressBlocks Sha512.IV m
  count : v.count0 ++ v.count1 = BitVec.ofNat 128 (8 * m.length)
  buf : (bytesLE v.buf).take (m.length % 128) = m.drop (m.length / 128 * 128)
  pre : v.Prefix (m.length % 128)

/-- The bytes buffered, as the code computes them from `count[1]`. -/
public theorem HashState.Absorbed.r_eq {v : HashState} {m : List (BitVec 8)} (h : v.Absorbed m) :
    v.count1.toNat / 8 % 128 = m.length % 128 := by
  have e : v.count1 = (BitVec.ofNat 128 (8 * m.length)).setWidth 64 := by
    rw [← h.count]; bv_decide
  rw [e, BitVec.toNat_setWidth, BitVec.toNat_ofNat]
  rw [Nat.mod_mod_of_dvd _ (by decide : 2 ^ 64 ∣ 2 ^ 128)]
  omega

/-- The buffered bytes are known: `update`'s and `final`'s precondition. -/
public theorem HashState.Absorbed.prefix {v : HashState} {m : List (BitVec 8)} (h : v.Absorbed m) :
    v.Prefix (v.count1.toNat / 8 % 128) := by
  rw [h.r_eq]; exact h.pre

/-- `init`'s object has absorbed nothing, whatever `buf` holds. -/
public theorem HashState.absorbed_init (v : HashState) :
    (crypto_hash_sha512_init.spec v).Absorbed [] := by
  refine ⟨?_, ?_, rfl, HashState.prefix_zero _⟩
  · rw [Sha512.compressBlocks_of_lt (by simp)]
    rfl
  · show 0#64 ++ 0#64 = 0#128
    exact BitVec.eq_of_toNat_eq (by simp)

namespace crypto_hash_sha512_update

/-- The count: 128-bit addition of the bit length. -/
theorem count_add (c0 c1 len : BitVec 64) :
    (c0 + BitVec.setWidth 64 (BitVec.ofBool ((c1 + len <<< 3).ult (len <<< 3))) + len >>> 61) ++
        (c1 + len <<< 3) =
      (c0 ++ c1) + (len.setWidth 128 <<< 3) := by
  bv_decide

theorem count_add_ofNat (n : Nat) (len : BitVec 64) :
    BitVec.ofNat 128 (8 * n) + (len.setWidth 128 <<< 3) =
      BitVec.ofNat 128 (8 * (n + len.toNat)) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_add, BitVec.toNat_ofNat, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth,
    Nat.shiftLeft_eq]
  rw [Nat.mod_eq_of_lt (a := len.toNat) (by omega)]
  omega

theorem counted_count {v : HashState} {m : List (BitVec 8)} (h : v.Absorbed m) (len : BitVec 64) :
    (counted v len).count0 ++ (counted v len).count1 =
      BitVec.ofNat 128 (8 * (m.length + len.toNat)) := by
  simp only [counted]
  rw [count_add, h.count, count_add_ofNat]

/-- `j` blocks from byte `a`: their compression. -/
theorem blocks_eq {n : Nat} (D : BitVec (8 * n)) :
    ∀ (j a : Nat) (h : Vector (BitVec 64) 8), a + 128 * j ≤ n →
      blocks h D a j = Sha512.compressBlocks h (((bytesLE D).drop a).take (128 * j))
  | 0, a, h, _ => by
    rw [blocks, Nat.mul_zero, List.take_zero, Sha512.compressBlocks_of_lt (by simp)]
  | j + 1, a, h, hj => by
    have hl : 128 ≤ (((bytesLE D).drop a).take (128 * (j + 1))).length := by
      simp; omega
    rw [blocks, blocks_eq D j (a + 128) _ (by omega), Sha512.compressBlocks_of_le hl,
      List.take_take, List.drop_take, List.drop_drop, SHA512_Transform.spec,
      bytesLE_extractLsb' _ (by omega) (by omega) (by omega),
      show 1024 / 8 = 128 from rfl, show 8 * a / 8 = a by omega,
      show min 128 (128 * (j + 1)) = 128 by omega, show 128 * (j + 1) - 128 = 128 * j by omega]

/-- A whole block's compression. -/
theorem compressBlocks_block {H : Vector (BitVec 64) 8} {B : List (BitVec 8)}
    (hB : B.length = 128) : Sha512.compressBlocks H B = Sha512.compress H B := by
  rw [Sha512.compressBlocks_of_le (by omega), Sha512.compressBlocks_of_lt (by simp; omega),
    List.take_of_length_le (by omega)]

end crypto_hash_sha512_update

open crypto_hash_sha512_update in
/-- `update` absorbs `D`'s bytes. -/
public theorem HashState.Absorbed.update {v : HashState} {m : List (BitVec 8)} (h : v.Absorbed m)
    (len : BitVec 64) (D : BitVec (8 * len.toNat)) :
    (crypto_hash_sha512_update.spec v len D).Absorbed (m ++ bytesLE D) := by
  have hD : (bytesLE D).length = len.toNat := by simp
  have hr := h.r_eq
  have hP := h.buf
  have hPl : (m.drop (m.length / 128 * 128)).length = m.length % 128 := by
    simp; omega
  rw [← hPl] at hP
  have hoff :
      (BitVec.ofNat 64 (m.length % 128)).toNat = (m.drop (m.length / 128 * 128)).length := by
    rw [hPl, BitVec.toNat_ofNat]; omega
  have hst : v.state = Sha512.compressBlocks Sha512.IV (m.take (m.length / 128 * 128)) := by
    rw [h.state, Sha512.compressBlocks_take]
  have hcount := counted_count h len
  unfold crypto_hash_sha512_update.spec
  by_cases h0 : len = 0#64
  · have : bytesLE D = [] :=
      List.eq_nil_of_length_eq_zero (by rw [hD, h0]; rfl)
    rw [ite_eq_left h0, this, List.append_nil]
    exact h
  rw [ite_eq_right h0]
  dsimp only
  rw [hr]
  by_cases hs : len.toNat < 128 - m.length % 128
  · rw [ite_eq_left hs]
    have hcopy := take_bytesLE_copy hP hoff D (by rw [hPl]; omega)
    refine ⟨?_, ?_, ?_, ?_⟩
    · show v.state = _
      rw [h.state, Sha512.compressBlocks_append_short (by rw [hD]; omega)]
    · exact hcount.trans (by rw [List.length_append, hD])
    · show (bytesLE (Firedancer.Ref.fd_sha512_append.copy v.buf _ D)).take _ = _
      rw [show (m ++ bytesLE D).length % 128 = (m.drop (m.length / 128 * 128)).length + len.toNat
          by simp; omega, hcopy,
        show (m ++ bytesLE D).length / 128 * 128 = m.length / 128 * 128 by simp; omega,
        List.drop_append_of_le_length (by omega)]
    · have := h.pre.fill (hoff.trans hPl) D (j := len.toNat) rfl (by omega)
      rw [show (m ++ bytesLE D).length % 128 = m.length % 128 + len.toNat by simp; omega]
      exact this
  · rw [ite_eq_right hs]
    have hs' : 128 - m.length % 128 ≤ len.toNat := by omega
    generalize ha : 128 - m.length % 128 = a at hs'
    -- the buffered block filled, compressed
    have hcopy := take_bytesLE_copy hP hoff (D.setWidth (8 * a)) (by rw [hPl]; omega)
    rw [bytesLE_setWidth _ (by omega) (by omega), show 8 * a / 8 = a by omega,
      show (m.drop (m.length / 128 * 128)).length + a = 128 by rw [hPl]; omega,
      List.take_of_length_le (by simp)] at hcopy
    generalize hB : m.drop (m.length / 128 * 128) ++ (bytesLE D).take a = B at hcopy
    have hBl : B.length = 128 := by rw [← hB]; simp; omega
    have hq : a + 128 * ((len.toNat - a) / 128) ≤ len.toNat := by omega
    have hstate :
        blocks (SHA512_Transform.spec v.state
            (Firedancer.Ref.fd_sha512_append.copy v.buf (BitVec.ofNat 64 (m.length % 128))
              (D.setWidth (8 * a)))) D a ((len.toNat - a) / 128) =
          Sha512.compressBlocks Sha512.IV (m ++ bytesLE D) := by
      have e : m ++ bytesLE D = m.take (m.length / 128 * 128) ++ (B ++ (bytesLE D).drop a) := by
        rw [← hB, List.append_assoc, List.take_append_drop, ← List.append_assoc,
          List.take_append_drop]
      rw [blocks_eq D _ _ _ hq, SHA512_Transform.spec, hcopy, ← compressBlocks_block hBl, hst, e,
        Sha512.compressBlocks_append _ (by simp; omega), Sha512.compressBlocks_append _ (by omega),
        Sha512.compressBlocks_take ((bytesLE D).drop a)]
      congr 2
      simp [hD]
      omega
    have hL : (m ++ bytesLE D).length = m.length + len.toNat := by simp
    have hmod : (m.length + len.toNat) % 128 = (len.toNat - a) % 128 := by omega
    have hdiv : (m.length + len.toNat) / 128 * 128 =
        m.length + (a + 128 * ((len.toNat - a) / 128)) := by omega
    have hcount' : (counted v len).count0 ++ (counted v len).count1 =
        BitVec.ofNat 128 (8 * (m ++ bytesLE D).length) := by rw [hcount, hL]
    split_ifs with ht
    · refine ⟨hstate, hcount', ?_, ?_⟩
      · rw [hL, hmod, ht, List.take_zero, eq_comm, List.drop_eq_nil_iff]
        omega
      · rw [hL, hmod, ht]
        exact HashState.prefix_zero _
    · have hcopy2 := take_bytesLE_copy (buf := Firedancer.Ref.fd_sha512_append.copy v.buf
          (BitVec.ofNat 64 (m.length % 128)) (D.setWidth (8 * a))) (P := []) (by simp)
        (off := 0#64) rfl
        (D.extractLsb' (8 * (a + 128 * ((len.toNat - a) / 128))) (8 * ((len.toNat - a) % 128)))
        (by simp; omega)
      rw [List.length_nil, Nat.zero_add, List.nil_append,
        bytesLE_extractLsb' _ (by omega) (by omega) (by omega)] at hcopy2
      refine ⟨hstate, hcount', ?_, ?_⟩
      · show (bytesLE (Firedancer.Ref.fd_sha512_append.copy
          (Firedancer.Ref.fd_sha512_append.copy v.buf _ _) 0#64 _)).take _ = _
        rw [hL, hmod, hcopy2, hdiv, List.drop_append,
          show 8 * (a + 128 * ((len.toNat - a) / 128)) / 8 =
            a + 128 * ((len.toNat - a) / 128) by omega,
          show 8 * ((len.toNat - a) % 128) / 8 = (len.toNat - a) % 128 by omega]
        rw [List.take_of_length_le (by simp [hD]; omega),
          List.drop_eq_nil_of_le (as := m) (by omega),
          List.nil_append, Nat.add_sub_cancel_left]
      · rw [hL, hmod]
        have key : ∀ u : HashState,
            (u.fill 0#64 (D.extractLsb' (8 * (a + 128 * ((len.toNat - a) / 128)))
              (8 * ((len.toNat - a) % 128)))).Prefix ((len.toNat - a) % 128) := fun u => by
          have := (HashState.prefix_zero u).fill (off := 0#64) rfl
            (D.extractLsb' (8 * (a + 128 * ((len.toNat - a) / 128))) (8 * ((len.toNat - a) % 128)))
            (j := (len.toNat - a) % 128) rfl (by omega)
          rwa [Nat.zero_add] at this
        exact key _

namespace SHA512_Pad

theorem bytesLE_cast {x : BitVec v} (h : v = w) : bytesLE (x.cast h) = bytesLE x := by
  subst h; rfl

/-- The digest's bytes: the state's words big-endian. -/
theorem bytesLE_digest (H : Vector (BitVec 64) 8) :
    bytesLE (wordsLE (fun i => store64_be.spec H[i]!) 8) = H.toList.flatMap Sha512.bytesBE := by
  obtain ⟨⟨l⟩, hl⟩ := H
  match l, hl with
  | [a, b, c, d, e, f, g, h], _ =>
    simp (disch := omega) only [wordsLE, bytesLE_cast, bytesLE_append]
    simp [store64_be.spec, bytesLE_bswap, Sha512.bytesBE]
    rfl

/-- `PAD`'s bytes. -/
theorem bytesLE_pad : bytesLE pad = 0x80#8 :: List.replicate 127 0#8 := by
  apply List.ext_getElem
  · simp
  · intro i h1 h2
    rw [getElem_bytesLE]
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    rw [BitVec.getLsbD_extractLsb', pad, BitVec.getLsbD_ofNat]
    rcases i with _ | i
    · simp only [List.getElem_cons_zero, hj, decide_true, Bool.true_and, Nat.mul_zero,
        Nat.zero_add, BitVec.getLsbD_ofNat, show j < 1024 by omega]
    · have hb : (128 : Nat).testBit (8 * (i + 1) + j) = false :=
        Nat.testBit_lt_two_pow (Nat.lt_of_lt_of_le (show 128 < 2 ^ 8 by decide)
          (Nat.pow_le_pow_right (by decide) (by omega)))
      rw [List.getElem_cons_succ, List.getElem_replicate]
      simp [hb]

/-- `PAD`'s first `j ≥ 1` bytes. -/
theorem bytesLE_pad_setWidth {j : Nat} (h1 : 1 ≤ j) (h : j ≤ 128) :
    bytesLE (pad.setWidth (8 * j)) = 0x80#8 :: List.replicate (j - 1) 0#8 := by
  rw [bytesLE_setWidth _ (by omega) (by omega), bytesLE_pad, show 8 * j / 8 = j by omega]
  obtain ⟨k, rfl⟩ : ∃ k, j = k + 1 := ⟨j - 1, by omega⟩
  rw [List.take_succ_cons, List.take_replicate, Nat.min_eq_left (by omega), Nat.add_sub_cancel]

theorem bytesLE_zero (n : Nat) : bytesLE (0#(8 * n)) = List.replicate n 0#8 := by
  apply List.ext_getElem
  · simp
  · intro i h1 h2
    rw [getElem_bytesLE, List.getElem_replicate]
    apply BitVec.eq_of_toNat_eq
    simp

/-- The counts' words byte-swapped: the bit length big-endian. -/
theorem bytesBE_count (c0 c1 : BitVec 64) :
    Sha512.bytesBE (c0 ++ c1) = bytesLE (store64_be.spec c0) ++ bytesLE (store64_be.spec c1) := by
  rw [Sha512.bytesBE, bytesLE_append _ _ (by decide), List.reverse_append, store64_be.spec,
    store64_be.spec, bytesLE_bswap, bytesLE_bswap]

/-- The buffer after the counts, its first 112 bytes `Q`. -/
theorem bytesLE_count_buf {w : HashState} {Q : List (BitVec 8)}
    (hQ : (bytesLE w.buf).take Q.length = Q) (hQl : Q.length = 112) :
    bytesLE (count w).buf =
      Q ++ bytesLE (store64_be.spec w.count0) ++ bytesLE (store64_be.spec w.count1) := by
  have h1 := take_bytesLE_copy hQ (off := 112#64) (by rw [hQl]; rfl) (n := 8)
    (store64_be.spec w.count0) (by omega)
  rw [show Q.length + 8 = (Q ++ bytesLE (store64_be.spec w.count0)).length by simp] at h1
  have h2 := take_bytesLE_copy h1 (off := 120#64) (by simp [hQl]) (n := 8)
    (store64_be.spec w.count1) (by simp [hQl])
  rw [show (Q ++ bytesLE (store64_be.spec w.count0)).length + 8 = 128 by simp [hQl],
    List.take_of_length_le (by simp)] at h2
  exact h2

end SHA512_Pad

open SHA512_Pad crypto_hash_sha512_update in
/-- `final` on an object that absorbed `m`: the digest's bytes are SHA-512 of `m`. -/
public theorem HashState.Absorbed.final {v : HashState} {m : List (BitVec 8)} (h : v.Absorbed m) :
    bytesLE (crypto_hash_sha512_final.spec v) = Sha512.digest m := by
  rw [crypto_hash_sha512_final.spec, bytesLE_digest, Sha512.digest]
  congr 2
  have hr : SHA512_Pad.r v = m.length % 128 := h.r_eq
  have hP := h.buf
  have hPl : (m.drop (m.length / 128 * 128)).length = m.length % 128 := by
    simp; omega
  rw [← hPl] at hP
  have hoff :
      (BitVec.ofNat 64 (m.length % 128)).toNat = (m.drop (m.length / 128 * 128)).length := by
    rw [hPl, BitVec.toNat_ofNat]; omega
  have hst : v.state = Sha512.compressBlocks Sha512.IV (m.take (m.length / 128 * 128)) := by
    rw [h.state, Sha512.compressBlocks_take]
  have hcb : Sha512.bytesBE (BitVec.ofNat 128 (8 * m.length)) =
      bytesLE (store64_be.spec v.count0) ++ bytesLE (store64_be.spec v.count1) := by
    rw [← h.count, bytesBE_count]
  have e : ∀ X : List (BitVec 8), m ++ X =
      m.take (m.length / 128 * 128) ++ (m.drop (m.length / 128 * 128) ++ X) := fun X => by
    rw [← List.append_assoc, List.take_append_drop]
  rw [Sha512.pad, hcb, List.append_assoc, List.append_assoc, e,
    Sha512.compressBlocks_append _ (by simp; omega), ← hst]
  generalize m.drop (m.length / 128 * 128) = P at *
  have hrl : m.length % 128 < 128 := Nat.mod_lt _ (by decide)
  generalize m.length % 128 = r at *
  simp only [SHA512_Pad.spec, tail, head, hr]
  by_cases h112 : r < 112
  · rw [ite_eq_left h112]
    have hN : (BitVec.ofNat 64 (112 - r)).toNat = 112 - r := by simp; omega
    rw [hr, hN]
    have hQ := take_bytesLE_copy hP hoff (pad.setWidth (8 * (112 - r))) (by omega)
    rw [bytesLE_pad_setWidth (by omega) (by omega)] at hQ
    rw [show P.length + (112 - r) = (P ++ 0x80#8 :: List.replicate (112 - r - 1) 0#8).length by
      simp; omega] at hQ
    have hB := bytesLE_count_buf (w := v.fill (BitVec.ofNat 64 r) (pad.setWidth (8 * (112 - r))))
      hQ (by simp; omega)
    simp only [HashState.fill_count0, HashState.fill_count1] at hB
    rw [SHA512_Transform.spec, hB, ← compressBlocks_block (by simp; omega),
      show (239 - r) % 128 = 112 - r - 1 by omega]
    show Sha512.compressBlocks v.state _ = _
    simp only [List.append_assoc, List.cons_append, List.nil_append]
  · rw [ite_eq_right h112]
    have hN : (BitVec.ofNat 64 (128 - r)).toNat = 128 - r := by simp; omega
    rw [hr, hN]
    have hB1 := take_bytesLE_copy hP hoff (pad.setWidth (8 * (128 - r))) (by omega)
    rw [bytesLE_pad_setWidth (by omega) (by omega),
      show P.length + (128 - r) = 128 by omega, List.take_of_length_le (by simp)] at hB1
    have hQ := take_bytesLE_copy (buf := Firedancer.Ref.fd_sha512_append.copy v.buf
      (BitVec.ofNat 64 r) (pad.setWidth (8 * (128 - r)))) (P := []) (by simp) (off := 0#64) rfl
      (n := 112) 0#896 (by simp)
    rw [List.nil_append, bytesLE_zero 112, List.length_nil, Nat.zero_add] at hQ
    rw [SHA512_Transform.spec, bytesLE_count_buf (Q := List.replicate 112 0#8)
        (by rw [List.length_replicate]; exact hQ) (by simp),
      show (239 - r) % 128 = 128 - r - 1 + 112 by omega, List.replicate_add]
    simp only [HashState.fill_count0, HashState.fill_count1]
    have hl1 : (P ++ 128#8 :: List.replicate (128 - r - 1) 0#8).length = 128 := by simp; omega
    have hl2 : (List.replicate 112 0#8 ++ bytesLE (store64_be.spec v.count0) ++
        bytesLE (store64_be.spec v.count1)).length = 128 := by simp
    show Sha512.compress (SHA512_Transform.spec v.state (Firedancer.Ref.fd_sha512_append.copy v.buf
      (BitVec.ofNat 64 r) (pad.setWidth (8 * (128 - r))))) _ = _
    rw [SHA512_Transform.spec, hB1,
      show P ++ ([128#8] ++ (List.replicate (128 - r - 1) 0#8 ++ List.replicate 112 0#8 ++
          (bytesLE (store64_be.spec v.count0) ++ bytesLE (store64_be.spec v.count1)))) =
        (P ++ 128#8 :: List.replicate (128 - r - 1) 0#8) ++
          (List.replicate 112 0#8 ++ bytesLE (store64_be.spec v.count0) ++
            bytesLE (store64_be.spec v.count1)) by simp,
      Sha512.compressBlocks_append _ (by rw [hl1]), compressBlocks_block hl1,
      compressBlocks_block hl2]

/-! ## Init, updates, final -/

/-- Updates with `pieces` of `len` bytes each, in order. -/
@[expose] public def crypto_hash_sha512_update.specs (v : HashState) :
    List ((len : BitVec 64) × BitVec (8 * len.toNat)) → HashState
  | [] => v
  | ⟨len, data⟩ :: ps => specs (crypto_hash_sha512_update.spec v len data) ps

/-- The bytes of `pieces`, in order. -/
@[expose] public def crypto_hash_sha512_update.bytes
    (ps : List ((len : BitVec 64) × BitVec (8 * len.toNat))) :
    List (BitVec 8) :=
  ps.flatMap fun p => bytesLE p.2

open crypto_hash_sha512_update in
/-- Updates with `pieces` absorb their bytes. -/
public theorem HashState.Absorbed.updates {v : HashState} {m : List (BitVec 8)} (h : v.Absorbed m) :
    ∀ ps, (specs v ps).Absorbed (m ++ bytes ps)
  | [] => by simpa [crypto_hash_sha512_update.specs, bytes] using h
  | ⟨len, data⟩ :: ps => by
    have := (h.update len data).updates ps
    simpa [crypto_hash_sha512_update.specs, bytes, List.append_assoc] using this

open crypto_hash_sha512_update in
/-- `init`, `update` with each of `pieces`, `final`: the digest's bytes are SHA-512 of the
pieces' bytes, whatever the struct held before. -/
public theorem digest_eq (v : HashState) (ps : List ((len : BitVec 64) × BitVec (8 * len.toNat))) :
    bytesLE (crypto_hash_sha512_final.spec (specs (crypto_hash_sha512_init.spec v) ps)) =
      Sha512.digest (bytes ps) := by
  have := (HashState.absorbed_init v).updates ps
  rw [List.nil_append] at this
  exact this.final

/-- The verify hash: `r`, `A` and `msg` appended, SHA-512 of `r ‖ A ‖ msg`. -/
public theorem hash_eq (v : HashState) (r a : BitVec 256) (mlen : BitVec 64)
    (msg : BitVec (8 * mlen.toNat)) :
    bytesLE
        (crypto_hash_sha512_final.spec
          (crypto_hash_sha512_update.spec
            (crypto_hash_sha512_update.spec
              (crypto_hash_sha512_update.spec (crypto_hash_sha512_init.spec v) 32#64 r) 32#64 a)
            mlen msg)) =
      Sha512.digest (bytesLE r ++ bytesLE a ++ bytesLE msg) := by
  have := digest_eq v [⟨32#64, r⟩, ⟨32#64, a⟩, ⟨mlen, msg⟩]
  simpa [crypto_hash_sha512_update.specs, crypto_hash_sha512_update.bytes,
    List.append_assoc] using this

end MLIR.Sodium
