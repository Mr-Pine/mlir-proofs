module

public import Firedancer.R52x5.wl_permute

meta import Firedancer.R52x5.wl_permute

namespace MLIR.Firedancer.R52x5

private def x : Wl :=
  #v[10, 11, 12, 0x8000000000000000]

/-- `wl_permute( x, i0, i1, i2, i3 )` against `wlPermute`. -/
private def check (i0 i1 i2 i3 : Nat) : Bool :=
  match
    wl_permute.eval 1
      (wl_permute.args (Ty.wrap x) (.value (BitVec.ofNat 32 i0)) (.value (BitVec.ofNat 32 i1))
        (.value (BitVec.ofNat 32 i2)) (.value (BitVec.ofNat 32 i3)))
      ⟨default, default⟩ with
  | .value (some (.cons v .nil), _) => v == Ty.wrap (wlPermute x i0 i1 i2 i3)
  | _ => false

#guard check 1 0 3 2 && check 0 0 0 0 && check 3 3 3 3 && check 2 1 2 1 && check 3 0 0 3

-- an index of 4 reads past the union: UB
#guard
  match
    wl_permute.eval 1
      (wl_permute.args (Ty.wrap x) (.value 4#32) (.value 0#32) (.value 0#32) (.value 0#32))
      ⟨default, default⟩ with
  | .value _ => false
  | _ => true

end MLIR.Firedancer.R52x5
