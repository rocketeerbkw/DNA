using System;
using System.Net;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of comments via the Comments API
    /// </summary>
    [TestClass]
    public class missingData
    {

        // ===================================================================================================
        // Test by building up the information that is sent into the request, from nothing. 
        // As more is added, ring the changes to see what causes failures
        // Start by using the editor user to ensure that that is not the sticking point
        // ===================================================================================================

        /// <summary>
        /// Have found that missing the trailing slash can sometimes cause an un-catered-for exception, try it here
        /// It should succeed and create a comment.
        /// </summary>
        [TestMethod]
        // mising the trailing / cause an exception 
        // "Web request ( http://dnadev.national.core.bbc.co.uk:8082/comments/commentsService.svc/v1/site/h2g2/commentsforums/FunctiontestCommentForum-e0d90d33-b3fe-4286-bfcb-5da2feafe9fa ) failed with error : The underlying connection was closed: An unexpected error occurred on a receive."
        // this happens before the request.CurrentWebResponse is given contents (so it stays null)
        public void missTrailingSlash()
        {
            Console.WriteLine("Before missingData - missTrailingSlash");

            // working data
            string testForumId = testUtils_CommentsAPI.makeTestCommentForum();
            DnaTestURLRequest request = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            // fixed input data
            string mimeType = "text/xml";
            string postData = testUtils_CommentsAPI.makeCommentPostXML();

            // test variant data
            string url = String.Format("http://{0}{1}site/{2}/commentsforums/{3}",
                testUtils_CommentsAPI.server,
                testUtils_CommentsAPI._resourceLocation,
                testUtils_CommentsAPI.sitename,
                testForumId
                );

            request.SetCurrentUserEditor();

            // Now try and create the comment
            bool assertThrown = false;
            try
            {
                request.RequestPageWithFullURL(url, postData, mimeType);
            }
            catch
            {
                assertThrown = true;
            }

            Assert.IsTrue(assertThrown);

            Console.WriteLine("After missingData - missTrailingSlash");
        } 

    } // ends class
} // ends namespace
