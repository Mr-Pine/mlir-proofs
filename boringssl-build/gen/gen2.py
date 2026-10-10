import sys,re
sys.path.insert(0,'/tmp/w1c')
from gen import *   # c, ins, const, form, kind, info, names, rawload, ptr, disp, ir_expr, ...
LO,HI=-2**63,2**63-1
body=[d for d in ins if d['op']!='func']   # body positions; the return is the exit
assert body[-1]['op']=='return'; body=body[:-1]
pos={d['res']:i for i,d in enumerate(body) if d['res']}
def dn(x):  # display operand
    if x in const: return f"{u64(const[x])}#64"
    return disp.get(x) or x
# rendered step expression (over display names) for value registers
def rexpr(d):
    r=d['res']; op=d['op']; a=d['args']
    if op=='call':
        cal=d['callee']
        if 'load' in cal:
            o=0 if a[0]=='%arg47' else ptr[a[0]]
            return f"load{'3' if 'load_3' in cal else '4'} (S.mem.readAt p 512) {o}"
        return f"{dn(a[0])} <<< 21"
    m={'add':'+','sub':'-','mul':'*','and':'&&&','or':'|||'}
    if op in m: return f"{dn(a[0])} {m[op]} {dn(a[1])}"
    if op=='lshr': return f"{dn(a[0])} >>> {const[a[1]]}"
    if op=='ashr': return f"{dn(a[0])}.sshiftRight {const[a[1]]}"
    raise Exception(op)
isval=lambda d: d['res'] in disp and not is_byte(d['res'])
# --- bounds, as `bnd2` computes them
bnd={}
def lit(v): v=u64(v); return v-2**64 if v>=2**63 else v
def gb(x):
    if x in const: v=lit(const[x]); return (v,v)
    return bnd[x]
def fd_bound(d):
    op=d['op']; a=d['args']
    if op=='lshr':
        n=const[a[1]]; lo,hi=gb(a[0])
        return (lo//2**n,hi//2**n) if lo>=0 else (0,(2**64-1)//2**n)
    if op=='ashr':
        n=const[a[1]]; lo,hi=gb(a[0]); return (lo//2**n,hi//2**n)
    if op=='and':
        k=lit(const[a[1]]); assert k>=0; return (0,k)
    if op=='mul':
        k=lit(const[a[1]]); lo,hi=gb(a[0]); v=[lo*k,hi*k]; r=(min(v),max(v))
    elif op=='add':
        (a1,b1),(c1,d1)=gb(a[0]),gb(a[1]); r=(a1+c1,b1+d1)
    elif op=='sub':
        (a1,b1),(c1,d1)=gb(a[0]),gb(a[1]); r=(a1-d1,b1-c1)
    else: raise Exception(op)
    return r if LO<=r[0] and r[1]<=HI else (LO,HI)
resid_need={}  # reg -> earlier regs whose equations bnd2 reads
for d in body:
    r=d['res']
    if not r or not isval(d): continue
    op=d['op']; a=d['args']
    if op=='call':
        if 'load_3' in d['callee']: bnd[r]=(0,2**24-1)
        elif 'load_4' in d['callee']: bnd[r]=(0,2**32-1)
        else:
            lo,hi=gb(a[0]); r2=(lo*2**21,hi*2**21)
            bnd[r]=r2 if LO<=r2[0] and r2[1]<=HI else (LO,HI)
        continue
    if op=='sub':
        y=a[1]; dy=defs_by_res.get(y)
        if dy and dy['op']=='call' and 'lshift21' in dy['callee']:
            cc=dy['args'][0]; dcc=defs_by_res[cc]; s=dcc['args'][0]
            if s==a[0] and dcc['op']=='ashr':
                bnd[r]=(0,2097151); resid_need[r]=[y,cc]; continue
            ds=defs_by_res.get(s)
            if ds and ds['op']=='add' and ds['args'][0]==a[0] and const.get(ds['args'][1])==2**20:
                bnd[r]=(-2**20,2**20-1); resid_need[r]=[y,cc,s]; continue
    bnd[r]=fd_bound(d)
# flags check
for d in body:
    r=d['res']
    if r in bnd and d['flags']&1:
        lo,hi=bnd[r]; assert LO<=lo and hi<=HI,(r,lo,hi)
def uses(d): return [x for x in d['args'] if x.startswith('%') and x not in const and x!='%arg47']

GAM='x25519_sc_reduce.Γ'
consts=[d for d in body if d['op']=='mlir.constant']
def consts_abbrev():
    items=', '.join(f"{d['res']} := {u64(d['value'])}#64" for d in consts)
    return f"/-- The constants the code reads after its first instructions. -/\nabbrev x25519_sc_reduce.Consts (E : ⟪{GAM}⟫) : Prop :=\n  E ⊨ [{items}]\n"
def is_ptr(x): return defs_by_res.get(x,{}).get('op')=='getelementptr'
def pval(x): return f"p.add {ptr[x]}#64"
def walk_lines(d):
    """the walk steps of one instruction (as in walk_text)"""
    r=d['res']; op=d['op']; a=d['args']
    simp={'add':('nswAdd','nuwAdd'),'mul':('nswMul','nuwMul'),'sub':('nswSub',None)}
    if op in ('mlir.constant','getelementptr'): return ['step_pure']
    if op=='call':
        cal=d['callee']; nm=disp[r]
        if 'load_3' in cal:
            o=0 if a[0]=='%arg47' else ptr[a[0]]
            prf='BitVec.not_uaddOverflow_of_le hp_off (by decide)' if o==0 else f'off3 hp_off {o} (by decide)'
            l=f'step_call using (load_3.call_eq (hp_off := {prf})) with {nm}'
        elif 'load_4' in cal: l=f'step_call using load_4.call_eq with {nm}'
        else: l=f'step_call using (int64_lshift21.call_eq _ _ _ (Bounds.lshift21_arg hb{disp[a[0]]} (by decide))) with {nm}'
        return [l,f'bnd_ext {nm}']
    if is_byte(r) if r else False: return ['step_pure']
    if op=='store': return ['step_store']
    nm=disp[r]; args=[]
    if op in simp:
        f=d['flags']
        if f&1: args.append(simp[op][0])
        if f&2 and simp[op][1]: args.append(simp[op][1])
    sa=(' ['+', '.join(args)+']') if args else ''
    return [f'step_pure{sa} with {nm}',f'bnd_ext {nm}']
def bstr(b): return f"({b})" if b<0 else str(b)
def needeq_of(P,Q):
    seg=body[P:Q]
    defined=[d['res'] for d in seg if d['res'] and isval(d)]
    ne=[]
    for x in defined:
        for y in resid_need.get(x,[]):
            if pos[y]<P and y not in ne: ne.append(y)
    return sorted(ne,key=lambda x:pos[x])
def main_line(P,Q):
    ne=needeq_of(P,Q)
    if not ne: return f"  step_pattern using x25519_sc_reduce.run{P}"
    a=" ".join(f"(h{disp[y]} := h{disp[y]}.symm)" for y in ne)
    return f"  step_pattern using (x25519_sc_reduce.run{P} {a})"
def later_uses_all(Q):
    u=set()
    for d in body[Q:]: u|=set(uses(d))
    return u
def run_lemma(P,Q,last):
    seg=body[P:Q]
    defined=[d['res'] for d in seg if d['res'] and isval(d)]
    later_uses=set()
    for d in body[Q:]: later_uses|=set(uses(d))
    inuse=[]
    for d in seg:
        for x in uses(d):
            if pos.get(x,10**9)<P and x not in inuse: inuse.append(x)
    for x in later_uses_all(Q):
        if pos.get(x,10**9)<P and x not in inuse: inuse.append(x)
    inuse.sort(key=lambda x:pos[x])
    used_here=set()
    for d in seg:
        r=d['res']; op=d['op']
        if op in ('store','trunc','shl','or') or (r and is_byte(r)): continue
        if op=='and': continue
        if op=='call' and 'load' in d.get('callee',''): continue
        if r in resid_need and not d['flags']: continue
        used_here|=set(uses(d))
    livein_vals=[x for x in inuse if not is_ptr(x)]
    livein_ptrs=[x for x in inuse if is_ptr(x)]
    # equations bnd2 reads from earlier runs
    needeq=[]
    for x in defined:
        for y in resid_need.get(x,[]):
            if pos[y]<P and y not in needeq: needeq.append(y)
    needeq.sort(key=lambda x:pos[x])
    liveout=sorted([x for x in later_uses if pos.get(x,10**9)<Q],key=lambda x:pos[x])
    # needeq of later runs that are defined here must be passed with equations (they are: all defined)
    has_call=any(d['op']=='call' for d in seg)
    has_load=any(d['op']=='call' and 'load' in d['callee'] for d in seg)
    nm=f"x25519_sc_reduce.run{P}"
    L=[f"/-- `^bb0` from instruction {P} to {Q}: its values named, with their forms and bounds. -/"]
    if last:
        L=["-- 24 stores, merged into one at the end: past the default budget",
           "set_option maxHeartbeats 1000000 in"]+L
    L.append(f"theorem {nm} {{β : Type}} {{p : Pointer}}")
    L.append(f"    {{blk : BasicBlock {GAM} [] x25519_sc_reduce.blockTys}}")
    L.append(f"    (hbody : blk.body.drop {P} = x25519_sc_reduce.entry.body.drop {P})")
    L.append(f"    {{E : ⟪{GAM}⟫}} {{S : GlobalState}}")
    L.append(f"    {{g : ⟪{GAM}⟫ × GlobalState → PoisonOr β}} {{K : PoisonOr β}}")
    iv=[disp[x] for x in livein_vals]+[disp[x] for x in needeq if x not in livein_vals]
    if iv: L.append(f"    {{{' '.join(iv)} : BitVec 64}}")
    L.append(f"    (hArgs : E.args = (x25519_sc_reduce.args (.value p)).get)")
    if has_call: L.append("    (hwf : S.WF)")
    if has_load: L.append("    (hp : Fits S.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64)")
    if last: L.append("    (hp : Fits S.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64)")
    if P>0: L.append("    (hc : x25519_sc_reduce.Consts E)")
    rd=[f"{x} := {disp[x]}" for x in livein_vals]+[f"{x} := {pval(x)}" for x in livein_ptrs]
    if rd: L.append(f"    (hR : E ⊨ [{', '.join(rd)}])")
    for y in needeq:
        L.append(f"    (h{disp[y]} : {rexpr(defs_by_res[y])} = {disp[y]})")
    for x in livein_vals:
        if x not in used_here: continue
        lo,hi=bnd[x]; L.append(f"    (hb{disp[x]} : Bnd {disp[x]} {bstr(lo)} {bstr(hi)})")
    # continuation
    outv=[disp[x] for x in defined]
    K=[]
    K.append(f"    (hK : ∀ (E' : ⟪{GAM}⟫)" + (f" ({' '.join(outv)} : BitVec 64)" if outv else "") + ",")
    K.append(f"      (hArgs : E'.args = (x25519_sc_reduce.args (.value p)).get) →")
    K.append(f"      (hc : x25519_sc_reduce.Consts E') →")
    ro=[f"{x} := {disp[x]}" for x in liveout if not is_ptr(x)]+[f"{x} := {pval(x)}" for x in liveout if is_ptr(x)]
    if ro: K.append(f"      (hR : E' ⊨ [{', '.join(ro)}]) →")
    for x in defined:
        K.append(f"      (h{disp[x]} : {disp[x]} = {rexpr(defs_by_res[x])}) →")
    bout=[x for x in defined if x in later_uses]
    for x in bout:
        lo,hi=bnd[x]; K.append(f"      (hb{disp[x]} : Bnd {disp[x]} {bstr(lo)} {bstr(hi)}) →")
    if last:
        st="S.mem"
        for d in seg:
            if d['op']=='store':
                v=inline_disp(d['args'][0]); pp='p' if d['args'][1]=='%arg47' else f"(p.add {ptr[d['args'][1]]}#64)"
                st=f"({st}.storeAt {pp} ({v}))"
        K.append(f"      (blk.runBodyFrom E' {Q} {{ S with mem := S.mem.storeAt p (x25519_sc_reduce.out {' '.join(disp[r] for r in FINAL)}) }} >>= g) = K) :")
    else:
        K.append(f"      (blk.runBodyFrom E' {Q} S >>= g) = K) :")
    L+=K
    L.append(f"    (blk.runBodyFrom E {P} S >>= g) = K := by")
    for d in seg:
        for l in walk_lines(d): L.append("  "+l)
    if has_call or last: L.append("  subst hS")
    if last:
        L.append("  rw [" + ",\n    ".join(merge_rws()) + "]")
    # apply continuation
    args=["_"]+outv+["hArgs"]
    args.append("(by unfold x25519_sc_reduce.Consts; env_reads)" if P==0 else "(by unfold x25519_sc_reduce.Consts; env_reads)")
    if ro: args.append("(by env_reads)")
    for x in defined:
        d=defs_by_res[x]
        if d['op']=='call' and 'load' in d['callee']:
            o=0 if d['args'][0]=='%arg47' else ptr[d['args'][0]]
            w='3' if 'load_3' in d['callee'] else '4'
            if o==0: args.append(f"(h{disp[x]}.trans (setWidth_load{w} _))")
            else: args.append(f"h{disp[x]}")
        else: args.append(f"h{disp[x]}")
    for x in bout: args.append(f"hb{disp[x]}")
    L.append("  exact hK "+" ".join(args))
    return "\n".join(L)
def inline_disp(x):
    if x in const: return f"{u64(const[x])}#64"
    if is_byte(x):
        d=defs_by_res[x]; op=d['op']; a=d['args']
        if op=='trunc':
            w=int(d['ty'][1:]); dx=defs_by_res.get(a[0])
            if dx and dx['op']=='or':
                s1,s2=[defs_by_res[y] for y in dx['args']]
                assert s1['op']=='shl' and s2['op']=='lshr'
                return (f"BitVec.setWidth {w} {inline_disp(s1['args'][0])} <<< {const[s1['args'][1]]} ||| "
                        f"BitVec.setWidth {w} ({inline_disp(s2['args'][0])} >>> {const[s2['args'][1]]})")
            return f"BitVec.setWidth {w} {inline_disp(a[0])}"
        if op=='shl': return f"({inline_disp(a[0])} <<< {const[a[1]]})"
        if op=='or': return f"({inline_disp(a[0])} ||| {inline_disp(a[1])})"
        if op=='lshr': return f"({inline_disp(a[0])} >>> {const[a[1]]})"
    return disp[x]

def main_text(splits):
    L=[]
    for P in splits[:-1]: L.append(f"  step_pattern using x25519_sc_reduce.run{P}")
    return "\n".join(L)
def runs_text(splits):
    out=[]
    for i in range(len(splits)-1):
        P,Q=splits[i],splits[i+1]
        out.append(run_lemma(P,Q,Q==len(body)))
    return "\n\n".join(out)

def store_list(seg):
    out=[]
    for d in seg:
        if d['op']=='store':
            v=d['args'][0]; o=0 if d['args'][1]=='%arg47' else ptr[d['args'][1]]
            w=int(defs_by_res[v]['ty'][1:])
            out.append((o,w,v))
    return out
FINAL=['%976','%980','%984','%988','%992','%996','%1000','%1004','%1008','%1012','%1016','%1014']
def out_def():
    sl=store_list(body)
    vs=[inline_disp(v) for _,_,v in sl]
    acc=f"({vs[0]})"
    for v in vs[1:]: acc=f"({v}) ++ {acc}" if acc.startswith('((') or True else acc
    # build right-nested properly
    acc=f"({vs[0]})"
    for v in vs[1:]: acc=f"({v}) ++ ({acc})"
    args=' '.join(disp[r] for r in FINAL)
    return f"/-- The 32 bytes the code stores, from the final limbs. -/\ndef x25519_sc_reduce.out ({args} : BitVec 64) : BitVec 256 :=\n  {acc}\n"
def merge_rws():
    sl=store_list(body)
    L=[]; acc=sl[0][1]
    for o,w,v in sl[1:]:
        assert acc==8*o,(acc,o)
        L.append(f"MemoryState.storeAt_storeAt_add (a := {acc}) (k := {o}) (BitVec.not_uaddOverflow_of_le hp_off (by decide)) rfl (by decide)")
        acc+=w
    return L

def ir_def_text():
    lines=[f"  let {n} := {e}" for n,e in ir_lets()]
    lines.append("  x25519_sc_reduce.out " + " ".join(tn(r) for r in FINAL))
    return ("/-- The compiled code's computation, one `let` per value, on the 64 bytes `x`. -/\n"
            "def x25519_sc_reduce.ir (x : BitVec 512) : BitVec 256 :=\n" + "\n".join(lines) + "\n")
def bridge_all():
    lemmas=[]; uses_=[]
    # limb atoms
    for d in body:
        r=d['res']
        if kind.get(r)=='limb': uses_.append(f"  have e{r[1:]} : {tn(r)} = {info[r]} := BitVec.and_comm _ _")
        elif kind.get(r)=='limbnomask':
            w=rawload[defs_by_res[r]['args'][0]][0]; sh=const[defs_by_res[r]['args'][1]]
            if info[r]=='s23': uses_.append(f"  have e{r[1:]} : {tn(r)} = {info[r]} := rfl")
            else: uses_.append(f"  have e{r[1:]} : {tn(r)} = {info[r]} := nomask{w}_{sh} _")
    for d in body:
        r=d['res']
        if kind.get(r)=='carry':
            if lshr_carry(r):
                opn=defs_by_res[r]['args'][0]; E=expand(opn)
                lemmas.append(f"theorem x25519_sc_reduce.lshr{r[1:]} (x : BitVec 512) :\n    ({E}) >>> 21 = ({E}).sshiftRight 21 := by\n  unfold load3 load4\n  bv_decide\n")
                uses_.append(f"  have n{r[1:]} : {tn(r)} = {tn(opn)}.sshiftRight 21 := x25519_sc_reduce.lshr{r[1:]} x")
            s,u=bridge(r,info[r][0],True); lemmas.append(s); uses_.append(u)
        elif r in FINAL:
            s,u=bridge(r,names[r][0],False); lemmas.append(s); uses_.append(u)
    return lemmas,uses_
def out_eq_text():
    fin=[disp_c for disp_c in [names[r][0] for r in FINAL]]
    tv=[tn(r) for r in FINAL]
    hyps=" ".join(f"(e{i} : {t} = {s})" for i,(t,s) in enumerate(zip(tv,fin)))
    rhs=" ++ ".join(e for i,e in sorted(c.bytes,key=lambda b:-b[0]))
    return (f"theorem x25519_sc_reduce.out_eq {{{' '.join(tv+fin)} : BitVec 64}} {hyps} :\n"
            f"    x25519_sc_reduce.out {' '.join(tv)} =\n      {rhs} := by\n  subst_vars\n  unfold x25519_sc_reduce.out\n  bv_decide\n")
def ir_eq_spec_text():
    lemmas,uses_=bridge_all()
    irn=[n for n,_ in ir_lets()]
    cn=[n for n,_,_,_ in c.lets]+[f"b{i}" for i,_ in c.bytes]
    t="theorem x25519_sc_reduce.ir_eq_spec (x : BitVec 512) :\n    x25519_sc_reduce.ir x = x25519_sc_reduce.spec x := by\n"
    t+="  unfold x25519_sc_reduce.ir x25519_sc_reduce.spec\n  lift_lets -merge\n"
    t+="  intro "+" ".join(irn+cn)+"\n"
    t+="\n".join(uses_)+"\n"
    t+="  exact x25519_sc_reduce.out_eq "+" ".join(f"e{r[1:]}" for r in FINAL)+"\n"
    return lemmas,t

def spec_eq_text():
    mine=[n for n,_,_,_ in c.lets]
    limbs=mine[:24]; mid=mine[24:]
    bnames=[f"b{i}" for i,_ in c.bytes]
    fd_names=[f"f_in{i}" for i in range(8)]+["f_mask"]+["f_"+n for n in limbs]+["f_"+n for n in mid]+[f"f_out{i}" for i in range(4)]
    t="/-- The same value as Firedancer's `fd_curve25519_scalar_reduce`: the same rows and carries on the\nsame limbs, the 32 bytes as its four packed words. -/\n"
    t+="public theorem x25519_sc_reduce.spec_eq (x : BitVec 512) :\n    x25519_sc_reduce.spec x = MLIR.Firedancer.Ref.fd_curve25519_scalar_reduce.spec x := by\n"
    t+="  unfold x25519_sc_reduce.spec MLIR.Firedancer.Ref.fd_curve25519_scalar_reduce.spec\n  lift_lets -merge\n"
    t+="  intro "+" ".join(mine+bnames+fd_names)+"\n"
    conj=" ∧ ".join(f"{n} = f_{n}" for n in limbs)
    t+=f"  have hL : {conj} := by\n    simp only [{', '.join(limbs)}, load3, load4, {', '.join(fd_names[:9+24])}]\n    bv_decide\n"
    t+="  obtain ⟨"+", ".join(f"e_{n}" for n in limbs)+"⟩ := hL\n"
    for n,e,k,inf in c.lets[24:]:
        deps=[m for m in re.findall(r'\b(?:s|carry)\d+(?:_\d+)?\b',e)]
        deps=list(dict.fromkeys(deps))
        t+=f"  have e_{n} : {n} = f_{n} := by simp only [{n}, f_{n}, {', '.join('e_'+m for m in deps)}]\n" if deps else f"  have e_{n} : {n} = f_{n} := rfl\n"
    fin=[c.cur[f"s{i}"] for i in range(12)]
    # residual source: final s_k (k<=10) := prev - carry <<< 21, carry := prev.sshiftRight 21
    resid=[]
    for k in range(11):
        n=fin[k]; e=clet[n][0]; prev=e.split(' - ')[0]
        resid.append(f"(resid_le {prev})")
    t+="  exact x25519_sc_reduce.bytes_eq_pack "+" ".join(f"e_{n}" for n in fin)+" "+" ".join(resid)+"\n"
    return t
