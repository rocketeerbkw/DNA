using System;
using BBC.Dna.Api;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class CommentActivity : MarshalByRefObject, ISnesActivity
    {
        private static string addActivityTemplate =
            "{{\"title\":\"{0}\", \"body\":\"{1}\", \"url\":\"{2}\", \"postedTime\":\"{3}\", \"type\":\"{4}\", \"displayName\":\"{5}\", \"objectTitle\":\"{6}\", \"objectDescription\":\"{7}\", \"username\":\"{8}\", \"objectUri\":\"{9}\"}}";

        private static string titleTemplate =
            @"{0} a <a href= ""{1}"" > new comment </a> on the <a href = ""{2}"" > {3} </a>";

        private static UriTemplate postUserActivityTemplate =
            new UriTemplate("social/social/rest/activities/{userid}/@self/{applicationid}");

        public int ActivityId
        {
            get;
            set;
        }

        public string Application
        {
            get;
            set;
        }

        public string ActivityType
        {
            get;
            set;
        }

        public string Title
        {
            get;
            set;
        }

        public string Body
        {
            get;
            set;
        }

        public string Url
        {
            get;
            set;
        }

        public DateTime PostedTime
        {
            get;
            set;
        }

        public int IdentityUserId
        {
            get;
            set;
        }

        public string DisplayName
        {
            get;
            set;
        }

        public CommentActivity()
        {
        }

        public static ISnesActivity CreateActivity(int activityType, IDnaDataReader currentRow)
        {
            CommentActivity activity = PolicyInjection.Create<CommentActivity>();

            string activityUrl = string.Empty;
            string activityHostNameUrl = string.Empty;
            CreateActivityUrls(currentRow, out activityUrl, out activityHostNameUrl);

            string activityVerb = CommentActivity.GetActivityTypeVerb(activityType);
            activity.ActivityId = currentRow.GetInt32("EventID");
            activity.ActivityType = activityVerb;
            activity.Application = currentRow.GetString("AppId") ?? "";
            activity.Title = CommentActivity.CreateTitleString(currentRow, activityVerb, activityUrl, activityHostNameUrl);
            activity.Body = currentRow.GetString("Body") ?? "";
            activity.Url = activityUrl;
            activity.PostedTime = currentRow.GetDateTime("ActivityTime");
            activity.IdentityUserId = currentRow.GetInt32("IdentityUserId");
            activity.DisplayName = currentRow.GetString("displayName") ?? "";

            return activity;
        }

        public string GetActivityJson()
        {
            string bodyApostropheEscaped = Body.Replace("'", "&#39");

            return string.Format(addActivityTemplate, 
                Title, 
                bodyApostropheEscaped, 
                Url, 
                PostedTime.MillisecondsSinceEpoch().ToString(),
                "comment",
                DisplayName.Replace("'","&#39"),
                Title,
                bodyApostropheEscaped,
                IdentityUserId.ToString(),
                Url.Replace("http://www.bbc.co.uk",""));
        }

        public string GetPostUri()
        {
            Uri relativeBase = new Uri("http://localhost");
            return postUserActivityTemplate.BindByPosition(relativeBase,
                IdentityUserId.ToString(),
                Application).PathAndQuery;
        }

        private static string CreateTitleString(IDnaDataReader currentRow, 
            string activityVerb, string activityUrl, string activityHostNameUrl)
        {
            string activityName = currentRow.GetString("AppName") ?? "";

            return string.Format(titleTemplate,
                activityVerb,
                activityUrl,
                activityHostNameUrl,
                activityName.Replace("'", "&#39"));
        }

        private static void CreateActivityUrls(IDnaDataReader currentRow,
            out string activityUrl, out string activityHostNameUrl)
        {
            activityHostNameUrl = "";
            activityUrl = "";
            int postId = currentRow.GetInt32NullAsZero("PostId");

            string blogUrl = "";
            if (!currentRow.IsDBNull("BlogUrl"))
            {
                blogUrl  = currentRow.GetString("BlogUrl") ?? "";
                if (blogUrl.Length > 0)
                {
                    activityHostNameUrl = blogUrl;
                    activityUrl = activityHostNameUrl + "#P" + postId.ToString();
                }
            }
            else
            {
                string url = currentRow.GetString("DnaUrl") ?? "";
                int forumId = currentRow.GetInt32NullAsZero("ForumId");
                int threadId = currentRow.GetInt32NullAsZero("ThreadId");
                activityHostNameUrl = "http://www.bbc.co.uk/dna/" + url;
                activityUrl = activityHostNameUrl + "/F" + forumId.ToString() +
                    "?thread=" + threadId.ToString() + "#p" + postId.ToString();
            }
        }

        public static string GetActivityTypeVerb(int item)
        {
            if (item == 5)
            {
                return "posted";
            }
            return "";
        }
    }
}
