import sys
sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.abspath(__file__)))
from info import *
L="abcdefgh"
def lst(items):
    return ", ".join(items)
def facts(t, vars_):
    # live facts at boundary t, values named by vars_ (8 names)
    regs=bounds[t][1]
    items=[f"%{regs[i]} := {vars_[i]}" for i in range(8)]
    for r in live(t):
        items.append(f"%{r} := {consts[r][0]}#{consts[r][1]}")
    items += ["%102 := V", "%103 := W", "%141 := dd.add 16#64"]
    return items
def shape(t):
    return 0 if t==0 else 1 if t==1 else 2 if t<4 else 4
def wrap(prefix, items, indent):
    out=[]; cur=prefix
    for i,x in enumerate(items):
        s=x+(", " if i<len(items)-1 else "]")
        if len(cur)+len(s)>99:
            out.append(cur.rstrip()); cur=" "*indent
        cur+=s
    out.append(cur)
    return "\n".join(out)
def round_steps(t, cur, nxt_a, nxt_e):
    o=[]
    if t==0:
        o.append("  iterate 8 step_pure")
        o.append(f"  have hw : S.mem.readAt W 64 = Wf 0 := by first | (rw [hS]; simpa using hW 0 (by decide)) | simpa using hW 0 (by decide)")
    else:
        o.append("  iterate 9 step_pure")
        o.append(f"  have hw : S.mem.readAt (W.add {8*t}#64) 64 = Wf {t} := by first | (rw [hS]; exact hW {t} (by decide)) | exact hW {t} (by decide)")
    o.append("  step_load consuming hw")
    o.append("  iterate 3 step_pure")
    o.append(f"  step_pure with t{t} ht{t}")
    o.append(f"  step_pure with {nxt_e} he{t}")
    o.append("  iterate 10 step_pure")
    o.append(f"  step_pure with {nxt_a} ha{t}")
    a,b,c,d,e,f,g,h=cur
    o.append(f"  have hr{t} : Sha512.round #v[{lst(cur)}] Sha512.K[{t}]! (Wf {t}) = #v[{nxt_a}, {a}, {b}, {c}, {nxt_e}, {e}, {f}, {g}] := by")
    o.append(f"    rw [ha{t}, he{t}, ht{t}]; exact round_eq{shape(t)} ..")
    o.append(f"  clear ha{t} he{t} ht{t}")
    return o
def chunk(t0,n):
    p=bounds[t0][0]; q=bounds[t0+n][0]
    v0=[f"{L[i]}" for i in range(8)]
    vn=[f"{L[i]}'" for i in range(8)]
    o=[]
    o.append(f"/-- Rounds `{t0}` to `{t0+n-1}`. -/")
    o.append(f"theorem chunk{t0} (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)")
    o.append("    (S : GlobalState) (E : ⟪Γ⟫) (R : PoisonOr (Vals [] × GlobalState))")
    o.append("    (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get) (hWo : W.offset = 0)")
    o.append("    (hWf : Fits S.mem W 5120)")
    o.append("    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)")
    o.append(wrap("    (hR : E ⊨ [", facts(t0,v0), 6)+")")
    o.append("    (hK : ∀ (E' : ⟪Γ⟫) (a' b' c' d' e' f' g' h' : BitVec 64),")
    o.append(f"      #v[{lst(vn)}] = rounds Wf {t0} {n} #v[{lst(v0)}] →")
    o.append("        E'.args = (Sha512_round.args (.value dd) (.value blk)).get →")
    o.append(wrap("        (E' ⊨ [", facts(t0+n,vn), 10)+") →")
    o.append(f"        BODY E' {q} S = R) :")
    o.append(f"    BODY E {p} S = R := by")


    cur=list(v0)
    names=[]
    for t in range(t0,t0+n):
        na,ne=f"a{t+1}",f"e{t+1}"
        o+=round_steps(t,cur,na,ne)
        cur=[na]+cur[:3]+[ne]+cur[4:7]
    final=cur
    o.append("  have hv : #v[" + lst(final) + f"] = rounds Wf {t0} {n} #v[{lst(v0)}] := by")
    o.append("    rw [" + ", ".join(f"rounds_succ, hr{t}" for t in range(t0,t0+n)) + ", rounds_zero]")
    o.append("  first | subst hS | skip")
    o.append(f"  exact hK E {' '.join(final)} hv hArgs (by env_reads)")
    return "\n".join(o)
if __name__=='__main__':
    print(chunk(int(sys.argv[1]),int(sys.argv[2])))
