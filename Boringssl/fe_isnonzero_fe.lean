module

public import MLIR.Run.Tactic
public import Boringssl.fe_tobytes
public import Boringssl.CRYPTO_memcmp
public import Boringssl.Mlir.fe_isnonzero_fe

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `CRYPTO_memcmp(s, zero, 32) != 0` on `f`'s canonical bytes `s`: `1` unless they are all
zero. -/
def fe_isnonzero_fe.spec (f : Fin 5 → BitVec 64) : BitVec 32 :=
  let s := Firedancer.Ref.fiat_25519_to_bytes.spec f
  (BitVec.ofBool (CRYPTO_memcmp.spec s 0#256 32 != 0#32)).setWidth 32

end

/-! ## Proof -/

section Proof

/-- `zero`'s initializer: 32 zero bytes. -/
public theorem fe_isnonzero_zero.value_eq (s : GlobalState) :
    fe_isnonzero_zero.value s = .value (Ty.wrap fe_isnonzero_zero.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `zero`'s bits. -/
theorem fe_isnonzero_zero.flatBits_eq {hw : (Ty.array 32 (.bv 8)).width = 256} :
    Ty.flatBits fe_isnonzero_zero.lit (hw := hw) = 0#256 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have h :=
    Ty.extractLsb'_flattenRaw_array (s := 8 * (i / 8)) (w := 8) fe_isnonzero_zero.lit
      (by
        simp [Ty.stride, Ty.width, Ty.padding, Ty.align]; omega)
      (by simp [Ty.stride, Ty.width, Ty.padding, Ty.align])
  have := congrArg (·.getLsbD (i % 8)) h
  simp only [fe_isnonzero_zero.lit, BitVec.getLsbD_extractLsb',
    show 8 * (i / 8) + i % 8 = i by omega, show i % 8 < 8 by omega, decide_true,
    Bool.true_and] at this
  rw [Ty.flatBits_eq, BitVec.getLsbD_cast, fe_isnonzero_zero.lit, this]
  simp [Ty.flattenRaw]

/-- `fe_isnonzero` returns `spec f`. The buffer, `zero`'s block and `fe_tobytes`'s 21 blocks are
freed again: only the counter moves on. -/
public theorem fe_isnonzero_fe.call_eq (f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hf : s.mem.LimbsFit f) :
    fe_isnonzero_fe.call (fe_isnonzero_fe.args (.value f)) s =
      .value
        (.cons (.value (fe_isnonzero_fe.spec (s.mem.readLimbs f))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 23⟩, mem := s.mem }) := by
  func_init
  have hfR : S₀.mem.LimbsRoom f := (hS ▸ hf).room
  block_init
  step_pure
  -- static const uint8_t zero[32] = {0};
  step_addressof fe_isnonzero_zero.value_eq with zero
  have hread_zero' : S.mem.readAt zero 256 = 0#256 := hread_zero.trans fe_isnonzero_zero.flatBits_eq
  clear hread_zero
  iterate 2 step_pure
  -- uint8_t s[32];
  step_alloca with buf
  step_pure
  -- fe_tobytes(s, f);
  step_call using fe_tobytes.call_eq consuming hf
  -- return CRYPTO_memcmp(s, zero, sizeof(zero)) != 0;
  have hbuf_ov : ¬buf.offset.uaddOverflow 32#64 := by simp [hbuf_off, BitVec.uaddOverflow]
  have hzero_ov : ¬zero.offset.uaddOverflow 32#64 := by simp [hzero_off, BitVec.uaddOverflow]
  step_call using CRYPTO_memcmp.call_eq
  iterate 3 step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Boringssl
