using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// Tests for the SiteOptionsList and SiteOption class
    /// </summary>
    [TestClass]
    public class SiteOptionTests 
    {
        /// <summary>
        /// Sets up the tests
        /// </summary>
        [TestInitialize]
        public void SetUpSiteOptionTests()
        {
        }

        private void TestSiteOptionInvalidBool(string value)
        {
            try
            {
                SiteOption so = new SiteOption(1, "eh up", "chuck", value, SiteOption.SiteOptionType.Bool, "bool");
            }
            catch (SiteOptionInvalidTypeException ex)
            {
                Assert.AreEqual("Value is not a bool", ex.Message);
                return;
            }
            catch (FormatException)
            {
                return;
            }

            Assert.Fail("TestSiteOptionInvalidBool() should always throw an exception");
        }

        private void TestSiteOptionInvalidInt(string value)
        {
            try
            {
                SiteOption so = new SiteOption(1, "eh up", "chuck", value, SiteOption.SiteOptionType.Int, "int");
            }
            catch (OverflowException)
            {
                return;
            }
            catch (FormatException)
            {
                return;
            }

            Assert.Fail("TestSiteOptionInvalidInt() should always throw an exception");
        }

        /// <summary>
        /// Tests the SiteOption constructor
        /// </summary>
        [TestMethod]
        public void TestSiteOptionConstructor()
        {
            Console.WriteLine("TestSiteOptionConstructor");
            SiteOption so;

            so = new SiteOption(1, "hello", "there", "0", SiteOption.SiteOptionType.Bool, "bool");
            so = new SiteOption(1, "hello", "there", "1", SiteOption.SiteOptionType.Bool, "bool");

            so = new SiteOption(1, "hello", "there", int.MinValue.ToString(), SiteOption.SiteOptionType.Int, "int");
            so = new SiteOption(1, "hello", "there", "0", SiteOption.SiteOptionType.Int, "int");
            so = new SiteOption(1, "hello", "there", "1", SiteOption.SiteOptionType.Int, "int");
            so = new SiteOption(1, "hello", "there", int.MaxValue.ToString(), SiteOption.SiteOptionType.Int, "int");

            TestSiteOptionInvalidBool("");
            TestSiteOptionInvalidBool("-1");
            TestSiteOptionInvalidBool("2");
            TestSiteOptionInvalidBool("e");

            Int64 i64 = int.MaxValue;
            i64 += 1;

            TestSiteOptionInvalidInt("");
            TestSiteOptionInvalidInt("agh");
            TestSiteOptionInvalidInt("1.0");
            TestSiteOptionInvalidInt("7E09");

            Int64 overflowInt1 = int.MaxValue;
            overflowInt1 += 1;
            Int64 overflowInt2 = int.MinValue;
            overflowInt2 -= 1;

            TestSiteOptionInvalidInt(overflowInt1.ToString());
            TestSiteOptionInvalidInt(overflowInt2.ToString());
        }

        /// <summary>
        /// Tests the SiteOption methods for the bool type
        /// </summary>
        [TestMethod]
        public void TestSiteOptionMethodsBool()
        {
            Console.WriteLine("TestSiteOptionMethodsBool");
            SiteOption soBool = new SiteOption(1, "sect", "name", "0", SiteOption.SiteOptionType.Bool, "desc");

            Assert.AreEqual(1, soBool.SiteId);
            Assert.AreEqual("sect", soBool.Section);
            Assert.AreEqual("name", soBool.Name);
            Assert.IsFalse(soBool.GetValueBool());
            Assert.IsTrue(soBool.IsTypeBool());
            Assert.IsFalse(soBool.IsTypeInt());

            try
            {
                soBool.GetValueInt();
            }
            catch (SiteOptionInvalidTypeException ex)
            {
                Assert.AreEqual("Value is not an int", ex.Message);
            }

            soBool = new SiteOption(1, "sect", "name", "1", SiteOption.SiteOptionType.Bool, "desc");

            Assert.AreEqual(1, soBool.SiteId);
            Assert.AreEqual("sect", soBool.Section);
            Assert.AreEqual("name", soBool.Name);
            Assert.IsTrue(soBool.GetValueBool());
            Assert.IsTrue(soBool.IsTypeBool());
            Assert.IsFalse(soBool.IsTypeInt());

            try
            {
                soBool.GetValueInt();
            }
            catch (SiteOptionInvalidTypeException ex)
            {
                Assert.AreEqual("Value is not an int", ex.Message);
            }

            soBool.SetValueBool(true);
            Assert.IsTrue(soBool.GetValueBool());

            soBool.SetValueBool(false);
            Assert.IsFalse(soBool.GetValueBool());

            try
            {
                soBool.SetValueInt(42);
            }
            catch (SiteOptionInvalidTypeException ex)
            {
                Assert.AreEqual("Type is not an int", ex.Message);
            }
        }

        /// <summary>
        /// Tests the SiteOption methods for the int type
        /// </summary>
        [TestMethod]
        public void TestSiteOptionMethodsInt()
        {
            Console.WriteLine("TestSiteOptionMethodsInt");
            SiteOption soInt = new SiteOption(1, "sect", "name", "0", SiteOption.SiteOptionType.Int, "desc");

            Assert.AreEqual(1, soInt.SiteId);
            Assert.AreEqual("sect", soInt.Section);
            Assert.AreEqual("name", soInt.Name);
            Assert.AreEqual(soInt.GetValueInt(), 0);
            Assert.IsFalse(soInt.IsTypeBool());
            Assert.IsTrue(soInt.IsTypeInt());

            try
            {
                soInt.GetValueBool();
            }
            catch (SiteOptionInvalidTypeException ex)
            {
                Assert.AreEqual("Value is not a bool", ex.Message);
            }

            soInt.SetValueInt(1);
            Assert.AreEqual(1, soInt.GetValueInt());
            soInt.SetValueInt(0);
            Assert.AreEqual(0, soInt.GetValueInt());
            soInt.SetValueInt(int.MaxValue);
            Assert.AreEqual(int.MaxValue, soInt.GetValueInt());
            soInt.SetValueInt(int.MinValue);
            Assert.AreEqual(int.MinValue, soInt.GetValueInt());

            try
            {
                soInt.SetValueBool(false);
            }
            catch (SiteOptionInvalidTypeException ex)
            {
                Assert.AreEqual("Type is not a bool", ex.Message);
            }
        }
    }
}
