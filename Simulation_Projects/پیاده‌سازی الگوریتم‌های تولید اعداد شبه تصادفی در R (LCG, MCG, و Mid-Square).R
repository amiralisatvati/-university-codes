m=8
a=5
b=3
N=10
x=numeric(N+1)
x[1]=2
for(i in 1:N ){
x[i+1]=(a*x[i]+b) %% m
}
u=x/m

# mcg
m=17
a=5
b=0
N=10
x=numeric(N+1)
x[1]=1
for(i in 1:N ){
x[i+1]=(a*x[i]+b) %% m
}
u=x/m


# lcg
m=100
a=5
b=57
N=10
x=numeric(N+1)
x[1]=23
for(i in 1:N ){
x[i+1]=(a*x[i]+b) %% m
}
u=x/m

