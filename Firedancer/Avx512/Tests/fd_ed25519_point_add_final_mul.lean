module

public import Firedancer.Avx512.fd_ed25519_point_add_final_mul

meta import Firedancer.Avx512.fd_ed25519_point_add_final_mul

namespace MLIR.Firedancer.Avx512

private def r : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Two 192-byte blocks: `r` zeroed, `a` holding `bytes`. -/
private def state (bytes : BitVec 1536) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨192, 0⟩), (⟨2⟩, ⟨192, bytes⟩)]⟩⟩

private def aBytes : BitVec 1536 :=
  BitVec.ofNat 1536 (2 ^ 1500 + 3 * 2 ^ 1000 + 5 * 2 ^ 600 + 12345678901234567890)

-- `r` is returned and holds all of `a`'s 192 bytes
#guard
  match
    fd_ed25519_point_add_final_mul.eval 1
      (fd_ed25519_point_add_final_mul.args (.value r) (.value a)) (state aBytes) with
  | .value (some (.cons ret .nil), s') => ret == .value r && s'.mem.readAt r 1536 == aBytes
  | _ => false

end MLIR.Firedancer.Avx512
