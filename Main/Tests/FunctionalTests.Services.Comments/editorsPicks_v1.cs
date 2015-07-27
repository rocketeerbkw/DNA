using BBC.Dna.Api;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Net;
using System.Xml;
using Tests;



namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class EditorsPicks_V1
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private static string _hostAndPort = DnaTestURLRequest.CurrentServer.Host + ":" + DnaTestURLRequest.CurrentServer.Port;
        private static string _server = _hostAndPort;
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
        public void CreateEditorsPickHelper(String siteName, int commentId)
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
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/", _sitename, _commentInfo.ID);

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


        /// <summary>
        /// Test that an editors pick may be created.
        /// </summary>
        [TestMethod]
        public void CreateEditorsPick_CheckStandardCalls_ReturnsCommentandEditorPickCount()
        {
            //First get a comment.
            CommentsTests_V1 comments = new CommentsTests_V1();
            CommentForumTests_V1 commentForums = new CommentForumTests_V1();

            var uid = commentForums.CommentForumCreateHelper().Id;
            _commentInfo = comments.CreateCommentHelper(uid);

            Assert.IsNotNull(_commentInfo, "Unable to Create Comment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}/editorpicks/", _sitename, _commentInfo.ID);

            request.RequestPageWithFullURL(url, String.Empty, "text/xml", "POST");

            //Check for Editors Pick presence.
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?filterBy=EditorPicks", _sitename);
            request.RequestPageWithFullURL(url);

            XmlDocument xml = request.GetLastResponseAsXML();
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");

            String xPath = String.Format("api:commentsList/api:comments/api:comment[api:id='{0}']", _commentInfo.ID);
            XmlNode pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNotNull(pick);

            //get normal list of comments
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, uid);
            request.RequestPageWithFullURL(url);

            var returnedForum = (CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
            Assert.AreEqual(1, returnedForum.commentSummary.EditorPicksTotal);
            Assert.IsTrue(returnedForum.commentList.comments[0].IsEditorPick);
        }
    }

}