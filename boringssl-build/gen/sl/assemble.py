import sys,os
HERE=os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0,os.path.dirname(HERE))
import importlib, slgen; importlib.reload(slgen)
d=os.path.join(HERE,'')
extra=(open(d+'extra.lean').read()+open(d+'extra2.lean').read()+open(d+'extra3.lean').read()) if len(sys.argv)>1 else ''
s=open(d+'head.lean').read()+open(d+'helpers.lean').read()+slgen.all_text()+"\n"+extra+"end Proof\n\nend MLIR.Boringssl\n"
open(os.path.join(HERE,'..','..','..','Boringssl/slide.lean'),'w').write(s)
