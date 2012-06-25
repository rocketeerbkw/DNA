using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Xml;
using Tests;
using TestUtils;
using BBC.Dna.Data;
using BBC.Dna;
using BBC.Dna.Utils;
using BBC.Dna.Api;
using BBC.Dna.Moderation.Utils;

namespace FunctionalTests
{
    /// <summary>
    /// Summary description for UserListPageTest
    /// </summary>
    [TestClass]
    public class HostDashboardUserActivityPageTest
    {
        private static string _siteName = "moderation";
        private static int _siteId = 1;
        private static int _normalUserId = TestUserAccounts.GetNormalUserAccount.UserID;
        private string _normalUserSearch = String.Format("HostDashboardUserActivity?s_user={0}&s_siteid={1}&skin=purexml", _normalUserId, _siteId);
        private IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

        public HostDashboardUserActivityPageTest()
        {

        }

        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            using (IDnaDataReader reader = testContext.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("delete from UserPrefStatusAuditActions");
                reader.ExecuteDEBUGONLY("delete from UserPrefStatusAudit");
                reader.ExecuteDEBUGONLY("delete from UserReputationScore");
                reader.ExecuteDEBUGONLY("insert into UserReputationScore (userid, modclassid, accumulativescore, lastupdated) values (" + _normalUserId.ToString() + ",3,0,getdate())");
            }
        }

        [TestCleanup]
        public void Cleanup()
        {
            
            //reset via db - dont bother doing request
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("reactivateaccount"))
            {
                reader.AddParameter("userid", _normalUserId);
                reader.Execute();
            }

            using (IDnaDataReader reader = testContext.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("update preferences set prefstatus=0, prefstatusduration=null where userid=" + _normalUserId.ToString());
            }
            using (IDnaDataReader reader = testContext.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("delete from UserPrefStatusAuditActions");
                reader.ExecuteDEBUGONLY("delete from UserPrefStatusAudit");
            }

        }

        [TestMethod]
        public void HostDashboardUserActivity_AsNormalUser_ReturnsUnauthorised()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "Authorization");
        }

        [TestMethod]
        public void HostDashboardUserActivity_AsEditorUser_ReturnsAuthorised()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("HostDashboarduseractivityPageTest?skin=purexml");

            var xml = request.GetLastResponseAsXML();

            CheckNoError(xml);
        }

        [TestMethod]
        public void HostDashboardUserActivity_AsSuperUser_ReturnsAuthorised()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch);

            var xml = request.GetLastResponseAsXML();

            CheckNoError(xml);
        }



        [TestMethod]
        public void HostDashboardUserActivity_SetPostModUser_ReturnsCorrectResults()
        {
            var newModStatus = "Postmoderated";
            var newDuration = "1440";

            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string,string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllSites", "1"));


            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, newModStatus, newDuration);
        }

        [TestMethod]
        public void HostDashboardUserActivity_SetPreModUser_ReturnsCorrectResults()
        {
            var newModStatus = "Premoderated";
            var newDuration = "1440";

            
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllSites", "1"));


            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, newModStatus, newDuration);
        }

        [TestMethod]
        public void HostDashboardUserActivity_SetBanned_ReturnsCorrectResults()
        {
            var newModStatus = "Restricted";
            var newDuration = "0";

            
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllSites", "1"));



            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, "Restricted", newDuration);
        }

        [TestMethod]
        public void HostDashboardUserActivity_SetDeactivated_ReturnsCorrectResults()
        {
            var newModStatus = "Deactivated";
            var newDuration = "0";

            
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllSites", "1"));


            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, newModStatus, newDuration);

            //c# test
            request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("mbfrontpage?skin=purexml");
            xml =request.GetLastResponseAsXML();
            Assert.IsNull(xml.SelectSingleNode("//H2G2/VIEWING-USER/USER"));

            //c++ test
            request.RequestPage("home?skin=purexml");
            xml = request.GetLastResponseAsXML();
            Assert.IsNull(xml.SelectSingleNode("//H2G2/VIEWING-USER/USER"));
        }

        [TestMethod]
        public void HostDashboardUserActivity_SetDeactivatedWithRemoveContent_ReturnsCorrectResults()
        {
            var newModStatus = "Deactivated";
            var newDuration = "0";
            var removeContent =true;

            
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllPosts", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllSites", "1"));

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, newModStatus, newDuration, removeContent, _siteId);
        }

        [TestMethod]
        public void HostDashboardUserActivity_SetDeactivatedAsEditor_ReturnsError()
        {
            var newModStatus = "Deactivated";
            var newDuration = "0";

            
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllSites", "1"));


            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "InsufficientPermissions");
        }

        [TestMethod]
        public void HostDashboardUserActivity_SetBannedWithRemoveContent_ReturnsError()
        {
            var newModStatus = "Restricted";
            var newDuration = "0";

            
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllPosts", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllSites", "1"));

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "InvalidStatus");
        }

        [TestMethod]
        public void HostDashboardUserActivity_SetBannedWithoutReason_ReturnsError()
        {
            var newModStatus = "Restricted";
            var newDuration = "0";

            
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            //postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllSites", "1"));

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "EmptyReason");
        }


        private void CheckUpdateApplied(XmlDocument xml, string newModStatus, string duration)
        {
            CheckUpdateApplied(xml, newModStatus, duration, false, _siteId);
        }

        private void CheckUpdateApplied(XmlDocument xml, string newModStatus, string duration, bool removeContent, int siteId)
        {
            CheckNoError(xml);

            Assert.AreEqual(newModStatus.ToUpper(), xml.SelectSingleNode("//H2G2/USERREPUTATION/CURRENTSTATUS").InnerText.ToUpper());
            
            if (removeContent)
            {
                using (IDnaDataReader reader = testContext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("select * from threadentries where (hidden is null) and userid=" + _normalUserId.ToString());
                    Assert.IsFalse(reader.HasRows);
                }
            }

            if (newModStatus.ToUpper() == "DEACTIVATED")
            {//audit does not contain site info
                siteId = 0;
            }

            //check audit tables
            using (IDnaDataReader reader = testContext.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select * from UserPrefStatusAudit where userid=" + TestUserAccounts.GetSuperUserAccount.UserID + " and userupdateid in (select max(UserUpdateId) from UserPrefStatusAudit)" );
                Assert.IsTrue(reader.Read());
                int auditId = reader.GetInt32("UserUpdateId");
                Assert.AreEqual(newModStatus.ToUpper() == "DEACTIVATED", reader.GetBoolean("DeactivateAccount"));
                Assert.AreEqual(removeContent, reader.GetBoolean("HideContent"));


                reader.ExecuteDEBUGONLY("select * from UserPrefStatusAuditActions where UserUpdateId=" + auditId.ToString() + " and siteid=" + siteId);
                Assert.IsTrue(reader.Read());
                Assert.IsTrue(reader.HasRows);
                switch(newModStatus.ToUpper())
                {
                    case "POSTMODERATED":
                        Assert.AreEqual(2, reader.GetInt32("NewPrefStatus")); break;
                    case "PREMODERATED":
                        Assert.AreEqual(1, reader.GetInt32("NewPrefStatus")); break;
                    case "RESTRICTED":
                        Assert.AreEqual(4, reader.GetInt32("NewPrefStatus")); break;
                }

                Assert.AreEqual(Int32.Parse(duration), reader.GetInt32("PrefDuration"));

            }
        }

        private void CheckValidXml(XmlDocument xml, bool shouldFindUsers)
        {
            CheckNoError(xml);

            DnaXmlValidator validator = new DnaXmlValidator(xml.SelectSingleNode("//H2G2/USERREPUTATION").OuterXml, "userreputation.xsd");
            validator.Validate();

            
        }

        private void CheckForError(XmlDocument xml, string errorType)
        {
            var errorXml = xml.SelectSingleNode("//H2G2/ERROR");
            Assert.IsNotNull(errorXml);
            Assert.AreEqual(errorType, errorXml.Attributes["TYPE"].Value);
        }

        private void CheckNoError(XmlDocument xml)
        {
            Assert.IsNull(xml.SelectSingleNode("//H2G2/ERROR"));
        }
    }
}
