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
            public List<int> Values { get; }
            public Card(object name, string suit, List<int> vals)
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
            public List<int> GetValues()
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
            Console.WriteLine( "How many decks?" );
            int numDecks = Convert.ToInt32(Console.ReadLine());
            List<int> vals = new List<int>();

            for (int a = 1; a <= numDecks; a++)
            {
                foreach (string suit in Suits)
                {
                    foreach (object name in Names)
                    {
                        switch (name) {
                            case "Ace":
                                vals.Clear();
                                vals.Add(1);
                                vals.Add(13);
                                Console.WriteLine(vals[0] + " " + vals[1]);
                                break;
                            case "Jack":
                            case "Queen":
                            case "King":
                            case 10:
                                vals.Clear();
                                vals.Add(10);
                                Console.WriteLine(vals[0]);
                                break;
                            default:
                                vals.Clear();
                                vals.Add(Convert.ToInt32(name));
                                Console.WriteLine(vals[0]);
                                break;
                        }
                        Console.WriteLine("Adding " + name + " " + suit + " " + vals);
                        foreach (int hhh in vals) { Console.WriteLine("Adding " + hhh + " from the current list.");}
                        myCards.Add(new Card(name, suit, vals));
                    }
                }
            }


            //Sample:  myCards.Add(new Card(9, "Spades"));

            //Shuffle
            var rnd = new Random();
            var result = myCards.OrderBy(item => rnd.Next());
            foreach (var item in result)
            //Report shuffled order
            {
                Console.Write("\n" + item.GetName() + " of " + item.GetSuit() + " with base value of ");
                foreach (int ggg in item.GetValues()) {
                    Console.Write(ggg + " ");
                }
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
