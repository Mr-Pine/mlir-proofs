import re,sys
for line in open(sys.argv[1]):
    l=line.strip()
    m=re.match(r'(%\d+ = )?"llvm\.([a-z_.]+)"\(([^)]*)\)(.*)',l)
    if not m:
        if l.startswith('^') : print(l)
        continue
    res,op,args,rest=m.groups()
    extra=''
    v=re.search(r'value = (-?\d+)',rest)
    if v: extra=v.group(1)
    c=re.search(r'callee = @(\w+)',rest)
    if c: extra=c.group(1)
    g=re.search(r'rawConstantIndices = array<i32: (\d+)>',rest)
    if g: extra='+'+g.group(1)
    f=re.search(r'overflowFlags = (\d)',rest)
    if f: extra+=' fl'+f.group(1)
    p=re.search(r'predicate = (\d+)',rest)
    if p: extra+=' pred'+p.group(1)
    t=re.search(r':\s*\(([^)]*)\)\s*->\s*(\S+)\s*$',rest)
    ty=t.group(2) if t else ''
    print(f"{res or ''}{op}({args}) {extra} :{ty}")
