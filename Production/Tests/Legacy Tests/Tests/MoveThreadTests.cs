using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Tests for the move thread functionality
    /// </summary>
    [TestClass]
    public class MoveThreadTests
    {
        /// <summary>
        /// Setup method
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// teardown method
        /// </summary>
        [TestCleanup]
        public void TearDown()
        {
            SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Test to make sure that the correct details are retrieved for a threadmod id
        /// </summary>
        [TestMethod]
        public void TestShowDetailsForThreadModID()
        {
            // Create a database context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            int forumid;
            string subject;
            int modID;
            SetupPreModPost(context, out forumid, out subject, out modID);

            // Mock the current site
            ISite mockedSite = DnaMockery.CurrentMockery.NewMock<ISite>();
            Stub.On(mockedSite).GetProperty("AutoMessageUserID").Will(Return.Value(194));

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml("<TOPIC-LIST />");
            Stub.On(mockedSite).Method("GetTopicListXml").Will(Return.Value(xmlDoc.FirstChild));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsEditor").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("IsModerator").Will(Return.Value(false));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Use the move thread builder to get the details for the thread
            Stub.On(context).Method("GetParamIntOrZero").With("ThreadModID", "Get the ThreadModID").Will(Return.Value(modID));
            Stub.On(context).Method("GetParamCountOrZero").With("Move", "Do we have a move param").Will(Return.Value(0));
            Stub.On(context).Method("GetParamStringOrEmpty").With("cmd", "Have we been given a command?").Will(Return.Value(""));
            Stub.On(context).Method("GetParamCountOrZero").With("Undo", "Do we have a undo move param").Will(Return.Value(0));
            Stub.On(context).Method("GetParamIntOrZero").With("MoveToForumID", "Get the move to forum id").Will(Return.Value(0));
            MoveThread testMoveThread = new MoveThread(context);
            testMoveThread.ProcessRequest();

            // Check to make sure the details come abck correctly
            XmlNode moveThreadNode = testMoveThread.RootElement.SelectSingleNode("//MOVE-THREAD-FORM");
            Assert.IsNotNull(moveThreadNode, "Failed to find the base node for the move thread.");
            Assert.AreEqual(subject, moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/THREAD-SUBJECT").InnerText, "The thread subject is defferent to the one submitted");
            Assert.AreEqual(forumid.ToString(), moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/OLD-FORUM-ID").InnerText, "The forumid is incorrect and should be " + forumid.ToString());
            Assert.AreEqual("1", moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/ISPREMODPOSTING").InnerText, "The post is not a premod posting!!!");
        }

        /// <summary>
        /// Test to make sure the move thread via modid works correctly
        /// </summary>
        [TestMethod]
        public void TestMoveThreadViaModID()
        {
            // Create a database context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            int forumid;
            string subject;
            int modID;
            SetupPreModPost(context, out forumid, out subject, out modID);

            // Find another suitable forum to move the thread to
            int moveToForumID = 0;
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select top 1 * from forums where siteid = 1 and title not in ('','User-journal','frontpage') and canread=1 and forumid != " + forumid.ToString() + " order by forumid desc");
                if (!reader.Read() || !reader.HasRows)
                {
                    Assert.Fail("Failed to find another suitable forum to move the thread to");
                }

                moveToForumID = reader.GetInt32("ForumID");
            }

            // Mock the current site
            ISite mockedSite = DnaMockery.CurrentMockery.NewMock<ISite>();
            Stub.On(mockedSite).GetProperty("AutoMessageUserID").Will(Return.Value(194));

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml("<TOPIC-LIST />");
            Stub.On(mockedSite).Method("GetTopicListXml").Will(Return.Value(xmlDoc.FirstChild));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            // Mock the post to thread stored procedure call
            IDnaDataReader mockedReader = DnaMockery.CurrentMockery.NewMock<IDnaDataReader>();
            Stub.On(mockedReader).Method("AddParameter").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Execute").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Dispose").Will(Return.Value(null));
            Stub.On(context).Method("CreateDnaDataReader").With("PostToEndOfThread").Will(Return.Value(mockedReader));

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsEditor").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("IsModerator").Will(Return.Value(false));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Use the move thread builder to get the details for the thread
            Stub.On(context).Method("GetParamIntOrZero").With("MoveToForumID", "Get the move to forum id").Will(Return.Value(moveToForumID));
            Stub.On(context).Method("GetParamIntOrZero").With("ThreadModID", "Get the ThreadModID").Will(Return.Value(modID));
            Stub.On(context).Method("GetParamCountOrZero").With("Move", "Do we have a move param").Will(Return.Value(1));
            Stub.On(context).Method("DoesParamExist").With("PostContent", "Do we have post content").Will(Return.Value(false));
            MoveThread testMoveThread = new MoveThread(context);
            testMoveThread.ProcessRequest();

            // Check to make sure the move worked correclty
            XmlNode moveThreadNode = testMoveThread.RootElement.SelectSingleNode("//MOVE-THREAD-FORM");
            Assert.IsNotNull(moveThreadNode, "Failed to find the base node for the move thread.");
            Assert.IsNull(moveThreadNode.SelectSingleNode("//ERROR"), "We had an Error!");
            Assert.AreEqual(subject, moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/THREAD-SUBJECT").InnerText, "The thread subject is defferent to the one submitted");
            Assert.AreEqual(forumid.ToString(), moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/OLD-FORUM-ID").InnerText, "The old forumid is incorrect and should be " + forumid.ToString());
            Assert.AreEqual(moveToForumID.ToString(), moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/NEW-FORUM-ID").InnerText, "The new forumid is incorrect and should be " + moveToForumID.ToString());
            Assert.AreEqual("1", moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/ISPREMODPOSTING").InnerText, "The post is not a premod posting!!!");
        }

        /// <summary>
        /// Test to make sure the move thread via modid returns correct error for moving to same forum
        /// </summary>
        [TestMethod]
        public void TestMoveThreadViaModIDToSameForumID()
        {
            // Create a database context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            int forumid;
            string subject;
            int modID;
            SetupPreModPost(context, out forumid, out subject, out modID);

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsEditor").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("IsModerator").Will(Return.Value(false));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Mock the current site
            ISite mockedSite = DnaMockery.CurrentMockery.NewMock<ISite>();
            Stub.On(mockedSite).GetProperty("AutoMessageUserID").Will(Return.Value(194));

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml("<TOPIC-LIST />");
            Stub.On(mockedSite).Method("GetTopicListXml").Will(Return.Value(xmlDoc.FirstChild));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            // Use the move thread builder to get the details for the thread
            Stub.On(context).Method("GetParamIntOrZero").With("ThreadModID", "Get the ThreadModID").Will(Return.Value(modID));
            Stub.On(context).Method("GetParamCountOrZero").With("Move", "Do we have a move param").Will(Return.Value(1));
            Stub.On(context).Method("GetParamIntOrZero").With("MoveToForumID", "Get the move to forum id").Will(Return.Value(forumid));
            MoveThread testMoveThread = new MoveThread(context);
            testMoveThread.ProcessRequest();

            // Check to make sure the move worked correclty
            XmlNode moveThreadNode = testMoveThread.RootElement.SelectSingleNode("//MOVE-THREAD-FORM");
            Assert.IsNotNull(moveThreadNode, "Failed to find the base node for the move thread.");
            Assert.IsNotNull(moveThreadNode.SelectSingleNode("//ERROR"), "We should have returned an error");
            Assert.AreEqual("Move to forum is same as current forum", moveThreadNode.SelectSingleNode("//ERROR").InnerText, "Incorrect error returned");
            Assert.AreEqual(subject, moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/THREAD-SUBJECT").InnerText, "The thread subject is defferent to the one submitted");
            Assert.AreEqual(forumid.ToString(), moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/OLD-FORUM-ID").InnerText, "The forumid is incorrect and should be " + forumid.ToString());
            Assert.AreEqual("1", moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/ISPREMODPOSTING").InnerText, "The post is not a premod posting!!!");
        }

        /// <summary>
        /// Test to make sure the move thread via modid returns correct error for moving to an invalid forum
        /// </summary>
        [TestMethod]
        public void TestMoveThreadViaModIDToInvalidForum()
        {
            // Create a database context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            int forumid;
            string subject;
            int modID;
            SetupPreModPost(context, out forumid, out subject, out modID);

            // Get the highest forumid in the database and add 1 to it. This will be the invalid forumid
            int moveToForumID = 0;
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select ForumID = MAX(forumID) + 1 From Forums");
                if (!reader.Read() || !reader.HasRows)
                {
                    Assert.Fail("Failed to find another suitable forum to move the thread to");
                }

                moveToForumID = reader.GetInt32("ForumID");
            }

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsEditor").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("IsModerator").Will(Return.Value(false));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Mock the current site
            ISite mockedSite = DnaMockery.CurrentMockery.NewMock<ISite>();
            Stub.On(mockedSite).GetProperty("AutoMessageUserID").Will(Return.Value(194));

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml("<TOPIC-LIST />");
            Stub.On(mockedSite).Method("GetTopicListXml").Will(Return.Value(xmlDoc.FirstChild));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            // Use the move thread builder to get the details for the thread
            Stub.On(context).Method("GetParamIntOrZero").With("ThreadModID", "Get the ThreadModID").Will(Return.Value(modID));
            Stub.On(context).Method("GetParamCountOrZero").With("Move", "Do we have a move param").Will(Return.Value(1));
            Stub.On(context).Method("GetParamIntOrZero").With("MoveToForumID", "Get the move to forum id").Will(Return.Value(moveToForumID));
            MoveThread testMoveThread = new MoveThread(context);
            testMoveThread.ProcessRequest();

            // Check to make sure the move worked correclty
            XmlNode moveThreadNode = testMoveThread.RootElement.SelectSingleNode("//MOVE-THREAD-FORM");
            Assert.IsNotNull(moveThreadNode, "Failed to find the base node for the move thread.");
            Assert.IsNotNull(moveThreadNode.SelectSingleNode("//ERROR"), "We should have returned an error");
            Assert.AreEqual("Could not find move to forum", moveThreadNode.SelectSingleNode("//ERROR").InnerText, "Incorrect error returned");
            Assert.AreEqual(subject, moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/THREAD-SUBJECT").InnerText, "The thread subject is defferent to the one submitted");
            Assert.AreEqual(forumid.ToString(), moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/OLD-FORUM-ID").InnerText, "The forumid is incorrect and should be " + forumid.ToString());
            Assert.AreEqual("1", moveThreadNode.SelectSingleNode("//MOVE-THREAD-FORM/ISPREMODPOSTING").InnerText, "The post is not a premod posting!!!");
        }

        /// <summary>
        /// Creates a new premod posting post in the mod queue
        /// </summary>
        /// <param name="context">The context for the request</param>
        /// <param name="forumid">The forumid that was posted to</param>
        /// <param name="subject">The subject used for the post</param>
        /// <param name="modID">The modid for the new moderation item</param>
        private static void SetupPreModPost(IInputContext context, out int forumid, out string subject, out int modID)
        {
            // Now create a new user to play with
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            int userID = request.CurrentUserID;

            using (IDnaDataReader reader = context.CreateDnaDataReader("FindUserFromID"))
            {
                reader.AddParameter("UserID",userID);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the FindUserFromID storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the FindUserFromID storedprocedure");
                Assert.AreEqual(userID, reader.GetInt32("UserID"), "The userid should come back as normal userid, as that's the id we wanted to get!");
                Assert.AreEqual("DotNetNormalUser", reader.GetString("UserName"), "The user name has been changed in the small guide.");
                Assert.AreEqual(1, reader.GetInt32("Status"), "The status of this user should be 1, normal user");
                Assert.IsFalse(reader.GetBoolean("BannedFromComplaints"), "The use should not be banned from complaints at this stage");
            }

            // Find a forum to post to
            forumid = 0;
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select top 1 * from forums where siteid = 1 and title not in ('','User-journal','frontpage') and canread=1 order by forumid desc");
                if (reader.Read() && reader.HasRows)
                {
                    forumid = reader.GetInt32("ForumID");
                }
                Assert.AreNotEqual(0, forumid, "Failed to find a good forum to test against");
            }

            // Set the site to be in premodposting mode
            using (IDnaDataReader reader = context.CreateDnaDataReader("SetSiteOption"))
            {
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "Moderation");
                reader.AddParameter("Name", "ProcessPreMod");
                reader.AddParameter("Value", "1");
                reader.Execute();
            }

            // Now post to the forum
            subject = "Testing move thread details";
            string content = "Testing move thread details with premod posting";
            using (IDnaDataReader reader = context.CreateDnaDataReader("PostToForum"))
            {
                reader.AddParameter("userid", userID);
                reader.AddParameter("forumid", forumid);
                reader.AddParameter("inreplyto", DBNull.Value);
                reader.AddParameter("threadid", 0);
                reader.AddParameter("subject", subject);
                reader.AddParameter("content", content);
                reader.AddParameter("poststyle", 2);
                reader.AddParameter("hash", Guid.NewGuid().ToString());
                reader.AddParameter("keywords", "");
                reader.AddParameter("forcepremoderation", 1);
                reader.Execute();

                if (!reader.Read() || !reader.HasRows)
                {
                    Assert.Fail("Failed to create a new post for the test.");
                }

                Assert.AreEqual(1, reader.GetInt32("IsPreModPosting"), "The last post did not go in as a premod posting!");
            }

            // check to make sure the thread is in the mod table
            modID = 0;
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("Select top 1 pm.modid,pm.forumid,pm.subject,pm.body,tm.IsPreModPosting from threadmod tm inner join premodpostings pm on pm.modid = tm.modid order by modid desc");
                Assert.IsTrue(reader.Read() && reader.HasRows, "Failed to get the moderated post");
                Assert.AreEqual(subject, reader.GetString("subject"), "We didn't find the moderated post");
                Assert.AreEqual(content, reader.GetString("body"), "We didn't find the moderated post");
                Assert.AreEqual(forumid, reader.GetInt32("forumid"), "We didn't find the moderated post");
                Assert.AreEqual(1, reader.GetTinyIntAsInt("IsPreModPosting"), "The post went in, but not as a premod posting");
                modID = reader.GetInt32("ModID");
                Assert.IsTrue(modID > 0, "The moderation id is 0!");
            }
        }



        /// <summary>
        /// Test that we can create a forum and post a unicode comment to it for a normal non 
        /// moderated site with a unicode title and then move it
        /// </summary>
        [TestMethod]
        public void TestCreateCommentForumWithUnicodeTitleAndThenMoveIt()
        {
            Console.WriteLine("Before MoveThreadTests - TestCreateCommentForumWithUnicodeTitleAndThenMoveIt");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();
            request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);

            string server = DnaTestURLRequest.CurrentServer;

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string encodedTitle = "\u041D\u0435 \u043F\u0430\u043D\u0438\u043A\u0443\u0439\u0442\u0435 1st Forums Title";
            string hosturl = "http://" + server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + encodedTitle + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);
            XmlDocument xml = request.GetLastResponseAsXML();

            string comment = "\u03CC\u03C7\u03B9 \u03C0\u03B1\u03BD\u03B9\u03BA\u03CC\u03C2 1st Comment " + uid;
            // Now check to make sure we can post to the comment box
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=" + comment + "&dnahostpageurl=" + hosturl + "&skin=purexml");
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            int forumID = 0;
            Int32.TryParse(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMID"].Value, out forumID);

            int threadid = 0;
            Int32.TryParse(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST").Attributes["THREAD"].Value, out threadid);



            // Setup the 2nd comment forum
            string uid2 = Guid.NewGuid().ToString();
            string encodedTitle2 = "\u041D\u0435 \u043F\u0430\u043D\u0438\u043A\u0443\u0439\u0442\u0435 2nd Forums Title";
            string hosturl2 = "http://" + server + "/dna/haveyoursay/acs";

            string url2 = "acswithoutapi?dnauid=" + uid2 + "&dnainitialtitle=" + encodedTitle2 + "&dnahostpageurl=" + hosturl2 + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url2);
            XmlDocument xml2 = request.GetLastResponseAsXML();

            //string comment2 = "\u03CC\u03C7\u03B9 \u03C0\u03B1\u03BD\u03B9\u03BA\u03CC\u03C2" + uid2;
            // Now check to make sure we can post to the comment box
            // request.RequestPage("acswithoutapi?dnauid=" + uid2 + "&dnaaction=add&dnacomment=" + comment2 + "&dnahostpageurl=" + hosturl2 + "&skin=purexml");
            // Check to make sure that the page returned with the correct information
            //xml = request.GetLastResponseAsXML();
            int forumID2 = 0;
            Int32.TryParse(xml2.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMID"].Value, out forumID2);

            // Create a database context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsEditor").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("IsModerator").Will(Return.Value(false));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Mock the current site
            ISite mockedSite = DnaMockery.CurrentMockery.NewMock<ISite>();
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(72));
            Stub.On(mockedSite).GetProperty("AutoMessageUserID").Will(Return.Value(1090558354));

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml("<TOPIC-LIST />");
            Stub.On(mockedSite).Method("GetTopicListXml").Will(Return.Value(xmlDoc.FirstChild));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            // Use the move thread builder to get the details for the thread
            Stub.On(context).Method("GetParamIntOrZero").With("ThreadModID", "Get the ThreadModID").Will(Return.Value(0));
            Stub.On(context).Method("GetParamIntOrZero").With("ThreadID", "Get the thread to move").Will(Return.Value(threadid));
            Stub.On(context).Method("GetParamCountOrZero").With("Move", "Do we have a move param").Will(Return.Value(1));
            Stub.On(context).Method("GetParamIntOrZero").With("MoveToForumID", "Get the move to forum id").Will(Return.Value(forumID2));
            Stub.On(context).Method("DoesParamExist").With("PostContent", "Do we have post content").Will(Return.Value(false));
            MoveThread testMoveThread = new MoveThread(context);
            testMoveThread.ProcessRequest();

            //get the second url again and it should contain the first urls post
            request.RequestPage(url2);
            xml = request.GetLastResponseAsXML();
            bool movedText = xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='" + comment + "']") != null;

            Assert.IsTrue(movedText, "Post to the 1st Forum has not been moved to the second" + xml.InnerText);

            Console.WriteLine("After MoveThreadTests - TestCreateCommentForumWithUnicodeTitleAndThenMoveIt");

        }
    }
}
