using System;
using System.IO;

namespace StructsEnumsExceptionsFiles._6
{
    class Program
    {
        //Struct
        struct book {
            public string title;
            public double price;
            public string author;
        }
        //A struct is a value type for a small group of related variables.
        //May have methods, properties, indexers, etc.
        //More limited than a class, but can be instantiated without using a new operator.
        //Meant for when data won't change after creation
        //C# data types are themselves structs (int, double, bool, char, etc.)
        /*
        NO inheritance
        NO virtual methods
        NO default constructors (one without parameters), but can have ones that take parameters.
        */
        struct point {
            public int x;
            public int y;
            public point(int x, int y) {
                this.x = x;
                this.y = y;
            }
        }

        //enum
        enum Days {Mon, Tue, Wed, Thu, Fri, Sat, Sun}; //values are 0 through 6
        enum Days2 {Mon, Tue, Wed, Thu=7, Fri, Sat, Sun}; //values are 0 through 2 then 7 through 10
        enum TrafficLights {Green, Red, Yellow};

        //Main----------------------------------------------------------
        static void Main(string[] args)
        {
            //struct
            book b;
            b.title = "Test";
            b.price = 6.95;
            b.author = "David";
            Console.WriteLine(b.title); //returns Test
            //struct using parameter-taking constructor
            point p = new point(10, 15);
            Console.WriteLine(p.x); //returns 10

            //enum
            int day = (int)Days.Mon; //narrowing conversion (data potentially lost)
            Console.WriteLine(day);
            //
            TrafficLights x = TrafficLights.Red;
            switch (x) {
                case TrafficLights.Green :
                    Console.WriteLine("Go!");
                    break;
                case TrafficLights.Red :
                    Console.WriteLine("Stop!");
                    break;
                case TrafficLights.Yellow :
                    Console.WriteLine("Caution!");
                    break;
            } //returns Stop!
            //This is great for a restricted list, or to improve readability 
            //over using values, or having to use a narrowing conversion and casting INT

            //Exception handling
            try {
                int [] arr = new int[] { 4,5,8 };
                Console.WriteLine(arr[8]);
            }
            catch (Exception e) {
                Console.WriteLine("An error occurred.\n", e); //catch block executes without stopping program
            }
            finally {
                Console.WriteLine("All done."); //finally block runs always, even if return statement exists in catch block
            }
            //Mutliple exceptions
            try {
                x = Convert.ToInt32(Console.Read());
                y = Convert.ToInt32(Console.Read());
                Console.WriteLine(x/y);
            }
            //Common exception types: FileNotFoundException, FormatException, IndexOutOfRangeException, InvalidOperationException, OutOfMemoryException
            //Use exception handling if the error is rare.  If it's common, build code to avoid it.
            catch (DivideByZeroException e) {
                Console.WriteLine("Cannot divide by zero");
                return;
            }
            catch (Exception e) {
                Console.WriteLine("An error occurred.\n", e);
                return;
            }
            finally {
                Console.WriteLine("Completed.");
            }  //One need for a finally block is to close a file, whether an exception occurred or not.

            //Working with files (System.IO namespace)
            //Write
            string str = "Some text";
            File.WriteAllText("Test.txt", str); //Creates file (or overwrites whole file) and adds the text.
            //Read
            string str2 = File.ReadAllText("test.txt");
            Console.WriteLine(str2);
            //Also:  AppendAllText(), Create(), Delete(), Exists(), Copy(), and Move()
        }
    }
}
