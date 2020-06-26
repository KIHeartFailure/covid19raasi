
ProjectTemplate::reload.project(cache_loading = FALSE)

sospath <- "./raw-data/SOS/"

# Data 2019, 2020 ov, sv --------------------------------------------------

load(paste0(sospath, "tmpdata/svov_cov.RData"))

svov_cov <- bind_rows(
  sv_cov2019 %>% mutate(sos_source = "sv"),
  ov_cov2019 %>% mutate(sos_source = "ov"),
  sv_cov2020 %>% mutate(sos_source = "sv"),
  ov_cov2020 %>% mutate(sos_source = "ov")
) %>% 
  select(-starts_with("OPD"), -KON, -ALDER, -MVO, -VTID, -UTSATT, -PVARD, -LK, -INDATUMA, -UTDATUMA)

svov_cov <- svov_cov %>%
  rename_at(
    vars(starts_with("op")),
    list(~ toupper(.))
  ) %>%
  rename_at(
    vars(starts_with("EKOD")),
    list(~ tolower(.))
  ) %>%
  rename(HDIA = hdia) %>%
  filter(!is.na(INDATUM))

svov_cov <- prep_sosdata(svov_cov, utdatum = FALSE)

save(file = paste0(sospath, "tmpdata/svov_cov_prep.RData"), "svov_cov")

rm(list = c(
  "sv_cov2019",
  "ov_cov2019",
  "sv_cov2020",
  "ov_cov2020", 
  "svov_cov"))


# SV ----------------------------------------------------------------------

load(paste0(sospath, "tmpdata/sv.RData"))

sv <- sv %>%
  select(-starts_with("OPD"), -KON, -ALDER, -MVO, -VTID, -UTSATT, -PVARD, -lk, -LKF, -INDATUMA, -UTDATUMA) %>%
  mutate(sos_source = "sv") %>%
  rename_at(
    vars(starts_with("op")),
    list(~ toupper(.))
  ) %>%
  rename_at(
    vars(starts_with("EKOD")),
    list(~ tolower(.))
  ) %>%
  rename(HDIA = hdia) %>%
  filter(!is.na(INDATUM))

sv <- prep_sosdata(sv, utdatum = FALSE)

save(file = paste0(sospath, "tmpdata/sv_prep.RData"), "sv")

rm(sv)

# OV ----------------------------------------------------------------------

load(paste0(sospath, "tmpdata/ov.RData"))

ov <- ov %>%
  select(-starts_with("OPD"), -KON, -ALDER, -MVO, -PVARD, -lk, -LKF, -INDATUMA) %>%
  mutate(sos_source = "ov") %>%
  rename_at(
    vars(starts_with("op")),
    list(~ toupper(.))
  ) %>%
  rename_at(
    vars(starts_with("EKOD")),
    list(~ tolower(.))
  ) %>%
  rename(HDIA = hdia) %>%
  filter(!is.na(INDATUM))

ov <- prep_sosdata(ov, utdatum = FALSE)

save(file = paste0(sospath, "tmpdata/ov_prep.RData"), "ov")

rm(ov)


# All together now https://www.youtube.com/watch?v=73lj5qJbrms ------------

load(paste0(sospath, "tmpdata/svov_cov_prep.RData"))
load(paste0(sospath, "tmpdata/sv_prep.RData"))
load(paste0(sospath, "tmpdata/ov_prep.RData"))

patreg <- bind_rows(
  sv,
  ov,
  svov_cov
)

rm(list = c(
  "sv",
  "ov",
  "svov_cov"))

patreg <- patreg %>%
  mutate(LopNr = as.numeric(LopNr))

save(file = "./data/rawData_sos_patreg.RData", "patreg")