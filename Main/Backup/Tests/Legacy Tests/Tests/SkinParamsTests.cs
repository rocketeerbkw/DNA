using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
	/// <summary>
	/// Tests for SkinParams class
	/// </summary>
	[TestClass]
	public class SkinParamsTests
	{
        private const string _schemaUri = "Params.xsd";
		/// <summary>
		/// Test having two s_params in the request among others
		/// </summary>
		[TestMethod]
		public void TestSkinParams()
		{
            Console.WriteLine("TestSkinParams");
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                inputcontext.SetCurrentSite("h2g2");
                inputcontext.InitDefaultUser();

                inputcontext.AddParam("s_abcde", "xyzzy");
                inputcontext.AddParam("notaskinparam", "abcde");
                inputcontext.AddParam("s_xxxxx", "plugh");
                inputcontext.AddParam("ss_not", "doesn't matter");

                SkinParams sparams = new SkinParams(inputcontext);
                sparams.ProcessRequest();
                DnaXmlValidator validator = new DnaXmlValidator(sparams.RootElement.InnerXml, _schemaUri);
                validator.Validate();

                XmlDocument doc = new XmlDocument();
                doc.LoadXml(sparams.RootElement.OuterXml);

                XmlNode node = doc.SelectSingleNode("/DNAROOT/PARAMS");
                Assert.IsNotNull(node, "No PARAMS element found");
                XmlNodeList nodes = doc.SelectNodes("/DNAROOT/PARAMS/PARAM");

                Assert.IsNotNull(nodes, "Unable to find /DNAROOT/PARAMS/PARAM");

                Assert.IsTrue(nodes.Count == 2, string.Format("Expecting 2 s_ params in query, found {0}", nodes.Count));

                foreach (XmlNode subnode in nodes)
                {
                    XmlNode name = subnode.SelectSingleNode("NAME");
                    XmlNode value = subnode.SelectSingleNode("VALUE");
                    Assert.IsNotNull(name, "NAME missing from PARAM object");
                    Assert.IsNotNull(value, "VALUE missing from PARAM object");
                    if (name.InnerText == "s_abcde")
                    {
                        Assert.AreEqual(value.InnerText, "xyzzy", "s_abcde value doesn't match");
                    }
                    else if (name.InnerText == "s_xxxxx")
                    {
                        Assert.AreEqual(value.InnerText, "plugh", "Value of s_xxxxx doesn't match");
                    }
                    else
                    {
                        Assert.Fail(string.Format("Unexpected param found: {0}", name.InnerText));
                    }
                }
            }
		}

		/// <summary>
		/// Test having no parameters in the request
		/// </summary>
		[TestMethod]
		public void TestAbsentSkinParams()
		{
            Console.WriteLine("TestAbsentSkinParams");
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                inputcontext.SetCurrentSite("h2g2");
                inputcontext.InitDefaultUser();

                inputcontext.AddParam("notaskinparam", "abcde");
                inputcontext.AddParam("ss_not", "doesn't matter");

                SkinParams sparams = new SkinParams(inputcontext);
                sparams.ProcessRequest();
                DnaXmlValidator validator = new DnaXmlValidator(sparams.RootElement.InnerXml, _schemaUri);
                validator.Validate();

                XmlDocument doc = new XmlDocument();
                doc.LoadXml(sparams.RootElement.OuterXml);

                XmlNode node = doc.SelectSingleNode("/DNAROOT/PARAMS");
                Assert.IsNotNull(node, "No PARAMS element found");
                XmlNodeList nodes = doc.SelectNodes("/DNAROOT/PARAMS/PARAM");

                Assert.IsNotNull(nodes, "Unable to find /DNAROOT/PARAMS/PARAM");

                Assert.IsTrue(nodes.Count == 0, string.Format("Expecting 0 s_ params in query, found {0}", nodes.Count));
            }
		}
	}
}
