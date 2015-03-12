using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Configuration;
using BBC.Dna.Data;
using BBC.Dna;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Rhino.Mocks;

namespace Tests
{
    /// <summary>
    /// Summary description for DnaMessageTests
    /// </summary>
    [TestClass]
    public class DnaMessageTests
    {
        /// <summary>
        /// 
        /// </summary>
        public DnaMessageTests()
        {
            ConnectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

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

        string ConnectionDetails { get; set; }

        private readonly MockRepository _mocks = new MockRepository();

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void SendEmailViaDatabaseWithValidData_CorrectDataInEmailQueue()
        {
            string toAddress = "to.me@bbc.co.uk";
            string fromAddress = "from.me@bbc.co.uk";
            string ccAddress = "cc.ing@bbc.co.uk";
            string body = "Testing that we put emails correctly in the database";
            string subject = "Database queued email";
            int siteId = 1;

            IInputContext context = _mocks.DynamicMock<IInputContext>();
            IDnaDiagnostics diagnostics = _mocks.DynamicMock<IDnaDiagnostics>();
            ISiteList siteList = _mocks.DynamicMock<ISiteList>();
            IDnaDataReaderCreator dataReaderCreator = _mocks.DynamicMock<IDnaDataReaderCreator>();

            context.Stub(x => x.Diagnostics).Return(diagnostics);
            context.Stub(x => x.TheSiteList).Return(siteList);
            context.Stub(x => x.CreateDnaDataReaderCreator()).Return(dataReaderCreator);

            diagnostics.Stub(x => x.WriteExceptionToLog(null));

            siteList.Stub(x => x.GetSiteOptionValueBool(siteId, "General", "UseSystemMessages")).Return(false);
            siteList.Stub(x => x.GetSiteOptionValueBool(siteId, "General", "RTLSite")).Return(false);

            using (IDnaDataReader firstReader = StoredProcedureReader.Create("QueueEmail", ConnectionDetails))
            {
                dataReaderCreator.Stub(x => x.CreateDnaDataReader("QueueEmail")).Return(firstReader);

                _mocks.ReplayAll();

                DnaMessage message = new DnaMessage(context);
                message.SendEmailOrSystemMessage(0, toAddress, fromAddress, ccAddress, siteId, subject, body);
            }

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                reader.ExecuteDEBUGONLY(@"EXEC getemailbatchtosend 2");
                if (reader.Read() && reader.HasRows)
                {
                    Assert.AreEqual(toAddress, reader.GetString("ToEmailAddress"));
                    Assert.AreEqual(fromAddress, reader.GetString("FromEmailAddress"));
                    Assert.AreEqual(ccAddress, reader.GetString("CCAddress"));
                    Assert.AreEqual(body, reader.GetString("body"));
                    Assert.AreEqual(subject, reader.GetString("subject"));
                }
                reader.Close();
            }
        }
    }
}
