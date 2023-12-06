# Bachelor's thesis "The Shape of Learning"

### Steps to recreate data extraction
Disclaimer: you may have to change paths and filenames depending on how they are stored on your computer.  
1. Download data from https://database.lichess.org/
    - download the .pgn.zst file for one month.
    - extract it using Peazip(https://peazip.github.io/), (I stopped extraction after 5 minutes or so because the file was too big for my hard drive). 
2. Run *get_lichess_usernames.py* to extract unique usernames from the .pgn file
3. Run *san2lan.R* to convert SAN (short algebraic notation) to LAN (long algebraic notation).
   - this is necessary because the stockfish python implementation can only take LAN as input.
5. Run *Lichess_API_Scraping.ipynb*:
    - to access the API, you need to create a API token (https://lichess.org/account/profile > API access tokens).
6. Run *Chess_game_stage_metrics.ipynb*:
    - you need to install stockfish (https://stockfishchess.org/) and reference the path where the .exe is stored on your computer.
