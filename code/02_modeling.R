library(here)
here::i_am("code/02_modeling.R")
library(tidyverse)
library(broom)
library(car)
library(glmtoolbox)
#Read the data
data_path <- here("output", "tables", "covid_clean.rds")
covid_clean <- readRDS(data_path)
#glm
covid_mod <- glm(
  death_indicator ~ age + diabetes + asthma + inmsupr+ hipertension+cardiovascular
  +obesity+tobacco+renal_chronic,
  data    = covid_clean,
  family  = binomial(link = "logit")
)
summary(covid_mod)

model_tbl <- tidy(covid_mod, conf.int = TRUE)


# export_coefficients.R
coef_tbl <- broom::tidy(covid_mod, conf.int = TRUE)
saveRDS(
  coef_tbl,
  here::here("output", "tables", "glm_coefficients.rds")
)

#Diagnostic plots
covid_aug = augment(covid_mod)
# Residuals vs Fitted
p1 <- ggplot(covid_aug, aes(.fitted, .resid)) +
  geom_point(alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(x = "Fitted Value", y = "residuals")
#QQ plot
p2 <- ggplot(covid_aug, aes(sample = .std.resid)) +
  stat_qq() +
  stat_qq_line() +
  labs(x = "Quartile", y = "Standardized residuals")
#Saving these two plots
ggsave(here("output","figures","resid_vs_fitted.png"), p1, width=6, height=4)
ggsave(here("output","figures","qq_plot.png"),         p2, width=6, height=4)

#VIF for multicollinerarity
vif_tbl <- car::vif(covid_mod) %>%
  enframe(name = "Variable", value = "VIF")
#output the VIF table
saveRDS(
  vif_tbl,
  here("output", "tables", "glm_vif.rds")
)
#Goodness-of-fit
covid_gof=glmtoolbox::hltest(covid_mod)
#output GOF
gof_summary <- tibble(
  statistic = covid_gof$statistic,   
  df        = covid_gof$parameter,   
  p_value   = covid_gof$p.value      
)

# Saving the summary information for Hosmer-Lemeshow goodness-of-fit test 
saveRDS(
  gof_summary,
  here("output", "tables", "covid_gof_summary.rds")
)



gof_detail <- tibble(
  group    = seq_along(covid_gof$size),  
  size     = covid_gof$size,             
  observed = covid_gof$observed,        
  expected = covid_gof$expected         
)

# Saving the detail information for Hosmer-Lemeshow goodness-of-fit test
saveRDS(
  gof_detail,
  here("output", "tables", "covid_gof_detail.rds")
)
