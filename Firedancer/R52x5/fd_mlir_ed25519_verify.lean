module

public import MLIR.Run.Tactic
import Firedancer.Common.Tactics
public import Firedancer.R52x5.fd_ed25519_verify
public import Firedancer.R52x5.Mlir.fd_mlir_ed25519_verify

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- What `fd_ed25519_verify` leaves keeps a state well-formed. -/
theorem GlobalState.WF.resultMem {s : GlobalState} {res : fd_ed25519_verify.Result} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + n⟩, res.mem s.mem sha⟩ : GlobalState).WF := by
  have h1 : (⟨⟨s.alloc.nextFreeBlock + n⟩, s.mem⟩ : GlobalState).WF := h.add_blocks
  unfold fd_ed25519_verify.Result.mem
  split
  · simp only [fd_sha512_init.stores]
    exact
      GlobalState.WF.storeSha
        h1.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt
  · exact h1

/-- What `fd_ed25519_verify` leaves keeps known ranges known. -/
theorem Fits.resultMem {m : MemoryState} {res : fd_ed25519_verify.Result} (h : Fits m q w) :
    Fits (res.mem m sha) q w := by
  unfold fd_ed25519_verify.Result.mem
  split
  · exact h.initStores.storeSha
  · exact h

/-- What `fd_ed25519_verify` leaves keeps the globals table. -/
theorem MemoryState.globals_resultMem {m : MemoryState} {res : fd_ed25519_verify.Result} :
    (res.mem m sha).globals = m.globals := by
  unfold fd_ed25519_verify.Result.mem
  split <;> rfl

/-- What `fd_ed25519_verify` leaves keeps every block's writability. -/
theorem Writable.resultMem {m : MemoryState} {res : fd_ed25519_verify.Result} (h : Writable m q) :
    Writable (res.mem m sha) q := by
  unfold fd_ed25519_verify.Result.mem fd_sha512_init.stores MemoryState.storeSha
  split
  · exact
      h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt
        |>.storeAt.storeAt.storeWords8
  · exact h

theorem MemoryState.ShaFit.resultMem {m : MemoryState} {res : fd_ed25519_verify.Result}
    (h : m.ShaFit q) : (res.mem m sha).ShaFit q :=
  ⟨Fits.resultMem h.1, h.2⟩

/-- Erasing a frame commutes with what `fd_ed25519_verify` leaves. -/
theorem MemoryState.eraseFrom_resultMem {m : MemoryState} {res : fd_ed25519_verify.Result} :
    (res.mem m sha).eraseFrom n = res.mem (m.eraseFrom n) sha := by
  unfold fd_ed25519_verify.Result.mem
  split
  · rw [MemoryState.eraseFrom_storeSha, MemoryState.eraseFrom_initStores]
  · rfl

attribute [local mlir_transport] GlobalState.WF.resultMem Fits.resultMem
  MemoryState.ShaFit.resultMem

attribute [local mlir_erase] MemoryState.eraseFrom_resultMem

/-- `fd_mlir_ed25519_verify` is `fd_ed25519_verify`. -/
public theorem fd_mlir_ed25519_verify.call_eq (msg : Pointer) (msgSz : BitVec 64)
    (sig pk sha : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_mlir_ed25519_verify.globals) (hmsg : Fits s.mem msg (8 * msgSz.toNat))
    (hmsg_off : ¬msg.offset.uaddOverflow msgSz) (hmsgSz : msgSz.toNat < 2 ^ 63)
    (hsig : Fits s.mem sig (8 * 64)) (hsig_off : ¬sig.offset.uaddOverflow 64#64)
    (hpk : Fits s.mem pk (8 * 32)) (hpk_off : ¬pk.offset.uaddOverflow 32#64)
    (hsha : s.mem.ShaFit sha) (hshaw : Writable s.mem sha) (hmsg_sha : msg.id ≠ sha.id)
    (hsig_sha : sig.id ≠ sha.id) (hpk_sha : pk.id ≠ sha.id) :
    fd_mlir_ed25519_verify.call
        (fd_mlir_ed25519_verify.args (.value msg) (.value msgSz) (.value sig) (.value pk)
          (.value sha))
        s =
      let res :=
        fd_ed25519_verify.spec fd_ed25519_base_point_wnaf_table.point msgSz
          (s.mem.readAt msg (8 * msgSz.toNat)) (s.mem.readAt sig 256)
          (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt pk 256) (s.mem.readAt sha 1024)
      .value
        (.cons (.value res.ret) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + res.blocks⟩, mem := res.mem s.mem sha }) := by
  func_init
  block_init
  step_call using fd_ed25519_verify.call_eq
  -- the globals and `sha`'s writability past the result's memory, which the step does not see
  -- through
  any_goals
    subst hS'
    first
    | exact hg.mono MemoryState.globals_resultMem fun _ h => h
    | exact Writable.resultMem (by assumption)
  finish_block
  subst hS
  erase_frame

end Proof

end MLIR.Firedancer.R52x5
