set.seed(123)
n <- 20
alpha <- 2
xm <- 1

mom <- numeric(100)
mle <- numeric(100)

for (i in 1:100) {
  u <- runif(n)
  x <- xm / (u^(1/alpha))
  
  x_bar <- mean(x)
  mom[i] <- x_bar / (x_bar - xm)
  
  log_sum <- sum(log(x / xm))
  mle[i] <- n / log_sum
}


# 1. محاسبه اریبی (Bias)

 mean(mom) - alpha
 mean(mle) - alpha

# 2. محاسبه میانگین مربعات خطا (MSE)
# MSE 
 mean((mom - alpha)^2)
 mean((mle - alpha)^2)


# رسم نمودار جعبه‌ای برای مقایسه چشمی
boxplot(mom, mle,  col = c("lightblue", "lightgreen"))
abline(h = alpha, col = "red", lty = 2, lwd = 2) 





n <- 30
lambda <- 4

mom <- numeric(100)
mle <- numeric(100)

for(i in 1:100){
  x <- rpois(n, lambda)
  
  mom[i] <- mean(x)
  mle[i] <- mean(x) 
}

mean(mom) - lambda
mean(mle) - lambda
mean((mom - lambda)^2)
mean((mle - lambda)^2)