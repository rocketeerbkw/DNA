using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Data;
using TestUtils.Mocks.Extentions;
using System.Collections.Generic;

namespace BBC.Dna.Moderation.Tests
{
    /// <summary>
    /// Summary description for EMailTemplatesTests
    /// </summary>
    [TestClass]
    public class EMailTemplatesTests
    {
        public EMailTemplatesTests()
        {
            testTemplateData.Add(new EmailTemplate() { ModClassID = 1, AutoFormat = 0, EmailTemplateID = 1, Name = "Complaints", Subject = "Complaints Email", Body = "This is an email about complaints" });
            testTemplateData.Add(new EmailTemplate() { ModClassID = 1, AutoFormat = 0, EmailTemplateID = 2, Name = "Profanities", Subject = "Profanities Email", Body = "This is an email about profanities" });
            testTemplateData.Add(new EmailTemplate() { ModClassID = 1, AutoFormat = 0, EmailTemplateID = 3, Name = "Spam", Subject = "Spam Email", Body = "This is an email about spamming" });
            testTemplateData.Add(new EmailTemplate() { ModClassID = 2, AutoFormat = 0, EmailTemplateID = 4, Name = "Complaints", Subject = "Complaints Email", Body = "This is an email about complaints" });
            testTemplateData.Add(new EmailTemplate() { ModClassID = 2, AutoFormat = 0, EmailTemplateID = 5, Name = "Profanities", Subject = "Profanities Email", Body = "This is an email about profanities" });
            testTemplateData.Add(new EmailTemplate() { ModClassID = 2, AutoFormat = 0, EmailTemplateID = 6, Name = "Spam", Subject = "Spam Email", Body = "This is an email about spamming" });
        }

        private List<EmailTemplate> testTemplateData = new List<EmailTemplate>();
        private MockRepository mocks= new MockRepository();
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

        [TestMethod]
        public void EmailTemplates_GetEmailTemplatesForSite_ExpectTemplatesForSite()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator readerCreator;
            string procName = "getemailtemplatesbysiteid";
            List<DataReaderFactory.TestDatabaseRow> testData = new List<DataReaderFactory.TestDatabaseRow>();
            testData.Add(new TestEmailTemplateDataRow(1, false, 1, "Complaints", "Complaints Email", "This is an email about complaints"));
            testData.Add(new TestEmailTemplateDataRow(1, false, 2, "Profanities", "Profanities Email", "This is an email about profanities"));
            testData.Add(new TestEmailTemplateDataRow(1, false, 3, "Spam", "Spam Email", "This is an email about spamming"));
            DataReaderFactory.CreateMockedDataBaseObjects(mocks, procName, out readerCreator, out reader, testData);

            EmailTemplates templates = EmailTemplates.GetEmailTemplates(readerCreator, EmailTemplateTypes.SiteTemplates, 1);

            Assert.IsNotNull(templates.EmailTemplatesList);
            Assert.AreEqual(3, templates.EmailTemplatesList.Count);
        }

        [TestMethod]
        public void EmailTemplates_GetEmailTemplatesForModClass_ExpectTemplatesForModClass()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator readerCreator;
            string procName = "getemailtemplatesbymodclassid";
            List<DataReaderFactory.TestDatabaseRow> testData = new List<DataReaderFactory.TestDatabaseRow>();
            testData.Add(new TestEmailTemplateDataRow(2, false, 4, "Complaints", "Complaints Email", "This is an email about complaints"));
            testData.Add(new TestEmailTemplateDataRow(2, false, 5, "Profanities", "Profanities Email", "This is an email about profanities"));
            testData.Add(new TestEmailTemplateDataRow(2, false, 6, "Spam", "Spam Email", "This is an email about spamming"));
            DataReaderFactory.CreateMockedDataBaseObjects(mocks, procName, out readerCreator, out reader, testData);

            EmailTemplates templates = EmailTemplates.GetEmailTemplates(readerCreator, EmailTemplateTypes.ClassTemplates, 2);

            Assert.IsNotNull(templates.EmailTemplatesList);
            Assert.AreEqual(3, templates.EmailTemplatesList.Count);
        }

        [TestMethod]
        public void EmailTemplates_GetEmailTemplatesForAllClasses_ExpectTemplatesForAllClasses()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator readerCreator;
            string procName = "getemailtemplatesbymodclassid";
            List<DataReaderFactory.TestDatabaseRow> testData = new List<DataReaderFactory.TestDatabaseRow>();
            testData.Add(new TestEmailTemplateDataRow(1, false, 1, "Complaints", "Complaints Email", "This is an email about complaints"));
            testData.Add(new TestEmailTemplateDataRow(1, false, 2, "Profanities", "Profanities Email", "This is an email about profanities"));
            testData.Add(new TestEmailTemplateDataRow(1, false, 3, "Spam", "Spam Email", "This is an email about spamming"));
            testData.Add(new TestEmailTemplateDataRow(2, false, 4, "Complaints", "Complaints Email", "This is an email about complaints"));
            testData.Add(new TestEmailTemplateDataRow(2, false, 5, "Profanities", "Profanities Email", "This is an email about profanities"));
            testData.Add(new TestEmailTemplateDataRow(2, false, 6, "Spam", "Spam Email", "This is an email about spamming"));
            DataReaderFactory.CreateMockedDataBaseObjects(mocks, procName, out readerCreator, out reader, testData);

            EmailTemplates templates = EmailTemplates.GetEmailTemplates(readerCreator, EmailTemplateTypes.AllTemplates, -1);

            Assert.IsNotNull(templates.EmailTemplatesList);
            Assert.AreEqual(6, templates.EmailTemplatesList.Count);
        }
    }

    public class TestEmailTemplateDataRow : DataReaderFactory.TestDatabaseRow
    {
        public TestEmailTemplateDataRow(int modClassID, bool autoFormat, int templateID, string name, string subject, string body)
        {
            AddGetInt32ColumnValue("ModClassID", modClassID);
            AddIsDBNullCheck("AutoFormat", false);
            AddGetBooleanColumnValue("AutoFormat", autoFormat);
            AddGetInt32ColumnValue("EmailTemplateID", templateID);
            AddGetStringColumnValue("Name",name);
            AddGetStringColumnValue("Subject", subject);
            AddGetStringColumnValue("Body", body);
        }
    }
}
