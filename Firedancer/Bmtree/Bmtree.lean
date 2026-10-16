module

public import Firedancer.Bmtree.Sha256

/-! `ballet/bmtree/fd_bmtree.c`: leaf/branch hashing, depth and node counts, the leaf-based
commit (`commit_init/append/fini`, the batch layer path), proofs (`get_proof`,
`from_proof`) and the proof-based commit (`commitp_insert_with_proof`, `commitp_fini`). -/

namespace Firedancer.Bmtree

@[expose] public section

/-! ## Constants and layout -/

/-- `fd_bmtree_node_t` (`ballet/bmtree/fd_bmtree.h:149`): `uchar hash[32]`. -/
abbrev fd_bmtree_node_t := Vector (BitVec 8) 32

/-- `FD_BMTREE_LONG_PREFIX_SZ` (`fd_bmtree.h:139`). -/
def FD_BMTREE_LONG_PREFIX_SZ : BitVec 64 := 26#64

/-- `FD_BMTREE_SHORT_PREFIX_SZ` (`fd_bmtree.h:140`). -/
def FD_BMTREE_SHORT_PREFIX_SZ : BitVec 64 := 1#64

/-- `fd_bmtree_leaf_prefix` (`fd_bmtree.h:141`): `"\x00SOLANA_MERKLE_SHREDS_LEAF"`, zero-padded. -/
def fd_bmtree_leaf_prefix : Vector (BitVec 8) 32 := #v[
  0x00#8, 0x53#8, 0x4f#8, 0x4c#8, 0x41#8, 0x4e#8, 0x41#8, 0x5f#8, 0x4d#8, 0x45#8, 0x52#8,
  0x4b#8, 0x4c#8, 0x45#8, 0x5f#8, 0x53#8, 0x48#8, 0x52#8, 0x45#8, 0x44#8, 0x53#8, 0x5f#8,
  0x4c#8, 0x45#8, 0x41#8, 0x46#8, 0x00#8, 0x00#8, 0x00#8, 0x00#8, 0x00#8, 0x00#8]

/-- `fd_bmtree_node_prefix` (`fd_bmtree.h:142`): `"\x01SOLANA_MERKLE_SHREDS_NODE"`, zero-padded. -/
def fd_bmtree_node_prefix : Vector (BitVec 8) 32 := #v[
  0x01#8, 0x53#8, 0x4f#8, 0x4c#8, 0x41#8, 0x4e#8, 0x41#8, 0x5f#8, 0x4d#8, 0x45#8, 0x52#8,
  0x4b#8, 0x4c#8, 0x45#8, 0x5f#8, 0x53#8, 0x48#8, 0x52#8, 0x45#8, 0x44#8, 0x53#8, 0x5f#8,
  0x4e#8, 0x4f#8, 0x44#8, 0x45#8, 0x00#8, 0x00#8, 0x00#8, 0x00#8, 0x00#8, 0x00#8]

/-- `FD_BMTREE_COMMIT_ALIGN` (`fd_bmtree.h:304`). -/
def FD_BMTREE_COMMIT_ALIGN : BitVec 64 := 32#64

/-- `FD_BMTREE_PRIVATE_BATCH_LEAF_MAX` (`fd_bmtree.c:219`). -/
def FD_BMTREE_PRIVATE_BATCH_LEAF_MAX : BitVec 64 := 64#64

/-- `sizeof(fd_bmtree_commit_t)`: 4 `ulong`s, `node_buf[63]`, a pointer, `inclusion_proofs[1]`. -/
def sizeof_fd_bmtree_commit_t : BitVec 64 := 2088#64

/-- `offsetof(fd_bmtree_commit_t, inclusion_proofs)`. -/
def offsetof_inclusion_proofs : Nat := 2056

/-- `ipfset_MAX` (`util/tmpl/fd_smallset.c:144`). -/
def ipfset_MAX : BitVec 64 := 64#64

/-- `fd_bmtree_commit_t` (`fd_bmtree.h:189`). `ip_mem` is the caller's region from
`&inclusion_proofs[0]` to its end (node `k` at byte `32k`); `inclusion_proofs_valid` is the
bitmap's byte offset in it, so the dummy node `inclusion_proofs[inclusion_proof_sz]` and the
bitmap share bytes as in C. -/
structure fd_bmtree_commit_t where
  leaf_cnt : BitVec 64
  hash_sz : BitVec 64
  prefix_sz : BitVec 64
  inclusion_proof_sz : BitVec 64
  node_buf : Vector fd_bmtree_node_t 63
  inclusion_proofs_valid : Nat
  ip_mem : Array (BitVec 8)
deriving Repr, DecidableEq, Inhabited

/-! ## State accesses -/

/-- `state->node_buf[ layer ]`; `ub` past `node_buf[62]`. -/
def node_buf_get (s : fd_bmtree_commit_t) (layer : Nat) (site : String) :
    Outcome fd_bmtree_node_t :=
  if h : layer < 63 then .ok s.node_buf[layer] else .ub site

/-- `state->node_buf[ layer ] = v`; `ub` past `node_buf[62]`. -/
def node_buf_set (s : fd_bmtree_commit_t) (layer : Nat) (v : fd_bmtree_node_t) (site : String) :
    Outcome fd_bmtree_commit_t :=
  if h : layer < 63 then .ok { s with node_buf := s.node_buf.set layer v } else .ub site

/-- `state->inclusion_proofs[ k ]` (a 32-byte copy). -/
def ip_get (s : fd_bmtree_commit_t) (k : BitVec 64) (site : String) :
    Outcome fd_bmtree_node_t := do
  let b ← readBytes s.ip_mem (32 * k.toNat) 32 site
  pure (Vector.ofFn fun i => b[i.val]!)

/-- `state->inclusion_proofs[ k ] = v`. -/
def ip_set (s : fd_bmtree_commit_t) (k : BitVec 64) (v : fd_bmtree_node_t) (site : String) :
    Outcome fd_bmtree_commit_t := do
  let ip_mem ← writeBytes s.ip_mem (32 * k.toNat) v.toArray site
  pure { s with ip_mem }

/-- The first `hash_sz` bytes of `n` (`ub` if `hash_sz > 32`). -/
def node_hash (n : fd_bmtree_node_t) (hash_sz : BitVec 64) : Outcome (Array (BitVec 8)) :=
  if hash_sz ≤ 32#64 then .ok (n.toArray.extract 0 hash_sz.toNat) else .ub "hash_sz > 32"

/-- The first `hash_sz` bytes of `state->inclusion_proofs[ k ].hash` (`ub` if `hash_sz > 32`). -/
def ip_hash (s : fd_bmtree_commit_t) (k hash_sz : BitVec 64) (site : String) :
    Outcome (Array (BitVec 8)) :=
  if hash_sz ≤ 32#64 then readBytes s.ip_mem (32 * k.toNat) hash_sz.toNat site
  else .ub "hash_sz > 32"

/-- `n` after `memcpy( n.hash, src, src.size )`, `src.size ≤ 32`. -/
def node_store (n : fd_bmtree_node_t) (src : Array (BitVec 8)) : fd_bmtree_node_t :=
  Vector.ofFn fun i => if i.val < src.size then src[i.val]! else n[i]

/-- An uninitialized local node. Its bytes are never read before written. -/
def node_uninit : fd_bmtree_node_t := Vector.replicate 32 0#8

/-- `HAS(idx)` (`fd_bmtree.c:454`): `ipfset_test( inclusion_proofs_valid[idx/64], idx%64 )`. -/
def HAS (s : fd_bmtree_commit_t) (idx : BitVec 64) : Outcome Bool := do
  let w ← loadULong s.ip_mem (s.inclusion_proofs_valid + 8 * (idx / 64#64).toNat)
    "HAS: bitmap word past the region"
  pure ((w >>> (idx % 64#64).toNat) &&& 1#64 == 1#64)

/-- `state->inclusion_proofs_valid[idx/64UL] |= ipfset_ele( idx%64UL )`. -/
def set_valid (s : fd_bmtree_commit_t) (idx : BitVec 64) : Outcome fd_bmtree_commit_t := do
  let off := s.inclusion_proofs_valid + 8 * (idx / 64#64).toNat
  let w ← loadULong s.ip_mem off "set_valid: bitmap word past the region"
  let ip_mem ← storeULong s.ip_mem off (w ||| (1#64 <<< (idx % 64#64).toNat))
    "set_valid: bitmap word past the region"
  pure { s with ip_mem }

/-- `(layer_cnt<<(layer+1UL)) - (1UL<<layer) - 1UL`: the last node of a layer. -/
def last_idx (layer_cnt layer : BitVec 64) : Outcome (BitVec 64) := do
  let a ← shl layer_cnt (layer + 1#64) "layer_cnt<<(layer+1UL)"
  let b ← shl 1#64 layer "1UL<<layer"
  pure (a - b - 1#64)

/-- `(int)layer + k` for a small `layer`. -/
def int_of (layer : Nat) (k : BitVec 32) : BitVec 32 := BitVec.ofNat 32 layer + k

/-! ## Hashing -/

/-- `fd_bmtree_hash_leaf` (`fd_bmtree.c:51`): `SHA-256(leaf_prefix[0,prefix_sz) | data[0,data_sz))`
as the node written. -/
def fd_bmtree_hash_leaf.spec (sha : Sha256) (data : Array (BitVec 8)) (data_sz prefix_sz : BitVec 64) :
    Outcome fd_bmtree_node_t := do
  let pre ← readBytes fd_bmtree_leaf_prefix.toArray 0 prefix_sz.toNat
    "fd_bmtree_hash_leaf: prefix_sz > 32"
  let d ← readBytes data 0 data_sz.toNat "fd_bmtree_hash_leaf: data past the buffer"
  pure (sha.hash (pre ++ d))

/-- `fd_bmtree_private_merge` (`fd_bmtree.c:78`, non-AVX branch :135):
`SHA-256(node_prefix[0,prefix_sz) | a[0,hash_sz) | b[0,hash_sz))`. -/
def fd_bmtree_private_merge.spec (sha : Sha256) (a b : fd_bmtree_node_t) (hash_sz prefix_sz : BitVec 64) :
    Outcome fd_bmtree_node_t := do
  let pre ← readBytes fd_bmtree_node_prefix.toArray 0 prefix_sz.toNat
    "fd_bmtree_private_merge: prefix_sz > 32"
  let ah ← node_hash a hash_sz
  let bh ← node_hash b hash_sz
  pure (sha.hash (pre ++ ah ++ bh))

/-! ## Sizes -/

/-- `fd_bmtree_depth` (`fd_bmtree.c:147`). -/
def fd_bmtree_depth.spec (leaf_cnt : BitVec 64) : BitVec 64 :=
  fd_ulong_if (leaf_cnt ≤ 1#64) leaf_cnt
    ((fd_ulong_find_msb_w_default (leaf_cnt - 1#64) (-1#32)).signExtend 64 + 2#64)

/-- `fd_bmtree_node_cnt` (`fd_bmtree.c:156`). -/
def fd_bmtree_node_cnt.spec (leaf_cnt : BitVec 64) : BitVec 64 := Id.run do
  if leaf_cnt = 0#64 then return 0#64
  let mut cnt := 0#64
  let leaf_cnt := leaf_cnt - 1#64
  for i in [0:64] do
    let term := leaf_cnt >>> i
    cnt := cnt + term
  cnt := cnt + (2#32 + fd_ulong_find_msb_w_default leaf_cnt (-1#32)).signExtend 64
  return cnt

/-- `fd_bmtree_commit_align` (`fd_bmtree.c:179`). -/
def fd_bmtree_commit_align.spec : BitVec 64 := FD_BMTREE_COMMIT_ALIGN

/-- `fd_bmtree_commit_footprint` (`fd_bmtree.c:182`). -/
def fd_bmtree_commit_footprint.spec (inclusion_proof_layer_cnt : BitVec 64) :
    Outcome (BitVec 64) := do
  let p ← shl 1#64 inclusion_proof_layer_cnt "fd_bmtree_commit_footprint: 1UL<<64"
  pure (fd_ulong_align_up (sizeof_fd_bmtree_commit_t + (p - 1#64) * 32#64 +
    ((p + 63#64) / 64#64) * 8#64) fd_bmtree_commit_align.spec)

/-- `FD_BMTREE_COMMIT_FOOTPRINT` (`fd_bmtree.h:301`). -/
def FD_BMTREE_COMMIT_FOOTPRINT (inclusion_proof_layer_cnt : BitVec 64) : Outcome (BitVec 64) := do
  let p ← shl 1#64 inclusion_proof_layer_cnt "FD_BMTREE_COMMIT_FOOTPRINT: 1UL<<64"
  pure (((sizeof_fd_bmtree_commit_t + (p - 1#64) * 32#64 + (p + 63#64) / 64#64 * 8#64) +
    31#64) / 32#64 * 32#64)

/-- `fd_bmtree_commit_leaf_cnt` (`fd_bmtree.h:336`). -/
def fd_bmtree_commit_leaf_cnt.spec (bmt : fd_bmtree_commit_t) : BitVec 64 := bmt.leaf_cnt

/-! ## Leaf-based commit -/

/-- `fd_bmtree_commit_init` (`fd_bmtree.c:196`): `mem` is the region before the call; only the
header fields and the bitmap are written. -/
def fd_bmtree_commit_init.spec (mem : fd_bmtree_commit_t)
    (hash_sz prefix_sz inclusion_proof_layer_cnt : BitVec 64) : Outcome fd_bmtree_commit_t := do
  let p ← shl 1#64 inclusion_proof_layer_cnt "fd_bmtree_commit_init: 1UL<<64"
  let inclusion_proof_sz := p - 1#64
  let state := { mem with
    leaf_cnt := 0#64, hash_sz, prefix_sz, inclusion_proof_sz,
    inclusion_proofs_valid := 32 * inclusion_proof_sz.toNat }
  let ip_mem ← zeroBytes state.ip_mem state.inclusion_proofs_valid
    (8#64 * (1#64 + inclusion_proof_sz / ipfset_MAX)).toNat
    "fd_bmtree_commit_init: bitmap past the region"
  pure { state with ip_mem }

/-- The `p` loop of one batch chunk (`fd_bmtree.c:248-260`): fill `msg[p-p0]`, queue it for
`next[p]`. -/
def fd_bmtree_private_commit_batch.add (cur : Array fd_bmtree_node_t)
    (prefix_sz hash_sz msg_sz : BitVec 64) (p0 p1 : Nat) (msg : Array (Array (BitVec 8)))
    (batch : fd_sha256_batch_t) : Outcome (Array (Array (BitVec 8)) × fd_sha256_batch_t) := do
  let mut msg := msg
  let mut batch := batch
  for p in [p0:p1] do
    let m ← arrGet msg (p - p0) "batch: msg slot"
    let pre ← readBytes fd_bmtree_node_prefix.toArray 0 prefix_sz.toNat "batch: prefix_sz > 32"
    let m ← writeBytes m 0 pre "batch: msg overflow"
    let a ← node_hash (← arrGet cur (2 * p) "batch: cur") hash_sz
    let m ← writeBytes m prefix_sz.toNat a "batch: msg overflow"
    let b ← node_hash (← arrGet cur (2 * p + 1) "batch: cur") hash_sz
    let m ← writeBytes m (prefix_sz.toNat + hash_sz.toNat) b "batch: msg overflow"
    msg := msg.set! (p - p0) m
    let data ← readBytes m 0 msg_sz.toNat "batch: msg_sz > 96"
    batch := fd_sha256_batch_add batch data p
  return (msg, batch)

/-- The `p0` loop (`fd_bmtree.c:245`): one SHA-256 batch per `FD_SHA256_BATCH_MAX` merges. -/
def fd_bmtree_private_commit_batch.chunks (sha : Sha256) (cur : Array fd_bmtree_node_t)
    (prefix_sz hash_sz msg_sz : BitVec 64) (merge_cnt : Nat) (next : Vector fd_bmtree_node_t 32)
    (msg : Array (Array (BitVec 8))) (p0 : Nat) :
    Outcome (Vector fd_bmtree_node_t 32 × Array (Array (BitVec 8))) :=
  if p0 < merge_cnt then do
    let p1 := min (p0 + sha.batch_max) merge_cnt
    let batch := fd_sha256_batch_init
    let (msg, batch) ← fd_bmtree_private_commit_batch.add cur prefix_sz hash_sz msg_sz p0 p1 msg
      batch
    let next ← fd_sha256_batch_fini sha batch next
    fd_bmtree_private_commit_batch.chunks sha cur prefix_sz hash_sz msg_sz merge_cnt next msg
      (p0 + sha.batch_max)
  else .ok (next, msg)
termination_by merge_cnt - p0
decreasing_by have := sha.batch_max_pos; omega

/-- The `layer` loop (`fd_bmtree.c:242`): `next = lvl[layer&1]`, merge `cur` pairwise into it. -/
def fd_bmtree_private_commit_batch.layers (sha : Sha256) (state : fd_bmtree_commit_t)
    (prefix_sz hash_sz msg_sz ip_sz : BitVec 64) (lvl : Vector (Vector fd_bmtree_node_t 32) 2)
    (msg : Array (Array (BitVec 8))) (cur : Array fd_bmtree_node_t) (cnt : BitVec 64)
    (layer : Nat) : Outcome fd_bmtree_commit_t :=
  if h : cnt ≥ 2#64 then do
    let next := lvl[layer % 2]
    let merge_cnt := cnt >>> 1
    let (next, msg) ← fd_bmtree_private_commit_batch.chunks sha cur prefix_sz hash_sz msg_sz
      merge_cnt.toNat next msg 0
    let lvl := lvl.set (layer % 2) next
    let mut state := state
    for p in [0:merge_cnt.toNat] do
      let a ← shl (BitVec.ofNat 64 p) (BitVec.ofNat 64 layer + 1#64) "batch: p<<(layer+1)"
      let b ← shl 1#64 (BitVec.ofNat 64 layer) "batch: 1<<layer"
      state ← ip_set state (fd_ulong_min (a + b - 1#64) ip_sz)
        (← arrGet next.toArray p "batch: next") "batch: inclusion_proofs past the region"
    state ← node_buf_set state layer
      (← arrGet next.toArray ((merge_cnt - 1#64) &&& ~~~1#64).toNat "batch: next")
      "batch: node_buf[layer]"
    fd_bmtree_private_commit_batch.layers sha state prefix_sz hash_sz msg_sz ip_sz lvl msg
      next.toArray merge_cnt (layer + 1)
  else .ok state
termination_by cnt.toNat
decreasing_by
  simp only [BitVec.le_def] at h
  simp only [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  simp at h
  omega

/-- `fd_bmtree_private_commit_batch` (`fd_bmtree.c:222`). -/
def fd_bmtree_private_commit_batch.spec (sha : Sha256) (state : fd_bmtree_commit_t)
    (leaf : Array fd_bmtree_node_t) (leaf_cnt : BitVec 64) : Outcome fd_bmtree_commit_t := do
  let hash_sz := state.hash_sz
  let prefix_sz := state.prefix_sz
  let ip_sz := state.inclusion_proof_sz
  let msg_sz := prefix_sz + 2#64 * hash_sz
  let mut state := state
  for i in [0:leaf_cnt.toNat] do
    state ← ip_set state (fd_ulong_min (2#64 * BitVec.ofNat 64 i) ip_sz)
      (← arrGet leaf i "batch: leaf past the array") "batch: inclusion_proofs past the region"
  state ← node_buf_set state 0
    (← arrGet leaf ((leaf_cnt - 1#64) &&& ~~~1#64).toNat "batch: leaf past the array")
    "batch: node_buf[0]"
  let lvl : Vector (Vector fd_bmtree_node_t 32) 2 := Vector.replicate 2 (Vector.replicate 32 node_uninit)
  let msg : Array (Array (BitVec 8)) := Array.replicate sha.batch_max (Array.replicate 96 0#8)
  state ← fd_bmtree_private_commit_batch.layers sha state prefix_sz hash_sz msg_sz ip_sz lvl msg
    leaf leaf_cnt 1
  return { state with leaf_cnt }

/-- The `while( !(cursor & 1UL) )` loop of `fd_bmtree_commit_append` (`fd_bmtree.c:314`);
returns `(state, tmp, layer, inc_idx)`. -/
def fd_bmtree_commit_append.walk (sha : Sha256) (state : fd_bmtree_commit_t)
    (tmp : fd_bmtree_node_t) (layer : Nat) (inc_idx cursor : BitVec 64) :
    Outcome (fd_bmtree_commit_t × fd_bmtree_node_t × Nat × BitVec 64) :=
  if cursor &&& 1#64 = 0#64 then
    if layer < 63 then do
      let state ← ip_set state (fd_ulong_min inc_idx state.inclusion_proof_sz) tmp
        "append: inclusion_proofs past the region"
      let nb ← node_buf_get state layer "append: node_buf[layer]"
      let tmp ← fd_bmtree_private_merge.spec sha nb tmp state.hash_sz state.prefix_sz
      let inc_idx := inc_idx - (← shl 1#64 (BitVec.ofNat 64 layer) "append: 1UL<<layer")
      fd_bmtree_commit_append.walk sha state tmp (layer + 1) inc_idx (cursor >>> 1)
    else .ub "append: node_buf[63] (cursor wrapped to 0)"
  else .ok (state, tmp, layer, inc_idx)
termination_by 63 - layer

/-- The `new_leaf_idx` loop of `fd_bmtree_commit_append` (`fd_bmtree.c:288`); returns the
state and the local `leaf_cnt`. -/
def fd_bmtree_commit_append.loop (sha : Sha256) (new_leaf : Array fd_bmtree_node_t)
    (new_leaf_cnt : BitVec 64) (state : fd_bmtree_commit_t) (leaf_cnt : BitVec 64)
    (new_leaf_idx : Nat) : Outcome (fd_bmtree_commit_t × BitVec 64) :=
  if new_leaf_idx < new_leaf_cnt.toNat then do
    let tmp ← arrGet new_leaf new_leaf_idx "append: new_leaf past the array"
    let layer := 0
    let inc_idx := 2#64 * leaf_cnt
    let leaf_cnt := leaf_cnt + 1#64
    let cursor := leaf_cnt
    let (state, tmp, layer, inc_idx) ←
      fd_bmtree_commit_append.walk sha state tmp layer inc_idx cursor
    let state ← node_buf_set state layer tmp "append: node_buf[layer]"
    let state ← ip_set state (fd_ulong_min inc_idx state.inclusion_proof_sz) tmp
      "append: inclusion_proofs past the region"
    fd_bmtree_commit_append.loop sha new_leaf new_leaf_cnt state leaf_cnt (new_leaf_idx + 1)
  else .ok (state, leaf_cnt)
termination_by new_leaf_cnt.toNat - new_leaf_idx

/-- `fd_bmtree_commit_append` (`fd_bmtree.c:277`): `new_leaf` holds the caller's leaves. -/
def fd_bmtree_commit_append.spec (sha : Sha256) (state : fd_bmtree_commit_t)
    (new_leaf : Array fd_bmtree_node_t) (new_leaf_cnt : BitVec 64) :
    Outcome fd_bmtree_commit_t := do
  let leaf_cnt := state.leaf_cnt
  if (leaf_cnt = 0#64) ∧ (new_leaf_cnt ≥ 8#64) ∧ (new_leaf_cnt ≤ FD_BMTREE_PRIVATE_BATCH_LEAF_MAX) then
    return ← fd_bmtree_private_commit_batch.spec sha state new_leaf new_leaf_cnt
  let (state, leaf_cnt) ← fd_bmtree_commit_append.loop sha new_leaf new_leaf_cnt state leaf_cnt 0
  return { state with leaf_cnt }

/-- The `while( layer_cnt>1UL )` loop of `fd_bmtree_commit_fini` (`fd_bmtree.c:369`). -/
def fd_bmtree_commit_fini.walk (sha : Sha256) (state : fd_bmtree_commit_t)
    (tmp : fd_bmtree_node_t) (layer : Nat) (layer_cnt : BitVec 64) :
    Outcome (fd_bmtree_commit_t × fd_bmtree_node_t) :=
  if _h : layer_cnt > 1#64 then do
    let tmp2 ← if layer_cnt &&& 1#64 ≠ 0#64 then pure tmp
      else node_buf_get state layer "fini: node_buf[layer]"
    let tmp ← fd_bmtree_private_merge.spec sha tmp2 tmp state.hash_sz state.prefix_sz
    let layer := layer + 1
    let layer_cnt' := (layer_cnt + 1#64) >>> 1
    let inc_idx ← last_idx layer_cnt' (BitVec.ofNat 64 layer)
    let state ← ip_set state (fd_ulong_min inc_idx state.inclusion_proof_sz) tmp
      "fini: inclusion_proofs past the region"
    fd_bmtree_commit_fini.walk sha state tmp layer layer_cnt'
  else .ok (state, tmp)
termination_by layer_cnt.toNat
decreasing_by
  simp only [BitVec.lt_def] at _h
  simp only [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_add]
  have := layer_cnt.isLt
  simp at *
  omega

/-- `fd_bmtree_commit_fini.spec`'s result: the state and the 32 bytes at the returned pointer. -/
structure fd_bmtree_commit_fini.Result where
  state : fd_bmtree_commit_t
  root : fd_bmtree_node_t
deriving Repr, DecidableEq

/-- `fd_bmtree_commit_fini` (`fd_bmtree.c:347`); `leaf_cnt==0` forms `node_buf-1` (`ub`). -/
def fd_bmtree_commit_fini.spec (sha : Sha256) (state : fd_bmtree_commit_t) :
    Outcome fd_bmtree_commit_fini.Result := do
  let leaf_cnt := state.leaf_cnt
  let root := fd_bmtree_depth.spec leaf_cnt - 1#64
  if root > 63#64 then
    return ← .ub "fini: node_buf + (depth-1) out of bounds (leaf_cnt==0: node_buf[-1])"
  let mut state := state
  if !fd_ulong_is_pow2 leaf_cnt then
    let layer := (← fd_ulong_find_lsb leaf_cnt).signExtend 64
    let layer_cnt ← shr leaf_cnt layer "fini: leaf_cnt>>layer"
    let _inc_idx ← last_idx layer_cnt layer
    let tmp ← node_buf_get state layer.toNat "fini: node_buf[layer]"
    let (state', tmp) ← fd_bmtree_commit_fini.walk sha state tmp layer.toNat layer_cnt
    state ← node_buf_set state' root.toNat tmp "fini: *root (node_buf[63])"
  let r ← node_buf_get state root.toNat "fini: root->hash (node_buf[63])"
  return { state, root := r }

/-! ## Proofs -/

/-- `fd_bmtree_get_proof.spec`'s result: the `int` returned and `dest` after the call. -/
structure fd_bmtree_get_proof.Result where
  ret : BitVec 32
  dest : Array (BitVec 8)
deriving Repr, DecidableEq

/-- The `while( layer_cnt>1UL )` loop of `fd_bmtree_get_proof` (`fd_bmtree.c:403`). -/
def fd_bmtree_get_proof.walk (state : fd_bmtree_commit_t) (leaf_cnt hash_sz : BitVec 64)
    (dest : Array (BitVec 8)) (inc_idx : BitVec 64) (layer : Nat) (layer_cnt : BitVec 64) :
    Outcome fd_bmtree_get_proof.Result :=
  if _h : layer_cnt > 1#64 then do
    let sibling_idx := inc_idx ^^^ (← shl 1#64 (BitVec.ofNat 64 layer + 1#64)
      "get_proof: 1UL<<(layer+1)")
    let max_idx_for_layer := fd_ulong_insert_lsb ((leaf_cnt - 1#64) <<< 1) (int_of layer 1#32)
      ((← shl 1#64 (BitVec.ofNat 64 layer) "get_proof: 1UL<<layer") - 1#64)
    let sibling_idx := fd_ulong_if (sibling_idx > max_idx_for_layer) inc_idx sibling_idx
    if sibling_idx ≥ state.inclusion_proof_sz then
      return { ret := -1#32, dest }
    let src ← readBytes state.ip_mem (32 * sibling_idx.toNat) hash_sz.toNat
      "get_proof: inclusion_proofs past the region"
    let dest ← writeBytes dest (BitVec.ofNat 64 layer * hash_sz).toNat src
      "get_proof: dest past the buffer"
    let layer := layer + 1
    let layer_cnt' := (layer_cnt + 1#64) >>> 1
    let inc_idx := fd_ulong_insert_lsb inc_idx (int_of layer 1#32)
      ((← shl 1#64 (BitVec.ofNat 64 layer) "get_proof: 1UL<<layer") - 1#64)
    fd_bmtree_get_proof.walk state leaf_cnt hash_sz dest inc_idx layer layer_cnt'
  else .ok { ret := BitVec.ofNat 32 layer, dest }
termination_by layer_cnt.toNat
decreasing_by
  simp only [BitVec.lt_def] at _h
  simp only [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_add]
  have := layer_cnt.isLt
  simp at *
  omega

/-- `fd_bmtree_get_proof` (`fd_bmtree.c:387`): `dest` is the caller's buffer. -/
def fd_bmtree_get_proof.spec (state : fd_bmtree_commit_t) (dest : Array (BitVec 8))
    (leaf_idx : BitVec 64) : Outcome fd_bmtree_get_proof.Result :=
  let leaf_cnt := state.leaf_cnt
  let hash_sz := state.hash_sz
  if leaf_idx ≥ leaf_cnt then .ok { ret := 0#32, dest }
  else
    let inc_idx := leaf_idx * 2#64
    let layer := 0
    let layer_cnt := state.leaf_cnt
    fd_bmtree_get_proof.walk state leaf_cnt hash_sz dest inc_idx layer layer_cnt

/-- The `layer` loop of `fd_bmtree_from_proof` (`fd_bmtree.c:439`); `tmp1` keeps its bytes
past `hash_sz` between iterations, as in C. -/
def fd_bmtree_from_proof.loop (sha : Sha256) (proof : Array (BitVec 8))
    (proof_depth hash_sz prefix_sz : BitVec 64) (tmp0 tmp1 : fd_bmtree_node_t) (inc_idx : BitVec 64)
    (layer : Nat) : Outcome fd_bmtree_node_t :=
  if layer < proof_depth.toNat then do
    if hash_sz > 32#64 then return ← .ub "from_proof: memcpy into tmp+1, hash_sz > 32"
    let src ← readBytes proof (BitVec.ofNat 64 layer * hash_sz).toNat hash_sz.toNat
      "from_proof: proof past the buffer"
    let tmp1 := node_store tmp1 src
    let bit ← shl 1#64 (BitVec.ofNat 64 layer + 1#64) "from_proof: 1UL<<(layer+1UL)"
    let left := 0#64 = inc_idx &&& bit
    let tmp_l := if left then tmp0 else tmp1
    let tmp_r := if left then tmp1 else tmp0
    let tmp0 ← fd_bmtree_private_merge.spec sha tmp_l tmp_r hash_sz prefix_sz
    let inc_idx := fd_ulong_insert_lsb inc_idx (int_of layer 2#32)
      ((← shl 2#64 (BitVec.ofNat 64 layer) "from_proof: 2UL<<layer") - 1#64)
    fd_bmtree_from_proof.loop sha proof proof_depth hash_sz prefix_sz tmp0 tmp1 inc_idx (layer + 1)
  else .ok tmp0
termination_by proof_depth.toNat - layer

/-- `fd_bmtree_from_proof` (`fd_bmtree.c:423`): the 32 bytes stored to `root`, or `none`
(`NULL`, `root` untouched). -/
def fd_bmtree_from_proof.spec (sha : Sha256) (leaf : fd_bmtree_node_t) (leaf_idx : BitVec 64)
    (proof : Array (BitVec 8)) (proof_depth hash_sz prefix_sz : BitVec 64) :
    Outcome (Option fd_bmtree_node_t) := do
  let tmp0 := leaf
  if proof_depth < fd_bmtree_depth.spec (leaf_idx + 1#64) - 1#64 then return none
  let inc_idx := leaf_idx * 2#64
  let tmp0 ← fd_bmtree_from_proof.loop sha proof proof_depth hash_sz prefix_sz tmp0 node_uninit
    inc_idx 0
  return some tmp0

/-! ## Proof-based commit -/

/-- `fd_bmtree_commitp_insert_with_proof.spec`'s result: the `int` returned, the state, and
what was stored to `*opt_root`. -/
structure fd_bmtree_commitp_insert_with_proof.Result where
  ret : BitVec 32
  state : fd_bmtree_commit_t
  opt_root : Option fd_bmtree_node_t
deriving Repr, DecidableEq

/-- The `layer<proof_depth` loop (`fd_bmtree.c:478`): `none` is `return 0`. -/
def fd_bmtree_commitp_insert_with_proof.proof_loop (sha : Sha256) (proof : Array (BitVec 8))
    (proof_depth hash_sz : BitVec 64) (state : fd_bmtree_commit_t) (inc_idx : BitVec 64)
    (layer : Nat) : Outcome (fd_bmtree_commit_t × Option (Nat × BitVec 64)) :=
  if layer < proof_depth.toNat then do
    let bit ← shl 2#64 (BitVec.ofNat 64 layer) "commitp_insert: 2UL<<layer"
    let sibling_idx := inc_idx ^^^ bit
    let proof_off := (hash_sz * BitVec.ofNat 64 layer).toNat
    if ← HAS state sibling_idx then
      let p ← readBytes proof proof_off hash_sz.toNat "commitp_insert: proof past the buffer"
      if !fd_memeq p (← ip_hash state sibling_idx hash_sz "commitp_insert: inclusion_proofs") then
        return (state, none)
    if ← HAS state inc_idx then
      let n ← node_hash (← node_buf_get state layer "commitp_insert: node_buf[layer]") hash_sz
      if !fd_memeq n (← ip_hash state inc_idx hash_sz "commitp_insert: inclusion_proofs") then
        return (state, none)
    let parent_idx := fd_ulong_insert_lsb inc_idx (int_of layer 2#32) (bit - 1#64)
    let hs ← HAS state sibling_idx
    let hi ← HAS state inc_idx
    let state ← if hs && hi then do
        node_buf_set state (layer + 1)
          (← ip_get state parent_idx "commitp_insert: inclusion_proofs")
          "commitp_insert: node_buf[layer+1]"
      else do
        let p ← readBytes proof proof_off hash_sz.toNat "commitp_insert: proof past the buffer"
        if hash_sz > 32#64 then return ← .ub "commitp_insert: memcpy into sibling, hash_sz > 32"
        let sibling := node_store node_uninit p
        let nb ← node_buf_get state layer "commitp_insert: node_buf[layer]"
        let left := 0#64 = inc_idx &&& bit
        let tmp_l := if left then nb else sibling
        let tmp_r := if left then sibling else nb
        node_buf_set state (layer + 1)
          (← fd_bmtree_private_merge.spec sha tmp_l tmp_r state.hash_sz state.prefix_sz)
          "commitp_insert: node_buf[layer+1]"
    fd_bmtree_commitp_insert_with_proof.proof_loop sha proof proof_depth hash_sz state parent_idx
      (layer + 1)
  else .ok (state, some (layer, inc_idx))
termination_by proof_depth.toNat - layer

/-- The `layer<63UL` loop (`fd_bmtree.c:501`): derive upward from cached siblings. -/
def fd_bmtree_commitp_insert_with_proof.cache_loop (sha : Sha256) (inclusion_proof_sz : BitVec 64)
    (state : fd_bmtree_commit_t) (inc_idx : BitVec 64) (layer : Nat) :
    Outcome (fd_bmtree_commit_t × Nat × BitVec 64) :=
  if h : layer < 63 then do
    let bit ← shl 2#64 (BitVec.ofNat 64 layer) "commitp_insert: 2UL<<layer"
    if (inc_idx ||| bit) ≥ inclusion_proof_sz then return (state, layer, inc_idx)
    let h1 ← HAS state inc_idx
    let h2 ← HAS state (inc_idx ^^^ bit)
    if h1 || !h2 then return (state, layer, inc_idx)
    let sibling ← ip_get state (inc_idx ^^^ bit) "commitp_insert: inclusion_proofs"
    let nb ← node_buf_get state layer "commitp_insert: node_buf[layer]"
    let left := 0#64 = inc_idx &&& bit
    let tmp_l := if left then nb else sibling
    let tmp_r := if left then sibling else nb
    let state ← node_buf_set state (layer + 1)
      (← fd_bmtree_private_merge.spec sha tmp_l tmp_r state.hash_sz state.prefix_sz)
      "commitp_insert: node_buf[layer+1]"
    let inc_idx := fd_ulong_insert_lsb inc_idx (int_of layer 2#32) (bit - 1#64)
    fd_bmtree_commitp_insert_with_proof.cache_loop sha inclusion_proof_sz state inc_idx (layer + 1)
  else .ok (state, layer, inc_idx)
termination_by 63 - layer

/-- `fd_bmtree_commitp_insert_with_proof` (`fd_bmtree.c:457`): `proof` is the caller's
buffer (`NULL` = empty), `opt_root` whether `opt_root!=NULL`. -/
def fd_bmtree_commitp_insert_with_proof.spec (sha : Sha256) (state : fd_bmtree_commit_t)
    (idx : BitVec 64) (new_leaf : fd_bmtree_node_t) (proof : Array (BitVec 8))
    (proof_depth : BitVec 64) (opt_root : Bool) :
    Outcome fd_bmtree_commitp_insert_with_proof.Result := do
  let inc_idx := 2#64 * idx
  let inclusion_proof_sz := state.inclusion_proof_sz
  let hash_sz := state.hash_sz
  let fail (s : fd_bmtree_commit_t) : fd_bmtree_commitp_insert_with_proof.Result :=
    { ret := 0#32, state := s, opt_root := none }
  if inc_idx ≥ inclusion_proof_sz then return fail state
  if proof_depth > 63#64 then return fail state
  if (← shl 1#64 proof_depth "commitp_insert: 1UL<<proof_depth") - 1#64 ≥ inclusion_proof_sz then
    return fail state
  let state ← node_buf_set state 0 new_leaf "commitp_insert: node_buf[0]"
  let (state, r) ← fd_bmtree_commitp_insert_with_proof.proof_loop sha proof proof_depth hash_sz
    state inc_idx 0
  let some (layer, inc_idx) := r | return fail state
  let (state, layer, inc_idx) ← fd_bmtree_commitp_insert_with_proof.cache_loop sha
    inclusion_proof_sz state inc_idx layer
  if ← HAS state inc_idx then
    let n ← node_hash (← node_buf_get state layer "commitp_insert: node_buf[layer]") state.hash_sz
    if !fd_memeq n (← ip_hash state inc_idx state.hash_sz "commitp_insert: inclusion_proofs") then
      return fail state
  let mut state := state
  let mut inc_idx := 2#64 * idx
  for i in [0:layer + 1] do
    state ← ip_set state inc_idx (← node_buf_get state i "commitp_insert: node_buf[i]")
      "commitp_insert: inclusion_proofs past the region"
    state ← set_valid state inc_idx
    inc_idx := fd_ulong_insert_lsb inc_idx (int_of i 2#32)
      ((← shl 2#64 (BitVec.ofNat 64 i) "commitp_insert: 2UL<<i") - 1#64)
  inc_idx := 2#64 * idx
  for i in [0:proof_depth.toNat] do
    let bit ← shl 2#64 (BitVec.ofNat 64 i) "commitp_insert: 2UL<<i"
    let sibling_idx := inc_idx ^^^ bit
    let p ← readBytes proof (hash_sz * BitVec.ofNat 64 i).toNat hash_sz.toNat
      "commitp_insert: proof past the buffer"
    if hash_sz > 32#64 then return ← .ub "commitp_insert: memcpy into inclusion_proofs, hash_sz > 32"
    let ip_mem ← writeBytes state.ip_mem (32 * sibling_idx.toNat) p
      "commitp_insert: inclusion_proofs past the region"
    state := { state with ip_mem }
    state ← set_valid state sibling_idx
    inc_idx := fd_ulong_insert_lsb inc_idx (int_of i 2#32) (bit - 1#64)
  let opt_root ← if opt_root then
      some <$> node_buf_get state layer "commitp_insert: node_buf[layer]"
    else pure none
  return { ret := 1#32, state, opt_root }

/-- The ascent `while( layer_cnt>1UL )` of `fd_bmtree_commitp_fini` (`fd_bmtree.c:573`):
`false` is `return NULL`. -/
def fd_bmtree_commitp_fini.walk (sha : Sha256) (hash_sz : BitVec 64) (state : fd_bmtree_commit_t)
    (layer : Nat) (layer_cnt inc_idx : BitVec 64) : Outcome (fd_bmtree_commit_t × Bool) :=
  if _h : layer_cnt > 1#64 then do
    let bit ← shl 2#64 (BitVec.ofNat 64 layer) "commitp_fini: 2UL<<layer"
    let hs ← HAS state (inc_idx ^^^ bit)
    if (layer_cnt &&& 1#64 = 0#64) && !hs then return (state, false)
    let tmp_l ← if layer_cnt &&& 1#64 ≠ 0#64 then node_buf_get state layer "commitp_fini: node_buf"
      else ip_get state (inc_idx ^^^ bit) "commitp_fini: inclusion_proofs"
    let nb ← node_buf_get state layer "commitp_fini: node_buf[layer]"
    let state ← node_buf_set state (layer + 1)
      (← fd_bmtree_private_merge.spec sha tmp_l nb hash_sz state.prefix_sz)
      "commitp_fini: node_buf[layer+1]"
    let layer := layer + 1
    let layer_cnt' := (layer_cnt + 1#64) >>> 1
    let inc_idx ← last_idx layer_cnt' (BitVec.ofNat 64 layer)
    if ← HAS state inc_idx then
      let n ← node_hash (← node_buf_get state layer "commitp_fini: node_buf[layer]") hash_sz
      if !fd_memeq n (← ip_hash state inc_idx hash_sz "commitp_fini: inclusion_proofs") then
        return (state, false)
    fd_bmtree_commitp_fini.walk sha hash_sz state layer layer_cnt' inc_idx
  else .ok (state, true)
termination_by layer_cnt.toNat
decreasing_by
  simp only [BitVec.lt_def] at _h
  simp only [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_add]
  have := layer_cnt.isLt
  simp at *
  omega

/-- The "cache that path" loop of `fd_bmtree_commitp_fini` (`fd_bmtree.c:593`); no bounds
check on `inc_idx`. -/
def fd_bmtree_commitp_fini.cache (state : fd_bmtree_commit_t) (layer : Nat)
    (layer_cnt : BitVec 64) : Outcome fd_bmtree_commit_t :=
  if _h : layer_cnt > 1#64 then do
    let layer := layer + 1
    let layer_cnt' := (layer_cnt + 1#64) >>> 1
    let inc_idx ← last_idx layer_cnt' (BitVec.ofNat 64 layer)
    let state ← ip_set state inc_idx (← node_buf_get state layer "commitp_fini: node_buf[layer]")
      "commitp_fini: inclusion_proofs past the region"
    let state ← set_valid state inc_idx
    fd_bmtree_commitp_fini.cache state layer layer_cnt'
  else .ok state
termination_by layer_cnt.toNat
decreasing_by
  simp only [BitVec.lt_def] at _h
  simp only [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, BitVec.toNat_add]
  have := layer_cnt.isLt
  simp at *
  omega

/-- The `ipfset_is_full` loop (`fd_bmtree.c:606`) over words `[i, n)`. -/
def fd_bmtree_commitp_fini.full_words (state : fd_bmtree_commit_t) (n i : Nat) : Outcome Bool :=
  if i < n then do
    let w ← loadULong state.ip_mem (state.inclusion_proofs_valid + 8 * i)
      "commitp_fini: bitmap word past the region"
    if w ≠ ~~~0#64 then return false
    fd_bmtree_commitp_fini.full_words state n (i + 1)
  else .ok true
termination_by n - i

/-- The `inc_idx` loop (`fd_bmtree.c:613`). A step that wraps or is 0 is `ub`: reaching it
needs `HAS` true on ~2^63 indices, a bitmap no address space holds. -/
def fd_bmtree_commitp_fini.idx_loop (state : fd_bmtree_commit_t) (max_idx step : BitVec 64)
    (inc_idx : BitVec 64) : Outcome Bool :=
  if inc_idx ≤ max_idx then do
    if !(← HAS state inc_idx) then return false
    if _h : inc_idx.toNat + step.toNat < 2 ^ 64 ∧ step ≠ 0#64 then
      fd_bmtree_commitp_fini.idx_loop state max_idx step (inc_idx + step)
    else .ub "commitp_fini: inc_idx loop wraps or does not advance"
  else .ok true
termination_by max_idx.toNat + 1 - inc_idx.toNat
decreasing_by
  all_goals
    obtain ⟨h1, h2⟩ := _h
    have : step.toNat ≠ 0 := fun e => h2 (BitVec.eq_of_toNat_eq (by simpa using e))
    rename_i hle
    simp only [BitVec.le_def] at hle
    rw [BitVec.toNat_add, Nat.mod_eq_of_lt h1]
    omega

/-- The `layer` loop (`fd_bmtree.c:608`); `1UL<<64` at layer 64 is `ub`. -/
def fd_bmtree_commitp_fini.layers (state : fd_bmtree_commit_t) (leaf_cnt root_idx : BitVec 64)
    (layer : Nat) : Outcome Bool :=
  if h : layer < 64 then do
    let p := 1#64 <<< layer
    if p - 1#64 < root_idx then
      let min_idx_for_layer := fd_ulong_insert_lsb (64#64 * ((root_idx + 1#64) / 64#64))
        (int_of layer 1#32) (p - 1#64)
      let max_idx_for_layer := fd_ulong_insert_lsb ((leaf_cnt - 1#64) <<< 1)
        (int_of layer 1#32) (p - 1#64)
      let step ← shl 2#64 (BitVec.ofNat 64 layer) "commitp_fini: 2UL<<layer"
      if !(← fd_bmtree_commitp_fini.idx_loop state max_idx_for_layer step min_idx_for_layer) then
        return false
      fd_bmtree_commitp_fini.layers state leaf_cnt root_idx (layer + 1)
    else .ok true
  else .ub "commitp_fini: 1UL<<64 in the layer loop condition"
termination_by 64 - layer

/-- `fd_bmtree_commitp_fini.spec`'s result: the state and the 32 bytes at the returned pointer
(`none` = `NULL`). -/
structure fd_bmtree_commitp_fini.Result where
  state : fd_bmtree_commit_t
  root : Option fd_bmtree_node_t
deriving Repr, DecidableEq

/-- `fd_bmtree_commitp_fini` (`fd_bmtree.c:540`). -/
def fd_bmtree_commitp_fini.spec (sha : Sha256) (state : fd_bmtree_commit_t) (leaf_cnt : BitVec 64) :
    Outcome fd_bmtree_commitp_fini.Result := do
  let inclusion_proof_sz := state.inclusion_proof_sz
  let hash_sz := state.hash_sz
  let fail (s : fd_bmtree_commit_t) : fd_bmtree_commitp_fini.Result := { state := s, root := none }
  if leaf_cnt = 0#64 then return fail state
  let mut state := state
  if !fd_ulong_is_pow2 leaf_cnt then
    let layer := (← fd_ulong_find_lsb leaf_cnt).signExtend 64
    let layer_cnt ← shr leaf_cnt layer "commitp_fini: leaf_cnt>>layer"
    let inc_idx ← last_idx layer_cnt layer
    if inc_idx ≥ inclusion_proof_sz then return fail state
    if !(← HAS state inc_idx) then return fail state
    state ← node_buf_set state layer.toNat (← ip_get state inc_idx "commitp_fini: inclusion_proofs")
      "commitp_fini: node_buf[layer]"
    let (state', ok) ← fd_bmtree_commitp_fini.walk sha hash_sz state layer.toNat layer_cnt inc_idx
    if !ok then return fail state'
    let layer := (← fd_ulong_find_lsb leaf_cnt).signExtend 64
    let layer_cnt ← shr leaf_cnt layer "commitp_fini: leaf_cnt>>layer"
    let _inc_idx ← last_idx layer_cnt layer
    state ← fd_bmtree_commitp_fini.cache state' layer.toNat layer_cnt
  let root_idx := fd_ulong_pow2_up leaf_cnt - 1#64
  if !(← fd_bmtree_commitp_fini.full_words state ((root_idx + 1#64) / 64#64).toNat 0) then
    return fail state
  if !(← fd_bmtree_commitp_fini.layers state leaf_cnt root_idx 0) then return fail state
  if !(← HAS state root_idx) then return fail state
  state := { state with leaf_cnt }
  return { state, root := some (← ip_get state root_idx "commitp_fini: return past the region") }

end

end Firedancer.Bmtree
