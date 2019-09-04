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
tweets_zomato3 = searchTwitter('#zomato', n=200)

#Transform tweets list into a data frame
tweets.df <- twListToDF(tweets_zomato)
tweets.df2 <- twListToDF(tweets_zomato2)
tweets.df3<- twListToDF(tweets_zomato3)

write.csv(tweets.df, file="tweets.csv", row.names=FALSE)
write.csv(tweets.df2, file="tweets2.csv", row.names=FALSE)
write.csv(tweets.df3, file="tweets3.csv", row.names=FALSE)



