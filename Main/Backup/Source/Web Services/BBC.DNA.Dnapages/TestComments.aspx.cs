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
using BBC.Dna.Page;
using BBC.Dna;

public partial class TestComments : DnaWebPage
{
	public TestComments()
	{
		UseDotNetRendering = true;
	}

	//protected void Page_Load(object sender, EventArgs e)
	//{

	//}

	protected void RenderPage()
	{
		string template = Request["template"];
		using (StreamReader reader = new StreamReader(Server.MapPath(@"App_Data\" + template)))
		{
			string contents = reader.ReadToEnd();
			string include = GetCustomInclude();
			string escaped = include.Replace("<!--#", "<!--");
			contents = contents.Replace("<!--#includecomments-->", include + escaped);
			Response.Write(contents);
		}
	}

	private string GetCustomInclude()
	{
		if (Request["newid"] != null)
		{
			string error = string.Empty;
			if (false == CheckForRequiredParameters(ref error, "sitename", "title", "host"))
			{
				return error;
			}
			string newid = Request["newid"];
			if (newid == "generate")
			{
				newid = Guid.NewGuid().ToString();
			}
			else if (newid == "custom")
			{
				newid = Request["customuid"];
			}
			string sitename = Request["sitename"];
			string hostdomain = Request["host"];
			string initialtitle = Request["title"];
			string modstatus = GetOptionalParam("modstatus", "dnainitialmodstatus");
			string staging = GetOptionalParam("staging");
			string stagingpath = string.Empty;
			if (staging.Length > 0)
			{
				stagingpath = "staging/";
			}
			string hostpageurl = Page.Server.UrlEncode("http://" + hostdomain + "/dna/dnapages/TestComments.aspx?useid=" + newid + "&sitename=" + sitename + staging);
			string closedate = GetOptionalParam("closedate", "dnaforumclosedate");
			string url = string.Format(@"/dna-ssi/{6}{0}/acs/acs?dnauid={1}&dnainitialtitle={2}&dnahostpageurl={8}{4}{5}{7}", sitename, newid, initialtitle, hostdomain, modstatus, closedate, stagingpath, staging, hostpageurl);
			return "<!--#include virtual=\"" + url + "&$QUERY_STRING\" -->";
		}
		else if (Request["useid"] != null)
		{
			string error = string.Empty;
			if (false == CheckForRequiredParameters(ref error, "sitename"))
			{
				return error;
			}
			string stagingpath = string.Empty;
			if (Request["staging"] != null)
			{
				stagingpath = "staging/";
			}
			return string.Format("<!--#include virtual=\"/dna-ssi/{0}{1}/acs/acs?dnauid={2}\" -->", stagingpath, Request["sitename"], Request["useid"]);
		}
		else
		{
			return "<div>No newid on querystring</div>";
		}
	}

	private bool CheckForRequiredParameters(ref string error, params string[] names)
	{
		foreach (string name in names)
		{
			if (Request[name] == null)
			{
				error = "Required parameter " + name + " is missing";
				return false;
			}
		}
		return true;
	}

	private string GetOptionalParam(string paramname)
	{
		return GetOptionalParam(paramname, paramname);
	}
	
	private string GetOptionalParam(string paramname, string commenturlparamname)
	{
		string result = Request[paramname];
		if (result == null)
		{
			result = string.Empty;
		}
		else
		{
			result = "&" + commenturlparamname + "=" + result;
		}
		return result;
	}

	protected void OutputOptionTemplates()
	{
		string path = Server.MapPath("App_Data");
		string[] templates = Directory.GetFiles(path, "test_template*.htm");
		foreach (string template in templates)
		{
			Response.Write(string.Format("<option value=\"{0}\">{0}</option>",Path.GetFileName(template)));
		}
	}

	protected void OutputSitenameOptions()
	{
        SiteXmlBuilder siteXml = new SiteXmlBuilder(_basePage);
        XmlNode sites = siteXml.GenerateAllSitesXml(_basePage.TheSiteList);
		XmlNodeList nodes = sites.SelectNodes("//SITE-LIST/SITE/NAME");
		foreach (XmlNode namenode in nodes)
		{
			Response.Write(string.Format("<option value=\"{0}\">{0}</option>", namenode.InnerText));
		}
		//Site[] sites = _basePage.TheSiteList.GetSites();
		//foreach (Site site in sites)
		//{
		//    Response.Write(string.Format("<option value=\"{0}\">{0}</option>", site.SiteName));
		//}
	}

	public override string PageType
	{
		get { return "TESTCOMMENTS"; }
	}

	public override void OnPageLoad()
	{
		
	}

}
