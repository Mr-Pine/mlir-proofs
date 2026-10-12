module

public import Agave.Avx2.compress512.Basic
public import Agave.Serial.Mlir.anon_13b8ab24e6986c1da96f68a50a4d6db2_1

/-! `K64`'s table, as `compress512` reads it: pairs of round constants. -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave

/-- A byte array's literal whose byte `i` is that of `N`: `N`'s bits. -/
theorem flatBits_ofFn_bytes {n N w : Nat} {hw : (Ty.array n (.bv 8)).width = w} :
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

/-- The table's pairs of words: `K[t]`, `K[t + 1]`. -/
theorem K_pairs {hw : (Ty.array 640 (.bv 8)).width = 5120} :
    ∀ t,
      t < 79 →
        (Ty.flatBits Serial.anon_13b8ab24e6986c1da96f68a50a4d6db2_1.lit (hw := hw)).extractLsb'
            (64 * t) 128 =
          BitVec.packLanes #v[Sha512.K[t]!, Sha512.K[t + 1]!] := by
  unfold Serial.anon_13b8ab24e6986c1da96f68a50a4d6db2_1.lit
  rw [flatBits_ofFn_bytes]
  decide +kernel

/-- The table's block, read as pairs. -/
public theorem kPairs_of_readAt {m : MemoryState} {Kp : Pointer}
    {hw : (Ty.array 640 (.bv 8)).width = 5120} (hf : Fits m Kp 5120) (ho : Kp.offset = 0)
    (h :
      m.readAt Kp 5120 =
        Ty.flatBits Serial.anon_13b8ab24e6986c1da96f68a50a4d6db2_1.lit (hw := hw)) :
    KPairs m Kp := by
  intro k hk
  rw [MemoryState.readAt_add_of_readAt hf.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      h,
    show (BitVec.ofNat 64 (k * 8)).toNat * 8 = 64 * k by
      simp; omega]
  exact K_pairs k (by omega)

end MLIR.Agave.Avx2.compress512
