using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// Tests for the skins Class
    /// </summary>
    [TestClass]
    public class SkinTests
    {
        /// <summary>
        /// Test1CreateSkinClassTest
        /// </summary>
        [TestMethod]
        public void Test1CreateSkinClassTest()
        {
            Skin testSkin = new Skin();

            Assert.IsNotNull(testSkin, "Skin object created.");
          
        }

        /// <summary>
        /// Test2AssignSkinDescription
        /// </summary>
        [TestMethod]
        public void Test2AssignSkinDescription()
        {
            Skin testSkin = new Skin();
            testSkin.Description = "Test Description";

            Assert.AreEqual(testSkin.Description, "Test Description");
        }

        /// <summary>
        /// Test3AssignSkinName
        /// </summary>
        [TestMethod]
        public void Test3AssignSkinName()
        {
            Skin testSkin = new Skin();
            testSkin.Name = "Test Name";

            Assert.AreEqual(testSkin.Name, "Test Name");
        }

        /// <summary>
        /// Test4AssignSkinUseFrames
        /// </summary>
        [TestMethod]
        public void Test4AssignSkinUseFrames()
        {
            Skin testSkin = new Skin();
            testSkin.UseFrames = true;

            Assert.AreEqual(testSkin.UseFrames, true);
        }

        /// <summary>
        /// Test5CreateSkinWithInitialValues
        /// </summary>
        [TestMethod]
        public void Test5CreateSkinWithInitialValues()
        {
            Skin testSkin = new Skin("Test Name", "Test Description", true);

            Assert.AreEqual(testSkin.Name, "Test Name");
            Assert.AreEqual(testSkin.Description, "Test Description");
            Assert.AreEqual(testSkin.UseFrames, true);
        }

        /// <summary>
        /// Test6CreateSkinFromSkin
        /// </summary>
        [TestMethod]
        public void Test6CreateSkinFromSkin()
        {
            Skin testSkin1 = new Skin("Test Name", "Test Description", true);
            Skin testSkin2 = new Skin(testSkin1);

            Assert.AreEqual(testSkin2.Name, "Test Name");
            Assert.AreEqual(testSkin2.Description, "Test Description");
            Assert.AreEqual(testSkin2.UseFrames, true);
        }

    }
}
