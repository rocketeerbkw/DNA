using System;
using System.Collections.Generic;
using System.Text;

using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Threading;



namespace RipleyTests
{
    [TestClass]
    public class MessageBoardScheduleTests
    {
        String topicPreviewID;
        String topicForumID;
        String topicName;
        String topicEditKey;

        [TestMethod]
        public void aaCreateTopic()
        {
            Console.WriteLine("Before aaCreateTopic");
            topicName = "CreateTopic" + Convert.ToString(DateTime.Now.Ticks);
            string url = "TopicBuilder?_msfinish=yes&_msstage=1&_msxml=+%0D%0A%09%3CMULTI-INPUT%3E%0D%0A%09%09%3CREQUIRED+NAME%3D%27TITLE%27%3E%3CVALIDATE+TYPE%3D%27EMPTY%27+%2F%3E%3C%2FREQUIRED%3E%0D%0A%09%09%3CREQUIRED+NAME%3D%27TEXT%27%3E%3CVALIDATE+TYPE%3D%27EMPTY%27+%2F%3E%3C%2FREQUIRED%3E%0D%0A%09%09%3CREQUIRED+NAME%3D%27TEXTTYPE%27+%3E%3C%2FREQUIRED%3E%09%09%0D%0A%09%09%3CREQUIRED+NAME%3D%27TOPICID%27%3E%3C%2FREQUIRED%3E%09%0D%0A%09%09%3CREQUIRED+NAME%3D%27EDITKEY%27%3E%3C%2FREQUIRED%3E%09%0D%0A%09%3C%2FMULTI-INPUT%3E%0D%0A+&cmd=create&title=" + topicName + "&text=TestBody" + topicName + "&save=+save++&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/ACTION[TYPE='created']"), "Check Topic Creation");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/ACTION[OBJECT='" + topicName + "']"), "Check Topic Creation");
            Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR"), "Error in Page");

            XmlNode node = doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TITLE='" + topicName + "']/EDITKEY");
            if (node != null)
            {
                topicEditKey = node.InnerText;
            }

            node = doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TITLE='" + topicName + "']/TOPICID");
            if (node != null)
            {
                topicPreviewID = node.InnerText;
            }
            Console.WriteLine("After aaCreateTopic");
        }

        [TestMethod]
        public void bbActivateBoard()
        {
            aaCreateTopic();
            Console.WriteLine("Before bbActivateBoard");
            //Activate Board 
            string url = "Messageboardadmin?cmd=activateboard&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[BOARDACTIVATED='1']"), "Check Board Activated");

            url = "?skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TITLE='" + topicName + "']"), "Check topic published");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TOPICLINKID='" + topicPreviewID + "']"), "Check Preview Topic Link");
            XmlNode node = doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TITLE='" + topicName + "']/FORUMID");
            if (node != null)
            {
                topicForumID = node.InnerText;
            }

            //Check Topic Forum Is Writable.
            url = "F" + topicForumID + "&skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO[FORUMID='" + topicForumID + "']"), "Check Topic ForumId");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS[@CANREAD='1']"), "Check Read Permissions");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS[@CANWRITE='1']"), "Check Write Permissions");

            Console.WriteLine("After bbActivateBoard");
        }

        [TestMethod]
        public void ccTestForumPermissions()
        {
            bbActivateBoard();

            Console.WriteLine("Before ccTestForumPermissions");
            //Need an active topic to get a forumid.
            //TopicBuilderTests topics = new TopicBuilderTests();
            //topics.aaCreateTopic();

            string forumId;
            CheckUserCanPost(out forumId, true);

            CheckForumPermissions(forumId, true, true);

            //Emergency Close Board.
            EmergencyCloseBoard();
            CheckForumPermissions(forumId, true, true);
            RestartBoard();
            CheckForumPermissions(forumId, true, true);
            SetOpenCloseTimes("0", "5", "0", "10");
            CheckForumPermissions(forumId, true, true);

            //ReOpen
            SetOpenCloseTimes("0", "5", "23", "55");

            //Check Normal User Can Post.
            CheckUserCanPost(out forumId, false);
            EmergencyCloseBoard();
            CheckForumPermissions(forumId, false, false);
            RestartBoard();
            CheckForumPermissions(forumId, false, true);
            SetOpenCloseTimes("0", "5", "0", "10");
            CheckForumPermissions(forumId, false, false);

            //ReOpen
            SetOpenCloseTimes("0", "5", "23", "55");

            //Archive Topic.
            //topics.ccArchiveTopic();
            Console.WriteLine("After ccTestForumPermissions");
        }

        [TestMethod]
        public void ddArchiveTopic()
        {
            aaCreateTopic();

            Console.WriteLine("Before ddArchiveTopic");
            string url = "TopicBuilder?cmd=delete&topicid=" + topicPreviewID + "&editkey=" + topicEditKey + "&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/ACTION[TYPE='deleted']"), "Check Topic Archived");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/ACTION[OBJECT='" + topicName + "']"), "Check Topic Archived");
            Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR"), "Error In Page");

            //Activate again
            url = "Messageboardadmin?cmd=activateboard&skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[BOARDACTIVATED='1']"), "Board Activated");

            url = "?skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TITLE='" + topicName + "']"), "Check Topic not Active");
            Console.WriteLine("After ddArchiveTopic");
        }

        [TestMethod]
        public void eeNormalUserPermissions()
        {
            Console.WriteLine("Before eeNormalUserPermissions");
            string url = "MessageBoardSchedule?Skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserNormal();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/ERROR[@CODE='UserNotLoggedInOrAuthorised']"),"Check Normal User Permissions");
            
            url = "MessageBoardSchedule?action=setsitetopicsinactive&confirm=1&skin=purexml";
            urlRequest.SetCurrentUserNormal();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/ERROR[@CODE='UserNotLoggedInOrAuthorised']"), "Check Normal User Permissions");

            url = "MessageBoardSchedule?action=setsitetopicsactive&confirm=1&skin=purexml";
            urlRequest.SetCurrentUserNormal();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/ERROR[@CODE='UserNotLoggedInOrAuthorised']"), "Check Normal User Permissions");

            url = "MessageBoardSchedule?action=update&updatetype=sameeveryday&recurrenteventopenhours=0&recurrenteventopenminutes=5&recurrenteventclosehours=23&recurrenteventcloseminutes=55&skin=purexml";
            urlRequest.SetCurrentUserNormal();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/ERROR[@CODE='UserNotLoggedInOrAuthorised']"), "Check Normal User Permissions - Error On Page");
            Console.WriteLine("After eeNormalUserPermissions");

            //sleep to allow for site signals to go through...
            Thread.Sleep(10000);
        }

        public void EmergencyCloseBoard()
        {
            Console.WriteLine("Before EmergencyCloseBoard");
            string url = "MessageBoardSchedule?skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR[@CODE='UserNotLoggedInOrAuthorised']"), "Check Editor User Permissions");

            url = "MessageBoardSchedule?action=setsitetopicsinactive&confirm=1&skin=purexml";
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR[@CODE='UserNotLoggedInOrAuthorised']"),"Check user authorised");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE[SCHEDULING-REQUEST='CONFIRMEDSETSITETOPICSINACTIVE']"));
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE[SITETOPICSEMERGENCYCLOSED='1']"));

            Console.WriteLine("After EmergencyCloseBoard");
        }

        public void RestartBoard()
        {
            Console.WriteLine("Before RestartBoard");
            string url = "MessageBoardSchedule?action=setsitetopicsactive&confirm=1&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR[@CODE='UserNotLoggedInOrAuthorised']"),"Restart Board");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE[SCHEDULING-REQUEST='CONFIRMEDSETSITETOPICSACTIVE']"),"Restart Board");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE[SITETOPICSEMERGENCYCLOSED='0']"),"Restart Board");
            Console.WriteLine("After RestartBoard");
        }

        private void SetOpenCloseTimes(string ohour, string omin, string chour, string cmin)
        {
            Console.WriteLine("Before SetOpenCloseTimes");
            string url = "MessageBoardSchedule?action=update&updatetype=sameeveryday&recurrenteventopenhours=" + ohour + "&recurrenteventopenminutes=" + omin + "&recurrenteventclosehours=" + chour + "&recurrenteventcloseminutes=" + cmin + "&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR[@CODE='UserNotLoggedInOrAuthorised']"));
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE/SCHEDULE/EVENT[@ACTION='0']/TIME[@HOURS = '" + ohour + "']"), "Set Open Close Times");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE/SCHEDULE/EVENT[@ACTION='0']/TIME[@MINUTES = '" + omin + "']"), "Set Open Close Times");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE/SCHEDULE/EVENT[@ACTION='1']/TIME[@HOURS = '" + chour + "']"), "Set Open Close Times");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE/SCHEDULE/EVENT[@ACTION='1']/TIME[@MINUTES = '" + cmin + "']"), "Set Open Close Times");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/SITETOPICSSCHEDULE[SITETOPICSEMERGENCYCLOSED='0']"), "Set Open Close Times");
            Console.WriteLine("After SetOpenCloseTimes");
        }

        private void CheckUserCanPost(out string forumId, bool editor )
        {
            Console.WriteLine("Before CheckUserCanPost");
            string url = "?skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            if ( editor )
            {
                urlRequest.SetCurrentUserEditor();
            }
            else
            {
                urlRequest.SetCurrentUserNormal();
            }
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            XmlNode node = doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC/FORUMID");
            Assert.IsNotNull(node, "Unable to find topic forum");
            forumId = node.InnerText;

            string post = "Post" + Convert.ToString(DateTime.Now.Ticks);

            //Create Post
            url = "AddThread?Forum=" + forumId + "&body=" + post + "&subject=RipleyTests&post=1&skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[@TYPE='REDIRECT']"), "Expecting Redirect");

            //Check post was created.
            node = doc.SelectSingleNode("H2G2/REDIRECT-TO");
            Assert.IsNotNull(node);
            string redirect = node.InnerText;
            redirect = redirect.Insert(redirect.IndexOf('?') + 1, "skin=purexml&");
            urlRequest.RequestPage(redirect);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADPOSTS/POST[TEXT='" + post + "']"), "Check existence of post");
            Console.WriteLine("After CheckUserCanPost");
        }

        private void CheckForumPermissions(string forumId, bool editor, bool canWrite )
        {
            Console.WriteLine("Before CheckForumPermissions");
            //Check Editor Permissions.
            string url = "F" + forumId + "&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
        
            if (editor)
                urlRequest.SetCurrentUserEditor();
            else
                urlRequest.SetCurrentUserNormal();

            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO[FORUMID='" + forumId + "']"), "Check have user");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS[@CANREAD='1']"), "Check forum CanRead permissions for user");
            if ( editor || canWrite )
                Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS[@CANWRITE='1']"), "Check forum CanWrite permissions for editor");
            else
                Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS[@CANWRITE='0']"), "Check forum CanWrite permissions for user");
            
            //if ( editor || canWrite )
            //    Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS/THREAD[@FORUMID='" + forumId + "' and @CANWRITE='1']"), "Check Thread CanWrite for Editor.");
            //else
            //    Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS/THREAD[@FORUMID='" + forumId + "' and @CANWRITE='0']"), "Check Thread CanWrite for Editor.");
            Console.WriteLine("After CheckForumPermissions");
        }
    }
}

