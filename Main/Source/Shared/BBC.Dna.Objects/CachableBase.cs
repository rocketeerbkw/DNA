using System;
using System.Linq;
using BBC.Dna.Data;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;

namespace BBC.Dna.Objects
{
    [Serializable]
    public abstract class CachableBase<T> : ICloneable
    {
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
            var ms = new MemoryStream();
            var bf = new BinaryFormatter();
            bf.Serialize(ms, this);
            ms.Position = 0;
            object obj = bf.Deserialize(ms);
            ms.Close();
            return obj;
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
