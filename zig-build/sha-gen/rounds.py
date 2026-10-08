import sys
n=int(sys.argv[1])
out=[]
out.append("  block_init")
out.append("  iterate 8\n    step_pure\n    step_load")
for t in range(n):
    if t==0:
        out.append("  have hw0 : S.mem.readAt W 64 = Ws[0] := by rw [hS]; simpa using hW 0 (by decide)")
        out.append("  iterate 8 step_pure")
    else:
        out.append(f"  have hw{t} : S.mem.readAt (W.add {8*t}#64) 64 = Ws[{t}] := by rw [hS]; exact hW {t} (by decide)")
        out.append("  iterate 9 step_pure")
    out.append(f"  step_load consuming hw{t}")
    out.append("  iterate 3 step_pure")
    out.append(f"  step_pure with t{t}")
    out.append(f"  step_pure with e{t}")
    out.append("  iterate 10 step_pure")
    out.append(f"  step_pure with a{t}")
print("\n".join(out))
