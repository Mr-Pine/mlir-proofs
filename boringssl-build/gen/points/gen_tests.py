#!/usr/bin/env python3
"""Generate Boringssl/Tests/<fn>.lean for the point functions."""
import os

OUT = "/home/david.intern/mlir-proofs/Boringssl/Tests"
FIELDS = {
    "P2": ["X", "Y", "Z"],
    "P3": ["X", "Y", "Z", "T"],
    "P1p1": ["X", "Y", "Z", "T"],
    "Precomp": ["yplusx", "yminusx", "xy2d"],
    "Cached": ["YplusX", "YminusX", "Z", "T2d"],
}
CTY = {"P2": "ge_p2", "P3": "ge_p3", "P1p1": "ge_p1p1", "Precomp": "ge_precomp", "Cached": "ge_cached"}

# fn: (output type or 'bytes', inputs)
FNS = {
    "ge_p3_to_p2": ("P2", ["P3"]),
    "x25519_ge_p1p1_to_p2": ("P2", ["P1p1"]),
    "x25519_ge_p1p1_to_p3": ("P3", ["P1p1"]),
    "x25519_ge_p3_to_cached": ("Cached", ["P3"]),
    "ge_p2_0": ("P2", []),
    "ge_p2_dbl": ("P1p1", ["P2"]),
    "ge_p3_dbl": ("P1p1", ["P3"]),
    "ge_madd": ("P1p1", ["P3", "Precomp"]),
    "ge_msub": ("P1p1", ["P3", "Precomp"]),
    "x25519_ge_add": ("P1p1", ["P3", "Cached"]),
    "x25519_ge_sub": ("P1p1", ["P3", "Cached"]),
    "x25519_ge_tobytes": ("bytes", ["P2"]),
}

HEADER = """module

public import Boringssl.{fn}

meta import Boringssl.{fn}

namespace MLIR.Boringssl

/-- A block holding the `n` bytes `b`. -/
private def blk (n : Nat) (b : BitVec (8 * n)) : MemoryBlock :=
  .ofBytes n b

/-- Limbs as the 40 bytes of a field element. -/
private def bytesOf (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- Limbs agree. -/
private def limbsEq (a b : Fin 5 → BitVec 64) : Bool :=
  (List.finRange 5).all fun k => a k == b k

/-- Test field element `k`: tight limbs, pseudo-random. -/
private def fe (k : Nat) : Fin 5 → BitVec 64 := fun i =>
  BitVec.ofNat 64 ((k * 0x9e3779b97f4a7c15 + (i.val + 1) * 0x51ed27e2b7f3a91) % 2 ^ 51)
"""


def bytes_expr(o, var):
    fs = FIELDS[o]
    return " ++ ".join(f"bytesOf {var}.{f}" for f in reversed(fs))


def size(o):
    return 40 * len(FIELDS[o])


def gen(fn, outt, ins):
    lines = [HEADER.format(fn=fn)]
    w = lines.append
    if outt != "bytes":
        fs = FIELDS[outt]
        w(f"/-- `{CTY[outt]}`s agree. -/")
        w(f"private def eq{outt} (a b : Ge{outt}) : Bool :=")
        w("  " + " && ".join(f"limbsEq a.{f} b.{f}" for f in fs))
        w("")
    names = ["P", "Q"][: len(ins)]
    params = " ".join(f"({n} : Ge{t})" for n, t in zip(names, ins))
    ret = f"Ge{outt}" if outt != "bytes" else "(BitVec 256)"
    osize = size(outt) if outt != "bytes" else 32
    blocks = [f"(⟨1⟩, blk {osize} 0)"]
    for i, (n, t) in enumerate(zip(names, ins)):
        blocks.append(f"(⟨{i + 2}⟩, blk {size(t)} ({bytes_expr(t, n)}))")
    nb = len(blocks) + 1
    args = " ".join(f"(.value ⟨⟨{i + 1}⟩, 0⟩)" for i in range(len(blocks)))
    rd = f"s'.mem.read{outt} ⟨⟨1⟩, 0⟩" if outt != "bytes" else "s'.mem.readAt ⟨⟨1⟩, 0⟩ 256"
    desc_in = ", ".join(f"`{n}` in block {i + 2}" for i, n in enumerate(names))
    w(f"/-- The output in block 1{', ' + desc_in if desc_in else ''}; the output after the call, or")
    w("`none` for UB. -/")
    w(f"private def run{(' ' + params) if params else ''} : Option {ret} :=")
    w("  let s : GlobalState :=")
    w(f"    ⟨⟨{nb}⟩, ⟨Std.ExtHashMap.ofList [{', '.join(blocks)}]⟩⟩")
    w(f"  match {fn}.call ({fn}.args {args}) s with")
    w(f"  | .value (_, s') => some ({rd})")
    w("  | _ => none")
    w("")
    if not ins:
        w("-- the spec's")
        w(f"#guard match run with")
        w(f"  | some R => eq{outt} R {fn}.spec")
        w("  | none => false")
    else:
        # three test inputs
        def obj(t, k):
            return "⟨" + ", ".join(f"fe {k * 7 + j}" for j in range(len(FIELDS[t]))) + "⟩"
        tests = []
        for k in range(3):
            tests.append("(" + ", ".join(obj(t, k + 3 * i) for i, t in enumerate(ins)) + ")" if len(ins) > 1
                         else obj(ins[0], k))
        if len(ins) == 1:
            w("-- the spec's, on three inputs")
            w(f"#guard ([{', '.join(tests)}] : List Ge{ins[0]}).all fun P =>")
            w("  match run P with")
            if outt == "bytes":
                w(f"  | some R => R == {fn}.spec P")
            else:
                w(f"  | some R => eq{outt} R ({fn}.spec P)")
            w("  | none => false")
        else:
            w("-- the spec's, on three inputs")
            w(f"#guard ([{', '.join(tests)}] : List (Ge{ins[0]} × Ge{ins[1]})).all fun (P, Q) =>")
            w("  match run P Q with")
            w(f"  | some R => eq{outt} R ({fn}.spec P Q)")
            w("  | none => false")
    w("")
    w("end MLIR.Boringssl")
    return "\n".join(lines) + "\n"


os.makedirs(OUT, exist_ok=True)
for fn, (outt, ins) in FNS.items():
    with open(os.path.join(OUT, fn + ".lean"), "w") as f:
        f.write(gen(fn, outt, ins))
print("ok")
