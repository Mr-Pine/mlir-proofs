module

public import Firedancer.Leaders.Wsample
public import Firedancer.Leaders.Sort

/-! `flamenco/leaders/fd_leaders.{c,h}`: the leader schedule. Memory is modelled only through
the addresses `fd_epoch_leaders_new` checks and the arrays its pointers point to. -/

namespace Firedancer.Leaders

@[expose] public section

/-- `MAX_SLOTS_PER_EPOCH` (`flamenco/leaders/fd_leaders_base.h:9`). -/
def MAX_SLOTS_PER_EPOCH : BitVec 64 := 432000#64

/-- `FD_EPOCH_SLOTS_PER_ROTATION` (`flamenco/leaders/fd_leaders.h:57`). -/
def FD_EPOCH_SLOTS_PER_ROTATION : BitVec 64 := 4#64

/-- `FD_EPOCH_LEADERS_ALIGN` (`flamenco/leaders/fd_leaders.h:42`). -/
def FD_EPOCH_LEADERS_ALIGN : BitVec 64 := 64#64

/-- `UINT_MAX`. -/
def UINT_MAX : BitVec 64 := 0xFFFFFFFF#64

/-- `sizeof(fd_epoch_leaders_t)`: eight 8-byte fields. -/
def sizeof_fd_epoch_leaders_t : BitVec 64 := 64#64

/-- `alignof(fd_epoch_leaders_t)`. -/
def alignof_fd_epoch_leaders_t : BitVec 64 := 8#64

/-- `struct fd_epoch_leaders` (`flamenco/leaders/fd_leaders.h:61`), each pointer replaced by
the array it points to. -/
structure fd_epoch_leaders_t where
  epoch : BitVec 64
  slot0 : BitVec 64
  slot_cnt : BitVec 64
  pub : Array fd_pubkey_t
  pub_cnt : BitVec 64
  sched : Array (BitVec 32)
  sched_cnt : BitVec 64
  vote_addr : Array fd_pubkey_t
deriving Repr, DecidableEq, Inhabited

/-- `FD_LAYOUT_APPEND` (`util/bits/fd_bits.h:968`). -/
def FD_LAYOUT_APPEND (l a s : BitVec 64) : BitVec 64 := FD_ULONG_ALIGN_UP l a + s

/-- `FD_EPOCH_LEADERS_FOOTPRINT` (`flamenco/leaders/fd_leaders.h:43`); `FD_ULONG_MAX` of
non-constants is `fd_ulong_max`. -/
def FD_EPOCH_LEADERS_FOOTPRINT (pub_cnt slot_cnt : BitVec 64) : BitVec 64 :=
  let rot := (slot_cnt + FD_EPOCH_SLOTS_PER_ROTATION - 1#64) / FD_EPOCH_SLOTS_PER_ROTATION
  FD_ULONG_ALIGN_UP
      (FD_LAYOUT_APPEND (FD_LAYOUT_APPEND (FD_LAYOUT_APPEND 0#64
        alignof_fd_epoch_leaders_t sizeof_fd_epoch_leaders_t) 4#64 (rot * 4#64)) 32#64
        (rot * 32#64))
      FD_EPOCH_LEADERS_ALIGN +
    FD_ULONG_ALIGN_UP (fd_ulong_max.spec (32#64 * pub_cnt) (FD_WSAMPLE_FOOTPRINT pub_cnt false))
      64#64

/-- `fd_epoch_leaders_footprint` (`flamenco/leaders/fd_leaders.c:68`). -/
def fd_epoch_leaders_footprint.spec (pub_cnt slot_cnt : BitVec 64) : BitVec 64 :=
  if pub_cnt = 0#64 ∨ pub_cnt > UINT_MAX - 3#64 ∨ slot_cnt = 0#64 then 0#64
  else FD_EPOCH_LEADERS_FOOTPRINT pub_cnt slot_cnt

/-- What `fd_epoch_leaders_new` does: returns `NULL`, exits (`FD_LOG_ERR`/`FD_TEST`), reads
past `stakes` (`ub`), runs out of roll fuel, or returns `shmem` holding `leaders`. -/
inductive fd_epoch_leaders_new.Result where
  | null
  | logErr
  | ub
  | outOfFuel
  | ok (leaders : fd_epoch_leaders_t)
deriving Repr, DecidableEq

/-- `for( ulong i=0UL; i<pub_cnt; i++ ) _wsample = fd_wsample_new_add( _wsample, stakes[i].stake );`
(`flamenco/leaders/fd_leaders.c:150`); `none` = a read past `stakes`. -/
def fd_epoch_leaders_new.add_loop (stakes : Array fd_vote_stake_weight_t) (pub_cnt : Nat)
    (ws : Option fd_wsample_t) (i : Nat) : Option (Option fd_wsample_t) :=
  if i < pub_cnt then
    match stakes[i]? with
    | none => none
    | some s => fd_epoch_leaders_new.add_loop stakes pub_cnt (fd_wsample_new_add.spec ws s.stake)
        (i + 1)
  else some ws
termination_by pub_cnt - i

/-- `for( ulong i=0UL; i<sched_cnt; i++ ) sched[ i ] = (uint)fd_wsample_sample( wsample );`
(`flamenco/leaders/fd_leaders.c:155`). -/
def fd_epoch_leaders_new.sample_loop (fuel : Nat) (wsample : fd_wsample_t) (sched_cnt : Nat)
    (sched : Array (BitVec 32)) (rng : fd_chacha_rng_t) (i : Nat) :
    Fueled (Array (BitVec 32) × fd_chacha_rng_t) :=
  if i < sched_cnt then
    match fd_wsample_sample.spec fuel wsample rng with
    | .outOfFuel => .outOfFuel
    | .done (r, rng) =>
      fd_epoch_leaders_new.sample_loop fuel wsample sched_cnt (sched.push (r.setWidth 32)) rng
        (i + 1)
  else .done (sched, rng)
termination_by sched_cnt - i

/-- `fd_epoch_leaders_new` (`flamenco/leaders/fd_leaders.c:78`) at address `shmem`, with `fuel`
iterations per roll; `stakes` is the caller's array. -/
def fd_epoch_leaders_new.spec (fuel : Nat) (shmem epoch slot0 slot_cnt pub_cnt : BitVec 64)
    (stakes : Array fd_vote_stake_weight_t) : fd_epoch_leaders_new.Result :=
  if shmem = 0#64 then .null else
  let laddr := shmem
  if fd_ulong_is_aligned.spec laddr FD_EPOCH_LEADERS_ALIGN = 0#32 then .null else
  if pub_cnt = 0#64 then .null else
  if slot_cnt > MAX_SLOTS_PER_EPOCH then .logErr else
  let sched_cnt :=
    (slot_cnt + FD_EPOCH_SLOTS_PER_ROTATION - 1#64) / FD_EPOCH_SLOTS_PER_ROTATION
  let laddr := laddr + sizeof_fd_epoch_leaders_t
  let laddr := fd_ulong_align_up.spec laddr 4#64
  let laddr := laddr + 4#64 * sched_cnt
  let laddr := fd_ulong_align_up.spec laddr 32#64
  let laddr := laddr + 32#64 * sched_cnt
  let laddr := fd_ulong_align_up.spec laddr (fd_ulong_max.spec 32#64 FD_WSAMPLE_ALIGN)
  let wsample_mem := laddr
  if ¬(laddr + fd_wsample_footprint.spec pub_cnt 0#32 ≤
      wsample_mem + fd_epoch_leaders_footprint.spec pub_cnt slot_cnt) then .logErr else
  -- `fd_chacha_rng_new( _rng, FD_CHACHA_RNG_MODE_MOD )` succeeds on the stack `_rng`.
  match fd_chacha_rng_new.spec FD_CHACHA_RNG_MODE_MOD with
  | none => .logErr  -- unreachable: MODE_MOD is valid (the C would deref `NULL`)
  | some rng =>
  let key : Vector (BitVec 8) 32 :=
    storeBytes (Vector.replicate 32 0#8) 0
      (#v[epoch.extractLsb' 0 8, epoch.extractLsb' 8 8, epoch.extractLsb' 16 8,
          epoch.extractLsb' 24 8, epoch.extractLsb' 32 8, epoch.extractLsb' 40 8,
          epoch.extractLsb' 48 8, epoch.extractLsb' 56 8] : Vector (BitVec 8) 8)
  let rng := fd_chacha_rng_init.spec rng key FD_CHACHA_RNG_ALGO_CHACHA20
  let _wsample :=
    fd_wsample_new_init.spec wsample_mem pub_cnt 0#32 FD_WSAMPLE_HINT_POWERLAW_NOREMOVE
  match fd_epoch_leaders_new.add_loop stakes pub_cnt.toNat _wsample 0 with
  | none => .ub
  | some _wsample =>
  match fd_wsample_join.spec wsample_mem (fd_wsample_new_fini.spec _wsample 0#64) with
  | none => .logErr
  | some wsample =>
  match fd_epoch_leaders_new.sample_loop fuel wsample sched_cnt.toNat #[] rng 0 with
  | .outOfFuel => .outOfFuel
  | .done (sched, _rng) =>
  -- `pubkeys` aliases `wsample_mem`; written only after the last sample.
  let pubkeys : Array fd_pubkey_t := (Array.range pub_cnt.toNat).map fun i => stakes[i]!.id_key
  if sched.any (fun s => s.toNat ≥ stakes.size) then .ub else
  let vote_addr : Array fd_pubkey_t := sched.map fun s => stakes[s.toNat]!.vote_key
  .ok { epoch := epoch, slot0 := slot0, slot_cnt := slot_cnt, pub := pubkeys,
        pub_cnt := pub_cnt, sched := sched, sched_cnt := sched_cnt, vote_addr := vote_addr }

/-- `fd_epoch_leaders_get` (`flamenco/leaders/fd_leaders.h:142`) on a non-`NULL` `leaders`:
the key pointed to, `none` = `NULL`. -/
def fd_epoch_leaders_get.spec (leaders : fd_epoch_leaders_t) (slot : BitVec 64) :
    Option fd_pubkey_t :=
  let slot_delta := slot - leaders.slot0
  if slot < leaders.slot0 then none
  else if slot_delta ≥ leaders.slot_cnt then none
  else some leaders.pub[(leaders.sched[(slot_delta / FD_EPOCH_SLOTS_PER_ROTATION).toNat]!).toNat]!

/-- `fd_epoch_leaders_get_vote` (`flamenco/leaders/fd_leaders.h:156`) on a non-`NULL`
`leaders`: the key pointed to, `none` = `NULL`. -/
def fd_epoch_leaders_get_vote.spec (leaders : fd_epoch_leaders_t) (slot : BitVec 64) :
    Option fd_pubkey_t :=
  let slot_delta := slot - leaders.slot0
  if slot < leaders.slot0 then none
  else if slot_delta ≥ leaders.slot_cnt then none
  else some leaders.vote_addr[(slot_delta / FD_EPOCH_SLOTS_PER_ROTATION).toNat]!

end

end Firedancer.Leaders
