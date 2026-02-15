"صورت مسئله: شبیه‌سازی توزیع نرمال دو متغیره با روش‌های MCMCهدف: تولید نمونه‌های تصادفی از یک توزیع نرمال دو متغیره با میانگین صفر و بررسی همگرایی آن به توزیع حاشیه‌ای (Marginal Distribution) متغیر $X$.۱. مشخصات توزیع هدففرض کنید بردار تصادفی $(X, Y)$ دارای توزیع نرمال دو متغیره با پارامترهای زیر است:میانگین: $\mu_X = 0, \mu_Y = 0$واریانس: $\sigma^2_X = 1, \sigma^2_Y = 1$ضریب همبستگی: $\rho = 0.95$تابع چگالی مشترک این توزیع که باید در الگوریتم متروپولیس استفاده شود، به صورت زیر تعریف می‌شود:$$f(x, y) \propto \exp \left( -\frac{1}{2(1-\rho^2)} (x^2 + y^2 - 2\rho xy) \right)$$۲. بخش اول: الگوریتم متروپولیس-هستینگز (M-H)با استفاده از یک گشت تصادفی (Random Walk) به عنوان تابع پیشنهاد، نمونه‌هایی از توزیع فوق تولید کنید:تابع پیشنهاد: $q(x', y' | x, y) \sim U(current \pm 0.5)$تعداد تکرار: $n = 10,000$مطلوب است: محاسبه نرخ پذیرش (Acceptance Rate) و رسم توزیع حاصل.۳. بخش دوم: نمونه‌گیر گیبس (Gibbs Sampler)با استفاده از ویژگی‌های شرطی توزیع نرمال، الگوریتم گیبس را پیاده‌سازی کنید. در این روش طبق متن، از توابع چگالی شرطی برای تولید مقادیر جدید استفاده می‌شود:توزیع شرطی اول: $X | Y=y \sim N(\rho y, 1-\rho^2)$توزیع شرطی دوم: $Y | X=x \sim N(\rho x, 1-\rho^2)$مطلوب است: تولید زنجیره‌ای از مقادیر $(X_k, Y_k)$ و اثبات همگرایی آن به توزیع مانا (Stationary Distribution) طبق رابطه $f P_{X|X} = f$.۴. مقایسه و تحلیلپس از اجرای هر دو الگوریتم:نمودار هیستوگرام متغیر $X$ را برای هر دو روش رسم کرده و با توزیع نرمال استاندارد مقایسه کنید.توضیح دهید چرا در روش گیبس نرخ پذیرش همواره ۱۰۰٪ است، در حالی که در متروپولیس این‌گونه نیست."


mh <- function(n = 5000, rho = 0.9, step_size = 0.5) {

  samples <- matrix(0, nrow = n, ncol = 2)
  colnames(samples) <- c("x", "y")
  accept_count <- 0
  

  target <- function(v) {
    exp(-(v[1]^2 + v[2]^2 - 2*rho*v[1]*v[2]) / (2*(1 - rho^2)))
  }
  
  for (i in 2:n) {
    current_point <- samples[i-1, ]
    proposal <- current_point + runif(2, -step_size, step_size)
    
   
    ratio <- target(proposal) / target(current_point)
    
    if (runif(1) < ratio) {
      samples[i, ] <- proposal
      accept_count <- accept_count + 1
    } else {
      samples[i, ] <- current_point
    }
  }
  
  cat("نرخ پذیرش M-H:", (accept_count /n ) * 100, "%\n")
  return(as.data.frame(samples))
}
mh(n = 10000, rho = 0.95)



gibbs <- function(n = 5000, rho = 0.9) {
 
  samples <- matrix(0, nrow = n, ncol = 2)
  colnames(samples) <- c("x", "y")
  sigma_cond <- sqrt(1 - rho^2)
  
  for (i in 2:n) {

    curr_y <- samples[i-1, 2]
    samples[i, 1] <- rnorm(1, mean = rho * curr_y, sd = sigma_cond)
    
  
    curr_x <- samples[i, 1]
    samples[i, 2] <- rnorm(1, mean = rho * curr_x, sd = sigma_cond)
  }
  
  cat("در روش گیبس تمام نمونه‌ها پذیرفته شدند (نرخ ۱۰۰٪).\n")
  return(as.data.frame(samples))
}
gibbs(n = 10000, rho = 0.95)


result_mh <- mh(n = 10000, rho = 0.95)
result_gibbs <- gibbs(n = 10000, rho = 0.95)


par(mfrow=c(1,2))


hist(result_mh$x, main="توزیع X (Metropolis)", col="tomato", breaks=30, xlab="X")
hist(result_gibbs$x, main="توزیع X (Gibbs)", col="skyblue", breaks=30, xlab="X")

