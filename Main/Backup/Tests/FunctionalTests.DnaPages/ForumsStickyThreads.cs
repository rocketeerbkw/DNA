using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Transactions;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace FunctionalTests
{
    /// <summary>
    /// Summary description for ForumsStickyThreads
    /// </summary>
    [TestClass]
    public class ForumsStickyThreads
    {
        private readonly ForumPageTests _forumPageTests = new ForumPageTests();
        //private TransactionScope _ts;

        public ForumsStickyThreads()
        {
            
        }

        [TestInitialize]
        public void Initialise()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            //_ts = new TransactionScope();
        }

        [TestCleanup]
        public void CleanUp()
        {
           //_ts.Dispose();
        }


        [TestMethod]
        public void AddStickyThread_WithoutSiteOption_ReturnsError()
        {
            var siteName = "mbiplayer";
            var request = new DnaTestURLRequest(siteName);

            request.SetCurrentUserEditor();
            request.RequestPage("NF7325075?cmd=MAKETHREADSTICKY&stickythreadid=34&skin=purexml");
            _forumPageTests.ValidateForumSchema(siteName, request);

            var doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR"));
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE"));
            Assert.AreEqual("'EnableStickyThreads' site option is false.", doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE").InnerText);

            
        }

        [TestMethod]
        public void AddStickyThread_AsNormalUser_ReturnsError()
        {
            var siteName = "h2g2";
            CheckEnableStickyThreadSiteOptionIsSet(1);

            var request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF150?cmd=MAKETHREADSTICKY&stickythreadid=32&skin=purexml");
            _forumPageTests.ValidateForumSchema(siteName, request);

            var doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR"));
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE"));
            Assert.AreEqual("Viewing user unauthorised.", doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE").InnerText);


        }

        [TestMethod]
        public void RemoveStickyThread_AsNormalUser_ReturnsError()
        {
            var siteName = "h2g2";
            var request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF150?cmd=REMOVESTICKYTHREAD&stickythreadid=32&skin=purexml");
            _forumPageTests.ValidateForumSchema(siteName, request);

            var doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR"));
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE"));
            Assert.AreEqual("Viewing user unauthorised.", doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE").InnerText);


        }

        [TestMethod]
        public void AddStickyThread_AsEditor_ReturnsStickyThread()
        {
                var siteName = "h2g2";
                var request = new DnaTestURLRequest(siteName);
                request.SetCurrentUserEditor();
                request.RequestPage("NF150?skin=purexml&ignorecache=1");
                _forumPageTests.ValidateForumSchema(siteName, request);

                var doc = request.GetLastResponseAsXML();
                Assert.IsNotNull(doc.SelectSingleNode("//H2G2/FORUMTHREADS"));
                var threads = doc.SelectNodes("//H2G2/FORUMTHREADS/THREAD");
                Assert.IsNotNull(threads);
                var threadId = Int32.Parse(threads[1].Attributes["THREADID"].Value);

                //make the second thread sticky
                request.RequestPage("NF150?skin=purexml&cmd=MAKETHREADSTICKY&stickythreadid=" + threadId);
                _forumPageTests.ValidateForumSchema(siteName, request);
                //check that the second thread has moved to the top - is marked sticky
                doc = request.GetLastResponseAsXML();
                Assert.IsNull(doc.SelectSingleNode("//H2G2/ERROR"));
                Assert.IsNotNull(doc.SelectSingleNode("//H2G2/FORUMTHREADS"));
                threads = doc.SelectNodes("//H2G2/FORUMTHREADS/THREAD");
                Assert.IsNotNull(threads);
                Assert.AreEqual(threadId, Int32.Parse(threads[0].Attributes["THREADID"].Value));//should be the first in the list now
                Assert.IsTrue(bool.Parse(threads[0].Attributes["ISSTICKY"].Value));

                //Check audit table...
                CheckAuditTable(150, threadId, request.CurrentUserID, 2); //check for an insert

        }

        [TestMethod]
        public void RemoveStickyThread_AsEditor_ReturnsCorrectResults()
        {
            //set up a sticky thread 
            AddStickyThread_AsEditor_ReturnsStickyThread();

            var siteName = "h2g2";
            var request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("NF150?skin=purexml");
            _forumPageTests.ValidateForumSchema(siteName, request);

            var doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/FORUMTHREADS"));
            var thread = doc.SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@ISSTICKY='true']");
            Assert.IsNotNull(thread);
            var threadId = Int32.Parse(thread.Attributes["THREADID"].Value);

            //make the second thread sticky
            request.RequestPage("NF150?skin=purexml&cmd=REMOVESTICKYTHREAD&stickythreadid=" + threadId);
            _forumPageTests.ValidateForumSchema(siteName, request);
            //check that the second thread has moved to the top - is marked sticky
            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/FORUMTHREADS"));
            var threads = doc.SelectNodes("//H2G2/FORUMTHREADS/THREAD");
            Assert.IsNotNull(threads);
            Assert.AreEqual(threadId, Int32.Parse(threads[1].Attributes["THREADID"].Value));
            Assert.IsFalse(bool.Parse(threads[1].Attributes["ISSTICKY"].Value));//should be the first in the list now

            //Check audit table...
            CheckAuditTable(150, threadId, request.CurrentUserID, 1); //check for an delete

        }
        private static void CheckEnableStickyThreadSiteOptionIsSet(int siteID)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                var sql = String.Format("select * from siteoptions where siteid={0} and name='EnableStickyThreads' and Value=1", siteID);
                dataReader.ExecuteDEBUGONLY(sql);
                if (dataReader.HasRows)
                {
                    return;
                }
                else
                {
                    sql = String.Format("select * from siteoptions where siteid={0} and name='EnableStickyThreads' and Value=0", siteID);
                    dataReader.ExecuteDEBUGONLY(sql);
                    if (dataReader.HasRows)
                    {
                        sql = String.Format("update siteoptions set Value=1 where siteid={0} and name='EnableStickyThreads'", siteID);
                        dataReader.ExecuteDEBUGONLY(sql);
                    }
                    else
                    {
                        sql = String.Format("insert into siteoptions values ('Forum', {0},  'EnableStickyThreads', 1, 1, 'Turns on and off sticky thread functionality'", siteID);
                        dataReader.ExecuteDEBUGONLY(sql);
                    }
                }
            }
        }

        private static void CheckAuditTable(int forumId, int threadId, int userId, int type)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                var sql = String.Format("select * from auditstickythreads where forumid={0} and threadid={1} and userid={2} and type={3}", forumId, threadId, userId, type);
                dataReader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(dataReader.HasRows);
            }

        }
    }
}
