using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using TestUtils;
using BBC.Dna.Data;
using System.Data;
using System.Configuration;

namespace TheGuide.Database.UnitTests
{
    /// <summary>
    /// Summary description for GetUserCommentsStatsTests
    /// </summary>
    [TestClass]
    public class GetUserCommentsStatsTests
    {
        public GetUserCommentsStatsTests()
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
        public void GetThreadPostContentsTests_CheckSiteSuffixForUserWithNoSiteSuffix_ExpectNull()
        {
            using (new TransactionScope())
            {
                int userID = TestUserAccounts.GetEditorUserAccount.UserID;
                using (IDnaDataReader reader = StoredProcedureReader.Create("GetUserCommentsStats", _connectionDetails))
                {
                    reader.AddParameter("userid", userID.ToString());
                    reader.AddParameter("siteid", 1);
                    reader.AddParameter("firstindex", 0);
                    reader.AddParameter("lastindex", 10);
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
                    while (reader.Read())
                    {
                        Assert.AreEqual("", reader.GetStringNullAsEmpty("sitesuffix"), "The users sitesuffix should be empty!");
                    }
                }
            }
        }

        [TestMethod]
        public void GetThreadPostContentsTests_CheckSiteSuffixForUserWithSiteSuffix_ExpectNonNull()
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
                    Assert.IsTrue(reader.Read() && reader.HasRows);
                    Assert.AreEqual(siteSuffix, reader.GetStringNullAsEmpty("SiteSuffix"));
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("GetUserCommentsStats", _connectionDetails))
                {
                    reader.AddParameter("userid", userID.ToString());
                    reader.AddParameter("siteid", 1);
                    reader.AddParameter("firstindex", 0);
                    reader.AddParameter("lastindex", 10);
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
                    bool testedNonh2g2Site = false;
                    while (reader.Read())
                    {
                        if (reader.GetInt32("SiteID") > 1)
                        {
                            testedNonh2g2Site = true;
                        }
                        Assert.AreEqual(siteSuffix, reader.GetStringNullAsEmpty("sitesuffix"), "The users sitesuffix should be " + siteSuffix + "!");
                    }

                    Assert.IsTrue(testedNonh2g2Site, "Failed to test a non h2g2 site for site suffixes!");
                }
            }
        }
    }
}
