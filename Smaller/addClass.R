class <- read.csv("class.csv", header = T, stringsAsFactors = F)
names(class) <- "theClass"
theClass <- class$theClass
data <- read.csv("tf-idf.csv", header = T, stringsAsFactors = F)
data <- cbind(theClass, data)

write.csv(data, "tf-idf.csv", row.names = F)
