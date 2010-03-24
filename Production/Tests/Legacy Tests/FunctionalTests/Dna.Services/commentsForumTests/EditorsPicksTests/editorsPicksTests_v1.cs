using System;
using System.Collections.Generic;
using System.Net;
using System.Xml;
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
    public class editorsPicksTests_V1
    {
        
        /// <summary>
        /// Test that an editors pick may be created.
        /// </summary>
        [TestMethod]
        public void CreateAs_Editor()
        {
            string forumId   = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);
            BBC.Dna.Api.CommentForum returnedForum = null;

            markComment(commentID); // this will crash if it fails
            // succesful creation returns no response data, just the status

            returnedForum = readForum(forumId); // this will crash if it can't list them
        }

        /// <summary>
        /// Repeated attempts to pick the same thing should succeed.
        /// </summary>
        [TestMethod]
        public void CreateAs_Editor_twice()
        {
            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);
            BBC.Dna.Api.CommentForum returnedForum = null;

            markComment(commentID);

            returnedForum = readForum(forumId); // crash if it does not get the list OK

            // try and mark it a second time
            markComment(commentID);

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
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/comments/{2}/editorpicks/",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, commentID
                );
            string postData = testUtils_CommentsAPI.makeTimeStamp(); // give it some sort of psot so that it uses POST, also see if it is interested in the POST data

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
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaError);
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
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/comments/{2}/editorpicks/",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, commentID
                );
            string postData = testUtils_CommentsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

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
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaError);
            myValidator.Validate();
        }

        /// <summary>
        /// Not sure if superusers should be able to make picks, but they can
        /// </summary>
        [TestMethod]
        public void CreateAs_SuperUser()
        {
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/comments/{2}/editorpicks/",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, commentID
                );
            string postData = testUtils_CommentsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

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
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/comments/{2}/editorpicks/",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, commentID
                );
            string postData = testUtils_CommentsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

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
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaError);
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
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId   = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            markComment(commentID);

            // now read it
            myRequest.SetCurrentUserNormal();

            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/?filterBy=EditorPicks",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, forumId
                );
            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
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
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            markComment(commentID);

            myRequest.SetCurrentUserBanned();

            // now read it
            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/?filterBy=EditorPicks",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, forumId
                );
            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
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
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            markComment(commentID);

            myRequest.SetCurrentUserPreModUser();

            // now read it
            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/?filterBy=EditorPicks",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, forumId
                );
            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
            myValidator.Validate();
        }

        /// <summary>
        /// The writes above have used reads to check that somehting was actaully done. So,
        /// Create a lot of comments, mark some as editor's picks and then get them out
        /// </summary>
        [TestMethod]
        public void ReadAs_notLoggedIn_someInMany()
        {
            XmlDocument xml;
            DnaXmlValidator myValidator;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            Random randomGen = new Random();
            int listLen = randomGen.Next(10, 20);
            int index1 = randomGen.Next(0, 3);
            int index2 = randomGen.Next(4, 6);
            int index3 = randomGen.Next(7, listLen);

            string[] commentArray;
            List<string> commentList = new List<string>();

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();

            for( int i = 0; i < listLen; i++){
                commentList.Add(testUtils_CommentsAPI.makeTestComment(forumId));
            }

            commentArray = commentList.ToArray();

            markComment(commentArray[index1]);
            markComment(commentArray[index2]);
            markComment(commentArray[index3]);

            // now read the list of editor's picks
            myRequest.SetCurrentUserNotLoggedInUser();

            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/?filterBy=EditorPicks",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, forumId
                );
            try
            {
                myRequest.RequestPageWithFullURL(url);
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed listing editor's picks. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            xml = myRequest.GetLastResponseAsXML();
            myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
            myValidator.Validate();

            BBC.Dna.Api.CommentForum returnedForum =
                (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));

            Assert.IsTrue(returnedForum.commentList.TotalCount == 3);

            // the default sort is by creation date and the marking should be in order down this list
            Assert.IsTrue(returnedForum.commentList.comments[0].ID.ToString() == commentArray[index1], "First item does not match");
            Assert.IsTrue(returnedForum.commentList.comments[1].ID.ToString() == commentArray[index2], "Second item does not match");
            Assert.IsTrue(returnedForum.commentList.comments[2].ID.ToString() == commentArray[index3], "Third item does not match");
        }

        //***********************************************************************************
        /// <summary>
        /// Test that an editor may un-pick a comment.
        /// </summary>
        [TestMethod]
        public void RemoveAs_Editor()
        {
            BBC.Dna.Api.CommentForum returnedForum = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId   = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            // mark this comment as an editor's pick (this will crash if it fails)
            markComment(commentID);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.commentList.TotalCount == 1, "should have I forum on this site, but have " + returnedForum.commentList.TotalCount);

            // now unmark it
            clearMark(commentID);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "should have no fora on this site, but have " + returnedForum.commentList.TotalCount);
        }

        /// <summary>
        /// Repeated attempts to un-pick something twice - should not fail
        /// This also should cover the case of tying to un-pick a not-picked comment
        /// </summary>
        [TestMethod]
        public void RemoveAs_Editor_twice()
        {
            BBC.Dna.Api.CommentForum returnedForum = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            // mark this comment as an editor's pick (this will crash if it fails)
            markComment(commentID);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.commentList.TotalCount == 1, "should have one forum on this site, but have " + returnedForum.commentList.TotalCount);

            // now unmark it
            clearMark(commentID);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "should have no fora on this site, but have " + returnedForum.commentList.TotalCount);

            // now unmark it a second time
            clearMark(commentID);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "should have no fora on this site, but have " + returnedForum.commentList.TotalCount);
        }

        /// <summary>
        /// Test that a not-logged-in user can't unpick
        /// </summary>
        [TestMethod]
        public void RemoveAs_notLoggedIn()
        {
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            BBC.Dna.Api.CommentForum returnedForum = null;

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);
            string url = "";

            // mark this comment as an editor's pick (this will crash if it fails)
            markComment(commentID);

            returnedForum = readForum(forumId);

            // assume complete succes, don't keep cheking it
            // Now try to unmark it - can't use helper becuse it is designed to succeed

            url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/comments/{2}/editorpicks/",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, commentID
                );
            string postData = testUtils_CommentsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

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
        /// </summary>
        [TestMethod]
        public void RemoveAs_Editor_OneFromMany()
        {
            BBC.Dna.Api.CommentForum returnedForum = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            Random randomGen = new Random();
            int listLen = randomGen.Next(100, 200);
            int index1 = randomGen.Next(0, 33);
            int index2 = randomGen.Next(34, 66);
            int index3 = randomGen.Next(67, listLen);

            string[] commentArray;
            List<string> commentList = new List<string>();

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();

            for( int i = 0; i < listLen; i++){
                commentList.Add(testUtils_CommentsAPI.makeTestComment(forumId));
            }

            commentArray = commentList.ToArray();

            markComment(commentArray[index1]);
            markComment(commentArray[index2]);
            markComment(commentArray[index3]);

            clearMark(commentArray[index2]);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.commentList.TotalCount == 2, "should have 2 fora on this site, but have " + returnedForum.commentList.TotalCount);

            // the default sort is by creation date and the marking should be in order down this list
            Assert.IsTrue(returnedForum.commentList.comments[0].ID.ToString() == commentArray[index1], "first survivor is not the right one, it's ID is " + returnedForum.commentList.comments[0].ID.ToString());
            Assert.IsTrue(returnedForum.commentList.comments[1].ID.ToString() == commentArray[index3], "second survivor is not the right one, it's ID is " + returnedForum.commentList.comments[0].ID.ToString());
        }

        /// <summary>
        /// Test that an editor may un-pick a comment.
        /// </summary>
        [TestMethod]
        public void RemoveAs_Superuser()
        {
            BBC.Dna.Api.CommentForum returnedForum = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string forumId = testUtils_CommentsAPI.makeTestCommentForum();
            string commentID = testUtils_CommentsAPI.makeTestComment(forumId);

            // mark this comment as an editor's pick (this will crash if it fails)
            markComment(commentID);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.commentList.TotalCount == 1, "should have I forum on this site, but have " + returnedForum.commentList.TotalCount);

            // now unmark it
            //clearMark(commentID);

            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/comments/{2}/editorpicks/",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, commentID
                );
            string postData = testUtils_CommentsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            myRequest.SetCurrentUserSuperUser();

            try
            {
                myRequest.RequestPageWithFullURL(url, String.Empty, String.Empty, "DELETE");
            }
            catch { }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed to clear an editor's pick. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription);

            returnedForum = readForum(forumId);

            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "should have no fora on this site, but have " + returnedForum.commentList.TotalCount);
        }


        //***********************************************************************************
        /// <summary>
        /// Helper to mark a comment as an editor's pick
        /// </summary>
        /// <param name="commentID">The ID (number) of the comment to pick</param>
        private void markComment(string commentID)
        {
            string response = "";
            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/comments/{2}/editorpicks/",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, commentID
                );
            string postData = testUtils_CommentsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

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
        /// <param name="commentID">it ID (number) of the comment to be unpicked</param>
        private void clearMark(string commentID)
        {
            string response = "";
            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/comments/{2}/editorpicks/",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, commentID
                );
            string postData = testUtils_CommentsAPI.makeTimeStamp(); // needs some sort of post data otherwise it uses GET

            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

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
        private BBC.Dna.Api.CommentForum readForum(string forumID)
        {
            string response = "";
            XmlDocument xml = null;
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            string url = String.Format(
                "http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/?filterBy=EditorPicks",
                testUtils_CommentsAPI.server, testUtils_CommentsAPI.sitename, forumID
                );

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
            DnaXmlValidator myValidator = new DnaXmlValidator(xml.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
            myValidator.Validate();

            BBC.Dna.Api.CommentForum returnedForum =
                (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));

            return returnedForum;

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