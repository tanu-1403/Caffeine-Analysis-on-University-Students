# =============================================================================
# CAFFEINE INTAKE STUDY — Script 08: Full Analysis Pipeline
# Faculty of Science, MSU Baroda
# =============================================================================
# PURPOSE: Run the entire analysis end-to-end in the correct order.
#          Execute this single script to reproduce all results and outputs.
#
# USAGE:
#   Rscript R/08_full_pipeline.R
#   OR from RStudio: source("R/08_full_pipeline.R")
# =============================================================================

cat("\n")
cat("╔══════════════════════════════════════════════════════════════╗\n")
cat("║     CAFFEINE INTAKE STUDY — FULL STATISTICAL PIPELINE       ║\n")
cat("║     Faculty of Science, MSU Baroda                          ║\n")
cat("╚══════════════════════════════════════════════════════════════╝\n\n")

# ---- Check and install required packages ------------------------------------

required_packages <- c(
  "tidyverse", "e1071", "moments", "psych", "vcd",
  "ggplot2", "ggpubr", "patchwork", "scales",
  "nortest", "coin", "knitr", "shiny",
  "shinyWidgets", "bslib", "DT"
)

missing_pkgs <- required_packages[!required_packages %in% installed.packages()[,"Package"]]

if (length(missing_pkgs) > 0) {
  cat("Installing missing packages:", paste(missing_pkgs, collapse = ", "), "\n\n")
  install.packages(missing_pkgs, repos = "https://cran.rstudio.com/", quiet = TRUE)
}

# ---- Timer ------------------------------------------------------------------

pipeline_start <- Sys.time()

run_step <- function(step_num, label, script_path) {
  cat(sprintf("\n[Step %d/7] %s\n", step_num, label))
  cat(strrep("-", 50), "\n")
  tryCatch(
    source(script_path),
    error = function(e) {
      cat("  ❌ ERROR in", script_path, ":\n  ", conditionMessage(e), "\n")
    }
  )
  cat(sprintf("  ✅ Step %d complete.\n", step_num))
}

# ---- Execute pipeline -------------------------------------------------------

run_step(1, "Data Preparation & Export",          "R/01_data_preparation.R")
run_step(2, "Descriptive Statistics",             "R/02_descriptive_statistics.R")
run_step(3, "Normality Tests",                    "R/03_normality_tests.R")
run_step(4, "Inferential Statistics",             "R/04_inferential_statistics.R")
run_step(5, "Chi-Square Association Tests",       "R/05_chi_square_associations.R")
run_step(6, "Reliability Analysis (Cronbach's α)","R/06_reliability_analysis.R")
run_step(7, "Visualizations",                     "R/07_visualizations.R")

# ---- Summary ----------------------------------------------------------------

elapsed <- round(difftime(Sys.time(), pipeline_start, units = "secs"), 1)

cat("\n")
cat("╔══════════════════════════════════════════════════════════════╗\n")
cat("║  PIPELINE COMPLETE                                          ║\n")
cat(sprintf("║  Total runtime: %-43s║\n", paste0(elapsed, " seconds")))
cat("╠══════════════════════════════════════════════════════════════╣\n")
cat("║  Output files:                                              ║\n")
cat("║    data/caffeine_raw.csv          — Master dataset          ║\n")
cat("║    data/caffeine_by_year.csv      — Summary statistics      ║\n")
cat("║    data/caffeine_brand_content.csv— Brand database          ║\n")
cat("║    outputs/*.png                  — 7 publication figures   ║\n")
cat("╠══════════════════════════════════════════════════════════════╣\n")
cat("║  To launch the Shiny calculator:                            ║\n")
cat("║    shiny::runApp('shiny_app/')                              ║\n")
cat("╚══════════════════════════════════════════════════════════════╝\n\n")
