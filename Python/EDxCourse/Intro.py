print("Hello, world!")  # Yields Hello, world!
x = 2
y = x + 5
print(y)  # Yields 7

student_name = "Alton"
print(student_name[0])  # Yields A

student_name = "Jin"
if student_name[0].lower() == "a":
    print("Winner! Name starts with A:", student_name)
elif student_name[0].lower() == "j":
    print("Winner! Name starts with J:", student_name)
else:
    print("Not a match, try again tomorrow:", student_name)

# [ ] review and run ERROR example
# cannot index out of range
student_name = "Tobias"
###print(student_name[6]) #Yields string index out of range error

# [ ] review and run example
student_name = "Joana"

# get last letter
end_letter = student_name[-1]
print(student_name,"ends with", "'" + end_letter + "'")
# [ ] review and run example
# get second to last letter
second_last_letter = student_name[-2]
print(student_name,"has 2nd to last letter of", "'" + second_last_letter + "'")
# [ ] review and run example
# you can get to the same letter with index counting + or -
print("for", student_name)
print("index 3 =", "'" + student_name[3] + "'")
print("index -2 =","'" + student_name[-2] + "'")

# [ ] assign a string 5 or more letters long to the variable: street_name
# [ ] print the last 3 characters of street_name
# [ ] create and assign string variable: first_name
# [ ] print the first and last letters of name

# [ ] Review, Run, Fix the error using string index
shoe = "tennis"
# print the last letter
print(shoe[-1])

