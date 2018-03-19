place = [-1
    -1
    -1
    -1
    -1
    ]


A = [4 5 2 3 8 
    7 3 7 4 1
    2 4 6 5 2
    9 1 2 9 1
    6 5 4 4 2]

b = [ 0 0 0 0 0 ]

f = [1 0 0 0 0 0]

Aeq = [0 1 1 1 1 1]
beq = 1

u = linprog(f, [place A], b, Aeq, beq)
v = linprog(f, [place -A.'], b, Aeq, beq)

u(1,:)=[]
v(1,:)=[]

v.'*A*u