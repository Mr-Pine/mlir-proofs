module

public import MLIR.Run.Tactic
public import Firedancer.Lane.split_odd_table
public import Firedancer.Lane.Mlir.fd_ed25519_split_table_a

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof


namespace Split

/-- `split_odd_table.call_eq` with the point read named. -/
public theorem split_call (tbl p : Pointer) (n : BitVec 32) (s : GlobalState) (P : Quad)
    (hwf : s.WF)
    (ht : Room s.mem tbl (1536 * n.toNat)) (hto : tbl.offset.toNat + 192 * n.toNat < 2 ^ 64)
    (hp : s.mem.QuadFit p) (hpt : p.id ≠ tbl.id) (hn : 2 ≤ n.toNat ∧ n.toNat < 2 ^ 31)
    (hP : s.mem.readQuad p = P) :
    _root_.Firedancer.Lane.Mlir.split_odd_table.call
        (_root_.Firedancer.Lane.Mlir.split_odd_table.args (.value tbl) (.value p) (.value n)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩
            mem := s.mem.storeTable tbl n.toNat (split_odd_table.spec P) }) := by
  rw [← hP]
  exact split_odd_table.call_eq tbl p n s hwf ht hto hp hpt hn

/-- `fd_ed25519_point_dbln.call_eq` with the point read named. -/
public theorem dbln_call (r a : Pointer) (n : BitVec 32) (s : GlobalState) (A : Quad) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) (hn : n.toNat ≤ 255)
    (hA : s.mem.readQuad a = A) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbln.args (.value r) (.value a) (.value n))
        s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeQuad r (fd_ed25519_point_dbln.spec A n.toNat) }) := by
  rw [← hA]
  exact fd_ed25519_point_dbln.call_eq r a n s hwf hr ha hn

end Split

open Split fd_ed25519_split_table_a in
/-- `fd_ed25519_split_table_a` stores `spec` of the point at `a`, 32 entries, as a table at `tbl`.
Its frame is nine blocks: `p` and the eight `split_odd_table`s' `p2`. -/
public theorem fd_ed25519_split_table_a.call_eq (tbl a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ht : Room s.mem tbl (1536 * 32)) (hto : tbl.offset.toNat + 192 * 32 < 2 ^ 64)
    (ha : s.mem.QuadFit a) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_split_table_a.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_split_table_a.args (.value tbl) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 9⟩
            mem :=
              s.mem.storeTable tbl 32 (fd_ed25519_split_table_a.spec (s.mem.readQuad a)) }) := by
  have ht0 := Firedancer.Lane.Split.room_seg (k := 0) (c := 4) ht hto (by omega)
  have ht1 := Firedancer.Lane.Split.room_seg (k := 4) (c := 4) ht hto (by omega)
  have ht2 := Firedancer.Lane.Split.room_seg (k := 8) (c := 4) ht hto (by omega)
  have ht3 := Firedancer.Lane.Split.room_seg (k := 12) (c := 4) ht hto (by omega)
  have ht4 := Firedancer.Lane.Split.room_seg (k := 16) (c := 4) ht hto (by omega)
  have ht5 := Firedancer.Lane.Split.room_seg (k := 20) (c := 4) ht hto (by omega)
  have ht6 := Firedancer.Lane.Split.room_seg (k := 24) (c := 4) ht hto (by omega)
  have ht7 := Firedancer.Lane.Split.room_seg (k := 28) (c := 4) ht hto (by omega)
  simp only [Nat.reduceMul, Pointer.add_zero_quad] at ht0 ht1 ht2 ht3 ht4 ht5 ht6 ht7
  clear ht
  have ho1 : (tbl.add 768#64).offset.toNat + 768 < 18446744073709551616 := by
    rw [Firedancer.Lane.Split.offset_add_ofNat (by omega)]; omega
  have ho2 : (tbl.add 1536#64).offset.toNat + 768 < 18446744073709551616 := by
    rw [Firedancer.Lane.Split.offset_add_ofNat (by omega)]; omega
  have ho3 : (tbl.add 2304#64).offset.toNat + 768 < 18446744073709551616 := by
    rw [Firedancer.Lane.Split.offset_add_ofNat (by omega)]; omega
  have ho4 : (tbl.add 3072#64).offset.toNat + 768 < 18446744073709551616 := by
    rw [Firedancer.Lane.Split.offset_add_ofNat (by omega)]; omega
  have ho5 : (tbl.add 3840#64).offset.toNat + 768 < 18446744073709551616 := by
    rw [Firedancer.Lane.Split.offset_add_ofNat (by omega)]; omega
  have ho6 : (tbl.add 4608#64).offset.toNat + 768 < 18446744073709551616 := by
    rw [Firedancer.Lane.Split.offset_add_ofNat (by omega)]; omega
  have ho7 : (tbl.add 5376#64).offset.toNat + 768 < 18446744073709551616 := by
    rw [Firedancer.Lane.Split.offset_add_ofNat (by omega)]; omega
  func_init
  block_init
  iterate 3 step_pure
  step_alloca with pp
  step_pure
  step_load with a03
  step_store
  step_pure
  step_load with a14
  step_pure
  step_store
  step_pure
  step_load with a25
  step_pure
  step_store
  have hpq : S.mem.QuadFit pp := ⟨by rw [hpp_off]; decide, hfits_pp, hfits_pp_64, hfits_pp_128⟩
  have eA : (⟨a03, a14, a25⟩ : Quad) = S₀.mem.readQuad a := by
    rw [ha03, ha14, ha25]
    rfl
  generalize hA : S₀.mem.readQuad a = A at eA
  have hP : S.mem.readQuad pp = seg A 0 := by
    rw [seg, ← eA, MemoryState.readQuad, MemoryState.readVec_packLanes hread_pp,
      MemoryState.readVec_packLanes hread_pp_64, MemoryState.readVec_packLanes hread_pp_128]
  clear hwritable_pp hread_pp hread_pp_64 hread_pp_128 eA ha03 ha14 ha25
  step_call using (split_call (P := seg A 0) (hP := hP))
  step_call using (dbln_call (A := seg A 0) (hA := hP)) consuming hP
  have hq1 : S.mem.readQuad pp = seg A 1 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg A 1) (hP := hq1))
  step_call using (dbln_call (A := seg A 1) (hA := hq1)) consuming hq1
  have hq2 : S.mem.readQuad pp = seg A 2 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg A 2) (hP := hq2))
  step_call using (dbln_call (A := seg A 2) (hA := hq2)) consuming hq2
  have hq3 : S.mem.readQuad pp = seg A 3 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg A 3) (hP := hq3))
  step_call using (dbln_call (A := seg A 3) (hA := hq3)) consuming hq3
  have hq4 : S.mem.readQuad pp = seg A 4 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg A 4) (hP := hq4))
  step_call using (dbln_call (A := seg A 4) (hA := hq4)) consuming hq4
  have hq5 : S.mem.readQuad pp = seg A 5 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg A 5) (hP := hq5))
  step_call using (dbln_call (A := seg A 5) (hA := hq5)) consuming hq5
  have hq6 : S.mem.readQuad pp = seg A 6 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg A 6) (hP := hq6))
  step_call using (dbln_call (A := seg A 6) (hA := hq6)) consuming hq6
  have hq7 : S.mem.readQuad pp = seg A 7 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg A 7) (hP := hq7))
  step_pure
  finish_block
  have hN : S₀.alloc.nextFreeBlock ≤ pp.id.id := by slot_bound
  rw [hS]
  dsimp only
  rw [Firedancer.Lane.Split.storeTable_congr (f := fd_ed25519_split_table_a.spec A)
      (g := fun k => split_odd_table.spec (seg A (k / 4)) (k % 4)) fun k _ => rfl,
    Firedancer.Lane.Split.storeTable_eq_segs (a := 4) (n := 32)
      (f := fun j i => split_odd_table.spec (seg A j) i) (by decide) 8 rfl]
  simp only [MemoryState.storeSegs, Nat.reduceMul, Pointer.add_zero_quad,
    MemoryState.eraseFrom_lifetimeEnd_of_le hN, Firedancer.Lane.Split.eraseFrom_storeTable,
    MemoryState.eraseFrom_storeQuad_of_le hN]
  erase_frame
  simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]

end Proof

end MLIR.Firedancer.Lane
