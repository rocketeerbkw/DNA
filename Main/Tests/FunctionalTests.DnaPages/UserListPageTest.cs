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
    public class UserListPageTest
    {
        private static string _siteName = "moderation";
        private static int _siteId = 1;
        private static int _normalUserId = TestUserAccounts.GetNormalUserAccount.UserID;
        private string _normalUserSearch = String.Format("userlist?searchText=DotNetNormalUser&usersearchtype=2&skin=purexml");
        private IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

        public UserListPageTest()
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
        public void UserList_AsNormalUser_ReturnsUnauthorised()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage("userlist?skin=purexml");

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "Authorization");
        }

        [TestMethod]
        public void UserList_AsEditorUser_ReturnsAuthorised()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("userlist?skin=purexml");

            var xml = request.GetLastResponseAsXML();

            CheckNoError(xml);
        }

        [TestMethod]
        public void UserList_AsSuperUser_ReturnsAuthorised()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage("userlist?skin=purexml");

            var xml = request.GetLastResponseAsXML();

            CheckNoError(xml);
        }

        [TestMethod]
        public void UserList_SearchNormalUserName_ReturnsCorrectResults()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;

            request.RequestPage(_normalUserSearch);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);
        }

        [TestMethod]
        public void UserList_SearchNormalUserId_ReturnsCorrectResults()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;


            request.RequestPage(String.Format("userlist?searchText={0}&usersearchtype=0&skin=purexml", _normalUserId));

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);
        }

        [TestMethod]
        public void UserList_SearchNormalUserBBCUid_ReturnsCorrectResults()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;


            request.RequestPage(String.Format("userlist?searchText=00000000-0000-0000-0000-000000000000&usersearchtype=4&skin=purexml"));

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);
        }

        [TestMethod]
        public void UserList_SearchInvalidBBCUid_ReturnsCorrectError()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;


            request.RequestPage(String.Format("userlist?searchText=notaguid&usersearchtype=4&skin=purexml"));

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "NotValidBBCUid");
        }

        [TestMethod]
        public void UserList_SetPostModUser_ReturnsCorrectResults()
        {
            var newModStatus = "Postmoderate";
            var newDuration = "1440";

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId); 
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string,string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string,string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            


            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, newModStatus, newDuration);
        }

        [TestMethod]
        public void UserList_SetPreModUser_ReturnsCorrectResults()
        {
            var newModStatus = "Premoderate";
            var newDuration = "1440";

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));



            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, newModStatus, newDuration);
        }

        [TestMethod]
        public void UserList_SetBanned_ReturnsCorrectResults()
        {
            var newModStatus = "Restricted";
            var newDuration = "0";

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));



            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, "Banned", newDuration);
        }

        [TestMethod]
        public void UserList_SetDeactivate_ReturnsCorrectResults()
        {
            var newModStatus = "Deactivate";
            var newDuration = "0";

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));



            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, newModStatus, newDuration);
        }

        [TestMethod]
        public void UserList_SetDeactivateWithRemoveContent_ReturnsCorrectResults()
        {
            var newModStatus = "Deactivate";
            var newDuration = "0";
            var removeContent =true;

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllPosts", "1"));

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, newModStatus, newDuration, removeContent, _siteId);
        }

        [TestMethod]
        public void UserList_SetDeactivateAsEditor_ReturnsError()
        {
            var newModStatus = "Deactivate";
            var newDuration = "0";

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));



            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "InsufficientPermissions");
        }

        [TestMethod]
        public void UserList_SetBannedWithRemoveContent_ReturnsError()
        {
            var newModStatus = "Restricted";
            var newDuration = "0";

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllPosts", "1"));


            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "InvalidStatus");
        }

        [TestMethod]
        public void UserList_SetBannedWithoutReason_ReturnsError()
        {
            var newModStatus = "Restricted";
            var newDuration = "0";

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            //postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));


            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "EmptyReason");
        }

        [TestMethod]
        public void UserList_SetMultipleBanned_ReturnsCorrectResults()
        {
            var newModStatus = "Restricted";
            var newDuration = "0";
            var secondSite = 54;

            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            var applyKey2 = string.Format("applyTo|{0}|{1}", _normalUserId, secondSite);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>(applyKey2, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));



            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);

            var xml = request.GetLastResponseAsXML();

            CheckValidXml(xml, true);

            CheckUpdateApplied(xml, "Banned", newDuration);
            CheckUpdateApplied(xml, "Banned", newDuration, false, secondSite);
        }

        [TestMethod]
        public void UserList_RemovePostsE2EWithMBs_ReturnsCorrectResults()
        {
            //check existing forum
            var request = new DnaTestURLRequest("h2g2");
            request.RequestPage(string.Format("NF{0}?thread={1}&skin=purexml", 150, 32));
            var xml = request.GetLastResponseAsXML();

            var posts = xml.SelectNodes("//H2G2/FORUMTHREADPOSTS/POST");
            foreach (XmlNode post in posts)
            {
                if (post.SelectSingleNode("USER/USERID").InnerText == _normalUserId.ToString())
                {
                    Assert.AreNotEqual("8", post.Attributes["HIDDEN"].InnerText);
                }
            }

            //deactivate user
            var newModStatus = "Deactivate";
            var newDuration = "0";
            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllPosts", "1"));
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);
            xml = request.GetLastResponseAsXML();
            CheckValidXml(xml, true);
            CheckUpdateApplied(xml, newModStatus, newDuration, true, _siteId);

            //check posts are hidden
            request.RequestPage(string.Format("NF{0}?thread={1}&skin=purexml", 150, 32));
            xml = request.GetLastResponseAsXML();

            posts = xml.SelectNodes("//H2G2/FORUMTHREADPOSTS/POST");
            foreach (XmlNode post in posts)
            {
                if (post.SelectSingleNode("USER/USERID").InnerText == _normalUserId.ToString())
                {
                    Assert.AreEqual("8", post.Attributes["HIDDEN"].InnerText);
                }
            }

            //reactivate user
            newModStatus = "Standard";
            newDuration = "0";
            applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);
            xml = request.GetLastResponseAsXML();
            CheckValidXml(xml, true);
            CheckUpdateApplied(xml, newModStatus, newDuration);

            //check posts are unhidden
            request.RequestPage(string.Format("NF{0}?thread={1}&skin=purexml", 150, 32));
            xml = request.GetLastResponseAsXML();

            posts = xml.SelectNodes("//H2G2/FORUMTHREADPOSTS/POST");
            foreach (XmlNode post in posts)
            {
                if (post.SelectSingleNode("USER/USERID").InnerText == _normalUserId.ToString())
                {
                    Assert.AreNotEqual("8", post.Attributes["HIDDEN"].InnerText);
                }
            }
        }

        [TestMethod]
        public void UserList_RemovePostsE2EWithCommentsApi_ReturnsCorrectResults()
        {
            //check existing forum
            string commentForumUrl = string.Format("http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/",
                    DnaTestURLRequest.CurrentServer, "h2g2", "TestUniqueKeyValue");
            
            var request = new DnaTestURLRequest("h2g2");
            request.RequestPageWithFullURL(commentForumUrl);
            var xml = request.GetLastResponseAsXML();

            var commentForum = (CommentForum)StringUtils.DeserializeObject(xml.OuterXml, typeof(CommentForum));
            foreach (var post in commentForum.commentList.comments)
            {
                Assert.AreNotEqual(CommentStatus.Hidden.Removed_UserContentRemoved, post.hidden);
            }

            //deactivate user
            var newModStatus = "Deactivate";
            var newDuration = "0";
            var applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            Queue<KeyValuePair<string, string>> postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            postData.Enqueue(new KeyValuePair<string, string>("hideAllPosts", "1"));
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);
            xml = request.GetLastResponseAsXML();
            CheckValidXml(xml, true);
            CheckUpdateApplied(xml, newModStatus, newDuration, true, _siteId);

            //check posts are hidden
            request.RequestPageWithFullURL(commentForumUrl);
            xml = request.GetLastResponseAsXML();

            commentForum = (CommentForum)StringUtils.DeserializeObject(xml.OuterXml, typeof(CommentForum));
            foreach (var post in commentForum.commentList.comments)
            {
                Assert.AreEqual(CommentStatus.Hidden.Removed_UserContentRemoved, post.hidden);
            }

            //reactivate user
            newModStatus = "Standard";
            newDuration = "0";
            applyKey = string.Format("applyTo|{0}|{1}", _normalUserId, _siteId);
            postData = new Queue<KeyValuePair<string, string>>();
            postData.Enqueue(new KeyValuePair<string, string>(applyKey, ""));
            postData.Enqueue(new KeyValuePair<string, string>("userStatusDescription", newModStatus));
            postData.Enqueue(new KeyValuePair<string, string>("duration", newDuration));
            postData.Enqueue(new KeyValuePair<string, string>("reasonChange", "test"));
            postData.Enqueue(new KeyValuePair<string, string>("ApplyAction", "1"));
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(_normalUserSearch, postData);
            xml = request.GetLastResponseAsXML();
            CheckValidXml(xml, true);
            CheckUpdateApplied(xml, newModStatus, newDuration);

            //check posts are unhidden
            request.RequestPageWithFullURL(commentForumUrl);
            xml = request.GetLastResponseAsXML();

            commentForum = (CommentForum)StringUtils.DeserializeObject(xml.OuterXml, typeof(CommentForum));
            foreach (var post in commentForum.commentList.comments)
            {
                Assert.AreNotEqual(CommentStatus.Hidden.Removed_UserContentRemoved, post.hidden);
            }
        }

        private void CheckUpdateApplied(XmlDocument xml, string newModStatus, string duration)
        {
            CheckUpdateApplied(xml, newModStatus, duration, false, _siteId);
        }

        private void CheckUpdateApplied(XmlDocument xml, string newModStatus, string duration, bool removeContent, int siteId)
        {
            CheckNoError(xml);

            var userAccount = xml.SelectSingleNode(
                string.Format("//H2G2/MEMBERLIST/USERACCOUNTS/USERACCOUNT[SITEID={0}]", siteId));

            Assert.IsNotNull(userAccount);

            if (newModStatus.ToUpper() != "DEACTIVATE")
            {
                Assert.AreEqual(newModStatus.ToUpper(), userAccount.SelectSingleNode("USERSTATUSDESCRIPTION").InnerText.ToUpper());
            }
            else
            {
                Assert.AreEqual("0", userAccount.SelectSingleNode("ACTIVE").InnerText);
            }
            Assert.AreEqual(duration, userAccount.SelectSingleNode("PREFSTATUSDURATION").InnerText);

            if (removeContent)
            {
                using (IDnaDataReader reader = testContext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("select * from threadentries where (hidden is null) and userid=" + _normalUserId.ToString());
                    Assert.IsFalse(reader.HasRows);
                }
            }

            if (newModStatus.ToUpper() == "DEACTIVATE")
            {//audit does not contain site info
                siteId = 0;
            }

            //check audit tables
            using (IDnaDataReader reader = testContext.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select * from UserPrefStatusAudit where userid=" + TestUserAccounts.GetSuperUserAccount.UserID + " and userupdateid in (select max(UserUpdateId) from UserPrefStatusAudit)" );
                Assert.IsTrue(reader.Read());
                int auditId = reader.GetInt32("UserUpdateId");
                Assert.AreEqual(newModStatus.ToUpper() == "DEACTIVATE", reader.GetBoolean("DeactivateAccount"));
                Assert.AreEqual(removeContent, reader.GetBoolean("HideContent"));


                reader.ExecuteDEBUGONLY("select * from UserPrefStatusAuditActions where UserUpdateId=" + auditId.ToString() + " and siteid=" + siteId);
                Assert.IsTrue(reader.Read());
                Assert.IsTrue(reader.HasRows);
                switch(newModStatus.ToUpper())
                {
                    case "POSTMODERATE":
                        Assert.AreEqual(2, reader.GetInt32("NewPrefStatus")); break;
                    case "PREMODERATE":
                        Assert.AreEqual(1, reader.GetInt32("NewPrefStatus")); break;
                    case "BANNED":
                        Assert.AreEqual(4, reader.GetInt32("NewPrefStatus")); break;
                }
                Assert.AreEqual(Int32.Parse(duration), reader.GetInt32("PrefDuration"));

            }
        }

        private void CheckValidXml(XmlDocument xml, bool shouldFindUsers)
        {
            CheckNoError(xml);

            DnaXmlValidator validator = new DnaXmlValidator(xml.SelectSingleNode("//H2G2/MEMBERLIST").OuterXml, "memberlist.xsd");
            validator.Validate();

            if(shouldFindUsers)
            {
                Assert.AreNotEqual("0", xml.SelectSingleNode("//H2G2/MEMBERLIST").Attributes["COUNT"].Value);
            }
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
