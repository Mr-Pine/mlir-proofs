"""The C of x25519_sc_reduce as a list of let-statements with linear forms."""
import re,os
SRC=os.path.join(os.path.dirname(os.path.abspath(__file__)),'screduce.c')
M21=2097151
def lin_add(a,b,k=1):
    r=dict(a)
    for x,c in b.items():
        r[x]=r.get(x,0)+k*c
        if r[x]==0: del r[x]
    return r
def lin_scale(a,k):
    return {x:c*k for x,c in a.items()} if k else {}
class C:
    def __init__(s):
        s.lets=[]   # (name, leanexpr, kind, info)
        s.cur={}    # C var -> current let name
        s.form={}   # let name -> linear form (dict, key 1 = constant)
        s.count={}
        s.bytes=[]
    def fresh(s,v):
        n=s.count.get(v,-1)+1; s.count[v]=n
        return v if n==0 else f"{v}_{n}"
def parse():
    c=C()
    for line in open(SRC):
        l=line.strip()
        m=re.match(r'int64_t (s\d+) = 2097151 & load_([34])\(s(?: \+ (\d+))?\);',l)
        if m:
            v,w,o=m.group(1),m.group(2),int(m.group(3) or 0)
            n=c.fresh(v); c.cur[v]=n
            c.lets.append((n,f"2097151#64 &&& load{w} x {o}",'load',(w,o,0)))
            c.form[n]={('L',n):1}; continue
        m=re.match(r'int64_t (s\d+) = 2097151 & \(load_([34])\(s \+ (\d+)\) >> (\d+)\);',l)
        if m:
            v,w,o,sh=m.group(1),m.group(2),int(m.group(3)),int(m.group(4))
            n=c.fresh(v); c.cur[v]=n
            c.lets.append((n,f"2097151#64 &&& load{w} x {o} >>> {sh}",'load',(w,o,sh)))
            c.form[n]={('L',n):1}; continue
        m=re.match(r'int64_t (s\d+) = \(load_([34])\(s \+ (\d+)\) >> (\d+)\);',l)
        if m:
            v,w,o,sh=m.group(1),m.group(2),int(m.group(3)),int(m.group(4))
            n=c.fresh(v); c.cur[v]=n
            c.lets.append((n,f"load{w} x {o} >>> {sh}",'load',(w,o,sh,'nomask')))
            c.form[n]={('L',n):1}; continue
        m=re.match(r'(s\d+) ([+-])= (s\d+) \* (\d+);',l)
        if m:
            a,op,b,k=m.group(1),m.group(2),m.group(3),int(m.group(4))
            pa,pb=c.cur[a],c.cur[b]; n=c.fresh(a); c.cur[a]=n
            sgn='+' if op=='+' else '-'
            c.lets.append((n,f"{pa} {sgn} {pb} * {k}#64",'row',(pa,pb,k,op)))
            c.form[n]=lin_add(c.form[pa],c.form[pb],k if op=='+' else -k); continue
        m=re.match(r'(s\d+) = 0;',l)
        if m:
            a=m.group(1)
            if a=='s12':
                n=c.fresh(a); c.cur[a]=n
                c.lets.append((n,"0#64",'zero',None)); c.form[n]={}
            else:
                c.cur[a]=None
            continue
        m=re.match(r'(carry\d+) = \((s\d+) \+ \(1 << 20\)\) >> 21;',l)
        if m:
            a,b=m.group(1),m.group(2); pb=c.cur[b]; n=c.fresh(a); c.cur[a]=n
            c.lets.append((n,f"({pb} + 1048576#64).sshiftRight 21",'carryr',pb))
            c.form[n]={('K',n):1}; continue
        m=re.match(r'(carry\d+) = (s\d+) >> 21;',l)
        if m:
            a,b=m.group(1),m.group(2); pb=c.cur[b]; n=c.fresh(a); c.cur[a]=n
            c.lets.append((n,f"{pb}.sshiftRight 21",'carryf',pb))
            c.form[n]={('K',n):1}; continue
        m=re.match(r'(s\d+) \+= (carry\d+);',l)
        if m:
            a,b=m.group(1),m.group(2); pa,pb=c.cur[a],c.cur[b]; n=c.fresh(a); c.cur[a]=n
            c.lets.append((n,f"{pa} + {pb}",'addc',(pa,pb)))
            c.form[n]=lin_add(c.form[pa],c.form[pb]); continue
        m=re.match(r'(s\d+) -= int64_lshift21\((carry\d+)\);',l)
        if m:
            a,b=m.group(1),m.group(2); pa,pb=c.cur[a],c.cur[b]; n=c.fresh(a); c.cur[a]=n
            c.lets.append((n,f"{pa} - {pb} <<< 21",'subc',(pa,pb)))
            c.form[n]=lin_add(c.form[pa],c.form[pb],-2**21); continue
        m=re.match(r's\[(\d+)\] = (.*);',l)
        if m:
            i=int(m.group(1)); e=m.group(2)
            def term(t):
                t=t.strip().strip('()')
                mm=re.match(r'(s\d+) >> (\d+)$',t)
                if mm:
                    v,k=mm.group(1),int(mm.group(2))
                    return c.cur[v] if k==0 else f"{c.cur[v]}.sshiftRight {k}"
                mm=re.match(r'(s\d+) << (\d+)$',t)
                if mm: return f"{c.cur[mm.group(1)]} <<< {mm.group(2)}"
                raise Exception(t)
            parts=[term(t) for t in re.split(r'\|',e)]
            ex=' ||| '.join(parts)
            c.bytes.append((i,f"({ex}).setWidth 8" if len(parts)>1 else f"{parts[0]}.setWidth 8" if '.' not in parts[0] else f"({parts[0]}).setWidth 8"))
            continue
        if l.startswith('int64_t carry') or l.startswith('//') or not l or l in('}',) or l.startswith('void'): continue
        raise Exception('unparsed: '+l)
    used=set()
    texts=[e for _,e,_,_ in c.lets]+[e for _,e in c.bytes]
    for t in texts: used|=set(re.findall(r'\b(?:s|carry)\d+(?:_\d+)?\b',t))
    c.lets=[l for l in c.lets if l[0] in used or l[2]!='zero']
    return c
if __name__=='__main__':
    c=parse()
    print(len(c.lets),'lets'); 
    for x in c.lets[:30]: print(x[:2])
    print(c.bytes[:5])
    print({k:c.cur[k] for k in sorted(c.cur)})
