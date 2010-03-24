using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for SkinTest and is intended
    ///to contain all SkinTest Unit Tests
    ///</summary>
    [TestClass]
    public class SkinTest
    {

        /// <summary>
        ///A test for Skin Constructor
        ///</summary>
        [TestMethod]
        public void SkinConstructorTest()
        {
            string name = string.Empty; 
            string description = string.Empty; 
            bool useFrames = false; 
            var target = new Skin(name, description, useFrames);
            Assert.AreEqual(name, target.Name);
        }

        /// <summary>
        ///A test for Skin Constructor
        ///</summary>
        [TestMethod]
        public void SkinConstructorTest_CopyObject()
        {
            var other = new Skin();
            string name = string.Empty;
            string description = string.Empty;
            bool useFrames = false;
            other = new Skin(name, description, useFrames); 
            var target = new Skin(other);
            Assert.AreEqual(other.Name, target.Name);
        }
    }
}