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
        }
        //Properties

    }
}
