module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_core_ref

/-!
`fd_sha512_core_avx2` is assembly (`fd_sha512_core_avx2.S`) and has no IR to lift. It is a `Func`
of its signature whose registers, blocks and body are axioms, and whose `call_eq` is an axiom: the
C core's (`Ref.fd_sha512_core_ref.call_eq`). A body that calls the C core is a model, so the axioms
are consistent.
-/

namespace MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_sha512_core_avx2

/-- The value registers' types. -/
axiom vals : List Ty

/-- The registers: `(state, block, block_cnt)`, then `vals`. -/
noncomputable abbrev Γ : Ctx :=
  ⟨vals.length, [.ptr, .ptr, .bv 64], vals, rfl, 0, 0⟩

/-- The block count. -/
axiom n : Nat

axiom hn : 0 < n

axiom blockTys : Fin n → List Ty

axiom hentry : blockTys ⟨0, hn⟩ = []

axiom blockParams : (k : Fin n) → Dsts Γ (blockTys k)

axiom blocks : Fin n → BasicBlock Γ [] blockTys

end fd_sha512_core_avx2

open fd_sha512_core_avx2 in
noncomputable def fd_sha512_core_avx2 : Func :=
  { Γ, tRets := [], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

noncomputable def fd_sha512_core_avx2.args (st data : ⟦.ptr⟧) (n : ⟦.bv 64⟧) :
    Vals fd_sha512_core_avx2.Γ.args :=
  .cons st (.cons data (.cons n .nil))

/-- The C core's `call_eq`. -/
axiom fd_sha512_core_avx2.call_eq (st data : Pointer) (n : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hst : s.mem.Words8Fit st) (hn : n ≠ 0) (hdata : Fits s.mem data (1024 * n.toNat))
    (hdo : data.offset.toNat + 128 * n.toNat < 2 ^ 64)
    (hsep : (Range.of st 512).Disjoint (Range.of data (1024 * n.toNat))) :
    fd_sha512_core_avx2.call (fd_sha512_core_avx2.args (.value st) (.value data) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem :=
              s.mem.storeWords8 st
                (Ref.fd_sha512_core_ref.spec (s.mem.readWords8 st)
                  (s.mem.readAt data (1024 * n.toNat))) })

end

end MLIR.Firedancer.R52x5
