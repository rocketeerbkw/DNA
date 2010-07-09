using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Utils;


namespace Tests
{
    

    /// <summary>
    /// Tests for added and getting recent searches
    /// </summary>
    [TestClass]
    public class RecentSearchTests
    {
        /// <summary>
        /// XML Schema
        /// </summary>
        private const string _schemaUri = "RecentSearch.xsd";

        /// <summary>
        /// Test the ability to add and retrieve latest search terms for a given site and type
        /// </summary>
        [TestMethod]
        public void AddRecentSearchTests()
        {
            string rootPath = TestConfig.GetConfig().GetRipleyServerPath();
            BBC.Dna.AppContext.OnDnaStartup(rootPath);



            Console.WriteLine("Before RecentSearch - AddRecentSearchTests");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create a mocked site for the context
            ISite mockedSite = DnaMockery.CreateMockedSite(context, 70, "mbiplayer", "mbiplayer", true, "http://identity/policies/dna/adult");//changed to miss cache
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));
            Stub.On(mockedSite).GetProperty("ModClassID").Will(Return.Value(1));


            BBC.Dna.User user = new BBC.Dna.User(context);
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));


            // Initialise the profanities object
            var p = new ProfanityFilter(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default, CacheFactory.GetCacheManager(), null, null);

            RecentSearch recentsearch = new RecentSearch(context);
            Assert.IsTrue(recentsearch.AddSearchTerm("test article", RecentSearch.SEARCHTYPE.ARTICLE),"Adding valid artical search");
            Assert.IsTrue(recentsearch.AddSearchTerm("test forum", RecentSearch.SEARCHTYPE.FORUM), "Adding valid forum search");
            Assert.IsFalse(recentsearch.AddSearchTerm("This contains the profanity fuck", RecentSearch.SEARCHTYPE.ARTICLE), "Failing to add search term with profanity");
            Assert.IsFalse(recentsearch.AddSearchTerm("This contains the an email - marcus.parnwell@bbc.co.uk", RecentSearch.SEARCHTYPE.ARTICLE), "Failing to add search term with email");


            recentsearch.ProcessRequest();
            XmlElement xml = recentsearch.RootElement;
            Assert.IsTrue(xml.SelectSingleNode("RECENTSEARCHES") != null, "The xml is not generated correctly!!!");
          
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("after RecentSearch - AddRecentSearchTests");
        }
    }

}
