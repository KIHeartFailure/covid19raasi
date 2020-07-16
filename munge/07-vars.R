

# Variables for tabs and mods ---------------------------------------------

tabvars <- names(pop)[str_detect(names(pop), "^(scb_|sos_com_|sos_ddr_)")]
tabvars <- tabvars[!tabvars %in% c("scb_region", "sos_ddr_arni")]
tabvars <- tabvars[!str_detect(tabvars, "^(scb_nc_|sos_com_nc_|sos_ddr_nc_)")]

tabvars_nc <- names(pop)[str_detect(names(pop), "^(scb_|sos_com_nc_|sos_ddr_nc_)")]
tabvars_nc <- tabvars_nc[!tabvars_nc %in% c("scb_age", "scb_region", "sos_ddr_nc_arni")]

# vars fox log reg
tabvars_not_in_mod <- c(
  "scb_dispincome",
  "scb_maritalstatus",
  "sos_ddr_rasi",
  "sos_ddr_acei",
  "sos_ddr_arb",
  "sos_ddr_mra",
  "sos_ddr_nc_rasi",
  "sos_ddr_nc_acei",
  "sos_ddr_nc_arb",
  "sos_ddr_nc_mra"
)

modvars <- tabvars[!(tabvars %in% tabvars_not_in_mod)]
modvarsns <- modvars
modvarsns[modvars == "scb_age"] <- "ns(scb_age, 4)"

modvars_nc <- tabvars_nc[!(tabvars_nc %in% tabvars_not_in_mod)]
modvarsns_nc <- modvars_nc
modvarsns_nc[modvars_nc == "scb_nc_age"] <- "ns(scb_nc_age, 4)"
