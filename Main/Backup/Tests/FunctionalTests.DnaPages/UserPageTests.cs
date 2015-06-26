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
    public class UserPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2UserPageFlat.xsd";

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
                _request.SetCurrentUserNormal();
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test that we can get user page
        /// </summary>
        [Ignore]//coded for c# version which is not used in filter.reg
        public void Test01GetUserPage()
        {
            Console.WriteLine("Before UserPageTests - Test01GetUserPage");

            //request the page
            _request.RequestPage("U" + _request.CurrentUserID + "&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERPAGE") != null, "User page tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERPAGE/USER[USERID=1090558353]") != null, "User tag is not correct-" + xml.SelectSingleNode("/H2G2/USERSTATISTICS/USER/USERID").Value);

            Console.WriteLine("After Test01GetUserPage");
        }
        /// <summary>
        /// Test that the user page is XSLT compliant
        /// </summary>
        [Ignore]//coded for c# version which is not used in filter.reg
        public void Test02ValidateUserPage()
        {
            Console.WriteLine("Before Test02ValidateUserPage");

            //request the page
            _request.RequestPage("U" + _request.CurrentUserID + "&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test02ValidateUserPage");
        }
    }
}