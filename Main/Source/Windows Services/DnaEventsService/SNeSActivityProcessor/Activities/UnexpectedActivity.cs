﻿using System.Net;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public class UnexpectedActivity : ActivityBase
    {
        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            return HttpStatusCode.OK;
        }

        public override string GetActivityJson()
        {
            throw new System.NotImplementedException();
        }
    }
}


