
# Inclusion/exclusion criteria --------------------------------------------

flow <- c(
  "No patients recieved from Socialstyrelsen", nrow(pop)
)

pop <- pop %>%
  filter(sos_com_hypertension == "Yes" |
    sos_com_diabetes == "Yes" |
    sos_com_hf == "Yes" |
    sos_com_renal == "Yes" |
    sos_com_ihd == "Yes")

flow <- rbind(flow, c(paste0("Include patients with hypertension, diabetes, hf, kidney, ihd 1997/1998-01-01 -- ", global_indexdtm), nrow(pop)))

pop <- pop %>%
  filter(is.na(sos_deathdtm) | sos_deathdtm >= ymd(global_indexdtm))

flow <- rbind(flow, c(paste0("Exclude patients died prior to ", global_indexdtm), nrow(pop)))

pop <- pop %>%
  filter(is.na(scb_emigrated))

flow <- rbind(flow, c("Exclude patients emigrated prior to 2019-12-31", nrow(pop)))

pop <- pop %>%
  filter(is.na(scb_immigratedpost2015))

flow <- rbind(flow, c("Exclude patients immigrated post 2015-01-01", nrow(pop)))

pop <- pop %>%
  filter(is.na(scb_atersenpnr)) # reused/changed personr

flow <- rbind(flow, c("Exclude patients with reused or changed PINs", nrow(pop)))

pop <- pop %>%
  filter(scb_age >= 18)

flow <- rbind(flow, c("Exclude patients < 18 years", nrow(pop)))

pop <- pop %>%
  filter(sos_ddr_arni == "No")

flow <- rbind(flow, c("Exclude patients with ARNI", nrow(pop)))

flow <- rbind(flow, c(
  paste0("Patients with Covid-19 ", global_indexdtm, " -- ", global_enddtm),
  pop %>% filter(sos_out_hospcovidconfirmed == "Yes" | sos_deathcovidconfulorsak == "Yes") %>% count()
))

pop <- pop %>%
  select(-scb_emigrated, -scb_immigratedpost2015, -scb_atersenpnr)
