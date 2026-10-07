module

public import Firedancer.Ref.fiat_25519_addcarryx_u51

meta import Firedancer.Ref.fiat_25519_addcarryx_u51

namespace LeanMLIR.RIR.Firedancer.Ref

private def out1 : Pointer :=
  ⟨⟨0⟩, 0⟩

private def out2 : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- An 8-byte block for `out1` and a 1-byte block for `out2`, both zeroed. -/
private def s0 : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨8, 0⟩), (⟨1⟩, ⟨1, 0⟩)]⟩⟩

/-- The two outputs, or `none` for UB / out of fuel. -/
private def outs (o1 : ⟦Ty.ptr⟧) (c : BitVec 8) (a b : BitVec 64) : Option (BitVec 64 × BitVec 8) :=
  match
    fiat_25519_addcarryx_u51.eval 1
      (fiat_25519_addcarryx_u51.args o1 (.value out2) (.value c) (.value a) (.value b)) s0 with
  | .value (some .nil, s) => some (s.mem.readAt out1 64, s.mem.readAt out2 8)
  | _ => none

/-- The run agrees with the spec. -/
private def agrees (c : BitVec 8) (a b : BitVec 64) : Bool :=
  outs (.value out1) c a b == some (fiat_25519_addcarryx_u51.spec c a b)

#guard agrees 0#8 1#64 2#64

-- a carry out of bit 51
#guard agrees 1#8 0x7ffffffffffff#64 0x7ffffffffffff#64

#guard outs (.value out1) 1#8 0x7ffffffffffff#64 0#64 == some (0#64, 1#8)

-- a poison pointer is UB
#guard (outs .poison 0#8 1#64 2#64).isNone

end LeanMLIR.RIR.Firedancer.Ref
