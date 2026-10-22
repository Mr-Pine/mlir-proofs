module

public import MLIR.Run.Tactic
public import Firedancer.Common.Memory
public import Firedancer.Common.Point
public import Firedancer.Common.Counter
public import Firedancer.Common.Dsmb
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_wnaf
import Firedancer.Common.LimbBits
import Std.Tactic.BVDecide
import Firedancer.Crc.Ed25519.Common.Reads

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

/-! ## Specification

`ulong w[4]` as one 256-bit number `w`, `w[0]` lowest; `bits` as `B`. The digit loop takes a `fuel`
bound it never reaches. -/

@[expose] public section

/-- `lo = w[0] & mask`, `mask = (1UL<<(bits+1))-1`. -/
def fd_r52x5_wnaf.lo (B : Nat) (w : BitVec 256) : BitVec 64 :=
  w.extractLsb' 0 64 &&& 1#64 <<< (B + 1) + 18446744073709551615#64

/-- `mask+1` when `lo >= half`, `half = 1UL<<bits`, else `0`. -/
def fd_r52x5_wnaf.sel (B : Nat) (w : BitVec 256) : BitVec 64 :=
  if BitVec.ofBool (fd_r52x5_wnaf.lo B w >>> B == 0#64) = 1#1 then 0#64 else 1#64 <<< (B + 1)

/-- `di`: `0` for an even `w`, else `lo - sel`, a `long`. -/
def fd_r52x5_wnaf.digit (B : Nat) (w : BitVec 256) : BitVec 64 :=
  if w.extractLsb' 0 64 &&& 1#64 = 0#64 then 0#64
  else fd_r52x5_wnaf.lo B w - fd_r52x5_wnaf.sel B w

/-- `w` after one digit: `(w - di) >> 1`. -/
def fd_r52x5_wnaf.next (B : Nat) (w : BitVec 256) : BitVec 256 :=
  (w - (fd_r52x5_wnaf.digit B w).signExtend 256) >>> 1

/-- The digits' count from digit `n` on of the nonzero `w`, `fuel` steps at most. -/
def fd_r52x5_wnaf.countF (B : Nat) : (fuel : Nat) → Nat → BitVec 256 → Nat
  | 0, n, _ => n
  | f + 1, n, w =>
    if fd_r52x5_wnaf.next B w = 0#256 then n + 1 else fd_r52x5_wnaf.countF B f (n + 1) (fd_r52x5_wnaf.next B w)

/-- The digits of the nonzero `w` from digit `n` on, stored at `d` over `m`. -/
def fd_r52x5_wnaf.storesF (B : Nat) (d : Pointer) : (fuel : Nat) → MemoryState → Nat → BitVec 256 → MemoryState
  | 0, m, _, _ => m
  | f + 1, m, n, w =>
    if fd_r52x5_wnaf.next B w = 0#256 then
      m.storeAt (d.add (BitVec.ofNat 64 (2 * n))) ((fd_r52x5_wnaf.digit B w).setWidth 16)
    else
      fd_r52x5_wnaf.storesF B d f
        (m.storeAt (d.add (BitVec.ofNat 64 (2 * n))) ((fd_r52x5_wnaf.digit B w).setWidth 16)) (n + 1)
        (fd_r52x5_wnaf.next B w)

/-- The digits' count of the scalar `x`: `0` for `x = 0`. -/
def fd_r52x5_wnaf.count (B : Nat) (x : BitVec 256) : Nat :=
  if x = 0#256 then 0 else fd_r52x5_wnaf.countF B 254 0 x

/-- `m` with the digits of the scalar `x` stored at `d`. -/
def fd_r52x5_wnaf.stores (B : Nat) (d : Pointer) (m : MemoryState) (x : BitVec 256) : MemoryState :=
  if x = 0#256 then m else fd_r52x5_wnaf.storesF B d 254 m 0 x

end

/-! ## Proof -/

section Proof

/-- `1UL<<(bits+1)` for `bits+1 < 10`: the `nuw nsw` shift and the `nsw` add of `-1` do not
overflow. -/
theorem shl_one_ok (h : k < 10) :
    1#64 <<< k >>> k = 1#64 ∧ (1#64 <<< k).sshiftRight k = 1#64 ∧
      (1#64 <<< k).saddOverflow 18446744073709551615#64 = false := by
  have : ∀ k < 10, 1#64 <<< k >>> k = 1#64 ∧ (1#64 <<< k).sshiftRight k = 1#64 ∧
      (1#64 <<< k).saddOverflow 18446744073709551615#64 = false := by decide
  exact this k h

namespace fd_r52x5_wnaf

/-- The registers at `^bb2` at digit `n` holding `w`. -/
abbrev hdr (E : ⟪Γ⟫) (n : Nat) (w : BitVec 256) : ⟪Γ⟫ :=
  E[%1128 := .value (BitVec.ofNat 32 n), %1129 := .value (w.extractLsb' 0 64),
    %1130 := Ty.wrap #v[w.extractLsb' 128 64, w.extractLsb' 192 64],
    %1131 := Ty.wrap #v[w.extractLsb' 64 64, w.extractLsb' 128 64]]

/-- The entry block's registers the loop reads: constants, `w`'s slot `v` and its limb pointers, and
the ones `bits` gives. -/
abbrev LoopEnv (E : ⟪Γ⟫) (v : Pointer) (B : Nat) : Prop :=
  E ⊨ [%1090 := 1#32, %1091 := 0#64, %1092 := 1#64, %1093 := 18446744073709551615#64,
    %1094 := Vector.replicate 2 PoisonOr.poison, %1096 := 0#16, %1097 := 63#64,
    %1098 := Ty.wrap (Vector.replicate 2 63#64), %1099 := v, %1109 := 1#64 <<< (B + 1),
    %1110 := 1#64 <<< (B + 1) + 18446744073709551615#64, %1111 := BitVec.ofNat 64 B,
    %1118 := v.add 8#64, %1119 := v.add 8#64, %1120 := v.add 16#64, %1121 := v.add 16#64,
    %1122 := v.add 8#64, %1123 := v.add 8#64, %1124 := v.add 16#64, %1125 := v.add 16#64,
    %1126 := v.add 8#64, %1127 := v.add 16#64]

/-- `w[1..3]` stored in the slot `v` over `M`. -/
abbrev stv (Sb : GlobalState) (M : MemoryState) (v : Pointer) (W : BitVec 256) : GlobalState :=
  { Sb with mem := M.storeAt v (W.extractLsb' 64 192) }

/-- The registers at `^bb13` at digit `n`: `w - di` and the `short` digit `y`. -/
abbrev hdr13 (E : ⟪Γ⟫) (n : Nat) (W : BitVec 256) (y : BitVec 16) : ⟪Γ⟫ :=
  E[%1128 := .value (BitVec.ofNat 32 n), %1161 := .value (W.extractLsb' 0 64), %1162 := .value y,
    %1163 := Ty.wrap #v[W.extractLsb' 128 64, W.extractLsb' 192 64],
    %1164 := Ty.wrap #v[W.extractLsb' 64 64, W.extractLsb' 128 64]]

/-- A small `int` sign-extends to the same `long`. -/
theorem signExtend_ofNat32 {a : Nat} (h : a < 2 ^ 31) :
    (BitVec.ofNat 32 a).signExtend 64 = BitVec.ofNat 64 a := by
  rw [BitVec.signExtend_eq_setWidth_of_msb_false (msb_ofNat32 h)]
  exact setWidth_ofNat32 (by omega)

/-- A two-lane `Vector.ofFn` as a literal. -/
theorem ofFn_two {α : Type} (f : Fin 2 → α) : Vector.ofFn f = #v[f 0, f 1] := by
  apply Vector.ext
  intro i hi
  match i, hi with
  | 0, _ => rfl
  | 1, _ => rfl

/-- `spliceBits` as masks and shifts, for `bv_decide`. -/
theorem spliceBits_eq {n w : Nat} (b : BitVec n) (off : Nat) (x : BitVec w) :
    Memory.spliceBits b off x =
      (b &&& ~~~((BitVec.allOnes w).setWidth n <<< off)) ||| (x.setWidth n <<< off) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
    BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth, BitVec.getLsbD_allOnes]
  grind

/-- The funnel shifts by 63: the limbs of `w >> 1`. -/
theorem shr_w0 (W : BitVec 256) :
    ((W.extractLsb' 64 64 ++ W.extractLsb' 0 64) <<< 63).extractLsb' 64 64 =
      (W >>> 1).extractLsb' 0 64 := by bv_decide

theorem shr_w2 (W : BitVec 256) :
    ((W.extractLsb' 192 64 ++ W.extractLsb' 128 64) <<< 63).extractLsb' 64 64 =
      (W >>> 1).extractLsb' 128 64 := by bv_decide

theorem shr_w3 (W : BitVec 256) : W.extractLsb' 192 64 >>> 1 = (W >>> 1).extractLsb' 192 64 := by
  bv_decide

theorem shr_w1 (W : BitVec 256) :
    ((W.extractLsb' 128 64 ++ W.extractLsb' 64 64) <<< 63).extractLsb' 64 64 =
      (W >>> 1).extractLsb' 64 64 := by bv_decide

/-- The loop test: the four limbs' OR is zero exactly when `w` is. -/
theorem lanes_zero (X : BitVec 256) :
    X.extractLsb' 64 64 ||| X.extractLsb' 128 64 ||| X.extractLsb' 0 64 ||| X.extractLsb' 192 64 =
      0#64 ↔ X = 0#256 := by bv_decide

/-- The shifted limbs `1 … 3` spliced into the slot: `(w >> 1)[1..3]`. -/
theorem shr_mem (W : BitVec 256) :
    Memory.spliceBits (Memory.spliceBits (W.extractLsb' 64 192) 0
        (BitVec.packLanes #v[(W >>> 1).extractLsb' 64 64, (W >>> 1).extractLsb' 128 64]))
      128 ((W >>> 1).extractLsb' 192 64) = (W >>> 1).extractLsb' 64 192 := by
  rw [BitVec.packLanes_pair, spliceBits_eq, spliceBits_eq]
  simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
  bv_decide

/-- `w[1]`, read from the slot. -/
theorem rd0 {m : MemoryState} {v : Pointer} {X : BitVec 192} (h : Room m v 192) :
    (m.storeAt v X).readAt v 64 = X.extractLsb' 0 64 := by
  rw [MemoryState.readAt_storeAt_subrange h rfl (Nat.le_refl _) (by omega)]
  simp

/-- Stores of one limb into the slot: the slot with it spliced. -/
theorem st8 {m : MemoryState} {v : Pointer} {X : BitVec 192} (hv : v.offset = 0) (y : BitVec 64) :
    (m.storeAt v X).storeAt (v.add 8#64) y = m.storeAt v (Memory.spliceBits X 64 y) := by
  rw [MemoryState.storeAt_storeAt_add (by simp [BitVec.uaddOverflow, hv]) (by simp)]
  rfl

theorem st16 {m : MemoryState} {v : Pointer} {X : BitVec 192} (hv : v.offset = 0) (y : BitVec 64) :
    (m.storeAt v X).storeAt (v.add 16#64) y = m.storeAt v (Memory.spliceBits X 128 y) := by
  rw [MemoryState.storeAt_storeAt_add (by simp [BitVec.uaddOverflow, hv]) (by simp)]
  rfl

theorem st0 {m : MemoryState} {v : Pointer} {X : BitVec 192} (y : BitVec 64) :
    (m.storeAt v X).storeAt v y = m.storeAt v (Memory.spliceBits X 0 y) :=
  MemoryState.storeAt_storeAt_low (by omega) y

/-- The funnel shifts' lane vectors: limbs `1, 2` and `2, 3` of `w >> 1`. -/
theorem shr_lanes12 (W : BitVec 256) :
    (Vector.ofFn fun i : Fin 2 => BitVec.extractLsb' 64 64
      (([W.extractLsb' 128 64, W.extractLsb' 192 64][(i : Nat)] ++
        [W.extractLsb' 64 64, W.extractLsb' 128 64][(i : Nat)]) <<< 63)) =
      #v[(W >>> 1).extractLsb' 64 64, (W >>> 1).extractLsb' 128 64] := by
  rw [ofFn_two]
  exact congrArg₂ (fun a b => #v[a, b]) (shr_w1 W) (shr_w2 W)

theorem shr_lanes23 (W : BitVec 256) :
    #v[((W.extractLsb' 192 64 ++ W.extractLsb' 128 64) <<< 63).extractLsb' 64 64,
        W.extractLsb' 192 64 >>> 1] =
      #v[(W >>> 1).extractLsb' 128 64, (W >>> 1).extractLsb' 192 64] := by
  rw [shr_w2, shr_w3]

/-- The constants `^bb0` computes from `bits = B` and the scalar's test, as `chunk0b` leaves them. -/
abbrev Out0b (E : ⟪Γ⟫) (v : Pointer) (B : Nat) (x : BitVec 256) : Prop :=
  E ⊨ [%1090 := 1#32, %1091 := 0#64, %1092 := 1#64, %1093 := 18446744073709551615#64,
    %1094 := Vector.replicate 2 PoisonOr.poison, %1095 := 0#32, %1096 := 0#16, %1097 := 63#64,
    %1098 := Ty.wrap (Vector.replicate 2 63#64), %1099 := v, %1100 := x.setWidth 64,
    %1103 := Ty.wrap (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (x.extractLsb' 64 128)),
    %1105 := Ty.wrap (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (x.extractLsb' 128 128)),
    %1109 := 1#64 <<< (B + 1), %1110 := 1#64 <<< (B + 1) + 18446744073709551615#64,
    %1111 := BitVec.ofNat 64 B,
    %1117 := BitVec.ofBool
      (Ty.extractVecElem 2 64 0 (x.extractLsb' 128 128) ||| Ty.extractVecElem 2 64 1 (x.extractLsb' 128 128) |||
        Ty.extractVecElem 2 64 0 (x.extractLsb' 64 128) ||| x.setWidth 64 == 0#64)]

set_option maxHeartbeats 1000000 in
/-- `^bb0` after its slot stores: the shifts `bits` gives and the zero test of the scalar `x`. -/
theorem chunk0b {blk : BasicBlock Γ [.bv 32] blockTys} (hbody : blk.body.drop 20 = bb0.body.drop 20)
    {d sp v : Pointer} {B : Nat} (hB : 3 ≤ B ∧ B ≤ 8) {x : BitVec 256} {S : GlobalState} {E : ⟪Γ⟫}
    {β : Type} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args = (args (.value d) (.value sp) (.value (BitVec.ofNat 32 B))).get)
    (hR : E ⊨ [%1090 := 1#32, %1091 := 0#64, %1092 := 1#64, %1093 := 18446744073709551615#64,
      %1094 := Vector.replicate 2 PoisonOr.poison, %1095 := 0#32, %1096 := 0#16, %1097 := 63#64,
      %1098 := Ty.wrap (Vector.replicate 2 63#64), %1099 := v, %1100 := x.setWidth 64,
      %1103 := Ty.wrap (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (x.extractLsb' 64 128)),
      %1105 := Ty.wrap (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (x.extractLsb' 128 128))])
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value (BitVec.ofNat 32 B))).get →
      Out0b E' v B x → (blk.runBodyFrom E' 31 S >>= g) = K) :
    (blk.runBodyFrom E 20 S >>= g) = K := by
  obtain ⟨h32, h33, h34, h35, h36, h37, h38, h39, h40, h41, h42, h45, h47⟩ := hR
  step_pure [saddOverflow_one32 (i := B) (by omega), uaddOverflow_one32 (i := B) (by omega),
    ← BitVec.ofNat_add]
  step_pure [msb_ofNat32 (i := B + 1) (by omega), setWidth_ofNat32 (i := B + 1) (by omega)]
  step_pure [Nat.mod_eq_of_lt (show B + 1 < 2 ^ 64 by omega), show ¬64 ≤ B + 1 by omega,
    (shl_one_ok (k := B + 1) (by omega)).1, (shl_one_ok (k := B + 1) (by omega)).2.1]
  step_pure [(shl_one_ok (k := B + 1) (by omega)).2.2]
  step_pure [msb_ofNat32 (i := B) (by omega), setWidth_ofNat32 (i := B) (by omega)]
  iterate 6 step_pure
  have hO : Out0b E v B x := by lemma_reads
  clear hE
  exact hK E hArgs hO

/-- The `^bb13` registers after its stores, as `chunk13a` leaves them: the counter, `w >> 1`'s limbs. -/
abbrev Out13a (E : ⟪Γ⟫) (n : Nat) (X : BitVec 256) : Prop :=
  E ⊨ [%1165 := BitVec.ofNat 32 (n + 1), %1169 := X.extractLsb' 0 64,
    %1170 := Ty.wrap #v[X.extractLsb' 64 64, X.extractLsb' 128 64], %1172 := X.extractLsb' 192 64]

set_option maxHeartbeats 1000000 in
/-- `^bb13` up to its last store: digit `y` stored at `d[n]` and `w >> 1` into the slot. -/
theorem chunk13a {blk : BasicBlock Γ [.bv 32] blockTys} (hbody : blk.body.drop 0 = bb13.body.drop 0)
    {d sp v : Pointer} {bits : BitVec 32} {B n : Nat} {W : BitVec 256} {y : BitVec 16}
    {M : MemoryState} {Sb : GlobalState} {E : ⟪Γ⟫} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hArgs : E.args = (args (.value d) (.value sp) (.value bits)).get)
    (hR : LoopEnv E v B)
    (hI : E ⊨ [%1128 := BitVec.ofNat 32 n, %1161 := W.extractLsb' 0 64, %1162 := y,
      %1163 := Ty.wrap #v[W.extractLsb' 128 64, W.extractLsb' 192 64],
      %1164 := Ty.wrap #v[W.extractLsb' 64 64, W.extractLsb' 128 64]])
    (hv : v.offset = 0) (hdv : d.id ≠ v.id) (hrv : Room M v 192) (hd : Room M d (8 * 512))
    (hdo : ¬d.offset.uaddOverflow 512#64) (hn : n < 256)
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get → LoopEnv E' v B →
      Out13a E' n (W >>> 1) →
      (blk.runBodyFrom E' 11 (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) y) v (W >>> 1))
        >>= g) = K) :
    (blk.runBodyFrom E 0 (stv Sb M v W) >>= g) = K := by
  have hd2 : (Range.of v 192).Disjoint (Range.of (d.add (BitVec.ofNat 64 (2 * n))) 16) :=
    .inl (Ne.symm hdv)
  obtain ⟨h70, h03, h04, h05, h06⟩ := hI
  step_pure
  step_pure [signExtend_ofNat32 (a := n) (by omega)]
  step_pure [Nat.mod_eq_of_lt (show n < 2 ^ 64 by omega), show 2 * n < 2 ^ 64 by omega,
    show n * 2 = 2 * n by omega]
  step_store
  iterate 3 step_pure
  step_store
  step_pure
  step_pure
  step_store
  rw [shr_lanes12, shr_w3] at hS
  rw [MemoryState.storeAt_comm hd2, MemoryState.storeAt_storeAt_low (by omega),
    show (16#64 : BitVec 64) = BitVec.ofNat 64 16 from rfl,
    MemoryState.storeAt_storeAt_add (by simp [BitVec.uaddOverflow, hv]) (by simp)] at hS
  rw [show (16#64 : BitVec 64).toNat * 8 = 128 from rfl, shr_mem] at hS
  rw [shr_lanes12, shr_w0, shr_w3, ← BitVec.ofNat_add] at hE
  have hL : LoopEnv E v B := by lemma_reads
  have hO : Out13a E n (W >>> 1) := by lemma_reads
  clear hE
  subst hS
  exact hK E hArgs hL hO

/-- `^bb13`'s loop test on `X = w >> 1`: its limbs' OR against zero. -/
abbrev test13 (X : BitVec 256) : BitVec 1 :=
  BitVec.ofBool (X.extractLsb' 64 64 ||| X.extractLsb' 128 64 ||| X.extractLsb' 0 64 |||
    X.extractLsb' 192 64 == 0#64)

set_option maxHeartbeats 1000000 in
/-- `^bb13` from its last store: the loop test and the next digit's lanes. -/
theorem chunk13b {blk : BasicBlock Γ [.bv 32] blockTys} (hbody : blk.body.drop 11 = bb13.body.drop 11)
    {d sp v : Pointer} {bits : BitVec 32} {B n : Nat} {X : BitVec 256} {S : GlobalState}
    {E : ⟪Γ⟫} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hArgs : E.args = (args (.value d) (.value sp) (.value bits)).get)
    (hR : LoopEnv E v B) (hI : Out13a E n X)
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get → LoopEnv E' v B →
      Out13a E' n X → E' ⊨ [%1178 := test13 X,
        %1180 := Ty.wrap #v[X.extractLsb' 128 64, X.extractLsb' 192 64]] →
      (blk.runBodyFrom E' 19 S >>= g) = K) :
    (blk.runBodyFrom E 11 S >>= g) = K := by
  iterate 8 step_pure
  have hL : LoopEnv E v B := by lemma_reads
  have hO : Out13a E n X := by lemma_reads
  have hT : E ⊨ [%1178 := test13 X, %1180 := Ty.wrap #v[X.extractLsb' 128 64, X.extractLsb' 192 64]] := by
    lemma_reads
  clear hE
  exact hK E hArgs hL hO hT

set_option maxHeartbeats 1000000 in
/-- `^bb13`: digit `y` stored at `d[n]`, `w` shifted right by one into the slot and the registers;
then `^bb2` while the shifted `w` is nonzero, else `^bb14`. -/
theorem blk13 (d sp v : Pointer) (bits : BitVec 32) (B n : Nat) (W : BitVec 256) (y : BitVec 16)
    (M : MemoryState) (Sb : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value d) (.value sp) (.value bits)).get)
    (hR : LoopEnv E v B) (hv : v.offset = 0) (hdv : d.id ≠ v.id)
    (hrv : Room M v 192) (hd : Room M d (8 * 512)) (hdo : ¬d.offset.uaddOverflow 512#64)
    (hn : n < 256)
    (hback : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get → LoopEnv E' v B →
      W >>> 1 ≠ 0#256 →
      (fd_r52x5_wnaf.runFrom (hdr E' (n + 1) (W >>> 1)) 2
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) y) v (W >>> 1)) >>= g) = K)
    (hexit : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get →
      E' ⊨ [%1099 := v, %1181 := BitVec.ofNat 32 (n + 1)] → W >>> 1 = 0#256 →
      (fd_r52x5_wnaf.runFrom E' 14
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) y) v (W >>> 1)) >>= g) = K) :
    (fd_r52x5_wnaf.runFrom (hdr13 E n W y) 13 (stv Sb M v W) >>= g) = K := by
  block_init
  refine chunk13a (blk := bb13) rfl (E := hdr13 E n W y) hArgs hR (by lemma_reads) hv hdv hrv hd
    hdo hn fun E hArgs hR hO => ?_
  refine chunk13b (blk := bb13) rfl hArgs hR hO fun E hArgs hR hO hT => ?_
  obtain ⟨h07, h11, h12, h14⟩ := hO
  obtain ⟨h20, h22⟩ := hT
  finish_block
  case isTrue =>
    have hx : E ⊨ [%1099 := v, %1181 := BitVec.ofNat 32 (n + 1)] := by lemma_reads
    clear hE
    run_from using hexit
    · exact (lanes_zero _).1 hbr
  case isFalse =>
    have hx : E ⊨ [%1128 := BitVec.ofNat 32 (n + 1), %1129 := (W >>> 1).extractLsb' 0 64,
        %1130 := Ty.wrap #v[(W >>> 1).extractLsb' 128 64, (W >>> 1).extractLsb' 192 64],
        %1131 := Ty.wrap #v[(W >>> 1).extractLsb' 64 64, (W >>> 1).extractLsb' 128 64]] := by
      lemma_reads
    have hL : LoopEnv E v B := by lemma_reads
    clear hE
    run_from using hback
    exact fun h => hbr ((lanes_zero _).2 h)

/-- A field of a field, as one field. -/
theorem extract_extract {w : Nat} (x : BitVec w) (a s l k : Nat) (h : s + k ≤ l) :
    (x.extractLsb' a l).extractLsb' s k = x.extractLsb' (a + s) k := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [BitVec.getLsbD_extractLsb', hi, decide_true, Bool.true_and]
  rw [show a + s + i = a + (s + i) by omega]
  simp [show s + i < l by omega]

/-- A field inside a truncation. -/
theorem setWidth_extract {w : Nat} (x : BitVec w) (s l k : Nat) (h : s + k ≤ l) :
    (x.setWidth l).extractLsb' s k = x.extractLsb' s k := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp [hi, show s + i < l by omega]

/-- The `<2 x i64>` loads of the slot at `0` and `8`, as limbs of `X ++ a`. -/
theorem lanes_lo (X : BitVec 192) (a : BitVec 64) :
    (Vector.ofFn fun i : Fin 2 => Ty.extractVecElem 2 64 i (X.setWidth 128)) =
      #v[(X ++ a).extractLsb' 64 64, (X ++ a).extractLsb' 128 64] := by
  have h0 : (X.setWidth 128).extractLsb' 0 64 = (X ++ a).extractLsb' 64 64 := by rw [setWidth_extract _ _ _ _ (by omega), BitVec.extractLsb'_append_eq_of_le (by omega)]
  have h1 : (X.setWidth 128).extractLsb' 64 64 = (X ++ a).extractLsb' 128 64 := by rw [setWidth_extract _ _ _ _ (by omega), BitVec.extractLsb'_append_eq_of_le (by omega)]
  rw [ofFn_two]
  simp only [Ty.extractVecElem_eq, Fin.isValue, Fin.val_zero, Fin.val_one, Nat.zero_mul,
    Nat.one_mul, h0, h1]

theorem lanes_hi (X : BitVec 192) (a : BitVec 64) :
    (Vector.ofFn fun i : Fin 2 => Ty.extractVecElem 2 64 i (X.extractLsb' 64 128)) =
      #v[(X ++ a).extractLsb' 128 64, (X ++ a).extractLsb' 192 64] := by
  have h0 : (X.extractLsb' 64 128).extractLsb' 0 64 = (X ++ a).extractLsb' 128 64 :=
    by rw [extract_extract _ _ _ _ _ (by omega), BitVec.extractLsb'_append_eq_of_le (by omega)]
  have h1 : (X.extractLsb' 64 128).extractLsb' 64 64 = (X ++ a).extractLsb' 192 64 :=
    by rw [extract_extract _ _ _ _ _ (by omega), BitVec.extractLsb'_append_eq_of_le (by omega)]
  rw [ofFn_two]
  simp only [Ty.extractVecElem_eq, Fin.isValue, Fin.val_zero, Fin.val_one, Nat.zero_mul,
    Nat.one_mul, h0, h1]

/-- The slot's limbs and limb `0` of `X ++ a`. -/
theorem mid_eq (X : BitVec 192) (a : BitVec 64) : (X ++ a).extractLsb' 64 192 = X :=
  BitVec.extractLsb'_append_eq_left

theorem low_eq (X : BitVec 192) (a : BitVec 64) : (X ++ a).extractLsb' 0 64 = a :=
  BitVec.extractLsb'_append_eq_right

set_option maxHeartbeats 1000000 in
/-- `^bb12`: `w - di` from limb `0` and the slot, the `short` digit; then `^bb13`. -/
theorem blk12 (d sp v : Pointer) (bits : BitVec 32) (B n : Nat) (X : BitVec 192) (w0 di : BitVec 64)
    (W : BitVec 256) (hW : W = X ++ (w0 - di))
    (M : MemoryState) (Sb : GlobalState) (E : ⟪Γ⟫)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value d) (.value sp) (.value bits)).get)
    (hR : LoopEnv E v B) (hE : E ⊨ [%1128 := BitVec.ofNat 32 n, %1129 := w0, %1138 := di])
    (hv : v.offset = 0) (hdv : d.id ≠ v.id)
    (hrv : Room M v 192) (hd : Room M d (8 * 512)) (hdo : ¬d.offset.uaddOverflow 512#64)
    (hn : n < 256) (hdi : (di.setWidth 16).signExtend 64 = di)
    (hback : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get → LoopEnv E' v B →
      W >>> 1 ≠ 0#256 →
      (fd_r52x5_wnaf.runFrom (hdr E' (n + 1) (W >>> 1)) 2
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) (di.setWidth 16)) v (W >>> 1)) >>= g) = K)
    (hexit : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get →
      E' ⊨ [%1099 := v, %1181 := BitVec.ofNat 32 (n + 1)] → W >>> 1 = 0#256 →
      (fd_r52x5_wnaf.runFrom E' 14
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) (di.setWidth 16)) v (W >>> 1)) >>= g) = K) :
    (fd_r52x5_wnaf.runFrom E 12 { Sb with mem := M.storeAt v X } >>= g) = K := by
  subst hW
  obtain ⟨h70, h71, h80⟩ := hE
  block_init
  step_pure
  step_pure [hdi]
  step_load [lanes_lo X (w0 - di)]
  step_load [lanes_hi X (w0 - di)]
  finish_block
  rw [← mid_eq X (w0 - di)] at hS
  run_from using blk13 d sp v bits B n (X ++ (w0 - di)) (di.setWidth 16) M Sb _ g K
    (hback := hback) (hexit := hexit)
  exact (low_eq X (w0 - di)).symm

/-- `w - di` by limbs: limb `0` minus `di`, limbs `1 … 3` minus the borrow (`di > 0`) or plus the
carry. -/
theorem sub_split (w : BitVec 256) (t : BitVec 64) (ht0 : t ≠ 0#64) :
    w - t.signExtend 256 =
      (w.extractLsb' 64 192 -
        if (0#64).slt t = true then (if (w.extractLsb' 0 64).ult t = true then 1#192 else 0#192)
        else if (w.extractLsb' 0 64).ult t = true then 0#192 else BitVec.allOnes 192) ++
        (w.extractLsb' 0 64 - t) := by
  bv_decide

/-- The borrow through limbs `1`, `2` into `3`: the slot's stores. -/
theorem cb3 (X : BitVec 192) (hz1 : BitVec.extractLsb' 0 64 X = 0#64) (hz2 : BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 (BitVec.extractLsb' 0 64 X + 18446744073709551615#64)) = 0#64) :
    X - 1#192 = Memory.spliceBits (Memory.spliceBits (Memory.spliceBits X 0 18446744073709551615#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 18446744073709551615#64) + 18446744073709551615#64)) 128 (BitVec.extractLsb' 128 64 (Memory.spliceBits (Memory.spliceBits X 0 18446744073709551615#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 18446744073709551615#64) + 18446744073709551615#64)) + 18446744073709551615#64) := by
  simp only [spliceBits_eq] at *
  bv_decide

theorem cb2 (X : BitVec 192) (hz1 : BitVec.extractLsb' 0 64 X = 0#64) (hz2 : ¬BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 (BitVec.extractLsb' 0 64 X + 18446744073709551615#64)) = 0#64) :
    X - 1#192 = Memory.spliceBits (Memory.spliceBits X 0 18446744073709551615#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 18446744073709551615#64) + 18446744073709551615#64) := by
  simp only [spliceBits_eq] at *
  bv_decide

theorem cb1 (X : BitVec 192) (hz1 : ¬BitVec.extractLsb' 0 64 X = 0#64) :
    X - 1#192 = Memory.spliceBits X 0 (BitVec.extractLsb' 0 64 X + 18446744073709551615#64) := by
  simp only [spliceBits_eq] at *
  bv_decide

/-- The carry through limbs `1`, `2` into `3`: the slot's stores. -/
theorem cc3 (X : BitVec 192) (hz1 : BitVec.extractLsb' 0 64 X = 18446744073709551615#64) (hz2 : BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 (BitVec.extractLsb' 0 64 X + 1#64)) = 18446744073709551615#64) :
    X - BitVec.allOnes 192 = Memory.spliceBits (Memory.spliceBits (Memory.spliceBits X 0 0#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 0#64) + 1#64)) 128 (BitVec.extractLsb' 128 64 (Memory.spliceBits (Memory.spliceBits X 0 0#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 0#64) + 1#64)) + 1#64) := by
  simp only [spliceBits_eq] at *
  bv_decide

theorem cc2 (X : BitVec 192) (hz1 : BitVec.extractLsb' 0 64 X = 18446744073709551615#64) (hz2 : ¬BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 (BitVec.extractLsb' 0 64 X + 1#64)) = 18446744073709551615#64) :
    X - BitVec.allOnes 192 = Memory.spliceBits (Memory.spliceBits X 0 0#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits X 0 0#64) + 1#64) := by
  simp only [spliceBits_eq] at *
  bv_decide

theorem cc1 (X : BitVec 192) (hz1 : ¬BitVec.extractLsb' 0 64 X = 18446744073709551615#64) :
    X - BitVec.allOnes 192 = Memory.spliceBits X 0 (BitVec.extractLsb' 0 64 X + 1#64) := by
  simp only [spliceBits_eq] at *
  bv_decide

/-- `w - di` through the stores of `^bb5 … ^bb7` (`0 < di`), `^bb4` or `^bb8` (none), `^bb9 … ^bb11`
(`di < 0`). -/
theorem sub_b3 (w : BitVec 256)
    (t : BitVec 64)
    (ht0 : t ≠ 0#64)
    (hp : BitVec.slt (0#64) t = true)
    (hu : BitVec.ult (BitVec.extractLsb' 0 64 w) t = true)
    (hz1 : BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) = 0#64)
    (hz2 : BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 (BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) + 18446744073709551615#64)) = 0#64) :
    w - BitVec.signExtend 256 t = Memory.spliceBits (Memory.spliceBits (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 18446744073709551615#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 18446744073709551615#64) + 18446744073709551615#64)) 128 (BitVec.extractLsb' 128 64 (Memory.spliceBits (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 18446744073709551615#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 18446744073709551615#64) + 18446744073709551615#64)) + 18446744073709551615#64) ++ (BitVec.extractLsb' 0 64 w - t) := by
  rw [sub_split w t ht0, ite_eq_left hp, ite_eq_left hu, cb3 _ hz1 hz2]

theorem sub_b2 (w : BitVec 256)
    (t : BitVec 64)
    (ht0 : t ≠ 0#64)
    (hp : BitVec.slt (0#64) t = true)
    (hu : BitVec.ult (BitVec.extractLsb' 0 64 w) t = true)
    (hz1 : BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) = 0#64)
    (hz2 : ¬BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 (BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) + 18446744073709551615#64)) = 0#64) :
    w - BitVec.signExtend 256 t = Memory.spliceBits (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 18446744073709551615#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 18446744073709551615#64) + 18446744073709551615#64) ++ (BitVec.extractLsb' 0 64 w - t) := by
  rw [sub_split w t ht0, ite_eq_left hp, ite_eq_left hu, cb2 _ hz1 hz2]

theorem sub_b1 (w : BitVec 256)
    (t : BitVec 64)
    (ht0 : t ≠ 0#64)
    (hp : BitVec.slt (0#64) t = true)
    (hu : BitVec.ult (BitVec.extractLsb' 0 64 w) t = true)
    (hz1 : ¬BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) = 0#64) :
    w - BitVec.signExtend 256 t = Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 (BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) + 18446744073709551615#64) ++ (BitVec.extractLsb' 0 64 w - t) := by
  rw [sub_split w t ht0, ite_eq_left hp, ite_eq_left hu, cb1 _ hz1]

theorem sub_nb (w : BitVec 256)
    (t : BitVec 64)
    (ht0 : t ≠ 0#64)
    (hp : BitVec.slt (0#64) t = true)
    (hu : ¬BitVec.ult (BitVec.extractLsb' 0 64 w) t = true) :
    w - BitVec.signExtend 256 t = BitVec.extractLsb' 64 192 w ++ (BitVec.extractLsb' 0 64 w - t) := by
  rw [sub_split w t ht0, ite_eq_left hp, ite_eq_right hu, BitVec.sub_zero]

theorem sub_nc (w : BitVec 256)
    (t : BitVec 64)
    (ht0 : t ≠ 0#64)
    (hp : ¬BitVec.slt (0#64) t = true)
    (hu : BitVec.ult (BitVec.extractLsb' 0 64 w) t = true) :
    w - BitVec.signExtend 256 t = BitVec.extractLsb' 64 192 w ++ (BitVec.extractLsb' 0 64 w - t) := by
  rw [sub_split w t ht0, ite_eq_right hp, ite_eq_left hu, BitVec.sub_zero]

theorem sub_c3 (w : BitVec 256)
    (t : BitVec 64)
    (ht0 : t ≠ 0#64)
    (hp : ¬BitVec.slt (0#64) t = true)
    (hu : ¬BitVec.ult (BitVec.extractLsb' 0 64 w) t = true)
    (hz1 : BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) = 18446744073709551615#64)
    (hz2 : BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 (BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) + 1#64)) = 18446744073709551615#64) :
    w - BitVec.signExtend 256 t = Memory.spliceBits (Memory.spliceBits (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 0#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 0#64) + 1#64)) 128 (BitVec.extractLsb' 128 64 (Memory.spliceBits (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 0#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 0#64) + 1#64)) + 1#64) ++ (BitVec.extractLsb' 0 64 w - t) := by
  rw [sub_split w t ht0, ite_eq_right hp, ite_eq_right hu, cc3 _ hz1 hz2]

theorem sub_c2 (w : BitVec 256)
    (t : BitVec 64)
    (ht0 : t ≠ 0#64)
    (hp : ¬BitVec.slt (0#64) t = true)
    (hu : ¬BitVec.ult (BitVec.extractLsb' 0 64 w) t = true)
    (hz1 : BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) = 18446744073709551615#64)
    (hz2 : ¬BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 (BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) + 1#64)) = 18446744073709551615#64) :
    w - BitVec.signExtend 256 t = Memory.spliceBits (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 0#64) 64 (BitVec.extractLsb' 64 64 (Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 0#64) + 1#64) ++ (BitVec.extractLsb' 0 64 w - t) := by
  rw [sub_split w t ht0, ite_eq_right hp, ite_eq_right hu, cc2 _ hz1 hz2]

theorem sub_c1 (w : BitVec 256)
    (t : BitVec 64)
    (ht0 : t ≠ 0#64)
    (hp : ¬BitVec.slt (0#64) t = true)
    (hu : ¬BitVec.ult (BitVec.extractLsb' 0 64 w) t = true)
    (hz1 : ¬BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) = 18446744073709551615#64) :
    w - BitVec.signExtend 256 t = Memory.spliceBits (BitVec.extractLsb' 64 192 w) 0 (BitVec.extractLsb' 0 64 (BitVec.extractLsb' 64 192 w) + 1#64) ++ (BitVec.extractLsb' 0 64 w - t) := by
  rw [sub_split w t ht0, ite_eq_right hp, ite_eq_right hu, cc1 _ hz1]

set_option maxHeartbeats 1000000 in
/-- `^bb5`: the borrow chain through the slot for `di = t`, then `^bb12`. -/
theorem chain5 (d sp v : Pointer) (bits : BitVec 32) (B n : Nat) (w : BitVec 256) (t : BitVec 64)
    (M : MemoryState) (Sb : GlobalState) (E : ⟪Γ⟫) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hArgs : E.args = (args (.value d) (.value sp) (.value bits)).get)
    (hR : LoopEnv E v B) (hE : E ⊨ [%1128 := BitVec.ofNat 32 n, %1129 := w.extractLsb' 0 64, %1138 := t])
    (hv : v.offset = 0) (hdv : d.id ≠ v.id)
    (hrv : Room M v 192) (hd : Room M d (8 * 512)) (hdo : ¬d.offset.uaddOverflow 512#64)
    (hn : n < 256) (hdi : (t.setWidth 16).signExtend 64 = t) (ht0 : t ≠ 0#64)
    (hp : (0#64).slt t = true) (hu : (w.extractLsb' 0 64).ult t = true)
    (hback : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get → LoopEnv E' v B →
      (w - t.signExtend 256) >>> 1 ≠ 0#256 →
      (fd_r52x5_wnaf.runFrom (hdr E' (n + 1) ((w - t.signExtend 256) >>> 1)) 2
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) (t.setWidth 16)) v
          ((w - t.signExtend 256) >>> 1)) >>= g) = K)
    (hexit : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get →
      E' ⊨ [%1099 := v, %1181 := BitVec.ofNat 32 (n + 1)] → (w - t.signExtend 256) >>> 1 = 0#256 →
      (fd_r52x5_wnaf.runFrom E' 14
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) (t.setWidth 16)) v
          ((w - t.signExtend 256) >>> 1)) >>= g) = K) :
    (fd_r52x5_wnaf.runFrom E 5 (stv Sb M v w) >>= g) = K := by
  obtain ⟨h70, h71, h80⟩ := hE
  block_init
  step_load [rd0 hrv]
  iterate 2 step_pure
  step_store
  rw [st0] at hS
  finish_block
  case isTrue =>
    have hz1 := hbr
    block_init
    step_load
    iterate 2 step_pure
    step_store
    rw [st8 hv] at hS
    finish_block
    case isTrue =>
      have hz2 := hbr
      block_init
      step_load
      step_pure
      step_store
      rw [st16 hv] at hS
      finish_block
      run_from using blk12 d sp v bits B n _ (w.extractLsb' 0 64) t (w - t.signExtend 256) _ M Sb _ g K
        (hback := hback) (hexit := hexit)
      exact sub_b3 w t ht0 hp hu hz1 hz2
    case isFalse =>
      have hz2 := hbr
      run_from using blk12 d sp v bits B n _ (w.extractLsb' 0 64) t (w - t.signExtend 256) _ M Sb _ g K
        (hback := hback) (hexit := hexit)
      exact sub_b2 w t ht0 hp hu hz1 hz2
  case isFalse =>
    have hz1 := hbr
    run_from using blk12 d sp v bits B n _ (w.extractLsb' 0 64) t (w - t.signExtend 256) _ M Sb _ g K
      (hback := hback) (hexit := hexit)
    exact sub_b1 w t ht0 hp hu hz1

set_option maxHeartbeats 1000000 in
/-- `^bb9`: the carry chain through the slot for `di = t`, then `^bb12`. -/
theorem chain9 (d sp v : Pointer) (bits : BitVec 32) (B n : Nat) (w : BitVec 256) (t : BitVec 64)
    (M : MemoryState) (Sb : GlobalState) (E : ⟪Γ⟫) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hArgs : E.args = (args (.value d) (.value sp) (.value bits)).get)
    (hR : LoopEnv E v B) (hE : E ⊨ [%1128 := BitVec.ofNat 32 n, %1129 := w.extractLsb' 0 64, %1138 := t])
    (hv : v.offset = 0) (hdv : d.id ≠ v.id)
    (hrv : Room M v 192) (hd : Room M d (8 * 512)) (hdo : ¬d.offset.uaddOverflow 512#64)
    (hn : n < 256) (hdi : (t.setWidth 16).signExtend 64 = t) (ht0 : t ≠ 0#64)
    (hp : ¬(0#64).slt t = true) (hu : ¬(w.extractLsb' 0 64).ult t = true)
    (hback : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get → LoopEnv E' v B →
      (w - t.signExtend 256) >>> 1 ≠ 0#256 →
      (fd_r52x5_wnaf.runFrom (hdr E' (n + 1) ((w - t.signExtend 256) >>> 1)) 2
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) (t.setWidth 16)) v
          ((w - t.signExtend 256) >>> 1)) >>= g) = K)
    (hexit : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get →
      E' ⊨ [%1099 := v, %1181 := BitVec.ofNat 32 (n + 1)] → (w - t.signExtend 256) >>> 1 = 0#256 →
      (fd_r52x5_wnaf.runFrom E' 14
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) (t.setWidth 16)) v
          ((w - t.signExtend 256) >>> 1)) >>= g) = K) :
    (fd_r52x5_wnaf.runFrom E 9 (stv Sb M v w) >>= g) = K := by
  obtain ⟨h70, h71, h80⟩ := hE
  block_init
  step_load [rd0 hrv]
  iterate 2 step_pure
  step_store
  rw [st0] at hS
  finish_block
  case isTrue =>
    have hz1 := hbr
    block_init
    step_load
    iterate 2 step_pure
    step_store
    rw [st8 hv] at hS
    finish_block
    case isTrue =>
      have hz2 := hbr
      block_init
      step_load
      step_pure
      step_store
      rw [st16 hv] at hS
      finish_block
      run_from using blk12 d sp v bits B n _ (w.extractLsb' 0 64) t (w - t.signExtend 256) _ M Sb _ g K
        (hback := hback) (hexit := hexit)
      exact sub_c3 w t ht0 hp hu hz1 hz2
    case isFalse =>
      have hz2 := hbr
      run_from using blk12 d sp v bits B n _ (w.extractLsb' 0 64) t (w - t.signExtend 256) _ M Sb _ g K
        (hback := hback) (hexit := hexit)
      exact sub_c2 w t ht0 hp hu hz1 hz2
  case isFalse =>
    have hz1 := hbr
    run_from using blk12 d sp v bits B n _ (w.extractLsb' 0 64) t (w - t.signExtend 256) _ M Sb _ g K
      (hback := hback) (hexit := hexit)
    exact sub_c1 w t ht0 hp hu hz1

set_option maxHeartbeats 1000000 in
/-- One digit at `^bb2`: `di`, the borrow (`di > 0`) or carry chain through the slot, then
`^bb13`. -/
theorem trip (d sp v : Pointer) (bits : BitVec 32) (B n : Nat) (w : BitVec 256) (M : MemoryState)
    (Sb : GlobalState) (E : ⟪Γ⟫) (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value d) (.value sp) (.value bits)).get)
    (hR : LoopEnv E v B) (hB : 3 ≤ B ∧ B ≤ 8) (hv : v.offset = 0) (hdv : d.id ≠ v.id)
    (hrv : Room M v 192) (hd : Room M d (8 * 512)) (hdo : ¬d.offset.uaddOverflow 512#64)
    (hn : n < 256)
    (hss : (fd_r52x5_wnaf.lo B w).ssubOverflow (fd_r52x5_wnaf.sel B w) = false)
    (hdi : (((fd_r52x5_wnaf.lo B w - fd_r52x5_wnaf.sel B w).setWidth 16).signExtend 64 =
      fd_r52x5_wnaf.lo B w - fd_r52x5_wnaf.sel B w))
    (hnz : ¬w.extractLsb' 0 64 &&& 1#64 = 0#64 → fd_r52x5_wnaf.lo B w - fd_r52x5_wnaf.sel B w ≠ 0#64)
    (hback : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get → LoopEnv E' v B →
      fd_r52x5_wnaf.next B w ≠ 0#256 →
      (fd_r52x5_wnaf.runFrom (hdr E' (n + 1) (fd_r52x5_wnaf.next B w)) 2
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) ((fd_r52x5_wnaf.digit B w).setWidth 16))
          v (fd_r52x5_wnaf.next B w)) >>= g) = K)
    (hexit : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get →
      E' ⊨ [%1099 := v, %1181 := BitVec.ofNat 32 (n + 1)] → fd_r52x5_wnaf.next B w = 0#256 →
      (fd_r52x5_wnaf.runFrom E' 14
        (stv Sb (M.storeAt (d.add (BitVec.ofNat 64 (2 * n))) ((fd_r52x5_wnaf.digit B w).setWidth 16))
          v (fd_r52x5_wnaf.next B w)) >>= g) = K) :
    (fd_r52x5_wnaf.runFrom (hdr E n w) 2 (stv Sb M v w) >>= g) = K := by
  block_init
  step_pure
  step_pure
  finish_block
  case isTrue =>
    have hdig : fd_r52x5_wnaf.digit B w = 0#64 := by simp only [fd_r52x5_wnaf.digit, hbr, ite_true]
    have hnx : fd_r52x5_wnaf.next B w = w >>> 1 := by
      rw [fd_r52x5_wnaf.next, hdig]; simp
    rw [hnx, hdig] at hback hexit
    run_from using blk13 d sp v bits B n w ((0#64).setWidth 16) M Sb _ g K (hback := hback)
      (hexit := hexit)
  case isFalse =>
    have hodd := hbr
    obtain ⟨t, ht⟩ : ∃ t, fd_r52x5_wnaf.lo B w - fd_r52x5_wnaf.sel B w = t := ⟨_, rfl⟩
    have hdig : fd_r52x5_wnaf.digit B w = t := by simp only [fd_r52x5_wnaf.digit, hodd, ite_false, ht]
    have hnx : fd_r52x5_wnaf.next B w = (w - t.signExtend 256) >>> 1 := by
      rw [fd_r52x5_wnaf.next, hdig]
    have ht0 : t ≠ 0#64 := ht ▸ hnz hodd
    rw [ht] at hdi
    rw [hnx, hdig] at hback hexit
    clear hnz hdig hnx
    block_init
    step_pure with transparent lo
    step_pure [Nat.mod_eq_of_lt (show B < 2 ^ 64 by omega), show ¬64 ≤ B by omega]
    step_pure
    step_pure with transparent sel
    have hlo' : lo = fd_r52x5_wnaf.lo B w := hlo
    have hsel' : sel = fd_r52x5_wnaf.sel B w := by rw [hsel]; rfl
    step_pure [hlo', hsel', hss, ht]
    step_pure
    step_pure
    finish_block
    case isTrue =>
      have hp := hbr
      block_init
      finish_block
      case isTrue =>
        have hu := hbr
        run_from using chain5 d sp v bits B n w t M Sb _ g K (hback := hback) (hexit := hexit)
      case isFalse =>
        have hu := hbr
        run_from using blk12 d sp v bits B n _ (w.extractLsb' 0 64) t (w - t.signExtend 256) _ M Sb _ g K
          (hback := hback) (hexit := hexit)
        exact sub_nb w t ht0 hp hu
    case isFalse =>
      have hp := hbr
      block_init
      finish_block
      case isTrue =>
        have hu := hbr
        run_from using blk12 d sp v bits B n _ (w.extractLsb' 0 64) t (w - t.signExtend 256) _ M Sb _ g K
          (hback := hback) (hexit := hexit)
        exact sub_nc w t ht0 hp hu
      case isFalse =>
        have hu := hbr
        run_from using chain9 d sp v bits B n w t M Sb _ g K (hback := hback) (hexit := hexit)

/-- `lo` and `sel` with `bits` as a `BitVec`, for `bv_decide`. -/
def loB (b : BitVec 64) (w0 : BitVec 64) : BitVec 64 :=
  w0 &&& 1#64 <<< (b + 1#64) + 18446744073709551615#64

def selB (b : BitVec 64) (w0 : BitVec 64) : BitVec 64 :=
  if loB b w0 >>> b = 0#64 then 0#64 else 1#64 <<< (b + 1#64)

/-- Shifts by a small `Nat`, as by a `BitVec`. -/
theorem shl_nat {w : Nat} (x : BitVec w) (h : k < 2 ^ 64) : x <<< k = x <<< BitVec.ofNat 64 k := by
  rw [BitVec.shiftLeft_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]

theorem shr_nat {w : Nat} (x : BitVec w) (h : k < 2 ^ 64) : x >>> k = x >>> BitVec.ofNat 64 k := by
  rw [BitVec.ushiftRight_eq', BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]

theorem lo_eq (hB : B < 63) (w : BitVec 256) :
    fd_r52x5_wnaf.lo B w = loB (BitVec.ofNat 64 B) (w.extractLsb' 0 64) := by
  rw [fd_r52x5_wnaf.lo, loB, shl_nat _ (show B + 1 < 2 ^ 64 by omega), BitVec.ofNat_add]

theorem sel_eq (hB : B < 63) (w : BitVec 256) :
    fd_r52x5_wnaf.sel B w = selB (BitVec.ofNat 64 B) (w.extractLsb' 0 64) := by
  unfold fd_r52x5_wnaf.sel selB
  rw [← lo_eq hB]
  have e1 : fd_r52x5_wnaf.lo B w >>> B = fd_r52x5_wnaf.lo B w >>> BitVec.ofNat 64 B :=
    shr_nat _ (by omega)
  have e2 : 1#64 <<< (B + 1) = 1#64 <<< (BitVec.ofNat 64 B + 1#64) := by
    rw [shl_nat _ (show B + 1 < 2 ^ 64 by omega), BitVec.ofNat_add]
  rw [← e1, ← e2]
  by_cases h : fd_r52x5_wnaf.lo B w >>> B = 0#64 <;> simp [h, BitVec.ofBool, beq_iff_eq]

/-- The `nsw` subtraction and truncation do not overflow; an odd `w` gives a nonzero digit. -/
theorem facts_bv (b w0 : BitVec 64) (hb : 3#64 ≤ b ∧ b ≤ 8#64) :
    (loB b w0).ssubOverflow (selB b w0) = false ∧
      (((loB b w0 - selB b w0).setWidth 16).signExtend 64 = loB b w0 - selB b w0) ∧
      (¬w0 &&& 1#64 = 0#64 → loB b w0 - selB b w0 ≠ 0#64) := by
  simp only [loB, selB]
  bv_decide

/-- `1 <<< k` for `k ≤ 255`, as a `Nat`. -/
theorem toNat_one_shl (k : BitVec 256) (hk : k ≤ 255#256) : (1#256 <<< k).toNat = 2 ^ k.toNat := by
  rw [BitVec.le_def, BitVec.toNat_ofNat] at hk
  rw [BitVec.shiftLeft_eq', BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, Nat.one_shiftLeft]
  exact Nat.mod_eq_of_lt (Nat.lt_of_le_of_lt (Nat.pow_le_pow_right (by decide) hk) (by decide))

/-- `1 <<< k` is a power of two. -/
theorem shl_pow2 (k : BitVec 256) (hk : k ≤ 255#256) :
    (1#256 <<< k) &&& (1#256 <<< k - 1#256) = 0#256 := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_and, BitVec.toNat_sub, toNat_one_shl k hk, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
  have h1 : 2 ^ k.toNat ≤ 2 ^ 255 := Nat.pow_le_pow_right (by decide) (by
    rw [BitVec.le_def, BitVec.toNat_ofNat] at hk; exact hk)
  have h2 : 1 ≤ 2 ^ k.toNat := Nat.one_le_two_pow
  rw [show (2 ^ 256 - 1 % 2 ^ 256 + 2 ^ k.toNat) % 2 ^ 256 = 2 ^ k.toNat - 1 by omega,
    Nat.and_two_pow_sub_one_eq_mod, Nat.mod_self]

theorem shl_ge2 (k : BitVec 256) (hk1 : 1#256 ≤ k) (hk : k ≤ 255#256) : 2#256 ≤ 1#256 <<< k := by
  rw [BitVec.le_def, toNat_one_shl k hk, BitVec.toNat_ofNat]
  rw [BitVec.le_def, BitVec.toNat_ofNat] at hk1
  calc 2 % 2 ^ 256 = 2 ^ 1 := by decide
    _ ≤ 2 ^ k.toNat := Nat.pow_le_pow_right (by decide) (by omega)

theorem shl_shr (k : BitVec 256) (hk1 : 1#256 ≤ k) (hk : k ≤ 255#256) :
    (1#256 <<< k) >>> 1 = 1#256 <<< (k - 1#256) := by
  have hk' : k - 1#256 ≤ 255#256 := by
    rw [BitVec.le_def, BitVec.toNat_sub, BitVec.toNat_ofNat, BitVec.toNat_ofNat]
    rw [BitVec.le_def, BitVec.toNat_ofNat] at hk1 hk
    omega
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ushiftRight, toNat_one_shl k hk, toNat_one_shl _ hk', BitVec.toNat_sub,
    BitVec.toNat_ofNat]
  rw [BitVec.le_def, BitVec.toNat_ofNat] at hk1 hk
  rw [show (2 ^ 256 - 1 % 2 ^ 256 + k.toNat) % 2 ^ 256 = k.toNat - 1 by omega,
    Nat.shiftRight_eq_div_pow, Nat.pow_div (by omega) (by decide)]

/-- `w ≤ P` with `P` a power of two, `2 ≤ P`, gives `next w ≤ P >>> 1`: `|di| < 2^bits` keeps
`w - di` below `P + 2^8`. -/
theorem next_le_pow2 (w P : BitVec 256) (b : BitVec 64) (hb : 3#64 ≤ b ∧ b ≤ 8#64)
    (hP : P &&& (P - 1#256) = 0#256) (hP2 : 2#256 ≤ P) (hw : w ≤ P) :
    (w - (if w.extractLsb' 0 64 &&& 1#64 = 0#64 then 0#64
        else loB b (w.extractLsb' 0 64) - selB b (w.extractLsb' 0 64)).signExtend 256) >>> 1 ≤
      P >>> 1 := by
  simp only [loB, selB]
  bv_decide

/-- `w ≤ 2^k` gives `next w ≤ 2^(k-1)`. -/
theorem next_le_bv (w k : BitVec 256) (b : BitVec 64) (hb : 3#64 ≤ b ∧ b ≤ 8#64) (hk1 : 1#256 ≤ k)
    (hk : k ≤ 255#256) (hw : w ≤ 1#256 <<< k) :
    (w - (if w.extractLsb' 0 64 &&& 1#64 = 0#64 then 0#64
        else loB b (w.extractLsb' 0 64) - selB b (w.extractLsb' 0 64)).signExtend 256) >>> 1 ≤
      1#256 <<< (k - 1#256) := by
  rw [← shl_shr k hk1 hk]
  exact next_le_pow2 w _ b hb (shl_pow2 k hk) (shl_ge2 k hk1 hk) hw

/-- `w ≤ 1` ends the loop. -/
theorem next_one_bv (w : BitVec 256) (b : BitVec 64) (hb : 3#64 ≤ b ∧ b ≤ 8#64) (hw : w ≤ 1#256) :
    (w - (if w.extractLsb' 0 64 &&& 1#64 = 0#64 then 0#64
        else loB b (w.extractLsb' 0 64) - selB b (w.extractLsb' 0 64)).signExtend 256) >>> 1 = 0#256 := by
  simp only [loB, selB]
  bv_decide

theorem b_range (hB : 3 ≤ B ∧ B ≤ 8) : 3#64 ≤ BitVec.ofNat 64 B ∧ BitVec.ofNat 64 B ≤ 8#64 := by
  simp only [BitVec.le_def, BitVec.toNat_ofNat]
  omega

theorem digit_eq (hB : B < 63) (w : BitVec 256) :
    fd_r52x5_wnaf.digit B w = if w.extractLsb' 0 64 &&& 1#64 = 0#64 then 0#64
      else loB (BitVec.ofNat 64 B) (w.extractLsb' 0 64) - selB (BitVec.ofNat 64 B) (w.extractLsb' 0 64) := by
  rw [fd_r52x5_wnaf.digit, lo_eq hB, sel_eq hB]

/-- `1 << (253 - n)`, the bound on `w` at digit `n`. -/
abbrev bnd (n : Nat) : BitVec 256 := 1#256 <<< BitVec.ofNat 256 (253 - n)

theorem next_le (hB : 3 ≤ B ∧ B ≤ 8) (hn : n < 253) (hw : w ≤ bnd n) :
    fd_r52x5_wnaf.next B w ≤ bnd (n + 1) := by
  have h := next_le_bv w (BitVec.ofNat 256 (253 - n)) _ (b_range hB)
    (by simp only [BitVec.le_def, BitVec.toNat_ofNat]; omega)
    (by simp only [BitVec.le_def, BitVec.toNat_ofNat]; omega) hw
  have hk : BitVec.ofNat 256 (253 - n) - 1#256 = BitVec.ofNat 256 (253 - (n + 1)) := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_sub, BitVec.toNat_ofNat]
    omega
  rw [hk, ← digit_eq (by omega)] at h
  exact h

theorem next_last (hB : 3 ≤ B ∧ B ≤ 8) (hw : w ≤ bnd 253) : fd_r52x5_wnaf.next B w = 0#256 := by
  have h := next_one_bv w _ (b_range hB) (by simpa using hw)
  rw [← digit_eq (by omega)] at h
  exact h

theorem facts (hB : 3 ≤ B ∧ B ≤ 8) (w : BitVec 256) :
    (fd_r52x5_wnaf.lo B w).ssubOverflow (fd_r52x5_wnaf.sel B w) = false ∧
      (((fd_r52x5_wnaf.lo B w - fd_r52x5_wnaf.sel B w).setWidth 16).signExtend 64 =
        fd_r52x5_wnaf.lo B w - fd_r52x5_wnaf.sel B w) ∧
      (¬w.extractLsb' 0 64 &&& 1#64 = 0#64 → fd_r52x5_wnaf.lo B w - fd_r52x5_wnaf.sel B w ≠ 0#64) := by
  rw [lo_eq (by omega), sel_eq (by omega)]
  exact facts_bv _ _ (b_range hB)

/-- `^bb2` at digit `n` with the nonzero `w ≤ bnd n` in the registers and `fuel` steps: the digits
stored as `storesF` leaves them, their count as `countF` gives it, then `^bb14`. -/
theorem loop (d sp v : Pointer) (bits : BitVec 32) (B : Nat) (hB : 3 ≤ B ∧ B ≤ 8)
    (hv : v.offset = 0) (hdv : d.id ≠ v.id) (hdo : ¬d.offset.uaddOverflow 512#64) (Sb : GlobalState)
    (g : Vals [.bv 32] × GlobalState → PoisonOr β) (K : PoisonOr β) :
    ∀ f n (w : BitVec 256) (M : MemoryState) (E : ⟪Γ⟫),
      E.args = (args (.value d) (.value sp) (.value bits)).get → LoopEnv E v B →
      Room M v 192 → Room M d (8 * 512) → n ≤ 253 → 254 ≤ f + n → w ≤ bnd n →
      (∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value bits)).get →
        E' ⊨ [%1099 := v, %1181 := BitVec.ofNat 32 (fd_r52x5_wnaf.countF B f n w)] →
        (fd_r52x5_wnaf.runFrom E' 14 (stv Sb (fd_r52x5_wnaf.storesF B d f M n w) v 0#256) >>= g) = K) →
      (fd_r52x5_wnaf.runFrom (hdr E n w) 2 (stv Sb M v w) >>= g) = K := by
  intro f
  induction f with
  | zero =>
    intro n w M E _ _ _ _ hn hf
    omega
  | succ f ih =>
    intro n w M E hArgs hR hrv hd hn hf hw hK
    obtain ⟨hss, hdi, hnz⟩ := facts hB w
    refine trip d sp v bits B n w M Sb E g K hArgs hR hB hv hdv hrv hd hdo (by omega) hss hdi hnz
      ?_ ?_
    · intro E' h1 h2 hne
      have hn' : n < 253 := by
        rcases Nat.lt_or_ge n 253 with h | h
        · exact h
        · exact absurd (next_last hB (show n = 253 by omega ▸ hw)) hne
      refine ih (n + 1) _ _ E' h1 h2 (Room.storeAt hrv) (Room.storeAt hd) (by omega) (by omega)
        (next_le hB hn' hw) ?_
      intro E'' f1 f2
      have := hK E'' f1
      simp only [fd_r52x5_wnaf.countF, fd_r52x5_wnaf.storesF, hne, ite_false] at this
      exact this f2
    · intro E' h1 h2 hz
      have := hK E' h1
      simp only [fd_r52x5_wnaf.countF, fd_r52x5_wnaf.storesF, hz, ite_true] at this
      rw [hz]
      exact this h2

end fd_r52x5_wnaf

/-- The digits' stores leave a frame erase. -/
theorem eraseFrom_storesF {d : Pointer} :
    ∀ f (m : MemoryState) n (w : BitVec 256),
      (fd_r52x5_wnaf.storesF B d f m n w).eraseFrom k = fd_r52x5_wnaf.storesF B d f (m.eraseFrom k) n w
  | 0, _, _, _ => rfl
  | f + 1, m, n, w => by
    simp only [fd_r52x5_wnaf.storesF]
    split
    · exact MemoryState.eraseFrom_storeAt
    · rw [eraseFrom_storesF f, MemoryState.eraseFrom_storeAt]

/-- `bb0`'s stores of `w[1]` and `w[2..3]` into the slot: `w[1..3]`. -/
theorem entry_eq (x : BitVec 256) :
    (BitVec.packLanes (Vector.ofFn fun i : Fin 2 => Ty.extractVecElem 2 64 i (x.extractLsb' 128 128)) ++
        Ty.extractVecElem 2 64 0 (x.extractLsb' 64 128)) = x.extractLsb' 64 192 := by
  rw [fd_r52x5_wnaf.ofFn_two, BitVec.packLanes_pair]
  simp only [Ty.extractVecElem_eq, Fin.isValue, Fin.val_zero, Fin.val_one, Nat.zero_mul, Nat.one_mul,
    Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
  bv_decide

/-- `bb0`'s test: the limbs' OR is zero exactly when the scalar is. -/
theorem entry_zero (x : BitVec 256) :
    Ty.extractVecElem 2 64 0 (x.extractLsb' 128 128) ||| Ty.extractVecElem 2 64 1 (x.extractLsb' 128 128) |||
          Ty.extractVecElem 2 64 0 (x.extractLsb' 64 128) ||| x.setWidth 64 = 0#64 ↔ x = 0#256 := by
  simp only [Ty.extractVecElem_eq, Fin.isValue, Fin.val_zero, Fin.val_one, Nat.zero_mul, Nat.one_mul]
  bv_decide

/-- The scalar's `<2 x i64>` loads at `8` and `16`, as limbs. -/
theorem entry_lanes_hi (x : BitVec 256) :
    (Vector.ofFn fun i : Fin 2 => Ty.extractVecElem 2 64 i (x.extractLsb' 128 128)) =
      #v[x.extractLsb' 128 64, x.extractLsb' 192 64] := by
  have h0 : (x.extractLsb' 128 128).extractLsb' 0 64 = x.extractLsb' 128 64 := by rw [fd_r52x5_wnaf.extract_extract _ _ _ _ _ (by omega)]
  have h1 : (x.extractLsb' 128 128).extractLsb' 64 64 = x.extractLsb' 192 64 := by rw [fd_r52x5_wnaf.extract_extract _ _ _ _ _ (by omega)]
  rw [fd_r52x5_wnaf.ofFn_two]
  simp only [Ty.extractVecElem_eq, Fin.isValue, Fin.val_zero, Fin.val_one, Nat.zero_mul,
    Nat.one_mul, h0, h1]

theorem entry_lanes_lo (x : BitVec 256) :
    (Vector.ofFn fun i : Fin 2 => Ty.extractVecElem 2 64 i (x.extractLsb' 64 128)) =
      #v[x.extractLsb' 64 64, x.extractLsb' 128 64] := by
  have h0 : (x.extractLsb' 64 128).extractLsb' 0 64 = x.extractLsb' 64 64 := by rw [fd_r52x5_wnaf.extract_extract _ _ _ _ _ (by omega)]
  have h1 : (x.extractLsb' 64 128).extractLsb' 64 64 = x.extractLsb' 128 64 := by rw [fd_r52x5_wnaf.extract_extract _ _ _ _ _ (by omega)]
  rw [fd_r52x5_wnaf.ofFn_two]
  simp only [Ty.extractVecElem_eq, Fin.isValue, Fin.val_zero, Fin.val_one, Nat.zero_mul,
    Nat.one_mul, h0, h1]

set_option maxHeartbeats 1000000 in
/-- `^bb1` for a nonzero scalar `x` with `w[1..3]` in the slot `v`: the digit loop from digit `0`,
then `^bb14`. -/
theorem fd_r52x5_wnaf.bb1_run (d sp v : Pointer) (B : Nat) (hB : 3 ≤ B ∧ B ≤ 8)
    (hv : v.offset = 0) (hdv : d.id ≠ v.id) (hdo : ¬d.offset.uaddOverflow 512#64) (Sb : GlobalState)
    (M : MemoryState) (x : BitVec 256) (E : ⟪Γ⟫) (g : Vals [.bv 32] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hArgs : E.args = (args (.value d) (.value sp) (.value (BitVec.ofNat 32 B))).get)
    (hR : E ⊨ [%1090 := 1#32, %1091 := 0#64, %1092 := 1#64, %1093 := 18446744073709551615#64,
      %1094 := Vector.replicate 2 PoisonOr.poison, %1095 := 0#32, %1096 := 0#16, %1097 := 63#64,
      %1098 := Ty.wrap (Vector.replicate 2 63#64), %1099 := v, %1109 := 1#64 <<< (B + 1),
      %1110 := 1#64 <<< (B + 1) + 18446744073709551615#64, %1111 := BitVec.ofNat 64 B])
    (hX : E ⊨ [%1100 := x.setWidth 64,
      %1103 := Ty.wrap (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (x.extractLsb' 64 128)),
      %1105 := Ty.wrap (Vector.ofFn fun i => Ty.extractVecElem 2 64 i (x.extractLsb' 128 128))])
    (hrv : Room M v 192) (hd : Room M d (8 * 512)) (hxb : x ≤ fd_r52x5_wnaf.bnd 0)
    (hK : ∀ E' : ⟪Γ⟫, E'.args = (args (.value d) (.value sp) (.value (BitVec.ofNat 32 B))).get →
      E' ⊨ [%1099 := v, %1181 := BitVec.ofNat 32 (fd_r52x5_wnaf.countF B 254 0 x)] →
      (fd_r52x5_wnaf.runFrom E' 14 (stv Sb (fd_r52x5_wnaf.storesF B d 254 M 0 x) v 0#256) >>= g) = K) :
    (fd_r52x5_wnaf.runFrom E 1 (stv Sb M v x) >>= g) = K := by
  block_init
  iterate 10 step_pure
  finish_block
  run_from using fd_r52x5_wnaf.loop d sp v (BitVec.ofNat 32 B) B hB hv hdv hdo Sb g K 254 0 x M
  · rw [entry_lanes_hi]
  · rw [entry_lanes_lo]
  · intro h
    subst hS
    exact hK E₀ hArgs₀ h

set_option maxHeartbeats 1000000 in
/-- `fd_r52x5_wnaf( d, s, bits )` stores the digits of the scalar at `s` at `d`, as `stores`, and
returns their count, for `bits` in `3 … 8` and a scalar below `2^253`; its `ulong w[3]` is a frame
slot. -/
public theorem fd_r52x5_wnaf.call_eq (d sp : Pointer) (bits : BitVec 32) (s : GlobalState) (hwf : s.WF)
    (hd : Room s.mem d (8 * 512)) (hdo : ¬d.offset.uaddOverflow 512#64)
    (hs : Fits s.mem sp 256) (hso : ¬sp.offset.uaddOverflow 32#64)
    (hbits : 3 ≤ bits.toNat ∧ bits.toNat ≤ 8) (hlt : (s.mem.readAt sp 256).toNat < 2 ^ 253) :
    fd_r52x5_wnaf.call (fd_r52x5_wnaf.args (.value d) (.value sp) (.value bits)) s =
      .value
        (.cons (.value (BitVec.ofNat 32 (fd_r52x5_wnaf.count bits.toNat (s.mem.readAt sp 256)))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := fd_r52x5_wnaf.stores bits.toNat d s.mem (s.mem.readAt sp 256) }) := by
  have hov (k : Nat) (hk : k ≤ 32) : ¬sp.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq] at hso ⊢; omega
  have hs8 : Fits s.mem (sp.add 8#64) 128 := Fits.add_of_le (hov 8 (by omega)) (by decide) hs
  have hs16 : Fits s.mem (sp.add 16#64) 128 := Fits.add_of_le (hov 16 (by omega)) (by decide) hs
  have hs0 : Fits s.mem sp 64 := hs.mono (by omega)
  obtain ⟨x, hx⟩ : ∃ x, s.mem.readAt sp 256 = x := ⟨_, rfl⟩
  have e0 := MemoryState.readAt_of_readAt_le (w := 64) (by decide) hx
  have e8 := MemoryState.readAt_add_of_readAt hs.inBounds (hov 8 (by omega)) (w := 128) (by decide) hx
  have e16 := MemoryState.readAt_add_of_readAt hs.inBounds (hov 16 (by omega)) (w := 128) (by decide) hx
  simp only [BitVec.toNat_ofNat] at e8 e16
  rw [hx] at hlt ⊢
  have hxb : x ≤ fd_r52x5_wnaf.bnd 0 := by
    rw [BitVec.le_def, show (fd_r52x5_wnaf.bnd 0).toNat = 2 ^ 253 from rfl]
    omega
  clear hlt
  obtain ⟨B, hB⟩ : ∃ B, bits.toNat = B := ⟨_, rfl⟩
  rw [hB] at hbits ⊢
  obtain rfl : bits = BitVec.ofNat 32 B := by rw [← hB, BitVec.ofNat_toNat, BitVec.setWidth_eq]
  generalize hres : fd_r52x5_wnaf.count B x = res
  generalize hmem : fd_r52x5_wnaf.stores B d s.mem x = mem
  func_init
  block_init
  iterate 9 step_pure
  step_alloca with v
  step_pure
  clear hv_bounds
  step_load
  iterate 2 step_pure
  step_load
  step_pure
  step_store
  step_load
  step_pure
  step_store
  rw [hv10, hv13, hv15] at hE
  refine fd_r52x5_wnaf.chunk0b (blk := bb0) rfl hbits (x := x) hArgs (by rw [hE]; lemma_reads)
    fun E' hArgs' hO => ?_
  clear hE
  rw [show (8#64 : BitVec 64) = BitVec.ofNat 64 8 from rfl,
    MemoryState.storeAt_storeAt_append (k := 8) (by simp [BitVec.uaddOverflow, hv_off]) rfl (by decide),
    entry_eq] at hS
  obtain ⟨o32, o33, o34, o35, o36, o37, o38, o39, o40, o41, o42, o45, o47, o51, o52, o53, o59⟩ := hO
  finish_block
  case isTrue =>
    have hx0 : x = 0#256 := (entry_zero x).1 hbr
    block_init
    step_pure
    finish_block
    subst hS hres hmem
    simp only [fd_r52x5_wnaf.count, fd_r52x5_wnaf.stores, hx0, ite_true]
    erase_frame
    rfl
  case isFalse =>
    have hx0 : x ≠ 0#256 := fun h => hbr ((entry_zero x).2 h)
    run_from using fd_r52x5_wnaf.bb1_run d sp v B hbits hv_off hd_ne_v hdo
      { alloc := (S₀.alloca 24 true).alloc, mem := S₀.mem } ((S₀.alloca 24 true).mem.lifetimeStart v) x
    · intro ⟨h1, h2⟩
      block_init
      step_pure
      finish_block
      subst hS hres hmem
      simp only [fd_r52x5_wnaf.count, fd_r52x5_wnaf.stores, hx0, ite_false]
      erase_frame
      rw [eraseFrom_storesF]
      erase_frame
      rfl


/-! ### The stored digits, read back -/

/-- `w` after `i` digits. -/
@[expose] public def fd_r52x5_wnaf.iter (B : Nat) : Nat → BitVec 256 → BitVec 256
  | 0, w => w
  | i + 1, w => fd_r52x5_wnaf.iter B i (fd_r52x5_wnaf.next B w)

/-- The digits' count is at most `n + fuel`. -/
public theorem fd_r52x5_wnaf.countF_le (B : Nat) :
    ∀ f n (w : BitVec 256), fd_r52x5_wnaf.countF B f n w ≤ n + f
  | 0, n, _ => by simp [fd_r52x5_wnaf.countF]
  | f + 1, n, w => by
    simp only [fd_r52x5_wnaf.countF]
    split
    · omega
    · have := fd_r52x5_wnaf.countF_le B f (n + 1) (fd_r52x5_wnaf.next B w); omega

/-- The digits' count is past `n`. -/
public theorem fd_r52x5_wnaf.lt_countF (B : Nat) :
    ∀ f n (w : BitVec 256), n < fd_r52x5_wnaf.countF B (f + 1) n w
  | 0, n, w => by simp only [fd_r52x5_wnaf.countF]; split <;> omega
  | f + 1, n, w => by
    rw [fd_r52x5_wnaf.countF]
    split
    · omega
    · have := fd_r52x5_wnaf.lt_countF B f (n + 1) (fd_r52x5_wnaf.next B w); omega

/-- `d[j]`'s range, below `512` bytes. -/
theorem lane_disjoint {d : Pointer} (hdo : ¬d.offset.uaddOverflow 512#64) (hi : i < 256) (hj : j < 256)
    (hij : i ≠ j) :
    (Range.of (d.add (BitVec.ofNat 64 (2 * j))) 16).Disjoint (Range.of (d.add (BitVec.ofNat 64 (2 * i))) 16) := by
  have h := hdo
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.reducePow, Nat.reduceMod] at h
  exact Range.disjoint_add (by omega) (by omega) (by omega)

/-- `d[i]`'s `Room`, inside `d`'s 512 bytes. -/
theorem lane_room {m : MemoryState} {d : Pointer} (hd : Room m d (8 * 512))
    (hdo : ¬d.offset.uaddOverflow 512#64) (hi : i < 256) : Room m (d.add (BitVec.ofNat 64 (2 * i))) 16 := by
  have h := hdo
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.reducePow, Nat.reduceMod] at h
  refine Room.add_of_le ?_ ?_ hd
  · simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]; omega
  · simp only [BitVec.toNat_ofNat]; omega

/-- Stores from digit `n` on keep `d[i]`, `i < n`, and its fit. -/
theorem storesF_keep {d : Pointer} (hdo : ¬d.offset.uaddOverflow 512#64) (hi : i < 256) :
    ∀ f (m : MemoryState) n (w : BitVec 256), i < n → n + f ≤ 256 →
      (fd_r52x5_wnaf.storesF B d f m n w).readAt (d.add (BitVec.ofNat 64 (2 * i))) 16 =
          m.readAt (d.add (BitVec.ofNat 64 (2 * i))) 16 ∧
        (Fits m (d.add (BitVec.ofNat 64 (2 * i))) 16 →
          Fits (fd_r52x5_wnaf.storesF B d f m n w) (d.add (BitVec.ofNat 64 (2 * i))) 16)
  | 0, m, n, w, _, _ => ⟨rfl, id⟩
  | f + 1, m, n, w, hin, hf => by
    have hD := lane_disjoint hdo hi (show n < 256 by omega) (by omega)
    simp only [fd_r52x5_wnaf.storesF]
    split
    · exact ⟨MemoryState.readAt_storeAt_disjoint hD _, fun h => Fits.storeAt h⟩
    · obtain ⟨h1, h2⟩ := storesF_keep hdo hi f
        (m.storeAt (d.add (BitVec.ofNat 64 (2 * n))) ((fd_r52x5_wnaf.digit B w).setWidth 16)) (n + 1)
        (fd_r52x5_wnaf.next B w) (by omega) (by omega)
      exact ⟨h1.trans (MemoryState.readAt_storeAt_disjoint hD _),
        fun h => h2 (Fits.storeAt h)⟩

/-- The digits stored from digit `n` on: `d[i]`, `n ≤ i < countF`, holds digit `i - n` of `w`,
in fit. -/
public theorem fd_r52x5_wnaf.storesF_digit {d : Pointer} (hdo : ¬d.offset.uaddOverflow 512#64) :
    ∀ f (m : MemoryState) n (w : BitVec 256) i, Room m d (8 * 512) → n + f ≤ 256 → n ≤ i →
      i < fd_r52x5_wnaf.countF B f n w →
      Fits (fd_r52x5_wnaf.storesF B d f m n w) (d.add (BitVec.ofNat 64 (2 * i))) 16 ∧
        (fd_r52x5_wnaf.storesF B d f m n w).readAt (d.add (BitVec.ofNat 64 (2 * i))) 16 =
          (fd_r52x5_wnaf.digit B (fd_r52x5_wnaf.iter B (i - n) w)).setWidth 16
  | 0, m, n, w, i, _, _, hni, hc => by simp only [fd_r52x5_wnaf.countF] at hc; omega
  | f + 1, m, n, w, i, hd, hf, hni, hc => by
    have hR := lane_room hd hdo (show n < 256 by omega)
    simp only [fd_r52x5_wnaf.countF] at hc
    simp only [fd_r52x5_wnaf.storesF]
    split
    · rename_i hz
      simp only [hz, ite_true] at hc
      obtain rfl : i = n := by omega
      exact ⟨Fits.storeAt_self hR, by rw [MemoryState.readAt_storeAt_self hR, Nat.sub_self]; rfl⟩
    · rename_i hz
      simp only [hz, ite_false] at hc
      rcases Nat.lt_or_ge n i with h | h
      · obtain ⟨h1, h2⟩ := fd_r52x5_wnaf.storesF_digit hdo f _ (n + 1) (fd_r52x5_wnaf.next B w) i
          (Room.storeAt hd) (by omega) (by omega) hc
        refine ⟨h1, h2.trans ?_⟩
        rw [show i - n = (i - (n + 1)) + 1 by omega]
        rfl
      · obtain rfl : i = n := by omega
        obtain ⟨k1, k2⟩ := storesF_keep (B := B) hdo (show i < 256 by omega) f
          (m.storeAt (d.add (BitVec.ofNat 64 (2 * i))) ((fd_r52x5_wnaf.digit B w).setWidth 16)) (i + 1)
          (fd_r52x5_wnaf.next B w) (by omega) (by omega)
        refine ⟨k2 (Fits.storeAt_self hR), ?_⟩
        rw [k1, MemoryState.readAt_storeAt_self hR, Nat.sub_self]
        rfl

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
