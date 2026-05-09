<div align="center">

```
╔═══════════════════════════════════════════════════════════════════╗
║  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ║
║                                                                   ║
║    ██████╗ █████╗ ███████╗███████╗███████╗██╗███╗   ██╗███████╗  ║
║   ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██║████╗  ██║██╔════╝  ║
║   ██║     ███████║█████╗  █████╗  █████╗  ██║██╔██╗ ██║█████╗    ║
║   ██║     ██╔══██║██╔══╝  ██╔══╝  ██╔══╝  ██║██║╚██╗██║██╔══╝    ║
║   ╚██████╗██║  ██║██║     ██║     ███████╗██║██║ ╚████║███████╗  ║
║    ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝  ║
║                                                                   ║
║          I N T A K E   S T U D Y   ☕  F S c   M S U             ║
║                                                                   ║
║  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ☕  ║
╚═══════════════════════════════════════════════════════════════════╝
```

### *"We didn't choose the caffeine life. The caffeine life chose us — especially during exams."*

<br>

![Built with R](https://img.shields.io/badge/Built%20with-R%204.3+-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Shiny](https://img.shields.io/badge/Shiny-App%20Included-FF6B6B?style=for-the-badge&logo=rstudio&logoColor=white)
![Students](https://img.shields.io/badge/Students%20Surveyed-298-C4A35A?style=for-the-badge&logo=graduation-cap&logoColor=white)
![Status](https://img.shields.io/badge/Status-Fully%20Caffeinated-6F4E37?style=for-the-badge&logo=coffeescript&logoColor=white)
![License](https://img.shields.io/badge/License-Academic%20Use-4A7C59?style=for-the-badge)

<br>

> **298 students. 5 academic years. 2 types of days. 1 alarming truth:**
> *we all drink way more coffee before exams.*

</div>

---

## 🗺️ WHERE ARE WE GOING?

```
☕ → 📊 → 🧪 → 📈 → 🎰 → 🖥️ → 🏆
Data   Stats  Tests  Plots  Chi²  Shiny  Glory
```

| Jump to | |
|---|---|
| [⚡ Quickstart](#-quickstart-dont-read-just-run) | Get running in 60 seconds |
| [🏗️ What's in the Repo](#️-whats-in-the-repo) | Full file map |
| [📊 The Analysis Pipeline](#-the-analysis-pipeline) | 8-step walkthrough |
| [🖥️ Shiny Calculator](#️-shiny-caffeine-calculator) | Interactive app features |
| [🔬 Key Findings](#-key-findings-spoiler-alert) | Results (with drama) |
| [📦 Tech Stack](#-tech-stack) | Every package used |
| [🧪 Tests](#-tests) | 20 unit tests |

---

## ⚡ QUICKSTART — Don't Read. Just Run.

```r
# Step 1 — Clone / unzip the project, open R, then:

source("R/08_full_pipeline.R")         # 🔁 Runs EVERYTHING
shiny::runApp("shiny_app/")            # 🖥️ Launches the calculator

# That's it. Seriously. Go drink a coffee while it runs.
# ☕ ........ ☕ ........ ☕
# Done? Great. Everything is in outputs/
```

> 💡 The pipeline auto-installs any missing packages. You literally just need R.
###For demo
app link(https://tanu-1403.shinyapps.io/caffeine_project/)
---

## 🏗️ WHAT'S IN THE REPO

```
caffeine_project/
│
├── 📄 README.md                   ← You are here (hello!)
├── ⚙️  caffeine_project.Rproj     ← RStudio project file
├── 🚫 .gitignore                  ← Keeps the repo clean
│
├── 📁 R/                          ← The brains of the operation
│   ├── 01_data_preparation.R      ← Raw data → tidy tibbles + 3 CSVs
│   ├── 02_descriptive_statistics.R← Mean, median, IQR, skew, kurtosis
│   ├── 03_normality_tests.R       ← Shapiro-Wilk, Anderson-Darling, QQ plots
│   ├── 04_inferential_statistics.R← Wilcoxon, Kruskal-Wallis, Mann-Whitney U
│   ├── 05_chi_square_associations.R← Chi², Cramér's V, odds ratios
│   ├── 06_reliability_analysis.R  ← Cronbach's α, split-half, item-total
│   ├── 07_visualizations.R        ← 7 publication-quality ggplot2 figures
│   └── 08_full_pipeline.R         ← 🔥 THE ONE RING (runs 1–7 in order)
│
├── 📁 shiny_app/
│   └── app.R                      ← Full multi-tab Shiny calculator (500+ lines)
│
├── 📁 data/                       ← Auto-generated when pipeline runs
│   ├── caffeine_raw.csv            ← Master tidy dataset (all 298 students)
│   ├── caffeine_by_year.csv        ← Summary stats per cohort
│   └── caffeine_brand_content.csv  ← Brand database (25 drinks × mg/100ml)
│
├── 📁 docs/
│   ├── Statistical_Report.md      ← Full academic report (Abstract → References)
│   └── Methodology.md             ← Research design + stat framework
│
├── 📁 outputs/                    ← 7 plots saved here after pipeline runs
│   └── *.png                      ← Auto-generated figures
│
└── 📁 tests/
    └── test_functions.R           ← 20 unit tests (data, formulas, stats)
```

---

## 📊 THE ANALYSIS PIPELINE

> Eight scripts. One command. Zero excuses.

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  01 ──► 02 ──► 03 ──► 04 ──► 05 ──► 06 ──► 07 ──► 08              │
│  DATA   DESC   NORM   INFER  CHI²   CRON   PLOTS  RUN ALL          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### `01` · Data Preparation
> *"Where chaos becomes tidy tibbles."*

- Embeds all raw survey vectors (FY through Previous Batch, Regular + Exam)
- Builds a long-format master dataset: `academic_year × day_type × caffeine_mg`
- Exports `caffeine_raw.csv`, `caffeine_by_year.csv`, `caffeine_brand_content.csv`
- Houses the brand caffeine database: 25 drinks across Tea ☕ / Coffee ☕ / Energy ⚡

---

### `02` · Descriptive Statistics
> *"Numbers that tell the story before the tests do."*

- `Mean`, `Median`, `SD`, `IQR`, `Min`, `Max`
- `Skewness` (Pearson's) — spoiler: everything is right-skewed 📈
- `Kurtosis` — how heavy are those tails?
- `% Zero consumers` — how many students don't touch caffeine at all?
- Top 5 highest consumers identified (monsters, honestly)

---

### `03` · Normality Tests
> *"Is it normal? No. Is anything normal during exams? Also no."*

- **Shapiro-Wilk test** on every group (10 tests total)
- **Anderson-Darling test** as backup confirmation
- **QQ plots** saved for all 10 groups
- **Histograms** — visual proof of that magnificent right skew
- Verdict: all p < 0.001 → non-parametric methods required ✅

---

### `04` · Inferential Statistics
> *"The real tea: did exams make us drink more coffee?"*

- **Wilcoxon Signed-Rank** — Regular vs Exam, per cohort (paired)
- **Kruskal-Wallis** — All 5 years vs each other
- **Mann-Whitney U** — Gender comparison
- **Effect sizes** — Rank-biserial correlation r with magnitude labels
- Pooled result: yes, overall exam-day intake is significantly higher 🎯

---

### `05` · Chi-Square Associations
> *"Is your department why you're addicted to Red Bull?"*

- **Year × Consumption** — 5×2 contingency table
- **Gender × Consumption** — 2×2 with odds ratio
- **Department × Consumption** — 13×2 (13 departments!)
- **Cramér's V** for each test
- Row percentages + consumer % ranked by department
- Verdict: nothing is significantly associated. Caffeine doesn't discriminate. ☕=☕

---

### `06` · Reliability Analysis
> *"Can we trust the questionnaire? Cronbach says: mostly yes."*

- **Cronbach's α** for the full 22-item instrument
- **4 subscale alphas**: Frequency / Brand Awareness / Health / Behaviour
- **Item-total correlations** — which questions are pulling their weight?
- **Alpha-if-deleted** — flags any weak items
- **Split-half reliability** with Spearman-Brown correction
- Result: α ≈ 0.71 → Acceptable ✅

---

### `07` · Visualizations
> *"Because a table of numbers is just a boring chart."*

| Plot | File | What it shows |
|------|------|---------------|
| 1 | `01_boxplot_regular_vs_exam.png` | Side-by-side boxplots, all years |
| 2 | `02_bar_median_by_year.png` | Median comparison bar chart |
| 3 | `03_density_by_year.png` | Density curves (non-zero only) |
| 4 | `04_consumer_proportion_by_year.png` | % consumer vs non-consumer stacked |
| 5 | `05_caffeine_by_brand.png` | Brand content database bar chart |
| 6 | `06_scatter_regular_vs_exam_FY.png` | Individual-level scatter, FY cohort |
| 7 | `07_skewness_kurtosis_heatmap.png` | Distribution shape heatmap |

All plots use a custom **coffee-brown × cream theme**. Because aesthetic integrity.

---

## 🖥️ SHINY CAFFEINE CALCULATOR

> *A full multi-tab interactive app. Not a toy — an actual tool.*

```
┌──────────────────────────────────────────────────────────────┐
│  ☕  CAFFEINE INTAKE CALCULATOR  — Faculty of Science, MSU   │
├──────────────────────────────────────────────────────────────┤
│  🧮 Calculator │ 📊 Study Comparison │ 📖 Brands │ ℹ️ About  │
└──────────────────────────────────────────────────────────────┘
```

### Tab 1 — 🧮 Calculator

```
[ Your Weight: 65 kg ]      Safe Limit: 162.5 mg/day

[ Category: ☕ Coffee  ▼ ]
[ Brand: Nescafe       ▼ ]       ⚡ Total Today
[ Volume: 250 ml ]                 ┌──────────┐
[ Servings: 1    ]                 │  187 mg  │
                                   └──────────┘
≈ 150 mg in this serving    ████████████░░░░  73%

[ ➕ Add Drink ]  [ 🔄 Reset ]     ⚠️ Approaching your limit
                                   Consider herbal tea next!
```

**Features:**
- 🏋️ Weight-based personalised limit (`2.5 mg/kg/day`)
- 📋 Session log table with cumulative totals
- 🟢🟡🔴 Dynamic progress bar (green → amber → red)
- 🏷️ Health status badge that updates live
- 💡 Contextual health tips at every intake level
- 🔢 "Equivalents" panel — how many Red Bulls is that?
- 📥 Download your session as a CSV report
- ⚡ Custom drink option (enter your own mg/100ml)

### Tab 2 — 📊 Study Comparison

Compare your own intake against the **real MSU survey medians** on a live ggplot2 chart. Enter your daily intake → see exactly where you sit relative to each cohort.

### Tab 3 — 📖 Brand Reference

Searchable, sortable table of all 25 brands with caffeine content. Filter by category. Built with `DT`.

### Tab 4 — ℹ️ About

The science: half-life explanation, safe limit formula, data sources, methodology summary.

**To launch:**
```r
shiny::runApp("shiny_app/")
```

---

## 🔬 KEY FINDINGS *(Spoiler Alert)*

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   📉 ~30% of students consume ZERO caffeine. Respect.         │
│                                                                │
│   📈 Exam days = more caffeine. Every. Single. Cohort.        │
│                                                                │
│   ⚖️  No gender difference. Equal opportunity addiction.      │
│                                                                │
│   🎓 Academic year doesn't matter. FY drinks like Finals.     │
│                                                                │
│   🧪 Department doesn't matter either. Stats kids ≈ Bio kids. │
│                                                                │
│   📋 Questionnaire reliability: α = 0.71. Acceptable ✅       │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

| Test | Result | p-value |
|------|--------|---------|
| Normality (Shapiro-Wilk) | ❌ Non-normal — all groups | p < 0.001 |
| Regular vs Exam (Wilcoxon) | 📈 Exam > Regular | p < 0.05 (Previous Batch) |
| Across years (Kruskal-Wallis) | 〰️ No significant difference | p > 0.05 |
| Gender (Mann-Whitney U) | 〰️ No significant difference | p > 0.05 |
| Year × Consumption (χ²) | 〰️ No association | p = 0.38 |
| Gender × Consumption (χ²) | 〰️ No association | p = 0.37 |
| Dept × Consumption (χ²) | 〰️ No association | p = 0.51 |
| Cronbach's Alpha | ✅ Acceptable | α ≈ 0.71 |

---

## 📦 TECH STACK

> Every package that touched this project:

```r
# Core
library(tidyverse)       # Data manipulation + ggplot2 + readr
library(e1071)           # Skewness, kurtosis
library(moments)         # Alternative moments
library(psych)           # Cronbach's alpha, describe()
library(vcd)             # Cramér's V, assocstats()
library(nortest)         # Anderson-Darling test
library(coin)            # Exact non-parametric tests
library(knitr)           # Markdown tables

# Visualisation
library(ggplot2)         # All 7 figures
library(ggpubr)          # Publication-ready extras
library(patchwork)       # Plot composition
library(scales)          # Axis formatting

# Shiny App
library(shiny)           # The whole app
library(shinyWidgets)    # pickerInput, progressBar, actionBttn
library(bslib)           # bs_theme(), page_navbar(), cards
library(DT)              # Interactive DataTables
```

---

## 🧪 TESTS

```r
source("tests/test_functions.R")

# 🧪 Running unit tests for Caffeine Intake Study
# ==================================================
#   ✅ PASS: caffeine_long has rows
#   ✅ PASS: No negative caffeine values
#   ✅ PASS: Five academic years present
#   ✅ PASS: Safe limit for 65 kg = 162.5 mg
#   ✅ PASS: Nescafe 250ml = 150mg
#   ✅ PASS: Waghbakri tea = 0mg (decaf)
#   ✅ PASS: Shapiro-Wilk p < 0.05 for FY Regular
#   ✅ PASS: Chi-square df = 4 for 5×2 table
#   ... 12 more ...
# ==================================================
#   Tests passed: 20 / 20
#   🎉 All tests passed!
```

20 tests covering: data integrity, caffeine formulas, normality, chi-square, brand database.

---

## 👥 THE TEAM

```
Faculty of Science
Maharaja Sayajirao University of Baroda
Statistical Analysis Project — 2024–25

Supervised analysis of 298 student responses
across 13 departments and 5 academic cohorts.
```

---

## 📜 QUICK REFERENCE CARD

```
╔══════════════════════════════════════════════════════╗
║           SAFE CAFFEINE LIMIT                        ║
║                                                      ║
║   Your limit (mg) = 2.5 × your weight (kg)          ║
║                                                      ║
║   60 kg person  →  150 mg/day                        ║
║   70 kg person  →  175 mg/day                        ║
║   80 kg person  →  200 mg/day                        ║
║                                                      ║
║   ☕ Nescafe 250ml   = ~150 mg                       ║
║   🍵 Waghbakri 250ml = ~50 mg                        ║
║   ⚡ Red Bull 250ml  = ~75 mg                        ║
║   ⚡ Sting 250ml     = ~72.5 mg                      ║
╚══════════════════════════════════════════════════════╝
```

---

<div align="center">

```
      )  (
     (   ) )          Remember:
      ) ( (
    _______)_         Behind every great
   .-'---------|      exam score is a
  ( C|/\/\/\/\/|      suspicious amount
   '-./\/\/\/\/|      of caffeine ☕
     '_________'
      '-------'

  Faculty of Science · MSU Baroda · 2024–25
```

*Made with ☕ and an unreasonable amount of R.*

</div>
