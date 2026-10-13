module

public import MLIR.Run.Tactic
public import Sodium.crypto_hash_sha512_init
public import Sodium.Mlir._crypto_sign_ed25519_ref10_hinit

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `WF` past a framed callee's struct store: the counter advanced, the struct stored. -/
public theorem _root_.MLIR.GlobalState.WF.storeHashState_mk {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeHashState c v⟩ : GlobalState).WF :=
  GlobalState.WF.storeHashState (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩) h.add_blocks

attribute [local mlir_transport] GlobalState.WF.storeHashState_mk

public theorem _crypto_sign_ed25519_ref10_hinit_DOM2PREFIX.value_eq (s : GlobalState) :
    _crypto_sign_ed25519_ref10_hinit_DOM2PREFIX.value s =
      .value (Ty.wrap _crypto_sign_ed25519_ref10_hinit_DOM2PREFIX.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `_crypto_sign_ed25519_ref10_hinit(hs, 0)` sets up the struct at `hs` as
`crypto_hash_sha512_init` does. -/
public theorem _crypto_sign_ed25519_ref10_hinit.call_eq (hs : Pointer) (s : GlobalState)
    (hwf : s.WF) (hg : s.mem.Globals _crypto_sign_ed25519_ref10_hinit.globals)
    (hroom : Room s.mem hs 1664) (hso : ¬hs.offset.uaddOverflow 208#64) :
    _crypto_sign_ed25519_ref10_hinit.call
        (_crypto_sign_ed25519_ref10_hinit.args (.value hs) (.value 0#32)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeHashState hs
                (crypto_hash_sha512_init.spec (s.mem.readHashState hs)) }) := by
  func_init
  block_init
  step_pure
  step_addressof _crypto_sign_ed25519_ref10_hinit_DOM2PREFIX.value_eq with dom
  step_pure
  -- crypto_hash_sha512_init(hs);
  step_call using crypto_hash_sha512_init.call_eq
  step_pure
  -- if (prehashed) …
  finish_block
  block_init
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Sodium
