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
using BBC.Dna;
using BBC.Dna.Page;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Diagnostics;
using System.Xml;
using System.Reflection;
using System.IO;

public partial class TestIdentity : DnaWebPage
{
    public TestIdentity()
    {
        UseDotNetRendering = true;
//        SetDnaXmlDataSource = true;
    }


    /// <summary>
	/// General page handling
	/// </summary>
	public override void OnPageLoad()
	{
        //AddComponent(new Status(_basePage));
	}

	/// <summary>
	/// PageType: Status
	/// </summary>
	public override string PageType
	{
		get { return "TESTIDENTITYPAGE"; }
	}

    string _proxy = "10.152.4.15:80"; //"http://www-cache.reith.bbc.co.uk:80";
    string _certificateName = "dna live";

    CookieContainer _cookieContainer = new CookieContainer();

    string _identityBaseURL = "https://api.stage.bbc.co.uk";
    public string _PolicyUri = "http://identity/policies/dna/adult";

    public string _loggingInfo = "";


    public override void OnPostProcessRequest()
    {
        //_identityBaseURL = "https://api.live.bbc.co.uk";

        HttpWebResponse response = CallRestAPI(string.Format("{0}/idservices/status/", _identityBaseURL));

        StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8);
        string res = reader.ReadToEnd();
        AddLoggingInfo("Reponse:");
        AddLoggingInfo(res);
        AddLoggingInfo("");

        string cookie = "269|furrygeezer|Mark+Neves|1306413974528|1|1f8be498d209f703bbf3e98f9d359bd5d7c6c6e27141";
        cookie = "1919155|furrygeezer|furrygeezer|1306418177656|0|a927b6dbad800ffa90a65257ec3590230a09b56789d8";

        TrySecureSetUserViaCookies(cookie, "");
    }

    public bool TrySecureSetUserViaCookies(string cookie, string secureCookie)
    {
        bool _userLoggedIn = false;

        try
        {
            // Make sure the cookie does not contain a ' ', so replace them with '+'
            cookie = cookie.Replace(' ', '+');

            // Strip the :0 or encoded %3A0 from the end of the secure cookie as it won't validate with it added.
            secureCookie = secureCookie.Replace(":0", "").Replace("%3A0", "");

            // Check to see if the user is logged in

            _cookieContainer.Add(new Cookie("IDENTITY", cookie, "/", ".bbc.co.uk"));
            if (secureCookie.Length > 0)
            {
                _cookieContainer.Add(new Cookie("IDENTITY-HTTPS", secureCookie, "/", ".bbc.co.uk"));
            }
            HttpWebResponse response = CallRestAPI(string.Format("{0}/idservices/authorization?target_resource={1}", _identityBaseURL, _PolicyUri));
            if (response == null || response.StatusCode != HttpStatusCode.OK)
            {
                if (response == null)
                {
                    AddLoggingInfo("Failed to authorize user because of no response.");
                }
                else
                {
                    AddLoggingInfo("Failed to authorize user because status code = " + response.StatusCode.ToString());
                }
                AddLoggingInfo("<* IDENTITY END *>");
                return false;
            }

            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(response.GetResponseStream());
            response.Close();
            string _cookieValue = cookie;
            if (secureCookie.Length > 0)
            {
                string _secureCookieValue = secureCookie;
            }

            // Check to make sure that we get a valid response and it's value is true
            if (xDoc.SelectSingleNode("//boolean") == null || xDoc.SelectSingleNode("//boolean").InnerText != "true")
            {
                // Not valid or false
                AddLoggingInfo("authorize result false or null : " + response);
                AddLoggingInfo("<* IDENTITY END *>");
                return false;
            }
            string identityUserName = cookie.Split('|').GetValue(1).ToString();

            AddLoggingInfo("Calling Get Attributes...");
            response = CallRestAPI(string.Format("{0}/idservices/users/{1}/attributes", _identityBaseURL, identityUserName));
            if (response.StatusCode != HttpStatusCode.OK)
            {
                AddLoggingInfo("Get attributes failed : " + response);
                AddLoggingInfo("<* IDENTITY END *>");
                return false;
            }

            xDoc.Load(response.GetResponseStream());
            response.Close();
            if (xDoc.HasChildNodes)
            {
                string _loginName = xDoc.SelectSingleNode("//attributes/username").InnerText;
                AddLoggingInfo("Login Name      : " + _loginName);
                string _emailAddress = xDoc.SelectSingleNode("//attributes/email").InnerText;
                AddLoggingInfo("Email           : " + _emailAddress);
                if (xDoc.SelectSingleNode("//attributes/firstname") != null)
                {
                    string _firstName = xDoc.SelectSingleNode("//attributes/firstname").InnerText;
                }
                if (xDoc.SelectSingleNode("//attributes/lastname") != null)
                {
                    string _lastName = xDoc.SelectSingleNode("//attributes/lastname").InnerText;
                }

                string _userID = xDoc.SelectSingleNode("//attributes/id").InnerText;

                string legacyID = xDoc.SelectSingleNode("//attributes/legacy_user_id").InnerText;
                if (legacyID.Length == 0)
                {
                    legacyID = "0";
                }
                int _legacySSOID = Convert.ToInt32(legacyID);
                AddLoggingInfo("Legacy SSO ID   : " + legacyID);

                string _displayName = xDoc.SelectSingleNode("//attributes/displayname").InnerText;
                AddLoggingInfo("Display Name    : " + _displayName);

                DateTime _lastUpdatedDate;
                DateTime.TryParse(xDoc.SelectSingleNode("//attributes/update_date").InnerText, out _lastUpdatedDate);
                AddLoggingInfo("Last Updated    : " + _lastUpdatedDate.ToString());

                // The user is now setup correctly
                _userLoggedIn = _userID.Length > 0;
            }
        }
        catch (Exception ex)
        {
            string error = ex.Message;
            if (ex.InnerException != null)
            {
                error += " : " + ex.InnerException.Message;
            }
            AddLoggingInfo("Error!!! : " + error);
        }
        AddLoggingInfo("<* IDENTITY END *>");
        AddLoggingInfo("SUCCESS!!");
        return _userLoggedIn;
    }

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
            X509Certificate certificate = null;
            bool gotDevCert = false;
            for (int i = 0; i <= 1 && !gotDevCert; i++)
            {
                certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _certificateName, false)[i];
                gotDevCert = certificate.Subject.ToLower().Contains("cn=" + _certificateName.ToLower() + ",");
            }
            //X509Certificate certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _certificateName, false)[0];
            AddLoggingInfo("gotDevCert = " + gotDevCert);
            AddLoggingInfo("certificate = " + certificate.ToString());
            AddLoggingInfo("identityRestCall= " + identityRestCall);
            webRequest.ClientCertificates.Add(certificate);
            response = (HttpWebResponse)webRequest.GetResponse();
        }
        catch (WebException ex)
        {
            AddLoggingInfo("*** ERROR ***");
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
            AddLoggingInfo(error);
        }

        return response;
    }

    void AddLoggingInfo(string s)
    {
        _loggingInfo += s + "<BR/>"+Environment.NewLine;
    }
}
