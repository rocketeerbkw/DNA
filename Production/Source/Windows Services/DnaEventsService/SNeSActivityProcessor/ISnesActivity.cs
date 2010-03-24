using System;
using System.Net;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor
{
    public interface ISnesActivity
    {
        string GetActivityJson();
        Uri GetUri();
        int ActivityId { get; set; }
        HttpStatusCode Send(IDnaHttpClient client);
        string Content { get; set; }
    }
}
