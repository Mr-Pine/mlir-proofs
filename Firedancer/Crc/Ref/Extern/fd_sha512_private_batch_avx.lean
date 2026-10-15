module

public import MLIR.Run.Tactic

/-!
`fd_sha512_private_batch_avx( cnt, data, sz, hash )` (`fd_sha512_batch_avx.c`, AVX2 intrinsics,
not lifted) hashes `cnt` messages at once. A `Func` of its signature whose registers, blocks and
body are axioms, with no `call_eq` yet: its callers, `fd_sha512_batch_add` and `_fini`, serve only
`fd_ed25519_sign_batch8`.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

namespace fd_sha512_private_batch_avx

/-- The value registers' types. -/
axiom vals : List Ty

/-- The registers: the arguments, then `vals`. -/
noncomputable abbrev Γ : Ctx :=
  ⟨vals.length, [.bv 64, .ptr, .ptr, .ptr], vals, rfl, 0, 0⟩

/-- The block count. -/
axiom n : Nat

axiom hn : 0 < n

axiom blockTys : Fin n → List Ty

axiom hentry : blockTys ⟨0, hn⟩ = []

axiom blockParams : (k : Fin n) → Dsts Γ (blockTys k)

axiom blocks : Fin n → BasicBlock Γ [] blockTys

end fd_sha512_private_batch_avx

open fd_sha512_private_batch_avx in
@[reducible] noncomputable def fd_sha512_private_batch_avx : Func :=
  { Γ, tRets := [], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

noncomputable def fd_sha512_private_batch_avx.args (cnt : ⟦.bv 64⟧) (data sz hash : ⟦.ptr⟧) :
    Vals fd_sha512_private_batch_avx.Γ.args :=
  .cons cnt (.cons data (.cons sz (.cons hash .nil)))

end

end MLIR.Firedancer.Crc.Ref
