

# Death -------------------------------------------------------------------

dorsall <- full_join(dors, 
                  dors_cov, 
                  by = "LopNr",
                  suffix = c("_all", "_cov")
) %>%
  mutate(DODSDAT = coalesce(DODSDAT_cov, DODSDAT_all), 
    sos_deathdtm = ymd(case_when(
    substr(DODSDAT, 5, 8) == "0000" ~ paste0(substr(DODSDAT, 1, 4), "0101"),
    substr(DODSDAT, 7, 8) == "00" ~ paste0(substr(DODSDAT, 1, 6), "01"),
    TRUE ~ DODSDAT
  )),
  sos_deathdtm = case_when(sos_deathdtm > global_enddtm ~ as.Date(NA), 
                           TRUE ~ sos_deathdtm),
  sos_death = case_when(!is.na(sos_deathdtm) ~ "Yes",
                           TRUE ~ "No"),
  sos_deathcovidconfulorsak = case_when(stringr::str_detect(ULORSAK, "U071") ~ "Yes",
                                        TRUE ~ "No"),
  sos_deathcovidall = case_when(stringr::str_detect(ICDKODER, "U071|U072|Z861A") ~ "Yes",
                                TRUE ~ "No")
  ) %>%
  select(LopNr, starts_with("sos_"))

pop <- left_join(pop, 
                 dorsall, 
                 by = "LopNr") %>%
  mutate(sos_death = replace_na(sos_death, "No"),
         sos_deathcovidconfulorsak = replace_na(sos_deathcovidconfulorsak, "No"),
         sos_deathcovidall = replace_na(sos_deathcovidall, "No"),
         censdtm = pmin(global_enddtm, sos_deathdtm, na.rm = TRUE)
         )