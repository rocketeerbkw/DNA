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
using BBC.Dna.Common;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for RecentActivityTests
    /// </summary>
    [TestClass]
    public class RecentActivityTests
    {
        public RecentActivityTests()
        {
            mocks = new MockRepository();
        }

        private MockRepository mocks;

        [TestMethod]
        public void RecentActivity_CreateNewRecentActivity_ExpectEmptyRecentActivity()
        {
            var RecentActivity = new RecentActivity();
            XmlDocument doc = SerializeToXML(RecentActivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNull(doc.SelectSingleNode("MOSTRECENTARTICLES"));
        }

        [TestMethod]
        public void RecentActivity_CreateNewRecentActivityWithOneRecentActivityForum_ExpectRecentActivityForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new RecentActivityForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecent", "Most Recent Comments", true, false));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var RecentActivity = new RecentActivity();
            RecentActivity.GetRecentActivityForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(1, RecentActivity.MostRecentConversations.topFiveForumList.Count);

            XmlDocument doc = SerializeToXML(RecentActivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));
        }

        [TestMethod]
        public void RecentActivity_CheckCacheContainsNewRecentActivityForums_ExpectRecentActivityForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ICacheManager cache = new TestCacheManager();

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new RecentActivityForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecent", "Most Recent Comments", true, false));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var recentAcivity = RecentActivity.GetSiteRecentActivity(1, creator, mocks.DynamicMock<IDnaDiagnostics>(), cache);
            Assert.AreEqual(1, recentAcivity.MostRecentConversations.topFiveForumList.Count);

            XmlDocument doc = SerializeToXML(recentAcivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));

            recentAcivity = RecentActivity.GetSiteRecentActivity(1, creator, mocks.DynamicMock<IDnaDiagnostics>(), cache);
            Assert.AreEqual(1, recentAcivity.MostRecentConversations.topFiveForumList.Count);

            doc = SerializeToXML(recentAcivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));
        }

        [TestMethod]
        public void RecentActivity_GetRecentActivityForumsFromDatabaseNotCacheWhenExpired_ExpectRecentActivityForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ICacheManager cache = new TestCacheManager();
            RecentActivity RecentActivity;

            {
                List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
                databaseRows.Add(new RecentActivityForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecent", "Most Recent Comments", true, false));

                DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

                RecentActivity = RecentActivity.GetSiteRecentActivity(1, creator, mocks.DynamicMock<IDnaDiagnostics>(), cache);
                Assert.AreEqual(1, RecentActivity.MostRecentConversations.topFiveForumList.Count);
                XmlDocument doc = SerializeToXML(RecentActivity);
                Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
                Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));
            }

            // Expire the cached RecentActivity
            var cachedRecentActivity = (CachableBase<RecentActivity>)cache.GetData("BBC.Dna.Objects.RecentActivity, BBC.Dna.Objects, Version=1.0.0.0, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887|1|");
            ((RecentActivity)cachedRecentActivity).CacheExpireryDate = DateTime.Now.AddMinutes(-10);

            {
                List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
                databaseRows.Add(new RecentActivityForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecent", "Most Recent Comments", true, false));

                DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

                RecentActivity = RecentActivity.GetSiteRecentActivity(1, creator, mocks.DynamicMock<IDnaDiagnostics>(), cache);
                Assert.AreEqual(1, RecentActivity.MostRecentConversations.topFiveForumList.Count);
                XmlDocument doc = SerializeToXML(RecentActivity);
                Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
                Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));
            }
        }

        [TestMethod]
        public void RecentActivity_CreateNewRecentActivityWithOneRecentActivityArticle_ExpectRecentActivityArticles()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new RecentActivityArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecent", "Most Recent Articles", true, false));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var RecentActivity = new RecentActivity();
            RecentActivity.GetRecentActivityForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(1, RecentActivity.MostRecentArticles.topFiveArticleList.Count);

            XmlDocument doc = SerializeToXML(RecentActivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTARTICLES/ARTICLE"));
        }

        [TestMethod]
        public void RecentActivity_CreateNewRecentActivityWithOneRecentActivityArticleAndOneRecentActivityForum_ExpectRecentActivityArticlesAndForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new RecentActivityArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecent", "Most Recent Articles", true, false));
            databaseRows.Add(new RecentActivityArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "Updated", "Most Recent Articles", true, true));
            databaseRows.Add(new RecentActivityArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecentUser", "Most Recent User Articles", true, true));
            databaseRows.Add(new RecentActivityForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecentComments", "Most Recent Comments", true, true));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var RecentActivity = new RecentActivity();
            RecentActivity.GetRecentActivityForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(1, RecentActivity.MostRecentArticles.topFiveArticleList.Count);
            Assert.AreEqual(1, RecentActivity.MostRecentUserArticles.topFiveArticleList.Count);
            Assert.AreEqual(1, RecentActivity.MostRecentUpdatedArticles.topFiveArticleList.Count);
            Assert.AreEqual(1, RecentActivity.MostRecentConversations.topFiveForumList.Count);

            XmlDocument doc = SerializeToXML(RecentActivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTARTICLES/ARTICLE"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));
        }

        [TestMethod]
        public void RecentActivity_CreateNewRecentActivityWithOneRecentActivityArticleOneRecentActivityForumAndUnkownDataType_ExpectRecentActivityArticlesAndForumsNoUnkownDataType()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new RecentActivityArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecent", "Most Recent Articles", true, false));
            databaseRows.Add(new RecentActivityUnkownDataaTypeTestDatabaseRow());
            databaseRows.Add(new RecentActivityForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecentComments", "Most Recent Comments", true, true));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var RecentActivity = new RecentActivity();
            RecentActivity.GetRecentActivityForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(1, RecentActivity.MostRecentArticles.topFiveArticleList.Count);
            Assert.AreEqual(1, RecentActivity.MostRecentConversations.topFiveForumList.Count);

            XmlDocument doc = SerializeToXML(RecentActivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTARTICLES/ARTICLE"));
        }

        [TestMethod]
        public void RecentActivity_CreateNewRecentActivityWithMultipleRecentActivityArticleAndMultipleRecentActivityForum_ExpectRecentActivityArticlesAndForums()
        {
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            List<DataReaderFactory.TestDatabaseRow> databaseRows = new List<DataReaderFactory.TestDatabaseRow>();
            databaseRows.Add(new RecentActivityForumTestDatabaseRow(123456789, 789456123, "Testing", "MostRecentConversations", "Most Recent Comments", true, false));
            databaseRows.Add(new RecentActivityForumTestDatabaseRow(4826159, 78787878, "Testing", "MostRecentConversations", "Most Recent Comments", false, false));
            databaseRows.Add(new RecentActivityArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 123456, 0, "", 0, "Testing", 517436, "Testing User", "my site suffix", "MostRecent", "Most Recent Articles", true, true));
            databaseRows.Add(new RecentActivityArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(1), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 456789, 0, "", 0, "Testing", 649713, "Second Testing User", "Second SiteSuffix", "MostRecent", "Most Recent Articles", false, false));
            databaseRows.Add(new RecentActivityForumTestDatabaseRow(456123789, 159487263, "Testing More", "MostRecentConversations", "Most Recent Posts", true, true));
            databaseRows.Add(new RecentActivityArticleTestDatabaseRow(DateTime.Now, DateTime.Now.AddDays(2), "<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>", 15948, 0, "", 0, "Testing", 1063883681, "NewBod", "Newbods site suffix", "MostRecent", "Most Recent Articles", true, true));

            DataReaderFactory.CreateMockedDataBaseObjects(mocks, "gettopfives2", out creator, out reader, databaseRows);

            var RecentActivity = new RecentActivity();
            RecentActivity.GetRecentActivityForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(3, RecentActivity.MostRecentArticles.topFiveArticleList.Count);
            Assert.AreEqual(3, RecentActivity.MostRecentConversations.topFiveForumList.Count);

            XmlDocument doc = SerializeToXML(RecentActivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTARTICLES/ARTICLE"));
        }

        [TestMethod]
        public void RecentActivity_CreateNewRecentActivityWithOneRecentActivityForumWithBADColumnData_ExpectRootRecentActivityWithNoRecentActivity()
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

            var RecentActivity = new RecentActivity();
            RecentActivity.GetRecentActivityForSite(1, creator, mocks.DynamicMock<IDnaDiagnostics>());
            Assert.AreEqual(0, RecentActivity.MostRecentArticles.topFiveArticleList.Count);

            XmlDocument doc = SerializeToXML(RecentActivity);
            Assert.IsNotNull(doc.SelectSingleNode("RECENTACTIVITY"));
            Assert.IsNull(doc.SelectSingleNode("RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM"));
        }

        [TestMethod]
        public void RecentActivity_AddRecentActivityArticle_ExpectListWithRecentActivityArticle()
        {
            RecentActivity RecentActivity = new RecentActivity();
            RecentActivity.MostRecentArticles = new TopFiveArticles();
            TopFiveArticle RecentActivityArticle = new TopFiveArticle();
            RecentActivity.MostRecentArticles.topFiveArticleList.Add(RecentActivityArticle);
            
            DateTime updatedDate = DateTime.Now;
            DateTime eventDate = DateTime.Now.AddMinutes(5);
            RecentActivityArticle.DateUpdated.Date = new Date(updatedDate);
            RecentActivityArticle.EventDate.Date = new Date(eventDate);
            XmlDocument doc = new XmlDocument();
            doc.LoadXml("<EXTRAINFO><TYPE ID=\"1\" /></EXTRAINFO>");
            RecentActivityArticle.ExtrainfoElement = (XmlElement)doc.FirstChild;
            RecentActivityArticle.H2G2ID = 123456789;
            RecentActivityArticle.LinkItemID = 789;
            RecentActivityArticle.LinkItemName = "The WEB";
            RecentActivityArticle.LinkItemType = 1;
            RecentActivityArticle.Subject = "Unit Testing";

            User user = new User();
            user.SiteSuffix = "Site-Suffix";
            user.UserId = 517436;
            user.UserName = "NewBod";

            RecentActivityArticle.User = user;

            Assert.AreEqual(doc.FirstChild.OuterXml, RecentActivityArticle.ExtrainfoElement.OuterXml);
            Assert.AreEqual(123456789, RecentActivityArticle.H2G2ID);
            Assert.AreEqual(789, RecentActivityArticle.LinkItemID);
            Assert.AreEqual("The WEB", RecentActivityArticle.LinkItemName);
            Assert.AreEqual(1, RecentActivityArticle.LinkItemType);
            Assert.AreEqual("Unit Testing", RecentActivityArticle.Subject);
            Assert.AreEqual(user, RecentActivityArticle.User);
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

    public class RecentActivityUnkownDataaTypeTestDatabaseRow : DataReaderFactory.TestDatabaseRow
    {
        public RecentActivityUnkownDataaTypeTestDatabaseRow()
        {
            AddColumnValue("forumid-isdbnull", true);
            AddColumnValue("h2g2id-isdbnull", true);
        }
    }

    public class RecentActivityForumTestDatabaseRow : DataReaderFactory.TestDatabaseRow
    {
        public RecentActivityForumTestDatabaseRow(int forumID, int threadID, string title, string groupName, string groupDescription, bool firstRowOfType, bool followsDifferentType)
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

    public class RecentActivityArticleTestDatabaseRow : DataReaderFactory.TestDatabaseRow
    {
        public RecentActivityArticleTestDatabaseRow(DateTime dateUpdated, DateTime eventDate, string extraInfo, int h2g2ID, int linkItemID,
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
