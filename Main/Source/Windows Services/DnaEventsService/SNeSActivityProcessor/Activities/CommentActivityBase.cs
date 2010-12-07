using System;
using BBC.Dna.Utils;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public abstract class CommentActivityBase : ActivityBase
    {
        private const string TitleTemplate =
            @"{0} a <a href= ""{1}"" > new comment </a> on the <a href = ""{2}"" > {3} </a>";

        private static readonly UriTemplate PostUserActivityTemplate =
            new UriTemplate("social/social/rest/activities/{userid}/@self/{applicationid}");

        public abstract void SetTitle(OpenSocialActivity openSocialActivity, SnesActivityData activityData);
        public abstract void SetObjectTitle(OpenSocialActivity openSocialActivity, SnesActivityData activityData);
        public abstract void SetObjectDescription(OpenSocialActivity openSocialActivity, SnesActivityData activityData);
        public abstract void SetObjectUri(OpenSocialActivity openSocialActivity, SnesActivityData activityData);

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

        public string IdentityUserId
        {
            get;
            set;
        }

        public override string GetActivityJson()
        {
            return StringUtils.SerializeToJsonReturnAsString(Contents);
        }

        public override Uri GetUri()
        {
            var relativeBase = new Uri("http://localhost/");
            return new Uri(PostUserActivityTemplate.BindByPosition(relativeBase,
                                                                   IdentityUserId,
                                                                   Application).PathAndQuery, UriKind.Relative);
        }

        public static ISnesActivity CreateActivity(OpenSocialActivity openSocialActivity, SnesActivityData activityData)
        {
            CommentActivityBase activityBase;
            
            if (activityData.BlogUrl == null)
            {
                activityBase = PolicyInjection.Create<MessageBoardPostActivity>(openSocialActivity, activityData);
            }
            else
            {
                if (activityData.Rating == null)
                {
                    activityBase = PolicyInjection.Create<CommentForumActivity>(openSocialActivity, activityData);    
                }
                else
                {
                    activityBase = PolicyInjection.Create<ReviewActivity>(openSocialActivity, activityData);
                }
            }
            
            activityBase.Application = activityData.AppInfo.AppId;
            
            activityBase.SetTitle(openSocialActivity, activityData);
            activityBase.SetObjectTitle(openSocialActivity, activityData);
            activityBase.SetObjectDescription(openSocialActivity, activityData);
            activityBase.SetObjectUri(openSocialActivity, activityData);

            return activityBase;
        }
        
        public static string CreateTitleString(SnesActivityData eventData, 
                                               string activityVerb, Uri activityUrl, string activityHostNameUrl)
        {
            var activityName = eventData.AppInfo.ApplicationName;

            return string.Format(TitleTemplate,
                                 activityVerb,
                                 activityUrl.PathAndQuery,
                                 activityHostNameUrl,
                                 activityName);
        }

        public static string GetActivityTypeVerb(int item)
        {
            return "posted";
        }
    }
}


