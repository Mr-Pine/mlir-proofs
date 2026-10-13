import sys,os
HERE=os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0,HERE)
from ir import parse
from cmodel import parse as cparse, lin_add, lin_scale
LIFT=os.path.join(HERE,'..','..','Boringssl/Mlir/x25519_sc_reduce.lean')
def key(f): return tuple(sorted((str(k),v) for k,v in f.items()))
def model():
    c=cparse()
    ins=parse(LIFT)
    const={}; ptr={}; form={}; kind={}; info={}
    cload={}  # (w,o,sh) -> C name
    for n,e,k,inf in c.lets:
        if k=='load': cload[(inf[0],inf[1],inf[2])]=n
    ccarry={}  # operand form key -> C carry name
    for n,e,k,inf in c.lets:
        if k=='carryr': ccarry[key(lin_add(c.form[inf],{1:2**20}))]=n
        if k=='carryf': ccarry[key(c.form[inf])]=n
    cform={}  # form key -> C let names
    for n,e,k,inf in c.lets:
        cform.setdefault(key(c.form[n]),[]).append(n)
    rawload={}
    for d in ins:
        r=d['res']; op=d['op']; a=d['args']
        if op=='func': continue
        def F(x):
            if x in form: return form[x]
            if x in const: return {1:const[x]}
            if x in rawload:
                nm=cload[rawload[x]]; form[x]={('L',nm):1}; kind[x]='limbnomask'; info[x]=nm; return form[x]
            raise Exception('noform '+x)
        if op=='mlir.constant': const[r]=d['value']; continue
        if op=='getelementptr':
            ptr[r]=d['gep'] if a[0]=='%arg47' else None; continue
        if op=='call':
            cal=d['callee']
            if 'load_3' in cal or 'load_4' in cal:
                o=0 if a[0]=='%arg47' else ptr[a[0]]
                rawload[r]=('3' if 'load_3' in cal else '4',o,0); kind[r]='loadcall'; continue
            # lshift21
            form[r]=lin_scale(form[a[0]],2**21); kind[r]='shl21'; info[r]=a[0]; continue
        if op in ('lshr','ashr') and a[0] in rawload:
            w,o,_=rawload[a[0]]; rawload[r]=(w,o,const[a[1]]); kind[r]='loadshift'
            if (w,o,const[a[1]]) in cload and op=='lshr':
                # unmasked use? only s7/s15/s23 style
                pass
            continue
        if op=='and' and a[0] in rawload and const.get(a[1])==2097151:
            nm=cload[rawload[a[0]]]; form[r]={('L',nm):1}; kind[r]='limb'; info[r]=nm; continue
        if op in ('add','sub','mul') :
            if op=='mul':
                x=a[0]; k=const[a[1]]
                if k>=2**63: k-=2**64
                form[r]=lin_scale(F(x),k); kind[r]='mul'; continue
            fx=F(a[0]); fy=F(a[1])
            form[r]=lin_add(fx,fy,1 if op=='add' else -1); kind[r]=op; continue
        if op in ('lshr','ashr'):
            if const[a[1]]!=21: kind[r]='byteop'; continue
            k=key(form[a[0]])
            nm=ccarry[k]; form[r]={('K',nm):1}; kind[r]='carry'; info[r]=(nm,op); continue
        if op in ('trunc','shl','or','store','return'): kind[r]=op; continue
        raise Exception(op)
    names={}
    for r,f in form.items():
        k=key(f)
        if k in cform: names[r]=cform[k]
    return c,ins,const,form,kind,info,names,rawload,ptr
if __name__=='__main__':
    c,ins,const,form,kind,info,names,rawload,ptr=model()
    n=0
    for d in ins:
        r=d['res']
        if r in kind and kind[r] not in('loadcall','loadshift','trunc','shl','or'):
            print(r,kind[r],names.get(r),info.get(r) if kind[r]=='carry' else '')
