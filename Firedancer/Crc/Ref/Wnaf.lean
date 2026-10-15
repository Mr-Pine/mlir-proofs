module

public import Firedancer.Math.Wnaf

/-!
# wNAF correctness reused for `crc_adx_wnaf`

`crc_adx_wnaf` (PR firedancer #12267, `crc/ref/fd_ed25519_ref_verify.c`) rewrites a 256-bit
little-endian scalar as windowed non-adjacent form: the signed digits `d₀, d₁, …` with
`∑ᵢ dᵢ · 2^i = s`, each `dᵢ` zero or odd and `|dᵢ| ≤ 2^bits − 1`.

It peels one digit per right shift, where the tree's `fd_curve25519_scalar_wnaf` scans to the next
set bit; both pick the same signed window representative and clear the same bits, so they produce
the same digit sequence. The mathematical correctness of that sequence is already proved, once, in
`Firedancer.Math.Wnaf` (`wnaf_sum`, `wnaf_digit`), for `1 ≤ bits ≤ 13` and `s < 2^255`. The PR uses
the windows `CRC_ADX_A_BITS = 4` and `CRC_ADX_BASE_BITS = 8` (split variant `3`), all in range; the
scalar is reduced below the group order `ℓ < 2^253`. We restate the two facts at the PR's windows,
so the reuse is explicit and checked. The `crc_adx_wnaf` lift equals this sequence is the separate
MLIR refinement obligation.
-/

namespace MLIR.Firedancer.Crc.Ref.Wnaf

open MLIR.Firedancer.Ref (fd_curve25519_scalar_wnaf)

@[expose] public section

/-- The digit sequence `crc_adx_wnaf` computes for scalar `s` and window `bits`: the tree's
already-modelled wNAF. -/
abbrev spec (s : BitVec 256) (bits : Nat) : Vector Int 256 :=
  fd_curve25519_scalar_wnaf.wnaf s bits

/-- **Reconstruction.** The digits sum back to the scalar (`s < 2^255`, `1 ≤ bits ≤ 13`). -/
theorem spec_sum (s : BitVec 256) (hb : 1 ≤ bits ∧ bits ≤ 13) (hs : s.toNat < 2 ^ 255) :
    ∑ i : Fin 256, (spec s bits)[i] * 2 ^ (i : Nat) = s.toNat :=
  fd_curve25519_scalar_wnaf.wnaf_sum s hb hs

/-- **Digit shape.** Each digit is `0` or odd with `|dᵢ| ≤ 2^bits − 1` (`1 ≤ bits`). -/
theorem spec_digit (s : BitVec 256) (hb : 1 ≤ bits) (hk : k < 256) :
    ((spec s bits)[k] = 0 ∨ Odd (spec s bits)[k]) ∧ (spec s bits)[k].natAbs ≤ 2 ^ bits - 1 :=
  fd_curve25519_scalar_wnaf.wnaf_digit s hb hk

end

end MLIR.Firedancer.Crc.Ref.Wnaf
