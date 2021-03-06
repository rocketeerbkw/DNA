using System;
using System.Net;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of individual reviews entries via the reviews API
    /// Test the diferent values that the format param can take 
    /// All test have the format param set to XML
    /// </summary>
    [TestClass]
    public class mimeType
    {
        /// <summary>
        /// Don't specify the mime type, it will assume XML
        /// </summary>
        [TestMethod]
        public void MimeType_PostWithoutMimeType_ReturnsUnsupportedMediaType()
        {
            Console.WriteLine("Before mimeType - MimeType_none");

            // test variants
            string mimeType = "";
            HttpStatusCode expectedCode = HttpStatusCode.UnsupportedMediaType;
            string fileName = ""; // used on the HTML-form thing
            string formatFrag = "";

            // working data
            string inputRating = "";
            string inputText = "";
            string postData = "";
    
            DnaTestURLRequest myRequest = null;

            // run test
            postData = testUtils_ratingsAPI.makeEntryPostXml_minimal(ref inputText, ref inputRating);
            myRequest = do_it(mimeType, fileName, postData, formatFrag);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );
        }

        /// <summary>
        /// Specify an unknown mime type, it will assume XML
        /// </summary>
        [TestMethod]
        public void MimeType_PostWithUnknown_ReturnsInternalServerError()
        {
            Console.WriteLine("Before mimeType - MimeType_unknown");

            // test variants
            string mimeType = "text-xml";
            HttpStatusCode expectedCode = HttpStatusCode.InternalServerError;
            string fileName = ""; // used on the HTML-form thing
            string formatFrag = "XML";

            // working data
            string inputRating = "";
            string inputText = "";
            string postData = "";
            DnaTestURLRequest myRequest = null;

            // run test
            postData = testUtils_ratingsAPI.makeEntryPostXml_minimal(ref inputText, ref inputRating);
            myRequest = do_it(mimeType, fileName, postData, formatFrag);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );
            Console.WriteLine("After mimeType - MimeType_unknown");
        }

        /// <summary>
        /// text/xml
        /// </summary>
        [TestMethod]
        public void MimeType_xmlText()
        {
            Console.WriteLine("Before mimeType - MimeType_xmlText");

            // test variants
            string mimeType = "text/xml";
            HttpStatusCode expectedCode = HttpStatusCode.OK;
            string fileName = ""; // used on the HTML-form thing
            string formatFrag = "XML";

            // working data
            string inputRating = "";
            string inputText = "";
            string postData = "";
            DnaTestURLRequest myRequest = null;

            // run test
            postData = testUtils_ratingsAPI.makeEntryPostXml_minimal(ref inputText, ref inputRating);
            myRequest = do_it(mimeType, fileName, postData, formatFrag);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            Assert.IsNotNull(xml, "The xml retreived from the response should not be null");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating.ToString() == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After mimeType - MimeType_xmlText");
        }


        /// <summary>
        /// application/xml
        /// </summary>
        [TestMethod]
        public void MimeType_xmlApplic()
        {
            Console.WriteLine("Before mimeType - MimeType_applicXml");

            // test variants
            string mimeType = "application/xml";
            HttpStatusCode expectedCode = HttpStatusCode.OK;
            string fileName = ""; // used on the HTML-form thing
            string formatFrag = "XML";

            // working data
            string inputRating = "";
            string inputText = "";
            string postData = "";
            DnaTestURLRequest myRequest = null;

            // run test
            postData = testUtils_ratingsAPI.makeEntryPostXml_minimal(ref inputText, ref inputRating);
            myRequest = do_it(mimeType, fileName, postData, formatFrag);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            Assert.IsNotNull(xml, "The xml retreived from the response should not be null");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating.ToString() == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After mimeType - MimeType_applicXml");
        }


        /// <summary>
        /// text/javascript - but given that the format=XML is set, should get XML output.
        /// </summary>
        [TestMethod]
        public void MimeType_PostAsJsonReturnAsXml_CorrectContentCreated()
        {
            Console.WriteLine("Before mimeType - MimeType_jsText");

            // test variants
            string mimeType = "application/json";
            HttpStatusCode expectedCode = HttpStatusCode.OK;
            string fileName = ""; // used on the HTML-form thing
            string formatFrag = "XML";

            // working data
            string inputRating = "";
            string inputText = "";
            string postData = "";
            DnaTestURLRequest myRequest = null;

            // run test
            postData = testUtils_ratingsAPI.makeEntryPostJSON_minimal(ref inputText, ref inputRating);
            myRequest = do_it(mimeType, fileName, postData, formatFrag);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            Assert.IsNotNull(xml, "The xml retreived from the response should not be null");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));
            //RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeJSONObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating.ToString() == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After mimeType - MimeType_jsText");
        }


        //==============================================================================================
        private DnaTestURLRequest do_it(string mimeType, string fileName, string postData, string formatFrag)
        {
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            string url = "";
            string formatParam = "";
            string testForumId;

            // step 1 - create a review forum into which this review item will go
            testForumId = testUtils_ratingsAPI.makeTestForum();

            // step 2 - create the review item
            if( formatFrag != "" )
                formatParam = "?format=" + formatFrag;
            
            myRequest.SetCurrentUserNormal();

            url = String.Format(
                "https://{0}/dna/api/comments/ReviewService.svc/V1/site/{1}/reviewforum/{2}/{3}{4}",
                testUtils_ratingsAPI.secureserver,
                testUtils_ratingsAPI.sitename,
                testForumId,
                fileName,
                formatParam
                );

            try
            {
                myRequest.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                // Don't loose control
            }

            return myRequest;
        }

       // =============================================================================================

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("completed mimeType");
        }

        /// <summary>
        /// Refresh the database (smallGuide)
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp mimeType");

            SnapshotInitialisation.RestoreFromSnapshot();

            // testUtils_ratingsAPI.runningForumCount = testUtils_ratingsAPI.countForums(testUtils_ratingsAPI.sitename);
        }

    
    } // ends class
} // ends namespace
