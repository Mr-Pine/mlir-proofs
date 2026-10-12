module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Sodium.load64_le
public import Sodium.Mlir.fe25519_frombytes

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- The limbs of the 32 bytes `s` (little-endian), its top bit ignored: 51 bits from the words
at bytes 0, 6, 12, 19 and 24, shifted down by 0, 3, 6, 1 and 12. -/
def fe25519_frombytes.spec (s : BitVec 256) : Fin 5 → BitVec 64 :=
  let mask := 0x7ffffffffffff#64
  let h0 := s.setWidth 64 &&& mask
  let h1 := s.extractLsb' 48 64 >>> 3 &&& mask
  let h2 := s.extractLsb' 96 64 >>> 6 &&& mask
  let h3 := s.extractLsb' 152 64 >>> 1 &&& mask
  let h4 := s.extractLsb' 192 64 >>> 12 &&& mask
  fun
  | 0 => h0
  | 1 => h1
  | 2 => h2
  | 3 => h3
  | 4 => h4

end

/-! ## Proof -/

section Proof

/-- `fe25519_frombytes` stores `spec` of the 32 bytes at `s` at `h`. -/
public theorem fe25519_frombytes.call_eq (h s : Pointer) (st : GlobalState) (hwf : st.WF)
    (hh : st.mem.LimbsRoom h) (hs : Fits st.mem s 256) (hso : s.offset.toNat + 32 < 2 ^ 64) :
    fe25519_frombytes.call (fe25519_frombytes.args (.value h) (.value s)) st =
      .value
        (.nil,
          { st with
            mem := st.mem.storeLimbs h (fe25519_frombytes.spec (st.mem.readAt s 256)) }) := by
  have hov (k : BitVec 64) (hk : k.toNat ≤ 32) : ¬s.offset.uaddOverflow k :=
    Agave.not_uaddOverflow_limb hso hk
  have hs0 : Fits st.mem s 64 := hs.mono (by decide)
  have hs6 : Fits st.mem (s.add 6#64) 64 := Fits.add_of_le (hov 6#64 (by decide)) (by decide) hs
  have hs12 : Fits st.mem (s.add 12#64) 64 := Fits.add_of_le (hov 12#64 (by decide)) (by decide) hs
  have hs19 : Fits st.mem (s.add 19#64) 64 := Fits.add_of_le (hov 19#64 (by decide)) (by decide) hs
  have hs24 : Fits st.mem (s.add 24#64) 64 := Fits.add_of_le (hov 24#64 (by decide)) (by decide) hs
  func_init
  have hs₀ : Fits S₀.mem s 256 := hS ▸ hs
  block_init
  iterate 5 step_pure
  -- h0 = (LOAD64_LE(s) ) & mask; … h4 = (LOAD64_LE(s + 24) >> 12) & mask;
  step_call using load64_le.call_eq
  step_pure
  iterate 4
    step_pure
    step_call using load64_le.call_eq
    step_pure
    step_pure
  -- h[0] = h0; … h[4] = h4;
  step_store
  iterate 4
    step_pure
    step_store
  finish_block
  rw [hS,
    MemoryState.readAt_of_readAt_le (m := S₀.mem) (p := s) (v := 256) (w := 64) (by decide) rfl]
  rw [MemoryState.readAt_add_of_readAt (off := 6#64) (w := 64) hs₀.inBounds (hov _ (by decide))
      (by decide) rfl,
    MemoryState.readAt_add_of_readAt (off := 12#64) (w := 64) hs₀.inBounds (hov _ (by decide))
      (by decide) rfl,
    MemoryState.readAt_add_of_readAt (off := 19#64) (w := 64) hs₀.inBounds (hov _ (by decide))
      (by decide) rfl,
    MemoryState.readAt_add_of_readAt (off := 24#64) (w := 64) hs₀.inBounds (hov _ (by decide))
      (by decide) rfl]
  rfl

end Proof

end MLIR.Sodium
