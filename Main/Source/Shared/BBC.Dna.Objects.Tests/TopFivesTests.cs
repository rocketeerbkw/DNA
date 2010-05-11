using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils.Mocks.Extentions;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks.Constraints;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for TopFivesTests
    /// </summary>
    [TestClass]
    public class TopFivesTests
    {
        public TopFivesTests()
        {
            mocks = new MockRepository();
        }

        private TestContext testContextInstance;
        private MockRepository mocks;

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

        [TestMethod]
        public void TopFives_CreateNewTopFive_ExpectEmptyTopFive()
        {
            var topFives = new TopFives();
            Assert.AreEqual(0, topFives.TopFiveList.Count);
            XmlDocument doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNull(doc.SelectSingleNode("TOP-FIVE"));
        }

        [TestMethod]
        public void TopFives_CreateNewTopFiveWithOneTopFiveForum_ExpectTopFiveForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new TopFiveForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecent", "Most Recent Comments", true, false));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var topFives = new TopFives();
            topFives.GetTopFivesForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(1, topFives.TopFiveList.Count);

            XmlDocument doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));
        }

        [TestMethod]
        public void TopFives_CheckCacheContainsNewTopFiveForums_ExpectTopFiveForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ICacheManager cache = new TestCacheManager();

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new TopFiveForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecent", "Most Recent Comments", true, false));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var topFives = TopFives.GetSiteTopFives(1, creator, mocks.DynamicMock<IDnaDiagnostics>(), cache);
            Assert.AreEqual(1, topFives.TopFiveList.Count);

            XmlDocument doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));

            topFives = TopFives.GetSiteTopFives(1, creator, mocks.DynamicMock<IDnaDiagnostics>(), cache);
            Assert.AreEqual(1, topFives.TopFiveList.Count);

            doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));
        }

        [TestMethod]
        public void TopFives_GetTopFivesForumsFromDatabaseNotCacheWhenExpired_ExpectTopFiveForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ICacheManager cache = new TestCacheManager();
            TopFives topFives;

            {
                List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
                databaseRows.Add(new TopFiveForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecent", "Most Recent Comments", true, false));

                DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

                topFives = TopFives.GetSiteTopFives(1, creator, mocks.DynamicMock<IDnaDiagnostics>(), cache);
                Assert.AreEqual(1, topFives.TopFiveList.Count);
                XmlDocument doc = SerializeToXML(topFives);
                Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
                Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));
            }

            // Expire the cached topfive
            var cachedTopFives = (CachableBase<TopFives>)cache.GetData("BBC.Dna.Objects.TopFives, BBC.Dna.Objects, Version=1.0.0.0, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887|topfives-site-|1|");
            ((TopFives)cachedTopFives).CacheExpireryDate = DateTime.Now.AddMinutes(-10);

            {
                List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
                databaseRows.Add(new TopFiveForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecent", "Most Recent Comments", true, false));

                DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

                topFives = TopFives.GetSiteTopFives(1, creator, mocks.DynamicMock<IDnaDiagnostics>(), cache);
                Assert.AreEqual(1, topFives.TopFiveList.Count);
                XmlDocument doc = SerializeToXML(topFives);
                Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
                Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));
            }
        }

        [TestMethod]
        public void TopFives_CreateNewTopFiveWithOneTopFiveArticle_ExpectTopFiveArticles()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new TopFiveArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecent", "Most Recent Articles", true, false));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var topFives = new TopFives();
            topFives.GetTopFivesForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(1, topFives.TopFiveList.Count);

            XmlDocument doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-ARTICLE"));
        }

        [TestMethod]
        public void TopFives_CreateNewTopFiveWithOneTopFiveArticleAndOneTopFiveForum_ExpectTopFiveArticlesAndForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new TopFiveArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecent", "Most Recent Articles", true, false));
            databaseRows.Add(new TopFiveForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecentComments", "Most Recent Comments", true, true));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var topFives = new TopFives();
            topFives.GetTopFivesForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(2, topFives.TopFiveList.Count);

            XmlDocument doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-ARTICLE"));
        }

        [TestMethod]
        public void TopFives_CreateNewTopFiveWithOneTopFiveArticleOneTopFiveForumAndUnkownDataType_ExpectTopFiveArticlesAndForumsNoUnkownDataType()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new TopFiveArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecent", "Most Recent Articles", true, false));
            databaseRows.Add(new TopFiveUnkownDataaTypeTestDatabaseRow());
            databaseRows.Add(new TopFiveForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecentComments", "Most Recent Comments", true, true));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var topFives = new TopFives();
            topFives.GetTopFivesForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(2, topFives.TopFiveList.Count);

            XmlDocument doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-ARTICLE"));
        }

        [TestMethod]
        public void TopFives_CreateNewTopFiveWithMultipleTopFiveArticleAndMultipleTopFiveForum_ExpectTopFiveArticlesAndForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new TopFiveForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecentComments", "Most Recent Comments", true, false));
            databaseRows.Add(new TopFiveForumTestDatabaseRow(4826159, 78787878, "Testing", "MostRecentComments", "Most Recent Comments", false, false));
            databaseRows.Add(new TopFiveArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecent", "Most Recent Articles", true, true));
            databaseRows.Add(new TopFiveArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 456789, 0, "", 0, "Testing", 649713, "Second Testing User", "Second SiteSuffix", "MostRecent", "Most Recent Articles", false, false));
            databaseRows.Add(new TopFiveForumTestDatabaseRow(456123789, 159487263, "Testing More", "MostRecentPosts", "Most Recent Posts", true, true));
            databaseRows.Add(new TopFiveArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(2), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 15948, 0, "", 0, "Testing", 1063883681, "NewBod", "Newbods site suffix", "MostRecentArticles", "Most Recent Articles", true, true));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var topFives = new TopFives();
            topFives.GetTopFivesForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(4, topFives.TopFiveList.Count);

            XmlDocument doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-ARTICLE"));
        }

        [TestMethod]
        public void TopFives_CreateNewTopFiveWithOneTopFiveForumWithBADColumnData_ExpectRootTopFiveWithNoTopFives()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, null);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.IsDBNull("h2g2id")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("groupname")).Return("MostRecent");
            reader.Stub(x => x.GetStringNullAsEmpty("groupdescription")).Return("MostRecent");
            reader.Stub(x => x.GetInt32NullAsZero("forumid")).Throw(new Exception("Database Exception"));
            reader.Stub(x => x.Read()).Return(true);

            var topFives = new TopFives();
            topFives.GetTopFivesForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(0, topFives.TopFiveList.Count);

            XmlDocument doc = SerializeToXML(topFives);
            Assert.IsNotNull(doc.SelectSingleNode("TOP-FIVES"));
            Assert.IsNull(doc.SelectSingleNode("TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM"));
        }

        [TestMethod]
        public void TopFives_AddTopFiveArticle_ExpectListWithTopFiveArticle()
        {
            TopFives topFives = new TopFives();
            TopFiveArticles topFiveArticles = new TopFiveArticles();
            topFives.TopFiveList.Add(topFiveArticles);
            TopFiveArticle topFiveArticle = new TopFiveArticle();
            topFiveArticles.topFiveArticleList.Add(topFiveArticle);

            DateTime updatedDate = DateTime.Now;
            DateTime eventDate = DateTime.Now.AddMinutes(5);
            topFiveArticle.DateUpdated.Date = new Date(updatedDate);
            topFiveArticle.EventDate.Date = new Date(eventDate);
            XmlDocument doc = new XmlDocument();
            doc.LoadXml("<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>");
            topFiveArticle.ExtrainfoElement = (XmlElement)doc.FirstChild;
            topFiveArticle.H2G2ID = 123456789;
            topFiveArticle.LinkItemID = 789;
            topFiveArticle.LinkItemName = "The WEB";
            topFiveArticle.LinkItemType = 1;
            topFiveArticle.Subject = "Unit Testing";

            TopFiveArticleUser user = new TopFiveArticleUser();
            user.SiteSuffix = "Site-Suffix";
            user.UserID = 517436;
            user.UserName = "NewBod";

            topFiveArticle.User = user;

            Assert.AreEqual(doc.FirstChild.OuterXml, topFiveArticle.ExtrainfoElement.OuterXml);
            Assert.AreEqual(123456789, topFiveArticle.H2G2ID);
            Assert.AreEqual(789, topFiveArticle.LinkItemID);
            Assert.AreEqual("The WEB", topFiveArticle.LinkItemName);
            Assert.AreEqual(1, topFiveArticle.LinkItemType);
            Assert.AreEqual("Unit Testing", topFiveArticle.Subject);
            Assert.AreEqual(user, topFiveArticle.User);
        }

        private XmlDocument SerializeToXML(object obj)
        {
            XmlDocument xml = new XmlDocument();
            using (StringWriterWithEncoding writer = new StringWriterWithEncoding(Encoding.UTF8))
            {
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Encoding = new UTF8Encoding(false);
                settings.Indent = true;
                settings.OmitXmlDeclaration = true;
                using (XmlWriter xWriter = XmlWriter.Create(writer, settings))
                {
                    System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(obj.GetType());
                    x.Serialize(xWriter, obj);
                    xWriter.Flush();
                    xml.InnerXml = Entities.GetEntities() + writer.ToString();
                }
            }

            return xml;
        }
    }

    public class TopFiveUnkownDataaTypeTestDatabaseRow : DataReaderFactory.TestDatabaseRow
    {
        public TopFiveUnkownDataaTypeTestDatabaseRow()
        {
            AddColumnValue("forumid-isdbnull", true);
            AddColumnValue("h2g2id-isdbnull", true);
        }
    }

    public class TopFiveForumTestDatabaseRow : DataReaderFactory.TestDatabaseRow
    {
        public TopFiveForumTestDatabaseRow(int forumID, int threadID, string title, string groupName, string groupDescription, bool firstRowOfType, bool followsDifferentType)
        {
            AddColumnValue("forumid", forumID);
            AddColumnValue("threadid", threadID);
            AddColumnValue("title", title);
            AddColumnValue("groupname", groupName);
            AddColumnValue("groupdescription", groupDescription);
            if (firstRowOfType)
            {
                AddColumnValue("forumid-isdbnull", false);
                AddColumnValue("h2g2id-isdbnull", true);
                AddColumnValue("groupname", groupName);
            }
            if (followsDifferentType)
            {
                AddColumnValue("groupname", groupName);
            }
        }
    }

    public class TopFiveArticleTestDatabaseRow : DataReaderFactory.TestDatabaseRow
    {
        public TopFiveArticleTestDatabaseRow(DateTime dateUpdated, DateTime eventDate, string extraInfo, int h2g2ID, int linkItemID,
                                             string linkItemName, int linkItemType, string subject, int userID, string userName, string siteSuffix,
                                             string groupName, string groupDescription, bool firstRowOfType, bool followsDifferentType)
        {
            AddColumnValue("dateupdated", dateUpdated);
            AddColumnValue("eventdate", eventDate);
            AddColumnValue("eventdate-isdbnull", eventDate == null);
            AddColumnValue("extrainfo", extraInfo);
            AddColumnValue("h2g2id", h2g2ID);
            AddColumnValue("linkitemid", linkItemID);
            AddColumnValue("linkitemname", linkItemName);
            AddColumnValue("linkitemtype", linkItemType);
            AddColumnValue("userid", userID);
            AddColumnValue("username", userName);
            AddColumnValue("sitesuffix", siteSuffix);
            AddColumnValue("groupname", groupName);
            AddColumnValue("groupdescription", groupDescription);
            if (firstRowOfType)
            {
                AddColumnValue("groupname", groupName);
                AddColumnValue("h2g2id-isdbnull", false);
            }
            if (followsDifferentType)
            {
                AddColumnValue("groupname", groupName);
            }
        }
    }

    public class TestCacheManager : ICacheManager
    {
        private Dictionary<string, object> cacheItems = new Dictionary<string, object>();

        #region ICacheManager Members

        public void Add(string key, object value, CacheItemPriority scavengingPriority, ICacheItemRefreshAction refreshAction, params ICacheItemExpiration[] expirations)
        {
            throw new NotImplementedException();
        }

        public void Add(string key, object value)
        {
            if (cacheItems.ContainsKey(key))
            {
                cacheItems[key] = value;
            }
            else
            {
                cacheItems.Add(key, value);
            }
        }

        public bool Contains(string key)
        {
            throw new NotImplementedException();
        }

        public int Count
        {
            get { throw new NotImplementedException(); }
        }

        public void Flush()
        {
            throw new NotImplementedException();
        }

        public object GetData(string key)
        {
            if (cacheItems.ContainsKey(key))
            {
                return cacheItems[key];
            }

            return null;
        }

        public void Remove(string key)
        {
            throw new NotImplementedException();
        }

        public object this[string key]
        {
            get { throw new NotImplementedException(); }
        }

        #endregion
    }
}
