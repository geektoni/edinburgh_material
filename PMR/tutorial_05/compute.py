A = [2, 4]
B = [4, 4]
D = [8,2,2,6]
E = [3,6,6,3]
F = [1,8]

def C(a,b,c):
    mat = {
    "000": 4,
    "100": 2,
    "010": 2,
    "110": 6,
    "001": 2,
    "101": 6,
    "011": 6,
    "111": 4
    }
    return mat[str(a)+str(b)+str(c)]

def D(a,b):
    mat = {
    "00": 8,
    "10": 2,
    "01": 2,
    "11": 6
    }
    return mat[str(a)+str(b)]

def E(a,b):
    mat = {
    "00": 3,
    "10": 6,
    "01": 6,
    "11": 3
    }
    return mat[str(a)+str(b)]

total_sum=0
for b in [1]:
    for c in [0,1]:
        for d in [0,1]:
            for e in [0,1]:
                for f in [0,1]:
                    total_sum += B[b]*C(1,b,c)*D(c,d)*E(c,f)*F[f]
print(total_sum*A[1])
