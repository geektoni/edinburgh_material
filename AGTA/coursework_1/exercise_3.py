import random

# Counters for players 1 and 2
# [#rock, #paper, #scissor]
p = {"1": [0.0,0.0,0.0],
    "2":[0.0,0.0,0.0]}

# Return the next move
def next_move(p):
    payoff=[p[2]-p[1], p[0]-p[2], p[1]-p[0]]
    previous=float("-inf")
    maximal=[]
    for i in range(3):
        if (payoff[i] > previous):
            previous = payoff[i]
            maximal=[]
            maximal.append(i)
        elif(payoff[i] == previous):
            maximal.append(i)
    return random.choice(maximal)

# Play the game
for i in range(1,10001):
    next_2_move = next_move(p["1"])
    next_1_move = next_move(p["2"])
    p["1"][next_1_move] += 1
    p["2"][next_2_move] += 1
