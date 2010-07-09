using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Utils;

namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Summary description for Entities
    /// </summary>
    [TestClass]
    public class EntitiesTests
    {
        public EntitiesTests()
        {

        }

        [TestMethod]
        public void GetEntities_ReturnsAllEntities()
        {
            Assert.IsTrue(!String.IsNullOrEmpty(Entities.GetEntities()));
        }

        [TestMethod]
        public void ReplaceEntitiesWithNumericValues_StringContainsEntity_ReturnsReplacedEntities()
        {
            var text = "this contains &nbsp text entities";
            var expected = "this contains &#160; text entities";
            Assert.AreEqual(expected, Entities.ReplaceEntitiesWithNumericValues(text));
        }

        
    }
}
