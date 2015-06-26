using System;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of comments forums via the Comments API
    /// The ID of the forum must be unique within a Site
    /// Generally, the other data are such that the forum should be created - e.g. the user is an editor
    /// </summary>
    [TestClass]
    public class uniqueId
    {
        // Curently, the ID is the importan datum. If a second call comes in with an exsiting ID (within a site), the previously created on will be returned
        // irrespective of the new title and parentURI

        /// <summary>
        /// Check that a forum can be created, then check that that ID can not be used a second time
        /// </summary>
        [TestMethod]
        public void repeatCreateForum()
        {
            Console.WriteLine("Before uniqueId - repeatCreateForum");
            
            // test variant data
            string sharedId = "";
            string sharedIdRemembered = "";

            // these will come out of the call to createForum so that they can be used in the checking
            string title1 = "";
            string title2 = "test2";
            string parentUri1 = "";
            string parentUri2 = "url2";

            // working data
            int newSiteCount = 0;
            DnaTestURLRequest theRequest = null;
            XmlDocument xmlOut = null;
            DnaXmlValidator validator = null;
            BBC.Dna.Api.CommentForum returnedForum = null;

            // first time around, expect to be able to create the forum
            testUtils_CommentsAPI.runningForumCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename);

            theRequest = createForum(ref sharedId, ref title1, ref parentUri1);

            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename); // there should be 1 more forum

            Assert.IsTrue(newSiteCount == (testUtils_CommentsAPI.runningForumCount + 1));

            sharedIdRemembered = sharedId; // remember it because the next call to createForum may change it.

            testUtils_CommentsAPI.runningForumCount = newSiteCount;

            // second time around, 
            // expect this to fail because the ID is the same
            parentUri2 = parentUri1 + "2";
            theRequest = createForum(ref sharedId, ref title2, ref parentUri2);

            /*
             * this repeatedly times-out
            newSiteCount = testUtils_CommentsAPI.countForums(testUtils_CommentsAPI.sitename); // there should be 1 more forum

            Assert.IsTrue(newSiteCount == testUtils_CommentsAPI.runningForumCount);
            */

            // the response matches the schema
            xmlOut = theRequest.GetLastResponseAsXML(); // 1d. check the result of the creation process is good
            validator = new DnaXmlValidator(xmlOut.InnerXml, testUtils_CommentsAPI._schemaCommentForum);
            validator.Validate();

            // the returned forum should be the one that was initially created
            returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(theRequest.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == sharedIdRemembered, "The new forum's ID has chagned from " +sharedIdRemembered+" to " +returnedForum.Id);
            Assert.IsTrue(returnedForum.Title == title2, "The new forum's Title has cahgned from " +title1+ " to " +returnedForum.Title);
            Assert.IsTrue(returnedForum.ParentUri == parentUri2, "The new forum's ParentURI has changed from " +parentUri1+ " to " +returnedForum.ParentUri);
            Assert.IsTrue(returnedForum.commentList.TotalCount == 0, "The new forum's should have an empty commentList, it is not empty");
            
            Console.WriteLine("After uniqueId - repeatCreateForum");
        }

        //===================================================================================================================================
        /// <summary>
        /// To be called twice, on first time around, 
        ///  - it is not given an ID, so makes it up and returns that ID. 
        ///  - the creation is succesful
        ///  On the second time around, it is give the ID 
        ///  - it uses that ID
        ///  - it fails to create the ID
        /// </summary>
        /// <param name="ID">The ID that may come in, but is certainly put out</param>
        /// <returns>the request object after the call has been made</returns>
 
        private DnaTestURLRequest createForum(ref string id, ref string title, ref string parentUri)
        {
            // test variant data
            // string id

            // consistent data
            string formatParam = "XML";
            string mimeType = "text/XML"; // test variant
            string url = "http://" + testUtils_CommentsAPI.server + "/dna/api/comments/CommentsService.svc/v1/site/" + testUtils_CommentsAPI.sitename + "/"  + "?format=" + formatParam;
            string postData = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri);

            // working data
            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            myRequest.SetCurrentUserEditor();

            // make the request and don't loose control
            try
            {
                myRequest.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
            }

            return myRequest;
        }

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("completed createCommentForumTests_V1");
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
