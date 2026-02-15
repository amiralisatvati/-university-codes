
set.seed(123)

n <- 1000

g_func <- function(x) {
  return(exp(exp(-x)))
}

xnormal <- rnorm(n, mean = 0, sd = 1)
g_func(x_normal)
mean(g_func(x_normal)) 

yc <- rcauchy(n, location = 0, scale = 1)

dnorm(yc)   # چگالی نرمال در نقاط y
dcauchy(yc) # چگالی کوشی در نقاط y
dnorm(yc)/dcauchy(yc)


values_b <- g_func(yc) * (dnorm(yc)/dcauchy(yc))


mean(values_b)


