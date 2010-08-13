using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test class for testing the CreateNewUser procedure
    /// </summary>
    [TestClass]
    public class CreateNewUserProcedureTests
    {
        /// <summary>
        /// Check to make sure that a user is correctly set when created in a site with auto sin bin set
        /// </summary>
        [TestMethod]
        public void TestUserIsCreatedCorrectlyForSIteWithAutoSinBin()
        {
            Console.WriteLine("Before CreateNewUserProcedureTests - TestUserIsCreatedCorrectlyForSIteWithAutoSinBin");

            // Restore the database
            SnapshotInitialisation.RestoreFromSnapshot();

            // Create a context that will provide us with real data reader support
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to set the autosinbin flag
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("setsiteoption"))
            {
                // Set users in h2g2 to be premodded for a day
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PreModDuration");
                reader.AddParameter("Value", "1440");
                reader.Execute();
            }

            // Create a new user in the database for h2g2
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("createnewuserfromssoid"))
            {
                reader.AddParameter("ssouserid", Int32.MaxValue - 2300000);
                reader.AddParameter("UserName", "TestUser");
                reader.AddParameter("Email", "a@b.c");
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("FirstNames", "MR");
                reader.AddParameter("LastName", "TESTER");
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "Creating a new user returned no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");

                // Now check the values comming back from the database
                Assert.AreNotEqual(0, reader.GetInt32("UserID"), "UserId is 0");
                Assert.AreEqual("TestUser", reader.GetString("LoginName"), "Users login name does not match the one entered");
                Assert.AreEqual("TestUser", reader.GetString("UserName"), "Users name does not match the one entered");
                //**************************************************************************************
                // SPF 3/12/09 Due to the removal of First Names Last Name due to legal issues,
                // the First Names and Last Name will be NULL
                //**************************************************************************************
                Assert.IsTrue(reader.IsDBNull("FirstNames"), "Users first name is not NULL");
                Assert.IsTrue(reader.IsDBNull("LastName"), "The users last name is not NULL");
                // *************************************************************************************
                Assert.AreEqual("a@b.c", reader.GetString("Email"), "The users email does not match the one entered");

                // Here are the important ones for this test
                Assert.IsTrue(reader.GetDateTime("DateJoined") > DateTime.Now.AddMinutes(-1), "The users date joined value is not with in the tolarences of this test!");
                Assert.AreEqual(1, reader.GetTinyIntAsInt("AutoSinBin"), "The user should be in the auto sin bin!");
                Assert.AreEqual(1, reader.GetTinyIntAsInt("Status"), "The user status is not correct");
                Assert.AreEqual(0, reader.GetTinyIntAsInt("PrefStatus"), "The user pref status is not correct");
            }

            // Now revert back to no pre mod duration for h2g2
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("deletesiteoption"))
            {
                // Set users in h2g2 to be premodded for a day
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PreModDuration");
                reader.Execute();
            }
        }
        
        /// <summary>
        /// Check to make sure that a user is correctly set when created in a site with auto sin bin disabled
        /// </summary>
        [TestMethod]
        public void TestUserIsCreatedCorrectlyForSiteWithAutoSinBinDisabled()
        {
            Console.WriteLine("Before TestUserIsCreatedCorrectlyForSiteWithAutoSinBinDisabled");

            // Restore the database
            SnapshotInitialisation.RestoreFromSnapshot();

            // Create a context that will provide us with real data reader support
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to ensure the autosinbin feature is diabled
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("deletesiteoption"))
            {
                // Set users in h2g2 to be premodded for a day
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PreModDuration");
                reader.Execute();
            }

            // Create a new user in the database for h2g2
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("createnewuserfromssoid"))
            {
                reader.AddParameter("ssouserid", Int32.MaxValue - 3200000);
                reader.AddParameter("UserName", "TestUser");
                reader.AddParameter("Email", "a@b.c");
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("FirstNames", "MR");
                reader.AddParameter("LastName", "TESTER");
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "Creating a new user returned no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");

                // Now check the values comming back from the database
                Assert.AreNotEqual(0, reader.GetInt32("UserID"), "UserId is 0");
                Assert.AreEqual("TestUser", reader.GetString("LoginName"), "Users login name does not match the one entered");
                Assert.AreEqual("TestUser", reader.GetString("UserName"), "Users name does not match the one entered");
                //**************************************************************************************
                // SPF 3/12/09 Due to the removal of First Names Last Name due to legal issues,
                // the First Names and Last Name will be NULL
                //**************************************************************************************
                Assert.IsTrue(reader.IsDBNull("FirstNames"), "Users first name is not NULL");
                Assert.IsTrue(reader.IsDBNull("LastName"), "The users last name is not NULL");
                // *************************************************************************************
                Assert.AreEqual("a@b.c", reader.GetString("Email"), "The users email does not match the one entered");

                // Here are the important ones for this test
                Assert.IsTrue(reader.GetDateTime("DateJoined") > DateTime.Now.AddMinutes(-1), "The users date joined value is not with in the tolarences of this test!");
                Assert.AreEqual(0, reader.GetTinyIntAsInt("AutoSinBin"), "The user should be in the auto sin bin!");
                Assert.AreEqual(1, reader.GetTinyIntAsInt("Status"), "The user status is not correct");
                Assert.AreEqual(0, reader.GetTinyIntAsInt("PrefStatus"), "The user pref status is not correct");
            }
        }

        /// <summary>
        /// Check to make sure that existing sso accounts get migrated correctly
        /// </summary>
        [TestMethod]
        public void TestMigrationOfSSOUsersToIdentity()
        {
            Console.WriteLine("Before TestMigrationOfSSOUsersToIdentity");

            // Restore the database
            SnapshotInitialisation.RestoreFromSnapshot();

            // Create a context that will provide us with real data reader support
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

            // setup the test data
            int ssoUserID = 123456789;
            string identityUserID = "987654321";
            int dnaUserID = 0;

            // Simulate a new user signing into dna via SSO
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("createnewuserfromssoid"))
            {
                reader.AddParameter("ssouserid", ssoUserID);
                reader.AddParameter("UserName", "TestUser");
                reader.AddParameter("Email", "a@b.c");
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("FirstNames", "MR");
                reader.AddParameter("LastName", "TESTER");
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "Creating a new user returned no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");

                // Get the new DNAUserID
                dnaUserID = reader.GetInt32("UserID");

                // Now check the values comming back from the database
                Assert.AreEqual("TestUser", reader.GetString("LoginName"), "Users login name does not match the one entered");
                Assert.AreEqual("TestUser", reader.GetString("UserName"), "Users name does not match the one entered");
                //**************************************************************************************
                // SPF 3/12/09 Due to the removal of First Names Last Name due to legal issues,
                // the First Names and Last Name will be NULL
                //**************************************************************************************
                Assert.IsTrue(reader.IsDBNull("FirstNames"), "Users first name is not NULL");
                Assert.IsTrue(reader.IsDBNull("LastName"), "The users last name is not NULL");
                // *************************************************************************************
                Assert.AreEqual("a@b.c", reader.GetString("Email"), "The users email does not match the one entered");
            }

            // Now simulate the existing sso user signing into dna via identity
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("createnewuserfromidentityid"))
            {
                reader.AddParameter("identityuserid", identityUserID);
                reader.AddParameter("legacyssoid", ssoUserID);
                reader.AddParameter("UserName", "TestUser");
                reader.AddParameter("Email", "a@b.c");
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("FirstNames", "MR");
                reader.AddParameter("LastName", "TESTER");
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "Creating a new user returned no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");

                // Get the new DNAUserID
                int newDnaUserID = reader.GetInt32("UserID");

                // Now check the values comming back from the database
                Assert.AreEqual(dnaUserID, newDnaUserID, "The user should have the same DNA UserID as they did when they signed in via SSO");
                Assert.AreEqual("TestUser", reader.GetString("LoginName"), "Users login name does not match the one entered");
                Assert.AreEqual("TestUser", reader.GetString("UserName"), "Users name does not match the one entered");
                //**************************************************************************************
                // SPF 3/12/09 Due to the removal of First Names Last Name due to legal issues,
                // the First Names and Last Name will be NULL
                //**************************************************************************************
                Assert.IsTrue(reader.IsDBNull("FirstNames"), "Users first name is not NULL");
                Assert.IsTrue(reader.IsDBNull("LastName"), "The users last name is not NULL");
                // *************************************************************************************
                Assert.AreEqual("a@b.c", reader.GetString("Email"), "The users email does not match the one entered");
            }
        }
    }
}
