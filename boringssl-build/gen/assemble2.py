import sys,os
def compiled_part():
    from gen2 import ir_def_text, ir_eq_spec_text, out_eq_text
    lem,t=ir_eq_spec_text()
    s="\n/-! ## The compiled computation -/\n\n"+ir_def_text()+"\n"
    s+='''/-- A 24-bit value shifted right by `3` fits the mask. -/
theorem x25519_sc_reduce.nomask3_3 (y : BitVec 24) :
    y.setWidth 64 >>> 3 = 2097151#64 &&& y.setWidth 64 >>> 3 := by
  bv_decide

'''
    if os.environ.get('NOIR'): return s
    s+="\n".join(lem)+"\n"+out_eq_text()+"\n"+t
    return s
HERE=os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0,HERE)
from gen2 import *
parts=os.path.join(HERE,'parts','')
splits=eval(sys.argv[1])
nruns=int(sys.argv[2]) if len(sys.argv)>2 else len(splits)-1
inline_last=os.environ.get('INLINE_LAST')=='1'
tail=(sys.argv[3] if len(sys.argv)>3 else '  sorry').replace('\\n','\n')
only=os.environ.get('ONLY')
def rl(i):
    t=run_lemma(splits[i],splits[i+1],splits[i+1]==len(body))
    if only is not None and str(splits[i]) not in only.split(','):
        t=t[:t.index(':= by\n')]+':= by\n  sorry'
    return t
runs=[rl(i) for i in range(nruns)]
ml=[main_line(splits[i],splits[i+1]) for i in range(nruns)]
if nruns==len(splits)-1: ml.insert(-1,"  clear hwf hp")
if inline_last:
    ml.pop(); ml.pop()
    runs.pop()
    il=[]
    for d in body[splits[-2]:]:
        il+=["  "+l for l in walk_lines(d)]
    ml+=il[:int(os.environ.get('KL','100000'))]
if os.environ.get("MAINOFF"): ml=[]
main="\n".join(ml)
thm='''
/-- `x25519_sc_reduce` stores `spec` of the 64 bytes at `p` as the 32 bytes at `p`. -/
public theorem x25519_sc_reduce.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p (8 * 64)) (hp_off : ¬p.offset.uaddOverflow 64#64) :
    x25519_sc_reduce.call (x25519_sc_reduce.args (.value p)) s =
      .value (.nil,
        { s with mem := s.mem.storeAt p (x25519_sc_reduce.spec (s.mem.readAt p 512)) }) := by
  generalize hres : x25519_sc_reduce.spec (s.mem.readAt p 512) = res
  func_init
  have hp₀ : Fits S₀.mem p (8 * 64) := hS ▸ hp
  block_init
'''
s=(open(parts+'head.lean').read()+open(parts+'spec.lean').read()+open(parts+'bnd_reduce.lean').read()
   +open(parts+'loads.lean').read()
   +open(parts+'fdeq.lean').read()+spec_eq_text()+"\n"+out_def()+"\n"+compiled_part()+"\n/-! ## Proof -/\n\nsection Proof\n\nopen x25519_sc_reduce Bounds\n\n"+consts_abbrev()+"\n"+"\n\n".join(runs)+"\n"+thm+main+"\n"+tail+"\n\nend Proof\n\nend MLIR.Boringssl\n")
open(os.path.join(HERE,'..','..','Boringssl/x25519_sc_reduce.lean'),'w').write(s)
