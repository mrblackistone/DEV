using System;

namespace csClassesAndObjects
{
    class Program
    {
        class Person {
            //Defining a class, which is a template for instances of that class (objects)
            //Encapsulation includes:  public, private, protected, internal, protected internal
            //Private is only accessible within the class itself
            public int age; //public FIELD
            private string name; //private FIELD, use PROPERTY to access
            private int vehicles;
            public string NameProperty { //PROPERTY
                get { return name; } //"get" is an ACCESSOR, as is "set"
                set { name = value; } //"value" is a special keyword
            }
            public int Vehicles {
                get { return vehicles; }
                set {
                    if (value >= 0 ) //Using logic in parameter to ensure input is valid
                        vehicles = value;
                }
            }
            public string Nickname { get; set; } //Quick property. Needs no private FIELD declaration and no logic needed.
            public void SayHi() {
                Console.WriteLine("Hello");
            }
        }
        class BankAccount {
            private double balance; //BankAccount.balance can only be referenced within the BankAccount class
            public BankAccount (double bl = 0) {
                balance = bl;
            } //constructor sets value for new instances to 0.  Must be public to set it.
            //If argument/param is given during creation, that'll be the balance.
            public void Deposit(double n) {
                balance += n;
            }
            public void Withdraw(double n) {
                balance -= n;
            }
            public double GetBalance() {
                //This is a property because it allows the red/write/compute of a private field.
                return balance;
            } //Since this is within the class, it can reference balance.  It's referenced as ClassName.MethodName()
            //Example:  BankAccount.GetBalance()
        }
        class animal {
            public string Name { get; set; } //Short form to create properties, and private fields as well.
            //Use when no custom logic is needed.
            public animal (string nm = "Bessie") {
                Name = nm;
            }
            //Constructor sets name to Bessie by default
            ~animal() {
                Console.WriteLine("Dog class destroyed");
            }
            //Destructor writes message when instantiated object is destroyed.
        }
        class staticStuff {
            public static int count=0; //static keyword on method, variable, or property
            //means it belongs to the class itself, instead of to instantiated objects.
            //There's only one copy of the class member, no matter how many instances are created.
            //Static members can be access through their class name: staticStuff.count
            public staticStuff() {
                count++;
            }
            public static void Bark() { //static method, which can only access static members
                Console.WriteLine("Woof!");
            }
        }
        class MathClass {
            public const int ONE = 1; //constants are static by default
        }
        class StaticConstructor {
            public static int X { get; set; }
            public static int Y { get; set; }
            static StaticConstructor() { //Constructor will be called when we try to
            //access StaticConstructor.X or StaticConstructor.Y
                X = 10;
                Y = 20;
            }
        }
        static class StaticClass {
            public static void DoIt() {
                Console.WriteLine("Doing it");
            }
        }
        class thisClass {
            private string name;
            public thisClass(string zzz) {
                this.name = zzz; //this.name represents member of the class, 
                //zzz represents parameter of the constructor
            }
        }
        class readonlyClass {
            private readonly string name = "John"; //readonly variable (field)
            //readonly does not need to be initialized when declared, unlike const
            //readonly can be changed in a constructor, but const cannot
            //readonly value can come from a calculation, whereas a const cannot
            public readonlyClass(string zzz) {
                this.name = zzz;
            }
        }
        class indexerClass {
            private string[] names = new string[10];
            public string this[int index] {
                get {
                    return names[index];
                }
                set {
                    names[index] = value;
                }
            }
        }
        class overloadingClass {
            public int Height {get;set;}
            public int Width {get;set;}
            public overloadingClass(int h, int w) {
                Height = h;
                Width = w;
            }
            //Here's the overload part:
            public static overloadingClass operator+ (overloadingClass a, overloadingClass b) {
                //operator_ where _ is the operator symbol declares this an overload
                int h = a.Height + b.Height;
                int w = a.Width + b.Width;
                overloadingClass res = new overloadingClass(h, w);
                return res;
            }
        }
        //Main----------------------------------------------------------------------------
        static void Main(string[] args)

        {
            Person p1 = new Person();
            p1.SayHi();
            p1.age = 50;
            p1.NameProperty = "Steve";
            Console.WriteLine("Person {0} is {1} years old.", p1.NameProperty, p1.age);
            BankAccount acct1 = new BankAccount(); //No param given, so default balance used.
            acct1.Deposit(500);
            acct1.Withdraw(7);
            Console.WriteLine("Balance is: {0}", acct1.GetBalance());
            
            //Constant (which is static by default)
            Console.WriteLine(MathClass.ONE); //returns 1
            
            //Static Class
            StaticClass.DoIt(); //returns Doing it
            
            //indexer
            indexerClass c = new indexerClass();
            c[0] = "Dave";
            c[1] = "Bob";
            Console.WriteLine(c[1]); //returns Bob

            //Operator overloading
            overloadingClass b1 = new overloadingClass(14,3);
            overloadingClass b2 = new overloadingClass(5,7);
            overloadingClass b3 = b1 + b2; //plus (+) is the operator that was overloaded
            Console.WriteLine(b2.Height); //19
            Console.WriteLine(b2.Width); //10
        }
        //Properties
        //Allow public interaction with private fields

    }
}
