module

public import Agave.Serial.Mlir.IterMut_u8_Zeroize_zeroize

meta import Agave.Serial.Mlir.IterMut_u8_Zeroize_zeroize

/-! `<IterMut<u8> as Zeroize>::zeroize` on an iterator stored at `it`, over four bytes at `buf`:
the bytes zeroed, the iterator's pointers loaded and stored back. -/

namespace MLIR.Agave.Serial

private def it : Pointer :=
  ⟨⟨1⟩, 0⟩

private def buf (k : Nat) : Pointer :=
  ⟨⟨2⟩, BitVec.ofNat 64 k⟩

/-- `it` holding the iterator over bytes `k … 3` of `buf`, its pointers stored. -/
private def s0 (k : Nat) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList
    [(⟨1⟩, ⟨16, 0, 0, true, fun o => if o = 0 then some (buf k) else if o = 64 then some (buf 4)
      else none⟩), (⟨2⟩, .ofBytes 4 0xdeadbeef)]⟩⟩

/-- The bytes at `buf` and the iterator's start after the call, or `none` for UB. -/
private def zeroizeOut (k : Nat) : Option (BitVec 32 × PoisonOr Pointer) :=
  match IterMut_u8_Zeroize_zeroize.eval 6 (IterMut_u8_Zeroize_zeroize.args (.value it)) (s0 k) with
  | .value (some .nil, s) => some (s.mem.readAt (buf 0) 32, s.mem.loadPtr it)
  | _ => none

#guard zeroizeOut 0 == some (0, .value (buf 4))
#guard zeroizeOut 2 == some (0x0000beef, .value (buf 4))
#guard zeroizeOut 4 == some (0xdeadbeef, .value (buf 4))

end MLIR.Agave.Serial
