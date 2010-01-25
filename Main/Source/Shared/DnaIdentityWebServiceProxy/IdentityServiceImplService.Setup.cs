using System;
using System.Collections.Generic;
using System.Text;
using System.Net;

namespace DnaIdentityWebServiceProxy
{
    public partial class IdentityServicesImplService : System.Web.Services.Protocols.SoapHttpClientProtocol
    {
        private string _clientIPAddress = "";

        /// <summary>
        /// Initialises the request so that it rewites the domain and adds the
        /// client ip address to the request header
        /// </summary>
        public void InitialiseRequest(string clientIPAddress)
        {
            _clientIPAddress = clientIPAddress;
            //Console.WriteLine("Set client ip address to " + _clientIPAddress);
        }

        /// <summary>
        /// Override of base class GetWebRequest. Used to modify the Identity load balance cookie.
        /// </summary>
        /// <param name="uri">The current uri being requested</param>
        /// <returns>The current web request object</returns>
        protected override WebRequest GetWebRequest(Uri uri)
        {
            // call the base class to get the underlying WebRequest object
            HttpWebRequest req = (HttpWebRequest)base.GetWebRequest(uri);
            try
            {
                if (_clientIPAddress.Length > 0)
                {
                    // set the header
                    req.Headers.Add("X-Forwarded-For", _clientIPAddress);
                    //Console.WriteLine("Added client ip address to header - " + _clientIPAddress);
                }

                CookieCollection cookies = CookieContainer.GetCookies(uri);
                if (cookies != null)
                {
                    Cookie identityCookie = cookies["X-Mapping-lbgdeohg"];
                    if (identityCookie != null)
                    {
                        identityCookie.Domain = "";
                        //Console.WriteLine("Set the identity cookie domain to BLANK");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            // return the WebRequest to the caller
            return (WebRequest)req;
        }

        /// <summary>
        /// Override of base class GetWebResponse. Used to modify the Identity load balance cookie
        /// </summary>
        /// <param name="request">Current request object</param>
        /// <returns>The WebResponse object</returns>
        protected override WebResponse GetWebResponse(WebRequest request)
        {
            WebResponse webResponse = base.GetWebResponse(request);
            try
            {
                CookieCollection cookies = CookieContainer.GetCookies(request.RequestUri);
                if (cookies != null)
                {
                    Cookie identityCookie = cookies["X-Mapping-lbgdeohg"];
                    if (identityCookie != null)
                    {
                        identityCookie.Domain = ".bbc.co.uk";
                        //Console.WriteLine("Set the identity cookie domain back to .bbc.co.uk");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            // Return the wen response back to the caller
            return webResponse;
        }
    }
}
