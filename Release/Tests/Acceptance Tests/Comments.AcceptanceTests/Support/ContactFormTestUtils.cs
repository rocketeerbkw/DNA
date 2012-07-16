using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Api;

namespace Comments.AcceptanceTests.Support
{
    public class ContactFormTestUtils
    {
        public static string CallCreateContactFormAPIRequest(DnaTestURLRequest request, string sitename, string postData, DnaTestURLRequest.usertype userType)
        {
            string requestURL = "http://" + DnaTestURLRequest.CurrentServer + "/dna/api/comments/ContactFormService.svc/V1/site/" + sitename + "/";
            return CallAPIRequest(request, requestURL, postData, userType);
        }

        public static string CallCreateContactDetailAPIRequest(DnaTestURLRequest request, string sitename, string contactFormId, string postData, DnaTestURLRequest.usertype userType)
        {
            string requestURL = "http://" + DnaTestURLRequest.CurrentServer + "/dna/api/comments/ContactFormService.svc/V1/site/" + sitename + "/contactform/" + contactFormId + "/";
            return CallAPIRequest(request, requestURL, postData, userType);
        }

        public static string CallGetCommentsForCommentForum(DnaTestURLRequest request, string sitename, string contactFormId)
        {
            string requestURL = "http://" + DnaTestURLRequest.CurrentServer + "/dna/api/comments/CommentsService.svc/V1/site/" + sitename + "/commentsforums/" + contactFormId + "/";
            return CallAPIRequest(request, requestURL, null, DnaTestURLRequest.usertype.NOTLOGGEDIN);
        }

        public static string CallCommentForumList(DnaTestURLRequest request, string sitename, string contactFormID, string additionalParams)
        {
            string requestURL = "https://" + DnaTestURLRequest.CurrentServer + "/dna/" + sitename + "/commentsforumlist/?s_siteid=1" + additionalParams;
            request.SetCurrentUserEditor();
            request.AssertWebRequestFailure = false;
            request.RequestSecurePage(requestURL);
            return requestURL;
        }

        private static string CallAPIRequest(DnaTestURLRequest request, string requestURL, string postData, DnaTestURLRequest.usertype userType)
        {
            if (userType == DnaTestURLRequest.usertype.EDITOR)
            {
                request.SetCurrentUserEditor();
            }
            else if (userType == DnaTestURLRequest.usertype.NORMALUSER)
            {
                request.SetCurrentUserNormal();
            }
            else
            {
                request.SetCurrentUserNotLoggedInUser();
            }

            request.AssertWebRequestFailure = false;
            request.RequestPageWithFullURL(requestURL, postData, "application/json");
            return requestURL;
        }

        public static void AssertResponseContainsGivenErrorTypeDetailAndCode(string response, ErrorType errorType)
        {
            ApiException ex = ApiException.GetError(errorType);
            string errorDetail = "\"detail\":\"" + ex.Message + "\"";
            string errorCode = "\"code\":\"" + ex.type.ToString() + "\"";
        }

        public static void AssertOutputContains(string output, string expected)
        {
            if (!output.Contains(expected))
            {
                Assert.Fail("Failed to find expected:[" + expected + "] within output:[" + output + "]");
            }
        }

        public static string AddFirstJSONData(string key, string value)
        {
            return "{" + AddJSONData(key, value);
        }

        public static string AddLastJSONData(string key, string value)
        {
            return AddJSONData(key, value).TrimEnd(',') + "}";
        }

        public static string AddJSONData(string key, string value)
        {
            return "\"" + key + "\":\"" + value + "\",";
        }
    }
}
