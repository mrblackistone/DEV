$PeopleDefinition = @"
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
"@
Add-Type -TypeDefinition $PeopleDefinition
Remove-Variable PeopleDefinition
$People = [People.Factory]::BuildPeople()
$Person = $People["Person"]

<#
The Remove-Variable statement removes the PeopleDefinition string variable from the session to free up resources as it is no longer needed once it has been used by the Add-Type cmdlet. Once an Add-Type has been defined, it cannot be removed from the PowerShell session. Quitting the PowerShell session (ISE or console) and starting again will remove the class types. 
Basically there are three types of classes in this example, which are represented by the person, persons and the factory class. There are other types of classes but those are beyond the scope of this article which is intended for a PowerShell audience.
What distinguishes these three classes? A person class is a single element class and holds the data or state of one person. The persons class is a collection type class and would contain one or more of the element class person in some kind of collection class, like an array or a list or a hashtable or a dictionary. A collection type class has an enumerator method so that it can be called by the ForEach statement and iterated through. The people class is similar to the persons class in that it is a collection type class but serves a different purpose than the persons class. The third type of class is the static class or in this case the static factory class. Static classes can not be instantiated with the New-Object cmdlet as the other two types of classes can be. 
PSObjects are instantiated with the New-Object cmdlet and it's properties are populated with a hashtable. Properties can be dynamically added to a PSObject with the Add-Member cmdlet. Whereas the .Net Framework type classes defined and added with the Add-Type cmdlet can not be changed, or in other words, the properties can not be dynamically added with Add-Member cmdlet. The structure or definition of the classes once added with the Add-Type cmdlet is set in stone until the end of the PowerShell session. It is possible to quit the session, modify the definition and do Add-Type statement and the new definition will be available until the end of that PowerShell session. 
PSObjects are containers to conveniently store or hold values and only have properties (note-properties). The .NET Framework classes have properties and methods including constructors that hold values but also are code driven which is probably why you want to define and use these types of classes / objects.
The next sections describes each of these classes, how they are implemented, how they relate to each other and how they can be used in PowerShell, for example;
$GrandParents = $Person.Parents.Parents
#>

#Using the Classes in PowerShell
#This is where the fun begins, using the defined classes as objects in PowerShell.
#The static class People.Factory provides a static method named BuildPeople().  To conserve space in the the listings above, it shows a BuildPeople() method to build the minimal number of persons necessary to demonstrate the functionality of the relational properties defined for the Person class. The source code available in the gallery 
#and has a larger pool of persons for the People class and a another method named BuildExtendedPeople().  All the persons that are defined in the People dictionary are named relative to a Person named Person. It spans the generations from the Person's grandparents to the Person's grandchildren. The names of the persons are generic relational terms and unique for the pool of persons defined. For example, the person's father is named 'Father'. The person's grandfathers would be named 'Father's Father' and 'Mother's Father'. Similarly, the Person's grandsons, would be named 'Son's Son' and 'Daughter's Son'
#Using the Classes at the PowerShell Command Prompt
#To get started, this is a sample session that creates a People object with a call to the BuildExtendedPeople() method. It then gets the person object for the person named Person and displays it's properties.
Add-Type -TypeDefinition $PeopleDefinition
$People = [People.Factory]::BuildExtendedPeople()
$Person = $People["Person"]
$Person
$Person | Select-Object Name
$Person.Parents | Select-Object Name
$Person.Parents.Parents | Select-Object Name
 
#This is where the beauty of PowerShell starts to come into focus. The $Person object is of the [People.Person] type. The $Person.Parents is the Parents property being called on the $Person object and returns a collection object of the [People.Persons] type.
#But what about $Person.Parents.Parents? The [People.Persons] class does not have a method or property named Parents. This is the boundary of where the activity of the classes ends and the beginning of the activity of PowerShell starts. It's an implied Pipe where each member that was returned from the Person.Parents call, is applied with a call to it's Parents property. This can be verified by the type that was returned.
$Person.GetType()
$Person.Parents.GetType()
$Person.Parents.Parents.GetType()
#The $Person and $Person.Parents returned the expected types. The $Person.Parent.Parents returns Object[], an array of objects. The Persons class is a strictly typed collection class. It's PowerShell that returns the object array. The classes do not use arrays.
#Also included in the Person class was a GrandParents property. The GrandParents property was included to demonstrate how to apply the Parents property call to a Parents property call.
$Person.GrandParents | Select-Object Name
$Person.GrandParents.GetType()
#The GrandParent property returns a People.Persons object and not an object array. Which is better, the Persons object or the Object array? There are two metrics to consider, performance and functionality. Performance-wise, the classes will perform faster because they are compiled.  In terms of functionality, both are the same relative to a pipe or a ForEach loop.
#The person class has three one-to-one directly linked properties; Father, Mother and Spouse. The two one-to-many properties Children and Siblings are expensive operations relative to the Father or Mother properties as the entire People dictionary has to be searched  to find those that meet the criteria of the property. In the sample there are only 70 persons defined ($People.Count=70) so the Children and Siblings operations do not take that too long. If the number of persons defined were to increase, then the times to to perform these operations would increase as well, unless some sort of search optimization techniques were employed. To define any relationships efficiently, the Children and Siblings calls should be minimized.
#In terms of  these five properties Father,Mother, Spouse, Children and Siblings, almost every relationship can be obtained. For example, in the case of the children, the Person is one of the children of the Person's father. The other children would be Person's siblings.
$Person.Father.Children | Select-Object Name
$Person.Siblings | Select-Object Name
#In this perfect world little scenario, the mother and father has the same children. A call to the $Person.Parents.Children returns twice the children as the both Parents' Children property is called and the results are merged together. The Persons collection object and an object array are not keyed so the same object can be present more than once.
#To overcome this, use the -Unique parameter on the select.
$Person.Parents.Children | Select-Object Name
$Person.Parents.Children | Select-Object Name -Unique
#The Children relationships comes in two flavors based on gender; sons and daughters. Similarly with siblings, there are brothers and sisters. The Person class has a gender field and two querying properties IsMale and IsFemale. The querying properties IsMale and IsFemale can be used with the Where clause to derive the gender based relationships.
#For example, to get the sons and daughters of the Person.Parents of which the Person would be a son, the IsMale and IsFemale property is used with the Where clause.
$Person.Parents.Children | Where-Object{ $_.IsMale } | Select-Object Name -Unique
$Person.Parents.Children | Where-Object{ $_.IsFemale } | Select-Object Name -Unique
$Person.Parents.Siblings | Where-Object{ $_.IsFemale } | Select-Object Name
$Person.Parents.Siblings | Where-Object{ $_.IsMale } | Select-Object Name
$Person.Parents.Siblings.Children | Select-Object Name
$Person.Siblings.Children | Where-Object{ $_.IsFemale } | Select-Object Name
$Person.Siblings.Children | Where-Object{ $_.IsMale } | Select-Object Name
$Person.Spouse.Parents | Select-Object Name
$Person.Spouse.Siblings | Select-Object Name
$Person.Spouse.Siblings.Children | Select-Object Name
#So far all the commands have started with the $Person variable, but it will work for any Person object in the People dictionary. It is just that the terms or names are relative to the Person, so it can be confusing for other persons.
#So in this example, the grandson of the Person will be used and will be assigned to the variable $GrandSon. For the grandson all the ancestors will be shown or in other words, all of the generations of parents will be shown.  The Person's grandparents would be the Person's grandson's Great-Great-GrandParents.
$Person.Children.Children | Select-Object Name
$GrandSon = ($Person.Children.Children)[1]
$GrandSon.Name
$GrandSon.Parents | Select-Object Name
$GrandSon.Parents.Parents | Select-Object Name
$GrandSon.Parents.Parents.Parents | Select-Object Name
$GrandSon.Parents.Parents.Parents.Parents | Select-Object Name
#There are persons missing, the Son's Spouse's family and ancestors have not been defined in the People dictionary.


#Using the Classes in PowerShell Functions
#So far, all the examples have been at the command prompt, and while that might be fun and interesting, it`s not very practical. To be more practical, functions should be employed that implement these relationships. To obtain the more complex relationships would require calling a combination of functions.
#The functions should be as robust as possible and work with the pipeline. The first function will that will be examined is a wrapper function for the Parents property.
Function Get-Parents {
    [CmdletBinding()]
    Param ([Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Object]$Person
    )
    Process { 
        $Person | Foreach-Object { $_.Parents }
    }
} 
#Using the function Get-Parents with a parameter and with the pipeline for a person.
Get-Parents $Person | Select-Object Name
$Person | Get-Parents | Select-Object Name
#Using the function Get-Parents with a parameter that has multiple objects and with the pipeline with multiple objects.
Get-Parents $Person.Parents | Select-Object Name
$Person.Parents | Get-Parents | Select-Object Name
#When the process directive is declared within the function, it will process each object coming in from the pipeline and allows for the cascading of the functions in the pipeline.
$Person | Get-Parents | Get-Parents | Select-Object Name
#The cascading of Get-Parents | Get-Parents is returning the grandparents of the person. This can be incorporated into a Get-GrandParents function.
Function Get-GrandParents {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Object]$Person
    )
    Process {
        $Person | Get-Parents | Get-Parents
    }
}
Get-GrandParents $Person | Select-Object Name
$Person | Get-GrandParents | Select-Object Name
#Similar wrapper functions can be built for Get-Children, and Get-Siblings. A Get-GrandChildren function can use cascading Get-Children functions.
#Then there are the gender filtering functions Get-Males and Get-Females which can be used in the gender specific functions like the Get-Brothers and the Get-Sisters functions.
Function Get-Males {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Object]$Person
    )
    Process {
        $Person | Where-Object{ $_.IsMale }
    }
} 
Function Get-Brothers {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Object]$Person
    )
    Process {
        $Person | Get-Siblings | Get-Males
    }
} 
#Testing the Get-Siblings and Get-Bothers functions.
$Person | Get-Siblings | Select-Object Name
$Person | Get-Brothers | Select-Object Name
#There are many options or ways of getting the same result. For example, to get the person's uncles;
$Person.Parents.Siblings | Where-Object{ $_.IsMale}
$Person.Parents.Siblings | Get-Males
$Person.Parents | Get-Brothers
$Person | Get-Parents | Get-Brothers
Get-Uncles $Person
#That is complex filtering but it's intuitive and easy to understand and maintain. 
#The last functions to consider would be the ancestors and descendants functions.
#The Get-Ancestors function is like a Get-Parents function with the recurse switch set to true.
Function Get-Ancestors {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Object]$Person
    )
    Process {
        $Parents = $Person | Get-Parents
        IF ($null -ne $Parents) {
            $Parents
            Get-Ancestors $Parents
        }
    }
}
#The Get-Descendants function is like a Get-Children function with the recurse switch set to true.
Function Get-Descendants {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Object]$Person
    )
    Process {
        $Children = $Person | Get-Children
        IF ($null -ne $Children) {
            $Children
            Get-Descendants $Children
        }
    }
}
 
#Using the Get-Ancestors and the Get-Descendants Function on $Person.
$Person | Get-Ancestors | Select-Object Name
$Person | Get-Descendants | Select-Object Name
#Using the Get-Ancestors function on the person`s grandson.
$GrandSon = ($Person | Get-GrandChildren)[1]
$GrandSon.Name
