module

public import Firedancer.Ref.fd_ed25519_point_neg

meta import Firedancer.Ref.fd_ed25519_point_neg

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 160-byte blocks: `r` zeroed, `a` holding `bytes`. -/
private def state (bytes : BitVec 1280) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨160, 0⟩), (⟨1⟩, ⟨160, bytes⟩)]⟩⟩

private def aBytes : BitVec 1280 :=
  BitVec.ofNat 1280 (2 ^ 1100 + 3 * 2 ^ 700 + 5 * 2 ^ 400 + 7)

-- X and T are `opp` of `a`'s, Y and Z are `a`'s
#guard
  match
    fd_ed25519_point_neg.eval 1 (fd_ed25519_point_neg.args (.value r) (.value a))
      (state aBytes) with
  | .value (some (.cons ret .nil), s') =>
    let m := (state aBytes).mem
    ret == .value r &&
      (List.finRange 5).all
        (fun k =>
          s'.mem.readLimbs r k == fiat_25519_opp.spec (m.readLimbs a) k &&
            s'.mem.readLimbs (r.add 80#64) k ==
              fiat_25519_opp.spec (m.readLimbs (a.add 80#64)) k) &&
      s'.mem.readAt (r.add 40#64) 320 == m.readAt (a.add 40#64) 320 &&
      s'.mem.readAt (r.add 120#64) 320 == m.readAt (a.add 120#64) 320
  | _ => false

end MLIR.Firedancer.Ref
