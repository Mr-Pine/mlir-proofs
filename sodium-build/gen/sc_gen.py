"""Writes Sodium/sc25519_reduce.lean: the walk (run lemmas in continuation form, each value named
with its compiled equation and bound), the compiled computation `ir`, and `ir = spec` by bridge
lemmas matching linear forms.

    python3 sodium-build/gen/sc_gen.py [SPLITS]
    lean-fmt-nightly-2026-09-16 format Sodium/sc25519_reduce.lean

SPLITS are the run lemmas' boundaries (instruction positions), by default the ones in use.
"""
import os, re, sys
from sc_model import model, lit, M21, M43, M63, NEG21

m = model()
c, ins, arg, const, ptr = m['c'], m['ins'], m['arg'], m['const'], m['ptr']
form, kind, info, names, defs, sib = (m['form'], m['kind'], m['info'], m['names'], m['defs'],
                                       m['sib'])
OUT = os.path.expanduser('~/mlir-proofs/Sodium/sc25519_reduce.lean')
F = 'sc25519_reduce'
GAM = f'{F}.Γ'
LO, HI = -2 ** 63, 2 ** 63 - 1

body = ins[:-1]
assert ins[-1]['op'] == 'return'
pos = {d['res']: i for i, d in enumerate(body) if d['res']}
u64 = lambda v: v % 2 ** 64
BYTE = lambda r: kind.get(r) == 'byteop' or (defs.get(r, {}).get('op') in ('trunc',))


def is_byte(r):
    return r in defs and (kind.get(r) in ('byteop', 'trunc', 'shl', 'or'))


# display names
disp, used = {}, set()
for d in body:
    r = d['res']
    if r is None or r not in kind or is_byte(r) or d['op'] in ('mlir.constant', 'getelementptr'):
        continue
    if kind[r] == 'carry':
        nm = info[r][0]
    elif r in names:
        cands = [x for x in names[r] if x not in used and not x.startswith('carry')]
        nm = cands[0] if cands else None
    else:
        nm = None
    if nm is None or nm in used:
        nm = 't' + r[1:]
    used.add(nm)
    disp[r] = nm
isval = lambda d: d['res'] in disp


def lsh(x):
    return x[1:]


def off(x):
    return 0 if x == arg else ptr[x]


def dn(x):
    if x in const:
        return f"{u64(const[x])}#64"
    return disp.get(x) or x


def rexpr(d, mem='(S.mem.readAt p 512)', name=dn):
    """The compiled value of `d` over its operands, as the walk's equation states it."""
    op, a = d['op'], d['args']
    if op == 'call':
        w = '3' if 'load_3' in d['callee'] else '4'
        return f"load{w} {mem} {off(a[0])}"
    mm = {'add': '+', 'sub': '-', 'mul': '*', 'and': '&&&', 'or': '|||'}
    if op in mm:
        return f"{name(a[0])} {mm[op]} {name(a[1])}"
    if op == 'lshr':
        return f"{name(a[0])} >>> {const[a[1]]}"
    if op == 'ashr':
        return f"{name(a[0])}.sshiftRight {const[a[1]]}"
    raise Exception(op)


# --- bounds, as `bnd_ext` computes them (for the shl side conditions)
import sc_bounds
bnd = sc_bounds.bnd


def uses(d):
    return [x for x in d['args'] if x.startswith('%') and x not in const and x != arg]


def is_ptr(x):
    return defs.get(x, {}).get('op') == 'getelementptr'


def pval(x):
    return f"p.add {ptr[x]}#64"


def bstr(b):
    return f"({b})" if b < 0 else str(b)


SIMP = {'add': ('nswAdd', 'nuwAdd'), 'mul': ('nswMul', 'nuwMul'), 'sub': ('nswSub', None)}


def walk_lines(d):
    r, op, a = d['res'], d['op'], d['args']
    if op in ('mlir.constant', 'getelementptr'):
        return ['step_pure']
    if op == 'call':
        nm = disp[r]
        o = off(a[0])
        if 'load_3' in d['callee']:
            prf = ('BitVec.not_uaddOverflow_of_le hp_off (by decide)' if o == 0
                   else f'off3 hp_off {o} (by decide)')
            l = f'step_call using (load_3.call_eq (hp_off := {prf})) with {nm}'
        else:
            l = f'step_call using load_4.call_eq with {nm}'
        return [l] + ([f'bnd_ext {nm}'] if r in need else [])
    if op == 'store':
        return ['step_store']
    if op == 'shl' and d['flags']:
        x, k = a[0], const[a[1]]
        args = []
        if d['flags'] & 2:
            args.append(f'{F}.shl_nuw {disp[x]} {k} (by decide) (Bnd.umulOverflow _ _ _ hb{disp[x]} 128#64 (by decide))')
        if d['flags'] & 1:
            args.append(f'{F}.shl_nsw {disp[x]} {k} (by decide) (Bnd.smulOverflow _ _ _ hb{disp[x]} 128#64 (by decide))')
        return [f"step_pure [{', '.join(args)}]"]
    if op == 'or':
        sh, lo = defs[a[0]], defs[a[1]]
        assert sh['op'] == 'shl'
        x, k = disp[sh['args'][0]], const[sh['args'][1]]
        if lo['op'] == 'and':
            y = disp[defs[lo['args'][0]]['args'][0]]
            return [f'step_pure [{F}.or_disj_mask {x} {y}]']
        y, n = lo['args'][0], const[lo['args'][1]]
        assert k + n == 21
        return [f'step_pure [{F}.or_disj {x} {disp[y]} {k} (by decide) '
                f'(Bnd.umulOverflow _ _ _ hb{disp[y]} 8796093022208#64 (by decide))]']
    if r and is_byte(r) or (r and r not in disp):
        return ['step_pure']
    nm = disp[r]
    args = []
    if op in SIMP:
        f = d['flags']
        if f & 1:
            args.append(SIMP[op][0])
        if f & 2 and SIMP[op][1]:
            args.append(SIMP[op][1])
    sa = (' [' + ', '.join(args) + ']') if args else ''
    return [f'step_pure{sa} with {nm}'] + ([f'bnd_ext {nm}'] if r in need else [])


def flag_refs(d):
    """Operands whose `Bnd` facts discharge `d`'s flags: the `nsw`/`nuw` simprocs', and the
    `shl`/`or disjoint` side conditions'."""
    op, a = d['op'], d['args']
    if op == 'shl':
        return uses(d) if d['flags'] else []
    if op == 'or':
        lo = defs[a[1]]
        return [] if lo['op'] == 'and' else uses(lo)
    return uses(d) if (op in SIMP and d['flags'] and d['res'] in disp) else []


def derive_refs(d):
    """Operands whose `Bnd` facts `bnd_ext` reads for `d`'s, unless that is the trivial bound."""
    op, a, r = d['op'], d['args'], d['res']
    if not r or r not in disp or op == 'call' or bnd[r] == (LO, HI):
        return []
    if op in ('add', 'sub', 'mul', 'ashr'):
        return uses(d)
    if op == 'lshr' and sc_bounds.gb(a[0])[0] >= 0:
        return uses(d)
    if op == 'and':
        k = lit(const[a[1]])
        if k == NEG21 or (k == M63 and sc_bounds.gb(a[0])[0] >= 0):
            return uses(d)
    return []


# `need[x]`: some step reads `x`'s `Bnd` fact, directly or through a needed derived fact
need = set()
for d in reversed(body):
    need |= set(flag_refs(d))
    if d['res'] in need:
        need |= set(derive_refs(d))


def fact_refs(d):
    """Operands whose `Bnd` facts the steps of `d` read."""
    return flag_refs(d) + (derive_refs(d) if d['res'] in need else [])


consts = [d for d in body if d['op'] == 'mlir.constant']


def consts_abbrev():
    items = ', '.join(f"{d['res']} := {u64(d['value'])}#{d['vty'][1:]}" for d in consts)
    return (f"/-- The constants the code reads. -/\nabbrev {F}.Consts (E : ⟪{GAM}⟫) : Prop :=\n"
            f"  E ⊨ [{items}]\n")


# stores, in program order: (offset, width, value register)
def store_list():
    out = []
    for d in body:
        if d['op'] == 'store':
            v = d['args'][0]
            out.append((off(d['args'][1]), int(defs[v]['ty'][1:]), v))
    return out


STORES = store_list()


def inline(v):
    """A stored value over the named registers, in the form the steps leave it (`setWidth` pushed
    through `|||`, `<<<` and the `&&& 31` mask)."""
    d = defs[v]
    assert d['op'] == 'trunc'
    w, x = int(d['ty'][1:]), d['args'][0]

    def low(y):
        if y in disp:
            return f"BitVec.setWidth {w} {disp[y]}"
        dy = defs[y]
        if dy['op'] == 'lshr':
            return f"BitVec.setWidth {w} ({disp[dy['args'][0]]} >>> {const[dy['args'][1]]})"
        assert dy['op'] == 'and' and const[dy['args'][1]] == 31
        return low(dy['args'][0]) + f" &&& 31#{w}"
    if x in disp:
        return f"BitVec.setWidth {w} {disp[x]}"
    dx = defs[x]
    if dx['op'] == 'or':
        sh = defs[dx['args'][0]]
        return (f"BitVec.setWidth {w} {disp[sh['args'][0]]} <<< {const[sh['args'][1]]} ||| " +
                low(dx['args'][1]))
    return low(x)


def store_regs(v):
    """The named registers a stored value reads."""
    if v in disp:
        return [v]
    return [y for x in uses(defs[v]) for y in store_regs(x)]


FINAL = sorted({y for _, _, v in STORES for y in store_regs(v)}, key=lambda x: pos[x])


def out_args():
    return ' '.join(disp[r] for r in FINAL)


def out_def():
    vs = [inline(v) for _, _, v in STORES]
    acc = f"({vs[0]})"
    for v in vs[1:]:
        acc = f"({v}) ++ ({acc})"
    return (f"/-- The 32 bytes the code stores, from the final limbs. -/\n"
            f"def {F}.out ({out_args()} : BitVec 64) : BitVec 256 :=\n  {acc}\n")


def merge_rws():
    L, acc = [], STORES[0][1]
    for o, w, v in STORES[1:]:
        assert acc == 8 * o, (acc, o)
        L.append(f"MemoryState.storeAt_storeAt_add (a := {acc}) (k := {o}) "
                 f"(BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide)")
        acc += w
    return L


def run_lemma(P, Q, last):
    seg = body[P:Q]
    defined = [d['res'] for d in seg if d['res'] and isval(d)]
    later = set()
    for d in body[Q:]:
        later |= set(uses(d))
    inuse = []
    for d in seg:
        for x in uses(d):
            if pos.get(x, 10 ** 9) < P and x not in inuse:
                inuse.append(x)
    for x in later:
        if pos.get(x, 10 ** 9) < P and x not in inuse:
            inuse.append(x)
    inuse.sort(key=lambda x: pos[x])
    bused = set()
    for d in seg:
        bused |= set(fact_refs(d))
    livein_vals = [x for x in inuse if not is_ptr(x)]
    livein_ptrs = [x for x in inuse if is_ptr(x)]
    liveout = sorted([x for x in later if pos.get(x, 10 ** 9) < Q], key=lambda x: pos[x])
    has_call = any(d['op'] == 'call' for d in seg)
    nm = f"{F}.run{P}"
    L = [f"/-- `^bb0` from instruction {P} to {Q}: its values named, with their forms and bounds. -/"]
    if last:
        L = ["-- 24 stores, merged into one at the end: past the default budget",
             "set_option maxHeartbeats 1000000 in"] + L
    L.append(f"theorem {nm} {{β : Type}} {{p : Pointer}}")
    L.append(f"    {{blk : BasicBlock {GAM} [] {F}.blockTys}}")
    L.append(f"    (hbody : blk.body.drop {P} = {F}.entry.body.drop {P})")
    L.append(f"    {{E : ⟪{GAM}⟫}} {{S : GlobalState}}")
    L.append(f"    {{g : ⟪{GAM}⟫ × GlobalState → PoisonOr β}} {{K : PoisonOr β}}")
    iv = [disp[x] for x in livein_vals]
    if iv:
        L.append(f"    {{{' '.join(iv)} : BitVec 64}}")
    L.append(f"    (hArgs : E.args = ({F}.args (.value p)).get)")
    if has_call:
        L.append("    (hwf : S.WF)")
    if has_call or last:
        L.append("    (hp : Fits S.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64)")
    if P > 0:
        L.append(f"    (hc : {F}.Consts E)")
    rd = [f"{x} := {disp[x]}" for x in livein_vals] + [f"{x} := {pval(x)}" for x in livein_ptrs]
    if rd:
        L.append(f"    (hR : E ⊨ [{', '.join(rd)}])")
    for x in livein_vals:
        if x in bused:
            lo, hi = bnd[x]
            L.append(f"    (hb{disp[x]} : Bnd {disp[x]} {bstr(lo)} {bstr(hi)})")
    outv = [disp[x] for x in defined]
    K = [f"    (hK : ∀ (E' : ⟪{GAM}⟫)" + (f" ({' '.join(outv)} : BitVec 64)" if outv else "") + ","]
    K.append(f"      (hArgs : E'.args = ({F}.args (.value p)).get) →")
    K.append(f"      (hc : {F}.Consts E') →")
    ro = ([f"{x} := {disp[x]}" for x in liveout if not is_ptr(x)] +
          [f"{x} := {pval(x)}" for x in liveout if is_ptr(x)])
    if ro and not last:
        K.append(f"      (hR : E' ⊨ [{', '.join(ro)}]) →")
    for x in defined:
        K.append(f"      (h{disp[x]} : {disp[x]} = {rexpr(defs[x])}) →")
    later_b = set()
    for d in body[Q:]:
        later_b |= set(fact_refs(d))
    bout = [x for x in defined if x in later_b]
    for x in bout:
        lo, hi = bnd[x]
        K.append(f"      (hb{disp[x]} : Bnd {disp[x]} {bstr(lo)} {bstr(hi)}) →")
    if last:
        K.append(f"      (blk.runBodyFrom E' {Q} {{ S with mem := S.mem.storeAt p ({F}.out {out_args()}) }}"
                 f" >>= g) = K) :")
    else:
        K.append(f"      (blk.runBodyFrom E' {Q} S >>= g) = K) :")
    L += K
    L.append(f"    (blk.runBodyFrom E {P} S >>= g) = K := by")
    for d in seg:
        for l in walk_lines(d):
            L.append("  " + l)
    if has_call or last:
        L.append("  subst hS")
    if last:
        L.append("  rw [" + ",\n    ".join(merge_rws()) + "]")
    args = ["_"] + outv + ["hArgs", f"(by unfold {F}.Consts; env_reads)"]
    if ro and not last:
        args.append("(by env_reads)")
    for x in defined:
        d = defs[x]
        if d['op'] == 'call' and off(d['args'][0]) == 0:
            w = '3' if 'load_3' in d['callee'] else '4'
            args.append(f"(h{disp[x]}.trans (Boringssl.x25519_sc_reduce.setWidth_load{w} _))")
        else:
            args.append(f"h{disp[x]}")
    for x in bout:
        args.append(f"hb{disp[x]}")
    L.append("  exact hK " + " ".join(args))
    return "\n".join(L)


def main_line(P):
    return f"  step_pattern using {F}.run{P}"


# ---------------------------------------------------------------- the compiled computation
def tn(r):
    return 't' + r[1:]


def opnd(x):
    if x in const:
        return f"{u64(const[x])}#64"
    return tn(x)


def ir_lets():
    out = []
    for d in body:
        r = d['res']
        if r is None or r not in disp:
            continue
        out.append((tn(r), rexpr(d, mem='x', name=opnd)))
    return out


def ir_def_text():
    lines = [f"  let {n} := {e}" for n, e in ir_lets()]
    lines.append(f"  {F}.out " + " ".join(tn(r) for r in FINAL))
    return (f"/-- The compiled code's computation, one `let` per value, on the 64 bytes `x`. -/\n"
            f"def {F}.ir (x : BitVec 512) : BitVec 256 :=\n" + "\n".join(lines) + "\n")


ATOMK = ('limb', 'limbnomask', 'carry')
clet = {n: (e, k, inf) for n, e, k, inf in c.lets}
corder = [n for n, _, _, _ in c.lets]


def cdeps(n):
    return [x for x in re.findall(r'\b(?:s|carry)\d+(?:_\d+)?\b', clet[n][0]) if x in clet]


def lshr_carry(r):
    return kind.get(r) == 'carry' and info[r][1] == 'lshr'


def conv_args(x):
    k = kind.get(x)
    if k == 'mask':
        return [info[x][0]]
    if k == 'low':
        return [defs[x]['args'][0], info[x]]
    return uses(defs[x])


def conv_def(x):
    d = defs[x]
    k = kind.get(x)
    if k == 'mask':
        return f"{tn(info[x][0])} <<< 21"
    if k == 'low':
        return f"{tn(d['args'][0])} - {tn(info[x])} <<< 21"
    if lshr_carry(x):
        return f"{opnd(d['args'][0])}.sshiftRight 21"
    return rexpr(d, mem='x', name=opnd)


def conv_proof(x):
    """The name of `x`'s converted equation in `ir_eq_spec`, or `rfl`."""
    if lshr_carry(x):
        return f"n{lsh(x)}"
    if kind.get(x) in ('mask', 'low'):
        return f"m{lsh(x)}"
    return "rfl"


def cclos(r):
    seen, atoms = [], []

    def go(x, top):
        if x in seen or x in atoms:
            return
        if not top and kind.get(x) in ATOMK:
            atoms.append(x)
            return
        seen.append(x)
        for y in conv_args(x):
            go(y, False)
    go(r, True)
    return [x for x in [d['res'] for d in body] if x in seen], atoms


def Cclos(n):
    seen, atoms = set(), set()

    def go(x, top):
        if x in seen or x in atoms:
            return
        k = clet[x][1]
        if not top and k in ('load', 'carryr', 'carryf'):
            atoms.add(x)
            return
        seen.add(x)
        for y in cdeps(x):
            go(y, False)
    go(n, True)
    return [x for x in corder if x in seen], [x for x in corder if x in atoms]


def cname(r):
    return info[r][0] if kind[r] == 'carry' else info[r]


def expand(x):
    if x in const:
        return f"{u64(const[x])}#64"
    e = rexpr(defs[x], mem='x', name=lambda y: '(' + expand(y) + ')' if y in defs else opnd(y))
    return e


def bridge(r, target, carry):
    cv, ca = cclos(r)
    Cv, Ca = Cclos(target)
    vars_ = [tn(x) for x in cv] + [tn(x) for x in ca]
    cvars = Cv + [x for x in Ca if x not in Cv]
    for a in ca:
        if cname(a) not in cvars:
            cvars.append(cname(a))
    hyps = [f"(h{tn(x)} : {tn(x)} = {conv_def(x)})" for x in cv]
    hyps += [f"(e{tn(a)} : {tn(a)} = {cname(a)})" for a in ca]
    hyps += [f"(h{x} : {x} = {clet[x][0]})" for x in Cv]
    allv = vars_ + cvars
    name = f"{F}.bridge_{target}"
    stmt = (f"/-- `{target}` as the C computes it is the compiled `%{lsh(r)}`. -/\n"
            f"theorem {name} ({' '.join(allv)} : BitVec 64)\n    " + "\n    ".join(hyps) +
            f" :\n    {tn(r)} = {target} := by\n  subst_vars\n" +
            ("  refine congrArg (BitVec.sshiftRight · 21) ?_\n" if carry else "") + "  grind\n")
    args = [conv_proof(x) for x in cv] + [f"e{lsh(x)}" for x in ca] + ["rfl" for _ in Cv]
    use = f"  have e{lsh(r)} := {name} {' '.join(allv)} {' '.join(args)}"
    return stmt, use


def ir_eq_spec_text():
    lemmas, uses_ = [], []
    for d in body:
        r = d['res']
        k = kind.get(r)
        if k == 'limb':
            uses_.append(f"  have e{lsh(r)} : {tn(r)} = {info[r]} := BitVec.and_comm _ _")
        elif k == 'limbnomask':
            w, o, sh = m['rawload'][r]
            if info[r] == 's23':
                uses_.append(f"  have e{lsh(r)} : {tn(r)} = {info[r]} := rfl")
            else:
                uses_.append(f"  have e{lsh(r)} : {tn(r)} = {info[r]} := nomask{w}_{sh} _")
        if lshr_carry(r):
            E = expand(defs[r]['args'][0])
            lemmas.append(f"/-- `%{lsh(r)}` shifts a non-negative value: logically as arithmetically. -/\n"
                          f"theorem {F}.lshr{lsh(r)} (x : BitVec 512) :\n    ({E}) >>> 21 = "
                          f"({E}).sshiftRight 21 := by\n  unfold load3 load4\n  bv_decide\n")
            uses_.append(f"  have n{lsh(r)} : {tn(r)} = {opnd(defs[r]['args'][0])}.sshiftRight 21 :="
                         f" {F}.lshr{lsh(r)} x")
        if k == 'mask':
            s, M = info[r]
            if M == NEG21:
                uses_.append(f"  have m{lsh(r)} : {tn(r)} = {tn(s)} <<< 21 := Bnd.and_neg_shift _")
            else:
                E = expand(defs[r]['args'][0])
                lemmas.append(f"/-- `%{lsh(r)}`'s mask, on a non-negative value, clears its low 21 bits. -/\n"
                              f"theorem {F}.mask{lsh(r)} (x : BitVec 512) :\n    ({E}) &&& "
                              f"{u64(M)}#64 = ({E}) >>> 21 <<< 21 := by\n  unfold load3 load4\n"
                              f"  bv_decide\n")
                uses_.append(f"  have m{lsh(r)} : {tn(r)} = {tn(s)} <<< 21 := {F}.mask{lsh(r)} x")
        if k == 'low':
            uses_.append(f"  have m{lsh(r)} : {tn(r)} = {tn(defs[r]['args'][0])} - {tn(info[r])} "
                         f"<<< 21 := Bnd.and_mask_sub _")
        if k == 'carry':
            s, u = bridge(r, info[r][0], True)
            lemmas.append(s)
            uses_.append(u)
        elif r in FINAL:
            s, u = bridge(r, names[r][0], False)
            lemmas.append(s)
            uses_.append(u)
    return lemmas, uses_


def final_chain():
    """C lets between the stored C values and the final limbs: each final limb `fin := pre - carry
    <<< 21` (and its `carry := pre >> 21`) whose `pre` is stored."""
    stored = {names[r][0] for r in FINAL}
    want = stored | {c.cur[f"s{k}"] for k in range(12)}
    need = set()
    for x in want:
        seen, leaves, todo = set(), set(), list(cdeps(x))
        while todo:
            y = todo.pop()
            if y in stored:
                leaves.add(y)
            elif y not in seen:
                seen.add(y)
                todo += cdeps(y)
        if leaves and all(clet[y][1] in ('carryr', 'carryf') for y in seen):
            need |= {x} | seen
    return [(x, clet[x][0]) for x in corder if x in need]


def out_eq_text():
    fin = [names[r][0] for r in FINAL]
    tv = [tn(r) for r in FINAL]
    chain = final_chain()
    hyps = " ".join(f"(e{i} : {t} = {s})" for i, (t, s) in enumerate(zip(tv, fin)))
    hyps += " " + " ".join(f"(h{x} : {x} = {e})" for x, e in chain)
    rhs = " ++ ".join(e for i, e in sorted(c.bytes, key=lambda b: -b[0]))
    allv = list(dict.fromkeys(tv + fin + [x for x, _ in chain]))
    t = (f"/-- The stored bytes, from the C's limbs, are the spec's. -/\n"
         f"theorem {F}.out_eq {{{' '.join(allv)} : BitVec 64}} {hyps} :\n"
         f"    {F}.out {' '.join(tv)} =\n      {rhs} := by\n  subst_vars\n  unfold {F}.out\n"
         f"  bv_decide\n")
    return t, len(chain)


def ir_eq_spec_thm():
    lemmas, uses_ = ir_eq_spec_text()
    ot, nch = out_eq_text()
    irn = [n for n, _ in ir_lets()]
    cn = [n for n, _, _, _ in c.lets] + [f"b{i}" for i, _ in c.bytes]
    t = (f"/-- The compiled computation is BoringSSL's spec. -/\n"
         f"theorem {F}.ir_eq_spec (x : BitVec 512) :\n    {F}.ir x = Boringssl.x25519_sc_reduce.spec x"
         f" := by\n  unfold {F}.ir Boringssl.x25519_sc_reduce.spec\n  lift_lets -merge\n")
    t += "  intro " + " ".join(irn + cn) + "\n"
    t += "\n".join(uses_) + "\n"
    t += (f"  exact {F}.out_eq " + " ".join(f"e{lsh(r)}" for r in FINAL) + " " +
          " ".join(["rfl"] * nch) + "\n")
    return "\n".join(lemmas) + "\n" + ot + "\n" + t


HEAD = open(os.path.join(os.path.dirname(__file__), 'sc_head.lean')).read()
MID = ''


def main():
    splits = (eval(sys.argv[1]) if len(sys.argv) > 1 else
              [0, 60, 116, 160, 205, 250, 295, 340, 385, 425, 464, len(body)])
    assert splits[-1] == len(body), len(body)
    runs = [run_lemma(splits[i], splits[i + 1], splits[i + 1] == len(body))
            for i in range(len(splits) - 1)]
    ml = [main_line(P) for P in splits[:-1]]
    ml.insert(-1, "  clear hwf hp")
    thm = f'''
/-- `sc25519_reduce` stores BoringSSL's `x25519_sc_reduce.spec` of the 64 bytes at `p` as the 32
bytes at `p`. -/
public theorem {F}.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64) :
    {F}.call ({F}.args (.value p)) s =
      .value (.nil,
        {{ s with mem := s.mem.storeAt p (Boringssl.x25519_sc_reduce.spec (s.mem.readAt p 512)) }}) := by
  generalize hres : Boringssl.x25519_sc_reduce.spec (s.mem.readAt p 512) = res
  func_init
  have hp₀ : Fits S₀.mem p (8 * 64) := hS ▸ hp
  block_init
''' + "\n".join(ml) + f'''
  rw [BasicBlock.runBodyFrom_done (block := {F}.entry) (pos := {len(body)})
      (by decide +kernel)]
  simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, reduceFuncContinue, Exit.run]
  rw [hS]
  subst hres
  rw [← {F}.ir_eq_spec]
  keep_eqs
  subst_vars
  rfl
'''
    s = (HEAD + "\n/-! ## The compiled computation -/\n\nsection Compiled\n\n" + out_def() + "\n" + ir_def_text() + "\n" +
         MID + "\n" + ir_eq_spec_thm() + "\nend Compiled\n\n/-! ## Proof -/\n\nsection Proof\n\n" +
         consts_abbrev() + "\n" + "\n\n".join(runs) + "\n" + thm +
         "\nend Proof\n\nend MLIR.Sodium\n")
    if os.environ.get('NOPROOF'):
        s = (HEAD + "\n/-! ## The compiled computation -/\n\nsection Compiled\n\n" + out_def() + "\n" + ir_def_text() +
             "\n" + MID + "\n" + ir_eq_spec_thm() + "\nend Compiled\n\nend MLIR.Sodium\n")
    open(OUT, 'w').write(s)
    print(len(body), 'instructions;', len(FINAL), 'stored values')


if __name__ == '__main__':
    main()
