
ProjectTemplate::reload.project(reset = TRUE)
memory.limit(size=10000000000000)

load("./data/rawData_scb.RData")
load("./data/rawData_sos_dors.RData")

# run 01-02

save(file = "./data/tmpdata/pop_scb_dors.RData", list = c("pop"))
load(file = "./data/tmpdata/pop_scb_dors.RData")

load("./data/rawData_sos_lm.RData")

# run 03

save(file = "./data/tmpdata/pop_scbdorslm.RData", list = c("pop", "metalm"))
load(file = "./data/tmpdata/pop_scbdorslm.RData")

load("./data/rawData_sos_patreg.RData")

# run 04

save(file = "./data/tmpdata/pop_scbdorslmpatreg.RData", list = c("pop", "metalm", "metaout"))
load("./data/tmpdata/pop_scbdorslmpatreg.RData")

# run 05-08

load("./data/rawData_sos_lmrasmra.RData")

# run 09

save(file = "./data/tmpdata/pop_scbdorslm2.RData", list = c("pop", "metalm"))
load(file = "./data/tmpdata/pop_scbdorslm2.RData")