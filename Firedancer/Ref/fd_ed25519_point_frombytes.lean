module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Tactics
public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_frombytes
public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_sub
public import Firedancer.Ref.fd_f25519_add
public import Firedancer.Ref.fd_f25519_sqrt_ratio
public import Firedancer.Ref.fd_f25519_sgn
public import Firedancer.Ref.fd_f25519_neg
public import Firedancer.Ref.fd_ed25519_point_from
public import Firedancer.Ref.Mlir.fd_ed25519_point_frombytes

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The point `buf` encodes, `none` when `x² = (y² - 1)/(d y² + 1)` has no root: `x` with the sign
of `buf`'s top bit (`x = 0` accepted with either), `Z = 1`, `T = x y`. -/
def fd_ed25519_point_frombytes.spec (buf : BitVec 256) : Option PointLimbs :=
  let y := fd_f25519_frombytes.spec buf
  let expected_x_sign := buf.extractLsb' 248 8 >>> 7
  let u := fd_f25519_sqr.spec y
  let v := fd_f25519_mul.spec u fd_f25519_d.limbs
  let u := fd_f25519_sub.spec u fd_f25519_one.limbs
  let v := fd_f25519_add.spec v fd_f25519_one.limbs
  let x := (fd_f25519_sqrt_ratio.spec u v).r
  let was_square := (fd_f25519_sqrt_ratio.spec u v).ret
  if was_square = 0#32 then none
  else
    let x := if fd_f25519_sgn.spec x = expected_x_sign.setWidth 32 then x else fd_f25519_neg.spec x
    let t := fd_f25519_mul.spec x y
    some ⟨x, y, t, fd_f25519_one.limbs⟩

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_frombytes` decodes the 32 bytes at `buf`: when `spec` is a point, it stores it
at `r` and returns `r`, else it returns null and stores nothing. `buf` is read before `r` is
written, so `r` may alias it. The globals', temporaries' and callees' blocks are freed again: only
the counter moves on, by 79 blocks (57 on failure). -/
public theorem fd_ed25519_point_frombytes.call_eq (r buf : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointFit r) (hbuf : Fits s.mem buf (8 * 32))
    (hbuf_off : ¬buf.offset.uaddOverflow 32#64) :
    fd_ed25519_point_frombytes.call (fd_ed25519_point_frombytes.args (.value r) (.value buf)) s =
      .value
        (.cons
            (.value
              (if (fd_ed25519_point_frombytes.spec (s.mem.readAt buf 256)).isSome then r
              else Pointer.null))
            .nil,
          {
            alloc :=
              ⟨s.alloc.nextFreeBlock +
                  if (fd_ed25519_point_frombytes.spec (s.mem.readAt buf 256)).isSome then 79
                  else 57⟩,
            mem :=
              s.mem.storePointOpt r
                (fd_ed25519_point_frombytes.spec (s.mem.readAt buf 256)) }) := by
  func_init
  -- `buf`'s bytes as a read fact, carried past the frame's blocks and stores
  have hbuf_read : S.mem.readAt buf 256 = S₀.mem.readAt buf 256 := by rw [hS]
  block_init
  iterate 3 step_pure
  step_addressof fd_f25519_d.value_eq with d
  step_addressof fd_f25519_one.value_eq with one
  step_pure
  -- fd_f25519_t x[1], y[1], t[1]; … fd_f25519_t u[1]; fd_f25519_t v[1];
  step_alloca with x
  step_alloca with y
  step_alloca with t
  step_alloca with u
  step_alloca with v
  have hd_read := fd_f25519_d.readLimbs hd_fits hd_off hread_d
  have hone_read := fd_f25519_one.readLimbs hone_fits hone_off hread_one
  clear hread_d hread_one
  limbs_fit d
  limbs_fit one
  limbs_fit x
  limbs_fit y
  limbs_fit t
  limbs_fit u
  limbs_fit v
  iterate 3 step_pure
  -- fd_f25519_frombytes( y, buf );
  step_call using fd_f25519_frombytes.call_eq
  name_limbs ly
  -- uchar expected_x_sign = buf[31] >> 7;
  step_pure
  step_load with buf31 consuming hbuf_read hbuf
  iterate 2 step_pure
  -- fd_f25519_sqr( u, y ); fd_f25519_mul( v, u, fd_f25519_d );
  step_call using fd_f25519_sqr.call_eq
  name_limbs lu0
  step_call using fd_f25519_mul.call_eq consuming hd_read hd_limbs
  name_limbs lv0
  -- fd_f25519_sub( u, u, fd_f25519_one ); fd_f25519_add( v, v, fd_f25519_one );
  step_call using fd_f25519_sub.call_eq
  name_limbs lu1
  step_call using fd_f25519_add.call_eq
  name_limbs lv1
  -- int was_square = fd_f25519_sqrt_ratio( x, u, v );
  step_call using fd_f25519_sqrt_ratio.call_eq with was_square consuming hread_u hread_v hu_limbs
    hv_limbs
  name_limbs lx0
  -- the returned value unfolds the limbs' names: fold them back
  rw [← hlu0, ← hlv0, ← hlu1, ← hlv1] at hwas_square
  step_pure
  finish_block
  case isTrue =>
    -- if( FD_UNLIKELY( !was_square ) ) return NULL;
    block_init
    iterate 5 step_pure
    finish_block
    have hnone : fd_ed25519_point_frombytes.spec (S₀.mem.readAt buf 256) = none := by
      simp only [fd_ed25519_point_frombytes.spec, ← hly, ← hlu0, ← hlv0, ← hlu1, ← hlv1,
        ← hwas_square, hbr, ↓reduceIte]
    clear_reads
    subst hS
    erase_frame
    simp only [hnone]
    rfl
  case isFalse =>
    -- if( fd_f25519_sgn(x)!=expected_x_sign ) fd_f25519_neg( x, x );
    have hsquare := hbr
    clear hbr
    block_init
    step_pure with expected_x_sign
    step_call using fd_f25519_sgn.call_eq with sgn_x
    rw [← hlu1, ← hlv1, ← hlx0] at hsgn_x
    iterate 2 step_pure
    finish_block
    case' isFalse =>
      block_init
      step_call using fd_f25519_neg.call_eq
      name_limbs lx1
      finish_block
    all_goals
      -- fd_f25519_mul( t, x, y );
      block_init
      step_call using fd_f25519_mul.call_eq
      name_limbs lt
      -- fd_ed25519_point_from( r, x, y, fd_f25519_one, t );
      step_call using fd_ed25519_point_from.call_eq
      finish_block
      -- return r;
      block_init
      iterate 5 step_pure
      finish_block
      clear_reads
      clear hread_r
      subst hS
      erase_frame
      subst_vars
      simp only [fd_ed25519_point_frombytes.spec, hsquare, hbr, ↓reduceIte, Option.isSome_some,
        MemoryState.storePointOpt_some]
      rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref
