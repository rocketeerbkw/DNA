using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Tests;
using TestUtils;


namespace FunctionalTests
{
    /// <summary>
    /// This class is used to test the banned emails functions.
    /// This includes signin banning and complaint banning.
    /// </summary>
    [TestClass]
    public class BannedEMailsFunctionalTests
    {
        [TestInitialize]
        public void Setup()
        {
            // Make sure the database is in the starting position
            SnapshotInitialisation.ForceRestore();
        }

        [TestCleanup]
        public void ShutDown()
        {
            // Make sure the database is back in the starting position
            SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Checks to make sure that an email that is marked as complaint banned in the bannedemails list is caught correctly.
        /// </summary>
        [TestMethod]
        public void TestComplaintBannedEmailIsCaught()
        {
            // First make sure that the test user can make a complint before we put the email in the banned emails list
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            int userID = request.CurrentUserID;
            request.RequestPage("UserComplaintPage?postid=2&skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();

            // Check to make sure that no errors came back
            Assert.IsTrue(xml.SelectSingleNode("//USER-COMPLAINT-FORM/ERROR") == null, "There should not be any errors present in the XML!");

            try
            {
                // Now put the users email into the banned emails list for complaints
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
                {
                    reader.AddParameter("Email", "mark.howitt@bbc.co.uk");//this is dotnetnormaluser's email
                    reader.AddParameter("SigninBanned", 0);
                    reader.AddParameter("ComplaintBanned", 1);
                    reader.AddParameter("EditorID", 6);
                    reader.AddIntReturnValue();
                    reader.Execute();

                    var duplicate = reader.GetIntReturnValue();
                    Assert.AreEqual(0, duplicate, "The Duplicate result should be false (0)");

                    request.RequestPage("dnasignal?action=recache-bannedEmails");
                }

                // Now try to complain again
                request.RequestPage("UserComplaintPage?postid=2&skin=purexml");
                request.SetCurrentUserEditor();
                xml = request.GetLastResponseAsXML();

                // Check to make sure that no errors came back
                Assert.IsTrue(xml.SelectSingleNode("//ERROR") != null, "There should be an error present in the XML!");
                Assert.IsTrue(xml.SelectSingleNode("//ERROR[@TYPE='EMAILNOTALLOWED']") != null, "There should be an EMAILNOTALLOWED error present in the XML!");

            }
            finally
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader reader = context.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("exec removebannedemail @email='mark.howitt@bbc.co.uk'");//this is dotnetnormaluser's email
                    request.RequestPage("dnasignal?action=recache-bannedEmails");
                }
            }
        }

        /// <summary>
        /// Checks to make sure that an email that is marked as complaint banned in the bannedemails list is caught correctly
        /// when the user is not logged in.
        /// </summary>
        [TestMethod]
        public void TestComplaintBannedEmailIsCaughtUserNotLoggedIn()
        {
            // First make sure that the test user can make a complint before we put the email in the banned emails list
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNotLoggedInUser();
            request.RequestPage("UserComplaintPage?postid=1&skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();

            // Check to make sure that no errors came back
            Assert.IsTrue(xml.SelectSingleNode("//USER-COMPLAINT-FORM/ERROR") == null, "There should not be any errors present in the XML!");

            // Now put the users email into the banned emails list for complaints if it's not already there
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "damnyoureyes72+2@googlemail.com");
                reader.AddParameter("SigninBanned", 0);
                reader.AddParameter("ComplaintBanned", 1);
                reader.AddParameter("EditorID", 6);
                reader.AddIntReturnValue();
                reader.Execute();

                var duplicate = reader.GetIntReturnValue();

                Assert.AreEqual(0, duplicate, "The Duplicate result should be false (0)");
            }

            // Now try to complain again
            request.RequestPage("UserComplaintPage?postid=1&Submit=1&email=damnyoureyes72%2B2@googlemail.com&skin=purexml");
            xml = request.GetLastResponseAsXML();

            // Check to make sure that no errors came back
            Assert.IsTrue(xml.SelectSingleNode("//ERROR") != null, "There should be an error present in the XML!");
            Assert.IsTrue(xml.SelectSingleNode("//ERROR[@TYPE='EMAILNOTALLOWED']") != null, "There should be an EMAILNOTALLOWED error present in the XML!");
        }

        [TestMethod]
        public void TestBannedEmailReturnValues()
        {
            Assert.AreEqual(0, AddEmailToBannedList("frank@tortoise.com"), "This email should not be a duplicate, so should return 0");
            Assert.AreEqual(1, AddEmailToBannedList("frank@tortoise.com"), "This email should be a duplicate, so should return 1");
            Assert.AreEqual(0, AddEmailToBannedList(null), "A NULL email should be ignored and return 0");
            Assert.AreEqual(0, AddEmailToBannedList(""), "An empty email should be ignored and return 0");
        }

        private int AddEmailToBannedList(string email)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", email);
                reader.AddParameter("SigninBanned", 0);
                reader.AddParameter("ComplaintBanned", 0);
                reader.AddParameter("EditorID", 6);
                reader.AddIntReturnValue();
                reader.Execute();
                return reader.GetIntReturnValue();
            }
        }
    }
}
