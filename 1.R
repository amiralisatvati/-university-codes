generate_lcg_stop_at <- function(N, m, a, b, seed, stop_value) {
  # بخش ۱ و ۲: بارگذاری پکیج و بررسی شرایط اولیه (بدون تغییر)
  if (!requireNamespace("numbers", quietly = TRUE)) {
    install.packages("numbers")
  }
  library(numbers)
  # ... (تمام بررسی‌های قضیه هال-دابل در اینجا وجود دارند اما برای خلاصه شدن حذف شده‌اند) ...
  # شما باید کدهای مربوط به بررسی شرایط را از پاسخ قبلی اینجا قرار دهید.
  
  # بخش ۳: ایجاد دنباله اعداد با شرط توقف
  x <- numeric(N)
  x[1] <- (a * seed + b) %% m
  
  # اگر اولین عدد همان مقدار توقف بود، دنباله فقط همین یک عدد است
  if (x[1] == stop_value) {
    x <- x[1] # کوتاه کردن وکتور
  } else {
    # حلقه برای تولید اعداد بعدی
    for (i in 2:N) {
      x[i] <- (a * x[i - 1] + b) %% m
      
      # شرط توقف در صورت تولید عدد صفر
      if (x[i] == 0) {
        x <- x[1:(i-1)] # وکتور را تا قبل از صفر کوتاه کن
        warning(paste0("تولید عدد 0 در مرحله ", i, ". دنباله متوقف شد."))
        break
      }
      
      # --- تغییر کلیدی: شرط توقف برای مقدار مشخص شده ---
      if (x[i] == stop_value) {
        x <- x[1:i] # وکتور را تا همین عدد (شامل خودش) کوتاه کن
        break       # از حلقه خارج شو
      }
    }
  }
  
  # اگر حلقه بدون پیدا کردن مقدار توقف تمام شد، ممکن است وکتور شامل صفرهای اضافی باشد
  # پس آن را تمیز می‌کنیم
  x <- x[x != 0 | cumsum(x != 0) > 0] # حذف صفرهای انتهایی در صورت عدم توقف
  
  # بخش ۴ و ۵: نرمال‌سازی، رسم هیستوگرام و برگرداندن خروجی
  u <- x / m
  
  # فقط در صورتی که عددی تولید شده باشد هیستوگرام را رسم کن
  if (length(u) > 0) {
    hist(u, 
         main = paste("Histogram of LCG (stopped at", stop_value, ")"),
         xlab = "Value (u)",
         ylab = "Frequency",
         col = "skyblue",
         border = "darkblue")
  } else {
    print("هیچ عددی برای رسم هیستوگرام تولید نشد.")
  }
  
  return(list(integer_sequence = x, uniform_sequence = u))
}

# تعریف پارامترها
N_max <- 100        # حداکثر تعداد اعداد برای تولید
modulus_m <- 16
multiplier_a <- 5
increment_b <- 3
start_seed <- 7
value_to_stop <- 11 # مقدار توقف

# فراخوانی تابع جدید
results_stopped <- generate_lcg_stop_at(N = N_max,
                                        m = modulus_m,
                                        a = multiplier_a,
                                        b = increment_b,
                                        seed = start_seed,
                                        stop_value = value_to_stop)

# چاپ نتایج
print("Generated sequence until 11 was found:")
print(results_stopped$integer_sequence)
