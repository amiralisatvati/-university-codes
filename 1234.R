set.seed(20)

n <- 100
data <- runif(n, min = 0, max = 1)
k=10 
tol <- seq(0, 1, by = 1/k)
oi<- table(cut(data, breaks = tol, include.lowest = TRUE))
ei <- rep(1/k, k)
chisq.test(x = oi, p = ei)




ks<- ks.test(data, "punif")
ks







Data<- sort(Data)
n <- length(Data) 
i <- 1:n      
Data



Dp <-  max((i/n) - Data)
Dp



Dm <-max(Data - ((i-1)/n)) 
Dm


D_manual <- max(Dp, Dm)
D_manual






