setwd("C:/Users/4malteses/Desktop/RandomTweets/TF-IDF")

### data
data <- read.csv("full.csv", header = T, stringsAsFactors =F)
names(data)[1] <- "text"

# add class
class <- rep(1, dim(data)[1])
data <- cbind(data, class)

### detect reply if possible
#reg <- "^@([a-zA-Z0-9]+://)?"
#whetherReply <- grep(reg, data$text, ignore.case = FALSE)
#
#data.rp <- rep(0, dim(data)[1])
#data.rp[whetherReply] <- 1
#data <- cbind(data, data.rp)
#names(data) <- c("text", "reply")

## remove url
reg <- "([a-zA-Z0-9]+://)?([a-zA-Z0-9_]+:[a-zA-Z0-9_]+@)?([a-zA-Z0-9.-]+\\.[A-Za-z]{2,4})(:[0-9]+)?(/.*)?"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

## remove <>
reg <- "<[a-zA-Z0-9.-\\+]+>"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

## remove \n
reg <- "\n"
data$text <- gsub(pattern = reg, replacement = " ", data$text, ignore.case = T)

## remove & ..
reg <- "&amp"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)
reg <- "&gt"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

## remove @username
reg <- "@+([a-zA-Z0-9_+-]+)"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

## remove #
reg <- "#sarcasm"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

## remove #
reg <- "#"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

### new requests
## Whether there is UTF-8 dash
data.dash <- rep(0, dim(data)[1])
# em-dash
reg <- "[��]{1,}"
dash <- grep(reg, data$text)
data.dash[dash] <- 1
# horizontal bar
reg <- "[�D]{1,}"
dash <- grep(reg, data$text)
data.dash[dash] <- 1
# en-dash
reg <- "[�C]{2,}"
dash <- grep(reg, data$text)
data.dash[dash] <- 1
# figure-dash
reg <- "[???]{2,}"
dash <- grep(reg, data$text)
data.dash[dash] <- 1
## normal dash
data.dash <- rep(0, dim(data)[1])
reg <- "[-]{3,}"
dash <- grep(reg, data$text)
data.dash[dash] <- 1
data <- data.frame(data, data.dash)


### detect non character, non ASCII
data$text <- iconv(data$text, "latin1", "ASCII", sub="")

# trim white space just in case
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
data$text <- trim(data$text)

# delete tweets with less than 8 chars
len <- dim(data)[1]
for (i in 1:len) {
  if (nchar(data$text[i]) <= 8) {
    data$text[i] <- NA
  }
}

# remove NA
data <- na.omit(data)

# trim white space just in case
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
data$text <- trim(data$text)


# delete the exactly same tweets
len <- dim(data)[1]
count <- 1
while (count < len) {
  while (is.na(data$text[count])) {
    count <- count + 1
  }
  
  text.item <- data$text[count]
  
  for (i in (count+1):len) {
    if (is.na(data$text[i])) {
      next
    }
    
    if (text.item == data$text[i]) {
      data$text[i] <- NA
    }
  }
  
  count <- count + 1
}

# remove NA
data <- na.omit(data)

### new requests
## Whether there is repetition of vowels
checkers <- c("a", "e", "i", "o", "u", "y")
data.vow <- rep(0, dim(data)[1])
for (i in 1:length(checkers)) {
  reg <- paste("[", checkers[i], toupper(checkers[i]), "]{3,}", sep = "")
  vow <- grep(reg, data$text, ignore.case = FALSE)
  data.vow[vow] <- 1
}
data <- data.frame(data, data.vow)

## Whether there is ... 
data.elip <- rep(0, dim(data)[1])
reg <- "[\\.\\.\\.]{3,}"
elip <- grep(reg, data$text)
data.elip[elip] <- 1
data <- data.frame(data, data.elip)

## Whether there is !
data.excl <- rep(0, dim(data)[1])
reg <- "[\\!]"
excl <- grep(reg, data$text)
data.excl[excl] <- 1
data <- data.frame(data, data.excl)

## Whether there is a capitalized word
data.cap <- rep(0, dim(data)[1])
reg <- "[A-Z][A-Z]+"
cap <- grep(reg, data$text)
data.cap[cap] <- 1
data <- data.frame(data, data.cap)

write.csv(data, "refined-sarc.csv", row.names = F)
