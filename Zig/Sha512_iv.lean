module

public import MLIR.Run.Tactic
public import Zig.Sha512
public import Zig.Mlir.Sha512_iv
import all MLIR.Ty

/-! `Sha512.iv`, the fresh object: its initializer's value, and an object copied from it has
absorbed nothing. -/

namespace MLIR.Zig

open _root_.Ed25519

public theorem Sha512_iv.value_eq (s : GlobalState) :
    Sha512_iv.value s = .value (Ty.wrap Sha512_iv.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `Sha512.iv`'s bytes, as a number: `total_len = 0`, the state `IV`, the rest zero. -/
theorem flatBits_iv :
    Ty.flatBits Sha512_iv.lit (hw := (by decide : Sha512_iv.t.width = 1792)) =
      1637455117631664012810557771656886049965747598061229742010934158805205274033315025337835822496269922903472358367800062343127587223993712505580661243712014069548549710486193496759589501325541376#1792 := by
  rw [Ty.flatBits_eq]
  decide +kernel

/-- An object holding `Sha512.iv`'s bytes has absorbed nothing. -/
public theorem Sha512Obj.absorbed_iv {m : MemoryState} {d : Pointer} {hw : Sha512_iv.t.width = 1792}
    (hf : Sha512Obj.Fit m d) (h : m.readAt d 1792 = Ty.flatBits Sha512_iv.lit (hw := hw)) :
    Sha512Obj.Absorbed m d [] := by
  obtain ⟨hf, ho⟩ := hf
  have e : Ty.flatBits Sha512_iv.lit (hw := hw) =
      Ty.flatBits Sha512_iv.lit (hw := (by decide : Sha512_iv.t.width = 1792)) := rfl
  rw [e, flatBits_iv] at h
  clear e hw
  have hr (k w : Nat) (hk : k * 8 + w ≤ 1792) :
      m.readAt (d.add (BitVec.ofNat 64 k)) w =
        (1637455117631664012810557771656886049965747598061229742010934158805205274033315025337835822496269922903472358367800062343127587223993712505580661243712014069548549710486193496759589501325541376#1792).extractLsb' (k * 8) w := by
    rw [MemoryState.readAt_add_of_readAt hf (by simp [BitVec.uaddOverflow]; omega) (by simp; omega) h]
    congr 1
    simp
    omega
  refine ⟨?_, ?_, by simp, ?_⟩
  · rw [Sha512.compressBlocks_of_lt (by simp)]
    apply Vector.ext
    intro i hi
    simp only [Sha512Obj.state, Vector.getElem_ofFn]
    rw [show 16#64 + BitVec.ofNat 64 (8 * i) = BitVec.ofNat 64 (16 + 8 * i) by
      apply BitVec.eq_of_toNat_eq; simp, hr _ _ (by omega)]
    match i, hi with
    | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ => decide +kernel +revert
  · rw [Sha512Obj.bufLen, hr 208 8 (by omega)]
    decide +kernel
  · rw [Sha512Obj.totalLen, MemoryState.readAt_of_readAt_le (by omega) h]
    decide +kernel

end MLIR.Zig
