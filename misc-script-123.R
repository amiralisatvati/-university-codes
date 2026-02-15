# --------------------------------------------------
# بخش ۱: داده‌های نمونه
# (!! شما باید این بخش را با داده‌های واقعی خود جایگزین کنید !!)
# --------------------------------------------------
set.seed(42) # برای تکرارپذیری
n <- 10000   # فرض کنید 10000 داده داریم

# تولید 10000 عدد 5 رقمی تصادفی (به صورت رشته متن)
# sprintf("%05d", ...) تضمین می‌کند که اعداد مثل 00123 هم 5 رقمی باشند
raw_data_strings <- sprintf("%05d", sample(0:99999, n, replace = TRUE))

# نمایش چند داده نمونه
# print(head(raw_data_strings))
# [1] "91481" "93707" "28609" "83045" "64550" "52153"

# --------------------------------------------------
# بخش ۲: تابع کمکی برای دسته‌بندی (قلب منطق پوکر)
# --------------------------------------------------
# این تابع یک عدد ۵ رقمی (به صورت رشته) گرفته و دسته آن را برمی‌گرداند
get_poker_category <- function(num_str) {
  
  # 1. رشته را به ارقام جدا تبدیل کن: "12133" -> c("1", "2", "1", "3", "3")
  digits <- strsplit(num_str, "")[[1]]
  
  # 2. فراوانی هر رقم را بشمار
  # table() -> 1:2, 2:1, 3:2
  digit_counts <- table(digits)
  
  # 3. فقط به تعداد تکرارها نگاه کن (نه خود ارقام)
  # as.vector() -> c(2, 1, 2)
  counts <- as.vector(digit_counts)
  
  # 4. تکرارها را مرتب کن تا الگو را پیدا کنیم: c(2, 2, 1)
  sorted_counts <- sort(counts, decreasing = TRUE)
  
  # 5. الگو را به یک رشته تبدیل کن: "221"
  key <- paste(sorted_counts, collapse = "")
  
  # 6. بر اساس الگو، دسته را مشخص کن
  if (key == "11111") {
    return("5 Distinct")
  } else if (key == "2111") {
    return("1 Pair")
  } else if (key == "221") {
    return("2 Pairs")
  } else if (key == "311") {
    return("3 of a Kind")
  } else {
    # شامل: Full House (32), 4 of a Kind (41), 5 of a Kind (5)
    return("Other")
  }
}

# تست تابع
# print(get_poker_category("12345")) # "5 Distinct"
# print(get_poker_category("11234")) # "1 Pair"
# print(get_poker_category("11223")) # "2 Pairs"
# print(get_poker_category("11123")) # "3 of a Kind"
# print(get_poker_category("11122")) # "Other" (Full House)
# print(get_poker_category("11111")) # "Other" (5 of a Kind)

# --------------------------------------------------
# بخش ۳: اعمال تابع و شمارش فراوانی‌ها
# --------------------------------------------------

# 1. تابع بالا را روی *تمام* داده‌های خام خود اجرا کن
# sapply() این کار را به صورت خودکار برای ما انجام می‌دهد
all_categories <- sapply(raw_data_strings, get_poker_category)

# (all_categories حالا یک وکتور طولانی است: ["5 Distinct", "1 Pair", "1 Pair", ...])

# 2. تعریف ترتیب استاندارد دسته‌ها (بسیار مهم!)
# این ترتیب *باید* با ترتیب احتمالات نظری شما یکی باشد
category_order <- c("5 Distinct", "1 Pair", "2 Pairs", "3 of a Kind", "Other")

# 3. تبدیل به Factor (عامل) برای حفظ ترتیب
# این کار تضمین می‌کند که table() خروجی را به ترتیب دلخواه ما بدهد
all_categories_factor <- factor(all_categories, levels = category_order)

# 4. شمارش فراوانی‌ها!
# این همان وکتوری است که دنبالش بودید
observed_counts <- table(all_categories_factor)

print("--- فراوانی‌های مشاهده‌شده (O_i) ---")
print(observed_counts)

# --------------------------------------------------
# بخش ۴: اجرای نهایی آزمون
# --------------------------------------------------

# 1. تعریف احتمالات نظری (باید با category_order مطابقت داشته باشد)
theoretical_probs <- c(0.3024,   # 5 Distinct
                       0.5040,   # 1 Pair
                       0.1080,   # 2 Pairs
                       0.0720,   # 3 of a Kind
                       0.0136)   # Other

# 2. اجرای آزمون با فراوانی‌های محاسبه شده
test_result <- chisq.test(x = observed_counts, p = theoretical_probs)

print("--- نتایج نهایی آزمون پوکر ---")
print(test_result)
