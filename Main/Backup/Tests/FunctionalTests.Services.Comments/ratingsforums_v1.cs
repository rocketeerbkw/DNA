using System;
using System.Collections.Generic;
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
using BBC.Dna.Common;

namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class ReviewForumTests_V1
    {
        private const string _schemaRatingForum = "Dna.Services\\ratingForum.xsd";
        private const string _schemaRating = "Dna.Services\\rating.xsd";
        private const string _schemaError = "Dna.Services\\error.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _secureserver = DnaTestURLRequest.SecureServerAddress;
        private string _sitename = "h2g2";

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After ReviewForumTests");
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
        /// Test GetReviewForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetReviewForumXML()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Empty;
            BBC.Dna.Api.RatingForum ratingForum = CreateRatingForum();

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);
           

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            BBC.Dna.Api.RatingForum returnedForum = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            
        }

        /// <summary>
        /// Test GetReviewForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetReviewForumXML_WithSorting_ByCreated()
        {
            BBC.Dna.Api.RatingForum returnedForum = CreateRatingForum();
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            string url = String.Empty;
            request.SetCurrentUserEditor();
            //create 10 comments
            for (int i = 0; i < 3; i++)
            {
                string text = "Functiontest Title" + Guid.NewGuid().ToString();
                string commentXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                    "<text>{0}</text>" +
                    "<rating>{1}</rating>" +
                    "</comment>", text, 5);

                // Setup the request url
                url = String.Format("https://" + _secureserver + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, returnedForum.Id);
                
                //change the user for a review...
                switch(i)
                {
                    case 1: request.SetCurrentUserModerator(); break;
                    case 2: request.SetCurrentUserNormal(); break;
                }

                // now get the response
                request.RequestPageWithFullURL(url, commentXml, "text/xml");
            }
            //////////////////////////////
            //set up sorting tests
            //////////////////////////////
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, returnedForum.Id);
            string sortBy = SortBy.Created.ToString();
            string sortDirection = SortDirection.Ascending.ToString();
            string sortUrl = url + "?sortBy={0}&sortDirection={1}";

            //test ascending created
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            BBC.Dna.Api.RatingForum returnedList = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedList.ratingsList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.ratingsList.SortBy.ToString() == sortBy);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < returnedList.ratingsList.ratings.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.ratingsList.ratings[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedList.ratingsList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.ratingsList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.ratingsList.ratings.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.ratingsList.ratings[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }

            //test descending created case insensitive
            sortBy = SortBy.Created.ToString();
            sortDirection = SortDirection.Descending.ToString().ToLower();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedList.ratingsList.SortDirection.ToString() != sortDirection);// should fail and return the default
            Assert.IsTrue(returnedList.ratingsList.SortDirection.ToString() == SortDirection.Ascending.ToString());// should fail and return the default
            Assert.IsTrue(returnedList.ratingsList.SortBy.ToString() == sortBy);

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.ratingsList.ratings.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.ratingsList.ratings[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //test sort by created case insensitive
            sortBy = SortBy.Created.ToString().ToLower();
            sortDirection = SortDirection.Descending.ToString();
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedList.ratingsList.SortDirection.ToString() == sortDirection);
            Assert.IsTrue(returnedList.ratingsList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.ratingsList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < returnedList.ratingsList.ratings.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.ratingsList.ratings[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }


            //test sort by created case with defaults (created and ascending
            sortBy = "";
            sortDirection = "";
            request.RequestPageWithFullURL(String.Format(sortUrl, sortBy, sortDirection), "", "text/xml");
            returnedList = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedList.ratingsList.SortDirection.ToString() != sortDirection);
            Assert.IsTrue(returnedList.ratingsList.SortDirection.ToString() == SortDirection.Ascending.ToString());
            Assert.IsTrue(returnedList.ratingsList.SortBy.ToString() != sortBy);// should fail and return the default which is Created
            Assert.IsTrue(returnedList.ratingsList.SortBy.ToString() == SortBy.Created.ToString());// should fail and return the default which is Created

            prevCreate = DateTime.MinValue;
            for (int i = 0; i < returnedList.ratingsList.ratings.Count; i++)
            {
                currentDate = DateTime.Parse(returnedList.ratingsList.ratings[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

        }

        /// <summary>
        /// Test GetReviewForumXML_WithUserList method from service
        /// </summary>
        [Ignore]//ignored because method is no longer supported
        public void GetReviewForumXML_WithUserList()
        {
            BBC.Dna.Api.RatingForum returnedForum = RatingForumIdentityUserCreate("tests", Guid.NewGuid().ToString() ,ModerationStatus.ForumStatus.Reactive, DateTime.MinValue);
            string url = String.Empty;
            string identitySiteName = "identity606";

            DnaTestURLRequest request = new DnaTestURLRequest(identitySiteName);

            PostToRatingForumAsIdentityUser(returnedForum, request, identitySiteName);
            string newIdentityUserID1 = request.CurrentIdentityUserID;
            PostToRatingForumAsIdentityUser(returnedForum, request, identitySiteName);
            string newIdentityUserID2 = request.CurrentIdentityUserID;
            PostToRatingForumAsIdentityUser(returnedForum, request, identitySiteName);
            string newIdentityUserID3 = request.CurrentIdentityUserID;


            //////////////////////////////
            //Call ReviewForums with filter by UserList
            //////////////////////////////
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", identitySiteName, returnedForum.Id);
            string filterBy = FilterBy.UserList.ToString();
            string userList = newIdentityUserID1 + "," + newIdentityUserID2;
            string filterUrl = url + "?filterBy={0}&userList={1}";

            request.RequestPageWithFullURL(String.Format(filterUrl, filterBy, userList), "", "text/xml");
            BBC.Dna.Api.RatingForum returnedList = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedList.ratingsList.FilterBy.ToString() == filterBy);
            Assert.IsTrue(returnedList.ratingsList.TotalCount == 2);
            Assert.IsTrue(returnedList.ratingsSummary.Total == 2);
            Assert.IsTrue(returnedList.ratingsSummary.Average == (returnedList.ratingsList.ratings[0].rating + returnedList.ratingsList.ratings[1].rating)/2);

            //test when no user list passed
            userList = string.Empty;
            try
            {
                request.RequestPageWithFullURL(String.Format(filterUrl, filterBy, userList), "", "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }

            //test when a bad user list passed
            userList = TestUserAccounts.GetNormalUserAccount.UserID + "," + TestUserAccounts.GetEditorUserAccount.UserID + ",a";
            try
            {
                request.RequestPageWithFullURL(String.Format(filterUrl, filterBy, userList), "", "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }     
        }

        private void PostToRatingForumAsIdentityUser(RatingForum ratingForum, DnaTestURLRequest request, string sitename)
        {
            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", sitename, ratingForum.Id);

            string userName = "RatingForumIdentityUserCreate" + DateTime.Now.Ticks.ToString();
            string userEmail = userName + "@bbc.co.uk";
            Assert.IsTrue(request.SetCurrentUserAsNewIdentityUser(userName, "password", "RatingForumCommenter", userEmail, "1989-12-31", TestUserCreator.IdentityPolicies.Adult, 1, TestUserCreator.UserType.IdentityOnly), "Failed to create a test identity user");

            // now get the response
            request.RequestPageWithFullURL(url, ratingXml, "text/xml");
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

            Assert.IsTrue(request.SetCurrentUserAsNewIdentityUser(userName, "password", "RatingForum User", userEmail, "1989-12-31", TestUserCreator.IdentityPolicies.Adult, 1, TestUserCreator.UserType.SuperUser), "Failed to create a test identity user");
            //Assert.IsTrue(request.SetCurrentUserAsNewIdentityUser(userName, "password", "RatingForum User", userEmail, "1989-12-31", TestUserCreator.IdentityPolicies.Adult, true, true), "Failed to create a test identity user");
            //using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            //{
            //    string sql = "EXEC dbo.createnewuserfromidentityid " + request.CurrentIdentityUserID + ",0,'" + userName + "','" + userEmail + "',74";
            //    reader.ExecuteDEBUGONLY(sql);
            //    if (reader.Read())
            //    {
            //        int dnauserid = reader.GetInt32NullAsZero("userid");
            //        sql = "UPDATE dbo.Users SET Status = 2 WHERE UserID = " + dnauserid.ToString();
            //        reader.ExecuteDEBUGONLY(sql);
            //    }
            //}

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
        /// Creates a review forum and returns it
        /// </summary>
        /// <returns>The create review forum</returns>
        private BBC.Dna.Api.RatingForum CreateRatingForum()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestReviewForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</ratingForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            return  (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
        }

        /// <summary>
        /// Test GetReviewForumJSONWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetReviewForumJSON()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Empty;
            BBC.Dna.Api.RatingForum ratingForum = CreateRatingForum();

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);

            // now get the response
            request.RequestPageWithFullURL(url, "", "application/json");

            BBC.Dna.Api.RatingForum returnedForum = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            
        }

        /// <summary>
        /// Test GetReviewForum
        /// </summary>
        [TestMethod]
        public void GetReviewForumHTML()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Empty;
            BBC.Dna.Api.RatingForum ratingForum = CreateRatingForum();

            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);

            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, "", "text/html");
            }
            catch { }
            Assert.AreEqual(HttpStatusCode.NotImplemented, request.CurrentWebResponse.StatusCode);
            Console.WriteLine("After GetReviewForumHTML");
        }

        /// <summary>
        /// Test GetReviewForumJSONWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetReviewForumRSS()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Empty;
            BBC.Dna.Api.RatingForum ratingForum = CreateRatingForum();
            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, "", "application/rss xml");
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/?format=RSS", _sitename, ratingForum.Id);
            request.RequestPageWithFullURL(url, "", "");
        }

        /// <summary>
        /// Test GetReviewForumJSONWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetReviewForumAtom()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Empty;
            BBC.Dna.Api.RatingForum ratingForum = CreateRatingForum();
            // Setup the request url
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, ratingForum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, "", "application/atom xml");
            url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/?format=ATOM", _sitename, ratingForum.Id);
            request.RequestPageWithFullURL(url, "", "");
        }

        /// <summary>
        /// Test GetReviewForumXMLWithoutNamespace method from service
        /// </summary>
        [TestMethod]
        public void GetReviewForum_NotFound()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", _sitename, Guid.NewGuid());

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
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</ratingForum>", id, title, parentUri);

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

            Console.WriteLine("After GetReviewForumXML");
        }
        
        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_MissingID()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "</ratingForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_MissingTitle()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<parentUri>{2}</parentUri>" +

                "</ratingForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_MissingUri()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +

                "</ratingForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_TooManyUidChars()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "".PadRight(256, 'I');
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "</ratingForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            }
            CheckErrorSchema(request.GetLastResponseAsXML());
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_InPostmod()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.PostMod;
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                "</ratingForum>", id, title, parentUri, moderationStatus);

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
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            Console.WriteLine("After GetReviewForumXML");
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_InPremod()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.PreMod;
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                "</ratingForum>", id, title, parentUri, moderationStatus);

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
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            Console.WriteLine("After GetReviewForumXML");
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_InReactive()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.Reactive;
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                "</ratingForum>", id, title, parentUri, moderationStatus);

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
            Assert.IsTrue(returnedForum.ModerationServiceGroup == moderationStatus);
            Console.WriteLine("After GetReviewForumXML");
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_InInvalidModerationStatus()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                "</ratingForum>", id, title, parentUri, "notavlidstatus");

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information
                
            }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);
            
            Console.WriteLine("After GetReviewForumXML");
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_InvalidClosedDate()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            DateTime closeDate = DateTime.Now.AddDays(1);
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "<closeDate>{3}</closeDate>" +
                "</ratingForum>", id, title, parentUri, "notadate");

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information

            }
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest);

            Console.WriteLine("After GetReviewForumXML");
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_WithClosedDate()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            //request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";

            DateTime closeDate = DateTime.Now.AddDays(1);
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +

                "<closeDate>{3}</closeDate>" +
                "</ratingForum>", id, title, parentUri, closeDate.ToString("yyyy-MM-dd"));

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

            DateTime anticipatedClosedDate = DateTime.Parse(closeDate.AddDays(1).ToString("yyyy-MM-dd"));
            Assert.IsTrue(returnedForum.CloseDate == anticipatedClosedDate);

            Console.WriteLine("After GetReviewForumXML");
        }

        /// <summary>
        /// Test CreateReviewForum method from service
        /// </summary>
        [TestMethod]
        public void CreateReviewForum_Noneditor()
        {
            Console.WriteLine("Before CreateReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString();//have to randomize the string to post
            string title = "Functiontest Title";
            string parentUri = "http://www.bbc.co.uk/dna/h2g2/";
            string ratingForumXml = String.Format("<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</ratingForum>", id, title, parentUri);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/", _sitename);
            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            }
            catch
            {// Check to make sure that the page returned with the correct information

            }
            //Should return 401 unauthorised
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized);
            CheckErrorSchema(request.GetLastResponseAsXML());
            Console.WriteLine("After GetReviewForumXML");
        }

        /// <summary>
        /// Create 2 comments.
        /// Pick first comment and filter by editors picks.
        /// Check that first comment only is included.
        /// </summary>
        [Ignore]
        public void GetReviewForumWithEditorsPickFilter()
        {
            //Create 2 Comments
            CommentsTests_V1 comments = new CommentsTests_V1();
            CommentForumTests_V1 commentForums = new CommentForumTests_V1();
            CommentInfo commentInfo = comments.CreateCommentHelper(commentForums.CommentForumCreateHelper().Id);
            CommentInfo commentInfo2 = comments.CreateCommentHelper(commentForums.CommentForumCreateHelper().Id);

            //Create Editors Pick on 1st comment only.
            EditorsPicks_V1 editorsPicks = new EditorsPicks_V1();
            editorsPicks.CreateEditorsPickHelper(_sitename, commentInfo.ID);


            //Request Comments Filtered by Editors Picks.
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = commentInfo.ForumUri + "?filterBy=EditorsPick";
            
            //Check that picked comment is in results.
            request.RequestPageWithFullURL(url, "", "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
            nsmgr.AddNamespace("api", "BBC.Dna.Api");

            String xPath = String.Format("api:ratingForum/api:commentsList/api:comments/api:comment[api:id='{0}']", commentInfo.ID);
            XmlNode pick = xml.SelectSingleNode(xPath, nsmgr);
            Assert.IsNotNull(pick);

            //Check Comment that has not been picked is not present.
            xPath = String.Format("api:ratingForum/api:commentsList/api:comments/api:comment[api:id='{0}']", commentInfo2.ID);
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
    }
}
