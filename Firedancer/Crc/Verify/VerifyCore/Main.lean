module

public import Firedancer.Crc.Verify.VerifyCore.Defs
import Firedancer.Crc.Verify.QuadRuns
import Firedancer.Crc.Verify.Reads

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5
open MLIR.Firedancer (fd_sha512_init.stores)

@[expose] public section

/-- What `fd_r52x5_verify_core` does: the code it returns, and when it hashes, the `fd_sha512_t` it
leaves and the code it stores at `ok`; the blocks its frame and its callees' count. -/
structure fd_r52x5_verify_core.Result where
  ret : BitVec 32
  out : Option (ShaState × BitVec 32)
  blocks : Nat

/-- The memory `fd_r52x5_verify_core` leaves: the hash object and the `ok` code when it hashes. -/
def fd_r52x5_verify_core.Result.mem (res : fd_r52x5_verify_core.Result) (m : MemoryState)
    (sha ok : Pointer) : MemoryState :=
  match res.out with
  | some (X, e) => ((Firedancer.fd_sha512_init.stores m sha).storeSha sha X).storeAt ok e
  | none => m

/-- `fd_r52x5_verify_core( msg, msg_sz, sig, public_key, sha, NULL, ok, NULL )` on the signature
halves `r`, `S`, the key, the message, the hash object's buffer `buf0`, the code `okv` at `ok`, and
the base table `TB`: the checks in the C's order; past them, `ok`'s code from
`fd_r52x5_ge_eq_z1` of `[k](-A) + [S]B` and `R`. -/
noncomputable def fd_r52x5_verify_core.spec (TB : Nat → Quad5) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) (r S publicKey : BitVec 256) (buf0 : BitVec 1024)
    (okv : BitVec 32) : fd_r52x5_verify_core.Result :=
  if !Ref.fd_curve25519_scalar_validate.spec S then ⟨-1#32, none, 13⟩
  else
    let D := fd_r52x5_ge_decode2.spec publicKey r
    let blocks := 13 + fd_r52x5_ge_decode2.blocks D
    match D.2 with
    | none => ⟨if D.1 &&& 1#32 = 0#32 then -2#32 else -1#32, none, blocks⟩
    | some (Ap, Rp) =>
      if fd_r52x5_ge_is_small_order_affine.spec Ap ≠ 0#32 then ⟨-2#32, none, blocks + 14⟩
      else if fd_r52x5_ge_is_small_order_affine.spec Rp ≠ 0#32 then ⟨-1#32, none, blocks + 28⟩
      else if okv = 0#32 then ⟨0#32, none, blocks + 28⟩
      else
        let H := Firedancer.fd_ed25519_verify.hash buf0 r publicKey msgSz msg
        let k := Ref.fd_curve25519_scalar_reduce.spec (Firedancer.Words8.bits H.2)
        let An := Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec Ap) Ap
        let Rc := fd_r52x5_double_scalar_mul_base.spec TB k An S
        ⟨0#32, some (H.1, fd_r52x5_ge_eq_z1.spec Rc Rp),
          blocks + 28 + Firedancer.fd_ed25519_verify.hashBlocks buf0 r publicKey msgSz msg +
            fd_r52x5_double_scalar_mul_base.blocks k S + 38⟩

end

section Proof

attribute [local mlir_read] MemoryState.readSha_storeSha_self

attribute [local mlir_transport] GlobalState.WF.add_blocks_storeSha
  GlobalState.WF.add_blocks_storeSha_storeWords8

theorem MemoryState.Quad5Fit.hashMem {m : MemoryState} (h : m.Quad5Fit q) :
    (Firedancer.fd_ed25519_verify.hashMem m sha k X v).Quad5Fit q :=
  ⟨h.1, h.2.1.hashMem, h.2.2.1.hashMem, h.2.2.2.1.hashMem, h.2.2.2.2.1.hashMem, h.2.2.2.2.2.hashMem⟩

theorem MemoryState.Quad5Room.hashMem {m : MemoryState} (h : m.Quad5Room q) :
    (Firedancer.fd_ed25519_verify.hashMem m sha k X v).Quad5Room q :=
  ⟨h.1, h.2.1.hashMem, h.2.2.1.hashMem, h.2.2.2.1.hashMem, h.2.2.2.2.1.hashMem, h.2.2.2.2.2.hashMem⟩

theorem MemoryState.readQuad5_hashMem_of_id_ne {m : MemoryState} (hsha : q.id ≠ sha.id)
    (hk : q.id ≠ k.id) :
    (Firedancer.fd_ed25519_verify.hashMem m sha k X v).readQuad5 q = m.readQuad5 q := by
  have h1 (o : BitVec 64) : (q.add o).id ≠ sha.id := by simpa [Pointer.add_id] using hsha
  have h2 (o : BitVec 64) : (q.add o).id ≠ k.id := by simpa [Pointer.add_id] using hk
  simp only [MemoryState.readQuad5, MemoryState.readWv, MemoryState.readAt_hashMem_of_id_ne hsha hk,
    MemoryState.readAt_hashMem_of_id_ne (h1 _) (h2 _)]

theorem Writable.hashMem {m : MemoryState} (h : Writable m q) :
    Writable (Firedancer.fd_ed25519_verify.hashMem m sha k X v) q := by
  unfold Firedancer.fd_ed25519_verify.hashMem fd_sha512_init.stores
  exact h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeSha.storeWords8

attribute [local mlir_transport] fd_r52x5_double_scalar_mul_base.TableAt.storeAt
  fd_r52x5_double_scalar_mul_base.TableAt.storeWv fd_r52x5_double_scalar_mul_base.TableAt.storeTmp5
  fd_r52x5_double_scalar_mul_base.TableAt.storeQuad5 fd_r52x5_double_scalar_mul_base.TableAt.storeOut
  fd_r52x5_double_scalar_mul_base.TableAt.lifetimeStart
  fd_r52x5_double_scalar_mul_base.TableAt.lifetimeEnd fd_r52x5_double_scalar_mul_base.TableAt.alloca
  fd_r52x5_double_scalar_mul_base.TableAt.storeWords8 fd_r52x5_double_scalar_mul_base.TableAt.storeSha

attribute [local mlir_transport] GlobalState.WF.add_blocks_storeQuad5 GlobalState.WF.add_blocks3

attribute [local mlir_transport] Fits.hashMem MemoryState.Quad5Fit.hashMem
  MemoryState.Quad5Room.hashMem MemoryState.ShaFit.hashMem MemoryState.Words8Fit.hashMem
  GlobalState.WF.hashMem_mk Writable.hashMem
  fd_r52x5_double_scalar_mul_base.TableAt.hashMem

attribute [local mlir_transport] fd_r52x5_ge_decode2.Fits.storeOut
  fd_r52x5_ge_decode2.InBounds.storeOut fd_r52x5_ge_decode2.Room.storeOut
  fd_r52x5_ge_decode2.Writable.storeOut fd_r52x5_ge_decode2.Quad5Fit.storeOut
  fd_r52x5_ge_decode2.Quad5Room.storeOut fd_r52x5_ge_decode2.Words8Room.storeOut
  fd_r52x5_ge_decode2.WF.storeOut_mk

attribute [local mlir_read] fd_r52x5_ge_decode2.readAt_storeOut_of_id_ne
  fd_r52x5_ge_decode2.readQuad5_storeOut_of_id_ne

attribute [local mlir_erase high] fd_r52x5_ge_decode2.eraseFrom_storeOut_of_le

attribute [local mlir_read] MemoryState.readAt_hashMem_of_id_ne
  MemoryState.readQuad5_hashMem_of_id_ne MemoryState.readAt_hashMem_k

attribute [local mlir_erase high] MemoryState.eraseFrom_hashMem_of_le

attribute [local mlir_fresh] Fits.hashMem_k

attribute [local mlir_transport] MemoryState.Words8Room.storeSha InBounds.hashMem Room.hashMem
  MemoryState.Words8Room.hashMem

/-- `fd_sha512_fini( fd_sha512_append( fd_sha512_append( fd_sha512_append( fd_sha512_init( sha ),
sig, 32UL ), public_key, 32UL ), msg, msg_sz ), k )`: the hash object and the digest's words at `k`
as `fd_ed25519_verify.hash` gives them. -/
theorem fd_r52x5_verify_core.hash_run {E : ⟪fd_r52x5_verify_core.Γ⟫} {S : GlobalState}
    {g : ⟪fd_r52x5_verify_core.Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    {msg sig pk sha k a ok n : Pointer} {msgSz : BitVec 64}
    (hArgs :
      E.args =
        (fd_r52x5_verify_core.args (.value msg) (.value msgSz) (.value sig) (.value pk)
            (.value sha) (.value a) (.value ok) (.value n)).get)
    (hR : E ⊨ [%2317 := 32#64, %2331 := k]) (hwf : S.WF)
    (hg : S.mem.Globals fd_r52x5_verify_core.globals) (hsha : S.mem.ShaFit sha)
    (hshaw : Writable S.mem sha) (hsig : Fits S.mem sig (8 * 32))
    (hsig_off : ¬sig.offset.uaddOverflow 32#64) (hpk : Fits S.mem pk (8 * 32))
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hmsg : Fits S.mem msg (8 * msgSz.toNat))
    (hmsg_off : ¬msg.offset.uaddOverflow msgSz) (hmsgSz : msgSz.toNat < 2 ^ 63)
    (hk : S.mem.Words8Room k) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hmsg_sha : msg.id ≠ sha.id) (hk_sha : k.id ≠ sha.id)
    (hK :
      (fd_r52x5_verify_core.bb17.runBodyFrom
            E[%2375 := .value sha, %2376 := .value sha, %2377 := .value sha, %2378 := .value sha,
              %2379 := .value k]
            6
            {
              alloc :=
                ⟨S.alloc.nextFreeBlock +
                    Firedancer.fd_ed25519_verify.hashBlocks (S.mem.readAt sha 1024)
                      (S.mem.readAt sig 256) (S.mem.readAt pk 256) msgSz
                      (S.mem.readAt msg (8 * msgSz.toNat))⟩,
              mem :=
                let h :=
                  Firedancer.fd_ed25519_verify.hash (S.mem.readAt sha 1024) (S.mem.readAt sig 256)
                    (S.mem.readAt pk 256) msgSz (S.mem.readAt msg (8 * msgSz.toNat))
                Firedancer.fd_ed25519_verify.hashMem S.mem sha k h.1 h.2 } >>=
          g) =
        K) :
    (fd_r52x5_verify_core.bb17.runBodyFrom E 1 S >>= g) = K := by
  have hinit := Ref.fd_sha512_init.readSha hsha hshaw
  obtain ⟨hsha_fits, hsha_off⟩ := hsha
  step_call using Ref.fd_sha512_init.call_eq
  rename_i S₀
  have hsh0 : S.mem.readSha sha = ⟨S₀.mem.readAt sha 1024, Ref.sha512IV, 0#64, 0#64, 0#64⟩ := by
    rw [hS]
    simpa using hinit
  clear hinit
  have hsha : S.mem.ShaFit sha := ⟨hsha_fits, hsha_off⟩
  clear hsha_fits hread_sha_200 hread_sha_184 hread_sha_176 hread_sha_168 hread_sha_160
    hread_sha_152 hread_sha_144 hread_sha_136 hread_sha_128
  step_call using
    (Ref.fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hsh0).mpr (by simp))) consuming
    hread_sig
  step_call using
    (Ref.fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp)))) consuming
    hread_pk
  step_call using
    (Ref.fd_sha512_append.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _
          (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))) consuming
    hread_msg
  step_call using
    (Ref.fd_sha512_fini.call_eq (hu :=
      (congrArg (fun x : ShaState => x.bufUsed.toNat < 128) hread_sha).mpr
        (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _
          (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _
            (Ref.fd_sha512_append.spec_bufUsed_lt _ _ _ (by simp))))))
  subst hE hS
  rw [MemoryState.storeSha_storeSha_self hsha_off, MemoryState.storeSha_storeSha_self hsha_off,
    MemoryState.storeSha_storeSha_self hsha_off]
  convert hK using 5 <;>
    simp only [Firedancer.fd_ed25519_verify.hash, Firedancer.fd_ed25519_verify.hashBlocks,
      Firedancer.fd_ed25519_verify.shaStates, Firedancer.fd_ed25519_verify.hashMem,
      fd_sha512_init.stores]
  omega

/-- A `wl_t` `x` cast to bytes into `u`; lanes 1 and 2 of them with lanes 0 and 3 of the bytes `c`
into `s`. -/
def fd_r52x5_verify_core.blendBytesRun {Γ : Ctx} (x : Reg Γ (.vec 4 64)) (c : Reg Γ (.vec 32 8))
    (u s : Dst Γ (.vec 32 8)) : List (Instr Γ) :=
  [.unop (.bitcast (by decide)) u x,
    .binop (.shufflevector (#v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 40, some 41, some 42, some 43, some 44, some 45, some 46, some 47, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, some 24, some 25, some 26, some 27, some 28, some 29, some 30, some 31] : Vector (Option (Fin (2 * 32))) 32)) s c (.val u.i u.h)]

/-- `blendBytesRun`'s `shufflevector` on two `wl_t`s' bytes: the bytes of their lane blend. -/
theorem fd_r52x5_verify_core.shufflevector_blendBytes (a b : Wl) :
    Operation.shufflevector (#v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 40, some 41, some 42, some 43, some 44, some 45, some 46, some 47, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, some 24, some 25, some 26, some 27, some 28, some 29, some 30, some 31] : Vector (Option (Fin (2 * 32))) 32)
        (Ty.wrap (t := .vec 32 8) (wlBytes b)) (Ty.wrap (t := .vec 32 8) (wlBytes a)) =
      Ty.wrap (t := .vec 32 8) (wlBytes (wlBlend true false false true b a)) := by
  simp only [wlBytes_eq, reduceShufflevector, wlBlend, Bool.cond_true, Bool.cond_false, Ty.wrap_vec,
    Vector.map_mk, List.map_toArray, List.map_cons, List.map_nil, reduceGetElemLit]

/-- Where the body at `pos` is `blendBytesRun`, `x` holds `a` and `c` the bytes of `b`: running on
from `pos` then `g` gives `K` if it does from `pos + 2` with the bytes of `wlBlend 1 0 0 1 b a` in
`s`. -/
theorem fd_r52x5_verify_core.runBodyFrom_blendBytesRun {Γ : Ctx} {blk : BasicBlock Γ tRets bp}
    {E : ⟪Γ⟫} {pos : Nat} {x : Reg Γ (.vec 4 64)} {c : Reg Γ (.vec 32 8)} {u s : Dst Γ (.vec 32 8)}
    {rest : List (Instr Γ)} {a b : Wl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (hbody : blk.body.drop pos = fd_r52x5_verify_core.blendBytesRun x c u s ++ rest)
    (hR : E ⊨ [x := a, c := wlBytes b]) (hcu : c ≠ .val u.i u.h)
    (hK :
      ∀ v : ⟦.vec 32 8⟧,
        (blk.runBodyFrom E[u := v, s := Ty.wrap (wlBytes (wlBlend true false false true b a))]
            (pos + 2) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hx, hc⟩ := hR
  have hb : blk.body.drop pos = _ :: _ :: rest := hbody
  have hb1 := List.drop_succ_of_drop_eq_cons hb
  rw [BasicBlock.runBodyFrom_step_pure (List.lt_length_of_drop_eq_cons hb)
      (by rw [List.getElem_of_drop_eq_cons hb]; rfl),
    BasicBlock.runBodyFrom_step_pure (List.lt_length_of_drop_eq_cons hb1)
      (by rw [List.getElem_of_drop_eq_cons hb1]; rfl)]
  simp only [Env.read_write_dst, Env.read_write_of_ne _ _ _ hcu, BinOp.compute, UnOp.compute, hx, hc,
    bitcast_wlBytes, fd_r52x5_verify_core.shufflevector_blendBytes]
  exact hK _

/-- Five `wl_t`s' bytes stored at a point's offsets. -/
def fd_r52x5_verify_core.storeBytesRun {Γ : Ctx} (s0 s1 s2 s3 s4 : Reg Γ (.vec 32 8))
    (p g1 g2 g3 g4 : Reg Γ .ptr) : List (Instr Γ) :=
  [.store p s0, .store g1 s1, .store g2 s2, .store g3 s3, .store g4 s4]

/-- Where the body at `pos` is `storeBytesRun`, `s0 … s4` hold the bytes of `Q` and `p, g1 … g4` the
point `P`'s offsets: running on from `pos` then `g` gives `K` if it does from `pos + 5` with `Q`
stored at `P`. -/
theorem fd_r52x5_verify_core.runBodyFrom_storeBytesRun {Γ : Ctx} {blk : BasicBlock Γ tRets bp}
    {E : ⟪Γ⟫} {pos : Nat} {s0 s1 s2 s3 s4 : Reg Γ (.vec 32 8)} {p g1 g2 g3 g4 : Reg Γ .ptr}
    {rest : List (Instr Γ)} {Q : Quad5} {P : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = fd_r52x5_verify_core.storeBytesRun s0 s1 s2 s3 s4 p g1 g2 g3 g4 ++ rest)
    (hR :
      E ⊨ [s0 := wlBytes Q.P0, s1 := wlBytes Q.P1, s2 := wlBytes Q.P2, s3 := wlBytes Q.P3,
        s4 := wlBytes Q.P4, p := P, g1 := P.add 32#64, g2 := P.add 64#64, g3 := P.add 96#64,
        g4 := P.add 128#64])
    (hP : S.mem.Quad5Room P)
    (hK : (blk.runBodyFrom E (pos + 5) { alloc := S.alloc, mem := S.mem.storeQuad5 P Q } >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨-, hp0, hp1, hp2, hp3, hp4⟩ := hP
  have e : S.mem.storeQuad5 P Q =
      ((((S.mem.storeAt P (BitVec.packLanes (wlBytes Q.P0))).storeAt (P.add 32#64)
        (BitVec.packLanes (wlBytes Q.P1))).storeAt (P.add 64#64) (BitVec.packLanes (wlBytes Q.P2))).storeAt
        (P.add 96#64) (BitVec.packLanes (wlBytes Q.P3))).storeAt (P.add 128#64)
        (BitVec.packLanes (wlBytes Q.P4)) := by
    simp only [MemoryState.storeAt_packLanes_wlBytes]; rfl
  rw [e] at hK
  iterate 5 step_store
  rw [hS]
  exact hK

/-- `hashMem` keeps a frame's slots. -/
theorem fd_r52x5_verify_core.SlotFrame.hashMem {B : GlobalState} {m : MemoryState}
    (h : SlotFrame B n m) : SlotFrame B n (Firedancer.fd_ed25519_verify.hashMem m sha k X v) :=
  h.of (fun _ _ => InBounds.hashMem) fun _ => Writable.hashMem

/-- A callee's temporaries keep the base table. -/
theorem fd_r52x5_verify_core.TableAt.callTmp5 {M : MemoryState} {p : Pointer}
    (h : fd_r52x5_double_scalar_mul_base.TableAt M p n T) (h0 : p.id ≠ t0.id) (h1 : p.id ≠ t1.id)
    (h2 : p.id ≠ t2.id) (h3 : p.id ≠ t3.id) (h4 : p.id ≠ t4.id) :
    fd_r52x5_double_scalar_mul_base.TableAt (M.callTmp5 t0 t1 t2 t3 t4 Q) p n T := by
  unfold MemoryState.callTmp5
  exact ((((((((((h.lifetimeStart h0).lifetimeStart h1).lifetimeStart h2).lifetimeStart
    h3).lifetimeStart h4).storeTmp5 h0 h1 h2 h3 h4).lifetimeEnd h4).lifetimeEnd h3).lifetimeEnd
    h2).lifetimeEnd h1).lifetimeEnd h0

attribute [local mlir_transport] fd_r52x5_verify_core.SlotFrame.hashMem
  fd_r52x5_verify_core.TableAt.callTmp5

/-- A read below the counter is unaffected by `alloca`s. -/
theorem fd_r52x5_verify_core.readAt_allocas {s : GlobalState} {p : Pointer}
    (hp : p.id.id < s.alloc.nextFreeBlock) :
    ∀ ns : List Nat, (fd_r52x5_ge_decode2.allocas s ns).mem.readAt p w = s.mem.readAt p w
  | [] => rfl
  | n :: ns => by
    simp only [fd_r52x5_ge_decode2.allocas]
    rw [readAt_allocas (s := s.alloca n true) (by simp [GlobalState.alloca_alloc]; omega) ns]
    simp only [MemoryState.readAt]
    rw [GlobalState.getElem?_alloca (fun h => by
      have := congrArg BlockId.id h
      simp [GlobalState.allocaPtr] at this; omega)]
termination_by ns => ns.length

/-- `^bb20` then `^bb21`: the three points' lifetimes ended, `v` returned. -/
theorem fd_r52x5_verify_core.exit_run {β : Type} {E : ⟪fd_r52x5_verify_core.Γ⟫} {S : GlobalState}
    {g : Vals fd_r52x5_verify_core.tRets × GlobalState → PoisonOr β} {K : PoisonOr β}
    {A R Rc : Pointer} {v : BitVec 32}
    (hR : E ⊨ [%2324 := A, %2325 := R, %2326 := Rc, %2407 := v])
    (hK : g (.cons (.value v) .nil,
      { alloc := S.alloc, mem := ((S.mem.lifetimeEnd Rc).lifetimeEnd R).lifetimeEnd A }) = K) :
    (fd_r52x5_verify_core.runFrom E 20 S >>= g) = K := by
  block_init
  iterate 3 step_pure
  finish_block
  block_init
  finish_block
  subst hS
  exact hK

/-- `^bb12` after a failed decode: `-2` when the code's low bit is clear, else `-1` (the code
below `2`), each through `exit_run`. -/
theorem fd_r52x5_verify_core.none_run {E : ⟪fd_r52x5_verify_core.Γ⟫} {S : GlobalState} {n : Nat}
    {K : PoisonOr (Vals fd_r52x5_verify_core.tRets × GlobalState)} {M : MemoryState}
    {A R Rc : Pointer} {d : BitVec 32}
    (hRegs : E ⊨ [%2316 := 1#32, %2319 := 4294967295#32, %2320 := 0#32, %2321 := 4294967294#32,
      %2322 := 2#32, %2324 := A, %2325 := R, %2326 := Rc, %2365 := d])
    (hd : d &&& 1#32 = 0#32 ∨ d.ult 2#32 = true)
    (herase : (((S.mem.lifetimeEnd Rc).lifetimeEnd R).lifetimeEnd A).eraseFrom n = M)
    (hKa : d &&& 1#32 = 0#32 →
      PoisonOr.value (Vals.cons (PoisonOr.value (-2#32)) Vals.nil,
        { alloc := S.alloc, mem := M }) = K)
    (hKb : ¬d &&& 1#32 = 0#32 →
      PoisonOr.value (Vals.cons (PoisonOr.value (-1#32)) Vals.nil,
        { alloc := S.alloc, mem := M }) = K) :
    (do
        let x ← fd_r52x5_verify_core.bb12.runBodyFrom E 1 S
        let x ← Exit.run fd_r52x5_verify_core.blockParams x.1 fd_r52x5_verify_core.bb12.exit x.2
        let p ← Func.continue x.1.1 x.1.2 x.2
        PoisonOr.value (p.1, { alloc := p.2.alloc, mem := p.2.mem.eraseFrom n })) = K := by
  step_pure
  step_pure
  finish_block
  case isTrue =>
    run_from using fd_r52x5_verify_core.exit_run
    exact hKa (by simpa using hbr)
  have hb1 : ¬d &&& 1#32 = 0#32 := by simpa using hbr
  clear hbr
  block_init
  step_pure
  finish_block
  case isFalse =>
    exfalso
    rcases hd with h | h
    · exact hb1 h
    · simp [h] at hbr
  run_from using fd_r52x5_verify_core.exit_run
  exact hKb hb1

open fd_r52x5_double_scalar_mul_base in
/-- `^bb17` on: the hash, `k`, `-A`, `[k](-A) + [S]B`, `ok`'s code; then the frame erased. -/
theorem fd_r52x5_verify_core.main_run {E : ⟪fd_r52x5_verify_core.Γ⟫} {S B : GlobalState}
    {K : PoisonOr (Vals fd_r52x5_verify_core.tRets × GlobalState)}
    {msg sig pk sha ok fl tb A R Rc k v16 v17 v18 v19 v20 : Pointer} {msgSz : BitVec 64}
    {flB tbB : BlockId} (TB : Nat → Quad5) (M : MemoryState) (Aq Rq : Quad5)
    (buf0 : BitVec 1024) (r pkv sS : BitVec 256) (msgv : BitVec (8 * msgSz.toNat))
    (hArgs :
      E.args =
        (fd_r52x5_verify_core.args (.value msg) (.value msgSz) (.value sig) (.value pk)
            (.value sha) (.value Pointer.null) (.value ok) (.value Pointer.null)).get)
    (hRegs : E ⊨ [%2317 := 32#64, %2318 := Pointer.null, %2320 := 0#32, %2324 := A,
      %2325 := R, %2326 := Rc, %2331 := k, %2332 := v16, %2333 := v17, %2334 := v18,
      %2335 := v19, %2336 := v20, %2337 := sig.add 32#64])
    (hA : A = B.slot 0) (hsig_ne_A : sig.id ≠ A.id) (hok_ne_A : ok.id ≠ A.id)
    (hfl_ne_A : fl.id ≠ A.id) (hsha_ne_A : sha.id ≠ A.id)
    (hR : R = B.slot 1) (hok_ne_R : ok.id ≠ R.id) (hsha_ne_R : sha.id ≠ R.id)
    (hRc : Rc = B.slot 2) (hRc_off : Rc.offset = 0) (hok_ne_Rc : ok.id ≠ Rc.id)
    (hk : k = B.slot 7) (hk_off : k.offset = 0) (hmsg_ne_k : msg.id ≠ k.id)
    (hsig_ne_k : sig.id ≠ k.id) (hpk_ne_k : pk.id ≠ k.id) (hok_ne_k : ok.id ≠ k.id)
    (hfl_ne_k : fl.id ≠ k.id) (hsha_ne_k : sha.id ≠ k.id)
    (hv16 : v16 = B.slot 8) (hsig_ne_v16 : sig.id ≠ v16.id)
    (hok_ne_v16 : ok.id ≠ v16.id) (hfl_ne_v16 : fl.id ≠ v16.id)
    (hv17 : v17 = B.slot 9) (hsig_ne_v17 : sig.id ≠ v17.id)
    (hok_ne_v17 : ok.id ≠ v17.id) (hfl_ne_v17 : fl.id ≠ v17.id)
    (hv18 : v18 = B.slot 10) (hsig_ne_v18 : sig.id ≠ v18.id)
    (hok_ne_v18 : ok.id ≠ v18.id) (hfl_ne_v18 : fl.id ≠ v18.id)
    (hv19 : v19 = B.slot 11) (hsig_ne_v19 : sig.id ≠ v19.id)
    (hok_ne_v19 : ok.id ≠ v19.id) (hfl_ne_v19 : fl.id ≠ v19.id)
    (hv20 : v20 = B.slot 12) (hsig_ne_v20 : sig.id ≠ v20.id)
    (hok_ne_v20 : ok.id ≠ v20.id) (hfl_ne_v20 : fl.id ≠ v20.id)
    (hRA : R.id ≠ A.id)
    (hfl_eq : (⟨flB, 0⟩ : Pointer) = fl) (htb_eq : (⟨tbB, 0⟩ : Pointer) = tb)
    (htb_lt : tb.id.id < B.alloc.nextFreeBlock)
    (htb_sha : tb.id ≠ sha.id) (hfl_sha : fl.id ≠ sha.id)
    (hmsg_off : ¬msg.offset.uaddOverflow msgSz) (hmsgSz : msgSz.toNat < 2 ^ 63)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hsig32 : ¬sig.offset.uaddOverflow 32#64) (hS_off : ¬(sig.add 32#64).offset.uaddOverflow 32#64)
    (hsha_off : ¬sha.offset.uaddOverflow 256#64)
    (hmsg_sha : msg.id ≠ sha.id) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hv : Ref.fd_curve25519_scalar_validate.spec sS = true)
    (hwf : S.WF) (hg : S.mem.Globals fd_r52x5_verify_core.globals)
    (hgf : S.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : S.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hset : S.mem.readAt fl 1 = 1#1)
    (hread_S : S.mem.readAt (sig.add 32#64) 256 = sS) (hread_r : S.mem.readAt sig 256 = r)
    (hread_pk : S.mem.readAt pk 256 = pkv) (hread_msg : S.mem.readAt msg (8 * msgSz.toNat) = msgv)
    (hread_buf : S.mem.readAt sha 1024 = buf0)
    (hqA : S.mem.readQuad5 A = Aq) (hread_R : S.mem.readQuad5 R = Rq)
    (hroom_Rc : Room S.mem Rc 1536)
    (hmsg : Fits S.mem msg (8 * msgSz.toNat)) (hsig : Fits S.mem sig (8 * 64))
    (hpk : Fits S.mem pk (8 * 32)) (hshaw : Writable S.mem sha) (hok : Fits S.mem ok 32)
    (hokw : Writable S.mem ok) (hfl : Fits S.mem fl 1) (hTB : TableAt S.mem tb 128 TB)
    (hsha_fits : Fits S.mem sha (8 * 256))
    (hwritable_k : Writable S.mem k) (hk_bounds : InBounds S.mem k 512)
    (hA_pt : S.mem.Quad5Room A) (hAf : S.mem.Quad5Fit A)
    (hRf : S.mem.Quad5Fit R)
    (hF : SlotFrame B 13 S.mem) (herase : S.mem.eraseFrom B.alloc.nextFreeBlock = M)
    (hK :
      let H := Firedancer.fd_ed25519_verify.hash buf0 r pkv msgSz msgv
      let kk := Ref.fd_curve25519_scalar_reduce.spec (Firedancer.Words8.bits H.2)
      PoisonOr.value
          (Vals.cons (PoisonOr.value 0#32) Vals.nil,
            { alloc := ⟨S.alloc.nextFreeBlock +
                  Firedancer.fd_ed25519_verify.hashBlocks buf0 r pkv msgSz msgv +
                  fd_r52x5_double_scalar_mul_base.blocks kk sS + 38⟩,
              mem := ((fd_sha512_init.stores M sha).storeSha sha H.1).storeAt ok
                (fd_r52x5_ge_eq_z1.spec
                  (fd_r52x5_double_scalar_mul_base.spec TB kk
                    (Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec Aq) Aq) sS) Rq) }) = K) :
    (do
        let p ← fd_r52x5_verify_core.runFrom E 17 S
        PoisonOr.value (p.1, { alloc := p.2.alloc, mem := p.2.mem.eraseFrom B.alloc.nextFreeBlock })) =
      K := by
  dsimp only at hK
  folded hA
  folded hR
  folded hRc
  folded hk
  folded hv16
  folded hv17
  folded hv18
  folded hv19
  folded hv20
  block_init
  step_pure
  have hsha : S.mem.ShaFit sha := ⟨hsha_fits, hsha_off⟩
  have hk_w := MemoryState.Words8Room.of_room hroom_k hk_off
  have hroom_k_pre := hroom_k
  step_pattern' using (fd_r52x5_verify_core.hash_run (hwf := hwf) (hg := hg) (hsha := hsha)
    (hshaw := hshaw) (hsig := hsig.mono (by decide)) (hsig_off := hsig32) (hpk := hpk)
    (hpk_off := hpk_off) (hmsg := hmsg) (hmsg_off := hmsg_off) (hmsgSz := hmsgSz) (hk := hk_w)
    (hsig_sha := hsig_sha) (hpk_sha := hpk_sha) (hmsg_sha := hmsg_sha)
    (hk_sha := fun h => hsha_ne_k h.symm))
  obtain ⟨⟨sha4, kw⟩, hH⟩ :
    ∃ H,
      Firedancer.fd_ed25519_verify.hash buf0 r pkv msgSz msgv = H :=
    ⟨_, rfl⟩
  rw [hH] at hS hread_k
  clear hsha hk_w
  have hk32 : ¬k.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow, hk_off]
  have hk64 : ¬k.offset.uaddOverflow 64#64 := by simp [BitVec.uaddOverflow, hk_off]
  have hkr0 : ∀ x : BitVec 256, (S.mem.storeAt k x).readAt k 256 = x :=
    fun x => MemoryState.readAt_storeAt_self (hroom_k_pre.mono (by decide)) x
  rw [hS] at hkr0
  step_call using Ref.fd_curve25519_scalar_reduce.call_eq consuming hread_k
  have hread_kr : S.mem.readAt k 256 = Ref.fd_curve25519_scalar_reduce.spec (Words8.bits kw) := by
    rw [hS]; exact hkr0 _
  clear hkr0 hroom_k_pre
  step_pattern' using runBodyFrom_quad5LoadRun (P := A) with QA
  rw [hqA] at hQA
  subst hQA hv73
  clear hqA
  clear hread_r hread_pk hread_msg hread_sig hread_A hread_R hfits_k hroom_k hmsg hpk hshaw
    hsha_fits hwritable_k hk_bounds
  step_pattern' using runBodyFrom_leafRun1B (hf := fd_r52x5_quad_neg.call_eq) (B := B) (k0 := 8)
    (k1 := 9) (k2 := 10) (k3 := 11) (k4 := 12) (hwf := hwf) (hF := hF) (hk := by decide)
    (hne := by decide) with QN
  subst hQN hv78
  clear hF
  step_pattern' using fd_r52x5_verify_core.runBodyFrom_blendBytesRun
  step_pattern' using fd_r52x5_verify_core.runBodyFrom_blendBytesRun
  step_pattern' using fd_r52x5_verify_core.runBodyFrom_blendBytesRun
  step_pattern' using fd_r52x5_verify_core.runBodyFrom_blendBytesRun
  step_pattern' using fd_r52x5_verify_core.runBodyFrom_blendBytesRun
  have hA_room : S.mem.Quad5Room A := by mem_fact
  obtain ⟨S₅, hS₅⟩ : ∃ s, s = S := ⟨_, rfl⟩
  rw [← hS₅] at hA_room
  step_pattern' using fd_r52x5_verify_core.runBodyFrom_storeBytesRun
    (Q := Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec QA) QA) (hP := hS₅ ▸ hA_room)
  have hAn : S.mem.readQuad5 A = Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec QA) QA := by
    rw [hS]; subst hS₅; exact MemoryState.readQuad5_storeQuad5_self hA_room
  clear hA_room
  clear hread_A hread_A_32 hread_A_64 hread_A_96 hread_A_128
  have hRc_pt := MemoryState.Quad5Room.of_room (hroom_Rc.mono (by decide)) hRc_off
  have hfl' : Fits S.mem ⟨flB, 0⟩ 1 := hfl_eq ▸ hfl
  have hset' : S.mem.readAt ⟨flB, 0⟩ 1 = 1 := hfl_eq ▸ hset
  have hTB' : TableAt S.mem ⟨tbB, 0⟩ 128 TB := htb_eq ▸ hTB
  have hgf' : S.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image) := by
    rw [hS]; exact hgf
  have hgb' : S.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image) := by
    rw [hS]; exact hgb
  clear hgf hgb
  step_call using (fd_r52x5_double_scalar_mul_base.call_eq Rc k A (sig.add 32#64) TB S hwf
    (by mem_fact) flB tbB hgf' hgb' hfl' hset' hTB' hRc_pt (by mem_fact) (by mem_fact) hk32
    (by rw [hread_kr]; exact reduce_lt _) (by mem_fact) hS_off (by rw [hread_S]; exact validate_lt hv))
    consuming hTB' hTB hfl' hset' hset hfl hgf' hgb'
  step_call using fd_r52x5_ge_eq_z1.call_eq
  step_store
  step_pure
  finish_block
  block_init
  step_pure
  finish_block
  run_from using fd_r52x5_verify_core.exit_run
  subst hS
  erase_frame
  rw [herase, ← hK, hH]

open fd_r52x5_double_scalar_mul_base in
/-- `^bb14` on: both points' small-order checks and `ok`'s code, then `main_run`. -/
theorem fd_r52x5_verify_core.checks_run {E : ⟪fd_r52x5_verify_core.Γ⟫} {S B : GlobalState}
    {K : PoisonOr (Vals fd_r52x5_verify_core.tRets × GlobalState)}
    {msg sig pk sha ok fl tb A R Rc k v16 v17 v18 v19 v20 : Pointer} {msgSz : BitVec 64}
    {flB tbB : BlockId} (TB : Nat → Quad5) (M : MemoryState) (Aq Rq : Quad5) (okv : BitVec 32)
    (buf0 : BitVec 1024) (r pkv sS : BitVec 256) (msgv : BitVec (8 * msgSz.toNat))
    (hArgs :
      E.args =
        (fd_r52x5_verify_core.args (.value msg) (.value msgSz) (.value sig) (.value pk)
            (.value sha) (.value Pointer.null) (.value ok) (.value Pointer.null)).get)
    (hRegs : E ⊨ [%2319 := 4294967295#32, %2321 := 4294967294#32, %2317 := 32#64, %2318 := Pointer.null, %2320 := 0#32, %2324 := A,
      %2325 := R, %2326 := Rc, %2331 := k, %2332 := v16, %2333 := v17, %2334 := v18,
      %2335 := v19, %2336 := v20, %2337 := sig.add 32#64])
    (hA : A = B.slot 0) (hsig_ne_A : sig.id ≠ A.id) (hok_ne_A : ok.id ≠ A.id)
    (hfl_ne_A : fl.id ≠ A.id) (hsha_ne_A : sha.id ≠ A.id)
    (hR : R = B.slot 1) (hok_ne_R : ok.id ≠ R.id) (hsha_ne_R : sha.id ≠ R.id)
    (hRc : Rc = B.slot 2) (hRc_off : Rc.offset = 0) (hok_ne_Rc : ok.id ≠ Rc.id)
    (hk : k = B.slot 7) (hk_off : k.offset = 0) (hmsg_ne_k : msg.id ≠ k.id)
    (hsig_ne_k : sig.id ≠ k.id) (hpk_ne_k : pk.id ≠ k.id) (hok_ne_k : ok.id ≠ k.id)
    (hfl_ne_k : fl.id ≠ k.id) (hsha_ne_k : sha.id ≠ k.id)
    (hv16 : v16 = B.slot 8) (hsig_ne_v16 : sig.id ≠ v16.id)
    (hok_ne_v16 : ok.id ≠ v16.id) (hfl_ne_v16 : fl.id ≠ v16.id)
    (hv17 : v17 = B.slot 9) (hsig_ne_v17 : sig.id ≠ v17.id)
    (hok_ne_v17 : ok.id ≠ v17.id) (hfl_ne_v17 : fl.id ≠ v17.id)
    (hv18 : v18 = B.slot 10) (hsig_ne_v18 : sig.id ≠ v18.id)
    (hok_ne_v18 : ok.id ≠ v18.id) (hfl_ne_v18 : fl.id ≠ v18.id)
    (hv19 : v19 = B.slot 11) (hsig_ne_v19 : sig.id ≠ v19.id)
    (hok_ne_v19 : ok.id ≠ v19.id) (hfl_ne_v19 : fl.id ≠ v19.id)
    (hv20 : v20 = B.slot 12) (hsig_ne_v20 : sig.id ≠ v20.id)
    (hok_ne_v20 : ok.id ≠ v20.id) (hfl_ne_v20 : fl.id ≠ v20.id)
    (hRA : R.id ≠ A.id)
    (hfl_eq : (⟨flB, 0⟩ : Pointer) = fl) (htb_eq : (⟨tbB, 0⟩ : Pointer) = tb)
    (htb_lt : tb.id.id < B.alloc.nextFreeBlock)
    (htb_sha : tb.id ≠ sha.id) (hfl_sha : fl.id ≠ sha.id)
    (hmsg_off : ¬msg.offset.uaddOverflow msgSz) (hmsgSz : msgSz.toNat < 2 ^ 63)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hsig32 : ¬sig.offset.uaddOverflow 32#64) (hS_off : ¬(sig.add 32#64).offset.uaddOverflow 32#64)
    (hsha_off : ¬sha.offset.uaddOverflow 256#64)
    (hmsg_sha : msg.id ≠ sha.id) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hv : Ref.fd_curve25519_scalar_validate.spec sS = true)
    (hwf : S.WF) (hg : S.mem.Globals fd_r52x5_verify_core.globals)
    (hgf : S.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : S.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hset : S.mem.readAt fl 1 = 1#1)
    (hread_S : S.mem.readAt (sig.add 32#64) 256 = sS) (hread_r : S.mem.readAt sig 256 = r)
    (hread_pk : S.mem.readAt pk 256 = pkv) (hread_msg : S.mem.readAt msg (8 * msgSz.toNat) = msgv)
    (hread_buf : S.mem.readAt sha 1024 = buf0) (hread_ok : S.mem.readAt ok 32 = okv)
    (hqA : S.mem.readQuad5 A = Aq) (hread_R : S.mem.readQuad5 R = Rq)
    (hroom_Rc : Room S.mem Rc 1536)
    (hmsg : Fits S.mem msg (8 * msgSz.toNat)) (hsig : Fits S.mem sig (8 * 64))
    (hpk : Fits S.mem pk (8 * 32)) (hshaw : Writable S.mem sha) (hok : Fits S.mem ok 32)
    (hokw : Writable S.mem ok) (hfl : Fits S.mem fl 1) (hTB : TableAt S.mem tb 128 TB)
    (hsha_fits : Fits S.mem sha (8 * 256))
    (hwritable_k : Writable S.mem k) (hk_bounds : InBounds S.mem k 512)
    (hA_pt : S.mem.Quad5Room A) (hAf : S.mem.Quad5Fit A)
    (hRf : S.mem.Quad5Fit R)
    (hF : SlotFrame B 13 S.mem) (herase : S.mem.eraseFrom B.alloc.nextFreeBlock = M)
    (hKa : fd_r52x5_ge_is_small_order_affine.spec Aq ≠ 0#32 →
      PoisonOr.value (Vals.cons (PoisonOr.value (-2#32)) Vals.nil,
        { alloc := ⟨S.alloc.nextFreeBlock + 14⟩, mem := M }) = K)
    (hKb : fd_r52x5_ge_is_small_order_affine.spec Aq = 0#32 →
      fd_r52x5_ge_is_small_order_affine.spec Rq ≠ 0#32 →
      PoisonOr.value (Vals.cons (PoisonOr.value (-1#32)) Vals.nil,
        { alloc := ⟨S.alloc.nextFreeBlock + 28⟩, mem := M }) = K)
    (hKc : fd_r52x5_ge_is_small_order_affine.spec Aq = 0#32 →
      fd_r52x5_ge_is_small_order_affine.spec Rq = 0#32 → okv = 0#32 →
      PoisonOr.value (Vals.cons (PoisonOr.value 0#32) Vals.nil,
        { alloc := ⟨S.alloc.nextFreeBlock + 28⟩, mem := M }) = K)
    (hKd : fd_r52x5_ge_is_small_order_affine.spec Aq = 0#32 →
      fd_r52x5_ge_is_small_order_affine.spec Rq = 0#32 → okv ≠ 0#32 →
      let H := Firedancer.fd_ed25519_verify.hash buf0 r pkv msgSz msgv
      let kk := Ref.fd_curve25519_scalar_reduce.spec (Firedancer.Words8.bits H.2)
      PoisonOr.value
          (Vals.cons (PoisonOr.value 0#32) Vals.nil,
            { alloc := ⟨S.alloc.nextFreeBlock + 28 +
                  Firedancer.fd_ed25519_verify.hashBlocks buf0 r pkv msgSz msgv +
                  fd_r52x5_double_scalar_mul_base.blocks kk sS + 38⟩,
              mem := ((fd_sha512_init.stores M sha).storeSha sha H.1).storeAt ok
                (fd_r52x5_ge_eq_z1.spec
                  (fd_r52x5_double_scalar_mul_base.spec TB kk
                    (Quad5.laneIf 1 0 0 1 (fd_r52x5_quad_neg.spec Aq) Aq) sS) Rq) }) = K) :
    (do
        let p ← fd_r52x5_verify_core.runFrom E 14 S
        PoisonOr.value (p.1, { alloc := p.2.alloc, mem := p.2.mem.eraseFrom B.alloc.nextFreeBlock })) =
      K := by
  folded hA
  folded hR
  folded hRc
  folded hk
  folded hv16
  folded hv17
  folded hv18
  folded hv19
  folded hv20
  block_init
  step_call using fd_r52x5_ge_is_small_order_affine.call_eq
  step_pure
  finish_block
  case isFalse =>
    run_from using fd_r52x5_verify_core.exit_run
    subst hS
    erase_frame
    rw [herase]
    exact hKa (by simpa using hbr)
  have hsoA : fd_r52x5_ge_is_small_order_affine.spec Aq = 0#32 := by simpa using hbr
  clear hbr
  block_init
  step_call using fd_r52x5_ge_is_small_order_affine.call_eq
  step_pure
  finish_block
  case isFalse =>
    run_from using fd_r52x5_verify_core.exit_run
    subst hS
    erase_frame
    rw [herase]
    rw [Nat.add_assoc]
    exact hKb hsoA (by simpa using hbr)
  have hsoR : fd_r52x5_ge_is_small_order_affine.spec Rq = 0#32 := by simpa using hbr
  clear hbr
  block_init
  step_load
  step_pure
  finish_block
  case isTrue =>
    run_from using fd_r52x5_verify_core.exit_run
    subst hS
    erase_frame
    rw [herase]
    rw [Nat.add_assoc]
    exact hKc hsoA hsoR (by simpa using hbr)
  have hok0 : okv ≠ 0#32 := by simpa using hbr
  clear hbr
  have herase' : S.mem.eraseFrom B.alloc.nextFreeBlock = M := by rw [hS]; exact herase
  have hgf' : S.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image) := by rw [hS]; exact hgf
  have hgb' : S.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image) := by
    rw [hS]; exact hgb
  have hread_R' : S.mem.readQuad5 R = Rq := by assumption
  have hsS := congrArg (fun s : GlobalState => s.alloc.nextFreeBlock) hS
  simp only [Nat.add_assoc] at hsS
  clear herase hgf hgb hread_sig hread_sha hread_A hread_R
  apply fd_r52x5_verify_core.main_run (B := B) (msg := msg) (sig := sig) (pk := pk) (sha := sha)
    (ok := ok) (fl := fl) (tb := tb) (A := A) (R := R) (Rc := Rc) (k := k) (v16 := v16) (v17 := v17)
    (v18 := v18) (v19 := v19) (v20 := v20) (flB := flB) (tbB := tbB) (S := S) TB M Aq Rq buf0 r pkv sS
    msgv hArgs (by rw [hE]; lemma_reads)
      (hA := hA) (hsig_ne_A := hsig_ne_A) (hok_ne_A := hok_ne_A) (hfl_ne_A := hfl_ne_A)
      (hsha_ne_A := hsha_ne_A) (hR := hR) (hok_ne_R := hok_ne_R) (hsha_ne_R := hsha_ne_R)
      (hRc := hRc) (hRc_off := hRc_off) (hok_ne_Rc := hok_ne_Rc) (hk := hk) (hk_off := hk_off)
      (hmsg_ne_k := hmsg_ne_k) (hsig_ne_k := hsig_ne_k) (hpk_ne_k := hpk_ne_k)
      (hok_ne_k := hok_ne_k) (hfl_ne_k := hfl_ne_k) (hsha_ne_k := hsha_ne_k) (hv16 := hv16)
      (hsig_ne_v16 := hsig_ne_v16)
      (hok_ne_v16 := hok_ne_v16) (hfl_ne_v16 := hfl_ne_v16)
      (hv17 := hv17) (hsig_ne_v17 := hsig_ne_v17)
      (hok_ne_v17 := hok_ne_v17) (hfl_ne_v17 := hfl_ne_v17)
      (hv18 := hv18)
      (hsig_ne_v18 := hsig_ne_v18) (hok_ne_v18 := hok_ne_v18)
      (hfl_ne_v18 := hfl_ne_v18) (hv19 := hv19)
      (hsig_ne_v19 := hsig_ne_v19)
      (hok_ne_v19 := hok_ne_v19) (hfl_ne_v19 := hfl_ne_v19)
      (hv20 := hv20) (hsig_ne_v20 := hsig_ne_v20)
      (hok_ne_v20 := hok_ne_v20) (hfl_ne_v20 := hfl_ne_v20)
      (hRA := hRA) (hfl_eq := hfl_eq) (htb_eq := htb_eq)
      (htb_lt := htb_lt) (htb_sha := htb_sha) (hfl_sha := hfl_sha) (hmsg_off := hmsg_off)
      (hmsgSz := hmsgSz) (hsig_off := hsig_off) (hpk_off := hpk_off) (hsig32 := hsig32)
      (hS_off := hS_off) (hsha_off := hsha_off) (hmsg_sha := hmsg_sha) (hsig_sha := hsig_sha)
      (hpk_sha := hpk_sha) (hv := hv) (hwf := hwf) (hg := hg) (hgf := hgf') (hgb := hgb')
      (hset := hset) (hread_S := hread_S) (hread_r := hread_r) (hread_pk := hread_pk)
      (hread_msg := hread_msg) (hread_buf := hread_buf) (hqA := hqA) (hread_R := hread_R')
      (hroom_Rc := hroom_Rc) (hmsg := hmsg) (hsig := hsig) (hpk := hpk) (hshaw := hshaw)
      (hok := hok) (hokw := hokw) (hfl := hfl) (hTB := hTB) (hsha_fits := hsha_fits)
      (hwritable_k := hwritable_k) (hk_bounds := hk_bounds) (hA_pt := hA_pt) (hAf := hAf)
      (hRf := hRf) (hF := hF) (herase := herase')
  dsimp only
  rw [hsS]
  exact hKd hsoA hsoR hok0

open fd_r52x5_double_scalar_mul_base in
/-- `^bb12` on: the decode, its failure's exits, then `checks_run`. -/
theorem fd_r52x5_verify_core.decode_run (E₀ : ⟪fd_r52x5_verify_core.Γ⟫)
    (msg : Pointer) (msgSz : BitVec 64) (sig pk sha ok : Pointer) (TB : ℕ → Quad5)
    (flB tbB : BlockId) (hmsg_off : ¬msg.offset.uaddOverflow msgSz = true)
    (hmsgSz : msgSz.toNat < 2 ^ 63) (hsig_off : ¬sig.offset.uaddOverflow 64#64 = true)
    (hpk_off : ¬pk.offset.uaddOverflow 32#64 = true) (hmsg_sha : msg.id ≠ sha.id)
    (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id) (res : fd_r52x5_verify_core.Result)
    (S₀ : GlobalState) (fl : Pointer) (hfl_eq : { id := flB, offset := 0 } = fl) (tb : Pointer)
    (htb_eq : { id := tbB, offset := 0 } = tb) (htb_lt : tb.id.id < S₀.alloc.nextFreeBlock)
    (htb_sha : tb.id ≠ sha.id) (hfl_sha : fl.id ≠ sha.id)
    (hS_off : ¬(sig.add 32#64).offset.uaddOverflow 32#64 = true)
    (hsha_off : ¬sha.offset.uaddOverflow 256#64 = true) (A : Pointer) (hA : A = S₀.slot 0)
    (hmsg_ne_A : msg.id ≠ A.id) (hsig_ne_A : sig.id ≠ A.id) (hpk_ne_A : pk.id ≠ A.id)
    (hok_ne_A : ok.id ≠ A.id) (hfl_ne_A : fl.id ≠ A.id) (hsha_ne_A : sha.id ≠ A.id) (R : Pointer)
    (hR : R = S₀.slot 1) (hmsg_ne_R : msg.id ≠ R.id) (hsig_ne_R : sig.id ≠ R.id)
    (hpk_ne_R : pk.id ≠ R.id) (hok_ne_R : ok.id ≠ R.id) (hfl_ne_R : fl.id ≠ R.id)
    (hsha_ne_R : sha.id ≠ R.id) (Rc : Pointer) (hRc : Rc = S₀.slot 2) (hok_ne_Rc : ok.id ≠ Rc.id)
    (hRc_off : Rc.offset = 0) (v11 : Pointer) (hv11 : v11 = S₀.slot 3) (v12 : Pointer)
    (hv12 : v12 = S₀.slot 4) (v13 : Pointer) (hv13 : v13 = S₀.slot 5) (v14 : Pointer)
    (hv14 : v14 = S₀.slot 6) (k : Pointer) (hk : k = S₀.slot 7) (hmsg_ne_k : msg.id ≠ k.id)
    (hsig_ne_k : sig.id ≠ k.id) (hpk_ne_k : pk.id ≠ k.id) (hok_ne_k : ok.id ≠ k.id)
    (hfl_ne_k : fl.id ≠ k.id) (hsha_ne_k : sha.id ≠ k.id) (hk_off : k.offset = 0) (v16 : Pointer)
    (hv16 : v16 = S₀.slot 8) (hsig_ne_v16 : sig.id ≠ v16.id) (hok_ne_v16 : ok.id ≠ v16.id)
    (hfl_ne_v16 : fl.id ≠ v16.id) (v17 : Pointer) (hv17 : v17 = S₀.slot 9)
    (hsig_ne_v17 : sig.id ≠ v17.id) (hok_ne_v17 : ok.id ≠ v17.id) (hfl_ne_v17 : fl.id ≠ v17.id)
    (v18 : Pointer) (hv18 : v18 = S₀.slot 10) (hsig_ne_v18 : sig.id ≠ v18.id)
    (hok_ne_v18 : ok.id ≠ v18.id) (hfl_ne_v18 : fl.id ≠ v18.id) (v19 : Pointer)
    (hv19 : v19 = S₀.slot 11) (hsig_ne_v19 : sig.id ≠ v19.id) (hok_ne_v19 : ok.id ≠ v19.id)
    (hfl_ne_v19 : fl.id ≠ v19.id) (v20 : Pointer) (hv20 : v20 = S₀.slot 12)
    (hsig_ne_v20 : sig.id ≠ v20.id) (hok_ne_v20 : ok.id ≠ v20.id) (hfl_ne_v20 : fl.id ≠ v20.id)
    (hv : Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = true)
    (hnv : (!Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)) ≠ true)
    (hsig32 : ¬sig.offset.uaddOverflow 32#64 = true) (S : GlobalState)
    (hroom_Rc : Room S.mem Rc 1536) (hset : S.mem.readAt fl 1 = 1#1)
    (hread_S : S.mem.readAt (sig.add 32#64) 256 = S₀.mem.readAt (sig.add 32#64) 256)
    (hread_r : S.mem.readAt sig 256 = S₀.mem.readAt sig 256)
    (hread_pk : S.mem.readAt pk 256 = S₀.mem.readAt pk 256)
    (hread_msg : S.mem.readAt msg (8 * msgSz.toNat) = S₀.mem.readAt msg (8 * msgSz.toNat))
    (hread_buf : S.mem.readAt sha 1024 = S₀.mem.readAt sha 1024)
    (hread_ok : S.mem.readAt ok 32 = S₀.mem.readAt ok 32) (hwf : S.WF)
    (hg : S.mem.Globals fd_r52x5_verify_core.globals)
    (hgf : S.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" = some (flB,
      fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : S.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hmsg : Fits S.mem msg (8 * msgSz.toNat)) (hsig : Fits S.mem sig (8 * 64))
    (hpk : Fits S.mem pk (8 * 32)) (hshaw : Writable S.mem sha) (hok : Fits S.mem ok 32)
    (hokw : Writable S.mem ok) (hfl : Fits S.mem fl 1) (hTB : TableAt S.mem tb 128 TB)
    (hsha_fits : Fits S.mem sha (8 * 256)) (hwritable_A : Writable S.mem A)
    (hA_bounds : InBounds S.mem A 1536) (hwritable_R : Writable S.mem R)
    (hR_bounds : InBounds S.mem R 1536) (hwritable_Rc : Writable S.mem Rc)
    (hRc_bounds : InBounds S.mem Rc 1536) (hwritable_v11 : Writable S.mem v11)
    (hv11_bounds : InBounds S.mem v11 512) (hwritable_v12 : Writable S.mem v12)
    (hv12_bounds : InBounds S.mem v12 320) (hwritable_v13 : Writable S.mem v13)
    (hv13_bounds : InBounds S.mem v13 320) (hwritable_v14 : Writable S.mem v14)
    (hv14_bounds : InBounds S.mem v14 256) (hwritable_k : Writable S.mem k)
    (hk_bounds : InBounds S.mem k 512) (hwritable_v16 : Writable S.mem v16)
    (hv16_bounds : InBounds S.mem v16 256) (hwritable_v17 : Writable S.mem v17)
    (hv17_bounds : InBounds S.mem v17 256) (hwritable_v18 : Writable S.mem v18)
    (hv18_bounds : InBounds S.mem v18 256) (hwritable_v19 : Writable S.mem v19)
    (hv19_bounds : InBounds S.mem v19 256) (hwritable_v20 : Writable S.mem v20)
    (hv20_bounds : InBounds S.mem v20 256) (E : ⟪fd_r52x5_verify_core.Γ⟫)
    (hArgs : E.args = (fd_r52x5_verify_core.args (.value msg) (.value msgSz) (.value sig) (.value
      pk) (.value sha) (.value Pointer.null) (.value ok) (.value Pointer.null)).get)
    (hE : E = E₀[%2316 := .value 1#32, %2317 := .value 32#64, %2318 := .value Pointer.null, %2319 :=
      .value 4294967295#32, %2320 := .value 0#32, %2321 := .value 4294967294#32, %2322 := .value
      2#32, %2323 := .value 192#64, %2324 := .value A, %2325 := .value R, %2326 := .value Rc, %2327
      := .value v11, %2328 := .value v12, %2329 := .value v13, %2330 := .value v14, %2331 := .value
      k, %2332 := .value v16, %2333 := .value v17, %2334 := .value v18, %2335 := .value v19, %2336
      := .value v20, %2337 := .value (sig.add 32#64), %2340 := .value 1#1])
    (hA_pt : S.mem.Quad5Room A) (hR_pt : S.mem.Quad5Room R) (hRA : R.id ≠ A.id)
    (hpk_n : pk.offset.toNat + 32 < 2 ^ 64) (hsig_n : sig.offset.toNat + 32 < 2 ^ 64)
    (hres : fd_r52x5_verify_core.spec TB msgSz (S₀.mem.readAt msg (8 * msgSz.toNat))
      (S₀.mem.readAt sig 256) (S₀.mem.readAt (sig.add 32#64) 256) (S₀.mem.readAt pk 256)
      (S₀.mem.readAt sha 1024) (S₀.mem.readAt ok 32) = res)
    (herase0 : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem)
    (halloc0 : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 13)
    {K : PoisonOr (Vals fd_r52x5_verify_core.tRets × GlobalState)}
    (hK : PoisonOr.value
        (.cons (.value res.ret) .nil,
          { alloc := ⟨S₀.alloc.nextFreeBlock + res.blocks⟩, mem := res.mem S₀.mem sha ok }) = K) :
    (do
        let p ← fd_r52x5_verify_core.runFrom E 12 S
        PoisonOr.value (p.1, { alloc := p.2.alloc, mem := p.2.mem.eraseFrom S₀.alloc.nextFreeBlock })) =
      K := by
  subst hK
  folded hA
  folded hR
  folded hRc
  folded hv11
  folded hv12
  folded hv13
  folded hv14
  folded hk
  folded hv16
  folded hv17
  folded hv18
  folded hv19
  folded hv20
  block_init
  have hA₁ : ∀ m, m = S.mem → m.Quad5Room A := fun _ h => h ▸ hA_pt
  have hR₁ : ∀ m, m = S.mem → m.Quad5Room R := fun _ h => h ▸ hR_pt
  step_call using fd_r52x5_ge_decode2.call_eq
  any_goals
    subst hS'
    first
    | exact fd_r52x5_ge_decode2.Globals.storeOut hg
    | exact fd_r52x5_ge_decode2.Writable.storeOut (by assumption)
  obtain ⟨⟨dres, dP⟩, hdec⟩ :
    ∃ t, fd_r52x5_ge_decode2.spec (S₀.mem.readAt pk 256) (S₀.mem.readAt sig 256) = t :=
    ⟨_, rfl⟩
  rw [hdec] at hS hE
  dsimp only at hE
  rcases dP with _ | ⟨Aq, Rq⟩
  · -- a decoding failed
    have hdn := fd_r52x5_ge_decode2.spec_none hdec
    simp only [fd_r52x5_ge_decode2.storeOut_none] at hS
    rw [fd_r52x5_verify_core.spec, ite_eq_right hnv, hdec] at hres
    dsimp only at hres
    subst hres
    refine fd_r52x5_verify_core.none_run (E := E) (S := S) (A := A) (R := R) (Rc := Rc) (M := S₀.mem)
      (by rw [hE]; lemma_reads) hdn (by rw [hS]; erase_frame; exact herase0) (fun h => ?_) (fun h => ?_)
    · rw [hS]
      simp only [h, fd_r52x5_verify_core.Result.mem, halloc0, ite_true, Nat.add_assoc]
    · rw [hS]
      simp only [h, fd_r52x5_verify_core.Result.mem, halloc0, ite_false, Nat.add_assoc]
  have hd3 := fd_r52x5_ge_decode2.spec_some hdec
  subst hd3
  simp only [fd_r52x5_ge_decode2.storeOut_some] at hS
  have hread_A : S.mem.readQuad5 A = Aq := by
    rw [hS]
    dsimp only
    rw [MemoryState.readQuad5_storeQuad5_of_id_ne hRA, MemoryState.readQuad5_storeQuad5_self (hA₁ _ rfl)]
  have hread_R : S.mem.readQuad5 R = Rq := by
    rw [hS]
    dsimp only
    rw [MemoryState.readQuad5_storeQuad5_self ((hR₁ _ rfl).storeQuad5)]
  have hAf : S.mem.Quad5Fit A := by
    rw [hS]
    exact (MemoryState.Quad5Fit.storeQuad5_self (hA₁ _ rfl)).storeQuad5
  have hRf : S.mem.Quad5Fit R := by
    rw [hS]
    exact MemoryState.Quad5Fit.storeQuad5_self (hR₁ _ rfl).storeQuad5
  clear hR₁
  have hspec : ∀ X, res = X → fd_r52x5_verify_core.spec TB msgSz (S₀.mem.readAt msg (8 * msgSz.toNat))
      (S₀.mem.readAt sig 256) (S₀.mem.readAt (sig.add 32#64) 256) (S₀.mem.readAt pk 256)
      (S₀.mem.readAt sha 1024) (S₀.mem.readAt ok 32) = X := fun X h => hres.trans h
  clear hres
  step_pure
  step_pure
  finish_block
  block_init
  step_pure
  finish_block
  have herase : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
    rw [hS]
    erase_frame
    exact herase0
  have halloc : S.alloc.nextFreeBlock =
      S₀.alloc.nextFreeBlock + 13 + fd_r52x5_ge_decode2.blocks (3, some (Aq, Rq)) := by
    rw [hS]
    simp only [halloc0]
  have hgfS : S.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image) := by
    rw [hS]; exact hgf
  have hgbS : S.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image) := by
    rw [hS]; exact hgb
  clear hgf hgb hA₁
  have hF : SlotFrame S₀ 13 S.mem := by
    intro j hj
    obtain h | h | h | h | h | h | h | h | h | h | h | h | h :
        j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 ∨ j = 4 ∨ j = 5 ∨ j = 6 ∨ j = 7 ∨ j = 8 ∨ j = 9 ∨ j = 10 ∨
          j = 11 ∨ j = 12 := by omega
    all_goals subst h
    · exact hA ▸ ⟨hA_bounds.mono (by decide), hwritable_A⟩
    · exact hR ▸ ⟨hR_bounds.mono (by decide), hwritable_R⟩
    · exact hRc ▸ ⟨hRc_bounds.mono (by decide), hwritable_Rc⟩
    · exact hv11 ▸ ⟨hv11_bounds.mono (by decide), hwritable_v11⟩
    · exact hv12 ▸ ⟨hv12_bounds.mono (by decide), hwritable_v12⟩
    · exact hv13 ▸ ⟨hv13_bounds.mono (by decide), hwritable_v13⟩
    · exact hv14 ▸ ⟨hv14_bounds, hwritable_v14⟩
    · exact hk ▸ ⟨hk_bounds.mono (by decide), hwritable_k⟩
    · exact hv16 ▸ ⟨hv16_bounds, hwritable_v16⟩
    · exact hv17 ▸ ⟨hv17_bounds, hwritable_v17⟩
    · exact hv18 ▸ ⟨hv18_bounds, hwritable_v18⟩
    · exact hv19 ▸ ⟨hv19_bounds, hwritable_v19⟩
    · exact hv20 ▸ ⟨hv20_bounds, hwritable_v20⟩
  have h := hspec _ rfl
  clear hspec
  rw [fd_r52x5_verify_core.spec, ite_eq_right hnv, hdec] at h
  dsimp only at h
  subst h
  apply fd_r52x5_verify_core.checks_run (B := S₀) (msg := msg) (sig := sig) (pk := pk) (sha := sha)
    (ok := ok) (fl := fl) (tb := tb) (A := A) (R := R) (Rc := Rc) (k := k) (v16 := v16) (v17 := v17)
    (v18 := v18) (v19 := v19) (v20 := v20) (flB := flB) (tbB := tbB) (S := S) TB S₀.mem Aq Rq
    (S₀.mem.readAt ok 32) (S₀.mem.readAt sha 1024)
    (S₀.mem.readAt sig 256) (S₀.mem.readAt pk 256) (S₀.mem.readAt (sig.add 32#64) 256)
    (S₀.mem.readAt msg (8 * msgSz.toNat)) hArgs (by rw [hE]; lemma_reads)
    (hA := hA) (hsig_ne_A := hsig_ne_A) (hok_ne_A := hok_ne_A) (hfl_ne_A := hfl_ne_A)
    (hsha_ne_A := hsha_ne_A) (hR := hR) (hok_ne_R := hok_ne_R) (hsha_ne_R := hsha_ne_R)
    (hRc := hRc) (hRc_off := hRc_off) (hok_ne_Rc := hok_ne_Rc) (hk := hk) (hk_off := hk_off)
    (hmsg_ne_k := hmsg_ne_k) (hsig_ne_k := hsig_ne_k) (hpk_ne_k := hpk_ne_k)
    (hok_ne_k := hok_ne_k) (hfl_ne_k := hfl_ne_k) (hsha_ne_k := hsha_ne_k) (hv16 := hv16)
    (hsig_ne_v16 := hsig_ne_v16)
    (hok_ne_v16 := hok_ne_v16) (hfl_ne_v16 := hfl_ne_v16)
    (hv17 := hv17) (hsig_ne_v17 := hsig_ne_v17)
    (hok_ne_v17 := hok_ne_v17) (hfl_ne_v17 := hfl_ne_v17)
    (hv18 := hv18)
    (hsig_ne_v18 := hsig_ne_v18) (hok_ne_v18 := hok_ne_v18)
    (hfl_ne_v18 := hfl_ne_v18) (hv19 := hv19)
    (hsig_ne_v19 := hsig_ne_v19)
    (hok_ne_v19 := hok_ne_v19) (hfl_ne_v19 := hfl_ne_v19)
    (hv20 := hv20) (hsig_ne_v20 := hsig_ne_v20)
    (hok_ne_v20 := hok_ne_v20) (hfl_ne_v20 := hfl_ne_v20)
    (hRA := hRA) (hfl_eq := hfl_eq) (htb_eq := htb_eq)
    (htb_lt := htb_lt) (htb_sha := htb_sha) (hfl_sha := hfl_sha) (hmsg_off := hmsg_off)
    (hmsgSz := hmsgSz) (hsig_off := hsig_off) (hpk_off := hpk_off) (hsig32 := hsig32)
    (hS_off := hS_off) (hsha_off := hsha_off) (hmsg_sha := hmsg_sha) (hsig_sha := hsig_sha)
    (hpk_sha := hpk_sha) (hv := hv) (hwf := hwf) (hg := hg) (hgf := hgfS) (hgb := hgbS)
    (hset := hset) (hread_S := hread_S) (hread_r := hread_r) (hread_pk := hread_pk)
    (hread_msg := hread_msg) (hread_buf := hread_buf) (hread_ok := hread_ok) (hqA := hread_A)
    (hread_R := hread_R) (hroom_Rc := hroom_Rc) (hmsg := hmsg) (hsig := hsig) (hpk := hpk)
    (hshaw := hshaw) (hok := hok) (hokw := hokw) (hfl := hfl) (hTB := hTB)
    (hsha_fits := hsha_fits) (hwritable_k := hwritable_k) (hk_bounds := hk_bounds)
    (hA_pt := hA_pt) (hAf := hAf) (hRf := hRf) (hF := hF) (herase := herase)
  · intro h
    simp only [h, halloc, fd_r52x5_verify_core.Result.mem, ne_eq, not_false_eq_true, ite_true,
      Nat.add_assoc]
  · intro h1 h2
    simp only [h1, h2, halloc, fd_r52x5_verify_core.Result.mem, ne_eq, not_true_eq_false,
      not_false_eq_true, ite_true, ite_false, Nat.add_assoc]
  · intro h1 h2 h3
    simp only [h1, h2, h3, halloc, fd_r52x5_verify_core.Result.mem, ne_eq, not_true_eq_false,
      ite_true, ite_false, Nat.add_assoc]
  · intro h1 h2 h3
    obtain ⟨⟨sha4, kw⟩, hH⟩ :
      ∃ H,
        Firedancer.fd_ed25519_verify.hash (S₀.mem.readAt sha 1024) (S₀.mem.readAt sig 256)
            (S₀.mem.readAt pk 256) msgSz (S₀.mem.readAt msg (8 * msgSz.toNat)) =
          H :=
      ⟨_, rfl⟩
    simp only [h1, h2, h3, hH, halloc, fd_r52x5_verify_core.Result.mem, ne_eq, not_true_eq_false,
      ite_false, Nat.add_assoc]


open fd_r52x5_double_scalar_mul_base in
public theorem fd_r52x5_verify_core.call_eq (msg : Pointer) (msgSz : BitVec 64)
    (sig pk sha ok : Pointer) (TB : Nat → Quad5) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_r52x5_verify_core.globals) (flB tbB : BlockId)
    (hgf : s.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : s.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hfl : Fits s.mem ⟨flB, 0⟩ 1) (hset : s.mem.readAt ⟨flB, 0⟩ 1 = 1)
    (hTB : TableAt s.mem ⟨tbB, 0⟩ 128 TB)
    (hmsg : Fits s.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hmsgSz : msgSz.toNat < 2 ^ 63) (hsig : Fits s.mem sig (8 * 64))
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits s.mem pk (8 * 32))
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha)
    (hok : Fits s.mem ok 32) (hokw : Writable s.mem ok)
    (hmsg_sha : msg.id ≠ sha.id) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hsha_fl : sha.id ≠ flB) (hsha_tb : sha.id ≠ tbB) :
    fd_r52x5_verify_core.call
        (fd_r52x5_verify_core.args (.value msg) (.value msgSz) (.value sig) (.value pk)
          (.value sha) (.value Pointer.null) (.value ok) (.value Pointer.null))
        s =
      let res :=
        fd_r52x5_verify_core.spec TB msgSz (s.mem.readAt msg (8 * msgSz.toNat))
          (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
          (s.mem.readAt sha 1024) (s.mem.readAt ok 32)
      .value
        (.cons (.value res.ret) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + res.blocks⟩, mem := res.mem s.mem sha ok }) := by
  dsimp only
  generalize hres :
    fd_r52x5_verify_core.spec TB msgSz (s.mem.readAt msg (8 * msgSz.toNat))
      (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
      (s.mem.readAt sha 1024) (s.mem.readAt ok 32) = res
  func_init
  rw [hS] at hres
  generalize hfl_eq : (⟨flB, 0⟩ : Pointer) = fl at hfl hset hfl₀
  generalize htb_eq : (⟨tbB, 0⟩ : Pointer) = tb at hTB
  have htb_lt : tb.id.id < S₀.alloc.nextFreeBlock := by
    rw [← htb_eq]; exact hwf₀.global_lt (hS ▸ hgb)
  have hfl_lt : fl.id.id < S₀.alloc.nextFreeBlock := by
    rw [← hfl_eq]; exact hwf₀.global_lt (hS ▸ hgf)
  have htb_sha : tb.id ≠ sha.id := by rw [← htb_eq]; exact fun h => hsha_tb h.symm
  have hfl_sha : fl.id ≠ sha.id := by rw [← hfl_eq]; exact fun h => hsha_fl h.symm
  have hS_off : ¬(sig.add 32#64).offset.uaddOverflow 32#64 :=
    Pointer.not_uaddOverflow_add_sub (a := 32#64) (b := 64#64) hsig_off (by decide)
  obtain ⟨hsha_fits, hsha_off⟩ := hsha
  block_init
  iterate 8 step_pure
  step_alloca with A
  step_alloca with R
  step_alloca with Rc
  iterate 4 step_alloca
  step_alloca with k
  iterate 5 step_alloca
  -- the entry's reads past the `alloca`s, stated after them so the steps do not carry them
  have hS13 : S.mem = (fd_r52x5_ge_decode2.allocas S₀ [192, 192, 192, 64, 40, 40, 32, 64, 32, 32, 32,
      32, 32]).mem := by rw [hS]; rfl
  have hlt {p : Pointer} {w : Nat} (h : Fits S₀.mem p w) : p.id.id < S₀.alloc.nextFreeBlock :=
    hwf₀.lt h.mem
  have hread_S : S.mem.readAt (sig.add 32#64) 256 = S₀.mem.readAt (sig.add 32#64) 256 := by
    rw [hS13]; exact fd_r52x5_verify_core.readAt_allocas (by simpa [Pointer.add_id] using hlt hsig₀) _
  have hread_r : S.mem.readAt sig 256 = S₀.mem.readAt sig 256 := by
    rw [hS13]; exact fd_r52x5_verify_core.readAt_allocas (hlt hsig₀) _
  have hread_pk : S.mem.readAt pk 256 = S₀.mem.readAt pk 256 := by
    rw [hS13]; exact fd_r52x5_verify_core.readAt_allocas (hlt hpk₀) _
  have hread_msg : S.mem.readAt msg (8 * msgSz.toNat) = S₀.mem.readAt msg (8 * msgSz.toNat) := by
    rw [hS13]; exact fd_r52x5_verify_core.readAt_allocas (hlt hmsg₀) _
  have hread_buf : S.mem.readAt sha 1024 = S₀.mem.readAt sha 1024 := by
    rw [hS13]; exact fd_r52x5_verify_core.readAt_allocas (hlt hsha₀) _
  have hread_ok : S.mem.readAt ok 32 = S₀.mem.readAt ok 32 := by
    rw [hS13]; exact fd_r52x5_verify_core.readAt_allocas (hlt hok₀) _
  clear hS13 hlt
  step_pure
  step_call using fd_curve25519_scalar_validate.call_eq
  step_pure
  finish_block
  case isTrue =>
    have hv :
      Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = false := by
      have hne := Pointer.add_ne_null (a := 32#64) hsig_off (by decide) (by decide)
      cases hc : Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)
      · rfl
      · simp [hc, hne] at hbr
    block_init
    finish_block
    subst hS hres
    erase_frame
    simp [fd_r52x5_verify_core.spec, hv, fd_r52x5_verify_core.Result.mem]
  case isFalse =>
    have hv :
      Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256) = true := by
      cases hc : Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)
      · simp [hc] at hbr
      · rfl
    clear hbr
    have hnv :
      (!Ref.fd_curve25519_scalar_validate.spec (S₀.mem.readAt (sig.add 32#64) 256)) ≠ true := by
      rw [hv]
      decide
    have hsig32 : ¬sig.offset.uaddOverflow 32#64 :=
      BitVec.not_uaddOverflow_of_le hsig_off (by decide)
    block_init
    iterate 3 step_pure
    step_pure
    finish_block
    have hA_pt := MemoryState.Quad5Room.of_room (hroom_A.mono (by decide)) hA_off
    have hR_pt := MemoryState.Quad5Room.of_room (hroom_R.mono (by decide)) hR_off
    clear hroom_A hroom_R
    have hRA : R.id ≠ A.id := by simp [hA, hR, GlobalState.slot]
    have hpk_n : pk.offset.toNat + 32 < 2 ^ 64 := by
      simp only [BitVec.uaddOverflow, decide_eq_true_eq, BitVec.toNat_ofNat] at hpk_off; omega
    have hsig_n : sig.offset.toNat + 32 < 2 ^ 64 := by
      simp only [BitVec.uaddOverflow, decide_eq_true_eq, BitVec.toNat_ofNat] at hsig32; omega
    have herase0 : S.mem.eraseFrom S₀.alloc.nextFreeBlock = S₀.mem := by
      rw [hS]
      erase_frame
    have halloc0 : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 13 := by
      rw [hS]
      simp only [GlobalState.alloca_alloc]
    clear hS
    exact fd_r52x5_verify_core.decode_run E₀
      (msg := msg) (msgSz := msgSz) (sig := sig) (pk := pk) (sha := sha) (ok := ok) (TB := TB)
      (flB := flB) (tbB := tbB) (hmsg_off := hmsg_off) (hmsgSz := hmsgSz) (hsig_off := hsig_off)
      (hpk_off := hpk_off) (hmsg_sha := hmsg_sha) (hsig_sha := hsig_sha) (hpk_sha := hpk_sha)
      (res := res) (S₀ := S₀) (fl := fl) (hfl_eq := hfl_eq) (tb := tb) (htb_eq := htb_eq)
      (htb_lt := htb_lt) (htb_sha := htb_sha) (hfl_sha := hfl_sha) (hS_off := hS_off)
      (hsha_off := hsha_off) (A := A) (hA := hA) (hmsg_ne_A := hmsg_ne_A) (hsig_ne_A := hsig_ne_A)
      (hpk_ne_A := hpk_ne_A) (hok_ne_A := hok_ne_A) (hfl_ne_A := hfl_ne_A)
      (hsha_ne_A := hsha_ne_A) (R := R) (hR := hR) (hmsg_ne_R := hmsg_ne_R)
      (hsig_ne_R := hsig_ne_R) (hpk_ne_R := hpk_ne_R) (hok_ne_R := hok_ne_R)
      (hfl_ne_R := hfl_ne_R) (hsha_ne_R := hsha_ne_R) (Rc := Rc) (hRc := hRc)
      (hok_ne_Rc := hok_ne_Rc) (hRc_off := hRc_off) (v11 := v11) (hv11 := hv11) (v12 := v12)
      (hv12 := hv12) (v13 := v13) (hv13 := hv13) (v14 := v14) (hv14 := hv14) (k := k) (hk := hk)
      (hmsg_ne_k := hmsg_ne_k) (hsig_ne_k := hsig_ne_k) (hpk_ne_k := hpk_ne_k)
      (hok_ne_k := hok_ne_k) (hfl_ne_k := hfl_ne_k) (hsha_ne_k := hsha_ne_k) (hk_off := hk_off)
      (v16 := v16) (hv16 := hv16) (hsig_ne_v16 := hsig_ne_v16) (hok_ne_v16 := hok_ne_v16)
      (hfl_ne_v16 := hfl_ne_v16) (v17 := v17) (hv17 := hv17) (hsig_ne_v17 := hsig_ne_v17)
      (hok_ne_v17 := hok_ne_v17) (hfl_ne_v17 := hfl_ne_v17) (v18 := v18) (hv18 := hv18)
      (hsig_ne_v18 := hsig_ne_v18) (hok_ne_v18 := hok_ne_v18) (hfl_ne_v18 := hfl_ne_v18)
      (v19 := v19) (hv19 := hv19) (hsig_ne_v19 := hsig_ne_v19) (hok_ne_v19 := hok_ne_v19)
      (hfl_ne_v19 := hfl_ne_v19) (v20 := v20) (hv20 := hv20) (hsig_ne_v20 := hsig_ne_v20)
      (hok_ne_v20 := hok_ne_v20) (hfl_ne_v20 := hfl_ne_v20) (hv := hv) (hnv := hnv)
      (hsig32 := hsig32) (S := S) (hroom_Rc := hroom_Rc) (hset := hset) (hread_S := hread_S)
      (hread_r := hread_r) (hread_pk := hread_pk) (hread_msg := hread_msg)
      (hread_buf := hread_buf) (hread_ok := hread_ok) (hwf := hwf) (hg := hg) (hgf := hgf)
      (hgb := hgb) (hmsg := hmsg) (hsig := hsig) (hpk := hpk) (hshaw := hshaw) (hok := hok)
      (hokw := hokw) (hfl := hfl) (hTB := hTB) (hsha_fits := hsha_fits)
      (hwritable_A := hwritable_A) (hA_bounds := hA_bounds) (hwritable_R := hwritable_R)
      (hR_bounds := hR_bounds) (hwritable_Rc := hwritable_Rc) (hRc_bounds := hRc_bounds)
      (hwritable_v11 := hwritable_v11) (hv11_bounds := hv11_bounds)
      (hwritable_v12 := hwritable_v12) (hv12_bounds := hv12_bounds)
      (hwritable_v13 := hwritable_v13) (hv13_bounds := hv13_bounds)
      (hwritable_v14 := hwritable_v14) (hv14_bounds := hv14_bounds) (hwritable_k := hwritable_k)
      (hk_bounds := hk_bounds) (hwritable_v16 := hwritable_v16) (hv16_bounds := hv16_bounds)
      (hwritable_v17 := hwritable_v17) (hv17_bounds := hv17_bounds)
      (hwritable_v18 := hwritable_v18) (hv18_bounds := hv18_bounds)
      (hwritable_v19 := hwritable_v19) (hv19_bounds := hv19_bounds)
      (hwritable_v20 := hwritable_v20) (hv20_bounds := hv20_bounds) (E := E) (hArgs := hArgs)
      (hE := hE) (hA_pt := hA_pt) (hR_pt := hR_pt) (hRA := hRA) (hpk_n := hpk_n)
      (hsig_n := hsig_n)
      (hres := hres) (herase0 := herase0) (halloc0 := halloc0) (hK := rfl)

end Proof

end MLIR.Firedancer.Crc.Verify
