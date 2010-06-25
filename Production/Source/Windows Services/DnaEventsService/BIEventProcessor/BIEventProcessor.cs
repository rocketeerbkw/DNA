using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Timers;

namespace Dna.BIIntegration
{
    public class BIEventProcessor : Timer
    {
        public BIEventProcessor()
        {
            Elapsed += new ElapsedEventHandler(BIEventProcessor_Elapsed);
        }

        void BIEventProcessor_Elapsed(object sender, ElapsedEventArgs e)
        {
            throw new NotImplementedException();
        }
    }
}
