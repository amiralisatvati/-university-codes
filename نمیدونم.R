library(leaps)
library(qpcR)
data <- data.frame(
  y  = c(410, 569, 425, 344, 324, 505, 235, 501, 400, 584, 434),
  x1 = c(69, 57, 77, 81, 0, 53, 77, 76, 65, 97, 76),
  x2 = c(125, 131, 141, 122, 141, 152, 141, 132, 157, 166, 131),
  x3 = c(96, 95, 99, 98, 106, 110, 97, 98, 95, 120, 130),
  x4 = c(3.7, 3.64, 3.12, 2.22, 1.57, 3.33, 2.48, 3.10, 3.07, 3.61, 3.51),
  x5 = c(59.00, 31.75, 80.50, 75, 49, 49.35, 60.70, 41.25, 50.70, 32.25, 54.5),
  x6 = c(52.5, 56, 44, 37.3, 48.8, 40.2, 44, 66.3, 37.3, 62.4, 61.9),
  x7 = c(55.66, 63.97, 45.32, 46.67, 41.21, 43.83, 41.61, 64.57, 42.41, 57.95, 57.90)
)
n=length(data$y)
model_a <- lm(y ~ x1 + x2 + x3 + x4, data = data)                         # مدل الف
model_b <- lm(y ~ x5 + x6 + x7, data = data)                             # مدل ب
model_full <- lm(y ~ x1 + x2 + x3 + x4 + x5 + x6 + x7, data = data)      # مدل کامل (ج)

# محاسبه سیگما برای Cp از مدل کامل
sigma2_full <- mean((data$y - predict(model_full))^2)

# تابع محاسبه PRESS و P-square
PRESS_stat <- function(model) {
  pr <- PRESS(model)
  return(c(press = pr$stat, p2 = pr$P.square))
}

# تابع محاسبه Mallows' Cp
calc_cp <- function(model, sigma2) {
  rss <- sum(residuals(model)^2)
  p <- length(coef(model))
  cp <- rss / sigma2 - (n - 2 * p)
  return(cp)
}

# تابع محاسبه R² و Adjusted R²
get_r2 <- function(model) {
  return(c(R2 = summary(model)$r.squared, R2adj = summary(model)$adj.r.squared))
}

# ساخت جدول نهایی نتایج
results <- data.frame(
  Model = c("A (x1-x4)", "B (x5-x7)", "C(full)"),
  PRESS = c(PRESS_stat(model_a)["press"], PRESS_stat(model_b)["press"], PRESS_stat(model_full)["press"]),
  P_square = c(PRESS_stat(model_a)["p2"], PRESS_stat(model_b)["p2"], PRESS_stat(model_full)["p2"]),
  Cp = c(calc_cp(model_a, sigma2_full), calc_cp(model_b, sigma2_full), calc_cp(model_full, sigma2_full)),
  R_squared = c(get_r2(model_a)["R2"], get_r2(model_b)["R2"], get_r2(model_full)["R2"]),
  Adj_R_squared = c(get_r2(model_a)["R2adj"], get_r2(model_b)["R2adj"], get_r2(model_full)["R2adj"])
)

# نمایش نتایج
print(results)




# مدل کامل
I_all <- regsubsets(y ~ x1 + x2 + x3 + x4 + x5 + x6 + x7, data = data, int = TRUE, nbest = 7)

# فقط x1 تا x4 (مدل A)
I_a <- regsubsets(y ~ x1 + x2 + x3 + x4, data = data, int = TRUE, nbest = 4)

# فقط x5 تا x7 (مدل B)
I_b <- regsubsets(y ~ x5 + x6 + x7, data = data, int = TRUE, nbest = 3)

par(mfrow = c(1, 3))
plot(I_all, scale = "Cp")       # نمودار مالوس Cp
plot(I_all, scale = "r2")       # نمودار R-squared
plot(I_all, scale = "adjr2")    # نمودار Adjusted R-squared


plot(I_a, scale = "Cp")         # نمودار مالوس Cp
plot(I_a, scale = "r2")         # نمودار R-squared
plot(I_a, scale = "adjr2")      # نمودار Adjusted R-squared


plot(I_b, scale = "Cp")         # نمودار مالوس Cp
plot(I_b, scale = "r2")         # نمودار R-squared
plot(I_b, scale = "adjr2")      # نمودار Adjusted R-squared
par(mfrow = c(1, 1))

par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))

barplot(results$PRESS, names.arg = results$Model, main = "PRESS", col = "skyblue")
barplot(results$P_square, names.arg = results$Model, main = "P-square", col = "lightgreen")
barplot(results$Cp, names.arg = results$Model, main = "Mallows' Cp", col = "orange")
barplot(results$Adj_R_squared, names.arg = results$Model, main = "Adjusted R-squared", col = "plum")






#summary(model_a)
#PRESS_stat(model_a)
#calc_cp(model_a, sigma2_full)

#summary(model_b)
#PRESS_stat(model_b)
#calc_cp(model_b, sigma2_full)

#summary(model_full)
#PRESS_stat(model_full)
#calc_cp(model_full, sigma2_full)









