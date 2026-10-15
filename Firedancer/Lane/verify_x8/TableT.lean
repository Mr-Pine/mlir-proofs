module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.verify_x8.TableTab
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! The end of `^bb79`: the temporaries freed, `acc` zeroed by `fd_ed25519_lane_zero`, the jump to
`^bb83`; `At83` from the facts carried and the frame. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

attribute [-simp] BitVec.replicate_succ BitVec.reduceReplicate

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

attribute [local mlir_transport] MemoryState.FrameOn.storeAt MemoryState.FrameOn.storeAt_add
  MemoryState.FrameOn.storeVec MemoryState.FrameOn.storeVec_add MemoryState.FrameOn.lifetimeStart
  MemoryState.FrameOn.lifetimeEnd MemoryState.FrameOn.storeFe MemoryState.FrameOn.storeFe_add
  MemoryState.FrameOn.storeLanePoint

attribute [local mlir_read] readFe_storeAt_of_id_ne readLanePoint_storeAt_of_id_ne
  readNiels_storeAt_of_id_ne readLanePoint_storeVec_of_id_ne readNiels_storeVec_of_id_ne
  readAt_storeLanePoint_x0 readAt_storeLanePoint_x1
  readAt_storeLanePoint_x2 readAt_storeLanePoint_x3 readAt_storeLanePoint_x4
  readAt_storeLanePoint_y0 readAt_storeLanePoint_y1 readAt_storeLanePoint_y2
  readAt_storeLanePoint_y3 readAt_storeLanePoint_y4 readAt_storeLanePoint_z0
  readAt_storeLanePoint_z1 readAt_storeLanePoint_z2 readAt_storeLanePoint_z3
  readAt_storeLanePoint_z4 readAt_storeLanePoint_t0 readAt_storeLanePoint_t1
  readAt_storeLanePoint_t2 readAt_storeLanePoint_t3 readAt_storeLanePoint_t4

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

-- the tail's 49 instructions and `At83`'s facts in one declaration
set_option maxHeartbeats 4000000 in
/-- `^bb79` from the last entry on: `acc` zeroed, the jump to `^bb83`. -/
public theorem segT (c : Call) (S₀ : GlobalState) (hb0 : c.Base S₀ c.mem76)
    (hkdf : Fits S₀.mem (c.s.slot 0) 4096) (hkdr : S₀.mem.readAt (c.s.slot 0) 4096 = c.kdBits)
    (hsdf : Fits S₀.mem (c.s.slot 1) 4096) (hsdr : S₀.mem.readAt (c.s.slot 1) 4096 = c.sdBits)
    (hr0 : c.PointAt S₀ 29 c.decR.1) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT1764 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT1764 c S₀.mem kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (h83 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args → Env83 c E' → c.At83 S' →
        ((verify_x8 c.batch).runFrom E' 83 S' >>= g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 1764 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3, hF4, hT4, hF5, hT5, hF6, hT6,
    hF7, hT7, hF8, hT8, hroom_tmp, hb11, hw11⟩ := hS
  have hkt_off : kt.offset = 0 := by rw [hkt]; rfl
  have hacc_off : acc.offset = 0 := by rw [hacc]; rfl
  have hacc_k : ¬Keep c acc.id := hacc ▸ not_keep_slot c (by decide) (by decide)
  have hp2_k : ¬Keep c p2.id := hp2 ▸ not_keep_slot c (by decide) (by decide)
  have hp3_k : ¬Keep c p3.id := hp3 ▸ not_keep_slot c (by decide) (by decide)
  have hp4_k : ¬Keep c p4.id := hp4 ▸ not_keep_slot c (by decide) (by decide)
  have hp6_k : ¬Keep c p6.id := hp6 ▸ not_keep_slot c (by decide) (by decide)
  have htmp_k : ¬Keep c tmp.id := htmp ▸ not_keep_slot c (by decide) (by decide)
  have hn1_k : ¬Keep c n1.id := hn1 ▸ not_keep_slot c (by decide) (by decide)
  have hktb : InBounds S.mem kt 115200 := hroom_kt.1.inBounds
  folded hkt
  folded hk2
  folded hn1
  folded hp2
  folded hp3
  folded hp4
  folded hp6
  folded htmp
  folded hacc
  folded ha
  env_writes hE
  unfold G79
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sms
  ss
  ss
  ss
  sp
  sp
  sp
  sms
  sms
  sms
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  finish_block
  have hacc_rd := readLanePoint_zero hacc_off hroom_acc.1.inBounds hread_acc hread_acc_320
    hread_acc_384 hread_acc_640 hread_acc_704 hread_acc_960 hread_acc_1024
  have hacc_ft := fits_zero hacc_off hfits_acc hfits_acc_320 hfits_acc_384 hfits_acc_640
    hfits_acc_704 hfits_acc_960 hfits_acc_1024
  have htf := fits_tab hkt_off hF0 hF1 hF2 hF3 hF4 hF5 hF6 hF7 hF8
  have htr := readAt_tab hkt_off hktb hT0 hT1 hT2 hT3 hT4 hT5 hT6 hT7 hT8
  have hsame := hfr.sameOn
  subst hkt hk2 hn1 hp2 hp3 hp4 hp6 htmp hacc ha
  exact h83 E S hArgs (by env_reads)
    ⟨hb0.of_frameOn hfr hwf, hsame.fits keep_slot0 hkdf,
      by rw [hsame.readAt keep_slot0]; exact hkdr, hsame.fits keep_slot1 hsdf,
      by rw [hsame.readAt keep_slot1]; exact hsdr, htf, htr,
      ⟨⟨nov_of_zero hacc_off (by decide), hacc_ft⟩, hacc_rd⟩, hr0.of_frameOn hfr keep_slot29⟩

end MLIR.Firedancer.Lane.VerifyX8
