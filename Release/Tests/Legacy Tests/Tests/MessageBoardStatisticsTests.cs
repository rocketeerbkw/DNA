using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Message Board Statistics Tests
    /// </summary>
    [TestClass]
    public class MessageBoardStatisticsTests
    {
        private const string _schemaUri = "H2G2MessageBoardStatisticsFlat.xsd";

        /// <summary>
        /// Test that emails are produced correctly
        /// </summary>
        [TestMethod]
        public void TestEmailSendMailOrSystemMessage()
        {
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");

            // Create a mocked site for the context
            ISite mockedSite = mock.NewMock<ISite>();
            //Stub.On(mockedSite).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));
            Stub.On(mockedSite).GetProperty("SiteName").Will(Return.Value("h2g2"));
            Stub.On(mockedSite).GetProperty("ModClassID").Will(Return.Value(1));

            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            IUser mockedUser = mock.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558354));

            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(context).Method("GetSiteRoot").Will(Return.Value("dnadev.national.core.bbc.co.uk:8081/dna/"));
            Stub.On(context).Method("SendMailOrSystemMessage");

            MessageBoardStatistics mbStats = new MessageBoardStatistics(context);
            mbStats.SendMessageBoardStatsEmail((new DateTime(2008, 1, 1)), "testFrom@dna.bbc.co.uk", "testTo@dna.bbc.co.uk" );


        }
    }
}
