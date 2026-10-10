"""Prints the generalize/bound steps of `fe25519_reduce.spec_nat` (Sodium/Math/Field.lean)."""
M = "2251799813685247#128"
steps = []  # (name, kind, args, bound)
def sa(n, x, y, b): steps.append((n, f"{x} >>> 51 + {y}", f"t_shift_add (x := {x}) (y := {y}) (b{y}.trans (by decide))", [x, y], b))
def ash(n, x, y, b): steps.append((n, f"{x} + {y} >>> 51", f"t_add_shift (x := {x}) (y := {y}) (b{x}.trans (by decide))", [x, y], b))
def mk(n, x): steps.append((n, f"{x} &&& {M}", f"t_mask {x}", [], 51))
def c19(n, x, b): steps.append((n, f"{x} >>> 51 * 19#128", f"t_carry19 (x := {x}) (b{x}.trans (by decide))", [x], b))
def ad(n, x, y, b, yc=None):
    if yc is None:
        steps.append((n, f"{x} + {y}", f"t_add (x := {x}) (y := {y}) (b{x}.trans (by decide)) (b{y}.trans (by decide))", [x, y], b))
    else:
        steps.append((n, f"{x} + {yc}", f"t_add_const (x := {x}) (b{x}.trans (by decide)) (by decide)", [x], b))
sa("a1","z0","z1",65); sa("a2","a1","z2",65); sa("a3","a2","z3",65); sa("a4","a3","z4",65)
c19("qa","a4",19)
for i in range(5): mk(f"a{i}m", f"z0" if i == 0 else f"a{i}")
ad("b0","qa","a0m",52)
sa("b1","b0","a1m",52); sa("b2","b1","a2m",52); sa("b3","b2","a3m",52); sa("b4","b3","a4m",52)
c19("qb","b4",6)
for i in range(5): mk(f"b{i}m", f"b{i}")
ad("c0a","b0m",None,52,"19#128"); ad("c0","c0a","qb",53)
sa("c1","c0","b1m",52); sa("c2","c1","b2m",52); sa("c3","c2","b3m",52); sa("c4","c3","b4m",52)
c19("qc","c4",6)
for i in range(4): mk(f"c{i}m", f"c{i}")
ad("d0a","c0m",None,52,"2251799813685229#128"); ad("d0","d0a","qc",53)
for i in range(1,4): ad(f"d{i}",f"c{i}m",None,52,M)
ad("d4","c4",None,53,M)
ash("e1","d1","d0",53); ash("e2","d2","e1",53); ash("e3","d3","e2",53); ash("e4","d4","e3",54)
for n, pat, lem, ops, b in steps:
    print(f"  generalize h{n} : {pat} = {n}")
    print(f"  have k{n} := h{n} ▸ {lem}")
    deps = " ".join(f"b{o}" for o in ops)
    print(f"  have b{n} : {n}.toNat < 2 ^ {b} := by clear * - k{n} {deps}; omega")
    print(f"  clear h{n}")
