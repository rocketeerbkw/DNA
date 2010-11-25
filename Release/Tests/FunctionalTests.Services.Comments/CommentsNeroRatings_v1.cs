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
    public class CommentsNeroRatings_v1
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        private const string _schemaComment = "Dna.Services\\comment.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _secureserver = DnaTestURLRequest.SecureServerAddress;
        private string _sitename = "h2g2";
        private CommentsTests_V1 commentsHelper;

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
        public CommentsNeroRatings_v1()
        {
            commentsHelper = new CommentsTests_V1();
          
        }

        public void CreateTestForumAndComment(ref CommentForum commentForum, ref CommentInfo returnedComment)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            commentForum = commentsHelper.CommentForumCreate("tests", Guid.NewGuid().ToString());

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

            returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            DateTime created = DateTime.Parse(returnedComment.Created.At);
            DateTime createdTest = BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(DateTime.Now.AddMinutes(5));
            Assert.IsTrue(created < createdTest);//should be less than 5mins
            Assert.IsTrue(!String.IsNullOrEmpty(returnedComment.Created.Ago));
        }


        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void RateUpComment_AsLoggedInUser_ReturnsValidTotal()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/comment/{2}/rate/up",_sitename,commentForum.Id, commentInfo.ID);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            
        }

        [TestMethod]
        public void RateUpComment_AsAnonymousWithAttributes_ReturnsValidTotal()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);

            request.AddCookie(new Cookie("BBC-UID", "a4acfefaf9d7a374026abfa9419a957ae48c5e5800803144642fba8aadcff86f0Mozilla%2f5%2e0%20%28Windows%3b%20U%3b%20Windows%20NT%205%2e1%3b%20en%2dGB%3b%20rv%3a1%2e9%2e2%2e12%29%20Gecko%2f20101026%20Firefox%2f3%2e6%2e12%20%28%2eNET%20CLR%203%2e5%2e30729%29"));
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/comment/{2}/rate/up?clientIp=1.1.1.1", _sitename, commentForum.Id, commentInfo.ID);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();

        }

        [TestMethod]
        public void RateUpComment_AsAnonymousWithoutAttributes_ReturnsUnauthorised()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/comment/{2}/rate/up", _sitename, commentForum.Id, commentInfo.ID);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
                throw new Exception("should have thrown one...");
            }
            catch
            {
                Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            }

        }

        [TestMethod]
        public void RateUpComment_InvalidCommentId_ReturnsCommentNotFound()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/test/comment/notacomment/rate/up", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
                throw new Exception("should have thrown one...");
            }
            catch
            {
                Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            }

        }

        
    }
}
