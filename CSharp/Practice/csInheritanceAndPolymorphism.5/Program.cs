using System;

namespace csInheritanceAndPolymorphism._5
{
    class Program
    {
        class baseClass {
            public int Legs {get;set;}
            public int Age {get;set;}
            public void Speak() {
                Console.WriteLine("Good day");
            }
            protected int Parties {get;set;}
            protected string LastName {get;set;}
            public baseClass() {
                Console.WriteLine("Creating baseClass");
            }
            ~baseClass() {
                Console.WriteLine("Deleting baseClass");
            }
        }
                                                /*Public members of the base class become 
                                                public members of the derived class. */
        class derivedClass : baseClass {        //Can only have one base class
            public derivedClass(int pr, string ln) {
                Legs = 4;                       //Constructor to set derived class to 4 legs
                Parties = pr;
                LastName = ln;
                Console.WriteLine("Creating derivedClass");
            }
            ~derivedClass() {
                Console.WriteLine("Deleting derivedClass");
            }
            public void Bark() {
                Console.WriteLine("Woof");          //public method on derived class
            }
            public void SayName() {
                Console.WriteLine("My name is: "+LastName);
            }
            public static int Number = 0;
        }
        sealed class sealedClass { //sealed keyword means no class can inherit from this class
            public string Type = "Special";
        }
        //class sealedClassDerivative : sealedClass {} //error

        //Polymorphism
        class Shape {
            public virtual void Draw() {
                Console.WriteLine("Base class draw method");
            }
        }
        class Circle : Shape {
            public override void Draw() {
                Console.WriteLine("Drawing a circle");
            }
        }
        class Rectangle : Shape {
            public override void Draw() {
                Console.WriteLine("Drawing a rectangle.");
            }
        }

        //Abstract classes
        abstract class abstractClass {
            public abstract void Draw(); //Use abstract when there's no real reason for the base class to have a definition for the method.
        }
        class abstractCircle : abstractClass {
            public override void Draw() {
                Console.WriteLine("Drawing a circle");
            }
        }
        class abstractRectangle : abstractClass {
            public override void Draw() {
                Console.WriteLine("Drawing a rectangle");                
            }
        }

        //Interfaces
        public interface IShape { //capital I in name is common for interfaces
            void Draw(); //Interfaces are fully abstract
        }
        public interface ISquash
        {
            void Squash();
        }
        class interfaceCircle : baseClass,IShape,ISquash { //Multiple Interfaces possible
            //No override needed when using an Interface
            //One base class must come before interfaces, if used.
            public void Draw() {
                Console.WriteLine("Drawing a circle (interface version)");
            }
            public void Squash() {
                Console.WriteLine("Squashing the shape (second interface)");
            }
        }

        //Main-----------------------------------------------------------------------------
        static void Main(string[] args)
        {
            //Inheritance and Polymorphism
            //Instantiate derived class and access its inherited public method
            derivedClass d = new derivedClass(7,"Smith");
            Console.WriteLine(d.Legs); //returns 4
            d.Bark(); //returns Woof
            d.Speak();
            Console.WriteLine(derivedClass.Number);
            //protected members of base class
            d.SayName(); //Works because derived class SayName method has access to base class' field/var
            //d.LastName = "Jones"; //error, due to "protected" protection level in base class

            //Polymorphism
            Shape c = new Circle();
            c.Draw(); //outputs circle
            Shape r = new Rectangle();
            r.Draw(); //outputs rectangle

            //Abstract class
            abstractClass v = new abstractCircle();
            v.Draw(); //circle

            //Interface
            IShape z = new interfaceCircle();
            z.Draw(); //Outputs circle drawing
            ISquash y = new interfaceCircle();
            y.Squash(); //Outputs about squashing
        }
    }
}
