import random
def run(a):
    r=[(a>>i)&1 for i in range(256)]
    lo=0;hi=0
    for i in range(256):
        L=sum(r[j]<<j for j in range(0,i)); lo=min(lo,L/2**i); hi=max(hi,L/2**i)
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
    return lo,hi
LO=0;HI=0
for _ in range(5000):
    x=random.getrandbits(255)
    l,h=run(x); LO=min(LO,l); HI=max(HI,h)
print(LO,HI)
