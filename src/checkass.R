
ProjectTemplate::reload.project()

# Logistic regression -----------------------------------------------------

mod <- glm(formula(paste(
  "sos_covidconfirmed == 'Yes' ~ ",
  paste(c("sos_ddr_rasi", "sos_ddr_mra", modvarsns), collapse = " + ")
)),
data = pop,
family = binomial(link = "logit"),
weights = weight_rasi
)

## Linearity for continous variables --------------------------------------

### Continous variables (age) with splines

## Outliers --------------------------------------------------------------

plot(mod, which = 4, id.n = 3)

## Multicollinearity ------------------------------------------------------

car::vif(mod)

# Cox regression ----------------------------------------------------------

modcox <- coxph(formula(paste0(
  "Surv(sos_outtime_death, sos_death=='Yes') ~ ",
  paste(c("sos_ddr_rasi", "sos_ddr_mra", modvarsns), collapse = " + ")
)),
weights = weight_rasi,
data = pop %>% filter(sos_covidconfirmed == "Yes")
)

## Checking for non-prop hazards ------------------------------------------

print(testpat <- cox.zph(modcox))
(sig <- testpat$table[testpat$table[, 3] < 0.05, ])

# check spec for mra
survminer::ggcoxzph(testpat[1])
survminer::ggcoxzph(testpat[2])

## Checking for outliers --------------------------------------------------

x11()
survminer::ggcoxdiagnostics(modcox,
  type = "dfbeta",
  linear.predictions = FALSE, ggtheme = theme_bw()
)

survminer::ggcoxdiagnostics(mod, type = , linear.predictions = TRUE)


## Checking for linearity --------------------------------------------------

### Continous variables (age) with splines
