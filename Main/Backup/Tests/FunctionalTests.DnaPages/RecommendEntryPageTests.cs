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
    /// This class tests the RecommendEntryPage Tests page
    /// </summary>
    [TestClass]
    public class RecommendEntryPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2RecommendEntryFlat.xsd";

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
                _request.UseEditorAuthentication = true;
                _request.SetCurrentUserEditor();
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test that we can get to Recommend Entry page view
        /// </summary>
        [TestMethod]
        public void Test01GetRecommendEntryPage()
        {
            Console.WriteLine("Before RecommendEntryPageTests - Test01GetRecommendEntryPage");

            int h2g2ID = CreateArticle();

            //request the page
            _request.RequestPage("RecommendEntry?h2g2id=" + h2g2ID + "&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/RECOMMEND-ENTRY-FORM") != null, "Recommend Entry Form tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/RECOMMEND-ENTRY-FORM[H2G2ID='" + h2g2ID.ToString() + "']") != null, "Recommend Entry h2g2id form tag does not exist");

            Console.WriteLine("After Test01GetRecommendEntryPage");
        }

        private int CreateArticle()
        {
            int h2g2ID = 0;
            int entryID = 0;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            TestDataCreator testData = new TestDataCreator(context);
            testData.CreateEntry(1, 1090558353, 3001, 3, ref entryID, ref h2g2ID);
            return h2g2ID;
        }
    }
}