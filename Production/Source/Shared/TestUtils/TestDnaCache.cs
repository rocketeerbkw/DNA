using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;
using System.Web.Caching;

namespace TestUtils
{
    public class TestDnaCache : IDnaCache
    {
        private Dictionary<string,object> _cache;

        public TestDnaCache()
        {
            _cache = new Dictionary<string, object>();
        }

        public bool Exists(string key)
        {
            try
            {
                return (_cache[key] != null);
            }
            catch
            {
                return false;
            }
        }

        public object Add(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemPriority priority, CacheItemRemovedCallback onRemoveCallback)
        {
            Remove(key);
            _cache.Add(key, value);
            return value;
        }

        public void Insert(string key, object value)
        {
            Remove(key);
            _cache.Add(key, value);
        }
        public void Insert(string key, object value, CacheDependency dependencies)
        {
            Remove(key);
            _cache.Add(key, value);
        }
        public void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration)
        {
            Remove(key);
            _cache.Add(key, value);
        }
        public void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemUpdateCallback onUpdateCallback)
        {
            Remove(key);
            _cache.Add(key, value);
        }
        public void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemPriority priority, CacheItemRemovedCallback onRemoveCallback)
        {
            Remove(key);
            _cache.Add(key, value);
        }

        public object Remove(string key)
        {
            try
            {
                return _cache.Remove(key);
            }
            catch
            {
                return null;
            }
        }

        public object this[string key]
        {
            get
            {
                try
                {
                    return _cache[key];
                }
                catch
                {
                    return null;
                }
            }
            
            set
            {
                Remove(key);
                _cache[key] = value;
            }
        }

        public object Get(string key)
        {
            try
            {
                return _cache[key];
            }
            catch
            {
                return null;
            }
        }
    }
}
