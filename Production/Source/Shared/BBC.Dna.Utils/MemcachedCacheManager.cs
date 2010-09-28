using System;
using System.Collections;
using System.Collections.Specialized;
using BBC.Dna.Utils;
using Memcached.ClientLibrary;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using Microsoft.Practices.EnterpriseLibrary.Common.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Caching.Configuration;
using System.Xml;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// The DNA Cache object. This class is used to provide a layer between DNA and the .NET Web request.
    /// It wraps all the required methods and properties that DNA requires.
    /// </summary>
    [ConfigurationElementType(typeof(CustomCacheManagerData))]
    public class MemcachedCacheManager : Microsoft.Practices.EnterpriseLibrary.Caching.ICacheManager, IDisposable
    {
        private MemcachedClient _mc = null;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="configuration">Convfiguration</param>
        public MemcachedCacheManager(NameValueCollection configuration)
        {
            using (new Tracer(this.GetType().Namespace))
                {
                    try
                    {
                        Logger.Write(new LogEntry() { Message = "Beginning Memcached Initialisation", Severity = System.Diagnostics.TraceEventType.Information });

                        _mc = new MemcachedClient();
                        SockIOPool pool = SockIOPool.GetInstance();
                        for (int i = 0; i < configuration.Count; i++)
                        {
                            if(configuration.Keys[i].ToUpper() == "POOLNAME")
                            {
                                _mc.PoolName = configuration[i];
                                pool = SockIOPool.GetInstance(_mc.PoolName);
                            }
                        }
                        

                        //default values
                        //pool.SetServers(serverlist);
                        pool.InitConnections = 3;
                        pool.MinConnections = 3;
                        pool.MaxConnections = 5;
                        pool.SocketConnectTimeout = 1000;
                        pool.SocketTimeout = 3000;
                        pool.MaintenanceSleep = 30;
                        pool.Failover = true;
                        pool.Nagle = false;
                        _mc.EnableCompression = true;

                        //check for configuration
                        for (int i = 0; i < configuration.Count; i++)
                        {
                            switch (configuration.Keys[i].ToUpper())
                            {
                                case "SERVERLIST":
                                    pool.SetServers(configuration[i].Split(','));
                                    break;

                                case "INITCONNECTIONS":
                                    pool.InitConnections = Int32.Parse(configuration[i].ToString());
                                    break;

                                case "MINCONNECTIONS":
                                    pool.MinConnections = Int32.Parse(configuration[i].ToString());
                                    break;

                                case "MAXCONNECTIONS":
                                    pool.MaxConnections = Int32.Parse(configuration[i].ToString());
                                    break;

                                case "SOCKETCONNECTTIMEOUT":
                                    pool.SocketConnectTimeout = Int32.Parse(configuration[i].ToString());
                                    break;

                                case "SOCKETTIMEOUT":
                                    pool.SocketTimeout = Int32.Parse(configuration[i].ToString());
                                    break;

                                case "MAINTENANCESLEEP":
                                    pool.MaintenanceSleep = Int32.Parse(configuration[i].ToString());
                                    break;

                                case "FAILOVER":
                                    pool.Failover = bool.Parse(configuration[i].ToString());
                                    break;

                                case "NAGLE":
                                    pool.Nagle = bool.Parse(configuration[i].ToString());
                                    break;

                                case "ENABLECOMPRESSION":
                                    _mc.EnableCompression = bool.Parse(configuration[i].ToString());
                                    break;
                            }
                        }

                        if (pool.Servers.Count == 0)
                        {
                            Logger.Write(new LogEntry() { Message = "No servers defined for caching", Severity = System.Diagnostics.TraceEventType.Error });
                            throw new Exception("No servers defined for memcached caching");
                        }
                        pool.Initialize();
                        Logger.Write(new LogEntry() { Message = "Ending Memcached Initialisation", Severity = System.Diagnostics.TraceEventType.Information });
                    }
                    catch (Exception e)
                    {
                        _mc = null;
                        throw e;
                    }
                }

        }

        /// <summary>
        /// Returns stats for servers or all servers
        /// </summary>
        /// <param name="servers">The list of servers to get stats for or null for all</param>
        /// <returns>Hashtable containing all server stats</returns>
        public Hashtable GetStats(ArrayList servers)
        {
            return _mc.Stats(servers);
        }

        public int LastCachedOjectSize { get; private set; }

        /// <summary>
        /// Returns stats for servers or all servers
        /// </summary>
        /// <param name="servers">The list of servers to get stats for or null for all</param>
        /// <returns>Hashtable containing all server stats</returns>
        public Hashtable GetStats()
        {
            return GetStats(null);
        }


        /// <summary>
        /// Returns stats as xml document
        /// </summary>
        /// <returns></returns>
        public XmlElement GetStatsXml()
        {
            XmlDocument xml = new XmlDocument();
            XmlNode xmlEl = xml.AppendChild(xml.CreateElement("MEMCACHED_STATUS"));
            try
            {
                Hashtable stats = GetStats();
                if(stats.Keys.Count == 0)
                {
                    throw new Exception("Empty stats object - no valid servers");
                }
                foreach (string key in stats.Keys)
                {
                    xmlEl = xmlEl.AppendChild(xml.CreateElement("SERVER"));
                    xmlEl.Attributes.Append(xml.CreateAttribute("ADDRESS"));
                    xmlEl.Attributes["ADDRESS"].InnerText = key;
                    Hashtable serverStats = (Hashtable)stats[key];
                    foreach (string subKey in serverStats.Keys)
                    {
                        var xmlElChild = xmlEl.AppendChild(xml.CreateElement(subKey.ToUpper()));
                        xmlElChild.InnerText = serverStats[subKey].ToString();
                    }
                }
            }
            catch (Exception e)
            {
                xmlEl.InnerText = "Unable to get Memcached stats:" + e.Message;
            }
            return xml.DocumentElement;
        }

        /// <summary>
        /// Returns the internal cache object
        /// </summary>
        public MemcachedClient memcachedClient { get { return _mc; } }

        #region ICacheManager Members
        /// <summary>
        /// Adds a permanent object to the cache
        /// </summary>
        /// <param name="key">The identifier</param>
        /// <param name="o">The object to cache</param>
        public void Add(string key, object o)
        {
            Add(key, o, CacheItemPriority.NotRemovable, null, new NeverExpired());
        }

        /// <summary>
        /// Adds to cache
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <param name="scavengingPriority"></param>
        /// <param name="refreshAction"></param>
        /// <param name="expirations"></param>
        public void Add(string key, object value, CacheItemPriority scavengingPriority, ICacheItemRefreshAction refreshAction, params ICacheItemExpiration[] expirations)
        {
            if(String.IsNullOrEmpty(key))
            {
                return;
            }

            key = DnaHasher.GenerateHashString(key);
            using (new Tracer(this.GetType().ToString()))
            {
                if (expirations == null || expirations.Length == 0)
                {
                    _mc.Set(key, value);
                }
                else
                {
                    DateTime expiry = DateTime.Now.AddDays(1);
                    foreach (ICacheItemExpiration item in expirations)
                    {
                        switch (item.GetType().Name.ToString().ToUpper())
                        {
                            case "ABSOLUTETIME":
                                expiry = ((AbsoluteTime)item).AbsoluteExpirationTime;
                                break;

                            case "NEVEREXPIRED":
                                expiry = DateTime.Now.AddYears(1);
                                break;

                            case "SLIDINGTIME":
                                expiry = DateTime.Now.Add(((SlidingTime)item).ItemSlidingExpiration);
                                break;
                        }
                    }

                    int tries = 20;
                    bool setSuccess = false;
                    while (!setSuccess && tries > 0)
                    {
                        setSuccess = _mc.Set(key, value, expiry);
                        if (!setSuccess)
                        {
                            if (_mc.LastError != null && _mc.LastError.IndexOf("object too large for cache") >= 0)
                            {
                                return;
                            }
                        }
                        tries--;
                    }

                    //failed to set
                    if (!setSuccess)
                    {
                        Logger.Write(new LogEntry(){Message="Failed to set in memcached", Severity= System.Diagnostics.TraceEventType.Error});
                        DnaDiagnostics.Default.WriteWarningToLog("CACHING", _mc.LastError);
                    }

                    LastCachedOjectSize = _mc.CachedObjectSize;
                }

            }
        }

        /// <summary>
        /// returns true if cache contains key
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public bool Contains(string key)
        {
            return _mc.KeyExists(DnaHasher.GenerateHashString(key));
        }

        /// <summary>
        /// Returns count of items in cache
        /// </summary>
        public int Count
        {
            get
            {
                IDictionary stats = _mc.Stats();
                return Int32.Parse(stats["total_items"].ToString());
            }
        }

        /// <summary>
        /// Removes all items from cache
        /// </summary>
        public void Flush()
        {
            _mc.FlushAll();
        }

        /// <summary>
        /// Returns data from cache
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public object GetData(string key)
        {
            return _mc.Get(DnaHasher.GenerateHashString(key));
        }

        /// <summary>
        /// removes the object from cache
        /// </summary>
        /// <param name="key"></param>
        public void Remove(string key)
        {
            _mc.Delete(DnaHasher.GenerateHashString(key));
        }

        /// <summary>
        /// Returns data from cache
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public object this[string key]
        {
            get { return _mc.Get(DnaHasher.GenerateHashString(key)); }
        }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            try
            {
                //close the pool down
                SockIOPool.GetInstance().Shutdown();
            }
            catch { }
            _mc = null;
        }

        #endregion
    }
}
