using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

using TestUtils;

namespace FunctionalTests
{
    /// <summary>
    /// This class tests the ProcessRecommendation page processing the recommendations for a scout
    /// </summary>
    [TestClass]
    public class ProcessRecommendationPageTests
    {
        private bool _setupRun = false;
        private int[] _recommendationIds = new int[1];

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2ProcessRecommendationFlat.xsd";

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

                SetupRecommendations();

                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }
        /// <summary>
        /// Test that we can get the process recommendation page and get a blank form
        /// </summary>
        [TestMethod]
        public void Test01GetProcessRecommendationPage()
        {
            Console.WriteLine("Before ProcessRecommendationPageTests - Test01GetProcessRecommendationPage");
            
            // now get the response with no params should return blank form
            _request.RequestPage("ProcessRecommendation?skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/PROCESS-RECOMMENDATION-FORM") != null, "PROCESS-RECOMMENDATION-FORM tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/PROCESS-RECOMMENDATION-FORM/FUNCTIONS") != null, "FUNCTIONS tag does not exist!");
            Console.WriteLine("After Test01GetProcessRecommendationPage");
        }

        /// <summary>
        /// Test that we can get the process recommendation page with a recommendation ID
        /// </summary>
        [TestMethod]
        public void Test02GetProcessRecommendationWithIDPage()
        {
            Console.WriteLine("Before Test02GetProcessRecommendationWithIDPage");

            int firstRecommendationID = _recommendationIds[0];

            // now get the response with no params should return blank form
            _request.RequestPage("ProcessRecommendation?recommendationID=" + firstRecommendationID.ToString() + "&skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/PROCESS-RECOMMENDATION-FORM") != null, "PROCESS-RECOMMENDATION-FORM tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/PROCESS-RECOMMENDATION-FORM/FUNCTIONS") != null, "FUNCTIONS tag does not exist!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test02GetProcessRecommendationWithIDPage");
        }

        private void SetupRecommendations()
        {
            //create a dummy articles
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            ISite siteContext = DnaMockery.CreateMockedSite(context, 1, "", "h2g2", true, "comment");
            TestDataCreator testData = new TestDataCreator(context);
            int[] entryIDs = new int[1];
            int[] h2g2IDs = new int[1];
            Assert.IsTrue(testData.CreateEntries(siteContext.SiteID, _request.CurrentUserID, 3001, 3, ref entryIDs, ref h2g2IDs), "Articles not created");

            Assert.IsTrue(testData.CreateRecommendations(_request.CurrentUserID, entryIDs, ref _recommendationIds), "Recommendation not created");
        }

    }
}
