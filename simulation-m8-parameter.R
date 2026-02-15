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





midSquareRand <- function(seed, len, D = 4) {
  
  if (D %% 2 != 0) {
    stop("tedad zoj")
  }
  
  randvector <- NULL
  
  L <- D / 2       
  power_L <- 10^L  
  power_D <- 10^D   
  
  for(i in 1:len) {
    
    value <- seed * seed 
    
   
    new_seed <- (floor(value / power_L)) %% power_D 
    
    randvector <- c(randvector, new_seed / power_D)
    
    
    seed <- new_seed 
  }
  
  return(randvector)
}


RmidSquare<- midSquareRand(seed = 3261, len = 20)
RmidSquare





