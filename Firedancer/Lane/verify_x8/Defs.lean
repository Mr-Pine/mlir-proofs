module

public import MLIR.Run.Tactic
import Std.Data.ExtHashMap.Lemmas
public import Firedancer.Lane.Common.Batch
public import Firedancer.Lane.Common.Mem
public import Firedancer.Lane.Common.Pick
public import Firedancer.Lane.Mlir.verify_x8

/-! `verify_x8`'s proof, split at the blocks where one stage of the C hands over to the next: a call
`Call`, the values the C computes from it, and at each of those blocks the registers (`EnvNN`) and
the memory (`AtNN`) the next stage starts from. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512 Firedancer.Ref
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

@[expose] public section

/-! ## The call -/

/-- A call of `verify_x8`: its multi-buffer SHA-512 `batch` and that one's globals `G`, the arrays,
the items, the count, the entry state. -/
structure Call where
  batch : Vals [.bv 64, .ptr, .ptr, .ptr] → EffectM (Vals [])
  G : List Global
  a : Arrays
  it : Nat → Item
  cnt : Nat
  s : GlobalState

/-- `verify_x8`'s constants. -/
noncomputable abbrev lc : Consts :=
  laneConsts x8Tbl

namespace Call

variable (c : Call)

/-- The arguments. -/
abbrev args :=
  (_root_.Firedancer.Lane.Mlir.verify_x8.args (.value c.a.msgs) (.value c.a.msgSzs)
      (.value c.a.sigs) (.value c.a.pks) (.value c.a.shas) (.value c.a.results)
      (.value (BitVec.ofNat 64 c.cnt))).get

/-- `fd_ed25519_lane_base_table`'s start. -/
def tbl : Pointer :=
  ⟨c.s.mem.globalBlock "fd_ed25519_lane_base_table", 0#64⟩

/-- `identity`'s start. -/
def idp : Pointer :=
  ⟨c.s.mem.globalBlock "verify_x8.identity", 0#64⟩

/-- What the C asks of the call: `X8CallEq`'s premises. -/
structure Ok : Prop where
  wf : c.s.WF
  globals : c.s.mem.Globals ((verify_x8 c.batch).globals ++ c.G)
  cnt3 : 3 ≤ c.cnt
  cnt8 : c.cnt ≤ 8
  batch : BatchOk c.s.mem c.a c.it c.cnt

/-! ### The values the C computes -/

/-- Lane `j`'s `R` (`0` past the items). -/
def R (j : Fin 8) : BitVec 256 :=
  if j.val < c.cnt then (c.it j).readR c.s.mem else 0

/-- Lane `j`'s `S`. -/
def S (j : Fin 8) : BitVec 256 :=
  if j.val < c.cnt then (c.it j).readS c.s.mem else 0

/-- Lane `j`'s public key. -/
def A (j : Fin 8) : BitVec 256 :=
  if j.val < c.cnt then (c.it j).readA c.s.mem else 0

/-- Lane `j`'s digest. -/
def H (j : Fin 8) : BitVec 512 :=
  if j.val < c.cnt then (c.it j).digest c.s.mem else 0

/-- `verify_x8` on the call. -/
noncomputable abbrev X : X8 :=
  x8Of c.s.mem c.it c.cnt

/-- Bit `j` set when `f j`. -/
def _root_.MLIR.Firedancer.Lane.VerifyX8.maskOf (f : Fin 8 → Bool) : BitVec 32 :=
  (BitVec.packLanes (Vector.ofFn fun j : Fin 8 => BitVec.ofBool (f j))).setWidth 32

/-- `candidates`. -/
noncomputable def candMask : BitVec 32 :=
  maskOf c.X.cand

/-- `live`. -/
noncomputable def liveMask : BitVec 32 :=
  maskOf c.X.live

/-- `a_buf[j]`: the key of a candidate, else `identity`. -/
noncomputable def bufA (j : Fin 8) : Pointer :=
  if c.X.cand j then (c.it j).pk else c.idp

/-- `r_buf[j]`: the signature of a candidate, else `identity`. -/
noncomputable def bufR (j : Fin 8) : Pointer :=
  if c.X.cand j then (c.it j).sig else c.idp

/-- `fd_ed25519_lane_decode2`'s `a` and `a_valid`. -/
noncomputable def decA : Point × BitVec 32 :=
  x8Dec lc c.cnt c.S c.A

/-- `fd_ed25519_lane_decode2`'s `r` and `r_valid`. -/
noncomputable def decR : Point × BitVec 32 :=
  x8Dec lc c.cnt c.S c.R

/-- `results[j]` after the checks: `-1` for a bad scalar or `R`, `-2` for a bad or small-order `A`,
and `-1` too for the live items (overwritten after the equation). -/
noncomputable def code1 (j : Nat) : BitVec 32 :=
  if h : j < 8 then
    if !c.X.cand ⟨j, h⟩ then errSig
    else if !c.X.aValid.getLsbD j then errPubkey
    else if !c.X.rValid.getLsbD j then errSig
    else if c.X.aSmall.getLsbD j then errPubkey
    else errSig
  else 0

/-- Item `j` hashed by streaming SHA-512 through `shas[j]`: live, its message longer than
`LANE_HASH_COPY_MAX`. -/
noncomputable def long (j : Nat) : Bool :=
  c.X.liveAt j && 1232 < (c.it j).msgSz.toNat

/-- `k[j]`: the reduced digest of a live item, else `0`. -/
noncomputable def kS (j : Fin 8) : BitVec 256 :=
  if c.X.live j then fd_curve25519_scalar_reduce.spec (c.H j) else 0

/-- `s[j]`: the `S` of a live item, else `0`. -/
noncomputable def sS (j : Fin 8) : BitVec 256 :=
  if c.X.live j then c.S j else 0

/-- `a` after `x` and `t` are negated: `-A`. -/
noncomputable def aNeg : Point :=
  ⟨sub Fe.zero c.decA.1.x, c.decA.1.y, c.decA.1.z, sub Fe.zero c.decA.1.t⟩

/-- `fd_ed25519_lane_verify`'s table of `[e](-A)`. -/
noncomputable def tab : Nat → Niels :=
  ktab c.aNeg lc.k2d

/-- Qword `q` of `ktab`: lane `q % 8` of limb `q % 40 / 8` of component `q % 200 / 40` (`y + x`,
`y - x`, `2dt`, `2p - 2dt`, `z`) of entry `q / 200`. -/
noncomputable def tabQword (q : Nat) : BitVec 64 :=
  let n := c.tab (q / 200)
  let f := #v[n.p, n.m, n.k, n.nk, n.z][q % 200 / 40]'(by omega)
  f.lane ⟨q % 8, by omega⟩ ⟨q % 40 / 8, by omega⟩

/-- `ktab[9][25*8]`'s bits. -/
noncomputable def tabBits : BitVec (64 * 1800) :=
  BitVec.packLanes (Vector.ofFn fun q : Fin 1800 => c.tabQword q)

/-- `acc` before window `63 - n`. -/
noncomputable def acc (n : Nat) : Point :=
  ladder c.tab lc.tbl c.kS c.sS n Point.zero

/-! ### Memory -/

/-- The 32-byte rows `f j` of an `[8][32]` array. -/
def _root_.MLIR.Firedancer.Lane.VerifyX8.rows32 (f : Fin 8 → BitVec 256) : BitVec (256 * 8) :=
  BitVec.packLanes (Vector.ofFn f)

/-- `kd[64][8]`: `kd[w][j]` digit `w` of `k[j]`'s `fd_ed25519_lane_recode4`. -/
noncomputable def kdBits : BitVec (8 * 512) :=
  BitVec.packLanes (Vector.ofFn fun i : Fin 512 => recode4 (c.kS ⟨i.val % 8, by omega⟩) (i.val / 8))

/-- `sd[32][8]`: `sd[w][j]` digit `w` of `s[j]`'s `fd_ed25519_lane_recode8`. -/
noncomputable def sdBits : BitVec (16 * 256) :=
  BitVec.packLanes (Vector.ofFn fun i : Fin 256 => recode8 (c.sS ⟨i.val % 8, by omega⟩) (i.val / 8))

/-- The memory outside the frame after the first loop: `results[j] = FD_ED25519_ERR_SIG`. -/
def mem38 : MemoryState :=
  storeResults c.s.mem c.a.results (fun _ => errSig) c.cnt

/-- The memory outside the frame after the checks. -/
noncomputable def mem62 : MemoryState :=
  storeResults c.s.mem c.a.results c.code1 c.cnt

/-- The memory outside the frame after the hashes: the streamed items' hash objects too. -/
noncomputable def mem76 : MemoryState :=
  storeResults (streamMem c.s.mem c.it c.long c.cnt) c.a.results c.code1 c.cnt

/-- The bytes of the 33 `alloca`s. -/
def _root_.MLIR.Firedancer.Lane.VerifyX8.slotBytes : List Nat :=
  [512, 512, 64, 14400, 320, 1600, 1280, 1280, 1280, 1280, 1280, 1280, 64, 64, 64, 64, 8, 8, 640,
    640, 640, 640, 320, 320, 4, 4, 256, 256, 1280, 1280, 10368, 512, 256]

/-- What holds at every hand-over: the state is `WF` and has the globals, the frame from the entry
state's counter holds the 33 `alloca`s (writable), outside it the memory is `M`, and the two globals
hold their images. -/
structure Base (S : GlobalState) (M : MemoryState) : Prop where
  wf : S.WF
  globals : S.mem.Globals ((verify_x8 c.batch).globals ++ c.G)
  frame : c.s.alloc.nextFreeBlock + 33 ≤ S.alloc.nextFreeBlock
  slots : ∀ k (h : k < 33), InBounds S.mem (c.s.slot k) (8 * slotBytes[k])
  writable : ∀ k < 33, Writable S.mem (c.s.slot k)
  mem : S.mem.eraseFrom c.s.alloc.nextFreeBlock = M
  tbl_lt : c.tbl.id.id < c.s.alloc.nextFreeBlock
  idp_lt : c.idp.id.id < c.s.alloc.nextFreeBlock
  tbl_fits : Fits S.mem c.tbl 165120
  tbl_read :
    S.mem.readAt c.tbl 165120 =
      Ty.flatBits _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_base_table.lit (hw := rfl)
  idp_fits : Fits S.mem c.idp 256
  idp_read :
    S.mem.readAt c.idp 256 =
      Ty.flatBits _root_.Firedancer.Lane.Mlir.verify_x8_identity.lit (hw := rfl)

/-- `k` and `s` (`%161`, `%162`) hold `K` and `Sv`. -/
structure KS (S : GlobalState) (K Sv : BitVec 2048) : Prop where
  k_fits : Fits S.mem (c.s.slot 26) 2048
  k_read : S.mem.readAt (c.s.slot 26) 2048 = K
  s_fits : Fits S.mem (c.s.slot 27) 2048
  s_read : S.mem.readAt (c.s.slot 27) 2048 = Sv

/-- The point at slot `k` is `P`. -/
structure PointAt (S : GlobalState) (k : Nat) (P : Point) : Prop where
  fit : S.mem.LanePointFit (c.s.slot k)
  read : S.mem.readLanePoint (c.s.slot k) = P

/-- `^bb38`: after the first loop, `k` and `s` zero. -/
structure At38 (S : GlobalState) : Prop where
  base : c.Base S c.mem38
  ks : c.KS S 0 0

/-- `^bb42`: after `fd_ed25519_lane_decode2`, the decodings `a` (`%163`) and `r` (`%164`). -/
structure At42 (S : GlobalState) : Prop where
  base : c.Base S c.mem38
  ks : c.KS S 0 0
  a : c.PointAt S 28 c.decA.1
  r : c.PointAt S 29 c.decR.1

/-- `^bb62`: after the checks and their codes. -/
structure At62 (S : GlobalState) : Prop where
  base : c.Base S c.mem62
  ks : c.KS S 0 0
  a : c.PointAt S 28 c.decA.1
  r : c.PointAt S 29 c.decR.1

/-- `^bb76`: after the hashes, live item `j`'s digest at `hashes[j]` (`%166`). -/
structure At76 (S : GlobalState) : Prop where
  base : c.Base S c.mem76
  ks : c.KS S 0 0
  a : c.PointAt S 28 c.decA.1
  r : c.PointAt S 29 c.decR.1
  hashes : ∀ j < c.cnt, c.X.liveAt j = true →
    Fits S.mem ((c.s.slot 31).add (BitVec.ofNat 64 (64 * j))) 512 ∧
      S.mem.readAt ((c.s.slot 31).add (BitVec.ofNat 64 (64 * j))) 512 = (c.it j).digest c.s.mem

/-- `^bb80`: after the reductions and copies into `k` and `s`, and `a`'s negation; `kd` and `sd`
started. -/
structure At80 (S : GlobalState) : Prop where
  base : c.Base S c.mem76
  ks : c.KS S (rows32 c.kS) (rows32 c.sS)
  a : c.PointAt S 28 c.aNeg
  r : c.PointAt S 29 c.decR.1
  kd : Room S.mem (c.s.slot 0) 4096
  sd : Room S.mem (c.s.slot 1) 4096

/-- `^bb79`: after the recodings into `kd` (`%135`) and `sd` (`%136`). -/
structure At79 (S : GlobalState) : Prop where
  base : c.Base S c.mem76
  kd_fits : Fits S.mem (c.s.slot 0) 4096
  kd_read : S.mem.readAt (c.s.slot 0) 4096 = c.kdBits
  sd_fits : Fits S.mem (c.s.slot 1) 4096
  sd_read : S.mem.readAt (c.s.slot 1) 4096 = c.sdBits
  a : c.PointAt S 28 c.aNeg
  r : c.PointAt S 29 c.decR.1

/-- `^bb83` at `w = 63`: after the table `ktab` (`%138`), `acc` (`%146`) zero. -/
structure At83 (S : GlobalState) : Prop where
  base : c.Base S c.mem76
  kd_fits : Fits S.mem (c.s.slot 0) 4096
  kd_read : S.mem.readAt (c.s.slot 0) 4096 = c.kdBits
  sd_fits : Fits S.mem (c.s.slot 1) 4096
  sd_read : S.mem.readAt (c.s.slot 1) 4096 = c.sdBits
  tab_fits : Fits S.mem (c.s.slot 3) (64 * 1800)
  tab_read : S.mem.readAt (c.s.slot 3) (64 * 1800) = c.tabBits
  acc : c.PointAt S 11 Point.zero
  r : c.PointAt S 29 c.decR.1

/-- `^bb88`: after the 64 windows. -/
structure At88 (S : GlobalState) : Prop where
  base : c.Base S c.mem76
  acc : c.PointAt S 11 (c.acc 64)
  r : c.PointAt S 29 c.decR.1

end Call

/-- The 505-lane mask of the masked store of `kj` into `kd`'s column: every eighth byte. -/
def kdMask : Vector (BitVec 1) 505 :=
  Vector.ofFn fun i : Fin 505 => if i.val % 8 = 0 then 1#1 else 0#1


/-! ## Below the frame -/

/-- `SameOn` the other way round. -/
theorem _root_.MLIR.MemoryState.SameOn.symm {m m' : MemoryState} {K : BlockId → Prop}
    (h : m.SameOn m' K) : m'.SameOn m K :=
  ⟨fun b hb => (h.1 b hb).symm, h.2.1.symm, h.2.2.symm⟩

/-- A memory and its frame-erased self agree below the frame. -/
theorem _root_.MLIR.MemoryState.sameOn_eraseFrom (m : MemoryState) (n : Nat) :
    m.SameOn (m.eraseFrom n) fun b => b.id < n := by
  refine ⟨fun b hb => ?_, rfl, rfl⟩
  show (m.mem.filter fun id _ => id.id < n)[b]? = m.mem[b]?
  simp only at hb
  simp only [Std.ExtHashMap.getElem?_filter', hb, decide_true]
  cases m.mem[b]? <;> rfl

/-- Below the frame a stage's state agrees with its memory `M`: reads, fits, room and pointers
there are `M`'s. -/
theorem Call.Base.sameOn {c : Call} {S : GlobalState} {M : MemoryState} (h : c.Base S M) :
    M.SameOn S.mem fun b => b.id < c.s.alloc.nextFreeBlock := by
  rw [← h.mem]
  exact (S.mem.sameOn_eraseFrom _).symm

/-! ## The registers at the hand-overs -/

/-- `^bb38`'s registers: the constants and slots, the lanes' buffers, `candidates`. -/
abbrev Env38 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64,
    507525298899#64, 15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64,
    0#64], %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value
    15#64, %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value
    768#32, %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64), %37 :=
    PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32, %39 := Ty.wrap (Vector.replicate 8
    8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32), %41 := Ty.wrap (Vector.replicate 8
    4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1), %43 := Ty.wrap (Vector.replicate 8
    1#1), %44 := Ty.wrap (Vector.replicate 8 0#32), %45 := Ty.wrap (Vector.replicate 8 1#32), %46 :=
    Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32], %47 := Vector.replicate 8
    PoisonOr.poison, %52 := PoisonOr.value 1#32, %53 := PoisonOr.value 0#8, %54 := PoisonOr.value
    256#64, %55 := PoisonOr.value 4294967295#32, %56 := PoisonOr.value 32#64, %57 := PoisonOr.value
    63#64, %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 :=
    PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32, %76 :=
    PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %81 :=
    PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %83 := Ty.wrap #v[6365466163363#64,
    253762649449#64, 7518893317#64, 260847760460#64, 7696165686388#64, 704489577558#64, 0#64, 0#64],
    %84 := Ty.wrap #v[3467281080496#64, 6582290652611#64, 5210002954932#64, 329084955603#64,
    4526638806224#64, 373767602335#64, 0#64, 0#64], %85 := PoisonOr.value 64#64, %86 :=
    PoisonOr.value 1#1, %87 := Vector.replicate 8 PoisonOr.poison, %88 := PoisonOr.value 1#64,
    %89 := PoisonOr.value 2#64, %90 := Ty.wrap #v[62#64, 61#64, 60#64, 59#64, 58#64, 57#64, 56#64,
    63#64], %91 := Ty.wrap #v[2#64, 4#64, 8#64, 16#64, 32#64, 64#64, 128#64, 4294967295#64], %92 :=
    PoisonOr.value 960#64, %93 := PoisonOr.value 640#64, %94 := Ty.wrap (Vector.replicate 8 0#64),
    %95 := Ty.wrap (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8
    2251799813685247#64), %97 := Ty.wrap (Vector.replicate 8 3#64), %98 := Ty.wrap (Vector.replicate
    8 6#64), %99 := PoisonOr.value 576#64, %100 := Ty.wrap (Vector.replicate 8 12#64), %101 :=
    Ty.wrap (Vector.replicate 8 2#64), %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap
    (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64), %105 := Ty.wrap
    (Vector.replicate 8 9007199254740915#64), %106 := Ty.wrap (Vector.replicate 8
    9007199254740988#64), %107 := PoisonOr.value 0#1, %108 := Ty.wrap (Vector.replicate 8
    4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64), %110 := Ty.wrap
    (Vector.replicate 8 2251799813685229#64), %111 := PoisonOr.value 255#8, %112 := Ty.wrap
    (Vector.replicate 8 2251799813685228#64), %113 := PoisonOr.value 18446744073709551584#64,
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32), %116 :=
    Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32,
    13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap
    (Vector.replicate 16 1#32), %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap
    (Vector.replicate 16 0#1), %121 := Ty.wrap (Vector.replicate 16 4294967294#32), %122 := Ty.wrap
    (Vector.replicate 16 4294967295#32), %123 := Ty.wrap (Vector.replicate 16 32#32), %124 :=
    PoisonOr.value 18446744073709551608#64, %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1
    (PoisonOr.value 0#32) (by decide)).set 2 (PoisonOr.value 0#32) (by decide)).set 3
    (PoisonOr.value 0#32) (by decide)).set 4 (PoisonOr.value 0#32) (by decide)).set 5
    (PoisonOr.value 0#32) (by decide)).set 6 (PoisonOr.value 0#32) (by decide)).set 7
    (PoisonOr.value 0#32) (by decide), %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value
    (c.s.slot 1), %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3), %139 :=
    PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5), %141 := PoisonOr.value
    (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7), %143 := PoisonOr.value (c.s.slot 8), %144 :=
    PoisonOr.value (c.s.slot 9), %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value
    (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15), %151 :=
    PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17), %153 := PoisonOr.value
    (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19), %155 := PoisonOr.value (c.s.slot 20),
    %156 := PoisonOr.value (c.s.slot 21), %157 := PoisonOr.value (c.s.slot 22), %158 :=
    PoisonOr.value (c.s.slot 23), %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value
    (c.s.slot 25), %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 :=
    PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value
    (c.s.slot 32), %191 := PoisonOr.value (c.bufA 0), %192 := PoisonOr.value (c.bufR 0), %221 :=
    PoisonOr.value (c.bufA 1), %222 := PoisonOr.value (c.bufR 1), %251 := PoisonOr.value (c.bufA 2),
    %252 := PoisonOr.value (c.bufR 2), %424 := PoisonOr.value ((c.s.slot 18).add 320#64), %425 :=
    PoisonOr.value ((c.s.slot 19).add 320#64), %426 := PoisonOr.value ((c.s.slot 20).add 320#64),
    %427 := PoisonOr.value ((c.s.slot 21).add 320#64), %428 := PoisonOr.value (c.candMask), %429 :=
    PoisonOr.value (c.bufA 7), %430 := PoisonOr.value (c.bufR 7), %431 := PoisonOr.value (c.bufA 5),
    %432 := PoisonOr.value (c.bufR 5), %433 := PoisonOr.value (c.bufA 3), %434 := PoisonOr.value
    (c.bufR 3), %435 := PoisonOr.value (c.bufR 4), %436 := PoisonOr.value (c.bufA 4), %437 :=
    PoisonOr.value (c.bufR 6), %438 := PoisonOr.value (c.bufA 6)]

/-- `^bb42`'s registers: `candidates`, `a_valid`, `r_valid`. -/
abbrev Env42 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64,
    507525298899#64, 15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64,
    0#64], %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value
    15#64, %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value
    768#32, %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64), %37 :=
    PoisonOr.value 1233#64, %38 := PoisonOr.value 4294967294#32, %39 := Ty.wrap (Vector.replicate 8
    8#32), %40 := Ty.wrap (Vector.replicate 8 4294967295#32), %41 := Ty.wrap (Vector.replicate 8
    4294967294#32), %42 := Ty.wrap (Vector.replicate 8 0#1), %43 := Ty.wrap (Vector.replicate 8
    1#1), %44 := Ty.wrap (Vector.replicate 8 0#32), %45 := Ty.wrap (Vector.replicate 8 1#32), %46 :=
    Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32], %47 := Vector.replicate 8
    PoisonOr.poison, %52 := PoisonOr.value 1#32, %53 := PoisonOr.value 0#8, %54 := PoisonOr.value
    256#64, %55 := PoisonOr.value 4294967295#32, %56 := PoisonOr.value 32#64, %57 := PoisonOr.value
    63#64, %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64,
    %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 :=
    PoisonOr.value 3#64, %73 := PoisonOr.value 24#64, %74 := PoisonOr.value 8#32, %76 :=
    PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %81 :=
    PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 :=
    PoisonOr.value 1#64, %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 :=
    PoisonOr.value 640#64, %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap
    (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64), %99 :=
    PoisonOr.value 576#64, %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap
    (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64), %106 := Ty.wrap
    (Vector.replicate 8 9007199254740988#64), %108 := Ty.wrap (Vector.replicate 8
    4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64), %110 := Ty.wrap
    (Vector.replicate 8 2251799813685229#64), %113 := PoisonOr.value 18446744073709551584#64,
    %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32), %116 :=
    Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32,
    13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap
    (Vector.replicate 16 1#32), %119 := Ty.wrap (Vector.replicate 16 1#1), %120 := Ty.wrap
    (Vector.replicate 16 0#1), %121 := Ty.wrap (Vector.replicate 16 4294967294#32), %122 := Ty.wrap
    (Vector.replicate 16 4294967295#32), %123 := Ty.wrap (Vector.replicate 16 32#32), %124 :=
    PoisonOr.value 18446744073709551608#64, %134 := (((((((Vector.replicate 8 PoisonOr.poison).set 1
    (PoisonOr.value 0#32) (by decide)).set 2 (PoisonOr.value 0#32) (by decide)).set 3
    (PoisonOr.value 0#32) (by decide)).set 4 (PoisonOr.value 0#32) (by decide)).set 5
    (PoisonOr.value 0#32) (by decide)).set 6 (PoisonOr.value 0#32) (by decide)).set 7
    (PoisonOr.value 0#32) (by decide), %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value
    (c.s.slot 1), %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3), %139 :=
    PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5), %141 := PoisonOr.value
    (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7), %143 := PoisonOr.value (c.s.slot 8), %144 :=
    PoisonOr.value (c.s.slot 9), %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value
    (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15), %151 :=
    PoisonOr.value (c.s.slot 16), %152 := PoisonOr.value (c.s.slot 17), %153 := PoisonOr.value
    (c.s.slot 18), %154 := PoisonOr.value (c.s.slot 19), %155 := PoisonOr.value (c.s.slot 20),
    %156 := PoisonOr.value (c.s.slot 21), %157 := PoisonOr.value (c.s.slot 22), %158 :=
    PoisonOr.value (c.s.slot 23), %159 := PoisonOr.value (c.s.slot 24), %160 := PoisonOr.value
    (c.s.slot 25), %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27),
    %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 :=
    PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value
    (c.s.slot 32), %428 := PoisonOr.value (c.candMask), rir_reg% hty 1278 := PoisonOr.value
    (c.X.aValid), rir_reg% hty 1818 := PoisonOr.value (c.X.rValid)]

/-- `^bb62`'s registers: `live`. -/
abbrev Env62 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64,
    507525298899#64, 15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64,
    0#64], %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value
    15#64, %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value
    768#32, %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64), %37 :=
    PoisonOr.value 1233#64, %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap
    (Vector.replicate 8 0#32), %45 := Ty.wrap (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32,
    1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32], %47 := Vector.replicate 8 PoisonOr.poison, %52 :=
    PoisonOr.value 1#32, %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %56 :=
    PoisonOr.value 32#64, %57 := PoisonOr.value 63#64, %61 := PoisonOr.value 0#32, %62 :=
    PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64, %69 :=
    PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 := PoisonOr.value 3#64, %74 :=
    PoisonOr.value 8#32, %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 :=
    PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %85 :=
    PoisonOr.value 64#64, %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64, %92 :=
    PoisonOr.value 960#64, %93 := PoisonOr.value 640#64, %94 := Ty.wrap (Vector.replicate 8 0#64),
    %95 := Ty.wrap (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8
    2251799813685247#64), %99 := PoisonOr.value 576#64, %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64), %106 :=
    Ty.wrap (Vector.replicate 8 9007199254740988#64), %108 := Ty.wrap (Vector.replicate 8
    4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64), %110 := Ty.wrap
    (Vector.replicate 8 2251799813685229#64), %114 := Vector.replicate 16 PoisonOr.poison, %115 :=
    Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32,
    7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate
    16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16
    32#32), %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value
    (c.s.slot 3), %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5), %141 :=
    PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7), %143 := PoisonOr.value
    (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9), %145 := PoisonOr.value (c.s.slot 10), %146 :=
    PoisonOr.value (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value
    (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 :=
    PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value
    (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask)]

/-- `^bb76`'s registers at `j = 0`: `live`. -/
abbrev Env76 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64,
    507525298899#64, 15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64,
    0#64], %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value
    15#64, %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value
    768#32, %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64), %39 :=
    Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32), %45 := Ty.wrap
    (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32, %53 := PoisonOr.value
    0#8, %54 := PoisonOr.value 256#64, %56 := PoisonOr.value 32#64, %57 := PoisonOr.value 63#64,
    %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 :=
    PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 :=
    PoisonOr.value 3#64, %74 := PoisonOr.value 8#32, %76 := PoisonOr.value 5#64, %78 :=
    PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 :=
    PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64, %89 :=
    PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 := PoisonOr.value 640#64, %94 := Ty.wrap
    (Vector.replicate 8 0#64), %95 := Ty.wrap (Vector.replicate 8 1#64), %96 := Ty.wrap
    (Vector.replicate 8 2251799813685247#64), %99 := PoisonOr.value 576#64, %102 := Ty.wrap
    (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap
    (Vector.replicate 8 51#64), %106 := Ty.wrap (Vector.replicate 8 9007199254740988#64), %108 :=
    Ty.wrap (Vector.replicate 8 4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8
    4503599627370494#64), %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %114 :=
    Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap
    #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32,
    14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16
    1#32), %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value
    18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot
    1), %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value (c.s.slot 3), %139 :=
    PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5), %141 := PoisonOr.value
    (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7), %143 := PoisonOr.value (c.s.slot 8), %144 :=
    PoisonOr.value (c.s.slot 9), %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value
    (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13),
    %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15), %161 :=
    PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value
    (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30),
    %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32), rir_reg% hty 2040 :=
    PoisonOr.value (c.liveMask), rir_reg% hty 2176 := PoisonOr.value 0#64]

/-- `^bb80`'s registers at `j = 0`: `live`, the limbs of `a.x` and `a.t` past the first. -/
abbrev Env80 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64,
    507525298899#64, 15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64,
    0#64], %26 := Ty.wrap kdMask, %27 := Vector.replicate 64 PoisonOr.poison, %28 := PoisonOr.value
    15#64, %29 := PoisonOr.value 10#64, %30 := PoisonOr.value 65280#32, %31 := PoisonOr.value
    768#32, %32 := PoisonOr.value 256#32, %33 := PoisonOr.value 4#8, %34 := PoisonOr.value 240#32,
    %35 := PoisonOr.value 15#8, %36 := Ty.wrap (Vector.replicate 8 9007199254740916#64), %39 :=
    Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32), %45 := Ty.wrap
    (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32, %53 := PoisonOr.value
    0#8, %54 := PoisonOr.value 256#64, %57 := PoisonOr.value 63#64, %61 := PoisonOr.value 0#32,
    %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64, %69 :=
    PoisonOr.value 8#64, %71 := PoisonOr.value 4#32, %72 := PoisonOr.value 3#64, %74 :=
    PoisonOr.value 8#32, %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 :=
    PoisonOr.value 7#64, %81 := PoisonOr.value 128#32, %82 := PoisonOr.value 320#64, %85 :=
    PoisonOr.value 64#64, %88 := PoisonOr.value 1#64, %89 := PoisonOr.value 2#64, %92 :=
    PoisonOr.value 960#64, %93 := PoisonOr.value 640#64, %94 := Ty.wrap (Vector.replicate 8 0#64),
    %95 := Ty.wrap (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8
    2251799813685247#64), %99 := PoisonOr.value 576#64, %102 := Ty.wrap (Vector.replicate 8 38#64),
    %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64), %106 :=
    Ty.wrap (Vector.replicate 8 9007199254740988#64), %108 := Ty.wrap (Vector.replicate 8
    4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64), %110 := Ty.wrap
    (Vector.replicate 8 2251799813685229#64), %114 := Vector.replicate 16 PoisonOr.poison, %115 :=
    Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32,
    7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate
    16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16
    32#32), %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %137 := PoisonOr.value (c.s.slot 2), %138 := PoisonOr.value
    (c.s.slot 3), %139 := PoisonOr.value (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5), %141 :=
    PoisonOr.value (c.s.slot 6), %142 := PoisonOr.value (c.s.slot 7), %143 := PoisonOr.value
    (c.s.slot 8), %144 := PoisonOr.value (c.s.slot 9), %145 := PoisonOr.value (c.s.slot 10), %146 :=
    PoisonOr.value (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value
    (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15),
    %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 :=
    PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value
    (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32),
    rir_reg% hty 2040 := PoisonOr.value (c.liveMask), rir_reg% hty 2115 := PoisonOr.value ((c.s.slot
    28).add 64#64), rir_reg% hty 2118 := PoisonOr.value ((c.s.slot 28).add 128#64),
    rir_reg% hty 2121 := PoisonOr.value ((c.s.slot 28).add 192#64), rir_reg% hty 2124 :=
    PoisonOr.value ((c.s.slot 28).add 256#64), rir_reg% hty 2142 := PoisonOr.value ((c.s.slot
    28).add 960#64), rir_reg% hty 2158 := PoisonOr.value ((c.s.slot 28).add 1024#64),
    rir_reg% hty 2160 := PoisonOr.value ((c.s.slot 28).add 1088#64), rir_reg% hty 2162 :=
    PoisonOr.value ((c.s.slot 28).add 1152#64), rir_reg% hty 2164 := PoisonOr.value ((c.s.slot
    28).add 1216#64), rir_reg% hty 3760 := PoisonOr.value 0#64]

/-- `^bb79`'s registers: `live`, the limbs of `a.x` and `a.t` past the first. -/
abbrev Env79 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %25 := Ty.wrap #v[3934839304537#64,
    507525298899#64, 15037786634#64, 521695520920#64, 6596238350568#64, 309467527341#64, 0#64,
    0#64], %28 := PoisonOr.value 15#64, %29 := PoisonOr.value 10#64, %36 := Ty.wrap
    (Vector.replicate 8 9007199254740916#64), %39 := Ty.wrap (Vector.replicate 8 8#32), %44 :=
    Ty.wrap (Vector.replicate 8 0#32), %45 := Ty.wrap (Vector.replicate 8 1#32), %46 := Ty.wrap
    #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32], %47 := Vector.replicate 8 PoisonOr.poison,
    %52 := PoisonOr.value 1#32, %53 := PoisonOr.value 0#8, %54 := PoisonOr.value 256#64, %57 :=
    PoisonOr.value 63#64, %61 := PoisonOr.value 0#32, %62 := PoisonOr.value 56#64, %66 :=
    PoisonOr.value 0#64, %68 := PoisonOr.value 4#64, %69 := PoisonOr.value 8#64, %72 :=
    PoisonOr.value 3#64, %76 := PoisonOr.value 5#64, %78 := PoisonOr.value 6#64, %80 :=
    PoisonOr.value 7#64, %82 := PoisonOr.value 320#64, %85 := PoisonOr.value 64#64, %88 :=
    PoisonOr.value 1#64, %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 :=
    PoisonOr.value 640#64, %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap
    (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64), %99 :=
    PoisonOr.value 576#64, %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap
    (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64), %106 := Ty.wrap
    (Vector.replicate 8 9007199254740988#64), %108 := Ty.wrap (Vector.replicate 8
    4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8 4503599627370494#64), %110 := Ty.wrap
    (Vector.replicate 8 2251799813685229#64), %114 := Vector.replicate 16 PoisonOr.poison, %115 :=
    Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32,
    7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate
    16 16#32), %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16
    32#32), %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0),
    %136 := PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value (c.s.slot 3), %139 := PoisonOr.value
    (c.s.slot 4), %140 := PoisonOr.value (c.s.slot 5), %141 := PoisonOr.value (c.s.slot 6), %142 :=
    PoisonOr.value (c.s.slot 7), %143 := PoisonOr.value (c.s.slot 8), %144 := PoisonOr.value
    (c.s.slot 9), %145 := PoisonOr.value (c.s.slot 10), %146 := PoisonOr.value (c.s.slot 11),
    %147 := PoisonOr.value (c.s.slot 12), %148 := PoisonOr.value (c.s.slot 13), %149 :=
    PoisonOr.value (c.s.slot 14), %150 := PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value
    (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 := PoisonOr.value (c.s.slot 28),
    %164 := PoisonOr.value (c.s.slot 29), %165 := PoisonOr.value (c.s.slot 30), %166 :=
    PoisonOr.value (c.s.slot 31), %167 := PoisonOr.value (c.s.slot 32), rir_reg% hty 2040 :=
    PoisonOr.value (c.liveMask), rir_reg% hty 2115 := PoisonOr.value ((c.s.slot 28).add 64#64),
    rir_reg% hty 2118 := PoisonOr.value ((c.s.slot 28).add 128#64), rir_reg% hty 2121 :=
    PoisonOr.value ((c.s.slot 28).add 192#64), rir_reg% hty 2124 := PoisonOr.value ((c.s.slot
    28).add 256#64), rir_reg% hty 2142 := PoisonOr.value ((c.s.slot 28).add 960#64),
    rir_reg% hty 2158 := PoisonOr.value ((c.s.slot 28).add 1024#64), rir_reg% hty 2160 :=
    PoisonOr.value ((c.s.slot 28).add 1088#64), rir_reg% hty 2162 := PoisonOr.value ((c.s.slot
    28).add 1152#64), rir_reg% hty 2164 := PoisonOr.value ((c.s.slot 28).add 1216#64)]

/-- `^bb83`'s registers at `w = 63`: `live`, `acc`'s and `sp … sz`'s inner pointers. -/
abbrev Env83 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %6 :=
    PoisonOr.value 18446744073709551615#64, %7 := PoisonOr.value c.tbl, %8 := Ty.wrap
    (Vector.replicate 8 160#32), %9 := PoisonOr.value 0#16, %10 := PoisonOr.value 2147483647#64,
    %11 := PoisonOr.value 696#64, %12 := PoisonOr.value 1016#64, %13 := PoisonOr.value 688#64,
    %14 := PoisonOr.value 1008#64, %15 := PoisonOr.value 680#64, %16 := PoisonOr.value 1000#64,
    %17 := PoisonOr.value 672#64, %18 := PoisonOr.value 992#64, %19 := PoisonOr.value 664#64, %20 :=
    PoisonOr.value 984#64, %21 := PoisonOr.value 656#64, %22 := PoisonOr.value 976#64, %23 :=
    PoisonOr.value 648#64, %24 := PoisonOr.value 968#64, %28 := PoisonOr.value 15#64, %29 :=
    PoisonOr.value 10#64, %39 := Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate
    8 0#32), %45 := Ty.wrap (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32,
    4#32, 5#32, 6#32, 7#32], %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32,
    %53 := PoisonOr.value 0#8, %57 := PoisonOr.value 63#64, %61 := PoisonOr.value 0#32, %62 :=
    PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %68 := PoisonOr.value 4#64, %69 :=
    PoisonOr.value 8#64, %72 := PoisonOr.value 3#64, %76 := PoisonOr.value 5#64, %78 :=
    PoisonOr.value 6#64, %80 := PoisonOr.value 7#64, %85 := PoisonOr.value 64#64, %88 :=
    PoisonOr.value 1#64, %89 := PoisonOr.value 2#64, %92 := PoisonOr.value 960#64, %93 :=
    PoisonOr.value 640#64, %94 := Ty.wrap (Vector.replicate 8 0#64), %95 := Ty.wrap
    (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8 2251799813685247#64), %102 :=
    Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap (Vector.replicate 8 19#64), %104 := Ty.wrap
    (Vector.replicate 8 51#64), %108 := Ty.wrap (Vector.replicate 8 4503599627370458#64), %109 :=
    Ty.wrap (Vector.replicate 8 4503599627370494#64), %110 := Ty.wrap (Vector.replicate 8
    2251799813685229#64), %114 := Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap
    (Vector.replicate 16 0#32), %116 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32,
    8#32, 9#32, 10#32, 11#32, 12#32, 13#32, 14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16
    16#32), %118 := Ty.wrap (Vector.replicate 16 1#32), %123 := Ty.wrap (Vector.replicate 16 32#32),
    %124 := PoisonOr.value 18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0), %136 :=
    PoisonOr.value (c.s.slot 1), %138 := PoisonOr.value (c.s.slot 3), %139 := PoisonOr.value
    (c.s.slot 4), %146 := PoisonOr.value (c.s.slot 11), %147 := PoisonOr.value (c.s.slot 12),
    %148 := PoisonOr.value (c.s.slot 13), %149 := PoisonOr.value (c.s.slot 14), %150 :=
    PoisonOr.value (c.s.slot 15), %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value
    (c.s.slot 27), %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 :=
    PoisonOr.value (c.s.slot 32), rir_reg% hty 2040 := PoisonOr.value (c.liveMask),
    rir_reg% hty 3727 := PoisonOr.value ((c.s.slot 11).add 640#64), rir_reg% hty 3728 :=
    PoisonOr.value ((c.s.slot 11).add 320#64), rir_reg% hty 3730 := PoisonOr.value ((c.s.slot
    11).add 704#64), rir_reg% hty 3731 := PoisonOr.value ((c.s.slot 11).add 384#64),
    rir_reg% hty 3732 := PoisonOr.value ((c.s.slot 12).add 8#64), rir_reg% hty 3733 :=
    PoisonOr.value ((c.s.slot 13).add 8#64), rir_reg% hty 3734 := PoisonOr.value ((c.s.slot 14).add
    8#64), rir_reg% hty 3735 := PoisonOr.value ((c.s.slot 15).add 8#64), rir_reg% hty 3736 :=
    PoisonOr.value ((c.s.slot 12).add 16#64), rir_reg% hty 3737 := PoisonOr.value ((c.s.slot 13).add
    16#64), rir_reg% hty 3738 := PoisonOr.value ((c.s.slot 14).add 16#64), rir_reg% hty 3739 :=
    PoisonOr.value ((c.s.slot 15).add 16#64), rir_reg% hty 3740 := PoisonOr.value ((c.s.slot 12).add
    24#64), rir_reg% hty 3741 := PoisonOr.value ((c.s.slot 13).add 24#64), rir_reg% hty 3742 :=
    PoisonOr.value ((c.s.slot 14).add 24#64), rir_reg% hty 3743 := PoisonOr.value ((c.s.slot 15).add
    24#64), rir_reg% hty 3744 := PoisonOr.value ((c.s.slot 12).add 32#64), rir_reg% hty 3745 :=
    PoisonOr.value ((c.s.slot 13).add 32#64), rir_reg% hty 3746 := PoisonOr.value ((c.s.slot 14).add
    32#64), rir_reg% hty 3747 := PoisonOr.value ((c.s.slot 15).add 32#64), rir_reg% hty 3748 :=
    PoisonOr.value ((c.s.slot 12).add 40#64), rir_reg% hty 3749 := PoisonOr.value ((c.s.slot 13).add
    40#64), rir_reg% hty 3750 := PoisonOr.value ((c.s.slot 14).add 40#64), rir_reg% hty 3751 :=
    PoisonOr.value ((c.s.slot 15).add 40#64), rir_reg% hty 3752 := PoisonOr.value ((c.s.slot 12).add
    48#64), rir_reg% hty 3753 := PoisonOr.value ((c.s.slot 13).add 48#64), rir_reg% hty 3754 :=
    PoisonOr.value ((c.s.slot 14).add 48#64), rir_reg% hty 3755 := PoisonOr.value ((c.s.slot 15).add
    48#64), rir_reg% hty 3756 := PoisonOr.value ((c.s.slot 12).add 56#64), rir_reg% hty 3757 :=
    PoisonOr.value ((c.s.slot 13).add 56#64), rir_reg% hty 3758 := PoisonOr.value ((c.s.slot 14).add
    56#64), rir_reg% hty 3759 := PoisonOr.value ((c.s.slot 15).add 56#64), rir_reg% hty 4134 :=
    PoisonOr.value 63#64]

/-- `^bb88`'s registers: `live`, `acc`'s inner pointers. -/
abbrev Env88 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := PoisonOr.value 4294967293#32, %1 := Ty.wrap (Vector.replicate 8 4294967293#32), %2 :=
    Ty.wrap (Vector.replicate 16 64#32), %3 := Ty.wrap (Vector.replicate 16 4294967293#32), %4 :=
    Ty.wrap (Vector.replicate 16 48#32), %5 := PoisonOr.value 18446744073709551552#64, %39 :=
    Ty.wrap (Vector.replicate 8 8#32), %44 := Ty.wrap (Vector.replicate 8 0#32), %45 := Ty.wrap
    (Vector.replicate 8 1#32), %46 := Ty.wrap #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32],
    %47 := Vector.replicate 8 PoisonOr.poison, %52 := PoisonOr.value 1#32, %61 := PoisonOr.value
    0#32, %62 := PoisonOr.value 56#64, %66 := PoisonOr.value 0#64, %69 := PoisonOr.value 8#64,
    %85 := PoisonOr.value 64#64, %88 := PoisonOr.value 1#64, %94 := Ty.wrap (Vector.replicate 8
    0#64), %95 := Ty.wrap (Vector.replicate 8 1#64), %96 := Ty.wrap (Vector.replicate 8
    2251799813685247#64), %102 := Ty.wrap (Vector.replicate 8 38#64), %103 := Ty.wrap
    (Vector.replicate 8 19#64), %104 := Ty.wrap (Vector.replicate 8 51#64), %108 := Ty.wrap
    (Vector.replicate 8 4503599627370458#64), %109 := Ty.wrap (Vector.replicate 8
    4503599627370494#64), %110 := Ty.wrap (Vector.replicate 8 2251799813685229#64), %114 :=
    Vector.replicate 16 PoisonOr.poison, %115 := Ty.wrap (Vector.replicate 16 0#32), %116 := Ty.wrap
    #v[0#32, 1#32, 2#32, 3#32, 4#32, 5#32, 6#32, 7#32, 8#32, 9#32, 10#32, 11#32, 12#32, 13#32,
    14#32, 15#32], %117 := Ty.wrap (Vector.replicate 16 16#32), %118 := Ty.wrap (Vector.replicate 16
    1#32), %123 := Ty.wrap (Vector.replicate 16 32#32), %124 := PoisonOr.value
    18446744073709551608#64, %135 := PoisonOr.value (c.s.slot 0), %136 := PoisonOr.value (c.s.slot
    1), %138 := PoisonOr.value (c.s.slot 3), %139 := PoisonOr.value (c.s.slot 4), %146 :=
    PoisonOr.value (c.s.slot 11), %161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value
    (c.s.slot 27), %163 := PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29),
    %165 := PoisonOr.value (c.s.slot 30), %166 := PoisonOr.value (c.s.slot 31), %167 :=
    PoisonOr.value (c.s.slot 32), rir_reg% hty 2040 := PoisonOr.value (c.liveMask),
    rir_reg% hty 3727 := PoisonOr.value ((c.s.slot 11).add 640#64), rir_reg% hty 3728 :=
    PoisonOr.value ((c.s.slot 11).add 320#64), rir_reg% hty 3730 := PoisonOr.value ((c.s.slot
    11).add 704#64), rir_reg% hty 3731 := PoisonOr.value ((c.s.slot 11).add 384#64)]

/-- `^bb102`'s registers. -/
abbrev Env102 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27), %163 :=
    PoisonOr.value (c.s.slot 28), %164 := PoisonOr.value (c.s.slot 29)]

/-- `^bb103`'s registers. -/
abbrev Env103 (c : Call) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%161 := PoisonOr.value (c.s.slot 26), %162 := PoisonOr.value (c.s.slot 27)]

end

end MLIR.Firedancer.Lane.VerifyX8
