using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Net;
using System.IO;

namespace SkinsChecker
{
    public class RequestXMLPage
    {
        /// <summary>
        /// class fields
        /// </summary>
        private WebProxy _proxy = new WebProxy("http://www-cache.reith.bbc.co.uk:80");
        private bool _useEditorAuthentication = false;
        private string _userName = "ProfileAPITest";
        private string _password = "APITest";
        private string _cookie = "44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00";
        private HttpWebResponse _response = null;
        private string _responseAsString = null;
        private bool _useIdentity = false;

        List<Cookie> _cookieList = new List<Cookie>();

        /// <summary>
        /// Helper function that sets the current user to be profile api test user
        /// </summary>
        public void SetCurrentUserProfileTest()
        {
            _userName = "ProfileAPITest";
            _password = "APITest";
            _cookie = "44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00";
        }

        /// <summary>
        /// Helper function that sets the current user to be a normal user
        /// </summary>
        public void SetCurrentUserNormal()
        {
            _userName = "DotNetNormalUser";
            _password = "789456123";
            _cookie = "0465e40bc638441a2e9b6381816653cf1a1348ec78c360cba1871e0d8345ef4800";
        }

        /// <summary>
        /// Helper function that sets the current user to be a Editor
        /// </summary>
        public void SetCurrentUserEditor()
        {
            _userName = "DotNetEditor";
            _password = "789456123";
            _cookie = "c4f5f57424cad2a942aa372761895fdae360410098c3e0ab31a71e7dd7d10e5b00";
        }

        /// <summary>
        /// Helper function that sets the current user to be a Superuser
        /// </summary>
        public void SetCurrentUserSuperUser()
        {
            _userName = "DotNetSuperUser";
            _password = "789456123";
            _cookie = "44f575d494ab0bb18384c0f961240c09fe4043606893d04b6107fe6df7411e2a00";
        }

        /// <summary>
        /// Helper function that sets the current user to be a Moderator
        /// </summary>
        public void SetCurrentUserModerator()
        {
            _userName = "DotNetModerator";
            _password = "789456123";
            _cookie = "5455c5ac05fd028981f5da2891c1d4567f73249c384310eb11c79e8d540142ca00";
        }

        /// <summary>
        /// Helper function that sets the current user to be a premod user
        /// </summary>
        public void SetCurrentUserPreModUser()
        {
            _userName = "DotNetPreModUser";
            _password = "789456123";
            _cookie = "0495f53dda7c633e7a527c2751ae8aab77a953cde823f0bb01a77e7d533fbd8c00";
        }

        /// <summary>
        /// Helper function that reset the current user to be a not logged in user
        /// </summary>
        public void SetCurrentUserNotLoggedInUser()
        {
            _userName = "";
            _password = "";
            _cookie = "";
        }

        /// <summary>
        /// Helper function that reset the current user to be an identity user
        /// </summary>
        public void SetCurrentUserAsIdentityTestUser()
        {
            _userName = "tester633518075951276859";
            _password = "123456789";
            _cookie = HttpUtility.UrlEncode("AQICySfvBLGfchTj5H8n4BV3oMunIzG4/bvFsiq+zOzU1eTUptTbH0/zNgT1hWeoHvv3JZEdZdNGXqzObiMiDaDFHIb7/pOIBKMc5qk8NxiW6yBUY/Zh/wenRhBhHB+8jK/z4X+uyoNDwSE=");
            _useIdentity = true;
        }

        /// <summary>
        /// Current user property
        /// </summary>
        public string CurrentUserName
        {
            get { return _userName; }
            set { _userName = value; }
        }

        /// <summary>
        /// Current password property
        /// </summary>
        public string CurrentPassword
        {
            get { return _password; }
            set { _password = value; }
        }

        /// <summary>
        /// Current SSO2 cookie property
        /// </summary>
        public string CurrentSSO2Cookie
        {
            get { return _cookie; }
            set { _cookie = HttpUtility.UrlEncode(value); }
        }

        /// <summary>
        /// Set which signin system to use. True uses identity, false uses profileAPI
        /// </summary>
        public bool UseIdentitySignIn
        {
            get { return _useIdentity; }
            set { _useIdentity = value; }
        }

        /// <summary>
        /// Adds the given cookie to the request
        /// </summary>
        /// <param name="cookie">The cookie you want to add</param>
        public void AddCookie(Cookie cookie)
        {
            _cookieList.Add(cookie);
        }

        /// <summary>
        /// Requests the given URL and returns the page as XML.
        /// </summary>
        /// <param name="pageAndParams">The page you want to get the XML for</param>
        /// <param name="outputXml"></param>
        /// <param name="errors"></param>
        /// <returns></returns>
        public bool RequestDnaPage(string pageAndParams, ref string outputXml, ref string errors)
        {
            string[] urlParts = pageAndParams.Split('/');
            if (urlParts.Length < 4)
            {
                errors = "Failed to find service from requested url";
                return false;
            }

            if (!pageAndParams.Contains("skin=purexml"))
            {
                if (pageAndParams.Contains("?"))
                {
                    pageAndParams += "&skin=purexml";
                }
                else
                {
                    pageAndParams += "?skin=purexml";
                }
            }
            
            // Set the user to be the editor
            SetCurrentUserEditor();
            
            // Create the URL and the Request object
            Uri URL = new Uri(pageAndParams);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
            webRequest.Timeout = 400000;

            // Set the proxy
            webRequest.Proxy = _proxy;

            // Check to see if we need to authenticate the request as an editor
            if (_useEditorAuthentication)
            {
                webRequest.PreAuthenticate = true;
                NetworkCredential myCred = new NetworkCredential("editor", "editor");
                CredentialCache MyCrendentialCache = new CredentialCache();
                MyCrendentialCache.Add(URL, "Basic", myCred);
                webRequest.Credentials = MyCrendentialCache;
            }

            // Check to see if we need to add a cookie
            if (_cookie.Length >= 66)
            {
                // Create and add the cookie to the request
                Cookie cookie;
                if (_useIdentity)
                {
                    cookie = new Cookie("IDENTITY", _cookie, "/", urlParts[2]);
                }
                else
                {
                    cookie = new Cookie("SSO2-UID", _cookie, "/", urlParts[2]);
                }
                webRequest.CookieContainer = new CookieContainer();
                webRequest.CookieContainer.Add(cookie);
            }

            try
            {
                // Try to send the request and get the response
                _response = (HttpWebResponse)webRequest.GetResponse();
            }
            catch (Exception ex)
            {
                errors = "Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message;
                return false;
            }

            if (_responseAsString == null)
            {
                // Create a reader from the response stream and return the content
                using (StreamReader reader = new StreamReader(_response.GetResponseStream()))
                {
                    outputXml = reader.ReadToEnd();
                }
                _response.Close();
            }

            // Return the response object
            return true;
        }
    }
}
