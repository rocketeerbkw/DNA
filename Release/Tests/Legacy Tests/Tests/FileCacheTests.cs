using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Utils;

namespace Tests
{
	/// <summary>
	/// Tests for the file caching class
	/// </summary>
	[TestClass]
	public class FileCacheTests
	{
		/// <summary>
		/// Test the file caching that simulates the Ripley method of caching
		/// </summary>
		[TestMethod]
		public void TestFileCaching()
		{
            try
            {
                string rootPath = TestConfig.GetConfig().GetRipleyServerPath();
                BBC.Dna.AppContext.OnDnaStartup(rootPath);

                Console.WriteLine("TestFileCaching");
                Statistics.InitialiseIfEmpty();
                string cacheRoot = Directory.GetCurrentDirectory();

                string testvalue = "The quick brown fox";

                Assert.IsFalse(FileCache.PutItem("", "TempCacheDirectory", "TestFile.txt", testvalue), "Empty cache root must fail");
                Assert.IsTrue(FileCache.PutItem(cacheRoot, "TempCacheDirectory", "TestFile.txt", testvalue), "Couldn't save cache file");

                string returnvalue = string.Empty;
                DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(5);
                DateTime originalexpiry = expiry + TimeSpan.FromMinutes(0);
                Assert.IsTrue(FileCache.GetItem(cacheRoot, "TempCacheDirectory", "TestFile.txt", ref expiry, ref returnvalue), "Failed to get cached item");
                Assert.AreEqual(testvalue, returnvalue, "Cached value doesn't match original value");
                Assert.IsTrue(expiry> originalexpiry, "We expect that the expiry field, on returning from GetItem >  has the file time of the file on disk");

                // See if a blank root fails, and ensure that the date is unchanged
                expiry = DateTime.Parse("27 September 1964");
                originalexpiry = expiry + TimeSpan.FromMinutes(0);
                returnvalue = "leave this unchanged";
                Assert.IsFalse(FileCache.GetItem("", "TempCacheDirectory", "TestFile.txt", ref expiry, ref returnvalue), "Failed to get cached item");
                Assert.AreEqual(expiry, originalexpiry, "ref Expiry parameter should be unchanged when no cache root is passed in");
                Assert.AreEqual(returnvalue, "leave this unchanged", "ref return value should be unchanged");


                expiry = DateTime.Now + TimeSpan.FromMinutes(5);
                Assert.IsFalse(FileCache.GetItem(cacheRoot, "TempCacheDirectory", "TestFile.txt", ref expiry, ref returnvalue), "GetItem should fail with a date more recent than the file date");

                File.Delete(Path.Combine(Path.Combine(cacheRoot, "TempCacheDirectory"), "TestFile.txt"));
                expiry = DateTime.Now - TimeSpan.FromMinutes(5);
                Assert.IsFalse(FileCache.GetItem(cacheRoot, "TempCacheDirectory", "TestFile.txt", ref expiry, ref returnvalue), "Expected to fail to get deleted cache item");

                Directory.Delete(Path.Combine(cacheRoot, "TempCacheDirectory"));
            }
            catch (Exception e)
            {
                System.Console.Write(e.Message);
                Assert.Fail(e.Message);
            }
		}

        /// <summary>
        /// Test the file caching that simulates the Ripley method of caching with invalid filename characters
        /// </summary>
        [TestMethod]
        public void TestFileCachingWithInvalidFileChars()
        {
            try
            {
                string filename = "1|!%/&2.txt";

                Console.WriteLine("TestFileCachingWithInvalidFileChars");
                Statistics.InitialiseIfEmpty();
                string cacheRoot = Directory.GetCurrentDirectory();

                string testvalue = "The quick brown fox";

                Assert.IsFalse(FileCache.PutItem("", "TempCacheDirectory", filename, testvalue), "Empty cache root must fail");
                Assert.IsTrue(FileCache.PutItem(cacheRoot, "TempCacheDirectory", filename, testvalue), "Couldn't save cache file");

                string returnvalue = string.Empty;
                DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(5);
                DateTime originalexpiry = expiry + TimeSpan.FromMinutes(0);
                Assert.IsTrue(FileCache.GetItem(cacheRoot, "TempCacheDirectory", filename, ref expiry, ref returnvalue), "Failed to get cached item");
                Assert.AreEqual(testvalue, returnvalue, "Cached value doesn't match original value");
                Assert.IsTrue(expiry > originalexpiry, "We expect that the expiry field, on returning from GetItem >  has the file time of the file on disk");

                File.Delete(Path.Combine(Path.Combine(cacheRoot, "TempCacheDirectory"), StringUtils.MakeStringFileNameSafe(filename)));
                Directory.Delete(Path.Combine(cacheRoot, "TempCacheDirectory"));
            }
            catch (Exception e)
            {
                System.Console.Write(e.Message);
                Assert.Fail(e.Message);
            }
        }
	}
}
