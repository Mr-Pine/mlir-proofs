module

public import Ed25519.Firedancer
public import Zig.Math.Verify

/-! Zig's cofactored `verify` accepts what Firedancer's cofactorless one accepts, for canonical
`R`: the library's variants compared. -/

namespace MLIR.Zig

open _root_.Ed25519

/-- Firedancer accepting a signature with canonical `r`, Zig accepts it. -/
public theorem verify_of_firedancer {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hr : r.toNat % 2 ^ 255 < p) (h : Ed25519.Firedancer.verify msg r S A = 0#32) :
    verify msg r S A = 0#32 :=
  (verify_eq_zero_iff msg r S A).2
    (Variant.zig_of_firedancer ((Ed25519.Firedancer.verify_eq_zero_iff msg r S A).1 h) hr)

end MLIR.Zig
