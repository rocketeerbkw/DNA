using System;
using System.Net;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;




namespace FunctionalTests
{
    /// <summary>
    /// Testing the creation of reviews / ratings forums via the reviews API
    /// This set of tests check what happens with different types of user - normal people should not be able to create them
    /// In all cases, use the basic minimum of data and using the XML 
    /// </summary>
    [TestClass]
    public class RatingsUserTypes
    {
        /// <summary>
        /// Normal users can't create a forum (because not an editor)
        /// </summary>
        [TestMethod]
        public void normalUser()
        {
            Console.WriteLine("Before userTypes - normalUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserNormal();

            doIt_xml(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userTypes - normalUser");
        }

        /// <summary>
        /// Succeeds because user is an editor
        /// </summary>
        [TestMethod]
        public void editorUser()
        {
            Console.WriteLine("Before userTypes - editorUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserEditor();

            doIt_xml(request, HttpStatusCode.OK);

            Console.WriteLine("After userTypes - editorUser");
        }

        /// <summary>
        /// Expect it to fail because the user is not logged on
        /// </summary>
        [TestMethod]
        public void NotLoggedInUser()
        {
            Console.WriteLine("Before userTypes - NotLoggedInUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserNotLoggedInUser();

            doIt_xml(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userTypes - NotLoggedInUser");
        }

        /// <summary>
        /// Probably will succeed for superusers.
        /// </summary>
        [TestMethod]
        public void superUser()
        {
            Console.WriteLine("Before userTypes - superUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserSuperUser();

            doIt_xml(request, HttpStatusCode.OK);

            Console.WriteLine("After userTypes - superUser");
        }

        /// <summary>
        /// Expect it to fail because the user is a banned
        /// </summary>
        [TestMethod]
        public void bannedUser()
        {
            Console.WriteLine("Before userTypes - bannedUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserBanned();

            doIt_xml(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userTypes - bannedUser");
        }

        // run a couple using the form-post just to prove that this route is not open either.
        /// <summary>
        /// Expect it to fail because the user is a banned
        /// </summary>
        [Ignore]
        public void bannedUser_formPost()
        {
            Console.WriteLine("Before userTypes - bannedUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserBanned();

            doIt_formPost(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userTypes - bannedUser");
        }

        /// <summary>
        /// Expect it to fail because the user is a banned
        /// </summary>
        [Ignore]
        public void normalUser_formPost()
        {
            Console.WriteLine("Before userTypes - bannedUser");

            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            request.SetCurrentUserNormal();

            doIt_formPost(request, HttpStatusCode.Unauthorized);

            Console.WriteLine("After userTypes - bannedUser");
        }        // =============================================================================================
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
            //int newForumcount = 0;

            string id = "";
            string title = "";
            string parentUri = ""; // not actually going to do anything with these, but need to give them the postXML

            string url = testUtils_ratingsAPI.makeCreateForumUrl();// "http://" + testUtils_ratingsAPI.server + testUtils_ratingsAPI._resourceLocation + testUtils_ratingsAPI.sitename + "/";

            string postXML = testUtils_ratingsAPI.makeCreatePostXml_minimal(ref id, ref title, ref parentUri); // make some unique data for the new forum

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
            /*
            if (expectedCode == HttpStatusCode.OK)
            {
                newForumcount = testUtils_ratingsAPI.countForums(testUtils_ratingsAPI.sitename);

                Assert.IsTrue(
                    newForumcount == (testUtils_ratingsAPI.runningForumCount + 1),
                    "expected the forum count to be incremented by  one. Old count: " + testUtils_ratingsAPI.runningForumCount + " new count: " + newForumcount
                    );

                testUtils_ratingsAPI.runningForumCount = newForumcount;
            }
             */
            if (expectedCode != HttpStatusCode.OK) {
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
            //int newForumcount = 0;

            string id = "";
            string title = "";
            string parentUri = ""; // not actually going to do anything with these, but need to give them the postXML
            string mimeType = "application/x-www-form-urlencoded";

            string url = String.Format("http://{0}/dna/{1}{2}/{3}",
                testUtils_ratingsAPI.server,
                testUtils_ratingsAPI._resourceLocation,
                testUtils_ratingsAPI.sitename,
                testUtils_ratingsAPI._formPostUrlPart);

            string postData = testUtils_ratingsAPI.makeCreatePostJSON_minimal(ref id, ref title, ref parentUri); // make some unique data for the new forum

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
            /*
            if (expectedCode == HttpStatusCode.OK)
            {
                newForumcount = testUtils_ratingsAPI.countForums(testUtils_ratingsAPI.sitename);

                Assert.IsTrue(
                    newForumcount == (testUtils_ratingsAPI.runningForumCount + 1),
                    "expected the forum count to be incremented by  one. Old count: " + testUtils_ratingsAPI.runningForumCount + " new count: " + newForumcount
                    );

                testUtils_ratingsAPI.runningForumCount = newForumcount;
            }
             */
            if (expectedCode != HttpStatusCode.OK)
            {
                // given that all of these are asking for XML, this can be used on them all
                XmlDocument xml = myRequest.GetLastResponseAsXML();

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaError);
                validator.Validate();
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

            // testUtils_ratingsAPI.runningForumCount = testUtils_ratingsAPI.countForums(testUtils_ratingsAPI.sitename);
        }

    
    } // ends class
} // ends namespace
