﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Caching;

namespace BBC.Dna.Utils
{
    public class DnaCache : IDnaCache
    {
        private Dictionary<string,object> _cache;

        public DnaCache()
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
        /*
        private Cache _cache = null;
        public DnaCache()
        {
            _cache = new Cache();
        }

        public bool Exists(string key)
        {
            return (_cache[key] != null);
        }

        public object Add(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemPriority priority, CacheItemRemovedCallback onRemoveCallback)
        {
            return _cache.Add(key, value, dependencies, absoluteExpiration, slidingExpiration, priority, onRemoveCallback);
        }

        public void Insert(string key, object value)
        {
            _cache.Insert(key, value);
        }
        public void Insert(string key, object value, CacheDependency dependencies)
        {
            _cache.Insert(key, value, dependencies);
        }
        public void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration)
        {
            _cache.Insert(key, value, dependencies, absoluteExpiration, slidingExpiration);
        }
        public void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemUpdateCallback onUpdateCallback)
        {
            _cache.Insert(key, value, dependencies, absoluteExpiration, slidingExpiration, onUpdateCallback);
        }
        public void Insert(string key, object value, CacheDependency dependencies, DateTime absoluteExpiration, TimeSpan slidingExpiration, CacheItemPriority priority, CacheItemRemovedCallback onRemoveCallback)
        {
            _cache.Insert(key, value, dependencies, absoluteExpiration, slidingExpiration, priority, onRemoveCallback);
        }

        public object Remove(string key)
        {
            return _cache.Remove(key);
        }

        public object this[string key]
        {
            get { return _cache[key]; }
            set { _cache[key] = value;}
        }

        public object Get(string key)
        {
            return _cache.Get(key);
        }
*/
    }
}
