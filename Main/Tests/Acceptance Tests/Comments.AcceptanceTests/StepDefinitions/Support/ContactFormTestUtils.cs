using Tests;

namespace Comments.AcceptanceTests.Support
{
    public class ContactFormTestUtils : APIRequester
    {
        public static string CallCreateContactFormAPIRequest(DnaTestURLRequest request, string sitename, string postData, DnaTestURLRequest.usertype userType)
        {
            string requestURL = DnaTestURLRequest.CurrentServer.AbsoluteUri + "dna/api/comments/ContactFormService.svc/V1/site/" + sitename + "/";
            return CallAPIRequest(request, requestURL, postData, userType, "POST");
        }

        public static string CallCreateContactDetailAPIRequest(DnaTestURLRequest request, string sitename, string contactFormId, string postData, DnaTestURLRequest.usertype userType)
        {
            string requestURL = DnaTestURLRequest.CurrentServer.AbsoluteUri + "dna/api/comments/ContactFormService.svc/V1/site/" + sitename + "/contactform/" + contactFormId + "/";
            return CallAPIRequest(request, requestURL, postData, userType, "POST");
        }

        public static string CallGetCommentsForCommentForum(DnaTestURLRequest request, string sitename, string contactFormId)
        {
            string requestURL = DnaTestURLRequest.CurrentServer.AbsoluteUri + "dna/api/comments/CommentsService.svc/V1/site/" + sitename + "/commentsforums/" + contactFormId + "/";
            return CallAPIRequest(request, requestURL, null, DnaTestURLRequest.usertype.NOTLOGGEDIN, "GET");
        }

        public static string CallCommentForumList(DnaTestURLRequest request, string sitename, string contactFormID, string additionalParams)
        {
            string requestURL = DnaTestURLRequest.SecureServerAddress.AbsoluteUri + "dna/" + sitename + "/commentsforumlist/?s_siteid=1" + additionalParams;
            request.SetCurrentUserEditor();
            request.AssertWebRequestFailure = false;
            request.RequestSecurePage(requestURL);
            return requestURL;
        }
    }
}
