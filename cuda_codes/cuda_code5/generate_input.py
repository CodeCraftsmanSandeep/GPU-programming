import sys
import random

n = int(sys.argv[1])

# generate n random doubles
with open("test_case.txt", 'w') as test_case:
    test_case.write(str(n) + '\n')
    for _ in range(n):
        test_case.write(str(random.uniform(0, 1e6)) + '\n')