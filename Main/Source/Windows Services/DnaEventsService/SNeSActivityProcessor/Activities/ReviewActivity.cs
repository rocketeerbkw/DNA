using System.Net;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    class ReviewActivity : CommentActivityBase
    {
        public ReviewActivity(OpenSocialActivity activity, SnesActivityData eventData)
        {
            Contents = activity;
            Contents.ActivityType = "review";
        }

        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            return Send(client.Post);
        }

        #region Overrides of CommentActivityBase

        public override void SetTitle(OpenSocialActivity activity, SnesActivityData eventData)
        {
            
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


