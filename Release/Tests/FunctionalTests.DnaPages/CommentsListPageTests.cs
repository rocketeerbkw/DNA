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
using BBC.Dna.Utils;
using BBC.Dna.Api;

namespace FunctionalTests
{
    /// <summary>
    /// Test utility class for CommentsListPageTests
    /// </summary>
    [TestClass]
    public class CommentsListPageTests
    {
        private int _forumId = 0;
        private int _siteId = 72;
        private bool _setupRun = false;
        private const string _schemaCommentsList = "Dna.Services\\commentsList.xsd";

        private DnaTestURLRequest _request = new DnaTestURLRequest("haveyoursay");

        public CommentsListPageTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

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
                GetCommentForumId();
            }
        }

        /// <summary>
        /// Use the Ajax test to create a commentforum for site 1 as a restore may blank it out
        /// </summary>
        private void MakeSureWeHaveACommentForum()
        {
            // Console.WriteLine("Before MakeSureWeHaveACommentForum");
            
            _request.RequestPage("acs?dnaaction=add&dnahostpageurl=http://www.bbc.co.uk/dna/something&dnauid=this is some unique id blah de blah blah2&dnainitialtitle=newtitle&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            //DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "CommentBox.xsd");
            //validator.Validate();
            Console.WriteLine("After MakeSureWeHaveACommentForum");
        }


        private void GetCommentForumId()
        {
            
            _request.RequestPage("CommentForumList?dnaskip=0&dnashow=20&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();

            int CommentForumListCount = 0;
            Int32.TryParse(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT").Value.ToString(), out CommentForumListCount);

            if (CommentForumListCount > 0)
            {
                var postCommentCount = 0;
                XmlNodeList nodeList = xml.SelectNodes("H2G2/COMMENTFORUMLIST/COMMENTFORUM");

                foreach (XmlNode node in nodeList)
                {
                    postCommentCount = Int32.Parse(node.Attributes["FORUMPOSTCOUNT"].Value);

                   if (postCommentCount > 0)
                   {
                       _forumId = Int32.Parse(node.Attributes["FORUMID"].Value);
                       _siteId = Int32.Parse(node.SelectSingleNode("SITEID").InnerText);

                       break;
                   }
                }
            }
            
        } 

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void TestCreateCommentsListPageTest()
        {
            Console.WriteLine("TestCreateCommentsListPageTest");
            _request.RequestPage("CommentsList?skin=purexml");
            
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
            
            Console.WriteLine("After TestCreateCommentsListPageTest");
        }

        /// <summary>
        /// Test we get a comment forum list page for the call. 
        /// </summary>
        [TestMethod]
        public void TestGetCommentsListPageTest()
        {
            Console.WriteLine("TestGetCommentsListPageTest");
            _request.RequestPage("CommentsList?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTSLIST") != null, "The comments list page has not been generated!!!");

            Console.WriteLine("After TestGetCommentsListPageTest");
        }
        

        /// <summary>
        /// Test we get the default information of comments for all sites. 
        /// </summary>
        [TestMethod]
        public void TestGetAllCommentsListTest()
        {
            Console.WriteLine("TestGetAllCommentsListTest");
            var requestUrl = "CommentsList?s_siteid=" + _siteId + "&s_forumid=" + _forumId + "&skin=purexml";
            _request.RequestPage(requestUrl);
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTSLIST") != null, "The comment forum list page has not been generated!!!");
            Assert.AreEqual(_forumId.ToString(), xml.SelectSingleNode("H2G2/COMMENTSLIST/@FORUMID").Value);

            Console.WriteLine("After TestGetAllCommentsListTest");
        }

        /// <summary>
        /// Validate the commentslist xml generated
        /// </summary>
        [TestMethod]
        public void TestValidateCommentsListPage()
        {
            Console.WriteLine("TestValidateCommentsListPage");

            int CommentsListCount = 0;

            var requestUrl = "CommentsList?s_siteid=" + _siteId + "&s_forumid=" + _forumId + "&skin=purexml";
            _request.RequestPage(requestUrl);
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTSLIST") != null, "The comment forum list page has not been generated!!!");

            int commentsCount = xml.SelectNodes("H2G2/COMMENTSLIST/COMMENTS/COMMENT").Count;
            Int32.TryParse(xml.SelectSingleNode("H2G2/COMMENTSLIST/TOTALCOUNT").InnerText, out CommentsListCount);

            if (commentsCount > 0)
            {
                Assert.AreEqual(CommentsListCount, commentsCount);
            }

            XmlNode node;
            node = xml.SelectSingleNode("H2G2/COMMENTSLIST/COMMENTS/COMMENT/USER");
            if (node != null)
            {
                var _isEditor = true;
                Assert.AreEqual(_isEditor.ToString().ToUpper(), xml.SelectSingleNode("H2G2/COMMENTSLIST/COMMENTS/COMMENT/USER/EDITOR").InnerText.ToUpper());
            }

            Console.WriteLine("After TestValidateCommentsListPage");
        }
    }
}
