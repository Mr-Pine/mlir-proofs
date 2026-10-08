import re,sys
lines=open(sys.argv[1]).read().split('\n')
# find bb5 range
start=[i for i,l in enumerate(lines) if l.strip().startswith('^bb5')][0]
end=[i for i,l in enumerate(lines) if l.strip().startswith('^bb6')][0]
consts={}
for l in lines:
    m=re.search(r'%(\d+) = "llvm.mlir.constant"\(\) <\{value = (-?\d+) : i(\d+)\}>',l)
    if m: consts[int(m.group(1))]=int(m.group(2))%(1<<int(m.group(3)))
sym={}
# state loads
names={142:'A',144:'B',146:'C',148:'D',150:'E',152:'F',154:'G',156:'H'}
expr={}
def show(k):
    if k in names: return names[k]
    if k in consts: return 'c%d'%k
    return expr.get(k,'%%%d'%k)
ops=[]
for l in lines[start+1:end]:
    m=re.match(r'\s*%(\d+) = "llvm\.(\S+?)"\(([^)]*)\)',l)
    if not m:
        ops.append(('other',l.strip()[:60])); continue
    k=int(m.group(1)); op=m.group(2); args=[int(x) for x in re.findall(r'%(\d+)',m.group(3))]
    ops.append((k,op,args,l))
# print kinds count
from collections import Counter
print(Counter(o[1] for o in ops if o[0]!='other'))
print(len(ops))
