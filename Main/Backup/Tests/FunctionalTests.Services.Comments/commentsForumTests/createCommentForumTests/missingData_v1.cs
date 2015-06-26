using System;
using System.Net;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of comments forums via the Comments API
    /// </summary>
    [TestClass]
    public class CommentsMissingData
    {

        // ===================================================================================================
        // Test by building up the information that is sent into the request, from nothing. 
        // As more is added, ring the changes to see what causes failures
        // Start by using the editor user to ensure that that is not the sticking point
        // ===================================================================================================

        /// <summary>
        /// No Input (neither site in URL, GET, POST, nor HTTP request_type header data) gives a 404 error
        /// </summary>
        [TestMethod]
        public void NoData()
        {
            Console.WriteLine("Before missingData - NoData");

            // test variant data
            string postData = "";
            string mimeType = "";
            string url = "http://" + testUtils_CommentsAPI.server + "/dna/api/comments/CommentsService.svc/v1/site/";
            //HttpStatusCode expectedHttpResponse = HttpStatusCode.OK;

            // consistent input data

            // working data
            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserEditor();

            // now get the response - no POST data, nor any clue about the type
            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {// Check to make sure that the page returned with the correct information
                Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.NotFound);
            }
            Console.WriteLine("After missingData - NoData");
        } // ends NoData

        /// <summary>
        /// Have found that missing the trailing slash can sometimes cause an un-catered-for exception, try it here
        /// Without the mising slash, the URL is not pointing to anything useful, so not found should be returned.
        /// </summary>
        [TestMethod]
        public void missTrailingSlash()
        {
            Console.WriteLine("Before missingData - missTrailingSlash");

            // working data
            string id = "";
            string title = "";
            string parentUri = "";
            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            // fixed input data

            // test variant data
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);
            string mimeType = "text/xml";
            string url = "http://" + testUtils_CommentsAPI.server + "/dna/api/comments/CommentsService.svc/v1/site/";
            HttpStatusCode expectedHttpResponse = HttpStatusCode.NotFound;

            request.SetCurrentUserEditor();

            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {// Check to make sure that the page returned with the correct information
            }

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedHttpResponse,
                "Expected "+expectedHttpResponse+", got " + request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After missingData - missTrailingSlash");
        } // ends missTrailingSlash

        /// <summary>
        /// With only the site name in URL  (neither GET, POST, nor HTTP request_type header) - Just give a list - replicates another test, but what the hell
        /// </summary>
        [TestMethod]
        public void SiteOnly()
        {
            Console.WriteLine("Before missingData - SiteOnly");

            // test variant data
            string postData = "";
            string mimeType = "";
            string url = "http://" + testUtils_CommentsAPI.server + "/dna/api/comments/CommentsService.svc/v1/site/" + testUtils_CommentsAPI.sitename + "/";
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data

            // working data
            XmlDocument xml;
            DnaXmlValidator validator;
            BBC.Dna.Api.CommentForumList returnedList;
            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserEditor();

            // now get the response - no POST data, nor any clue about the input mime-type
            // This should give us a list of forums in this site
            request.RequestPageWithFullURL(url, postData, mimeType);

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode,
                "HTTP repsonse. Expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            // as there was no indication of the request mime-type, the default of XML should have come back
            // and we should have a list of forums for this site - as it is H2G2, we know that it will already be a few.
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForumList);
            validator.Validate();

            // try to see if we can convert what came back into an Object
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList != null);

            Console.WriteLine("After missingData - SiteOnly");
        } // ends SiteOnly

        /// <summary>
        /// With site name in URL & correct minimal POST data & no request mime-type
        /// </summary>
        [TestMethod]
        public void MinimalPostData_noMimeType()
        {
            Console.WriteLine("Before missingData - MinimalPostData_noMimeType");

            // test variant data
            string postData = "";
            string mimeType = "";
            string url = "http://" + testUtils_CommentsAPI.server + "/dna/api/comments/CommentsService.svc/v1/site/" + testUtils_CommentsAPI.sitename + "/";
            HttpStatusCode expectedResponseCode = HttpStatusCode.UnsupportedMediaType;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";

            // working data
            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserEditor();

            postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);
            
            // now get the response - minimal POST data, no clue about the input mime-type , user is OK
            try{
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch{
                // We should have an exception, make it continue without raising it further.
            }

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode,
                "HTTP repsonse. Expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            Console.WriteLine("After missingData - MinimalPostData_noMimeType");
        } // ends MinimalPostData_noMimeType

  
        //============================================================

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("completed missingData");
        }

        /// <summary>
        /// Refresh the database (smallGuide)
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();

            testUtils_CommentsAPI.runningForumCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);
        }
    
    } // ends class
} // ends namespace
