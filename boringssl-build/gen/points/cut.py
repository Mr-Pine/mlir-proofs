import sys
src, cut, dst = sys.argv[1], sys.argv[2], sys.argv[3]
s=open(src).read()
i=s.index(cut)
j=s.index("end Proof")
s=s[:i]+"  sorry\n\n"+s[j:]
open(dst,'w').write(s)
