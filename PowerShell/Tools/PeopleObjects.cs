using System;
using System.Collections;
using System.Collections.Generic;
namespace People
{
    public enum Gender
    {
        Unknown,
        Male,
        Female
    }
    //The Person class represents one person. The properties define the attributes of a person such as the name, age and gender. The linked properties are for the mother, father and spouse and from the basis for the relationships. All other relationships can be derived from these three basic links such as siblings and children.
    public class Person
    {
        private People _people;
        public String _motherID = "";
        public String _fatherID = "";
        public String _spouseID = "";
        public People People { set { this._people = value; } }
        public String ID { get { return this.Name; } }
        public string Name { get; set; }
        public Gender Gender { get; set; }
        public int Age { get; set; }
        public bool IsMale { get { return (this.Gender == Gender.Male); } }
        public bool IsFemale { get { return (this.Gender == Gender.Female); } }
        public Person Mother
        {
            get
            {
                return _people[this._motherID];
            }
            set
            {
                if (value != null) { this._motherID = value.ID; }
            }
        }
        public Person Father
        {
            get
            {
                return _people[this._fatherID];
            }
            set
            {
                if (value != null) { this._fatherID = value.ID; }
            }
        }
        public Person Spouse
        {
            get
            {
                return _people[this._spouseID];
            }
            set
            {
                if (value != null) { this._spouseID = value.ID; }
            }
        }
        public Persons Parents
        {
            get
            {
                Persons Parents = new Persons();
                Parents.Add(this.Mother);
                Parents.Add(this.Father);
                return Parents;
            }
            set
            {
                foreach (Person Parent in value)
                {
                    if (Parent.Gender == Gender.Male)
                    {
                        this.Father = Parent;
                    }
                    else if (Parent.Gender == Gender.Female)
                    {
                        this.Mother = Parent;
                    }
                }
            }
        }

        public Persons Children
        {
            get
            {
                return _people.Person_Children(this);
            }
        }

        public Persons Siblings
        {
            get
            {
                return _people.Person_Siblings(this);
            }
        }

        public Persons GrandChildren
        {
            get
            {
                Persons grandChildren = new Persons();
                foreach (Person child in this.Children)
                {
                    grandChildren.AddPersons(child.Children);
                }
                return grandChildren;
            }
        }

        public Persons GrandParents
        {
            get
            {
                Persons grandParents = new Persons();
                foreach (Person parent in this.Parents)
                {
                    grandParents.AddPersons(parent.Parents);
                }
                return grandParents;
            }
        }

        // Constructor
        public Person(People people, string Name, Gender Gender, int Age)
        {
            this._people = people;
            this.Name = Name;
            this.Gender = Gender;
            this.Age = Age;
        }
    }
    /*
    The Persons class is a collection type class. The Persons class inherits the IEnumerable interface. The IEnumerable interface is what gives the functionality to the ForEach looping mechanism. Within the Persons class, a private class is defined called PersonEnumerator and it is this class that is actually passed to the ForEach statement.  It is this private class that is returned when the GetEnumerator method is called by the ForEach mechanism.
    //The PersonEnumerator class needs a constructor that passes the list to it, so it has the list to iterate through. The other methods / properties are Current, MoveNext and Reset. In this case , a list is used, but it does not matter what collection data type is used as long as the constructor passes the collection data type that is used and the methods and properties implement the behavior of the collection data type that is being used.
    //The Persons purpose is not a fully implemented collection class, there is no remove method for example. But rather, it is a placeholder or read only collection to hold multiple person objects that are returned from various Person properties like Parents or Children.
    */

    public class Persons : System.Collections.IEnumerable
    {
        private System.Collections.Generic.List<Person> _persons
        = new System.Collections.Generic.List<Person>();

        public int Count { get { return _persons.Count; } }
        public Person this[int index]
        {
            get { return (Person)_persons[index]; }
        }
        public void Add(Person person)
        {
            if (person != null)
            {
                _persons.Add(person);
            }
        }
        public void AddPersons(Persons persons)
        {
            foreach (Person person in persons)
            {
                this.Add(person);
            }
        }
        public System.Collections.IEnumerator GetEnumerator()
        {
            return new PersonEnumerator(_persons);
        }
        private class PersonEnumerator : System.Collections.IEnumerator
        {
            private System.Collections.Generic.List<Person> _persons;
            private int _position = -1;
            public PersonEnumerator(System.Collections.Generic.List<Person> persons)
            {
                _persons = persons;
            }
            object System.Collections.IEnumerator.Current
            {
                get
                {
                    return _persons[_position];
                }
            }
            bool System.Collections.IEnumerator.MoveNext()
            {
                _position++;
                return (_position < _persons.Count);
            }
            void System.Collections.IEnumerator.Reset()
            {
                _position = -1;
            }
        }
    }
    /*
    People is a collection type class. It inherits the dictionary base class. The enumerator private class is not required as it is implemented in the dictionary base class. The methods that are required to implement are the add and remove methods and the this property. To access any element requires a key, similar to a hashtable.
    The purpose of the People class is to hold all of the defined persons vs the purpose of the Persons class which just holds the persons there were returned by a property of the Person class. Since the People Class is a dictionary and is keyed, that allows for easy retrieval of elements or persons, for example, the Person class has a _FatherID property and that is used as the key to fetch the associated element or person. The Father property is a one-to-one relationship and since the key for the father and mother is stored with the person it is easy to get either or both of the parents directly. The children property however, is a one-to-many relationship and a derived property, (no direct link). In order to get the children of a person, all of the People in the dictionary has to be searched for those that have a MotherID or FatherID that is the same as the ID of the person that is being search for. There are techniques to optimize these searches but that is beyond the scope of this article.
    Any derived property in the Person class that does not have a direct link, calls a corresponding method in the People class. This shields the implementation details of the People class from the Person class. The People class is based on a dictionary that needs to be rebuilt with each session and is stored in memory, but if the People class was persistent and based on a SQL Server table for example, the Person class would continue to function as is and would be oblivious to any implementation change.
    */

    public class People : DictionaryBase
    {
        public void Add(string key, Person person)
        {
            if (person != null)
            {
                Dictionary.Add(key, person);
            }
        }
        public void Remove(string key)
        {
            Dictionary.Remove(key);
        }
        public Person this[string key]
        {
            get { return (Person)Dictionary[key]; }
            set { Dictionary[key] = value; }
        }
        public Persons Person_Children(Person person)
        {
            Persons children = new Persons();
            if (person != null)
            {
                foreach (DictionaryEntry PersonEntry in Dictionary)
                {
                    Person child = PersonEntry.Value as Person;
                    if (child._motherID == person.ID)
                    {
                        children.Add(child);
                    }
                    else if (child._fatherID == person.ID)
                    {
                        children.Add(child);
                    }
                }
            }
            return children;
        }
        public Persons Person_Siblings(Person person)
        {
            Persons siblings = new Persons();
            if (person != null)
            {
                foreach (DictionaryEntry PersonEntry in Dictionary)
                {
                    Person sibling = PersonEntry.Value as Person;
                    if (sibling.ID != person.ID)
                    {
                        if (sibling._motherID != "" &&
                        sibling._motherID == person._motherID)
                        {
                            siblings.Add(sibling);
                        }
                        else if (sibling._fatherID != "" &&
                         sibling._fatherID == person._fatherID)
                        {
                            siblings.Add(sibling);
                        }
                    }
                }
            }
            return siblings;
        }
    }
    /*
    The Factory class is a static class and has static members. Static classes can not be instantiated with the New-Object cmdlet. The members are called with a syntax like this
    $People=[People.Factory]::BuildPeople()
    The purpose of static classes is to provide common utilities or helper functions for classes that can be instantiated. In this case, functions are available to create person objects and to link those person objects together in some meaningful way. It can be quite complicated to link them all together, so these helper functions are a convenient way to help manage that complexity. 
    */
    public static class Factory
    {
        public static Person NewPerson(People people, string Name,
         Gender Gender, int Age)
        {
            Person Person = new Person(people, Name, Gender, Age);
            people.Add(Person.ID, Person);
            return Person;
        }
        public static Person NewMan(People people, string Name, int Age)
        {
            return NewPerson(people, Name, Gender.Male, Age);
        }
        public static Person NewWoman(People people, string Name, int Age)
        {
            return NewPerson(people, Name, Gender.Female, Age);
        }
        public static Persons AsCouple(Person man, Person woman)
        {
            Persons couple = new Persons();
            if (man != null)
            {
                man.Spouse = woman;
                couple.Add(man);
            }
            if (woman != null)
            {
                woman.Spouse = man;
                couple.Add(woman);
            }
            return couple;
        }
        public static void AsFamily(Person father, Person mother, Person person,
        Person brother, Person sister)
        {
            Persons parents = AsCouple(father, mother);
            if (person != null) { person.Parents = parents; }
            if (sister != null) { sister.Parents = parents; }
            if (brother != null) { brother.Parents = parents; }
        }
        public static People BuildPeople()
        {
            People People = new People();
            Person Father, Mother;
            Person Person, Brother, Sister;
            Father = Factory.NewMan(People, "Father", 79);
            Mother = Factory.NewWoman(People, "Mother", 77);
            Person = Factory.NewMan(People, "Person", 60);
            Brother = Factory.NewMan(People, "Brother", 59);
            Sister = Factory.NewWoman(People, "Sister", 58);
            Factory.AsFamily(Father, Mother, Person, Brother, Sister);
            Father = Person;
            Mother = Factory.NewWoman(People, "Spouse", 57);
            Person = null;
            Brother = Factory.NewMan(People, "Son", 40);
            Sister = Factory.NewWoman(People, "Daughter", 39);
            Factory.AsFamily(Father, Mother, Person, Brother, Sister);
            return People;
        }
    }
}