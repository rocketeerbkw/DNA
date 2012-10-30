using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

using TestUtils;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Users project
    /// </summary>
    [TestClass]
    public class ArticlePageTests
    {
        /// <summary>
        /// Setup fixture
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            //SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        [Ignore] //H2G2 not supported and test failing in build environment
        public void Test01GetH2G2ArticlesAndValidateSchemasUsingRipley()
        {
            string siteName = "h2g2";
            GetAndValidateArticleXml(siteName, 1675);
            GetAndValidateArticleXml(siteName, 1422);
            GetAndValidateArticleXml(siteName, 266942);
        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [Ignore]//606 not supported
        public void Test02Get606ArticlesAndValidateSchemasUsingRipley()
        {
            string siteName = "606";
            GetAndValidateArticleXml(siteName, 7619345);
        }

        /// <summary>
        /// Test new c# code base
        /// </summary>
        [TestMethod]
        public void Test03GetH2G2ArticlesAndValidateSchemasCSharp()
        {
            string siteName = "h2g2";
            GetAndValidateArticleXml(siteName, 1675, false);
            GetAndValidateArticleXml(siteName, 1422, false);
            GetAndValidateArticleXml(siteName, 266942, false);
        }

        private void GetAndValidateArticleXml(string siteName, int article)
        {
            GetAndValidateArticleXml(siteName, article, true);
        }

        /// <summary>
        /// Gets the xml for an article page and validates it against the schema
        /// </summary>
        /// <param name="siteName"></param>
        /// <param name="article"></param>
        private void GetAndValidateArticleXml(string siteName, int article, bool useRipley)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(siteName);
            request.SetCurrentUserNormal();
            if (useRipley)
            {
                request.RequestPage("A" + article.ToString() + "?skin=purexml");
            }
            else
            {
                request.RequestPage("NA" + article.ToString() + "?skin=purexml");
            }

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(request.GetLastResponseAsString());

            
            string xml = doc.DocumentElement.SelectSingleNode("ARTICLEFORUM").OuterXml;
            DnaXmlValidator validator = new DnaXmlValidator(Entities.GetEntities() + xml, "ArticleForum.xsd");
            validator.Validate();

            xml = doc.DocumentElement.SelectSingleNode("ARTICLE").OuterXml;
            validator = new DnaXmlValidator(Entities.GetEntities() + xml, "Article.xsd");
            validator.Validate();

            if (doc.DocumentElement.SelectSingleNode("POLL-LIST") != null)
            {//is optional and not included with H2G2
                xml = doc.DocumentElement.SelectSingleNode("POLL-LIST").OuterXml;
                validator = new DnaXmlValidator(Entities.GetEntities() + xml, "Polllist.xsd");
                validator.Validate();
            }

            //string xml = doc.DocumentElement.OuterXml;
            validator = new DnaXmlValidator(Entities.GetEntities() + doc.DocumentElement.OuterXml, "H2G2ArticleFlat.xsd");
            validator.Validate();

            Assert.AreNotEqual(null, doc.SelectSingleNode("H2G2[@TYPE='ARTICLE']"));
        }
    }
}
