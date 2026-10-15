module

public import Firedancer.Crc.Ref.Verdict

/-!
# Batch verify and cache bookkeeping (spec and mathematical correctness)

The batch entry points of PR firedancer #12267 (`crc/ref/fd_ed25519_ref_verify.c`,
`fd_ed25519_ref_cache.c`) are thin wrappers over `fd_ed25519_verify` and the verdict rule:

  * `fd_ed25519_verify_batch_multi_msg` writes `results[j] = fd_ed25519_verify(item j)`
    (`fd_ed25519_crc.h`: "results[j] … is exactly fd_ed25519_verify's code for item j; nothing is
    aggregated across signatures");
  * `fd_ed25519_verify_batch_single_msg` returns `crc_adx_verdict` of those codes;
  * the cached forms return what their uncached counterparts return (the cache changes only timing),
    so these specs hold for the cached forms too.

With `verify` the per-signature result, we model the batch result as `List.map verify` and the
transaction result as `verdict` of that, and prove the transaction accepts exactly when every
signature verifies. The cache's credit counter is a saturating increment.
-/

namespace MLIR.Firedancer.Crc.Ref.Batch

open MLIR.Firedancer.Crc.Ref.Verdict

@[expose] public section

/-- `fd_ed25519_verify_batch_multi_msg`: item `j`'s code is `verify` of item `j`. -/
def multiMsg (verify : α → BitVec 32) (batch : List α) : List (BitVec 32) :=
  batch.map verify

/-- `FD_ED25519_ERR_SIG`. -/
def ERR_SIG : BitVec 32 := -1

/-- `fd_ed25519_verify_batch_single_msg`: `ERR_SIG` unless `1 ≤ batch_sz ≤ 16`, else the
transaction verdict of the per-signature codes (the C guards `batch_sz==0 || batch_sz>16`). -/
def singleMsg (verify : α → BitVec 32) (batch : List α) : BitVec 32 :=
  if batch = [] ∨ 16 < batch.length then ERR_SIG else verdict (multiMsg verify batch)

/-- `CRC_ADX_CACHE_CREDIT_MAX = 64 · 8`. -/
def creditMax : Nat := 64 * 8

/-- `crc_adx_cache_credit`: a saturating increment of the build-credit counter. -/
def credit (c : Nat) : Nat := min (c + 1) creditMax

/-! ## Mathematical correctness -/

/-- **Per-signature independence.** Each batch result is exactly that signature's verify code. -/
theorem multiMsg_get (verify : α → BitVec 32) (batch : List α) (j : Nat) (hj : j < batch.length) :
    (multiMsg verify batch)[j]'(by simpa [multiMsg] using hj) = verify batch[j] := by
  simp [multiMsg]

/-- **Transaction acceptance.** A well-formed single-message batch (`1 ≤ size ≤ 16`) accepts
exactly when every signature in it verifies (`SUCCESS`). -/
theorem singleMsg_accepts_iff (verify : α → BitVec 32) (batch : List α)
    (hne : batch ≠ []) (hle : batch.length ≤ 16) :
    singleMsg verify batch = SUCCESS ↔ ∀ item ∈ batch, verify item = SUCCESS := by
  unfold singleMsg
  split_ifs with h
  · exact absurd h (by rintro (h | h); exacts [hne h, by omega])
  · exact verdict_accepts_iff_all_verify verify batch

/-- Outside `1 ≤ size ≤ 16` the single-message batch is rejected with `ERR_SIG`, as the C guards. -/
theorem singleMsg_guard (verify : α → BitVec 32) (batch : List α)
    (h : batch = [] ∨ 16 < batch.length) : singleMsg verify batch = ERR_SIG := by
  unfold singleMsg
  split
  · rfl
  · rename_i h'; exact absurd h h'

/-- **Credit bound.** The credit counter never exceeds its cap, and a bounded counter stays
bounded. -/
theorem credit_le (c : Nat) : credit c ≤ creditMax := by
  simp [credit]

/-- The credit counter advances by one until it saturates. -/
theorem credit_eq (c : Nat) : credit c = if c + 1 ≤ creditMax then c + 1 else creditMax := by
  simp [credit, Nat.min_def]

end

end MLIR.Firedancer.Crc.Ref.Batch
