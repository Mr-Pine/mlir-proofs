module

public import MLIR.Ty
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The AVX-512 `wwl_t` operations of `fd_avx512_wwl.h` and `wv_t` of `fd_avx_wv.h`, lane by lane,
as the specs use them. Each operation is a `Vector.ofFn`, so `expandOfFn` splits it into lanes. -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

/-- A `wwl_t`: eight 64-bit lanes, lane 0 lowest. -/
abbrev Wwl := Vector (BitVec 64) 8

/-- A `wv_t`: four 64-bit lanes, lane 0 lowest. -/
abbrev Wv := Vector (BitVec 64) 4

/-- Vectors with the same lanes, the lanes indexed by `Fin n` (for `fin_cases`). -/
theorem vec_ext_fin {x y : Vector α n} (h : ∀ i : Fin n, x[i] = y[i]) : x = y :=
  Vector.ext fun i hi => h ⟨i, hi⟩

/-- `wwl(x0, …, x7)`. -/
def wwl (x0 x1 x2 x3 x4 x5 x6 x7 : BitVec 64) : Wwl :=
  #v[x0, x1, x2, x3, x4, x5, x6, x7]

/-- `wwl_bcast(x)`: `x` in every lane. -/
def wwl_bcast (x : BitVec 64) : Wwl :=
  Vector.replicate 8 x

/-- `wwl_zero()`. -/
abbrev wwl_zero : Wwl :=
  Vector.replicate 8 0

/-- `wwl_one()`. -/
def wwl_one : Wwl :=
  wwl_bcast 1

def wwl_add (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => x[i] + y[i]

def wwl_sub (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => x[i] - y[i]

/-- `wwl_mul(x, y)`: the low 64 bits of each lane's product. -/
def wwl_mul (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => x[i] * y[i]

def wwl_and (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => x[i] &&& y[i]

/-- `wwl_andnot(x, y)`: `~x & y`. -/
def wwl_andnot (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => ~~~x[i] &&& y[i]

def wwl_xor (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => x[i] ^^^ y[i]

/-- `wwl_shl(x, n)`: each lane shifted left by `n` (zero from `64` on). -/
def wwl_shl (x : Wwl) (n : Nat) : Wwl :=
  Vector.ofFn fun i => x[i] <<< n

/-- `wwl_shr(x, n)`: arithmetic right shift. -/
def wwl_shr (x : Wwl) (n : Nat) : Wwl :=
  Vector.ofFn fun i => x[i].sshiftRight n

/-- `wwl_shru(x, n)`: logical right shift. -/
def wwl_shru (x : Wwl) (n : Nat) : Wwl :=
  Vector.ofFn fun i => x[i] >>> n

/-- `wwl_shl_vector(x, y)`: lane `i` shifted left by `y[i]`. -/
def wwl_shl_vector (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => x[i] <<< y[i].toNat

/-- `wwl_shr_vector(x, y)`: lane `i` shifted right arithmetically by `y[i]`. -/
def wwl_shr_vector (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => x[i].sshiftRight y[i].toNat

/-- `wwl_shru_vector(x, y)`: lane `i` shifted right logically by `y[i]`. -/
def wwl_shru_vector (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => x[i] >>> y[i].toNat

/-- `wwl_permute(p, x)`: lane `i` is `x[p[i] mod 8]`. -/
def wwl_permute (p x : Wwl) : Wwl :=
  Vector.ofFn fun i => x[p[i].toNat % 8]'(Nat.mod_lt _ (by decide))

/-- `wwl_select(p, x, y)`: lane `i` is lane `p[i] mod 16` of `x` then `y`. -/
def wwl_select (p x y : Wwl) : Wwl :=
  Vector.ofFn fun i =>
    let j := p[i].toNat % 16
    if h : j < 8 then x[j] else y[j - 8]

/-- `madd52`'s 52-bit mask. -/
abbrev m52 : BitVec 64 :=
  0xFFFFFFFFFFFFF

/-- `vpmadd52luq`'s lane: the low 52 bits of the product of `b`'s and `c`'s low 52 bits. -/
def madd52lo (b c : BitVec 64) : BitVec 64 :=
  (b &&& m52) * (c &&& m52) &&& m52

/-- `vpmadd52huq`'s lane: the high 52 bits of that 104-bit product. -/
def madd52hi (b c : BitVec 64) : BitVec 64 :=
  (((b &&& m52).setWidth 128 * (c &&& m52).setWidth 128) >>> 52).setWidth 64

/-- `wwl_madd52lo(a, b, c)`. -/
def wwl_madd52lo (a b c : Wwl) : Wwl :=
  Vector.ofFn fun i => a[i] + madd52lo b[i] c[i]

/-- `wwl_madd52hi(a, b, c)`. -/
def wwl_madd52hi (a b c : Wwl) : Wwl :=
  Vector.ofFn fun i => a[i] + madd52hi b[i] c[i]

/-- `wwl_slide(x, y, imm)`: lanes `imm …` of `x`, then `y`'s (`_mm512_alignr_epi64(y, x, imm)`). -/
def wwl_slide (x y : Wwl) (imm : Nat) : Wwl :=
  Vector.ofFn fun i => if h : i.val + imm < 8 then x[i.val + imm] else y[i.val + imm - 8]?.getD 0

/-- `wwl_eq(x, y)`: bit `i` set when lanes `i` agree (`_mm512_cmpeq_epi64_mask`). -/
def wwl_eq (x y : Wwl) : BitVec 32 :=
  (BitVec.packLanes (Vector.ofFn fun i : Fin 8 => BitVec.ofBool (x[i] == y[i]))).setWidth 32

/-- `wwl_if(c, x, y)`: lane `i` from `x` when bit `i` of `c` is set, else from `y`. -/
def wwl_if (c : BitVec 32) (x y : Wwl) : Wwl :=
  Vector.ofFn fun i => if c.getLsbD i then x[i] else y[i]

/-- `wwl_pack_halves(x, i, y, j)`: half `i` of `x`, then half `j` of `y` (`i, j` in `0, 1`). -/
def wwl_pack_halves (x : Wwl) (i : Nat) (y : Wwl) (j : Nat) : Wwl :=
  Vector.ofFn fun k =>
    if k.val < 4 then x[(4 * i + k.val) % 8]'(Nat.mod_lt _ (by decide))
    else y[(4 * j + k.val - 4) % 8]'(Nat.mod_lt _ (by decide))

/-- `wwl_pack_h0_h1(x, y)`: the lower half of `x`, then the upper half of `y`. -/
def wwl_pack_h0_h1 (x y : Wwl) : Wwl :=
  Vector.ofFn fun k => if k.val < 4 then x[k] else y[k]

/-- `wwv_add_if(c, x, y, z)`: `x + y` in the lanes `c` selects, `z` elsewhere. -/
def wwv_add_if (c : BitVec 8) (x y z : Wwl) : Wwl :=
  Vector.ofFn fun k => if c.getLsbD k.val then x[k] + y[k] else z[k]

/-- `_mm512_inserti64x4(x, u, 0)`: `x` with lanes 0-3 replaced by `u`. -/
def mm512_inserti64x4 (x : Wwl) (u : Wv) : Wwl :=
  #v[u[0], u[1], u[2], u[3], x[4], x[5], x[6], x[7]]

/-- `_mm512_permutexvar_epi8`'s byte indices: byte `k` of `perm`, mod `64`. -/
def permutexvarIdx (perm : Wwl) : Vector Nat 64 :=
  Vector.ofFn fun k => (perm[k.1 / 8].extractLsb' (8 * (k.1 % 8)) 8).toNat % 64

/-- `_mm512_permutexvar_epi8(perm, x)`'s bytes: `x`'s bytes at `permutexvarIdx perm`. -/
def permutexvarBytes (perm x : Wwl) : Vector (BitVec 8) 64 :=
  (permutexvarIdx perm).map fun i => (BitVec.packLanes x).extractLsb' (8 * i) 8

/-- `_mm512_permutexvar_epi8(perm, x)`: `permutexvarBytes` regrouped into lanes. -/
def mm512_permutexvar_epi8 (perm x : Wwl) : Wwl :=
  Vector.ofFn fun j => (BitVec.packLanes (permutexvarBytes perm x)).extractLsb' (j.1 * 64) 64

/-- Below `2^44`, a masked lane plus a small bias overflows neither way. -/
theorem and_add_no_overflow (a m b : BitVec 64) (hm : m < 0x100000000000#64)
    (hb : b < 0x100000000000#64) :
    (a &&& m).saddOverflow b = false ∧ (a &&& m).uaddOverflow b = false := by bv_decide

end

end MLIR.Firedancer.Avx512
