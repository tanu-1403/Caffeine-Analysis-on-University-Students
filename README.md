# ☕ Caffeine Intake Statistical Analysis — Faculty of Science, MSU

> **A complete end-to-end statistical research project** analyzing caffeine consumption patterns among university students, with interactive R Shiny calculator.

---

## 📌 Project Overview

This project examines **caffeine intake habits** among students across five academic years (First Year through Final Year + Previous Year batch) at the Faculty of Science, Maharaja Sayajirao University of Baroda. Surveys captured regular-day vs. exam-day consumption and demographic factors including gender, department, and academic year.

---

## 🗂️ Repository Structure

```
caffeine_project/
│
├── README.md                        ← You are here
├── data/
│   ├── caffeine_raw.csv             ← Cleaned master dataset (all years, both days)
│   ├── caffeine_by_year.csv         ← Summary statistics by academic year
│   └── caffeine_brand_content.csv   ← Caffeine content database (mg/100ml)
│
├── R/
│   ├── 01_data_preparation.R        ← Data loading, cleaning, reshaping
│   ├── 02_descriptive_statistics.R  ← Summary stats per year and gender
│   ├── 03_normality_tests.R         ← Shapiro-Wilk, QQ plots, histograms
│   ├── 04_inferential_statistics.R  ← Wilcoxon, Kruskal-Wallis, Mann-Whitney
│   ├── 05_chi_square_associations.R ← Chi-square tests: year, gender, dept
│   ├── 06_reliability_analysis.R    ← Cronbach's Alpha reliability test
│   ├── 07_visualizations.R          ← All publication-quality plots
│   └── 08_full_pipeline.R           ← Run entire analysis end-to-end
│
├── shiny_app/
│   ├── app.R                        ← Full Shiny caffeine calculator app
│   └── www/
│       └── coffee.png               ← App icon (place your image here)
│
├── docs/
│   ├── Statistical_Report.md        ← Full written statistical report
│   └── Methodology.md               ← Research design & methodology
│
├── outputs/
│   └── (generated plots saved here automatically)
│
└── tests/
    └── test_functions.R             ← Unit tests for key functions
```

---

## 📊 Analysis Pipeline

| Step | Script | Description |
|------|--------|-------------|
| 1 | `01_data_preparation.R` | Load & clean raw data, handle missing values |
| 2 | `02_descriptive_statistics.R` | Median, IQR, skewness, kurtosis by year & gender |
| 3 | `03_normality_tests.R` | Shapiro-Wilk test, QQ plots, histograms |
| 4 | `04_inferential_statistics.R` | Non-parametric group comparisons |
| 5 | `05_chi_square_associations.R` | Categorical associations |
| 6 | `06_reliability_analysis.R` | Cronbach's α for questionnaire |
| 7 | `07_visualizations.R` | Boxplots, bar charts, scatter plots |
| 8 | `shiny_app/app.R` | Interactive caffeine calculator |

---

## 🚀 Quick Start

### Prerequisites
```r
install.packages(c(
  "tidyverse", "e1071", "moments", "readxl",
  "ggplot2", "ggpubr", "psych", "vcd",
  "shiny", "shinyWidgets", "bslib", "DT",
  "nortest", "coin"
))
```

### Run Full Analysis
```r
source("R/08_full_pipeline.R")
```

### Launch Shiny App
```r
shiny::runApp("shiny_app/")
```
### For demo
https://tanu-1403.shinyapps.io/caffeine_project/
---

## 🔑 Key Findings

| Finding | Result |
|---------|--------|
| Data Distribution | Right-skewed across all groups (non-normal) |
| Regular vs Exam Day | Significant increase in exam-day caffeine (Wilcoxon, p < 0.05) |
| Gender Association | No significant association (Chi-square, p > 0.05) |
| Academic Year Association | No significant association (Chi-square, p > 0.05) |
| Department Association | No significant association (Chi-square, p > 0.05) |
| Questionnaire Reliability | Cronbach's α ≈ 0.70+ (acceptable) |

---

## 📦 Deliverables

- [x] Complete R scripts (modular, commented)
- [x] End-to-end statistical analysis
- [x] R Shiny interactive caffeine calculator
- [x] Publication-quality visualizations
- [x] Full statistical report (Markdown)
- [x] Methodology documentation
- [x] Unit tests

---

## 👥 Authors

Faculty of Science — Maharaja Sayajirao University of Baroda  
Statistical Analysis Project, 2024–2025

---

## 📄 License

For academic use only. Data collected with informed consent from student participants.
