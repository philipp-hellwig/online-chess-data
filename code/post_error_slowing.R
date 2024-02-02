library(tidyverse)
source("./chess_utils.R")
options(scipen=999)
rapid_games = read.csv("../data/rapid_games_Dec15final.csv")

pes = data.frame(matrix(ncol=4, nrow=0))
colnames(pes) = c("pre_rt","pre_cpl","post_rt","post_cpl")


for(user in unique(rapid_games$username)){
  usr_data = subset(rapid_games, username==user)
  pre_rts = numeric()
  pre_cpls = numeric()
  post_rts = numeric()
  post_cpls = numeric()
  for(i in 1:nrow(usr_data)){
    cpl = csv_list_to_vec(usr_data[i,"cp_losses"], numeric=TRUE)
    times = csv_list_to_vec(usr_data[i,"moveTimes"], numeric=TRUE)
    if(length(cpl) > 3){
      for(index in 2:(length(cpl)-1)){
        if(cpl[index]>199){
          pre_rts = append(pre_rts, times[index-1])
          pre_cpls = append(pre_cpls, cpl[index-1])
          post_rts = append(post_rts, times[index+1])
          post_cpls = append(post_cpls, cpl[index+1])
        }
      }
    }
  }
  pes[user,] = c(
    mean(pre_rts, na.rm=TRUE),
    mean(pre_cpls, na.rm=TRUE),
    mean(post_rts, na.rm=TRUE),
    mean(post_cpls, na.rm=TRUE)
  )
}

tfit = t.test(pes$post_rt, pes$pre_rt, paired=TRUE) # paired t-test for RTs (thinking times)
mean(pes$post_rt, na.rm=TRUE); sd(pes$post_rt, na.rm=TRUE)
mean(pes$pre_rt, na.rm=TRUE); sd(pes$pre_rt, na.rm=TRUE)

t.test(pes$pre_cpl, pes$post_cpl, paired=TRUE) # paired t-test for centipawn losses
mean(pes$post_cpl, na.rm=TRUE); sd(pes$post_cpl, na.rm=TRUE)
mean(pes$pre_cpl, na.rm=TRUE); sd(pes$post_cpl, na.rm=TRUE)

plot(
  c(0.5,1.5),
  c(mean(pes$pre_rt, na.rm=TRUE), mean(pes$post_rt, na.rm=TRUE)),
  ylim = c(0,20),
  xlim = c(0, 2),
  xlab = "",
  ylab = "avg. in seconds",
  xaxt="n"
  )
axis(1, c(0.5,1.5), c("pre","post"))

