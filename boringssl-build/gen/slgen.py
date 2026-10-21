# slide: carry and window lemmas for b = 1..6
H={1:3,2:11,3:20,4:29,5:38,6:47}
CH={1:(8,'%276'),2:(16,'%296'),3:(25,'%317'),4:(34,'%338'),5:(43,'%359'),6:(52,'%380')}
NEXT={1:11,2:20,3:29,4:38,5:47,6:56}
def env_carry(b): return "hdrB r E i" if b<=5 else "hdrI E i"
def env_next(b,E="E'"): return f"hdrB r {E} i" if b<=5 else f"hdrI {E} i"
def env_win(b,E="E"):
    if b==1: return f"(hdrI {E} i)[%256 := .value (r.add (BitVec.ofNat 64 i))]"
    return f"hdrB r {E} i"
CARRY_BODY='''    replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
    have hk' : k < 256 := by omega
    block_init
    step_pure [Nat.mod_lt]
    step_load [readAt_byte hr.inBounds hr_off hk']
    step_pure
    finish_block
    · rw [carry_set hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      finish_block
      run_from using hK
    · rw [carry_clear hk' hbr] at hK
      block_init
      step_store
      rw [storeAt_byte hr_off hk'] at hS
      step_pure [saddOverflow_one64 (i := k) (by omega), uaddOverflow_one64 (i := k) (by omega),
        ← BitVec.ofNat_add]
      step_pure
      finish_block
'''
def carry(b):
    blk,reg=CH[b]
    return f'''/-- `^bb{blk}`, the carry loop of `b = {b}` from `k`: on to `^bb{NEXT[b]}` with `carry v k`. -/
theorem carry{b}_loop (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ n k (v : Vector (BitVec 8) 256) (E : ⟪slide.Γ⟫),
      E.args = (slide.args (.value r) (.value a)).get → k + n = 255 →
        (∀ E' : ⟪slide.Γ⟫, E'.args = E.args →
          slide.runFrom ({env_next(b)}) ^bb{NEXT[b]} (st Sb r (carry v k)) = K) →
        slide.runFrom (({env_carry(b)})[{reg} := .value (BitVec.ofNat 64 k)]) ^bb{blk} (st Sb r v) =
          K := by
  intro n
  induction n with
  | zero =>
    intro k v E hArgs hk hK
{CARRY_BODY}      · rw [carry_done (by omega)] at hK
        run_from using hK
      · exact absurd (by rw [show k + 1 = 256 by omega]) hbr
  | succ n ih =>
    intro k v E hArgs hk hK
{CARRY_BODY}      · exact absurd hbr (ofNat64_ne (by omega) (by omega) (by omega))
      · run_from using ih (k + 1)
        run_from using hK
'''
BOR=lambda b: f"(by decide : {b} = 1 ∨ {b} = 2 ∨ {b} = 3 ∨ {b} = 4 ∨ {b} = 5 ∨ {b} = 6)"
def window(b):
    hyp={1:"(hi : i < 255)",2:"(hi : i < 255)"}.get(b,f"(hi : i + {b-1} < 256)")
    L=[]
    L.append(f'''/-- `^bb{H[b]}`, the window at `b = {b}`: on to `^bb56` with `window v i {b}`. -/
theorem window{b} (r a : Pointer) (Sb : GlobalState) (hr : Room Sb.mem r 2048)
    (hr_off : ¬r.offset.uaddOverflow 256#64) (i : Nat) {hyp}
    (K : PoisonOr (Vals [] × GlobalState)) (v : Vector (BitVec 8) 256) (E : ⟪slide.Γ⟫)
    (hArgs : E.args = (slide.args (.value r) (.value a)).get)
    (hK : ∀ E' : ⟪slide.Γ⟫, E'.args = E.args →
      slide.runFrom (hdrI E' i) ^bb56 (st Sb r (window v i {b})) = K) :
    slide.runFrom ({env_win(b)}) ^bb{H[b]} (st Sb r v) = K := by
  replace hK := fun E' (h : E'.args = _) => hK E' (h.trans hArgs.symm)
  have hi0 : i < 256 := by omega
  block_init''')
    if b==1:
        L.append('''  -- min(254 - i, 5) + 2
  step_pure [umin_cnt hi]
  step_pure [sadd32 (x := min (254 - i) 5) (c := 2) (by omega),
    uadd32 (x := min (254 - i) 5) (c := 2) (by omega), ← BitVec.ofNat_add]
  have hib : i + 1 < 256 := by omega''')
    elif b==2:
        L.append('''  -- i + b, i + b < 256
  step_pure [sadd64 (x := i + 1) (c := 1) (by omega), uadd64 (x := i + 1) (c := 1) (by omega),
    ← BitVec.ofNat_add, show i + 1 + 1 = i + 2 from rfl]
  step_pure
  finish_block
  · rw [window_stop (by have := cnt_eq hi hbr; omega)] at hK
    run_from using hK
  have hib : i + 2 < 256 := by have := cnt_ne hi hbr; omega''')
    else:
        L.append(f'''  -- i + b, i + b < 256
  step_pure [sadd64 (x := i + 1) (c := {b-1}) (by omega), uadd64 (x := i + 1) (c := {b-1}) (by omega),
    ← BitVec.ofNat_add, show i + 1 + {b-1} = i + {b} from rfl]
  step_pure
  finish_block
  · rw [window_stop (by have := guard_eq (b := {b}) (by decide) hbr; omega)] at hK
    run_from using hK
  have hib : i + {b} < 256 := by have := guard_ne (b := {b}) (by decide) hi hbr; omega''')
    if b<=5:
        L.append(f'''  have W := window{b+1} r a Sb hr hr_off i {"hib" if b>=2 else "hi"} K
  have C := carry{b}_loop r a Sb hr hr_off i K (255 - (i + {b})) (i + {b})''')
        nxt="  run_from using W _\n  run_from using hK"
        fin=""
    else:
        L.append(f'''  have C := carry{b}_loop r a Sb hr hr_off i K (255 - (i + {b})) (i + {b})''')
        nxt="  run_from using hK"
        fin="\n  rw [window_stop (by omega)] at hK"
    L.append(f'''  -- if (r[i + b])
  {"block_init" + chr(10) + "  " if b>1 else ""}step_pure [Nat.mod_lt]
  step_load [readAt_byte hr.inBounds hr_off hib]
  step_pure
  finish_block
  · rw [window_skip (by decide) hib hbr] at hK
    simp only [Nat.reduceAdd] at hK{fin.replace(chr(10),chr(10)+"  ")}
  {nxt.replace(chr(10),chr(10)+"  ")}
  have h0 := hbr
  -- if (r[i] + (r[i + b] << b) <= 15)
  block_init
  step_load [readAt_byte hr.inBounds hr_off hi0]
  step_pure
  step_pure
  step_pure [sext_shl _ {BOR(b)}]
  step_pure [sext_add _ _ {BOR(b)}]
  step_pure
  finish_block
  · rw [window_add (by decide) hib h0 hbr] at hK
    simp only [Nat.reduceAdd] at hK{fin.replace(chr(10),chr(10)+"  ")}
    block_init
    step_pure
    step_store
    rw [storeAt_byte hr_off hi0] at hS
    step_store
    rw [storeAt_byte hr_off hib] at hS
    finish_block
  {nxt.replace(chr(10),chr(10)+"  ")}
  have h1 := hbr
  -- else if (r[i] - (r[i + b] << b) >= -15)
  block_init
  step_pure [sext_sub _ _ {BOR(b)}]
  step_pure
  finish_block
  · rw [window_sub (by decide) hib h0 h1 hbr] at hK
    simp only [Nat.reduceAdd] at hK{fin.replace(chr(10),chr(10)+"  ")}
    block_init
    step_pure
    step_store
    rw [storeAt_byte hr_off hi0] at hS
    finish_block
    run_from using C
  {nxt.replace(chr(10),chr(10)+"  ")}
  rw [window_break (by decide) hib h0 h1 hbr] at hK
  run_from using hK
''')
    return "\n".join(L)
def all_text():
    out=[]
    for b in range(6,0,-1):
        out.append(carry(b)); out.append(window(b))
    return "\n".join(out)
if __name__=='__main__':
    print(window(6)); print(window(1))
