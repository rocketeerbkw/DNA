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
using System.IO;
public partial class acsdemoindex : System.Web.UI.Page
{
	protected void Page_Load(object sender, EventArgs e)
	{

	}
	protected void ScanSamples()
	{
		string thispath = Server.MapPath(@"App_Data");
		string[] files = Directory.GetFiles(thispath, "*.xml");
		Response.Write("<ul>");
		foreach (string path in files)
		{
			XmlDocument doc = new XmlDocument();
			doc.Load(path);
			XmlNode node = doc.SelectSingleNode("/H2G2/sample-description[1]");
			if (null != node)
			{
				XmlNode title = node.SelectSingleNode("title");
				XmlNode description = node.SelectSingleNode("description");
				Response.Write("<li>");
				if (null != title)
				{
					WriteAjaxLink("/dna/h2g2/stylepage", "source=" + Path.GetFileName(path), "uniqueid", title.InnerText);
					if (description != null)
					{
						Response.Write("<ul><li>");
						Response.Write(description.InnerXml);
						Response.Write("</li></ul>");
					}
				}
				else
				{
					Response.Write(path);
				}
				Response.Write("</li>");
			}
			else
			{
				Response.Write("<li>");
				WriteAjaxLink("/dna/h2g2/stylepage", "source=" + Path.GetFileName(path), "uniqueid", path);
				Response.Write("</li>");
			}
		}
		Response.Write("</ul>");
	}

	protected void WriteAjaxLink(string url, string parameters, string elementid, string contents)
	{
//		Response.Write(string.Format(@"<a href=""{0}"" onclick=""hide('samples');hide('closeit');unhide('openit');return dorequest('{0}','{2}')"">{1}</a>", url + "?" + parameters, contents, elementid));
		Response.Write(string.Format(@"<a href=""{0}"" onclick=""hide('samples');hide('closeit');unhide('openit');return doconfigrequest('{0}','{3}','{2}')"">{1}</a>", url, contents, elementid, parameters));
	}
}
