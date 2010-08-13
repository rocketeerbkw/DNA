using System;
using System.Collections.Generic;
using System.Text;

namespace DnaIdentityWebServiceProxy
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
    /// The DNA Signin and Service Info Interface
    /// As we now have the option to sign in via both SSO and Identity, we need to use this
    /// instead of the ProfileAPI interface.
    /// </summary>
    public interface IDnaIdentityWebServiceProxy
    {
        /// <summary>
        /// Gets the type of signin system the object supports
        /// </summary>
        SignInSystem SignInSystemType { get; }

        /// <summary>
        /// Initialises the connection details for the web service
        /// </summary>
        /// <param name="connectionDetails">The url for the webservice</param>
        /// <param name="clientIPAddress">The IP address of the calling user</param>
        /// <returns>True if initialised, false if something went wrong</returns>
        bool Initialise(string connectionDetails, string clientIPAddress);

        /// <summary>
        /// Get property that states whether or not the user is logged in
        /// </summary>
        bool IsUserLoggedIn { get; }

        /// <summary>
        /// Get property that states whether or not the user is signed in
        /// </summary>
        bool IsUserSignedIn { get; }

        /// <summary>
        /// Checks to see if a given attribute exists for the given service
        /// </summary>
        /// <param name="service">The name of the service you want to check against</param>
        /// <param name="attributeName">The name of the attribute you want to check for</param>
        /// <returns>True if it does, false if not</returns>
        bool DoesAttributeExistForService(string service, string attributeName);

        /// <summary>
        /// Gets the given attribute for the current user
        /// </summary>
        /// <param name="attributeName">The name of the attribute you want to get</param>
        /// <returns>The value if it exists, empty if it doesn't</returns>
        string GetUserAttribute(string attributeName);

        /// <summary>
        /// Sets the service you want to log into or get info about
        /// </summary>
        /// <param name="serviceName">The name of the service you want to use</param>
        void SetService(string serviceName);

        /// <summary>
        /// Get property that states whether or not the service has been set
        /// </summary>
        bool IsServiceSet { get; }

        /// <summary>
        /// Tries to log a user in via their cookie
        /// </summary>
        /// <param name="cookieValue">The users cookie</param>
        /// <returns>True if they were logged in, false if not</returns>
        bool TrySetUserViaCookie(string cookieValue);

        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="userName">The username you want to sign in with</param>
        /// <param name="password">The password for the user</param>
        /// <returns>True if user was set correctly, false if not</returns>
        bool TrySetUserViaUserNamePassword(string userName, string password);
        
        /// <summary>
        /// Tries to set the user using their username and cookie
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="userName">The name of the user you are trying to set</param>
        /// <returns>True if user was set correctly, false if not</returns>
        bool TrySetUserViaCookieAndUserName(string cookie, string userName);

        /// <summary>
        /// Tries to set the user using their cookies (normal and secure)
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="secureCookie">The secure cookie value for the user</param>
        /// <returns>True if user was set correctly, false if not</returns>
        bool TrySecureSetUserViaCookies(string cookie, string secureCookie);

            /// <summary>
        /// Tries to log the user in with the details already set
        /// </summary>
        /// <returns>True if they were logged in, false if not</returns>
        bool LoginUser();

        /// <summary>
        /// Get property for the current user id
        /// </summary>
        string UserID { get; }

        /// <summary>
        /// Get property for the current users login name
        /// </summary>
        string LoginName { get; }

        /// <summary>
        /// Gets the min max ages for a given service
        /// </summary>
        /// <param name="serviceName">The name of the service you want to check against</param>
        /// <param name="minAge">reference to an int that will take the min age</param>
        /// <param name="maxAge">reference to an int that will take the max age</param>
        void GetServiceMinMaxAge(string serviceName, ref int minAge, ref int maxAge);

        /// <summary>
        /// Called to close any connections that might be open for the current object.
        /// </summary>
        void CloseConnections();

        /// <summary>
        /// Called to dispose of any allocated resources if any
        /// </summary>
        void Dispose();

        /// <summary>
        /// Gets the current users Identity cookie value
        /// </summary>
        string GetCookieValue { get; }

        /// <summary>
        /// Gets the current users secure Identity cookie value
        /// </summary>
        string GetSecureCookieValue { get; }

#if DEBUG
        /// <summary>
        /// Debugging feature for logging out users
        /// </summary>
        void LogoutUser();
#endif

        /// <summary>
        /// Gets the last known error as a string
        /// </summary>
        /// <returns>The error message</returns>
        string GetLastError();

        /// <summary>
        /// Gets the current list of all dna policies
        /// </summary>
        /// <returns>The list of dna policies</returns>
        string[] GetDnaPolicies();

        /// <summary>
        /// Returns the last piece of timing information
        /// </summary>
        /// <returns>The information for the last timed logging</returns>
        string GetLastTimingInfo();

        /// <summary>
        /// Gets the version number of the Interface
        /// </summary>
        /// <returns>The version number for this Interface</returns>
        string GetVersion();

        /// <summary>
        /// Gets the value of the given attribute from the given app name space in identity
        /// </summary>
        /// <param name="cookie">The users IDENTITY cookie</param>
        /// <param name="appNameSpace">The App Name Space the attribute lives in</param>
        /// <param name="attributeName">The attribute you want to get the value of</param>
        /// <returns>The value of the attribute</returns>
        string GetAppNameSpacedAttribute(string cookie, string appNameSpace, string attributeName);

        /// <summary>
        /// Checks to see if the requested attribute exists
        /// </summary>
        /// <param name="cookie">The users IDENTITY cookie</param>
        /// <param name="appNameSpace">The App Name space in which to check for the attribute</param>
        /// <param name="attributeName">The name of the attribute you want to check for</param>
        /// <returns>True if it exists, false if not</returns>
        bool DoesAppNameSpacedAttributeExist(string cookie, string appNameSpace, string attributeName);
        
        /// <summary>
        /// Get property that states whether or not the request is secure or not
        /// </summary>
        bool IsSecureRequest{ get; }
    }
}
