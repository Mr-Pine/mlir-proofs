module

public import Sodium._crypto_sign_ed25519_verify_detached
public import Sodium.crypto_verify_32

meta import Sodium.crypto_verify_32

namespace MLIR.Sodium

-- the proved statement is the one `_crypto_sign_ed25519_verify_detached` assumes
example : crypto_verify_32.Spec :=
  crypto_verify_32.call_eq

/-- `a` in block 1 and `b` in block 2, 32 bytes each; the result, or `none` for UB. -/
private def run (a b : BitVec 256) (same : Bool := false) : Option (BitVec 32) :=
  let s : GlobalState := ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 32 a), (⟨2⟩, .ofBytes 32 b)]⟩⟩
  match
    crypto_verify_32.call
      (crypto_verify_32.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨if same then 1 else 2⟩, 0⟩)) s with
  | .value (.cons (.value r) .nil, _) => some r
  | _ => none

private def a : BitVec 256 :=
  (0x0123456789abcdef#64).replicate 4

/-- `a` with byte `k` changed. -/
private def b (k : Nat) : BitVec 256 :=
  a ^^^ (0x5a#256 <<< (8 * k))

-- equal bytes, the same block or not
#guard run a a == some 0 && run a a true == some 0 && run 0 0 == some 0

-- a difference in any byte, in either half
#guard (List.range 32).all fun k => run a (b k) == some (-1)

#guard run 0 (-1) == some (-1) && run (1 <<< 255) 0 == some (-1)

end MLIR.Sodium
