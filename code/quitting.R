library(tidyverse)
library(lubridate)
source("./chess_utils.R")
options(scipen=999)

rapid_games = read.csv("../data/rapid_games_Dec15(LAN).csv")

# convert to date times in R:
rapid_games = rapid_games %>%
  mutate(
    createdAt = ymd_hms(createdAt),
    lastMoveAt = ymd_hms(lastMoveAt)
  )

# go through all users
quitting_data = data.frame(matrix(ncol=4, nrow=0))
colnames(quitting_data) = c("total_games", "total_losses", "total_quits", "quit_given_loss")
usernames = unique(rapid_games$username)
for(i in 1:length(usernames)){
  # subset data by username:
  user_data = subset(rapid_games, username == usernames[i])
  # sort with oldest date first:
  user_data = user_data %>%
    arrange(createdAt)

  # loop through all games:
  user_total_quits = 0
  user_quits_given_loss = 0
  user_losses = nrow(subset(user_data, outcome=="loss"))
  user_games = nrow(user_data)
  if(nrow(user_data)>2){
    for(game in 1:(nrow(user_data)-1)){
      #print(user_data[game,"lastMoveAt"] - user_data[game+1,"createdAt"])
      if(user_data[game+1,"createdAt"] - user_data[game,"lastMoveAt"] > 30){
        user_total_quits = user_total_quits + 1
        if(user_data[game,"outcome"]=="loss"){
          user_quits_given_loss = user_quits_given_loss + 1
        }
      }
    }
    quitting_data[usernames[i],] = c(user_games, user_losses, user_total_quits, user_quits_given_loss)
  }
}

# adding p and q statistics:
quitting_data = quitting_data %>%
  mutate(
    p = (total_quits-quit_given_loss)/(total_games-total_losses),
    q = quit_given_loss/total_losses
  )

# adding grit statistic:
quitting_data = quitting_data %>%
  mutate(
    grit = log(p/(1-p) * (1-q)/q)
  )


# regression with rank

ratings = read.csv("../data/rapid_ratings_Dec15.csv")

usernames = unique(ratings$username)

for(user in usernames){
  user_ratings = subset(ratings, username==user)
  quitting_data[user, "rating"] = mean(user_ratings$rating)
}

quitting_data = quitting_data[complete.cases(quitting_data),]
cor(quitting_data$grit, quitting_data$rating)
