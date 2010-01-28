using System;
using DnaEventService.Common;
using System.Net;

namespace Dna.SnesIntegration.ActivityProcessor
{
    public interface ISnesActivity
    {
        string GetActivityJson();
        Uri GetUri();
        int ActivityId { get; set; }
        HttpStatusCode Send(IDnaHttpClient client);
    }
}
