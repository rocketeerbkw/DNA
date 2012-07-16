using System;
using System.Net;

namespace DnaIdentityWebServiceProxy
{
    /// <summary>
    /// The ProfileAPI class that is used to connect to the SSO Database to check the users details
    /// </summary>
    public partial class ProfileAPI : IDnaIdentityWebServiceProxy, IDisposable
    {
        /// <summary>
        /// This property tell the caller that it uses profile api and sso
        /// </summary>
        public SignInSystem SignInSystemType
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// Basic Is Service Set property
        /// </summary>
        public bool IsServiceSet
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// Basic Is Secure request property
        /// </summary>
        public bool IsSecureRequest
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// Basic Is user logged in property
        /// </summary>
        public bool IsUserLoggedIn
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// Basic Is user signed in property
        /// </summary>
        public bool IsUserSignedIn
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// Login name property (distinct from the DNA username).
        /// </summary>
        public string LoginName
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// User Id property
        /// </summary>
        public int SSOUserID
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }
        /// <summary>
        /// User Id string property
        /// </summary>
        public string UserID
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="ProfileAPIReadConnectionDetails">The connection details for the profileAPI to connect with</param>
        /// <exception cref="ProfileAPIConnectionDetailsException">Cannot find one of the connection details needed</exception>
        public ProfileAPI(string ProfileAPIReadConnectionDetails)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// The dispose function
        /// </summary>
        public void Dispose()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Initialises the connection details for the web service
        /// </summary>
        /// <param name="connectionDetails">The url for the webservice</param>
        /// <param name="clientIPAddress">The IP address of the calling user</param>
        /// <returns>True if initialised, false if something went wrong</returns>
        public bool Initialise(string connectionDetails, string clientIPAddress)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        private void SetLastError(string error)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Sets the current service that you want to use
        /// </summary>
        /// <param name="serviceName">The name of the service that you want to use</param>
        /// <exception cref="ProfileAPIDataReaderException">The datareader was null or empty of results</exception>
        public void SetService(string serviceName)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Helper function for getting a services min and max age
        /// </summary>
        /// <param name="serviceName">The urlname of the service you wnat to get the inof for</param>
        /// <param name="minAge">A reference to the field that will take the min age for the service</param>
        /// <param name="maxAge">A reference to the field that will take the max age for the service</param>
        /// <exception cref="ProfileAPIDataReaderException">Thrown if there was a sql reader problem</exception>
        public void GetServiceMinMaxAge(string serviceName, ref int minAge, ref int maxAge)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Set the current user via their cookie value
        /// </summary>
        /// <param name="userCookie">The users cookie</param>
        /// <returns>True if they were set corrctly, false if not</returns>
        /// <exception cref="ProfileAPIServiceException">The service was not set</exception>
        /// <exception cref="ProfileAPIDataReaderException">One of the Sql requests returned a null reader or no results</exception>
        public bool TrySetUserViaCookie(string userCookie)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="userName">The username you want to sign in with</param>
        /// <param name="password">The password for the user</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaUserNamePassword(string userName, string password)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }
        
        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="userName">The name of the user you are trying to set</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaCookieAndUserName(string cookie, string userName)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Tries to set the user using their username, normal cookie and secure cookie
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="secureCookie">The secure cookie value for the user</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySecureSetUserViaCookies(string cookie, string secureCookie)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Validates the user cookie
        /// </summary>
        /// <returns>True if they validated, false if not</returns>
        /// <param name="cookieValidationMark">The cookie validation flag taken from the cookie</param>
        private bool ValidateUser(string cookieValidationMark)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Cookie decrypting and validation
        /// </summary>
        /// <returns>True if we decyphered cookie and it amtches the one passed in via the URL, false if not</returns>
        /// <param name="cookieValidationMark">The cookie validation mark from the current cookie</param>
        private bool DecypherCookie(ref string cookieValidationMark)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Calculates and returns a cookie for the current user
        /// </summary>
        /// <param name="remeberUser">A flag that states whether to remember the user</param>
        /// <param name="cookieValidationMark">Validation mark taken from the SSO2_UID</param>
        /// <returns>The cookie value for the current user and settings, Empty string if something went wrong</returns>
        private string ValidateCookie(char remeberUser, string cookieValidationMark)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Checks the database to see if the user is currently logged in (NOT signed in!)
        /// </summary>
        /// <returns>true if logged in, false if not</returns>
        /// <exception cref="ProfileAPIServiceException">The service has not been set</exception>
        /// <exception cref="ProfileAPIDataReaderException">The Sql request returned a null datareader, was empty or failed to read the results</exception>
        /// <exception cref="ProfileAPIUserException">Thrown if the user isn't signed in</exception>
        private bool GetIsUserLoggedIn()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Logs the user out of the given service
        /// </summary>
        /// <exception cref="ProfileAPIDataReaderException">Thrown if there was a database problem</exception>
        public void LogoutUser()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Sets the server cookie for testing
        /// </summary>
        /// <param name="cookie">The cookie for the identity server</param>
        public void SetIdentityServerCookie(Cookie cookie)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Logs the current user into the current service
        /// </summary>
        /// <returns>True if they were logged in, false if not</returns>
        /// <exception cref="ProfileAPIServiceException">Thrown when the service is not set</exception>
        /// <exception cref="ProfileAPIUserException">Thrown for one of the following reasons...\n
        /// Not signed in.\n
        /// Not in the age range for the service.\n
        /// Not registered for the service.\n
        /// Failed to fill in all mandatory service attribute.\n
        /// One or more attribute have not been validated.\n
        /// Password has been blocked.\n
        /// Has been banned for the site.</exception>
        /// <exception cref="ProfileAPIDataReaderException">Thrown if there was a database problem</exception>
        public bool LoginUser()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Checks to see if the user is able to log into the current service
        /// </summary>
        /// <returns>True if they can, false if not</returns>
        public bool CanUserLogIntoService()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Checks to see if the current user can log into the given service
        /// </summary>
        /// <returns>True if they are register, false if not</returns>
        private bool IsUserRegisteredWithService()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Check to see if the users age is within the services age range
        /// </summary>
        /// <returns>True if they are, false if not</returns>
        private bool IsUserInAgeRangeForService()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Checks to make sure the user has filled in all the mandatory attribute for the current service.
        /// </summary>
        /// <returns>True if they are, false if not</returns>
        private bool AreManditoryServiceAttributesSet()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Check to see if the user has had all the manditory details validated for the current service
        /// </summary>
        /// <returns>True if they are, false if not</returns>
        private bool AreUsersDetailsValidatedForService()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Checks to see if the user has their password blocked. Throws a User password blocked exception
        /// </summary>
        /// <returns>True if it is, false if not</returns>
        /// <exception cref="ProfileAPIUserException">The users password is blocked</exception>
        private bool IsUserPasswordBlocked()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Checks to see if the user needs to change their password
        /// </summary>
        /// <returns>True if they do, false if not</returns>
        private bool DoesUserNeedToChangePassword()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Checks to make sure that use is not banned for the service or outright
        /// </summary>
        /// <returns>True if they are, false if not</returns>
        private bool IsUserBannedforService()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Function for checking if a given service supports a given attribute
        /// </summary>
        /// <param name="serviceName">The name of the service you want to check against</param>
        /// <param name="attribute">The name of the attribute you want to check for</param>
        /// <returns>True if the attrbite exists, false if not</returns>
        /// <exception cref="ProfileAPIServiceException">The service has not been set</exception>
        /// <exception cref="ProfileAPIDataReaderException">The Sql request returned a null datareader</exception>
        public bool DoesAttributeExistForService(string serviceName, string attribute)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Gets a given user attribute for the current service
        /// </summary>
        /// <param name="attributeName">The name of the attribute that you want to get</param>
        /// <returns>The value if found</returns>
        /// <exception cref="ProfileAPIServiceException">The service has not been set</exception>
        /// <exception cref="ProfileAPIUserException">The user has not signed in yet</exception>
        /// <exception cref="ProfileAPIDataReaderException">The Sql request returned a null datareader, was empty or failed to read the results</exception>
        public string GetUserAttribute(string attributeName)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Gets the requested attribute for the current user, or null if the attribute does not exist
        /// </summary>
        /// <param name="attributeName">The sttribute that you want to find</param>
        /// <returns>The value of the attribute or null if not found</returns>
        /// <exception cref="ProfileAPIServiceException">The service has not been set</exception>
        /// <exception cref="ProfileAPIUserException">The user has not signed in yet</exception>
        /// <exception cref="ProfileAPIDataReaderException">The Sql request returned a null datareader</exception>
        private string GetUserAttributeOrNullIfNotExists(string attributeName)
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Get the users cookie value
        /// </summary>
        public string GetCookieValue
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// Get the users secure cookie value
        /// </summary>
        public string GetSecureCookieValue
        {
            get { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
        }

        /// <summary>
        /// Gets the last known error
        /// </summary>
        /// <returns>The error message</returns>
        public string GetLastError()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Gets the current list of all dna policies
        /// </summary>
        /// <returns>The list of dna policies, or null if non found</returns>
        public string[] GetDnaPolicies()
        {
            // This is an Identity only feature, but the class must support the interface.
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// Gets the version number of the Interface
        /// </summary>
        /// <returns>The version number for this Interface</returns>
        public string GetVersion()
        {
            return "1.0.1.6 (ProfileAPI)";
        }
        /// <summary>
        /// Gets the value of the given attribute from the given app name space in identity
        /// </summary>
        /// <param name="cookie">The users IDENTITY cookie</param>
        /// <param name="appNameSpace">The App Name Space the attribute lives in</param>
        /// <param name="attributeName">The attribute you want to get the value of</param>
        /// <returns>The value of the attribute</returns>
        public string GetAppNameSpacedAttribute(string cookie, string appNameSpace, string attributeName) { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }

        /// <summary>
        /// Checks to see if the requested attribute exists
        /// </summary>
        /// <param name="cookie">The users IDENTITY cookie</param>
        /// <param name="appNameSpace">The App Name space in which to check for the attribute</param>
        /// <param name="attributeName">The name of the attribute you want to check for</param>
        /// <returns>True if it exists, false if not</returns>
        public bool DoesAppNameSpacedAttributeExist(string cookie, string appNameSpace, string attributeName) { throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity."); }
    }
}
