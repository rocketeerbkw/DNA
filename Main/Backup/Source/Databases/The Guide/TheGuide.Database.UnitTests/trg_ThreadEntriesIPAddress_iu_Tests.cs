using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using TestUtils;
using BBC.Dna.Data;
using System.Configuration;

namespace TheGuide.Database.UnitTests
{
    /// <summary>
    /// Summary description for trg_ThreadEntriesIPAddress_iu
    /// </summary>
    [TestClass]
    public class trg_ThreadEntriesIPAddress_iu_Tests
    {
        public trg_ThreadEntriesIPAddress_iu_Tests()
        {
            ConnectionString = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        struct ThreadEntryIPAddress
        {
            public int entryId;
            public string ipAddress;
            public string bbcuid;
        }


        private string ConnectionString { get; set; }

        [TestMethod]
        public void ThreadEntryIPAddress_Insert_CheckBBCIPsGetReset()
        {
            using (new TransactionScope())
            {
                var listBefore = GetThreadEntryIPAddresses();

                int entryId = FindMaxThreadEntryIPAddressEntryId()+1;

                for (int i = 224; i <= 255; i++)
                {
                    string ipaddress = "212.58." + i + ".1";
                    TestInsertBBCIPAddress(entryId++, ipaddress);

                    ipaddress = "212.58." + i + ".255";
                    TestInsertBBCIPAddress(entryId++, ipaddress);
                }

                // There should be only 64 extra rows (2*(255-224+1))
                var listAfter = GetThreadEntryIPAddresses();
                Assert.AreEqual(64, CountListDifferences(listBefore, listAfter));
            }
        }

        void TestInsertBBCIPAddress(int entryId, string ipaddress)
        {
            InsertThreadEntryIPAddress(entryId, ipaddress);

            var ipInfo = GetThreadEntryIPAddressInfo(entryId);
            Assert.AreEqual(entryId, ipInfo.entryId);
            Assert.AreEqual("0.0.0.0", ipInfo.ipAddress);
        }

        void TestInsertNonBBCIPAddress(int entryId, string ipaddress)
        {
            InsertThreadEntryIPAddress(entryId, ipaddress);

            var ipInfo = GetThreadEntryIPAddressInfo(entryId);
            Assert.AreEqual(entryId, ipInfo.entryId);
            Assert.AreEqual(ipaddress, ipInfo.ipAddress);
        }

        [TestMethod]
        public void ThreadEntryIPAddress_Insert_CheckNonBBCIPAddressesAreLeftAlone()
        {
            using (new TransactionScope())
            {
                var listBefore = GetThreadEntryIPAddresses();

                int entryId = FindMaxThreadEntryIPAddressEntryId() + 1;
                TestInsertNonBBCIPAddress(entryId, "212.57.45.73");

                entryId = FindMaxThreadEntryIPAddressEntryId() + 1;
                TestInsertNonBBCIPAddress(entryId, "212.59.45.73");

                entryId = FindMaxThreadEntryIPAddressEntryId() + 1;

                for (int i = 0; i < 224; i++)
                {
                    string ipaddress = "212.58." + i + ".1";
                    TestInsertNonBBCIPAddress(entryId++, ipaddress);

                    ipaddress = "212.58." + i + ".255";
                    TestInsertNonBBCIPAddress(entryId++, ipaddress);
                }

                // There should be 450 extra rows (2*225)
                var listAfter = GetThreadEntryIPAddresses();
                Assert.AreEqual(450, CountListDifferences(listBefore, listAfter));
            }
        }

        [TestMethod]
        public void ThreadEntryIPAddress_Update_CheckBBCIPsGetReset()
        {
            using (new TransactionScope())
            {
                var listBefore = GetThreadEntryIPAddresses();

                int entryId = FindMaxThreadEntryIPAddressEntryId();

                for (int i = 224; i <= 255; i++)
                {
                    string ipaddress = "212.58." + i + ".1";
                    TestUpdateBBCIPAddress(entryId, ipaddress);

                    ipaddress = "212.58." + i + ".255";
                    TestUpdateBBCIPAddress(entryId, ipaddress);
                }

                // There should be only one row that changed in the entire table
                var listAfter = GetThreadEntryIPAddresses();
                Assert.AreEqual(1, CountListDifferences(listBefore, listAfter));
            }
        }

        void TestUpdateBBCIPAddress(int entryId, string ipaddress)
        {
                UpdateThreadEntryIPAddress(entryId, ipaddress);

                var ipInfo = GetThreadEntryIPAddressInfo(entryId);
                Assert.AreEqual(entryId, ipInfo.entryId);
                Assert.AreEqual("0.0.0.0", ipInfo.ipAddress);
       }

        void TestUpdateNonBBCIPAddress(int entryId, string ipaddress)
        {
            UpdateThreadEntryIPAddress(entryId, ipaddress);

            var ipInfo = GetThreadEntryIPAddressInfo(entryId);
            Assert.AreEqual(entryId, ipInfo.entryId);
            Assert.AreEqual(ipaddress, ipInfo.ipAddress);
        }

        [TestMethod]
        public void ThreadEntryIPAddress_Update_CheckNonBBCIPAddressesAreLeftAlone()
        {
            using (new TransactionScope())
            {
                var listBefore = GetThreadEntryIPAddresses();

                int entryId = FindMaxThreadEntryIPAddressEntryId();
                TestUpdateNonBBCIPAddress(entryId, "212.57.45.73");
                TestUpdateNonBBCIPAddress(entryId, "212.59.45.73");

                for (int i = 0; i < 224; i++)
                {
                    string ipaddress = "212.58." + i + ".1";
                    TestUpdateNonBBCIPAddress(entryId, ipaddress);

                    ipaddress = "212.58." + i + ".255";
                    TestUpdateNonBBCIPAddress(entryId, ipaddress);
                }

                // There should be only one row that changed in the entire table
                var listAfter = GetThreadEntryIPAddresses();
                Assert.AreEqual(1, CountListDifferences(listBefore, listAfter));
            }
        }

        private void InsertThreadEntryIPAddress(int entryId, string ip)
        {
            string sql = string.Format(@"insert ThreadEntriesIPAddress values({0},'{1}',null)", entryId, ip);

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionString))
            {
                reader.ExecuteWithinATransaction(sql);
            }
        }

        private void UpdateThreadEntryIPAddress(int entryId, string ip)
        {
            string sql = string.Format(@"update ThreadEntriesIPAddress set ipaddress='{0}' where entryid={1}", ip, entryId);

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionString))
            {
                reader.ExecuteWithinATransaction(sql);
            }
        }

        private int FindMaxThreadEntryIPAddressEntryId()
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionString))
            {
                reader.ExecuteWithinATransaction(@"select max(entryid) as EntryId from ThreadEntriesIPAddress");
                reader.Read();
                return reader.GetInt32("EntryId");
            }
        }

        private ThreadEntryIPAddress GetThreadEntryIPAddressInfo(int entryId)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionString))
            {
                reader.ExecuteWithinATransaction(@"select * from ThreadEntriesIPAddress where entryid=" + entryId);
                reader.Read();

                var ipInfo = new ThreadEntryIPAddress();
                ipInfo.entryId = reader.GetInt32("EntryId");
                ipInfo.ipAddress = reader.GetString("ipAddress");
                ipInfo.bbcuid = reader.GetGuidAsStringOrEmpty("BBCUID");

                return ipInfo;
            }
        }

        private List<ThreadEntryIPAddress> GetThreadEntryIPAddresses()
        {
            var listThreadEntryIPAddresses = new List<ThreadEntryIPAddress>();

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionString))
            {
                reader.ExecuteWithinATransaction(@"select * from ThreadEntriesIPAddress order by entryid");

                while (reader.Read())
                {
                    var ipInfo = new ThreadEntryIPAddress();
                    ipInfo.entryId = reader.GetInt32("EntryId");
                    ipInfo.ipAddress = reader.GetString("ipAddress");
                    ipInfo.bbcuid = reader.GetGuidAsStringOrEmpty("BBCUID");

                    listThreadEntryIPAddresses.Add(ipInfo);
                }

                return listThreadEntryIPAddresses;
            }
        }

        private int CountListDifferences(List<ThreadEntryIPAddress> list1, List<ThreadEntryIPAddress> list2)
        {
            int diffCount = Math.Abs(list1.Count - list2.Count);

            for (int i = 0; i < list1.Count; i++)
            {
                if (i >= list2.Count)
                    break;

                if (!list1[i].Equals(list2[i]))
                    diffCount++;
            }

            return diffCount;
        }
    }
}
