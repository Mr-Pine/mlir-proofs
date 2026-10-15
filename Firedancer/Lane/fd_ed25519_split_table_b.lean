module

public import MLIR.Run.Tactic
public import Firedancer.Lane.fd_ed25519_split_table_a
public import Firedancer.Lane.Mlir.fd_ed25519_split_table_b

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

open Split fd_ed25519_split_table_a in
/-- `fd_ed25519_split_table_b` stores `spec`, 896 entries, as a table at `tbl`. Its frame is eight
blocks: `p` and the seven `split_odd_table`s' `p2`. -/
public theorem fd_ed25519_split_table_b.call_eq (tbl : Pointer) (s : GlobalState) (hwf : s.WF)
    (ht : Room s.mem tbl (1536 * 896)) (hto : tbl.offset.toNat + 192 * 896 < 2 ^ 64) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_split_table_b.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_split_table_b.args (.value tbl)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 8⟩
            mem := s.mem.storeTable tbl 896 fd_ed25519_split_table_b.spec }) := by
  have ht0 := Firedancer.Lane.Split.room_seg (k := 0) (c := 128) ht hto (by omega)
  have ht1 := Firedancer.Lane.Split.room_seg (k := 128) (c := 128) ht hto (by omega)
  have ht2 := Firedancer.Lane.Split.room_seg (k := 256) (c := 128) ht hto (by omega)
  have ht3 := Firedancer.Lane.Split.room_seg (k := 384) (c := 128) ht hto (by omega)
  have ht4 := Firedancer.Lane.Split.room_seg (k := 512) (c := 128) ht hto (by omega)
  have ht5 := Firedancer.Lane.Split.room_seg (k := 640) (c := 128) ht hto (by omega)
  have ht6 := Firedancer.Lane.Split.room_seg (k := 768) (c := 128) ht hto (by omega)
  simp only [Nat.reduceMul, Pointer.add_zero_quad] at ht0 ht1 ht2 ht3 ht4 ht5 ht6
  clear ht
  have hoff (c : Nat) (hc : c + 24576 ≤ 192 * 896) :
      (tbl.add (BitVec.ofNat 64 c)).offset.toNat + 24576 < 18446744073709551616 := by
    rw [Firedancer.Lane.Split.offset_add_ofNat (by omega)]; omega
  have ho1 := hoff 24576 (by decide)
  have ho2 := hoff 49152 (by decide)
  have ho3 := hoff 73728 (by decide)
  have ho4 := hoff 98304 (by decide)
  have ho5 := hoff 122880 (by decide)
  have ho6 := hoff 147456 (by decide)
  clear hoff
  func_init
  block_init
  iterate 6 step_pure
  -- fd_ed25519_point_t p[1]; fd_ed25519_point_set( p, fd_ed25519_base_point )
  step_alloca with pp
  step_pure
  step_store
  step_pure
  step_store
  step_pure
  step_store
  have hpq : S.mem.QuadFit pp := ⟨by rw [hpp_off]; decide, hfits_pp, hfits_pp_64, hfits_pp_128⟩
  have hP : S.mem.readQuad pp = seg fd_ed25519_split_table_b.base 0 := by
    rw [MemoryState.readQuad, MemoryState.readVec_packLanes hread_pp,
      MemoryState.readVec_packLanes hread_pp_64, MemoryState.readVec_packLanes hread_pp_128]
    rfl
  clear hwritable_pp hread_pp hread_pp_64 hread_pp_128
  -- for( int j=1; j<FD_ED25519_SPLIT_SEG_CNT; j++ ) { fd_ed25519_point_dbln( p, p, 32 );
  -- split_odd_table( tbl+128*(j-1), p, 128 ); }
  step_call using (dbln_call (A := seg fd_ed25519_split_table_b.base 0) (hA := hP)) consuming hP
  have hq1 : S.mem.readQuad pp = seg fd_ed25519_split_table_b.base 1 := hread_pp
  clear hread_pp
  step_call using (split_call (P := seg fd_ed25519_split_table_b.base 1) (hP := hq1))
  step_call using (dbln_call (A := seg fd_ed25519_split_table_b.base 1) (hA := hq1))
    consuming hq1
  have hq2 : S.mem.readQuad pp = seg fd_ed25519_split_table_b.base 2 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg fd_ed25519_split_table_b.base 2) (hP := hq2))
  step_call using (dbln_call (A := seg fd_ed25519_split_table_b.base 2) (hA := hq2))
    consuming hq2
  have hq3 : S.mem.readQuad pp = seg fd_ed25519_split_table_b.base 3 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg fd_ed25519_split_table_b.base 3) (hP := hq3))
  step_call using (dbln_call (A := seg fd_ed25519_split_table_b.base 3) (hA := hq3))
    consuming hq3
  have hq4 : S.mem.readQuad pp = seg fd_ed25519_split_table_b.base 4 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg fd_ed25519_split_table_b.base 4) (hP := hq4))
  step_call using (dbln_call (A := seg fd_ed25519_split_table_b.base 4) (hA := hq4))
    consuming hq4
  have hq5 : S.mem.readQuad pp = seg fd_ed25519_split_table_b.base 5 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg fd_ed25519_split_table_b.base 5) (hP := hq5))
  step_call using (dbln_call (A := seg fd_ed25519_split_table_b.base 5) (hA := hq5))
    consuming hq5
  have hq6 : S.mem.readQuad pp = seg fd_ed25519_split_table_b.base 6 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg fd_ed25519_split_table_b.base 6) (hP := hq6))
  step_call using (dbln_call (A := seg fd_ed25519_split_table_b.base 6) (hA := hq6))
    consuming hq6
  have hq7 : S.mem.readQuad pp = seg fd_ed25519_split_table_b.base 7 := hread_pp
  clear hread_pp
  step_pure
  step_call using (split_call (P := seg fd_ed25519_split_table_b.base 7) (hP := hq7))
  step_pure
  finish_block
  have hN : S₀.alloc.nextFreeBlock ≤ pp.id.id := by slot_bound
  rw [hS]
  dsimp only
  rw [Firedancer.Lane.Split.storeTable_congr (f := fd_ed25519_split_table_b.spec)
      (g := fun k => split_odd_table.spec (seg fd_ed25519_split_table_b.base (k / 128 + 1))
        (k % 128)) fun k _ => rfl,
    Firedancer.Lane.Split.storeTable_eq_segs (a := 128) (n := 896)
      (f := fun j i => split_odd_table.spec (seg fd_ed25519_split_table_b.base (j + 1)) i)
      (by decide) 7 rfl]
  simp only [MemoryState.storeSegs, Nat.reduceMul, Nat.reduceAdd, Pointer.add_zero_quad,
    MemoryState.eraseFrom_lifetimeEnd_of_le hN, Firedancer.Lane.Split.eraseFrom_storeTable,
    MemoryState.eraseFrom_storeQuad_of_le hN]
  erase_frame
  simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]

end Proof

end MLIR.Firedancer.Lane
