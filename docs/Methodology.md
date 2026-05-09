# Research Methodology
## Caffeine Intake Study — Faculty of Science, MSU Baroda

---

## Study Design

**Type:** Observational cross-sectional survey  
**Setting:** Faculty of Science, Maharaja Sayajirao University of Baroda (MSU Baroda)  
**Period:** Academic Year 2024–25  
**Ethics:** Data collected with informed consent; anonymised before analysis

---

## Sampling

| Parameter | Detail |
|-----------|--------|
| Target population | All enrolled students, Faculty of Science, MSU Baroda |
| Sampling method | Convenience sampling (class-level administration) |
| Total sample | n = 298 |
| Strata | 5 academic year groups |
| Gender | 91 male (30.5%), 207 female (69.5%) |
| Departments | 13 science departments |

---

## Instrument: Questionnaire Design

The 22-item questionnaire was designed to capture:

**Section A — Demographics (Q1–Q4)**
- Academic year, gender, department, age

**Section B — Consumption Habits (Q5–Q12)**
- Type of caffeinated beverage (tea, coffee, energy drink)
- Brand preference
- Cup size and frequency (regular days)
- Cup size and frequency (exam days)

**Section C — Awareness & Perception (Q13–Q18)**
- Knowledge of caffeine content
- Perceived effects on alertness
- Perceived effects on sleep
- Reasons for consumption (habit, taste, alertness, stress)

**Section D — Health & Lifestyle (Q19–Q22)**
- Physical activity level
- Sleep hours
- Stress self-assessment
- Desire to reduce intake

---

## Caffeine Content Conversion

Daily caffeine intake was calculated as:

```
caffeine_mg_per_day = (caffeine_per_100ml / 100) × cup_volume_ml × servings_per_day
```

Brand-specific caffeine values sourced from:
- Manufacturer nutrition labels
- USDA FoodData Central database
- Published food composition tables
- Academic literature (validated Indian brands)

---

## Statistical Framework

### Phase 1 — Data Preparation
- Data entry verification against raw questionnaires
- Outlier identification (values > 3×IQR flagged)
- Missing data: listwise deletion (< 2% of responses)
- Units standardised to mg/day

### Phase 2 — Descriptive Analysis
- Central tendency: Mean, Median
- Spread: SD, IQR, Min, Max
- Shape: Skewness (Pearson's), Excess Kurtosis
- Zero-consumer percentage

### Phase 3 — Normality Testing
- **Primary:** Shapiro-Wilk test (n < 2000)
- **Supplementary:** Anderson-Darling test
- **Visual:** QQ plots, histograms
- **Decision rule:** If p < 0.05, reject normality → use non-parametric tests

### Phase 4 — Inferential Testing
Since normality was rejected for all groups:

| Comparison | Test Used | Rationale |
|------------|-----------|-----------|
| Regular vs Exam (per year) | Wilcoxon Signed-Rank | Paired, non-normal |
| Across all years | Kruskal-Wallis | k > 2 independent groups |
| Male vs Female | Mann-Whitney U | 2 independent groups |

### Phase 5 — Association Analysis
- **Chi-Square test of independence** for categorical × categorical relationships
- **Cramér's V** for effect size
- Fisher's Exact (not used: impractical for 13×2 tables)

### Phase 6 — Reliability
- **Cronbach's Alpha (α)** for internal consistency
- **Item-total correlation** for item quality
- **Split-half reliability** with Spearman-Brown correction

---

## Software

| Tool | Version | Purpose |
|------|---------|---------|
| R | ≥ 4.3.0 | Primary statistical computing |
| tidyverse | ≥ 2.0 | Data manipulation & visualisation |
| psych | ≥ 2.3 | Cronbach's Alpha, factor analysis |
| vcd | ≥ 1.4 | Association measures (Cramér's V) |
| nortest | ≥ 1.0 | Anderson-Darling test |
| ggplot2 | ≥ 3.4 | Publication figures |
| shiny | ≥ 1.8 | Interactive calculator |
| bslib | ≥ 0.6 | Shiny UI theming |

---

## Significance Level

All hypothesis tests used **α = 0.05** (two-tailed unless stated otherwise).

---

## Reproducibility

All analyses are fully reproducible by running:

```r
source("R/08_full_pipeline.R")
```

Random seed `set.seed(42)` is used where simulation is required (reliability section). All raw data vectors are embedded in `R/01_data_preparation.R`.

---

*Faculty of Science, MSU Baroda | Caffeine Intake Study 2024–25*
