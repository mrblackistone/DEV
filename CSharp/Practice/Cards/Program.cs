using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Cards {
    class Program {
        class Card {
            public string Name { get; set; }
            public string Suit { get; set; }
            public int[] Value { get; set; }
            public Card (string nm, string st, int[] vl) {
                Name = nm;
                Suit = st;
                Value = vl;
            }
        }
        public static List<T> Shuffle<T> (List<T> list) {
            Random rnd = new Random ();
            for (int i = 0; i < list.Count; i++) {
                int k = rnd.Next (0, i);
                T value = list[k];
                list[k] = list[i];
                list[i] = value;
            }
            return list;
        }

        //Main--------------------------------------------------------
        static void Main (string[] args) {
            int numDecks = 0;
            Console.Write ("Enter number of decks: ");
            numDecks = Convert.ToInt32 (Console.ReadLine ());
            string[] suitsArray = { "Hearts", "Spades", "Diamonds", "Clubs" };
            string[] namesArray = { "Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King" };
            int[] currVals = new int[2];
            List<Card> fullDeckList = new List<Card> ();
            int convertedName;
            int cardCountVar = 0;

            for (int a = 1; a <= numDecks; a++) {
                foreach (string suit in suitsArray) {
                    foreach (string name in namesArray) {
                        switch (name) {
                            case "Ace":
                                Array.Resize (ref currVals, 2);
                                currVals[0] = 1;
                                currVals[1] = 13;
                                fullDeckList.Add (new Card (name, suit, (int[]) currVals.Clone ()));
                                //Clone required, otherwise object will reference variable rather than its value.
                                //Name and Suit don't need to be cloned as they are not objects, and value is assumed.
                                cardCountVar++;
                                break;
                            case "10":
                            case "Jack":
                            case "Queen":
                            case "King":
                                Array.Resize (ref currVals, 1);
                                currVals[0] = 10;
                                fullDeckList.Add (new Card (name, suit, (int[]) currVals.Clone ()));
                                cardCountVar++;
                                break;
                            default:
                                convertedName = Convert.ToInt32 (name);
                                Array.Resize (ref currVals, 1);
                                currVals[0] = convertedName;
                                fullDeckList.Add (new Card (name, suit, (int[]) currVals.Clone ()));
                                cardCountVar++;
                                break;
                        }
                    }
                }
            }

            //Display output
            Console.WriteLine ("\nPre-Shuffle:");
            Console.WriteLine ("Name: {0}; Suit: {1}; Values: {2} {3}", fullDeckList[0].Name, fullDeckList[0].Suit, fullDeckList[0].Value[0], fullDeckList[0].Value[1]);
            Console.WriteLine ("Name: {0}; Suit: {1}; Values: {2}", fullDeckList[8].Name, fullDeckList[8].Suit, fullDeckList[8].Value[0]);
            Console.WriteLine ("Name: {0}; Suit: {1}; Values: {2}", fullDeckList[10].Name, fullDeckList[10].Suit, fullDeckList[10].Value[0]);

            //Shuffle deck
            fullDeckList = Shuffle (fullDeckList);

            //Display shuffled results from same positions
            Console.WriteLine ("\nPost-Shuffle:");
            Console.WriteLine ("Name: {0}; Suit: {1}; Values: {2}", fullDeckList[0].Name, fullDeckList[0].Suit, fullDeckList[0].Value[0]);
            Console.WriteLine ("Name: {0}; Suit: {1}; Values: {2}", fullDeckList[8].Name, fullDeckList[8].Suit, fullDeckList[8].Value[0]);
            Console.WriteLine ("Name: {0}; Suit: {1}; Values: {2}\n", fullDeckList[10].Name, fullDeckList[10].Suit, fullDeckList[10].Value[0]);

            //Display full shuffled deck
            int x, y;
            string w, z;
            for (int a = 0; a < cardCountVar; a++) {
                w = fullDeckList[a].Name;
                z = fullDeckList[a].Suit;
                if (fullDeckList[0].Value.Length == 2) { //Trying to get this to work.  Aces not appearing.
                    x = fullDeckList[a].Value[0];
                    y = fullDeckList[a].Value[1];
                    Console.WriteLine ("{0} of {1} with values {2} and {3}", w, z, x, y);
                } else if (fullDeckList[a].Value.Length == 1) {
                    x = fullDeckList[a].Value[0];
                    Console.WriteLine ("{0} of {1} with value {2}", w, z, x);
                }
            }
        }
    }
}