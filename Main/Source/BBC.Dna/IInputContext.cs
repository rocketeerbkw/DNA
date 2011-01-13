using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using System.Web;
using System.Configuration;
using System.Xml;
using BBC.Dna.Page;
using BBC.Dna.Component;
using DnaIdentityWebServiceProxy;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Interface that represents all aspects of a DNA request.
    /// </summary>
	public interface IInputContext : IAppContext
	{
        /// <summary>
        /// Gets the User object representing the viewing user.
        /// </summary>
		IUser ViewingUser
		{
			get;
		}

        /// <summary>
        /// Gets the Site object of the current site.
        /// </summary>
        ISite CurrentSite
        {
            get;
        }

        /// <summary>
        /// Gets the current dan request object
        /// </summary>
        IRequest CurrentDnaRequest
        {
            get;
        }

        /// <summary>
        /// 
        /// </summary>
        SkinSelector SkinSelector
        {
            get;
        }

		/// <summary>
		/// The browser or UserAgent for this request
		/// </summary>
		string UserAgent
		{
			get;
		}

		/// <summary>
		/// Puts a complete site list XML chunk in the page
		/// </summary>
		void AddAllSitesXmlToPage();

        /// <summary>
        /// Gets the given int site option for the current site
        /// <see cref="SiteOptionList.GetValueInt"/>
        /// </summary>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        int GetSiteOptionValueInt(string section, string name);

        /// <summary>
        /// Gets the given bool site option for the current site
        /// <see cref="SiteOptionList.GetValueInt"/>
        /// </summary>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        bool GetSiteOptionValueBool(string section, string name);

        /// <summary>
        /// Gets the given bool site option for the current site
        /// <see cref="SiteOptionList.GetValueString"/>
        /// </summary>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        string GetSiteOptionValueString(string section, string name);

        /// <summary>
        /// Get the current Signin object for this request. This could be either ProfileAPI or Identity web service
        /// depending on the sign in method for the site
        /// </summary>
        /// <returns>The current sign on object for the request</returns>
        IDnaIdentityWebServiceProxy GetCurrentSignInObject
        {
            get;
        }

        /// <summary>
        /// Gets an object out of the cache that matches the key, or null
        /// </summary>
        /// <param name="key">The key</param>
        /// <returns>The object, or null</returns>
        object GetCachedObject(string key);

        /// <summary>
        /// Caches the object under the given key, and will cache it for up to the number of seconds passed in.
        /// </summary>
        /// <param name="key">The key</param>
        /// <param name="o">The object</param>
        /// <param name="seconds">Number of seconds</param>
        void CacheObject(string key, object o, int seconds);

        /// <summary>
        /// Get a values indicating whether a parameter exists on the input context.
        /// </summary>
        /// <param name="paramName">Name of the parameter.</param>
        /// <param name="description">Description of the parameter for documentation purposes</param>
        /// <returns>true if the parameter exists, otherwise false.</returns>
        bool DoesParamExist(string paramName, string description);

        /// <summary>
        /// Gets the specified parameter as a string. Boolean return value indicates whether the parameter was found or not.
        /// </summary>
        /// <param name="paramName">Name of the parameter.</param>
        /// <param name="value">Reference to a string to receive the value</param>
        /// <param name="description">Description of the paramter for documentation purposes</param>
        /// <returns>bool if the parameter exists, otherwise false.</returns>
        bool TryGetParamString(string paramName, ref string value, string description);

        /// <summary>
        /// Tries to get the specified param as an int, or returns the "Known Value" if it fails.
        /// Alternative to the GetParamIntOrZero(...) Method if zero can be a valid value.
        /// </summary>
        /// <param name="paramName">The name of the param you want to get that value for</param>
        /// <param name="knownValue">The known value you want to return on failure</param>
        /// <param name="description">Description of the parameter, for documentation purposes</param>
        /// <returns>The parsed value, or the known value on failure</returns>
        int TryGetParamIntOrKnownValueOnError(string paramName, int knownValue, string description);

        /// <summary>
        /// Gets the specified parameter as a string. Empty string returned if the parameter doesn't exist.
        /// </summary>
        /// <param name="paramName">Name of the parameter.</param>
        /// <param name="description">Description of parameter for documentation purposes</param>
        /// <returns>string value of the parameter.</returns>
        string GetParamStringOrEmpty(string paramName, string description);

        /// <summary>
        /// Gets a specified DnaCookie.
        /// </summary>
        /// <param name="cookieName">Name of the cookie.</param>
        /// <returns>DnaCookie object.</returns>
        DnaCookie GetCookie(string cookieName);

        /// <summary>
        /// Gets the named parameter from the query string or form data.
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="name">Name of paramter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>Integer value of parameter or zero if param doesn't exist</returns>
        int GetParamIntOrZero(string name, string description);

        /// <summary>
        /// Gets a string array containing 
        /// </summary>
        /// <returns></returns>
        List<string> GetAllParamNames();

        /// <summary>
        /// Returns the name value pairs of all the parameters in the current query that have the given prefix
        /// </summary>
        /// <param name="prefix"></param>
        /// <returns>A name value collection of all parameters in the query that have the given prefix</returns>
        NameValueCollection GetAllParamsWithPrefix(string prefix);

        /// <summary>
        /// Counts the number of parameters of the given name in the request
        /// </summary>
        /// <param name="paramName">name of parameter to count</param>
        /// <param name="description">description of parameter for documentation purposes</param>
        /// <returns>Number of params</returns>
        int GetParamCountOrZero(string paramName, string description);

        /// <summary>
        /// Get one of multiple named parameters
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="index">index of parameter</param>
        /// <param name="description">description of parameter</param>
        /// <returns>value of parameter</returns>
        string GetParamStringOrEmpty(string paramName, int index, string description);

        /// <summary>
        /// Gets whether the current site is a messageboard
        /// </summary>
        bool IsCurrentSiteMessageboard
        {
            get;
        }

        /// <summary>
        /// Gets the named parameter from the query string or form data in double format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="name">Name of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>Double value of parameter or zero if param doesn't exist</returns>
        double GetParamDoubleOrZero(string name, string description);

        /// <summary>
        /// Gets one of multiple named parameters from the query string or form data in double format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="name">Name of parameter</param>
        /// <param name="index">Index of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>Double value of parameter or zero if param doesn't exist</returns>
        double GetParamDoubleOrZero(string name, int index, string description);
        
        /// <summary>
        /// Gets one of multiple named parameters from the query string or form data in int format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="name">Name of parameter</param>
        /// <param name="index">Index of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>Integer value of parameter or zero if param doesn't exist</returns>
        int GetParamIntOrZero(string name, int index, string description);

        /// <summary>
        /// Gets the named parameter from the query string or form data in bool format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="name">Name of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>bool value of parameter or zero if param doesn't exist</returns>
        bool GetParamBoolOrFalse(string name, string description);

        /// <summary>
        /// Gets one of multiple named parameters from the query string or form data in bool format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="name">Name of parameter</param>
        /// <param name="index">Index of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>bool value of parameter or zero if param doesn't exist</returns>
        bool GetParamBoolOrFalse(string name, int index, string description);

		/// <summary>
		/// The IP address for this request
		/// </summary>
		string IpAddress
		{
			get;
		}

		/// <summary>
		/// UID extracted from the BBC-UID cookie on this request
		/// </summary>
		Guid BBCUid
		{
			get;
		}

        /// <summary>
        /// Returns a formed siteURL
        /// </summary>
        /// <param name="siteid">Site id</param>
        /// <returns>Returned site url</returns>
        string GetSiteRoot(int siteid);

        /// <summary>
        /// Sends a DNA System Message
        /// </summary>
        /// <param name="sendToUserID">User id to send the system message to</param>
        /// <param name="siteID">Site ID involved</param>
        /// <param name="messageBody">Body of the SYstem Message</param>
        void SendDNASystemMessage(int sendToUserID, int siteID, string messageBody);

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
        void SendMailOrSystemMessage(string email, string subject, string body, string fromAddress, string fromName, bool insertLineBreaks, int userID, int siteID);
 
        /// <summary>
        /// Is secure request i.e has IDENTITY-HTTPS cookie
        /// </summary>
        bool IsSecureRequest
        {
            get;
            set;
        }

        /// <summary>
        /// Returns if in preview mode
        /// </summary>
        /// <returns></returns>
        bool IsPreviewMode();
    }
}
