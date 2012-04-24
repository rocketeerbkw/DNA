using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace TestDnaCacheFileDel
{
    class Program
    {
        static void Main(string[] args)
        {
            string rootfolder = args[0];
            string[] roots = { rootfolder, rootfolder + @"\articles", rootfolder + @"\forums" };

            foreach (string root in roots)
            {
                if (!Directory.Exists(root))
                    Directory.CreateDirectory(root);
            }

            Random r = new Random();

            while (true)
            {
                for (int i = 0; i < 1000; i++)
                {
                    int n = r.Next(500000);
                    int rn = r.Next(roots.GetLength(0));

                    string newfile = Path.Combine(roots[rn], n.ToString() + ".txt");
                    using (FileStream fs = File.Open(newfile, FileMode.OpenOrCreate))
                    {
                        byte[] info = new UTF8Encoding(true).GetBytes(DateTime.Now.ToString());
                        fs.Write(info, 0, info.Length);
                    }
                }
                System.Threading.Thread.Sleep(500);
            }
        }
    }
}
