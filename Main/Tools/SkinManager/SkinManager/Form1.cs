using System;
using System.Drawing;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Net;
using System.Web;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;

namespace SkinManager
{
    public partial class Form1 : Form
    {
        private string[] _skinNames;
        private string _hostName = String.Empty;
        private string _proxy;
        private string _port;
        private bool _useProxy = false;
        private bool _localDebug = true;
        private bool _iDLogin = false;
        private string _loginName = String.Empty;
        private string _password = String.Empty;
        private string _editorPassword = String.Empty;
        private string _siteName = String.Empty;
        private string _loginHost = String.Empty;
        private bool _loggedIn = false;
        private bool _gotFileList = false;
        private bool _cancelPressed = false;
        private bool _autoClearTemplates = true;
        private string _pathForDownload = String.Empty;
        private CookieContainer _cookieContainer = null;
        private string _IdentityServerBaseUri = "https://api.live.bbc.co.uk/idservices";
        private string _webServiceCertificationName = "dna live";
        private static string _iDproxy = "http://10.152.4.180:80";
        private string _cookieValue = String.Empty;


        /// <summary>
        /// The cert callback method
        /// </summary>
        /// <param name="sender">who sent the cert</param>
        /// <param name="certificate">the cert itself</param>
        /// <param name="chain">the chain the cert had to go through</param>
        /// <param name="sslPolicyErrors">any errors</param>
        /// <returns>True if we like the cert, false if not</returns>
        static public bool AcceptAllCertificatePolicy(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; }

        private List<string> _filesToUpload = new List<string>();
        
        public Form1()
        {
            InitializeComponent();

 			try
			{
				string filename = Application.UserAppDataPath + @"\config.xml";
				using (StreamReader reader = new StreamReader(filename))
				{
					string docstring = reader.ReadToEnd();
					
					XmlDocument xml = new XmlDocument();
					try
					{
						xml.LoadXml(docstring);
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
                        _loginName = xml.SelectSingleNode("/config/settings/loginname").InnerText;
						_editorPassword = xml.SelectSingleNode("/config/settings/editorpassword").InnerText;
						_hostName = xml.SelectSingleNode("/config/settings/hostname").InnerText;
						_proxy = xml.SelectSingleNode("/config/settings/proxy").InnerText;
						_port = xml.SelectSingleNode("/config/settings/port").InnerText;
						_siteName = xml.SelectSingleNode("/config/settings/sitename").InnerText;
						_useProxy = ("True" == xml.SelectSingleNode("/config/settings/useproxy").InnerText);
                        _localDebug = ("True" == xml.SelectSingleNode("/config/settings/localdebug").InnerText);
                        _iDLogin = ("True" == xml.SelectSingleNode("/config/settings/idlogin").InnerText);
                        this.PathToSkins.Text = xml.SelectSingleNode("/config/settings/pathtoskins").InnerText;
						browseFileDialog.InitialDirectory = this.PathToSkins.Text;
						_pathForDownload = xml.SelectSingleNode("/config/settings/pathfordownload").InnerText;
						downloadFileDialog.InitialDirectory = _pathForDownload;
						_loginName = GetConfigValue("loginname",xml);
						this._loginHost = GetConfigValue("loginhost", xml);
						_autoClearTemplates = GetConfigValueBool("autocleartemplates",xml);
						PopulateFiles();
						chAutoClearTemplates.Checked = _autoClearTemplates;

						this.Text = "Not connected";

                        ServicePointManager.ServerCertificateValidationCallback += AcceptAllCertificatePolicy;
                    }
					catch (Exception e)
					{
						System.Diagnostics.Debug.WriteLine(e.Message);
					}
				}
			}
			catch
			{
			}       
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

        private void Form1_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            WriteSettings();
        }

        private void WriteSettings()
        {
            string filename = Application.UserAppDataPath + @"\config.xml";
            using (StreamWriter writer = new StreamWriter(filename))
            {
                writer.WriteLine("<config>");
                writer.WriteLine("<settings>");
                writer.WriteLine("<loginname>{0}</loginname>", _loginName);
                writer.WriteLine("<editorpassword>{0}</editorpassword>", _editorPassword);
                writer.WriteLine("<hostname>{0}</hostname>", _hostName);
                writer.WriteLine("<proxy>{0}</proxy>", _proxy);
                writer.WriteLine("<port>{0}</port>", _port);
                writer.WriteLine("<useproxy>{0}</useproxy>", _useProxy);
                writer.WriteLine("<localdebug>{0}</localdebug>", _localDebug);
                writer.WriteLine("<sitename>{0}</sitename>", this._siteName);
                writer.WriteLine("<pathtoskins>{0}</pathtoskins>", this.PathToSkins.Text);
                writer.WriteLine("<pathfordownload>{0}</pathfordownload>", _pathForDownload);
                writer.WriteLine("<loginhost>{0}</loginhost>", this._loginHost);
                writer.WriteLine("<autocleartemplates>{0}</autocleartemplates>", this._autoClearTemplates);
                writer.WriteLine("<idlogin>{0}</idlogin>", _iDLogin);
                writer.WriteLine("</settings>");
                writer.WriteLine("</config>");

            }
        }

        private void Connect_Click(object sender, EventArgs e)
        {
            LoginDetails login = new LoginDetails();
            login.Hostname = _hostName;
            login.LoginName = _loginName;
            login.Proxy = _proxy;
            login.UseProxy = _useProxy;
            login.Port = _port;
            login.Password = _password;
            login.EditorPassword = _editorPassword;
            login.Sitename = _siteName;
            login.LoginHost = _loginHost;
            login.LocalDebug = _localDebug;
            login.iDLogin = _iDLogin;

            DialogResult result = login.ShowDialog();
            if (result == DialogResult.OK)
            {
                _hostName = login.Hostname;
                _loginName = login.LoginName;
                _proxy = login.Proxy;
                _useProxy = login.UseProxy;
                _port = login.Port;
                _password = login.Password;
                _editorPassword = login.EditorPassword;
                _siteName = login.Sitename;
                _loginHost = login.LoginHost;
                _localDebug = login.LocalDebug;
                _iDLogin = login.iDLogin;
                label1.Text = "Host: " + _hostName + ", Proxy: " + _proxy + ":" + _port + "\n"
                    + "Login: " + _loginName + ", Site: " + _siteName;
                label1.Text += "\nLog file: " + GetLogFile();
                ConnectToServer();

                this.Text = GetFriendlyHostname(_hostName);
            }
        }

        private string GetFriendlyHostname(string hostName)
        {
            string friendlyName = "";
            if (hostName == "www.bbc.co.uk")
            {
                friendlyName = "Live Site";
            }
            else if (hostName == "www0.bbc.co.uk")
            {
                friendlyName = "Staging Server";
            }
            else if (hostName == "dna-staging.bbc.co.uk")
            {
                friendlyName = "Staging Server";
            }
            else if (hostName == "dna-extdev.bbc.co.uk")
            {
                friendlyName = "Ext Dev Server";
            }
            else if (hostName == "local.bbc.co.uk")
            {
                friendlyName = "Local Server";
            }

            friendlyName += " (" + hostName + ")";

            return friendlyName;
        }

        private void buttonBrowse_Click(object sender, EventArgs e)
        {
            if (this.browseFileDialog.ShowDialog() == DialogResult.OK)
            {
                string dir = Path.GetDirectoryName(this.browseFileDialog.FileName);
                this.PathToSkins.Text = dir;
                PopulateFiles();
            }
            if (_gotFileList && _loggedIn)
            {
                btnUpload.Enabled = true;
                this.btnDownloadSkin.Enabled = true;
                this.btnTest.Enabled = true;
                this.btnDownloadAllSkins.Enabled = true;
                this.btnClearTemplates.Enabled = true;
            }
        }

        private void PopulateFiles()
        {
            string dir = this.PathToSkins.Text;
            DirectoryInfo dInfo = new DirectoryInfo(dir);
            if (dInfo.Exists)
            {
                directoryStructure.Nodes.Clear();
                directoryStructure.Nodes.Add(dir);

                PopulateDirectoryStructure(directoryStructure.Nodes[0], dir);

                _gotFileList = true;
            }
        }

        private void PopulateDirectoryStructure(TreeNode parent, string startLevelDirectory)
        {
            string[] directories = Directory.GetDirectories(startLevelDirectory);
            try
            {
                if (directories.Length != 0)
                {
                    foreach (string directory in directories)
                    {
                        string subDirectory = directory.Substring(directory.LastIndexOf('\\') + 1, directory.Length - directory.LastIndexOf('\\') - 1);

                        TreeNode subNode = new TreeNode(subDirectory);

                        parent.Nodes.Add(subNode);

                        PopulateDirectoryStructure(subNode, directory);
                    }
                }
                //Right done the directories now do the files
                string[] files = Directory.GetFiles(startLevelDirectory);
                if (files.Length != 0)
                {
                    foreach (string file in files)
                    {
                        string filename = file.Substring(file.LastIndexOf('\\') + 1, file.Length - file.LastIndexOf('\\') - 1);
                        TreeNode newNode = parent.Nodes.Add(filename);

                        //Don't pre select the files as we will always only do a sub set of them
                        /*
                         * if (".xsl" == Path.GetExtension(filename) || ".xml" == Path.GetExtension(filename))
                        {
                            newNode.Checked = !FileExcludedFromAutoSelect(filename);
                        }
                         */
                    }
                }
            }
            catch (UnauthorizedAccessException)
            {
                parent.Nodes.Add("Access denied");
            }
        }
        // Updates all child tree nodes recursively.
        private void CheckAllChildNodes(TreeNode treeNode, bool nodeChecked)
        {
            if (FileExcludedFromAutoSelect(treeNode.Text))
            {
                if (nodeChecked)
                {
                    DialogResult ds = MessageBox.Show("Are you sure you want to upload " + treeNode.Text + "?  This file is usually site-specific"
                        , "DANGER Will Robinson", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                    if (ds != DialogResult.Yes)
                    {
                        treeNode.Checked = nodeChecked;
                    }
                }
                else
                {
                    treeNode.Checked = nodeChecked;
                }
            }
            else
            {
                treeNode.Checked = nodeChecked;
            }

            if (treeNode.Nodes.Count > 0)
            {
                foreach (TreeNode node in treeNode.Nodes)
                {
                    // If the current node has child nodes, call the CheckAllChildsNodes method recursively.
                    this.CheckAllChildNodes(node, nodeChecked);
                }
            }
        }

        // NOTE   This code can be added to the BeforeCheck event handler instead of the AfterCheck event.
        // After a tree node's Checked property is changed, all its child nodes are updated to the same value.
        private void directoryStructure_AfterCheck(object sender, TreeViewEventArgs e)
        {
            // The code only executes if the user caused the checked state to change.
            if (e.Action != TreeViewAction.Unknown)
            {
                if (e.Node.Nodes.Count > 0)
                {
                    /* Calls the CheckAllChildNodes method, passing in the current 
                    Checked value of the TreeNode whose checked state changed. */
                    this.CheckAllChildNodes(e.Node, e.Node.Checked);
                }
            }
        }

        protected string GetNodeDirectory(TreeNode node)
        {
            TreeNode tmpNode = node;
            string directory = String.Empty;

            while (tmpNode != null)
            {
                if (tmpNode.Text[tmpNode.Text.Length - 1] != '\\')
                {
                    directory = "\\" + directory;
                }
                if (tmpNode.Nodes.Count != 0)
                {
                    directory = tmpNode.Text + directory;
                }
                else
                {
                    directory = tmpNode.Text;
                }
                tmpNode = tmpNode.Parent;
            }
            return directory;
        }

        private void GetCheckedFiles(TreeNode treeNode, List<string> checkedFiles)
        {
            foreach (TreeNode node in treeNode.Nodes)
            {
                if (node.Checked)
                {
                    string path = String.Empty;
                    path = GetNodeDirectory(node);
                    if (!path.EndsWith("\\")) //skip actual directories
                    {
                        checkedFiles.Add(path);
                    }
                }
                if (node.Nodes.Count > 0)
                {
                    // If the current node has child nodes, call the CheckAllChildsNodes method recursively.
                    this.GetCheckedFiles(node, checkedFiles);
                }
            }
        }

        private void GetListViewCheckedFileCount(TreeNode treeNode, int count)
        {
            foreach (TreeNode node in treeNode.Nodes)
            {
                if (node.Checked)
                {
                    count++;
                }
                if (node.Nodes.Count > 0)
                {
                    // If the current node has child nodes, call the CheckAllChildsNodes method recursively.
                    this.GetListViewCheckedFileCount(node, count);
                }
            }
        }
        // When the Connect button is clicked, perform a connection and
        // populate the rest of the dialog box
        private bool ConnectToServer()
        {
            _cookieContainer = new CookieContainer();

            richTextBox1.Clear();
            if (_iDLogin)
            {
                _loggedIn = ConnectToServerViaID();
            }
            else
            {
                _loggedIn = ConnectToServerViaSSO();
            }

            if (!_loggedIn)
            {
                return false;
            }

            // Read the sitemap.xml file, and default to a standard single server if not found
            XmlDocument doc = new XmlDocument();
            doc = null;
            doc = LoadXMLDocFromURL("http://" + _hostName + "/dna/-/skins/base/sitemap.xml");
            //doc = LoadXMLDocFromURL("http://www.bbc.co.uk/h2g2/servers/narthur8/-/skins/base/sitemap.xml");
            chServerlist.Items.Clear();

            if (doc != null)
            {
                XmlNodeList list = doc.SelectNodes("/site/server");
                foreach (XmlNode site in list)
                {
                    string sName = site.SelectSingleNode("name").InnerText;
                    string sPath = site.SelectSingleNode("urlroot").InnerText;
                    chServerlist.Items.Add(new ServerDetails(sName, sPath), true);
                }
            }
            else
            {
                chServerlist.Items.Add(new ServerDetails("SERVER", "/dna/"), true);
            }

            if (_loggedIn && _gotFileList)
            {
                btnUpload.Enabled = true;
                this.btnTest.Enabled = true;
                this.btnDownloadSkin.Enabled = true;
                this.btnDownloadAllSkins.Enabled = true;
                this.btnClearTemplates.Enabled = true;
            }
            return true;
        }


        private bool ConnectToServerViaID()
        {
            return LoginViaID();
        }

        private bool LoginViaID()
        {
            Dictionary<string, string> _postParams = new Dictionary<string, string>();
            List<Cookie> cookies = new List<Cookie>();

            _postParams.Clear();
            _postParams.Add("username", _loginName);
            _postParams.Add("password", _password);

            HttpWebResponse response = CallIdentityRestAPI("/sessions", _postParams, cookies, "POST");

            foreach (Cookie c in response.Cookies)
            {
                cookies.Add(c);
                _cookieContainer.Add(new Cookie(c.Name, c.Value, "/", _hostName));
                if (c.Name == "IDENTITY")
                {
                    string[] values = c.Value.Split('|');
                    _cookieContainer.Add(new Cookie("IDENTITY-USERNAME", values[1] + "|" + values[0] + "|" + values[5], "/", _hostName));
                }
                richTextBox1.AppendText(c.Name + " - " + c.Value);
                richTextBox1.AppendText("\r\n");
            }

            _postParams.Clear();
            _postParams.Add("target_resource", "http://identity/policies/dna/adult");

            response = CallIdentityRestAPI("/authorization", _postParams, cookies, "GET");

            if (response == null || response.StatusCode != HttpStatusCode.OK)
            {
                if (response == null)
                {
                    richTextBox1.AppendText("Failed to authorize user because of no response.\n");
                    richTextBox1.AppendText("\r\n");
                }
                else
                {
                    richTextBox1.AppendText("Failed to authorize user because status code = " + response.StatusCode.ToString() + "\n");
                    richTextBox1.AppendText("\r\n");
                }
                return false;
            }

            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(response.GetResponseStream());
            response.Close();

            // Check to make sure that we get a valid response and it's value is true
            if (xDoc.SelectSingleNode("//boolean") == null || xDoc.SelectSingleNode("//boolean").InnerText != "true")
            {
                // Not valid or false
                richTextBox1.AppendText("Authorize result false or null : " + response + "\n");
                richTextBox1.AppendText("\r\n");
                return false;
            }

            WebResponse wResp;
            HttpWebRequest wr;

            if (!_localDebug)
            {
                wResp = null;
                try
                {
                    wr = GetWebRequest("http://" + _hostName + "/dna/" + _siteName + "/SSO?ssoc=true?skin=purexml", true);
                    wr.AllowAutoRedirect = false;
                    wResp = wr.GetResponse();

                    xDoc.Load(wResp.GetResponseStream());
                    string match = xDoc.SelectSingleNode("//SETCOOKIE/COOKIE").InnerText;
                    Cookie myCookie = new Cookie("H2G2USER", match, "/", _hostName);
                    _cookieContainer.Add(myCookie);
                }
                catch (WebException ex)
                {
                    richTextBox1.AppendText(ex.Message + "\n");
                    return false;
                }
                catch (XmlException ex)
                {
                    richTextBox1.AppendText(ex.Message + "\n");
                    return false;
                }

                wResp.Close();
            }

            richTextBox1.AppendText("You are now logged in.\n");
            return true; //logged in
        }

        // When the Connect button is clicked, perform a connection and
        // populate the rest of the dialog box
        private bool ConnectToServerViaSSO()
        {
            string loginPath;

            if (_localDebug)
            {
                loginPath = "http://" + _hostName + "/dna/h2g2/?d_userid=6";
                Cookie myCookie = new Cookie("H2G2USER", "H2G2DEBUG=6A", "/", _hostName);
                _cookieContainer.Add(myCookie);
            }
            else if (_loginHost.Length == 0)
            {
                loginPath = "http://" + _hostName + "/cgi-perl/signon/mainscript.pl?username=" + _loginName + "&password=" + _password + "&remember_me=on&c_login=login&scratch_key=&service=" + _siteName + "&ptrt=http://" + _hostName + "/dna/" + _siteName + "/SSO";
            }
            else
            {
                loginPath = "http://" + _loginHost + "/cgi-perl/signon/mainscript.pl?username=" + _loginName + "&password=" + _password + "&remember_me=on&c_login=login&scratch_key=&service=" + _siteName + "&ptrt=http://" + _hostName + "/dna/" + _siteName + "/SSO";
            }

            // Cope with the new behaviour of SSO - to reject any requests that don't have BBC-UID cookies

            // Get a cookie by fetching the homepage


            WebResponse wResp;
            HttpWebRequest wr;

            if (_loginHost.Length == 0)
            {
                wr = GetWebRequest("http://" + _hostName, false);
            }
            else
            {
                wr = GetWebRequest("http://" + _loginHost, false);
            }
            wResp = wr.GetResponse();
            wResp.Close();

            if (!_localDebug)
            {
                wr = GetWebRequest(loginPath, false);
                wr.AllowAutoRedirect = false;
                try
                {
                    wResp = wr.GetResponse();
                    {
                        Stream respStream2 = wResp.GetResponseStream();

                        // This example uses a StreamReader to read the entire response
                        // into a string and then writes the string to the console.
                        StreamReader rstr2 =
                            new StreamReader(respStream2, Encoding.ASCII);
                        string respHTML2 = rstr2.ReadToEnd();
                        wResp.Close();
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Connect Error: " + ex.Message, "Message from Skin Manager");
                    System.Diagnostics.Debug.WriteLine(ex.Message);
                    return false;
                }
                wResp.Close();
                wr = GetWebRequest("http://" + _hostName + "/dna/" + _siteName + "/SSO?ssoc=login", true);
                wr.AllowAutoRedirect = false;
                wResp = wr.GetResponse();
                WebHeaderCollection headers = wResp.Headers;

                bool bFoundH2G2USERCookie = false;
                string[] array = headers.GetValues("Set-Cookie");
                if (array != null)
                {
                    for (int i = 0; i < array.Length; i++)
                    {
                        Match m = Regex.Match(array[i], @"H2G2USER=(........-....-....-....-............)");
                        if (m.Success)
                        {
                            string match = m.Groups[1].ToString();
                            Cookie myCookie = new Cookie("H2G2USER", match, "/", _hostName);
                            _cookieContainer.Add(myCookie);
                            bFoundH2G2USERCookie = true;
                        }
                    }
                }
                wResp.Close();

                if (!bFoundH2G2USERCookie)
                {
                    richTextBox1.AppendText("Failed to find H2G2USER cookie\r\n");
                    richTextBox1.AppendText("\r\n");
                    return false;
                }
            }
            return true; //logged in
            /* 
             * We don't need to get the skins stuff for now
             * 
             * 
            wr = GetWebRequest("http://" + _hostName + "/dna/-/skinupload.cgi?xml=1", true);
            wResp = wr.GetResponse();

            // Get the response stream.
            Stream respStream = wResp.GetResponseStream();

            // This example uses a StreamReader to read the entire response
            // into a string and then writes the string to the console.
            StreamReader reader =
                new StreamReader(respStream, Encoding.ASCII);
            String respHTML = reader.ReadToEnd();

            // Close the response and response stream.
            wResp.Close();
            XmlDocument doc = new XmlDocument();
            _loggedIn = true;

            try
            {
                doc.LoadXml(respHTML);
                // Get the pagetype - should be SITEADMIN-EDITOR

                XmlNode root = doc.SelectSingleNode("/skinupload");

                if (root != null)
                {
                    richTextBox1.AppendText("Reading site details\r\n");
                    XmlNodeList skins = doc.SelectNodes("/skinupload/sites/site");
                    _skinNames = new string[skins.Count];
                    int icount = 0;
                    foreach (XmlNode skin in skins)
                    {
                        string skinname = skin.SelectSingleNode("skin/@name").InnerText;
                        string description = skin.SelectSingleNode("@name").InnerText + " - " + skin.SelectSingleNode("skin").InnerText;
                        _skinNames[icount] = skinname;
                        icount++;
                    }
                }
                else
                {
                    _loggedIn = false;
                }
                // First, login the user and get a cookie
                // Then get the SiteAdmin page and populate the treeview
            }
            catch
            {
                _loggedIn = false;
                richTextBox1.AppendText("Failed to read the XML");
            }
             */
        }

        private XmlDocument LoadXMLDocFromURL(string sURL)
        {
            HttpWebRequest wr = GetWebRequestBasic(sURL);
            WebResponse wResp;
            try
            {
                wResp = wr.GetResponse();
            }
            catch(Exception ex)
            {
                richTextBox1.AppendText("LoadXmlDoc failed (ok on staging): " + ex.Message);
                System.Diagnostics.Debug.WriteLine(ex.Message);
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

        private void btnUpload_Click(object sender, EventArgs e)
        {
            string skinname = GetSelectedSkinName(false);
            string dirName = Path.GetFileName(PathToSkins.Text);

            if (dirName.ToLower().CompareTo("Skins") != 0)
            {
                string msg = string.Format("Your source folder name '{0}' doesn't match the root of the Skins folder.  Are you sure you want to upload?", dirName);
                DialogResult res = MessageBox.Show(msg, "Are you sure?", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation);
                if (res == DialogResult.No)
                {
                    return;
                }
            }
            else
            {
                string msg = string.Format("Are you sure you want to upload the selected skin files to server {1}?", GetFriendlyHostname(_hostName));
                DialogResult res = MessageBox.Show(msg, "Are you sure?", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (res == DialogResult.No)
                {
                    return;
                }
            }

            richTextBox1.Clear();
            _filesToUpload.Clear();

            this.Connect.Enabled = false;
            this.btnDownloadSkin.Enabled = false;
            this.btnDownloadAllSkins.Enabled = false;
            this.btnClearTemplates.Enabled = false;
            this.btnUpload.Enabled = false;
            this.Cancel.Enabled = true;
            this._cancelPressed = false;

            int serverCount = this.chServerlist.CheckedItems.Count;

            GetCheckedFiles(directoryStructure.Nodes[0], _filesToUpload);

            int fileNameCount = this._filesToUpload.Count;

            bool[,] uploaded = new bool[serverCount, fileNameCount];

            for (int i = 0; i < serverCount; i++)
            {
                for (int j = 0; j < fileNameCount; j++)
                {
                    uploaded[i, j] = false;
                }
            }

            ServerDetails[] aServers = new ServerDetails[serverCount];
            int[] iServIndex = new int[serverCount];
            for (int i = 0; i < serverCount; i++)
            {
                aServers[i] = (ServerDetails)this.chServerlist.CheckedItems[i];
                iServIndex[i] = this.chServerlist.CheckedIndices[i];
            }

            string[] aFilenames = new string[fileNameCount];
            int[] iFileIndex = new int[fileNameCount];
            for (int i = 0; i < fileNameCount; i++)
            {
                aFilenames[i] = this._filesToUpload[i];
                iFileIndex[i] = i;
            }
            uploaded = new bool[serverCount, fileNameCount];

            for (int i = 0; i < serverCount; i++)
            {
                for (int j = 0; j < fileNameCount; j++)
                {
                    uploaded[i, j] = false;
                }
            }

            DelegateUpload upload = new DelegateUpload(DoUpload);
            //upload.BeginInvoke(serverCount, fileNameCount, aServers, iServIndex, aFilenames, iFileIndex, uploaded, null, null);
            DoUpload(serverCount, fileNameCount, aServers, iServIndex, aFilenames, iFileIndex, uploaded);
        }

        delegate void DelegateUpload(int iServerCount, int iFilenameCount, ServerDetails[] aServers, int[] iServIndex, string[] aFilenames, int[] iFileName, bool[,] bUploaded);
        
        string GetLogFile()
        {
            string filename = "SkinManager-" + _hostName + ".log";
            //return @"\\ops-dna1\SkinManager\" + filename;
            return filename;
        }

        void WriteToLogFile(string s)
        {
            try
            {
                using (StreamWriter writer = new StreamWriter(GetLogFile(), true))
                {
                    writer.Write(s);
                }
            }
            catch (Exception e)
            {
                richTextBox1.AppendText("WriteToLogFile Error: " + e.Message + "\r\n");
            }
        }
        private void chSelectAll_CheckedChanged(object sender, System.EventArgs e)
        {
            if (this.directoryStructure.Nodes.Count > 0)
            {
                if (this.chSelectAll.Checked)
                {
                    CheckAllChildNodes(this.directoryStructure.Nodes[0], true);
                }
                else
                {
                    CheckAllChildNodes(this.directoryStructure.Nodes[0], false);
                }
            }
        }

        private bool FileExcludedFromAutoSelect(string fileName)
        {
            // We don't want to auto-select site.xsl, as it's usually diferent between sites
            return (fileName.ToLower().CompareTo("site.xsl") == 0);
        }

        private void lbSkinList_SelectedIndexChanged(object sender, System.EventArgs e)
        {
            this.btnUpload.Text = "Upload to " + GetSelectedSkinName(false);
        }

        delegate string GetSelectedSkinNameHandler(bool rawName);

        private string GetSelectedSkinName(bool rawName)
        {
            /*string s = _skinNames[0];
            if (s.Length == 0 && !rawName)
            {
                s = "base";
            }*/
            string s = "base";
            return s;
        }

        private void chAutoClearTemplates_CheckedChanged(object sender, System.EventArgs e)
        {
            _autoClearTemplates = chAutoClearTemplates.Checked;
        }

        delegate void DelegateClearTemplates(int iServerCount, ServerDetails[] aServers, int[] iServIndex);

        private void btClearTemplates_Click(object sender, System.EventArgs e)
        {
            int iServerCount = this.chServerlist.CheckedItems.Count;
            ServerDetails[] aServers = new ServerDetails[iServerCount];
            int[] iServIndex = new int[iServerCount];
            for (int i = 0; i < iServerCount; i++)
            {
                aServers[i] = (ServerDetails)this.chServerlist.CheckedItems[i];
                iServIndex[i] = this.chServerlist.CheckedIndices[i];
            }

            DelegateClearTemplates cleartemplates = new DelegateClearTemplates(DoClearTemplates);
            cleartemplates.BeginInvoke(iServerCount, aServers, iServIndex, null, null);
        }

        private void btnDownloadAllSkins_Click(object sender, System.EventArgs e)
        {
            // Given a selected file, download this and all included/imported files
            if (this.downloadFileDialog.ShowDialog() == DialogResult.OK)
            {
                _pathForDownload = Path.GetDirectoryName(this.downloadFileDialog.FileName);

                string mainleaf = "HTMLOutput.xsl";
                for (int i = 0; i < _skinNames.GetLength(0); i++)
                {
                    string skinname = _skinNames[i];
                    if (skinname.Length > 0)
                    {
                        string subfilesroot = _pathForDownload + @"\" + skinname;
                        DownloadSkinFile(_pathForDownload, subfilesroot, mainleaf, skinname, new SortedList(), false, "default");
                    }
                }

                mainleaf = "XMLOutput.xsl";
                for (int i = 0; i < _skinNames.GetLength(0); i++)
                {
                    string skinname = _skinNames[i];
                    if (skinname.Length > 0)
                    {
                        string subfilesroot = _pathForDownload + @"\" + skinname;
                        DownloadSkinFile(_pathForDownload, subfilesroot, mainleaf, skinname, new SortedList(), false, "default");
                    }
                }
                System.Windows.Forms.MessageBox.Show("All skin files downloaded OK", "Message from Skin Manager");
            }
        }

        class SelectItemArgs : EventArgs
        {
            public int iWhichOne;
            public bool bSelected = false;

            public SelectItemArgs(int whichserver, bool bValue)
            {
                this.iWhichOne = whichserver;
                this.bSelected = bValue;
            }
        }

        delegate void DeselectServerHandler(object sender, SelectItemArgs e);

        void DeselectServer(object sender, SelectItemArgs e)
        {
        }

        delegate void DeselectFilenameHandler(object sender, SelectItemArgs e);

        void DeselectFilename(object sender, SelectItemArgs e)
        {
        }




        private string UploadFile(string filename, string server)
        {
            string response = String.Empty;

            string URL = string.Empty;
#if DEBUG
            {
                URL = @"http://" + _hostName + server + @"dnapages/skinuploadserverpage.aspx";
            }
#else 
            {
                URL = @"http://" + _hostName + server + @"dnapages/skinuploadserverpage.aspx";
            }
#endif
            //Specifying the actual aspx page can be important.
            Uri skinUploadServerURL = new Uri(URL);

            string skinName = GetSelectedSkinName(true);

            // get the stub path from the skins directory from the filename
            string skinStubPath = filename.Remove(0, PathToSkins.Text.Length);
            skinStubPath = skinStubPath.Remove(skinStubPath.LastIndexOf("\\"));

            NameValueCollection queryString = new NameValueCollection();
            queryString["skinstubpath"] = Uri.EscapeUriString(skinStubPath);
            queryString["skinname"] = Uri.EscapeUriString(skinName);
            queryString["skin"] = "purexml";
            queryString["_si"] = "h2g2";

            response = UploadFileEx(filename, URL, "file", "text/xml", queryString, _cookieContainer);

            //response = OldUploadFile(filename, response, skinUploadServerURL, queryString);

            return response;
        }

        private string OldUploadFile(string filename, string response, Uri skinUploadServerURL, NameValueCollection queryString)
        {
            CookieAwareWebClient Client = new CookieAwareWebClient();
            NetworkCredential myCred = new NetworkCredential("editor", _editorPassword);
            CredentialCache MyCrendentialCache = new CredentialCache();
            MyCrendentialCache.Add(skinUploadServerURL, "Basic", myCred);
            Client.Credentials = MyCrendentialCache;
            if (_proxy != String.Empty)
            {
                Client.Proxy = new WebProxy("http://" + _proxy + ":" + _port);
            }
            Client.Cookies = _cookieContainer;

            Client.Headers.Add(HttpRequestHeader.ContentType, "text/xml");


            Client.QueryString.Add("skinstubpath", queryString["skinstubpath"]);
            Client.QueryString.Add("skinname", queryString["skinname"]);
            Client.QueryString.Add("skin", queryString["skin"]);

            byte[] responseArray = Client.UploadFile(skinUploadServerURL, filename);

            response = System.Text.Encoding.ASCII.GetString(responseArray);
            return response;
        }


        private string UploadFileEx(string uploadfile, string url,
            string fileFormName, string contenttype, NameValueCollection querystring,
            CookieContainer cookies)
        {
            if ((fileFormName == null) ||
                (fileFormName.Length == 0))
            {
                fileFormName = "file";
            }

            if ((contenttype == null) ||
                (contenttype.Length == 0))
            {
                contenttype = "application/octet-stream";
            }


            string postdata;
            postdata = "?";
            if (querystring != null)
            {
                foreach (string key in querystring.Keys)
                {
                    postdata += key + "=" + querystring.Get(key) + "&";
                }
            }
             
            Uri uri = new Uri(url + postdata);
            Uri uriPrefix = new Uri(url);


            string boundary = "----------" + DateTime.Now.Ticks.ToString("x");
            HttpWebRequest webrequest = (HttpWebRequest)WebRequest.Create(uri);
            webrequest.CookieContainer = cookies;
            webrequest.ContentType = "multipart/form-data; boundary=" + boundary;
            webrequest.Method = "POST";

            webrequest.KeepAlive = true;
            webrequest.Accept = @"*/*";

            NetworkCredential myCred = new NetworkCredential("editor", _editorPassword);
            CredentialCache MyCrendentialCache = new CredentialCache();
            MyCrendentialCache.Add(uriPrefix, "Basic", myCred);
            webrequest.Credentials = MyCrendentialCache;
            if (_proxy != String.Empty)
            {
                webrequest.Proxy = new WebProxy("http://" + _proxy + ":" + _port);
            }
            webrequest.ProtocolVersion = HttpVersion.Version10;

            // Build up the post message header
            StringBuilder sb = new StringBuilder();
            sb.Append("--");
            sb.Append(boundary);
            sb.Append("\r\n");
            sb.Append("Content-Disposition: form-data; name=\"");
            sb.Append(fileFormName);
            sb.Append("\"; filename=\"");
            sb.Append(Path.GetFileName(uploadfile));
            sb.Append("\"");
            sb.Append("\r\n");
            sb.Append("Content-Type: ");
            sb.Append(contenttype);
            sb.Append("\r\n");
            sb.Append("\r\n");

            string postHeader = sb.ToString();
            byte[] postHeaderBytes = Encoding.UTF8.GetBytes(postHeader);

            // Build the trailing boundary string as a byte array
            // ensuring the boundary appears on a line by itself
            byte[] boundaryBytes =
                   Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");

            FileStream fileStream = new FileStream(uploadfile,
                                        FileMode.Open, FileAccess.Read);
            long length = postHeaderBytes.Length + fileStream.Length +
                                                   boundaryBytes.Length;
            webrequest.ContentLength = length;

            Stream requestStream = webrequest.GetRequestStream();

            // Write out our post header
            requestStream.Write(postHeaderBytes, 0, postHeaderBytes.Length);

            // Write out the file contents
            byte[] buffer = new Byte[checked((uint)Math.Min(4096,
                                     (int)fileStream.Length))];
            int bytesRead = 0;
            while ((bytesRead = fileStream.Read(buffer, 0, buffer.Length)) != 0)
            {
                requestStream.Write(buffer, 0, bytesRead);
            }
            fileStream.Close();

            // Write out the trailing boundary
            requestStream.Write(boundaryBytes, 0, boundaryBytes.Length);
            WebResponse response = webrequest.GetResponse();
            Stream s = response.GetResponseStream();
            StreamReader sr = new StreamReader(s);

            return sr.ReadToEnd();
        }



        private void DoUpload(int serverCount, int filenameCount, ServerDetails[] servers, int[] serverIndex, string[] filenames, int[] fileIndex, bool[,] uploaded)
        {
            object sender = System.Threading.Thread.CurrentThread;
            RichBoxArgs rbArgs = new RichBoxArgs("", true);

            rbArgs.stringToWrite = "\r\n--------------------------------------------\r\n";
            WriteToRichBox(sender, rbArgs);
            rbArgs.clear = false;

            rbArgs.stringToWrite = DateTime.Today.ToLongDateString() + " : ";
            rbArgs.stringToWrite += DateTime.Now.ToLongTimeString() + "\r\n";
            WriteToRichBox(sender, rbArgs);

            rbArgs.stringToWrite = string.Format("Host: {0}\r\n", _hostName);
            WriteToRichBox(sender, rbArgs);

            rbArgs.stringToWrite = string.Format("Starting to Upload to the skins folder from {0}\r\n", PathToSkins.Text);
            WriteToRichBox(sender, rbArgs);

            int pass = 1;
            bool anyFailed = false;

            do
            {
                anyFailed = false;
                for (int iServerIndex = 0; iServerIndex < serverCount && rbArgs.Cancel == false; iServerIndex++)
                {
                    ServerDetails details = servers[iServerIndex];
                    rbArgs.stringToWrite = String.Concat("Uploading to ", details.Name, " (pass ", pass, ")\r\n");

                    for (int fi = 0; fi < filenameCount; fi++)
                    {
                        try
                        {
                            string webResponse = String.Empty;
                            if (!filenames[fi].EndsWith("\\")) //skip actual directories
                            {
                                webResponse = UploadFile(filenames[fi], details.Path);
                                System.Threading.Thread.Sleep(200);

                                XmlDocument response = new XmlDocument();
                                response.LoadXml(webResponse);
                               
                                XmlNode savedpath = response.SelectSingleNode("//H2G2/SKINUPLOADSERVER/SKINSSAVED/PATH");
                                if (savedpath != null)
                                {
                                    string path = savedpath.InnerText;

                                    XmlNodeList saved = response.SelectNodes("//H2G2/SKINUPLOADSERVER/SKINSSAVED/FILENAME");
                                    foreach (XmlNode node in saved)
                                    {
                                        rbArgs.stringToWrite = node.InnerText + " uploaded to " + path + " on " + details.Name + "\r\n";
                                        WriteToRichBox(sender, rbArgs);

                                    }
                                }
                                else
                                {
                                    throw new Exception("Error occured");
                                }
                            }
                        }
                        catch (Exception Ex)
                        {
                            if (filenames[fi].Contains("configuration.xsl"))
                            {
                                rbArgs.stringToWrite = "WARNING - Trying to overwrite " + filenames[fi] + "\r\n";
                                WriteToRichBox(sender, rbArgs);
                            }
                            else
                            {
                                string innermsg = String.Empty;
                                if (Ex.InnerException != null && Ex.InnerException.Message != null)
                                {
                                    innermsg = Ex.InnerException.Message;
                                }
                                anyFailed = true;
                                rbArgs.stringToWrite = Ex.Message + innermsg + " - When trying to process " + filenames[fi] + "\r\n";
                                WriteToRichBox(sender, rbArgs);
                            }
                        }
                    }
                    if (_autoClearTemplates)
                    {
                        ClearTemplates(details);
                    }
                    pass++;
                }
            } while (pass < 4 && anyFailed && rbArgs.Cancel == false);
            if (rbArgs.Cancel == false)
            {
                rbArgs.Completed = true;
                rbArgs.stringToWrite = "Finished uploading\r\n";
                WriteToRichBox(sender, rbArgs);
                if (anyFailed)
                {
                    rbArgs.stringToWrite = "Some files were not uploaded\r\n";
                    WriteToRichBox(sender, rbArgs);
                    MessageBox.Show("Upload finished. Some files were not uploaded.", "Message from Skin Manager");
                }
                else
                {
                    MessageBox.Show("Upload finished.", "Message from Skin Manager");
                }
            }
            else
            {
                rbArgs.stringToWrite = "Upload cancelled\r\n";
                WriteToRichBox(sender, rbArgs);
            }
        }

        private void ClearTemplates(ServerDetails details)
        {
            object sender = System.Threading.Thread.CurrentThread;
            RichBoxArgs rbArgs = new RichBoxArgs("Clearing templates on " + details.Name + "...\r\n");
            WriteToRichBox(sender, rbArgs);

            WebResponse wResp;
            HttpWebRequest wr;
            string s = "http://" + _hostName + details.Path + "h2g2/status?clear_templates=1&skin=purexml";
            wr = GetWebRequest(s, true);
            wResp = wr.GetResponse();
            wResp.Close();
            s = "http://" + _hostName + details.Path + "h2g2/purexml/dnastatus?clear_templates=1";
            wr = GetWebRequest(s, true);
            wResp = wr.GetResponse();
            wResp.Close();
            rbArgs.stringToWrite = "Cleared\r\n";
            WriteToRichBox(sender, rbArgs);
        }

        private void DoClearTemplates(int iServerCount, ServerDetails[] aServers, int[] iServIndex)
        {
            object sender = System.Threading.Thread.CurrentThread;

            for (int iServerIndex = 0; iServerIndex < iServerCount; iServerIndex++)
            {
                ServerDetails details = aServers[iServerIndex];
                ClearTemplates(details);
            }

            MessageBox.Show("All templates cleared", "Message from Skin Manager");
        }

        private HttpWebRequest GetWebRequestBasic(string sURL)
        {
            Uri URL = new Uri(sURL);
            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(URL);
            if (_useProxy)
            {
                WebProxy myProxy = new WebProxy("http://" + _proxy + ":" + _port);
                wr.Proxy = myProxy;
            }
            wr.CookieContainer = _cookieContainer;
            return wr;
        }

        private HttpWebRequest GetWebRequest(string sURL, bool bAuthenticate)
        {
            Uri URL = new Uri(sURL);
            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(URL);
            if (_useProxy)
            {
                WebProxy myProxy = new WebProxy("http://" + _proxy + ":" + _port);
                wr.Proxy = myProxy;
            }
            wr.CookieContainer = _cookieContainer;
            wr.Accept = "application/xml";
            wr.Timeout = 1000 * 400;
            if (bAuthenticate)
            {
                wr.PreAuthenticate = true;
                NetworkCredential myCred = new NetworkCredential("editor", _editorPassword);
                CredentialCache MyCrendentialCache = new CredentialCache();
                MyCrendentialCache.Add(URL, "Basic", myCred);
                wr.Credentials = MyCrendentialCache;
            }
            return wr;
        }

        private HttpWebRequest GetWebRequest(string sURL, bool bAuthenticate, List<Cookie> cookies)
        {
            Uri URL = new Uri(sURL);
            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(URL);
            if (_useProxy)
            {
                WebProxy myProxy = new WebProxy("http://" + _proxy + ":" + _port);
                wr.Proxy = myProxy;
            }

            wr.CookieContainer = new CookieContainer();
            foreach (Cookie c in cookies)
            {
                wr.CookieContainer.Add(new Cookie(c.Name, c.Value, "/", _hostName));
                wr.Headers.Add(c.Name, c.Value);
                if (c.Name == "IDENTITY")
                {
                    string[] values = c.Value.Split('|');
                    wr.CookieContainer.Add(new Cookie("IDENTITY-USERNAME", values[1] + "|" + values[0] + "|" + values[5], "/", _hostName));
                    wr.Headers.Add("IDENTITY-USERNAME", values[1] + "|" + values[0] + "|" + values[5]);
                }
            }

            wr.Accept = "application/xml";
            wr.Timeout = 1000 * 400;
            if (bAuthenticate)
            {
                wr.PreAuthenticate = true;
                NetworkCredential myCred = new NetworkCredential("editor", _editorPassword);
                CredentialCache MyCrendentialCache = new CredentialCache();
                MyCrendentialCache.Add(URL, "Basic", myCred);
                wr.Credentials = MyCrendentialCache;
            }
            return wr;
        }

        private void btnDownloadSkin_Click(object sender, System.EventArgs e)
        {
            // Given a selected file, download this and all included/imported files
            if (this.downloadFileDialog.ShowDialog() == DialogResult.OK)
            {
                /*_pathForDownload = Path.GetDirectoryName(this.downloadFileDialog.FileName);
                string skinname = _skinNames[0];
                string tempfilesroot = _pathForDownload;
                string subfilesroot = tempfilesroot + @"\" + skinname;

                string mainleaf = "HTMLOutput.xsl";
                DownloadSkinFile(tempfilesroot, subfilesroot, mainleaf, skinname, new SortedList(), false, "default");

                mainleaf = "XMLOutput.xsl";
                DownloadSkinFile(tempfilesroot, subfilesroot, mainleaf, skinname, new SortedList(), false, "default");

                System.Windows.Forms.MessageBox.Show("Files downloaded OK", "Message from Skin Manager");
                 * 
                 * 
                 * "http://dna-extdev.bbc.co.uk/dna/-/skins/skinsets/memoryshare/default/output.xsl";
                 * */

                _pathForDownload = Path.GetDirectoryName(this.downloadFileDialog.FileName);
                string skinname = "memoryshare";
                string skinset = "default";
                string tempfilesroot = _pathForDownload;
                string subfilesroot = tempfilesroot + @"\skinsets\" + skinname + @"\" + skinset;

                string mainleaf = "Output.xsl";
                DownloadSkinFile(tempfilesroot, subfilesroot, mainleaf, skinname, new SortedList(), false, skinset);


                mainleaf = "HTMLOutput.xsl";
                DownloadSkinFile(tempfilesroot, subfilesroot, mainleaf, skinname, new SortedList(), false, skinset);


                mainleaf = "XMLOutput.xsl";
                DownloadSkinFile(tempfilesroot, subfilesroot, mainleaf, skinname, new SortedList(), false, skinset);


            }
        }

        /// <summary>
        /// Downloads a given file from either the root or the skin directory and downloads all included files
        /// </summary>
        /// <param name="basedir">Base directory to which to save the files (usually .../skins)</param>
        /// <param name="skindir">Skin specific directory to which to save the files (usually .../skins/skinname)</param>
        /// <param name="leafname">Leafname of the file to download (possibly starting ../)</param>
        /// <param name="skinname">name of the skin</param>
        /// <param name="list">List containing those leafnames already downloaded</param>
        /// <param name="bInRoot">true if we're currently saving to the root directory, false if we're 
        /// <param name="skinset">skinset we're trying to get
        /// saving to the skin directory</param>
        private void DownloadSkinFile(string basedir, string skindir, string leafname, string skinname, SortedList list, bool bInRoot, string skinset)
        {
            HttpWebRequest wr;
            if (bInRoot)
            {
                wr = GetWebRequest("http://" + this._hostName + "/dna/-/skins/skinsets/" + skinset + "/" + leafname, true);
            }
            else
            {
                // If the leafname starts with "../" remove it, because this confuses the htaccess file
                // and ends up defaulting to the live site's file regardless of the server you are connected to
                if (leafname.StartsWith("../"))
                {
                    string newleafname = leafname.Substring(3);
                    wr = GetWebRequest("http://" + this._hostName + "/dna/-/skins/skinsets/" + skinset + "/" + newleafname, true);
                }
                else
                {
                    wr = GetWebRequest("http://" + this._hostName + "/dna/-/skins/skinsets/" + skinname + "/" + skinset + "/" + leafname, true);
                }
            }

            HttpWebResponse resp;
            try
            {
                resp = (HttpWebResponse)wr.GetResponse();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
                return;
            }
            Stream respStream = resp.GetResponseStream();
            StreamReader reader =
                new StreamReader(respStream, Encoding.Default);
            String respHTML = reader.ReadToEnd();

            // Close the response and response stream.
            resp.Close();

            // Find a path to save the skins to
            string actualdir;
            if (leafname.Substring(0, 3) == "../")
            {
                leafname = leafname.Substring(3);
                bInRoot = true;
            }
            if (bInRoot)
            {
                actualdir = basedir;
            }
            else
            {
                actualdir = skindir;
            }
            // Mark in our list that we've already got this file, so we don't try and download it again

            if (bInRoot)
            {
                list.Add("../" + leafname, "1");
            }
            else
            {
                list.Add(leafname, "1");
            }

            if (leafname.Substring(0, 6) == "pages/")
            {
                actualdir = skindir + @"\pages\";
                leafname = leafname.Substring(6);
            }
            else if (leafname.Substring(0, 8) == "objects/")
            {
                string nextleaf = leafname.Substring(8);
                int neaxtleafend = nextleaf.IndexOf('/');

                if (neaxtleafend != -1)
                {
                    string nextleafname = nextleaf.Substring(0, neaxtleafend);
                    actualdir = skindir + @"\objects\" + nextleafname + @"\";
                    leafname = nextleaf.Substring(neaxtleafend + 1);
                }
                else
                {
                    actualdir = skindir + @"\objects\";
                    leafname = leafname.Substring(8);
                }
            }
            else if (leafname.Substring(0, 7) == "inputs/")
            {
                actualdir = skindir + @"\inputs\";
                leafname = leafname.Substring(7);
            }

            System.IO.Directory.CreateDirectory(actualdir);

            try
            {
                // Write the file
                StreamWriter writer = new StreamWriter(actualdir + @"\" + leafname, false, Encoding.Default);
                writer.Write(respHTML);
                writer.Flush();
                writer.Close();

                // load it into an XML document
                XmlDocument xdoc = new XmlDocument();
                xdoc.LoadXml(respHTML);

                // find all import and include directives
                NameTable nt = new NameTable();
                XmlNamespaceManager nsmgr = new XmlNamespaceManager(nt);
                nsmgr.AddNamespace("xsl", "http://www.w3.org/1999/XSL/Transform");
                XmlNodeList nodes = xdoc.SelectNodes("//xsl:import|//xsl:include", nsmgr);
                foreach (XmlNode node in nodes)
                {
                    string incfilename = node.Attributes.GetNamedItem("href").Value;
                    if (!((bInRoot && list.ContainsKey("../" + incfilename)) || (!bInRoot && list.ContainsKey(incfilename))))
                    {
                        DownloadSkinFile(basedir, skindir, incfilename, skinname, list, bInRoot, skinset);
                    }
                    System.Diagnostics.Debug.WriteLine(incfilename);
                }
            }
            catch (Exception exception)
            {
                System.Diagnostics.Debug.WriteLine(exception.Message);
            }
        }

        private void Cancel_Click(object sender, System.EventArgs e)
        {
            this._cancelPressed = true;
        }

        class CheckedFilenameArgs : EventArgs
        {
            public int _index;
            public string _curvalue;
            public int _count;
            public CheckedFilenameArgs(int whichindex)
            {
                _index = whichindex;
            }
        }

        delegate void GetCheckedFilenameHandler(object sender, CheckedFilenameArgs a);
        void GetCheckedFilename(object sender, CheckedFilenameArgs a)
        {
            if (this.InvokeRequired == false)
            {
                a._curvalue = this.directoryStructure.Nodes[a._index].ToString();
            }
            else
            {
                GetCheckedFilenameHandler handler = new GetCheckedFilenameHandler(GetCheckedFilename);
                Invoke(handler, new object[] { sender, a });
            }
        }

        private string GetCheckedFilename(int index)
        {
            CheckedFilenameArgs a = new CheckedFilenameArgs(index);
            GetCheckedFilename(System.Threading.Thread.CurrentThread, a);
            return a._curvalue;
        }


        delegate void GetCheckedFileCountHandler(object sender, CheckedFilenameArgs a);
        void GetCheckedFileCount(object sender, CheckedFilenameArgs a)
        {
            if (this.InvokeRequired == false)
            {
                int count = 0;
                GetListViewCheckedFileCount(directoryStructure.Nodes[0], count);
                a._count = count;
            }
            else
            {
                GetCheckedFileCountHandler handler = new GetCheckedFileCountHandler(GetCheckedFileCount);
                Invoke(handler, new object[] { sender, a });
            }
        }

        private int GetCheckedFileCount()
        {
            CheckedFilenameArgs a = new CheckedFilenameArgs(0);
            GetCheckedFileCount(System.Threading.Thread.CurrentThread, a);
            return a._count;
        }

        private void btnTest_Click(object sender, System.EventArgs e)
        {
            DelegateTestUpload upload = new DelegateTestUpload(TestUpload);
            upload.BeginInvoke(_skinNames[0], null, null);
        }

        class SwapFileItemsArgs : EventArgs
        {
            public int firstindex;
            public int secondindex;

            public SwapFileItemsArgs(int ifirst, int isecond)
            {
                firstindex = ifirst;
                secondindex = isecond;
            }
        }

        delegate void SwapFileItemsHandler(object sender, SwapFileItemsArgs a);

        void SwapFileItems(object sender, SwapFileItemsArgs a)
        {
            if (this.InvokeRequired == false)
            {
                TreeNode temp = this.directoryStructure.Nodes[a.firstindex];
                this.directoryStructure.Nodes[a.firstindex] = this.directoryStructure.Nodes[a.firstindex];
                this.directoryStructure.Nodes[a.firstindex] = temp;
            }
            else
            {
                SwapFileItemsHandler handler = new SwapFileItemsHandler(SwapFileItems);
                Invoke(handler, new object[] { sender, a });
            }
        }

        delegate void DelegateTestUpload(string skinName);

        private void TestUpload(string skinname)
        {
            // Given a selected file, download this and all included/imported files
            string mainleaf;
            mainleaf = "HTMLOutput.xsl";
            object sender = System.Threading.Thread.CurrentThread;

            string rootfile = this.PathToSkins.Text + @"\" + mainleaf;
            string rootdir = this.PathToSkins.Text;

            string tempfilesroot = Application.UserAppDataPath + @"\skins";
            string subfilesroot = tempfilesroot + @"\" + skinname;
            string mainskinpath = tempfilesroot + @"\" + skinname + @"\" + mainleaf;
            RichBoxArgs a = new RichBoxArgs("Testing " + rootfile + "\r\n", true);
            this.WriteToRichBox(sender, a);
            a.clear = false;
            a.stringToWrite = "dowloading files\r\n";
            this.WriteToRichBox(sender, a);

            DownloadSkinFile(tempfilesroot, subfilesroot, mainleaf, skinname, new SortedList(), false, "default");

            /*
             * Now we've got the skins from live, apply the changes (one by one) and see if it still works
             * We can rearrange the filenames in the list in order to accomodate the success or otherwise
             * 
             * Simply put: Go down the list of selected items until one fails, then keep going until one
             *				succeeds, then swap the failure and success, then start again from the next
             *				one. If you run out of files and they've all failed, report the problem
             * 
             */

            int current = 0;
            int lastfailed = 0;
            int iFilecount = this.GetCheckedFileCount();
            while (current < iFilecount && lastfailed < iFilecount)
            {
                // rename existing file in the test directory
                string curfilename = subfilesroot + @"\" + this.GetCheckedFilename(current);
                string filetocopy = rootdir + @"\" + this.GetCheckedFilename(current);
                string renamefile = subfilesroot + @"\" + this.GetCheckedFilename(current) + ".___temp";
                a.stringToWrite = "Trying " + this.GetCheckedFilename(current) + "...";
                this.WriteToRichBox(sender, a);
                bool bFileExists = System.IO.File.Exists(curfilename);
                if (bFileExists)
                {
                    System.IO.Directory.Move(curfilename, renamefile);
                }
                System.IO.File.Copy(filetocopy, curfilename, true);
                string result;
                if (TestXSLTFile(mainskinpath, out result))
                {
                    a.stringToWrite = "succeeded\r\n";
                    this.WriteToRichBox(sender, a);
                    // succeeded
                    if (bFileExists)
                    {
                        System.IO.File.Delete(renamefile);
                    }
                    if (current != lastfailed)
                    {
                        a.stringToWrite = "Swapping " + this.GetCheckedFilename(current) + " with " + this.GetCheckedFilename(lastfailed);
                        this.WriteToRichBox(sender, a);
                        SwapFileItemsArgs arg = new SwapFileItemsArgs(current, lastfailed);
                        SwapFileItems(sender, arg);

                        lastfailed = current;
                    }
                    else
                    {
                        current++;
                        lastfailed = current;
                    }
                }
                else
                {
                    a.stringToWrite = "failed (" + result + ")\r\n";
                    this.WriteToRichBox(sender, a);
                    System.IO.File.Delete(curfilename);
                    if (bFileExists)
                    {
                        System.IO.File.Move(renamefile, curfilename);
                    }
                    current++;
                }
            }
            if (current == lastfailed)
            {
                a.stringToWrite = "All files successfully tested\r\n";
                this.WriteToRichBox(sender, a);
            }
            else
            {
                a.stringToWrite = this.directoryStructure.Nodes[lastfailed].Text + " cannot be uploaded\r\n";
                this.WriteToRichBox(sender, a);
            }
        }

        private bool TestXSLTFile(string pathname, out string result)
        {
            result = pathname + " Uploaded OK";
            try
            {
                XmlDocument msXmlDoc = new XmlDocument();
                XmlDocument msXslDoc = new XmlDocument();

                // Load the XML and XSL data.
                msXmlDoc.LoadXml("<H2G2 TYPE='SIMPLE'/>");

                msXslDoc.Load(pathname);

                // 2. Transform XML by using MSXML 4.0, and then load the results into XmlDocument.
                //msXmlDoc.Schemas.(msXslDoc);

            }
            catch (XmlException xmlEx)        // Handle the Xml Exceptions here.
            {
                result = xmlEx.Message;
                return false;
            }
            catch (System.Runtime.InteropServices.COMException ex)              // Handle the generic Exceptions here.
            {
                result = ex.Message;
                return false;
            }
            catch (Exception ex)              // Handle the generic Exceptions here.
            {
                result = ex.Message;
                return false;
            }
            return true;
        }

        class RichBoxArgs : EventArgs
        {
            public string stringToWrite;
            public bool clear = false;
            public bool Cancel = false;
            public bool Completed = false;

            public RichBoxArgs(string toWrite)
            {
                this.stringToWrite = toWrite;
                clear = false;
            }
            public RichBoxArgs(string toWrite, bool doClear)
            {
                this.stringToWrite = toWrite;
                clear = doClear;
            }
        }

        delegate void WriteToRichBoxHandler(object sender, RichBoxArgs e);

        void WriteToRichBox(object sender, RichBoxArgs e)
        {
            if (this.InvokeRequired == false)
            {
                if (e.clear)
                {
                    richTextBox1.Clear();
                }
                richTextBox1.AppendText(e.stringToWrite);

                // Scroll to end of text
                richTextBox1.SelectionLength = 0;
                richTextBox1.SelectionStart = richTextBox1.Text.Length;
                richTextBox1.ScrollToCaret();
                if (_cancelPressed)
                {
                    e.Cancel = true;
                }
                if (e.Cancel || e.Completed)
                {
                    this._cancelPressed = false;
                    this.Cancel.Enabled = false;
                    this.btnUpload.Enabled = true;
                    this.btnDownloadSkin.Enabled = true;
                    this.Connect.Enabled = true;
                    this.btnDownloadAllSkins.Enabled = true;
                    this.btnClearTemplates.Enabled = true;
                }

                WriteToLogFile(e.stringToWrite);
            }
            else
            {
                WriteToRichBoxHandler writeToBox = new WriteToRichBoxHandler(WriteToRichBox);
                Invoke(writeToBox, new object[] { sender, e });
            }
        }

        private void WriteToRichBox(string s, bool bClear)
        {
            object sender = System.Threading.Thread.CurrentThread;
            RichBoxArgs a = new RichBoxArgs(s, bClear);
            WriteToRichBox(sender, a);
        }



        /// <summary>
        /// ServerDetails class
        /// </summary>
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

        public class CookieAwareWebClient : WebClient
        {
            private CookieContainer _container = new CookieContainer();

            public CookieContainer Cookies
            {
                get
                {
                    return _container;
                }
                set
                {
                    _container = value;
                }
            }

            protected override WebRequest GetWebRequest(Uri address)
            {
                WebRequest request = base.GetWebRequest(address);
                if (request is HttpWebRequest)
                {
                    (request as HttpWebRequest).CookieContainer = _container;
                }
                return request;
            }
        }
        /// <summary>
        /// Helper method for calling identity
        /// </summary>
        /// <param name="identityRestCall">The call you want to make</param>
        /// <param name="postParams">The params to be sent with this request</param>
        /// <param name="cookies">any cookies you want to add to the request</param>
        /// <param name="verb">The type of request you want to make</param>
        /// <returns>http response for the call</returns>
        public HttpWebResponse CallIdentityRestAPI(string identityRestCall, Dictionary<string, string> postParams, List<Cookie> cookies, string verb)
        {
            // Setup the params 
            string urlParams = "";
            if (postParams != null)
            {
                foreach (KeyValuePair<string, string> s in postParams)
                {
                    if (urlParams.Length > 0)
                    {
                        urlParams += "&";
                    }
                    urlParams += s.Key + "=" + s.Value;
                }
            }

            // Create the full URL
            string fullURI = _IdentityServerBaseUri;
            if (_hostName == "127.0.0.1")
            {
                fullURI = "https://api.stage.bbc.co.uk/idservices";
            }

            if (!identityRestCall.StartsWith("/"))
            {
                fullURI += "/" + identityRestCall;
            }
            else
            {
                fullURI += identityRestCall;
            }

            // If we're not doing a post request, then add the params to the url
            if (verb == "GET")
            {
                fullURI += "?" + urlParams;
            }

            Uri URL = new Uri(fullURI);

            // Create the new request object
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);

            switch (verb)
            {
                case "POST":
                    webRequest.Method = "POST";
                    break;
                default:
                    webRequest.Method = "GET";
                    break;
            }

            webRequest.Accept = "application/xml";
            webRequest.Timeout = 1000 * 400;
            webRequest.Proxy = new WebProxy(_iDproxy);
            webRequest.CookieContainer = new CookieContainer();
            if (cookies != null)
            {
                foreach (Cookie c in cookies)
                {
                    webRequest.CookieContainer.Add(c);
                    webRequest.Headers.Add(c.Name, c.Value);
                }
            }

            // Add the cert for the request
            X509Store store = new X509Store("My", StoreLocation.LocalMachine);
            store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
            X509Certificate _certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _webServiceCertificationName, false)[0];
            webRequest.ClientCertificates.Add(_certificate);

            // Now setup the correct method depending on the post flag
            if (verb != "GET")
            {
                webRequest.ContentType = "application/x-www-form-urlencoded";

                // Write the params to the body of the request
                ASCIIEncoding encoding = new ASCIIEncoding();
                byte[] bytes = encoding.GetBytes(urlParams);
                webRequest.ContentLength = bytes.Length;

                try
                {
                    Stream requestBody = webRequest.GetRequestStream();
                    requestBody.Write(bytes, 0, bytes.Length);
                    requestBody.Close();
                }
                catch (Exception ex)
                {
                    richTextBox1.AppendText("Failed to get read stream - " + ex.Message);
                    richTextBox1.AppendText("\r\n");
                    throw (ex);
                }
            }

            // Now do the request itself.
            HttpWebResponse response = null;
            try
            {
                response = (HttpWebResponse)webRequest.GetResponse();
                if (response == null)
                {
                    richTextBox1.AppendText("IDENTITY REQUEST ERROR - No Reponse object");
                    richTextBox1.AppendText("\r\n");
                }
            }
            catch (WebException ex)
            {
                string error = "IDENTITY REQUEST ERROR - \n" + ex.Message + "\r\n";
                if (ex.Response != null)
                {
                    StreamReader reader = new StreamReader(ex.Response.GetResponseStream(), Encoding.UTF8);
                    error += reader.ReadToEnd();
                }
                richTextBox1.AppendText(error);
            }
            richTextBox1.AppendText("\r\n");
            return response;
        }
    }
}