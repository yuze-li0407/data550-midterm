here::i_am("code/01_exploratory_plots.R")

library(tidyverse)
library(here)
library(ggplot2)

# Load the path
data_path <- here("output", "tables", "covid_clean.rds")
fig_dir   <- here("output", "figures")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

# Load cleaned data
covid_clean <- readRDS(data_path)

# Define your predictors
# Continuous:
cont_vars <- "age"

# Categorical (columns present in your cleaned data):
cat_vars <- c(
  "sex", "patient_type", "usmer", "intubed", "pneumonia", "pregnant",
  "diabetes", "copd", "asthma", "inmsupr", "hipertension", "other_disease",
  "cardiovascular", "obesity", "renal_chronic", "tobacco",
  "clasiffication_final", "icu", "age_group"
)

# Bar plots: each categorical vs. death_indicator
for (var in cat_vars) {
  # skip if the variable doesn't actually exist
  if (!var %in% names(covid_clean)) next
  
  p <- covid_clean %>%
    mutate(death = factor(death_indicator, levels = c(0,1), labels = c("Survived","Died"))) %>%
    ggplot(aes_string(x = var, fill = "death")) +
    geom_bar(position = "fill") +
    labs(
      x    = str_to_title(var),
      y    = "Percentage",
      fill = "Outcome"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(
    filename = here(fig_dir, paste0("bar_", var, "_vs_death.png")),
    plot     = p,
    width    = 6,
    height   = 4,
    dpi      = 300
  )
}

# Boxplots: each continuous vs. death_indicator
for (var in cont_vars) {
  if (!var %in% names(covid_clean)) next
  
  p <- covid_clean %>%
    mutate(death = factor(death_indicator, levels = c(0,1), labels = c("Survived","Died"))) %>%
    ggplot(aes_string(x = "death", y = var)) +
    geom_boxplot() +
    labs(
      x = "Outcome",
      y = str_to_title(var)
    ) +
    theme_minimal()
  
  ggsave(
    filename = here(fig_dir, paste0("box_", var, "_vs_death.png")),
    plot     = p,
    width    = 6,
    height   = 4,
    dpi      = 300
  )
}