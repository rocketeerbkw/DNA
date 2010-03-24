using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Caching;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// The dna Cache Interface. Impliments all calls needed by DNA from the HttpContext.Cache.
    /// </summary>
	public interface ICache
	{
        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <param name="o"></param>
        /// <param name="dependency"></param>
        /// <param name="expiry"></param>
        /// <param name="duration"></param>
		void Insert(string key, object o,System.Web.Caching.CacheDependency  dependency, DateTime expiry, TimeSpan duration);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <param name="o"></param>
        /// <param name="dependency"></param>
        /// <param name="expiry"></param>
        /// <param name="duration"></param>
        /// <param name="priority"></param>
        /// <param name="callback"></param>
        /// <returns></returns>
		object Add(string key, object o, System.Web.Caching.CacheDependency dependency, DateTime expiry, TimeSpan duration, CacheItemPriority priority, CacheItemRemovedCallback callback);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
		object this[string key]	{ get; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
		object Remove(string key);
	}
}
