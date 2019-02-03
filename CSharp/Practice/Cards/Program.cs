using System;

namespace Cards
{
    class Program
    {
        class Card {
            public string Name { get; set; }
            public string Suit { get; set; }
            public int Value { get; set; }
            public Card(string nm, string st, int vl) {
                Name = nm;
                Suit = st;
                Value = vl;
            }
        }
        //Main--------------------------------------------------------
        static void Main(string[] args)
        {
            
        }
    }
}
