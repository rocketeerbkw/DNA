using System;
using Microsoft.Http;

namespace DnaEventService.Common
{
    /// <summary>
    /// Interface to abstract HttpClient
    /// </summary>
    public interface IDnaHttpClient
    {
        HttpWebRequestTransportSettings TransportSettings { get; }

        HttpResponseMessage Get(Uri uri);
        HttpResponseMessage Delete(Uri uri);
        HttpResponseMessage Post(Uri uri, HttpContent body);
        HttpResponseMessage Put(Uri uri, HttpContent body);
    }
}