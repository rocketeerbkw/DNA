using System;
using System.Net;
using System.Text.RegularExpressions;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Utils;

using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Any user can only provide one rating in any forum 
    /// </summary>
    [TestClass]
    public class duplicationTests
    {
        /// <summary>
        /// Send in XML, don't specify the output, the output should be XML
        /// </summary>
        [TestMethod]
        public void onlyOnce()
        {
            Console.WriteLine("Before duplicationTests - onlyOnce");

            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            // Make the forum into which to put ratings
            string testForumId = testUtils_ratingsAPI.makeTestForum();

            myRequest.SetCurrentUserNormal();

            // make a rating for the first time
            myRequest = tryIt(testForumId, myRequest);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed to make the test rating. Expecting " + HttpStatusCode.OK +
                " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" +
                myRequest.CurrentWebResponse.StatusDescription
                );

            // try and make a second one as the same person
            myRequest = tryIt(testForumId, myRequest);

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.BadRequest,
                "Error making second attempt. Expecting " + HttpStatusCode.BadRequest +
                " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" +
                myRequest.CurrentWebResponse.StatusDescription
                );

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaError);
            validator.Validate();

            string resStr = myRequest.GetLastResponseAsString();

            Assert.IsTrue(Regex.Match(resStr, "code\\>MultipleRatingByUser<").Success == true);
            Assert.IsTrue(Regex.Match(resStr, "already").Success == true);

            Console.WriteLine("After duplicationTests - onlyOnce");
        }

        /// <summary>
        /// Try making a rating (review)
        /// </summary>
        /// <param name="forumId">The forum on which to try hanging the review</param>
        /// <param name="theRequest">The Request object (giving the user ID etc)</param>
        /// <returns>The request object (containing the response from the server)</returns>
        private DnaTestURLRequest tryIt(string forumId, DnaTestURLRequest theRequest)
        {
            string mimeType = "text/xml";
            string ratingString = "";
            string ratingScore = "";
            string postData = testUtils_ratingsAPI.makeEntryPostXml_minimal(ref ratingString, ref ratingScore);
            string url = testUtils_ratingsAPI.makeCreatePostUrl(forumId);

            try
            {
                theRequest.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
            }
            return theRequest;
        } 
        /*
        //==============================================================================================
        /// <summary>
        /// Abstract the work of creating a new forum and then adding a rating to it (so that it does not obscure the tests)
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

            inputRating = RandNum.Next(1, 5);
            inputText = "Test rating content" + Guid.NewGuid().ToString();

            postData = String.Format(
                "<rating xmlns=\"BBC.Dna.Api\"><text>{0}</text><rating>{1}</rating></rating>",
                inputText,
                inputRating
                );

            // step 1 - create a review forum into which this review item will go

            // step 2 - create the review item
            myRequest.SetCurrentUserNormal();

            url = String.Format(
                "http://{0}/dna/api/comments/ReviewService.svc/V1/site/{1}/reviewforum/{2}/",
                testUtils_ratingsAPI.server,
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

          
         * return myRequest;
        }
         * */
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
