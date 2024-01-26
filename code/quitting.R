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

# create dataframe for quitting data:
quitting_data = data.frame(matrix(ncol=6, nrow=0))
colnames(quitting_data) = c("total_games", "total_losses", "total_quits", "quit_given_loss", "dur_quit_l", "dur_quit_w_or_d")

# loop through all usernames:
usernames = unique(rapid_games$username)
for(i in 1:length(usernames)){
  # subset data by username:
  user_data = subset(rapid_games, username == usernames[i])
  # sort with oldest date first:
  user_data = user_data %>%
    arrange(createdAt)

  user_total_quits = 0
  user_quits_given_loss = 0
  user_losses = nrow(subset(user_data, outcome=="loss"))
  user_games = nrow(user_data)
  dur_quits_l = numeric()
  dur_quits_wd = numeric()

  # loop through each game of the current user:
  if(nrow(user_data)>2){
    for(game in 1:(nrow(user_data)-1)){
      quit_dur = difftime(user_data[game+1,"createdAt"], user_data[game,"lastMoveAt"], units="mins")
      if(quit_dur > 30){
        user_total_quits = user_total_quits + 1
        if(user_data[game,"outcome"]=="loss"){
          user_quits_given_loss = user_quits_given_loss + 1
          dur_quits_l = append(dur_quits_l, quit_dur) # append quitting duration given a loss
        }
        else{
          dur_quits_wd = append(dur_quits_wd, quit_dur) # append duration of the quit given a win.
        }
      }
    }
    quitting_data[usernames[i],] = c(
      user_games,
      user_losses,
      user_total_quits,
      user_quits_given_loss,
      mean(dur_quits_l)/60,
      mean(dur_quits_wd)/60
      )
  }
}

# adding p and q statistics:
quitting_data = quitting_data %>%
  mutate(
    quit_dur = (dur_quit_l + dur_quit_w_or_d)/2,
    p = (total_quits-quit_given_loss)/(total_games-total_losses),
    q = quit_given_loss/total_losses
  )

# adding grit statistic:
quitting_data = quitting_data %>%
  mutate(
    grit = log(p/(1-p) * (1-q)/q)
  )

# load ratings:
ratings = read.csv("../data/rapid_ratings_Dec15.csv")
usernames = unique(ratings$username)
for(user in usernames){
  user_ratings = subset(ratings, username==user)
  quitting_data[user, "rating"] = mean(user_ratings$rating)
}

# drop NA cases
quitting_data = quitting_data[complete.cases(quitting_data),]

# linear regression with grit as a predictor
reg = lm(rating~grit, quitting_data)
summary(reg)
