#Getting help:  Help method calls help interpreter, and the keywords below list more info
help()
modules
symbols
keywords
topics

#Strings
"This is a string"
print("Hello, world!")
print('Single quotes work, too.')
print('Inside of single quotes, you "can" have double quotes.')
print("Inside of double quotes, you 'can' have single quotes.")
print("Backslash escapes itself \\ and newline \n and double quotes in double quotes \"")
print("""Triple double quotes
allow you to use enter key to break across new lines in a string.""")
"spam"+'eggs' #Single and double quotes work identically

#Numbers
6 + 5 #Int plus int is int
2 * (3 + 4) #Ints without division yield ints
8 / 4 #division yields float
-7 + 8 #Negatives are naturally defined
5 + 6.0 #Any equation with a float will yield a float
8**2 #Exponent
8//2 #Floor division, remainder is dropped, outputs int
7%2 #Modulus

#Print outputs
print(1+1) #Integer
print(2*"string") #Clone string and concat the clones
print("concat"+"enation") #Concatenation

#Inputs
input("Enter something: ") #Input adds escape charaters to the string as needed (\ converted to \\).

#String/number combinations
"2" + "2" #Outputs 22 as these are strings
int("2") + int("3") #outputs 5 as integer method converts strings to ints
4 * '2' #Outputs 2222 as 2 is a string
float(input("Enter a number: ")) + float(input("Enter another number: ")) #Outputs float sum of inputs

#Variables:  Names can be alphanumeric and underscores, but can't start with a number
#Variables don't have types in Python, so different data types can be assigned to the same variable
x = 7 #Define and assign variable
print(x)
print(x + 3)
del x #Delete variable

#In-place operators
x += 2
x -= 2
x *= 2
x %= 2
x /= 2
