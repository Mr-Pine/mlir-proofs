import re
P='/home/david.intern/rir-firedancer-zig/Zig/Mlir/Sha512_round.lean'
lines=open(P).read().split('\n')
start=[i for i,l in enumerate(lines) if l.strip().startswith('^bb5')][0]
end=[i for i,l in enumerate(lines) if l.strip().startswith('^bb6')][0]
consts={}
for l in lines:
    m=re.search(r'%(\d+) = "llvm.mlir.constant"\(\) <\{value = (-?\d+) : i(\d+)\}>',l)
    if m: consts[int(m.group(1))]=(int(m.group(2))%(1<<int(m.group(3))),int(m.group(3)))
ops=[]
for l in lines[start+1:end]:
    m=re.match(r'\s*(?:%(\d+) = )?"llvm\.(\S+?)"\(([^)]*)\)(.*)',l)
    if not m: continue
    k=int(m.group(1)) if m.group(1) else None
    args=[int(x) for x in re.findall(r'%(\d+)',m.group(3))]
    ops.append((k,m.group(2),args))
init=[142,144,146,148,150,152,154,156]
state=list(init)
bounds=[]   # (pos, state regs, Kreg) for round t
idx=16
Kregs=[]
for t in range(80):
    n=25 if t==0 else 26
    rops=ops[idx:idx+n]
    adds=[(k,a) for (k,op,a) in rops if op=='add']
    # K reg: const arg >100 value among adds
    kr=[x for (k,a) in adds for x in a if x in consts and consts[x][0]>100]
    assert len(kr)==1, (t,kr)
    bounds.append((idx,list(state),kr[0]))
    Kregs.append(kr[0])
    t1,e1,a1=adds[3][0],adds[4][0],adds[6][0]
    state=[a1]+state[:3]+[e1]+state[4:7]
    idx+=n
bounds.append((idx,list(state),None))
ROT=[15,16,17,19,20,21]
MISC=[1,4,22]
def live(t):
    return ROT+Kregs[t:]+MISC
if __name__=='__main__':
    for t in [0,1,4,79,80]: print(t,bounds[t][0],bounds[t][1],bounds[t][2])
    print(Kregs[:5])
    print(len(ops), idx)
