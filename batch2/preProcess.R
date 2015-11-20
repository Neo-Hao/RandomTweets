setwd("C:/Users/4malteses/Desktop/RandomTweets/batch2")

### remove stop words

# load data
data <- read.csv("words2.csv", header = F, stringsAsFactors = F)
data <- data[,1]
class(data)
# load stopwords
stopWords <- read.csv("stopwords.csv", header = T, stringsAsFactors = F)
stopWords <- stopWords$words
# delete stop words
len <- length(data)
lenBlank <- 0
for (i in 1:len) {
  if (data[i] %in% stopWords) {
    data[i] = ""
    lenBlank = lenBlank + 1
  }
}
# new data
count <- 1
newData <- vector(mode="character", length=len - lenBlank)
for (i in 1:len) {
  if (data[i] != "") {
    newData[count] <- data[i]
    count = count +1
  }
}

write.csv(newData, file = "words2.csv", row.names=F)


