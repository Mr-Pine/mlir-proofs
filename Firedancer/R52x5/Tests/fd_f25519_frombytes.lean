module

public import Firedancer.R52x5.fd_f25519_frombytes

meta import Firedancer.R52x5.fd_f25519_frombytes

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl)

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- The element `Σ lane_i * 2^(51 i)` over lanes `0 … 4`, mod `p`. -/
private def value (x : Wwl) : Nat :=
  (List.range 5).foldl (fun acc i => acc + x[i]!.toNat * 2 ^ (51 * i)) 0 % (2 ^ 255 - 19)

/-- A 64-byte block for `r`, and the 32 bytes `bytes` at byte 8 of a 40-byte block. -/
private def state (bytes : BitVec 256) : GlobalState :=
  ⟨⟨2⟩,
    ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 64 0), (⟨1⟩, .ofBytes 40 (bytes.setWidth 320 <<< 64))]⟩⟩

/-- `r` is returned and holds `spec bytes`: Ref's limbs, `bytes` mod `2^255` mod `p`, lanes 5-7
zero. -/
private def check (bytes : BitVec 256) : Bool :=
  let buf : Pointer := ⟨⟨1⟩, 8⟩
  match
    fd_f25519_frombytes.eval 1 (fd_f25519_frombytes.args (.value r) (.value buf)) (state bytes) with
  | .value (some (.cons ret .nil), s') =>
    let z := s'.mem.readVec r
    ret == .value r && z == fd_f25519_frombytes.spec bytes &&
      (List.range 5).all (fun i => z[i]! == Ref.fd_f25519_frombytes.spec bytes (Fin.ofNat 5 i)) &&
      value z == bytes.toNat % 2 ^ 255 % (2 ^ 255 - 19) &&
      z[5] == 0 &&
      z[6] == 0 &&
      z[7] == 0
  | _ => false

#guard check 0

#guard check 1

#guard check (-1)

#guard check 0x0123456789abcdeffedcba98765432100f1e2d3c4b5a69788796a5b4c3d2e1f0#256

-- past the block's end: UB
#guard
  match
    fd_f25519_frombytes.eval 1 (fd_f25519_frombytes.args (.value r) (.value ⟨⟨1⟩, 9⟩))
      (state 0) with
  | .value _ => false
  | _ => true

end MLIR.Firedancer.R52x5
