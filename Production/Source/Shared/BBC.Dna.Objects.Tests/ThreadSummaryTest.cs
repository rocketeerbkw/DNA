using System;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using BBC.Dna.Objects;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for ThreadSummaryTest and is intended
    ///to contain all ThreadSummaryTest Unit Tests
    ///</summary>
    [TestClass]
    public class ThreadSummaryTest
    {
        public MockRepository Mocks = new MockRepository();


        /// <summary>
        ///A test for CreateThreadSummaryFromReader
        ///</summary>
        [TestMethod]
        public void CreateThreadSummaryFromReaderTest()
        {
            var mocks = new MockRepository();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetBoolean("ThisCanRead")).Return(true);
            reader.Stub(x => x.GetBoolean("ThisCanWrite")).Return(true);
            reader.Stub(x => x.GetString("FirstSubject")).Return("test>");
            reader.Stub(x => x.DoesFieldExist("FirstPostthreadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("FirstPostthreadid")).Return(1);
            reader.Stub(x => x.DoesFieldExist("LastPostthreadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("LastPostthreadid")).Return(2);
            mocks.ReplayAll();

            ThreadSummary actual = ThreadSummary.CreateThreadSummaryFromReader(reader, 0, 0);
            Assert.AreEqual(actual.CanRead, 1);
            Assert.AreEqual(actual.CanWrite, 1);
            Assert.AreEqual(actual.Subject, "test&gt;");
        }

        /// <summary>
        ///A test for CreateThreadSummaryFromReader
        ///</summary>
        [TestMethod]
        public void CreateThreadSummaryFromReader_ThisCanAsFalse()
        {
            var mocks = new MockRepository();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetBoolean("ThisCanRead")).Return(false);
            reader.Stub(x => x.GetBoolean("ThisCanWrite")).Return(false);
            reader.Stub(x => x.GetString("FirstSubject")).Return("test>");
            reader.Stub(x => x.DoesFieldExist("FirstPostthreadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("FirstPostthreadid")).Return(1);
            reader.Stub(x => x.DoesFieldExist("LastPostthreadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("LastPostthreadid")).Return(2);
            mocks.ReplayAll();

            ThreadSummary actual = ThreadSummary.CreateThreadSummaryFromReader(reader, 0, 0);
            Assert.AreEqual(actual.CanRead, 0);
            Assert.AreEqual(actual.CanWrite, 0);
            Assert.AreEqual(actual.Subject, "test&gt;");
        }


        public static ThreadSummary CreateThreadSummaryTest()
        {
            var summary = new ThreadSummary
                              {
                                  Subject = string.Empty,
                                  DateLastPosted = new DateElement(DateTime.Now),
                                  FirstPost = ThreadPostSummaryTest.GetThreadPostSummary(),
                                  LastPost = ThreadPostSummaryTest.GetThreadPostSummary(),
                              };
            return summary;
        }


        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_IsEditor_ReturnsDefaultValue()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(true);
            user.Stub(x => x.IsSuperUser).Return(false);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ThreadSummary();
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_IsSuperUser_ReturnsDefaultValue()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(false);
            user.Stub(x => x.IsSuperUser).Return(true);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ThreadSummary();
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_SiteClosed_ReturnsCannotWrite()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(false);
            user.Stub(x => x.IsSuperUser).Return(false);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(true);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ThreadSummary {CanWrite = 1};
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_SiteScheduledClosed_ReturnsCannotWrite()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(false);
            user.Stub(x => x.IsSuperUser).Return(false);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(true);
            Mocks.ReplayAll();

            var target = new ThreadSummary {CanWrite = 1};
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for ThreadId1
        ///</summary>
        [TestMethod]
        public void ThreadId1Test()
        {
            var target = new ThreadSummary();
            const int expected = 1;
            target.ThreadId1 = expected;
            int actual = target.ThreadId1;
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for ThreadId
        ///</summary>
        [TestMethod]
        public void ThreadIdTest()
        {
            var target = new ThreadSummary();
            const int expected = 1;
            target.ThreadId = expected;
            int actual = target.ThreadId;
            Assert.AreEqual(expected, actual);
        }

    }
}