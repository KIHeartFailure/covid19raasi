

# Propensity scores -------------------------------------------------------

ps_raasiarni <- glm(formula(paste0(
  "sos_ddr_raasiarni ~ sos_ddr_mra + ",
  paste(modvarsns,
    collapse = " + "
  )
)),
data = pop,
family = binomial
)

ps_arni <- glm(formula(paste0(
  "sos_ddr_arni ~ sos_ddr_mra + ",
  paste(modvarsns[!modvarsns %in% "sos_com_hf"],
        collapse = " + "
  )
)),
data = pop %>% filter(sos_com_hf == "Yes"),
family = binomial
)

ps_mra <- glm(formula(paste0(
  "sos_ddr_mra ~ sos_ddr_raasiarni + ",
  paste(modvarsns,
    collapse = " + "
  )
)),
data = pop,
family = binomial
)

popps <- bind_cols(na.omit(pop %>% select(LopNr, !!!syms(modvars))), 
                   ps_raasiarni = ps_raasiarni$fitted,
                   ps_mra = ps_mra$fitted,
)

poppsarni <- bind_cols(na.omit(pop %>% select(LopNr, !!!syms(modvars)) %>% filter(sos_com_hf == "Yes")), 
                       ps_arni = ps_arni$fitted
)


pop <- left_join(pop, 
                 popps %>%
                   select(LopNr,
                          ps_raasiarni,
                          ps_mra),
                 by = "LopNr"
) %>%
  mutate(
    weight_raasiarni = ifelse(sos_ddr_raasiarni == "Yes",
                              1 / ps_raasiarni,
                              1 / (1 - ps_raasiarni)
    ),
    weight_mra = ifelse(sos_ddr_mra == "Yes",
                        1 / ps_mra,
                        1 / (1 - ps_mra)
    ),
    weight_raasiarni_trunc10 = pmin(10, weight_raasiarni),
    weight_mra_trunc10 = pmin(10, weight_mra),
  )

pop <- left_join(pop, 
                 poppsarni %>%
                   select(LopNr,
                          ps_arni),
                 by = "LopNr"
) %>%
  mutate(
    weight_arni = ifelse(sos_ddr_arni == "Yes",
                              1 / ps_arni,
                              1 / (1 - ps_arni)
    ),
    weight_arni_trunc10 = pmin(10, weight_arni)
  )

# 
# ggplot(pop, aes(x = weight_raasiarni, fill = sos_ddr_raasiarni)) +
#   geom_density(alpha = 0.5, colour = "grey50") +
#   geom_rug() +
#   scale_x_log10(breaks = c(1, 5, 10, 20, 40)) +
#   ggtitle("Distribution of inverse probability weights RAASi/ARNI")
# 
# ggplot(pop, aes(x = weight_raasiarni_trunc10, fill = sos_ddr_raasiarni)) +
#   geom_density(alpha = 0.5, colour = "grey50") +
#   geom_rug() +
#   scale_x_log10(breaks = c(1, 5, 10, 20, 40)) +
#   ggtitle("Distribution of inverse probability weights RAASi/ARNI")
# 
# 
# ggplot(pop, aes(x = weight_mra, fill = sos_ddr_mra)) +
#   geom_density(alpha = 0.5, colour = "grey50") +
#   geom_rug() +
#   scale_x_log10(breaks = c(1, 5, 10, 20, 40)) +
#   ggtitle("Distribution of inverse probability weights MRA")
