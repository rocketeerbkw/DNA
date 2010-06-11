using System;
using System.Collections.Generic;
using System.Net;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Set of tests for the editors picks aspect of the comments API
    /// Most functionality 
    /// </summary>
    [TestClass]
    public class RatingsEditorsPicksTests_V1
    {
        
        /// <summary>
        /// Test that an editors pick may be created.
        /// </summary>
        [TestMethod]
        public void CreateAs_Editor()
        {
            string forumId   = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);
            BBC.Dna.Api.RatingForum returnedForum = null;

            markComment(ratingId); // this will crash if it fails
            // succesful creation returns no response data, just the status

            returnedForum = readForum(forumId); // this will crash if it can't list them
        }

        /// <summary>
        /// Repeated attempts to pick the same thing should succeed.
        /// </summary>
        [TestMethod]
        public void CreateAs_Editor_twice()
        {
            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);
            BBC.Dna.Api.RatingForum returnedForum = null;

            markComment(ratingId);

            returnedForum = readForum(forumId); // crash if it does not get the list OK

            // try and mark it a second time
            markComment(ratingId);

            returnedForum = readForum(forumId); // crash if it does not get the list OK
        }

        /// <summary>
        /// Expect this to fail
        /// manually make the request because the helpers are there to succeed
        /// </summary>
        [TestMethod]
        public void CreateAs_NormalUser()
        {
            XmlDocument xml;
            DnaXmlValidator myValidator;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            string url = makeCreatePickUrl(ratingId);
            string postData = testUtils_ratingsAPI.makeTimeStamp(); // give it some sort of psot so that it uses POST, also see if it is interested in the POST data

            // create the pick

            myRequest.SetCurrentUserNormal();

            try
            {
                myRequest.RequestPageWithFullURL(url, postData, "text/xml");
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized,
                "Should have been unauthorised. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaError);
            myValidator.Validate();
        }

        /// <summary>
        /// Expect this to fail - Notable users are ordinary users that do stuff?
        /// manually make the request because the helpers are there to succeed
        /// </summary>
        [TestMethod]
        public void CreateAs_NotableUser()
        {
            XmlDocument xml;
            DnaXmlValidator myValidator;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            string url = makeCreatePickUrl(ratingId);
            string postData = testUtils_ratingsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            myRequest.SetCurrentUserNotableUser();

            try
            {
                myRequest.RequestPageWithFullURL(url, postData, "text/xml");
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized,
                "Should have been unauthorised. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaError);
            myValidator.Validate();
        }

        /// <summary>
        /// Not sure if superusers should be able to make picks, but they can
        /// </summary>
        [TestMethod]
        public void CreateAs_SuperUser()
        {
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            string url = makeCreatePickUrl(ratingId);
            string postData = testUtils_ratingsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            myRequest.SetCurrentUserSuperUser();

            try
            {
                myRequest.RequestPageWithFullURL(url, postData, "text/xml");
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );
            // succesful creation returns no response data, just the status
        }
        
        /// <summary>
        /// Expect this to fail
        /// Using a different sort of user so can not use the markComment utility
        /// </summary>
        [TestMethod]
        public void CreateAs_BannedUser()
        {
            XmlDocument xml;
            DnaXmlValidator myValidator;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            string url = makeCreatePickUrl(ratingId);
            string postData = testUtils_ratingsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            myRequest.SetCurrentUserBanned();

            try
            {
                myRequest.RequestPageWithFullURL(url, postData, "text/xml");
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized,
                "Should have been unauthorised. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaError);
            myValidator.Validate();
        }

        //-------------------------------------------------------------------------------

        /// <summary>
        /// Test that an editor's pick can be read by a normal user
        /// manually make the request because the helpers are there to succeed
        /// </summary>
        [TestMethod]
        public void ReadAs_NormalUser()
        {
            XmlDocument xml; 
            DnaXmlValidator myValidator;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string forumId   = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            markComment(ratingId);

            // now read it
            myRequest.SetCurrentUserNormal();

            string url = makeReadPickUrl(forumId);

            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            myValidator.Validate();
        }

        /// <summary>
        /// Test that an editor's pick can be read by a banned user
        /// </summary>
        [TestMethod]
        public void ReadAs_BannedUser()
        {
            XmlDocument xml;
            DnaXmlValidator myValidator;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            string url = makeReadPickUrl(forumId);

            markComment(ratingId);

            myRequest.SetCurrentUserBanned();

            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            myValidator.Validate();
        }

        /// <summary>
        /// Test that an editor's pick can be read by a Pre-Mod user
        /// </summary>
        [TestMethod]
        public void ReadAs_PreModUser()
        {
            XmlDocument xml;
            DnaXmlValidator myValidator;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            string url = makeReadPickUrl(forumId);

            markComment(ratingId);

            myRequest.SetCurrentUserPreModUser();

            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            myValidator.Validate();
        }

        /// <summary>
        /// It is not easy to create a lot of reviews because we are only allowed 1 review/forum/user and only have a few logins available
        /// Create as many as we can and then mark a couple, get the marked ones and check that they are the ones we marked
        /// One, basic assumption is that they will be returned sorted, ascending on their ID
        /// </summary>
        [TestMethod]
        public void ReadAs_notLoggedIn_someInMany()
        {
            // chose some random numbers. Severly constrained by the smallnes of testUtils_ratingsAPI.maxNumDiffUsers
            Random randomGen = new Random();
            int index1 = randomGen.Next(0, 1);
            int index2 = randomGen.Next(2, 3);
            int index3 = randomGen.Next(4, 5);

            string[] commentArray;
            List<string> ratingList = new List<string>();

            // create the data
            // first the forum
            string forumId = testUtils_ratingsAPI.makeTestForum();

            // then a list of ratings
            for (int i = 0; i < testUtils_ratingsAPI.maxNumDiffUsers; i++)
            {
                ratingList.Add(testUtils_ratingsAPI.makeTestItem(forumId, i));
            }

            // convert it to an array so it is easier to deal with
            commentArray = ratingList.ToArray();

            // mark some
            markComment(commentArray[index1]);
            markComment(commentArray[index2]);
            markComment(commentArray[index3]);

            // read the list of editor's picks
            string url = makeReadPickUrl(forumId);
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            myRequest.SetCurrentUserNotLoggedInUser();

            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            DnaXmlValidator myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            myValidator.Validate();

            BBC.Dna.Api.RatingForum returnedForum =
                (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 3);

            // the default sort is by creation date and the marking should be in order down this list
            Assert.IsTrue(returnedForum.ratingsList.ratings[0].ID.ToString() == commentArray[index1], "First item does not match");
            Assert.IsTrue(returnedForum.ratingsList.ratings[1].ID.ToString() == commentArray[index2], "Second item does not match");
            Assert.IsTrue(returnedForum.ratingsList.ratings[2].ID.ToString() == commentArray[index3], "Third item does not match");
        }

        //***********************************************************************************
        /// <summary>
        /// Test that an editor may un-pick a comment.
        /// </summary>
        [TestMethod]
        public void RemoveAs_Editor()
        {
            BBC.Dna.Api.RatingForum returnedForum = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            myRequest.UseIdentitySignIn = true;

            string forumId   = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            // mark this comment as an editor's pick (this will crash if it fails)
            markComment(ratingId);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 1, "should have I forum on this site, but have " + returnedForum.ratingsList.TotalCount);

            // now unmark it
            clearMark(ratingId);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 0, "should have no fora on this site, but have " + returnedForum.ratingsList.TotalCount);
        }

        /// <summary>
        /// Repeated attempts to un-pick something twice - should not fail
        /// This also should cover the case of tying to un-pick a not-picked comment
        /// </summary>
        [TestMethod]
        public void RemoveAs_Editor_twice()
        {
            BBC.Dna.Api.RatingForum returnedForum = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            // mark this comment as an editor's pick (this will crash if it fails)
            markComment(ratingId);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 1, "should have one forum on this site, but have " + returnedForum.ratingsList.TotalCount);

            // now unmark it
            clearMark(ratingId);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 0, "should have no fora on this site, but have " + returnedForum.ratingsList.TotalCount);

            // now unmark it a second time
            clearMark(ratingId);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 0, "should have no fora on this site, but have " + returnedForum.ratingsList.TotalCount);
        }

        /// <summary>
        /// Test that a not-logged-in user can't unpick
        /// </summary>
        [TestMethod]
        public void RemoveAs_notLoggedIn()
        {
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            BBC.Dna.Api.RatingForum returnedForum = null;

            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            string url = makeCreatePickUrl(ratingId);

            // mark this comment as an editor's pick (this will crash if it fails)
            markComment(ratingId);

            returnedForum = readForum(forumId);
            // assume complete succes, don't keep cheking it
            // Now try to unmark it - can't use helper because it is designed to succeed

            string postData = testUtils_ratingsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            myRequest.SetCurrentUserNotLoggedInUser();

            try
            {
                myRequest.RequestPageWithFullURL(url, String.Empty, String.Empty, "DELETE");
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.Unauthorized,
                "Failed to clear an editor's pick. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription);
        }

        /// <summary>
        /// Test that the right ones will be unpicked form a bag.
        /// Again severely restricted by the fact that we have only a small numbers of users
        /// This could be greatly improved if the test data had a load of reviews already created. Maybe it will after a while
        /// One, basic assumption is that they will be returned sorted, ascending on their ID
        /// </summary>
        [TestMethod]
        public void RemoveAs_Editor_OneFromMany()
        {
            BBC.Dna.Api.RatingForum returnedForum = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            // chose some random numbers. Severly constrained by the smallnes of testUtils_ratingsAPI.maxNumDiffUsers
            Random randomGen = new Random();
            int index1 = randomGen.Next(0, 1);
            int index2 = randomGen.Next(2, 3);
            int index3 = randomGen.Next(4, 5);

            string[] commentArray;
            List<string> ratingList = new List<string>();

            // make the forum
            string forumId = testUtils_ratingsAPI.makeTestForum();

            // then a list of ratings
            for (int i = 0; i < testUtils_ratingsAPI.maxNumDiffUsers; i++)
            {
                ratingList.Add(testUtils_ratingsAPI.makeTestItem(forumId, i));
            }

            commentArray = ratingList.ToArray();

            // mark some
            markComment(commentArray[index1]);
            markComment(commentArray[index2]);
            markComment(commentArray[index3]);

            // Clear the middle one to suggest that it is not chopping from one end
            clearMark(commentArray[index2]);

            // see what we have left
            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 2, "should have 2 fora on this site, but have " + returnedForum.ratingsList.TotalCount);

            // the default sort is by creation date and the marking should be in order down this list
            Assert.IsTrue(returnedForum.ratingsList.ratings[0].ID.ToString() == commentArray[index1], "first survivor is not the right one, it's ID is " + returnedForum.ratingsList.ratings[0].ID.ToString());
            Assert.IsTrue(returnedForum.ratingsList.ratings[1].ID.ToString() == commentArray[index3], "second survivor is not the right one, it's ID is " + returnedForum.ratingsList.ratings[1].ID.ToString());
        }

        /// <summary>
        /// Test that an editor may un-pick a comment.
        /// </summary>
        [TestMethod]
        public void RemoveAs_Superuser()
        {
            string forumId = testUtils_ratingsAPI.makeTestForum();
            string ratingId = testUtils_ratingsAPI.makeTestItem(forumId);

            // mark this comment as an editor's pick (this will crash if it fails)
            markComment(ratingId);

            BBC.Dna.Api.RatingForum returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 1, "should have I forum on this site, but have " + returnedForum.ratingsList.TotalCount);

            //string postData = testUtils_ratingsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            string url = makeCreatePickUrl(ratingId);

            myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);
            myRequest.SetCurrentUserSuperUser();

            try
            {
                myRequest.RequestPageWithFullURL(url, String.Empty, String.Empty, "DELETE");
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed to clear an editor's pick. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.ratingsList.TotalCount == 0, "should have no fora on this site, but have " + returnedForum.ratingsList.TotalCount);
        }


        //***********************************************************************************
        /// <summary>
        /// Helper to mark a comment as an editor's pick
        /// </summary>
        /// <param name="ratingId">The ID (number) of the comment to pick</param>
        private void markComment(string ratingId)
        {
            string response = "";
            string url = makeCreatePickUrl(ratingId);

            string postData = testUtils_ratingsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            myRequest.SetCurrentUserEditor();

            try
            {
                //myRequest.RequestPageWithFullURL(url, String.Empty, String.Empty, "POST");
                myRequest.RequestPageWithFullURL(url, postData, "text/xml");
            }
            catch {
                response = myRequest.GetLastResponseAsString();
            }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed to make a comment as an editor's pick. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription + "\n" + response
                );
        }

        //--------------------------------------------------------------------------------------------------------
        /// <summary>
        /// Helper to remove editor's pick from a comment
        /// </summary>
        /// <param name="ratingId">it ID (number) of the comment to be unpicked</param>
        private void clearMark(string ratingId)
        {
            string response = "";
            string url = makeCreatePickUrl(ratingId);
            string postData = testUtils_ratingsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            myRequest.SetCurrentUserEditor();

            try
            {
                myRequest.RequestPageWithFullURL(url, String.Empty, String.Empty, "DELETE");
            }
            catch
            {
                response = myRequest.GetLastResponseAsString();
            }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed to clear an editor's pick. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription + "\n" + response
                );
        }

        /// <summary>
        /// Helper to get a list of editors picks in a forum
        /// </summary>
        /// <param name="forumID">the forum to list</param>
        /// <returns></returns>
        private BBC.Dna.Api.RatingForum readForum(string forumID)
        {
            string response = "";
            XmlDocument xml = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_ratingsAPI.sitename);

            string url = makeReadPickUrl(forumID);

            myRequest.SetCurrentUserNormal();

            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch {
                response = myRequest.GetLastResponseAsString();
            }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription  + "\n" + response
                );

            xml = myRequest.GetLastResponseAsXML();
            DnaXmlValidator myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_ratingsAPI._schemaRatingForum);
            myValidator.Validate();

            BBC.Dna.Api.RatingForum returnedForum =
                (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));

            return returnedForum;

        }

        /// <summary>
        /// build the URL needed to create an editor's pick
        /// </summary>
        /// <param name="ratingId">the review / rating to be marked</param>
        /// <returns>the URL</returns>
        public string makeCreatePickUrl(string ratingId)
        {
            return String.Format(
             "http://{0}/{1}/{2}/comments/{3}/editorpicks/",
             testUtils_ratingsAPI.server,
             testUtils_ratingsAPI._resourceLocation,
             testUtils_ratingsAPI.sitename,
             ratingId
             );
        }

        /// <summary>
        /// build the URL to get a list of editors' picks on a forum
        /// </summary>
        /// <param name="forumID">the forum to get a list off</param>
        /// <returns>the URL</returns>
        public string makeReadPickUrl(string forumID)
        {
            return testUtils_ratingsAPI.makeReadForumUrl(forumID) + "?filterBy=EditorPicks";
        }

        //***********************************************************************************
        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("Before editorsPicksTests_V1");

            SnapshotInitialisation.RestoreFromSnapshot();

        }

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After editorsPicksTests_V1");
        }

    }
}