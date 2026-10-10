import sys
sys.path.insert(0,'/tmp/w1c')
from ir import parse
ins=parse('/home/david.intern/mlir-proofs/Boringssl/Mlir/x25519_sc_reduce.lean')
LO,HI=-2**63,2**63-1
const={}; iv={}; defs={}
def fl(a,b): return a//b
bad=[]
for d in ins:
    r=d['res']; op=d['op']; a=d['args']
    if op=='mlir.constant': const[r]=d['value']; iv[r]=(d['value'],d['value']); continue
    defs[r]=d
    def I(x): return iv[x]
    if op=='call':
        if 'load_3' in d['callee']: iv[r]=(0,2**24-1)
        elif 'load_4' in d['callee']: iv[r]=(0,2**32-1)
        else:
            lo,hi=I(a[0])
            if lo< -2**42 or hi>=2**42: bad.append((r,'lshift arg',lo,hi))
            iv[r]=(lo*2**21,hi*2**21)
        continue
    if op=='getelementptr': continue
    if op in('store','return','trunc','or','shl'): 
        continue
    if op=='and':
        k=const[a[1]]; iv[r]=(0,k); continue
    if op in('lshr','ashr'):
        k=const[a[1]]; lo,hi=I(a[0])
        if op=='lshr' and lo<0: bad.append((r,'lshr neg',lo,hi)); iv[r]=(0,(2**64-1)>>k)
        else: iv[r]=(fl(lo,2**k),fl(hi,2**k))
        continue
    if op=='mul':
        x,c=a; k=const[c]; lo,hi=I(x); vals=[lo*k,hi*k]; iv[r]=(min(vals),max(vals))
    elif op=='add':
        (l1,h1),(l2,h2)=I(a[0]),I(a[1]); iv[r]=(l1+l2,h1+h2)
    elif op=='sub':
        x,y=a
        # residual: y = lshift21(c), c = shift(x + 2^20) or shift(x)
        dy=defs.get(y)
        res=None
        if dy and dy['op']=='call' and 'lshift21' in dy.get('callee',''):
            c=dy['args'][0]; dc=defs[c]
            src=dc['args'][0]; ds=defs.get(src)
            if src==x: res=(0,2**21-1)
            elif ds and ds['op']=='add' and ds['args'][0]==x and const.get(ds['args'][1])==2**20: res=(-2**20,2**20-1)
        if False: iv[r]=res
        else:
            (l1,h1),(l2,h2)=I(x),I(y); iv[r]=(l1-h2,h1-l2)
    else:
        print('??',op); continue
    lo,hi=iv[r]
    if d['flags']&1 and (lo<LO or hi>HI): bad.append((r,op,'nsw',lo,hi))
    if d['flags']&2 and (lo<0 or hi>2**64-1): bad.append((r,op,'nuw',lo,hi))
for b in bad: print(b)
print(len(bad),'bad')
import math
mx=max(max(abs(l),abs(h)) for l,h in iv.values())
print('max log2',math.log2(mx))
