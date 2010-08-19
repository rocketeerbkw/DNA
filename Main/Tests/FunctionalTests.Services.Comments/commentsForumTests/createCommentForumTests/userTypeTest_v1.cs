using System;
using System.Net;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;




namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of comments forums via the Comments API
    /// This set of tests check what happens with different types of user - normal people should not be able to create them
    /// In all cases, use the basic minimum of data
    /// </summary>
    [TestClass]
    public class userTypes
    {
        /// <summary>
        /// Normal users can't create a fprum (because not an editor)
        /// </summary>
        [TestMethod]
        public void normalUser()
        {
            Console.WriteLine("Before userTypes - normalUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserNormal();

            doIt(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userTypes - normalUser");
        }

        /// <summary>
        /// Succeeds because user is an editor
        /// </summary>
        [TestMethod]
        public void editorUser()
        {
            Console.WriteLine("Before userTypes - editorUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserEditor();

            doIt(request, HttpStatusCode.OK);

            Console.WriteLine("After userTypes - editorUser");
        }

        /// <summary>
        /// Expect it to fail because the user is not logged on
        /// </summary>
        [TestMethod]
        public void NotLoggedInUser()
        {
            Console.WriteLine("Before userTypes - NotLoggedInUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserNotLoggedInUser();

            doIt(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userTypes - NotLoggedInUser");
        }

        /// <summary>
        /// Probably will succeed for superusers.
        /// </summary>
        [TestMethod]
        public void superUser()
        {
            Console.WriteLine("Before userTypes - superUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserSuperUser();

            doIt(request, HttpStatusCode.OK);

            Console.WriteLine("After userTypes - superUser");
        }

        /// <summary>
        /// Expect it to fail because the user is a banned
        /// </summary>
        [TestMethod]
        public void bannedUser()
        {
            Console.WriteLine("Before userTypes - bannedUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            request.SetCurrentUserBanned();

            doIt(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userTypes - bannedUser");
        }


        // =============================================================================================
        /// <summary>
        /// Abstraction of the actual work
        /// All that htis one does is see the return code is as expected, and
        /// if it is a success code, that the count of forums has gone up by one
        /// </summary>
        /// <param name="myRequest">A request object initialiased with the sort of user to be used</param>
        /// <param name="expectedCode">The expected HTTP status code. If it is OK, it is assumed that another forum will be created and this is checked</param>
        private void doIt(DnaTestURLRequest myRequest, HttpStatusCode expectedCode)
        {
            int newForumcount = 0;

            string id = "";
            string title = "";
            string parentUri = ""; // not actually going to do anything with these, but need to give them the postXML

            string url = "http://" + testUtils_CommentsAPI.server + "/dna/api/comments/CommentsService.svc/v1/site/" + testUtils_CommentsAPI.sitename + "/";

            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri); // make some unique data for the new forum

            try
            {
                myRequest.RequestPageWithFullURL(url, postXML, "text/xml");
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
                newForumcount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);

                Assert.IsTrue(
                    newForumcount == (testUtils_CommentsAPI.runningForumCount + 1),
                    "expected the forum count to be incremented by  one. Old count: " + testUtils_CommentsAPI.runningForumCount + " new count: " + newForumcount
                    );

                testUtils_CommentsAPI.runningForumCount = newForumcount;
            }
        }

       // =============================================================================================

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("completed userTypes");
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
