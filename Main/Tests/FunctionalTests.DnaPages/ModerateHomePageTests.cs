using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using TestUtils;

namespace FunctionalTests
{
    [TestClass]
    public class ModerateHomePageTests
    {
        [TestInitialize]
        public void Startup()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Check Normal User Does not have access .
        /// </summary>
        [Ignore]
        public void TestModerateHomePageNonModerator()
        {
            Console.WriteLine("Before ModerateHome Page Tests - TestModerateHomePageNonModerator");
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"NModerate?skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
            Console.WriteLine("After ModerateHome Page Tests - TestModerateHomePageNonModerator");
        }

        /// <summary>
        /// Check the page cannot be access
        /// </summary>
        [Ignore]
        public void TestModerateHomePageNonSecure()
        {
            Console.WriteLine("Before ModerateHome Page Tests - TestModerateHomePageNonSecure");
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"NModerate?skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
            Console.WriteLine("After ModerateHome Page Tests - TestModerateHomePageNonSecure");
        }

        /// <summary>
        /// Check the page cannot be access
        /// </summary>
        [Ignore]
        public void TestModerateHomePageSecure()
        {
            Console.WriteLine("Before ModerateHome Page Tests - TestModerateHomePageSecure");
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");

            Cookie cookie;
            string testUserName;
            SetupIdentityEditorUser(request, out cookie, out testUserName);

            request.RequestSecurePage(@"NModerate?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();

            TestUserCreator.DeleteIdentityUser(cookie, testUserName);
            request.Dispose();
            Console.WriteLine("After ModerateHome Page Tests - TestModerateHomePageSecure");
        }

        /// <summary>
        /// Check the Xml Schema.
        /// </summary>
        [Ignore]
        public void TestModerateHomePageXml()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            //Cookie cookie;
            //string testUserName;
            //SetupIdentityEditorUser(request, out cookie, out testUserName);
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();            
            request.RequestSecurePage(@"NModerate?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "H2G2ModerateHome.xsd");
            validator.Validate();

            //TestUserCreator.DeleteIdentityUser(cookie, testUserName);
        }


        /// <summary>
        /// Check the Xml Schema.
        /// </summary>
        [Ignore]
        public void TestModerateHomePageUnlockAll()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            Cookie cookie;
            string testUserName;
            SetupIdentityEditorUser(request, out cookie, out testUserName);
/*
            modHomeParams.UnlockForums = InputContext.DoesParamExist("UnlockForums", _docDnaUnlockForums);
            modHomeParams.UnlockForumReferrals = InputContext.DoesParamExist("UnlockForumReferrals", _docDnaUnlockForumReferrals);
            modHomeParams.UnlockUserPosts = InputContext.DoesParamExist("UnlockUserPosts", _docDnaUnlockUserPosts);
            modHomeParams.UnlockSitePosts = InputContext.DoesParamExist("UnlockSitePosts", _docDnaUnlockSitePosts);
            modHomeParams.UnlockAllPosts = InputContext.DoesParamExist("UnlockAllPosts", _docDnaUnlockAllPosts);
            modHomeParams.UnlockArticles = InputContext.DoesParamExist("UnlockArticles", _docDnaUnlockArticles);
            modHomeParams.UnlockArticleReferrals = InputContext.DoesParamExist("UnlockArticleReferrals", _docDnaUnlockArticleReferrals);
            modHomeParams.UnlockGeneral = InputContext.DoesParamExist("UnlockGeneral", _docDnaUnlockGeneral);
            modHomeParams.UnlockGeneralReferrals = InputContext.DoesParamExist("UnlockGeneralReferrals", _docDnaUnlockGeneralReferrals);
            modHomeParams.UnlockNicknames = InputContext.DoesParamExist("UnlockNicknames", _docDnaUnlockNicknames);
            modHomeParams.UnlockAll = InputContext.DoesParamExist("UnlockAll", _docDnaUnlockAll);
*/
            request.RequestSecurePage(@"NModerate?UnlockForums=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockForumReferrals=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockUserPosts=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockSitePosts=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockAllPosts=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockArticles=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockArticleReferrals=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockGeneral=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockGeneralReferrals=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockNicknames=1&skin=purexml");
            request.RequestSecurePage(@"NModerate?UnlockAll=1&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();

            TestUserCreator.DeleteIdentityUser(cookie, testUserName);
            request.Dispose();
        }

















        private void SetupIdentityEditorUser(DnaTestURLRequest request, out Cookie cookie, out string testUserName)
        {
            request.UseEditorAuthentication = true;

            SetUpForIdentity(request);

            testUserName = CreateIdentityEditorUser(request);
            string returnedCookie = request.CurrentCookie;
            cookie = new Cookie("IDENTITY", returnedCookie, "/", ".bbc.co.uk");

            request.RequestPage("dnasignal?action=recache-groups&skin=purexml&userid=" + request.CurrentUserID.ToString());
            XmlDocument xml = request.GetLastResponseAsXML();
        }

        private static string CreateIdentityEditorUser(DnaTestURLRequest request)
        {
            string userName = "dnatester";
            string password = "123456789";
            string dob = "1972-09-07";
            string email = "a@b.com";

            string testUserName = String.Empty;

            // Create a unique name and email for the test
            testUserName = userName + DateTime.Now.Ticks.ToString();
            email = testUserName + "@bbc.co.uk";

            request.SetCurrentUserAsNewIdentityUser(testUserName, password, "", email, dob, TestUserCreator.IdentityPolicies.Adult, "haveyoursay", TestUserCreator.UserType.Editor);

            return testUserName;
        }

        private void SetUpForIdentity(DnaTestURLRequest request)
        {
            int siteID = 0;
            string urlstatus = "status-n?skin=purexml";
            request.RequestPage(urlstatus);
            XmlDocument xml = request.GetLastResponseAsXML();
            XmlNode xmlNode = xml.SelectSingleNode("/H2G2/SITE/@ID");

            siteID = Convert.ToInt32(xmlNode.Value);

            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                StringBuilder sql = new StringBuilder("exec setsiteoption " + siteID.ToString() + ", 'SignIn','UseIdentitySignIn','1'");
                sql.AppendLine("UPDATE Sites SET IdentityPolicy='http://identity/policies/dna/adult' WHERE SiteID=" + siteID.ToString());
                reader.ExecuteDEBUGONLY(sql.ToString());
            }

            urlstatus = "dnasignal?action=recache-site&skin=purexml";
            request.RequestPage(urlstatus);
            xml = request.GetLastResponseAsXML();
        }
    }
}
