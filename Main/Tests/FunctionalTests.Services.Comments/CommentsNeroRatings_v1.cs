using BBC.Dna.Api;
using BBC.Dna.Api.Contracts;
using BBC.Dna.Common;
using BBC.Dna.Data;
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
    public class CommentsNeroRatings_v1
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        private const string _schemaComment = "Dna.Services\\comment.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private static string _hostAndPort = DnaTestURLRequest.CurrentServer.Host + ":" + DnaTestURLRequest.CurrentServer.Port;

        private static string _server = _hostAndPort;
        private string _secureserver = _hostAndPort;
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
            //SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public CommentsNeroRatings_v1()
        {
            commentsHelper = new CommentsTests_V1();
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        public void CreateTestForumAndComment(ref CommentForum commentForum, ref CommentInfo returnedComment)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            //create the forum
            if (string.IsNullOrEmpty(commentForum.Id))
            {
                commentForum = commentsHelper.CommentForumCreate("tests", Guid.NewGuid().ToString());
            }

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
        public void RateUpComment_AsLoggedInUserV2_ReturnsValidTotal()
        {
            int apiVersion = 2;
            CreateCommentAndRateUpAsNormalUserAndValidate(apiVersion);
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void RateUpComment_AsLoggedInUserV1_ReturnsValidTotal()
        {
            int apiVersion = 1;
            CreateCommentAndRateUpAsNormalUserAndValidate(apiVersion);
        }

        private void CreateCommentAndRateUpAsNormalUserAndValidate(int apiVersion)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/up", _sitename, commentForum.Id, commentInfo.ID, apiVersion);

            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            if (apiVersion == 1)
            {
                Assert.AreEqual("1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(1, neroRatingInfo.neroValue);
                Assert.AreEqual(1, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(0, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We only support version 1 or 2 of ratings!");
            }

            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum = (CommentForum)StringUtils.DeserializeObject(xml.InnerXml, typeof(CommentForum));
            Assert.AreEqual(1, returnedForum.commentList.comments[0].NeroRatingValue);

            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/{1}", _sitename, returnedForum.commentList.comments[0].ID);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaComment);
            validator.Validate();

            var returnedComment = (CommentInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(CommentInfo));
            Assert.AreEqual(1, returnedComment.NeroRatingValue);
            Assert.AreEqual(1, returnedComment.NeroPositiveRatingValue);
            Assert.AreEqual(0, returnedComment.NeroNegativeRatingValue);
        }

        [TestMethod]
        public void RateDownComment_AsAnonymousWithAttributesV2_ReturnsValidTotal()
        {
            int apiVersion = 2;

            CreateCommentAndRateDownAsAnonymousUserAndValidate(apiVersion);
        }

        [TestMethod]
        public void RateDownComment_AsAnonymousWithAttributesV1_ReturnsValidTotal()
        {
            int apiVersion = 1;

            CreateCommentAndRateDownAsAnonymousUserAndValidate(apiVersion);
        }

        private void CreateCommentAndRateDownAsAnonymousUserAndValidate(int apiVersion)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);

            try
            {
                SetSiteOption(1, "CommentForum", "AllowNotSignedInRating", 1, "1");
                request.AddCookie(new Cookie("BBC-UID", "a4acfefaf9d7a374026abfa9419a957ae48c5e5800803144642fba8aadcff86f0Mozilla%2f5%2e0%20%28Windows%3b%20U%3b%20Windows%20NT%205%2e1%3b%20en%2dGB%3b%20rv%3a1%2e9%2e2%2e12%29%20Gecko%2f20101026%20Firefox%2f3%2e6%2e12%20%28%2eNET%20CLR%203%2e5%2e30729%29"));
                string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/down?clientIp=1.1.1.1", _sitename, commentForum.Id, commentInfo.ID, apiVersion);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();

                if (apiVersion == 1)
                {
                    Assert.AreEqual("-1", xml.DocumentElement.InnerText);
                }
                else if (apiVersion == 2)
                {
                    var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                    Assert.AreEqual(-1, neroRatingInfo.neroValue);
                    Assert.AreEqual(0, neroRatingInfo.positiveNeroValue);
                    Assert.AreEqual(-1, neroRatingInfo.negativeNeroValue);
                }
                else
                {
                    Assert.Fail("We don't support any other version than 1 or 2");
                }


                url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                xml = request.GetLastResponseAsXML();
                var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                validator.Validate();


                var returnedForum = (CommentForum)StringUtils.DeserializeObject(xml.InnerXml, typeof(CommentForum));
                Assert.AreEqual(-1, returnedForum.commentList.comments[0].NeroRatingValue);
                Assert.AreEqual(0, returnedForum.commentList.comments[0].NeroPositiveRatingValue);
                Assert.AreEqual(-1, returnedForum.commentList.comments[0].NeroNegativeRatingValue);
            }
            finally
            {
                RemoveSiteOption(1, "AllowNotSignedInRating");
            }
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
                SetSiteOption(1, "CommentForum", "AllowNotSignedInRating", 1, "1");
                request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
                throw new Exception("should have thrown one...");
            }
            catch
            {
                Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            }
            finally
            {
                RemoveSiteOption(1, "AllowNotSignedInRating");
            }
        }

        [TestMethod]
        public void RateUpComment_AsAnonymousWithSiteOptionSet_ReturnsUnauthorised()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/comment/{2}/rate/up", _sitename, commentForum.Id, commentInfo.ID);
            // now get the response
            try
            {
                SetSiteOption(1, "CommentForum", "AllowNotSignedInRating", 1, "0");

                request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
                throw new Exception("should have thrown one...");
            }
            catch
            {
                Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            }
            finally
            {
                RemoveSiteOption(1, "AllowNotSignedInRating");
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

        [TestMethod]
        public void RateUpComment_ChangesValueV2_ReturnsValidTotal()
        {
            int apiVersion = 2;
            CreateCommentAndRateUpAndDown(apiVersion);
        }

        [TestMethod]
        public void RateUpComment_ChangesValueV1_ReturnsValidTotal()
        {
            int apiVersion = 1;
            CreateCommentAndRateUpAndDown(apiVersion);
        }

        private void CreateCommentAndRateUpAndDown(int apiVersion)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/up", _sitename, commentForum.Id, commentInfo.ID, apiVersion);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            if (apiVersion == 1)
            {
                Assert.AreEqual("1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(1, neroRatingInfo.neroValue);
                Assert.AreEqual(1, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(0, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }
            //Assert.AreEqual("1", xml.DocumentElement.InnerText);

            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/down", _sitename, commentForum.Id, commentInfo.ID, apiVersion);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            xml = request.GetLastResponseAsXML();
            if (apiVersion == 1)
            {
                Assert.AreEqual("-1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(-1, neroRatingInfo.neroValue);
                Assert.AreEqual(0, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(-1, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }
            //Assert.AreEqual("-1", xml.DocumentElement.InnerText);

            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum = (CommentForum)StringUtils.DeserializeObject(xml.InnerXml, typeof(CommentForum));
            Assert.AreEqual(-1, returnedForum.commentList.comments[0].NeroRatingValue);
            Assert.AreEqual(0, returnedForum.commentList.comments[0].NeroPositiveRatingValue);
            Assert.AreEqual(-1, returnedForum.commentList.comments[0].NeroNegativeRatingValue);
        }

        [TestMethod]
        public void RateUpComment_DuplicateV2_ReturnsValidTotal()
        {
            int apiVersion = 2;
            CreateCommentAndRateUpValidateTotal(apiVersion);
        }

        [TestMethod]
        public void RateUpComment_DuplicateV1_ReturnsValidTotal()
        {
            int apiVersion = 1;
            CreateCommentAndRateUpValidateTotal(apiVersion);
        }

        private void CreateCommentAndRateUpValidateTotal(int apiVersion)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/up", _sitename, commentForum.Id, commentInfo.ID, apiVersion);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            if (apiVersion == 1)
            {
                Assert.AreEqual("1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(1, neroRatingInfo.neroValue);
                Assert.AreEqual(1, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(0, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }

            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            xml = request.GetLastResponseAsXML();
            if (apiVersion == 1)
            {
                Assert.AreEqual("1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(1, neroRatingInfo.neroValue);
                Assert.AreEqual(1, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(0, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }

            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum = (CommentForum)StringUtils.DeserializeObject(xml.InnerXml, typeof(CommentForum));
            Assert.AreEqual(1, returnedForum.commentList.comments[0].NeroRatingValue);
            Assert.AreEqual(1, returnedForum.commentList.comments[0].NeroPositiveRatingValue);
            Assert.AreEqual(0, returnedForum.commentList.comments[0].NeroNegativeRatingValue);
        }

        [TestMethod]
        public void RateUpComment_MultipleRatingsV2_ReturnsValidTotal()
        {
            int apiVersion = 2;
            CreateCommentRateupTwiceDownonceAndValidate(apiVersion);
        }

        [TestMethod]
        public void RateUpComment_MultipleRatingsV1_ReturnsValidTotal()
        {
            int apiVersion = 1;
            CreateCommentRateupTwiceDownonceAndValidate(apiVersion);
        }

        private void CreateCommentRateupTwiceDownonceAndValidate(int apiVersion)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/up", _sitename, commentForum.Id, commentInfo.ID, apiVersion);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            if (apiVersion == 1)
            {
                Assert.AreEqual("1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(1, neroRatingInfo.neroValue);
                Assert.AreEqual(1, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(0, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }
            request.SetCurrentUserModerator();
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            xml = request.GetLastResponseAsXML();
            if (apiVersion == 1)
            {
                Assert.AreEqual("2", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(2, neroRatingInfo.neroValue);
                Assert.AreEqual(2, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(0, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }

            request.SetCurrentUserNotableUser();
            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/down", _sitename, commentForum.Id, commentInfo.ID, apiVersion);
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            xml = request.GetLastResponseAsXML();
            if (apiVersion == 1)
            {
                Assert.AreEqual("1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(1, neroRatingInfo.neroValue);
                Assert.AreEqual(2, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(-1, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }

            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum = (CommentForum)StringUtils.DeserializeObject(xml.InnerXml, typeof(CommentForum));
            Assert.AreEqual(1, returnedForum.commentList.comments[0].NeroRatingValue);
            Assert.AreEqual(2, returnedForum.commentList.comments[0].NeroPositiveRatingValue);
            Assert.AreEqual(-1, returnedForum.commentList.comments[0].NeroNegativeRatingValue);
        }

        [TestMethod]
        public void RateUpComment_SortByRatingValueV2_ReturnsCorrectOrder()
        {
            int apiVersion = 2;
            CreateCommentsWithDifferentRatingsAndValidate(apiVersion);
        }

        [TestMethod]
        public void RateUpComment_SortByRatingValueV1_ReturnsCorrectOrder()
        {
            int apiVersion = 1;
            CreateCommentsWithDifferentRatingsAndValidate(apiVersion);
        }

        private void CreateCommentsWithDifferentRatingsAndValidate(int apiVersion)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            CommentForum commentForum = new CommentForum();
            CommentInfo commentInfo = new CommentInfo();
            CommentInfo commentInfo2 = new CommentInfo();
            CreateTestForumAndComment(ref commentForum, ref commentInfo);
            CreateTestForumAndComment(ref commentForum, ref commentInfo2);

            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/up", _sitename, commentForum.Id, commentInfo.ID, apiVersion);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            //Assert.AreEqual("1", xml.DocumentElement.InnerText);
            if (apiVersion == 1)
            {
                Assert.AreEqual("1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(1, neroRatingInfo.neroValue);
                Assert.AreEqual(1, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(0, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }

            request.SetCurrentUserModerator();
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            xml = request.GetLastResponseAsXML();
            //Assert.AreEqual("2", xml.DocumentElement.InnerText);
            if (apiVersion == 1)
            {
                Assert.AreEqual("2", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(2, neroRatingInfo.neroValue);
                Assert.AreEqual(2, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(0, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }

            request.SetCurrentUserNotableUser();
            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V{3}/site/{0}/commentsforums/{1}/comment/{2}/rate/down", _sitename, commentForum.Id, commentInfo2.ID, apiVersion);
            request.RequestPageWithFullURL(url, null, "text/xml", "PUT");
            xml = request.GetLastResponseAsXML();
            //Assert.AreEqual("-1", xml.DocumentElement.InnerText);
            if (apiVersion == 1)
            {
                Assert.AreEqual("-1", xml.DocumentElement.InnerText);
            }
            else if (apiVersion == 2)
            {
                var neroRatingInfo = (NeroRatingInfo)StringUtils.DeserializeObject(xml.InnerXml, typeof(NeroRatingInfo));
                Assert.AreEqual(-1, neroRatingInfo.neroValue);
                Assert.AreEqual(0, neroRatingInfo.positiveNeroValue);
                Assert.AreEqual(-1, neroRatingInfo.negativeNeroValue);
            }
            else
            {
                Assert.Fail("We don't support any other version than 1 or 2");
            }

            //test as ascending
            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?sortBy={2}&sortDirection={3}", _sitename, commentForum.Id, SortBy.RatingValue, SortDirection.Ascending);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum = (CommentForum)StringUtils.DeserializeObject(xml.InnerXml, typeof(CommentForum));
            Assert.AreEqual(commentInfo2.ID, returnedForum.commentList.comments[0].ID);
            Assert.AreEqual(commentInfo.ID, returnedForum.commentList.comments[1].ID);

            //test as ascending
            url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?sortBy={2}&sortDirection={3}", _sitename, commentForum.Id, SortBy.RatingValue, SortDirection.Descending);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            returnedForum = (CommentForum)StringUtils.DeserializeObject(xml.InnerXml, typeof(CommentForum));
            Assert.AreEqual(commentInfo.ID, returnedForum.commentList.comments[0].ID);
            Assert.AreEqual(commentInfo2.ID, returnedForum.commentList.comments[1].ID);
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
