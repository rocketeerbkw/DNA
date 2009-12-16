using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Security.Principal;
using System.Text;
using System.Web;

namespace BBC.Dna.Utils
{
	/// <summary>
	/// The dna request Interface. Impliments all calls needed by DNA from the HttpRequest.
	/// </summary>
	public interface IRequest
	{
		/// <summary>
		/// The Query String property
		/// </summary>
		NameValueCollection QueryString { get; }

		/// <summary>
		/// The RawUrl property
		/// </summary>
		string RawUrl { get; }

		/// <summary>
		/// The Form property
		/// </summary>
        NameValueCollection Form { get; }

		/// <summary>
		/// The Server Variables property
		/// </summary>
        NameValueCollection ServerVariables { get; }

		/// <summary>
		/// The Params property
		/// </summary>
        NameValueCollection Params { get; }

		/// <summary>
		/// The Logon User Identity property
		/// </summary>
        WindowsIdentity LogonUserIdentity { get; }

		/// <summary>
		/// The array parameter property
		/// </summary>
		/// <param name="s">The name of the param you want to get the value for</param>
		/// <returns>The value of the named param if found</returns>
		string this[string s] { get; }

		/// <summary>
		/// The cookies property
		/// </summary>
        HttpCookieCollection Cookies { get; }

		/// <summary>
		/// The user agent property
		/// </summary>
        string UserAgent { get; }

        /// <summary>
        /// This function is used to check to see if a given param exists
        /// </summary>
        /// <param name="paramName">The name of the param you want to check for</param>
        /// <param name="description">Description of the parameter, for documentation purposes</param>
        /// <returns>True if it exists or false if not</returns>
        bool DoesParamExist(string paramName, string description);

        /// <summary>
        /// This function returns the value for a given param
        /// </summary>
        /// <param name="paramName">The name of the param you want to get that value for</param>
        /// <param name="value">reference string that will take the value</param>
        /// <param name="description">Description of the parameter, for documentation purposes</param>
        /// <returns>True if it exists, false if not</returns>
        bool TryGetParamString(string paramName, ref string value, string description);

        /// <summary>
        /// Get a parameter value, or empty string if the parameter does not exist
        /// </summary>
        /// <param name="paramName">name of parameter to find</param>
        /// <param name="description">Description of parameter for documenation purposes</param>
        /// <returns>string value of parameter or empty string</returns>
        string GetParamStringOrEmpty(string paramName, string description);

        /// <summary>
        /// Gets the named parameter from the query string or form data.
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="paramName">Name of paramter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>Integer value of parameter or zero if param doesn't exist</returns>
        int GetParamIntOrZero(string paramName, string description);

        /// <summary>
        /// Gets the named parameter from the query string or form data.
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="paramName">Name of paramter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>Double value of parameter or zero if param doesn't exist</returns>
        double GetParamDoubleOrZero(string paramName, string description);

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
        /// Gets a string array containing 
        /// </summary>
        /// <returns>A list of all the param names</returns>
        List<string> GetAllParamNames();

        /// <summary>
        /// Gets a specified DnaCookie.
        /// </summary>
        /// <param name="cookieName">Name of the cookie.</param>
        /// <returns>DnaCookie object.</returns>
        DnaCookie GetCookie(string cookieName);

        /// <summary>
        /// Gets the URL Referrer.
        /// </summary>
        /// <returns>Uri of the referrer</returns>
        Uri UrlReferrer { get; }

        /// <summary>
        /// Get one of multiple named parameters
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="index">index of parameter</param>
        /// <param name="description">description of parameter</param>
        /// <returns>value of parameter</returns>
        double GetParamDoubleOrZero(string paramName, int index, string description);

        /// <summary>
        /// Get one of multiple named parameters
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="index">index of parameter</param>
        /// <param name="description">description of parameter</param>
        /// <returns>value of parameter</returns>
        int GetParamIntOrZero(string paramName, int index, string description);

        /// <summary>
        /// Gets the named parameter from the query string or form data in bool format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>bool value of parameter or zero if param doesn't exist</returns>
        bool GetParamBoolOrFalse(string paramName, string description);

        /// <summary>
        /// Gets one of multiple named parameters from the query string or form data in bool format
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="index">Index of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>bool value of parameter or zero if param doesn't exist</returns>
        bool GetParamBoolOrFalse(string paramName, int index, string description);

        /// <summary>
        /// The Files property
        /// </summary>
        HttpFileCollection Files
        {
            get;
        }
        
        /// <summary>
        /// Returns the name value pairs of all the parameters in the current query that have the given prefix
        /// </summary>
        /// <param name="prefix"></param>
        /// <returns>A name value collection of all parameters in the query that have the given prefix</returns>
        NameValueCollection GetAllParamsWithPrefix(string prefix);


    }
}
