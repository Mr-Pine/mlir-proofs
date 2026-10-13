module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Bytes
public import Agave.Common.Copy
public import Agave.Common.Scalar
public import Agave.Serial.Scalar52_constants
public import Agave.Serial.Scalar52_montgomery_mul
public import Agave.Serial.Scalar52_add
public import Agave.Serial.Mlir.Scalar52_from_bytes_wide
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `from_bytes_wide`'s `lo`: the low 260 bits of the eight little-endian words `words[i]`, in
52-bit limbs. -/
def Scalar52_from_bytes_wide.lo (bytes : BitVec 512) : Fin 5 → BitVec 64 :=
  let words (i : Nat) := bytes.extractLsb' (64 * i) 64
  let mask := 0xfffffffffffff#64
  fun
  | ⟨0, _⟩ => words 0 &&& mask
  | ⟨1, _⟩ => (words 0 >>> 52 ||| words 1 <<< 12) &&& mask
  | ⟨2, _⟩ => (words 1 >>> 40 ||| words 2 <<< 24) &&& mask
  | ⟨3, _⟩ => (words 2 >>> 28 ||| words 3 <<< 36) &&& mask
  | ⟨4, _⟩ => (words 3 >>> 16 ||| words 4 <<< 48) &&& mask

/-- `from_bytes_wide`'s `hi`: the high 252 bits, in 52-bit limbs. -/
def Scalar52_from_bytes_wide.hi (bytes : BitVec 512) : Fin 5 → BitVec 64 :=
  let words (i : Nat) := bytes.extractLsb' (64 * i) 64
  let mask := 0xfffffffffffff#64
  fun
  | ⟨0, _⟩ => words 4 >>> 4 &&& mask
  | ⟨1, _⟩ => (words 4 >>> 56 ||| words 5 <<< 8) &&& mask
  | ⟨2, _⟩ => (words 5 >>> 44 ||| words 6 <<< 20) &&& mask
  | ⟨3, _⟩ => (words 6 >>> 32 ||| words 7 <<< 32) &&& mask
  | ⟨4, _⟩ => words 7 >>> 20

/-- `Scalar52::from_bytes_wide(bytes)`: `montgomery_mul(hi, RR) + montgomery_mul(lo, R)` mod `ℓ`.
-/
def Scalar52_from_bytes_wide.spec (bytes : BitVec 512) : Fin 5 → BitVec 64 :=
  let lo := Scalar52_montgomery_mul.spec (Scalar52_from_bytes_wide.lo bytes) Scalar52.R
  let hi := Scalar52_montgomery_mul.spec (Scalar52_from_bytes_wide.hi bytes) Scalar52.RR
  Scalar52_add.spec hi lo

end

/-! ## Proof -/

section Proof

/-- A step of a word built from bytes: its `shl nuw nsw` and `or disjoint` flags hold. -/
local macro "wstep" : tactic =>
  `(tactic|
    step_pure [Agave.zext_shl_ushiftRight, Agave.zext_shl_sshiftRight, BitVec.and_or_distrib_left,
      BitVec.and_or_distrib_right, Agave.zext_shl_and_zext_shl, Agave.zext_shl_and_zext,
      Agave.zext_and_zext_shl])

set_option hygiene false in
/-- `ld k w`: the load of `w` bits at byte `k` of `bytes`, from `buf`. -/
local macro "ld " k:num w:num : tactic =>
  `(tactic|
    ( have hb :=
        Agave.readAt_bytes (n := 64) hbytes.inBounds hbytes_off (by decide) hbuf' $k $w (by decide)
      step_load consuming hb))

/-- `(bytes[k] as u64) << 8 j`, or'ed in: the address, the byte, its extension and shift, the `or`.
-/
local macro "byte " k:num : tactic => `(tactic| (wstep; ld $k 8; wstep; wstep; wstep))

set_option hygiene false in
/-- `copied p`: the limbs a copy stored at `p` (`hfits_p`, `hread_p`) as `hp_limbs` and
`hread_p_readLimbs`. -/
local macro "copied " p:ident : tactic => do
  let n := p.getId.toString
  let fits := Lean.mkIdent (.mkSimple s!"hfits_{n}")
  let read := Lean.mkIdent (.mkSimple s!"hread_{n}")
  let readL := Lean.mkIdent (.mkSimple s!"hread_{n}_readLimbs")
  let off := Lean.mkIdent (.mkSimple s!"h{n}_off")
  let limbs := Lean.mkIdent (.mkSimple s!"h{n}_limbs")
  `(tactic|
      ( have $limbs:ident := Agave.limbsFit_of_fits $fits (by simp [$off:ident])
        have $readL:ident :=
          Agave.readLimbs_of_readAt_limbsBits (Fits.inBounds $fits) (by simp [$off:ident]) $read
        clear $fits $read))

-- a long chain of calls: the state cut from the entry state every so often (`rir.stateDepth`)
set_option rir.stateDepth 64 in
-- about 330 steps in one block, each carrying the 14 slots' and two globals' facts: past the
-- default heartbeats
set_option maxHeartbeats 2000000 in
/-- `Scalar52::from_bytes_wide(bytes)` for the 64 bytes at `bytes` stores `spec` at `out`: `lo` and
`hi`'s Montgomery products by `R` and `RR`, added. The temporaries' and the callees' blocks are
freed again: only the counter moves on. The loads all come before the store to `out`,
so `out` may alias `bytes`. -/
public theorem Scalar52_from_bytes_wide.call_eq (out bytes : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Scalar52_from_bytes_wide.globals) (hout : s.mem.LimbsRoom out)
    (hbytes : Fits s.mem bytes 512)
    (hbytes_off : ¬bytes.offset.uaddOverflow 64#64) :
    Scalar52_from_bytes_wide.call (Scalar52_from_bytes_wide.args (.value out) (.value bytes)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 38⟩
            mem :=
              s.mem.storeLimbs out (Scalar52_from_bytes_wide.spec (s.mem.readAt bytes 512)) }) := by
  func_init
  have hrd : S.mem.readAt bytes 512 = S₀.mem.readAt bytes 512 := by rw [hS]
  block_init
  iterate 14 step_pure
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_41.value_eq with R
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_40.value_eq with RR
  step_pure
  step_alloca with zt_hi
  step_alloca with zt_lo
  step_alloca with hi_t
  step_alloca with lo_t
  step_alloca with hi
  step_alloca with lo
  step_alloca with w0
  step_alloca with w1
  step_alloca with w2
  step_alloca with w3
  step_alloca with w4
  step_alloca with w5
  step_alloca with w6
  step_alloca with w7
  have hR_read := anon_042b818bc72209407b52bd0e4d6c8368_41.readLimbs hR_fits hR_off hread_R
  have hRR_read := anon_042b818bc72209407b52bd0e4d6c8368_40.readLimbs hRR_fits hRR_off hread_RR
  clear hread_R hread_RR
  limbs_fit R
  limbs_fit RR
  iterate 8 step_pure
  obtain ⟨buf, hbuf⟩ : ∃ b, S₀.mem.readAt bytes 512 = b := ⟨_, rfl⟩
  rw [hbuf]
  have hbuf' := hrd.trans hbuf
  clear hrd
  -- `words[i] |= (bytes[(i * 8) + j] as u64) << (j * 8)`
  step_store
  step_store
  have hb := Agave.readAt_bytes0 hbuf' 64 (by decide)
  step_load consuming hb
  step_store
  step_pure
  ld 8 64
  step_store
  step_pure
  ld 16 64
  step_store
  -- `words[3]`, `words[4]`
  step_pure
  ld 24 8
  wstep
  byte 25
  byte 26
  byte 27
  byte 28
  byte 29
  byte 30
  byte 31
  step_store
  step_pure
  ld 32 8
  wstep
  byte 33
  byte 34
  byte 35
  byte 36
  byte 37
  byte 38
  byte 39
  step_store
  -- `words[5]`
  step_pure
  ld 40 8
  wstep
  byte 41
  byte 42
  byte 43
  byte 44
  byte 45
  wstep
  ld 46 8
  iterate 3 wstep
  ld 47 8
  iterate 4 wstep
  step_store
  -- `words[6]`
  step_pure
  step_load
  ld 48 8
  iterate 2 wstep
  byte 49
  byte 50
  byte 51
  wstep
  ld 52 16
  iterate 3 wstep
  ld 54 16
  iterate 4 wstep
  step_store
  -- `words[7]`
  step_pure
  step_load
  ld 56 8
  iterate 2 wstep
  byte 57
  byte 58
  wstep
  ld 59 8
  iterate 3 wstep
  ld 60 16
  iterate 4 wstep
  ld 62 16
  iterate 4 wstep
  step_store
  -- `lo[i] = …`, `hi[i] = …`
  iterate 2 step_pure
  step_load
  step_pure
  step_store
  iterate 4
    step_load
    iterate 3 step_pure
    step_store
  iterate 2 step_pure
  step_store
  iterate 3
    iterate 3 step_pure
    step_store
  iterate 2 step_pure
  step_store
  have hlo_limbs : S.mem.LimbsFit lo :=
    ⟨by
      rw [hlo_off]; decide, hfits_lo, hfits_lo_8, hfits_lo_16, hfits_lo_24, hfits_lo_32⟩
  have hhi_limbs : S.mem.LimbsFit hi :=
    ⟨by
      rw [hhi_off]; decide, hfits_hi, hfits_hi_8, hfits_hi_16, hfits_hi_24, hfits_hi_32⟩
  have hlo_read : S.mem.readLimbs lo = Scalar52_from_bytes_wide.lo buf :=
    readLimbs_of_reads (hread_lo.trans rfl)
      (hread_lo_8.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.lo]; bv_decide))
      (hread_lo_16.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.lo]; bv_decide))
      (hread_lo_24.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.lo]; bv_decide))
      (hread_lo_32.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.lo]; bv_decide))
  have hhi_read : S.mem.readLimbs hi = Scalar52_from_bytes_wide.hi buf :=
    readLimbs_of_reads
      (hread_hi.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.hi]; bv_decide))
      (hread_hi_8.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.hi]; bv_decide))
      (hread_hi_16.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.hi]; bv_decide))
      (hread_hi_24.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.hi]; bv_decide))
      (hread_hi_32.trans
        (by
          clear * -; simp only [Scalar52_from_bytes_wide.hi]; bv_decide))
  clear hread_lo hread_lo_8 hread_lo_16 hread_lo_24 hread_lo_32 hread_hi hread_hi_8 hread_hi_16
    hread_hi_24 hread_hi_32 hread_w0 hread_w1 hread_w2 hread_w3 hread_w4 hread_w5 hread_w6 hread_w7
  clear hfits_lo hfits_lo_8 hfits_lo_16 hfits_lo_24 hfits_lo_32 hfits_hi hfits_hi_8 hfits_hi_16
    hfits_hi_24 hfits_hi_32
  -- `lo = Scalar52::montgomery_mul(&lo, &constants::R);`
  step_pure
  limbs_room lo_t
  step_call using Scalar52_montgomery_mul.call_eq [hlo_read] consuming hlo_read
  have hsrc := Agave.fits_of_limbsFit hlo_t_limbs
  step_memcpy consuming hsrc
  copied lo
  clear_facts lo_t
  clear hread_lo_t hread_lo_t_readLimbs
  step_pure
  -- `hi = Scalar52::montgomery_mul(&hi, &constants::RR);`
  step_pure
  limbs_room hi_t
  step_call using Scalar52_montgomery_mul.call_eq [hhi_read] consuming hhi_read
  have hsrc := Agave.fits_of_limbsFit hhi_t_limbs
  step_memcpy consuming hsrc
  copied hi
  clear_facts hi_t
  clear hread_hi_t hread_hi_t_readLimbs
  step_pure
  -- `let reduced = Scalar52::add(&hi, &lo);`
  step_call using Scalar52_add.call_eq
  clear hread_hi_readLimbs hread_lo_readLimbs
  -- `words.zeroize(); lo.zeroize(); hi.zeroize();`
  iterate 8 step_store
  step_pure
  step_memset
  step_memcpy
  step_pure
  step_pure
  step_memset
  step_memcpy
  iterate 11 step_pure
  finish_block
  clear_reads
  subst_vars
  erase_frame
  simp only [GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
  rfl

end Proof

end MLIR.Agave.Serial
