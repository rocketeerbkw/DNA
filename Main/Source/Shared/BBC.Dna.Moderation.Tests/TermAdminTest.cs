using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks;
using System.Xml;
using TestUtils;
using BBC.Dna.Moderation.Utils;
using System;
using BBC.Dna.Objects;

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

            var cacheManager = Mocks.DynamicMock<ICacheManager>();

            TermDetails termDetail = new TermDetails();
            termDetail.Id = 1;
            termDetail.Value = "whoopsy";
            termDetail.Reason = "It's not right";
            DateTime updatedDate = DateTime.Now;
            termDetail.UpdatedDate = new DateElement(updatedDate);
            termDetail.UserID = 123456978;
            termDetail.UserName = "Moderator";
            termDetail.Action = TermAction.ReEdit;

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.AddParameter("modClassId", modClassId)).Return(reader);
            reader.Stub(x => x.Execute()).Return(reader);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("TermID")).Return(termDetail.Id);
            reader.Stub(x => x.GetStringNullAsEmpty("Term")).Return(termDetail.Value);
            reader.Stub(x => x.GetStringNullAsEmpty("Reason")).Return(termDetail.Reason);
            reader.Stub(x => x.GetDateTime("UpdatedDate")).Return(updatedDate);
            reader.Stub(x => x.GetInt32NullAsZero("UserID")).Return(termDetail.UserID);
            reader.Stub(x => x.GetStringNullAsEmpty("UserName")).Return(termDetail.UserName);
            reader.Stub(x => x.GetByteNullAsZero("actionId")).Return((byte)termDetail.Action);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(reader);

            Mocks.ReplayAll();

            var termAdmin = TermsFilterAdmin.CreateTermAdmin(readerCreator, cacheManager, modClassId);

            Assert.AreEqual(1, termAdmin.TermsList.Terms.Count);
            Assert.AreEqual(1, termAdmin.ModerationClasses.ModClassList.Count);
            Assert.AreEqual(termDetail.Id, termAdmin.TermsList.Terms[0].Id);
            Assert.AreEqual(termDetail.Value, termAdmin.TermsList.Terms[0].Value);
            Assert.AreEqual(termDetail.Reason, termAdmin.TermsList.Terms[0].Reason);
            Assert.AreEqual(termDetail.UpdatedDate.Date.DateTime, termAdmin.TermsList.Terms[0].UpdatedDate.Date.DateTime);
            Assert.AreEqual(termDetail.UserID, termAdmin.TermsList.Terms[0].UserID);
            Assert.AreEqual(termDetail.UserName, termAdmin.TermsList.Terms[0].UserName);
            Assert.AreEqual(termDetail.Action, termAdmin.TermsList.Terms[0].Action);
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
                "<TERMSLIST FORUMID=\"0\" MODCLASSID=\"1\"><TERMDETAILS ID=\"0\" ACTION=\"ReEdit\" TERM=\"term\" ModClassID=\"0\" ForumID=\"0\" USERID=\"0\" FromModClass=\"false\" /></TERMSLIST>" +
                "<MODERATION-CLASSES><MODERATION-CLASS CLASSID=\"1\"><NAME>test</NAME><DESCRIPTION>test</DESCRIPTION><ITEMRETRIEVALTYPE>Standard</ITEMRETRIEVALTYPE></MODERATION-CLASS></MODERATION-CLASSES>" +
                "</TERMSFILTERADMIN>";

            XmlDocument xml = Serializer.SerializeToXml(target);
            Assert.AreEqual(expected, xml.SelectSingleNode("TERMSFILTERADMIN").OuterXml);

            
            
        }
    }
}
