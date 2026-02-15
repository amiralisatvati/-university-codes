f <- function(N, m, a, b, seed) {

  if (!requireNamespace("numbers", quietly = TRUE)) {
    install.packages("numbers")
  }
  library(numbers)
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
 
  x <- numeric(N + 1)
  x[1] <- seed
  last_index <- 1
  
  for (i in 1:N) {
    new_val <- (a * x[i] + b) %% m
    
    if (new_val == 0) {
      
      last_index <- i 
      break
    }
    
    x[i+1] <- new_val
    last_index <- i + 1
  }
  
  
  
  u <- (x[2:last_index]) / m
  
  
  # 1. اطمینان از نصب و بارگذاری پکیج ggplot2
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    install.packages("ggplot2")
  }
  library(ggplot2)
  
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    install.packages("ggplot2")
  }
  library(ggplot2)
  
  df <- data.frame(values = u)
  mean_u <- mean(df$values)
  
  # --- بخش اصلاح‌شده نمودار ---
  
  # 1. نمودار را به یک متغیر اختصاص دهید (مثلاً p)
  p1 <- ggplot(df, aes(x = values)) +
    geom_histogram(aes(y = ..density..), 
                   binwidth = 0.1,
                   fill = "#4c72b0",
                   color = "white",
                   alpha = 0.8) +
    geom_density(alpha = 0.4,
                 fill = "#dd8452",
                 color = "#c44e52",
                 linewidth = 1) +
    geom_vline(aes(xintercept = mean_u),
               color = "#55a868",
               linetype = "dashed",
               linewidth = 1.2) +
    annotate("text", 
             x = mean_u * 1.05,
             y = max(density(df$values)$y) * 0.9,
             label = paste("Mean =", round(mean_u, 2)),
             color = "#55a868",
             size = 4,
             fontface = "bold") +
    labs(title = "Distribution of Generated Numbers",
         subtitle = "Histogram with Density Curve and Mean",
         x = "Generated Value (u)",
         y = "Density") +
    theme_minimal(base_size = 15) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          plot.subtitle = element_text(hjust = 0.5))
  
  # 2. به صراحت دستور پرینت را برای نمایش نمودار اجرا کنید
  
  
  lag_df <- data.frame(u_i = u[-length(u)], u_i_plus_1 = u[-1])
  p2 <- ggplot(lag_df, aes(x = u_i, y = u_i_plus_1)) +
    geom_point(alpha = 0.6, color = "#4c72b0") +
    labs(title = "Lag Plot", subtitle = "Checking for independence", x = "u[i]", y = "u[i+1]") +
    theme_minimal(base_size = 14) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          plot.subtitle = element_text(hjust = 0.5))
  library(gridExtra)
  grid.arrange(p1, p2, ncol = 2)


  
  print("First 10 generated 'u' values:")
  print(head(u, 10))

  print("First 10 generated 'x' values:")
  return(x[2:last_index])
  
 
  
}






autoshiny::makeApp(f)
