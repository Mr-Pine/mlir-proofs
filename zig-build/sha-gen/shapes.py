import re,sys
lines=open(sys.argv[1]).read().split('\n')
start=[i for i,l in enumerate(lines) if l.strip().startswith('^bb5')][0]
end=[i for i,l in enumerate(lines) if l.strip().startswith('^bb6')][0]
consts={}
for l in lines:
    m=re.search(r'%(\d+) = "llvm.mlir.constant"\(\) <\{value = (-?\d+) : i(\d+)\}>',l)
    if m: consts[int(m.group(1))]=int(m.group(2))%(1<<int(m.group(3)))
ops=[]
for l in lines[start+1:end]:
    m=re.match(r'\s*(?:%(\d+) = )?"llvm\.(\S+?)"\(([^)]*)\)(.*)',l)
    if not m: continue
    k=int(m.group(1)) if m.group(1) else None
    args=[int(x) for x in re.findall(r'%(\d+)',m.group(3))]
    ops.append((k,m.group(2),args,m.group(4)))
# initial state regs
init=[142,144,146,148,150,152,154,156]
state=list(init)  # registers of a..h
val={}
idx=16
shapes={}
for t in range(80):
    n = 25 if t==0 else 26
    rops=ops[idx:idx+n]; idx+=n
    roles={state[i]:"abcdefgh"[i] for i in range(8)}
    expr={}
    def S(r):
        if r in roles: return roles[r]
        if r in expr: return expr[r]
        if r in consts: return 'K' if consts[r]>100 else str(consts[r])
        return '?%d'%r
    loadreg=None
    for (k,op,args,rest) in rops:
        if op=='load': expr[k]='w'; continue
        if op=='getelementptr': expr[k]='ptr'; continue
        if op=='intr.fshl': expr[k]=f"rot({S(args[0])},{S(args[2])})"; continue
        expr[k]=f"({S(args[0])} {op} {S(args[1])})"
    # T1 = 4th add among first adds, e' 5th, a' last
    adds=[k for (k,op,a,r) in rops if op=='add']
    t1,e1,a1=adds[3],adds[4],adds[6]
    key=(expr[t1],expr[e1].replace(expr[t1],'T1'),expr[a1].replace(expr[t1],'T1'))
    shapes.setdefault(key,[]).append(t)
    newstate=[a1]+state[:3]+[e1]+state[4:7]
    state=newstate
for k,v in shapes.items():
    print(v)
    for x in k: print('   ',x)
print(state)
