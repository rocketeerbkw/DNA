﻿using System.Net;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public class RevokeCommentActivity : ActivityBase
    {
        private long PostedTime
        {
            get; set;
        }

        private string IdentityUserId
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
                
                if (activities != null)
                {
                    if (activities.TotalResults > 0)
                    {
                        var deleteActivity =
                            new DeleteActivity(activities.Entries[0].Id, ApplicationId, IdentityUserId);
                        return deleteActivity.Send(client);
                    }
                    else
                    {//nothing to find so dont retry....
                        return HttpStatusCode.OK;
                    }

                }
            }
            return HttpStatusCode.BadRequest;
        }

        public static ISnesActivity CreateActivity(OpenSocialActivity openSocialActivity, 
            SnesActivityData activityData)
        {
            var activity = new RevokeCommentActivity
                               {
                                   ActivityId = activityData.EventId,
                                   PostedTime = openSocialActivity.PostedTime,
                                   IdentityUserId = activityData.IdentityUserId,
                                   ApplicationId = activityData.AppInfo.AppId
                               };
            return activity;
        }
    }
}


