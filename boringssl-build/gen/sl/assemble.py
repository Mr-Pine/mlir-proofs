import sys
sys.path.insert(0,'/tmp/w1c')
import importlib, slgen; importlib.reload(slgen)
d='/tmp/w1c/sl/'
extra=(open(d+'extra.lean').read()+open(d+'extra2.lean').read()+open(d+'extra3.lean').read()) if len(sys.argv)>1 else ''
s=open(d+'head.lean').read()+open(d+'helpers.lean').read()+slgen.all_text()+"\n"+extra+"end Proof\n\nend MLIR.Boringssl\n"
open('/home/david.intern/mlir-proofs/Boringssl/slide.lean','w').write(s)
