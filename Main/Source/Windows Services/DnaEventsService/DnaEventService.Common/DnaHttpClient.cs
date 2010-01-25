using System;
using Microsoft.Http;

namespace DnaEventService.Common
{
    /// <summary>
    /// Implementation of the IDnaHttpClient interface. Simple wrapper around HttpClient with factory method.
    /// </summary>
    public class DnaHttpClient : IDnaHttpClient
    {
        /// <summary>
        /// Private constructor. Use Factory method to create instance.
        /// </summary>
        private DnaHttpClient()
        {
        }

        /// <summary>
        /// Private constructor. Create instance via CreateDnaHttpClient factory method.
        /// </summary>
        /// <param name="httpClient">The actual HttpClient instance being wrapped.</param>
        private DnaHttpClient(HttpClient httpClient)
        {
            Client = httpClient;
        }

        private HttpClient Client { get; set; }

        #region IDnaHttpClient Members

        public HttpWebRequestTransportSettings TransportSettings
        {
            get { return Client.TransportSettings; }
        }

        /// <summary>
        /// Post Method
        /// </summary>
        /// <param name="uri">Location to post to</param>
        /// <param name="body">Body of the post request.</param>
        /// <returns>Response from the POST request.</returns>
        public HttpResponseMessage Post(string uri, HttpContent body)
        {
            return Client.Post(uri, body);
        }

        #endregion

        /// <summary>
        /// Factory method to create an instance of an HttpClient
        /// </summary>
        /// <param name="baseAddress">The base address the HttpClient is set to.</param>
        /// <returns>Interface to HttpClient abstraction</returns>
        public static IDnaHttpClient CreateDnaHttpClient(Uri baseAddress)
        {
            var client = new HttpClient(baseAddress);
            return new DnaHttpClient(client);
        }
    }
}