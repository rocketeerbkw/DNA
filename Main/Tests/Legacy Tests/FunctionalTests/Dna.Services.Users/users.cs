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

        public users()
        {
            callinguser_url = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/callinguser/xml";
            callinguser_url_json = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/callinguser/json";
            callinguser_url_withInvalidSite = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/site/unknownite/users/callinguser/xml";
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



    }
}
