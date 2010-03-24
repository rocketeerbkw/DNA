using System;
using System.Collections.Generic;
using System.Web;
using System.IO;
using System.Text;
using System.Xml.Xsl;

namespace BBC.Dna
{
    /// <summary>
    /// Interface the represents the output context for a dna request.
    /// </summary>
	public interface IOutputContext : IAppContext
	{
        /// <summary>
        /// Get the skin path.
        /// </summary>
        /// <param name="leaf">Name of the skin file.</param>
        /// <returns>String representing the skin path.</returns>
		string GetSkinPath(string leaf);
        
        /// <summary>
        /// Gets the TextWriter output is written to.
        /// </summary>
		TextWriter Writer
		{
			get;
		}

		/// <summary>
		/// Redirects to the specified URL rather than sending a response
		/// </summary>
		/// <param name="Url">URL to which to redirect</param>
		void Redirect(string Url);

        /// <summary>
        /// Gets a cached transform for a given xslt file. If there isn't a cached version, then it creates it and then adds it to the cache
        /// </summary>
        /// <param name="xsltFileName">The name of the xslt file you want to get the cached transform for</param>
        /// <returns>The transform for the xslt file.</returns>
        XslCompiledTransform GetCachedXslTransform(string xsltFileName);

		/// <summary>
		/// Sets the Content-type header for this request
		/// </summary>
		/// <param name="contentType">value of the content type</param>
		void SetContentType(string contentType);

#if DEBUG
        /// <summary>
        /// Debug property that holds the debug skin filename which is set via the d_skinfile URL param
        /// </summary>
        string DebugSkinFile
        {
            get;
            set;
        }
#endif

        /// <summary>
        /// Is Html caching enabled? Call this to find out.
        /// </summary>
        /// <returns>true or false</returns>
        bool IsHtmlCachingEnabled();

        /// <summary>
        /// Gets the time, in seconds, to cache html output
        /// </summary>
        /// <returns>Number of seconds</returns>
        int GetHtmlCachingTime();

        /// <summary>
        /// Creates a key based on the request and it's query string params
        /// </summary>
        /// <returns>The key</returns>
        string CreateRequestCacheKey();

        /// <summary>
        /// Gets an object out of the cache that matches the key, or null
        /// </summary>
        /// <param name="key">The key</param>
        /// <returns>The object, or null</returns>
        object GetCachedObject(string key);

        /// <summary>
        /// Caches the object under the given key, and will cache it for up to the number of seconds passed in.
        /// </summary>
        /// <param name="key">The key</param>
        /// <param name="o">The object</param>
        /// <param name="seconds">Number of seconds</param>
        void CacheObject(string key, object o, int seconds);

        /// <summary>
        /// Verifies skin file exists in file system.
        /// </summary>
        /// <param name="skinName"></param>
        /// <param name="skinSet"></param>
        /// <returns></returns>
        bool VerifySkinFileExists(string skinName, string skinSet);

        /// <summary>
        /// Gets the cookie collection for the response
        /// </summary>
        HttpCookieCollection Cookies { get; }
	}
}
