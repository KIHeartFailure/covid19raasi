
# Time on treatment --------------------------------------------------------

lmtime <- function(atc, treatname, lmdata = lmrasmra) {
  treatvar <- paste0("sos_ddr_", treatname)
  treattimevar <- paste0("sos_ddr_", treatname, "_time")

  lmtmp <- left_join(pop %>%
    filter(!!sym(treatvar) == "Yes") %>%
    select(LopNr),
  lmdata %>%
    mutate(atcneed = stringr::str_detect(ATC, atc)) %>%
    filter(
      atcneed,
      EDATUM <= global_indexdtm
    ),
  by = "LopNr"
  )

  lmtmp <- lmtmp %>%
    group_by(LopNr) %>%
    arrange(EDATUM) %>%
    slice(c(1, n())) %>%
    mutate(firstlast = ifelse(row_number() == 1, "firstdtm", "lastdtm")) %>%
    ungroup()

  lmtmp2 <- inner_join(lmtmp %>%
    filter(firstlast == "firstdtm") %>%
    select(LopNr, EDATUM),
  lmtmp %>%
    filter(firstlast == "lastdtm") %>%
    select(LopNr, EDATUM),
  by = "LopNr",
  suffix = c("_first", "_last")
  ) %>%
    mutate(!!treattimevar := as.numeric(EDATUM_last - EDATUM_first) / 365.25)

  pop <<- left_join(pop,
    lmtmp2,
    by = "LopNr"
  )
}


lmtime("^(C09A|C09B)", "acei")

lmtime("^(C09C|C09D(?!X04))", "arb")

lmtime("^(C09A|C09B|C09C|C09D(?!X04))", "rasi")

lmtime("^C03DA", "mra")
