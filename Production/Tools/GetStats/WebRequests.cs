using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Net;
using System.Net.Security;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Runtime.InteropServices;
using System.Security.Cryptography.X509Certificates;

namespace DNA.WebRequests
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class WebRequests
	{
		//private System.Windows.Forms.GroupBox groupBox1;
		//private System.Windows.Forms.Button button1;
		//private System.Windows.Forms.Label label1;
		//private System.Windows.Forms.GroupBox groupBox2;
		//private System.Windows.Forms.Splitter splitter1;
		//private System.Windows.Forms.GroupBox groupBox3;
		//private System.Windows.Forms.TextBox PathToSkins;
		//private System.Windows.Forms.Button buttonBrowse;
		//private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
		//private System.ComponentModel.IContainer components;

		//private string[] skinnames;
		//private string[] sitenames;
		private string _hostname = "";
		public string HostName
		{
			get
			{
				return _hostname;
			}
			set
			{
				_hostname = value;
			}
		}
		private string _proxy;

		public string Proxy
		{
			get { return _proxy; }
			set { _proxy = value; }
		}
		private string _port;

		public string Port
		{
			get { return _port; }
			set { _port = value; }
		}
		private bool _useproxy = false;

		public bool Useproxy
		{
			get { return _useproxy; }
			set { _useproxy = value; }
		}
		private bool _localdebug = true;

		public bool Localdebug
		{
			get { return _localdebug; }
			set { _localdebug = value; }
		}
		private string _loginname = "";

		public string Loginname
		{
			get { return _loginname; }
			set { _loginname = value; }
		}
		private string _password = "";

		public string Password
		{
			get { return _password; }
			set { _password = value; }
		}
		private string _editorpassword = "";

		public string Editorpassword
		{
			get { return _editorpassword; }
			set { _editorpassword = value; }
		}
		//private System.Windows.Forms.RichTextBox richTextBox1;
		private string _sitename = "";

		public string Sitename
		{
			get { return _sitename; }
			set { _sitename = value; }
		}
		private string _loginhost;

		public string Loginhost
		{
			get { return _loginhost; }
			set { _loginhost = value; }
		}

		private string _logfile;

		public string Logfile
		{
			get { return _logfile; }
			set { _logfile = value; }
		}

		private string _usercookie = "";

		//private SkinManager.SkinFileItem sfi1;
		//private System.Windows.Forms.CheckedListBox chServerlist;
		//private System.Windows.Forms.CheckedListBox chFilelist;
		private CookieContainer _cContainer = new CookieContainer();
		private bool _bLoggedIn = false;
		//private System.Windows.Forms.Button btnUpload;
		//private System.Windows.Forms.ListBox lbSkinList;
		//private System.Windows.Forms.ToolTip toolTip1;
		//private System.Windows.Forms.Button Cancel;
		//private bool bGotFileList = false;
		//private System.Windows.Forms.Button btnTest;
		//private System.Windows.Forms.CheckBox chSelectAll;
		//private System.Windows.Forms.CheckBox chAutoClearTemplates;

		//private bool bCancelPressed = false;
		//private System.Windows.Forms.Button btnClearTemplates;
		//private bool bAutoClearTemplates = true;
		//private System.Windows.Forms.Button btnDownloadSkin;
		//private System.Windows.Forms.Button btnDownloadAllSkins;
		//private System.Windows.Forms.OpenFileDialog browseFileDialog;
		//private System.Windows.Forms.OpenFileDialog downloadFileDialog;
		//private string sPathForDownload = "";

        private string _identityurlbase;
        private string _certname;

		public WebRequests()
        {

        }

        public void Initialize(XmlDocument xml)
        {
						/*
							 * <config>
							 *		<settings>
							 *			<loginname>DnaUser</loginname>
							 *			<editorpassword>password</editorpassword>
							 *			<hostname>www.bbc.co.uk</hostname>
							 *			<proxy>www-cache...</proxy>
							 *			<port>80</port>
							 *			<useproxy/>
							 *			<localdebug/>
							 *		</settings>
							 * </config>
							 * 
							 */
						_editorpassword = GetConfigValue("editorpassword",xml);
						_hostname = GetConfigValue("hostname",xml);
						_proxy = GetConfigValue("proxy",xml);
						_port = GetConfigValue("port",xml);
						_sitename = GetConfigValue("sitename",xml);
						_useproxy = ("True" == GetConfigValue("useproxy",xml));
						_localdebug = ("True" == GetConfigValue("localdebug",xml));
						_loginname = GetConfigValue("loginname",xml);
                        _password = GetConfigValue("loginpassword", xml);
						_loginhost = GetConfigValue("loginhost", xml);
						_logfile = GetConfigValue("logfile", xml);
                        _identityurlbase = GetConfigValue("identityurlbase", xml);
                        _certname = GetConfigValue("certname", xml);

                        ServicePointManager.ServerCertificateValidationCallback += DNAIWSAcceptCertificatePolicy;
        }

        public static bool DNAIWSAcceptCertificatePolicy(object sender,
                                        X509Certificate certificate,
                                        X509Chain chain,
                                        SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }

        private CookieContainer _cookieContainer = new CookieContainer();

        private HttpWebResponse CallRestAPI(string identityRestCall)
        {
            HttpWebResponse response = null;
            try
            {
                Uri URL = new Uri(identityRestCall);
                HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);

                webRequest.Timeout = 30000;

                if (_proxy.Length > 0)
                {
                    webRequest.Proxy = new WebProxy(_proxy);
                }

                webRequest.CookieContainer = _cookieContainer;
                X509Store store = new X509Store("My", StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                X509Certificate certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _certname, false)[0];
                webRequest.ClientCertificates.Add(certificate);
                webRequest.Method = "POST";
                response = (HttpWebResponse)webRequest.GetResponse();
            }
            catch (WebException ex)
            {
                string error = ex.Message;

                if (ex.Response != null)
                {
                    StreamReader reader = new StreamReader(ex.Response.GetResponseStream(), Encoding.UTF8);
                    error += reader.ReadToEnd();
                }

                if (ex.InnerException != null)
                {
                    error += " : " + ex.InnerException.Message;
                }
            }

            return response;
        }
        
        private string GetConfigValue(string sKey, XmlDocument xml)
		{
			XmlNode node = xml.SelectSingleNode("/config/settings/" + sKey);
			if (node != null)
			{
				return node.InnerText;
			}
			else
			{
				return "";
			}
		}

		private bool GetConfigValueBool(string sKey, XmlDocument xml)
		{
			XmlNode node = xml.SelectSingleNode("/config/settings/" + sKey);
			if (node != null)
			{
				return ("True" == node.InnerText);
			}
			else
			{
				return false;
			}
		}


        public void WriteSettings(StreamWriter writer)
		{
				writer.WriteLine("<loginname>{0}</loginname>",_loginname);
				writer.WriteLine("<editorpassword>{0}</editorpassword>", _editorpassword);
				writer.WriteLine("<hostname>{0}</hostname>", _hostname);
				writer.WriteLine("<proxy>{0}</proxy>", _proxy);
				writer.WriteLine("<port>{0}</port>", _port);
				writer.WriteLine("<useproxy>{0}</useproxy>", _useproxy);
				writer.WriteLine("<localdebug>{0}</localdebug>", _localdebug);
				writer.WriteLine("<sitename>{0}</sitename>", this._sitename);
				writer.WriteLine("<loginhost>{0}</loginhost>",this._loginhost);


        }



		public XmlDocument LoadXMLDocFromURL(string sURL)
		{
			if (sURL.StartsWith("http://") == false)
			{
				sURL = "http://" + _hostname + sURL;
			}
			HttpWebRequest wr = GetWebRequest(sURL, true);
			WebResponse wResp;
			try
			{
				wResp = wr.GetResponse();
			}
			catch(Exception e)
			{
				LogMessage(e.Message);
				return null;
			}
			
			// Get the response stream.
			Stream respStream = wResp.GetResponseStream();

			// This example uses a StreamReader to read the entire response
			// into a string and then writes the string to the console.
			StreamReader reader = 
				new StreamReader(respStream, Encoding.ASCII);
			String respHTML = reader.ReadToEnd();
			
			// Close the response and response stream.
			wResp.Close();

			using (StreamWriter sw = new StreamWriter("xmldoc.xml"))
			{
				sw.Write(respHTML);
			}
			XmlDocument doc = new XmlDocument();

			try
			{
				doc.LoadXml(respHTML);
				return doc;
			}
			catch 
			{
				return null;
			}
		}

		public HttpWebRequest GetWebRequest(string sURL, bool bAuthenticate)
		{
			Uri URL = new Uri(sURL);
			HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(URL);
			if (_useproxy)
			{
				WebProxy myProxy = new WebProxy("http://" + _proxy + ":" + _port);
				wr.Proxy = myProxy;
			}
			wr.CookieContainer = _cContainer;
			wr.PreAuthenticate = true;
			if (bAuthenticate)
			{
				NetworkCredential myCred = new NetworkCredential("editor", _editorpassword);
				CredentialCache MyCrendentialCache = new CredentialCache();
				MyCrendentialCache.Add(URL, "Basic", myCred);
				wr.Credentials = MyCrendentialCache;
			}
			wr.Timeout = 300000;
			return wr;
		}

        public void HardcodeSSOCookie(string ssoCookie)
        {
            Cookie cookie = new Cookie("SSO2-UID", ssoCookie, "/", _hostname);
            _cContainer.Add(cookie);
        }

		public void LogIntoIdentity()
		{
            string identityRestCall = _identityurlbase + "/idservices/tokens?username=" + _loginname + "&password=" + _password;
            CallRestAPI(identityRestCall);

            Uri u = new Uri(_identityurlbase);
            CookieCollection cc = _cookieContainer.GetCookies(u);
            foreach (Cookie c in cc)
            {
                string n = c.Name;
                string v = c.Value;

                Cookie cookie = new Cookie(c.Name, c.Value, "/", _hostname);
                _cContainer.Add(cookie);
            }
		}

		public bool ConnectToServer()
		{

			string LoginPath;
			if (_localdebug)
			{
				LoginPath = "http://" + _hostname + "/dna/h2g2/?d_userid=6";
				Cookie myCookie = new Cookie("H2G2USER", "H2G2DEBUG=6A", "/", _hostname);
				_cContainer.Add(myCookie);
			}
			else if (_loginhost.Length == 0)
			{
				LoginPath = "http://" + _hostname + "/cgi-perl/signon/mainscript.pl?username=" + _loginname + "&password=" + _password + "&remember_me=on&c_login=login&scratch_key=&service=" + Sitename + "&ptrt=http://" + this._hostname + "/dna/" + this._sitename + "/SSO";
			}
			else
			{
				LoginPath = "http://" + _loginhost + "/cgi-perl/signon/mainscript.pl?username=" + _loginname + "&password=" + _password + "&remember_me=on&c_login=login&scratch_key=&service=" + Sitename + "&ptrt=http://" + this._hostname + "/dna/" + this._sitename + "/SSO";
			}

			// Cope with the new behaviour of SSO - to reject any requests that don't have BBC-UID cookies

			// Get a cookie by fetching the homepage


			WebResponse wResp;
			HttpWebRequest wr;

			if (_loginhost.Length == 0)
			{
				wr = GetWebRequest("http://" + _hostname, false);
			}
			else
			{
				wr = GetWebRequest("http://" + _loginhost + "/cgi-perl/signon/mainscript.pl", false);
			}

			try
			{
				wResp = wr.GetResponse();

			}
			catch (Exception e)
			{
				LogMessage("Exception while getting UID cookie: " + e.Message);
				return false;
			}
			{
				Stream respStream = wResp.GetResponseStream();

				// This example uses a StreamReader to read the entire response
				// into a string and then writes the string to the console.
				StreamReader reader =
					new StreamReader(respStream, Encoding.ASCII);
				String respHTML = reader.ReadToEnd();
				Console.WriteLine(respHTML);
			}
			wResp.Close();

			if (!_localdebug)
			{
				wr = GetWebRequest(LoginPath, false);
				wr.AllowAutoRedirect = false;
				try
				{
					wResp = wr.GetResponse();
				}
				catch (Exception ex)
				{
					LogMessage("Exception while calling SSO mainscript: " + ex.Message);
					return false;
				}
				{
					Stream respStream = wResp.GetResponseStream();

					// This example uses a StreamReader to read the entire response
					// into a string and then writes the string to the console.
					StreamReader reader =
						new StreamReader(respStream, Encoding.ASCII);
					String respHTML = reader.ReadToEnd();
					Console.WriteLine(respHTML);
				}
				wResp.Close();
				wr = GetWebRequest("http://" + _hostname + "/dna/" + Sitename + "/SSO?ssoc=login", true);
				wr.AllowAutoRedirect = false;
				try
				{
					wResp = wr.GetResponse();

				}
				catch (Exception e)
				{
					LogMessage("Exception while calling DNA SSO page: " + e.Message);
					return false;
				} 
				WebHeaderCollection headers = wResp.Headers;
				string[] array = headers.GetValues("Set-Cookie");
				if (array != null)
				{
					for (int i = 0; i < array.Length; i++)
					{
						Match m = Regex.Match(array[i], @"H2G2USER=(........-....-....-....-............)");
						if (m.Success)
						{
							string match = m.Groups[1].ToString();
							Cookie myCookie = new Cookie("H2G2USER", match, "/", _hostname);
							_cContainer.Add(myCookie);
						}
					}
				}
				wResp.Close();

				// Read an HTTP-specific property.
				//	if (wResp is HttpWebResponse)
				//	{
				//		string Cookie = wResp.Headers.Get("Set-Cookie");
				//		Match m = Regex.Match(Cookie, @"SSO2\-UID=(..................................................................)");
				//		string mtch = m.ToString();
				//		this.UserCookie = mtch.Remove(0,9);
				//	}
				//				Stream loginrespStream = wResp.GetResponseStream();

				// This example uses a StreamReader to read the entire response
				// into a string and then writes the string to the console.
				//				StreamReader loginreader = 
				//					new StreamReader(loginrespStream, Encoding.ASCII);
				//				String loginHTML = loginreader.ReadToEnd();

				//				wResp.Close();
			}
			//Uri URL = new Uri("http://" + _hostname + "/dna/" + Sitename + "/purexml/siteadmin");

			//richTextBox1.AppendText(respHTML);
			//richTextBox1.AppendText(pagetype.InnerText);
			// First, login the user and get a cookie
			// Then get the SiteAdmin page and populate the treeview

			return true;
		}

		public void LogMessage(string message)
		{
			if (_logfile.Length > 0)
			{
				using (StreamWriter wr = new StreamWriter(_logfile, true))
				{
					wr.Write(DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss: "));
					wr.WriteLine(message);
				}
			}
		}
		
	}


	public class ServerDetails
	{
		private string ServerName;
		private string ServerPath;

		public ServerDetails()
		{
			//
		}

		public string Name
		{
			get
			{
				return this.ServerName;
			}
		}
		
		public string Path
		{
			get
			{
				return this.ServerPath;
			}
		}
		
		public ServerDetails(string sName, string sPath)
		{
			this.ServerName = sName;
			this.ServerPath = sPath;
		}
		public override string ToString()
		{
			return ServerName;
		}

	}
}

namespace norvanco.http
{
	/// <summary>
	/// Allow the transfer of data files using the W3C's specification
	/// for HTTP multipart form data.  Microsoft's version has a bug
	/// where it does not format the ending boundary correctly.
	/// Written by: gregoryp@norvanco.com
	/// </summary>
	public class MultipartForm
	{
		/// <summary>
		/// Holds any form fields and values that you
		/// wish to transfer with your data.
		/// </summary>
		private Hashtable coFormFields;
		/// <summary>
		/// Used mainly to avoid passing parameters to other routines.
		/// Could have been local to sendFile().
		/// </summary>
		protected HttpWebRequest coRequest;
		/// <summary>
		/// Used if we are testing and want to output the raw
		/// request, minus http headers, out to a file.
		/// </summary>
		System.IO.Stream coFileStream;
		
		private string _authUserName;
		/// <summary>
		/// Used to provide the Basic authentication username
		/// </summary>
		public string authUserName
		{
			get
			{
				return _authUserName;
			}
			set
			{
				_authUserName = value;
			}
		}

		private string _authPassword;
		/// <summary>
		/// password used for basic authentication
		/// </summary>
		public string authPassword
		{
			get
			{
				return _authPassword;
			}
			set
			{
				_authPassword = value;
			}
		}

		private CookieContainer _CookieJar;
		/// <summary>
		/// Supplies a cookie jar to the request so that user identity is preserved
		/// </summary>
		public CookieContainer CookieJar
		{
			get
			{
				return _CookieJar;
			}
			set
			{
				_CookieJar = value;
			}
		}

		private string _proxy;
		private bool _useproxy;
		private string _port;
		/// <summary>
		/// hostname of a proxy server to use for the request
		/// </summary>
		public string Proxy
		{
			get
			{
				return _proxy;
			}
			set
			{
				_proxy = value;
			}
		}

		/// <summary>
		/// Port number of a proxy server to use for the request
		/// </summary>
		public string Port
		{
			get
			{
				return _port;
			}
			set
			{
				_port = value;
			}
		}

		/// <summary>
		/// Sets whether to use the proxy server or not
		/// </summary>
		public bool UseProxy
		{
			get
			{
				return _useproxy;
			}
			set
			{
				_useproxy = value;
			}
		}

		/// <summary>
		/// Difined to build the form field data that is being
		/// passed along with the request.
		/// </summary>
		static string CONTENT_DISP = "Content-Disposition: form-data; name=";
		/// <summary>
		/// Allows you to specify the specific version of HTTP to use for uploads.
		/// The dot NET stuff currently does not allow you to remove the continue-100 header
		/// from 1.1 and 1.0 currently has a bug in it where it adds the continue-100.  MS
		/// has sent a patch to remove the continue-100 in HTTP 1.0.
		/// </summary>
		public Version TransferHttpVersion
		{get{return coHttpVersion;}set{coHttpVersion=value;}}
		Version coHttpVersion;

		/// <summary>
		/// Used to change the content type of the file being sent.
		/// Currently defaults to: text/xml. Other options are
		/// text/plain or binary
		/// </summary>
		public string FileContentType
		{get{return coFileContentType;}set{coFileContentType=value;}}
		string coFileContentType;

		/// <summary>
		/// Initialize our class for use to send data files.
		/// </summary>
		/// <param name="url">The web address of the recipient of the data transfer.</param>
		public MultipartForm(string url)
		{
			URL = url;
			coFormFields = new Hashtable();
			ResponseText = new StringBuilder();
			BufferSize = 1024 * 10;
			BeginBoundary = "ou812--------------8c405ee4e38917c";
			TransferHttpVersion = HttpVersion.Version11;
			FileContentType = "text/xml";
		}
		//---------- BEGIN PROPERTIES SECTION ----------
		string _BeginBoundary;
		/// <summary>
		/// The string that defines the begining boundary of
		/// our multipart transfer as defined in the w3c specs.
		/// This method also sets the Content and Ending
		/// boundaries as defined by the w3c specs.
		/// </summary>
		public string BeginBoundary
		{
			get{return _BeginBoundary;}
			set
			{
				_BeginBoundary    =value;
				ContentBoundary = "--" + BeginBoundary;
				EndingBoundary  = ContentBoundary + "--";
			}
		}
		/// <summary>
		/// The string that defines the content boundary of
		/// our multipart transfer as defined in the w3c specs.
		/// </summary>
		protected string ContentBoundary
		{get{return _ContentBoundary;}set{_ContentBoundary=value;}}
		string _ContentBoundary;
		/// <summary>
		/// The string that defines the ending boundary of
		/// our multipart transfer as defined in the w3c specs.
		/// </summary>
		protected string EndingBoundary
		{get{return _EndingBoundary;}set{_EndingBoundary=value;}}
		string _EndingBoundary;
		/// <summary>
		/// The data returned to us after the transfer is completed.
		/// </summary>
		public StringBuilder ResponseText
		{get{return _ResponseText;}set{_ResponseText=value;}}
		StringBuilder _ResponseText;
		/// <summary>
		/// The web address of the recipient of the transfer.
		/// </summary>
		public string URL
		{get{return _URL;}set{_URL = value;}}
		string _URL;
		/// <summary>
		/// Allows us to determine the size of the buffer used
		/// to send a piece of the file at a time out the IO
		/// stream.  Defaults to 1024 * 10.
		/// </summary>
		public int BufferSize
		{get{return _BufferSize;}set{_BufferSize = value;}}
		int _BufferSize;
		//---------- END PROPERTIES SECTION ----------
		/// <summary>
		/// Used to signal we want the output to go to a
		/// text file verses being transfered to a URL.
		/// </summary>
		/// <param name="path"></param>
		public void setFilename(string path)
		{
			coFileStream = new
				System.IO.FileStream(path,FileMode.Create,FileAccess.Write);
		}
		/// <summary>
		/// Allows you to add some additional field data to be
		/// sent along with the transfer.  This is usually used
		/// for things like userid and password to validate the
		/// transfer.
		/// </summary>
		/// <param name="key">The form field name</param>
		/// <param name="str">The form field value</param>
		public void setField(string key, string str)
		{
			coFormFields[key] = str;
		}
		/// <summary>
		/// Determines if we have a file stream set, and returns either
		/// the HttpWebRequest stream of the file.
		/// </summary>
		/// <returns></returns>
		public virtual System.IO.Stream getStream()
		{
			System.IO.Stream io;
			if( null == coFileStream )
				io = coRequest.GetRequestStream();
			else
				io = coFileStream;
			return io;
		}
		/// <summary>
		/// Here we actually make the request to the web server and
		/// retrieve it's response into a text buffer.
		/// </summary>
		public virtual void getResponse()
		{
			if( null == coFileStream )
			{
				System.IO.Stream io;
				WebResponse oResponse;
				try
				{
					oResponse = coRequest.GetResponse();
				}
				catch(WebException web )
				{
					oResponse = web.Response;
				}
				if( null != oResponse )
				{
					io = oResponse.GetResponseStream();
					StreamReader sr = new StreamReader(io);
					string str;
					ResponseText.Length = 0;
					while( (str = sr.ReadLine()) != null )
						ResponseText.Append(str);
					oResponse.Close();
				}
				else
					throw new Exception("MultipartForm: Error retrieving server response");
			}
		}
		/// <summary>
		/// Transmits a file to the web server stated in the
		/// URL property.  You may call this several times and it
		/// will use the values previously set for fields and URL.
		/// </summary>
		/// <param name="aFilename">The full path of file being transfered.</param>
		public void sendFile(string aFilename)
		{
			// The live of this object is only good during
			//  this function.  Used mainly to avoid passing
			//  around parameters to other functions.
			coRequest = (HttpWebRequest) WebRequest.Create(URL);
			if (_useproxy)
			{
				coRequest.Proxy = new WebProxy("http://" + _proxy + ":" + _port);
			}
			// Set use HTTP 1.0 or 1.1.
			coRequest.ProtocolVersion = TransferHttpVersion;
			coRequest.Method = "POST";
			coRequest.ContentType = "multipart/form-data; boundary=" +
				BeginBoundary;
			coRequest.CookieContainer = _CookieJar;
			if ("" != _authUserName)
			{
				coRequest.PreAuthenticate = true;
				NetworkCredential myCred = new NetworkCredential(_authUserName, _authPassword);
				CredentialCache MyCrendentialCache = new CredentialCache();
				Uri aURL = new Uri(URL);
				MyCrendentialCache.Add(aURL, "Basic", myCred);
				coRequest.Credentials = MyCrendentialCache;
			}
			coRequest.Headers.Add("Cache-Control","no-cache");
			coRequest.KeepAlive = true;
			string strFields = getFormfields();
			string strFileHdr = getFileheader(aFilename);
			string strFileTlr = getFiletrailer();
			FileInfo info = new FileInfo(aFilename);
			coRequest.ContentLength = strFields.Length +
				strFileHdr.Length +
				strFileTlr.Length +
				info.Length;
			System.IO.Stream io;
			io = getStream();
			writeString(io,strFields);
			writeString(io,strFileHdr);
			this.writeFile(io, aFilename);
			writeString(io,strFileTlr);
			getResponse();
			io.Close();
			// End the life time of this request object.
			coRequest = null;
		}

		/// <summary>
		/// Transmits a file to the web server stated in the
		/// URL property.  You may call this several times and it
		/// will use the values previously set for fields and URL.
		/// </summary>
		/// <param name="Filenames">An array of filenames to upload in one request.</param>
		public void sendFile(string[] Filenames)
		{
			// The live of this object is only good during
			//  this function.  Used mainly to avoid passing
			//  around parameters to other functions.
			coRequest = (HttpWebRequest) WebRequest.Create(URL);
			if (_useproxy)
			{
				coRequest.Proxy = new WebProxy("http://" + _proxy + ":" + _port);
			}
			// Set use HTTP 1.0 or 1.1.
			coRequest.ProtocolVersion = TransferHttpVersion;
			coRequest.Method = "POST";
			coRequest.ContentType = "multipart/form-data; boundary=" +
				BeginBoundary;
			coRequest.CookieContainer = _CookieJar;
			if ("" != _authUserName)
			{
				coRequest.PreAuthenticate = true;
				NetworkCredential myCred = new NetworkCredential(_authUserName, _authPassword);
				CredentialCache MyCrendentialCache = new CredentialCache();
				Uri aURL = new Uri(URL);
				MyCrendentialCache.Add(aURL, "Basic", myCred);
				coRequest.Credentials = MyCrendentialCache;
			}
			coRequest.Headers.Add("Cache-Control","no-cache");
			coRequest.KeepAlive = true;
			string strFields = getFormfields();
			
			string strFileTlr = getFiletrailer();
			string cr = "\r\n";
			long totalfilelength = 0;
			int lastfile = Filenames.GetLength(0)-1;
			for (int i=0;i<=lastfile;i++)
			{
				string sFilename = Filenames[i];
				FileInfo info = new FileInfo(sFilename);
				totalfilelength += info.Length 
								+ getFileheader(sFilename).Length;
				if (i != lastfile)
				{
					totalfilelength += cr.Length;
				}				
			}
			totalfilelength += strFileTlr.Length;

			
			//string strFileHdr = getFileheader(aFilename);
			coRequest.ContentLength = strFields.Length +
				totalfilelength;
		//		strFileHdr.Length +
		//		strFileTlr.Length +
		//		info.Length;
			System.IO.Stream io;
			io = getStream();
			writeString(io,strFields);
			for (int i=0;i<=lastfile;i++)
			{
				string sFilename = Filenames[i];
				writeString(io,getFileheader(sFilename));
				this.writeFile(io, sFilename);
				if (i != lastfile)
				{
					writeString(io,cr);
				}
			}
			writeString(io,strFileTlr);
			getResponse();
			io.Close();
			// End the life time of this request object.
			coRequest = null;
		}

		
		
		/// <summary>
		/// Mainly used to turn the string into a byte buffer and then
		/// write it to our IO stream.
		/// </summary>
		/// <param name="io">The io stream for output.</param>
		/// <param name="str">The data to write.</param>
		public void writeString(System.IO.Stream io, string str)
		{
			byte[] PostData = System.Text.Encoding.ASCII.GetBytes(str);
			io.Write(PostData,0,PostData.Length);
		}
		/// <summary>
		/// Builds the proper format of the multipart data that
		/// contains the form fields and their respective values.
		/// </summary>
		/// <returns>The data to send in the multipart upload.</returns>
		public string getFormfields()
		{
			string str="";
			IDictionaryEnumerator myEnumerator = coFormFields.GetEnumerator();
			while ( myEnumerator.MoveNext() )
			{
				str += ContentBoundary + "\r\n" +
					CONTENT_DISP + '"' + myEnumerator.Key + "\"\r\n\r\n" +
					myEnumerator.Value + "\r\n";
			}
			return str;
		}
		/// <summary>
		/// Returns the proper content information for the
		/// file we are sending.
		/// </summary>
		/// <remarks>
		/// Hits Patel reported a bug when used with ActiveFile.
		/// Added semicolon after sendfile to resolve that issue.
		/// Tested for compatibility with IIS 5.0 and Java.
		/// </remarks>
		/// <param name="aFilename"></param>
		/// <returns></returns>
		public string getFileheader(string aFilename)
		{
			return  ContentBoundary + "\r\n" +
				CONTENT_DISP +
				"\"file\"; filename=\"" +
				Path.GetFileName(aFilename) + "\"\r\n" +
				"Content-type: " + FileContentType  + "\r\n\r\n";
		}
		/// <summary>
		/// Creates the proper ending boundary for the multipart upload.
		/// </summary>
		/// <returns>The ending boundary.</returns>
		public string getFiletrailer()
		{
			return "\r\n" + EndingBoundary;
		}
		/// <summary>
		/// Reads in the file a chunck at a time then sends it to the
		/// output stream.
		/// </summary>
		/// <param name="io">The io stream to write the file to.</param>
		/// <param name="aFilename">The name of the file to transfer.</param>
		public void writeFile(System.IO.Stream io, string aFilename)
		{
			FileStream readIn = new FileStream(aFilename, FileMode.Open,
				FileAccess.Read);
			readIn.Seek(0, SeekOrigin.Begin); // move to the start of the file
			byte[] fileData = new byte[BufferSize];
			int bytes;
			while( (bytes = readIn.Read(fileData,0, BufferSize)) > 0 )
			{
				// read the file data and send a chunk at a time
				io.Write(fileData,0,bytes);
			}
			readIn.Close();
		}
	}
}

