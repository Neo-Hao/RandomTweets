#setwd("C:/Users/4malteses/Desktop/RandomTweets/batch1")

## collectappend result to a csv file
tweetCollect <- function(hashtag, numberOfTweets, nameOfFile) {
  # search tweets by hashtag
  tweets <- searchTwitter(hashtag, n = numberOfTweets)
  # convert searchtwitter research into dataframe
  tweets <- twListToDF(tweets)
  # return results
  tweets <- as.matrix(tweets$text)
  write.table(tweets, file = nameOfFile, append = TRUE, sep = ",", col.names = FALSE,
              qmethod = "double")
}

## collect tweet function
dataCollector <- function(words, nameOfFile) {
  number <- length(words)
  for (i in 1: number) {
    hashtag <- paste("#", words[i], sep="")
    tweetCollect(hashtag, 500, nameOfFile)
    Sys.sleep(61)
  }
}

## read random words
words <- read.csv("words1.csv", sep=" ", header = F, stringsAsFactors=FALSE)
words <- words[,1]
words <- as.character(words)

dataCollector(words, "nosar1.csv")
