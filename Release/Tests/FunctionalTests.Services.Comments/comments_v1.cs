using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;

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



namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class CommentsTests_V1
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        private const string _schemaComment = "Dna.Services\\comment.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _secureserver = DnaTestURLRequest.SecureServerAddress;
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
        public CommentsTests_V1()
        {
          
        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        public CommentForum CommentForumCreate(string Namespace, string id)
        {
            return CommentForumCreate(Namespace, id, ModerationStatus.ForumStatus.Reactive, DateTime.MinValue);

        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        public CommentForum CommentForumCreate(string Namespace, string id, ModerationStatus.ForumStatus moderationStatus)
        {
            return CommentForumCreate(Namespace, id, moderationStatus, DateTime.MinValue);

        }

        /// <summary>
        /// A helper class for other tests that need a comment to operate.
        /// </summary>
        /// <returns></returns>
        public CommentInfo CreateCommentHelper(string commentForumId)
        {

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForumId);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information

            return (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));

        }

        /// <summary>
        /// A helper class for other tests that need a comment to operate.
        /// </summary>
        /// <returns></returns>
        public CommentInfo CreateCommentHelperWithPut(CommentForum forum, string text,  bool UseNotSignedIn, string userName)
        {

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            if (!UseNotSignedIn)
            {
                request.SetCurrentUserNormal();
            }

            forum.NotSignedInUserId = UseNotSignedIn?1:0;
            forum.commentList = new BBC.Dna.Api.CommentsList();
            forum.commentList.comments = new List<CommentInfo>();
            forum.commentList.comments.Add(new CommentInfo{text = text});
            if(!String.IsNullOrEmpty(userName))
            {
                forum.commentList.comments[0].User = new User{DisplayName = userName};
            }


            // Setup the request url
            string url = String.Format("https://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/", _secureserver, _sitename, forum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, StringUtils.SerializeToJsonReturnAsString(forum), "application/json", "PUT");
            // Check to make sure that the page returned with the correct information

            return (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));

        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        public CommentForum CommentForumCreate(string nameSpace, string id, ModerationStatus.ForumStatus moderationStatus, DateTime closingDate)
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<namespace>{3}</namespace>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "<closeDate>{4}</closeDate>" +
                "<moderationServiceGroup>{5}</moderationServiceGroup>" +
                "</commentForum>", id, title, parentUri, nameSpace, closingDate.ToString("yyyy-MM-dd"), moderationStatus);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            BBC.Dna.Api.CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == id);
            
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            return returnedForum;
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",_sitename,commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            //check the TextAsHtml element
            //string textAsHtml = xml.DocumentElement.ChildNodes[2].InnerXml;
            //Assert.IsTrue(textAsHtml == "<div class=\"dna-comment text\" xmlns=\"\">" + text + "</div>");

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            DateTime created = DateTime.Parse(returnedComment.Created.At);
            DateTime createdTest = BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(DateTime.Now.AddMinutes(5));
            Assert.IsTrue(created < createdTest);//should be less than 5mins
            Assert.IsTrue(!String.IsNullOrEmpty(returnedComment.Created.Ago));

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsNotable()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotableUser();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            //check the TextAsHtml element
            //string textAsHtml = xml.DocumentElement.ChildNodes[2].InnerXml;
            //Assert.IsTrue(textAsHtml == "<div class=\"dna-comment text\" xmlns=\"\">" + text + "</div>");

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);
            Assert.AreEqual(true, returnedComment.User.Notable);

            DateTime created = DateTime.Parse(returnedComment.Created.At);
            DateTime createdTest = BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(DateTime.Now.AddMinutes(5));
            Assert.IsTrue(created < createdTest);//should be less than 5mins
            Assert.IsTrue(!String.IsNullOrEmpty(returnedComment.Created.Ago));
        }

        /// <summary>
        /// Test the auto-creation of a forum using XML
        /// Also show that the call can be repeatedly used and will simply append comments on 2nd (and subsequent?) call(s)
        /// </summary>
        [TestMethod]
        public void CreateCommentForumWithComment()
        {
            Console.WriteLine("Before Createcomment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string text = Guid.NewGuid().ToString();
            string uid = Guid.NewGuid().ToString();
            string template = "<commentForum  xmlns=\"BBC.Dna.Api\"> " +
            "<id>{0}</id> " +
            "<title>{1}</title> " +
            "<parentUri>{2}</parentUri> " +
            "<commentsList> " +
            "<comments> " +
            "<comment> " +
            "<text>{3}</text> " +
            "</comment> " +
            "</comments> " +
            "</commentsList> " +
            "</commentForum> ";

            string commentXML = string.Format(template,
                uid, "title", "http://www.bbc.co.uk/dna/h2g2/",
                text);

            // used to check that a forum is actually created
            int finalForumcount = 0;
            int forumCount = testUtils_CommentsAPI.countForums(_sitename);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, uid);
            // now get the response
            request.RequestPageWithFullURL(url, commentXML, "text/xml", "PUT");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaComment);
            validator.Validate();

            //get returned comment
            CommentInfo returnedcomment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedcomment.text == text);
            Assert.IsNotNull(returnedcomment.User);
            Assert.IsTrue(returnedcomment.User.UserId == request.CurrentUserID);

            //make a second comment with the same uid, verb and post-data structure
            text = Guid.NewGuid().ToString();
            commentXML = string.Format(template,
                uid, "title", "http://www.bbc.co.uk/dna/h2g2/",
                text, 5);

            // now get the response
            request.SetCurrentUserNotableUser();//change user
            request.RequestPageWithFullURL(url, commentXML, "text/xml", "PUT");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaComment);
            validator.Validate();
            returnedcomment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedcomment.text == text);
            Assert.IsNotNull(returnedcomment.User);
            Assert.IsTrue(returnedcomment.User.UserId == request.CurrentUserID);

            // count the fora for this site
            finalForumcount = testUtils_CommentsAPI.countForums(_sitename);
            // there should be 1 more
            Assert.AreEqual((forumCount + 1), finalForumcount);

            // Check that the new fourm actually contains the number of comments that we expect.
            request.RequestPageWithFullURL(url, "", "text/xml", "GET");

            CommentForum theForum = (CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
            Assert.AreEqual(2, theForum.commentSummary.Total, "Made the wrong number of comments");

            Console.WriteLine("After Createcomment");
        }


        /// <summary>
        /// Test the auto-creation of a forum using json
        /// </summary>
        [TestMethod]
        public void CreateCommentForumWithCommentJson()
        {
            Console.WriteLine("Before CreateCommentForumWithCommentJson");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string text = Guid.NewGuid().ToString();
            string uid = Guid.NewGuid().ToString();

            string template = @"{{""id"":""{0}"",""title"":""{1}"",""parentUri"":""{2}"", ""commentsList"":{{""comments"":[{{""text"":""{3}""}}]}}}}";
                
            string commentXML = string.Format(template,
                uid, "title", HttpUtility.UrlEncode("http://www.bbc.co.uk/dna/h2g2/"),
                text);

            int finalForumcount = 0;
            int forumCount = testUtils_CommentsAPI.countForums(_sitename);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, uid);
            // now get the response
            request.RequestPageWithFullURL(url, commentXML, "application/json", "PUT");

            // check that we have created a new forum
            finalForumcount = testUtils_CommentsAPI.countForums(_sitename);

            Assert.AreEqual((forumCount + 1), finalForumcount);


            // Check that the new fourm actually contains the number of comments that we expect.
            request.RequestPageWithFullURL(url, "", "text/xml", "GET");

            CommentForum theForum = (CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
            Assert.AreEqual(1, theForum.commentSummary.Total, "Made the wrong number of comments");

            Console.WriteLine("After CreateCommentForumWithCommentJson");
        }



        /// <summary>
        /// Test the autocreation of the forum, but give it some bad JSON. It should fail in some way.
        /// </summary>
        [TestMethod]
        public void CreateCommentForumWithComment_BadJson()
        {
            Console.WriteLine("Before CreateCommentForumWithCommentJson");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string text = Guid.NewGuid().ToString();
            string uid = Guid.NewGuid().ToString();

            // bad json with missing "
            string template = @"{{id"":""{0}"",""title"":""{1}"",""parentUri"":""{2}"", ""commentsList"":{{""comments"":{{""text"":""{3}""}}}}}}";

            string commentXML = string.Format(template,
                uid, "title", HttpUtility.UrlEncode("http://www.bbc.co.uk/dna/h2g2/"),
                text);

            int finalForumcount = 0;
            int forumCount = testUtils_CommentsAPI.countForums(_sitename);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, uid);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentXML, "application/json", "PUT");
            }
            catch
            {
            }

            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            
            // check that we have created a new forum
            finalForumcount = testUtils_CommentsAPI.countForums(_sitename);

            Assert.AreEqual(forumCount, finalForumcount);

            /*
             * useful for debugging?
            // Check that the new fourm actually contains the number of comments that we expect.
            request.RequestPageWithFullURL(url, "", "text/xml", "GET");

            CommentForum theForum = (CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
            */

            Console.WriteLine("After CreateCommentForumWithCommentJson");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_JSONReturn()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?format=JSON", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            Assert.AreEqual("application/json", request.CurrentWebResponse.ContentType);


            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_JSON()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            CommentInfo inputComment = new CommentInfo() { text = text };
            string jsonComment = StringUtils.SerializeToJsonReturnAsString(inputComment);


            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, jsonComment, "application/json");

            

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            DateTime created = DateTime.Parse(returnedComment.Created.At);
            DateTime createdTest = BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(DateTime.Now.AddMinutes(5));
            Assert.IsTrue(created < createdTest);//should be less than 5mins
            Assert.IsTrue(!String.IsNullOrEmpty(returnedComment.Created.Ago));

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_WithSpaces()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());


            string text = "Functiontest\r\nTitle" + Guid.NewGuid().ToString();
            CommentInfo inputComment = new CommentInfo() { text = text };
            string jsonComment = StringUtils.SerializeToJsonReturnAsString(inputComment);


            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, jsonComment, "application/json");

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            //Assert.IsTrue(returnedComment.text == text.Replace("\r\n", "<BR />"));
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            text = "Functiontest\r\nTitle" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
               "<text>{0}</text>" +
               "</comment>", text);

            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            XmlNode pick = xml.SelectSingleNode("api:comment/api:text", nsmgr);
            Assert.IsTrue(pick.InnerText == text.Replace("\r\n", "<BR />")); 


            returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text.Replace("\r\n", "<BR />"));
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_JSON_WithMissingForum()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            CommentInfo inputComment = new CommentInfo() { text = text };
            string jsonComment = StringUtils.SerializeToJsonReturnAsString(inputComment);


            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, Guid.NewGuid().ToString());
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, jsonComment, "application/json");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.NotFound);
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_WithoutNamespace()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_WithBannedUser()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserBanned();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);
            

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_WithNoUser()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.CurrentCookie = "";
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_MissingText()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_PreModForum()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.PreMod);

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == "This post is awaiting moderation.");
            Assert.IsTrue(returnedComment.hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_PreModForumWithProcessPremod()
        {

            try
            {
                SetSiteOption(1, "Moderation", "ProcessPreMod", 1, "1");

                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();
                //create the forum
                CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.PreMod);

                string text = "Functiontest Title" + Guid.NewGuid().ToString();
                string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                    "<text>{0}</text>" +
                    "</comment>", text);

                // Setup the request url
                string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaComment);
                validator.Validate();

                CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
                Assert.IsTrue(returnedComment.text == "This post is awaiting moderation.");
                Assert.IsTrue(returnedComment.hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration);
                Assert.IsNotNull(returnedComment.User);
                Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);
            }
            finally
            {
                RemoveSiteOption(1, "ProcessPreMod");
            }

        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_PostModForum()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.PostMod);

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsTrue(returnedComment.hidden == CommentStatus.Hidden.NotHidden);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_ReactiveForum()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.Reactive);

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsTrue(returnedComment.hidden == CommentStatus.Hidden.NotHidden);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_PreModForumAsEditor()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString(), ModerationStatus.ForumStatus.PreMod);

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsTrue(returnedComment.hidden == CommentStatus.Hidden.NotHidden);
            Assert.IsTrue(returnedComment.ID > 0);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsPlainText()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            PostStyle.Style postStyle = PostStyle.Style.plaintext;
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "<poststyle>{1}</poststyle>" +
                "</comment>", text, postStyle);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();
            //check the TextAsHtml element
            //string textAsHtml = xml.DocumentElement.ChildNodes[2].InnerXml;
            //Assert.IsTrue(textAsHtml == "<div class=\"dna-comment text\" xmlns=\"\">" + text + "</div>");

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsTrue(returnedComment.PostStyle == postStyle);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsPlainTextWithHTMLTags()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            
            string text = "<b>Functiontest Title" + Guid.NewGuid().ToString() + "</b>";
            string expectedText = text.Replace("<b>", "").Replace("</b>", "");
            PostStyle.Style postStyle = PostStyle.Style.plaintext;
            string commentForumXml = String.Format("text={0}&poststyle={1}", text, postStyle);

            // Setup the request url
            string urlCreate = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm", _sitename, commentForum.Id);
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(urlCreate, commentForumXml, "application/x-www-form-urlencoded");

            //get the forum back as xml
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            XmlNode returnedText = xml.SelectSingleNode("api:commentForum/api:commentsList/api:comments/api:comment/api:text", nsmgr);

            Assert.AreEqual(expectedText, returnedText.InnerText);

            //get the forum back as json
            request.RequestPageWithFullURL(url, null, "text/javascript");
            CommentForum returnedForum = (CommentForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentForum));
            Assert.IsTrue(returnedForum.commentList.comments[0].text == expectedText, "Expected:" + expectedText + " Actual:" + returnedForum.commentList.comments[0].text);


        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsEditorWithHTMLTags_ReturnsUntouchedTags()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());


            string text = "<script>Functiontest Title" + Guid.NewGuid().ToString() + "</script>";
            string expectedText = text;
            PostStyle.Style postStyle = PostStyle.Style.richtext;
            string commentForumXml = String.Format("text={0}&poststyle={1}", text, postStyle);

            // Setup the request url
            string urlCreate = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm", _sitename, commentForum.Id);
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(urlCreate, commentForumXml, "application/x-www-form-urlencoded");

            //get the forum back as xml
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            XmlNode returnedText = xml.SelectSingleNode("api:commentForum/api:commentsList/api:comments/api:comment/api:text", nsmgr);

            Assert.AreEqual(expectedText, returnedText.InnerText);

            //get the forum back as json
            request.RequestPageWithFullURL(url, null, "text/javascript");
            CommentForum returnedForum = (CommentForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentForum));
            Assert.IsTrue(returnedForum.commentList.comments[0].text == expectedText, "Expected:" + expectedText + " Actual:" + returnedForum.commentList.comments[0].text);


        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsPlainTextWithHTMLLink_ReturnsTransformedLink()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string randomiser = Guid.NewGuid().ToString();
            string text = "http://www.bbc.co.uk/" + randomiser + " in the post";
            string expectedText = "<a href=\"http://www.bbc.co.uk/" + randomiser + "\">http://www.bbc.co.uk/" + randomiser + "</a> in the post";
            PostStyle.Style postStyle = PostStyle.Style.plaintext;
            string commentForumXml = String.Format("text={0}&poststyle={1}", text, postStyle);

            // Setup the request url
            string urlCreate = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/create.htm", _sitename, commentForum.Id);
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(urlCreate, commentForumXml, "application/x-www-form-urlencoded");

            //get the forum back as xml
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            XmlNode returnedText = xml.SelectSingleNode("api:commentForum/api:commentsList/api:comments/api:comment/api:text", nsmgr);

            Assert.AreEqual(expectedText, returnedText.InnerText);

            //get the forum back as json
            request.RequestPageWithFullURL(url, null, "text/javascript");
            CommentForum returnedForum = (CommentForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentForum));
            Assert.IsTrue(returnedForum.commentList.comments[0].text == expectedText, "Expected:" + expectedText + " Actual:" + returnedForum.commentList.comments[0].text);


        }


        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void PreviewComment_AsPlainTextWithHTMLLink_ReturnsTransformedLink()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string randomiser = Guid.NewGuid().ToString();
            string text = "http://www.bbc.co.uk/" + randomiser + " in the post";
            string expectedText = "<a href=\"http://www.bbc.co.uk/" + randomiser + "\">http://www.bbc.co.uk/" + randomiser + "</a> in the post";

            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><poststyle>plaintext</poststyle>" +
                "</comment>", text);

            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/preview", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == expectedText);

        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void PreviewComment_AsEditorWithHTMLLink_ReturnsTransformedLink()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string randomiser = Guid.NewGuid().ToString();
            string text = "http://www.bbc.co.uk/" + randomiser + " in the post &lt;script&gt;hello&lt;/script&gt;";
            string expectedText = "<a href=\"http://www.bbc.co.uk/" + randomiser + "\">http://www.bbc.co.uk/" + randomiser + "</a> in the post <script>hello</script>";

            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><poststyle>plaintext</poststyle>" +
                "</comment>", text);

            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/preview", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == expectedText);

        }


        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_InvalidPostStyle()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "<poststyle>{1}</poststyle>" +
                "</comment>", text, "invalid style");

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            CheckErrorSchema(request.GetLastResponseAsXML());

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_WithClosedForum()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            using (FullInputContext _context = new FullInputContext(""))
            {
                using (IDnaDataReader dataReader = _context.CreateDnaDataReader("updatecommentforumstatus"))
                {
                    dataReader.AddParameter("uid", commentForum.Id);
                    dataReader.AddParameter("canwrite", 0);
                    dataReader.Execute();
                }
            }

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            CheckErrorSchema(request.GetLastResponseAsXML());

            //try as an editor - should ignore moderation and post to closed forum
            request.SetCurrentUserEditor();
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);


            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsDuplicate()
        {
            Console.WriteLine("Before CreateComment_AsDuplicate");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);

            //try reposting same comment
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);


            request.RequestPageWithFullURL(url, null, "text/xml");
            var returnedForum = (CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
            Assert.AreEqual(1, returnedForum.commentSummary.Total);
            Console.WriteLine("After CreateComment_AsDuplicate");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_CheckAgoValues()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();
            string expectedResponse = "Just Now";
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");
            XmlNode ago = xml.SelectSingleNode("api:comment/api:created/api:ago", nsmgr);
            XmlNode commentId = xml.SelectSingleNode("api:comment/api:id", nsmgr);

            Assert.IsTrue(ago.InnerText == expectedResponse); 

            //set the comment time back 5 minutes
            using (FullInputContext _context = new FullInputContext(""))
            {
                using (IDnaDataReader dataReader = _context.CreateDnaDataReader("updatecommentforumstatus"))
                {
                    string sql = "update threadentries set DatePosted = dateadd(minute, -5, getdate()) where entryid = " + commentId.InnerText;
                    dataReader.ExecuteDEBUGONLY(sql);
    
                    sql = "INSERT INTO ForumLastUpdated (ForumID, LastUpdated) VALUES(" + commentForum.ForumID + ", getdate())";
                    dataReader.ExecuteDEBUGONLY(sql);
                }
            }

            request.RequestPageWithFullURL(url, null, "text/xml");
            xml = request.GetLastResponseAsXML();
            expectedResponse = "5 Minutes Ago";
            ago = xml.SelectSingleNode("api:commentForum/api:commentsList/api:comments/api:comment/api:created/api:ago", nsmgr);

            Assert.IsTrue(ago.InnerText == expectedResponse); 

            
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsInsecureWithoutOption_ReturnsError()
        {
            Console.WriteLine("Before CreateComment");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            request.UseDebugUserSecureCookie = false;

            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response

            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch{}
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);
            CheckErrorSchema(request.GetLastResponseAsXML());


            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsInsecureWithOptionSet_ReturnsComment()
        {
            try
            {

                Console.WriteLine("Before CreateComment");

                SetSecureSiteOption(0);

                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();
                //create the forum
                CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

                string text = "Functiontest Title" + Guid.NewGuid().ToString();
                string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                    "<text>{0}</text>" +
                    "</comment>", text);

                // Setup the request url
                string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
                // now get the response

                try
                {
                    request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
                }
                catch { }
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);
                
            }
            finally
            {
                RemoveSecureSiteOption();
            }


            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_WithSiteSuffixSiteOption()
        {
            Console.WriteLine("Before CreateComment_WithSiteSuffix");
            var siteId = 1;
            var udng = "fluffybunnyslippers";
            try
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();
                //create the forum
                CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

                string text = "Functiontest Title" + Guid.NewGuid().ToString();
                string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                    "<text>{0}</text>" +
                    "</comment>", text);

                // Setup the request url
                string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                validator.Validate();

                //check the TextAsHtml element
                //string textAsHtml = xml.DocumentElement.ChildNodes[2].InnerXml;
                //Assert.IsTrue(textAsHtml == "<div class=\"dna-comment text\" xmlns=\"\">" + text + "</div>");

                CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
                Assert.IsTrue(returnedComment.text == text);
                Assert.IsNotNull(returnedComment.User);
                Assert.AreEqual(string.Empty, returnedComment.User.SiteSpecificDisplayName);
                Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

                ConfigureUDNG(siteId, udng, "1");

                text = text + "with udng";
                commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                    "<text>{0}</text>" +
                    "</comment>", text);

                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
                // Check to make sure that the page returned with the correct information
                xml = request.GetLastResponseAsXML();
                validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                validator.Validate();

                returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
                Assert.IsTrue(returnedComment.text == text);
                Assert.IsNotNull(returnedComment.User);
                Assert.AreEqual(udng, returnedComment.User.SiteSpecificDisplayName);
                Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            }
            finally
            {
                ConfigureUDNG(siteId, "", "0");
            }

            Console.WriteLine("After CreateComment_WithSiteSuffix");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_AsPUT_CreatesComment()
        {
            var text = "Functiontest Title" + Guid.NewGuid().ToString();
            Console.WriteLine("Before CreateComment");
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            //create the forum
            CommentForum commentForum = CommentForumCreate("tests", Guid.NewGuid().ToString());

            CommentInfo returnedComment = CreateCommentHelperWithPut(commentForum, text, false, "");
            Assert.AreEqual(text, returnedComment.text);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            DateTime created = DateTime.Parse(returnedComment.Created.At);
            DateTime createdTest = BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(DateTime.Now.AddMinutes(5));
            Assert.IsTrue(created < createdTest);//should be less than 5mins
            Assert.IsTrue(!String.IsNullOrEmpty(returnedComment.Created.Ago));

            Console.WriteLine("After CreateComment");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_NotSignedIn_CreatesComment()
        {
            try
            {
                SetSiteOption(1, "CommentForum", "AllowNotSignedInCommenting", 1, "1");
                var text = "Functiontest Title" + Guid.NewGuid().ToString();
                var userName = "testUserName";

                //create the forum
                CommentForum commentForum = new CommentForum
                {
                    Id = Guid.NewGuid().ToString(),
                    ParentUri = "http://bbc.co.uk",
                    Title = Guid.NewGuid().ToString(),
                    allowNotSignedInCommenting = true
                };

                CommentInfo returnedComment = CreateCommentHelperWithPut(commentForum, text, true, userName);
                Assert.AreEqual(text, returnedComment.text);
                Assert.AreEqual(userName, returnedComment.User.DisplayName);
                Assert.IsNotNull(returnedComment.User);

                DateTime created = DateTime.Parse(returnedComment.Created.At);
                DateTime createdTest = BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(DateTime.Now.AddMinutes(5));
                Assert.IsTrue(created < createdTest);//should be less than 5mins
                Assert.IsTrue(!String.IsNullOrEmpty(returnedComment.Created.Ago));

                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();
                string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
                // now get the response
                request.RequestPageWithFullURL(url);
                XmlDocument xml = request.GetLastResponseAsXML();

                var returnedCommentForum = (CommentForum)StringUtils.DeserializeObject(xml.OuterXml, typeof(CommentForum));

                Assert.AreEqual(text, returnedCommentForum.commentList.comments[0].text);
                Assert.AreEqual(userName, returnedCommentForum.commentList.comments[0].User.DisplayName);
            }
            finally
            {
                RemoveSiteOption(1, "AllowNotSignedInCommenting");
            }
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_SignedInToNotSignedInForum_CreatesComment()
        {
            try
            {
                SetSiteOption(1, "CommentForum", "AllowNotSignedInCommenting", 1, "1");
                var text = "Functiontest Title" + Guid.NewGuid().ToString();
                var userName = "testUserName";

                //create the forum
                CommentForum commentForum = new CommentForum
                {
                    Id = Guid.NewGuid().ToString(),
                    ParentUri = "http://bbc.co.uk",
                    Title = Guid.NewGuid().ToString(),
                    allowNotSignedInCommenting = true
                };

                CommentInfo returnedComment = CreateCommentHelperWithPut(commentForum, text, true, userName);
                Assert.AreEqual(text, returnedComment.text);
                Assert.AreEqual(userName, returnedComment.User.DisplayName);
                Assert.IsNotNull(returnedComment.User);

                CreateCommentHelper(commentForum.Id);


                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();
                string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
                // now get the response
                request.RequestPageWithFullURL(url);
                XmlDocument xml = request.GetLastResponseAsXML();

                var returnedCommentForum = (CommentForum)StringUtils.DeserializeObject(xml.OuterXml, typeof(CommentForum));
                Assert.AreEqual(2, returnedCommentForum.commentList.TotalCount);
                Assert.AreEqual(request.CurrentUserName, returnedCommentForum.commentList.comments[1].User.DisplayName);
            }
            finally
            {
                RemoveSiteOption(1, "AllowNotSignedInCommenting");
            }
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateComment_NotSignedInWithoutSiteOption_ReturnsNotAuthorised()
        {
            var text = "Functiontest Title" + Guid.NewGuid().ToString();
            var userName = "testUserName";
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            //create the forum
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://bbc.co.uk",
                Title = Guid.NewGuid().ToString(),
                allowNotSignedInCommenting = true
            };


            try
            {
                CommentInfo returnedComment = CreateCommentHelperWithPut(commentForum, text, true, userName);
                throw new Exception("Should have thrown an error");
            }
            catch (Exception e)
            {
                Assert.IsTrue(e.Message.IndexOf("401") >= 0);
            }

        }

        private void ConfigureUDNG(int siteId, string udng, string siteSuffixValue)
        {
            using (FullInputContext _context = new FullInputContext(""))
            {
                if (siteSuffixValue == "1")
                {
                    using (IDnaDataReader dataReader = _context.CreateDnaDataReader("dbu_createsiteoption"))
                    {
                        dataReader.AddParameter("siteid",siteId);
                        dataReader.AddParameter("section", "User");
                        dataReader.AddParameter("Name", "UseSiteSuffix");
                        dataReader.AddParameter("Value", siteSuffixValue);
                        dataReader.AddParameter("Type", "1");
                        dataReader.AddParameter("Description", "");
                        dataReader.Execute();
                    }
                }
                else
                {
                    using (IDnaDataReader dataReader = _context.CreateDnaDataReader(""))
                    {
                        dataReader.ExecuteDEBUGONLY("delete from siteoptions where siteid=" + siteId.ToString() + " and Name='UseSiteSuffix'");
                    }
                }

                using (IDnaDataReader dataReader = _context.CreateDnaDataReader(""))
                {
                    dataReader.ExecuteDEBUGONLY("update preferences set sitesuffix='" + udng + "' where siteid=" + siteId.ToString() + " and userid=" + TestUserAccounts.GetNormalUserAccount.UserID);
                }

                DnaTestURLRequest myRequest = new DnaTestURLRequest(_sitename);
                myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/h2g2/?action=recache-site", "", "text/xml");
            }
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
        /// 
        /// </summary>
        /// <param name="value"></param>
        private void SetSecureSiteOption(int value)
        {
            SetSiteOption(1, "CommentForum", "EnforceSecurePosting", 0, value.ToString());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        private void RemoveSecureSiteOption()
        {
            RemoveSiteOption(1, "EnforceSecurePosting");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        private void SetSiteOption(int siteId, string section, string name, int type, string value)
        {
            //set max char option
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY(string.Format("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values({0},'{1}', '{2}','{3}',{4},'test option')", siteId, section, name, value, type));
                }
            }
            DnaTestURLRequest myRequest = new DnaTestURLRequest(_sitename);
            myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/h2g2/?action=recache-site", "", "text/xml");

        }

        private void RemoveSiteOption(int siteId, string name)
        {
            //set max char option
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where name='{1}' and siteid={0}", siteId, name));
                }
            }
            DnaTestURLRequest myRequest = new DnaTestURLRequest(_sitename);
            myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/h2g2/?action=recache-site&siteid=1", "", "text/xml");

        }
    }
}
