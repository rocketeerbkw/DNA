using System;
using System.Net;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public class CommentForumActivity : CommentActivityBase
    {
        public CommentForumActivity(OpenSocialActivity openSocialActivity, SnesActivityData eventData)
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
            try
            {
                Contents.Url = new Uri(openSocialActivity.ContentPermaUrl, UriKind.RelativeOrAbsolute);
            }
            catch { }

            if (Contents.Url == null || String.IsNullOrEmpty(Contents.Url.OriginalString))
            {
                if (eventData.BlogUrl.Length > 0)
                {
                    Contents.Url = new Uri(eventData.BlogUrl + "#P" + eventData.UrlBuilder.PostId, UriKind.RelativeOrAbsolute);
                }

            }
           

            Contents.Title =
                CreateTitleString(eventData, "posted", Contents.Url, eventData.BlogUrl);
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


