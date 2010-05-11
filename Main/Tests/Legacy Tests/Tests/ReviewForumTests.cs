using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using TestUtils;


namespace Tests
{
    /// <summary>
    /// Tests for the Review Forum
    /// </summary>
    [TestClass]
    public class ReviewForumTests
    {
        private bool _setupRun = false;
        IInputContext _context = null;

        /// <summary>
        /// XML Schema
        /// </summary>
        private const string _schemaUri = "ReviewForum.xsd";

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("Setting up");


                string rootPath = TestConfig.GetConfig().GetRipleyServerPath();
                BBC.Dna.AppContext.OnDnaStartup(rootPath);

                ProfanityFilter.ClearTestData();

                //Create the mocked inputcontext
                Mockery mock = new Mockery();
                _context = DnaMockery.CreateDatabaseInputContext();

                // Create a mocked site for the context
                ISite mockedSite = DnaMockery.CreateMockedSite(_context, 1, "h2g2", "h2g2", true, "http://identity/policies/dna/adult");
                Stub.On(_context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));
                Stub.On(mockedSite).GetProperty("ModClassID").Will(Return.Value(1));

                Stub.On(_context).Method("FileCacheGetItem").Will(Return.Value(false));
                Stub.On(_context).Method("FileCachePutItem").Will(Return.Value(false));

                // Initialise the profanities object
                ProfanityFilter.InitialiseProfanitiesIfEmpty(DnaMockery.CreateDatabaseReaderCreator(), null);

                BBC.Dna.User user = new BBC.Dna.User(_context);
                Stub.On(_context).GetProperty("ViewingUser").Will(Return.Value(user));
                
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test the getting the Review Forum
        /// </summary>
        [TestMethod]
        public void Test01GetReviewForumTest()
        {
            Console.WriteLine("Before ReviewForumTests - GetReviewForumTest");

            ReviewForum reviewForum = new ReviewForum(_context);

            reviewForum.InitialiseViaReviewForumID(1, true);

            XmlElement xml = reviewForum.RootElement;

            Assert.IsTrue(xml.SelectSingleNode("REVIEWFORUM") != null, "The xml is not generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After ReviewForumTests - GetReviewForumTest");
        }

        /// <summary>
        /// Test the getting the Review Forum Thread list - Last posted order
        /// </summary>
        [TestMethod]
        public void Test02GetReviewForumThreadsLastPostedTest()
        {
            Console.WriteLine("Before Test02GetReviewForumThreadsLastPostedTest");
            PerformTest(ReviewForum.OrderBy.LASTPOSTED);
            Console.WriteLine("After Test02GetReviewForumThreadsLastPostedTest");
        }

        /// <summary>
        /// Test the getting the Review Forum Thread list - AUTHORID order
        /// </summary>
        [TestMethod]
        public void Test03GetReviewForumThreadsAuthorIDTest()
        {
            Console.WriteLine("Before Test03GetReviewForumThreadsAuthorIDTest");
            PerformTest(ReviewForum.OrderBy.LASTPOSTED);
            Console.WriteLine("After Test03GetReviewForumThreadsAuthorIDTest");
        }

        /// <summary>
        /// Test the getting the Review Forum Thread list - AUTHORNAME order
        /// </summary>
        [TestMethod]
        public void Test04GetReviewForumThreadsAUTHORNAMETest()
        {
            Console.WriteLine("Before Test04GetReviewForumThreadsAUTHORNAMETest");
            PerformTest(ReviewForum.OrderBy.AUTHORNAME);
            Console.WriteLine("After Test04GetReviewForumThreadsAUTHORNAMETest");
        }

        /// <summary>
        /// Test the getting the Review Forum Thread list - DATEENTERED order
        /// </summary>
        [TestMethod]
        public void Test05GetReviewForumThreadsDATEENTEREDTest()
        {
            Console.WriteLine("Before Test05GetReviewForumThreadsDATEENTEREDTest");
            PerformTest(ReviewForum.OrderBy.DATEENTERED);
            Console.WriteLine("After Test05GetReviewForumThreadsDATEENTEREDTest");
        }

        /// <summary>
        /// Test the getting the Review Forum Thread list - H2G2ID order
        /// </summary>
        [TestMethod]
        public void Test06GetReviewForumThreadsH2G2IDTest()
        {
            Console.WriteLine("Before Test06GetReviewForumThreadsH2G2IDTest");
            PerformTest(ReviewForum.OrderBy.H2G2ID);
            Console.WriteLine("After Test06GetReviewForumThreadsH2G2IDTest");
        }

        /// <summary>
        /// Test the getting the Review Forum Thread list - SUBJECT order
        /// </summary>
        [TestMethod]
        public void Test07GetReviewForumThreadsSUBJECTTest()
        {
            Console.WriteLine("Before Test07GetReviewForumThreadsSUBJECTTest");
            PerformTest(ReviewForum.OrderBy.SUBJECT);
            Console.WriteLine("After Test07GetReviewForumThreadsSUBJECTTest");
        }

        private void PerformTest(ReviewForum.OrderBy orderBy)
        {
            int forumID = SubmitArticleForReview();
            ReviewForum reviewForum = new ReviewForum(_context);

            reviewForum.InitialiseViaReviewForumID(1, true);

            reviewForum.GetReviewForumThreadList(20, 0, orderBy, false);

            XmlElement xml = reviewForum.RootElement;

            Assert.IsTrue(xml.SelectSingleNode("REVIEWFORUM/REVIEWFORUMTHREADS") != null, "The xml is not generated correctly!!!");
            
            Assert.IsTrue(xml.SelectSingleNode("REVIEWFORUM/REVIEWFORUMTHREADS[@ORDERBY='" + ((int) orderBy).ToString() +"']") != null, "The xml is not generated correctly - ORDER BY!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        private int SubmitArticleForReview()
        {
            int forumID = 0;

            TestDataCreator testData = new TestDataCreator(_context);
            forumID = testData.CreateAndSubmitArticleForReview();

            return forumID;
        }
    }
}
