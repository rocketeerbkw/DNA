using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Groups;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Moderation.Utils;
using TestUtils;
using System.Net;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Users project
    /// </summary>
   [TestClass]
    public class MBAdminTests
    {
        //private int _threadId = 34;
        //private int _forumId = 7325075;
        //private int _inReplyTo = 61;
        private int _siteId = 70;//mbiplayer
        private string _siteName = "mbiplayer";
        private int _userId = TestUserAccounts.GetNormalUserAccount.UserID;


        /// <summary>
        /// Setup fixtures
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            try
            {
                //SnapshotInitialisation.ForceRestore();
            }
            catch { }
        }

        [TestCleanup]
        public void TearDown()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("delete from previewconfig where siteid=" + _siteId);
                dataReader.ExecuteDEBUGONLY("delete from topics where siteid=" + _siteId);
                dataReader.ExecuteDEBUGONLY("delete from frontpageelements where siteid=" + _siteId);
            }
          
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_AsNormalUser_ReturnsForbidden()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            try
            {
                request.RequestPage("mbadmin");
            }
            catch(Exception e)
            {
                Assert.IsTrue(e.Message.IndexOf("(401) Unauthorized") > 0);
            }
            
        }


        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_AsEditor_CorrectXml()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("mbadmin?skin=purexml");

            CheckPageSchema(request.GetLastResponseAsXML());

        }

        [TestMethod]
        public void MBAdmin_UpdatePreviewIncorrectEditKey_CorrectError()
        {
            var expectedType = "SiteConfigUpdateInvalidKey";

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("editkey", Guid.NewGuid().ToString()));
            


            request.RequestPage("mbadmin?cmd=UPDATEPREVIEW&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckError(request.GetLastResponseAsXML(), expectedType);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewInvalidHeaderColour_CorrectError()
        {
            var expectedType = "InvalidHeaderColour";
            var updateType = "HEADER_COLOUR";
            var updateValue = "";

            UpdatePreviewInvalidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidHeaderColour_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "HEADER_COLOUR";
            var updateValue = "RED";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewInvalidTopicLayout_CorrectError()
        {
            var expectedType = "InvalidTopicLayout";
            var updateType = "TOPICLAYOUT";
            var updateValue = "";

            UpdatePreviewInvalidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidTopicLayout_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "TOPICLAYOUT";
            var updateValue = "1Col";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewInvalidWelcomeMessage_CorrectError()
        {
            var expectedType = "InvalidWelcomeMessage";
            var updateType = "WELCOME_MESSAGE";
            var updateValue = "";

            UpdatePreviewInvalidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidWelcomeMessage_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "WELCOME_MESSAGE";
            var updateValue = "welcome message";

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("mbadmin?skin=purexml");

            var editKey = CheckPageSchema(request.GetLastResponseAsXML());

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("editkey", editKey));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));


            request.RequestPage("mbadmin?cmd=UPDATEPREVIEW&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckResult(request.GetLastResponseAsXML(), expectedType);
            CheckV2Config(request.GetLastResponseAsXML(), updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewInvalidAboutMessage_CorrectError()
        {
            var expectedType = "InvalidAboutMessage";
            var updateType = "ABOUT_MESSAGE";
            var updateValue = "";

            UpdatePreviewInvalidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidAboutMessage_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "ABOUT_MESSAGE";
            var updateValue = "welcome message";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewInvalidOpenCloseTimesText_CorrectError()
        {
            var expectedType = "InvalidOpenCloseMessage";
            var updateType = "OPENCLOSETIMES_TEXT";
            var updateValue = "";

            UpdatePreviewInvalidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidOpenCloseTimesText_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "OPENCLOSETIMES_TEXT";
            var updateValue = "welcome message";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewInvalidFooterColour_CorrectError()
        {
            var expectedType = "InvalidFooterColour";
            var updateType = "FOOTER_COLOUR";
            var updateValue = "";

            UpdatePreviewInvalidRequest(expectedType, updateType, updateValue);


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidFooterColour_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "FOOTER_COLOUR";
            var updateValue = "red";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue, "FOOTER/COLOUR");


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidBannerSsi_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "BANNER_SSI";
            var updateValue = "testbanner.ssi";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidHorizontalNavSsi_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "HORIZONTAL_NAV_SSI";
            var updateValue = "testbanner.ssi";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidLeftNavSsi_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "LEFT_NAV_SSI";
            var updateValue = "testbanner.ssi";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidCssLocation_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "CSS_LOCATION";
            var updateValue = "red";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidEmoticonLocation_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "EMOTICON_LOCATION";
            var updateValue = "red";

            UpdatePeviewValidRequest(expectedType, updateType, updateValue);


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidRecentDiscussions_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "RECENTDISCUSSIONS";
            var updateValue = "1";

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("mbadmin?skin=purexml");

            var editKey = CheckPageSchema(request.GetLastResponseAsXML());

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("editkey", editKey));
            postParams.Enqueue(new KeyValuePair<string, string>("RECENTDISCUSSIONS_SUBMIT", "on"));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));


            request.RequestPage("mbadmin?cmd=UPDATEPREVIEW&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckResult(request.GetLastResponseAsXML(), expectedType);
            CheckV2Config(request.GetLastResponseAsXML(), updateType, updateValue);


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidSocialToolbar_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "SOCIALTOOLBAR";
            var updateValue = "1";

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("mbadmin?skin=purexml");

            var editKey = CheckPageSchema(request.GetLastResponseAsXML());

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("editkey", editKey));
            postParams.Enqueue(new KeyValuePair<string, string>("SOCIALTOOLBAR_SUBMIT", "on"));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));


            request.RequestPage("mbadmin?cmd=UPDATEPREVIEW&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckResult(request.GetLastResponseAsXML(), expectedType);
            CheckV2Config(request.GetLastResponseAsXML(), updateType, updateValue);


        }


        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidFooterLink_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "FOOTER_LINK";
            var updateValue = "footer link";

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("mbadmin?skin=purexml");

            var editKey = CheckPageSchema(request.GetLastResponseAsXML());

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("editkey", editKey));
            postParams.Enqueue(new KeyValuePair<string, string>("SOCIALTOOLBAR_SUBMIT", "on"));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));


            request.RequestPage("mbadmin?cmd=UPDATEPREVIEW&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckResult(request.GetLastResponseAsXML(), expectedType);
            CheckV2Config(request.GetLastResponseAsXML(), "FOOTER/LINKS/LINK", updateValue);


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdatePreviewValidModuleLink_CorrectUpdate()
        {
            var expectedType = "SiteConfigUpdateSuccess";
            var updateType = "MODULE_LINK";
            var updateValue = "footer link";

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("mbadmin?skin=purexml");

            var editKey = CheckPageSchema(request.GetLastResponseAsXML());

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("editkey", editKey));
            postParams.Enqueue(new KeyValuePair<string, string>("SOCIALTOOLBAR_SUBMIT", "on"));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));


            request.RequestPage("mbadmin?cmd=UPDATEPREVIEW&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckResult(request.GetLastResponseAsXML(), expectedType);
            CheckV2Config(request.GetLastResponseAsXML(), "MODULES/LINKS/LINK", updateValue);


        }

        /// <summary/>
        [TestMethod]
        public void MBAdmin_UpdateTopicNewTopic_CorrectUpdate()
        {
            var expectedType = "TopicCreateSuccessful";
            var fpTitleValue = "fp title";
            var fpText = "fp text";
            var fpImagename = "fp_imagename.jpg";
            var fpImagealttext = "fp_imagealttext";
            var topicTitle = "topictitle";
            var topicText = "topictext";

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
           
            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("fp_title", fpTitleValue));
            postParams.Enqueue(new KeyValuePair<string, string>("fp_text", fpText));
            postParams.Enqueue(new KeyValuePair<string, string>("fp_imagename", fpImagename));
            postParams.Enqueue(new KeyValuePair<string, string>("fp_imagealttext", fpImagealttext));
            postParams.Enqueue(new KeyValuePair<string, string>("topictitle", topicTitle));
            postParams.Enqueue(new KeyValuePair<string, string>("topictext", topicText));
            


            request.RequestPage("mbadmin?cmd=UPDATETOPIC&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckResult(request.GetLastResponseAsXML(), expectedType);

            var xml = request.GetLastResponseAsXML();
            Assert.AreEqual(1, xml.SelectNodes("//H2G2/TOPIC_PAGE").Count);
            Assert.AreEqual(topicTitle, xml.SelectSingleNode("//H2G2/TOPIC_PAGE/TOPICLIST/TOPIC/TITLE").InnerText);
            Assert.AreEqual(fpTitleValue, xml.SelectSingleNode("//H2G2/TOPIC_PAGE/TOPICLIST/TOPIC/FRONTPAGEELEMENT/TITLE").InnerText);
            Assert.AreEqual(fpImagename, xml.SelectSingleNode("//H2G2/TOPIC_PAGE/TOPICLIST/TOPIC/FRONTPAGEELEMENT/IMAGENAME").InnerText);
            Assert.AreEqual(fpImagealttext, xml.SelectSingleNode("//H2G2/TOPIC_PAGE/TOPICLIST/TOPIC/FRONTPAGEELEMENT/IMAGEALTTEXT").InnerText);

        }

       

        private void CheckV2Config(XmlDocument xml, string updateType, string updateValue)
        {
            Assert.IsNotNull(xml.SelectSingleNode("//H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/" + updateType.ToUpper()));
            Assert.IsNotNull(xml.SelectSingleNode("//H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/" + updateType.ToUpper()).InnerText = updateValue);
        }

        private void CheckError(XmlDocument xml, string expectedType)
        {
            Assert.IsNull(xml.SelectSingleNode("//H2G2/RESULT"));
            Assert.IsNotNull(xml.SelectSingleNode("//H2G2/ERROR"));
            var validator = new DnaXmlValidator(xml.SelectSingleNode("//H2G2/ERROR").OuterXml, "error.xsd");
            validator.Validate();

            Assert.AreEqual(expectedType, xml.SelectSingleNode("//H2G2/ERROR").Attributes["TYPE"].Value);
        }

        private void CheckResult(XmlDocument xml, string expectedType)
        {
            Assert.IsNotNull(xml.SelectSingleNode("//H2G2/RESULT"));
            Assert.IsNull(xml.SelectSingleNode("//H2G2/ERROR"));
            var validator = new DnaXmlValidator(xml.SelectSingleNode("//H2G2/RESULT").OuterXml, "Result.xsd");
            validator.Validate();

            Assert.AreEqual(expectedType, xml.SelectSingleNode("//H2G2/RESULT").Attributes["TYPE"].Value);
        }

        private string CheckPageSchema(XmlDocument xml)
       {
           Assert.IsNotNull(xml.SelectSingleNode("//H2G2/SITECONFIGPREVIEW"));
           var validator = new DnaXmlValidator(xml.SelectSingleNode("//H2G2/SITECONFIGPREVIEW/SITECONFIG").OuterXml, "SiteConfig_V2Boards.xsd");
           validator.Validate();

           Assert.IsNotNull(xml.SelectSingleNode("//H2G2/TOPIC_PAGE"));
           validator = new DnaXmlValidator(xml.SelectSingleNode("//H2G2/TOPIC_PAGE").OuterXml, "TopicPage.xsd");
           validator.Validate();

           return xml.SelectSingleNode("//H2G2/SITECONFIGPREVIEW/EDITKEY").InnerText;
       }

        private void UpdatePreviewInvalidRequest(string expectedType, string updateType, string updateValue)
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("mbadmin?skin=purexml");

            var editKey = CheckPageSchema(request.GetLastResponseAsXML());

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("editkey", editKey));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));


            request.RequestPage("mbadmin?cmd=UPDATEPREVIEW&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckError(request.GetLastResponseAsXML(), expectedType);
        }

        private void UpdatePeviewValidRequest(string expectedType, string updateType, string updateValue)
        {
            UpdatePeviewValidRequest(expectedType, updateType, updateValue, updateType);
        }

        private void UpdatePeviewValidRequest(string expectedType, string updateType, string updateValue, string xPath)
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage("mbadmin?skin=purexml");

            var editKey = CheckPageSchema(request.GetLastResponseAsXML());

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("editkey", editKey));
            postParams.Enqueue(new KeyValuePair<string, string>(updateType, updateValue));


            request.RequestPage("mbadmin?cmd=UPDATEPREVIEW&skin=purexml", postParams);
            CheckPageSchema(request.GetLastResponseAsXML());
            CheckResult(request.GetLastResponseAsXML(), expectedType);
            CheckV2Config(request.GetLastResponseAsXML(), xPath, updateValue);
        }

        
    }
}
