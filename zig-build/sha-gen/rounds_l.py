import sys
n=int(sys.argv[1])
out=[]
out.append("  block_init")
out.append("  iterate 8\n    step_pure only [PoisonOr.value_bind, PoisonOr.pure_def, PoisonOr.bind₂_value, PoisonOr.map_value, Ty.unflatten_bv, Ty.flatten_bv, Ty.wrap_bv, Ty.unwrap_bv, false_and, and_false, if_false, ite_false, ite_true, if_true, Bool.false_eq_true, false_or, or_false]\n    step_load")
for t in range(n):
    if t==0:
        out.append("  have hw0 : S.mem.readAt W 64 = Ws[0] := by rw [hS]; simpa using hW 0 (by decide)")
        out.append("  iterate 8 step_pure only [PoisonOr.value_bind, PoisonOr.pure_def, PoisonOr.bind₂_value, PoisonOr.map_value, Ty.unflatten_bv, Ty.flatten_bv, Ty.wrap_bv, Ty.unwrap_bv, false_and, and_false, if_false, ite_false, ite_true, if_true, Bool.false_eq_true, false_or, or_false]")
    else:
        out.append(f"  have hw{t} : S.mem.readAt (W.add {8*t}#64) 64 = Ws[{t}] := by rw [hS]; exact hW {t} (by decide)")
        out.append("  iterate 9 step_pure only [PoisonOr.value_bind, PoisonOr.pure_def, PoisonOr.bind₂_value, PoisonOr.map_value, Ty.unflatten_bv, Ty.flatten_bv, Ty.wrap_bv, Ty.unwrap_bv, false_and, and_false, if_false, ite_false, ite_true, if_true, Bool.false_eq_true, false_or, or_false]")
    out.append(f"  step_load consuming hw{t}")
    out.append("  iterate 3 step_pure only [PoisonOr.value_bind, PoisonOr.pure_def, PoisonOr.bind₂_value, PoisonOr.map_value, Ty.unflatten_bv, Ty.flatten_bv, Ty.wrap_bv, Ty.unwrap_bv, false_and, and_false, if_false, ite_false, ite_true, if_true, Bool.false_eq_true, false_or, or_false]")
    out.append(f"  step_pure only [PoisonOr.value_bind, PoisonOr.pure_def, PoisonOr.bind₂_value, PoisonOr.map_value, Ty.unflatten_bv, Ty.flatten_bv, Ty.wrap_bv, Ty.unwrap_bv, false_and, and_false, if_false, ite_false, ite_true, if_true, Bool.false_eq_true, false_or, or_false] with t{t}")
    out.append(f"  step_pure only [PoisonOr.value_bind, PoisonOr.pure_def, PoisonOr.bind₂_value, PoisonOr.map_value, Ty.unflatten_bv, Ty.flatten_bv, Ty.wrap_bv, Ty.unwrap_bv, false_and, and_false, if_false, ite_false, ite_true, if_true, Bool.false_eq_true, false_or, or_false] with e{t}")
    out.append("  iterate 10 step_pure only [PoisonOr.value_bind, PoisonOr.pure_def, PoisonOr.bind₂_value, PoisonOr.map_value, Ty.unflatten_bv, Ty.flatten_bv, Ty.wrap_bv, Ty.unwrap_bv, false_and, and_false, if_false, ite_false, ite_true, if_true, Bool.false_eq_true, false_or, or_false]")
    out.append(f"  step_pure only [PoisonOr.value_bind, PoisonOr.pure_def, PoisonOr.bind₂_value, PoisonOr.map_value, Ty.unflatten_bv, Ty.flatten_bv, Ty.wrap_bv, Ty.unwrap_bv, false_and, and_false, if_false, ite_false, ite_true, if_true, Bool.false_eq_true, false_or, or_false] with a{t}")
print("\n".join(out))
