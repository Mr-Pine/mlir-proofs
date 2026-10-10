module

public import MLIR.Run.Tactic
public import Boringssl.Mlir.slide

namespace MLIR.Boringssl

/-! ## Specification

`signed char r[256]` as a vector of bytes, `r[0]` first. The C's `int` arithmetic is 32-bit. -/

@[expose] public section

namespace slide

/-- `r[i] = 1 & (a[i >> 3] >> (i & 7))`: the bits of `a`. -/
def bits (a : BitVec 256) : Vector (BitVec 8) 256 :=
  Vector.ofFn fun i => 1#8 &&& a.extractLsb' (8 * (i.val >> 3)) 8 >>> (i.val &&& 7)

/-- The carry loop from `k`: `r[k]` cleared while set, the first clear one set. -/
def carry (r : Vector (BitVec 8) 256) (k : Nat) : Vector (BitVec 8) 256 :=
  if h : k < 256 then
    if r[k] = 0#8 then r.set k 1#8 else carry (r.set k 0#8) (k + 1)
  else r
termination_by 256 - k

/-- The `b` loop at `i` from `b`: each set `r[i + b]` folded into `r[i]`, as `+` while
`r[i] + (r[i + b] << b) <= 15`, else as `-` with a carry while `r[i] - (r[i + b] << b) >= -15`,
else the loop ends. -/
def window (r : Vector (BitVec 8) 256) (i b : Nat) : Vector (BitVec 8) 256 :=
  if h : b ≤ 6 ∧ i + b < 256 then
    if r[i + b] = 0#8 then window r i (b + 1)
    else
      let ri := r[i].signExtend 32
      let rb := r[i + b].signExtend 32 <<< b
      if (ri + rb).sle 15#32 then window ((r.set i (ri + rb).setWidth 8).set (i + b) 0#8) i (b + 1)
      else if (-15#32).sle (ri - rb) then
        window (carry (r.set i (ri - rb).setWidth 8) (i + b)) i (b + 1)
      else r
  else r
termination_by 7 - b

/-- The `i` loop from `i`: each set `r[i]` given its window. -/
def loop (r : Vector (BitVec 8) 256) (i : Nat) : Vector (BitVec 8) 256 :=
  if h : i < 256 then loop (if r[i] ≠ 0#8 then window r i 1 else r) (i + 1) else r
termination_by 256 - i

end slide

/-- The 256 signed digits `slide` stores at `r` for the 32 bytes `a`. -/
def slide.spec (a : BitVec 256) : Vector (BitVec 8) 256 :=
  slide.loop (slide.bits a) 0

end

end MLIR.Boringssl
