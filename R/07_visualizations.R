# =============================================================================
# CAFFEINE INTAKE STUDY — Script 07: Visualizations
# Faculty of Science, MSU Baroda
# =============================================================================
# PURPOSE: Generate all publication-quality figures for the project report.
#          Plots are saved to outputs/ directory.
# =============================================================================

library(tidyverse)
library(ggplot2)
library(ggpubr)
library(scales)
library(patchwork)

source("R/01_data_preparation.R")
dir.create("outputs", showWarnings = FALSE)

# Shared colour palette
COFFEE_BROWN <- "#6F4E37"
LATTE        <- "#C4A35A"
CREAM        <- "#FFF8E7"
ESPRESSO     <- "#2C1810"
MATCHA       <- "#4A7C59"
DARK_ROAST   <- "#3B2314"

theme_caffeine <- function() {
  theme_minimal(base_size = 12) +
  theme(
    plot.background  = element_rect(fill = CREAM, color = NA),
    panel.background = element_rect(fill = CREAM, color = NA),
    plot.title       = element_text(color = ESPRESSO, face = "bold", size = 14),
    plot.subtitle    = element_text(color = COFFEE_BROWN, size = 10),
    plot.caption     = element_text(color = "grey50", size = 8),
    axis.title       = element_text(color = ESPRESSO),
    axis.text        = element_text(color = COFFEE_BROWN),
    legend.background= element_rect(fill = CREAM, color = NA),
    strip.background = element_rect(fill = COFFEE_BROWN, color = NA),
    strip.text       = element_text(color = "white", face = "bold"),
    panel.grid.major = element_line(color = "#E8DCC8"),
    panel.grid.minor = element_blank()
  )
}

year_labels <- c(
  "First Year"            = "FY",
  "Second Year"           = "SY",
  "Third Year"            = "TY",
  "Master's / Final Year" = "Final/M",
  "Previous Year Batch"   = "Previous"
)

# =============================================================================
# PLOT 1 — Grouped Boxplot: Regular vs Exam across all years
# =============================================================================

p1 <- ggplot(caffeine_long,
             aes(x = academic_year, y = caffeine_mg, fill = day_type)) +
  geom_boxplot(outlier.shape = 21, outlier.size = 1.8,
               outlier.colour = COFFEE_BROWN, alpha = 0.85, width = 0.6) +
  scale_fill_manual(values = c("Regular" = COFFEE_BROWN, "Exam" = LATTE)) +
  scale_x_discrete(labels = year_labels) +
  scale_y_continuous(labels = comma) +
  labs(
    title    = "Caffeine Intake: Regular vs Exam Days",
    subtitle = "Distribution by academic year — Median line shown inside boxes",
    x        = "Academic Year",
    y        = "Daily Caffeine Intake (mg)",
    fill     = "Day Type",
    caption  = "Faculty of Science, MSU Baroda | n = 298"
  ) +
  theme_caffeine()

ggsave("outputs/01_boxplot_regular_vs_exam.png", p1, width = 12, height = 7, dpi = 150)
cat("✔ Plot 1 saved: Boxplot Regular vs Exam\n")

# =============================================================================
# PLOT 2 — Stacked bar: Median intake by year and day type
# =============================================================================

median_summary <- caffeine_long %>%
  group_by(academic_year, day_type) %>%
  summarise(median_caffeine = median(caffeine_mg), .groups = "drop")

p2 <- ggplot(median_summary,
             aes(x = academic_year, y = median_caffeine, fill = day_type)) +
  geom_col(position = "dodge", width = 0.65, color = "white") +
  geom_text(aes(label = round(median_caffeine, 1)),
            position = position_dodge(width = 0.65),
            vjust = -0.4, size = 3.2, color = ESPRESSO) +
  scale_fill_manual(values = c("Regular" = COFFEE_BROWN, "Exam" = LATTE)) +
  scale_x_discrete(labels = year_labels) +
  labs(
    title    = "Median Caffeine Intake by Academic Year",
    subtitle = "Comparison of regular and exam day medians",
    x        = "Academic Year",
    y        = "Median Caffeine (mg/day)",
    fill     = "Day Type",
    caption  = "Faculty of Science, MSU Baroda"
  ) +
  theme_caffeine()

ggsave("outputs/02_bar_median_by_year.png", p2, width = 11, height = 6, dpi = 150)
cat("✔ Plot 2 saved: Bar chart median by year\n")

# =============================================================================
# PLOT 3 — Density plots: Distribution shape all years
# =============================================================================

p3 <- ggplot(caffeine_long %>% filter(caffeine_mg > 0),
             aes(x = caffeine_mg, color = academic_year)) +
  geom_density(linewidth = 0.9, alpha = 0.8) +
  facet_wrap(~ day_type, ncol = 2) +
  scale_color_manual(values = c(
    "First Year"            = "#8B4513",
    "Second Year"           = "#CD853F",
    "Third Year"            = "#DAA520",
    "Master's / Final Year" = "#4A7C59",
    "Previous Year Batch"   = "#2C5F8A"
  )) +
  labs(
    title    = "Caffeine Intake Density (Non-Zero Consumers Only)",
    subtitle = "All distributions show positive skew — right-tailed",
    x        = "Caffeine Intake (mg/day)",
    y        = "Density",
    color    = "Academic Year",
    caption  = "Zero-intake students excluded for density clarity"
  ) +
  theme_caffeine()

ggsave("outputs/03_density_by_year.png", p3, width = 13, height = 6, dpi = 150)
cat("✔ Plot 3 saved: Density plots\n")

# =============================================================================
# PLOT 4 — Consumer vs Non-consumer bar by year
# =============================================================================

consumer_summary <- caffeine_long %>%
  filter(day_type == "Regular") %>%
  group_by(academic_year) %>%
  summarise(
    consumer     = sum(caffeine_mg > 0),
    non_consumer = sum(caffeine_mg == 0),
    total        = n(),
    .groups      = "drop"
  ) %>%
  pivot_longer(cols = c(consumer, non_consumer),
               names_to = "status", values_to = "count") %>%
  mutate(pct = count / total * 100)

p4 <- ggplot(consumer_summary,
             aes(x = academic_year, y = pct, fill = status)) +
  geom_col(width = 0.7, color = "white") +
  geom_text(aes(label = paste0(round(pct, 0), "%")),
            position = position_stack(vjust = 0.5),
            color = "white", fontface = "bold", size = 3.5) +
  scale_fill_manual(values = c("consumer" = COFFEE_BROWN, "non_consumer" = "#B0B0B0"),
                    labels = c("consumer" = "Caffeine Consumer", "non_consumer" = "Non-Consumer")) +
  scale_x_discrete(labels = year_labels) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  labs(
    title    = "Proportion of Caffeine Consumers vs Non-Consumers",
    subtitle = "Based on regular day intake",
    x        = "Academic Year",
    y        = "Percentage of Students",
    fill     = "",
    caption  = "Faculty of Science, MSU Baroda"
  ) +
  theme_caffeine() +
  theme(legend.position = "bottom")

ggsave("outputs/04_consumer_proportion_by_year.png", p4, width = 11, height = 6, dpi = 150)
cat("✔ Plot 4 saved: Consumer proportion bar\n")

# =============================================================================
# PLOT 5 — Brand caffeine content comparison
# =============================================================================

p5 <- ggplot(caffeine_brands,
             aes(x = reorder(brand, caffeine_per_100ml),
                 y = caffeine_per_100ml, fill = category)) +
  geom_col(color = "white", width = 0.8) +
  geom_text(aes(label = caffeine_per_100ml),
            hjust = -0.2, size = 2.8, color = ESPRESSO) +
  coord_flip() +
  scale_fill_manual(values = c("Tea" = MATCHA, "Coffee" = COFFEE_BROWN,
                               "Energy Drink" = "#E05C2A")) +
  facet_wrap(~ category, scales = "free_y", ncol = 3) +
  labs(
    title    = "Caffeine Content by Brand (mg per 100 ml)",
    subtitle = "Data source: Standard nutrition references + brand websites",
    x        = NULL,
    y        = "Caffeine (mg / 100 ml)",
    fill     = "Category",
    caption  = "Faculty of Science, MSU Baroda | Used in calculator"
  ) +
  theme_caffeine() +
  theme(legend.position = "none")

ggsave("outputs/05_caffeine_by_brand.png", p5, width = 14, height = 8, dpi = 150)
cat("✔ Plot 5 saved: Brand content bar\n")

# =============================================================================
# PLOT 6 — Scatter: Regular vs Exam intake per student (FY)
# =============================================================================

fy_wide <- data.frame(
  Regular = c(99.4,37.86,65.8,5.8,65.8,60,158,60,5.8,97.86,65.8,0,85.8,0,78,
              20,0,0,20,0,20,140.14,65.8,20,0,80,0,0,0,40,20.14,60,65.8,97.86,
              20,65.8,0,0,0,0,25.8,40,0,33,20,0,60,60,38,0,100,80,0,154.14,120,
              40,80,140,0,120,80,0,85.8,65.8,0,80,83,63.8,85.8,94.87,133.66,80,
              0,111.6,85.8,140,100,80,40,260),
  Exam    = c(99.4,37.86,60,0,60,60,217.86,120,0,97.86,60,0,85.8,0,40,20,0,0,
              20,0,20,140.14,0,20,0,80,0,0,0,40,20.14,60,65.8,97.86,20,65.8,0,
              0,0,0,25.8,40,0,33,20,0,60,60,76,0,100,80,0,476,120,40,80,140,0,
              180,80,0,80,65.8,0,80,106,101.8,85.8,94.87,133.66,160.14,0,111.6,
              85.8,210,120,100,60,260)
)

p6 <- ggplot(fy_wide, aes(x = Regular, y = Exam)) +
  geom_point(color = COFFEE_BROWN, alpha = 0.7, size = 2.5) +
  geom_abline(slope = 1, intercept = 0, color = LATTE, linetype = "dashed", linewidth = 1) +
  geom_smooth(method = "lm", se = TRUE, color = DARK_ROAST, fill = LATTE, alpha = 0.2) +
  annotate("text", x = 250, y = 50, label = "Below line = Exam < Regular",
           color = "grey50", size = 3, hjust = 1) +
  annotate("text", x = 50, y = 420, label = "Above line = Exam > Regular",
           color = COFFEE_BROWN, size = 3, hjust = 0) +
  labs(
    title    = "Individual Caffeine Intake: Regular vs Exam Days (First Year)",
    subtitle = "Dashed line = equality; points above = increased exam consumption",
    x        = "Regular Day Caffeine (mg)",
    y        = "Exam Day Caffeine (mg)",
    caption  = "Each point = 1 student | n = 80"
  ) +
  theme_caffeine()

ggsave("outputs/06_scatter_regular_vs_exam_FY.png", p6, width = 10, height = 7, dpi = 150)
cat("✔ Plot 6 saved: Scatter regular vs exam\n")

# =============================================================================
# PLOT 7 — Skewness & Kurtosis summary heatmap
# =============================================================================

sk_kurt <- caffeine_long %>%
  group_by(academic_year, day_type) %>%
  summarise(
    Skewness = round(e1071::skewness(caffeine_mg), 2),
    Kurtosis = round(e1071::kurtosis(caffeine_mg), 2),
    .groups  = "drop"
  ) %>%
  pivot_longer(cols = c(Skewness, Kurtosis), names_to = "Statistic", values_to = "Value")

p7 <- ggplot(sk_kurt,
             aes(x = day_type, y = academic_year, fill = Value)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = Value), color = "white", fontface = "bold", size = 3.5) +
  facet_wrap(~ Statistic, ncol = 2) +
  scale_fill_gradient2(low = MATCHA, mid = LATTE, high = COFFEE_BROWN, midpoint = 2) +
  scale_y_discrete(labels = year_labels) +
  labs(
    title    = "Skewness and Kurtosis Heatmap",
    subtitle = "Positive skewness confirms right-tailed distributions",
    x        = "Day Type",
    y        = "Academic Year",
    fill     = "Value",
    caption  = "Faculty of Science, MSU Baroda"
  ) +
  theme_caffeine()

ggsave("outputs/07_skewness_kurtosis_heatmap.png", p7, width = 11, height = 7, dpi = 150)
cat("✔ Plot 7 saved: Skewness/Kurtosis heatmap\n")

cat("\n✅ All 7 visualizations saved to outputs/\n")
