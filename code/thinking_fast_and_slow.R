library(tidyverse)
source("./chess_utils.R")
library(latex2exp)
library(diptest)
library(LaplacesDemon)
library(devtools)
# install_github("choisy/cutoff")
library(cutoff)

rapid_games = read.csv("../data/rapid_games_Dec15final.csv")
# only analyze move times for games with time format 10+5:
ten_plus_five = subset(rapid_games, clock=="{'initial': 600, 'increment': 5, 'totalTime': 800}")
move_times = numeric()

for(i in 1:nrow(ten_plus_five)){
  move_times = append(move_times, csv_list_to_vec(ten_plus_five[i,"moveTimes"], numeric=TRUE))
}

# replace premoves (time==0) with a very small number instead:
move_times[move_times==0] = 1e-5
# drop negative move times (this can occur if the opponent gives the user extra time for their move):
move_times = move_times[move_times>0]
log_move_times = sapply(move_times, FUN=log)
# plot thinking time distribution
hist(
  log_move_times,
  breaks = 200,
  xlim = c(-2,5),
  xlab = "Thinking Times in log(seconds)",
  lty="blank",
  col="blue",
  main=NULL
  )

# reducing the size of the data as the shapiro wilk only allows for a maximum of 5000 observations:
shapiro_move_times = sample(log_move_times, 5000)
shapiro.test(shapiro_move_times)

# Hartigan's dip test for uni-/ multimodality
dip.test(log_move_times)
# test for bimodality
is.bimodal(log_move_times)

# mixed model estimation
out <- cutoff::em(log_move_times,"normal","normal")
confint(out)

# plotting
hist(
  log_move_times,
  breaks = 200,
  probability = TRUE,
  xlim = c(-2,5),
  xlab = "Thinking Times in log(seconds)",
  lty="blank",
  col="blue",
  main=NULL
)
dist = function(x, mean, sd, proportion){
  return(dnorm(x, mean, sd) * proportion )
}
# plotting the pdf of d1
curve(dist(x, out$param[1], out$param[2], mean(out$lambda)), -2, 5, add=TRUE, lwd=2, lty=2)

# plotting the pdf of d2
curve(dist(x, out$param[3], out$param[4], 1-mean(out$lambda)), -2, 5, add=TRUE, lwd = 2, lty=3)

legend(
  -2, 0.37,
  legend=c(TeX(r'($d_1$)'),TeX(r'($d_2$)')),
  col="black",
  lwd=2,
  lty=2:3,
  box.lty=0,
  bg="transparent"
  )
