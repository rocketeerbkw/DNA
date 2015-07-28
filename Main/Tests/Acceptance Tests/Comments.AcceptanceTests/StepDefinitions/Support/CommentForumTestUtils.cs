using BBC.Dna.Api;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading;
using TechTalk.SpecFlow;
using Tests;

namespace Comments.AcceptanceTests.Support
{
    public class CommentForumTestUtils : APIRequester
    {
        public static string CallPUTCreateCommentAPIRequest(DnaTestURLRequest request, string sitename, string commentForumUID, string postData, DnaTestURLRequest.usertype userType)
        {
            string requestURL = DnaTestURLRequest.CurrentServer.AbsoluteUri + "dna/api/comments/CommentsService.svc/V1/site/" + sitename + "/commentsforums/" + commentForumUID + "/";
            return CallAPIRequest(request, requestURL, postData, userType, "PUT");
        }

        public static string CallGETCommentForumAPIRequest(DnaTestURLRequest request, string sitename, string commentForumUID)
        {
            string requestURL = DnaTestURLRequest.CurrentServer.AbsoluteUri + "dna/api/comments/CommentsService.svc/V1/site/" + sitename + "/commentsforums/" + commentForumUID + "/";
            return CallAPIRequest(request, requestURL, "", DnaTestURLRequest.usertype.NOTLOGGEDIN, "GET");
        }

        public static string CallCommentForumList(DnaTestURLRequest request, string additionalParams)
        {
            string requestURL = "admin/commentsforumlist?s_siteid=1" + additionalParams;
            request.SetCurrentUserEditor();
            request.AssertWebRequestFailure = false;
            request.RequestSecurePage(requestURL);
            return requestURL;
        }

        /// <summary>
        /// Serialise and converts to string
        /// </summary>
        /// <param name="obj">Object to convert to json string</param>
        /// <returns>JSON String representation of object</returns>
        public static string SerializeToJsonString(object obj)
        {
            string jsonStirng = "";
            using (MemoryStream ms = new MemoryStream())
            {
                DataContractJsonSerializer ser = new DataContractJsonSerializer(obj.GetType());
                ser.WriteObject(ms, obj);
                ms.Seek(0, SeekOrigin.Begin);
                jsonStirng = Encoding.UTF8.GetString(ms.ToArray());
            }
            return jsonStirng;
        }

        public static CommentForum CreateCommentforumToPost(bool allowAnonymousPosting, string title, string id, string text, string parentUri, string userName)
        {
            CommentForum postDataForum = new CommentForum();
            postDataForum.ParentUri = parentUri;
            postDataForum.Title = title;
            postDataForum.Id = id;
            postDataForum.allowNotSignedInCommenting = allowAnonymousPosting;
            postDataForum.commentList = new CommentsList();
            postDataForum.commentList.comments = new List<CommentInfo>();
            CommentInfo testCommentInfo = new CommentInfo();
            testCommentInfo.text = text;
            testCommentInfo.User.DisplayName = userName;
            postDataForum.commentList.comments.Add(testCommentInfo);
            return postDataForum;
        }

        public static void SetSiteOptionForAnonymousPosting(DnaTestURLRequest request, bool allow)
        {
            request.SetCurrentUserSuperUser();
            string requestURL = "SiteOptions?siteid=1&so_1_CommentForum_AllowNotSignedInCommenting=1&sov_1_CommentForum_AllowNotSignedInCommenting=";
            requestURL += allow ? "1" : "0";
            requestURL += "&cmd=update&skin=purexml";
            request.RequestSecurePage(requestURL);
            Thread.Sleep(3000);
        }

        public static void CreateTestCommentForum(DnaTestURLRequest request, bool allowAnonymousPosting, string title, string id)
        {
            SetSiteOptionForAnonymousPosting(request, allowAnonymousPosting);

            string text = "Lets Start this test with " + DateTime.Now.Ticks;
            string parentUri = "http://local.bbc.co.uk/dna/h2g2";

            CommentForum postDataForum = CreateCommentforumToPost(allowAnonymousPosting, title, id, text, parentUri, "First Poster");
            TestRunnerManager.GetTestRunner().ScenarioContext.Add("CreateTestCommentForum.newCommentForum", postDataForum);

            try
            {
                string jsonPostData = SerializeToJsonString(postDataForum);
                CommentForumTestUtils.CallPUTCreateCommentAPIRequest(request, "h2g2", id, jsonPostData, DnaTestURLRequest.usertype.NOTLOGGEDIN);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                if (allowAnonymousPosting)
                {
                    Console.WriteLine(ex.StackTrace);
                    throw ex;
                }
            }
        }

        public static void CheckCommentIsOrIsNotInTheCommentList(DnaTestURLRequest request, bool isInList, string textToCheck, CommentForum commentForum)
        {
            CallGETCommentForumAPIRequest(request, "h2g2", commentForum.Id);
            var currentCommentForum = (CommentForum)request.GetLastResponseAsJSONObject(typeof(CommentForum));
            bool match = false;
            Console.WriteLine("Text just posted : " + textToCheck);
            foreach (CommentInfo comment in currentCommentForum.commentList.comments)
            {
                match |= textToCheck.CompareTo(comment.text) == 0;
                Console.WriteLine("Comment in list : " + comment.text);
            }

            Console.WriteLine("Post found in comment list : " + match);

            if (isInList)
            {
                Assert.IsTrue(match);
            }
            else
            {
                Assert.IsFalse(match);
            }
        }
    }
}
