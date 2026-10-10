import random
def slide(a):
    r=[(a>>i)&1 for i in range(256)]
    for i in range(256):
        if r[i]:
            b=1
            while b<=6 and i+b<256:
                if r[i+b]:
                    if r[i]+(r[i+b]<<b)<=15:
                        r[i]+=r[i+b]<<b; r[i+b]=0
                    elif r[i]-(r[i+b]<<b)>=-15:
                        r[i]-=r[i+b]<<b
                        k=i+b
                        while k<256:
                            if not r[k]: r[k]=1; break
                            r[k]=0; k+=1
                    else: break
                b+=1
    return r
def check(a):
    r=slide(a)
    s=sum(d<<i for i,d in enumerate(r))
    ok=all(d==0 or (d%2==1 and abs(d)<=15) for d in r)
    zr=all(not(r[i]) or all(r[j]==0 for j in range(i+1,min(i+5,256))) for i in range(256))
    return s==a, ok, zr
bad=[]
tests=[2**255-1,2**256-1,2**255,2**254-1,2**253-1]+[random.getrandbits(256) for _ in range(20000)]+[random.getrandbits(255) for _ in range(20000)]
# adversarial: dense high bits
for _ in range(20000):
    x=random.getrandbits(256)|((2**256-1)^(2**random.randint(200,256)-1))
    tests.append(x % 2**256)
    tests.append(x % 2**255)
for a in tests:
    s,ok,zr=check(a)
    if not (s and ok and zr): bad.append((a.bit_length(),s,ok,zr))
from collections import Counter
print(len(tests), Counter(bad).most_common(10))
bad2=0
for _ in range(200000):
    x=random.getrandbits(255)
    k=random.randint(230,255)
    x|=(2**255-1)^(2**k-1)
    if not all(check(x)): bad2+=1; print(hex(x)); break
print('bad2',bad2)
