using System;
using System.Collections.Generic;
using System.Linq;

namespace Shuffle
{
    class Program
    {
        class Card
        {
            public int Number { get; }
            public string Suit { get; }
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
        public static List<T> Shuffle<T>(List<T> list)
        {
            Random rnd = new Random();
            for (int i = 0; i < list.Count; i++)
            {
                int k = rnd.Next(0, i);
                T value = list[k];
                list[k] = list[i];
                list[i] = value;
            }
            return list;
        }
        static void Main(string[] args)
        {
            //Objects
            List<Card> myCards = new List<Card>();
            myCards.Add(new Card(1, "Hearts"));
            myCards.Add(new Card(5, "Hearts"));
            myCards.Add(new Card(2, "Clubs"));
            myCards.Add(new Card(3, "Diamonds"));
            myCards.Add(new Card(4, "Spades"));
            myCards.Add(new Card(9, "Spades"));
            //Shuffle
            var rnd = new Random();
            var result = myCards.OrderBy(item => rnd.Next());
            foreach (var item in result)
            {
                Console.WriteLine(item.GetSuit());
            }


            //Integers
            List<int> mylist = new List<int>();
            mylist.Add(1);
            mylist.Add(2);
            mylist.Add(3);
            mylist.Add(4);
            mylist.Add(5);
            mylist.Add(6);

            mylist = Shuffle(mylist);

            foreach (var item in mylist)
            {
                Console.WriteLine(item);
            }
            Console.ReadLine();
        }
    }
}
