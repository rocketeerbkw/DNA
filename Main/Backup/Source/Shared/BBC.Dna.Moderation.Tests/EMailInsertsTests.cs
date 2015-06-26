using System.Collections.Generic;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using TestUtils.Mocks.Extentions;

namespace BBC.Dna.Moderation.Tests
{
    /// <summary>
    /// Summary description for EMailInsertsTests
    /// </summary>
    [TestClass]
    public class EMailInsertsTests
    {
        public EMailInsertsTests()
        {
            mocks = new MockRepository();
            _testInserts.Add(new EmailInsert() { ClassID = 1, ID = 1, Name = "AdvertInsert", DisplayName = "Advertising", Group = "House Rules", SiteID = 1, DefaultText = "Default class based advertising insert", InsertText = "Site based override advertising insert" });
            _testInserts.Add(new EmailInsert() { ClassID = 1, ID = 2, Name = "CopyrightInsert", DisplayName = "Copyright Material", Group = "House Rules", SiteID = 1, DefaultText = "Default class based copyright insert", InsertText = "Site based override copyright insert" });
            _testInserts.Add(new EmailInsert() { ClassID = 1, ID = 3, Name = "OffensiveInsert", DisplayName = "Offensive", Group = "House Rules", SiteID = 1, DefaultText = "Default class base offensive insert", InsertText = "Site based override offensive insert" });
            _testInserts.Add(new EmailInsert() { ClassID = 1, ID = 4, Name = "ComplaintInsert", DisplayName = "Complaint", Group = "House Rules", SiteID = 1, DefaultText = "Default class base complaint insert", InsertText = "Site based complaint insert" });
        }

        private MockRepository mocks;

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        private List<EmailInsert> _testInserts = new List<EmailInsert>();

        [TestMethod]
        public void EmailInserts_CreateInsertListForModClass_ExpectEmailInsertListForModClass()
        {
            string procName = "getemailinsertsbyclass";
            int modClassID = 10;
            int siteID = 0;
            IDnaDataReader reader;
            IDnaDataReaderCreator readerCreator;

            List<DataReaderFactory.TestDatabaseRow> testDatat = new List<DataReaderFactory.TestDatabaseRow>();
            testDatat.Add(new EmailInsertsDataReaderRow(1, "AdvertInsert", "Advertising", "House Rules", siteID, "Default class based advertising insert", "", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(2, "CopyrightInsert", "Copyright Material", "House Rules", siteID, "Default class based copyright insert", "", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(3, "OffensiveInsert", "Offensive", "House Rules", siteID, "Default class base offensive insert", "", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(4, "ComplaintInsert", "Complaint", "House Rules", siteID, "Default class base complaint insert", "", modClassID));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, procName, out readerCreator, out reader, testDatat);

            EmailInserts emailInserts = EmailInserts.GetEmailInserts(readerCreator, EmailTemplateTypes.ClassTemplates, 1);
            TestExpectedResults(modClassID, siteID, emailInserts,false);
        }

        [TestMethod]
        public void EmailInserts_CreateInsertListForSiteWithSiteOverridesOnly_ExpectEmailInsertListForSiteWithSiteOverridesOnly()
        {
            string procName = "getemailinsertsbysite2";
            int modClassID = 4;
            int siteID = 5;
            IDnaDataReader reader;
            IDnaDataReaderCreator readerCreator;
            List<DataReaderFactory.TestDatabaseRow> testDatat = new List<DataReaderFactory.TestDatabaseRow>();
            testDatat.Add(new EmailInsertsDataReaderRow(1, "AdvertInsert", "Advertising", "House Rules", siteID, "Default class based advertising insert", "Site based override advertising insert", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(2, "CopyrightInsert", "Copyright Material", "House Rules", siteID, "Default class based copyright insert", "Site based override copyright insert", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(3, "OffensiveInsert", "Offensive", "House Rules", siteID, "Default class base offensive insert", "Site based override offensive insert", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(4, "ComplaintInsert", "Complaint", "House Rules", siteID, "Default class base complaint insert", "Site based complaint insert", modClassID));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, procName, out readerCreator, out reader, testDatat);

            EmailInserts emailInserts = EmailInserts.GetEmailInserts(readerCreator, EmailTemplateTypes.SiteTemplates, 1);
            TestExpectedResults(modClassID, siteID, emailInserts, true);
        }

        [TestMethod]
        public void EmailInserts_CreateInsertListForSiteWithDefaultAndSiteOverrides_ExpectEmailInsertListForSiteWithDefaultAndSiteOverrides()
        {
            string procName = "getemailinsertsbysite2";
            int modClassID = 4;
            int siteID = 5;
            IDnaDataReader reader;
            IDnaDataReaderCreator readerCreator;
            List<DataReaderFactory.TestDatabaseRow> testDatat = new List<DataReaderFactory.TestDatabaseRow>();
            testDatat.Add(new EmailInsertsDataReaderRow(1, "AdvertInsert", "Advertising", "House Rules", siteID, "Default class based advertising insert", "Site based override advertising insert", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(2, "CopyrightInsert", "Copyright Material", "House Rules", 0, "Default class based copyright insert", "", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(3, "OffensiveInsert", "Offensive", "House Rules", siteID, "Default class base offensive insert", "Site based override offensive insert", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(4, "ComplaintInsert", "Complaint", "House Rules", 0, "Default class base complaint insert", "", modClassID));
            DataReaderFactory.CreateMockedDataBaseObjects(mocks, procName, out readerCreator, out reader, testDatat);

            EmailInserts emailInserts = EmailInserts.GetEmailInserts(readerCreator, EmailTemplateTypes.SiteTemplates, 1);
            Assert.IsNotNull(emailInserts, "Failed to create email inserts");
            Assert.IsNotNull(emailInserts.EmailInsertList, "Email inserts list is null");
            Assert.IsTrue(emailInserts.EmailInsertList.Count > 0, "No email inserts found in list");

            int i = 0;
            foreach (EmailInsert insert in emailInserts.EmailInsertList)
            {
                Assert.AreEqual(modClassID, insert.ClassID);
                if (i % 2 == 1)
                {
                    Assert.AreEqual(0, insert.SiteID);
                    Assert.AreEqual("", insert.InsertText);
                }
                else
                {
                    Assert.AreEqual(siteID, insert.SiteID);
                    Assert.AreEqual(_testInserts[i].InsertText, insert.InsertText);
                }
                Assert.AreEqual(_testInserts[i].ID, insert.ID);
                Assert.AreEqual(_testInserts[i].Name, insert.Name);
                Assert.AreEqual(_testInserts[i].DisplayName, insert.DisplayName);
                Assert.AreEqual(_testInserts[i].DefaultText, insert.DefaultText);
                
                i++;
            }
        }

        [TestMethod]
        public void EmailInserts_CreateInsertListForAllGeneralTemplates_ExpectEmailInsertListForAllGeneralTemplates()
        {
            string procName = "getemailinsertsbyclass";
            IDnaDataReader reader;
            IDnaDataReaderCreator readerCreator;
            int modClassID = 4;
            int siteID = 0;

            List<DataReaderFactory.TestDatabaseRow> testDatat = new List<DataReaderFactory.TestDatabaseRow>();
            testDatat.Add(new EmailInsertsDataReaderRow(1, "AdvertInsert", "Advertising", "House Rules", siteID, "Default class based advertising insert", "", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(2, "CopyrightInsert", "Copyright Material", "House Rules", siteID, "Default class based copyright insert", "", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(3, "OffensiveInsert", "Offensive", "House Rules", siteID, "Default class base offensive insert", "", modClassID));
            testDatat.Add(new EmailInsertsDataReaderRow(4, "ComplaintInsert", "Complaint", "House Rules", siteID, "Default class base complaint insert", "", modClassID));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, procName, out readerCreator, out reader, testDatat);

            EmailInserts emailInserts = EmailInserts.GetEmailInserts(readerCreator, EmailTemplateTypes.AllTemplates, 0);
            TestExpectedResults(modClassID, siteID, emailInserts, false);
        }

        private void TestExpectedResults(int modClassID, int siteID, EmailInserts emailInserts, bool insertText)
        {
            Assert.IsNotNull(emailInserts, "Failed to create email inserts");
            Assert.IsNotNull(emailInserts.EmailInsertList, "Email inserts list is null");
            Assert.IsTrue(emailInserts.EmailInsertList.Count > 0, "No email inserts found in list");

            int i = 0;
            foreach (EmailInsert insert in emailInserts.EmailInsertList)
            {
                Assert.AreEqual(modClassID, insert.ClassID);
                Assert.AreEqual(siteID, insert.SiteID);
                Assert.AreEqual(_testInserts[i].ID, insert.ID);
                Assert.AreEqual(_testInserts[i].Name, insert.Name);
                Assert.AreEqual(_testInserts[i].DisplayName, insert.DisplayName);
                Assert.AreEqual(_testInserts[i].DefaultText, insert.DefaultText);
                if (insertText)
                {
                    Assert.AreEqual(_testInserts[i].InsertText, insert.InsertText);
                }
                else
                {
                    Assert.AreEqual("", insert.InsertText);
                }
                i++;
            }
        }
    }

    public class EmailInsertsDataReaderRow : DataReaderFactory.TestDatabaseRow
    {
        public EmailInsertsDataReaderRow(int emailInsertID, string insertName, string displayName, string insertGroup, int siteID, string defaultText, string insertText, int modClassID)
        {
            AddGetInt32ColumnValue("EmailInsertID", emailInsertID);
            AddGetStringColumnValue("InsertName", insertName);
            AddGetStringColumnValue("DisplayName", displayName);
            AddGetStringColumnValue("InsertGroup", insertGroup);
            AddIsDBNullCheck("SiteID", siteID == 0 ? true : false);
            if (siteID > 0)
            {
                AddGetInt32ColumnValue("SiteID", siteID);
            }
            AddGetStringColumnValue("DefaultText", defaultText);
            AddGetStringColumnValue("InsertText", insertText);
            AddGetInt32ColumnValue("ModClassID", modClassID);
        }
    }
}
