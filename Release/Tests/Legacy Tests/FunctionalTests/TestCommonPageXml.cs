using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
	/// <summary>
	/// Tests for all the common elements we expect to see on a request
	/// </summary>
	[TestClass]
	public class TestCommonPageXml
	{
		/// <summary>
		/// Test to see if the common page elements are there
		/// </summary>
		[TestMethod]
		public void TestAcsRequest()
		{
			DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
			request.RequestPage(@"acs?dnatitle=New+Comment+Box2&dnaurl=http://local.bbc.co.uk:8000/testpage.shtml&dnauid=552F1F05-74AD-410b-880C-F37B83D8B69A&skin=purexml");
			XmlDocument doc = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(doc.InnerXml, "H2G2CommentBoxFlat.xsd");
            validator.Validate();
			Assert.IsTrue(doc.SelectSingleNode("/H2G2/SERVERNAME") != null, "No SERVERNAME element found");
			Assert.IsTrue(doc.SelectSingleNode("/H2G2/TIMEFORPAGE") != null, "No TIMEFORPAGE element found");
			Assert.IsTrue(doc.SelectSingleNode("/H2G2/USERAGENT") != null, "No USERAGENT element found");
		}
	}
}
