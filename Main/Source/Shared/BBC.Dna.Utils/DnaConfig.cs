using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.IO;

//Build you bugger!!

namespace BBC.Dna.Utils
{
    /// <summary>
    /// The class that handles DNA application configuration
    /// </summary>
    public class DnaConfig
    {
        private string _rootPath;
        private string _connectionString;
        private string _inputLogFilePath;
		private string _cachePath;

		private string _postcoderServer;
		private string _postcoderProxy;
        private string _postcoderPlace;

        private string _siteRoot;
        private string _smtpServer;

        private string _bannedUserAgentsString;
   
		/// <summary>
		/// Path of the Ripley cache
		/// </summary>
		public string CachePath
		{
			get { return _cachePath; }
		}
        private List<string> _ripleyServerAddresses;
        private List<string> _dotNetServerAddresses;

        /// <summary>
        /// <para>Creates the object using the given path</para>
        /// <para>The supplied root path should contain the configuration file</para>
        /// </summary>
        /// <param name="rootPath">Folder containing the configuration file</param>
        public DnaConfig(string rootPath)
        {
            _rootPath = rootPath;
			Initialise();
        }

        /// <summary>
        /// The folder where input log files are to be created
        /// </summary>
        public string InputLogFilePath
        {
            get { return _inputLogFilePath; }
        }

        /// <summary>
        /// The database connection string
        /// </summary>
        public string ConnectionString
        {
            get { return _connectionString; }
        }

        /// <summary>
        /// The Postcoder Server string
        /// </summary>
        public string PostcoderServer
        {
            get { return _postcoderServer; }
        }
        /// <summary>
        /// The Postcoder Proxy string
        /// </summary>
        public string PostcoderProxy
        {
            get { return _postcoderProxy; }
        }
        /// <summary>
        /// The Postcoder Place string
        /// </summary>
        public string PostcoderPlace
        {
            get { return _postcoderPlace; }
        }

        public string BannedUserAgentsString
        {
            get { return _bannedUserAgentsString; }
        }

        /// <summary>
        /// The ripley server farm addresses
        /// </summary>
        public List<string> RipleyServerAddresses
        {
            get { return _ripleyServerAddresses; }
        }

        /// <summary>
        /// The dot net server farm addresses
        /// </summary>
        public List<string> DotNetServerAddresses
        {
            get { return _dotNetServerAddresses; }
        }

        /// <summary>
        /// Site Root
        /// </summary>
        public string SiteRoot
        {
            get { return _siteRoot; }
        }

        /// <summary>
        /// SMTP Server
        /// </summary>
        public string SMTPServer
        {
            get { return _smtpServer; }
        }

        /// <summary>
        /// Creates the database connection string based in the given XML doc
        /// </summary>
        /// <param name="xmlDoc">XML doc representing the app's configuration</param>
        private void CreateConnectionString(XmlDocument xmlDoc)
        {
            XmlNode node = xmlDoc.SelectSingleNode("RIPLEY/DBSERVER/SQLSERVER/SERVERNAME");
            string servername = node.InnerText;

            node = xmlDoc.SelectSingleNode("RIPLEY/DBSERVER/SQLSERVER/DBNAME");
            string dbname = node.InnerText;

            node = xmlDoc.SelectSingleNode("RIPLEY/DBSERVER/SQLSERVER/UID");
            string uid = node.InnerText;

            node = xmlDoc.SelectSingleNode("RIPLEY/DBSERVER/SQLSERVER/PASSWORD");
            string password = node.InnerText;

            string appName = "BBC.Dna";
            node = xmlDoc.SelectSingleNode("RIPLEY/DBSERVER/SQLSERVER/DOTNETAPPNAME");
            if (node != null)
            {
                appName = node.InnerText;
            }

            string pooling = "true";
            node = xmlDoc.SelectSingleNode("RIPLEY/DBSERVER/SQLSERVER/POOLING");
            if (node != null)
            {
                pooling = node.InnerText;
            }

            _connectionString = "application name="+appName+"; user id=" + uid + ";password=" + password + ";data source=" + servername + ";initial catalog=" + dbname + ";pooling="+pooling;
        }

        /// <summary>
        /// Creates the input log file path from the given XML doc
        /// </summary>
        /// <param name="xmlDoc">XML doc representing the app's configuration</param>
        private void CreateInputLogFilePath(XmlDocument xmlDoc)
        {
            XmlNode node = xmlDoc.SelectSingleNode("RIPLEY/INPUTLOGPATH");
            _inputLogFilePath = node.InnerText;
        }

		private void CreateCachePath(XmlDocument xmlDoc)
		{
			XmlNode node = xmlDoc.SelectSingleNode("RIPLEY/CACHEROOT");
			_cachePath = node.InnerText;
		}

		/// <summary>
        /// Creates the list of server addresses in the server farm from the given XML doc
        /// </summary>
        /// <param name="xmlDoc">XML doc representing the app's configuration</param>
        private void CreateServerFarmAddresses(XmlDocument xmlDoc)
        {
            // First check to make sure that the config contains the two tags we require.
            if (xmlDoc.SelectNodes("RIPLEY/SERVERFARM") == null || xmlDoc.SelectNodes("RIPLEY/DOTNET-SERVERFARM") == null)
            {
                throw new Exception("<SERVERFARM> or <DOTNET-SERVERFARM> config details missing!!!");
            }

            // First get the ripley server addresses
            List<string> ripleyServerAddresses = new List<string>();

            // Create a navigator to go through the list
            XmlNodeList nodes = xmlDoc.SelectNodes("RIPLEY/SERVERFARM/ADDRESS");
            if (nodes.Count == 0)
            {
                throw new Exception("No ripley server farm addresses given!!!");
            }
            foreach (XmlNode node in nodes)
            {
                // Add the address to the list.
                ripleyServerAddresses.Add(node.InnerText);
            }

            // Now assign the member to the new list
            _ripleyServerAddresses = ripleyServerAddresses;

            // Now get the Dot Net srver addresses
            List<string> dotNetServerAddresses = new List<string>();

            // Create a navigator to go through the list
            nodes = xmlDoc.SelectNodes("RIPLEY/DOTNET-SERVERFARM/ADDRESS");
            if (nodes.Count == 0)
            {
                throw new Exception("No .net server farm addresses given!!!");
            }
            foreach (XmlNode node in nodes)
            {
                // Add the address to the list.
                dotNetServerAddresses.Add(node.InnerText);
            }

            // Now assign the member to the new list
            _dotNetServerAddresses = dotNetServerAddresses;
        }

        /// <summary>
        /// <para>
        /// Initialises itself by reading the app's configuration file, which it finds in the folder
        /// supplied on construction
        /// </para>
        /// </summary>
        private void Initialise()
        {
            //Load DB Config Information
            XmlDocument xmlDoc = new XmlDocument();
            string path = _rootPath + "ripleyserver.xmlconf";
            xmlDoc.Load(path);

            CreateConnectionString(xmlDoc);
            CreateInputLogFilePath(xmlDoc);
            CreateServerFarmAddresses(xmlDoc);
			CreateCachePath(xmlDoc);
            CreatePostcoderDetails(xmlDoc);
            CreateSecretKey(xmlDoc);
            CreateSiteRoot(xmlDoc);
            CreateBannedUserAgentString(xmlDoc);
        }

        private void CreateBannedUserAgentString(XmlDocument xmlDoc)
        {
            _bannedUserAgentsString = "";
            if (xmlDoc.SelectSingleNode("RIPLEY/BANNEDUSERAGENTS") != null)
            {
                _bannedUserAgentsString = xmlDoc.SelectSingleNode("RIPLEY/BANNEDUSERAGENTS").InnerText;
            }
        }

		private string _secretKey;

		
		/// <summary>
		/// The secret key used to hash the BBC-UID cookie data
		/// </summary>
		public string SecretKey
		{
			get { return _secretKey; }
		}

		private void CreateSecretKey(XmlDocument xmlDoc)
		{
			XmlNode node = xmlDoc.SelectSingleNode("RIPLEY/SECRET-KEY");
			if (node == null)
			{
				throw new Exception("Can't find SECRET-KEY in config");
			}
			_secretKey = node.InnerText;
		}

        /// <summary>
        /// Get the full path to the "skins" folder for this server
        /// </summary>
        /// <returns>Full path to the "skins" folder for this server</returns>
        public string GetSkinRootFolder()
        {
            return _rootPath + @"skins\";
        }

        /// <summary>
        /// Creates the Postcoder connection details from the given XML doc
        /// </summary>
        /// <param name="xmlDoc">XML doc representing the app's configuration</param>
        private void CreatePostcoderDetails(XmlDocument xmlDoc)
        {
            /*	<POSTCODER>
		        <SERVER></SERVER>
		        <PROXY></PROXY>
		        <PLACE></PLACE>
		        <POSTCODEDATA></POSTCODEDATA>
             */
            XmlNode node = xmlDoc.SelectSingleNode("RIPLEY/POSTCODER/SERVER");
            _postcoderServer = node.InnerText;
            node = xmlDoc.SelectSingleNode("RIPLEY/POSTCODER/PROXY");
            _postcoderProxy = node.InnerText;
            node = xmlDoc.SelectSingleNode("RIPLEY/POSTCODER/PLACE");
            _postcoderPlace = node.InnerText;
        }

        /// <summary>
        /// Creates the Site Root from the given XML doc
        /// </summary>
        /// <param name="xmlDoc">XML doc representing the app's configuration</param>
        private void CreateSiteRoot(XmlDocument xmlDoc)
        {
            XmlNode node = xmlDoc.SelectSingleNode("RIPLEY/SITEROOT");
            _siteRoot = node.InnerText;
        }

        /// <summary>
        /// Creates the SMTP Server from the given XML doc
        /// </summary>
        /// <param name="xmlDoc">XML doc representing the app's configuration</param>
        private void CreateSMTPServer(XmlDocument xmlDoc)
        {
            XmlNode node = xmlDoc.SelectSingleNode("RIPLEY/SMTPSERVER");
            _smtpServer = node.InnerText;
        }
    }
}
