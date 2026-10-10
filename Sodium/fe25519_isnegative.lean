module

public import MLIR.Run.Tactic
public import Sodium.fe25519_tobytes
public import Sodium.Mlir.fe25519_isnegative

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- The low bit of `f`'s canonical encoding, `s[0] & 1` (`s[0]` promoted to `int`). -/
def fe25519_isnegative.spec (f : Fin 5 → BitVec 64) : BitVec 32 :=
  ((fe25519_tobytes.spec f).setWidth 8).setWidth 32 &&& 1#32

end

/-! ## Proof -/

section Proof

/-- `fe25519_isnegative` returns `spec f`. The encoding goes through a temporary, freed again:
only the counter moves on, by two blocks (its own and `fe25519_tobytes`'s). -/
public theorem fe25519_isnegative.call_eq (f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hf : s.mem.LimbsFit f) :
    fe25519_isnegative.call (fe25519_isnegative.args (.value f)) s =
      .value
        (.cons (.value (fe25519_isnegative.spec (s.mem.readLimbs f))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 2 step_pure
  -- unsigned char s[32];
  step_alloca with buf
  step_pure
  have hbuf_end : buf.offset.toNat + 32 < 2 ^ 64 := by simp [hbuf_off]
  -- fe25519_tobytes(s, f);
  step_call using fe25519_tobytes.call_eq consuming hf
  -- return s[0] & 1;
  step_load
  iterate 3 step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Sodium
