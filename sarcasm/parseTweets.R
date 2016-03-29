setwd("C:/Users/4malteses/Desktop/RandomTweets/sarcasm")

# load necessary packages
if (require(stringr) == FALSE) {
  install.packages("stringr")
  library(stringr)
}
if (require(XML) == FALSE) {
  install.packages("XML")
  library(XML)
}


fileUrl <- "full.html"
doc <- htmlTreeParse(fileUrl, useInternal= TRUE)
rootNode <- xmlRoot(doc)
# get the unchanged tweet content
tweets <- xpathSApply(rootNode, "//p[@class='TweetTextSize  js-tweet-text tweet-text']", xmlValue)

titles <- xpathSApply(rootNode, "//p[@class='TweetTextSize  js-tweet-text tweet-text']", function(x) {
  if (xpathSApply(x, "boolean(./img['twitter-emoji'])")) {
    xpathSApply(x, "./img['twitter-emoji']", xmlGetAttr, 'title')
  } else {
    " "
  }
})

emoji.names <- vector()
count <- 1

for (i in 1:length(titles)) {
  if (titles[[i]][1] == " ") {
    next
  } 
  
  len = length(titles[[i]])
  for (j in 1:len){
    if (!(titles[[i]][j] %in% emoji.names)) {
      emoji.names[count] <- titles[[i]][j]
      count <- count + 1
    }
  }
}

emoji.matrix <- matrix(0, length(titles), length(emoji.names))
for (i in 1:length(titles)) {
  if (titles[[i]][1] == " ") {
    next
  }
  
  len1 = length(titles[[i]])
  len2 = length(emoji.names)
  for (j in 1:len1){
    for (k in 1:len2) {
      if (titles[[i]][j] == emoji.names[k]) {
        emoji.matrix[i,][k] = 1
      }
    }
  }
}


emoji.matrix <- data.frame(emoji.matrix)
names(emoji.matrix) <- emoji.names

emoji.matrix <- data.frame(tweets, emoji.matrix)
write.csv(emoji.matrix, file = "full.csv", row.names = F)