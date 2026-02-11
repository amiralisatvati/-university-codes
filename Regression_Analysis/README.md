# Regression Analysis

This folder contains regression analysis projects focusing on diagnostics and assumption testing.

## Files

- **Multicollinearity_VIF_Analysis.Rmd**: Multicollinearity examination
  - VIF (Variance Inflation Factor) calculation
  - Tolerance calculation
  - Outlier detection using Hat Matrix
  - Influential points detection using Cook's Distance

- **Shiny_Regression_Assumption_Testing.R**: Interactive Shiny application
  - CSV upload and variable selection
  - 6 statistical tests: Shapiro-Wilk, Kolmogorov-Smirnov, Lilliefors, Anderson-Darling, Breusch-Pagan, Durbin-Watson
  - Diagnostic plots: Histogram, QQ-Plot, Residual Plot, ACF

- **Shiny_Regression_Diagnostics.R**: Advanced diagnostic Shiny app
  - Cook's Distance, Leverage, DFFITS calculations
  - Diagnostic plots download
  - CSV export of results

- **Pencil_Dataset_Analysis.Rmd**: Simple regression analysis on pencil dataset
