using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Net;
using System.Security.Cryptography.X509Certificates;

namespace DnaEventService.Common
{
    /// <summary>
    /// Implementation of the IDnaHttpClientCreator interface
    /// </summary>
    public class DnaHttpClientCreator : IDnaHttpClientCreator
    {
        public Uri BaseAddress { get; set; }
        public string ProxyAddress { get; set; }
        public X509Certificate Certificate { get; set; }
        
        public DnaHttpClientCreator(Uri baseAddress, string proxyAddress, X509Certificate certificate) 
        {
            BaseAddress = baseAddress;
            ProxyAddress = proxyAddress;
            Certificate = certificate;
        }

        #region IDnaHttpClientCreator Members

        /// <summary>
        /// Method to create an HttpClient. Delegates to the factory method on DnaHttpClient.
        /// </summary>
        /// <param name="baseAddress">The base address of the HttpClient</param>
        /// <returns></returns>
        public IDnaHttpClient CreateHttpClient()
        {
            IDnaHttpClient httpClient = DnaHttpClient.CreateDnaHttpClient(BaseAddress);
            InitializeHttpClient(httpClient);

            return httpClient;
        }

        public IDnaHttpClient CreateHttpClient(string uri)
        {
            IDnaHttpClient httpClient = DnaHttpClient.CreateDnaHttpClient(new Uri(uri));
            InitializeHttpClient(httpClient);
            return httpClient;
        }

        #endregion

        private void InitializeHttpClient(IDnaHttpClient httpClient)
        {
            if (Certificate != null)
            {
                httpClient.TransportSettings.ClientCertificates.Add(Certificate);
            }
            httpClient.TransportSettings.Proxy = new WebProxy(ProxyAddress);

            System.Net.ServicePointManager.Expect100Continue = false;
            System.Net.ServicePointManager.SetTcpKeepAlive(false, 0, 0);
        }
    }
}
