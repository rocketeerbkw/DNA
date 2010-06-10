using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace DNAIISLogParser
{
    class Program
    {
        static void Main(string[] args)
        {
            if(args.Length == 0)
            {
                Console.WriteLine("Error: No input parameters");
                return;
            }
            

            ParseFiles parse = new ParseFiles();
            parse.OnDebug += new InputLogDelegate(log_OnDebug);

            if (args[0].LastIndexOf("\\") + 1 == args[0].Length)
            {//parsing directory
                parse.ScanDirectory(args[0]);
            }
            else
            {
                FileInfo file = new FileInfo(args[0]);
                parse.ProcessFile(file);
            }
        }


        static void log_OnDebug(object sender, InputLogDebugArgs args)
        {
            Console.WriteLine(args.msg);

        }


    }
}
