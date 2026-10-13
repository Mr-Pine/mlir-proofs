module

public import MLIR.Run.Tactic
public import Boringssl.load_3
public import Boringssl.load_4
public import Boringssl.int64_lshift21
public import Boringssl.Mlir.x25519_sc_reduce
public import Boringssl.Common.Bounds
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Boringssl

open MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `load_3(s + k)` on the 64 bytes `x`. -/
def x25519_sc_reduce.load3 (x : BitVec 512) (k : Nat) : BitVec 64 :=
  (x.extractLsb' (8 * k) 24).setWidth 64

/-- `load_4(s + k)` on the 64 bytes `x`. -/
def x25519_sc_reduce.load4 (x : BitVec 512) (k : Nat) : BitVec 64 :=
  (x.extractLsb' (8 * k) 32).setWidth 64

open x25519_sc_reduce in
/-- `s mod ℓ` as the C computes it, on the 64 bytes `x`: 21-bit limbs, the limbs above `2^252`
folded down by `2^252 ≡ -27742317777372353535851937790883648493 (mod ℓ)` (the `666643 … 683901`
rows), the carries between (`1048576` is `1 << 20`, `int64_lshift21(c)` is `c << 21`), and the 12
low limbs stored as 32 bytes. The dead `sK = 0` resets are left out. -/
def x25519_sc_reduce.spec (x : BitVec 512) : BitVec 256 :=
