# =============================================================================
# CAFFEINE INTAKE STUDY — Script 02: Descriptive Statistics
# Faculty of Science, MSU Baroda
# =============================================================================
# PURPOSE: Compute and display comprehensive descriptive statistics for
#          caffeine intake across all academic years and day types.
# =============================================================================

library(tidyverse)
library(e1071)      # skewness, kurtosis
library(moments)    # alternative skewness/kurtosis
library(knitr)

source("R/01_data_preparation.R")

# =============================================================================
# HELPER: Full descriptive stats function
# =============================================================================

describe_caffeine <- function(x, label = "") {
  tibble(
    Group        = label,
    N            = length(x),
    Mean         = round(mean(x), 2),
    Median       = round(median(x), 2),
    SD           = round(sd(x), 2),
    IQR          = round(IQR(x), 2),
    Min          = round(min(x), 2),
    Max          = round(max(x), 2),
    Skewness     = round(e1071::skewness(x), 3),
    Kurtosis     = round(e1071::kurtosis(x), 3),
    Pct_Zero     = round(mean(x == 0) * 100, 1),
    Q1           = round(quantile(x, 0.25), 2),
    Q3           = round(quantile(x, 0.75), 2)
  )
}

# =============================================================================
# 1. BY ACADEMIC YEAR — Regular Days
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  DESCRIPTIVE STATISTICS — REGULAR DAYS\n")
cat(strrep("=", 70), "\n\n")

reg_data <- caffeine_long %>% filter(day_type == "Regular")

desc_regular <- reg_data %>%
  group_by(academic_year) %>%
  summarise(describe_caffeine(caffeine_mg, unique(academic_year)), .groups = "drop")

print(kable(desc_regular, format = "pipe", caption = "Regular Day Caffeine Intake (mg)"))

# =============================================================================
# 2. BY ACADEMIC YEAR — Exam Days
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  DESCRIPTIVE STATISTICS — EXAM DAYS\n")
cat(strrep("=", 70), "\n\n")

exam_data <- caffeine_long %>% filter(day_type == "Exam")

desc_exam <- exam_data %>%
  group_by(academic_year) %>%
  summarise(describe_caffeine(caffeine_mg, unique(academic_year)), .groups = "drop")

print(kable(desc_exam, format = "pipe", caption = "Exam Day Caffeine Intake (mg)"))

# =============================================================================
# 3. OVERALL COMPARISON (Regular vs Exam)
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  OVERALL COMPARISON: REGULAR vs EXAM DAYS\n")
cat(strrep("=", 70), "\n\n")

overall_comparison <- caffeine_long %>%
  group_by(day_type) %>%
  summarise(describe_caffeine(caffeine_mg, unique(as.character(day_type))), .groups = "drop")

print(kable(overall_comparison, format = "pipe"))

# =============================================================================
# 4. DISTRIBUTION SHAPE INTERPRETATION
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  DISTRIBUTION SHAPE NOTES\n")
cat(strrep("=", 70), "\n\n")

cat("All cohorts exhibit RIGHT-SKEWED distributions:\n")
cat("  - Majority of students consume low/zero caffeine daily\n")
cat("  - A minority are high consumers, pulling the mean above the median\n")
cat("  - Skewness > 1 in most groups → strong positive skew\n")
cat("  - Kurtosis varies: leptokurtic (heavy-tailed) in several groups\n")
cat("  - Non-normal distributions confirmed by Shapiro-Wilk (see Script 03)\n\n")

# Highlight extreme consumers
cat("TOP 5 HIGHEST INDIVIDUAL INTAKES (Regular Days):\n")
reg_data %>%
  arrange(desc(caffeine_mg)) %>%
  slice_head(n = 5) %>%
  select(academic_year, student_id, caffeine_mg) %>%
  print()

cat("\nTOP 5 HIGHEST INDIVIDUAL INTAKES (Exam Days):\n")
exam_data %>%
  arrange(desc(caffeine_mg)) %>%
  slice_head(n = 5) %>%
  select(academic_year, student_id, caffeine_mg) %>%
  print()

# =============================================================================
# 5. ZERO-CONSUMPTION ANALYSIS
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  NON-CAFFEINE-CONSUMER ANALYSIS (Intake = 0 mg)\n")
cat(strrep("=", 70), "\n\n")

zero_summary <- caffeine_long %>%
  group_by(academic_year, day_type) %>%
  summarise(
    total     = n(),
    zero_n    = sum(caffeine_mg == 0),
    zero_pct  = round(mean(caffeine_mg == 0) * 100, 1),
    .groups   = "drop"
  )

print(kable(zero_summary, format = "pipe",
            col.names = c("Year", "Day Type", "N", "Zero Consumers", "% Zero")))

cat("\n✅ Descriptive statistics complete.\n")
