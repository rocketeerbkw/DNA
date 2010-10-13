using System;
using System.Collections.Generic;
using System.Text;

namespace TestUtils
{
    public class RandomStringGenerator
    {
        private Random r;
        const string UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const string LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
        const string NUMBERS = "0123456789";
        const string SYMBOLS = @"~`!@#$%^&*()-_=+<>?:,./\[]{}|'";

        public RandomStringGenerator()
        {
            r = new Random();
        }

        public RandomStringGenerator(int seed)
        {
            r = new Random(seed);
        }

        public static string NextString(int length)
        {
            var r = new RandomStringGenerator(DateTime.Now.Millisecond);
            return r.NextString(length, true, true, true, true);
        }

        public virtual string NextString(int length, bool lowerCase, bool upperCase, bool numbers, bool symbols)
        {
            char[] charArray = new char[length];
            string charPool = string.Empty;

            //Build character pool
            if (lowerCase)
                charPool += LOWERCASE;

            if (upperCase)
                charPool += UPPERCASE;

            if (numbers)
                charPool += NUMBERS;

            if (symbols)
                charPool += SYMBOLS;

            //Build the output character array
            for (int i = 0; i < charArray.Length; i++)
            {
                //Pick a random integer in the character pool
                int index = r.Next(0, charPool.Length);

                //Set it to the output character array
                charArray[i] = charPool[index];
            }

            return new string(charArray);
        }
    }
}
