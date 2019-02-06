#Crypto Random
import os #os module is needed for urandom
os.urandom(10) #returns 10 random bytes suitable for cryptography
type(os.urandom(10)) #returns the type
map(ord, os.urandom(10))

#System Random
from random import SystemRandom
cryptogen = SystemRandom()
[cryptogen.randrange(3) for i in range(20)] #random ints in range 3
[cryptogen.random() for i in range(3)] #randomfloats in [0., 1.]
