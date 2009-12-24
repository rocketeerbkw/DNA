using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.ServiceProcess;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna.Component;
using BBC.Dna.Utils;
using Memcached.ClientLibrary;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class Memcached_Tests
    {
        ServiceController service = new ServiceController("memcached Server");
        TimeSpan timeout = TimeSpan.FromMilliseconds(5000);
        int runs = 10;

        [TestCleanup]
        public void ShutDown()
        {
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            
            /*
            //stop memcached service
            if (service.CanStop)
            {
                service.Stop();
                service.WaitForStatus(ServiceControllerStatus.Stopped, timeout);
            }*/
            //start memcached service
            if (service.Status != ServiceControllerStatus.Running)
            {
                service.Start();
                service.WaitForStatus(ServiceControllerStatus.Running, timeout);
            }

        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetCompressibleFile()
        {
            NameValueCollection settings = new NameValueCollection();
            settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
            settings.Add("poolname", Guid.NewGuid().ToString());
            using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
            {
                string keyBase = "testKey" + Guid.NewGuid().ToString();
                string obj = File.ReadAllText("../../../Tests/Legacy Tests/FunctionalTests/Memcached.ClientLibrary/compressablefile.txt");
                Console.WriteLine("Compressible File Metrics obj size:" + obj.Length + " bytes");


                long begin = DateTime.Now.Ticks;
                for (int i = 0; i < runs; i++)
                {
                    _mc.Add(keyBase + i, obj);
                }
                long end = DateTime.Now.Ticks;
                long time = end - begin;

                Console.WriteLine(runs + " sets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per set)");

                begin = DateTime.Now.Ticks;
                int hits = 0;
                int misses = 0;
                for (int i = 0; i < runs; i++)
                {
                    string str = (string)_mc.GetData(keyBase + i);
                    if (str != null)
                        ++hits;
                    else
                        ++misses;
                }
                end = DateTime.Now.Ticks;
                time = end - begin;

                Console.WriteLine(runs + " sets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per set)");
                Console.WriteLine("Cache hits: " + hits.ToString());
                Console.WriteLine("Cache misses: " + misses.ToString());
                Assert.IsTrue(misses == 0);
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetBiggerThan1MegFile()
        {
            NameValueCollection settings = new NameValueCollection();
            settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
            settings.Add("poolname", Guid.NewGuid().ToString());
            using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
            {
                string keyBase = "testKey" + Guid.NewGuid().ToString();
                string obj = File.ReadAllText("../../../Tests/Legacy Tests/FunctionalTests/Memcached.ClientLibrary/biggerthan1megfile.txt");
                Console.WriteLine("Big File Metrics obj size:" + obj.Length + " bytes");

                int _bigRun = 10;

                long begin = DateTime.Now.Ticks;
                for (int i = 0; i < _bigRun; i++)
                {
                    _mc.Add(keyBase + i, obj);
                }
                long end = DateTime.Now.Ticks;
                long time = end - begin;

                Console.WriteLine(_bigRun + " sets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / _bigRun + "ms per set)");

                begin = DateTime.Now.Ticks;
                int hits = 0;
                int misses = 0;
                for (int i = 0; i < _bigRun; i++)
                {
                    string str = (string)_mc.GetData(keyBase + i);
                    if (str != null)
                        ++hits;
                    else
                        ++misses;
                }
                end = DateTime.Now.Ticks;
                time = end - begin;

                Console.WriteLine(_bigRun + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / _bigRun + "ms per get)");
                Console.WriteLine("Cache hits: " + hits.ToString());
                Console.WriteLine("Cache misses: " + misses.ToString());
                Assert.IsTrue(misses == 0);
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetSingleLocalServer()
        {
            
            
            NameValueCollection settings = new NameValueCollection();
            settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
            settings.Add("poolname", Guid.NewGuid().ToString());
            using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
            {

                string keyBase = "testKey" + Guid.NewGuid().ToString();
                string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";
                Console.WriteLine("Single local server Metrics obj size:" + obj.Length + " bytes");

                long begin = DateTime.Now.Ticks;
                for (int i = 0; i < runs; i++)
                {
                    _mc.Add(keyBase + i, obj);
                }
                long end = DateTime.Now.Ticks;
                long time = end - begin;

                Console.WriteLine(runs + " sets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per set)");

                begin = DateTime.Now.Ticks;
                int hits = 0;
                int misses = 0;
                for (int i = 0; i < runs; i++)
                {
                    string str = (string)_mc.GetData(keyBase + i);
                    if (str != null)
                        ++hits;
                    else
                        ++misses;
                }
                end = DateTime.Now.Ticks;
                time = end - begin;

                Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");
                Console.WriteLine("Cache hits: " + hits.ToString());
                Console.WriteLine("Cache misses: " + misses.ToString());
                Assert.IsTrue(misses == 0);
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetSingleRemoteServer()
        {
            try
            {
                NameValueCollection settings = new NameValueCollection();
                settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
                settings.Add("poolname", Guid.NewGuid().ToString());
                using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
                {

                    string keyBase = "testKey" + Guid.NewGuid().ToString();
                    string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";
                    Console.WriteLine("Single Remote server Metrics obj size:" + obj.Length + " bytes");

                    long begin = DateTime.Now.Ticks;
                    for (int i = 0; i < runs; i++)
                    {
                        _mc.Add(keyBase + i, obj);
                    }
                    long end = DateTime.Now.Ticks;
                    long time = end - begin;

                    Console.WriteLine(runs + " sets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per set)");

                    begin = DateTime.Now.Ticks;
                    int hits = 0;
                    int misses = 0;
                    for (int i = 0; i < runs; i++)
                    {
                        string str = (string)_mc.GetData(keyBase + i);
                        if (str != null)
                            ++hits;
                        else
                            ++misses;
                    }
                    end = DateTime.Now.Ticks;
                    time = end - begin;

                    Console.WriteLine(runs + " sets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per set)");
                    Console.WriteLine("Cache hits: " + hits.ToString());
                    Console.WriteLine("Cache misses: " + misses.ToString());
                    Assert.IsTrue(misses == 0);
                }
            }
            finally
            {//reset to single source
                StartUp();
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetWithMultipleHosts()
        {
            try
            {
                NameValueCollection settings = new NameValueCollection();
                settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"] + "," + ConfigurationManager.AppSettings["SecondaryMemcachedServer"]);
                settings.Add("poolname", Guid.NewGuid().ToString());
                using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
                {
                    _mc.Flush();
                    string keyBase = "testKey" + Guid.NewGuid().ToString();
                    string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";
                    Console.WriteLine("Multiple servers Metrics obj size:" + obj.Length + " bytes");


                    long begin = DateTime.Now.Ticks;
                    for (int i = 0; i < runs; i++)
                    {
                        _mc.Add(keyBase + i, obj);
                    }
                    long end = DateTime.Now.Ticks;
                    long time = end - begin;

                    Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");

                    begin = DateTime.Now.Ticks;
                    int hits = 0;
                    int misses = 0;
                    for (int i = 0; i < runs; i++)
                    {
                        string str = (string)_mc.GetData(keyBase + i);
                        if (str != null)
                            ++hits;
                        else
                            ++misses;
                    }
                    end = DateTime.Now.Ticks;
                    time = end - begin;

                    Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");
                    Console.WriteLine("Cache hits: " + hits.ToString());
                    Console.WriteLine("Cache misses: " + misses.ToString());
                    Assert.IsTrue(misses == 0);
                }
            }
            finally
            {//reset to single source
                StartUp();
            }
        }


        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetWithExpiryDate()
        {
            NameValueCollection settings = new NameValueCollection();
            settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
            settings.Add("poolname", Guid.NewGuid().ToString());
            using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
            {
                string keyBase = "testKey" + Guid.NewGuid().ToString();
                string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";

                //add with a day expirey
                _mc.Add(keyBase, obj, CacheItemPriority.Normal, null, new AbsoluteTime(DateTime.Now.AddDays(1)));
                string str = (string)_mc.GetData(keyBase);
                Assert.IsTrue(str != null);

                //add with -2 sec expiry and wait for it to expiry
                keyBase = "testKey" + Guid.NewGuid().ToString();
                _mc.Add(keyBase, obj, CacheItemPriority.Normal, null, new AbsoluteTime(DateTime.Now.AddSeconds(2)));
                System.Threading.Thread.Sleep(5000);//sleep for 2
                str = (string)_mc.GetData(keyBase);
                Assert.IsTrue(str == null);// should be null as it should have expired
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetWithExpiryTimespan()
        {
            NameValueCollection settings = new NameValueCollection();
            settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
            settings.Add("poolname", Guid.NewGuid().ToString());
            using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
            {
                string keyBase = "testKey" + Guid.NewGuid().ToString();
                string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";

                //add with a day expirey
                _mc.Add(keyBase, obj, CacheItemPriority.Normal, null, new AbsoluteTime(new TimeSpan(24, 0, 0)));//span for a day
                string str = (string)_mc.GetData(keyBase);
                Assert.IsTrue(str != null);

                //add with -2 sec expiry and wait for it to expiry
                keyBase = "testKey" + Guid.NewGuid().ToString();
                _mc.Add(keyBase, obj, CacheItemPriority.Normal, null, new AbsoluteTime(new TimeSpan(0, 0, 1)));
                System.Threading.Thread.Sleep(5000);//sleep for 5
                str = (string)_mc.GetData(keyBase);
                Assert.IsTrue(str == null);// should be null as it should have expired
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetWithMultipleHostsAndSingleServerOutage()
        {
            try
            {
                NameValueCollection settings = new NameValueCollection();
                settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"] + "," + ConfigurationManager.AppSettings["SecondaryMemcachedServer"]);
                settings.Add("poolname", Guid.NewGuid().ToString());
                using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
                {
                    _mc.Flush();

                    string keyBase = "testKey" + Guid.NewGuid().ToString();
                    string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";
                    Console.WriteLine("Multiple servers Metrics obj size:" + obj.Length + " bytes");


                    long begin = DateTime.Now.Ticks;
                    for (int i = 0; i < runs; i++)
                    {
                        _mc.Add(keyBase + i, obj);
                    }
                    long end = DateTime.Now.Ticks;
                    long time = end - begin;

                    Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");
                    service.Stop();
                    service.WaitForStatus(ServiceControllerStatus.Stopped, timeout);
                    Console.WriteLine("Stoping one of the servers between set and get");

                    begin = DateTime.Now.Ticks;
                    int hits = 0;
                    int misses = 0;
                    for (int i = 0; i < runs; i++)
                    {
                        string str = (string)_mc.GetData(keyBase + i);
                        if (str != null)
                            ++hits;
                        else
                            ++misses;
                    }
                    end = DateTime.Now.Ticks;
                    time = end - begin;

                    Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");
                    Console.WriteLine("Cache hits: " + hits.ToString());
                    Console.WriteLine("Cache misses: " + misses.ToString());
                    Assert.IsTrue(misses != runs);



                    keyBase = "testKey" + Guid.NewGuid().ToString();
                    Console.WriteLine("Get and set after server downed obj size:" + obj.Length + " bytes");


                    begin = DateTime.Now.Ticks;
                    for (int i = 0; i < runs; i++)
                    {
                        _mc.Add(keyBase + i, obj);
                    }
                    end = DateTime.Now.Ticks;
                    time = end - begin;

                    Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");

                    begin = DateTime.Now.Ticks;
                    hits = 0;
                    misses = 0;
                    for (int i = 0; i < runs; i++)
                    {
                        string str = (string)_mc.GetData(keyBase + i);
                        if (str != null)
                            ++hits;
                        else
                            ++misses;
                    }
                    end = DateTime.Now.Ticks;
                    time = end - begin;

                    Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");
                    Console.WriteLine("Cache hits: " + hits.ToString());
                    Console.WriteLine("Cache misses: " + misses.ToString());
                    Assert.IsTrue(hits != 0);


                    //now restart failed server and see how memcached handles it
                    if (service.Status != ServiceControllerStatus.Running)
                    {
                        service.Start();
                        service.WaitForStatus(ServiceControllerStatus.Running, timeout);
                    }

                    keyBase = "testKey" + Guid.NewGuid().ToString();
                    Console.WriteLine("Get and set after downed server returns  obj size:" + obj.Length + " bytes");


                    begin = DateTime.Now.Ticks;
                    for (int i = 0; i < runs; i++)
                    {
                        _mc.Add(keyBase + i, obj);
                    }
                    end = DateTime.Now.Ticks;
                    time = end - begin;

                    Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");

                    begin = DateTime.Now.Ticks;
                    hits = 0;
                    misses = 0;
                    for (int i = 0; i < runs; i++)
                    {
                        string str = (string)_mc.GetData(keyBase + i);
                        if (str != null)
                            ++hits;
                        else
                            ++misses;
                    }
                    end = DateTime.Now.Ticks;
                    time = end - begin;

                    Console.WriteLine(runs + " gets: " + new TimeSpan(time).ToString() + "ms (" + (double)TimeSpan.FromTicks(time).Milliseconds / runs + "ms per get)");
                    Console.WriteLine("Cache hits: " + hits.ToString());
                    Console.WriteLine("Cache misses: " + misses.ToString());
                    Assert.IsTrue(hits != 0);

                    //check the distrubtion of keys...
                    MemcachedClient client = ((MemcachedCacheManager)_mc).memcachedClient;

                    DateTime t = DateTime.Now.AddSeconds(3.0);
                    while (t > DateTime.Now) { }

                    foreach (string server in SockIOPool.GetInstance(client.PoolName).Servers)
                    {
                        if (!String.IsNullOrEmpty(server))
                        {
                            ArrayList servers = new ArrayList();
                            servers.Add(server);
                            Hashtable stats = client.Stats(servers);

                            //int totalItems = Int32.Parse(((Hashtable)stats[server])["total_items"].ToString());
                            Console.WriteLine(String.Format("Server {0}: {1}", server, ((Hashtable)(client.Stats(servers))[server])["total_items"]));
                            //Assert.IsTrue(totalItems != 0);
                        }
                    }
                }
            }
            finally
            {//reset to single source
                StartUp();
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void Delete()
        {
            NameValueCollection settings = new NameValueCollection();
            settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
            settings.Add("poolname", Guid.NewGuid().ToString());
            using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
            {
                string keyBase = "testKey" + Guid.NewGuid().ToString();
                string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";

                //add with a day expirey
                _mc.Add(keyBase, obj);
                string str = (string)_mc.GetData(keyBase);
                Assert.IsTrue(str != null);

                //check if it exists
                Assert.IsTrue(_mc.Contains(keyBase));

                //remove key            
                _mc.Remove(keyBase);
                str = (string)_mc.GetData(keyBase);
                Assert.IsTrue(str == null);
                Assert.IsTrue(!_mc.Contains(keyBase));
            }


        }


        /// <summary>
        /// </summary>
        [TestMethod]
        public void FlushAll()
        {
            NameValueCollection settings = new NameValueCollection();
            settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
            settings.Add("poolname", Guid.NewGuid().ToString());
            using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
            {
                string keyBase = "testKey" + Guid.NewGuid().ToString();
                string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";

                //add with a day expirey
                _mc.Add(keyBase, obj);
                //WriteOutStats("After first add");
                string str = (string)_mc.GetData(keyBase);
                //WriteOutStats("After first get");
                Assert.IsTrue(str != null, "Test 1:Returned string should not be null");

                //check if it exists
                Assert.IsTrue(_mc.Contains(keyBase), "Test 2: Key should exist as it was just saved");

                //flush all keys
                _mc.Flush();
                str = (string)_mc.GetData(keyBase);
                Assert.IsTrue(str == null, "Test 3:Returned string should be null");
                Assert.IsTrue(!_mc.Contains(keyBase), "Test 4: Key should exist as it was just flushed");
            }


        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetWithServiceOutage()
        {
            try
            {
                NameValueCollection settings = new NameValueCollection();
                settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
                settings.Add("poolname", Guid.NewGuid().ToString());
                using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
                {
                    string keyBase = "testKey" + Guid.NewGuid().ToString();
                    string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";

                    //add
                    _mc.Add(keyBase, obj);
                    string str = (string)_mc.GetData(keyBase);
                    Assert.IsTrue(str != null);

                    //stop memcached service
                    service.Stop();
                    service.WaitForStatus(ServiceControllerStatus.Stopped, timeout);


                    str = (string)_mc.GetData(keyBase);
                    Assert.IsTrue(str == null);
                }
            }
            finally 
            {
                if (service.Status != ServiceControllerStatus.Running)
                {
                    service.Start();
                    service.WaitForStatus(ServiceControllerStatus.Running, timeout);
                }
            }

        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void GetAndSetAfterServiceOutage()
        {
            try
            {
                NameValueCollection settings = new NameValueCollection();
                settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
                settings.Add("poolname", Guid.NewGuid().ToString());
                using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
                {
                    string keyBase = "testKey" + Guid.NewGuid().ToString();
                    string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";

                    //add
                    _mc.Add(keyBase, obj);
                    string str = (string)_mc.GetData(keyBase);
                    Assert.IsTrue(str != null);

                    //stop memcached service
                    service.Stop();
                    service.WaitForStatus(ServiceControllerStatus.Stopped, timeout);
                    service.Start();
                    service.WaitForStatus(ServiceControllerStatus.Running, timeout);

                    str = (string)_mc.GetData(keyBase);
                    Assert.IsTrue(str == null);

                    //add
                    _mc.Add(keyBase, obj);
                    str = (string)_mc.GetData(keyBase);
                    Assert.IsTrue(str != null);
                }
            }
            finally
            {
                if (service.Status != ServiceControllerStatus.Running)
                {
                    service.Start();
                    service.WaitForStatus(ServiceControllerStatus.Running, timeout);
                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void WriteOutStats()
        {
            NameValueCollection settings = new NameValueCollection();
                settings.Add("ServerList", ConfigurationManager.AppSettings["ServerList"]);
                settings.Add("poolname", Guid.NewGuid().ToString());
                using (MemcachedCacheManager _mc = new MemcachedCacheManager(settings))
                {
                    string message = "Testing stats writing";

                    //warm up the cache...
                    string keyBase = "testKey" + Guid.NewGuid().ToString();
                    string obj = "This is a test of an object blah blah es, serialization does not seem to slow things down so much.  The gzip compression is horrible horrible performance, so we only use it for very large objects.  I have not done any heavy benchmarking recently";

                    //add with a day expirey
                    _mc.Add(keyBase, obj);
                    //WriteOutStats("After first add");
                    string str = (string)_mc.GetData(keyBase);
                    //WriteOutStats("After first get");
                    Assert.IsTrue(str != null, "Test 1:Returned string should not be null");


                    Console.WriteLine(message);
                    IDictionary stats = ((MemcachedCacheManager)_mc).GetStats(null);
                    Assert.IsTrue(stats.Count != 0);

                    foreach (string key1 in stats.Keys)
                    {
                        Console.WriteLine(key1);
                        Hashtable values = (Hashtable)stats[key1];
                        foreach (string key2 in values.Keys)
                        {
                            Console.WriteLine(key2 + ":" + values[key2]);
                        }
                        Console.WriteLine();
                    }
                }
        }



        /// <summary>
        /// Sub function
        /// </summary>
        /// <param name="key"></param>
        /// <param name="o"></param>
        /// <param name="reason"></param>
        private void callbackTest(string key, object o, CacheItemRemovedReason reason)
        {
            return;
        }



    }
}
