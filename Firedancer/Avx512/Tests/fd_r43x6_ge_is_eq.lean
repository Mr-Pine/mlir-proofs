module

public import Firedancer.Avx512.fd_r43x6_ge_is_eq

meta import Firedancer.Avx512.fd_r43x6_ge_is_eq

namespace LeanMLIR.RIR.Firedancer.Avx512

/-- Eight 43-bit lanes from `seed`. -/
private def lanes (seed : Nat) : Wwl :=
  Vector.ofFn fun i => BitVec.ofNat 64 (seed + 99999999989 * i.val)

/-- The return value on the points with vectors from `x` and `y`, or `none` for UB / out of fuel. -/
private def run (x y : Nat × Nat × Nat) : Option (BitVec 32) :=
  match fd_r43x6_ge_is_eq.eval 5
      (fd_r43x6_ge_is_eq.args (Ty.wrap (lanes x.1)) (Ty.wrap (lanes x.2.1)) (Ty.wrap (lanes x.2.2))
        (Ty.wrap (lanes y.1)) (Ty.wrap (lanes y.2.1)) (Ty.wrap (lanes y.2.2))) ⟨⟨0⟩, ⟨∅⟩⟩ with
  | .value (some (.cons (.value r) .nil), _) => some r
  | _ => none

private def specOf (x y : Nat × Nat × Nat) : BitVec 32 :=
  fd_r43x6_ge_is_eq.spec ⟨lanes x.1, lanes x.2.1, lanes x.2.2⟩ ⟨lanes y.1, lanes y.2.1, lanes y.2.2⟩

private def P : Nat × Nat × Nat :=
  (4000000000000, 1234567890123, 3000000000007)

private def Q : Nat × Nat × Nat :=
  (2000000000000, 5555555555555, 1000000000001)

#guard run P P == some 1 && specOf P P == 1

#guard run P Q == some 0 && specOf P Q == 0

end LeanMLIR.RIR.Firedancer.Avx512
