using System;
using System.Linq;
using System.Net;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using TestUtils;
using BBC.Dna.Sites;

namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class CommentForumTests_V1
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        private const string _schemaCommentsList = "Dna.Services\\commentsList.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private readonly string _server = DnaTestURLRequest.CurrentServer;
        private readonly string _secureServer = DnaTestURLRequest.SecureServerAddress;
        private string _sitename = "h2g2";
        private ISiteList _siteList;

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
            FullInputContext context = new FullInputContext("");

            _siteList = context.SiteList;
        }

        public CommentForum CommentForumCreateHelper()
        {
            string nameSpace = "Tests";
            string id = Guid.NewGuid().ToString();
            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.Reactive;
            DateTime closingDate = DateTime.MinValue;

            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
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
                                                   "</commentForum>", id, title, parentUri, nameSpace,
                                                   closingDate.ToString("yyyy-MM-dd"), moderationStatus);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedForum.Id == id);

            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            return returnedForum;
        }

 
        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));

            //check the content language returned
            Assert.IsNotNull(request.CurrentWebResponse.Headers["Content-Language"]);
            Assert.AreEqual(request.CurrentWebResponse.Headers["Content-Language"], _siteList.GetSiteOptionValueString(1, "General", "SiteLanguage"));
            Console.WriteLine("After GetCommentForumsBySitenameXML");
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithSorting_ByCreated()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created case insensitive
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Ascending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection); // should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            // should fail and return the default
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test sort by created case insensitive
            sortBy = SortBy.Created.ToString().ToLower();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());
            // should fail and return the default which is Created

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithSorting_ByLastPosted()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            string sortBy = SortBy.LastPosted.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Updated.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created
            sortBy = SortBy.LastPosted.ToString();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Updated.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created case insensitive
            sortBy = SortBy.LastPosted.ToString();
            sortDirection = SortDirection.Ascending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection); // should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            // should fail and return the default
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Updated.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test sort by created case insensitive
            sortBy = SortBy.LastPosted.ToString().ToLower();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Updated.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithSorting_ByPostCount()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            string sortBy = SortBy.PostCount.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            int prevTotal = 0;
            int currentTotal;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentTotal = returnedList.CommentForums[i].commentSummary.Total;
                Assert.IsTrue(currentTotal >= prevTotal);
                prevTotal = currentTotal;
            }

            //test descending created
            sortBy = SortBy.PostCount.ToString();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevTotal = int.MaxValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentTotal = returnedList.CommentForums[i].commentSummary.Total;
                Assert.IsTrue(currentTotal <= prevTotal);
                prevTotal = currentTotal;
            }

            //test descending created case insensitive
            sortBy = SortBy.PostCount.ToString();
            sortDirection = SortDirection.Ascending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection); // should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            // should fail and return the default
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevTotal = 0;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentTotal = returnedList.CommentForums[i].commentSummary.Total;
                Assert.IsTrue(currentTotal >= prevTotal);
                prevTotal = currentTotal;
            }

            //test sort by created case insensitive
            sortBy = SortBy.PostCount.ToString().ToLower();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.AreEqual(SortBy.Created, returnedList.SortBy);
            // should fail and return the default which is Created
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameAndPrefixXML_WithSorting_ByCreated()
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
                    StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
                Assert.IsTrue(returnedForum.Id == id);
            }
            //create a non-prefixed one
            id = Guid.NewGuid().ToString();
            commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                            "<id>{0}</id>" +
                                            "<title>{1}</title>" +
                                            "<parentUri>{2}</parentUri>" +
                                            "</commentForum>", id, title, parentUri);

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedForum.Id == id);

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/?prefix={1}",
                                _sitename, prefix);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList != null);
            Console.WriteLine("After GetCommentForumsBySitenameXML");

            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "&sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created case insensitive
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Ascending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection); // should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            // should fail and return the default
            Assert.IsTrue(returnedList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test sort by created case insensitive
            sortBy = SortBy.Created.ToString().ToLower();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());
            // should fail and return the default which is Created

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }
        }


        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithPaging()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            int forumCount = 0;
            while (returnedList.TotalCount > forumCount)
            {
                url =
                    String.Format(
                        "http://" + _server +
                        "/dna/api/comments/CommentsService.svc/V1/site/{0}/?itemsPerPage=1&startIndex={1}", _sitename,
                        forumCount);

                // now get the response
                request.RequestPageWithFullURL(url, "", "text/xml");

                // Check to make sure that the page returned with the correct information
                xml = request.GetLastResponseAsXML();
                validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
                validator.Validate();

                returnedList =
                    (CommentForumList)
                    StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
                forumCount += returnedList.CommentForums.Count;
            }
            Assert.IsTrue(forumCount == returnedList.TotalCount);
            Console.WriteLine("After GetCommentForumsBySitenameXML");
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameJSON method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameJSON()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameJSON");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "application/json");
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            Console.WriteLine("After GetCommentForumsBySitenameJSON");
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML_InvalidSiteName()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       "NOTAVALIDSITE");

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, "", "text/xml");
            }
            catch { }
            Assert.AreEqual(request.CurrentWebResponse.StatusCode, HttpStatusCode.NotFound);
        }

        /// <summary>
        /// Test GetCommentForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumXML()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            //get the first for test
            CommentForum commentForum = returnedList.CommentForums.First();

            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, commentForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
        }

        /// <summary>
        /// Test GetCommentForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumXML_WithSorting_ByCreated()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedForum.Id == id);
            //create 10 comments
            for (int i = 0; i < 3; i++)
            {
                string text = "Functiontest Title" + Guid.NewGuid();
                string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                                                  "<text>{0}</text>" +
                                                  "</comment>", text);

                // Setup the request url
                url =
                    String.Format(
                        "https://" + _secureServer + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                        _sitename, returnedForum.Id);
                // now get the response
                request.RequestPageWithFullURL(url, commentXml, "text/xml");
            }
            //////////////////////////////
            //set up sorting tests
            //////////////////////////////
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, returnedForum.Id);
            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            var returnedList =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() == sortBy);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < returnedList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created case insensitive
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() != sortDirection);
            // should fail and return the default
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            // should fail and return the default
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test sort by created case insensitive
            sortBy = SortBy.Created.ToString().ToLower();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() == SortBy.Created.ToString());
            // should fail and return the default which is Created

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }


            //test sort by created case with defaults (created and ascending
            sortBy = "";
            sortDirection = "";
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() != sortDirection);
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() != sortBy);
            // should fail and return the default which is Created
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() == SortBy.Created.ToString());
            // should fail and return the default which is Created

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// Test GetCommentForumJSONWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumJSON()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            //get the first for test
            CommentForum commentForum = returnedList.CommentForums.First();

            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, commentForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "application/json");

            var returnedForum =
                (CommentForum)
                StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof (CommentForum));
        }

        /// <summary>
        /// Test GetCommentForum
        /// </summary>
        [TestMethod]
        public void GetCommentForumHTML()
        {
            Console.WriteLine("Before GetCommentForumHTML");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            //get the first for test
            CommentForum commentForum = returnedList.CommentForums.First();

            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, commentForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/html");
            Assert.IsTrue(request.GetLastResponseAsString().IndexOf("<div") >= 0);


            Console.WriteLine("After GetCommentForumHTML");
        }

        /// <summary>
        /// Test GetCommentForum
        /// </summary>
        [TestMethod]
        public void GetCommentForumHTML_XsltCacheTest()
        {
            Console.WriteLine("Before GetCommentForumHTML_XsltCacheTest");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            //get the first for test
            CommentForum commentForum = returnedList.CommentForums[0];

            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, commentForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/html");
            Assert.IsTrue(request.GetLastResponseAsString().IndexOf("<div") >= 0);

            commentForum = returnedList.CommentForums[1];
            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, commentForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/html");
            Assert.IsTrue(request.GetLastResponseAsString().IndexOf("<div") >= 0);


            Console.WriteLine("After GetCommentForumHTML_XsltCacheTest");
        }

        /// <summary>
        /// Test GetCommentForumJSONWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumRSS()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            //get the first for test
            CommentForum commentForum = returnedList.CommentForums.First();
            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, "", "application/rss xml");
            url =
                String.Format(
                    "http://" + _server +
                    "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?format=RSS", _sitename,
                    commentForum.Id);
            request.RequestPageWithFullURL(url, "", "");
        }

        /// <summary>
        /// Test GetCommentForumJSONWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumAtom()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            var returnedList =
                (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForumList));
            //get the first for test
            CommentForum commentForum = returnedList.CommentForums.First();
            // Setup the request url
            url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, "", "application/atom xml");
            url =
                String.Format(
                    "http://" + _server +
                    "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?format=ATOM", _sitename,
                    commentForum.Id);
            request.RequestPageWithFullURL(url, "", "");
        }

        /// <summary>
        /// Test GetCommentForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForum_NotFound()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, Guid.NewGuid());

            try
            {
                request.RequestPageWithFullURL(url, "", "text/xml");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.NotFound);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test GetCommentForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForum_NotFoundJSON()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url =
                String.Format(
                    "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    _sitename, Guid.NewGuid());

            try
            {
                request.RequestPageWithFullURL(url, "", "text/javascript");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.NotFound);
            }
            var error =
                (ErrorData) StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof (ErrorData));
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedForum.Id == id);

            Console.WriteLine("After GetCommentForumXML");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_MissingID()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_MissingTitle()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_MissingUri()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_TooManyUidChars()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "".PadRight(256, 'I');
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_InPostmod()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.PostMod;
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                                                   "</commentForum>", id, title, parentUri, moderationStatus);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            Console.WriteLine("After GetCommentForumXML");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_InPremod()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.PreMod;
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                                                   "</commentForum>", id, title, parentUri, moderationStatus);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            Console.WriteLine("After GetCommentForumXML");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_InReactive()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.Reactive;
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                                                   "</commentForum>", id, title, parentUri, moderationStatus);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            Console.WriteLine("After GetCommentForumXML");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_InInvalidModerationStatus()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                                                   "</commentForum>", id, title, parentUri, "notavlidstatus");

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
            }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);

            Console.WriteLine("After GetCommentForumXML");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_InvalidClosedDate()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            DateTime closeDate = DateTime.Now.AddDays(1);
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "<closeDate>{3}</closeDate>" +
                                                   "</commentForum>", id, title, parentUri, "notadate");

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
            }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);

            Console.WriteLine("After GetCommentForumXML");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_WithClosedDate()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            DateTime closeDate = DateTime.Now.AddDays(1);
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "<closeDate>{3}</closeDate>" +
                                                   "</commentForum>", id, title, parentUri,
                                                   closeDate.ToString("yyyy-MM-dd"));

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            var returnedForum =
                (CommentForum) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof (CommentForum));

            DateTime anticipatedClosedDate = DateTime.Parse(closeDate.AddDays(1).ToString("yyyy-MM-dd"));
            Assert.IsTrue(returnedForum.CloseDate == anticipatedClosedDate);

            Console.WriteLine("After GetCommentForumXML");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_Noneditor()
        {
            Console.WriteLine("Before CreateCommentForum");

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
// Check to make sure that the page returned with the correct information
            }
            //Should return 401 unauthorised
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);
            CheckErrorSchema(request.GetLastResponseAsXML());
            Console.WriteLine("After GetCommentForumXML");
        }

        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithEditorsPickFilter()
        {
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            //create the forum
            CommentForum commentForum = CommentForumCreateHelper();

            //Create 2 Comments in the same forum.
            var comments = new CommentsTests_V1();
            CommentInfo commentInfo = comments.CreateCommentHelper(commentForum.Id);
            CommentInfo commentInfo2 = comments.CreateCommentHelper(commentForum.Id);

            //Create Editors Pick on first comment
            var editorsPicks = new EditorsPicks_V1();
            editorsPicks.CreateEditorsPickHelper(_sitename, commentInfo.ID);


            // Filter forum on editors picks filter
            string url =
                String.Format(
                    "http://" + _server +
                    "/dna/api/comments/CommentsService.svc/V1/site/h2g2/commentsforums/{0}/?filterBy=EditorPicks",
                    commentForum.Id);

            //Check that picked comment is in results.
            request.RequestPageWithFullURL(url, "", "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            //Check XML.
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            var nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");

            // Check comment is included in picks.
            String xPath = String.Format("api:commentForum/api:commentsList/api:comments/api:comment[api:id='{0}']",
                                         commentInfo.ID);
            XmlNode pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNotNull(pick);

            //Check Comment that has not been picked is not present.
            xPath = String.Format("api:commentForum/api:commentsList/api:comments/api:comment[api:id='{0}']",
                                  commentInfo2.ID);
            pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNull(pick);
        }

        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithTimeFrameFilter()
        {
            SnapshotInitialisation.ForceRestore();//must be clean here...
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Filter forum on editors picks filter
            var url =
                String.Format(
                    "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/?filterBy={2}", _server, _sitename, FilterBy.PostsWithinTimePeriod);


            //create the forum
            var commentForum = CommentForumCreateHelper();

            //Create 1 Comments in the same forum.
            var comments = new CommentsTests_V1();
            var commentInfo = comments.CreateCommentHelper(commentForum.Id);

            //get the latest list
            request.RequestPageWithFullURL(url, "", "text/xml");
            var returnedObj = (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForumList));

            Assert.IsNotNull(returnedObj);
            Assert.AreEqual(FilterBy.PostsWithinTimePeriod, returnedObj.FilterBy);
            Assert.AreEqual(SortBy.PostCount, returnedObj.SortBy);
            Assert.AreEqual(1, returnedObj.TotalCount);

            url += "&timeperiod=0";
            request.RequestPageWithFullURL(url, "", "text/xml");
            returnedObj = (CommentForumList)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForumList));

            Assert.IsNotNull(returnedObj);
            Assert.AreEqual(FilterBy.PostsWithinTimePeriod, returnedObj.FilterBy);
            Assert.AreEqual(SortBy.PostCount, returnedObj.SortBy);
            Assert.AreEqual(0, returnedObj.TotalCount);

        }

        /// <summary>
        /// Test to make sure that we return the correct status code when trying to create a forum as a user that has not agreed terms and conditions
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_CreateForumAsNonAgreedTermsAndConditionsUser()
        {
            Console.WriteLine("Before CreateForumAsNonAgreedTermsAndConditionsUser");

            var request = new DnaTestURLRequest("identity606");

            string userName = "CommentForumCreateUser" + DateTime.Now.Ticks;
            string userEmail = userName + "@bbc.co.uk";
            Cookie cookie;
            Cookie secureCookie;
            string identityUserID;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(userName, "password", "1989-12-31", userEmail,
                                                             "Comment User", true,
                                                             TestUserCreator.IdentityPolicies.Adult, false, 0,
                                                             out cookie,
                                                             out secureCookie,
                                                             out identityUserID));
            request.UseIdentitySignIn = true;
            request.CurrentCookie = cookie.Value;
            request.CurrentSecureCookie = secureCookie.Value;

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       "identity606");

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
            }
            ;

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();

            var nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("bda", "BBC.Dna.Api");
            Assert.IsNotNull(xml.SelectSingleNode("//bda:error/bda:code", nsmgr), "Failed to find the error code");
            Assert.AreEqual("FailedTermsAndConditions", xml.SelectSingleNode("//bda:error/bda:code", nsmgr).InnerText);
            Assert.IsNotNull(xml.SelectSingleNode("//bda:error/bda:detail", nsmgr), "Failed to find the error deatils");
            Assert.AreEqual("http://identity/policies/dna/adult",
                            xml.SelectSingleNode("//bda:error/bda:detail", nsmgr).InnerText);

            Console.WriteLine("After CreateForumAsNonAgreedTermsAndConditionsUser");
        }

        /// <summary>
        /// Test to make sure that we return the correct status code when trying to create a comment as a user that has not agreed terms and conditions
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_CreateCommentAsNonAgreedTermsAndConditionsUser()
        {
            Console.WriteLine("Before CreateCommentAsNonAgreedTermsAndConditionsUser");

            var request = new DnaTestURLRequest("identity606");

            string userName = "CommentForumCreateUser" + DateTime.Now.Ticks;
            string userEmail = userName + "@bbc.co.uk";
            Assert.IsTrue(
                request.SetCurrentUserAsNewIdentityUser(userName, "password", "Comment User", userEmail, "1989-12-31",
                                                        TestUserCreator.IdentityPolicies.Adult, "identity606",
                                                        TestUserCreator.UserType.SuperUser),
                "Failed to create a test identity user");

            string id = "FunctiontestCommentForum-" + Guid.NewGuid(); //have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                                                   "<id>{0}</id>" +
                                                   "<title>{1}</title>" +
                                                   "<parentUri>{2}</parentUri>" +
                                                   "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/",
                                       "identity606");

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
            }
            ;

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);

            userName = "CommentCreateUser" + DateTime.Now.Ticks;
            userEmail = userName + "@bbc.co.uk";
            //Assert.IsTrue(request.SetCurrentUserAsNewIdentityUser(userName, "password", "Comment User", userEmail, "1989-12-31", TestUserCreator.IdentityPolicies.Adult, true, false, 1, false), "Failed to create a test identity user");

            Cookie cookie;
            Cookie secureCookie;
            string identityUserID;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(userName, "password", "1989-12-31", userEmail,
                                                             "Comment User", true,
                                                             TestUserCreator.IdentityPolicies.Adult, false, 0,
                                                             out cookie,
                                                             out secureCookie,
                                                             out identityUserID));
            request.UseIdentitySignIn = true;

            request.CurrentCookie = cookie.Value;
            request.CurrentSecureCookie = secureCookie.Value;

            string text = "Functiontest Title" + Guid.NewGuid();
            commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                                            "<text>{0}</text>" +
                                            "</comment>", text);

            // Setup the comment request url - needs to be secure
            url =
                String.Format(
                    "https://" + _secureServer + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/",
                    "identity606", id);

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {
            }
            ;

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();

            var nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("bda", "BBC.Dna.Api");
            Assert.IsNotNull(xml.SelectSingleNode("//bda:error/bda:code", nsmgr), "Failed to find the error code");
            Assert.AreEqual("FailedTermsAndConditions", xml.SelectSingleNode("//bda:error/bda:code", nsmgr).InnerText);
            Assert.IsNotNull(xml.SelectSingleNode("//bda:error/bda:detail", nsmgr), "Failed to find the error deatils");
            Assert.AreEqual("http://identity/policies/dna/adult",
                            xml.SelectSingleNode("//bda:error/bda:detail", nsmgr).InnerText);

            Console.WriteLine("After CreateCommentAsNonAgreedTermsAndConditionsUser");
        }


        [TestMethod]
        public void GetCommentForumWithCommentId_CreateAndDescending_ReturnsCorrectPost()
        {
            var sortBy = SortBy.Created;
            var sortDirection = SortDirection.Descending;
            var expectedStartIndex = 0;
            var itemsPerPage =1;

            //create the forum
            CommentForum commentForum = CommentForumCreateHelper();

            //Create 2 Comments in the same forum.
            var comments = new CommentsTests_V1();
            CommentInfo commentInfo = comments.CreateCommentHelper(commentForum.Id);
            CommentInfo commentInfo2 = comments.CreateCommentHelper(commentForum.Id);
            CommentInfo commentInfo3 = comments.CreateCommentHelper(commentForum.Id);

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?includepostid={2}&sortBy={3}&sortDirection={4}&itemsPerPage={5}",
                                       _sitename, commentForum.Id, commentInfo3.ID, sortBy, sortDirection, itemsPerPage);
            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();
            var returnedForum =
                (CommentForum)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));

            Assert.AreEqual(expectedStartIndex, returnedForum.commentList.StartIndex);
            Assert.AreEqual(itemsPerPage, returnedForum.commentList.ItemsPerPage);
            Assert.AreEqual(commentInfo3.ID, returnedForum.commentList.comments[0].ID);

            
        }

        [TestMethod]
        public void GetCommentForumWithCommentId_CreateAndAscending_ReturnsCorrectPost()
        {
            var sortBy = SortBy.Created;
            var sortDirection = SortDirection.Ascending;
            var expectedStartIndex = 2;
            var itemsPerPage = 1;

            //create the forum
            CommentForum commentForum = CommentForumCreateHelper();

            //Create 2 Comments in the same forum.
            var comments = new CommentsTests_V1();
            CommentInfo commentInfo = comments.CreateCommentHelper(commentForum.Id);
            CommentInfo commentInfo2 = comments.CreateCommentHelper(commentForum.Id);
            CommentInfo commentInfo3 = comments.CreateCommentHelper(commentForum.Id);

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?includepostid={2}&sortBy={3}&sortDirection={4}&itemsPerPage={5}",
                                       _sitename, commentForum.Id, commentInfo3.ID, sortBy, sortDirection, itemsPerPage);
            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();
            var returnedForum =
                (CommentForum)
                StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentForum));

            Assert.AreEqual(expectedStartIndex, returnedForum.commentList.StartIndex);
            Assert.AreEqual(itemsPerPage, returnedForum.commentList.ItemsPerPage);
            Assert.AreEqual(commentInfo3.ID, returnedForum.commentList.comments[0].ID);


        }

        [TestMethod]
        public void GetCommentForumWithCommentId_CommentIdDoesNotExist_ReturnsCorrectError()
        {
            var sortBy = SortBy.Created;
            var sortDirection = SortDirection.Ascending;
            var itemsPerPage = 1;

            //create the forum
            CommentForum commentForum = CommentForumCreateHelper();

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?includepostid={2}&sortBy={3}&sortDirection={4}&itemsPerPage={5}",
                                       _sitename, commentForum.Id, Int32.MaxValue-1, sortBy, sortDirection, itemsPerPage);
            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, "", "text/xml");
            }
            catch 
            {
            }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.NotFound);
            CheckErrorSchema(request.GetLastResponseAsXML());


        }

        [TestMethod]
        public void GetCommentForumWithCommentId_CommentIdNotValid_ReturnsCorrectError()
        {
            var sortBy = SortBy.Created;
            var sortDirection = SortDirection.Ascending;
            var itemsPerPage = 1;

            //create the forum
            CommentForum commentForum = CommentForumCreateHelper();

            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?includepostid={2}&sortBy={3}&sortDirection={4}&itemsPerPage={5}",
                                       _sitename, commentForum.Id, "notacomment", sortBy, sortDirection, itemsPerPage);
            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, "", "text/xml");
            }
            catch 
            {
            }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.NotFound);
            CheckErrorSchema(request.GetLastResponseAsXML());


        }

        /// <summary>
        /// Checks the xml against the error schema
        /// </summary>
        /// <param name="xml">Returned XML</param>
        public void CheckErrorSchema(XmlDocument xml)
        {
            var validator = new DnaXmlValidator(xml.InnerXml, _schemaError);
            validator.Validate();
        }
    }
}