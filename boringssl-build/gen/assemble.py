import sys
parts='/tmp/w1c/parts/'
walk=open(parts+'walk.lean').read().split('\n')
N=int(sys.argv[1])
tail=(sys.argv[2] if len(sys.argv)>2 else '  sorry').replace('\\n','\n')
body='\n'.join(walk[:N])
s=open(parts+'head.lean').read()+open(parts+'spec.lean').read()+open(parts+'bnd.lean').read()+open(parts+'thm_head.lean').read()+body+'\n'+tail+'\n\nend Proof\n\nend MLIR.Boringssl\n'
open('/home/david.intern/mlir-proofs/Boringssl/x25519_sc_reduce.lean','w').write(s)
