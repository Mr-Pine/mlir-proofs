import re,sys
f=sys.argv[1]
names={'_ZL6fe_add':'fe_add','_ZL6fe_sub':'fe_sub','_ZL8fe_carry':'fe_carry','_ZL10fe_mul_tll':'fe_mul_tll','_ZL10fe_mul_tlt':'fe_mul_tlt','_ZL10fe_mul_ttl':'fe_mul_ttl','_ZL10fe_mul_ttt':'fe_mul_ttt','_ZL10fe_mul_ltt':'fe_mul_ltt'}
for line in open(f):
    line=line.strip()
    if line.startswith('^bb'): print(line.split('(')[0].split(':')[0]); continue
    m=re.search(r'"llvm\.(\w[\w.]*)"',line)
    if not m: continue
    op=m.group(1)
    if op=='func': continue
    if op=='call':
        c=re.search(r'callee = @(\w+)',line).group(1)
        args=re.search(r'"llvm.call"\(([^)]*)\)',line).group(1)
        print('  CALL',c[:40],args)
    elif op=='alloca': print('  ALLOCA',line.split('=')[0])
    elif op=='getelementptr':
        k=re.search(r'rawConstantIndices = array<i32: (\d+)>',line)
        a=re.search(r'getelementptr"\(([^)]*)\)',line).group(1)
        print('  pure gep',line.split('=')[0].strip(),a,k.group(1) if k else '?')
    else: print('  ',op, line.split('=')[0].strip() if '=' in line.split('"')[0] else '')
