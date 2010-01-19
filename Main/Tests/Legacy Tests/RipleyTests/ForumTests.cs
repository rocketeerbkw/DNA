using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;




namespace RipleyTests
{
    [TestClass]
    public class ForumTests
    {
        string threadId;
        string forumId = "7618985";
        public ForumTests()
        { }

        [TestInitialize]
        public void SetUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        [TestMethod]
        public void aaPost()
        {
            Console.WriteLine("Before aaPost");
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserNormal();

            //Create Post
            string post = "Post" + Convert.ToString(DateTime.Now.Ticks);
            string url = "AddThread?Forum=" + forumId + "&body=" + post + "&subject=RipleyTests&post=1&skin=purexml";
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[@TYPE='REDIRECT']"), "Check normal user can post - Expecting Redirect");

            //Check post was created.
            XmlNode node = doc.SelectSingleNode("H2G2/REDIRECT-TO");
            Assert.IsNotNull(node);
            string redirect = node.InnerText;
            redirect = redirect.Insert(redirect.IndexOf('?') + 1, "skin=purexml&");
            urlRequest.RequestPage(redirect);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADPOSTS/POST[TEXT='" + post + "']"), "Check existence of post");
            Console.WriteLine("After aaPost");
        }

        [TestMethod]
        public void bbHideThread()
        {
            aaPost();

            Console.WriteLine("Before bbHideThread");
            string url = "F" + forumId + "?skin=purexml";
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();

            XmlNode node = doc.SelectSingleNode("/H2G2/FORUMTHREADS/THREAD/@THREADID");
            Assert.IsNotNull(node, "Get ThreadId from Forum");

            threadId = node.InnerText;

            //Check Normal User Cannot Hide Threads
            url = "F" + forumId + "&HideThread=" + threadId + "&skin=purexml";
            urlRequest.SetCurrentUserNormal();
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("/H2G2[HIDETHREAD='HideThreadOK']"), "Check Thread Hidden");

            //Hide Thread
            url = "F" + forumId + "&HideThread=" + threadId + "&skin=purexml&fudge=1";
            urlRequest.SetCurrentUserEditor();
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[HIDETHREAD='HideThreadOK']"),"Check Thread Hidden");
            
            //Check Editor Can See hidden thread.
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS/THREAD[@THREADID=" + threadId + "]"), "Check Editor Can See Hidden Thread");

            //Check Normal User cannot see hidden thread.
            urlRequest.SetCurrentUserNormal();
            url = "F" + forumId + "&skin=purexml";
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS/THREAD[@THREADID=" + threadId + "]"), "Check Normal User Cannot See Hidden Thread");
            Console.WriteLine("After bbHideThread");
        }

        [TestMethod]
        public void ccUnHideThread()
        {
            bbHideThread();
            Console.WriteLine("Before ccHideThread");
            //Check Editor Can Unhide Thread.
            DnaTestURLRequest urlRequest = new DnaTestURLRequest("haveyoursay");
            urlRequest.SetCurrentUserEditor();
            string url = "F" + forumId + "&UnHideThread=" + threadId + "&skin=purexml";
            urlRequest.RequestPage(url);
            XmlDocument doc = urlRequest.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("/H2G2[UNHIDETHREAD='UnHideThreadOK']"), "Check Thread UnHidden");

            System.Threading.Thread.Sleep(100);

            //Check Normal User Can See Thread.
            url = "F" + forumId + "&skin=purexml";
            urlRequest.SetCurrentUserNormal();
            urlRequest.RequestPage(url);
            doc = urlRequest.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("/H2G2/FORUMTHREADS/THREAD[@THREADID=" + threadId + "]"), "Check Normal User can See UnHidden Thread.");
            Console.WriteLine("After ccHideThread");
        }
    }
}
