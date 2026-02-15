
library(shiny)
library(autoshiny)
library(numbers)


f <- function(N=c(0:100), m=c(0:100), a=c(0:100), b=c(0:100), seed=c(0:100)) {
  
  N <- N[1]
  m <- m[1]
  a <- a[1]
  b <- b[1]
  seed <- seed[1]
  
  if (m < 2) {
    return("Error: 'm' must be greater than 1.")
  }
  if (N < 1) {
    return("Error: 'N' must be at least 1.")
  }
  
 
  if (!coprime(b, m)) {
    warning("Warning: b and m must be coprime.")
  }
  primefm <- tryCatch(unique(primeFactors(m)), error = function(e) NULL)
  if (!is.null(primefm) && !all((a - 1) %% primefm == 0)) {
    warning("Warning: (a-1) must be divisible by all prime factors of m.")
  }
  if (m %% 4 == 0) {
    if ((a - 1) %% 4 != 0) {
      warning("Warning: If m is divisible by 4, (a-1) must be as well.")
    }
  }
  

  x <- numeric(N + 1)
  x[1] <- seed
  index <- 1
  
  for (i in 1:N) {
    new_val <- (a * x[i] + b) %% m
    if (new_val == 0) {
      index <- i  
      break
    }
    x[i+1] <- new_val
    index <- i + 1
  }
  u <- (x[2:index]) / m
 
  return(list(
    Generated_Numbers = x[2:index],  
    Generated_U_Values = u          
  ))
}


autoshiny::makeApp(f, withGoButton = TRUE)
