using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Net;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using System.Xml;

namespace FunctionalTests.Dna.Services.Users
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
        
        private const string _schemaUser = @"Dna.Services.Users\user.xsd";
        private const string _schemaArticle = "Dna.Services.Articles\\article.xsd";
        private const string _schemaForumThreads = "Dna.Services.Forums\\forumThreads.xsd";

        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        public users()
        {
            callinguser_url = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/callinguser?format=xml";
            callinguser_url_json = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/callinguser?format=json";
            callinguser_url_withInvalidSite = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/unknownsite/users/callinguser?format=xml";
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
            request.RequestPageWithFullURL(callinguser_url);

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
            request.RequestPageWithFullURL(callinguser_url);

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
            request.RequestPageWithFullURL(callinguser_url);

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
            request.RequestPageWithFullURL(callinguser_url);

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
            request.RequestPageWithFullURL(callinguser_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.IsNotNull(user.UsersListOfGroups.Find(x => x.Name.ToLower() == "notables"));

            Console.WriteLine("After GetCallingUserInfo_AsModerator_ReturnsNotablesItemInGroup");
        }

        [TestMethod]        
        public void GetCallingUserInfo_AsNotLoggedInUser_Returns401()
        {
            Console.WriteLine("Before GetCallingUserInfo_AsNotLoggedInUser_Returns401");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2"); request.SetCurrentUserNotLoggedInUser();
            request.SetCurrentUserNotLoggedInUser();
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

            Console.WriteLine("After GetCallingUserInfo_AsNotLoggedInUser_Returns401");
        }

        [TestMethod]
        public void GetCallingUserInfo_UnknownSite_Returns404()
        {
            Console.WriteLine("Before GetCallingUserInfo_UnknownSite_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(DnaTestURLRequest.CurrentServer);
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
            request.RequestPageWithFullURL(callinguser_url);

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
            request.RequestPageWithFullURL(callinguser_url);

            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));

            Assert.AreEqual("Super", user.StatusAsString);            
            

            Console.WriteLine("After GetCallingUserInfo_AsSuperUser_ReturnsSuperStatus");
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
    }
}
