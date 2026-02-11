# 🎓 University Codes - Statistical Computing & Data Mining

This repository contains practical projects and exercises from university courses in Statistical Computing, Simulation, and Data Mining.

## 📁 Folder Structure

### 🔬 Simulation_Projects (Chapter 4 & 5 Exercises)
Simulation exercises covering non-parametric tests and distribution simulations.

- **Simulation_Exercise_10.Rmd**: Non-parametric tests (Sign Test, Runs Test, Run Lengths)
- **Simulation_Chapter5_Exercise12.Rmd**: Weibull distribution simulation, discrete distributions, histogram simulation
- **Direct_Transformation_Methods.Rmd**: Inverse transform and Box-Muller methods for generating random variables

### 📈 Regression_Analysis (Regression Diagnostics & Assumptions)
Comprehensive regression analysis tools and diagnostic tests.

- **Multicollinearity_VIF_Analysis.Rmd**: VIF (Variance Inflation Factor) and Tolerance analysis for multicollinearity detection
- **Shiny_Regression_Assumption_Testing.R**: Interactive Shiny app for testing regression assumptions (6 statistical tests)
- **Shiny_Regression_Diagnostics.R**: Shiny app for advanced diagnostics (Cook's Distance, Leverage, DFFITS)
- **Pencil_Dataset_Analysis.Rmd**: Simple regression analysis on the Pencil dataset

### 📊 Data_Mining_Projects (Machine Learning)
Machine learning projects including classification and discrete data analysis.

- **Data_Mining_Exercise_2.Rmd**: CART and Random Forest models for faculty rank prediction (87.8% - 90% accuracy)
- **Discrete_Data_Analysis.Rmd**: 5 types of visualizations (Bar, Polar, Treemap, Heatmap, Radar charts)

### 🎲 Probability_Process (Stochastic Processes & Markov Chains)
Stochastic process simulations including Markov chains and random walk.

- **Stochastic_Process_Exercise.Rmd**: Markov chain simulation, absorbing/transient states, Bernoulli process, Random Walk simulation

### 🧪 Exam_and_Labs (Exercises & Quizzes)
Short exercises and lab assignments.

- **Exam_1.R**: Quiz covering regression through origin, switch functions, and random number generation

## 🚀 How to Run

```r
# Install required packages
install.packages(c("ggplot2", "dplyr", "randomForest", "shiny", "car", "DescTools", "nortest", "lmtest"))

# Run Rmd files
rmarkdown::render("Simulation_Projects/Simulation_Exercise_10.Rmd")

# Run Shiny apps
shiny::runApp("Regression_Analysis/Shiny_Regression_Assumption_Testing.R")
```

## 📚 Topics Covered

- **Statistical Tests**: Sign Test, Runs Test, Shapiro-Wilk, Kolmogorov-Smirnov, Lilliefors, Anderson-Darling, Breusch-Pagan, Durbin-Watson
- **Simulation Methods**: Inverse Transform, Box-Muller, Weibull Distribution, Discrete Distributions
- **Regression Analysis**: Multicollinearity detection, VIF, Tolerance, Cook's Distance, Leverage, Residual Analysis
- **Machine Learning**: CART Decision Trees, Random Forest, Confusion Matrix, Variable Importance
- **Stochastic Processes**: Markov Chains, Random Walk, Bernoulli Process

## 📞 Contact
[GitHub Profile](https://github.com/amiralisatvati) | [LinkedIn](https://www.linkedin.com/in/amirali-satvati/)

## 📜 License
This project is licensed under the MIT License.

---
*Last Updated: February 2026*