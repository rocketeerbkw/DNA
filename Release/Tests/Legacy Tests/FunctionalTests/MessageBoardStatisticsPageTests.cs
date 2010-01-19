using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class MessageBoardStatisticsPageTests.cs
    /// </summary>
    [TestClass]
    public class MessageBoardStatisticsPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("mbpointsofview");
        private const string _schemaUri = "H2G2MessageBoardStatisticsFlat.xsd";


        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.ForceRestore();
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("setting up");
                _request.UseEditorAuthentication = true;
                _request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;
            }
        }

        [TestCleanup]
        public void ShutDown()
        {
            SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateMessageBoardStatisticsPageTest()
        {
            Console.WriteLine("Before Test01CreateMessageBoardStatisticsPageTest");
            _request.RequestPage("MessageBoardStats?skin=purexml");
            Console.WriteLine("After Test01CreateMessageBoardStatisticsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test02CreateEmailMessageBoardStatisticsPageTest()
        {
            DateTime dt = DateTime.Now;
            string date = dt.ToString("yyyyMMdd");

            Console.WriteLine("Before Test02CreateEmailMessageBoardStatisticsPageTest");
            _request.RequestPage("MessageBoardStats?emailFrom=" + date + "@test.bbc.co.uk&emailTo=Messageboardstatstest@test.bbc.co.uk&skin=purexml");
            Console.WriteLine("After Test02CreateEmailMessageBoardStatisticsPageTest");

            //TODO Check the failed email folder contains the email

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test03CreateMessageBoardStatisticsWithDatePageTest()
        {
            Console.WriteLine("Before Test03CreateMessageBoardStatisticsWithDatePageTest");
            
            TestPost();

            _request.RequestPage("MessageBoardStats?date=20050101&skin=purexml");

            Console.WriteLine("After Test03CreateMessageBoardStatisticsWithDatePageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MESSAGEBOARDSTATS") != null, "The page does not exist!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MESSAGEBOARDSTATS/MODSTATSPERTOPIC") != null, "The Mod Stats Per Topic does not exist!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MESSAGEBOARDSTATS/MODSTATSTOPICTOTALS") != null, "The Mod Stats Topic Total does not exist!!!");
        }

        /// <summary>
        /// Validate the xml. 
        /// </summary>
        [TestMethod]
        public void Test04CheckMessageBoardStatisticsXmlTest()
        {
            Console.WriteLine("Before Test04CheckMessageBoardStatisticsXmlTest");
            _request.RequestPage("MessageBoardStats?date=20050101&skin=purexml");
            Console.WriteLine("After Test04CheckMessageBoardStatisticsXmlTest");

            XmlDocument xml = _request.GetLastResponseAsXML();

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }




        private void TestPost()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Find a forum to post to
            int forumid = 0;
            using (IDnaDataReader forumReader = context.CreateDnaDataReader(""))
            {
                forumReader.ExecuteDEBUGONLY("select top 1 * from forums where siteid = 19 and title ='Dr Who' and canread=1 order by forumid desc");
                if (forumReader.Read() && forumReader.HasRows)
                {
                    forumid = forumReader.GetInt32("ForumID");
                }
                Assert.AreNotEqual(0, forumid, "Failed to find a good forum to test against");
            }



            // Now post to the forum
            string subject = "Testing messageboard statisitics post subject.";
            string content = "Testing messageboard statisitics post.";
            using (IDnaDataReader postToForumReader = context.CreateDnaDataReader("PostToForum"))
            {
                postToForumReader.AddParameter("userid", 1090558353);
                postToForumReader.AddParameter("forumid", forumid);
                postToForumReader.AddParameter("inreplyto", DBNull.Value);
                postToForumReader.AddParameter("threadid", 0);
                postToForumReader.AddParameter("subject", subject);
                postToForumReader.AddParameter("content", content);
                postToForumReader.AddParameter("poststyle", 2);
                postToForumReader.AddParameter("hash", Guid.NewGuid().ToString());
                postToForumReader.AddParameter("keywords", "");
                postToForumReader.AddParameter("forcepremoderation", 1);
                postToForumReader.Execute();

                if (!postToForumReader.Read() || !postToForumReader.HasRows)
                {
                    Assert.Fail("Failed to create a new post for the test.");
                }
            }

            //Moderate the post with the moderator user account
            ModeratePostUpdateEntry(1090564231, context);

        }


        private void ModeratePostUpdateEntry(int moderatorUserId, IInputContext inputContext)
        {
            int processedThreadID=0;
            using (IDnaDataReader reader = inputContext.CreateDnaDataReader("getmoderationposts"))
            {
                reader.AddParameter("@userid", moderatorUserId);
                reader.Execute();
                Assert.IsTrue(reader.Read(), "Expecting at least one post to moderate");
                do
                {
                    int forumId = reader.GetInt32NullAsZero("ForumID");
                    int threadId = reader.GetInt32NullAsZero("ThreadID");
                    int postId = reader.GetInt32NullAsZero("EntryID");
                    int modID = reader.GetInt32NullAsZero("ModID");
                    using (IDnaDataReader subreader = inputContext.CreateDnaDataReader("moderatepost"))
                    {
                        subreader.AddParameter("@forumid", forumId)
                        .AddParameter("@threadid", threadId)
                        .AddParameter("@postid", postId)
                        .AddParameter("@modid", modID)
                        .AddParameter("@status", 3)
                        .AddParameter("@notes", "")
                        .AddParameter("@referto", 0)
                        .AddParameter("@referredby", moderatorUserId)
                        .AddParameter("@moderationstatus", 0);
                        subreader.Execute();


                        Assert.IsTrue(subreader.Read(), "moderatepost expects a single row");
                        Assert.IsTrue(subreader.GetInt32NullAsZero("PostID") > 0, "PostID should be non-zero after processing");

                        processedThreadID = subreader.GetInt32NullAsZero("ThreadID");

                        int postid = subreader.GetInt32NullAsZero("PostID");
                    }

                } while (reader.Read());
            }

            string updateEntry = "UPDATE ThreadMod SET DateQueued='20050101' WHERE ThreadID = " + processedThreadID.ToString();

            //string server = GetServerName();

            using (IDnaDataReader reader = inputContext.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(updateEntry);
            }

        }


        private string GetServerName()
        {
            XmlDocument xmldoc = new XmlDocument();

            string path = String.Empty;
            try
            {
                path = System.Configuration.ConfigurationManager.AppSettings["ripleyserverxmlconf"].ToString();
            }
            catch (Exception)
            {
                path = String.Empty;
            }


            if (path == String.Empty)
            {
                path = TestConfig.GetConfig().GetRipleyServerPath();
            }

            path += "ripleyserver.xmlconf";

            xmldoc.Load(path);

            XmlNode node = xmldoc.SelectSingleNode("RIPLEY//DBSERVER//SQLSERVER//SERVERNAME");
            string servername = node.InnerText;
            return servername;
        }

    }
}