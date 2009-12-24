using System;
using System.Collections.Generic;
using System.Collections.Specialized;
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
    public class CommentForumTests_V1
    {
        private const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        private const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        private const string _schemaCommentsList = "Dna.Services\\commentsList.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
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

        public CommentForum CommentForumCreateHelper()
        {
            string nameSpace = "Tests";
            string id = Guid.NewGuid().ToString();
            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.Reactive;
            DateTime closingDate = DateTime.MinValue;
 
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
        /// Test GetAllCommentForumsAsXML method from service
        /// </summary>
        [TestMethod]
        public void GetAllCommentForumsAsXML()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/commentsforums/";

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
        }

        /// <summary>
        /// Test GetAllCommentForumsAsXML method from service
        /// </summary>
        [Ignore]
        public void GetAllCommentForumsAsXML_WithSorting_ByCreated()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/commentsforums/";

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();


            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
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
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
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
            sortDirection = SortDirection.Descending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);// should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());// should fail and return the default
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
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }


            //test sort by created case with defaults (created and ascending
            sortBy = "";
            sortDirection = "";
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }
        }


        /// <summary>
        /// Test GetAllCommentForumsAsJSON method from service
        /// </summary>
        [TestMethod]
        public void GetAllCommentForumsAsJSON()
        {
            Console.WriteLine("Before CommentForumTests_V1 - GetAllCommentForumsAsJSON");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/commentsforums/";

            // now get the response
            request.RequestPageWithFullURL(url, "", "application/json");

            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Console.WriteLine("After CommentForumTests_V1 - GetAllCommentForumsAsJSON");
        }

        /// <summary>
        /// Test GetAllCommentForumsAsJSON method from service
        /// </summary>
        [TestMethod]
        public void GetAllCommentForumsAsHTML()
        {
            Console.WriteLine("Before CommentForumTests_V1 - GetAllCommentForumsAsHTML");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = "http://" + _server + "/dna/api/comments/CommentsService.svc/V1/commentsforums/";

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/html");
            Assert.IsTrue(request.GetLastResponseAsString().IndexOf("<div") >= 0);
            
            Console.WriteLine("After CommentForumTests_V1 - GetAllCommentForumsAsHTML");
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Console.WriteLine("After GetCommentForumsBySitenameXML");
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithSorting_ByCreated()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
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
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
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
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);// should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());// should fail and return the default
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
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

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
        public void GetCommentForumsBySitenameAndPrefixXML_WithSorting_ByCreated()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");
            //create 3 forums with a prefix and one without
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-";//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id  = string.Empty;
            string url = string.Empty;
            string commentForumXml  = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            BBC.Dna.Api.CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id= prefix + Guid.NewGuid().ToString();
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

                returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
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

            returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == id);

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/?prefix={1}", _sitename, prefix);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList != null);
            Console.WriteLine("After GetCommentForumsBySitenameXML");

            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "&sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
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
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
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
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);// should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());// should fail and return the default
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
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

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
        public void GetCommentListBySitenameAndPrefixXML()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");
            //create 3 forums with a prefix and one without
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-";//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id = string.Empty;
            string url = string.Empty;
            string commentForumXml = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            BBC.Dna.Api.CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id = prefix + Guid.NewGuid().ToString();
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

                returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
                Assert.IsTrue(returnedForum.Id == id);

                //post comments to list
                for (int j = 0; j < 3; j++)
                {
                    string text = "Functiontest Title" + Guid.NewGuid().ToString();
                    string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                        "<text>{0}</text>" +
                        "</comment>", text);

                    // Setup the request url
                    url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, returnedForum.Id);
                    // now get the response
                    request.RequestPageWithFullURL(url, commentXml, "text/xml");
                    // Check to make sure that the page returned with the correct information
                    xml = request.GetLastResponseAsXML();
                    validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                    validator.Validate();

                    CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
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
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?prefix={1}", _sitename, prefix);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentsList);
            validator.Validate();

            BBC.Dna.Api.CommentsList returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
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
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-";//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id = string.Empty;
            string url = string.Empty;
            string commentForumXml = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            BBC.Dna.Api.CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id = prefix + Guid.NewGuid().ToString();
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

                returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
                Assert.IsTrue(returnedForum.Id == id);

                //post comments to list
                for (int j = 0; j < 3; j++)
                {
                    string text = "Functiontest Title" + Guid.NewGuid().ToString();
                    string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                        "<text>{0}</text>" +
                        "</comment>", text);

                    // Setup the request url
                    url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, returnedForum.Id);
                    // now get the response
                    request.RequestPageWithFullURL(url, commentXml, "text/xml");
                    // Check to make sure that the page returned with the correct information
                    xml = request.GetLastResponseAsXML();
                    validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                    validator.Validate();

                    CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
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
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?prefix={1}", _sitename, prefix);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentsList);
            validator.Validate();

            BBC.Dna.Api.CommentsList returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList != null);
            Console.WriteLine("After GetCommentForumsBySitenameXML");

            //////////////////////////////
            //set up sorting tests
            //////////////////////////////
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/", _sitename, returnedForum.Id);
            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
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
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
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
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);// should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());// should fail and return the default
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
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

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
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

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
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-";//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id = string.Empty;
            string url = string.Empty;
            string commentForumXml = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            BBC.Dna.Api.CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id = prefix + Guid.NewGuid().ToString();
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

                returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
                Assert.IsTrue(returnedForum.Id == id);

                //post comments to list
                for (int j = 0; j < 3; j++)
                {
                    string text = "Functiontest Title" + Guid.NewGuid().ToString();
                    string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                        "<text>{0}</text>" +
                        "</comment>", text);

                    // Setup the request url
                    url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, returnedForum.Id);
                    // now get the response
                    request.RequestPageWithFullURL(url, commentXml, "text/xml");
                    // Check to make sure that the page returned with the correct information
                    xml = request.GetLastResponseAsXML();
                    validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                    validator.Validate();

                    CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
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
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentsList);
            validator.Validate();

            BBC.Dna.Api.CommentsList returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
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
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string prefix = "prefixfunctionaltest-";//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string id = string.Empty;
            string url = string.Empty;
            string commentForumXml = string.Empty;
            XmlDocument xml = null;
            DnaXmlValidator validator = null;
            BBC.Dna.Api.CommentForum returnedForum = null;

            for (int i = 0; i < 3; i++)
            {
                id = prefix + Guid.NewGuid().ToString();
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

                returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
                Assert.IsTrue(returnedForum.Id == id);

                //post comments to list
                for (int j = 0; j < 3; j++)
                {
                    string text = "Functiontest Title" + Guid.NewGuid().ToString();
                    string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                        "<text>{0}</text>" +
                        "</comment>", text);

                    // Setup the request url
                    url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, returnedForum.Id);
                    // now get the response
                    request.RequestPageWithFullURL(url, commentXml, "text/xml");
                    // Check to make sure that the page returned with the correct information
                    xml = request.GetLastResponseAsXML();
                    validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
                    validator.Validate();

                    CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
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
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentsList);
            validator.Validate();

            BBC.Dna.Api.CommentsList returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList != null);
            Assert.IsTrue(returnedList.TotalCount != 0);

            //////////////////////////////
            //set up sorting tests
            //////////////////////////////
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/", _sitename, returnedForum.Id);
            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
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
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
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
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);// should fail and return the default
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());// should fail and return the default
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
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

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
            returnedList = (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
            Assert.IsTrue(returnedList.SortDirection.ToString() != sortDirection);
            Assert.IsTrue(returnedList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            Assert.IsTrue(returnedList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

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
            CommentsTests_V1 comment = new CommentsTests_V1();
            
            //create the forum
            CommentForum commentForum = CommentForumCreateHelper();
            CommentInfo commentInfo = comment.CreateCommentHelper(commentForum.Id);
            CommentInfo commentInfo2 = comment.CreateCommentHelper( commentForum.Id);

            //Create Editors Pick on first comment only.
            EditorsPicks_V1 editorsPicks = new EditorsPicks_V1();
            editorsPicks.CreateEditorsPickHelper(_sitename, commentInfo.ID);


            //Request Comments Filtered by Editors Picks.
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?filterBy=EditorPicks", _sitename);
            
            //Check that picked comment is in results.
            request.RequestPageWithFullURL(url, "", "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            //Check Schema
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");

            String xPath = String.Format("api:commentsList/api:comments/api:comment[api:id='{0}']", commentInfo.ID);
            XmlNode pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNotNull(pick);

            //Check Comment that has not been picked is not present.
            xPath = String.Format("api:commentsList/api:comments/api:comment[api:id='{0}']", commentInfo2.ID);
            pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNull(pick);
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithPaging()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            int forumCount = 0;
            while (returnedList.TotalCount > forumCount)
            {
                url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/?itemsPerPage=1&startIndex={1}", _sitename, forumCount);

                // now get the response
                request.RequestPageWithFullURL(url, "", "text/xml");

                // Check to make sure that the page returned with the correct information
                xml = request.GetLastResponseAsXML();
                validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
                validator.Validate();

                returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, "", "application/json");
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
             Console.WriteLine("After GetCommentForumsBySitenameJSON");
        }

        /// <summary>
        /// Test GetCommentForumsBySitenameXML method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumsBySitenameXML_InvalidSiteName()
        {
            Console.WriteLine("Before GetCommentForumsBySitenameXML");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", "NOTAVALIDSITE");

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList != null);
            Assert.IsTrue(returnedList.TotalCount == 0);
            Assert.IsTrue(returnedList.CommentForums != null);
            Console.WriteLine("After GetCommentForumsBySitenameXML");
        }

        /// <summary>
        /// Test GetCommentForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumXML()
        {
            

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url,"", "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            //get the first for test
            var commentForum = returnedList.CommentForums.First();

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            BBC.Dna.Api.CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            
        }

        /// <summary>
        /// Test GetCommentForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumXML_WithSorting_ByCreated()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</commentForum>", id, title, parentUri);

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
            //create 10 comments
            for (int i = 0; i < 3; i++)
            {
                string text = "Functiontest Title" + Guid.NewGuid().ToString();
                string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                    "<text>{0}</text>" +
                    "</comment>", text);

                // Setup the request url
                url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, returnedForum.Id);
                // now get the response
                request.RequestPageWithFullURL(url, commentXml, "text/xml");
            }
            //////////////////////////////
            //set up sorting tests
            //////////////////////////////
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, returnedForum.Id);
            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            BBC.Dna.Api.CommentForum returnedList = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
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
            returnedList = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
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
            returnedList = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() != sortDirection);// should fail and return the default
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() == SortDirection.Ascending.ToString());// should fail and return the default
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
            returnedList = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

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
            returnedList = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() != sortDirection);
            Assert.IsTrue(returnedList.commentList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.commentList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

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
            

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            //get the first for test
            var commentForum = returnedList.CommentForums.First();

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "application/json");

            BBC.Dna.Api.CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            
        }

        /// <summary>
        /// Test GetCommentForum
        /// </summary>
        [TestMethod]
        public void GetCommentForumHTML()
        {
            Console.WriteLine("Before GetCommentForumHTML");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            //get the first for test
            var commentForum = returnedList.CommentForums.First();

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);

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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            //get the first for test
            var commentForum = returnedList.CommentForums[0];

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/html");
            Assert.IsTrue(request.GetLastResponseAsString().IndexOf("<div") >= 0);

            commentForum = returnedList.CommentForums[1];
            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);

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
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            //get the first for test
            var commentForum = returnedList.CommentForums.First();
            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, "", "application/rss xml");
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?format=RSS", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, "", "");
        }

        /// <summary>
        /// Test GetCommentForumJSONWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForumAtom()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url);
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();
            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            //get the first for test
            var commentForum = returnedList.CommentForums.First();
            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, commentForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, "", "application/atom xml");
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/?format=ATOM", _sitename, commentForum.Id);
            request.RequestPageWithFullURL(url, "", "");
        }

        /// <summary>
        /// Test GetCommentForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetCommentForum_NotFound()
        {
            

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, Guid.NewGuid());

            try
            {
                request.RequestPageWithFullURL(url, "", "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
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


            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, Guid.NewGuid());

            try
            {
                request.RequestPageWithFullURL(url, "", "text/javascript");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.NotFound);
            }
            BBC.Dna.Api.ErrorData error = (BBC.Dna.Api.ErrorData)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.ErrorData));
            
        }
        
        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</commentForum>", id, title, parentUri);

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

            Console.WriteLine("After GetCommentForumXML");
        }

        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_MissingID()
        {
            Console.WriteLine("Before CreateCommentForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<parentUri>{2}</parentUri>" +

                "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +

                "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
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
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
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
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            BBC.Dna.Api.CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
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
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            BBC.Dna.Api.CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
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
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForum);
            validator.Validate();

            BBC.Dna.Api.CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                "</commentForum>", id, title, parentUri, "notavlidstatus");

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                
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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
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
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information

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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            DateTime closeDate = DateTime.Now.AddDays(1);
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "<closeDate>{3}</closeDate>" +
                "</commentForum>", id, title, parentUri, closeDate.ToString("yyyy-MM-dd"));

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

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information

            }
            //Should return 401 unauthorised
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);
            CheckErrorSchema(request.GetLastResponseAsXML());
            Console.WriteLine("After GetCommentForumXML");
        }

        [TestMethod]
        public void GetCommentForumsBySitenameXML_WithEditorsPickFilter()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            //create the forum
            CommentForum commentForum = CommentForumCreateHelper();

            //Create 2 Comments in the same forum.
            CommentsTests_V1 comments = new CommentsTests_V1();
            CommentInfo commentInfo = comments.CreateCommentHelper(commentForum.Id);
            CommentInfo commentInfo2 = comments.CreateCommentHelper(commentForum.Id);

            //Create Editors Pick on first comment
            EditorsPicks_V1 editorsPicks = new EditorsPicks_V1();
            editorsPicks.CreateEditorsPickHelper(_sitename, commentInfo.ID);


            // Filter forum on editors picks filter
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/h2g2/commentsforums/{0}/?filterBy=EditorPicks", commentForum.Id);
            
            //Check that picked comment is in results.
            request.RequestPageWithFullURL(url, "", "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            //Check XML.
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");

            // Check comment is included in picks.
            String xPath = String.Format("api:commentForum/api:commentsList/api:comments/api:comment[api:id='{0}']", commentInfo.ID);
            XmlNode pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNotNull(pick);

            //Check Comment that has not been picked is not present.
            xPath = String.Format("api:commentForum/api:commentsList/api:comments/api:comment[api:id='{0}']", commentInfo2.ID);
            pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNull(pick);

        }

        /// <summary>
        /// Test to make sure that we return the correct status code when trying to create a forum as a user that has not agreed terms and conditions
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_CreateForumAsNonAgreedTermsAndConditionsUser()
        {
            Console.WriteLine("Before CreateForumAsNonAgreedTermsAndConditionsUser");

            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            
            string userName = "CommentForumCreateUser" + DateTime.Now.Ticks.ToString();
            string userEmail = userName + "@bbc.co.uk";
            Cookie cookie;
            int userID;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(userName, "password", "1989-12-31", userEmail, "Comment User", true, TestUserCreator.IdentityPolicies.Adult, false, 0, out cookie, out userID));
            request.UseIdentitySignIn = true;
            request.CurrentSSO2Cookie = cookie.Value;

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", "identity606");

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { };

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("bda", "BBC.Dna.Api");
            Assert.IsNotNull(xml.SelectSingleNode("//bda:error/bda:code", nsmgr), "Failed to find the error code");
            Assert.AreEqual("FailedTermsAndConditions", xml.SelectSingleNode("//bda:error/bda:code", nsmgr).InnerText);
            Assert.IsNotNull(xml.SelectSingleNode("//bda:error/bda:detail", nsmgr), "Failed to find the error deatils");
            Assert.AreEqual("http://identity/policies/dna/adult", xml.SelectSingleNode("//bda:error/bda:detail", nsmgr).InnerText);

            Console.WriteLine("After CreateForumAsNonAgreedTermsAndConditionsUser");
        }

        /// <summary>
        /// Test to make sure that we return the correct status code when trying to create a comment as a user that has not agreed terms and conditions
        /// </summary>
        [TestMethod]
        public void CreateCommentForum_CreateCommentAsNonAgreedTermsAndConditionsUser()
        {
            Console.WriteLine("Before CreateCommentAsNonAgreedTermsAndConditionsUser");

            DnaTestURLRequest request = new DnaTestURLRequest("identity606");

            string userName = "CommentForumCreateUser" + DateTime.Now.Ticks.ToString();
            string userEmail = userName + "@bbc.co.uk";
            Assert.IsTrue(request.SetCurrentUserAsNewIdentityUser(userName, "password", "Comment User", userEmail, "1989-12-31", TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.SuperUser), "Failed to create a test identity user");

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</commentForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", "identity606");

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { };

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);

            userName = "CommentCreateUser" + DateTime.Now.Ticks.ToString();
            userEmail = userName + "@bbc.co.uk";
            //Assert.IsTrue(request.SetCurrentUserAsNewIdentityUser(userName, "password", "Comment User", userEmail, "1989-12-31", TestUserCreator.IdentityPolicies.Adult, true, false, 1, false), "Failed to create a test identity user");

            Cookie cookie;
            int userID; 
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(userName, "password", "1989-12-31", userEmail, "Comment User", true, TestUserCreator.IdentityPolicies.Adult, false, 0, out cookie, out userID));
            request.UseIdentitySignIn = true;
            request.CurrentSSO2Cookie = cookie.Value;

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", text);

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", "identity606", id);
            
            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            }
            catch { };

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("bda", "BBC.Dna.Api");
            Assert.IsNotNull(xml.SelectSingleNode("//bda:error/bda:code", nsmgr), "Failed to find the error code");
            Assert.AreEqual("FailedTermsAndConditions", xml.SelectSingleNode("//bda:error/bda:code", nsmgr).InnerText);
            Assert.IsNotNull(xml.SelectSingleNode("//bda:error/bda:detail", nsmgr), "Failed to find the error deatils");
            Assert.AreEqual("http://identity/policies/dna/adult", xml.SelectSingleNode("//bda:error/bda:detail", nsmgr).InnerText);

            Console.WriteLine("After CreateCommentAsNonAgreedTermsAndConditionsUser");
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
