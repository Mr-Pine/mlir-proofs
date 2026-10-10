module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Decode2.Frame
public import Firedancer.R52x5.Decode2.Spec
import Firedancer.R52x5.Decode2.Tactics
public import Firedancer.R52x5.Common.Runs
public import Firedancer.R52x5.wwl_st
public import Firedancer.R52x5.fd_f25519_mul2
public import Firedancer.R52x5.fd_f25519_mul

/-! `fd_r52x5_ge_decode2`'s exits: the failures storing the neutral point at `Pb`, the points of
both encodings, the return. -/

namespace MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

open Firedancer.Avx512 (Wwl wwl)

@[expose] public section

variable {Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb : Pointer}

attribute [local mlir_env 1100] read_write_same

/-- `^bb13`: the lifetimes end, `%3038` is returned. -/
theorem bb13_run {β : Type} {E : ⟪Γ⟫} {S B : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} (r : BitVec 32)
    (hr : E.read (rir_reg% hty 1491) = .value r) (hEnd : EndRegs B E) :
    (fd_r52x5_ge_decode2.runFrom E 13 S >>= g) =
      g (.cons (.value r) .nil, { S with mem := endFields S.mem B }) := by
  dsimp only [EndRegs] at hEnd
  block_init
  iterate 36 step_pure
  finish_block
  rw [hS]
  rfl

/-- `^bb9`: `A` has no root: `Pb` the neutral point, `-1`. -/
theorem bb9_run {β : Type} {E : ⟪Γ⟫} {S B : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β}
    (hArgs : E.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      E ⊨ [rir_reg% hty 5 := (wl 0 1 1 0 : Wl), rir_reg% hty 4 := (wl_zero : Wl), rir_reg% hty 3 :=
        4294967295#32])
    (hb0 : Room S.mem Pb0 256) (hb1 : Room S.mem Pb1 256) (hb2 : Room S.mem Pb2 256)
    (hb3 : Room S.mem Pb3 256) (hb4 : Room S.mem Pb4 256) (hEnd : EndRegs B E) :
    (fd_r52x5_ge_decode2.runFrom E 9 S >>= g) =
      g
        (.cons (.value (-1)) .nil,
          { S with mem := endFields (S.mem.storeTmp5 Pb0 Pb1 Pb2 Pb3 Pb4 quadZero) B }) := by
  dsimp only [EndRegs] at hEnd
  block_init
  iterate 5 step_store
  finish_block
  rw [bb13_run (-1)
      (by
        simp only [hE, read_write_same]; rfl)
      (by env_reads),
    hS]
  rfl

/-- `^bb11`: `B` has no root: `Pb` the neutral point, `-2`. -/
theorem bb11_run {β : Type} {E : ⟪Γ⟫} {S B : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β}
    (hArgs : E.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      E ⊨ [rir_reg% hty 5 := (wl 0 1 1 0 : Wl), rir_reg% hty 4 := (wl_zero : Wl), rir_reg% hty 2 :=
        4294967294#32])
    (hb0 : Room S.mem Pb0 256) (hb1 : Room S.mem Pb1 256) (hb2 : Room S.mem Pb2 256)
    (hb3 : Room S.mem Pb3 256) (hb4 : Room S.mem Pb4 256) (hEnd : EndRegs B E) :
    (fd_r52x5_ge_decode2.runFrom E 11 S >>= g) =
      g
        (.cons (.value (-2)) .nil,
          { S with mem := endFields (S.mem.storeTmp5 Pb0 Pb1 Pb2 Pb3 Pb4 quadZero) B }) := by
  dsimp only [EndRegs] at hEnd
  block_init
  iterate 5 step_store
  finish_block
  rw [bb13_run (-2)
      (by
        simp only [hE, read_write_same]; rfl)
      (by env_reads),
    hS]
  rfl

/-- `^bb10`: on to `^bb12` if `B`'s checks pass, else `^bb11`. -/
theorem bb10_run {β : Type} {E : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} (t1nz t2nz : BitVec 32)
    (hR : E ⊨ [rir_reg% hty 1337 := t1nz, rir_reg% hty 1338 := t2nz, rir_reg% hty 33 := 0#32])
    (hK12 :
      ∀ E' : ⟪Γ⟫,
        E'.args = E.args →
          Writes E E' 1369 1371 →
          t2nz &&& t1nz = 0 → (fd_r52x5_ge_decode2.runFrom E' 12 S >>= g) = K)
    (hK11 :
      ∀ E' : ⟪Γ⟫,
        E'.args = E.args →
          Writes E E' 1369 1371 →
          t2nz &&& t1nz ≠ 0 → (fd_r52x5_ge_decode2.runFrom E' 11 S >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom E 10 S >>= g) = K := by
  block_init
  step_pure
  step_pure
  finish_block
  · refine
      hK12 E
        (by
          rw [hE]; rfl)
        ?_ hbr
    rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · refine
      hK11 E
        (by
          rw [hE]; rfl)
        ?_ hbr
    rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _

/-- `fd_f25519_is_nonzero` is `0` or `1`. -/
theorem is_nonzero_01 (a : Wwl) :
    fd_f25519_is_nonzero.spec a = 0 ∨ fd_f25519_is_nonzero.spec a = 1 := by
  unfold fd_f25519_is_nonzero.spec fd_f25519_is_zero.spec
  dsimp only
  split <;> simp

/-- A comparison's `zext` is `0` or `1`. -/
theorem ofBool_setWidth_01 (b : Bool) :
    (BitVec.ofBool b).setWidth 32 = 0 ∨ (BitVec.ofBool b).setWidth 32 = 1 := by cases b <;> decide

-- 156 instructions, ten callee states with their read facts, two `FD_R52X5_QUAD_PACK`s with
-- sixteen lifetime markers: about 500000 heartbeats
set_option maxHeartbeats 600000 in
/-- `^bb12`: both encodings decode: `x` times `√-1` where `t1` is nonzero, negated unless its sign
is `x_0`, packed with `y`, `1`, `x y` into `Pa` and `Pb`; `0`. -/
theorem bb12_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} (DA DB : Dec)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 1228 := DA.x0, rir_reg% hty 1230 := DB.x0, rir_reg% hty 1335 := DA.t1nz,
        rir_reg% hty 1337 := DB.t1nz, rir_reg% hty 1 := B.slot 0, rir_reg% hty 16 := B.slot 1,
        rir_reg% hty 0 := (wwl 1 0 0 0 0 0 0 0 : Wwl), rir_reg% hty 46 := B.slot 3,
        rir_reg% hty 55 := B.slot 12, rir_reg% hty 64 := B.slot 21, rir_reg% hty 69 := B.slot 26,
        rir_reg% hty 70 := B.slot 27, rir_reg% hty 71 := B.slot 28, rir_reg% hty 72 := B.slot 29,
        rir_reg% hty 77 := B.slot 34, rir_reg% hty 78 := B.slot 35, rir_reg% hty 79 := B.slot 36,
        rir_reg% hty 239 := B.slot 196, rir_reg% hty 240 := B.slot 197, rir_reg% hty 241 :=
        B.slot 198, rir_reg% hty 242 := B.slot 199, rir_reg% hty 243 := B.slot 200,
        rir_reg% hty 244 := B.slot 201, rir_reg% hty 245 := B.slot 202, rir_reg% hty 246 :=
        B.slot 203, rir_reg% hty 20 := 1#64, rir_reg% hty 21 := 2#64, rir_reg% hty 22 := 3#64,
        rir_reg% hty 33 := 0#32])
    (ht1a : DA.t1nz = 0 ∨ DA.t1nz = 1) (ht1b : DB.t1nz = 0 ∨ DB.t1nz = 1) (hI : Inv B M c S)
    (hG : Globals B M)
    (hO :
      Room M Pa0 256 ∧
        Room M Pa1 256 ∧
        Room M Pa2 256 ∧
        Room M Pa3 256 ∧
        Room M Pa4 256 ∧
        Room M Pb0 256 ∧ Room M Pb1 256 ∧ Room M Pb2 256 ∧ Room M Pb3 256 ∧ Room M Pb4 256)
    (hy : S.mem.readVec (B.slot 3) = DA.y) (hyb : S.mem.readVec (B.slot 12) = DB.y)
    (hx : S.mem.readVec (B.slot 21) = DA.x) (hxb : S.mem.readVec (B.slot 29) = DB.x)
    (f3 : Fits S.mem (B.slot 3) 512) (f12 : Fits S.mem (B.slot 12) 512)
    (f21 : Fits S.mem (B.slot 21) 512) (f29 : Fits S.mem (B.slot 29) 512) (hEnd : EndRegs B Ein)
    (hlt :
      Pa0.id.id < B.alloc.nextFreeBlock + 3 ∧
        Pa1.id.id < B.alloc.nextFreeBlock + 3 ∧
        Pa2.id.id < B.alloc.nextFreeBlock + 3 ∧
        Pa3.id.id < B.alloc.nextFreeBlock + 3 ∧
        Pa4.id.id < B.alloc.nextFreeBlock + 3 ∧
        Pb0.id.id < B.alloc.nextFreeBlock + 3 ∧
        Pb1.id.id < B.alloc.nextFreeBlock + 3 ∧
        Pb2.id.id < B.alloc.nextFreeBlock + 3 ∧
        Pb3.id.id < B.alloc.nextFreeBlock + 3 ∧ Pb4.id.id < B.alloc.nextFreeBlock + 3)
    (hK :
      ∀ S' : GlobalState,
        S'.alloc.nextFreeBlock = S.alloc.nextFreeBlock + 4 →
          S'.mem.eraseFrom (B.alloc.nextFreeBlock + 3) =
            (M.storeTmp5 Pa0 Pa1 Pa2 Pa3 Pa4 DA.point).storeTmp5 Pb0 Pb1 Pb2 Pb3 Pb4 DB.point →
          g (.cons (.value 0) .nil, S') = K) :
    (fd_r52x5_ge_decode2.runFrom Ein 12 S >>= g) = K := by
  have hg0 := hI.fits hG.sqrtm1_fits
  have hg1 := hI.fits hG.one_fits
  have hsq := (hI.readVec (p := B.slot 0) (by simp [GlobalState.slot])).trans hG.sqrtm1
  have hone := (hI.readVec (p := B.slot 1) (by simp [GlobalState.slot])).trans hG.one
  clear hG
  obtain ⟨ha0, ha1, ha2, ha3, ha4, hb0, hb1, hb2, hb3, hb4⟩ := hO
  obtain ⟨la0, la1, la2, la3, la4, lb0, lb1, lb2, lb3, lb4⟩ := hlt
  replace ha0 := hI.room ha0
  replace ha1 := hI.room ha1
  replace ha2 := hI.room ha2
  replace ha3 := hI.room ha3
  replace ha4 := hI.room ha4
  replace hb0 := hI.room hb0
  replace hb1 := hI.room hb1
  replace hb2 := hI.room hb2
  replace hb3 := hI.room hb3
  replace hb4 := hI.room hb4
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  have hy' : S.mem.readAt (B.slot 3) 512 = BitVec.packLanes DA.y :=
    readAt_eq_packLanes_readVec.trans (by rw [hy])
  have hyb' : S.mem.readAt (B.slot 12) 512 = BitVec.packLanes DB.y :=
    readAt_eq_packLanes_readVec.trans (by rw [hyb])
  have f26 := hF.vec 26
  have f27 := hF.vec 27
  have f28 := hF.vec 28
  have f34 := hF.vec 34
  have f35 := hF.vec 35
  have f36 := hF.vec 36
  block_init
  -- `t3a = t1nza ? sqrt_m1 : one`, `t3b`
  step_call using (fd_f25519_if.call_eq (hc := ht1a))
  name_vec t3a
  step_call using (fd_f25519_if.call_eq (hc := ht1b))
  name_vec t3b
  -- `fd_f25519_mul2( xa, xa, t3a, xb, xb, t3b )`
  step_call using fd_f25519_mul2.call_eq
  name_vec xb
  name_vec xa
  -- `x_mod_2a = fd_f25519_sgn( xa )`, `neg_xa`, `xa = x_0a != x_mod_2a ? neg_xa : xa`
  step_call using fd_f25519_sgn.call_eq with x_mod_2a
  step_call using fd_f25519_sgn.call_eq with x_mod_2b
  step_call using fd_f25519_neg.call_eq
  name_vec neg_xa
  step_call using fd_f25519_neg.call_eq
  name_vec neg_xb
  step_pure
  step_pure with transparent ca
  step_call using (fd_f25519_if.call_eq (hc := hca ▸ ofBool_setWidth_01 _))
  name_vec xa'
  step_pure
  step_pure with transparent cb
  step_call using (fd_f25519_if.call_eq (hc := hcb ▸ ofBool_setWidth_01 _))
  name_vec xb'
  -- `fd_f25519_mul2( xya, xa, ya, xyb, xb, yb )`
  step_call using fd_f25519_mul2.call_eq
  name_vec xyb
  name_vec xya
  -- `t3a t3b neg_xa neg_xb` dead, `xya xyb` known
  clear_facts_at (B.slot 26) (B.slot 28) (B.slot 34) (B.slot 36)
  clear f27 f35 hg0
  have f196 := hF.arr 196
  have f197 := hF.arr 197
  have f198 := hF.arr 198
  have f199 := hF.arr 199
  -- `FD_R52X5_QUAD_PACK( *_Pa, xa, ya, one, xya )`
  step_pure
  step_load [ofFn_extractVecElem_readAt_512]
  step_call using wwl_st.call_eq
  step_pure
  step_load [ofFn_extractVecElem_readAt_512]
  step_call using wwl_st.call_eq
  step_pure
  step_call using wwl_st.call_eq
  step_pure
  step_load [ofFn_extractVecElem_readAt_512]
  step_call using wwl_st.call_eq
  step_pattern using runBodyFrom_packLimbRun0
  step_store
  step_pattern using runBodyFrom_packLimbRun 1
  step_store
  step_pattern using runBodyFrom_packLimbRun 2
  step_store
  step_pattern using runBodyFrom_packLimbRun 3
  step_store
  step_pattern using runBodyFrom_packLimbRun 4
  step_store
  clear_facts_at (B.slot 196) (B.slot 197) (B.slot 198) (B.slot 199)
  iterate 4 step_pure
  -- `FD_R52X5_QUAD_PACK( *_Pb, xb, yb, one, xyb )`
  have f200 := hF.arr 200
  have f201 := hF.arr 201
  have f202 := hF.arr 202
  have f203 := hF.arr 203
  step_pure
  step_load [ofFn_extractVecElem_readAt_512]
  step_call using wwl_st.call_eq
  step_pure
  step_load [ofFn_extractVecElem_readAt_512]
  step_call using wwl_st.call_eq
  step_pure
  step_call using wwl_st.call_eq
  step_pure
  step_load [ofFn_extractVecElem_readAt_512]
  step_call using wwl_st.call_eq
  step_pattern using runBodyFrom_packLimbRun0
  step_store
  step_pattern using runBodyFrom_packLimbRun 1
  step_store
  step_pattern using runBodyFrom_packLimbRun 2
  step_store
  step_pattern using runBodyFrom_packLimbRun 3
  step_store
  step_pattern using runBodyFrom_packLimbRun 4
  step_store
  clear_facts_at (B.slot 200) (B.slot 201) (B.slot 202) (B.slot 203)
  iterate 4 step_pure
  have hPA : DA.point = Quad5.pack xa' DA.y fd_f25519_one.vec xya := by
    rw [hxya, hxa', hneg_xa, hx_mod_2a, hxa, ht3a]; rfl
  have hPB : DB.point = Quad5.pack xb' DB.y fd_f25519_one.vec xyb := by
    rw [hxyb, hxb', hneg_xb, hx_mod_2b, hxb, ht3b]; rfl
  finish_block
  rw [bb13_run 0
      (by
        simp only [hE, read_write_same]; rfl)
      (by
        dsimp only [EndRegs] at hEnd ⊢; env_reads)]
  refine hK { S with mem := endFields S.mem B } (by rw [hS]) ?_
  rw [eraseFrom_endFields, hS, hPA, hPB]
  simp (disch := decide) only [eraseFrom_storeVec_slot, eraseFrom_lifetimeStart_slot,
    eraseFrom_lifetimeEnd_slot, MemoryState.eraseFrom_storeAt, herase]
  simp only [MemoryState.storeTmp5, MemoryState.storeWv, Quad5.pack, fd_f25519_one.vec]
  rfl

end

end MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2
