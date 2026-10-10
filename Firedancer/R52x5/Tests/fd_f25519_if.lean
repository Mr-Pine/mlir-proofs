module

public import Firedancer.R52x5.fd_f25519_if

meta import Firedancer.R52x5.fd_f25519_if

namespace MLIR.Firedancer.R52x5

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a0 : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a1 : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three 64-byte blocks: `r` zeroed, `a0` and `a1` holding `x0` and `x1`. -/
private def state (x0 x1 : BitVec 512) : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 64 0), (⟨1⟩, .ofBytes 64 x0), (⟨2⟩, .ofBytes 64 x1)]⟩⟩

/-- The bits at `r` if `r` is returned and holds `spec`, else `none`. -/
private def out (c : BitVec 32) (x0 x1 : BitVec 512) : Option (BitVec 512) :=
  let s := state x0 x1
  match fd_f25519_if.eval 1 (fd_f25519_if.args (.value r) (.value c) (.value a0) (.value a1)) s with
  | .value (some (.cons ret .nil), s') =>
    if
        ret == .value r &&
          s'.mem.readVec r == fd_f25519_if.spec c (s.mem.readVec a0) (s.mem.readVec a1) then
      some (s'.mem.readAt r 512)
    else none
  | _ => none

private def x0 : BitVec 512 :=
  (0x0123456789abcdef#64).replicate 8

private def x1 : BitVec 512 :=
  -1

-- `cond` selects `a0`, else `a1`
#guard out 1 x0 x1 == some x0

#guard out 0 x0 x1 == some x1

-- `cond = 2` is outside the theorem: the `trunc nuw` is poison, `r` does not get `a0`
#guard out 2 x0 x1 == none

end MLIR.Firedancer.R52x5
