using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace BBC.Dna.LoadTest
{
    public class LoggingHelper
    {
        private readonly string _name;

        public LoggingHelper(string name)
        {
            _name = name;
        }

        public string Content { get; set; }

        public void WriteToLog()
        {
            WriteSection(_name, Content);
        }

        public static void WriteSection(string name, string content)
        {
            Console.WriteLine(" ================================= START {0} ================================= ", name.ToUpper());
            Console.Write(content);
            Console.WriteLine(" ================================= END {0}   ================================= ", name.ToUpper());

        }

        public static void WriteFileSection(string name, string fileName)
        {
            var stream = File.OpenText(fileName);
            var content = stream.ReadToEnd();
            WriteSection(name, content);

        }

    }
}
