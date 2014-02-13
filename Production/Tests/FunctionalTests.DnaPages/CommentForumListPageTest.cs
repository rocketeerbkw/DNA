using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.IO;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class CommentForumListPageTest.cs
    /// </summary>
    [TestClass]
    public class CommentForumListPageTest
    {
        private string _firstUid = String.Empty;
        private string _forumId = string.Empty;
        private bool _setupRun = false;
        private string _defaultForumTitle = "newTitle";

        private DnaTestURLRequest _request = new DnaTestURLRequest("haveyoursay");

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("setting up");
                _request.UseEditorAuthentication = true;
                _request.SetCurrentUserEditor();
                _request.UseIdentitySignIn = true;
//                _request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;

                MakeSureWeHaveACommentForum();

                ClearAllEmails();
            }
        }

        /// <summary>
        /// Clears all the emails from the directory specified
        /// </summary>
        private void ClearAllEmails()
        {
            DirectoryInfo dir = new DirectoryInfo(TestConfig.GetConfig().GetRipleyConfSetting("CACHEROOT") + "failedmails");

            if (dir.Exists)
            {
                foreach (var file in dir.GetFiles())
                {
                    file.Delete();
                }
            }

        }

        /// <summary>
        /// Check if the email was sent
        /// </summary>
        /// <param name="subject"></param>
        /// <param name="expectedInEmail"></param>
        private void CheckEmailWasSent(string subject, string expectedInEmail)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("EXEC openemailaddresskey; select top 1 subject = dbo.udf_decrypttext(subject, ID), body = dbo.udf_decrypttext(body, ID) from emailqueue ORDER BY ID Desc");
                Assert.IsTrue(dataReader.Read());
                Assert.IsTrue(dataReader.HasRows);
                Assert.AreEqual(subject, dataReader.GetString("subject"));
                Assert.IsTrue(dataReader.GetString("body").Contains(expectedInEmail));
            }

            //DirectoryInfo dir = new DirectoryInfo(TestConfig.GetConfig().GetRipleyConfSetting("CACHEROOT") + "failedmails");
            //Assert.IsTrue(dir.Exists);
            //Assert.AreEqual(1, dir.GetFiles().Length);

            //string email = string.Empty;
            //var emailFile = dir.GetFiles()[0];
            //using (var stream = emailFile.OpenText())
            //{
            //    email = stream.ReadToEnd();
            //    stream.Close();
            //}
            //Assert.IsTrue(email.IndexOf(expectedInEmail) >= 0);

            //email = email.Replace("\r\n", "\n");
            //var emailLines = email.Split('\n');
            //Assert.AreEqual(subject, emailLines[2]);//third line is the subject
        }

        /// <summary>
        /// Use the Ajax test to create a commentforum for site 1 as a restore may blank it out
        /// </summary>
        private void MakeSureWeHaveACommentForum()
        {
           // Console.WriteLine("Before MakeSureWeHaveACommentForum");
          //  FileInputContext inputContext = new FileInputContext();
            //inputContext.InitialiseFromFile(@"../../../Tests/testredirectparams.txt", @"../../../Tests/userdave.txt");

            //CommentBoxForum forum = new CommentBoxForum(inputContext);
            //forum.ProcessRequest();


            //string forumXml = forum.RootElement.InnerXml;
            //DnaXmlValidator validator = new DnaXmlValidator(forumXml, "CommentBox.xsd");
            //validator.Validate();
            //Console.WriteLine("After MakeSureWeHaveACommentForum");
            _request.RequestPage("acs?dnaaction=add&dnahostpageurl=http://www.bbc.co.uk/dna/something&dnauid=this is some unique id blah de blah blah2&dnainitialtitle=" + _defaultForumTitle +"&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            //DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "CommentBox.xsd");
            //validator.Validate();
            Console.WriteLine("After MakeSureWeHaveACommentForum");
        }

        private void GetFirstUid()
        {
            GetFirstUid(false);
        }

        private void GetFirstUid(bool bForceReRead)
        {
            if (_firstUid == String.Empty || bForceReRead)
            {
                _request.RequestPage("CommentForumList?dnaskip=0&dnashow=20&skin=purexml");

                XmlDocument xml = _request.GetLastResponseAsXML();

                int CommentForumListCount = 0;
                Int32.TryParse(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT").Value.ToString(), out CommentForumListCount);

                if (CommentForumListCount > 0)
                {
                    _firstUid = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/@UID").Value.ToString();
                    _forumId = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/@FORUMID").Value.ToString();//Required for testing the new feature
                    _defaultForumTitle = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/TITLE").InnerText;
                }
            }
        }

      

        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateCommentForumListPageTest()
        {
            Console.WriteLine("Test1CreateCommentForumListPageTest");
            _request.RequestPage("CommentForumList?skin=purexml");
            Console.WriteLine("After Test1CreateCommentForumListPageTest");
            
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
        }

        /// <summary>
        /// Test we get a comment forum list page for the call. 
        /// </summary>
        [TestMethod]
        public void Test02GetCommentForumListPageTest()
        {
            Console.WriteLine("Test02GetCommentForumListPageTest");
            _request.RequestPage("CommentForumList?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST") != null, "The comment forum list page has not been generated!!!");
        }

        /// <summary>
        /// Test we get the default information of comments for all sites. 
        /// </summary>
        [TestMethod]
        public void Test03GetAllCommentForumListsTest()
        {
            Console.WriteLine("Test03GetAllCommentForumListsTest");
            _request.RequestPage("CommentForumList?dnasiteid=0&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST") != null, "The comment forum list page has not been generated!!!");
        }

        /// <summary>
        /// Test we get the default information of comments for all sites. 
        /// </summary>
        [TestMethod]
        public void Test04SkipAndShowCommentForumListsTest()
        {
            Console.WriteLine("Test04SkipAndShowCommentForumListsTest");
            _request.RequestPage("CommentForumList?dnasiteid=0&dnaskip=0&dnashow=20&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST[@SKIP=0]") != null, "The comment forum list page has not been generated!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST[@SHOW=20]") != null, "The comment forum list page has not been generated!!!");
        }

        /// <summary>
        /// Testing format of the Comment CommentBoxForum XML
        /// </summary>
        [TestMethod]
        public void Test05CheckCommentForumListXmlFormatTest()
        {
            GetFirstUid();

            _request.RequestPage("CommentForumList?dnaskip=0&dnashow=20&skin=purexml");

            Console.WriteLine("Test05CheckCommentForumListXmlFormatTest");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT") != null, "The comment forum list page has not been generated correctly - COMMENTFORUMLISTCOUNT!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/@SKIP") != null, "The comment forum list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/@SHOW") != null, "The comment forum list page has not been generated correctly - SHOW!!!");

            Console.WriteLine("After first checks");
            
            int CommentForumListCount = 0;
            Int32.TryParse(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT").Value.ToString(), out CommentForumListCount);

            Console.WriteLine("Comment CommentBoxForum List Count = " + CommentForumListCount.ToString());

            if (CommentForumListCount > 0)
            {
                Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/@UID") != null, "The comment forum list page has not been generated correctly - UID!!!");

                Console.WriteLine("Comment CommentBoxForum List Uid = " + _firstUid.ToString());

                Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/@FORUMID") != null, "The comment forum list page has not been generated correctly - FORUMID!!!");
                Console.WriteLine("Comment CommentBoxForum  - CommentBoxForum Id present");
                Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/@FORUMPOSTCOUNT") != null, "The comment forum list page has not been generated correctly - FORUMPOSTCOUNT!!!");
                Console.WriteLine("Comment CommentBoxForum - CommentBoxForum Post Count present");
                Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/MODSTATUS") != null, "The comment forum list page has not been generated correctly - MODSTATUS!!!");
                Console.WriteLine("Comment CommentBoxForum - Mod Status  present");
                Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/DATECREATED") != null, "The comment forum list page has not been generated correctly - CLOSEDATE!!!");
                Console.WriteLine("Comment CommentBoxForum - DateCreated present");
                Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/@CANWRITE") != null, "The comment forum list page has not been generated correctly - COMMENTFORUMLISTCOUNT!!!");
                Console.WriteLine("Comment CommentBoxForum List CanWrite present");

            }
        }

        /// <summary>
        /// Testing updating the a comment forum mod status, open close status and end/close date
        /// </summary>
        [TestMethod]
        public void Test06UpdateAllStatusesForCommentForumTest()
        {
            Console.WriteLine("Test06UpdateAllStatusesForCommentForumTest");
            GetFirstUid();

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + @"&dnanewmodstatus=reactive&dnanewforumclosedate=20070709&dnanewcanwrite=1&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();
            XmlNode node;

            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/MODSTATUS");
            Assert.IsTrue(node.InnerText == "1", "The comment forum has not been altered!!! - Moderation Status");
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/CLOSEDATE/DATE/LOCAL/@SORT");
            Assert.IsTrue(node.InnerText == "20070709000000", "The comment forum has not been altered!!! - Closed Date");
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/@CANWRITE");
            Assert.IsTrue(node.InnerText == "1", "The comment forum has not been altered!!! - Can Write flag!!!");
        }
        /// <summary>
        /// Testing updating the a comment forum mod status
        /// </summary>
        [TestMethod]
        public void Test07UpdateModStatusForCommentForumTest()
        {
            Console.WriteLine("Test07UpdateModStatusForCommentForumTest");
            GetFirstUid();

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnanewmodstatus=reactive&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();
            XmlNode node;

            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/MODSTATUS");
            Assert.IsTrue(node.InnerText == "1", "The comment forum has not been altered!!! - Moderation Status");
        }
        /// <summary>
        /// Testing updating the a comment forum can write
        /// </summary>
        [TestMethod]
        public void Test08UpdateCanWriteForCommentForumTest()
        {
            Console.WriteLine("Test08UpdateCanWriteForCommentForumTest");
            GetFirstUid();

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnanewcanwrite=1&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();
            XmlNode node;

            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/@CANWRITE");
            Assert.IsTrue(node.InnerText == "1", "The comment forum has not been altered!!! - Can Write flag!!!");
        }
        /// <summary>
        /// Testing updating the a comment end/close date
        /// </summary>
        [TestMethod]
        public void Test09UpdateACloseDateForCommentForumTest()
        {
            Console.WriteLine("Test09UpdateACloseDateForCommentForumTest");
            GetFirstUid();

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnanewforumclosedate=20070709&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();
            XmlNode node;

            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/CLOSEDATE/DATE/LOCAL/@SORT");
            Assert.IsTrue(node.InnerText == "20070709000000", "The comment forum has not been altered!!! - Closed Date");
        }

        /// <summary>
        /// Testing the anonymous posting status of a comment forum
        /// </summary>
        [TestMethod]
        public void Test25UpdateAnonymousPostingStatusForCommentForumTest()
        {
            Console.WriteLine("Test25UpdateAnonymousPostingStatusForCommentForumTest");

            int currentSiteId = GetSiteIdForSite("haveyoursay");

            SetAnonymousStatusForSite(currentSiteId, true);

            _request.RequestPage(string.Format("CommentForumList?dnasiteid={0}&skin=purexml&_ns=1",currentSiteId));

            XmlDocument xml = _request.GetLastResponseAsXML();

            XmlNode node;
            node = xml.SelectSingleNode("H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'AllowNotSignedInCommenting']/VALUE");
            Assert.AreEqual("1", node.InnerText);

            var forumUID = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/@UID").Value;

            var forumID = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + forumUID + "']/@FORUMID").Value;

            UpdateAnonymousPostingForCommentForum(currentSiteId, Convert.ToInt32(forumID));

            _request.RequestPage(string.Format("CommentForumList?dnasiteid={0}&skin=purexml&_ns=1", currentSiteId));

            XmlDocument xml1 = _request.GetLastResponseAsXML();

            node = xml1.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + forumUID + "']/@NOTSIGNEDINUSERID");
            Assert.IsTrue(!string.IsNullOrEmpty(node.InnerText));
            Assert.AreEqual("0", node.InnerText);

            //Anonymous posting update on comment forum
            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + forumUID + "&dnaanonymoussetting=allow&forumid=" + forumID + "&skin=purexml&_ns=1";
            _request.RequestPage(requesturl);

            XmlDocument xml2 = _request.GetLastResponseAsXML();
            node = xml2.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + forumUID + "']/@NOTSIGNEDINUSERID");
            Assert.AreNotEqual("0", node.InnerText);
        }

        /// <summary>
        /// Testing the comment forum doesn't get updated with invalid parameters
        /// </summary>
        [TestMethod]
        public void Test10InvalidParamsCommentForumListTest()
        {
            Console.WriteLine("Test10InvalidParamsCommentForumListTest");
            GetFirstUid();

            _request.RequestPage("CommentForumList?dnaskip=0&dnashow=20&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();

            XmlNode node;
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid +"']/MODSTATUS");
            string modStatus = node.InnerText;
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/CLOSEDATE/DATE/LOCAL/@SORT");
            string closeDateSort = node.InnerText;
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/@CANWRITE");
            string canWrite = node.InnerText;

            //Checks that we don't update with default blank values if we miss out parameters

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml2 = _request.GetLastResponseAsXML();
            node = xml2.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/MODSTATUS");
            Assert.IsTrue(node.InnerText == modStatus, "The comment forum has been altered!!! - Moderation Status");
            node = xml2.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/CLOSEDATE/DATE/LOCAL/@SORT");
            Assert.IsTrue(node.InnerText == closeDateSort, "The comment forum has been altered!!! - Closed Date");
            node = xml2.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/@CANWRITE");
            Assert.IsTrue(node.InnerText == canWrite, "The comment forum has been altered!!! - Can Write flag!!!");

        }
        /// <summary>
        /// Testing the comment forum doesn't get updated with an invalid date parameter
        /// </summary>
        [TestMethod]
        public void Test11InvalidNewDateCommentForumListTest()
        {
            Console.WriteLine("Test11InvalidNewDateCommentForumListTest");
            GetFirstUid();

            _request.RequestPage("CommentForumList?dnaskip=0&dnashow=20&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();

            XmlNode node;
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/CLOSEDATE/DATE/LOCAL/@SORT");
            string closeDateSort = node.InnerText;

            //Checks that we don't update with default blank values if we miss out parameters

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnanewforumclosedate=20073369&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml2 = _request.GetLastResponseAsXML();

            //Check the date hasn't changed
            node = xml2.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/CLOSEDATE/DATE/LOCAL/@SORT");
            Assert.IsTrue(node.InnerText == closeDateSort, "The comment forum has been altered!!! - Closed Date");
            
            //Check we've got an error message
            node = xml2.SelectSingleNode("H2G2/ERROR/ERRORMESSAGE");
            Assert.IsTrue(node.InnerText.Contains(@"Invalid date"), "The comment forum has no invalid date error!!!");

        }
        /// <summary>
        /// Testing the comment forum doesn't get updated with invalid parameters
        /// </summary>
        [TestMethod]
        public void Test12InvalidModStatusParamCommentForumListTest()
        {
            Console.WriteLine("Test12InvalidModStatusParamCommentForumListTest");
            GetFirstUid();

            _request.RequestPage("CommentForumList?dnaskip=0&dnashow=20&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();

            XmlNode node;
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/MODSTATUS");
            string modStatus = node.InnerText;

            //Checks that we don't update with default blank values if we miss out parameters

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnanewmodstatus=FRED&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml2 = _request.GetLastResponseAsXML();
            node = xml2.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/MODSTATUS");
            Assert.IsTrue(node.InnerText == modStatus, "The comment forum has been altered!!! - Moderation Status");
            //Check we've got an error message
            node = xml2.SelectSingleNode("H2G2/ERROR/ERRORMESSAGE");
            Assert.IsTrue(node.InnerText.Contains(@"Illegal New Moderation Status"), "The comment forum has no invalid mod status error!!!");

        }

        /// <summary>
        /// Tests we can get the comments for a particular site and the site is returned in the xml. 
        /// </summary>
        [TestMethod]
        public void Test13GetSiteSpecificCommentForumListTest()
        {
            Console.WriteLine("Before Test13GetSiteSpecificCommentForumListTest");

            int CommentForumListCount = 0;
            string firstHaveYourSayUid = String.Empty;
            int haveYourSaySiteId = GetSiteIdForSite("haveyoursay");
            Console.WriteLine("HaveYourSay Site ID " + haveYourSaySiteId);

            _request.RequestPage("CommentForumList?dnasiteid=" + Convert.ToString(haveYourSaySiteId) + "&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();

            Int32.TryParse(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT").Value.ToString(), out CommentForumListCount);

            if (CommentForumListCount > 0)
            {
                firstHaveYourSayUid = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/@UID").Value.ToString();
            }

            Console.WriteLine("First HaveYourSay ID " + firstHaveYourSayUid);

            _request.RequestPage("CommentForumList?dnasiteid=" + Convert.ToString(haveYourSaySiteId) + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();

            XmlNode node;
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + firstHaveYourSayUid + "']/SITEID");
            if (node != null)
            {
                string siteid = node.InnerText;
                Console.WriteLine("SiteID = " + siteid);
                Console.WriteLine("HaveYourSaySiteID = " + siteid);
                Assert.IsTrue(siteid == Convert.ToString(haveYourSaySiteId), "The comment forum list page has not been generated correctly wrong site!!! Was " + siteid + " Expected " + haveYourSaySiteId);
            }
            else
            {
                node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST");
                Console.WriteLine(xml.OuterXml);
                Assert.IsTrue(false, "The comment forum list page has not been generated correctly wrong site!!! Expected " + haveYourSaySiteId + ";");
            }
            Console.WriteLine("Before Requested Site ID Check");

            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID");
            if (node != null)
            {
                string requestedSiteID = node.InnerText;
                Assert.IsTrue(requestedSiteID == Convert.ToString(haveYourSaySiteId), "The comment forum list page has not been generated correctly requested site id wrong!!! Was " + requestedSiteID + " Expected " + haveYourSaySiteId);
            }
            else
            {
                node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST");
                Console.WriteLine(xml.OuterXml);
                Assert.IsTrue(false, "The comment forum list page has not been generated correctly No Requested Site ID;");
            }


            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST");
            if (node != null)
            {
                string termslistForumID = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST/@FORUMID").Value.ToString();
                string commentForumID = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/@FORUMID").Value.ToString();
                Assert.AreEqual(termslistForumID, commentForumID);
            }
            else
            {
                node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST");
                Console.WriteLine(xml.OuterXml);
                Assert.IsTrue(false, "The comment forum list page has not been generated correctly. No Terms related data.");
            }

        }

        /// <summary>
        /// Test that a non editor getting past the challenge response cannot see the xml. 
        /// </summary>
        [TestMethod]
        public void Test14NonEditor401CommentForumListsTest()
        {
            Console.WriteLine("Test14NonEditor401CommentForumListsTest - Exception Test");
            DnaTestURLRequest _normalUserRequest = new DnaTestURLRequest("haveyoursay");
            _normalUserRequest.UseEditorAuthentication = false;
            _normalUserRequest.SetCurrentUserNormal();
            //_normalUserRequest.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.NORMALUSER);
            _normalUserRequest.AssertWebRequestFailure = false;
            try
            {
                // Try to send the request and get the response
                _normalUserRequest.RequestPage("CommentForumList?skin=purexml");
                Assert.IsTrue(true, "The request should have thrown an exception!!");
            }
            catch (Exception ex)
            {
                Assert.IsTrue(ex.Message.Contains(@"(401) Unauthorized."), "The comment forum has thrown wrong exception!!!");
            }
        }

        /// <summary>
        /// Test that a non editor getting past the challenge response cannot see the xml. 
        /// </summary>
        [TestMethod]
        public void Test15NonEditorXmlErrorCommentForumListsTest()
        {
            Console.WriteLine("Test15NonEditorXmlErrorCommentForumListsTest");
            DnaTestURLRequest _normalUserRequest = new DnaTestURLRequest("haveyoursay");
            _normalUserRequest.UseEditorAuthentication = true;
            _normalUserRequest.SetCurrentUserNormal();

            //_normalUserRequest.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.NORMALUSER);

            _normalUserRequest.RequestPage("CommentForumList?skin=purexml");

            CheckError(_normalUserRequest, "Not Authorised");
        }

        

        /// <summary>
        /// Test we get the editable sites sitelist. 
        /// </summary>
        [TestMethod]
        public void Test16CheckEditableSitesSiteListCommentForumListsTest()
        {
            Console.WriteLine("Test16CheckEditableSitesSiteListCommentForumListsTest");
            GetFirstUid();
            _request.RequestPage("CommentForumList?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            XmlNode node;
            Assert.IsTrue(xml.SelectSingleNode("H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[NAME='haveyoursay']") != null, "The comment forum list editable sites sitelist is not correct!!! - NAME");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[NAME='haveyoursay']/DESCRIPTION") != null, "The comment forum list editable sites sitelist is not correct!!! - DESCRIPTION");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[NAME='haveyoursay']/SHORTNAME") != null, "The comment forum list editable sites sitelist is not correct!!! - SHORTNAME");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[NAME='haveyoursay']/SSOSERVICE") != null, "The comment forum list editable sites sitelist is not correct!!! - SSOSERVICE");
            node = xml.SelectSingleNode("H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[NAME='haveyoursay']/NAME");
            Assert.IsTrue(node.InnerText == @"haveyoursay", "The comment forum list editable sites sitelist is not correct!!! site 36 not haveyoursay");
            
            Console.WriteLine("After Test16CheckEditableSitesSiteListCommentForumListsTest");
        }

        [TestMethod]
        public void Test17GetCommentListForumByDnaUids()
        {
            Console.WriteLine("Test17GetCommentListForumByDnaUids");
            GetFirstUid();

            DnaTestURLRequest _editorUserRequest = new DnaTestURLRequest("haveyoursay");
            _editorUserRequest.UseEditorAuthentication = true;
            _editorUserRequest.SetCurrentUserEditor();

            //_normalUserRequest.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);

            _editorUserRequest.RequestPage("CommentForumList?skin=purexml&u=" + _firstUid.ToString());

            XmlDocument xml = _editorUserRequest.GetLastResponseAsXML();

            Assert.AreEqual(_firstUid, xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM/@UID").Value);


        }

        [TestMethod]
        public void Test18AddRemoveFastModStatus()
        {
            Console.WriteLine("Test09UpdateACloseDateForCommentForumTest");
            GetFirstUid();

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnafastmod=enabled&skin=purexml";

            try
            {
                _request.RequestPage(requesturl);

                XmlDocument xml = _request.GetLastResponseAsXML();
                XmlNode node;

                node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/FASTMOD");
                Assert.IsTrue(node.InnerText == "1", "Not added to fast mod");

                requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnafastmod=disabled&skin=purexml";
                _request.RequestPage(requesturl);

                xml = _request.GetLastResponseAsXML();
                node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + _firstUid + "']/FASTMOD");
                Assert.IsTrue(node.InnerText == "0", "Not removed from fast mod");
            }
            catch (Exception ex)
            {
                Assert.IsTrue(ex.Message.Contains("Assert.Fail failed."));
            }


        }

        /// <summary>
        /// Testing updating the a comment forum mod status, open close status and end/close date
        /// </summary>
        [TestMethod]
        public void Test19CreateCommentForumTest()
        {
            Console.WriteLine("Test19CreateCommentForumTest");
            var testUid = Guid.NewGuid().ToString();

            string requesturl = "CommentForumList?dnaaction=create&dnauid=" + testUid + @"&dnahostpageurl=http://bbc.co.uk/&dnatitle=test&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();
            XmlNode node;

            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + testUid + "']/HOSTPAGEURL");
            Assert.IsTrue(node.InnerText == "http://bbc.co.uk/", "The comment forum was not created");
            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + testUid + "']/TITLE");
            Assert.IsTrue(node.InnerText == "test", "The comment forum was not created");
        }

        [TestMethod]
        public void Test20CreateCommentForumTest_Withoutuid_CorrectError()
        {
            Console.WriteLine("Test20CreateCommentForumTest_Withoutuid_CorrectError");
            var testUid = Guid.NewGuid().ToString();

            string requesturl = "CommentForumList?dnaaction=create&dnauid=&dnahostpageurl=http://bbc.co.uk/&dnatitle=test&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();
            CheckError(_request, "blank unique id provided");
        }

        [TestMethod]
        public void Test21CreateCommentForumTest_WithoutUrl_CorrectError()
        {
            Console.WriteLine("Test21CreateCommentForumTest_WithoutUrl_CorrectError");
            var testUid = Guid.NewGuid().ToString();

            string requesturl = "CommentForumList?dnaaction=create&dnauid=" + testUid + @"&dnatitle=test&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();
            CheckError(_request, "No url provided");
        }

        [TestMethod]
        public void Test22CreateCommentForumTest_WithoutTitle_CorrectError()
        {
            Console.WriteLine("Test22CreateCommentForumTest_WithoutTitle_CorrectError");
            var testUid = Guid.NewGuid().ToString();

            string requesturl = "CommentForumList?dnaaction=create&dnauid=" + testUid + @"&dnahostpageurl=http://bbc.co.uk/&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();
            CheckError(_request, "No title provided");
        }


        [TestMethod]
        public void Test23AddTermCommentForumListTest()
        {
            Console.WriteLine("Test23AddTermCommentForumListTest");
            GetFirstUid();

            string term = "bum";
            string reason = "Testing bum";


            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                var sql = String.Format("delete from fastmodforums where FORUMID=" + _forumId);
                dataReader.ExecuteDEBUGONLY(sql);
                Assert.IsFalse(dataReader.HasRows);
            }

            string requesturl = "CommentForumList?action=UPDATETERMS&dnauid=" + _firstUid + "&dnafastmod=enabled&forumid=" + _forumId + "&termtext=" + term + "&reason=" + reason + "&action_forumid_all=Refer&skin=purexml";
            _request.RequestPage(requesturl);

            XmlDocument xml = _request.GetLastResponseAsXML();

            CheckEmailWasSent("Terms section updated for the forum, " + _defaultForumTitle + ".", "The Terms section of the forum");
            
            XmlNode node;

            node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@FORUMID='" + _forumId + "']");

            if (node != null)

            {
                node = xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@FORUMID='" + _forumId + "']/TERMS/TERMSLIST");
                if (node != null)
                {
                    Assert.AreEqual(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@FORUMID='" + _forumId + "']/TERMS/TERMSLIST/@FORUMID").Value, _forumId);
                    Assert.AreEqual(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@FORUMID='" + _forumId + "']/TERMS/TERMSLIST/TERMDETAILS/@TERM").Value, term);
                    Assert.AreNotEqual(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@FORUMID='" + _forumId + "']/TERMS/TERMSLIST/TERMDETAILS/@TERM").Value, "humbugsweet");
                    Assert.AreEqual(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@FORUMID='" + _forumId + "']/TERMS/TERMSLIST/TERMDETAILS/@ACTION").Value, "Refer");
                }
            }

        }

        [TestMethod]
        public void Test24CommentForumListTest_AddTermWithoutTerm_WithoutReason()
        {
            Console.WriteLine("Test24CommentForumListTest_AddTermWithoutTerm_WithoutReason");
            GetFirstUid();

            string term = string.Empty;
            string reason = "Testing bum";

            string requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnafastmod=enabled&forumid=" + _forumId + "&termtext=" + term + "&reason=" + reason + "&action_forumid_all=Refer&action=UPDATETERM&skin=purexml";
            try
            {
                _request.RequestPage(requesturl);
            }
            catch (Exception ex)
            {
                //Term text cannot be empty
                Assert.IsTrue(ex.Message.Contains("Assert.Fail failed."));
            }

            term = "bum";
            reason = string.Empty;

            requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnafastmod=enabled&forumid=" + _forumId + "&termtext=" + term + "&reason=" + reason + "&action_forumid_all=Refer&action=UPDATETERM&skin=purexml";

            try
            {
                _request.RequestPage(requesturl);
            }
            catch (Exception e)
            {
                //Reason cannot be empty
                Assert.IsTrue(e.Message.Contains("Assert.Fail failed."));
            }

            reason = "Re Testing bum";
            requesturl = "CommentForumList?dnaaction=update&dnauid=" + _firstUid + "&dnafastmod=enabled&forumid=0&termtext=" + term + "&reason=" + reason + "&action_forumid_all=Refer&action=UPDATETERM&skin=purexml";

            try
            {
                _request.RequestPage(requesturl);
            }
            catch (Exception ex1)
            {
                //ForumID cannot be 0
                Assert.IsTrue(ex1.Message.Contains("Assert.Fail failed."));
            }
        }

        /// <summary>
        /// Gets site id for thre given site.
        /// </summary>
        /// <param name="urlName"></param>
        /// <returns></returns>
        private int GetSiteIdForSite(String urlName)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("") )
            {
                reader.ExecuteDEBUGONLY("SELECT siteid from sites where urlname='" + urlName + "'");
                if ( reader.Read() )
                {
                    return reader.GetInt32("siteid");
                }
            }
            return 0;
        }

        private static void CheckError(DnaTestURLRequest _normalUserRequest, string errorMess)
        {
            XmlDocument xml = _normalUserRequest.GetLastResponseAsXML();
            XmlNode node;
            node = xml.SelectSingleNode("H2G2/ERROR/ERRORMESSAGE");
            Assert.IsTrue(node.InnerText.ToLower().Contains(errorMess.ToLower()), "Wrong Error - Wanted '" + errorMess + "', but got '" + node.InnerText);
        }

        private void SetAnonymousStatusForSite(int currentSiteId, bool setAnonymous)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                var anonymousStatus = string.Empty;

                if (setAnonymous)
                {
                    anonymousStatus = "1";
                }
                else
                {
                    anonymousStatus = "0";
                }

                var deleteSQL = string.Format(@"delete from siteoptions where siteid = {0} and name = 'AllowNotSignedInCommenting' and section = 'CommentForum'", currentSiteId);

                reader.ExecuteDEBUGONLY(deleteSQL);
                
                var sql = @"insert into SiteOptions(Section,SiteID,Name,Value,[Type],[Description])
                        values('CommentForum'," + currentSiteId + ",'AllowNotSignedInCommenting','" + anonymousStatus + "',1,'Whether comment forums can be used with non-signed in users.')";
                
                reader.ExecuteDEBUGONLY(sql);
            }
        }

        private void UpdateAnonymousPostingForCommentForum(int currentSiteId, int forumId)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {

                var updateSQL = string.Format(@"update commentforums set NotSignedInUserId = 0 where siteid = {0} and forumid = {1}", currentSiteId, forumId);

                reader.ExecuteDEBUGONLY(updateSQL);
            }
        }
    }
}
