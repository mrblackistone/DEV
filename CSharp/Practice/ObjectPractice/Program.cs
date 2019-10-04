using System;

namespace ObjectPractice
{
    class Program
    {
        public class Lifeform
        {
            string Name { get; set; }
            int Lifespan { get; set; }
        }

        public class Animal : Lifeform
        {
            bool Carnivore { get; set; }
            bool Herbivore { get; set; }
            bool Swims { get; set; }
            bool Walks { get; set; }
            bool Flies { get; set; }
            bool Climbs { get; set; }
        }
        static GenerateMap(int width, int height, int numOceans)
        {
            //0 = Land
            //1 = Water
            //Initialize Map with all land
            int[,] landMap = new int[width, height];
            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    landMap(x, y) = 0;
                }
            }
            //Seed Ocean Start Points
            for (int a = 0; a < numOceans; a++)
            {
                Random landType = new Random();
                int x = landType.Next(width);
                int y = landType.Next(height);
                landMap(x, y) = 1;
            }
            //Grow Oceans
            for (a = 0; a < 1000; a++)
            {
                for (int y = 0; y < height; y++)
                {
                    for (int x = 0; x < width; x++)
                    {
                        int a = landType(4);
                    }
                }
            }
        }
        //----------------------------------------------------

        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
