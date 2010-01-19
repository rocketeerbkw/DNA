using System;
using System.Net;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Testing the creation of individual reviews entries via the reviews API
    /// Test the effect of combinations of mime-type and format parameter
    /// The different mime-tyes should result in differnt data formats for the response when the format parameter is not set.
    /// In the testing of the mime-types, the format parameter was always set to XML, so different values need to be exercised.
    /// </summary>
    [TestClass]
    public class mimeTypeFormatCombo
    {

        /// <summary>
        /// text/xml but whit no format, should return XML
        /// </summary>
        [TestMethod]
        public void MimeType_xmlText_formatBlank()
        {
            Console.WriteLine("Before mimeTypeFormatCombo - MimeType_xmlText_formatBlank");

            // test variants
            string mimeType = "text/xml";
            HttpStatusCode expectedCode = HttpStatusCode.OK;
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

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            Assert.IsNotNull(xml, "The xml retreived from the response should not be null");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating.ToString() == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After mimeTypeFormatCombo - MimeType_xmlText_formatBlank");
        }


        /// <summary>
        /// mime-type = application/xml and format = JSON. output should be in JSON
        /// </summary>
        [TestMethod]
        public void MimeType_xmlText_formatJSON()
        {
            Console.WriteLine("Before mimeTypeFormatCombo - MimeType_applicXml");

            // test variants
            string mimeType = "application/xml";
            HttpStatusCode expectedCode = HttpStatusCode.OK;
            string fileName = ""; // used on the HTML-form thing
            string formatFrag = "JSON";

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

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeJSONObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating.ToString() == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After mimeTypeFormatCombo - MimeType_applicXml");
        }

        // input of JSON and output of XML is already tsted in the mime-types test-set

        /// <summary>
        /// text/javascript - teh default output will correspond to the input, so should be JSON.
        /// </summary>
        [Ignore]
        // can't make the JSON input work
        public void MimeType_jsText_formatBlank()
        {
            Console.WriteLine("Before mimeTypeFormatCombo - MimeType_jsText_formatBlank");

            // test variants
            string mimeType = "text/javascript";
            HttpStatusCode expectedCode = HttpStatusCode.OK;
            string fileName = ""; // used on the HTML-form thing
            string formatFrag = "";

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

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeJSONObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating.ToString() == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After mimeTypeFormatCombo - MimeType_jsText_formatBlank");
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
                "http://{0}/dna/api/comments/ReviewService.svc/V1/site/{1}/reviewforum/{2}/{3}{4}",
                testUtils_ratingsAPI.server,
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
            Console.WriteLine("completed mimeTypeFormatCombo");
        }

        /// <summary>
        /// Refresh the database (smallGuide)
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp mimeTypeFormatCombo");

            SnapshotInitialisation.RestoreFromSnapshot();

            // testUtils_ratingsAPI.runningForumCount = testUtils_ratingsAPI.countForums(testUtils_ratingsAPI.sitename);
        }

    
    } // ends class
} // ends namespace
