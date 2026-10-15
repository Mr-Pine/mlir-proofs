module

public import Firedancer.Avx512.fd_r43x6_ge_decode2
public import Firedancer.Lane.Common.Decode
public import Firedancer.Lane.Mlir.fd_r43x6_ge_decode2
public import Firedancer.Lane.fd_r43x6_pow22523_2
public import MLIR.Run.Tactic
import Mathlib.Tactic.CasesM
import Std.Tactic.BVDecide

/-! `fd_r43x6_ge_decode2` as the lane build compiles it: all callees but `fd_r43x6_pow22523_2`
inlined, `fd_r43x6_is_nonzero` and `fd_r43x6_diagnose` partly vectorized over both points. Stated
against the `Avx512` proof's `dec`, `result` and `spec`; the frames count `20` blocks (the two slots
and `fd_r43x6_pow22523_2`'s `18`).

Blocks end by `finish_block only []`: the default simp set decides a register's type by unfolding
`Γ`, too deep (maximum recursion) for registers past about `1500`. -/

namespace MLIR.Firedancer.Lane.fd_r43x6_ge_decode2

open Firedancer.Avx512
open Firedancer.Avx512.fd_r43x6_ge_decode2 (Dec Dec.ok dec decodePt packAt foldAt fill d sqrtM1
  pSubOne vsub result spec storeOut)

/-- The lift's registers' context. -/
local notation "Γ" => _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode2.Γ

/-- The lift's run from a block. -/
local notation "runL" => _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode2.runFrom

/-- Register `k` as a destination. -/
local macro "%%%" k:num : term => `(rir_dst% _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode2.hty $k)

/-- Register `k`, its type from the lift's proof (deciding it would unfold `Γ`). -/
local macro "%%" k:num : term => `(rir_reg% _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode2.hty $k)

@[expose] public section

/-! ## The blocks -/

variable {a03 a14 a25 sa b03 b14 b25 sb : Pointer}

variable (a03 a14 a25 sa b03 b14 b25 sb) in
/-- The arguments: the six out-vectors and the two encodings. -/
abbrev argsOf : Vals (Ctx.args Γ) :=
  _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode2.args (.value a03) (.value a14) (.value a25)
      (.value sa) (.value b03) (.value b14) (.value b25)
    (.value sb)

/-- `^bb5`: `*_Pb25 = %1807`, then return `%1808`. -/
theorem bb5_run (E : ⟪Γ⟫) (S : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (v : Vector (BitVec 64) 8)
    (r : BitVec 32) (hv : E.read (%%1807) = Ty.wrap v) (hr : E.read (%%1808) = .value r)
    (hb25 : Room S.mem b25 512) (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK : .value (.cons (.value r) .nil, { S with mem := S.mem.storeAt b25 (BitVec.packLanes v) })
        = K) :
    runL E 5 S = K := by
  block_init
  step_store consuming hb25 hfits_b25
  finish_block only [hr]
  rw [← hK, hS]

/-- `^bb3`: the first encoding does not decode; all six out-vectors zeroed (`%73`), then `-1`
(`%0`). -/
theorem bb3_run (E : ⟪Γ⟫) (S : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (z : Vector (BitVec 64) 8)
    (r : BitVec 32) (hz : E.read (%%73) = Ty.wrap z) (hr : E.read (%%0) = .value r)
    (ha03 : Room S.mem a03 512) (ha14 : Room S.mem a14 512) (ha25 : Room S.mem a25 512)
    (hb03 : Room S.mem b03 512) (hb14 : Room S.mem b14 512) (hb25 : Room S.mem b25 512)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK :
      .value (.cons (.value r) .nil, { S with mem := fill a03 a14 a25 b03 b14 b25 S.mem z }) = K) :
    runL E 3 S = K := by
  subst hK
  block_init
  iterate 5 step_store
  finish_block only [hz, hr]
  step_loop using bb5_run

/-- `^bb4`: the second encoding does not decode; all six out-vectors zeroed (`%73`), then `-2`
(`%1`). -/
theorem bb4_run (E : ⟪Γ⟫) (S : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (z : Vector (BitVec 64) 8)
    (r : BitVec 32) (hz : E.read (%%73) = Ty.wrap z) (hr : E.read (%%1) = .value r)
    (ha03 : Room S.mem a03 512) (ha14 : Room S.mem a14 512) (ha25 : Room S.mem a25 512)
    (hb03 : Room S.mem b03 512) (hb14 : Room S.mem b14 512) (hb25 : Room S.mem b25 512)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK :
      .value (.cons (.value r) .nil, { S with mem := fill a03 a14 a25 b03 b14 b25 S.mem z }) = K) :
    runL E 4 S = K := by
  subst hK
  block_init
  iterate 5 step_store
  finish_block only [hz, hr]
  step_loop using bb5_run

/-- An encoding's lanes, lane `3` replaced: the lanes of the encoding with its top word spliced. -/
theorem set3_splice (s : BitVec 256) (y : BitVec 64) (h : 3 < 4) :
    (Vector.ofFn fun i : Fin 4 => Ty.extractVecElem 4 64 i s).set 3 y h =
      Vector.ofFn fun i => Ty.extractVecElem 4 64 i (Memory.spliceBits s 192 y) := by
  apply vec_ext_fin
  intro i
  fin_cases i <;> simp only [Ty.extractVecElem_eq] <;> simp
  · exact (Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega)).symm
  · exact (Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega)).symm
  · exact (Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega)).symm
  · exact (Memory.extractLsb'_spliceBits_self _ _ _ (by omega)).symm

/-- The unpacked encoding as `dec` reads it: its lanes, the top word's sign bit cleared. -/
abbrev decLanes (s : BitVec 256) : Wv :=
  Vector.ofFn fun i => Ty.extractVecElem 4 64 i (Memory.spliceBits s 192 (s.extractLsb' 192 64 &&&
      0x7FFFFFFFFFFFFFFF))

/-- `fd_r43x6_sub_fast( x, y )` plus a constant known on lanes `0 … 5`, as compiled. -/
theorem sub_add_lanesBelow (x y c : Wwl) :
    (Vector.ofFn fun i : Fin 8 => do
        let b ← (lanesBelow 6 c)[↑i]
        PoisonOr.value (x[↑i] - y[↑i] + b)) =
      lanesBelow 6 (vadd (vsub x y) c) := by
  apply vec_ext_fin
  intro i
  fin_cases i <;> simp [lanesBelow, vadd, vsub]

/-- The entry block's constants `^bb2` reads: `one`, `sqrt_m1`, `true`/`false`, the lane indices
`0 1`, `fd_r43x6_mul_fast`'s, `fd_r43x6_neg`'s, `fd_r43x6_diagnose`'s (two lanes), `QUAD_PACK`'s and
`QUAD_FOLD_UNSIGNED`'s. -/
abbrev Bb2Consts (E : ⟪Γ⟫) : Prop :=
  (E ⊨ [%%9 := 1#1, %%5 := 0#1, %%36 := Ty.wrap one, %%8 := Ty.wrap sqrtM1, %%64 := 0#64, %%32 :=
      1#64, %%7 := Ty.wrap negP, %%43 := Ty.wrap negBias, %%45 := Ty.wrap neg18, %%44 :=
      Ty.wrap negSel, %%6 := Ty.wrap (Vector.replicate 2 1#32), %%208 := oneLo, %%216 := oneHi,
      %%4 := Ty.wrap (Vector.replicate 8 43), %%3 := Ty.wrap quadShifts, %%68 :=
      Ty.wrap (Vector.replicate 8 8796093022207), %%2 := Ty.wrap quadFoldMask, %%224 := quad19,
      %%80 := 0#32]) ∧
    MulConsts E (%%%73) (%%%74) (%%%120) (%%%144) (%%%152) (%%%160) (%%%168) (%%%176) (%%%184)
      (%%%136) (%%%192) (%%%52) (%%%51) (%%%50) (%%%49) (%%%48) (%%%47) ∧
    Nz2Consts E (%%%19) (%%%18) (%%%17) (%%%16) (%%%15) (%%%14) (%%%13) (%%%12) (%%%11) (%%%10)

/-- `fd_r43x6_if( c, x, y )` as compiled: a byte mask from `!c`, as eight `i1` lanes, selecting `x`
where set. -/
theorem select_not_mask (b : Bool) (h : 8 = 8) (x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        if
            Ty.extractVecElem 8 1 i
                (BitVec.cast h (BitVec.signExtend 8 (BitVec.ofBool b) ^^^ 255#8)) =
              1#1 then
          x[↑i]
        else y[↑i]) =
      if b then y else x := by
  have h1 : ∀ k : Fin 8, Ty.extractVecElem 8 1 k 255#8 = 1#1 := by
    intro k; fin_cases k <;> simp [Ty.extractVecElem_eq]
  have h0 : ∀ k : Fin 8, Ty.extractVecElem 8 1 k 0#8 = 0#1 := by
    intro k; fin_cases k <;> simp [Ty.extractVecElem_eq]
  cases b <;> apply vec_ext_fin <;> intro i <;> fin_cases i <;> simp [h0, h1]

/-- `fd_r43x6_if( c, x, y )` on a `c` already an `i1`. -/
theorem select_mask (k : BitVec 1) (h : 8 = 8) (x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        if Ty.extractVecElem 8 1 i (BitVec.cast h (BitVec.signExtend 8 k)) = 1#1 then x[↑i]
        else y[↑i]) =
      if k = 1#1 then x else y := by
  have h1 : ∀ k : Fin 8, Ty.extractVecElem 8 1 k 255#8 = 1#1 := by
    intro k; fin_cases k <;> simp [Ty.extractVecElem_eq]
  have h0 : ∀ k : Fin 8, Ty.extractVecElem 8 1 k 0#8 = 0#1 := by
    intro k; fin_cases k <;> simp [Ty.extractVecElem_eq]
  have hk : k = 0#1 ∨ k = 1#1 := by bv_decide
  rcases hk with rfl | rfl <;> apply vec_ext_fin <;> intro i <;> fin_cases i <;> simp [h0, h1]

/-- `x_0 != x_mod_2` as compiled: the reduction nonzero and its low bit `x_0`, for `x_0` a bit. -/
theorem keep_iff (n : BitVec 1) (p x0 : BitVec 32) (h01 : x0 = 0 ∨ x0 = 1) :
    (if n = 1#1 then BitVec.ofBool (p == x0) else 0#1) = 1#1 ↔
      (if n = 0#1 then -1 else p) = x0 := by
  rcases h01 with rfl | rfl <;> bv_decide

/-- `x = fd_r43x6_if( x_0 != x_mod_2, fd_r43x6_neg( x ), x )` as compiled. -/
theorem keep_select (x : Wwl) (x0 : BitVec 32) (h01 : x0 = 0 ∨ x0 = 1) (a b : Wwl) :
    (if (if nzBit x = 1#1 then BitVec.ofBool (parLimbs x[0] x[1] x[2] x[3] x[4] x[5] == x0)
          else 0#1) = 1#1 then a else b) =
      if fd_r43x6_diagnose.spec x = x0 then a else b := by
  rw [diagnose_eq]
  exact if_congr (keep_iff _ _ _ h01) rfl rfl

/-- `^bb2`: both encodings decode; finish both points and store them as QUADs. -/
theorem bb2_run (E : ⟪Γ⟫) (S₀ : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (xa ya xb yb : Wwl)
    (x0a x0b t1nza t1nzb : BitVec 32) (hC : Bb2Consts E)
    (hR :
      E ⊨ [%%1005 := xa, %%1051 := xb, %%244 := ya, %%251 := yb, %%233 := #v[x0b, x0a], %%1372 :=
        BitVec.ofBool (t1nza != 0), %%1306 := BitVec.ofBool (t1nzb != 0)])
    (hx0a : x0a = 0 ∨ x0a = 1) (hx0b : x0b = 0 ∨ x0b = 1)
    (ha03 : Room S₀.mem a03 512) (ha14 : Room S₀.mem a14 512) (ha25 : Room S₀.mem a25 512)
    (hb03 : Room S₀.mem b03 512) (hb14 : Room S₀.mem b14 512) (hb25 : Room S₀.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) (hwf : S₀.WF) :
    runL E 2 S₀ =
      let A := decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one xa ya t1nza x0a
      let B := decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one xb yb t1nzb x0b
      .value
        (.cons (.value 0) .nil,
          { S₀ with
            mem :=
              foldAt (foldAt (packAt (packAt S₀.mem a03 a14 a25 A) b03 b14 b25 B) a03 a14 a25 A) b03
                b14 b25 B }) := by
  -- the reads as single facts, so the steps' sealing carries them
  dsimp only [Bb2Consts, MulConsts, Nz2Consts] at hC
  casesm* _ ∧ _
  block_init
  -- `t3a = fd_r43x6_if( t1nza, sqrt_m1, one )`, `t3b` likewise
  step_pure
  step_pure
  step_pure
  step_pure with t3a
  step_pure
  step_pure
  step_pure
  step_pure with t3b
  replace ht3a : t3a = if t1nza != 0 then sqrtM1 else one := by
    rw [ht3a]; exact select_not_mask _ _ _ _
  replace ht3b : t3b = if t1nzb != 0 then sqrtM1 else one := by
    rw [ht3b]; exact select_not_mask _ _ _ _
  -- `FD_R43X6_MUL2_INL( xa, xa, t3a, xb, xb, t3b )`
  step_pattern using runBodyFrom_mulRun with xa'
  step_pattern using runBodyFrom_mulRun with xb'
  -- `fd_r43x6_neg( xa )`, then `x_mod_2a`, `x_mod_2b` against `x_0a`, `x_0b`
  step_pattern using runBodyFrom_negRun with nxa
  step_pattern using runBodyFrom_diag2Run with diag hdiag
  step_pure
  step_pure
  step_pure with keepa
  step_pure
  step_pure
  step_pure with xa''
  step_pure
  step_pure
  step_pure with keepb
  step_pure
  step_pattern using runBodyFrom_negRun with nxb
  step_pure
  step_pure with xb''
  replace hxa'' : xa'' = if keepa = 1#1 then xa' else nxa := by
    rw [hxa'']; exact select_mask _ _ _ _
  replace hxb'' : xb'' = if keepb = 1#1 then xb' else nxb := by
    rw [hxb'']; exact select_mask _ _ _ _
  rw [hkeepa, hdiag] at hxa''
  rw [hkeepb, hdiag] at hxb''
  simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ] at hxa'' hxb''
  replace hxa'' : xa'' = if fd_r43x6_diagnose.spec xa' = x0a then xa' else nxa := by
    rw [hxa'']; exact keep_select _ _ hx0a _ _
  replace hxb'' : xb'' = if fd_r43x6_diagnose.spec xb' = x0b then xb' else nxb := by
    rw [hxb'']; exact keep_select _ _ hx0b _ _
  clear hkeepa hkeepb hdiag
  -- `FD_R43X6_MUL2_INL( xya, xa, ya, xyb, xb, yb )`
  step_pattern using runBodyFrom_mulRun with xya
  step_pattern using runBodyFrom_mulRun with xyb
  -- `FD_R43X6_QUAD_PACK( a, xa, ya, one, xya )`, `b` likewise
  step_pattern using runBodyFrom_quadPackRun
  step_pattern using runBodyFrom_quadPackRun
  -- `FD_R43X6_QUAD_FOLD_UNSIGNED( *_Pa, a )`, `b` likewise; `b`'s limbs `2 5` stored in `^bb5`
  step_pattern using runBodyFrom_quadFoldRun with a'
  step_store
  step_pattern using runBodyFrom_quadFoldRun with b'
  finish_block only []
  -- `^bb5`'s result, then the named values against the statement's
  step_loop using bb5_run (v := b') (r := 0)
  rfl

/-- `fd_r43x6_is_nonzero`'s scalar constants, as `^bb0` defines them. -/
abbrev NzConstsAt (E : ⟪Γ⟫) : Prop :=
  NzConsts E (%%%64) (%%%32) (%%%31) (%%%60) (%%%30) (%%%29) (%%%28) (%%%27) (%%%26) (%%%25) (%%%24)
    (%%%23) (%%%22) (%%%21) (%%%20)

/-- `Dec.ok` through the compiled checks: both answers `0` or `1`, `ok` unless both are nonzero. -/
theorem ok_iff (t2 t1 : BitVec 32) (h2 : t2 = 0 ∨ t2 = 1) (h1 : t1 = 0 ∨ t1 = 1) :
    t2 &&& t1 = 0#32 ↔ ¬BitVec.ofBool (t2 != 0) &&& BitVec.ofBool (t1 != 0) = 1#1 := by
  rcases h2 with rfl | rfl <;> rcases h1 with rfl | rfl <;> decide

/-- `ok_iff` through `nzBit`. -/
theorem ok_iff' (X Y : Wwl) :
    fd_r43x6_is_nonzero.spec X &&& fd_r43x6_is_nonzero.spec Y = 0#32 ↔
      ¬nzBit X &&& nzBit Y = 1#1 :=
  ok_iff _ _ (fd_r43x6_is_nonzero.spec_01 _) (fd_r43x6_is_nonzero.spec_01 _)

/-- `^bb1`, for `A` already checked: the second point's last check, `B.vx2 + B.u` nonzero as
`%1306` (`B.t1nz`) is. Both nonzero: `^bb4`'s failure; else `^bb2`. -/
theorem bb1_run (E : ⟪Γ⟫) (S : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (A B : Dec) (hC : Bb2Consts E)
    (hN : NzConstsAt E)
    (hR :
      E ⊨ [%%1005 := A.x, %%1051 := B.x, %%244 := A.y, %%251 := B.y, %%233 := #v[B.x0, A.x0],
        %%1372 := BitVec.ofBool (A.t1nz != 0), %%1306 := BitVec.ofBool (B.t1nz != 0), %%1237 :=
        B.vx2, %%363 := B.u, %%73 := wwl_zero, %%1 := (-2 : BitVec 32)])
    (hx0a : A.x0 = 0 ∨ A.x0 = 1) (hx0b : B.x0 = 0 ∨ B.x0 = 1)
    (h2 : B.t2nz = fd_r43x6_is_nonzero.spec (vadd B.vx2 B.u)) (h1 : B.t1nz = 0 ∨ B.t1nz = 1)
    (hA : A.ok) (ha03 : Room S.mem a03 512) (ha14 : Room S.mem a14 512) (ha25 : Room S.mem a25 512)
    (hb03 : Room S.mem b03 512) (hb14 : Room S.mem b14 512) (hb25 : Room S.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) (hwf : S.WF) :
    runL E 1 S = result a03 a14 a25 b03 b14 b25 id S A B := by
  have hC' := hC
  dsimp only [Bb2Consts, MulConsts, Nz2Consts, NzConstsAt, NzConsts] at hC' hN
  casesm* _ ∧ _
  simp only [result, ite_eq_left hA]
  block_init
  step_pure with t2b
  step_pattern using runBodyFrom_nz1Run' with nz2b
  step_pure
  finish_block only []
  all_goals rw [hnz2b, ht2b] at hbr
  · -- `^bb4`
    have hB : ¬B.ok := by
      rw [Dec.ok, ok_iff _ _ (h2 ▸ fd_r43x6_is_nonzero.spec_01 _) h1, not_not, h2]
      exact hbr
    rw [ite_eq_right hB]
    step_loop using bb4_run
    rfl
  · -- `^bb2`
    have hB : B.ok := by
      rw [Dec.ok, ok_iff _ _ (h2 ▸ fd_r43x6_is_nonzero.spec_01 _) h1, h2]
      exact hbr
    rw [ite_eq_left hB]
    step_loop using bb2_run

/-- `dec s` as `^bb0` computes it, from the values its steps name. -/
theorem dec_eq (s : BitVec 256) (ysq u dysq v v2 v4 v3 uv3 uv7 t0 x x2 vx2 : Wwl)
    (hysq : ysq = fd_r43x6_sqr (fd_r43x6_unpack.spec (decLanes s)))
    (hu : u = vadd (foldSignedPre (vadd ysq pSubOne)) negBias)
    (hdysq : dysq = fd_r43x6_mul d ysq) (hv : v = vadd dysq one) (hv2 : v2 = fd_r43x6_sqr v)
    (hv4 : v4 = fd_r43x6_sqr v2) (hv3 : v3 = fd_r43x6_mul v v2) (huv3 : uv3 = fd_r43x6_mul u v3)
    (huv7 : uv7 = fd_r43x6_mul uv3 v4) (ht0 : t0 = fd_r43x6_pow22523_2.spec uv7)
    (hx : x = fd_r43x6_mul uv3 t0) (hx2 : x2 = fd_r43x6_sqr x) (hvx2 : vx2 = fd_r43x6_mul v x2) :
    dec s =
      ⟨s.extractLsb' 192 64 &&& 0x7FFFFFFFFFFFFFFF, (s.extractLsb' 192 64 >>> 63).setWidth 32,
        fd_r43x6_unpack.spec (decLanes s),
        foldSignedPre (vadd ysq pSubOne), u, v, t0, x, vx2,
        fd_r43x6_is_nonzero.spec (vadd (vsub vx2 (foldSignedPre (vadd ysq pSubOne))) negP),
        fd_r43x6_is_nonzero.spec (vadd vx2 u)⟩ := by
  subst_vars
  rfl

/-- The state `^bb0` leaves: the slots `_t0a _t0b` (`S₀`'s first two), the powers stored in them
and freed, and `fd_r43x6_pow22523_2`'s frames counted. -/
def frame (S₀ : GlobalState) (A B : Dec) : GlobalState :=
  let S₁ := (S₀.alloca 64 true).alloca 64 true
  { alloc := ⟨S₁.alloc.nextFreeBlock + 18⟩,
    mem :=
      (((((S₁.mem.lifetimeStart (S₀.slot 0)).lifetimeStart (S₀.slot 1)).storeVec (S₀.slot 0)
                  A.t0).storeVec
              (S₀.slot 1) B.t0).lifetimeEnd
          (S₀.slot 1)).lifetimeEnd
        (S₀.slot 0) }

/-- The sign bit, as an `int`, is `0` or `1`. -/
theorem shr63_01 (y : BitVec 64) : (y >>> 63).setWidth 32 = 0 ∨ (y >>> 63).setWidth 32 = 1 := by
  bv_decide

-- the entry block: about 170 steps over 1390 instructions, in a context of some 200 facts: over
-- 1000000 heartbeats
set_option maxHeartbeats 2000000 in
/-- `^bb0`: both encodings unpacked to `y`, `x` recovered from `x² = (y² - 1) / (d y² + 1)` up to
the root of `-1`, and checked; on to `^bb1`, else `^bb3`. -/
theorem bb0_run (E : ⟪Γ⟫) (S₀ : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (hwf : S₀.WF)
    (hsa : Fits S₀.mem sa 256) (hsb : Fits S₀.mem sb 256) (ha03 : Room S₀.mem a03 512)
    (ha14 : Room S₀.mem a14 512) (ha25 : Room S₀.mem a25 512) (hb03 : Room S₀.mem b03 512)
    (hb14 : Room S₀.mem b14 512) (hb25 : Room S₀.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) :
    runL E 0 S₀ =
      let A := dec (S₀.mem.readAt sa 256)
      let B := dec (S₀.mem.readAt sb 256)
      result a03 a14 a25 b03 b14 b25 id (frame S₀ A B) A B := by
  block_init
  -- the constants, left inline: the patterns read them as literals
  iterate 81 step_pure
  -- the masks, the slides' zero operands and the QUADs' lanes, by `insertelement`s
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 1 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 6 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 4 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 negP)
  step_pattern using runBodyFrom_padRunAs (oneLo)
  step_pattern using runBodyFrom_padRunAs (oneHi)
  step_pattern using runBodyFrom_padRunAs (quad19)
  -- `_t0a`, `_t0b`: the slots `fd_r43x6_pow22523_2` stores to
  step_alloca with _t0a
  step_alloca with _t0b
  -- `wv_ld( _vsa )`, `wv_ld( _vsb )`
  step_load with lda
  step_load with ldb
  -- `y3a = _sa[3]`, `y3b = _sb[3]`; `x_0a = (int)(y3a>>63)`, `x_0b` likewise
  step_pure with y3a
  step_pure with y3b
  step_pure
  step_pure
  step_pure [Avx512.fd_r43x6_ge_decode2.shr63_trunc] with x0v
  replace hx0v :
      x0v =
        #v[((S₀.mem.readAt sb 256).extractLsb' 192 64 >>> 63).setWidth 32,
          ((S₀.mem.readAt sa 256).extractLsb' 192 64 >>> 63).setWidth 32] := by
    rw [hx0v, hlda, hldb]
    apply vec_ext_fin
    intro i
    fin_cases i <;> simp [Ty.extractVecElem_eq]
  -- `y3a &= ~(1UL<<63); _sa[3] = y3a`, `b` likewise
  step_pure with y3a'
  step_pure with y3b'
  step_pure with ua0
  step_pure with ub0
  have hua : ua0 = decLanes (S₀.mem.readAt sa 256) := by
    rw [hua0, hy3a', hy3a, hlda, set3_splice]
    simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, decLanes]
    rfl
  have hub : ub0 = decLanes (S₀.mem.readAt sb 256) := by
    rw [hub0, hy3b', hy3b, hldb, set3_splice]
    simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, decLanes]
    rfl
  clear hua0 hub0
  subst hua hub
  -- `ya = fd_r43x6_unpack( wv_ld( _sa ) )`, `yb` likewise
  step_pattern using runBodyFrom_unpackRun with ya
  step_pattern using runBodyFrom_unpackRun with yb
  -- `FD_R43X6_SQR2_INL( ysqa, ya, ysqb, yb )`
  step_pattern using runBodyFrom_sqrRunNW (hX := unpack_lt _) with ysqa
  step_pattern using runBodyFrom_sqrRunNW (hX := unpack_lt _) with ysqb
  -- `ua = fd_r43x6_sub( ysqa, one )`, `ub` likewise
  step_pattern using runBodyFrom_subRun with ua hua
  step_pattern using runBodyFrom_subRun with ub hub
  -- `va = fd_r43x6_add_fast( fd_r43x6_mul( d, ysqa ), one )`, `vb` likewise
  step_pattern using runBodyFrom_mulRowsRun d with dysqa
  step_pure with va
  step_pattern using runBodyFrom_mulRowsRun d with dysqb
  step_pure with vb
  -- `FD_R43X6_SQR2_INL( v2a, va, v2b, vb )`, then `v4`
  step_pattern using runBodyFrom_r43SqrRun with v2a
  step_pattern using runBodyFrom_r43SqrRun with v2b
  step_pattern using runBodyFrom_r43SqrRun with v4a
  step_pattern using runBodyFrom_r43SqrRun with v4b
  -- `FD_R43X6_MUL2_INL( v3a, va,v2a, v3b, vb,v2b )`, `va vb` broadcast once for `vx2` too
  step_pure with bva0
  step_pure with bva1
  step_pure with bva2
  step_pure with bva3
  step_pure with bva4
  step_pure with bva5
  step_pattern using runBodyFrom_mulRowsRun va with v3a
  step_pure with bvb0
  step_pure with bvb1
  step_pure with bvb2
  step_pure with bvb3
  step_pure with bvb4
  step_pure with bvb5
  step_pattern using runBodyFrom_mulRowsRun vb with v3b
  -- `uv3`, then `uv7`, `uv3` broadcast once for `x` too
  step_pattern using runBodyFrom_mulRun with uv3a
  step_pattern using runBodyFrom_mulRun with uv3b
  step_pure with buv3a0
  step_pure with buv3a1
  step_pure with buv3a2
  step_pure with buv3a3
  step_pure with buv3a4
  step_pure with buv3a5
  step_pattern using runBodyFrom_mulRowsRun uv3a with uv7a
  step_pure with buv3b0
  step_pure with buv3b1
  step_pure with buv3b2
  step_pure with buv3b3
  step_pure with buv3b4
  step_pure with buv3b5
  step_pattern using runBodyFrom_mulRowsRun uv3b with uv7b
  -- `FD_R43X6_POW22523_2_INL( t0a, uv7a, t0b, uv7b )`, through the slots `_t0a _t0b`
  iterate 2 step_pure
  step_call using MLIR.Firedancer.Lane.fd_r43x6_pow22523_2.call_eq
  step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with t0a
  step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with t0b
  iterate 2 step_pure
  -- `FD_R43X6_MUL2_INL( xa, uv3a,t0a, xb, uv3b,t0b )`, `x2`, then `vx2 = v x2`
  step_pattern using runBodyFrom_mulRowsRun uv3a with xa
  step_pattern using runBodyFrom_mulRowsRun uv3b with xb
  step_pattern using runBodyFrom_r43SqrRun with x2a
  step_pattern using runBodyFrom_r43SqrRun with x2b
  step_pattern using runBodyFrom_mulRowsRun va with vx2a
  step_pattern using runBodyFrom_mulRowsRun vb with vx2b
  -- `t1a = fd_r43x6_sub_fast( vx2a, ua )`, `t1b` likewise (lanes `0 … 5`), `t2a = vx2a + ua`
  step_pure
  step_pure with t1a
  step_pure
  step_pure with t1b
  step_pure with t2a
  replace ht1a : t1a = lanesBelow 6 (vadd (vsub vx2a (foldSignedPre (vadd ysqa pSubOne))) negP) :=
      by
    rw [ht1a]; exact sub_add_lanesBelow _ _ _
  replace ht1b : t1b = lanesBelow 6 (vadd (vsub vx2b (foldSignedPre (vadd ysqb pSubOne))) negP) :=
      by
    rw [ht1b]; exact sub_add_lanesBelow _ _ _
  subst ht1a ht1b ht2a
  -- `t1nzb = fd_r43x6_is_nonzero( t1b )`; `t2nza`, `t1nza` at once
  step_pattern using runBodyFrom_nz1Run with t1nzb
  step_pattern using runBodyFrom_nz2Run with nz2a
  step_pure
  step_pure
  step_pure
  -- both encodings' `dec`, as the values just computed
  have hA :=
    dec_eq (S₀.mem.readAt sa 256) ysqa ua dysqa va v2a v4a v3a uv3a uv7a t0a xa x2a vx2a hysqa
      hua hdysqa hva hv2a hv4a hv3a huv3a huv7a ht0a hxa hx2a hvx2a
  have hB :=
    dec_eq (S₀.mem.readAt sb 256) ysqb ub dysqb vb v2b v4b v3b uv3b uv7b t0b xb x2b vx2b hysqb
      hub hdysqb hvb hv2b hv4b hv3b huv3b huv7b ht0b hxb hx2b hvx2b
  have hF : frame S₀ (dec (S₀.mem.readAt sa 256)) (dec (S₀.mem.readAt sb 256)) = S := by
    rw [hA, hB, hS, h_t0a, h_t0b, ht0a, ht0b]
    rfl
  finish_block only []
  all_goals
    rw [hnz2a] at hbr
    simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
      List.getElem_cons_succ] at hbr
    rw [hF]
  · -- `^bb3`: the first encoding does not decode
    have hok : ¬(dec (S₀.mem.readAt sa 256)).ok := by
      rw [hA, Dec.ok, ok_iff', not_not]
      exact hbr
    simp only [result, ite_eq_right hok]
    step_loop using bb3_run
  · -- `^bb1`: the second encoding's last check
    have hok : (dec (S₀.mem.readAt sa 256)).ok := by
      rw [hA, Dec.ok, ok_iff']
      exact hbr
    step_loop using bb1_run (A := dec (S₀.mem.readAt sa 256)) (B := dec (S₀.mem.readAt sb 256))
    any_goals rfl
    any_goals exact shr63_01 _
    any_goals exact fd_r43x6_is_nonzero.spec_01 _

/-- `fd_r43x6_ge_decode2` on the encodings at `sa sb`, into the out-vectors `a03 … b25`: `result`
over the caller's memory, with `20` blocks counted for the frames it used. -/
theorem call_eq_result (s : GlobalState) (hwf : s.WF) (hsa : Fits s.mem sa 256)
    (hsb : Fits s.mem sb 256) (ha03 : Room s.mem a03 512) (ha14 : Room s.mem a14 512)
    (ha25 : Room s.mem a25 512) (hb03 : Room s.mem b03 512) (hb14 : Room s.mem b14 512)
    (hb25 : Room s.mem b25 512) (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) :
    _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode2.call (argsOf a03 a14 a25 sa b03 b14 b25 sb) s =
      let A := dec (s.mem.readAt sa 256)
      let B := dec (s.mem.readAt sb 256)
      result a03 a14 a25 b03 b14 b25 id ⟨⟨s.alloc.nextFreeBlock + 20⟩, s.mem⟩ A B := by
  func_init
  rw [hS]
  erw [bb0_run E S₀ hEargs hwf₀ hsa₀ hsb₀ ha03₀ ha14₀ ha25₀ hb03₀ hb14₀ hb25₀ hids]
  simp only [result]
  generalize dec (S₀.mem.readAt sa 256) = A, dec (S₀.mem.readAt sb 256) = B
  by_cases ha : A.ok <;> by_cases hb : B.ok <;>
    simp only [ha, hb, ↓reduceIte, PoisonOr.value_bind, frame, GlobalState.alloca_alloc, fill,
      foldAt, packAt, Nat.add_assoc, id_eq] <;>
    erase_frame

/-- `fd_r43x6_ge_decode2` on the encodings at `sa sb` stores `spec`'s points at `a03 a14 a25` and
`b03 b14 b25` (six distinct blocks) and returns its value; its frames count `20` blocks. -/
theorem call_eq (s : GlobalState) (hwf : s.WF) (hsa : Fits s.mem sa 256) (hsb : Fits s.mem sb 256)
    (ha03 : Room s.mem a03 512) (ha14 : Room s.mem a14 512) (ha25 : Room s.mem a25 512)
    (hb03 : Room s.mem b03 512) (hb14 : Room s.mem b14 512) (hb25 : Room s.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) :
    _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_decode2.call (argsOf a03 a14 a25 sa b03 b14 b25 sb) s =
      let R := spec (dec (s.mem.readAt sa 256)) (dec (s.mem.readAt sb 256))
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 20⟩,
            mem := storeOut a03 a14 a25 b03 b14 b25 s.mem R.2.1 R.2.2 }) := by
  rw [call_eq_result s hwf hsa hsb ha03 ha14 ha25 hb03 hb14 hb25 hids]
  simp only [List.nodup_cons, List.mem_cons, List.mem_nil_iff, or_false, not_or] at hids
  obtain ⟨⟨h01, h02, h03, h04, h05⟩, ⟨h12, h13, h14, h15⟩, ⟨h23, h24, h25⟩, ⟨h34, h35⟩, h45, -⟩ :=
    hids
  generalize dec (s.mem.readAt sa 256) = A, dec (s.mem.readAt sb 256) = B
  by_cases ha : A.ok <;> by_cases hb : B.ok <;> simp only [result, spec, ha, hb, ↓reduceIte, id_eq]
  · simp only [storeOut, MemoryState.storeVec, foldAt, packAt, Avx512.fd_r43x6_ge_decode2.quadOf]
    rw [Avx512.fd_r43x6_ge_decode2.storeAt_twice h01 h02 h03 h04 h05 h12 h13 h14 h15 h23 h24 h25 h34
      h35 h45]
  all_goals
    simp only [storeOut, MemoryState.storeVec, fill, Avx512.fd_r43x6_ge_decode2.zeroQuad]
    rw [Avx512.fd_r43x6_ge_decode2.fill_eq h13 h23 h24]

end

end MLIR.Firedancer.Lane.fd_r43x6_ge_decode2
