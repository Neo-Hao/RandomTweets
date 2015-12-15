### data
data <- read.csv("nonsarcastic-tweets.csv", header = T, stringsAsFactors =F)

## detect url if possible
reg <- "([a-zA-Z0-9]+://)?([a-zA-Z0-9_]+:[a-zA-Z0-9_]+@)?([a-zA-Z0-9.-]+\\.[A-Za-z]{2,4})(:[0-9]+)?(/.*)?"
whetherLink <- grep(reg, data$text, ignore.case = FALSE)

data.link <- rep(0, dim(data)[1])
data.link[whetherLink] <- 1
data <- cbind(data, data.link)
names(data) <- c("text", "link")

## remove url
reg <- "([a-zA-Z0-9]+://)?([a-zA-Z0-9_]+:[a-zA-Z0-9_]+@)?([a-zA-Z0-9.-]+\\.[A-Za-z]{2,4})(:[0-9]+)?(/.*)?"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

## detect reply if possible
reg <- "^@([a-zA-Z0-9]+://)?"
whetherReply <- grep(reg, data$text, ignore.case = FALSE)

data.rp <- rep(0, dim(data)[1])
data.rp[whetherReply] <- 1
data <- cbind(data, data.rp)
names(data) <- c("text", "link", "reply")

## remove @username
reg <- "@+([a-zA-Z0-9_+-]+)"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

## remove \n
reg <- "\n"
data$text <- gsub(pattern = reg, replacement = "", data$text, ignore.case = T)

## detect non character, non ASCII
data$text <- gsub("[^0-9A-Za-z///' ]", "", data$text)

# delete tweets with less than 5 chars
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

# remove NA
data <- na.omit(data)
len <- length(data)


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
len <- dim(data)[1]
class <- rep(0, len)
data <- cbind(data, class)
write.csv(data, "refined-nonsarc.csv", row.names = F)

# save into three groups
data.haveLinks <- data[data$link == 1,]
data.isReply <- data[data$reply == 1,]
data.rest <- data[data$link == 0,]
data.rest <- data.rest[data.rest$reply == 0,]

write.csv(data.haveLinks, "refined-subset-link.csv", row.names = F)
write.csv(data.isReply, "refined-subset-reply.csv", row.names = F)
write.csv(data.rest, "refined-subset-rest.csv", row.names = F)
