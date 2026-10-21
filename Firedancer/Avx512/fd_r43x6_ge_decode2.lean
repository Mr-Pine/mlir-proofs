module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Common.Callees
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Common.If
public import Firedancer.Avx512.Common.Inl
public import Firedancer.Avx512.Common.Neg
public import Firedancer.Avx512.Common.Quad
public import Firedancer.Avx512.Common.Sub
public import Firedancer.Avx512.fd_r43x6_mul_fast
public import Firedancer.Avx512.fd_r43x6_sqr_fast
public import Firedancer.Avx512.fd_r43x6_diagnose
public import Firedancer.Avx512.fd_r43x6_is_nonzero
public import Firedancer.Avx512.fd_r43x6_unpack
public import Firedancer.Avx512.fd_r43x6_pow22523_2
public import Firedancer.Avx512.wv_ld
public import Firedancer.Avx512.Mlir.fd_r43x6_ge_decode2
import Std.Tactic.BVDecide
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.Avx512

namespace fd_r43x6_ge_decode2

@[expose] public section

/-! ## The blocks -/

/-- The sign bit `y3 >>> 63` truncates to `int` losslessly. -/
theorem shr63_trunc (y : BitVec 64) :
    ((y >>> 63).setWidth 32).setWidth 64 = y >>> 63 ∧
      ((y >>> 63).setWidth 32).signExtend 64 = y >>> 63 := by
  bv_decide

variable {a03 a14 a25 sa b03 b14 b25 sb : Pointer}

/-- `fd_r43x6_ge_decode2`. -/
abbrev func : Func :=
  fd_r43x6_ge_decode2

variable (a03 a14 a25 sa b03 b14 b25 sb) in
/-- The arguments: the six out-vectors and the two encodings. -/
abbrev argsOf : Vals Γ.args :=
  args (.value a03) (.value a14) (.value a25) (.value sa) (.value b03) (.value b14) (.value b25)
    (.value sb)

variable (a03 a14 a25 b03 b14 b25) in
/-- The six out-vectors, all set to `z`, in the failure paths' order. -/
abbrev fill (m : MemoryState) (z : Vector (BitVec 64) 8) : MemoryState :=
  let z := BitVec.packLanes z
  (((((m.storeAt a03 z).storeAt b03 z).storeAt a14 z).storeAt b14 z).storeAt a25 z).storeAt b25 z

/-- `^bb5`: `*_Pb25 = %2241`, the copies `pa pb` freed, then return `%2242`. -/
theorem bb5_run (E : ⟪Γ⟫) (S : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (v : Vector (BitVec 64) 8)
    (r : BitVec 32) (pa pb : Pointer) (hv : E.read (%2241) = Ty.wrap v)
    (hr : E.read (%2242) = .value r) (hpa : E.read (%1977) = .value pa)
    (hpb : E.read (%1978) = .value pb) (hb25 : Room S.mem b25 512)
    (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK :
      .value
          (.cons (.value r) .nil,
            { S with
              mem := ((S.mem.storeAt b25 (BitVec.packLanes v)).lifetimeEnd pb).lifetimeEnd pa }) =
        K) :
    func.runFrom E ^bb5 S = K := by
  block_init
  step_store consuming hb25 hfits_b25
  step_pure
  step_pure
  finish_block
  subst_vars
  rfl

/-- `^bb3`: the first encoding does not decode; all six out-vectors zeroed (`%1919`), then `-1`
(`%1918`). -/
theorem bb3_run (E : ⟪Γ⟫) (S : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (z : Vector (BitVec 64) 8)
    (r : BitVec 32) (pa pb : Pointer) (hz : E.read (%1919) = Ty.wrap z)
    (hr : E.read (%1918) = .value r) (hpa : E.read (%1977) = .value pa)
    (hpb : E.read (%1978) = .value pb) (ha03 : Room S.mem a03 512) (ha14 : Room S.mem a14 512)
    (ha25 : Room S.mem a25 512) (hb03 : Room S.mem b03 512) (hb14 : Room S.mem b14 512)
    (hb25 : Room S.mem b25 512) :
    func.runFrom E ^bb3 S =
      .value
        (.cons (.value r) .nil,
          { S with
            mem := ((fill a03 a14 a25 b03 b14 b25 S.mem z).lifetimeEnd pb).lifetimeEnd pa }) := by
  block_init
  iterate 5 step_store
  finish_block
  run_from using bb5_run

/-- `^bb4`: the second encoding does not decode; all six out-vectors zeroed (`%1919`), then `-2`
(`%1917`). -/
theorem bb4_run (E : ⟪Γ⟫) (S : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (z : Vector (BitVec 64) 8)
    (r : BitVec 32) (pa pb : Pointer) (hz : E.read (%1919) = Ty.wrap z)
    (hr : E.read (%1917) = .value r) (hpa : E.read (%1977) = .value pa)
    (hpb : E.read (%1978) = .value pb) (ha03 : Room S.mem a03 512) (ha14 : Room S.mem a14 512)
    (ha25 : Room S.mem a25 512) (hb03 : Room S.mem b03 512) (hb14 : Room S.mem b14 512)
    (hb25 : Room S.mem b25 512) (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK :
      .value
          (.cons (.value r) .nil,
            { S with
              mem := ((fill a03 a14 a25 b03 b14 b25 S.mem z).lifetimeEnd pb).lifetimeEnd pa }) =
        K) :
    func.runFrom E ^bb4 S = K := by
  subst hK
  block_init
  iterate 5 step_store
  finish_block
  run_from using bb5_run

/-- `^bb1`: the checks of the second point, `x + y` (`%2116 + %2022`) nonzero as `%2123` is. Both
nonzero: on to `^bb2` (`hK`'s first case); else `^bb4`'s failure. -/
theorem bb1_run (E : ⟪Γ⟫) (S : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (x y z : Vector (BitVec 64) 8)
    (c r : BitVec 32) (pa pb : Pointer) (hx : E.read (%2116) = Ty.wrap x)
    (hy : E.read (%2022) = Ty.wrap y) (hc : E.read (%2123) = .value c)
    (h0 : E.read (%1944) = .value 0) (hz : E.read (%1919) = Ty.wrap z)
    (hr : E.read (%1917) = .value r) (hpa : E.read (%1977) = .value pa)
    (hpb : E.read (%1978) = .value pb) (ha03 : Room S.mem a03 512) (ha14 : Room S.mem a14 512)
    (ha25 : Room S.mem a25 512) (hb03 : Room S.mem b03 512) (hb14 : Room S.mem b14 512)
    (hb25 : Room S.mem b25 512) (hwf : S.WF) (K : PoisonOr (Vals [.bv 32] × GlobalState))
    (hK :
      (if fd_r43x6_is_nonzero.spec (vadd x y) &&& c = 0#32 then
          func.runFrom
            E[%2127 := vadd x y, %2128 := fd_r43x6_is_nonzero.spec (vadd x y), %2129 :=
              fd_r43x6_is_nonzero.spec (vadd x y) &&& c, %2130 :=
              BitVec.ofBool (fd_r43x6_is_nonzero.spec (vadd x y) &&& c == 0#32)]
            ^bb2 S
        else
          .value
            (.cons (.value r) .nil,
              { S with
                mem := ((fill a03 a14 a25 b03 b14 b25 S.mem z).lifetimeEnd pb).lifetimeEnd pa })) =
        K) :
    func.runFrom E ^bb1 S = K := by
  have hnz := fd_r43x6_is_nonzero.call_eq
  block_init
  step_pure with transparent sum
  step_call using hnz with transparent nz hnz_eq
  step_pure with transparent both
  step_pure with transparent isZero
  finish_block
  all_goals split at hK
  · subst hK
    subst_vars
    rfl
  · subst_vars
    contradiction
  · subst_vars
    contradiction
  · subst hK
    run_from using bb4_run

/-! ### `^bb0`'s copies of the encodings -/

/-- The four slots `^bb0` allocates, dead until their lifetimes start. -/
abbrev slots4 (S : GlobalState) : GlobalState :=
  (((S.alloca 32 true).alloca 32 true).alloca 64 true).alloca 64 true

theorem inBounds_slot0 {S : GlobalState} (hwf : S.WF) : InBounds (slots4 S).mem (S.slot 0) 256 := by
  have h : InBounds (S.alloca 32 true).mem S.allocaPtr 256 := InBounds.allocaPtr (by omega)
  exact
    ((h.alloca (n := 32) hwf.alloca).alloca (n := 64) hwf.alloca.alloca).alloca (n := 64)
      hwf.alloca.alloca.alloca

theorem inBounds_slot1 {S : GlobalState} (hwf : S.WF) : InBounds (slots4 S).mem (S.slot 1) 256 := by
  have h : InBounds ((S.alloca 32 true).alloca 32 true).mem (S.alloca 32 true).allocaPtr 256 :=
    InBounds.allocaPtr (by omega)
  rw [GlobalState.allocaPtr_eq_slot, GlobalState.alloca_slot] at h
  exact (h.alloca (n := 64) hwf.alloca.alloca).alloca (n := 64) hwf.alloca.alloca.alloca

theorem writable_slot0 {S : GlobalState} (hwf : S.WF) : Writable (slots4 S).mem (S.slot 0) := by
  have h : Writable (S.alloca 32 true).mem S.allocaPtr := Writable.allocaPtr
  exact
    ((h.alloca (n := 32) hwf.alloca).alloca (n := 64) hwf.alloca.alloca).alloca (n := 64)
      hwf.alloca.alloca.alloca

theorem writable_slot1 {S : GlobalState} (hwf : S.WF) : Writable (slots4 S).mem (S.slot 1) := by
  have h : Writable ((S.alloca 32 true).alloca 32 true).mem (S.alloca 32 true).allocaPtr :=
    Writable.allocaPtr
  rw [GlobalState.allocaPtr_eq_slot, GlobalState.alloca_slot] at h
  exact (h.alloca (n := 64) hwf.alloca.alloca).alloca (n := 64) hwf.alloca.alloca.alloca

/-- The copy at `pa`, its top word replaced, read back as four lanes. -/
theorem readWv_copy_a {m : MemoryState} {pa pb : Pointer} (hab : pa.id ≠ pb.id) (ha : Room m pa 256)
    (ho : pa.offset = 0) (xa xb : BitVec 256) (ya yb : BitVec 64) :
    ((((m.storeAt pa xa).storeAt pb xb).storeAt (pa.add 24#64) ya).storeAt (pb.add 24#64) yb).readWv
        pa =
      Vector.ofFn fun i => Ty.extractVecElem 4 64 i (Memory.spliceBits xa 192 ya) := by
  have hd : (Range.of (pb.add 24#64) 64).Disjoint (Range.of pa 256) :=
    Or.inl (by simpa [Range.of, Pointer.add] using hab.symm)
  have hd' : (Range.of pb 256).Disjoint (Range.of pa 256) :=
    Or.inl (by simpa [Range.of] using hab.symm)
  rw [MemoryState.readWv, MemoryState.readAt_storeAt_disjoint hd,
    MemoryState.readAt_add_storeAt (ha.storeAt.storeAt) (by simp [ho, BitVec.uaddOverflow])
      (by decide),
    MemoryState.readAt_storeAt_disjoint hd', MemoryState.readAt_storeAt_self ha]
  rfl

/-- `readWv_copy_a` for the copy at `pb`. -/
theorem readWv_copy_b {m : MemoryState} {pa pb : Pointer} (hab : pa.id ≠ pb.id) (hb : Room m pb 256)
    (ho : pb.offset = 0) (xa xb : BitVec 256) (ya yb : BitVec 64) :
    ((((m.storeAt pa xa).storeAt pb xb).storeAt (pa.add 24#64) ya).storeAt (pb.add 24#64) yb).readWv
        pb =
      Vector.ofFn fun i => Ty.extractVecElem 4 64 i (Memory.spliceBits xb 192 yb) := by
  have hd : (Range.of (pa.add 24#64) 64).Disjoint (Range.of pb 256) :=
    Or.inl (by simpa [Range.of, Pointer.add] using hab)
  have hd' : (Range.of pa 256).Disjoint (Range.of pb 256) := Or.inl (by simpa [Range.of] using hab)
  rw [MemoryState.readWv,
    MemoryState.readAt_add_storeAt (hb.storeAt.storeAt.storeAt) (by simp [ho, BitVec.uaddOverflow])
      (by decide),
    MemoryState.readAt_storeAt_disjoint hd, MemoryState.readAt_storeAt_self hb.storeAt]
  rfl

/-- A decoded point as a QUAD `(x, y, 1, x y)`: `x` times `sqrtM1` unless `t1nz` is `0`, folded,
then negated if its parity `diagS` is not `x0`. -/
abbrev decodePt (mulS : Vector (BitVec 64) 8 → Vector (BitVec 64) 8 → Vector (BitVec 64) 8)
    (diagS : Vector (BitVec 64) 8 → BitVec 32) (sqrtM1 one x y : Vector (BitVec 64) 8)
    (t1nz x0 : BitVec 32) :
    Vector (BitVec 64) 8 × Vector (BitVec 64) 8 × Vector (BitVec 64) 8 × Vector (BitVec 64) 8 :=
  let x' := fold (mulS x (if t1nz = 0 then one else sqrtM1))
  let x'' := if diagS x' = x0 then x' else negFold x'
  (x'', y, one, fold (mulS x'' y))

/-- `FD_R43X6_QUAD_PACK`'s stores of the QUAD `(x, y, z, t)` at `p03 p14 p25`. -/
abbrev packAt (m : MemoryState) (p03 p14 p25 : Pointer)
    (q :
      Vector (BitVec 64) 8 × Vector (BitVec 64) 8 × Vector (BitVec 64) 8 × Vector (BitVec 64) 8) :
    MemoryState :=
  let (x, y, z, t) := q
  ((m.storeAt p03 (BitVec.packLanes (quadLanes 0 x y z t))).storeAt p14
        (BitVec.packLanes (quadLanes 1 x y z t))).storeAt
    p25 (BitVec.packLanes (quadLanes 2 x y z t))

/-- `FD_R43X6_QUAD_FOLD_UNSIGNED`'s stores of the packed QUAD `(x, y, z, t)` at `p03 p14 p25`. -/
abbrev foldAt (m : MemoryState) (p03 p14 p25 : Pointer)
    (q :
      Vector (BitVec 64) 8 × Vector (BitVec 64) 8 × Vector (BitVec 64) 8 × Vector (BitVec 64) 8) :
    MemoryState :=
  let (x, y, z, t) := q
  ((m.storeAt p03
            (BitVec.packLanes (quadFold03 (quadLanes 0 x y z t) (quadLanes 2 x y z t)))).storeAt
        p14 (BitVec.packLanes (quadFold14 (quadLanes 1 x y z t) (quadLanes 0 x y z t)))).storeAt
    p25 (BitVec.packLanes (quadFold25 (quadLanes 2 x y z t) (quadLanes 1 x y z t)))

/-- `fd_r43x6_d()`. -/
@[mlir_const]
def d : Vector (BitVec 64) 8 :=
  #v[6365466163363, 253762649449, 7518893317, 260847760460, 7696165686388, 704489577558, 0, 0]

/-- `fd_r43x6_imag()`, the root of `-1`. -/
@[mlir_const]
def sqrtM1 : Vector (BitVec 64) 8 :=
  #v[3467281080496, 6582290652611, 5210002954932, 329084955603, 4526638806224, 373767602335, 0, 0]

/-- `fd_r43x6_p() - one`, less `fd_r43x6_fold_signed`'s bias: `fd_r43x6_sub( _, one )`'s constant,
as compiled. -/
@[mlir_const]
def pSubOne : Vector (BitVec 64) 8 :=
  #v[8795933638636, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]

/-- Lane-wise `x - y`. -/
abbrev vsub (x y : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  Vector.ofFn fun i => x[i.1] - y[i.1]

/-- One encoding through `fd_r43x6_ge_decode2`'s checks: `y3` with its sign bit cleared, the sign
`x_0`, `y`, `u = y² - 1` (`pre` before `fd_r43x6_fold_signed`'s bias), `v = d y² + 1`, the power
`t0`, the candidate `x`, `v x²`, and whether `t1 = v x² - u` and `t2 = v x² + u` are nonzero. -/
structure Dec where
  y3 : BitVec 64
  x0 : BitVec 32
  y : Vector (BitVec 64) 8
  pre : Vector (BitVec 64) 8
  u : Vector (BitVec 64) 8
  v : Vector (BitVec 64) 8
  t0 : Vector (BitVec 64) 8
  x : Vector (BitVec 64) 8
  vx2 : Vector (BitVec 64) 8
  t1nz : BitVec 32
  t2nz : BitVec 32

/-- `fd_r43x6_ge_decode2`'s HPC path on the encoding `s`, up to its checks. -/
def dec (s : BitVec 256) : Dec :=
  let y3 := s.extractLsb' 192 64
  let x0 := (y3 >>> 63).setWidth 32
  let y3 := y3 &&& 0x7FFFFFFFFFFFFFFF
  let y :=
    fd_r43x6_unpack.spec
      (Vector.ofFn fun i => Ty.extractVecElem 4 64 i (Memory.spliceBits s 192 y3))
  let ysq := fold (fd_r43x6_sqr_fast.spec y)
  let pre := foldSignedPre (vadd ysq pSubOne)
  let u := vadd pre negBias
  let v := vadd (fold (fd_r43x6_mul_fast.spec d ysq)) one
  let v2 := fold (fd_r43x6_sqr_fast.spec v)
  let v4 := fold (fd_r43x6_sqr_fast.spec v2)
  let v3 := fold (fd_r43x6_mul_fast.spec v v2)
  let uv3 := fold (fd_r43x6_mul_fast.spec u v3)
  let uv7 := fold (fd_r43x6_mul_fast.spec uv3 v4)
  let t0 := fd_r43x6_pow22523_2.spec uv7
  let x := fold (fd_r43x6_mul_fast.spec uv3 t0)
  let vx2 := fold (fd_r43x6_mul_fast.spec v (fold (fd_r43x6_sqr_fast.spec x)))
  ⟨y3, x0, y, pre, u, v, t0, x, vx2, fd_r43x6_is_nonzero.spec (vadd (vsub vx2 pre) negP),
    fd_r43x6_is_nonzero.spec (vadd vx2 u)⟩

/-- `A`'s checks pass: `t1` or `t2` is zero, so `x` or `sqrt_m1 x` is a root. -/
def Dec.ok (A : Dec) : Prop :=
  A.t2nz &&& A.t1nz = 0#32

-- classical: deciding it would make the kernel evaluate `fd_r43x6_is_nonzero.spec`
noncomputable instance (A : Dec) : Decidable A.ok :=
  Classical.propDecidable _

/-- The state `^bb0` leaves: the slots `_sa _sb _t0a _t0b`, the encodings copied in with their
sign bits cleared, the powers stored in `_t0a _t0b` and freed, and `fd_r43x6_pow22523_2`'s frames
counted. -/
def frame (S₀ : GlobalState) (sa sb : Pointer) (A B : Dec) : GlobalState :=
  let S₁ := slots4 S₀
  let pa := S₀.allocaPtr
  let pb := (S₀.alloca 32 true).allocaPtr
  let t0a := ((S₀.alloca 32 true).alloca 32 true).allocaPtr
  let t0b := (((S₀.alloca 32 true).alloca 32 true).alloca 64 true).allocaPtr
  { alloc := ⟨S₁.alloc.nextFreeBlock + 20⟩,
    mem :=
      (((((((((((S₁.mem.lifetimeStart pa).lifetimeStart pb).storeAt pa
                                            (S₀.mem.readAt sa 256)).storeAt
                                        pb (S₀.mem.readAt sb 256)).storeAt
                                    (pa.add 24) A.y3).storeAt
                                (pb.add 24) B.y3).lifetimeStart
                            t0a).lifetimeStart
                        t0b).storeAt
                    t0a (BitVec.packLanes A.t0)).storeAt
                t0b (BitVec.packLanes B.t0)).lifetimeEnd
            t0b).lifetimeEnd
        t0a }

variable (a03 a14 a25 b03 b14 b25) in
/-- `fd_r43x6_ge_decode2`'s result from the state `S` and both encodings' checks: `-1` or `-2` with
the out-vectors zeroed, else `0` with both points stored as folded QUADs; then `e` (the copies'
lifetimes' ends). -/
noncomputable def result (e : MemoryState → MemoryState) (S : GlobalState) (A B : Dec) :
    PoisonOr (Vals [.bv 32] × GlobalState) :=
  if A.ok then
    if B.ok then
      let PA :=
        decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one A.x A.y A.t1nz A.x0
      let PB :=
        decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one B.x B.y B.t1nz B.x0
      .value
        (.cons (.value 0) .nil,
          { S with
            mem :=
              e
                (foldAt
                  (foldAt (packAt (packAt S.mem a03 a14 a25 PA) b03 b14 b25 PB) a03 a14 a25 PA) b03
                  b14 b25 PB) })
    else
      .value
        (.cons (.value (-2)) .nil,
          { S with mem := e (fill a03 a14 a25 b03 b14 b25 S.mem (Vector.replicate 8 0)) })
  else
    .value
      (.cons (.value (-1)) .nil,
        { S with mem := e (fill a03 a14 a25 b03 b14 b25 S.mem (Vector.replicate 8 0)) })

/-- `^bb2`'s entry env: `^bb0`'s constants it reads, the copies `pa pb`, the points' coordinates
`xa ya`, `xb yb`, their signs `x0a x0b` and whether `t1nza t1nzb` are nonzero. -/
abbrev entry (E : ⟪Γ⟫) (pa pb : Pointer) (sqrtM1 xa ya xb yb : Vector (BitVec 64) 8)
    (x0a x0b t1nza t1nzb : BitVec 32) : ⟪Γ⟫ :=
  E[%1909 := quadFoldMask, %1910 := Vector.replicate 8 8796093022207, %1912 := quadShifts, %1913 :=
    Vector.replicate 8 43, %1915 := sqrtM1, %1916 := 255#8, %1920 := negP, %1921 := one, %1923 :=
    negBias, %1924 := negSel, %1925 := neg18, %1936 := foldMask, %1937 := foldShifts, %1939 :=
    foldK, %1944 := 0#32, %1952 := zeroLo, %1960 := oneLo, %1968 := oneHi, %1976 := quad19, %1977 :=
    pa, %1978 := pb, %1986 := x0a, %1988 := x0b, %1992 := ya, %1994 := yb, %2091 := xa, %2096 := xb,
    %2122 := t1nza, %2123 := t1nzb]

/-- `^bb2`: both encodings decode; finish both points and store them as QUADs. -/
theorem bb2_run (E : ⟪Γ⟫) (S₀ : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (pa pb : Pointer)
    (sqrtM1 xa ya xb yb : Vector (BitVec 64) 8) (x0a x0b t1nza t1nzb : BitVec 32)
    (ht1nza01 : t1nza = 0 ∨ t1nza = 1) (ht1nzb01 : t1nzb = 0 ∨ t1nzb = 1)
    (ha03 : Room S₀.mem a03 512) (ha14 : Room S₀.mem a14 512) (ha25 : Room S₀.mem a25 512)
    (hb03 : Room S₀.mem b03 512) (hb14 : Room S₀.mem b14 512) (hb25 : Room S₀.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) (hwf : S₀.WF) :
    func.runFrom (entry E pa pb sqrtM1 xa ya xb yb x0a x0b t1nza t1nzb) ^bb2 S₀ =
      let A := decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one xa ya t1nza x0a
      let B := decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one xb yb t1nzb x0b
      .value
        (.cons (.value 0) .nil,
          { S₀ with
            mem :=
              ((foldAt (foldAt (packAt (packAt S₀.mem a03 a14 a25 A) b03 b14 b25 B) a03 a14 a25 A)
                        b03 b14 b25 B).lifetimeEnd
                    pb).lifetimeEnd
                pa }) := by
  have hmul : MulFast.Spec fd_r43x6_mul_fast.call fd_r43x6_mul_fast.spec := fun x y s hwf =>
    fd_r43x6_mul_fast.call_eq x y s hwf
  have hdiag := fd_r43x6_diagnose.call_eq
  block_init
  -- `t3a = fd_r43x6_if( t1nza, sqrt_m1, one )`, `t3b` likewise
  step_pattern using runBodyFrom_ifRun with t3a
  step_pattern using runBodyFrom_ifRun with t3b
  -- `FD_R43X6_MUL2_INL( xa, xa, t3a, xb, xb, t3b )`
  step_pattern using runBodyFrom_mulInlRun with xa'
  step_pattern using runBodyFrom_mulInlRun with xb'
  -- `x_mod_2a = fd_r43x6_diagnose( xa )`, `x_mod_2b` likewise
  step_call using hdiag with xmod2a
  step_call using hdiag with xmod2b
  -- `xa = fd_r43x6_if( x_0a!=x_mod_2a, fd_r43x6_neg( xa ), xa )`, `xb` likewise
  step_pattern using runBodyFrom_negIfRun with xa''
  step_pattern using runBodyFrom_negIfRun with xb''
  -- `FD_R43X6_MUL2_INL( xya, xa, ya, xyb, xb, yb )`
  step_pattern using runBodyFrom_mulInlRun with xya
  step_pattern using runBodyFrom_mulInlRun with xyb
  -- `FD_R43X6_QUAD_PACK( a, xa, ya, one, xya )`, `b` likewise
  step_pattern using runBodyFrom_quadPackRun
  step_pattern using runBodyFrom_quadPackRun
  -- `FD_R43X6_QUAD_FOLD_UNSIGNED( *_Pa, a )`, `b` likewise; `b`'s limbs `2 5` stored in `^bb5`
  step_pattern using runBodyFrom_quadFoldRun with a'
  step_store
  step_pattern using runBodyFrom_quadFoldRun with b'
  finish_block
  -- `^bb5`'s result, then the named values against the statement's
  run_from using bb5_run (v := b') (r := 0)
  subst_vars
  rfl

/-- An env with `entry`'s values is its `entry`. -/
theorem entry_eq (E : ⟪Γ⟫) (pa pb : Pointer) (sqrtM1 xa ya xb yb : Vector (BitVec 64) 8)
    (x0a x0b t1nza t1nzb : BitVec 32)
    (hR :
      E ⊨ [%1909 := quadFoldMask, %1910 := Vector.replicate 8 8796093022207, %1912 := quadShifts,
        %1913 := Vector.replicate 8 43, %1915 := sqrtM1, %1916 := 255#8, %1920 := negP, %1921 :=
        one, %1923 := negBias, %1924 := negSel, %1925 := neg18, %1936 := foldMask, %1937 :=
        foldShifts, %1939 := foldK, %1944 := 0#32, %1952 := zeroLo, %1960 := oneLo, %1968 := oneHi,
        %1976 := quad19, %1977 := pa, %1978 := pb, %1986 := x0a, %1988 := x0b, %1992 := ya, %1994 :=
        yb, %2091 := xa, %2096 := xb, %2122 := t1nza, %2123 := t1nzb]) :
    entry E pa pb sqrtM1 xa ya xb yb x0a x0b t1nza t1nzb = E := by
  simp only [entry]
  repeat rw [Env.write_of_read]
  all_goals simp [mlir_env, hR]

/-- `bb2_run` for an env holding `entry`'s values. -/
theorem bb2_run' (E : ⟪Γ⟫) (S₀ : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (pa pb : Pointer)
    (sqrtM1 xa ya xb yb : Vector (BitVec 64) 8) (x0a x0b t1nza t1nzb : BitVec 32)
    (hR :
      E ⊨ [%1909 := quadFoldMask, %1910 := Vector.replicate 8 8796093022207, %1912 := quadShifts,
        %1913 := Vector.replicate 8 43, %1915 := sqrtM1, %1916 := 255#8, %1920 := negP, %1921 :=
        one, %1923 := negBias, %1924 := negSel, %1925 := neg18, %1936 := foldMask, %1937 :=
        foldShifts, %1939 := foldK, %1944 := 0#32, %1952 := zeroLo, %1960 := oneLo, %1968 := oneHi,
        %1976 := quad19, %1977 := pa, %1978 := pb, %1986 := x0a, %1988 := x0b, %1992 := ya, %1994 :=
        yb, %2091 := xa, %2096 := xb, %2122 := t1nza, %2123 := t1nzb])
    (ht1nza01 : t1nza = 0 ∨ t1nza = 1) (ht1nzb01 : t1nzb = 0 ∨ t1nzb = 1)
    (ha03 : Room S₀.mem a03 512) (ha14 : Room S₀.mem a14 512) (ha25 : Room S₀.mem a25 512)
    (hb03 : Room S₀.mem b03 512) (hb14 : Room S₀.mem b14 512) (hb25 : Room S₀.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) (hwf : S₀.WF) :
    func.runFrom E ^bb2 S₀ =
      let A := decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one xa ya t1nza x0a
      let B := decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one xb yb t1nzb x0b
      .value
        (.cons (.value 0) .nil,
          { S₀ with
            mem :=
              ((foldAt (foldAt (packAt (packAt S₀.mem a03 a14 a25 A) b03 b14 b25 B) a03 a14 a25 A)
                        b03 b14 b25 B).lifetimeEnd
                    pb).lifetimeEnd
                pa }) := by
  have h :=
    bb2_run E S₀ hArgs pa pb sqrtM1 xa ya xb yb x0a x0b t1nza t1nzb ht1nza01 ht1nzb01 ha03 ha14 ha25
      hb03 hb14 hb25 hids hwf
  rwa [entry_eq E pa pb sqrtM1 xa ya xb yb x0a x0b t1nza t1nzb hR] at h

-- the entry block: two unpacks and the square-root chain, about 300 instructions
set_option maxHeartbeats 1000000 in
/-- `^bb0`: both encodings unpacked to `y`, `x` recovered from `x² = (y² - 1) / (d y² + 1)` up to
the root of `-1`, and checked; on to `^bb1`, else `^bb3`. -/
theorem bb0_run (E : ⟪Γ⟫) (S₀ : GlobalState)
    (hArgs : E.args = (argsOf a03 a14 a25 sa b03 b14 b25 sb).get) (hwf : S₀.WF)
    (hsa : Fits S₀.mem sa 256) (hsb : Fits S₀.mem sb 256) (ha03 : Room S₀.mem a03 512)
    (ha14 : Room S₀.mem a14 512) (ha25 : Room S₀.mem a25 512) (hb03 : Room S₀.mem b03 512)
    (hb14 : Room S₀.mem b14 512) (hb25 : Room S₀.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) :
    func.runFrom E ^bb0 S₀ =
      let A := dec (S₀.mem.readAt sa 256)
      let B := dec (S₀.mem.readAt sb 256)
      result a03 a14 a25 b03 b14 b25
        (fun m => (m.lifetimeEnd (S₀.alloca 32 true).allocaPtr).lifetimeEnd S₀.allocaPtr)
        (frame S₀ sa sb A B) A B := by
  have hld := wv_ld.call_eq
  have hunpack := fd_r43x6_unpack.call_eq
  have hsqr : SqrFast.Spec fd_r43x6_sqr_fast.call fd_r43x6_sqr_fast.spec := fun x s hwf =>
    fd_r43x6_sqr_fast.call_eq x s hwf
  have hmul : MulFast.Spec fd_r43x6_mul_fast.call fd_r43x6_mul_fast.spec := fun x y s hwf =>
    fd_r43x6_mul_fast.call_eq x y s hwf
  have hpow := fd_r43x6_pow22523_2.call_eq
  have hnz := fd_r43x6_is_nonzero.call_eq
  -- the copies' reads, about the entry state
  have hwva :=
    readWv_copy_a (GlobalState.slot_id_ne (i := 0) (j := 1) (by decide)) (m :=
      ((slots4 S₀).mem.lifetimeStart (S₀.slot 0)).lifetimeStart (S₀.slot 1))
      ((Room.lifetimeStart_self (inBounds_slot0 hwf) (writable_slot0 hwf)).lifetimeStart
        (GlobalState.slot_id_ne (by decide)))
      rfl (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)
  have hwvb :=
    readWv_copy_b (GlobalState.slot_id_ne (i := 0) (j := 1) (by decide)) (m :=
      ((slots4 S₀).mem.lifetimeStart (S₀.slot 0)).lifetimeStart (S₀.slot 1))
      (Room.lifetimeStart_self (inBounds_slot1 hwf).lifetimeStart
        (writable_slot1 hwf).lifetimeStart)
      rfl (S₀.mem.readAt sa 256) (S₀.mem.readAt sb 256)
  block_init
  -- `one`, `d`, `sqrt_m1`, the fold's and `fd_r43x6_neg`'s constants
  iterate 36 step_pure
  -- `zeroLo`, `oneLo`, `oneHi` and `quad19`, lane by lane
  iterate 4 step_pattern using runBodyFrom_insertRun
  -- `_sa`, `_sb`, and the two stack slots `fd_r43x6_pow22523_2` stores to
  step_alloca with _sa
  step_alloca with _sb
  step_alloca with _t0a
  step_alloca with _t0b
  iterate 2 step_pure
  -- `memcpy( _sa, _vsa, 32UL )`, `_sb` likewise
  step_memcpy
  step_memcpy
  -- `y3a = _sa[3]`, `y3b = _sb[3]`
  step_pure
  step_load with y3a
  step_pure
  step_load with y3b
  -- `x_0a = (int)(y3a>>63)`, `x_0b` likewise
  step_pure
  step_pure [shr63_trunc] with x_0a
  step_pure
  step_pure [shr63_trunc] with x_0b
  -- `y3a &= ~(1UL<<63); _sa[3] = y3a`, `b` likewise
  step_pure with transparent y3a'
  step_pure with transparent y3b'
  step_store
  step_store
  -- `ya = fd_r43x6_unpack( wv_ld( _sa ) )`, `yb` likewise
  step_call using hld with lda
  step_call using hunpack with ya
  step_call using hld with ldb
  step_call using hunpack with yb
  -- `FD_R43X6_SQR2_INL( ysqa, ya, ysqb, yb )`
  step_pattern using runBodyFrom_sqrInlRun with ysqa
  step_pattern using runBodyFrom_sqrInlRun with ysqb
  -- `ua = fd_r43x6_sub( ysqa, one )`, `ub` likewise
  step_pattern using runBodyFrom_subRun with ua
  step_pattern using runBodyFrom_subRun with ub
  -- `va = fd_r43x6_add_fast( fd_r43x6_mul( d, ysqa ), one )`, `vb` likewise
  step_pattern using runBodyFrom_mulInlRun with dysqa
  step_pure with va
  step_pattern using runBodyFrom_mulInlRun with dysqb
  step_pure with vb
  -- `FD_R43X6_SQR2_INL( v2a, va, v2b, vb )`, then `v4`
  step_pattern using runBodyFrom_sqrInlRun with v2a
  step_pattern using runBodyFrom_sqrInlRun with v2b
  step_pattern using runBodyFrom_sqrInlRun with v4a
  step_pattern using runBodyFrom_sqrInlRun with v4b
  -- `FD_R43X6_MUL2_INL( v3a, va,v2a, v3b, vb,v2b )`, then `uv3`, `uv7`
  step_pattern using runBodyFrom_mulInlRun with v3a
  step_pattern using runBodyFrom_mulInlRun with v3b
  step_pattern using runBodyFrom_mulInlRun with uv3a
  step_pattern using runBodyFrom_mulInlRun with uv3b
  step_pattern using runBodyFrom_mulInlRun with uv7a
  step_pattern using runBodyFrom_mulInlRun with uv7b
  -- `FD_R43X6_POW22523_2_INL( t0a, uv7a, t0b, uv7b )`, through the slots `_t0a _t0b`
  iterate 2 step_pure
  step_call using hpow
  step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with t0a
  step_load [Ty.extractVecElem_packLanes, Vector.ofFn_getElem] with t0b
  iterate 2 step_pure
  -- `FD_R43X6_MUL2_INL( xa, uv3a,t0a, xb, uv3b,t0b )`, `x2`, then `vx2 = v x2`
  step_pattern using runBodyFrom_mulInlRun with xa
  step_pattern using runBodyFrom_mulInlRun with xb
  step_pattern using runBodyFrom_sqrInlRun with x2a
  step_pattern using runBodyFrom_sqrInlRun with x2b
  step_pattern using runBodyFrom_mulInlRun with vx2a
  step_pattern using runBodyFrom_mulInlRun with vx2b
  -- `t1a = fd_r43x6_sub_fast( vx2a, ua )`, `t1b` likewise, `t2a = fd_r43x6_add_fast( vx2a, ua )`
  step_pure
  step_pure with t1a
  step_pure
  step_pure with t1b
  step_pure with t2a
  -- `t1nza = fd_r43x6_is_nonzero( t1a )`, `t1nzb`, `t2nza`; `t1nza & t2nza` fails
  step_call using hnz with t1nza
  step_call using hnz with t1nzb
  step_call using hnz with t2nza
  step_pure with transparent nza
  step_pure with transparent faila
  -- both encodings' `dec`, as the values just computed
  have hA :
    dec (S₀.mem.readAt sa 256) =
      ⟨y3a &&& 0x7FFFFFFFFFFFFFFF, x_0a, ya, foldSignedPre (vadd ysqa pSubOne), ua, va, t0a, xa,
        vx2a, t1nza, t2nza⟩ := by
    clear hS hE
    subst_vars
    simp only [dec, vadd, vsub, one, d, pSubOne, Vector.getElem_ofFn, Vector.getElem_mk,
      List.getElem_toArray]
    simp only [hwva]
    rfl
  have hB :
    dec (S₀.mem.readAt sb 256) =
      ⟨y3b &&& 0x7FFFFFFFFFFFFFFF, x_0b, yb, foldSignedPre (vadd ysqb pSubOne), ub, vb, t0b, xb,
        vx2b, t1nzb, fd_r43x6_is_nonzero.spec (vadd vx2b ub)⟩ := by
    clear hS hE
    subst_vars
    simp only [dec, vadd, vsub, one, d, pSubOne, Vector.getElem_ofFn, Vector.getElem_mk,
      List.getElem_toArray]
    simp only [hwvb]
    rfl
  have hF : frame S₀ sa sb (dec (S₀.mem.readAt sa 256)) (dec (S₀.mem.readAt sb 256)) = S := by
    rw [hA, hB]
    clear hE
    subst_vars
    rfl
  rw [hA, hB] at hF ⊢
  finish_block
  · -- `^bb1`
    simp only [result, Dec.ok, hF]
    rw [ite_eq_left hbr]
    run_from using bb1_run (x := vx2b) (y := ub) (z := Vector.replicate 8 0) (c := t1nzb) (r := -2)
    -- both sides test `B`'s checks
    split
    · run_from using
        bb2_run' (sa := sa) (sb := sb) (ht1nza01 := ht1nza ▸ fd_r43x6_is_nonzero.spec_01 _)
          (ht1nzb01 := ht1nzb ▸ fd_r43x6_is_nonzero.spec_01 _)
      rw [hE] at hArgs
      simp at hArgs
      assumption
    · rfl
  · -- `^bb3`
    simp only [result, Dec.ok, hF]
    rw [ite_eq_right hbr]
    run_from using bb3_run

/-- `fd_r43x6_ge_decode2` on the encodings at `sa sb`, into the out-vectors `a03 … b25`: `result`
over the caller's memory, with `24` blocks counted for the frames it used. -/
theorem call_eq_result (s : GlobalState) (hwf : s.WF) (hsa : Fits s.mem sa 256)
    (hsb : Fits s.mem sb 256) (ha03 : Room s.mem a03 512) (ha14 : Room s.mem a14 512)
    (ha25 : Room s.mem a25 512) (hb03 : Room s.mem b03 512) (hb14 : Room s.mem b14 512)
    (hb25 : Room s.mem b25 512) (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) :
    fd_r43x6_ge_decode2.call (argsOf a03 a14 a25 sa b03 b14 b25 sb) s =
      let A := dec (s.mem.readAt sa 256)
      let B := dec (s.mem.readAt sb 256)
      result a03 a14 a25 b03 b14 b25 id ⟨⟨s.alloc.nextFreeBlock + 24⟩, s.mem⟩ A B := by
  func_init
  subst_vars
  rw [bb0_run _ _ hEargs hwf₀ hsa hsb ha03 ha14 ha25 hb03 hb14 hb25 hids]
  simp only [result]
  generalize dec (S.mem.readAt sa 256) = A, dec (S.mem.readAt sb 256) = B
  by_cases ha : A.ok <;> by_cases hb : B.ok <;>
    simp only [ha, hb, ↓reduceIte, PoisonOr.value_bind, frame, GlobalState.alloca_alloc, fill,
      foldAt, packAt, Nat.add_assoc, id_eq] <;>
    erase_frame

/-! ### The result as out-vectors -/

/-- A failure's out-vectors: zero. -/
def zeroQuad : Quad :=
  ⟨Vector.replicate 8 0, Vector.replicate 8 0, Vector.replicate 8 0⟩

/-- A decoded point `(x, y, z, t)` packed into a QUAD and folded, as `^bb2` stores it. -/
def quadOf (P : Wwl × Wwl × Wwl × Wwl) : Quad :=
  let (x, y, z, t) := P
  ⟨quadFold03 (quadLanes 0 x y z t) (quadLanes 2 x y z t),
    quadFold14 (quadLanes 1 x y z t) (quadLanes 0 x y z t),
    quadFold25 (quadLanes 2 x y z t) (quadLanes 1 x y z t)⟩

/-- The return value and both points: `0` and the decoded points, or `-1`/`-2` and zeros. -/
noncomputable def spec (A B : Dec) : BitVec 32 × Quad × Quad :=
  if A.ok then
    if B.ok then
      (0,
        quadOf
          (decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one A.x A.y A.t1nz A.x0),
        quadOf
          (decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one B.x B.y B.t1nz B.x0))
    else (-2, zeroQuad, zeroQuad)
  else (-1, zeroQuad, zeroQuad)

variable (a03 a14 a25 b03 b14 b25) in
/-- The out-vectors stored: `P` at `a03 a14 a25`, then `Q` at `b03 b14 b25`. -/
abbrev storeOut (m : MemoryState) (P Q : Quad) : MemoryState :=
  (((((m.storeVec a03 P.P03).storeVec a14 P.P14).storeVec a25 P.P25).storeVec b03 Q.P03).storeVec
        b14 Q.P14).storeVec
    b25 Q.P25

theorem storeAt_swap_id {m : MemoryState} {p q : Pointer} {x : BitVec v} {y : BitVec w}
    (h : p.id ≠ q.id) : (m.storeAt p x).storeAt q y = (m.storeAt q y).storeAt p x :=
  MemoryState.storeAt_swap (Or.inl (by simpa [Range.of] using h))

theorem readAt_storeAt_ne {m : MemoryState} {p q : Pointer} {x : BitVec v} (h : p.id ≠ q.id) :
    (m.storeAt p x).readAt q w = m.readAt q w :=
  MemoryState.readAt_storeAt_disjoint (Or.inl (by simpa [Range.of] using h)) x

/-- Six distinct block ids, each against the ones after it. -/
theorem ids_ne {i0 i1 i2 i3 i4 i5 : BlockId} (h : [i0, i1, i2, i3, i4, i5].Nodup) :
    (i0 ≠ i1 ∧ i0 ≠ i2 ∧ i0 ≠ i3 ∧ i0 ≠ i4 ∧ i0 ≠ i5) ∧
      (i1 ≠ i2 ∧ i1 ≠ i3 ∧ i1 ≠ i4 ∧ i1 ≠ i5) ∧
      (i2 ≠ i3 ∧ i2 ≠ i4 ∧ i2 ≠ i5) ∧ (i3 ≠ i4 ∧ i3 ≠ i5) ∧ i4 ≠ i5 := by
  simp only [List.nodup_cons, List.mem_cons, List.mem_nil_iff, or_false, not_or] at h
  grind

/-! The out-vectors read back from `storeOut`, each where its block fits. -/

section ReadOut

variable {m : MemoryState} {P Q : Quad}
  (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup)

include hids

theorem readAt_storeOut_a03 (hf : Room m a03 512) :
    (storeOut a03 a14 a25 b03 b14 b25 m P Q).readAt a03 512 = BitVec.packLanes P.P03 := by
  obtain ⟨⟨h01, h02, h03, h04, h05⟩, -⟩ := ids_ne hids
  simp only [storeOut, MemoryState.storeVec, readAt_storeAt_ne (Ne.symm h05),
    readAt_storeAt_ne (Ne.symm h04), readAt_storeAt_ne (Ne.symm h03),
    readAt_storeAt_ne (Ne.symm h02), readAt_storeAt_ne (Ne.symm h01),
    MemoryState.readAt_storeAt_self hf]

theorem readAt_storeOut_a14 (hf : Room m a14 512) :
    (storeOut a03 a14 a25 b03 b14 b25 m P Q).readAt a14 512 = BitVec.packLanes P.P14 := by
  obtain ⟨-, ⟨h12, h13, h14, h15⟩, -⟩ := ids_ne hids
  simp only [storeOut, MemoryState.storeVec, readAt_storeAt_ne (Ne.symm h15),
    readAt_storeAt_ne (Ne.symm h14), readAt_storeAt_ne (Ne.symm h13),
    readAt_storeAt_ne (Ne.symm h12), MemoryState.readAt_storeAt_self hf.storeAt]

theorem readAt_storeOut_a25 (hf : Room m a25 512) :
    (storeOut a03 a14 a25 b03 b14 b25 m P Q).readAt a25 512 = BitVec.packLanes P.P25 := by
  obtain ⟨-, -, ⟨h23, h24, h25⟩, -⟩ := ids_ne hids
  simp only [storeOut, MemoryState.storeVec, readAt_storeAt_ne (Ne.symm h25),
    readAt_storeAt_ne (Ne.symm h24), readAt_storeAt_ne (Ne.symm h23),
    MemoryState.readAt_storeAt_self hf.storeAt.storeAt]

theorem readAt_storeOut_b03 (hf : Room m b03 512) :
    (storeOut a03 a14 a25 b03 b14 b25 m P Q).readAt b03 512 = BitVec.packLanes Q.P03 := by
  obtain ⟨-, -, -, ⟨h34, h35⟩, -⟩ := ids_ne hids
  simp only [storeOut, MemoryState.storeVec, readAt_storeAt_ne (Ne.symm h35),
    readAt_storeAt_ne (Ne.symm h34), MemoryState.readAt_storeAt_self hf.storeAt.storeAt.storeAt]

theorem readAt_storeOut_b14 (hf : Room m b14 512) :
    (storeOut a03 a14 a25 b03 b14 b25 m P Q).readAt b14 512 = BitVec.packLanes Q.P14 := by
  obtain ⟨-, -, -, -, h45⟩ := ids_ne hids
  simp only [storeOut, MemoryState.storeVec, readAt_storeAt_ne (Ne.symm h45),
    MemoryState.readAt_storeAt_self hf.storeAt.storeAt.storeAt.storeAt]

omit hids in
theorem readAt_storeOut_b25 (hf : Room m b25 512) :
    (storeOut a03 a14 a25 b03 b14 b25 m P Q).readAt b25 512 = BitVec.packLanes Q.P25 := by
  simp only [storeOut, MemoryState.storeVec,
    MemoryState.readAt_storeAt_self hf.storeAt.storeAt.storeAt.storeAt.storeAt]

end ReadOut

/-- Twelve stores to six distinct blocks, the second six overwriting the first: the second six. -/
theorem storeAt_twice {m : MemoryState} {x1 x2 x3 x4 x5 x6 y1 y2 y3 y4 y5 y6 : BitVec 512}
    (h01 : a03.id ≠ a14.id) (h02 : a03.id ≠ a25.id) (h03 : a03.id ≠ b03.id) (h04 : a03.id ≠ b14.id)
    (h05 : a03.id ≠ b25.id) (h12 : a14.id ≠ a25.id) (h13 : a14.id ≠ b03.id) (h14 : a14.id ≠ b14.id)
    (h15 : a14.id ≠ b25.id) (h23 : a25.id ≠ b03.id) (h24 : a25.id ≠ b14.id) (h25 : a25.id ≠ b25.id)
    (h34 : b03.id ≠ b14.id) (h35 : b03.id ≠ b25.id) (h45 : b14.id ≠ b25.id) :
    (((((((((((m.storeAt a03 x1).storeAt a14 x2).storeAt a25 x3).storeAt b03 x4).storeAt b14
                                    x5).storeAt
                                b25 x6).storeAt
                            a03 y1).storeAt
                        a14 y2).storeAt
                    a25 y3).storeAt
                b03 y4).storeAt
            b14 y5).storeAt
        b25 y6 =
      (((((m.storeAt a03 y1).storeAt a14 y2).storeAt a25 y3).storeAt b03 y4).storeAt b14 y5).storeAt
        b25 y6 := by
  rw [storeAt_swap_id (Ne.symm h05), storeAt_swap_id (Ne.symm h04), storeAt_swap_id (Ne.symm h03),
    storeAt_swap_id (Ne.symm h02), storeAt_swap_id (Ne.symm h01), MemoryState.storeAt_storeAt_same,
    storeAt_swap_id (Ne.symm h15), storeAt_swap_id (Ne.symm h14), storeAt_swap_id (Ne.symm h13),
    storeAt_swap_id (Ne.symm h12), MemoryState.storeAt_storeAt_same, storeAt_swap_id (Ne.symm h25),
    storeAt_swap_id (Ne.symm h24), storeAt_swap_id (Ne.symm h23), MemoryState.storeAt_storeAt_same,
    storeAt_swap_id (Ne.symm h35), storeAt_swap_id (Ne.symm h34), MemoryState.storeAt_storeAt_same,
    storeAt_swap_id (Ne.symm h45), MemoryState.storeAt_storeAt_same,
    MemoryState.storeAt_storeAt_same]

/-- `fill`'s stores in `storeOut`'s order. -/
theorem fill_eq {m : MemoryState} {z : BitVec 512} (h13 : a14.id ≠ b03.id) (h23 : a25.id ≠ b03.id)
    (h24 : a25.id ≠ b14.id) :
    (((((m.storeAt a03 z).storeAt b03 z).storeAt a14 z).storeAt b14 z).storeAt a25 z).storeAt b25
        z =
      (((((m.storeAt a03 z).storeAt a14 z).storeAt a25 z).storeAt b03 z).storeAt b14 z).storeAt b25
        z := by
  rw [storeAt_swap_id (Ne.symm h13), storeAt_swap_id (Ne.symm h24), storeAt_swap_id (Ne.symm h23)]

/-- `fd_r43x6_ge_decode2` on the encodings at `sa sb` stores `spec`'s points at `a03 a14 a25` and
`b03 b14 b25` (six distinct blocks) and returns its value; its frames count `24` blocks. -/
theorem call_eq (s : GlobalState) (hwf : s.WF) (hsa : Fits s.mem sa 256) (hsb : Fits s.mem sb 256)
    (ha03 : Room s.mem a03 512) (ha14 : Room s.mem a14 512) (ha25 : Room s.mem a25 512)
    (hb03 : Room s.mem b03 512) (hb14 : Room s.mem b14 512) (hb25 : Room s.mem b25 512)
    (hids : [a03.id, a14.id, a25.id, b03.id, b14.id, b25.id].Nodup) :
    fd_r43x6_ge_decode2.call (argsOf a03 a14 a25 sa b03 b14 b25 sb) s =
      let R := spec (dec (s.mem.readAt sa 256)) (dec (s.mem.readAt sb 256))
      .value
        (.cons (.value R.1) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 24⟩,
            mem := storeOut a03 a14 a25 b03 b14 b25 s.mem R.2.1 R.2.2 }) := by
  rw [call_eq_result s hwf hsa hsb ha03 ha14 ha25 hb03 hb14 hb25 hids]
  simp only [List.nodup_cons, List.mem_cons, List.mem_nil_iff, or_false, not_or] at hids
  obtain ⟨⟨h01, h02, h03, h04, h05⟩, ⟨h12, h13, h14, h15⟩, ⟨h23, h24, h25⟩, ⟨h34, h35⟩, h45, -⟩ :=
    hids
  generalize dec (s.mem.readAt sa 256) = A, dec (s.mem.readAt sb 256) = B
  by_cases ha : A.ok <;> by_cases hb : B.ok <;> simp only [result, spec, ha, hb, ↓reduceIte, id_eq]
  · simp only [storeOut, MemoryState.storeVec, foldAt, packAt, quadOf]
    rw [storeAt_twice h01 h02 h03 h04 h05 h12 h13 h14 h15 h23 h24 h25 h34 h35 h45]
  all_goals
    simp only [storeOut, MemoryState.storeVec, fill, zeroQuad]
    rw [fill_eq h13 h23 h24]

end

end fd_r43x6_ge_decode2

end MLIR.Firedancer.Avx512
