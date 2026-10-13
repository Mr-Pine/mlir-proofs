module

public import Agave.Avx2.compress512.Basic
public import Agave.Serial.Mlir.anon_13b8ab24e6986c1da96f68a50a4d6db2_1
import Agave.Serial.compress512

/-! `K64`'s table, as `compress512` reads it: pairs of round constants. -/

namespace MLIR.Agave.Avx2.compress512

open _root_.Ed25519 MLIR.Agave
open MLIR.Agave.Serial.compress512 (flatBits_ofFn_bytes)

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
