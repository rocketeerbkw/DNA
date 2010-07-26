﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
//#if DEBUG
using BBC.Dna.Data;
using System.DirectoryServices;
using System.Diagnostics;
using System.Security.Permissions;

namespace DnaIdentityWebServiceProxy
{
    public class IdentityDebugSigninComponent : IDnaIdentityWebServiceProxy
    {
        public IdentityDebugSigninComponent()
        {
        }

        public IdentityDebugSigninComponent(string debugIdentityUserID)
        {
            Initialise(debugIdentityUserID, "");
        }

        private string DotNetNormalUser
        {
            get
            {
                StringBuilder details = new StringBuilder();
                details.Append("<signInDetails>");
                details.Append(string.Format("<{0}>{1}</{0}>", "logInName", "DotNetNormalUser"));
                details.Append(string.Format("<{0}>{1}</{0}>", "identityUserID", "6042002"));
                details.Append(string.Format("<{0}>{1}</{0}>", "displayName", "DotNetNormalUser"));
                details.Append(string.Format("<{0}>{1}</{0}>", "email", "tester@bbc.co.uk"));
                details.Append(string.Format("<{0}>{1}</{0}>", "cookie", "6042002|DotNetNormalUser|DotNetNormalUser|0|DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "secureCookie", "HTTPS-DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "lastUpdated", DateTime.Now.AddYears(SyncDetails ? 1 : -1).ToString()));
                details.Append("</signInDetails>");

                return details.ToString();
            }
        }

        private string DotNetSuperUser
        {
            get
            {
                StringBuilder details = new StringBuilder();
                details.Append("<signInDetails>");
                details.Append(string.Format("<{0}>{1}</{0}>", "logInName", "DotNetSuperUser"));
                details.Append(string.Format("<{0}>{1}</{0}>", "identityUserID", "6042010"));
                details.Append(string.Format("<{0}>{1}</{0}>", "displayName", "DotNetSuperUser"));
                details.Append(string.Format("<{0}>{1}</{0}>", "email", "tester@bbc.co.uk"));
                details.Append(string.Format("<{0}>{1}</{0}>", "cookie", "6042010|DotNetSuperUser|DotNetSuperUser|0|DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "secureCookie", "HTTPS-DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "lastUpdated", DateTime.Now.AddYears(SyncDetails ? 1 : -1).ToString()));
                details.Append("</signInDetails>");

                return details.ToString();
            }
        }

        private string DotNetEditor
        {
            get
            {
                StringBuilder details = new StringBuilder();
                details.Append("<signInDetails>");
                details.Append(string.Format("<{0}>{1}</{0}>", "logInName", "DotNetEditor"));
                details.Append(string.Format("<{0}>{1}</{0}>", "identityUserID", "6042008"));
                details.Append(string.Format("<{0}>{1}</{0}>", "displayName", "DotNetEditor"));
                details.Append(string.Format("<{0}>{1}</{0}>", "email", "tester@bbc.co.uk"));
                details.Append(string.Format("<{0}>{1}</{0}>", "cookie", "6042008|DotNetEditor|DotNetEditor|0|DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "secureCookie", "HTTPS-DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "lastUpdated", DateTime.Now.AddYears(SyncDetails ? 1 : -1).ToString()));
                details.Append("</signInDetails>");

                return details.ToString();
            }
        }

        private string DotNetModerator
        {
            get
            {
                StringBuilder details = new StringBuilder();
                details.Append("<signInDetails>");
                details.Append(string.Format("<{0}>{1}</{0}>", "logInName", "DotNetModerator"));
                details.Append(string.Format("<{0}>{1}</{0}>", "identityUserID", "6042012"));
                details.Append(string.Format("<{0}>{1}</{0}>", "displayName", "DotNetModerator"));
                details.Append(string.Format("<{0}>{1}</{0}>", "email", "tester@bbc.co.uk"));
                details.Append(string.Format("<{0}>{1}</{0}>", "cookie", "6042012|DotNetModerator|DotNetModerator|0|DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "secureCookie", "HTTPS-DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "lastUpdated", DateTime.Now.AddYears(SyncDetails ? 1 : -1).ToString()));
                details.Append("</signInDetails>");

                return details.ToString();
            }
        }

        private string DotNetPreModUser
        {
            get
            {
                StringBuilder details = new StringBuilder();
                details.Append("<signInDetails>");
                details.Append(string.Format("<{0}>{1}</{0}>", "logInName", "DotNetPreModUser"));
                details.Append(string.Format("<{0}>{1}</{0}>", "identityUserID", "6042014"));
                details.Append(string.Format("<{0}>{1}</{0}>", "displayName", "DotNetPreModUser"));
                details.Append(string.Format("<{0}>{1}</{0}>", "email", "tester@bbc.co.uk"));
                details.Append(string.Format("<{0}>{1}</{0}>", "cookie", "6042014|DotNetPreModUser|DotNetPreModUser|0|DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "secureCookie", "HTTPS-DEBUG-IDENTITY-COOKIE"));
                details.Append(string.Format("<{0}>{1}</{0}>", "lastUpdated", DateTime.Now.AddYears(SyncDetails ? 1 : -1).ToString()));
                details.Append("</signInDetails>");

                return details.ToString();
            }
        }

        private bool SyncDetails { get; set; }
        private string DBConnectionDetails { get; set; }
        private string RunningWebDirectoryRoot { get; set; }

        public bool Initialise(string debugIdentityUserID, string notUsed)
        {
            LoginName = "";
            IdentityUserID = "";
            DisplayName = "";
            Email = "";
            LegacySSOUserID = 0;
            LastUpdatedDate = DateTime.MinValue;
            CookieValue = "";
            SecureCookieValue = "";
            LastError = "";
            Policy = "";
            _userAttributes = new Dictionary<string, string>();
            _namespacedAttributes = new Dictionary<string, string>();
            DBConnectionDetails = "";
            RunningWebDirectoryRoot = "";

            Console.WriteLine(debugIdentityUserID);

            string[] details = debugIdentityUserID.Split('|');
            if (details.Length == 0)
            {
                return false;
            }

            SyncDetails = details.Length > 1 && details[1].ToLower() == "sync";

            string userID = details[0].ToLower();

            string userDetails = "";
            if (userID == "dotnetnormaluser")
            {
                userDetails = DotNetNormalUser;
            }
            else if (userID == "dotnetsuperuser")
            {
                userDetails = DotNetSuperUser;
            }
            else if (userID == "dotneteditor")
            {
                userDetails = DotNetEditor;
            }
            else if (userID == "dotnetmoderator")
            {
                userDetails = DotNetModerator;
            }
            else if (userID == "dotnetpremoduser")
            {
                userDetails = DotNetPreModUser;
            }
            else if (userID.Contains("configfileuser-") && userID.IndexOf("configfileuser-") == 0)
            {
                // File base setup
                userDetails = GetConfigFileUserDetails(userID);
            }
            else
            {
                // Find them from the database
                userDetails = GetDataBaseUserDetails(userID);
            }

            try
            {
                XmlDocument signinDetailsXML = new XmlDocument();
                signinDetailsXML.LoadXml(userDetails);

                XmlNode identityUserIDNode = signinDetailsXML.SelectSingleNode("signInDetails/identityUserID");
                if (identityUserIDNode != null)
                {
                    IdentityUserID = identityUserIDNode.InnerText;
                }

                XmlNode logInNameNode = signinDetailsXML.SelectSingleNode("signInDetails/logInName");
                if (logInNameNode != null)
                {
                    LoginName = logInNameNode.InnerText;
                    _userAttributes.Add("username", LoginName);
                }

                XmlNode displayNameNode = signinDetailsXML.SelectSingleNode("signInDetails/displayName");
                if (displayNameNode != null)
                {
                    DisplayName = displayNameNode.InnerText;
                    _userAttributes.Add("displayname", DisplayName);
                }

                XmlNode legacySSOUserIDNode = signinDetailsXML.SelectSingleNode("signInDetails/legacySSOUserID");
                if (legacySSOUserIDNode != null)
                {
                    _userAttributes.Add("legacy_user_id", legacySSOUserIDNode.InnerText);
                    LegacySSOUserID = Convert.ToInt32(legacySSOUserIDNode.InnerText);
                }

                XmlNode emailNode = signinDetailsXML.SelectSingleNode("signInDetails/email");
                if (emailNode != null)
                {
                    Email = emailNode.InnerText;
                    _userAttributes.Add("email", Email);
                }

                XmlNode lastUpdatedNode = signinDetailsXML.SelectSingleNode("signInDetails/lastUpdated");
                if (lastUpdatedNode == null)
                {
                    LastUpdatedDate = DateTime.Now.AddYears(SyncDetails ? 1 : -1);
                }
                else
                {
                    LastUpdatedDate = DateTime.Parse(lastUpdatedNode.InnerText);
                }
                _userAttributes.Add("lastupdatedcpp", string.Format("{0:yyyyMMddHHmmss}", LastUpdatedDate));
                _userAttributes.Add("lastupdated", LastUpdatedDate.ToString());

                XmlNode cookieNode = signinDetailsXML.SelectSingleNode("signInDetails/cookie");
                if (cookieNode != null)
                {
                    CookieValue = cookieNode.InnerText;
                }
                else
                {
                    CookieValue = IdentityUserID.ToString() + "|" + LoginName + "|" + DisplayName + "|0|DEBUG-IDENTITY-COOKIE";
                }

                XmlNode secureCookieNode = signinDetailsXML.SelectSingleNode("signInDetails/secureCookie");
                if (secureCookieNode != null)
                {
                    SecureCookieValue = secureCookieNode.InnerText;
                }

                XmlNode userAttibutesNode = signinDetailsXML.SelectSingleNode("signinDetails/userAttributes");
                if (userAttibutesNode != null && userAttibutesNode.HasChildNodes)
                {
                    foreach (XmlNode attrib in userAttibutesNode.ChildNodes)
                    {
                        _userAttributes.Add(attrib.Name, attrib.InnerText);
                    }
                }

                XmlNode namespaceAttrbutesNode = signinDetailsXML.SelectSingleNode("signInDetails/namespaceAttributes");
                if (namespaceAttrbutesNode != null && namespaceAttrbutesNode.HasChildNodes)
                {
                    foreach (XmlNode attrib in namespaceAttrbutesNode.ChildNodes)
                    {
                        _namespacedAttributes.Add(attrib.Name, attrib.InnerText);
                    }
                }
            }
            catch (Exception ex)
            {
                LastError += ex.Message;
            }

            return LoginName.Length > 0 && IdentityUserID.Length > 0 && LastUpdatedDate != DateTime.MinValue;
        }

        private string GetConfigFileUserDetails(string userID)
        {
            string details = "";
            XmlDocument xmlDoc = new System.Xml.XmlDocument();
            try
            {
                string id = userID.Substring("configfileuser-".Length);
                string rootPath = GetRunningDNAWebDirectoryRoot();
                xmlDoc.Load(rootPath + @"\debuguserdetails.xml");
                XmlNode detailXML = xmlDoc.SelectSingleNode("debugUsers/user[@id='" + id + "']/signInDetails");
                if (detailXML != null)
                {
                    details = detailXML.OuterXml;
                }
                else
                {
                    LastError = "Failed to find given user in config file - " + id;
                }
            }
            catch (Exception ex)
            {
                LastError = "Failed to get config file. " + ex.Message;
            }

            return details;
        }

        private string GetDataBaseUserDetails(string userID)
        {
            StringBuilder details = new StringBuilder();
            IDnaDataReaderCreator dataReaderCreator = new DnaDataReaderCreator(GetDataBaseConnectionDetails());
            try
            {
                using (IDnaDataReader reader = dataReaderCreator.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("SELECT * FROM SignInUserIDMapping sim JOIN Users u ON u.UserID = sim.DNAUserID WHERE IdentityUserID = " + userID);
                    if (reader.HasRows && reader.Read())
                    {
                        details.Append("<signInDetails>");
                        string loginName = reader.GetStringNullAsEmpty("loginname");
                        details.Append(string.Format("<{0}>{1}</{0}>", "logInName", loginName));

                        string identityUserID = reader.GetInt32NullAsZero("IdentityUserID").ToString();
                        details.Append(string.Format("<{0}>{1}</{0}>", "identityUserID", identityUserID));

                        string displayName = reader.GetStringNullAsEmpty("username");
                        details.Append(string.Format("<{0}>{1}</{0}>", "displayName", displayName));

                        details.Append(string.Format("<{0}>{1}</{0}>", "email", reader.GetStringNullAsEmpty("email")));
                        details.Append(string.Format("<{0}>{1}</{0}>", "cookie", identityUserID.ToString() + "|" + loginName + "|" + displayName + "|0|DEBUG-IDENTITY-COOKIE"));
                        details.Append(string.Format("<{0}>{1}</{0}>", "secureCookie", "HTTPS-DEBUG-IDENTITY-COOKIE"));
                        details.Append(string.Format("<{0}>{1}</{0}>", "lastUpdated", DateTime.Now.AddYears(SyncDetails ? 1 : -1).ToString()));
                        details.Append("</signInDetails>");
                    }
                    else
                    {
                        LastError = "Failed to find identity user (" + userID.ToString() + ") in the database!";
                    }
                }
            }
            catch (Exception ex)
            {
                LastError = "Failed to find identity user (" + userID.ToString() + ") in the database! " + ex.Message;
            }
            return details.ToString();
        }

        private string GetDataBaseConnectionDetails()
        {
            if (DBConnectionDetails.Length > 0)
            {
                return DBConnectionDetails;
            }

            XmlDocument xmlDoc = new System.Xml.XmlDocument();
            try
            {
                string rootPath = GetRunningDNAWebDirectoryRoot();
                xmlDoc.Load(rootPath + @"\ripleyserver.xmlconf");
            }
            catch(Exception ex)
            {
                LastError = "Failed to get config file. " + ex.Message;
                return "";
            }

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

            DBConnectionDetails = "application name=" + appName + "; user id=" + uid + ";password=" + password + ";data source=" + servername + ";initial catalog=" + dbname + ";pooling=" + pooling;
            return DBConnectionDetails;
        }

        private string GetRunningDNAWebDirectoryRoot()
        {
            if (RunningWebDirectoryRoot.Length > 0)
            {
                return RunningWebDirectoryRoot;
            }

            string rootPath = "";
            try
            {
                DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC", "editor", "editor");
                foreach (DirectoryEntry site in entry.Children)
                {
                    if (site.SchemaClassName == "IIsWebServer")
                    {
                        string serverComment = site.Properties["ServerComment"].Value.ToString();

                        // We want the web directory of the running h2g2 or h2g2 unit testing site
                        if (serverComment == "h2g2"/* || serverComment == "h2g2UnitTesting"*/)
                        {
                            DirectoryEntry rootVDir = new DirectoryEntry("IIS://localhost/W3SVC/" + site.Name + "/Root");
                            rootPath = rootVDir.Properties["Path"].Value.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            RunningWebDirectoryRoot = rootPath;
            return rootPath;
        }

        public string LoginName { get; private set; }
        public string DisplayName { get; private set; }
        public string Email { get; set; }
        private string IdentityUserID { get; set; }
        private int LegacySSOUserID { get; set; }
        private DateTime LastUpdatedDate { get; set; }
        public string CookieValue { get; private set; }
        public string SecureCookieValue { get; private set; }
        private string LastError { get; set; }
        private string Policy { get; set; }
        private Dictionary<string, string> _userAttributes;
        private Dictionary<string, string> _namespacedAttributes;

        #region IDnaIdentityWebServiceProxy Members

        public void CloseConnections()
        {
        }

        public void Dispose()
        {
        }

        public bool DoesAppNameSpacedAttributeExist(string cookie, string appNameSpace, string attributeName)
        {

            return _namespacedAttributes.ContainsKey(attributeName);
        }

        public bool DoesAttributeExistForService(string service, string attributeName)
        {
            return _userAttributes.ContainsKey(attributeName);
        }

        public string GetAppNameSpacedAttribute(string cookie, string appNameSpace, string attributeName)
        {
            if (_namespacedAttributes.ContainsKey(attributeName))
            {
                return _namespacedAttributes[attributeName];
            }
            return "";
        }

        public string GetCookieValue
        {
            get { return CookieValue; }
        }

        public string[] GetDnaPolicies()
        {
            List<string> policies = new List<string>();
            policies.Add("http://identity/policies/dna/adult");
            policies.Add("http://identity/policies/dna/kids");
            policies.Add("http://identity/policies/dna/over13");
            policies.Add("http://identity/policies/dna/schools");
            policies.Add("http://identity/policies/dna/blast");
            return policies.ToArray();
        }

        public string GetLastError()
        {
            return LastError;
        }

        public string GetLastTimingInfo()
        {
            return "<debugusermode>No timing info in debug user mode</debugusermode>";
        }

        public string GetSecureCookieValue
        {
            get { return SecureCookieValue; }
        }

        public void GetServiceMinMaxAge(string serviceName, ref int minAge, ref int maxAge)
        {
            throw new NotImplementedException();
        }

        public string GetUserAttribute(string attributeName)
        {
            if (_userAttributes.ContainsKey(attributeName))
            {
                return _userAttributes[attributeName];
            }
            return "";
        }

        public string GetVersion()
        {
            return "<debugusermode>DNA Debug Identity Component</debugusermode>";
        }

        public bool IsSecureRequest
        {
            get { return SecureCookieValue.Length > 0; }
        }

        public bool IsServiceSet
        {
            get { return Policy.Length > 0; }
        }

        public bool IsUserLoggedIn
        {
            get { return IdentityUserID.Length > 0; }
        }

        public bool IsUserSignedIn
        {
            get { return IdentityUserID.Length > 0; }
        }

        public bool LoginUser()
        {
            return true;
        }

        public void LogoutUser()
        {
        }

        public void SetService(string serviceName)
        {
            Policy = serviceName;
        }

        public SignInSystem SignInSystemType
        {
            get { return SignInSystem.Identity; }
        }

        public bool TrySecureSetUserViaCookies(string cookie, string secureCookie)
        {
            return IdentityUserID.Length > 0;
        }

        public bool TrySetUserViaCookie(string cookieValue)
        {
            return IdentityUserID.Length > 0;
        }

        public bool TrySetUserViaCookieAndUserName(string cookie, string userName)
        {
            return IdentityUserID.Length > 0;
        }

        public bool TrySetUserViaUserNamePassword(string userName, string password)
        {
            return IdentityUserID.Length > 0;
        }

        public string UserID
        {
            get { return IdentityUserID; }
        }

        #endregion
    }
}
//#endif
