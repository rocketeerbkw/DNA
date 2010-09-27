using System.Net;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using DnaEventService.Common;
using System;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public class ReviewActivity : CommentActivityBase
    {
        public ReviewActivity(OpenSocialActivity activity, SnesActivityData eventData)
        {
            Contents = activity;
            Contents.ActivityType = activity.CustomActivityType;
            if (string.IsNullOrEmpty(Contents.ActivityType))
            {
                Contents.ActivityType = "review";
            }
            
            IdentityUserId = eventData.IdentityUserId;
            ActivityId = eventData.EventId;
        }

        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            return Send(client.Post);
        }

        #region Overrides of CommentActivityBase

        public override void SetTitle(OpenSocialActivity activity, SnesActivityData eventData)
        {
            try
            {
                Contents.Url = new Uri(activity.ContentPermaUrl, UriKind.RelativeOrAbsolute);
            }
            catch { }

            if (String.IsNullOrEmpty(Contents.Url.ToString()))
            {
                if (eventData.BlogUrl.Length > 0)
                {
                    Contents.Url = new Uri(eventData.BlogUrl + "#P" + eventData.UrlBuilder.PostId, UriKind.RelativeOrAbsolute);
                }

            }


            Contents.Title =
                CreateTitleString(eventData, "posted", Contents.Url, eventData.BlogUrl);
        }

        public override void SetObjectTitle(OpenSocialActivity activity, SnesActivityData eventData)
        {
            Contents.ObjectTitle = activity.ObjectTitle;
        }

        public override void SetObjectDescription(OpenSocialActivity activity, SnesActivityData eventData)
        {
            Contents.ObjectDescription = activity.ObjectDescription;
        }

        public override void SetObjectUri(OpenSocialActivity activity, SnesActivityData eventData)
        {
            Contents.ObjectUri = activity.ObjectUri; 
        }

        #endregion
    }
}


