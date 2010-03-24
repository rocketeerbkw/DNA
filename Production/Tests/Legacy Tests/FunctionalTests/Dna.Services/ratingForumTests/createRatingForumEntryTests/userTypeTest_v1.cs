using System;
using System.Net;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;




namespace FunctionalTests
{
    /// <summary>
    /// Testing the creation of review / rating entries via the reviews API
    /// This set of tests check what happens when different types of user make a rating. most test use the straightforward XML in/out route
    /// but there are a couple using the form post, just to get a bit of coverage there.
    /// In all cases, use the basic minimum of data and using the XML 
    /// the test fo success / failure is based on the HTTP status code, the content of a succesful response is tested elsewhere
    /// </summary>
    [TestClass]
    public class userType
    {
        /// <summary>
        /// Normal users are the ones who usually post reviews
        /// </summary>
        [TestMethod]
        public void normalUser()
        {
            Console.WriteLine("Before userType - normalUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserNormal();

            doIt_xml(request, HttpStatusCode.OK);

            Console.WriteLine("After userType - normalUser");
        }

        /// <summary>
        /// No reason why editors can't make reviews
        /// </summary>
        [TestMethod]
        public void editorUser()
        {
            Console.WriteLine("Before userType - editorUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserEditor();

            doIt_xml(request, HttpStatusCode.OK);

            Console.WriteLine("After userType - editorUser");
        }

        /// <summary>
        /// Expect it to fail because the user is not logged on
        /// </summary>
        [TestMethod]
        public void NotLoggedInUser()
        {
            Console.WriteLine("Before userType - NotLoggedInUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserNotLoggedInUser();

            doIt_xml(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userType - NotLoggedInUser");
        }

        /// <summary>
        /// Probably will succeed for superusers.
        /// </summary>
        [TestMethod]
        public void superUser()
        {
            Console.WriteLine("Before userType - superUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserSuperUser();

            doIt_xml(request, HttpStatusCode.OK);

            Console.WriteLine("After userType - superUser");
        }

        /// <summary>
        /// Expect it to fail because the user is a banned
        /// </summary>
        [TestMethod]
        public void bannedUser()
        {
            Console.WriteLine("Before userType - bannedUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserBanned();

            doIt_xml(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userType - bannedUser");
        }

        // run a couple using the form-post just to prove that this route is not open either.
        /// <summary>
        /// Expect it to fail because the user is a banned, use the form method
        /// </summary>
        [TestMethod]
        // can't make the JSON methods work
        public void bannedUser_formPost()
        {
            Console.WriteLine("Before userType - bannedUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserBanned();

            doIt_formPost(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userType - bannedUser");
        }

        /// <summary>
        /// Expect it to fail because the user is a banned
        /// </summary>
        [TestMethod]
        public void normalUser_formPost()
        {
            Console.WriteLine("Before userType - bannedUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserNormal();

            doIt_formPost(request, HttpStatusCode.Created);

            Console.WriteLine("After userType - bannedUser");
        }        
        
        // =============================================================================================
        /// <summary>
        /// Abstraction of the actual work
        /// All that this one does is see the return code is as expected, and
        /// if it could, it is is a success code, that the count of forums has gone up by one
        /// If it is not a success code, check that the response is well-formed XML
        /// </summary>
        /// <param name="myRequest">A request object initialiased with the sort of user to be used</param>
        /// <param name="expectedCode">The expected HTTP status code. If it is OK, it is assumed that another forum will be created and this is checked</param>
        private void doIt_xml(DnaTestURLRequest myRequest, HttpStatusCode expectedCode)
        {
            string fileName = ""; // using xml, so don't need this exta bit on the url
            string mimeType = "text/xml";
            string formatParam = "xml";

            string testForumId = "";
            string postData = ""; ;
            string theText = "";
            string theRating = "";
            string url = "";
            string itemCount = "";

            // make the forum on which the test review-posting can be hung.
            testForumId = testUtils_ratingsAPI.makeTestForum();

            // now make the posting
            postData = testUtils_ratingsAPI.makeEntryPostXml_minimal(ref theText, ref theRating);

            url = String.Format(
                "http://{0}/dna/api/comments/ReviewService.svc/V1/site/{1}/reviewforum/{2}/{3}?format={4}",
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

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Expecting " + expectedCode + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            if (expectedCode == HttpStatusCode.OK)
            {
                itemCount = testUtils_ratingsAPI.forumEntryCount(testForumId);

                Assert.IsTrue(
                    itemCount == "1",
                    "There should now be one item in the list. there are : " + itemCount
                    );
            }
            else
            {
                // given that all of these are asking for XML, this can be used on them all
                XmlDocument xml = myRequest.GetLastResponseAsXML();

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaError);
                validator.Validate();
            }
        
        }

        // =============================================================================================
        /// <summary>
        /// Similar to the above, buit it uses the form post mechanism - just to make sure
        /// </summary>
        /// <param name="myRequest">A request object initialiased with the sort of user to be used</param>
        /// <param name="expectedCode">The expected HTTP status code. If it is OK, it is assumed that another forum will be created and this is checked</param>
        private void doIt_formPost(DnaTestURLRequest myRequest, HttpStatusCode expectedCode)
        {
            const string filename = testUtils_ratingsAPI._formPostUrlPart; // "create.htm";
            const string mimeType = "application/x-www-form-urlencoded";

            string testForumId = "";
            string formatParam = "XML";
            string postData = ""; ;
            string theText = "";
            string theRating = "";
            string url = "";

            // make the forum on which the test review-posting can be hung.
            testForumId = testUtils_ratingsAPI.makeTestForum();

            postData = testUtils_ratingsAPI.makeEntryPostJSON_minimal(ref theText, ref theRating);

            url = String.Format(
                "http://{0}/dna/api/comments/ReviewService.svc/V1/site/{1}/reviewforum/{2}/{3}?format={4}",
                testUtils_ratingsAPI.server,
                testUtils_ratingsAPI.sitename,
                testForumId,
                filename,
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

        }
       // =============================================================================================

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("completed userType");
        }

        /// <summary>
        /// Refresh the database (smallGuide)
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();

            // testUtils_ratingsAPI.runningForumCount = testUtils_ratingsAPI.countForums(testUtils_ratingsAPI.sitename);
        }

    
    } // ends class
} // ends namespace
