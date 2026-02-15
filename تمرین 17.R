
sim_poisson <- function(L,p) {
  
  
  p <- p
  
  n <- max(30, (20*L))
  
  
  X <- rbinom(n = 1, size = n, prob = p)
  
  return(X)
}

replicate(10, sim_poisson(L = 3,0.05))


  
  
f_X <- function(x) {
  if (x >= 0 & x <= 1) {
    return(12 * (x^2) * (1 - x))
  } else {
    return(0)
  }
}

f_Y <- function(x) {
  if (x >= 0 & x <= 1) {
    return(1)
  } else {
    return(0)
  }
}

C <- 16 / 9

acbeta <- function(N) {
  samples <- numeric(N)  
  count <- 0             
  b <- 0 
  
  while (count < N) {
    b <- b + 1
    
    X_star <- runif(1, 0, 1)
    U <- runif(1, 0, 1)
    
    ratio <- f_X(X_star) / C
    
    if (U <= ratio) {
      count <- count + 1
      samples[count] <- X_star
    }
  }
  
 
  efficiency <- N / b

  
  N / b
  b
  round(efficiency, 4)
  round(1 / C, 4)
  
  return(samples)
}

acbeta(5)

length(acbeta(5))

