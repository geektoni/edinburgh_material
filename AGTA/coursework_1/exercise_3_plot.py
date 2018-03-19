import random
import matplotlib.pyplot as plt

runs=10000
# [#rock, #paper, #scissor]
p = {"a": [0.0,0.0,0.0],
    "b":[0.0,0.0,0.0]}

# Return the next move
def next_move(p):
    player=[p[2]-p[1], p[0]-p[2], p[1]-p[0]]
    print
    previous=float("-inf")
    maximal=[]
    for i in range(3):
        if (player[i] > previous):
            previous = player[i]
            maximal=[]
            maximal.append(i)
        elif(player[i] == previous):
            maximal.append(i)
    return random.choice(maximal)

def normalize(p):
    total = p[0]+p[1]+p[2]
    p[0] /= float(total)
    p[1] /= float(total)
    p[2] /= float(total)
    return p

a_player=[]
b_player=[]

#p["a"][random.randrange(0, 3)] += 1
#p["b"][random.randrange(0, 3)] += 1

# Play the game
for i in range(1,runs+1):
    next_b_move = next_move(p["a"])
    next_a_move = next_move(p["b"])
    p["a"][next_a_move] += 1
    p["b"][next_b_move] += 1
    a_player.append(normalize(list(p["a"])))
    b_player.append(normalize(list(p["b"])))

print(normalize(p["a"]))
print(normalize(p["b"]))

font = {'family' : 'normal',
        'size'   : 15}
plt.rc('font', **font)
plt.figure(1, figsize=(15,10))
plt.subplot(211)
plt.ylabel("Probability of different strategies")
[r,p,s] = plt.plot(a_player)
plt.legend([r,p,s], ["Rock", "Paper", "Scissor"])
plt.subplot(212)
plt.ylabel("Probability of different strategies")
plt.xlabel("Number of rounds")
[r,p,s] = plt.plot(b_player)
plt.legend([r,p,s], ["Rock", "Paper", "Scissor"])
plt.savefig("test.png")
