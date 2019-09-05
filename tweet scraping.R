library(twitteR)
library(ROAuth)

#Set API Keys
api_key<- 'XXXXXX'
api_secret<- 'XXXXXX'
access_token<- 'XXXXX'
access_token_secret<- 'XXXXX'


setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)


#Grab Latest Tweets
tweets_zomato =searchTwitter('from:ZomatoIN', n=50)
tweets_zomato2 = searchTwitter('@zomato', n=100)
tweets_zomato3 = searchTwitter('zomato', n=3000)

#Transform tweets list into a data frame
tweets.df <- twListToDF(tweets_zomato)
tweets.df2 <- twListToDF(tweets_zomato2)
tweets.df3<- twListToDF(tweets_zomato3)

write.csv(tweets.df, file="tweets.csv", row.names=FALSE)
write.csv(tweets.df2, file="tweets2.csv", row.names=FALSE)
write.csv(tweets.df3, file="tweets3.csv", row.names=FALSE)


#Adding libraries for wordcloud
library(tm)
library(wordcloud)
library(plyr)
library(RColorBrewer)

#Get tweets text
tweets.text <- tweets.df3[,1]

# Create Corpus
tweet.corpus<- Corpus(VectorSource(tweets.text))

#Clean text
tweet.removeURL<- function(x) gsub("http[^[:space:]]*","",x)
tweet.removeAtUser<- function(x) gsub("@[a-z,A-Z]*","",x)
tweet.removeEmoji<- function(x) gsub("\\p{So}|\\p{Cn}","",x, perl=TRUE)
tweet.removeSpecialChar<- function(x) gsub("[[:punct:]]","",x)
tweet.removeN <- function(x) gsub('\\n', '', x)

tweet.corpus<- tm_map(tweet.corpus, content_transformer(tweet.removeURL))
tweet.corpus<- tm_map(tweet.corpus, content_transformer(tweet.removeAtUser))
tweet.corpus<- tm_map(tweet.corpus, content_transformer(tweet.removeEmoji))
tweet.corpus<- tm_map(tweet.corpus, content_transformer(tweet.removeSpecialChar))
tweet.corpus<- tm_map(tweet.corpus, content_transformer(tweet.removeN))
tweet.corpus<- tm_map(tweet.corpus, removePunctuation, preserve_intra_word_dashes=TRUE)
tweet.corpus<- tm_map(tweet.corpus, content_transformer(tolower))

inspect(tweet.corpus[1:5])

#remove stopwords
tweet.corpus<- tm_map(tweet.corpus, removeWords, c(stopwords("english"), "zomato", "rt"))
tweet.corpus<- tm_map(tweet.corpus, removeNumbers)
tweet.corpus<- tm_map(tweet.corpus, stripWhitespace)


#Create TDM
ap.tdm<- TermDocumentMatrix(tweet.corpus)
ap.m<- as.matrix(ap.tdm)
ap.v<- sort(rowSums(ap.m), decreasing=TRUE)
ap.d<- data.frame(word=names(ap.v), freq=ap.v)

#Create image
pal2<- brewer.pal(8, "Dark2")
png("Zomato.png", width=1920, height = 1080)
wordcloud(ap.d$word, ap.d$freq, scale=c(8,.2), min.freq=25, max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)

dev.off()

stop="STOP"
