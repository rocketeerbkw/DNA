using System;
using System.Net;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public class SnesActivitiesQuery : ActivityBase
    {
        public string FilterOp
        {
            get; set;
        }

        public string FilterBy
        {
            get; set;
        }

        public string FilterValue
        {
            get; set;
        }

        public string IdentityUserId
        {
            get; set;
        }

        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            return Send(client.Get);
        }

        public override Uri GetUri()
        {
            string query = "?filterBy=" + FilterBy + "&filterOp=" + FilterOp + "&filterValue=" + FilterValue;
            return new Uri("/social/social/rest/activities/" + IdentityUserId + "/@self/" + query, UriKind.Relative);  
        }
    }
}


