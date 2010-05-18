using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace Tests
{
    /// <summary>
    /// Tests the PreModerated User Time Limit.
    /// Checks that the users status is updated on leaving the premoderated time limit.
    /// </summary>
    [TestClass]
    public class TimedPreModeratedUserTests
    {
        /// <summary>
        /// This checks to make sure that user that has been premoded for a set time period gets their prefstatus updated
        /// correctly when that time period is up.
        /// </summary>
        [TestMethod]
        public void TestUserTakenOutOfTimedPremod()
        {
            // Restore the database
            SnapshotInitialisation.ForceRestore();

            // Create a context capable for creating real data readers
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to set the autosinbin flag
            using (IDnaDataReader reader = context.CreateDnaDataReader("setsiteoption"))
            {
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PostCountThreshold");
                reader.AddParameter("Value", "0");
                reader.Execute();
            }

            // Not using premod timeout for this test.
            using (IDnaDataReader reader = context.CreateDnaDataReader("setsiteoption"))
            {
                //In PreMod for a day
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PreModDuration");
                reader.AddParameter("Value", "0");
                reader.Execute();
            }

            // Create a new user in the database for h2g2
            int userID = CreateUserInDatabase(context, 0);

            // Now put the user into timed premod for a day
            using (IDnaDataReader reader = context.CreateDnaDataReader("updatetrackedmemberlist"))
            {
                reader.AddParameter("UserIDs", userID.ToString());
                reader.AddParameter("SiteIDs", 1);
                reader.AddParameter("PrefStatus", 1);
                reader.AddParameter("PrefStatusDuration", 1440);
                reader.Execute();
            }

            // Check to make sure that the status of the user is correct
            using (IDnaDataReader reader = context.CreateDnaDataReader("getmemberprefstatus"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", 1);
                reader.AddIntOutputParameter("PrefStatus");
                reader.Execute();

                // Check to make sure that we got something back
                int prefStatus = -1;
                reader.TryGetIntOutputParameter("PrefStatus", out prefStatus);
                Assert.AreEqual(1, prefStatus, "The users pref status should be 1!");
            }

            // Now simulate the passing of a day by setting the PrefStatusChangedDate to being more than a day ago
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                // Create an adhoc qurery to update the preferences table for the user
                DateTime d = DateTime.Now.AddDays(-2);
                String s = Convert.ToString(d.Year) + "-" + Convert.ToString(d.Month) + "-" + Convert.ToString(d.Day);
                string sql = "UPDATE dbo.Preferences SET PrefStatusChangedDate ='" + s + "' WHERE SiteID = 1 AND UserID = " + Convert.ToString(userID);
                reader.ExecuteDEBUGONLY(sql);
            }

            // Check to make sure that the status of the user is correct. This should not of changed as we need to call the update timed premod users
            using (IDnaDataReader reader = context.CreateDnaDataReader("getmemberprefstatus"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", 1);
                reader.AddIntOutputParameter("PrefStatus");
                reader.Execute();

                // Check to make sure that we got something back
                int prefStatus = -1;
                reader.TryGetIntOutputParameter("PrefStatus", out prefStatus);
                Assert.AreEqual(1, prefStatus, "The users pref status should be 1!");
            }

            // Now call the UpdateTimedPreModUsers procedure to update the users PrefSatus inline with the changed date
            using (IDnaDataReader reader = context.CreateDnaDataReader("updatetimedpremodusers"))
            {
                reader.Execute();
            }

            // Check to make sure that the status of the user is correct.
            // The user should now be out of premod
            using (IDnaDataReader reader = context.CreateDnaDataReader("getmemberprefstatus"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", 1);
                reader.AddIntOutputParameter("PrefStatus");
                reader.Execute();

                // Check to make sure that we got something back
                int prefStatus = -1;
                reader.TryGetIntOutputParameter("PrefStatus", out prefStatus);
                Assert.AreEqual(0, prefStatus, "The users pref status should be 0!");
            }
        }

        /// <summary>
        /// Helper method for creating a new user in the database
        /// </summary>
        /// <param name="context">The context in which to create the data reader</param>
        /// <param name="autoSinBinExpectedValue">The expected value for the autosinbin when checked</param>
        /// <returns>The id of the new user</returns>
        private static int CreateUserInDatabase(IInputContext context, int autoSinBinExpectedValue)
        {
            int userID = Int32.MaxValue - 100000;
            using (IDnaDataReader reader = context.CreateDnaDataReader("createnewuserfromssoid"))
            {
                reader.AddParameter("ssouserid", userID);
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
                userID = reader.GetInt32("UserID");
                Assert.AreNotEqual(0, reader.GetInt32("UserID"), "UserId does not match the one entered");
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
                Assert.IsTrue(reader.GetDateTime("DateJoined") > DateTime.Now.AddMinutes(-5), "The users date joined value is not with in the tolarences of this test!");
                Assert.AreEqual(autoSinBinExpectedValue, reader.GetTinyIntAsInt("AutoSinBin"), "The user should be in the auto sin bin!");
                Assert.AreEqual(1, reader.GetTinyIntAsInt("Status"), "The user status is not correct");
                Assert.AreEqual(0, reader.GetTinyIntAsInt("PrefStatus"), "The user pref status is not correct");
            }

            return userID;
        }
    }
}
