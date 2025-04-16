# Midterm - COVID-19 Mortality Analysis Project

## Overview

This project aims to explore key factors associated with COVID-19 mortality using a cleaned dataset and statistical modeling. The analysis includes data preprocessing, exploratory data visualization, and GLM-based modeling. The project is organized to support reproducibility and automation through structured folders and R scripts.

---

## Project Structure

```
data550-midterm/
├── covid_sub.csv                # Raw dataset
├── code/                        # R scripts for data cleaning, EDA, and modeling
│   ├── 00_data_clean.R
│   └── 01_exploratory_plots.R
│   └── 02_models.R
├── output/                      # Output directory for figures and tables
│   ├── figures/                 # Exploratory and diagnostic plots
│   └── tables/                  # Cleaned dataset and summary/model tables
├── report.Rmd 		    # Markdown file to generate report
├── Makefile 		    # Make file to run project
├── README.md
├── midterm_project.Rproj        # R project file
```

---

## Team Responsibilities

### **Yuze Li — Team Leader **

### **Yujia Dou — Data Cleaning & Table 1**
- **Tasks**:
  - Clean and preprocess the dataset from `covid_sub.csv`
  - Create age groups and binary indicators (e.g., death outcome)
  - Generate Table 1 with demographic summaries
- **Output**:
  - `covid_clean.rds`: Cleaned dataset
  - `table1.rds`: Table 1 summary
  - Saved to `output/tables/`

---

### **Ruigang Jiang — Exploratory Analysis & Visualization**
- **Tasks**:
  - Generate bar plots for categorical predictors vs. death
  - Create boxplots for continuous predictors vs. death
- **Output**:
  - PNG plots saved to `output/figures/`
  - e.g., `bar_sex_vs_death.png`, `box_age_vs_death.png`

---

### **Peicheng Ji — Statistical Modeling**
- **Tasks**:
  - Fit a Generalized Linear Model (GLM) for mortality risk
  - Conduct model diagnostics (residuals, multicollinearity, goodness-of-fit)
- **Output**:
  - Model coefficient table with CIs saved to `output/tables/`
  - Diagnostic plots saved to `output/figures/`

---

## Workflow Automation

To ensure consistency and reproducibility, the final workflow can be automated via:

- `Makefile`: Automates the pipeline (from cleaning to final report)
- `config/config.yml`: Parameter file that controls:
  - Age group cutoffs
  - Plot inclusion/exclusion
  - Output formatting

---

## Final Report

The final deliverable is a dynamic report (`report.html` or `report.pdf`) built using:
- Parameterized R Markdown (`.Rmd`)
- Inputs: cleaned data, figures, tables
- Controlled by `config.yml` and built via `make`

---

## How to Run

1. Open the R Project (`midterm_project.Rproj`) in RStudio.
2. Run the scripts in the following order:
   - `00_data_clean.R`
   - `01_exploratory_plots.R`
   - Statistical modeling (TBD)
3. Optionally, run `make` to generate everything and build the final report.
