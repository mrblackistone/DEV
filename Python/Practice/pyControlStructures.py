#Boolean and comparison operators
trueVar = True
falseVar = False
trueVar == falseVar #Returns false
trueVar != falseVar #Returns true
8.0 > 5 #Returns true
1 <= 5 #Returns true
8.7 <= 8.70 #Returns true

#If statements
#Code blocks require indentation
if 10 > 9 :
    print("True 'nuf")
print("Done")
num = 12
if num > 5 :
    print("Bigger than 5")
    if num >= 10 :
        print("At least 10")

#Else statements
x = 4
if x == 5 :
    print("It's 5")
else :
    print("It's not 5")

#Elif (ElseIf) statements
num = 7
if num == 5 :
    print("It's 5")
elif num == 7 :
    print("It's 7")
else :
    print("Nope")

#Boolean logic
1 == 1 and 2 == 2 #Returns true
1 == 1 and 2 == 3 #Returns false
1 == 1 or 2 == 3 #Returns true
not 1 == 1 #Returns false
not 1 > 7 #Returns true
#"if not true" returns false, and elif and else only evaluate if initial "if" is false, therefore...
if not True :
    print("1")
elif not (1+1 == 3) :
    print("2")
else:
    print("3")
#...returns 2

#Operator precedence:  Follows PEMDAS; comparison operators are higher precedence than boolean logic...
False == False or True #Returns True
False == (False or True) #Returns False
(False == False) or True #Returns True
#Precedence:
# **            (Exponentiation)
# ~, +, -       (Complement, unary plus and minus.  Method names for last two are +@ and -@)
# *, /, %, //   (Multiply, divide, modulus, and floor division)
# +, -          (Addition, subtraction)
# >>, <<        (Right and left bitwise shift)
# &             (Bitwise AND)
# ^             (Bitwise XOR)
# |             (Bitwise OR)
# in, not in, is, is not, <, <=, >, >=, !=, ==
# not
# and
# or
# =, %=, /=, //=, -=, +=, *=, **=

#While loops
i = 1
while i <= 5 :
    print(i)
    i += 1
print("Done")
while 1 == 1 : #Infinite loop
    print("Looping")
#Break stops a loop immediately
i = 0
while 1 == 1 : #or you could use "while True" for an infinite loop
    print(i)
    i += 1
    if i >= 5 :
        print("Breaking")
        break
print("Done")
#Continue breaks only the current iteration of the loop, skipping back to the top

#Lists (like Arrays)
listVar = ["foo","bar","!!!"]
print(listVar[0]) #Returns foo
blankListVar = []
singleItem = [5,] #Ending comma does not define an additional item, and can be left off if desired
variedList = ["string",42,["foo","bar",],7.62]
print(variedList[2][1]) #Returns bar
stringVar = "Some words" #String is just a list of CHARs
print(stringVar[2]) #Returns m
variedList[0] = "foo" #Change value as list index location.  Can't do this for string, though
print(variedList) #Returns with modified value on 0 index
numsList = [1,2,3,4,5]
print(numsList + [4,5,6]) #Returns longer concatenated single list
print(numsList * 3) #Returns single list with contents in triplicate
#List Operations
wordList = ["foo","bar","desk","chair"]
print("foo" in wordList) #Returns True
print("jifweojfewoeo" in wordList) #Returns Falsee
print(not "foo" in wordList) #Returns False
print("foo" not in wordList) #Returns False, just with different order
print("ifjweojfewo" not in wordList) #Returns True
wordList.append("appended word") #Append method appends indexed item to list
len(wordList) #Len function returns number of indexed items in list
wordList.insert(2,"inserted word") #Insert method inserts a new value into a list, and shifts existing items to the right
wordList.index("inserted word") #Index method finds the FIRST matching value and returns its index
max(wordList) #Max function returns list item with greatest value.  Won't work with mixed str and num data types.
min(wordList) #Min function returns list item with smallest value.  Won't work with mixed str and num data types.
wordList.count("foo") #Count method returns number of instances of an object in a list
wordList.remove() #Remove method removes the first matching object from a list
wordList.reverse() #Reverse method reverses the order of the list object itself (doesn't just return a reversed order)
#Range object.
#Single argument ranges from 0 to int 1 below provided value.
rangeList = list(range(10)) #Creates a list from a range object.  Without the call to "list" a range object is created instead.
rangeObject = range(10) #Range object created.  This is NOT a list.
rangeList #Returns: [0,1,2,3,4,5,6,7,8,9]
rangeObject #Returns object: range(0,10)
#  Two arguments range from first arg to 1 below second arg.
z = list(range(3,8)) #Returns
print(z) #Returns [3,4,5,6,7]
# Three arguments are same as two, but third is interval.
z = list(range(5,20,3))
print(z) #Returns [5,8,11,14,17]

#For loops
#While loop was like this:
wordList = ["this","is","a","list"]
counter = 0
max_index = len(wordList) - 1
while counter <= max_index :
    word = wordList[counter]
    print(word + "!")
    counter = counter + 1
#Shorter FOR syntax gives us this:
wordList = ["this","is","a","list"]
for word in wordList :
    print (word + "!")
#Can use range to limit repetitions when no list is used:
for varname in range(5) :
    print(varname) #Returns range values

#Simple calculator
while True :
    print("Options: add, sub, mult, div, quit")
    user_input = input(": ")
    if user_input == "quit" :
        break
    elif user_input == "add" :
        num1 = float(input("Enter a number: "))
        num2 = float(input("Enter another: "))
        print(num1 + num2)
    elif user_input == "sub" :
        num1 = float(input("Enter a number: "))
        num2 = float(input("Enter another: "))
        print(num1 - num2)
    elif user_input == "mult" :
        num1 = float(input("Enter a number: "))
        num2 = float(input("Enter another: "))
        print(num1 * num2)
    elif user_input == "div" :
        num1 = float(input("Enter a number: "))
        num2 = float(input("Enter another: "))
        print(num1 / num2)

