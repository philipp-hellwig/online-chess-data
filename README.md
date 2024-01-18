# Online Chess Data
The repository for my bachelor's thesis "Leveraging Online Chess Data for Psychological Research" at the University of Amsterdam.

### Resources
- Database of all games on lichess.org by month: https://database.lichess.org/
- Lichess API documentation: https://lichess.org/api
- Python *berserk* documentation: https://berserk.readthedocs.io/
- Python *stockfish* documentation: https://pypi.org/project/stockfish/

### Steps to recreate Data acquisition as done in the paper
Disclaimer: you may have to change paths and filenames depending on how they are stored on your computer.  
1. Download data from https://database.lichess.org/
    - download the .pgn.zst file for one month.
    - extract it using Peazip(https://peazip.github.io/), (I stopped extraction after 5 minutes or so because the file was too big for my hard drive - leaving me with a partial .pgn file). 
2. Run *get_lichess_usernames.py* to extract unique usernames from the .pgn file
3. Run *Lichess_API_Scraping.ipynb*:
    - to access the API, you need to create a lichess account and generate an API token (after creating an account go to https://lichess.org/account/profile > API access tokens).
4. Run *san2lan.R* to convert SAN (short algebraic notation) to LAN (long algebraic notation).
   - this is necessary because the stockfish python implementation can only take LAN as input.
5. Run *Chess_game_stage_metrics.ipynb*:
    - you need to install stockfish (https://stockfishchess.org/) and update the reference path where the .exe is stored on your computer.

### Data Sets Descriptions
1. rapid_games.csv: The data for all the rapid games. The column names refer to the following:
- username: the username on lichess.org
- id: the link to the game.
- rated: whether the game was rated.
- speed: which time format the game had.
- createdAt: the date and time at which the game was created.
- lastMoveAt: the date and time at which the game ended.
- status: how the outcome of the game was decided.
- winner: which side won the game (empty in case of a draw).
- opening: The type of opening that was played in the game.
- moves: the moves of the game in short algebraic notation (SAN).
- clocks: the time on the users clock at the beginning of the corresponding move in centiseconds.
- clock: the exact time format of the game given by the initial time in seconds and the increment added per move in seconds.
- analysis: server-side analysis of the game. This is only provided if someone analysed this particular game.
- white: the username of the player who played the White pieces.
- black: the username of the player who played the Black pieces.
- outcome: the outcome of the game from the perspective of "username".
- LAN: the moves of the game in long algebraic notation (LAN).
- evaluation: the centipawn evaluations I added using a local version of Stockfish at depth 15.
- cp_losses: the loss in centipawns for each move of "username" for each move in the game.
- blunders: the number of moves by "username" which lost more than 200 centipawns.
- increment: the increment of the game in seconds.
- moveTimes: the duration "username" spent for each of their moves in seconds.
- averaged_cp_loss: the average centipawn loss across all of the moves by "username" in that game.
- dateCreated: the date the game was created.
3. rapid_ratings.csv:
4. puzzle_ratings.csv:
