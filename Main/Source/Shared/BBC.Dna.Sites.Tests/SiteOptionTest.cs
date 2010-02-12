using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Sites;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for SiteOptionTest and is intended
    ///to contain all SiteOptionTest Unit Tests
    ///</summary>
    [TestClass]
    public class SiteOptionTest
    {
        /// <summary>
        ///A test for CreateFromDefault
        ///</summary>
        [TestMethod]
        public void CreateFromDefault_ValidInput_ValidObjectCreated()
        {
            SiteOption defaultSiteOption = GetDefaultSiteOption();
            int siteId = 1;
            SiteOption actual = SiteOption.CreateFromDefault(defaultSiteOption, siteId);
            Assert.AreEqual(siteId, actual.SiteId);
            Assert.AreEqual("test", actual.Description);
        }

        public static SiteOption GetDefaultSiteOption()
        {
            return new SiteOption(0, "test", "test", "1", SiteOption.SiteOptionType.Int, "test");
        }

        public static SiteOption GetEmptySiteOption()
        {
            return new SiteOption(0, "", "", "0", SiteOption.SiteOptionType.Int, "");
        }

        /// <summary>
        ///A test for SiteOption Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionConstructorTest()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Int;
            string description = string.Empty;
            var target = new SiteOption(siteId, section, name, value, type, description);
            Assert.AreEqual(type, target.OptionType);
        }

        /// <summary>
        ///A test for IsGlobal
        ///</summary>
        [TestMethod]
        public void IsGlobalTest()
        {
            var target = GetDefaultSiteOption();
            Assert.IsTrue(target.IsGlobal);
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetValueInt_ValidInt_ReturnsInt()
        {
            int siteId = 0; 
            string section = string.Empty; 
            string name = string.Empty; 
            string value = "1"; 
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Int; 
            string description = string.Empty; 
            SiteOption target = new SiteOption(siteId, section, name, value, type, description); 
            int expected = 1;
            int actual = target.GetValueInt();
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetRawValue_ValidInt_ReturnsIntString()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Int;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);
            Assert.AreEqual(value, target.GetRawValue());
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetValueBool_ValidBool_ReturnsBool()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Bool;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);
            bool actual = target.GetValueBool();
            Assert.IsTrue(actual);
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetRawValue_ValidFalse_ReturnsFalseString()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "0";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Bool;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);
            Assert.AreEqual(value, target.GetRawValue());
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetRawValue_ValidBool_ReturnsBool()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Bool;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);
            Assert.AreEqual(value, target.GetRawValue());
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetValueInt_InvalidInt_ThrowsException()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "0";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Bool;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);
            bool actual = target.GetValueBool();
            Assert.IsFalse(actual);
            try
            {
                target.GetValueInt();
                throw new Exception("GetValueInt should throw exception");
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetValueBool_InvalidBool_ThrowsException()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Int;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);
            int expected = 1;
            int actual = target.GetValueInt();
            Assert.AreEqual(expected, actual);

            try
            {
                target.GetValueBool();
                throw new Exception("GetValueBool should throw exception");
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetValueString_ValidString_ReturnsString()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.String;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);
            string expected = "1";
            string actual = target.GetValueString();
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueString_NotStringType_ThrowsException()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Bool;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);

            try
            {
                target.SetValueString("test");
                throw new Exception("SetValueString should throw exception");
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueInt_NotIntType_ThrowsException()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Bool;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);

            try
            {
                target.SetValueInt(1);
                throw new Exception("SetValueInt should throw exception");
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueBool_NotBoolType_ThrowsException()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Int;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);

            try
            {
                target.SetValueBool(true);
                throw new Exception("SetValueBool should throw exception");
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetRawValue_ValidString_ReturnsString()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.String;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);
            Assert.AreEqual(value, target.GetRawValue());
        }

        /// <summary>
        ///A test for GetValueInt
        ///</summary>
        [TestMethod()]
        public void GetValueString_InvalidString_ThrowsException()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "1";
            SiteOption.SiteOptionType type = SiteOption.SiteOptionType.Bool;
            string description = string.Empty;
            SiteOption target = new SiteOption(siteId, section, name, value, type, description);

            try
            {
                target.GetValueString();
                throw new Exception("GetValueString should throw exception");
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }


        /// <summary>
        ///A test for SiteOption Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionConstructor_InvalidBoolType_ThrowsException()
        {
            int siteId = 0;
            string section = string.Empty;
            string name = string.Empty;
            string value = "5";
            string description = string.Empty;
            try
            {
                new SiteOption(siteId, section, name, value, SiteOption.SiteOptionType.Bool, description);
                throw new Exception("new SiteOption should throw exception");
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }
        
    }
}