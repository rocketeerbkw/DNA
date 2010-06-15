using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
	/// <summary>
	/// Class to test the WholePage component
	/// </summary>
	[TestClass]
	public class WholePageTests
	{
		/// <summary>
		/// Test the URL Skin name is put into the XML returned by the WholePage
		/// </summary>
		[TestMethod]
		public void TestUrlSkinName()
		{
            Console.WriteLine("After TestUrlSkinName");
            Mockery mock = new Mockery();
			IInputContext context = mock.NewMock<IInputContext>();
			XmlDocument siteconfig = new XmlDocument();
			siteconfig.LoadXml("<SITECONFIG />");
			ISite site = mock.NewMock<ISite>();
			Stub.On(site).GetProperty("Config").Will(Return.Value(String.Empty));

			User user = new User(context);
            Stub.On(context).Method("IsPreviewMode").Will(Return.Value(false));
			Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(user));
			Stub.On(context).GetProperty("UserAgent").Will(Return.Value("Mozilla+blah+blah"));
			Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(site));
			Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("_sk"), Is.Anything).Will(Return.Value(true));
			Stub.On(context).Method("GetParamStringOrEmpty").With(Is.EqualTo("_sk"), Is.Anything).Will(Return.Value("randomskin"));

			WholePage page = new WholePage(context);
			page.InitialisePage("TEST");
			Assert.IsNotNull(page.RootElement);
			Assert.AreEqual(page.RootElement.FirstChild.Name, "H2G2");
			XmlNodeList nodes = page.RootElement.SelectNodes("H2G2/VIEWING-USER");
			Assert.IsNotNull(nodes);
			Assert.AreEqual(nodes.Count, 1, "Only expecting one Viewing User element");
			nodes = page.RootElement.SelectNodes("H2G2/URLSKINNAME");
			Assert.IsNotNull(nodes);
			Assert.AreEqual(nodes.Count, 1, "Only expecting one URLSKINNAME element");
			XmlNode node = nodes[0];
			Assert.AreEqual(node.InnerText, "randomskin", "Expected 'randomskin' for the skin name in the URLSKINNAME element");

			context = mock.NewMock<IInputContext>();
            Stub.On(context).Method("IsPreviewMode").Will(Return.Value(false));
			Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(user));
			Stub.On(context).GetProperty("UserAgent").Will(Return.Value("Mozilla+blah+blah"));
			Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(site));
			Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("_sk"), Is.Anything).Will(Return.Value(false));
			Stub.On(context).Method("GetParamStringOrEmpty").With(Is.EqualTo("_sk"), Is.Anything).Will(Return.Value(""));
			page = new WholePage(context);
			page.InitialisePage("TEST");
			Assert.IsNotNull(page.RootElement);
			Assert.AreEqual(page.RootElement.FirstChild.Name, "H2G2");
			nodes = page.RootElement.SelectNodes("H2G2/VIEWING-USER");
			Assert.IsNotNull(nodes);
			Assert.AreEqual(nodes.Count, 1, "Only expecting one Viewing User element");
			nodes = page.RootElement.SelectNodes("H2G2/URLSKINNAME");
			Assert.IsNotNull(nodes);
			Assert.AreEqual(nodes.Count, 0, "Not expecting one URLSKINNAME element");
            Console.WriteLine("After TestUrlSkinName");
        }
	}
}
