using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Caching;
using System.Data;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// The DNA Cache object. This class is used to provide a layer between DNA and the .NET Web request.
    /// It wraps all the required methods and properties that DNA requires.
    /// </summary>
    public static class DnaStaticCache
    {
        private static Cache _cache = new Cache();
        private static bool _cacheInitialised = false;

        public static void InitialiseCache(Cache cache)
        {
            //only do once per application
            if (!_cacheInitialised)
            {
                _cache = cache;
                _cacheInitialised = true;
            }
        }

        /// <summary>
        /// Adds a permanent object to the cache
        /// </summary>
        /// <param name="key">The identifier</param>
        /// <param name="o">The object to cache</param>
        public static void Add(string key, object o)
        {
            Add(key, o, null, DateTime.Now.AddDays(1), TimeSpan.Zero, CacheItemPriority.Default, null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <param name="o"></param>
        /// <param name="dependency"></param>
        /// <param name="expiry"></param>
        /// <param name="duration"></param>
        public static void Add(string key, object o, System.Web.Caching.CacheDependency dependency, DateTime expiry, TimeSpan duration)
        {
            
            _cache.Insert(key, o, dependency, expiry, duration);
        }

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
        public static void Add(string key, object o, System.Web.Caching.CacheDependency dependency, DateTime expiry, TimeSpan duration, CacheItemPriority priority, CacheItemRemovedCallback callback)
        {
            
            _cache.Insert(key, o, dependency, expiry, duration, priority, callback);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static object Get(string key)
        {
            
            return _cache[key];
            
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static object Remove(string key)
        {
            
            return _cache.Remove(key);
        }

        /// <summary>
        /// Returns if the key exists in the cache
        /// </summary>
        /// <param name="key">The key to test</param>
        /// <returns>Whether it exists in the cache or not</returns>
        public static bool Exists(string key)
        {
            
            return (_cache[key] != null);
        }

    }
}
