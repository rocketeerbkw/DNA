﻿using System;
using System.Net;
using BBC.Dna.Api;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using DnaEventService.Common;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;

namespace Dna.SnesIntegration.ActivityProcessor
{
    abstract class CommentActivity : ActivityBase
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
            var relativeBase = new Uri("http://localhost");
            return postUserActivityTemplate.BindByPosition(relativeBase,
                IdentityUserId,
                Application);
        }

        public static ISnesActivity CreateActivity(int activityType, IDnaDataReader currentRow)
        {
            CommentActivity activity;

            if (currentRow.IsDBNull("BlogUrl"))
            {
                activity = PolicyInjection.Create<MessageBoardPostActivity>();
            }
            else
            {
                activity = PolicyInjection.Create<CommentForumActivity>();
            }

            activity.Contents = new OpenSocialActivity();
            activity.ActivityId = currentRow.GetInt32("EventID");
            activity.Application = currentRow.GetString("AppId") ?? "";
            activity.ActivityType = GetActivityTypeVerb(activityType);
            activity.IdentityUserId = currentRow.GetInt32("IdentityUserId");

            activity.SetTitle(currentRow);
            activity.SetObjectTitle(currentRow);
            activity.SetObjectDescription(currentRow);
            activity.SetObjectUri(currentRow);

            activity.Contents.Type = "comment";
            activity.Contents.Body = currentRow.GetString("Body") ?? "";
            activity.Contents.PostedTime = currentRow.GetDateTime("ActivityTime").MillisecondsSinceEpoch();
            activity.Contents.DisplayName = currentRow.GetString("displayName") ?? "";
            activity.Contents.Username = currentRow.GetString("username") ?? "";

            return activity;
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
            return item == 19 ? "posted" : "";
        }
    }
}
