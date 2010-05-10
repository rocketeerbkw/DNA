using System;
using System.Data;
using System.Configuration;
using System.Web;
using DnaIdentityWebServiceProxy;
using System.Diagnostics;

namespace BBC.Dna.Users
{
    /// <summary>
    /// The differenct signin systems
    /// </summary>
    public enum SignInSystem
    {
        /// <summary>
        /// Identity web Service
        /// </summary>
        Identity,
        /// <summary>
        /// ProfileAPI connection
        /// </summary>
        SSO
    }
    
    /// <summary>
    /// The class that authenticates the given user against the signin system via their cookie
    /// </summary>
    public class AuthenticateUser : IDisposable
    {
        private IDnaIdentityWebServiceProxy _signInComponent = null;
        private SignInSystem _signInSystem;
        private int _signInUserID = 0;
        private int _legacySSOUserID = 0;
        private string _loginName = "";
        private string _userName = "";
        private string _email = "";
        private string _firstName = "";
        private string _lastNames = "";
        private string _cookie = "";
        private string _secureCookie = "";
        private DateTime _lastUpdatedDate;

        /// <summary>
        /// Get property for the users signin userid
        /// </summary>
        public int SignInUserID
        {
            get { return _signInUserID; }
        }

        /// <summary>
        /// Get property for the users legacy SSO userid if they have one
        /// </summary>
        public int LegacyUserID
        {
            get { return _legacySSOUserID; }
        }

        /// <summary>
        /// Get propert for the username
        /// </summary>
        public string UserName
        {
            get { return _userName; }
        }

        /// <summary>
        /// Get propert for the login nmae
        /// </summary>
        public string LoginName
        {
            get { return _loginName; }
        }

        /// <summary>
        /// The get property for the email
        /// </summary>
        public string Email
        {
            get { return _email; }
        }

        /// <summary>
        /// Get propert for the users firstname
        /// </summary>
        public string FirstName
        {
            get { return _firstName; }
        }

        /// <summary>
        /// Get property for the users last names
        /// </summary>
        public string LastNames
        {
            get { return _lastNames; }
        }

        /// <summary>
        /// Get property to see if the user is signed in
        /// </summary>
        public bool IsSignedIn
        {
            get
            {
                if (_signInComponent != null)
                {
                    return _signInComponent.IsUserSignedIn;
                }
                return false;
            }
        }

        /// <summary>
        /// Get property to see if the user is logged in
        /// </summary>
        public bool IsLoggedIn
        {
            get
            {
                if (_signInComponent != null)
                {
                    return _signInComponent.IsUserLoggedIn;
                }
                return false;
            }
        }

        /// <summary>
        /// Get property for the users last updated date in the signin system
        /// </summary>
        public DateTime LastUpdatedDate
        {
            get
            {
                if (_signInComponent != null)
                {
                    return _lastUpdatedDate;
                }
                return DateTime.MinValue;
            }
        }

        /// <summary>
        /// Default constructor for UserSecurity
        /// </summary>
        /// <param name="signInSystem">The signin component to use</param>
        public AuthenticateUser(SignInSystem signInSystem)
        {
            _signInSystem = signInSystem;
            string signinConnectionDetails = ConfigurationManager.ConnectionStrings["IdentityURL"].ConnectionString;
            if (signInSystem == SignInSystem.SSO)
            {
                signinConnectionDetails = ConfigurationManager.ConnectionStrings["ProfileRead"].ConnectionString;
            }
            _signInComponent = SignInComponentFactory.CreateSignInComponent(signinConnectionDetails, _signInSystem);
        }

        /// <summary>
        /// The dispose method for closing any signin connections
        /// </summary>
        public void Dispose()
        {
            _signInComponent.Dispose();
        }

        /// <summary>
        /// Authenticates a user via the cookie
        /// </summary>
        /// <param name="cookie">The cookie you wnat to authenticate against</param>
        /// <param name="secureCookie">The secure cookie you want to authenticate against</param>
        /// <param name="policy">The policy to authenticate against. This is the site urlName for SSO but as this is being phased out, we're using
        /// <param name="identityUserName">The identity username. This is found in the IDENTITY-USER cookie</param>
        /// the Identity terms</param>
        /// <returns>True if they are authenticated, false if not</returns>
        public bool AuthenticateUserFromCookie(string cookie, string policy, string identityUserName)
        {
            return AuthenticateUserFromCookies(cookie, "", policy);
        }


        /// <summary>
        /// Authenticates a user via the cookies (normal and secure)
        /// </summary>
        /// <param name="cookie">The cookie you wnat to authenticate against</param>
        /// <param name="secureCookie">The secure cookie you want to authenticate against</param>
        /// <param name="policy">The policy to authenticate against. This is the site urlName for SSO but as this is being phased out, we're using
        /// the Identity terms</param>
        /// <returns>True if they are authenticated, false if not</returns>
        public bool AuthenticateUserFromCookies(string cookie, string secureCookie, string policy)
        {
            // Check to make sure we got a cookie
            if (cookie == "")
            {
                // no cookie, no entry!
                return false;
            }

            string decodedCookie = cookie;
            string decodedSecureCookie = secureCookie;
            if (_signInSystem == SignInSystem.Identity)
            {
                // BODGE!!! Make sure that the cookie is fully decoded.
                // Currently the cookie can come in from Forge double encoded.
                // Our tests are correct in encoding only the once.
                /*
                int i = 0;
                while (decodedCookie.IndexOfAny(new char[] { ' ', '/', '+' }) < 0 && i < 3)
                {
                    decodedCookie = HttpUtility.UrlDecode(decodedCookie);
                    i++;
                }

                i = 0;
                while (decodedSecureCookie.IndexOfAny(new char[] { ' ', '/', '+' }) < 0 && i < 3)
                {
                    decodedSecureCookie = HttpUtility.UrlDecode(decodedSecureCookie);
                    i++;
                }*/
            }
            Trace.WriteLine("AuthenticateUserFromCookie() - policy = " + policy);
            Trace.WriteLine("AuthenticateUserFromCookie() - cookie = " + decodedCookie);
            Trace.WriteLine("AuthenticateUserFromCookie() - secure cookie = " + decodedSecureCookie);
            _signInComponent.SetService(policy);

            bool userSet = false;
            if (_signInSystem == SignInSystem.SSO)
            {
                userSet = _signInComponent.TrySetUserViaCookie(decodedCookie);
            }
            else
            {
                //userSet = _signInComponent.TrySetUserViaCookieAndUserName(decodedCookie, identityUserName);
                userSet = _signInComponent.TrySecureSetUserViaCookies(decodedCookie, decodedSecureCookie);
            }

            if (!userSet)
            {
                // Not authenticated
                Trace.WriteLine("AuthenticateUserFromCookie() - Not logged in : " + _signInComponent.GetLastError());
                return false;
            }
            _signInUserID = _signInComponent.UserID;
            if (_signInComponent.DoesAttributeExistForService(policy, "legacy_user_id"))
            {
                int.TryParse(_signInComponent.GetUserAttribute("legacy_user_id"), out _legacySSOUserID);
            }

            _loginName = _signInComponent.LoginName;
            _userName = _loginName;
            if (_signInComponent.DoesAttributeExistForService(policy, "displayname"))
            {
                _userName = _signInComponent.GetUserAttribute("displayname");
            } 
            
            _email = _signInComponent.GetUserAttribute("email");
            if (_signInComponent.DoesAttributeExistForService(policy, "firstname"))
            {
                _firstName = _signInComponent.GetUserAttribute("firstname");
            }
            if (_signInComponent.DoesAttributeExistForService(policy, "lastnames"))
            {
                _lastNames = _signInComponent.GetUserAttribute("lastnames");
            }

            if (_signInComponent.DoesAttributeExistForService(policy, "lastupdated"))
            {
                DateTime.TryParse(_signInComponent.GetUserAttribute("lastupdated"), out _lastUpdatedDate);
            }

            _cookie = cookie;
            _secureCookie = secureCookie;

            return true;
        }

        /// <summary>
        /// Method for getting the auto generated username from the signin component if it exists
        /// </summary>
        /// <param name="isKidsSite">A flag to state that we're getting the name for a kids site</param>
        /// <returns>The name stored in the signin system or empty if it does not exist</returns>
        public string GetAutoGenNameFromSignInSystem(bool isKidsSite)
        {
            string siteSuffix = "";
            string attribNameSpace = "";
            string attribName = "";

            if (isKidsSite)
            {
                attribNameSpace = "cbbc";
                attribName = "cbbc_displayname";
            }

            if (_signInComponent.DoesAppNameSpacedAttributeExist(_cookie, attribNameSpace, attribName))
            {
                siteSuffix = _signInComponent.GetAppNameSpacedAttribute(_cookie, attribNameSpace, attribName);
            }

            return siteSuffix;
        }

        /// <summary>
        /// Authenticates a user via the username and password
        /// </summary>
        /// <param name="userName">The username to try and usthenticate</param>
        /// <param name="password">The password to authenticate with</param>
        /// <param name="policy">The policy to authenticate against. This is the site urlName for SSO but as this is being phased out, we're using
        /// the Identity terms</param>
        /// <returns>True if they are authenticated, false if not</returns>
        public bool AuthenticateUserFromUsernameAndPassword(string userName, string password, string policy)
        {
            _signInComponent.SetService(policy);
            if (!_signInComponent.TrySetUserViaUserNamePassword(userName, password))
            {
                return false;
            }

            _signInUserID = _signInComponent.UserID;
            _userName = _signInComponent.LoginName;
            return true;
        }

        /// <summary>
        /// This method is used to check if the current call was made securely, called with the IDENTITY-HTTPS cookie.
        /// </summary>
        /// <returns>True if it is, false if not</returns>
        public bool IsSecureRequest
        {
            get { return _signInComponent.IsSecureRequest; }
        }
    }
}
