module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Common.R43x6
public import Firedancer.Avx512.fd_r43x6_quad_mul_fast
public import Firedancer.Avx512.fd_r43x6_quad_sqr_fast
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect
import Std.Data.ExtHashMap.Lemmas
import Firedancer.Common.Memory

/-! Points in memory: `fd_ed25519_point_t`'s `FD_R43X6_QUAD`, three vectors of eight 64-bit lanes
at byte offsets 0, 64, 128, read and stored as a whole. -/

namespace MLIR

@[expose] public section

namespace Firedancer.Avx512

/-- An `FD_R43X6_QUAD` `(X, Y, Z, T)`: lane `j < 4` of `P03`, `P14`, `P25` holds limbs 0, 1, 2 of
coordinate `j`, lane `j + 4` its limbs 3, 4, 5. -/
structure Quad where
  P03 : Wwl
  P14 : Wwl
  P25 : Wwl

/-- `FD_R43X6_QUAD_PACK( Q, x,y,z,t )`: limbs `k` and `k + 3` of `x, y, z, t` into one vector. -/
def Quad.pack (x y z t : Wwl) : Quad :=
  ⟨#v[x[0], y[0], z[0], t[0], x[3], y[3], z[3], t[3]],
    #v[x[1], y[1], z[1], t[1], x[4], y[4], z[4], t[4]],
    #v[x[2], y[2], z[2], t[2], x[5], y[5], z[5], t[5]]⟩

/-- The `_mask` of the `FD_R43X6_QUAD_LANE_*` macros: lanes `j` and `j + 4` for each `immj` set. -/
def quadMask (i0 i1 i2 i3 : Nat) : BitVec 8 :=
  BitVec.ofNat 8 (17 * i0 + 34 * i1 + 68 * i2 + 136 * i3)

/-- `p` in each coordinate, the `M` of `FD_R43X6_QUAD_LANE_SUB_FAST`. -/
def quadP : Quad :=
  ⟨wwl 8796093022189 8796093022189 8796093022189 8796093022189 m43 m43 m43 m43, wwl_bcast m43,
    wwl m43 m43 m43 m43 m40 m40 m40 m40⟩

/-- `FD_R43X6_QUAD_LANE_ADD_FAST( D, S, imm0,imm1,imm2,imm3, P, Q )`: `P + Q` in the coordinates
selected, `S` in the others. -/
def Quad.laneAddFast (S : Quad) (i0 i1 i2 i3 : Nat) (P Q : Quad) : Quad :=
  let m := quadMask i0 i1 i2 i3
  ⟨wwv_add_if m P.P03 Q.P03 S.P03, wwv_add_if m P.P14 Q.P14 S.P14, wwv_add_if m P.P25 Q.P25 S.P25⟩

/-- `FD_R43X6_QUAD_LANE_SUB_FAST( D, S, imm0,imm1,imm2,imm3, P, Q )`: `P + (p - Q)` in the
coordinates selected, `S` in the others. -/
def Quad.laneSubFast (S : Quad) (i0 i1 i2 i3 : Nat) (P Q : Quad) : Quad :=
  S.laneAddFast i0 i1 i2 i3 P
    ⟨wwl_sub quadP.P03 Q.P03, wwl_sub quadP.P14 Q.P14, wwl_sub quadP.P25 Q.P25⟩

/-- `FD_R43X6_QUAD_PERMUTE( D, imm0,imm1,imm2,imm3, S )`: coordinate `j` of `D` is coordinate
`immj` of `S`. -/
def Quad.permute (i0 i1 i2 i3 : Nat) (S : Quad) : Quad :=
  let p :=
    wwl (BitVec.ofNat 64 i0) (BitVec.ofNat 64 i1) (BitVec.ofNat 64 i2) (BitVec.ofNat 64 i3)
      (BitVec.ofNat 64 (4 + i0)) (BitVec.ofNat 64 (4 + i1)) (BitVec.ofNat 64 (4 + i2))
      (BitVec.ofNat 64 (4 + i3))
  ⟨wwl_permute p S.P03, wwl_permute p S.P14, wwl_permute p S.P25⟩

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED( R, P )`. -/
def Quad.foldUnsigned (P : Quad) : Quad :=
  let _Ph03 := wwl_shru P.P03 43
  let _Ph14 := wwl_shru P.P14 43
  let _Ph25 := wwl_shru_vector P.P25 (wwl 43 43 43 43 40 40 40 40)
  let _19_Ph25 := wwl_add _Ph25 (wwl_add (wwl_shl _Ph25 1) (wwl_shl _Ph25 4))
  ⟨wwl_add (wwl_and P.P03 (wwl_bcast m43)) (wwl_pack_halves _19_Ph25 1 _Ph25 0),
    wwl_add (wwl_and P.P14 (wwl_bcast m43)) _Ph03,
    wwl_add (wwl_and P.P25 (wwl m43 m43 m43 m43 m40 m40 m40 m40)) _Ph14⟩

/-- `FD_R43X6_QUAD_FOLD_SIGNED( R, P )`. -/
def Quad.foldSigned (P : Quad) : Quad :=
  let _b0 : BitVec 64 := 159383552 -- 19L<<23
  let _bb : BitVec 64 := 1048576 -- 1L<<20
  let _bias03 := wwl _b0 _b0 _b0 _b0 _bb _bb _bb _bb
  let _bias := wwl_bcast _bb
  let _P03 := wwl_sub P.P03 _bias03
  let _P14 := wwl_sub P.P14 _bias
  let _P25 := wwl_sub P.P25 _bias
  let _Ph03 := wwl_shr _P03 43
  let _Ph14 := wwl_shr _P14 43
  let _Ph25 := wwl_shr_vector _P25 (wwl 43 43 43 43 40 40 40 40)
  let _19_Ph25 := wwl_add _Ph25 (wwl_add (wwl_shl _Ph25 1) (wwl_shl _Ph25 4))
  ⟨wwl_add (wwl_and _P03 (wwl_bcast m43)) (wwl_add (wwl_pack_halves _19_Ph25 1 _Ph25 0) _bias03),
    wwl_add (wwl_and _P14 (wwl_bcast m43)) (wwl_add _Ph03 _bias),
    wwl_add (wwl_and _P25 (wwl m43 m43 m43 m43 m40 m40 m40 m40)) (wwl_add _Ph14 _bias)⟩

/-- `FD_R43X6_QUAD_1112d( Q )`: `(1, 1, 1, 2d)`. -/
def quad1112d : Quad :=
  ⟨wwl 1 1 1 3934839304537 0 0 0 521695520920, wwl 0 0 0 507525298899 0 0 0 6596238350568,
    wwl 0 0 0 15037786634 0 0 0 309467527341⟩

/-- `FD_R43X6_QUAD_MUL_FAST( R, P, Q )`. -/
def quadMul (P Q : Quad) : Quad :=
  let r := fd_r43x6_quad_mul_fast.spec P.P03 P.P14 P.P25 Q.P03 Q.P14 Q.P25
  ⟨r.1, r.2.1, r.2.2⟩

/-- `FD_R43X6_QUAD_SQR_FAST( R, P )`. -/
def quadSqr (P : Quad) : Quad :=
  let r := fd_r43x6_quad_sqr_fast.spec P.P03 P.P14 P.P25
  ⟨r.1, r.2.1, r.2.2⟩

/-- `FD_R43X6_GE_ADD( P3, P1, P2 )`, with `mul` for `FD_R43X6_QUAD_MUL_FAST`. -/
def geAdd (mul : Quad → Quad → Quad) (P1 P2 : Quad) : Quad :=
  let _ta := P1.permute 1 0 2 3
  let _tb := P2.permute 1 0 2 3
  let _ta := _ta.laneSubFast 1 0 0 0 _ta P1
  let _tb := _tb.laneSubFast 1 0 0 0 _tb P2
  let _ta := _ta.laneAddFast 0 1 1 0 _ta P1
  let _tb := _tb.laneAddFast 0 1 0 0 _tb P2
  let _ta := _ta.foldSigned
  let _tb := _tb.foldSigned
  let _ta := mul _ta quad1112d
  let _ta := _ta.foldUnsigned
  let _ta := mul _ta _tb
  let _tb := _ta.permute 1 0 3 2
  let _tb := _tb.laneSubFast 1 0 0 1 _tb _ta
  let _tb := _tb.laneAddFast 0 1 1 0 _tb _ta
  let _tb := _tb.foldSigned
  let _ta := _tb.permute 0 2 2 0
  let _tb := _tb.permute 3 1 3 1
  let _ta := mul _ta _tb
  _ta.foldUnsigned

/-- `FD_R43X6_GE_ADD_TABLE_ALT( P3, P1, T2, _ta, _tb )`: `P1 + T2` for a precomputed
`T2 = (Y-X, Y+X, 2Z, 2dT)`. -/
def geAddTable (mul : Quad → Quad → Quad) (P1 T2 : Quad) : Quad :=
  let _ta := T2
  let _tb := P1.permute 1 0 2 3
  let _tb := _tb.laneSubFast 1 0 0 0 _tb P1
  let _tb := _tb.laneAddFast 0 1 1 0 _tb P1
  let _tb := _tb.foldSigned
  let _ta := mul _ta _tb
  let _ta := _ta.foldUnsigned
  let _tb := _ta.permute 1 0 3 2
  let _tb := _tb.laneSubFast 1 0 0 1 _tb _ta
  let _tb := _tb.laneAddFast 0 1 1 0 _tb _ta
  let _tb := _tb.foldSigned
  let _ta := _tb.permute 0 2 2 0
  let _tb := _tb.permute 3 1 3 1
  let _ta := mul _ta _tb
  _ta.foldUnsigned

/-- `FD_R43X6_GE_DBL( P3, P1 )`, with `mul` and `sqr` for `FD_R43X6_QUAD_MUL_FAST` and
`FD_R43X6_QUAD_SQR_FAST`. -/
def geDbl (mul : Quad → Quad → Quad) (sqr : Quad → Quad) (P1 : Quad) : Quad :=
  let _ta := P1.permute 1 1 2 0
  let _ta := _ta.laneAddFast 1 0 0 0 _ta P1
  let _ta := sqr _ta
  let _ta := _ta.laneAddFast 0 0 1 0 _ta _ta
  let _tb := _ta.permute 3 3 3 3
  let _BB := _ta.permute 1 1 1 1
  let _tb := _tb.laneAddFast 1 0 0 1 _tb _BB
  let _tb := _tb.laneSubFast 0 1 1 0 _tb _BB
  let _tb := _tb.laneAddFast 0 0 1 0 _tb _ta
  let _tb := _tb.laneSubFast 1 0 0 0 _tb _ta
  let _tb := _tb.foldSigned
  let _ta := _tb.permute 0 1 1 0
  let _tb := _tb.permute 2 3 2 3
  let _ta := mul _ta _tb
  _ta.foldUnsigned

/-- The fold's shift amounts: 43, and 40 for limb 5. -/
abbrev s4340 : Wwl :=
  #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64]

/-- The fold's masks for limbs `2, 5`: 43 bits, and 40 for limb 5. -/
abbrev m4340 : Wwl :=
  #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64, 1099511627775#64,
    1099511627775#64, 1099511627775#64, 1099511627775#64]

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED` as compiled: `19 Ph25` as a product, the sums in the code's
operand order. -/
def Quad.foldUnsignedC (P : Quad) : Quad :=
  ⟨wwl_add
      (wwl_pack_halves (wwl_mul (wwl_shru_vector P.P25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shru_vector P.P25 s4340) 0)
      (wwl_and P.P03 (Vector.replicate 8 8796093022207#64)),
    wwl_add (wwl_and P.P14 (Vector.replicate 8 8796093022207#64))
      (wwl_shru_vector P.P03 (Vector.replicate 8 43#64)),
    wwl_add (wwl_and P.P25 m4340) (wwl_shru_vector P.P14 (Vector.replicate 8 43#64))⟩

/-- `-_bias03` of `FD_R43X6_QUAD_FOLD_SIGNED`, as the code adds it. -/
abbrev negBias03 : Wwl :=
  #v[18446744073550168064#64, 18446744073550168064#64, 18446744073550168064#64,
    18446744073550168064#64, 18446744073708503040#64, 18446744073708503040#64,
    18446744073708503040#64, 18446744073708503040#64]

/-- `_bias03` of `FD_R43X6_QUAD_FOLD_SIGNED`. -/
abbrev bias03 : Wwl :=
  #v[159383552#64, 159383552#64, 159383552#64, 159383552#64, 1048576#64, 1048576#64, 1048576#64,
    1048576#64]

/-- `FD_R43X6_QUAD_FOLD_SIGNED` as compiled: the biases added negated, `19 Ph25` as a product, the
sums in the code's operand order. -/
def Quad.foldSignedC (P : Quad) : Quad :=
  let d03 := wwl_add P.P03 negBias03
  let d14 := wwl_add P.P14 (Vector.replicate 8 18446744073708503040#64)
  let d25 := wwl_add P.P25 (Vector.replicate 8 18446744073708503040#64)
  let h03 := wwl_shr_vector d03 (Vector.replicate 8 43#64)
  let h14 := wwl_shr_vector d14 (Vector.replicate 8 43#64)
  let h25 := wwl_shr_vector d25 s4340
  ⟨wwl_add (wwl_add (wwl_and d03 (Vector.replicate 8 8796093022207#64)) bias03)
      (wwl_pack_halves (wwl_mul h25 (wwl_bcast 19#64)) 1 h25 0),
    wwl_add (wwl_add h03 (Vector.replicate 8 1048576#64))
      (wwl_and d14 (Vector.replicate 8 8796093022207#64)),
    wwl_add (wwl_add h14 (Vector.replicate 8 1048576#64)) (wwl_and d25 m4340)⟩

/-- `Quad.foldSignedC` with the sums in the other order: `(19 Ph25 + bias) + low bits` and
`(low bits + bias) + Ph03`. -/
def Quad.foldSignedC' (P : Quad) : Quad :=
  let d03 := wwl_add P.P03 negBias03
  let d14 := wwl_add P.P14 (Vector.replicate 8 18446744073708503040#64)
  let d25 := wwl_add P.P25 (Vector.replicate 8 18446744073708503040#64)
  let h03 := wwl_shr_vector d03 (Vector.replicate 8 43#64)
  let h14 := wwl_shr_vector d14 (Vector.replicate 8 43#64)
  let h25 := wwl_shr_vector d25 s4340
  ⟨wwl_add (wwl_add (wwl_pack_halves (wwl_mul h25 (wwl_bcast 19#64)) 1 h25 0) bias03)
      (wwl_and d03 (Vector.replicate 8 8796093022207#64)),
    wwl_add
      (wwl_add (wwl_and d14 (Vector.replicate 8 8796093022207#64)) (Vector.replicate 8 1048576#64))
      h03,
    wwl_add (wwl_add h14 (Vector.replicate 8 1048576#64)) (wwl_and d25 m4340)⟩

/-- `X` as `FD_R43X6_QUAD_UNPACK` gives it: six limbs, then two zero lanes. -/
def Quad.X (Q : Quad) : Wwl :=
  #v[Q.P03[0], Q.P14[0], Q.P25[0], Q.P03[4], Q.P14[4], Q.P25[4], 0, 0]

/-- `Y` as `FD_R43X6_QUAD_UNPACK` gives it. -/
def Quad.Y (Q : Quad) : Wwl :=
  #v[Q.P03[1], Q.P14[1], Q.P25[1], Q.P03[5], Q.P14[5], Q.P25[5], 0, 0]

/-- `Z` as `FD_R43X6_QUAD_UNPACK` gives it. -/
def Quad.Z (Q : Quad) : Wwl :=
  #v[Q.P03[2], Q.P14[2], Q.P25[2], Q.P03[6], Q.P14[6], Q.P25[6], 0, 0]

/-- `T` as `FD_R43X6_QUAD_UNPACK` gives it. -/
def Quad.T (Q : Quad) : Wwl :=
  #v[Q.P03[3], Q.P14[3], Q.P25[3], Q.P03[7], Q.P14[7], Q.P25[7], 0, 0]

end Firedancer.Avx512

open Firedancer.Avx512 Memory

/-- The point at `p`. -/
def MemoryState.readQuad (m : MemoryState) (p : Pointer) : Quad :=
  ⟨m.readVec p, m.readVec (p.add 64#64), m.readVec (p.add 128#64)⟩

/-- Store a point at `p`, `P03` first, as the code does. -/
def MemoryState.storeQuad (m : MemoryState) (p : Pointer) (P : Quad) : MemoryState :=
  ((m.storeVec p P.P03).storeVec (p.add 64#64) P.P14).storeVec (p.add 128#64) P.P25

/-- The point at `p` fits: its offsets do not wrap, and each vector fits. Spelled out at the offsets
`getelementptr` produces, so the steps find each conjunct. -/
abbrev MemoryState.QuadFit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 192 ≤ 2 ^ 64 ∧
    Fits m p 512 ∧ Fits m (p.add 64#64) 512 ∧ Fits m (p.add 128#64) 512

/-- Room for a point at `p` (an output), and its offsets do not wrap. -/
abbrev MemoryState.QuadRoom (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 192 ≤ 2 ^ 64 ∧
    Room m p 512 ∧ Room m (p.add 64#64) 512 ∧ Room m (p.add 128#64) 512

attribute [mlir_mem] MemoryState.QuadFit MemoryState.QuadRoom

theorem MemoryState.QuadFit.room {m : MemoryState} (h : m.QuadFit p) : m.QuadRoom p :=
  ⟨h.1, h.2.1.room, h.2.2.1.room, h.2.2.2.room⟩

/-! ### Lanes -/

set_option hygiene false in
/-- `wwl_lanes`: the lanes of `wwl` operations at literal indices, by `simp only`; a full `simp`,
`rw` or `rfl` on such lanes can unfold the `BitVec` literals for minutes. -/
macro "wwl_lanes" : tactic =>
  `(tactic|
    simp only [wwl_add, wwl_sub, wwl_and, wwv_add_if, wwl_shru, wwl_shru_vector, wwl_pack_halves,
      wwl_mul, wwl_shl, wwl_shr, wwl_shr_vector, wwl_shl_vector, wwl_permute, wwl_bcast, wwl,
      quadMask, Vector.getElem_ofFn, Fin.getElem_fin, Vector.getElem_replicate, Vector.getElem_mk,
      List.getElem_toArray, List.getElem_cons_succ, List.getElem_cons_zero, BitVec.toNat_ofNat,
      Nat.reduceMod, Nat.reducePow, m43, m40, BitVec.reduceToNat, BitVec.reduceGetLsb,
      Nat.reduceAdd, Nat.reduceMul, Nat.reduceSub, Nat.reduceLT, Bool.false_eq_true, ↓reduceIte,
      ↓reduceDIte, decide_true, decide_false])

set_option hygiene false in
/-- `quad_lanes`: a `Quad` equation of lane operations, lane by lane. -/
macro "quad_lanes" : tactic =>
  `(tactic|
    ( simp only [Quad.permute, Quad.laneAddFast, Quad.laneSubFast, Quad.addSel, Quad.subSel,
        Quad.perm4, quadP, Quad.mk.injEq, Nat.reduceAdd]
      refine ⟨?_, ?_, ?_⟩ <;> ext i hi : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
      all_goals
        first
        | omega
        | try simp only [wwl_add_sel, wwl_sub_sel, wwl_perm4, Bool.cond_true, Bool.cond_false]
          wwl_lanes
          first
          | done
          |
            simp only [add_sub_comm', add_self_eq_shl, BitVec.shiftLeft_zero,
              BitVec.ofNat_eq_ofNat]))

/-- Bit `i` of packed lanes: bit `i % 64` of lane `i / 64`. -/
theorem BitVec.getLsbD_packLanes (v : Vector (BitVec 64) 8) (hi : i < 512) :
    (BitVec.packLanes v).getLsbD i = (v[i / 64]'(by omega)).getLsbD (i % 64) := by
  have h := BitVec.extractLsb'_packLanes v (i / 64) (by omega)
  have hb := congrArg (fun y => y.getLsbD (i % 64)) h
  simp only [BitVec.getLsbD_extractLsb', show i % 64 < 64 by omega, decide_true, Bool.true_and,
    show i / 64 * 64 + i % 64 = i by omega] at hb
  exact hb

theorem BitVec.packLanes_zero : BitVec.packLanes (Vector.replicate 8 0#64) = 0#512 := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [BitVec.getLsbD_packLanes _ hi]

/-! ### Vector operations on defined lanes

A vector instruction on defined lanes as the `wwl` operation the C code names, unexpanded: proofs
erase `zipWith_eq_ofFn` and take these as `mlir_operation` lemmas, so values stay folded. The lanes
are typed `⟦.vec 8 64⟧ᵣ`, as the steps' values are: `simp` does not unify that with `Wwl`. -/

theorem zipWith_and_wrap (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.and (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_and x y) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_and, Operation.and]

theorem zipWith_add_wrap (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.add {} (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_add x y) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_add, Operation.add]

theorem zipWith_sub_wrap (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.sub {} (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_sub x y) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_sub, Operation.sub]

theorem zipWith_lshr_wrap (x y : ⟦.vec 8 64⟧ᵣ) (h : ∀ i : Fin 8, y[i].toNat < 64) :
    Vector.zipWith (Operation.lshr false (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_shru_vector x y) := by
  ext i hi
  have : y[i].toNat < 64 := h ⟨i, hi⟩
  simp [Ty.wrap_vec, wwl_shru_vector, Operation.lshr]
  omega

/-- `add nsw nuw` on lanes that overflow neither way. -/
theorem zipWith_add_nsw_nuw_wrap (x y : ⟦.vec 8 64⟧ᵣ)
    (h : ∀ i : Fin 8, x[i].saddOverflow y[i] = false ∧ x[i].uaddOverflow y[i] = false) :
    Vector.zipWith (Operation.add { nsw := true, nuw := true } (w := 64))
        (Ty.wrap (t := .vec 8 64) x) (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_add x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, wwl_add, Operation.add]

theorem zipWith_ashr_wrap (x y : ⟦.vec 8 64⟧ᵣ) (h : ∀ i : Fin 8, y[i].toNat < 64) :
    Vector.zipWith (Operation.ashr false (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_shr_vector x y) := by
  ext i hi
  have : y[i].toNat < 64 := h ⟨i, hi⟩
  simp [Ty.wrap_vec, wwl_shr_vector, Operation.ashr]
  omega

theorem zipWith_shl_wrap (x y : ⟦.vec 8 64⟧ᵣ) (h : ∀ i : Fin 8, y[i].toNat < 64) :
    Vector.zipWith (Operation.shl {} (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_shl_vector x y) := by
  ext i hi
  have : y[i].toNat < 64 := h ⟨i, hi⟩
  simp [Ty.wrap_vec, wwl_shl_vector, Operation.shl]
  omega

theorem zipWith_mul_wrap (x y : ⟦.vec 8 64⟧ᵣ) :
    Vector.zipWith (Operation.mul {} (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_mul x y) := by
  ext i hi
  simp [Ty.wrap_vec, wwl_mul, Operation.mul]

/-- `add nsw` on lanes that do not overflow signed. -/
theorem zipWith_add_nsw_wrap (x y : ⟦.vec 8 64⟧ᵣ)
    (h : ∀ i : Fin 8, x[i].saddOverflow y[i] = false) :
    Vector.zipWith (Operation.add { nsw := true } (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_add x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, wwl_add, Operation.add]

theorem zipWith_sub_nsw_wrap (x y : ⟦.vec 8 64⟧ᵣ)
    (h : ∀ i : Fin 8, x[i].ssubOverflow y[i] = false) :
    Vector.zipWith (Operation.sub { nsw := true } (w := 64)) (Ty.wrap (t := .vec 8 64) x)
        (Ty.wrap (t := .vec 8 64) y) =
      Ty.wrap (t := .vec 8 64) (wwl_sub x y) := by
  ext i hi
  have := h ⟨i, hi⟩
  simp_all [Ty.wrap_vec, wwl_sub, Operation.sub]

/-! ### The fold as compiled -/

theorem foldUnsigned_lane (x : BitVec 64) : x + ((x <<< 1) + (x <<< 4)) = x * 19#64 := by bv_decide

theorem mul19_add_mask_no_overflow (x y : BitVec 64) :
    (x >>> 40 * 19#64).saddOverflow (y &&& 8796093022207#64) = false ∧
      (x >>> 40 * 19#64).uaddOverflow (y &&& 8796093022207#64) = false := by
  bv_decide

theorem shr43_add_mask_no_overflow (x y : BitVec 64) :
    (x >>> 43).saddOverflow (y &&& 8796093022207#64) = false ∧
      (x >>> 43).uaddOverflow (y &&& 8796093022207#64) = false := by
  bv_decide

theorem mask_add_shr43_no_overflow (x y : BitVec 64) :
    (y &&& 8796093022207#64).saddOverflow (x >>> 43) = false ∧
      (y &&& 8796093022207#64).uaddOverflow (x >>> 43) = false := by
  bv_decide

theorem mask40_add_shr43_no_overflow (x y : BitVec 64) :
    (y &&& 1099511627775#64).saddOverflow (x >>> 43) = false ∧
      (y &&& 1099511627775#64).uaddOverflow (x >>> 43) = false := by
  bv_decide

theorem Quad.foldUnsigned_eq (P : Quad) : P.foldUnsigned = P.foldUnsignedC := by
  rcases P with ⟨a, b, c⟩
  simp only [Quad.foldUnsigned, Quad.foldUnsignedC, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext i hi : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      first
      | done
      | simp only [foldUnsigned_lane]; exact BitVec.add_comm _ _
      | exact BitVec.add_comm _ _

theorem fold_ok03 (c a : Wwl) :
    ∀ i : Fin 8,
      (wwl_pack_halves (wwl_mul (wwl_shru_vector c s4340) (wwl_bcast 19#64)) 1
                  (wwl_shru_vector c s4340) 0)[i].saddOverflow
            (wwl_and a (Vector.replicate 8 8796093022207#64))[i] =
          false ∧
        (wwl_pack_halves (wwl_mul (wwl_shru_vector c s4340) (wwl_bcast 19#64)) 1
                  (wwl_shru_vector c s4340) 0)[i].uaddOverflow
            (wwl_and a (Vector.replicate 8 8796093022207#64))[i] =
          false := by
  intro ⟨i, hi⟩
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      simp only [mul19_add_mask_no_overflow, shr43_add_mask_no_overflow, and_self]

theorem fold_ok (m a b : Wwl) (hm : m = Vector.replicate 8 8796093022207#64 ∨ m = m4340) :
    ∀ i : Fin 8,
      (wwl_and a m)[i].saddOverflow (wwl_shru_vector b (Vector.replicate 8 43#64))[i] = false ∧
        (wwl_and a m)[i].uaddOverflow (wwl_shru_vector b (Vector.replicate 8 43#64))[i] =
          false := by
  intro ⟨i, hi⟩
  rcases hm with rfl | rfl <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      simp only [mask_add_shr43_no_overflow, mask40_add_shr43_no_overflow, and_self]

/-! ### The signed fold as compiled -/

theorem sub_bias (x : BitVec 64) : x - 1048576#64 = x + 18446744073708503040#64 := by bv_decide

/-! The signed fold's lanes, C's against the compiled. -/

theorem foldSigned_lane03 (a c : BitVec 64) :
    (a - 159383552 &&& 8796093022207#64) +
        ((c - 1048576).sshiftRight 40 +
          ((c - 1048576).sshiftRight 40 <<< 1 + (c - 1048576).sshiftRight 40 <<< 4) +
          159383552) =
      (a + 18446744073550168064#64 &&& 8796093022207#64) + 159383552#64 +
        (c + 18446744073708503040#64).sshiftRight 40 * 19#64 := by
  bv_decide

theorem foldSigned_lane47 (a c : BitVec 64) :
    (a - 1048576 &&& 8796093022207#64) + ((c - 1048576).sshiftRight 43 + 1048576) =
      (a + 18446744073708503040#64 &&& 8796093022207#64) + 1048576#64 +
        (c + 18446744073708503040#64).sshiftRight 43 := by
  bv_decide

theorem foldSigned_lane14 (a b : BitVec 64) :
    (b - 1048576 &&& 8796093022207#64) + ((a - 159383552).sshiftRight 43 + 1048576) =
      (a + 18446744073550168064#64).sshiftRight 43 + 1048576#64 +
        (b + 18446744073708503040#64 &&& 8796093022207#64) := by
  bv_decide

theorem foldSigned_lane14' (a b : BitVec 64) :
    (b - 1048576 &&& 8796093022207#64) + ((a - 1048576).sshiftRight 43 + 1048576) =
      (a + 18446744073708503040#64).sshiftRight 43 + 1048576#64 +
        (b + 18446744073708503040#64 &&& 8796093022207#64) := by
  bv_decide

theorem foldSigned_lane25' (b c : BitVec 64) :
    (c - 1048576 &&& 8796093022207#64) + ((b - 1048576).sshiftRight 43 + 1048576) =
      (b + 18446744073708503040#64).sshiftRight 43 + 1048576#64 +
        (c + 18446744073708503040#64 &&& 8796093022207#64) := by
  bv_decide

theorem foldSigned_lane25 (b c : BitVec 64) :
    (c - 1048576 &&& 1099511627775#64) + ((b - 1048576).sshiftRight 43 + 1048576) =
      (b + 18446744073708503040#64).sshiftRight 43 + 1048576#64 +
        (c + 18446744073708503040#64 &&& 1099511627775#64) := by
  bv_decide

theorem Quad.foldSigned_eq (P : Quad) : P.foldSigned = P.foldSignedC := by
  rcases P with ⟨a, b, c⟩
  simp only [Quad.foldSigned, Quad.foldSignedC, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext i hi : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  -- `P03`
  iterate 4
    · wwl_lanes
      exact foldSigned_lane03 _ _
  iterate 4
    · wwl_lanes
      exact foldSigned_lane47 _ _
  · omega
  -- `P14`
  iterate 4
    · wwl_lanes
      exact foldSigned_lane14 _ _
  iterate 4
    · wwl_lanes
      exact foldSigned_lane14' _ _
  · omega
  -- `P25`
  iterate 4
    · wwl_lanes
      exact foldSigned_lane25' _ _
  iterate 4
    · wwl_lanes
      exact foldSigned_lane25 _ _
  · omega

/-- The low bits plus `_bias03`: no overflow either way. -/
theorem mask_add_bias03_ok (d : Wwl) :
    ∀ i : Fin 8,
      (wwl_and d (Vector.replicate 8 8796093022207#64))[i].saddOverflow bias03[i] = false ∧
        (wwl_and d (Vector.replicate 8 8796093022207#64))[i].uaddOverflow bias03[i] = false := by
  intro ⟨i, hi⟩
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      constructor <;> bv_decide

/-- A signed carry plus `_bias`: no signed overflow. -/
theorem shr_add_bias_ok (d s : Wwl) (hs : s = Vector.replicate 8 43#64 ∨ s = s4340) :
    ∀ i : Fin 8,
      (wwl_shr_vector d s)[i].saddOverflow (Vector.replicate 8 1048576#64)[i] = false := by
  intro ⟨i, hi⟩
  rcases hs with rfl | rfl <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      bv_decide

/-- A signed carry by 43 plus `_bias`, plus the next limb's low bits: no overflow either way. -/
theorem shr43_add_bias_add_mask_ok (d e m : Wwl)
    (hm : m = Vector.replicate 8 8796093022207#64 ∨ m = m4340) :
    ∀ i : Fin 8,
      (wwl_add (wwl_shr_vector d (Vector.replicate 8 43#64))
                  (Vector.replicate 8 1048576#64))[i].saddOverflow
            (wwl_and e m)[i] =
          false ∧
        (wwl_add (wwl_shr_vector d (Vector.replicate 8 43#64))
                  (Vector.replicate 8 1048576#64))[i].uaddOverflow
            (wwl_and e m)[i] =
          false := by
  intro ⟨i, hi⟩
  rcases hm with rfl | rfl <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      constructor <;> bv_decide

theorem wwl_add_add_swap (x b y : Wwl) : wwl_add (wwl_add x b) y = wwl_add (wwl_add y b) x := by
  ext i hi : 1
  simp only [wwl_add, Vector.getElem_ofFn, Fin.getElem_fin]
  rw [BitVec.add_comm x[i], BitVec.add_comm y[i], BitVec.add_assoc, BitVec.add_assoc,
    BitVec.add_comm x[i]]

theorem Quad.foldSignedC_eq' (P : Quad) : P.foldSignedC = P.foldSignedC' := by
  simp only [Quad.foldSignedC, Quad.foldSignedC', Quad.mk.injEq]
  exact ⟨wwl_add_add_swap _ _ _, wwl_add_add_swap _ _ _, trivial⟩

/-- The low bits plus `_bias`: no overflow either way. -/
theorem mask_add_bias_ok (d : Wwl) :
    ∀ i : Fin 8,
      (wwl_and d (Vector.replicate 8 8796093022207#64))[i].saddOverflow
            (Vector.replicate 8 1048576#64)[i] =
          false ∧
        (wwl_and d (Vector.replicate 8 8796093022207#64))[i].uaddOverflow
            (Vector.replicate 8 1048576#64)[i] =
          false := by
  intro ⟨i, hi⟩
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      constructor <;> bv_decide

/-- The low bits plus `_bias`, plus a signed carry: no signed overflow. -/
theorem mask_add_bias_add_shr_ok (d e : Wwl) :
    ∀ i : Fin 8,
      (wwl_add (wwl_and e (Vector.replicate 8 8796093022207#64))
                (Vector.replicate 8 1048576#64))[i].saddOverflow
          (wwl_shr_vector d (Vector.replicate 8 43#64))[i] =
        false := by
  intro ⟨i, hi⟩
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      bv_decide

/-! ### Lane operations as compiled

The code computes `LANE_ADD_FAST( D, P, .., P, Q )` lane by lane, `LANE_SUB_FAST` as `P - Q + p`,
and `PERMUTE` as a shuffle. -/

namespace Firedancer.Avx512

/-- `x + y` in lanes `j`, `j + 4` where `bj`, `x` in the others. -/
def wwl_add_sel (b0 b1 b2 b3 : Bool) (x y : Wwl) : Wwl :=
  #v[cond b0 (wwl_add x y)[0] x[0], cond b1 (wwl_add x y)[1] x[1], cond b2 (wwl_add x y)[2] x[2],
    cond b3 (wwl_add x y)[3] x[3], cond b0 (wwl_add x y)[4] x[4], cond b1 (wwl_add x y)[5] x[5],
    cond b2 (wwl_add x y)[6] x[6], cond b3 (wwl_add x y)[7] x[7]]

/-- `x - y + p` in lanes `j < 4` and `x - y + q` in lanes `j + 4` where `bj`, `x` in the
others. -/
def wwl_sub_sel (b0 b1 b2 b3 : Bool) (x y : Wwl) (p q : BitVec 64) : Wwl :=
  #v[cond b0 ((wwl_sub x y)[0] + p) x[0], cond b1 ((wwl_sub x y)[1] + p) x[1],
    cond b2 ((wwl_sub x y)[2] + p) x[2], cond b3 ((wwl_sub x y)[3] + p) x[3],
    cond b0 ((wwl_sub x y)[4] + q) x[4], cond b1 ((wwl_sub x y)[5] + q) x[5],
    cond b2 ((wwl_sub x y)[6] + q) x[6], cond b3 ((wwl_sub x y)[7] + q) x[7]]

/-- Lanes `i0 i1 i2 i3` of `x`, then the same lanes plus 4, all mod 8. -/
def wwl_perm4 (i0 i1 i2 i3 : Nat) (x : Wwl) : Wwl :=
  #v[x[i0 % 8]'(Nat.mod_lt _ (by decide)), x[i1 % 8]'(Nat.mod_lt _ (by decide)),
    x[i2 % 8]'(Nat.mod_lt _ (by decide)), x[i3 % 8]'(Nat.mod_lt _ (by decide)),
    x[(i0 + 4) % 8]'(Nat.mod_lt _ (by decide)), x[(i1 + 4) % 8]'(Nat.mod_lt _ (by decide)),
    x[(i2 + 4) % 8]'(Nat.mod_lt _ (by decide)), x[(i3 + 4) % 8]'(Nat.mod_lt _ (by decide))]

/-- `wwl_add_sel` on each vector. -/
def Quad.addSel (b0 b1 b2 b3 : Bool) (P Q : Quad) : Quad :=
  ⟨wwl_add_sel b0 b1 b2 b3 P.P03 Q.P03, wwl_add_sel b0 b1 b2 b3 P.P14 Q.P14,
    wwl_add_sel b0 b1 b2 b3 P.P25 Q.P25⟩

/-- `wwl_sub_sel` on each vector, with `p`'s limbs. -/
def Quad.subSel (b0 b1 b2 b3 : Bool) (P Q : Quad) : Quad :=
  ⟨wwl_sub_sel b0 b1 b2 b3 P.P03 Q.P03 8796093022189#64 8796093022207#64,
    wwl_sub_sel b0 b1 b2 b3 P.P14 Q.P14 8796093022207#64 8796093022207#64,
    wwl_sub_sel b0 b1 b2 b3 P.P25 Q.P25 8796093022207#64 1099511627775#64⟩

/-- `wwl_perm4` on each vector. -/
def Quad.perm4 (i0 i1 i2 i3 : Nat) (P : Quad) : Quad :=
  ⟨wwl_perm4 i0 i1 i2 i3 P.P03, wwl_perm4 i0 i1 i2 i3 P.P14, wwl_perm4 i0 i1 i2 i3 P.P25⟩

end Firedancer.Avx512

theorem add_sub_comm' (a b c : BitVec 64) : a + (b - c) = a - c + b := by bv_decide

theorem add_self_eq_shl (x : BitVec 64) : x + x = x <<< 1 := by bv_decide

theorem Quad.permute_1120 (P : Quad) : P.permute 1 1 2 0 = P.perm4 1 1 2 0 := by quad_lanes

/-- `Z` doubled, as the code does it: shifted left by one. -/
theorem Quad.laneAddFast_0010_self (P : Quad) :
    P.laneAddFast 0 0 1 0 P P =
      ⟨wwl_shl_vector P.P03 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64],
        wwl_shl_vector P.P14 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64],
        wwl_shl_vector P.P25 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64]⟩ := by
  quad_lanes

theorem Quad.permute_1032 (P : Quad) : P.permute 1 0 3 2 = P.perm4 1 0 3 2 := by quad_lanes

/-! ### Bounds on folded lanes -/

theorem fold_lane_lt (x y : BitVec 64) :
    x >>> 40 * 19#64 + (y &&& 8796093022207#64) < 17592186044416#64 := by bv_decide

theorem fold_lane_lt' (x y : BitVec 64) :
    x >>> 43 + (y &&& 8796093022207#64) < 17592186044416#64 := by bv_decide

theorem fold_lane_lt14 (x y : BitVec 64) :
    (y &&& 8796093022207#64) + x >>> 43 < 17592186044416#64 := by bv_decide

theorem fold_lane_lt25 (x y : BitVec 64) :
    (y &&& 1099511627775#64) + x >>> 43 < 17592186044416#64 := by bv_decide

/-- The unsigned fold's lanes are below `2^44`. -/
theorem Quad.foldUnsignedC_lt {P : Quad} {a b c : Wwl} (h : P.foldUnsignedC = ⟨a, b, c⟩) :
    (∀ i : Fin 8, a[i] < 17592186044416#64) ∧
      (∀ i : Fin 8, b[i] < 17592186044416#64) ∧ ∀ i : Fin 8, c[i] < 17592186044416#64 := by
  rcases P with ⟨p, q, r⟩
  simp only [Quad.foldUnsignedC, Quad.mk.injEq] at h
  obtain ⟨rfl, rfl, rfl⟩ := h
  refine ⟨?_, ?_, ?_⟩ <;> intro ⟨i, hi⟩ <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      simp only [fold_lane_lt, fold_lane_lt', fold_lane_lt14, fold_lane_lt25]

theorem wwl_perm4_lt {x : Wwl} {B : BitVec 64} (h : ∀ i : Fin 8, x[i] < B) (i0 i1 i2 i3 : Nat) :
    ∀ i : Fin 8, (wwl_perm4 i0 i1 i2 i3 x)[i] < B := by
  intro ⟨i, hi⟩
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | simp only [wwl_perm4, Fin.getElem_fin, Vector.getElem_mk, List.getElem_toArray,
        List.getElem_cons_succ, List.getElem_cons_zero]
      exact h ⟨_, Nat.mod_lt _ (by decide)⟩

theorem sub_lane_ok {a b : BitVec 64} (ha : a < 17592186044416#64) (hb : b < 17592186044416#64) :
    a.ssubOverflow b = false := by bv_decide

theorem sub_add_lane_ok {a b c : BitVec 64} (ha : a < 17592186044416#64)
    (hb : b < 17592186044416#64) (hc : c < 17592186044416#64) : (a - b).saddOverflow c = false := by
  bv_decide

theorem wwl_perm4_lt_of_eq {x v : Wwl} {B : BitVec 64} {i0 i1 i2 i3 : Nat}
    (h : ∀ i : Fin 8, x[i] < B) (hv : wwl_perm4 i0 i1 i2 i3 x = v) : ∀ i : Fin 8, v[i] < B :=
  hv ▸ wwl_perm4_lt h i0 i1 i2 i3

/-- Folded lanes less folded lanes: no signed overflow. -/
theorem sub_lt_ok {x y : Wwl} (hx : ∀ i : Fin 8, x[i] < 17592186044416#64)
    (hy : ∀ i : Fin 8, y[i] < 17592186044416#64) : ∀ i : Fin 8, x[i].ssubOverflow y[i] = false :=
  fun i => sub_lane_ok (hx i) (hy i)

theorem add_lane_ok {a c : BitVec 64} (ha : a < 17592186044416#64) (hc : c < 17592186044416#64) :
    a.saddOverflow c = false := by bv_decide

theorem shr40_mul19_no_overflow (x : BitVec 64) :
    (x >>> 40).smulOverflow 19#64 = false ∧ (x >>> 40).umulOverflow 19#64 = false := by bv_decide

/-- A signed carry by 40 times `19`: no signed overflow. -/
theorem sshr40_mul19_no_overflow (x : BitVec 64) :
    (x.sshiftRight 40).smulOverflow 19#64 = false := by bv_decide

/-! ### Fit -/

theorem MemoryState.QuadFit.no_wrap {m : MemoryState} (h : m.QuadFit p) {off : BitVec 64}
    (hoff : off.toNat ≤ 128) : ¬p.offset.uaddOverflow off := by
  have := h.1
  simp only [BitVec.uaddOverflow, decide_eq_true_eq]
  omega

theorem MemoryState.QuadRoom.no_wrap {m : MemoryState} (h : m.QuadRoom p) {off : BitVec 64}
    (hoff : off.toNat ≤ 128) : ¬p.offset.uaddOverflow off := by
  have := h.1
  simp only [BitVec.uaddOverflow, decide_eq_true_eq]
  omega

theorem MemoryState.QuadFit.fits_03 {m : MemoryState} (h : m.QuadFit p) : Fits m p 512 :=
  h.2.1

theorem MemoryState.QuadFit.fits_14 {m : MemoryState} (h : m.QuadFit p) :
    Fits m (p.add 64#64) 512 :=
  h.2.2.1

theorem MemoryState.QuadFit.fits_25 {m : MemoryState} (h : m.QuadFit p) :
    Fits m (p.add 128#64) 512 :=
  h.2.2.2

/-- `P14` and `P25` together, as `memset` writes them. -/
theorem MemoryState.QuadRoom.room_14_25 {m : MemoryState} (h : m.QuadRoom p) :
    Room m (p.add 64#64) 1024 := by
  obtain ⟨blk, hblk, hl, hsz⟩ := h.2.2.2
  refine ⟨blk, hblk, hl, ?_⟩
  have h1 := Pointer.offsetInBits_add (p := p) (h.no_wrap (off := 64#64) (by decide))
  have h2 := Pointer.offsetInBits_add (p := p) (h.no_wrap (off := 128#64) (by decide))
  simp only [BitVec.toNat_ofNat] at h1 h2
  omega

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadFit.storeAt {m : MemoryState} {x : BitVec w} (h : m.QuadFit q) :
    (m.storeAt p x).QuadFit q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadRoom.storeAt {m : MemoryState} {x : BitVec w} (h : m.QuadRoom q) :
    (m.storeAt p x).QuadRoom q :=
  ⟨h.1, h.2.1.storeAt, h.2.2.1.storeAt, h.2.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadFit.storeVec {m : MemoryState} (h : m.QuadFit q) :
    (m.storeVec p v).QuadFit q :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadRoom.storeVec {m : MemoryState} (h : m.QuadRoom q) :
    (m.storeVec p v).QuadRoom q :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem Fits.storeQuad {m : MemoryState} (h : Fits m p w) : Fits (m.storeQuad q P) p w :=
  (h.storeAt.storeAt.storeAt : Fits (((m.storeAt _ _).storeAt _ _).storeAt _ _) p w)

@[mlir_mem, mlir_transport]
theorem Room.storeQuad {m : MemoryState} (h : Room m p w) : Room (m.storeQuad q P) p w :=
  (h.storeAt.storeAt.storeAt : Room (((m.storeAt _ _).storeAt _ _).storeAt _ _) p w)

@[mlir_mem, mlir_transport]
theorem InBounds.storeQuad {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.storeQuad q P) p w :=
  (h.storeAt.storeAt.storeAt : InBounds (((m.storeAt _ _).storeAt _ _).storeAt _ _) p w)

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadFit.storeQuad {m : MemoryState} (h : m.QuadFit q) :
    (m.storeQuad p P).QuadFit q :=
  (h.storeAt.storeAt.storeAt : (((m.storeAt _ _).storeAt _ _).storeAt _ _).QuadFit q)

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadRoom.storeQuad {m : MemoryState} (h : m.QuadRoom q) :
    (m.storeQuad p P).QuadRoom q :=
  (h.storeAt.storeAt.storeAt : (((m.storeAt _ _).storeAt _ _).storeAt _ _).QuadRoom q)

/-- A point stored where there is room is known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.QuadFit.storeQuad_self {m : MemoryState} (h : m.QuadRoom p) :
    (m.storeQuad p P).QuadFit p :=
  ⟨h.1, (Fits.storeAt_self h.2.1).storeAt.storeAt, (Fits.storeAt_self h.2.2.1.storeAt).storeAt,
    Fits.storeAt_self h.2.2.2.storeAt.storeAt⟩

/-- A point stored vector by vector where there is room is known, as a store pattern leaves it. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.QuadFit.storeAt_quad_self {m : MemoryState} {a b c : BitVec 512}
    (h : m.QuadRoom p) :
    (((m.storeAt p a).storeAt (p.add 64#64) b).storeAt (p.add 128#64) c).QuadFit p :=
  ⟨h.1, (Fits.storeAt_self h.2.1).storeAt.storeAt, (Fits.storeAt_self h.2.2.1.storeAt).storeAt,
    Fits.storeAt_self h.2.2.2.storeAt.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadFit.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.QuadFit q) :
    (s.alloca n d).mem.QuadFit q :=
  ⟨h.1, h.2.1.alloca hwf, h.2.2.1.alloca hwf, h.2.2.2.alloca hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadRoom.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.QuadRoom q) :
    (s.alloca n d).mem.QuadRoom q :=
  ⟨h.1, h.2.1.alloca hwf, h.2.2.1.alloca hwf, h.2.2.2.alloca hwf⟩

@[mlir_transport]
theorem MemoryState.QuadFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.QuadFit q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).QuadFit q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.addBlock hwf⟩

@[mlir_transport]
theorem MemoryState.QuadRoom.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.QuadRoom q) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).QuadRoom q :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.1.addBlock hwf, h.2.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadFit.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.QuadFit p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).QuadFit p :=
  ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart hne, h.2.2.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadFit.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.QuadFit p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).QuadFit p :=
  ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd hne, h.2.2.2.lifetimeEnd hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadRoom.lifetimeStart {m : MemoryState} {p q : Pointer} (h : m.QuadRoom p)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).QuadRoom p :=
  ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.1.lifetimeStart hne, h.2.2.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.QuadRoom.lifetimeEnd {m : MemoryState} {p q : Pointer} (h : m.QuadRoom p)
    (hne : p.id ≠ q.id) : (m.lifetimeEnd q).QuadRoom p :=
  ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.1.lifetimeEnd hne, h.2.2.2.lifetimeEnd hne⟩

/-- A 192-byte block from its start holds one point. -/
theorem MemoryState.QuadFit.of_fits {m : MemoryState} (h : Fits m p 1536) (ho : p.offset = 0) :
    m.QuadFit p := by
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 128) : ¬p.offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, ho, decide_eq_true_eq]
    simp
    omega
  exact
    ⟨by simp [ho], h.mono (by omega), Fits.add_of_le (hov _ (by decide)) (by decide) h,
      Fits.add_of_le (hov _ (by decide)) (by decide) h⟩

/-- A live 192-byte block from its start has room for one point. -/
theorem MemoryState.QuadRoom.of_room {m : MemoryState} (h : Room m p 1536) (ho : p.offset = 0) :
    m.QuadRoom p := by
  have hov (off : BitVec 64) (hoff : off.toNat ≤ 128) : ¬p.offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, ho, decide_eq_true_eq]
    simp
    omega
  exact
    ⟨by simp [ho], h.mono (by omega), Room.add_of_le (hov _ (by decide)) (by decide) h,
      Room.add_of_le (hov _ (by decide)) (by decide) h⟩

/-! ### State -/

@[simp, mlir_mem]
theorem GlobalState.WF_storeQuad {s : GlobalState} :
    ({ s with mem := m.storeQuad p P } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeQuad, MemoryState.storeVec]

@[mlir_transport]
theorem GlobalState.WF.storeQuad {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeQuad p P } : GlobalState).WF :=
  GlobalState.WF_storeQuad.mpr h

@[mlir_transport]
theorem GlobalState.WF.storeQuad_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeQuad p P⟩ : GlobalState).WF :=
  GlobalState.WF.storeQuad (s := ⟨a, m⟩) h

/-! ### Reads -/

@[mlir_read]
theorem MemoryState.readQuad_storeQuad_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : p.id ≠ q.id) : (m.storeQuad p P).readQuad q = m.readQuad q := by
  have h' (k k' : BitVec 64) : (Range.of (p.add k) 512).Disjoint (Range.of (q.add k') 512) :=
    Or.inl (by simpa [Range.of, Pointer.add] using h)
  have h0 (k : BitVec 64) : (Range.of (p.add k) 512).Disjoint (Range.of q 512) :=
    Or.inl (by simpa [Range.of, Pointer.add] using h)
  have h1 (k : BitVec 64) : (Range.of p 512).Disjoint (Range.of (q.add k) 512) :=
    Or.inl (by simpa [Range.of, Pointer.add] using h)
  have h2 : (Range.of p 512).Disjoint (Range.of q 512) := Or.inl (by simpa [Range.of] using h)
  simp only [MemoryState.readQuad, MemoryState.storeQuad, MemoryState.readVec, MemoryState.storeVec,
    MemoryState.readAt_storeAt_disjoint, h', h0, h1, h2]

@[mlir_read]
theorem MemoryState.readQuad_storeAt_of_id_ne {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).readQuad q = m.readQuad q := by
  have h' (k : BitVec 64) : (Range.of p w).Disjoint (Range.of (q.add k) 512) :=
    Or.inl (by simpa [Range.of, Pointer.add] using h)
  have h2 : (Range.of p w).Disjoint (Range.of q 512) := Or.inl (by simpa [Range.of] using h)
  simp only [MemoryState.readQuad, MemoryState.readVec, MemoryState.readAt_storeAt_disjoint, h', h2]

theorem Range.disjoint_quad {p : Pointer} {a b : Nat} (hp : p.offset.toNat + 192 ≤ 2 ^ 64)
    (ha : a ≤ 128) (hb : b ≤ 128) (hab : a + 64 ≤ b ∨ b + 64 ≤ a) :
    (Range.of (p.add (BitVec.ofNat 64 a)) 512).Disjoint
      (Range.of (p.add (BitVec.ofNat 64 b)) 512) := by
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega : a < 2 ^ 64), Nat.mod_eq_of_lt (by omega : b < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

theorem Pointer.add_zero_quad (p : Pointer) : p.add (BitVec.ofNat 64 0) = p := by simp [Pointer.add]

@[mlir_read]
theorem MemoryState.readQuad_storeQuad_self {m : MemoryState} {p : Pointer} (h : m.QuadRoom p) :
    (m.storeQuad p P).readQuad p = P := by
  have d01 := Range.disjoint_quad h.1 (a := 0) (b := 64) (by omega) (by omega) (by omega)
  have d02 := Range.disjoint_quad h.1 (a := 0) (b := 128) (by omega) (by omega) (by omega)
  have d12 := Range.disjoint_quad h.1 (a := 64) (b := 128) (by omega) (by omega) (by omega)
  rw [Pointer.add_zero_quad] at d01 d02
  simp only [MemoryState.readQuad, MemoryState.storeQuad, MemoryState.readVec, MemoryState.storeVec]
  rw [MemoryState.readAt_storeAt_disjoint d02.symm, MemoryState.readAt_storeAt_disjoint d01.symm,
    MemoryState.readAt_storeAt_self h.2.1.inBounds, MemoryState.readAt_storeAt_disjoint d12.symm,
    MemoryState.readAt_storeAt_self h.2.2.1.inBounds.storeAt,
    MemoryState.readAt_storeAt_self h.2.2.2.inBounds.storeAt.storeAt]
  simp only [Ty.extractVecElem_packLanes]
  rcases P with ⟨a, b, c⟩
  congr <;> ext i hi <;> simp

/-- A point elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readQuad_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readQuad p = s.mem.readQuad p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add] using hne
  simp only [MemoryState.readQuad, MemoryState.readVec, MemoryState.readAt,
    GlobalState.getElem?_alloca hne, GlobalState.getElem?_alloca (hne' _)]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readQuad_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readQuad p = m.readQuad p := by
  simp only [MemoryState.readQuad, MemoryState.readVec_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readQuad_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readQuad p = m.readQuad p := by
  simp only [MemoryState.readQuad, MemoryState.readVec_lifetimeEnd]

@[mlir_read]
theorem MemoryState.readQuad_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readQuad p = m.readQuad p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add] using h
  simp only [MemoryState.readQuad, MemoryState.readVec, MemoryState.readAt_addBlock_of_id_ne h,
    MemoryState.readAt_addBlock_of_id_ne (h' _)]

/-! ### Stores -/

/-- A store of `y ++ x` is a store of `x`, then of `y` right after it. -/
theorem MemoryState.storeAt_append {m : MemoryState} {p : Pointer} {x : BitVec w} {y : BitVec v}
    {off : BitVec 64} (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 = w) :
    m.storeAt p (y ++ x) = (m.storeAt p x).storeAt (p.add off) y := by
  have h :=
    MemoryState.storeAt_storeAt_append (m := m) (x := x) (y := y) (k := off.toNat)
      (by simpa using hov) (by omega) off.isLt
  simpa using h.symm

/-- `memset` of 128 zero bytes at a point's `P14`: its `P14` and `P25` zeroed. -/
theorem MemoryState.storeAt_zero_14_25 {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 192 ≤ 2 ^ 64) :
    m.storeAt (p.add 64#64) 0#1024 =
      (m.storeAt (p.add 64#64) (BitVec.packLanes (Vector.replicate 8 0#64))).storeAt (p.add 128#64)
        (BitVec.packLanes (Vector.replicate 8 0#64)) := by
  have hov : ¬(p.add 64#64).offset.uaddOverflow 64#64 := by
    simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add]
    simp
    omega
  have hadd : (p.add 64#64).add 64#64 = p.add 128#64 := by
    simp only [Pointer.add, BitVec.add_assoc]
    rfl
  rw [← hadd, ← MemoryState.storeAt_append hov rfl, BitVec.packLanes_zero]
  simp

/-- A second store to the same range replaces the first. -/
theorem MemoryState.storeAt_storeAt_same {m : MemoryState} {p : Pointer} {x y : BitVec w} :
    (m.storeAt p x).storeAt p y = m.storeAt p y :=
  MemoryState.storeAt_storeAt_self

/-- Stores to disjoint ranges commute. -/
theorem MemoryState.storeAt_swap {m : MemoryState} {p q : Pointer} {x : BitVec v} {y : BitVec w}
    (h : (Range.of p v).Disjoint (Range.of q w)) :
    (m.storeAt p x).storeAt q y = (m.storeAt q y).storeAt p x := by
  by_cases hid : p.id = q.id
  · simp only [Range.Disjoint, Range.of, hid, ne_eq, not_true_eq_false, false_or] at h
    simp only [MemoryState.storeAt, hid,
      MemoryState.modifyBlock_modifyBlock_self]
    congr 1
    funext blk
    simp only [Function.comp_apply, MemoryBlock.mk.injEq, true_and, and_true]
    exact
      ⟨heq_of_eq (spliceBits_comm_of_disjoint _ _ _ _ _ (by omega)),
        heq_of_eq (spliceBits_comm_of_disjoint _ _ _ _ _ (by omega))⟩
  · exact MemoryState.modifyBlock_comm hid

/-- `P03` and `P14` stored twice, then `P25`: the second stores. -/
theorem MemoryState.storeAt_03_14_twice {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 192 ≤ 2 ^ 64) {a b x y z : BitVec 512} :
    ((((m.storeAt p a).storeAt (p.add 64#64) b).storeAt p x).storeAt (p.add 64#64) y).storeAt
        (p.add 128#64) z =
      ((m.storeAt p x).storeAt (p.add 64#64) y).storeAt (p.add 128#64) z := by
  have d01 := Range.disjoint_quad h (a := 64) (b := 0) (by omega) (by omega) (by omega)
  rw [Pointer.add_zero_quad] at d01
  rw [MemoryState.storeAt_swap (p := p.add 64#64) (q := p) d01, MemoryState.storeAt_storeAt_same,
    MemoryState.storeAt_storeAt_same]

/-- A point stored twice, vector by vector: the second stores win. -/
theorem MemoryState.storeAt_quad_twice {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 192 ≤ 2 ^ 64) {a b c x y z : BitVec 512} :
    (((((m.storeAt p a).storeAt (p.add 64#64) b).storeAt (p.add 128#64) c).storeAt p x).storeAt
            (p.add 64#64) y).storeAt
        (p.add 128#64) z =
      ((m.storeAt p x).storeAt (p.add 64#64) y).storeAt (p.add 128#64) z := by
  have d20 := Range.disjoint_quad h (a := 128) (b := 0) (by omega) (by omega) (by omega)
  have d21 := Range.disjoint_quad h (a := 128) (b := 64) (by omega) (by omega) (by omega)
  rw [Pointer.add_zero_quad] at d20
  rw [MemoryState.storeAt_swap (p := p.add 128#64) (q := p) d20,
    MemoryState.storeAt_swap (p := p.add 128#64) (q := p.add 64#64) d21,
    MemoryState.storeAt_storeAt_same, MemoryState.storeAt_03_14_twice h]

/-! ### Frames -/

@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeQuad {m : MemoryState} :
    (m.storeQuad p P).eraseFrom n = (m.eraseFrom n).storeQuad p P := by
  simp only [MemoryState.storeQuad, MemoryState.storeVec, MemoryState.eraseFrom_storeAt]

@[mlir_frame, mlir_erase]
theorem MemoryState.storeQuad_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeQuad p P = m.eraseFrom n := by
  have h' (k : BitVec 64) : n ≤ (p.add k).id.id := by simpa [Pointer.add] using h
  simp only [MemoryState.storeQuad, MemoryState.storeVec, MemoryState.storeAt_eraseFrom_of_le h,
    MemoryState.storeAt_eraseFrom_of_le (h' _)]

section Patterns

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

/-! ### `FD_R43X6_QUAD_FOLD_UNSIGNED` as compiled, a pattern -/

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED( R, x )` as eleven instructions, the results kept in `r03 r14 r25`:
the carries `h03 h14 h25` (`sh43`, `sh4340` hold the shifts), `19 h25` into `p` (`k19` holds `19` in
lanes 4-7), the low bits `l03 l14 l25` (`mk43`, `mk4340` hold the masks), `p`'s top half and `h25`'s
bottom half into `c`. -/
def foldUnsignedRun
    (x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25 r25 :
      Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.lshr false)) h03 (.val x03.i x03.h) (.val sh43.i sh43.h),
    .binop (.vector (.lshr false)) h14 (.val x14.i x14.h) (.val sh43.i sh43.h),
    .binop (.vector (.lshr false)) h25 (.val x25.i x25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val x03.i x03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r03 (.val c.i c.h) (.val l03.i l03.h),
    .binop (.vector .and) l14 (.val x14.i x14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r14 (.val l14.i l14.h) (.val h03.i h03.h),
    .binop (.vector .and) l25 (.val x25.i x25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val l25.i l25.h) (.val h14.i h14.h)]

/-- `19` in lanes 4-7, the multiplier of the fold's top carries; the other lanes unused. -/
abbrev k19Lanes : ⟦.vec 8 64⟧ :=
  #v[.poison, .poison, .poison, .poison, .value 19#64, .value 19#64, .value 19#64, .value 19#64]

/-- Where the body at `pos` is `foldUnsignedRun` and `x03 x14 x25` hold `X`, the others the
constants: running on from `pos` then `g` gives `K` if it does from `pos + 11` with
`Quad.foldUnsignedC X` in `r03 r14 r25` (as `u03 u14 u25`), whatever the intermediates hold. -/
theorem runBodyFrom_foldUnsignedRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25 r25 :
      Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldUnsignedRun x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25
            r25 ++
          rest)
    (hR :
      E ⊨ [x03 := X03, x14 := X14, x25 := X25, sh43 := Vector.replicate 8 43#64, sh4340 :=
        #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64], mk43 :=
        Vector.replicate 8 8796093022207#64, mk4340 :=
        #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64, 1099511627775#64,
          1099511627775#64, 1099511627775#64, 1099511627775#64]])
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd :
      [x03.i, x14.i, x25.i, sh43.i, sh4340.i, k19.i, mk43.i, mk4340.i, h03.i, h14.i, h25.i, p.i,
          l03.i, c.i, r03.i, l14.i, r14.i, l25.i].Nodup)
    (hK :
      ∀ (vh03 vh14 vh25 vp vl03 vc vl14 vl25 : ⟦.vec 8 64⟧) (u03 u14 u25 : Wwl),
        ∀ (_hu : Quad.foldUnsignedC ⟨X03, X14, X25⟩ = ⟨u03, u14, u25⟩),
          (blk.runBodyFrom
                E[h03 := vh03, h14 := vh14, h25 := vh25, p := vp, l03 := vl03, c := vc, r03 :=
                  Ty.wrap u03, l14 := vl14, r14 := Ty.wrap u14, l25 := vl25, r25 := Ty.wrap u25]
                (pos + 11) S >>=
              g) =
            K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent uh03
  step_pure with transparent uh14
  step_pure with transparent uh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shru_vector,
    shr40_mul19_no_overflow] with transparent up
  step_pure with ul03
  step_pure with uc
  have huc' :
    uc =
      wwl_pack_halves (wwl_mul (wwl_shru_vector X25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shru_vector X25 s4340) 0 := by
    rw [huc]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  have hok03 := fold_ok03 X25 X03
  rw [← hul03, ← huc'] at hok03
  step_pure with uf03
  step_pure with ul14
  have hok14 := fold_ok _ X14 X03 (.inl rfl)
  rw [← hul14, ← huh03] at hok14
  step_pure with uf14
  step_pure with ul25
  have hok25 := fold_ok _ X25 X14 (.inr rfl)
  rw [← hul25, ← huh14] at hok25
  step_pure with uf25
  have e : Quad.foldUnsignedC ⟨X03, X14, X25⟩ = ⟨uf03, uf14, uf25⟩ := by
    rw [huf03, huf14, huf25, hul03, hul14, hul25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ e

/-- `foldUnsignedRun` with each result stored as it is formed: `r03` at `q`, `r14` at `g1`
(`q + 64`, by a `getelementptr`), `r25` at `g2` (`q + 128`). -/
def foldUnsignedStoreRun
    (x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25 r25 :
      Dst Γ (.vec 8 64))
    (q : Reg Γ .ptr) (g1 g2 : Dst Γ .ptr) : List (Instr Γ) :=
  [.binop (.vector (.lshr false)) h03 (.val x03.i x03.h) (.val sh43.i sh43.h),
    .binop (.vector (.lshr false)) h14 (.val x14.i x14.h) (.val sh43.i sh43.h),
    .binop (.vector (.lshr false)) h25 (.val x25.i x25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val x03.i x03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r03 (.val c.i c.h) (.val l03.i l03.h),
    .store q (.val r03.i r03.h), .binop (.vector .and) l14 (.val x14.i x14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r14 (.val l14.i l14.h) (.val h03.i h03.h),
    .unop (.gepConst { nusw := true, nuw := true } 64) g1 q,
    .store (.val g1.i g1.h) (.val r14.i r14.h),
    .binop (.vector .and) l25 (.val x25.i x25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val l25.i l25.h) (.val h14.i h14.h),
    .unop (.gepConst { nusw := true, nuw := true } 128) g2 q,
    .store (.val g2.i g2.h) (.val r25.i r25.h)]

/-- Where the body at `pos` is `foldUnsignedStoreRun`, `x03 x14 x25` hold `X`, `q` the point `Q`
and the others the constants: running on from `pos` then `g` gives `K` if it does from `pos + 16`
with `Quad.foldUnsignedC X` (as `u03 u14 u25`) in `r03 r14 r25` and stored at `Q`. -/
theorem runBodyFrom_foldUnsignedStoreRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25 r25 :
      Dst Γ (.vec 8 64)}
    {q : Reg Γ .ptr} {g1 g2 : Dst Γ .ptr} {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {Q : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldUnsignedStoreRun x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14
            l25 r25 q g1 g2 ++
          rest)
    (hR :
      E ⊨ [x03 := X03, x14 := X14, x25 := X25, sh43 := Vector.replicate 8 43#64, sh4340 :=
        #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64], mk43 :=
        Vector.replicate 8 8796093022207#64, mk4340 :=
        #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64, 1099511627775#64,
          1099511627775#64, 1099511627775#64, 1099511627775#64]])
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes) (hq : E.read q = .value Q)
    (hqg : q ≠ .val g1.i g1.h) (hwf : S.WF) (hQ : S.mem.QuadRoom Q)
    (hd :
      [x03.i, x14.i, x25.i, sh43.i, sh4340.i, k19.i, mk43.i, mk4340.i, h03.i, h14.i, h25.i, p.i,
          l03.i, c.i, r03.i, l14.i, r14.i, l25.i, g1.i, r25.i, g2.i].Nodup)
    (hK :
      ∀ (vh03 vh14 vh25 vp vl03 vc vl14 vl25 : ⟦.vec 8 64⟧) (u03 u14 u25 : Wwl)
        (_hu : Quad.foldUnsignedC ⟨X03, X14, X25⟩ = ⟨u03, u14, u25⟩),
        (blk.runBodyFrom
              E[h03 := vh03, h14 := vh14, h25 := vh25, p := vp, l03 := vl03, c := vc, r03 :=
                Ty.wrap u03, l14 := vl14, r14 := Ty.wrap u14, g1 := .value (Q.add 64#64), l25 :=
                vl25, r25 := Ty.wrap u25, g2 := .value (Q.add 128#64)]
              (pos + 16)
              { alloc := S.alloc,
                mem :=
                  ((S.mem.storeAt Q (BitVec.packLanes u03)).storeAt (Q.add 64#64)
                        (BitVec.packLanes u14)).storeAt
                    (Q.add 128#64) (BitVec.packLanes u25) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent uh03
  step_pure with transparent uh14
  step_pure with transparent uh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shru_vector,
    shr40_mul19_no_overflow] with transparent up
  step_pure with ul03
  step_pure with uc
  have huc' :
    uc =
      wwl_pack_halves (wwl_mul (wwl_shru_vector X25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shru_vector X25 s4340) 0 := by
    rw [huc]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  have hok03 := fold_ok03 X25 X03
  rw [← hul03, ← huc'] at hok03
  step_pure with uf03
  step_store
  step_pure with ul14
  have hok14 := fold_ok _ X14 X03 (.inl rfl)
  rw [← hul14, ← huh03] at hok14
  step_pure with uf14
  step_pure
  step_store
  step_pure with ul25
  have hok25 := fold_ok _ X25 X14 (.inr rfl)
  rw [← hul25, ← huh14] at hok25
  step_pure with uf25
  step_pure
  step_store
  have e : Quad.foldUnsignedC ⟨X03, X14, X25⟩ = ⟨uf03, uf14, uf25⟩ := by
    rw [huf03, huf14, huf25, hul03, hul14, hul25]
    rfl
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ e

/-- `foldUnsignedStoreRun` with `q + 64` and `q + 128` computed before, in `g1` and `g2`. -/
def foldUnsignedStoreRun'
    (x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25 r25 :
      Dst Γ (.vec 8 64))
    (q : Reg Γ .ptr) (g1 g2 : Dst Γ .ptr) : List (Instr Γ) :=
  [.binop (.vector (.lshr false)) h03 (.val x03.i x03.h) (.val sh43.i sh43.h),
    .binop (.vector (.lshr false)) h14 (.val x14.i x14.h) (.val sh43.i sh43.h),
    .binop (.vector (.lshr false)) h25 (.val x25.i x25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val x03.i x03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r03 (.val c.i c.h) (.val l03.i l03.h),
    .store q (.val r03.i r03.h), .binop (.vector .and) l14 (.val x14.i x14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r14 (.val l14.i l14.h) (.val h03.i h03.h),
    .store (.val g1.i g1.h) (.val r14.i r14.h),
    .binop (.vector .and) l25 (.val x25.i x25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val l25.i l25.h) (.val h14.i h14.h),
    .store (.val g2.i g2.h) (.val r25.i r25.h)]

/-- `runBodyFrom_foldUnsignedStoreRun` for `foldUnsignedStoreRun'`, `g1` and `g2` holding `Q + 64`
and `Q + 128`. -/
theorem runBodyFrom_foldUnsignedStoreRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14 r14 l25 r25 :
      Dst Γ (.vec 8 64)}
    {q : Reg Γ .ptr} {g1 g2 : Dst Γ .ptr} {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {Q : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldUnsignedStoreRun' x03 x14 x25 sh43 sh4340 k19 mk43 mk4340 h03 h14 h25 p l03 c r03 l14
            r14 l25 r25 q g1 g2 ++
          rest)
    (hR :
      E ⊨ [x03 := X03, x14 := X14, x25 := X25, sh43 := Vector.replicate 8 43#64, sh4340 :=
        #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64], mk43 :=
        Vector.replicate 8 8796093022207#64, mk4340 :=
        #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64, 1099511627775#64,
          1099511627775#64, 1099511627775#64, 1099511627775#64]])
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes) (hq : E.read q = .value Q)
    (hg1 : E.read (.val g1.i g1.h) = .value (Q.add 64#64))
    (hg2 : E.read (.val g2.i g2.h) = .value (Q.add 128#64)) (hwf : S.WF) (hQ : S.mem.QuadRoom Q)
    (hd :
      [x03.i, x14.i, x25.i, sh43.i, sh4340.i, k19.i, mk43.i, mk4340.i, h03.i, h14.i, h25.i, p.i,
          l03.i, c.i, r03.i, l14.i, r14.i, l25.i, g1.i, r25.i, g2.i].Nodup)
    (hK :
      ∀ (vh03 vh14 vh25 vp vl03 vc vl14 vl25 : ⟦.vec 8 64⟧) (u03 u14 u25 : Wwl)
        (_hu : Quad.foldUnsignedC ⟨X03, X14, X25⟩ = ⟨u03, u14, u25⟩),
        (blk.runBodyFrom
              E[h03 := vh03, h14 := vh14, h25 := vh25, p := vp, l03 := vl03, c := vc, r03 :=
                Ty.wrap u03, l14 := vl14, r14 := Ty.wrap u14, l25 := vl25, r25 := Ty.wrap u25]
              (pos + 14)
              { alloc := S.alloc,
                mem :=
                  ((S.mem.storeAt Q (BitVec.packLanes u03)).storeAt (Q.add 64#64)
                        (BitVec.packLanes u14)).storeAt
                    (Q.add 128#64) (BitVec.packLanes u25) } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent uh03
  step_pure with transparent uh14
  step_pure with transparent uh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shru_vector,
    shr40_mul19_no_overflow] with transparent up
  step_pure with ul03
  step_pure with uc
  have huc' :
    uc =
      wwl_pack_halves (wwl_mul (wwl_shru_vector X25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shru_vector X25 s4340) 0 := by
    rw [huc]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  have hok03 := fold_ok03 X25 X03
  rw [← hul03, ← huc'] at hok03
  step_pure with uf03
  step_store
  step_pure with ul14
  have hok14 := fold_ok _ X14 X03 (.inl rfl)
  rw [← hul14, ← huh03] at hok14
  step_pure with uf14
  step_store
  step_pure with ul25
  have hok25 := fold_ok _ X25 X14 (.inr rfl)
  rw [← hul25, ← huh14] at hok25
  step_pure with uf25
  step_store
  have e : Quad.foldUnsignedC ⟨X03, X14, X25⟩ = ⟨uf03, uf14, uf25⟩ := by
    rw [huf03, huf14, huf25, hul03, hul14, hul25]
    rfl
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ e

/-! ### `FD_R43X6_QUAD_FOLD_SIGNED` as compiled, patterns -/

/-- `FD_R43X6_QUAD_FOLD_SIGNED( R, x )` as seventeen instructions, the results in `r03 r14 r25`:
`x` less the biases into `d03 d14 d25`, their carries `h03 h14 h25`, `19 h25` into `p`, the low
bits `l03 l14 l25`, `p`'s top half and `h25`'s bottom half into `c`; then `(l03 + b03) + c`,
`(h03 + b) + l14`, `(h14 + b) + l25` through `e03 e14 e25`. -/
def foldSignedRun (x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64))
    (d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.add {})) d03 (.val x03.i x03.h) (.val nb03.i nb03.h),
    .binop (.vector (.add {})) d14 (.val x14.i x14.h) (.val nb.i nb.h),
    .binop (.vector (.add {})) d25 (.val x25.i x25.h) (.val nb.i nb.h),
    .binop (.vector (.ashr false)) h03 (.val d03.i d03.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h14 (.val d14.i d14.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h25 (.val d25.i d25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val d03.i d03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e03 (.val l03.i l03.h) (.val b03.i b03.h),
    .binop (.vector (.add {})) r03 (.val e03.i e03.h) (.val c.i c.h),
    .binop (.vector .and) l14 (.val d14.i d14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true })) e14 (.val h03.i h03.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r14 (.val e14.i e14.h) (.val l14.i l14.h),
    .binop (.vector .and) l25 (.val d25.i d25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true })) e25 (.val h14.i h14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val e25.i e25.h) (.val l25.i l25.h)]

/-- `foldSignedRun` with the sums in `Quad.foldSignedC'`'s order: `(c + b03) + l03`,
`(l14 + b) + h03`, `(h14 + b) + l25`. -/
def foldSignedRun' (x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64))
    (d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.add {})) d03 (.val x03.i x03.h) (.val nb03.i nb03.h),
    .binop (.vector (.add {})) d14 (.val x14.i x14.h) (.val nb.i nb.h),
    .binop (.vector (.add {})) d25 (.val x25.i x25.h) (.val nb.i nb.h),
    .binop (.vector (.ashr false)) h03 (.val d03.i d03.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h14 (.val d14.i d14.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h25 (.val d25.i d25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val d03.i d03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add {})) e03 (.val c.i c.h) (.val b03.i b03.h),
    .binop (.vector (.add {})) r03 (.val e03.i e03.h) (.val l03.i l03.h),
    .binop (.vector .and) l14 (.val d14.i d14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e14 (.val l14.i l14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true })) r14 (.val e14.i e14.h) (.val h03.i h03.h),
    .binop (.vector .and) l25 (.val d25.i d25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true })) e25 (.val h14.i h14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val e25.i e25.h) (.val l25.i l25.h)]

/-- `FD_R43X6_QUAD_FOLD_SIGNED`'s constants in `nb03 … mk4340`: the biases subtracted and added
back, the carry shifts and the low-bit masks. -/
abbrev FoldSignedConsts (E : ⟪Γ⟫) (nb03 nb sh43 sh4340 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)) :
    Prop :=
  E ⊨ [nb03 := negBias03, nb := Vector.replicate 8 18446744073708503040#64, sh43 :=
    Vector.replicate 8 43#64, sh4340 := #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64],
    mk43 := Vector.replicate 8 8796093022207#64, b03 := bias03, b := Vector.replicate 8 1048576#64,
    mk4340 :=
    #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64, 1099511627775#64,
      1099511627775#64, 1099511627775#64, 1099511627775#64]]

/-- Where the body at `pos` is `foldSignedRun`, `x03 x14 x25` hold `X` and the others the
constants: running on from `pos` then `g` gives `K` if it does from `pos + 17` with
`Quad.foldSignedC X` in `r03 r14 r25` (as `s03 s14 s25`), whatever the intermediates hold. -/
theorem runBodyFrom_foldSignedRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedRun x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 d03 d14 d25 h03 h14 h25
            p l03 c e03 r03 l14 e14 r14 l25 e25 r25 ++
          rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hC : FoldSignedConsts E nb03 nb sh43 sh4340 mk43 b03 b mk4340)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd :
      [x03.i, x14.i, x25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          d03.i, d14.i, d25.i, h03.i, h14.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i, l14.i, e14.i,
          r14.i, l25.i, e25.i].Nodup)
    (hK :
      ∀ (vd03 vd14 vd25 vh03 vh14 vh25 vp vl03 vc ve03 vl14 ve14 vl25 ve25 : ⟦.vec 8 64⟧)
        (s03 s14 s25 : Wwl) (_hs : Quad.foldSignedC ⟨X03, X14, X25⟩ = ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := vd14, d25 := vd25, h03 := vh03, h14 := vh14, h25 := vh25, p :=
                vp, l03 := vl03, c := vc, e03 := ve03, r03 := Ty.wrap s03, l14 := vl14, e14 := ve14,
                r14 := Ty.wrap s14, l25 := vl25, e25 := ve25, r25 := Ty.wrap s25]
              (pos + 17) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with sd03
  step_pure with sd14
  step_pure with sd25
  step_pure with sh03
  step_pure with sh14
  step_pure with transparent sh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector,
    sshr40_mul19_no_overflow] with transparent sp
  step_pure with sl03
  step_pure with sc03
  have hsc03' :
    sc03 =
      wwl_pack_halves (wwl_mul (wwl_shr_vector sd25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shr_vector sd25 s4340) 0 := by
    rw [hsc03]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  have hok03 := mask_add_bias03_ok sd03
  rw [← hsl03] at hok03
  step_pure with se03
  step_pure [hsc03'] with sf03
  step_pure with sl14
  have hok14 := shr_add_bias_ok sd03 _ (.inl rfl)
  rw [← hsh03] at hok14
  step_pure with se14
  have hok14' := shr43_add_bias_add_mask_ok sd03 sd14 _ (.inl rfl)
  rw [← hsh03, ← hse14, ← hsl14] at hok14'
  step_pure with sf14
  step_pure with sl25
  have hok25 := shr_add_bias_ok sd14 _ (.inl rfl)
  rw [← hsh14] at hok25
  step_pure with se25
  have hok25' := shr43_add_bias_add_mask_ok sd14 sd25 _ (.inr rfl)
  rw [← hsh14, ← hse25, ← hsl25] at hok25'
  step_pure with sf25
  have e : Quad.foldSignedC ⟨X03, X14, X25⟩ = ⟨sf03, sf14, sf25⟩ := by
    rw [hsf03, hsf14, hsf25, hse03, hse14, hse25, hsl03, hsl14, hsl25, hsh03, hsh14, hsd03, hsd14,
      hsd25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

/-- `runBodyFrom_foldSignedRun` for `foldSignedRun'`: `Quad.foldSignedC' X` in `r03 r14 r25`. -/
theorem runBodyFrom_foldSignedRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedRun' x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 d03 d14 d25 h03 h14 h25
            p l03 c e03 r03 l14 e14 r14 l25 e25 r25 ++
          rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hC : FoldSignedConsts E nb03 nb sh43 sh4340 mk43 b03 b mk4340)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd :
      [x03.i, x14.i, x25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          d03.i, d14.i, d25.i, h03.i, h14.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i, l14.i, e14.i,
          r14.i, l25.i, e25.i].Nodup)
    (hK :
      ∀ (vd03 vd14 vd25 vh03 vh14 vh25 vp vl03 vc ve03 vl14 ve14 vl25 ve25 : ⟦.vec 8 64⟧)
        (s03 s14 s25 : Wwl) (_hs : Quad.foldSignedC' ⟨X03, X14, X25⟩ = ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := vd14, d25 := vd25, h03 := vh03, h14 := vh14, h25 := vh25, p :=
                vp, l03 := vl03, c := vc, e03 := ve03, r03 := Ty.wrap s03, l14 := vl14, e14 := ve14,
                r14 := Ty.wrap s14, l25 := vl25, e25 := ve25, r25 := Ty.wrap s25]
              (pos + 17) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with sd03
  step_pure with sd14
  step_pure with sd25
  step_pure with sh03
  step_pure with sh14
  step_pure with transparent sh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector,
    sshr40_mul19_no_overflow] with transparent sp
  step_pure with sl03
  step_pure with sc03
  have hsc03' :
    sc03 =
      wwl_pack_halves (wwl_mul (wwl_shr_vector sd25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shr_vector sd25 s4340) 0 := by
    rw [hsc03]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  step_pure [hsc03'] with se03
  step_pure with sf03
  step_pure with sl14
  have hok14 := mask_add_bias_ok sd14
  rw [← hsl14] at hok14
  step_pure with se14
  have hok14' := mask_add_bias_add_shr_ok sd03 sd14
  rw [← hsh03, ← hsl14, ← hse14] at hok14'
  step_pure with sf14
  step_pure with sl25
  have hok25 := shr_add_bias_ok sd14 _ (.inl rfl)
  rw [← hsh14] at hok25
  step_pure with se25
  have hok25' := shr43_add_bias_add_mask_ok sd14 sd25 _ (.inr rfl)
  rw [← hsh14, ← hse25, ← hsl25] at hok25'
  step_pure with sf25
  have e : Quad.foldSignedC' ⟨X03, X14, X25⟩ = ⟨sf03, sf14, sf25⟩ := by
    rw [hsf03, hsf14, hsf25, hse03, hse14, hse25, hsl03, hsl14, hsl25, hsh03, hsh14, hsd03, hsd14,
      hsd25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

end Patterns

-- last: registered early, the transport search backtracks through it for every `Room` fact
attribute [mlir_transport] MemoryState.QuadFit.room

end

end MLIR
