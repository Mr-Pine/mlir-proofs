import re,sys
txt=open(sys.argv[1]).read()
out=[]
for m in re.finditer(r'%(\d+) = "llvm.mlir.constant"\(\) <\{value = (-?\d+) : i(\d+)\}>',txt):
    k,v,w=int(m.group(1)),int(m.group(2)),int(m.group(3))
    v%= 1<<w
    out.append(f"%{k} := {v}#{w}")
print(", ".join(out))
