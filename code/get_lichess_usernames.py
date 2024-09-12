import re

with open("./data/lichess_db_standard_rated_2024-08.pgn", "r") as file:
    data = file.read(81920000) # limit read to number of max characters
users = re.findall(r'White "(\w*)"]', data) + re.findall(r'Black "(\w*)"]', data)
users = set(users) # include each username only once
with open('./data/usernames_2024-08.txt', 'w', newline='') as file:
    file.write(",".join(users))
