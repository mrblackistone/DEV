#Functions
def my_func(word) :
    print(word + "!")
my_func("First")
my_func("Second")

def my_sum(x, y) : #x and y are parameters
    print(x + y)
my_sum(5,9) #5 and 9 are arguments

def max(x, y) :
    if x >= y :
        return x
    else :
        return y
print(max(4, 7)) #returns 7
z = max(8,5)
print(z) #returns 8

def addNumbers(x, y) :
    total = x + y
    return total
    print("This text will never print") #return command leaves the function immediately
print(addNumbers(4,5)) #returns 9

#Comments and docstrings
def shout(word) : #This is a comment, and below is a docstring
    """
    Function adds an
    exlamation mark
    """
    print(word + "!")
shout("dude")

#Assign a function to a variable
def multiply(x, y) :
    return x * y
a = 4
b = 7
operation = multiply
print(operation(a, b)) #returns 28

#Functions as arguments to other functions
def do_twice(func, x, y) :
    return func(func(x, y), func(x, y))
a = 5
b = 10
print(do_twice(addNumbers, a, b)) #addNumbers was defined earlier
#returns 30

#Module import
import random
for i in range(5) :
    value = random.randint(1,5)
    print(value)

#Partial module import
from math import pi, sqrt
print(pi)
print(sqrt(5))

#Import module or sub-module under a different name
from math import sqrt as square_root
print(square_root(7))

#Types of modules:  Ones you create, ones you download, ones that come with Python
#Standard modules:  string, re, datetime, math, random, os, multiprocessing,
#subprocess, socket, email, json,doctest, unittest, pdb, argparse, and sys
#Some of the standard modules are written in Python and others in C
#To install a library, use pip:  pip install library_name