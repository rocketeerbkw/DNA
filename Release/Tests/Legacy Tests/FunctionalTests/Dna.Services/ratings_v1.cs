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
using BBC.Dna.Data;
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
    public class RatingTests_V1
    {
        private const string _schemaRatingForum = "Dna.Services\\ratingForum.xsd";
        private const string _schemaComment = "Dna.Services\\rating.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After Comments_V1");
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
        /// Constructor
        /// </summary>
        public RatingTests_V1()
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
        /// tests successful RatingForumIdentityUserCreate 
        /// </summary>
        private RatingForum RatingForumIdentityUserCreate(string Namespace, string id)
        {
            return RatingForumIdentityUserCreate(Namespace, id, ModerationStatus.ForumStatus.Reactive, DateTime.MinValue);

        }

        /// <summary>
        /// tests successful RatingForumIdentityUserCreate 
        /// </summary>
        private RatingForum RatingForumIdentityUserCreate(string Namespace, string id, ModerationStatus.ForumStatus moderationStatus)
        {
            return RatingForumIdentityUserCreate(Namespace, id, moderationStatus, DateTime.MinValue);

        }

        /// <summary>
        /// Helper function to create rating for a given RatingForumID
        /// </summary>
        /// <param name="ratingForumID"></param>
        /// <returns></returns>
        public RatingInfo CreateRatingHelper(string ratingForumID, bool asNotable)
        {

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            if (asNotable)
            {
                request.SetCurrentUserNotableUser();
            }
            else
            {
                request.SetCurrentUserNormal();
            }

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForumID);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information

            return (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));

        }

        /// <summary>
        /// A helper class for other tests that need a comment to operate.
        /// </summary>
        /// <returns></returns>
        public RatingInfo CreateRatingHelper()
        {
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            return CreateRatingHelper(ratingForum.Id, false);            
        }

        /// <summary>
        /// Creates a Rating Forum for tests that require one.
        /// </summary>
        /// <returns></returns>
        public RatingForum CreateRatingForumHelper()
        {
            return RatingForumCreate("tests", Guid.NewGuid().ToString());
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
        /// tests successful RatingForumIdentityUserCreate 
        /// </summary>
        private RatingForum RatingForumIdentityUserCreate(string nameSpace, string id, ModerationStatus.ForumStatus moderationStatus, DateTime closingDate)
        {
            Console.WriteLine("Before RatingForumIdentityUserCreate");
            string identitySitename = "identity606";
            DnaTestURLRequest request = new DnaTestURLRequest(identitySitename);

            string userName = "RatingForumIdentityUserCreate" + DateTime.Now.Ticks.ToString();
            string userEmail = userName + "@bbc.co.uk";

            Assert.IsTrue(request.SetCurrentUserAsNewIdentityUser(userName, "password", "RatingForum User", userEmail, "1989-12-31", TestUserCreator.IdentityPolicies.Adult, identitySitename, TestUserCreator.UserType.SuperUser), "Failed to create a test identity user");

            string title = "FunctionalTest Title";
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
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", identitySitename);
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

            Console.WriteLine("After RatingForumIdentityUserCreate");

            return returnedForum;
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating()
        {
            Console.WriteLine("Before CreateRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

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
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_AsNotable()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotableUser();
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
            Assert.AreEqual(true, returnedRating.User.Notable);
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingForumWithRating()
        {
            Console.WriteLine("Before CreateRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string text = Guid.NewGuid().ToString();
            string uid = Guid.NewGuid().ToString();
            string template = "<ratingForum  xmlns=\"BBC.Dna.Api\"> " +
            "<id>{0}</id> " +
            "<title>{1}</title> " +
            "<parentUri>{2}</parentUri> " +
            "<ratingsList> " +
            "<ratings> " +
            "<rating> " +
            "<text>{3}</text> " +
            "<rating>{4}</rating> " +
            "</rating> " +
            "</ratings> " +
            "</ratingsList> " +
            "</ratingForum> ";

            string ratingXML = string.Format(template,
                uid, "title", "http://www.bbc.co.uk/dna/h2g2/",
                text, 5);

            

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, uid);
            // now get the response
            request.RequestPageWithFullURL(url, ratingXML, "text/xml", "PUT");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            //get returned rating
            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            //make another comment with the same uid
            text = Guid.NewGuid().ToString();
            ratingXML = string.Format(template,
                uid, "title", "http://www.bbc.co.uk/dna/h2g2/",
                text, 5);

            // now get the response
            request.SetCurrentUserNotableUser();//change user
            request.RequestPageWithFullURL(url, ratingXML, "text/xml", "PUT");
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();
            returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);



            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_JSONReturn()
        {
            Console.WriteLine("Before CreateRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/?format=JSON", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            Assert.AreEqual("application/json", request.CurrentWebResponse.ContentType);

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_WithBannedUser()
        {
            Console.WriteLine("Before CreateRating");

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
            

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_WithNoUser()
        {
            Console.WriteLine("Before CreateRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.CurrentCookie = "";
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/",_sitename,ratingForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_MissingText()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }


        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_MissingRating()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_TooLargeRating()
        {
            Console.WriteLine("Before CreateRating");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "<rating>{1}</rating>" +
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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_TooLargeRating()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_PreModForum()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_PostModForum()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_ReactiveForum()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_PreModForumAsEditor()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_AsPlainText()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Test CreateRatingForum method from service
        /// </summary>
        [TestMethod]
        public void CreateRating_InvalidPostStyle()
        {
            Console.WriteLine("Before CreateRating");

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

            Console.WriteLine("After CreateRating");
        }

        /// <summary>
        /// Return a list of the given users ratings ViewIdentityUsersRating
        /// </summary>
        [TestMethod]
        public void ViewIdentityUsersRating()
        {
            Console.WriteLine("Before ViewIdentityUsersRating");
            string siteName = "identity606";
           //create the forum
            RatingForum ratingForum = RatingForumIdentityUserCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);

            PostToRatingForumAsIdentityUser(ratingForum, ratingForumXml, request, siteName);

            int newIdentityUserID = request.CurrentIdentityUserID;

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            Assert.IsTrue(returnedRating.text == text);
            Assert.IsNotNull(returnedRating.User);

            //get specific users comment
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/user/{2}/", siteName, ratingForum.Id, newIdentityUserID);
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

            Console.WriteLine("After ViewIdentityUsersRating");
        }

        private void PostToRatingForumAsIdentityUser(RatingForum ratingForum, string ratingForumXml, DnaTestURLRequest request, string sitename)
        {
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", sitename, ratingForum.Id);

            string userName = "RatingForumIdentityUserCreate" + DateTime.Now.Ticks.ToString();
            string userEmail = userName + "@bbc.co.uk";
            Assert.IsTrue(request.SetCurrentUserAsNewIdentityUser(userName, "password", "RatingForumCommenter", userEmail, "1989-12-31", TestUserCreator.IdentityPolicies.Adult, sitename, TestUserCreator.UserType.IdentityOnly), "Failed to create a test identity user");

            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
        }

        /// <summary>
        /// Request ratings filtered by Editors Picks.
        /// </summary>
        [TestMethod]
        public void ReviewsWithEditorsPickFilter()
        {
            RatingForum ratingForum = RatingForumCreate("editorpickstests", Guid.NewGuid().ToString());

            //Create Review.
            RatingInfo reviewInfo = CreateRatingHelper(ratingForum.Id, false);
            RatingInfo reviewInfo2 = CreateRatingHelper(ratingForum.Id, true);

            //Create Editors Pick
            EditorsPicks_V1 editorsPicks = new EditorsPicks_V1();
            editorsPicks.CreateEditorsPickHelper(_sitename, reviewInfo.ID);


            //Request Reviews Filtered by Editors Picks.
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/?filterBy=EditorPicks", _sitename, ratingForum.Id);
            
            
            
            //Check that picked comment is in results.
            request.RequestPageWithFullURL(url, "", "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            BBC.Dna.Api.RatingForum returnedForum = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedForum.Id == ratingForum.Id);
            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 1);
            Assert.IsTrue(returnedForum.ratingsList.ratings[0].ID == reviewInfo.ID);
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
        /// Test CreateRatingForum method from service with too few characters
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_TooFewCharsRating()
        {
            Console.WriteLine("Before CreateRatingHtml_TooFewCharsRating");

            try
            {
                SetMinCharLimit(100);

                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();
                //create the forum
                RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

                string text = "Functiontest Title" + Guid.NewGuid().ToString();
                string ratingForumXml = String.Format("text={0}&rating={1}", text, 1);

                // Setup the request url
                string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, ratingForum.Id);
                // now get the response
                try
                {
                    request.RequestPageWithFullURL(url, ratingForumXml, "application/x-www-form-urlencoded");
                }
                catch (AssertFailedException Ex)
                {
                    Console.WriteLine(Ex.Message);
                }


                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
                CheckErrorSchema(request.GetLastResponseAsXML());

            }
            finally 
            {
                DeleteMinMaxLimitSiteOptions();
            }
            

            Console.WriteLine("After CreateRatingHtml_TooFewCharsRating");
        }
        /// <summary>
        /// Test CreateRatingForum method from service with too many characters
        /// </summary>
        [TestMethod]
        public void CreateRatingHtml_TooManyCharsRating()
        {
            Console.WriteLine("Before CreateRatingHtml_TooManyCharsRating");

            try
            {

            
                SetMaxCharLimit(10);

                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();
                //create the forum
                RatingForum ratingForum = RatingForumCreate("tests", Guid.NewGuid().ToString());

                string text = "Functiontest Title" + Guid.NewGuid().ToString();
                string ratingForumXml = String.Format("text={0}&rating={1}", text, 1);

                // Setup the request url
                string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/create.htm?format=XML", _sitename, ratingForum.Id);
                // now get the response
                try
                {
                    request.RequestPageWithFullURL(url, ratingForumXml, "application/x-www-form-urlencoded");
                }
                catch (AssertFailedException Ex)
                {
                    Console.WriteLine(Ex.Message);
                }


                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
                CheckErrorSchema(request.GetLastResponseAsXML());
            }
            finally
            {

                DeleteMinMaxLimitSiteOptions();
            }
            

            Console.WriteLine("After CreateRatingHtml_TooManyCharsRating");
        }

        private void SetMaxCharLimit(int maxLimit)
        {
            //set max char option
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(1,'CommentForum', 'MaxCommentCharacterLength','" + maxLimit.ToString() + "',0,'test MaxCommentCharacterLength value')");
                }
            }
            DnaTestURLRequest myRequest = new DnaTestURLRequest(_sitename);
            myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/commentsforums/?_ns=1", "", "text/xml");

        }
        private void SetMinCharLimit(int minLimit)
        {
            //set min char option
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(1,'CommentForum', 'MinCommentCharacterLength','" + minLimit.ToString() + "',0,'test MinCommentCharacterLength value')");
                }
            }
            DnaTestURLRequest myRequest = new DnaTestURLRequest(_sitename);
            myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/commentsforums/?_ns=1", "", "text/xml");
        }

        private void DeleteMinMaxLimitSiteOptions()
        {
            SnapshotInitialisation.ForceRestore();
            DnaTestURLRequest myRequest = new DnaTestURLRequest(_sitename);
            myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/commentsforums/?_ns=1", "", "text/xml");
        }


    }
}
