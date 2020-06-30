
ProjectTemplate::reload.project(reset = TRUE)

load("./data/rawData_scb.RData")
load("./data/rawData_sos_dors.RData")

save(file = "./data/tmpdata/pop_scb_dors.RData", list = c("pop"))
load(file = "./data/tmpdata/pop_scb_dors.RData")

load("./data/rawData_sos_lm.RData")

save(file = "./data/tmpdata/pop_scbdorslm.RData", list = c("pop", "metalm"))
load(file = "./data/tmpdata/pop_scbdorslm.RData")

load("./data/rawData_sos_patreg.RData")

save(file = "./data/tmpdata/pop_scbdorslmpatreg.RData", list = c("pop", "metalm", "metaout"))
load("./data/tmpdata/pop_scbdorslmpatreg.RData")