using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils;
using System.Xml;
using BBC.Dna.Moderation;
using BBC.Dna.Data;
using BBC.Dna.Sites;


namespace BBC.Dna.Moderation.Tests
{
    /// <summary>
    ///This is a test class for TermTest and is intended
    ///to contain all TermTest Unit Tests
    ///</summary>
    [TestClass]
    public class ModeratorInfoTests
    {

        public MockRepository Mocks = new MockRepository();


        /// <summary>
        ///A test for UpdateTermForModClassId
        ///</summary>
        [TestMethod()]
        public void GetModeratorInfo_ValidRecordSet_ReturnsCorrectObject()
        {
            var siteId = 1;
            var siteType = SiteType.Blog;
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var readerActionItems = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            var siteList = Mocks.DynamicMock<ISiteList>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.HasRows).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("SiteClassID")).Return(1).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId).Repeat.Once();
            reader.Stub(x => x.IsDBNull("SiteClassID")).Return(false).Repeat.Once();
            reader.Stub(x => x.IsDBNull("SiteID")).Return(false).Repeat.Once();

            readerActionItems.Stub(x => x.Read()).Return(true).Repeat.Twice();
            readerActionItems.Stub(x => x.HasRows).Return(true).Repeat.Twice();
            readerActionItems.Stub(x => x.GetInt32NullAsZero("total")).Return(1).Repeat.Twice();
            readerActionItems.Stub(x => x.GetStringNullAsEmpty("sitetype")).Return("1").Repeat.Twice();
            

            creator.Stub(x => x.CreateDnaDataReader("getmoderatorinfo")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("fetchmoderationstatisticsperuserbytype")).Return(readerActionItems);
            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "General", "SiteType")).Return((int)siteType);
            Mocks.ReplayAll();

            var moderatorInfo = ModeratorInfo.GetModeratorInfo(creator, 1, siteList);

            Assert.AreEqual(1, moderatorInfo.Classes.Count);
            Assert.AreEqual(1, moderatorInfo.Sites.Count);
            Assert.AreEqual(1, moderatorInfo.ActionItems.Count);
            Assert.AreEqual(2, moderatorInfo.ActionItems[0].Total);
            
        }

       
    }
}