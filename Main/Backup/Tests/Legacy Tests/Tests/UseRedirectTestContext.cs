using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;

namespace Tests
{
    class UseRedirectTestContext : TestInputContext
    {
        public override bool TryGetParamString(string paramName, ref string value, string description)
        {
            if (paramName == "dnaur") 
            { 
                value = "0"; 
            } 
            return true;
        }
    }
}
