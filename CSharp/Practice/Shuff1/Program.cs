using System;
using System.Collections.Generic;
using System.Linq;

namespace Shuffle
{
    class Program
    {
        public class Card
        {
            public string Name { get; }
            public string Suit { get; }
            public List<int> Values { get; }
            public Card(string name, string suit, List<int> vals)
            {
                Name = name;
                Suit = suit;
                Values = vals;
            }
            public string GetName()
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
            int myCardTester = 0;
            string[] Suits = { "Hearts", "Spades", "Clubs", "Diamonds" };
            string[] Names = { "Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King" };
            Console.WriteLine( "How many decks?" );
            int numDecks = Convert.ToInt32(Console.ReadLine());
            List<int> vals = new List<int>();

            for (int a = 1; a <= numDecks; a++)
            {
                foreach (string suit in Suits)
                {
                    foreach (string name in Names)
                    {
                        if ( name == "Ace" )
                        {
                            Console.WriteLine("name is actually " + name + " and we selected Ace");
                            vals.Clear();
                            vals.Add(1);
                            Console.WriteLine("Vals[0] is now set to " + vals[0]);
                            vals.Add(13);
                            Console.WriteLine(vals[0] + " " + vals[1]);
                            myCards.Add(new Card(name, suit, vals));
                            Console.WriteLine("Object just created is " + myCards[myCardTester].Name + " " + myCards[myCardTester].Suit + " " + myCards[myCardTester].Values[0]);
                        } else if ( name == "Jack" || name == "Queen" || name == "King" || name == "10" ) {
                            Console.WriteLine("name is actually " + name + " and we selected Face Cards");
                            vals.Clear();
                            vals.Add(444);
                            Console.WriteLine(vals[0]);
                            myCards.Add(new Card(name, suit, vals));
                            Console.WriteLine("Object just created is " + myCards[myCardTester].Name + " " + myCards[myCardTester].Suit + " " + myCards[myCardTester].Values[0]);
                        } else
                        {
                            Console.WriteLine("name is actually " + name + " and we selected the Else statement");
                            vals.Clear();
                            vals.Add(Convert.ToInt32(name));
                            Console.WriteLine(vals[0]);
                            myCards.Add(new Card(name, suit, vals));
                            Console.WriteLine("Object just created is " + myCards[myCardTester].Name + " " + myCards[myCardTester].Suit + " " + myCards[myCardTester].Values[0]);
                        }
                        myCardTester++;
                        Console.WriteLine();

                    }
                }
            }
            Console.WriteLine("Pre-shuffle:");
            Console.WriteLine(myCards[0].Name + " " + myCards[0].Suit + " " + myCards[0].Values[0]);
            Console.WriteLine(myCards[5].Name + " " + myCards[5].Suit + " " + myCards[5].Values[0]);
            Console.WriteLine(myCards[11].Name + " " + myCards[11].Suit + " " + myCards[1].Values[0]);
            Console.WriteLine();

            myCards = Shuffle(myCards);

            Console.WriteLine("Post-shuffle:");
            for ( int r = 0; r < myCards.Count; r++)
            {
                Console.WriteLine(myCards[r].Name + " " + myCards[r].Suit + " " + myCards[r].Values[0]);
            }

            //foreach ( object shuffledCard in myCards )
            //{
            //    Console.Write("\n" + shuffledCard.GetName() + )
            //}

            //Sample:  myCards.Add(new Card(9, "Spades"));

            //Shuffle???
            /*
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
            */

            Console.Read();

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
