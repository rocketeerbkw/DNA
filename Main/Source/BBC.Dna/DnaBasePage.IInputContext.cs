using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Diagnostics;
using System.Net;
using System.Net.Mail;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Configuration;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;


namespace BBC.Dna.Page
{
    /// <summary>
    /// Summary description for DnaBasePage
    /// </summary>
    public partial class DnaBasePage : IInputContext, IOutputContext
    {
        [DllImport("kernel32.dll")]
        extern static short QueryPerformanceCounter(ref long x);
        [DllImport("kernel32.dll")]
        extern static short QueryPerformanceFrequency(ref long x);

        private User _viewingUser;
        private string _currentSiteName;
        private string _skinName;
        private DnaDiagnostics _dnaInputDiagnostics;
        private bool _isSecureRequest;

        /// <summary>
        /// Property to get the SkinName
        /// </summary>
        public string SkinName
        {
            get 
            { 
                return _skinName; 
            }
        }


        /// <summary>
        /// Get the User object representing the viewing user.
        /// </summary>
        public IUser ViewingUser
        {
            get
            {
                return _viewingUser;
            }
        }

        /// <summary>
        /// Get the Site object representing the current site.
        /// </summary>
        public ISite CurrentSite
        {
            get
            {
                return this.TheSiteList.GetSite(_currentSiteName);
            }
        }

        /// <summary>
        /// Gets whether the current site is a messageboard
        /// </summary>
        public bool IsCurrentSiteMessageboard
        {
            get
            {
                return this.TheSiteList.IsMessageboard(CurrentSite.SiteID);
            }
        }

        /// <summary>
        /// Returns if preview flag set
        /// </summary>
        /// <returns></returns>
        public bool IsPreviewMode()
        {
            string value = "";
            if(TryGetParamString("_previewmode", ref value, "Preview mode") )
            {
                return value == "1";
            }
            return false;
        }

        /// <summary>
        /// Sets the Site name from the si input parameter or sets it to h2g2 if none found
        /// </summary>
        private void SetCurrentSiteName()
        {
            Request.TryGetParamString("_si", ref _currentSiteName, "Site name as extracted from the URL. Internal use only.");

            // Check to make sure that the site exists and we support it.
            if (_currentSiteName == null || _currentSiteName.Length == 0 || CurrentSite == null)
            {
                // Default back to h2g2
                //_currentSiteName = "h2g2";
                Diagnostics.WriteToLog("Error", "Site not known." + _currentSiteName);

                throw new DnaException("Site not known.");
            }
        }

        /// <summary>
        /// Sets the skin name from the sk input parameter or sets it to brunel if none found
        /// </summary>
        private void SetSkinName()
        {
            _skinName = String.Empty;

            Request.TryGetParamString("_sk", ref _skinName, "XXXXXXXXXXXXXX");
            Request.TryGetParamString("skin", ref _skinName, "XXXXXXXXXXXXXXXXXX");
        }

        /// <summary>
        /// UserAgent for this request
        /// </summary>
        public string UserAgent
        {
            get
            {
                if (Request.UserAgent == null)
                {
                    return string.Empty;
                }
                else
                {
                    return Request.UserAgent;
                }
            }
        }

        /// <summary>
        /// Put in the XML representation of all the sites into the page
        /// </summary>
        public void AddAllSitesXmlToPage()
        {
            SiteXmlBuilder siteXml = new SiteXmlBuilder(this);
            siteXml.GenerateAllSitesXml(TheSiteList);
            _page.AddInside(siteXml, "H2G2");
        }

        /// <summary>
        /// This function is used to check to see if a given param exists
        /// </summary>
        /// <param name="paramName">The name of the param you want to check for</param>
        /// <param name="description">Description of the parameter, for documentation purposes</param>
        /// <returns>True if it exists or false if not</returns>
        public bool DoesParamExist(string paramName, string description)
        {
            return Request.DoesParamExist(paramName, description);
        }

        /// <summary>
        /// This function returns the value for a given param
        /// </summary>
        /// <param name="paramName">The name of the param you want to get that value for</param>
        /// <param name="value">reference string that will take the value</param>
        /// <param name="description">Description of the parameter, for documentation purposes</param>
        /// <returns>True if it exists, false if not</returns>
        public bool TryGetParamString(string paramName, ref string value, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.TryGetParamString(paramName, ref value, description);
        }

        /// <summary>
        /// Tries to get the specified param as an int, or returns the "Known Value" if it fails.
        /// Alternative to the GetParamIntOrZero(...) Method if zero can be a valid value.
        /// </summary>
        /// <param name="paramName">The name of the param you want to get that value for</param>
        /// <param name="knownValue">The known value you want to return on failure</param>
        /// <param name="description">Description of the parameter, for documentation purposes</param>
        /// <returns>The parsed value, or the known value on failure</returns>
        public int TryGetParamIntOrKnownValueOnError(string paramName, int knownValue, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.TryGetParamIntOrKnownValueOnError(paramName, knownValue, description);
        }

        /// <summary>
        /// Function for getting a given cookie
        /// </summary>
        /// <param name="cookieName">The name of the cookie that you want to get</param>
        /// <returns>The reference to our new DnaCookie or null if it could not be found</returns>
        public DnaCookie GetCookie(string cookieName)
        {
            if (Request.Cookies[cookieName] != null)
            {
                return new DnaCookie(Request.Cookies[cookieName]);
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Get a parameter value, or empty string if the parameter does not exist
        /// </summary>
        /// <param name="paramName">name of parameter to find</param>
        /// <param name="description">Description of parameter for documenation purposes</param>
        /// <returns>string value of parameter or empty string</returns>
        public string GetParamStringOrEmpty(string paramName, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamStringOrEmpty(paramName, description);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        public int GetParamIntOrZero(string paramName, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamIntOrZero(paramName, description);
        }

        /// <summary>
        /// Returns a list of all the parameter names in the current query
        /// </summary>
        /// <returns>A list of strings with all the parameter names in the query</returns>
        public List<string> GetAllParamNames()
        {
            return Request.GetAllParamNames();
        }

        /// <summary>
        /// Returns a list of all the parameter names in the current query
        /// </summary>
        /// <returns>A list of strings with all the parameter names in the query</returns>
        public NameValueCollection GetAllParamsWithPrefix(string prefix)
        {
            return Request.GetAllParamsWithPrefix(prefix);
        }

        /// <summary>
        /// Counts the number of parameters of the given name in the request
        /// </summary>
        /// <param name="paramName">name of parameter to count</param>
        /// <param name="description">description of parameter for documentation purposes</param>
        /// <returns></returns>
        public int GetParamCountOrZero(string paramName, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamCountOrZero(paramName, description);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="index"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public string GetParamStringOrEmpty(string paramName, int index, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamStringOrEmpty(paramName, index, description);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public double GetParamDoubleOrZero(string paramName, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamDoubleOrZero(paramName, description);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="index"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public double GetParamDoubleOrZero(string paramName, int index, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamDoubleOrZero(paramName, index, description);
        }
        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="index"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public int GetParamIntOrZero(string paramName, int index, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamIntOrZero(paramName, index, description);
        }

        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public bool GetParamBoolOrFalse(string paramName, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamBoolOrFalse(paramName, description);
        }
        /// <summary>
        /// <see cref="IInputContext"/>
        /// </summary>
        /// <param name="paramName"></param>
        /// <param name="index"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public bool GetParamBoolOrFalse(string paramName, int index, string description)
        {
            _tracker.TrackParam(paramName, description);
            return Request.GetParamBoolOrFalse(paramName, index, description);
        }

		/// <summary>
		/// IP address of request as passed through from the front end server
		/// </summary>
		public string IpAddress
		{
			get
			{
				return GetParamStringOrEmpty("__ip__", "IP address for this request");
			}
		}

		/// <summary>
		/// Guid extracted from the BBC-UID cookie
		/// </summary>
		public Guid BBCUid
		{
			get
			{
				//return new Guid();
				DnaCookie cookie = GetCookie("BBC-UID");
				if (cookie != null)
				{
					return UidCookieDecoder.Decode(cookie.Value, AppContext.TheAppContext.Config.SecretKey);
				}
				else
				{
					return new Guid("00000000000000000000000000000000");
				}
			}
		}

        /// <summary>
        /// Gets the site URL
        /// </summary>
        /// <param name="siteid">Site ID involved</param>
        /// <returns>Site Url to fill in</returns>
        public string GetSiteRoot(int siteid)
        {
            string siteRootUrl = String.Empty;
            string siteRoot = AppContext.TheAppContext.Config.SiteRoot;
            string siteName = "h2g2";
            if (TheSiteList != null)
            {
                siteName = this.TheSiteList.GetSite(siteid).SiteName;
            }
            siteRootUrl = siteRoot + siteName + "/";
            return siteRootUrl;
        }

        /// <summary>
        /// Sends an email
        /// </summary>
        /// <param name="email">Email address </param>
        /// <param name="subject">Subject of the email</param>
        /// <param name="body">Body of the email</param>
        /// <param name="fromAddress">email of the from address</param>
        /// <param name="fromName">From whom is the message</param>
        /// <param name="insertLineBreaks">Put the line breaks in of not</param>
        public void SendEmail(string email, string subject, string body, string fromAddress, string fromName, bool insertLineBreaks)
        {
            string smtpServer = AppContext.TheAppContext.Config.SMTPServer;

            string clientAddr = Request.ServerVariables["REMOTE_ADDR"].ToString();

            if (fromAddress == String.Empty)
            {
                fromAddress = this.TheSiteList.GetSite(CurrentSite.SiteID).GetEmail(BBC.Dna.Sites.Site.EmailType.Feedback);
                fromName = this.TheSiteList.GetSite(CurrentSite.SiteID).ShortName;
            }

            try
            {
                SendMail(email, subject, body, fromAddress, fromName, smtpServer);
            }
            catch (Exception Ex)
            {
		        //Create a unique filename. QueryPerformanceCounter used to distinguish emails sent within a second.
		        string filename = "M";
		        DateTime dt = DateTime.Now;

		        filename += dt.ToString("yyyyMMddHHmmss");

		        long counter = 0;
		        QueryPerformanceCounter(ref counter);
		        filename += "-" + counter + ".txt";

                string mail = String.Empty;
                mail += "From: " + fromAddress + "\r\n";
                mail += "Recipient: " + email + "\r\n";

		        string toField;
		        if (clientAddr != String.Empty)
		        {
                    toField = "X-Originating-IP: [";
                    toField += clientAddr + "]";
                    mail += toField + "\r\n";
		        }
                mail += "Subject: " + subject + "\r\n";
                toField = "To: ";
                toField += email;
                mail += toField + "\r\n";
                toField = "From: ";
                toField += "\"" + fromName + "\" <" + fromAddress + ">";
                mail += toField + "\r\n";

                mail += "\r\n";
                mail += body;

                Diagnostics.WriteToLog("Failed Send Mail", Ex.Message);

                FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "failedmails", filename, mail);

            }
        }

        /// <summary>
        /// Sends a DNA System Message
        /// </summary>
        /// <param name="sendToUserID">User id to send the system message to</param>
        /// <param name="siteID">Site ID involved</param>
        /// <param name="messageBody">Body of the SYstem Message</param>
        public void SendDNASystemMessage(int sendToUserID, int siteID, string messageBody)
        {
            using (IDnaDataReader dataReader = this.CreateDnaDataReader("senddnasystemmessage"))
            {
                dataReader.AddParameter("userid", sendToUserID);
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("messagebody", messageBody);
                dataReader.Execute();
            }
        }
        /// <summary>
        /// Sends a mail or DNA System Message
        /// </summary>
        /// <param name="email">Email address </param>
        /// <param name="subject">Subject of the email</param>
        /// <param name="body">Body of the email</param>
        /// <param name="fromAddress">email of the from address</param>
        /// <param name="fromName">From whom is the message</param>
        /// <param name="insertLineBreaks">Put the line breaks in of not</param>
        /// <param name="userID">User ID involved</param>
        /// <param name="siteID">For which Site</param>
        public void SendMailOrSystemMessage(string email, string subject, string body, string fromAddress, string fromName, bool insertLineBreaks, int userID, int siteID)
        {
            if (GetSiteOptionValueBool(siteID, "General", "UseSystemMessages") && userID > 0)
            {
                SendDNASystemMessage(userID, siteID, body);
            }
            else
            {
                SendEmail(email, subject, body, fromAddress, fromName, insertLineBreaks);
            }
        }

        private void SendMail(string email, string subject, string body, string fromAddress, string fromName, string smtpServer)
        {
            // Command line argument must the the SMTP host.
            SmtpClient client = new SmtpClient(smtpServer);

            // Specify the e-mail sender.
            // Create a mailing address that includes a UTF8 character in the display name.
            MailAddress from = new MailAddress(fromAddress, fromName, System.Text.Encoding.UTF8);

            // Set destinations for the e-mail message.
            MailAddress to = new MailAddress(email);

            // Specify the message content.
            MailMessage message = new MailMessage(from, to);
            message.Body = body;
            message.BodyEncoding = System.Text.Encoding.UTF8;
            message.Subject = subject;
            message.SubjectEncoding = System.Text.Encoding.UTF8;

            client.Send(message);
        }

        /// <summary>
        /// Is secure request has IDENTITY-HTTPS cookie
        /// </summary>
        public bool IsSecureRequest
        {
            get
            {

                return _isSecureRequest;
            }
            set
            {
                _isSecureRequest = value;
            }
        }
    
    }
}
