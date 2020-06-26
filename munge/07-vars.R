

# Variables for tabs and mods ---------------------------------------------

tabvars <- names(pop)[str_detect(names(pop), "^(scb_|sos_com_|sos_ddr_)")]
tabvars <- tabvars[!tabvars %in% c("scb_region", "sos_ddr_arni")]

# vars fox log reg
tabvars_not_in_mod <- c(
  "scb_dispincome",
  "scb_maritalstatus",
  "sos_ddr_rasi",
  "sos_ddr_acei",
  "sos_ddr_arb",
  "sos_ddr_mra"
)

modvars <- tabvars[!(tabvars %in% tabvars_not_in_mod)]
modvarsns <- modvars
modvarsns[modvars == "scb_age"] <- "ns(scb_age, 4)"
