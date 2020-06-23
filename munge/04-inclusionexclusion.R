
flow <- c(
  "No of patients (ORDERED: pats with hypertension, diabetes, hf, kidney, ihd, obesity, af 1997 to now and alive 2020-01-01)", nrow(pop))

pop <- pop %>%
  filter(is.na(scb_atersenpnr)) # reused/changed personr

flow <- rbind(flow, c("Exclude patients with reused or changed PINs", nrow(pop)))

pop <- pop %>%
  filter(is.na(scb_migrated))

flow <- rbind(flow, c(paste0("Exclude patients migrated prior to ", global_indexdtm), nrow(pop)))

pop <- pop %>%
  filter(is.na(sos_deathdtm) | sos_deathdtm >= ymd(global_indexdtm))

flow <- rbind(flow, c(paste0("Exclude patients died prior to ", global_indexdtm), nrow(pop)))

pop <- pop %>%
  filter(scb_age >= 18)

flow <- rbind(flow, c("Exclude patients < 18 years", nrow(pop)))

pop <- pop %>%
  filter(sos_com_hypertension == "Yes" |
    sos_com_diabetes == "Yes" |
    sos_com_hf == "Yes" |
    sos_com_renal == "Yes" |
    sos_com_ihd == "Yes")

flow <- rbind(flow, c(paste0("Include patients with hypertension, diabetes, hf, kidney, ihd 1997-01-01 -- ", global_indexdtm), nrow(pop)))

flow <- rbind(flow, c(paste0("Patients with Covid-19 ", global_indexdtm, " -- 2020-06-01"), 
                      pop %>% filter(sos_out_hospcovidconfirmed == "Yes") %>% count()))

flow <- rbind(flow, c(paste0("Wherof dead from Covid-19 ", global_indexdtm, " -- 2020-06-01"), 
                      pop %>% filter(sos_deathcovidconfulorsak == "Yes") %>% count()))

sos_deathcovidconfulorsak

pop <- pop %>%
  select(-scb_migrated, -scb_atersenpnr)