import re,sys
def parse(path):
    """Instructions of the lift: list of dicts."""
    ins=[]
    for line in open(path):
        l=line.strip()
        m=re.match(r'(?:(%\d+) = )?"llvm\.([a-z_.]+)"\(([^)]*)\)(.*)',l)
        if not m: continue
        res,op,args,rest=m.groups()
        d={'res':res,'op':op,'args':[a.strip() for a in args.split(',') if a.strip()]}
        v=re.search(r'value = (-?\d+) : (i\d+)',rest)
        if v: d['value']=int(v.group(1)); d['vty']=v.group(2)
        c=re.search(r'callee = @(\w+)',rest)
        if c: d['callee']=c.group(1)
        g=re.search(r'rawConstantIndices = array<i32: (\d+)>',rest)
        if g: d['gep']=int(g.group(1))
        f=re.search(r'overflowFlags = (\d)',rest)
        d['flags']=int(f.group(1)) if f else 0
        t=re.search(r':\s*\(([^)]*)\)\s*->\s*(\S+)\s*$',rest)
        d['ty']=t.group(2) if t else ''
        d['argty']=[x.strip() for x in t.group(1).split(',')] if t else []
        ins.append(d)
    return ins
