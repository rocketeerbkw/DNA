using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Test class AllowedURLTests.cs
    /// </summary>
    [TestClass]
    public class AllowedURLTests
    {
        /// <summary>
        /// Test method to test loading the allowed urls
        /// </summary>
        [TestMethod]
        public void TestCheckLoadAllowedURLListData()
        {
            Console.WriteLine("Before TestCheckLoadAllowedURLListData");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = DnaMockery.CreateDatabaseInputContext();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            User user = new User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the stored procedure reader for the UITemplate object
            using (IDnaDataReader reader = mockedInputContext.CreateDnaDataReader("getallallowedurls"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getallallowedurls").Will(Return.Value(reader));
                AllowedURLs allowedURLs = new AllowedURLs();
                allowedURLs.LoadAllowedURLLists(mockedInputContext);
                Assert.IsTrue(allowedURLs.DoesAllowedURLListContain(1, "www.bbc.co.uk"), "Does not report that it contains the bbc web address");
            }
            Console.WriteLine("After TestCheckLoadAllowedURLListData");
        }
    }
}
