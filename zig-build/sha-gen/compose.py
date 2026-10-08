import sys
sys.path.insert(0,'/tmp/sha/gen')
from final import *
def compose():
    o=[]
    o.append("set_option maxHeartbeats 0 in")
    o.append("/-- `bb5`: the 80 rounds from the state words at `dd + 16`, stored at `V`. -/")
    o.append("theorem block5 (dd blk V W : Pointer) (Wf : Nat → BitVec 64) (a b c d e f g h : BitVec 64)")
    o.append("    (E : ⟪Γ⟫) (S : GlobalState) {β : Type} (κ : Vals [] × GlobalState → PoisonOr β)")
    o.append("    (R : PoisonOr β) (hArgs : E.args = (Sha512_round.args (.value dd) (.value blk)).get)")
    o.append("    (hc : Consts E) (hR : E ⊨ [%102 := V, %103 := W]) (hdo : dd.offset.toNat + 80 < 2 ^ 64)")
    regs=[f"dd.add {16+8*i}#64" for i in range(8)]
    o.append(wrap("    ", [f"(hF{i} : Fits S.mem ({regs[i]}) 64)" for i in range(8)], 4, close=""))
    for i in range(8):
        o.append(f"    (hd{i} : S.mem.readAt ({regs[i]}) 64 = {L[i]})")
    o.append("    (hWo : W.offset = 0) (hWf : Fits S.mem W 5120) (hVo : V.offset = 0) (hVf : Fits S.mem V 512)")
    o.append("    (hW : ∀ t, t < 80 → S.mem.readAt (W.add (BitVec.ofNat 64 (8 * t))) 64 = Wf t)")
    o.append("    (hK : ∀ E' : ⟪Γ⟫, E'.args = (Sha512_round.args (.value dd) (.value blk)).get → Consts E' →")
    o.append("      (E' ⊨ [rir_reg% hty 2243 := 0#64, %102 := V, %141 := dd.add 16#64]) →")
    o.append("      (Sha512_round.runFrom E' 6")
    o.append("        { S with mem := storeWords8 S.mem V (rounds Wf 0 80 #v[a, b, c, d, e, f, g, h]) } >>= κ) = R) :")
    o.append("    (Sha512_round.runFrom E 5 S >>= κ) = R := by")
    o.append("  block_init")
    prev=list(L)
    o.append("  refine chunk0 dd blk V W Wf a b c d e f g h E S κ R hArgs hc hR hdo hF0 hF1 hF2 hF3 hF4 hF5")
    o.append("    hF6 hF7 hd0 hd1 hd2 hd3 hd4 hd5 hd6 hd7 hWo hWf hW")
    for j,t in enumerate(range(4,80,4)):
        vs=[f"{x}{j+1}" for x in L]
        o.append(f"    fun E{j+1} {' '.join(vs)} hv{j+1} hA{j+1} hc{j+1} hR{j+1} => ?_")
        extra = " hVo hVf" if t==76 else ""
        o.append(f"  refine chunk{t} dd blk V W Wf {' '.join(vs)} E{j+1} S κ R hA{j+1} hc{j+1} hR{j+1} hWo hWf{extra} hW")
        prev=vs
    o.append("    fun E' a' b' c' d' e' f' g' h' hv hA hc' hR' => ?_")
    rws=[]
    t=0
    for k in range(19):
        rws.append(f"rounds_add Wf {t} 4 {76-t}")
        rws.append(f"← hv{k+1}")
        t+=4
    o.append("  have hfin : #v[a', b', c', d', e', f', g', h'] = rounds Wf 0 80 #v[a, b, c, d, e, f, g, h] := by")
    o.append("    rw [" + ", ".join(rws) + "]")
    o.append("    exact hv")
    o.append("  rw [hfin]")
    o.append("  exact hK E' hA hc' hR'")
    return "\n".join(o)
if __name__=='__main__':
    print(compose())
