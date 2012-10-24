using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Tests;
using BBC.Dna.Api;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Net;

namespace Comments.AcceptanceTests.Support
{
    public class APIRequester
    {
        protected static string CallPOSTAPIRequest(DnaTestURLRequest request, string requestURL, string postData, DnaTestURLRequest.usertype userType)
        {
            return CallAPIRequest(request, requestURL, postData, userType, "POST");
        }

        protected static string CallGETAPIRequest(DnaTestURLRequest request, string requestURL, string postData, DnaTestURLRequest.usertype userType)
        {
            return CallAPIRequest(request, requestURL, postData, userType, "GET");
        }

        protected static string CallPUTAPIRequest(DnaTestURLRequest request, string requestURL, string postData, DnaTestURLRequest.usertype userType)
        {
            return CallAPIRequest(request, requestURL, postData, userType, "PUT");
        }

        protected static string CallAPIRequest(DnaTestURLRequest request, string requestURL, string postData, DnaTestURLRequest.usertype userType, string requestMethod)
        {
            if (userType == DnaTestURLRequest.usertype.SUPERUSER)
            {
                request.SetCurrentUserSuperUser();
            } 
            else if (userType == DnaTestURLRequest.usertype.EDITOR)
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
            request.RequestPageWithFullURL(requestURL, postData, "application/json", requestMethod);
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
