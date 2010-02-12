using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System;

namespace BBC.Dna.Sites.Tests
{
    
    
    /// <summary>
    ///This is a test class for ContextTest and is intended
    ///to contain all ContextTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ContextTest
    {


        /// <summary>
        ///A test for Context Constructor
        ///</summary>
        [TestMethod()]
        public void ContextConstructor_WithDiag_ReturnsNotNull()
        {
            IDnaDataReaderCreator readerCreator = new DnaDataReaderCreator("", new DnaDiagnostics(0, DateTime.Now));
            Context target = new Context(readerCreator, null);
            Assert.IsNotNull(target.DnaDiagnostics);
        }

        /// <summary>
        ///A test for Context Constructor
        ///</summary>
        [TestMethod()]
        public void ContextConstructor_WithoutDiag_ReturnsNotNull()
        {
            IDnaDataReaderCreator readerCreator = new DnaDataReaderCreator("", null);
            Context target = new Context(readerCreator,null);
            Assert.IsNotNull(target.DnaDiagnostics);
        }
    }
}
