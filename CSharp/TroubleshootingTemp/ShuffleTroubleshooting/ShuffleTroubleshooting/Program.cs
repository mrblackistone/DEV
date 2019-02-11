using System;
using System.Collections.Generic;

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
        //Main--------------------------------------------------------------------------------------------------
        static void Main(string[] args)
        {
            //Objects
            List<Card> myCards = new List<Card>();
            string[] Suits = { "Hearts", "Spades" };
            string[] Names = { "Ace", "2", "King" };
            Console.WriteLine("How many decks?");
            int numDecks = Convert.ToInt32(Console.ReadLine());
            List<int> vals = new List<int>();

            for (int a = 1; a <= numDecks; a++)
            {
                foreach (string suit in Suits)
                {
                    foreach (string name in Names)
                    {

                        string conditionalMsg = (name == "Ace") ? "Ace" : "Nope";
                        Console.WriteLine("Conditional message is {0}", conditionalMsg);

                        if ( name == "Ace" )
                        {
                            Console.WriteLine("We're ace!");
                            vals.Clear();
                            vals.Add(1);
                            vals.Add(13);
                        }
                        else if ( name == "King" )
                        {
                            vals.Clear();
                            vals.Add(445);
                            vals.Add(555);
                        }
                        else
                        {
                            vals.Clear();
                            vals.Add(Convert.ToInt32(name));
                        }
                        myCards.Add(new Card(name, suit, vals));
                    }
                }
            }

            for (int r = 0; r < myCards.Count; r++)
            {
                Console.WriteLine(myCards[r].Name + " " + myCards[r].Suit + " " + myCards[r].Values[0]);
            }

            Console.Read();
        }
    }
}
