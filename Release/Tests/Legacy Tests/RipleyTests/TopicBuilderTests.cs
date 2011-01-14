using System;
using System.Collections.Generic;
using System.Text;

using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace RipleyTests
{
    [TestClass]
    public class TopicBuilderTests
    {
        String topicPreviewID;
        String topicID;
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
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/ACTION[TYPE='created']"),"Check Topic Creation");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/ACTION[OBJECT='" + topicName + "']"),"Check Topic Creation");
			Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR"),"Error in Page");

            XmlNode node = doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TITLE='" + topicName + "']/EDITKEY");
            if ( node != null )
            {
                topicEditKey = node.InnerText;
            }

            node = doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TITLE='" + topicName + "']/TOPICID");
            if ( node != null )
            {
                topicPreviewID = node.InnerText;
            }
            Console.WriteLine("After aaCreateTopic");
        }

        [TestMethod]
        public void bbActivateBoard()
        {
            aaCreateTopic();
            Console.WriteLine("Before aaCreateTopic");
            //Activate Board 
            string url = "Messageboardadmin?cmd=activateboard&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
           
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[BOARDACTIVATED='1']"),"Check Board Activated");

            url = "frontpage?skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TITLE='" + topicName + "']"),"Check topic published");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TOPICLINKID='" + topicPreviewID + "']"),"Check Preview Topic Link");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TOPICSTATUS='0']"), "Check status of live topic");
            XmlNode node = doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TITLE='" + topicName + "']/FORUMID");
            if ( node != null )
            {
                topicForumID = node.InnerText;
            }

            node = doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TOPICLINKID='" + topicPreviewID + "']/TOPICID");
            if (node != null)
            {
                topicID = node.InnerText;
            }


            //Check Topic Forum Is Writable.
            url = "F" + topicForumID + "&skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO[FORUMID='" + topicForumID + "']"),"Check Topic ForumId");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS[@CANREAD='1']"),"Check Read Permissions");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS[@CANWRITE='1']"),"Check Write Permissions");

            //Check Topic Status
            url = "topicbuilder?skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID='" + topicPreviewID + "'][TOPICSTATUS='1']"), "Check Status of Topic");
            Console.WriteLine("After bbActivateBoard");
        }

        [TestMethod]
        public void ccArchiveTopic()
        {
            bbActivateBoard();
            Console.WriteLine("Before aaCreateTopic");
            string url = "TopicBuilder?cmd=delete&topicid=" + topicPreviewID + "&editkey=" + topicEditKey + "&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/ACTION[TYPE='deleted']"),"Check Topic Archived");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/ACTION[OBJECT='" + topicName + "']"),"Check Topic Archived");
            Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR"),"Error In Page");

            //Activate again
            url = "Messageboardadmin?cmd=activateboard&skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[BOARDACTIVATED='1']"),"Board Activated");

            url = "frontpage?skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TITLE='" + topicName + "']"),"Check Topic not Active");

            //Check status
            url = "TopicBuilder?skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID='" + topicPreviewID + "'][TOPICSTATUS='4']"), "Chech topic has archive status");
            
            //Check live topic doesn't exist.
            Assert.IsNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID='" + topicID + "']"));
            Console.WriteLine("After ccArchiveTopic");
        }

        [TestMethod]
        public void ddUnArchiveTopic()
        {
            ccArchiveTopic();
            Console.WriteLine("Before aaCreateTopic");
            string url = "TopicBuilder?cmd=unarchive&topicid=" + topicPreviewID + "&skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.UseEditorAuthentication = true;
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();

            //Check for non existence of live topic.
            Assert.IsNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID='" + topicID + "']"));
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID='" + topicPreviewID + "'][TOPICSTATUS='1']"), "Check Status of Unarchived Topic");
            Assert.IsNull(doc.SelectSingleNode("/H2G2/ERROR"), "Error In Page");

            //Activate again
            url = "Messageboardadmin?cmd=activateboard&skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[BOARDACTIVATED='1']"), "Board Activated");

            url = "TopicBuilder?skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICID='" + topicPreviewID + "'][TOPICSTATUS='1']"), "Check Status of Unarchived Topic");
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/TOPICLIST/TOPIC[TOPICID='" + topicID + "'][TOPICSTATUS='0']"),"Check Status of Unarchived Topic");

            Console.WriteLine("After ddUnArchiveTopic");

        }
    }
}
