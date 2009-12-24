using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Test the XML against the schema.
    /// Sanity check the results.
    /// </summary>
    [TestClass]
    public class UserComplaintPageTests
    {
        private int _postId = 0;

        [TestInitialize]
        public void FixtureSetup()
        {
            SnapshotInitialisation.ForceRestore();

            //Get a post Id so that a complaint can be made.
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("getalluserpostingstatsbasic"))
            {
                reader.ExecuteDEBUGONLY("SELECT TOP 1 entryid FROM ThreadEntries");

                if (reader.Read())
                {
                    _postId = reader.GetInt32NullAsZero("entryid");
                }
            }
        }

        [TestCleanup]
        public void ShutDown()
        {
            // Make sure the database is back in the starting position
            // SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Check Schema of UserComplaint page befor submission
        /// </summary>
        [TestMethod]
        public void Test1UserComplaintPage()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = false;
            request.RequestPage("UserComplaintPage?skin=purexml" + "&postid=" + Convert.ToString(_postId) );

            XmlDocument doc = request.GetLastResponseAsXML();

            //Check XML against Schema.
            DnaXmlValidator validator = new DnaXmlValidator(doc.InnerXml, "H2G2UserComplaintFlat.xsd");
            validator.Validate();
        }

        /// <summary>
        /// Check Schema of UserComplaint page befor submission
        /// </summary>
        [TestMethod]
        public void Test2DuplicateComplaint()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = false;
            request.RequestPage("UserComplaintPage?postid=" + Convert.ToString(_postId) + "&action=submit&complaintreason=libellous&complainttext=Complaint&skin=purexml");

            //Check XML against Schema.
            XmlDocument doc = request.GetLastResponseAsXML();

            Assert.IsTrue(doc.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID") != null, "Complaint should be processed");
            String modId = doc.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID").Value;

            request.RequestPage("UserComplaintPage?postid=" + Convert.ToString(_postId) + "&action=submit&complaintreason=libellous&complainttext=Complaint&skin=purexml");
            Assert.IsTrue(doc.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID") != null, "Complaint should be processed");
            Assert.IsTrue(doc.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID").Value == modId, "New complaint should not be generated");
        }

        /// <summary>
        /// Tests that a banned user either logged in or not does not succeed
        /// </summary>
        [TestMethod]
        public void Test3BannedUser()
        {
            // First make sure that the test user can make a complaint before we put the email in the banned emails list
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNotLoggedInUser();
            request.RequestPage("UserComplaintPage?postid=" + Convert.ToString(_postId) + "&action=submit&complaintreason=libellous&complainttext=Complaint&email=mark.howitt@bbc.co.uk&skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();

            // Check to make sure complaint was processed
            Assert.IsTrue(xml.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID") != null, "Complaint did not succeed");

             // Now put the users email into the banned emails list for complaints
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "mark.howitt@bbc.co.uk");
                reader.AddParameter("SigninBanned", 0);
                reader.AddParameter("ComplaintBanned", 1);
                reader.AddParameter("EditorID", 6);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Exists("Duplicate"), "The Duplicate result field is not in the AddEMailToBannedList dataset");
                Assert.IsFalse(reader.GetBoolean("Duplicate"), "The Duplicate result should be false!");
            }

             // Now try to complain again
            request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.RequestPage("UserComplaintPage?postid=" + Convert.ToString(_postId) + "&action=submit&complaintreason=libellous&complainttext=Complaint&email=mark.howitt@bbc.co.uk&skin=purexml");
            xml = request.GetLastResponseAsXML();

            // Check to make sure that complaint was not made.
            Assert.IsTrue(xml.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID") == null, "User is banned from complaining.");
            Assert.IsTrue(xml.SelectSingleNode("//H2G2/ERROR") != null, "User is banned from complaining.");
        }
    }
}
