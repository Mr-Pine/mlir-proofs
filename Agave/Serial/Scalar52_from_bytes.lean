module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Bytes
public import Agave.Serial.Mlir.Scalar52_from_bytes
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `Scalar52::from_bytes(bytes)`: the four little-endian words `words[i]` split into 52-bit limbs,
the top one of 48 bits. -/
def Scalar52_from_bytes.spec (bytes : BitVec 256) : Fin 5 → BitVec 64 :=
  let words (i : Nat) := bytes.extractLsb' (64 * i) 64
  let mask := 0xfffffffffffff#64
  let top_mask := 0xffffffffffff#64
  fun
  | ⟨0, _⟩ => words 0 &&& mask
  | ⟨1, _⟩ => (words 0 >>> 52 ||| words 1 <<< 12) &&& mask
  | ⟨2, _⟩ => (words 1 >>> 40 ||| words 2 <<< 24) &&& mask
  | ⟨3, _⟩ => (words 2 >>> 28 ||| words 3 <<< 36) &&& mask
  | ⟨4, _⟩ => words 3 >>> 16 &&& top_mask

end

/-! ## Proof -/

section Proof

/-- A step of a word built from bytes: its `shl nuw nsw` and `or disjoint` flags hold. -/
local macro "wstep" : tactic =>
  `(tactic|
    step_pure [Agave.zext_shl_ushiftRight, Agave.zext_shl_sshiftRight, BitVec.and_or_distrib_left,
      BitVec.and_or_distrib_right, Agave.zext_shl_and_zext_shl, Agave.zext_shl_and_zext,
      Agave.zext_and_zext_shl, BitVec.extractLsb'_or, Agave.zext_shl_extractLsb'_low])

/-- Two stores at one pointer, of equal memories and values, are equal. -/
theorem storeAt_congr {m m' : MemoryState} {p : Pointer} {v v' : BitVec w} (hm : m = m')
    (hv : v = v') : m.storeAt p v = m'.storeAt p v' := by rw [hm, hv]

set_option hygiene false in
/-- `ld k w`: the load of `w` bits at byte `k` of `bytes`, from `buf`. -/
local macro "ld " k:num w:num : tactic =>
  `(tactic|
    ( have hb :=
        Agave.readAt_bytes (n := 32) hbytes.inBounds hbytes_off (by decide) hbuf' $k $w (by decide)
      step_load consuming hb))

/-- `Scalar52::from_bytes(bytes)` for the 32 bytes at `bytes` stores `spec` at `out`; `words`' four
slots are zeroed and freed, only the counter moves on. The loads all come before the stores, so
`out` may alias `bytes`. -/
public theorem Scalar52_from_bytes.call_eq (out bytes : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hbytes : Fits s.mem bytes 256)
    (hbytes_off : ¬bytes.offset.uaddOverflow 32#64) :
    Scalar52_from_bytes.call (Scalar52_from_bytes.args (.value out) (.value bytes)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩
            mem := s.mem.storeLimbs out (Scalar52_from_bytes.spec (s.mem.readAt bytes 256)) }) := by
  func_init
  have hrd : S.mem.readAt bytes 256 = S₀.mem.readAt bytes 256 := by rw [hS]
  block_init
  iterate 11 step_pure
  step_alloca with w0
  step_alloca with w1
  step_alloca with w2
  step_alloca with w3
  iterate 4 step_pure
  obtain ⟨buf, hbuf⟩ : ∃ b, S₀.mem.readAt bytes 256 = b := ⟨_, rfl⟩
  rw [hbuf]
  have hbuf' := hrd.trans hbuf
  clear hrd
  -- `words[0]`
  have hb := Agave.readAt_bytes0 hbuf' 64 (by decide)
  step_load consuming hb
  -- `words[1]`
  step_pure
  ld 8 32
  iterate 2 step_pure
  ld 12 8
  iterate 4 wstep
  ld 13 8
  iterate 3 wstep
  ld 14 16
  iterate 4 wstep
  step_store
  -- `words[2]`
  step_pure
  ld 16 16
  iterate 2 step_pure
  ld 18 8
  iterate 4 wstep
  ld 19 8
  iterate 4 wstep
  ld 20 16
  iterate 3 wstep
  ld 22 16
  iterate 4 wstep
  step_store
  -- `words[3]`
  step_pure
  ld 24 8
  iterate 2 step_pure
  ld 25 8
  iterate 4 wstep
  ld 26 16
  iterate 3 wstep
  ld 28 16
  iterate 4 wstep
  ld 30 16
  iterate 4 wstep
  step_store
  -- `words.zeroize()`
  iterate 4 step_store
  -- `s[0] … s[4]`
  iterate 6 wstep
  step_store
  iterate 4 (step_pure; step_store)
  iterate 4 step_pure
  finish_block
  subst hS
  erase_frame
  simp only [GlobalState.alloca_alloc, MemoryState.storeLimbs, Nat.add_assoc, Nat.reduceAdd]
  clear_reads
  congr 3
  refine
    storeAt_congr (storeAt_congr (storeAt_congr (storeAt_congr (storeAt_congr rfl ?_) ?_) ?_) ?_) ?_
  all_goals clear * -
  all_goals simp only [Scalar52_from_bytes.spec]
  all_goals bv_decide

end Proof

end MLIR.Agave.Serial
