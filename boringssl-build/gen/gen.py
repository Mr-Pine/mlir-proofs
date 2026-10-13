import sys,re,os
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from irmodel import model
c,ins,const,form,kind,info,names,rawload,ptr=model()

def base(n):  # C variable of a let name
    return re.sub(r'_\d+$','',n)

def spec_text():
    out=[]
    for n,e,k,inf in c.lets:
        # shadowing: refer to base names
        e2=re.sub(r'\b((?:s|carry)\d+)_\d+\b',r'\1',e)
        out.append(f"  let {base(n)} := {e2}")
    bs=[]
    for i,e in c.bytes:
        e2=re.sub(r'\b((?:s|carry)\d+)_\d+\b',r'\1',e)
        out.append(f"  let b{i} := {e2}")
    out.append("  " + " ++ ".join(f"b{i}" for i in range(31,-1,-1)))
    return "\n".join(out)

# display names for compiled registers
disp={}
used=set()
for d in ins:
    r=d['res']
    if r is None or r not in kind: continue
    k=kind[r]
    if k=='carry': nm=info[r][0]
    elif r in names:
        cands=[x for x in names[r] if x not in used and not x.startswith('carry')]
        nm=cands[0] if cands else None
    else: nm=None
    if nm is None or nm in used: nm='t'+r[1:]
    used.add(nm); disp[r]=nm
if __name__=='__main__':
    print(spec_text())

def walk_text():
    out=[]
    simp={'add':('nswAdd','nuwAdd'),'mul':('nswMul','nuwMul'),'sub':('nswSub',None)}
    for d in ins:
        r=d['res']; op=d['op']; a=d['args']
        if op=='func': continue
        if op in ('mlir.constant','getelementptr'):
            out.append('  step_pure'); continue
        if op=='call':
            cal=d['callee']; nm=disp[r]
            if 'load_3' in cal:
                o=0 if a[0]=='%arg47' else ptr[a[0]]
                prf='BitVec.not_uaddOverflow_of_le hp_off (by decide)' if o==0 else f'off3 hp_off {o} (by decide)'
                out.append(f'  step_call using (load_3.call_eq (hp_off := {prf})) with {nm}')
            elif 'load_4' in cal:
                out.append(f'  step_call using load_4.call_eq with {nm}')
            else:
                arg=disp[a[0]]
                out.append(f'  step_call using (int64_lshift21.call_eq _ _ _ (lshift21_arg hb{arg} (by decide))) with {nm}')
            out.append(f'  bnd_ext {nm}'); continue
        if op in ('trunc','shl','or') or (op=='lshr' and kind.get(r)=='byteop'):
            out.append('  step_pure'); continue
        if op=='store': out.append('  step_store'); continue
        if op=='return': out.append('  finish_block'); continue
        nm=disp[r]
        args=[]
        if op in simp:
            f=d['flags']
            if f&1: args.append(simp[op][0])
            if f&2 and simp[op][1]: args.append(simp[op][1])
        sa=(' ['+', '.join(args)+']') if args else ''
        out.append(f'  step_pure{sa} with {nm}')
        out.append(f'  bnd_ext {nm}')
    return '\n'.join(out)

def u64(v): return v % 2**64
def opnd(x):
    if x in const: return f"{u64(const[x])}#64"
    return 't'+x[1:]
def ir_expr(d):
    """The compiled value of instruction d over earlier lets `tN` (None if not a let)."""
    r=d['res']; op=d['op']; a=d['args']
    k=kind.get(r)
    if op=='call':
        cal=d['callee']
        if 'load_3' in cal or 'load_4' in cal:
            o=0 if a[0]=='%arg47' else ptr[a[0]]
            return f"load{'3' if 'load_3' in cal else '4'} x {o}"
        return f"{opnd(a[0])} <<< 21"
    if op=='add': return f"{opnd(a[0])} + {opnd(a[1])}"
    if op=='sub': return f"{opnd(a[0])} - {opnd(a[1])}"
    if op=='mul': return f"{opnd(a[0])} * {opnd(a[1])}"
    if op=='and': return f"{opnd(a[0])} &&& {opnd(a[1])}"
    if op=='or': return f"{opnd(a[0])} ||| {opnd(a[1])}"
    if op=='lshr': return f"{opnd(a[0])} >>> {const[a[1]]}"
    if op=='shl': return f"{opnd(a[0])} <<< {const[a[1]]}"
    if op=='ashr': return f"{opnd(a[0])}.sshiftRight {const[a[1]]}"
    if op=='trunc':
        w=int(d['ty'][1:]); return f"{opnd(a[0])}.setWidth {w}"
    return None

BYTEOPS=('trunc','shl','or')
def is_byte(r):
    d=defs_by_res.get(r)
    return d is not None and (d['op'] in BYTEOPS or kind.get(r)=='byteop')
defs_by_res={d['res']:d for d in ins if d['res']}
def inline(x):
    if x in const: return f"{u64(const[x])}#64"
    if is_byte(x):
        d=defs_by_res[x]; op=d['op']; a=d['args']
        if op=='trunc': return f"({inline(a[0])}).setWidth {int(d['ty'][1:])}"
        if op=='shl': return f"({inline(a[0])} <<< {const[a[1]]})"
        if op=='or': return f"({inline(a[0])} ||| {inline(a[1])})"
        if op=='lshr': return f"({inline(a[0])} >>> {const[a[1]]})"
    return 't'+x[1:]
def stored():
    return [d['args'][0] for d in ins if d['op']=='store']
def ir_lets():
    out=[]
    for d in ins:
        r=d['res']
        if r is None or d['op'] in ('mlir.constant','getelementptr','func') or is_byte(r): continue
        e=ir_expr(d)
        if e is None: continue
        out.append(('t'+r[1:],e))
    return out
def ir_text():
    lines=[f"  let {n} := {e}" for n,e in ir_lets()]
    vs=[inline(v) for v in stored()]
    acc=vs[0]
    for v in vs[1:]: acc=f"{v} ++ ({acc})" if acc!=vs[0] else f"{v} ++ {acc}"
    lines.append("  "+acc)
    return "\n".join(lines)

ATOMK=('limb','limbnomask','carry')
clet={n:(e,k,inf) for n,e,k,inf in c.lets}
corder=[n for n,_,_,_ in c.lets]
def cdeps(n):
    e=clet[n][0]
    return [m for m in re.findall(r'\b(?:s|carry)\d+(?:_\d+)?\b',e) if m in clet]
def regs_of(d): return [a for a in d['args'] if a.startswith('%') and a not in const and a!='%arg47']
def lshr_carry(r): return kind.get(r)=='carry' and info[r][1]=='lshr'
def cclos(r):
    seen=[];atoms=[]
    def go(x,top):
        if x in seen or x in atoms: return
        if not top and kind.get(x) in ATOMK: atoms.append(x); return
        seen.append(x)
        for y in regs_of(defs_by_res[x]): go(y,False)
    go(r,True)
    return [x for x in [d['res'] for d in ins] if x in seen], atoms
def Cclos(n):
    seen=set();atoms=set()
    def go(m,top):
        if m in seen or m in atoms: return
        k=clet[m][1]
        if not top and k in ('load','carryr','carryf'): atoms.add(m); return
        seen.add(m)
        for y in cdeps(m): go(y,False)
    go(n,True)
    return [m for m in corder if m in seen],[m for m in corder if m in atoms]
def cname(r):  # C atom name of a compiled atom
    return info[r][0] if kind[r]=='carry' else info[r]
def tn(r): return 't'+r[1:]
def ir_def(r):
    d=defs_by_res[r]
    if lshr_carry(r): return f"{opnd(d['args'][0])}.sshiftRight 21"
    return ir_expr(d)
def bridge(r, target, carry):
    cv,ca=cclos(r); Cv,Ca=Cclos(target)
    vars_=[tn(x) for x in cv]+[tn(x) for x in ca]
    cvars=Cv+[m for m in Ca if m not in Cv]
    for a in ca:
        if cname(a) not in cvars: cvars.append(cname(a))
    hyps=[f"(h{tn(x)} : {tn(x)} = {ir_def(x)})" for x in cv]
    hyps+=[f"(e{tn(a)} : {tn(a)} = {cname(a)})" for a in ca]
    hyps+=[f"(h{m} : {m} = {clet[m][0]})" for m in Cv]
    allv=vars_+cvars
    name=f"x25519_sc_reduce.bridge_{target}"
    stmt=f"/-- `{target}` as the C computes it is the compiled `%{r[1:]}`. -/\ntheorem {name} ({' '.join(allv)} : BitVec 64)\n    "+"\n    ".join(hyps)+f" :\n    {tn(r)} = {target} := by\n  subst_vars\n"+("  refine congrArg (BitVec.sshiftRight · 21) ?_\n" if carry else "")+"  grind\n"
    args=[]
    for x in cv:
        args.append(f"n{x[1:]}" if lshr_carry(x) else "rfl")
    args+=[f"e{x[1:]}" for x in ca]
    args+=["rfl" for m in Cv]
    use=f"  have e{r[1:]} := {name} {' '.join(allv)} {' '.join(args)}"
    return stmt,use
def expand(x):
    if x in const: return f"{u64(const[x])}#64"
    d=defs_by_res[x]; e=ir_expr(d)
    def rep(m):
        y='%'+m.group(1)
        return '('+expand(y)+')' if y in defs_by_res else m.group(0)
    return re.sub(r'\bt(\d+)\b',rep,e)
