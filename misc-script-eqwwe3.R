# --- بخش 1: تابع اصلی برای تولید اعداد (با هشدار به جای خطا) ---
generate_lcg <- function(N, m, a, b, seed) {
  # بررسی نصب بودن پکیج مورد نیاز
  if (!requireNamespace("numbers", quietly = TRUE)) {
    # اگر پکیج نصب نبود، آن را نصب می‌کنیم
    install.packages("numbers")
  }
  library(numbers)
  
  # --- اعتبارسنجی پارامترها با استفاده از warning ---
  if (!coprime(b, m)) {
    warning("هشدار: شرط اول نقض شد. b و m باید نسبت به هم اول باشند.")
  }
  
  primefm <- unique(primeFactors(m))
  if (!all((a - 1) %% primefm == 0)) {
    warning("هشدار: شرط دوم نقض شد. (a-1) بر تمام عوامل اول m بخش‌پذیر نیست.")
  }
  
  if (m %% 4 == 0) {
    if ((a - 1) %% 4 != 0) {
      warning("هشدار: شرط سوم نقض شد. m بر 4 بخش‌پذیر است، اما (a-1) نیست.")
    }
  }
  
  # --- تولید اعداد ---
  x <- numeric(N + 1)
  x[1] <- seed
  
  for (i in 1:N) {
    x[i+1] <- (a * x[i] + b) %% m
  }
  
  # برگرداندن یک لیست حاوی هر دو دنباله
  return(list(
    x = x[-1], # حذف مقدار seed اولیه
    u = x[-1] / m
  ))
}

# --- بخش 2: تابع برای بصری‌سازی (بدون تغییر) ---
plot_lcg_analysis <- function(u) {
  if (!requireNamespace("ggplot2", quietly = TRUE) || !requireNamespace("gridExtra", quietly = TRUE)) {
    install.packages(c("ggplot2", "gridExtra"))
  }
  library(ggplot2)
  library(gridExtra)
  
  df <- data.frame(values = u)
  mean_u <- mean(u)
  
  # نمودار 1: هیستوگرام و توزیع چگالی
  p1 <- ggplot(df, aes(x = values)) +
    geom_histogram(aes(y = ..density..), binwidth = 0.1, fill = "#4c72b0", color = "white", alpha = 0.8) +
    geom_density(alpha = 0.4, fill = "#dd8452", color = "#c44e52", linewidth = 1) +
    geom_vline(aes(xintercept = mean_u), color = "#55a868", linetype = "dashed", linewidth = 1.2) +
    geom_hline(yintercept = 1, color = "darkred", linetype = "dotted", linewidth = 1) +
    annotate("text", x = mean_u * 1.05, y = 1.5, label = paste("Mean =", round(mean_u, 2)), color = "#55a868", size = 4) +
    labs(title = "Distribution of Generated Numbers", x = "Value (u)", y = "Density") +
    theme_minimal(base_size = 14) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  
  # نمودار 2: نمودار تأخیر (Lag Plot)
  lag_df <- data.frame(u_i = u[-length(u)], u_i_plus_1 = u[-1])
  p2 <- ggplot(lag_df, aes(x = u_i, y = u_i_plus_1)) +
    geom_point(alpha = 0.6, color = "#4c72b0") +
    labs(title = "Lag Plot", subtitle = "Checking for independence", x = "u[i]", y = "u[i+1]") +
    theme_minimal(base_size = 14) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          plot.subtitle = element_text(hjust = 0.5))
  
  grid.arrange(p1, p2, ncol = 2)
}


# --- نحوه استفاده از کد جدید ---
# حالا می‌توانید پارامترهای اولیه خودتان را بدون توقف برنامه اجرا کنید
# توجه کنید که هشدارها در کنسول نمایش داده خواهند شد
generated_data <- generate_lcg(N = 1000, m = 10000, a = 22, b = 1, seed = 123)

# تحلیل و بصری‌سازی نتایج
# همانطور که در نمودار Lag Plot خواهید دید، الگوهای خطی مشخصی وجود دارد 
# که نشان‌دهنده کیفیت پایین این پارامترهاست.
plot_lcg_analysis(generated_data$u)

# مشاهده داده‌های خام
print("First 10 generated 'u' values:")
print(head(generated_data$u, 10))

