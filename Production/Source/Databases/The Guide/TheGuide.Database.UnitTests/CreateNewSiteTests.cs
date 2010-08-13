using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using BBC.Dna.Data;
using System.Configuration;

namespace TheGuide.Database.UnitTests
{
    /// <summary>
    /// Summary description for CreateNewSite
    /// </summary>
    [TestClass]
    public class CreateNewSite
    {
        public CreateNewSite()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        private string _connectionDetails;

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
        public void CreateSite_CreateNewSite_ExpectSiteID()
        {
            using (new TransactionScope())
            {
                int siteID = CreateNewTestSite();
                Assert.IsTrue(siteID > 0);
            }
        }

        [TestMethod]
        public void CreateSite_DefaultSkinSetToBoards_ExpectPrefSkinUserZeroToBeNULL()
        {
            using (new TransactionScope())
            {
                int siteID = CreateNewTestSite();
                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    string sql = "SELECT * FROM Preferences WHERE SiteID = " + siteID.ToString() + " AND UserID = 0";

                    reader.ExecuteDEBUGONLY(sql);
                    Assert.IsTrue(reader.HasRows);
                    Assert.IsTrue(reader.Read());
                    Assert.IsTrue(reader.IsDBNull("PrefSkin"));
                }
            }
        }

        private int CreateNewTestSite()
        {
            int siteID = 0;
            using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
            {
                string sql = "exec createnewsite 'mbtestnewsite', 'New Site', 'DNA TestSite', 'boards', 'boards skin', 'vanilla', 0, 0, 1, 0, 'mod@bbc.co.uk', 'editor@bbc.co.uk', 'feedback@bbc.co.uk', 123, 0, 1, 1, 1, 120, 'Event Email', 24, 1, 1, 'old sso service name', 0, 0, 0, 1, 'http://identity/policies/dna/adult'";
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.HasRows);
                Assert.IsTrue(reader.Read());
                Assert.IsTrue(reader.DoesFieldExist("SiteID"));
                siteID = reader.GetInt32("SiteID");
            }
            return siteID;
        }
    }
}
