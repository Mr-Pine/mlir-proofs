module

public import MLIR.Run.Tactic
public import Sodium.Common.Memory
public import Sodium.load64_be
public import Sodium.Mlir.be64dec_vect

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `dst[i] = LOAD64_BE(src + i * 8)`: word `i` of the 128 bytes `block`, big-endian. -/
def be64dec_vect.spec (block : BitVec 1024) (i : Nat) : BitVec 64 :=
  load64_be.spec (block.extractLsb' (64 * i) 64)

end

/-! ## Proof -/

section Proof

/-- `be64dec_vect(dst, src, 128)` stores the 16 big-endian words of the block at `src` at `dst`.
The two must not share a block. -/
public theorem be64dec_vect.call_eq (dst src : Pointer) (s : GlobalState) (hwf : s.WF)
    (hdst : Room s.mem dst 1024) (hdsto : ¬dst.offset.uaddOverflow 128#64)
    (hsrc : Fits s.mem src 1024) (hsrco : ¬src.offset.uaddOverflow 128#64)
    (hsep : dst.id ≠ src.id) :
    be64dec_vect.call (be64dec_vect.args (.value dst) (.value src)) s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeWords dst (be64dec_vect.spec (s.mem.readAt src 1024)) 16 }) := by
  generalize hx : s.mem.readAt src 1024 = x
  have ho (k : Nat) (hk : k < 16) : ¬(src.add (BitVec.ofNat 64 (8 * k))).offset.uaddOverflow 8#64 :=
    Pointer.not_uaddOverflow_add hsrco
      (by
        simp; omega)
  func_init
  block_init
  -- dst[0] = LOAD64_BE(src);
  step_call using (load64_be.call_eq (hsrco := by simpa using ho 0 (by decide)))
  step_store consuming hread_dst hfits_dst
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 1 (by decide)))
  step_pure
  step_store consuming hread_dst_8 hfits_dst_8
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 2 (by decide)))
  step_pure
  step_store consuming hread_dst_16 hfits_dst_16
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 3 (by decide)))
  step_pure
  step_store consuming hread_dst_24 hfits_dst_24
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 4 (by decide)))
  step_pure
  step_store consuming hread_dst_32 hfits_dst_32
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 5 (by decide)))
  step_pure
  step_store consuming hread_dst_40 hfits_dst_40
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 6 (by decide)))
  step_pure
  step_store consuming hread_dst_48 hfits_dst_48
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 7 (by decide)))
  step_pure
  step_store consuming hread_dst_56 hfits_dst_56
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 8 (by decide)))
  step_pure
  step_store consuming hread_dst_64 hfits_dst_64
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 9 (by decide)))
  step_pure
  step_store consuming hread_dst_72 hfits_dst_72
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 10 (by decide)))
  step_pure
  step_store consuming hread_dst_80 hfits_dst_80
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 11 (by decide)))
  step_pure
  step_store consuming hread_dst_88 hfits_dst_88
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 12 (by decide)))
  step_pure
  step_store consuming hread_dst_96 hfits_dst_96
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 13 (by decide)))
  step_pure
  step_store consuming hread_dst_104 hfits_dst_104
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 14 (by decide)))
  step_pure
  step_store consuming hread_dst_112 hfits_dst_112
  step_pure
  step_call using (load64_be.call_eq (hsrco := ho 15 (by decide)))
  step_pure
  step_store consuming hread_dst_120 hfits_dst_120
  finish_block
  rw [hS]
  simp only [MemoryState.storeWords, spec, Nat.mul_zero, Pointer.add_zero]
  rfl

end Proof

end MLIR.Sodium
