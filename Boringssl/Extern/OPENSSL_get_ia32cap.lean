module

public import MLIR.Run.Tactic

/-!
`OPENSSL_get_ia32cap(idx)` (`crypto/crypto.cc`) is not linked: it reads the CPU capability words
`OPENSSL_ia32cap_P[idx]`, set up once from `cpuid` (inline assembly) and the `OPENSSL_ia32cap`
environment variable. Its declaration is `OPENSSL_ATTR_CONST` (imported as `memory_effects` none):
a pure function of `idx`. It is a `Func` of its signature whose registers, blocks and body are
axioms, and whose `call_eq` is an axiom, the trusted assumption: a call returns `cap idx`, an
arbitrary but fixed function of `idx`, and leaves the state unchanged. A body that branches on
`idx` to each constant `cap idx` is a model, so the axioms are consistent.
-/

namespace MLIR.Boringssl

@[expose] public section

namespace OPENSSL_get_ia32cap

/-- The value registers' types. -/
axiom vals : List Ty

/-- The registers: `(idx)`, then `vals`. -/
noncomputable abbrev Γ : Ctx :=
  ⟨vals.length, [.bv 32], vals, rfl, 0, 0⟩

/-- The block count. -/
axiom n : Nat

axiom hn : 0 < n

axiom blockTys : Fin n → List Ty

axiom hentry : blockTys ⟨0, hn⟩ = []

axiom blockParams : (k : Fin n) → Dsts Γ (blockTys k)

axiom blocks : Fin n → BasicBlock Γ [.bv 32] blockTys

/-- The capability word `idx`, unknown at compile time. -/
axiom cap : BitVec 32 → BitVec 32

end OPENSSL_get_ia32cap

open OPENSSL_get_ia32cap in
@[reducible]
noncomputable def OPENSSL_get_ia32cap : Func :=
  { Γ, tRets := [.bv 32], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

noncomputable def OPENSSL_get_ia32cap.args (idx : ⟦.bv 32⟧) : Vals OPENSSL_get_ia32cap.Γ.args :=
  .cons idx .nil

/-- The trusted assumption: a call returns `cap idx` and leaves the state unchanged. -/
axiom OPENSSL_get_ia32cap.call_eq (idx : BitVec 32) (s : GlobalState) :
    OPENSSL_get_ia32cap.call (OPENSSL_get_ia32cap.args (.value idx)) s =
      .value (.cons (.value (OPENSSL_get_ia32cap.cap idx)) .nil, s)

end

end MLIR.Boringssl
