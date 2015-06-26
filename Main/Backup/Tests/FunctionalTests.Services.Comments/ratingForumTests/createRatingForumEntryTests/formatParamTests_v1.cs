using System;
using System.Net;
using System.Text.RegularExpressions;
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
    /// </summary>
    [TestClass]
    public class RatingFormatParamTests
    {
        /// <summary>
        /// Send in XML, don't specify the output, the output should be XML
        /// </summary>
        [TestMethod]
        public void inXMLoutDefault()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutDefault");

            // test variants
            string formatParam = "";
            HttpStatusCode expectedCode = HttpStatusCode.OK;

            // working data
            int inputRating = 0;
            string inputText = "";
            DnaTestURLRequest myRequest = null;

            // run test
            myRequest = do_it(formatParam, ref inputText, ref inputRating);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After formatParamTests - inXMLoutDefault");
        }

        /// <summary>
        /// send in XML, ask for XML, verify it
        /// </summary>
        [TestMethod]
        public void inXMLoutXML()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutXML");

            // test variants
            string formatParam = "XML";
            HttpStatusCode expectedCode = HttpStatusCode.OK;

            // working data
            int inputRating = 0;
            string inputText = "";
            DnaTestURLRequest myRequest = null;

            // run test
            myRequest = do_it(formatParam, ref inputText, ref inputRating);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            validator.Validate();

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After formatParamTests - inXMLoutXML");
        }


        /// <summary>
        /// Get JSON output
        /// </summary>
        [TestMethod]
        public void inXMLoutJSON()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutJSON");

            // test variants
            string formatParam = "JSON";
            HttpStatusCode expectedCode = HttpStatusCode.OK;

            // working data
            int inputRating = 0;
            string inputText = "";
            DnaTestURLRequest myRequest = null;

            // run test
            myRequest = do_it(formatParam, ref inputText, ref inputRating);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            RatingInfo returnedRating = (RatingInfo)StringUtils.DeserializeJSONObject(myRequest.GetLastResponseAsString(), typeof(RatingInfo));

            Assert.IsTrue(returnedRating.text == inputText);
            Assert.IsTrue(returnedRating.rating == inputRating);
            Assert.IsNotNull(returnedRating.User);
            Assert.IsTrue(returnedRating.User.UserId == myRequest.CurrentUserID);

            Console.WriteLine("After formatParamTests - inXMLoutJSON");
        }

        /// <summary>
        /// Get HTML output
        /// </summary>
        [TestMethod]
        public void inXMLoutHTML()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutHTML");

            // test variants
            string formatParam = "HTML";
            HttpStatusCode expectedCode = HttpStatusCode.NotImplemented;

            // working data
            int inputRating = 0;
            string inputText = "";
            DnaTestURLRequest myRequest = null;

            // run test
            myRequest = do_it(formatParam, ref inputText, ref inputRating);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );
            Console.WriteLine("After formatParamTests - inXMLoutHTML");
        }

        /// <summary>
        /// Send in XML, ask for an unkonown output format, should fail.
        /// </summary>
        [TestMethod]
        public void inXMLoutInvalid()
        {
            Console.WriteLine("Before formatParamTests - inXMLoutInvalid");

            // test variants
            string formatParam = "WML";
            HttpStatusCode expectedCode = HttpStatusCode.NotImplemented;

            // working data
            int inputRating = 0;
            string inputText = "";
            DnaTestURLRequest myRequest = null;

            // run test
            myRequest = do_it(formatParam, ref inputText, ref inputRating);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            Console.WriteLine("After formatParamTests - inXMLoutInvalid");
        }

        //==============================================================================================
        /// <summary>
        /// Abstract the work of creating a new forum and then adding a rating to it sot that it does not obscure the tests
        /// Some params are passed by ref so that they can be used in verification (afterwards)
        /// </summary>
        /// <param name="formatParam">to be added at the format parameter at the end of the URL, can be empty</param>
        /// <param name="inputText">Comment text</param>
        /// <param name="inputRating">The score</param>
        /// <returns></returns>
        private DnaTestURLRequest do_it(string formatParam, ref string inputText, ref int inputRating)
        {
            System.Random RandNum = new System.Random();
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            string url = "";
            string mimeType = "text/xml";
            string postData = "";
            string testForumId;

            inputRating = RandNum.Next(1, 5);
            inputText = "Test rating content" + Guid.NewGuid().ToString();

            postData = String.Format(
                "<rating xmlns=\"BBC.Dna.Api\"><text>{0}</text><rating>{1}</rating></rating>",
                inputText,
                inputRating
                );

            // step 1 - create a review forum into which this review item will go
            testForumId = testUtils_ratingsAPI.makeTestForum();

            // step 2 - create the review item
            myRequest.SetCurrentUserNormal();
            url = String.Format(
                "https://{0}/dna/api/comments/ReviewService.svc/V1/site/{1}/reviewforum/{2}/",
                testUtils_ratingsAPI.secureserver,
                testUtils_ratingsAPI.sitename,
                testForumId
                );

            if (formatParam != "")
                url += "?format=" + formatParam;
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
            Console.WriteLine("completed formatParamTests");
        }

        /// <summary>
        /// Refresh the database (smallGuide)
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp formatParamTests");

            SnapshotInitialisation.RestoreFromSnapshot();

            // testUtils_ratingsAPI.runningForumCount = testUtils_ratingsAPI.countForums(testUtils_ratingsAPI.sitename);
        }

    
    } // ends class
} // ends namespace
