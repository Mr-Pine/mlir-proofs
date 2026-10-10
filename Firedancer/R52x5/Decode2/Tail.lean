module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Decode2.Frame
public import Firedancer.R52x5.Decode2.Spec
public import Firedancer.R52x5.Common.Runs
import Firedancer.R52x5.Decode2.Tactics
public import Firedancer.R52x5.Decode2.Loop
public import Firedancer.R52x5.fd_f25519_mul2
public import Firedancer.R52x5.fd_f25519_sqr2
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2

open Firedancer.Avx512 (Wwl wwl)

@[expose] public section

variable {Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb : Pointer}

attribute [local mlir_env 1100] read_write_same

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl zipWith_and_wl zipWith_lshr_wl
  zipWith_add_nsw_nuw_reduce

/-- `^bb7`'s sites `4` to `97`: `_t0 = _t1 _t0`, squared twice. -/
theorem bb7c0_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (Q2905 Q2581 : Quad5)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 1358 := Q2905.P0, rir_reg% hty 1360 := Q2905.P1, rir_reg% hty 1362 :=
        Q2905.P2, rir_reg% hty 1364 := Q2905.P3, rir_reg% hty 1366 := Q2905.P4, rir_reg% hty 1034 :=
        Q2581.P0, rir_reg% hty 1036 := Q2581.P1, rir_reg% hty 1038 := Q2581.P2, rir_reg% hty 1040 :=
        Q2581.P3, rir_reg% hty 1042 := Q2581.P4, rir_reg% hty 219 := B.slot 176, rir_reg% hty 220 :=
        B.slot 177, rir_reg% hty 221 := B.slot 178, rir_reg% hty 222 := B.slot 179,
        rir_reg% hty 223 := B.slot 180, rir_reg% hty 224 := B.slot 181, rir_reg% hty 225 :=
        B.slot 182, rir_reg% hty 226 := B.slot 183, rir_reg% hty 227 := B.slot 184,
        rir_reg% hty 228 := B.slot 185, rir_reg% hty 229 := B.slot 186, rir_reg% hty 230 :=
        B.slot 187, rir_reg% hty 231 := B.slot 188, rir_reg% hty 232 := B.slot 189,
        rir_reg% hty 233 := B.slot 190, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl),
        rir_reg% hty 24 := (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl)])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 1231 1291 →
          (E' ⊨ [rir_reg% hty 1282 := (sqrQ (sqrQ (mulQ Q2905 Q2581))).P0, rir_reg% hty 1284 :=
            (sqrQ (sqrQ (mulQ Q2905 Q2581))).P1, rir_reg% hty 1286 :=
            (sqrQ (sqrQ (mulQ Q2905 Q2581))).P2, rir_reg% hty 1288 :=
            (sqrQ (sqrQ (mulQ Q2905 Q2581))).P3, rir_reg% hty 1290 :=
            (sqrQ (sqrQ (mulQ Q2905 Q2581))).P4]) →
          Inv B M c S' → Keeps B S.mem S'.mem → (bb7.runBodyFrom E' 97 S' >>= g) = K) :
    (bb7.runBodyFrom Ein 4 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  qp_mul 176
  qp_sqr 181
  qp_sqr 186
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩ ?_
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · env_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc
  · rw [hS]
    exact
      ((((Keeps.refl _ _).callTmp5 176 177 178 179 180 (by decide) (by decide) (by decide)
                (by decide) (by decide)).callTmp5
            181 182 183 184 185 (by decide) (by decide) (by decide) (by decide)
            (by decide)).callTmp5
        186 187 188 189 190 (by decide) (by decide) (by decide) (by decide) (by decide))

/-- `%1584`: `2^51 - 1` in lanes 0 and 1, lanes 2 and 3 poison. -/
abbrev mask2 : ⟦Ty.vec 4 64⟧ :=
  ((((Vector.replicate 4 PoisonOr.poison).set 0 (PoisonOr.value 2251799813685247#64)
                (by decide)).set
            1 (PoisonOr.value 2251799813685247#64) (by decide)).set
        2 PoisonOr.poison (by decide)).set
    3 PoisonOr.poison (by decide)

theorem and_mask2 (x : Wl) :
    Vector.zipWith (Operation.and (w := 64)) (Ty.wrap (t := .vec 4 64) x) mask2 =
      #v[.value (x[0] &&& 2251799813685247#64), .value (x[1] &&& 2251799813685247#64), .poison,
        .poison] := by
  ext i hi
  obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
  all_goals simp [Ty.wrap_vec, Operation.and]

theorem add_mask2 (x y : Wl) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        #v[.value (x[0] &&& 2251799813685247#64), .value (x[1] &&& 2251799813685247#64), .poison,
          .poison]
        (Ty.wrap (t := .vec 4 64) (wl_shru y 51)) =
      #v[.value (wl_add (wl_and x (Vector.replicate 4 2251799813685247#64)) (wl_shru y 51))[0],
        .value (wl_add (wl_and x (Vector.replicate 4 2251799813685247#64)) (wl_shru y 51))[1],
        .poison, .poison] := by
  ext i hi
  obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
  all_goals simp [Ty.wrap_vec, Operation.add, wl_add, wl_and, wl_shru, mask51_add_shr51]

-- a QUAD site's ten lifetime markers and `ea eb`'s ends, each an effectful step
set_option maxHeartbeats 300000 in
/-- `^bb7`'s last `QP_MUL` (`D = _t0 A`), its limbs `0` and `1` taken apart into `xa` and `xb`. -/
theorem bb7b_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} {B : GlobalState} {M : MemoryState} {c : Nat} (T A : Quad5)
    (hR :
      Ein ⊨ [rir_reg% hty 1282 := T.P0, rir_reg% hty 1284 := T.P1, rir_reg% hty 1286 := T.P2,
        rir_reg% hty 1288 := T.P3, rir_reg% hty 1290 := T.P4, rir_reg% hty 270 := A.P0,
        rir_reg% hty 278 := A.P1, rir_reg% hty 286 := A.P2, rir_reg% hty 294 := A.P3,
        rir_reg% hty 302 := A.P4, rir_reg% hty 234 := B.slot 191, rir_reg% hty 235 := B.slot 192,
        rir_reg% hty 236 := B.slot 193, rir_reg% hty 237 := B.slot 194, rir_reg% hty 238 :=
        B.slot 195, rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl), rir_reg% hty 18 :=
        (Vector.replicate 4 PoisonOr.poison : ⟦.vec 4 64⟧), rir_reg% hty 37 :=
        ((((Vector.replicate 4 PoisonOr.poison).set 0 (PoisonOr.value 2251799813685247#64)
                      (by decide)).set
                  1 (PoisonOr.value 2251799813685247#64) (by decide)).set
              2 PoisonOr.poison (by decide)).set
          3 PoisonOr.poison (by decide),
        rir_reg% hty 45 :=
        (((Vector.replicate 8 PoisonOr.poison).set 5 (PoisonOr.value 0#64) (by decide)).set 6
              (PoisonOr.value 0#64) (by decide)).set
          7 (PoisonOr.value 0#64) (by decide),
        rir_reg% hty 64 := B.slot 21, rir_reg% hty 72 := B.slot 29, rir_reg% hty 82 := B.slot 39,
        rir_reg% hty 83 := B.slot 40])
    (hI : Inv B M c S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        Writes Ein E' 1291 1331 →
          Inv B M c S' →
          (∀ j,
            3 ≤ j →
              j < 21 →
              S'.mem.readVec (B.slot j) = S.mem.readVec (B.slot j) ∧
                (Fits S.mem (B.slot j) 512 → Fits S'.mem (B.slot j) 512)) →
          S'.mem.readVec (B.slot 21) = (mulQ T A).unpack.1 →
          S'.mem.readVec (B.slot 29) = (mulQ T A).unpack.2.1 →
          Fits S'.mem (B.slot 21) 512 →
          Fits S'.mem (B.slot 29) 512 → (bb7.runBodyFrom E' 152 S' >>= g) = K) :
    (bb7.runBodyFrom Ein 97 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  have hz0 := hF.tmp 191
  have hz1 := hF.tmp 192
  have hz2 := hF.tmp 193
  have hz3 := hF.tmp 194
  have hz4 := hF.tmp 195
  iterate 5 step_pure
  step_call using fd_r52x5_quad_mul_fast.call_eq
  iterate 5 step_load [ofFn_extractVecElem_readAt] inline
  clear hz0 hz1 hz2 hz3 hz4
  clear_facts_at (B.slot 191) (B.slot 192) (B.slot 193) (B.slot 194) (B.slot 195)
  iterate 5 step_pure
  rw [← MemoryState.callTmp5.eq_1] at hS
  iterate 5 step_pure with transparent vc
  step_pure with transparent va
  step_pure [reduce_P0, reduce_mul]
  step_pure
  step_pure
  iterate 4 
    step_pure [and_mask2]
    step_pure [add_mask2, reduce_P1, reduce_P2, reduce_P3, reduce_P4, reduce_mul]
    step_pure
    step_pure
  iterate 5 step_pure
  have h21 := hF.vec 21
  have h29 := hF.vec 29
  step_store
  iterate 5 step_pure
  step_store
  iterate 2 step_pure
  refine
    hK E S ?_ ⟨hwf, hF, ?_, ?_⟩ ?_ (MemoryState.readVec_packLanes (by assumption))
      (MemoryState.readVec_packLanes (by assumption)) (by mem_fact) (by mem_fact)
  · rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  · rw [hS]
    simp (disch := decide) only [eraseFrom_lifetimeEnd_slot, eraseFrom_callTmp5_slot,
      eraseFrom_storeAt_slot]
    exact herase
  · rw [hS]
    exact halloc
  · intro j h3 hj
    refine ⟨?_, fun hf => ?_⟩
    · rw [hS]
      simp only [MemoryState.readVec_lifetimeEnd,
        readVec_storeAt_of_id_ne (GlobalState.slot_id_ne (show 29 ≠ j by omega)),
        readVec_storeAt_of_id_ne (GlobalState.slot_id_ne (show 21 ≠ j by omega))]
      rw [readVec_callTmp5_of_id_ne] <;> exact GlobalState.slot_id_ne (by omega)
    · rw [hS]
      dsimp only
      refine
        Fits.lifetimeEnd (Fits.lifetimeEnd ?_ (GlobalState.slot_id_ne (by omega)))
          (GlobalState.slot_id_ne (by omega))
      refine Fits.storeAt (Fits.storeAt ?_)
      exact
        hf.callTmp5 (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))
          (GlobalState.slot_id_ne (by omega)) (GlobalState.slot_id_ne (by omega))
          (GlobalState.slot_id_ne (by omega))

/-- `buf[31] >> 7` is `0` or `1`: its `zext nneg` is no poison. -/
theorem shr7_msb (b : BitVec 8) : (b >>> 7).msb = false := by bv_decide

/-- `^bb7`: `_t0 = _t1 _t0`, `FD_R52X5_POW22523_QUAD`'s last steps into `xa xb`, then `x = xa uv3`
and the checks of both encodings; on to `^bb10` if `A`'s pass, else `^bb9`. -/
theorem bb7_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState}
    {g : Vals [.bv 32] × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} (T1 T0 Aq : Quad5) (A Bp : Pre) (ba bb : BitVec 8)
    (hArgs : Ein.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get)
    (hR :
      Ein ⊨ [rir_reg% hty 248 := ba, rir_reg% hty 250 := bb, rir_reg% hty 29 := 7#8,
        rir_reg% hty 1358 := T1.P0, rir_reg% hty 1360 := T1.P1, rir_reg% hty 1362 := T1.P2,
        rir_reg% hty 1364 := T1.P3, rir_reg% hty 1366 := T1.P4, rir_reg% hty 1034 := T0.P0,
        rir_reg% hty 1036 := T0.P1, rir_reg% hty 1038 := T0.P2, rir_reg% hty 1040 := T0.P3,
        rir_reg% hty 1042 := T0.P4, rir_reg% hty 270 := Aq.P0, rir_reg% hty 278 := Aq.P1,
        rir_reg% hty 286 := Aq.P2, rir_reg% hty 294 := Aq.P3, rir_reg% hty 302 := Aq.P4,
        rir_reg% hty 219 := B.slot 176, rir_reg% hty 220 := B.slot 177, rir_reg% hty 221 :=
        B.slot 178, rir_reg% hty 222 := B.slot 179, rir_reg% hty 223 := B.slot 180,
        rir_reg% hty 224 := B.slot 181, rir_reg% hty 225 := B.slot 182, rir_reg% hty 226 :=
        B.slot 183, rir_reg% hty 227 := B.slot 184, rir_reg% hty 228 := B.slot 185,
        rir_reg% hty 229 := B.slot 186, rir_reg% hty 230 := B.slot 187, rir_reg% hty 231 :=
        B.slot 188, rir_reg% hty 232 := B.slot 189, rir_reg% hty 233 := B.slot 190,
        rir_reg% hty 234 := B.slot 191, rir_reg% hty 235 := B.slot 192, rir_reg% hty 236 :=
        B.slot 193, rir_reg% hty 237 := B.slot 194, rir_reg% hty 238 := B.slot 195,
        rir_reg% hty 23 := (Vector.replicate 4 51#64 : Wl), rir_reg% hty 24 :=
        (Vector.replicate 4 2251799813685247#64 : Wl), rir_reg% hty 25 :=
        (Vector.replicate 4 19#64 : Wl), rir_reg% hty 18 :=
        (Vector.replicate 4 PoisonOr.poison : ⟦.vec 4 64⟧), rir_reg% hty 37 := mask2,
        rir_reg% hty 45 :=
        (((Vector.replicate 8 PoisonOr.poison).set 5 (PoisonOr.value 0#64) (by decide)).set 6
              (PoisonOr.value 0#64) (by decide)).set
          7 (PoisonOr.value 0#64) (by decide),
        rir_reg% hty 47 := B.slot 4, rir_reg% hty 48 := B.slot 5, rir_reg% hty 53 := B.slot 10,
        rir_reg% hty 56 := B.slot 13, rir_reg% hty 57 := B.slot 14, rir_reg% hty 62 := B.slot 19,
        rir_reg% hty 64 := B.slot 21, rir_reg% hty 65 := B.slot 22, rir_reg% hty 66 := B.slot 23,
        rir_reg% hty 67 := B.slot 24, rir_reg% hty 68 := B.slot 25, rir_reg% hty 72 := B.slot 29,
        rir_reg% hty 73 := B.slot 30, rir_reg% hty 74 := B.slot 31, rir_reg% hty 75 := B.slot 32,
        rir_reg% hty 76 := B.slot 33, rir_reg% hty 82 := B.slot 39, rir_reg% hty 83 := B.slot 40,
        rir_reg% hty 33 := 0#32])
    (hI : Inv B M c S) (hu : S.mem.readVec (B.slot 4) = A.u) (hv : S.mem.readVec (B.slot 5) = A.v)
    (huv3 : S.mem.readVec (B.slot 10) = A.uv3) (hub : S.mem.readVec (B.slot 13) = Bp.u)
    (hvb : S.mem.readVec (B.slot 14) = Bp.v) (huv3b : S.mem.readVec (B.slot 19) = Bp.uv3)
    (hy : S.mem.readVec (B.slot 3) = A.y) (hyb : S.mem.readVec (B.slot 12) = Bp.y)
    (hfits : ∀ j, 3 ≤ j → j < 21 → Fits S.mem (B.slot j) 512)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 1227 1341 →
            (let Qx := (mulQ (sqrQ (sqrQ (mulQ T1 T0))) Aq).unpack
       let DA := dec A Qx.1
            let DB := dec Bp Qx.2.1
            (E' ⊨ [rir_reg% hty 1228 := ba.setWidth 32 >>> 7, rir_reg% hty 1230 :=
                bb.setWidth 32 >>> 7, rir_reg% hty 1335 := DA.t1nz, rir_reg% hty 1337 := DB.t1nz,
                rir_reg% hty 1338 := DB.t2nz]) →
              Inv B M (c + 8) S' →
              S'.mem.readVec (B.slot 3) = A.y →
              S'.mem.readVec (B.slot 12) = Bp.y →
              S'.mem.readVec (B.slot 21) = DA.x →
              S'.mem.readVec (B.slot 29) = DB.x →
              Fits S'.mem (B.slot 3) 512 →
              Fits S'.mem (B.slot 12) 512 →
              Fits S'.mem (B.slot 21) 512 →
              Fits S'.mem (B.slot 29) 512 →
              DA.t2nz &&& DA.t1nz = 0 → (fd_r52x5_ge_decode2.runFrom E' 10 S' >>= g) = K))
    (hK9 :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState),
        E'.args = (argsOf Pa0 Pa1 Pa2 Pa3 Pa4 sa Pb0 Pb1 Pb2 Pb3 Pb4 sb).get →
          Writes Ein E' 1227 1341 →
          Inv B M (c + 8) S' →
          (dec A (mulQ (sqrQ (sqrQ (mulQ T1 T0))) Aq).unpack.1).t2nz &&&
              (dec A (mulQ (sqrQ (sqrQ (mulQ T1 T0))) Aq).unpack.1).t1nz ≠
            0 →
          (fd_r52x5_ge_decode2.runFrom E' 9 S' >>= g) = K) :
    (fd_r52x5_ge_decode2.runFrom Ein 7 S >>= g) = K := by
  block_init
  step_pure
  step_pure [shr7_msb] with transparent x_0a
  step_pure
  step_pure [shr7_msb] with transparent x_0b
  have hs :
    E ⊨ [rir_reg% hty 1228 := ba.setWidth 32 >>> 7, rir_reg% hty 1230 := bb.setWidth 32 >>> 7] := by
    simp (disch := decide) only [hE, Env.read_write_ne', read_write_same, hx_0a, hx_0b, and_self]
  have hB0 : Writes Ein E 1227 1231 := by
    rw [hE]
    repeat refine Writes.write ?_ (by decide)
    exact Writes.refl _ _ _
  obtain ⟨hwf₀, hF₀, herase₀, halloc₀⟩ := hI
  refine
    bb7c0_run T1 T0 hArgs (by chain_reads) ⟨hwf₀, hF₀, herase₀, halloc₀⟩
      fun E1 S1 hA1 hB1 hR1 hI1 hK1 => ?_
  refine bb7b_run _ Aq (by chain_reads) hI1 fun E2 S2 hB2 hI2 hk2 hxa hxb hfxa hfxb => ?_
  obtain ⟨hwf, hF, herase, halloc⟩ := hI2
  have r3 : S2.mem.readVec (B.slot 3) = A.y :=
    (hk2 3 (by omega) (by omega)).1.trans ((hK1 3 (by omega) (by omega)).1.trans hy)
  have r12 : S2.mem.readVec (B.slot 12) = Bp.y :=
    (hk2 12 (by omega) (by omega)).1.trans ((hK1 12 (by omega) (by omega)).1.trans hyb)
  have r4 : S2.mem.readVec (B.slot 4) = A.u :=
    (hk2 4 (by omega) (by omega)).1.trans ((hK1 4 (by omega) (by omega)).1.trans hu)
  have r5 : S2.mem.readVec (B.slot 5) = A.v :=
    (hk2 5 (by omega) (by omega)).1.trans ((hK1 5 (by omega) (by omega)).1.trans hv)
  have r10 : S2.mem.readVec (B.slot 10) = A.uv3 :=
    (hk2 10 (by omega) (by omega)).1.trans ((hK1 10 (by omega) (by omega)).1.trans huv3)
  have r13 : S2.mem.readVec (B.slot 13) = Bp.u :=
    (hk2 13 (by omega) (by omega)).1.trans ((hK1 13 (by omega) (by omega)).1.trans hub)
  have r14 : S2.mem.readVec (B.slot 14) = Bp.v :=
    (hk2 14 (by omega) (by omega)).1.trans ((hK1 14 (by omega) (by omega)).1.trans hvb)
  have r19 : S2.mem.readVec (B.slot 19) = Bp.uv3 :=
    (hk2 19 (by omega) (by omega)).1.trans ((hK1 19 (by omega) (by omega)).1.trans huv3b)
  have hf2 (j : Nat) (h3 : 3 ≤ j) (hj : j < 21) : Fits S2.mem (B.slot j) 512 :=
    (hk2 j h3 hj).2 ((hK1 j h3 (by omega)).2 (hfits j h3 hj))
  have f3 := hf2 3 (by omega) (by omega)
  have f12 := hf2 12 (by omega) (by omega)
  have f4 := hf2 4 (by omega) (by omega)
  have f5 := hf2 5 (by omega) (by omega)
  have f10 := hf2 10 (by omega) (by omega)
  have f13 := hf2 13 (by omega) (by omega)
  have f14 := hf2 14 (by omega) (by omega)
  have f19 := hf2 19 (by omega) (by omega)
  clear hk2 hK1 hu hv huv3 hub hvb huv3b hy hyb hf2 hfits
  have f22 := hF.vec 22
  have f23 := hF.vec 23
  have f24 := hF.vec 24
  have f25 := hF.vec 25
  have f30 := hF.vec 30
  have f31 := hF.vec 31
  have f32 := hF.vec 32
  have f33 := hF.vec 33
  have hR2 :
    E2 ⊨ [rir_reg% hty 47 := B.slot 4, rir_reg% hty 48 := B.slot 5, rir_reg% hty 53 := B.slot 10,
      rir_reg% hty 56 := B.slot 13, rir_reg% hty 57 := B.slot 14, rir_reg% hty 62 := B.slot 19,
      rir_reg% hty 64 := B.slot 21, rir_reg% hty 65 := B.slot 22, rir_reg% hty 66 := B.slot 23,
      rir_reg% hty 67 := B.slot 24, rir_reg% hty 68 := B.slot 25, rir_reg% hty 72 := B.slot 29,
      rir_reg% hty 73 := B.slot 30, rir_reg% hty 74 := B.slot 31, rir_reg% hty 75 := B.slot 32,
      rir_reg% hty 76 := B.slot 33, rir_reg% hty 33 := 0#32] := by
    chain_reads
  -- `fd_f25519_mul2( xa, xa, uv3a, xb, xb, uv3b )`
  step_call using fd_f25519_mul2.call_eq
  name_vec xb
  name_vec xa
  -- `fd_f25519_sqr2( x2a, xa, x2b, xb )`, `fd_f25519_mul2( vx2a, va, x2a, vx2b, vb, x2b )`
  step_call using fd_f25519_sqr2.call_eq
  name_vec x2b
  name_vec x2a
  step_call using fd_f25519_mul2.call_eq
  name_vec vx2b
  name_vec vx2a
  -- `t1a = vx2a - ua`, `t2a = vx2a + ua`, `t1b`, `t2b`
  step_call using fd_f25519_sub.call_eq
  name_vec t1a
  step_call using fd_f25519_add.call_eq
  name_vec t2a
  step_call using fd_f25519_sub.call_eq
  name_vec t1b
  step_call using fd_f25519_add.call_eq
  name_vec t2b
  step_call using fd_f25519_is_nonzero.call_eq with t1nza
  step_call using fd_f25519_is_nonzero.call_eq with t2nza
  step_call using fd_f25519_is_nonzero.call_eq with t1nzb
  step_call using fd_f25519_is_nonzero.call_eq with t2nzb
  step_pure with transparent erra
  step_pure
  have hDA :
    dec A (mulQ (sqrQ (sqrQ (mulQ T1 T0))) Aq).unpack.1 =
      ⟨A.x0, A.y, A.u, A.v, xa, t1nza, t2nza⟩ := by
    rw [ht1nza, ht2nza, ht1a, ht2a, hvx2a, hx2a, hxa]; rfl
  have hDB :
    dec Bp (mulQ (sqrQ (sqrQ (mulQ T1 T0))) Aq).unpack.2.1 =
      ⟨Bp.x0, Bp.y, Bp.u, Bp.v, xb, t1nzb, t2nzb⟩ := by
    rw [ht1nzb, ht2nzb, ht1b, ht2b, hvx2b, hx2b, hxb]; rfl
  have hI' : Inv B M (c + 8) S := by
    refine ⟨hwf, hF, ?_, ?_⟩
    · rw [hS]
      simp (disch := decide) only [eraseFrom_storeVec_slot]
      exact herase
    · rw [hS]
      simp only [halloc]
      omega
  finish_block
  all_goals
    have hW : Writes Ein E 1227 1341 := by
      refine (hB0.mono).trans ((hB1.mono).trans ((hB2.mono).trans ?_))
      simp only [hE]
      repeat refine Writes.write ?_ (by decide)
      exact Writes.refl _ _ _
  · have hRo1 :
      E ⊨ [rir_reg% hty 1335 := t1nza, rir_reg% hty 1337 := t1nzb, rir_reg% hty 1338 := t2nzb] := by
      simp (disch := decide) only [hE, Env.read_write_ne', read_write_same, and_self]
    have hW2 : Writes E2 E 1331 1341 := by
      simp only [hE]
      repeat refine Writes.write ?_ (by decide)
      exact Writes.refl _ _ _
    have hRo :
      E ⊨ [rir_reg% hty 1228 := ba.setWidth 32 >>> 7, rir_reg% hty 1230 := bb.setWidth 32 >>> 7,
        rir_reg% hty 1335 := t1nza, rir_reg% hty 1337 := t1nzb, rir_reg% hty 1338 := t2nzb] := by
      chain_reads
    refine
      hK E S (hW.1.trans (hB0.1.symm.trans hArgs)) hW ?_ hI' ‹_› ‹_› (by rwa [hDA]) (by rwa [hDB])
        (by mem_fact) (by mem_fact) (by mem_fact) (by mem_fact)
        (by
          rw [hDA]; exact hbr)
    rw [hDA, hDB]
    exact hRo
  · exact
      hK9 E S (hW.1.trans (hB0.1.symm.trans hArgs)) hW hI'
        (by
          rw [hDA]; exact hbr)

end

end MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2
