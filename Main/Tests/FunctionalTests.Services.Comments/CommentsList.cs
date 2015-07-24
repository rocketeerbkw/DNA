using BBC.Dna.Api;
using BBC.Dna.Common;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Xml;
using Tests;

namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Summary description for CommentsList
    /// </summary>
    [TestClass]
    public class CommentsListTests
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        private const string _schemaCommentsList = "Dna.Services\\commentsList.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private static string _hostAndPort = DnaTestURLRequest.CurrentServer.Host + ":" + DnaTestURLRequest.CurrentServer.Port;
        private static string _server = _hostAndPort;
        private readonly string _secureserver = DnaTestURLRequest.SecureServerAddress.Host;
        private string _sitename = "h2g2";

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
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentListBySitenameAndPrefixXML()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");
            //create 3 forums with a prefix and one without
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-"; //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id = string.Empty;
            string url = string.Empty;
            string commentForumXml = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id = prefix + Guid.NewGuid();
                commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                "<id>{0}</id>" +
                                                "<title>{1}</title>" +
                                                "<parentUri>{2}</parentUri>" +
                                                "</commentForum>", id, title, parentUri);

                // Setup the request url
                url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                    _sitename);
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
                // Check to make sure that the page returned with the correct information
                // Check to make sure that the page returned with the correct information
                xml = request.GetLastResponseAsXML();
                validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                validator.Validate();

                returnedForum =
                    (CommentForum)
                    StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
                Assert.IsTrue(returnedForum.Id == id);

                //post comments to list
                for (int j = 0; j < 3; j++)
                {
                    string text = "Functiontest Title" + Guid.NewGuid();
                    string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                                                      "<text>{0}</text>" +
                                                      "</comment>", text);

                    // Setup the request url
                    url =
                        String.Format(
                            "https://" + _secureserver +
                            "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename,
                            returnedForum.Id);
                    // now get the response
                    request.RequestPageWithFullURL(url, commentXml, "text/xml");
                    // Check to make sure that the page returned with the correct information
                    xml = request.GetLastResponseAsXML();
                    validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                    validator.Validate();

                    var returnedComment =
                        (CommentInfo)
                        StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
                    Assert.IsTrue(returnedComment.text == text);
                    Assert.IsNotNull(returnedComment.User);
                    Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);
                }
            }
            //create a non-prefixed one
            id = Guid.NewGuid().ToString();
            commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                            "<id>{0}</id>" +
                                            "<title>{1}</title>" +
                                            "<parentUri>{2}</parentUri>" +
                                            "</commentForum>", id, title, parentUri);

            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?prefix={1}",
                    _sitename, prefix);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentsList);
            validator.Validate();

            var returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList != null);
            //Assert.IsTrue(returnedList.TotalCount == 9); // 3 forums with 3 comments per forum = 9
            Console.WriteLine("After GetCommentForumsBySitenameXML");
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentListBySitenameAndPrefixXML_WithSorting_ByCreated()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");
            //create 3 forums with a prefix and one without
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-"; //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id = string.Empty;
            string url = string.Empty;
            string commentForumXml = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id = prefix + Guid.NewGuid();
                commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                "<id>{0}</id>" +
                                                "<title>{1}</title>" +
                                                "<parentUri>{2}</parentUri>" +
                                                "</commentForum>", id, title, parentUri);

                // Setup the request url
                url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                    _sitename);
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
                // Check to make sure that the page returned with the correct information
                // Check to make sure that the page returned with the correct information
                xml = request.GetLastResponseAsXML();
                validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                validator.Validate();

                returnedForum =
                    (CommentForum)
                    StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
                Assert.IsTrue(returnedForum.Id == id);

                //post comments to list
                for (int j = 0; j < 3; j++)
                {
                    string text = "Functiontest Title" + Guid.NewGuid();
                    string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                                                      "<text>{0}</text>" +
                                                      "</comment>", text);

                    // Setup the request url
                    url =
                        String.Format(
                            "https://" + _secureserver +
                            "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename,
                            returnedForum.Id);
                    // now get the response
                    request.RequestPageWithFullURL(url, commentXml, "text/xml");
                    // Check to make sure that the page returned with the correct information
                    xml = request.GetLastResponseAsXML();
                    validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                    validator.Validate();

                    var returnedComment =
                        (CommentInfo)
                        StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
                    Assert.IsTrue(returnedComment.text == text);
                    Assert.IsNotNull(returnedComment.User);
                    Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);
                }
            }
            //create a non-prefixed one
            id = Guid.NewGuid().ToString();
            commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                            "<id>{0}</id>" +
                                            "<title>{1}</title>" +
                                            "<parentUri>{2}</parentUri>" +
                                            "</commentForum>", id, title, parentUri);

            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?prefix={1}",
                    _sitename, prefix);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentsList);
            validator.Validate();

            var returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList != null);
            Console.WriteLine("After GetCommentForumsBySitenameXML");

            //////////////////////////////
            //set up sorting tests
            //////////////////////////////
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/",
                                _sitename, returnedForum.Id);
            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created case insensitive
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection); // should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            // should fail and return the default
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test sort by created case insensitive
            sortBy = SortBy.Created.ToString().ToLower();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());
            // should fail and return the default which is Created

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }


            //test sort by created case with defaults (created and ascending
            sortBy = "";
            sortDirection = "";
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());
            // should fail and return the default which is Created

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentListBySitenameXML()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");
            //create 3 forums with a prefix and one without
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-"; //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id = string.Empty;
            string url = string.Empty;
            string commentForumXml = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id = prefix + Guid.NewGuid();
                commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                "<id>{0}</id>" +
                                                "<title>{1}</title>" +
                                                "<parentUri>{2}</parentUri>" +
                                                "</commentForum>", id, title, parentUri);

                // Setup the request url
                url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                    _sitename);
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
                // Check to make sure that the page returned with the correct information
                // Check to make sure that the page returned with the correct information
                xml = request.GetLastResponseAsXML();
                validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                validator.Validate();

                returnedForum =
                    (CommentForum)
                    StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
                Assert.IsTrue(returnedForum.Id == id);

                //post comments to list
                for (int j = 0; j < 3; j++)
                {
                    string text = "Functiontest Title" + Guid.NewGuid();
                    string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                                                      "<text>{0}</text>" +
                                                      "</comment>", text);

                    // Setup the request url
                    url =
                        String.Format(
                            "https://" + _secureserver +
                            "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename,
                            returnedForum.Id);
                    // now get the response
                    request.RequestPageWithFullURL(url, commentXml, "text/xml");
                    // Check to make sure that the page returned with the correct information
                    xml = request.GetLastResponseAsXML();
                    validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                    validator.Validate();

                    var returnedComment =
                        (CommentInfo)
                        StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
                    Assert.IsTrue(returnedComment.text == text);
                    Assert.IsNotNull(returnedComment.User);
                    Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);
                }
            }
            //create a non-prefixed one
            id = Guid.NewGuid().ToString();
            commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                            "<id>{0}</id>" +
                                            "<title>{1}</title>" +
                                            "<parentUri>{2}</parentUri>" +
                                            "</commentForum>", id, title, parentUri);

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/",
                                _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentsList);
            validator.Validate();

            var returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList != null);
            Assert.IsTrue(returnedList.TotalCount != 0);
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentListBySitenameXML_WithSorting_ByCreated()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");
            //create 3 forums with a prefix and one without
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-"; //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id = string.Empty;
            string url = string.Empty;
            string commentForumXml = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id = prefix + Guid.NewGuid();
                commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                "<id>{0}</id>" +
                                                "<title>{1}</title>" +
                                                "<parentUri>{2}</parentUri>" +
                                                "</commentForum>", id, title, parentUri);

                // Setup the request url
                url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                    _sitename);
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
                // Check to make sure that the page returned with the correct information
                // Check to make sure that the page returned with the correct information
                xml = request.GetLastResponseAsXML();
                validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                validator.Validate();

                returnedForum =
                    (CommentForum)
                    StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));
                Assert.IsTrue(returnedForum.Id == id);

                //post comments to list
                for (int j = 0; j < 3; j++)
                {
                    string text = "Functiontest Title" + Guid.NewGuid();
                    string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                                                      "<text>{0}</text>" +
                                                      "</comment>", text);

                    // Setup the request url
                    url =
                        String.Format(
                            "https://" + _secureserver +
                            "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename,
                            returnedForum.Id);
                    // now get the response
                    request.RequestPageWithFullURL(url, commentXml, "text/xml");
                    // Check to make sure that the page returned with the correct information
                    xml = request.GetLastResponseAsXML();
                    validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                    validator.Validate();

                    var returnedComment =
                        (CommentInfo)
                        StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
                    Assert.IsTrue(returnedComment.text == text);
                    Assert.IsNotNull(returnedComment.User);
                    Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);
                }
            }
            //create a non-prefixed one
            id = Guid.NewGuid().ToString();
            commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                            "<id>{0}</id>" +
                                            "<title>{1}</title>" +
                                            "<parentUri>{2}</parentUri>" +
                                            "</commentForum>", id, title, parentUri);

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/",
                                _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentsList);
            validator.Validate();

            var returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList != null);
            Assert.IsTrue(returnedList.TotalCount != 0);

            //////////////////////////////
            //set up sorting tests
            //////////////////////////////
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/",
                                _sitename, returnedForum.Id);
            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created case insensitive
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection); // should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            // should fail and return the default
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test sort by created case insensitive
            sortBy = SortBy.Created.ToString().ToLower();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());
            // should fail and return the default which is Created

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }


            //test sort by created case with defaults (created and ascending
            sortBy = "";
            sortDirection = "";
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (BBC.Dna.Api.CommentsList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());
            // should fail and return the default which is Created

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// Request comments filtered by Editors Picks.
        /// Creates 2 comments. Picks first comment.
        /// Expect only first comment to be present in editor picks filtered list.
        /// </summary>
        [TestMethod]
        public void GetCommentListBySitenameXML_WithEditorsPickFilter()
        {
            //Create Comment.
            var comment = new CommentsTests_V1();
            var commentForumTest = new CommentForumTests_V1();


            //create the forum
            CommentForum commentForum = commentForumTest.CommentForumCreateHelper();
            CommentInfo commentInfo = comment.CreateCommentHelper(commentForum.Id);
            CommentInfo commentInfo2 = comment.CreateCommentHelper(commentForum.Id);

            //Create Editors Pick on first comment only.
            var editorsPicks = new EditorsPicks_V1();
            editorsPicks.CreateEditorsPickHelper(_sitename, commentInfo.ID);


            //Request Comments Filtered by Editors Picks.
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url =
                String.Format(
                    "http://" + _server +
                    "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?filterBy=EditorPicks", _sitename);

            //Check that picked comment is in results.
            request.RequestPageWithFullURL(url, "", "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            //Check Schema
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            var nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");

            String xPath = String.Format("api:commentsList/api:comments/api:comment[api:id='{0}']", commentInfo.ID);
            XmlNode pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNotNull(pick);

            //Check Comment that has not been picked is not present.
            xPath = String.Format("api:commentsList/api:comments/api:comment[api:id='{0}']", commentInfo2.ID);
            pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNull(pick);
        }
    }
}