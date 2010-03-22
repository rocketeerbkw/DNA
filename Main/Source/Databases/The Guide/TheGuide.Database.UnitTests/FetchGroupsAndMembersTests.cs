using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using TestUtils;
using BBC.Dna.Data;
using System.Configuration;

namespace TheGuide.Database.UnitTests
{
    /// <summary>
    /// Summary description for FetchGroupsAndMembersTests
    /// </summary>
    [TestClass]
    public class FetchGroupsAndMembersTests
    {
        public FetchGroupsAndMembersTests()
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
        public void FetchGroupsAndMembers_FetchGroupsAndMembersWithNullEntries_ExpectNoNullValues()
        {
            using (new TransactionScope())
            {
                StringBuilder sqlErrornousNUllValues = new StringBuilder("INSERT INTO GroupMembers SELECT UserID = NULL, GroupID = NULL, SiteID = NULL;");
                sqlErrornousNUllValues.AppendLine("INSERT INTO GroupMembers SELECT UserID = 123456789,  GroupID = NULL, SiteID = NULL;");
                sqlErrornousNUllValues.AppendLine("INSERT INTO GroupMembers SELECT UserID = NULL,       GroupID = 8,    SiteID = NULL;");
                sqlErrornousNUllValues.AppendLine("INSERT INTO GroupMembers SELECT UserID = NULL,       GroupID = NULL, SiteID = 1;");
                sqlErrornousNUllValues.AppendLine("INSERT INTO GroupMembers SELECT UserID = 123456789,  GroupID = 8,    SiteID = NULL;");
                sqlErrornousNUllValues.AppendLine("INSERT INTO GroupMembers SELECT UserID = NULL,       GroupID = 8,    SiteID = 1;");
                sqlErrornousNUllValues.AppendLine("INSERT INTO GroupMembers SELECT UserID = 123456789,  GroupID = NULL, SiteID = 1;");
                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(sqlErrornousNUllValues.ToString());
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("EXEC FetchGroupsAndMembers");
                    Assert.IsTrue(reader.HasRows, "Failed to get the groups and members!");
                    while (reader.Read())
                    {
                        int siteID = reader.GetInt32NullAsZero("siteid");
                        int userID = reader.GetInt32NullAsZero("userid");
                        int groupID = reader.GetInt32NullAsZero("groupid");
                        Assert.IsTrue(siteID > 0, "Found invalid siteid");
                        Assert.IsTrue(userID > 0, "Found invalid userid");
                        Assert.IsTrue(groupID > 0, "Found invalid groupid");
                    }
                }
            }
        }
    }
}
