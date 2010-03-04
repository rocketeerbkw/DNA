using System;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using System.Transactions;
using System.Configuration;
using TestUtils;

namespace TheGuide.Database.UnitTests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class GetAllPostingStatsBasicTests
    {
        public GetAllPostingStatsBasicTests()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
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

        private string _connectionDetails;

        [TestMethod]
        public void GetAllPostingStatsBasic_CheckSiteSuffixForUserWithNoSiteSuffix_ExpectNull()
        {
            using (new TransactionScope())
            {
                int userID = TestUserAccounts.GetEditorUserAccount.UserID;
                PostAndGetAllPostingStatsBasic(userID, "");
            }
        }

        [TestMethod]
        public void GetAllPostingStatsBasic_CheckSiteSuffixForUserWithSiteSuffix_ExpectNonNull()
        {
            using (new TransactionScope())
            {
                int userID = TestUserAccounts.GetEditorUserAccount.UserID;
                string siteSuffix = TestUserAccounts.GetEditorUserAccount.UserName + " - SiteSuffix";
                
                StringBuilder sql2 = new StringBuilder("UPDATE Preferences SET SiteSuffix = '" + siteSuffix + "' WHERE UserID = " + userID.ToString() + " AND SiteID = 1;");
                sql2.AppendLine("SELECT * FROM Preferences WHERE UserID = " + userID.ToString() + " AND SiteID = 1;");
                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(sql2.ToString());
                    if (reader.Read() && reader.HasRows)
                    {
                        string s = reader.GetStringNullAsEmpty("SiteSuffix");
                        s += "";
                    }
                }
                PostAndGetAllPostingStatsBasic(userID, siteSuffix);
            }
        }

        private void PostAndGetAllPostingStatsBasic(int userID, string siteSuffix)
        {

            StringBuilder sql = new StringBuilder("DECLARE @myid uniqueidentifier;");
            sql.AppendLine("SET @myid = NEWID();");
            sql.AppendLine("exec posttoforum 1090558353, 7619030, " + userID.ToString() + ", 1, 'test', 'this is the posting', 2, @myid;");
            using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
            {
                reader.ExecuteDEBUGONLY(sql.ToString());
            }

            using (IDnaDataReader reader = StoredProcedureReader.Create("getalluserpostingstatsbasic", _connectionDetails))
            {
                reader.AddParameter("userid", userID.ToString());
                reader.AddParameter("maxresults", "1");
                reader.AddParameter("siteid", "1");
                try
                {
                    reader.Execute();
                }
                catch (DataException ex)
                {
                    Assert.Fail(ex.Message);
                }
                catch (Exception e)
                {
                    Assert.Fail(e.Message);
                }

                Assert.IsTrue(reader.HasRows, "Failed to find expected result set from storedprocedure call");
                Assert.IsTrue(reader.Read(), "Failed to read anything from the procedurte!");
                Assert.AreEqual(siteSuffix, reader.GetStringNullAsEmpty("sitesuffix"), "The users sitesuffix should be " + siteSuffix + "!");
            }
        }
    }
}
