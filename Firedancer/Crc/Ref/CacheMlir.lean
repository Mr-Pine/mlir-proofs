module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.BitsMlir
public import Firedancer.Crc.Ref.Mlir.fd_ed25519_cache_footprint
public import Firedancer.Crc.Ref.Mlir.crc_adx_cache_credit
public import Firedancer.Crc.Ref.Mlir.fd_memeq
public import Firedancer.Crc.Ref.Mlir.fd_memeq_28
import Std.Tactic.BVDecide

/-!
# Cache helper refinements (MLIR lift ↔ spec)

`fd_ed25519_cache_footprint` as its `FD_LAYOUT` computation, `fd_memeq` on 32 bytes, and
`crc_adx_cache_credit`'s capped increment.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

/-- `fd_ed25519_cache_footprint(ent_cnt)`: `0` unless `ent_cnt` is a power of two in `[4, 2^20]`,
else the `FD_LAYOUT` size of the header, `ent_cnt/4` sets, `4·ent_cnt` filter slots and
`ent_cnt` tables of 32 cache lines. -/
def fd_ed25519_cache_footprint.spec (ent_cnt : BitVec 64) : BitVec 64 :=
  if ent_cnt < 4 ∨ ent_cnt > 1048576 ∨ fd_ulong_is_pow2.spec ent_cnt = 0 then 0
  else
    let set_cnt := ent_cnt / 4
    let l := fd_ulong_align_up.spec 0 128 + 128
    let l := fd_ulong_align_up.spec l 128 + set_cnt * 256
    let l := fd_ulong_align_up.spec l 8 + 4 * ent_cnt * 8
    let l := fd_ulong_align_up.spec l 64 + ent_cnt * 32 * 128
    fd_ulong_align_up.spec l 128

/-- `fd_memeq(a, b, 32)` on the two 32-byte values. -/
def fd_memeq.spec (a b : BitVec 256) : BitVec 32 :=
  if a = b then 1 else 0

/-- `crc_adx_cache_credit`'s new `credit`: one more, capped at `CREDIT_MAX = 512`. -/
def crc_adx_cache_credit.spec (credit : BitVec 64) : BitVec 64 :=
  fd_ulong_min.spec (credit + 1) 512

end

section Proof

namespace fd_ed25519_cache_footprint

/-- The lift's range test `ent_cnt - (2^20 + 1) <u -(2^20 - 3)`: `ent_cnt ∉ [4, 2^20]`. -/
abbrev Out (n : BitVec 64) : Prop :=
  (n + 18446744073708503039#64).ult 18446744073708503043#64 = true

theorem spec_of_out {n : BitVec 64} (h : Out n) : spec n = 0 := by
  unfold spec
  split
  · rfl
  · exact absurd (by bv_decide) ‹¬(_ ∨ _)›

theorem ne_zero {n : BitVec 64} (h : ¬Out n) : n ≠ 0 := by bv_decide

theorem spec_of_not_pow2 {n : BitVec 64} (h : fd_ulong_is_pow2.spec n = 0) : spec n = 0 := by
  unfold spec
  split
  · rfl
  · exact absurd (Or.inr (Or.inr h)) ‹_›

theorem noOverflow {n : BitVec 64} (h : ¬Out n) :
    n.smulOverflow 4128#64 = false ∧
      n.umulOverflow 4128#64 = false ∧
      (n * 4128#64).saddOverflow 224#64 = false ∧
      (n * 4128#64).uaddOverflow 224#64 = false ∧
      n <<< 6 >>> 6 = n ∧
      (n <<< 6).sshiftRight 6 = n ∧
      (n * 4128#64 + 224#64).saddOverflow (n <<< 6 &&& 134217472#64) = false ∧
      (n * 4128#64 + 224#64).uaddOverflow (n <<< 6 &&& 134217472#64) = false := by
  bv_decide

theorem spec_eq {n : BitVec 64} (h : ¬Out n) (hp : ¬fd_ulong_is_pow2.spec n = 0) :
    spec n = n * 4128#64 + 224#64 + (n <<< 6 &&& 134217472#64) &&& 68719476608#64 := by
  have hp' : n &&& (n - 1) = 0 := by
    unfold fd_ulong_is_pow2.spec at hp
    split at hp
    · exact ‹_ ∧ _›.2
    · exact absurd rfl hp
  unfold spec
  split
  · exfalso; bv_decide
  · simp only [fd_ulong_align_up.spec]
    bv_decide

end fd_ed25519_cache_footprint

/-- `fd_ed25519_cache_footprint` returns `spec ent_cnt`, state unchanged. -/
public theorem fd_ed25519_cache_footprint.call_eq (n : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    fd_ed25519_cache_footprint.call (fd_ed25519_cache_footprint.args (.value n)) s =
      .value (.cons (.value (fd_ed25519_cache_footprint.spec n)) .nil, s) := by
  func_init
  block_init
  iterate 11 step_pure
  finish_block
  · block_init
    finish_block
    rw [hS, spec_of_out hbr]
    rfl
  · have hin := hbr
    block_init
    step_call using (fd_ulong_is_pow2.call_eq (hx := ne_zero hin))
    step_pure
    finish_block
    · block_init
      finish_block
      rw [hS, spec_of_not_pow2 hbr]
      rfl
    · block_init
      iterate 6 step_pure
      finish_block
      block_init
      finish_block
      rw [hS, spec_eq hin hbr]
      simp only [noOverflow hin, Bool.false_eq_true, ↓reduceIte]

theorem memeq_res (a b : BitVec 256) :
    BitVec.setWidth 32 (BitVec.ofBool (BitVec.setWidth 32 (BitVec.ofBool (a != b)) == 0#32)) =
      fd_memeq.spec a b := by
  unfold fd_memeq.spec
  split <;> bv_decide

/-- The lift is specialised to `sz = 32`. -/
public theorem fd_memeq.call_eq (p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 256) (hq : Fits s.mem q 256) :
    fd_memeq.call (fd_memeq.args (.value p) (.value q)) s =
      .value
        (.cons (.value (fd_memeq.spec (s.mem.readAt p 256) (s.mem.readAt q 256))) .nil, s) := by
  func_init
  block_init
  step_pure
  step_load
  step_load
  iterate 4 step_pure
  finish_block
  subst hv1 hv2
  rw [hS, memeq_res]

/-- The lift is specialised to `sz = 32`. -/
public theorem fd_memeq_28.call_eq (p q : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 256) (hq : Fits s.mem q 256) :
    fd_memeq_28.call (fd_memeq_28.args (.value p) (.value q)) s =
      .value
        (.cons (.value (fd_memeq.spec (s.mem.readAt p 256) (s.mem.readAt q 256))) .nil, s) := by
  func_init
  block_init
  step_pure
  step_load
  step_load
  iterate 4 step_pure
  finish_block
  subst hv1 hv2
  rw [hS, memeq_res]

/-- `crc_adx_cache_credit` stores `spec credit` over the `credit` field (offset 40). -/
public theorem crc_adx_cache_credit.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hoff : ¬p.offset.uaddOverflow 40#64) (hfits : Fits s.mem (p.add 40#64) 64)
    (hroom : Room s.mem (p.add 40#64) 64) :
    crc_adx_cache_credit.call (crc_adx_cache_credit.args (.value p)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeAt (p.add 40#64)
                (crc_adx_cache_credit.spec (s.mem.readAt (p.add 40#64) 64)) }) := by
  func_init
  block_init
  step_pure
  step_pure [gep_value hoff (.inr (by decide))]
  step_load
  step_pure
  step_call using fd_ulong_min.call_eq
  step_store
  finish_block
  rw [hS, hv2]
  rfl

end Proof

end MLIR.Firedancer.Crc.Ref
