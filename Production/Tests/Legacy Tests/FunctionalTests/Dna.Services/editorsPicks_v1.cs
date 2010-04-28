using System;
using System.Net;
using System.Xml;
using BBC.Dna.Api;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class EditorsPicks_V1
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        private CommentInfo _commentInfo = null;
 
        [TestCleanup]
        public void ShutDown()
        {
            
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Helper Function for Tests that require an editors pick.
        /// </summary>
        /// <param name="commentId"></param>
        public void CreateEditorsPickHelper( String siteName, int commentId )
        {
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/", _sitename, commentId);

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPageWithFullURL(url, "No data to send", "text/xml");
        }

        
        /// <summary>
        /// Test that an editors pick may be created.
        /// </summary>
        [TestMethod]
        public void CreateEditorsPick()
        {
            //First get a comment.
            CommentsTests_V1 comments = new CommentsTests_V1();
            CommentForumTests_V1 commentForums = new CommentForumTests_V1();

            _commentInfo = comments.CreateCommentHelper(commentForums.CommentForumCreateHelper().Id);

            Assert.IsNotNull(_commentInfo, "Unable to Create Comment");
            
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

             // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/", _sitename,_commentInfo.ID);
            
            request.RequestPageWithFullURL(url, "No data to send", "text/xml");

            //Check for Editors Pick presence.
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?filterBy=EditorPicks", _sitename);
            request.RequestPageWithFullURL(url);

            XmlDocument xml = request.GetLastResponseAsXML();
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            
            String xPath = String.Format("api:commentsList/api:comments/api:comment[api:id='{0}']", _commentInfo.ID);
            XmlNode pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNotNull(pick);
        }

        [TestMethod]
        public void CreateEditorsPickNonEditor()
        {
            //First get a comment.
            CommentsTests_V1 comments = new CommentsTests_V1();
            CommentForumTests_V1 commentForums = new CommentForumTests_V1();

            _commentInfo = comments.CreateCommentHelper(commentForums.CommentForumCreateHelper().Id);

            Assert.IsNotNull(_commentInfo, "Unable to Create Comment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            try
            {
                string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/", _sitename, _commentInfo.ID);
                request.RequestPageWithFullURL(url, "No data to send", "text/xml");
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            //Should return 401 unauthorised
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);

           
        }

        /// <summary>
        /// Test that an editor may vote or pick a comment.
        /// Requires that Editors Pick has already been created in a previous test.
        /// </summary>
        [TestMethod]
        public void RemoveEditorsPick()
        {
            //First get a comment.
            CommentsTests_V1 comments = new CommentsTests_V1();
            CommentForumTests_V1 commentForums = new CommentForumTests_V1();
            _commentInfo = comments.CreateCommentHelper(commentForums.CommentForumCreateHelper().Id);

            // Now make a pick
            String url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/", _sitename, _commentInfo.ID);
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();
            request.RequestPageWithFullURL(url, String.Empty, "text/xml", "POST");

            //Check that pick has been made.
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?filterBy=EditorPicks", _sitename);
            request.RequestPageWithFullURL(url);
            XmlDocument xml = request.GetLastResponseAsXML();
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            XmlNode response = xml.SelectSingleNode(String.Format("api:commentsList/api:comments/api:comment[api:id={0}]", _commentInfo.ID), nsmgr);
            Assert.IsNotNull(response);

            // Delete the pick.
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/", _sitename, _commentInfo.ID);
            request.RequestPageWithFullURL(url, String.Empty, String.Empty, "DELETE");

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);

            //Check the pick is no longer there
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?filterBy=EditorPicks", _sitename);
            request.RequestPageWithFullURL(url);
            xml = request.GetLastResponseAsXML();
            nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            response = xml.SelectSingleNode(String.Format("api:commentsList/api:comments/api:comment[api:id={0}]", _commentInfo.ID), nsmgr);
            Assert.IsNull(response);
        }

        /// <summary>
        /// Test that an editor may vote or pick a comment.
        /// Requires that Editors Pick has already been created in a previous test.
        /// </summary>
        [TestMethod]
        public void RemoveEditorsPickViaPost()
        {
            //First get a comment.
            CommentsTests_V1 comments = new CommentsTests_V1();
            CommentForumTests_V1 commentForums = new CommentForumTests_V1();
            _commentInfo = comments.CreateCommentHelper(commentForums.CommentForumCreateHelper().Id);

            // Now make a pick
            String url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/", _sitename, _commentInfo.ID);
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();
            request.RequestPageWithFullURL(url, String.Empty, "text/xml", "POST");

            //Check that pick has been made.
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?filterBy=EditorPicks", _sitename);
            request.RequestPageWithFullURL(url);
            XmlDocument xml = request.GetLastResponseAsXML();
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            XmlNode response = xml.SelectSingleNode(String.Format("api:commentsList/api:comments/api:comment[api:id={0}]", _commentInfo.ID), nsmgr);
            Assert.IsNotNull(response);

            // Delete the pick.
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/delete", _sitename, _commentInfo.ID);
            request.RequestPageWithFullURL(url, String.Empty, String.Empty, "POST");

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);

            //Check the pick is no longer there
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?filterBy=EditorPicks", _sitename);
            request.RequestPageWithFullURL(url);
            xml = request.GetLastResponseAsXML();
            nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            response = xml.SelectSingleNode(String.Format("api:commentsList/api:comments/api:comment[api:id={0}]", _commentInfo.ID), nsmgr);
            Assert.IsNull(response);
        }
    }

}