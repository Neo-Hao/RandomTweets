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


# trim the white leading and tailing space
trim <- function (x) {
  gsub("^\\s+|\\s+$", "", x)
}


# save the clean data in a csv file in the working directory
# input: hashtag -- character, fileLocation -- character, nameOfFile -- character
# output: a csv file in the working directory
getData <- function(inputFileName, outputFileName) {
  fileUrl <- inputFileName
  doc <- htmlTreeParse(fileUrl, useInternal= TRUE)
  rootNode <- xmlRoot(doc)
  # get the unchanged tweet content
  tweets.messyContent <- xpathSApply(rootNode, "//p[@class='TweetTextSize  js-tweet-text tweet-text']", xmlValue)
  
  # merge the data into a dataframe
  data <- data.frame(tweets.messyContent)
  names(data) <- c("Messy text")
  
  # write the result into csv file
  write.csv(data, file = outputFileName)
}

# sample application of functions
getData("full.html", "full.csv")
getData("other.html", "other.csv")
