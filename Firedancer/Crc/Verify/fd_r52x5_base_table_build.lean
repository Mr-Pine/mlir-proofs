module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.Crc.Verify.fd_r52x5_ge_dbln
public import Firedancer.Crc.Verify.fd_r52x5_odd_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_split_table
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_build

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- The base point `B` as `fd_r52x5_base_table_build` stores it. -/
def fd_r52x5_base_table_build.B : Quad5 :=
  ⟨#v[1738742601995546, 1801439850948184, 1, 1841354044333475],
    #v[1146398526822698, 1351079888211148, 0, 16398895984059],
    #v[2070867633025821, 450359962737049, 0, 755974180946558],
    #v[562264141797630, 900719925474099, 0, 900171276175154],
    #v[587772402128613, 1801439850948198, 0, 1821297809914039]⟩

/-- `2^(33 k) B`: the point segment `k`'s table is built from. -/
def fd_r52x5_base_table_build.segBase : Nat → Quad5
  | 0 => B
  | k + 1 => fd_r52x5_ge_dbln.spec (segBase k)

/-- The memory `fd_r52x5_base_table_build` leaves: the odd multiples of `B` at `tb`, those of
`segBase k` at segment `k` of `ts` (`24576 k` bytes in). -/
def fd_r52x5_base_table_build.built (m : MemoryState) (tb ts : Pointer) : MemoryState :=
  let m := fd_r52x5_odd_table.storesFrom m tb (segBase 0) 0 128
  let m := fd_r52x5_odd_table.storesFrom m ts (segBase 1) 0 128
  let m := fd_r52x5_odd_table.storesFrom m (ts.add 24576#64) (segBase 2) 0 128
  let m := fd_r52x5_odd_table.storesFrom m (ts.add 49152#64) (segBase 3) 0 128
  let m := fd_r52x5_odd_table.storesFrom m (ts.add 73728#64) (segBase 4) 0 128
  let m := fd_r52x5_odd_table.storesFrom m (ts.add 98304#64) (segBase 5) 0 128
  let m := fd_r52x5_odd_table.storesFrom m (ts.add 122880#64) (segBase 6) 0 128
  fd_r52x5_odd_table.storesFrom m (ts.add 147456#64) (segBase 7) 0 128

end

/-! ## Proof -/

section Proof

/-! The table builder's memory through the steps: stores into the two tables only. -/

@[mlir_transport]
public theorem GlobalState.WF.built {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + 1 + 8 * 14730 + 7 * 2645⟩,
      fd_r52x5_base_table_build.built s.mem tb ts⟩ : GlobalState).WF := by
  have h' := (GlobalState.WF.add_blocks (k := 1 + 8 * 14730 + 7 * 2645) h)
  simp only [fd_r52x5_base_table_build.built]
  repeat apply GlobalState.WF.storesFrom
  simpa [Nat.add_assoc] using h'

@[mlir_mem, mlir_transport]
public theorem Fits.built {m : MemoryState} (h : Fits m p w) :
    Fits (fd_r52x5_base_table_build.built m tb ts) p w := by
  simp only [fd_r52x5_base_table_build.built]
  repeat apply Fits.storesFrom
  exact h

@[mlir_mem, mlir_transport]
public theorem Room.built {m : MemoryState} (h : Room m p w) :
    Room (fd_r52x5_base_table_build.built m tb ts) p w := by
  simp only [fd_r52x5_base_table_build.built]
  repeat apply Room.storesFrom
  exact h

@[mlir_mem, mlir_transport]
public theorem InBounds.built {m : MemoryState} (h : InBounds m p w) :
    InBounds (fd_r52x5_base_table_build.built m tb ts) p w := by
  simp only [fd_r52x5_base_table_build.built]
  repeat apply InBounds.storesFrom
  exact h

public theorem MemoryState.eraseFrom_built {m : MemoryState} :
    (fd_r52x5_base_table_build.built m tb ts).eraseFrom n =
      fd_r52x5_base_table_build.built (m.eraseFrom n) tb ts := by
  simp only [fd_r52x5_base_table_build.built, MemoryState.eraseFrom_storesFrom']

public theorem Writable.built {m : MemoryState} (h : Writable m p) :
    Writable (fd_r52x5_base_table_build.built m tb ts) p := by
  simp only [fd_r52x5_base_table_build.built]
  repeat apply Writable.storesFrom'
  exact h

/-- One segment of the build: `fd_r52x5_odd_table( t, q, c )`, then `fd_r52x5_ge_dbln( q, q )`. -/
def segRun (t q : Reg Γ .ptr) (c : Reg Γ (.bv 32)) : List (Instr Γ) :=
  [.call fd_r52x5_odd_table.call (.cons t (.cons q (.cons c .nil))) .nil,
    .call fd_r52x5_ge_dbln.call (.cons q (.cons q .nil)) .nil]

/-- Where the body at `pos` is `segRun`, `t` holds a table with room, `q` the point `X` and `c`
`128`: the table of `X`'s odd multiples at `t`, `2^33 X` at `q`, `14730 + 2645` blocks on. -/
theorem runBodyFrom_segRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {t q : Reg Γ .ptr} {c : Reg Γ (.bv 32)} {rest : List (Instr Γ)} {T Q : Pointer}
    {X : Quad5} {a : AllocState} {m : MemoryState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = segRun t q c ++ rest)
    (hR : E ⊨ [t := T, q := Q, c := 128#32])
    (hwf : (⟨a, m⟩ : GlobalState).WF) (hq : m.Quad5Fit Q) (hqw : Writable m Q)
    (hX : m.readQuad5 Q = X)
    (ht : oddTabRoom m T 128) (hto : T.offset.toNat + 192 * 128 < 2 ^ 64)
    (hTQ : T.id ≠ Q.id)
    (hK : (blk.runBodyFrom E (pos + 2)
      ⟨⟨a.nextFreeBlock + 14730 + 2645⟩, (fd_r52x5_odd_table.storesFrom m T X 0 128).storeQuad5 Q
        (fd_r52x5_ge_dbln.spec X)⟩ >>= g) = K) :
    (blk.runBodyFrom E pos ⟨a, m⟩ >>= g) = K := by
  have hqw1 := Writable.storesFrom' (tab := T) (A := X) hqw 128 0
  have hq1 := MemoryState.Quad5Fit.storesFrom (tab := T) (A := X) hq 128 0
  have hrd : (fd_r52x5_odd_table.storesFrom m T X 0 128).readQuad5 Q = X :=
    (MemoryState.readQuad5_storesFrom_of_id_ne hTQ 128 0).trans hX
  have hwf1 : (⟨⟨a.nextFreeBlock + 14730⟩, fd_r52x5_odd_table.storesFrom m T X 0 128⟩ :
      GlobalState).WF := GlobalState.WF.storesFrom_add (s := ⟨a, m⟩) hwf
  have hr1 := hq1.room hqw1
  have h1 := fd_r52x5_odd_table.call_eq T Q 128#32 _ hwf hq ht hto (by decide)
  have h2 := fd_r52x5_ge_dbln.call_eq Q Q _ hwf1 hr1 hq1
  simp only [hX, hrd] at h1 h2
  obtain ⟨hT, hQ, hc⟩ := hR
  have hb0 := hbody
  simp only [segRun, List.cons_append, List.nil_append] at hb0
  rw [BasicBlock.runBodyFrom_step_of_run (List.lt_length_of_drop_eq_cons hb0)
    (by
      rw [List.getElem_of_drop_eq_cons hb0]
      simp only [Instr.run, Regs.read_cons, Regs.read_nil, hT, hQ, hc]
      exact run_call h1)]
  have hb1 := List.drop_succ_of_drop_eq_cons hb0
  rw [BasicBlock.runBodyFrom_step_of_run (List.lt_length_of_drop_eq_cons hb1)
    (by
      rw [List.getElem_of_drop_eq_cons hb1]
      simp only [Instr.run, Regs.read_cons, Regs.read_nil, Env.writeMany, hQ]
      have e : (125 + 115 * ((128#32 : BitVec 32).toNat - 1)) = 14730 := by decide
      rw [e]
      exact run_call h2)]
  simpa only [Env.writeMany, Nat.add_assoc] using hK

/-- `runBodyFrom_segRun` carrying the facts the next segment reads: `q`'s point and writability,
and room `w` at `L`. -/
theorem runBodyFrom_segRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {t q : Reg Γ .ptr} {c : Reg Γ (.bv 32)} {rest : List (Instr Γ)} {T Q L : Pointer} {w : Nat}
    {X : Quad5} {a : AllocState} {m : MemoryState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = segRun t q c ++ rest)
    (hR : E ⊨ [t := T, q := Q, c := 128#32])
    (hwf : (⟨a, m⟩ : GlobalState).WF) (hq : m.Quad5Fit Q) (hqw : Writable m Q)
    (hX : m.readQuad5 Q = X)
    (ht : oddTabRoom m T 128) (hto : T.offset.toNat + 192 * 128 < 2 ^ 64)
    (hTQ : T.id ≠ Q.id) (hL : Room m L w)
    (hK : ∀ m' : MemoryState,
      m' = (fd_r52x5_odd_table.storesFrom m T X 0 128).storeQuad5 Q (fd_r52x5_ge_dbln.spec X) →
      (⟨⟨a.nextFreeBlock + 14730 + 2645⟩, m'⟩ : GlobalState).WF → m'.Quad5Fit Q →
      Writable m' Q → m'.readQuad5 Q = fd_r52x5_ge_dbln.spec X → Room m' L w →
      (blk.runBodyFrom E (pos + 2) ⟨⟨a.nextFreeBlock + 14730 + 2645⟩, m'⟩ >>= g) = K) :
    (blk.runBodyFrom E pos ⟨a, m⟩ >>= g) = K := by
  have hq1 := MemoryState.Quad5Fit.storesFrom (tab := T) (A := X) hq 128 0
  have hqw1 := Writable.storesFrom' (tab := T) (A := X) hqw 128 0
  refine runBodyFrom_segRun hbody hR hwf hq hqw hX ht hto hTQ (hK _ rfl ?_ hq1.storeQuad5
    hqw1.storeQuad5 (MemoryState.readQuad5_storeQuad5_self (hq1.room hqw1))
    (Room.storesFrom hL 128 0).storeQuad5)
  exact GlobalState.WF.storeQuad5_mk
    (GlobalState.WF.storesFrom (a := ⟨a.nextFreeBlock + 14730 + 2645⟩)
      (by simpa [Nat.add_assoc] using GlobalState.WF.add_blocks (k := 14730 + 2645) hwf) 128 0)

/-- `runBodyFrom_segRun'` over a state literal: the successor literal, with its facts. -/
theorem runBodyFrom_segRunM {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {t q : Reg Γ .ptr} {c : Reg Γ (.bv 32)} {rest : List (Instr Γ)} {T Q L : Pointer} {w : Nat}
    {X : Quad5} {n : Nat} {m : MemoryState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = segRun t q c ++ rest)
    (hR : E ⊨ [t := T, q := Q, c := 128#32])
    (hwf : (⟨⟨n⟩, m⟩ : GlobalState).WF) (hq : m.Quad5Fit Q) (hqw : Writable m Q)
    (hX : m.readQuad5 Q = X)
    (ht : Room m T (1536 * 128)) (hto : T.offset.toNat + 192 * 128 < 2 ^ 64)
    (hTQ : T.id ≠ Q.id) (hL : Room m L w)
    (hK : (⟨⟨n + 14730 + 2645⟩, (fd_r52x5_odd_table.storesFrom m T X 0 128).storeQuad5 Q
        (fd_r52x5_ge_dbln.spec X)⟩ : GlobalState).WF →
      ((fd_r52x5_odd_table.storesFrom m T X 0 128).storeQuad5 Q
        (fd_r52x5_ge_dbln.spec X)).Quad5Fit Q →
      Writable ((fd_r52x5_odd_table.storesFrom m T X 0 128).storeQuad5 Q
        (fd_r52x5_ge_dbln.spec X)) Q →
      ((fd_r52x5_odd_table.storesFrom m T X 0 128).storeQuad5 Q
        (fd_r52x5_ge_dbln.spec X)).readQuad5 Q = fd_r52x5_ge_dbln.spec X →
      Room ((fd_r52x5_odd_table.storesFrom m T X 0 128).storeQuad5 Q
        (fd_r52x5_ge_dbln.spec X)) L w →
      (blk.runBodyFrom E (pos + 2) ⟨⟨n + 14730 + 2645⟩,
        (fd_r52x5_odd_table.storesFrom m T X 0 128).storeQuad5 Q
          (fd_r52x5_ge_dbln.spec X)⟩ >>= g) = K) :
    (blk.runBodyFrom E pos ⟨⟨n⟩, m⟩ >>= g) = K :=
  runBodyFrom_segRun' hbody hR hwf hq hqw hX (by unfold oddTabRoom; exact ht) hto hTQ hL
    fun _ hm' hwf' hq' hqw' hX' hL' => by subst hm'; exact hK hwf' hq' hqw' hX' hL'

namespace fd_r52x5_base_table_build

theorem body26 :
    entry.body.drop 26 =
      segRun (rir_reg% hty 6) (rir_reg% hty 15) (rir_reg% hty 7) ++ entry.body.drop 28 :=
  rfl

theorem body28 :
    entry.body.drop 28 =
      segRun (rir_reg% hty 8) (rir_reg% hty 15) (rir_reg% hty 7) ++ entry.body.drop 30 :=
  rfl

theorem body30 :
    entry.body.drop 30 =
      segRun (rir_reg% hty 9) (rir_reg% hty 15) (rir_reg% hty 7) ++ entry.body.drop 32 :=
  rfl

theorem body32 :
    entry.body.drop 32 =
      segRun (rir_reg% hty 10) (rir_reg% hty 15) (rir_reg% hty 7) ++ entry.body.drop 34 :=
  rfl

theorem body34 :
    entry.body.drop 34 =
      segRun (rir_reg% hty 11) (rir_reg% hty 15) (rir_reg% hty 7) ++ entry.body.drop 36 :=
  rfl

theorem body36 :
    entry.body.drop 36 =
      segRun (rir_reg% hty 12) (rir_reg% hty 15) (rir_reg% hty 7) ++ entry.body.drop 38 :=
  rfl

theorem body38 :
    entry.body.drop 38 =
      segRun (rir_reg% hty 13) (rir_reg% hty 15) (rir_reg% hty 7) ++ entry.body.drop 40 :=
  rfl

end fd_r52x5_base_table_build

public theorem fd_r52x5_base_table_build.call_eq (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_r52x5_base_table_build.globals) (tbB tsB : BlockId)
    (hgb : s.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hgs : s.mem.globals "fd_r52x5_base_split_table" = some (tsB, fd_r52x5_base_split_table.image))
    (hl0 : Room s.mem ⟨tbB, 0⟩ 196608) (hl1 : Room s.mem ⟨tsB, 0⟩ 1376256) :
    fd_r52x5_base_table_build.call fd_r52x5_base_table_build.args s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1 + 8 * 14730 + 7 * 2645⟩,
            mem := fd_r52x5_base_table_build.built s.mem ⟨tbB, 0⟩ ⟨tsB, 0⟩ }) := by
  func_init
  block_init
  iterate 6 step_pure
  step_addressof with tb
  step_pure
  step_addressof with ts
  have htb : tb = ⟨tbB, 0⟩ := by
    have := hglobal_tb.symm.trans hgb
    simp only [Option.some.injEq, Prod.mk.injEq] at this
    cases tb; simp_all
  have hts : ts = ⟨tsB, 0⟩ := by
    have := hglobal_ts.symm.trans hgs
    simp only [Option.some.injEq, Prod.mk.injEq] at this
    cases ts; simp_all
  subst htb hts
  have hne : tbB ≠ tsB := by
    intro e
    have := hwf.merged _ _ _ _ _ hgb (e ▸ hgs) (by decide)
    simp [GlobalInitializer.image_constant] at this

  clear hg hgb hgs hglobal_tb hglobal_ts
  iterate 6 step_pure
  step_alloca with q
  step_pure
  step_store
  iterate 4 (step_pure; step_store)
  have hqf : S.mem.Quad5Fit q := ⟨by rw [hq_off]; decide, hfits_q, hfits_q_32, hfits_q_64,
    hfits_q_96, hfits_q_128⟩
  have hB : S.mem.readQuad5 q = fd_r52x5_base_table_build.B := by
    have e0 := MemoryState.readWv_packLanes hread_q
    have e1 := MemoryState.readWv_packLanes hread_q_32
    have e2 := MemoryState.readWv_packLanes hread_q_64
    have e3 := MemoryState.readWv_packLanes hread_q_96
    have e4 := MemoryState.readWv_packLanes hread_q_128
    unfold MemoryState.readQuad5
    rw [e0, e1, e2, e3, e4]
    rfl
  clear hqf
  have hqf : S.mem.Quad5Fit q := by
    refine ⟨by rw [hq_off]; decide, ?_, ?_, ?_, ?_, ?_⟩ <;> mem_fact
  clear htb_bounds hwritable_tb hts_bounds hwritable_ts hwritable_q hq_bounds
  have hqw : Writable S.mem q := by mem_fact
  clear hfits_q_128 hfits_q_96 hfits_q_64 hfits_q_32 hfits_q hroom_q hread_q hread_q_32 hread_q_64
    hread_q_96 hread_q_128
  have hR : E ⊨ [rir_reg% hty 6 := (⟨tbB, 0⟩ : Pointer), rir_reg% hty 8 := (⟨tsB, 0⟩ : Pointer),
      rir_reg% hty 9 := (⟨tsB, 0⟩ : Pointer).add 24576#64,
      rir_reg% hty 10 := (⟨tsB, 0⟩ : Pointer).add 49152#64,
      rir_reg% hty 11 := (⟨tsB, 0⟩ : Pointer).add 73728#64,
      rir_reg% hty 12 := (⟨tsB, 0⟩ : Pointer).add 98304#64,
      rir_reg% hty 13 := (⟨tsB, 0⟩ : Pointer).add 122880#64, rir_reg% hty 15 := q,
      rir_reg% hty 7 := (128#32 : BitVec 32)] := by
    rw [hE]; lemma_reads
  obtain ⟨hr6, hr8, hr9, hr10, hr11, hr12, hr13, hr15, hr7⟩ := hR
  have htq : tbB ≠ q.id := fun e => by
    have := hwf₀.lt hl0₀.mem; rw [hq] at e; rw [e] at this; simp [GlobalState.slot] at this
  have hsq (k : BitVec 64) : ((⟨tsB, 0⟩ : Pointer).add k).id ≠ q.id := fun e => by
    have := hwf₀.lt hl1₀.mem; rw [hq] at e; simp only [Pointer.add_id] at e; rw [e] at this
    simp [GlobalState.slot] at this
  have hal : S.alloc = ⟨S₀.alloc.nextFreeBlock + 1⟩ := by rw [hS]; rfl
  obtain ⟨a, m⟩ := S
  simp only at hal hS hwf hqf hqw hB hl0 hl1
  have hm : m = ((((((S₀.alloca 192 true).mem.lifetimeStart q).storeAt q
      (BitVec.packLanes fd_r52x5_base_table_build.B.P0)).storeAt (q.add 32#64)
      (BitVec.packLanes fd_r52x5_base_table_build.B.P1)).storeAt (q.add 64#64)
      (BitVec.packLanes fd_r52x5_base_table_build.B.P2)).storeAt (q.add 96#64)
      (BitVec.packLanes fd_r52x5_base_table_build.B.P3)).storeAt (q.add 128#64)
      (BitVec.packLanes fd_r52x5_base_table_build.B.P4) := congrArg GlobalState.mem hS
  clear hS
  subst hal
  obtain ⟨m0, hm0⟩ : ∃ m0, m0 = m := ⟨_, rfl⟩
  rw [← hm0] at hwf hqf hqw hB hl0 hl1 ⊢
  refine runBodyFrom_segRunM (L := ⟨tsB, 0⟩) (blk := entry) fd_r52x5_base_table_build.body26
    ⟨hr6, hr15, hr7⟩ hwf hqf hqw hB hl0 (by simp) htq hl1
    fun hwf1 hqf1 hqw1 hB1 hl1' => ?_
  clear hwf hqf hqw hB hl0 hl1
  refine runBodyFrom_segRunM (L := ⟨tsB, 0⟩) (blk := entry) fd_r52x5_base_table_build.body28
    ⟨hr8, hr15, hr7⟩ hwf1 hqf1 hqw1 hB1 (hl1'.mono (by omega)) (by simp) (hsq 0) hl1'
    fun hwf2 hqf2 hqw2 hB2 hl2' => ?_
  clear hwf1 hqf1 hqw1 hB1 hl1'
  refine runBodyFrom_segRunM (L := ⟨tsB, 0⟩) (blk := entry) fd_r52x5_base_table_build.body30
    ⟨hr9, hr15, hr7⟩ hwf2 hqf2 hqw2 hB2
    (Room.add_of_le (by simp [BitVec.uaddOverflow]) (by simp) hl2') (by simp [Pointer.add])
    (hsq _) hl2'
    fun hwf3 hqf3 hqw3 hB3 hl3' => ?_
  clear hwf2 hqf2 hqw2 hB2 hl2'
  refine runBodyFrom_segRunM (L := ⟨tsB, 0⟩) (blk := entry) fd_r52x5_base_table_build.body32
    ⟨hr10, hr15, hr7⟩ hwf3 hqf3 hqw3 hB3
    (Room.add_of_le (by simp [BitVec.uaddOverflow]) (by simp) hl3') (by simp [Pointer.add])
    (hsq _) hl3'
    fun hwf4 hqf4 hqw4 hB4 hl4' => ?_
  clear hwf3 hqf3 hqw3 hB3 hl3'
  refine runBodyFrom_segRunM (L := ⟨tsB, 0⟩) (blk := entry) fd_r52x5_base_table_build.body34
    ⟨hr11, hr15, hr7⟩ hwf4 hqf4 hqw4 hB4
    (Room.add_of_le (by simp [BitVec.uaddOverflow]) (by simp) hl4') (by simp [Pointer.add])
    (hsq _) hl4'
    fun hwf5 hqf5 hqw5 hB5 hl5' => ?_
  clear hwf4 hqf4 hqw4 hB4 hl4'
  refine runBodyFrom_segRunM (L := ⟨tsB, 0⟩) (blk := entry) fd_r52x5_base_table_build.body36
    ⟨hr12, hr15, hr7⟩ hwf5 hqf5 hqw5 hB5
    (Room.add_of_le (by simp [BitVec.uaddOverflow]) (by simp) hl5') (by simp [Pointer.add])
    (hsq _) hl5'
    fun hwf6 hqf6 hqw6 hB6 hl6' => ?_
  clear hwf5 hqf5 hqw5 hB5 hl5'
  refine runBodyFrom_segRunM (L := ⟨tsB, 0⟩) (blk := entry) fd_r52x5_base_table_build.body38
    ⟨hr13, hr15, hr7⟩ hwf6 hqf6 hqw6 hB6
    (Room.add_of_le (by simp [BitVec.uaddOverflow]) (by simp) hl6') (by simp [Pointer.add])
    (hsq _) hl6'
    fun hwf7 hqf7 hqw7 hB7 hl7' => ?_
  clear hwf6 hqf6 hqw6 hB6 hl6'
  generalize hM : (fd_r52x5_odd_table.storesFrom _ _ _ 0 128).storeQuad5 q _ = M
    at hwf7 hqf7 hqw7 hB7 hl7' ⊢
  generalize hN : S₀.alloc.nextFreeBlock + 1 + 14730 + 2645 + 14730 + 2645 + 14730 + 2645 + 14730 +
    2645 + 14730 + 2645 + 14730 + 2645 + 14730 + 2645 = N at hwf7 ⊢
  obtain ⟨S, hS⟩ : ∃ S, S = (⟨⟨N⟩, M⟩ : GlobalState) := ⟨_, rfl⟩
  rw [← hS] at hwf7 ⊢
  have hqf : S.mem.Quad5Fit q := by rw [hS]; exact hqf7
  have ht0 : oddTabRoom S.mem ((⟨tsB, 0⟩ : Pointer).add 147456#64) 128 := by
    rw [hS]; unfold oddTabRoom
    exact Room.add_of_le (by simp [BitVec.uaddOverflow]) (by simp) hl7'
  clear hqf7 hqw7 hl7'
  step_call using (fd_r52x5_odd_table.call_eq ((⟨tsB, 0⟩ : Pointer).add 147456#64) q 128#32 S hwf7
    hqf ht0 (by simp [Pointer.add]) (by decide)) consuming hqf ht0 hwf7
  step_pure
  finish_block
  subst hS hN hM hm0 hm
  rw [hB7]
  have hqb : S₀.alloc.nextFreeBlock ≤ q.id.id := by rw [hq]; slot_bound
  have hqb' (k : BitVec 64) : S₀.alloc.nextFreeBlock ≤ (q.add k).id.id := hqb
  simp only [MemoryState.eraseFrom_lifetimeEnd_of_le hqb, MemoryState.eraseFrom_storesFrom',
    MemoryState.eraseFrom_storeQuad5_of_le hqb, MemoryState.eraseFrom_storeAt_of_le (hqb' _),
    MemoryState.eraseFrom_storeAt_of_le hqb, MemoryState.eraseFrom_lifetimeStart_of_le hqb,
    GlobalState.eraseFrom_alloca]
  have he := congrArg GlobalState.mem (GlobalState.eraseFrom_self hwf₀)
  simp only at he
  rw [he]
  have hal : S₀.alloc.nextFreeBlock + 1 + 14730 + 2645 + 14730 + 2645 + 14730 + 2645 + 14730 +
      2645 + 14730 + 2645 + 14730 + 2645 + 14730 + 2645 + 14730 =
      S₀.alloc.nextFreeBlock + 1 + 8 * 14730 + 7 * 2645 := by
    simp only [Nat.add_assoc, Nat.reduceAdd, Nat.reduceMul]
  simp only [hal]
  rfl

end Proof

end MLIR.Firedancer.Crc.Verify
