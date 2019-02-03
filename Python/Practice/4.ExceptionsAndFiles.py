#Exceptions
#Common ones:  ImportError, IndexError, NameError, SyntaxError, TypeError, ValueError, ZeroDivisionError, OSError

#Handling an exception
try :
    num1 = 7
    num2 = 0
    print (num1/num2) #Error occurs here
    print("Done calculating") #...so this gets skipped...
except ZeroDivisionError : #...and this handles the particular error type.
    print("An error occurred")
    print("due to zero division")
except (ValueError, TypeError) : #This could handle other error types if they occurred.
    print("Error occurred")

#Handling all exceptions, and Finally
try :
    num1 = 7
    num2 = 0
    print(num1/num2)
except :
    print("error") #Should be used sparingly as it catches all errors, and obfuscates programming mistakes
finally :
    print("This happens no matter what") #Runs even if an uncaught exception occurs
#Commands here AFTER the end of the finally block would not run if an uncaught exception occurred
#Thus the finally block's benefit

#Raising exceptions
print(1)
raise ValueError
#print(2) #unreachable code due to raised exception

