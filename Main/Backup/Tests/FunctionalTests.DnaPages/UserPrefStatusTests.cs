using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation;
using BBC.Dna.Sites;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Tests;
using BBC.Dna.Moderation.Utils;








namespace FunctionalTests
{
    /// <summary>
    /// This class tests the users prefstatus when moderation actions are taken via the member list and details procedures
    /// </summary>
    [TestClass]
    public class UserPrefStatusTests
    {
        /// <summary>
        /// Check to make that the users pref status changes correctly when they are put into premod
        /// </summary>
        [TestMethod]
        public void CheckPrefStatusAndGroupForUsersWhenChangingModerationStatus()
        {
            Console.WriteLine("Starting CheckPrefStatusAndChangedDateForUserBeingPutIntoPreMod");

            // Restore the database
            SnapshotInitialisation.RestoreFromSnapshot();

            // Create a context capable for creating real data readers
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            ISite mockedSite = DnaMockery.CurrentMockery.NewMock<ISite>();
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));
            Stub.On(mockedSite).GetProperty("UseIdentitySignInSystem").Will(Return.Value(false));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            // Mock the siteoption call for the checkusernameset option
            Stub.On(context).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(false));

            IDnaIdentityWebServiceProxy mockedSignIn = DnaMockery.CurrentMockery.NewMock<IDnaIdentityWebServiceProxy>();
            Stub.On(mockedSignIn).GetProperty("GetCookieValue").Will(Return.Value(""));
            Stub.On(context).GetProperty("GetCurrentSignInObject").Will(Return.Value(mockedSignIn));

            // Create a new user in the database for h2g2
            int userID = CreateUserInDatabase(context);

            // Now put the user into premod
            SetUsersModerationStatus(context, userID, 1);

            // Check to make sure that users is not in the premod group.
            //CheckUserBelongsToGroup(context, userID, "PREMODERATED", false);
            User user = new User(context);
            user.CreateUser(userID);

            // Check to make sure that the status of the user is correct
            CheckUsersPrefStatus(context, userID, 1);

            // Users Moderation Status is no longer put into GROUPS.
            CheckUserXML(context, userID, ModerationStatus.UserStatus.Premoderated);

            // Now put the user into premod
            SetUsersModerationStatus(context, userID, 2);

            // Check to make sure that users is not in the premod group.
            CheckUserXML(context, userID, ModerationStatus.UserStatus.Postmoderated);

            // Check to make sure that the status of the user is correct
            CheckUsersPrefStatus(context, userID, 2);

            // Now put the user into premod
            SetUsersModerationStatus(context, userID, 3);

            // Check to make sure that the status of the user is correct
            CheckUsersPrefStatus(context, userID, 3);

            // Now put the user into premod
            SetUsersModerationStatus(context, userID, 4);

            // Check to make sure that users is not in the premod group.
            CheckUserXML(context, userID, ModerationStatus.UserStatus.Restricted);

            // Check to make sure that the status of the user is correct
            CheckUsersPrefStatus(context, userID, 4);


            // Now put the user into premod
            SetUsersModerationStatus(context, userID, 0);

            // Check to make sure that the status of the user is correct
            CheckUsersPrefStatus(context, userID, 0);

            // Check to see if they are in the correct group in the XML
            CheckUserXML(context, userID, ModerationStatus.UserStatus.Standard);


            // Now put the user into trusted
            SetUsersModerationStatus(context, userID, 6);

            // Check to make sure that the status of the user is correct
            CheckUsersPrefStatus(context, userID, 6);

            // Check to see if they are in the correct group in the XML
            CheckUserXML(context, userID, ModerationStatus.UserStatus.Trusted);

            Console.WriteLine("Finishing CheckPrefStatusAndChangedDateForUserBeingPutIntoPreMod");
        }

        /// <summary>
        /// Helper method for setting the users pref status via the stored procedures
        /// </summary>
        /// <param name="context">The context in which to create the data reader</param>
        /// <param name="userID">The id of the user you want to update the status for</param>
        /// <param name="prefStatus">The new status for the user.
        /// 0 = normal
        /// 1 = premod
        /// 2 = postmod
        /// 3 = for review
        /// 4 = banned / restricted</param>
        private static void SetUsersModerationStatus(IInputContext context, int userID, int prefStatus)
        {
            using (IDnaDataReader reader = context.CreateDnaDataReader("updatetrackedmemberlist"))
            {
                reader.AddParameter("UserIDs", userID.ToString());
                reader.AddParameter("SiteIDs", 1);
                reader.AddParameter("PrefStatus", prefStatus);
                reader.AddParameter("PrefStatusDuration", 0);
                reader.AddParameter("reason", "reason");
                reader.AddParameter("viewinguser", 6);
                reader.Execute();
            }
        }

        /// <summary>
        /// Helper method that checks to see if the us4er belongs to a given group
        /// </summary>
        /// <param name="context">The context in which to create the data reader</param>
        /// <param name="userID">The id of the user you want to check the groups for</param>
        /// <param name="groupToCheck">The group that you want to see if the user is a member of</param>
        /// <param name="expectedResult">The exspected result from the query</param>
        private static void CheckUserBelongsToGroup(IInputContext context, int userID, string groupToCheck, bool expectedResult)
        {
            using (IDnaDataReader reader = context.CreateDnaDataReader("isusermemberofgroup"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("GroupName", groupToCheck);
                reader.AddIntOutputParameter("Exists");
                reader.Execute();

                // Check to make sure that we got something back
                int isMember = -1;
                reader.TryGetIntOutputParameter("Exists", out isMember);
                if (expectedResult)
                {
                    Assert.IsTrue(isMember > 0, "The user should belong to the group - " + groupToCheck);
                }
                else
                {
                    Assert.IsTrue(isMember == 0, "The user should not belong to the group - " + groupToCheck);
                }
            }
        }

        /// <summary>
        /// Helper method that checks the users current prefstatus against an expected value
        /// </summary>
        /// <param name="context">The context in which to create the data reader</param>
        /// <param name="userID">The id of the user you want to check the status for</param>
        /// <param name="expectedPrefStatus">The expected value for the users current pref status</param>
        private static void CheckUsersPrefStatus(IInputContext context, int userID, int expectedPrefStatus)
        {
            using (IDnaDataReader reader = context.CreateDnaDataReader("getmemberprefstatus"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", 1);
                reader.AddIntOutputParameter("PrefStatus");
                reader.Execute();

                // Check to make sure that we got something back
                int prefStatus = -1;
                reader.TryGetIntOutputParameter("PrefStatus", out prefStatus);
                Assert.AreEqual(expectedPrefStatus, prefStatus, "The users pref status should be " + expectedPrefStatus.ToString());
            }
        }

        /// <summary>
        /// Helper method for checking if a user belongs to a given group. This is done by checking the XML for the user
        /// </summary>
        /// <param name="context">The context in which to create the object</param>
        /// <param name="userID">The id of the user you want to check against</param>
        /// <param name="groupToCheck">The group you want tocheck against</param>
        /// <param name="expectedResult">The expected outcome of the test</param>
        private static void CheckUserXML(IInputContext context, int userID, ModerationStatus.UserStatus prefStatus )
        {
            // Create a user object using this userid so we can check that the XML contains the correct group information
            User user = new User(context);
            user.CreateUser(userID);

           /* IDnaDataReader mockedReader = DnaMockery.CurrentMockery.NewMock<IDnaDataReader>();
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("UserName").Will(Return.Value("MR TESTER"));
            Stub.On(mockedReader).Method("DoesFieldExist").With("ZeitgeistScore").Will(Return.Value(false));
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("FirstNames").Will(Return.Value("MR"));
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("LastName").Will(Return.Value("TESTER"));
            Stub.On(mockedReader).Method("GetInt32NullAsZero").With("Status").Will(Return.Value(1));
            Stub.On(mockedReader).Method("GetInt32NullAsZero").With("TaxonomyNode").Will(Return.Value(0));
            Stub.On(mockedReader).Method("GetBoolean").With("Active").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Exists").With("UserName").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Exists").With("ZeitgeistScore").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Exists").With("FirstNames").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Exists").With("LastName").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Exists").With("Status").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Exists").With("TaxonomyNode").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Exists").With("Active").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Exists").With("SiteSuffix").Will(Return.Value(false));
            Stub.On(mockedReader).Method("Exists").With("Journal").Will(Return.Value(false));
            Stub.On(mockedReader).Method("Exists").With("Area").Will(Return.Value(false));
            Stub.On(mockedReader).Method("Exists").With("Title").Will(Return.Value(false));
            user.AddUserXMLBlock(mockedReader, userID, parentNode); */

            XmlNode parentNode = user.RootElement;

            // Check to see if the user belongs to the group
            /*XmlNode groupNode = parentNode.SelectSingleNode("//GROUPS/GROUP/NAME['" + groupToCheck + "']");

            if (expectedResult)
            {
                Assert.IsNotNull(groupNode, "Failed to find expected group - " + groupToCheck);
            }
            else
            {
                Assert.IsNull(groupNode, "The user should not belong to this group - " + groupToCheck);
            }*/

            //Check Users Pref / /Mod Status
            XmlNode node = parentNode.SelectSingleNode("//USER/MODERATIONSTATUS[@ID=" + (int) prefStatus + "]");
            Assert.IsNotNull(node, "User Pref Status XML Check");
        }

        private static int _currentTestUserID = int.MaxValue - 10000;

        /// <summary>
        /// Helper method for creating a new user in the database
        /// </summary>
        /// <param name="context">The context in which to create the data reader</param>
        /// <returns>The id of the new user</returns>
        private static int CreateUserInDatabase(IInputContext context)
        {
            int ssoUserID = _currentTestUserID++;
            int userID = 0;
            using (IDnaDataReader reader = context.CreateDnaDataReader("createnewuserfromssoid"))
            {
                reader.AddParameter("ssouserid", ssoUserID);
                reader.AddParameter("UserName", "TestUser" + ssoUserID.ToString());
                reader.AddParameter("Email", "a@b.c");
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("FirstNames", "MR");
                reader.AddParameter("LastName", "TESTER");
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "Creating a new user returned no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");

                // Get the new user id
                userID = reader.GetInt32("UserID");

                // Now check the values comming back from the database
                Assert.AreEqual("TestUser" + ssoUserID.ToString(), reader.GetString("LoginName"), "Users login name does not match the one entered");
                Assert.AreEqual("TestUser" + ssoUserID.ToString(), reader.GetString("UserName"), "Users name does not match the one entered");
                Assert.IsTrue(String.IsNullOrEmpty(reader.GetStringNullAsEmpty("FirstNames")), "Users first name should be null");
                Assert.IsTrue(String.IsNullOrEmpty(reader.GetStringNullAsEmpty("LastName")), "The users last name should be null");
                Assert.AreEqual("a@b.c", reader.GetString("Email"), "The users email does not match the one entered");
                

                // Here are the important ones for this test
                Assert.IsTrue(reader.GetDateTime("DateJoined") > DateTime.Now.AddMinutes(-1), "The users date joined value is not with in the tolarences of this test!");
                Assert.AreEqual(0, reader.GetTinyIntAsInt("AutoSinBin"), "The user shouldn't be in the auto sin bin!");
                Assert.AreEqual(1, reader.GetTinyIntAsInt("Status"), "The user status is not correct");
                Assert.AreEqual(0, reader.GetTinyIntAsInt("PrefStatus"), "The user pref status is not correct");
            }
            return userID;
        }
    }
}
