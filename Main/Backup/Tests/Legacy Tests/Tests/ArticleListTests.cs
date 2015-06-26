using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    ///ArticleList Tests
    /// </summary>
    [TestClass]
    public class ArticleListTests
    {
        private const string _schemaUri = "ArticleListUndecidedRecommendations.xsd";

        /// <summary>
        /// Test that we get the undecided recommended article list
        /// </summary>
        [TestMethod]
        public void TestGetUndecidedRecommendationsArticleListTest()
        {
            Console.WriteLine("Before ArticleListTests - TestGetUndecidedRecommendationsArticleListTest");
            //Create the mocked inputcontext
            Mockery mock = new Mockery();

            // Create the app context for the poll to run in
            string rootPath = TestConfig.GetConfig().GetRipleyServerPath();
            BBC.Dna.AppContext.OnDnaStartup(rootPath);

            // Create the stored procedure reader for the CommentList object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");

            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            User user = new User(context);
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(site));

            SetupArticles(context);

            using (IDnaDataReader reader = context.CreateDnaDataReader("FetchUndecidedRecommendations"))
            {
                Stub.On(context).Method("CreateDnaDataReader").With("FetchUndecidedRecommendations").Will(Return.Value(reader));

                // Create a new ArtiocleList object and get the list of undecided articles
                ArticleList testArticleList = new ArticleList(context);
                testArticleList.CreateUndecidedRecommendationsList(0, 50);

                XmlElement xml = testArticleList.RootElement;
                Assert.IsTrue(xml.SelectSingleNode("ARTICLE-LIST") != null, "The xml is not generated correctly!!!");

                Assert.IsTrue(xml.SelectSingleNode("ARTICLE-LIST[@TYPE='UNDECIDED-RECOMMENDATIONS']") != null, "The xml is not generated correctly (TYPE != UNDECIDED-RECOMMENDATIONS)!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();

            }
            Console.WriteLine("After ArticleListTests - TestGetUndecidedRecommendationsArticleListTest");
        }

        void SetupArticles(IInputContext context)
        {
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
        }
    }
}
