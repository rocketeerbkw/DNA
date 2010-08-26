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
    /// Testing the creation of comments forums via the Comments API
    /// This set of tests check what happens with different request format parameter values
    /// The Post data is minimal and changes on each attempt
    /// Generally, the other data are such that the forum should be created - e.g. the user is an editor
    /// </summary>
    [TestClass]
    public class formatParam
    {

        /// <summary>
        /// All good, if miminal, send in XML and ask for XML response
        /// Succeeds, creates the forum, returns data as XML
        /// </summary>
        [TestMethod]
        public void inXMLoutXML()
        {
            Console.WriteLine("Before formatParam - inXMLoutXML");

           // test variant data
            string formatParam = "XML";
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            int newSiteCount = 0;
            DnaTestURLRequest request;
            XmlDocument xml;
            DnaXmlValidator validator;
            BBC.Dna.Api.CommentForum returnedForum;

            //go
            request = makeRequest(formatParam, filename, postXML, mimeType);

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode, 
                "HTTP repsonse. Expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);

            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));

            testUtils_CommentsAPI.runningForumCount = newSiteCount;

            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
            validator.Validate();

            returnedForum = 
                (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum)
                );

            Assert.IsTrue(returnedForum.Id == id);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0);


            Console.WriteLine("After formatParam - inXMLoutXML");
        } // ends inXMLoutXML

        /// <summary>
        /// All good, if miminal, send in XML and ask for JSON response
        /// </summary>
        [TestMethod]
        public void inXMLoutJSON()
        {
            Console.WriteLine("Before formatParam - inXMLoutJSON");

            // test variant data
            string formatParam = "JSON";
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            int newSiteCount = 0;
            DnaTestURLRequest request;
            BBC.Dna.Api.CommentForum returnedForum;

            //go
            request = makeRequest(formatParam, filename, postXML, mimeType);

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode, 
                "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);

            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));

            testUtils_CommentsAPI.runningForumCount = newSiteCount;


            returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));

            Assert.IsTrue(returnedForum.Id == id);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0);

            Console.WriteLine("After formatParam - inXMLoutJSON");
        } // ends inXMLoutJSON


        /// <summary>
        /// All good, if miminal, send in XML and ask for HTML response
        /// </summary>
        [TestMethod]
        public void inXMLoutHTML()
        {
            Console.WriteLine("Before formatParam - inXMLoutHTML");

            // test variant data
            string formatParam = "HTML";
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            int newSiteCount = 0;
            DnaTestURLRequest request;
            String response;

            request = makeRequest(formatParam, filename, postXML, mimeType);

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode, 
                "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);

            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));

            testUtils_CommentsAPI.runningForumCount = newSiteCount;

            response = request.GetLastResponseAsString(); // store it before it goes away

            //Assert.IsTrue(response.IndexOf("<h1>" + _title + "</h1>") > 0);
            Assert.IsTrue(response.IndexOf("0 comments") > 0);
            Assert.IsTrue(response.IndexOf("id=\"dna-commentforum\"") > 0);


            Console.WriteLine("After formatParam - inXMLoutHTML");
        } // ends inXMLoutHTML


        /// <summary>
        /// All good, if miminal, send in JSON and ask for XML response
        /// </summary>
        [TestMethod]
        // JSON looks good to me
        //{"id":"FunctiontestCommentForum-3dddfe8c-898a-4a8b-9275-c710a2082ee9","title":"Functiontest Title Tuesday2009September080937108824862","parentUri":"http://www.bbc.co.uk/dna/Tuesday2009September080937108824862/"}
        // but this is what it gives
        // <error xmlns="BBC.Dna.Api" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><code>InvalidForumUid</code><detail>Forum uid is empty, null or exceeds 255 characters.</detail><innerException></innerException></error>
        public void inJSONoutXML()
        {
            Console.WriteLine("Before formatParam - inFormJSONoutXML");
            
            // test variant data
            string formatParam = "XML";
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;
            string mimeType = "application/json";
            string filename = "";

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            //string mimeType = "text/xml";
            //string filename = "";
            string postData = testUtils_CommentsAPI.makePostJSON(ref id, ref title, ref parentUri);

            // working data
            int newSiteCount = 0;
            DnaTestURLRequest request;

            request = makeRequest(formatParam, filename, postData, mimeType);

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode, "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode);

            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);

            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));

            testUtils_CommentsAPI.runningForumCount = newSiteCount;
        } // ends inFormJSONoutXML

        /// <summary>
        /// All good, if miminal, send in XML and ask for Blank response - it is not clear if this should fail, or not.
        /// It does succeed, returning XML. This is arguable OK.
        /// </summary>
        [TestMethod]
        public void inXMLoutBlank()
        {
            Console.WriteLine("Before formatParam - inXMLoutBlank");

            // test variant data
            string formatParam = "";
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            int newSiteCount = 0;
            DnaTestURLRequest request;
            XmlDocument xml;
            DnaXmlValidator validator;
            BBC.Dna.Api.CommentForum returnedForum;

            request = makeRequest(formatParam, filename, postXML, mimeType);

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode);

            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode, "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode);

            testUtils_CommentsAPI.runningForumCount = newSiteCount;

            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
            validator.Validate();

            returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == id);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0);

            Console.WriteLine("After formatParam - inXMLoutBlank");
        } // ends inXMLoutBlank


        /// <summary>
        /// All good, if miminal, send in XML and ask for Blank response - it is not clear if this should fail, or not.
        /// It should not succeed. 
        /// What it does do is return NotImplemented, returns no useful result, creates a forum
        /// </summary>
        [TestMethod]
        public void inXMLoutJunk()
        {
            Console.WriteLine("Before formatParam - inXMLoutJunk");

            // test variant data
            string formatParam = "JUNK";
            HttpStatusCode expectedResponseCode = HttpStatusCode.NotImplemented;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            int newSiteCount = 0;
            DnaTestURLRequest request;

            request = makeRequest(formatParam, filename, postXML, mimeType);

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode, "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode);

            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);

            Assert.IsTrue(newSiteCount == testUtils_CommentsAPI.runningForumCount);

            Console.WriteLine("After formatParam - inXMLoutJunk");
        } // ends inXMLoutJunk


        //-------------------------------------------------------------------------------------------------
        // force some errors and check the format of the data that we get back
        /// <summary>
        /// force 400-BadRequest-InvalidForumParentUri-Forum parent uri is empty, null or not from a bbc.co.uk domain
        /// just see that it is XML and the right XML
        /// </summary>
        [TestMethod]
        public void inXMLoutXML400()
        {
            Console.WriteLine("Before formatParam - inXMLoutXML400");

            // test variant data
            string formatParam = "xml";
            HttpStatusCode expectedResponseCode = HttpStatusCode.BadRequest;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "yabber.dabber.dooooo";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            //int newSiteCount = 0;
            DnaTestURLRequest request;

            request = makeRequest(formatParam, filename, postXML, mimeType);

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode, "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode);

            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaError);
            validator.Validate();

            string resStr = request.GetLastResponseAsString();

            Assert.IsTrue(Regex.Match(resStr, "InvalidForumParentUri").Success == true);

            Console.WriteLine("After formatParam - inXMLoutXML400");
        } // ends inXMLoutJunk

        /// <summary>
        /// Do the same thing, but ask for a JSON output
        /// </summary>
        // currently it returns XML
        [TestMethod]
        public void inXMLoutJSON400()
        {
            Console.WriteLine("Before formatParam - inXMLoutJSON");

            // test variant data
            string formatParam = "JSON";
            HttpStatusCode expectedResponseCode = HttpStatusCode.BadRequest;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "yabber.dabber.dooooo";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            //int newSiteCount = 0;
            DnaTestURLRequest request;
            //BBC.Dna.Api.CommentForum returnedForum;

            //go
            request = makeRequest(formatParam, filename, postXML, mimeType);

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode,
                "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            string respStr = request.GetLastResponseAsString();

            //This test could do with improving - it does not really prove that you're getting valid JSON back, 
            // but there does not appear to be an appropriate object to try to deserialise into
            Assert.IsTrue(Regex.Match(respStr, "\"code\":\"InvalidForumParentUri\"", RegexOptions.IgnoreCase).Success == true, "The JSON output does not look right (" + respStr + ")");

            Console.WriteLine("After formatParam - inXMLoutJSON400");
        }


        /// <summary>
        /// force 404-not found
        /// just see that it is XML and the right XML
        /// </summary>
        /// currently thows a 500 and does not have nice stuff in the response string
        [TestMethod]
        public void inXMLoutXML404()
        {
            Console.WriteLine("Before formatParam - inXMLoutXML404");

            // test variant data
            string formatParam = "xml";
            HttpStatusCode expectedResponseCode = HttpStatusCode.NotFound;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            string siteSafe = testUtils_CommentsAPI.sitename;

            testUtils_CommentsAPI.sitename = "weeblweeble"; // this should cause it to build a URL that points to nowhere
            // working data
            DnaTestURLRequest request;

            request = makeRequest(formatParam, filename, postXML, mimeType);

            testUtils_CommentsAPI.sitename = siteSafe; // put it right immediately after

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == expectedResponseCode, "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode);

            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaError);
            validator.Validate();

            string resStr = request.GetLastResponseAsString();

            Assert.IsTrue(Regex.Match(resStr, "UnknownSite").Success == true);

            Console.WriteLine("After formatParam - inXMLoutXML404");
        } // ends inXMLoutJunk

        /// <summary>
        /// Do the same thing, but ask for a JSON output
        /// </summary>
        // currently it throws 500
        [TestMethod]
        public void inXMLoutJSON404()
        {
            Console.WriteLine("Before formatParam - inXMLoutJSON");

            // test variant data
            string formatParam = "JSON";
            HttpStatusCode expectedResponseCode = HttpStatusCode.NotFound;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string mimeType = "text/xml";
            string filename = "";
            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            string siteSafe = testUtils_CommentsAPI.sitename;

            testUtils_CommentsAPI.sitename = "weeblweeble"; // this should cause it to build a URL that points to nowhere

            // working data
            DnaTestURLRequest request;

            //go
            request = makeRequest(formatParam, filename, postXML, mimeType);

            testUtils_CommentsAPI.sitename = siteSafe; // put it right immediately after

            Assert.IsTrue(
                request.CurrentWebResponse.StatusCode == expectedResponseCode,
                "HTTP repsonse expected:" + expectedResponseCode + " actually got " + request.CurrentWebResponse.StatusCode
                );

            string respStr = request.GetLastResponseAsString();

            //This test could do with improving - it does not really prove that you're getting valid JSON back, 
            // but there does not appear to be an appropriate object to try to deserialise into
            Assert.IsTrue(Regex.Match(respStr, "\"code\":\"UnknownSite\"", RegexOptions.IgnoreCase).Success == true, "The JSON output does not look right (" + respStr + ")");

            Console.WriteLine("After formatParam - inXMLoutJSON400");
        }

        // =============================================================================================
        /// <summary>
        /// Does all  the work
        /// </summary>
        private DnaTestURLRequest makeRequest(string formatParam, String file, String postData, String mimeType)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserEditor();

            String url = "http://" + testUtils_CommentsAPI.server + "/dna/api/comments/CommentsService.svc/v1/site/" + testUtils_CommentsAPI.sitename + "/" + file + "?format=" + formatParam;

            // now get the response - minimal POST data, no clue about the input mime-type , user is not allowed, however
            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                string respStr = request.GetLastResponseAsString();
            }

            return request;
        } // ends makeRequest


        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("completed formatParam");
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
