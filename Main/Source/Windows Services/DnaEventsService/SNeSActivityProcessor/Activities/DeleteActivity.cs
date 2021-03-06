﻿using System;
using System.Net;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public class DeleteActivity : ActivityBase
    {
        private string SnesId
        {
            get; set;
        }

        private string ApplicationId
        {
            get; set;
        }

        private string IdentityUserId
        {
            get; set;
        }

        public DeleteActivity(string snesId, string applicationId, string identityUserId)
        {
            SnesId = snesId;
            ApplicationId = applicationId;
            IdentityUserId = identityUserId;
        }

        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            return Send(client.Delete);
        }

        public override Uri GetUri()
        {
            return new Uri("/social/social/rest/activities/" + IdentityUserId + "/@self/" +
                           ApplicationId + "/" + SnesId, UriKind.Relative);
        }
    }
}