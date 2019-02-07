using System;
using System.Collections.Generic;
using System.Linq;

namespace Shuffle
{
    class Program
    {
        class Card
        {
            public object Name { get; }
            public string Suit { get; }
            public int Values { get; }
            public Card(object name, string suit, int vals)
            {
                Name = name;
                Suit = suit;
                Values = vals;
            }
            public object GetName()
            {
                return Name;
            }
            public string GetSuit()
            {
                return Suit;
            }
            public int GetValues()
            {
                return Values;
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
        //Main------------------------------------------------------------------------------
        static void Main(string[] args)
        {
            //Objects
            List<Card> myCards = new List<Card>();
            
            string[] Suits = { "Hearts", "Spades", "Clubs", "Diamonds" };
            object[] Names = { "Ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King" };
            Console.WriteLine("How many decks?");
            int numDecks = Convert.ToInt32(Console.ReadLine());
            int valz = 0;

            for (int a = 1; a <= numDecks; a++)
            {
                foreach (string suit in Suits)
                {
                    foreach (object name in Names)
                    {
                        switch (name) {
                            case "Ace":
                                valz = 1;
                                break;
                            case "Jack":
                            case "Queen":
                            case "King":
                            case 10:
                                valz = 10;
                                break;
                            default:
                                valz = Convert.ToInt32(name);
                                break;
                        }
                        myCards.Add(new Card(name, suit, valz));
                    }
                }
            }


            //Sample:  myCards.Add(new Card(9, "Spades"));

            //Shuffle
            var rnd = new Random();
            var result = myCards.OrderBy(item => rnd.Next());
            foreach (var item in result)
            {
                Console.WriteLine(item.GetName() + " of " + item.GetSuit() + " with base value of " + item.GetValues());
            }


            //Integers
            /*
            Console.WriteLine("Shuffled list of Integers:");
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
            */
        }
    }
}
