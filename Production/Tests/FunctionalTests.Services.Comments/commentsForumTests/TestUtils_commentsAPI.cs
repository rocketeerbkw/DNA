using System;
using System.Net;
using System.Web;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Testing the creation of comments forums via the Comments API
    /// This set of tests check what happens with different types of user - normal people should not be able to create them
    /// In all cases, use the basic minimum of data
    /// </summary>
    
    public class testUtils_CommentsAPI
    {
        
        public const string _schemaCommentForumList = "Dna.Services\\commentForumList.xsd";
        public const string _schemaCommentForum = "Dna.Services\\commentForum.xsd";
        public const string _schemaCommentsList = "Dna.Services\\commentsList.xsd";
        public const string _schemaComment = "Dna.Services\\comment.xsd";
        public const string _schemaError = "Dna.Services\\error.xsd";

        public const string _resourceLocation = "/dna/api/comments/CommentsService.svc/v1/";
        public static string server = DnaTestURLRequest.CurrentServer;
        public static string secureServer = DnaTestURLRequest.SecureServerAddress;
        public static string sitename = "h2g2";

        public static int runningForumCount = 0; // used to see our starting count, before we start adding forums.

        /// <summary>
        /// Simply count the number of commentsForums that have been created so far on this site
        /// </summary>
        /// <param name="SiteName">the name of the sute to query</param>
        /// <returns>teh count</returns>
        public static int countForums(string SiteName)
        {
            string _server = DnaTestURLRequest.CurrentServer;

            DnaTestURLRequest request = new DnaTestURLRequest(SiteName);

            request.SetCurrentUserNormal();

            // Setup the request url
            string url = "http://" + _server + "/dna/api/comments/CommentsService.svc/v1/site/" + SiteName + "/";

            // now get the response - no POST data, nor any clue about the input mime-type
            request.RequestPageWithFullURL(url, "", "");

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);

            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaCommentForumList);
            validator.Validate();

            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList != null);

            return returnedList.TotalCount;
        }


        /// <summary>
        /// Make up some unique post data
        /// </summary>
        /// <returns>a string which is XML post data</returns>
        public static string makePostXml(ref string id, ref string title, ref string parentUri)
        {
            DateTime dt = DateTime.Now;
            String TimeStamp = makeTimeStamp();

            if( id == "")
                id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString(); // the tail bit creates an unique string

            if (title == "")
                title = "Functiontest Title " + TimeStamp;

            if (parentUri == "")
                parentUri = "http://www.bbc.co.uk/dna/" + TimeStamp + "/";
            
            string postXML = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</commentForum>",
                id, title, parentUri);

            return postXML;
        }

        /// <summary>
        /// Make the POST data as JSON
        /// </summary>
        public static string makePostJSON(ref string id, ref string title, ref string parentUri)
        {
            DateTime dt = DateTime.Now;
            String TimeStamp = makeTimeStamp();

            if (id == "")
                id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString(); // the tail bit creates an unique string

            if (title == "")
                title = "Functiontest Title " + TimeStamp;

            if (parentUri == "")
                parentUri = "http://www.bbc.co.uk/dna/" + TimeStamp + "/";

            string postData = String.Format(@"{{""id"":""{0}"",""title"":""{1}"",""parentUri"":""{2}""}}",
                id, title, parentUri
                //HttpUtility.UrlEncode(id), HttpUtility.UrlEncode(title), HttpUtility.UrlEncode(parentUri)
                );

            return postData;
        }

        /// <summary>
        /// Make the POST data as JSON
        /// </summary>
        public static string makePostHtml(ref string id, ref string title, ref string parentUri)
        {
            DateTime dt = DateTime.Now;
            String TimeStamp = makeTimeStamp();

            if (id == "")
                id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString(); // the tail bit creates an unique string

            if (title == "")
                title = "Functiontest Title " + TimeStamp;

            if (parentUri == "")
                parentUri = "http://www.bbc.co.uk/dna/" + TimeStamp + "/";

            string postData = String.Format(@"""id""=""{0}""&""title""=""{1}""&""parentUri""=""{2}""",
                id, title, parentUri
                //HttpUtility.UrlEncode(id), HttpUtility.UrlEncode(title), HttpUtility.UrlEncode(parentUri)
                );

            return postData;
        }

        public static string makeCommentPostXML()
        {
            Random ranGen = new Random();
            string raw = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla adipiscing rutrum nunc a blandit. Etiam at odio vel purus malesuada gravida. Integer sapien erat, mattis eget vestibulum vitae, tincidunt eget mi. Suspendisse luctus, nisl vitae consectetur vulputate, odio mauris convallis erat, in vestibulum purus nunc nec nisi. Curabitur tellus ipsum, laoreet blandit aliquet at, tincidunt ac urna. Sed sed metus eget nibh dignissim blandit in nec neque. Donec justo ligula, consequat vel tincidunt nec, consequat in nibh. Proin mattis sapien porta nunc sagittis mattis. Nullam bibendum dapibus velit, a luctus purus dictum a. Sed a nisl non leo euismod gravida.";
            int startInex = ranGen.Next(0, raw.Length/2);
            int len = ranGen.Next(10, (raw.Length/2) - 1);

            string postXML = String.Format(
                "<comment xmlns=\"BBC.Dna.Api\"><text>{0}</text></comment>",
                raw.Substring(startInex, len)
                );

            return postXML;
        }

        /// <summary>
        /// helper for making unique strings
        /// </summary>
        /// <returns></returns>
        public static string makeTimeStamp()
        {
            DateTime dt = DateTime.Now;
            String TimeStamp = dt.ToString("ddddyyyyMMMMddHHmmssfffffff");

            return TimeStamp;
        }

        /// <summary>
        /// Create a test comment forum on the globally listed site
        /// Updates the global testUtils_CommentsAPI.runningForumCount
        /// Does not return if it fails
        /// </summary>
        public static string makeTestCommentForum()
        {
            int newForumcount;

            string id = "";
            string title = "";
            string parentUri = ""; // not actually going to do anything with these, but need to give them the postXML

            string url = "http://" + testUtils_CommentsAPI.server + testUtils_CommentsAPI._resourceLocation + "/site/" +testUtils_CommentsAPI.sitename + "/";

            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri); // make some unique data for the new forum

            DnaTestURLRequest myRequest = new DnaTestURLRequest(sitename);
            myRequest.UseIdentitySignIn = true;

            testUtils_CommentsAPI.runningForumCount = testUtils_CommentsAPI.countForums(sitename);
            myRequest.SetCurrentUserEditor();

            try
            {
                myRequest.RequestPageWithFullURL(url, postXML, "text/xml");
            }
            catch
            {
                // Don't loose control
            }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed making test comments forum. Got: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription + "\n" + url
                );

            newForumcount = testUtils_CommentsAPI.countForums(sitename);

            Assert.IsTrue(
                newForumcount == (testUtils_CommentsAPI.runningForumCount + 1),
                "Expected the forum count to be incremented by  one. Old count: " + testUtils_CommentsAPI.runningForumCount + " new count: " + newForumcount
                );

            runningForumCount = newForumcount;

            BBC.Dna.Api.CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == id);

            return id;
            }

        /// <summary>
        /// Assumes that the name that it has been given is the name of a good comments forum
        /// Creates a comment with some random text
        /// </summary>
        /// <param name="forumName">Name of the foum upon which to hang the new comment</param>
        /// <returns></returns>
        public static string makeTestComment(string forumName)
        {
            string postData = makeCommentPostXML();
            string url = String.Format("https://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/",
                testUtils_CommentsAPI.secureServer, testUtils_CommentsAPI.sitename, forumName);
            
            DnaTestURLRequest myRequest = new DnaTestURLRequest(sitename);
            myRequest.SetCurrentUserNormal();
            myRequest.UseIdentitySignIn = true;

            myRequest.RequestPageWithFullURL(url, postData, "text/xml");

            XmlDocument xml = myRequest.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaComment);
            validator.Validate();

            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(CommentInfo));
            /*
            Assert.IsTrue(returnedComment.text == text);
            Assert.IsNotNull(returnedComment.User);
             * */
            Assert.IsTrue(returnedComment.User.UserId == myRequest.CurrentUserID);

            return (returnedComment.ID).ToString();
        }
    } // ends class
} // ends namespace
