module

public import Ed25519.Sha512
public import Firedancer.Math.Sha512
public import Boringssl.SHA512_Init
public import Boringssl.SHA512_Update
public import Boringssl.SHA512_Final
import Std.Tactic.BVDecide

/-! The SHA-512 that `SHA512_Init`, `SHA512_Update` and `SHA512_Final` compute: after an init
and updates, the final digest's bytes are SHA-512 of the bytes appended. -/

namespace MLIR.Boringssl

open _root_.Ed25519
open Memory
open Firedancer.Ref (take_bytesLE_copy bytesLE_bswap)
open Firedancer.Ref.fd_sha512_append (copy)

/-! ## The hash object -/

/-- `v` has absorbed the bytes `m`: their whole blocks compressed from `IV`, the rest buffered and
known, their count mod `2 ^ 96`, the digest length 64. -/
public structure _root_.MLIR.Sha512Ctx.Absorbed (v : Sha512Ctx) (m : List (BitVec 8)) : Prop where
  h : v.h = Sha512.compressBlocks Sha512.IV m
  num : v.num.toNat = m.length % 128
  p : (bytesLE v.p).take (m.length % 128) = m.drop (m.length / 128 * 128)
  pre : v.Prefix (m.length % 128)
  count : v.hi ++ v.lo = BitVec.ofNat 96 m.length
  mdLen : v.mdLen = 64#16

/-- What the code needs between calls. -/
public theorem _root_.MLIR.Sha512Ctx.Absorbed.valid {v : Sha512Ctx} {m : List (BitVec 8)}
    (h : v.Absorbed m) : v.Valid :=
  ⟨by
    rw [h.num]; omega, by
    rw [h.num]; exact h.pre⟩

/-- `init`'s object has absorbed nothing, whatever `p` holds. -/
public theorem _root_.MLIR.Sha512Ctx.absorbed_init (v : Sha512Ctx) :
    (BCM_sha512_init.spec v).Absorbed [] := by
  refine ⟨?_, rfl, rfl, Sha512Ctx.prefix_zero _, ?_, rfl⟩
  · rw [Sha512.compressBlocks_of_lt (by simp)]
    rfl
  · show 0#32 ++ 0#64 = 0#96
    exact BitVec.eq_of_toNat_eq (by simp)

namespace BCM_sha512_update

private theorem toNat_and_127 (n : BitVec 64) : (n &&& 127#64).toNat = n.toNat % 128 := by
  rw [BitVec.toNat_and, show (127#64).toNat = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

private theorem toNat_ushiftRight_7 (n : BitVec 64) : (n >>> 7).toNat = n.toNat / 128 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- The byte count: 96-bit addition of `len`. -/
private theorem count_add (hi : BitVec 32) (lo len : BitVec 64) :
    (if (lo + len).ult len then hi + 1#32 else hi) ++ (lo + len) =
      (hi ++ lo) + len.setWidth 96 := by
  split <;> bv_decide

private theorem count_add_ofNat (n : Nat) (len : BitVec 64) :
    BitVec.ofNat 96 n + len.setWidth 96 = BitVec.ofNat 96 (n + len.toNat) := by
  rw [BitVec.ofNat_add]
  congr 1
  apply BitVec.eq_of_toNat_eq
  simp

/-- The leftover after whole blocks `m`, from an empty buffer, the count already added. -/
private theorem leftover_absorbed {v : Sha512Ctx} {m : List (BitVec 8)} (len : BitVec 64)
    (data : BitVec (8 * len.toNat)) (hm : m.length % 128 = 0) (hlt : len.toNat < 128)
    (hs : v.h = Sha512.compressBlocks Sha512.IV m) (hn : v.num = 0#16)
    (hc : v.hi ++ v.lo = BitVec.ofNat 96 (m.length + len.toNat)) (hmd : v.mdLen = 64#16) :
    (leftover v len data).Absorbed (m ++ bytesLE data) := by
  have hD : (bytesLE data).length = len.toNat := by simp
  have e1 : (m ++ bytesLE data).length % 128 = len.toNat := by
    simp; omega
  have e2 : (m ++ bytesLE data).length / 128 * 128 = m.length := by
    simp; omega
  unfold leftover
  split
  · rename_i h0
    have : bytesLE data = [] :=
      List.eq_nil_of_length_eq_zero
        (by
          rw [hD, h0]; rfl)
    rw [this, List.append_nil]
    have hl : len.toNat = 0 := by
      rw [h0]; rfl
    refine ⟨hs, ?_, ?_, ?_, ?_, hmd⟩
    · rw [hn, hm]
      rfl
    · rw [hm, List.take_zero, eq_comm, List.drop_eq_nil_iff]
      omega
    · rw [hm]
      exact Sha512Ctx.prefix_zero _
    · simp only [hc, hl, Nat.add_zero]
  · rename_i h0
    have hcopy :=
      take_bytesLE_copy (buf := v.p) (P := []) (by simp) (off := 0#64) rfl data
        (by
          simp only [List.length_nil]; omega)
    rw [List.length_nil, Nat.zero_add, List.nil_append] at hcopy
    refine ⟨?_, ?_, ?_, ?_, ?_, hmd⟩
    · show v.h = _
      rw [hs,
        Sha512.compressBlocks_append_short
          (by
            rw [hD]; omega)]
    · show (len.setWidth 16).toNat = _
      rw [e1, BitVec.toNat_setWidth]
      omega
    · show (bytesLE (copy v.p 0#64 data)).take _ = _
      rw [e1, hcopy, e2, List.drop_left]
    · rw [e1]
      have := (Sha512Ctx.prefix_zero v).fill (off := 0#64) rfl data (j := len.toNat) rfl (by omega)
      rw [Nat.zero_add] at this
      exact this
    · show v.hi ++ v.lo = _
      rw [hc, List.length_append, hD]

/-- The bulk after whole blocks `m`, from an empty buffer, the count already added. -/
private theorem bulk_absorbed {v : Sha512Ctx} {m : List (BitVec 8)} (len : BitVec 64)
    (data : BitVec (8 * len.toNat)) (hm : m.length % 128 = 0)
    (hs : v.h = Sha512.compressBlocks Sha512.IV m) (hn : v.num = 0#16)
    (hc : v.hi ++ v.lo = BitVec.ofNat 96 (m.length + len.toNat)) (hmd : v.mdLen = 64#16)
    (hok : BulkOk len) : (bulk v len data).Absorbed (m ++ bytesLE data) := by
  have hD : (bytesLE data).length = len.toNat := by simp
  have hb := toNat_ushiftRight_7 len
  unfold bulk
  split
  · rename_i hlt
    have h0 : len &&& 127#64 = 0#64 := hok.resolve_left (by simpa using hlt)
    have h0' : len.toNat % 128 = 0 := by
      rw [← toNat_and_127, h0]; rfl
    unfold leftover
    rw [ite_eq_left h0]
    have e1 : (m ++ bytesLE data).length % 128 = 0 := by
      simp; omega
    refine ⟨?_, ?_, ?_, ?_, ?_, hmd⟩
    · show Firedancer.Ref.fd_sha512_core_ref.spec _ _ = _
      rw [Firedancer.Ref.fd_sha512_core_ref.spec_eq, bytesLE_setWidth _ (by omega) (by omega),
        Sha512.compressBlocks_append _ hm, ← hs,
        List.take_of_length_le
          (by
            simp; omega)]
    · rw [e1, hn]
      rfl
    · rw [e1, List.take_zero, eq_comm, List.drop_eq_nil_iff]
      simp; omega
    · rw [e1]
      exact Sha512Ctx.prefix_zero _
    · show v.hi ++ v.lo = _
      rw [hc, List.length_append, hD]
  · rename_i hlt
    exact
      leftover_absorbed len data hm
        (by
          simp [BitVec.ult] at hlt; omega)
        hs hn hc hmd

end BCM_sha512_update

open BCM_sha512_update in
/-- `update` absorbs `data`'s bytes, when its bulk is `Ok`. -/
public theorem _root_.MLIR.Sha512Ctx.Absorbed.update {v : Sha512Ctx} {m : List (BitVec 8)}
    (h : v.Absorbed m) (len : BitVec 64) (data : BitVec (8 * len.toNat)) (hok : Ok v len) :
    (BCM_sha512_update.spec v len data).Absorbed (m ++ bytesLE data) := by
  have hD : (bytesLE data).length = len.toNat := by simp
  have hc := count_add v.hi v.lo len
  rw [h.count, count_add_ofNat] at hc
  have hu := h.num
  unfold BCM_sha512_update.spec
  split
  · rename_i h0
    have : bytesLE data = [] :=
      List.eq_nil_of_length_eq_zero
        (by
          rw [hD, h0]; rfl)
    rw [this, List.append_nil]
    exact h
  rename_i hlen
  have hrok : RestOk v len := hok.resolve_left hlen
  dsimp only
  generalize (if (v.lo + len).ult len then v.hi + 1#32 else v.hi) = hi at hc ⊢
  unfold rest
  dsimp only
  split
  · rename_i hn
    have hm : m.length % 128 = 0 := by
      rw [← hu, hn]; rfl
    exact bulk_absorbed len data hm h.h hn hc h.mdLen (by simpa [RestOk, hn] using hrok)
  rename_i hn
  have hrem : (128#64 - v.num.setWidth 64).toNat = 128 - m.length % 128 := by
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def]; simp; omega)]
    simp only [BitVec.toNat_ofNat, BitVec.toNat_setWidth, hu]
    omega
  have hL : 0 < m.length % 128 := by
    rw [← hu]
    have := mt BitVec.toNat_eq.mpr hn
    simp only [BitVec.toNat_ofNat] at this
    omega
  have hP := h.p
  have hPl : (m.drop (m.length / 128 * 128)).length = m.length % 128 := by
    simp; omega
  rw [← hPl] at hP
  have hoff : (v.num.setWidth 64).toNat = (m.drop (m.length / 128 * 128)).length := by
    rw [hPl, BitVec.toNat_setWidth, hu]
    omega
  split
  · rename_i hlt
    simp only [BitVec.ult, decide_eq_true_eq, hrem] at hlt
    have hcopy :=
      take_bytesLE_copy hP hoff data
        (by
          rw [hPl]; omega)
    refine ⟨?_, ?_, ?_, ?_, ?_, h.mdLen⟩
    · show v.h = _
      rw [h.h,
        Sha512.compressBlocks_append_short
          (by
            rw [hD]; omega)]
    · show (v.num + len.setWidth 16).toNat = _
      rw [BitVec.toNat_add, hu]
      simp only [List.length_append, hD, BitVec.toNat_setWidth]
      omega
    · show (bytesLE (copy v.p (v.num.setWidth 64) data)).take _ = _
      rw [show (m ++ bytesLE data).length % 128 = (m.drop (m.length / 128 * 128)).length + len.toNat
          by
          simp; omega,
        hcopy,
        show (m ++ bytesLE data).length / 128 * 128 = m.length / 128 * 128 by
          simp; omega,
        List.drop_append_of_le_length (by omega)]
    · have := h.pre.fill (hoff.trans hPl) data (j := len.toNat) rfl (by omega)
      rw [show (m ++ bytesLE data).length % 128 = m.length % 128 + len.toNat by
          simp; omega]
      exact this
    · exact hc.trans (by rw [List.length_append, hD])
  · rename_i hge
    simp only [BitVec.ult, decide_eq_true_eq, hrem, Nat.not_lt] at hge
    have hok' : BulkOk (len - (128#64 - v.num.setWidth 64)) := by
      simpa [RestOk, hn, BitVec.ult, hrem, Nat.not_lt.mpr hge] using hrok
    generalize hR : 128#64 - v.num.setWidth 64 = R at *
    have hsub : (len - R).toNat = len.toNat - (128 - m.length % 128) := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hrem]; omega),
        hrem]
    have hcopy :=
      take_bytesLE_copy hP hoff (data.setWidth (8 * R.toNat))
        (by
          rw [hPl, hrem]; omega)
    have hx :
      bytesLE (data.setWidth (8 * R.toNat)) = (bytesLE data).take (128 - m.length % 128) := by
      rw [bytesLE_setWidth _ (by omega) (by omega), hrem]
      congr 1
      omega
    rw [hx,
      show (m.drop (m.length / 128 * 128)).length + R.toNat = 128 by
        rw [hPl, hrem]; omega,
      List.take_of_length_le (by simp)] at hcopy
    have hy :
      bytesLE (data.extractLsb' (8 * R.toNat) (8 * (len - R).toNat)) =
        (bytesLE data).drop (128 - m.length % 128) := by
      rw [bytesLE_extractLsb' _ (by omega) (by omega)
          (by
            rw [hsub, hrem]; omega),
        hsub, hrem, List.take_of_length_le (by simp)]
      congr 1
      omega
    rw [show
        m ++ bytesLE data =
          m ++ (bytesLE data).take (128 - m.length % 128) ++
            bytesLE (data.extractLsb' (8 * R.toNat) (8 * (len - R).toNat))
        by rw [hy, List.append_assoc, List.take_append_drop]]
    refine
      bulk_absorbed _ _
        (by
          simp only [List.length_append, List.length_take, hD]; omega)
        ?_ rfl ?_ h.mdLen hok'
    · show Firedancer.Ref.fd_sha512_core_ref.spec (n := 1) v.h (copy v.p _ _) = _
      rw [Firedancer.Ref.fd_sha512_core_ref.spec_one, hcopy, h.h, Sha512.compressBlocks_take m,
        show
          m ++ (bytesLE data).take (128 - m.length % 128) =
            m.take (m.length / 128 * 128) ++
              (m.drop (m.length / 128 * 128) ++ (bytesLE data).take (128 - m.length % 128))
          by rw [← List.append_assoc, List.take_append_drop],
        Sha512.compressBlocks_append (a := m.take _) _
          (by
            simp; omega)]
    · show hi ++ (v.lo + len) = _
      rw [hc]
      congr 1
      simp only [List.length_append, List.length_take, hD, hsub]
      omega

namespace sha512_final_impl

/-- `last` after a known prefix `Q` of `p`, `b = |Q|`: the block `Q`, zeros to byte 112, the
counts big-endian. -/
private theorem last_h (s : Sha512Ctx) (b : BitVec 64) (Q : List (BitVec 8))
    (hQ : (bytesLE s.p).take Q.length = Q) (hb : b.toNat = Q.length) (hl : Q.length ≤ 112) :
    (last s b).h =
      Sha512.compressBlocks s.h
        (Q ++ List.replicate (112 - Q.length) 0#8 ++
          bytesLE (Firedancer.Ref.fd_ulong_bswap.spec (s.hi.setWidth 64 <<< 3 ||| s.lo >>> 61)) ++
          bytesLE (Firedancer.Ref.fd_ulong_bswap.spec (s.lo <<< 3))) := by
  have hn : (112#64 - b).toNat = 112 - Q.length := by
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def, hb]; simp; omega),
      hb]
    rfl
  unfold last
  dsimp only
  rw [Firedancer.Ref.fd_sha512_core_ref.spec_one]
  simp only [Sha512Ctx.fill]
  rw [hn]
  have h1 := take_bytesLE_copy hQ hb ((0#8).replicate (112 - Q.length)) (by omega)
  rw [bytesLE_replicate_zero,
    show Q.length + (112 - Q.length) = (Q ++ List.replicate (112 - Q.length) 0#8).length by
      simp] at h1
  have h2 :=
    take_bytesLE_copy h1 (off := 112#64)
      (by
        simp; omega)
      (n := 8) (Firedancer.Ref.fd_ulong_bswap.spec (s.hi.setWidth 64 <<< 3 ||| s.lo >>> 61))
      (by
        simp; omega)
  rw [show
      (Q ++ List.replicate (112 - Q.length) 0#8).length + 8 =
        (Q ++ List.replicate (112 - Q.length) 0#8 ++
            bytesLE
              (Firedancer.Ref.fd_ulong_bswap.spec (s.hi.setWidth 64 <<< 3 ||| s.lo >>> 61))).length
      by
      simp; omega] at h2
  have h3 :=
    take_bytesLE_copy h2 (off := 120#64)
      (by
        simp; omega)
      (n := 8) (Firedancer.Ref.fd_ulong_bswap.spec (s.lo <<< 3))
      (by
        simp; omega)
  rw [show
      (Q ++ List.replicate (112 - Q.length) 0#8 ++
              bytesLE
                (Firedancer.Ref.fd_ulong_bswap.spec
                  (s.hi.setWidth 64 <<< 3 ||| s.lo >>> 61))).length +
          8 =
        128
      by
      simp; omega,
    List.take_of_length_le (by simp)] at h3
  rw [h3]

/-- The count's words: the bit length big-endian, for fewer than `2 ^ 96` bytes. -/
private theorem bytesBE_count (hi : BitVec 32) (lo : BitVec 64) {L : Nat}
    (hc : hi ++ lo = BitVec.ofNat 96 L) (hL : L < 2 ^ 96) :
    Sha512.bytesBE (BitVec.ofNat 128 (8 * L)) =
      bytesLE (Firedancer.Ref.fd_ulong_bswap.spec (hi.setWidth 64 <<< 3 ||| lo >>> 61)) ++
        bytesLE (Firedancer.Ref.fd_ulong_bswap.spec (lo <<< 3)) := by
  have e1 : (hi.setWidth 64 <<< 3 ||| lo >>> 61) ++ lo <<< 3 = (hi ++ lo).setWidth 128 <<< 3 := by
    bv_decide
  have e2 : (BitVec.ofNat 96 L).setWidth 128 <<< 3 = BitVec.ofNat 128 (8 * L) := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, BitVec.toNat_ofNat]
    rw [Nat.shiftLeft_eq, Nat.mod_eq_of_lt hL, Nat.mod_eq_of_lt (by omega)]
    omega
  rw [← e2, ← hc, ← e1, Sha512.bytesBE, bytesLE_append _ _ (by decide), List.reverse_append,
    bytesLE_bswap, bytesLE_bswap]

/-- The digest's bytes: the state's words big-endian. -/
private theorem bytesLE_bits_bswap (v : Vector (BitVec 64) 8) :
    bytesLE (Firedancer.Words8.bits (v.map Firedancer.Ref.fd_ulong_bswap.spec)) =
      v.toList.flatMap Sha512.bytesBE := by
  obtain ⟨⟨l⟩, hl⟩ := v
  match l, hl with
  | [a, b, c, d, e, f, g, h],
    _ =>
    simp only [Firedancer.Words8.bits, Vector.map_mk, Vector.getElem_mk, List.map_toArray,
      List.map_cons, List.map_nil, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ]
    rw [bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide), bytesLE_append _ _ (by decide),
      bytesLE_append _ _ (by decide)]
    simp [bytesLE_bswap, Sha512.bytesBE]

end sha512_final_impl

open sha512_final_impl in
/-- `final` on an object that absorbed `m`, fewer than `2 ^ 96` bytes: the digest's bytes are
SHA-512 of `m`. -/
public theorem _root_.MLIR.Sha512Ctx.Absorbed.final {v : Sha512Ctx} {m : List (BitVec 8)}
    (h : v.Absorbed m) (hm : m.length < 2 ^ 96) :
    bytesLE
        (Firedancer.Words8.bits
          ((sha512_final_impl.spec v).h.map Firedancer.Ref.fd_ulong_bswap.spec)) =
      Sha512.digest m := by
  rw [Sha512.digest, bytesLE_bits_bswap]
  congr 2
  have hu := h.num
  have hP := h.p
  have hPl : (m.drop (m.length / 128 * 128)).length = m.length % 128 := by
    simp; omega
  rw [← hPl] at hP
  have hb0 : (v.num.setWidth 64).toNat = (m.drop (m.length / 128 * 128)).length := by
    rw [hPl, BitVec.toNat_setWidth, hu]
    omega
  have h80 :=
    take_bytesLE_copy hP hb0 (n := 1) 0x80#8
      (by
        rw [hPl]; omega)
  rw [show bytesLE 0x80#8 = [0x80#8] from rfl] at h80
  have hb1 : (v.num.setWidth 64 + 1#64).toNat = m.length % 128 + 1 := by
    rw [BitVec.toNat_add, BitVec.toNat_setWidth, hu]; simp; omega
  have hst : v.h = Sha512.compressBlocks Sha512.IV (m.take (m.length / 128 * 128)) := by
    rw [h.h, Sha512.compressBlocks_take]
  rw [Sha512.pad, bytesBE_count v.hi v.lo h.count hm]
  generalize hk : (239 - m.length % 128) % 128 = k
  have e := List.take_append_drop (m.length / 128 * 128) m
  simp only [List.append_assoc]
  rw [show
      ∀ X : List (BitVec 8),
        m ++ X = m.take (m.length / 128 * 128) ++ (m.drop (m.length / 128 * 128) ++ X)
      by
      intro X; rw [← List.append_assoc, e],
    Sha512.compressBlocks_append (a := m.take _) _
      (by
        simp; omega),
    ← hst]
  generalize m.drop (m.length / 128 * 128) = P at *
  clear e hst
  have hr : m.length % 128 < 128 := Nat.mod_lt _ (by decide)
  generalize m.length % 128 = r at *
  have h80' :
    (bytesLE (copy v.p (v.num.setWidth 64) 128#8)).take (P ++ [128#8]).length = P ++ [128#8] := by
    rw [List.length_append, List.length_singleton]
    exact h80
  have h112 : (112#64).toNat = 112 := rfl
  unfold sha512_final_impl.spec
  dsimp only
  split
  · rename_i hlt
    simp only [BitVec.ult, decide_eq_true_eq, hb1, h112] at hlt
    have hn : (128#64 - (v.num.setWidth 64 + 1#64)).toNat = 127 - r := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hb1]; simp; omega),
        hb1]
      simp
    have h2 :=
      take_bytesLE_copy h80' (off := v.num.setWidth 64 + 1#64)
        (by
          rw [hb1]; simp; omega)
        ((0#8).replicate (128#64 - (v.num.setWidth 64 + 1#64)).toNat)
        (by
          rw [hn]; simp; omega)
    rw [bytesLE_replicate_zero, hn,
      show (P ++ [128#8]).length + (127 - r) = 128 by
        simp; omega,
      List.take_of_length_le (by simp)] at h2
    rw [last_h _ _ [] (by simp) (by simp) (by simp)]
    dsimp only
    rw [Firedancer.Ref.fd_sha512_core_ref.spec_one]
    simp only [Sha512Ctx.fill_h, Sha512Ctx.fill_hi, Sha512Ctx.fill_lo]
    show
      Sha512.compressBlocks
          (Sha512.compressBlocks v.h
            (bytesLE
              (copy (copy v.p _ _) _
                ((0#8).replicate (128#64 - (v.num.setWidth 64 + 1#64)).toNat))))
          _ =
        _
    rw [hn, h2, ←
      Sha512.compressBlocks_append _
        (by
          simp; omega),
      show k = 127 - r + 112 by omega, List.replicate_add]
    simp only [List.append_assoc, List.nil_append, List.length_nil, Nat.sub_zero, List.cons_append]
  · rename_i hge
    simp only [BitVec.ult, decide_eq_true_eq, hb1, h112, Nat.not_lt] at hge
    rw [last_h _ _ (P ++ [128#8]) h80'
        (by
          rw [hb1]; simp; omega)
        (by
          simp; omega)]
    simp only [Sha512Ctx.fill_h, Sha512Ctx.fill_hi, Sha512Ctx.fill_lo]
    rw [show k = 112 - (P ++ [128#8]).length by
        simp; omega]
    simp only [List.append_assoc, List.cons_append]

/-! ## Init, updates, final -/

/-- `update`'s `Ok` from the bytes absorbed before: `k` of them, then `len` more. -/
public def BCM_sha512_update.OkAt (k : Nat) (len : BitVec 64) : Prop :=
  len = 0#64 ∨
    if k % 128 = 0 then BCM_sha512_update.BulkOk len
    else
      len.toNat < 128 - k % 128 ∨ BCM_sha512_update.BulkOk (len - BitVec.ofNat 64 (128 - k % 128))

open BCM_sha512_update in
public theorem _root_.MLIR.Sha512Ctx.Absorbed.ok {v : Sha512Ctx} {m : List (BitVec 8)}
    (h : v.Absorbed m) {len : BitVec 64} (hok : OkAt m.length len) : Ok v len := by
  have hu := h.num
  have hn : v.num.setWidth 64 = BitVec.ofNat 64 (m.length % 128) := by
    apply BitVec.eq_of_toNat_eq
    rw [BitVec.toNat_setWidth, hu, BitVec.toNat_ofNat]
  have hz : v.num = 0#16 ↔ m.length % 128 = 0 := by
    rw [← hu, BitVec.toNat_eq]
    rfl
  have hr : (128#64 - BitVec.ofNat 64 (m.length % 128)).toNat = 128 - m.length % 128 := by
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def]; simp; omega)]
    simp
    omega
  have hr' : 128#64 - BitVec.ofNat 64 (m.length % 128) = BitVec.ofNat 64 (128 - m.length % 128) :=
    BitVec.eq_of_toNat_eq
      (by
        rw [hr]; simp; omega)
  rcases hok with h0 | hok
  · exact .inl h0
  right
  unfold RestOk
  by_cases hk : m.length % 128 = 0
  · rw [ite_eq_left (hz.2 hk)]
    rw [ite_eq_left hk] at hok
    exact hok
  · rw [ite_eq_right (mt hz.1 hk), hn, hr']
    rw [ite_eq_right hk] at hok
    rcases hok with hl | hb
    · left
      simp only [BitVec.ult, decide_eq_true_eq, BitVec.toNat_ofNat]
      omega
    · exact .inr hb

/-- Updates with `pieces` of `len` bytes each, in order. -/
public def BCM_sha512_update.specs (v : Sha512Ctx) :
    List ((len : BitVec 64) × BitVec (8 * len.toNat)) → Sha512Ctx
  | [] => v
  | ⟨len, data⟩ :: ps => specs (BCM_sha512_update.spec v len data) ps

/-- The bytes of `pieces`, in order. -/
public def BCM_sha512_update.bytes (ps : List ((len : BitVec 64) × BitVec (8 * len.toNat))) :
    List (BitVec 8) :=
  ps.flatMap fun p => bytesLE p.2

/-- Each piece's `OkAt` after the ones before it, from `k` bytes absorbed. -/
public def BCM_sha512_update.OkAll (k : Nat) :
    List ((len : BitVec 64) × BitVec (8 * len.toNat)) → Prop
  | [] => True
  | ⟨len, _⟩ :: ps => OkAt k len ∧ OkAll (k + len.toNat) ps

open BCM_sha512_update in
/-- Updates with `pieces`, each `Ok`, absorb their bytes. -/
public theorem _root_.MLIR.Sha512Ctx.Absorbed.updates {v : Sha512Ctx} {m : List (BitVec 8)}
    (h : v.Absorbed m) : ∀ ps, OkAll m.length ps → (specs v ps).Absorbed (m ++ bytes ps)
  | [], _ => by simpa [BCM_sha512_update.specs, bytes] using h
  | ⟨len, data⟩ :: ps, ⟨hok, hrest⟩ => by
    have h' := h.update len data (h.ok hok)
    have := h'.updates ps (by simpa using hrest)
    simpa [BCM_sha512_update.specs, bytes, List.append_assoc] using this

open BCM_sha512_update in
/-- `SHA512_Init`, `SHA512_Update` with each of `pieces`, `SHA512_Final`: the digest's bytes are
SHA-512 of the pieces' bytes, for fewer than `2 ^ 96` bytes whose bulks are `Ok`; whatever the
struct held before. -/
public theorem digest_eq (v : Sha512Ctx) (ps : List ((len : BitVec 64) × BitVec (8 * len.toNat)))
    (hok : OkAll 0 ps) (hlen : (bytes ps).length < 2 ^ 96) :
    bytesLE
        (Firedancer.Words8.bits
          ((sha512_final_impl.spec (specs (BCM_sha512_init.spec v) ps)).h.map
            Firedancer.Ref.fd_ulong_bswap.spec)) =
      Sha512.digest (bytes ps) := by
  have := (Sha512Ctx.absorbed_init v).updates ps hok
  rw [List.nil_append] at this
  exact this.final hlen

open BCM_sha512_update in
/-- `ED25519_verify`'s hash: `r`, `A` and `msg` appended, SHA-512 of `r ‖ A ‖ msg` for a message
whose bulk is `Ok` after the 64 bytes before it. -/
public theorem hash_eq (v : Sha512Ctx) (r a : BitVec 256) (msgLen : BitVec 64)
    (msg : BitVec (8 * msgLen.toNat)) (hok : msgLen.toNat < 64 ∨ BulkOk (msgLen - 64#64)) :
    bytesLE
        (Firedancer.Words8.bits
          ((sha512_final_impl.spec
                (BCM_sha512_update.spec
                  (BCM_sha512_update.spec (BCM_sha512_update.spec (BCM_sha512_init.spec v) 32#64 r)
                    32#64 a)
                  msgLen msg)).h.map
            Firedancer.Ref.fd_ulong_bswap.spec)) =
      Sha512.digest (bytesLE r ++ bytesLE a ++ bytesLE msg) := by
  have :=
    digest_eq v [⟨32#64, r⟩, ⟨32#64, a⟩, ⟨msgLen, msg⟩]
      ⟨.inr (by simp [BulkOk]), .inr (by simp [BulkOk]), .inr (by simpa using hok), trivial⟩
      (by
        simp [bytes]; omega)
  simpa [specs, bytes, List.append_assoc] using this

end MLIR.Boringssl
