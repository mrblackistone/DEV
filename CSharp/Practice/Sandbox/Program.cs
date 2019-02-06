using System;
using System.Collections;
using System.Collections.Generic;

namespace Sandbox
{
    class Program
    {
        class Card {
            private int Number { get; }
            private string Suit { get; }
            public Card(int num, string suit) {
                Number = num;
                Suit = suit;
            }
            public int GetNumber() {
                return Number;
            }
            public string GetSuit() {
                return Suit;
            }
            
        }
        //Main--------------------------------------------------------------------------
        static void Main(string[] args)
        {
            //Card c1 = new Card(5,"Spades");
            //Console.WriteLine(c1.GetSuit());
            /*List<object> cards = new List<object>();
            
            Card thistime = new Card(3, "Hearts");
            cards.Add(thistime);
            string thesuit = cards[0].Suit;
            Console.WriteLine(thesuit);
            */
            Console.Write("Enter the number of decks:  ");
            int numberOfDecks = Console.Read();
            var cardlist = new List<Card>();
            string [] suits = new string[] { "Spades", "Hearts", "Diamonds", "Clubs" };

            for (int a = 0; a < numberOfDecks; a++ ) {
                for (int numz = 1; numz <= 13; numz++ ) {
                    foreach (string suitz in suits) {
                        cardlist.Add(new Card(numz, suitz));
                    }
                }                
            }
            Console.WriteLine(cardlist[38].GetSuit());
        }
    }
}
