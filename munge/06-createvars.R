

# Final fix to variables -----------------------------------------------------

# gruppindelning inkomst
inc <- pop %>%
  summarise(incsum = quantile(scb_dispincome,
    probs = c(0.33, 0.66),
    na.rm = TRUE
  )) %>%
  pull(incsum)

pop <- pop %>%
  mutate(
    coviddtm = case_when(
      sos_out_hospcovidconfirmed == "Yes" ~ indexdtm + sos_outtime_hospcovidconfirmed,
      TRUE ~ as.Date(NA)
    ),
    sos_covidconfirmed = if_else(sos_deathcovidconfulorsak == "Yes" |
      sos_out_hospcovidconfirmed == "Yes", "Yes", "No"),
    sos_ddr_rasi = if_else(sos_ddr_acei == "Yes" |
      sos_ddr_arb == "Yes", "Yes", "No"),
    scb_dispincome_cat = case_when(
      scb_dispincome < inc[[1]] ~ 1,
      scb_dispincome < inc[[2]] ~ 2,
      scb_dispincome >= inc[[2]] ~ 3
    ),
    scb_dispincome_cat = factor(scb_dispincome_cat, labels = c("Low", "Medium", "High")),
    scb_region_stockholm = if_else(scb_region == "01", "Yes", "No"),

    sos_outtime_death = case_when(
      is.na(coviddtm) & sos_deathcovidconfulorsak == "Yes" ~ 0,
      TRUE ~ as.numeric(censdtm - coviddtm)
    ),
    sos_outtime_death = if_else(sos_outtime_death < 0, 0, sos_outtime_death)
  ) %>%
  select(
    LopNr,
    indexdtm,
    coviddtm,
    censdtm,
    contains("scb_"),
    contains("sos_ddr_"),
    contains("sos_com_"),
    contains("sos_out"),
    contains("sos_death"),
    contains("sos_covid")
  )


pop <- pop %>%
  mutate_if(is.character, as.factor) %>%
  mutate(
    scb_region = as.character(scb_region)
  )
