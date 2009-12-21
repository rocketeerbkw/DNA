using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Xml.Xsl;
using System.IO;

public partial class stylepage : System.Web.UI.Page
{
	protected void Page_Load(object sender, EventArgs e)
	{

	}
	static XslCompiledTransform transformer = null;
	private static object locker = new object();

	protected void ShowStyledPage()
	{
		if (Request["clear_templates"] == "1")
		{
			transformer = null;
		}
		if (Request["checkconfig"] == "1")
		{
			if (Request["config"] == null || Request["config"].Length == 0)
			{
				Response.Write("No config supplied");
			}

			string wrappedConfig = "<newconfig>" + Request["config"] + "</newconfig>";

			XmlDocument newconfig = new XmlDocument();
			try
			{
				newconfig.LoadXml(wrappedConfig);
			}
			catch (Exception ex)
			{
				Response.Write(ex.Message);
				return;
			}
			Response.Write("Config is OK");

		}
		else
		{
			string sourcefile = Request["source"];
			string stylesheet = Server.MapPath(@"\skins\acs\HTMLOutput.xsl");
			sourcefile = @"App_Data/" + sourcefile;
			XmlDocument source = new XmlDocument();
			source.Load(Server.MapPath(sourcefile));

			RewriteConfig(ref source);

			lock (locker)
			{
				if (transformer == null)
				{
					transformer = new XslCompiledTransform();
					// this stuff is necessary to cope with our stylesheets having DTDs
					// Without all this settings and resolver stuff, you can't use the Load method
					// and tell it to allow DTDs
					XmlReaderSettings xset = new XmlReaderSettings();
					xset.ProhibitDtd = false;

					using (XmlReader xread = XmlReader.Create(stylesheet, xset))
					{
						try
						{
							transformer.Load(xread, XsltSettings.TrustedXslt, new XmlUrlResolver());
						}
						catch (Exception e)
						{
							throw new XsltException("Couldn't load xslt file: " + stylesheet, e);
						}
					}
				}
			}


			StringWriter sw = new StringWriter();
			transformer.Transform(source, null, sw);
			string output = sw.ToString();
			Response.Write(output);
		}
	}

	void RewriteConfig(ref XmlDocument doc)
	{
		if (Request["config"] == null || Request["config"].Length == 0)
		{
			return;
		}

		string wrappedConfig = "<newconfig>" + Request["config"] + "</newconfig>";

		XmlDocument newconfig = new XmlDocument();
		try
		{
			newconfig.LoadXml(wrappedConfig);
		}
		catch (Exception)
		{
			return;
		}

		XmlNode siteconfig = doc.SelectSingleNode("/H2G2/SITECONFIG");
		XmlNode oldsection = doc.SelectSingleNode("/H2G2/SITECONFIG/DNACOMMENTTEXT");
		siteconfig.RemoveChild(oldsection);
		XmlNode newsection = newconfig.SelectSingleNode("//DNACOMMENTTEXT[1]");
		XmlNode importedsection = doc.ImportNode(newsection, true);
		siteconfig.AppendChild(importedsection);
		return;
	}
}
