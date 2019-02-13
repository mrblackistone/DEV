using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Cards
{
    class Program
    {
        class Card
        {
            public string Name { get; set; }
            public string Suit { get; set; }
            public List<int> Value { get; set; }
            public Card(string nm, string st, List<int> vl)
            {
                Name = nm;
                Suit = st;
                Value = vl;
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

        //Main--------------------------------------------------------
        static void Main(string[] args)
        {
            int numDecks = 0;
            Console.Write("Enter number of decks: ");
            numDecks = Convert.ToInt32(Console.ReadLine());
            string[] suitsArray = { "Hearts", "Spades", "Diamonds", "Clubs" };
            string[] namesArray = { "Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King" };
            List<int> currVals = new List<int>();
            List<Card> preShuffleDeck = new List<Card>();
            int convertedName = 0;
            int indexerVar = 0;

            for ( int a = 1; a <= numDecks; a++ )
            {
                foreach (string suit in suitsArray)
                {
                    foreach (string name in namesArray)
                    {
                        switch (name)
                        {
                            case "Ace":
                                currVals.Clear();
                                currVals.Add(1);
                                currVals.Add(13);
                                preShuffleDeck.Add(new Card(name, suit, currVals));
                                Console.WriteLine("Name: {0}; Suit: {1}; Values: {2}, {3}", preShuffleDeck[indexerVar].Name, preShuffleDeck[indexerVar].Suit, preShuffleDeck[indexerVar].Value[0], preShuffleDeck[indexerVar].Value[1]);
                                Console.WriteLine("Indexer is currently: " + indexerVar);
                                Console.WriteLine("For variable 'a' is currently: " + a);
                                indexerVar++;
                                Console.ReadLine();
                                break;
                            case "10":
                            case "Jack":
                            case "Queen":
                            case "King":
                                currVals.Clear();
                                currVals.Add(10);
                                preShuffleDeck.Add(new Card(name, suit, currVals));
                                Console.WriteLine("Name: {0}; Suit: {1}; Values: {2}", preShuffleDeck[indexerVar].Name, preShuffleDeck[indexerVar].Suit, preShuffleDeck[indexerVar].Value[0]);
                                Console.WriteLine("Indexer is currently: " + indexerVar);
                                Console.WriteLine("For variable 'a' is currently: " + a);
                                indexerVar++;
                                Console.ReadLine();
                                break;
                            default:
                                convertedName = Convert.ToInt32(name);
                                currVals.Clear();
                                currVals.Add(convertedName);
                                preShuffleDeck.Add(new Card(name, suit, currVals));
                                Console.WriteLine("Name: {0}; Suit: {1}; Values: {2}", preShuffleDeck[indexerVar].Name, preShuffleDeck[indexerVar].Suit, preShuffleDeck[indexerVar].Value[0]);
                                Console.WriteLine("Indexer is currently: " + indexerVar);
                                Console.WriteLine("For variable 'a' is currently: " + a);
                                indexerVar++;
                                Console.ReadLine();
                                break;
                        }
                    }
                }
            }

            //Display output
            Console.WriteLine("Name: {0}; Suit: {1}; Values:", preShuffleDeck[0].Name, preShuffleDeck[0].Suit);
            Console.WriteLine("Name: {0}; Suit: {1}; Values: {2}", preShuffleDeck[8].Name, preShuffleDeck[8].Suit, preShuffleDeck[8].Value[0]);
            Console.WriteLine("Name: {0}; Suit: {1}; Values: {2}", preShuffleDeck[10].Name, preShuffleDeck[10].Suit, preShuffleDeck[10].Value[0]);
        }
    }
}
