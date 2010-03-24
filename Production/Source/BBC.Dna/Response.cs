using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.IO;

namespace BBC.Dna
{
    /// <summary>
    /// The DNA Request object. This class is used to provide a layer between DNA and the .NET Web response.
    /// It wraps all the required methods and properties that DNA requires.
    /// </summary>
    public class Response : IResponse
    {
        private HttpResponse _response;

        /// <summary>
        /// The Response constructor
        /// </summary>
        /// <param name="response">The HttpResponse object you want to wrap</param>
        public Response(HttpResponse response)
        {
            _response = response;
        }

        /// <summary>
        /// The output property
        /// </summary>
        public TextWriter Output
        {
            get { return _response.Output; }
        }

        /// <summary>
        /// The redirect method
        /// </summary>
        /// <param name="url">The url you want to redirect to</param>
        public void Redirect(string url)
        {
            _response.Redirect(url,false);
        }

        /// <summary>
        /// The content type property
        /// </summary>
        public string ContentType
        {
            set { _response.ContentType = value; }
        }

        /// <summary>
        /// The status code property
        /// </summary>
        public int StatusCode
        {
            set { _response.StatusCode = value; }
        }

        /// <summary>
        /// The write method
        /// </summary>
        /// <param name="s">The string you want to be written to the response</param>
        public void Write(string s)
        {
            _response.Write(s);
        }

        /// <summary>
        /// The content encoding property
        /// </summary>
        public Encoding ContentEncoding
        {
            set { _response.ContentEncoding = value; }
        }

        /// <summary>
        /// Gets the cookie collection for the response
        /// </summary>
        public HttpCookieCollection Cookies
        {
            get { return _response.Cookies; }
        }
    }
}
