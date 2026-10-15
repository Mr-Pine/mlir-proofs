module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Ref.Mlir.crc_adx_comb_table_build

/-!
`crc_adx_comb_table_init()` builds the comb table once (`FD_ONCE`): a `cmpxchg` on its state
from `0` to `-1`, `crc_adx_comb_table_build()`, then `1`; a caller finding `-1` spins (`fd_yield`)
until it is `1`. A `Func` of its signature whose registers, blocks and body are axioms; its
`call_eq`, an axiom, is the one-thread behavior: from state `1` nothing, from `0` the build, then
`1`. The build is lifted.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

namespace crc_adx_comb_table_init

/-- The value registers' types. -/
axiom vals : List Ty

/-- The registers: the arguments, then `vals`. -/
noncomputable abbrev Γ : Ctx :=
  ⟨vals.length, [], vals, rfl, 0, 0⟩

/-- The block count. -/
axiom n : Nat

axiom hn : 0 < n

axiom blockTys : Fin n → List Ty

axiom hentry : blockTys ⟨0, hn⟩ = []

axiom blockParams : (k : Fin n) → Dsts Γ (blockTys k)

axiom blocks : Fin n → BasicBlock Γ [] blockTys

end crc_adx_comb_table_init

open crc_adx_comb_table_init in
@[reducible] noncomputable def crc_adx_comb_table_init : Func :=
  { Γ, tRets := [], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

/-- The `FD_ONCE` state: `0` before the build, `1` after. -/
def crc_adx_comb_table_init.state (s : GlobalState) : Pointer :=
  ⟨s.mem.globalBlock "crc_adx_comb_table_init._fd_once_block_state", 0#64⟩

/-- From state `1` nothing; from `0` the build, then state `1`. -/
axiom crc_adx_comb_table_init.call_eq (s : GlobalState) (hwf : s.WF)
    (hg : (s.mem.globals "crc_adx_comb_table_init._fd_once_block_state").isSome)
    (hst : s.mem.readAt (crc_adx_comb_table_init.state s) 32 = 0#32 ∨
      s.mem.readAt (crc_adx_comb_table_init.state s) 32 = 1#32) :
    crc_adx_comb_table_init.call .nil s =
      if s.mem.readAt (crc_adx_comb_table_init.state s) 32 = 1#32 then .value (.nil, s)
      else do
        let (_, s') ← crc_adx_comb_table_build.call .nil s
        return (.nil, { s' with mem := s'.mem.storeAt (crc_adx_comb_table_init.state s) 1#32 })

end

end MLIR.Firedancer.Crc.Ref
