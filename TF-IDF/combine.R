data <- read.csv("refined-nonsarc.csv", header = T, stringsAsFactors =F)
data.other <- read.csv("refined-sarc.csv", header = T, stringsAsFactors =F)
data <- rbind(data, data.other)
write.csv(data, "total.csv", row.names = F)