using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class MoreLinksPageTests.cs
    /// </summary>
    [TestClass]
    public class MoreLinksPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2MoreLinksFlat.xsd";
        private IInputContext _context = DnaMockery.CreateDatabaseInputContext();

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("setting up");
                _setupRun = true;
            }
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateMoreLinksPageTest()
        {
            _request.RequestPage("ML6?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKS/LINKS-LIST") != null, "The Links-List was not generated");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKS/LINKS-LIST/@SKIP") != null, "The Links-List skip parameter was not generated");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKS/LINKS-LIST/@SHOW") != null, "The Links-List show parameter was not generated");

            //Check the User XML for user 6.
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKS/LINKS-LIST/USER[USERID='6']") != null, "The Links-List user block was not generated correctly.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Test when we add a link it is displayed in the page. 
        /// </summary>
        [TestMethod]
        public void Test02CheckAddingLinksPageTest()
        {
            AddResearcher(64, 24);

            int scoreIncrement = GetScoreIncrement();

            _request.SetCurrentUserNormal();
            _request.RequestPage("MUS24?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            int score = 0;
            Int32.TryParse(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/USER/SCORE").InnerXml, out score);
            
            _request.RequestPage("A649?clip=1&skin=purexml");

            _request.RequestPage("MUS24?skin=purexml");
            xml = _request.GetLastResponseAsXML();

            int score2 = 0;
            Int32.TryParse(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/USER/SCORE").InnerXml, out score2);

            Assert.IsTrue(score2 == score + scoreIncrement, "Bookmarking page doesn't increment user zeitgeist score correctly. Score 1 = " + score.ToString() + " and Score2 = " + score2.ToString());

            _request.RequestPage("ML1090501859?skin=purexml");

            xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKS/LINKS-LIST") != null, "The Links-List was not generated");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKS/LINKS-LIST/@SKIP") != null, "The Links-List skip parameter was not generated");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKS/LINKS-LIST/@SHOW") != null, "The Links-List show parameter was not generated");

            //Check the User XML for user 1090501859.
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKS/LINKS-LIST/USER[USERID='1090501859']") != null, "The Links-List user block was not generated correctly.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        private int GetScoreIncrement()
        {
            int scoreIncrement = 0;
            DnaTestURLRequest editorRequest = new DnaTestURLRequest("h2g2");
            editorRequest.SetCurrentUserEditor();
            editorRequest.UseEditorAuthentication = true;

            editorRequest.RequestPage("contentsignifadmin?skin=purexml");
            XmlDocument xml = editorRequest.GetLastResponseAsXML();
            XmlElement score = (XmlElement) xml.SelectSingleNode("/H2G2/CONTENTSIGNIFSETTINGS/SETTING[ACTION/DESCRIPTION='BookmarkArticle'][ITEM/DESCRIPTION='User']/VALUE");

            Int32.TryParse(score.InnerText, out scoreIncrement);
            return scoreIncrement;
        }

        /// <summary>
        /// Function to add a research/user of an entry
        /// </summary>
        /// <param name="entryID">The entry id of the article</param>
        /// <param name="userID">The user id of the person you want to add as a researcher</param>
        private void AddResearcher(int entryID, int userID)
        {
            using (IDnaDataReader dataReader = _context.CreateDnaDataReader("addresearcher"))
            {
                dataReader.AddParameter("entryid", entryID);
                dataReader.AddParameter("userid", userID);

                dataReader.Execute();
            }
        }
    }
}
