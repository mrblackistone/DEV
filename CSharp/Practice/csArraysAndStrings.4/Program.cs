using System;
using System.Linq; //Needed for Min, Max, and Sum methods on arrays

namespace csArraysAndStrings._4
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] myArray = new int[5]; //Instantiates a new array holding 5 integers.
            myArray[0] = 42; //Sets index 0 of myArray to a value of 42.
            string[] stringArray = new string[3] {"Alpha", "Bravo", "Charlie"};
            double[] doubleArray = new double[] {3.14, 5.56, 7.62}; //size omitted
            int[] shortArray = {1,2,3}; //"new" and type omitted
            Console.WriteLine(shortArray[0]);
            //foreach
            foreach (double zzz in doubleArray) {
                //foreach goes through entire array, without size needing to be known
                Console.WriteLine(zzz);
            }
            //Multi-dimensional arrays
            int [,] multiDimArray1 = new int[5,7]; //Define two-dimensional array with 5x7 size
            multiDimArray1[3,5] += 42;
            Console.WriteLine("multiDimArray1 we just set should now be 42:  "+multiDimArray1[3,5]);
            int [,] multiDimArray2 = { {2,3}, {5,6}, {4,6} };
            Console.WriteLine("Zero dot one should be 3:  "+multiDimArray2[0,1]);
            //Jagged arrays (arrays nested within arrays)
            int[][] jaggedArray1 = new int[3][]; //Array with 3 elements, each element is a 1D array.
            int[][] jaggedArray2 = new int[][] {
                new int[] {1,2,3,4,5},
                new int[] {3,6,9},
                new int[] {42,84}
            };
            int returnValue = jaggedArray2[2][1]; //Should return 84
            Console.WriteLine("Jagged array should return 84:  "+jaggedArray2[2][1]);
            //Array properties: Length (number of members) and Rank (number of dimensions)
            Console.WriteLine("multiDimArray2 should have 2 dimensions:  "+multiDimArray2.Rank);
            Console.WriteLine("jaggedArray2 should have 3 members:  "+jaggedArray2.Length);
            //Array methods:  Max, Min, Sum -- only works on single-dimensional non-jagged array (top level)
            Console.WriteLine("shortArray should have 3 as largest:  "+shortArray.Max());
            Console.WriteLine("shortArray should have 1 as smallest:  "+shortArray.Min());
            Console.WriteLine("shortArray should have 6 as sum:  "+shortArray.Sum());
            
            //String properties: Length
            string theString = "A bunch of stuff";
            Console.WriteLine(theString.Length);
            //String methods:  IndexOf, Insert, Remove, Replace, Substring, Contains
            Console.WriteLine(theString.IndexOf("b")); //returns index of first "b"
            Console.WriteLine(theString.Insert(4,"zzzz")); //inserts "zzzz" at index 4
            Console.WriteLine(theString.Remove(7)); //removes everything at and after index 7 (leaving first 7 chars)
            Console.WriteLine(theString.Replace("bunch","crapload")); //replaces every "bunch" with "crapload"
            Console.WriteLine(theString.Substring(1,7)); //returns substring from first to second index (or end if no second specified)
            Console.WriteLine(theString.Contains("werd")); //returns true if "werd" is in the string
        }
    }
}
