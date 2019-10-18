using System;

namespace FindCommonFactors
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] comparo = {1,2,3,4,5,6,7,8,9};
            int divisorInt = 22;
            int[] a = Kata.DivisibleBy(comparo, divisorInt);
            Console.WriteLine(a);
        }
    }
    public class Kata
    {
        public static int[] DivisibleBy(int[] numbers, int divisor)
        {
            int returnableLength = 0;
            for (int indexer = 0; indexer < numbers.Length; indexer++) {
                int integerCompare = divisor/ numbers[indexer];
                float floatCompare = divisor/ numbers[indexer];
                if (integerCompare == floatCompare) {
                    returnableLength++;
                };
            }
            int[] returnable = new int[returnableLength];
            for (int indexer = 0; indexer < returnableLength; indexer++) {
                int integerCompare = divisor/ numbers[indexer];
                float floatCompare = divisor/ numbers[indexer];
                if (integerCompare == floatCompare) {
                    returnable[indexer] = numbers[indexer];
                }
            }
            return returnable;
        }
    }
}
