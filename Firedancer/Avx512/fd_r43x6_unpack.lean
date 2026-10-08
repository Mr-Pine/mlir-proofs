module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Wwl
public import Firedancer.Avx512.Mlir.fd_r43x6_unpack

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_unpack(u)`: the 256 bits of `u` cut into five 43-bit limbs and a 41-bit one, lanes 6
and 7 zero. -/
def fd_r43x6_unpack.spec (u : Wv) : Wwl :=
  let zero := wwl_zero
  let perm := wwl 0x3f3f050403020100 0x3f3f0a0908070605 0x3f100f0e0d0c0b0a 0x3f3f151413121110
    0x3f3f1a1918171615 0x3f3f1f1e1d1c1b1a 0x3f3f3f3f3f3f3f3f 0x3f3f3f3f3f3f3f3f
  let rshift := wwl 0 3 6 1 4 7 0 0
  let mask := wwl_bcast ((1 <<< 43) - 1)
  wwl_and (wwl_shru_vector (mm512_permutexvar_epi8 perm (mm512_inserti64x4 zero u)) rshift) mask

end

/-! ## Proof -/

section Proof

/-- `perm`'s byte indices, as the shuffle's mask. -/
theorem fd_r43x6_unpack.perm_idx :
    permutexvarIdx
        (wwl 0x3f3f050403020100 0x3f3f0a0908070605 0x3f100f0e0d0c0b0a 0x3f3f151413121110
          0x3f3f1a1918171615 0x3f3f1f1e1d1c1b1a 0x3f3f3f3f3f3f3f3f 0x3f3f3f3f3f3f3f3f) =
      #v[0, 1, 2, 3, 4, 5, 63, 63, 5, 6, 7, 8, 9, 10, 63, 63, 10, 11, 12, 13, 14, 15, 16, 63, 16,
        17, 18, 19, 20, 21, 63, 63, 21, 22, 23, 24, 25, 26, 63, 63, 26, 27, 28, 29, 30, 31, 63, 63,
        63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63] := by
  ext i hi : 1
  simp only [permutexvarIdx, wwl, Vector.getElem_ofFn]
  revert i; decide

/-- `fd_r43x6_unpack` returns `spec u` and leaves the state as it is. -/
public theorem fd_r43x6_unpack.call_eq (u : Wv) (s : GlobalState) (hwf : s.WF) :
    fd_r43x6_unpack.call (fd_r43x6_unpack.args (Ty.wrap (t := .vec 4 64) u)) s =
      .value (.cons (Ty.wrap (fd_r43x6_unpack.spec u)) .nil, s) := by
  func_init
  block_init
  -- the constants
  iterate 6 step_pure
  -- `_mm512_inserti64x4( zero, u, 0 )` and its bytes
  step_pure with u8
  step_pure with z
  step_pure with zb
  -- `_mm512_permutexvar_epi8( perm, … )`'s bytes
  step_pure with b
  subst hu8 hz hzb
  replace hb :
    b = Ty.wrap (t := .vec 64 8)
      (permutexvarBytes
        (wwl 0x3f3f050403020100 0x3f3f0a0908070605 0x3f100f0e0d0c0b0a 0x3f3f151413121110
          0x3f3f1a1918171615 0x3f3f1f1e1d1c1b1a 0x3f3f3f3f3f3f3f3f 0x3f3f3f3f3f3f3f3f)
        (mm512_inserti64x4 wwl_zero u)) := by
    simp [Fin.exists_fin_succ] at hb
    rw [hb, permutexvarBytes, fd_r43x6_unpack.perm_idx]
    simp [mm512_inserti64x4]
  -- back to lanes, `wwl_shru_vector( …, rshift )`, `wwl_and( …, mask )`
  iterate 3 step_pure
  finish_block
  clear hE hArgs
  subst_vars
  simp [fd_r43x6_unpack.spec, Ty.wrap_vec, wwl_and, wwl_shru_vector, mm512_permutexvar_epi8,
    Function.comp_def]
  ext i hi : 1
  simp [wwl, wwl_bcast]
  intro h
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;> simp at h <;> omega

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
