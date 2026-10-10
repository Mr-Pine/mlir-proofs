module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.Common.Fe
public import Firedancer.R52x5.fd_ulong_load_8
public import Firedancer.Ref.fd_f25519_frombytes
public import Firedancer.R52x5.Mlir.fd_f25519_frombytes
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_frombytes`: the 32 little-endian bytes `buf` as five 51-bit limbs, read 8 bytes at
a time from bytes 0, 6, 12, 19 and 24 (bit 255 dropped). -/
def fd_f25519_frombytes.spec (buf : BitVec 256) : Wwl :=
  wwl (buf.setWidth 64 &&& mask51) ((buf.extractLsb' 48 64 >>> 3) &&& mask51)
    ((buf.extractLsb' 96 64 >>> 6) &&& mask51) ((buf.extractLsb' 152 64 >>> 1) &&& mask51)
    ((buf.extractLsb' 192 64 >>> 12) &&& mask51) 0 0 0

end

/-! ## Ref's limbs -/

/-- The limbs are Ref's `fd_f25519_frombytes`'s. -/
public theorem fd_f25519_frombytes.limbs_spec (buf : BitVec 256) (i : Fin 5) :
    limbs (fd_f25519_frombytes.spec buf) i = Ref.fd_f25519_frombytes.spec buf i := by
  obtain ⟨i, hi⟩ := i
  obtain rfl | rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 ∨ i = 4 := by omega
  all_goals
    simp only [limbs, fd_f25519_frombytes.spec, Ref.fd_f25519_frombytes.spec,
      Ref.fiat_25519_from_bytes.spec, wwl, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ]
    bv_decide

/-! ## Proof -/

section Proof

/-- `fd_f25519_frombytes( r, buf )` stores `spec` of the 32 bytes at `buf` at `r` and returns
`r`. -/
public theorem fd_f25519_frombytes.call_eq (r buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : Room s.mem r 512) (hbuf : Fits s.mem buf 256)
    (hbuf_off : ¬buf.offset.uaddOverflow 32#64) :
    fd_f25519_frombytes.call (fd_f25519_frombytes.args (.value r) (.value buf)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem := s.mem.storeVec r (fd_f25519_frombytes.spec (s.mem.readAt buf 256)) }) := by
  have hov : ∀ k : BitVec 64, k ≤ 32#64 → ¬buf.offset.uaddOverflow k := by
    intro k hk
    simp only [BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, BitVec.le_def] at hbuf_off hk ⊢
    simp at hk hbuf_off
    omega
  have h0 : Fits s.mem buf 64 := Fits.mono (by decide) hbuf
  have h6 : Fits s.mem (buf.add 6#64) 64 := Fits.add_of_le (hov _ (by decide)) (by decide) hbuf
  have h12 : Fits s.mem (buf.add 12#64) 64 := Fits.add_of_le (hov _ (by decide)) (by decide) hbuf
  have h19 : Fits s.mem (buf.add 19#64) 64 := Fits.add_of_le (hov _ (by decide)) (by decide) hbuf
  have h24 : Fits s.mem (buf.add 24#64) 64 := Fits.add_of_le (hov _ (by decide)) (by decide) hbuf
  obtain ⟨b, hb⟩ : ∃ b, s.mem.readAt buf 256 = b := ⟨_, rfl⟩
  rw [hb]
  func_init
  block_init
  iterate 20 step_pure
  -- lanes 5-7: `0L, 0L, 0L`
  iterate 8 step_pure
  -- fd_ulong_load_8_fast( buf+6 ), ( buf+12 ), ( buf+19 ), ( buf )
  step_pure
  step_call using fd_ulong_load_8.call_eq
  step_pure
  step_call using fd_ulong_load_8.call_eq
  step_pure
  step_call using fd_ulong_load_8.call_eq
  step_call using fd_ulong_load_8.call_eq
  -- limbs 0-3 as one vector: `>> 0, 3, 6, 1` and `& FD_F25519_LIMB_MASK`
  iterate 4 step_pure
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  -- limb 4: `(fd_ulong_load_8_fast( buf+24 ) >> 12) & FD_F25519_LIMB_MASK`
  step_pure
  step_call using fd_ulong_load_8.call_eq
  step_pure
  step_pure
  -- r->el = wwl( … )
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  step_pure
  step_store
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Firedancer.R52x5
