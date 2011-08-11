using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks;
using System.Xml;
using TestUtils;

namespace BBC.Dna.Moderation.Tests
{
    
    
    /// <summary>
    ///This is a test class for TermAdminTest and is intended
    ///to contain all TermAdminTest Unit Tests
    ///</summary>
    [TestClass()]
    public class TermAdminTest
    {

        public MockRepository Mocks = new MockRepository();

        /// <summary>
        ///A test for CreateTermAdmin
        ///</summary>
        [TestMethod()]
        public void CreateTermAdmin_FromCache_ReturnsValidObject()
        {
            ModerationClassListTest.InitialiseClasses();
            TermsList termsList = TermsListTest.GetTermsList();
            const int modClassId = 1;

            //var reader = Mocks.DynamicMock<IDnaDataReader>();
            //reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);

            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            cacheManager.Stub(x => x.GetData(termsList.GetCacheKey(modClassId))).Return(termsList);

            Mocks.ReplayAll();

            var termAdmin = TermsFilterAdmin.CreateTermAdmin(readerCreator, cacheManager, modClassId, false);

            Assert.AreEqual(1, termAdmin.TermsList.Terms.Count);
            Assert.AreEqual(1, termAdmin.ModerationClasses.ModClassList.Count);

        }

        /// <summary>
        ///A test for TermAdmin Constructor
        ///</summary>
        [TestMethod()]
        public void TermAdminConstructorTest()
        {
            TermsFilterAdmin target = new TermsFilterAdmin()
                                   {
                                       ModerationClasses = ModerationClassListTest.GetModerationClassList(),
                                       TermsList = TermsListTest.GetTermsList()
                                   };
            


            var expected = "<TERMSFILTERADMIN xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">" +
                "<TERMSLIST MODCLASSID=\"1\"><TERM ID=\"0\" ACTION=\"ReEdit\" TERM=\"term\" /></TERMSLIST>" +
                "<MODERATION-CLASSES><MODERATION-CLASS CLASSID=\"1\"><NAME>test</NAME><DESCRIPTION>test</DESCRIPTION><ITEMRETRIEVALTYPE>Standard</ITEMRETRIEVALTYPE></MODERATION-CLASS></MODERATION-CLASSES>" +
                "</TERMSFILTERADMIN>";

            XmlDocument xml = Serializer.SerializeToXml(target);
            Assert.AreEqual(expected, xml.SelectSingleNode("TERMSFILTERADMIN").OuterXml);

            
            
        }
    }
}
