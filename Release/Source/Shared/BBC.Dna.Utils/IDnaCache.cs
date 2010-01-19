using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Caching;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// The dna Cache Interface. Impliments all calls needed by DNA from the HttpContext.Cache.
    /// </summary>
	public interface IDnaCache
	{
        bool Exists(string key);

        object Add(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemPriority priority, CacheItemRemovedCallback onRemoveCallback);
        
        void Insert(string key, object value);
        void Insert(string key, object value, CacheDependency dependencies);
        void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration);
        void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemUpdateCallback onUpdateCallback);
        void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemPriority priority, CacheItemRemovedCallback onRemoveCallback);

        object Remove(string key);

        object this[string key] { get; set; }
        object Get(string key);
	}
}
