﻿using System;
using System.Linq;
using BBC.Dna.Data;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;
using BBC.Dna.Api;
using System.Configuration;
using System.Xml.Serialization;

namespace BBC.Dna.Common
{
    [Serializable]
    public abstract class CachableBase<T> : ICloneable
    {
        //minutes to cache for a sliding window
        [XmlIgnore]
        public int CacheSlidingWindow {get;set;}
        public CachableBase()
        {
            CacheSlidingWindow = 5;
            if (!String.IsNullOrEmpty(ConfigurationManager.AppSettings["CacheSlidingWindow"]))
            {
                int value = 0;
                Int32.TryParse(ConfigurationManager.AppSettings["CacheSlidingWindow"], out value);
                if (value > 0)
                {
                    CacheSlidingWindow = value;
                }
            }
        }

        /// <summary>
        /// Check if the object is cachable
        /// </summary>
        /// <param name="readerCreator">Reader to use to verify object</param>
        /// <returns></returns>
        public abstract bool IsUpToDate(IDnaDataReaderCreator readerCreator);

        #region ICloneable Members
        /// <summary>
        /// Clones the current object
        /// </summary>
        /// <returns></returns>
        public object Clone()
        {
            using (var ms = new MemoryStream())
            {
                var bf = new BinaryFormatter();
                bf.Serialize(ms, this);
                ms.Position = 0;
                return bf.Deserialize(ms);
            }
        }

        #endregion

        /// <summary>
        /// Creates a cache key from the args passed
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public string GetCacheKey(params object[] args)
        {
            var key = string.Format(@"{0}|", typeof(T).AssemblyQualifiedName);
            return args.Aggregate(key, (current, arg) => current + (arg + "|"));
        }

    }
}
