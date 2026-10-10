import random
def slide_trace(a):
    r=[(a>>i)&1 for i in range(256)]
    mx=0; top=0
    for i in range(256):
        V=sum(r[j]<<j for j in range(i,256)); mx=max(mx,V/2**255)
        if r[255]: top+=1
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
    return mx,top
M=0;T=0
for _ in range(20000):
    x=random.getrandbits(255); k=random.randint(200,255); x|=(2**255-1)^(2**k-1)
    m,t=slide_trace(x); M=max(M,m); T=max(T,t)
print(M,T)
