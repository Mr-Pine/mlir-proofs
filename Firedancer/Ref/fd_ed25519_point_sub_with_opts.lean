module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Common.Tactics
public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_add
public import Firedancer.Ref.fd_f25519_add_nr
public import Firedancer.Ref.fd_f25519_sub_nr
public import Firedancer.Ref.fd_f25519_mul3
public import Firedancer.Ref.fd_ed25519_point_add_final_mul
public import Firedancer.Ref.Mlir.fd_ed25519_point_sub_with_opts

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- The last step, from `r5 … r8`: the sums `(r1, r2, r3, r4)` in `X, Y, Z, T`, multiplied unless
`skip_last_mul`. -/
def fd_ed25519_point_sub_with_opts.last (r5 r6 r7 r8 : Fin 5 → BitVec 64)
    (skip_last_mul : BitVec 32) : PointLimbs :=
  let P : PointLimbs :=
    { X := fd_f25519_sub_nr.spec r6 r5, Y := fd_f25519_add_nr.spec r8 r7,
      Z := fd_f25519_sub_nr.spec r8 r7, T := fd_f25519_add_nr.spec r6 r5 }
  if skip_last_mul = 0#32 then fd_ed25519_point_add_final_mul.spec P else P

/-- `A - B` in extended coordinates, where a nonzero `b_Z_is_one` takes `B.Z` as 1 and a nonzero
`b_is_precomputed` takes `B.Y, B.X, B.T` as `r2, r4, k B.T`; a nonzero `skip_last_mul` leaves the
final product's operands `(r1, r2, r3, r4)` in `X, Y, Z, T`. -/
def fd_ed25519_point_sub_with_opts.spec (A B : PointLimbs)
    (b_Z_is_one b_is_precomputed skip_last_mul : BitVec 32) : PointLimbs :=
  let r1 := fd_f25519_sub_nr.spec A.Y A.X
  let r3 := fd_f25519_add_nr.spec A.Y A.X
  let r2 := if b_is_precomputed = 0#32 then fd_f25519_add_nr.spec B.Y B.X else B.Y
  let r4 := if b_is_precomputed = 0#32 then fd_f25519_sub_nr.spec B.Y B.X else B.X
  let r5 := fd_f25519_mul.spec r1 r2
  let r6 := fd_f25519_mul.spec r3 r4
  let r7 := fd_f25519_mul.spec A.T B.T
  let r8 :=
    if b_Z_is_one = 0#32 then
      let t := fd_f25519_add_nr.spec A.Z A.Z
      fd_f25519_mul.spec t B.Z
    else fd_f25519_add.spec A.Z A.Z
  let r7 := if b_is_precomputed = 0#32 then fd_f25519_mul.spec r7 fd_f25519_k.limbs else r7
  fd_ed25519_point_sub_with_opts.last r5 r6 r7 r8 skip_last_mul

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `branch x`: the branch condition `hbr` is named `x`. -/
local macro "branch " x:ident : tactic => `(tactic| (have $x := hbr; clear hbr))

set_option hygiene false in
/-- From `^bb7`: `last_block`, then the frame erased and `spec` unfolded along the branches. -/
local macro "last_close" : tactic =>
  `(tactic|
    ( rw [fd_ed25519_point_sub_with_opts.last_block r r1 r2 r3 r4 r5 r6 r7 r8 t skip_last_mul (n :=
          S₀.alloc.nextFreeBlock) hArgs (by env_reads) hwf hr (by mem_fact) (by mem_fact)
          (by mem_fact) (by mem_fact) hr5_limbs hr6_limbs hr7_limbs hr8_limbs hsep (by slot_bound)
          (by slot_bound) (by slot_bound) (by slot_bound) (by slot_bound) (by slot_bound)
          (by slot_bound) (by slot_bound) (by slot_bound) hread_r5 hread_r6 hread_r7 hread_r8]
      clear_reads
      subst hS
      erase_frame
      simp only [GlobalState.alloca_alloc, fd_ed25519_point_sub_with_opts.spec, hpre, hz,
        ↓reduceIte]
      subst_vars
      rfl))

set_option hygiene false in
/-- `^bb2` to `^bb5`: `r5 … r8` by `mul4` after `t` (`^bb4`) or by `mul3` and `add` (`^bb3`), then
`next` from `^bb5`; the facts `dead` are dropped after the products. -/
local macro "muls " "[" dead:ident,* "]" next:tactic : tactic =>
  `(tactic|
    ( block_init
      step_pure
      finish_block
      case isTrue =>
        branch hz
        -- fd_f25519_add_nr( t, a->Z, a->Z );
        -- fd_f25519_mul4( r5, r1, r2p, r6, r3, r4p, r7, a->T, b->T, r8, t, b->Z );
        block_init
        step_pure
        step_call using fd_f25519_add_nr.call_eq
        name_limbs lt
        limbs_stored t
        clear haZ_read haZ
        iterate 3 step_pure
        step_call using fd_f25519_mul4.call_eq
        clear haT_read hbT_read hbZ_read haT hbT hbZ hread_r1 hread_r3 hread_t $dead*
        name_limbs l8
        name_limbs l7
        name_limbs l6
        name_limbs l5
        limbs_stored r5 r6 r7 r8
        finish_block
        $next:tactic
      case isFalse =>
        branch hz
        -- fd_f25519_mul3( r5, r1, r2p, r6, r3, r4p, r7, a->T, b->T );
        -- fd_f25519_add( r8, a->Z, a->Z );
        block_init
        iterate 2 step_pure
        step_call using fd_f25519_mul3.call_eq
        clear haT_read hbT_read haT hbT hbZ_read hbZ hread_r1 hread_r3 $dead*
        name_limbs l7
        name_limbs l6
        name_limbs l5
        limbs_stored r5 r6 r7
        step_pure
        step_call using fd_f25519_add.call_eq
        clear haZ_read haZ
        name_limbs l8
        limbs_stored r8
        finish_block
        $next:tactic))

/-- `^bb7` to the return, the frame erased from `n` on: the last step's point at `r`. The
temporaries `r1 … r4` it overwrites are in the frame. -/
theorem fd_ed25519_point_sub_with_opts.last_block (r r1 r2 r3 r4 r5 r6 r7 r8 t : Pointer)
    (skip_last_mul : BitVec 32) {a b : Pointer} {b_Z_is_one b_is_precomputed : BitVec 32}
    {v5 v6 v7 v8 : Fin 5 → BitVec 64} {n : Nat} {S : GlobalState}
    {E : ⟪fd_ed25519_point_sub_with_opts.Γ⟫}
    (hArgs :
      E.args =
        (fd_ed25519_point_sub_with_opts.args (.value r) (.value a) (.value b) (.value b_Z_is_one)
            (.value b_is_precomputed) (.value skip_last_mul)).get)
    (hR :
      E ⊨ [%1854 := 0#32, %1856 := r1, %1857 := r2, %1858 := r3, %1859 := r4, %1860 := r5, %1861 :=
        r6, %1862 := r7, %1863 := r8, %1864 := t])
    (hwf : S.WF) (hr : S.mem.PointRoom r) (hr1 : S.mem.LimbsRoom r1) (hr2 : S.mem.LimbsRoom r2)
    (hr3 : S.mem.LimbsRoom r3) (hr4 : S.mem.LimbsRoom r4) (hr5 : S.mem.LimbsFit r5)
    (hr6 : S.mem.LimbsFit r6) (hr7 : S.mem.LimbsFit r7) (hr8 : S.mem.LimbsFit r8)
    (hsep : [r.id, r1.id, r2.id, r3.id, r4.id, r5.id, r6.id, r7.id, r8.id].Nodup)
    (hn1 : n ≤ r1.id.id) (hn2 : n ≤ r2.id.id) (hn3 : n ≤ r3.id.id) (hn4 : n ≤ r4.id.id)
    (hn5 : n ≤ r5.id.id) (hn6 : n ≤ r6.id.id) (hn7 : n ≤ r7.id.id) (hn8 : n ≤ r8.id.id)
    (hnt : n ≤ t.id.id) (h5 : S.mem.readLimbs r5 = v5) (h6 : S.mem.readLimbs r6 = v6)
    (h7 : S.mem.readLimbs r7 = v7) (h8 : S.mem.readLimbs r8 = v8) :
    (fd_ed25519_point_sub_with_opts.runFrom E 7 S >>= fun p =>
        PoisonOr.value (p.1, ({ alloc := p.2.alloc, mem := p.2.mem.eraseFrom n } : GlobalState))) =
      .value
        (.cons (.value r) .nil,
          ({ alloc := S.alloc,
             mem :=
               (S.mem.eraseFrom n).storePoint r
                 (fd_ed25519_point_sub_with_opts.last v5 v6 v7 v8 skip_last_mul) } :
            GlobalState)) := by
  block_init
  step_pure
  finish_block
  case isTrue =>
    block_init
    -- fd_f25519_sub_nr( r1, r6, r5 ); fd_f25519_add_nr( r2, r8, r7 );
    -- fd_f25519_sub_nr( r3, r8, r7 ); fd_f25519_add_nr( r4, r6, r5 );
    step_call using fd_f25519_sub_nr.call_eq
    step_call using fd_f25519_add_nr.call_eq
    step_call using fd_f25519_sub_nr.call_eq
    step_call using fd_f25519_add_nr.call_eq
    -- fd_f25519_mul4( r->X, r1, r2, r->Y, r3, r4, r->Z, r2, r3, r->T, r1, r4 );
    iterate 3 step_pure
    step_call using fd_f25519_mul4.call_eq
    finish_block
    block_init
    clear_facts r r1 r2 r3 r4 r5 r6 r7 r8
    iterate 9 step_pure
    finish_block
    simp only [hS, fd_ed25519_point_sub_with_opts.last, hbr, ↓reduceIte,
      MemoryState.eraseFrom_storeLimbs, MemoryState.storeLimbs_eraseFrom_of_le hn1,
      MemoryState.storeLimbs_eraseFrom_of_le hn2, MemoryState.storeLimbs_eraseFrom_of_le hn3,
      MemoryState.storeLimbs_eraseFrom_of_le hn4, MemoryState.eraseFrom_lifetimeEnd_of_le hn1,
      MemoryState.eraseFrom_lifetimeEnd_of_le hn2, MemoryState.eraseFrom_lifetimeEnd_of_le hn3,
      MemoryState.eraseFrom_lifetimeEnd_of_le hn4, MemoryState.eraseFrom_lifetimeEnd_of_le hn5,
      MemoryState.eraseFrom_lifetimeEnd_of_le hn6, MemoryState.eraseFrom_lifetimeEnd_of_le hn7,
      MemoryState.eraseFrom_lifetimeEnd_of_le hn8, MemoryState.eraseFrom_lifetimeEnd_of_le hnt]
    rfl
  case isFalse =>
    block_init
    -- fd_f25519_sub_nr( r->X, r6, r5 ); fd_f25519_add_nr( r->Y, r8, r7 );
    -- fd_f25519_sub_nr( r->Z, r8, r7 ); fd_f25519_add_nr( r->T, r6, r5 );
    step_call using fd_f25519_sub_nr.call_eq
    step_pure
    step_call using fd_f25519_add_nr.call_eq
    step_pure
    step_call using fd_f25519_sub_nr.call_eq
    step_pure
    step_call using fd_f25519_add_nr.call_eq
    finish_block
    block_init
    clear_facts r r1 r2 r3 r4 r5 r6 r7 r8
    iterate 9 step_pure
    finish_block
    simp only [hS, fd_ed25519_point_sub_with_opts.last, hbr, ↓reduceIte,
      MemoryState.eraseFrom_lifetimeEnd_of_le hn1, MemoryState.eraseFrom_lifetimeEnd_of_le hn2,
      MemoryState.eraseFrom_lifetimeEnd_of_le hn3, MemoryState.eraseFrom_lifetimeEnd_of_le hn4,
      MemoryState.eraseFrom_lifetimeEnd_of_le hn5, MemoryState.eraseFrom_lifetimeEnd_of_le hn6,
      MemoryState.eraseFrom_lifetimeEnd_of_le hn7, MemoryState.eraseFrom_lifetimeEnd_of_le hn8,
      MemoryState.eraseFrom_lifetimeEnd_of_le hnt, MemoryState.eraseFrom_storeLimbs]
    rfl

-- the nine temporaries' lifetime starts, then their facts through every step: about 300000
-- heartbeats
set_option maxHeartbeats 400000 in
/-- `fd_ed25519_point_sub_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`. `r` may alias `a` or `b`: every read of them comes before the first store to `r`. The global
`fd_f25519_k` and the nine temporaries count ten blocks. -/
public theorem fd_ed25519_point_sub_with_opts.call_eq (r a b : Pointer)
    (b_Z_is_one b_is_precomputed skip_last_mul : BitVec 32) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (ha : s.mem.PointFit a) (hb : s.mem.PointFit b) :
    fd_ed25519_point_sub_with_opts.call
        (fd_ed25519_point_sub_with_opts.args (.value r) (.value a) (.value b) (.value b_Z_is_one)
          (.value b_is_precomputed) (.value skip_last_mul))
        s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 10⟩,
            mem :=
              s.mem.storePoint r
                (fd_ed25519_point_sub_with_opts.spec (s.mem.readPoint a) (s.mem.readPoint b)
                  b_Z_is_one b_is_precomputed skip_last_mul) }) := by
  func_init
  block_init
  -- `a`'s and `b`'s coordinates, read before the frame's blocks: later reads need not pass them
  have haX_read : S.mem.readLimbs a = S₀.mem.readLimbs a := by rw [hS]
  have haY_read : S.mem.readLimbs (a.add 40#64) = S₀.mem.readLimbs (a.add 40#64) := by rw [hS]
  have haT_read : S.mem.readLimbs (a.add 80#64) = S₀.mem.readLimbs (a.add 80#64) := by rw [hS]
  have haZ_read : S.mem.readLimbs (a.add 120#64) = S₀.mem.readLimbs (a.add 120#64) := by rw [hS]
  have hbX_read : S.mem.readLimbs b = S₀.mem.readLimbs b := by rw [hS]
  have hbY_read : S.mem.readLimbs (b.add 40#64) = S₀.mem.readLimbs (b.add 40#64) := by rw [hS]
  have hbT_read : S.mem.readLimbs (b.add 80#64) = S₀.mem.readLimbs (b.add 80#64) := by rw [hS]
  have hbZ_read : S.mem.readLimbs (b.add 120#64) = S₀.mem.readLimbs (b.add 120#64) := by rw [hS]
  iterate 2 step_pure
  step_addressof fd_f25519_k.value_eq with k
  -- fd_f25519_t r1[1], r2[1], r3[1], r4[1], r5[1], r6[1], r7[1], r8[1], t[1];
  step_alloca with r1
  step_alloca with r2
  step_alloca with r3
  step_alloca with r4
  step_alloca with r5
  step_alloca with r6
  step_alloca with r7
  step_alloca with r8
  step_alloca with t
  iterate 9 step_pure
  have hk_read := fd_f25519_k.readLimbs hk_fits hk_off hread_k
  clear hread_k
  limbs_fit k
  limbs_room r1
  limbs_room r2
  limbs_room r3
  limbs_room r4
  limbs_room r5
  limbs_room r6
  limbs_room r7
  limbs_room r8
  limbs_room t
  have hsep : [r.id, r1.id, r2.id, r3.id, r4.id, r5.id, r6.id, r7.id, r8.id].Nodup := by
    simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil, or_false, not_or, List.nodup_nil,
      and_true]
    and_intros <;> mem_fact
  -- the coordinates' limbs fit; of the points only their offsets stay, for the `getelementptr`s
  have haX := ha.limbsFit_X
  have haY := ha.limbsFit_Y
  have haT := ha.limbsFit_T
  have haZ := ha.limbsFit_Z
  have hbX := hb.limbsFit_X
  have hbY := hb.limbsFit_Y
  have hbT := hb.limbsFit_T
  have hbZ := hb.limbsFit_Z
  replace ha := ha.1
  replace hb := hb.1
  -- fd_f25519_sub_nr( r1, a->Y, a->X ); fd_f25519_add_nr( r3, a->Y, a->X );
  step_pure
  step_call using fd_f25519_sub_nr.call_eq
  name_limbs l1
  limbs_stored r1
  step_call using fd_f25519_add_nr.call_eq
  name_limbs l3
  limbs_stored r3
  clear haX_read haY_read haX haY
  step_pure
  step_pure
  finish_block
  case isTrue =>
    branch hpre
    -- fd_f25519_add_nr( r2, b->Y, b->X ); fd_f25519_sub_nr( r4, b->Y, b->X );
    block_init
    step_call using fd_f25519_add_nr.call_eq
    name_limbs l2
    step_call using fd_f25519_sub_nr.call_eq
    name_limbs l4
    limbs_stored r2 r4
    clear hbX_read hbY_read hbX hbY
    finish_block
    muls [hread_r2,
      hread_r4](
        block_init
        -- if( !b_is_precomputed ) fd_f25519_mul( r7, r7, fd_f25519_k );
        finish_block
        block_init
        step_call using fd_f25519_mul.call_eq consuming hk_read
        finish_block
        last_close)
  case isFalse =>
    branch hpre
    clear hk_read hk_limbs
    muls [hbX_read, hbY_read, hbX,
      hbY](
        block_init
        -- if( !b_is_precomputed ): not taken
        finish_block
        last_close)

end Proof

end MLIR.Firedancer.Ref
