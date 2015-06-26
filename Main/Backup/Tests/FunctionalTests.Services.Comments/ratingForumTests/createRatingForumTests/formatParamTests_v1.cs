using System;
using System.Net;
using System.Text.RegularExpressions;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of review forums via the Reviews API
    /// This set of tests check what happens with different request format parameter values
    /// The Post data is minimal and changes on each attempt
    /// Generally, the other data are such that the forum should be created - e.g. the user is an editor
    /// </summary>
    [TestClass]
    public class formatParamTests
    {

        /// <summary>
        /// All good, if miminal, send in XML and ask for XML response
        /// Succeeds, creates the forum, returns data as XML
        /// </summary>
        [TestMethod]
        public void inXMLoutXML()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutXML");

           // test variant data
            string mimeType = "text/xml";
            string formatParam = "XML";

            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // working data
            string id = "";
            string title = "";
            string parentUri = "";

            // make the post as XML data
            string postData = testUtils_ratingsAPI.makeCreatePostXml_minimal(ref id, ref title, ref parentUri);
            
            string url = testUtils_ratingsAPI.makeCreateForumUrl() + "?format=" + formatParam;

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            request.SetCurrentUserEditor();

            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                string resp = request.GetLastResponseAsString(); // usefull when debugging
                if (expectedResponseCode == HttpStatusCode.OK)
                    Assert.Fail("Fell over: " + resp); 
            }

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode, 
                "HTTP repsonse. Expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            validator.Validate();

            BBC.Dna.Api.RatingForum returnedForum = 
                (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum)
                );

            Assert.IsTrue(returnedForum.Id == id);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 0);

            Console.WriteLine("After formatParamTests - inXMLoutXML");
        } // ends inXMLoutXML

        /// <summary>
        /// All good, if miminal, send in XML and ask for JSON response
        /// </summary>
        [TestMethod]
        public void inXMLoutJSON()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutJSON");

            // test variant data
            string mimeType = "text/xml";
            string formatParam = "JSON";

            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // working data
            string id = "";
            string title = "";
            string parentUri = "";

            // make the post data as XML
            string postData = testUtils_ratingsAPI.makeCreatePostXml_minimal(ref id, ref title, ref parentUri);

            string url = testUtils_ratingsAPI.makeCreateForumUrl() + "?format=" + formatParam;

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            request.SetCurrentUserEditor();

            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                string resp = request.GetLastResponseAsString(); // usefull when debugging
                if (expectedResponseCode == HttpStatusCode.OK)
                    Assert.Fail("Fell over: " + resp);
            }

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode, 
                "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            BBC.Dna.Api.RatingForum returnedForum = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));

            Assert.IsTrue(returnedForum.Id == id);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 0);

            Console.WriteLine("After formatParamTests - inXMLoutJSON");
        } // ends inXMLoutJSON


        /// <summary>
        /// All good, if miminal, send in XML and ask for HTML response
        /// </summary>
        [TestMethod]
        public void inXMLoutHTML()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutHTML");

            // test variant data
            string mimeType = "text/xml";
            string formatParam = "HTML";

            HttpStatusCode expectedResponseCode = HttpStatusCode.NotImplemented;

            // working data
            string id = "";
            string title = "";
            string parentUri = "";

            // make the post data as XML
            string postData = testUtils_ratingsAPI.makeCreatePostXml_minimal(ref id, ref title, ref parentUri);

            string url = testUtils_ratingsAPI.makeCreateForumUrl() + "?format=" + formatParam;

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            request.SetCurrentUserEditor();

            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                string resp = request.GetLastResponseAsString(); // usefull when debugging
                if (expectedResponseCode == HttpStatusCode.OK)
                    Assert.Fail("Fell over: " + resp);
            }

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode, 
                "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            string theResponse = request.GetLastResponseAsString(); // store it before it goes away

            Console.WriteLine("After formatParamTests - inXMLoutHTML");
        } // ends inXMLoutHTML

        /// <summary>
        /// All good, if mininal, send in XML and don't specify the type fo the response, the default is XML.
        /// </summary>
        [TestMethod]
        public void inXMLoutBlank()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutBlank");

            // test variant data
            string mimeType = "text/xml";
            string formatParam = "";
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // working data
            string id = "";
            string title = "";
            string parentUri = "";

            // make the post data as XML
            string postData = testUtils_ratingsAPI.makeCreatePostXml_minimal(ref id, ref title, ref parentUri);

            string url = testUtils_ratingsAPI.makeCreateForumUrl() + "?format=" + formatParam;

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            request.SetCurrentUserEditor();

            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                string resp = request.GetLastResponseAsString(); // usefull when debugging
                if (expectedResponseCode == HttpStatusCode.OK)
                    Assert.Fail("Fell over: " + resp);
            }

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode);

            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            validator.Validate();

            BBC.Dna.Api.RatingForum returnedForum = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedForum.Id == id);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 0);

            Console.WriteLine("After formatParamTests - inXMLoutBlank");
        } // ends inXMLoutBlank


        /// <summary>
        /// All good, if miminal, send in XML and ask for unknown type of response.
        /// It should not succeed. 
        /// What it does do is return NotImplemented, returns no useful result, creates a forum
        /// </summary>
        [TestMethod]
        public void inXMLoutJunk()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutJunk");

            // test variant data
            string mimeType = "text/xml";
            string formatParam = "JUNK";

            HttpStatusCode expectedResponseCode = HttpStatusCode.NotImplemented;

            // working data
            string id = "";
            string title = "";
            string parentUri = "";

            // make the post data as XML
            string postData = testUtils_ratingsAPI.makeCreatePostXml_minimal(ref id, ref title, ref parentUri);

            string url = testUtils_ratingsAPI.makeCreateForumUrl() + "?format=" + formatParam;

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            request.SetCurrentUserEditor();

            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                string resp = request.GetLastResponseAsString(); // usefull when debugging
                if (expectedResponseCode == HttpStatusCode.OK)
                    Assert.Fail("Fell over: " + resp);
            }

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode, 
                "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            Console.WriteLine("After formatParamTests - inXMLoutJunk");
        } // ends inXMLoutJunk


        /// <summary>
        /// All good, if miminal, send in JSON and ask for XML response
        /// </summary>
        [TestMethod]
        public void inFormJSONoutXML()
        {
            Console.WriteLine("Before formatParamTests - inFormJSONoutXML");
            
            // test variant data
            string mimeType = "application/x-www-form-urlencoded";
            string formatParam = "XML";

            HttpStatusCode expectedResponseCode = HttpStatusCode.Created;

            // working data
            string id = "";
            string title = "";
            string parentUri = "";

            // make the post data as JSON
            string postData = testUtils_ratingsAPI.makeCreatePostJSON_minimal(ref id, ref title, ref parentUri);

            // note that the URL has an actual file at the end
            string url = testUtils_ratingsAPI.makeCreateForumUrl() + "create.htm?format=" + formatParam;

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            request.SetCurrentUserEditor();

            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                string resp = request.GetLastResponseAsString(); // usefull when debugging
                if (expectedResponseCode == HttpStatusCode.OK)
                    Assert.Fail("Fell over: " + resp);
            }

            string respStr = request.GetLastResponseAsString();

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode, "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode);
            // there is no useful data sent back, beyond the staus, that is
            // See the other form-post tests produced by Marcus

            Console.WriteLine("After formatParamTests - inFormJSONoutXML");
        } // ends inFormJSONoutXML

        /// <summary>
        /// All good, if miminal, send in JSON and ask for JSON response
        /// </summary>
        [TestMethod]
        public void inFormJSONoutJSON()
        {
            Console.WriteLine("Before formatParamTests - inFormJSONoutXML");

            // test variant data
            string mimeType = "application/x-www-form-urlencoded";
            string formatParam = "JSON";

            HttpStatusCode expectedResponseCode = HttpStatusCode.Created;

            // working data
            string id = "";
            string title = "";
            string parentUri = "";

            // make the post data as JSON
            string postData = testUtils_ratingsAPI.makeCreatePostJSON_minimal(ref id, ref title, ref parentUri);

            // note that the URL has an actual file at the end
            string url = testUtils_ratingsAPI.makeCreateForumUrl() + "create.htm?format=" + formatParam;

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            request.SetCurrentUserEditor();

            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                string resp = request.GetLastResponseAsString(); // usefull when debugging
                if (expectedResponseCode == HttpStatusCode.OK)
                    Assert.Fail("Fell over: " + resp);
            }

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode, 
                "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode);

            // there is no useful data sent back, beyond the staus, that is
            // See the other form-post tests produced by Marcus

            Console.WriteLine("After formatParamTests - inFormJSONoutXML");
        } // ends inFormJSONoutXML

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("completed formatParamTests");
        }

        /// <summary>
        /// Refresh the database (smallGuide)
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }
    
    } // ends class
} // ends namespace
