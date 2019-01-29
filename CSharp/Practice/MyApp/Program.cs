using System;

namespace MyApp
{
    class Program
    {
        /*
        Multi-line comment
        This is where the fun begins.
        */
        static void Main(string[] args)
        {
            //Single line comment.  We output a string.
            Console.WriteLine("Hello, world!");
            //Explicit declaration of two variables with types and values
            int anInteger = 10;
            double aDouble = 20.05;
            //Write a string, using the variables are arguments
            Console.WriteLine("x = {0}; y = {1}", anInteger, aDouble);
            //Define a string variable, ask for it, and read user input
            string yourName;
            Console.WriteLine("What is your name?");
            yourName = Console.ReadLine();
            Console.WriteLine("Hello, {0}", yourName);
            //Convert string to integer
            Console.WriteLine("What is your age?");
            int yourAge = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("You are {0} years old", yourAge);
            //Implicit declaration of variable type with var keyword.
            //Cannot declare without assigning a value, because implicit.
            var num = 15;
            Console.WriteLine(num);
            //Constants can't be changed once set
            const double PI = 3.14;
            Console.WriteLine(PI);
            //Arithmetic Operators.
            //Addition, subtraction, multiplication, division (drops remainder), modulus.
            //PEMDAS is used.
            int a = 14;
            int b = 5;
            Console.WriteLine("a and b are {0} and {1} respecively.", a, b);
            Console.WriteLine("a plus b is: {0}", a+b);
            Console.WriteLine("a minus b is: {0}", a-b);
            Console.WriteLine("a times b is: {0}", a*b);
            Console.WriteLine("a divided by b is: {0}", a/b);
            Console.WriteLine("a modulus b is: {0}", a%b);
            //Assignment Operators
            a += 5; //a = a+5
            b -= 5; //b = b-5
            a *= 5; //a = a*5
            b /= 5; //b = b/5
            a %= 5; //a = a % 5
            //Increment Operator
            ++a; //Prefix increment, increments then evaluates expression
            a++; //Postfix increment, evaluates expression then increments
            int y = ++a; //Increments a then adds the new value to y
            int z = a++; //Adds the value of a to y, then increments a
            //Decrement Operator, works like increment but subtracting one at a time
            b--;
            //If-Then-ElseIf-Else
            //Comparison operators are >= <= == != for GE, LE, EQ, and NotEQ
            Console.WriteLine("a and b are {0} and {1} respecively.", a, b);
            if (a%2 == 0) {
                Console.WriteLine("Variable a is even.");
            }
            else if (a%2 == 1) {
                Console.WriteLine("Variable a is odd.");
            }
            else {
                Console.WriteLine("This should never happen.");
            }
            //Switch statement
            int switchVar = 3;
            switch (switchVar) {
                case 1:
                Console.WriteLine("Switch Case One");
                break;
                case 2:
                Console.WriteLine("Switch Case Two");
                break;
                case 3:
                Console.WriteLine("Switch Case Three");
                break;
                default:
                Console.WriteLine("Default Switch Case");
                break;
            }
            //While loop, runs 0 or more times
            int whileVar = 1;
            while (whileVar <6){
                Console.WriteLine("WhileVar value is {0}", whileVar);
                whileVar++;
            }
            //Shortened while loop with prefix increment
            whileVar = 0;
            while (++whileVar < 6) {
                Console.WriteLine("Shortened whileVar value is {0}", whileVar);
            }
            //For loop
            for (int forVar = 0; forVar < 10; forVar++) {
                Console.WriteLine("forVar value is now {0}", forVar);
            }
            //For loop, with initialization and increment left out, but semi-colons mandatory
            int forVar2 = 0;
            for ( ;forVar2 < 10; ) {
                Console.WriteLine("forVar value is now {0}", forVar2);
                forVar2++;
            }
            //Do-While Loop, always runs at least once
            int doWhileVar = 0;
            do {
                Console.WriteLine("doWhileVar value is now {0}", doWhileVar);
                doWhileVar++;
            } while (doWhileVar < 5);
            //break and continue.
            //Break immediately leaves the loop it's in
            //Continue skips the rest of the current iteration of the loop it's in, but continues the loop
            int breakVar = 0;
            while (breakVar < 20) {
                if (breakVar == 5)
                    break;
                
                Console.WriteLine("breakVar value is now {0}", breakVar);
                breakVar++;
            }
            for (int continueVar = 0; continueVar < 10; continueVar++){
                if (continueVar == 5)
                    continue;
                Console.WriteLine("continueVar value is now {0}", continueVar);
            }
            //Logical Operators:  &&, ||, !
            //AND, OR, and NOT respectively
            bool left = true;
            bool right = false;
            if (left == true && right == true) {Console.WriteLine("Both are true.");}
            if (left == true || right == true) {Console.WriteLine("One is true.");}
            if ( !(right == true)) {Console.WriteLine("Right isn't true!");}
            //Conditional Operator:  ?
            //exp1 ? exp2 : exp3;
            //If exp1 is true, then exp2 becomes the value, otherwise exp3 does
            int conditionalVar = 42;
            string conditionalMsg;
            conditionalMsg = (conditionalVar >= 18) ? "Welcome" : "Nope";
            Console.WriteLine("Conditional message is {0}", conditionalMsg);
            //
        }
    }
}
