"""sc25519_reduce's compiled code and libsodium's C as linear forms over limbs and carries.

The C (from ~/src/libsodium) is rewritten into BoringSSL's spelling and parsed by
boringssl-build/gen/cmodel.py, so its lets are those of `Boringssl.x25519_sc_reduce.spec`."""
import os, re, sys
HOME = os.path.expanduser('~')
sys.path.insert(0, f'{HOME}/mlir-proofs/boringssl-build/gen')
import cmodel
from cmodel import lin_add, lin_scale
from ir import parse as irparse

LIFT = f'{HOME}/mlir-proofs/Sodium/Mlir/sc25519_reduce.lean'
CSRC = f'{HOME}/src/libsodium/src/libsodium/crypto_core/ed25519/ref10/ed25519_ref10.c'
CNORM = '/tmp/w2gen/screduce.c'
M21, M43, M63, NEG21 = 2097151, 8796090925056, 9223372036852678656, -2097152


def normalize_c():
    """libsodium's `sc25519_reduce` in BoringSSL's spelling."""
    src = open(CSRC).read()
    body = src[src.index('sc25519_reduce(unsigned char s[64])'):]
    body = body[:body.index('\n}\n') + 3]
    out = []
    for l in body.split('\n'):
        l = re.sub(r'\s+', ' ', l).strip()
        l = l.replace('(int64_t) (1L << 20)', '(1 << 20)')
        l = re.sub(r'(s\d+) -= (carry\d+) \* \(\(uint64_t\) 1L << 21\);', r'\1 -= int64_lshift21(\2);', l)
        l = re.sub(r'\((s\d+) \* \(\(uint64_t\) 1 << (\d+)\)\)', r'(\1 << \2)', l)
        if l.startswith('sc25519_reduce') or l == '{':
            continue
        out.append(l)
    os.makedirs(os.path.dirname(CNORM), exist_ok=True)
    open(CNORM, 'w').write('\n'.join(out) + '\n')


def key(f):
    return tuple(sorted((str(k), v) for k, v in f.items()))


def lit(v):
    v %= 2 ** 64
    return v - 2 ** 64 if v >= 2 ** 63 else v


def model():
    normalize_c()
    cmodel.SRC = CNORM
    c = cmodel.parse()
    ins = [d for d in irparse(LIFT) if d['op'] != 'func']
    arg = next(a for d in ins for a in d['args'] if a.startswith('%arg'))
    const, ptr, form, kind, info, rawload = {}, {}, {}, {}, {}, {}
    cload = {}
    for n, e, k, inf in c.lets:
        if k == 'load':
            cload[(inf[0], inf[1], inf[2])] = n
    ccarry = {}
    for n, e, k, inf in c.lets:
        if k == 'carryr':
            ccarry[key(lin_add(c.form[inf], {1: 2 ** 20}))] = n
        if k == 'carryf':
            ccarry[key(c.form[inf])] = n
    cform = {}
    for n, e, k, inf in c.lets:
        cform.setdefault(key(c.form[n]), []).append(n)
    defs = {d['res']: d for d in ins if d['res']}
    sib = {}  # operand of a carry shift -> the shift register
    for d in ins:
        if d['op'] in ('lshr', 'ashr') and d['args'][1] in const_regs(ins) and \
                const_regs(ins)[d['args'][1]] == 21:
            sib[d['args'][0]] = d['res']
    for d in ins:
        r, op, a = d['res'], d['op'], d['args']

        def F(x):
            if x in form:
                return form[x]
            if x in const:
                return {1: const[x]}
            if x in rawload:
                nm = cload[rawload[x]]
                form[x] = {('L', nm): 1}
                kind[x] = 'limbnomask'
                info[x] = nm
                return form[x]
            raise Exception('noform ' + x)
        if op == 'mlir.constant':
            const[r] = d['value']
            continue
        if op == 'getelementptr':
            ptr[r] = d['gep']
            continue
        if op == 'call':
            o = 0 if a[0] == arg else ptr[a[0]]
            rawload[r] = ('3' if 'load_3' in d['callee'] else '4', o, 0)
            kind[r] = 'loadcall'
            continue
        if op in ('lshr', 'ashr') and a[0] in rawload:
            w, o, _ = rawload[a[0]]
            rawload[r] = (w, o, const[a[1]])
            kind[r] = 'loadshift'
            continue
        if op == 'and' and a[0] in rawload and const.get(a[1]) == M21:
            nm = cload[rawload[a[0]]]
            form[r] = {('L', nm): 1}
            kind[r] = 'limb'
            info[r] = nm
            continue
        if op == 'and' and lit(const.get(a[1], 0)) in (NEG21, M43, M63):
            s = sib[a[0]]
            form[r] = lin_scale(F(s), 2 ** 21)
            kind[r] = 'mask'
            info[r] = (s, lit(const[a[1]]))
            continue
        if op == 'and' and const.get(a[1]) == M21 and a[0] in sib:
            s = sib[a[0]]
            form[r] = lin_add(F(a[0]), F(s), -2 ** 21)
            kind[r] = 'low'
            info[r] = s
            continue
        if op == 'mul':
            form[r] = lin_scale(F(a[0]), lit(const[a[1]]))
            kind[r] = 'mul'
            continue
        if op in ('add', 'sub'):
            form[r] = lin_add(F(a[0]), F(a[1]), 1 if op == 'add' else -1)
            kind[r] = op
            continue
        if op in ('lshr', 'ashr') and const[a[1]] == 21:
            nm = ccarry[key(form[a[0]])]
            form[r] = {('K', nm): 1}
            kind[r] = 'carry'
            info[r] = (nm, op)
            continue
        if op in ('lshr', 'trunc', 'shl', 'or', 'and', 'store', 'return'):
            kind[r] = 'byteop' if r else op
            continue
        raise Exception(op + ' ' + str(r))
    names = {}
    for r, f in form.items():
        k = key(f)
        if k in cform:
            names[r] = cform[k]
    return dict(c=c, ins=ins, arg=arg, const=const, ptr=ptr, form=form, kind=kind, info=info,
                names=names, rawload=rawload, defs=defs, sib=sib)


_CR = None


def const_regs(ins):
    global _CR
    if _CR is None:
        _CR = {d['res']: d['value'] for d in ins if d['op'] == 'mlir.constant'}
    return _CR


if __name__ == '__main__':
    m = model()
    for d in m['ins']:
        r = d['res']
        if r in m['kind'] and m['kind'][r] not in ('loadcall', 'loadshift', 'byteop'):
            print(r, m['kind'][r], m['names'].get(r), m['info'].get(r, ''))
