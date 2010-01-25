using Microsoft.Http;

namespace DnaEventService.Common
{
    /// <summary>
    /// Interface to abstract HttpClient
    /// </summary>
    public interface IDnaHttpClient
    {
        HttpWebRequestTransportSettings TransportSettings { get; }

        HttpResponseMessage Post(string uri, HttpContent body);
    }
}