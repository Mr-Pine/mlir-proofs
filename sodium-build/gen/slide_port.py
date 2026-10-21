"""Sodium/slide_vartime.lean from Boringssl/slide.lean: the same proof on libsodium's lift.

The lifts differ in three ways: registers are offset by 2276; `cmp < -15` is `icmp slt -15`
(branch true to the loop's end) where BoringSSL tests `sgt -16`; and each window's first block
loads `r[i]` after shifting `r[i + b]`.

    python3 sodium-build/gen/slide_port.py > Sodium/slide_vartime.lean
    lean-fmt format Sodium/slide_vartime.lean
"""
import re, sys, os
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
src = open(os.path.join(ROOT, 'Boringssl/slide.lean')).read()
OFF = 2276

head, rest = src.split('/-! ## Proof -/', 1)
t = rest
# registers
t = re.sub(r'%(\d+)', lambda m: f'%{int(m.group(1)) + OFF}', t)
# the lift's names
t = re.sub(r'\bslide\.(Γ|args|runFrom|call_eq|call)\b', r'slide_vartime.\1', t)
# BoringSSL's public window lemmas are reused
for name in ['window_stop', 'window_skip']:
    t, n = re.subn(r'\n/--[^\n]*\npublic theorem ' + name + r' .*?\n\n', '\n\n', t, flags=re.S)
    assert n == 1, name
# the `-15` test: `slt -15` breaks
t = t.replace('4294967280#32', '4294967281#32')
old_sub = re.search(r'/-- Else `r\[i\] - .*?\n\n', t, re.S).group(0)
old_brk = re.search(r'/-- Else: the window ends\. -/.*?\n\n', t, re.S).group(0)
new_sub = old_sub.replace(
    "(h' :\n      (4294967281#32).slt ((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b) = true)",
    "(h' :\n      ¬((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b).slt 4294967281#32 =\n          true)")
new_brk = old_brk.replace(
    "(h' :\n      ¬(4294967281#32).slt ((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b) =\n          true)",
    "(h' :\n      ((v[i]'(by omega)).signExtend 32 - v[i + b].signExtend 32 <<< b).slt 4294967281#32 = true)")
for o, n, nb in [(old_sub, new_sub, 'Bool.not_false'), (old_brk, new_brk, 'Bool.not_true')]:
    n = n.replace("(-15#32).sle x = (4294967281#32).slt x", "(-15#32).sle x = !x.slt 4294967281#32")
    n = n.replace("Bool.false_eq_true]", f"Bool.false_eq_true, {nb}]")
    assert n != o
    t = t.replace(o, n)
# each window's first block: `r[i + b] << b` before `r[i]`
old = """  block_init
  step_load [readAt_byte hr.inBounds hr_off hi0]
  step_pure
  step_pure
  step_pure [sext_shl _ (by decide : @ = 1 ∨ @ = 2 ∨ @ = 3 ∨ @ = 4 ∨ @ = 5 ∨ @ = 6)]
"""
new = """  block_init
  step_pure
  step_pure [sext_shl _ (by decide : @ = 1 ∨ @ = 2 ∨ @ = 3 ∨ @ = 4 ∨ @ = 5 ∨ @ = 6)]
  step_load [readAt_byte hr.inBounds hr_off hi0]
  step_pure
"""
for b in range(1, 7):
    o, n = old.replace('@', str(b)), new.replace('@', str(b))
    assert o in t, b
    t = t.replace(o, n)
# the `-15` branch: true is the break, false the subtraction
pat = re.compile(r"""(  -- else if \(r\[i\] - \(r\[i \+ b\] << b\) >= -15\)
  block_init
  step_pure \[sext_sub [^\n]*\]
  step_pure
  finish_block
)  · rw \[window_sub \(by decide\) hib h0 h1 hbr\] at hK
((?:    [^\n]*\n)*)  rw \[window_break \(by decide\) hib h0 h1 hbr\] at hK
  run_from using hK
""")
def swap(m):
    body = ''.join(l[2:] + '\n' for l in m.group(2).rstrip('\n').split('\n'))
    return (m.group(1) + "  · rw [window_break (by decide) hib h0 h1 hbr] at hK\n    run_from using hK\n"
            + "  rw [window_sub (by decide) hib h0 h1 hbr] at hK\n" + body)
t, n = pat.subn(swap, t)
assert n == 6, n
t = t.replace('-- else if (r[i] - (r[i + b] << b) >= -15)', '-- if (cmp < -15) break')
t = t.replace('end MLIR.Boringssl', 'end MLIR.Sodium')
t = t.replace('open slide MLIR.Firedancer', 'open MLIR.Boringssl MLIR.Boringssl.slide MLIR.Firedancer')
t = t.replace('''/-- `slide` stores `slide.spec` of the 32 bytes at `a` as the 256 digits at `r`, which must not
alias `a`. -/''', '''/-- `slide_vartime` stores `slide.spec` of the 32 bytes at `a` as the 256 digits at `r`, which
must not alias `a`. -/''')
hdr = """module

public import MLIR.Run.Tactic
public import Boringssl.slide
public import Sodium.Mlir.slide_vartime
import Firedancer.Common.Memory
import Firedancer.Common.Counter
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `slide_vartime` is BoringSSL's `slide`: the same digits, `slide.spec`. -/

namespace MLIR.Sodium

"""
sys.stdout.write(hdr + '/-! ## Proof -/' + t)
