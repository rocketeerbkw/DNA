using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Tests for all the common elements we expect to see on a request
    /// </summary>
    [TestClass]
    public class SiteSummaryPageTests
    {
        DateTime _startDate = DateTime.Parse("2000-01-01 00:00:01");
        DateTime _endDate = DateTime.Now.AddDays(1.0);

        /// <summary>
        /// Create a Comment / Post and Moderate It.
        /// </summary>
        [TestInitialize]
        public void CreateModeratedContent()
        {
            SnapshotInitialisation.ForceRestore();
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            int userId = request.CurrentUserID;

            // First create a new comment forum
            string uid = "TestUniqueKeyValue" + Guid.NewGuid().ToString();//make it random
            string url = "www.bbc.co.uk/dna/commentforumtestpage.html";
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("getcommentforum"))
            {
                reader.AddParameter("uid", uid);
                reader.AddParameter("url", url);
                reader.AddParameter("Title", "TEST");
                reader.AddParameter("siteid", 1);
                reader.AddParameter("CreateIfNotExists", 1);
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.Read(), "Unable to Create Comment Forum");

                byte moderationStatus = reader.GetByteNullAsZero("moderationStatus");
                int forumid = reader.GetInt32("ForumID");
                int canread = reader.GetByteNullAsZero("ForumCanRead");
                int canwrite = reader.GetByteNullAsZero("ForumCanWrite");
            }

            //Create a moderated Comment/Post.
            string comment = "Testing SiteSummary page.";
            Guid guid = DnaHasher.GenerateCommentHashValue(comment, uid, userId);


            int postId = 0;
            using (IDnaDataReader reader = context.CreateDnaDataReader("CreateComment"))
            {
                reader.AddParameter("uniqueid", uid);
                reader.AddParameter("userid", userId);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("content", comment);
                reader.AddParameter("hash", guid);
                reader.AddParameter("forcemoderation", 1);
                reader.AddParameter("ignoremoderation", 0);
                reader.AddParameter("isnotable", 0);
                reader.AddParameter("poststyle", 1);
                reader.Execute();

                Assert.IsTrue(reader.Read(), "Unable to post to comment forum.");
                postId = reader.GetInt32NullAsZero("postid");
            }


            int threadId = 0;
            int forumId = 0;
            int modId = 0;
            request.SetCurrentUserSuperUser();
            userId = request.CurrentUserID;
            using (IDnaDataReader reader = context.CreateDnaDataReader("getmoderationposts"))
            {
                reader.AddParameter("userid", userId);
                reader.AddParameter("issuperuser", 1);
                reader.Execute();
                while (reader.Read())
                {
                    threadId = reader.GetInt32NullAsZero("threadid");
                    forumId = reader.GetInt32NullAsZero("forumid");
                    modId = reader.GetInt32NullAsZero("modid");

                    //Moderate the post.
                    String notes = "Automated Functional Testing";
                    int status = 3;
                    using (IDnaDataReader modReader = context.CreateDnaDataReader("moderatePost"))
                    {
                        modReader.AddParameter("forumid", forumId);
                        modReader.AddParameter("threadId", threadId);
                        modReader.AddParameter("postid", postId);
                        modReader.AddParameter("modid", modId);
                        modReader.AddParameter("referto", 0);
                        modReader.AddParameter("referredby", 0);
                        modReader.AddParameter("status", status);
                        modReader.AddParameter("notes", notes);
                        modReader.Execute();
                    }
                }
            }
        }

        /// <summary>
        /// Test to see if the common page elements are there
        /// </summary>
        [TestMethod]
        public void TestSiteSummaryPageXML()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("Test"))
            {
                DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
                request.SetCurrentUserSuperUser();
                request.UseEditorAuthentication = true;
                request.RequestPage(@"sitesummary?skin=purexml&startdate=" + _startDate.ToString("yyyy-MM-dd HH:mm:ss") + "&enddate=" + _endDate.ToString("yyyy-MM-dd HH:mm:ss"));
                XmlDocument doc = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(doc.InnerXml, "H2G2SiteSummaryFlat.xsd");
                validator.Validate();
            }
        }


        /// <summary>
        /// Check some of the results in the SiteSummary page.
        /// Independently counts the moderation counts then compares these counts with the values 
        /// in the SiteSummary page.
        /// </summary>
        [TestMethod]
        public void TestSiteSummaryPageData()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("Test") ) 
            {
                int threadmodtotal = 0;
                int threadpassedtotal = 0;
                int threadfailedtotal = 0;
                int threadreferredtotal = 0;
                int threadcomplainttotal = 0;

                String query = @"SELECT * FROM ThreadMod WHERE DateCompleted BETWEEN '" + _startDate.ToString("yyyy-MM-dd HH:mm:ss") + "' AND '" + _endDate.ToString("yyyy-MM-dd HH:mm:ss") + "' AND SiteID = 1";
                reader.ExecuteDEBUGONLY(query );
                while ( reader.Read() )
                {
                    threadmodtotal++ ;
                    int status = reader.GetInt32NullAsZero("status");
                    if ( status == 3 )
                        threadpassedtotal++;
                    if (status == 4)
                        threadfailedtotal++;
                    if (!reader.IsDBNull("ReferredBy"))
                        threadreferredtotal++;
                    if (!reader.IsDBNull("ComplainantID"))
                        threadcomplainttotal++;
                }
                
                DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
                request.SetCurrentUserSuperUser();
                request.UseEditorAuthentication = true;
                query = @"sitesummary?skin=purexml&recalculate=1&siteid=1&startdate=" + _startDate.ToString("yyyy-MM-dd HH:mm:ss") + "&enddate=" + _endDate.ToString("yyyy-MM-dd HH:mm:ss");
                request.RequestPage(query);
                XmlDocument doc = request.GetLastResponseAsXML();

                XmlNode node = doc.SelectSingleNode("H2G2/SITESUMMARY/POSTSUMMARYLIST/POSTSUMMARY[@SITEID='1']/POSTMODERATEDTOTAL");
                Assert.IsNotNull(node,"Failed to find Post Mod Total on Summary Page");
                Assert.IsTrue(node.InnerText == Convert.ToString(threadmodtotal),"Checking thread mod total");

                node = doc.SelectSingleNode("H2G2/SITESUMMARY/POSTSUMMARYLIST/POSTSUMMARY[@SITEID='1']/POSTPASSED");
                Assert.IsNotNull(node,"Failed to find Post Passed Total on Summary Page");
                Assert.IsTrue(node.InnerText == Convert.ToString(threadpassedtotal),"Checking Post passed total");

                node = doc.SelectSingleNode("H2G2/SITESUMMARY/POSTSUMMARYLIST/POSTSUMMARY[@SITEID='1']/POSTFAILED");
                Assert.IsNotNull(node,"Failed to find Post Failed Total on Summary Page");
                Assert.IsTrue(node.InnerText == Convert.ToString(threadfailedtotal),"Checking post failed total");

                node = doc.SelectSingleNode("H2G2/SITESUMMARY/POSTSUMMARYLIST/POSTSUMMARY[@SITEID='1']/POSTREFERRED");
                Assert.IsNotNull(node,"Failed to find Post Referred Total on Summary Page");
                Assert.IsTrue(node.InnerText == Convert.ToString(threadreferredtotal),"Checking post referred total");
            }
        }
    }
}
