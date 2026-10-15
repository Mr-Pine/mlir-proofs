# `noncomputable` on the lifts too big for the code generator and on all that reach them.
import os,re,sys
d=sys.argv[1]; mod=sys.argv[2]
# too big for the code generator: "maximum recursion depth" there
roots={'fd_ed25519_base_point_const_time_table','fd_ed25519_base_point_wnaf_table',
       'fd_ed25519_lane_base_table','fd_ed25519_lane_pow22523_2','fd_r43x6_ge_decode2',
       'fd_ristretto255_map_to_curve','fd_ristretto255_point_tobytes'}
names=[f[:-5] for f in os.listdir(d) if f.endswith('.lean')]
deps={n:set(re.findall(rf'^public import {re.escape(mod)}\.(\w+)$',open(os.path.join(d,n+'.lean')).read(),re.M)) for n in names}
nc=set(roots)&set(names)
while True:
    more={n for n in names if deps[n]&nc}-nc
    if not more: break
    nc|=more
for n in nc:
    p=os.path.join(d,n+'.lean'); t=open(p).read()
    t=re.sub(r'^(mlir_(?:const_)?def) ',r'noncomputable \1 ',t,flags=re.M)
    open(p,'w').write(t)
print(sorted(nc))

# Callees that cannot be lifted yet (inttoptr in the multi-buffer SHA-512, a pointer-vector GEP in
# the cached verify's split decode) become parameters of their callers' lifts.
params={
  'verify_x8': [('batch','fd_sha512_private_batch_avx512','MLIR.Vals [.bv 64, .ptr, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [])')],
  'fd_ed25519_verify_batch_multi_msg': [('batch',None,None)],
  'fd_ed25519_verify_batch_multi_msg_cached': [('batch',None,None),
     ('verifyCached','fd_ed25519_verify_cached','MLIR.Vals [.ptr, .bv 64, .ptr, .ptr, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals [.bv 32])')],
}
for n,ps in params.items():
    p=os.path.join(d,n+'.lean')
    if not os.path.exists(p): continue
    t=open(p).read()
    if '(batch :' in t: continue
    binders=''
    for v,sym,ty in ps:
        if sym:
            binders+=f' ({v} : {ty})'
            t=t.replace(f'      @{sym} := {mod}.{sym}',f'      @{sym} := {v}')
            t=t.replace(f'public import {mod}.{sym}\n','')
        else:
            binders+=f' ({v} : MLIR.Vals [.bv 64, .ptr, .ptr, .ptr] → MLIR.EffectM (MLIR.Vals []))'
            t=t.replace(f'      @verify_x8 := {mod}.verify_x8',f'      @verify_x8 := {mod}.verify_x8 {v}')
    t=re.sub(rf'^((?:noncomputable )?mlir_def {n}) :=',rf'\1{binders} :=',t,flags=re.M)
    open(p,'w').write(t)
