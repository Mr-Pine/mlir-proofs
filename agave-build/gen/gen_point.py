#!/usr/bin/env python3
"""Writes Agave/Common/Point.lean: the hand-written core, then each object's lemmas."""
import sys

core = open(sys.argv[1]).read()
out = sys.argv[2]

# name, struct, fields, core (Fe4/Fe3), Fit, Room, rust name
objs = [
    ("Edwards", "Agave.EdwardsPoint", ["X", "Y", "Z", "T"], "Fe4", "PointFit", "PointRoom",
     "EdwardsPoint"),
    ("Projective", "Agave.ProjectivePoint", ["X", "Y", "Z"], "Fe3", "ProjectiveFit",
     "ProjectiveRoom", "ProjectivePoint"),
    ("Completed", "Agave.CompletedPoint", ["X", "Y", "Z", "T"], "Fe4", "PointFit", "PointRoom",
     "CompletedPoint"),
    ("Niels", "Agave.ProjectiveNielsPoint", ["Y_plus_X", "Y_minus_X", "Z", "T2d"], "Fe4",
     "PointFit", "PointRoom", "ProjectiveNielsPoint"),
]
preds = ["LimbsFit", "LimbsRoom", "PointFit", "PointRoom", "ProjectiveFit", "ProjectiveRoom"]
offs = ["p", "(p.add 40#64)", "(p.add 80#64)", "(p.add 120#64)"]

L = []
w = L.append

w("/-! ### The objects' reads and stores -/\n")
for (n, S, fs, c, fit, room, rust) in objs:
    reads = ", ".join(f"m.readLimbs {o}" for o in offs[: len(fs)])
    w(f"/-- The `{rust}` at `p`. -/")
    w(f"def MemoryState.read{n} (m : MemoryState) (p : Pointer) : {S} :=")
    w(f"  ⟨{reads}⟩\n")
    args = " ".join(f"P.{f}" for f in fs)
    w(f"/-- Store a `{rust}` at `p`, `{fs[0]}` to `{fs[-1]}`. -/")
    w(f"def MemoryState.store{n} (m : MemoryState) (p : Pointer) (P : {S}) : MemoryState :=")
    w(f"  m.store{c} p {args}\n")

for (n, S, fs, c, fit, room, rust) in objs:
    st = f"store{n}"
    w(f"/-! ### `{rust}` stores -/\n")
    w(f"section {n}\n")
    w(f"variable {{m : MemoryState}} {{p q : Pointer}} {{P : {S}}}\n")
    for pr in ["Fits", "Room", "InBounds"]:
        w("@[mlir_transport]")
        w(f"theorem {pr}.{st} (h : {pr} m q w) : {pr} (m.{st} p P) q w :=")
        w(f"  h.store{c}\n")
    for pr in preds:
        w("@[mlir_mem, mlir_transport]")
        w(f"theorem MemoryState.{pr}.{st} (h : m.{pr} q) : (m.{st} p P).{pr} q :=")
        w(f"  h.store{c}\n")
    w("@[simp, mlir_state]")
    w(f"theorem MemoryState.limbsRoom_{st}_iff : (m.{st} p P).LimbsRoom q ↔ m.LimbsRoom q :=")
    w(f"  limbsRoom_store{c}_iff\n")
    w(f"theorem MemoryState.PointRoom.of_{st} (h : (m.{st} p P).PointRoom q) : m.PointRoom q :=")
    w(f"  ⟨h.1, limbsRoom_{st}_iff.mp h.2.1, limbsRoom_{st}_iff.mp h.2.2.1,")
    w(f"    limbsRoom_{st}_iff.mp h.2.2.2.1, limbsRoom_{st}_iff.mp h.2.2.2.2⟩\n")
    w(f"theorem MemoryState.ProjectiveRoom.of_{st} (h : (m.{st} p P).ProjectiveRoom q) :")
    w(f"    m.ProjectiveRoom q :=")
    w(f"  ⟨h.1, limbsRoom_{st}_iff.mp h.2.1, limbsRoom_{st}_iff.mp h.2.2.1,")
    w(f"    limbsRoom_{st}_iff.mp h.2.2.2⟩\n")
    w("@[simp, mlir_mem]")
    w(f"theorem GlobalState.WF_{st} {{s : GlobalState}} :")
    w(f"    ({{ s with mem := m.{st} p P }} : GlobalState).WF ↔ ({{ s with mem := m }} : GlobalState).WF :=")
    w(f"  WF_store{c}\n")
    w("@[mlir_transport]")
    w(f"theorem GlobalState.WF.{st} {{s : GlobalState}} (h : s.WF) :")
    w(f"    ({{ s with mem := s.mem.{st} p P }} : GlobalState).WF :=")
    w(f"  GlobalState.WF_{st}.mpr h\n")
    w(f"/-- `WF.{st}` for a state written as a constructor, which unifies first-order. -/")
    w("@[mlir_transport]")
    w(f"theorem GlobalState.WF.{st}_mk {{a : AllocState}} (h : (⟨a, m⟩ : GlobalState).WF) :")
    w(f"    (⟨a, m.{st} p P⟩ : GlobalState).WF :=")
    w(f"  GlobalState.WF.{st} (s := ⟨a, m⟩) h\n")
    w(f"/-- A `{rust}` stored where there is room is known. -/")
    w("@[mlir_fresh, mlir_mem]")
    w(f"theorem MemoryState.{fit}.{st}_self (h : m.{room} p) : (m.{st} p P).{fit} p :=")
    w(f"  {fit}.store{c}_self h\n")
    w("@[mlir_read]")
    w(f"theorem MemoryState.readLimbs_{st}_of_id_ne (h : p.id ≠ q.id) :")
    w(f"    (m.{st} p P).readLimbs q = m.readLimbs q :=")
    w(f"  readLimbs_store{c}_of_id_ne h\n")
    w("@[mlir_read]")
    w(f"theorem MemoryState.readAt_{st}_of_id_ne (h : p.id ≠ q.id) :")
    w(f"    (m.{st} p P).readAt q w = m.readAt q w :=")
    w(f"  readAt_store{c}_of_id_ne h\n")
    for i, f in enumerate(fs):
        o = offs[i]
        w("@[mlir_read]")
        w(f"theorem MemoryState.readLimbs_{st}_{f} (h : m.{room} p) :")
        w(f"    (m.{st} p P).readLimbs {o} = P.{f} :=")
        w(f"  readLimbs_store{c}_{i} h\n")
    w("@[mlir_frame, mlir_erase]")
    w(f"theorem MemoryState.eraseFrom_{st} : (m.{st} p P).eraseFrom n = (m.eraseFrom n).{st} p P :=")
    w(f"  eraseFrom_store{c}\n")
    w("@[mlir_frame, mlir_erase]")
    w(f"theorem MemoryState.{st}_eraseFrom_of_le (h : n ≤ p.id.id) :")
    w(f"    (m.eraseFrom n).{st} p P = m.eraseFrom n :=")
    w(f"  store{c}_eraseFrom_of_le h\n")
    w(f"/-- A `{rust}` store into a block the erase removes: dropped before the erase moves inward. -/")
    w("@[mlir_erase high]")
    w(f"theorem MemoryState.eraseFrom_{st}_of_le (h : n ≤ p.id.id) :")
    w(f"    (m.{st} p P).eraseFrom n = m.eraseFrom n := by")
    w(f"  rw [eraseFrom_{st}, {st}_eraseFrom_of_le h]\n")
    w(f"end {n}\n")

for (n, S, fs, c, fit, room, rust) in objs:
    rd = f"read{n}"
    st = f"store{n}"
    w(f"/-! ### `{rust}` reads -/\n")
    w(f"section Read{n}\n")
    w(f"variable {{m : MemoryState}} {{p q : Pointer}}\n")
    rws = ", ".join(f"readLimbs_{st}_{f} h" for f in fs)
    w("@[mlir_read]")
    w(f"theorem MemoryState.{rd}_{st}_self {{P : {S}}} (h : m.{room} p) : (m.{st} p P).{rd} p = P := by")
    w(f"  rw [MemoryState.{rd}, {rws}]\n")
    for (n2, S2, _, _, _, _, _) in objs:
        st2 = f"store{n2}"
        w("@[mlir_read]")
        w(f"theorem MemoryState.{rd}_{st2}_of_id_ne {{P : {S2}}} (h : p.id ≠ q.id) :")
        w(f"    (m.{st2} p P).{rd} q = m.{rd} q := by")
        w("  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h")
        w(f"  simp only [MemoryState.{rd}, readLimbs_{st2}_of_id_ne h, readLimbs_{st2}_of_id_ne (h' _)]\n")
    w("@[mlir_read]")
    w(f"theorem MemoryState.{rd}_storeLimbs_of_id_ne (h : p.id ≠ q.id) :")
    w(f"    (m.storeLimbs p l).{rd} q = m.{rd} q := by")
    w("  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h")
    w(f"  simp only [MemoryState.{rd}, readLimbs_storeLimbs_of_id_ne h,")
    w("    readLimbs_storeLimbs_of_id_ne (h' _)]\n")
    w("@[mlir_read]")
    w(f"theorem MemoryState.{rd}_storeAt_of_id_ne {{x : BitVec w}} (h : p.id ≠ q.id) :")
    w(f"    (m.storeAt p x).{rd} q = m.{rd} q := by")
    w("  have h' (k : BitVec 64) : p.id ≠ (q.add k).id := by simpa [Pointer.add_id] using h")
    w(f"  simp only [MemoryState.{rd}, Agave.readLimbs_storeAt_of_id_ne h,")
    w("    Agave.readLimbs_storeAt_of_id_ne (h' _)]\n")
    w(f"/-- A `{rust}` elsewhere is unaffected by `alloca`. -/")
    w("@[mlir_frame, mlir_read]")
    w(f"theorem MemoryState.{rd}_alloca {{s : GlobalState}} (hne : p.id ≠ s.allocaPtr.id) :")
    w(f"    (s.alloca n d).mem.{rd} p = s.mem.{rd} p := by")
    w("  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by")
    w("    simpa [Pointer.add_id] using hne")
    w(f"  simp only [MemoryState.{rd}, readLimbs_alloca hne, readLimbs_alloca (hne' _)]\n")
    w("@[mlir_read]")
    w(f"theorem MemoryState.{rd}_lifetimeStart : (m.lifetimeStart q).{rd} p = m.{rd} p := by")
    w(f"  simp only [MemoryState.{rd}, readLimbs_lifetimeStart]\n")
    w("@[mlir_read]")
    w(f"theorem MemoryState.{rd}_lifetimeEnd : (m.lifetimeEnd q).{rd} p = m.{rd} p := by")
    w(f"  simp only [MemoryState.{rd}, readLimbs_lifetimeEnd]\n")
    w("@[mlir_read]")
    w(f"theorem MemoryState.{rd}_addBlock_of_id_ne {{x : BitVec v}} (h : p.id ≠ b) :")
    w(f"    (m.addBlock b n x).{rd} p = m.{rd} p := by")
    w("  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h")
    w(f"  simp only [MemoryState.{rd}, readLimbs_addBlock_of_id_ne h,")
    w("    readLimbs_addBlock_of_id_ne (h' _)]\n")
    w(f"end Read{n}\n")

w("""-- last among the transports: tried after the structural ones, which carry a `…Room` fact
-- directly, so they do not search the `…Fit` facts first
attribute [-mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room

attribute [mlir_transport] MemoryState.LimbsFit.room MemoryState.PointFit.room
  MemoryState.ProjectiveFit.room

end

end MLIR
""")

open(out, "w").write(core.rstrip() + "\n\n" + "\n".join(L))
