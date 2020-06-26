

# Propensity scores -------------------------------------------------------

ps_rasi <- glm(formula(paste0(
  "sos_ddr_rasi == 'Yes' ~ sos_ddr_mra + ",
  paste(modvarsns,
    collapse = " + "
  )
)), 
data = pop,
family = binomial
)

ps_mra <- glm(formula(paste0(
  "sos_ddr_mra == 'Yes' ~ sos_ddr_rasi + ",
  paste(modvarsns,
    collapse = " + "
  )
)),
data = pop,
family = binomial
)

popps <- bind_cols(na.omit(pop %>% select(LopNr, !!!syms(modvars))),
  ps_rasi = ps_rasi$fitted,
  ps_mra = ps_mra$fitted,
)


pop <- left_join(pop,
  popps %>%
    select(
      LopNr,
      ps_rasi,
      ps_mra
    ),
  by = "LopNr"
) %>%
  mutate(
    weight_rasi = ifelse(sos_ddr_rasi == "Yes",
      1 / ps_rasi,
      1 / (1 - ps_rasi)
    ),
    weight_mra = ifelse(sos_ddr_mra == "Yes",
      1 / ps_mra,
      1 / (1 - ps_mra)
    ),
    weight_rasi = pmin(10, weight_rasi),
    weight_mra = pmin(10, weight_mra),
  )


#
# ggplot(pop, aes(x = weight_rasi, fill = sos_ddr_rasi)) +
#   geom_density(alpha = 0.5, colour = "grey50") +
#   geom_rug() +
#   scale_x_log10(breaks = c(1, 5, 10, 20, 40)) +
#   ggtitle("Distribution of inverse probability weights RASi")
#
# ggplot(pop, aes(x = weight_mra, fill = sos_ddr_mra)) +
#   geom_density(alpha = 0.5, colour = "grey50") +
#   geom_rug() +
#   scale_x_log10(breaks = c(1, 5, 10, 20, 40)) +
#   ggtitle("Distribution of inverse probability weights MRA")
