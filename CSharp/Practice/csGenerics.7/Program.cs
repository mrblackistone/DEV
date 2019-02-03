using System;
using System.Collections;
using System.Collections.Generic;

namespace csGenerics._7
{
    class Program
    {
        //Regular Method:
        static void SwapInt(ref int a, ref int b) {
            int temp = a;
            a = b;
            b = temp;
        }
        //Generic Method:
        static void SwapGeneric<T>(ref T a, ref T b) {
            T temp = a;
            a = b;
            b = temp;
        }

        //Generic Class:
        class Stackz<T> {
            int index = 0;
            T[] innerArray = new T[100];
            public void Push(T item) {
                innerArray[index++] = item;
            }
            public T Pop() {
                return innerArray[--index];
            }
            public T Get(int k) { return innerArray[k]; }
        }

        //Collections
        static void PrintBarr(string name, BitArray ba) {
            Console.Write(name + " :");
            for (int x = 0; x < ba.Length; x++) {
                Console.Write(ba.Get(x) + " ");
            }
            Console.WriteLine();
        }

        //Main-------------------------------------------------------------------
        static void Main(string[] args)
        {
            int a = 4, b = 9;
            SwapGeneric<int>(ref a, ref b);
            //Now b is 4 and a is 9
            string x = "Hello";
            String y = "World";
            SwapGeneric<String>(ref x, ref y);
            //Now x is "World" and y is "Hello

            //Create objects usin Generic Class
            Stackz<int> intStack = new Stackz<int>();
            intStack.Push(3);
            intStack.Push(6);
            intStack.Push(7);
            Console.WriteLine(intStack.Get(1)); //returns 6
            Stackz<string> strStack = new Stackz<string>();
            //Stack<Person> PersonStack = new Stack<Person>(); //Custom designed Person type.

            //Collections
            //System.Collections.Generic: List<T>, Dictionary<TKey, TValue>, SortedList<TKey, TValue>,
            //Stack<T>, Queue<T>, Hashset<T>
            //These are higher-performing.
            //System.Collections: ArrayList, SortedList, Stack, Queue, Hashtable, BitArray
            //These are less-performance and error-prone.
            
            //List<T>
            //Like an array, but elements can be inserted/removed dynamically.  All elements must be same type.
            List<int> li = new List<int>();
            li.Add(59); li.Add(40); li.Add(22); li.Add(42);
            li.RemoveAt(1);
            foreach (int liitem in li) {Console.WriteLine(liitem);} //returns 59 22 42
            li.Sort();
            foreach (int liitem in li) {Console.WriteLine(liitem);} //returns 22 42 59
            //List properties and methods
            //Capacity, Clear(), TrimExcess(), AddRange(IEnumerable coll), Insert(int i, Tt),
            //InsertRange(int i, IEnumerable coll), Remove(T t), RemoveRange(int i, int count),
            //Contains (T t), IndexOf(T t), Reverse(), ToArray()

            //SortedList<K, V>
            //Collection of key:value pairs that are sorted by key
            //All must be of the same type <K, V>
            //Properties:  Count, Item[K key], Keys, Values
            //Methods:  Add(K value, V value), Remove(K key), Clear(), ContainsKey(K key),
            //ContainsValue(V value), IndexOfKey(K key), IndexOfValue(V value)
            SortedList<string, int> sl = new SortedList<string, int>();
            sl.Add("Answer", 42);
            sl.Add("Gridlock", 95);
            sl.Add("Lucky", 7);
            sl.Remove("Gridlock");
            Console.WriteLine("SortedList: ");
            foreach (string s in sl.Keys) {
                Console.WriteLine(s + ": " + sl[s]); //returns Snaser: 42 Lucky: 7
            }
            Console.WriteLine("Count: " + sl.Count); //returns 2
            
            //BitArray
            //Properties:  Count, IsReadOnly
            //Methods:  Get(int i), Set(int i, bool value), SetAll(bool value), And(BitArray ba),
            //Or(BitArrray ba), Not(), Xor(BitArray ba)
            BitArray ba1 = new BitArray(4);
            BitArray ba2 = new BitArray(4);
            ba1.SetAll(true);
            ba2.SetAll(false);
            ba1.Set(2, false);
            ba2.Set(3,true);
            PrintBarr("ba1", ba1);
            PrintBarr("ba2", ba2);
            Console.WriteLine();
            PrintBarr("ba1 AND ba2", ba1.And(ba2)); //returns false false false true, both must be true
            PrintBarr("ba1 OR ba2", ba1.Or(ba2)); //returns false false false true???
            PrintBarr("    NOT ba2", ba2.Not()); //returns true true true false

            //Stack<T>
            //Last in, first out.  Uses push and pop at the top of the stack.
            //Properties:  Count
            //Methods:  Peek(), Pop(), Push(T t), Clear(), Contains(T t), ToArray()
            Stack<int> st = new Stack<int>();
            st.Push(59); st.Push(42); st.Push(18); st.Push(7);
            Console.Write("Stack: ");
            foreach (int i in st)
                Console.Write(i + " ");
            
                Console.Write("\nCount: " + st.Count);
                Console.Write("\nTop: " + st.Peek());
                Console.Write("\nPop: " + st.Pop());
                Console.Write("\nStack: ");
            foreach (int i in st) {
                Console.Write(i + " ");
            }
            Console.Write("\nCount: " + st.Count);

            //Queue<T>
            //First in, first out.  Uses enqueue to add and dequeue to remove.
            //Properties: Count
            //Methods: Enqueue(T t), Dequeue(), Clear(), Contains(T t), Peek(), ToArray()
            Queue<int> qu = new Queue<int>();
            qu.Enqueue(5); qu.Enqueue(10); qu.Enqueue(15);
            Console.Write("\n\nQueue: ");
            foreach (int i in qu) {
                Console.Write(i + " ");
            }
            Console.Write("\nCount: " + qu.Count);
            Console.Write("\nDequeue: " + qu.Dequeue());
            Console.Write("\nQueue: ");
            foreach (int i in qu) {
                Console.Write(i + " ");
            }
            Console.Write("\nCount: " + qu.Count + "\n");

            //Dictionary<U, V>
            //Collection of unique key/value pairs where a key is used to access its value
            //Properties:  Count, Item[K key], Keys, Values
            //Methods:  Add(K key, V value), Remove(K key), Clear(), ContainsKey(K key), ContainsValue(V value)
            Dictionary<string, int> di = new Dictionary<string, int>();
            di.Add("Uno", 1); di.Add("One", 1); di.Add("Dos", 2); di.Add("Two", 2);
            di.Remove("One");
            Console.WriteLine("\nDictionary: ");
            foreach (string s in di.Keys) {
                Console.WriteLine(s + ": " + di[s]);
            }
            Console.WriteLine("\nCount: {0}", di.Count);

            //HashSet<T>
            //Collection of unique values where duplicates are not allowed.
            //Properties:  Count
            //Methods:  Add(T t), IsSubsetOf(ICollection c), Remove(T t), Clear(), Contains(T t)
            //          ToString(); IsSupersetOf(ICollection c), UnionWith(ICollection c),
            //          IntersectWith(ICollection c), ExceptWith(ICollect c)
            HashSet<int> hs = new HashSet<int>();
            hs.Add(5); hs.Add(10); hs.Add(15); hs.Add(20);
            Console.Write("\n\nHashSet: ");
            foreach (int i in hs) {
                Console.Write(i + " ");
            }
            Console.Write("\nCount: " + hs.Count);
            
            HashSet<int> hs2 = new HashSet<int>();
            hs2.Add(15); hs2.Add(20);
            Console.Write("\n{15, 20} is a subset of {5, 10, 15, 20}: " + hs2.IsSubsetOf(hs) + "\n");
        }
    }
}
