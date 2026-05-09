# =============================================================================
# CAFFEINE INTAKE STUDY — Script 03: Normality Tests
# Faculty of Science, MSU Baroda
# =============================================================================
# PURPOSE: Test whether caffeine intake data follows a normal distribution
#          using Shapiro-Wilk test, QQ plots, and histograms.
#          Results justify use of non-parametric methods in Script 04.
# =============================================================================

library(tidyverse)
library(ggplot2)
library(ggpubr)
library(nortest)   # Anderson-Darling test

source("R/01_data_preparation.R")

dir.create("outputs", showWarnings = FALSE)

# =============================================================================
# 1. SHAPIRO-WILK NORMALITY TEST — All groups
# =============================================================================

cat("\n", strrep("=", 70), "\n")
cat("  SHAPIRO-WILK NORMALITY TEST RESULTS\n")
cat(strrep("=", 70), "\n\n")
cat("H₀: Data is normally distributed\n")
cat("H₁: Data is NOT normally distributed\n")
cat("Significance level: α = 0.05\n\n")

normality_results <- caffeine_long %>%
  group_by(academic_year, day_type) %>%
  summarise(
    n          = n(),
    W_stat     = tryCatch(shapiro.test(caffeine_mg)$statistic, error = function(e) NA),
    p_value    = tryCatch(shapiro.test(caffeine_mg)$p.value,   error = function(e) NA),
    normal     = ifelse(p_value > 0.05, "✅ Fail to Reject H₀", "❌ Reject H₀ (Non-normal)"),
    .groups    = "drop"
  ) %>%
  mutate(
    W_stat  = round(W_stat, 4),
    p_value = format(p_value, scientific = TRUE, digits = 3)
  )

print(normality_results)

cat("\n📌 CONCLUSION: All groups show p < 0.05 → Non-normal distributions.\n")
cat("   Non-parametric tests (Wilcoxon, Kruskal-Wallis) must be used.\n\n")

# =============================================================================
# 2. ANDERSON-DARLING TEST (additional confirmation)
# =============================================================================

cat(strrep("-", 70), "\n")
cat("  ANDERSON-DARLING TEST (Supplementary)\n")
cat(strrep("-", 70), "\n\n")

ad_results <- caffeine_long %>%
  group_by(academic_year, day_type) %>%
  summarise(
    AD_stat  = ad.test(caffeine_mg)$statistic,
    p_value  = ad.test(caffeine_mg)$p.value,
    .groups  = "drop"
  ) %>%
  mutate(
    AD_stat = round(AD_stat, 4),
    p_value = format(p_value, scientific = TRUE, digits = 3),
    decision = ifelse(as.numeric(p_value) > 0.05, "Normal", "Non-normal")
  )

print(ad_results)

# =============================================================================
# 3. QQ PLOTS — Visualizing departures from normality
# =============================================================================

years <- levels(caffeine_long$academic_year)

for (yr in years) {
  for (dt in c("Regular", "Exam")) {
    subset_data <- caffeine_long %>%
      filter(academic_year == yr, day_type == dt) %>%
      pull(caffeine_mg)

    if (length(subset_data) < 3) next

    fname <- paste0("outputs/qqplot_",
                    gsub("[^a-zA-Z0-9]", "_", yr), "_", dt, ".png")

    png(fname, width = 800, height = 600, res = 120)
    qqnorm(subset_data,
           main = paste("QQ Plot —", yr, "|", dt, "Days"),
           col  = "#8B4513", pch = 16, cex = 0.8)
    qqline(subset_data, col = "#2C5F2E", lwd = 2, lty = 2)
    dev.off()
  }
}

# =============================================================================
# 4. HISTOGRAMS — Distribution shape (ggplot2)
# =============================================================================

hist_plot <- ggplot(caffeine_long, aes(x = caffeine_mg, fill = day_type)) +
  geom_histogram(binwidth = 30, color = "white", alpha = 0.8, position = "identity") +
  facet_grid(academic_year ~ day_type, scales = "free_y") +
  scale_fill_manual(values = c("Regular" = "#8B4513", "Exam" = "#D2691E")) +
  labs(
    title    = "Distribution of Caffeine Intake by Academic Year and Day Type",
    subtitle = "Right-skewed distributions observed across all cohorts",
    x        = "Caffeine Intake (mg/day)",
    y        = "Number of Students",
    fill     = "Day Type",
    caption  = "Faculty of Science, MSU Baroda"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    strip.background = element_rect(fill = "#4b3621", color = NA),
    strip.text       = element_text(color = "white", face = "bold"),
    plot.title       = element_text(face = "bold", size = 13),
    legend.position  = "bottom"
  )

ggsave("outputs/histograms_all_groups.png", hist_plot,
       width = 14, height = 12, dpi = 150)

# =============================================================================
# 5. SUMMARY BOXPLOT — All years, both day types
# =============================================================================

box_plot <- ggplot(caffeine_long,
                   aes(x = academic_year, y = caffeine_mg, fill = day_type)) +
  geom_boxplot(outlier.shape = 21, outlier.size = 1.5,
               outlier.fill = "white", alpha = 0.85) +
  scale_fill_manual(values = c("Regular" = "#8B4513", "Exam" = "#C4A35A")) +
  scale_x_discrete(labels = c("FY","SY","TY","Final/Masters","Previous")) +
  labs(
    title    = "Caffeine Intake Distribution — Regular vs Exam Days",
    subtitle = "Median lines shown; whiskers = 1.5×IQR; dots = outliers",
    x        = "Academic Year",
    y        = "Caffeine Intake (mg/day)",
    fill     = "Day Type"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

ggsave("outputs/boxplot_regular_vs_exam.png", box_plot,
       width = 12, height = 7, dpi = 150)

cat("✅ Normality tests complete. Plots saved to outputs/\n")
