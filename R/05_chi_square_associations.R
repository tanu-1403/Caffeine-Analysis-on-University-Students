# =============================================================================
# CAFFEINE INTAKE STUDY — Script 05: Chi-Square Association Tests
# Faculty of Science, MSU Baroda
# =============================================================================
# PURPOSE: Test whether caffeine consumption (consumer vs non-consumer) is
#          associated with categorical variables: academic year, gender,
#          and department.
# =============================================================================

library(tidyverse)
library(vcd)       # assocstats, Cramer's V
library(knitr)

source("R/01_data_preparation.R")

# =============================================================================
# HELPER: Pretty chi-square result printer
# =============================================================================

print_chi <- function(test, label) {
  cat("\n---", label, "---\n")
  cat("  χ² =", round(test$statistic, 4),
      " | df =", test$parameter,
      " | p-value =", round(test$p.value, 4), "\n")
  if (any(test$expected < 5)) {
    cat("  ⚠️  Warning: Some expected counts < 5; interpret with caution.\n")
  }
  cat("  Decision:", ifelse(test$p.value < 0.05,
                            "★ Reject H₀ — Significant association",
                            "Fail to Reject H₀ — No significant association"), "\n")
}

# =============================================================================
# 1. ACADEMIC YEAR × CAFFEINE CONSUMPTION
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  TEST 1: ACADEMIC YEAR vs CAFFEINE CONSUMPTION\n")
cat(strrep("=", 70), "\n")
cat("H₀: No association between academic year and caffeine consumption\n")
cat("H₁: There IS an association between academic year and consumption\n\n")

# Contingency table: rows = 5 academic years, cols = Non-Consumer / Consumer
assoc_year_mat <- matrix(
  c(22,58,  14,48,  24,52,  18,23,  13,26),
  nrow = 5, byrow = TRUE,
  dimnames = list(
    Year        = c("First Year","Second Year","Third Year",
                    "Masters/Final","Previous Batch"),
    Consumption = c("Non-Consumer","Consumer")
  )
)

cat("Observed Contingency Table:\n")
print(addmargins(assoc_year_mat))

chi_year <- chisq.test(assoc_year_mat)
print_chi(chi_year, "Chi-Square Result")

cat("\nExpected counts:\n")
print(round(chi_year$expected, 2))

# Cramer's V effect size
cv_year <- assocstats(assoc_year_mat)$cramer
cat("\nCramér's V =", round(cv_year, 4),
    "→", ifelse(cv_year < 0.1, "Negligible",
          ifelse(cv_year < 0.3, "Small",
          ifelse(cv_year < 0.5, "Medium", "Large"))), "effect\n")

# Row percentages
cat("\nRow Percentages (% Consumer per year):\n")
row_pct_year <- prop.table(assoc_year_mat, margin = 1) * 100
print(round(row_pct_year, 1))

# =============================================================================
# 2. GENDER × CAFFEINE CONSUMPTION
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  TEST 2: GENDER vs CAFFEINE CONSUMPTION\n")
cat(strrep("=", 70), "\n")
cat("H₀: No association between gender and caffeine consumption\n")
cat("H₁: There IS an association between gender and consumption\n\n")

assoc_gender_mat <- matrix(
  c(47,89,  44,118),
  nrow = 2, byrow = TRUE,
  dimnames = list(
    Gender      = c("Male","Female"),
    Consumption = c("Non-Consumer","Consumer")
  )
)

cat("Observed Contingency Table:\n")
print(addmargins(assoc_gender_mat))

chi_gender <- chisq.test(assoc_gender_mat)
print_chi(chi_gender, "Chi-Square Result")

cat("\nExpected counts:\n")
print(round(chi_gender$expected, 2))

cv_gender <- assocstats(assoc_gender_mat)$cramer
cat("\nCramér's V =", round(cv_gender, 4), "\n")

# Odds Ratio
or <- (assoc_gender_mat[1,1] * assoc_gender_mat[2,2]) /
      (assoc_gender_mat[1,2] * assoc_gender_mat[2,1])
cat("Odds Ratio (Male:Female for consumption) =", round(or, 3), "\n")

# =============================================================================
# 3. DEPARTMENT × CAFFEINE CONSUMPTION
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  TEST 3: DEPARTMENT vs CAFFEINE CONSUMPTION\n")
cat(strrep("=", 70), "\n")
cat("H₀: No association between department and caffeine consumption\n")
cat("H₁: There IS an association between department and consumption\n\n")

dept_names <- c("Biochemistry","Biotechnology","Botany","Chemistry",
                "Environmental Sci","Geography","Industrial Chemistry",
                "Mathematics","Microbiology","Physics","Statistics",
                "Zoology","Other")

assoc_dept_mat <- matrix(
  c(2,3, 7,11, 6,20, 12,24, 11,25, 14,21, 0,8, 2,13, 7,18, 4,3, 14,26, 7,16, 5,19),
  nrow = 13, byrow = TRUE,
  dimnames = list(
    Department  = dept_names,
    Consumption = c("Non-Consumer","Consumer")
  )
)

cat("Observed Contingency Table:\n")
print(addmargins(assoc_dept_mat))

chi_dept <- chisq.test(assoc_dept_mat)
print_chi(chi_dept, "Chi-Square Result")

cat("\n⚠️  Note: Several cells have expected counts < 5 due to small dept sizes.\n")
cat("   Fisher's exact test is not feasible for 13×2 tables.\n")
cat("   Consider collapsing departments for a more reliable test.\n")

cv_dept <- assocstats(assoc_dept_mat)$cramer
cat("\nCramér's V =", round(cv_dept, 4), "\n")

# Department-wise consumer percentage
cat("\nConsumer % by Department:\n")
dept_pct <- data.frame(
  Department    = dept_names,
  Non_Consumer  = assoc_dept_mat[, "Non-Consumer"],
  Consumer      = assoc_dept_mat[, "Consumer"],
  Total         = rowSums(assoc_dept_mat),
  Consumer_Pct  = round(assoc_dept_mat[, "Consumer"] / rowSums(assoc_dept_mat) * 100, 1)
) %>% arrange(desc(Consumer_Pct))
print(dept_pct)

# =============================================================================
# 4. SUMMARY TABLE — All Chi-Square Tests
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  SUMMARY OF ALL ASSOCIATION TESTS\n")
cat(strrep("=", 70), "\n\n")

summary_table <- tibble(
  Variable       = c("Academic Year","Gender","Department"),
  Chi_sq         = round(c(chi_year$statistic, chi_gender$statistic, chi_dept$statistic), 3),
  df             = c(chi_year$parameter, chi_gender$parameter, chi_dept$parameter),
  p_value        = round(c(chi_year$p.value, chi_gender$p.value, chi_dept$p.value), 4),
  Cramers_V      = round(c(cv_year, cv_gender, cv_dept), 4),
  Decision       = ifelse(c(chi_year$p.value, chi_gender$p.value, chi_dept$p.value) < 0.05,
                          "Significant", "Not Significant")
)

print(kable(summary_table, format = "pipe",
            caption = "Chi-Square Association Test Summary"))

cat("\n📌 OVERALL CONCLUSION:\n")
cat("   None of the demographic variables (year, gender, department)\n")
cat("   show a statistically significant association with caffeine\n")
cat("   consumption status at α = 0.05.\n\n")

cat("✅ Chi-square association tests complete.\n")
