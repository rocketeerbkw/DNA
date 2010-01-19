using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Text;
using BBC.Dna;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{

    /// <summary>
    /// Class to fake InputContext when testing Sites etc 
    /// </summary>
    class SiteTestInputContext : TestInputContext
    {

       public override ISite CurrentSite
        {
            get
            {
                return new Site(1, "h2g2", 0, false, "brunel", true, "H2G2", "h2g2",
                            "a@b.c", "b@b.c", "c@b.c", 1090497224, false,true, true, "", "Alert", 2000, 1090497224, 0,
                            1, 1, false, false, 16, 255, 1, "h2g2", false, "skinset", "", Diagnostics,  DnaMockery.DnaConfig.ConnectionString);
            }
        }
    }
}
