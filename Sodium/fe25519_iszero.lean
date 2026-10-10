module

public import MLIR.Run.Tactic
public import Sodium.fe25519_tobytes
public import Sodium.sodium_is_zero
public import Sodium.Mlir.fe25519_iszero

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `1` if `f`'s canonical encoding is zero, else `0`: `sodium_is_zero(s, 32)`. -/
def fe25519_iszero.spec (f : Fin 5 → BitVec 64) : BitVec 32 :=
  sodium_is_zero.spec (fe25519_tobytes.spec f) 32

end

/-! ## Proof -/

section Proof

/-- `fe25519_iszero` returns `spec f`. The encoding goes through a temporary, freed again: only
the counter moves on, by three blocks (its own, `fe25519_tobytes`'s and `sodium_is_zero`'s). -/
public theorem fe25519_iszero.call_eq (f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hf : s.mem.LimbsFit f) :
    fe25519_iszero.call (fe25519_iszero.args (.value f)) s =
      .value
        (.cons (.value (fe25519_iszero.spec (s.mem.readLimbs f))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 2 step_pure
  -- unsigned char s[32];
  step_alloca with buf
  step_pure
  have hbuf_end : buf.offset.toNat + 32 < 2 ^ 64 := by simp [hbuf_off]
  -- fe25519_tobytes(s, f);
  step_call using fe25519_tobytes.call_eq consuming hf
  -- return sodium_is_zero(s, 32);
  step_call using sodium_is_zero.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Sodium
