using System;
using System.Net;
using System.Xml;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of review / rating entries via the reviews API
    /// This set of tests check the relationship between teh value in the rating and the allowed values, both by implementation and the site option
    /// </summary>

    [TestClass]
    public class ratingValueTest_v1
    {
        
        /// <summary>
        /// Create a rating with a value = min allowed value
        /// </summary>
        [TestMethod]
        public void atFloor()
        {
            Console.WriteLine("Before ReviewAPI_RatingEntriesTests_ratingValue_V1 - atFloor");

            Random random = new Random();
            int testRatingCeilingValue = random.Next(testUtils_ratingsAPI._implementedFloor, testUtils_ratingsAPI._implementedCeiling);
            int testRatingValue = testUtils_ratingsAPI._implementedFloor;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.OK);

            Console.WriteLine("After ReviewAPI_RatingEntriesTests_ratingValue_V1 - atFloor");
        }
        
        /// <summary>
        /// Create a rating with a value = (min - 1) allowed value
        /// </summary>
        [TestMethod]
        public void justBelowFloor()
        {
            Console.WriteLine("Before ReviewAPI_RatingEntriesTests_ratingValue_V1 - justBelowFloor");

            Random random = new Random();
            int testRatingCeilingValue = random.Next(testUtils_ratingsAPI._implementedFloor, testUtils_ratingsAPI._implementedCeiling);
            int testRatingValue = (testUtils_ratingsAPI._implementedFloor - 1);

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.BadRequest);

            Console.WriteLine("After ReviewAPI_RatingEntriesTests_ratingValue_V1 - justBelowFloor");
        }

        /// <summary>
        /// Create a rating with a value = (min - a random number) allowed value
        /// </summary>
        [TestMethod]
        public void wayBelowFloor()
        {
            Console.WriteLine("Before ReviewAPI_RatingEntriesTests_ratingValue_V1 - wayBelowFloor");

            Random random = new Random();
            int subtractor = random.Next(2, 1000);
            int testRatingCeilingValue = random.Next(testUtils_ratingsAPI._implementedFloor, testUtils_ratingsAPI._implementedCeiling);
            int testRatingValue = (testUtils_ratingsAPI._implementedFloor - subtractor);

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.BadRequest);

            Console.WriteLine("After ReviewAPI_RatingEntriesTests_ratingValue_V1 - wayBelowFloor");
        }

        /// <summary>
        /// Change the ceiling and then create a rating just under that ceiling. 
        /// </summary>
        [TestMethod]
        public void justBelowNewCeiling()
        {
            Console.WriteLine("Before ratingValueTest_v1 - justBelowNewCeiling");

            Random random = new Random();

            // set the ceiling to be somewhere in the top half of the range allowed by the implementation
            int testRatingCeilingValue = random.Next((int)(testUtils_ratingsAPI._implementedCeiling / 2) , testUtils_ratingsAPI._implementedCeiling);

            int testRatingValue = testRatingCeilingValue - 1;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.OK);

            Console.WriteLine("After ratingValueTest_v1 - justBelowNewCeiling");
        }

        /// <summary>
        /// Change the ceiling and then create a rating just at that ceiling.
        /// Do this withinin the range specified for the implementation - currently, it gives a server error with numbers above the implementation theshold
        /// </summary>
        [TestMethod]
        public void atNewCeiling()
        {
            Console.WriteLine("Before ratingValueTest_v1 - atNewCeiling");

            Random random = new Random();

            int testRatingCeilingValue = random.Next(testUtils_ratingsAPI._implementedFloor, testUtils_ratingsAPI._implementedCeiling);

            int testRatingValue = testRatingCeilingValue;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.OK);

            Console.WriteLine("After ratingValueTest_v1 - atNewCeiling");
        }

        /// <summary>
        /// Change the ceiling and then create a rating just over that ceiling. 
        /// Keep mumbers below the implementation threshold - currently, it gives a server error with numbers above the implementation theshold
        /// </summary>
        [TestMethod]
        // gives a 500, it should be a bad request
        public void justAboveNewCeiling()
        {
            Console.WriteLine("Before ratingValueTest_v1 - atNewCeiling");

            Random random = new Random();

            int testRatingCeilingValue = random.Next(testUtils_ratingsAPI._implementedFloor, (testUtils_ratingsAPI._implementedCeiling - 1));

            int testRatingValue = testRatingCeilingValue + 1;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.BadRequest);

            Console.WriteLine("After ratingValueTest_v1 - atNewCeiling");
        }
        // gives a 500, it should be a bad request
        /// <summary>
        /// Change the ceiling and then create a rating way over that ceiling. Do this in the range specified for the implementation
        /// Keep mumbers below the implementation threshold - currently, it gives a server error with numbers above the implementation theshold
        /// </summary>
        [TestMethod]

        public void wayAboveNewCeiling()
        {
            Console.WriteLine("Before ratingValueTest_v1 - wayAboveNewCeiling");

            const int maxFactor = 100;

            Random random = new Random();

            int testRatingCeilingValue = random.Next(testUtils_ratingsAPI._implementedFloor, (testUtils_ratingsAPI._implementedCeiling - maxFactor));
            int addition = random.Next(10, maxFactor);

            int testRatingValue = testRatingCeilingValue + addition;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.BadRequest);

            Console.WriteLine("After ratingValueTest_v1 - wayAboveNewCeiling");
        }

        //***************
        
        /// <summary>
        /// Set the ceiling to the max implemented value and then create a rating just under that ceiling. Do this in the range specified for the implementation
        /// </summary>
        [TestMethod]
        public void justBelowImplemCeiling()
        {
            Console.WriteLine("Before ratingValueTest_v1 - justUnderImplemCeiling");

            int testRatingCeilingValue = testUtils_ratingsAPI._implementedCeiling;

            int testRatingValue = testRatingCeilingValue - 1;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.OK);

            Console.WriteLine("After ratingValueTest_v1 - justUnderImplemCeiling");
        }

        /// <summary>
        /// Set the ceiling to the max implemented value and then create a rating just at that ceiling. Do this in the range specified for the implementation
        /// </summary>
        [TestMethod]
        public void atImplemCeiling()
        {
            Console.WriteLine("Before ratingValueTest_v1 - atImplemCeiling");

            Random random = new Random();

            int testRatingCeilingValue = testUtils_ratingsAPI._implementedCeiling;

            int testRatingValue = testRatingCeilingValue;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.OK);

            Console.WriteLine("After ratingValueTest_v1 - atImplemCeiling");
        }

        /// <summary>
        /// Change the ceiling and then create a rating just over that ceiling. Do this in the range specified for the implementation
        /// </summary>
        [TestMethod]
        // it actually returns Server Error (with a useful eror message)
        public void justAboveImplemCeiling()
        {
            Console.WriteLine("Before ratingValueTest_v1 - justAboveImplemCeiling");

            int testRatingCeilingValue = testUtils_ratingsAPI._implementedCeiling;

            int testRatingValue = testRatingCeilingValue + 1;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.BadRequest);

            Console.WriteLine("After ratingValueTest_v1 - justAboveImplemCeiling");
        }

        /// <summary>
        /// Change the ceiling and then create a rating way over that ceiling. Do this in the range specified for the implementation
        /// </summary>
        [TestMethod]
        // it actually returns Server Error (with a useful eror message)
        public void wayAboveImplemCeiling()
        {
            Console.WriteLine("Before ratingValueTest_v1 - wayAboveImplemCeiling");

            Random random = new Random();

            int testRatingCeilingValue = testUtils_ratingsAPI._implementedCeiling;
            int addition = random.Next(2, 1000);

            int testRatingValue = testRatingCeilingValue + addition;

            testIt_xml(testRatingCeilingValue.ToString(), testRatingValue.ToString(), HttpStatusCode.BadRequest);

            Console.WriteLine("After ratingValueTest_v1 - wayAboveImplemCeiling");
        }


        // =============================================================================================
        /// <summary>
        /// Abstraction of the actual work
        /// Creates a forum using minimal data + a max rating value. this value is set in the test set-up procedure
        /// </summary>
        /// <param name="myRequest">A request object initialiased with the sort of user to be used</param>
        /// <param name="expectedCode">The expected HTTP status code. If it is OK, it is assumed that another forum will be created and this is checked</param>
        private void testIt_xml(string forumCeiling, string theRating, HttpStatusCode expectedCode)
        {
            string fileName = ""; // using xml, so don't need this exta bit on the url
            string mimeType = "text/xml";
            string formatParam = "xml";

            string testForumId = "";
            string postData = ""; ;
            string theText = "";
            string url = "";

            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            myRequest.UseIdentitySignIn = true;

            // Step 1. make the forum on which the test review-posting can be hung.
            testForumId = testUtils_ratingsAPI.makeTestForum();

            // set the rating ceiling for the forum
            testUtils_ratingsAPI.setCeiling(testForumId, forumCeiling);

            // now post to the review forum
            myRequest.SetCurrentUserNormal();
            postData = testUtils_ratingsAPI.makeEntryPostXml_minimal(ref theText, ref theRating);

            url = String.Format(
                "https://{0}/dna/api/comments/ReviewService.svc/V1/site/{1}/reviewforum/{2}/{3}?format={4}",
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

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            if (expectedCode == HttpStatusCode.OK)
            {
                /*
                string itemCount = "";
                // sometimes it hangs on this
                itemCount = testUtils_ratingsAPI.forumEntryCount(testForumId);

                Assert.IsTrue(
                    itemCount == "1",
                    "There should now be one item in the list. there are : " + itemCount
                    );
                 */
            }
            else
            {
                // given that all of these are asking for XML, this can be used on them all
                XmlDocument xml = myRequest.GetLastResponseAsXML();

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaError);
                validator.Validate();
            }
        
        }

        /*
        /// <summary>
        /// Build the POST data for createing a review forum
        /// </summary>
        /// <param name="id">name of forum</param>
        /// <param name="title"></param>
        /// <param name="parentUri"></param>
        /// <param name="ratingValue"></param>
        /// <returns></returns>
        private string makeCreatePostXml(ref string id, ref string title, ref string parentUri, string ratingValue)
        {
            DateTime dt = DateTime.Now;
            String TimeStamp = testUtils_ratingsAPI.makeTimeStamp();

            if (id == "")
                id = "FunctiontestReviewForum-" + Guid.NewGuid().ToString(); // the tail bit creates an unique string

            if (title == "")
                title = "Functiontest Title " + TimeStamp;

            if (parentUri == "")
                parentUri = "http://www.bbc.co.uk/dna/" + TimeStamp + "/";

            string postXML = String.Format(
                "<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "<rating>{3}</rating>" +
                "</ratingForum>",
                id, title, parentUri, ratingValue);

            return postXML;
        }
        */

        // =============================================================================================

        [TestCleanup]
        public void ShutDown()
        {
            testUtils_ratingsAPI.setCeiling("", "5");
            Console.WriteLine("completed ratingValueTest_v1");
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
