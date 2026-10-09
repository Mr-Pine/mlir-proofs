module

public import Firedancer.Ref.fiat_25519_cmovznz_u64

meta import Firedancer.Ref.fiat_25519_cmovznz_u64

namespace MLIR.Firedancer.Ref

private def s0 : GlobalState :=
  ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨8, 0⟩)]⟩⟩

private def p0 : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- The 64 bits at `p0` after the run, or `none` for UB / out of fuel. -/
private def out (c : BitVec 8) (a b : BitVec 64) : Option (BitVec 64) :=
  match
    fiat_25519_cmovznz_u64.eval 1
      (fiat_25519_cmovznz_u64.args (.value p0) (.value c) (.value a) (.value b)) s0 with
  | .value (some _, s) => some (s.mem.readAt p0 64)
  | _ => none

-- NOTE: these encode LLVM's `select`: `select c, x, y` yields `x` when `c` is *true*.
-- They currently fail, because `Operation.select` picks `x` when the condition is 0.
#guard out 0#8 11#64 22#64 == some 11#64

#guard out 1#8 11#64 22#64 == some 22#64

#guard out 7#8 11#64 22#64 == some 22#64

/-- A poison argument that the store depends on is UB. -/
private def outPoison : Option (BitVec 64) :=
  match
    fiat_25519_cmovznz_u64.eval 1
      (fiat_25519_cmovznz_u64.args (.value p0) .poison (.value 11#64) (.value 22#64)) s0 with
  | .value (some _, s) => some (s.mem.readAt p0 64)
  | _ => none

#guard outPoison.isNone

end MLIR.Firedancer.Ref
