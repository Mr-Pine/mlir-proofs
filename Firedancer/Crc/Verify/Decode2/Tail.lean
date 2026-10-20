module

public import Firedancer.Crc.Verify.Decode2.Frame
public import Firedancer.R52x5.Common.Runs
import Firedancer.Crc.Verify.Decode2.Tactics
import Firedancer.Crc.Verify.QuadRuns

/-! `fd_r52x5_ge_decode2`'s `^bb14`: both lanes decoded, `x` fixed, signed and both points stored. -/

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

@[expose] public section

namespace fd_r52x5_ge_decode2

attribute [local mlir_env 1100] read_write_same

attribute [-mlir_operation] Operation.pblendvb

@[local mlir_transport]
theorem Frame.storeQuad5 {B : GlobalState} {m : MemoryState} (h : Frame B m) :
    Frame B (m.storeQuad5 p Q) :=
  h.storeTmp5

/-- A QUAD's bytes stored as a point at `p`: `qk` to `p + 32 k` (`gk` the offsets). -/
def storeBytesQuadRun (p : Reg Γ .ptr) (q0 q1 q2 q3 q4 : Reg Γ (.vec 32 8))
    (g1 g2 g3 g4 : Dst Γ .ptr) : List (Instr Γ) :=
  [.store p q0,
    .unop (.gepConst { nusw := true, nuw := true } 32) g1 p, .store (.val g1.i g1.h) q1,
    .unop (.gepConst { nusw := true, nuw := true } 64) g2 p, .store (.val g2.i g2.h) q2,
    .unop (.gepConst { nusw := true, nuw := true } 96) g3 p, .store (.val g3.i g3.h) q3,
    .unop (.gepConst { nusw := true, nuw := true } 128) g4 p, .store (.val g4.i g4.h) q4]

/-- Where the body at `pos` is `storeBytesQuadRun`, `qk` hold the bytes of `Vk` and `p` a point
with room: running on from `pos` then `g` gives `K` if it does from `pos + 9` with
`⟨V0, …, V4⟩` stored at `P` (`storeQuad5`). -/
theorem runBodyFrom_storeBytesQuadRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p : Reg Γ .ptr} {q0 q1 q2 q3 q4 : Reg Γ (.vec 32 8)} {g1 g2 g3 g4 : Dst Γ .ptr}
    {rest : List (Instr Γ)} {V0 V1 V2 V3 V4 : Wl} {P : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = storeBytesQuadRun p q0 q1 q2 q3 q4 g1 g2 g3 g4 ++ rest)
    (hR :
      E ⊨ [p := P, q0 := wlBytes V0, q1 := wlBytes V1, q2 := wlBytes V2, q3 := wlBytes V3,
        q4 := wlBytes V4])
    (hd : p ≠ .val g1.i g1.h ∧ p ≠ .val g2.i g2.h ∧ p ≠ .val g3.i g3.h)
    (hP : S.mem.Quad5Room P)
    (hK :
      (blk.runBodyFrom
            E[g1 := .value (P.add 32#64), g2 := .value (P.add 64#64), g3 := .value (P.add 96#64),
              g4 := .value (P.add 128#64)]
            (pos + 9) { alloc := S.alloc, mem := S.mem.storeQuad5 P ⟨V0, V1, V2, V3, V4⟩ } >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := hP
  obtain ⟨hp1, hp2, hp3⟩ := hd
  have o1 : ¬P.offset.uaddOverflow 32#64 := by simp [BitVec.uaddOverflow]; omega
  have o2 : ¬P.offset.uaddOverflow 64#64 := by simp [BitVec.uaddOverflow]; omega
  have o3 : ¬P.offset.uaddOverflow 96#64 := by simp [BitVec.uaddOverflow]; omega
  have o4 : ¬P.offset.uaddOverflow 128#64 := by simp [BitVec.uaddOverflow]; omega
  step_store
  step_pure [o1]
  step_store
  step_pure [o2]
  step_store
  step_pure [o3]
  step_store
  step_pure [o4]
  step_store
  rw [hE, hS]
  simp only [MemoryState.storeAt_packLanes_wlBytes]
  exact hK

/-- Lanes `a`, `b` of a `wl_t`, lanes `2`, `3` poison: `shufflevector [0, 5, -1, -1]`. -/
def pairLanes (a b : BitVec 64) : ⟦Ty4x64⟧ :=
  #v[PoisonOr.value a, PoisonOr.value b, PoisonOr.poison, PoisonOr.poison]

/-- The bytes of `pairLanes a b`: those of `a`, of `b`, then 16 poison. -/
def pairBytes (a b : BitVec 64) : ⟦Ty32x8⟧ :=
  #v[PoisonOr.value (a.extractLsb' 0 8), PoisonOr.value (a.extractLsb' 8 8),
    PoisonOr.value (a.extractLsb' 16 8), PoisonOr.value (a.extractLsb' 24 8),
    PoisonOr.value (a.extractLsb' 32 8), PoisonOr.value (a.extractLsb' 40 8),
    PoisonOr.value (a.extractLsb' 48 8), PoisonOr.value (a.extractLsb' 56 8),
    PoisonOr.value (b.extractLsb' 0 8), PoisonOr.value (b.extractLsb' 8 8),
    PoisonOr.value (b.extractLsb' 16 8), PoisonOr.value (b.extractLsb' 24 8),
    PoisonOr.value (b.extractLsb' 32 8), PoisonOr.value (b.extractLsb' 40 8),
    PoisonOr.value (b.extractLsb' 48 8), PoisonOr.value (b.extractLsb' 56 8),
    PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison,
    PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison,
    PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison,
    PoisonOr.poison]

/-- Bytes `16 … 23` the `i64` `z`, the rest poison (`mask1Bytes`, `mask0Bytes`). -/
abbrev maskBytes (z : BitVec 8) : ⟦Ty32x8⟧ :=
  #v[PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison,
    PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison,
    PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison,
    PoisonOr.poison, PoisonOr.value z, PoisonOr.value 0#8, PoisonOr.value 0#8,
    PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8,
    PoisonOr.value 0#8, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison,
    PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]

theorem mask1Bytes_maskBytes : mask1Bytes = maskBytes 1#8 := rfl
theorem mask0Bytes_maskBytes : mask0Bytes = maskBytes 0#8 := rfl

/-- The bytes of `a`, `b` and the `i64` `z`, the last 8 poison: `pairBytes a b` with
`maskBytes z` shuffled in. -/
def limbPre (a b : BitVec 64) (z : BitVec 8) : ⟦Ty32x8⟧ :=
  #v[PoisonOr.value (a.extractLsb' 0 8), PoisonOr.value (a.extractLsb' 8 8),
    PoisonOr.value (a.extractLsb' 16 8), PoisonOr.value (a.extractLsb' 24 8),
    PoisonOr.value (a.extractLsb' 32 8), PoisonOr.value (a.extractLsb' 40 8),
    PoisonOr.value (a.extractLsb' 48 8), PoisonOr.value (a.extractLsb' 56 8),
    PoisonOr.value (b.extractLsb' 0 8), PoisonOr.value (b.extractLsb' 8 8),
    PoisonOr.value (b.extractLsb' 16 8), PoisonOr.value (b.extractLsb' 24 8),
    PoisonOr.value (b.extractLsb' 32 8), PoisonOr.value (b.extractLsb' 40 8),
    PoisonOr.value (b.extractLsb' 48 8), PoisonOr.value (b.extractLsb' 56 8),
    PoisonOr.value z, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8,
    PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8, PoisonOr.value 0#8,
    PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison, PoisonOr.poison,
    PoisonOr.poison, PoisonOr.poison, PoisonOr.poison]

/-- `shufflevector [0, 5, -1, -1]` of `x`, `y` into `u0` and its bytes into `u1`: lanes `0` of
the permuted `x` and `1` of the permuted `y`. -/
def pairRun (x y : Reg Γ Ty4x64) (u0 : Dst Γ Ty4x64) (u1 : Dst Γ Ty32x8) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 5, none, none]) u0 x y,
    .unop (.bitcast (by decide)) u1 (.val u0.i u0.h)]

/-- Where the body at `pos` is `pairRun` and `x`, `y` hold lane `j` of `A`, `B` broadcast: running on
from `pos + 2` with lane `j`'s pair in `u0` and its bytes in `u1`. -/
theorem runBodyFrom_pairRun (j : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x y : Reg Γ Ty4x64} {u0 : Dst Γ Ty4x64} {u1 : Dst Γ Ty32x8} {rest : List (Instr Γ)}
    {A B : Wl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = pairRun x y u0 u1 ++ rest)
    (hR : E ⊨ [x := wlPermute A j j j j, y := wlPermute B j j j j]) (hj : j < 4)
    (hK :
      (blk.runBodyFrom E[u0 := pairLanes A[j] B[j], u1 := pairBytes A[j] B[j]] (pos + 2) S >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with v0
  have e0 : v0 = pairLanes A[j] B[j] := by
    rw [hv0]; simp [pairLanes, wlPermute, Nat.mod_eq_of_lt hj]
  clear hv0
  subst e0
  step_pure with v1
  have e1 : v1 = pairBytes A[j] B[j] := by
    rw [hv1]; rfl
  clear hv1
  subst e1
  rw [hE]
  exact hK

/-- `shufflevector` of `u1`'s first 16 bytes with the mask `m`'s bytes `16 … 23` into `u2`. -/
def maskRun (u1 m : Reg Γ Ty32x8) (u2 : Dst Γ Ty32x8) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8,
      some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 48, some 49, some 50,
      some 51, some 52, some 53, some 54, some 55, none, none, none, none, none, none, none, none])
    u2 u1 m]

/-- Where the body at `pos` is `maskRun`, `u1` holds `pairBytes a b` and `m` `maskBytes z`: running
on from `pos + 1` with `limbPre a b z` in `u2`. -/
theorem runBodyFrom_maskRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u1 m : Reg Γ Ty32x8} {u2 : Dst Γ Ty32x8} {rest : List (Instr Γ)} {a b : BitVec 64}
    {z : BitVec 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = maskRun u1 m u2 ++ rest)
    (hR : E ⊨ [u1 := pairBytes a b, m := maskBytes z])
    (hK : (blk.runBodyFrom E[u2 := limbPre a b z] (pos + 1) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with v2
  have e2 : v2 = limbPre a b z := by
    rw [hv2]; rfl
  clear hv2
  subst e2
  rw [hE]
  exact hK

/-- `t`'s bytes into `u3`, then `u2`'s first 24 with `u3`'s last 8 into `u4`: a limb of a
decoded point as bytes. -/
def limbRun (u2 : Dst Γ Ty32x8) (t : Reg Γ Ty4x64) (u3 u4 : Dst Γ Ty32x8) : List (Instr Γ) :=
  [.unop (.bitcast (by decide)) u3 t,
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7,
      some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 16, some 17,
      some 18, some 19, some 20, some 21, some 22, some 23, some 56, some 57, some 58, some 59,
      some 60, some 61, some 62, some 63])
    u4 (.val u2.i u2.h) (.val u3.i u3.h)]

/-- `limbPre a b z`'s first 24 bytes with the last 8 of `tv`: the bytes of `wl a b z tv[3]`. -/
theorem limbPre_bytes (a b : BitVec 64) (z : BitVec 8) (tv : Wl) :
    (#v[(limbPre a b z)[0], (limbPre a b z)[1], (limbPre a b z)[2], (limbPre a b z)[3],
      (limbPre a b z)[4], (limbPre a b z)[5], (limbPre a b z)[6], (limbPre a b z)[7],
      (limbPre a b z)[8], (limbPre a b z)[9], (limbPre a b z)[10], (limbPre a b z)[11],
      (limbPre a b z)[12], (limbPre a b z)[13], (limbPre a b z)[14], (limbPre a b z)[15],
      (limbPre a b z)[16], (limbPre a b z)[17], (limbPre a b z)[18], (limbPre a b z)[19],
      (limbPre a b z)[20], (limbPre a b z)[21], (limbPre a b z)[22], (limbPre a b z)[23],
      PoisonOr.value (wlBytes tv)[24], PoisonOr.value (wlBytes tv)[25],
      PoisonOr.value (wlBytes tv)[26], PoisonOr.value (wlBytes tv)[27],
      PoisonOr.value (wlBytes tv)[28], PoisonOr.value (wlBytes tv)[29],
      PoisonOr.value (wlBytes tv)[30], PoisonOr.value (wlBytes tv)[31]] : ⟦Ty32x8⟧) =
      Ty.wrap (t := .vec 32 8) (wlBytes (wl a b (z.setWidth 64) tv[3])) := by
  have z0 : (z.setWidth 64).extractLsb' 0 8 = z := by bv_decide
  have z1 : (z.setWidth 64).extractLsb' 8 8 = 0#8 := by bv_decide
  have z2 : (z.setWidth 64).extractLsb' 16 8 = 0#8 := by bv_decide
  have z3 : (z.setWidth 64).extractLsb' 24 8 = 0#8 := by bv_decide
  have z4 : (z.setWidth 64).extractLsb' 32 8 = 0#8 := by bv_decide
  have z5 : (z.setWidth 64).extractLsb' 40 8 = 0#8 := by bv_decide
  have z6 : (z.setWidth 64).extractLsb' 48 8 = 0#8 := by bv_decide
  have z7 : (z.setWidth 64).extractLsb' 56 8 = 0#8 := by bv_decide
  simp only [limbPre, wlBytes_eq, wl, Ty.wrap_vec, Vector.map_mk, List.map_toArray, List.map_cons,
    List.map_nil, reduceGetElemLit, z0, z1, z2, z3, z4, z5, z6, z7]

/-- Where the body at `pos` is `limbRun`, `u2` holds `limbPre a b z` and `t` lane `j` of `T`
broadcast: running on from `pos + 2` with the limb `wl a b z T[j]` as bytes in `u4`. -/
theorem runBodyFrom_limbRun (j : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u2 : Dst Γ Ty32x8} {t : Reg Γ Ty4x64} {u3 u4 : Dst Γ Ty32x8} {rest : List (Instr Γ)}
    {a b : BitVec 64} {z : BitVec 8} {T : Wl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = limbRun u2 t u3 u4 ++ rest)
    (hR : E ⊨ [u2 := limbPre a b z, t := wlPermute T j j j j]) (hj : j < 4)
    (hne : u2.i ≠ u3.i)
    (hK :
      (blk.runBodyFrom
            E[u3 := Ty.wrap (wlBytes (wlPermute T j j j j)), u4 :=
              Ty.wrap (wlBytes (wl a b (z.setWidth 64) T[j]))]
            (pos + 2) S >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with v3
  rw [← wlBytes_eq] at hv3
  subst hv3
  step_pure with v4
  rw [limbPre_bytes] at hv4
  have e : (wlPermute T j j j j)[3] = T[j] := by simp [wlPermute, Nat.mod_eq_of_lt hj]
  rw [e] at hv4
  subst hv4
  rw [hE]
  exact hK

/-- A `WF` state with its block counter moved on: the blocks are still below it. -/
@[local mlir_transport]
theorem WF_bump {S : GlobalState} (h : S.WF) (k : Nat) :
    ({ alloc := ⟨S.alloc.nextFreeBlock + k⟩, mem := S.mem } : GlobalState).WF :=
  ⟨fun b hb => Nat.lt_of_lt_of_le (h.bound b hb) (Nat.le_add_right _ _),
    Nat.lt_of_lt_of_le h.pos (Nat.le_add_right _ _), h.null, h.global, h.merged⟩

/-- Five `wl_permute` calls, of `x0 … x4` by the index in `c`, into `r0 … r4`. -/
def permute5Run (c : Dst Γ (.bv 32)) (x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x0.i x0.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons r0 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x1.i x1.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons r1 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x2.i x2.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons r2 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x3.i x3.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons r3 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x4.i x4.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons r4 .nil)]

/-- Where the body at `pos` is `permute5Run`, `c` holds `j` (below 4) and `x0 … x4` hold `X`:
running on from `pos` then `g` gives `K` if it does from `pos + 5` with lane `j` of `X` broadcast
in `r0 … r4`, five blocks on. -/
theorem runBodyFrom_permute5Run (j : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {c : Dst Γ (.bv 32)} {x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)}
    {X : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = permute5Run c x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 ++ rest)
    (hR : E ⊨ [c := laneImm j, x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4])
    (hj : j < 4) (hwf : S.WF)
    (hd : x1.i ≠ r0.i ∧ x2.i ≠ r0.i ∧ x2.i ≠ r1.i ∧ x3.i ≠ r0.i ∧ x3.i ≠ r1.i ∧ x3.i ≠ r2.i ∧
      x4.i ≠ r0.i ∧ x4.i ≠ r1.i ∧ x4.i ≠ r2.i ∧ x4.i ≠ r3.i)
    (hK :
      (blk.runBodyFrom
            E[r0 := Ty.wrap (wlPermute X.P0 j j j j), r1 := Ty.wrap (wlPermute X.P1 j j j j),
              r2 := Ty.wrap (wlPermute X.P2 j j j j), r3 := Ty.wrap (wlPermute X.P3 j j j j),
              r4 := Ty.wrap (wlPermute X.P4 j j j j)]
            (pos + 5) { alloc := ⟨S.alloc.nextFreeBlock + 5⟩, mem := S.mem } >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h10, h20, h21, h30, h31, h32, h40, h41, h42, h43⟩ := hd
  have e := laneImm_toNat hj
  have hi : (laneImm j).toNat < 4 ∧ (laneImm j).toNat < 4 ∧ (laneImm j).toNat < 4 ∧
      (laneImm j).toNat < 4 := by
    simp only [e]
    exact ⟨hj, hj, hj, hj⟩
  step_call using wl_permute.call_eq [e]
  step_call using wl_permute.call_eq [e]
  step_call using wl_permute.call_eq [e]
  step_call using wl_permute.call_eq [e]
  step_call using wl_permute.call_eq [e]
  rw [hE, hS]
  exact hK

/-- Lane `j`'s `(x, y)` pairs: `X`, `Y` permuted to lane `j` (`permute5Run`), each pair
(`pairRun`) with the masks' `z` (`maskRun`). -/
def lanePairRun (c : Dst Γ (.bv 32)) (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Dst Γ Ty4x64) (m0 m1 : Dst Γ Ty32x8)
    (px0 px1 px2 px3 px4 py0 py1 py2 py3 py4 p0 p1 p2 p3 p4 : Dst Γ Ty4x64)
    (b0 b1 b2 b3 b4 l0 l1 l2 l3 l4 : Dst Γ Ty32x8) : List (Instr Γ) :=
  [.call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x0.i x0.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons px0 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x1.i x1.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons px1 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x2.i x2.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons px2 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x3.i x3.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons px3 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val x4.i x4.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons px4 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val y0.i y0.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons py0 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val y1.i y1.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons py1 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val y2.i y2.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons py2 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val y3.i y3.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons py3 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val y4.i y4.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons py4 .nil),
    .binop (.shufflevector #v[some 0, some 5, none, none]) p0 (.val px0.i px0.h) (.val py0.i py0.h),
    .unop (.bitcast (by decide)) b0 (.val p0.i p0.h),
    .binop (.shufflevector #v[some 0, some 5, none, none]) p1 (.val px1.i px1.h) (.val py1.i py1.h),
    .unop (.bitcast (by decide)) b1 (.val p1.i p1.h),
    .binop (.shufflevector #v[some 0, some 5, none, none]) p2 (.val px2.i px2.h) (.val py2.i py2.h),
    .unop (.bitcast (by decide)) b2 (.val p2.i p2.h),
    .binop (.shufflevector #v[some 0, some 5, none, none]) p3 (.val px3.i px3.h) (.val py3.i py3.h),
    .unop (.bitcast (by decide)) b3 (.val p3.i p3.h),
    .binop (.shufflevector #v[some 0, some 5, none, none]) p4 (.val px4.i px4.h) (.val py4.i py4.h),
    .unop (.bitcast (by decide)) b4 (.val p4.i p4.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, none, none, none, none, none, none, none, none]) l0 (.val b0.i b0.h) (.val m1.i m1.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, none, none, none, none, none, none, none, none]) l1 (.val b1.i b1.h) (.val m0.i m0.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, none, none, none, none, none, none, none, none]) l2 (.val b2.i b2.h) (.val m0.i m0.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, none, none, none, none, none, none, none, none]) l3 (.val b3.i b3.h) (.val m0.i m0.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 48, some 49, some 50, some 51, some 52, some 53, some 54, some 55, none, none, none, none, none, none, none, none]) l4 (.val b4.i b4.h) (.val m0.i m0.h)]

/-- Lane `j`'s limbs as bytes: `T` permuted to lane `j` (`permute5Run`), then each pair with
`T`'s lane (`limbRun`). -/
def laneLimbRun (c : Dst Γ (.bv 32)) (t0 t1 t2 t3 t4 : Dst Γ Ty4x64) (l0 l1 l2 l3 l4 : Dst Γ Ty32x8)
    (pt0 pt1 pt2 pt3 pt4 : Dst Γ Ty4x64) (tb0 tb1 tb2 tb3 tb4 u0 u1 u2 u3 u4 : Dst Γ Ty32x8) :
    List (Instr Γ) :=
  [.call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val t0.i t0.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons pt0 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val t1.i t1.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons pt1 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val t2.i t2.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons pt2 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val t3.i t3.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons pt3 .nil),
    .call MLIR.Firedancer.Crc.Verify.wl_permute.call
      (.cons (.val t4.i t4.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) (.cons (.val c.i c.h) .nil)))))
      (.cons pt4 .nil),
    .unop (.bitcast (by decide)) tb0 (.val pt0.i pt0.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 16, some 17, some 18, some 19, some 20, some 21, some 22, some 23, some 56, some 57, some 58, some 59, some 60, some 61, some 62, some 63]) u0 (.val l0.i l0.h) (.val tb0.i tb0.h),
    .unop (.bitcast (by decide)) tb1 (.val pt1.i pt1.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 16, some 17, some 18, some 19, some 20, some 21, some 22, some 23, some 56, some 57, some 58, some 59, some 60, some 61, some 62, some 63]) u1 (.val l1.i l1.h) (.val tb1.i tb1.h),
    .unop (.bitcast (by decide)) tb2 (.val pt2.i pt2.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 16, some 17, some 18, some 19, some 20, some 21, some 22, some 23, some 56, some 57, some 58, some 59, some 60, some 61, some 62, some 63]) u2 (.val l2.i l2.h) (.val tb2.i tb2.h),
    .unop (.bitcast (by decide)) tb3 (.val pt3.i pt3.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 16, some 17, some 18, some 19, some 20, some 21, some 22, some 23, some 56, some 57, some 58, some 59, some 60, some 61, some 62, some 63]) u3 (.val l3.i l3.h) (.val tb3.i tb3.h),
    .unop (.bitcast (by decide)) tb4 (.val pt4.i pt4.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14, some 15, some 16, some 17, some 18, some 19, some 20, some 21, some 22, some 23, some 56, some 57, some 58, some 59, some 60, some 61, some 62, some 63]) u4 (.val l4.i l4.h) (.val tb4.i tb4.h)]

/-- Where the body at `pos` is `lanePairRun`, `c` holds `j` (below 4), `x…`, `y…` hold `X`, `Y`
and `m1`, `m0` the masks of `1`, `0`: running on from `pos` then `g` gives `K` if it does from
`pos + 25` with lane `j`'s pairs and their `z` in `l0 … l4`, ten blocks on. -/
theorem runBodyFrom_lanePairRun (j : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {c : Dst Γ (.bv 32)} {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Dst Γ Ty4x64} {m0 m1 : Dst Γ Ty32x8}
    {px0 px1 px2 px3 px4 py0 py1 py2 py3 py4 p0 p1 p2 p3 p4 : Dst Γ Ty4x64}
    {b0 b1 b2 b3 b4 l0 l1 l2 l3 l4 : Dst Γ Ty32x8} {rest : List (Instr Γ)} {X Y : Quad5}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = lanePairRun c x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 m0 m1 px0 px1 px2 px3 px4 py0 py1 py2 py3 py4 p0 p1 p2 p3 p4 b0 b1 b2 b3 b4 l0 l1 l2 l3 l4 ++ rest)
    (hR :
      E ⊨ [c := laneImm j, x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, y0 := Y.P0, y1 := Y.P1, y2 := Y.P2, y3 := Y.P3, y4 := Y.P4, m1 := maskBytes 1#8, m0 := maskBytes 0#8])
    (hj : j < 4) (hwf : S.WF)
    (hd :
      [c.i, x0.i, x1.i, x2.i, x3.i, x4.i, y0.i, y1.i, y2.i, y3.i, y4.i, m0.i, m1.i, px0.i, px1.i, px2.i, px3.i, px4.i, py0.i, py1.i, py2.i, py3.i, py4.i, p0.i, p1.i, p2.i, p3.i, p4.i, b0.i, b1.i, b2.i, b3.i, b4.i, l0.i, l1.i, l2.i, l3.i, l4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[px0 := Ty.wrap (wlPermute X.P0 j j j j),
              px1 := Ty.wrap (wlPermute X.P1 j j j j),
              px2 := Ty.wrap (wlPermute X.P2 j j j j),
              px3 := Ty.wrap (wlPermute X.P3 j j j j),
              px4 := Ty.wrap (wlPermute X.P4 j j j j),
              py0 := Ty.wrap (wlPermute Y.P0 j j j j),
              py1 := Ty.wrap (wlPermute Y.P1 j j j j),
              py2 := Ty.wrap (wlPermute Y.P2 j j j j),
              py3 := Ty.wrap (wlPermute Y.P3 j j j j),
              py4 := Ty.wrap (wlPermute Y.P4 j j j j),
              p0 := pairLanes X.P0[j] Y.P0[j],
              b0 := pairBytes X.P0[j] Y.P0[j],
              p1 := pairLanes X.P1[j] Y.P1[j],
              b1 := pairBytes X.P1[j] Y.P1[j],
              p2 := pairLanes X.P2[j] Y.P2[j],
              b2 := pairBytes X.P2[j] Y.P2[j],
              p3 := pairLanes X.P3[j] Y.P3[j],
              b3 := pairBytes X.P3[j] Y.P3[j],
              p4 := pairLanes X.P4[j] Y.P4[j],
              b4 := pairBytes X.P4[j] Y.P4[j],
              l0 := limbPre X.P0[j] Y.P0[j] 1#8,
              l1 := limbPre X.P1[j] Y.P1[j] 0#8,
              l2 := limbPre X.P2[j] Y.P2[j] 0#8,
              l3 := limbPre X.P3[j] Y.P3[j] 0#8,
              l4 := limbPre X.P4[j] Y.P4[j] 0#8]
            (pos + 25)
            { alloc := ⟨S.alloc.nextFreeBlock + 10⟩, mem := S.mem } >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pattern' using runBodyFrom_permute5Run j inline
  step_pattern' using runBodyFrom_permute5Run j inline
  step_pattern' using runBodyFrom_pairRun j inline
  step_pattern' using runBodyFrom_pairRun j inline
  step_pattern' using runBodyFrom_pairRun j inline
  step_pattern' using runBodyFrom_pairRun j inline
  step_pattern' using runBodyFrom_pairRun j inline
  step_pattern' using runBodyFrom_maskRun inline
  step_pattern' using runBodyFrom_maskRun inline
  step_pattern' using runBodyFrom_maskRun inline
  step_pattern' using runBodyFrom_maskRun inline
  step_pattern' using runBodyFrom_maskRun inline
  rw [hE, hS]
  exact hK

/-- Where the body at `pos` is `laneLimbRun`, `c` holds `j` (below 4), `t…` hold `T` and `l…`
lane `j`'s pairs with their `z`: running on from `pos` then `g` gives `K` if it does from
`pos + 15` with lane `j` of the point `(X, Y, 1, T)` as bytes in `u0 … u4`, five blocks on. -/
theorem runBodyFrom_laneLimbRun (j : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {c : Dst Γ (.bv 32)} {t0 t1 t2 t3 t4 : Dst Γ Ty4x64} {l0 l1 l2 l3 l4 : Dst Γ Ty32x8}
    {pt0 pt1 pt2 pt3 pt4 : Dst Γ Ty4x64} {tb0 tb1 tb2 tb3 tb4 u0 u1 u2 u3 u4 : Dst Γ Ty32x8}
    {rest : List (Instr Γ)} {X Y T : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = laneLimbRun c t0 t1 t2 t3 t4 l0 l1 l2 l3 l4 pt0 pt1 pt2 pt3 pt4 tb0 tb1 tb2 tb3 tb4 u0 u1 u2 u3 u4 ++ rest) (hj : j < 4)
    (hR :
      E ⊨ [c := laneImm j, t0 := T.P0, t1 := T.P1, t2 := T.P2, t3 := T.P3, t4 := T.P4, l0 := limbPre X.P0[j] Y.P0[j] 1#8, l1 := limbPre X.P1[j] Y.P1[j] 0#8, l2 := limbPre X.P2[j] Y.P2[j] 0#8, l3 := limbPre X.P3[j] Y.P3[j] 0#8, l4 := limbPre X.P4[j] Y.P4[j] 0#8])
    (hwf : S.WF)
    (hd : [c.i, t0.i, t1.i, t2.i, t3.i, t4.i, l0.i, l1.i, l2.i, l3.i, l4.i, pt0.i, pt1.i, pt2.i, pt3.i, pt4.i, tb0.i, tb1.i, tb2.i, tb3.i, tb4.i, u0.i, u1.i, u2.i, u3.i, u4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[pt0 := Ty.wrap (wlPermute T.P0 j j j j),
              pt1 := Ty.wrap (wlPermute T.P1 j j j j),
              pt2 := Ty.wrap (wlPermute T.P2 j j j j),
              pt3 := Ty.wrap (wlPermute T.P3 j j j j),
              pt4 := Ty.wrap (wlPermute T.P4 j j j j),
              tb0 := Ty.wrap (wlBytes (wlPermute T.P0 j j j j)),
              u0 := Ty.wrap (wlBytes (wl X.P0[j] Y.P0[j] ((1#8).setWidth 64) T.P0[j])),
              tb1 := Ty.wrap (wlBytes (wlPermute T.P1 j j j j)),
              u1 := Ty.wrap (wlBytes (wl X.P1[j] Y.P1[j] ((0#8).setWidth 64) T.P1[j])),
              tb2 := Ty.wrap (wlBytes (wlPermute T.P2 j j j j)),
              u2 := Ty.wrap (wlBytes (wl X.P2[j] Y.P2[j] ((0#8).setWidth 64) T.P2[j])),
              tb3 := Ty.wrap (wlBytes (wlPermute T.P3 j j j j)),
              u3 := Ty.wrap (wlBytes (wl X.P3[j] Y.P3[j] ((0#8).setWidth 64) T.P3[j])),
              tb4 := Ty.wrap (wlBytes (wlPermute T.P4 j j j j)),
              u4 := Ty.wrap (wlBytes (wl X.P4[j] Y.P4[j] ((0#8).setWidth 64) T.P4[j]))]
            (pos + 15)
            { alloc := ⟨S.alloc.nextFreeBlock + 5⟩, mem := S.mem } >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pattern' using runBodyFrom_permute5Run j inline
  step_pattern' using runBodyFrom_limbRun j inline
  step_pattern' using runBodyFrom_limbRun j inline
  step_pattern' using runBodyFrom_limbRun j inline
  step_pattern' using runBodyFrom_limbRun j inline
  step_pattern' using runBodyFrom_limbRun j inline
  rw [hE, hS]
  exact hK





/-- `pblendvb` of `xb`, `yb` by the mask `m` into `q`, its bytes back as a `wl_t` into `r`. -/
def blendBackRun (xb yb m : Reg Γ Ty32x8) (q : Dst Γ Ty32x8) (r : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.ternop .pblendvb q xb yb m, .unop (.bitcast (by decide)) r (.val q.i q.h)]

/-- Where the body at `pos` is `blendBackRun`, `xb`, `yb` hold the bytes of `Y`, `X` and `m` those
of `fixMask c0 c1`: running on from `pos` then `g` gives `K` if it does from `pos + 2` with lanes
`0`, `1` of `X` where `c0`, `c1` are `1`, else `Y`'s, in `r` and its bytes in `q`. -/
theorem runBodyFrom_blendBackRun {c0 c1 : BitVec 32} (h0 : c0 = 0 ∨ c0 = 1)
    (h1 : c1 = 0 ∨ c1 = 1) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {xb yb m : Reg Γ Ty32x8} {q : Dst Γ Ty32x8} {r : Dst Γ Ty4x64} {rest : List (Instr Γ)}
    {X Y : Wl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = blendBackRun xb yb m q r ++ rest)
    (hR : E ⊨ [xb := wlBytes Y, yb := wlBytes X, m := wlBytes (fixMask c0 c1)])
    (hK :
      (blk.runBodyFrom
            E[q := Ty.wrap (wlBytes (wlBlend (c0 == 1#32) (c1 == 1#32) false false X Y)), r :=
              Ty.wrap (wlBlend (c0 == 1#32) (c1 == 1#32) false false X Y)]
            (pos + 2) S >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [pblendvb_fixMask h0 h1]
  step_pure with xr
  rw [wlBytes_concat] at hxr
  subst hxr
  rw [hE]
  exact hK

/-- `x`'s bytes into `xb`, then `blendBackRun` of `xb`, `yb` by `m`. -/
def blendBytesRun (x : Reg Γ Ty4x64) (xb : Dst Γ Ty32x8) (yb m : Reg Γ Ty32x8) (q : Dst Γ Ty32x8)
    (r : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.unop (.bitcast (by decide)) xb x, .ternop .pblendvb q (.val xb.i xb.h) yb m,
    .unop (.bitcast (by decide)) r (.val q.i q.h)]

/-- `runBodyFrom_blendBackRun` for `blendBytesRun`, `x` holding `Y`. -/
theorem runBodyFrom_blendBytesRun {c0 c1 : BitVec 32} (h0 : c0 = 0 ∨ c0 = 1)
    (h1 : c1 = 0 ∨ c1 = 1) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x : Reg Γ Ty4x64} {xb : Dst Γ Ty32x8} {yb m : Reg Γ Ty32x8} {q : Dst Γ Ty32x8}
    {r : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X Y : Wl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = blendBytesRun x xb yb m q r ++ rest)
    (hR : E ⊨ [x := Y, yb := wlBytes X, m := wlBytes (fixMask c0 c1)])
    (hne : yb ≠ .val xb.i xb.h ∧ m ≠ .val xb.i xb.h)
    (hK :
      (blk.runBodyFrom
            E[xb := Ty.wrap (wlBytes Y), q :=
              Ty.wrap (wlBytes (wlBlend (c0 == 1#32) (c1 == 1#32) false false X Y)), r :=
              Ty.wrap (wlBlend (c0 == 1#32) (c1 == 1#32) false false X Y)]
            (pos + 3) S >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hne1, hne2⟩ := hne
  step_pure with xb'
  rw [← wlBytes_eq] at hxb'
  subst hxb'
  step_pure [pblendvb_fixMask h0 h1]
  step_pure with xr
  rw [wlBytes_concat] at hxr
  subst hxr
  rw [hE]
  exact hK

/-- `^bb14`'s flip mask from the lanes' canonical limbs `w0`, `w1` and the encodings' last bytes
`a`, `b`: each lane's parity against the sign bit as `0` / `-1`, spread to `fixMask`'s bytes. -/
def flipMaskRun (w0 w1 : Dst Γ (.bv 64)) (a b : Dst Γ (.bv 8)) (p32 : Dst Γ (.vec 2 32))
    (k0 k1 : Dst Γ (.bv 64)) (one : Dst Γ (.vec 2 32)) (p8 : Dst Γ (.vec 2 8))
    (seven : Dst Γ (.vec 2 8)) (m8 : Dst Γ (.vec 8 32))
    (t0 : Dst Γ (.bv 32)) (i0 : Dst Γ (.vec 2 32)) (t1 : Dst Γ (.bv 32)) (i1 : Dst Γ (.vec 2 32))
    (an : Dst Γ (.vec 2 32)) (j0 : Dst Γ (.vec 2 8)) (j1 : Dst Γ (.vec 2 8)) (sh : Dst Γ (.vec 2 8))
    (zx : Dst Γ (.vec 2 32)) (ne : Dst Γ (.vec 2 1)) (s0 : Dst Γ (.vec 2 32))
    (u0 u1 : Dst Γ (.vec 8 32)) (s1 : Dst Γ (.vec 2 32)) (u2 u3 u4 : Dst Γ (.vec 8 32))
    (mb : Dst Γ Ty32x8) : List (Instr Γ) :=
  [.unop (.trunc {}) t0 (.val w0.i w0.h),
    .ternop .insertelement i0 (.val p32.i p32.h) (.val t0.i t0.h) (.val k0.i k0.h),
    .unop (.trunc {}) t1 (.val w1.i w1.h),
    .ternop .insertelement i1 (.val i0.i i0.h) (.val t1.i t1.h) (.val k1.i k1.h),
    .binop (.vector .and) an (.val i1.i i1.h) (.val one.i one.h),
    .ternop .insertelement j0 (.val p8.i p8.h) (.val a.i a.h) (.val k0.i k0.h),
    .ternop .insertelement j1 (.val j0.i j0.h) (.val b.i b.h) (.val k1.i k1.h),
    .binop (.vector (.lshr false)) sh (.val j1.i j1.h) (.val seven.i seven.h),
    .unop (.vector (.zext true)) zx (.val sh.i sh.h),
    .binop (.vector (.icmp .ne)) ne (.val an.i an.h) (.val zx.i zx.h),
    .unop (.vector .sext) s0 (.val ne.i ne.h),
    .binop (.shufflevector #v[some 0, some 1, none, none, none, none, none, none]) u0 (.val s0.i s0.h)
      (.val p32.i p32.h),
    .binop (.shufflevector #v[some 0, none, none, none, some 12, some 13, some 14, some 15]) u1
      (.val u0.i u0.h) (.val m8.i m8.h),
    .unop (.vector .sext) s1 (.val ne.i ne.h),
    .binop (.shufflevector #v[some 0, some 1, none, none, none, none, none, none]) u2 (.val s1.i s1.h)
      (.val p32.i p32.h),
    .binop (.shufflevector #v[some 0, some 8, some 9, none, some 4, some 5, some 6, some 7]) u3
      (.val u1.i u1.h) (.val u2.i u2.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 9, some 4, some 5, some 6, some 7]) u4
      (.val u3.i u3.h) (.val u0.i u0.h),
    .unop (.bitcast (by decide)) mb (.val u4.i u4.h)]

/-- A lane's flip bit: `1` where `x`'s parity is not the encoding's sign bit. -/
abbrev flipBit (w : BitVec 64) (e : BitVec 8) : BitVec 32 :=
  if BitVec.setWidth 32 w &&& 1#32 = BitVec.setWidth 32 e >>> 7 then 0#32 else 1#32

/-- A sign byte shifted right by `7` has a clear top bit. -/
theorem msb_shr7 (e : BitVec 8) : (e >>> 7).msb = false := by bv_decide

/-- A two-lane vector built by `insertelement`s, as a literal. -/
theorem set2 {α : Type} (p : α) (a b : α) (h0 h1) :
    ((Vector.replicate 2 p).set 0 a h0).set 1 b h1 = #v[a, b] := by
  ext i hi
  match i, hi with
  | 0, _ => rfl
  | 1, _ => rfl

set_option maxHeartbeats 1000000 in
/-- Where the body at `pos` is `flipMaskRun`: running on from `pos + 18` with the bytes of
`fixMask (flipBit x0 e0) (flipBit x1 e1)` in `mb`, whatever the intermediates. -/
theorem runBodyFrom_flipMaskRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {w0 w1 : Dst Γ (.bv 64)} {a b : Dst Γ (.bv 8)} {p32 : Dst Γ (.vec 2 32)} {k0 k1 : Dst Γ (.bv 64)}
    {one : Dst Γ (.vec 2 32)} {p8 : Dst Γ (.vec 2 8)} {seven : Dst Γ (.vec 2 8)}
    {m8 : Dst Γ (.vec 8 32)} {t0 : Dst Γ (.bv 32)} {i0 : Dst Γ (.vec 2 32)} {t1 : Dst Γ (.bv 32)}
    {i1 : Dst Γ (.vec 2 32)} {an : Dst Γ (.vec 2 32)} {j0 j1 sh : Dst Γ (.vec 2 8)}
    {zx : Dst Γ (.vec 2 32)} {ne : Dst Γ (.vec 2 1)} {s0 : Dst Γ (.vec 2 32)}
    {u0 u1 : Dst Γ (.vec 8 32)} {s1 : Dst Γ (.vec 2 32)} {u2 u3 u4 : Dst Γ (.vec 8 32)}
    {mb : Dst Γ Ty32x8} {rest : List (Instr Γ)} {x0 x1 : BitVec 64} {e0 e1 : BitVec 8}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos =
      flipMaskRun w0 w1 a b p32 k0 k1 one p8 seven m8 t0 i0 t1 i1 an j0 j1 sh zx ne s0 u0 u1 s1 u2 u3
        u4 mb ++ rest)
    (hR : E ⊨ [.val w0.i w0.h := x0, .val w1.i w1.h := x1, .val a.i a.h := e0, .val b.i b.h := e1,
      .val p32.i p32.h := Vector.replicate 2 PoisonOr.poison, .val k0.i k0.h := 0#64,
      .val k1.i k1.h := 1#64, .val one.i one.h := Ty.wrap (t := .vec 2 32) (Vector.replicate 2 1#32),
      .val p8.i p8.h := Vector.replicate 2 PoisonOr.poison,
      .val seven.i seven.h := Ty.wrap (t := .vec 2 8) (Vector.replicate 2 7#8),
      .val m8.i m8.h := m8Undef])
    (hd : [w0.i, w1.i, a.i, b.i, p32.i, k0.i, k1.i, one.i, p8.i, seven.i, m8.i, t0.i, i0.i, t1.i,
      i1.i, an.i, j0.i, j1.i, sh.i, zx.i, ne.i, s0.i, u0.i, u1.i, s1.i, u2.i, u3.i, u4.i, mb.i].Nodup)
    (hK : ∀ (v0 : ⟦.bv 32⟧) (v1 : ⟦.vec 2 32⟧) (v2 : ⟦.bv 32⟧) (v3 v4 : ⟦.vec 2 32⟧)
      (v5 v6 v7 : ⟦.vec 2 8⟧) (v8 : ⟦.vec 2 32⟧) (v9 : ⟦.vec 2 1⟧) (v10 : ⟦.vec 2 32⟧)
      (v11 v12 : ⟦.vec 8 32⟧) (v13 : ⟦.vec 2 32⟧) (v14 v15 v16 : ⟦.vec 8 32⟧),
      (blk.runBodyFrom
          E[t0 := v0, i0 := v1, t1 := v2, i1 := v3, an := v4, j0 := v5, j1 := v6, sh := v7, zx := v8,
            ne := v9, s0 := v10, u0 := v11, u1 := v12, s1 := v13, u2 := v14, u3 := v15, u4 := v16,
            mb := Ty.wrap (wlBytes (fixMask (flipBit x0 e0) (flipBit x1 e1)))]
          (pos + 18) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  iterate 11 step_pure named
  iterate 6 step_pure named
  have h4 : vu4 = Ty.wrap (t := .vec 8 32)
      #v[-flipBit x0 e0, -flipBit x0 e0, -flipBit x1 e1, -flipBit x1 e1, 0#32, 0#32, 0#32, 0#32] := by
    subst hvu4 hvu3 hvu2 hvs1 hvu1 hvu0 hvs0 hvne hvzx hvsh hvj1 hvj0 hvan hvi1 hvt1 hvi0 hvt0
    simp only [flipBit, set2, Vector.getElem_ofFn, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, PoisonOr.value_bind, msb_shr7,
      Bool.false_eq_true, ite_false, signExtend_ofBool, Ty.wrap_vec, bne_iff_ne, ne_eq,
      setWidth_shr7, ite_not, Vector.map_mk, List.map_toArray, List.map_cons, List.map_nil]
  step_pure [h4, fixMask_bytes]
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

set_option maxHeartbeats 4000000 in
/-- `^bb14`'s sites `0` to `36`: `x` times `√-1` in the lanes whose `v x² = -u`. -/
theorem bb14a_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} (X : Quad5) (c0 c1 : BitVec 32)
    (hc0 : c0 = 0 ∨ c0 = 1) (hc1 : c1 = 0 ∨ c1 = 1)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 732 := X.P0, rir_reg% hty 733 := X.P1, rir_reg% hty 734 := X.P2,
      rir_reg% hty 735 := X.P3, rir_reg% hty 736 := X.P4,
      rir_reg% hty 769 := (0 : BitVec 32) - c0, rir_reg% hty 775 := (0 : BitVec 32) - c1,
      rir_reg% hty 369 := B.slot 230, rir_reg% hty 370 := B.slot 231,
      rir_reg% hty 371 := B.slot 232, rir_reg% hty 372 := B.slot 233,
      rir_reg% hty 373 := B.slot 234,
      rir_reg% hty 43 := (Vector.replicate 4 1718705420411056#64 : Wl),
      rir_reg% hty 42 := (Vector.replicate 4 234908883556509#64 : Wl),
      rir_reg% hty 41 := (Vector.replicate 4 2233514472574048#64 : Wl),
      rir_reg% hty 40 := (Vector.replicate 4 2117202627021982#64 : Wl),
      rir_reg% hty 39 := (Vector.replicate 4 765476049583133#64 : Wl),
      rir_reg% hty 74 := m8Undef, rir_reg% hty 59 := 0#64, rir_reg% hty 55 := 1#64,
      rir_reg% hty 32 := 2#64, rir_reg% hty 31 := 3#64])
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 777 802 →
      (E' ⊨ [rir_reg% hty 789 := (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P0,
        rir_reg% hty 792 := (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P1,
        rir_reg% hty 795 := (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P2,
        rir_reg% hty 798 := (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P3,
        rir_reg% hty 801 := (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P4,
        rir_reg% hty 788 := wlBytes (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P0,
        rir_reg% hty 791 := wlBytes (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P1,
        rir_reg% hty 794 := wlBytes (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P2,
        rir_reg% hty 797 := wlBytes (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P3,
        rir_reg% hty 800 := wlBytes (blend2Q (c0 == 1) (c1 == 1) (mulQ X sqrtm1Q) X).P4]) →
      Inv B M c S' → (bb14.runBodyFrom E' 36 S' >>= g) = K) :
    (bb14.runBodyFrom Ein 0 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  have hSF : SlotFrame B 246 S.mem := fun j hj =>
    ⟨(hF j hj).1.mono (by unfold slotBytes; split_ifs <;> decide), (hF j hj).2⟩
  step_pattern' using runBodyFrom_leafRun2B (hf := fd_r52x5_quad_mul.call_eq) (Y := sqrtm1Q) with Q0
  subst hQ0
  clear hSF
  iterate 4 step_pure
  step_pure with xb
  rw [← wlBytes_eq] at hxb
  subst hxb
  step_pure [fixMask_bytes]
  step_pattern' using runBodyFrom_blendBackRun hc0 hc1 inline
  step_pattern' using runBodyFrom_blendBytesRun hc0 hc1 inline
  step_pattern' using runBodyFrom_blendBytesRun hc0 hc1 inline
  step_pattern' using runBodyFrom_blendBytesRun hc0 hc1 inline
  step_pattern' using runBodyFrom_blendBytesRun hc0 hc1 inline
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩
  · rw [hE]
    writes_chain
  · lemma_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot]
    exact herase
  · rw [hS]
    exact halloc

set_option maxHeartbeats 4000000 in
/-- `^bb14`'s sites `36` to `92`: `x` negated in the lanes whose canonical sign is not the
encoding's. -/
theorem bb14b_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} (X : Quad5) (sA sB : BitVec 256)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 789 := X.P0, rir_reg% hty 792 := X.P1, rir_reg% hty 795 := X.P2,
      rir_reg% hty 798 := X.P3, rir_reg% hty 801 := X.P4,
      rir_reg% hty 788 := wlBytes X.P0, rir_reg% hty 791 := wlBytes X.P1,
      rir_reg% hty 794 := wlBytes X.P2, rir_reg% hty 797 := wlBytes X.P3,
      rir_reg% hty 800 := wlBytes X.P4,
      rir_reg% hty 374 := B.slot 235, rir_reg% hty 375 := B.slot 236,
      rir_reg% hty 376 := B.slot 237, rir_reg% hty 377 := B.slot 238,
      rir_reg% hty 378 := B.slot 239, rir_reg% hty 379 := B.slot 240,
      rir_reg% hty 62 := 0#32, rir_reg% hty 58 := 1#32,
      rir_reg% hty 30 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 29 := Ty.wrap (t := .vec 2 32) (Vector.replicate 2 1#32),
      rir_reg% hty 28 := Vector.replicate 2 PoisonOr.poison,
      rir_reg% hty 27 := Ty.wrap (t := .vec 2 8) (Vector.replicate 2 7#8),
      rir_reg% hty 74 := m8Undef, rir_reg% hty 59 := 0#64, rir_reg% hty 55 := 1#64])
    (hsa : Fits S.mem ea 256) (hsb : Fits S.mem eb 256)
    (hsA : S.mem.readAt ea 256 = sA) (hsB : S.mem.readAt eb 256 = sB)
    (hsa_off : ea.offset.toNat + 32 < 2 ^ 64) (hsb_off : eb.offset.toNat + 32 < 2 ^ 64)
    (hsa_lt : ea.id.id < B.alloc.nextFreeBlock) (hsb_lt : eb.id.id < B.alloc.nextFreeBlock)
    (hI : Inv B M c S)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 802 841 →
      (E' ⊨ [rir_reg% hty 832 := (blend2Q (flip X 0 sA) (flip X 1 sB) (fd_r52x5_quad_neg.spec X) X).P0,
        rir_reg% hty 834 := (blend2Q (flip X 0 sA) (flip X 1 sB) (fd_r52x5_quad_neg.spec X) X).P1,
        rir_reg% hty 836 := (blend2Q (flip X 0 sA) (flip X 1 sB) (fd_r52x5_quad_neg.spec X) X).P2,
        rir_reg% hty 838 := (blend2Q (flip X 0 sA) (flip X 1 sB) (fd_r52x5_quad_neg.spec X) X).P3,
        rir_reg% hty 840 := (blend2Q (flip X 0 sA) (flip X 1 sB) (fd_r52x5_quad_neg.spec X) X).P4]) →
      Inv B M (c + 12) S' → (bb14.runBodyFrom E' 92 S' >>= g) = K) :
    (bb14.runBodyFrom Ein 36 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  have hov (k : Nat) (hk : k ≤ 32) (p : Pointer) (hp : p.offset.toNat + 32 < 2 ^ 64) :
      ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
  have fa : Fits S.mem (ea.add 31#64) 8 := Fits.add_of_le (hov 31 (by omega) ea hsa_off) (by decide) hsa
  have fb : Fits S.mem (eb.add 31#64) 8 := Fits.add_of_le (hov 31 (by omega) eb hsb_off) (by decide) hsb
  have ra : S.mem.readAt (ea.add 31#64) 8 = sA.extractLsb' 248 8 :=
    MemoryState.readAt_add_of_readAt hsa.inBounds (hov 31 (by omega) ea hsa_off) (by decide) hsA
  have rb : S.mem.readAt (eb.add 31#64) 8 = sB.extractLsb' 248 8 :=
    MemoryState.readAt_add_of_readAt hsb.inBounds (hov 31 (by omega) eb hsb_off) (by decide) hsB
  clear hsa hsb hsA hsB
  obtain ⟨ba, hba⟩ : ∃ x, sA.extractLsb' 248 8 = x := ⟨_, rfl⟩
  obtain ⟨bb, hbb⟩ : ∃ x, sB.extractLsb' 248 8 = x := ⟨_, rfl⟩
  rw [hba] at ra
  rw [hbb] at rb
  have hla : (ea.add 31#64).id.id < B.alloc.nextFreeBlock := by simpa [Pointer.add] using hsa_lt
  have hlb : (eb.add 31#64).id.id < B.alloc.nextFreeBlock := by simpa [Pointer.add] using hsb_lt
  have na240 := (ne_slot (j := 240) hla).symm
  have nb240 := (ne_slot (j := 240) hlb).symm
  have hSF : SlotFrame B 246 S.mem := fun j hj =>
    ⟨(hF j hj).1.mono (by unfold slotBytes; split_ifs <;> decide), (hF j hj).2⟩
  step_pattern' using runBodyFrom_leafRun1B (hf := fd_r52x5_quad_neg.call_eq) with Q0
  subst hQ0
  clear hSF
  obtain ⟨i0, w0⟩ := hF.limbs 240
  step_pure
  have r0 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 240) 320› rfl
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := X) (hl := by decide)) consuming r0
  have l0 : S.mem.readAt (B.slot 240) 64 = fd_r52x5_quad_lane_canon.spec X 0 0 := by
    rw [← ‹S.mem.readLimbs (B.slot 240) = fd_r52x5_quad_lane_canon.spec X 0›]; rfl
  step_load
  step_pure
  step_load
  clear l0 ra fa
  step_pure
  step_pure
  obtain ⟨i0, w0⟩ := hF.limbs 240
  have r1 := MemoryState.LimbsRoom.of_room ‹Room S.mem (B.slot 240) 320› rfl
  step_call using (fd_r52x5_quad_lane_canon.call_eq (X := X) (hl := by decide)) consuming r1
  have l1 : S.mem.readAt (B.slot 240) 64 = fd_r52x5_quad_lane_canon.spec X 1 0 := by
    rw [← ‹S.mem.readLimbs (B.slot 240) = fd_r52x5_quad_lane_canon.spec X 1›]; rfl
  step_load
  step_pure
  step_load
  clear l1 rb fb
  step_pure
  step_pattern' using runBodyFrom_flipMaskRun inline
  rw [hv807, hv810] at hE
  generalize hf0 : flipBit (fd_r52x5_quad_lane_canon.spec X 0 0) ba = f0 at hE
  generalize hf1 : flipBit (fd_r52x5_quad_lane_canon.spec X 1 0) bb = f1 at hE
  have hf0' : f0 = 0 ∨ f0 = 1 := by rw [← hf0, flipBit]; split <;> simp
  have hf1' : f1 = 0 ∨ f1 = 1 := by rw [← hf1, flipBit]; split <;> simp
  step_pattern' using runBodyFrom_blendBackRun hf0' hf1' inline
  step_pattern' using runBodyFrom_blendBackRun hf0' hf1' inline
  step_pattern' using runBodyFrom_blendBackRun hf0' hf1' inline
  step_pattern' using runBodyFrom_blendBackRun hf0' hf1' inline
  step_pattern' using runBodyFrom_blendBackRun hf0' hf1' inline
  have e0 : (f0 == 1#32) = flip X 0 sA := by rw [← hf0, ← hba]; exact flip_eq X 0 sA
  have e1 : (f1 == 1#32) = flip X 1 sB := by rw [← hf1, ← hbb]; exact flip_eq X 1 sB
  rw [e0, e1] at hE
  refine hK E S hArgs ?_ ?_ ⟨hwf, hF, ?_, ?_⟩
  · rw [hE]
    writes_chain
  · lemma_reads
  · rw [hS]
    simp (disch := decide) only [eraseFrom_callTmp5_slot, eraseFrom_storeLimbs_slot,
      eraseFrom_lifetimeStart_slot, eraseFrom_lifetimeEnd_slot]
    exact herase
  · rw [hS]
    simp only
    omega

set_option maxHeartbeats 16000000 in
/-- `^bb14`'s sites `92` to `206`: `T = x y`, both points `(x, y, 1, T)` assembled lane by lane
and stored at `a` and `b`. -/
theorem bb14c_run {β : Type} {Ein : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {B : GlobalState}
    {M : MemoryState} {c : Nat} {a ea b eb : Pointer} (X Y : Quad5)
    (hArgs : Ein.args = (argsOf a ea b eb).get)
    (hR : Ein ⊨ [rir_reg% hty 832 := X.P0, rir_reg% hty 834 := X.P1, rir_reg% hty 836 := X.P2,
      rir_reg% hty 838 := X.P3, rir_reg% hty 840 := X.P4,
      rir_reg% hty 388 := Y.P0, rir_reg% hty 394 := Y.P1, rir_reg% hty 400 := Y.P2,
      rir_reg% hty 406 := Y.P3, rir_reg% hty 412 := Y.P4,
      rir_reg% hty 380 := B.slot 241, rir_reg% hty 381 := B.slot 242,
      rir_reg% hty 382 := B.slot 243, rir_reg% hty 383 := B.slot 244,
      rir_reg% hty 384 := B.slot 245,
      rir_reg% hty 62 := 0#32, rir_reg% hty 58 := 1#32,
      rir_reg% hty 106 := mask1Bytes, rir_reg% hty 138 := mask0Bytes])
    (hI : Inv B M c S) (ha : S.mem.Quad5Room a) (hb : S.mem.Quad5Room b)
    (ha_lt : a.id.id < B.alloc.nextFreeBlock) (hb_lt : b.id.id < B.alloc.nextFreeBlock)
    (hK : ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = (argsOf a ea b eb).get →
      Writes Ein E' 841 934 →
      S'.alloc.nextFreeBlock = B.alloc.nextFreeBlock + 246 + (c + 30) →
      S'.mem.eraseFrom B.alloc.nextFreeBlock =
        (M.storeQuad5 a ⟨wl X.P0[0] Y.P0[0] ((1#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P0[0], wl X.P1[0] Y.P1[0] ((0#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P1[0], wl X.P2[0] Y.P2[0] ((0#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P2[0], wl X.P3[0] Y.P3[0] ((0#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P3[0], wl X.P4[0] Y.P4[0] ((0#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P4[0]⟩).storeQuad5 b ⟨wl X.P0[1] Y.P0[1] ((1#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P0[1], wl X.P1[1] Y.P1[1] ((0#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P1[1], wl X.P2[1] Y.P2[1] ((0#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P2[1], wl X.P3[1] Y.P3[1] ((0#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P3[1], wl X.P4[1] Y.P4[1] ((0#8).setWidth 64) (fd_r52x5_quad_mul.spec X Y).P4[1]⟩ →
      S'.WF → Frame B S'.mem → (bb14.runBodyFrom E' 206 S' >>= g) = K) :
    (bb14.runBodyFrom Ein 92 S >>= g) = K := by
  obtain ⟨hwf, hF, herase, halloc⟩ := hI
  have hSF : SlotFrame B 246 S.mem := fun j hj =>
    ⟨(hF j hj).1.mono (by unfold slotBytes; split_ifs <;> decide), (hF j hj).2⟩
  step_pattern' using runBodyFrom_leafRun2 (hf := fd_r52x5_quad_mul.call_eq) with Q0
  subst hQ0
  clear hSF
  step_pattern' using runBodyFrom_lanePairRun 0
  step_pattern' using runBodyFrom_laneLimbRun 0
  step_pattern' using runBodyFrom_lanePairRun 1
  step_pattern' using runBodyFrom_laneLimbRun 1
  step_pattern' using runBodyFrom_storeBytesQuadRun
  step_pattern' using runBodyFrom_storeBytesQuadRun
  refine hK E S hArgs ?_ ?_ ?_ (by mem_fact) (by mem_fact)
  · rw [hE]
    writes_chain
  · rw [hS]
    simp only
    omega
  · rw [hS]
    simp only [MemoryState.eraseFrom_storeQuad5, eraseFrom_callTmp5_slot, herase]
    rfl

end fd_r52x5_ge_decode2

end

end MLIR.Firedancer.Crc.Verify
