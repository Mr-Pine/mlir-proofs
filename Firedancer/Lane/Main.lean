module

public import Firedancer.Lane.fd_ed25519_verify_batch_multi_msg
public import Firedancer.Lane.fd_ed25519_verify
public import Firedancer.Lane.verify_x8

/-! PR 11958's batch verify returns `fd_ed25519_verify`'s codes: `results[j]` is
`Ed25519.Firedancer.verify` of item `j`, for every batch shape. Assumed are only the callees the
framework cannot lift yet: the multi-buffer SHA-512 (`BatchSpec`) and, for the cached entry, the
cached verify (`VerifyCachedCallSpec`). -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (bytesLE)
open _root_.Firedancer.Lane.Mlir

/-- `fd_ed25519_verify_batch_multi_msg`: each `results[j]` is item `j`'s `fd_ed25519_verify` code,
given the multi-buffer SHA-512's spec. -/
public theorem fd_ed25519_verify_batch_multi_msg.results_of_batch
    (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (hb : BatchSpec batch Gb) (a : Arrays) (n : BitVec 64) (it : Nat → Item) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals ((fd_ed25519_verify_batch_multi_msg batch).globals ++ Gb))
    (hB : BatchOk s.mem a it n.toNat) :
    ∃ s',
      (fd_ed25519_verify_batch_multi_msg batch).call
          (fd_ed25519_verify_batch_multi_msg.args (.value a.msgs) (.value a.msgSzs)
            (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results) (.value n))
          s =
        .value (.nil, s') ∧
      ∀ j < n.toNat,
        s'.mem.readAt (a.results.add (BitVec.ofNat 64 (j * 4))) 32 =
          _root_.Ed25519.Firedancer.verify
            (bytesLE (s.mem.readAt (it j).msg (8 * (it j).msgSz.toNat)))
            (s.mem.readAt (it j).sig 256) (s.mem.readAt ((it j).sig.add 32#64) 256)
            (s.mem.readAt (it j).pk 256) :=
  fd_ed25519_verify_batch_multi_msg.results batch Gb fd_ed25519_verify.call_spec
    (verify_x8.call_spec batch Gb hb) a n it s hwf hg hB

/-- `fd_ed25519_verify_batch_multi_msg_cached`: the same, given also the cached verify's spec. -/
public theorem fd_ed25519_verify_batch_multi_msg_cached.results_of_batch
    (batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])) (Gb : List Global)
    (hb : BatchSpec batch Gb) (verifyCached : VerifyCached) (G : List Global) (cache : Pointer)
    (hvc : VerifyCachedCallSpec verifyCached G cache) (a : Arrays) (n : BitVec 64)
    (it : Nat → Item) (s : GlobalState) (hwf : s.WF) (hG : s.mem.Globals G)
    (hg :
      s.mem.Globals ((fd_ed25519_verify_batch_multi_msg_cached batch verifyCached).globals ++ Gb))
    (hB : BatchOk s.mem a it n.toNat)
    (hcache : ¬a.ReadOnly it n.toNat cache.id ∧ (∀ j < n.toNat, cache.id ≠ (it j).sha.id) ∧
      cache.id ≠ a.results.id) :
    ∃ s',
      (fd_ed25519_verify_batch_multi_msg_cached batch verifyCached).call
          (fd_ed25519_verify_batch_multi_msg_cached.args (.value a.msgs) (.value a.msgSzs)
            (.value a.sigs) (.value a.pks) (.value a.shas) (.value a.results) (.value n)
            (.value cache))
          s =
        .value (.nil, s') ∧
      ∀ j < n.toNat,
        s'.mem.readAt (a.results.add (BitVec.ofNat 64 (j * 4))) 32 =
          _root_.Ed25519.Firedancer.verify
            (bytesLE (s.mem.readAt (it j).msg (8 * (it j).msgSz.toNat)))
            (s.mem.readAt (it j).sig 256) (s.mem.readAt ((it j).sig.add 32#64) 256)
            (s.mem.readAt (it j).pk 256) :=
  fd_ed25519_verify_batch_multi_msg_cached.results batch Gb verifyCached G cache hvc
    (verify_x8.call_spec batch Gb hb) a n it s hwf hG hg hB hcache

end MLIR.Firedancer.Lane
