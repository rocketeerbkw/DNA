using System.Net;
using BBC.Dna.Api;
using BBC.Dna.Data;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class RevokeCommentActivity : ActivityBase
    {
        private long PostedTime
        {
            get; set;
        }

        private int IdentityUserId
        {
            get; set;
        }

        private string ApplicationId
        {
            get; set;
        }
               
        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            var query = new SnesActivitiesQuery
                            {
                                FilterBy = "postedTime",
                                FilterOp = "equals",
                                FilterValue = PostedTime.ToString(),
                                IdentityUserId = IdentityUserId
                            };

            var statusCode = query.Send(client);
            if (statusCode == HttpStatusCode.OK)
            {
                var activities = query.Content.ObjectFromJson<OpenSocialActivities>();
                
                if (activities != null && activities.TotalResults == 1)
                {
                    var deleteActivity = new DeleteActivity(activities.Entries[0].Id, ApplicationId, IdentityUserId);
                    return deleteActivity.Send(client);
                }
            }
            return HttpStatusCode.BadRequest;
        }

        public static ISnesActivity CreateActivity(IDnaDataReader currentRow)
        {
            var activity = new RevokeCommentActivity
                               {
                                   ActivityId = currentRow.GetInt32("EventID"),
                                   PostedTime = currentRow.GetDateTime("ActivityTime").MillisecondsSinceEpoch(),
                                   IdentityUserId = currentRow.GetInt32("IdentityUserId"),
                                   ApplicationId = currentRow.GetString("AppId")
                               };
            return activity;
        }
    }
}
