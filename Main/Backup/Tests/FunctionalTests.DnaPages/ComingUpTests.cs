using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// This class tests the ComingUp Tests page showing the articles coming up
    /// </summary>
    [TestClass]
    public class ComingUpTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2ComingUpFlat.xsd";

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
                _request.UseEditorAuthentication = false;
                _request.SetCurrentUserNormal();
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test01GetComingUpPage()
        {
            Console.WriteLine("Before ComingUpTests - Test01GetComingUpPage");

            SetupScoutRecommendation();

            //request the page
            _request.RequestPage("ComingUp?&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/RECOMMENDATIONS") != null, "Recommendations tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/RECOMMENDATIONS/RECOMMENDATION") != null, "Recommendations Recommendation tag does not exist");

            Console.WriteLine("After Test01GetComingUpPage");
        }
        /// <summary>
        /// Test that the user page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test02ValidateComingUpPage()
        {
            Console.WriteLine("Before Test02ValidateComingUpPage");

            //request the page
            _request.RequestPage("ComingUp?skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test02ValidateComingUpPage");
        }


        private void SetupScoutRecommendation()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {                
                reader.ExecuteDEBUGONLY("exec storescoutrecommendation 2106165, 6, 'Test scout recommendation'");
                int recommendationID = 0;
                if (reader.Read())
                {
                    recommendationID = reader.GetInt32NullAsZero("RecommendationID");
                }

                reader.ExecuteDEBUGONLY("exec acceptscoutrecommendation " + recommendationID.ToString() + ", 6, 'Test recommendation'");
            }
        }

    }
}