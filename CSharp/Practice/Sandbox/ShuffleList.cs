using System;
using System.Collections.Generic;

namespace ShuffleList
{
    static class GetIt {
        static void main(string[] args)
        {
            List theList = new List();
            theList += 1; theList += 2; theList += 3; theList += 4;
            ShuffleList(theList);
            Console.Write(theList);
        }
    }
}