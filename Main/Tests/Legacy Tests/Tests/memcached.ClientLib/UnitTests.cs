
namespace Tests
{
    using System;
    using System.Collections;
    using System.Configuration;
    using System.Diagnostics;
    using System.Text;
    using Memcached.ClientLibrary;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    /// <summary>
    /// 
    /// </summary>
    [TestClass]
	public class UnitTests 
	{

        /// <summary>
        /// 
        /// </summary>
        [TestCleanup]
        public void ShutDown()
        {
            pool.Shutdown();
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            mc = new MemcachedClient();
            //mc.PoolName = "testpool"Guid.NewGuid().ToString();
            pool = SockIOPool.GetInstance();
            string[] serverlist = null;
            if (!String.IsNullOrEmpty(ConfigurationSettings.AppSettings["MemcachedServerList"]))
            {
                serverlist = ConfigurationSettings.AppSettings["MemcachedServerList"].Split(',');
            }
            else
            {
                throw new Exception("Application setting 'MemcachedServerList' cannot be empty or null");
            }
            // initialize the pool for memcache servers
            pool.SetServers(serverlist);
            pool.InitConnections = 3;
            pool.MinConnections = 3;
            pool.MaxConnections = 5;
            pool.SocketConnectTimeout = 1000;
            pool.SocketTimeout = 3000;
            pool.MaintenanceSleep = 30;
            pool.Failover = true;
            pool.Nagle = false;
            pool.Initialize();
            mc.EnableCompression = true;

            //wipe all keys from MC
            mc.FlushAll();
        
        }

		private MemcachedClient mc  = null;
        private SockIOPool pool = null;

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
		public void test1() 
		{
			mc.Set("foo", true);
			bool b = (bool)mc.Get("foo");
			Assert.IsTrue(b);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
		public void test2() 
		{
			mc.Set("foo", int.MaxValue);
			int i = (int)mc.Get("foo");
			Assert.IsTrue(i == int.MaxValue);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test3() 
		{
			string input = "test of string encoding";
			mc.Set("foo", input);
			string s = (string)mc.Get("foo");
			Assert.IsTrue(s == input);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test4() 
		{
			mc.Set("foo", 'z');
			char c = (char)mc.Get("foo");
			Assert.IsTrue(c == 'z');
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test5() 
		{
			mc.Set("foo", (byte)127);
			byte b = (byte)mc.Get("foo");
			Assert.IsTrue(b == 127);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test6() 
		{
			mc.Set("foo", new StringBuilder("hello"));
			StringBuilder o = (StringBuilder)mc.Get("foo");
			Assert.IsTrue(o.ToString() == "hello");
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test7() 
		{
			mc.Set("foo", (short)100);
			short o = (short)mc.Get("foo");
			Assert.IsTrue(o == 100);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test8() 
		{
			mc.Set("foo", long.MaxValue);
			long o = (long)mc.Get("foo");
			Assert.IsTrue(o == long.MaxValue);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test9() 
		{
			
			mc.Set("foo", 1.1d);
			double o = (double)mc.Get("foo");
			Assert.IsTrue(o == 1.1d);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test10() 
		{
			
			mc.Set("foo", 1.1f);
			float o = (float)mc.Get("foo");
			Assert.IsTrue(o == 1.1f);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test11() 
		{
			mc.Delete("foo");
			mc.Set("foo", 100, DateTime.Now);
			System.Threading.Thread.Sleep(1000);
			Assert.IsTrue(mc.Get("foo") != null);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test12() 
		{
			long i = 0;
			mc.StoreCounter("foo", i);
			mc.Increment("foo"); // foo now == 1
			mc.Increment("foo", (long)5); // foo now == 6
			long j = mc.Decrement("foo", (long)2); // foo now == 4
			Assert.IsTrue(j == 4);
			Assert.IsTrue(j == mc.GetCounter("foo"));
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test13() 
		{
			DateTime d1 = new DateTime();
			mc.Set("foo", d1);
			DateTime d2 = (DateTime) mc.Get("foo");
			Assert.IsTrue(d1 == d2);
		}

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void test14() 
		{
			if(mc.KeyExists("foobar123"))
				mc.Delete("foobar123");
			Assert.IsTrue(!mc.KeyExists("foobar123"));
			mc.Set("foobar123", 100000);
			Assert.IsTrue(mc.KeyExists("foobar123"));

			if(mc.KeyExists("counterTest123"))
				mc.Delete("counterTest123");
			Assert.IsTrue(!mc.KeyExists("counterTest123"));
			mc.StoreCounter("counterTest123", 0);
			Assert.IsTrue(mc.KeyExists("counterTest123"));
		}
	}
}