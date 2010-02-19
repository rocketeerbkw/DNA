using System;
using System.Security.Cryptography.X509Certificates;

namespace DnaEventService.Common
{
    /// <summary>
    /// Interface to abstract creation of classes implementing IDnaHttpClient.
    /// </summary>
    public interface IDnaHttpClientCreator
    {
        Uri BaseAddress { get; set; }
        Uri ProxyAddress { get; set; }
        X509Certificate Certificate { get; set; }
        IDnaHttpClient CreateHttpClient();
        IDnaHttpClient CreateHttpClient(Uri uri);
    }
}