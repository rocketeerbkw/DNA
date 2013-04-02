using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Security.Principal;
using System.Text;
using System.Web;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// The DNA Request object. This class is used to provide a layer between DNA and the .NET Web request.
    /// It wraps all the required methods and properties that DNA requires. It also offers helper methods for common pieces of code.
    /// </summary>
    public class Request : IRequest
    {
        private HttpRequest _request;

        /// <summary>
        /// The Request constructor.
        /// </summary>
        /// <param name="request">The http request that you want to wrap</param>
        public Request(HttpRequest request)
        {
            _request = request;
        }

        /// <summary>
        /// The query string property
        /// </summary>
        public NameValueCollection QueryString
        {
            get { return _request.QueryString; }
        }

        /// <summary>
        /// The Raw Url property
        /// </summary>
        public string RawUrl
        {
            get { return _request.RawUrl.Trim(); }
        }
        
        /// <summary>
        /// The Form property
        /// </summary>
        public NameValueCollection Form
        {
            get { return _request.Form; }
        }
        
        /// <summary>
        /// The server variables property
        /// </summary>
        public NameValueCollection ServerVariables
        {
            get { return _request.ServerVariables; }
        }
        
        /// <summary>
        /// The Params property
        /// </summary>
        public NameValueCollection Params
        {
            get { return _request.Params; }
        }

        /// <summary>
        /// The Logon User Identity property
        /// </summary>
        public WindowsIdentity LogonUserIdentity
        {
            get { return _request.LogonUserIdentity; }
        }
        
        /// <summary>
        /// The param array property
        /// </summary>
        /// <param name="s">The name of the param you want to get the value for</param>
        /// <returns>The value of the named param if found</returns>
        public string this[string s]
        {
            get { return _request[s]; }
        }
        
        /// <summary>
        /// The cookies property
        /// </summary>
        public HttpCookieCollection Cookies
        {
            get { return _request.Cookies; }
        }

        /// <summary>
        /// The user agent property
        /// </summary>
        public string UserAgent
        {
            get { return _request.UserAgent.Trim(); }
        }

        /// <summary>
        /// This function is used to check to see if a given param exists
        /// </summary>
        /// <param name="paramName">The name of the param you want to check for</param>
        /// <param name="description">Description of the parameter, for documentation purposes</param>
        /// <returns>True if it exists or false if not</returns>
        public bool DoesParamExist(string paramName, string description)
        {
            return (_request[paramName] != null);
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
            if (DoesParamExist(paramName, description))
            {
                value = _request[paramName];
                return true;
            }
            return false;
        }

        /// <summary>
        /// Get a parameter value, or empty string if the parameter does not exist
        /// </summary>
        /// <param name="paramName">name of parameter to find</param>
        /// <param name="description">Description of parameter for documenation purposes</param>
        /// <returns>string value of parameter or empty string</returns>
        public string GetParamStringOrEmpty(string paramName, string description)
        {
            string retval = String.Empty;
            if (TryGetParamString(paramName, ref retval, description))
            {
                return retval.Trim();
            }
            else
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the named parameter from the query string or form data.
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="paramName">Name of paramter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>Integer value of parameter or zero if param doesn't exist</returns>
        public int GetParamIntOrZero(string paramName, string description)
        {
            int val = 0;
            if (Int32.TryParse(GetParamStringOrEmpty(paramName, description), out val))
            {
                return val;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// Gets the named parameter from the query string or form data.
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>Double value of parameter or zero if param doesn't exist</returns>
        public double GetParamDoubleOrZero(string paramName, string description)
        {
            double val = 0.0;
            if (Double.TryParse(GetParamStringOrEmpty(paramName, description), out val))
            {
                return val;
            }
            else
            {
                return 0.0;
            }
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
            if (DoesParamExist(paramName, description))
            {
                try
                {
                    return Convert.ToInt32(_request[paramName]);
                }
                catch
                {
                    return knownValue;
                }
            }
            return knownValue;
        }

        /// <summary>
        /// Counts the number of parameters of the given name in the request
        /// </summary>
        /// <param name="paramName">name of parameter to count</param>
        /// <param name="description">description of parameter for documentation purposes</param>
        /// <returns>Number of params</returns>
        public int GetParamCountOrZero(string paramName, string description)
        {
            if (_request[paramName] != null)
            {
                return _request.Params.GetValues(paramName).Length;
            }
            return 0;
        }

        /// <summary>
        /// Get one of multiple named parameters
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="index">index of parameter</param>
        /// <param name="description">description of parameter</param>
        /// <returns>value of parameter</returns>
        public string GetParamStringOrEmpty(string paramName, int index, string description)
        {
            if (_request[paramName] != null)
            {
                return _request.Params.GetValues(paramName).GetValue(index).ToString().Trim();
            }
            return string.Empty;
        }

        /// <summary>
        /// Returns a list of all the parameter names in the current query
        /// </summary>
        /// <returns>A list of strings with all the parameter names in the query</returns>
        public List<string> GetAllParamNames()
        {
            List<string> paramnames = new List<string>();
            foreach (string paramname in _request.Form)
            {
                if (paramname != null)
                {
                    paramnames.Add(paramname);
                }
            }
            foreach (string paramname in _request.QueryString)
            {
                if (paramname != null)
                {
                    paramnames.Add(paramname);
                }
            }
            return paramnames;
        }

        /// <summary>
        /// Returns the name value pairs of all the parameters in the current query that have the given prefix
        /// </summary>
        /// <param name="prefix"></param>
        /// <returns>A name value collection of all parameters in the query that have the given prefix</returns>
        public NameValueCollection GetAllParamsWithPrefix(string prefix)
        {
            NameValueCollection parameters = new NameValueCollection();
            foreach (string paramname in _request.Form)
            {
                if (paramname != null && paramname.StartsWith(prefix))
                {
                    parameters.Add(paramname, _request.Form[paramname]);
                }
            }
            foreach (string paramname in _request.QueryString)
            {
                if (paramname != null && paramname.StartsWith(prefix))
                {
                    parameters.Add(paramname, _request.QueryString[paramname]);
                }
            }
            return parameters;
        }

        /// <summary>
        /// Function for getting a given cookie
        /// </summary>
        /// <param name="cookieName">The name of the cookie that you want to get</param>
        /// <returns>The reference to our new DnaCookie or null if it could not be found</returns>
        public DnaCookie GetCookie(string cookieName)
        {
            if (_request.Cookies[cookieName] != null)
            {
                return new DnaCookie(_request.Cookies[cookieName]);
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Gets the URL Referrer.
        /// </summary>
        /// <returns>Uri of the referrer</returns>
        public Uri UrlReferrer
        {
            get { return _request.UrlReferrer; }
        }

        /// <summary>
        /// Get one of multiple named parameters
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="index">index of parameter</param>
        /// <param name="description">description of parameter</param>
        /// <returns>value of parameter</returns>
        public double GetParamDoubleOrZero(string paramName, int index, string description)
        {
            if (_request[paramName] != null)
            {
                DnaStringParser parser = new DnaStringParser(_request[paramName], new char[] { ',' }, true, false, false);
                ArrayList paramnames = parser.ParseToArrayList();
                if (paramnames.Count > index)
                {
                    double paramValue = 0.0;
                    Double.TryParse(paramnames[index].ToString(), out paramValue);
                    return paramValue;
                }
            }
            return 0.0;
        }
        /// <summary>
        /// Get one of multiple named parameters
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="index">index of parameter</param>
        /// <param name="description">description of parameter</param>
        /// <returns>value of parameter</returns>
        public int GetParamIntOrZero(string paramName, int index, string description)
        {
            if (_request[paramName] != null)
            {
                DnaStringParser parser = new DnaStringParser(_request[paramName], new char[] { ',' }, true, false, false);
                ArrayList paramnames = parser.ParseToArrayList();
                if (paramnames.Count > index)
                {
                    int paramValue = 0;
                    Int32.TryParse(paramnames[index].ToString(), out paramValue);
                    return paramValue;
                }
            }
            return 0;
        }

        /// <summary>
        /// Gets the named parameter from the query string or form data.
        /// If the parameter doesn't exist, this function returns zero
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="description">Description of what the parameter means. Used for auto documenation</param>
        /// <returns>bool value of parameter or zero if param doesn't exist</returns>
        public bool GetParamBoolOrFalse(string paramName, string description)
        {
            bool paramValue = false;
            string paramString = GetParamStringOrEmpty(paramName, description);
            bool.TryParse(paramString, out paramValue);

            if (paramValue || paramString == "1")
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        /// <summary>
        /// Get one of multiple named parameters
        /// </summary>
        /// <param name="paramName">Name of parameter</param>
        /// <param name="index">index of parameter</param>
        /// <param name="description">description of parameter</param>
        /// <returns>bool value of parameter</returns>
        public bool GetParamBoolOrFalse(string paramName, int index, string description)
        {
            if (_request[paramName] != null)
            {
                DnaStringParser parser = new DnaStringParser(_request[paramName], new char[] { ',' }, true, false, false);
                ArrayList paramnames = parser.ParseToArrayList();
                if (paramnames.Count > index)
                {
                    bool paramValue = false;
                    bool.TryParse(paramnames[index].ToString(), out paramValue);

                    paramValue = paramValue || paramnames[index].ToString() == "1";
                    
                    return paramValue;
                }
            }
            return false;
        }

        /// <summary>
        /// The Files property
        /// </summary>
        public HttpFileCollection Files
        {
            get { return _request.Files; }
        }



    }
}
