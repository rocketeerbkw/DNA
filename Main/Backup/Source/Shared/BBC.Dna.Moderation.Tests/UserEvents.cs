using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using System;
using BBC.Dna.Common;
using Rhino.Mocks;

namespace BBC.Dna.Moderation.Tests
{
    /// <summary>
    /// Summary description for UserEvents
    /// </summary>
    [TestClass]
    public class UserEventsTests
    {
       

        public UserEventsTests()
        {
        }

        [TestMethod]
        public void GetUserEventList_NoResults_ReturnEmptyObject()
        {
            MockRepository mocks = new MockRepository();

            var reader = mocks.DynamicMock<IDnaDataReader>();
            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            
            reader.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getuserevents")).Return(reader);
            mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { ClassId = 1 };
            var list = UserEventList.GetUserEventList(modClass, 0,0,DateTime.MinValue, DateTime.MaxValue, creator, 0);
            Assert.AreEqual(0, list.UserEventObjList.Count);
        }

        [TestMethod]
        public void GetUserEventList_SiteEventResults_ReturnCorrectObject()
        {
            MockRepository mocks = new MockRepository();

            var reader = mocks.DynamicMock<IDnaDataReader>();
            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("activitydata")).Return("<activitydata></activitydata>").Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("typeid")).Return(1).Repeat.Once();

            creator.Stub(x => x.CreateDnaDataReader("getuserevents")).Return(reader);
            mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { ClassId = 1 };
            var list = UserEventList.GetUserEventList(modClass, 0, 0, DateTime.MinValue, DateTime.MaxValue, creator, 0);
            Assert.AreEqual(1, list.UserEventObjList.Count);
        }

        [TestMethod]
        public void GetUserEventList_BadFormattedSiteEventResults_ReturnCorrectObject()
        {
            MockRepository mocks = new MockRepository();

            var reader = mocks.DynamicMock<IDnaDataReader>();
            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("activitydata")).Return("<activitydata>").Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("typeid")).Return(1).Repeat.Once();

            creator.Stub(x => x.CreateDnaDataReader("getuserevents")).Return(reader);
            mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { ClassId = 1 };
            var list = UserEventList.GetUserEventList(modClass, 0, 0, DateTime.MinValue, DateTime.MaxValue, creator, 0);
            Assert.AreEqual(0, list.UserEventObjList.Count);
        }

        [TestMethod]
        public void GetUserEventList_PostEventResults_ReturnCorrectObject()
        {
            MockRepository mocks = new MockRepository();

            var reader = mocks.DynamicMock<IDnaDataReader>();
            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("activitydata")).Return("<activitydata></activitydata>").Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("typeid")).Return((int)SiteActivityType.UserPost).Repeat.Once();

            creator.Stub(x => x.CreateDnaDataReader("getuserevents")).Return(reader);
            mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { ClassId = 1 };
            var list = UserEventList.GetUserEventList(modClass, 0, 0, DateTime.MinValue, DateTime.MaxValue, creator, 0);
            Assert.AreEqual(1, list.UserEventObjList.Count);
            Assert.AreEqual("<ACTIVITYDATA>User posted 0 times</ACTIVITYDATA>", list.UserEventObjList[0].ActivityData.ToString());
        }

        [TestMethod]
        public void GetUserEventList_PostEventResultsOnePost_ReturnCorrectObject()
        {
            MockRepository mocks = new MockRepository();

            var reader = mocks.DynamicMock<IDnaDataReader>();
            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("activitydata")).Return("<activitydata></activitydata>").Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("typeid")).Return((int)SiteActivityType.UserPost).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("numberofposts")).Return(1);

            creator.Stub(x => x.CreateDnaDataReader("getuserevents")).Return(reader);
            mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { ClassId = 1 };
            var list = UserEventList.GetUserEventList(modClass, 0, 0, DateTime.MinValue, DateTime.MaxValue, creator, 0);
            Assert.AreEqual(1, list.UserEventObjList.Count);
            Assert.AreEqual("<ACTIVITYDATA>User posted 1 time</ACTIVITYDATA>", list.UserEventObjList[0].ActivityData.ToString());
        }
    }
}
