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
        [TestMethod]
        public void TestModerateHomePageNonModerator()
        {
            Console.WriteLine("Before moderationhome Page Tests - TestModerateHomePageNonModerator");
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"moderationhome?skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
            Console.WriteLine("After moderationhome Page Tests - TestModerateHomePageNonModerator");
        }

        /// <summary>
        /// Check the page cannot be access
        /// </summary>
        [TestMethod]
        public void TestModerateHomePageNonSecure()
        {
            Console.WriteLine("Before moderationhome Page Tests - TestModerateHomePageNonSecure");
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserEditor();
            request.UseDebugUserSecureCookie = false;
            request.RequestPage(@"moderationhome?skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
            Console.WriteLine("After moderationhome Page Tests - TestModerateHomePageNonSecure");
        }

        /// <summary>
        /// Check the page cannot be access
        /// </summary>
        [TestMethod]
        public void TestModerateHomePageSecure()
        {
            Console.WriteLine("Before moderationhome Page Tests - TestModerateHomePageSecure");
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();  

            request.RequestSecurePage(@"moderationhome?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();

            Console.WriteLine("After moderationhome Page Tests - TestModerateHomePageSecure");
        }

        /// <summary>
        /// Check the Xml Schema.
        /// </summary>
        [TestMethod]
        public void TestModerateHomePageXml()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            //Cookie cookie;
            //string testUserName;
            //SetupIdentityEditorUser(request, out cookie, out testUserName);
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();            
            request.RequestSecurePage(@"moderationhome?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "H2G2ModerateHome.xsd");
            validator.Validate();

            //TestUserCreator.DeleteIdentityUser(cookie, testUserName);
        }


        /// <summary>
        /// Check the Xml Schema.
        /// </summary>
        [TestMethod]
        public void TestModerateHomePageUnlockAll()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();     
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
            request.RequestSecurePage(@"moderationhome?UnlockForums=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockForumReferrals=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockUserPosts=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockSitePosts=1&skin=purexml&siteid=1");
            request.RequestSecurePage(@"moderationhome?UnlockAllPosts=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockArticles=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockArticleReferrals=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockGeneral=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockGeneralReferrals=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockNicknames=1&skin=purexml");
            request.RequestSecurePage(@"moderationhome?UnlockAll=1&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
        }

    }
}
