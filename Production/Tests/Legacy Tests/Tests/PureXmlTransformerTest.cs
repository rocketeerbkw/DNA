using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Page;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
	/// <summary>
	/// Tests for the pure xml transformer
	/// </summary>
	[TestClass]
	public class PureXmlTransformerTest
	{
		private WholePage _page;
		private DummyOutputContext outputcontext;
		private IInputContext inputcontext;

		/// <summary>
		/// Setup for PureXmlTransformer tests
		/// </summary>
		[TestInitialize]
		public void SetUpTests()
		{
			inputcontext = DnaMockery.CreateInputContext();
			outputcontext = new DummyOutputContext();
		}
		
		/// <summary>
		/// PureXmlTransformer test
		/// </summary>
		[TestMethod]
		public void Test1PureXmlTransformer()
		{
            Console.WriteLine("Test1PureXmlTransformer");
            PureXmlTransformer trans = new PureXmlTransformer(outputcontext);
			Assert.IsNotNull(trans, "Failed to get new transformer");
			_page = new WholePage(null);
			Assert.IsNotNull(_page, "Failed to get whole page");
			XmlNode gumby = _page.AddElementTag(_page.RootElement, "GUMBY");
			Assert.IsNotNull(gumby,"AddElementTag returned null adding GUMBY");

			Assert.IsTrue(trans.TransformXML(_page),"TransformXML returned false");
			string contents = outputcontext.Contents.ToString();
			Assert.IsTrue(contents.Contains("<?xml version=\"1.0\"?>"),"Failed to find xml directive");
			Assert.IsTrue(contents.Contains("<GUMBY"),"Failed to find GUMBY element");
			XmlDocument newdoc = new XmlDocument();
			Assert.IsNotNull(newdoc, "Couldn't create new XmlDocument");
			newdoc.LoadXml(contents);
		}
	}
}
