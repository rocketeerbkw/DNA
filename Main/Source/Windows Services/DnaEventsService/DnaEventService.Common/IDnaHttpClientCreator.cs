using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace DnaEventService.Common
{
    /// <summary>
    /// Interface to abstract creation of classes implementing IDnaHttpClient.
    /// </summary>
    public interface IDnaHttpClientCreator
    {
        Uri BaseAddress { get; set; }
        string ProxyAddress { get; set; }
        X509Certificate Certificate { get; set; }
        IDnaHttpClient CreateHttpClient();
        IDnaHttpClient CreateHttpClient(string uri);
    }
}
