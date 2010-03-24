using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Web;
using System.IO;
using BBC.Dna.Utils;

//Build you bugger!!

namespace BBC.Dna.Page
{
    /// <summary>
    /// Summary description for DnaBasePage
    /// </summary>
    public partial class DnaBasePage : IInputContext, IOutputContext
    {
        /// <summary>
        ///  Get the skin path.
        /// </summary>
        /// <param name="leaf">Name of the skin file.</param>
        /// <returns>String representing the skin path.</returns>
        public string GetSkinPath(string leaf)
        {
            return AppContext.TheAppContext.Config.GetSkinRootFolder() + "SkinSets" + @"\" + _skinSelector.SkinSet + @"\" + _skinSelector.SkinName + @"\" + leaf;
        }

        /// <summary>
        /// Gets the TextWriter output is written to.
        /// </summary>
        public TextWriter Writer
        {
            get
            {
                return Response.Output;
            }
        }

		/// <summary>
		/// Redirects to the specified URL rather than sending a response
		/// </summary>
		/// <param name="Url">URL to which to redirect</param>
		public void Redirect(string Url)
		{
			Response.Redirect(Url);
		}


		/// <summary>
		/// Sets the Content-type header for this request
		/// </summary>
		/// <param name="contentType">value of the content type</param>
		public void SetContentType(string contentType)
		{
			Response.ContentType = contentType;
		}

#if DEBUG
        private string _debugSkinFile = String.Empty;

        /// <summary>
        /// Debug property that holds the debug skin filename which is set via the d_skinfile URL param
        /// </summary>
        public string DebugSkinFile
        {
            get { return _debugSkinFile; }
            set { _debugSkinFile = value; }
        }
#endif

        /// <summary>
        /// Checks to see if the current site and page is using html caching. It also depends on the user being logged in or not.
        /// Caching only works for logged out users
        /// </summary>
        /// <returns>True if caching is enaqbled and the user is logged out, false if caching is disabled or the user is logged in</returns>
        public virtual bool IsHtmlCachingEnabled()
        {
            return _dnapage.IsHtmlCachingEnabled() && GetCookie("SSO2-UID") == null && GetCookie("IDENTITY") == null;
        }

        /// <summary>
        /// Base implementaion always returns 0
        /// </summary>
        /// <returns>0</returns>
        public virtual int GetHtmlCachingTime()
        {
            return _dnapage.GetHtmlCachingTime();
        }

        /// <summary>
        /// Creates a key unique for this request.  It's based on the query string params
        /// </summary>
        /// <returns>the key</returns>
        public virtual string CreateRequestCacheKey()
        {
            string key = "RequestCache:"+PageType;

            NameValueCollection queryCollection = Request.QueryString;
            foreach (string s in queryCollection)
            {
                if (s != null)
                {
                    if (s.ToLower() != "__ip__")
                    {
                        key += ":" + s + "=" + queryCollection[s];
                    }
                }
            }

            return key;
        }

        /// <summary>
        /// Returns the object stored in the cache with the given key, or null is it's not found
        /// </summary>
        /// <param name="key">The key</param>
        /// <returns>The object, or null if not found</returns>
        public object GetCachedObject(string key)
        {
			
            return DnaStaticCache.Get(key);
        }

        /// <summary>
        /// Caches the given object, with the given key for the given number of seconds.
        /// If an object is already cached under the given key, it is replaced
        /// </summary>
        /// <param name="key">The key</param>
        /// <param name="o">The object</param>
        /// <param name="seconds">Number of seconds to cache for</param>
        public void CacheObject(string key, object o, int seconds)
        {
            DnaStaticCache.Add(key, o, null, DateTime.Now.AddSeconds(seconds), TimeSpan.Zero);
        }

		/// <summary>
		/// <see cref="IAppContext.FileCachePutItem"/>
		/// </summary>
		public bool FileCachePutItem(string pCacheName, string pItemName, string pText)
		{
			return AppContext.TheAppContext.FileCachePutItem(pCacheName, pItemName, pText);			
		}

        /// <summary>
        /// Verifies that specified skin exists in the file structure.
        /// </summary>
        /// <param name="skinName"></param>
        /// <param name="skinSet"></param>
        /// <returns></returns>
        public bool VerifySkinFileExists(string skinName, string skinSet)
        {
            string path = AppContext.TheAppContext.Config.GetSkinRootFolder() + "SkinSets" + @"\" + skinSet + @"\" + skinName + @"\" + DnaTransformer.XsltFileName;
            FileInfo fileInfo = new FileInfo(path);
            return fileInfo.Exists;
        }

        /// <summary>
        /// Gets the cookie collection for the response
        /// </summary>
        public HttpCookieCollection Cookies
        {
            get { return Response.Cookies; }
        }

    }
}
