using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna.Api;
using BBC.Dna.Component;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

using TestUtils;

namespace FunctionalTests
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class RatingsComments_V1
    {
        private const string _schemaRatingForum = "Dna.Services\\ratingForum.xsd";
        private const string _schemaRating = "Dna.Services\\rating.xsd";
        private const string _schemaComment = "Dna.Services\\comment.xsd";
        private const string _schemaCommentList = "Dna.Services\\commentsList.xsd";
        private const string _schemaThread = "Dna.Services\\thread.xsd";
        private const string _schemaThreadlist = "Dna.Services\\threadlist.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After RatingsComments_V1");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("Before RatingsComments_V1");
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public RatingsComments_V1()
        {
          
        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        private RatingForum RatingForumCreate(string Namespace, string id)
        {
            return RatingForumCreate(Namespace, id, ModerationStatus.ForumStatus.Reactive, DateTime.MinValue);

        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        private RatingForum RatingForumCreate(string Namespace, string id, ModerationStatus.ForumStatus moderationStatus)
        {
            return RatingForumCreate(Namespace, id, moderationStatus, DateTime.MinValue);

        }

        /// <summary>
        /// A helper class for other tests that need a comment to operate.
        /// </summary>
        /// <returns></returns>
        public RatingInfo CreateRatingHelper()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            
            return  (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            
        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        private RatingForum RatingForumCreate(string nameSpace, string id, ModerationStatus.ForumStatus moderationStatus, DateTime closingDate)
        {
            Console.WriteLine("Before CreateRatingForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<namespace>{3}</namespace>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "<closeDate>{4}</closeDate>" +
                "<moderationServiceGroup>{5}</moderationServiceGroup>" +
                "</ratingForum>", id, title, parentUri, nameSpace, closingDate.ToString("yyyy-MM-dd"), moderationStatus);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            BBC.Dna.Api.RatingForum returnedForum = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedForum.Id == id);
            
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            return returnedForum;
        }

        /// <summary>
        /// Test creating a threaded rating
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating()
        {
            Console.WriteLine("Before CreateThreadedRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "FunctionTest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread",_sitename,ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaThread);
            validator.Validate();

            ThreadInfo returnedThread = (ThreadInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ThreadInfo));
            Assert.IsTrue(returnedThread.id > 0);
            Assert.IsTrue(returnedThread.rating.text == text);
            Assert.IsNotNull(returnedThread.rating.User);
            Assert.IsTrue(returnedThread.rating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRating");
        }

        /// <summary>
        /// Test CreateThreadedRating method from service return HTML
        /// </summary>
        [TestMethod]
        public void CreateThreadedRatingHtml()
        {
            Console.WriteLine("Before CreateThreadedRatingHtml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("text={0}&rating={1}", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread/create.htm?format=XML", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "application/x-www-form-urlencoded");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaThread);
            validator.Validate();

            ThreadInfo returnedThread = (ThreadInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ThreadInfo));
            Assert.IsTrue(returnedThread.rating.text == text);
            Assert.IsNotNull(returnedThread.rating.User);
            Assert.IsTrue(returnedThread.rating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRatingHtml");
        }

        /// <summary>
        /// Test CreateThreadedRating method from service return JSON
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_JSONReturn()
        {
            Console.WriteLine("Before CreateThreadedRating_JSONReturn");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread?format=JSON", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");

            ThreadInfo returnedThread = (ThreadInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(ThreadInfo));
            Assert.IsTrue(returnedThread.rating.text == text);
            Assert.IsNotNull(returnedThread.rating.User);
            Assert.IsTrue(returnedThread.rating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRating_JSONReturn");
        }

        /// <summary>
        /// Test try CreateThreadedRating method from service with a banned User
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_WithBannedUser()
        {
            Console.WriteLine("Before CreateThreadedRating_WithBannedUser");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserBanned();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);


            Console.WriteLine("After CreateThreadedRating_WithBannedUser");
        }

        /// <summary>
        /// Test CreateThreadedRating method from service with No User
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_WithNoUser()
        {
            Console.WriteLine("Before CreateThreadedRating_WithNoUser");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.CurrentCookie = "";
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread",_sitename,ratingForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateThreadedRating_WithNoUser");
        }

        /// <summary>
        /// Test CreateThreadedRating method from service with missing text
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_MissingText()
        {
            Console.WriteLine("Before CreateThreadedRating_MissingText");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateThreadedRating_MissingText");
        }


        /// <summary>
        /// Test CreateThreadedRating_MissingRating method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_MissingRating()
        {
            Console.WriteLine("Before CreateThreadedRating_MissingRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateThreadedRating_MissingRating");
        }

        /// <summary>
        /// Test CreateThreadedRating_TooLargeRating method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_TooLargeRating()
        {
            Console.WriteLine("Before CreateThreadedRating_TooLargeRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</rating>", text, 1000);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateThreadedRating_TooLargeRating");
        }

        /// <summary>
        /// Test CreateThreadedRatingHtml_TooLargeRating method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRatingHtml_TooLargeRating()
        {
            Console.WriteLine("Before CreateThreadedRatingHtml_TooLargeRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("text={0}&rating={1}", text, 1000);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, ratingForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "application/x-www-form-urlencoded");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateThreadedRatingHtml_TooLargeRating");
        }

        /// <summary>
        /// Test CreateThreadedRating_PreModForum method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_PreModForum()
        {
            Console.WriteLine("Before CreateThreadedRating_PreModForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.PreMod);

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == "This post is awaiting moderation.");
            Assert.IsTrue(returnedRating.hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRating_PreModForum");
        }

        /// <summary>
        /// Test CreateThreadedRating_PostModForum method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_PostModForum()
        {
            Console.WriteLine("Before CreateThreadedRating_PostModForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.PostMod);

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsTrue(returnedRating.hidden == CommentStatus.Hidden.NotHidden);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRating_PostModForum");
        }

        /// <summary>
        /// Test CreateThreadedRating_ReactiveForum method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_ReactiveForum()
        {
            Console.WriteLine("Before CreateThreadedRating_ReactiveForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.Reactive);

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsTrue(returnedRating.hidden == CommentStatus.Hidden.NotHidden);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRating_ReactiveForum");
        }

        /// <summary>
        /// Test CreateThreadedRating_PreModForumAsEditor method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_PreModForumAsEditor()
        {
            Console.WriteLine("Before CreateThreadedRating_PreModForumAsEditor");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.PreMod);

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsTrue(returnedRating.hidden == CommentStatus.Hidden.NotHidden);
            Assert.IsTrue(returnedRating.ID > 0);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRating_PreModForumAsEditor");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_AsPlainText()
        {
            Console.WriteLine("Before CreateThreadedRating_AsPlainText");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            PostStyle.Style postStyle = PostStyle.Style.plaintext;
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "<poststyle>{1}</poststyle><rating>{2}</rating>" +
                "</rating>", text, postStyle, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsTrue(returnedRating.PostStyle == postStyle);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRating_AsPlainText");
        }

        /// <summary>
        /// Test CreateThreadedRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateThreadedRating_InvalidPostStyle()
        {
            Console.WriteLine("Before CreateThreadedRating_InvalidPostStyle");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "<poststyle>{1}</poststyle>" +
                "</rating>", text, "invalid style");

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateThreadedRating_InvalidPostStyle");
        }


        /// <summary>
        /// Test ViewUsersRating method from service
        /// </summary>
        [Ignore]
        public void ViewUsersRating()
        {
            Console.WriteLine("Before ViewUsersRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            //get specific users comment
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/user/{2}/", _sitename, ratingForum.Id, TestUserAccounts.GetNormalUserAccount.UserID);
            request.RequestPageWithFullURL(url, "", "text/xml");
            // Check to make sure that the page returned with the correct information
            RatingInfo returnedUserRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == returnedUserRating.text);
            Assert.IsTrue(returnedRating.User.UserId == returnedUserRating.User.UserId);

            //get specific users comment who hasn't commented
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/user/{2}/", _sitename, ratingForum.Id, TestUserAccounts.GetModeratorAccount.UserID);
            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.NotFound);

            Console.WriteLine("After ViewUsersRating");
        }


        /// <summary>
        /// Request ratings filtered by Editors Picks.
        /// </summary>
        [Ignore]
        public void CommentsListWithEditorsPickFilter()
        {
            Console.WriteLine("Before ViewUsersRating");

            //Create Comment.
            RatingInfo commentInfo = CreateRatingHelper();
            RatingInfo commentInfo2 = CreateRatingHelper();

            //Create Editors Pick
            EditorsPicks_V1 editorsPicks = new EditorsPicks_V1();
            editorsPicks.CreateEditorsPickHelper(_sitename, commentInfo.ID);


            //Request Comments Filtered by Editors Picks.
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/comments/?filterBy=EditorsPick", _sitename);
            //Check that picked comment is in results.
            request.RequestPageWithFullURL(url, "", "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");

            String xPath = String.Format("api:commentsList/api:comments/api:comment[api:id='{0}']/api:editorspick", commentInfo.ID);
            XmlNode pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNotNull(pick);

            //Check Comment that has not been picked is not present.
            xPath = String.Format("api:ratingForum/api:commentsList/api:comments/api:comment[api:id='{0}']/api:editorspick", commentInfo2.ID);
            pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNull(pick);
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



        /// <summary>
        /// Test creating a comment on a threaded rating
        /// </summary>
        [TestMethod]
        public void CreateThreadedRatingComment()
        {
            Console.WriteLine("Before CreateThreadedRatingComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "FunctionTest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");

            ThreadInfo returnedThread = (ThreadInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ThreadInfo));
            int threadid = returnedThread.id;

            string comment = "Here is my comment on this rating." + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", comment);

            // Setup the comment url
            string commenturl = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread/{2}", _sitename, ratingForum.Id, returnedThread.id);

            // now get the response
            request.RequestPageWithFullURL(commenturl, commentForumXml, "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaComment);
            validator.Validate();

            CommentInfo returnedThreadedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedThreadedComment.ID > 0);
            Assert.IsTrue(returnedThreadedComment.text == comment);
            Assert.IsNotNull(returnedThreadedComment.User);
            Assert.IsTrue(returnedThreadedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateThreadedRatingComment");
        }

        /// <summary>
        /// Test viewing comments on a threaded rating
        /// </summary>
        [TestMethod]
        public void ViewThreadedRatingComments()
        {
            Console.WriteLine("Before ViewThreadedRatingComments");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            ThreadInfo returnedThread = CreateRatingThreadAndComments(request, ratingForum);

            //Get the thread and comments 
            string threadurl = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread/{2}", _sitename, ratingForum.Id, returnedThread.id);
            // now get the response
            request.RequestPageWithFullURL(threadurl, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentList);
            validator.Validate();

            BBC.Dna.Api.CommentsList returnedCommentList = (BBC.Dna.Api.CommentsList) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedCommentList.comments.Count == 2);
            //returnedThread = (ThreadInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ThreadInfo));
            //Assert.IsTrue(returnedThread.id > 0);
            //Assert.IsTrue(returnedThread.count == 2);

            Console.WriteLine("After ViewThreadedRatingComments");
        }

        /// <summary>
        /// Test viewing rating threads
        /// </summary>
        [TestMethod]
        public void ViewRatingThreads()
        {
            Console.WriteLine("Before ViewRatingThreads");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            ThreadInfo thread1 = CreateRatingThreadAndComments(request, ratingForum);

            request.SetCurrentUserEditor();
            ThreadInfo thread2 = CreateRatingThreadAndComments(request, ratingForum);

            //Get the thread and comments 
            string threadurl = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/threads", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(threadurl, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaThreadlist);
            validator.Validate();

            ThreadList returnedThreads = (ThreadList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ThreadList));
            Assert.IsTrue(returnedThreads.threads[0].id == thread1.id);
            Assert.IsTrue(returnedThreads.threads[0].count == 3);

            Console.WriteLine("After ViewRatingThreads");
        }


        private ThreadInfo CreateRatingThreadAndComments(DnaTestURLRequest request, RatingForum ratingForum)
        {
            string text = "FunctionTest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            ThreadInfo returnedThread = (ThreadInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ThreadInfo));

            string comment = "Here is my comment on this rating." + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", comment);
            // Setup the comment url
            string commenturl = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread/{2}", _sitename, ratingForum.Id, returnedThread.id);
            // now get the response
            request.RequestPageWithFullURL(commenturl, commentForumXml, "text/xml");

            comment = "Here is a second comment on this rating." + Guid.NewGuid().ToString();
            commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", comment);
            // Setup the 2nd comment url
            commenturl = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/thread/{2}", _sitename, ratingForum.Id, returnedThread.id);
            // now get the response
            request.RequestPageWithFullURL(commenturl, commentForumXml, "text/xml");
            return returnedThread;
        }

    }
}
