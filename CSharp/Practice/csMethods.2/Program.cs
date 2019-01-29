using System;

namespace csMethods
{
    class Program
    {
        //Methods (functions):  datareturntype name optionalParams
        //void is a return type that gives a valueless state
        //Created within a Class
        static int Sqr(int x){
            //Manipulates the parameter value fed to it by squaring it
            int result = x*x;
            return result;
        }
        static int Sqr2(ref int x){
            //Manipulates directly the calling argument's memory address
            x = x * x;
            return x;
        }
        static void saySomething(){
            //Uses void because no value is returned
            Console.WriteLine("Saying something from the saySomething method.");
        }
        static void print(int x){
            //Uses void because no value is returned, but does use param value
            Console.WriteLine(x);
        }
        static int sum(int x, int y){
            //Uses multiple param values
            return x+y;
        }
        static int Pow(int x, int y=2){
            //Uses default parameter value, but can be over-ridden when called
            //Optional (defaulted) params must all follow mandatory params
            int result = 1;
            for (int i=0; i < y; i++){
                result *= x;
            }
            return result;
        }
        static int Area(int height, int width) {
            //Uses named param names, so order no longer matters when feeding param values to method
            return height * width;
        }
        static void GetValues(out int x, out int y) {
            //Passing parameters by Output.  Instead of taking inputs, the "out" values are fed backward.
            //Basically, params in reverse.  What's defined here changes the calling values rather than vice-versa
            x = 5;
            y = 42;
        }
        static void PrintOverload(int a){
            //First instance of overloaded method.  Same name, different params.
            Console.WriteLine("Value: " + a);
        }
        static void PrintOverload(double a){
            //Second instance of overloaded method.  Same name, different params.
            Console.WriteLine("Value: " + a);
        }
        static void PrintOverload(string label, double a){
            //Third instance of overloaded method.  Same name, different params.
            Console.WriteLine(label + a);
        }
        static int Factorial(int num) {
            //This method references itself.  The if statement is the exit condition.
            if (num == 1) {
                return 1;
            }
            return num * Factorial(num-1);
        }
        static void DrawPyramid(int n){
            //Take input as number of levels to draw pyramid
            for (int i = 1; i <= n; i++) {
                for (int j = i; j < n; j++){
                    Console.Write(" ");
                }
                for (int k = 1; k <= 2 * i - 1; k++) {
                    Console.Write("*");
                }
                Console.WriteLine();
            }
        }
        static void Main (string[] args)
        {
            Console.WriteLine(Sqr(5)); //Returns 25, squaring param value supplied
            saySomething(); //function is void and writes within its own code
            print(5); //function is void, takes parameter, and writes within its own code
            Console.WriteLine(sum(3,4)); //Returns 7, function returns added value from two parameters
            Console.WriteLine(Pow(6)); //Returns 36, because second param has default value of 2
            Console.WriteLine(Pow(3,4)); //Returns 81 because both params provided, overriding default
            Console.WriteLine(Area(width: 5, height: 8)); //Returns 40
            //Passing argyments by value, reference, or output
            //By Value
            int a = 3;
            Sqr(a);
            Console.WriteLine(a); //Outputs 3 because "a" was used to feed a value to the method, but is not itself manipulated
            //By Reference
            a = 3;
            Sqr2(ref a);
            Console.WriteLine(a); //Outputs 9 because the argument's memory address was directly manipulated by the method.
            //By Output
            int b, c;
            GetValues(out b, out c); //Now b equals 5 (x in the method) and c equals 42 (y in the method)
            //Overloading Methods
            PrintOverload(11); //int version of the method is used
            PrintOverload(4.13); //double version of the method is used
            PrintOverload("Average: ", 7.57); //version of the method with string then double is used
            //Recursion
            Console.WriteLine(Factorial(6)); //Returns 720. Uses self-referencing method to calculate factorial
            //Draw a pyramid
            DrawPyramid(7);
        }
    }
}
