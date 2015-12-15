###### figure out which document is empty
library(tm)

### bring in the data
# load data
#data <- read.csv("data-cleaned.csv", header = T, stringsAsFactors = F)
data <- data$text
len <- length(data)

# trim white space just in case
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
data <- trim(data)

# delete tweets with less than 5 chars
for (i in 1:len) {
  if (nchar(data[i]) <= 8) {
    data[i] <- NA
  }
}

# remove NA
data <- na.omit(data)
len <- length(data)

# make a corpus
docs <- Corpus(VectorSource(data))

### remove sth.
# remove punctuation
docs <- tm_map(docs, removePunctuation)
# remove numbers
docs <- tm_map(docs, removeNumbers)
# remove stop words
docs <- tm_map(docs, removeWords, stopwords("english"))
# remove extra white splace
docs <- tm_map(docs, stripWhitespace)

### further process
# lowercase
docs <- tm_map(docs, tolower)
# stem
#library(SnowballC)
#docs <- tm_map(docs, stemDocument)

### finish pre-process
# make it ready
test.ready <- tm_map(docs, PlainTextDocument)
dtm <- DocumentTermMatrix(test.ready)
# rename rows
rownames(dtm) <- 1:len
# get the number of empty rows
library(slam)
rowTotals <- row_sums(dtm, na.rm = T)
empty <- which(rowTotals == 0)
empty <- as.vector(empty)



###### read in data without empty rows
empty <- -1 * empty
data <- data[empty]
len <- length(data)

####### get tf-idf
library(tm)

# make a corpus
docs <- Corpus(VectorSource(data))

### remove sth.
# remove punctuation
docs <- tm_map(docs, removePunctuation)
# remove numbers
docs <- tm_map(docs, removeNumbers)
# remove stop words
docs <- tm_map(docs, removeWords, stopwords("english"))
# remove extra white splace
docs <- tm_map(docs, stripWhitespace)

### further process
# lowercase
docs <- tm_map(docs, tolower)
# stem
#library(SnowballC)
#docs <- tm_map(docs, stemDocument)

### add meta info
# meta(docs, "tag") <- 1:983


### finish pre-process
# make it ready
test.ready <- tm_map(docs, PlainTextDocument)
dtm <- DocumentTermMatrix(test.ready,
                          control = list(weighting = function(x) weightTfIdf(x, normalize = T),
                                         stopwords = TRUE))
dtm <- removeSparseTerms(dtm, 0.999)

# rename rows
rownames(dtm) <- 1:64525

### tf-idf
write.csv(as.matrix(dtm), file="tf-idf-nonsarc.csv")




