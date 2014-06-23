using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Web;
using System.Net;
using BBC.Dna;
using BBC.Dna.Api;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Objects;
using System.Xml;
using System.Collections.Specialized;

namespace FunctionalTests.Services.Users
{
    /// <summary>
    /// Summary description for users
    /// </summary>
    [TestClass]
    public class users
    {
        string callinguser_url;
        string callinguser_url_withInvalidSite;
        string callinguser_url_json;

        string callinguserfull_secure_url;
        
        private const string _schemaUser = @"Dna.Services.Users\user.xsd";
        private const string _schemaArticle = "Dna.Services.Articles\\article.xsd";
        private const string _schemaForumThreads = "Dna.Services.Forums\\forumThreads.xsd";
        private const string _schemaLinksList = "Dna.Services.Common\\linksList.xsd";
        private const string _schemaArticleSubscriptions = "Dna.Services.Common\\articleSubscriptionsList.xsd";
        private const string _schemaUserSubscriptions = "Dna.Services.Common\\userSubscriptionsList.xsd";
        private const string _schemaLinkSubscriptions = "Dna.Services.Common\\linkSubscriptionsList.xsd";
        private const string _schemaBlockedUserSubscriptions = "Dna.Services.Common\\blockedUserSubscriptionsList.xsd";
        private const string _schemaSubscribingUsers = "Dna.Services.Common\\subscribingUsersList.xsd";
        private const string _schemaArticleList = "Dna.Services.Articles\\articleList.xsd";
        private const string _schemaPostList = "Dna.Services.Common\\postList.xsd";
        private const string _schemaFriendsList = @"Dna.Services.Users\friendsList.xsd";

        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        public users()
        {
            callinguser_url = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/callinguser?format=xml";
            callinguser_url_json = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/callinguser?format=json";
            callinguser_url_withInvalidSite = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/unknownsite/users/callinguser?format=xml";
            callinguserfull_secure_url = @"https://" + DnaTestURLRequest.SecureServerAddress + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/callinguserfull?format=xml";
        }

        [TestMethod]
        public void GetCallingUserInfo_AsEditor_ReturnsEditorItemInGroup()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsEditor_ReturnsEditorItemInGroup");
            
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserEditor();
            request.RequestPageWithFullURL(callinguser_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.IsNotNull(user.UsersListOfGroups.Find(x => x.Name.ToLower()  == "editor"));

            Console.WriteLine("After GetCallingUserInfo_AsEditor_ReturnsEditorItemInGroup");
        }

        [TestMethod]
        public void GetCallingUserInfo_AsBannedUser_ReturnsBannedStatus()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsBannedUser_ReturnsBannedStatus");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserBanned();
            request.RequestPageWithFullURL(callinguserfull_secure_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual("Banned", user.StatusAsString);

            Console.WriteLine("After GetCallingUserInfo_AsBannedUser_ReturnsBannedStatus");
        }

        [TestMethod]
        public void GetCallingUserInfo_AsModerator_ReturnsModeratorItemInGroup()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsModerator_ReturnsModeratorItemInGroup");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserModerator();
            request.RequestPageWithFullURL(callinguserfull_secure_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));
            
            Assert.IsTrue(user.UsersListOfGroups.Exists(x => x.Name.ToLower() == "moderator"));

            Console.WriteLine("After GetCallingUserInfo_AsModerator_ReturnsModeratorItemInGroup");
        }

        [TestMethod]
        public void GetCallingUserInfo_AsNormalUser_ReturnsNormalStatus()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsNormalUser_ReturnsNormalStatus");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(callinguserfull_secure_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual("Normal", user.StatusAsString);

            Console.WriteLine("After GetCallingUserInfo_AsNormalUser_ReturnsNormalStatus");
        }

        [TestMethod]
        public void GetCallingUserInfo_AsNormalUser_ReturnsValidXml()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsNormalUser_ReturnsNormalStatus");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserEditor();
            request.RequestPageWithFullURL(callinguserfull_secure_url);

            XmlDocument xml = request.GetLastResponseAsXML();
            string xmlWithoutNamespaces = xml.InnerXml.Replace(@"xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Users""", "");
            xmlWithoutNamespaces = xmlWithoutNamespaces.Replace(@"xmlns:a=""http://schemas.datacontract.org/2004/07/BBC.Dna.Groups""", "");
            xmlWithoutNamespaces = xmlWithoutNamespaces.Replace("a:", "");

            DnaXmlValidator validator = new DnaXmlValidator(xmlWithoutNamespaces, _schemaUser);
            validator.Validate();

            Console.WriteLine("After GetCallingUserInfo_AsNormalUser_ReturnsNormalStatus");
        }

        [TestMethod]
        public void GetCallingUserInfo_AsNormalUser_ReturnsValidJson()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsNormalUser_ReturnsValidJson");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(callinguser_url_json);

            Console.WriteLine("After GetCallingUserInfo_AsNormalUser_ReturnsValidJson");
        }        

        [TestMethod]
        public void GetCallingUserInfo_AsNotableUser_ReturnsNotablesItemInGroup()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsModerator_ReturnsNotablesItemInGroup");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNotableUser();
            request.RequestPageWithFullURL(callinguserfull_secure_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.IsNotNull(user.UsersListOfGroups.Find(x => x.Name.ToLower() == "notables"));

            Console.WriteLine("After GetCallingUserInfo_AsModerator_ReturnsNotablesItemInGroup");
        }

        [TestMethod]        
        public void GetCallingUserInfo_AsNotLoggedInUser_Returns401()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsNotLoggedInUser_Returns401");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2"); 
            request.SetCurrentUserNotLoggedInUser();
            request.AssertWebRequestFailure = false;
            try
            {
                request.RequestPageWithFullURL(callinguserfull_secure_url);               
            }
            catch (WebException)
            {
            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MissingUserCredentials.ToString(), errorData.Code);

            Console.WriteLine("After GetCallingUserInfo_AsNotLoggedInUser_Returns401");
        }

        [TestMethod]
        public void GetCallingUserInfo_UnknownSite_Returns404()
        {
            Console.WriteLine("Before GetCallingUserInfo_UnknownSite_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(DnaTestURLRequest.CurrentServer);
            request.AssertWebRequestFailure = false; 
            try
            {
                request.RequestPageWithFullURL(callinguser_url_withInvalidSite);
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UnknownSite.ToString(), errorData.Code);

            Console.WriteLine("After GetCallingUserInfo_UnknownSite_Returns404");
        }

        [TestMethod]
        public void GetCallingUserInfo_AsPreModUser_ReturnsNormalUser()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsPreModUser_ReturnsNormalUser");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserPreModUser();
            request.RequestPageWithFullURL(callinguserfull_secure_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual("Normal", user.StatusAsString);            

            Console.WriteLine("After GetCallingUserInfo_AsPreModUser_ReturnsNormalUser");
        }

        [TestMethod]
        public void GetCallingUserInfo_AsSuperUser_ReturnsSuperStatus()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsSuperUser_ReturnsSuperStatus");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserSuperUser();
            request.RequestPageWithFullURL(callinguserfull_secure_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual("Super", user.StatusAsString);            
            

            Console.WriteLine("After GetCallingUserInfo_AsSuperUser_ReturnsSuperStatus");
        }

        [TestMethod]
        public void GetCallingUserInfo_Non_Secure_ReturnsLessDetails()
        {
            Console.WriteLine("Before GetCallingUserInfo_Non_Secure_ReturnsLessDetails");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(callinguser_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.IsTrue(string.IsNullOrEmpty(user.IdentityUserID));
            Assert.IsTrue(string.IsNullOrEmpty(user.IdentityUserName));
           
            Console.WriteLine("After GetCallingUserInfo_Non_Secure_ReturnsLessDetails");
        }

        [TestMethod]
        public void GetCallingUserInfoFull_Non_Secure_Returns401()
        {
            Console.WriteLine("Before GetCallingUserInfoFull_Non_Secure_Returns401");

            DnaTestURLRequest request = new DnaTestURLRequest(DnaTestURLRequest.CurrentServer);
            request.AssertWebRequestFailure = false;
            try
            {
                request.RequestPageWithFullURL(callinguser_url);
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MissingUserCredentials.ToString(), errorData.Code);

            Console.WriteLine("After GetCallingUserInfoFull_Non_Secure_Returns401");
        }

        /// <summary>
        /// Test GetUsersAboutMeArticle method from service 
        /// </summary>
        [TestMethod]
        public void GetUsersAboutMeArticleByIdentityUserName_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersAboutMeArticleByIdentityUserName_ReadOnly_ReturnsValidXml");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users About Me IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/aboutme?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersAboutMeArticleByIdentityUserName_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetUsersAboutMeArticle method from service
        /// </summary>
        [TestMethod]
        public void GetUsersAboutMeArticleByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersAboutMeArticleByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users About Me UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/aboutme?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersAboutMeArticleByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersJournalByDNAUserId method from service
        /// </summary>
        [TestMethod]
        public void GetUsersJournalByIdentityUserName_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersJournalByIdentityUserName_ReadOnly_ReturnsValidXml");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Journal IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/journal?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaForumThreads);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersJournalByIdentityUserName_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersJournal method from service
        /// </summary>
        [TestMethod]
        public void GetUsersJournalByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersJournalByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Journal UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/journal?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaForumThreads);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersJournalByDNAUserId_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetUsersMessages method from service by IdentityUserName
        /// </summary>
        [TestMethod]
        public void GetUsersMessagesByIdentityUserName_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersMessagesByIdentityUserName_ReadOnly_ReturnsValidXml");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Messages IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/messages?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaForumThreads);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersMessagesByIdentityUserName_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersMessages method from service by DNAUserID
        /// </summary>
        [TestMethod]
        public void GetUsersMessagesByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersMessagesByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Messages UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/messages?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaForumThreads);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersMessagesByDNAUserId_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetUsersLinks / Bookmarks method from service by IdentityUserName
        /// </summary>
        [TestMethod]
        public void GetUsersLinksByIdentityUserName_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersLinksByIdentityUserName_ReadOnly_ReturnsValidXml");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Links IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/links?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaLinksList);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersLinksByIdentityUserName_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersLinks method from service by DNAUserID
        /// </summary>
        [TestMethod]
        public void GetUsersLinksByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersLinksByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Links UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/links?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaLinksList);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersLinksByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersArticleSubscriptions method from service 
        /// </summary>
        [TestMethod]
        public void GetUsersArticleSubscriptionsByIdentityUserName_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersArticleSubscriptionsByIdentityUserName_ReadOnly_ReturnsValidXml");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            SubscribeNormalUserToSomeUsersWhoCreateSomeArticles();

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();

                Console.WriteLine("Validating Users Article Subscriptions IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/articlesubscriptions?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticleSubscriptions);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersArticleSubscriptionsByIdentityUserName_ReadOnly_ReturnsValidXml");
        }

        private void SubscribeNormalUserToSomeUsersWhoCreateSomeArticles()
        {
            SubscribeToUser(1090501859, 6, 1);
            SubscribeToUser(1090501859, 42, 1);
            SubscribeToUser(1090501859, 1090558354, 1);

            //Create some articles 
            AddArticleSubscription(SetupASimpleGuideEntry(6));
            AddArticleSubscription(SetupASimpleGuideEntry(1090558354));
        }

        /// <summary>
        /// Function to add a subscription to a user
        /// </summary>
        /// <param name="userID">The user id of the person trying to subscribe to another user</param>
        /// <param name="authorID">The user id the person is trying to subscribe to</param>
        /// <param name="siteID">The site id of the site</param>
        private void SubscribeToUser(int userID, int authorID, int siteID)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            using (IDnaDataReader reader = context.CreateDnaDataReader("SubscribeToUser"))
            {
                reader.AddParameter("userid", userID);
                reader.AddParameter("authorid", authorID);
                reader.AddParameter("siteid", siteID);

                reader.Execute();
           }
        }

        private int SetupASimpleGuideEntry(int editor)
        {
            int H2G2ID = 0;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("createguideinternal"))
            {
                reader.ExecuteDEBUGONLY("exec createguideentry @subject='Test Entry by " + editor.ToString() + "', @bodytext='Test New Article', @extrainfo='<EXTRAINFO></EXTRAINFO>',@editor=" + editor.ToString() + ", @typeid=1, @status=1, @style=2");
                if (reader.Read())
                {
                    H2G2ID = reader.GetInt32NullAsZero("H2G2ID");
                }
            }
            return H2G2ID;

        }
        private void AddArticleSubscription(int h2g2Id)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("addarticlesubscription"))
            {
                reader.AddParameter("h2g2id", h2g2Id);
                reader.Execute();
            }
        }
        
        /// <summary>
        /// Test GetUsersArticleSubscriptions method from service
        /// </summary>
        [TestMethod]
        public void GetUsersArticleSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersArticleSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Article Subscriptions UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/articlesubscriptions?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticleSubscriptions);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersArticleSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersUserSubscriptions method from service
        /// </summary>
        [TestMethod]
        public void GetUsersUserSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersUserSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();

                Console.WriteLine("Validating Users User Subscriptions UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/usersubscriptions?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaUserSubscriptions);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersUserSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersBlockedUserSubscriptions method from service
        /// </summary>
        [TestMethod]
        public void GetUsersBlockedUserSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersBlockedUserSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();

                Console.WriteLine("Validating Users Blocked User Subscriptions UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/blockedusers?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaBlockedUserSubscriptions);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersBlockedUserSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersSubscribingUsers method from service
        /// </summary>
        [TestMethod]
        public void GetUsersSubscribingUsersByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersSubscribingUsersByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();

                Console.WriteLine("Validating Users Subscribing Users UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/subscribingusers?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaSubscribingUsers);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersSubscribingUsersByDNAUserId_ReadOnly_ReturnsValidXml");
        }


        /// <summary>
        /// Test GetUsersLinkSubscriptions method from service
        /// </summary>
        [TestMethod]
        public void GetUsersLinkSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersLinkSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();

                Console.WriteLine("Validating Users Link Subscriptions UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/linksubscriptions?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaLinkSubscriptions);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersLinkSubscriptionsByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        //JSON
        //JSON
        //JSON
        //JSON
        /// <summary>
        /// Test GetUsersAboutMeArticle method from service 
        /// </summary>
        [TestMethod]
        public void GetUsersAboutMeArticleByIdentityUserName_ReadOnly_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUsersAboutMeArticleByIdentityUserName_ReadOnly_ReturnsValidJSON");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users About Me IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/aboutme?format=json", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url);

                Article article = (Article)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(Article));

            }
            Console.WriteLine("After GetUsersAboutMeArticleByIdentityUserName_ReadOnly_ReturnsValidJSON");
        }
        /// <summary>
        /// Test GetUsersAboutMeArticle method from service
        /// </summary>
        [TestMethod]
        public void GetUsersAboutMeArticleByDNAUserId_ReadOnly_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUsersAboutMeArticleByDNAUserId_ReadOnly_ReturnsValidJSON");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users About Me UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/aboutme?idtype=DNAUserId&format=json", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url);

                Article article = (Article)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(Article));
            }
            Console.WriteLine("After GetUsersAboutMeArticleByDNAUserId_ReadOnly_ReturnsValidJSON");
        }

        /// <summary>
        /// Test GetUsersJournalByDNAUserId method from service
        /// </summary>
        [TestMethod]
        public void GetUsersJournalByIdentityUserName_ReadOnly_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUsersJournalByIdentityUserName_ReadOnly_ReturnsValidJSON");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Journal IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/journal?format=json", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url);

                ForumThreads forumThreads = (ForumThreads)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(ForumThreads));
            }
            Console.WriteLine("After GetUsersJournalByIdentityUserName_ReadOnly_ReturnsValidJSON");
        }

        /// <summary>
        /// Test GetUsersJournal method from service
        /// </summary>
        [TestMethod]
        public void GetUsersJournalByDNAUserId_ReadOnly_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUsersJournalByDNAUserId_ReadOnly_ReturnsValidJSON");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Journal UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/journal?idtype=DNAUserId&format=json", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url);

                ForumThreads forumThreads = (ForumThreads)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(ForumThreads));
            }
            Console.WriteLine("After GetUsersJournalByDNAUserId_ReadOnly_ReturnsValidJSON");
        }
        /// <summary>
        /// Test GetUsersMessages method from service by IdentityUserName
        /// </summary>
        [TestMethod]
        public void GetUsersMessagesByIdentityUserName_ReadOnly_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUsersMessagesByIdentityUserName_ReadOnly_ReturnsValidJSON");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Messages IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/messages?format=json", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url);

                ForumThreads forumThreads = (ForumThreads)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(ForumThreads));
            }
            Console.WriteLine("After GetUsersMessagesByIdentityUserName_ReadOnly_ReturnsValidJSON");
        }

        /// <summary>
        /// Test GetUsersMessages method from service by DNAUserID
        /// </summary>
        [TestMethod]
        public void GetUsersMessagesByDNAUserId_ReadOnly_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUsersMessagesByDNAUserId_ReadOnly_ReturnsValidJSON");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Messages UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/messages?idtype=DNAUserId&format=json", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url);

                ForumThreads forumThreads = (ForumThreads)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(ForumThreads));
            }
            Console.WriteLine("After GetUsersMessagesByDNAUserId_ReadOnly_ReturnsValidJSON");
        }
        /// <summary>
        /// Test GetUsersLinks / Bookmarks method from service by IdentityUserName
        /// </summary>
        [TestMethod]
        public void GetUsersLinksByIdentityUserName_ReadOnly_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUsersLinksByIdentityUserName_ReadOnly_ReturnsValidJSON");

            string[] identityUserNames = { "DotNetNormalUser", "DotNetEditor", "DotNetSuperUser", "DotNetModerator" };

            foreach (var name in identityUserNames)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Links IdentityUserName:" + name);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/links?format=json", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url);

                LinksList links = (LinksList)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(LinksList));
            }
            Console.WriteLine("After GetUsersLinksByIdentityUserName_ReadOnly_ReturnsValidJSON");
        }

        /// <summary>
        /// Test GetUsersLinks method from service by DNAUserID
        /// </summary>
        [TestMethod]
        public void GetUsersLinksByDNAUserId_ReadOnly_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUsersLinksByDNAUserId_ReadOnly_ReturnsValidJSON");

            int[] userIds = { 6, 42, 284, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Links UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/links?idtype=DNAUserId&format=json", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url);

                LinksList links = (LinksList)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(LinksList));
            }
            Console.WriteLine("After GetUsersLinksByDNAUserId_ReadOnly_ReturnsValidJSON");
        }

        //ERRORS
        /// <summary>
        /// Test GetUsersAboutMe method from service with an not known identityuserid 
        ///</summary>
        [TestMethod]
        public void CreateUsersAboutMeTestWithUnknownIdentityUserName()
        {
            Console.WriteLine("Before CreateUsersAboutMeTestWithUnknownIdentityUserName");

            string identityusername = "Idontexistshahahahaha";
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotLoggedInUser();
            request.AssertWebRequestFailure = false;
            try
            {
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/aboutme?format=xml", _sitename, identityusername);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UserNotFound.ToString(), errorData.Code);

            Console.WriteLine("After CreateUsersAboutMeTestWithUnknownIdentityUserName");
        }

        /// <summary>
        /// Test GetUsersJournal method from service with an not known identityuserid 
        ///</summary>
        [TestMethod]
        public void CreateUsersJournalTestWithUnknownIdentityUserName()
        {
            Console.WriteLine("Before CreateUsersJournalTestWithUnknownIdentityUserName");

            string identityusername = "Idontexistshahahahaha";
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotLoggedInUser();
            request.AssertWebRequestFailure = false;
            try
            {
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/journal?format=xml", _sitename, identityusername);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UserNotFound.ToString(), errorData.Code);

            Console.WriteLine("After CreateUsersJournalTestWithUnknownIdentityUserName");
        }

        /// <summary>
        /// Test GetUsersMessages method from service with an not known identityuserid 
        ///</summary>
        [TestMethod]
        public void CreateUsersMessagesTestWithUnknownIdentityUserName()
        {
            Console.WriteLine("Before CreateUsersMessagesTestWithUnknownIdentityUserName");

            string identityusername = "Idontexistshahahahaha";
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotLoggedInUser();
            request.AssertWebRequestFailure = false;
            try
            {
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/messages?format=xml", _sitename, identityusername);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UserNotFound.ToString(), errorData.Code);

            Console.WriteLine("After CreateUsersMessagesTestWithUnknownIdentityUserName");
        }

        /// <summary>
        /// Test GetUsersLinks method from service with an not known identityuserid 
        ///</summary>
        [TestMethod]
        public void CreateUsersLinksListTestWithUnknownIdentityUserName()
        {
            Console.WriteLine("Before CreateUsersLinksListTestWithUnknownIdentityUserName");

            string identityusername = "Idontexistshahahahaha";
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotLoggedInUser();
            request.AssertWebRequestFailure = false;
            try
            {
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/links?format=xml", _sitename, identityusername);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UserNotFound.ToString(), errorData.Code);

            Console.WriteLine("After CreateUsersLinksListTestWithUnknownIdentityUserName");
        }

        /// <summary>
        /// Test GetUsersLinks method from service with an not known DNAUserId 
        ///</summary>
        [TestMethod]
        public void CreateUsersLinksListTestWithUnknownDNAUserId()
        {
            Console.WriteLine("Before CreateUsersLinksListTestWithUnknownDNAUserId");

            int dnaUserId = 9999999;
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotLoggedInUser();
            request.AssertWebRequestFailure = false;
            try
            {
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/links?idtype=DNAUserId&format=xml", _sitename, dnaUserId);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UserNotFound.ToString(), errorData.Code);

            Console.WriteLine("After CreateUsersLinksListTestWithUnknownDNAUserId");
        }

        [TestMethod]
        public void GetUserInfo_Secure_ForASuperUser_ReturnsTheirSuperStatus()
        {
            Console.WriteLine("Before GetUserInfo_ForASuperUser_ReturnsTheirSuperStatus");

            string url = @"https://" + DnaTestURLRequest.SecureServerAddress + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/DotNetSuperUser?format=xml";

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual("Super", user.StatusAsString);


            Console.WriteLine("After GetUserInfo_ForASuperUser_ReturnsTheirSuperStatus");
        }

        [TestMethod]
        public void GetUserInfo_NonSecure_ForASuperUser_ReturnsUnAuthorised()
        {
            Console.WriteLine("Before GetUserInfo_ForASuperUser_ReturnsTheirSuperStatus");

            string callinguser_url = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/DotNetSuperUser?format=xml";

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();
            request.UseDebugUserSecureCookie = false;
            try
            {
                request.RequestPageWithFullURL(callinguser_url);
            }
            catch { }

            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.NotAuthorized.ToString(), errorData.Code);

            Console.WriteLine("After GetUserInfo_ForASuperUser_ReturnsTheirSuperStatus");
        }

        /// <summary>
        /// Test GetUserInfo with an not known DNAUserId 
        ///</summary>
        [TestMethod]
        public void GetUserInfoWithUnknownDNAUserId()
        {
            Console.WriteLine("Before GetUserInfoWithUnknownDNAUserId");

            int dnaUserId = 9999999;
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();
            try
            {
                string url = String.Format("https://" + DnaTestURLRequest.SecureServerAddress + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}?idtype=DNAUserId&format=xml", _sitename, dnaUserId);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UserNotFound.ToString(), errorData.Code);

            Console.WriteLine("After GetUserInfoWithUnknownDNAUserId");
        }

        /// <summary>
        /// Test GetUsersArticles method from service
        /// </summary>
        [TestMethod]
        public void GetUsersArticlesByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersArticlesByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Articles UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/articles?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticleList);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersArticlesByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersConversations method from service
        /// </summary>
        [TestMethod]
        public void GetUsersConversationsByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersConversationsByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Conversations UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/conversations?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaPostList);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersConversationsByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test GetUsersFriends method from service
        /// </summary>
        [TestMethod]
        public void GetUsersFriendsByDNAUserId_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetUsersFriendsByDNAUserId_ReadOnly_ReturnsValidXml");

            int[] userIds = { 6, 42, 128652, 225620, 551837, 1090501859 };

            foreach (var id in userIds)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validating Users Friends List UserID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/friends?idtype=DNAUserId&format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaFriendsList);
                validator.Validate();
            }
            Console.WriteLine("After GetUsersFriendsByDNAUserId_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test UpdateUsersSiteSuffix method from service
        /// </summary>
        [TestMethod]
        public void UpdateUsersSiteSuffix()
        {
            Console.WriteLine("Before UpdateUsersSiteSuffix");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string siteSuffix = "New Site Suffix" + DateTime.Now.ToShortDateString();

            string postData = String.Format("siteSuffix={0}",
                 HttpUtility.HtmlEncode(siteSuffix));

            string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/callinguser/userdetails/create.htm", _sitename);

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", null, localHeaders);

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            request.RequestPageWithFullURL(callinguser_url);
            // Check to make sure that the page returned with the correct information
            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual(siteSuffix, user.SiteSuffix);

            Console.WriteLine("After UpdateUsersSiteSuffix");
        }
        /// <summary>
        /// Test UpdateUsersAcceptSubscriptions method from service
        /// </summary>
        [TestMethod]
        public void UpdateUsersAcceptSubscriptions()
        {
            Console.WriteLine("Before UpdateUsersAcceptSubscriptions");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/callinguser/acceptsubscriptions", _sitename);
            string postData = "No data to send";

            request.RequestPageWithFullURL(url, postData, "text/xml");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            request.RequestPageWithFullURL(callinguserfull_secure_url);
            // Check to make sure that the page returned with the correct information
            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual(true, user.AcceptSubscriptions);

            url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/callinguser/acceptsubscriptions/remove", _sitename);

            request.RequestPageWithFullURL(url, postData, "text/xml");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            request.RequestPageWithFullURL(callinguser_url);
            // Check to make sure that the page returned with the correct information
            user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual(false, user.AcceptSubscriptions);

            Console.WriteLine("After UpdateUsersAcceptSubscriptions");
        }

        /// <summary>
        /// Test AddFriend method from service
        /// </summary>
        [TestMethod]
        public void AddFriendTest()
        {
            Console.WriteLine("Before AddFriendTest");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            int dnaUserId = 1090501859;
            int friendId = 6;
            string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/friends/{2}/add?idtype=dnauserid", _sitename, dnaUserId, friendId);
            string postData = "No data to send";

            // now get the response
            request.RequestPageWithFullURL(url, postData, "text/xml", "POST");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After AddFriendTest");
        }
        /// <summary>
        /// Test DeleteFriend method from service
        /// </summary>
        [TestMethod]
        public void DeleteFriendTest()
        {
            Console.WriteLine("Before DeleteFriendTest");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            int dnaUserId = 1090501859;
            int friendId = 6;
            string postData = "No data to send";

            string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/friends/{2}/delete?idtype=dnauserid", _sitename, dnaUserId, friendId);

            // now get the response
            request.RequestPageWithFullURL(url, postData, "text/xml", "POST");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After DeleteFriendTest");
        }
        /// <summary>
        /// Test DeleteLink method from service
        /// </summary>
        [TestMethod]
        public void DeleteLinkTest()
        {
            Console.WriteLine("Before DeleteLinkTest");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string link = "1";
            string name = "DotNetNormalUser";
            string postData = "No data to send";

            //Get the links
            //string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/links?format=xml", _sitename, name);
            // now get the response
            //request.RequestPageWithFullURL(url, null, "text/xml");


            string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/links/{2}/delete", _sitename, name, link);

            // now get the response
            request.RequestPageWithFullURL(url, postData, "text/xml", "POST");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After DeleteLinkTest");
        }
        /// <summary>
        /// Test BlockUserTest method from service
        /// </summary>
        [TestMethod]
        public void BlockUserTest()
        {
            Console.WriteLine("Before BlockUserTest");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            int dnaUserId = 1090501859;
            int blockId = 6;
            string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/blockedusers/{2}/block?idtype=dnauserid", _sitename, dnaUserId, blockId);

            // now get the response
            request.RequestPageWithFullURL(url, "No data to Send", "text/xml", "POST");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After BlockUserTest");
        }
        /// <summary>
        /// Test UnblockUserTest method from service
        /// </summary>
        [TestMethod]
        public void UnblockUserTest()
        {
            Console.WriteLine("Before UnblockUserTest");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            int dnaUserId = 1090501859;
            int unblockId = 6;

            //Block user 6 first
            string url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/blockedusers/{2}/block?idtype=dnauserid", _sitename, dnaUserId, unblockId);

            // now get the response
            request.RequestPageWithFullURL(url, "No data to Send", "text/xml", "POST");

            //Unblock 
            url = String.Format("http://" + _server + "/dna/api/users/UsersService.svc/V1/site/{0}/users/{1}/blockedusers/{2}/unblock?idtype=dnauserid", _sitename, dnaUserId, unblockId);

            // now get the response
            request.RequestPageWithFullURL(url, String.Empty, String.Empty, "POST");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After UnblockUserTest");
        }
    }
}
