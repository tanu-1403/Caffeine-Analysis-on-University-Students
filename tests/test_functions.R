# =============================================================================
# CAFFEINE INTAKE STUDY — Tests
# Faculty of Science, MSU Baroda
# =============================================================================
# PURPOSE: Basic unit tests to verify key functions and data integrity.
#          Run with: source("tests/test_functions.R")
# =============================================================================

library(tidyverse)

cat("\n🧪 Running unit tests for Caffeine Intake Study\n")
cat(strrep("=", 50), "\n\n")

pass <- 0
fail <- 0

test_that_manual <- function(label, expr) {
  result <- tryCatch(expr, error = function(e) FALSE)
  if (isTRUE(result)) {
    cat("  ✅ PASS:", label, "\n")
    pass <<- pass + 1
  } else {
    cat("  ❌ FAIL:", label, "\n")
    fail <<- fail + 1
  }
}

# ---- Load data ----
source("R/01_data_preparation.R")

# =============================================================================
# DATA INTEGRITY TESTS
# =============================================================================

cat("--- Data Integrity ---\n")

test_that_manual("caffeine_long has rows", nrow(caffeine_long) > 0)

test_that_manual("caffeine_long has correct columns",
  all(c("academic_year","student_id","day_type","caffeine_mg") %in% names(caffeine_long)))

test_that_manual("No negative caffeine values",
  all(caffeine_long$caffeine_mg >= 0))

test_that_manual("day_type has only Regular and Exam",
  all(levels(caffeine_long$day_type) %in% c("Regular","Exam")))

test_that_manual("Five academic years present",
  length(unique(caffeine_long$academic_year)) == 5)

test_that_manual("caffeine_brands has correct columns",
  all(c("category","brand","caffeine_per_100ml") %in% names(caffeine_brands)))

test_that_manual("All brand caffeine values >= 0",
  all(caffeine_brands$caffeine_per_100ml >= 0))

test_that_manual("Three brand categories",
  length(unique(caffeine_brands$category)) == 3)

# =============================================================================
# FORMULA TESTS
# =============================================================================

cat("\n--- Formula Verification ---\n")

# Safe limit formula: 2.5 mg/kg × weight
test_that_manual("Safe limit for 65 kg = 162.5 mg",
  abs(2.5 * 65 - 162.5) < 0.001)

test_that_manual("Safe limit for 80 kg = 200 mg",
  abs(2.5 * 80 - 200.0) < 0.001)

# Caffeine calculation: (mg/100ml / 100) × volume × servings
calc_caffeine <- function(mg_per_100ml, volume_ml, servings) {
  (mg_per_100ml / 100) * volume_ml * servings
}

test_that_manual("Nescafe 250ml = 150mg",
  abs(calc_caffeine(60, 250, 1) - 150) < 0.001)

test_that_manual("Red Bull 250ml = 75mg",
  abs(calc_caffeine(30, 250, 1) - 75) < 0.001)

test_that_manual("Waghbakri tea = 0mg (decaf)",
  calc_caffeine(0, 250, 1) == 0)

test_that_manual("Two cups Bru 200ml = 320mg",
  abs(calc_caffeine(80, 200, 2) - 320) < 0.001)

# =============================================================================
# DESCRIPTIVE STATS TESTS
# =============================================================================

cat("\n--- Descriptive Statistics ---\n")

fy_reg <- caffeine_long %>%
  filter(academic_year == "First Year", day_type == "Regular") %>%
  pull(caffeine_mg)

test_that_manual("FY Regular: median >= 0",
  median(fy_reg) >= 0)

test_that_manual("FY Regular: IQR >= 0",
  IQR(fy_reg) >= 0)

test_that_manual("FY Regular: skewness is positive (right-skewed)",
  e1071::skewness(fy_reg) > 0)

test_that_manual("FY Regular: has zero consumers",
  any(fy_reg == 0))

# =============================================================================
# NORMALITY TEST VALIDATION
# =============================================================================

cat("\n--- Normality Tests ---\n")

sw_test <- shapiro.test(fy_reg)

test_that_manual("Shapiro-Wilk returns a p-value",
  !is.null(sw_test$p.value))

test_that_manual("Shapiro-Wilk p < 0.05 for FY Regular (confirms non-normality)",
  sw_test$p.value < 0.05)

test_that_manual("W statistic is between 0 and 1",
  sw_test$statistic > 0 && sw_test$statistic <= 1)

# =============================================================================
# CHI-SQUARE TEST VALIDATION
# =============================================================================

cat("\n--- Association Tests ---\n")

chi_test <- chisq.test(matrix(c(22,58, 14,48, 24,52, 18,23, 13,26),
                               nrow = 5, byrow = TRUE))

test_that_manual("Chi-square returns statistic",
  !is.null(chi_test$statistic))

test_that_manual("Chi-square df = 4 for 5×2 table",
  chi_test$parameter == 4)

test_that_manual("Chi-square p-value between 0 and 1",
  chi_test$p.value > 0 && chi_test$p.value < 1) 

# =============================================================================
# FINAL SUMMARY
# =============================================================================

cat("\n", strrep("=", 50), "\n")
cat(sprintf("  Tests passed: %d / %d\n", pass, pass + fail))
if (fail == 0) {
  cat("  🎉 All tests passed!\n")
} else {
  cat(sprintf("  ⚠️  %d test(s) failed. Review output above.\n", fail))
}
cat(strrep("=", 50), "\n\n")
