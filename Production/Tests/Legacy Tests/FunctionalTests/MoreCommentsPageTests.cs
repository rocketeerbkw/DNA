using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class CommentForumListPageTest.cs
    /// </summary>
    [TestClass]
    public class MoreCommentsPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("haveyoursay");
        private const string _schemaUri = "H2G2MoreCommentsFlat.xsd";

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
                _request.UseEditorAuthentication = true;
                _request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;
            }
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateMoreCommentsPageTest()
        {
            Console.WriteLine("Before Test01CreateMoreCommentsPageTest");
            _request.RequestPage("MC6?skin=purexml");
            Console.WriteLine("After Test01CreateMoreCommentsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
        }

        /// <summary>
        /// Test we get a more comments page for the call. 
        /// </summary>
        [TestMethod]
        public void Test02GetMoreCommentsPageTest()
        {
            Console.WriteLine("Before Test02GetMoreCommentsPageTest");
            _request.RequestPage("MC6?skin=purexml");
            Console.WriteLine("After Test02GetMoreCommentsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORECOMMENTS/COMMENTS-LIST") != null, "The comments list page has not been generated!!!");
        }

        /// <summary>
        /// Test we get a more comments page for the call. 
        /// </summary>
        [TestMethod]
        public void Test03CheckOutputFormatMoreCommentsPageTest()
        {
            Console.WriteLine("Before Test03CheckOutputFormatMoreCommentsPageTest");
            _request.RequestPage("MC6?skin=purexml");
            Console.WriteLine("After Test03CheckOutputFormatMoreCommentsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORECOMMENTS/COMMENTS-LIST") != null, "The comments list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORECOMMENTS/COMMENTS-LIST/@SKIP") != null, "The comment list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORECOMMENTS/COMMENTS-LIST/@SHOW") != null, "The comment list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORECOMMENTS[@USERID='6']") != null, "The comment list page has not been generated correctly - USERID!!!");
           
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
    }
}
