module

public import Firedancer.Avx512.fd_r43x6_quad_mul_fast
public import Firedancer.Avx512.fd_r43x6_mul_fast

meta import Firedancer.Avx512.fd_r43x6_quad_mul_fast
meta import Firedancer.Avx512.fd_r43x6_mul_fast

namespace MLIR.Firedancer.Avx512

private def z03 : Pointer :=
  ⟨⟨0⟩, 0⟩

private def z14 : Pointer :=
  ⟨⟨1⟩, 0⟩

private def z25 : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three zeroed 64-byte blocks. -/
private def state : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨64, 0⟩), (⟨1⟩, ⟨64, 0⟩), (⟨2⟩, ⟨64, 0⟩)]⟩⟩

/-- Four elements in the QUAD layout: limbs `k` and `k + 3` of each in `qk`. -/
private def quad (x y z t : Wwl) (k : Nat) : Wwl :=
  #v[x[k]!, y[k]!, z[k]!, t[k]!, x[k + 3]!, y[k + 3]!, z[k + 3]!, t[k + 3]!]

/-- Element `e` of a QUAD `q03 q14 q25`. -/
private def unquad (q03 q14 q25 : Wwl) (e : Nat) : Wwl :=
  #v[q03[e]!, q14[e]!, q25[e]!, q03[e + 4]!, q14[e + 4]!, q25[e + 4]!, 0, 0]

/-- The stores are `spec`'s, and each element is `fd_r43x6_mul_fast`'s product. -/
private def check (xs ys : List Wwl) : Bool :=
  let qx := fun k => quad xs[0]! xs[1]! xs[2]! xs[3]! k
  let qy := fun k => quad ys[0]! ys[1]! ys[2]! ys[3]! k
  match
    fd_r43x6_quad_mul_fast.eval 1
      (fd_r43x6_quad_mul_fast.args (.value z03) (.value z14) (.value z25) (Ty.wrap (qx 0))
        (Ty.wrap (qx 1)) (Ty.wrap (qx 2)) (Ty.wrap (qy 0)) (Ty.wrap (qy 1)) (Ty.wrap (qy 2)))
      state with
  | .value (some .nil, s') =>
    let r := (s'.mem.readVec z03, s'.mem.readVec z14, s'.mem.readVec z25)
    r == fd_r43x6_quad_mul_fast.spec (qx 0) (qx 1) (qx 2) (qy 0) (qy 1) (qy 2) &&
      (List.range 4).all fun e =>
        unquad r.1 r.2.1 r.2.2 e == fd_r43x6_mul_fast.spec xs[e]! ys[e]!
  | _ => false

#guard
  check [#v[1, 2, 3, 4, 5, 6, 0, 0], #v[7, 8, 9, 10, 11, 12, 0, 0], #v[0, 0, 0, 0, 0, 1, 0, 0],
      #v[2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 0, 0]]
    [#v[13, 14, 15, 16, 17, 18, 0, 0], #v[1, 0, 0, 0, 0, 0, 0, 0],
      #v[2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 0, 0],
      #v[0x123456789AB, 0x7FEDCBA9876, 0x1F2E3D4C5B6, 0x0A1B2C3D4E5, 0x66554433221, 0x77777777777,
        0, 0]]

end MLIR.Firedancer.Avx512
