using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using DNA.WebRequests;

namespace GetStats
{
    class Program
    {
        static void Main(string[] args)
        {
			WebRequests req = new WebRequests();

			XmlDocument configxml = new XmlDocument();
			string filename = @"GetStats.config";
			try
			{
				using (StreamReader reader = new StreamReader(filename))
				{
					string docstring = reader.ReadToEnd();

					try
					{
						configxml.LoadXml(docstring);
						req.Initialize(configxml);
					}
					catch (Exception e)
					{
						System.Diagnostics.Debug.WriteLine(e.Message);
						return;
					}
				}
				//req.ConnectToServer();
				//req.HardcodeSSOCookie("44741966ea9db55af653e6f6d1af913f29a872488813303b121b2951942fd31a11");
                req.LogIntoIdentity();

				DateTime dt = DateTime.Now.AddDays(-1);
				if (args.Length > 0)
				{
					DateTime tempdate;
					if (DateTime.TryParse(args[0], out tempdate))
					{
						dt = tempdate;
					}
				}
				foreach (XmlNode node in configxml.SelectNodes("/config/actions/action"))
				{
					string type = "";
					if (node.Attributes["type"] != null)
					{
						type = node.Attributes["type"].InnerText;
					}
					DateTime thisdate;
					XmlNode datenode = node.SelectSingleNode("date");
					if (datenode == null)
					{
						thisdate = dt;
					}
					else
					{
						thisdate = DateTime.Parse(datenode.InnerText);
					}

					if (type == "savelocalfile")
					{
						string url = node.SelectSingleNode("url").InnerText.Replace("%date%", thisdate.ToString("yyyyMMdd"));
						string stylesheet = node.SelectSingleNode("stylesheet").InnerText;
						string location = node.SelectSingleNode("outputfile/location").InnerText;
						string filenamesource = node.SelectSingleNode("outputfile/filename").InnerText;
						string realfilename = location + thisdate.ToString(filenamesource);

						Console.WriteLine("url:{0}, date:{1},save to: {2}", url, thisdate, realfilename);
						XslCompiledTransform transform = new XslCompiledTransform();

						XmlDocument thisdoc = null;
						for (int i = 0; thisdoc == null && i < 3; i++)
						{
							thisdoc = req.LoadXMLDocFromURL(url);
							if (thisdoc != null)
							{
								// check that it's not an error page
								XmlNode rootnode = thisdoc.SelectSingleNode("/H2G2/@TYPE");
								if (rootnode.InnerText != "STATISTICSREPORT")
								{
									thisdoc = null;
								}
							}
						}
						if (thisdoc != null)
						{
							using (StreamWriter sw = new StreamWriter(realfilename))
							{
								transform.Load(stylesheet);
								transform.Transform(thisdoc, null, sw);
							}
						}
						else
						{
							req.LogMessage("Unable to read request for " + url);
						}

						//Console.WriteLine(realfilename);
					}
					else if (type == "makerequest")
					{
						string url = node.SelectSingleNode("url").InnerText.Replace("%date%", thisdate.ToString("yyyyMMdd"));
						XmlDocument thisdoc = req.LoadXMLDocFromURL(url);
						if (thisdoc == null)
						{
							req.LogMessage("Unable to read request for " + url);
						}
					}
				}

				//XmlDocument status = req.LoadXMLDocFromURL("http://dnadev.bu.bbc.co.uk/dna/h2g2/purexml/siteadmin");
				//status.Save("doc.xml");
				// Now do the stats call
			}
			catch (Exception e)
			{
				using (StreamWriter wr = new StreamWriter(@"GetStats.log"))
				{
					wr.WriteLine("Exception found " + DateTime.Now.ToString());
					wr.WriteLine(e.Message);
					wr.WriteLine(e.StackTrace);
					wr.WriteLine("-------------------------------");
				}
			}
        }

		public string GetConfigValue(string sSection, string sKey, XmlDocument xml)
		{
			XmlNode node = xml.SelectSingleNode("/config/" + sSection + "/" + sKey);
			if (node != null)
			{
				return node.InnerText;
			}
			else
			{
				return "";
			}
		}

    }
}
