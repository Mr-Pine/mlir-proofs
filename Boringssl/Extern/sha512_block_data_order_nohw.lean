module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_core_ref

/-!
`sha512_block_data_order_nohw`, the path without AVX of `sha512_block_data_order`, is assembly
(`gen/bcm/sha512-x86_64-linux.S`) and has no IR to lift. It is a `Func` of its signature whose
registers, blocks and body are axioms, and whose `call_eq` is an axiom (trusted): Firedancer's C
core's (`Firedancer.Ref.fd_sha512_core_ref.call_eq`), whose spec is FIPS 180-4 compression,
`Ed25519.Sha512.compressBlocks` (`Firedancer.Ref.spec_eq`). That core is a model, so the axioms
are consistent.
-/

namespace MLIR.Boringssl

@[expose] public section

namespace sha512_block_data_order_nohw

/-- The value registers' types. -/
axiom vals : List Ty

/-- The registers: `(state, in, num_blocks)`, then `vals`. -/
noncomputable abbrev Γ : Ctx :=
  ⟨vals.length, [.ptr, .ptr, .bv 64], vals, rfl, 0, 0⟩

/-- The block count. -/
axiom n : Nat

axiom hn : 0 < n

axiom blockTys : Fin n → List Ty

axiom hentry : blockTys ⟨0, hn⟩ = []

axiom blockParams : (k : Fin n) → Dsts Γ (blockTys k)

axiom blocks : Fin n → BasicBlock Γ [] blockTys

end sha512_block_data_order_nohw

open sha512_block_data_order_nohw in
@[reducible]
noncomputable def sha512_block_data_order_nohw : Func :=
  { Γ, tRets := [], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

noncomputable def sha512_block_data_order_nohw.args (st data : ⟦.ptr⟧) (n : ⟦.bv 64⟧) :
    Vals sha512_block_data_order_nohw.Γ.args :=
  .cons st (.cons data (.cons n .nil))

/-- Firedancer's C core's `call_eq`: the `n` 128-byte blocks at `data` compressed into the
eight words at `st`. -/
axiom sha512_block_data_order_nohw.call_eq (st data : Pointer) (n : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hst : s.mem.Words8Fit st) (hn : n ≠ 0) (hdata : Fits s.mem data (1024 * n.toNat))
    (hdo : data.offset.toNat + 128 * n.toNat < 2 ^ 64)
    (hsep : (Range.of st 512).Disjoint (Range.of data (1024 * n.toNat))) :
    sha512_block_data_order_nohw.call
        (sha512_block_data_order_nohw.args (.value st) (.value data) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem :=
              s.mem.storeWords8 st
                (Firedancer.Ref.fd_sha512_core_ref.spec (s.mem.readWords8 st)
                  (s.mem.readAt data (1024 * n.toNat))) })

end

end MLIR.Boringssl
