using System;
using System.Net;
using System.Web;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;




namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of comments forums via the Comments API
    /// This set of tests checks what happens with different request MIME types
    /// The Post data is minimal as XML, of JSON, depending on the MIME type declared
    /// The data is the mimimum necessary to create a new forum
    /// </summary>
    [TestClass]
    public class mimeTypes
    {        
        /// <summary>
        /// XML POST data, No request mime-type, expect it to reject the request
        /// </summary>
        [TestMethod]
        public void noMimeType()
        {
            Console.WriteLine("Before mimeTypes - noMimeType");

            // test variant data
            string mimeType = ""; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.UnsupportedMediaType;

            // consistent data
            string id = "";
            string title = "";
            string parentUri = "";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);
            DnaTestURLRequest request;

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            Console.WriteLine("After mimeTypes - noMimeType");
        } // ends noMimeType

        /// <summary>
        /// XML POST data, bad MIME type - expect it to reject this as not yet implemented
        /// </summary>
        [TestMethod]
        // instead of giving NotYetImplemented, this gives 500 - at least is should indicate a client error?
        public void badMimeType()
        {
            Console.WriteLine("Before mimeTypes - badMimeType");

            // test variant data
            string mimeType = "tixt/xml"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.InternalServerError;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest request;

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            Console.WriteLine("After mimeTypes - badMimeType");
        } // ends badMimeType

        /// <summary>
        /// XML POST data, MIME type of text/html - expect success + an HTML response
        /// </summary>
        [TestMethod]
        public void inXmlMimeTypeHTML()
        {
            Console.WriteLine("Before mimeTypes - inXmlMimeTypeHTML");

            // test variant data
            string mimeType = "text/html"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.NotImplemented;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);
            
            // working data
            DnaTestURLRequest request;
            int newSiteCount = 0;
            string respStr = "";

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            // check that one was actually created
            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);
            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));
            testUtils_CommentsAPI.runningForumCount = newSiteCount;

            Console.WriteLine("After mimeTypes - inXmlMimeTypeHTML");
        } // ends inXmlMimeTypeHTML

        /// <summary>
        /// XML POST data, MIME type of text/xml - expect success + XML response
        /// </summary>
        [TestMethod]
        public void inXmlMimeTypeTextXML()
        {
            Console.WriteLine("Before mimeTypes - inXmlMimeTypeTextXML");

            // test variant data
            string mimeType = "text/xml"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest request;
            int newSiteCount = 0;
            string respStr = "";

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            // check that one was actually created
            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);
            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));
            testUtils_CommentsAPI.runningForumCount = newSiteCount;

            // check schema of what came back
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
            validator.Validate();

            // check content of what came back
            respStr = request.GetLastResponseAsString();
            BBC.Dna.Api.CommentForum returnedForum = 
                (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(respStr, typeof(BBC.Dna.Api.CommentForum));

            Assert.IsTrue(returnedForum.Id == id, "ID was corrupted from " + id + " to " + returnedForum.Id);
            Assert.IsTrue(returnedForum.Title == title, "Title was corrupted from " + title + " to " + returnedForum.Title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri, "ParentUri was corrupted from " + parentUri + " to " + returnedForum.ParentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "Total count should have been 0, but was " + returnedForum.commentList.TotalCount);

            Console.WriteLine("After mimeTypes - inXmlMimeTypeTextXML");
        } // ends inXmlMimeTypeTextXML

        /// <summary>
        /// XML POST data, MIME type of application/xml - expect success + XML response
        /// </summary>
        [TestMethod]
        public void inXmlMimeTypeAppXML()
        {
            Console.WriteLine("Before mimeTypes - inXmlMimeTypeAppXML");

            // test variant data
            string mimeType = "application/xml"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest request;
            int newSiteCount = 0;
            string respStr = "";
            BBC.Dna.Api.CommentForum returnedForum;

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            // check that one was actually created
            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);
            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));
            testUtils_CommentsAPI.runningForumCount = newSiteCount;

            // check schema of what came back
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
            validator.Validate();

            // check content of what came back
            respStr = request.GetLastResponseAsString();
            returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(respStr, typeof(BBC.Dna.Api.CommentForum));

            Assert.IsTrue(returnedForum.Id == id, "ID was corrupted from " + id + " to " + returnedForum.Id);
            Assert.IsTrue(returnedForum.Title == title, "Title was corrupted from " + title + " to " + returnedForum.Title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri, "ParentUri was corrupted from " + parentUri + " to " + returnedForum.ParentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "Total count should have been 0, but was " + returnedForum.commentList.TotalCount);

            Console.WriteLine("After mimeTypes - inXmlMimeTypeAppXML");
        } // ends inXmlMimeTypeAppXML

        /// <summary>
        /// JSON POST data, MIME type of text/javascript - expect success + JSON output
        /// </summary>
        // This should work because the POST JSON made for the application/x-www-form-urlencoded test works OK and this is using the same format of data
        // instead it throws back 500
        /*
         * <innerException>Error : The incoming message has an unexpected message format 'Raw'. The expected message formats for the operation are 'Xml', 'Json'. This can be because a WebContentTypeMapper has not been configured on the binding. See the documentation of WebContentTypeMapper for more details.&#xD;
Located :    at System.ServiceModel.Dispatcher.DemultiplexingDispatchMessageFormatter.DeserializeRequest(Message message, Object[] parameters)&#xD;
   at System.ServiceModel.Dispatcher.UriTemplateDispatchFormatter.DeserializeRequest(Message message, Object[] parameters)&#xD;
   at Microsoft.ServiceModel.Web.FormsPostDispatchMessageFormatter.DeserializeRequest(Message message, Object[] parameters) in d:\CruiseControl\Microsoft.ServiceModel.Web\FormsPostDispatchMessageFormatter.cs:line 91&#xD;
   at System.ServiceModel.Dispatcher.CompositeDispatchFormatter.DeserializeRequest(Message message, Object[] parameters)&#xD;
   at System.ServiceModel.Dispatcher.DispatchOperationRuntime.DeserializeInputs(MessageRpc&amp; rpc)&#xD;
   at System.ServiceModel.Dispatcher.DispatchOperationRuntime.InvokeBegin(MessageRpc&amp; rpc)&#xD;
   at System.ServiceModel.Dispatcher.ImmutableDispatchRuntime.ProcessMessage5(MessageRpc&amp; rpc)&#xD;
   at System.ServiceModel.Dispatcher.ImmutableDispatchRuntime.ProcessMessage4(MessageRpc&amp; rpc)&#xD;
   at System.ServiceModel.Dispatcher.ImmutableDispatchRuntime.ProcessMessage3(MessageRpc&amp; rpc)&#xD;
   at System.ServiceModel.Dispatcher.ImmutableDispatchRuntime.ProcessMessage2(MessageRpc&amp; rpc)&#xD;
   at System.ServiceModel.Dispatcher.ImmutableDispatchRuntime.ProcessMessage1(MessageRpc&amp; rpc)&#xD;
   at System.ServiceModel.Dispatcher.MessageRpc.Process(Boolean isOperationContextSet)&#xD;
&#xD;
</innerException></root>
         * */
        [TestMethod]
        public void inJsonMimeTypeTextJava()
        {
            Console.WriteLine("Before mimeTypes - inJsonMimeTypeTextJava");

            // test variant data
            string mimeType = "application/json"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostJSON(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest request;
            int newSiteCount = 0;
            string respStr = "";
            BBC.Dna.Api.CommentForumList returnedList;

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            // check that one was actually created
            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);
            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));
            testUtils_CommentsAPI.runningForumCount = newSiteCount;

            // examine what has come back
            respStr = request.GetLastResponseAsString();
            returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeJSONObject(respStr, typeof(BBC.Dna.Api.CommentForumList));

            /*
             * Don't know what the response looks like, so don't know how to examine it
             * 
            Assert.IsTrue(returnedForum.Id == _id, "ID was corrupted from " + _id + " to " + returnedForum.Id);
            Assert.IsTrue(returnedForum.Title == _title, "Title was corrupted from " + _title + " to " + returnedForum.Title);
            Assert.IsTrue(returnedForum.ParentUri == _parentUri, "ParentUri was corrupted from " + _ParentUri + " to " + returnedForum.ParentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "Total count should have been 0, but was " + returnedForum.commentList.TotalCount);

            BBC.Dna.Api.CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == id);
            Assert.IsTrue(returnedForum.Title == title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0);
            */

            Console.WriteLine("After mimeTypes - inJsonMimeTypeTextJava");
        } // ends inJsonMimeTypeTextJava

        /// <summary>
        /// Post as JSON, MIME type is application/xml - expect succes and output as JSON 
        /// </summary>
        [TestMethod]
        public void inJsonMimeTypeAppJson()
        {
            Console.WriteLine("Before mimeTypes - inJsonMimeTypeAppJson");

            // test variant data
            string mimeType = "application/json"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.OK;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostJSON(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest request;
            int newSiteCount = 0;
            string respStr = "";
            BBC.Dna.Api.CommentForum returnedForum;

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            // check that one was actually created
            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);
            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));
            testUtils_CommentsAPI.runningForumCount = newSiteCount; 

            // examine what has come back
            respStr = request.GetLastResponseAsString();
            returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeJSONObject(respStr, typeof(BBC.Dna.Api.CommentForum));

            Assert.IsTrue(returnedForum.Id == id, "ID was corrupted from " + id + " to " + returnedForum.Id);
            Assert.IsTrue(returnedForum.Title == title, "Title was corrupted from " + title + " to " + returnedForum.Title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri, "ParentUri was corrupted from " + parentUri + " to " + returnedForum.ParentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "Total count should have been 0, but was " + returnedForum.commentList.TotalCount);

            Console.WriteLine("After mimeTypes - inJsonMimeTypeAppJson");
        } // ends inJsonMimeTypeAppJson

        /// <summary>
        /// JSON POST data, MIME type of application/x-www-form-urlencoded therefore goes to a specific file - expect success and respons as XML
        /// </summary>
        [TestMethod]
        public void inJsonMimeTypeAppUrlEnc()
        {
            /*
             * BBC_Dna_Services_Tests.Comments_Service.Create_Forum.mimeTypes.inJsonMimeTypeAppUrlEnc:
      Expected a response of: Created actaully got: BadRequest - Bad Request more details: <error xmlns="BBC.Dna.Api" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><code>InvalidForumUid</code><detail>Forum uid is empty, null or exceeds 255 characters.</detail><innerException></innerException></error>
      Expected: True
      But was:  False
            */
            Console.WriteLine("Before mimeTypes - inJsonMimeTypeAppUrlEnc");

            // test variant data
            string mimeType = "application/x-www-form-urlencoded"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.BadRequest;
            string fileName = "create.htm";

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "";
            //string fileName = "";
            string postData = testUtils_CommentsAPI.makePostJSON(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest request;

            request = doIt(postData, mimeType, expectedResponseCode, fileName);
            
        } // ends inJsonMimeTypeAppUrlEnc

        //-------------------------------------------------------------------------------------------------------------------
        /// <summary>
        /// force 400-BadRequest-InvalidForumParentUri-Forum parent uri is empty, null or not from a bbc.co.uk domain
        /// just see that it is HTML and the right HTML
        /// </summary>
        [TestMethod]
        public void inXmlOutXml400()
        {
            Console.WriteLine("Before mimeTypes - inXmlOutXml400");

            // test variant data
            string mimeType = "text/xml"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.BadRequest;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "yabber.dabber.dooooo";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest request;
            string respStr = "";

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            // look at what came back
            respStr = request.GetLastResponseAsString(); // store it before it goes away

            // these tests need to be replaced with something useful
            //Assert.IsTrue(respStr.IndexOf("0 comments") > 0);
            //Assert.IsTrue(respStr.IndexOf("id=\"dna-commentforum\"") > 0);

            Console.WriteLine("After mimeTypes - inXmlOutXml400");
        } // ends inXmlMimeTypeHTML


        /// <summary>
        /// force 400-BadRequest-InvalidForumParentUri-Forum parent uri is empty, null or not from a bbc.co.uk domain
        /// just see that it is HTML and the right HTML
        /// </summary>
        [TestMethod]
        public void inXmlOutHTML400()
        {
            Console.WriteLine("Before mimeTypes - inXmlOutHTML400");

            // test variant data
            string mimeType = "text/html"; // test variant
            HttpStatusCode expectedResponseCode = HttpStatusCode.BadRequest;

            // consistent input data
            string id = "";
            string title = "";
            string parentUri = "yabber.dabber.dooooo";
            string fileName = "";
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest request;
            string respStr = "";

            request = doIt(postData, mimeType, expectedResponseCode, fileName);

            // look at what came back
            respStr = request.GetLastResponseAsString(); // store it before it goes away

            // these tests need to be replaced with something useful
            //Assert.IsTrue(respStr.IndexOf("0 comments") > 0);
            //Assert.IsTrue(respStr.IndexOf("id=\"dna-commentforum\"") > 0);

            Console.WriteLine("After mimeTypes - inXmlOutHTML400");
        } // ends inXmlMimeTypeHTML



        //-------------------------------------------------------------------------------------------------------------------------------
       /// <summary>
       /// Abstraction of the actual work - make the call and check the response
       /// </summary>
       /// <param name="myPostData">Post data that is to be used</param>
       /// <param name="myMimeType">The mime type that is to be declared</param>
       /// <param name="myRespCode">The HTTP repsonse code to expect</param>
       /// <returns>the populated request object</returns>
       private DnaTestURLRequest doIt(string myPostData, string myMimeType, HttpStatusCode myRespCode, string fileName)
       {

           DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
           request.SetCurrentUserEditor();

           string url = "http://" + testUtils_CommentsAPI.server + "/dna/api/comments/CommentsService.svc/v1/site/" + testUtils_CommentsAPI.sitename + "/" + fileName;

           // now get the response - minimal POST data, no clue about the input mime-type , user is not allowed, however
           try
           {
               request.RequestPageWithFullURL(url, myPostData, myMimeType);
           }
           catch
           {
               // don't loose control.
               string resStr = request.GetLastResponseAsString();
           }
           
           Assert.IsTrue(
               request.CurrentWebResponse.StatusCode == myRespCode,
               "Expected a response of: " + myRespCode + 
               " actaully got: " + request.CurrentWebResponse.StatusCode +" - "+ request.CurrentWebResponse.StatusDescription +
               " more details: "+ request.GetLastResponseAsString()
               );

           return request;
        }

        // =============================================================================================
        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("completed mimeTypes");
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
