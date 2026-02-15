gibbs_sampler <- function(n, y1) {
 
  x_out <- numeric(n)
  y_out <- numeric(n)
  
 
  cy <- y1
  
  for (i in 1:n) {
   
    cx <- runif(1, min = 0, max = cy)
 
    cy <- runif(1, min = 0, max = cx)
    x_out[i] <- cx
    y_out[i] <- cy
  }
  

  return(data.frame(X = x_out, Y = y_out))
}


r <- gibbs_sampler(100, 1)
print(r)


plot(1:n, r$X, type = "b", col = "blue", pch = 19)
