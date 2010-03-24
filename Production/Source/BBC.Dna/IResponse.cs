using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.IO;

namespace BBC.Dna
{
	/// <summary>
    /// The DNA Response Interface. Impliments all calls needed by DNA from the HttpResponse.
	/// </summary>
	public interface IResponse
	{
		/// <summary>
		/// The Output property
		/// </summary>
		TextWriter Output { get;}

		/// <summary>
		/// The redirect method
		/// </summary>
		/// <param name="url">The url you want to redirect to</param>
		void Redirect(string url);

		/// <summary>
		/// The content type property
		/// </summary>
		string ContentType { set;}

		/// <summary>
		/// The status code property
		/// </summary>
		int StatusCode { set;}

		/// <summary>
		/// The write method
		/// </summary>
		/// <param name="s">The string you want to be written to the response</param>
		void Write(string s);

		/// <summary>
		/// The content encoding property
		/// </summary>
		Encoding ContentEncoding { set;}

        /// <summary>
        /// Gets the cookie collection for the response
        /// </summary>
        HttpCookieCollection Cookies { get; }
	}
}
