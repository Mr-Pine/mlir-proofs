import sys
sys.path.insert(0,'/tmp/sha/gen')
from info import *
L="abcdefgh"
def lst(xs): return ", ".join(xs)
def wrap(prefix, items, indent, close="]"):
    out=[]; cur=prefix
    for i,x in enumerate(items):
        s=x+((", " if close=="]" else " ") if i<len(items)-1 else close)
        if len(cur)+len(s)>100:
            out.append(cur.rstrip()); cur=" "*indent
        cur+=s
    out.append(cur)
    return "\n".join(out)
def R(k): return f"%{k}" if k < 300 else f"rir_reg% hty {k}"
def regfacts(t, vs):
    regs=bounds[t][1]
    return [f"{R(regs[i])} := {vs[i]}" for i in range(8)]+["%102 := V", "%103 := W", "%141 := dd.add 16#64"]
def shape(t): return 0 if t==0 else 1 if t==1 else 2 if t<4 else 4
def round_steps(t, cur, na, ne):
    o=[]
    if t==0:
        o.append("  iterate 8 step_pure")
        o.append("  have hw : S.mem.readAt W 64 = Wf 0 := by rw [hS]; simpa using hW 0 (by decide)")
    else:
        o.append("  iterate 9 step_pure")
        o.append(f"  have hw : S.mem.readAt (W.add {8*t}#64) 64 = Wf {t} := by")
        o.append(f"    first | exact hW {t} (by decide) | (rw [hS]; exact hW {t} (by decide))")
    o.append("  step_load consuming hw")
    o.append("  iterate 3 step_pure")
    o.append(f"  step_pure with t{t} ht{t}")
    o.append(f"  step_pure with {ne} he{t}")
    o.append("  iterate 10 step_pure")
    o.append(f"  step_pure with {na} ha{t}")
    a,b,c,d,e,f,g,h=cur
    o.append(f"  have hr{t} : Sha512.round #v[{lst(cur)}] Sha512.K[{t}]! (Wf {t}) =")
    o.append(f"      #v[{na}, {a}, {b}, {c}, {ne}, {e}, {f}, {g}] := by")
    o.append(f"    rw [ha{t}, he{t}, ht{t}]; exact round_eq{shape(t)} ..")
    o.append(f"  clear ha{t} he{t} ht{t}")
    return o
def chunk(t0,n):
    first = t0==0
    last = t0+n==80
    p=0 if first else bounds[t0][0]; q=bounds[t0+n][0]
    v0=list(L); vn=[x+"'" for x in L]
    o=[]
    o.append("set_option maxHeartbeats 0 in")
    o.append(f"/-- Rounds `{t0}` to `{t0+n-1}`" + (", after loading the state words" if first else "") + (", then the working variables stored at `V`" if last else "") + ". -/")
    o.append(f"theorem chunk{t0} (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)")
    o.append("    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)")
    o.append("    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)")
    if first:
        o.append("    (hc : Consts E) (hR : E ⊨ [%102 := V, %103 := W]) (hdo : dd.offset.toNat + 80 < 2 ^ 64)")
        regs=[f"dd.add {16+8*i}#64" for i in range(8)]
        o.append(wrap("    ", [f"(hF{i} : Fits S.mem ({regs[i]}) 64)" for i in range(8)], 4, close=""))
        for i in range(8):
            o.append(f"    (hd{i} : S.mem.readAt ({regs[i]}) 64 = {L[i]})")
    else:
        o.append("    (hc : Consts E)")
        o.append(wrap("    (hR : E ⊨ [", regfacts(t0,v0), 6)+")")
    o.append("    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120)")
    if last:
        o.append("    (hVo : V.offset = 0) (hVf : Fits S.mem V 512)")
    o.append("    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)")
    o.append("    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),")
    o.append(f"      #v[{lst(vn)}] = rounds Wf {t0} {n} #v[{lst(v0)}] →")
    o.append("        E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →")
    if last:
        o.append("        (E' ⊨ [rir_reg% hty 2243 := 0#64, %102 := V, %141 := dd.add 16#64]) →")
        o.append(f"        (Sha512_round.runFrom E' 6 {{ S with mem := storeWords8 S.mem V #v[{lst(vn)}] }} >>= κ) = R) :")
    else:
        o.append(wrap("        (E' ⊨ [", regfacts(t0+n,vn), 10)+") →")
        o.append(f"        BODY E' {q} S κ = R) :")
    o.append(f"    BODY E {p} S κ = R := by")
    if first:
        o.append("  iterate 8")
        o.append("    step_pure")
        o.append("    step_load")
    cur=list(v0)
    for t in range(t0,t0+n):
        na,ne=f"a{t+1}",f"e{t+1}"
        o+=round_steps(t,cur,na,ne)
        cur=[na]+cur[:3]+[ne]+cur[4:7]
    o.append(f"  have hv : #v[{lst(cur)}] = rounds Wf {t0} {n} #v[{lst(v0)}] := by")
    o.append("    rw [" + ", ".join(f"rounds_succ, hr{t}" for t in range(t0,t0+n)) + ", rounds_zero]")
    if last:
        o.append("  step_store")
        o.append("  iterate 7")
        o.append("    step_pure")
        o.append("    step_store")
        o.append("  rw [BasicBlock.runBodyFrom_done bb5_done]")
        o.append("  simp only [EffectM.pure_eq, PoisonOr.value_bind, reduceBlockExit, Exit.run]")
        o.append("  dsimp only [Jump.run, Fin.isValue, Regs.read_nil, EffectM.pure_eq, PoisonOr.value_bind,")
        o.append("    Regs.read_cons, reduceWriteManyDsts, Env.writeMany_nil, Env.writeMany_cons]")
        o.append("  rw [Func.continue_next]")
        o.append("  subst hS")
        o.append(f"  refine hK _ {' '.join(cur)} hv hArgs (by env_reads) ⟨?_, ?_, ?_⟩")
        o.append("  · rw [read_write_same]; env_reads")
        o.append("  all_goals rw [Env.read_write_ne']; env_reads")
    else:
        o.append("  first | subst hS | skip")
        o.append(f"  exact hK E {' '.join(cur)} hv hArgs (by env_reads) (by env_reads)")
    return "\n".join(o)
if __name__=='__main__':
    for a in sys.argv[1:]:
        t0,n=map(int,a.split(','))
        print(chunk(t0,n)); print()
