using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace RipleyTests
{
    /// <summary>
    /// </summary>
    [TestClass]
    public class UserPageTests
    {
        private SiteOptionList  _siteOptionList;
        private AppContext      _appContext;
        private bool            _includeContentFromOtherSites;
        private int _siteId = 0;
        private int _forumId = 0;

        /// <summary>
        /// Create a post on h2g2 and a post on have your say.
        /// Set up the site option IncludeContentFromOtherSites so that posts from other sites are disallowed.
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                _appContext = new AppContext(TestConfig.GetConfig().GetRipleyServerPath());
                _siteOptionList = new SiteOptionList();
                _siteOptionList.CreateFromDatabase(inputcontext.ReaderCreator, inputcontext.dnaDiagnostics);
            }
            
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            IInputContext inputContext = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = inputContext.CreateDnaDataReader(""))
            {
                SetSiteID(dataReader, "h2g2");

                _includeContentFromOtherSites = _siteOptionList.GetValueBool(_siteId, "PersonalSpace", "IncludeContentFromOtherSites");

                //Create a post on h2g2
                SetForumID(dataReader);
                request = new DnaTestURLRequest("h2g2");
                request.SetCurrentUserNormal();
                int id = request.CurrentUserID;
                request.RequestPage("AddThread?subject=test&body=blahblah&post=1&skin=purexml&forum=" + Convert.ToString(_forumId));

                //Create a post on have your say.
                SetSiteID(dataReader, "haveyoursay");
                SetForumID(dataReader);
                request = new DnaTestURLRequest("haveyoursay");
                request.SetCurrentUserNormal();
                request.RequestPage("AddThread?subject=test&body=blahblah&post=1&skin=purexml&forum=" + Convert.ToString(_forumId));
            }
        }

        /// <summary>
        /// Reset the IncludeContentFromOtherSites site option to its initial state.
        /// </summary>
        [TestCleanup]
        public void TearDown()
        {
            if (_siteOptionList.GetValueBool(_siteId, "PersonalSpace", "IncludeContentFromOtherSites") !=  _includeContentFromOtherSites)
            {
                using (FullInputContext inputcontext = new FullInputContext(""))
                {
                    //Reset to initial value.
                    _siteOptionList.SetValueBool(_siteId, "PersonalSpace", "IncludeContentFromOtherSites", _includeContentFromOtherSites, inputcontext.ReaderCreator, inputcontext.dnaDiagnostics);
                }
                
                //Recache Site Data.
                DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
                request.SetCurrentUserNormal();
                int id = request.CurrentUserID;
                request.RequestPage("U" + id.ToString() + "?_ns=1&skin=purexml");
            }
        }

        /// <summary>
        /// Test Recent Posts for a site that does not include content from other sites.
        /// Expect Only posts for the current site to be returned.
        /// </summary>
        [TestMethod]
        public void TestRecentPostsForCurrentSiteOnly()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            
            //Want to test content from the current site only
            //Clear IncludeContentFromOtherSites option
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                _siteOptionList.SetValueBool(_siteId, "PersonalSpace", "IncludeContentFromOtherSites", false, inputcontext.ReaderCreator, inputcontext.dnaDiagnostics);
            }

            int id = request.CurrentUserID;

            request.RequestPage("U" + id.ToString() + "?_ns=1&Skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();
            XmlNode node = doc.SelectSingleNode("H2G2/RECENT-POSTS/POST-LIST/POST[SITEID!='" + _siteId.ToString() + "']");
            Assert.IsNull(node,"Post Returned from another site.");
        }

        /// <summary>
        /// Test Recent Posts for a site that does include content from other sites.
        /// Expect posts for all public sites to be returned if posts.
        /// </summary>
        [TestMethod]
        public void TestRecentPosts()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            //Want to test content from the current site only
            //Clear IncludeContentFromOtherSites option
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                _siteOptionList.SetValueBool(_siteId, "PersonalSpace", "IncludeContentFromOtherSites", true, inputcontext.ReaderCreator, inputcontext.dnaDiagnostics);
            }

            int id = request.CurrentUserID;

            request.RequestPage("U" + id.ToString() + "?_ns=1&Skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();
            XmlNode node = doc.SelectSingleNode("H2G2/RECENT-POSTS/POST-LIST/POST[SITEID='" + _siteId.ToString() + "']");
            Assert.IsNotNull(node, "Not found a post from haveyoursay.");
            node = doc.SelectSingleNode("H2G2/RECENT-POSTS/POST-LIST/POST[SITEID='1']");
            Assert.IsNotNull(node, "Not found a post from h2g2.");
        }

        private void SetSiteID(IDnaDataReader dataReader, String urlname)
        {
            dataReader.ExecuteDEBUGONLY("select siteid from sites where urlname='" + urlname + "'");

            if (dataReader.Read())
            {
                _siteId = dataReader.GetInt32("SiteID");
            }
            else
            {
                Assert.Fail("Unable to read the Sites table");
            }
        }

        private void SetForumID(IDnaDataReader dataReader)
        {
            dataReader.ExecuteDEBUGONLY("select forumid from forums where canread = 1 and canwrite=1 and siteid =" + Convert.ToString(_siteId) );

            if (dataReader.Read())
            {
                _forumId = dataReader.GetInt32("ForumID");
            }
            else
            {
                Assert.Fail("Unable to find a forum for site");
            }
        }

    }
}
