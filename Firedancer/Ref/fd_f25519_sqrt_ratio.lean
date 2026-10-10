module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Common.Tactics
public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_neg
public import Firedancer.Ref.fd_f25519_eq
public import Firedancer.Ref.fd_f25519_if
public import Firedancer.Ref.fd_f25519_pow22523
public import Firedancer.Ref.fd_f25519_abs
public import Firedancer.Ref.Mlir.fd_f25519_sqrt_ratio

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- What `fd_f25519_sqrt_ratio` computes: the limbs it stores at `r`, and the flag it returns. -/
structure fd_f25519_sqrt_ratio.Result where
  r : Fin 5 → BitVec 64
  ret : BitVec 32

/-- `r = (u v³) (u v⁷)^((p-5)/8)`, times `√-1` when `v r²` is `-u` or `-u √-1`, then `|r|`; the
flag is `1` when `v r²` is `u` or `-u`. The `or`s in the program's operand order. -/
def fd_f25519_sqrt_ratio.spec (u v : Fin 5 → BitVec 64) : fd_f25519_sqrt_ratio.Result :=
  let v2 := fd_f25519_sqr.spec v
  let v3 := fd_f25519_mul.spec v2 v
  let uv3 := fd_f25519_mul.spec u v3
  let v6 := fd_f25519_sqr.spec v3
  let v7 := fd_f25519_mul.spec v6 v
  let uv7 := fd_f25519_mul.spec u v7
  let r := fd_f25519_pow22523.spec uv7
  let r := fd_f25519_mul.spec r uv3
  let check := fd_f25519_sqr.spec r
  let check := fd_f25519_mul.spec check v
  let u_neg := fd_f25519_neg.spec u
  let u_neg_sqrtm1 := fd_f25519_mul.spec u_neg fd_f25519_sqrtm1.limbs
  let correct_sign_sqrt := fd_f25519_eq.spec check u
  let flipped_sign_sqrt := fd_f25519_eq.spec check u_neg
  let flipped_sign_sqrt_i := fd_f25519_eq.spec check u_neg_sqrtm1
  let r_prime := fd_f25519_mul.spec r fd_f25519_sqrtm1.limbs
  let r := fd_f25519_if.spec (flipped_sign_sqrt_i ||| flipped_sign_sqrt) r_prime r
  let r := fd_f25519_abs.spec r
  ⟨r, flipped_sign_sqrt ||| correct_sign_sqrt⟩

end

/-! ## Proof -/

section Proof

/-- An `or` of two `fd_f25519_eq` flags is `0` or `1`: it fits `fd_f25519_if`'s `uchar`. -/
theorem fd_f25519_eq.spec_or_lt (a b c d : Fin 5 → BitVec 64) :
    (fd_f25519_eq.spec a b).toNat ||| (fd_f25519_eq.spec c d).toNat < 256 := by
  have h (a b : Fin 5 → BitVec 64) : (fd_f25519_eq.spec a b).toNat < 2 ^ 8 := by
    simp only [fd_f25519_eq.spec, fd_f25519_is_zero.spec]
    split <;> decide
  exact Nat.or_lt_two_pow (h a b) (h c d)

/-! ### The function -/

/-- `fd_f25519_sqrt_ratio` stores `(spec u v).r` at `r` and returns `(spec u v).ret`; `u` and `v`
are read after `r` is written, so `r` is in another block, while `u` may alias `v`.
`fd_f25519_sqrtm1`, the ten temporaries and the callees' blocks are freed again: only the counter
moves on, by 50 blocks. -/
public theorem fd_f25519_sqrt_ratio.call_eq (r u v : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsRoom r) (hu : s.mem.LimbsFit u) (hv : s.mem.LimbsFit v) (hru : r.id ≠ u.id)
    (hrv : r.id ≠ v.id) :
    fd_f25519_sqrt_ratio.call (fd_f25519_sqrt_ratio.args (.value r) (.value u) (.value v)) s =
      .value
        (.cons (.value (fd_f25519_sqrt_ratio.spec (s.mem.readLimbs u) (s.mem.readLimbs v)).ret)
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 50⟩,
            mem :=
              s.mem.storeLimbs r
                (fd_f25519_sqrt_ratio.spec (s.mem.readLimbs u) (s.mem.readLimbs v)).r }) := by
  func_init
  -- reads of `u` and `v` pass the frame's blocks: their facts about the chain's base `S₀`
  have hu₀ : S₀.mem.LimbsFit u := hS ▸ hu
  have hv₀ : S₀.mem.LimbsFit v := hS ▸ hv
  block_init
  step_pure
  step_addressof fd_f25519_sqrtm1.value_eq with sqrtm1
  -- the temporaries, in the C's order of declaration
  step_alloca with v2
  step_alloca with v3
  step_alloca with uv3
  step_alloca with v6
  step_alloca with v7
  step_alloca with uv7
  step_alloca with check
  step_alloca with u_neg
  step_alloca with u_neg_sqrtm1
  step_alloca with r_prime
  have hsqrtm1_read := fd_f25519_sqrtm1.readLimbs hsqrtm1_fits hsqrtm1_off hread_sqrtm1
  clear hread_sqrtm1
  limbs_fit sqrtm1
  -- each temporary's lifetime starts before its first write: then its limbs have room
  -- fd_f25519_sqr( v2, v );
  step_pure
  limbs_room v2
  step_call using fd_f25519_sqr.call_eq
  name_limbs lv2
  -- fd_f25519_mul( v3, v2, v );
  step_pure
  limbs_room v3
  step_call using fd_f25519_mul.call_eq consuming hread_v2
  name_limbs lv3
  clear_facts v2
  -- fd_f25519_mul( uv3, u, v3 );
  step_pure
  limbs_room uv3
  step_call using fd_f25519_mul.call_eq
  name_limbs luv3
  -- fd_f25519_sqr( v6, v3 );
  step_pure
  limbs_room v6
  step_call using fd_f25519_sqr.call_eq consuming hread_v3
  name_limbs lv6
  clear_facts v3
  -- fd_f25519_mul( v7, v6, v );
  step_pure
  limbs_room v7
  step_call using fd_f25519_mul.call_eq consuming hread_v6
  name_limbs lv7
  clear_facts v6
  -- fd_f25519_mul( uv7, u, v7 );
  step_pure
  limbs_room uv7
  step_call using fd_f25519_mul.call_eq consuming hread_v7
  name_limbs luv7
  clear_facts v7
  -- fd_f25519_pow22523( r, uv7 );
  step_call using fd_f25519_pow22523.call_eq consuming hread_uv7
  name_limbs lr0
  clear_facts uv7
  -- fd_f25519_mul( r, r, uv3 );
  step_call using fd_f25519_mul.call_eq consuming hread_uv3
  name_limbs lr1
  clear_facts uv3
  -- fd_f25519_sqr( check, r );
  step_pure
  limbs_room check
  step_call using fd_f25519_sqr.call_eq
  name_limbs lcheck0
  -- fd_f25519_mul( check, check, v );
  step_call using fd_f25519_mul.call_eq consuming hv
  name_limbs lcheck1
  clear hv₀ hrv hv_ne_sqrtm1 hv_ne_v2 hv_ne_v3 hv_ne_uv3 hv_ne_v6 hv_ne_v7 hv_ne_uv7 hv_ne_check
    hv_ne_u_neg hv_ne_u_neg_sqrtm1 hv_ne_r_prime
  -- fd_f25519_neg( u_neg, u );
  step_pure
  limbs_room u_neg
  step_call using fd_f25519_neg.call_eq
  name_limbs lu_neg
  -- fd_f25519_mul( u_neg_sqrtm1, u_neg, fd_f25519_sqrtm1 );
  step_pure
  limbs_room u_neg_sqrtm1
  step_call using fd_f25519_mul.call_eq
  name_limbs lu_neg_sqrtm1
  -- int correct_sign_sqrt   = fd_f25519_eq( check, u );
  step_call using fd_f25519_eq.call_eq with correct_sign_sqrt consuming hu
  clear hu₀ hru hu_ne_sqrtm1 hu_ne_v2 hu_ne_v3 hu_ne_uv3 hu_ne_v6 hu_ne_v7 hu_ne_uv7 hu_ne_check
    hu_ne_u_neg hu_ne_u_neg_sqrtm1 hu_ne_r_prime
  -- int flipped_sign_sqrt   = fd_f25519_eq( check, u_neg );
  step_call using fd_f25519_eq.call_eq with flipped_sign_sqrt consuming hread_u_neg
  clear_facts u_neg
  -- int flipped_sign_sqrt_i = fd_f25519_eq( check, u_neg_sqrtm1 );
  step_call using fd_f25519_eq.call_eq with flipped_sign_sqrt_i consuming hread_u_neg_sqrtm1
  clear_facts u_neg_sqrtm1 check
  clear hread_check
  -- the returned values unfold the limbs' names: fold them back
  rw [← hlcheck0, ← hlcheck1] at hcorrect_sign_sqrt
  rw [← hlcheck0, ← hlcheck1, ← hlu_neg] at hflipped_sign_sqrt
  rw [← hlcheck0, ← hlcheck1, ← hlu_neg, ← hlu_neg_sqrtm1] at hflipped_sign_sqrt_i
  -- fd_f25519_mul( r_prime, r, fd_f25519_sqrtm1 );
  step_pure
  limbs_room r_prime
  step_call using fd_f25519_mul.call_eq consuming hsqrtm1_read
  name_limbs lr_prime
  clear_facts sqrtm1
  -- fd_f25519_if( r, flipped_sign_sqrt|flipped_sign_sqrt_i, r_prime, r );
  step_pure
  have hcond := fd_f25519_eq.spec_or_lt
  step_call using fd_f25519_if.call_eq consuming hread_r_prime
  name_limbs lr2
  clear_facts r_prime
  -- fd_f25519_abs( r, r );
  step_call using fd_f25519_abs.call_eq
  name_limbs lr3
  -- return correct_sign_sqrt|flipped_sign_sqrt; the temporaries' lifetimes end
  clear_facts r
  step_pure
  iterate 10 step_pure
  finish_block
  clear_reads
  subst hS
  erase_frame
  simp only [MemoryState.storeLimbs_storeLimbs_self]
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Ref
