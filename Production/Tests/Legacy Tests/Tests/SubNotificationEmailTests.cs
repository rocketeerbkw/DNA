using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;


namespace Tests
{
    /// <summary>
    /// Tests for the sub notification email
    /// </summary>
    [TestClass]
    public class SubNotificationEmailTests
    {
        /// <summary>
        /// XML Schema
        /// </summary>
        private const string _schemaUri = "SubNotificationEmail.xsd";

        /// <summary>
        /// Test the get Sub Notification email
        /// </summary>
        [TestMethod]
        public void GetSubNotificationEmailTest()
        {
            string rootPath = TestConfig.GetConfig().GetRipleyServerPath();
            BBC.Dna.AppContext.OnDnaStartup(rootPath);

            ProfanityFilter.ClearTestData();

            Console.WriteLine("Before SubNotificationEmailTests - GetSubNotificationEmailTest");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create a mocked site for the context
            ISite mockedSite = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", true, "http://identity/policies/dna/adult");
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));
            Stub.On(mockedSite).GetProperty("ModClassID").Will(Return.Value(1));

            // Initialise the profanities object
            ProfanityFilter.InitialiseProfanitiesIfEmpty(DnaMockery.CreateDatabaseReaderCreator(), null);

            BBC.Dna.User user = new BBC.Dna.User(context);
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            CreateAndRecommendAndAllocateArticle(context);

            SubNotificationEmail subNotificationEmail = new SubNotificationEmail(context);
            bool toSend = false;
            string emailAddress = String.Empty;
            string emailSubject = String.Empty;
            string emailText = String.Empty;

            subNotificationEmail.CreateNotificationEmail(6, ref toSend, ref emailAddress, ref emailSubject, ref emailText);

            XmlElement xml = subNotificationEmail.RootElement;
            Assert.IsTrue(xml.SelectSingleNode("EMAIL") != null, "The xml is not generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After SubNotificationEmailTests - GetSubNotificationEmailTest");
        }

        void CreateAndRecommendAndAllocateArticle(IInputContext context)
        {
            using (IDnaDataReader reader = context.CreateDnaDataReader("updateuser"))
            {
                reader.AddParameter("userid", 6);
                reader.AddParameter("email", "testemail@test.bbc.co.uk");
                reader.Execute();
            }

            int entryID = 0;
            int h2g2ID = 0;
            //create a dummy article

            using (IDnaDataReader reader = context.CreateDnaDataReader("createguideentry"))
            {
                reader.AddParameter("subject", "TEST ARTICLE");
                reader.AddParameter("bodytext", "TEST ARTICLE");
                reader.AddParameter("extrainfo", "<EXTRAINFO>TEST ARTICLE</EXTRAINFO>");
                reader.AddParameter("editor", 6);
                reader.AddParameter("typeid", 3001);
                reader.AddParameter("status", 3);

                reader.Execute();
                Assert.IsTrue(reader.Read(), "Article not created");
                entryID = reader.GetInt32NullAsZero("entryid");
                h2g2ID = reader.GetInt32NullAsZero("h2g2id");

                Assert.IsTrue(entryID != 0, "Article not created");
            }

            int recommendationID = 0;
            //recommnend article...
            using (IDnaDataReader reader = context.CreateDnaDataReader("storescoutrecommendation"))
            {
                reader.AddParameter("entryid", entryID);
                reader.AddParameter("@comments", "scout comment");
                reader.AddParameter("scoutid", 6);
                reader.Execute();
                Assert.IsTrue(reader.Read(), "Recommendation not created");
                recommendationID = reader.GetInt32NullAsZero("RecommendationID");
                Assert.IsTrue(recommendationID != 0, "Recommendation not created");
            }

            int newH2G2ID = 0;
            //accept the recommendation
            using (IDnaDataReader reader = context.CreateDnaDataReader("acceptscoutrecommendation"))
            {
                reader.AddParameter("recommendationid", recommendationID);
                reader.AddParameter("comments", "acceptor comment");
                reader.AddParameter("acceptorid", 6);
                reader.Execute();
                Assert.IsTrue(reader.Read(), "Recommendation not accepted");
                Assert.IsTrue(reader.GetTinyIntAsInt("Success") == 1, "Recommendation not accepted");
                newH2G2ID = reader.GetInt32NullAsZero("h2g2ID");
                Assert.IsTrue(newH2G2ID != 0, "Recommendation not created");
            }
            //allocate the recommendation
            using (IDnaDataReader reader = context.CreateDnaDataReader("AllocateEntriesToSub"))
            {
                reader.AddParameter("subid", 6);
                reader.AddParameter("comments", "allocator comment");
                reader.AddParameter("AllocatorID", 6);
                reader.AddParameter("id0", newH2G2ID / 10);
                reader.Execute();
                Assert.IsTrue(reader.Read(), "Allocation not accepted");
                Assert.IsTrue(reader.GetInt32NullAsZero("EntryID") == newH2G2ID / 10, "Allocation not accepted");
            }
        }
    }
}
