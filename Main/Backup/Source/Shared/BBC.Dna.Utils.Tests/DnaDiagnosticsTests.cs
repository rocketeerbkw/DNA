using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Test file for testing the DnaDiagnostics class
    /// </summary>
    [TestClass]
    public class DnaDiagnosticsTests
    {
        /// <summary>
        /// Setup method that is called before all tests
        /// </summary>
        [TestInitialize]
        public void SetUpDnaDiagnosticsTests()
        {
            //DnaDiagnostics.Initialise(@"c:\temp\testdna\");
        }

        /// <summary>
        /// Teardown method that is called after all tests
        /// </summary>
        [TestCleanup]
        public void TearDownDnaDiagnosticsTests()
        {
            //DnaDiagnostics.Deinitialise();
        }

        /// <summary>
        /// Test method to test the dnadiagnostics class can write to the log correctly
        /// </summary>
        [TestMethod]
        public void TestDnaDiagnostics()
        {
            //DnaDiagnostics diag = new DnaDiagnostics(1, new DateTime(2006,10,23));
            //diag.WriteToLog("Testing", "Testing dna diagnostics");
        }
    }
}
