"""Interval bounds of sc25519_reduce's values as `bnd_ext` computes them (operand intervals only:
residuals of masked carries are not recognized), and a check that they discharge every
`nsw`/`nuw` flag."""
from sc_model import model, lit, M63, NEG21
LO, HI = -2 ** 63, 2 ** 63 - 1
m = model()
ins, const, kind = m['ins'], m['const'], m['kind']
bnd = {}


def gb(x):
    if x in const:
        v = lit(const[x])
        return (v, v)
    return bnd[x]


def interval(d):
    op, a = d['op'], d['args']
    if op == 'call':
        return (0, 2 ** 24 - 1) if 'load_3' in d['callee'] else (0, 2 ** 32 - 1)
    if op == 'lshr':
        n = const[a[1]]
        lo, hi = gb(a[0])
        return (lo // 2 ** n, hi // 2 ** n) if lo >= 0 else (0, (2 ** 64 - 1) // 2 ** n)
    if op == 'ashr':
        n = const[a[1]]
        lo, hi = gb(a[0])
        return (lo // 2 ** n, hi // 2 ** n)
    if op == 'and':
        k = lit(const[a[1]])
        lo, hi = gb(a[0])
        if k == M63 and lo >= 0:
            return (lo // 2 ** 21 * 2 ** 21, hi // 2 ** 21 * 2 ** 21)
        if k >= 0:
            return (0, k)
        if k == NEG21:
            return (lo // 2 ** 21 * 2 ** 21, hi // 2 ** 21 * 2 ** 21)
        return (LO, HI)
    if op == 'mul':
        k = lit(const[a[1]])
        lo, hi = gb(a[0])
        r = (min(lo * k, hi * k), max(lo * k, hi * k))
    elif op == 'add':
        (a1, b1), (c1, d1) = gb(a[0]), gb(a[1])
        r = (a1 + c1, b1 + d1)
    elif op == 'sub':
        (a1, b1), (c1, d1) = gb(a[0]), gb(a[1])
        r = (a1 - d1, b1 - c1)
    else:
        raise Exception(op)
    return r if LO <= r[0] and r[1] <= HI else (LO, HI)


for d in ins:
    r = d['res']
    if r and (d['op'] == 'call' or kind.get(r) not in (None, 'byteop')):
        bnd[r] = interval(d)


def bad():
    out = []
    for d in ins:
        r, f, a = d['res'], d['flags'], d['args']
        if not r or d['op'] not in ('add', 'sub', 'mul') or r not in bnd:
            continue
        (a1, b1), (c1, d1) = gb(a[0]), gb(a[1])
        if f & 1:
            if d['op'] == 'add':
                ok = LO <= a1 + c1 and b1 + d1 <= HI
            elif d['op'] == 'sub':
                ok = LO <= a1 - d1 and b1 - c1 <= HI
            else:
                ok = all(LO <= v <= HI for v in (a1 * c1, b1 * c1))
            if not ok:
                out.append((r, 'nsw'))
        if f & 2:
            if d['op'] == 'add':
                ok = a1 >= 0 and c1 >= 0 and b1 + d1 < 2 ** 64
            else:
                ok = a1 >= 0 and c1 >= 0 and b1 * c1 < 2 ** 64
            if not ok:
                out.append((r, 'nuw'))
    return out


if __name__ == '__main__':
    print('undischarged flags:', bad())
