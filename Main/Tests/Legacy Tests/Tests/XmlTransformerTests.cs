using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Page;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Xml;
using System.Xml.Xsl;

namespace Tests
{
    /// <summary>
    /// 
    /// </summary>
    public class XmlTransOutputContext : DummyOutputContext
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="leaf"></param>
        /// <returns></returns>
        public override string GetSkinPath(string leaf)
        {
            using (var iis = IIsInitialise.GetIIsInitialise())
            {
                var schemas = iis.GetVDirPath("h2g2UnitTesting", "Schemas");

                return schemas + "/TestXmlTransformer-" + leaf;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <param name="o"></param>
        /// <param name="seconds"></param>
        public override void CacheObject(string key, object o, int seconds)
        {
            return;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string CreateRequestCacheKey()
        {
            return "xxxx";
        }

        /// <summary>
        /// 
        /// </summary>
        public override string DebugSkinFile
        {
            get
            {
                return string.Empty;
            }
            set
            {
                base.DebugSkinFile = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="xsltFileName"></param>
        /// <returns></returns>
        public override XslCompiledTransform GetCachedXslTransform(string xsltFileName)
        {
            return DnaBasePage.CreateCompiledTransform(xsltFileName);
        }
    }

    /// <summary>
    /// Tests for the XML transformer class
    /// </summary>
    [TestClass]
    public class XmlTransformerTests
    {
        private WholePage _page;
        private XmlTransOutputContext outputcontext;
        //private IInputContext inputcontext;

        /// <summary>
        /// Setup for PureXmlTransformer tests
        /// </summary>
        [TestInitialize]
        public void SetUpTests()
        {
            //inputcontext = new TestInputContext();
            outputcontext = new XmlTransOutputContext();
        }

        /// <summary>
        /// PureXmlTransformer test
        /// </summary>
        [TestMethod]
        public void TestXmltransformer()
        {
            Console.WriteLine("After TestXmltransformer");

            XmlTransformer trans = new XmlTransformer(outputcontext);
            Assert.IsNotNull(trans, "Failed to get new transformer");
            _page = new WholePage(null);
            Assert.IsNotNull(_page, "Failed to get whole page");
            XmlNode gumby = _page.AddElementTag(_page.RootElement, "GUMBY");
            Assert.IsNotNull(gumby, "AddElementTag returned null adding GUMBY");

            Assert.IsTrue(trans.TransformXML(_page), "TransformXML returned false");
            string contents = outputcontext.Contents.ToString();
            Assert.IsTrue(contents.Contains("<?xml version=\"1.0\""), "Failed to find xml directive");
            Assert.IsTrue(outputcontext.ContentType.Contains("text/xml"), "Content type must contain text/xml");

            Console.WriteLine("After TestXSLTCaching");
        }

    }
}
