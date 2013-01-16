using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using System.Net;
using System.Collections.Specialized;

namespace BBC.Dna.Common
{
    public class SignalBase<T> : ISignalBase
    {
        //cache and db objects
        private Dictionary<string, object> _objects;
        public Dictionary<string, object> InternalObjects
        {
            get { return _objects; }
        }
        private int MaxCacheItemSize = 0;
        private string MaxCacheItemSizeKey = string.Empty;
        protected ICacheManager _cache;
        protected IDnaDiagnostics _dnaDiagnostics;
        protected IDnaDataReaderCreator _readerCreator;
        protected const string _lastUpdateCacheKey = "LASTUPDATE";

        //Delegates
        protected delegate void InitialiseObjectDelegate(params object[] args);
        protected event InitialiseObjectDelegate InitialiseObject;
        protected delegate bool HandleSignalDelegate(NameValueCollection args);
        protected Delegate HandleSignalObject;
        protected delegate NameValueCollection GetStatsDelegate();
        protected Delegate GetStatsObject;

        //server addresses
        protected List<string> _ripleyServerAddresses;
        protected List<string> _dotNetServerAddresses;

        /// <summary>
        /// The signal that this object listens for
        /// </summary>
        public string SignalKey
        {
            get;
            set;
        }

        /// <summary>
        /// Constructor complete with signal code
        /// </summary>
        /// <param name="dnaDataReaderCreator"></param>
        /// <param name="dnaDiagnostics"></param>
        /// <param name="caching"></param>
        /// <param name="signalKey"></param>
        /// <param name="ripleyServerAddresses"></param>
        /// <param name="dotNetServerAddresses"></param>
        public SignalBase(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics,
            ICacheManager caching, string signalKey, List<string> ripleyServerAddresses, List<string> dotNetServerAddresses)
        {
            _objects = new Dictionary<string,object>();
            _readerCreator = dnaDataReaderCreator;
            _dnaDiagnostics = dnaDiagnostics;
            _cache = caching;
            SignalKey = signalKey;
            _ripleyServerAddresses = ripleyServerAddresses;
            _dotNetServerAddresses = dotNetServerAddresses;
        }

        /// <summary>
        /// Returns the object which is cached
        /// </summary>
        /// <returns></returns>
        protected object GetCachedObject(params object[] args)
        {
            CheckVersionInCache(args);
            var cacheKey = GetCacheKey(args);

            if(_objects.ContainsKey(cacheKey))
            {
                return _objects[cacheKey];
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Clears the cached object
        /// </summary>
        public void Clear()
        {
            var keys = _objects.Keys.ToArray();
            foreach (var key in keys)
            {
                _objects.Remove(key);
                _cache.Remove(key);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="signalType"></param>
        /// <param name="args"></param>
        /// <returns></returns>
        public bool HandleSignal(string signalType, NameValueCollection args)
        {
            if (signalType.ToUpper() == SignalKey.ToUpper())
            {
                if (HandleSignalObject != null)
                {
                    return (bool)HandleSignalObject.DynamicInvoke(args);
                }
            }
            return false;
        }

        /// <summary>
        /// Returns unique cache key per object
        /// </summary>
        /// <returns></returns>
        static public string GetCacheKey(params object[] args)
        {
            var key = string.Format(@"{0}|", typeof(T).Name);
            return args.Aggregate(key, (current, arg) => current + (arg + "|"));
        }

        /// <summary>
        /// Returns unique cache key per object
        /// </summary>
        /// <returns></returns>
        static public string GetCacheKeyLastUpdate(params object[] args)
        {
            return GetCacheKey(args) + "|" + _lastUpdateCacheKey;
            
        }

        /// <summary>
        /// Checks if the current version of object up to date with cache
        /// </summary>
        protected void CheckVersionInCache(params object[] args)
        {
            var cacheKey = GetCacheKey(args);
            var cacheLastUpdateKey = GetCacheKeyLastUpdate(args);

            DateTime cacheLastUpdate = DateTime.MinValue;
            try
            {
                if (_cache.Contains(cacheLastUpdateKey))
                {
                    cacheLastUpdate = (DateTime)_cache.GetData(cacheLastUpdateKey);
                }
            }
            catch(Exception e)
            {
                _dnaDiagnostics.WriteExceptionToLog(e);
            }

            DateTime localLastUpdate = DateTime.MaxValue;
            if (_objects.ContainsKey(cacheLastUpdateKey))
            {
                localLastUpdate = (DateTime)_objects[cacheLastUpdateKey];
            }

            if (localLastUpdate == cacheLastUpdate && _objects.ContainsKey(cacheKey))
            {//everything up to date
                return;
            }

            object tempObject = null;
            try
            {
                //get new object
                if (_cache.Contains(cacheKey))
                {
                    tempObject = _cache.GetData(cacheKey);
                }
                if (_cache.Contains(cacheLastUpdateKey))
                {
                    cacheLastUpdate = (DateTime)_cache.GetData(cacheLastUpdateKey);
                }

            }
            catch (Exception e)
            {
                _dnaDiagnostics.WriteExceptionToLog(e);
            }
            if(tempObject != null)
            {//got a valid object
                if (_objects.ContainsKey(cacheLastUpdateKey))
                {
                    _objects[cacheLastUpdateKey] = cacheLastUpdate;
                }
                else
                {
                    _objects.Add(cacheLastUpdateKey, cacheLastUpdate);
                }

                if (_objects.ContainsKey(cacheKey))
                {
                    _objects[cacheKey] = tempObject;
                }
                else
                {
                    _objects.Add(cacheKey, tempObject);
                }
                return;
            }

            if (_objects.ContainsKey(cacheKey))
            {//no update but have an object so use it
                return;
            }
            
            //no object in cache or cache not available
            if (InitialiseObject != null)
            {
                //InitialiseObject.DynamicInvoke(args);
                InitialiseObject(args);
            }
            else
            {
                throw new NotImplementedException();
            }

        }

        /// <summary>
        /// Adds the object to the internal cache and distrubted version
        /// </summary>
        /// <param name="cacheKey"></param>
        /// <param name="cacheLastUpdateKey"></param>
        /// <param name="obj"></param>
        protected void AddToInternalObjects(string cacheKey, string cacheLastUpdateKey, object obj)
        {
            
            var saveDate = DateTime.Now;
            if (_objects.ContainsKey(cacheKey))
            {
                _objects[cacheKey] = obj;
            }
            else
            {
                _objects.Add(cacheKey, obj);
            }
            _cache.Add(cacheKey, _objects[cacheKey]);

            if (_objects.ContainsKey(cacheLastUpdateKey))
            {
                _objects[cacheLastUpdateKey] = saveDate;
            }
            else
            {
                _objects.Add(cacheLastUpdateKey, saveDate);
            }
            _cache.Add(cacheLastUpdateKey, _objects[cacheLastUpdateKey]);

            if (_cache.GetType() == typeof(MemcachedCacheManager))
            {
                var cachedObjectSize = ((MemcachedCacheManager)_cache).LastCachedOjectSize;
                if (MaxCacheItemSize < cachedObjectSize)
                {
                    MaxCacheItemSize = cachedObjectSize;
                    MaxCacheItemSizeKey = cacheKey;
                }
            }
            
        }

        ///// <summary>
        ///// Copies current version to cache
        ///// </summary>
        //protected void AddAllItemsToCache()
        //{
        //    try
        //    {
        //        DnaDiagnostics.Default.WriteTimedEventToLog("CACHING", "About to add all items to cache");
        //        var keys = _objects.Keys.ToArray();
        //        foreach (var key in keys)
        //        {
        //            _cache.Add(key, _objects[key]);
        //        }
        //        DnaDiagnostics.Default.WriteTimedEventToLog("CACHING", "Finished adding items to cache");
        //    }
        //    catch (Exception e)
        //    {
        //        _dnaDiagnostics.WriteExceptionToLog(e);
        //    }
        //}

        /// <summary>
        /// Sends the signal to other machines to refresh caches
        /// </summary>
        protected void SendSignals()
        {
            SendSignals(null);
        }

        /// <summary>
        /// Sends the signal to other machines to refresh caches
        /// </summary>
        /// <param name="queryStringData">the querystring data WITHOUT the action value</param>
        protected void SendSignals(NameValueCollection queryStringData)
        {
            if (_ripleyServerAddresses == null && _dotNetServerAddresses == null)
            {
                _dnaDiagnostics.WriteWarningToLog("SignalBase.SendSignals", "Unable to send signal as no addresses specificied");
                return;
            }
            if (_ripleyServerAddresses != null)
            {
                //send signals synchronously if only one - helps with automatic testing
                var sync = (_ripleyServerAddresses.Count == 1);
                foreach (var server in _ripleyServerAddresses)
                {
                    SendSignal(server, "signal", queryStringData, sync);
                }
            }
            if (_dotNetServerAddresses != null)
            {
                var sync = (_dotNetServerAddresses.Count == 1);
                foreach (var server in _dotNetServerAddresses)
                {
                    SendSignal(server, "dnasignal", queryStringData, sync);
                }
            }
        }

        /// <summary>
        /// Sends the individual machine signal
        /// </summary>
        /// <param name="serverName"></param>
        /// <param name="pageName"></param>
        /// <param name="queryStringData"></param>
        private void SendSignal(string serverName, string pageName, NameValueCollection queryStringData, bool sendSync)
        {
            string request = string.Format("http://{0}/dna/moderation/{1}?action={2}", serverName, pageName, SignalKey);

            if (queryStringData != null)
            {
                foreach (var key in queryStringData.AllKeys)
                {
                    request += string.Format("&{0}={1}", key, queryStringData[key]);
                }
            }

            Uri URL = new Uri(request);
            _dnaDiagnostics.WriteToLog("SendingSignal", request);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
            webRequest.Timeout = 5000;//timeout after 10s
            try
            {
                // Try to send the request and get the response
                if (sendSync)
                {
                    webRequest.GetResponse();
                }
                else
                {
                    webRequest.BeginGetResponse(new AsyncCallback(FinishSignalRequest), null);
                }
            }
            catch (Exception ex)
            {
                // Problems!
                _dnaDiagnostics.WriteWarningToLog("Signal", "Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
            }

        }

        /// <summary>
        /// Asynchronous method for sending signals
        /// </summary>
        /// <param name="result"></param>
        static private void FinishSignalRequest(IAsyncResult result)
        { 
            //do nothing as we dont really care about the response as we dont wait for it.
        }

        /// <summary>
        /// Reloads object from cache
        /// </summary>
        public void ReInitialise()
        {
            if (InitialiseObject != null)
            {
                InitialiseObject.DynamicInvoke(new object[1]);
            }
            else
            {
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// Get stats
        /// </summary>
        /// <returns></returns>
        public SignalStatusMember GetStats(Type type)
        {
            var signalStatusMember = new SignalStatusMember() { Name = type.AssemblyQualifiedName };
            
            if (GetStatsObject != null)
            {
                signalStatusMember.Values =  (NameValueCollection)GetStatsObject.DynamicInvoke();

                if (signalStatusMember.Values == null)
                {
                    signalStatusMember.Values = new NameValueCollection();
                }
                signalStatusMember.Values.Add("MaxCacheItemSize", MaxCacheItemSize.ToString());
                signalStatusMember.Values.Add("MaxCacheItemSizeKey", MaxCacheItemSizeKey);
            }
            return signalStatusMember;
        }

        /// <summary>
        /// Checks if the current version of object up to date with cache
        /// </summary>
        public DateTime GetLastUpdated(params object[] args)
        {
            var cacheLastUpdateKey = GetCacheKeyLastUpdate(args);

            DateTime cacheLastUpdate = DateTime.MinValue;
            try
            {
                if (_cache.Contains(cacheLastUpdateKey))
                {
                    cacheLastUpdate = (DateTime)_cache.GetData(cacheLastUpdateKey);
                }
            }
            catch (Exception e)
            {
                _dnaDiagnostics.WriteExceptionToLog(e);
            }

            return cacheLastUpdate;

        }
    }
}
