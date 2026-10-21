module

public import MLIR.Run.Tactic
public import Ed25519.Sha512
public import Agave.Common.Sha512
public import Agave.Common.Sha512Rounds
public import Agave.Serial.Mlir.compress512
public import Agave.Serial.compress512.Rounds
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

open _root_.Ed25519 MLIR.Agave

/-! ## Specification -/

@[expose] public section

/-- `compress512(state, blocks)`: SHA-512's compression of each whole 128-byte block of `bytes`,
in order, from the state words `H`. -/
def compress512.spec (H : Vector (BitVec 64) 8) (bytes : List (BitVec 8)) : Vector (BitVec 64) 8 :=
  Sha512.compressBlocks H bytes

end

/-! ## Proof -/

namespace compress512

section Proof

/-- `bswap64`'s bytes, the lowest first: the bytes reversed. -/
theorem bswap64_eq (x : BitVec 64) :
    bswap64 x =
      x.extractLsb' 0 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 24 8 ++
        x.extractLsb' 32 8 ++
        x.extractLsb' 40 8 ++
        x.extractLsb' 48 8 ++
        x.extractLsb' 56 8 := by
  simp only [bswap64, List.range, List.range.loop, List.foldl]
  bv_decide

/-- Block word `t`, big-endian: the byte swap of its little-endian load. -/
theorem word_eq (B : BitVec 1024) (ht : t < 16) :
    Sha512.word (bytesLE B) t = bswap64 (B.extractLsb' (64 * t) 64) := by
  have e (b : Nat) (hb : b + 8 ≤ 64) :
    (B.extractLsb' (64 * t) 64).extractLsb' b 8 = B.extractLsb' (64 * t + b) 8 := by
    apply BitVec.eq_of_getLsbD_eq
    intro j hj
    simp [BitVec.getLsbD_extractLsb', show b + j < 64 by omega, Nat.add_assoc]
  simp (disch := omega) only [Sha512.word, getElem!_bytesLE, bswap64_eq, e]
  rw [show 8 * (8 * t) = 64 * t + 0 by omega, show 8 * (8 * t + 1) = 64 * t + 8 by omega,
    show 8 * (8 * t + 2) = 64 * t + 16 by omega, show 8 * (8 * t + 3) = 64 * t + 24 by omega,
    show 8 * (8 * t + 4) = 64 * t + 32 by omega, show 8 * (8 * t + 5) = 64 * t + 40 by omega,
    show 8 * (8 * t + 6) = 64 * t + 48 by omega, show 8 * (8 * t + 7) = 64 * t + 56 by omega]

/-- The schedule's words: the block's, then `σ₁ + W + σ₀ + W`. -/
theorem schedule_words (B : BitVec 1024) :
    (bswap64 (B.setWidth 64) = (Sha512.schedule (bytesLE B))[0]!) ∧
      (∀ t, t < 16 → bswap64 (B.extractLsb' (64 * t) 64) = (Sha512.schedule (bytesLE B))[t]!) ∧
      (∀ t,
        16 ≤ t →
          t < 80 →
          (Sha512.schedule (bytesLE B))[t]! =
            Sha512.sigma1 (Sha512.schedule (bytesLE B))[t - 2]! +
              (Sha512.schedule (bytesLE B))[t - 7]! +
              Sha512.sigma0 (Sha512.schedule (bytesLE B))[t - 15]! +
              (Sha512.schedule (bytesLE B))[t - 16]!) := by
  refine ⟨?_, fun t ht => ?_, fun t h1 h2 => Sha512.getElem!_schedule_ge _ h1 h2⟩
  · rw [Sha512.getElem!_schedule_lt _ (by decide), word_eq B (by decide),
      BitVec.setWidth_eq_extractLsb' (by decide)]
  · rw [Sha512.getElem!_schedule_lt _ ht, word_eq B ht]

/-- The state words after a block: `compress`. -/
theorem compress_eq (H : Vector (BitVec 64) 8) (B : List (BitVec 8)) :
    Vector.zipWith (· + ·) #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]]
        (rounds (fun t => (Sha512.schedule B)[t]!) 80
          #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]]) =
      Sha512.compress H B := by
  have : #v[H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]] = H := by
    ext i hi
    rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
      first
      | rfl
      | omega
  rw [this]
  simp only [rounds, Sha512.compress]

/-- A byte array's literal whose byte `i` is that of `N`: `N`'s bits. -/
public theorem flatBits_ofFn_bytes {n N w : Nat} {hw : (Ty.array n (.bv 8)).width = w} :
    Ty.flatBits (t := .array n (.bv 8))
        (Vector.ofFn fun i : Fin n => BitVec.ofNat 8 (N >>> (8 * i.val))) (hw := hw) =
      BitVec.ofNat w N := by
  have hw' : w = 8 * n := by
    rw [← hw]; simp [Ty.width, Ty.padding, Ty.align]
  subst hw'
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  have hs : (Ty.bv 8).stride = 8 := rfl
  have h1 :=
    congrArg (fun x : BitVec 1 => x.getLsbD 0)
      (Ty.extractLsb'_flattenRaw_array (s := j) (w := 1)
        (Vector.ofFn fun i : Fin n => BitVec.ofNat 8 (N >>> (8 * i.val)))
        (by
          rw [hs]; omega)
        (by
          rw [hs]; have := Nat.mod_lt j (by decide : 0 < 8); simp [Ty.width]; omega))
  simp only [BitVec.getLsbD_extractLsb', hs, Ty.extractLsb'_flattenRaw_bv, Nat.zero_lt_one,
    decide_true, Bool.true_and, Nat.add_zero, Vector.getElem_ofFn, BitVec.getLsbD_ofNat,
    Nat.testBit_shiftRight, show j % 8 < 8 by omega] at h1
  simp only [Ty.flatBits_eq, BitVec.getLsbD_cast, BitVec.getLsbD_ofNat, hj, decide_true,
    Bool.true_and, h1]
  congr 1
  omega

/-- The `K` table's block holds `Sha512.K`, word by word. -/
theorem K_words {hw : (Ty.array 640 (.bv 8)).width = 5120} :
    ∀ t,
      t < 80 →
        (Ty.flatBits anon_13b8ab24e6986c1da96f68a50a4d6db2_1.lit (hw := hw)).extractLsb' (64 * t)
            64 =
          Sha512.K[t]! := by
  unfold anon_13b8ab24e6986c1da96f68a50a4d6db2_1.lit
  rw [flatBits_ofFn_bytes]
  decide +kernel

/-- `K[t]`, read from the table's block. -/
theorem readAt_K {m : MemoryState} {Kp : Pointer} {hw : (Ty.array 640 (.bv 8)).width = 5120}
    (hf : Fits m Kp 5120) (ho : Kp.offset = 0)
    (h : m.readAt Kp 5120 = Ty.flatBits anon_13b8ab24e6986c1da96f68a50a4d6db2_1.lit (hw := hw)) :
    ∀ t, t < 80 → m.readAt (Kp.add (BitVec.ofNat 64 (8 * t))) 64 = Sha512.K[t]! := by
  intro t ht
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      h,
    show (BitVec.ofNat 64 (8 * t)).toNat * 8 = 64 * t by
      simp; omega]
  exact K_words t ht

/-- Block `j`'s offset does not wrap. -/
theorem block_noOverflow {data : Pointer} {N j : Nat} (hdo : data.offset.toNat + 128 * N < 2 ^ 64)
    (hj : j ≤ N) : ¬data.offset.uaddOverflow (BitVec.ofNat 64 (128 * j)) := by
  simp [BitVec.uaddOverflow]
  omega

/-- Block `j` of `N` fits. -/
theorem fits_block {m : MemoryState} {data : Pointer} {N j : Nat} (hf : Fits m data (1024 * N))
    (hdo : data.offset.toNat + 128 * N < 2 ^ 64) (hj : j < N) :
    Fits m (data.add (BitVec.ofNat 64 (128 * j))) 1024 :=
  Fits.add_of_le (block_noOverflow hdo (Nat.le_of_lt hj))
    (by
      simp; omega)
    hf

/-- Block `j` of `N`, read where the `N` blocks were read whole. -/
theorem readAt_block {m : MemoryState} {data : Pointer} {N j : Nat} {D : BitVec (1024 * N)}
    (hf : Fits m data (1024 * N)) (hdo : data.offset.toNat + 128 * N < 2 ^ 64) (hj : j < N)
    (h : m.readAt data (1024 * N) = D) :
    m.readAt (data.add (BitVec.ofNat 64 (128 * j))) 1024 = D.extractLsb' (1024 * j) 1024 := by
  rw [MemoryState.readAt_add_of_readAt hf.inBounds (block_noOverflow hdo (Nat.le_of_lt hj))
      (by
        simp; omega)
      h]
  congr 1
  simp
  omega

/-- The next block's pointer. -/
theorem add_block {data : Pointer} (j : Nat) :
    (data.add (BitVec.ofNat 64 (128 * j))).add 128#64 =
      data.add (BitVec.ofNat 64 (128 * (j + 1))) := by
  rw [Pointer.add_add, Nat.mul_succ, BitVec.ofNat_add]

/-- Block `j`'s pointer is not the end's before the last. -/
theorem block_ne {data : Pointer} {N j : Nat} (hdo : data.offset.toNat + 128 * N < 2 ^ 64)
    (hj : j < N) : data.add (BitVec.ofNat 64 (128 * j)) ≠ data.add (BitVec.ofNat 64 (128 * N)) := by
  intro h
  have := congrArg (fun p : Pointer => p.offset.toNat) h
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat] at this
  rw [Nat.mod_eq_of_lt (by omega : 128 * j < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega : 128 * N < 2 ^ 64), Nat.mod_eq_of_lt (by omega),
    Nat.mod_eq_of_lt (by omega)] at this
  omega

/-- The bytes from block `j` on: block `j`'s, then those from `j + 1`. -/
public theorem compressBlocks_drop {N j : Nat} (D : BitVec (1024 * N)) (hj : j < N)
    (H : Vector (BitVec 64) 8) :
    Sha512.compressBlocks H ((bytesLE D).drop (128 * j)) =
      Sha512.compressBlocks (Sha512.compress H (bytesLE (D.extractLsb' (1024 * j) 1024)))
        ((bytesLE D).drop (128 * (j + 1))) := by
  rw [Sha512.compressBlocks_of_le
      (by
        simp; omega),
    List.drop_drop, bytesLE_extractLsb' D (by omega) (by decide) (by omega)]
  simp only [show 1024 * j / 8 = 128 * j by omega, show 1024 / 8 = 128 by rfl,
    show 128 * j + 128 = 128 * (j + 1) by omega]

/-- No bytes after the last block. -/
public theorem compressBlocks_drop_all {N : Nat} (D : BitVec (1024 * N))
    (H : Vector (BitVec 64) 8) : Sha512.compressBlocks H ((bytesLE D).drop (128 * N)) = H :=
  Sha512.compressBlocks_of_lt
    (by
      simp; omega)

/-- `n << 7` drops no bits for `n < 2 ^ 56`. -/
theorem shl7_nuw {n : BitVec 64} (h : n.toNat < 2 ^ 56) : n <<< 7 >>> 7 = n := by
  have : n < 72057594037927936#64 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `n << 7` keeps its sign for `n < 2 ^ 56`. -/
theorem shl7_nsw {n : BitVec 64} (h : n.toNat < 2 ^ 56) : (n <<< 7).sshiftRight 7 = n := by
  have : n < 72057594037927936#64 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- The end pointer's offset does not wrap. -/
theorem end_noOverflow {blocks : Pointer} {n : BitVec 64} (h : n.toNat < 2 ^ 56)
    (hdo : blocks.offset.toNat + 128 * n.toNat < 2 ^ 64) :
    ¬blocks.offset.uaddOverflow (n <<< 7) := by
  simp only [BitVec.uaddOverflow, BitVec.toNat_shiftLeft, decide_eq_true_eq, Nat.not_le]
  rw [Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]
  omega

/-- `n << 7`, the blocks' bytes. -/
theorem shl7_eq (n : BitVec 64) : n <<< 7 = BitVec.ofNat 64 (128 * n.toNat) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, Nat.shiftLeft_eq]
  congr 1
  omega

/-- Block `j`'s offset does not wrap by its `128` bytes. -/
theorem block_end_noOverflow {data : Pointer} {N j : Nat}
    (hdo : data.offset.toNat + 128 * N < 2 ^ 64) (hj : j < N) :
    ¬(data.add (BitVec.ofNat 64 (128 * j))).offset.uaddOverflow 128#64 := by
  simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : 128 * j < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  simp
  omega

/-- The blocks from `k` on, `m + 1` of them left, from the state words `H`: each block's rounds and
sums, then `^bb2` with the words `compressBlocks` leaves. -/
theorem blocks_loop (st blocks Kp En : Pointer) (A : Vals compress512.Γ.args) (N : Nat)
    (D : BitVec (1024 * N)) (S : GlobalState) (g : Vals [] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hB : Fits S.mem blocks (1024 * N))
    (hdo : blocks.offset.toNat + 128 * N < 2 ^ 64) (hBr : S.mem.readAt blocks (1024 * N) = D)
    (hEn : En = blocks.add (BitVec.ofNat 64 (128 * N))) (hKf : Fits S.mem Kp 5120)
    (hKo : Kp.offset = 0)
    (hK : ∀ t, t < 80 → S.mem.readAt (Kp.add (BitVec.ofNat 64 (8 * t))) 64 = Sha512.K[t]!) :
    ∀ m k (H : Vector (BitVec 64) 8) (E : ⟪Γ⟫),
      k + m + 1 = N →
        E.args = A.get →
        Statics st Kp En E →
        (∀ E' : ⟪Γ⟫,
          E'.args = A.get →
            Statics st Kp En E' →
            (compress512.runFrom
                  E'[rir_dst% compress512.hty 3088 :=
                    .value (Sha512.compressBlocks H ((bytesLE D).drop (128 * k)))[0],
                    rir_dst% compress512.hty 3089 :=
                    .value (Sha512.compressBlocks H ((bytesLE D).drop (128 * k)))[1],
                    rir_dst% compress512.hty 3090 :=
                    .value (Sha512.compressBlocks H ((bytesLE D).drop (128 * k)))[2],
                    rir_dst% compress512.hty 3091 :=
                    .value (Sha512.compressBlocks H ((bytesLE D).drop (128 * k)))[3],
                    rir_dst% compress512.hty 3092 :=
                    .value (Sha512.compressBlocks H ((bytesLE D).drop (128 * k)))[4],
                    rir_dst% compress512.hty 3093 :=
                    .value (Sha512.compressBlocks H ((bytesLE D).drop (128 * k)))[5],
                    rir_dst% compress512.hty 3094 :=
                    .value (Sha512.compressBlocks H ((bytesLE D).drop (128 * k)))[6],
                    rir_dst% compress512.hty 3095 :=
                    .value (Sha512.compressBlocks H ((bytesLE D).drop (128 * k)))[7]]
                  2 S >>=
                g) =
              K) →
        (compress512.runFrom (hdr (blocks.add (BitVec.ofNat 64 (128 * k))) H E) 1 S >>= g) = K := by
  intro m
  induction m with
  | zero =>
    intro k H E hk hA hst hexit
    have hkN : k < N := by omega
    have hBk := readAt_block hB hdo hkN hBr
    refine
      rounds0 st Kp En _ A H _ E S g K hA hst (fits_block hB hdo hkN) (block_end_noOverflow hdo hkN)
        hKf hKo hK (schedule_words _).2.2
        (by
          rw [hBk]; exact (schedule_words _).1)
        (fun t ht => by
          rw [hBk]; exact (schedule_words _).2.1 t ht)
        ?_
    intro E1 a20 a19 a18 a17 e20 e19 e18 e17 hacc hA1 hst1 hpar1 hlive1
    refine
      rounds20 st Kp En _ A H _ a20 a19 a18 a17 e20 e19 e18 e17 E1 S g K hA1 hst1 hpar1 hlive1 hKf
        hKo hK (schedule_words _).2.2 hacc ?_
    intro E2 a40 a39 a38 a37 e40 e39 e38 e37 hacc hA2 hst2 hpar2 hlive2
    refine
      rounds40 st Kp En _ A H _ a40 a39 a38 a37 e40 e39 e38 e37 E2 S g K hA2 hst2 hpar2 hlive2 hKf
        hKo hK (schedule_words _).2.2 hacc ?_
    intro E3 a60 a59 a58 a57 e60 e59 e58 e57 hacc hA3 hst3 hpar3 hlive3
    refine
      rounds60 st Kp En _ A H _ a60 a59 a58 a57 e60 e59 e58 e57 E3 S g K hA3 hst3 hpar3 hlive3 hKf
        hKo hK (schedule_words _).2.2 hacc ?_
    intro E4 Nv hN hA4 hst4 hR4
    refine exit_eq En _ Nv E4 S g K hR4 (fun _ => ?_) (fun hb => ?_)
    · rw [compressBlocks_drop D hkN, show k + 1 = N by omega, compressBlocks_drop_all, ←
        compress_eq, ← hN] at hexit
      exact hexit E4 hA4 hst4
    · exact absurd (by rw [add_block, show k + 1 = N by omega, hEn]) hb
  | succ m ih =>
    intro k H E hk hA hst hexit
    have hkN : k < N := by omega
    have hBk := readAt_block hB hdo hkN hBr
    refine
      rounds0 st Kp En _ A H _ E S g K hA hst (fits_block hB hdo hkN) (block_end_noOverflow hdo hkN)
        hKf hKo hK (schedule_words _).2.2
        (by
          rw [hBk]; exact (schedule_words _).1)
        (fun t ht => by
          rw [hBk]; exact (schedule_words _).2.1 t ht)
        ?_
    intro E1 a20 a19 a18 a17 e20 e19 e18 e17 hacc hA1 hst1 hpar1 hlive1
    refine
      rounds20 st Kp En _ A H _ a20 a19 a18 a17 e20 e19 e18 e17 E1 S g K hA1 hst1 hpar1 hlive1 hKf
        hKo hK (schedule_words _).2.2 hacc ?_
    intro E2 a40 a39 a38 a37 e40 e39 e38 e37 hacc hA2 hst2 hpar2 hlive2
    refine
      rounds40 st Kp En _ A H _ a40 a39 a38 a37 e40 e39 e38 e37 E2 S g K hA2 hst2 hpar2 hlive2 hKf
        hKo hK (schedule_words _).2.2 hacc ?_
    intro E3 a60 a59 a58 a57 e60 e59 e58 e57 hacc hA3 hst3 hpar3 hlive3
    refine
      rounds60 st Kp En _ A H _ a60 a59 a58 a57 e60 e59 e58 e57 E3 S g K hA3 hst3 hpar3 hlive3 hKf
        hKo hK (schedule_words _).2.2 hacc ?_
    intro E4 Nv hN hA4 hst4 hR4
    refine exit_eq En _ Nv E4 S g K hR4 (fun hb => ?_) (fun _ => ?_)
    · rw [add_block, hEn] at hb
      exact absurd hb (block_ne hdo (by omega))
    · rw [compressBlocks_drop D hkN, ← compress_eq, ← hN] at hexit
      rw [add_block]
      exact ih (k + 1) Nv E4 (by omega) hA4 hst4 hexit

end Proof

end compress512

open compress512 in
/-- The `K` table's initializer gives its folded constant, leaving the state. -/
public theorem anon_13b8ab24e6986c1da96f68a50a4d6db2_1.value_eq (s : GlobalState) :
    anon_13b8ab24e6986c1da96f68a50a4d6db2_1.value s =
      .value (Ty.wrap anon_13b8ab24e6986c1da96f68a50a4d6db2_1.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

open compress512 in
-- `^bb0`'s 110 steps, its 79 pointers into the `K` table among them
set_option maxHeartbeats 1000000 in
/-- `compress512(state, blocks, n)` compresses the `n` 128-byte blocks at `blocks` into the eight
state words at `state` (`compress512.spec`, SHA-512's compression of each block in order) and
stores the result there. The words are read before and stored after the blocks are read, so the
two may overlap. -/
public theorem compress512.call_eq (st blocks : Pointer) (n : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals compress512.globals) (hst : s.mem.Sha512Fit st)
    (hstw : Writable s.mem st) (hn : n ≠ 0) (hn56 : n.toNat < 2 ^ 56)
    (hB : Fits s.mem blocks (1024 * n.toNat)) (hdo : blocks.offset.toNat + 128 * n.toNat < 2 ^ 64) :
    compress512.call (compress512.args (.value st) (.value blocks) (.value n)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeSha512 st
                (compress512.spec (s.mem.readSha512 st)
                  (bytesLE (s.mem.readAt blocks (1024 * n.toNat)))) }) := by
  generalize hres :
    compress512.spec (s.mem.readSha512 st) (bytesLE (s.mem.readAt blocks (1024 * n.toNat))) = res
  func_init
  block_init
  iterate 10 step_pure
  step_addressof anon_13b8ab24e6986c1da96f68a50a4d6db2_1.value_eq with Kp
  iterate 3 step_pure
  iterate 79 step_pure
  step_pure [shl7_nuw hn56, shl7_nsw hn56]
  have hov := end_noOverflow hn56 hdo
  step_pure [Nat.mod_lt _ (show 0 < 2 ^ 64 by decide)]
  step_load
  iterate 7 step_pure
  iterate 7 step_load
  finish_block
  have hBr : S.mem.readAt blocks (1024 * n.toNat) = S₀.mem.readAt blocks (1024 * n.toNat) := by
    rw [hS]
  have hn0 : 0 < n.toNat := by
    rcases Nat.eq_zero_or_pos n.toNat with h | h
    · exact absurd (BitVec.eq_of_toNat_eq (by simpa using h)) hn
    · exact h
  run_from using
    blocks_loop st blocks Kp (blocks.add (n <<< 7)) _ n.toNat _ S _ _ hB hdo hBr (by rw [shl7_eq])
      hKp_fits hKp_off (readAt_K hKp_fits hKp_off hread_Kp) (n.toNat - 1) 0 (S₀.mem.readSha512 st)
  intro hst'
  block_init
  iterate 8 step_store
  finish_block
  subst hS
  erase_frame
  subst hres
  rfl

end MLIR.Agave.Serial
