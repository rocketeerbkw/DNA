using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Configuration;
using System.Transactions;
using BBC.Dna.Data;

namespace TheGuide.Database.UnitTests
{
    class TestDate
    {
        public DateTime TestDateTime { get; set; }

        public bool CheckDate(DateTime dateToCheckAgainst)
        {
            // if the times are within a certain tolerance, we give it the OK!
            TimeSpan ts = TestDateTime - dateToCheckAgainst;
            return (Math.Abs(ts.TotalSeconds) < 10);
        }
    }

    [TestClass]
    public class RiskModTests
    {
        string ConnectionDetails { get; set; }

        public RiskModTests()
        {
            ConnectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        class RiskModThreadEntryQueueInfo
        {
            public int siteid;
            public int forumid;
            public int? threadid;
            public int? threadentryid;
            public int? inReplyTo;
            public int? inReplyToThread;
            public string posttext;
        }

#region Risk Mod On, Publish method B

        [TestMethod]
        public void RiskModOn_PubMethodB_Unmoderated_NewThread()
        {
            using (new TransactionScope())
            {
                RiskModOn_PubMethodB_Unmoderated_NewThread_internal(new RiskModThreadEntryQueueInfo());
            }
        }

        void RiskModOn_PubMethodB_Unmoderated_NewThread_internal(RiskModThreadEntryQueueInfo info)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteModStatus(reader, siteid, "unmoderated");
                SetSiteRiskModState(reader, siteid, true, 'B');
                ClearEventQueue(reader);
                int latestThreadModId = GetLatestThreadModId(reader);

                string postText = "RiskModOn_PubMethodB_Unmoderated_NewThread";

                int? threadid, threadEntryId;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out threadEntryId, false, false);

                CheckRiskModThreadEntryQueue(reader, threadEntryId, 'B', null, null, siteid, forumid, threadid, 42, "the furry one", null, "The Cabinet", postText, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, null, null, null, (int)threadEntryId, null, 0, 1, postText);

                // Check that no new entries have been created in the threadmod table
                Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));

                int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));

                info.siteid = siteid;
                info.forumid = forumid;
                info.threadid = threadid;
                info.threadentryid = threadEntryId;
                info.posttext = postText;
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodB_PostModerated_NewThread()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_PostModerated_NewThread("On", 'B');
            }
        }

        bool OnOrOff(string onOrOff)
        {
            var a = new[] { new { s = "On", b = true }, new { s = "Off", b = false } };
            return a.Where(x => x.s == onOrOff).First().b;
        }

        void RiskMod_PostModerated_NewThread(string onOrOff, char publishMethod)
        {
            bool isOn=OnOrOff(onOrOff);

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteModStatus(reader, siteid, "postmoderated");
                SetSiteRiskModState(reader, siteid, isOn, publishMethod);
                ClearEventQueue(reader);
                int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);

                string postText = "RiskModOn_PostModerated_NewThread_internal Publish Method:"+publishMethod;

                int? threadid, threadEntryId;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out threadEntryId, false, false);

                CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, null, null, null, (int)threadEntryId, null, 0, 1, postText);

                CheckLatestThreadMod(reader, forumid, (int)threadid, (int)threadEntryId, null, 0, null, siteid, 0);

                // Check that no new entries have been created in the RiskModThreadEntryQueue table
                Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));

                int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                Assert.IsFalse(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodB_Premoderated_NewThread()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_Premoderated_NewThread("On",'B');
            }
        }

        void RiskMod_Premoderated_NewThread(string onOrOff, char publishMethod)
        {
            bool isOn = OnOrOff(onOrOff);

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteModStatus(reader, siteid, "premoderated");
                SetSiteRiskModState(reader, siteid, isOn, publishMethod);
                ClearEventQueue(reader);
                SetSiteOptionProcessPremod(reader, siteid, false);
                int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);

                string postText = "RiskModOn_PubMethodB_Premoderated_NewThread";

                int? threadid, threadEntryId;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out threadEntryId, false, false);

                CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, null, null, null, (int)threadEntryId, 3, 0, 1, postText);

                CheckLatestThreadMod(reader, forumid, (int)threadid, (int)threadEntryId, null, 0, null, siteid, 0);

                // Check that no new entries have been created in the RiskModThreadEntryQueue table
                Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));

                int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                Assert.IsFalse(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodB_PremodPostings_NewThread()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_PremodPostings_NewThread("On",'B');
            }
        }

        void RiskMod_PremodPostings_NewThread(string onOrOff, char publishMethod)
        {
            bool isOn = OnOrOff(onOrOff);

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteModStatus(reader, siteid, "premoderated");
                SetSiteRiskModState(reader, siteid, isOn, publishMethod);
                ClearEventQueue(reader);
                SetSiteOptionProcessPremod(reader, siteid, true);

                int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);
                int latestThreadId = GetLatestThreadId(reader);
                int latestThreadEntryId = GetLatestThreadEntryId(reader);

                string postText = "RiskModOn_PubMethodB_PremodPostings_NewThread";

                int? threadid, threadEntryId;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out threadEntryId, false, false);

                CheckLatestThreadMod(reader, forumid, threadid, threadEntryId, null, 0, null, siteid, 1);

                int modId = GetLatestThreadModId(reader);
                CheckLatestPremodPostings(reader, modId, 42, forumid, threadid, null, postText, 1, siteid, 0, null);

                // Check that no new entries have been created in the RiskModThreadEntryQueue, Threads and ThreadEntries tables
                Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));
                Assert.AreEqual(latestThreadId, GetLatestThreadId(reader));
                Assert.AreEqual(latestThreadEntryId, GetLatestThreadEntryId(reader));

                // No events should be created
                Assert.AreEqual(0, CountEventQueueEntries(reader));
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodB_Unmoderated_InReplyTo()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int siteid, forumid;
                    GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                    SetSiteModStatus(reader, siteid, "unmoderated");
                    SetSiteRiskModState(reader, siteid, true, 'B');
                    ClearEventQueue(reader);
                    int latestThreadModId = GetLatestThreadModId(reader);

                    string postText = "RiskModOn_PubMethodB_Unmoderated_InReplyTo";

                    // Get a thread entry to reply to
                    int? threadid, threadEntryId, inReplyTo;
                    RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out inReplyTo, false, false);

                    postText = "replying to prev post";
                    RiskModTestPostHelper(reader, forumid, threadid, inReplyTo, 42, postText, out threadid, out threadEntryId, false, false);

                    CheckRiskModThreadEntryQueue(reader, threadEntryId, 'B', null, null, siteid, forumid, threadid, 42, "the furry one", inReplyTo, "The Cabinet", postText, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                    CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, inReplyTo, null, null, (int)threadEntryId, null, 1, 1, postText);

                    // Check that no new entries have been created in the threadmod table
                    Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));

                    int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                    Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                    Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
                }
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodB_PostModerated_InReplyTo()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_PostModerated_InReplyTo("On",'B');
            }
        }

        void RiskMod_PostModerated_InReplyTo(string onOrOff, char publishMethod)
        {
            bool isOn = OnOrOff(onOrOff);

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteModStatus(reader, siteid, "postmoderated");
                SetSiteRiskModState(reader, siteid, isOn, publishMethod);
                ClearEventQueue(reader);
                int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);

                string postText = "RiskModOn_PubMethodB_PostModerated_InReplyTo";

                // Get a thread entry to reply to
                int? threadid, threadEntryId, inReplyTo;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out inReplyTo, false, false);

                postText = "replying to prev post";
                RiskModTestPostHelper(reader, forumid, threadid, inReplyTo, 42, postText, out threadid, out threadEntryId, false, false);

                CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, inReplyTo, null, null, (int)threadEntryId, null, 1, 1, postText);

                CheckLatestThreadMod(reader, forumid, (int)threadid, (int)threadEntryId, null, 0, null, siteid, 0);

                // Check that no new entries have been created in the RiskModThreadEntryQueue table
                Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));

                int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                Assert.IsFalse(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodB_Premoderated_InReplyTo()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_Premoderated_InReplyTo("On",'B');
            }
        }

        void RiskMod_Premoderated_InReplyTo(string onOrOff, char publishMethod)
        {
            bool isOn = OnOrOff(onOrOff);

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteModStatus(reader, siteid, "premoderated");
                SetSiteRiskModState(reader, siteid, isOn, publishMethod);
                ClearEventQueue(reader);
                SetSiteOptionProcessPremod(reader, siteid, false);
                int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);

                string postText = "RiskModOn_PubMethodB_Premoderated_InReplyTo";

                // Get a thread entry to reply to
                int? threadid, threadEntryId, inReplyTo;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out inReplyTo, false, false);

                postText = "replying to prev post";
                RiskModTestPostHelper(reader, forumid, threadid, inReplyTo, 42, postText, out threadid, out threadEntryId, false, false);

                CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, inReplyTo, null, null, (int)threadEntryId, 3, 1, 1, postText);

                CheckLatestThreadMod(reader, forumid, (int)threadid, (int)threadEntryId, null, 0, null, siteid, 0);

                // Check that no new entries have been created in the RiskModThreadEntryQueue table
                Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));

                int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                Assert.IsFalse(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodB_PremodPostings_InReplyTo()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_PremodPostings_InReplyTo("On",'B');
            }
        }

        void RiskMod_PremodPostings_InReplyTo(string onOrOff, char publishMethod)
        {
            bool isOn = OnOrOff(onOrOff);

            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteRiskModState(reader, siteid, isOn, publishMethod);
                ClearEventQueue(reader);
                SetSiteOptionProcessPremod(reader, siteid, true);

                // Post the first post postmoderated, so we get a threadentry to reply to
                SetSiteModStatus(reader, siteid, "postmoderated");

                int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);
                int latestThreadId = GetLatestThreadId(reader);
                int latestThreadEntryId = GetLatestThreadEntryId(reader);

                string postText = "RiskModOn_PubMethodB_PremodPostings_InReplyTo";

                // Get a thread entry to reply to
                int? threadid, threadEntryId, inReplyToThread, inReplyTo;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out inReplyToThread, out inReplyTo, false, false);

                // Now switch to premoderated with premodposting
                SetSiteModStatus(reader, siteid, "premoderated");

                int latestEventQueueCount = CountEventQueueEntries(reader);

                postText = "replying to prev post";
                RiskModTestPostHelper(reader, forumid, inReplyToThread, inReplyTo, 42, postText, out threadid, out threadEntryId, false, false);

                CheckLatestThreadMod(reader, forumid, inReplyToThread, threadEntryId, null, 0, null, siteid, 1);

                int modId = GetLatestThreadModId(reader);
                CheckLatestPremodPostings(reader, modId, 42, forumid, inReplyToThread, inReplyTo, postText, 1, siteid, 0, null);

                // Check that no new entries have been created in the RiskModThreadEntryQueue
                Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));

                // Check the latest thread and thread entries are as expected
                Assert.AreEqual(inReplyToThread, GetLatestThreadId(reader));
                Assert.AreEqual(inReplyTo, GetLatestThreadEntryId(reader));

                // Check that no new events were be created for the premod posting
                Assert.AreEqual(latestEventQueueCount, CountEventQueueEntries(reader));

                ModeratePost(reader, forumid, threadid.Value, /*postid*/ 0, modId, 3, "Testing", /*referto*/ null, /*referredby*/ 42);
            }
        }

#endregion
#region Risk Mod On, Publish method A

        [TestMethod]
        public void RiskModOn_PubMethodA_Unmoderated_NewThread()
        {
            using (new TransactionScope())
            {
                RiskModOn_PubMethodA_Unmoderated_NewThread_internal(new RiskModThreadEntryQueueInfo());
            }
        }

        void RiskModOn_PubMethodA_Unmoderated_NewThread_internal(RiskModThreadEntryQueueInfo info)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteModStatus(reader, siteid, "unmoderated");
                SetSiteRiskModState(reader, siteid, true, 'A');
                ClearEventQueue(reader);

                int latestThreadEntryId = GetLatestThreadEntryId(reader);
                int latestThreadId = GetLatestThreadId(reader);
                int latestThreadModId = GetLatestThreadModId(reader);
                int latestPremodPostingsModId = GetLatestPremodPostingsModId(reader);

                string postText = "RiskModOn_PubMethodA_Unmoderated_NewThread";

                int? threadid, threadEntryId;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out threadEntryId, false, false);

                CheckRiskModThreadEntryQueue(reader, threadEntryId, 'A', null, null, siteid, forumid, threadid, 42, "the furry one", null, "The Cabinet", postText, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                // Check that no new rows have been created in the other tables
                Assert.AreEqual(latestThreadEntryId, GetLatestThreadEntryId(reader));
                Assert.AreEqual(latestThreadId, GetLatestThreadId(reader));
                Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));
                Assert.AreEqual(latestPremodPostingsModId, GetLatestPremodPostingsModId(reader));

                int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                // Check that only ET_POSTNEEDSRISKASSESSMENT has been generated
                Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                Assert.AreEqual(1, CountEventQueueEntries(reader));

                info.forumid = forumid;
                info.siteid = siteid;
                info.posttext = postText;
                info.threadid = threadid;
                info.threadentryid = threadEntryId;
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodA_PostModerated_NewThread()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_PostModerated_NewThread("On", 'A');
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodA_Premoderated_NewThread()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_Premoderated_NewThread("On",'A');
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodA_PremodPostings_NewThread()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_PremodPostings_NewThread("On",'A');
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodA_Unmoderated_InReplyTo()
        {
            using (new TransactionScope())
            {
                RiskModOn_PubMethodA_Unmoderated_InReplyTo_internal(new RiskModThreadEntryQueueInfo());
            }
        }

        void RiskModOn_PubMethodA_Unmoderated_InReplyTo_internal(RiskModThreadEntryQueueInfo info)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                int siteid, forumid;
                GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                SetSiteModStatus(reader, siteid, "unmoderated");
                ClearEventQueue(reader);
                int latestThreadModId = GetLatestThreadModId(reader);

                string postText1 = "RiskModOn_PubMethodA_Unmoderated_InReplyTo";

                // Turn off risk mod to start with
                SetSiteRiskModState(reader, siteid, false, 'A');

                // Get a thread entry to reply to
                int? threadid, threadEntryId, inReplyToThread, inReplyTo;
                RiskModTestPostHelper(reader, forumid, null, null, 42, postText1, out inReplyToThread, out inReplyTo, false, false);

                // Turn on risk mod, to test inReplyTo behaviour
                SetSiteRiskModState(reader, siteid, true, 'A');

                string postText2 = "replying to prev post";
                RiskModTestPostHelper(reader, forumid, inReplyToThread, inReplyTo, 42, postText2, out threadid, out threadEntryId, false, false);

                CheckRiskModThreadEntryQueue(reader, threadEntryId, 'A', null, null, siteid, forumid, inReplyToThread, 42, "the furry one", inReplyTo, "The Cabinet", postText2, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                CheckLatestThread(reader, (int)inReplyToThread, forumid, 1, 1, siteid);

                CheckLatestThreadEntry(reader, (int)inReplyToThread, forumid, 42, null, null, null, null, (int)inReplyTo, null, 0, 1, postText1);

                // Check that no new entries have been created in the threadmod table
                Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));

                int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)inReplyToThread, 42));
                Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)inReplyToThread, 42));
                Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)inReplyTo, 42));

                info.forumid = forumid;
                info.siteid = siteid;
                info.posttext = postText2;
                info.threadid = threadid;
                info.threadentryid = threadEntryId;
                info.inReplyTo = inReplyTo;
                info.inReplyToThread = inReplyToThread;
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodA_PostModerated_InReplyTo()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_PostModerated_InReplyTo("On", 'A');
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodA_Premoderated_InReplyTo()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_Premoderated_InReplyTo("On",'A');
            }
        }

        [TestMethod]
        public void RiskModOn_PubMethodA_PremodPostings_InReplyTo()
        {
            using (new TransactionScope())
            {
                //  The same thing should happen for publish method A as it does for B
                RiskMod_PremodPostings_InReplyTo("On",'A');
            }
        }

#endregion

#region Risk Mod Off

        [TestMethod]
        public void RiskModOff_PubMethodB_Unmoderated_NewThread()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int siteid, forumid;
                    GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                    SetSiteModStatus(reader, siteid, "unmoderated");
                    SetSiteRiskModState(reader, siteid, false, 'B');
                    ClearEventQueue(reader);

                    int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);
                    int latestThreadModId = GetLatestThreadModId(reader);
                    int latestPremodPostingsModId = GetLatestPremodPostingsModId(reader);

                    string postText = "RiskModOff_Unmoderated_NewThread";

                    int? threadid, threadEntryId;
                    RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out threadEntryId, false, false);

                    CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                    CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, null, null, null, (int)threadEntryId, null, 0, 1, postText);

                    // Check that no new rows have been created in the these tables:
                    Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));
                    Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));
                    Assert.AreEqual(latestPremodPostingsModId, GetLatestPremodPostingsModId(reader));

                    int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                    Assert.IsFalse(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                    Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
                }
            }
        }

        [TestMethod]
        public void RiskModOff_PostModerated_NewThread()
        {
            using (new TransactionScope())
            {
                // Risk mod is off.  Publish method irrelevant.  Should be the same as a PostMod with risk mod on
                RiskMod_PostModerated_NewThread("Off", 'A');
            }
        }

        [TestMethod]
        public void RiskModOff_Premoderated_NewThread()
        {
            using (new TransactionScope())
            {
                // Risk mod is off.  Publish method irrelevant.  Should be the same as a PostMod with risk mod on
                RiskMod_Premoderated_NewThread("Off", 'A');
            }
        }

        [TestMethod]
        public void RiskModOff_PremodPosting_NewThread()
        {
            using (new TransactionScope())
            {
                // Risk mod is off.  Publish method irrelevant.  Should be the same as a PostMod with risk mod on
                RiskMod_PremodPostings_NewThread("Off", 'A');
            }
        }

        [TestMethod]
        public void RiskModOff_PubMethodB_Unmoderated_InReplyTo()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int siteid, forumid;
                    GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                    SetSiteModStatus(reader, siteid, "unmoderated");
                    SetSiteRiskModState(reader, siteid, false, 'B');
                    ClearEventQueue(reader);

                    int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);
                    int latestThreadModId = GetLatestThreadModId(reader);
                    int latestPremodPostingsModId = GetLatestPremodPostingsModId(reader);

                    string postText = "RiskModOn_PubMethodB_Unmoderated_InReplyTo";

                    // Get a thread entry to reply to
                    int? threadid, threadEntryId, inReplyTo;
                    RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out inReplyTo, false, false);

                    postText = "replying to prev post";
                    RiskModTestPostHelper(reader, forumid, threadid, inReplyTo, 42, postText, out threadid, out threadEntryId, false, false);

                    CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                    CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, inReplyTo, null, null, (int)threadEntryId, null, 1, 1, postText);

                    // Check that no new rows have been created in the these tables:
                    Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));
                    Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));
                    Assert.AreEqual(latestPremodPostingsModId, GetLatestPremodPostingsModId(reader));

                    int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                    Assert.IsFalse(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                    Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
                }
            }
        }

        [TestMethod]
        public void RiskModOff_PostModerated_InReplyTo()
        {
            using (new TransactionScope())
            {
                // Risk mod is off.  Publish method irrelevant.  Should be the same as a PostMod with risk mod on
                RiskMod_PostModerated_InReplyTo("Off", 'A');
            }
        }

        [TestMethod]
        public void RiskModOff_Premoderated_InReplyTo()
        {
            using (new TransactionScope())
            {
                // Risk mod is off.  Publish method irrelevant.  Should be the same as a PostMod with risk mod on
                RiskMod_Premoderated_InReplyTo("Off", 'A');
            }
        }

        [TestMethod]
        public void RiskModOff_PremodPosting_InReplyTo()
        {
            using (new TransactionScope())
            {
                // Risk mod is off.  Publish method irrelevant.  Should be the same as a PostMod with risk mod on
                RiskMod_PremodPostings_InReplyTo("Off", 'A');
            }
        }

#endregion

#region Process Risk Mod Assements

        [TestMethod]
        public void ProcessRiskModAssessment_PubMethodB_NewThread_NotRisky()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    ClearBIEventQueue(reader);

                    // Create a risk mod entry
                    var info = new RiskModThreadEntryQueueInfo();
                    RiskModOn_PubMethodB_Unmoderated_NewThread_internal(info);

                    int riskModId = GetLatestRiskModThreadEntryQueueId(reader);

                    GenerateBIEvents(reader);
                    Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInBIEventQueue(reader, riskModId, 42));

                    bool? isRisky = null;
                    CheckRiskModThreadEntryQueue(reader, info.threadentryid, 'B', isRisky, null, info.siteid, info.forumid, info.threadid, 42, "the furry one", null, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    int latestThreadModId = GetLatestThreadModId(reader);

                    int? newThreadId, newThreadEntryId;
                    RiskMod_ProcessRiskAssessmentForThreadEntry(reader, riskModId, "NotRisky", out newThreadId, out newThreadEntryId);

                    Assert.IsNull(newThreadId);
                    Assert.IsNull(newThreadEntryId);

                    isRisky = false;
                    TestDate td = new TestDate() { TestDateTime = DateTime.Now };
                    CheckRiskModThreadEntryQueue(reader, info.threadentryid, 'B', isRisky, td, info.siteid, info.forumid, info.threadid, 42, "the furry one", null, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    // check no mod queue entry was created
                    Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));
                }
            }
        }

        [TestMethod]
        public void ProcessRiskModAssessment_PubMethodB_NewThread_Risky()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    ClearBIEventQueue(reader);

                    // Create a risk mod entry
                    var info = new RiskModThreadEntryQueueInfo();
                    RiskModOn_PubMethodB_Unmoderated_NewThread_internal(info);

                    int riskModId = GetLatestRiskModThreadEntryQueueId(reader);

                    GenerateBIEvents(reader);
                    Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInBIEventQueue(reader, riskModId, 42));

                    bool? isRisky = null;
                    CheckRiskModThreadEntryQueue(reader, info.threadentryid, 'B', isRisky, null, info.siteid, info.forumid, info.threadid, 42, "the furry one", null, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    int? newThreadId, newThreadEntryId;
                    RiskMod_ProcessRiskAssessmentForThreadEntry(reader, riskModId, "Risky", out newThreadId, out newThreadEntryId);

                    Assert.IsNull(newThreadId);
                    Assert.IsNull(newThreadEntryId);

                    isRisky = true;
                    TestDate td = new TestDate() { TestDateTime = DateTime.Now };
                    CheckRiskModThreadEntryQueue(reader, info.threadentryid, 'B', isRisky, td, info.siteid, info.forumid, info.threadid, 42, "the furry one", null, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    // Check that an entry ended up in the thread mod queue
                    CheckLatestThreadMod(reader, info.forumid, info.threadid, info.threadentryid, null, 0, "[The post was published before being queued by risk moderation]", info.siteid, 0);
                }
            }
        }

        [TestMethod]
        public void ProcessRiskModAssessment_PubMethodA_NewThread_NotRisky()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    ClearBIEventQueue(reader);

                    // Create a risk mod entry
                    var info = new RiskModThreadEntryQueueInfo();
                    RiskModOn_PubMethodA_Unmoderated_NewThread_internal(info);

                    int riskModId = GetLatestRiskModThreadEntryQueueId(reader);

                    GenerateBIEvents(reader);
                    Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInBIEventQueue(reader, riskModId, 42));

                    bool? isRisky = null;
                    CheckRiskModThreadEntryQueue(reader, info.threadentryid, 'A', isRisky, null, info.siteid, info.forumid, info.threadid, 42, "the furry one", null, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    int latestThreadModId = GetLatestThreadModId(reader);

                    int? newThreadId, newThreadEntryId;
                    RiskMod_ProcessRiskAssessmentForThreadEntry(reader, riskModId, "NotRisky", out newThreadId, out newThreadEntryId);

                    isRisky = false;
                    TestDate td = new TestDate() { TestDateTime = DateTime.Now };
                    CheckRiskModThreadEntryQueue(reader, newThreadEntryId, 'A', isRisky, td, info.siteid, info.forumid, newThreadId, 42, "the furry one", null, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    CheckLatestThreadEntry(reader, (int)newThreadId, info.forumid, 42, null, null, null, null, (int)newThreadEntryId, null, 0, 1, info.posttext);

                    CheckLatestThread(reader, (int)newThreadId, info.forumid, 1, 1, info.siteid);

                    // check no mod queue entry was created
                    Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));
                }
            }
        }

        [TestMethod]
        public void ProcessRiskModAssessment_PubMethodA_NewThread_Risky()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    ClearBIEventQueue(reader);

                    // Create a risk mod entry
                    var info = new RiskModThreadEntryQueueInfo();
                    RiskModOn_PubMethodA_Unmoderated_NewThread_internal(info);

                    int riskModId = GetLatestRiskModThreadEntryQueueId(reader);

                    GenerateBIEvents(reader);
                    Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInBIEventQueue(reader, riskModId, 42));

                    bool? isRisky = null;
                    CheckRiskModThreadEntryQueue(reader, info.threadentryid, 'A', isRisky, null, info.siteid, info.forumid, info.threadid, 42, "the furry one", null, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    int latestThreadId = GetLatestThreadId(reader);
                    int latestThreadEntryId = GetLatestThreadEntryId(reader);

                    int? newThreadId, newThreadEntryId;
                    RiskMod_ProcessRiskAssessmentForThreadEntry(reader, riskModId, "Risky", out newThreadId, out newThreadEntryId);

                    isRisky = true;
                    TestDate td = new TestDate() { TestDateTime = DateTime.Now };
                    CheckRiskModThreadEntryQueue(reader, newThreadEntryId, 'A', isRisky, td, info.siteid, info.forumid, newThreadId, 42, "the furry one", null, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    CheckLatestThreadMod(reader, info.forumid, newThreadId, newThreadEntryId, null, 0, "[The post will be published after moderation. Queued by risk moderation]", info.siteid, 1);

                    int modId = GetLatestThreadModId(reader);
                    CheckLatestPremodPostings(reader, modId, 42, info.forumid, newThreadId, null, info.posttext, 1, info.siteid, 0, riskModId);

                    // check no mod queue entry was created
                    Assert.AreEqual(latestThreadId, GetLatestThreadId(reader));
                    Assert.AreEqual(latestThreadEntryId, GetLatestThreadEntryId(reader));
                }
            }
        }

        [TestMethod]
        public void ProcessRiskModAssessment_PubMethodA_InReplyTo_NotRisky()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    ClearBIEventQueue(reader);

                    // Create a risk mod entry
                    var info = new RiskModThreadEntryQueueInfo();
                    RiskModOn_PubMethodA_Unmoderated_InReplyTo_internal(info);

                    int riskModId = GetLatestRiskModThreadEntryQueueId(reader);

                    GenerateBIEvents(reader);
                    Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInBIEventQueue(reader, riskModId, 42));

                    bool? isRisky = null;
                    CheckRiskModThreadEntryQueue(reader, info.threadentryid, 'A', isRisky, null, info.siteid, info.forumid, info.inReplyToThread, 42, "the furry one", info.inReplyTo, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    int latestThreadModId = GetLatestThreadModId(reader);

                    int? newThreadId, newThreadEntryId;
                    RiskMod_ProcessRiskAssessmentForThreadEntry(reader, riskModId, "NotRisky", out newThreadId, out newThreadEntryId);

                    isRisky = false;
                    TestDate td = new TestDate() { TestDateTime = DateTime.Now };
                    CheckRiskModThreadEntryQueue(reader, newThreadEntryId, 'A', isRisky, td, info.siteid, info.forumid, newThreadId, 42, "the furry one", info.inReplyTo, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    CheckLatestThreadEntry(reader, (int)newThreadId, info.forumid, 42, null, info.inReplyTo, null, null, (int)newThreadEntryId, null, 1, 1, info.posttext);

                    CheckLatestThread(reader, (int)newThreadId, info.forumid, 1, 1, info.siteid);

                    // check no mod queue entry was created
                    Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));
                }
            }
        }

        [TestMethod]
        public void ProcessRiskModAssessment_PubMethodA_InReplyTo_Risky()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    ClearBIEventQueue(reader);

                    // Create a risk mod entry
                    var info = new RiskModThreadEntryQueueInfo();
                    RiskModOn_PubMethodA_Unmoderated_InReplyTo_internal(info);

                    int riskModId = GetLatestRiskModThreadEntryQueueId(reader);

                    GenerateBIEvents(reader);
                    Assert.IsTrue(CheckEventET_POSTNEEDSRISKASSESSMENTIsInBIEventQueue(reader, riskModId, 42));

                    bool? isRisky = null;
                    CheckRiskModThreadEntryQueue(reader, info.threadentryid, 'A', isRisky, null, info.siteid, info.forumid, info.inReplyToThread, 42, "the furry one", info.inReplyTo, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    int latestThreadId = GetLatestThreadId(reader);
                    int latestThreadEntryId = GetLatestThreadEntryId(reader);

                    int? newThreadId, newThreadEntryId;
                    RiskMod_ProcessRiskAssessmentForThreadEntry(reader, riskModId, "Risky", out newThreadId, out newThreadEntryId);

                    isRisky = true;
                    TestDate td = new TestDate() { TestDateTime = DateTime.Now };
                    CheckRiskModThreadEntryQueue(reader, newThreadEntryId, 'A', isRisky, td, info.siteid, info.forumid, info.inReplyToThread, 42, "the furry one", info.inReplyTo, "The Cabinet", info.posttext, 1, "testip", testGUID.ToString(), DateTime.Now, 1, 0, null, 0, 0, 0, null, 0);

                    CheckLatestThreadMod(reader, info.forumid, info.inReplyToThread, newThreadEntryId, null, 0, "[The post will be published after moderation. Queued by risk moderation]", info.siteid, 1);

                    int modId = GetLatestThreadModId(reader);
                    CheckLatestPremodPostings(reader, modId, 42, info.forumid, info.inReplyToThread, info.inReplyTo, info.posttext, 1, info.siteid, 0, riskModId);

                    // check no mod queue entry was created
                    Assert.AreEqual(latestThreadId, GetLatestThreadId(reader));
                    Assert.AreEqual(latestThreadEntryId, GetLatestThreadEntryId(reader));
                }
            }
        }

#endregion

#region Risk Mod On but ignoremoderation set to 1

        [TestMethod]
        public void RiskModOn_PubMethodB_Unmoderated_NewThread_IgnoreModerationOn()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int siteid, forumid;
                    GetRiskModTestSiteAndForum(reader, out siteid, out forumid);
                    SetSiteModStatus(reader, siteid, "unmoderated");
                    SetSiteRiskModState(reader, siteid, true, 'B');  // Risk mod is on
                    ClearEventQueue(reader);

                    int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);
                    int latestThreadModId = GetLatestThreadModId(reader);
                    int latestPremodPostingsModId = GetLatestPremodPostingsModId(reader);

                    string postText = "RiskModOn_PubMethodB_Unmoderated_NewThread_IgnoreModerationOn";

                    int? threadid, threadEntryId;
                    RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out threadEntryId, true, false);  // Ingnore Moderation is true

                    CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                    CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, null, null, null, (int)threadEntryId, null, 0, 1, postText);

                    // Check that no new rows have been created in the these tables:
                    Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));
                    Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));
                    Assert.AreEqual(latestPremodPostingsModId, GetLatestPremodPostingsModId(reader));

                    int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                    Assert.IsFalse(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                    Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
                }
            }
        }

#endregion

        [TestMethod]
        public void PremodPosting_CheckEvents()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int siteid, forumid;
                    GetRiskModTestSiteAndForum(reader, out siteid, out forumid);

                    // For this test is shouldn't matter 
                    SetSiteModStatus(reader, siteid, "unmoderated");
                    SetSiteRiskModState(reader, siteid, true, 'B');  // Risk mod is on
                    ClearEventQueue(reader);

                    int latestRiskModId = GetLatestRiskModThreadEntryQueueId(reader);
                    int latestThreadModId = GetLatestThreadModId(reader);
                    int latestPremodPostingsModId = GetLatestPremodPostingsModId(reader);

                    string postText = "RiskModOn_PubMethodB_Unmoderated_NewThread_IgnoreModerationOn";

                    int? threadid, threadEntryId;
                    RiskModTestPostHelper(reader, forumid, null, null, 42, postText, out threadid, out threadEntryId, true, false);  // Ingnore Moderation is true

                    CheckLatestThread(reader, (int)threadid, forumid, 1, 1, siteid);

                    CheckLatestThreadEntry(reader, (int)threadid, forumid, 42, null, null, null, null, (int)threadEntryId, null, 0, 1, postText);

                    // Check that no new rows have been created in the these tables:
                    Assert.AreEqual(latestRiskModId, GetLatestRiskModThreadEntryQueueId(reader));
                    Assert.AreEqual(latestThreadModId, GetLatestThreadModId(reader));
                    Assert.AreEqual(latestPremodPostingsModId, GetLatestPremodPostingsModId(reader));

                    int rmId = GetLatestRiskModThreadEntryQueueId(reader);

                    Assert.IsFalse(CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(reader, rmId, 42));
                    Assert.IsTrue(CheckEventET_FORUMEDITEDIsInInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTNEWTHREADIsInQueue(reader, forumid, (int)threadid, 42));
                    Assert.IsTrue(CheckEventET_POSTTOFORUMIsInQueue(reader, forumid, (int)threadEntryId, 42));
                }
            }
        }

        int RiskyOrNotRisky(string riskyOrNotRisky)
        {
            var a = new[] { new { s = "Risky", v = 1 }, new { s = "NotRisky", v = 0 } };
            return a.Where(x => x.s == riskyOrNotRisky).First().v;
        }


        void RiskMod_ProcessRiskAssessmentForThreadEntry(IDnaDataReader reader, int riskModId, string isRisky, out int? newThreadId, out int? newThreadEntryId)
        {
            string sql = string.Format(@"
                            declare @ret int
                            exec @ret=riskmod_processriskassessmentforthreadentry @riskmodthreadentryqueueid={0}, @risky={1}
                            ", riskModId, RiskyOrNotRisky(isRisky));
            reader.ExecuteWithinATransaction(sql);
            reader.Read();

            if (reader.DoesFieldExist("ThreadId"))
            {
                newThreadId = reader.GetInt32("ThreadID");
                newThreadEntryId = reader.GetInt32("PostID");
            }
            else
            {
                newThreadId = newThreadEntryId = null;
            }
        }

        void ProcessEventQueue(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction("exec processeventqueue");
        }

        void GenerateBIEvents(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction(@"
		                    DECLARE @TopEventID INT
		                    SELECT @TopEventID = MAX(EventID) FROM dbo.EventQueue
                            EXEC dbo.generatebievents @TopEventID");
        }


        void ClearBIEventQueue(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction("delete from bieventqueue");
        }



        bool CheckEventIsInBIEventQueue(IDnaDataReader reader, EventTypes EventType, int ItemID, EventItemTypes ItemType, int ItemID2, EventItemTypes ItemType2, int EventUserID)
        {
            string sql = string.Format(@"
                    select 1
                    from BIeventQueue with(nolock)
                    where EventType={0} and ItemID={1} and ItemType={2} and ItemID2={3} and ItemType2={4} and EventUserID={5}
            ", (int)EventType, ItemID, (int)ItemType, ItemID2, (int)ItemType2, EventUserID);

            reader.ExecuteWithinATransaction(sql);

            return reader.HasRows;
        }

        bool CheckEventET_POSTNEEDSRISKASSESSMENTIsInBIEventQueue(IDnaDataReader reader, int riskModId, int userid)
        {
            bool r = CheckEventIsInBIEventQueue(reader, EventTypes.ET_POSTNEEDSRISKASSESSMENT, riskModId, EventItemTypes.IT_RISKMODQUEUEID, 0, EventItemTypes.IT_ALL, userid);
            return r;
        }

        bool CheckEventIsInQueue(IDnaDataReader reader, EventTypes EventType, int ItemID, EventItemTypes ItemType, int ItemID2, EventItemTypes ItemType2, int EventUserID)
        {
            string sql = string.Format(@"
                    select 1
                    from eventQueue with(nolock)
                    where EventType={0} and ItemID={1} and ItemType={2} and ItemID2={3} and ItemType2={4} and EventUserID={5}
            ", (int)EventType, ItemID, (int)ItemType, ItemID2, (int)ItemType2, EventUserID);

            reader.ExecuteWithinATransaction(sql);

            return reader.HasRows;
        }

        bool CheckEventET_POSTNEEDSRISKASSESSMENTIsInQueue(IDnaDataReader reader, int riskModId, int userid)
        {
            bool r = CheckEventIsInQueue(reader, EventTypes.ET_POSTNEEDSRISKASSESSMENT, riskModId, EventItemTypes.IT_RISKMODQUEUEID, 0, EventItemTypes.IT_ALL, userid);
            return r;
        }

        bool CheckEventET_FORUMEDITEDIsInInQueue(IDnaDataReader reader, int forumid, int threadid, int userid)
        {
            bool r = CheckEventIsInQueue(reader, EventTypes.ET_FORUMEDITED, forumid, EventItemTypes.IT_FORUM, threadid, EventItemTypes.IT_THREAD, userid);
            return r;
        }

        bool CheckEventET_POSTNEWTHREADIsInQueue(IDnaDataReader reader, int forumid, int threadid, int userid)
        {
            bool r = CheckEventIsInQueue(reader, EventTypes.ET_POSTNEWTHREAD, forumid, EventItemTypes.IT_FORUM, threadid, EventItemTypes.IT_THREAD, userid);
            return r;
        }

        bool CheckEventET_POSTTOFORUMIsInQueue(IDnaDataReader reader, int forumid, int threadentryid, int userid)
        {
            bool r = CheckEventIsInQueue(reader, EventTypes.ET_POSTTOFORUM, forumid, EventItemTypes.IT_FORUM, threadentryid, EventItemTypes.IT_ENTRYID, userid);
            return r;
        }

        void ClearEventQueue(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction("delete from eventqueue");
            reader.Close();
        }

        int CountEventQueueEntries(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction("select count(*) as C from eventqueue");
            reader.Read();
            int c = reader.GetInt32("C");
            reader.Close();
            return c;
        }

        void ClearRiskModThreadEntryQueue(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction("delete from RiskModThreadEntryQueue");
            reader.Close();
        }

        void SetSiteRiskModState(IDnaDataReader reader, int siteid, bool ison, char state)
        {
            string sql = string.Format("EXEC riskmod_setsitestate @siteid = {0}, @ison = {1}, @publishmethod = '{2}'", siteid, ison?1:0, state);
            reader.ExecuteWithinATransaction(sql);
        }

        void SetSiteModStatus(IDnaDataReader reader, int siteid, string modStatus)
        {
            int premoderation=0, unmoderated=0;
            switch (modStatus.ToLower())
            {
                case "unmoderated":   premoderation = 0; unmoderated = 1; break;
                case "postmoderated": premoderation = 0; unmoderated = 0; break;
                case "premoderated":  premoderation = 1; unmoderated = 0; break;
                default: Assert.Fail("Unknown moderation status"); break;
            }

            string sql = string.Format("UPDATE Sites SET premoderation={1}, unmoderated={2} WHERE siteid={0}", siteid, premoderation, unmoderated);
            reader.ExecuteWithinATransaction(sql);
        }

        void SetSiteOptionInt(IDnaDataReader reader, int siteid, string section, string name, int val, int type)
        {
            string sql =string.Format(@"  
                    delete siteoptions where siteid={0} and section='{1}' and name='{2}';
                    insert siteoptions(siteid,section,name,value,type) values ({0},'{1}','{2}','{3}',{4});", siteid,section,name,val,type);
            reader.ExecuteWithinATransaction(sql);
        }

        void SetSiteOptionProcessPremod(IDnaDataReader reader, int siteid, bool on)
        {
            SetSiteOptionInt(reader,siteid,"Moderation","ProcessPreMod",on?1:0,1);
        }

        void GetRiskModTestSiteAndForum(IDnaDataReader reader, out int siteid, out int forumid)
        {
            reader.ExecuteWithinATransaction(@"  select top 1 g.forumid,g.siteid 
                                                from topics t
                                                join guideentries g on g.h2g2id=t.h2g2id
                                                order by topicid");
            reader.Read();
            forumid = reader.GetInt32("forumid");
            siteid = reader.GetInt32("siteid");
            reader.Close();
        }

        Guid testGUID = Guid.NewGuid();

        void RiskModTestPostHelper(IDnaDataReader reader, int forumid, int? threadid, int? inreplyto, int userid, string content, out int? newthreadid, out int? newthreadentryid, bool ignoremoderation, bool forcepremodposting)
        {
            string sql = string.Format(@"
                
                -- Pretend this user has never posted to this forum, to make sure the check in posttoforuminternal
                -- that stops the same user from creating a new conversation within a minute of the last one, doesn't stop the post
                update threadentries set forumid=-{0} where forumid={0} and userid={3}

                declare @hash uniqueidentifier, @returnthread int, @returnpost int, @premodpostingmodid int, @ispremoderated int
                set @hash=newid()
                exec posttoforuminternal    @userid= {3}, 
										    @forumid = {0}, 
										    @inreplyto = {2}, 
										    @threadid = {1}, 
										    @subject ='The Cabinet', 
										    @content ='{4}', 
										    @poststyle =1, 
										    @hash =@hash,
										    @keywords ='', 
										    @nickname ='the furry one', 
										    @returnthread = @returnthread OUTPUT, 
										    @returnpost = @returnpost OUTPUT, 
										    @type = NULL, 
										    @eventdate = NULL,
										    @forcemoderate = 0, 
										    @forcepremoderation = 0,
										    @ignoremoderation = {6}, 
										    @allowevententries = 1, 
										    @nodeid = 0, 
										    @ipaddress = 'testip',
										    @queueid = null, 
										    @clubid = 0, 
										    @premodpostingmodid =@premodpostingmodid OUTPUT,
										    @ispremoderated =@ispremoderated OUTPUT, 
										    @bbcuid = '{5}',
										    @isnotable = 0, 
										    @iscomment = 0,
										    @modnotes = NULL,
										    @isthreadedcomment = 0,
										    @ignoreriskmoderation = 0,
										    @forcepremodposting = {7},
										    @forcepremodpostingdate = NULL,
										    @riskmodthreadentryqueueid = NULL;

                -- put the userids back
                update threadentries set forumid={0} where forumid =-{0} and userid={3}

                select @returnthread AS returnthread, @returnpost as returnpost",
                                            forumid,
                                            threadid.HasValue ? threadid.ToString() : "NULL",
                                            inreplyto.HasValue ? inreplyto.ToString() : "NULL",
                                            userid,
                                            content,
                                            testGUID.ToString(),
                                            ignoremoderation ? 1 : 0,
                                            forcepremodposting ? 1 : 0);

            reader.ExecuteWithinATransaction(sql);
            reader.Read();
            newthreadid = reader.GetNullableInt32("returnthread");
            newthreadentryid = reader.GetNullableInt32("returnpost");
            reader.Close();
        }

        void ModeratePost(IDnaDataReader reader, int forumid, int threadid, int postid, int modid, int status, string notes, int? referto, int? referredby)
        {
            string sql = string.Format(@"
                EXEC moderatepost @forumid={0}, @threadid={1}, @postid={2}, 
	                @modid={3}, @status={4}, @notes='{5}', @referto={6}, @referredby={7}, @moderationstatus=NULL, 
	                @emailtype=''",
                    forumid,
                    threadid,
                    postid, 
                    modid, 
                    status, 
                    notes, 
                    referto.HasValue ? referto.ToString() : "NULL",
                    referredby.HasValue ? referredby.ToString() : "NULL");

            reader.ExecuteWithinATransaction(sql);
        }

        void CheckRiskModThreadEntryQueue(IDnaDataReader reader, int? ThreadEntryId, char PublishMethod, bool? IsRisky, TestDate DateAssessed, int SiteId, int ForumId, int? ThreadId, int UserId, string UserName, int? InReplyTo, string Subject, string Text, byte PostStyle, string IPAddress, string BBCUID, DateTime EventDate, byte AllowEventEntries, int NodeId, int? QueueId, int ClubId, byte IsNotable, byte IsComment, string ModNotes, byte IsThreadedComment)
        {
            reader.ExecuteWithinATransaction(@"SELECT rm.*
                                        FROM RiskModThreadEntryQueue rm
                                        WHERE RiskModThreadEntryQueueId=" + GetLatestRiskModThreadEntryQueueId(reader));
            reader.Read();

            // Nasty tweak.  The RiskModThreadEntryQueue table always stores undefined ThreadId and ThreadEntryId values
            // as NULL.  We treat zero values as NULL for comparision purposes 
            ThreadId = NullIf(ThreadId, 0);
            ThreadEntryId = NullIf(ThreadEntryId, 0);
            
            TestNullableIntField(reader, "ThreadEntryId", ThreadEntryId);

            TestPublishMethod(reader, PublishMethod);

            TestNullableBoolField(reader, "IsRisky", IsRisky);

            TestNullableDateField(reader, "DateAssessed", DateAssessed);

            Assert.AreEqual(SiteId,reader.GetInt32("SiteId"));
            Assert.AreEqual(ForumId,reader.GetInt32("ForumId"));

            TestNullableIntField(reader, "ThreadId", ThreadId);

            Assert.AreEqual(UserId,reader.GetInt32("UserId"));

            Assert.AreEqual(UserName, reader.GetString("UserName"));

            TestNullableIntField(reader, "InReplyTo", InReplyTo);

            Assert.AreEqual(Subject,reader.GetString("Subject"));
            Assert.AreEqual(Text,reader.GetString("Text"));
            Assert.AreEqual(PostStyle, reader.GetByte("PostStyle"));
            Assert.AreEqual(IPAddress,reader.GetString("IPAddress"));
            Assert.AreEqual(BBCUID,reader.GetGuidAsStringOrEmpty("BBCUID"));

            //Assert.AreEqual(EventDate,reader.GetInt32("EventDate"));
            Assert.AreEqual(AllowEventEntries,reader.GetByte("AllowEventEntries"));
            //Assert.AreEqual(NodeId,reader.GetInt32("NodeId"));
            TestNullableIntField(reader, "QueueId", QueueId);
            Assert.AreEqual(ClubId,reader.GetInt32("ClubId"));
            Assert.AreEqual(IsNotable, reader.GetByte("IsNotable"));
            Assert.AreEqual(IsComment, reader.GetByte("IsComment"));
            TestNullableStringField(reader, "ModNotes", ModNotes);
            Assert.AreEqual(IsThreadedComment, reader.GetByte("IsThreadedComment"));

            reader.Close();
        }

        void CheckLatestThread(IDnaDataReader reader, int threadid, int forumid, byte canRead, byte canWrite, int siteid)
        {
            reader.ExecuteWithinATransaction(@"SELECT top 1 * FROM Threads order by ThreadID desc");
            reader.Read();

            Assert.AreEqual(threadid, reader.GetInt32("threadid"));
            Assert.AreEqual(forumid, reader.GetInt32("forumid"));
            Assert.AreEqual(canRead, reader.GetByte("canRead"));
            Assert.AreEqual(canWrite, reader.GetByte("canWrite"));
            Assert.AreEqual(siteid, reader.GetInt32("siteid"));
        }

        void CheckLatestThreadEntry(IDnaDataReader reader, int threadid, int forumid, int userid, int? nextSibling, int? parent, int? prevSibling, int? firstChild, int entryID, int? hidden, int postIndex, byte postStyle, string text)
        {
            reader.ExecuteWithinATransaction(@"SELECT top 1 * FROM ThreadEntries order by EntryID desc");
            reader.Read();

            Assert.AreEqual(threadid, reader.GetInt32("threadid"));
            Assert.AreEqual(forumid, reader.GetInt32("forumid"));
            Assert.AreEqual(userid, reader.GetInt32("userid"));
            TestNullableIntField(reader, "nextSibling", nextSibling);
            TestNullableIntField(reader, "parent", parent);
            TestNullableIntField(reader, "prevSibling", prevSibling);
            TestNullableIntField(reader, "firstChild", firstChild);
            Assert.AreEqual(entryID, reader.GetInt32("entryID"));
            TestNullableIntField(reader, "hidden", hidden);
            Assert.AreEqual(postIndex, reader.GetInt32("postIndex"));
            Assert.AreEqual(postStyle, reader.GetByte("postStyle"));
            Assert.AreEqual(text, reader.GetString("text"));
        }

        void CheckLatestThreadMod(IDnaDataReader reader, int forumid, int? threadid, int? postid, int? lockedby, int status, string notes, int siteid, byte isPremodPosting)
        {
            reader.ExecuteWithinATransaction(@"SELECT top 1 * FROM ThreadMod order by ModId desc");
            reader.Read();

            // Nasty tweak.  With PremodPostings, when it creates a thread mod entry, it sets threadid=null and postid=0
            // posttoforuminternal returns 0 for both thread id and threadentry id, so here we're treating 0 as null
            threadid = NullIf(threadid, 0);

            Assert.AreEqual(forumid, reader.GetInt32("forumid"));
            TestNullableIntField(reader, "threadid", threadid);
            TestNullableIntField(reader, "postid", postid);
            TestNullableIntField(reader, "lockedby", lockedby);
            Assert.AreEqual(status, reader.GetInt32("status"));
            TestNullableStringField(reader, "notes", notes);
            Assert.AreEqual(siteid, reader.GetInt32("siteid"));
            Assert.AreEqual(isPremodPosting,reader.GetByte("isPremodPosting"));
        }

        void CheckLatestPremodPostings(IDnaDataReader reader, int modId, int userid, int forumid, int? threadid, int? inReplyTo, string body, int postStyle, int siteid, byte isComment, int? riskModThreadEntryQueueId)
        {
            reader.ExecuteWithinATransaction(@"SELECT * FROM PremodPostings where ModId="+modId);
            reader.Read();

            // Nasty tweak.  With PremodPostings, when it creates a thread mod entry, it sets threadid=null and postid=0
            // posttoforuminternal returns 0 for both thread id and threadentry id, so here we're treating 0 as null
            threadid = NullIf(threadid, 0);

            Assert.AreEqual(userid, reader.GetInt32("userid"));
            Assert.AreEqual(forumid, reader.GetInt32("forumid"));
            TestNullableIntField(reader, "threadid", threadid);
            TestNullableIntField(reader, "inReplyTo", inReplyTo);
            Assert.AreEqual(body, reader.GetString("body"));
            Assert.AreEqual(postStyle, reader.GetInt32("postStyle"));
            Assert.AreEqual(siteid, reader.GetInt32("siteid"));
            Assert.AreEqual(isComment, reader.GetByte("isComment"));
            TestNullableIntField(reader, "riskModThreadEntryQueueId", riskModThreadEntryQueueId);
        }

        int? NullIf(int? v, int test)
        {
            if (v.HasValue && v == test)
                return null;

            return v;
        }

        int GetLatestThreadModId(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction(@"SELECT top 1 * FROM ThreadMod order by ModId desc");
            reader.Read();

            return reader.GetInt32("ModId");
        }

        int GetLatestThreadId(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction(@"SELECT top 1 * FROM Threads order by ThreadId desc");
            reader.Read();

            return reader.GetInt32("ThreadId");
        }

        int GetLatestThreadEntryId(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction(@"SELECT top 1 * FROM ThreadEntries order by EntryId desc");
            reader.Read();

            return reader.GetInt32("EntryId");
        }

        int GetLatestRiskModThreadEntryQueueId(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction(@"SELECT top 1 * FROM RiskModThreadEntryQueue order by RiskModThreadEntryQueueId desc");
            reader.Read();

            if (reader.HasRows)
                return reader.GetInt32("RiskModThreadEntryQueueId");

            return -1;
        }

        int GetLatestPremodPostingsModId(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction(@"SELECT top 1 * FROM PremodPostings order by modid desc");
            reader.Read();

            if (reader.HasRows)
                return reader.GetInt32("ModId");

            return -1;
        }

        void TestPublishMethod(IDnaDataReader reader, char expectedPublishMethod)
        {
            string pm = reader.GetString("PublishMethod");
            Assert.AreEqual(expectedPublishMethod, pm[0]);
            Assert.IsTrue(pm.Length == 1);
            Assert.IsTrue(pm[0] == 'A' || pm[0] == 'B');
        }

        void TestNullableDateField(IDnaDataReader reader, string fieldName, TestDate expected)
        {
            if (reader.IsDBNull(fieldName))
                Assert.IsNull(expected);
            else
                Assert.IsTrue(expected.CheckDate(reader.GetDateTime(fieldName)));
        }


        void TestNullableIntField(IDnaDataReader reader, string fieldName, int? expected)
        {
            int? v = reader.GetNullableInt32(fieldName);
            if (expected.HasValue)
                Assert.AreEqual(expected, v);
            else
                Assert.IsFalse(v.HasValue);
        }

        void TestNullableStringField(IDnaDataReader reader, string fieldName, string expected)
        {
            if (reader.IsDBNull(fieldName))
                Assert.IsNull(expected);
            else
                Assert.AreEqual(expected, reader.GetString(fieldName));
        }

        void TestNullableBoolField(IDnaDataReader reader, string fieldName, bool? expected)
        {
            bool? v = reader.GetNullableBoolean(fieldName);
            if (expected.HasValue)
                Assert.AreEqual(expected, v);
            else
                Assert.IsFalse(v.HasValue);
        }
    }
}
