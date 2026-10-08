import re,sys
lines=open(sys.argv[1]).read().split('\n')
start=[i for i,l in enumerate(lines) if l.strip().startswith('^bb5')][0]
end=[i for i,l in enumerate(lines) if l.strip().startswith('^bb6')][0]
ops=[]
for l in lines[start+1:end]:
    m=re.match(r'\s*(?:%(\d+) = )?"llvm\.(\S+?)"',l)
    ops.append(m.group(2) if m else '?')
# skip 16 state loads
body=ops[16:]
seq=' '.join(body)
# split rounds at loads
rounds=[]; cur=[]
for o in body:
    cur.append(o)
    if o=='load' and len(cur)>1:
        pass
print(len(body))
print(' '.join(body[:30]))
print(' '.join(body[25:52]))
print(' '.join(body[-40:]))
