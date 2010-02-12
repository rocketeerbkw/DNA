using System;
using BBC.Dna.Api;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;

namespace Dna.SnesIntegration.ActivityProcessor
{
    abstract class CommentActivityBase : ActivityBase
    {
        private static string titleTemplate =
            @"{0} a <a href= ""{1}"" > new comment </a> on the <a href = ""{2}"" > {3} </a>";

        private static readonly UriTemplate postUserActivityTemplate =
            new UriTemplate("social/social/rest/activities/{userid}/@self/{applicationid}");

        public abstract void SetTitle(IDnaDataReader currentRow);
        public abstract void SetObjectTitle(IDnaDataReader currentRow);
        public abstract void SetObjectDescription(IDnaDataReader currentRow);
        public abstract void SetObjectUri(IDnaDataReader currentRow);

        public OpenSocialActivity Contents
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

        public int IdentityUserId
        {
            get;
            set;
        }

        public override string GetActivityJson()
        {
            return StringUtils.SerializeToJson(Contents);
        }

        public override Uri GetUri()
        {
            var relativeBase = new Uri("http://localhost/");
            return new Uri(postUserActivityTemplate.BindByPosition(relativeBase,
                IdentityUserId.ToString(),
                Application).PathAndQuery, UriKind.Relative);
        }

        public static ISnesActivity CreateActivity(int activityType, IDnaDataReader currentRow)
        {
            CommentActivityBase activityBase;

            if (currentRow.IsDBNull("BlogUrl"))
            {
                activityBase = PolicyInjection.Create<MessageBoardPostActivity>();
            }
            else
            {
                activityBase = PolicyInjection.Create<CommentForumActivity>();
            }

            activityBase.Contents = new OpenSocialActivity();
            activityBase.ActivityId = currentRow.GetInt32("EventID");
            activityBase.Application = currentRow.GetString("AppId") ?? "";
            activityBase.ActivityType = GetActivityTypeVerb(activityType);
            activityBase.IdentityUserId = currentRow.GetInt32("IdentityUserId");

            activityBase.SetTitle(currentRow);
            activityBase.SetObjectTitle(currentRow);
            activityBase.SetObjectDescription(currentRow);
            activityBase.SetObjectUri(currentRow);

            activityBase.Contents.Type = "comment";
            activityBase.Contents.Body = currentRow.GetString("Body") ?? "";
            activityBase.Contents.PostedTime = currentRow.GetDateTime("ActivityTime").MillisecondsSinceEpoch();
            activityBase.Contents.DisplayName = currentRow.GetString("displayName") ?? "";
            activityBase.Contents.Username = currentRow.GetString("username") ?? "";

            return activityBase;
        }
        
        public static string CreateTitleString(IDnaDataReader currentRow, 
            string activityVerb, string activityUrl, string activityHostNameUrl)
        {
            var activityName = currentRow.GetString("AppName") ?? "";

            return string.Format(titleTemplate,
                activityVerb,
                activityUrl,
                activityHostNameUrl,
                activityName);
        }

        public static string GetActivityTypeVerb(int item)
        {
            return "posted";
        }
    }
}
