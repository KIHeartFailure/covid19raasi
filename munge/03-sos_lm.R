
# Treatments from the DDR -------------------------------------------------

# within 5 months prior to index

lm_covid <- lm %>%
  filter(
    EDATUM >= global_indexdtm - 30.5 * 5,
    EDATUM <= global_indexdtm
  )

lm_nc <- lm %>%
  filter(
    EDATUM >= global_indexdtm - 365 - 30.5 * 5,
    EDATUM <= global_indexdtm - 365
  )

lmtreats <- function(atc, treatname, lmdata = lm_covid, metatab = TRUE) {
  lmtmp2 <- lmdata %>%
    mutate(
      atcneed = stringr::str_detect(ATC, atc)
    ) %>%
    filter(
      atcneed
    )

  treatname <- paste0("sos_ddr_", treatname)

  lmtmp2 <- lmtmp2 %>%
    group_by(LopNr) %>%
    slice(1) %>%
    ungroup() %>%
    mutate(!!treatname := "Yes") %>%
    select(LopNr, !!sym(treatname))

  pop <<- left_join(pop,
    lmtmp2,
    by = "LopNr"
  ) %>%
    mutate(!!treatname := replace_na(!!sym(treatname), "No"))

  if (metatab) {
    metatmp <- c(treatname, stringr::str_replace_all(atc, "\\|", ","))
    if (exists("metalm")) {
      metalm <<- rbind(metalm, metatmp) # global variable, writes to global env
    } else {
      metalm <<- metatmp # global variable, writes to global env
    }
  }
}


lmtreats("^(C09A|C09B)", "acei")
lmtreats("^(C09A|C09B)", "nc_acei", lmdata = lm_nc, metatab = FALSE)

lmtreats("^(C09C|C09D(?!X04))", "arb")
lmtreats("^(C09C|C09D(?!X04))", "nc_arb", lmdata = lm_nc, metatab = FALSE)

lmtreats("^(C03(?!DA)|C07B|C07C|C07D|C08GA|C09BA|C09DA|C09DX01)", "diuretics")
lmtreats("^(C03(?!DA)|C07B|C07C|C07D|C08GA|C09BA|C09DA|C09DX01)", "nc_diuretics",
  lmdata = lm_nc, metatab = FALSE
)

lmtreats("^C07", "bbl")
lmtreats("^C07", "nc_bbl", lmdata = lm_nc, metatab = FALSE)

lmtreats("^(C08|C07FB|C09BB|C09DB|C09DX01)", "ccb")
lmtreats("^(C08|C07FB|C09BB|C09DB|C09DX01)", "nc_ccb", lmdata = lm_nc, metatab = FALSE)

lmtreats("^C03DA", "mra")
lmtreats("^C03DA", "nc_mra", lmdata = lm_nc, metatab = FALSE)

lmtreats("^C09DX04", "arni")
lmtreats("^C09DX04", "nc_arni", lmdata = lm_nc, metatab = FALSE)

lmtreats("^B01AC", "antiplatlet")
lmtreats("^B01AC", "nc_antiplatlet", lmdata = lm_nc, metatab = FALSE)

lmtreats("^B01A(?!C)", "anticoagulant")
lmtreats("^B01A(?!C)", "nc_anticoagulant", lmdata = lm_nc, metatab = FALSE)

lmtreats("^A10A", "insulin")
lmtreats("^A10A", "nc_insulin", lmdata = lm_nc, metatab = FALSE)

lmtreats("^A10B", "oralantidiabetic")
lmtreats("^A10B", "nc_oralantidiabetic", lmdata = lm_nc, metatab = FALSE)

lmtreats("^C10", "lipidlowering")
lmtreats("^C10", "nc_lipidlowering", lmdata = lm_nc, metatab = FALSE)

lmtreats("^C01AA05", "digoxin")
lmtreats("^C01AA05", "nc_digoxin", lmdata = lm_nc, metatab = FALSE)

lmtreats("^C01DA", "nitrate")
lmtreats("^C01DA", "nc_nitrate", lmdata = lm_nc, metatab = FALSE)

lmtreats("^C01B", "antiarrhythmic")
lmtreats("^C01B", "nc_antiarrhythmic", lmdata = lm_nc, metatab = FALSE)

colnames(metalm) <- c("Variable", "ATC")
metalm <- metalm %>%
  as_tibble() %>%
  mutate(
    ATC = gsub("^", "", ATC, fixed = TRUE),
    ATC = gsub("(", "", ATC, fixed = TRUE),
    ATC = gsub(")", "", ATC, fixed = TRUE),
    ATC = gsub("?!", " excl.", ATC, fixed = TRUE),
    Registry = "Dispensed Drug Registry",
    Period = "-5mo-0",
  )
