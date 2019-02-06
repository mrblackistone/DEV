using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Sandbox
{
    class Program
    {
                //Function to get random number for multi-threading only
        private static readonly Random getrandom = new Random();

        public static int GetRandomNumber(int min, int max)
        {
            lock (getrandom) // synchronize
            {
                return getrandom.Next(min, max);
            }
        }

        class Card
        {
            private int Number { get; }
            private string Suit { get; }
            public Card(int num, string suit)
            {
                Number = num;
                Suit = suit;
            }
            public int GetNumber()
            {
                return Number;
            }
            public string GetSuit()
            {
                return Suit;
            }

        }

        //Main--------------------------------------------------------------------------
        static void Main(string[] args)
        {
            Console.Write("Enter the number of decks:  ");
            int numberOfDecks = Console.Read();
            var cardlist = new List<Card>();
            string[] suits = new string[] { "Spades", "Hearts", "Diamonds", "Clubs" };

            for (int a = 0; a < numberOfDecks; a++)
            {
                for (int numz = 1; numz <= 13; numz++)
                {
                    foreach (string suitz in suits)
                    {
                        cardlist.Add(new Card(numz, suitz));
                    }
                }
            }
            Console.WriteLine(cardlist[38].GetSuit());

            int iteration = 0;
            int iterations = numberOfDecks * 52;
            int[] order = new int[iterations];

            /*
            Random rand = new Random();
            var ints = Enumerable.Range(1, iterations)
                                    .Select(i => new Tuple<int, int>(rand.Next(iterations), i))
                                    .OrderBy(i => i.Item1)
                                    .Select(i => i.Item2);

            foreach (int z in ints) { Console.Write(z + " "); }


            var shuffledcards = cards.OrderBy(a => Guid.NewGuid()).ToList();

            Random rng = new Random();
            var shuffledcards = cards.OrderBy(a => rng.Next());
            */

            /// <summary>
            /// Returns a new list where the elements are randomly shuffled.
            /// Based on the Fisher-Yates shuffle, which has O(n) complexity.
            /// </summary>

            /*
            var count = 1000000000;
            var list = new List<int>(count);
            var random = new Random();
            list.Add(0);
            for (var i = 1; i < count; i++)
            {
                var swap = random.Next(i - 1);
                list.Add(list[swap]);
                list[swap] = i;
            }
            */

            /*
            Random rnd = new Random();
            do
            {
                int roll = rnd.Next(1, iterations);
                if (order.Contains(roll))
                {
                    continue;
                }
                order[iteration] = roll;
                //order.Insert(iteration, roll); //needs help
                iteration++;

            } while (iteration < iterations);
            foreach (int z in order) { Console.WriteLine(z); }
            */

            private static Random rng = new Random();
            public static IEnumerable<T> Shuffle<T>(this IEnumerable<T> list)
            {
                var source = list.ToList();
                int n = source.Count;
                var shuffled = new List<T>(n);
                shuffled.AddRange(source);
                while (n > 1)
                {
                    n--;
                    int k = rng.Next(n + 1);
                    T value = shuffled[k];
                    shuffled[k] = shuffled[n];
                    shuffled[n] = value;
                }
                return shuffled;
            }
        }
    }
}