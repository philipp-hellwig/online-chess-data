library(bigchess)

# load data set:
rapid_games = read.csv("../data/Lichess Data/rapid_games.csv", header=TRUE)
rapid_games = subset(rapid_games, moves != "")

# transform SAN notation to LAN notation
for(i in 1:nrow(rapid_games)){
  rapid_games[i,"LAN"] = san2lan(rapid_games[i,"moves"])
}

# write to csv
write.csv(rapid_games, "../data/rapid_games(LAN).csv")
