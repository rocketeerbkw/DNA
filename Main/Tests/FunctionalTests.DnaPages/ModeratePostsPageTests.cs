﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using TestUtils;
using BBC.Dna.Moderation;
using BBC.Dna.Moderation.Utils;

namespace FunctionalTests
{
    [TestClass]
    public class ModeratePostsPageTests
    {
        /// <summary>
        /// Check Normal User Does not have access .
        /// </summary>
        [TestMethod]
        public void TestModeratePostsPageNonModerator()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModeratePosts?modclassid=1&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
        }

        /// <summary>
        /// Check the Xml Schema.
        /// </summary>
        [TestMethod]
        public void TestModeratePostsPageXml()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModeratePosts?modclassid=1&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "H2G2ModeratePosts.xsd");
            validator.Validate();
        }

        /// <summary>
        /// Check Moderation Email Queue
        /// </summary>
        [TestMethod]
        public void TestModerationEmailQueue()
        {
            var postId = 0;
            var modStatus = ModerationItemStatus.Failed;
            var threadId = 0;
            var threadModStatus = 3;
            var forumId = 0;
            var modId = 0;
            var siteId = 0;
            var notes = string.Empty;
            var moderatorEmail = "abc123xyz@bbc.co"; //change this to a proper email account for checking the dbmail's send status


            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("select siteId from sites where urlname = 'haveyoursay'");
                Assert.IsTrue(dataReader.Read());
                siteId = dataReader.GetInt32NullAsZero("siteId");

                dataReader.ExecuteDEBUGONLY("select MAX(ModID) AS ModId from threadmod where siteid = " + siteId + ")");
                Assert.IsTrue(dataReader.Read());

                modId = dataReader.GetInt32NullAsZero("ModId");

                dataReader.ExecuteDEBUGONLY("select * from threadmod where modid = " + modId);
                Assert.IsTrue(dataReader.Read());

                postId = dataReader.GetInt32NullAsZero("PostID");
                threadId = dataReader.GetInt32NullAsZero("ThreadID");
                forumId = dataReader.GetInt32NullAsZero("ForumID");
                notes = dataReader.GetStringNullAsEmpty("Notes");
            }

            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("update Sites set ModeratorsEmail = '" + moderatorEmail + "' where siteid = " + siteId + "");
            }

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            string url = "ModeratePosts?modclassid=1&postid=" + postId + "&threadid=" + threadId + "&modid=" + modId + "&siteid=" + siteId + "&decision=" + modStatus + "&threadModStatus=" + threadModStatus + "&skin=purexml";
            request.RequestPage(@"url");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("select * from EmailQueue where ToEmailAddress = '" + moderatorEmail + "'");
                Assert.IsTrue(dataReader.Read());
            }
        }

    }
}
