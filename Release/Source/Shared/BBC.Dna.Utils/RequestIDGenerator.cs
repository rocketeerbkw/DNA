using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace BBC.Dna.Utils
{

    public class RequestIdGenerator
    {
        private static int id = 0;
        static public int GetNextRequestId()
        {
            return Interlocked.Increment(ref id);
        }
    }
}
