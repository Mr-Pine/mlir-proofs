import re
src=open('/home/david.intern/mlir-proofs/Boringssl/Mlir/slide.lean').read().split('\n')
blocks={}; order=[]; cur=None
for l in src:
    m=re.match(r'\^bb(\d+)(\(([^)]*)\))?:',l.strip())
    if m:
        cur=int(m.group(1)); order.append(cur)
        params=re.findall(r'(%\w+):',m.group(3) or '')
        blocks[cur]={'params':params,'defs':[],'uses':[],'succ':[],'jargs':{}}
        continue
    if cur is None: continue
    l=l.strip()
    mm=re.match(r'(?:(%\d+) = )?"llvm\.([a-z_.]+)"\(([^)]*)\)(\[[^\]]*\])?',l)
    if not mm: continue
    res,op,args,tg=mm.groups()
    a=[x.strip() for x in args.split(',') if x.strip()]
    b=blocks[cur]
    if op in('br','cond_br'):
        tgts=[int(t) for t in re.findall(r'\^bb(\d+)',tg)]
        seg=re.search(r'operandSegmentSizes = array<i32: ([\d, ]+)>',l)
        if op=='br':
            b['succ']=tgts; b['jargs'][tgts[0]]=a; b['uses']+= [x for x in a if x not in b['defs']]
        else:
            s=[int(x) for x in seg.group(1).split(',')]
            cond=a[0]; ta=a[1:1+s[1]]; fa=a[1+s[1]:]
            b['succ']=tgts; b['jargs'][tgts[0]]=ta; b['jargs'][tgts[1]]=fa
            b['uses']+=[x for x in a if x not in b['defs']]
        continue
    b['uses']+=[x for x in a if x not in b['defs'] and x not in b['uses']]
    if res: b['defs'].append(res)
# liveness
live_in={k:set() for k in blocks}
changed=True
while changed:
    changed=False
    for k in reversed(order):
        b=blocks[k]
        out=set()
        for s in b['succ']: out|=live_in[s]-set(blocks[s]['params'])
        li=(set(b['uses'])|out)-set(b['defs'])
        li-=set(b['params'])
        li|=set()  # params defined at entry
        if li!=live_in[k]: live_in[k]=li; changed=True
for k in order:
    print(k, blocks[k]['params'], sorted(live_in[k], key=lambda x:(not x.startswith('%arg'), int(re.sub(r'\D','',x)))))
