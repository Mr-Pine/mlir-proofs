module

public import Firedancer.Crc.Verify.VerifyCore.Main
public import Firedancer.Crc.Verify.Mlir.fd_ed25519_verify

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5
open MLIR.Firedancer (fd_sha512_init.stores)

@[expose] public section

/-- `fd_ed25519_verify` on the signature halves `r`, `S`, the key, the message, the hash object's
buffer `buf0` and the base table `TB`: `fd_r52x5_verify_core` with `ok = 1`, its code when it is
nonzero, else `-3` when `ok` comes back `0`. -/
noncomputable def fd_ed25519_verify.spec (TB : Nat → Quad5) (msgSz : BitVec 64)
    (msg : BitVec (8 * msgSz.toNat)) (r S publicKey : BitVec 256) (buf0 : BitVec 1024) :
    Firedancer.fd_ed25519_verify.Result :=
  let R := fd_r52x5_verify_core.spec TB msgSz msg r S publicKey buf0 1#32
  match R.out with
  | none => ⟨R.ret, none, 1 + R.blocks⟩
  | some (X, e) => ⟨if R.ret = 0#32 then (if e = 0#32 then -3#32 else 0#32) else R.ret, some X,
      1 + R.blocks⟩

end

section Proof

theorem fd_r52x5_verify_core.WF_mem {s : GlobalState} (h : s.WF) (R : fd_r52x5_verify_core.Result) :
    (⟨⟨s.alloc.nextFreeBlock + R.blocks⟩, R.mem s.mem sha ok⟩ : GlobalState).WF := by
  have h1 : (⟨⟨s.alloc.nextFreeBlock + R.blocks⟩, s.mem⟩ : GlobalState).WF := h.add_blocks
  unfold fd_r52x5_verify_core.Result.mem
  rcases R with ⟨_, _ | ⟨X, e⟩, _⟩
  · exact h1
  · simp only [fd_sha512_init.stores]
    exact GlobalState.WF.storeAt (GlobalState.WF.storeSha (s := ⟨_, _⟩)
      (h1.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt))

attribute [local mlir_transport] fd_r52x5_verify_core.WF_mem

attribute [local mlir_transport] fd_r52x5_double_scalar_mul_base.TableAt.storeAt
  fd_r52x5_double_scalar_mul_base.TableAt.lifetimeStart
  fd_r52x5_double_scalar_mul_base.TableAt.lifetimeEnd fd_r52x5_double_scalar_mul_base.TableAt.alloca

open fd_r52x5_double_scalar_mul_base in
public theorem fd_ed25519_verify.call_eq (msg : Pointer) (msgSz : BitVec 64) (sig pk sha : Pointer)
    (TB : Nat → Quad5) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_ed25519_verify.globals) (flB tbB : BlockId)
    (hgf : s.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : s.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hfl : Fits s.mem ⟨flB, 0⟩ 1) (hset : s.mem.readAt ⟨flB, 0⟩ 1 = 1)
    (hTB : TableAt s.mem ⟨tbB, 0⟩ 128 TB)
    (hmsg : Fits s.mem msg (8 * msgSz.toNat)) (hmsg_off : ¬msg.offset.uaddOverflow msgSz)
    (hmsgSz : msgSz.toNat < 2 ^ 63) (hsig : Fits s.mem sig (8 * 64))
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hpk : Fits s.mem pk (8 * 32))
    (hpk_off : ¬pk.offset.uaddOverflow 32#64) (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha)
    (hmsg_sha : msg.id ≠ sha.id) (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id)
    (hsha_fl : sha.id ≠ flB) (hsha_tb : sha.id ≠ tbB) :
    fd_ed25519_verify.call
        (fd_ed25519_verify.args (.value msg) (.value msgSz) (.value sig) (.value pk) (.value sha))
        s =
      let res :=
        fd_ed25519_verify.spec TB msgSz (s.mem.readAt msg (8 * msgSz.toNat))
          (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
          (s.mem.readAt sha 1024)
      .value
        (.cons (.value res.ret) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + res.blocks⟩, mem := res.mem s.mem sha }) := by
  dsimp only
  generalize hres :
    fd_ed25519_verify.spec TB msgSz (s.mem.readAt msg (8 * msgSz.toNat))
      (s.mem.readAt sig 256) (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256)
      (s.mem.readAt sha 1024) = res
  func_init
  rw [hS] at hres
  generalize hfl_eq : (⟨flB, 0⟩ : Pointer) = fl at hfl hset hfl₀
  generalize htb_eq : (⟨tbB, 0⟩ : Pointer) = tb at hTB
  have htb_lt : tb.id.id < S₀.alloc.nextFreeBlock := by
    rw [← htb_eq]; exact hwf₀.global_lt (hS ▸ hgb)
  have hfl_lt : fl.id.id < S₀.alloc.nextFreeBlock := by
    rw [← hfl_eq]; exact hwf₀.global_lt (hS ▸ hgf)
  obtain ⟨hsha_fits, hsha_off⟩ := hsha
  have hread_S : S.mem.readAt (sig.add 32#64) 256 = S₀.mem.readAt (sig.add 32#64) 256 := by rw [hS]
  have hread_r : S.mem.readAt sig 256 = S₀.mem.readAt sig 256 := by rw [hS]
  have hread_pk : S.mem.readAt pk 256 = S₀.mem.readAt pk 256 := by rw [hS]
  have hread_msg : S.mem.readAt msg (8 * msgSz.toNat) = S₀.mem.readAt msg (8 * msgSz.toNat) := by
    rw [hS]
  have hread_buf : S.mem.readAt sha 1024 = S₀.mem.readAt sha 1024 := by rw [hS]
  block_init
  iterate 4 step_pure
  step_alloca with ok
  step_pure
  step_store
  have hok1 : S.mem.readAt ok 32 = 1#32 := by
    rw [hS]; exact MemoryState.readAt_storeAt_self (by mem_fact) _
  have hfl' : Fits S.mem ⟨flB, 0⟩ 1 := hfl_eq ▸ hfl
  have hset' : S.mem.readAt ⟨flB, 0⟩ 1 = 1 := hfl_eq ▸ hset
  have hTB' : TableAt S.mem ⟨tbB, 0⟩ 128 TB := htb_eq ▸ hTB
  have hok_fits : Fits S.mem ok 32 := by mem_fact
  have hokroom : Room S.mem ok 32 := by mem_fact
  have hokr0 : ∀ (X : ShaState) (x : BitVec 32),
      (((fd_sha512_init.stores S.mem sha).storeSha sha X).storeAt ok x).readAt ok 32 = x :=
    fun X x => MemoryState.readAt_storeAt_self (hokroom.initStores.storeSha) x
  have hokf0 : ∀ (X : ShaState) (x : BitVec 32),
      Fits (((fd_sha512_init.stores S.mem sha).storeSha sha X).storeAt ok x) ok 32 :=
    fun X x => Fits.storeAt_self hokroom.initStores.storeSha
  have hokf1 : Fits S.mem ok 32 := hok_fits
  have hok1' : S.mem.readAt ok 32 = 1#32 := hok1
  rw [hS] at hokr0 hok1' hokf0 hokf1
  have hgv : S.mem.Globals fd_r52x5_verify_core.globals := by mem_fact
  step_call using (fd_r52x5_verify_core.call_eq msg msgSz sig pk sha ok TB S hwf hgv
    flB tbB hgf hgb hfl' hset' hTB' hmsg hmsg_off hmsgSz hsig hsig_off
    hpk hpk_off ⟨hsha_fits, hsha_off⟩ hshaw hok_fits (by mem_fact)
    hmsg_sha hsig_sha hpk_sha hsha_fl hsha_tb)
    consuming hTB' hTB hfl' hset' hset hfl hgf hgb hgv hg hmsg hsig hpk hshaw hsha_fits hok_fits
      hroom_ok hwritable_ok hok_bounds hread_S hread_r hread_pk hread_msg hread_buf hfits_ok hokroom
  obtain ⟨⟨cret, cout, cblocks⟩, hcore⟩ :
    ∃ R, fd_r52x5_verify_core.spec TB msgSz (S₀.mem.readAt msg (8 * msgSz.toNat))
        (S₀.mem.readAt sig 256) (S₀.mem.readAt (sig.add 32#64) 256) (S₀.mem.readAt pk 256)
        (S₀.mem.readAt sha 1024) 1#32 = R := ⟨_, rfl⟩
  rw [hcore] at hS hE
  have hspec := hres
  rw [fd_ed25519_verify.spec, hcore] at hspec
  clear hres
  rcases cout with _ | ⟨X, e⟩
  · -- no hash: `ok` still `1`
    have hrd : S.mem.readAt ok 32 = 1#32 := by
      rw [hS]
      exact hok1'
    have hokf : Fits S.mem ok 32 := by rw [hS]; exact hokf1
    clear hokr0 hok1' hokf0 hokf1
    step_pure
    step_load
    iterate 4 step_pure
    finish_block
    dsimp only at hspec
    subst hS hspec
    simp only [fd_r52x5_verify_core.Result.mem, Firedancer.fd_ed25519_verify.Result.mem]
    erase_frame
    simp only [ite_ofBool_beq, GlobalState.alloca_alloc]
    congr 3
    · split <;> simp_all
    · simp only [AllocState.mk.injEq]; omega
  · have hrd : S.mem.readAt ok 32 = e := by
      rw [hS]
      exact hokr0 X e
    have hokf : Fits S.mem ok 32 := by rw [hS]; exact hokf0 X e
    clear hokr0 hok1' hokf0 hokf1
    step_pure
    step_load
    iterate 4 step_pure
    finish_block
    dsimp only at hspec
    subst hS hspec
    simp only [fd_r52x5_verify_core.Result.mem, Firedancer.fd_ed25519_verify.Result.mem]
    erase_frame
    simp only [MemoryState.eraseFrom_storeSha, MemoryState.eraseFrom_initStores]
    erase_frame
    simp only [ite_ofBool_beq, GlobalState.alloca_alloc]
    congr 3
    simp only [AllocState.mk.injEq]; omega

end Proof

end MLIR.Firedancer.Crc.Verify
