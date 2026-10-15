module

public import Firedancer.Lane.verify_x8.TableMem

/-! The hand-overs inside `verify_x8`'s table block `^bb79`: at the positions where one entry's
`fd_ed25519_lane_to_niels` ends, the registers live there (`EnvT…`) and the memory (`StT…`), over
the slots `kt` (`ktab`), `k2` (`k2d`), `n1`, `p2`, `p3`, `p4`, `p6`, `tmp`, `acc` and `a`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

@[expose] public section

/-- The points of `ktab`'s entries `2 … 8`, in `fd_ed25519_lane_verify`'s order. -/
noncomputable def Call.tabPt (c : Call) : Nat → Point :=
  let n1 := c.aNeg.toNiels lc.k2d
  let p2 := c.aNeg.dbl true Fe.zero
  let p3 := p2.add n1 true true Fe.zero
  let p4 := p2.dbl true Fe.zero
  let p5 := p4.add n1 true true Fe.zero
  let p6 := p3.dbl true Fe.zero
  let p7 := p6.add n1 true true Fe.zero
  let p8 := p4.dbl true Fe.zero
  fun e => match e with
    | 2 => p2
    | 3 => p3
    | 4 => p4
    | 5 => p5
    | 6 => p6
    | 7 => p7
    | _ => p8

/-- The slots of the table's objects. -/
abbrev Ptrs (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) : Prop :=
  kt = c.s.slot 3 ∧ k2 = c.s.slot 4 ∧ n1 = c.s.slot 5 ∧ p2 = c.s.slot 6 ∧ p3 = c.s.slot 7 ∧
    p4 = c.s.slot 8 ∧ p6 = c.s.slot 9 ∧ tmp = c.s.slot 10 ∧ acc = c.s.slot 11 ∧ a = c.s.slot 28

variable {β : Type}

/-- What `^bb79` does after its body: its jump, then the rest of `verify_x8`, then `g`. -/
noncomputable abbrev G79 (c : Call) (g : Vals [] × GlobalState → PoisonOr β) :
    ⟪Γ⟫ × GlobalState → PoisonOr β :=
  fun x =>
    Exit.run _root_.Firedancer.Lane.Mlir.verify_x8.blockParams x.1
        _root_.Firedancer.Lane.Mlir.verify_x8.bb79.exit x.2 >>= fun x =>
      Func.continue (func := verify_x8 c.batch) x.1.1 x.1.2 x.2 >>= g

/-- The memory at the start of `^bb79`. -/
abbrev StT0 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    InBounds S.mem kt (8 * 14400) ∧ Writable S.mem kt ∧
    InBounds S.mem k2 (8 * 320) ∧ Writable S.mem k2 ∧
    InBounds S.mem n1 (8 * 1600) ∧ Writable S.mem n1 ∧
    InBounds S.mem p2 (8 * 1280) ∧ Writable S.mem p2 ∧
    InBounds S.mem p3 (8 * 1280) ∧ Writable S.mem p3 ∧
    InBounds S.mem p4 (8 * 1280) ∧ Writable S.mem p4 ∧
    InBounds S.mem p6 (8 * 1280) ∧ Writable S.mem p6 ∧
    InBounds S.mem tmp (8 * 1280) ∧ Writable S.mem tmp ∧
    InBounds S.mem acc (8 * 1280) ∧ Writable S.mem acc ∧
    S.mem.LanePointFit a ∧
    S.mem.readLanePoint a = c.aNeg

/-- The memory at position 243 of `^bb79`. -/
abbrev StT243 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    Room S.mem kt (8 * 14400) ∧
    Fits S.mem (kt.add 0#64) 12800 ∧
    S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits ∧
    Fits S.mem (kt.add 1600#64) 12800 ∧
    S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits ∧
    S.mem.FeFit k2 ∧
    S.mem.readAt k2 512 = BitVec.packLanes lc.k2d.l0 ∧
    S.mem.readAt (k2.add 64#64) 512 = BitVec.packLanes lc.k2d.l1 ∧
    S.mem.readAt (k2.add 128#64) 512 = BitVec.packLanes lc.k2d.l2 ∧
    S.mem.readAt (k2.add 192#64) 512 = BitVec.packLanes lc.k2d.l3 ∧
    S.mem.readAt (k2.add 256#64) 512 = BitVec.packLanes lc.k2d.l4 ∧
    S.mem.NielsFit n1 ∧
    S.mem.readNiels n1 = c.tab 1 ∧
    Room S.mem p2 (8 * 1280) ∧
    Room S.mem p3 (8 * 1280) ∧
    Room S.mem p4 (8 * 1280) ∧
    Room S.mem p6 (8 * 1280) ∧
    Room S.mem tmp (8 * 1280) ∧
    InBounds S.mem acc (8 * 1280) ∧
    Writable S.mem acc ∧
    S.mem.LanePointFit a ∧
    S.mem.readLanePoint a = c.aNeg

/-- The memory at position 465 of `^bb79`. -/
abbrev StT465 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc _a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    Room S.mem kt (8 * 14400) ∧
    Fits S.mem (kt.add 0#64) 12800 ∧
    S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits ∧
    Fits S.mem (kt.add 1600#64) 12800 ∧
    S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits ∧
    Fits S.mem (kt.add 3200#64) 12800 ∧
    S.mem.readAt (kt.add 3200#64) 12800 = (c.tab 2).bits ∧
    S.mem.FeFit k2 ∧
    S.mem.readAt k2 512 = BitVec.packLanes lc.k2d.l0 ∧
    S.mem.readAt (k2.add 64#64) 512 = BitVec.packLanes lc.k2d.l1 ∧
    S.mem.readAt (k2.add 128#64) 512 = BitVec.packLanes lc.k2d.l2 ∧
    S.mem.readAt (k2.add 192#64) 512 = BitVec.packLanes lc.k2d.l3 ∧
    S.mem.readAt (k2.add 256#64) 512 = BitVec.packLanes lc.k2d.l4 ∧
    S.mem.NielsFit n1 ∧
    S.mem.readNiels n1 = c.tab 1 ∧
    S.mem.LanePointFit p2 ∧
    S.mem.readLanePoint p2 = c.tabPt 2 ∧
    Room S.mem p3 (8 * 1280) ∧
    Room S.mem p4 (8 * 1280) ∧
    Room S.mem p6 (8 * 1280) ∧
    Room S.mem tmp (8 * 1280) ∧
    InBounds S.mem acc (8 * 1280) ∧
    Writable S.mem acc

/-- The memory at position 687 of `^bb79`. -/
abbrev StT687 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc _a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    Room S.mem kt (8 * 14400) ∧
    Fits S.mem (kt.add 0#64) 12800 ∧
    S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits ∧
    Fits S.mem (kt.add 1600#64) 12800 ∧
    S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits ∧
    Fits S.mem (kt.add 3200#64) 12800 ∧
    S.mem.readAt (kt.add 3200#64) 12800 = (c.tab 2).bits ∧
    Fits S.mem (kt.add 4800#64) 12800 ∧
    S.mem.readAt (kt.add 4800#64) 12800 = (c.tab 3).bits ∧
    S.mem.FeFit k2 ∧
    S.mem.readAt k2 512 = BitVec.packLanes lc.k2d.l0 ∧
    S.mem.readAt (k2.add 64#64) 512 = BitVec.packLanes lc.k2d.l1 ∧
    S.mem.readAt (k2.add 128#64) 512 = BitVec.packLanes lc.k2d.l2 ∧
    S.mem.readAt (k2.add 192#64) 512 = BitVec.packLanes lc.k2d.l3 ∧
    S.mem.readAt (k2.add 256#64) 512 = BitVec.packLanes lc.k2d.l4 ∧
    S.mem.NielsFit n1 ∧
    S.mem.readNiels n1 = c.tab 1 ∧
    S.mem.LanePointFit p2 ∧
    S.mem.readLanePoint p2 = c.tabPt 2 ∧
    S.mem.LanePointFit p3 ∧
    S.mem.readLanePoint p3 = c.tabPt 3 ∧
    Room S.mem p4 (8 * 1280) ∧
    Room S.mem p6 (8 * 1280) ∧
    Room S.mem tmp (8 * 1280) ∧
    InBounds S.mem acc (8 * 1280) ∧
    Writable S.mem acc

/-- The memory at position 909 of `^bb79`. -/
abbrev StT909 (c : Call) (M₀ : MemoryState) (kt k2 n1 _p2 p3 p4 p6 tmp acc _a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    Room S.mem kt (8 * 14400) ∧
    Fits S.mem (kt.add 0#64) 12800 ∧
    S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits ∧
    Fits S.mem (kt.add 1600#64) 12800 ∧
    S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits ∧
    Fits S.mem (kt.add 3200#64) 12800 ∧
    S.mem.readAt (kt.add 3200#64) 12800 = (c.tab 2).bits ∧
    Fits S.mem (kt.add 4800#64) 12800 ∧
    S.mem.readAt (kt.add 4800#64) 12800 = (c.tab 3).bits ∧
    Fits S.mem (kt.add 6400#64) 12800 ∧
    S.mem.readAt (kt.add 6400#64) 12800 = (c.tab 4).bits ∧
    S.mem.FeFit k2 ∧
    S.mem.readAt k2 512 = BitVec.packLanes lc.k2d.l0 ∧
    S.mem.readAt (k2.add 64#64) 512 = BitVec.packLanes lc.k2d.l1 ∧
    S.mem.readAt (k2.add 128#64) 512 = BitVec.packLanes lc.k2d.l2 ∧
    S.mem.readAt (k2.add 192#64) 512 = BitVec.packLanes lc.k2d.l3 ∧
    S.mem.readAt (k2.add 256#64) 512 = BitVec.packLanes lc.k2d.l4 ∧
    S.mem.NielsFit n1 ∧
    S.mem.readNiels n1 = c.tab 1 ∧
    S.mem.LanePointFit p3 ∧
    S.mem.readLanePoint p3 = c.tabPt 3 ∧
    S.mem.LanePointFit p4 ∧
    S.mem.readLanePoint p4 = c.tabPt 4 ∧
    Room S.mem p6 (8 * 1280) ∧
    Room S.mem tmp (8 * 1280) ∧
    InBounds S.mem acc (8 * 1280) ∧
    Writable S.mem acc

/-- The memory at position 1131 of `^bb79`. -/
abbrev StT1131 (c : Call) (M₀ : MemoryState) (kt k2 n1 _p2 p3 p4 p6 tmp acc _a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    Room S.mem kt (8 * 14400) ∧
    Fits S.mem (kt.add 0#64) 12800 ∧
    S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits ∧
    Fits S.mem (kt.add 1600#64) 12800 ∧
    S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits ∧
    Fits S.mem (kt.add 3200#64) 12800 ∧
    S.mem.readAt (kt.add 3200#64) 12800 = (c.tab 2).bits ∧
    Fits S.mem (kt.add 4800#64) 12800 ∧
    S.mem.readAt (kt.add 4800#64) 12800 = (c.tab 3).bits ∧
    Fits S.mem (kt.add 6400#64) 12800 ∧
    S.mem.readAt (kt.add 6400#64) 12800 = (c.tab 4).bits ∧
    Fits S.mem (kt.add 8000#64) 12800 ∧
    S.mem.readAt (kt.add 8000#64) 12800 = (c.tab 5).bits ∧
    S.mem.FeFit k2 ∧
    S.mem.readAt k2 512 = BitVec.packLanes lc.k2d.l0 ∧
    S.mem.readAt (k2.add 64#64) 512 = BitVec.packLanes lc.k2d.l1 ∧
    S.mem.readAt (k2.add 128#64) 512 = BitVec.packLanes lc.k2d.l2 ∧
    S.mem.readAt (k2.add 192#64) 512 = BitVec.packLanes lc.k2d.l3 ∧
    S.mem.readAt (k2.add 256#64) 512 = BitVec.packLanes lc.k2d.l4 ∧
    S.mem.NielsFit n1 ∧
    S.mem.readNiels n1 = c.tab 1 ∧
    S.mem.LanePointFit p3 ∧
    S.mem.readLanePoint p3 = c.tabPt 3 ∧
    S.mem.LanePointFit p4 ∧
    S.mem.readLanePoint p4 = c.tabPt 4 ∧
    Room S.mem p6 (8 * 1280) ∧
    Room S.mem tmp (8 * 1280) ∧
    InBounds S.mem acc (8 * 1280) ∧
    Writable S.mem acc

/-- The memory at position 1353 of `^bb79`. -/
abbrev StT1353 (c : Call) (M₀ : MemoryState) (kt k2 n1 _p2 _p3 p4 p6 tmp acc _a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    Room S.mem kt (8 * 14400) ∧
    Fits S.mem (kt.add 0#64) 12800 ∧
    S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits ∧
    Fits S.mem (kt.add 1600#64) 12800 ∧
    S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits ∧
    Fits S.mem (kt.add 3200#64) 12800 ∧
    S.mem.readAt (kt.add 3200#64) 12800 = (c.tab 2).bits ∧
    Fits S.mem (kt.add 4800#64) 12800 ∧
    S.mem.readAt (kt.add 4800#64) 12800 = (c.tab 3).bits ∧
    Fits S.mem (kt.add 6400#64) 12800 ∧
    S.mem.readAt (kt.add 6400#64) 12800 = (c.tab 4).bits ∧
    Fits S.mem (kt.add 8000#64) 12800 ∧
    S.mem.readAt (kt.add 8000#64) 12800 = (c.tab 5).bits ∧
    Fits S.mem (kt.add 9600#64) 12800 ∧
    S.mem.readAt (kt.add 9600#64) 12800 = (c.tab 6).bits ∧
    S.mem.FeFit k2 ∧
    S.mem.readAt k2 512 = BitVec.packLanes lc.k2d.l0 ∧
    S.mem.readAt (k2.add 64#64) 512 = BitVec.packLanes lc.k2d.l1 ∧
    S.mem.readAt (k2.add 128#64) 512 = BitVec.packLanes lc.k2d.l2 ∧
    S.mem.readAt (k2.add 192#64) 512 = BitVec.packLanes lc.k2d.l3 ∧
    S.mem.readAt (k2.add 256#64) 512 = BitVec.packLanes lc.k2d.l4 ∧
    S.mem.NielsFit n1 ∧
    S.mem.readNiels n1 = c.tab 1 ∧
    S.mem.LanePointFit p4 ∧
    S.mem.readLanePoint p4 = c.tabPt 4 ∧
    S.mem.LanePointFit p6 ∧
    S.mem.readLanePoint p6 = c.tabPt 6 ∧
    Room S.mem tmp (8 * 1280) ∧
    InBounds S.mem acc (8 * 1280) ∧
    Writable S.mem acc

/-- The memory at position 1561 of `^bb79`. -/
abbrev StT1561 (c : Call) (M₀ : MemoryState) (kt _k2 _n1 _p2 _p3 p4 _p6 tmp acc _a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    Room S.mem kt (8 * 14400) ∧
    Fits S.mem (kt.add 0#64) 12800 ∧
    S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits ∧
    Fits S.mem (kt.add 1600#64) 12800 ∧
    S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits ∧
    Fits S.mem (kt.add 3200#64) 12800 ∧
    S.mem.readAt (kt.add 3200#64) 12800 = (c.tab 2).bits ∧
    Fits S.mem (kt.add 4800#64) 12800 ∧
    S.mem.readAt (kt.add 4800#64) 12800 = (c.tab 3).bits ∧
    Fits S.mem (kt.add 6400#64) 12800 ∧
    S.mem.readAt (kt.add 6400#64) 12800 = (c.tab 4).bits ∧
    Fits S.mem (kt.add 8000#64) 12800 ∧
    S.mem.readAt (kt.add 8000#64) 12800 = (c.tab 5).bits ∧
    Fits S.mem (kt.add 9600#64) 12800 ∧
    S.mem.readAt (kt.add 9600#64) 12800 = (c.tab 6).bits ∧
    Fits S.mem (kt.add 11200#64) 12800 ∧
    S.mem.readAt (kt.add 11200#64) 12800 = (c.tab 7).bits ∧
    S.mem.LanePointFit p4 ∧
    S.mem.readLanePoint p4 = c.tabPt 4 ∧
    Room S.mem tmp (8 * 1280) ∧
    InBounds S.mem acc (8 * 1280) ∧
    Writable S.mem acc

/-- The memory at position 1764 of `^bb79`. -/
abbrev StT1764 (c : Call) (M₀ : MemoryState) (kt _k2 _n1 _p2 _p3 _p4 _p6 tmp acc _a : Pointer)
    (S : GlobalState) : Prop :=
  S.WF ∧
    M₀.FrameOn S.mem (Keep c) ∧
    Room S.mem kt (8 * 14400) ∧
    Fits S.mem (kt.add 0#64) 12800 ∧
    S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits ∧
    Fits S.mem (kt.add 1600#64) 12800 ∧
    S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits ∧
    Fits S.mem (kt.add 3200#64) 12800 ∧
    S.mem.readAt (kt.add 3200#64) 12800 = (c.tab 2).bits ∧
    Fits S.mem (kt.add 4800#64) 12800 ∧
    S.mem.readAt (kt.add 4800#64) 12800 = (c.tab 3).bits ∧
    Fits S.mem (kt.add 6400#64) 12800 ∧
    S.mem.readAt (kt.add 6400#64) 12800 = (c.tab 4).bits ∧
    Fits S.mem (kt.add 8000#64) 12800 ∧
    S.mem.readAt (kt.add 8000#64) 12800 = (c.tab 5).bits ∧
    Fits S.mem (kt.add 9600#64) 12800 ∧
    S.mem.readAt (kt.add 9600#64) 12800 = (c.tab 6).bits ∧
    Fits S.mem (kt.add 11200#64) 12800 ∧
    S.mem.readAt (kt.add 11200#64) 12800 = (c.tab 7).bits ∧
    Fits S.mem (kt.add 12800#64) 12800 ∧
    S.mem.readAt (kt.add 12800#64) 12800 = (c.tab 8).bits ∧
    Room S.mem tmp (8 * 1280) ∧
    InBounds S.mem acc (8 * 1280) ∧
    Writable S.mem acc


/-- The registers live at position 0 of `^bb79`. -/
abbrev EnvT0 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64,
    %25 := Ty.wrap #v[3934839304537#64, 507525298899#64, 15037786634#64, 521695520920#64,
      6596238350568#64, 309467527341#64, 0#64, 0#64], %28 := PoisonOr.value 15#64,
    %29 := PoisonOr.value 10#64, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64), %99 := PoisonOr.value 576#64,
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask),
    rir_reg% hty 2115 := PoisonOr.value (a.add 64#64),
    rir_reg% hty 2118 := PoisonOr.value (a.add 128#64),
    rir_reg% hty 2121 := PoisonOr.value (a.add 192#64),
    rir_reg% hty 2124 := PoisonOr.value (a.add 256#64),
    rir_reg% hty 2142 := PoisonOr.value (a.add 960#64),
    rir_reg% hty 2158 := PoisonOr.value (a.add 1024#64),
    rir_reg% hty 2160 := PoisonOr.value (a.add 1088#64),
    rir_reg% hty 2162 := PoisonOr.value (a.add 1152#64),
    rir_reg% hty 2164 := PoisonOr.value (a.add 1216#64)]

/-- The registers live at position 243 of `^bb79`. -/
abbrev EnvT243 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64,
    %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask), rir_reg% hty 2277 := Ty.wrap lc.k2d.l0,
    rir_reg% hty 2278 := PoisonOr.value (k2.add 64#64), rir_reg% hty 2279 := Ty.wrap lc.k2d.l1,
    rir_reg% hty 2280 := PoisonOr.value (k2.add 128#64), rir_reg% hty 2281 := Ty.wrap lc.k2d.l2,
    rir_reg% hty 2282 := PoisonOr.value (k2.add 192#64), rir_reg% hty 2283 := Ty.wrap lc.k2d.l3,
    rir_reg% hty 2284 := PoisonOr.value (k2.add 256#64), rir_reg% hty 2285 := Ty.wrap lc.k2d.l4]

/-- The registers live at position 465 of `^bb79`. -/
abbrev EnvT465 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64,
    %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask), rir_reg% hty 2277 := Ty.wrap lc.k2d.l0,
    rir_reg% hty 2278 := PoisonOr.value (k2.add 64#64), rir_reg% hty 2279 := Ty.wrap lc.k2d.l1,
    rir_reg% hty 2280 := PoisonOr.value (k2.add 128#64), rir_reg% hty 2281 := Ty.wrap lc.k2d.l2,
    rir_reg% hty 2282 := PoisonOr.value (k2.add 192#64), rir_reg% hty 2283 := Ty.wrap lc.k2d.l3,
    rir_reg% hty 2284 := PoisonOr.value (k2.add 256#64), rir_reg% hty 2285 := Ty.wrap lc.k2d.l4]

/-- The registers live at position 687 of `^bb79`. -/
abbrev EnvT687 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64,
    %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask), rir_reg% hty 2277 := Ty.wrap lc.k2d.l0,
    rir_reg% hty 2278 := PoisonOr.value (k2.add 64#64), rir_reg% hty 2279 := Ty.wrap lc.k2d.l1,
    rir_reg% hty 2280 := PoisonOr.value (k2.add 128#64), rir_reg% hty 2281 := Ty.wrap lc.k2d.l2,
    rir_reg% hty 2282 := PoisonOr.value (k2.add 192#64), rir_reg% hty 2283 := Ty.wrap lc.k2d.l3,
    rir_reg% hty 2284 := PoisonOr.value (k2.add 256#64), rir_reg% hty 2285 := Ty.wrap lc.k2d.l4]

/-- The registers live at position 909 of `^bb79`. -/
abbrev EnvT909 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64,
    %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask), rir_reg% hty 2277 := Ty.wrap lc.k2d.l0,
    rir_reg% hty 2278 := PoisonOr.value (k2.add 64#64), rir_reg% hty 2279 := Ty.wrap lc.k2d.l1,
    rir_reg% hty 2280 := PoisonOr.value (k2.add 128#64), rir_reg% hty 2281 := Ty.wrap lc.k2d.l2,
    rir_reg% hty 2282 := PoisonOr.value (k2.add 192#64), rir_reg% hty 2283 := Ty.wrap lc.k2d.l3,
    rir_reg% hty 2284 := PoisonOr.value (k2.add 256#64), rir_reg% hty 2285 := Ty.wrap lc.k2d.l4]

/-- The registers live at position 1131 of `^bb79`. -/
abbrev EnvT1131 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64,
    %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask), rir_reg% hty 2277 := Ty.wrap lc.k2d.l0,
    rir_reg% hty 2278 := PoisonOr.value (k2.add 64#64), rir_reg% hty 2279 := Ty.wrap lc.k2d.l1,
    rir_reg% hty 2280 := PoisonOr.value (k2.add 128#64), rir_reg% hty 2281 := Ty.wrap lc.k2d.l2,
    rir_reg% hty 2282 := PoisonOr.value (k2.add 192#64), rir_reg% hty 2283 := Ty.wrap lc.k2d.l3,
    rir_reg% hty 2284 := PoisonOr.value (k2.add 256#64), rir_reg% hty 2285 := Ty.wrap lc.k2d.l4,
    rir_reg% hty 2975 := PoisonOr.value (tmp.add 320#64),
    rir_reg% hty 2979 := PoisonOr.value (tmp.add 384#64),
    rir_reg% hty 2981 := PoisonOr.value (tmp.add 64#64),
    rir_reg% hty 2984 := PoisonOr.value (tmp.add 448#64),
    rir_reg% hty 2986 := PoisonOr.value (tmp.add 128#64),
    rir_reg% hty 2989 := PoisonOr.value (tmp.add 512#64),
    rir_reg% hty 2991 := PoisonOr.value (tmp.add 192#64),
    rir_reg% hty 2994 := PoisonOr.value (tmp.add 576#64),
    rir_reg% hty 2996 := PoisonOr.value (tmp.add 256#64),
    rir_reg% hty 3039 := PoisonOr.value (tmp.add 640#64),
    rir_reg% hty 3041 := PoisonOr.value (tmp.add 704#64),
    rir_reg% hty 3043 := PoisonOr.value (tmp.add 768#64),
    rir_reg% hty 3045 := PoisonOr.value (tmp.add 832#64),
    rir_reg% hty 3047 := PoisonOr.value (tmp.add 896#64),
    rir_reg% hty 3049 := PoisonOr.value (tmp.add 960#64),
    rir_reg% hty 3051 := PoisonOr.value (tmp.add 1024#64),
    rir_reg% hty 3053 := PoisonOr.value (tmp.add 1088#64),
    rir_reg% hty 3055 := PoisonOr.value (tmp.add 1152#64),
    rir_reg% hty 3057 := PoisonOr.value (tmp.add 1216#64)]

/-- The registers live at position 1353 of `^bb79`. -/
abbrev EnvT1353 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64,
    %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask),
    rir_reg% hty 2278 := PoisonOr.value (k2.add 64#64),
    rir_reg% hty 2280 := PoisonOr.value (k2.add 128#64),
    rir_reg% hty 2282 := PoisonOr.value (k2.add 192#64),
    rir_reg% hty 2284 := PoisonOr.value (k2.add 256#64),
    rir_reg% hty 2975 := PoisonOr.value (tmp.add 320#64),
    rir_reg% hty 2979 := PoisonOr.value (tmp.add 384#64),
    rir_reg% hty 2981 := PoisonOr.value (tmp.add 64#64),
    rir_reg% hty 2984 := PoisonOr.value (tmp.add 448#64),
    rir_reg% hty 2986 := PoisonOr.value (tmp.add 128#64),
    rir_reg% hty 2989 := PoisonOr.value (tmp.add 512#64),
    rir_reg% hty 2991 := PoisonOr.value (tmp.add 192#64),
    rir_reg% hty 2994 := PoisonOr.value (tmp.add 576#64),
    rir_reg% hty 2996 := PoisonOr.value (tmp.add 256#64),
    rir_reg% hty 3039 := PoisonOr.value (tmp.add 640#64),
    rir_reg% hty 3041 := PoisonOr.value (tmp.add 704#64),
    rir_reg% hty 3043 := PoisonOr.value (tmp.add 768#64),
    rir_reg% hty 3045 := PoisonOr.value (tmp.add 832#64),
    rir_reg% hty 3047 := PoisonOr.value (tmp.add 896#64),
    rir_reg% hty 3049 := PoisonOr.value (tmp.add 960#64),
    rir_reg% hty 3051 := PoisonOr.value (tmp.add 1024#64),
    rir_reg% hty 3053 := PoisonOr.value (tmp.add 1088#64),
    rir_reg% hty 3055 := PoisonOr.value (tmp.add 1152#64),
    rir_reg% hty 3057 := PoisonOr.value (tmp.add 1216#64)]

/-- The registers live at position 1561 of `^bb79`. -/
abbrev EnvT1561 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64,
    %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64),
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask),
    rir_reg% hty 2975 := PoisonOr.value (tmp.add 320#64),
    rir_reg% hty 2979 := PoisonOr.value (tmp.add 384#64),
    rir_reg% hty 2981 := PoisonOr.value (tmp.add 64#64),
    rir_reg% hty 2984 := PoisonOr.value (tmp.add 448#64),
    rir_reg% hty 2986 := PoisonOr.value (tmp.add 128#64),
    rir_reg% hty 2989 := PoisonOr.value (tmp.add 512#64),
    rir_reg% hty 2991 := PoisonOr.value (tmp.add 192#64),
    rir_reg% hty 2994 := PoisonOr.value (tmp.add 576#64),
    rir_reg% hty 2996 := PoisonOr.value (tmp.add 256#64),
    rir_reg% hty 3039 := PoisonOr.value (tmp.add 640#64),
    rir_reg% hty 3041 := PoisonOr.value (tmp.add 704#64),
    rir_reg% hty 3043 := PoisonOr.value (tmp.add 768#64),
    rir_reg% hty 3045 := PoisonOr.value (tmp.add 832#64),
    rir_reg% hty 3047 := PoisonOr.value (tmp.add 896#64),
    rir_reg% hty 3049 := PoisonOr.value (tmp.add 960#64),
    rir_reg% hty 3051 := PoisonOr.value (tmp.add 1024#64),
    rir_reg% hty 3053 := PoisonOr.value (tmp.add 1088#64),
    rir_reg% hty 3055 := PoisonOr.value (tmp.add 1152#64),
    rir_reg% hty 3057 := PoisonOr.value (tmp.add 1216#64), rir_reg% hty 3432 := Ty.wrap lc.k2d.l0,
    rir_reg% hty 3433 := Ty.wrap lc.k2d.l1, rir_reg% hty 3434 := Ty.wrap lc.k2d.l2,
    rir_reg% hty 3435 := Ty.wrap lc.k2d.l3, rir_reg% hty 3436 := Ty.wrap lc.k2d.l4]

/-- The registers live at position 1764 of `^bb79`. -/
abbrev EnvT1764 (c : Call) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32),
    %2 := Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32),
    %4 := Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64,
    %6 := PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl,
    %8 := Ty.wrap (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16,
    %10 := PoisonOr.value 2147483647#64, %11 := PoisonOr.value 696#64,
    %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64, %14 := PoisonOr.value 1008#64,
    %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64, %17 := PoisonOr.value 672#64,
    %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 := PoisonOr.value 984#64,
    %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 := PoisonOr.value 648#64,
    %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64,
    %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32),
    %45 := Ty.wrap (Vector.replicate 8 1#32),
    %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 := PoisonOr.value 3#64,
    %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64,
    %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64,
    %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64),
    %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64),
    %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64),
    %104 := Ty.wrap (Vector.replicate 8 51#64),
    %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64),
    %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64),
    %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64),
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32),
    %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32,
      12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32),
    %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value kt, %139 := PoisonOr.value k2,
    %140 := PoisonOr.value n1, %141 := PoisonOr.value p2, %142 := PoisonOr.value p3,
    %143 := PoisonOr.value p4, %144 := PoisonOr.value p6, %145 := PoisonOr.value tmp,
    %146 := PoisonOr.value acc, %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14),
    %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26),
    %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value a,
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask)]

end

end MLIR.Firedancer.Lane.VerifyX8
