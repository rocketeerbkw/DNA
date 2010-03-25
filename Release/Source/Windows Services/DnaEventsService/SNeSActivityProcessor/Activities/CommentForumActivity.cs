using System;
using System.Net;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    class CommentForumActivity : CommentActivityBase
    {
        public CommentForumActivity(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
        {
            Contents = openSocialActivity;
            Contents.ActivityType = "comment";
            IdentityUserId = eventData.IdentityUserId;
            ActivityId = eventData.EventId;
        }

        public override void SetTitle(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
        {
            string activityHostNameUrl = "";
            int postId = eventData.UrlBuilder.PostId;
            string blogUrl = eventData.BlogUrl;

            if (blogUrl.Length > 0)
            {
                activityHostNameUrl = blogUrl;
                Contents.Url = new Uri(activityHostNameUrl + "#P" + postId, UriKind.RelativeOrAbsolute);
            }

            Contents.Title =
                CreateTitleString(eventData, "posted", Contents.Url, activityHostNameUrl);
        }

        public override void SetObjectTitle(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
        {
            Contents.ObjectTitle = openSocialActivity.ObjectTitle;
        }

        public override void SetObjectDescription(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
        {
            Contents.ObjectDescription = openSocialActivity.ObjectDescription;
        }

        public override void SetObjectUri(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
        {
            Contents.ObjectUri = openSocialActivity.ObjectUri;
        }

        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            return Send(client.Post);
        }
      
    }
}


