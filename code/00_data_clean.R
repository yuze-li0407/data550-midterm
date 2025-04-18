library(tidyverse)
library(gtsummary)
library(here)

here::i_am("code/00_data_clean.R")

raw_path    <- here("covid_sub.csv")
out_dir     <- here("output", "tables")
clean_path  <- file.path(out_dir, "covid_clean.rds")
table1_path <- file.path(out_dir, "table1.rds")

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Load & lowercase
covid_raw <- read_csv(raw_path, col_types = cols()) %>%
  rename_with(tolower)

# Clean & feature‑engineer
covid_clean <- covid_raw %>%
  mutate(
    # factorize sex & clasification
    sex = factor(sex),
    clasiffication_final = factor(clasiffication_final),
    # convert DATE_DIED ("dd/mm/yyyy") → NA when blank → death_indicator
    death_indicator = if_else(is.na(date_died) | date_died == "", 0L, 1L),
    # age groups
    age_group = case_when(
      age < 18          ~ "<18",
      age < 40          ~ "18–39",
      age < 60          ~ "40–59",
      TRUE              ~ "60+"
    ) %>% factor(levels = c("<18","18–39","40–59","60+")),
    # pregnant = No for males
    pregnant = if_else(sex == "male", "No", pregnant)
  ) %>%
  # drop rows with missing values in patient characteristics
  filter(if_all(-c(date_died, icu, intubed), ~ !is.na(.))) 


# Create Table1
tb1 <- covid_clean %>%
  select(sex, age, age_group, clasiffication_final,
         pneumonia, pregnant, diabetes, copd,
         asthma, inmsupr, hipertension, cardiovascular,
         obesity, tobacco, renal_chronic, other_disease) %>%
  tbl_summary(
    statistic = list(all_continuous() ~ "{mean} ({sd})"),
    label = list(
      sex ~ "Sex",
      age ~ "Age",
      age_group ~ "Age Group",
      clasiffication_final ~ "Covid Test Degree",
      pneumonia ~ "Pneumonia",
      pregnant ~ "Pregnancy",
      diabetes ~ "Diabetes",
      copd ~ "Chronic Obstructive Pulmonary Disease",
      asthma ~ "Asthma",
      inmsupr ~ "Immunosuppressed",
      hipertension ~ "Hypertension",
      cardiovascular ~ "Cardiovascular Disease",
      obesity ~ "Obesity",
      tobacco ~ "Tobacco Use",
      renal_chronic ~ "Chroic Renal Disease",
      other_disease ~ "Other Disease"
    ),
    missing = "no"
  )


# Save outputs as .rds
saveRDS(covid_clean, clean_path)
saveRDS(tb1,     table1_path)

message("✔ Cleaned data saved to:     ", clean_path)
message("✔ Table1 saved to:          ", table1_path)

