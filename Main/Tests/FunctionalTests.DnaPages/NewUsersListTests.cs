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
    /// This class tests the User Statistics page showing the users last posts
    /// </summary>
    [TestClass]
    public class NewUsersListTests
    {

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "NewUsers-List.xsd";

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            ISite siteContext = DnaMockery.CreateMockedSite(context, 1, "", "h2g2", true, "comment");
            TestDataCreator testData = new TestDataCreator(context);

            int[] userIDs = new int[10];
            Assert.IsTrue(testData.CreateNewUsers(siteContext.SiteID, ref userIDs), "Test users not created");
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test that we can get user page
        /// </summary>
        [TestMethod]
        public void Test01GetDefaultUserList()
        {
            Console.WriteLine("Before UserPageTests - Test01GetDefaultUserList");

            //request the page
            _request.RequestPage("NewUsers?skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            XmlNode xmlSub = xml.SelectSingleNode("/H2G2/NEWUSERS-LISTING");
            Assert.IsTrue(xmlSub != null, "User list does not exist!");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, _schemaUri);
            validator.Validate();
            Console.WriteLine("After Test01GetDefaultUserList");
        }

        /// <summary>
        /// Test that we can get user page
        /// </summary>
        [TestMethod]
        public void Test02GetUserListWithoutFilter()
        {
            Console.WriteLine("Before Test02GetUserListWithoutFilter");

            //request the page
            _request.RequestPage("NewUsers?TimeUnits=10&UnitType=month&Filter=off&thissite=1&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            XmlNode xmlSub = xml.SelectSingleNode("/H2G2/NEWUSERS-LISTING");
            Assert.IsTrue(xmlSub != null, "User list does not exist!");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, _schemaUri);
            validator.Validate();
            Console.WriteLine("After Test02GetUserListWithoutFilter");
        }

        /// <summary>
        /// Test that we can get user page
        /// </summary>
        [TestMethod]
        public void Test03GetUserListWithFilter()
        {
            Console.WriteLine("Before Test03GetUserListWithFilter");

            //request the page
            _request.RequestPage("NewUsers?TimeUnits=10&UnitType=month&Filter=noposting&thissite=1&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            XmlNode xmlSub = xml.SelectSingleNode("/H2G2/NEWUSERS-LISTING");
            Assert.IsTrue(xmlSub != null, "User list does not exist!");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, _schemaUri);
            validator.Validate();
            Console.WriteLine("After Test03GetUserListWithFilter");
        }

        /// <summary>
        /// Test that we can get user page
        /// </summary>
        [TestMethod]
        public void Test04GetUserListWithWhoupdatedpersonalspaceFilter()
        {
            Console.WriteLine("Before Test04GetUserListWithWhoupdatedpersonalspaceFilter");

            //request the page
            _request.RequestPage("NewUsers?TimeUnits=10&UnitType=month&Filter=noposting&Whoupdatedpersonalspace=1&thissite=1&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            XmlNode xmlSub = xml.SelectSingleNode("/H2G2/NEWUSERS-LISTING");
            Assert.IsTrue(xmlSub != null, "User list does not exist!");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, _schemaUri);
            validator.Validate();
            Console.WriteLine("After Test04GetUserListWithWhoupdatedpersonalspaceFilter");
        }
    }
}