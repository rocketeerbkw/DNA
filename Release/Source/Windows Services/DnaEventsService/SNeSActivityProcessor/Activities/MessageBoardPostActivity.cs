using System;
using System.Net;
using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public class MessageBoardPostActivity : CommentActivityBase
    {
        public MessageBoardPostActivity(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
        {
            Contents = openSocialActivity;
            Contents.ActivityType = openSocialActivity.CustomActivityType;
            if (string.IsNullOrEmpty(Contents.ActivityType))
            {
                Contents.ActivityType = "comment";
            }
            IdentityUserId = eventData.IdentityUserId;
            ActivityId = eventData.EventId;
        }

        public override void SetTitle(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
        {
            int postId = eventData.UrlBuilder.PostId;
            string url = eventData.UrlBuilder.DnaUrl;
            int forumId = eventData.UrlBuilder.ForumId;
            int threadId = eventData.UrlBuilder.ThreadId;
            string activityHostNameUrl = "http://www.bbc.co.uk/dna/" + url;
            try
            {
                Contents.Url = new Uri(openSocialActivity.ContentPermaUrl, UriKind.RelativeOrAbsolute);
            }
            catch { }

            if (String.IsNullOrEmpty(Contents.Url.ToString()))
            {
                Contents.Url = new Uri(activityHostNameUrl + "/F" + forumId + "?thread=" + threadId + "#p" + postId,
                                       UriKind.RelativeOrAbsolute);
            }

            Contents.Title = CreateTitleString(eventData, "posted", Contents.Url, activityHostNameUrl);
        }

        public override void SetObjectTitle(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
        {
            Contents.ObjectTitle = Contents.Title;
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


