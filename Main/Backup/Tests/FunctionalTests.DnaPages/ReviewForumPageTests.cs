using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


using TestUtils;

namespace FunctionalTests
{
    /// <summary>
    /// This class tests the ReviewForumPage Tests page
    /// </summary>
    [TestClass]
    public class ReviewForumPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2ReviewForumFlat.xsd";

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
                Console.WriteLine("Setting up");
                _request.UseEditorAuthentication = false;
                _request.SetCurrentUserSuperUser();
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test01GetReviewForumPage()
        {
            Console.WriteLine("Before ReviewForumPageTests - Test01GetReviewForumPage");

            SubmitArticleForReview();

            //request the page
            _request.SetCurrentUserSuperUser();
            _request.RequestPage("RF1?&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/REVIEWFORUM") != null, "ReviewForum tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/REVIEWFORUM/REVIEWFORUMTHREADS") != null, "ReviewForum Threads tag does not exist");

            Console.WriteLine("After Test01GetReviewForumPage");
        }

        private int SubmitArticleForReview()
        {
            int forumID = 0;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
 
            TestDataCreator testData = new TestDataCreator(context);
            forumID = testData.CreateAndSubmitArticleForReview();
            return forumID;
        }
        /// <summary>
        /// Test that the user page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test02ValidateReviewForumPage()
        {
            Console.WriteLine("Before Test02ValidateReviewForumPage");

            //request the page
            _request.SetCurrentUserSuperUser();
            _request.RequestPage("RF1?skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test02ValidateReviewForumPage");
        }
    }
}

