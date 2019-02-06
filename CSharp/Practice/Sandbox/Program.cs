using System;
using System.Collections;
using System.Collections.Generic;

namespace Sandbox
{
    class Program
    {
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

            int iterations = numberOfDecks * 52;
            int iteration = 0;
            int[] order = new int[iterations];
            
            Random rnd = new Random();
            do
            {
                int roll = rnd.Next();
                if ( order.Contains(roll) ) {
                    continue;
                }
                //Construct order

            } while (iteration <= iterations);


        }
    }
}
