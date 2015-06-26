using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace Tests
{
    /// <summary>
    /// Implements the Stored Procedure aspects of InputContext
    /// </summary>
    public class StoredProcedureTestInputContext : TestInputContext
    {
        private DnaConfig _config;

        /// <summary>
        /// Creates the object
        /// </summary>
        public StoredProcedureTestInputContext()
        {
            //Before accessing database restore it to clean state (once only).
			SnapshotInitialisation.RestoreFromSnapshot();

            //string ripleyServerPath = System.Environment.GetEnvironmentVariable("RipleyServerPath");
            //_config = new DnaConfig(ripleyServerPath + @"\");

            //Dont use the config from h2g2 - use the config from dnapages dir.
            //Must find a better solution to finding a test config.
            //_config = new DnaConfig(System.Environment.GetEnvironmentVariable("dnapages") + @"\");
           
            _config = new DnaConfig(TestConfig.GetConfig().GetRipleyServerPath());
            //_config.Initialise();
        }

        /// <summary>
        /// Create an instance of a IDnaDataReader that accesses the configured database
        /// </summary>
        /// <param name="name">The name of the stored procedure you wanr to call</param>
        /// <returns>The data reader</returns>
        public override IDnaDataReader CreateDnaDataReader(string name)
        {
            return new StoredProcedureReader(name, _config.ConnectionString, null);
        }
    }
}
