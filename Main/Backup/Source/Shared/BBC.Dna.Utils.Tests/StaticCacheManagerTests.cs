using System;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Summary description for StaticCacheManager
    /// </summary>
    [TestClass]
    public class StaticCacheManagerTests
    {
        private StaticCacheManager _cache = new StaticCacheManager();
        [TestInitialize]
        public void Setup()
        {
            _cache.Flush();
        }

        [TestMethod]
        public void Add_AddObjectToCache_ReturnsObject()
        {
            
            _cache.Add("test", "mytestobject");

            Assert.AreEqual("mytestobject", _cache["test"].ToString());

        }

        [TestMethod]
        public void Add_ReAddObjectToCacheWithDifferentValue_ReturnsObject()
        {

            _cache.Add("test", "mytestobject");
            _cache.Add("test", "mytestobject2");


            Assert.AreEqual("mytestobject2", _cache["test"].ToString());

        }

        [TestMethod]
        public void Add_AddObjectWithExtraParams_ThrowsNotImplemented()
        {

            try
            {
                _cache.Add("test", "mytestobject", CacheItemPriority.None, null, null);
            }
            catch (NotImplementedException)
            {
            }
            Assert.IsNull(_cache["Test"]);

        }

        [TestMethod]
        public void Add_AddObjectToCacheWithDoubleInitialise_ReturnsObject()
        {
            
            _cache.Add("test", "mytestobject");

            _cache = new StaticCacheManager();

            Assert.AreEqual("mytestobject", _cache["test"].ToString());

        }

        [TestMethod]
        public void GetData_AddObjectToCache_ReturnsObject()
        {

            _cache.Add("test", "mytestobject");

            Assert.AreEqual("mytestobject", _cache.GetData("test").ToString());

        }

        [TestMethod]
        public void GetData_AddObjectToCacheCaseSensitive_FailsToReturnObjectWithWrongCasedKey()
        {

            _cache.Add("test", "mytestobject");

            Assert.IsNull(_cache.GetData("Test"));

        }


        [TestMethod]
        public void Contains_AddObjectToCache_ReturnsTrue()
        {
            
            _cache.Add("test", "mytestobject");

            Assert.IsTrue(_cache.Contains("test"));

        }

        [TestMethod]
        public void Contains_NoObjectinCache_ReturnsFalse()
        {
            
            

            Assert.IsFalse(_cache.Contains("test"));

        }

        [TestMethod]
        public void Remove_AddObjectToCacheRemoveIts_ReturnsNull()
        {

            _cache.Add("test", "mytestobject");

            _cache.Remove("test");

            Assert.IsNull(_cache["test"]);

        }

        [TestMethod]
        public void Count_AddTwoObjectsToCache_Returns2()
        {

            _cache.Add("test", "mytestobject");
            _cache.Add("test2", "mytestobject");

            Assert.AreEqual(2, _cache.Count);

        }

        [TestMethod]
        public void Count_AddObjectsToCacheTwice_Returns1()
        {

            _cache.Add("test", "mytestobject");
            _cache.Add("test", "mytestobject");

            Assert.AreEqual(1, _cache.Count);

        }


    }
}