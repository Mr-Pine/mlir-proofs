#!/usr/bin/env python3
"""Writes Sodium/Tests/ge25519_*.lean: each point function's lift run against its spec."""
import os

OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'Sodium', 'Tests')

HEAD = '''module

public import Sodium.{fn}

meta import Sodium.{fn}

namespace MLIR.Sodium

/-- A block holding the `n` bytes `b`. -/
private def blk (n : Nat) (b : BitVec (8 * n)) : MemoryBlock :=
  .ofBytes n b

/-- Limbs as the 40 bytes of a field element. -/
private def bytesOf (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- Limbs agree. -/
private def limbsEq (a b : Fin 5 → BitVec 64) : Bool :=
  (List.finRange 5).all fun k => a k == b k

/-- Test field element `k`: limbs below `2^51`, pseudo-random. -/
private def fe (k : Nat) : Fin 5 → BitVec 64 := fun i =>
  BitVec.ofNat 64 ((k * 0x9e3779b97f4a7c15 + (i.val + 1) * 0x51ed27e2b7f3a91) % 2 ^ 51)
'''

TAIL = '''
end MLIR.Sodium
'''

EQ = {
    'GeP2': ('eqP2', 'limbsEq a.X b.X && limbsEq a.Y b.Y && limbsEq a.Z b.Z'),
    'GeP3': ('eqP3', 'limbsEq a.X b.X && limbsEq a.Y b.Y && limbsEq a.Z b.Z && limbsEq a.T b.T'),
    'GeP1p1': ('eqP1p1', 'limbsEq a.X b.X && limbsEq a.Y b.Y && limbsEq a.Z b.Z && limbsEq a.T b.T'),
    'GeCached': ('eqCached', 'limbsEq a.YplusX b.YplusX && limbsEq a.YminusX b.YminusX && '
                 'limbsEq a.Z b.Z && limbsEq a.T2d b.T2d'),
}
# object type: (size, bytes of a value P, reader)
OBJ = {
    'GeP2': (120, 'bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X', 'readP2'),
    'GeP3': (160, 'bytesOf P.T ++ bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X', 'readP3'),
    'GeP1p1': (160, 'bytesOf P.T ++ bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X', 'readP1p1'),
    'GeCached': (160, 'bytesOf P.T2d ++ bytesOf P.Z ++ bytesOf P.YminusX ++ bytesOf P.YplusX',
                 'readCached'),
    'GePrecomp': (120, 'bytesOf P.xy2d ++ bytesOf P.yminusx ++ bytesOf P.yplusx', 'readPrecomp'),
}
SAMPLE = {
    'GeP2': lambda k: f'⟨fe {k}, fe {k + 1}, fe {k + 2}⟩',
    'GeP3': lambda k: f'⟨fe {k}, fe {k + 1}, fe {k + 2}, fe {k + 3}⟩',
    'GeP1p1': lambda k: f'⟨fe {k}, fe {k + 1}, fe {k + 2}, fe {k + 3}⟩',
    'GeCached': lambda k: f'⟨fe {k}, fe {k + 1}, fe {k + 2}, fe {k + 3}⟩',
    'GePrecomp': lambda k: f'⟨fe {k}, fe {k + 1}, fe {k + 2}⟩',
}


def unary(fn, inty, outty, spec):
    osz, _, oread = OBJ[outty]
    isz, ibytes, _ = OBJ[inty]
    eqn, eqb = EQ[outty]
    ins = ', '.join(SAMPLE[inty](k) for k in (0, 7, 14))
    return HEAD.format(fn=fn) + f'''
/-- The `{outty}`s agree. -/
private def {eqn} (a b : {outty}) : Bool :=
  {eqb}

/-- The output in block 1, `P` in block 2; the output after the call, or `none` for UB. -/
private def run (P : {inty}) : Option {outty} :=
  let s : GlobalState :=
    ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk {osz} 0), (⟨2⟩, blk {isz} ({ibytes}))]⟩⟩
  match {fn}.call ({fn}.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.{oread} ⟨⟨1⟩, 0⟩)
  | _ => none

-- the spec's, on three inputs
#guard
  ([{ins}] : List {inty}).all fun P =>
    match run P with
    | some R => {eqn} R ({spec} P)
    | none => false
''' + TAIL


def binary(fn, qty):
    _, pbytes, _ = OBJ['GeP3']
    qsz, _, _ = OBJ[qty]
    qbytes = OBJ[qty][1].replace('P.', 'Q.')
    eqn, eqb = EQ['GeP1p1']
    ps = [SAMPLE['GeP3'](k) for k in (0, 7, 14)]
    qs = [SAMPLE[qty](k) for k in (21, 28, 35)]
    pairs = ', '.join(f'({p}, {q})' for p, q in zip(ps, qs))
    return HEAD.format(fn=fn) + f'''
/-- The `GeP1p1`s agree. -/
private def {eqn} (a b : GeP1p1) : Bool :=
  {eqb}

/-- The output in block 1, `P` in block 2, `Q` in block 3; the output after the call, or `none`
for UB. -/
private def run (P : GeP3) (Q : {qty}) : Option GeP1p1 :=
  let s : GlobalState :=
    ⟨⟨4⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, blk 160 0), (⟨2⟩, blk 160 ({pbytes})),
            (⟨3⟩, blk {qsz} ({qbytes}))]⟩⟩
  match {fn}.call ({fn}.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩) (.value ⟨⟨3⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readP1p1 ⟨⟨1⟩, 0⟩)
  | _ => none

-- the spec's, on three inputs
#guard
  ([{pairs}] : List (GeP3 × {qty})).all fun (P, Q) =>
    match run P Q with
    | some R => {eqn} R ({fn}.spec P Q)
    | none => false
''' + TAIL


P2_0 = HEAD.format(fn='ge25519_p2_0') + '''
/-- `h` in block 1; it after the call, or `none` for UB. -/
private def run : Option GeP2 :=
  let s : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 120 0)]⟩⟩
  match ge25519_p2_0.call (ge25519_p2_0.args (.value ⟨⟨1⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readP2 ⟨⟨1⟩, 0⟩)
  | _ => none

-- `(0 : 1 : 1)`
#guard
  match run with
  | some R =>
    limbsEq R.X Boringssl.ge_p2_0.spec.X && limbsEq R.Y Boringssl.ge_p2_0.spec.Y &&
      limbsEq R.Z Boringssl.ge_p2_0.spec.Z
  | none => false
''' + TAIL

FILES = {
    'ge25519_p3_to_p2': unary('ge25519_p3_to_p2', 'GeP3', 'GeP2', 'Boringssl.ge_p3_to_p2.spec'),
    'ge25519_p1p1_to_p2': unary('ge25519_p1p1_to_p2', 'GeP1p1', 'GeP2', 'ge25519_p1p1_to_p2.spec'),
    'ge25519_p1p1_to_p3': unary('ge25519_p1p1_to_p3', 'GeP1p1', 'GeP3', 'ge25519_p1p1_to_p3.spec'),
    'ge25519_p3_to_cached': unary('ge25519_p3_to_cached', 'GeP3', 'GeCached',
                                  'ge25519_p3_to_cached.spec'),
    'ge25519_p2_dbl': unary('ge25519_p2_dbl', 'GeP2', 'GeP1p1', 'ge25519_p2_dbl.spec'),
    'ge25519_p3_dbl': unary('ge25519_p3_dbl', 'GeP3', 'GeP1p1', 'ge25519_p3_dbl.spec'),
    'ge25519_add': binary('ge25519_add', 'GeCached'),
    'ge25519_sub': binary('ge25519_sub', 'GeCached'),
    'ge25519_madd': binary('ge25519_madd', 'GePrecomp'),
    'ge25519_msub': binary('ge25519_msub', 'GePrecomp'),
    'ge25519_p2_0': P2_0,
}

NUMS = '''
/-- Limbs' number. -/
private def natOf (l : Fin 5 → BitVec 64) : Nat :=
  (l 0).toNat + (l 1).toNat * 2 ^ 51 + (l 2).toNat * 2 ^ 102 + (l 3).toNat * 2 ^ 153 +
    (l 4).toNat * 2 ^ 204

private def p : Nat :=
  2 ^ 255 - 19

/-- `b ^ e % m` by squaring. -/
private def powMod (b e m : Nat) : Nat :=
  if e = 0 then 1 % m
  else
    let h := powMod (b * b % m) (e / 2) m
    if e % 2 = 0 then h else h * b % m
termination_by e
decreasing_by omega
'''

TOBYTES = HEAD.format(fn='ge25519_tobytes') + NUMS + '''
/-- `s` (32 bytes) in block 1, `h` in block 2; `s` after the call, or `none` for UB. -/
private def run (P : GeP2) : Option (BitVec 256) :=
  let s : GlobalState :=
    ⟨⟨3⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, blk 32 0), (⟨2⟩, blk 120 (bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X))]⟩⟩
  match ge25519_tobytes.call (ge25519_tobytes.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readAt ⟨⟨1⟩, 0⟩ 256)
  | _ => none

/-- The encoding of `(X / Z, Y / Z)`: `y` below `p`, the parity of `x` on top. -/
private def encodeNat (P : GeP2) : Nat :=
  let r := powMod (natOf P.Z) (p - 2) p
  let x := natOf P.X * r % p
  let y := natOf P.Y * r % p
  y + 2 ^ 255 * (x % 2)

-- the encoding, on three points (`spec`'s inversion chain is not evaluated: its closures recompute
-- exponentially)
#guard
  ([⟨fe 0, fe 1, fe 2⟩, ⟨fe 7, fe 8, fe 9⟩, ⟨fe 14, fe 15, fe 16⟩] : List GeP2).all fun P =>
    (run P).map BitVec.toNat == some (encodeNat P)
''' + TAIL

FROMBYTES = HEAD.format(fn='ge25519_frombytes_negate_vartime') + NUMS + '''
/-- `d = -121665 / 121666`. -/
private def dNat : Nat :=
  (p - 121665) * powMod 121666 (p - 2) p % p

/-- `√-1`. -/
private def iNat : Nat :=
  powMod 2 ((p - 1) / 4) p

/-- The point `s` encodes, as `(x, y)` below `p`, by RFC 8032's recovery (any `y` below
`2²⁵⁵`, any sign of `x = 0`). -/
private def decodeNat (s : Nat) : Option (Nat × Nat) :=
  let y := s % 2 ^ 255 % p
  let u := (y * y + p - 1) % p
  let v := (dNat * y * y + 1) % p
  let x := u * powMod (u * v % p) ((p - 5) / 8) p % p
  let vxx := v * x * x % p
  let x? := if vxx = u then some x else if (vxx + u) % p = 0 then some (x * iNat % p) else none
  x?.map fun x => (if x % 2 = s / 2 ^ 255 then x else (p - x) % p, y)

/-- `h` (160 bytes) in block 1, `s` in block 2; the result and `h`'s `X, Y, Z, T` values. -/
private def run (s : BitVec 256) : Option (BitVec 32 × List Nat) :=
  let st : GlobalState := ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 160 0), (⟨2⟩, blk 32 s)]⟩⟩
  match
    ge25519_frombytes_negate_vartime.call
      (ge25519_frombytes_negate_vartime.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) st with
  | .value (.cons (.value r) .nil, s') =>
    let P := s'.mem.readP3 ⟨⟨1⟩, 0⟩
    some (r, [P.X, P.Y, P.Z, P.T].map fun l => natOf l % p)
  | _ => none

/-- The result `decodeNat` expects: `0` and the negated point `(-x, y, 1, -x y)`, or `-1`. -/
private def expected (s : Nat) : BitVec 32 × Option (List Nat) :=
  match decodeNat s with
  | some (x, y) => (0, some [(p - x) % p, y, 1, (p - x) * y % p])
  | none => (-1, none)

/-- Encodings: the base point and its negation, `y = 3`, `y = 1` with the sign set (`x = 0`),
`y = p + 3` (non-canonical), and `y = 2`, `y = 7` (no point). -/
private def bufs : List Nat :=
  [0x6666666666666666666666666666666666666666666666666666666666666658,
    0xe666666666666666666666666666666666666666666666666666666666666658, 3, 2 ^ 255 + 1, p + 3, 2, 7]

-- the result `decodeNat` expects, and the negated point's values on success
#guard
  bufs.all fun s =>
    match run (BitVec.ofNat 256 s), expected s with
    | some (r, vals), (r', some vals') => r == r' && vals == vals'
    | some (r, _), (r', none) => r == r'
    | none, _ => false

-- `decodeNat` fails exactly on `y = 2` and `y = 7`
#guard bufs.map (fun s => (decodeNat s).isSome) == [true, true, true, true, true, false, false]
''' + TAIL


def bytetest(fn, doc, expect, bufs):
    return HEAD.format(fn=fn) + f'''
/-- `s` in block 1; the result, or `none` for UB. -/
private def run (s : BitVec 256) : Option (BitVec 32) :=
  let st : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 32 s)]⟩⟩
  match {fn}.call ({fn}.args (.value ⟨⟨1⟩, 0⟩)) st with
  | .value (.cons (.value r) .nil, _) => some r
  | _ => none

/-- {doc} -/
private def bufs : List Nat :=
  {bufs}

-- `spec`, and the expected result
#guard
  bufs.all fun s =>
    let b := BitVec.ofNat 256 s
    run b == some ({fn}.spec b) && run b == some ({expect})
''' + TAIL


CANON = bytetest(
    'ge25519_is_canonical',
    'Encodings around `p` of either sign, `2²⁵⁵ - 1`, `0`, and `p` with a low byte cleared.',
    'if s % 2 ^ 255 < 2 ^ 255 - 19 then 1#32 else 0#32',
    '[2 ^ 255 - 20, 2 ^ 255 - 19, 2 ^ 255 - 18, 2 ^ 255 - 1, 0, 2 ^ 256 - 20, 2 ^ 256 - 19,\n'
    '    2 ^ 256 - 1, 2 ^ 255 - 19 - 2 ^ 100, 2 ^ 255 + 3]')
SMALL = bytetest(
    'ge25519_has_small_order',
    "The table's entries, with the sign bit too, and their neighbours.",
    'if (ge25519_has_small_order.blacklist.map BitVec.toNat).contains (s % 2 ^ 255) then 1#32\n'
    '        else 0#32',
    '(ge25519_has_small_order.blacklist.map BitVec.toNat).flatMap fun n =>\n'
    '    [n, n + 2 ^ 255, n + 2, (n + 2 ^ 254) % 2 ^ 256]')

FILES.update({'ge25519_tobytes': TOBYTES, 'ge25519_frombytes_negate_vartime': FROMBYTES,
              'ge25519_is_canonical': CANON, 'ge25519_has_small_order': SMALL})

for name, text in FILES.items():
    with open(os.path.join(OUT, name + '.lean'), 'w') as f:
        f.write(text)
