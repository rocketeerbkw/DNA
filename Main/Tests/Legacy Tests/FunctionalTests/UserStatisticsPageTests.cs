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
    /// This class tests the User Statistics page showing the users last posts
    /// </summary>
    [TestClass]
    public class UserStatisticsPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2UserStatisticsFlat.xsd";

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
        public void Test01GetUserStatisticsPage()
        {
            Console.WriteLine("Before UserStatisticsPageTests - Test01GetUserStatisticsPage");
            
            // now get the response
            _request.RequestPage("US" + _request.CurrentUserID + "&skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERSTATISTICS") != null, "User Statistics tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERSTATISTICS/USER[USERID=1090558353]") != null, "User tag is not correct-" + xml.SelectSingleNode("/H2G2/USERSTATISTICS/USER/USERID").Value);

            Console.WriteLine("After Test01GetUserStatisticsPage");
        }

        /// <summary>
        /// Test that we can get
        /// </summary>
        [TestMethod]
        public void Test02PostAndCheckUserStatisticsPage()
        {
            Console.WriteLine("Before Test02PostAndCheckUserStatisticsPage");

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://local.bbc.co.uk/dna/haveyoursay/acs";
            string url = "acs?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            _request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Now check to make sure we can post to the comment box
            _request.RequestPage("acs?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah&dnahostpageurl=" + hosturl + "&skin=purexml");

            // Check to make sure that the page returned with the correct information
            xml = _request.GetLastResponseAsXML();
            
            
            // now get the response
            _request.RequestPage("US" + _request.CurrentUserID + "&skin=purexml");

            // Check to make sure that the page returned with the correct information
            xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERSTATISTICS") != null, "User Statistics tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERSTATISTICS/USER[USERID=1090558353]") != null, "User tag is not correct-" + xml.SelectSingleNode("/H2G2/USERSTATISTICS/USER/USERID").Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERSTATISTICS/FORUM[SUBJECT='TestingCommentBox']") != null, "Subject is not correct-" + xml.SelectSingleNode("/H2G2/USERSTATISTICS/FORUM/SUBJECT").Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERSTATISTICS/FORUM/THREAD/POST[BODY='blahblahblah']") != null, "User's post in incorrect-" + xml.SelectSingleNode("/H2G2/USERSTATISTICS/FORUM/THREAD/POST/BODY").Value);

            Console.WriteLine("After Test02PostAndCheckUserStatisticsPage");
        }

        /// <summary>
        /// Test that the user statistics page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test03ValidateUserStatisticsPage()
        {
            Console.WriteLine("Before Test03ValidateUserStatisticsPage");

            // now get the response
            _request.RequestPage("US" + _request.CurrentUserID + "&skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test03ValidateUserStatisticsPage");
        }

    }
}
