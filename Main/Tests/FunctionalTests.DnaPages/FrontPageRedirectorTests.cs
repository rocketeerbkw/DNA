using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Moderation.Utils;
using TestUtils;
using System.Web;


namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Users project
    /// </summary>
    [TestClass]
    public class FrontPageRedirectorTests
    {
        private int _siteId = 70;//mbiplayer
        private string _siteName = "mbiplayer";

        [TestInitialize]
        public void Setup()
        {
            try
            {
                SnapshotInitialisation.RestoreFromSnapshot();
            }
            catch { }
        }

        [TestCleanup]
        public void TearDown()
        {


        }

        [TestMethod]
        public void FrontPageRedirector_NoSiteOption_RedirectsToCPlusHome()
        {

            try
            {
                SetSiteOptions("");

                var request = new DnaTestURLRequest(_siteName);
                request.SetCurrentUserNormal();
                request.RequestPage("/", null);

                var lastRequest = request.GetLastResponseAsString();

                Assert.IsTrue(lastRequest.IndexOf("%2fdna%2fmbiplayer%2fhome") > 0);

            }
            finally
            {
                UnSetSiteOptions();
            }

        }

        [TestMethod]
        public void FrontPageRedirector_CustomSkin_RedirectsToCPlusHomeWithSkinInTact()
        {

            try
            {
                SetSiteOptions("");

                var request = new DnaTestURLRequest("h2g2");
                request.SetCurrentUserNormal();
                request.RequestPage("classic/", null);

                var lastRequest = request.GetLastResponseAsString();

                Assert.IsTrue(lastRequest.IndexOf("%2fdna%2fh2g2%2fclassic%2fhome") > 0);

            }
            finally
            {
                UnSetSiteOptions();
            }

        }

        [TestMethod]
        public void FrontPageRedirector_WithRelativePath_RedirectsToRelativePath()
        {

            try
            {
                SetSiteOptions("/my/relative/url");

                var request = new DnaTestURLRequest(_siteName);
                request.SetCurrentUserNormal();
                request.RequestPage("/", null);

                var lastRequest = request.GetLastResponseAsString();

                Assert.IsTrue(lastRequest.IndexOf("%2fmy%2frelative%2furl") > 0);

            }
            finally
            {
                UnSetSiteOptions();
            }

        }

        [TestMethod]
        public void FrontPageRedirector_WithFullQualifiedPath_RedirectsToPath()
        {

            try
            {
                SetSiteOptions("http://www.bbc.co.uk/");

                var request = new DnaTestURLRequest(_siteName);
                request.SetCurrentUserNormal();
                request.RequestPage("/", null);

                var lastRequest = request.GetLastResponseAsString();

                Assert.IsTrue(lastRequest.IndexOf("http://www.bbc.co.uk/") > 0);

            }
            finally
            {
                UnSetSiteOptions();
            }

        }

        [TestMethod]
        public void FrontPageRedirector_WithASPXBuilder_RedirectsASPXBuilder()
        {

            try
            {
                SetSiteOptions("status.aspx");

                var request = new DnaTestURLRequest(_siteName);
                request.SetCurrentUserNormal();
                request.RequestPage("/?skin=purexml", null);

                var lastRequest = request.GetLastResponseAsXML();

                Assert.AreEqual("STATUSPAGE", lastRequest.DocumentElement.Attributes["TYPE"].Value);

            }
            finally
            {
                UnSetSiteOptions();
            }

        }

        [TestMethod]
        public void FrontPageRedirector_WithMBFrontPage_RedirectsMBFrontPage()
        {

            try
            {
                SetSiteOptions("mbfrontpage.aspx");

                var request = new DnaTestURLRequest(_siteName);
                request.SetCurrentUserNormal();
                request.RequestPage("/?skin=purexml", null);

                var lastRequest = request.GetLastResponseAsXML();

                Assert.AreEqual("FRONTPAGE", lastRequest.DocumentElement.Attributes["TYPE"].Value);

            }
            finally
            {
                UnSetSiteOptions();
            }

        }

        [TestMethod]
        public void FrontPageRedirector_WithMBFrontPageAndNoForwardSlash_RedirectsMBFrontPage()
        {

            try
            {
                SetSiteOptions("mbfrontpage.aspx");

                var request = new DnaTestURLRequest(_siteName);
                request.SetCurrentUserNormal();
                request.RequestPage("?skin=purexml", null);

                var lastRequest = request.GetLastResponseAsXML();

                Assert.AreEqual("FRONTPAGE", lastRequest.DocumentElement.Attributes["TYPE"].Value);

            }
            finally
            {
                UnSetSiteOptions();
            }

        }


        private void SetSiteOptions(string location)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='FrontPageLocation'", _siteId));
                if (!String.IsNullOrEmpty(location))
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into siteoptions (section, siteid, name, value, type,description) values ('General',{0},'FrontPageLocation', '{1}', 2, 'test')", _siteId, location));
                }


            }

            SendSignal();

        }

        private void UnSetSiteOptions()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='FrontPageLocation'", _siteId));
            }

            SendSignal();
        }


        private void SendSignal()
        {
            var url = String.Format("http://{0}/dna/h2g2/dnaSignal?action=recache-site", DnaTestURLRequest.CurrentServer);
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(url, null, "text/xml");


        }

    }
}
