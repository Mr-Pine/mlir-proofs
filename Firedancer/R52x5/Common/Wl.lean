module

public import Firedancer.Avx512.Common.Wwl

/-! The AVX2 `wl_t` operations of `fd_avx_wl.h` the r52x5 backend uses, lane by lane, and the
lane-uniform conditionals of `wc_bcast_wide` and `wl_if`. -/

namespace MLIR.Firedancer.R52x5

@[expose] public section

open Firedancer.Avx512 (Wv madd52lo madd52hi)

/-- A `wl_t`: four 64-bit lanes, lane 0 lowest. -/
abbrev Wl :=
  Wv

/-- `wl(l0, l1, l2, l3)`. -/
def wl (l0 l1 l2 l3 : BitVec 64) : Wl :=
  #v[l0, l1, l2, l3]

/-- `wl_bcast(x)`: `x` in every lane. -/
def wl_bcast (x : BitVec 64) : Wl :=
  Vector.replicate 4 x

/-- `wl_zero()`. -/
abbrev wl_zero : Wl :=
  Vector.replicate 4 0

def wl_add (x y : Wl) : Wl :=
  Vector.ofFn fun i => x[i] + y[i]

def wl_sub (x y : Wl) : Wl :=
  Vector.ofFn fun i => x[i] - y[i]

def wl_and (x y : Wl) : Wl :=
  Vector.ofFn fun i => x[i] &&& y[i]

/-- `wl_shl(x, n)`: each lane shifted left by `n`. -/
def wl_shl (x : Wl) (n : Nat) : Wl :=
  Vector.ofFn fun i => x[i] <<< n

/-- `wl_shru(x, n)`: each lane shifted right logically by `n`. -/
def wl_shru (x : Wl) (n : Nat) : Wl :=
  Vector.ofFn fun i => x[i] >>> n

/-- `wl_madd52lo(a, b, c)`. -/
def wl_madd52lo (a b c : Wl) : Wl :=
  Vector.ofFn fun i => a[i] + madd52lo b[i] c[i]

/-- `wl_madd52hi(a, b, c)`. -/
def wl_madd52hi (a b c : Wl) : Wl :=
  Vector.ofFn fun i => a[i] + madd52hi b[i] c[i]

/-- `wl_permute(x, i0, i1, i2, i3)`: lane `k` is lane `ik` of `x` (`ik < 4`). -/
def wl_permute (x : Wl) (i0 i1 i2 i3 : Nat) : Wl :=
  #v[x[i0 % 4]'(Nat.mod_lt _ (by decide)), x[i1 % 4]'(Nat.mod_lt _ (by decide)),
    x[i2 % 4]'(Nat.mod_lt _ (by decide)), x[i3 % 4]'(Nat.mod_lt _ (by decide))]

/-- `wc_bcast_wide(c0, c1, c2, c3)` as compiled: lane `k` is `-ck` in both 32-bit halves, all ones
for `ck = 1`. -/
def wcBcast (c0 c1 c2 c3 : BitVec 32) : Wl :=
  #v[(-c0) ++ (-c0), (-c1) ++ (-c1), (-c2) ++ (-c2), (-c3) ++ (-c3)]

/-- `wl_if(c, x, y)` for a lane-uniform `c` (each lane 0 or all ones): lane `k` from `x` where
`bk`, else from `y`. -/
def wlBlend (b0 b1 b2 b3 : Bool) (x y : Wl) : Wl :=
  #v[cond b0 x[0] y[0], cond b1 x[1] y[1], cond b2 x[2] y[2], cond b3 x[3] y[3]]

/-! ### Lanes -/

theorem wl_add_getElem (x y : Wl) (i : Nat) (h : i < 4) : (wl_add x y)[i] = x[i] + y[i] := by
  simp [wl_add]

theorem wl_sub_getElem (x y : Wl) (i : Nat) (h : i < 4) : (wl_sub x y)[i] = x[i] - y[i] := by
  simp [wl_sub]

theorem wl_and_getElem (x y : Wl) (i : Nat) (h : i < 4) : (wl_and x y)[i] = x[i] &&& y[i] := by
  simp [wl_and]

theorem wl_shl_getElem (x : Wl) (n i : Nat) (h : i < 4) : (wl_shl x n)[i] = x[i] <<< n := by
  simp [wl_shl]

theorem wl_shru_getElem (x : Wl) (n i : Nat) (h : i < 4) : (wl_shru x n)[i] = x[i] >>> n := by
  simp [wl_shru]

theorem wl_madd52lo_getElem (a b c : Wl) (i : Nat) (h : i < 4) :
    (wl_madd52lo a b c)[i] = a[i] + madd52lo b[i] c[i] := by simp [wl_madd52lo]

theorem wl_madd52hi_getElem (a b c : Wl) (i : Nat) (h : i < 4) :
    (wl_madd52hi a b c)[i] = a[i] + madd52hi b[i] c[i] := by simp [wl_madd52hi]

theorem wl_bcast_getElem (x : BitVec 64) (i : Nat) (h : i < 4) : (wl_bcast x)[i] = x := by
  simp [wl_bcast]

end

end MLIR.Firedancer.R52x5
