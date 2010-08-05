using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// This class tests the ScoutRecommendations page showing the the recommendations for a scout
    /// </summary>
    [TestClass]
    public class ScoutRecommendationsPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2ScoutRecommendationsFlat.xsd";

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
        /// Test that we can get user statistics page
        /// </summary>
        [TestMethod]
        public void Test01GetScoutRecommendationsPage()
        {
            Console.WriteLine("Before ScoutRecommendationsPageTests - Test01GetScoutRecommendationsPage");
            
            // now get the response
            _request.RequestPage("ScoutRecommendations?skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/UNDECIDED-RECOMMENDATIONS") != null, "UNDECIDED-RECOMMENDATIONS tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/UNDECIDED-RECOMMENDATIONS/ARTICLE-LIST") != null, "ARTICLE-LIST tag does not exist!");
            Console.WriteLine("After Test01GetScoutRecommendationsPage");
        }
    }
}
