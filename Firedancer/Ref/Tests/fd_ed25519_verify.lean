module

public import Firedancer.Ref.fd_ed25519_verify

meta import Firedancer.Ref.fd_ed25519_verify

/-! The lift reads the 20 KB base-point table and cannot be evaluated; these test the spec's parts
that evaluate quickly. The point decoding's `pow22523` chain is too slow to run here. -/

namespace MLIR.Firedancer.Ref

/-- No table: the tests below never reach the scalar multiplication. -/
private def noTbl : Nat → PointLimbs := fun _ => ⟨0, 0, 0, 0⟩

-- `S ≥ ℓ`: FD_ED25519_ERR_SIG before anything else, the hash object untouched
#guard
  let res :=
    fd_ed25519_verify.spec noTbl 0#64 0#0 0#256
      (BitVec.ofNat 256
        7237005577332262213973186563042994240857116359379907606001950938285454250989)
      0#256 0#1024
  res.ret == -1#32 && res.sha.isNone && res.blocks == 3

-- SHA-512 of 64 zero bytes, as the digest's words lay it out in memory
#guard
  Words8.bits (fd_ed25519_verify.hash 0#1024 0#256 0#256 0#64 0#0).2 ==
    BitVec.ofNat 512
      6756433270247411179955344271290860428196519276306619770861134681094926084110998387270479862864333985199987953846750880615535480720605515890594991962974587

-- SHA-512 of the bytes 0 … 63 and "abc"
#guard
  Words8.bits
      (fd_ed25519_verify.hash 0#1024
          (BitVec.ofNat 256
            14074904626401341155369551180448584754667373453244490859944217516317499064576)
          (BitVec.ofNat 256
            28605676609123373522249047338401577112724783293638600857052620215349734940960)
          3#64 (BitVec.ofNat 24 6513249)).2 ==
    BitVec.ofNat 512
      2113626006853070987569356334403230428970188404400764128064959858859507509059298575746253257956050671484778280016492655593550391659505145575534877717010997

end MLIR.Firedancer.Ref
