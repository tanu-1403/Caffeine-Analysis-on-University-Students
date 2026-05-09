# =============================================================================
# CAFFEINE INTAKE STUDY — Script 01: Data Preparation
# Faculty of Science, MSU Baroda
# =============================================================================
# PURPOSE: Build the master tidy dataset from embedded raw vectors,
#          matching the validated values used in all downstream scripts.
# =============================================================================

library(tidyverse)

# -----------------------------------------------------------------------------
# 1. RAW DATA — Caffeine intake (mg/day) per academic cohort
#    Source: Survey responses, manually calculated from brand × volume × servings
# -----------------------------------------------------------------------------

# ---- Regular Days ----
fy_reg  <- c(99.4,37.86,65.8,5.8,65.8,60,158,60,5.8,97.86,65.8,0,85.8,0,78,
             20,0,0,20,0,20,140.14,65.8,20,0,80,0,0,0,40,20.14,60,65.8,97.86,
             20,65.8,0,0,0,0,25.8,40,0,33,20,0,60,60,38,0,100,80,0,154.14,120,
             40,80,140,0,120,80,0,85.8,65.8,0,80,83,63.8,85.8,94.87,133.66,80,
             0,111.6,85.8,140,100,80,40,260)

sy_reg  <- c(25.8,365.88,695.73,48,0,80,0,63.8,85.8,40,25.8,25.8,83.8,80,58,
             0,80,74.14,25.8,25.94,100,0,0,117.86,80,80,0,88.8,25.8,0,0,0,
             97.86,0,120.14,40,80,80,65.8,0,85.8,65.8,108,88.8,61,71.6,25.8,
             80,83,0,80.14,61,71.6,0,5.8,25.8,60,40.14,100,43.8,90,117.86)

ty_reg  <- c(108.88,20,0,40,20,45.8,3.5,0,0,0,70,63.8,300.14,136,20,0,136,
             85.94,0,0,200,100,0,148.94,63.8,0,0,118,40,0,100,40.14,40,0,120,
             0,120.14,90,0,0,0,0,40,80,0,40,85.8,100,0,65.8,0,0,0,120,0,60,
             0,80,97.86,40,60,80,80,100,97.8,83.14,189.3,99.26,77.54,85.8,25.8,
             20,40,100,40,117.74)

mf_reg  <- c(60,0,0,0,100,0.14,40,0,75.72,0,45.8,0,0,0,29,40,180,20,80,60,60,
             160,100,80,0,0,110,40,190.2,68,5.8,30,65.8,0,35.29,30,0,0,120,
             0,201.8)

py_reg  <- c(95.25,265.94,0,20,85.8,20,0,125.94,0,37,0,0,91.8,88.5,0,37,57,
             0,40,0,0,94.73,81.765,58,97.4,0,99.8,148.8,80.14,0,70,0,80,114,
             97.86,140.14,80,105.8,80)

# ---- Exam Days ----
fy_exam <- c(99.4,37.86,60,0,60,60,217.86,120,0,97.86,60,0,85.8,0,40,20,0,0,
             20,0,20,140.14,0,20,0,80,0,0,0,40,20.14,60,65.8,97.86,20,65.8,0,
             0,0,0,25.8,40,0,33,20,0,60,60,76,0,100,80,0,476,120,40,80,140,0,
             180,80,0,80,65.8,0,80,106,101.8,85.8,94.87,133.66,160.14,0,111.6,
             85.8,210,120,100,60,260)

sy_exam <- c(25.8,409.08,901.11,5.8,5.8,80,0,101.8,85.8,40,25.8,25.8,121.8,
             100,96,0,80,74.14,25.8,25.94,260,0,0,197.86,100,80,0,88.8,45.8,
             0,0,0,97.86,0,120.14,40,80,80,65.8,0,85.8,65.8,108,88.8,61,71.6,
             25.8,80,83,0,80.14,61,71.6,0,11.6,25.8,60,40.14,100,81.8,90,277.86)

ty_exam <- c(97,85.8,0,45.8,25.8,40,63.5,0,60,0,230,121.8,370.14,97.86,20,0,
             136,85.94,0,0,300,100,0,5.8,101.8,0,0,118,40,0,100,40,40,0,125.8,
             0,125.94,228.8,0,0,0,0,40,160,0,60,85.8,180,0,125.8,0,0,0,120,0,
             140,0,80,135.72,40,60,80,80,100,97.86,83.14,189.3,99.26,131.6,
             85.8,45.8,40,40,100,40,176.54)

mf_exam <- c(180,0,0,0,100,0.14,60,0,113.58,0,45.8,0,0,0,29,40,180,20,80,60,
             60,160,100,80,0,180,390,45.8,323,68,125.8,0,65.8,0,70.58,45,0,
             0,120,0,167.8)

py_exam <- c(72,301.6,0,20,85.8,20,0,185.8,0,37,0,0,49,117,0,107,114,0,60,0,
             0,183.66,163.39,117.86,167.4,0,219.8,257.8,140.14,0,244,0,100,
             456,157.86,140.14,140,265.8,100)

# -----------------------------------------------------------------------------
# 2. BUILD TIDY DATAFRAME
# -----------------------------------------------------------------------------

make_df <- function(reg_vec, exam_vec, year_label) {
  n_reg  <- length(reg_vec)
  n_exam <- length(exam_vec)
  bind_rows(
    tibble(
      academic_year  = year_label,
      student_id     = seq_len(n_reg),
      day_type       = "Regular",
      caffeine_mg    = reg_vec
    ),
    tibble(
      academic_year  = year_label,
      student_id     = seq_len(n_exam),
      day_type       = "Exam",
      caffeine_mg    = exam_vec
    )
  )
}

caffeine_long <- bind_rows(
  make_df(fy_reg,  fy_exam,  "First Year"),
  make_df(sy_reg,  sy_exam,  "Second Year"),
  make_df(ty_reg,  ty_exam,  "Third Year"),
  make_df(mf_reg,  mf_exam,  "Master's / Final Year"),
  make_df(py_reg,  py_exam,  "Previous Year Batch")
)

caffeine_long <- caffeine_long %>%
  mutate(
    academic_year = factor(academic_year,
                           levels = c("First Year","Second Year","Third Year",
                                      "Master's / Final Year","Previous Year Batch")),
    day_type      = factor(day_type, levels = c("Regular","Exam"))
  )

# -----------------------------------------------------------------------------
# 3. CAFFEINE BRAND CONTENT DATABASE (mg per 100 ml)
# -----------------------------------------------------------------------------

caffeine_brands <- tribble(
  ~category,       ~brand,               ~caffeine_per_100ml,
  "Tea",           "Dwarkesh",           37.86,
  "Tea",           "Girnar",             25.00,
  "Tea",           "Lipton",             23.25,
  "Tea",           "Red Label",          48.00,
  "Tea",           "Taj",                58.80,
  "Tea",           "Tata",               37.00,
  "Tea",           "Tetley",             33.00,
  "Tea",           "Tulsi",               0.00,
  "Tea",           "Waghbakri",          20.00,
  "Coffee",        "Amul",               70.00,
  "Coffee",        "Nescafe",            60.00,
  "Coffee",        "Bru",                80.00,
  "Coffee",        "Davidoff",           57.00,
  "Coffee",        "Ajay",               38.00,
  "Coffee",        "MSU Nescafe",        24.08,
  "Coffee",        "Continental",        62.00,
  "Coffee",        "Starbucks",          73.00,
  "Coffee",        "Sunrise",            90.00,
  "Coffee",        "Others (Regular)",   75.00,
  "Energy Drink",  "Red Bull",           30.00,
  "Energy Drink",  "Monster",            36.00,
  "Energy Drink",  "Mountain Dew",       54.00,
  "Energy Drink",  "Coca-Cola",          38.00,
  "Energy Drink",  "Sting",              29.00,
  "Energy Drink",  "Others",             31.00
)

# -----------------------------------------------------------------------------
# 4. ASSOCIATION TEST MATRICES (from Chi-square analysis)
# -----------------------------------------------------------------------------

# Academic Year × Caffeine Consumption Level (consumer / non-consumer)
assoc_year <- matrix(
  c(22,58, 14,48, 24,52, 18,23, 13,26),
  nrow = 5, byrow = TRUE,
  dimnames = list(
    Year = c("FY","SY","TY","Final/Masters","Previous"),
    Consumption = c("Non-Consumer","Consumer")
  )
)

# Gender × Caffeine Consumption Level
assoc_gender <- matrix(
  c(47,89, 44,118),
  nrow = 2, byrow = TRUE,
  dimnames = list(
    Gender = c("Male","Female"),
    Consumption = c("Non-Consumer","Consumer")
  )
)

# Department × Caffeine Consumption Level (13 departments)
assoc_dept <- matrix(
  c(2,3, 7,11, 6,20, 12,24, 11,25, 14,21, 0,8, 2,13, 7,18, 4,3, 14,26, 7,16, 5,19),
  nrow = 13, byrow = TRUE,
  dimnames = list(
    Department = c("Dept1","Dept2","Dept3","Dept4","Dept5","Dept6","Dept7",
                   "Dept8","Dept9","Dept10","Dept11","Dept12","Dept13"),
    Consumption = c("Non-Consumer","Consumer")
  )
)

# -----------------------------------------------------------------------------
# 5. SAVE CSV EXPORTS
# -----------------------------------------------------------------------------

dir.create("data", showWarnings = FALSE)
write_csv(caffeine_long,   "data/caffeine_raw.csv")
write_csv(caffeine_brands, "data/caffeine_brand_content.csv")

# Year-level summary (wide format for reports)
year_summary <- caffeine_long %>%
  group_by(academic_year, day_type) %>%
  summarise(
    n        = n(),
    mean     = round(mean(caffeine_mg), 2),
    median   = round(median(caffeine_mg), 2),
    sd       = round(sd(caffeine_mg), 2),
    IQR      = round(IQR(caffeine_mg), 2),
    min      = min(caffeine_mg),
    max      = max(caffeine_mg),
    pct_zero = round(mean(caffeine_mg == 0) * 100, 1),
    .groups  = "drop"
  )
write_csv(year_summary, "data/caffeine_by_year.csv")

cat("✅ Data preparation complete.\n")
cat("   Rows in master dataset:", nrow(caffeine_long), "\n")
cat("   CSV files saved to data/\n")
