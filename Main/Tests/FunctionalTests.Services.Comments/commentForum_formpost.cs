using BBC.Dna.Api;
using BBC.Dna.Moderation.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Specialized;
using System.Net;
using System.Web;
using System.Xml;
using Tests;


namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class commentForum_FormPost
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        private const string _schemaCommentsList = "Dna.Services\\commentsList.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private static string _hostAndPort = DnaTestURLRequest.CurrentServer.Host + ":" + DnaTestURLRequest.CurrentServer.Port;
        private static string _server = _hostAndPort;
        private string _secureserver = DnaTestURLRequest.SecureServerAddress.Host;
        private string _sitename = "h2g2";
        private static CommentsTests_V1 GetCommentsTests()
        {
            CommentsTests_V1 commentsTests = new CommentsTests_V1();
            return commentsTests;
        }
        private NameValueCollection headers;


        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After CommentForumTests");
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
        /// 
        /// </summary>
        public commentForum_FormPost()
        {
            headers = new NameValueCollection();
            headers.Add("referer", "http://www.bbc.co.uk/dna/h2g2/");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPost()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}", HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(parentUri));

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());

        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPostWithQueryString()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}", HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(parentUri));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, localHeaders);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == expectedResponse);

        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPostWithQueryStringPtrt()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string ptrt = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}", HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(parentUri));



            string expectedResponse = ptrt + "?resultCode=" + ErrorType.Ok.ToString();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm?ptrt=" + ptrt, _sitename);
            // now get the response

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://news.bbc.co.uk/weather/");

            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, localHeaders);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == expectedResponse);

        }


        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPostWithQueryStringAndAnchor()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}", HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(parentUri));


            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1#acs");
            string expectedResponse = "http://www.bbc.co.uk/dna/h2g2/?test=1&resultCode=" + ErrorType.Ok.ToString() + "#acs";

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, localHeaders);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == expectedResponse);

        }


        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPost_InPreMod()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.PreMod;
            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}" +
                "&moderationServiceGroup={3}",
                HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title),
                HttpUtility.HtmlEncode(parentUri), moderationStatus);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPost_CloseDate()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            DateTime closeDate = DateTime.Now.AddDays(1);
            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}" +

                "&closeDate={3}",
                HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title),
                HttpUtility.HtmlEncode(parentUri), closeDate.ToString("yyyy-MM-dd"));

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPost_InPostMod()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.PostMod;
            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}" +

                "&moderationServiceGroup={3}",
                HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title),
                HttpUtility.HtmlEncode(parentUri), moderationStatus);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPost_InvalidModerationStatus()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}" +
                "&moderationServiceGroup={3}",
                HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title),
                HttpUtility.HtmlEncode(parentUri), "invalid status");



            // Check to make sure that the page returned with the correct information
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.InvalidModerationStatus.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_AsFormPost_Noneditor()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}", HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(parentUri));

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/create.htm", _sitename);

            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.MissingEditorCredentials.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentHtml()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentHtml_WithoutNamespace()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentHtml_WithoutUser()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.CurrentCookie = "";
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.MissingUserCredentials.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentHtml_WithBannedUser()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserBanned();
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.UserIsBanned.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentHtml_WithoutText()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = "notest=somethingelse";// String.Format("text={0}", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.EmptyText.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentHtml_WithInvalidPostStyle()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}&postStyle=invalidpoststyle", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently, "Not Moved - Status Code = " + request.CurrentWebResponse.StatusCode.ToString());
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.InvalidPostStyle.ToString());
        }

        /// <summary>
        /// Checks the xml against the error schema
        /// </summary>
        /// <param name="xml">Returned XML</param>
        public void CheckErrorSchema(XmlDocument xml)
        {
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaError);
            validator.Validate();
        }
    }
}
