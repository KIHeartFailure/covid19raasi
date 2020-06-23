
ProjectTemplate::reload.project()

# Import data from SCB ----------------------------------------------------

scbpath <- "./raw-data/SCB/Leverans/"

lisa <- readdata_sas(path = scbpath, filename = "lbenson_lev_lisa_2018",
                     checkdups = TRUE)
fodelseuppg <- readdata_sas(path = scbpath, filename = "lbenson_lev_fodelseuppg", 
                            checkdups = TRUE)
migration <- readdata_sas(path = scbpath, filename = "lbenson_lev_migrationer", 
                          lopnr = "Lopnr")
rtb <- readdata_sas(path = scbpath, filename = "lbenson_lev_rtb_2019",
                    checkdups = TRUE)
#doddatum <- readdata_sas(path = scbpath, filename = "lbenson_lev_doddatum",
#                      checkdups = TRUE, lopnr = "Lopnr")
antalbarn <- readdata_sas(path = scbpath, filename = "lbenson_lev_antalbarn",
                          checkdups = TRUE)


# Store as RData in /data folder ------------------------------------------

save(file = "./data/rawData_scb.RData", list = c(
  "lisa",
  "fodelseuppg",
  "migration",
  "rtb",
  "antalbarn"
))

# Import data from SoS ----------------------------------------------------

sospath <- "./raw-data/SOS/"


## LM ---------------------------------------------------------------------

lm <- readdata_sas(path = sospath, filename = "ut_lmed_19_20_18194_2020/lmed_19_20_18194_2020", clean = FALSE)

### Store as RData in /data folder ----------------------------------------

save(file = "./data/rawData_sos_lm.RData", "lm")

rm(lm)

## Death -----------------------------------------------------------------

dors <- readdata_sas(path = sospath, filename = "Ut_dors_18194_2020/r_dors__18194_2020", clean = FALSE, checkdups = TRUE)
dors_cov <- readdata_sas(path = sospath, filename = "Ut_dors_18194_2020/cov_dors_18194_2020", clean = FALSE, checkdups = TRUE)

### Store as RData in /data folder ----------------------------------------

save(file = "./data/rawData_sos_dors.RData", list = c(
  "dors",
  "dors_cov"
))

## Patreg ------------------------------------------------------------------

sv <- readdata_sas(path = sospath, filename = "ut_par_97_18_18194_2020/par_sv_1997_2018_18194_2020", clean = FALSE)
save(file = paste0(sospath, "TEMPdata/sv.RData"), "sv")
rm(sv)

ov <- readdata_sas(path = sospath, filename = "ut_par_97_18_18194_2020/par_ov_1997_2018_18194_2020", clean = FALSE)
save(file = paste0(sospath, "TEMPdata/ov.RData"), "ov")
rm(ov)

sv_cov2019 <- readdata_sas(path = sospath, filename = "ut_par_cov_18194_2020/par_cov_sv_2019_18194_2020", clean = FALSE)
ov_cov2019 <- readdata_sas(path = sospath, filename = "ut_par_cov_18194_2020/par_cov_ov_2019_18194_2020", clean = FALSE)
sv_cov2020 <- readdata_sas(path = sospath, filename = "ut_par_cov_18194_2020/par_cov_sv_2020_18194_2020", clean = FALSE)
ov_cov2020 <- readdata_sas(path = sospath, filename = "ut_par_cov_18194_2020/par_cov_ov_2020_18194_2020", clean = FALSE)

save(file = paste0(sospath, "TEMPdata/svov_cov.RData"), list = c(
  "sv_cov2019",
  "ov_cov2019",
  "sv_cov2020",
  "ov_cov2020"))

rm(list = c(
  "sv_cov2019",
  "ov_cov2019",
  "sv_cov2020",
  "ov_cov2020"))

