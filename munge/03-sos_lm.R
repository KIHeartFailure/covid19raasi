
# Treatments from the DDR -------------------------------------------------


# within 5 months prior to index

lm <- lm %>%
  filter(
    EDATUM >= global_indexdtm - 30.5 * 5,
    EDATUM <= global_indexdtm
  )

lmtreats <- function(atc, treatname) {
  lmtmp2 <- lm %>%
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

  metatmp <- c(treatname, stringr::str_replace_all(atc, "\\|", ","))
  if (exists("metalm")) {
    metalm <<- rbind(metalm, metatmp) # global variable, writes to global env
  } else {
    metalm <<- metatmp # global variable, writes to global env
  }
}


lmtreats("^(C09A|C09B)", "acei")
lmtreats("^(C09C|C09D(?!X04))", "arb")
lmtreats("^(C03(?!DA)|C07B|C07C|C07D|C08GA|C09BA|C09DA|C09DX01)", "diuretics")
lmtreats("^C07", "bbl")
lmtreats("^(C08|C07FB|C09BB|C09DB|C09DX01)", "ccb")
lmtreats("^C03DA", "mra")
lmtreats("^C09DX04", "arni")
lmtreats("^B01AC", "antiplatlet")
lmtreats("^B01A(?!C)", "anticoagulant")
lmtreats("^A10A", "insulin")
lmtreats("^A10B", "oralantidiabetic")
lmtreats("^C10", "lipidlowering")
lmtreats("^C01AA05", "digoxin")
lmtreats("^C01DA", "nitrate")
lmtreats("^C01B", "antiarrhythmic")

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
