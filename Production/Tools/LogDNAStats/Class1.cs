using System;
using System.IO;
using System.Net;
using System.Xml;
using System.Collections;
using System.Data;
using System.Data.SqlClient;

namespace LogDNAStats
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class Class1
	{
		static private string Proxy;
		static private string AuthUsername;
		static private string AuthPassword;
		static private string EditorPassword;
		static private string Port;
		static private string dbserver;
		static private string dbname;
		static private string dbuser;
		static private string dbpassword;
		static private bool UseProxy;
		static string[] inputargs;
		static string[] pages;
        static string[] urls;
        static bool[] csharpflags;

        static string NL = Environment.NewLine;

		/// <summary>
		/// This console application fetches DNA stats information from the status page and
		/// logs them to a database.
		/// </summary>
		[STAThread]
		static void Main(string[] args)
		{
            string version = "Version " + System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();
            inputargs = args;

            if (DoesInputParamExist("-h") || DoesInputParamExist("/?"))
            {
                string help = "LogDNAStats" + NL + version;

                Console.WriteLine(help);
                return;
            }

            Console.WriteLine("LogDNAStats "+version);
            try
			{
				string filename = @"LogDNAStatsConfig.xml";
				using (StreamReader reader = new StreamReader(filename))
				{
					string docstring = reader.ReadToEnd();
					
					XmlDocument xml = new XmlDocument();
					try
					{
						xml.LoadXml(docstring);
                        /*
                            <?xml version="1.0" encoding="utf-8" ?> 
                              <config>
                                    <settings>
                                        <username>DnaUser</username>
                                        <password>authpassword</password>
                                        <editorpassword>password</editorpassword>
                                        <proxy>gatef-rth.mh.bbc.co.uk</proxy>
                                        <port>80</port>
                                        <useproxy>true</useproxy>
                                        <dbserver>.</dbserver>
                                        <dbname>Stats</dbname>
                                        <dbuser>stats</dbuser>
                                        <dbpassword>numb3rs</dbpassword>
                                        <pages>
                                            <page name='narthur1'  csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur1/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur2'  csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur2/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur3'  csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur3/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur4'  csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur4/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur8'  csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur8/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur9'  csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur9/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur10' csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur10/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur11' csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur11/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur12' csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur12/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur13' csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur13/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur14' csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur14/h2g2/purexml/status-n?interval=1</page>
                                            <page name='narthur15' csharp='1'>http://www.bbc.co.uk/h2g2/servers/narthur15/h2g2/purexml/status-n?interval=1</page>

                                            <page name='narthur1'  csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur1/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur2'  csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur2/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur3'  csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur3/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur4'  csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur4/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur8'  csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur8/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur9'  csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur9/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur10' csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur10/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur11' csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur11/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur12' csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur12/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur13' csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur13/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur14' csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur14/h2g2/purexml/status?interval=1</page>
                                            <page name='narthur15' csharp='0'>http://www.bbc.co.uk/h2g2/servers/narthur15/h2g2/purexml/status?interval=1</page>
                                        </pages>							 			
                                    </settings>
                              </config>
                        */
                        AuthUsername = xml.SelectSingleNode("/config/settings/username").InnerText;
						AuthPassword = xml.SelectSingleNode("/config/settings/password").InnerText;
						EditorPassword = xml.SelectSingleNode("/config/settings/editorpassword").InnerText;
						Proxy = xml.SelectSingleNode("/config/settings/proxy").InnerText;
						Port = xml.SelectSingleNode("/config/settings/port").InnerText;
						dbserver = xml.SelectSingleNode("/config/settings/dbserver").InnerText;
						dbname = xml.SelectSingleNode("/config/settings/dbname").InnerText;
						dbuser = xml.SelectSingleNode("/config/settings/dbuser").InnerText;
						dbpassword = xml.SelectSingleNode("/config/settings/dbpassword").InnerText;
						UseProxy = ("True" == xml.SelectSingleNode("/config/settings/useproxy").InnerText);
						System.Xml.XmlNodeList nset = xml.SelectNodes("/config/settings/pages/page");
						pages = new string[nset.Count];
						urls = new string[nset.Count];
                        csharpflags = new bool[nset.Count];
						for (int i = 0; i < nset.Count; i++)
						{
                            pages[i] = nset[i].Attributes["name"].Value;
                            csharpflags[i] = int.Parse(nset[i].Attributes["csharp"].Value) == 1;
							urls[i] = nset[i].InnerText;
						}

					}
					catch (Exception e)
					{
						System.Diagnostics.Debug.WriteLine(e.Message);
                        Console.WriteLine(e.Message);
                        Console.WriteLine(e.ToString());
                    }
				}
			}
            catch (Exception e)
            {
                System.Diagnostics.Debug.WriteLine(e.Message);
                Console.WriteLine(e.Message);
                Console.WriteLine(e.ToString());
                return;
            }
            try
            {
                Proxy = GetInputParamVal("-proxy", Proxy);
                AuthUsername = GetInputParamVal("-username", AuthUsername);
                AuthPassword = GetInputParamVal("-password", AuthPassword);
                Port = GetInputParamVal("-port", Port);
                EditorPassword = GetInputParamVal("-editor", EditorPassword);
                UseProxy = false;
                if (Proxy.Length > 0)
                {
                    UseProxy = true;
                }
                //dbserver=@"ops-dna1\sql2005";
                string connectionstring = string.Format("Server={0};Database={1};User ID={2};pwd={3};application name=DNA Stats", dbserver, dbname, dbuser, dbpassword);
                SqlConnection conn = new SqlConnection(connectionstring);

                conn.Open();

                SqlCommand command = conn.CreateCommand();
                command.CommandText = "select max(Timeslice) from DNAStats where Server = @servername and csharp=@csharp";
                SqlCommand updcom = conn.CreateCommand();
                updcom.CommandText = @"INSERT INTO DNAStats(Server, Timeslice, ServerTooBusy, CacheHits, CacheMisses, AverageRequestTime, TotalRequests
									    , RawRequests, rsscachehits, rsscachemisses, ssicachehits, ssicachemisses, htmlcachehits, htmlcachemisses, nonssorequests, csharp, averageidentitytime, identityrequests)
					    VALUES(@server, @timeslice, @servertoobusy, @cachehits, @cachemisses, @averagerequesttime, @totalrequests
							    , @rawrequests, @rsscachehits, @rsscachemisses, @ssicachehits, @ssicachemisses, @htmlcachehits, @htmlcachemisses, @nonssorequests, @csharp, @averageidentitytime, @identityrequests)";

                for (int i = 0; i < pages.Length; i++)
                {
                    Console.Write("Server: {0} - {1}", pages[i], csharpflags[i] ? "C#" : "C++");
                    command.Parameters.Clear();
                    command.Parameters.Add("@servername", SqlDbType.VarChar, 50).Value = pages[i];
                    command.Parameters.Add("@csharp", SqlDbType.Int).Value = csharpflags[i] ? 1 : 0;
                    SqlDataReader dreader = command.ExecuteReader();
                    bool bNoData = true;
                    DateTime maxdate = DateTime.Now;
                    if (dreader.Read())
                    {
                        bNoData = dreader.IsDBNull(0);
                        if (!bNoData)
                        {
                            maxdate = dreader.GetDateTime(0);
                        }
                    }
                    dreader.Close();

                    HttpWebRequest req = GetWebRequest(urls[i], false);
                    XmlDocument status;
                    try
                    {
                        Console.Write(" - requesting");
                        WebResponse resp = req.GetResponse();
                        Stream respStream = resp.GetResponseStream();
                        StreamReader sreader =
                            new StreamReader(respStream);

                        Console.Write(" - reading response");
                        string xmlfile = sreader.ReadToEnd();
                        sreader.Close();
                        resp.Close();
                        status = new XmlDocument();
                        status.LoadXml(xmlfile);
                    }
                    catch (Exception e)
                    {

                        // If there's an exception, just leave this one - it'll get the data next run
                        Console.WriteLine("Got exception");
                        Console.WriteLine("Exception: {0}", e.Message);
                        continue;
                    }

                    // Right. We've got the latest timeslice. We need to get all the remaining slices up to (but not including) the current slice
                    // However, we have to cope with crossing the midnight boundary. This should be reasonably easy. Take the current time
                    // from the xml file. All slices prior to this one are immediately prior to the current date. All slices after the current date
                    // are from the previous day. So if we simply scan forward, calculating the actual slice datetime, and inserting the values
                    // if we don't already have them

                    XmlNode datenode = status.SelectSingleNode("/H2G2/STATUS-REPORT/STATISTICS/CURRENTDATE/DATE");

                    // curdatetime is the current date and time according to the status page (rather than using the local
                    // time on this machine, which could so easily be wrong.
                    DateTime curdatetime = new DateTime(Convert.ToInt32(datenode.Attributes["YEAR"].Value),
                        Convert.ToInt32(datenode.Attributes["MONTH"].Value),
                        Convert.ToInt32(datenode.Attributes["DAY"].Value),
                        Convert.ToInt32(datenode.Attributes["HOURS"].Value),
                        Convert.ToInt32(datenode.Attributes["MINUTES"].Value), 0);

                    // curdaystart is the start of this current day
                    DateTime curdaystart = new DateTime(Convert.ToInt32(datenode.Attributes["YEAR"].Value),
                        Convert.ToInt32(datenode.Attributes["MONTH"].Value),
                        Convert.ToInt32(datenode.Attributes["DAY"].Value), 0, 0, 0);

                    // prevdaystart is the start of yesterday - for handling those data items *after* the current times
                    DateTime prevdaystart = curdaystart.AddDays(-1);

                    // curtime is the string representation of the current time in hours:minutes
                    string curtime = datenode.Attributes["HOURS"].Value + ":" + datenode.Attributes["MINUTES"].Value;

                    Console.WriteLine(" - inserting");
                    // get all the statistics items in the XML
                    XmlNodeList slices = status.SelectNodes("/H2G2/STATUS-REPORT/STATISTICS/STATISTICSDATA");
                    foreach (XmlNode thisnode in slices)
                    {
                        // Get the data values
                        int servertoobusy = Convert.ToInt32(thisnode.SelectSingleNode("SERVERBUSYCOUNT").InnerText);
                        int cachehits = Convert.ToInt32(thisnode.SelectSingleNode("CACHEHITS").InnerText);
                        int cachemisses = Convert.ToInt32(thisnode.SelectSingleNode("CACHEMISSES").InnerText);
                        int averagerequesttime = Convert.ToInt32(thisnode.SelectSingleNode("AVERAGEREQUESTTIME").InnerText);
                        int totalrequests = Convert.ToInt32(thisnode.SelectSingleNode("REQUESTS").InnerText);
                        string slicetime = thisnode.Attributes["INTERVALSTARTTIME"].Value;
                        int rawrequests = Convert.ToInt32(thisnode.SelectSingleNode("RAWREQUESTS").InnerText);
                        int rsscachehits = Convert.ToInt32(thisnode.SelectSingleNode("RSSCACHEHITS").InnerText);
                        int rsscachemisses = Convert.ToInt32(thisnode.SelectSingleNode("RSSCACHEMISSES").InnerText);
                        int ssicachehits = Convert.ToInt32(thisnode.SelectSingleNode("SSICACHEHITS").InnerText);
                        int ssicachemisses = Convert.ToInt32(thisnode.SelectSingleNode("SSICACHEMISSES").InnerText);
                        int htmlcachehits = Convert.ToInt32(thisnode.SelectSingleNode("HTMLCACHEHITS").InnerText);
                        int htmlcachemisses = Convert.ToInt32(thisnode.SelectSingleNode("HTMLCACHEMISSES").InnerText);
                        int nonssorequests = Convert.ToInt32(thisnode.SelectSingleNode("NONSSOREQUESTS").InnerText);
                        bool csharp = csharpflags[i];
                        int averageidentitytime = Convert.ToInt32(thisnode.SelectSingleNode("AVERAGEIDENTITYTIME").InnerText);
                        int identityrequests = Convert.ToInt32(thisnode.SelectSingleNode("IDENTITYREQUESTS").InnerText);

                        // tspan is the timespan of this timeslice (from midnight)
                        TimeSpan tspan = new TimeSpan(Convert.ToInt32(slicetime.Substring(0, 2)), Convert.ToInt32(slicetime.Substring(3, 2)), 0);
                        DateTime slicedate = curdaystart;

                        // compare this slice time to the current time. If it's less, then add it to today, if it's greater, add it to yesterday
                        // if it's the same, don't try to collect the data yet
                        int cmp = slicetime.CompareTo(curtime);
                        if (cmp <= 0)
                        {
                            slicedate = curdaystart.Add(tspan);
                        }
                        else if (cmp > 0)
                        {
                            slicedate = prevdaystart.Add(tspan);
                        }

                        // only try to log the data if this isn't the current time
                        if (cmp != 0)
                        {
                            if (bNoData || slicedate > maxdate)
                            {
                                updcom.Parameters.Clear();
                                updcom.Parameters.Add("@server", SqlDbType.VarChar, 50).Value = pages[i];
                                updcom.Parameters.Add("@timeslice", SqlDbType.DateTime).Value = slicedate;
                                updcom.Parameters.Add("@servertoobusy", SqlDbType.Int).Value = servertoobusy;
                                updcom.Parameters.Add("@cachehits", SqlDbType.Int).Value = cachehits;
                                updcom.Parameters.Add("@cachemisses", SqlDbType.Int).Value = cachemisses;
                                updcom.Parameters.Add("@averagerequesttime", SqlDbType.Int).Value = averagerequesttime;
                                updcom.Parameters.Add("@totalrequests", SqlDbType.Int).Value = totalrequests;
                                updcom.Parameters.Add("@rawrequests", SqlDbType.Int).Value = rawrequests;
                                updcom.Parameters.Add("@rsscachehits", SqlDbType.Int).Value = rsscachehits;
                                updcom.Parameters.Add("@rsscachemisses", SqlDbType.Int).Value = rsscachemisses;
                                updcom.Parameters.Add("@ssicachehits", SqlDbType.Int).Value = ssicachehits;
                                updcom.Parameters.Add("@ssicachemisses", SqlDbType.Int).Value = ssicachemisses;
                                updcom.Parameters.Add("@htmlcachehits", SqlDbType.Int).Value = htmlcachehits;
                                updcom.Parameters.Add("@htmlcachemisses", SqlDbType.Int).Value = htmlcachemisses;
                                updcom.Parameters.Add("@nonssorequests", SqlDbType.Int).Value = nonssorequests;
                                updcom.Parameters.Add("@csharp", SqlDbType.Int).Value = csharp;
                                updcom.Parameters.Add("@averageidentitytime", SqlDbType.Int).Value = averageidentitytime;
                                updcom.Parameters.Add("@identityrequests", SqlDbType.Int).Value = identityrequests;

                                updcom.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                Console.WriteLine(e.ToString());
                return;
            }
		}

        private static string GetInputParamVal(string pname, string defaultval)
        {
            int i = 0;
            while ((i + 1) < inputargs.Length)
            {
                if (pname.Equals(inputargs[i]))
                {
                    return inputargs[i + 1];
                }
            }
            return "";
        }

        private static bool DoesInputParamExist(string pname)
        {
            for (int i = 0; i < inputargs.Length;i++)
            {
                if (pname.Equals(inputargs[i]))
                {
                    return true;
                }
            }
            return false;
        }

		private static HttpWebRequest GetWebRequest(string sURL, bool bAuthenticate)
		{
			Uri URL = new Uri(sURL);
			HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(URL);
			if (UseProxy)
			{
				WebProxy myProxy = new WebProxy("http://" + Proxy + ":" + Port);
				wr.Proxy = myProxy;
			}
			//wr.CookieContainer = cContainer;
			wr.PreAuthenticate = true;
			if (bAuthenticate)
			{
				
				NetworkCredential myCred;
				if (AuthUsername.Length > 0)
				{
					myCred = new NetworkCredential(AuthUsername, AuthPassword);
				}
				else
				{
					myCred = new NetworkCredential("editor", EditorPassword);
				}
				CredentialCache MyCrendentialCache = new CredentialCache();
				MyCrendentialCache.Add(URL, "Basic", myCred);
				wr.Credentials = MyCrendentialCache;
			}
			return wr;
		}
	}
}
