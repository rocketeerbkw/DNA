using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System.Configuration;
using BBC.Dna.Data;
using System.Collections.Generic;
using Rhino.Mocks;
using TestUtils;
using Tests;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for SiteOptionTest and is intended
    ///to contain all SiteOptionTest Unit Tests
    ///</summary>
    [TestClass]
    public class SiteOptionTest
    {
        private readonly MockRepository _mocks = new MockRepository();

        [TestInitialize]
        public void TestStartup()
        {
            SnapshotInitialisation.ForceRestore();
        }

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

        [TestMethod]
        public void ShouldUpdateSiteOptionsWithValidUpdateOption()
        {
            IDnaDataReaderCreator readerCreator;
            SetupDataBaseMockedDataReaderCreator(out readerCreator);

            string section = "General";
            string name = "SiteIsPrivate";
            string description = "If true, this site's content won't get pulled out on lists in any other site";
            int siteID = 1;
            int changeToValue = GetValueForGivenSiteOptionAssertFail(readerCreator, section, name, siteID, true) == 1 ? 0 : 1;

            SiteOption siteOption = new SiteOption(siteID, section, name, changeToValue.ToString(), SiteOption.SiteOptionType.Bool, description);
            List<SiteOption> updatedSiteoptions = new List<SiteOption>();
            updatedSiteoptions.Add(siteOption);

            SiteOption.UpdateSiteOptions(updatedSiteoptions, readerCreator);
            int storedValue = GetValueForGivenSiteOptionAssertFail(readerCreator, section, name, siteID, true);

            Assert.AreEqual(changeToValue, storedValue);
        }

        [TestMethod]
        public void ShouldRemoveSiteOptionForSite()
        {
            IDnaDataReaderCreator readerCreator;
            SetupDataBaseMockedDataReaderCreator(out readerCreator);

            string section = "General";
            string name = "IsURLFiltered";
            string description = "Set if this site is to be url filtered";
            int siteID = 1;
            
            // Check the option exists first
            GetValueForGivenSiteOptionAssertFail(readerCreator, section, name, siteID, true);
            
            SiteOption siteOption = new SiteOption(siteID, section, name, "0", SiteOption.SiteOptionType.Bool, description);
            SiteOption.RemoveSiteOptionFromSite(siteOption, siteID, readerCreator);
            GetValueForTheSpecificSiteSiteOptionAssertFail(readerCreator, section, name, siteID, false);
        }

        [TestMethod]
        public void ShouldRemoveSiteOptionWhenNewSettingMatchesDefault()
        {
            IDnaDataReaderCreator readerCreator;
            SetupDataBaseMockedDataReaderCreator(out readerCreator);

            string section = "General";
            string name = "IsMessageboard";
            string description = "Set if this site is a messageboard";
            int siteID = 1;

            UpdateBooleanSiteOption(siteID, section, name, "1", description);
            GetValueForTheSpecificSiteSiteOptionAssertFail(readerCreator, section, name, siteID, true);

            UpdateBooleanSiteOption(siteID, section, name, "0", description);
            GetValueForTheSpecificSiteSiteOptionAssertFail(readerCreator, section, name, siteID, false);
            GetValueForGivenSiteOptionAssertFail(readerCreator, section, name, siteID, true);
        }

        private void UpdateBooleanSiteOption(int siteID, string section, string name, string value, string description)
        {
            IDnaDataReaderCreator readerCreator;
            SetupDataBaseMockedDataReaderCreator(out readerCreator);

            SiteOption updatedSiteOption = new SiteOption(siteID, section, name, value, SiteOption.SiteOptionType.Bool, description);
            List<SiteOption> updatedSiteoptions = new List<SiteOption>();
            updatedSiteoptions.Add(updatedSiteOption);
            SiteOption.UpdateSiteOptions(updatedSiteoptions, readerCreator);
        }

        private static int GetValueForGivenSiteOptionAssertFail(IDnaDataReaderCreator readerCreator, string section, string name, int siteID, bool expectResults)
        {
            string sql = "SELECT dbo.udf_getsiteoptionsetting(" + siteID + ", '" + section + "', '" + name + "') AS value";
            return GetSiteOptionSetting(readerCreator, expectResults, sql);
        }

        private static int GetValueForTheSpecificSiteSiteOptionAssertFail(IDnaDataReaderCreator readerCreator, string section, string name, int siteID, bool expectResults)
        {
            string sql = "SELECT * FROM SiteOptions WHERE Section='" + section + "' AND Name='" + name + "' AND SiteID=" + siteID;
            return GetSiteOptionSetting(readerCreator, expectResults, sql);
        }

        private static int GetSiteOptionSetting(IDnaDataReaderCreator readerCreator, bool expectResults, string sql){
            int value = -1;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(sql);
                if (expectResults)
                {
                    Assert.IsTrue(reader.HasRows, "Failed to find site option");
                    Assert.IsTrue(reader.Read(), "Failed to read data from database query");
                    value = reader.GetTinyIntAsInt("value");
                }
                else
                {
                    Assert.IsFalse(reader.HasRows, "Should not have any rows!");
                }
            }
            return value;
        }

        private static int GetValueForGivenSiteOption(IDnaDataReaderCreator readerCreator, string section, string name, int siteID)
        {
            int value = -1;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM SiteOptions WHERE Section='" + section + "' AND Name='" + name + "' AND SiteID=" + siteID;
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.HasRows, "Failed to find site option");
                Assert.IsTrue(reader.Read(), "Failed to read data from database query");
                value = reader.GetTinyIntAsInt("value");
            }
            return value;
        }

        private void SetupDataBaseMockedDataReaderCreator(out IDnaDataReaderCreator readerCreator)
        {
            IDnaDiagnostics mockedDiagnostics = _mocks.DynamicMock<IDnaDiagnostics>();
            string connectionString = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
            readerCreator = new DnaDataReaderCreator(connectionString, mockedDiagnostics);
        }
    }
}