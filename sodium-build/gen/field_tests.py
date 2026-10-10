"""Writes Sodium/Tests/<f>.lean: `#guard` tests of the field specs against the lifts."""
import os
HDR = '''module

public import Sodium.{f}

meta import Sodium.{f}

namespace MLIR.Sodium

/-- A block holding the `n` bytes `b`. -/
private def blk (n : Nat) (b : BitVec (8 * n)) : MemoryBlock :=
  .ofBytes n b

/-- Limbs as the 40 bytes of a field element. -/
private def bytesOf (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- Test elements: small, near `2^52`, mixed, `p`'s limbs, and limbs near `2^54`. -/
private def xs : List (Fin 5 → BitVec 64) :=
  [fun i => #v[1, 2, 3, 4, 5][i], fun i =>
    #v[0xfffffffffffff, 0x8000000000000, 0x7ffffffffffff, 0xfffffffffffed, 0x1][i], fun i =>
    #v[0x123456789abcd, 0x7edcba9876543, 0x1111111111111, 0x0, 0x7ffffffffffff][i], fun i =>
    #v[0x7ffffffffffed, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff][i],
    fun i => #v[0x3fffffffffffff, 0x3ffffffffffff0, 0x2fffffffffffff, 0x3fffffffffffff, 0x1][i]]

'''
BIN = '''/-- `h` in block 1, `f` and `g` in blocks 2 and 3; `h`'s limbs after the call, or `none` for UB. -/
private def run (a b : Fin 5 → BitVec 64) : Option (Fin 5 → BitVec 64) :=
  let s : GlobalState :=
    ⟨⟨4⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 40 0), (⟨2⟩, blk 40 (bytesOf a)),
      (⟨3⟩, blk 40 (bytesOf b))]⟩⟩
  match {f}.call ({f}.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩) (.value ⟨⟨3⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readLimbs ⟨⟨1⟩, 0⟩)
  | _ => none

-- every limb is the spec's
#guard
  xs.all fun a =>
    xs.all fun b =>
      match run a b with
      | some r => (List.finRange 5).all fun k => r k == {spec} a b k
      | none => false
'''
UN = '''/-- `h` in block 1, `f` in block 2; `h`'s limbs after the call, or `none` for UB. -/
private def run (a : Fin 5 → BitVec 64) : Option (Fin 5 → BitVec 64) :=
  let s : GlobalState :=
    ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 40 0), (⟨2⟩, blk 40 (bytesOf a))]⟩⟩
  match {f}.call ({f}.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readLimbs ⟨⟨1⟩, 0⟩)
  | _ => none

-- every limb is the spec's
#guard
  xs.all fun a =>
    match run a with
    | some r => (List.finRange 5).all fun k => r k == {spec} a k
    | none => false
'''
TOB = '''/-- `s` (32 bytes) in block 1, `h` in block 2; `s`'s bytes, or `none` for UB. -/
private def run (a : Fin 5 → BitVec 64) : Option (BitVec 256) :=
  let s : GlobalState :=
    ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 32 0), (⟨2⟩, blk 40 (bytesOf a))]⟩⟩
  match fe25519_tobytes.call (fe25519_tobytes.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readAt ⟨⟨1⟩, 0⟩ 256)
  | _ => none

-- `spec`'s bytes
#guard xs.all fun a => run a == some (fe25519_tobytes.spec a)
'''
FROMB = '''/-- `h` in block 1, the 32 bytes `x` in block 2; `h`'s limbs, or `none` for UB. -/
private def run (x : BitVec 256) : Option (Fin 5 → BitVec 64) :=
  let s : GlobalState :=
    ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 40 0), (⟨2⟩, blk 32 x)]⟩⟩
  match fe25519_frombytes.call (fe25519_frombytes.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readLimbs ⟨⟨1⟩, 0⟩)
  | _ => none

-- every limb is the spec's, for encodings with the top bit clear and set
#guard
  [0#256, 1#256, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed#256,
      0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256,
      0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef#256].all fun x =>
    match run x with
    | some r => (List.finRange 5).all fun k => r k == fe25519_frombytes.spec x k
    | none => false
'''
RET = '''/-- `f` in block 1; the returned value, or `none` for UB. -/
private def run (a : Fin 5 → BitVec 64) : Option (BitVec 32) :=
  let s : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 40 (bytesOf a))]⟩⟩
  match {f}.call ({f}.args (.value ⟨⟨1⟩, 0⟩)) s with
  | .value (.cons (.value r) .nil, _) => some r
  | _ => none

-- the spec's value, also at `0` and `p` (zero, unreduced)
#guard (xs ++ [fun _ => 0]).all fun a => run a == some ({f}.spec a)
'''
tests = {
  'fe25519_sub': BIN.replace('{spec}', 'fe25519_sub.spec'),
  'fe25519_mul': BIN.replace('{spec}', 'fe25519_mul.spec'),
  'fe25519_sq': UN.replace('{spec}', 'fe25519_sq.spec'),
  'fe25519_sq2': UN.replace('{spec}', 'fe25519_sq2.spec'),
  'fe25519_reduce': UN.replace('{spec}', 'fe25519_reduce.spec'),
  'fe25519_neg': UN.replace('{spec}', 'fe25519_neg.spec'),
  'fe25519_tobytes': TOB,
  'fe25519_frombytes': FROMB,
  'fe25519_isnegative': RET,
  'fe25519_iszero': RET,
}
out = os.path.join(os.path.dirname(__file__), '..', '..', 'Sodium', 'Tests')
for f, body in tests.items():
    s = HDR.replace('{f}', f) + body.replace('{f}', f) + '\nend MLIR.Sodium\n'
    open(os.path.join(out, f + '.lean'), 'w').write(s)
    print(f)
