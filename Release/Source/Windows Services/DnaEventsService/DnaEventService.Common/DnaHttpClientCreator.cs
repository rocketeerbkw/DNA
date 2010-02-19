using System;
using System.Net;
using System.Security.Cryptography.X509Certificates;

namespace DnaEventService.Common
{
    /// <summary>
    /// Implementation of the IDnaHttpClientCreator interface
    /// </summary>
    public class DnaHttpClientCreator : IDnaHttpClientCreator
    {
        public DnaHttpClientCreator(Uri baseAddress, Uri proxyAddress, X509Certificate certificate)
        {
            BaseAddress = baseAddress;
            ProxyAddress = proxyAddress;
            Certificate = certificate;
        }

        #region IDnaHttpClientCreator Members

        public Uri BaseAddress { get; set; }
        public Uri ProxyAddress { get; set; }
        public X509Certificate Certificate { get; set; }

        /// <summary>
        /// Method to create an HttpClient. Delegates to the factory method on DnaHttpClient.
        /// </summary>
       /// <returns></returns>
        public IDnaHttpClient CreateHttpClient()
        {
            IDnaHttpClient httpClient = DnaHttpClient.CreateDnaHttpClient(BaseAddress);
            InitializeHttpClient(httpClient);

            return httpClient;
        }

        public IDnaHttpClient CreateHttpClient(Uri uri)
        {
            IDnaHttpClient httpClient = DnaHttpClient.CreateDnaHttpClient(uri);
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

            ServicePointManager.Expect100Continue = false;
            ServicePointManager.SetTcpKeepAlive(false, 0, 0);
        }
    }
}