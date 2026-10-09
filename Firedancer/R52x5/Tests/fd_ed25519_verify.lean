module

public import Firedancer.R52x5.fd_ed25519_verify

/-! The lift reads the base-point table and cannot be evaluated, and `spec` is noncomputable
through the point decoding. The hashing is the ref's, tested there; this checks the scalar check's
early exit by proof. -/

namespace MLIR.Firedancer.R52x5

/-- No table: the test below never reaches the scalar multiplication. -/
private def noTbl : Nat → Quad5 := fun _ => quadZero

-- `S ≥ ℓ`: FD_ED25519_ERR_SIG before anything else, the hash object untouched
example :
    let res :=
      fd_ed25519_verify.spec noTbl 0#64 0#0 0#256
        (BitVec.ofNat 256
          7237005577332262213973186563042994240857116359379907606001950938285454250989)
        0#256 0#1024
    res.ret = -1#32 ∧ res.sha = none ∧ res.blocks = 4 := by
  have h :
    Ref.fd_curve25519_scalar_validate.spec
        (BitVec.ofNat 256
          7237005577332262213973186563042994240857116359379907606001950938285454250989) =
      false := by
    decide
  simp [fd_ed25519_verify.spec, h]

end MLIR.Firedancer.R52x5
