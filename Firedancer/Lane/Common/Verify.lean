module

public import Firedancer.Lane.Common.Point

/-! Decompression, the small-order test, the signed recodings and `fd_ed25519_lane_verify` of
`fd_ed25519_lane.h`, as functions. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-- Lanes `f j`, limb-major. -/
def Fe.ofLanes (f : Fin 8 → Fin 5 → BitVec 64) : Fe :=
  ⟨Vector.ofFn (f · 0), Vector.ofFn (f · 1), Vector.ofFn (f · 2), Vector.ofFn (f · 3),
    Vector.ofFn (f · 4)⟩

/-- The radix-`2^51` limbs of a 32-byte encoding with bit 255 dropped, read as the C reads them:
the unaligned qwords at bytes 0, 6, 12, 19, 24, shifted and masked. -/
def limbsOfBytes (b : BitVec 256) (i : Fin 5) : BitVec 64 :=
  #v[b.extractLsb' 0 64 &&& mask51, (b.extractLsb' 48 64 >>> 3) &&& mask51,
    (b.extractLsb' 96 64 >>> 6) &&& mask51, (b.extractLsb' 152 64 >>> 1) &&& mask51,
    (b.extractLsb' 192 64 >>> 12) &&& mask51][i]

/-- `fd_ed25519_lane_bcast_fe` of an element whose `fd_f25519_tobytes` is `b`. -/
def bcastBytes (b : BitVec 256) : Fe :=
  Fe.ofLanes fun _ => limbsOfBytes b

/-! ## `fd_ed25519_lane_pow22523_2` -/

/-- `n` squarings, `SQRN2`'s chain on one element (`n ≥ 1`). -/
def sqrN : Nat → Fe → Fe
  | 0, a => a
  | n + 1, a => sqr (sqrN n a)

/-- `a ^ (2^252 - 3)`, the addition chain of `fd_ed25519_lane_pow22523_2` on one of its two
interleaved elements. -/
def pow22523 (a : Fe) : Fe :=
  let t0 := sqr a
  let t1 := sqrN 2 t0
  let t1 := mul a t1
  let t0 := mul t0 t1
  let t0 := sqr t0
  let t0 := mul t1 t0
  let t1 := sqrN 5 t0
  let t0 := mul t1 t0
  let t1 := sqrN 10 t0
  let t1 := mul t1 t0
  let t2 := sqrN 20 t1
  let t1 := mul t2 t1
  let t1 := sqrN 10 t1
  let t0 := mul t1 t0
  let t1 := sqrN 50 t0
  let t1 := mul t1 t0
  let t2 := sqrN 100 t1
  let t1 := mul t2 t1
  let t1 := sqrN 50 t1
  let t0 := mul t1 t0
  let t0 := sqrN 2 t0
  mul t0 a

/-! ## Masks -/

/-- `wwv_ge(x, y)`: bit `i` set when lane `i` of `x` is at least `y`'s, unsigned. -/
def wwl_geu (x y : Wwl) : BitVec 32 :=
  (BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (y[i] ≤ x[i]))).setWidth 32

/-- `wwv_ne(x, y)`. -/
def wwl_ne (x y : Wwl) : BitVec 32 :=
  (BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (x[i] != y[i]))).setWidth 32

/-- The sign bits (bit 255) of eight encodings, as a lane mask. -/
def signs (b : Fin 8 → BitVec 256) : BitVec 32 :=
  (BitVec.packLanes (Vector.ofFn fun j : Fin 8 => BitVec.ofBool ((b j).getLsbD 255))).setWidth 32

/-! ## `fd_ed25519_lane_decode2` -/

/-- One decoding's state before the shared exponentiation: `y`, `u = y² - 1`, `v = d y² + 1`,
`u v³`, `u v⁷`. -/
structure DecPre where
  y : Fe
  u : Fe
  v : Fe
  uv3 : Fe
  uv7 : Fe

/-- The first loop of `fd_ed25519_lane_decode2` on one set of encodings, `d` the broadcast `d`. -/
def decPre (d : Fe) (b : Fin 8 → BitVec 256) : DecPre :=
  let y := Fe.ofLanes fun j => limbsOfBytes (b j)
  let y2 := sqr y
  let v := mul y2 d
  let u := sub y2 Fe.one
  let v := addRaw v Fe.one
  let v2 := sqr v
  let v3 := mul v2 v
  let uv3 := mul u v3
  let uv7 := sqr v3
  let uv7 := mul uv7 v
  let uv7 := mul uv7 u
  ⟨y, u, v, uv3, uv7⟩

/-- The second loop of `fd_ed25519_lane_decode2` on one set, from `x = (u v⁷)^((p-5)/8)`: the
point (the identity in failed lanes) and the success mask. -/
def decFin (sqrtm1 : Fe) (sign : BitVec 32) (pre : DecPre) (x : Fe) : Point × BitVec 32 :=
  let x := mul x pre.uv3
  let check := sqr x
  let check := mul check pre.v
  let correct := isZero (subRaw check pre.u)
  let flipped := isZero (addRaw check pre.u)
  let valid := correct ||| flipped
  let x := Fe.ite (flipped &&& ~~~correct) (mul x sqrtm1) x
  let tmp := normalize x
  let geP := wwl_geu tmp.l0 (wwl_bcast (mask51 - 18)) &&& wwl_eq tmp.l1 (wwl_bcast mask51) &&&
    wwl_eq tmp.l2 (wwl_bcast mask51) &&& wwl_eq tmp.l3 (wwl_bcast mask51) &&&
    wwl_eq tmp.l4 (wwl_bcast mask51)
  let parity := wwl_ne (wwl_and tmp.l0 wwl_one) wwl_zero ^^^ geP
  let x := Fe.ite (sign ^^^ parity) (neg x) x
  let x := Fe.ite valid x Fe.zero
  let y := Fe.ite valid pre.y Fe.one
  (⟨x, y, Fe.one, mul x y⟩, valid)

/-- `fd_ed25519_lane_decode2`: both sets' points and success masks. -/
def decode2 (d sqrtm1 : Fe) (b0 b1 : Fin 8 → BitVec 256) : (Point × BitVec 32) × (Point × BitVec 32) :=
  let p0 := decPre d b0
  let p1 := decPre d b1
  (decFin sqrtm1 (signs b0) p0 (pow22523 p0.uv7), decFin sqrtm1 (signs b1) p1 (pow22523 p1.uv7))

/-- `fd_ed25519_lane_small_order`, `y0`, `y1` the broadcast order-8 `y`s. -/
def smallOrder (y0 y1 : Fe) (r : Point) : BitVec 32 :=
  isZero r.x ||| isZero r.y ||| isZero (subRaw r.y y0) ||| isZero (subRaw r.y y1)

/-! ## Signed recodings -/

/-- Nibble `w` of `s`, as the C's `int`. -/
def nib (s : BitVec 256) (w : Nat) : BitVec 32 :=
  (s >>> (4 * w)).setWidth 32 &&& 15

/-- The carry into window `w` of `fd_ed25519_lane_recode4`. -/
def carry4 (s : BitVec 256) : Nat → BitVec 32
  | 0 => 0
  | w + 1 => (nib s w + carry4 s w + 8).sshiftRight 4

/-- Digit `w` of `fd_ed25519_lane_recode4`, the C's `schar`. -/
def recode4 (s : BitVec 256) (w : Nat) : BitVec 8 :=
  let v := nib s w + carry4 s w
  (v - 16 * (v + 8).sshiftRight 4).setWidth 8

/-- Byte `w` of `s`, as the C's `int`. -/
def byte (s : BitVec 256) (w : Nat) : BitVec 32 :=
  (s >>> (8 * w)).setWidth 32 &&& 255

/-- The carry into window `w` of `fd_ed25519_lane_recode8`. -/
def carry8 (s : BitVec 256) : Nat → BitVec 32
  | 0 => 0
  | w + 1 => (byte s w + carry8 s w + 128).sshiftRight 8

/-- Digit `w` of `fd_ed25519_lane_recode8`, the C's `short`. -/
def recode8 (s : BitVec 256) (w : Nat) : BitVec 16 :=
  let v := byte s w + carry8 s w
  (v - 256 * (v + 128).sshiftRight 8).setWidth 16

/-! ## `fd_ed25519_lane_verify` -/

/-- The table of `[e](-A)`, `e = 0 … 8`, of `fd_ed25519_lane_verify`; `a = -A`. -/
def ktab (a : Point) (k2d : Fe) : Nat → Niels :=
  let n1 := a.toNiels k2d
  let p2 := a.dbl true Fe.zero
  let p3 := p2.add n1 true true Fe.zero
  let p4 := p2.dbl true Fe.zero
  let p5 := p4.add n1 true true Fe.zero
  let p6 := p3.dbl true Fe.zero
  let p7 := p6.add n1 true true Fe.zero
  let p8 := p4.dbl true Fe.zero
  fun e => match e with
    | 0 => Niels.zero
    | 1 => n1
    | 2 => p2.toNiels k2d
    | 3 => p3.toNiels k2d
    | 4 => p4.toNiels k2d
    | 5 => p5.toNiels k2d
    | 6 => p6.toNiels k2d
    | 7 => p7.toNiels k2d
    | _ => p8.toNiels k2d

/-- The operand of a `[k]` window: lane `j` from entry `|d j|`, negated where `d j < 0`; its
`y + x`, `y - x`, `2dt`, `z`. -/
def selK (tab : Nat → Niels) (d : Fin 8 → BitVec 8) : Fe × Fe × Fe × Fe :=
  let pick (f : Niels → Bool → Fe) := Fe.ofLanes fun j =>
    (f (tab (d j).toInt.natAbs) ((d j).toInt < 0)).lane j
  (pick fun q n => if n then q.m else q.p, pick fun q n => if n then q.p else q.m,
    pick fun q n => if n then q.nk else q.k, pick fun q _ => q.z)

/-- Lane `j`'s limbs `off … off + 4` of fixed-base entry `e`, in `tbl`'s 20 ulongs per entry. -/
def baseLimbs (tbl : Nat → BitVec 64) (e off : Nat) : Fin 5 → BitVec 64 :=
  fun i => tbl (20 * e + off + i)

/-- The operand of an `[S]` window from the fixed-base table: `y + x`, `y - x`, `2dt` of entry
`|d j|` in lane `j`, negated where `d j < 0`. -/
def selB (tbl : Nat → BitVec 64) (d : Fin 8 → BitVec 16) : Fe × Fe × Fe :=
  let pick (off : Bool → Nat) := Fe.ofLanes fun j =>
    baseLimbs tbl (d j).toInt.natAbs (off ((d j).toInt < 0))
  (pick fun n => if n then 5 else 0, pick fun n => if n then 0 else 5,
    pick fun n => if n then 15 else 10)

/-- Window `w` of `fd_ed25519_lane_verify`'s loop: four doublings (none at the top), the `[k]`
digit, and at even `w` the `[S]` digit. -/
def window (tab : Nat → Niels) (tbl : Nat → BitVec 64) (k s : Fin 8 → BitVec 256) (w : Nat)
    (acc : Point) : Point :=
  let acc :=
    if w = 63 then acc
    else
      let acc := acc.dbl false acc.t
      let acc := acc.dbl false acc.t
      let acc := acc.dbl false acc.t
      acc.dbl true acc.t
  let (qp, qm, qk, qz) := selK tab fun j => recode4 (k j) w
  let acc := acc.addQ qp qm qk qz false (w % 2 = 0) acc.t
  if w % 2 = 0 then
    let (bp, bm, bk) := selB tbl fun j => recode8 (s j) (w / 2)
    acc.addQ bp bm bk Fe.one true false acc.t
  else acc

/-- Windows `63, …, 64 - n` from `acc`. -/
def ladder (tab : Nat → Niels) (tbl : Nat → BitVec 64) (k s : Fin 8 → BitVec 256) :
    Nat → Point → Point
  | 0, acc => acc
  | n + 1, acc => window tab tbl k s (63 - n) (ladder tab tbl k s n acc)

/-- `fd_ed25519_lane_verify`: bit `j` set when `[S]B + [k]a = R` in lane `j`, `a = -A`; `k2d` the
broadcast `2d`, `tbl` `fd_ed25519_lane_base_table`. -/
def verify (k2d : Fe) (tbl : Nat → BitVec 64) (a r : Point) (k s : Fin 8 → BitVec 256) :
    BitVec 32 :=
  let acc := ladder (ktab a k2d) tbl k s 64 Point.zero
  let x := subRaw (mul r.x acc.z) acc.x
  let y := subRaw (mul r.y acc.z) acc.y
  isZero x &&& isZero y

end

end MLIR.Firedancer.Lane
