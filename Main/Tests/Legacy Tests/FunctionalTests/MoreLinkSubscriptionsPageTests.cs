using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class MoreSubscribingUsersPageTests.cs
    /// </summary>
    [TestClass]
    public class MoreLinkSubscriptionsPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2MoreLinkSubscriptionsFlat.xsd";
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
                //_request.UseEditorAuthentication = true;
                // _request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;
            }
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateMoreSubscribingUsersPageTest()
        {
            _request.RequestPage("MLS6?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKSUBSCRIPTIONS/USERSUBSCRIPTIONLINKS-LIST") != null, "The UserSubscriptionLinks-List was not generated");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKSUBSCRIPTIONS/USERSUBSCRIPTIONLINKS-LIST/@SKIP") != null, "The UserSubscriptionLinks-List skip parameter was not generated");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKSUBSCRIPTIONS/USERSUBSCRIPTIONLINKS-LIST/@SHOW") != null, "The UserSubscriptionLinks-List show parameter was not generated");

            //Check the User XML for user 6.
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKSUBSCRIPTIONS/USERSUBSCRIPTIONLINKS-LIST/USER[USERID='6']") != null, "The UserSubscriptionLinks-List user block was not generated correctly.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        [TestMethod]
        public void Test02MoreSubscriptionUsersPageArticleBookmark()
        {
            _request.SetCurrentUserEditor();
            String editorid = Convert.ToString(_request.CurrentUserID);

            //Subscribe Normal User to Editor
            _request.SetCurrentUserNormal();
            string url = "MUS" + _request.CurrentUserID + "?dnaaction=subscribe&subscribedtoid=" + editorid + "&skin=purexml";
            _request.RequestPage(url);

            //Get an Article to clip.
            _request.SetCurrentUserEditor();
            _request.RequestPage("A?random=any&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLE/ARTICLEINFO/H2G2ID") != null, "Could not locate randomj article");
            XmlNode node = xml.SelectSingleNode("H2G2/ARTICLE/ARTICLEINFO/H2G2ID");
            String article = "A" + node.InnerText;

            //Clip article.
            _request.RequestPage(article + "?clip=1&skin=purexml");

            //Check that normal user has subscribed users clipping.
            _request.SetCurrentUserNormal();
            _request.RequestPage("MLS" + _request.CurrentUserID + "?Skin=purexml");
            xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORELINKSUBSCRIPTIONS/USERSUBSCRIPTIONLINKS-LIST/LINK[@DNAUID='" + article + "']") != null,"Article " + article + " of subscribed userid 6 not found in MLS page");

        }
    }
}

