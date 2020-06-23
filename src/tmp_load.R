
ProjectTemplate::reload.project()

load("./data/rawData_scb.RData")

save(file = "./data/pop_scb.RData", list = c("pop"))
load(file = "./data/pop_scb.RData")

load("./data/rawData_sos_dors.RData")

load("./data/rawData_sos_lm.RData")

save(file = "./data/pop_scbdorslm.RData", list = c("pop", "metalm"))
load(file = "./data/pop_scbdorslm.RData")

load("./data/rawData_sos_patreg.RData")

save(file = "./data/pop_scbdorslmpatreg.RData", list = c("pop", "metalm", "outcommeta"))
save(file = "./data/pop.RData", list = c("pop"))