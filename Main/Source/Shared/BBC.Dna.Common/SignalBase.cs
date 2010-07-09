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
        protected T _object;
        private DateTime _lastUpdate = DateTime.MaxValue;
        protected ICacheManager _cache;
        protected IDnaDiagnostics _dnaDiagnostics;
        protected IDnaDataReaderCreator _readerCreator;
        const string _lastUpdateCacheKey = "LASTUPDATE";
        

        //Delegates
        protected delegate T InitialiseObjectDelegate();
        protected Delegate InitialiseObject;
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
        public T GetCachedObject()
        {
            CheckVersionInCache();
            return _object;
        }

        /// <summary>
        /// Clears the cached object
        /// </summary>
        public void Clear()
        {
            _object = default(T);
            _cache.Remove(GetCacheKey());
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
            var key = string.Format(@"{0}|", typeof(T).AssemblyQualifiedName);
            return args.Aggregate(key, (current, arg) => current + (arg + "|"));
        }

        /// <summary>
        /// Checks if the current version of object up to date with cache
        /// </summary>
        protected void CheckVersionInCache()
        {
            DateTime cacheLastUpdate = DateTime.MinValue;
            try
            {
                if (_cache.Contains(GetCacheKey(_lastUpdateCacheKey)))
                {
                    cacheLastUpdate = (DateTime)_cache.GetData(GetCacheKey(_lastUpdateCacheKey));
                }
            }
            catch(Exception e)
            {
                _dnaDiagnostics.WriteExceptionToLog(e);
            }
            if (_lastUpdate == cacheLastUpdate && _object != null)
            {//everything up to date
                return;
            }

            T tempObject = default(T);
            try
            {
                //get new object
                if (_cache.Contains(GetCacheKey()))
                {
                    tempObject = (T)_cache.GetData(GetCacheKey());
                }
                if (_cache.Contains(GetCacheKey(_lastUpdateCacheKey)))
                {
                    _lastUpdate = (DateTime)_cache.GetData(GetCacheKey(_lastUpdateCacheKey));
                }

            }
            catch (Exception e)
            {
                _dnaDiagnostics.WriteExceptionToLog(e);
            }
            if(tempObject != null)
            {//got a valid object
                _object = tempObject;
                return;
            }

            if(_object != null)
            {//no update but have an object so use it
                return;
            }
            
            //no object in cache or cache not available
            if (InitialiseObject != null)
            {
                _object = (T)InitialiseObject.DynamicInvoke();
                UpdateCache();
            }
            else
            {
                throw new NotImplementedException();
            }

        }

        /// <summary>
        /// Copies current version to cache
        /// </summary>
        protected void UpdateCache()
        {
            try
            {
                _lastUpdate = DateTime.Now;
                _cache.Add(GetCacheKey(), _object);
                _cache.Add(GetCacheKey(_lastUpdateCacheKey), _lastUpdate);
            }
            catch (Exception e)
            {
                _dnaDiagnostics.WriteExceptionToLog(e);
            }
        }

        /// <summary>
        /// Updates cache and sends signal
        /// </summary>
        protected void UpdateCacheAndSignal()
        {
            UpdateCacheAndSignal(null);
        }

        /// <summary>
        /// Updates and send signal with querystring data
        /// </summary>
        /// <param name="queryStringData"></param>
        protected void UpdateCacheAndSignal(NameValueCollection queryStringData)
        {
            UpdateCache();
            SendSignals(queryStringData);
        }

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
                foreach (var server in _ripleyServerAddresses)
                {
                    SendSignal(server, "signal", queryStringData);
                }
            }
            if (_dotNetServerAddresses != null)
            {
                foreach (var server in _dotNetServerAddresses)
                {
                    SendSignal(server, "dnasignal", queryStringData);
                }
            }
        }

        /// <summary>
        /// Sends the individual machine signal
        /// </summary>
        /// <param name="serverName"></param>
        /// <param name="pageName"></param>
        /// <param name="queryStringData"></param>
        private void SendSignal(string serverName, string pageName, NameValueCollection queryStringData)
        {
            string request = string.Format("http://{0}/dna/h2g2/{1}?action={2}", serverName, pageName, SignalKey);

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
            try
            {
                // Try to send the request and get the response
                webRequest.BeginGetResponse(new AsyncCallback(FinishSignalRequest), null);
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
                _object = (T)InitialiseObject.DynamicInvoke();
                UpdateCache();
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
        public SignalStatusMember GetStats()
        {
            var signalStatusMember = new SignalStatusMember(){Name = typeof(T).AssemblyQualifiedName};
            signalStatusMember.Values.Add("LastCacheUpdate", _lastUpdate.ToString());
            if (GetStatsObject != null)
            {
                signalStatusMember.Values =  (NameValueCollection)GetStatsObject.DynamicInvoke();

                if (signalStatusMember.Values == null)
                {
                    signalStatusMember.Values = new NameValueCollection();
                }
            }
            return signalStatusMember;
        }

        
    }
}
