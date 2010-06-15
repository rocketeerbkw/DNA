using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Groups;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Users project
    /// </summary>
    [TestClass]
    public class ForumPageTests
    {
        /// <summary>
        /// Setup fixture
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.ForceRestore();
            //clean ripley cache
            CleanRiplyCache();
        }

        

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test01GetH2G2ForumAndValidateSchemas()
        {
            string siteName = "h2g2";
            GetAndValidateForumXml(siteName, 150);
            //test with c#
            GetAndValidateForumXml(siteName, 150,false);
        }
        
        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test02Get606ForumAndValidateSchemas()
        {
            string siteName = "606";
            GetAndValidateForumXml(siteName, 7619351, false);

            GetAndValidateForumXml(siteName, 7619351);
            //test with c#
            
        }


        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test03GetMBForumAndValidateSchemasUsingRipley()
        {
            string siteName = "mbiplayer";
            GetAndValidateForumXml(siteName, 7325075, true);
            //c#
            GetAndValidateForumXml(siteName, 7325075, false);
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test04GetH2G2ForumThreadAndValidateSchemas()
        {
            string siteName = "h2g2";
            GetAndValidateForumThreadXml(siteName, 150, 33, true);
            //test with c#
            GetAndValidateForumThreadXml(siteName, 150, 33, false);
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test05GetMBForumThreadAndValidateSchemas()
        {
            string siteName = "mbiplayer";
            GetAndValidateForumThreadXml(siteName, 7325075, 34, true);
            //test with c#
            GetAndValidateForumThreadXml(siteName, 7325075, 34, false);
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test06CloseOpenThreadUsingRipley()
        {
            CleanRiplyCache();
            string siteName = "mbiplayer";
            //CLOSETHREAD first
            
            
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("F7325075?cmd=closethread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0 in forumThreadPosts
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);//as editor I can write
            //check forumThreads object
            XmlNode forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='34']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("0", forumThreads.Attributes["CANWRITE"].Value);

            //request as logged out user
            request.SetCurrentUserNormal();
            request.RequestPage("F7325075?thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("0", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='34']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("0", forumThreads.Attributes["CANWRITE"].Value);

            CleanRiplyCache();
            //Reopen Thread
            //request as logged out user
            request.SetCurrentUserEditor();
            request.RequestPage("F7325075?cmd=reopenthread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='34']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("1", forumThreads.Attributes["CANWRITE"].Value);

            CleanRiplyCache();
            //check as not logged in user
            request.SetCurrentUserNormal();
            request.RequestPage("F7325075?thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='34']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("1", forumThreads.Attributes["CANWRITE"].Value);
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test07CloseOpenThreadUsingCSharp()
        {
            string siteName = "mbiplayer";
            //CLOSETHREAD first

            
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("NF7325075?cmd=closethread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0 in forumThreadPosts
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);//as editor I can write
            //check forumThreads object
            XmlNode forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='34']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("0", forumThreads.Attributes["CANWRITE"].Value);//as editor thread level permissions should remain

            //request as logged out user
            request.SetCurrentUserNormal();
            request.RequestPage("NF7325075?thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("0", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='34']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("0", forumThreads.Attributes["CANWRITE"].Value);

            //Reopen Thread
            //request as logged out user
            request.SetCurrentUserEditor();
            request.RequestPage("NF7325075?cmd=reopenthread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='34']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("1", forumThreads.Attributes["CANWRITE"].Value);

            //check as not logged in user
            request.SetCurrentUserNormal();
            request.RequestPage("NF7325075?thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='34']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("1", forumThreads.Attributes["CANWRITE"].Value);
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test08OpenCloseOpenThreadNotAuthorisedRipley()
        {
            string siteName = "mbiplayer";
                        
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("F7325075?cmd=closethread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //ValidateErrorSchema(request);//for some reason ripley doesn't return error- although C++ code writes one out.
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);//no change

            request.RequestPage("F7325075?cmd=reopenthread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //ValidateErrorSchema(request);

            
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test09OpenCloseOpenThreadNotAuthorisedCSharp()
        {
            string siteName = "mbiplayer";
            
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF7325075?thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            var defaultCanWrite = forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value;

            request.RequestPage("NF7325075?cmd=closethread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            ValidateErrorSchema(request);
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual(defaultCanWrite, forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);//no change

            request.RequestPage("NF7325075?cmd=reopenthread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            ValidateErrorSchema(request);


        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test10OpenCloseOpenThreadAsAuthorWithoutSiteOptionRipley()
        {
            string siteName = "h2g2";

            SignalAndWaitforSiteOptionToBeSet(siteName, 1, "Forum", "ArticleAuthorCanCloseThreads", 0);

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("F150?cmd=closethread&thread=33&skin=purexml&show=" + GetRandom().ToString());
            ValidateForumThreadSchema(request);
            //ValidateErrorSchema(request);//for some reason ripley doesn't return error- although C++ code writes one out.
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);//no change

            request.RequestPage("F7325075?cmd=reopenthread&thread=33&skin=purexml&show=" + GetRandom().ToString());
            ValidateForumThreadSchema(request);
            //ValidateErrorSchema(request);


        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test11OpenCloseOpenThreadAsAuthorWithoutSiteOptionCSharp()
        {
            string siteName = "h2g2";

            SignalAndWaitforSiteOptionToBeSet(siteName, 1, "Forum", "ArticleAuthorCanCloseThreads", 0);
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF150?cmd=closethread&thread=33&skin=purexml"); 
            ValidateForumThreadSchema(request);
            ValidateErrorSchema(request);
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);//no change

            request.RequestPage("NF7325075?cmd=reopenthread&thread=33&skin=purexml");
            ValidateForumThreadSchema(request);
            ValidateErrorSchema(request);


        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test12OpenCloseOpenThreadAsAuthorRipley()
        {
            string siteName = "h2g2";

            SignalAndWaitforSiteOptionToBeSet(siteName, 1, "Forum", "ArticleAuthorCanCloseThreads", 1);

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("F150?cmd=closethread&thread=33&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0 in forumThreadPosts
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("0", forumThreadPosts.Attributes["CANWRITE"].Value);//as author I can write
            //check forumThreads object
            XmlNode forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='33']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("0", forumThreads.Attributes["CANWRITE"].Value);

            //Reopen Thread
            //request as logged out user
            request.SetCurrentUserSuperUser();
            request.RequestPage("NF150?cmd=reopenthread&thread=33&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='33']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("1", forumThreads.Attributes["CANWRITE"].Value);

        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test13OpenCloseOpenThreadAsAuthorCSharp()
        {
            string siteName = "h2g2";

            SignalAndWaitforSiteOptionToBeSet(siteName, 1, "Forum", "ArticleAuthorCanCloseThreads", 1);

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF150?cmd=closethread&thread=33&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0 in forumThreadPosts
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("0", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            XmlNode forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='33']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("0", forumThreads.Attributes["CANWRITE"].Value);

            //Reopen Thread
            //request as logged out user
            request.SetCurrentUserSuperUser();
            request.RequestPage("NF150?cmd=reopenthread&thread=33&skin=purexml");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            //check that default can write on thread is 0
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);
            //check forumThreads object
            forumThreads = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/THREAD[@THREADID='33']");
            Assert.AreNotEqual(null, forumThreads);
            Assert.AreEqual("1", forumThreads.Attributes["CANWRITE"].Value);
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test14ChangePermissionsNotAuthorisedRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("F7325075?cmd=forumperm&thread=34&skin=purexml&read=1");
            ValidateForumThreadSchema(request);
            //ValidateErrorSchema(request);//for some reason ripley doesn't return error- although C++ code writes one out.
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);//no change
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test15ChangePermissionsNotAuthorisedCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF7325075?cmd=forumperm&thread=34&skin=purexml&read=1");
            ValidateForumThreadSchema(request);
            ValidateErrorSchema(request);
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);//no change
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test16ChangeForumPermissionsRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("F7325075?cmd=forumperm&thread=34&skin=purexml&read=0&write=0");
            ValidateForumThreadSchema(request);

            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            //editors right should be maintained
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANREAD"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);

            CleanRiplyCache();
            //reset
            request.RequestPage("F7325075?cmd=forumperm&thread=34&skin=purexml&read=1&write=1");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANREAD"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);

        }


        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test17ChangeForumPermissionsCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("NF7325075?cmd=forumperm&thread=34&skin=purexml&read=0&write=0");
            ValidateForumThreadSchema(request);

            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            //editors right should be maintained
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANREAD"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);

            //reset
            request.RequestPage("NF7325075?cmd=forumperm&thread=34&skin=purexml&read=1&write=1");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANWRITE"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANREAD"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["CANWRITE"].Value);
        }

        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test18ChangeForumThreadPermissionsRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("F7325075?cmd=forumperm&thread=34&skin=purexml&threadread=0&threadwrite=0");
            ValidateForumThreadSchema(request);

            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["THREADCANREAD"].Value);
            Assert.AreEqual("0", forumThreadPosts.Attributes["THREADCANWRITE"].Value);

            CleanRiplyCache();
            //reset
            request.RequestPage("F7325075?cmd=forumperm&thread=34&skin=purexml&threadread=1&threadwrite=1");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["THREADCANREAD"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["THREADCANWRITE"].Value);

        }


        /// <summary>
        
        /// </summary>
        [TestMethod]
        public void Test19ChangeForumThreadPermissionsCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("NF7325075?cmd=forumperm&thread=34&skin=purexml&threadread=0&threadwrite=0");
            ValidateForumThreadSchema(request);

            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThreadPosts);
            //editors right should be maintained
            Assert.AreEqual("0", forumThreadPosts.Attributes["THREADCANREAD"].Value);
            Assert.AreEqual("0", forumThreadPosts.Attributes["THREADCANWRITE"].Value);

            //reset
            request.RequestPage("NF7325075?cmd=forumperm&thread=34&skin=purexml&threadread=1&threadwrite=1");
            ValidateForumThreadSchema(request);
            //check for no errors
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["THREADCANREAD"].Value);
            Assert.AreEqual("1", forumThreadPosts.Attributes["THREADCANWRITE"].Value);
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test20ChangeModerationStatusNotAuthorisedRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("F7325075?cmd=updateforummoderationstatus&thread=34&skin=purexml&status=1");
            ValidateForumThreadSchema(request);
            //ValidateErrorSchema(request);//for some reason ripley doesn't return error- although C++ code writes one out.
            XmlNode moderationStatus = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/MODERATIONSTATUS");
            Assert.AreNotEqual(null, moderationStatus);
            Assert.AreEqual("0", moderationStatus.InnerText);//no change
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test21ChangeModerationStatusNotAuthorisedCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF7325075?thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            XmlNode moderationStatus = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/MODERATIONSTATUS");
            Assert.AreNotEqual(null, moderationStatus);
            var existingStatus = moderationStatus.InnerText;

            request.RequestPage("NF7325075?cmd=updateforummoderationstatus&thread=34&skin=purexml&status=1");
            ValidateForumThreadSchema(request);
            ValidateErrorSchema(request);
            moderationStatus = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/MODERATIONSTATUS");
            Assert.AreNotEqual(null, moderationStatus);
            Assert.AreEqual(existingStatus, moderationStatus.InnerText);//no change
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test22ChangeModerationStatusRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("F7325075?cmd=updateforummoderationstatus&thread=34&skin=purexml&status=1");

            ValidateForumThreadSchema(request);
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode moderationStatus = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/MODERATIONSTATUS");
            Assert.AreNotEqual(null, moderationStatus);
            Assert.AreEqual("1", moderationStatus.InnerText);

            //reset
            CleanRiplyCache();
            request.SetCurrentUserSuperUser();
            request.RequestPage("F7325075?cmd=updateforummoderationstatus&thread=34&skin=purexml&status=0");

            ValidateForumThreadSchema(request);
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            moderationStatus = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/MODERATIONSTATUS");
            Assert.AreNotEqual(null, moderationStatus);
            Assert.AreEqual("0", moderationStatus.InnerText);
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test23ChangeModerationStatusCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("NF7325075?cmd=updateforummoderationstatus&thread=34&skin=purexml&status=1");

            ValidateForumThreadSchema(request);
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode moderationStatus = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/MODERATIONSTATUS");
            Assert.AreNotEqual(null, moderationStatus);
            Assert.AreEqual("1", moderationStatus.InnerText);

            //reset
            request.SetCurrentUserSuperUser();
            request.RequestPage("NF7325075?cmd=updateforummoderationstatus&thread=34&skin=purexml&status=0");

            ValidateForumThreadSchema(request);
            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            moderationStatus = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS/MODERATIONSTATUS");
            Assert.AreNotEqual(null, moderationStatus);
            Assert.AreEqual("0", moderationStatus.InnerText);
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test24HideThreadNotAuthorisedRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("F7325075?cmd=hidethread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            //ValidateErrorSchema(request);//for some reason ripley doesn't return error- although C++ code writes one out.
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);//no change
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test25HideThreadNotAuthorisedCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF7325075?cmd=hidethread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            ValidateErrorSchema(request);

            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("1", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);//no change
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test26HideThreadAuthorisedRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserSuperUser();
            request.RequestPage("F7325075?cmd=hidethread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);

            //reset
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to set the Generate Hotlist flag
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("SetThreadVisibletoUsers"))
            {
                reader.AddParameter("threadid", 34);
                reader.AddParameter("forumid", 7325075);
                reader.AddParameter("Visible", true);
                reader.Execute();
            }
            
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test27HideThreadAuthorisedCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserSuperUser();
            request.RequestPage("NF7325075?cmd=hidethread&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode forumThreadPosts = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS");
            Assert.AreNotEqual(null, forumThreadPosts);
            Assert.AreEqual("0", forumThreadPosts.Attributes["DEFAULTCANREAD"].Value);

            //reset
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to set the Generate Hotlist flag
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("SetThreadVisibletoUsers"))
            {
                reader.AddParameter("threadid", 34);
                reader.AddParameter("forumid", 7325075);
                reader.AddParameter("Visible", true);
                reader.Execute();
            }

        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test28UpdateAlertInstantlyNotAuthorisedRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("F7325075?cmd=AlertInstantly&thread=34&skin=purexml&AlertInstantly=1");
            ValidateForumThreadSchema(request);
            //ValidateErrorSchema(request);//for some reason ripley doesn't return error- although C++ code writes one out.
            XmlNode forumThread = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThread);
            Assert.AreEqual("0", forumThread.Attributes["ALERTINSTANTLY"].Value);//no change
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test29UpdateAlertInstantlyNotAuthorisedCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            request.RequestPage("NF7325075?cmd=AlertInstantly&thread=34&skin=purexml&AlertInstantly=1");
            ValidateForumThreadSchema(request);
            ValidateErrorSchema(request);//for some reason ripley doesn't return error- although C++ code writes one out.
            XmlNode forumThread = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThread);
            Assert.AreEqual("0", forumThread.Attributes["ALERTINSTANTLY"].Value);//no change
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test30UpdateAlertInstantlyRipley()
        {
            CleanRiplyCache();
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            //add random page size as this is not a cached field
            request.RequestPage("F7325075?cmd=AlertInstantly&thread=34&skin=purexml&AlertInstantly=1&show=" + GetRandom().ToString());
            ValidateForumThreadSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode forumThread = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThread);
            Assert.AreEqual("1", forumThread.Attributes["ALERTINSTANTLY"].Value, "This should work but may be affected by ripley cache!");

            //reset
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();
            //reset via db - dont bother doing request
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("UpdateForumAlertInstantly"))
            {
                reader.AddParameter("forumid", 7325075);
                reader.AddParameter("alert", 0);
                reader.Execute();
            }
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test31UpdateAlertInstantlyCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            //add random page size as this is not a cached field
            request.RequestPage("NF7325075?cmd=AlertInstantly&thread=34&skin=purexml&AlertInstantly=1&show=" + GetRandom().ToString());
            ValidateForumThreadSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode forumThread = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADS");
            Assert.AreNotEqual(null, forumThread);
            Assert.AreEqual("1", forumThread.Attributes["ALERTINSTANTLY"].Value);

            //reset
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();
            //reset via db - dont bother doing request
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("UpdateForumAlertInstantly"))
            {
                reader.AddParameter("forumid", 7325075);
                reader.AddParameter("alert", 0);
                reader.Execute();
            }
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test32SubscribeThreadRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("F7325075?cmd=subscribethread&thread=34&skin=purexml&type=fth&show=" + GetRandom().ToString());
            //ValidateForumThreadSchema(request); //ignore schema as it is different for this type
            ValidateSubscribeResultSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode subscribeState = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-STATE");
            Assert.AreNotEqual(null, subscribeState);
            Assert.AreEqual("1", subscribeState.Attributes["THREAD"].Value, "This should work but may be affected by ripley cache!");

            XmlNode subscribeResult = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-RESULT");
            Assert.AreNotEqual(null, subscribeResult);
            Assert.AreEqual("34", subscribeResult.Attributes["TOTHREAD"].Value);
            Assert.AreEqual(null, subscribeResult.Attributes["FAILED"]);


            //unsub
            request.RequestPage("F7325075?cmd=unsubscribethread&thread=34&skin=purexml&type=fth&show=" + GetRandom().ToString());
            //ValidateForumThreadSchema(request);
            ValidateSubscribeResultSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            subscribeState = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-STATE");
            Assert.AreNotEqual(null, subscribeState);
            Assert.AreEqual("0", subscribeState.Attributes["THREAD"].Value);

            subscribeResult = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-RESULT");
            Assert.AreNotEqual(null, subscribeResult);
            Assert.AreEqual("34", subscribeResult.Attributes["FROMTHREAD"].Value);
            Assert.AreEqual(null, subscribeResult.Attributes["FAILED"]);

        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test33SubscribeThreadCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("NF7325075?cmd=subscribethread&thread=34&skin=purexml&show=" + GetRandom().ToString());
            ValidateForumThreadSchema(request); 
            ValidateSubscribeResultSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode subscribeState = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-STATE");
            Assert.AreNotEqual(null, subscribeState);
            Assert.AreEqual("1", subscribeState.Attributes["THREAD"].Value, "This should work but may be affected by ripley cache!");

            XmlNode subscribeResult = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-RESULT");
            Assert.AreNotEqual(null, subscribeResult);
            Assert.AreEqual("34", subscribeResult.Attributes["TOTHREAD"].Value);
            Assert.AreEqual(null, subscribeResult.Attributes["FAILED"]);


            //unsub
            request.RequestPage("NF7325075?cmd=unsubscribethread&thread=34&skin=purexml&show=" + GetRandom().ToString());
            ValidateForumThreadSchema(request);
            ValidateSubscribeResultSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            subscribeState = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-STATE");
            Assert.AreNotEqual(null, subscribeState);
            Assert.AreEqual("0", subscribeState.Attributes["THREAD"].Value);

            subscribeResult = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-RESULT");
            Assert.AreNotEqual(null, subscribeResult);
            Assert.AreEqual("34", subscribeResult.Attributes["FROMTHREAD"].Value);
            Assert.AreEqual(null, subscribeResult.Attributes["FAILED"]);

        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test34SubscribeForumRipley()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("F7325075?cmd=subscribeforum&thread=34&skin=purexml&type=fth");
            //ValidateForumThreadSchema(request); //ignore schema as it is different for this type
            ValidateSubscribeResultSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode subscribeState = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-STATE");
            Assert.AreNotEqual(null, subscribeState);
            Assert.AreEqual("1", subscribeState.Attributes["FORUM"].Value, "This should work but may be affected by ripley cache!");

            XmlNode subscribeResult = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-RESULT");
            Assert.AreNotEqual(null, subscribeResult);
            Assert.AreEqual("7325075", subscribeResult.Attributes["TOFORUM"].Value);
            Assert.AreEqual(null, subscribeResult.Attributes["FAILED"]);


            //unsub
            request.RequestPage("F7325075?cmd=unsubscribeforum&thread=34&skin=purexml&type=fth");
            //ValidateForumThreadSchema(request);
            ValidateSubscribeResultSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            subscribeState = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-STATE");
            Assert.AreNotEqual(null, subscribeState);
            Assert.AreEqual("0", subscribeState.Attributes["FORUM"].Value);

            subscribeResult = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-RESULT");
            Assert.AreNotEqual(null, subscribeResult);
            Assert.AreEqual("7325075", subscribeResult.Attributes["FROMFORUM"].Value);
            Assert.AreEqual(null, subscribeResult.Attributes["FAILED"]);

        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test35SubscribeForumCSharp()
        {
            string siteName = "mbiplayer";

            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("NF7325075?cmd=subscribeforum&thread=34&skin=purexml");
            ValidateForumThreadSchema(request); 
            ValidateSubscribeResultSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            XmlNode subscribeState = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-STATE");
            Assert.AreNotEqual(null, subscribeState);
            Assert.AreEqual("1", subscribeState.Attributes["FORUM"].Value, "This should work but may be affected by ripley cache!");

            XmlNode subscribeResult = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-RESULT");
            Assert.AreNotEqual(null, subscribeResult);
            Assert.AreEqual("7325075", subscribeResult.Attributes["TOFORUM"].Value);
            Assert.AreEqual(null, subscribeResult.Attributes["FAILED"]);


            //unsub
            request.RequestPage("NF7325075?cmd=unsubscribeforum&thread=34&skin=purexml");
            ValidateForumThreadSchema(request);
            ValidateSubscribeResultSchema(request);

            Assert.AreEqual(null, request.GetLastResponseAsXML().SelectSingleNode("//H2G2/ERROR"));
            subscribeState = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-STATE");
            Assert.AreNotEqual(null, subscribeState);
            Assert.AreEqual("0", subscribeState.Attributes["FORUM"].Value);

            subscribeResult = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/SUBSCRIBE-RESULT");
            Assert.AreNotEqual(null, subscribeResult);
            Assert.AreEqual("7325075", subscribeResult.Attributes["FROMFORUM"].Value);
            Assert.AreEqual(null, subscribeResult.Attributes["FAILED"]);

        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test36GetH2G2ForumAndValidateSmileyRelacement()
        {
            string siteName = "h2g2";
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("NF150?thread=33&skin=purexml");
            ValidateForumThreadSchema(request);
            

            //check post has smiley translated
            XmlNode textNode = request.GetLastResponseAsXML().SelectSingleNode("//H2G2/FORUMTHREADPOSTS/POST/TEXT");
            Assert.IsNotNull(textNode);
            Assert.IsTrue(textNode.InnerXml.IndexOf("<SMILEY TYPE=\"kiss\" H2G2=\"Smiley#kiss\" />") >= 0);
        }

        /// <summary>

        /// </summary>
        [TestMethod]
        public void Test37GetSameForumManyTimes()
        {
            var siteName = "mbiplayer";
            var testPost = @"this post contains newlines
links: http://www.bbc.co.uk and other stuff";
            var expectedString = "this post contains newlines<BR />links: <LINK HREF=\"http://www.bbc.co.uk\">http://www.bbc.co.uk</LINK> and other stuff";


            PostToForum(34, 61, 7325075, testPost, siteName);

            var request = new DnaTestURLRequest(siteName);
            for (int i = 0; i < 10; i++)
            {
                request.RequestPage("NF7325075" + "?skin=purexml");
                XmlDocument doc = request.GetLastResponseAsXML();

                var lastPost = doc.SelectSingleNode("//H2G2/FORUMTHREADS/THREAD/LASTPOST/TEXT");
                Assert.IsNotNull(lastPost);
                Assert.AreEqual(expectedString, lastPost.InnerXml);
            }

        }

        [TestMethod]
        public void Test38ForumPageInPreviewMode()
        {

            var siteConfig = "<SITECONFIG><TEST>OK</TEST></SITECONFIG>";
            var siteId = 70;
            var siteName = "mbiplayer";
            using (IDnaDataReader dataReader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY(String.Format("insert into previewconfig (siteid, config, editkey) values ({0},'{1}','{2}')", siteId, siteConfig, Guid.NewGuid().ToString()));
            }


            var request = new DnaTestURLRequest(siteName);
            request.RequestPage("NF7325075" + "?skin=purexml&_previewmode=1");

            var xml = request.GetLastResponseAsXML();

            Assert.AreEqual("OK", xml.SelectSingleNode("//H2G2/SITECONFIG/TEST").InnerText);
            var topicXml = xml.SelectSingleNode("//H2G2/TOPICLIST");
            Assert.IsNotNull(topicXml);
            Assert.AreEqual("PREVIEW", topicXml.Attributes["STATUS"].Value);
            
            
        }

        [TestMethod]
        public void Test39ForumPageForumNotFound()
        {

            var siteName = "mbiplayer";
            var forumId = Int32.MaxValue - 1;

            var request = new DnaTestURLRequest(siteName);
            request.RequestPage(string.Format("NF{0}?skin=purexml", forumId));

            var xml = request.GetLastResponseAsXML();

            var errorXml = xml.SelectSingleNode("//H2G2/ERROR");
            Assert.IsNotNull(errorXml);
            Assert.AreEqual("ForumNotFound", errorXml.Attributes["TYPE"].Value);

        }



        #region Private helper functions

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteName"></param>
        /// <param name="forum"></param>
        private void GetAndValidateForumXml(string siteName, int forum)
        {
            GetAndValidateForumXml(siteName, forum, true);
        }

        /// <summary>
        /// Gets the xml for an article page and validates it against the schema
        /// </summary>
        /// <param name="siteName"></param>
        /// <param name="article"></param>
        private void GetAndValidateForumXml(string siteName, int forum, bool useRipley)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            if (useRipley)
            {
                request.RequestPage("F" + forum.ToString() + "?skin=purexml");
            }
            else
            {
                request.RequestPage("NF" + forum.ToString() + "?skin=purexml");
            }

            ValidateForumSchema(siteName, request);

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteName"></param>
        /// <param name="request"></param>
        public void ValidateForumSchema(string siteName, DnaTestURLRequest request)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(request.GetLastResponseAsString());


            string xml = doc.DocumentElement.SelectSingleNode("FORUMSOURCE").OuterXml;
            DnaXmlValidator validator = new DnaXmlValidator(Entities.GetEntities() + xml, "ForumSource.xsd");
            validator.Validate();

            bool requireElement = false;
            if (doc.DocumentElement.SelectSingleNode("FORUMTHREADS") != null)
            {
                xml = doc.DocumentElement.SelectSingleNode("FORUMTHREADS").OuterXml;
                validator = new DnaXmlValidator(Entities.GetEntities() + xml, "ForumThreads.xsd");
                validator.Validate();
                requireElement = true;
            }

            if (doc.DocumentElement.SelectSingleNode("FORUMTHREADPOSTS") != null)
            {
                xml = doc.DocumentElement.SelectSingleNode("FORUMTHREADPOSTS").OuterXml;
                validator = new DnaXmlValidator(Entities.GetEntities() + xml, "Thread.xsd");
                validator.Validate();
                requireElement = true;
            }
            Assert.AreEqual(true, requireElement, "FORUMTHREADPOSTS or FORUMTHREADS must be available");

            /* broken for an unknown reason
            if (siteName == "606")
            {
                validator = new DnaXmlValidator(Entities.GetEntities() + doc.DocumentElement.OuterXml, "H2G2ForumFlat606Site.xsd");
            }
            else
            {
                validator = new DnaXmlValidator(Entities.GetEntities() + doc.DocumentElement.OuterXml, "H2G2ForumFlat.xsd");
            }
            validator.Validate();
             */

            Assert.AreNotEqual(null, doc.SelectSingleNode("H2G2[@TYPE='THREADS']"));
        }

        /// <summary>
        /// Gets the xml for an article page and validates it against the schema
        /// </summary>
        /// <param name="siteName"></param>
        /// <param name="article"></param>
        private void GetAndValidateForumThreadXml(string siteName, int forum, int threadid, bool useRipley)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            if (useRipley)
            {
                request.RequestPage("F" + forum.ToString() + "?thread=" + threadid + "&skin=purexml");
            }
            else
            {
                request.RequestPage("NF" + forum.ToString() + "?thread=" + threadid + "&skin=purexml");
            }

            ValidateForumThreadSchema(request);

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        public void ValidateForumThreadSchema(DnaTestURLRequest request)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(request.GetLastResponseAsString());


            string xml = doc.DocumentElement.SelectSingleNode("FORUMSOURCE").OuterXml;
            DnaXmlValidator validator = new DnaXmlValidator(Entities.GetEntities() + xml, "ForumSource.xsd");
            validator.Validate();


            xml = doc.DocumentElement.SelectSingleNode("FORUMTHREADS").OuterXml;
            validator = new DnaXmlValidator(Entities.GetEntities() + xml, "ForumThreads.xsd");
            validator.Validate();


            xml = doc.DocumentElement.SelectSingleNode("FORUMTHREADPOSTS").OuterXml;
            validator = new DnaXmlValidator(Entities.GetEntities() + xml, "Thread.xsd");
            validator.Validate();

            xml = doc.DocumentElement.SelectSingleNode("ONLINEUSERS").OuterXml;
            validator = new DnaXmlValidator(Entities.GetEntities() + xml, "OnlineUsers.xsd");
            validator.Validate();


            Assert.AreNotEqual(null, doc.SelectSingleNode("H2G2[@TYPE='MULTIPOSTS']"));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        private void ValidateErrorSchema(DnaTestURLRequest request)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(request.GetLastResponseAsString());


            string xml = doc.DocumentElement.SelectSingleNode("ERROR").OuterXml;
            DnaXmlValidator validator = new DnaXmlValidator(Entities.GetEntities() + xml, "error.xsd");
            validator.Validate();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        private void ValidateSubscribeResultSchema(DnaTestURLRequest request)
        {
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(request.GetLastResponseAsString());


            string xml = doc.DocumentElement.SelectSingleNode("SUBSCRIBE-RESULT").OuterXml;
            DnaXmlValidator validator = new DnaXmlValidator(Entities.GetEntities() + xml, "subscriberesult.xsd");
            validator.Validate();
        }

        /// <summary>
        /// Helper method that signals for a siteoption to be changed then waits for that site to receive and process the signal
        /// </summary>
        /// <param name="siteid">The site id</param>
        /// <param name="section">The site option section</param>
        /// <param name="siteoption">The site option name</param>
        /// <param name="value">The value for the site option</param>
        private static void SignalAndWaitforSiteOptionToBeSet(string siteName, int siteid, string section, string name, int value)
        {
            // Create a context that will provide us with real data reader support
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to set the Generate Hotlist flag
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("setsiteoption"))
            {
                reader.AddParameter("SiteID", siteid);
                reader.AddParameter("Section", section);
                reader.AddParameter("Name", name);
                reader.AddParameter("Value", value);
                reader.Execute();
            }

            using (FullInputContext inputContext = new FullInputContext(true))
            {//send signal
                inputContext.SendSignal("action=recache-site");
            }
        }

        /// <summary>
        /// returns a random number to ensure cache is violated  -ripley
        /// </summary>
        /// <returns></returns>
        private int GetRandom()
        {
            Random ran = new Random();
            return ran.Next(0, 10000);
        }

        private void CleanRiplyCache()
        {
            string cachePath = string.Empty;
            using (FullInputContext inputContext = new FullInputContext(true))
            {//send signal
                cachePath = inputContext.DnaConfig.CachePath;
            }
            if (cachePath != string.Empty)
            {
                DirectoryInfo directoryInfo = new DirectoryInfo(cachePath);

                foreach (DirectoryInfo dir in directoryInfo.GetDirectories())
                {
                    try
                    {
                        dir.Delete(true);
                    }
                    catch{}
                }
            }

        }

        private XmlDocument PostToForum(int _threadId, int _inReplyTo, int _forumId, string body, string _siteName)
        {
            var url = String.Format("AddThread?skin=purexml");

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("threadid", _threadId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("inreplyto", _inReplyTo.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("dnapoststyle", "1"));
            postParams.Enqueue(new KeyValuePair<string, string>("forum", _forumId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("subject", "test post"));
            postParams.Enqueue(new KeyValuePair<string, string>("body", body));
            postParams.Enqueue(new KeyValuePair<string, string>("post", "Post message"));
            request.RequestPage(url, postParams);
            return request.GetLastResponseAsXML();
        }
        #endregion
    }
}
