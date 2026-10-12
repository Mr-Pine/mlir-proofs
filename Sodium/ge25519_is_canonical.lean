module

public import MLIR.Run.Tactic
public import Sodium.Common.Bytes
public import Sodium.Mlir.ge25519_is_canonical
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `1` when the low 255 bits of `s` are below `p`, as the C computes it: `c` is `0` exactly when
`s[31] & 0x7f = 0x7f` and `s[30] … s[1]` are all `0xff`, `d` is `1` when `s[0] ≥ 0xed`. -/
def ge25519_is_canonical.spec (s : BitVec 256) : BitVec 32 :=
  let byte (i : Nat) := s.extractLsb' (8 * i) 8
  let c := orBytes (fun i => byte (30 - i) ^^^ 0xff#8) ((byte 31 &&& 0x7f#8) ^^^ 0x7f#8) 30
  let c := (((c.setWidth 32) - 1#32) >>> 8).setWidth 8
  let d := ((0xec#32 - (byte 0).setWidth 32) >>> 8).setWidth 8
  1#32 - (c &&& d &&& 1#8).setWidth 32

end

/-! ## Proof -/

section Proof

/-- `ge25519_is_canonical` returns `spec` of the 32 bytes at `s`, read as byte and vector loads;
memory is unchanged. -/
public theorem ge25519_is_canonical.call_eq (s : Pointer) (st : GlobalState) (hwf : st.WF)
    (hs : Fits st.mem s 256) (hso : ¬s.offset.uaddOverflow 32#64) :
    ge25519_is_canonical.call (ge25519_is_canonical.args (.value s)) st =
      .value (.cons (.value (ge25519_is_canonical.spec (st.mem.readAt s 256))) .nil, st) := by
  obtain ⟨b, hb⟩ : ∃ b, st.mem.readAt s 256 = b := ⟨_, rfl⟩
  rw [hb]
  func_init
  block_init
  iterate 9 step_pure
  -- c = (s[31] & 0x7f) ^ 0x7f; for (i = 30; i > 0; i--) c |= s[i] ^ 0xff;
  step_load
  iterate 3 step_pure
  iterate 4
    step_load
    step_pure
  step_load
  iterate 12 step_pure
  -- c = (((unsigned int) c) - 1U) >> 8;
  step_pure
  -- d = (0xed - 1U - (unsigned int) s[0]) >> 8; return 1 - (c & d & 1);
  step_load
  step_pure
  step_pure
  iterate 4 step_pure
  finish_block
  rw [hS]
  clear hS hE hArgs hb hs hwf hso
  simp only [ge25519_is_canonical.spec, orBytes, Ty.extractVecElem_eq, fin_val_ofNat, Nat.reduceMod,
    Nat.reduceMul, Nat.reduceSub]
  -- the flagged `sub` and `add` do not wrap; the value
  repeat' split
  case isFalse.isFalse.isFalse =>
    congr
    bv_decide
  all_goals
    exfalso
    bv_decide

end Proof

end MLIR.Sodium
