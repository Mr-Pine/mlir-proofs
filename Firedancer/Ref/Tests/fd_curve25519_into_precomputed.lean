module

public import Firedancer.Ref.fd_curve25519_into_precomputed

meta import Firedancer.Ref.fd_curve25519_into_precomputed

namespace LeanMLIR.RIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- One 160-byte block holding `bytes`. -/
private def state (bytes : BitVec 1280) : GlobalState :=
  ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨160, bytes⟩)]⟩⟩

/-- Limbs `2^52 - 1` in `X`, `1, 2, 3, 4, 5` in `Y`, `2^51 + 7` in `T`, `9` in `Z`'s lowest. -/
private def rBytes : BitVec 1280 :=
  BitVec.ofNat 1280
    ((List.range 5).foldl (fun acc i => acc + (2 ^ 52 - 1) * 2 ^ (64 * i)) 0 +
      (List.range 5).foldl (fun acc i => acc + (i + 1) * 2 ^ (320 + 64 * i)) 0 +
      (List.range 5).foldl (fun acc i => acc + (2 ^ 51 + 7) * 2 ^ (640 + 64 * i)) 0 +
      9 * 2 ^ 960)

/-- The two points' limbs agree. -/
private def PointLimbs.beq (P Q : PointLimbs) : Bool :=
  (List.finRange 5).all fun k =>
    P.X k == Q.X k && P.Y k == Q.Y k && P.T k == Q.T k && P.Z k == Q.Z k

-- `r` holds `spec` of its point; three blocks counted
#guard
  match
    fd_curve25519_into_precomputed.eval 1 (fd_curve25519_into_precomputed.args (.value r))
      (state rBytes) with
  | .value (some .nil, s') =>
    PointLimbs.beq (s'.mem.readPoint r)
        (fd_curve25519_into_precomputed.spec ((state rBytes).mem.readPoint r)) &&
      s'.alloc.nextFreeBlock == 4
  | _ => false

-- `T = 1` becomes `k`'s limbs
#guard
  match
    fd_curve25519_into_precomputed.eval 1 (fd_curve25519_into_precomputed.args (.value r))
      (state (BitVec.ofNat 1280 (2 ^ 640))) with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k => s'.mem.readLimbs (r.add 80#64) k == fd_f25519_k.limbs k
  | _ => false

end LeanMLIR.RIR.Firedancer.Ref
