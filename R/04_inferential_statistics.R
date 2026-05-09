# =============================================================================
# CAFFEINE INTAKE STUDY — Script 04: Inferential Statistics (Non-Parametric)
# Faculty of Science, MSU Baroda
# =============================================================================
# PURPOSE: Since data is non-normal (confirmed in Script 03), apply appropriate
#          non-parametric tests to compare caffeine intake across groups.
# =============================================================================

library(tidyverse)
library(coin)   # exact tests

source("R/01_data_preparation.R")

# =============================================================================
# 1. WILCOXON SIGNED-RANK TEST — Regular vs Exam (paired, per year)
# =============================================================================
# H₀: No difference in caffeine intake between regular and exam days
# H₁: Caffeine intake differs between regular and exam days
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  WILCOXON SIGNED-RANK TEST: REGULAR vs EXAM DAYS\n")
cat(strrep("=", 70), "\n\n")
cat("H₀: Median caffeine intake is equal on regular and exam days\n")
cat("H₁: Median caffeine intake differs between day types\n")
cat("α = 0.05\n\n")

years_list <- levels(caffeine_long$academic_year)

wilcox_results <- map_dfr(years_list, function(yr) {
  reg  <- caffeine_long %>% filter(academic_year == yr, day_type == "Regular") %>% pull(caffeine_mg)
  exam <- caffeine_long %>% filter(academic_year == yr, day_type == "Exam")    %>% pull(caffeine_mg)

  # Match lengths for paired test
  n_min <- min(length(reg), length(exam))
  reg   <- reg[1:n_min]
  exam  <- exam[1:n_min]

  test <- wilcox.test(reg, exam, paired = TRUE, exact = FALSE)

  tibble(
    Academic_Year    = yr,
    N                = n_min,
    Median_Regular   = round(median(reg), 2),
    Median_Exam      = round(median(exam), 2),
    Difference       = round(median(exam) - median(reg), 2),
    W_statistic      = test$statistic,
    p_value          = round(test$p.value, 4),
    Decision         = ifelse(test$p.value < 0.05,
                              "Reject H₀ ★ Significant",
                              "Fail to Reject H₀")
  )
})

print(wilcox_results)
cat("\n")

# Overall test (pooled)
reg_all  <- caffeine_long %>% filter(day_type == "Regular") %>% pull(caffeine_mg)
exam_all <- caffeine_long %>% filter(day_type == "Exam")    %>% pull(caffeine_mg)
overall_wilcox <- wilcox.test(reg_all, exam_all, paired = FALSE, exact = FALSE)

cat("--- OVERALL (Pooled) ---\n")
cat("W =", overall_wilcox$statistic,
    " | p-value =", round(overall_wilcox$p.value, 6), "\n")
cat("Decision:", ifelse(overall_wilcox$p.value < 0.05,
                        "★ Reject H₀ — Significant increase on exam days",
                        "Fail to Reject H₀"), "\n\n")

# =============================================================================
# 2. KRUSKAL-WALLIS TEST — Comparing all academic years
# =============================================================================
# H₀: All academic years have the same distribution of caffeine intake
# H₁: At least one academic year differs
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  KRUSKAL-WALLIS TEST: COMPARING ALL ACADEMIC YEARS\n")
cat(strrep("=", 70), "\n\n")

# Regular days
kw_regular <- kruskal.test(caffeine_mg ~ academic_year,
                           data = caffeine_long %>% filter(day_type == "Regular"))

cat("REGULAR DAYS:\n")
cat("  χ² =", round(kw_regular$statistic, 4),
    " | df =", kw_regular$parameter,
    " | p-value =", round(kw_regular$p.value, 4), "\n")
cat("  Decision:", ifelse(kw_regular$p.value < 0.05,
                          "★ Significant difference among years",
                          "No significant difference among years"), "\n\n")

# Exam days
kw_exam <- kruskal.test(caffeine_mg ~ academic_year,
                        data = caffeine_long %>% filter(day_type == "Exam"))

cat("EXAM DAYS:\n")
cat("  χ² =", round(kw_exam$statistic, 4),
    " | df =", kw_exam$parameter,
    " | p-value =", round(kw_exam$p.value, 4), "\n")
cat("  Decision:", ifelse(kw_exam$p.value < 0.05,
                          "★ Significant difference among years",
                          "No significant difference among years"), "\n\n")

# =============================================================================
# 3. MANN-WHITNEY U TEST — Gender comparison
# =============================================================================
# NOTE: Gender-split data from descriptive analysis (separate male/female vectors)
# Using FY as representative cohort (largest sample)
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  MANN-WHITNEY U TEST: GENDER COMPARISON (FY Cohort)\n")
cat(strrep("=", 70), "\n\n")
cat("H₀: No difference in caffeine intake between males and females\n")
cat("H₁: Caffeine intake differs by gender\n\n")

# FY Regular — Male vs Female (from caffeine.xlsx data)
fy_male_reg   <- c(140.14, 40, 20, 100, 118, 80, 40, 80, 88.8, 154.14, 120,
                   71.6, 71.6, 80, 100, 83.14)
fy_female_reg <- c(20, 5.8, 65.8, 60, 85.8, 0, 78, 0, 0, 20, 0, 20, 65.8,
                   20, 0, 80, 0, 0, 0, 40, 20.14, 60, 65.8, 97.86, 20, 65.8,
                   0, 0, 0, 0, 25.8, 40, 0, 33, 20, 0, 60, 60, 38, 0, 100,
                   80, 0, 154.14, 120, 40, 80, 140, 0, 120, 80, 0, 85.8, 65.8,
                   0, 80, 83, 63.8, 85.8, 94.87, 133.66, 80, 0, 111.6, 85.8)

mw_gender <- wilcox.test(fy_male_reg, fy_female_reg, exact = FALSE)

cat("Male:   n =", length(fy_male_reg),
    " | Median =", median(fy_male_reg), "mg\n")
cat("Female: n =", length(fy_female_reg),
    " | Median =", median(fy_female_reg), "mg\n")
cat("W =", mw_gender$statistic,
    " | p-value =", round(mw_gender$p.value, 4), "\n")
cat("Decision:", ifelse(mw_gender$p.value < 0.05,
                        "★ Significant gender difference",
                        "No significant gender difference"), "\n\n")

# =============================================================================
# 4. EFFECT SIZE — Rank-biserial correlation (r) for Wilcoxon tests
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  EFFECT SIZES — Rank-Biserial Correlation (r)\n")
cat(strrep("=", 70), "\n\n")

rank_biserial <- function(w, n1, n2) {
  r <- 1 - (2 * w) / (n1 * n2)
  abs(r)
}

cat("Interpretation: |r| < 0.1 = negligible, 0.1–0.3 = small,\n")
cat("                0.3–0.5 = medium, >0.5 = large\n\n")

map_dfr(years_list, function(yr) {
  reg  <- caffeine_long %>% filter(academic_year == yr, day_type == "Regular") %>% pull(caffeine_mg)
  exam <- caffeine_long %>% filter(academic_year == yr, day_type == "Exam")    %>% pull(caffeine_mg)
  n_min <- min(length(reg), length(exam))
  reg  <- reg[1:n_min]; exam <- exam[1:n_min]
  test <- wilcox.test(reg, exam, paired = TRUE, exact = FALSE)
  r    <- rank_biserial(test$statistic, n_min, n_min)
  tibble(
    Year       = yr,
    r          = round(r, 3),
    Magnitude  = case_when(
      r < 0.1  ~ "Negligible",
      r < 0.3  ~ "Small",
      r < 0.5  ~ "Medium",
      TRUE     ~ "Large"
    )
  )
}) %>% print()

cat("\n✅ Inferential statistics complete.\n")
