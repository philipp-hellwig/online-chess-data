import re
with open("../data/lichess_db_standard_rated_2023-10.pgn", "r") as file:
    data = file.read()
users = re.findall(r'White "(\w*)"]', data) + re.findall(r'Black "(\w*)"]', data)
users = set(users) # include each username only once

with open('../data/usernames.txt', 'w', newline='') as file:
    file.write(",".join(users))
