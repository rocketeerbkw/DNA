using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Transactions;
using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using DnaEventService.Common;
using Microsoft.Http;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using BBC.Dna.Utils;
using Dna.SnesIntegration.ActivityProcessor.Activities;

namespace DnaEventProcessorService.IntegrationTests
{
    /// <summary>
    /// Summary description for LogFileSeperationTests
    /// </summary>
    [TestClass]
    public class LogFileSeperationTests
    {
        [TestMethod]
        public void ProcessEvents_SingleLogFileGenerated()
        {
            string logFile = @"Logs\SnesActivityProcessor\snesactivityprocessor.log";

            Assert.IsFalse(File.Exists(logFile));

            var mocks = new MockRepository();

            var getSnesEvents = mocks.DynamicMock<IDnaDataReader>();
            getSnesEvents.Stub(x => x.GetInt32("ActivityType")).Return(19);
            var removeHandledSnesEvents = mocks.DynamicMock<IDnaDataReader>();
            removeHandledSnesEvents
                .Stub(x => x.AddParameter("eventids", ""))
                .Constraints(Is.Equal("eventids"), Is.Anything())
                .Return(removeHandledSnesEvents);

            Expect.Call(removeHandledSnesEvents.Execute()).Return(removeHandledSnesEvents);
            Expect.Call(removeHandledSnesEvents.Dispose);
            
            var dataReaderCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            IDnaLogger logger = new DnaLogger();

            var httpClientCreator = MockRepository.GenerateStub<IDnaHttpClientCreator>();
            
            var httpClient = MockRepository.GenerateStub<IDnaHttpClient>();
            httpClientCreator.Stub(x => x.CreateHttpClient()).Return(httpClient);

            StubHttpClientPostMethod(httpClient);

            using (mocks.Record())
            {
                MockCurrentRowDataReader(getSnesEvents);
                Expect.Call(dataReaderCreator.CreateDnaDataReader("removehandledsnesevents"))
                    .Return(removeHandledSnesEvents);
                Expect.Call(dataReaderCreator.CreateDnaDataReader("getsnesevents")).Return(getSnesEvents);
            }

            using (mocks.Playback())
            {
                var processor = CreateSnesActivityProcessor(dataReaderCreator, logger, httpClientCreator);
                processor.ProcessEvents(null);
            }

            Assert.IsTrue(File.Exists(logFile));

            File.Copy(logFile, logFile + ".copy");  // We have to copy it in order to read it, otherwise we get a share violation
            var lines = File.ReadAllLines(logFile + ".copy");

            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines,"Category: SnesActivityProcessor.Requests"));
            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines, "Category: SnesActivityProcessor.Responses"));
            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines, "POST Data"));
            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines, "Activity Uri"));
            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines, "Uri"));
            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines, "Content"));
        }

        private bool ArrayContainsLineThatStartsWith(string[] lines, string startsWith)
        {
            foreach (string s in lines)
            {
                if (s.StartsWith(startsWith))
                    return true;
            }
            return false;
        }

        [TestMethod]
        public void Integration_CommentActivityEndToEnd_HttpStatusOK()
        {
            using (new TransactionScope())
            {
                //Setup up a comment forum for test using createcommentforum sp
                string connectionString = Properties.Settings.Default.guideConnectionString;
                IDnaDataReaderCreator creator = new DnaDataReaderCreator(connectionString);

                var uid = Guid.NewGuid().ToString();
                var url = "http://www.bbc.co.uk/";
                var title = "Test comment forum title";
                var siteId = "h2g2";

                SetupSiteOptions(creator, 1, true, "", "", "", false);
                CreateCommentForum(creator, uid, url, title, siteId);

                //Add comment to comment forum
                var hash = Guid.NewGuid().ToString();
                var content = "content";
                var userId = 6;

                CreateComment(creator, uid, userId, content, hash);

                SetupTestData(creator, siteId);
                
                ProcessEvents(creator);

                var mocks = new MockRepository();
                var httpClientCreator = mocks.Stub<IDnaHttpClientCreator>();
                var httpClient = mocks.Stub<IDnaHttpClient>();

                SetupResult.For(httpClientCreator.CreateHttpClient()).Return(httpClient);
                
                StubHttpClientPostMethod(httpClient);

                var logger = MockRepository.GenerateStub<IDnaLogger>();
                mocks.ReplayAll();

                var processor = CreateSnesActivityProcessor(creator, logger, httpClientCreator);
                processor.ProcessEvents(null);

                httpClient.AssertWasCalled(client => client.Post(new Uri("", UriKind.Relative), 
                    HttpContent.Create("")), op => op.Constraints(Is.Anything(),Is.Anything()));
            }
        }

        [TestMethod]
        public void Integration_CommentActivityEndToEndWithoutSiteOption_NoEventsSent()
        {
            using (new TransactionScope())
            {
                //Setup up a comment forum for test using createcommentforum sp
                string connectionString = Properties.Settings.Default.guideConnectionString;
                IDnaDataReaderCreator creator = new DnaDataReaderCreator(connectionString);

                var uid = Guid.NewGuid().ToString();
                var url = "http://www.bbc.co.uk/";
                var title = "Test comment forum title";
                var siteId = "h2g2";

                SetupSiteOptions(creator, 1, false, "", "", "", false);
                CreateCommentForum(creator, uid, url, title, siteId);

                //Add comment to comment forum
                var hash = Guid.NewGuid().ToString();
                var content = "content";
                var userId = 6;

                CreateComment(creator, uid, userId, content, hash);

                SetupTestData(creator,siteId);

                ProcessEvents(creator);

                var mocks = new MockRepository();
                var httpClientCreator = mocks.Stub<IDnaHttpClientCreator>();
                var httpClient = MockRepository.GenerateStub<IDnaHttpClient>();

                SetupResult.For(httpClientCreator.CreateHttpClient()).Return(httpClient);

                StubHttpClientPostMethod(httpClient);

                var logger = MockRepository.GenerateStub<IDnaLogger>();
                //logger.Stub(x => x.LogRequest("", "")).WhenCalled(x => ValidateActivityJson(x.Arguments[0], 1)).Constraints(Is.Anything(),Is.Anything());
                //LogUtility.LogRequest(GetActivityJson(), GetUri().ToString());
                mocks.ReplayAll();

                var processor = CreateSnesActivityProcessor(creator, logger, httpClientCreator);
                processor.ProcessEvents(null);

                httpClient.AssertWasNotCalled(client => client.Post(new Uri("", UriKind.Relative),
                    HttpContent.Create("")), op => op.Constraints(Is.Anything(), Is.Anything()));
            }
        }

        [TestMethod]
        public void Integration_CommentActivityEndToEndWithIsPrivate_NoEventsSent()
        {
            using (new TransactionScope())
            {
                //Setup up a comment forum for test using createcommentforum sp
                string connectionString = Properties.Settings.Default.guideConnectionString;
                IDnaDataReaderCreator creator = new DnaDataReaderCreator(connectionString);

                var uid    = Guid.NewGuid().ToString();
                var url    = "http://www.bbc.co.uk/";
                var title  = "Test comment forum title";
                var siteId = "h2g2";

                SetupSiteOptions(creator, 1, true, "", "", "", true);
                CreateCommentForum(creator, uid, url, title, siteId);

                //Add comment to comment forum
                var hash    = Guid.NewGuid().ToString();
                var content = "content";
                var userId  = 6;

                CreateComment(creator, uid, userId, content, hash);

                SetupTestData(creator,siteId);

                ProcessEvents(creator);

                var mocks = new MockRepository();
                var httpClientCreator = mocks.Stub<IDnaHttpClientCreator>();
                var httpClient = MockRepository.GenerateStub<IDnaHttpClient>();

                SetupResult.For(httpClientCreator.CreateHttpClient()).Return(httpClient);

                StubHttpClientPostMethod(httpClient);

                var logger = MockRepository.GenerateStub<IDnaLogger>();
                //logger.Stub(x => x.LogRequest("", "")).WhenCalled(x => ValidateActivityJson(x.Arguments[0], 1)).Constraints(Is.Anything(),Is.Anything());
                //LogUtility.LogRequest(GetActivityJson(), GetUri().ToString());
                mocks.ReplayAll();

                var processor = CreateSnesActivityProcessor(creator, logger, httpClientCreator);
                processor.ProcessEvents(null);

                httpClient.AssertWasNotCalled(client => client.Post(new Uri("", UriKind.Relative),
                    HttpContent.Create("")), op      => op.Constraints(Is.Anything(), Is.Anything()));
            }
        }

        [TestMethod]
        public void ProcessEvents_HttpClientNotReturning200Ok_RemoveHandledEventsNotCalled()
        {
            var mocks = new MockRepository();
            var dataReader = mocks.Stub<IDnaDataReader>();
            var dataCreator = mocks.Stub<IDnaDataReaderCreator>();
            dataCreator.Stub(x => x.CreateDnaDataReader("")).Constraints(Is.Anything()).Return(dataReader);
            var logger = mocks.Stub<IDnaLogger>();

            var httpCreator = mocks.Stub<IDnaHttpClientCreator>();
            var httpClient = mocks.Stub<IDnaHttpClient>();
            httpCreator.Stub(x => x.CreateHttpClient()).Return(httpClient);

            StubHttpClientPostMethod(httpClient, HttpStatusCode.NotFound);

            mocks.ReplayAll();

            var processor = CreateSnesActivityProcessor(dataCreator, logger, httpCreator);
            processor.ProcessEvents(null);

            dataCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("removehandledsnesevents"));
        }

        [TestMethod]
        [DeploymentItem("activities.js")]
        public void OpenSocialActivities_Deserialize()
        {
            var sr = new StreamReader(File.Open(@"activities.js", FileMode.Open));
            var json = sr.ReadToEnd();
            var obj = json.ObjectFromJson<OpenSocialActivities>();

            Assert.IsNotNull(obj);
        }


        private static void ProcessEvents(IDnaDataReaderCreator creator)
        {
            using (var reader = creator.CreateDnaDataReader("processeventqueue"))
            {
                reader.Execute();
            }
        }

        private static void SetupTestData(IDnaDataReaderCreator creator, string urlname)
        {
            using (var adhoc = creator.CreateDnaDataReader(""))
            {/*
                adhoc.ExecuteDEBUGONLY(
                    "update signinuseridmapping set identityuserid = 6 where dnauserid = 6");
                adhoc.ExecuteDEBUGONLY("delete from snesapplicationmetadata where urlname = '"+urlname+"'");
                adhoc.ExecuteDEBUGONLY(
                    "declare @siteid int; select @siteid=siteid from sites where urlname = '"+urlname+"';"+
                    "insert into snesapplicationmetadata(siteid, applicationid, applicationname) values " +
                    "(@siteid, 'iplayertv', 'Hitchhiker''s guide to the Galaxy')");
                adhoc.ExecuteDEBUGONLY("update users set loginname = 'Test' where userid = 6");
                */
                string sql = string.Format(@"
                            declare @siteid int; 
                            select @siteid=siteid from sites where urlname = '{0}';
                            update signinuseridmapping set identityuserid = 6 where dnauserid = 6
                            delete from snesapplicationmetadata where siteid = @siteid
                            insert into snesapplicationmetadata(siteid, applicationid, applicationname) 
                                values (@siteid, '{0}', 'Hitchhiker''s guide to the Galaxy')", urlname);

                adhoc.ExecuteDEBUGONLY(sql);

            }
        }

        private static int SetupSite(IDnaDataReaderCreator creator, string urlname)
        {
            using (var adhoc = creator.CreateDnaDataReader(""))
            {
                if (!SiteExists(adhoc, urlname))
                {
                    return CreateNewSite(adhoc, urlname);
                }
            }

            throw new Exception("Unable to set up site");
        }

        private static bool SiteExists(IDnaDataReader reader,string urlname)
        {
            using (IDnaDataReader r = reader.ExecuteDEBUGONLY("select * from sites where urlname='"+urlname+"'"))
            {
                while (r.Read())
                {
                    if (r.GetString("urlname") == urlname)
                        return true;
                }
            }

            return false;
        }

        private static int CreateNewSite(IDnaDataReader reader, string urlname)
        {
            string sql = @"exec createnewsite	 @urlname = '"+urlname+"',"+
									            "@shortname = '"+urlname+"',"+
									            "@description = '"+urlname+"',"+
									            "@defaultskin = 'default',"+
									            "@skindescription = '',"+
									            "@skinset ='boards',"+
									            "@useframes =0,"+
									            "@premoderation = 0,"+
									            "@noautoswitch =0,"+
									            "@customterms = 0,"+
									            "@moderatorsemail = 'a@b.c',"+
									            "@editorsemail = 'a@b.c',"+
									            "@feedbackemail = 'a@b.c',"+
									            "@automessageuserid = 245,"+
									            "@passworded = 0,"+
									            "@unmoderated = 0,"+
									            "@articleforumstyle =0,"+
									            "@threadorder =1,"+
									            "@threadedittimelimit = 0,"+
									            "@eventemailsubject = '',"+
									            "@eventalertmessageuserid = 254,"+ 
									            "@includecrumbtrail  = 0,"+
									            "@allowpostcodesinsearch = 0,"+ 
									            "@ssoservice = null,"+
									            "@siteemergencyclosed = 0,"+
									            "@allowremovevote = 0,"+
									            "@queuepostings = 0,"+
									            "@modclassid = 1,"+
									            "@identitypolicy = 'http://identity/policies/dna/adult'";

            reader.ExecuteDEBUGONLY(sql);
            reader.Read();
            int siteid = reader.GetInt32("siteid");
            return siteid;
        }

        private static void StubHttpClientPostMethod(IDnaHttpClient httpClient)
        {
            StubHttpClientPostMethod(httpClient, HttpStatusCode.OK);
        }

        private static void StubHttpClientPostMethod(IDnaHttpClient httpClient, HttpStatusCode returnCode)
        {
            var settings = new HttpWebRequestTransportSettings();
            httpClient.Stub(x => x.TransportSettings).Return(settings);
            var content = HttpContent.Create("");
            var newHttpResponseMessage = new HttpResponseMessage();
            httpClient.Stub(x => x.Post(new Uri("", UriKind.Relative), content))
                .Constraints(Is.Anything(), Is.Anything())
                .Return(newHttpResponseMessage)
                .WhenCalled(x => x.ReturnValue = GetNewHttpResponseMessage(returnCode));
        }

        private static HttpResponseMessage GetNewHttpResponseMessage(HttpStatusCode returnCode)
        {
            var content = HttpContent.Create("");
            var newHttpResponseMessage = new HttpResponseMessage
                                             {
                                                 StatusCode = returnCode,
                                                 Uri = new Uri("http://www.bbc.co.uk/"),
                                                 Content = content
                                             };
            return newHttpResponseMessage;
        }

        private static void CreateComment(IDnaDataReaderCreator creator, 
            string uid, int userId, string content, string hash)
        {
            using (var dataReader = creator.CreateDnaDataReader("commentcreate"))
            {
                dataReader.AddParameter("commentforumid", uid);
                dataReader.AddParameter("userid", userId);
                dataReader.AddParameter("content", content);
                dataReader.AddParameter("hash", hash);
                dataReader.AddIntReturnValue();

                dataReader.Execute();
            }
        }

        private static void CreateCommentForum(IDnaDataReaderCreator creator, 
            string uid, string url, string title, string siteId)
        {
            using (var reader = creator.CreateDnaDataReader("commentforumcreate"))
            {
                reader.AddParameter("uid", uid);
                reader.AddParameter("url", url);
                reader.AddParameter("title", title);
                reader.AddParameter("sitename", siteId);

                reader.Execute();
            }
        }

        private static SnesActivityProcessor CreateSnesActivityProcessor(IDnaDataReaderCreator dataReaderCreator, 
            IDnaLogger logger,
            IDnaHttpClientCreator httpClientCreator)
        {
            return new SnesActivityProcessor(
                dataReaderCreator, 
                logger,
                httpClientCreator);
        }

        private static void MockCurrentRowDataReader(IDnaDataReader reader)
        {
            Expect.Call(reader.Execute()).Return(reader);
            Expect.Call(reader.HasRows).Return(true);
            var readReturn = new Queue<bool>();
            readReturn.Enqueue(true);
            readReturn.Enqueue(false);
            Expect.Call(reader.Read()).Return(true).WhenCalled( x => x.ReturnValue = readReturn.Dequeue());
            Expect.Call(reader.Dispose);
            Expect.Call(reader.GetString("AppId")).Return("iPlayer");
            Expect.Call(reader.GetString("IdentityUserId")).Return("0");

            //Expect.Call(reader.GetInt32NullAsZero("PostId")).Repeat.Times(2).Return(1);

            //Expect.Call(reader.GetStringNullAsEmpty("DnaUrl")).Return("http://www.bbc.co.uk/dna/");
            //Expect.Call(reader.GetInt32NullAsZero("ForumID")).Repeat.Any().Return(1234);
            //Expect.Call(reader.GetInt32NullAsZero("ThreadId")).Repeat.Any().Return(54321);
            //Expect.Call(reader.GetInt32("ActivityType")).Repeat.Times(2).Return(5);
            //Expect.Call(reader.GetInt32("EventID")).Return(1234);
            //string appId = Guid.NewGuid().ToString();
            //Expect.Call(reader.GetStringNullAsEmpty("AppId")).Return(appId);
            //Expect.Call(reader.GetStringNullAsEmpty("Body")).Return("here is some text");
            //DateTime now = new DateTime(1970, 1, 1, 0, 0, 0);
            //Expect.Call(reader.GetDateTime("ActivityTime")).Return(now);
            //Expect.Call(reader.GetInt32("IdentityUserId")).Return(12345456);
            //Expect.Call(reader.GetStringNullAsEmpty("AppName")).Return("iPlayer");

            //Expect.Call(reader.GetStringNullAsEmpty("BlogUrl")).Repeat.Times(2).Return("http://www.bbc.co.uk/blogs/test");

            return;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="siteId"></param>
        /// <param name="enabled"></param>
        /// <param name="objectUriFormat"></param>
        /// <param name="contentPermaUrl"></param>
        /// <param name="customActivityType"></param>
        private void SetupSiteOptions(IDnaDataReaderCreator creator, int siteId, bool enabled, string objectUriFormat,
            string contentPermaUrl, string customActivityType, bool isPrivate)
        {
            using (var dataReader = creator.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='SiteIsPrivate'", siteId));
            }


            using (var dataReader = creator.CreateDnaDataReader("dbu_createsiteoption"))
            {
                dataReader.AddParameter("siteid", siteId);
                dataReader.AddParameter("section", "General");
                dataReader.AddParameter("name", "SiteIsPrivate");
                dataReader.AddParameter("value", isPrivate ? "1" : "0");
                dataReader.AddParameter("type", "1");
                dataReader.AddParameter("description", "Whether to propogate content to SNeS - note SiteIsPrivate is also honoured");
                dataReader.Execute();
            }

            using (var dataReader = creator.CreateDnaDataReader("dbu_createsiteoption"))
            {
                dataReader.AddParameter("siteid", siteId);
                dataReader.AddParameter("section", "SNeS Integration");
                dataReader.AddParameter("name", "Enabled");
                dataReader.AddParameter("value", enabled ? "1" : "0");
                dataReader.AddParameter("type", "1");
                dataReader.AddParameter("description", "Whether to propogate content to SNeS - note SiteIsPrivate is also honoured");
                dataReader.Execute();
            }

            if (!string.IsNullOrEmpty(objectUriFormat))
            {
                using (var dataReader = creator.CreateDnaDataReader("dbu_createsiteoption"))
                {
                    dataReader.AddParameter("siteid", siteId);
                    dataReader.AddParameter("section", "SNeS Integration");
                    dataReader.AddParameter("name", "ObjectUriFormat");
                    dataReader.AddParameter("value", objectUriFormat);
                    dataReader.AddParameter("type", "2");
                    dataReader.AddParameter("description", "Format of the object URI sent to SNeS - supports {forumid}, {threadid}, {postid}, {sitename}, {parenturl} and {commentforumuid}");
                    dataReader.Execute();
                }

            }

            if (!string.IsNullOrEmpty(contentPermaUrl))
            {
                using (var dataReader = creator.CreateDnaDataReader("dbu_createsiteoption"))
                {
                    dataReader.AddParameter("siteid", siteId);
                    dataReader.AddParameter("section", "SNeS Integration");
                    dataReader.AddParameter("name", "ContentPermaUrl");
                    dataReader.AddParameter("value", contentPermaUrl);
                    dataReader.AddParameter("type", "2");
                    dataReader.AddParameter("description", "Format of the permalink - supports {forumid}, {threadid}, {postid}, {sitename}, {parenturl} and {commentforumuid} - empty means standard dna url");
                    dataReader.Execute();
                }

            }

            if (!string.IsNullOrEmpty(customActivityType))
            {
                using (var dataReader = creator.CreateDnaDataReader("dbu_createsiteoption"))
                {
                    dataReader.AddParameter("siteid", siteId);
                    dataReader.AddParameter("section", "SNeS Integration");
                    dataReader.AddParameter("name", "CustomActivityType");
                    dataReader.AddParameter("value", customActivityType);
                    dataReader.AddParameter("type", "2");
                    dataReader.AddParameter("description", "ActivityType sent through to SNeS - empty uses default value for type of content");
                    dataReader.Execute();
                }

            }
        }
    }
}
