using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna.Utils
{
    public class StaticCacheManager : ICacheManager
    {
        private static readonly Dictionary<string, object> InternalCache = new Dictionary<string, object>();

        public void Add(string key, object value)
        {
            if (Contains(key))
            {
                InternalCache[key] = value;
            }
            else
            {
                InternalCache.Add(key, value);
            }
        }

        public void Add(string key, object value, CacheItemPriority scavengingPriority, ICacheItemRefreshAction refreshAction, params ICacheItemExpiration[] expirations)
        {
            throw new NotImplementedException();
        }

        public bool Contains(string key)
        {
            return InternalCache.ContainsKey(key);
        }

        public void Flush()
        {
            InternalCache.Clear();
        }

        public object GetData(string key)
        {
            if(Contains(key))
            {
                return InternalCache[key];
            }
            return null;
        }

        public void Remove(string key)
        {
            if (Contains(key))
            {
               InternalCache.Remove(key);
            }
        }

        public int Count
        {
            get { return InternalCache.Count; }
        }

        public object this[string key]
        {
            get
            {
                if(Contains(key))
                {
                    return InternalCache[key];
                }
                return null;
            }
        }
    }
}
