using System;
using System.Collections.Specialized;
using System.Net;
using System.Web;
using BBC.Dna.Api;
using BBC.Dna.Moderation.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class ratingsForum_formpost
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        private const string _schemaCommentsList = "Dna.Services\\commentsList.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
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
        public ratingsForum_formpost()
        {
            headers = new NameValueCollection();
            headers.Add("referer", "http://www.bbc.co.uk/dna/h2g2/");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForum_AsFormPost()
        {
            

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}", HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(parentUri));

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());

        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForum_AsFormPostWithQueryString()
        {
            

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
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, localHeaders);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == expectedResponse);

        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForum_AsFormPostWithQueryStringAndAnchor()
        {
            

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
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, localHeaders);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == expectedResponse);

        }


        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForum_AsFormPost_InPreMod()
        {
            

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
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForum_AsFormPost_CloseDate()
        {
            

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
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForum_AsFormPost_InPostMod()
        {
            

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
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForum_AsFormPost_InvalidModerationStatus()
        {
            

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
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/create.htm", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.InvalidModerationStatus.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForum_AsFormPost_Noneditor()
        {
            

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("id={0}&" +
                "title={1}&" +
                "parentUri={2}", HttpUtility.HtmlEncode(id), HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(parentUri));

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/create.htm", _sitename);

            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.MissingEditorCredentials.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}&rating=1", text);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.Ok.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_WithTooLargeRating()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}&rating=1000", text);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.InvalidRatingValue.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_WithoutRating()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}", text);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.InvalidRatingValue.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_WithoutUser()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.CurrentCookie = "";
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}&rating=1", text);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.MissingUserCredentials.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_WithBannedUser()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserBanned();
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}&rating=1", text);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.MissingUserCredentials.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_WithoutText()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = "notest=somethingelse&rating=5";// String.Format("text={0}", text);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.EmptyText.ToString());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_WithInvalidPostStyle()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            //create the forum
            CommentForum commentForum = GetCommentsTests().CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("text={0}&postStyle=invalidpoststyle", text);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, commentForumXml, "application/x-www-form-urlencoded", null, headers);
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.MovedPermanently);
            Assert.IsTrue(request.CurrentWebResponse.Headers["Location"] == headers["referer"] + "?resultCode=" + ErrorType.InvalidPostStyle.ToString());
        }
    }
}
