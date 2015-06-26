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
    public class SiteSummaryStatsTests
    {

        public MockRepository Mocks = new MockRepository();


        /// <summary>
        ///A test for UpdateTermForModClassId
        ///</summary>
        [TestMethod()]
        public void GetStatsBySite_ValidRecordSet_ReturnsCorrectObject()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("TotalModerations")).Return(1).Repeat.Once();
            
            creator.Stub(x => x.CreateDnaDataReader("getsitedailysummaryreportbysite")).Return(reader);

            Mocks.ReplayAll();

            var siteSummaryStats = SiteSummaryStats.GetStatsBySite(creator, 1, DateTime.MinValue, DateTime.MinValue);

            Assert.AreEqual(1, siteSummaryStats.SiteId);
            Assert.AreEqual(1, siteSummaryStats.TotalModerations);
            
        }

        [TestMethod()]
        public void GetStatsBySite_NoRecords_ReturnsEmptyObject()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(false).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("TotalModerations")).Return(1).Repeat.Once();
            creator.Stub(x => x.CreateDnaDataReader("getsitedailysummaryreportbysite")).Return(reader);

            Mocks.ReplayAll();

            var siteSummaryStats = SiteSummaryStats.GetStatsBySite(creator, 1, DateTime.MinValue, DateTime.MinValue);

            Assert.AreEqual(1, siteSummaryStats.SiteId);
            Assert.AreEqual(0, siteSummaryStats.TotalModerations);
        }

        [TestMethod()]
        public void GetStatsByType_ValidRecordSet_ReturnsCorrectObject()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("TotalModerations")).Return(1).Repeat.Once();

            creator.Stub(x => x.CreateDnaDataReader("getsitedailysummaryreportbytype")).Return(reader);

            Mocks.ReplayAll();

            var siteSummaryStats = SiteSummaryStats.GetStatsByType(creator, SiteType.Blog, 1, DateTime.MinValue, DateTime.MinValue);

            Assert.AreEqual(1, siteSummaryStats.UserId);
            Assert.AreEqual((int)SiteType.Blog, siteSummaryStats.Type);
            Assert.AreEqual(1, siteSummaryStats.TotalModerations);

        }

        [TestMethod()]
        public void GetStatsByType_NoRecords_ReturnsEmptyObject()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(false).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("TotalModerations")).Return(1).Repeat.Once();
            creator.Stub(x => x.CreateDnaDataReader("getsitedailysummaryreportbytype")).Return(reader);

            Mocks.ReplayAll();

            var siteSummaryStats = SiteSummaryStats.GetStatsByType(creator, SiteType.Blog, 1, DateTime.MinValue, DateTime.MinValue);

            Assert.AreEqual(1, siteSummaryStats.UserId);
            Assert.AreEqual((int)SiteType.Blog, siteSummaryStats.Type);
            Assert.AreEqual(0, siteSummaryStats.TotalModerations);
        }

       
    }
}