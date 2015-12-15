data <- read.csv("refined-nonsarc.csv", header = T, stringsAsFactors =F)
len <- dim(data)[1]
number <- 13000
rand <- runif(number, 1, len)
rand <- as.integer(rand)
rand <- sort(rand)
data <- data[rand,]

data.other <- read.csv("refined-sarc.csv", header = T, stringsAsFactors =F)
data <- rbind(data, data.other)
write.csv(data, "total.csv", row.names = F)
